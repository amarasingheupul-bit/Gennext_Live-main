tableextension 50131 "4HC Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(50100; "Sales Order No. 4HC"; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(50103; "Gennext User"; Code[20])
        {
            Caption = 'Gennext User';
            DataClassification = ToBeClassified;
        }
        field(50142; "Gennext Create By User"; Code[20])
        {
            Caption = 'Create By';
        }
    }
}