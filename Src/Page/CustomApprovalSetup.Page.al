page 50114 "4HC Custom Approval Setup"
{
    PageType = Card;
    SourceTable = "4HC Custom Approval Header";
    Caption = 'Gennext Approval Setup';
    UsageCategory = None;
    ApplicationArea = All;
    DataCaptionExpression = 'Gennext Approval Setup';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    Visible = false;
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
            part(ApprovalLines; "4HC Custom Approval Subform")
            {
                Enabled = Rec."Document Type" <> Rec."Document Type"::" ";
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("Entry No.");
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

        // Rec.Reset();
        // if not Rec.Get() then begin
        //     Rec.Init();
        //     Rec.Insert();
        // end;
    end;
}