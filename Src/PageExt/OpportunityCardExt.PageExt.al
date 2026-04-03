pageextension 50114 OpportunityCardExt extends "Opportunity Card"
{
    layout
    {
        addlast(General)
        {
            field("Estimated GP"; Rec."Estimated GP")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Estimated GP field.';
                Importance = Promoted;
            }
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field(solutionPillar; Rec.solutionPillar)
            {
                ApplicationArea = All;
                Editable = SolutionPillarEdit;
            }
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
    }
    trigger OnAfterGetRecord()
    var
        SalesCycle: Record "Sales Cycle";
    begin
        if SalesCycle.Get(Rec."Sales Cycle Code") then
            if SalesCycle.SolutionPillarEditable then
                SolutionPillarEdit := true
            else
                SolutionPillarEdit := false;
    end;

    var
        SolutionPillarEdit: Boolean;
}
