pageextension 50117 TaskListExt extends "Task List"
{
    layout
    {
        addbefore(Control1900383207)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(170), "No." = field("No.");
            }
        }
    }
    actions
    {
        addfirst(Processing)
        {
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
        }
        moveafter("&Create Task"; "Co&mment")
        addlast(Category_Process)
        {
            actionref("Co&mment_Promoted"; "Co&mment")
            {
            }
            actionref("DocAttach_Promoted"; DocAttach)
            {
            }
        }
    }
}
