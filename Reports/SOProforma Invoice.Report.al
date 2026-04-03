report 50119 "SO Proforma Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/Layouts/Proforma Invoice.rdl';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            CalcFields = Amount, "Amount Including VAT";
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";

            column(ShowEmailSignature; ShowEmailSignature)
            {
            }
            column(Your_Reference; "Your Reference")
            {
            }
            column(ExternalDocumentNo_SalesInvoiceHeader; "External Document No.")
            {
            }
            column(No_SalesInvoiceHeader; "No.")
            {
            }
            column(date_SalesInvoiceHeader; "Posting Date")
            {
            }
            column(SelltoCustomerName_SalesInvoiceHeader; "Sell-to Customer Name")
            {
            }
            column(SelltoAddress_SalesInvoiceHeader; "Sell-to Address")
            {
            }
            column(SelltoAddress2_SalesInvoiceHeader; "Sell-to Address 2")
            {
            }
            column(SelltoCity_SalesInvoiceHeader; "Sell-to City")
            {
            }
            column(Ship_to_Contact; "Ship-to Contact")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(Ship_to_Address_2; "Ship-to Address 2")
            {
            }
            column(Ship_to_City; "Ship-to City")
            {
            }
            column(CurrCode; CurrCode)
            {
            }
            column(TaxLbl; TaxLbl)
            {
            }
            column(SvatPct; SvatPct)
            {
            }
            column(VATAmount; VATAmount)
            {
            }
            column(CustVATRegNo; Customer."VAT Registration No.")
            {
            }
            column(CustSVATRegNo; Customer.SVATRegistrationNo)
            {
            }
            column(CusVATPostingGroup; Customer."VAT Bus. Posting Group")
            {
            }
            column(VATPostingGroup; "VAT Bus. Posting Group")
            {
            }
            column(Advance; PIAdvance)
            {
            }
            column(AdvanceLbl; AdvanceLbl)
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(BankAccName; TempBankAcc.Name)
            {
            }
            column(BankAccNo; TempBankAcc."Bank Account No.")
            {
            }
            column(BankAccCity; TempBankAcc.City)
            {
            }
            column(BankAccSwiftCode; TempBankAcc."SWIFT Code")
            {
            }
            column(BankAccCode; TempBankAcc."Transit No.")
            {
            }
            column(ComName; ComInfo.Name)
            {
            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {
            }
            column(Invoice_Discount_Amount; "Invoice Discount Amount")
            {
            }
            column(SVATControl; SVATControl)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(Sn; Sn)
                {
                }
                column(LineAmount_SalesInvoiceLine; "Line Amount")
                {
                }
                column(No_SalesInvoiceLine; "No.")
                {
                }
                column(Description_SalesInvoiceLine; Description)
                {
                }
                column(Quantity_SalesInvoiceLine; Quantity)
                {
                }
                column(UnitPrice_SalesInvoiceLine; "Unit Price")
                {
                }
                column(ReportTitle; ReportTitle)
                {
                }
                column(SSCLTaxAmount; SSCLTaxAmount)
                {
                }
                column(VATAmnt; VATAmnt)
                {
                }
                column(SSCLTaxText; SSCLTaxText)
                {
                }
                column(VATTaxText; VATTaxText)
                {
                }
                column(TotalSSCLTaxAmount; TotalSSCLTaxAmount)
                {
                }
                column(TotalVatAmount; TotalVatAmount)
                {
                }
                trigger OnAfterGetRecord();
                begin
                    if "No." <> '' then
                        Sn += 1
                    else
                        Sn := 0;
                    Clear(SSCLTaxAmount);
                    Clear(VATAmnt);
                    Clear(SSCLTaxText);
                    Clear(VATTaxText);
                    if not (("Tax Area Code" = '') and ("Tax Group Code" = '')) then CalTaxOnTax("Tax Group Code", "Tax Area Code", Amount, "Sales Header"."Posting Date", SSCLTaxAmount, VATAmnt, SSCLTaxText, VATTaxText);
                    //Message('%1',SSCLTaxAmount);
                    TotalSSCLTaxAmount += SSCLTaxAmount;
                    TotalVatAmount += VATAmnt;
                    //Message('%1 / %2', TotalSSCLTaxAmount, TotalVatAmount);
                end;
            }
            trigger OnAfterGetRecord();
            var
                TaxArea: Record "Tax Area";
            begin
                if "Currency Code" = '' then
                    CurrCode := 'LKR'
                else
                    CurrCode := "Currency Code";
                //temperory
                TaxLbl := 'VAT 18%';
                SvatPct := 18;
                if "Posting Date" < 20240101D then begin
                    TaxLbl := 'VAT 15%';
                    SvatPct := 15;
                end;
                if "Posting Date" < 20220601D then begin
                    TaxLbl := 'VAT 8%';
                    SvatPct := 8;
                end
                else if "Posting Date" < 20220901D then begin
                    TaxLbl := 'VAT 12%';
                    SvatPct := 12;
                end;
                //DocumentTotals.CalculatePostedSalesInvoiceTotals(TotalSalesInvoiceHeader,VATAmount,"Sales Invoice Line");
                VATAmount := "Amount Including VAT" - Amount;
                Customer.GET("Sell-to Customer No.");
                "Company Information".GET();
                "Company Information".CALCFIELDS(Picture);
                /*CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment);  PV commented
                            CustLedgerEntry.SETRANGE("Document No.", "Sales Invoice Header"."Applies-to Doc. No.");
                            if CustLedgerEntry.FINDFIRST then begin
                                CustLedgerEntry.CALCFIELDS(Amount);
                                Advance := ABS(CustLedgerEntry.Amount);
                            end;*/

                AdvanceLbl := 'Advance ' + Format(PIAdvancePercentage) + '%';
                //PV(+)
                SVATControl := false;
                ReportTitle := 'Proforma Invoice';
                if TaxArea.Get("Tax Area Code") then
                    if TaxArea.Description = 'SVAT Invoice' then begin
                        ReportTitle := 'SVAT Proforma Invoice';
                        SVATControl := true; //TD
                    end;
                if BankAcc.Get("Bal. Account No.") then begin
                    TempBankAcc.Init();
                    TempBankAcc.TransferFields(BankAcc);
                    TempBankAcc.Insert();
                end
                else begin
                    TempBankAcc.Init();
                    TempBankAcc."No." := 'TEST';
                    TempBankAcc.Name := ComInfo."Bank Name";
                    TempBankAcc."Bank Account No." := ComInfo."Bank Account No.";
                    TempBankAcc.City := ComInfo."Bank Branch No.";
                    TempBankAcc."SWIFT Code" := ComInfo."SWIFT Code";
                    TempBankAcc."Transit No." := ComInfo."Giro No.";
                    TempBankAcc.Insert();
                end;
                if TempBankAcc.FindFirst() then;
                //PV(-)
            end;

            trigger OnPreDataItem()
            begin
                ComInfo.Get();
                //"Company Information".CalcFields(Picture);
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            MaxIteration = 1;

            column(EMail_CompanyInformation; "Company Information"."E-Mail")
            {
            }
            column(Name_CompanyInformation; "Company Information".Name)
            {
            }
            column(Address_CompanyInformation; "Company Information".Address)
            {
            }
            column(Address2_CompanyInformation; "Company Information"."Address 2")
            {
            }
            column(City_CompanyInformation; "Company Information".City)
            {
            }
            column(PhoneNo_CompanyInformation; "Company Information"."Phone No.")
            {
            }
            column(FaxNo_CompanyInformation; "Company Information"."Fax No.")
            {
            }
            column(VATRegistrationNo_CompanyInformation; "Company Information"."VAT Registration No.")
            {
            }
            column(SVATRegistrationNo_CompanyInformation; "Company Information".SVATRegistrationNo)
            {
            }
            column(Logo; "Company Information".Picture)
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                field("E-Mail Signature"; ShowEmailSignature)
                {
                    ApplicationArea = All;
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    var
        CurrCode: Code[10];
        TaxLbl: Text;
        SvatPct: Decimal;
        DocumentTotals: Codeunit "Document Totals";
        VATAmount: Decimal;
        TotalSalesInvoiceHeader: Record "Sales Invoice Header";
        Customer: Record Customer;
        Sn: Integer;
        "Company Information": Record "Company Information";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Advance: Decimal;
        ShowEmailSignature: Boolean;
        AdvanceLbl: Text;
        BankAcc: Record "Bank Account";
        ComInfo: Record "Company Information";
        TempBankAcc: Record "Bank Account" temporary;
        ReportTitle: text; //PV
        SSCLTaxAmount: Decimal;
        TotalSSCLTaxAmount: Decimal;
        VATAmnt: Decimal;
        TotalVatAmount: Decimal;
        SSCLTaxText: Text;
        VATTaxText: Text;
        SVATControl: Boolean;

    procedure CalTaxOnTax(TaxGroup: Code[20]; TaxArea: Code[20]; CalAmt: Decimal; PostingDate: Date; var SSCLAmt: Decimal; var VATAmt: Decimal; var SSCLPerText: Text; var VATPerText: Text)
    var
        TaxDetail: Record "Tax Detail";
        TaxALine: Record "Tax Area Line";
    begin
        Clear(TaxDetail);
        TaxDetail.SetRange("Tax Group Code", TaxGroup);
        TaxDetail.SetFilter("Effective Date", '<=%1', PostingDate);
        Clear(TaxALine);
        TaxALine.SetCurrentKey("Tax Area", "Calculation Order");
        TaxALine.SetRange("Tax Area", TaxArea);
        TaxALine.Ascending(false);
        if TaxALine.FindSet() then
            repeat
                TaxDetail.SetRange("Tax Jurisdiction Code", TaxALine."Tax Jurisdiction Code");
                if TaxDetail.FindLast() then begin
                    if TaxALine."Tax Jurisdiction Code" = 'SSCL-HALF' then begin
                        SSCLAmt := CalAmt * TaxDetail."Tax Below Maximum" / 100;
                        SSCLPerText := 'SSCL ' + Format(Round(TaxDetail."Tax Below Maximum", 0.01, '=')) + ' %';
                    end;
                    if TaxALine."Tax Jurisdiction Code" = 'SSCL-FULL' then begin
                        SSCLAmt := CalAmt * TaxDetail."Tax Below Maximum" / 100;
                        SSCLPerText := 'SSCL ' + Format(Round(TaxDetail."Tax Below Maximum", 0.01, '=')) + ' %';
                    end;
                    if TaxALine."Tax Jurisdiction Code" = 'SSCL' then begin
                        SSCLAmt := CalAmt * TaxDetail."Tax Below Maximum" / 100;
                        SSCLPerText := 'SSCL ' + Format(Round(TaxDetail."Tax Below Maximum", 0.01, '=')) + ' %';
                    end;
                    if TaxALine."Tax Jurisdiction Code" = 'VAT' then begin
                        VATAmt := CalAmt * TaxDetail."Tax Below Maximum" / 100;
                        VATPerText := 'VAT ' + Format(Round(TaxDetail."Tax Below Maximum", 0.01, '=')) + ' %';
                    end;
                end;
            until TaxALine.Next() = 0;
    end;
}