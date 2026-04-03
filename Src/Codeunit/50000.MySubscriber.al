codeunit 50107 MySubscriber
{
    [EventSubscriber(ObjectType::Codeunit, 367, 'OnBeforeVoidCheck', '', false, false)]
    procedure MyOnBeforeCheckvoid(var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        Should_Not_be_Blank: Label 'Void Remarks Should Not be Blank';
        GenJnlLine2: Record "Gen. Journal Line";
        VoidCheckLedger: Record "Check Ledger Entry";
        ConfirmVoid: Page "Confirm Void";
        CheckLedgEntry2: Record "Check Ledger Entry";
        ChequeMgt: Codeunit ChequeMgt;
    begin
        //PV
        GenJnlLine.TESTFIELD("External Document No.");

        VoidCheckLedger.RESET();
        VoidCheckLedger.SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
        IF GenJnlLine.Amount <= 0 THEN
            VoidCheckLedger.SETRANGE("Bank Account No.", GenJnlLine."Account No.")
        ELSE
            VoidCheckLedger.SETRANGE("Bank Account No.", GenJnlLine."Bal. Account No.");
        VoidCheckLedger.SETRANGE("Entry Status", VoidCheckLedger."Entry Status"::Printed);
        VoidCheckLedger.SETRANGE("Check No.", GenJnlLine."External Document No.");
        VoidCheckLedger.FINDFIRST();

        CLEAR(ConfirmVoid);
        ConfirmVoid.SetCheckLedgerEntry(VoidCheckLedger);
        IF ConfirmVoid.RUNMODAL() <> ACTION::Yes THEN
            EXIT;

        IF ConfirmVoid.GetVoidRemarks() = '' THEN
            ERROR('Void remarks cannot be empty.');

        VoidRemarks := ConfirmVoid.GetVoidRemarks();

        ChequeMgt.VoidCheck(GenJnlLine, VoidRemarks);
        IsHandled := true;
    end;



    procedure GetUserName(UserID: Code[50]) FullName: Text[80]
    var
        User: Record User;
    begin
        //S[20725] T[20772] [MARLYN]
        User.SETCURRENTKEY("User Name");
        User.SETRANGE("User Name", UserID);
        IF User.FINDFIRST() THEN
            EXIT(User."Full Name");
    end;

    procedure FormatNoText(var NoText: array[3] of Text[80]; No: Decimal; CurrencyCode: Code[10]; IsUpperCase: Boolean; StartStar: Boolean; EndStar: Boolean)
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
        DecimalPosition: Decimal;
        Cents_: Integer;
        Text026: Label 'Zero';
        Text027: Label 'Hundred';
        Text028: Label 'And';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        Text032: Label 'One';
        Text033: Label 'Two';
        Text034: Label 'Three';
        Text035: Label 'Four';
        Text036: Label 'Five';
        Text037: Label 'Six';
        Text038: Label 'Seven';
        Text039: Label 'Eight';
        Text040: Label 'Nine';
        Text041: Label 'Ten';
        Text042: Label 'Eleven';
        Text043: Label 'Twelve';
        Text044: Label 'Thirteen';
        Text045: Label 'Fourteen';
        Text046: Label 'Fifteen';
        Text047: Label 'Sixteen';
        Text048: Label 'Seventeen';
        Text049: Label 'Eighteen';
        Text050: Label 'Nineteen';
        Text051: Label 'Twenty';
        Text052: Label 'Thirty';
        Text053: Label 'Forty';
        Text054: Label 'Fifty';
        Text055: Label 'Sixty';
        Text056: Label 'Seventy';
        Text057: Label 'Eighty';
        Text058: Label 'Ninety';
        Text059: Label 'Thousand';
        Text060: Label 'Million';
        Text061: Label 'Billion';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        DescriptionLine: array[3] of Text[80];
        TensDec: Integer;
        OnesDec: Integer;
        CentsText: Text;
        Text062: Label 'Cents Only';
        TextEmpty: Text;
        TextStarSign: Label '***';
        ZeroText: Text;
        HundredText: Text;
        AndText: Text;
    begin
        /// <summary>
        /// This function converts a number to text format.
        /// This funtion use "AddToNoText" & "GetAmtDecimalPosition" local functions.
        ///
        /// </summary>
        /// <param name="NoText">Text(80) array length of 3 which returns the text</param>
        /// <param name="No">Amount or the number needs to be converted</param>
        /// <param name="CurrencyCode">Currency Code if any, if not keep it blank</param>
        /// <param name="IsUpperCase">if "TRUE" text will return in UPPERCASE, if "FALSE" first letter of each word in UPPERCASE</param>
        /// <param name="StartStar">if "TRUE", "***" will print at the begin</param>
        /// <param name="EndStar">if "TRUE", "***" will print at the end</param>
        /// <returns></returns>

        // InitTextVariable --- START
        IF IsUpperCase THEN BEGIN

            OnesText[1] := UPPERCASE(Text032);
            OnesText[2] := UPPERCASE(Text033);
            OnesText[3] := UPPERCASE(Text034);
            OnesText[4] := UPPERCASE(Text035);
            OnesText[5] := UPPERCASE(Text036);
            OnesText[6] := UPPERCASE(Text037);
            OnesText[7] := UPPERCASE(Text038);
            OnesText[8] := UPPERCASE(Text039);
            OnesText[9] := UPPERCASE(Text040);
            OnesText[10] := UPPERCASE(Text041);
            OnesText[11] := UPPERCASE(Text042);
            OnesText[12] := UPPERCASE(Text043);
            OnesText[13] := UPPERCASE(Text044);
            OnesText[14] := UPPERCASE(Text045);
            OnesText[15] := UPPERCASE(Text046);
            OnesText[16] := UPPERCASE(Text047);
            OnesText[17] := UPPERCASE(Text048);
            OnesText[18] := UPPERCASE(Text049);
            OnesText[19] := UPPERCASE(Text050);

            TensText[1] := TextEmpty;
            TensText[2] := UPPERCASE(Text051);
            TensText[3] := UPPERCASE(Text052);
            TensText[4] := UPPERCASE(Text053);
            TensText[5] := UPPERCASE(Text054);
            TensText[6] := UPPERCASE(Text055);
            TensText[7] := UPPERCASE(Text056);
            TensText[8] := UPPERCASE(Text057);
            TensText[9] := UPPERCASE(Text058);

            ExponentText[1] := TextEmpty;
            ExponentText[2] := UPPERCASE(Text059);
            ExponentText[3] := UPPERCASE(Text060);
            ExponentText[4] := UPPERCASE(Text061);

            CentsText := UPPERCASE(Text062);
            ZeroText := UPPERCASE(Text026);
            HundredText := UPPERCASE(Text027);
            AndText := UPPERCASE(Text028);

        END ELSE BEGIN
            OnesText[1] := Text032;
            OnesText[2] := Text033;
            OnesText[3] := Text034;
            OnesText[4] := Text035;
            OnesText[5] := Text036;
            OnesText[6] := Text037;
            OnesText[7] := Text038;
            OnesText[8] := Text039;
            OnesText[9] := Text040;
            OnesText[10] := Text041;
            OnesText[11] := Text042;
            OnesText[12] := Text043;
            OnesText[13] := Text044;
            OnesText[14] := Text045;
            OnesText[15] := Text046;
            OnesText[16] := Text047;
            OnesText[17] := Text048;
            OnesText[18] := Text049;
            OnesText[19] := Text050;

            TensText[1] := TextEmpty;
            TensText[2] := Text051;
            TensText[3] := Text052;
            TensText[4] := Text053;
            TensText[5] := Text054;
            TensText[6] := Text055;
            TensText[7] := Text056;
            TensText[8] := Text057;
            TensText[9] := Text058;

            ExponentText[1] := TextEmpty;
            ExponentText[2] := Text059;
            ExponentText[3] := Text060;
            ExponentText[4] := Text061;

            CentsText := Text062;
            ZeroText := Text026;
            HundredText := Text027;
            AndText := Text028;
        END;
        // InitTextVariable ---  END

        CLEAR(NoText);
        NoTextIndex := 1;

        IF StartStar THEN
            NoText[1] := TextStarSign
        ELSE
            NoText[1] := TextEmpty;

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, ZeroText)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, HundredText);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, AndText);
        DecimalPosition := GetAmtDecimalPosition(CurrencyCode);

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);

        // --- Display Cents ----------------------------------
        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;
        IF TensDec >= 2 THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            IF OnesDec > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        END ELSE
            IF (TensDec * 10 + OnesDec) > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            ELSE
                AddToNoText(NoText, NoTextIndex, PrintExponent, ZeroText);

        IF EndStar THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CentsText + TextEmpty + TextStarSign)
        ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, CentsText);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    var
        Text_: Text;
        Text01: Label '%1 results in a written number that is too long.';
        Text02: Label ' ';
    begin
        /// <summary>
        /// This function used to create the text.
        /// Calles inside the "FormatNoText" Function.
        /// </summary>

        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + Text02 + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text01, AddText);
        END;

        NoText[NoTextIndex] := NoText[NoTextIndex] + Text02 + AddText
    end;

    local procedure GetAmtDecimalPosition(CurrCode: Code[10]): Decimal
    var
        Currency: Record Currency;
    begin
        /// <summary>
        /// This function used to get the decimal points according to currency code.
        /// Calles inside the "FormatNoText" Function.
        /// </summary>

        IF CurrCode = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(CurrCode);
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
        EXIT(1 / Currency."Amount Rounding Precision");
    end;

    var
        VoidRemarks: Text[200];
}
