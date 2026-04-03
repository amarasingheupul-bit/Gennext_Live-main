page 50132 "4HC Salesperson Target Card"
{
    PageType = Card;
    SourceTable = "4HC Salesperson Target";
    Caption = 'Salesperson Target Card';
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Shows the salesperson linked to this target.';
                }
                field("Date"; Rec."Start Date")
                {
                    ToolTip = 'Enter a reference date; Year and Month are calculated automatically.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("Year"; Rec."Year")
                {
                    ToolTip = 'Shows the calculated year from the Date.';
                }
                field("Month"; Rec."Month")
                {
                    ToolTip = 'Shows the calculated month number from the Date.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the dimension code assigned (Shortcut Dimension 1).';
                }
                field("Monthly Target"; Rec."Monthly Target")
                {
                    ToolTip = 'Enter the total sales target set for this month.';
                }
                field("Monthly Achivement"; Rec."Monthly Achivement")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Monthly Achivement field.';
                }
                field("Balance Target to Achieve"; Rec."Balance Target to Achieve")
                {
                    ToolTip = 'Shows the remaining sales target to be achieved.';
                    Editable = false;
                }
                field("Monthly Cost"; Rec."Monthly Cost")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Monthly Cost field.';
                }
                field("Monthly GP Target"; Rec."Monthly GP Target")
                {
                    ToolTip = 'Enter the gross profit target set for this month.';
                }
                field("Monthly GP"; Rec."Monthly GP")
                {
                    Editable = false;
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