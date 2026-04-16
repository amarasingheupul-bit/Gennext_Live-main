pageextension 50130 PaymentJournalExt extends "Payment Journal"
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
        }
    }
    actions
    {
        modify("Void &All Checks")
        {
            Enabled = false;
        }
        modify("Post and &Print")
        {
            Enabled = false;
        }
        modify(Post)
        {
            Visible = false;
        }
        addafter(Post)
        {
            // action(PostSC)
            // {
            //     ApplicationArea = Basic, Suite;
            //     Caption = 'P&ost';
            //     Image = PostOrder;
            //     Promoted = true;
            //     PromotedCategory = Category8;
            //     PromotedIsBig = true;
            //     ShortCutKey = 'F9';
            //     ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

            //     trigger OnAction()
            //     begin
            //         CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post SC", Rec);
            //         CurrPage.Update(false);
            //     end;
            // }
            action(PostChq)
            {
                //Visible = Rec."Bank Payment Type" = Rec."Bank Payment Type"::"Computer Check";
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Image = PostOrder;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                begin
                    CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post SC", Rec);
                    //CurrentJnlBatchName := GetRangeMax("Journal Batch Name");
                    //SetJobQueueVisibility();
                    CurrPage.Update(false);
                end;
            }

        }
        addafter("Post and &Print")
        {
            action("Print Payment Voucher")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Report;
                Image = Payment;

                trigger OnAction()
                var
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                    GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                    GenJnlLine.SetRange("Document No.", Rec."Document No.");
                    Report.run(50111, true, true, GenJnlLine);
                end;
            }
        }
    }
}
