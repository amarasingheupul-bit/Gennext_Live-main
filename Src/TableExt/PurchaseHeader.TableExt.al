tableextension 50128 "4HC PurchaseHeader" extends "Purchase Header"
{
    fields
    {
        field(50100; "Sales Order No. 4HC"; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(50142; "Gennext Create By User"; Code[20])
        {
            Caption = 'Create By';
        }
    }
}