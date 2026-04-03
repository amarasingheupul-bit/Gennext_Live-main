report 50118 "4HC Update GL Entries SP"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Update GL Entries - Sales Person';
    ProcessingOnly = true;
    dataset
    {
        dataitem(GLAccountEntry; "G/L Entry")
        {
            RequestFilterFields = "G/L Account No.", "Document No.";
            DataItemTableView = sorting("Entry No.") where("Salesperson Code" = filter(''));
            trigger OnPreDataItem()
            begin
                Window.Open('Updating G/L Entries... #1######');
            end;

            trigger OnAfterGetRecord()
            begin
                if ("G/L Account No." = '') and ("Document No." = '') then
                    exit;

                if UpdateFromValueEntry then
                    if this.SPGLEntryUpdate.UpdateSalesPersonInGLEntry(GLAccountEntry) then
                        UpdateCount += 1;

                Window.Update(1, "Entry No.");
                if UpdateFromSalesInvHeader then
                    if this.SPGLEntryUpdate.UpdateSalesPersonFromSalesInvHeaderInGLEntry(GLAccountEntry) then
                        UpdateCount += 1;

                if UpdateFromPurchaseInvHeader then
                    if this.SPGLEntryUpdate.UpdateSalesPersonFromPurchaseInvHeaderInGLEntry(GLAccountEntry) then
                        UpdateCount += 1;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Group)
                {
                    Caption = 'Options';
                    field(UpdateFromValueEntryfi; UpdateFromValueEntry)
                    {
                        ApplicationArea = All;
                        Caption = 'Update from Value Entry';
                        ToolTip = 'If selected, the Sales Person Code will be updated from the Value Entry table.';
                    }
                    field(UpdateFromSalesInvHeaderfi; UpdateFromSalesInvHeader)
                    {
                        ApplicationArea = All;
                        Caption = 'Update from Sales Invoice Header';
                        ToolTip = 'If selected, the Sales Person Code will be updated from the Sales Invoice Header table.';
                    }
                    field(UpdateFromPurchaseInvHeaderfi; UpdateFromPurchaseInvHeader)
                    {
                        ApplicationArea = All;
                        Caption = 'Update from Purchase Invoice Header';
                        ToolTip = 'If selected, the Sales Person Code will be updated from the Purchase Invoice Header table.';
                    }
                }
            }

        }
    }
    trigger OnPostReport()
    begin
        Window.Close();
        Message(SucessMsgLbl, UpdateCount);
    end;

    var
        SPGLEntryUpdate: Codeunit "4HC Gennext Update Entries";
        SucessMsgLbl: Label 'Total %1 GL Entries updated successfully.', Comment = '%1=count';
        UpdateCount: Integer;
        UpdateFromValueEntry: Boolean;
        UpdateFromSalesInvHeader: Boolean;
        UpdateFromPurchaseInvHeader: Boolean;
        Window: Dialog;
}
