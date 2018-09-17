OBJECT Report 5692 Calculate Depreciation
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Beregn afskrivninger;
               ENU=Calculate Depreciation];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  DeprBook.GET(DeprBookCode);
                  IF DeprUntilDate = 0D THEN
                    ERROR(Text000,FAJnlLine.FIELDCAPTION("FA Posting Date"));
                  IF PostingDate = 0D THEN
                    PostingDate := DeprUntilDate;
                  IF UseForceNoOfDays AND (DaysInPeriod = 0) THEN
                    ERROR(Text001);

                  IF DeprBook."Use Same FA+G/L Posting Dates" AND (DeprUntilDate <> PostingDate) THEN
                    ERROR(
                      Text002,
                      FAJnlLine.FIELDCAPTION("FA Posting Date"),
                      FAJnlLine.FIELDCAPTION("Posting Date"),
                      DeprBook.FIELDCAPTION("Use Same FA+G/L Posting Dates"),
                      FALSE,
                      DeprBook.TABLECAPTION,
                      DeprBook.FIELDCAPTION(Code),
                      DeprBook.Code);

                  Window.OPEN(
                    Text003 +
                    Text004 +
                    Text005);
                END;

    OnPostReport=VAR
                   PageGenJnlLine@1000 : Record 81;
                   PageFAJnlLine@1001 : Record 5621;
                 BEGIN
                   IF (FAJnlLineCreatedCount = 0) AND (GenJnlLineCreatedCount = 0) THEN BEGIN
                     MESSAGE(CompletionStatsMsg);
                     EXIT;
                   END;

                   IF FAJnlLineCreatedCount > 0 THEN
                     IF CONFIRM(CompletionStatsFAJnlQst,TRUE,FAJnlLineCreatedCount)
                     THEN BEGIN
                       PageFAJnlLine.SETRANGE("Journal Template Name",FAJnlLine."Journal Template Name");
                       PageFAJnlLine.SETRANGE("Journal Batch Name",FAJnlLine."Journal Batch Name");
                       PageFAJnlLine.FINDFIRST;
                       PAGE.RUN(PAGE::"Fixed Asset Journal",PageFAJnlLine);
                     END;

                   IF GenJnlLineCreatedCount > 0 THEN
                     IF CONFIRM(CompletionStatsGenJnlQst,TRUE,GenJnlLineCreatedCount)
                     THEN BEGIN
                       PageGenJnlLine.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
                       PageGenJnlLine.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
                       PageGenJnlLine.FINDFIRST;
                       PAGE.RUN(PAGE::"Fixed Asset G/L Journal",PageGenJnlLine);
                     END;
                 END;

  }
  DATASET
  {
    { 3794;    ;DataItem;                    ;
               DataItemTable=Table5600;
               OnAfterGetRecord=BEGIN
                                  IF Inactive OR Blocked THEN
                                    CurrReport.SKIP;

                                  CalculateDepr.Calculate(
                                    DeprAmount,Custom1Amount,NumberOfDays,Custom1NumberOfDays,
                                    "No.",DeprBookCode,DeprUntilDate,EntryAmounts,0D,DaysInPeriod);
                                  IF (DeprAmount <> 0) OR (Custom1Amount <> 0) THEN
                                    Window.UPDATE(1,"No.")
                                  ELSE
                                    Window.UPDATE(2,"No.");

                                  IF Custom1Amount <> 0 THEN
                                    IF NOT DeprBook."G/L Integration - Custom 1" OR "Budgeted Asset" THEN BEGIN
                                      FAJnlLineTmp."FA No." := "No.";
                                      FAJnlLineTmp."FA Posting Type" := FAJnlLineTmp."FA Posting Type"::"Custom 1";
                                      FAJnlLineTmp.Amount := Custom1Amount;
                                      FAJnlLineTmp."No. of Depreciation Days" := Custom1NumberOfDays;
                                      FAJnlLineTmp."FA Error Entry No." := Custom1ErrorNo;
                                      FAJnlLineTmp."Line No." := FAJnlLineTmp."Line No." + 1;
                                      FAJnlLineTmp.INSERT;
                                    END ELSE BEGIN
                                      GenJnlLineTmp."Account No." := "No.";
                                      GenJnlLineTmp."FA Posting Type" := GenJnlLineTmp."FA Posting Type"::"Custom 1";
                                      GenJnlLineTmp.Amount := Custom1Amount;
                                      GenJnlLineTmp."No. of Depreciation Days" := Custom1NumberOfDays;
                                      GenJnlLineTmp."FA Error Entry No." := Custom1ErrorNo;
                                      GenJnlLineTmp."Line No." := GenJnlLineTmp."Line No." + 1;
                                      GenJnlLineTmp.INSERT;
                                    END;

                                  IF DeprAmount <> 0 THEN
                                    IF NOT DeprBook."G/L Integration - Depreciation" OR "Budgeted Asset" THEN BEGIN
                                      FAJnlLineTmp."FA No." := "No.";
                                      FAJnlLineTmp."FA Posting Type" := FAJnlLineTmp."FA Posting Type"::Depreciation;
                                      FAJnlLineTmp.Amount := DeprAmount;
                                      FAJnlLineTmp."No. of Depreciation Days" := NumberOfDays;
                                      FAJnlLineTmp."FA Error Entry No." := ErrorNo;
                                      FAJnlLineTmp."Line No." := FAJnlLineTmp."Line No." + 1;
                                      FAJnlLineTmp.INSERT;
                                    END ELSE BEGIN
                                      GenJnlLineTmp."Account No." := "No.";
                                      GenJnlLineTmp."FA Posting Type" := GenJnlLineTmp."FA Posting Type"::Depreciation;
                                      GenJnlLineTmp.Amount := DeprAmount;
                                      GenJnlLineTmp."No. of Depreciation Days" := NumberOfDays;
                                      GenJnlLineTmp."FA Error Entry No." := ErrorNo;
                                      GenJnlLineTmp."Line No." := GenJnlLineTmp."Line No." + 1;
                                      GenJnlLineTmp.INSERT;
                                    END;
                                END;

               OnPostDataItem=BEGIN
                                WITH FAJnlLine DO BEGIN
                                  IF FAJnlLineTmp.FIND('-') THEN BEGIN
                                    LOCKTABLE;
                                    FAJnlSetup.FAJnlName(DeprBook,FAJnlLine,FAJnlNextLineNo);
                                    NoSeries := FAJnlSetup.GetFANoSeries(FAJnlLine);
                                    IF DocumentNo = '' THEN
                                      DocumentNo2 := FAJnlSetup.GetFAJnlDocumentNo(FAJnlLine,DeprUntilDate,TRUE)
                                    ELSE
                                      DocumentNo2 := DocumentNo;
                                  END;
                                  IF FAJnlLineTmp.FIND('-') THEN
                                    REPEAT
                                      INIT;
                                      "Line No." := 0;
                                      FAJnlSetup.SetFAJnlTrailCodes(FAJnlLine);
                                      LineNo := LineNo + 1;
                                      Window.UPDATE(3,LineNo);
                                      "Posting Date" := PostingDate;
                                      "FA Posting Date" := DeprUntilDate;
                                      IF "Posting Date" = "FA Posting Date" THEN
                                        "Posting Date" := 0D;
                                      "FA Posting Type" := FAJnlLineTmp."FA Posting Type";
                                      VALIDATE("FA No.",FAJnlLineTmp."FA No.");
                                      "Document No." := DocumentNo2;
                                      "Posting No. Series" := NoSeries;
                                      Description := PostingDescription;
                                      VALIDATE("Depreciation Book Code",DeprBookCode);
                                      VALIDATE(Amount,FAJnlLineTmp.Amount);
                                      "No. of Depreciation Days" := FAJnlLineTmp."No. of Depreciation Days";
                                      "FA Error Entry No." := FAJnlLineTmp."FA Error Entry No.";
                                      FAJnlNextLineNo := FAJnlNextLineNo + 10000;
                                      "Line No." := FAJnlNextLineNo;
                                      INSERT(TRUE);
                                      FAJnlLineCreatedCount += 1;
                                    UNTIL FAJnlLineTmp.NEXT = 0;
                                END;

                                WITH GenJnlLine DO BEGIN
                                  IF GenJnlLineTmp.FIND('-') THEN BEGIN
                                    LOCKTABLE;
                                    FAJnlSetup.GenJnlName(DeprBook,GenJnlLine,GenJnlNextLineNo);
                                    NoSeries := FAJnlSetup.GetGenNoSeries(GenJnlLine);
                                    IF DocumentNo = '' THEN
                                      DocumentNo2 := FAJnlSetup.GetGenJnlDocumentNo(GenJnlLine,DeprUntilDate,TRUE)
                                    ELSE
                                      DocumentNo2 := DocumentNo;
                                  END;
                                  IF GenJnlLineTmp.FIND('-') THEN
                                    REPEAT
                                      INIT;
                                      "Line No." := 0;
                                      FAJnlSetup.SetGenJnlTrailCodes(GenJnlLine);
                                      LineNo := LineNo + 1;
                                      Window.UPDATE(3,LineNo);
                                      "Posting Date" := PostingDate;
                                      "FA Posting Date" := DeprUntilDate;
                                      IF "Posting Date" = "FA Posting Date" THEN
                                        "FA Posting Date" := 0D;
                                      "FA Posting Type" := GenJnlLineTmp."FA Posting Type";
                                      "Account Type" := "Account Type"::"Fixed Asset";
                                      VALIDATE("Account No.",GenJnlLineTmp."Account No.");
                                      Description := PostingDescription;
                                      "Document No." := DocumentNo2;
                                      "Posting No. Series" := NoSeries;
                                      VALIDATE("Depreciation Book Code",DeprBookCode);
                                      VALIDATE(Amount,GenJnlLineTmp.Amount);
                                      "No. of Depreciation Days" := GenJnlLineTmp."No. of Depreciation Days";
                                      "FA Error Entry No." := GenJnlLineTmp."FA Error Entry No.";
                                      GenJnlNextLineNo := GenJnlNextLineNo + 1000;
                                      "Line No." := GenJnlNextLineNo;
                                      INSERT(TRUE);
                                      GenJnlLineCreatedCount += 1;
                                      IF BalAccount THEN
                                        FAInsertGLAcc.GetBalAcc2(GenJnlLine,GenJnlNextLineNo);
                                    UNTIL GenJnlLineTmp.NEXT = 0;
                                END;
                              END;

               ReqFilterFields=No.,FA Class Code,FA Subclass Code,Budgeted Asset }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
                   BalAccount := TRUE;
                   PostingDate := WORKDATE;
                   DeprUntilDate := WORKDATE;
                   IF DeprBookCode = '' THEN BEGIN
                     FASetup.GET;
                     DeprBookCode := FASetup."Default Depr. Book";
                   END;
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 15  ;2   ;Field     ;
                  Name=DepreciationBook;
                  CaptionML=[DAN=Afskrivningsprofil;
                             ENU=Depreciation Book];
                  ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, der skal inkluderes i rapporten eller k›rslen.;
                             ENU=Specifies the code for the depreciation book to be included in the report or batch job.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=DeprBookCode;
                  TableRelation="Depreciation Book" }

      { 9   ;2   ;Field     ;
                  Name=FAPostingDate;
                  CaptionML=[DAN=Bogf›ringsdato for anl‘g;
                             ENU=FA Posting Date];
                  ToolTipML=[DAN=Angiver den bogf›ringsdato for anl‘gget, som skal bruges i forbindelse med k›rslen. K›rslen omfatter anl‘gsposter op til denne dato. Datoen vises i feltet Bogf›ringsdato for anl‘g i de kladdelinjer, som k›rslen opretter. Hvis du har markeret feltet Brug ens anl‘gsdato+bogf.dato i den afskrivningsprofil, som blev anvendt til k›rslen, skal denne dato v‘re den samme som den bogf›ringsdato, der er angivet i feltet Bogf›ringsdato.;
                             ENU=Specifies the fixed asset posting date to be used by the batch job. The batch job includes ledger entries up to this date. This date appears in the FA Posting Date field in the resulting journal lines. If the Use Same FA+G/L Posting Dates field has been activated in the depreciation book that is used in the batch job, then this date must be the same as the posting date entered in the Posting Date field.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=DeprUntilDate;
                  Importance=Additional;
                  OnValidate=BEGIN
                               DeprUntilDateModified := TRUE;
                             END;
                              }

      { 8   ;2   ;Field     ;
                  Name=UseForceNoOfDays;
                  CaptionML=[DAN=Brug tvungent antal dage;
                             ENU=Use Force No. of Days];
                  ToolTipML=[DAN=Angiver, om programmet skal benytte det antal dage i afskrivningsberegningerne, som er angivet i feltet nedenfor.;
                             ENU=Specifies if you want the program to use the number of days, as specified in the field below, in the depreciation calculation.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=UseForceNoOfDays;
                  Importance=Additional;
                  OnValidate=BEGIN
                               IF NOT UseForceNoOfDays THEN
                                 DaysInPeriod := 0;
                             END;
                              }

      { 5   ;2   ;Field     ;
                  Name=ForceNoOfDays;
                  CaptionML=[DAN=Tvungent antal dage;
                             ENU=Force No. of Days];
                  ToolTipML=[DAN=Angiver, om programmet skal benytte det antal dage i afskrivningsberegningerne, som er angivet i feltet nedenfor.;
                             ENU=Specifies if you want the program to use the number of days, as specified in the field below, in the depreciation calculation.];
                  ApplicationArea=#FixedAssets;
                  BlankZero=Yes;
                  SourceExpr=DaysInPeriod;
                  MinValue=0;
                  Importance=Additional;
                  OnValidate=BEGIN
                               IF NOT UseForceNoOfDays AND (DaysInPeriod <> 0) THEN
                                 ERROR(Text006);
                             END;
                              }

      { 11  ;2   ;Field     ;
                  Name=PostingDate;
                  CaptionML=[DAN=Bogf›ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver den bogf›ringsdato, som skal bruges i forbindelse med k›rslen.;
                             ENU=Specifies the posting date to be used by the batch job.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=PostingDate;
                  OnValidate=BEGIN
                               IF NOT DeprUntilDateModified THEN
                                 DeprUntilDate := PostingDate;
                             END;
                              }

      { 1   ;2   ;Field     ;
                  Name=DocumentNo;
                  CaptionML=[DAN=Bilagsnr.;
                             ENU=Document No.];
                  ToolTipML=[DAN=Angiver det n‘ste tilg‘ngelige nummer p† den resulterende kladdelinje, hvis du lader feltet v‘re tomt. Hvis der ikke er konfigureret nogen nummerserie, skal du angive det bilagsnummer, du vil knytte til den resulterende kladdelinje.;
                             ENU=Specifies, if you leave the field empty, the next available number on the resulting journal line. If a number series is not set up, enter the document number that you want assigned to the resulting journal line.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=DocumentNo }

      { 13  ;2   ;Field     ;
                  CaptionML=[DAN=Bogf›ringsbeskrivelse;
                             ENU=Posting Description];
                  ToolTipML=[DAN=Angiver den bogf›ringsdato, som skal bruges som filter i forbindelse med k›rslen.;
                             ENU=Specifies the posting date to be used by the batch job as a filter.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=PostingDescription }

      { 3   ;2   ;Field     ;
                  Name=InsertBalAccount;
                  CaptionML=[DAN=Inds‘t modkonto;
                             ENU=Insert Bal. Account];
                  ToolTipML=[DAN=Angiver, at der automatisk skal inds‘ttes modkonti p† de anl‘gsposter, som k›rslen opretter.;
                             ENU=Specifies if you want the batch job to automatically insert fixed asset entries with balancing accounts.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=BalAccount;
                  Importance=Additional }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du skal indtaste %1.;ENU=You must specify %1.';
      Text001@1001 : TextConst 'DAN=Brug tvungent antal dage skal aktiveres.;ENU=Force No. of Days must be activated.';
      Text002@1002 : TextConst 'DAN="%1 og %2 skal v‘re ens. %3 skal v‘re %4 i %5 %6 = %7.";ENU="%1 and %2 must be identical. %3 must be %4 in %5 %6 = %7."';
      Text003@1003 : TextConst 'DAN=Afskriver anl‘g               #1##########\;ENU=Depreciating fixed asset      #1##########\';
      Text004@1004 : TextConst 'DAN=Overspringer anl‘g            #2##########\;ENU=Not depreciating fixed asset  #2##########\';
      Text005@1005 : TextConst 'DAN=Inds‘tter kladdelinjer        #3##########;ENU=Inserting journal lines       #3##########';
      Text006@1006 : TextConst 'DAN=Brug tvungent antal dage skal aktiveres.;ENU=Use Force No. of Days must be activated.';
      GenJnlLine@1007 : Record 81;
      GenJnlLineTmp@1008 : TEMPORARY Record 81;
      FASetup@1009 : Record 5603;
      FAJnlLine@1010 : Record 5621;
      FAJnlLineTmp@1011 : TEMPORARY Record 5621;
      DeprBook@1012 : Record 5611;
      FAJnlSetup@1013 : Record 5605;
      CalculateDepr@1014 : Codeunit 5610;
      FAInsertGLAcc@1015 : Codeunit 5601;
      Window@1016 : Dialog;
      DeprAmount@1017 : Decimal;
      Custom1Amount@1018 : Decimal;
      NumberOfDays@1019 : Integer;
      Custom1NumberOfDays@1020 : Integer;
      DeprUntilDate@1021 : Date;
      UseForceNoOfDays@1022 : Boolean;
      DaysInPeriod@1023 : Integer;
      PostingDate@1024 : Date;
      DocumentNo@1025 : Code[20];
      DocumentNo2@1026 : Code[20];
      NoSeries@1027 : Code[20];
      PostingDescription@1028 : Text[50];
      DeprBookCode@1029 : Code[10];
      BalAccount@1030 : Boolean;
      ErrorNo@1031 : Integer;
      Custom1ErrorNo@1032 : Integer;
      FAJnlNextLineNo@1033 : Integer;
      GenJnlNextLineNo@1034 : Integer;
      EntryAmounts@1035 : ARRAY [4] OF Decimal;
      LineNo@1036 : Integer;
      CompletionStatsMsg@1037 : TextConst 'DAN=Afskrivningen er beregnet.\\Ingen kladdelinjer blev oprettet.;ENU=The depreciation has been calculated.\\No journal lines were created.';
      FAJnlLineCreatedCount@1038 : Integer;
      GenJnlLineCreatedCount@1039 : Integer;
      CompletionStatsFAJnlQst@1042 : TextConst '@@@=The depreciation has been calculated.\\5 fixed asset journal lines were created.\\Do you want to open the Fixed Asset Journal window?;DAN=Afskrivningen er beregnet.\\%1 anl‘gskladdelinjer blev oprettet.\\Vil du †bne vinduet Anl‘gskladde?;ENU=The depreciation has been calculated.\\%1 fixed asset journal lines were created.\\Do you want to open the Fixed Asset Journal window?';
      CompletionStatsGenJnlQst@1043 : TextConst '@@@=The depreciation has been calculated.\\2 fixed asset G/L  journal lines were created.\\Do you want to open the Fixed Asset G/L Journal window?;DAN=Afskrivningen er beregnet.\\%1 anl‘gsfinanskladdelinjer blev oprettet.\\Vil du †bne vinduet Anl‘gskassekladde?;ENU=The depreciation has been calculated.\\%1 fixed asset G/L journal lines were created.\\Do you want to open the Fixed Asset G/L Journal window?';
      DeprUntilDateModified@1040 : Boolean;

    PROCEDURE InitializeRequest@1(DeprBookCodeFrom@1007 : Code[10];DeprUntilDateFrom@1000 : Date;UseForceNoOfDaysFrom@1001 : Boolean;DaysInPeriodFrom@1002 : Integer;PostingDateFrom@1003 : Date;DocumentNoFrom@1004 : Code[20];PostingDescriptionFrom@1005 : Text[50];BalAccountFrom@1006 : Boolean);
    BEGIN
      DeprBookCode := DeprBookCodeFrom;
      DeprUntilDate := DeprUntilDateFrom;
      UseForceNoOfDays := UseForceNoOfDaysFrom;
      DaysInPeriod := DaysInPeriodFrom;
      PostingDate := PostingDateFrom;
      DocumentNo := DocumentNoFrom;
      PostingDescription := PostingDescriptionFrom;
      BalAccount := BalAccountFrom;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

