pageextension 50161 "4HC Posted SalesInvLines" extends "Posted Sales Invoice Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("GL Dim Updated"; Rec."GL Dim Updated")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GL Dim Updated field.', Comment = '%';
            }
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = true;
        }
    }
    actions
    {
        addafter("&Line")
        {
            action(UpdateItemDimension)
            {
                ApplicationArea = All;
                Image = Administration;
                ToolTip = 'Update Item Dimension';
                Caption = 'Update Dimensions';
                trigger OnAction()
                var
                    SaleInvLine: Record "Sales Invoice Line";
                begin
                    if Confirm('Do you want to Continue Update.') then begin
                        CurrPage.SetSelectionFilter(SaleInvLine);
                        UpdateDim.UpdateItemDimension(SaleInvLine);
                    end;
                end;
            }
        }
    }
    var
        UpdateDim: Codeunit "4HC Gennext Update Entries";
}
