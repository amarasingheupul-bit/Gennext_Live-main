tableextension 50141 "4HC Return Shipment Header" extends "Return Shipment Header"
{
    fields
    {
        field(50103; "Gennext User"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Gennext User';
            DataClassification = ToBeClassified;
        }
    }
}