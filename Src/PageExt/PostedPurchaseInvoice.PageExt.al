pageextension 50149 "4HC Posted Purchase Invoice" extends "Posted Purchase Invoice"
{
    layout
    {
        addlast(General)
        {

            field("Sales Order No. 4HC"; Rec."Sales Order No. 4HC")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order No. field.';
            }
        }
    }
}