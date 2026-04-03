page 50111 JobTaskProfileAnswers
{
    Caption = 'Job Task Profile Questionnaire Answers';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = JobTaskProfileAnswer;
    SourceTableView = sorting("Job No.", "Job Task No.", "Answer Priority", "Profile Questionnaire Priority")order(descending)where("Answer Priority"=filter(<>"Very Low (Hidden)"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("Answer Priority"; Rec."Answer Priority")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the priority of the profile answer.';
                    Visible = false;
                }
                field("Profile Questionnaire Priority"; Rec."Profile Questionnaire Priority")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the priority of the questionnaire that the profile answer is linked to.';
                    Visible = false;
                }
                field(Question; Rec.Question())
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Question';
                    ToolTip = 'Specifies the question in the profile questionnaire.';
                }
                field(Answer; Rec.Answer)
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the answer to the question.';

                    trigger OnAssistEdit()
                    var
                        JobTaskProfileAns: Record JobTaskProfileAnswer;
                        Rating: Record Rating;
                        TempRating: Record Rating temporary;
                        ProfileQuestionnaireLine: Record "Profile Questionnaire Line";
                        JobTask: Record "Job Task";
                        ProfileManagement: Codeunit ProfileManagement;
                    begin
                        ProfileQuestionnaireLine.Get(Rec."Profile Questionnaire Code", Rec."Line No.");
                        ProfileQuestionnaireLine.Get(Rec."Profile Questionnaire Code", ProfileQuestionnaireLine.FindQuestionLine());
                        if ProfileQuestionnaireLine."Auto Contact Classification" then begin
                            if ProfileQuestionnaireLine."Contact Class. Field" = ProfileQuestionnaireLine."Contact Class. Field"::Rating then begin
                                Rating.SetRange("Profile Questionnaire Code", Rec."Profile Questionnaire Code");
                                Rating.SetRange("Profile Questionnaire Line No.", ProfileQuestionnaireLine."Line No.");
                                if Rating.Find('-')then repeat if JobTaskProfileAns.Get(Rec."Job No.", Rec."Job Task No.", Rating."Rating Profile Quest. Code", Rating."Rating Profile Quest. Line No.")then begin
                                            TempRating:=Rating;
                                            TempRating.Insert();
                                        end;
                                    until Rating.Next() = 0;
                                if not TempRating.IsEmpty()then PAGE.RunModal(PAGE::"Answer Points List", TempRating)
                                else
                                    Message(Text001);
                            end
                            else
                                Message(Text002, Rec."Last Date Updated");
                        end
                        else
                        begin
                            JobTask.Get(Rec."Job No.", Rec."Job Task No.");
                            // ProfileManagement.ShowJobTaskQuestionnaireCard(JobTask, Rec."Profile Questionnaire Code", Rec."Line No.");
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field("Questions Answered (%)"; Rec."Questions Answered (%)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the percentage of questions that have been answered.';
                }
                field("Last Date Updated"; Rec."Last Date Updated")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the date when the profile answer was last updated.';
                }
            }
        }
    }
    var Text001: Label 'There are no answer values for this rating answer.';
    Text002: Label 'This answer reflects the state on %1 when the Update Contact Class. batch job was run.\To make the answer reflect the current state, run the batch job again.';
}
