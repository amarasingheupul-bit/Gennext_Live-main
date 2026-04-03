report 50112 "Update Dimension Report"
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Update Dimension Report';
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Opportunity; Opportunity)
        {
            DataItemTableView = where("Shortcut Dimension 1 Code" = const(''));
            RequestFilterFields = "No.", "Salesperson Code";
            trigger OnAfterGetRecord()
            var
                SalesPerson: Record "Salesperson/Purchaser";
            begin
                TestField("Salesperson Code");
                SalesPerson.Get(Opportunity."Salesperson Code");
                Opportunity.Validate("Shortcut Dimension 1 Code", SalesPerson."Global Dimension 1 Code");
                Opportunity.Modify();
            end;
        }
    }
}