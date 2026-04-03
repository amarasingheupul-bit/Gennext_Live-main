page 50136 "4HC Brand Target RC Part"
{
    Caption = 'Brand Targets';
    PageType = ListPart;
    SourceTable = "4HC Brand Solution Target";
    ApplicationArea = All;
    UsageCategory = None;
    SourceTableView = where(Type = const(Brand));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Year"; Rec."Year")
                {
                    ToolTip = 'Specifies the year for which the brand target is defined.';
                }
                field("Month"; Rec."Month")
                {
                    ToolTip = 'Specifies the month for which the brand target is defined.';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ToolTip = 'Specifies the Brand dimension value (configured as Shortcut Dimension 4).';
                }
                field("Amount"; Rec."Amount")
                {
                    ToolTip = 'Shows the total item ledger entry amount for the selected brand in the specified month.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // if (Rec."Year" <> 0) and (Rec."Month" <> 0) then
        //     Rec.SetRange("Date Filter",
        //                  DMY2Date(1, Rec."Month", Rec."Year"),
        //                  CalcDate('<CM>', DMY2Date(1, Rec."Month", Rec."Year")));
    end;
}