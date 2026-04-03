report 50111 PaymentVoucher
{
    Caption = 'Payment Voucher';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Reports/Layouts/Payment Voucher.rdl';

    dataset
    {
        dataitem("Gen. Journal Line"; "Gen. Journal Line")
        {
            column(Description_GenJournalLine; "Gen. Journal Line".Description)
            {
            }
            column(Payee_Name; payeeName)
            {
            }
            column(Posting_Date; "Posting Date")
            {
            }
            column(Amount_GenJournalLine; amt)
            {
            }
            column(BankAccName; BankName)
            {
            }
            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(CompanyLogo; CompanyInformation.Picture)
            {
            }
            column(ExternalDocumentNo_GenJournalLine; "Gen. Journal Line"."External Document No.")
            {
            }
            column(DocumentNo_GenJournalLine; "Gen. Journal Line"."Document No.")
            {
            }
            column(MessagetoRecipient_GenJournalLine; "Gen. Journal Line"."Message to Recipient")
            {
            }
            column(CompanyAddress; CompanyInformation.Address + ' ' + CompanyInformation."Address 2")
            {
            }
            column(CompanyCity; CompanyInformation.City)
            {
            }
            column(CompanyPhone; CompanyInformation."Phone No.")
            {
            }
            column(CompanyEmail; CompanyInformation."E-Mail")
            {
            }
            column(Narration; Narration)
            {
            }
            column(Desc; DescAmtInWord)
            {
            }
            column(RecCount; VendLedgerEntry.Count)
            {
            }
            trigger OnAfterGetRecord();
            begin
                Amt := 0;
                clear(Amt2);
                IF Amount > 0 THEN Amt := Amount;
                //Amt2 += amt;
                GenJnl.SetRange("Journal Batch Name", "Journal Batch Name");
                GenJnl.SetRange("Journal Template Name", "Journal Template Name");
                GenJnl.SetRange("Document No.", "Document No.");
                if GenJnl.FindFirst() then
                    repeat
                        IF GenJnl.Amount > 0 THEN Amt2 += GenJnl.Amount;
                    until GenJnl.next() = 0;
                AmountInWord.FormatNoText(Desc, Amt2, "Currency Code");
                Cents := (Amt2 MOD 1) * 100;
                AmountInWord.FormatNoText(Desc, Amt2, "Gen. Journal Line"."Currency Code");
                AmtInWord := Desc[1] + ' ' + Desc[2];
                //MESSAGE(FORMAT(STRPOS(Desc[1],' AND')));
                IF Cents = 0 THEN
                    DescAmtInWord := (FORMAT(DELSTR(AmtInWord, STRLEN(AmtInWord) - 9, 11)) + ' No Cents')
                ELSE
                    DescAmtInWord := (FORMAT(DELSTR(AmtInWord, STRLEN(AmtInWord) - 11, 11)) + ' ' + FORMAT(Cents) + ' Cents');
                //if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then
                // IF BankAccount.GET("Gen. Journal Line"."Bal. Account No.") then;
                clear(BankName); //PV
                clear(BankAccount);
                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                    IF BankAccount.GET("Account No.") THEN BankName := BankAccount.Name;
                END
                ELSE IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
                    IF BankAccount.GET("Bal. Account No.") THEN BankName := BankAccount.Name;
                END;
                Clear(VendLedgerEntry);
                VendLedgerEntry.SetRange("Applies-to ID", "Document No.");
                if VendLedgerEntry.FindSet() then;
            end;
        }
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            column(DocumentNoApp; "Document No.")
            {
            }
            column(PostingDateApp; "Posting Date")
            {
            }
            column(DescriptionApp; Description)
            {
            }
            column(Amount_to_Apply; ABS("Amount to Apply"))
            {
            }
            trigger OnPreDataItem()
            begin
                SetRange("Applies-to ID", "Gen. Journal Line"."Document No.");
            end;
        }
    }
    requestpage
    {
        layout
        {
        }
    }
    trigger OnPreReport();
    begin
        CompanyInformation.GET();
        CompanyInformation.CalcFields(Picture);
        AmountInWord.InitTextVariable();
    end;

    var
        BankAccount: Record "Bank Account";
        CompanyInformation: Record "Company Information";
        GenJnl: Record "Gen. Journal Line";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        AmountInWord: Report Check;
        Amt: Decimal;
        Amt2: Decimal;
        Cents: Decimal;
        Desc: array[2] of Text[80];
        BankName: Text[100];
        AmtInWord: Text[160];
        DescAmtInWord: Text[160];
}
