tableextension 50140 "4HC Purch. Cr. Memo Hdr." extends "Purch. Cr. Memo Hdr."
{
    fields
    {
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