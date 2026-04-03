pageextension 50150 "4HC SalesOrderArchiveSubform" extends "Sales Order Archive Subform"
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