report 50121 "Reset Sales Order Approver"
{
    ApplicationArea = All;
    Caption = 'Reset Sales Order Approver';
    ProcessingOnly = true;
    UsageCategory = Administration;

    Permissions = tabledata "Sales Header" = RIMD;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Order));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                SH: Record "Sales Header";
            begin
                SH.LockTable();

                if not SH.Get(SalesHeader."Document Type", SalesHeader."No.") then
                    Error('Sales Order %1 not found.', SalesHeader."No.");

                SH.Validate("Approver ID", '');
                SH.Modify(true);

                ProcessedCount += 1;
            end;

            trigger OnPreDataItem()
            begin
                if SalesHeader.GetFilter("No.") = '' then
                    Error('Please enter a Sales Order No. filter before running this report.');
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
            }
        }
    }

    trigger OnPostReport()
    begin
        Message('%1 Sales Order(s) updated successfully.', ProcessedCount);
    end;

    var
        ProcessedCount: Integer;
}