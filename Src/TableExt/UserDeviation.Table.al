table 50108 UserDeviation
{
    Caption = 'User Deviation';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; SessionId; Integer)
        {
            Caption = 'Session Id';
        }
        field(2; UserID; code[50])
        {
            Caption = 'User ID';
        }
        field(3; Salesperson; code[20])
        {
            Caption = 'salesperson';
            TableRelation = "Salesperson/Purchaser";
        }
        field(4; LoginDateTime; DateTime)
        {
            Caption = 'Login Date Time';
        }
    }
    keys
    {
        key(PK; SessionId)
        {
            Clustered = true;
        }
    }
}
