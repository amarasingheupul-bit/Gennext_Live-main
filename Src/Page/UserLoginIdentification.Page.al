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
        }
    }
    var
        Password: Text[100];
        Salesperson: code[20];

    procedure GetSalesPerson(): Code[20];
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
        if not SalespersonPurchaser.Get(Salesperson) then Error('Invalid authentication details.Please enter correct details');
        if SalespersonPurchaser.Password <> Password then Error('Invalid password!.Please enter correct Password.');

        if SalespersonPurchaser."BC Map ID" <> UserSecurityId() then
            Error(Text0001Err);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CheckUserNamePassword();
    end;
}
