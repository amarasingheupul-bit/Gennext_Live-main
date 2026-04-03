pageextension 50138 "Purchase Order" extends Microsoft.Purchases.Document."Purchase Order"
{
    layout
    {
        addafter(BuyFromContactPhoneNo)
        {
            field("Tax Liable56926"; Rec."Tax Liable")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Tax Area Code84296"; Rec."Tax Area Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addlast(General)
        {
            field("Sales Order No. 4HC"; Rec."Sales Order No. 4HC")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Sales Order No.';
                Importance = Additional;
                Editable = false;
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        BC4HC: Codeunit "4HC Business Central";
    begin
        Rec."Gennext Create By User" := BC4HC.GetCurrentLoginUser();
    end;
}
