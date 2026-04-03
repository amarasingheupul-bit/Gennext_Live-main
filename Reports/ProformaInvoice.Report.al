report 50106 "Proforma Invoice"
{
    UsageCategory = None;
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/Layouts/ProformaInvoice1.rdl';

    dataset
    {
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

            dataitem("Sales Invoice Header"; "Sales Invoice Header")
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
                column(ExternalDocumentNo_SalesInvoiceHeader; "Sales Invoice Header"."External Document No.")
                {
                }
                column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.")
                {
                }
                column(date_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date")
                {
                }
                column(SelltoCustomerName_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer Name")
                {
                }
                column(SelltoAddress_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Address")
                {
                }
                column(SelltoAddress2_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Address 2")
                {
                }
                column(SelltoCity_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to City")
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
                column(Posting_Date; "Posting Date")
                {
                }
                column(Invoice_Discount_Amount; "Invoice Discount Amount")
                {
                }
                column(Payment_Terms_Code; "Payment Terms Code")
                {
                }
                column(Advance; ABS(TempCustLedgEntry.Amount))
                {
                }
                dataitem("Sales Invoice Line"; "Sales Invoice Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Line No.");

                    column(Sn; Sn)
                    {
                    }
                    column(LineAmount_SalesInvoiceLine; "Sales Invoice Line"."Line Amount")
                    {
                    }
                    column(No_SalesInvoiceLine; "Sales Invoice Line"."No.")
                    {
                    }
                    column(Description_SalesInvoiceLine; "Sales Invoice Line".Description)
                    {
                    }
                    column(Quantity_SalesInvoiceLine; "Sales Invoice Line".Quantity)
                    {
                    }
                    column(UnitPrice_SalesInvoiceLine; "Sales Invoice Line"."Unit Price")
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
                        if ("No." <> '') and (Quantity = 0) then CurrReport.Skip();
                        if "No." <> '' then
                            Sn += 1
                        else
                            Sn := 0;
                        Clear(SSCLTaxAmount);
                        Clear(VATAmnt);
                        Clear(SSCLTaxText);
                        if not (("Tax Area Code" = '') and ("Tax Group Code" = '')) then
                            CalTaxOnTax("Tax Group Code", "Tax Area Code", Amount, "Sales Invoice Header"."Posting Date", SSCLTaxAmount, VATAmnt, SSCLTaxText, VATTaxText);
                        TotalSSCLTaxAmount += SSCLTaxAmount;
                        TotalVatAmount += VATAmnt;
                    end;
                }
                /*  dataitem(Integer2; Integer)
                           {
                               //DataItemTableView = sorting(Number) WHERE(Number = FILTER(1 ..));


                               trigger OnPreDataItem()
                               begin
                                   TempCustLedgEntry.SetAutoCalcFields(Amount);
                                   if not TempCustLedgEntry.FindFirst() then
                                       CurrReport.break;
                                   SetRange(Number, 1, TempCustLedgEntry.Count);
                               end;

                               trigger OnAfterGetRecord()6
                               begin
                                   if Number <> 1 then
                                       TempCustLedgEntry.Next();
                               end;
                           } */
                trigger OnAfterGetRecord();
                var
                    TaxArea: Record "Tax Area";
                begin
                    //Message('Under developments... please contact system admin.');
                    if "Currency Code" = '' then
                        CurrCode := 'LKR'
                    else
                        CurrCode := "Currency Code";
                    TaxLbl := 'VAT 18%';
                    SvatPct := 18;
                    if "Posting Date" < 20220601D then begin
                        TaxLbl := 'VAT 8%';
                        SvatPct := 8;
                    end
                    else if "Posting Date" < 20220901D then begin
                        TaxLbl := 'VAT 12%';
                        SvatPct := 12;
                    end
                    else if "Posting Date" < 20240101D then begin
                        TaxLbl := 'VAT 15%';
                        SvatPct := 15;
                    end;
                    //DocumentTotals.CalculatePostedSalesInvoiceTotals(TotalSalesInvoiceHeader,VATAmount,"Sales Invoice Line");
                    VATAmount := "Amount Including VAT" - Amount;
                    Customer.GET("Sell-to Customer No.");
                    "Company Information".GET();
                    "Company Information".CALCFIELDS(Picture);
                    //CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment);
                    CustLedgerEntry.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                    if CustLedgerEntry.FindFirst() then GetAppliedDocs.GetAppliedCustomerDocs(CustLedgerEntry, TempCustLedgEntry, false);
                    TempCustLedgEntry.SetAutoCalcFields(Amount);
                    if TempCustLedgEntry.FindFirst() then;
                    //  CustLedgerEntry.CALCFIELDS(Amount);
                    // Advance := ABS(CustLedgerEntry.Amount);
                    //end;

                    ReportTitle := 'Proforma Invoice';
                    // if TaxArea.Get("Tax Area Code") then
                    //     if TaxArea.Description = 'SVAT Invoice' then
                    //         ReportTitle := 'SVAT Invoice';

                    if BankAcc.Get("Company Bank Account Code") then begin
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
                end;

                trigger OnPreDataItem()
                begin
                    ComInfo.Get();
                end;
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
    }
    var
        BankAcc: Record "Bank Account";
        TempBankAcc: Record "Bank Account" temporary;
        ComInfo: Record "Company Information";
        "Company Information": Record "Company Information";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        //CustLedgEntry: Record "Cust. Ledger Entry";
        //CreateCustLedgEntry: Record "Cust. Ledger Entry";
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        Customer: Record Customer;
        TotalSalesInvoiceHeader: Record "Sales Invoice Header";
        DocumentTotals: Codeunit "Document Totals";
        GetAppliedDocs: Codeunit "Get Applied Docs";
        //Advance: Decimal;
        ShowEmailSignature: Boolean;
        CurrCode: Code[10];
        SSCLTaxAmount: Decimal;
        SvatPct: Decimal;
        TotalSSCLTaxAmount: Decimal;
        TotalVatAmount: Decimal;
        VATAmnt: Decimal;
        VATAmount: Decimal;
        Sn: Integer;
        ReportTitle: text;
        SSCLTaxText: Text;
        TaxLbl: Text;
        VATTaxText: Text;

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
        if TaxALine.FindSet() then //repeat VAT and SSCL twice
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
                        VATAmt := (CalAmt + SSCLAmt) * TaxDetail."Tax Below Maximum" / 100;
                        VATPerText := 'VAT ' + Format(Round(TaxDetail."Tax Below Maximum", 0.01, '=')) + ' %';
                    end;
                end;
            until TaxALine.Next() = 0;
    end;
}
