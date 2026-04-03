pageextension 50132 GenLedgeEntriesExt extends "General Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field(NarrationChqMgt; Rec.Narration)
            {
                ApplicationArea = all;
                //Editable = false;
            }
        }
    }
}
