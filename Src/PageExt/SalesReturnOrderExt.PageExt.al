pageextension 50124 SalesReturnOrderExt extends "Sales Return Order"
{
    layout
    {
        addafter("Currency Code")
        {
            field(CompanyBankAccountCode; Rec.CompanyBankAccountCode)
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    Rec.Validate("Company Bank Account Code", Rec.CompanyBankAccountCode);
                end;
            }
        }
        modify("Company Bank Account Code")
        {
            Visible = false;
        }
    }
}
