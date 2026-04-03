pageextension 50118 UserSetupExt extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field(PresalesAdmin; Rec.PresalesAdmin)
            {
                ApplicationArea = All;
            }
        }
    }
}
