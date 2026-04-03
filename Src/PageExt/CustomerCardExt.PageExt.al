pageextension 50135 CustomerCardExt extends "Customer Card"
{
    layout
    {
        addafter("VAT Registration No.")
        {
            field(SVATRegistrationNo; Rec.SVATRegistrationNo)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the SVAT Registration Number for the customer.';
            }
        }
        addafter("Preferred Bank Account Code")
        {
            field(CompanyBankAccountCode; Rec.CompanyBankAccountCode)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Company Bank Account Code field.';
            }
        }
    }
}
