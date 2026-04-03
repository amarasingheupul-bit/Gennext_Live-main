table 50109 "4HC Custom Approval Header"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Sales Quote Approval Process"; Boolean)
        {
            Caption = 'Sales Quote Approval Process';
            ObsoleteState = Pending;
            ObsoleteTag = '4HC20250905';
            ObsoleteReason = 'Replaced by Document Type field';
        }
        field(3; "Approval Amount"; Decimal)
        {
            Caption = 'Approval Amount';
        }
        field(4; "Approval Margin"; Decimal)
        {
            Caption = 'Approval Margin';
        }
        field(5; Enabled; Boolean)
        {
            Caption = 'Enabled';
        }
        field(6; "Document Type"; Enum "4HC Approval Doc Type")
        {
            Caption = 'Document Type';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(key2; "Document Type", "Entry No.")
        {
        }
    }
}