pageextension 50134 CustomerLedgEntries extends "Customer Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = All;
            }
        }
    }
}
