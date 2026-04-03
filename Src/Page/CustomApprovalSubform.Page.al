page 50115 "4HC Custom Approval Subform"
{
    PageType = ListPart;
    SourceTable = "4HC Custom Approval Line";
    ApplicationArea = All;
    Caption = 'Approval Lines';
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Minimum Range"; Rec."Minimum Range")
                {
                    ToolTip = 'Specifies the value of the Margin % field.';
                }
                field("Maximum Range"; Rec."Maximum Range")
                {
                    ToolTip = 'Specifies the value of the Value field.';
                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ToolTip = 'Specifies the approver for this line.';
                }
                field(Director; Rec.Director)
                {
                    ToolTip = 'Specifies the value of the Director field.';
                }
            }
        }
    }
}