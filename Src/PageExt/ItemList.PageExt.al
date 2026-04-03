pageextension 50158 "Item List" extends "Item List"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the code for Dimension 4 that is associated with the item.';
            }
        }
    }

    trigger OnOpenPage()
    var
        GNPermission: Codeunit "4HC Business Central";
        PermissionType: Enum "4HC Gennext Permission";
    begin
        GNPermission.PermissionCheck(Database::Item, PermissionType::Read);
    end;
}