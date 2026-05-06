codeunit 50113 "Gennext Job Queue Setup"
{
    procedure ScheduleSalesTaxSetup()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        // Check if job already exists
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Gennext Sales Tax Area Setup");
        if not JobQueueEntry.IsEmpty() then
            exit; // Already scheduled

        // Create new Job Queue Entry
        JobQueueEntry.Init();
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := Codeunit::"Gennext Sales Tax Area Setup";
        JobQueueEntry.Description := 'Gennext - Enable Sales Tax Application Area';

        // Schedule: Run daily
        JobQueueEntry."Recurring Job" := true;
        JobQueueEntry."Run on Mondays" := true;
        JobQueueEntry."Run on Tuesdays" := true;
        JobQueueEntry."Run on Wednesdays" := true;
        JobQueueEntry."Run on Thursdays" := true;
        JobQueueEntry."Run on Fridays" := true;
        JobQueueEntry."Run on Saturdays" := true;
        JobQueueEntry."Run on Sundays" := true;
        JobQueueEntry."Starting Time" := 050000T; // 5.00AM
        JobQueueEntry."No. of Minutes between Runs" := 1440; // Once per day

        JobQueueEntry.Insert(true);

        // ✅ Correct way to set status to Ready
        JobQueueEntry.SetStatus(JobQueueEntry.Status::Ready);
    end;
}