pageextension 50127 PurchaseOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        modify("Tax Area Code")
        {
            ApplicationArea = All;
            Visible = true;
        }

        modify("Tax Group Code")
        {
            ApplicationArea = All;
            Visible = true;
        }
    }
}
