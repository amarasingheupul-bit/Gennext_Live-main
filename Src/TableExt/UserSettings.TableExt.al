tableextension 50136 "4HC User Settings" extends "User Settings"
{
    trigger OnBeforeModify()
    var
        UserDeviation: Record UserDeviation;
        SalesPerson: Record "Salesperson/Purchaser";
    begin
        if Rec.Company <> xRec.Company then
            if UserDeviation.Get(SessionId()) then
                if SalesPerson.Get(UserDeviation.Salesperson) then
                    Rec."Profile ID" := SalesPerson."SP Profile";
    end;
}