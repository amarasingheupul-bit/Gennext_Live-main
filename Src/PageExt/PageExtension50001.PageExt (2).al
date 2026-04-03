pageextension 50140 CustomerTemplCard extends Microsoft.Sales.Customer."Customer Templ. Card"
{
    layout
    {
        moveafter("Customer Posting Group"; "Tax Liable")
        modify("Tax Liable")
        {
            Visible = true;
        }
        moveafter("Tax Liable"; "Tax Area Code")
        modify("Tax Area Code")
        {
            Visible = true;
        }
    }
}
