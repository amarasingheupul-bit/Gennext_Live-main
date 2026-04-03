page 50116 "Sales Quotes PendingApproval"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Pending Approval Requets';
    // CardPageID = "Sales Quote";
    DataCaptionFields = "Sell-to Customer No.";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = where("Approval Status" = const("Approval Status"::"Pending Approval"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document type.';
                    trigger OnDrillDown()
                    var
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        RecRef.SetRecFilter();
                        PageManagement.PageRun(RecRef);
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the customer.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the customer.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies when the sales invoice must be paid.';
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the sum of amounts on all the lines in the document. This will include invoice discounts.';
                }
                // Approval fields
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approval status of the sales quote.';
                }
                field("Approval Sender"; Rec."Approval Sender")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who sent the approval request.';
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approver for this sales quote.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Record")
            {
                ApplicationArea = Suite;
                Caption = 'Open Record';
                Image = Document;
                Scope = Repeater;
                ToolTip = 'Open the document, journal line, or card that the approval is requested for.';

                trigger OnAction()
                var
                    PageManagement: Codeunit "Page Management";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    RecRef.SetRecFilter();
                    PageManagement.PageRun(RecRef);
                end;
            }
        }
        area(Promoted)
        {
            actionref(Record_Promoted; Record)
            {
            }
        }
    }
    var
        PageManagement: Codeunit "Page Management";

    trigger OnOpenPage()
    var
        UserDiv: Record UserDeviation;
        Text0001Err: Label 'Please complete the authentication process to proceed with your task.';
    begin
        Rec.FilterGroup(19);
        if not UserDiv.Get(SessionId()) then
            Error(Text0001Err);
        Rec.SetRange("Approver ID", GetCurrentLoginUser());
        Rec.FilterGroup(0);
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
}