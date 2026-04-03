tableextension 50126 "4HC Item" extends Item
{
    fields
    {
        field(50100; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                          Blocked = const(false));
            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
    }
    trigger OnBeforeModify()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::Item, PermissionType::Modify);
    end;

    trigger OnBeforeDelete()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::Item, PermissionType::Delete);
    end;

    trigger OnBeforeInsert()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::Item, PermissionType::Insert);
    end;
}