tableextension 50122 CustomerExt extends Customer
{
    fields
    {
        field(50100; SVATRegistrationNo; Text[20])
        {
            Caption = 'SVAT Registration No.';
            DataClassification = ToBeClassified;
        }
        field(50131; CompanyBankAccountCode; Code[20])
        {
            Caption = 'Company Bank Account Code';
            TableRelation = "Bank Account" where("Currency Code" = field("Currency Code"), ShowInSalesDocument = const(true));
        }
    }
}
