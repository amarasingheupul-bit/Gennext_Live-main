report 50103 "Delete All Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Delete All Ledger Entries';
    UsageCategory = Administration;
    ProcessingOnly = true;
    Permissions = tabledata "G/L Entry" = rmd,
        tabledata "Cust. Ledger Entry" = rmd,
        tabledata "Vendor Ledger Entry" = rmd,
        tabledata "Bank Account Ledger Entry" = rmd,
        tabledata "Item Ledger Entry" = rmd,
        tabledata "Value Entry" = rmd,
        tabledata "VAT Entry" = rmd;

    trigger OnPreReport()
    begin
        DeleteAllLedgerEntries();
    end;

    trigger OnPostReport()
    begin
        if DeleteCount > 0 then Message('Completed! Deleted %1 Ledger Entries.', DeleteCount)
    end;

    procedure DeleteAllLedgerEntries()
    var
        GLEntry: Record "G/L Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        VATEntry: Record "VAT Entry";
        Window: Dialog;
    begin
        if not Confirm('WARNING: This will permanently delete ALL ledger entries in the system.This operation cannot be undone!.Are you absolutely sure you want to continue?') then exit;
        Window.Open('Deleting all ledger entries... #1##########');
        DeleteRecordEntries(GLEntry, DeleteCount, Window);
        DeleteRecordEntries(CustLedgerEntry, DeleteCount, Window);
        DeleteRecordEntries(VendLedgerEntry, DeleteCount, Window);
        DeleteRecordEntries(BankAccLedgerEntry, DeleteCount, Window);
        DeleteRecordEntries(ItemLedgerEntry, DeleteCount, Window);
        DeleteRecordEntries(ValueEntry, DeleteCount, Window);
        DeleteRecordEntries(VATEntry, DeleteCount, Window);
        Window.Close();
    end;

    local procedure DeleteRecordEntries(var Rec: RecordRef; var DeleteCount: Integer; var Window: Dialog)
    begin
        if Rec.FindSet(true) then
            repeat
                Rec.Delete(true);
                DeleteCount += 1;
                if DeleteCount mod 100 = 0 then Window.Update(1, StrSubstNo('Deleted %1 entries...', DeleteCount));
            until Rec.Next() = 0;
    end;

    local procedure DeleteRecordEntries(var GLEntry: Record "G/L Entry"; var DeleteCount: Integer; var Window: Dialog)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(GLEntry);
        DeleteRecordEntries(RecRef, DeleteCount, Window);
    end;

    local procedure DeleteRecordEntries(var CustLedgerEntry: Record "Cust. Ledger Entry"; var DeleteCount: Integer; var Window: Dialog)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(CustLedgerEntry);
        DeleteRecordEntries(RecRef, DeleteCount, Window);
    end;

    local procedure DeleteRecordEntries(var VendLedgerEntry: Record "Vendor Ledger Entry"; var DeleteCount: Integer; var Window: Dialog)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(VendLedgerEntry);
        DeleteRecordEntries(RecRef, DeleteCount, Window);
    end;

    local procedure DeleteRecordEntries(var BankAccLedgerEntry: Record "Bank Account Ledger Entry"; var DeleteCount: Integer; var Window: Dialog)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(BankAccLedgerEntry);
        DeleteRecordEntries(RecRef, DeleteCount, Window);
    end;

    local procedure DeleteRecordEntries(var ItemLedgerEntry: Record "Item Ledger Entry"; var DeleteCount: Integer; var Window: Dialog)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(ItemLedgerEntry);
        DeleteRecordEntries(RecRef, DeleteCount, Window);
    end;

    local procedure DeleteRecordEntries(var ValueEntry: Record "Value Entry"; var DeleteCount: Integer; var Window: Dialog)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(ValueEntry);
        DeleteRecordEntries(RecRef, DeleteCount, Window);
    end;

    local procedure DeleteRecordEntries(var VATEntry: Record "VAT Entry"; var DeleteCount: Integer; var Window: Dialog)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(VATEntry);
        DeleteRecordEntries(RecRef, DeleteCount, Window);
    end;

    var
        DeleteCount: Integer;
}
