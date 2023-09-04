/*An Angular implementation of the  d3noob's Collapsible tree diagram in v5 
 see:https://gist.github.com/d3noob/1a96af738c89b88723eb63456beb6510
  under The MIT License. https://opensource.org/licenses/MIT
  */

import {
  Component,
  AfterViewInit,
  Input,
  ElementRef,
  ViewChild,
} from '@angular/core';
import { fromEvent } from 'rxjs';
import { map, tap, startWith, debounceTime } from 'rxjs/operators';
import * as d3 from 'd3';

@Component({
  selector: 'd3noob-collapsible-tree',
  template: `<div #wrapper [style.font-size]='fontSize|async' class='wrapper' id='d3noob'><span #marginDiv class='fade'>{{treeData?.name}}</span></div>`,
  styles: [
    `.wrapper{
    position:relative;
    max-width:960px;
    margin-left:auto;
    margin-right:auto;
  }
  .fade{
    display:inline-block;
    border:1px solid black;
    position:absolute;
    visibility:hidden;
  }
`,
  ],
})
export class D3noobCollapsibleTreeComponent implements AfterViewInit {
  @Input() treeData: any = {};

  @Input() duration = 750;

  @ViewChild('marginDiv') marginDiv: ElementRef;
  @ViewChild('wrapper') wrapper: ElementRef;
  margin = { top: 0, right: 30, bottom: 0, left: 30 };
  width: number;
  height: number;
  svg: any;
  root: any;

  //  duration = d3.event && d3.event.altKey ? 500 : 500;
  i = 0;
  treemap: any;
  fontSize = fromEvent(window, 'resize').pipe(
    startWith(null),
    map((_) => {
      let size=this.wrapper?this.wrapper.nativeElement.getBoundingClientRect().width:window.innerWidth
      return size?(14 * 960) / size + 'px':'14px'
    }),
    tap((_) => {
      setTimeout(() => {
        const inc = this.marginDiv.nativeElement.getBoundingClientRect().width;
        this.svg.attr(
          'transform',
          'translate(' + (this.margin.left + inc) + ',' + this.margin.top + ')'
        );
      });
    })
  );
  constructor(private el: ElementRef) {}
  ngAfterViewInit(): void {
    const inc = this.marginDiv.nativeElement.getBoundingClientRect().width;
    (this.width = 960 - inc - this.margin.left - this.margin.right),
      (this.height = 500 - this.margin.top - this.margin.bottom);

    this.svg = d3
      .select('#d3noob')
      .append('svg')
      .attr('viewBox', '0 0 960 500')
      .append('g')
      .attr(
        'transform',
        'translate(' + (this.margin.left + inc) + ',' + this.margin.top + ')'
      );

    // declares a tree layout and assigns the size
    this.treemap = d3.tree().size([this.height, this.width]);

    // Assigns parent, children, height, depth
    this.root = d3.hierarchy(this.treeData, (d: any) => {
      return d.children;
    });

    this.root.x0 = this.height / 2;
    this.root.y0 = 0;
    // Collapse after the second level
    this.root.children.forEach((d: any) => {
      this.collapse(d);
    });

    this.update(this.root);
  }

  update(source: any) {
    // Assigns the x and y position for the nodes
    const treeData = this.treemap(this.root);

    // Compute the new tree layout.
    const nodes = treeData.descendants();
    const links = treeData.descendants().slice(1);

    // Normalize for fixed-depth.
    nodes.forEach((d: any) => {
      d.y = d.depth * 180;
    });

    // ****************** Nodes section ***************************

    // Update the nodes...
    const node = this.svg.selectAll('g.node').data(nodes, (d: any) => {
      return d.id || (d.id = ++this.i);
    });

    // Enter any new modes at the parent's previous position.
    const nodeEnter = node
      .enter()
      .append('g')
      .attr('class', 'node')
      .attr('transform', (d: any) => {
        return 'translate(' + source.y0 + ',' + source.x0 + ')';
      })
      .on('click', (_, d) => this.click(d));

    // Add Circle for the nodes
    nodeEnter
      .append('circle')
      .attr('class', (d: any) => (d._children ? 'node fill' : 'node'))
      .attr('r', 1e-6);
    // Add labels for the nodes
    nodeEnter
      .append('text')
      .attr('text-rendering','optimizeLegibility')
      .attr('dy', '.35em')

      .attr('x', (d) => {
        return d.children || d._children ? -13 : 13;
      })
      .attr('text-anchor', (d: any) => {
        return d.children || d._children ? 'end' : 'start';
      })
      .text((d) => {
        return d.data.name;
      });
    // UPDATE
    const nodeUpdate = nodeEnter.merge(node);

    // Transition to the proper position for the node
    nodeUpdate
      .transition()
      .duration(this.duration)
      .attr('transform', (d: any) => {
        return 'translate(' + d.y + ',' + d.x + ')';
      });

    // Update the node attributes and style
    nodeUpdate
      .select('circle.node')
      .attr('r', 10)
      .attr('class', (d: any) => (d._children ? 'node fill' : 'node'))
      .attr('cursor', 'pointer');

    // Remove any exiting nodes
    const nodeExit = node
      .exit()
      .transition()
      .duration(this.duration)
      .attr('transform', (d: any) => {
        return 'translate(' + source.y + ',' + source.x + ')';
      })
      .remove();

    // On exit reduce the node circles size to 0
    nodeExit.select('circle').attr('r', 1e-6);

    // On exit reduce the opacity of text labels
    nodeExit.select('text').style('fill-opacity', 1e-6);

    // ****************** links section ***************************

    // Update the links...
    const link = this.svg.selectAll('path.link').data(links, (d: any) => {
      return d.id;
    });

    // Enter any new links at the parent's previous position.
    const linkEnter = link
      .enter()
      .insert('path', 'g')
      .attr('class', 'link')
      .attr('d', (d: any) => {
        const o = { x: source.x0, y: source.y0 };
        return this.diagonal(o, o);
      });

    // UPDATE
    const linkUpdate = linkEnter.merge(link);

    // Transition back to the parent element position
    linkUpdate
      .transition()
      .duration(this.duration)
      .attr('d', (d: any) => {
        return this.diagonal(d, d.parent);
      });

    // Remove any exiting links
    const linkExit = link
      .exit()
      .transition()
      .duration(this.duration)
      .attr('d', (d: any) => {
        const o = { x: source.x, y: source.y };
        return this.diagonal(o, o);
      })
      .remove();

    // Store the old positions for transition.
    nodes.forEach((d: any) => {
      d.x0 = d.x;
      d.y0 = d.y;
    });
  }

  collapse(d: any) {
    if (d.children) {
      d._children = d.children;
      d._children.forEach((d: any) => this.collapse(d));
      d.children = null;
    }
  }

  click(d: any) {
    if (d.children) {
      d._children = d.children;
      d.children = null;
    } else {
      d.children = d._children;
      d._children = null;
    }
    this.update(d);
  }

  diagonal(s: any, d: any) {
    const path = `M ${s.y} ${s.x}
            C ${(s.y + d.y) / 2} ${s.x},
              ${(s.y + d.y) / 2} ${d.x},
              ${d.y} ${d.x}`;

    return path;
  }
}
