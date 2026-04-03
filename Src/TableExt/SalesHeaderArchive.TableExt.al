tableextension 50124 "4HC Sales Header Archive" extends "Sales Header Archive"
{
    fields
    {
        field(50138; "Margin %"; Decimal)
        {
            Caption = 'Margin %';
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