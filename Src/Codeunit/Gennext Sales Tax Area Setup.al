codeunit 50112 "Gennext Sales Tax Area Setup"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
    begin
        if not ApplicationAreaSetup.Get(CompanyName()) then begin
            ApplicationAreaSetup.Init();
            ApplicationAreaSetup."Company Name" := CompanyName();
            ApplicationAreaSetup."Sales Tax" := true;
            ApplicationAreaSetup.Insert(true);
        end else begin
            if not ApplicationAreaSetup."Sales Tax" then begin
                ApplicationAreaSetup."Sales Tax" := true;
                ApplicationAreaSetup.Modify(true);
            end;
        end;
    end;
}