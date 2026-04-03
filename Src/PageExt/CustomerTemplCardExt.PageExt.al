pageextension 50126 CustomerTemplCardExt extends "Customer Templ. Card"
{
    layout
    {
        modify("Tax Liable")
        {
            Visible = true;
        }
        modify("Tax Area Code")
        {
            Visible = true;
        }
        moveafter("Customer Posting Group"; "Tax Liable")
        moveafter("Tax Liable"; "Tax Area Code")
    }
}
