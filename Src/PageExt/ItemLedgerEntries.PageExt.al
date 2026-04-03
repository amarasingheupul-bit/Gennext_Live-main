pageextension 50162 "4HC Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("4HC Service Item Doc No."; Rec."4HC Service Item Doc No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Service Item Doc. No. field.';
            }
        }
        modify("Serial No.")
        {
            Visible = true;
        }
        modify("Expiration Date")
        {
            Visible = true;
        }
    }
    actions
    {
        addafter("&Navigate")
        {
            action(CreateServiceItem)
            {
                ApplicationArea = All;
                Image = ItemGroup;
                Caption = 'Create Service Item';
                ToolTip = 'Create Service Items form sales shipment lines.';
                trigger OnAction()
                var
                    ItemLedergerEntry: Record "Item Ledger Entry";
                begin
                    if Confirm('Do you want to Create Service Items.') then begin
                        //ItemLedergerEntry.SetRange("Entry No.", Rec."Entry No.");
                        CurrPage.SetSelectionFilter(ItemLedergerEntry);
                        CreateServiceItemCode.CreateServiceItemDocuments(ItemLedergerEntry);
                        Message('Service Item Created..');
                    end;
                end;
            }
            action(DeleteServiceItem)
            {
                ApplicationArea = All;
                Image = DeleteAllBreakpoints;
                Caption = 'Delete All Service Item';
                ToolTip = 'Delete All Service Item';
                trigger OnAction()
                var
                    ServiceItem: Record "Service Item";
                begin
                    if Confirm('Do you want to Delete Service Items.') then begin
                        ServiceItem.DeleteAll();
                        Message('All Service Item Deleted..');
                    end;
                end;
            }
        }
    }
    var
        CreateServiceItemCode: Codeunit "4HC Gennext Update Entries";
}
