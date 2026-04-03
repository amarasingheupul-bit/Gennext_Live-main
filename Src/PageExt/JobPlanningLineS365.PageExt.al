pageextension 50109 JobPlanningLineS365 extends "Job Planning Lines"
{
    layout
    {
        addafter("Invoiced Amount (LCY)")
        {
            field("SEQNO S365"; Rec."SEQNO S365")
            {
                ApplicationArea = All;
            }
            field("Predecessor Seq S365"; Rec."Predecessor Seq S365")
            {
                ApplicationArea = All;
            }
            field("Completed S365"; Rec."Completed S365")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(SendNotifyS365)
            {
                Caption = 'Send Notification';
                Image = SendMail;
                ApplicationArea = Suite;
                ToolTip = 'Notification email will be send after configure email accounts';

                trigger OnAction()
                begin
                    Message('Notification email will be send after configure email accounts');
                end;
            }
            action(CreateWhseRcpS365)
            {
                Caption = 'Send Whse Notification';
                Image = SendMail;
                ApplicationArea = Suite;
                ToolTip = 'Notification email & Whse Receipt will be create';

                trigger OnAction()
                var
                    SQModFunc: Codeunit "SQmodFunction S365";
                begin
                    SQModFunc.CreateWarehouseReceipt(Rec."Job No.");
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref("SendNotifyS365_Promoted"; SendNotifyS365)
            {
            }
        }
    }
}
