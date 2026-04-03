codeunit 50104 "Get Applied Docs"
{
    trigger OnRun();
    begin
    end;

    procedure GetAppliedCustomerDocs(CreateCustLedgEntry: Record "Cust. Ledger Entry"; var TEMPCustLedgerEntry: Record "Cust. Ledger Entry"; AppliedAmtWithLCY: Boolean);
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        CustLedgerEntryRec: Record "Cust. Ledger Entry";
    begin
        CLEAR(TEMPCustLedgerEntry);
        DtldCustLedgEntry1.SETCURRENTKEY("Cust. Ledger Entry No.");
        DtldCustLedgEntry1.SETRANGE("Cust. Ledger Entry No.", CreateCustLedgEntry."Entry No.");
        DtldCustLedgEntry1.SETRANGE(Unapplied, FALSE);
        IF DtldCustLedgEntry1.FIND('-') THEN
            REPEAT
                IF DtldCustLedgEntry1."Cust. Ledger Entry No." = DtldCustLedgEntry1."Applied Cust. Ledger Entry No." THEN BEGIN
                    DtldCustLedgEntry2.INIT();
                    DtldCustLedgEntry2.SETCURRENTKEY("Applied Cust. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry2.SETRANGE("Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    DtldCustLedgEntry2.SETRANGE("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                    DtldCustLedgEntry2.SETRANGE(Unapplied, FALSE);
                    IF DtldCustLedgEntry2.FIND('-') THEN
                        REPEAT
                            IF DtldCustLedgEntry2."Cust. Ledger Entry No." <> DtldCustLedgEntry2."Applied Cust. Ledger Entry No." THEN BEGIN
                                CustLedgerEntryRec.SETCURRENTKEY("Entry No.");
                                CustLedgerEntryRec.SETRANGE("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                IF CustLedgerEntryRec.FIND('-') THEN BEGIN
                                    CustLedgerEntryRec.MARK(TRUE);
                                    IF NOT TEMPCustLedgerEntry.GET(CustLedgerEntryRec."Entry No.") THEN BEGIN
                                        TEMPCustLedgerEntry := CustLedgerEntryRec;
                                        IF AppliedAmtWithLCY THEN
                                            TEMPCustLedgerEntry."Amount to Apply" := ABS(DtldCustLedgEntry2."Amount (LCY)")
                                        ELSE
                                            TEMPCustLedgerEntry."Amount to Apply" := ABS(DtldCustLedgEntry2.Amount);
                                        TEMPCustLedgerEntry."Transaction No." := DtldCustLedgEntry2."Entry No.";
                                        TEMPCustLedgerEntry.INSERT();
                                        TEMPCustLedgerEntry.MARK(TRUE);
                                    END
                                    ELSE IF TEMPCustLedgerEntry."Transaction No." <> DtldCustLedgEntry2."Entry No." THEN BEGIN
                                        IF AppliedAmtWithLCY THEN
                                            TEMPCustLedgerEntry."Amount to Apply" += ABS(DtldCustLedgEntry2."Amount (LCY)")
                                        ELSE
                                            TEMPCustLedgerEntry."Amount to Apply" += ABS(DtldCustLedgEntry2.Amount);
                                        TEMPCustLedgerEntry.MODIFY();
                                        TEMPCustLedgerEntry.MARK(TRUE);
                                    END;
                                END;
                            END;
                        UNTIL DtldCustLedgEntry2.NEXT() = 0;
                END
                ELSE BEGIN
                    CustLedgerEntryRec.SETCURRENTKEY("Entry No.");
                    CustLedgerEntryRec.SETRANGE("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    IF CustLedgerEntryRec.FIND('-') THEN BEGIN
                        CustLedgerEntryRec.MARK(TRUE);
                        IF NOT TEMPCustLedgerEntry.GET(CustLedgerEntryRec."Entry No.") THEN BEGIN
                            TEMPCustLedgerEntry := CustLedgerEntryRec;
                            IF AppliedAmtWithLCY THEN
                                TEMPCustLedgerEntry."Amount to Apply" := ABS(DtldCustLedgEntry1."Amount (LCY)")
                            ELSE
                                TEMPCustLedgerEntry."Amount to Apply" := ABS(DtldCustLedgEntry1.Amount);
                            TEMPCustLedgerEntry."Transaction No." := DtldCustLedgEntry1."Entry No.";
                            TEMPCustLedgerEntry.INSERT();
                            TEMPCustLedgerEntry.MARK(TRUE);
                        END
                        ELSE IF TEMPCustLedgerEntry."Transaction No." <> DtldCustLedgEntry1."Entry No." THEN BEGIN
                            IF AppliedAmtWithLCY THEN
                                TEMPCustLedgerEntry."Amount to Apply" += ABS(DtldCustLedgEntry1."Amount (LCY)")
                            ELSE
                                TEMPCustLedgerEntry."Amount to Apply" += ABS(DtldCustLedgEntry1.Amount);
                            TEMPCustLedgerEntry.MODIFY();
                            TEMPCustLedgerEntry.MARK(TRUE);
                        END;
                    END;
                END;
            UNTIL DtldCustLedgEntry1.NEXT() = 0;
        CustLedgerEntryRec.SETCURRENTKEY("Entry No.");
        CustLedgerEntryRec.SETRANGE("Entry No.");
        IF CreateCustLedgEntry."Closed by Entry No." <> 0 THEN BEGIN
            CustLedgerEntryRec."Entry No." := CreateCustLedgEntry."Closed by Entry No.";
            CustLedgerEntryRec.MARK(TRUE);
            IF NOT TEMPCustLedgerEntry.GET(CustLedgerEntryRec."Entry No.") THEN BEGIN
                TEMPCustLedgerEntry := CustLedgerEntryRec;
                TEMPCustLedgerEntry.INSERT();
                TEMPCustLedgerEntry.MARK(TRUE);
            END
            ELSE
                TEMPCustLedgerEntry.MARK(TRUE);
        END;
        CustLedgerEntryRec.SETCURRENTKEY("Closed by Entry No.");
        CustLedgerEntryRec.SETRANGE("Closed by Entry No.", CreateCustLedgEntry."Entry No.");
        IF CustLedgerEntryRec.FIND('-') THEN
            REPEAT
                CustLedgerEntryRec.MARK(TRUE);
                IF NOT TEMPCustLedgerEntry.GET(CustLedgerEntryRec."Entry No.") THEN BEGIN
                    TEMPCustLedgerEntry := CustLedgerEntryRec;
                    TEMPCustLedgerEntry.INSERT();
                    TEMPCustLedgerEntry.MARK(TRUE);
                END
                ELSE
                    TEMPCustLedgerEntry.MARK(TRUE);
            UNTIL CustLedgerEntryRec.NEXT() = 0;
        CustLedgerEntryRec.SETCURRENTKEY("Entry No.");
        CustLedgerEntryRec.SETRANGE("Closed by Entry No.");
        CustLedgerEntryRec.MARKEDONLY(TRUE);
        TEMPCustLedgerEntry.SETCURRENTKEY("Entry No.");
        TEMPCustLedgerEntry.SETRANGE("Closed by Entry No.");
        TEMPCustLedgerEntry.MARKEDONLY(TRUE);
    end;

    procedure GetAppliedVendorDocs(CreateVendLedgEntry: Record "Vendor Ledger Entry"; var TEMPVendLedgerEntry: Record "Vendor Ledger Entry"; AppliedAmtWithLCY: Boolean);
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        VendLedgerEntryRec: Record "Vendor Ledger Entry";
    begin
        CLEAR(TEMPVendLedgerEntry);
        DtldVendLedgEntry1.SETCURRENTKEY("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SETRANGE("Vendor Ledger Entry No.", CreateVendLedgEntry."Entry No.");
        DtldVendLedgEntry1.SETRANGE(Unapplied, FALSE);
        IF DtldVendLedgEntry1.FIND('-') THEN
            REPEAT
                IF DtldVendLedgEntry1."Vendor Ledger Entry No." = DtldVendLedgEntry1."Applied Vend. Ledger Entry No." THEN BEGIN
                    DtldVendLedgEntry2.INIT();
                    DtldVendLedgEntry2.SETCURRENTKEY("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendLedgEntry2.SETRANGE("Applied Vend. Ledger Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry2.SETRANGE("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                    DtldVendLedgEntry2.SETRANGE(Unapplied, FALSE);
                    IF DtldVendLedgEntry2.FIND('-') THEN
                        REPEAT
                            IF DtldVendLedgEntry2."Vendor Ledger Entry No." <> DtldVendLedgEntry2."Applied Vend. Ledger Entry No." THEN BEGIN
                                VendLedgerEntryRec.SETCURRENTKEY("Entry No.");
                                VendLedgerEntryRec.SETRANGE("Entry No.", DtldVendLedgEntry2."Vendor Ledger Entry No.");
                                IF VendLedgerEntryRec.FIND('-') THEN BEGIN
                                    VendLedgerEntryRec.MARK(TRUE);
                                    IF NOT TEMPVendLedgerEntry.GET(VendLedgerEntryRec."Entry No.") THEN BEGIN
                                        TEMPVendLedgerEntry := VendLedgerEntryRec;
                                        IF AppliedAmtWithLCY THEN
                                            TEMPVendLedgerEntry."Amount to Apply" := ABS(DtldVendLedgEntry2."Amount (LCY)")
                                        ELSE
                                            TEMPVendLedgerEntry."Amount to Apply" := ABS(DtldVendLedgEntry2.Amount);
                                        TEMPVendLedgerEntry."Transaction No." := DtldVendLedgEntry2."Entry No.";
                                        TEMPVendLedgerEntry.INSERT();
                                        TEMPVendLedgerEntry.MARK(TRUE);
                                    END
                                    ELSE IF TEMPVendLedgerEntry."Transaction No." <> DtldVendLedgEntry2."Entry No." THEN BEGIN
                                        IF AppliedAmtWithLCY THEN
                                            TEMPVendLedgerEntry."Amount to Apply" += ABS(DtldVendLedgEntry2."Amount (LCY)")
                                        ELSE
                                            TEMPVendLedgerEntry."Amount to Apply" += ABS(DtldVendLedgEntry2.Amount);
                                        TEMPVendLedgerEntry.MODIFY();
                                        TEMPVendLedgerEntry.MARK(TRUE);
                                    END;
                                END;
                            END;
                        UNTIL DtldVendLedgEntry2.NEXT() = 0;
                END
                ELSE BEGIN
                    VendLedgerEntryRec.SETCURRENTKEY("Entry No.");
                    VendLedgerEntryRec.SETRANGE("Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    IF VendLedgerEntryRec.FIND('-') THEN BEGIN
                        VendLedgerEntryRec.MARK(TRUE);
                        IF NOT TEMPVendLedgerEntry.GET(VendLedgerEntryRec."Entry No.") THEN BEGIN
                            TEMPVendLedgerEntry := VendLedgerEntryRec;
                            IF AppliedAmtWithLCY THEN
                                TEMPVendLedgerEntry."Amount to Apply" := ABS(DtldVendLedgEntry1."Amount (LCY)")
                            ELSE
                                TEMPVendLedgerEntry."Amount to Apply" := ABS(DtldVendLedgEntry1.Amount);
                            TEMPVendLedgerEntry."Transaction No." := DtldVendLedgEntry1."Entry No.";
                            TEMPVendLedgerEntry.INSERT();
                            TEMPVendLedgerEntry.MARK(TRUE);
                        END
                        ELSE IF TEMPVendLedgerEntry."Transaction No." <> DtldVendLedgEntry1."Entry No." THEN BEGIN
                            IF AppliedAmtWithLCY THEN
                                TEMPVendLedgerEntry."Amount to Apply" += ABS(DtldVendLedgEntry1."Amount (LCY)")
                            ELSE
                                TEMPVendLedgerEntry."Amount to Apply" += ABS(DtldVendLedgEntry1.Amount);
                            TEMPVendLedgerEntry.MODIFY();
                            TEMPVendLedgerEntry.MARK(TRUE);
                        END;
                    END;
                END;
            UNTIL DtldVendLedgEntry1.NEXT() = 0;
        VendLedgerEntryRec.SETCURRENTKEY("Entry No.");
        VendLedgerEntryRec.SETRANGE("Entry No.");
        IF CreateVendLedgEntry."Closed by Entry No." <> 0 THEN BEGIN
            VendLedgerEntryRec."Entry No." := CreateVendLedgEntry."Closed by Entry No.";
            VendLedgerEntryRec.MARK(TRUE);
            IF NOT TEMPVendLedgerEntry.GET(VendLedgerEntryRec."Entry No.") THEN BEGIN
                TEMPVendLedgerEntry := VendLedgerEntryRec;
                TEMPVendLedgerEntry.INSERT();
                TEMPVendLedgerEntry.MARK(TRUE);
            END
            ELSE
                TEMPVendLedgerEntry.MARK(TRUE);
        END;
        VendLedgerEntryRec.SETCURRENTKEY("Closed by Entry No.");
        VendLedgerEntryRec.SETRANGE("Closed by Entry No.", CreateVendLedgEntry."Entry No.");
        IF VendLedgerEntryRec.FIND('-') THEN
            REPEAT
                VendLedgerEntryRec.MARK(TRUE);
                IF NOT TEMPVendLedgerEntry.GET(VendLedgerEntryRec."Entry No.") THEN BEGIN
                    TEMPVendLedgerEntry := VendLedgerEntryRec;
                    TEMPVendLedgerEntry.INSERT();
                    TEMPVendLedgerEntry.MARK(TRUE);
                END
                ELSE
                    TEMPVendLedgerEntry.MARK(TRUE);
            UNTIL VendLedgerEntryRec.NEXT() = 0;
        VendLedgerEntryRec.SETCURRENTKEY("Entry No.");
        VendLedgerEntryRec.SETRANGE("Closed by Entry No.");
        VendLedgerEntryRec.MARKEDONLY(TRUE);
        TEMPVendLedgerEntry.SETCURRENTKEY("Entry No.");
        TEMPVendLedgerEntry.SETRANGE("Closed by Entry No.");
        TEMPVendLedgerEntry.MARKEDONLY(TRUE);
    end;
}
