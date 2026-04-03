report 50109 "Delete GL Entry VAT Entry Link"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Delete GL Entry VAT Entry Link';
    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry - VAT Entry Link"=RIMD;

    trigger OnPreReport()
    begin
        DeletePostValueEntry();
    end;
    local procedure DeletePostValueEntry()
    var
        GLEntryVatEntryLink: Record "G/L Entry - VAT Entry Link";
    begin
        GLEntryVatEntryLink.Reset();
        if not GLEntryVatEntryLink.IsEmpty()then GLEntryVatEntryLink.DeleteAll();
    end;
}
