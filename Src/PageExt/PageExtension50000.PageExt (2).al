pageextension 50141 PageExtension50141 extends Microsoft.CRM.Contact."Contact Card"
{
    layout
    {
        modify(LastDateTimeModified)
        {
            Visible = false;
        }
        modify("Date of Last Interaction")
        {
            Visible = false;
        }
        modify("Organizational Level Code")
        {
            Visible = false;
        }
        modify("Last Date Attempted")
        {
            Visible = false;
        }
        modify("Next Task Date")
        {
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify(Minor)
        {
            Visible = false;
        }
        modify("Parental Consent Received")
        {
            Visible = false;
        }
        modify("Territory Code")
        {
            Visible = false;
        }
        modify(ContactIntEntriesSubform)
        {
            Visible = false;
        }
    }
}
