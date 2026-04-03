pageextension 50159 "4HC Vendor List" extends "Vendor List"
{
    layout
    {
    }
    trigger OnOpenPage()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::Vendor, PermissionType::Read);
    end;
}