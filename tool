1. Create a Tooltip Element
Add a hidden div to serve as the tooltip. This should be placed within your Angular component's ngAfterViewInit method:​

typescript
Copy
Edit
const tooltip = d3.select('body')
  .append('div')
  .attr('class', 'tooltip')
  .style('position', 'absolute')
  .style('background', '#fff')
  .style('padding', '6px')
  .style('border', '1px solid #ccc')
  .style('border-radius', '4px')
  .style('pointer-events', 'none')
  .style('opacity', 0);
This div will display the tooltip content and is initially hidden by setting its opacity to 0.​

2. Attach Tooltip Events to Nodes
Within your update method, after appending circles to the nodes, add event listeners for mouseover, mousemove, and mouseout to handle the tooltip display:​

typescript
Copy
Edit
nodeEnter
  .append('circle')
  .attr('class', (d: any) => (d._children ? 'node fill' : 'node'))
  .attr('r', 1e-6)
  .on('mouseover', function(event, d) {
    tooltip.transition()
      .duration(200)
      .style('opacity', 0.9);
    tooltip.html(d.data.name)
      .style('left', (event.pageX + 10) + 'px')
      .style('top', (event.pageY - 28) + 'px');
  })
  .on('mousemove', function(event) {
    tooltip
      .style('left', (event.pageX + 10) + 'px')
      .style('top', (event.pageY - 28) + 'px');
  })
  .on('mouseout', function() {
    tooltip.transition()
      .duration(500)
      .style('opacity', 0);
  });
This code displays the tooltip with the node's name when hovered over and positions it near the cursor. The tooltip fades in on hover and fades out when the cursor leaves the node.​

3. Implement Double-Click Alert
To trigger an alert on double-clicking a node, add a dblclick event listener to the node group (g element):​

typescript
Copy
Edit
nodeEnter
  .on('click', (_, d) => this.click(d))
  .on('dblclick', function(event, d) {
    alert('Double-clicked on node: ' + d.data.name);
  });
This will display an alert box showing the name of the node that was double-clicked.​

4. Style the Tooltip
Ensure you have appropriate CSS to style the tooltip. You can add the following styles to your component's styles:​

css
Copy
Edit
.tooltip {
  position: absolute;
  text-align: center;
  width: auto;
  padding: 6px;
  font: 12px sans-serif;
  background: #fff;
  border: 1px solid #ccc;
  border-radius: 4px;
  pointer-events: none;
  opacity: 0;
}
This CSS ensures the tooltip has a white background, rounded corners, and is hidden by default.​

By following these steps, you will enhance your D3.js collapsible tree diagram with interactive tooltips on each node and an alert on double-clicking a node.


Sources







