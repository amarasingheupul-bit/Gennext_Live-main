page 50137 "4HC Solution Target RC Part"
{
    Caption = 'Solution Targets';
    PageType = ListPart;
    SourceTable = "4HC Brand Solution Target";
    ApplicationArea = All;
    UsageCategory = None;
    SourceTableView = where(Type = const(Solution));
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Year"; Rec."Year")
                {
                    ToolTip = 'Specifies the fiscal year for which the solution target is defined.';
                }
                field("Month"; Rec."Month")
                {
                    ToolTip = 'Specifies the month for which the solution target is defined.';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the solution dimension value as configured in Shortcut Dimension 3.';
                }
                field("Count"; Rec."Count")
                {
                    ToolTip = 'Shows the number of item ledger entries for the selected solution in the specified year and month.';
                }
            }
        }
    }
}