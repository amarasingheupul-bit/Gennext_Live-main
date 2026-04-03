tableextension 50143 "4HC General Posting Setup" extends "General Posting Setup"
{
    fields
    {
    }
    trigger OnBeforeModify()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::"General Posting Setup", PermissionType::Modify);
    end;

    trigger OnBeforeDelete()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::"General Posting Setup", PermissionType::Delete);
    end;

    trigger OnBeforeInsert()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::"General Posting Setup", PermissionType::Insert);
    end;
}