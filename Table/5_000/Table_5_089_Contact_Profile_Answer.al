OBJECT Table 5089 Contact Profile Answer
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    OnInsert=VAR
               Contact@1000 : Record 5050;
               ContProfileAnswer@1005 : Record 5089;
               ProfileQuestnLine@1003 : Record 5088;
               ProfileQuestnLine2@1002 : Record 5088;
               ProfileQuestnLine3@1001 : Record 5088;
             BEGIN
               ProfileQuestnLine.GET("Profile Questionnaire Code","Line No.");
               ProfileQuestnLine.TESTFIELD(Type,ProfileQuestnLine.Type::Answer);

               ProfileQuestnLine2.GET("Profile Questionnaire Code",QuestionLineNo);
               ProfileQuestnLine2.TESTFIELD("Auto Contact Classification",FALSE);

               IF NOT ProfileQuestnLine2."Multiple Answers" THEN BEGIN
                 ContProfileAnswer.RESET;
                 ProfileQuestnLine3.RESET;
                 ProfileQuestnLine3.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
                 ProfileQuestnLine3.SETRANGE(Type,ProfileQuestnLine3.Type::Question);
                 ProfileQuestnLine3.SETFILTER("Line No.",'>%1',ProfileQuestnLine2."Line No.");
                 IF ProfileQuestnLine3.FINDFIRST THEN
                   ContProfileAnswer.SETRANGE(
                     "Line No.",ProfileQuestnLine2."Line No.",ProfileQuestnLine3."Line No.")
                 ELSE
                   ContProfileAnswer.SETFILTER("Line No.",'>%1',ProfileQuestnLine2."Line No.");
                 ContProfileAnswer.SETRANGE("Contact No.","Contact No.");
                 ContProfileAnswer.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
                 IF NOT ContProfileAnswer.ISEMPTY THEN
                   ERROR(Text000,ProfileQuestnLine2.FIELDCAPTION("Multiple Answers"));
               END;

               IF PartOfRating THEN BEGIN
                 INSERT;
                 UpdateContactClassification.UpdateRating("Contact No.");
                 DELETE;
               END;

               Contact.TouchContact("Contact No.");
             END;

    OnModify=VAR
               Contact@1000 : Record 5050;
             BEGIN
               Contact.TouchContact("Contact No.");
             END;

    OnDelete=VAR
               Contact@1000 : Record 5050;
               ProfileQuestnLine@1001 : Record 5088;
             BEGIN
               ProfileQuestnLine.GET("Profile Questionnaire Code",QuestionLineNo);
               ProfileQuestnLine.TESTFIELD("Auto Contact Classification",FALSE);

               IF PartOfRating THEN BEGIN
                 DELETE;
                 UpdateContactClassification.UpdateRating("Contact No.");
                 INSERT;
               END;

               Contact.TouchContact("Contact No.");
             END;

    OnRename=VAR
               Contact@1000 : Record 5050;
             BEGIN
               IF xRec."Contact No." = "Contact No." THEN
                 Contact.TouchContact("Contact No.")
               ELSE BEGIN
                 Contact.TouchContact("Contact No.");
                 Contact.TouchContact(xRec."Contact No.");
               END;
             END;

    CaptionML=[DAN=Svar p� kontaktprofil;
               ENU=Contact Profile Answer];
    DrillDownPageID=Page5115;
  }
  FIELDS
  {
    { 1   ;   ;Contact No.         ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                Cont@1000 : Record 5050;
                                                              BEGIN
                                                                IF Cont.GET("Contact No.") THEN
                                                                  "Contact Company No." := Cont."Company No."
                                                                ELSE
                                                                  "Contact Company No." := '';
                                                              END;

                                                   CaptionML=[DAN=Kontaktnr.;
                                                              ENU=Contact No.];
                                                   NotBlank=Yes }
    { 2   ;   ;Contact Company No. ;Code20        ;TableRelation=Contact WHERE (Type=CONST(Company));
                                                   CaptionML=[DAN=Virksomhedsnummer;
                                                              ENU=Contact Company No.];
                                                   NotBlank=Yes }
    { 3   ;   ;Profile Questionnaire Code;Code20  ;TableRelation="Profile Questionnaire Header";
                                                   OnValidate=VAR
                                                                ProfileQuestnHeader@1000 : Record 5087;
                                                              BEGIN
                                                                ProfileQuestnHeader.GET("Profile Questionnaire Code");
                                                                "Profile Questionnaire Priority" := ProfileQuestnHeader.Priority;
                                                              END;

                                                   CaptionML=[DAN=Profilsp�rgeskemakode;
                                                              ENU=Profile Questionnaire Code];
                                                   NotBlank=Yes }
    { 4   ;   ;Line No.            ;Integer       ;TableRelation="Profile Questionnaire Line"."Line No." WHERE (Profile Questionnaire Code=FIELD(Profile Questionnaire Code),
                                                                                                                Type=CONST(Answer));
                                                   OnValidate=VAR
                                                                ProfileQuestnLine@1000 : Record 5088;
                                                              BEGIN
                                                                ProfileQuestnLine.GET("Profile Questionnaire Code","Line No.");
                                                                "Answer Priority" := ProfileQuestnLine.Priority;
                                                              END;

                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 5   ;   ;Answer              ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Profile Questionnaire Line".Description WHERE (Profile Questionnaire Code=FIELD(Profile Questionnaire Code),
                                                                                                                      Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Svar;
                                                              ENU=Answer];
                                                   Editable=No }
    { 6   ;   ;Contact Company Name;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Contact."Company Name" WHERE (No.=FIELD(Contact No.)));
                                                   CaptionML=[DAN=Virksomhed;
                                                              ENU=Contact Company Name];
                                                   Editable=No }
    { 7   ;   ;Contact Name        ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Contact.Name WHERE (No.=FIELD(Contact No.)));
                                                   CaptionML=[DAN=Kontaktnavn;
                                                              ENU=Contact Name];
                                                   Editable=No }
    { 8   ;   ;Profile Questionnaire Priority;Option;
                                                   CaptionML=[DAN=Sp�rgeskemaprioritet;
                                                              ENU=Profile Questionnaire Priority];
                                                   OptionCaptionML=[DAN=Meget lav,Lav,Normal,H�j,Meget h�j;
                                                                    ENU=Very Low,Low,Normal,High,Very High];
                                                   OptionString=Very Low,Low,Normal,High,Very High;
                                                   Editable=No }
    { 9   ;   ;Answer Priority     ;Option        ;CaptionML=[DAN=Svarprioritet;
                                                              ENU=Answer Priority];
                                                   OptionCaptionML=[DAN=Meget lav (skjult),Lav,Normal,H�j,Meget h�j;
                                                                    ENU=Very Low (Hidden),Low,Normal,High,Very High];
                                                   OptionString=Very Low (Hidden),Low,Normal,High,Very High }
    { 10  ;   ;Last Date Updated   ;Date          ;CaptionML=[DAN=Opdateret den;
                                                              ENU=Last Date Updated] }
    { 11  ;   ;Questions Answered (%);Decimal     ;CaptionML=[DAN=Besvarede sp�rgsm�l (pct.);
                                                              ENU=Questions Answered (%)];
                                                   DecimalPlaces=0:0;
                                                   BlankZero=Yes }
    { 5088;   ;Profile Questionnaire Value;Text250;CaptionML=[DAN=Profilsp�rgeskemav�rdi;
                                                              ENU=Profile Questionnaire Value] }
  }
  KEYS
  {
    {    ;Contact No.,Profile Questionnaire Code,Line No.;
                                                   Clustered=Yes }
    {    ;Contact No.,Answer Priority,Profile Questionnaire Priority }
    {    ;Profile Questionnaire Code,Line No.      }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 kan ikke angives til sp�rgsm�let.;ENU=This Question does not allow %1.';
      UpdateContactClassification@1007 : Report 5199;

    [External]
    PROCEDURE Question@1() : Text[250];
    VAR
      ProfileQuestnLine@1000 : Record 5088;
    BEGIN
      IF ProfileQuestnLine.GET("Profile Questionnaire Code",QuestionLineNo) THEN
        EXIT(ProfileQuestnLine.Description)
    END;

    LOCAL PROCEDURE QuestionLineNo@3() : Integer;
    VAR
      ProfileQuestnLine@1000 : Record 5088;
    BEGIN
      WITH ProfileQuestnLine DO BEGIN
        RESET;
        SETRANGE("Profile Questionnaire Code",Rec."Profile Questionnaire Code");
        SETFILTER("Line No.",'<%1',Rec."Line No.");
        SETRANGE(Type,Type::Question);
        IF FINDLAST THEN
          EXIT("Line No.")
      END;
    END;

    LOCAL PROCEDURE PartOfRating@4() : Boolean;
    VAR
      Rating@1001 : Record 5111;
      ProfileQuestnLine@1000 : Record 5088;
      ProfileQuestnLine2@1002 : Record 5088;
    BEGIN
      Rating.SETCURRENTKEY("Rating Profile Quest. Code","Rating Profile Quest. Line No.");
      Rating.SETRANGE("Rating Profile Quest. Code","Profile Questionnaire Code");

      ProfileQuestnLine.GET("Profile Questionnaire Code","Line No.");
      ProfileQuestnLine.GET("Profile Questionnaire Code",ProfileQuestnLine.FindQuestionLine);

      ProfileQuestnLine2 := ProfileQuestnLine;
      ProfileQuestnLine2.SETRANGE(Type,ProfileQuestnLine2.Type::Question);
      ProfileQuestnLine2.SETRANGE("Profile Questionnaire Code",ProfileQuestnLine2."Profile Questionnaire Code");
      IF ProfileQuestnLine2.NEXT <> 0 THEN
        Rating.SETRANGE("Rating Profile Quest. Line No.",ProfileQuestnLine."Line No.",ProfileQuestnLine2."Line No.")
      ELSE
        Rating.SETFILTER("Rating Profile Quest. Line No.",'%1..',ProfileQuestnLine."Line No.");

      EXIT(Rating.FINDFIRST);
    END;

    BEGIN
    END.
  }
}

