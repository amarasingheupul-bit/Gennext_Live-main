report 50116 "4HC Delete Old Opportunities"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Delete Opportunities';
    ProcessingOnly = true;
    Permissions = tabledata Opportunity = RIMD;

    dataset
    {
        dataitem(Opportunity; Opportunity)
        {
            RequestFilterFields = "No.", "Salesperson Code";

            trigger OnAfterGetRecord()
            begin
                DeleteFilterdOpportunity(Opportunity."No.");
            end;

            trigger OnPostDataItem()
            begin
                Message('Opportunities deleted successfully.');
            end;
        }
    }

    local procedure DeleteFilterdOpportunity(OpportunityNumber: Code[20])
    var
        DeleteOpportunity: Record Opportunity;
        DeleteOpportunityEntry: Record "Opportunity Entry";
    begin
        DeleteOpportunity.Reset();
        if DeleteOpportunity.Get(OpportunityNumber) then
            DeleteOpportunity.Delete();

        DeleteOpportunityEntry.Reset();
        DeleteOpportunityEntry.SetRange("Opportunity No.", OpportunityNumber);
        if DeleteOpportunityEntry.FindSet() then
            DeleteOpportunityEntry.DeleteAll();
    end;
}
