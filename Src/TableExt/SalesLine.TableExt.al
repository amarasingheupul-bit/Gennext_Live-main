tableextension 50102 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50100; "Printed or Email S365"; Boolean)
        {
            Caption = 'Printed or Email';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."Printed or Email S365" where("No." = field("Document No."), "Document Type" = field("Document Type")));
        }
        field(50102; "Package Type S365"; Code[10])
        {
            Caption = 'Package Type';
            DataClassification = CustomerContent;
            TableRelation = PackageTypeS365.Code;
        }
        field(50103; "WidthS365"; Decimal)
        {
            Caption = 'Width(CM)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //this.CalcNetWeight();
                this.CalculateVolume();
                this.CalculateVolumeWeight();
                this.CalculateTotalWeight();
            end;
        }
        field(50104; "HeightS365"; Decimal)
        {
            Caption = 'Height(CM)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //this.CalcNetWeight();
                this.CalculateVolume();
                this.CalculateVolumeWeight();
                this.CalculateTotalWeight();
            end;
        }
        field(50105; "LengthS365"; Decimal)
        {
            Caption = 'Length(CM)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //this.CalcNetWeight();
                this.CalculateVolume();
                this.CalculateVolumeWeight();
                this.CalculateTotalWeight();
            end;
        }
        field(50106; "No. of Packages S365"; Decimal)
        {
            Caption = 'No. of Packages';
            DataClassification = CustomerContent;
        }
        field(50107; "No. of Pallets S365"; Decimal)
        {
            Caption = 'No. of Pallets';
            DataClassification = CustomerContent;
        }
        field(50108; "Volume S365"; Decimal)
        {
            Caption = 'Volume';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50109; "Volume Weight S365"; Decimal)
        {
            Caption = 'Volume Weight';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(50110; "Total Weight S365"; Decimal)
        {
            Caption = 'Total Weight';
            DataClassification = CustomerContent;
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(50111; "HS Code S365"; Code[20])
        {
            Caption = 'HS Code';
            DataClassification = CustomerContent;
            TableRelation = "Tariff Number";
        }
        modify("Net Weight")
        {
            trigger OnAfterValidate()
            begin
                this.CalculateTotalWeight();
            end;
        }
        field(50112; "Commodity"; Option)
        {
            Caption = 'Commodity';
            OptionMembers = GEN;
            DataClassification = CustomerContent;
        }
        field(50113; QuoteType; Code[10])
        {
            Caption = 'Quote Type';
            DataClassification = CustomerContent;
            TableRelation = "Quote Type S365"."Code S365";
        }
        field(50114; IncoTerms; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Inco Terms';
            TableRelation = IncoTerm.Code;
        }
        field(50115; UnitCostHistorical; Decimal)
        {
            Caption = 'Unit Cost - Historical';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50116; AvailableQty; Decimal)
        {
            Caption = 'Available Qty';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50101; "Margin %"; Decimal)
        {
            Caption = 'Margin %';
            trigger OnValidate()
            begin
                Validate("Unit Price", "Unit Cost" / (1 - ("Margin %" / 100)));
            end;
        }
        field(50117; "Margine %"; Decimal)
        {
            Caption = 'Margin %';
            ObsoleteState = Removed;
            ObsoleteReason = 'Name Wrong';
            ObsoleteTag = '20250721';
        }
        field(50118; "Is Charger Item"; Boolean)
        {
            Caption = 'Is Charger Item';
        }
        field(50119; "Charger Item Created"; Boolean)
        {
            Caption = 'Charger Item Created';
        }
        field(50120; "Base Item No."; Code[20])
        {
            Caption = 'Base Item No.';
        }
        field(50121; "GL Dim Updated"; Boolean)
        {
            Caption = 'GL Dim Updated';
        }
    }
    trigger OnBeforeModify()
    var
        Text000Err: Label 'Modification is restricted. This document was printed or sent by email.';
    begin
        Rec.CalcFields("Printed or Email S365");
        if (Rec."Document Type" = Rec."Document Type"::Quote) and Rec."Printed or Email S365" then Error(Text000Err);
    end;

    local procedure CalcNetWeight()
    begin
        "Net Weight" := WidthS365 * HeightS365 * LengthS365;
        rec.Modify();
    end;

    procedure CalculateVolume()
    begin
        "Volume S365" := HeightS365 * LengthS365 * WidthS365;
    end;

    procedure CalculateVolumeWeight()
    begin
        "Volume Weight S365" := "Volume S365" / 6000;
    end;

    procedure CalculateTotalWeight()
    begin
        "Total Weight S365" := "Net Weight" + "Volume Weight S365";
    end;
}
