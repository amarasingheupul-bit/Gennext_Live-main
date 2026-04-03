report 50120 "4HC Update Item Ledger Entries"
{
    Caption = 'Update Item Ledger Entries';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Tracking Code", Inventory;
            CalcFields = Inventory;
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                DataItemLink = "Item No." = field("No.");
                trigger OnAfterGetRecord()
                begin
                    if this.GennextUpdateEntries.ItemLedgerEntryUpdateForSerieal("Item Ledger Entry") then
                        this.EntriesCount += 1;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                this.ItemCount += 1;
                Item."Item Tracking Code" := 'SN NEW';
                Item.Modify();
            end;
        }
    }
    trigger OnPreReport()
    begin
        this.ItemCount := 0;
        this.EntriesCount := 0;
    end;

    trigger OnPostReport()
    begin
        Message('Total Items Processed: %1. Total Item Ledger Entries Processed: %2', this.ItemCount, this.EntriesCount);
    end;

    var
        GennextUpdateEntries: Codeunit "4HC Gennext Update Entries";
        ItemCount: Integer;
        EntriesCount: Integer;
}