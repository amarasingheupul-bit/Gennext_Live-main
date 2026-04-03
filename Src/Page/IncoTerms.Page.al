page 50105 IncoTerms
{
    ApplicationArea = All;
    Caption = 'IncoTerms';
    PageType = List;
    SourceTable = IncoTerm;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    ToolTip = 'Specifies the code of the IncoTerm.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description of the IncoTerm.';
                }
            }
        }
    }
}
