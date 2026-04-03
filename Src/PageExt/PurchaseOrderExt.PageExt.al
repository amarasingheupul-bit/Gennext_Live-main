pageextension 50128 PurchaseOrderExt extends "Purchase Order"
{
    layout
    {
        modify("Tax Liable")
        {
            ApplicationArea = All;
        }
        modify("Tax Area Code")
        {
            ApplicationArea = All;
        }
    }
    actions
    {
        addafter("&Print")
        {
            action("Print PO")
            {
                ApplicationArea = all;
                Caption = 'Print PO';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category10;

                trigger OnAction();
                var
                    PurchHdr: Record "Purchase Header";
                    Text0001: Label 'Status should  be released';
                begin
                    if Rec.Status = Rec.Status::Released then begin
                        PurchHdr.SetRange("No.", Rec."No.");
                        Report.Run(50110, true, true, PurchHdr);
                    end
                    else
                        Error(Text0001);
                end;
            }
        }
    }
}
