pageextension 50131 CheckLedgerEntriesExt extends "Check Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
            }
            field(PayeeName; Rec.PayeeName)
            {
                ApplicationArea = all;
            }
            field(VoidRemarks; Rec.VoidRemarks)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify("Void Check")
        {
            Visible = false;
        }
        addafter("Void Check")
        {
            action("Void Check SC")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Void Check';
                Image = VoidCheck;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Void the check if, for example, the check is not cashed by the bank.';

                trigger OnAction()
                var
                // CheckManagement: Codeunit ChequeMgt;
                begin
                    //CheckManagement.FinancialVoidCheck(Rec);
                end;
            }
        }
    }
}
