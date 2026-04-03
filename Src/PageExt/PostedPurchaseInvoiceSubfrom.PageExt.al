pageextension 50143 "Posted PurchInvoiceSubform Ext" extends "Posted Sales Invoice Subform"
{
    actions
    {
        addafter(Dimensions)
        {
            action(BlankComment)
            {
                Caption = 'Blank Comment';
                Image = Comment;
                ApplicationArea = All;
                ToolTip = 'Clears the Description field for the selected line.';
                trigger OnAction()
                var
                    SalesInvLine: Record "Sales Invoice Line";
                begin
                    SalesInvLine.SetRange("Document No.", Rec."Document No.");
                    SalesInvLine.SetRange("Line No.", Rec."Line No.");
                    if SalesInvLine.FindFirst() then
                        Report.Run(50113, true, false, SalesInvLine);
                end;
            }
        }
    }
}
report 50113 "Del Sales Invoice Subform"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Permissions = tabledata "Sales Invoice Line" = RIMD;
    ProcessingOnly = true;

    dataset
    {
        dataitem(SalesInvLine; "Sales Invoice Line")
        {
            RequestFilterFields = "Document No.", "Line No.";
            DataItemTableView = sorting("Document No.", "Line No.");
            trigger OnAfterGetRecord()
            begin
                if Type = Type::" " then
                    if Confirm('Do you want to delete the Description field for the selected line?', true) then
                        SalesInvLine.Delete(true);
            end;
        }
    }
}