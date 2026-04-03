pageextension 50156 "4HC Posted Sales Invoices" extends "Posted Sales Invoices"
{
    actions
    {
        addlast(Reporting)
        {
            action("Customer Sales Statistics")
            {
                ApplicationArea = all;
                Caption = 'Customer Sales Statistics';
                Image = Report;
                ToolTip = 'Run Customer Sales Statistics Report.';
                trigger OnAction()
                begin
                    Report.Run(50101);
                end;
            }
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
        }
        addlast(Category_Report)
        {
            actionref(CustomerSalesStatistics_Promoted; "Customer Sales Statistics")
            {
            }
        }
        addafter(Print_Promoted)
        {
            actionref(ProformaInvoice_Promoted; ProformaInvoice)
            {
            }
        }
    }
}
