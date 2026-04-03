tableextension 50144 "4HC Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(50121; "GL Dim Updated"; Boolean)
        {
            Caption = 'GL Dim Updated';
            DataClassification = ToBeClassified;
        }
    }
}
