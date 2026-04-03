tableextension 50142 "4HC G/L Account" extends "G/L Account"
{
    fields
    {
    }
    trigger OnBeforeModify()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::"G/L Account", PermissionType::Modify);
    end;

    trigger OnBeforeDelete()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::"G/L Account", PermissionType::Delete);
    end;

    trigger OnBeforeInsert()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::"G/L Account", PermissionType::Insert);
    end;
}