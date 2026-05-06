pageextension 50114 OpportunityCardExt extends "Opportunity Card"
{
    layout
    {
        addlast(General)
        {
            field("Estimated GP"; Rec."Estimated GP")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Estimated GP field.';
                Importance = Promoted;
            }
            field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field(solutionPillar; Rec.solutionPillar)
            {
                ApplicationArea = All;
                Editable = SolutionPillarEdit;
            }
            field("100% Payment Received"; Rec."100% Payment Received")
            {
                ApplicationArea = All;
                Editable = PaymentReceivedEdit;
            }
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
    }

    trigger OnOpenPage()
    begin
        // Use your existing procedure to get the logged-in salesperson
        PaymentReceivedEdit := (GetSalespersonFromUser() = 'SIVAKUMAR.P');
    end;

    trigger OnAfterGetRecord()
    var
        SalesCycle: Record "Sales Cycle";
    begin
        if SalesCycle.Get(Rec."Sales Cycle Code") then
            SolutionPillarEdit := SalesCycle.SolutionPillarEditable
        else
            SolutionPillarEdit := false;
    end;

    local procedure GetSalespersonFromUser(): Code[20]
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        UserDiv: Record UserDeviation;
        CurrentSessionId: Integer;
    begin
        CurrentSessionId := SessionId();

        UserDiv.SetRange(SessionId, CurrentSessionId);
        UserDiv.SetRange(UserID, UserId());
        if UserDiv.FindFirst() then begin
            if SalespersonPurchaser.Get(UserDiv.Salesperson) then
                exit(UserDiv.Salesperson);
        end;
        exit('');
    end;

    var
        SolutionPillarEdit: Boolean;
        PaymentReceivedEdit: Boolean;
}