
<div class="container">
    <div class="col-sm-12">
        <angular-slickgrid gridId="grid2" (onDataviewCreated)="dataviewReady($event)" (onGridCreated)="gridReady($event)"
            [columnDefinitions]="columnDefinitions" [gridOptions]="gridOptions" [dataset]="dataset"   gridHeight="400"
                gridWidth="100%">
        </angular-slickgrid>
    </div>
</div>
