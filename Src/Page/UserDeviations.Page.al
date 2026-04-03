page 50112 UserDeviations
{
    ApplicationArea = All;
    Caption = 'User Deviations';
    PageType = List;
    SourceTable = UserDeviation;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(UserID; Rec.UserID)
                {
                    ApplicationArea = All;
                }
                field(Salesperson; Rec.Salesperson)
                {
                    ApplicationArea = All;
                }
                field(LoginDateTime; Rec.LoginDateTime)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
