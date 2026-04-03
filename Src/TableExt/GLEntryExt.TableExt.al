tableextension 50119 GLEntryExt extends "G/L Entry"
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
        field(50103; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            ToolTip = 'Specifies the code for the salesperson whom the entry is linked to.';
        }
        field(50104; "Gennext User"; Code[20])
        {
            Caption = 'Gennext User';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = ToBeClassified;
        }
    }
}
