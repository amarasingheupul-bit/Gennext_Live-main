table 50111 "4HC Salesperson Target"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(2; "Start Date"; Date)
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
        field(11; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(3; "Month"; Integer)
        {
            Caption = 'Month';
            Editable = false;
        }
        field(4; "Year"; Integer)
        {
            Caption = 'Year';
            Editable = false;
        }
        field(5; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));
        }
        field(6; "Monthly Target"; Decimal)
        {
            Caption = 'Monthly Target';
            trigger OnValidate()
            begin
                "Balance Target to Achieve" := "Monthly Target" - "Monthly Achivement";
            end;
        }
        field(7; "Monthly GP Target"; Decimal)//Gross Profit
        {
            Caption = 'Monthly GP Target';
            trigger OnValidate()
            begin
                "Monthly GP" := "Monthly Achivement" - Abs("Monthly Cost");
                "Balance GP to Achieve" := "Monthly GP Target" - "Monthly GP";
            end;
        }
        field(8; "Balance Target to Achieve"; Decimal)
        {
            Caption = 'Balance Target to Achieve';
        }
        field(9; "Balance GP to Achieve"; Decimal)//Gross Profit
        {
            Caption = 'Balance GP to Achieve';
        }
        field(10; "GP %"; Decimal)
        {
            Caption = 'GP %';
        }
        field(12; "Monthly Achivement"; Decimal)
        {
            Caption = 'Monthly Achivement';
        }
        field(13; "Monthly Cost"; Decimal)
        {
            Caption = 'Monthly Cost';
        }
        field(14; "Monthly GP"; Decimal)//Gross Profit
        {
            Caption = 'Monthly GP';
        }
        field(15; "Cumulative GP Target"; Decimal)
        {
            Caption = 'Cumulative GP Target';
        }
        field(16; "Cumulative GP"; Decimal)
        {
            Caption = 'Cumulative GP';
        }
        field(17; "Cumulative GP Balance"; Decimal)
        {
            Caption = 'Cumulative GP Balance';
        }
    }

    keys
    {
        key(PK; "Salesperson Code", "Shortcut Dimension 1 Code", "Start Date", "End Date")
        {
            Clustered = true;
        }
    }
}