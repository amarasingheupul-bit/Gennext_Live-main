page 50139 "4HC Gennext Permission List"
{
    Caption = 'Gennext Permission List';
    PageType = List;
    SourceTable = "4HC Gennext Permission";
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTableView = sorting("User ID", "Table ID") order(ascending);

    layout
    {
        area(content)
        {
            repeater(Permissions)
            {
                Caption = 'Permissions';

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the salesperson/purchaser code used to identify the user for this permission entry.';
                }
                field("Table ID"; Rec."Table ID")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the ID of the table to which the permissions apply.';
                }
                field("Table Caption"; Rec."Table Caption")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the caption of the table selected in the Table ID field.';
                }
                field(Read; Rec."Read")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the user can read records in the selected table.';
                }
                field(Modify; Rec."Modify")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the user can modify records in the selected table.';
                }
                field(Insert; Rec."Insert")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the user can insert records in the selected table.';
                }
                field(Delete; Rec."Delete")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the user can delete records in the selected table.';
                }
            }
        }
    }
}