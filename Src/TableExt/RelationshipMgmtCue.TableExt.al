tableextension 50127 "4HC RelationshipMgmtCue" extends "Relationship Mgmt. Cue"
{
    fields
    {
        field(50100; "All Approval Pending SQ"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Sales Header" where("Approval Status" = filter('Pending Approval')));
            Caption = 'All Pending Approval';
        }
        field(50102; "Pending Apporval In BU"; Integer)
        {
            Caption = 'Pending Apporval In Business Unit';
        }
        field(50101; "Approval Pending Sales Quotes"; Integer)
        {
            Caption = 'Pending Approval';
        }
    }
}