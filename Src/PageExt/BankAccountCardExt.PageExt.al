pageextension 50125 BankAccountCardExt extends "Bank Account Card"
{
    layout
    {
        addlast(General)
        {
            field(ShowInSalesDocument; Rec.ShowInSalesDocument)
            {
                ApplicationArea = All;
            }
        }
    }
}
