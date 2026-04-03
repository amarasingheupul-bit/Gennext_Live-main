tableextension 50104 SalesReceivableSetupS365 extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; ArchiveandDeleteQuoteS365; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Archive and Delete Quote';
        }
        field(50101; Director; code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Director';
            TableRelation = "Salesperson/Purchaser";
        }
    }
}
