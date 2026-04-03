pageextension 50129 SalespersonPurchaserCardExt extends "Salesperson/Purchaser Card"
{
    layout
    {
        addlast(General)
        {
            field(UserLevel; Rec.UserLevel)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the UserLevel field.';
            }
            field(Supervisor; Rec.Supervisor)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Supervisor field.';
            }
            field("Vice President"; Rec."Vice President")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vice President field.';
            }
            field(Password; Rec.Password)
            {
                ApplicationArea = All;
                Visible = PasswordVisible;
                ToolTip = 'Specifies the value of the Password field.';
            }
            field("BC Map ID"; Rec."BC Map ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BC Map ID field.';
            }
            field("SP Profile"; Rec."SP Profile")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the SP Profile field.';
            }
        }
    }
    trigger OnOpenPage()
    begin
        this.SetPasswordVisible();
    end;

    trigger OnAfterGetRecord()
    begin
        this.SetPasswordVisible();
    end;

    local procedure SetPasswordVisible()
    var
        SalesNReceivableSetup: Record "Sales & Receivables Setup";
        UserDiv: Record UserDeviation;
    begin
        SalesNReceivableSetup.Get();
        if UserDiv.Get(SessionId()) then
            if UserDiv.Salesperson = SalesNReceivableSetup.Director then
                PasswordVisible := true
            else
                PasswordVisible := false;
    end;

    var
        PasswordVisible: Boolean;
}
