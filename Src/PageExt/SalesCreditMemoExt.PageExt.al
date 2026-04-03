pageextension 50123 SalesCreditMemoExt extends "Sales Credit Memo"
{
    layout
    {
        addafter("Currency Code")
        {
            field(CompanyBankAccountCode; Rec.CompanyBankAccountCode)
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the bank account to use for bank information when the document is printed.';
                trigger OnValidate()
                begin
                    Rec.Validate("Company Bank Account Code", Rec.CompanyBankAccountCode);
                end;
            }
        }
        addlast(General)
        {
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
    }

    actions
    {
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
                    Rec.TestField("Shortcut Dimension 1 Code");
                    Rec."Approval Sender" := Rec."Salesperson Code";
                    Rec.CalcFields("Amount");
                    Rec.TestField("Amount");
                    this.GetApprovalUserIDBaseMargin();
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
            }
        }
        // modify(Post)
        // {
        //     trigger OnBeforeAction()
        //     begin
        //         REc.TestField(Status, Rec.Status::Released);
        //     end;
        // }
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
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetVisibilityForActions();
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
    begin
        ApprovalLine.Reset();
        ApprovalLine.SetRange("Document Type", ApprovalLine."Document Type"::"Sales Credit Memo");
        if ApprovalLine.FindFirst() then begin
            if not DirectorApproval then
                Rec."Approver ID" := ApprovalLine."Approver ID";
            if ApprovalLine.Director then
                DirectorApproval := true;
            ExistApprovalWorkflow := true;
            Rec.Modify();
        end;
    end;

    local procedure SetVisibilityForActions()
    begin
        CustomApprovalHeader.SetRange("Document Type", CustomApprovalHeader."Document Type"::"Sales Credit Memo");
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
        ApprovalLine.SetRange("Document Type", ApprovalLine."Document Type"::"Sales Credit Memo");
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
