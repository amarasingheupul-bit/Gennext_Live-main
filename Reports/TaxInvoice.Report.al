report 50107 "Tax Invoice"
{
    UsageCategory = None;
    DefaultLayout = RDLC;
    //RDLCLayout = './Reports/Layouts/Tax Invoice.rdl';
    RDLCLayout = './Reports/Layouts/Tax InvoiceNew.rdl';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number);
            MaxIteration = 1;

            column(EMail_CompanyInformation; "Company Information"."E-Mail") { }
            column(Name_CompanyInformation; "Company Information".Name) { }
            column(Address_CompanyInformation; "Company Information".Address) { }
            column(Address2_CompanyInformation; "Company Information"."Address 2") { }
            column(City_CompanyInformation; "Company Information".City) { }
            column(PhoneNo_CompanyInformation; "Company Information"."Phone No.") { }
            column(FaxNo_CompanyInformation; "Company Information"."Fax No.") { }
            column(VATRegistrationNo_CompanyInformation; "Company Information"."VAT Registration No.") { }
            column(SVATRegistrationNo_CompanyInformation; "Company Information".SVATRegistrationNo) { }
            column(Logo; "Company Information".Picture) { }

            dataitem("Sales Invoice Header"; "Sales Invoice Header")
            {
                CalcFields = Amount, "Amount Including VAT";
                DataItemTableView = SORTING("No.");
                RequestFilterFields = "No.";

                column(ShowEmailSignature; ShowEmailSignature) { }
                column(ShowFooter; ShowFooter) { }
                column(FooterText; FooterText) { }
                column(Your_Reference; "Your Reference") { }
                column(ExternalDocumentNo_SalesInvoiceHeader; "Sales Invoice Header"."External Document No.") { }
                column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.") { }
                column(date_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date") { }
                column(SelltoCustomerName_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer Name") { }
                column(SelltoAddress_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Address") { }
                column(SelltoAddress2_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Address 2") { }
                column(SelltoCity_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to City") { }
                column(SellcusPhone; "Sales Invoice Header"."Sell-to Phone No.") { }
                column(Shipment_Date; "Shipment Date") { }
                column(Ship_to_Contact; "Ship-to Contact") { }
                column(Ship_to_Address; "Ship-to Address") { }
                column(Ship_to_Address_2; "Ship-to Address 2") { }
                column(Ship_to_City; "Ship-to City") { }
                column(CurrCode; CurrCode) { }
                column(TaxLbl; TaxLbl) { }
                column(SvatPct; SvatPct) { }
                column(VATAmount; VATAmount) { }
                column(CustVATRegNo; Customer."VAT Registration No.") { }
                column(CustSVATRegNo; Customer.SVATRegistrationNo) { }
                column(BankAccName; TempBankAcc.Name) { }
                column(BankAccNo; TempBankAcc."Bank Account No.") { }
                column(BankAccCity; TempBankAcc.City) { }
                column(BankAccSwiftCode; TempBankAcc."SWIFT Code") { }
                column(BankAccCode; TempBankAcc."Transit No.") { }
                column(ComName; ComInfo.Name) { }
                column(Posting_Date; "Posting Date") { }
                column(Invoice_Discount_Amount; "Invoice Discount Amount") { }
                column(Payment_Terms_Code; "Payment Terms Code") { }
                column(Advance; ABS(TempCustLedgEntry.Amount)) { }
                column(TotalInvoiceAmount; TotalInvoiceAmount) { }
                column(AmountInWords; AmountInWordsTxt) { }
                column(CurrencyFactor; "Sales Invoice Header"."Currency Factor") { }
                column(ExchangeRateAmt; ExchangeRateAmt) { }
                column(ExchangeRateTxt; ExchangeRateTxt) { }

                dataitem("Sales Invoice Line"; "Sales Invoice Line")
                {
                    DataItemLink = "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document No.", "Line No.");

                    column(Sn; Sn) { }
                    column(LineAmount_SalesInvoiceLine; "Sales Invoice Line"."Line Amount") { }
                    column(No_SalesInvoiceLine; "Sales Invoice Line"."No.") { }
                    column(Description_SalesInvoiceLine; "Sales Invoice Line".Description) { }
                    column(Quantity_SalesInvoiceLine; "Sales Invoice Line".Quantity) { }
                    column(UnitPrice_SalesInvoiceLine; "Sales Invoice Line"."Unit Price") { }
                    column(ReportTitle; ReportTitle) { }
                    column(SSCLTaxAmount; SSCLTaxAmount) { }
                    column(VATAmnt; VATAmnt) { }
                    column(SSCLTaxText; SSCLTaxText) { }
                    column(VATTaxText; VATTaxText) { }
                    column(TotalSSCLTaxAmount; TotalSSCLTaxAmount) { }
                    column(TotalVatAmount; TotalVatAmount) { }

                    trigger OnAfterGetRecord()
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
                            CalTaxOnTax(
                                "Tax Group Code",
                                "Tax Area Code",
                                Amount,
                                "Sales Invoice Header"."Posting Date",
                                SSCLTaxAmount,
                                VATAmnt,
                                SSCLTaxText,
                                VATTaxText);
                        TotalSSCLTaxAmount += SSCLTaxAmount;
                        TotalVatAmount += VATAmnt;
                    end;
                }

                trigger OnPreDataItem()
                begin
                    ComInfo.Get();
                end;

                trigger OnAfterGetRecord()
                var
                    TaxArea: Record "Tax Area";
                    SalesLine: Record "Sales Invoice Line";
                    LineSSCLAmt: Decimal;
                    LineVATAmt: Decimal;
                    LineSSCLText: Text;
                    LineVATText: Text;
                    SumLineAmount: Decimal;
                    SumSSCL: Decimal;
                    SumVAT: Decimal;
                begin
                    // Reset per-line running totals for this header
                    TotalSSCLTaxAmount := 0;
                    TotalVatAmount := 0;
                    Sn := 0;

                    if "Currency Code" = '' then
                        CurrCode := 'LKR'
                    else
                        CurrCode := "Currency Code";

                    TaxLbl := 'VAT 18%';
                    SvatPct := 18;
                    if "Posting Date" < 20220601D then begin
                        TaxLbl := 'VAT 8%';
                        SvatPct := 8;
                    end else if "Posting Date" < 20220901D then begin
                        TaxLbl := 'VAT 12%';
                        SvatPct := 12;
                    end else if "Posting Date" < 20240101D then begin
                        TaxLbl := 'VAT 15%';
                        SvatPct := 15;
                    end;

                    VATAmount := "Amount Including VAT" - Amount;
                    Customer.GET("Sell-to Customer No.");
                    "Company Information".GET();
                    "Company Information".CALCFIELDS(Picture);

                    CustLedgerEntry.SETRANGE("Document No.", "Sales Invoice Header"."No.");
                    if CustLedgerEntry.FindFirst() then
                        GetAppliedDocs.GetAppliedCustomerDocs(
                            CustLedgerEntry,
                            TempCustLedgEntry,
                            false);
                    TempCustLedgEntry.SetAutoCalcFields(Amount);
                    if TempCustLedgEntry.FindFirst() then;

                    ReportTitle := 'TAX INVOICE';
                    if TaxArea.Get("Tax Area Code") then
                        if TaxArea.Description = 'SVAT INVOICE' then
                            ReportTitle := 'SVAT INVOICE';

                    if BankAcc.Get("Company Bank Account Code") then begin
                        TempBankAcc.Init();
                        TempBankAcc.TransferFields(BankAcc);
                        TempBankAcc.Insert();
                    end else begin
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

                    // Footer text is set independently of ShowEmailSignature
                    if ShowFooter then
                        FooterText :=
                            'Payments are due within the stipulated credit period. ' +
                            'Any outstanding balance beyond the due date will be subject to a ' +
                            '2% monthly interest charge calculated daily until full payment is received.'
                    else
                        FooterText := '';

                    // ---- Exchange rate (Relational Exch. Rate Amount equivalent) ----
                    if ("Currency Code" <> '') and ("Currency Factor" <> 0) then begin
                        GLSetup.Get();
                        if GLSetup."LCY Code" <> '' then
                            LCYCode := GLSetup."LCY Code"
                        else
                            LCYCode := 'LKR';

                        ExchangeRateAmt := Round(1 / "Currency Factor", 0.01);
                        ExchangeRateTxt := StrSubstNo('1 %1 = %2 %3',
                            "Currency Code",
                            ExchangeRateAmt,
                            LCYCode);
                    end else begin
                        ExchangeRateAmt := 0;
                        ExchangeRateTxt := '';
                    end;

                    // ---- Compute grand total (Line Amount + VAT + SSCL - Discount) and convert to words ----
                    SumLineAmount := 0;
                    SumSSCL := 0;
                    SumVAT := 0;
                    SalesLine.SetRange("Document No.", "No.");
                    if SalesLine.FindSet() then
                        repeat
                            if (SalesLine."No." <> '') and (SalesLine.Quantity <> 0) then begin
                                SumLineAmount += SalesLine."Line Amount";
                                Clear(LineSSCLAmt);
                                Clear(LineVATAmt);
                                if not ((SalesLine."Tax Area Code" = '') and (SalesLine."Tax Group Code" = '')) then
                                    CalTaxOnTax(
                                        SalesLine."Tax Group Code",
                                        SalesLine."Tax Area Code",
                                        SalesLine.Amount,
                                        "Posting Date",
                                        LineSSCLAmt,
                                        LineVATAmt,
                                        LineSSCLText,
                                        LineVATText);
                                SumSSCL += LineSSCLAmt;
                                SumVAT += LineVATAmt;
                            end;
                        until SalesLine.Next() = 0;

                    TotalInvoiceAmount := SumLineAmount + SumVAT + SumSSCL - "Invoice Discount Amount";
                    AmountInWordsTxt := AmountToWords(TotalInvoiceAmount, CurrCode);
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
                    Caption = 'Show Email Signature';
                }
                field("Show Footer"; ShowFooter)
                {
                    ApplicationArea = All;
                    Caption = 'Show Interest Charge Description';
                    ToolTip = 'Enable to print payment terms at the bottom of the invoice.';
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
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        Customer: Record Customer;
        TotalSalesInvoiceHeader: Record "Sales Invoice Header";
        GLSetup: Record "General Ledger Setup";
        DocumentTotals: Codeunit "Document Totals";
        GetAppliedDocs: Codeunit "Get Applied Docs";
        ShowEmailSignature: Boolean;
        ShowFooter: Boolean;
        FooterText: Text;
        CurrCode: Code[10];
        LCYCode: Code[10];
        SSCLTaxAmount: Decimal;
        SvatPct: Decimal;
        TotalSSCLTaxAmount: Decimal;
        TotalVatAmount: Decimal;
        VATAmnt: Decimal;
        VATAmount: Decimal;
        Sn: Integer;
        ReportTitle: Text;
        SSCLTaxText: Text;
        TaxLbl: Text;
        VATTaxText: Text;
        TotalInvoiceAmount: Decimal;
        AmountInWordsTxt: Text[250];
        ExchangeRateAmt: Decimal;
        ExchangeRateTxt: Text;

    procedure CalTaxOnTax(TaxGroup: Code[20]; TaxArea: Code[20];
        CalAmt: Decimal; PostingDate: Date;
        var SSCLAmt: Decimal; var VATAmt: Decimal;
        var SSCLPerText: Text; var VATPerText: Text)
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
                TaxDetail.SetRange(
                    "Tax Jurisdiction Code",
                    TaxALine."Tax Jurisdiction Code");
                if TaxDetail.FindLast() then begin
                    if TaxALine."Tax Jurisdiction Code" = 'SSCL-HALF' then begin
                        SSCLAmt := CalAmt * TaxDetail."Tax Below Maximum" / 100;
                        SSCLPerText := 'SSCL ' +
                            Format(Round(TaxDetail."Tax Below Maximum", 0.01, '=')) + ' %';
                    end;
                    if TaxALine."Tax Jurisdiction Code" = 'SSCL-FULL' then begin
                        SSCLAmt := CalAmt * TaxDetail."Tax Below Maximum" / 100;
                        SSCLPerText := 'SSCL ' +
                            Format(Round(TaxDetail."Tax Below Maximum", 0.01, '=')) + ' %';
                    end;
                    if TaxALine."Tax Jurisdiction Code" = 'SSCL' then begin
                        SSCLAmt := CalAmt * TaxDetail."Tax Below Maximum" / 100;
                        SSCLPerText := 'SSCL ' +
                            Format(Round(TaxDetail."Tax Below Maximum", 0.01, '=')) + ' %';
                    end;
                    if TaxALine."Tax Jurisdiction Code" = 'VAT' then begin
                        VATAmt := (CalAmt + SSCLAmt) * TaxDetail."Tax Below Maximum" / 100;
                        VATPerText := 'VAT ' +
                            Format(Round(TaxDetail."Tax Below Maximum", 0.01, '=')) + ' %';
                    end;
                end;
            until TaxALine.Next() = 0;
    end;

    procedure AmountToWords(Amt: Decimal; CurrencyCode: Code[10]): Text[250]
    var
        WholePart: Integer;
        FractionPart: Integer;
        ResultTxt: Text;
        IsNegative: Boolean;
    begin
        IsNegative := Amt < 0;
        Amt := Abs(Amt);
        WholePart := Round(Amt, 1, '<');
        FractionPart := Round((Amt - WholePart) * 100, 1, '=');

        ResultTxt := ConvertNumberToWords(WholePart) + ' Rupees';
        if FractionPart > 0 then
            ResultTxt += ' and ' + ConvertNumberToWords(FractionPart) + ' Cents';
        ResultTxt += ' Only';

        if IsNegative then
            ResultTxt := 'Minus ' + ResultTxt;

        exit(CopyStr(ResultTxt, 1, 250));
    end;

    local procedure ConvertNumberToWords(Number: Integer): Text
    var
        Ones: array[20] of Text;
        Tens: array[10] of Text;
        ResultTxt: Text;
    begin
        Ones[1] := 'One';
        Ones[2] := 'Two';
        Ones[3] := 'Three';
        Ones[4] := 'Four';
        Ones[5] := 'Five';
        Ones[6] := 'Six';
        Ones[7] := 'Seven';
        Ones[8] := 'Eight';
        Ones[9] := 'Nine';
        Ones[10] := 'Ten';
        Ones[11] := 'Eleven';
        Ones[12] := 'Twelve';
        Ones[13] := 'Thirteen';
        Ones[14] := 'Fourteen';
        Ones[15] := 'Fifteen';
        Ones[16] := 'Sixteen';
        Ones[17] := 'Seventeen';
        Ones[18] := 'Eighteen';
        Ones[19] := 'Nineteen';

        Tens[2] := 'Twenty';
        Tens[3] := 'Thirty';
        Tens[4] := 'Forty';
        Tens[5] := 'Fifty';
        Tens[6] := 'Sixty';
        Tens[7] := 'Seventy';
        Tens[8] := 'Eighty';
        Tens[9] := 'Ninety';

        if Number = 0 then
            exit('Zero');

        if Number >= 10000000 then begin
            ResultTxt += ConvertNumberToWords(Number div 10000000) + ' Crore ';
            Number := Number mod 10000000;
        end;
        if Number >= 100000 then begin
            ResultTxt += ConvertNumberToWords(Number div 100000) + ' Lakh ';
            Number := Number mod 100000;
        end;
        if Number >= 1000 then begin
            ResultTxt += ConvertNumberToWords(Number div 1000) + ' Thousand ';
            Number := Number mod 1000;
        end;
        if Number >= 100 then begin
            ResultTxt += ConvertNumberToWords(Number div 100) + ' Hundred ';
            Number := Number mod 100;
        end;
        if Number > 0 then begin
            if ResultTxt <> '' then
                ResultTxt += 'and ';
            if Number < 20 then
                ResultTxt += Ones[Number]
            else begin
                ResultTxt += Tens[Number div 10];
                if Number mod 10 > 0 then
                    ResultTxt += '-' + Ones[Number mod 10];
            end;
        end;

        exit(DelChr(ResultTxt, '>', ' '));
    end;
}