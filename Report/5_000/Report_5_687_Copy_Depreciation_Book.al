OBJECT Report 5687 Copy Depreciation Book
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836,NAVDK11.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kopier afskrivningsprofil;
               ENU=Copy Depreciation Book];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  IF (EndingDate > 0D) AND (StartingDate > EndingDate) THEN
                    ERROR(Text000);
                  IF EndingDate = 0D THEN
                    EndingDate2 := DMY2DATE(31,12,9999)
                  ELSE
                    EndingDate2 := EndingDate;
                  DeprBook.GET(DeprBookCode);
                  DeprBook2.GET(DeprBookCode2);
                  ExchangeRate := GetExchangeRate;
                  DeprBook2.IndexGLIntegration(GLIntegration);
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
                                  IF NOT FADeprBook2.GET("No.",DeprBookCode2) THEN BEGIN
                                    FADeprBook2 := FADeprBook;
                                    FADeprBook2."Depreciation Book Code" := DeprBookCode2;
                                    FADeprBook2.INSERT(TRUE);
                                  END;
                                  FALedgEntry.SETRANGE("FA No.","No.");
                                  IF FALedgEntry.FIND('-') THEN
                                    REPEAT
                                      SetJournalType(FALedgEntry);
                                      CASE JournalType OF
                                        JournalType::SkipType:
                                          ;
                                        JournalType::GenJnlType:
                                          InsertGenJnlLine(FALedgEntry);
                                        JournalType::FAJnlType:
                                          InsertFAJnlLine(FALedgEntry);
                                      END;
                                    UNTIL FALedgEntry.NEXT = 0;
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
                  Name=CopyFromBook;
                  CaptionML=[DAN=Kopier fra afskr.profil;
                             ENU=Copy from Book];
                  ToolTipML=[DAN=Angiver koden p� den afskrivningsprofil, du vil kopiere fra.;
                             ENU=Specifies the code of the depreciation book you want to copy from.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=DeprBookCode;
                  TableRelation="Depreciation Book" }

      { 15  ;2   ;Field     ;
                  Name=CopyToBook;
                  CaptionML=[DAN=Kopier til afskr.profil;
                             ENU=Copy to Book];
                  ToolTipML=[DAN=Angiver koden p� den afskrivningsprofil, du vil kopiere til.;
                             ENU=Specifies the code of the depreciation book you want to copy to.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=DeprBookCode2;
                  TableRelation="Depreciation Book" }

      { 20  ;2   ;Field     ;
                  Name=StartingDate;
                  CaptionML=[DAN=Startdato;
                             ENU=Starting Date];
                  ToolTipML=[DAN=Angiver den dato, hvor rapporten skal starte.;
                             ENU=Specifies the date when you want the report to start.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=StartingDate }

      { 6   ;2   ;Field     ;
                  Name=EndingDate;
                  CaptionML=[DAN=Slutdato;
                             ENU=Ending Date];
                  ToolTipML=[DAN=Angiver den dato, hvor rapporten skal slutte.;
                             ENU=Specifies the date when you want the report to end.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=EndingDate }

      { 19  ;2   ;Field     ;
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
                  Name=InsertBalAccount;
                  CaptionML=[DAN=Inds�t modkonto;
                             ENU=Insert Bal. Account];
                  ToolTipML=[DAN=Angiver, at der automatisk skal inds�ttes modkonti p� de anl�gsposter, som k�rslen opretter.;
                             ENU=Specifies if you want the batch job to automatically insert fixed asset entries with balancing accounts.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=BalAccount }

      { 7   ;2   ;Group     ;
                  CaptionML=[DAN=Kopier;
                             ENU=Copy] }

      { 8   ;3   ;Field     ;
                  CaptionML=[DAN=Anskaffelse;
                             ENU=Acquisition Cost];
                  ToolTipML=[DAN=Angiver, om relaterede anskaffelsesposter er inkluderet i k�rslen.;
                             ENU=Specifies if related acquisition cost entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CopyChoices[1] }

      { 9   ;3   ;Field     ;
                  CaptionML=[DAN=Afskrivning;
                             ENU=Depreciation];
                  ToolTipML=[DAN=Angiver, om relaterede afskrivningsposter er inkluderet i k�rslen.;
                             ENU=Specifies if related depreciation entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CopyChoices[2] }

      { 10  ;3   ;Field     ;
                  CaptionML=[DAN=Nedskrivning;
                             ENU=Write-Down];
                  ToolTipML=[DAN=Angiver, om relaterede nedskrivningsposter er inkluderet i k�rslen.;
                             ENU=Specifies if related write-down entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CopyChoices[3] }

      { 11  ;3   ;Field     ;
                  CaptionML=[DAN=Opskrivning;
                             ENU=Appreciation];
                  ToolTipML=[DAN=Angiver, om relaterede opskrivningsposter er inkluderet i k�rslen.;
                             ENU=Specifies if related appreciation entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CopyChoices[4] }

      { 18  ;3   ;Field     ;
                  CaptionML=[DAN=Skrapv�rdi;
                             ENU=Salvage Value];
                  ToolTipML=[DAN=Angiver, om relaterede skrapv�rdiposter er inkluderet i k�rslen.;
                             ENU=Specifies if related salvage value entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CopyChoices[9] }

      { 5   ;3   ;Field     ;
                  CaptionML=[DAN=Salg;
                             ENU=Disposal];
                  ToolTipML=[DAN=Angiver, om relaterede salgsposter er inkluderet i k�rslen.;
                             ENU=Specifies if related disposal entries are included in the batch job .];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=CopyChoices[7] }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Startdato ligger efter slutdato.;ENU=The Starting Date is later than the Ending Date.';
      Text001@1001 : TextConst 'DAN=Kopierer anl�g         #1##########;ENU=Copying fixed asset    #1##########';
      GenJnlLine@1002 : Record 81;
      FASetup@1003 : Record 5603;
      FAJnlLine@1004 : Record 5621;
      FADeprBook@1005 : Record 5612;
      FADeprBook2@1006 : Record 5612;
      DeprBook@1007 : Record 5611;
      DeprBook2@1008 : Record 5611;
      FALedgEntry@1009 : Record 5601;
      FAJnlSetup@1010 : Record 5605;
      DepreciationCalc@1011 : Codeunit 5616;
      CancelFALedgEntries@1012 : Codeunit 5624;
      Window@1013 : Dialog;
      ExchangeRate@1014 : Decimal;
      CopyChoices@1015 : ARRAY [9] OF Boolean;
      GLIntegration@1016 : ARRAY [9] OF Boolean;
      DocumentNo@1017 : Code[20];
      DocumentNo2@1018 : Code[20];
      DocumentNo3@1019 : Code[20];
      NoSeries2@1020 : Code[20];
      NoSeries3@1021 : Code[20];
      PostingDescription@1022 : Text[50];
      JournalType@1023 : 'SkipType,GenJnlType,FAJnlType';
      DeprBookCode@1024 : Code[10];
      DeprBookCode2@1025 : Code[10];
      BalAccount@1026 : Boolean;
      StartingDate@1027 : Date;
      EndingDate@1028 : Date;
      EndingDate2@1029 : Date;
      FirstGenJnl@1030 : Boolean;
      FirstFAJnl@1031 : Boolean;
      FAJnlNextLineNo@1032 : Integer;
      GenJnlNextLineNo@1033 : Integer;

    LOCAL PROCEDURE InsertGenJnlLine@2(VAR FALedgEntry@1000 : Record 5601);
    VAR
      FAInsertGLAcc@1001 : Codeunit 5601;
    BEGIN
      IF FirstGenJnl THEN BEGIN
        GenJnlLine.LOCKTABLE;
        FAJnlSetup.GenJnlName(DeprBook2,GenJnlLine,GenJnlNextLineNo);
        NoSeries2 := FAJnlSetup.GetGenNoSeries(GenJnlLine);
        IF DocumentNo = '' THEN
          DocumentNo2 := FAJnlSetup.GetGenJnlDocumentNo(GenJnlLine,FALedgEntry."FA Posting Date",TRUE)
        ELSE
          DocumentNo2 := DocumentNo;
      END;
      FirstGenJnl := FALSE;

      WITH GenJnlLine DO BEGIN
        FALedgEntry.MoveToGenJnl(GenJnlLine);
        VALIDATE("Depreciation Book Code",DeprBookCode2);
        VALIDATE(Amount,ROUND(Amount * ExchangeRate));
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
        FAJnlSetup.FAJnlName(DeprBook2,FAJnlLine,FAJnlNextLineNo);
        NoSeries3 := FAJnlSetup.GetFANoSeries(FAJnlLine);
        IF DocumentNo = '' THEN
          DocumentNo3 := FAJnlSetup.GetFAJnlDocumentNo(FAJnlLine,FALedgEntry."FA Posting Date",TRUE)
        ELSE
          DocumentNo3 := DocumentNo;
      END;
      FirstFAJnl := FALSE;

      WITH FAJnlLine DO BEGIN
        FALedgEntry.MoveToFAJnl(FAJnlLine);
        VALIDATE("Depreciation Book Code",DeprBookCode2);
        VALIDATE(Amount,ROUND(Amount * ExchangeRate));
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
      IF CopyChoices[Index] THEN BEGIN
        IF GLIntegration[Index] AND NOT "Fixed Asset"."Budgeted Asset" THEN
          JournalType := JournalType::GenJnlType
        ELSE
          JournalType := JournalType::FAJnlType
      END ELSE
        JournalType := JournalType::SkipType;
    END;

    LOCAL PROCEDURE GetExchangeRate@1() : Decimal;
    VAR
      ExchangeRate2@1000 : Decimal;
      ExchangeRate3@1001 : Decimal;
    BEGIN
      ExchangeRate2 := DeprBook."Default Exchange Rate";
      IF ExchangeRate2 <= 0 THEN
        ExchangeRate2 := 100;
      IF NOT DeprBook."Use FA Exch. Rate in Duplic." THEN
        ExchangeRate2 := 100;

      ExchangeRate3 := DeprBook2."Default Exchange Rate";
      IF ExchangeRate3 <= 0 THEN
        ExchangeRate3 := 100;
      IF NOT DeprBook2."Use FA Exch. Rate in Duplic." THEN
        ExchangeRate3 := 100;

      EXIT(ExchangeRate2 / ExchangeRate3);
    END;

    PROCEDURE InitializeRequest@4(DeprBookCodeFrom@1000 : Code[10];DeprBookCode2From@1001 : Code[10];StartingDateFrom@1002 : Date;EndingDateFrom@1003 : Date;DocumentNoFrom@1004 : Code[20];PostingDescriptionFrom@1005 : Text[50];BalAccountFrom@1006 : Boolean);
    BEGIN
      DeprBookCode := DeprBookCodeFrom;
      DeprBookCode2 := DeprBookCode2From;
      StartingDate := StartingDateFrom;
      EndingDate := EndingDateFrom;
      DocumentNo := DocumentNoFrom;
      PostingDescription := PostingDescriptionFrom;
      BalAccount := BalAccountFrom;
    END;

    PROCEDURE SetCopyAcquisitionCost@5(Choice@1000 : Boolean);
    BEGIN
      CopyChoices[1] := Choice;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

