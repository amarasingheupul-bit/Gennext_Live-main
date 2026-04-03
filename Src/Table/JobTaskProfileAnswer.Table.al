table 50107 JobTaskProfileAnswer
{
    Caption = 'Job Task Profile Answer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(2; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(3; "Profile Questionnaire Code"; Code[20])
        {
            Caption = 'Profile Questionnaire Code';
            TableRelation = "Profile Questionnaire Header";
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Answer Priority"; Enum "Profile Answer Priority")
        {
            Caption = 'Answer Priority';
        }
        field(6; "Profile Questionnaire Priority"; Enum "Profile Questionnaire Priority")
        {
            Caption = 'Profile Questionnaire Priority';
        }
        field(7; Answer; Text[250])
        {
            Caption = 'Answer';
        }
        field(8; "Questions Answered (%)"; Decimal)
        {
            Caption = 'Questions Answered (%)';
            DecimalPlaces = 0 : 0;
        }
        field(9; "Last Date Updated"; Date)
        {
            Caption = 'Last Date Updated';
        }
    }
    keys
    {
        key(PK; "Job No.", "Job Task No.", "Profile Questionnaire Code", "Line No.")
        {
            Clustered = true;
        }
        key(Priority; "Job No.", "Job Task No.", "Answer Priority", "Profile Questionnaire Priority")
        {
        }
    }
    procedure Question(): Text[250]
    var
        ProfileQuestionnaireLine: Record "Profile Questionnaire Line";
    begin
        if ProfileQuestionnaireLine.Get("Profile Questionnaire Code", "Line No.") then exit(ProfileQuestionnaireLine.Question());
        exit('');
    end;
}
