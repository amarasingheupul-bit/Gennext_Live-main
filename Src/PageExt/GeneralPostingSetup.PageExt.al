pageextension 50160 "4HC General Posting Setup" extends "General Posting Setup"
{
    layout
    {
    }
    trigger OnOpenPage()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::"General Posting Setup", PermissionType::Read);
    end;
}