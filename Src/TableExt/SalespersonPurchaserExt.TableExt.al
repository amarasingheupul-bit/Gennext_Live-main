tableextension 50114 SalespersonPurchaserExt extends "Salesperson/Purchaser"
{
    fields
    {
        field(50100; Password; Text[100])
        {
            Caption = 'Password';
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(50101; UserLevel; Enum UserLevels)
        {
            Caption = 'User Level';
        }
        field(50102; UserDepartment; Enum UserDepartment)
        {
            Caption = 'User Department';
        }
        field(50103; Supervisor; Code[20])
        {
            Caption = 'Supervisor';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50104; "BC Map ID"; Code[50])
        {
            Caption = 'BC Map ID';
            TableRelation = User;
        }
        field(50105; "SP Profile"; Code[30])
        {
            Caption = 'SP Profile';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                AllProfile: Record "All Profile";
            begin
                if Page.RunModal(Page::Roles, AllProfile) = Action::LookupOK then
                    "SP Profile" := AllProfile."Profile ID";
            end;
        }
        field(50106; "Vice President"; Code[20])
        {
            Caption = 'Vice President';
            TableRelation = "Salesperson/Purchaser";
        }
    }
}
