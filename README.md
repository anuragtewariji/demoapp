

import { Component } from '@angular/core';

@Component({
  selector: 'my-app',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
})
export class AppComponent {
  name = 'Angular D3 Tree ';

  treeData = {
    name: 'Top Level',
    children: [
      {
        name: 'Level 2: A',
        children: [
          { name: 'Son of A' },
          { name: 'Daughter of A' },
          { name: 'Daughter of X' ,children:[{name:'Son of X'},{name:'Daugther of X'}]},
        ],
      },
      {
        name: 'Level 2: B',
        children: [
          {
            name: 'Son of B',children:[{name:'Son of X'},{name:'Daugther of X'}]
          },
          { name: 'Son of D' },
        ],
      },
    ],
  };

  
}
