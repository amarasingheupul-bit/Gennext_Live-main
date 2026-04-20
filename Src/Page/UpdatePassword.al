page 50141 UpdatePassword
{
    ApplicationArea = All;
    Caption = 'Gennext Update Password';
    PageType = List;

    layout
    {
        area(Content)
        {
            field(Salesperson; Salesperson)
            {
                ApplicationArea = All;
                Caption = 'User';
                Editable = false;
            }
            field(CurrentPassword; CurrentPassword)
            {
                ApplicationArea = All;
                Caption = 'Current Password';
                ExtendedDatatype = Masked;
            }
            field(NewPassword; NewPassword)
            {
                ApplicationArea = All;
                Caption = 'New Password';
                ExtendedDatatype = Masked;
            }
            field(ConfirmPassword; ConfirmPassword)
            {
                ApplicationArea = All;
                Caption = 'Confirm New Password';
                ExtendedDatatype = Masked;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(UpdatePassword)
            {
                ApplicationArea = All;
                Caption = 'Update Password';
                Image = Action;

                trigger OnAction()
                begin
                    ValidateAndUpdatePassword();
                end;
            }
        }
    }

    var
        CurrentPassword: Text[100];
        NewPassword: Text[100];
        ConfirmPassword: Text[100];
        Salesperson: Code[20];

    procedure SetSalesPerson(SalespersonCode: Code[20])
    begin
        Salesperson := SalespersonCode;
    end;

    local procedure ValidateAndUpdatePassword()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        MinPasswordLengthErr: Label 'New password must be at least 8 characters.';
        EmptyFieldErr: Label 'All fields are required.';
        WrongCurrentPasswordErr: Label 'Current password is incorrect.';
        PasswordMismatchErr: Label 'New password and confirmation do not match.';
        SamePasswordErr: Label 'New password must be different from the current password.';
    begin
        if (CurrentPassword = '') or (NewPassword = '') or (ConfirmPassword = '') then
            Error(EmptyFieldErr);

        if StrLen(NewPassword) < 8 then
            Error(MinPasswordLengthErr);

        if NewPassword <> ConfirmPassword then
            Error(PasswordMismatchErr);

        if NewPassword = CurrentPassword then
            Error(SamePasswordErr);

        if not SalespersonPurchaser.Get(Salesperson) then
            Error('User not found.');

        if SalespersonPurchaser.Password <> CurrentPassword then
            Error(WrongCurrentPasswordErr);

        SalespersonPurchaser.Password := NewPassword;
        SalespersonPurchaser.Modify(true);

        Message('Password updated successfully.');
        CurrPage.Close();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        exit(true);
    end;
}