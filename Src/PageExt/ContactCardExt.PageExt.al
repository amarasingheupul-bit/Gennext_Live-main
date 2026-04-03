pageextension 50120 ContactCardExt extends "Contact Card"
{
    layout
    {
        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify("Language Code")
        {
            Visible = false;
        }
        modify("Format Region")
        {
            Visible = false;
        }
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
    actions
    {
        modify("Industry Groups")
        {
            ApplicationArea = All;
            Promoted = true;
            PromotedCategory = Category5;
        }
    }
}
