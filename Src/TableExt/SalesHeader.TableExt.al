tableextension 50100 "4HC Sales Header" extends "Sales Header"
{
    fields
    {
        field(50100; "Origin S365"; Text[50])
        {
            Caption = 'Origin';
            DataClassification = CustomerContent;
            TableRelation = "Ports Code S365".Descritption where(Type = const("Ports Code Types S365"::Origin));
            ValidateTableRelation = false;
        }
        field(50101; "Destination S365"; Text[50])
        {
            Caption = 'Destination';
            DataClassification = CustomerContent;
            TableRelation = "Ports Code S365".Descritption where(Type = const("Ports Code Types S365"::Destination));
            ValidateTableRelation = false;
        }
        field(50103; "Change Reason S365"; Code[10])
        {
            Caption = 'Change Reason';
            DataClassification = CustomerContent;
            TableRelation = "Reason Code".Code;
        }
        field(50104; "Printed or Email S365"; Boolean)
        {
            Caption = 'Printed or Email';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50105; "Original Quote No. S365"; Code[20])
        {
            Caption = 'Original Quote No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50106; "Amend & Archived S365"; Boolean)
        {
            Caption = 'Amend & Archived';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50107; "ConfirmedS365"; Boolean)
        {
            Caption = 'Confirmed';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50108; "Job TemplateS365"; Code[20])
        {
            Caption = 'Job No. Template';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50109; "Quote Status S365"; Enum "Qoute Status S365")
        {
            DataClassification = CustomerContent;
            Caption = 'Quote Status';
        }
        field(50110; "ETD S365"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'ETD';
        }
        field(50111; "ETA S365"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'ETA';
        }
        field(50112; "MAWB No. S365"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'MAWB No.';
        }
        field(50113; "MAWB Date S365"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'MAWB Date';
        }
        field(50114; "Cross Trade S365"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Cross Trade';
        }
        field(50115; "Container No. S365"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Container No.';
        }
        field(50116; "Remarks S365"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Remarks';
        }
        field(50117; "Job No. S365"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Job No';
            Editable = false;
        }
        field(50118; "Place of Receipt S365"; Text[50])
        {
            Caption = 'Place of Receipt';
            DataClassification = CustomerContent;
            TableRelation = "Ports Code S365".Descritption where(Type = const("Ports Code Types S365"::Origin));
            ValidateTableRelation = false;
        }
        field(50119; "Place of Delivery S365"; Text[50])
        {
            Caption = 'Place of Delivery';
            DataClassification = CustomerContent;
            TableRelation = "Ports Code S365".Descritption where(Type = const("Ports Code Types S365"::Destination));
            ValidateTableRelation = false;
        }
        field(50120; "Carrier"; Text[50])
        {
            Caption = 'Carrier';
            DataClassification = CustomerContent;
        }
        field(50121; "Delivery Instructions"; Text[100])
        {
            Caption = 'Delivery Instructions';
            DataClassification = CustomerContent;
        }
        // Feb. 13 2025
        field(50122; "Sales Derector/ Area Director"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension".Code where(Blocked = const(false));
        }
        field(50123; "Sales Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50124; "Sales Contract Desc"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50125; "Yard No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50126; "Milestones Dates and Amounts"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Milestones with Dates and Amounts';
        }
        field(50127; "End User/ Main Customer"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50128; "Group Customer with One Stream"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Group Customer with One Stream Code';
            TableRelation = Customer;
        }
        field(50129; "Supplier to Services"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50130; "Sales Area"; Code[20])
        {
            DataClassification = ToBeClassified;
            // CaptionClass = '1,2,3';
            // Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension".Code where(Blocked = const(false));
        }
        field(50131; CompanyBankAccountCode; Code[20])
        {
            Caption = 'Company Bank Account Code';
            TableRelation = "Bank Account" where("Currency Code" = field("Currency Code"), ShowInSalesDocument = const(true));
            trigger OnValidate()
            begin
                Rec.Validate("Company Bank Account Code", Rec.CompanyBankAccountCode);
            end;
        }
        field(50132; PIAdvancePercentage; Decimal)
        {
            Caption = 'PI Advance Percentage';
        }
        field(50133; PIAdvance; Decimal)
        {
            Caption = 'PI Advance';
        }
        field(50102; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
        }
        field(50134; "Margine %"; Decimal)
        {
            Caption = 'Margine %';
            ObsoleteState = Pending;
            ObsoleteReason = 'Name Wrong';
            ObsoleteTag = '20250721';
        }
        field(50138; "Margin %"; Decimal)
        {
            Caption = 'Margin %';
        }
        field(50135; "Approval Status"; Enum "4HC Header Status")
        {
            Caption = 'Approval Status';
        }
        field(50136; "Approval Sender"; Code[20])
        {
            Caption = 'Approval Sender';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50137; "Approver ID"; Code[20])
        {
            Caption = 'Approver ID';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50139; "Purchase Order No. 4HC"; Code[20])
        {
            Caption = 'Purchase Order No.';
            TableRelation = "Purchase Header"."No.";
        }
        field(50140; "Reject Reason"; Text[250])
        {
            Caption = 'Reject Reason';
        }
        field(50141; "Approval Base Type"; Enum "Approval Base Type")
        {
            Caption = 'Approval Base Type';
        }
        field(50142; "Gennext Create By User"; Code[20])
        {
            Caption = 'Create By';
        }
        field(50143; "Quote Type S365"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Quote Type';
            TableRelation = "Quote Type S365"."Code S365";
        }
        modify("Currency Code")
        {
            trigger OnBeforeValidate()
            begin
                if "Currency Code" = 'LKR' then
                    Error(CurrencyCodeErr);
            end;
        }
    }
    var
        CurrencyCodeErr: Label 'LKR is not allowed as a currency code for this document.';

    // trigger OnBeforeModify()
    // var
    //     Text000Err: Label 'Modification is restricted. This document was printed or sent by email.';
    // begin
    //     if (Rec."Document Type" = Rec."Document Type"::Quote) and Rec."Printed or Email S365" and (xRec."Printed or Email S365" = Rec."Printed or Email S365") then Error(Text000Err);
    // end;
}
