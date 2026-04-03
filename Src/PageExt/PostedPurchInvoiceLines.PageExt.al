pageextension 50163 "4HC Posted Purch Invoice Lines" extends "Posted Purchase Invoice Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("GL Dim Updated"; Rec."GL Dim Updated")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GL Dim Updated field.';
            }
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
                Caption = 'Update Item Dimension';
                trigger OnAction()
                begin
                    if Confirm('Do you want to Continue Update.') then
                        UpdateDim.UpdateDimensionPurchaseInvoice();
                end;
            }
        }
    }
    var
        UpdateDim: Codeunit "4HC Gennext Update Entries";
}
