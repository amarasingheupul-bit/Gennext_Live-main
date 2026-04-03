report 50104 DeleteUnpostedInvoices
{
    ApplicationArea = All;
    Caption = 'Delete Unposted Invoices';
    UsageCategory = Administration;
    ProcessingOnly = true;

    trigger OnPreReport()
    begin
        if not Confirm('Are you sure you want to delete all unposted sales invoices and purchase invoices?') then exit;
        DeleteUnpostedSalesInvoices();
        DeleteUnpostedPurchaseInvoices();
    end;

    local procedure DeleteUnpostedSalesInvoices()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Invoice);
        if not SalesLine.IsEmpty() then SalesLine.DeleteAll();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        if not SalesHeader.IsEmpty() then SalesHeader.DeleteAll();
    end;

    local procedure DeleteUnpostedPurchaseInvoices()
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Invoice);
        if not PurchaseLine.IsEmpty() then PurchaseLine.DeleteAll();
        PurchaseHeader.SetRange("Document Type", PurchaseHeader."Document Type"::Invoice);
        if not PurchaseHeader.IsEmpty() then PurchaseHeader.DeleteAll();
    end;
}
