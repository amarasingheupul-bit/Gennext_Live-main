pageextension 50115 OpportunityListExt extends "Opportunity List"
{
    layout
    {
        modify("Contact Company Name")
        {

            ApplicationArea = All;
        }
        moveafter("Contact No."; "Contact Company Name")
        addafter(CurrSalesCycleStage)
        {
            field(TaskComment; Rec.TaskComment)
            {
                ApplicationArea = All;
                ToolTip = 'Indicates whether a related task comment exists for the opportunity.';
            }
        }
        addafter("Estimated Value (LCY)")
        {
            field("Estimated GP"; Rec."Estimated GP")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Estimated GP field.';
            }
        }
        addlast(Control1)
        {
            field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
            }
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
            }
        }
    }
    actions
    {
        addlast(navigation)
        {
            action(WonOpportunities)
            {
                ApplicationArea = All;
                Caption = 'WON/In-Progress Opportunities';
                Image = Opportunity;
                ToolTip = 'View WON and In Progress Opportunities.';
                trigger OnAction()
                begin
                    Page.Run(50138);
                end;
            }
        }
        addafter("Show Sales Quote_Promoted")
        {
            actionref(WonOpportunities_Promoted; WonOpportunities)
            {
            }
        }
    }
    trigger OnOpenPage()
    begin
        FilterSalesperson();
    end;

    trigger OnAfterGetRecord()
    begin
        FindTaskCommentExist();
    end;

    local procedure FindTaskCommentExist()
    var
        SolutionPill: Record SolutionPillar;
        Todo: Record "To-do";
        RlshpMgtCommentLine: Record "Rlshp. Mgt. Comment Line";
    begin
        SolutionPill.SetRange(Solution, Rec.solutionPillar);
        if not SolutionPill.FindFirst() then exit;
        Todo.SetRange("Salesperson Code", SolutionPill.SalespersonCode);
        Todo.SetRange("Opportunity No.", Rec."No.");
        if Todo.FindSet() then
            repeat
                RlshpMgtCommentLine.SetRange("Table Name", "Rlshp. Mgt. Comment Line Table Name"::"To-do");
                RlshpMgtCommentLine.SetRange("Sub No.", 0);
                RlshpMgtCommentLine.SetRange("No.", Todo."Organizer To-do No.");
                if RlshpMgtCommentLine.FindFirst() then begin
                    Rec.TaskComment := true;
                    break;
                end;
            until Todo.Next() = 0;
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
