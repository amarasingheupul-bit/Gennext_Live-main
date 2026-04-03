page 50124 "Confirm Void"
{
    Caption = 'Confirm Fin Void';
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field(Control19; '')
            {
                ApplicationArea = Basic, Suite;
                CaptionClass = Format(Text002);
                Editable = false;
                ShowCaption = false;
            }
            field(VoidRemarks; VoidRemarks)
            {
                Caption = 'Void Remarks';
                MultiLine = true;
                ApplicationArea = All;
            }
            group(Details)
            {
                Caption = 'Details';
                field("CheckLedgerEntry.""Bank Account No."""; CheckLedgerEntry."Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Account No.';
                    Editable = false;
                    ToolTip = 'Specifies the bank account.';
                }
                field("CheckLedgerEntry.""Check No."""; CheckLedgerEntry."Check No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Check No.';
                    Editable = false;
                    ToolTip = 'Specifies the check number to be voided.';
                }
                field("CheckLedgerEntry.""Bal. Account No."""; CheckLedgerEntry."Bal. Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = Format(StrSubstNo(Text001, CheckLedgerEntry."Bal. Account Type"));
                    Editable = false;
                }
                field("CheckLedgerEntry.Amount"; CheckLedgerEntry.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Amount';
                    Editable = false;
                    ToolTip = 'Specifies the amount to be voided.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    var
        CheckLedgerEntry: Record "Check Ledger Entry";
        Text000: Label 'Void Date must not be before the original %1.';
        Text001: Label '%1 No.';
        Text002: Label 'Do you want to void this check?';
        VoidRemarks: Text[100];

    [Scope('Personalization')]
    procedure SetCheckLedgerEntry(var NewCheckLedgerEntry: Record "Check Ledger Entry")
    begin
        CheckLedgerEntry := NewCheckLedgerEntry;
    end;

    [Scope('Personalization')]
    procedure GetVoidRemarks(): Text
    begin
        exit(VoidRemarks);
    end;
}

