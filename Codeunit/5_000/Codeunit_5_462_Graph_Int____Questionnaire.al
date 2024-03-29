OBJECT Codeunit 5462 Graph Int. - Questionnaire
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ProfileQuestionnaireDescriptionTxt@1000 : TextConst 'DAN=Microsoft Graph-synkronisering til kontakter;ENU=Microsoft Graph Syncing for Contacts';
      NameProfileQuestionTxt@1001 : TextConst 'DAN=Navn;ENU=Name';
      AnniversariesProfileQuestionTxt@1002 : TextConst 'DAN=�rsdage;ENU=Anniversaries';
      PhoneticNameProfileQuestionTxt@1003 : TextConst 'DAN=PhoneticName;ENU=PhoneticName';
      WorkProfileQuestionTxt@1004 : TextConst 'DAN=Arbejde;ENU=Work';

    [EventSubscriber(Codeunit,5345,OnAfterTransferRecordFields)]
    [External]
    PROCEDURE OnAfterTransferRecordFields@35(SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef;VAR AdditionalFieldsWereModified@1000 : Boolean);
    BEGIN
      CASE GetSourceDestCode(SourceRecordRef,DestinationRecordRef) OF
        'Contact-Graph Contact':
          BEGIN
            SetProfileQuestionnaireOnGraph(SourceRecordRef,DestinationRecordRef);
            AdditionalFieldsWereModified := TRUE;
          END;
      END;
    END;

    [EventSubscriber(Codeunit,5345,OnAfterInsertRecord)]
    [External]
    PROCEDURE OnAfterInsertRecord@45(SourceRecordRef@1001 : RecordRef;DestinationRecordRef@1000 : RecordRef);
    BEGIN
      CASE GetSourceDestCode(SourceRecordRef,DestinationRecordRef) OF
        'Graph Contact-Contact':
          CreateProfileQuestionnaireFromGraph(SourceRecordRef,DestinationRecordRef);
      END;
    END;

    [EventSubscriber(Codeunit,5345,OnAfterModifyRecord)]
    [External]
    PROCEDURE OnAfterModifyRecord@51(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef);
    BEGIN
      CASE GetSourceDestCode(SourceRecordRef,DestinationRecordRef) OF
        'Graph Contact-Contact':
          SetProfileQuestionnaireFromGraph(SourceRecordRef,DestinationRecordRef);
      END;
    END;

    LOCAL PROCEDURE GetSourceDestCode@38(SourceRecordRef@1001 : RecordRef;DestinationRecordRef@1000 : RecordRef) : Text;
    BEGIN
      IF (SourceRecordRef.NUMBER <> 0) AND (DestinationRecordRef.NUMBER <> 0) THEN
        EXIT(STRSUBSTNO('%1-%2',SourceRecordRef.NAME,DestinationRecordRef.NAME));
      EXIT('');
    END;

    [External]
    PROCEDURE GetGraphSyncQuestionnaireCode@3() : Code[10];
    BEGIN
      EXIT(UPPERCASE('GraphSync'));
    END;

    LOCAL PROCEDURE GetProfileQuestionnaireLine@16(VAR ProfileQuestionnaireLine@1001 : Record 5088;InputType@1002 : Option;InputDescription@1000 : Text[250]) : Boolean;
    BEGIN
      WITH ProfileQuestionnaireLine DO BEGIN
        SETRANGE("Profile Questionnaire Code",GetGraphSyncQuestionnaireCode);
        SETRANGE(Type,InputType);
        SETRANGE(Description,InputDescription);
        EXIT(FINDFIRST);
      END;
    END;

    LOCAL PROCEDURE GetContactProfileAnswer@6(VAR ContactProfileAnswer@1000 : Record 5089;ContactNo@1001 : Code[20];Description@1002 : Text[250]) : Boolean;
    VAR
      ProfileQuestionnaireLine@1003 : Record 5088;
    BEGIN
      IF GetProfileQuestionnaireLine(ProfileQuestionnaireLine,ProfileQuestionnaireLine.Type::Answer,Description) THEN
        EXIT(ContactProfileAnswer.GET(ContactNo,GetGraphSyncQuestionnaireCode,ProfileQuestionnaireLine."Line No."));
    END;

    [External]
    PROCEDURE CreateGraphSyncQuestionnaire@18();
    VAR
      GraphContact@1001 : Record 5450;
      ProfileQuestionnaireHeader@1000 : Record 5087;
    BEGIN
      WITH ProfileQuestionnaireHeader DO
        IF NOT GET(GetGraphSyncQuestionnaireCode) THEN BEGIN
          INIT;
          VALIDATE(Code,GetGraphSyncQuestionnaireCode);
          VALIDATE(Description,ProfileQuestionnaireDescriptionTxt);
          VALIDATE("Contact Type","Contact Type"::People);
          INSERT(TRUE);
        END;

      CreateProfileQuestion(NameProfileQuestionTxt);
      CreateProfileAnswer(GraphContact.FIELDNAME(Title));
      CreateProfileAnswer(GraphContact.FIELDNAME(NickName));
      CreateProfileAnswer(GraphContact.FIELDNAME(Generation));

      CreateProfileQuestion(AnniversariesProfileQuestionTxt);
      CreateProfileAnswer(GraphContact.FIELDNAME(Birthday));
      CreateProfileAnswer(GraphContact.FIELDNAME(WeddingAnniversary));
      CreateProfileAnswer(GraphContact.FIELDNAME(SpouseName));

      CreateProfileQuestion(PhoneticNameProfileQuestionTxt);
      CreateProfileAnswer(GraphContact.FIELDNAME(YomiGivenName));
      CreateProfileAnswer(GraphContact.FIELDNAME(YomiSurname));

      CreateProfileQuestion(WorkProfileQuestionTxt);
      CreateProfileAnswer(GraphContact.FIELDNAME(Profession));
      CreateProfileAnswer(GraphContact.FIELDNAME(Department));
      CreateProfileAnswer(GraphContact.FIELDNAME(OfficeLocation));
      CreateProfileAnswer(GraphContact.FIELDNAME(AssistantName));
      CreateProfileAnswer(GraphContact.FIELDNAME(Manager));
    END;

    LOCAL PROCEDURE CreateProfileQuestion@17(InputDescription@1001 : Text[250]);
    VAR
      ProfileQuestionnaireLine@1000 : Record 5088;
    BEGIN
      CreateProfileQestionnaireLine(InputDescription,ProfileQuestionnaireLine.Type::Question,TRUE);
    END;

    LOCAL PROCEDURE CreateProfileAnswer@19(InputDescription@1000 : Text[250]);
    VAR
      ProfileQuestionnaireLine@1001 : Record 5088;
    BEGIN
      CreateProfileQestionnaireLine(InputDescription,ProfileQuestionnaireLine.Type::Answer,FALSE);
    END;

    LOCAL PROCEDURE CreateProfileQestionnaireLine@8(InputDescription@1001 : Text[250];InputType@1002 : Option;EnableMultipleAnswers@1003 : Boolean);
    VAR
      ProfileQuestionnaireLine@1000 : Record 5088;
    BEGIN
      IF NOT GetProfileQuestionnaireLine(ProfileQuestionnaireLine,InputType,InputDescription) THEN
        WITH ProfileQuestionnaireLine DO BEGIN
          INIT;
          VALIDATE("Profile Questionnaire Code",GetGraphSyncQuestionnaireCode);
          VALIDATE("Line No.",GetNewLineNo);
          VALIDATE(Type,InputType);
          VALIDATE(Description,InputDescription);
          VALIDATE("Multiple Answers",EnableMultipleAnswers);
          INSERT(TRUE);
        END;
    END;

    LOCAL PROCEDURE CreateContactProfileAnswer@46(ContactNo@1001 : Code[20];InputDescription@1002 : Text[250];NewProfileQuestionnaireValue@1004 : Text);
    VAR
      ContactProfileAnswer@1000 : Record 5089;
      ProfileQuestionnaireLine@1003 : Record 5088;
    BEGIN
      IF NOT GetProfileQuestionnaireLine(ProfileQuestionnaireLine,ProfileQuestionnaireLine.Type::Answer,InputDescription) THEN
        EXIT;

      WITH ContactProfileAnswer DO
        IF GET(ContactNo,GetGraphSyncQuestionnaireCode,ProfileQuestionnaireLine."Line No.") THEN BEGIN
          VALIDATE("Profile Questionnaire Value",COPYSTR(NewProfileQuestionnaireValue,1,MAXSTRLEN("Profile Questionnaire Value")));
          MODIFY(TRUE);
        END ELSE BEGIN
          INIT;
          VALIDATE("Contact No.",ContactNo);
          VALIDATE("Profile Questionnaire Code",GetGraphSyncQuestionnaireCode);
          VALIDATE("Line No.",ProfileQuestionnaireLine."Line No.");
          VALIDATE("Profile Questionnaire Value",COPYSTR(NewProfileQuestionnaireValue,1,MAXSTRLEN("Profile Questionnaire Value")));
          INSERT(TRUE);
        END;
    END;

    LOCAL PROCEDURE GetNewLineNo@27() : Integer;
    VAR
      ProfileQuestionnaireLine@1000 : Record 5088;
    BEGIN
      WITH ProfileQuestionnaireLine DO BEGIN
        SETRANGE("Profile Questionnaire Code",GetGraphSyncQuestionnaireCode);
        IF FINDLAST THEN;
        EXIT("Line No." + 10000);
      END;
    END;

    LOCAL PROCEDURE SetProfileQuestionnaireOnGraph@7(VAR SourceRecordRef@1000 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef);
    VAR
      Contact@1002 : Record 5050;
      GraphContact@1004 : Record 5450;
    BEGIN
      SourceRecordRef.SETTABLE(Contact);
      DestinationRecordRef.SETTABLE(GraphContact);

      SetProfileQuestionnaireForNameOnGraph(Contact,GraphContact);
      SetProfileQuestionnaireForAnniversariesOnGraph(Contact,GraphContact);
      SetProfileQuestionnaireForPhoneticNameOnGraph(Contact,GraphContact);
      SetProfileQuestionnaireForWorkOnGraph(Contact,GraphContact);

      DestinationRecordRef.GETTABLE(GraphContact);
    END;

    LOCAL PROCEDURE CreateProfileQuestionnaireFromGraph@10(VAR SourceRecordRef@1000 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef);
    BEGIN
      SetProfileQuestionnaireFromGraph(SourceRecordRef,DestinationRecordRef);
    END;

    LOCAL PROCEDURE SetProfileQuestionnaireFromGraph@11(VAR SourceRecordRef@1000 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef);
    VAR
      Contact@1002 : Record 5050;
      GraphContact@1003 : Record 5450;
    BEGIN
      SourceRecordRef.SETTABLE(GraphContact);
      DestinationRecordRef.SETTABLE(Contact);

      SetProfileQuestionnaireForNameFromGraph(Contact,GraphContact);
      SetProfileQuestionnaireForAnniversariesFromGraph(Contact,GraphContact);
      SetProfileQuestionnaireForPhoneticNameFromGraph(Contact,GraphContact);
      SetProfileQuestionnaireForWorkFromGraph(Contact,GraphContact);

      DestinationRecordRef.GETTABLE(Contact);
    END;

    LOCAL PROCEDURE SetProfileQuestionnaireForNameOnGraph@1(VAR Contact@1001 : Record 5050;VAR GraphContact@1000 : Record 5450);
    VAR
      ContactProfileAnswer@1002 : Record 5089;
    BEGIN
      ContactProfileAnswer.SETRANGE("Contact No.",Contact."No.");
      ContactProfileAnswer.SETRANGE("Profile Questionnaire Code",GetGraphSyncQuestionnaireCode);
      IF ContactProfileAnswer.ISEMPTY THEN
        EXIT;

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(Title));
      GraphContact.Title := COPYSTR(ContactProfileAnswer."Profile Questionnaire Value",1,MAXSTRLEN(GraphContact.Title));

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(NickName));
      GraphContact.NickName := COPYSTR(ContactProfileAnswer."Profile Questionnaire Value",1,MAXSTRLEN(GraphContact.NickName));

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(Generation));
      GraphContact.Generation := COPYSTR(ContactProfileAnswer."Profile Questionnaire Value",1,MAXSTRLEN(GraphContact.Generation));
    END;

    LOCAL PROCEDURE SetProfileQuestionnaireForAnniversariesOnGraph@2(VAR Contact@1001 : Record 5050;VAR GraphContact@1000 : Record 5450);
    VAR
      ContactProfileAnswer@1002 : Record 5089;
      BirthdayDate@1004 : Date;
      WeddingAnniversaryDate@1005 : Date;
    BEGIN
      ContactProfileAnswer.SETRANGE("Contact No.",Contact."No.");
      ContactProfileAnswer.SETRANGE("Profile Questionnaire Code",GetGraphSyncQuestionnaireCode);
      IF ContactProfileAnswer.ISEMPTY THEN
        EXIT;

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(Birthday));
      EVALUATE(BirthdayDate,ContactProfileAnswer."Profile Questionnaire Value");
      GraphContact.Birthday := CREATEDATETIME(BirthdayDate,0T);

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(WeddingAnniversary));
      EVALUATE(WeddingAnniversaryDate,ContactProfileAnswer."Profile Questionnaire Value");
      GraphContact.WeddingAnniversary := CREATEDATETIME(WeddingAnniversaryDate,0T);

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(SpouseName));
      GraphContact.SpouseName := COPYSTR(ContactProfileAnswer."Profile Questionnaire Value",1,MAXSTRLEN(GraphContact.SpouseName));
    END;

    LOCAL PROCEDURE SetProfileQuestionnaireForPhoneticNameOnGraph@4(VAR Contact@1001 : Record 5050;VAR GraphContact@1000 : Record 5450);
    VAR
      ContactProfileAnswer@1002 : Record 5089;
    BEGIN
      ContactProfileAnswer.SETRANGE("Contact No.",Contact."No.");
      ContactProfileAnswer.SETRANGE("Profile Questionnaire Code",GetGraphSyncQuestionnaireCode);
      IF ContactProfileAnswer.ISEMPTY THEN
        EXIT;

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(YomiGivenName));
      GraphContact.YomiGivenName :=
        COPYSTR(ContactProfileAnswer."Profile Questionnaire Value",1,MAXSTRLEN(GraphContact.YomiGivenName));

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(YomiSurname));
      GraphContact.YomiSurname :=
        COPYSTR(ContactProfileAnswer."Profile Questionnaire Value",1,MAXSTRLEN(GraphContact.YomiSurname));
    END;

    LOCAL PROCEDURE SetProfileQuestionnaireForWorkOnGraph@5(VAR Contact@1001 : Record 5050;VAR GraphContact@1000 : Record 5450);
    VAR
      ContactProfileAnswer@1002 : Record 5089;
    BEGIN
      ContactProfileAnswer.SETRANGE("Contact No.",Contact."No.");
      ContactProfileAnswer.SETRANGE("Profile Questionnaire Code",GetGraphSyncQuestionnaireCode);
      IF ContactProfileAnswer.ISEMPTY THEN
        EXIT;

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(Profession));
      GraphContact.Profession :=
        COPYSTR(ContactProfileAnswer."Profile Questionnaire Value",1,MAXSTRLEN(GraphContact.Profession));

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(Department));
      GraphContact.Department :=
        COPYSTR(ContactProfileAnswer."Profile Questionnaire Value",1,MAXSTRLEN(GraphContact.Department));

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(OfficeLocation));
      GraphContact.OfficeLocation :=
        COPYSTR(ContactProfileAnswer."Profile Questionnaire Value",1,MAXSTRLEN(GraphContact.OfficeLocation));

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(AssistantName));
      GraphContact.AssistantName :=
        COPYSTR(ContactProfileAnswer."Profile Questionnaire Value",1,MAXSTRLEN(GraphContact.AssistantName));

      GetContactProfileAnswer(ContactProfileAnswer,Contact."No.",GraphContact.FIELDNAME(Manager));
      GraphContact.Manager :=
        COPYSTR(ContactProfileAnswer."Profile Questionnaire Value",1,MAXSTRLEN(GraphContact.Manager));
    END;

    LOCAL PROCEDURE SetProfileQuestionnaireForNameFromGraph@15(VAR Contact@1001 : Record 5050;VAR GraphContact@1000 : Record 5450);
    BEGIN
      IF NOT GraphContact.HasNameDetailsForQuestionnaire THEN
        EXIT;

      CreateGraphSyncQuestionnaire;

      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(Title),GraphContact.Title);
      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(NickName),GraphContact.NickName);
      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(Generation),GraphContact.Generation);
    END;

    LOCAL PROCEDURE SetProfileQuestionnaireForAnniversariesFromGraph@14(VAR Contact@1001 : Record 5050;VAR GraphContact@1000 : Record 5450);
    BEGIN
      IF NOT GraphContact.HasAnniversariesForQuestionnaire THEN
        EXIT;

      CreateGraphSyncQuestionnaire;

      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(Birthday),FORMAT(GraphContact.Birthday));
      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(WeddingAnniversary),FORMAT(GraphContact.WeddingAnniversary));
      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(SpouseName),GraphContact.SpouseName);
    END;

    LOCAL PROCEDURE SetProfileQuestionnaireForPhoneticNameFromGraph@13(VAR Contact@1001 : Record 5050;VAR GraphContact@1000 : Record 5450);
    BEGIN
      IF NOT GraphContact.HasPhoneticNameDetailsForQuestionnaire THEN
        EXIT;

      CreateGraphSyncQuestionnaire;

      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(YomiGivenName),GraphContact.YomiGivenName);
      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(YomiSurname),GraphContact.YomiSurname);
    END;

    LOCAL PROCEDURE SetProfileQuestionnaireForWorkFromGraph@12(VAR Contact@1001 : Record 5050;VAR GraphContact@1000 : Record 5450);
    BEGIN
      IF NOT GraphContact.HasWorkDetailsForQuestionnaire THEN
        EXIT;

      CreateGraphSyncQuestionnaire;

      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(Profession),GraphContact.Profession);
      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(Department),GraphContact.Department);
      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(OfficeLocation),GraphContact.OfficeLocation);
      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(AssistantName),GraphContact.AssistantName);
      CreateContactProfileAnswer(Contact."No.",GraphContact.FIELDNAME(Manager),GraphContact.Manager);
    END;

    BEGIN
    END.
  }
}

