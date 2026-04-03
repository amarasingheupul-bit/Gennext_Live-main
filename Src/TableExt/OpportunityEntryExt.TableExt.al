tableextension 50109 OpportunityEntryExt extends "Opportunity Entry"
{
    fields
    {
        field(50100; ActivityAssign; Code[20])
        {
            Caption = 'Activity Assign';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
        field(50101; "Shortcut Dimension 1 Lookup"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Job."Global Dimension 1 Code" where("No." = field("Opportunity No.")));
        }
    }
}
