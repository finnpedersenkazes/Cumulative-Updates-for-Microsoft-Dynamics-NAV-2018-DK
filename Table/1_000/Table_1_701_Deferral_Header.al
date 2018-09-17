OBJECT Table 1701 Deferral Header
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    DataCaptionFields=Schedule Description;
    OnDelete=VAR
               DeferralLine@1000 : Record 1702;
             BEGIN
               // If the user deletes the header, all associated lines should also be deleted
               DeferralUtilities.FilterDeferralLines(
                 DeferralLine,"Deferral Doc. Type","Gen. Jnl. Template Name","Gen. Jnl. Batch Name",
                 "Document Type","Document No.","Line No.");
               DeferralLine.DELETEALL;
             END;

    CaptionML=[DAN=Periodiseringsoverskrift;
               ENU=Deferral Header];
  }
  FIELDS
  {
    { 1   ;   ;Deferral Doc. Type  ;Option        ;CaptionML=[DAN=Periodiseringsdok.type;
                                                              ENU=Deferral Doc. Type];
                                                   OptionCaptionML=[DAN=K›b,Salg,Finans;
                                                                    ENU=Purchase,Sales,G/L];
                                                   OptionString=Purchase,Sales,G/L }
    { 2   ;   ;Gen. Jnl. Template Name;Code10     ;CaptionML=[DAN=Finanskladdetype;
                                                              ENU=Gen. Jnl. Template Name] }
    { 3   ;   ;Gen. Jnl. Batch Name;Code10        ;CaptionML=[DAN=Finanskladdenavn;
                                                              ENU=Gen. Jnl. Batch Name] }
    { 4   ;   ;Document Type       ;Integer       ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type] }
    { 5   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 6   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 7   ;   ;Deferral Code       ;Code10        ;CaptionML=[DAN=Periodiseringskode;
                                                              ENU=Deferral Code];
                                                   NotBlank=Yes }
    { 8   ;   ;Amount to Defer     ;Decimal       ;OnValidate=BEGIN
                                                                IF "Initial Amount to Defer" < 0 THEN BEGIN// Negative amount
                                                                  IF "Amount to Defer" < "Initial Amount to Defer" THEN
                                                                    ERROR(AmountToDeferErr);
                                                                  IF "Amount to Defer" > 0 THEN
                                                                    ERROR(AmountToDeferErr)
                                                                END;

                                                                IF "Initial Amount to Defer" >= 0 THEN BEGIN// Positive amount
                                                                  IF "Amount to Defer" > "Initial Amount to Defer" THEN
                                                                    ERROR(AmountToDeferErr);
                                                                  IF "Amount to Defer" < 0 THEN
                                                                    ERROR(AmountToDeferErr);
                                                                END;

                                                                IF "Amount to Defer" = 0 THEN
                                                                  ERROR(ZeroAmountToDeferErr);
                                                              END;

                                                   CaptionML=[DAN=Bel›b, der skal periodiseres;
                                                              ENU=Amount to Defer];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 9   ;   ;Amount to Defer (LCY);Decimal      ;CaptionML=[DAN=Bel›b, der skal periodiseres (RV);
                                                              ENU=Amount to Defer (LCY)];
                                                   AutoFormatType=1 }
    { 10  ;   ;Calc. Method        ;Option        ;CaptionML=[DAN=Beregningsmetode;
                                                              ENU=Calc. Method];
                                                   OptionCaptionML=[DAN=Line‘r,Lig med pr. periode,Dage pr. periode,Brugerdefineret;
                                                                    ENU=Straight-Line,Equal per Period,Days per Period,User-Defined];
                                                   OptionString=Straight-Line,Equal per Period,Days per Period,User-Defined }
    { 11  ;   ;Start Date          ;Date          ;OnValidate=VAR
                                                                AccountingPeriod@1000 : Record 50;
                                                              BEGIN
                                                                IF GenJnlCheckLine.DateNotAllowed("Start Date") THEN
                                                                  ERROR(InvalidPostingDateErr,"Start Date");

                                                                AccountingPeriod.SETFILTER("Starting Date",'>=%1',"Start Date");
                                                                IF AccountingPeriod.ISEMPTY THEN
                                                                  ERROR(DeferSchedOutOfBoundsErr);
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Start Date] }
    { 12  ;   ;No. of Periods      ;Integer       ;OnValidate=BEGIN
                                                                IF "No. of Periods" < 1 THEN
                                                                  ERROR(NumberofPeriodsErr);
                                                              END;

                                                   CaptionML=[DAN=Antal perioder;
                                                              ENU=No. of Periods];
                                                   NotBlank=Yes;
                                                   BlankZero=Yes }
    { 13  ;   ;Schedule Description;Text50        ;CaptionML=[DAN=Planbeskrivelse;
                                                              ENU=Schedule Description] }
    { 14  ;   ;Initial Amount to Defer;Decimal    ;CaptionML=[DAN=Startbel›b, der skal periodiseres;
                                                              ENU=Initial Amount to Defer] }
    { 15  ;   ;Currency Code       ;Code10        ;TableRelation=Currency.Code;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 20  ;   ;Schedule Line Total ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Deferral Line".Amount WHERE (Deferral Doc. Type=FIELD(Deferral Doc. Type),
                                                                                                 Gen. Jnl. Template Name=FIELD(Gen. Jnl. Template Name),
                                                                                                 Gen. Jnl. Batch Name=FIELD(Gen. Jnl. Batch Name),
                                                                                                 Document Type=FIELD(Document Type),
                                                                                                 Document No.=FIELD(Document No.),
                                                                                                 Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Budgetlinjetotal;
                                                              ENU=Schedule Line Total] }
  }
  KEYS
  {
    {    ;Deferral Doc. Type,Gen. Jnl. Template Name,Gen. Jnl. Batch Name,Document Type,Document No.,Line No.;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      AmountToDeferErr@1000 : TextConst 'DAN=Det periodiserede bel›b m† ikke v‘re st›rre end dokumentlinjebel›bet.;ENU=The deferred amount cannot be greater than the document line amount.';
      GenJnlCheckLine@1001 : Codeunit 11;
      InvalidPostingDateErr@1004 : TextConst '@@@="%1=The date passed in for the posting date.";DAN=%1 er ikke inden for intervallet af bogf›ringsdatoer for regnskabet.;ENU=%1 is not within the range of posting dates for your company.';
      DeferSchedOutOfBoundsErr@1003 : TextConst 'DAN=Periodiseringsplanen falder uden for de regnskabsperioder, der er oprettet for virksomheden.;ENU=The deferral schedule falls outside the accounting periods that have been set up for the company.';
      SelectionMsg@1005 : TextConst 'DAN=Du skal angive en Periodiseringskode for denne linje, f›r du kan f† vist Periodiseringsplanen.;ENU=You must specify a deferral code for this line before you can view the deferral schedule.';
      DeferralUtilities@1006 : Codeunit 1720;
      NumberofPeriodsErr@1007 : TextConst 'DAN=Du skal angive ‚n eller flere perioder.;ENU=You must specify one or more periods.';
      ZeroAmountToDeferErr@1008 : TextConst 'DAN=Bel›bet, der skal periodiseres, m† ikke v‘re 0.;ENU=The Amount to Defer cannot be 0.';

    [External]
    PROCEDURE CalculateSchedule@1() : Boolean;
    VAR
      DeferralDescription@1000 : Text[50];
    BEGIN
      IF "Deferral Code" = '' THEN BEGIN
        MESSAGE(SelectionMsg);
        EXIT(FALSE);
      END;
      DeferralDescription := "Schedule Description";
      DeferralUtilities.CreateDeferralSchedule("Deferral Code","Deferral Doc. Type","Gen. Jnl. Template Name",
        "Gen. Jnl. Batch Name","Document Type","Document No.","Line No.","Amount to Defer",
        "Calc. Method","Start Date","No. of Periods",FALSE,DeferralDescription,FALSE,"Currency Code");
      EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

