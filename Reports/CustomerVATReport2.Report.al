report 50100 "Customer VAT Report 2"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Customer VAT Report 2.rdl';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = where("Document Type" = filter(Invoice | "Credit Memo"));
            RequestFilterFields = "Document No.", "Posting Date";
            CalcFields = Amount;
            column(PostingDate; FORMAT("Posting Date", 0, '<Month,2>/<Day,2>/<Year4>'))
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(Description; Description)
            {
            }
            column(SerNo; SerNo)
            {
            }
            column(CustVATNo; Customer."VAT Registration No.")
            {
            }
            column(CustName; Customer.Name)
            {
            }
            column(Base; Base)
            {
            }
            column(AmtExclVAT; Amt)
            {
            }
            column(VatProdPostingGroup; VATEntry."VAT Bus. Posting Group")
            {
            }
            column(TaxAreaCode; VATEntry."Tax Area Code")
            {
            }
            column(TaxJurisCode; VATEntry."Tax Jurisdiction Code")
            {
            }
            column(CustomerSvatNo; Customer.SVATRegistrationNo)
            {
            }
            column(CompName; CompInfo.Name)
            {
            }
            column(SSCLAmount; SSCLAmount)
            {
            }
            trigger OnAfterGetRecord()
            begin
                SerNo += 1;
                if not Customer.Get("Customer No.") then
                    Clear(Customer);

                Clear(Amt);
                Clear(Base);
                Clear(VATEntry);
                clear(SSCLAmount);
                VATEntry.SetRange("Document No.", "Document No.");
                VATEntry.SetRange("Posting Date", "Posting Date");
                VATEntry.SetFilter(Base, '<>%1', 0);
                // VATEntry.CalcSums(Base);
                // VATEntry.CalcSums(Amount);
                // Amt := abs(VATEntry.Amount);
                if VATEntry.FindFirst() then
                    Base := Abs(VATEntry.Base)
                else
                    Base := Abs(Amount);

                if Base <> 0 then begin
                    VATEntry.Reset();
                    VATEntry.SetRange("Document No.", "Document No.");
                    VATEntry.SetRange("Posting Date", "Posting Date");
                    VATEntry.SetFilter("Tax Jurisdiction Code", '%1|%2', 'SSCL-FULL', 'SSCL-HALF');
                    VATEntry.CalcSums(Amount);
                    SSCLAmount := Abs(VATEntry.Amount);
                    VATEntry.Reset();
                    VATEntry.SetRange("Document No.", "Document No.");
                    VATEntry.SetRange("Posting Date", "Posting Date");
                    VATEntry.SetRange("Tax Jurisdiction Code", 'VAT');
                    VATEntry.CalcSums(Amount);
                    Amt := Abs(VATEntry.Amount);

                    if "Document Type" = "Document Type"::"Credit Memo" then begin
                        Base := -Base;
                        Amt := -Amt;
                    end;
                    if VATEntry.FindFirst() then;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SerNo := 0;
                CompInfo.Get();
            end;
        }
    }

    var
        Customer: Record Customer;
        CompInfo: Record "Company Information";
        VATEntry: Record "VAT Entry";
        SerNo: Integer;
        Base: Decimal;
        Amt: Decimal;
        SSCLAmount: Decimal;
}