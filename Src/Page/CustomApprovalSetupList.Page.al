page 50126 "4HC Custom Approval Setup List"
{
    PageType = List;
    SourceTable = "4HC Custom Approval Header";
    Caption = 'Gennext Approval Setup';
    UsageCategory = Administration;
    ApplicationArea = All;
    CardPageId = "4HC Custom Approval Setup";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the unique entry number for this approval header.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies the value of the Enabled field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserDiv: Record UserDeviation;
        Text0001Err: Label 'Please complete the authentication process to proceed with your task.';
    begin
        if not UserDiv.Get(SessionId()) then
            Error(Text0001Err);
    end;
}