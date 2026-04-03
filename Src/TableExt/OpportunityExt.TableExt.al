tableextension 50110 OpportunityExt extends Opportunity
{
    fields
    {
        field(50100; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), Blocked = const(false));
        }
        field(50101; solutionPillar; Code[20])
        {
            Caption = 'Solution Pillar';
            TableRelation = SolutionPillar;
        }
        field(50102; TaskComment; Boolean)
        {
            Caption = 'Task Comment';
        }
        field(50103; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));
        }
        field(50104; "Estimated GP"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Estimated GP';
        }
    }
}
