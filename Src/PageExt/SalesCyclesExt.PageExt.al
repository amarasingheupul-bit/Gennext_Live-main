pageextension 50119 SalesCyclesExt extends "Sales Cycles"
{
    layout
    {
        addlast(Control1)
        {
            field(SolutionPillarEditable; Rec.SolutionPillarEditable)
            {
                ApplicationArea = All;
            }
        }
    }
}
