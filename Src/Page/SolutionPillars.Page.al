page 50109 SolutionPillars
{
    ApplicationArea = All;
    Caption = 'Solution Pillars';
    PageType = List;
    SourceTable = SolutionPillar;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Solution; Rec.Solution)
                {
                    ApplicationArea = All;
                }
                field(SalespersonCode; Rec.SalespersonCode)
                {
                    ApplicationArea = All;
                }
                field(SalespersonName; Rec.SalespersonName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
