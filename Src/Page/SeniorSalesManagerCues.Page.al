page 50123 "4HC Senior Sales Manager Cues"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Relationship Mgmt. Cue";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Opportunities)
            {
                Caption = 'Opportunities';
                field("Open Opportunities"; Rec."Open Opportunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Opportunity List";
                    ToolTip = 'Specifies open opportunities.';
                }
                field("Opportunities Due in 7 Days"; Rec."Opportunities Due in 7 Days")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Opportunity Entries";
                    Style = Favorable;
                    StyleExpr = true;
                    ToolTip = 'Specifies opportunities with a due date in seven days or more.';
                }
                field("Overdue Opportunities"; Rec."Overdue Opportunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Opportunity Entries";
                    Style = Unfavorable;
                    StyleExpr = true;
                    ToolTip = 'Specifies opportunities that have exceeded the due date.';
                }
                field("Closed Opportunities"; Rec."Closed Opportunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Opportunity List";
                    ToolTip = 'Specifies opportunities that have been closed.';
                }
            }
            cuegroup(Sales)
            {
                Caption = 'Sales';
                field("Open Sales Quotes"; Rec."Open Sales Quotes")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Sales Quotes";
                    ToolTip = 'Specifies the number of sales quotes that are not yet converted to invoices or orders.';
                }
                field("Open Sales Orders"; Rec."Open Sales Orders")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies the number of sales orders that are not fully posted.';
                }
            }
            cuegroup(Approvals)
            {

                Caption = 'Approvals';
                field("Pending Apporval In BU"; Rec."Pending Apporval In BU")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pending Apporval In Business Unit field.';
                    DrillDownPageID = "Sales Quotes";
                }

                field("Approval Pending Sales Quotes"; Rec."Approval Pending Sales Quotes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Approval Pending Sales Quotes field.';
                    DrillDownPageID = "Sales Quotes PendingApproval";
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec."Approval Pending Sales Quotes" := CalculateApprovalPendingSalesQuotes();
        Rec."Pending Apporval In BU" := BusinessUnitApprovalPendingSalesQuotes();
    end;


    procedure CalculateApprovalPendingSalesQuotes() SQCount: Integer
    var
        SalesHeader: Record "Sales Header";
        UserDiv: Record UserDeviation;
    begin
        if UserDiv.Get(SessionId()) then begin
            //SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
            SalesHeader.SetRange("Approval Status", SalesHeader."Approval Status"::"Pending Approval");
            SalesHeader.SetRange("Approver ID", UserDiv.Salesperson);
            SQCount := SalesHeader.Count();
        end;
    end;

    procedure BusinessUnitApprovalPendingSalesQuotes() SQCount: Integer
    var
        SalesHeader: Record "Sales Header";
        UserDiv: Record UserDeviation;
        SalesPerson: Record "Salesperson/Purchaser";
    begin
        if UserDiv.Get(SessionId()) then begin
            SalesPerson.Get(UserDiv.Salesperson);
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
            SalesHeader.SetRange("Approval Status", SalesHeader."Approval Status"::"Pending Approval");
            SalesHeader.SetRange("Shortcut Dimension 1 Code", SalesPerson."Global Dimension 1 Code");
            SQCount := SalesHeader.Count();
        end;
    end;
}