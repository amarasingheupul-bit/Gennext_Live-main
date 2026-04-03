
table 50114 "4HC Product Brand Buffer"
{
    //TableType = Temporary;

    fields
    {
        field(1; "Product Code"; Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Product Name"; Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(3; "Brand Code"; Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(4; "Brand Name"; Text[100])
        {
            DataClassification = SystemMetadata;
        }
        field(5; "Revenue"; Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(8; "Cost"; Decimal)
        {
            DataClassification = SystemMetadata;
        }
        field(10; "Gross Profit Margin"; Decimal)
        {
            DataClassification = SystemMetadata;
            AutoFormatType = 1;
        }
    }

    keys
    {
        key(PK; "Product Code", "Brand Code")
        {
            Clustered = true;
        }
    }
}