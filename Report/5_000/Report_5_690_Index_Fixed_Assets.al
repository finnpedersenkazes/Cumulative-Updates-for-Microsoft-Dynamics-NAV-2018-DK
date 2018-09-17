OBJECT Report 5690 Index Fixed Assets
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836,NAVDK11.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Indekser anl‘g;
               ENU=Index Fixed Assets];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  IF FAPostingDate = 0D THEN
                    ERROR(Text000,FAJnlLine.FIELDCAPTION("FA Posting Date"));
                  IF FAPostingDate <> NORMALDATE(FAPostingDate) THEN
                    ERROR(Text001);

                  IF PostingDate = 0D THEN
                    PostingDate := FAPostingDate;
                  DeprBook.GET(DeprBookCode);
                  DeprBook.TESTFIELD("Allow Indexation",TRUE);
                  IF DeprBook."Use Same FA+G/L Posting Dates" AND (FAPostingDate <> PostingDate) THEN
                    ERROR(
                      Text002,
                      FAJnlLine.FIELDCAPTION("FA Posting Date"),
                      FAJnlLine.FIELDCAPTION("Posting Date"),
                      DeprBook.FIELDCAPTION("Use Same FA+G/L Posting Dates"),
                      FALSE,
                      DeprBook.TABLECAPTION,
                      DeprBook.FIELDCAPTION(Code),
                      DeprBook.Code);

                  DeprBook.IndexGLIntegration(GLIntegration);
                  FirstGenJnl := TRUE;
                  FirstFAJnl := TRUE;

                  FALedgEntry.SETCURRENTKEY(
                    "FA No.","Depreciation Book Code","FA Posting Category","FA Posting Type","FA Posting Date");
                  FALedgEntry.SETRANGE("Depreciation Book Code",DeprBookCode);
                  FALedgEntry.SETRANGE("FA Posting Category",FALedgEntry."FA Posting Category"::" ");
                  FALedgEntry.SETRANGE("FA Posting Date",0D,FAPostingDate);

                  MaintenanceLedgEntry.SETCURRENTKEY(
                    "FA No.","Depreciation Book Code","FA Posting Date");
                  MaintenanceLedgEntry.SETRANGE("Depreciation Book Code",DeprBookCode);
                  MaintenanceLedgEntry.SETRANGE("FA Posting Date",0D,FAPostingDate);

                  Window.OPEN(Text003);
                END;

  }
  DATASET
  {
    { 3794;    ;DataItem;                    ;
               DataItemTable=Table5600;
               OnAfterGetRecord=BEGIN
                                  IF NOT FADeprBook.GET("No.",DeprBookCode) THEN
                                    CurrReport.SKIP;
                                  Window.UPDATE(1,"No.");

                                  IF Inactive OR
                                     Blocked OR
                                     (FADeprBook."Disposal Date" > 0D) OR
                                     (FADeprBook."Acquisition Date" = 0D) OR
                                     (FADeprBook."Acquisition Date" > FAPostingDate)
                                  THEN
                                    CurrReport.SKIP;

                                  FALedgEntry.SETRANGE("FA No.","No.");
                                  MaintenanceLedgEntry.SETRANGE("FA No.","No.");

                                  i := 0;
                                  WHILE i < 9 DO BEGIN
                                    i := i + 1;
                                    IF i = 7 THEN
                                      i := 8;
                                    IndexAmount := 0;
                                    IF IndexChoices[i] THEN BEGIN
                                      IF i = 1 THEN
                                        FALedgEntry.SETRANGE("FA Posting Type",FALedgEntry."FA Posting Type"::"Acquisition Cost");
                                      IF i = 2 THEN
                                        FALedgEntry.SETRANGE("FA Posting Type",FALedgEntry."FA Posting Type"::Depreciation);
                                      IF i = 3 THEN
                                        FALedgEntry.SETRANGE("FA Posting Type",FALedgEntry."FA Posting Type"::"Write-Down");
                                      IF i = 4 THEN
                                        FALedgEntry.SETRANGE("FA Posting Type",FALedgEntry."FA Posting Type"::Appreciation);
                                      IF i = 5 THEN
                                        FALedgEntry.SETRANGE("FA Posting Type",FALedgEntry."FA Posting Type"::"Custom 1");
                                      IF i = 6 THEN
                                        FALedgEntry.SETRANGE("FA Posting Type",FALedgEntry."FA Posting Type"::"Custom 2");
                                      IF i = 9 THEN
                                        FALedgEntry.SETRANGE("FA Posting Type",FALedgEntry."FA Posting Type"::"Salvage Value");
                                      IF i = 8 THEN BEGIN
                                        MaintenanceLedgEntry.CALCSUMS(Amount);
                                        IndexAmount := MaintenanceLedgEntry.Amount;
                                      END ELSE BEGIN
                                        FALedgEntry.CALCSUMS(Amount);
                                        IndexAmount := FALedgEntry.Amount;
                                      END;
                                      IndexAmount :=
                                        DepreciationCalc.CalcRounding(DeprBookCode,IndexAmount * (IndexFigure / 100 - 1));
                                      IF NOT GLIntegration[i] OR "Budgeted Asset" THEN
                                        InsertFAJnlLine("No.",IndexAmount,i - 1)
                                      ELSE
                                        InsertGenJnlLine("No.",IndexAmount,i - 1);
                                    END;
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

      { 5   ;2   ;Field     ;
                  Name=IndexFigure;
                  CaptionML=[DAN=Indekstal;
                             ENU=Index Figure];
                  ToolTipML=[DAN=Angiver et indekstal, der bruges til at beregne de indeksbel›b, som overf›res til kladden. Du skal f.eks. indtaste 102, hvis du vil indeksere med 2 %. Hvis du vil indeksere med -3 %, skal du indtaste 97 i dette felt.;
                             ENU="Specifies an index figure that is to calculate the index amounts entered in the journal. For example, if you want to index by 2%, enter 102 in this field; if you want to index by -3% percent, enter 97 in this field."];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=IndexFigure;
                  MinValue=0 }

      { 9   ;2   ;Field     ;
                  Name=FAPostingDate;
                  CaptionML=[DAN=Bogf›ringsdato for anl‘g;
                             ENU=FA Posting Date];
                  ToolTipML=[DAN=Angiver den bogf›ringsdato for anl‘gget, som skal bruges i forbindelse med k›rslen. K›rslen omfatter anl‘gsposter op til denne dato. Datoen vises i feltet Bogf›ringsdato for anl‘g i de kladdelinjer, som k›rslen opretter. Hvis du har markeret feltet Brug ens anl‘gsdato+bogf.dato i den afskrivningsprofil, som blev anvendt til k›rslen, skal denne dato v‘re den samme som den bogf›ringsdato, der er angivet i feltet Bogf›ringsdato.;
                             ENU=Specifies the fixed asset posting date to be used by the batch job. The batch job includes ledger entries up to this date. This date appears in the FA Posting Date field in the resulting journal lines. If the Use Same FA+G/L Posting Dates field has been activated in the depreciation book that is used in the batch job, then this date must be the same as the posting date entered in the Posting Date field.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=FAPostingDate }

      { 11  ;2   ;Field     ;
                  CaptionML=[DAN=Bogf›ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver den bogf›ringsdato, som skal bruges i forbindelse med k›rslen. Datoen vises i feltet Bogf›ringsdato i de anl‘gskladdelinjer, der oprettes, for anl‘g, som er integreret med finans. Hvis du har markeret feltet Brug ens anl‘gsdato+bogf.dato i den afskrivningsprofil, som blev anvendt til k›rslen, skal denne dato v‘re den samme som den bogf›ringsdato for anl‘gget, der er angivet i feltet Bogf›ringsdato for anl‘g.;
                             ENU=Specifies the posting date to be used by the batch job. This date appears in the Posting Date field in the resulting FA G/L journal lines for assets that are integrated with the general ledger. If the Use Same FA+G/L Posting Dates field has been activated in the depreciation book that is used in the batch job, then this date must be the same as the fixed asset posting date entered in the FA Posting Date field.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=PostingDate }

      { 23  ;2   ;Field     ;
                  CaptionML=[DAN=Bilagsnr.;
                             ENU=Document No.];
                  ToolTipML=[DAN=Angiver det n‘ste tilg‘ngelige nummer p† den resulterende kladdelinje, hvis du lader feltet v‘re tomt. Hvis der ikke er konfigureret nogen nummerserie, skal du angive det bilagsnummer, du vil knytte til den resulterende kladdelinje.;
                             ENU=Specifies, if you leave the field empty, the next available number on the resulting journal line. If a number series is not set up, enter the document number that you want assigned to the resulting journal line.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=DocumentNo }

      { 13  ;2   ;Field     ;
                  CaptionML=[DAN=Bogf›ringsbeskrivelse;
                             ENU=Posting Description];
                  ToolTipML=[DAN=Angiver en bogf›ringsbeskrivelse, som skal vises i de oprettede kladdelinjer.;
                             ENU=Specifies a posting description to appear on the resulting journal lines.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=PostingDescription }

      { 20  ;2   ;Field     ;
                  Name=InsertBalAccount;
                  CaptionML=[DAN=Inds‘t modkonto;
                             ENU=Insert Bal. Account];
                  ToolTipML=[DAN=Angiver, om du ›nsker, at k›rslen automatisk skal inds‘tte modkonti p† de kladdelinjer, som k›rslen opretter. K›rslen bruger de konti, du har oprettet i tabellen Anl‘gsbogf›ringsgruppe.;
                             ENU=Specifies if you want the batch job to automatically insert balancing accounts in the resulting journal. The batch job uses the accounts that you defined in the FA Posting Group table.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=BalAccount }

      { 4   ;2   ;Group     ;
                  CaptionML=[DAN=Indekser;
                             ENU=Index] }

      { 3   ;3   ;Field     ;
                  CaptionML=[DAN=Anskaffelse;
                             ENU=Acquisition Cost];
                  ToolTipML=[DAN=Angiver den samlede procentdel af anskaffelsen, som kan allokeres, n†r anskaffelsen bogf›res.;
                             ENU=Specifies the total percentage of acquisition cost that can be allocated when acquisition cost is posted.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=IndexChoices[1] }

      { 1   ;3   ;Field     ;
                  CaptionML=[DAN=Afskrivning;
                             ENU=Depreciation];
                  ToolTipML=[DAN=Angiver, om du have k›rslen til at foretage indeksering af anl‘g for transaktionstypen Afskrivning.;
                             ENU=Specifies if you want to index for fixed assets of transaction type Depreciation in the batch job.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=IndexChoices[2] }

      { 2   ;3   ;Field     ;
                  CaptionML=[DAN=Nedskrivning;
                             ENU=Write-Down];
                  ToolTipML=[DAN=Angiver, om du have k›rslen til at foretage indeksering af anl‘g for transaktionstypen Nedskrivning.;
                             ENU=Specifies if you want to index for fixed assets of transaction type Write-down in the batch job.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=IndexChoices[3] }

      { 7   ;3   ;Field     ;
                  CaptionML=[DAN=Opskrivning;
                             ENU=Appreciation];
                  ToolTipML=[DAN=Angiver, om opskrivninger er inkluderet i k›rslen.;
                             ENU=Specifies if appreciations are included by the batch job.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=IndexChoices[4] }

      { 18  ;3   ;Field     ;
                  CaptionML=[DAN=Skrapv‘rdi;
                             ENU=Salvage Value];
                  ToolTipML=[DAN=Angiver, om du have k›rslen til at foretage indeksering af anl‘g for transaktionstypen Skrapv‘rdi.;
                             ENU=Specifies if you want to index for fixed assets of transaction type Salvage Value in the batch job.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=IndexChoices[9] }

      { 19  ;3   ;Field     ;
                  CaptionML=[DAN=Reparation;
                             ENU=Maintenance];
                  ToolTipML=[DAN=Angiver, om du have k›rslen til at foretage indeksering af anl‘g for transaktionstypen Skrapv‘rdi.;
                             ENU=Specifies if you want to index for fixed assets of transaction type Salvage Value in the batch job.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=IndexChoices[8] }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du skal indtaste %1.;ENU=You must specify %1.';
      Text001@1001 : TextConst 'DAN=Bogf›ringsdato for anl‘g m† ikke v‘re en ultimodato.;ENU=FA Posting Date must not be a closing date.';
      Text002@1002 : TextConst 'DAN="%1 og %2 skal v‘re ens. %3 skal v‘re %4 i %5 %6 = %7.";ENU="%1 and %2 must be identical. %3 must be %4 in %5 %6 = %7."';
      Text003@1003 : TextConst 'DAN=Indekserer anl‘g       #1##########;ENU=Indexing fixed asset   #1##########';
      GenJnlLine@1004 : Record 81;
      FASetup@1005 : Record 5603;
      FAJnlLine@1006 : Record 5621;
      DeprBook@1007 : Record 5611;
      FADeprBook@1008 : Record 5612;
      FALedgEntry@1009 : Record 5601;
      MaintenanceLedgEntry@1010 : Record 5625;
      FAJnlSetup@1011 : Record 5605;
      DepreciationCalc@1012 : Codeunit 5616;
      Window@1013 : Dialog;
      FAPostingDate@1014 : Date;
      IndexFigure@1015 : Decimal;
      IndexChoices@1016 : ARRAY [9] OF Boolean;
      IndexAmount@1017 : Decimal;
      GLIntegration@1018 : ARRAY [9] OF Boolean;
      FirstGenJnl@1019 : Boolean;
      FirstFAJnl@1020 : Boolean;
      PostingDate@1021 : Date;
      DocumentNo@1022 : Code[20];
      DocumentNo2@1023 : Code[20];
      DocumentNo3@1024 : Code[20];
      NoSeries2@1025 : Code[20];
      Noseries3@1026 : Code[20];
      PostingDescription@1027 : Text[50];
      DeprBookCode@1028 : Code[10];
      BalAccount@1029 : Boolean;
      FAJnlNextLineNo@1030 : Integer;
      GenJnlNextLineNo@1031 : Integer;
      i@1032 : Integer;

    LOCAL PROCEDURE InsertGenJnlLine@2(FANo@1000 : Code[20];IndexAmount@1001 : Decimal;PostingType@1002 : 'Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance,Salvage Value');
    VAR
      FAInsertGLAcc@1003 : Codeunit 5601;
    BEGIN
      IF IndexAmount = 0 THEN
        EXIT;
      IF FirstGenJnl THEN BEGIN
        GenJnlLine.LOCKTABLE;
        FAJnlSetup.GenJnlName(DeprBook,GenJnlLine,GenJnlNextLineNo);
        NoSeries2 := FAJnlSetup.GetGenNoSeries(GenJnlLine);
        IF DocumentNo = '' THEN
          DocumentNo2 := FAJnlSetup.GetGenJnlDocumentNo(GenJnlLine,FAPostingDate,TRUE)
        ELSE
          DocumentNo2 := DocumentNo;
        FirstGenJnl := FALSE;
      END;
      WITH GenJnlLine DO BEGIN
        INIT;
        "Line No." := 0;
        FAJnlSetup.SetGenJnlTrailCodes(GenJnlLine);
        "FA Posting Date" := FAPostingDate;
        "Posting Date" := PostingDate;
        IF "Posting Date" = "FA Posting Date" THEN
          "FA Posting Date" := 0D;
        "FA Posting Type" := PostingType + 1;
        "Account Type" := "Account Type"::"Fixed Asset";
        VALIDATE("Account No.",FANo);
        "Document No." := DocumentNo2;
        "Posting No. Series" := NoSeries2;
        Description := PostingDescription;
        VALIDATE("Depreciation Book Code",DeprBookCode);
        VALIDATE(Amount,IndexAmount);
        "Index Entry" := TRUE;
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

    LOCAL PROCEDURE InsertFAJnlLine@3(FANo@1000 : Code[20];IndexAmount@1001 : Decimal;PostingType@1002 : 'Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance,Salvage Value');
    BEGIN
      IF IndexAmount = 0 THEN
        EXIT;
      IF FirstFAJnl THEN BEGIN
        FAJnlLine.LOCKTABLE;
        FAJnlSetup.FAJnlName(DeprBook,FAJnlLine,FAJnlNextLineNo);
        Noseries3 := FAJnlSetup.GetFANoSeries(FAJnlLine);
        IF DocumentNo = '' THEN
          DocumentNo3 := FAJnlSetup.GetFAJnlDocumentNo(FAJnlLine,FAPostingDate,TRUE)
        ELSE
          DocumentNo3 := DocumentNo;
        FirstFAJnl := FALSE;
      END;
      WITH FAJnlLine DO BEGIN
        INIT;
        "Line No." := 0;
        FAJnlSetup.SetFAJnlTrailCodes(FAJnlLine);
        "Posting Date" := PostingDate;
        "FA Posting Date" := FAPostingDate;
        IF "Posting Date" = "FA Posting Date" THEN
          "Posting Date" := 0D;
        "FA Posting Type" := PostingType;
        VALIDATE("FA No.",FANo);
        "Document No." := DocumentNo3;
        "Posting No. Series" := Noseries3;
        Description := PostingDescription;
        VALIDATE("Depreciation Book Code",DeprBookCode);
        VALIDATE(Amount,IndexAmount);
        "Index Entry" := TRUE;
        FAJnlNextLineNo := FAJnlNextLineNo + 10000;
        "Line No." := FAJnlNextLineNo;
        INSERT(TRUE);
      END;
    END;

    PROCEDURE InitializeRequest@1(DeprBookCodeFrom@1000 : Code[10];IndexFigureFrom@1001 : Decimal;FAPostingDateFrom@1002 : Date;PostingDateFrom@1003 : Date;DocumentNoFrom@1004 : Code[20];PostingDescriptionFrom@1005 : Text[50];BalAccountFrom@1006 : Boolean);
    BEGIN
      DeprBookCode := DeprBookCodeFrom;
      IndexFigure := IndexFigureFrom;
      FAPostingDate := FAPostingDateFrom;
      PostingDate := PostingDateFrom;
      DocumentNo := DocumentNoFrom;
      PostingDescription := PostingDescriptionFrom;
      BalAccount := BalAccountFrom;
    END;

    PROCEDURE SetIndexAcquisitionCost@4(IndexChoice@1000 : Boolean);
    BEGIN
      IndexChoices[1] := IndexChoice;
    END;

    PROCEDURE SetIndexDepreciation@5(IndexChoice@1000 : Boolean);
    BEGIN
      IndexChoices[2] := IndexChoice;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

