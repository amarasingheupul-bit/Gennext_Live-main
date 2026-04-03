table 50112 "4HC Brand Solution Target"
{
    DataClassification = CustomerContent;
    Caption = 'Brand/Solution Target';

    fields
    {
        field(1; "Start Date"; Date)
        {
            Caption = 'Start Date';
            trigger OnValidate()
            begin
                "End Date" := CalcDate('<CM>', "Start Date");
                if "Start Date" <> 0D then begin
                    "Month" := Date2DMY("Start Date", 2); // Month number 1-12
                    "Year" := Date2DMY("Start Date", 3); // Year value like 2024
                end else begin
                    "Month" := 0;
                    "Year" := 0;
                end;
            end;
        }
        field(2; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(3; "Type"; Enum "4HC Target Type")
        {
            Caption = 'Target Type';
            ToolTip = 'Specifies if the target is related to a Brand or a Solution.';
        }
        // Brand
        field(4; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            ToolTip = 'Specifies the dimension value used for Brand (Shortcut Dimension 4).';
            TableRelation = "Dimension Value".Code
                where("Global Dimension No." = const(4), Blocked = const(false));
        }
        // Solution
        field(5; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            ToolTip = 'Specifies the dimension value used for Solution (Shortcut Dimension 3).';
            TableRelation = "Dimension Value".Code
                where("Global Dimension No." = const(3), Blocked = const(false));
        }
        field(6; "Amount"; Decimal)
        {
            Caption = 'Amount';
            ToolTip = 'Sums item ledger entry amounts filtered by Shortcut Dimension 4 for the specified month.';
        }
        field(7; "Count"; Integer)
        {
            Caption = 'Count';
            ToolTip = 'Counts item ledger entries filtered by Shortcut Dimension 3 for the specified month.';
        }
        field(8; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            ToolTip = 'Specifies the date filter used by the FlowFields.';
            FieldClass = FlowFilter;
        }
        field(9; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(10; "Month"; Integer)
        {
            Caption = 'Month';
            Editable = false;
        }
        field(11; "Year"; Integer)
        {
            Caption = 'Year';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Type, "Start Date", "End Date", "Shortcut Dimension 3 Code")
        {
        }
        key(Key3; Type, "Start Date", "End Date", "Shortcut Dimension 4 Code")
        {
        }
    }
    procedure CountTheEntriesBasedSolution()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        Rec.Count := 0;
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetFilter("Document Type", '%1|%2', ItemLedgerEntry."Document Type"::"Sales Invoice", ItemLedgerEntry."Document Type"::"Sales Credit Memo");
        ItemLedgerEntry.SetRange("Posting Date", Rec."Start Date", Rec."End Date");
        ItemLedgerEntry.SetRange("Shortcut Dimension 3 Code", Rec."Shortcut Dimension 3 Code");
        Rec.Count := ItemLedgerEntry.Count();
    end;

    procedure CalculateTheAmountBasedBrand()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        Rec.Amount := 0;
        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetFilter("Document Type", '%1|%2', ItemLedgerEntry."Document Type"::"Sales Invoice", ItemLedgerEntry."Document Type"::"Sales Credit Memo");
        ItemLedgerEntry.SetRange("Posting Date", Rec."Start Date", Rec."End Date");
        ItemLedgerEntry.SetRange("Shortcut Dimension 4 Code", Rec."Shortcut Dimension 4 Code");
        if ItemLedgerEntry.FindSet() then
            repeat
                ItemLedgerEntry.CalcFields("Sales Amount (Actual)");
                Rec.Amount += ItemLedgerEntry."Sales Amount (Actual)";
            until ItemLedgerEntry.Next() = 0;
    end;
}