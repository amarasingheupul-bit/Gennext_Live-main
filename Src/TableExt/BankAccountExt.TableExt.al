tableextension 50113 BankAccountExt extends "Bank Account"
{
    fields
    {
        field(50100; ShowInSalesDocument; Boolean)
        {
            Caption = 'Show In Sales Document';
            DataClassification = ToBeClassified;
        }
    }
}
