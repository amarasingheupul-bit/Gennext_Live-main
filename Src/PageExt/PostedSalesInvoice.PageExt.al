pageextension 50144 "4HC Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        addlast(General)
        {
        }
    }
    actions
    {
        modify(Print)
        {
            Enabled = not (Rec."Tax Area Code" = 'SVAT');
        }
        addafter(Print)
        {
            action(ProformaInvoice)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Proforma Invoice';
                Image = Print;
                ToolTip = 'Show Proforma Invoice for the selected sales invoice.';
                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    Report.Run(Report::"Proforma Invoice", true, true, SalesInvHeader);
                end;
            }
            action(ShowSVATInvoice)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'SVAT Invoice';
                Image = Print;
                ToolTip = 'Show SVAT Invoice for the selected sales invoice.';
                Enabled = Rec."Tax Area Code" = 'SVAT';
                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    Report.Run(Report::"4HC SVAT Invoice", true, true, SalesInvHeader);
                end;
            }
        }
        addafter(Print_Promoted)
        {
            actionref(ShowSVATInvoice_Promoted; ShowSVATInvoice)
            {
            }
            actionref(ProformaInvoice_Promoted; ProformaInvoice)
            {
            }
        }
    }
}