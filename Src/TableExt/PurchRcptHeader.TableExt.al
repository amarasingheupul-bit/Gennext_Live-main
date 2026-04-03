tableextension 50132 "4HC Purch.Rcpt.Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50100; "Sales Order No. 4HC"; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(50103; "Gennext User"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Gennext User';
            DataClassification = ToBeClassified;
        }
        field(50142; "Gennext Create By User"; Code[20])
        {
            Caption = 'Create By';
        }
    }
}