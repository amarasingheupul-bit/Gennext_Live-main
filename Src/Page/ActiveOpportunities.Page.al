page 50138 "4HC Active Opportunities"
{
    AdditionalSearchTerms = 'prospects';
    ApplicationArea = RelationshipMgmt;
    Caption = 'Opportunities';
    CardPageID = "Opportunity Card";
    DataCaptionExpression = Caption();
    Editable = false;
    PageType = List;
    SourceTable = Opportunity;
    SourceTableView = sorting("No.") where(Status = filter(WON | "In Progress"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the opportunity is closed.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date that the opportunity was created.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the opportunity.';
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the contact that this opportunity is linked to.';
                }
                field("Contact Company Name"; Rec."Contact Company Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the company of the contact person to which this opportunity is linked. The program automatically fills in this field when you have entered a number in the Contact Company No. field.';
                }
                field("Contact Company No."; Rec."Contact Company No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the company that is linked to this opportunity.';
                    Visible = false;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code of the salesperson that is responsible for the opportunity.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the status of the opportunity. There are four options:';
                }
                field("Sales Document Type"; Rec."Sales Document Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the type of the sales document (Quote, Order, Posted Invoice). The combination of Sales Document No. and Sales Document Type specifies which sales document is assigned to the opportunity.';
                }
                field(SalesOrderStatus; SalesOrderStatus)
                {
                    Style = Favorable;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Order Status';
                    ToolTip = 'Specifies the status of the sales order that is linked to this opportunity.';
                }
                field("Sales Document No."; Rec."Sales Document No.")
                {
                    Style = StrongAccent;
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the sales document that has been created for this opportunity.';
                }
                field("Estimated Closing Date"; Rec."Estimated Closing Date")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the estimated closing date of the opportunity.';
                }
                field("Estimated Value (LCY)"; Rec."Estimated Value (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the estimated value of the opportunity.';
                }
                field("Calcd. Current Value (LCY)"; Rec."Calcd. Current Value (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the current calculated value of the opportunity.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        SalesOrder: Record "Sales Header";
    begin
        if SalesOrder.Get(SalesOrder."Document Type"::Order, Rec."Sales Document No.") then
            SalesOrderStatus := Format(SalesOrder.Status)
        else
            if Rec."Sales Document Type" = Rec."Sales Document Type"::"Posted Invoice" then
                SalesOrderStatus := 'Completed'
            else
                SalesOrderStatus := 'N/A';
    end;

    var
        SalesOrderStatus: Text[20];
}