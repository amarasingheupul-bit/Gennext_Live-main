pageextension 50136 CompanyInformationExt extends "Company Information"
{
    layout
    {
        addafter("VAT Registration No.")
        {
            field(SVATRegistrationNo; Rec.SVATRegistrationNo)
            {
                ApplicationArea = All;
            }
        }
    }
}
