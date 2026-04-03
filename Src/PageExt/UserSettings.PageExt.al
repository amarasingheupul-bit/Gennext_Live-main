pageextension 50147 "4HC User Settings" extends "User Settings"
{
    trigger OnOpenPage()
    begin
        CurrPage.Update();
    end;
}