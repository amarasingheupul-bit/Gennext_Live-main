page 50131 "4HC Salesperson Target List"
{
    PageType = List;
    SourceTable = "4HC Salesperson Target";
    Caption = 'Salesperson Target List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "4HC Salesperson Target Card";
    Editable = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Specifies the salesperson for whom the target is defined.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Enter a reference date; Year and Month are calculated automatically.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Year"; Rec."Year")
                {
                    ToolTip = 'Calculated year from the date.';
                }
                field("Month"; Rec."Month")
                {
                    ToolTip = 'Calculated month number from the date.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the primary dimension value for reporting.';
                }
                field("Monthly Target"; Rec."Monthly Target")
                {
                    ToolTip = 'Enter the total sales target set for this month.';
                }
                field("Monthly Achivement"; Rec."Monthly Achivement")
                {
                    ToolTip = 'Specifies the value of the Monthly Achivement field.';
                }
                field("Balance Target to Achieve"; Rec."Balance Target to Achieve")
                {
                    ToolTip = 'Shows the remaining sales target to be achieved.';
                    Editable = false;
                }
                field("Monthly Cost"; Rec."Monthly Cost")
                {
                    ToolTip = 'Specifies the value of the Monthly Cost field.';
                }
                field("Monthly GP Target"; Rec."Monthly GP Target")
                {
                    ToolTip = 'Enter the gross profit target set for this month.';
                }
                field("Monthly GP"; Rec."Monthly GP")
                {
                    ToolTip = 'Specifies the value of the Monthly GP field.';
                }
                field("Balance GP to Achieve"; Rec."Balance GP to Achieve")
                {
                    ToolTip = 'Shows the remaining gross profit target to be achieved.';
                    Editable = false;
                }
                field("GP %"; Rec."GP %")
                {
                    ToolTip = 'Indicates the gross profit percentage achieved.';
                    Editable = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        BCcustom: Codeunit "4HC Business Central";
    begin
        BCcustom.CalculateMonthlyAchievmentAndGP(Rec);
        Rec.Modify();
    end;
}