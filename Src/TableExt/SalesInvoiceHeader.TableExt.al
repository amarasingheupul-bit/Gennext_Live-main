tableextension 50134 "4HC Sales Invoice Header" extends "Sales Invoice Header"
{
    fields
    {
        field(50139; "Purchase Order No. 4HC"; Code[20])
        {
            Caption = 'Purchase Order No.';
        }
        field(50131; CompanyBankAccountCode; Code[20])
        {
            Caption = 'Company Bank Account Code';
            TableRelation = "Bank Account" where("Currency Code" = field("Currency Code"), ShowInSalesDocument = const(true));
        }
        field(50138; "Margin %"; Decimal)
        {
            Caption = 'Margin %';
        }
        field(50135; "Approval Status"; Enum "4HC Header Status")
        {
            Caption = 'Approval Status';
        }
        field(50136; "Approval Sender"; Code[20])
        {
            Caption = 'Approval Sender';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50137; "Approver ID"; Code[20])
        {
            Caption = 'Approver ID';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50140; "Reject Reason"; Text[250])
        {
            Caption = 'Reject Reason';
        }
        field(50103; "Gennext User"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Gennext User';
            DataClassification = ToBeClassified;
        }
        field(50142; "Gennext Create By User"; Code[20])
        {
            Caption = 'Create By';
        }
    }
}