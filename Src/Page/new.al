page 50142 "Gennext Sales Tax Verify"
{
    ApplicationArea = All;
    Caption = 'Gennext Sales Tax Setup Verify';
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(StatusGroup)
            {
                Caption = 'Application Area Setup Status';

                field(CompanyNameField; CompanyNameField)
                {
                    ApplicationArea = All;
                    Caption = 'Company Name';
                    Editable = false;
                }
                field(SalesTaxStatus; SalesTaxStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Tax Enabled';
                    Editable = false;
                    StyleExpr = SalesTaxStyle;
                }
                field(RecordExists; RecordExists)
                {
                    ApplicationArea = All;
                    Caption = 'Setup Record Exists';
                    Editable = false;
                }
            }
            group(JobQueueGroup)
            {
                Caption = 'Job Queue Status';

                field(JobExists; JobExists)
                {
                    ApplicationArea = All;
                    Caption = 'Job Queue Entry Exists';
                    Editable = false;
                }
                field(JobStatus; JobStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Job Status';
                    Editable = false;
                    StyleExpr = JobStatusStyle;
                }
                field(JobDescription; JobDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Job Description';
                    Editable = false;
                }
                field(LastRunDateTime; LastRunDateTime)
                {
                    ApplicationArea = All;
                    Caption = 'Last Run Date/Time';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunJobNow)
            {
                ApplicationArea = All;
                Caption = 'Run Job Now';
                Image = Start;

                trigger OnAction()
                var
                    GennextSalesTax: Codeunit "Gennext Sales Tax Area Setup";
                    JobQueueEntry: Record "Job Queue Entry"; // ✅ Pass required record
                begin
                    GennextSalesTax.Run(JobQueueEntry);
                    Message('✅ Job executed successfully.');
                    RefreshStatus();
                    CurrPage.Update(false);
                end;
            }
            action(ScheduleJob)
            {
                ApplicationArea = All;
                Caption = 'Schedule Job Queue';
                Image = Reconcile;

                trigger OnAction()
                var
                    GennextJobSetup: Codeunit "Gennext Job Queue Setup";
                begin
                    GennextJobSetup.ScheduleSalesTaxSetup();
                    Message('✅ Job Queue scheduled successfully.');
                    RefreshStatus();
                    CurrPage.Update(false);
                end;
            }
            action(RefreshAction)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;

                trigger OnAction()
                begin
                    RefreshStatus();
                    CurrPage.Update(false);
                end;
            }
            action(OpenJobQueueEntries)
            {
                ApplicationArea = All;
                Caption = 'Open Job Queue Entries';
                Image = JobQueue;
                RunObject = Page "Job Queue Entries";
            }
            action(OpenJobQueueLog)
            {
                ApplicationArea = All;
                Caption = 'Open Job Queue Log';
                Image = Log;
                RunObject = Page "Job Queue Log Entries";
            }
        }
    }

    var
        CompanyNameField: Text;
        SalesTaxStatus: Boolean;
        SalesTaxStyle: Text;
        RecordExists: Boolean;
        JobExists: Boolean;
        JobStatus: Text;
        JobStatusStyle: Text;
        JobDescription: Text;
        LastRunDateTime: DateTime;

    trigger OnOpenPage()
    begin
        RefreshStatus();
    end;

    local procedure RefreshStatus()
    var
        ApplicationAreaSetup: Record "Application Area Setup";
        JobQueueEntry: Record "Job Queue Entry";
    begin
        // Company Info
        CompanyNameField := CompanyName();

        // ApplicationAreaSetup Check
        if ApplicationAreaSetup.Get(CompanyName()) then begin
            RecordExists := true;
            SalesTaxStatus := ApplicationAreaSetup."Sales Tax";
            if SalesTaxStatus then
                SalesTaxStyle := 'Favorable'
            else
                SalesTaxStyle := 'Unfavorable';
        end else begin
            RecordExists := false;
            SalesTaxStatus := false;
            SalesTaxStyle := 'Unfavorable';
        end;

        // Job Queue Check
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"Gennext Sales Tax Area Setup");
        if JobQueueEntry.FindFirst() then begin
            JobExists := true;
            JobDescription := JobQueueEntry.Description;
            LastRunDateTime := JobQueueEntry."Last Ready State";
            case JobQueueEntry.Status of
                JobQueueEntry.Status::Ready:
                    begin
                        JobStatus := 'Ready';
                        JobStatusStyle := 'Favorable';
                    end;
                JobQueueEntry.Status::Error:
                    begin
                        JobStatus := 'Error';
                        JobStatusStyle := 'Unfavorable';
                    end;
                JobQueueEntry.Status::"In Process":
                    begin
                        JobStatus := 'In Process';
                        JobStatusStyle := 'Ambiguous';
                    end;
                JobQueueEntry.Status::"On Hold":
                    begin
                        JobStatus := 'On Hold';
                        JobStatusStyle := 'Ambiguous';
                    end;
                else begin
                    JobStatus := 'Unknown';
                    JobStatusStyle := 'None';
                end;
            end;
        end else begin
            JobExists := false;
            JobStatus := 'Not Scheduled';
            JobStatusStyle := 'Unfavorable';
            JobDescription := '';
            LastRunDateTime := 0DT;
        end;
    end;
}