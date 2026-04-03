pageextension 50102 "4HC Item Card" extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
            }
        }
    }
}