tableextension 50103 "ItemChargeS365" extends "Item Charge"
{
    fields
    {
        field(50100; "QuoteType S365"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Quote Type';
            TableRelation = "Quote Type S365"."Code S365";
        }
        field(50101; "Charge UOM S365"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Charge UOM';
            TableRelation = "Unit of Measure".Code;
        }
        field(50102; "Charge Amount S365"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Charge Amount';

            trigger OnValidate()
            begin
                if Rec."Charge Percentage" > 0 then Error('Charge Percentage must be 0 when Charge Amount to set.');
            end;
        }
        field(50103; "Minimum Charge S365"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Minimum Charge';

            trigger OnValidate()
            begin
                if Rec."Charge Percentage" > 0 then Error('Charge Percentage must be 0 when Minimum Charge Amount to set.');
            end;
        }
        field(50104; IncoTerms; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Inco Terms';
            TableRelation = IncoTerm.Code;
        }
        field(50105; "Charge Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Charge Percentage';

            trigger OnValidate()
            begin
                if Rec."Charge Amount S365" > 0 then Error('Charge Amount must be 0 when Charge Percentage to set.');
            end;
        }
        field(50106; HSCode; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'HS Code';
            TableRelation = "Tariff Number";
        }
    }
    keys
    {
    // Add changes to keys here
    }
    fieldgroups
    {
    // Add changes to field groups here
    }
}
