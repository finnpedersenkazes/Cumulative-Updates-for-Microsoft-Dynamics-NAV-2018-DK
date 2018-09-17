OBJECT Report 5688 Cancel FA Ledger Entries
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836,NAVDK11.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Annuller anl�gsfinansposter;
               ENU=Cancel FA Ledger Entries];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  IF (EndingDate > 0D) AND (StartingDate > EndingDate) THEN
                    ERROR(Text000);
                  IF UseNewPostingDate THEN
                    IF NewPostingDate = 0D THEN
                      ERROR(Text002);
                  IF NOT UseNewPostingDate THEN
                    IF NewPostingDate > 0D THEN
                      ERROR(Text003);
                  IF NewPostingDate > 0D THEN
                    IF NORMALDATE(NewPostingDate) <> NewPostingDate THEN
                      ERROR(Text004);

                  IF EndingDate = 0D THEN
                    EndingDate2 := DMY2DATE(31,12,9999)
                  ELSE
                    EndingDate2 := EndingDate;
                  DeprBook.GET(DeprBookCode);
                  IF UseNewPostingDate THEN
                    DeprBook.TESTFIELD("Use Same FA+G/L Posting Dates",FALSE);
                  DeprBook.IndexGLIntegration(GLIntegration);
                  FirstGenJnl := TRUE;
                  FirstFAJnl := TRUE;
                  Window.OPEN(Text001);
                END;

  }
  DATASET
  {
    { 3794;    ;DataItem;                    ;
               DataItemTable=Table5600;
               DataItemTableView=SORTING(No.);
               OnPreDataItem=BEGIN
                               DepreciationCalc.SetFAFilter(FALedgEntry,'',DeprBookCode,FALSE);
                               WITH FALedgEntry DO BEGIN
                                 SETRANGE("FA Posting Category","FA Posting Category"::" ");
                                 SETRANGE(
                                   "FA Posting Type",
                                   "FA Posting Type"::"Acquisition Cost","FA Posting Type"::"Salvage Value");
                                 SETRANGE("FA Posting Date",StartingDate,EndingDate2);
                               END;
                             END;

               OnAfterGetRecord=BEGIN
                                  Window.UPDATE(1,"No.");
                                  IF Inactive OR Blocked THEN
                                    CurrReport.SKIP;
                                  IF NOT FADeprBook.GET("No.",DeprBookCode) THEN
                                    CurrReport.SKIP;
                                  FALedgEntry.SETRANGE("FA No.","No.");
                                  IF FALedgEntry.FIND('+') THEN
                                    REPEAT
                                      SetJournalType(FALedgEntry);
                                      IF NewPostingDate > 0D THEN
                                        FALedgEntry."Posting Date" := NewPostingDate;
                                      CASE JournalType OF
                                        JournalType::SkipType:
                                          ;
                                        JournalType::GenJnlType:
                                          InsertGenJnlLine(FALedgEntry);
                                        JournalType::FAJnlType:
                                          InsertFAJnlLine(FALedgEntry);
                                      END;
                                    UNTIL FALedgEntry.NEXT(-1) = 0;
                                END;

               ReqFilterFields=No.,FA Class Code,FA Subclass Code }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
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

      { 1   ;2   ;Field     ;
                  Name=CancelBook;
                  CaptionML=[DAN=Annuller profil;
                             ENU=Cancel Book];
                  ToolTipML=[DAN=Angiver den afskrivningsprofil, som poster fjernes fra af k�rslen.;
                             ENU=Specifies the depreciation book where entries will be removed by the batch job.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=DeprBookCode;
                  TableRelation="Depreciation Book" }

      { 20  ;2   ;Field     ;
                  CaptionML=[DAN=Startdato;
                             ENU=Starting Date];
                  ToolTipML=[DAN=Angiver den dato, hvor rapporten skal starte.;
                             ENU=Specifies the date when you want the report to start.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=StartingDate }

      { 6   ;2   ;Field     ;
                  CaptionML=[DAN=Slutdato;
                             ENU=Ending Date];
                  ToolTipML=[DAN=Angiver den dato, hvor rapporten skal slutte.;
                             ENU=Specifies the date when you want the report to end.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=EndingDate }

      { 23  ;2   ;Field     ;
                  CaptionML=[DAN=Brug ny bogf�ringsdato;
                             ENU=Use New Posting Date];
                  ToolTipML=[DAN=Angiver, at der anvendes en ny bogf�ringsdato i de kladdeposter, der oprettes ved k�rslen. Hvis du undlader at markere feltet, kopieres bogf�ringsdatoen for de anl�gsposter, der skal annulleres, til de kladdeposter, der oprettes ved k�rslen.;
                             ENU=Specifies that a new posting date is applied to the journal entries created by the batch job. If the field is cleared, the posting date of the fixed asset ledger entries to be canceled is copied to the journal entries that the batch job creates.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=UseNewPostingDate }

      { 19  ;2   ;Field     ;
                  CaptionML=[DAN=Ny bogf�ringsdato;
                             ENU=New Posting Date];
                  ToolTipML=[DAN=Angiver den bogf�ringsdato, der skal anvendes i de kladdeposter, der oprettes ved k�rslen, n�r feltet Brug ny bogf�ringsdato er markeret.;
                             ENU=Specifies the posting date to be applied to the journal entries created by the batch job when the Use New Posting Date field is selected.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=NewPostingDate }

      { 16  ;2   ;Field     ;
                  CaptionML=[DAN=Bilagsnr.;
                             ENU=Document No.];
                  ToolTipML=[DAN=Angiver det n�ste tilg�ngelige nummer p� den resulterende kladdelinje, hvis du lader feltet v�re tomt. Hvis der ikke er konfigureret nogen nummerserie, skal du angive det bilagsnummer, du vil knytte til den resulterende kladdelinje.;
                             ENU=Specifies, if you leave the field empty, the next available number on the resulting journal line. If a number series is not set up, enter the document number that you want assigned to the resulting journal line.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=DocumentNo }

      { 13  ;2   ;Field     ;
                  CaptionML=[DAN=Bogf�ringsbeskrivelse;
                             ENU=Posting Description];
                  ToolTipML=[DAN=Angiver den bogf�ringsdato, som skal bruges som filter i forbindelse med k�rslen.;
                             ENU=Specifies the posting date to be used by the batch job as a filter.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=PostingDescription }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Inds�t modkonto;
                             ENU=Insert Bal. Account];
                  ToolTipML=[DAN=Angiver, at der automatisk skal inds�ttes modkonti p� de anl�gsposter, som k�rslen opretter.;
                             ENU=Specifies if you want the batch job to automatically insert fixed asset entries with balancing accounts.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=BalAccount }

      { 1904404401;2;Group  ;
                  CaptionML=[DAN=Annuller;
                             ENU=Cancel] }

      { 8   ;3   ;Field     ;
                  CaptionML=[DAN=Anskaffelse;
                             ENU=Acquisition Cost];
                  ToolTipML=[DAN=Angiver, om relaterede anskaffelsesposter er inkluderet i k�rslen.;
                             ENU=Specifies if related acquisition cost entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CancelChoices[1] }

      { 9   ;3   ;Field     ;
                  CaptionML=[DAN=Afskrivning;
                             ENU=Depreciation];
                  ToolTipML=[DAN=Angiver, om relaterede afskrivningsposter er inkluderet i k�rslen.;
                             ENU=Specifies if related depreciation entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CancelChoices[2] }

      { 10  ;3   ;Field     ;
                  CaptionML=[DAN=Nedskrivning;
                             ENU=Write-Down];
                  ToolTipML=[DAN=Angiver, om relaterede nedskrivningsposter er inkluderet i k�rslen.;
                             ENU=Specifies if related write-down entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CancelChoices[3] }

      { 11  ;3   ;Field     ;
                  CaptionML=[DAN=Opskrivning;
                             ENU=Appreciation];
                  ToolTipML=[DAN=Angiver, om relaterede opskrivningsposter er inkluderet i k�rslen.;
                             ENU=Specifies if related appreciation entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CancelChoices[4] }

      { 18  ;3   ;Field     ;
                  CaptionML=[DAN=Skrapv�rdi;
                             ENU=Salvage Value];
                  ToolTipML=[DAN=Angiver, om relaterede skrapv�rdiposter er inkluderet i k�rslen.;
                             ENU=Specifies if related salvage value entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CancelChoices[9] }

      { 5   ;3   ;Field     ;
                  Name=Disposal;
                  CaptionML=[DAN=Salg;
                             ENU=Disposal];
                  ToolTipML=[DAN=Angiver, om relaterede salgsposter er inkluderet i k�rslen.;
                             ENU=Specifies if related disposal entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CancelChoices[7] }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Startdato ligger efter slutdato.;ENU=The Starting Date is later than the Ending Date.';
      Text001@1001 : TextConst 'DAN=Annullerer anl�gsposter  #1##########;ENU=Canceling fixed asset    #1##########';
      GenJnlLine@1002 : Record 81;
      FASetup@1003 : Record 5603;
      FAJnlLine@1004 : Record 5621;
      FADeprBook@1005 : Record 5612;
      DeprBook@1006 : Record 5611;
      FALedgEntry@1007 : Record 5601;
      FAJnlSetup@1008 : Record 5605;
      DepreciationCalc@1009 : Codeunit 5616;
      Window@1011 : Dialog;
      CancelChoices@1012 : ARRAY [9] OF Boolean;
      GLIntegration@1013 : ARRAY [9] OF Boolean;
      DocumentNo@1014 : Code[20];
      DocumentNo2@1015 : Code[20];
      DocumentNo3@1016 : Code[20];
      NoSeries2@1017 : Code[20];
      NoSeries3@1018 : Code[20];
      PostingDescription@1019 : Text[50];
      JournalType@1020 : 'SkipType,GenJnlType,FAJnlType';
      DeprBookCode@1021 : Code[10];
      BalAccount@1022 : Boolean;
      StartingDate@1023 : Date;
      EndingDate@1024 : Date;
      EndingDate2@1025 : Date;
      FirstGenJnl@1026 : Boolean;
      FirstFAJnl@1027 : Boolean;
      FAJnlNextLineNo@1028 : Integer;
      GenJnlNextLineNo@1029 : Integer;
      Text002@1032 : TextConst 'DAN=Du skal angive en ny bogf�ringsdato.;ENU=You must specify New Posting Date.';
      Text003@1031 : TextConst 'DAN=Du skal ikke angive en ny bogf�ringsdato.;ENU=You must not specify New Posting Date.';
      Text004@1030 : TextConst 'DAN=Du skal ikke angive en ultimodato.;ENU=You must not specify a closing date.';
      UseNewPostingDate@1034 : Boolean;
      NewPostingDate@1033 : Date;

    LOCAL PROCEDURE InsertGenJnlLine@2(VAR FALedgEntry@1000 : Record 5601);
    VAR
      FAInsertGLAcc@1001 : Codeunit 5601;
    BEGIN
      IF FirstGenJnl THEN BEGIN
        GenJnlLine.LOCKTABLE;
        FAJnlSetup.GenJnlName(DeprBook,GenJnlLine,GenJnlNextLineNo);
        NoSeries2 := FAJnlSetup.GetGenNoSeries(GenJnlLine);
        IF DocumentNo = '' THEN
          DocumentNo2 := FAJnlSetup.GetGenJnlDocumentNo(GenJnlLine,GetPostingDate(FALedgEntry."FA Posting Date"),TRUE)
        ELSE
          DocumentNo2 := DocumentNo;
      END;
      FirstGenJnl := FALSE;

      WITH GenJnlLine DO BEGIN
        FALedgEntry.MoveToGenJnl(GenJnlLine);
        "Shortcut Dimension 1 Code" := FALedgEntry."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := FALedgEntry."Global Dimension 2 Code";
        "Dimension Set ID" := FALedgEntry."Dimension Set ID";
        VALIDATE("Depreciation Book Code",DeprBookCode);
        VALIDATE(Amount,-Amount);
        "FA Error Entry No." := FALedgEntry."Entry No.";
        VALIDATE(Correction,DeprBook."Mark Errors as Corrections");
        "Document No." := DocumentNo2;
        "Posting No. Series" := NoSeries2;
        "Document Type" := "Document Type"::" ";
        "External Document No." := '';
        IF PostingDescription <> '' THEN
          Description := PostingDescription;
        GenJnlNextLineNo := GenJnlNextLineNo + 10000;
        "Line No." := GenJnlNextLineNo;
        INSERT(TRUE);
        IF BalAccount THEN BEGIN
          FAInsertGLAcc.GetBalAcc(GenJnlLine);
          IF FINDLAST THEN ;
          GenJnlNextLineNo := "Line No.";
        END;
      END;
    END;

    LOCAL PROCEDURE InsertFAJnlLine@3(VAR FALedgEntry@1000 : Record 5601);
    BEGIN
      IF FirstFAJnl THEN BEGIN
        FAJnlLine.LOCKTABLE;
        FAJnlSetup.FAJnlName(DeprBook,FAJnlLine,FAJnlNextLineNo);
        NoSeries3 := FAJnlSetup.GetFANoSeries(FAJnlLine);
        IF DocumentNo = '' THEN
          DocumentNo3 := FAJnlSetup.GetFAJnlDocumentNo(FAJnlLine,GetPostingDate(FALedgEntry."FA Posting Date"),TRUE)
        ELSE
          DocumentNo3 := DocumentNo;
      END;
      FirstFAJnl := FALSE;

      WITH FAJnlLine DO BEGIN
        FALedgEntry.MoveToFAJnl(FAJnlLine);
        "Shortcut Dimension 1 Code" := FALedgEntry."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := FALedgEntry."Global Dimension 2 Code";
        "Dimension Set ID" := FALedgEntry."Dimension Set ID";
        VALIDATE("Depreciation Book Code",DeprBookCode);
        VALIDATE(Amount,-Amount);
        "FA Error Entry No." := FALedgEntry."Entry No.";
        VALIDATE(Correction,DeprBook."Mark Errors as Corrections");
        "Document No." := DocumentNo3;
        "Posting No. Series" := NoSeries3;
        "Document Type" := "Document Type"::" ";
        "External Document No." := '';
        IF PostingDescription <> '' THEN
          Description := PostingDescription;
        FAJnlNextLineNo := FAJnlNextLineNo + 10000;
        "Line No." := FAJnlNextLineNo;
        INSERT(TRUE);
      END;
    END;

    LOCAL PROCEDURE SetJournalType@10(VAR FALedgEntry@1000 : Record 5601);
    VAR
      Index@1001 : Integer;
    BEGIN
      Index := FALedgEntry.ConvertPostingType + 1;
      IF CancelChoices[Index] THEN BEGIN
        IF GLIntegration[Index] AND NOT "Fixed Asset"."Budgeted Asset" THEN
          JournalType := JournalType::GenJnlType
        ELSE
          JournalType := JournalType::FAJnlType
      END ELSE
        JournalType := JournalType::SkipType;
    END;

    PROCEDURE InitializeRequest@1(DeprBookCodeFrom@1000 : Code[10];StartingDateFrom@1001 : Date;EndingDateFrom@1002 : Date;UseNewPostingDateFrom@1003 : Boolean;NewPostingDateFrom@1004 : Date;DocumentNoFrom@1005 : Code[20];PostingDescriptionFrom@1006 : Text[50];BalAccountFrom@1007 : Boolean);
    BEGIN
      DeprBookCode := DeprBookCodeFrom;
      StartingDate := StartingDateFrom;
      EndingDate := EndingDateFrom;
      UseNewPostingDate := UseNewPostingDateFrom;
      NewPostingDate := NewPostingDateFrom;
      DocumentNo := DocumentNoFrom;
      PostingDescription := PostingDescriptionFrom;
      BalAccount := BalAccountFrom;
    END;

    PROCEDURE SetCancelDepreciation@4(Choice@1000 : Boolean);
    BEGIN
      CancelChoices[2] := Choice;
    END;

    PROCEDURE SetCancelAcquisitionCost@5(Choice@1000 : Boolean);
    BEGIN
      CancelChoices[1] := Choice;
    END;

    LOCAL PROCEDURE GetPostingDate@6(FAPostingDate@1000 : Date) : Date;
    BEGIN
      IF NewPostingDate <> 0D THEN
        EXIT(NewPostingDate);
      EXIT(FAPostingDate);
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

