pageextension 50151 "4HC SalesQuoteArchiveSubform" extends "Sales Quote Archive Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the field of unit cose';
            }
        }
    }
}