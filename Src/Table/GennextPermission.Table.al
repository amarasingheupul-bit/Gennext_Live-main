table 50113 "4HC Gennext Permission"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(7; "Table Caption"; Text[250])
        {
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table),
                                                                           "Object ID" = field("Table ID")));
            Caption = 'Table Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2; "User ID"; Code[20])
        {
            Caption = 'User ID';
            TableRelation = "Salesperson/Purchaser";
        }
        field(3; Read; Boolean)
        {
            Caption = 'Read';
        }
        field(4; Modify; Boolean)
        {
            Caption = 'Modify';
        }
        field(5; Insert; Boolean)
        {
            Caption = 'Read';
        }
        field(6; Delete; Boolean)
        {
            Caption = 'Delete';
        }
    }

    keys
    {
        key(PK; "User ID", "Table ID")
        {
            Clustered = true;
        }
    }
}