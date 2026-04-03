report 50117 "Dispatch Advice"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Dispatch Advice2.rdl';
    UsageCategory = None;

    dataset
    {
        dataitem("Sales Shipment Header"; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ShowEmailSignature; ShowEmailSignature) { }
            column(ExternalDocumentNo_SalesInvoiceHeader; "External Document No.")
            {
            }
            column(No_SalesInvoiceHeader; "No.")
            {
            }
            column(SelltoCustomerName_SalesInvoiceHeader; "Sell-to Customer Name")
            {
            }
            column(PostingDate_SalesShipmentHeader; "Sales Shipment Header"."Posting Date")
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
            column(Ship_to_Name; "Ship-to Name")
            {
            }
            column(CurrCode; CurrCode)
            {
            }
            column(VATAmount; VATAmount)
            {
            }
            column(CustVATRegNo; Customer."VAT Registration No.")
            {
            }
            column(Advance; Advance)
            {
            }
            column(Contact; "Sell-to Contact")
            {
            }
            column(PaymentTermDesc; PaymentTerms.Description)
            {
            }
            dataitem("Sales Shipment Line"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(Sn; Sn)
                {
                }
                column(LineAmount_SalesInvoiceLine; Advance)
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
                column(SerialNo; SerialNo)
                {
                }
                column(Comment_SalesCommentLine; CommentLine)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Sn += 1;

                    CLEAR(SerialNo);
                    CLEAR(CommentLine);
                    ItemLedgerEntry.RESET();
                    ItemLedgerEntry.SETRANGE("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                    ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                    ItemLedgerEntry.SETRANGE("Document No.", "Sales Shipment Line"."Document No.");
                    ItemLedgerEntry.SETRANGE("Item No.", "Sales Shipment Line"."No.");
                    ItemLedgerEntry.SetRange("Document Line No.", "Sales Shipment Line"."Line No.");
                    if ItemLedgerEntry.FINDFIRST() then
                        repeat
                            SerialNo += ItemLedgerEntry."Serial No." + '   ';
                        until ItemLedgerEntry.NEXT() = 0;

                    VarMessage[1] := 10;
                    clear(CommentLine);
                    SCL.Ascending(false);
                    SCL.SETRANGE("Document Line No.", "Line No.");
                    SCL.SETRANGE("No.", "Document No.");
                    SCL.SETRANGE("Document Type", SCL."Document Type"::Shipment);
                    if SCL.FINDFIRST() then
                        repeat
                            CommentLine := SCL.Comment + VarMessage + CommentLine;
                        until SCL.NEXT() = 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                if "Currency Code" = '' then
                    CurrCode := 'LKR'
                else
                    CurrCode := "Currency Code";

                Customer.GET("Sell-to Customer No.");
                "Company Information".GET();
                "Company Information".CALCFIELDS(Picture);
                CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Payment);
                CustLedgerEntry.SETRANGE("Document No.", "Applies-to Doc. No.");
                if CustLedgerEntry.FINDFIRST() then begin
                    CustLedgerEntry.CALCFIELDS(Amount);
                    Advance := ABS(CustLedgerEntry.Amount);
                end;

                if PaymentTerms.GET("Payment Terms Code") then;
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
                    Caption = 'E-Mail Signature';
                    ToolTip = 'Specifies whether to show the e-mail signature.';
                }
            }
        }
    }

    var

        Customer: Record Customer;
        ItemLedgerEntry: Record "Item Ledger Entry";
        "Company Information": Record "Company Information";
        PaymentTerms: Record "Payment Terms";
        SCL: Record "Sales Comment Line";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Advance: Decimal;
        Sn: Integer;
        CurrCode: Code[10];
        VATAmount: Decimal;
        SerialNo: Text[50000];
        CommentLine: Text;
        VarMessage: Text;
        ShowEmailSignature: Boolean;
}