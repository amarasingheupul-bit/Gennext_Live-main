tableextension 50138 "4HC Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50103; "Gennext User"; Code[20])
        {
            Caption = 'Gennext User';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = ToBeClassified;
        }
    }
}