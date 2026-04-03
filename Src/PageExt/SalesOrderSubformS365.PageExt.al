pageextension 50110 SalesOrderSubformS365 extends "Sales Order Subform"
{
    layout
    {
        addafter("Unit of Measure")
        {
            field("Unit Cost"; Rec."Unit Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Cost field.';
                Editable = true;
                trigger OnValidate()
                begin
                    CalculateTotalMargin();
                end;
            }
            field("Margine %"; Rec."Margin %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the "Margine % field.';
            }
        }
        modify("Net Weight")
        {
            Visible = false;
        }
        modify("Qty. to Assemble to Order")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Unit Cost (LCY)")
        {
            Visible = true;
            trigger OnAfterValidate()
            begin
                CalculateTotalMargin();
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CalculateTotalMargin();
            end;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                CalculateTotalMargin();
            end;
        }
        moveafter("Margine %"; "Unit Price")
        moveafter("Unit Price"; Quantity)
        movelast(Control1; "No.")
        moveafter(Control1; "Unit Cost (LCY)")
        addlast(Control45)
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
                    CalculateTotalMargin();
                end;
            }
        }
        addfirst(Control28)
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
    end;

    var
        MarkupPerc: Decimal;
        MarginPrecentage: Decimal;
        TotalCost: Decimal;
        TotalPrice: Decimal;
        MarginAmont: Decimal;

    procedure CalculateTotalCostAndPrice()
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.CopyFilters(Rec);
        TotalCost := 0;
        TotalPrice := 0;
        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", Rec."Document No.");
        if SalesLine.FindSet() then
            repeat
                TotalCost += SalesLine."Unit Cost" * SalesLine.Quantity;
                TotalPrice += SalesLine."Unit Price" * SalesLine.Quantity;
            until SalesLine.Next() = 0;
    end;

    procedure CalculateTotalMargin()
    var
        SalesHeader: Record "Sales Header";
    begin
        MarginPrecentage := 0;
        MarginAmont := 0;
        CalculateTotalCostAndPrice();

        MarginAmont := TotalPrice - TotalCost;

        if TotalPrice <> 0 then
            MarginPrecentage := (MarginAmont / TotalPrice) * 100
        else
            MarginPrecentage := 0;

        if SalesHeader.Get(SalesHeader."Document Type"::Order, Rec."Document No.") then begin
            SalesHeader."Margin %" := MarginPrecentage;
            SalesHeader.Modify();
        end;
    end;
}
