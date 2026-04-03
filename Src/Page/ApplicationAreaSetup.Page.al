page 50110 ApplicationAreaSetup
{
    ApplicationArea = All;
    Caption = 'Application Area Setup';
    SourceTable = "Application Area Setup";
    PageType = List;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = all;
                }
                field("Profile ID"; Rec."Profile ID")
                {
                    ApplicationArea = all;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                }
                field("Sales Tax"; Rec."Sales Tax")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
