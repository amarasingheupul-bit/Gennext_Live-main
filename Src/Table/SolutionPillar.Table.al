table 50106 SolutionPillar
{
    Caption = 'Solution Pillar';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Solution; Code[20])
        {
            Caption = 'Solution';
        }
        field(2; SalespersonCode; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                SalesPerson: Record "Salesperson/Purchaser";
            begin
                if SalesPerson.Get(SalespersonCode)then SalespersonName:=SalesPerson.Name;
            end;
        }
        field(3; SalespersonName; Text[50])
        {
            Caption = 'Salesperson Name';
            Editable = false;
        }
    }
    keys
    {
        key(PK; Solution, SalespersonCode)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Solution, SalespersonCode, SalespersonName)
        {
        }
    }
}
