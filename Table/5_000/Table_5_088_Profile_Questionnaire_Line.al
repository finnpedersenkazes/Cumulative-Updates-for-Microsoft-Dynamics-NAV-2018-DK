OBJECT Table 5088 Profile Questionnaire Line
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    DataCaptionFields=Profile Questionnaire Code,Description;
    OnDelete=VAR
               Rating@1000 : Record 5111;
               ProfileQuestionnaireLine@1001 : Record 5088;
             BEGIN
               CALCFIELDS("No. of Contacts");
               TESTFIELD("No. of Contacts",0);

               Rating.SETRANGE("Rating Profile Quest. Code","Profile Questionnaire Code");
               Rating.SETRANGE("Rating Profile Quest. Line No.","Line No.");
               IF NOT Rating.ISEMPTY THEN
                 ERROR(Text002);

               Rating.RESET;
               Rating.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
               Rating.SETRANGE("Profile Questionnaire Line No.","Line No.");
               IF NOT Rating.ISEMPTY THEN
                 ERROR(Text003);

               IF Type = Type::Question THEN BEGIN
                 ProfileQuestionnaireLine.GET("Profile Questionnaire Code","Line No.");
                 IF (ProfileQuestionnaireLine.NEXT <> 0) AND
                    (ProfileQuestionnaireLine.Type = ProfileQuestnLine.Type::Answer)
                 THEN
                   ERROR(Text004);
               END;
             END;

    CaptionML=[DAN=Profilsp�rgeskemalinje;
               ENU=Profile Questionnaire Line];
    LookupPageID=Page5149;
  }
  FIELDS
  {
    { 1   ;   ;Profile Questionnaire Code;Code20  ;TableRelation="Profile Questionnaire Header";
                                                   CaptionML=[DAN=Profilsp�rgeskemakode;
                                                              ENU=Profile Questionnaire Code] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                CASE Type OF
                                                                  Type::Question:
                                                                    BEGIN
                                                                      CALCFIELDS("No. of Contacts");
                                                                      TESTFIELD("No. of Contacts",0);
                                                                      TESTFIELD("From Value",0);
                                                                      TESTFIELD("To Value",0);
                                                                    END;
                                                                  Type::Answer:
                                                                    BEGIN
                                                                      TESTFIELD("Multiple Answers",FALSE);
                                                                      TESTFIELD("Auto Contact Classification",FALSE);
                                                                      TESTFIELD("Customer Class. Field",0);
                                                                      TESTFIELD("Vendor Class. Field",0);
                                                                      TESTFIELD("Contact Class. Field",0);
                                                                      TESTFIELD("Starting Date Formula",ZeroDateFormula);
                                                                      TESTFIELD("Ending Date Formula",ZeroDateFormula);
                                                                      TESTFIELD("Classification Method",0);
                                                                      TESTFIELD("Sorting Method",0);
                                                                      TESTFIELD("No. of Decimals",0);
                                                                    END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Sp�rgsm�l,Svar;
                                                                    ENU=Question,Answer];
                                                   OptionString=Question,Answer }
    { 4   ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   NotBlank=Yes }
    { 5   ;   ;Multiple Answers    ;Boolean       ;OnValidate=BEGIN
                                                                IF "Multiple Answers" THEN
                                                                  TESTFIELD(Type,Type::Question);
                                                              END;

                                                   CaptionML=[DAN=Flere svarmuligheder;
                                                              ENU=Multiple Answers] }
    { 6   ;   ;Auto Contact Classification;Boolean;OnValidate=BEGIN
                                                                IF "Auto Contact Classification" THEN
                                                                  TESTFIELD(Type,Type::Question)
                                                                ELSE BEGIN
                                                                  TESTFIELD("Customer Class. Field","Customer Class. Field"::" ");
                                                                  TESTFIELD("Vendor Class. Field","Vendor Class. Field"::" ");
                                                                  TESTFIELD("Contact Class. Field","Contact Class. Field"::" ");
                                                                  TESTFIELD("Starting Date Formula",ZeroDateFormula);
                                                                  TESTFIELD("Ending Date Formula",ZeroDateFormula);
                                                                  TESTFIELD("Classification Method","Classification Method"::" ");
                                                                  TESTFIELD("Sorting Method","Sorting Method"::" ");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Automatisk klassificering;
                                                              ENU=Auto Contact Classification] }
    { 7   ;   ;Customer Class. Field;Option       ;OnValidate=BEGIN
                                                                IF "Customer Class. Field" <> "Customer Class. Field"::" " THEN BEGIN
                                                                  TESTFIELD(Type,Type::Question);
                                                                  CLEAR("Vendor Class. Field");
                                                                  CLEAR("Contact Class. Field");
                                                                  IF "Classification Method" = "Classification Method"::" " THEN
                                                                    "Classification Method" := "Classification Method"::"Defined Value";
                                                                END ELSE
                                                                  ResetFields;
                                                              END;

                                                   CaptionML=[DAN=Debitorklassefelt;
                                                              ENU=Customer Class. Field];
                                                   OptionCaptionML=[DAN=" ,Salg (RV),Avancebel�b (RV),Salgsfrekvens (fakturaer pr. �r),Gnsn. fakturabel�b (RV),Rabatpct.,Gnsn. forsinkelse (dage)";
                                                                    ENU=" ,Sales (LCY),Profit (LCY),Sales Frequency (Invoices/Year),Avg. Invoice Amount (LCY),Discount (%),Avg. Overdue (Day)"];
                                                   OptionString=[ ,Sales (LCY),Profit (LCY),Sales Frequency (Invoices/Year),Avg. Invoice Amount (LCY),Discount (%),Avg. Overdue (Day)] }
    { 8   ;   ;Vendor Class. Field ;Option        ;OnValidate=BEGIN
                                                                IF "Vendor Class. Field" <> "Vendor Class. Field"::" " THEN BEGIN
                                                                  TESTFIELD(Type,Type::Question);
                                                                  CLEAR("Customer Class. Field");
                                                                  CLEAR("Contact Class. Field");
                                                                  IF "Classification Method" = "Classification Method"::" " THEN
                                                                    "Classification Method" := "Classification Method"::"Defined Value";
                                                                END ELSE
                                                                  ResetFields;
                                                              END;

                                                   CaptionML=[DAN=Kreditorklassefelt;
                                                              ENU=Vendor Class. Field];
                                                   OptionCaptionML=[DAN=" ,K�b (RV),K�bsfrekvens (fakturaer pr. �r),Gnsn. ordrestr. (RV),Rabatpct.,Gnsn. forsinkelse (dage)";
                                                                    ENU=" ,Purchase (LCY),Purchase Frequency (Invoices/Year),Avg. Ticket Size (LCY),Discount (%),Avg. Overdue (Day)"];
                                                   OptionString=[ ,Purchase (LCY),Purchase Frequency (Invoices/Year),Avg. Ticket Size (LCY),Discount (%),Avg. Overdue (Day)] }
    { 9   ;   ;Contact Class. Field;Option        ;OnValidate=VAR
                                                                Rating@1000 : Record 5111;
                                                              BEGIN
                                                                IF xRec."Contact Class. Field" = "Contact Class. Field"::Rating THEN BEGIN
                                                                  Rating.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
                                                                  Rating.SETRANGE("Profile Questionnaire Line No.","Line No.");
                                                                  IF Rating.FINDFIRST THEN
                                                                    IF CONFIRM(Text000,FALSE) THEN
                                                                      Rating.DELETEALL
                                                                    ELSE
                                                                      ERROR(Text001,FIELDCAPTION("Contact Class. Field"));
                                                                END;

                                                                IF "Contact Class. Field" <> "Contact Class. Field"::" " THEN BEGIN
                                                                  TESTFIELD(Type,Type::Question);
                                                                  CLEAR("Customer Class. Field");
                                                                  CLEAR("Vendor Class. Field");
                                                                  IF ("Classification Method" = "Classification Method"::" ") OR
                                                                     ("Contact Class. Field" = "Contact Class. Field"::Rating)
                                                                  THEN BEGIN
                                                                    "Classification Method" := "Classification Method"::"Defined Value";
                                                                    "Sorting Method" := "Sorting Method"::" ";
                                                                  END;
                                                                  IF "Contact Class. Field" = "Contact Class. Field"::Rating THEN BEGIN
                                                                    CLEAR("Starting Date Formula");
                                                                    CLEAR("Ending Date Formula");
                                                                  END;
                                                                END ELSE
                                                                  ResetFields;
                                                              END;

                                                   CaptionML=[DAN=Kontaktklassefelt;
                                                              ENU=Contact Class. Field];
                                                   OptionCaptionML=[DAN=" ,Interaktionsm�ngde,Interakt.frekvens (antal pr. �r),Gnsn. interakt.kostpris (RV),Gnsn. interakt.varighed (min.),Vundet salgsmulighed (%),Vurdering";
                                                                    ENU=" ,Interaction Quantity,Interaction Frequency (No./Year),Avg. Interaction Cost (LCY),Avg. Interaction Duration (Min.),Opportunity Won (%),Rating"];
                                                   OptionString=[ ,Interaction Quantity,Interaction Frequency (No./Year),Avg. Interaction Cost (LCY),Avg. Interaction Duration (Min.),Opportunity Won (%),Rating] }
    { 10  ;   ;Starting Date Formula;DateFormula  ;OnValidate=BEGIN
                                                                IF FORMAT("Starting Date Formula") <> '' THEN
                                                                  TESTFIELD(Type,Type::Question);
                                                              END;

                                                   CaptionML=[DAN=Startdatoformel;
                                                              ENU=Starting Date Formula] }
    { 11  ;   ;Ending Date Formula ;DateFormula   ;OnValidate=BEGIN
                                                                IF FORMAT("Ending Date Formula") <> '' THEN
                                                                  TESTFIELD(Type,Type::Question);
                                                              END;

                                                   CaptionML=[DAN=Slutdatoformel;
                                                              ENU=Ending Date Formula] }
    { 12  ;   ;Classification Method;Option       ;OnValidate=BEGIN
                                                                IF "Classification Method" <> "Classification Method"::" " THEN BEGIN
                                                                  TESTFIELD(Type,Type::Question);
                                                                  IF "Classification Method" <> "Classification Method"::"Defined Value" THEN
                                                                    "Sorting Method" := ProfileQuestnLine."Sorting Method"::Descending
                                                                  ELSE
                                                                    "Sorting Method" := ProfileQuestnLine."Sorting Method"::" ";
                                                                END ELSE
                                                                  "Sorting Method" := ProfileQuestnLine."Sorting Method"::" ";
                                                              END;

                                                   CaptionML=[DAN=Klassificeringsmetode;
                                                              ENU=Classification Method];
                                                   OptionCaptionML=[DAN=" ,Defineret v�rdi,Procent af v�rdi,Procent af kontakter";
                                                                    ENU=" ,Defined Value,Percentage of Value,Percentage of Contacts"];
                                                   OptionString=[ ,Defined Value,Percentage of Value,Percentage of Contacts] }
    { 13  ;   ;Sorting Method      ;Option        ;OnValidate=BEGIN
                                                                IF "Sorting Method" <> "Sorting Method"::" " THEN
                                                                  TESTFIELD(Type,Type::Question);
                                                              END;

                                                   CaptionML=[DAN=Sorteringsmetode;
                                                              ENU=Sorting Method];
                                                   OptionCaptionML=[DAN=" ,Faldende,Stigende";
                                                                    ENU=" ,Descending,Ascending"];
                                                   OptionString=[ ,Descending,Ascending] }
    { 14  ;   ;From Value          ;Decimal       ;OnValidate=BEGIN
                                                                IF "From Value" <> 0 THEN
                                                                  TESTFIELD(Type,Type::Answer);
                                                              END;

                                                   CaptionML=[DAN=Fra v�rdi;
                                                              ENU=From Value];
                                                   DecimalPlaces=0:25;
                                                   BlankZero=Yes }
    { 15  ;   ;To Value            ;Decimal       ;OnValidate=BEGIN
                                                                IF "To Value" <> 0 THEN
                                                                  TESTFIELD(Type,Type::Answer);
                                                              END;

                                                   CaptionML=[DAN=Til v�rdi;
                                                              ENU=To Value];
                                                   DecimalPlaces=0:25;
                                                   BlankZero=Yes }
    { 16  ;   ;No. of Contacts     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Contact Profile Answer" WHERE (Profile Questionnaire Code=FIELD(Profile Questionnaire Code),
                                                                                                     Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Antal kontakter;
                                                              ENU=No. of Contacts];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 17  ;   ;Priority            ;Option        ;InitValue=Normal;
                                                   OnValidate=VAR
                                                                ContProfileAnswer@1000 : Record 5089;
                                                              BEGIN
                                                                TESTFIELD(Type,Type::Answer);
                                                                ContProfileAnswer.SETCURRENTKEY("Profile Questionnaire Code","Line No.");
                                                                ContProfileAnswer.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
                                                                ContProfileAnswer.SETRANGE("Line No.","Line No.");
                                                                ContProfileAnswer.MODIFYALL("Answer Priority",Priority);
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Prioritet;
                                                              ENU=Priority];
                                                   OptionCaptionML=[DAN=Meget lav (skjult),Lav,Normal,H�j,Meget h�j;
                                                                    ENU=Very Low (Hidden),Low,Normal,High,Very High];
                                                   OptionString=Very Low (Hidden),Low,Normal,High,Very High }
    { 18  ;   ;No. of Decimals     ;Integer       ;OnValidate=BEGIN
                                                                IF "No. of Decimals" <> 0 THEN
                                                                  TESTFIELD(Type,Type::Question);
                                                              END;

                                                   CaptionML=[DAN=Antal decimaler;
                                                              ENU=No. of Decimals];
                                                   MinValue=-25;
                                                   MaxValue=25 }
    { 19  ;   ;Min. % Questions Answered;Decimal  ;OnValidate=BEGIN
                                                                IF "Min. % Questions Answered" <> 0 THEN BEGIN
                                                                  TESTFIELD(Type,Type::Question);
                                                                  TESTFIELD("Contact Class. Field","Contact Class. Field"::Rating);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Min. besvarelsespct.;
                                                              ENU=Min. % Questions Answered];
                                                   DecimalPlaces=0:0;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 9501;   ;Wizard Step         ;Option        ;CaptionML=[DAN=Trin i guiden;
                                                              ENU=Wizard Step];
                                                   OptionCaptionML=[DAN=" ,1,2,3,4,5,6";
                                                                    ENU=" ,1,2,3,4,5,6"];
                                                   OptionString=[ ,1,2,3,4,5,6];
                                                   Editable=No }
    { 9502;   ;Interval Option     ;Option        ;CaptionML=[DAN=Intervalfunktion;
                                                              ENU=Interval Option];
                                                   OptionCaptionML=[DAN=Minimum,Maksimum,Interval;
                                                                    ENU=Minimum,Maximum,Interval];
                                                   OptionString=Minimum,Maximum,Interval }
    { 9503;   ;Answer Option       ;Option        ;CaptionML=[DAN=Svarindstilling;
                                                              ENU=Answer Option];
                                                   OptionCaptionML=[DAN=H�jLav,ABC,Brugerdefineret;
                                                                    ENU=HighLow,ABC,Custom];
                                                   OptionString=HighLow,ABC,Custom }
    { 9504;   ;Answer Description  ;Text250       ;CaptionML=[DAN=Beskrivelse af svar;
                                                              ENU=Answer Description] }
    { 9505;   ;Wizard From Value   ;Decimal       ;OnValidate=BEGIN
                                                                IF "From Value" <> 0 THEN
                                                                  TESTFIELD(Type,Type::Answer);
                                                              END;

                                                   CaptionML=[DAN=Fra-v�rdi i guiden;
                                                              ENU=Wizard From Value];
                                                   DecimalPlaces=0:25;
                                                   BlankZero=Yes }
    { 9506;   ;Wizard To Value     ;Decimal       ;OnValidate=BEGIN
                                                                IF "To Value" <> 0 THEN
                                                                  TESTFIELD(Type,Type::Answer);
                                                              END;

                                                   CaptionML=[DAN=Til-v�rdi i guiden;
                                                              ENU=Wizard To Value];
                                                   DecimalPlaces=0:25;
                                                   BlankZero=Yes }
    { 9707;   ;Wizard From Line No.;Integer       ;OnValidate=BEGIN
                                                                IF "To Value" <> 0 THEN
                                                                  TESTFIELD(Type,Type::Answer);
                                                              END;

                                                   CaptionML=[DAN=Fra-linjenr. i guide;
                                                              ENU=Wizard From Line No.];
                                                   BlankZero=Yes }
  }
  KEYS
  {
    {    ;Profile Questionnaire Code,Line No.     ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Type,Description,Priority,Multiple Answers,Auto Contact Classification,No. of Contacts }
  }
  CODE
  {
    VAR
      ProfileQuestnLine@1000 : Record 5088;
      TempProfileQuestionnaireLine@1007 : TEMPORARY Record 5088;
      ZeroDateFormula@1001 : DateFormula;
      Text000@1002 : TextConst 'DAN=Vil du slette vurderingsv�rdierne?;ENU=Do you want to delete the rating values?';
      Text001@1003 : TextConst 'DAN=%1 kan ikke �ndres, f�r vurderingsv�rdien er blevet slettet.;ENU=%1 cannot be changed until the rating value is deleted.';
      Text002@1004 : TextConst 'DAN=Du kan ikke slette denne linje, fordi �t eller flere sp�rgsm�l er knyttet til den.;ENU=You cannot delete this line because one or more questions are depending on it.';
      Text003@1005 : TextConst 'DAN=Du kan ikke slette denne linje, fordi der findes �n eller flere vurderingsv�rdier.;ENU=You cannot delete this line because one or more rating values exists.';
      Text004@1006 : TextConst 'DAN=Du kan ikke slette dette sp�rgsm�l, n�r der findes svar.;ENU=You cannot delete this question while answers exists.';
      Text005@1011 : TextConst 'DAN=Angiv hvilket sp�rgeskema denne vurdering skal oprettes til.;ENU=Please select for which questionnaire this rating should be created.';
      Text006@1010 : TextConst 'DAN=Beskriv vurderingen.;ENU=Please describe the rating.';
      Text007@1009 : TextConst 'DAN=Opret �t eller flere forskellige svar.;ENU=Please create one or more different answers.';
      Text008@1008 : TextConst 'DAN=Angiv hvilket pointinterval der er p�k�vet til dette svar.;ENU=Please enter which range of points this answer should require.';
      Text009@1012 : TextConst 'DAN=H�j;ENU=High';
      Text010@1013 : TextConst 'DAN=Lav;ENU=Low';
      Text011@1014 : TextConst '@@@=Selecting answer A;DAN=A;ENU=A';
      Text012@1015 : TextConst '@@@=Selecting answer B;DAN=B;ENU=B';
      Text013@1016 : TextConst '@@@=Selecting answer C;DAN=U;ENU=C';

    [External]
    PROCEDURE MoveUp@1();
    VAR
      UpperProfileQuestnLine@1000 : Record 5088;
      LineNo@1001 : Integer;
      UpperRecLineNo@1002 : Integer;
    BEGIN
      TESTFIELD(Type,Type::Answer);
      UpperProfileQuestnLine.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
      LineNo := "Line No.";
      UpperProfileQuestnLine.GET("Profile Questionnaire Code","Line No.");

      IF UpperProfileQuestnLine.FIND('<') AND
         (UpperProfileQuestnLine.Type = UpperProfileQuestnLine.Type::Answer)
      THEN BEGIN
        UpperRecLineNo := UpperProfileQuestnLine."Line No.";
        RENAME("Profile Questionnaire Code",-1);
        UpperProfileQuestnLine.RENAME("Profile Questionnaire Code",LineNo);
        RENAME("Profile Questionnaire Code",UpperRecLineNo);
      END;
    END;

    [External]
    PROCEDURE MoveDown@2();
    VAR
      LowerProfileQuestnLine@1000 : Record 5088;
      LineNo@1001 : Integer;
      LowerRecLineNo@1002 : Integer;
    BEGIN
      TESTFIELD(Type,Type::Answer);
      LowerProfileQuestnLine.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
      LineNo := "Line No.";
      LowerProfileQuestnLine.GET("Profile Questionnaire Code","Line No.");

      IF LowerProfileQuestnLine.FIND('>') AND
         (LowerProfileQuestnLine.Type = LowerProfileQuestnLine.Type::Answer)
      THEN BEGIN
        LowerRecLineNo := LowerProfileQuestnLine."Line No.";
        RENAME("Profile Questionnaire Code",-1);
        LowerProfileQuestnLine.RENAME("Profile Questionnaire Code",LineNo);
        RENAME("Profile Questionnaire Code",LowerRecLineNo);
      END;
    END;

    [External]
    PROCEDURE Question@4() : Text[250];
    BEGIN
      ProfileQuestnLine.RESET;
      ProfileQuestnLine.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
      ProfileQuestnLine.SETFILTER("Line No.",'<%1',"Line No.");
      ProfileQuestnLine.SETRANGE(Type,Type::Question);
      IF ProfileQuestnLine.FINDLAST THEN
        EXIT(ProfileQuestnLine.Description);
    END;

    [External]
    PROCEDURE FindQuestionLine@3() : Integer;
    BEGIN
      ProfileQuestnLine.RESET;
      ProfileQuestnLine.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
      ProfileQuestnLine.SETFILTER("Line No.",'<%1',"Line No.");
      ProfileQuestnLine.SETRANGE(Type,Type::Question);
      IF ProfileQuestnLine.FINDLAST THEN
        EXIT(ProfileQuestnLine."Line No.");
    END;

    LOCAL PROCEDURE ResetFields@5();
    BEGIN
      CLEAR("Starting Date Formula");
      CLEAR("Ending Date Formula");
      "Classification Method" := "Classification Method"::" ";
      "Sorting Method" := "Sorting Method"::" ";
      "No. of Decimals" := 0;
      "Min. % Questions Answered" := 0;
    END;

    [External]
    PROCEDURE CreateRatingFromProfQuestnLine@6(VAR ProfileQuestnLine@1001 : Record 5088);
    BEGIN
      INIT;
      "Profile Questionnaire Code" := ProfileQuestnLine."Profile Questionnaire Code";
      StartWizard;
    END;

    LOCAL PROCEDURE StartWizard@16();
    BEGIN
      "Wizard Step" := "Wizard Step"::"1";
      VALIDATE("Auto Contact Classification",TRUE);
      VALIDATE("Contact Class. Field","Contact Class. Field"::Rating);
      INSERT;

      ValidateAnswerOption;
      ValidateIntervalOption;

      PAGE.RUNMODAL(PAGE::"Create Rating",Rec);
    END;

    [External]
    PROCEDURE CheckStatus@9();
    BEGIN
      CASE "Wizard Step" OF
        "Wizard Step"::"1":
          BEGIN
            IF "Profile Questionnaire Code" = '' THEN
              ERROR(Text005);
            IF Description = '' THEN
              ERROR(Text006);
          END;
        "Wizard Step"::"2":
          BEGIN
            IF TempProfileQuestionnaireLine.COUNT = 0 THEN
              ERROR(Text007);
          END;
        "Wizard Step"::"3":
          IF ("Wizard From Value" = 0) AND ("Wizard To Value" = 0) THEN
            ERROR(Text008);
      END;
    END;

    [External]
    PROCEDURE PerformNextWizardStatus@8();
    BEGIN
      CASE "Wizard Step" OF
        "Wizard Step"::"1":
          "Wizard Step" := "Wizard Step" + 1;
        "Wizard Step"::"2":
          BEGIN
            "Wizard From Line No." := 0;
            "Wizard Step" := "Wizard Step" + 1;
            TempProfileQuestionnaireLine.SETRANGE("Line No.");
            TempProfileQuestionnaireLine.FIND('-');
            SetIntervalOption;
          END;
        "Wizard Step"::"3":
          BEGIN
            TempProfileQuestionnaireLine.SETFILTER("Line No.",'%1..',"Wizard From Line No.");
            TempProfileQuestionnaireLine.FIND('-');
            TempProfileQuestionnaireLine."From Value" := "Wizard From Value";
            TempProfileQuestionnaireLine."To Value" := "Wizard To Value";
            TempProfileQuestionnaireLine.MODIFY;
            IF TempProfileQuestionnaireLine.NEXT <> 0 THEN BEGIN
              TempProfileQuestionnaireLine.SETRANGE("Line No.",TempProfileQuestionnaireLine."Line No.");
              "Wizard From Line No." := TempProfileQuestionnaireLine."Line No.";
              "Wizard From Value" := TempProfileQuestionnaireLine."From Value";
              "Wizard To Value" := TempProfileQuestionnaireLine."To Value";
              SetIntervalOption;
            END ELSE BEGIN
              TempProfileQuestionnaireLine.SETRANGE("Line No.");
              TempProfileQuestionnaireLine.FIND('-');
              "Wizard Step" := "Wizard Step" + 1;
            END;
          END;
      END;
    END;

    [External]
    PROCEDURE PerformPrevWizardStatus@17();
    BEGIN
      CASE "Wizard Step" OF
        "Wizard Step"::"3":
          BEGIN
            TempProfileQuestionnaireLine.SETFILTER("Line No.",'..%1',"Wizard From Line No.");
            IF TempProfileQuestionnaireLine.FIND('+') THEN BEGIN
              TempProfileQuestionnaireLine."From Value" := "Wizard From Value";
              TempProfileQuestionnaireLine."To Value" := "Wizard To Value";
              TempProfileQuestionnaireLine.MODIFY;
            END;
            IF TempProfileQuestionnaireLine.NEXT(-1) <> 0 THEN BEGIN
              "Wizard From Line No." := TempProfileQuestionnaireLine."Line No.";
              "Wizard From Value" := TempProfileQuestionnaireLine."From Value";
              "Wizard To Value" := TempProfileQuestionnaireLine."To Value";
              SetIntervalOption
            END ELSE BEGIN
              TempProfileQuestionnaireLine.SETRANGE("Line No.");
              TempProfileQuestionnaireLine.FIND('-');
              "Wizard Step" := "Wizard Step" - 1;
            END;
          END;
        ELSE
          "Wizard Step" := "Wizard Step" - 1;
      END;
    END;

    [External]
    PROCEDURE FinishWizard@7();
    VAR
      ProfileQuestionnaireLine@1000 : Record 5088;
      ProfileMgt@1004 : Codeunit 5059;
      NextLineNo@1002 : Integer;
      QuestionLineNo@1001 : Integer;
    BEGIN
      ProfileQuestionnaireLine.SETRANGE("Profile Questionnaire Code","Profile Questionnaire Code");
      IF ProfileQuestionnaireLine.FINDLAST THEN
        QuestionLineNo := ProfileQuestionnaireLine."Line No." + 10000
      ELSE
        QuestionLineNo := 10000;

      ProfileQuestionnaireLine := Rec;
      ProfileQuestionnaireLine."Line No." := QuestionLineNo;
      ProfileQuestionnaireLine.INSERT(TRUE);

      NextLineNo := QuestionLineNo;
      TempProfileQuestionnaireLine.RESET;
      IF TempProfileQuestionnaireLine.FINDSET THEN
        REPEAT
          NextLineNo := NextLineNo + 10000;
          ProfileQuestionnaireLine := TempProfileQuestionnaireLine;
          ProfileQuestionnaireLine."Profile Questionnaire Code" := "Profile Questionnaire Code";
          ProfileQuestionnaireLine."Line No." := NextLineNo;
          ProfileQuestionnaireLine.INSERT(TRUE);
        UNTIL TempProfileQuestionnaireLine.NEXT = 0;

      COMMIT;

      ProfileQuestionnaireLine.GET("Profile Questionnaire Code",QuestionLineNo);
      ProfileMgt.ShowAnswerPoints(ProfileQuestionnaireLine);
    END;

    [External]
    PROCEDURE SetIntervalOption@10();
    BEGIN
      CASE TRUE OF
        (TempProfileQuestionnaireLine."From Value" = 0) AND (TempProfileQuestionnaireLine."To Value" <> 0):
          "Interval Option" := "Interval Option"::Maximum;
        (TempProfileQuestionnaireLine."From Value" <> 0) AND (TempProfileQuestionnaireLine."To Value" = 0):
          "Interval Option" := "Interval Option"::Minimum
        ELSE
          "Interval Option" := "Interval Option"::Interval
      END;

      ValidateIntervalOption;
    END;

    [External]
    PROCEDURE ValidateIntervalOption@14();
    BEGIN
      TempProfileQuestionnaireLine.SETFILTER("Line No.",'%1..',"Wizard From Line No.");
      TempProfileQuestionnaireLine.FIND('-');
      IF "Interval Option" = "Interval Option"::Minimum THEN
        TempProfileQuestionnaireLine."To Value" := 0;
      IF "Interval Option" = "Interval Option"::Maximum THEN
        TempProfileQuestionnaireLine."From Value" := 0;
      TempProfileQuestionnaireLine.MODIFY;
    END;

    [External]
    PROCEDURE ValidateAnswerOption@13();
    BEGIN
      IF "Answer Option" = "Answer Option"::Custom THEN
        EXIT;

      TempProfileQuestionnaireLine.DELETEALL;

      CASE "Answer Option" OF
        "Answer Option"::HighLow:
          BEGIN
            CreateAnswer(Text009);
            CreateAnswer(Text010);
          END;
        "Answer Option"::ABC:
          BEGIN
            CreateAnswer(Text011);
            CreateAnswer(Text012);
            CreateAnswer(Text013);
          END;
      END;
    END;

    LOCAL PROCEDURE CreateAnswer@15(AnswerDescription@1000 : Text[250]);
    BEGIN
      TempProfileQuestionnaireLine.INIT;
      TempProfileQuestionnaireLine."Line No." := (TempProfileQuestionnaireLine.COUNT + 1) * 10000;
      TempProfileQuestionnaireLine.Type := TempProfileQuestionnaireLine.Type::Answer;
      TempProfileQuestionnaireLine.Description := AnswerDescription;
      TempProfileQuestionnaireLine.INSERT;
    END;

    [External]
    PROCEDURE NoOfProfileAnswers@11() : Decimal;
    BEGIN
      EXIT(TempProfileQuestionnaireLine.COUNT);
    END;

    [External]
    PROCEDURE ShowAnswers@12();
    VAR
      TempProfileQuestionnaireLine2@1000 : TEMPORARY Record 5088;
    BEGIN
      IF "Answer Option" <> "Answer Option"::Custom THEN
        IF TempProfileQuestionnaireLine.FIND('-') THEN
          REPEAT
            TempProfileQuestionnaireLine2 := TempProfileQuestionnaireLine;
            TempProfileQuestionnaireLine2.INSERT;
          UNTIL TempProfileQuestionnaireLine.NEXT = 0;

      PAGE.RUNMODAL(PAGE::"Rating Answers",TempProfileQuestionnaireLine);

      IF "Answer Option" <> "Answer Option"::Custom THEN
        IF TempProfileQuestionnaireLine.COUNT <> TempProfileQuestionnaireLine2.COUNT THEN
          "Answer Option" := "Answer Option"::Custom
        ELSE BEGIN
          IF TempProfileQuestionnaireLine.FIND('-') THEN
            REPEAT
              IF NOT TempProfileQuestionnaireLine2.GET(
                   TempProfileQuestionnaireLine."Profile Questionnaire Code",TempProfileQuestionnaireLine."Line No.")
              THEN
                "Answer Option" := "Answer Option"::Custom
              ELSE
                IF TempProfileQuestionnaireLine.Description <> TempProfileQuestionnaireLine2.Description THEN
                  "Answer Option" := "Answer Option"::Custom
            UNTIL (TempProfileQuestionnaireLine.NEXT = 0) OR ("Answer Option" = "Answer Option"::Custom);
        END;
    END;

    [External]
    PROCEDURE GetProfileLineAnswerDesc@18() : Text[250];
    BEGIN
      TempProfileQuestionnaireLine.SETFILTER("Line No.",'%1..',"Wizard From Line No.");
      TempProfileQuestionnaireLine.FIND('-');
      EXIT(TempProfileQuestionnaireLine.Description);
    END;

    [External]
    PROCEDURE GetAnswers@19(VAR ProfileQuestionnaireLine@1000 : Record 5088);
    BEGIN
      TempProfileQuestionnaireLine.RESET;
      ProfileQuestionnaireLine.RESET;
      ProfileQuestionnaireLine.DELETEALL;
      IF TempProfileQuestionnaireLine.FIND('-') THEN
        REPEAT
          ProfileQuestionnaireLine.INIT;
          ProfileQuestionnaireLine := TempProfileQuestionnaireLine;
          ProfileQuestionnaireLine.INSERT;
        UNTIL TempProfileQuestionnaireLine.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

