report 50110 "Purch Order"
{
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/Layouts/Purch Order.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
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
            column(ExternalDocumentNo_SalesInvoiceHeader; '')
            {
            }
            column(No_SalesInvoiceHeader; "No.")
            {
            }
            column(SelltoCustomerName_SalesInvoiceHeader; "Purchase Header"."Buy-from Vendor Name")
            {
            }
            column(SelltoAddress_SalesInvoiceHeader; "Purchase Header"."Buy-from Address")
            {
            }
            column(SelltoAddress2_SalesInvoiceHeader; "Purchase Header"."Buy-from Address 2")
            {
            }
            column(SelltoCity_SalesInvoiceHeader; "Purchase Header"."Buy-from City")
            {
            }
            column(CurrCode; CurrCode)
            {
            }
            column(TaxLbl; TaxLbl)
            {
            }
            column(PurchaseCode; SalespersonPurchaser.Name)
            {
            }
            column(Dept; "Purchase Header"."Shortcut Dimension 1 Code")
            {
            }
            column(VATAmount; VATAmount)
            {
            }
            column(CustVATRegNo; Vendor."VAT Registration No.")
            {
            }
            column(PaymentTermsCode_PurchaseHeader; PaymentTerms.Description)
            {
            }
            column(Advance; Advance)
            {
            }
            column(ShipmentMethodCode_PurchaseHeader; "Purchase Header"."Shipment Method Code")
            {
            }
            column(OrderDate; "Purchase Header"."Order Date")
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
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
                column(UnitPrice_SalesInvoiceLine; "Purchase Line"."Unit Cost")
                {
                }
                column(Comment_SalesCommentLine; CommentLine)
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
                var
                    txtCRLF: array[2] of Char;
                begin
                    Sn += 1;
                    //CLEAR(ItemDesc );
                    clear(CommentLine);
                    VarMessage[1] := 10;
                    SCL.SetCurrentKey("Line No.");
                    SCL.Ascending(false);
                    SCL.SETRANGE("Document Line No.", "Line No.");
                    SCL.SETRANGE("No.", "Document No.");
                    SCL.SETRANGE("Document Type", SCL."Document Type"::Order);
                    if SCL.FINDFIRST() then
                        repeat
                            CommentLine := SCL.Comment + VarMessage + CommentLine;
                        until SCL.NEXT() = 0;
                    Clear(SSCLTaxAmount);
                    Clear(VATAmnt);
                    Clear(SSCLTaxText);
                    Clear(VATTaxText);
                    if not (("Tax Area Code" = '') and ("Tax Group Code" = '')) then CalTaxOnTax("Tax Group Code", "Tax Area Code", Amount, "Purchase Header"."Posting Date", SSCLTaxAmount, VATAmnt, SSCLTaxText, VATTaxText);
                    TotalSSCLTaxAmount += SSCLTaxAmount;
                    TotalVatAmount += VATAmnt;
                end;
            }
            trigger OnAfterGetRecord();
            begin
                if "Currency Code" = '' then
                    CurrCode := 'LKR'
                else
                    CurrCode := "Currency Code";
                //temperory
                TaxLbl := 'VAT 18%';
                if "Posting Date" < 20220601D then
                    TaxLbl := 'VAT 8%'
                else if "Posting Date" < 20220901D then
                    TaxLbl := 'VAT 12%'
                else if "Posting Date" < 20240101D then TaxLbl := 'VAT 15%';
                //DocumentTotals.CalculatePostedSalesInvoiceTotals(TotalSalesInvoiceHeader,VATAmount,"Sales Invoice Line");
                VATAmount := "Amount Including VAT" - Amount;
                Vendor.GET("Purchase Header"."Buy-from Vendor No.");
                "Company Information".GET();
                "Company Information".CALCFIELDS(Picture);
                CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment);
                /*CustLedgerEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                            IF CustLedgerEntry.FINDFIRST THEN BEGIN
                              CustLedgerEntry.CALCFIELDS(Amount);
                              Advance := ABS(CustLedgerEntry.Amount);
                            END;
                            */
                if SalespersonPurchaser.GET("Purchase Header"."Purchaser Code") then;
                if PaymentTerms.Get("Purchase Header"."Payment Terms Code") then;
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
        PaymentTerms: Record "Payment Terms";
        CurrCode: Code[10];
        TaxLbl: Text;
        DocumentTotals: Codeunit "Document Totals";
        VATAmount: Decimal;
        TotalSalesInvoiceHeader: Record "Sales Invoice Header";
        Vendor: Record Vendor;
        Sn: Integer;
        "Company Information": Record "Company Information";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Advance: Decimal;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        ShowEmailSignature: Boolean;
        ItemLedgerEntry: Record "Item Ledger Entry";
        SerialNo: Text[1024];
        SerialCount: Integer;
        DesCount: Integer;
        SSL: Record "Sales Shipment Line";
        ItemDesc: Text;
        SCL: Record "Purch. Comment Line";
        CommentLine: Text;
        VarMessage: Text;
        SSCLTaxAmount: Decimal;
        TotalSSCLTaxAmount: Decimal;
        VATAmnt: Decimal;
        TotalVatAmount: Decimal;
        SSCLTaxText: Text;
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
                    if TaxALine."Tax Jurisdiction Code" = 'VAT' then begin
                        VATAmt := (CalAmt + SSCLAmt) * TaxDetail."Tax Below Maximum" / 100;
                        VATPerText := 'VAT ' + Format(Round(TaxDetail."Tax Below Maximum", 0.01, '=')) + ' %';
                    end;
                end;
            until TaxALine.Next() = 0;
    end;
}
