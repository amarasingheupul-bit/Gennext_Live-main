tableextension 50130 "4HC Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(50139; "Purchase Order No. 4HC"; Code[20])
        {
            Caption = 'Purchase Order No.';
        }
        field(50103; "Gennext User"; Code[20])
        {
            Caption = 'Gennext User';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = ToBeClassified;
        }
        field(50142; "Gennext Create By User"; Code[20])
        {
            Caption = 'Create By';
        }
    }
}