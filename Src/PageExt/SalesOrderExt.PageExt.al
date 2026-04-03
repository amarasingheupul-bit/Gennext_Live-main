pageextension 50107 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Tax Area Code"; Rec."Tax Area Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
            }
            field("Tax Liable"; Rec."Tax Liable")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if this vendor charges you sales tax for purchases.';
            }
            field("Margin %"; Rec."Margin %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Margine % field.';
                Editable = false;
            }
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = All;
                Style = Strong;
                ToolTip = 'Specifies the value of the Approval Status field.';
                Editable = false;
            }
            field("Approver ID"; Rec."Approver ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Approver ID field.';
                Editable = false;
            }
            field("Reject Reason"; Rec."Reject Reason")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reject Reason field.';
                Importance = Additional;
                MultiLine = true;
            }
        }

        addlast(General)
        {
            field("Job No. S365"; Rec."Job No. S365")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Job No.';

                trigger OnAssistEdit()
                var
                    RecJob: Record Job;
                    JobCardPageID: Integer;
                begin
                    JobCardPageID := PAGE::"Job Card";
                    if RecJob.Get(Rec."Job No. S365") then PAGE.RUN(JobCardPageID, RecJob);
                end;
            }
            field("Purchase Order No."; Rec."Purchase Order No. 4HC")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purchase Order No. field.';
                Importance = Additional;
                Editable = false;
            }
        }
        addafter(General)
        {
            group("New Fields S365")
            {
                ShowCaption = true;
                Caption = 'Additional Order Details';

                field("Place of Receipt S365"; Rec."Origin S365")
                {
                    Caption = 'Place of Receipt';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Receipt field.';
                }
                field("Quote Type S365"; Rec."Quote Type S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quote Type field.';
                }
                field("Place of Delivery S365"; Rec."Destination S365")
                {
                    Caption = 'Place of Delivery';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Delivery field.';
                }
                field("ETD S365"; Rec."ETD S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETD field.';
                    Visible = false;
                }
                field("ETA S365"; Rec."ETA S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETA field.';
                    Visible = false;
                }
                field("Shipment Method Code S365"; Rec."Shipment Method Code")
                {
                    Caption = 'Incoterms';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incoterms field.';
                    Visible = false;
                }
                field("MAWB No. S365"; Rec."MAWB No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MAWB No. field.';
                    Visible = false;
                }
                field("MAWB Date S365"; Rec."MAWB Date S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MAWB Date field.';
                    Visible = false;
                }
                field("Cross Trade S365"; Rec."Cross Trade S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cross Trade field.';
                    Visible = false;
                }
                field("Container No. S365"; Rec."Container No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container No. field.';
                    Visible = false;
                }
                field("Remarks S365"; Rec."Remarks S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field("Sales Derector/ Area Director"; Rec."Sales Derector/ Area Director")
                {
                    ApplicationArea = All;
                }
                field("Sales Contract No."; Rec."Sales Contract No.")
                {
                    ApplicationArea = All;
                }
                field("Sales Contract Desc"; Rec."Sales Contract Desc")
                {
                    ApplicationArea = All;
                }
                field("Yard No."; Rec."Yard No.")
                {
                    ApplicationArea = All;
                }
                field("Milestones Dates and Amounts"; Rec."Milestones Dates and Amounts")
                {
                    ApplicationArea = All;
                }
                field("End User/ Main Customer"; Rec."End User/ Main Customer")
                {
                    ApplicationArea = All;
                }
                field("Group Customer with One Stream"; Rec."Group Customer with One Stream")
                {
                    ApplicationArea = All;
                }
                field("Supplier to Services"; Rec."Supplier to Services")
                {
                    ApplicationArea = All;
                }
                field("Sales Area"; Rec."Sales Area")
                {
                    ApplicationArea = All;
                }
            }
        }
        addafter("Currency Code")
        {
            field(CompanyBankAccountCode; Rec.CompanyBankAccountCode)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Company Bank Account Code field.';
            }
        }
        addlast("Invoice Details")
        {
            field(PIAdvance; Rec.PIAdvance)
            {
                ApplicationArea = All;
            }
            field(PIAdvancePercentage; Rec.PIAdvancePercentage)
            {
                ApplicationArea = All;
            }
        }
        modify("Company Bank Account Code")
        {
            Visible = false;
        }
        modify("Prepmt. Payment Discount %")
        {
            Visible = false;
        }
        modify("Prepmt. Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("VAT Country/Region Code")
        {
            Visible = false;
        }
        modify("Payment Method Code")
        {
            Visible = false;
        }
        modify(SelectedPayments)
        {
            Visible = false;
        }
        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify("Payment Discount %")
        {
            Visible = false;
        }
        modify("Pmt. Discount Date")
        {
            Visible = false;
        }
        modify("Direct Debit Mandate ID")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
    }
    actions
    {
        addlast(processing)
        {
            action("CreateJob S365")
            {
                Caption = 'Create Job';
                Image = CreateJobSalesInvoice;
                ToolTip = 'Create Job';
                ApplicationArea = Suite;

                // Visible = IsActionVisible;
                trigger OnAction()
                var
                    Func: Codeunit "SQmodFunction S365";
                begin
                    Func.CreateJobFromTemplate(Rec);
                end;
            }
            action(SOProformaInvoice)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Proforma Invoice';
                Image = Print;
                ToolTip = 'Show Proforma Invoice for the selected sales invoice.';
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesHeader);
                    Report.Run(Report::"SO Proforma Invoice", true, true, SalesHeader);
                end;
            }
        }
        addlast("Request Approval")
        {
            action(CustomSendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Enabled = OpenApprovalEntriesExist and ApprovalWorkflowEnable;
                Image = SendApprovalRequest;
                ToolTip = 'Request approval of the document.';
                trigger OnAction()
                begin
                    //Rec.TestField("Margin %");
                    Rec.TestField("Shortcut Dimension 1 Code");
                    Rec."Approval Sender" := Rec."Salesperson Code";
                    // Rec.CalcFields("Amount");
                    // Rec.TestField("Amount");
                    this.GetApprovalUserIDBaseMargin();
                    this.GetApprovalUserIDBasedAmount();
                    if ExistApprovalWorkflow then begin
                        Rec."Approval Status" := Rec."Approval Status"::"Pending Approval";
                        Rec.Status := Rec.Status::"Pending Approval";
                    end;
                    if not ExistApprovalWorkflow then begin
                        Rec."Approval Status" := Rec."Approval Status"::"Released";
                        Rec.Status := Rec.Status::Released;
                        Rec."Approver ID" := Rec."Salesperson Code";
                    end;
                    Rec.Modify();
                    CurrPage.Close();
                    Message(Text011Msg);
                end;
            }
            action(CustomCancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Enabled = CanCancelApprovalForRecord;
                Image = CancelApprovalRequest;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                begin
                    ApprovalStatusOpen();
                    Message(Text014Msg);
                end;
            }
            group(CustomApproval)
            {
                Caption = 'Approval';
                action(CustomApprove)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    begin
                        Rec."Approval Status" := Rec."Approval Status"::Released;
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                        Message(Text015Msg);
                    end;
                }
                action(CustomReject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;
                    trigger OnAction()
                    begin
                        Rec.TestField("Reject Reason");
                        Rec."Approval Status" := Rec."Approval Status"::Rejected;
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                        Message(Text016Msg);
                    end;
                }
                action(CustomReopen)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&open';
                    Enabled = Rec."Approval Status" = Rec."Approval Status"::Released;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    begin
                        this.ApprovalStatusOpen();
                        Message(Text013Msg);
                    end;
                }
                action(DelegateApprovalAct)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate Approval';
                    Image = Delegate;
                    ToolTip = 'Delegate the approval request to another user.';
                    Enabled = Rec."Approval Status" = Rec."Approval Status"::"Pending Approval";

                    trigger OnAction()
                    begin
                        this.DelegateApproval();
                        Message(Text012Msg, Rec."Approver ID");
                    end;
                }
                action(in)
                {
                    ApplicationArea = All;
                    Caption = 'In';
                    Image = Info;
                    ToolTip = 'In';
                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Open;
                        Rec."Approval Status" := Rec."Approval Status"::Open;
                        Rec.Modify();
                    end;
                }
                action(out)
                {
                    ApplicationArea = All;
                    Caption = 'Out';
                    Image = Info;
                    ToolTip = 'Out';
                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Released;
                        Rec."Approval Status" := Rec."Approval Status"::Released;
                        Rec.Modify();
                    end;
                }
            }
        }
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }
        modify(Reopen)
        {
            Visible = false;
        }
        modify(Release)
        {
            Visible = false;
        }
        addlast(Category_Category11)
        {
            actionref(SOProformaInvoice_Promoted; SOProformaInvoice)
            {
            }
        }
        addlast(Category_Category9)
        {
            actionref(CustomSendApprovalRequest_Promoted; CustomSendApprovalRequest)
            {
            }
            actionref(CustomCancelApprovalRequest_Promoted; CustomCancelApprovalRequest)
            {
            }
        }
        addlast(Category_Category4)
        {
            actionref(CustomApprove_Promoted; CustomApprove)
            {
            }
            actionref(CustomReject_Promoted; CustomReject)
            {
            }
            actionref(DelegateApproval_Promoted; DelegateApprovalAct)
            {
            }
        }
        addlast(Category_Category5)
        {
            actionref(CustomReopen_Promoted; CustomReopen)
            {
            }
        }
        addlast(Category_Process)
        {
            actionref("CreateJob_Promoted S365"; "createJob S365")
            {
            }
        }
        modify(ProformaInvoice_Promoted)
        {
            Visible = false;
        }
        moveafter("Prepayment &Test Report"; ProformaInvoice)
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetVisibilityForActions();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        BC4HC: Codeunit "4HC Business Central";
    begin
        Rec."Gennext Create By User" := BC4HC.GetCurrentLoginUser();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetVisibilityForActions();
    end;

    trigger OnAfterGetRecord()
    begin
        SetVisibilityForActions();
    end;

    trigger OnOpenPage()
    begin
        SetVisibilityForActions();
    end;

    var
        CustomApprovalHeader: Record "4HC Custom Approval Header";
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ApprovalWorkflowEnable: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        DirectorApproval: Boolean;
        ExistApprovalWorkflow: Boolean;
        Text013Msg: Label 'The document has been reopened.';
        Text012Msg: Label 'The approval request has been delegated to %1.', Comment = '%1 is the approver ID';
        Text011Msg: Label 'The document has been sent for approval.';
        Text014Msg: Label 'The approval request has been canceled.';
        Text015Msg: Label 'The document has been approved.';
        Text016Msg: Label 'The document has been rejected.';

    local procedure GetApprovalUserIDBaseMargin()
    var
        ApprovalLine: Record "4HC Custom Approval Line";
        SalesPerson: Record "Salesperson/Purchaser";
    begin
        ApprovalLine.Reset();
        ApprovalLine.SetRange(Type, ApprovalLine.Type::Margin);
        ApprovalLine.SetRange("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        ApprovalLine.SetRange("Document Type", ApprovalLine."Document Type"::"Sales Order");
        if ApprovalLine.FindSet() then
            repeat
                if not DirectorApproval then
                    if (ApprovalLine."Minimum Range" <= Rec."Margin %") and (ApprovalLine."Maximum Range" > Rec."Margin %") then begin
                        if ApprovalLine."Approver ID" = 'VP' then begin
                            if SalesPerson.Get(Rec."Salesperson Code") then
                                Rec."Approver ID" := SalesPerson."Vice President"
                        end
                        else
                            Rec."Approver ID" := ApprovalLine."Approver ID";
                        Rec."Approval Base Type" := Rec."Approval Base Type"::Margin;
                        if ApprovalLine.Director then
                            DirectorApproval := true;
                        ExistApprovalWorkflow := true;
                        Rec.Modify();
                    end;
            until ApprovalLine.Next() = 0;
    end;

    local procedure GetApprovalUserIDBasedAmount()
    var
        ApprovalLine: Record "4HC Custom Approval Line";
        SalesPerson: Record "Salesperson/Purchaser";
    begin
        ApprovalLine.Reset();
        ApprovalLine.SetRange(Type, ApprovalLine.Type::Value);
        ApprovalLine.SetRange("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        ApprovalLine.SetRange("Document Type", ApprovalLine."Document Type"::"Sales Order");
        ApprovalLine.SetFilter("Shortcut Dimension 2 Code", '%1', Rec."Shortcut Dimension 2 Code");
        if ApprovalLine.FindSet() then
            repeat
                Rec.CalcFields("Amount");
                if not DirectorApproval then
                    if (ApprovalLine."Minimum Range" <= Rec."Amount") and (ApprovalLine."Maximum Range" > Rec.Amount) then begin
                        if ApprovalLine."Approver ID" = 'VP' then begin
                            if SalesPerson.Get(Rec."Salesperson Code") then
                                Rec."Approver ID" := SalesPerson."Vice President"
                        end
                        else
                            Rec."Approver ID" := ApprovalLine."Approver ID";
                        Rec."Approval Base Type" := Rec."Approval Base Type"::Value;
                        if ApprovalLine.Director then
                            DirectorApproval := true;
                        ExistApprovalWorkflow := true;
                        Rec.Modify();
                    end;
            until ApprovalLine.Next() = 0;
    end;

    local procedure SetVisibilityForActions()
    begin
        CustomApprovalHeader.SetRange("Document Type", CustomApprovalHeader."Document Type"::"Sales Order");
        CustomApprovalHeader.SetRange(Enabled, true);
        if CustomApprovalHeader.FindFirst() then
            ApprovalWorkflowEnable := true
        else
            ApprovalWorkflowEnable := false;

        if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval" then begin
            CanCancelApprovalForRecord := true;
            if Rec."Approver ID" = GetCurrentLoginUser() then
                OpenApprovalEntriesExistForCurrUser := true
            else
                OpenApprovalEntriesExistForCurrUser := false;
        end
        else
            if Rec."Approval Status" = Rec."Approval Status"::Open then
                OpenApprovalEntriesExist := true
    end;

    local procedure DelegateApproval()
    var
        ApprovalLine: Record "4HC Custom Approval Line";
    begin
        ApprovalLine.SetRange(Type, Rec."Approval Base Type");
        ApprovalLine.SetRange("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        ApprovalLine.SetRange("Document Type", ApprovalLine."Document Type"::"Sales Order");
        ApprovalLine.SetFilter("Approver ID", '<>%1', Rec."Approver ID");
        if ApprovalLine.FindFirst() then begin
            Rec."Approver ID" := ApprovalLine."Approver ID";
            Rec.Modify();
            CurrPage.Update();
        end
        else
            Message('No other approver found for this approval type.');
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

    local procedure ApprovalStatusOpen()
    begin
        Rec."Approver ID" := '';
        Rec."Approval Status" := Rec."Approval Status"::Open;
        Rec.Status := Rec.Status::Open;
        Rec.Modify();
        CurrPage.Update();
    end;
}
