OBJECT Table 1252 Bank Pmt. Appl. Rule
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               VALIDATE(Priority);
               UpdateScore(Rec);
             END;

    OnRename=BEGIN
               UpdateScore(Rec);
             END;

    CaptionML=[DAN=Regel for bankbetalingsudligning;
               ENU=Bank Pmt. Appl. Rule];
  }
  FIELDS
  {
    { 1   ;   ;Match Confidence    ;Option        ;CaptionML=[DAN=Matchtillid;
                                                              ENU=Match Confidence];
                                                   OptionCaptionML=[DAN=Ingen,Lav,Medium,H�j;
                                                                    ENU=None,Low,Medium,High];
                                                   OptionString=None,Low,Medium,High }
    { 2   ;   ;Priority            ;Integer       ;OnValidate=BEGIN
                                                                IF (Priority > GetMaximumPriorityNo) OR (Priority < 1) THEN
                                                                  ERROR(WrongPriorityNoErr,FIELDCAPTION(Priority),1,GetMaximumPriorityNo);
                                                              END;

                                                   CaptionML=[DAN=Prioritet;
                                                              ENU=Priority] }
    { 3   ;   ;Related Party Matched;Option       ;CaptionML=[DAN=Relateret part er matchet;
                                                              ENU=Related Party Matched];
                                                   OptionCaptionML=[DAN=Ikke medregnet,Helt,Delvist,Nej;
                                                                    ENU=Not Considered,Fully,Partially,No];
                                                   OptionString=Not Considered,Fully,Partially,No }
    { 4   ;   ;Doc. No./Ext. Doc. No. Matched;Option;
                                                   CaptionML=[DAN=Bilagsnr./Eksternt bilagsnr. er matchet;
                                                              ENU=Doc. No./Ext. Doc. No. Matched];
                                                   OptionCaptionML=[DAN=Ikke medregnet,Ja,Nej,Ja - flere;
                                                                    ENU=Not Considered,Yes,No,Yes - Multiple];
                                                   OptionString=Not Considered,Yes,No,Yes - Multiple }
    { 5   ;   ;Amount Incl. Tolerance Matched;Option;
                                                   CaptionML=[DAN=Matchende bel�b inkl. tolerance;
                                                              ENU=Amount Incl. Tolerance Matched];
                                                   OptionCaptionML=[DAN=Ikke medregnet,Et match,Flere matchinger,Ingen matchinger;
                                                                    ENU=Not Considered,One Match,Multiple Matches,No Matches];
                                                   OptionString=Not Considered,One Match,Multiple Matches,No Matches }
    { 30  ;   ;Score               ;Integer       ;CaptionML=[DAN=Score;
                                                              ENU=Score];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Match Confidence,Priority               ;Clustered=Yes }
    {    ;Score                                    }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      WrongPriorityNoErr@1000 : TextConst '@@@=%1 - Table field with caption Priority. %2 and %3 are numbers presenting a range - e.g. 1 and 999;DAN=%1, som du har angivet, er ugyldig. %1 skal v�re mellem %2 og %3.;ENU=The %1 you entered is invalid. The %1 must be between %2 and %3.';
      LoadRulesOnlyOnTempRecordsErr@1001 : TextConst '@@@=Description to developers, should not be seen by users;DAN=Programmeringsfejl: Funktionen LoadRules kan kun kaldes fra midlertidige records.;ENU=Programming error: The LoadRules function can only be called from temporary records.';

    [External]
    PROCEDURE LoadRules@4();
    VAR
      BankPmtApplRule@1001 : Record 1252;
    BEGIN
      IF NOT ISTEMPORARY THEN
        ERROR(LoadRulesOnlyOnTempRecordsErr);

      DELETEALL;
      IF BankPmtApplRule.FINDSET THEN
        REPEAT
          TRANSFERFIELDS(BankPmtApplRule);
          INSERT;
        UNTIL BankPmtApplRule.NEXT = 0;
    END;

    [External]
    PROCEDURE GetBestMatchScore@5(ParameterBankPmtApplRule@1000 : Record 1252) : Integer;
    BEGIN
      CLEAR(Rec);
      SETCURRENTKEY(Score);
      ASCENDING(FALSE);

      SETFILTER("Related Party Matched",'%1|%2',
        ParameterBankPmtApplRule."Related Party Matched",
        ParameterBankPmtApplRule."Related Party Matched"::"Not Considered");

      SETFILTER("Doc. No./Ext. Doc. No. Matched",'%1|%2',
        ParameterBankPmtApplRule."Doc. No./Ext. Doc. No. Matched",
        ParameterBankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::"Not Considered");

      SETFILTER("Amount Incl. Tolerance Matched",'%1|%2',
        ParameterBankPmtApplRule."Amount Incl. Tolerance Matched",
        ParameterBankPmtApplRule."Amount Incl. Tolerance Matched"::"Not Considered");

      IF FINDFIRST THEN
        EXIT(Score);

      EXIT(0);
    END;

    [External]
    PROCEDURE GetTextMapperScore@8() : Integer;
    VAR
      MediumConfidenceHighestScore@1001 : Integer;
    BEGIN
      // Text mapper should override only Medium confidence and lower
      MediumConfidenceHighestScore := CalculateScore("Match Confidence"::Medium,0);
      EXIT(MediumConfidenceHighestScore);
    END;

    LOCAL PROCEDURE UpdateScore@3(VAR BankPmtApplRule@1000 : Record 1252);
    BEGIN
      BankPmtApplRule.Score := CalculateScore(BankPmtApplRule."Match Confidence",BankPmtApplRule.Priority);
    END;

    LOCAL PROCEDURE CalculateScore@9(MatchConfidence@1000 : Option;NewPriority@1002 : Integer) : Integer;
    VAR
      ConfidenceRangeScore@1001 : Integer;
    BEGIN
      ConfidenceRangeScore := (MatchConfidence + 1 ) * GetConfidenceScoreRange;

      // Update the score based on priority
      EXIT(ConfidenceRangeScore - NewPriority);
    END;

    LOCAL PROCEDURE GetConfidenceScoreRange@2() : Integer;
    BEGIN
      EXIT(1000);
    END;

    LOCAL PROCEDURE GetMaximumPriorityNo@6() : Integer;
    BEGIN
      EXIT(GetConfidenceScoreRange - 1);
    END;

    [External]
    PROCEDURE GetMatchConfidence@7(MatchQuality@1002 : Integer) : Integer;
    VAR
      BankAccReconciliationLine@1000 : Record 274;
      OptionNo@1001 : Integer;
    BEGIN
      IF MatchQuality = GetTextMapperScore THEN
        EXIT(BankAccReconciliationLine."Match Confidence"::"High - Text-to-Account Mapping");

      OptionNo := MatchQuality DIV GetConfidenceScoreRange;
      CASE OptionNo OF
        "Match Confidence"::None:
          EXIT(BankAccReconciliationLine."Match Confidence"::None);
        "Match Confidence"::Low:
          EXIT(BankAccReconciliationLine."Match Confidence"::Low);
        "Match Confidence"::Medium:
          EXIT(BankAccReconciliationLine."Match Confidence"::Medium);
        "Match Confidence"::High:
          EXIT(BankAccReconciliationLine."Match Confidence"::High);
      END;
    END;

    [External]
    PROCEDURE GetLowestScoreInRange@10(AssignedScore@1000 : Integer) : Integer;
    BEGIN
      EXIT((AssignedScore DIV GetConfidenceScoreRange) * GetConfidenceScoreRange);
    END;

    [External]
    PROCEDURE GetHighestScoreInRange@11(AssignedScore@1000 : Integer) : Integer;
    BEGIN
      EXIT(GetLowestScoreInRange(AssignedScore) + GetConfidenceScoreRange);
    END;

    [External]
    PROCEDURE GetHighestPossibleScore@1() : Integer;
    BEGIN
      EXIT(GetConfidenceScoreRange * ("Match Confidence"::High + 1));
    END;

    [External]
    PROCEDURE InsertDefaultMatchingRules@23();
    VAR
      BankPmtApplRule@1000 : Record 1252;
      RulePriority@1001 : Integer;
    BEGIN
      IF NOT BankPmtApplRule.ISEMPTY THEN
        EXIT;

      // Insert High Confidence rules
      RulePriority := 1;
      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::High,RulePriority,
        BankPmtApplRule."Related Party Matched"::Fully,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::"Yes - Multiple",
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"One Match");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::High,RulePriority,
        BankPmtApplRule."Related Party Matched"::Fully,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::"Yes - Multiple",
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Multiple Matches");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::High,RulePriority,
        BankPmtApplRule."Related Party Matched"::Fully,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::Yes,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"One Match");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::High,RulePriority,
        BankPmtApplRule."Related Party Matched"::Fully,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::Yes,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Multiple Matches");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::High,RulePriority,
        BankPmtApplRule."Related Party Matched"::Partially,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::"Yes - Multiple",
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"One Match");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::High,RulePriority,
        BankPmtApplRule."Related Party Matched"::Partially,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::"Yes - Multiple",
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Multiple Matches");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::High,RulePriority,
        BankPmtApplRule."Related Party Matched"::Partially,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::Yes,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"One Match");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::High,RulePriority,
        BankPmtApplRule."Related Party Matched"::Fully,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::No,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"One Match");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::High,RulePriority,
        BankPmtApplRule."Related Party Matched"::No,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::"Yes - Multiple",
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"One Match");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::High,RulePriority,
        BankPmtApplRule."Related Party Matched"::No,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::"Yes - Multiple",
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Multiple Matches");

      // Insert Medium Confidence rules
      RulePriority := 1;
      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Medium,RulePriority,
        BankPmtApplRule."Related Party Matched"::Fully,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::"Yes - Multiple",
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Not Considered");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Medium,RulePriority,
        BankPmtApplRule."Related Party Matched"::Fully,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::Yes,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Not Considered");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Medium,RulePriority,
        BankPmtApplRule."Related Party Matched"::Fully,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::No,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Multiple Matches");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Medium,RulePriority,
        BankPmtApplRule."Related Party Matched"::Partially,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::"Yes - Multiple",
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Not Considered");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Medium,RulePriority,
        BankPmtApplRule."Related Party Matched"::Partially,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::Yes,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Not Considered");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Medium,RulePriority,
        BankPmtApplRule."Related Party Matched"::No,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::Yes,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"One Match");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Medium,RulePriority,
        BankPmtApplRule."Related Party Matched"::No,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::"Yes - Multiple",
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Not Considered");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Medium,RulePriority,
        BankPmtApplRule."Related Party Matched"::Partially,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::No,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"One Match");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Medium,RulePriority,
        BankPmtApplRule."Related Party Matched"::No,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::Yes,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Not Considered");

      // Insert Low Confidence rules
      RulePriority := 1;
      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Low,RulePriority,
        BankPmtApplRule."Related Party Matched"::Fully,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::No,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"No Matches");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Low,RulePriority,
        BankPmtApplRule."Related Party Matched"::Partially,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::No,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Multiple Matches");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Low,RulePriority,
        BankPmtApplRule."Related Party Matched"::Partially,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::No,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"No Matches");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Low,RulePriority,
        BankPmtApplRule."Related Party Matched"::No,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::No,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"One Match");

      InsertBankPaymentApplicationRule(
        BankPmtApplRule."Match Confidence"::Low,RulePriority,
        BankPmtApplRule."Related Party Matched"::No,
        BankPmtApplRule."Doc. No./Ext. Doc. No. Matched"::No,
        BankPmtApplRule."Amount Incl. Tolerance Matched"::"Multiple Matches");
    END;

    LOCAL PROCEDURE InsertBankPaymentApplicationRule@22(MatchConfidence@1001 : Option;VAR RulePriority@1002 : Integer;RelatedPartyIdentification@1003 : Option;DocumentMatch@1004 : Option;AmountMatch@1005 : Option);
    VAR
      BankPmtApplRule@1000 : Record 1252;
    BEGIN
      BankPmtApplRule.INIT;
      BankPmtApplRule."Match Confidence" := MatchConfidence;
      BankPmtApplRule.Priority := RulePriority;
      BankPmtApplRule."Related Party Matched" := RelatedPartyIdentification;
      BankPmtApplRule."Doc. No./Ext. Doc. No. Matched" := DocumentMatch;
      BankPmtApplRule."Amount Incl. Tolerance Matched" := AmountMatch;
      BankPmtApplRule.INSERT(TRUE);
      RulePriority += 1;
    END;

    BEGIN
    END.
  }
}

