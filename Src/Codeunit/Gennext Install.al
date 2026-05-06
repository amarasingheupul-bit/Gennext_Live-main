codeunit 50114 "Gennext Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        GennextJobSetup: Codeunit "Gennext Job Queue Setup";
        CompanyInformation: Record "Company Information";
    begin
        if not CompanyInformation.Get() then
            exit;

        // Only schedule for Gennext (Pvt) Ltd
        if CompanyInformation.Name = 'Gennext (Pvt) Ltd' then
            GennextJobSetup.ScheduleSalesTaxSetup();
    end;
}