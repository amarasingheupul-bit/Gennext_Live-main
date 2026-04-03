tableextension 50115 GenJournalLineExt extends "Gen. Journal Line"
{
    fields
    {
        field(50100; Narration; Text[250])
        {
            Caption = 'Narration';
        }
        field(50101; PayeeName; Text[80])
        {
            Caption = 'Payee Name';
        }
        field(50102; VoidRemarks; Text[100])
        {
            Caption = 'Void Remarks';
        }
        field(50003; "Pre Assigned No."; Code[20])
        {
            Caption = 'Pre Assigned No.';
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                Vendor: Record Vendor;
            begin
                if "Account Type" = "Account Type"::Vendor then begin
                    Vendor.Reset();
                    if Vendor.Get("Account No.") then
                        PayeeName := Vendor.Payee;
                end;
            end;
        }
    }
}
