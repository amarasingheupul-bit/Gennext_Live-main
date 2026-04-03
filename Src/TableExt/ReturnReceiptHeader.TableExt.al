tableextension 50139 "4HC Return Receipt Header" extends "Return Receipt Header"
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