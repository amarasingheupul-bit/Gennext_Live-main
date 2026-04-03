page 50140 "4HC SP Import Worksheet"
{
    AutoSplitKey = true;
    Caption = 'SP Import Worksheet';
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SaveValues = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(BatchName; this.BatchName)
            {
                Caption = 'Batch Name';
                ApplicationArea = All;
                ToolTip = 'Just provide a name';
            }
            field(ModifyCount; this.ModifyCount)
            {
                Caption = 'Modify Count';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Modified GL Entries Count';
            }
            field(FileNameField; this.FileName)
            {
                Caption = 'File Name';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'File Name';
            }
            field(SheetNameField; this.SheetName)
            {
                Caption = 'Sheet Name';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Sheet Name';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Import")
            {
                Caption = '&Import';
                Image = ImportExcel;
                ApplicationArea = All;
                ToolTip = 'Import data from excel.';
                trigger OnAction()
                var
                begin
                    if this.BatchName = '' then
                        Error(this.BatchISBlankMsg);
                    this.ReadExcelSheet();
                    this.ImportExcelData();
                end;
            }
        }
        area(Promoted)
        {
            actionref(Import_Promoted; "&Import")
            {
            }
        }
    }

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UpadateEntries: Codeunit "4HC Gennext Update Entries";
        BatchName: Code[10];
        ModifyCount: Integer;
        FileName: Text;
        SheetName: Text;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        BatchISBlankMsg: Label 'Batch name is blank';
        ExcelImportSucessMsg: Label 'Excel is successfully imported.';

    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text;
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            this.FileName := FileMgt.GetFileName(FromFile);
            this.SheetName := this.TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(this.NoFileFoundMsg);
        this.TempExcelBuffer.Reset();
        this.TempExcelBuffer.DeleteAll();
        this.TempExcelBuffer.OpenBookStream(IStream, this.SheetName);
        this.TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        TempSOImportBuffer: Record "G/L Entry" temporary;
        GLEntry: Record "G/L Entry";
        RowNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        TempSOImportBuffer.Reset();
        // if SOImportBufferTemp.FindLast() then
        //     LineNo := SOImportBufferTemp."Line No.";
        this.TempExcelBuffer.Reset();
        if this.TempExcelBuffer.FindLast() then
            MaxRowNo := this.TempExcelBuffer."Row No.";

        for RowNo := 2 to MaxRowNo do begin
            LineNo := LineNo + 10000;
            TempSOImportBuffer.Init();
            Evaluate(TempSOImportBuffer."Document No.", this.GetValueAtCell(RowNo, 2));
            Evaluate(TempSOImportBuffer."Posting Date", this.GetValueAtCell(RowNo, 1));
            Evaluate(TempSOImportBuffer."Salesperson Code", this.GetValueAtCell(RowNo, 3));
            Evaluate(TempSOImportBuffer."Entry No.", this.GetValueAtCell(RowNo, 4));
            TempSOImportBuffer.Insert();
        end;
        Message(ExcelImportSucessMsg);

        TempSOImportBuffer.Reset();
        if TempSOImportBuffer.FindSet() then
            repeat
                GLEntry.Reset();
                GLEntry.SetRange("Entry No.", TempSOImportBuffer."Entry No.");
                GLEntry.SetRange("Document No.", TempSOImportBuffer."Document No.");
                GLEntry.SetRange("Posting Date", TempSOImportBuffer."Posting Date");
                if GLEntry.FindFirst() then begin
                    GLEntry."Salesperson Code" := TempSOImportBuffer."Salesperson Code";
                    if this.UpadateEntries.UpdateSalesPersonInGLEntryFromExcel(GLEntry) then
                        this.ModifyCount += 1;
                end;
            until TempSOImportBuffer.Next() = 0;
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        this.TempExcelBuffer.Reset();
        if this.TempExcelBuffer.Get(RowNo, ColNo) then
            exit(this.TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
}