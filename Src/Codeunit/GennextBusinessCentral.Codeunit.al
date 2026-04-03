codeunit 50103 "4HC Business Central"
{
    Permissions = tabledata "Purch. Inv. Header" = rimd,
               tabledata "Purch. Rcpt. Header" = rimd,
               tabledata "Return Shipment Header" = rimd,
               tabledata "Purch. Cr. Memo Hdr." = rimd,
               tabledata "Sales Cr.Memo Header" = rimd,
               tabledata "Sales Invoice Header" = rimd,
               tabledata "Return Receipt Header" = rimd,
               tabledata "Sales Shipment Header" = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company Triggers", 'OnCompanyOpenCompleted', '', false, false)]
    local procedure OnCompanyOpenCompleted();
    var
        UserDeviation: Record UserDeviation;
        SalesPerson: Record "Salesperson/Purchaser";
        AllProfile: Record "All Profile";
        ConfPersonMgt: Codeunit "Conf./Personalization Mgt.";
    begin
        if UserDeviation.Get(SessionId()) then
            if SalesPerson.Get(UserDeviation.Salesperson) then begin
                AllProfile.Reset();
                AllProfile.SetRange("Profile ID", SalesPerson."SP Profile");
                if AllProfile.FindFirst() then
                    ConfPersonMgt.SetCurrentProfile(AllProfile);
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnBeforeRunSalesPost, '', false, false)]
    local procedure "Sales-Post (Yes/No)_OnBeforeRunSalesPost"(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; var SuppressCommit: Boolean)
    begin
        SalesHeader.TestField("Salesperson Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnBeforeOnRun, '', false, false)]
    local procedure "Sales-Post (Yes/No)_OnBeforeOnRun"(var SalesHeader: Record "Sales Header")
    begin

        this.CheckSalesDocumentReleased(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post + Print", OnBeforeOnRun, '', false, false)]
    local procedure "Sales-Post + Print_OnBeforeOnRun"(var SalesHeader: Record "Sales Header")
    begin
        this.CheckSalesDocumentReleased(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post and Send", OnBeforePostAndSend, '', false, false)]
    local procedure "Sales-Post and Send_OnBeforePostAndSend"(var SalesHeader: Record "Sales Header"; var HideDialog: Boolean; var TempDocumentSendingProfile: Record "Document Sending Profile" temporary)
    begin
        this.CheckSalesDocumentReleased(SalesHeader);
    end;

    local procedure CheckSalesDocumentReleased(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.TestField(Status, SalesHeader.Status::Released);
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            SalesHeader.TestField("Purchase Order No. 4HC");
    end;

    procedure CalculateMonthlyAchievmentAndGP(var SPTarget: Record "4HC Salesperson Target")
    var
        RevenueGLEntry: Record "G/L Entry";
        CostGLEntry: Record "G/L Entry";
    begin
        SPTarget."Monthly Achivement" := 0;
        SPTarget."Monthly Cost" := 0;
        SPTarget."Monthly GP" := 0;
        SPTarget."Balance GP to Achieve" := 0;
        SPTarget."GP %" := 0;
        SPTarget."Balance Target to Achieve" := 0;

        RevenueGLEntry.Reset();
        RevenueGLEntry.SetLoadFields(Amount, "Salesperson Code");
        // GLEntry.SetRange("Item Ledger Entry Type", GLEntry."Item Ledger Entry Type"::Sale);
        // GLEntry.SetFilter("Document Type", '%1|%2', GLEntry."Document Type"::"Sales Invoice", GLEntry."Document Type"::"Sales Credit Memo");
        RevenueGLEntry.SetRange("Posting Date", SPTarget."Start Date", SPTarget."End Date");
        RevenueGLEntry.SetRange("Global Dimension 1 Code", SPTarget."Shortcut Dimension 1 Code");
        RevenueGLEntry.SetRange("Salesperson Code", SPTarget."Salesperson Code");
        RevenueGLEntry.SetFilter("G/L Account No.", '2100005|2100015');
        if RevenueGLEntry.FindSet() then
            repeat
                SPTarget."Monthly Achivement" += RevenueGLEntry.Amount;
            until RevenueGLEntry.Next() = 0;

        CostGLEntry.Reset();
        CostGLEntry.SetLoadFields(Amount, "Salesperson Code");
        CostGLEntry.SetRange("Posting Date", SPTarget."Start Date", SPTarget."End Date");
        CostGLEntry.SetRange("Global Dimension 1 Code", SPTarget."Shortcut Dimension 1 Code");
        CostGLEntry.SetRange("Salesperson Code", SPTarget."Salesperson Code");
        CostGLEntry.SetFilter("G/L Account No.", '2300005');
        if CostGLEntry.FindSet() then
            repeat
                SPTarget."Monthly Cost" += CostGLEntry.Amount;
            until CostGLEntry.Next() = 0;

        SPTarget."Balance Target to Achieve" := SPTarget."Monthly Target" - Abs(SPTarget."Monthly Achivement");
        SPTarget."Monthly GP" := Abs(SPTarget."Monthly Achivement") - Abs(SPTarget."Monthly Cost");
        SPTarget."Balance GP to Achieve" := SPTarget."Monthly GP Target" - SPTarget."Monthly GP";
        if SPTarget."Monthly Achivement" <> 0 then
            SPTarget."GP %" := (SPTarget."Monthly GP" / SPTarget."Monthly Achivement") * 100
        else
            SPTarget."GP %" := 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Pipeline Chart Mgt.", OnGetOppEntryCountOnBeforeCount, '', false, false)]
    local procedure "Sales Pipeline Chart Mgt._OnGetOppEntryCountOnBeforeCount"(var OppEntry: Record "Opportunity Entry")
    begin
        OpportunityFilteration(OppEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Pipeline Chart Mgt.", OnBeforeDrillDown, '', false, false)]
    local procedure "Sales Pipeline Chart Mgt._OnBeforeDrillDown"(var OppEntry: Record "Opportunity Entry")
    begin
        OpportunityFilteration(OppEntry);
    end;

    local procedure OpportunityFilteration(var OppEntry: Record "Opportunity Entry")
    var
        UserDiv: Record UserDeviation;
        Salesperson: Record "Salesperson/Purchaser";
        SalePersonSupervisor: Record "Salesperson/Purchaser";
        Filter: Text;
        Text0001Err: Label 'Please complete the authentication process to proceed with your task.';
    begin
        OppEntry.FilterGroup(19);
        if UserDiv.Get(SessionId()) then begin
            if Salesperson.Get(UserDiv.Salesperson) then begin
                if Salesperson.UserLevel = Salesperson.UserLevel::User then
                    OppEntry.SetRange("Salesperson Code", Salesperson.Code)
                else
                    if Salesperson.UserLevel = Salesperson.UserLevel::Supervisor then begin
                        Filter := UserDiv.Salesperson;
                        SalePersonSupervisor.SetRange(Supervisor, UserDiv.Salesperson);
                        if SalePersonSupervisor.FindSet() then
                            repeat
                                if Filter <> '' then
                                    Filter := Filter + '|' + SalePersonSupervisor.Code;
                            until SalePersonSupervisor.Next() = 0;
                        OppEntry.SetFilter("Salesperson Code", Filter);
                    end;

                if Salesperson."Global Dimension 1 Code" <> '' then
                    if (Salesperson.UserLevel = Salesperson.UserLevel::SeniorManager) or (Salesperson.UserLevel = Salesperson.UserLevel::Coordinator) then
                        OppEntry.SetRange("Shortcut Dimension 1 Lookup", Salesperson."Global Dimension 1 Code");
            end;
        end
        else
            Error(Text0001Err);
        OppEntry.FilterGroup(0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
    local procedure CopyFromItemLedEntry(ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        ItemLedgerEntry."Gennext User" := GetCurrentLoginUser();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnRunOnBeforeFinalizePosting, '', false, false)]
    local procedure "Sales-Post_OnRunOnBeforeFinalizePosting"(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; GenJnlLineExtDocNo: Code[35]; var EverythingInvoiced: Boolean; GenJnlLineDocNo: Code[20]; SrcCode: Code[10]; PreviewMode: Boolean)
    begin
        if SalesShipmentHeader."No." <> '' then begin
            SalesShipmentHeader."Gennext User" := GetCurrentLoginUser();
            SalesShipmentHeader.Modify();
        end;
        if SalesInvoiceHeader."No." <> '' then begin
            SalesInvoiceHeader."Gennext User" := GetCurrentLoginUser();
            SalesInvoiceHeader.Modify();
        end;
        if SalesCrMemoHeader."No." <> '' then begin
            SalesCrMemoHeader."Gennext User" := GetCurrentLoginUser();
            SalesCrMemoHeader.Modify();
        end;
        if ReturnReceiptHeader."No." <> '' then begin
            ReturnReceiptHeader."Gennext User" := GetCurrentLoginUser();
            ReturnReceiptHeader.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnRunOnBeforeFinalizePosting, '', false, false)]
    local procedure "Purch.-Post_OnRunOnBeforeFinalizePosting"(var PurchaseHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShipmentHeader: Record "Return Shipment Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean)
    begin
        if PurchRcptHeader."No." <> '' then begin
            PurchRcptHeader."Gennext User" := GetCurrentLoginUser();
            PurchRcptHeader.Modify();
        end;
        if PurchInvHeader."No." <> '' then begin
            PurchInvHeader."Gennext User" := GetCurrentLoginUser();
            PurchInvHeader.Modify();
        end;
        if PurchCrMemoHdr."No." <> '' then begin
            PurchCrMemoHdr."Gennext User" := GetCurrentLoginUser();
            PurchCrMemoHdr.Modify();
        end;
        if ReturnShipmentHeader."No." <> '' then begin
            ReturnShipmentHeader."Gennext User" := GetCurrentLoginUser();
            ReturnShipmentHeader.Modify();
        end;
    end;

    procedure GetCurrentLoginUser(): Code[20]
    var
        UserDiv: Record UserDeviation;
    begin
        if UserDiv.Get(SessionId()) then
            exit(UserDiv.Salesperson)
        else
            exit('');
    end;

    procedure PermissionCheck(TableID: Integer; PermissionType: Enum "4HC Gennext Permission")
    var
        GNPermission: Record "4HC Gennext Permission";
        AccessDenyErr: Label 'You don''t have permission to perform this action. Please contact your system administrator.';
    begin
        if GNPermission.Get(this.GetCurrentLoginUser(), TableID) then
            case PermissionType of
                PermissionType::Insert:
                    if not GNPermission.Insert then
                        Error(AccessDenyErr);
                PermissionType::Modify:
                    if not GNPermission.Modify then
                        Error(AccessDenyErr);
                PermissionType::Delete:
                    if not GNPermission.Delete then
                        Error(AccessDenyErr);
                PermissionType::Read:
                    if not GNPermission.Read then
                        Error(AccessDenyErr);
            end
        else
            Error(AccessDenyErr);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnValidateSellToCustomerNoOnAfterTestStatusOpen, '', false, false)]
    local procedure "Sales Header_OnValidateSellToCustomerNoOnAfterTestStatusOpen"(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        Customer: Record Customer;
    begin
        // Customer.Get(SalesHeader."Sell-to Customer No.");
        // if Customer."Tax Liable" then
        //     Customer.TestField("VAT Registration No.");
    end;
}