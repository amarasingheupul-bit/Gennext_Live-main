report 50105 DeletePostedDocuments
{
    ApplicationArea = All;
    Caption = 'Delete Posted Documents';
    UsageCategory = Administration;
    ProcessingOnly = true;
    Permissions = tabledata "Sales Invoice Header" = rmd,
        tabledata "Sales Invoice Line" = rmd,
        tabledata "Sales Shipment Header" = rmd,
        tabledata "Sales Shipment Line" = rmd,
        tabledata "Purch. Inv. Header" = rmd,
        tabledata "Purch. Inv. Line" = rmd,
        tabledata "Purch. Rcpt. Header" = rmd,
        tabledata "Purch. Rcpt. Line" = rmd;

    trigger OnPreReport()
    begin
        if not Confirm('Are you sure you want to delete all Posted sales invoices,posted sales shipments,Posted purchase invoices,Posted purchase receipts?') then exit;
        DeletePostedSalesInvoices();
        DeletePostedPurchaseInvoices();
        DeletePostedSalesShipments();
        DeletePostedPurchaseReceipts();
    end;

    local procedure DeletePostedSalesInvoices()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        if not SalesInvoiceLine.IsEmpty() then SalesInvoiceLine.DeleteAll();
        if not SalesInvoiceHeader.IsEmpty() then SalesInvoiceHeader.DeleteAll();
    end;

    local procedure DeletePostedSalesShipments()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        if not SalesShipmentLine.IsEmpty() then SalesShipmentLine.DeleteAll();
        if not SalesShipmentHeader.IsEmpty() then SalesShipmentHeader.DeleteAll();
    end;

    local procedure DeletePostedPurchaseInvoices()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        if not PurchInvLine.IsEmpty() then PurchInvLine.DeleteAll();
        if not PurchInvHeader.IsEmpty() then PurchInvHeader.DeleteAll();
    end;

    local procedure DeletePostedPurchaseReceipts()
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        if not PurchRcptLine.IsEmpty() then PurchRcptLine.DeleteAll();
        if not PurchRcptHeader.IsEmpty() then PurchRcptHeader.DeleteAll();
    end;
}
