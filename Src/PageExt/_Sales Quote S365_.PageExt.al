/* pageextension 50102 "Sales Quote S365" extends "Sales Quote"
{
    layout
    {
        addafter(General)
        {
            group("New Fields S365")
            {
                ShowCaption = true;
                Caption = 'Additional Quote Details';

                field("Origin S365"; Rec."Origin S365")
                {
                    Caption = 'Origin';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Origin field.';
                    Visible = false;
                }
                field("Destination S365"; Rec."Destination S365")
                {
                    Caption = 'Destination';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Destination field.';
                    Visible = false;
                }
                field("Place of Receipt S365"; Rec."Place of Receipt S365")
                {
                    Caption = 'Place of Receipt';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Receipt field.';
                    Visible = false;
                }
                field("Place of Delivery S365"; Rec."Place of Delivery S365")
                {
                    Caption = 'Place of Delivery';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Place of Delivery field.';
                    Visible = false;
                }
                field("Change Reason S365"; Rec."Change Reason S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Change Reason field.';
                }
                field("Original Quote No. S365"; Rec."Original Quote No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Original Quote No. field.';
                }
                field(ConfirmedS365; Rec.ConfirmedS365)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value for confirmed qoutes';
                }
                field("Quote Status S365"; Rec."Quote Status S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quote Status field.';
                }
                field("ETD S365"; Rec."ETD S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETD field.';
                    Visible = false;
                }
                field("ETA S365"; Rec."ETA S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETA field.';
                    Visible = false;
                }
                field("Shipment Method Code S365"; Rec."Shipment Method Code")
                {
                    Caption = 'Incoterms';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incoterms field.';
                    Visible = false;
                }
                field("MAWB No. S365"; Rec."MAWB No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MAWB No. field.';
                    Visible = false;
                }
                field("MAWB Date S365"; Rec."MAWB Date S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the MAWB Date field.';
                    Visible = false;
                }
                field("Cross Trade S365"; Rec."Cross Trade S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Cross Trade field.';
                    Visible = false;
                }
                field("Container No. S365"; Rec."Container No. S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container No. field.';
                    Visible = false;
                }
                field("Remarks S365"; Rec."Remarks S365")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(CompanyBankAccountCode; Rec.CompanyBankAccountCode)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        Rec.Validate("Company Bank Account Code", Rec.CompanyBankAccountCode);
                    end;
                }
            }
        }
        movelast(General; "Shortcut Dimension 1 Code")
        moveafter("Remarks S365"; "Currency Code")
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Sell-to Customer Templ. Code")
        {
            Visible = false;
        }
        modify("Opportunity No.")
        {
            Visible = false;
        }
        modify("Invoice Details")
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            trigger OnAfterValidate()
            var
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                if Rec."Currency Code" = 'USD' then
                    Rec."Exchange Rate" := CurrExchRate.ExchangeRate(Today, Rec."Currency Code");
                Rec.Modify();
            end;
        }
        addafter("Currency Code")
        {
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
            }
            field("Exchange Rate"; Rec."Exchange Rate")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Exchange Rate field.';
            }
        }
    }
    actions
    {
        addafter("Archive Document")
        {
            action("Amend Quote & Archive S365")
            {
                Caption = 'Amend Quote & Archive';
                ToolTip = 'Copy document lines and header information from another sales document to this document and send the document to the archive';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SQmodFunction.SalesQuoteAmendArchive(Rec);
                end;
            }
            action(ConfirmS365)
            {
                Caption = 'Confirm Qoute';
                ToolTip = 'Confirm this qoute and prepare for make order';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Confirm;

                trigger OnAction()
                begin
                    SQmodFunction.ConfirmQoute(Rec);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        //FilterSalesperson;
    end;

    local procedure FilterSalesperson()
    var
        UserDiv: Record UserDeviation;
        Salesperson: Record "Salesperson/Purchaser";
    begin
        if not UserDiv.Get(SessionId()) then exit;
        if Salesperson.Get(UserDiv.Salesperson) then if Salesperson.UserLevel = Salesperson.UserLevel::User then Rec.SetRange("Salesperson Code", UserDiv.Salesperson);
        if Salesperson."Global Dimension 1 Code" <> '' then if (Salesperson.UserLevel = Salesperson.UserLevel::SeniorManager) or (Salesperson.UserLevel = Salesperson.UserLevel::Supervisor) then Rec.SetRange("Shortcut Dimension 1 Code", Salesperson."Global Dimension 1 Code");
    end;

    var
        SQmodFunction: Codeunit "SQmodFunction S365";
}
 */