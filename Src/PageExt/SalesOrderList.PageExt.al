pageextension 50137 "4HC Sales Order List" extends "Sales Order List"
{
    trigger OnOpenPage()
    begin
        FilterSalesperson();
    end;

    local procedure FilterSalesperson()
    var
        UserDiv: Record UserDeviation;
        Salesperson: Record "Salesperson/Purchaser";
        SalePersonSupervisor: Record "Salesperson/Purchaser";
        Filter: Text;
        Text0001Err: Label 'Please complete the authentication process to proceed with your task.';
    begin
        Rec.FilterGroup(19);
        if UserDiv.Get(SessionId()) then begin
            if Salesperson.Get(UserDiv.Salesperson) then begin
                if Salesperson.UserLevel = Salesperson.UserLevel::User then
                    Rec.SetRange("Salesperson Code", Salesperson.Code)
                else
                    if Salesperson.UserLevel = Salesperson.UserLevel::Supervisor then begin
                        Filter := Salesperson.Code;
                        SalePersonSupervisor.SetRange(Supervisor, Salesperson.Code);
                        if SalePersonSupervisor.FindSet() then
                            repeat
                                if Filter <> '' then
                                    Filter := Filter + '|' + SalePersonSupervisor.Code;
                            until SalePersonSupervisor.Next() = 0;
                        Rec.SetFilter("Salesperson Code", Filter);
                    end;
            end;
            if Salesperson."Global Dimension 1 Code" <> '' then
                if (Salesperson.UserLevel = Salesperson.UserLevel::SeniorManager) or (Salesperson.UserLevel = Salesperson.UserLevel::Coordinator) then
                    Rec.SetRange("Shortcut Dimension 1 Code", Salesperson."Global Dimension 1 Code");
        end
        else
            Error(Text0001Err);
        Rec.FilterGroup(0);
    end;
}