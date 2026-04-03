report 50101 "Cust. Sales Statictics"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Customer - Sales Statistics';
    ApplicationArea = all;
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\Cus_Sales_Stat.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = sorting(Number) WHERE(Number = FILTER(1 ..));

            column(Doc_Type; TempSalesLine."Document Type")
            {
            }
            column(Doc_No; TempSalesLine."Document No.")
            {
            }
            column(Customer_No_; CustLedgerEntry."Customer No.")
            {
            }
            column(Customer_Name; CustLedgerEntry."Customer Name")
            {
            }
            column(Salesperson_Code; CustLedgerEntry."Salesperson Code")
            {
            }
            column(Posting_Date; CustLedgerEntry."Posting Date")
            {
            }
            column(Amount; Amt)
            {
            }
            column(Amount__LCY_; AmtLCY)
            {
            }
            column(Currency_Code; CustLedgerEntry."Currency Code")
            {
            }
            column(Profit__LCY_; CustLedgerEntry."Profit (LCY)")
            {
            }
            column(Document_No_; CustLedgerEntry."Document No.")
            {
            }
            column(Document_Type; CustLedgerEntry."Document Type")
            {
            }
            column(CostLCY; Cost)
            {
            }
            column(CompName; ComInfo.Name)
            {
            }
            trigger OnAfterGetRecord()
            var
                SalesInvHeader: Record "Sales Invoice Header";
                SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                Item: Record Item;
                getSalesLineOrderNo: Code[20];
            begin
                if Number = 1 then begin
                    if not TempSalesLine.Find('-') then
                        CurrReport.Break();
                end else
                    if TempSalesLine.Next = 0 then
                        CurrReport.Break();

                //TD(+)
                if TempSalesLine.Quantity = 0 then
                    CurrReport.Skip();
                //TD(-)

                Clear(Item);

                if PreviousDocNo <> TempSalesLine."Document No." then
                    ActiveFirstLine := false;

                PreviousDocNo := TempSalesLine."Document No.";

                if TempSalesLine.Type = TempSalesLine.Type::Item then
                    Item.Get(TempSalesLine."No.");

                getSalesLineOrderNo := TempSalesLine."Document No.";

                Clear(CustLedgerEntry);
                CustLedgerEntry.SetRange("Document No.", TempSalesLine."Document No.");
                if CustLedgerEntry.FindFirst then;

                //Get total of cost amount actual in value entry, related to document no.
                Clear(Cost);
                Clear(ValueEntry);
                ValueEntry.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Item No.");
                ValueEntry.SetFilter("Document Type", '%1|%2', ValueEntry."Document Type"::"Sales Invoice",
                        ValueEntry."Document Type"::"Sales Credit Memo");
                ValueEntry.SetRange("Document No.", TempSalesLine."Document No.");
                //ValueEntry.SetRange("Document Line No.", TempSalesLine."Return Receipt Line No.");
                ValueEntry.SetRange("Item No.", TempSalesLine."No.");//PV L
                ValueEntry.CalcSums("Cost Amount (Actual)");

                //if ValueEntry.FindFirst() then;
                if TempSalesLine."Shipment No." = 'MARKETING/RENTAL' //check department code to make cost zero //SJ210704 (SL.)
                then begin
                    Cost := 0
                end
                else begin
                    //if not ActiveFirstLine then PV L
                    Cost := ValueEntry."Cost Amount (Actual)";
                end;

                ActiveFirstLine := true; //SJ210704 (EL.)
                AmtLCY := TempSalesLine.Amount;
                if SalesInvHeader.Get(TempSalesLine."Document No.") then begin
                    Amt := TempSalesLine.Amount;
                    if SalesInvHeader."Currency Factor" <> 0 then
                        AmtLCY := TempSalesLine.Amount / SalesInvHeader."Currency Factor";
                    //Get Cost
                    if Item.Type <> Item.Type::Inventory then begin
                        Cost := 0;
                        if SalesInvHeader."Order No." <> '' then
                            Cost := GetCostofNonInvItems(SalesInvHeader."Order No.", TempSalesLine."No.", false, '', TempSalesLine.Quantity);
                    end;
                end;

                if SalesCrMemoHeader.Get(TempSalesLine."Document No.") then begin
                    Amt := TempSalesLine.Amount * -1;
                    if SalesCrMemoHeader."Currency Factor" <> 0 then
                        AmtLCY := (TempSalesLine.Amount / SalesCrMemoHeader."Currency Factor") * -1
                    else
                        AmtLCY := TempSalesLine.Amount * -1;
                    //Get Cost
                    if Item.Type <> Item.Type::Inventory then begin
                        Cost := 0;
                        Cost := GetCostofNonInvItems('', TempSalesLine."No.", true, TempSalesLine."Document No.", TempSalesLine.Quantity) * -1;
                    end;
                end;
                if TempSalesLine."Gen. Prod. Posting Group" = 'FATRF' then
                    Cost := 0;
            end;

            trigger OnPreDataItem()
            begin
                //Init Filters
                Clear(TempSalesLine);
                if (StartDate <> 0D) and (ToDate <> 0D) then
                    TempSalesLine.SetRange("FA Posting Date", StartDate, ToDate);
                if (StartDate = 0D) and (ToDate <> 0D) then
                    TempSalesLine.SetFilter("FA Posting Date", '..%1', ToDate);
                if (StartDate <> 0D) and (ToDate = 0D) then
                    TempSalesLine.SetFilter("FA Posting Date", '%1..', StartDate);

                if PostingGroup <> '' then
                    TempSalesLine.SetRange("Gen. Bus. Posting Group", PostingGroup);
                if SalesPerson <> '' then
                    TempSalesLine.SetRange("Tax Group Code", SalesPerson);
                if Dim3 <> '' then
                    TempSalesLine.SetRange("Shortcut Dimension 1 Code", Dim3);
                if Dim4 <> '' then
                    TempSalesLine.SetRange("Shortcut Dimension 2 Code", Dim4);
                //TempSalesLine.SetRange("Document No.", 'PSI-22/23-0999');
                //TempSalesLine.SetCurrentKey("Posting Date");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(SalesPerson; SalesPerson)
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Person';
                        TableRelation = "Salesperson/Purchaser";
                    }
                    field(PostingGroup; PostingGroup)
                    {
                        Caption = 'Gen. Bus. Posting Group';
                        ApplicationArea = All;
                        TableRelation = "Gen. Business Posting Group";
                    }
                    field(Dim3; Dim3)
                    {
                        Caption = 'CUSTOMER GROUP';
                        ApplicationArea = All;
                        TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('CUSTOMER GROUP'));
                    }
                    field(Dim4; Dim4)
                    {
                        Caption = 'CUSTOMER SUBGROUP';
                        ApplicationArea = All;
                        TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('CUSTOMER SUBGROUP'));
                    }
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if ToDate = 0D then
                                ToDate := StartDate;
                        end;
                    }
                    field(ToDate; ToDate)
                    {
                        Caption = 'End Date';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        SalesInvLines: Record "Sales Invoice Line";
        SalesCrMemoLines: Record "Sales Cr.Memo Line";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesCrHdr: Record "Sales Cr.Memo Header";
        DimSetEntry: Record "Dimension Set Entry";
        GenLedgerSetup: Record "General Ledger Setup";
        Inx: Integer;
        CustGroupDim: Code[20];
        CustSubGroupDim: Code[20];
        DepartDimCode: Code[20]; //SJ210704
    begin
        GenLedgerSetup.Get;
        Clear(SalesInvLines);
        //SalesInvLines.SetRange("Document No.", 'PSI-22/23-0357');
        SalesInvLines.SetFilter("No.", '<>%1', '');
        if SalesInvLines.FindSet then
            repeat
                Clear(CustGroupDim);
                Clear(CustSubGroupDim);
                Clear(SalesInvHdr);
                Clear(DepartDimCode);

                SalesInvHdr.Get(SalesInvLines."Document No.");
                if DimSetEntry.Get(SalesInvHdr."Dimension Set ID", GenLedgerSetup."Shortcut Dimension 3 Code") then
                    CustGroupDim := DimSetEntry."Dimension Value Code";
                if DimSetEntry.Get(SalesInvHdr."Dimension Set ID", GenLedgerSetup."Shortcut Dimension 4 Code") then
                    CustSubGroupDim := DimSetEntry."Dimension Value Code";
                if DimSetEntry.Get(SalesInvHdr."Dimension Set ID", GenLedgerSetup."Shortcut Dimension 1 Code") then //SJ210704
                    DepartDimCode := DimSetEntry."Dimension Value Code";

                Inx += 10000;
                Clear(TempSalesLine);
                TempSalesLine.Init;
                //TempSalesLine.TransferFields(SalesInvLines);
                TempSalesLine."Document Type" := TempSalesLine."Document Type"::Invoice;
                TempSalesLine."Document No." := SalesInvLines."Document No.";
                TempSalesLine."Line No." := Inx;
                //TempSalesLine."Return Receipt Line No." := SalesInvLines."Line No."; //SJ210901
                TempSalesLine.Type := SalesInvLines.Type;
                TempSalesLine."No." := SalesInvLines."No.";
                TempSalesLine.Quantity := SalesInvLines.Quantity;
                TempSalesLine.Amount := SalesInvLines.Amount;
                TempSalesLine."FA Posting Date" := SalesInvHdr."Posting Date";//Posting Date
                TempSalesLine."Gen. Bus. Posting Group" := SalesInvLines."Gen. Bus. Posting Group";
                TempSalesLine."Tax Group Code" := SalesInvHdr."Salesperson Code";//Insert sales person code
                TempSalesLine."Shortcut Dimension 1 Code" := CustGroupDim;//Insert Dim3
                TempSalesLine."Shortcut Dimension 2 Code" := CustSubGroupDim;//Insert Dim4
                TempSalesLine."Shipment No." := DepartDimCode; //Insert department dimention code //SJ210704
                TempSalesLine."Gen. Prod. Posting Group" := SalesInvLines."Gen. Prod. Posting Group";
                TempSalesLine.Insert;
            until SalesInvLines.Next = 0;

        Clear(SalesCrMemoLines);
        SalesCrMemoLines.SetFilter("No.", '<>%1', '');
        if SalesCrMemoLines.FindSet then
            repeat
                Clear(CustGroupDim);
                Clear(CustSubGroupDim);
                Clear(DepartDimCode);
                SalesCrHdr.Get(SalesCrMemoLines."Document No.");
                if DimSetEntry.Get(SalesCrHdr."Dimension Set ID", GenLedgerSetup."Shortcut Dimension 3 Code") then
                    CustGroupDim := DimSetEntry."Dimension Value Code";
                if DimSetEntry.Get(SalesCrHdr."Dimension Set ID", GenLedgerSetup."Shortcut Dimension 4 Code") then
                    CustSubGroupDim := DimSetEntry."Dimension Value Code";
                if DimSetEntry.Get(SalesCrHdr."Dimension Set ID", GenLedgerSetup."Shortcut Dimension 1 Code") then //SJ210704
                    DepartDimCode := DimSetEntry."Dimension Value Code";

                Inx += 10000;
                Clear(TempSalesLine);
                TempSalesLine.Init;
                //TempSalesLine.TransferFields(SalesCrMemoLines);
                TempSalesLine."Document Type" := TempSalesLine."Document Type"::"Credit Memo";
                TempSalesLine."Document No." := SalesCrMemoLines."Document No.";
                TempSalesLine."Line No." := Inx;
                //TempSalesLine."Return Receipt Line No." := SalesInvLines."Line No."; //SJ210901
                TempSalesLine.Type := SalesCrMemoLines.Type;
                TempSalesLine."No." := SalesCrMemoLines."No.";
                TempSalesLine.Quantity := SalesCrMemoLines.Quantity;
                TempSalesLine.Amount := SalesCrMemoLines.Amount;
                TempSalesLine."FA Posting Date" := SalesCrHdr."Posting Date";//Posting Date
                TempSalesLine."Gen. Bus. Posting Group" := SalesCrMemoLines."Gen. Bus. Posting Group";
                TempSalesLine."Tax Group Code" := SalesCrHdr."Salesperson Code";//Insert sales person code
                TempSalesLine."Shortcut Dimension 1 Code" := CustGroupDim;//Insert Dim3
                TempSalesLine."Shortcut Dimension 2 Code" := CustSubGroupDim;//Insert Dim4
                TempSalesLine."Shipment No." := DepartDimCode; //Insert department dimention code //SJ210704
                TempSalesLine."Gen. Prod. Posting Group" := SalesCrMemoLines."Gen. Prod. Posting Group";
                TempSalesLine.Insert;
            until SalesCrMemoLines.Next = 0;
    end;

    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CreateCustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ComInfo: Record "Company Information";
        ValueEntry: Record "Value Entry";
        AmtLCY: Decimal;
        Amt: Decimal;
        Cost: Decimal;
        TempSalesLine: Record "Sales Line" temporary;
        //Req page fields
        SalesPerson: Code[20];
        StartDate: Date;
        ToDate: Date;
        PostingGroup: Code[20];
        Dim3: Code[20];
        Dim4: Code[20];
        ActiveFirstLine: Boolean;
        PreviousDocNo: Code[20];

    local procedure GetAppliedInvoiceForCrMemo(DocNo: Code[20]): Code[20]
    begin
        Clear(CustLedgEntry);
        Clear(CreateCustLedgEntry);
        CreateCustLedgEntry.SetCurrentKey("Entry No.");
        CreateCustLedgEntry.Setrange("Document No.", DocNo);
        IF not CreateCustLedgEntry.FindFirst THEN
            exit;

        FindApplnEntriesDtldtLedgEntry;
        CustLedgEntry.SETCURRENTKEY("Entry No.");
        CustLedgEntry.SETRANGE("Entry No.");

        IF CreateCustLedgEntry."Closed by Entry No." <> 0 THEN BEGIN
            CustLedgEntry."Entry No." := CreateCustLedgEntry."Closed by Entry No.";
            CustLedgEntry.MARK(TRUE);
        END;

        CustLedgEntry.SETCURRENTKEY("Closed by Entry No.");
        CustLedgEntry.SETRANGE("Closed by Entry No.", CreateCustLedgEntry."Entry No.");
        IF CustLedgEntry.FIND('-') THEN
            REPEAT
                CustLedgEntry.MARK(TRUE);
            UNTIL CustLedgEntry.NEXT = 0;

        CustLedgEntry.SETCURRENTKEY("Entry No.");
        CustLedgEntry.SETRANGE("Closed by Entry No.");

        CustLedgEntry.MARKEDONLY(TRUE);
        CustLedgEntry.SetRange("Document Type", CustLedgEntry."Document Type"::Invoice);
        if CustLedgEntry.FindFirst then
            exit(CustLedgEntry."Document No.");
        exit('');
    end;

    local procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry1.SETCURRENTKEY("Cust. Ledger Entry No.");
        DtldCustLedgEntry1.SETRANGE("Cust. Ledger Entry No.", CreateCustLedgEntry."Entry No.");
        DtldCustLedgEntry1.SETRANGE(Unapplied, FALSE);
        IF DtldCustLedgEntry1.FIND('-') THEN
            REPEAT
                IF DtldCustLedgEntry1."Cust. Ledger Entry No." =
                   DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
                THEN BEGIN
                    DtldCustLedgEntry2.INIT;
                    DtldCustLedgEntry2.SETCURRENTKEY("Applied Cust. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry2.SETRANGE(
                      "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    DtldCustLedgEntry2.SETRANGE("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                    DtldCustLedgEntry2.SETRANGE(Unapplied, FALSE);
                    IF DtldCustLedgEntry2.FIND('-') THEN
                        REPEAT
                            IF DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                               DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                            THEN BEGIN
                                CustLedgEntry.SETCURRENTKEY("Entry No.");
                                CustLedgEntry.SETRANGE("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                IF CustLedgEntry.FIND('-') THEN
                                    CustLedgEntry.MARK(TRUE);
                            END;
                        UNTIL DtldCustLedgEntry2.NEXT = 0;
                END ELSE BEGIN
                    CustLedgEntry.SETCURRENTKEY("Entry No.");
                    CustLedgEntry.SETRANGE("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    IF CustLedgEntry.FIND('-') THEN
                        CustLedgEntry.MARK(TRUE);
                END;
            UNTIL DtldCustLedgEntry1.NEXT = 0;
    end;

    local procedure GetCostofNonInvItems(OrderNo: Code[20]; ItemNo: code[20]; IsCreditMemo: Boolean; DocNo: Code[20]; Qty: Decimal): Decimal
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        SalesInvHeader: Record "Sales Invoice Header";
        InvNo: Code[20];
        SignConversion: Integer;
        CostAmt: Decimal;
    begin
        //Message((Format(ItemNo)) + ' ' + Format(OrderNo));
        SignConversion := -1;
        if IsCreditMemo then begin
            //SignConversion := 1;
            InvNo := '';
            InvNo := GetAppliedInvoiceForCrMemo(DocNo);
            if InvNo = '' then
                exit(0);
            Clear(SalesInvHeader);
            SalesInvHeader.SetRange("No.", InvNo);
            if SalesInvHeader.FindFirst then
                OrderNo := SalesInvHeader."Order No."
            else
                exit(0);
        end;

        Clear(PurchaseHeader);
        PurchaseHeader.SetRange("Sales Order No. 4HC", OrderNo);
        if PurchaseHeader.FindFirst then begin
            repeat
                Clear(PurchaseLine);
                PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                PurchaseLine.SetRange("No.", ItemNo);
                if PurchaseLine.FindFirst then begin
                    if PurchaseHeader."Currency Factor" <> 0 then
                        CostAmt := (((PurchaseLine."Unit Cost" * Qty) / PurchaseHeader."Currency Factor") * SignConversion)
                    else
                        CostAmt := ((PurchaseLine."Unit Cost" * Qty) * SignConversion);
                    exit(CostAmt);
                end;
            until PurchaseHeader.Next() = 0;
        end
        else begin
            Clear(PurchInvHeader);
            PurchInvHeader.SetRange("Sales Order No. 4HC", OrderNo);
            if PurchInvHeader.FindFirst then begin
                repeat
                    Clear(PurchInvLine);
                    PurchInvLine.SetRange("Document No.", PurchInvHeader."No.");
                    PurchInvLine.SetRange("No.", ItemNo);
                    if PurchInvLine.FindFirst then begin
                        if PurchInvHeader."Currency Factor" <> 0 then
                            CostAmt := (((PurchInvLine."Unit Cost" * Qty) / PurchInvHeader."Currency Factor") * SignConversion)
                        else
                            CostAmt := ((PurchInvLine."Unit Cost" * Qty) * SignConversion);
                        exit(CostAmt);
                    end;
                until PurchInvHeader.Next() = 0;
            end;
        end;
    end;
}