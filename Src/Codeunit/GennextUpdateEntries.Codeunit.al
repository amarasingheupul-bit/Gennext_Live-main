codeunit 50111 "4HC Gennext Update Entries"
{
    Permissions = tabledata "Sales Invoice Line" = RM,
                  tabledata "Sales Cr.Memo Line" = RM,
                  tabledata "Item Ledger Entry" = RM,
                  tabledata "Purch. Cr. Memo Line" = RM,
                  tabledata "Purch. Inv. Line" = RM,
                  tabledata "Dimension Set Entry" = RMI,
                  tabledata "G/L Entry" = RM;
    procedure UpdateSalesPersonInGLEntry(var GLEntry: Record "G/L Entry"): Boolean
    var
        ValueEntry: Record "Value Entry";
    begin
        ValueEntry.Reset();
        ValueEntry.SetRange("Document No.", GLEntry."Document No.");
        ValueEntry.SetRange("Posting Date", GLEntry."Posting Date");
        if ValueEntry.FindFirst() then begin
            GLEntry."Salesperson Code" := ValueEntry."Salespers./Purch. Code";
            GLEntry.Modify();
            exit(true);
        end;
        exit(false);
    end;

    procedure UpdateSalesPersonInGLEntryFromExcel(var GLEntry: Record "G/L Entry"): Boolean
    begin
        if GLEntry."Salesperson Code" <> '' then begin
            GLEntry.Modify();
            exit(true);
        end;
        exit(false);
    end;

    procedure UpdateSalesPersonFromSalesInvHeaderInGLEntry(var GLEntry: Record "G/L Entry"): Boolean
    var
        SalesInvHeader: Record "Sales Invoice Header";
    begin
        SalesInvHeader.Reset();
        SalesInvHeader.SetRange("No.", GLEntry."Document No.");
        SalesInvHeader.SetRange("Posting Date", GLEntry."Posting Date");
        if SalesInvHeader.FindFirst() then begin
            GLEntry."Salesperson Code" := SalesInvHeader."Salesperson Code";
            GLEntry.Modify();
            exit(true);
        end;
        exit(false);
    end;

    procedure UpdateSalesPersonFromPurchaseInvHeaderInGLEntry(var GLEntry: Record "G/L Entry"): Boolean
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        SlaesInvHeader: Record "Sales Invoice Header";
        SalesHeaderArchive: Record "Sales Header Archive";
    begin
        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("No.", GLEntry."Document No.");
        PurchInvHeader.SetRange("Posting Date", GLEntry."Posting Date");
        if PurchInvHeader.FindFirst() then begin
            SlaesInvHeader.Reset();
            SlaesInvHeader.SetRange("Order No.", PurchInvHeader."Sales Order No. 4HC");
            if SlaesInvHeader.FindFirst() then begin
                GLEntry."Salesperson Code" := SlaesInvHeader."Salesperson Code";
                GLEntry.Modify();
                exit(true);
            end
            else begin
                SalesHeaderArchive.Reset();
                SalesHeaderArchive.SetRange("Document Type", SalesHeaderArchive."Document Type"::Order);
                SalesHeaderArchive.SetRange("No.", PurchInvHeader."Sales Order No. 4HC");
                if SalesHeaderArchive.FindFirst() then begin
                    GLEntry."Salesperson Code" := SalesHeaderArchive."Salesperson Code";
                    GLEntry.Modify();
                    exit(true);
                end;
            end;
        end;
        exit(false);
    end;

    procedure UpdateItemDimension(var SalesInvoiceLine: Record "Sales Invoice Line")
    var
        Item: Record Item;
    begin
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
        if SalesInvoiceLine.FindSet() then
            repeat
                Item.Reset();
                if Item.Get(SalesInvoiceLine."No.") then
                    this.UpdateGLEntriesDimension(SalesInvoiceLine, Item);
            until SalesInvoiceLine.Next() = 0;
    end;

    local procedure UpdateGLEntriesDimension(var SalesInvLine: Record "Sales Invoice Line"; Item: Record Item)
    var
        GL: Record "G/L Entry";
        DimensionSetEntry: Record "Dimension Set Entry";
        GeneralLederSetup: Record "General Ledger Setup";
        DimensionSetID: Integer;
    begin
        DimensionSetID := 0;
        GeneralLederSetup.Get();
        GL.Reset();
        GL.SetRange("Document No.", SalesInvLine."Document No.");
        GL.SetRange("Posting Date", SalesInvLine."Posting Date");
        if GL.FindSet() then
            repeat
                GL."Global Dimension 2 Code" := Item."Global Dimension 2 Code";
                GL.Modify();
                if DimensionSetID = 0 then
                    if GL."G/L Account No." = '2300005' then
                        DimensionSetID := GL."Dimension Set ID";
            until GL.Next() = 0;
        if Item."Shortcut Dimension 4 Code" <> '' then begin
            DimensionSetEntry.Reset();
            if not DimensionSetEntry.Get(DimensionSetID, GeneralLederSetup."Shortcut Dimension 4 Code") then begin
                DimensionSetEntry.Init();
                DimensionSetEntry."Dimension Set ID" := DimensionSetID;
                DimensionSetEntry.Validate("Dimension Code", GeneralLederSetup."Shortcut Dimension 4 Code");
                DimensionSetEntry.Validate("Dimension Value Code", Item."Shortcut Dimension 4 Code");
                DimensionSetEntry.Insert(true);
            end
            else begin
                DimensionSetEntry.Validate("Dimension Value Code", Item."Shortcut Dimension 4 Code");
                DimensionSetEntry.Modify(true)
            end;
        end;
        SalesInvLine."Shortcut Dimension 2 Code" := Item."Global Dimension 2 Code";
        SalesInvLine."GL Dim Updated" := true;
        SalesInvLine.Modify();
    end;

    procedure UpdateItemDimensionCreditNote()
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        Item: Record Item;
    begin
        SalesCrMemoLine.Reset();
        SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::Item);
        if SalesCrMemoLine.FindSet() then
            repeat
                Item.Reset();
                if Item.Get(SalesCrMemoLine."No.") then
                    this.UpdateGLEntriesDimensionCreditNote(SalesCrMemoLine, Item);
            until SalesCrMemoLine.Next() = 0;
    end;

    local procedure UpdateGLEntriesDimensionCreditNote(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; Item: Record Item)
    var
        GL: Record "G/L Entry";
        DimensionSetEntry: Record "Dimension Set Entry";
        GeneralLederSetup: Record "General Ledger Setup";
    begin
        GeneralLederSetup.Get();
        GL.Reset();
        GL.SetRange("Document No.", SalesCrMemoLine."Document No.");
        GL.SetRange("Posting Date", SalesCrMemoLine."Posting Date");
        if GL.FindSet() then
            repeat
                GL."Global Dimension 2 Code" := Item."Global Dimension 2 Code";
                GL.Modify();
            until GL.Next() = 0;
        if Item."Shortcut Dimension 4 Code" <> '' then begin
            DimensionSetEntry.Reset();
            if not DimensionSetEntry.Get(GL."Dimension Set ID", GeneralLederSetup."Shortcut Dimension 4 Code") then begin
                DimensionSetEntry.Init();
                DimensionSetEntry."Dimension Set ID" := GL."Dimension Set ID";
                DimensionSetEntry.Validate("Dimension Code", GeneralLederSetup."Shortcut Dimension 4 Code");
                DimensionSetEntry.Validate("Dimension Value Code", Item."Shortcut Dimension 4 Code");
                DimensionSetEntry.Insert(true);
            end
            else begin
                DimensionSetEntry.Validate("Dimension Value Code", Item."Shortcut Dimension 4 Code");
                DimensionSetEntry.Modify(true)
            end;
        end;
        SalesCrMemoLine."Shortcut Dimension 2 Code" := Item."Global Dimension 2 Code";
        SalesCrMemoLine."GL Dim Updated" := true;
        SalesCrMemoLine.Modify();
    end;

    procedure UpdateDimensionPurchaseInvoice()
    var
        PurchInvLine: Record "Purch. Inv. Line";
        Item: Record Item;
    begin
        PurchInvLine.Reset();
        PurchInvLine.SetRange(Type, PurchInvLine.Type::Item);
        if PurchInvLine.FindSet() then
            repeat
                Item.Reset();
                if Item.Get(PurchInvLine."No.") then begin
                    this.UpdateGLEntriesDimensions(PurchInvLine."Document No.", PurchInvLine."Posting Date", Item);
                    PurchInvLine."Shortcut Dimension 2 Code" := Item."Global Dimension 2 Code";
                    PurchInvLine."GL Dim Updated" := true;
                    PurchInvLine.Modify();
                end;
            until PurchInvLine.Next() = 0;
    end;

    procedure UpdateDimensionPurchasCrMemoLine()
    var
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        Item: Record Item;
    begin
        PurchCrMemoLine.Reset();
        PurchCrMemoLine.SetRange(Type, PurchCrMemoLine.Type::Item);
        if PurchCrMemoLine.FindSet() then
            repeat
                Item.Reset();
                if Item.Get(PurchCrMemoLine."No.") then begin
                    this.UpdateGLEntriesDimensions(PurchCrMemoLine."Document No.", PurchCrMemoLine."Posting Date", Item);
                    PurchCrMemoLine."Shortcut Dimension 2 Code" := Item."Global Dimension 2 Code";
                    PurchCrMemoLine."GL Dim Updated" := true;
                    PurchCrMemoLine.Modify();
                end;
            until PurchCrMemoLine.Next() = 0;
    end;

    local procedure UpdateGLEntriesDimensions(DocNo: Code[20]; PostingDate: Date; Item: Record Item)
    var
        GL: Record "G/L Entry";
        DimensionSetEntry: Record "Dimension Set Entry";
        GeneralLederSetup: Record "General Ledger Setup";
    begin
        GeneralLederSetup.Get();
        GL.Reset();
        GL.SetRange("Document No.", DocNo);
        GL.SetRange("Posting Date", PostingDate);
        if GL.FindSet() then
            repeat
                GL."Global Dimension 2 Code" := Item."Global Dimension 2 Code";
                GL.Modify();
            until GL.Next() = 0;
        if Item."Shortcut Dimension 4 Code" <> '' then begin
            DimensionSetEntry.Reset();
            if not DimensionSetEntry.Get(GL."Dimension Set ID", GeneralLederSetup."Shortcut Dimension 4 Code") then begin
                DimensionSetEntry.Init();
                DimensionSetEntry."Dimension Set ID" := GL."Dimension Set ID";
                DimensionSetEntry.Validate("Dimension Code", GeneralLederSetup."Shortcut Dimension 4 Code");
                DimensionSetEntry.Validate("Dimension Value Code", Item."Shortcut Dimension 4 Code");
                DimensionSetEntry.Insert(true);
            end
            else begin
                DimensionSetEntry.Validate("Dimension Value Code", Item."Shortcut Dimension 4 Code");
                DimensionSetEntry.Modify(true)
            end;
        end;
    end;

    procedure CreateServiceItemDocuments(var ItemLedgerEntry: Record "Item Ledger Entry")
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        ServiceItem: Record "Service Item";
        ServiceSetup: Record "Service Mgt. Setup";
        PurchItemEntry: Record "Item Ledger Entry";
        Item: Record Item;
        Noseries: Codeunit "No. Series";
        SerialList: List of [Code[50]];
    begin
        ServiceSetup.Get();
        ItemLedgerEntry.SetCurrentKey("Entry Type", "Document Type", "Entry No.", "Serial No.");
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
        ItemLedgerEntry.SetFilter("Serial No.", '<>%1', ' ');
        ItemLedgerEntry.SetFilter("Shipped Qty. Not Returned", '<>%1', 0);
        ServiceItem.LockTable();
        if ItemLedgerEntry.FindSet() then
            repeat
                if not SerialList.Contains(ItemLedgerEntry."Serial No.") then begin
                    SerialList.Add(ItemLedgerEntry."Serial No.");
                    ServiceItem.Init();
                    ServiceItem."No." := Noseries.GetNextNo(ServiceSetup."Service Item Nos.");
                    ServiceItem.Description := ItemLedgerEntry.Description;
                    ServiceItem.Insert(true);

                    // Temporarily unblock item to allow Validate to proceed
                    if Item.Get(ItemLedgerEntry."Item No.") then
                        if Item.Blocked then begin
                            Item.Blocked := false;
                            Item.Modify();
                        end;

                    ServiceItem.Validate("Item No.", ItemLedgerEntry."Item No.");

                    // Re-block the item after validate
                    if Item.Get(ItemLedgerEntry."Item No.") then
                        if not Item.Blocked then begin
                            Item.Blocked := true;
                            Item.Modify();
                        end;

                    SalesShipmentHeader.Reset();
                    if SalesShipmentHeader.Get(ItemLedgerEntry."Document No.") then
                        ServiceItem."Description 2" := SalesShipmentHeader."Order No.";
                    ServiceItem.Validate("Customer No.", ItemLedgerEntry."Source No.");
                    ServiceItem.Validate("Sales/Serv. Shpt. Document No.", ItemLedgerEntry."Document No.");
                    ServiceItem.Validate("Serial No.", ItemLedgerEntry."Serial No.");
                    ServiceItem.Validate("Warranty Ending Date (Parts)", ItemLedgerEntry."Warranty Date");
                    PurchItemEntry.Reset();
                    PurchItemEntry.SetRange("Entry Type", PurchItemEntry."Entry Type"::Purchase);
                    PurchItemEntry.SetRange("Document Type", PurchItemEntry."Document Type"::"Purchase Receipt");
                    PurchItemEntry.SetRange("Serial No.", ItemLedgerEntry."Serial No.");
                    if PurchItemEntry.FindFirst() then
                        ServiceItem.Validate("Vendor No.", PurchItemEntry."Source No.");
                    ServiceItem.Modify();
                    ItemLedgerEntry."4HC Service Item Doc No." := ServiceItem."No.";
                    ItemLedgerEntry.Modify(true);
                end;
            until ItemLedgerEntry.Next() = 0;
    end;

    procedure ItemLedgerEntryUpdateForSerieal(var ItemLedgerEntry: Record "Item Ledger Entry"): Boolean;
    begin
        if ItemLedgerEntry.Open then begin
            ItemLedgerEntry.Open := false;
            ItemLedgerEntry.Modify();
            exit(true);
        end;
        exit(false);
    end;
}