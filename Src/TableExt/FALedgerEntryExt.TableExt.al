tableextension 50121 FALedgerEntryExt extends "FA Ledger Entry"
{
    fields
    {
        field(50100; Narration; Text[250])
        {
            Caption = 'Narration';
        }
        field(50101; PayeeName; Text[80])
        {
            Caption = 'Payee Name';
        }
        field(50102; VoidRemarks; Text[100])
        {
            Caption = 'Void Remarks';
        }
        field(50103; "Gennext User"; Code[20])
        {
            Caption = 'Gennext User';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = ToBeClassified;
        }
    }
}
