pageextension 50157 "4HC Chart of Accounts" extends "Chart of Accounts"
{
    trigger OnOpenPage()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::"G/L Account", PermissionType::Read);
    end;
}