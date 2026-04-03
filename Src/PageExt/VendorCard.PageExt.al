pageextension 50146 "4HC Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter(Name)
        {
            field(Payee; Rec.Payee)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'The name of the payee associated with this vendor.';
            }
        }
    }
}