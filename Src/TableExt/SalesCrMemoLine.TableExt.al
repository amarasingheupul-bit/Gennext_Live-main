tableextension 50137 "4HC Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50100; "Applies-to Doc. No. 4HC"; Code[20])
        {
            Caption = 'Applies-to Doc. No. ';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."Applies-to Doc. No." where("No." = field("Document No.")));
        }
        field(50121; "GL Dim Updated"; Boolean)
        {
            Caption = 'GL Dim Updated';
            DataClassification = ToBeClassified;
        }
    }
}
