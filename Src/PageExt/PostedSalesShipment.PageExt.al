pageextension 50153 "4HC Posted Sales Shipment" extends "Posted Sales Shipment"
{
    actions
    {
        addafter("&Print")
        {
            action(AdviceOfDispatch)
            {
                ApplicationArea = All;
                Caption = 'Print Advice of Dispatch';
                Tooltip = 'Prints the Advice of Dispatch report for the selected sales shipment.';
                Image = Shipment;
                trigger OnAction();
                var
                    SalesShipmentHeader: Record "Sales Shipment Header";
                begin
                    SalesShipmentHeader.SetRange("No.", Rec."No.");
                    if SalesShipmentHeader.FindFirst() then
                        Report.Run(50117, true, true, SalesShipmentHeader);
                end;
            }
        }
        addlast(Category_Category4)
        {
            actionref(AdviceOfDispatch_Promoted; AdviceOfDispatch)
            {
            }
        }
    }
}