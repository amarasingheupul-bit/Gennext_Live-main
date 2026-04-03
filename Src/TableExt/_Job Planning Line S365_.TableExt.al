tableextension 50107 "Job Planning Line S365" extends "Job Planning Line"
{
    fields
    {
        field(50100; "SEQNO S365"; Integer)
        {
            Caption = 'Seq. No.';
            DataClassification = CustomerContent;
        }
        field(50101; "Predecessor Seq S365"; Integer)
        {
            Caption = 'Predecessor Seq.';
            DataClassification = CustomerContent;
        }
        field(50102; "Completed S365"; Boolean)
        {
            Caption = 'Completed';
            DataClassification = CustomerContent;
        }
    }
}
