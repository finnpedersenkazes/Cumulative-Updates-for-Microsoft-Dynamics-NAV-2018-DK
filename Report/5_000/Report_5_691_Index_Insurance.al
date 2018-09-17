OBJECT Report 5691 Index Insurance
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Indekser forsikring;
               ENU=Index Insurance];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  IF PostingDate = 0D THEN
                    ERROR(Text000,InsuranceJnlLine.FIELDCAPTION("Posting Date"));
                  IF PostingDate <> NORMALDATE(PostingDate) THEN
                    ERROR(Text001);
                  IF IndexFigure = 100 THEN
                    ERROR(Text002);
                  IF IndexFigure <= 0 THEN
                    ERROR(Text003);
                  FASetup.GET;
                  FASetup.TESTFIELD("Insurance Depr. Book");
                  DeprBook.GET(FASetup."Insurance Depr. Book");
                  InsuranceJnlLine.LOCKTABLE;
                  FAJnlSetup.InsuranceJnlName(DeprBook,InsuranceJnlLine,NextLineNo);
                  NoSeries := FAJnlSetup.GetInsuranceNoSeries(InsuranceJnlLine);
                  IF DocumentNo = '' THEN
                    DocumentNo := FAJnlSetup.GetInsuranceJnlDocumentNo(InsuranceJnlLine,PostingDate);
                  InsuranceJnlLine."Posting Date" := PostingDate;
                  Window.OPEN(Text004);
                END;

  }
  DATASET
  {
    { 3794;    ;DataItem;                    ;
               DataItemTable=Table5600;
               OnPreDataItem=BEGIN
                               InsCoverageLedgEntry.SETCURRENTKEY("FA No.","Insurance No.");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Blocked OR Inactive THEN
                                    CurrReport.SKIP;
                                  Window.UPDATE(1,"No.");
                                  InsuranceTmp.DELETEALL;
                                  InsCoverageLedgEntry.SETRANGE("FA No.","No.");
                                  InsCoverageLedgEntry.SETRANGE("Posting Date",0D,PostingDate);
                                  IF InsCoverageLedgEntry.FIND('-') THEN
                                    REPEAT
                                      InsuranceTmp."No." := InsCoverageLedgEntry."Insurance No.";
                                      IF InsuranceTmp.INSERT THEN BEGIN
                                        InsCoverageLedgEntry.SETRANGE("Insurance No.",InsCoverageLedgEntry."Insurance No.");
                                        InsCoverageLedgEntry.CALCSUMS(Amount);
                                        InsCoverageLedgEntry.SETRANGE("Insurance No.");
                                        IF InsCoverageLedgEntry.Amount <> 0 THEN BEGIN
                                          IF Insurance.GET(InsCoverageLedgEntry."Insurance No.") THEN BEGIN
                                            IF Insurance.Blocked THEN
                                              CurrReport.SKIP;
                                          END ELSE
                                            CurrReport.SKIP;
                                          InsuranceJnlLine."Line No." := 0;
                                          FAJnlSetup.SetInsuranceJnlTrailCodes(InsuranceJnlLine);
                                          InsuranceJnlLine.VALIDATE("Insurance No.",InsCoverageLedgEntry."Insurance No.");
                                          InsuranceJnlLine.VALIDATE("FA No.","No.");
                                          InsuranceJnlLine.VALIDATE(
                                            Amount,ROUND(InsCoverageLedgEntry.Amount * (IndexFigure / 100 - 1)));
                                          InsuranceJnlLine."Document No." := DocumentNo;
                                          InsuranceJnlLine."Posting No. Series" := NoSeries;
                                          InsuranceJnlLine.Description := PostingDescription;
                                          InsuranceJnlLine."Index Entry" := TRUE;
                                          NextLineNo := NextLineNo + 10000;
                                          InsuranceJnlLine."Line No." := NextLineNo;
                                          InsuranceJnlLine.INSERT(TRUE);
                                        END;
                                      END;
                                    UNTIL InsCoverageLedgEntry.NEXT = 0;
                                END;

               ReqFilterFields=No.,FA Class Code,FA Subclass Code }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 5   ;2   ;Field     ;
                  CaptionML=[DAN=Indekstal;
                             ENU=Index Figure];
                  ToolTipML=[DAN=Angiver et indekstal, der bruges til at beregne de indeksbel›b, som overf›res til kladden. Du skal f.eks. indtaste 102, hvis du vil indeksere med 2 %. Hvis du vil indeksere med -3 %, skal du indtaste 97 i dette felt.;
                             ENU="Specifies an index figure that is to calculate the index amounts entered in the journal. For example, if you want to index by 2%, enter 102 in this field; if you want to index by -3% percent, enter 97 in this field."];
                  ApplicationArea=#FixedAssets;
                  DecimalPlaces=0:8;
                  SourceExpr=IndexFigure }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Bogf›ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver den bogf›ringsdato, som skal bruges i forbindelse med k›rslen. Denne dato vises i feltet Bogf›ringsdato p† forsikringskladdelinjerne.;
                             ENU=Specifies the posting date to be used by the batch job. This date appears in the Posting Date field on the insurance journal lines.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=PostingDate }

      { 8   ;2   ;Field     ;
                  CaptionML=[DAN=Bilagsnr.;
                             ENU=Document No.];
                  ToolTipML=[DAN=Angiver det n‘ste tilg‘ngelige nummer p† den resulterende kladdelinje, hvis du lader feltet v‘re tomt. Hvis der ikke er konfigureret nogen nummerserie, skal du angive det bilagsnummer, du vil knytte til den resulterende kladdelinje.;
                             ENU=Specifies, if you leave the field empty, the next available number on the resulting journal line. If a number series is not set up, enter the document number that you want assigned to the resulting journal line.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=DocumentNo }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Bogf›ringsbeskrivelse;
                             ENU=Posting Description];
                  ToolTipML=[DAN=Angiver en bogf›ringsbeskrivelse, som skal vises i de oprettede kladdelinjer.;
                             ENU=Specifies a posting description to appear on the resulting journal lines.];
                  ApplicationArea=#FixedAssets;
                  SourceExpr=PostingDescription }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du skal indtaste %1.;ENU=You must specify %1.';
      Text001@1001 : TextConst 'DAN=Bogf›ringsdato m† ikke v‘re en ultimodato.;ENU=Posting Date must not be a closing date.';
      Text002@1002 : TextConst 'DAN=Indekstal m† ikke v‘re 100.;ENU=Index Figure must not be 100.';
      Text003@1003 : TextConst 'DAN=Indekstallet skal v‘re positivt.;ENU=Index Figure must be positive.';
      Text004@1004 : TextConst 'DAN=Indekser forsikring   #1##########;ENU=Indexing insurance    #1##########';
      FASetup@1005 : Record 5603;
      DeprBook@1006 : Record 5611;
      Insurance@1007 : Record 5628;
      FAJnlSetup@1008 : Record 5605;
      InsuranceTmp@1009 : TEMPORARY Record 5628;
      InsCoverageLedgEntry@1010 : Record 5629;
      InsuranceJnlLine@1011 : Record 5635;
      Window@1012 : Dialog;
      PostingDate@1013 : Date;
      IndexFigure@1014 : Decimal;
      DocumentNo@1015 : Code[20];
      NoSeries@1016 : Code[20];
      PostingDescription@1017 : Text[50];
      NextLineNo@1018 : Integer;

    PROCEDURE InitializeRequest@1(DocumentNoFrom@1003 : Code[20];PostingDescriptionFrom@1002 : Text[50];PostingDateFrom@1001 : Date;IndexFigureFrom@1000 : Decimal);
    BEGIN
      DocumentNo := DocumentNoFrom;
      PostingDescription := PostingDescriptionFrom;
      PostingDate := PostingDateFrom;
      IndexFigure := IndexFigureFrom;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

