pageextension 50113 OpportunitySubformExt extends "Opportunity Subform"
{
    layout
    {
        addafter("Sales Cycle Stage Description")
        {
            field(ActivityAssign; Rec.ActivityAssign)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Activity Assign field.';
                TableRelation = "Salesperson/Purchaser";
            }
        }
        modify("Action Taken")
        {
            Visible = false;
        }
    }
}
