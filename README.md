import { Component, OnInit } from '@angular/core';
import {
  AngularGridInstance,
  Aggregators,
  Column,
  FieldType,
  Filters,
  Formatters,
  GridOption,
  GroupTotalFormatters,
  SortDirectionNumber,
  Sorters
} from 'angular-slickgrid';

// create a custom Formatter to highlight negative values in red
// let columnsWithHighlightingById = {};
// const highlightingFormatter = (row, cell, value, columnDef, dataContext) => {
//   if (columnsWithHighlightingById && columnsWithHighlightingById[columnDef.id] && value < 0) {
//     return `<div style="color:red; font-weight:bold;">${value}</div>`;
//   } else {
//     return value;
//   }
// };

@Component({
  selector: 'app-grid-three',
  templateUrl: './grid-three.component.html',
  styleUrls: ['./grid-three.component.css']
})
export class GridThreeComponent implements OnInit {





  constructor() { }

  columnDefinitions: Column[];
  gridOptions: GridOption;
  dataset: any[];
  gridObj: any;
  dataviewObj: any;
  visibleColumns: Column[];

  ngOnInit(): void {
    this.columnDefinitions = [];
    this.gridOptions = {
      enableAutoResize: true,
      enableHeaderButton: true,
      enableHeaderMenu: false,
      enableGrouping: true,
      // autoResize: {
      //   containerId: 'demo-container',
      //   sidePadding: 15
      // },
      //enableFiltering: false,
      //enableCellNavigation: true,
      headerButton: {
        onCommand: (e, args) => {
          const column = args.column;
          const button = args.button;
          const command = args.command;
          console.log('column', column)
          this.addToGroup(column.name);
          // if (!columnsWithHighlightingById) {
          //   columnsWithHighlightingById = {};
          // }

          // if (command === 'toggle-highlight') {
          //   if (button.cssClass === 'fa fa-circle red') {
          //     delete columnsWithHighlightingById[column.id];
          //     button.cssClass = 'fa fa-circle-o red faded';
          //     button.tooltip = 'Highlight negative numbers.';
          //   } else {
          //     columnsWithHighlightingById[column.id] = true;
          //     button.cssClass = 'fa fa-circle red';
          //     button.tooltip = 'Remove highlight.';
          //   }

          //   this.gridObj.invalidate();
          // }
        }
      }
    };

    this.getData();
  }

  ngOnDestroy() {
    //columnsWithHighlightingById = null;
  }

  getData() {
    // Set up some test columns.
    for (let i = 0; i < 5; i++) {
      this.columnDefinitions.push({
        id: i,
        name: 'Column' + (i + 1),
        field: i + '',
        width: 100, // have the 2 first columns wider
        sortable: true,
        //formatter: highlightingFormatter,
        // header: {
        //   buttons: [
        //     {
        //       cssClass: 'fa fa-circle-o red faded',
        //       command: 'toggle-highlight',
        //       tooltip: 'Highlight negative numbers.'
        //     }
        //   ]
        // }
      });
    }

    this.columnDefinitions.forEach(a => {

      a.header = {
        buttons: [
          {
            cssClass: 'fa fa-object-group',
            showOnHover: true,
            tooltip: 'This button only appears on hover.',
            command: 'kool',
            handler: (e) => {
              // console.log(e)
            }
          }
        ]
      }

    });



    // mock a dataset
    const mockDataset = [];
    for (let i = 0; i < 100; i++) {
      const d = (mockDataset[i] = {});
      d['id'] = i;
      for (let j = 0; j < this.columnDefinitions.length; j++) {
        d[j] = Math.round(Math.random() * 10) - 5;
      }
    }
    this.dataset = mockDataset;
  }

  groupedItems: string[] = [];

  addToGroup(item: string) {
    this.groupedItems.push(item);
    this.groupItems();
  }

  removeFromGroup(index: number) {
    this.groupedItems.splice(index, 1);
  }
  private groups: any[] = [];
  groupItems() {
    this.groupedItems.forEach(a => {

      this.groups.push({
        getter: a,
        formatter: (g) => {
          return `XXX:  ${g.value}  <span style="color:green">(${g.count} items)</span>`;
        },
        aggregators: [
          new Aggregators.Sum(a)
          
        ],
        aggregateCollapsed: true,
        lazyTotalsCalculation: true
      })

    });
    this.dataviewObj.setGrouping(this.groups);
  }

  clearGrouping() {
    this.dataviewObj.setGrouping([]);
  }

  gridReady(grid) {
    this.gridObj = grid;
  }
  dataviewReady(dataview) {
    this.dataviewObj = dataview;
  }

}
