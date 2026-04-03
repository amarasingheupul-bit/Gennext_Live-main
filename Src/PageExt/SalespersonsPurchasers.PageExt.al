pageextension 50142 "4HC Salespersons/Purchasers" extends "Salespersons/Purchasers"
{

    trigger OnOpenPage()
    var
        UserDiv: Record UserDeviation;
        Text0001Err: Label 'Please complete the authentication process to proceed with your task.';
    begin
        if not UserDiv.Get(SessionId()) then
            Error(Text0001Err);
    end;
}