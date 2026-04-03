report 50108 "Delete Post Value Entry to G/L"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Delete Post Value Entry to G/L';
    ProcessingOnly = true;
    Permissions = tabledata "Post Value Entry to G/L" = RIMD;

    trigger OnPreReport()
    begin
        DeletePostValueEntry();
    end;

    local procedure DeletePostValueEntry()
    var
        PostValueEntrytoGL: Record "Post Value Entry to G/L";
    begin
        PostValueEntrytoGL.Reset();
        if not PostValueEntrytoGL.IsEmpty() then PostValueEntrytoGL.DeleteAll();
    end;
}
