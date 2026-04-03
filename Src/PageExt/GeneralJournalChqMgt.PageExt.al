pageextension 50133 GeneralJournalChqMgt extends "General Journal"
{
    layout
    {
        addafter("Deferral Code")
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = All;
            }
        }
    }
}
