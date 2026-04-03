pageextension 50104 "4HC Sales Quote" extends "Sales Quote"
{
    layout
    {
        addlast(General)
        {
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
        addafter(General)
        {
            group("New Fields S365")
            {
                ShowCaption = true;
                Caption = 'Additional Quote Details';

                field("Origin S365"; Rec."Origin S365")
                {
                    Caption = 'Origin';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Origin field.';
                    Visible = false;
                }
                field("Quote Type S365"; Rec."Quote Type S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quote Type field.';
                }
                field("Destination S365"; Rec."Destination S365")
                {
                    Caption = 'Destination';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination field.';
                    Visible = false;
                }
                field("Place of Receipt S365"; Rec."Place of Receipt S365")
                {
                    Caption = 'Place of Receipt';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Receipt field.';
                    Visible = false;
                }
                field("Place of Delivery S365"; Rec."Place of Delivery S365")
                {
                    Caption = 'Place of Delivery';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Delivery field.';
                    Visible = false;
                }
                field("Change Reason S365"; Rec."Change Reason S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Change Reason field.';
                }
                field("Original Quote No. S365"; Rec."Original Quote No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Original Quote No. field.';
                }
                field(ConfirmedS365; Rec.ConfirmedS365)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value for confirmed qoutes';
                }
                field("Quote Status S365"; Rec."Quote Status S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quote Status field.';
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
                field(CompanyBankAccountCode; Rec.CompanyBankAccountCode)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company Bank Account Code field.';
                }
            }
        }
        addafter("Currency Code")
        {
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Currency Factor field.';
            }
            field("Exchange Rate"; Rec."Exchange Rate")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Exchange Rate field.';
            }
        }
        movelast(General; "Shortcut Dimension 1 Code")
        moveafter("Remarks S365"; "Currency Code")
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Sell-to Customer Templ. Code")
        {
            Visible = false;
        }
        modify("Opportunity No.")
        {
            Visible = false;
        }
        modify("Invoice Details")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            trigger OnAfterValidate()
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                if Rec."Currency Code" = 'USD' then
                    Rec."Exchange Rate" := CurrExchRate.ExchangeRate(Today, Rec."Currency Code");
                Rec.Modify();
            end;
        }
        // modify(Status)
        // {
        //     Visible = false;
        // }
    }
    actions
    {
        addafter("Archive Document")
        {
            action("Amend Quote & Archive S365")
            {
                Caption = 'Amend Quote & Archive';
                ToolTip = 'Copy document lines and header information from another sales document to this document and send the document to the archive';
                ApplicationArea = All;
                Image = Archive;

                trigger OnAction()
                begin
                    SQmodFunction.SalesQuoteAmendArchive(Rec);
                end;
            }
            action(ConfirmS365)
            {
                Caption = 'Confirm Qoute';
                ToolTip = 'Confirm this qoute and prepare for make order';
                ApplicationArea = All;
                Image = Confirm;

                trigger OnAction()
                begin
                    SQmodFunction.ConfirmQoute(Rec);
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
                    //  Rec.TestField("Margin %");
                    Rec.TestField("Shortcut Dimension 1 Code");
                    Rec."Approval Sender" := Rec."Salesperson Code";
                    Rec.CalcFields("Amount");
                    Rec.TestField("Amount");
                    this.GetApprovalUserIDBaseMargin();
                    this.GetApprovalUserIDBasedAmount();
                    if ExistApprovalWorkflow then begin
                        Rec."Approval Status" := Rec."Approval Status"::"Pending Approval";
                        Rec.Status := Rec.Status::"Pending Approval";
                    end;
                    if not ExistApprovalWorkflow then begin
                        this.GetTotoalChargerAmountandUpdatePriceAndDelete();
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
                    var
                        ArchiveManagement: Codeunit ArchiveManagement;
                    begin
                        ArchiveManagement.StoreSalesDocument(Rec, false);
                        this.GetTotoalChargerAmountandUpdatePriceAndDelete();
                        Rec."Approval Status" := Rec."Approval Status"::Released;
                        Rec.Status := Rec.Status::Released;
                        Rec.Modify();
                        CurrPage.Update();
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
        modify(MakeInvoice)
        {
            Visible = false;
        }
        modify(MakeOrder)
        {
            trigger OnBeforeAction()
            begin
                REc.TestField(Status, Rec.Status::Released);
            end;
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
        addlast(Category_Process)
        {
            actionref(AmendQuoteArchiveS365; "Amend Quote & Archive S365")
            {
            }
        }
        addlast(Category_Category7)
        {
            actionref(CustomSendApprovalRequest_Promoted; CustomSendApprovalRequest)
            {
            }
            actionref(CustomCancelApprovalRequest_Promoted; CustomCancelApprovalRequest)
            {
            }
        }
        addlast(Category_Category6)
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
        addlast(Category_Category10)
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
        SQmodFunction: Codeunit "SQmodFunction S365";
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
        ApprovalLine.SetRange("Document Type", ApprovalLine."Document Type"::"Sales Quote");
        ApprovalLine.SetRange("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code"); // when product wise approval
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
            until ApprovalLine.Next() = 0
        else begin
            ApprovalLine.SetRange("Shortcut Dimension 2 Code");
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
                until ApprovalLine.Next() = 0
        end;
    end;

    local procedure GetApprovalUserIDBasedAmount()
    var
        SalesPerson: Record "Salesperson/Purchaser";
        ApprovalLine: Record "4HC Custom Approval Line";
    begin
        ApprovalLine.Reset();
        ApprovalLine.SetRange(Type, ApprovalLine.Type::Value);
        ApprovalLine.SetRange("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
        ApprovalLine.SetRange("Document Type", ApprovalLine."Document Type"::"Sales Quote");
        ApprovalLine.SetRange("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
        if ApprovalLine.FindSet() then
            repeat
                Rec.CalcFields("Amount");
                if not DirectorApproval then
                    if (ApprovalLine."Minimum Range" <= Rec."Amount") and (ApprovalLine."Maximum Range" > Rec.Amount) then begin
                        if ApprovalLine."Approver ID" = 'VP' then
                            if SalesPerson.Get(Rec."Salesperson Code") then
                                Rec."Approver ID" := SalesPerson."Vice President"
                            else
                                Rec."Approver ID" := ApprovalLine."Approver ID";
                        Rec."Approval Base Type" := Rec."Approval Base Type"::Value;
                        if ApprovalLine.Director then
                            DirectorApproval := true;
                        ExistApprovalWorkflow := true;
                        Rec.Modify();
                    end;
            until ApprovalLine.Next() = 0
        else begin
            ApprovalLine.SetRange("Shortcut Dimension 2 Code");
            if ApprovalLine.FindSet() then
                repeat
                    Rec.CalcFields("Amount");
                    if not DirectorApproval then
                        if (ApprovalLine."Minimum Range" <= Rec."Amount") and (ApprovalLine."Maximum Range" > Rec.Amount) then begin
                            if ApprovalLine."Approver ID" = 'VP' then
                                if SalesPerson.Get(Rec."Salesperson Code") then
                                    Rec."Approver ID" := SalesPerson."Vice President"
                                else
                                    Rec."Approver ID" := ApprovalLine."Approver ID";
                            Rec."Approval Base Type" := Rec."Approval Base Type"::Value;
                            if ApprovalLine.Director then
                                DirectorApproval := true;
                            ExistApprovalWorkflow := true;
                            Rec.Modify();
                        end;
                until ApprovalLine.Next() = 0
        end;
    end;

    local procedure SetVisibilityForActions()
    begin
        CustomApprovalHeader.SetRange("Document Type", CustomApprovalHeader."Document Type"::"Sales Quote");
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
        ApprovalLine.SetRange("Document Type", ApprovalLine."Document Type"::"Sales Quote");
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

    local procedure GetTotoalChargerAmountandUpdatePriceAndDelete()
    var
        SaleLine: Record "Sales Line";
        FindChargerItemLine: Record "Sales Line";
        TotalUnitPrice: Decimal;
    begin
        Rec.Status := Rec.Status::Open;
        Rec.Modify();
        SaleLine.Reset();
        SaleLine.SetRange("Document Type", Rec."Document Type");
        SaleLine.SetRange("Document No.", Rec."No.");
        SaleLine.SetRange("Charger Item Created", true);
        if SaleLine.FindSet() then
            repeat
                FindChargerItemLine.Reset();
                FindChargerItemLine.SetRange("Document Type", SaleLine."Document Type");
                FindChargerItemLine.SetRange("Document No.", SaleLine."Document No.");
                FindChargerItemLine.SetRange("Is Charger Item", true);
                FindChargerItemLine.SetRange("Base Item No.", SaleLine."No.");
                FindChargerItemLine.CalcSums("Unit Price");
                if FindChargerItemLine.FindSet() then begin
                    TotalUnitPrice := SaleLine."Unit Price" + FindChargerItemLine."Unit Price";
                    SaleLine.Validate("Unit Price", TotalUnitPrice);
                    SaleLine.Modify();
                    FindChargerItemLine.DeleteAll();
                end;
            until SaleLine.Next() = 0;
        Rec.Status := Rec.Status::"Pending Approval";
        Rec.Modify();
    end;
}
