page 50113 UserLoginIdentification
{
    ApplicationArea = All;
    Caption = 'Gennext User Authentication';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field(Salesperson; Salesperson)
            {
                Caption = 'User';
            }
            field(Password; Password)
            {
                Caption = 'Password';
                ExtendedDatatype = Masked;
            }
            field(UpdatePasswordToggle; UpdatePasswordToggle)
            {
                Caption = 'Update Password';

                trigger OnValidate()
                begin
                    CurrPage.Update(false);
                end;
            }
            group(UpdatePasswordGroup)
            {
                Caption = 'Change Password';
                Visible = UpdatePasswordToggle;

                field(OldPassword; OldPassword)
                {
                    Caption = 'Current Password';
                    ExtendedDatatype = Masked;
                }
                field(NewPassword; NewPassword)
                {
                    Caption = 'New Password';
                    ExtendedDatatype = Masked;
                }
                field(ConfirmNewPassword; ConfirmNewPassword)
                {
                    Caption = 'Confirm New Password';
                    ExtendedDatatype = Masked;
                }
            }
        }
    }

    var
        Password: Text[100];
        Salesperson: Code[20];
        OldPassword: Text[100];
        NewPassword: Text[100];
        ConfirmNewPassword: Text[100];
        UpdatePasswordToggle: Boolean;

    procedure GetSalesPerson(): Code[20]
    begin
        exit(Salesperson);
    end;

    local procedure CheckUserNamePassword()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Text0001Err: Label 'User ID Invalid for this salesperson.';
    begin
        if Salesperson = '' then Error('Authentication details can not be empty.');
        if Password = '' then Error('Password can not be empty.');
        if not SalespersonPurchaser.Get(Salesperson) then
            Error('Invalid authentication details. Please enter correct details.');
        if SalespersonPurchaser.Password <> Password then
            Error('Invalid password! Please enter correct Password.');
        if SalespersonPurchaser."BC Map ID" <> UserSecurityId() then
            Error(Text0001Err);
    end;

    local procedure ChangeUserPassword()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        MinPasswordLength: Integer;
    begin
        MinPasswordLength := 6;

        if OldPassword = '' then Error('Current password cannot be empty.');
        if NewPassword = '' then Error('New password cannot be empty.');
        if ConfirmNewPassword = '' then Error('Please confirm your new password.');

        if not SalespersonPurchaser.Get(Salesperson) then
            Error('User not found. Please check the User ID.');

        if SalespersonPurchaser.Password <> OldPassword then
            Error('Current password is incorrect. Please try again.');

        if NewPassword = OldPassword then
            Error('New password must be different from the current password.');

        if StrLen(NewPassword) < MinPasswordLength then
            Error('New password must be at least %1 characters long.', MinPasswordLength);

        if NewPassword <> ConfirmNewPassword then
            Error('New password and confirmation do not match.');

        SalespersonPurchaser.Password := NewPassword;
        SalespersonPurchaser.Modify(true);

        ClearPasswordFields();
        UpdatePasswordToggle := false;
        CurrPage.Update(false);

        Message('Password updated successfully.');
    end;

    local procedure ClearPasswordFields()
    begin
        OldPassword := '';
        NewPassword := '';
        ConfirmNewPassword := '';
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::OK then begin
            if UpdatePasswordToggle then
                ChangeUserPassword();
            CheckUserNamePassword();
        end;
    end;
}