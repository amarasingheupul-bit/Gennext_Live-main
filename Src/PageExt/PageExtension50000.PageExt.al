pageextension 50139 PurchaseOrderSubform extends Microsoft.Purchases.Document."Purchase Order Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("Tax Area Code32170"; Rec."Tax Area Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
