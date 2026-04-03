pageextension 50121 "4HC Sales Invoice" extends "Sales Invoice"
{
    InsertAllowed = false;

    layout
    {
        addlast(General)
        {
            field("Tax Area Code"; Rec."Tax Area Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
            }
            field("Purchase Order No. 4HC"; Rec."Purchase Order No. 4HC")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purchase Order No. field.';
            }
        }

    }
}

