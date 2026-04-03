page 50133 "4HC Sales Target RC List"
{
    Caption = 'Salesperson Targets';
    PageType = ListPart;
    SourceTable = "4HC Salesperson Target";
    ApplicationArea = All;
    ShowFilter = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Specifies the salesperson for whom the target is set.';
                }
                field("Year"; Rec."Year")
                {
                    ToolTip = 'Year derived from the Date.';
                }
                field(MonthI; Rec.Month)
                {
                    ToolTip = 'Shows the calculated month number from the Date.';
                    Visible = false;
                }
                field("Month"; MonthName)
                {
                    Caption = 'Month';
                    ToolTip = 'Month derived from the Date.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the dimension code assigned (Shortcut Dimension 1).';
                }
                field("Monthly GP Target"; Rec."Monthly GP Target")
                {
                    ToolTip = 'Monthly gross profit target for this salesperson.';
                    Visible = false;
                }
                field("Cumulative GP Target"; Rec."Cumulative GP Target")
                {
                    Caption = 'GP Target';
                    ToolTip = 'Calculated Cumulative GP Target up to selected month.';
                }
                field("Monthly GP"; Rec."Monthly GP")
                {
                    ToolTip = 'Specifies the value of the Monthly GP field.';
                    Visible = false;
                }
                field("Cumulative GP"; Rec."Cumulative GP")
                {
                    Caption = 'GP Achived';
                    ToolTip = 'Specifies the value of the Cumulative GP field.';
                }
                field("Balance GP to Achieve"; Rec."Balance GP to Achieve")
                {
                    ToolTip = 'Outstanding gross profit required to reach target.';
                    Visible = false;
                }
                field("Cumulative GP Balance"; Rec."Cumulative GP Balance")
                {
                    ToolTip = 'Specifies the value of the Cumulative GP Balance field.';
                    Caption = 'Balance GP to Achieve';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ClearFilter)
            {
                Caption = 'Clear Filter';
                ToolTip = 'Clear Filter.';
                ApplicationArea = All;
                Image = ClearFilter;
                trigger OnAction()
                begin
                    this.ResetToTheCurrentDate();
                end;
            }
            action(April)
            {
                Caption = 'April';
                ToolTip = 'Filter records for April month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3);
                    ActionMonth := 4;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
            action(May)
            {
                Caption = 'May';
                ToolTip = 'Filter records for May month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3);
                    ActionMonth := 5;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
            action(June)
            {
                Caption = 'June';
                ToolTip = 'Filter records for June month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3);
                    ActionMonth := 6;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
            action(July)
            {
                Caption = 'July';
                ToolTip = 'Filter records for July month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3);
                    ActionMonth := 7;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
            action(August)
            {
                Caption = 'August';
                ToolTip = 'Filter records for August month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3);
                    ActionMonth := 8;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
            action(September)
            {
                Caption = 'September';
                ToolTip = 'Filter records for September month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3);
                    ActionMonth := 9;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
            action(Octomber)
            {
                Caption = 'Octomber';
                ToolTip = 'Filter records for Octomber month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3);
                    ActionMonth := 10;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
            action(November)
            {
                Caption = 'November';
                ToolTip = 'Filter records for November month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3);
                    ActionMonth := 11;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
            action(December)
            {
                Caption = 'December';
                ToolTip = 'Filter records for December month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3);
                    ActionMonth := 12;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
            action(January)
            {
                Caption = 'January';
                ToolTip = 'Filter records for January month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3) + 1;
                    ActionMonth := 1;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
            action(February)
            {
                Caption = 'February';
                ToolTip = 'Filter records for February month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3) + 1;
                    ActionMonth := 2;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
            action(March)
            {
                Caption = 'March';
                ToolTip = 'Filter records for March month.';
                ApplicationArea = All;
                Image = CalendarChanged;
                trigger OnAction()
                begin
                    ActionYear := Date2DMY(Today, 3) + 1;
                    ActionMonth := 3;
                    this.MonthlyGPTargetCalculate();
                    this.FilterPage();
                end;
            }
        }
    }
    var
        ActionYear: Integer;
        ActionMonth: Integer;
        MonthName: Text[10];

    trigger OnOpenPage()
    begin
        this.ResetToTheCurrentDate();
    end;

    local procedure FilterPage();
    begin
        Rec.SetRange(Month, ActionMonth);
    end;

    local procedure ResetToTheCurrentDate()
    begin
        ActionYear := Date2DMY(Today, 3);
        ActionMonth := Date2DMY(Today, 2);
        this.MonthlyGPTargetCalculate();
        this.FilterPage();
        Rec.Reset();
        this.FilterSalesperson();
    end;

    trigger OnAfterGetRecord()
    var
        BCcustom: Codeunit "4HC Business Central";
    begin
        BCcustom.CalculateMonthlyAchievmentAndGP(Rec);     
           Rec.Modify();
    end;

    local procedure MonthlyGPTargetCalculate()
    var
        SPT: Record "4HC Salesperson Target";
        SalesPerson: Record "Salesperson/Purchaser";
        MonthlyGPTarget: Decimal;
        MonthlyAchivement: Decimal;
    begin
        SalesPerson.Reset();
        Rec.Reset();
        if SalesPerson.FindSet() then
            repeat
                MonthlyGPTarget := 0;
                MonthlyAchivement := 0;
                SPT.Reset();
                SPT.SetCurrentKey("Start Date", "End Date", "Salesperson Code");
                SPT.Ascending(true);
                SPT.SetFilter("Start Date", '%1..', CalcDate('<-CM>', 20250401D));
                SPT.SetFilter("End Date", '..%1', this.GetTheEndDate(ActionMonth, ActionYear));
                SPT.SetRange("Salesperson Code", SalesPerson."Code");
                if SPT.FindSet() then
                    repeat
                        MonthlyGPTarget += SPT."Monthly GP Target";
                        MonthlyAchivement += SPT."Monthly GP";
                        SPT."Cumulative GP Target" := MonthlyGPTarget;
                        SPT."Cumulative GP" := MonthlyAchivement;
                        SPT."Cumulative GP Balance" := MonthlyGPTarget - MonthlyAchivement;
                        SPT.Modify();
                    until SPT.Next() = 0;
            until SalesPerson.Next() = 0;
        MonthName := this.SetMonthName(ActionMonth);
    end;

    local procedure GetTheEndDate(Month1: Integer; Year3: Integer): Date
    begin
        exit(CalcDate('<CM>', DMY2Date(1, Month1, Year3)));
    end;

    local procedure SetMonthName(MonthNum: Integer): Text[10]
    begin
        case MonthNum of
            1:
                exit('January');
            2:
                exit('February');
            3:
                exit('March');
            4:
                exit('April');
            5:
                exit('May');
            6:
                exit('June');
            7:
                exit('July');
            8:
                exit('August');
            9:
                exit('September');
            10:
                exit('October');
            11:
                exit('November');
            12:
                exit('December');
            else
                exit('');
        end;
    end;

    local procedure FilterSalesperson()
    var
        UserDiv: Record UserDeviation;
        Salesperson: Record "Salesperson/Purchaser";
        SalePersonSupervisor: Record "Salesperson/Purchaser";
        Filter: Text;
        Text0001Err: Label 'Please complete the authentication process to proceed with your task.';
    begin
        Rec.FilterGroup(19);
        if UserDiv.Get(SessionId()) then begin
            if Salesperson.Get(UserDiv.Salesperson) then begin
                if Salesperson.UserLevel = Salesperson.UserLevel::User then
                    Rec.SetRange("Salesperson Code", Salesperson.Code)
                else
                    if Salesperson.UserLevel = Salesperson.UserLevel::Supervisor then begin
                        Filter := UserDiv.Salesperson;
                        SalePersonSupervisor.SetRange(Supervisor, UserDiv.Salesperson);
                        if SalePersonSupervisor.FindSet() then
                            repeat
                                if Filter <> '' then
                                    Filter := Filter + '|' + SalePersonSupervisor.Code;
                            until SalePersonSupervisor.Next() = 0;
                        Rec.SetFilter("Salesperson Code", Filter);
                    end;

                if Salesperson."Global Dimension 1 Code" <> '' then
                    if (Salesperson.UserLevel = Salesperson.UserLevel::SeniorManager) or (Salesperson.UserLevel = Salesperson.UserLevel::Coordinator) then
                        Rec.SetRange("Shortcut Dimension 1 Code", Salesperson."Global Dimension 1 Code");
            end;
        end
        else
            Error(Text0001Err);
        Rec.FilterGroup(0);
    end;
}