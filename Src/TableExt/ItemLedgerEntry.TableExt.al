tableextension 50129 "4HC Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(50103; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            ToolTip = 'Specifies the code for the salesperson whom the entry is linked to.';
        }
        field(50100; "Gennext User"; Code[20])
        {
            Caption = 'Gennext User';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = ToBeClassified;
        }
        field(50101; "4HC Service Item Doc No."; Code[20])
        {
            Caption = 'Service Item Doc. No.';
            TableRelation = "Service Item";
            DataClassification = ToBeClassified;
        }
    }
}