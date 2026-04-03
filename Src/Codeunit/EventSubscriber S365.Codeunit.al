codeunit 50100 "EventSubscriber S365"
{
    [EventSubscriber(ObjectType::Report, Report::"Standard Sales - Quote", OnHeaderOnAfterGetRecordOnAfterUpdateNoPrinted, '', false, false)]
    local procedure OnHeaderOnAfterGetRecordOnAfterUpdateNoPrinted(ReportInPreviewMode: Boolean; var SalesHeader: Record "Sales Header")
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Quote then
            if SalesHeader."No. Printed" > 0 then begin
                SalesHeader."Printed or Email S365" := true;
                SalesHeader.Modify();
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnBeforeValidateNo, '', false, false)]
    local procedure ValidateIncompatibleItems(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        SalesLineCheck: Record "Sales Line";
        ItemCombination: Record ServiceItemMatrixS365;
        ItemMatrixErr: Label 'Item %1 is incompatible with item %2.', Comment = '%1=Service Item 1,%2=Service Item 2';
    begin
        SalesLineCheck.Reset();
        SalesLineCheck.SetRange("Document Type", SalesLine."Document Type");
        SalesLineCheck.SetRange("Document No.", SalesLine."Document No.");
        if SalesLineCheck.FindSet() then
            repeat // Check for incompatible combinations
                if ItemCombination.Get(SalesLine."No.", SalesLineCheck."No.") or ItemCombination.Get(SalesLineCheck."No.", SalesLine."No.") then Error(ItemMatrixErr, SalesLine."No.", SalesLineCheck."No.");
            until SalesLineCheck.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order (Yes/No)", OnBeforeConfirmConvertToOrder, '', false, false)]
    local procedure "Sales-Quote to Order (Yes/No)_OnBeforeConfirmConvertToOrder"(SalesHeader: Record "Sales Header"; var Result: Boolean; var IsHandled: Boolean)
    var
        Jobs: Record Job;
        SalesLine: Record "Sales Line";
        Opportunity: Record Opportunity;
        Text001Err: Label 'Select a project template and create a project for this quote. The base opportunity sales cycle code is %1', Comment = '%1=Sales CycleCode';
    begin
        // Jobs.SetFilter("Use as TemplateS365", '%1', true);
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindFirst() then begin
            Jobs.SetRange("Quote Type S365", SalesLine.QuoteType);
            if Page.RunModal(Page::ProjectTemplateS365, Jobs) = Action::LookupOK then begin
                SalesHeader."Job TemplateS365" := Jobs."No.";
                SalesHeader.Modify();
            end
            else
                if Opportunity.Get(SalesHeader."Opportunity No.") then
                    if Opportunity."Sales Cycle Code" = 'PRESALES' then
                        Error(Text001Err, Opportunity."Sales Cycle Code");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order (Yes/No)", OnAfterSalesQuoteToOrderRun, '', false, false)]
    local procedure "Sales-Quote to Order (Yes/No)_OnAfterSalesQuoteToOrderRun"(var SalesHeader2: Record "Sales Header"; var SalesHeader: Record "Sales Header")
    var
        Job: Record Job;
        CopyfromJob: Record Job;
        // JobPlanningLines: Record "Job Planning Line";
        // JobTaskLines: Record "Job Task";
        CopyfromJobTaskLines: Record "Job Task";
        CopyJob: Codeunit "Copy Job";
        // Func: Codeunit "SQmodFunction S365";
        Source: Option "Job Planning Lines","Job Ledger Entries","None";
        PlanningLineType: Option "Budget+Billable",Budget,Billable;
        LedgerEntryType: Option "Usage+Sale",Usage,Sale;
    begin
        //Copy from job
        Message('Done');

        if CopyfromJob.Get(SalesHeader."Job TemplateS365") then begin
            CopyfromJobTaskLines.SetRange("Job No.", CopyfromJob."No.");
            //create job
            Job.Init();
            job.Description := SalesHeader2."No." + '-' + SalesHeader2."Sell-to Customer Name";
            job.Validate("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
            Job.Validate("Project Manager", CopyfromJob."Project Manager");
            Job.Insert(true);
            CopyJob.SetCopyOptions(false, false, false, Source::"Job Planning Lines", PlanningLineType, LedgerEntryType::"Usage+Sale");
            CopyJob.CopyJobTasks(CopyfromJob, job);
            SalesHeader2."Job No. S365" := Job."No.";
            SalesHeader2.Modify();
        end;
        //Func.SendNotificationEmail(SalesHeader, Job);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Opportunity Entry", OnUpdateOppFromOppOnBeforeStartWizard2, '', false, false)]
    local procedure OnUpdateOppFromOppOnBeforeStartWizard2(var OpportunityEntry: Record "Opportunity Entry"; Opportunity: Record Opportunity)
    var
        SolutionPill: Record SolutionPillar;
    begin
        SolutionPill.SetRange(Solution, Opportunity.solutionPillar);
        if SolutionPill.FindFirst() then OpportunityEntry.ActivityAssign := SolutionPill.SalespersonCode;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Opportunity Entry", OnCreateTaskOnBeforeInsertTask, '', false, false)]
    local procedure OnCreateTaskOnBeforeInsertTask(var OpportunityEntry: Record "Opportunity Entry"; var Task: Record "To-do")
    begin
        Task."Salesperson Code" := OpportunityEntry.ActivityAssign;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateNo(var Rec: Record "Sales Line")
    var
        Item: Record Item;
    begin
        If Item.Get(Rec."No.") then begin
            Item.CalcFields(Inventory);
            Rec."HS Code S365" := Item."Tariff No.";
            Rec.UnitCostHistorical := Item."Unit Cost";
            Rec.AvailableQty := Item.Inventory;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Pipeline Chart Mgt.", OnBeforeDrillDown, '', false, false)]
    local procedure OnBeforeDrillDown(var OppEntry: Record "Opportunity Entry")
    var
    begin
        OppEntry.SetRange(ActivityAssign, UserId);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, OnAfterCopyFromNewCustomerTemplate, '', false, false)]
    local procedure OnAfterCopyFromNewCustomerTemplate(var Customer: Record Customer; CustomerTemplate: Record "Customer Templ.")
    begin
        Customer."Tax Liable" := CustomerTemplate."Tax Liable";
        Customer."Tax Area Code" := CustomerTemplate."Tax Area Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", OnAfterLogin, '', false, false)]
    local procedure OnAfterLogin()
    var
        UserLoginIdentify: Page UserLoginIdentification;
        UserDiv: Record UserDeviation;
    begin
        if not GuiAllowed then exit;
        Commit();
        if UserLoginIdentify.RunModal() = Action::OK then begin
            UserDiv.Init();
            UserDiv.SessionId := SessionId();
            UserDiv.UserID := UserId;
            UserDiv.Salesperson := UserLoginIdentify.GetSalesPerson();
            UserDiv.LoginDateTime := CurrentDateTime;
            UserDiv.Insert();
        end
        else
            RestartSession();
    end;

    local procedure RestartSession()
    var
        SessionSetting: SessionSettings;
    begin
        SessionSetting.Init();
        SessionSetting.RequestSessionUpdate(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterSetupNewLine', '', false, false)]
    local procedure OnAfterSetupNewLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Pre Assigned No." := GenJournalLine."Document No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure CopyGenLedgeEntries(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry.PayeeName := GenJournalLine.PayeeName;
        GLEntry.Narration := GenJournalLine.Narration;
        GLEntry.VoidRemarks := GenJournalLine.VoidRemarks;
        GLEntry."Salesperson Code" := GenJournalLine."Salespers./Purch. Code";
        GLEntry."Gennext User" := BusinessCentralCod.GetCurrentLoginUser();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure CopyBankLedgeEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        BankAccountLedgerEntry.PayeeName := GenJournalLine.PayeeName;
        BankAccountLedgerEntry.Narration := GenJournalLine.Narration;
        BankAccountLedgerEntry.VoidRemarks := GenJournalLine.VoidRemarks;
        BankAccountLedgerEntry."Pre Assigned No." := GenJournalLine."Pre Assigned No.";
        BankAccountLedgerEntry."Salesperson Code" := GenJournalLine."Salespers./Purch. Code";
        BankAccountLedgerEntry."Gennext User" := BusinessCentralCod.GetCurrentLoginUser();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure CopyVendorLedgeEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry.PayeeName := GenJournalLine.PayeeName;
        VendorLedgerEntry.Narration := GenJournalLine.Narration;
        VendorLedgerEntry.VoidRemarks := GenJournalLine.VoidRemarks;
        VendorLedgerEntry."Pre Assigned No." := GenJournalLine."Pre Assigned No.";
        //VendorLedgerEntry."Salesperson Code" := GenJournalLine."Salespers./Purch. Code";
        VendorLedgerEntry."Gennext User" := BusinessCentralCod.GetCurrentLoginUser();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure CopyCustLedgeEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry.PayeeName := GenJournalLine.PayeeName;
        CustLedgerEntry.Narration := GenJournalLine.Narration;
        CustLedgerEntry.VoidRemarks := GenJournalLine.VoidRemarks;
        CustLedgerEntry."Gennext User" := BusinessCentralCod.GetCurrentLoginUser();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Make FA Ledger Entry", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure CopyFALedgeEntry(var FALedgerEntry: Record "FA Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        FALedgerEntry.PayeeName := GenJournalLine.PayeeName;
        FALedgerEntry.Narration := GenJournalLine.Narration;
        FALedgerEntry.VoidRemarks := GenJournalLine.VoidRemarks;
        FALedgerEntry."Gennext User" := BusinessCentralCod.GetCurrentLoginUser();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Check Ledger Entry", 'OnAfterCopyFromBankAccLedgEntry', '', false, false)]
    local procedure CopyCheckLedgeEntry(var CheckLedgerEntry: Record "Check Ledger Entry"; BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        CheckLedgerEntry.PayeeName := BankAccountLedgerEntry.PayeeName;
        CheckLedgerEntry.Narration := BankAccountLedgerEntry.Narration;
        CheckLedgerEntry.VoidRemarks := BankAccountLedgerEntry.VoidRemarks;
        CheckLedgerEntry."Salesperson Code" := BankAccountLedgerEntry."Salesperson Code";
        CheckLedgerEntry."Check No." := BankAccountLedgerEntry."External Document No.";
        CheckLedgerEntry."Gennext User" := BusinessCentralCod.GetCurrentLoginUser();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Doc. From Sales Doc.", OnCreatePurchaseOrderOnAfterPurchaseHeaderSetFilters, '', false, false)]
    local procedure "Purch. Doc. From Sales Doc._OnCreatePurchaseOrderOnAfterPurchaseHeaderSetFilters"(var PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    var
        SalesHeaderUpdate: Record "Sales Header";
    begin
        if PurchaseHeader.FindSet() then
            PurchaseHeader.ModifyAll("Sales Order No. 4HC", SalesHeader."No.");

        SalesHeaderUpdate.SetRange("Document Type", SalesHeader."Document Type");
        SalesHeaderUpdate.SetRange("No.", SalesHeader."No.");
        if SalesHeaderUpdate.FindFirst() then begin
            SalesHeaderUpdate."Purchase Order No. 4HC" := PurchaseHeader."No.";
            SalesHeaderUpdate.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, OnAfterSubstituteReport, '', false, false)]
    local procedure ReportManagement_OnAfterSubstituteReport(ReportId: Integer; RunMode: Option; RequestPageXml: Text; RecordRef: RecordRef; var NewReportId: Integer)
    begin
        if ReportId = Report::Check then
            NewReportId := Report::"Check WQ";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnBeforeCopySellToCustomerAddressFieldsFromCustomer, '', false, false)]
    local procedure "Sales Header_OnBeforeCopySellToCustomerAddressFieldsFromCustomer"(var SalesHeader: Record "Sales Header"; Customer: Record Customer; var IsHandled: Boolean)
    begin
        SalesHeader.Validate(CompanyBankAccountCode, Customer.CompanyBankAccountCode);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", OnBeforeRunPurchPost, '', false, false)]
    local procedure "Purch.-Post (Yes/No)_OnBeforeRunPurchPost"(var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader.TestField("Purchaser Code");
    end;

    var
        BusinessCentralCod: Codeunit "4HC Business Central";
}
