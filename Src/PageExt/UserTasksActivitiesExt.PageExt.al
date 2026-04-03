pageextension 50116 UserTasksActivitiesExt extends "User Tasks Activities"
{
    layout
    {
        addafter("My User Tasks")
        {
            cuegroup(PendingMyTasks)
            {
                Caption = 'Pending My Tasks';

                field(PendingTaskscount; PendingTaskscount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pending My Tasks';
                    Image = Checklist;
                    ToolTip = 'Specifies the number of pending tasks that are assigned to you';

                    trigger OnDrillDown()
                    begin
                        GetPendingTasks(false);
                    end;
                }
            }
            cuegroup(AllUsersPendingTasks)
            {
                Caption = 'Pending All Users Tasks';
                Visible = AllTasksVisible;

                field(AllUsersPendingTasksCount; AllUsersPendingTasksCount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pending All Users Tasks';
                    Image = Checklist;
                    ToolTip = 'Specifies the number of pending tasks that are assigned to all users';

                    trigger OnDrillDown()
                    begin
                        GetPendingTasks(true);
                    end;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CheckAllTasksVisible();
        PendingTaskscount := CalculatePendingTaskCount(false);
        AllUsersPendingTasksCount := CalculatePendingTaskCount(true);
    end;

    local procedure CalculatePendingTaskCount(AllTasks: Boolean): Integer
    var
        ToDo: Record "To-do";
    begin
        ToDo.SetRange(Closed, false);
        if not AllTasks then ToDo.SetRange("Salesperson Code", UserId);
        exit(ToDo.Count)
    end;

    local procedure GetPendingTasks(AllTasks: Boolean)
    var
        ToDo: Record "To-do";
        TaskList: page "Task List";
    begin
        ToDo.SetRange(Closed, false);
        if not AllTasks then ToDo.SetRange("Salesperson Code", UserId);
        TaskList.SetTableView(ToDo);
        TaskList.RunModal();
    end;

    local procedure CheckAllTasksVisible()
    begin
        if not UserSetup.Get(UserId) then exit;
        if UserSetup.PresalesAdmin then
            AllTasksVisible := true
        else
            AllTasksVisible := false
    end;

    var
        UserSetup: Record "User Setup";
        PendingTaskscount: Integer;
        AllUsersPendingTasksCount: Integer;
        AllTasksVisible: Boolean;
}
