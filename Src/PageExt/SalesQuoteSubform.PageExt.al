pageextension 50122 "4HC Sales Quote Subform" extends "Sales Quote Subform"
{
    layout
    {
        addafter(Description)
        {
            field("HS Code S365"; Rec."HS Code S365")
            {
                ApplicationArea = All;
                Caption = 'Item Group';
                ToolTip = 'Provide the Harmonized System (HS) code for classifying goods in the shipment.';
            }
            field("Quote Type S365"; Rec.QuoteType)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quote Type field.';
            }
            field(IncoTerms; Rec.IncoTerms)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inco Terms field.';
                TableRelation = IncoTerm.Code;
            }
            field(UnitCostHistorical; Rec.UnitCostHistorical)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the historical unit cost for the item.';
            }
            field(AvailableQty; Rec.AvailableQty)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the available quantity for the item.';
            }
        }
        addafter("Unit of Measure Code")
        {
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Cost field.';
                Editable = true;
                trigger OnValidate()
                begin
                    this.CalculateTotalMargin();
                    Rec.Validate("Margin %");
                end;
            }
        }
        addafter("Unit Cost")
        {
            field("Margine %"; Rec."Margin %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the "Margine % field.';
            }
        }
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                this.CalculateTotalMargin();
            end;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Line Discount %")
        {
            Visible = false;
        }
        modify("Inv. Discount Amount")
        {
            Visible = false;
        }
        modify("Invoice Disc. Pct.")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = true;
        }
        moveafter(Quantity; "Tax Area Code")
        moveafter(AvailableQty; "Unit of Measure Code")
        moveafter("Margine %"; "Unit Price")
        moveafter("Unit Price"; Quantity)
        movelast(Control1; "No.")
        addlast(Control49)
        {
            field(MarkupPerc; MarkupPerc)
            {
                ApplicationArea = All;
                ToolTip = 'Specify the Markup % for the sales quote item.';
                Caption = 'Margin %';

                trigger OnValidate()
                var
                    SalesLine: Record "Sales Line";
                begin
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("Document No.", Rec."Document No.");
                    if SalesLine.FindSet() then begin
                        repeat
                            if (SalesLine.Type = SalesLine.Type::Item) or (SalesLine.Type = SalesLine.Type::"G/L Account") or (SalesLine.Type = SalesLine.Type::"Charge (Item)") then begin
                                SalesLine.Validate("Margin %", MarkupPerc);
                                SalesLine.Modify();
                            end;
                        until SalesLine.Next() = 0;
                        CurrPage.Update(false);
                    end;
                    this.CalculateTotalMargin();
                end;
            }
        }
        addfirst(Control35)
        {
            field(TotalCost; TotalCost)
            {
                Caption = 'Total Cost';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the total cost for the sales quote line.';
            }
            field(MarginAmont; MarginAmont)
            {
                Caption = 'Margin Amount';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the margin amount for the sales quote line.';
            }
            // field("Margin %"; MarginPrecentage)
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            // }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("Add Charge ItemsS365")
            {
                Caption = 'Add Charge Items';
                ApplicationArea = All;
                ToolTip = 'Add Charge items for selected service item';
                Image = AuthorizeCreditCard;

                trigger OnAction()
                var
                    Saleline: Record "Sales Line";
                    SQmodFunction: Codeunit "SQmodFunction S365";
                begin
                    CurrPage.SetSelectionFilter(Saleline);
                    if Saleline.find('-') then
                        SQmodFunction.AddChargeItem(Saleline);
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        this.CalculateTotalMargin();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        this.CalculateTotalMargin();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        this.CalculateTotalMargin();
        this.CheckChargerItemBeforeDelete();
    end;

    var
        MarkupPerc: Decimal;
        // Markup: Decimal;
        MarginPrecentage: Decimal;
        TotalCost: Decimal;
        TotalPrice: Decimal;
        MarginAmont: Decimal;

    procedure CalculateTotalMargin()
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
    begin
        MarginPrecentage := 0;
        TotalCost := 0;
        TotalPrice := 0;
        MarginAmont := 0;
        SalesLine.Reset();
        SalesLine.CopyFilters(Rec);
        if SalesLine.FindSet() then
            repeat
                TotalCost += SalesLine."Unit Cost" * SalesLine.Quantity;
                TotalPrice += SalesLine."Unit Price" * SalesLine.Quantity;
            until SalesLine.Next() = 0;

        MarginAmont := TotalPrice - TotalCost;

        if TotalPrice <> 0 then
            MarginPrecentage := (MarginAmont / TotalPrice) * 100
        else
            MarginPrecentage := 0;

        if SalesHeader.Get(SalesHeader."Document Type"::Quote, Rec."Document No.") then begin
            SalesHeader."Margin %" := MarginPrecentage;
            SalesHeader.Modify();
        end;
    end;

    local procedure CheckChargerItemBeforeDelete()
    begin
        if Rec."Is Charger Item" then
            Error('Cannot delete a Charger Item.');
        if Rec."Charger Item Created" then
            Error('Cannot delete a record that has created a Charger Item.');
    end;
}