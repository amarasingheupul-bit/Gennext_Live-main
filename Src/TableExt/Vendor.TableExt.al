tableextension 50135 "4HC Vendor" extends Vendor
{
    fields
    {
        field(50100; Payee; Text[80])
        {
        }
    }
    trigger OnBeforeModify()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::Vendor, PermissionType::Modify);
    end;

    trigger OnBeforeDelete()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::Vendor, PermissionType::Delete);
    end;

    trigger OnBeforeInsert()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::Vendor, PermissionType::Insert);
    end;
}