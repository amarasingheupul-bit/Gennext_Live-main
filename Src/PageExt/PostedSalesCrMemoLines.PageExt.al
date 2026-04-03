pageextension 50152 "4HC Posted Sales CrMemo Lines" extends "Posted Sales Credit Memo Lines"
{
    layout
    {
        addlast(Control1)
        {
            field("Applies-to Doc. No. 4HC"; Rec."Applies-to Doc. No. 4HC")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Applies-to Doc. No. field.';
            }
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
                        UpdateDim.UpdateItemDimensionCreditNote();
                end;
            }
        }
    }
    var
        UpdateDim: Codeunit "4HC Gennext Update Entries";
}
