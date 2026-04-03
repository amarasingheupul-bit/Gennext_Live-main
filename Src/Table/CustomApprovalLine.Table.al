table 50110 "4HC Custom Approval Line"
{
    Caption = '4HC Custom Approval Line';

    fields
    {
        field(1; Type; Enum "Approval Base Type")
        {
            Caption = 'Type';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Minimum Range"; Decimal)
        {
            Caption = 'Minimum Range';
        }
        field(4; "Maximum Range"; Decimal)
        {
            Caption = 'Maximum Range';
        }
        field(5; "Approver ID"; Code[20])
        {
            Caption = 'Approver ID';
            TableRelation = "Salesperson/Purchaser";
        }
        field(6; Director; Boolean)
        {
            Caption = 'Director';
        }
        field(7; "Document Type"; Enum "4HC Approval Doc Type")
        {
            Caption = 'Document Type';
        }
        field(8; "Document No."; Integer)
        {
            Caption = 'Document No.';
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));
        }
    }

    keys
    {
        key(PK; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; Type, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code")
        {
        }
        key(Key3; "Document Type", "Document No.")
        {
        }
    }
}