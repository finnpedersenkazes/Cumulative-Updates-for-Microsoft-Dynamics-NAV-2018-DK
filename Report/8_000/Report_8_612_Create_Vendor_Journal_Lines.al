OBJECT Report 8612 Create Vendor Journal Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opret debitorkladdelinjer;
               ENU=Create Vendor Journal Lines];
    ProcessingOnly=Yes;
    OnPostReport=BEGIN
                   MESSAGE(Text004);
                 END;

  }
  DATASET
  {
    { 1   ;    ;DataItem;                    ;
               DataItemTable=Table23;
               DataItemTableView=SORTING(No.);
               OnPreDataItem=BEGIN
                               CheckJournalTemplate;
                               CheckBatchName;
                               CheckPostingDate;

                               GenJnlLine.SETRANGE("Journal Template Name",JournalTemplate);
                               GenJnlLine.SETRANGE("Journal Batch Name",BatchName);
                               IF GenJnlLine.FINDLAST THEN
                                 LineNo := GenJnlLine."Line No." + 10000
                               ELSE
                                 LineNo := 10000;

                               GenJnlBatch.GET(JournalTemplate,BatchName);
                               IF TemplateCode <> '' THEN
                                 StdGenJournal.GET(JournalTemplate,TemplateCode);
                             END;

               OnAfterGetRecord=VAR
                                  StdGenJournalLine@1000 : Record 751;
                                BEGIN
                                  GenJnlLine.INIT;
                                  IF GetStandardJournalLine THEN BEGIN
                                    Initialize(StdGenJournal,GenJnlBatch.Name);

                                    StdGenJournalLine.SETRANGE("Journal Template Name",StdGenJournal."Journal Template Name");
                                    StdGenJournalLine.SETRANGE("Standard Journal Code",StdGenJournal.Code);
                                    IF StdGenJournalLine.FINDSET THEN
                                      REPEAT
                                        CopyGenJnlFromStdJnl(StdGenJournalLine,GenJnlLine);
                                        IF PostingDate <> 0D THEN
                                          GenJnlLine.VALIDATE("Posting Date",PostingDate);

                                        GenJnlLine.VALIDATE("Document Type",DocumentTypes);
                                        GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Vendor);
                                        GenJnlLine.VALIDATE("Account No.","No.");
                                        IF (GenJnlBatch."Bal. Account Type" = GenJnlBatch."Bal. Account Type"::"G/L Account") AND
                                           (GenJnlBatch."Bal. Account No." <> '')
                                        THEN BEGIN
                                          GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Bal. Account Type"::"G/L Account");
                                          GenJnlLine.VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
                                        END ELSE
                                          IF "Vendor Posting Group" <> '' THEN
                                            IF VendorPostGrp.GET("Vendor Posting Group") THEN BEGIN
                                              GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Bal. Account Type"::"G/L Account");
                                              GenJnlLine.VALIDATE("Bal. Account No.",VendorPostGrp."Payables Account");
                                            END;

                                        IF DocumentDate <> 0D THEN BEGIN
                                          GenJnlLine.VALIDATE("Posting Date",DocumentDate);
                                          GenJnlLine."Posting Date" := PostingDate;
                                        END;

                                        IF NOT GenJnlLine.INSERT(TRUE) THEN
                                          GenJnlLine.MODIFY(TRUE);
                                      UNTIL StdGenJournalLine.NEXT = 0;
                                  END ELSE BEGIN
                                    GenJnlLine.VALIDATE("Journal Template Name",GenJnlLine.GETFILTER("Journal Template Name"));
                                    GenJnlLine.VALIDATE("Journal Batch Name",BatchName);
                                    GenJnlLine."Line No." := LineNo;
                                    LineNo := LineNo + 10000;

                                    IF PostingDate <> 0D THEN
                                      GenJnlLine.VALIDATE("Posting Date",PostingDate);

                                    GenJnlLine.VALIDATE("Document Type",DocumentTypes);
                                    GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::Vendor);
                                    GenJnlLine.VALIDATE("Account No.","No.");
                                    IF (GenJnlBatch."Bal. Account Type" = GenJnlBatch."Bal. Account Type"::"G/L Account") AND
                                       (GenJnlBatch."Bal. Account No." <> '')
                                    THEN BEGIN
                                      GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Bal. Account Type"::"G/L Account");
                                      GenJnlLine.VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
                                    END ELSE
                                      IF "Vendor Posting Group" <> '' THEN
                                        IF VendorPostGrp.GET("Vendor Posting Group") THEN BEGIN
                                          GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Bal. Account Type"::"G/L Account");
                                          GenJnlLine.VALIDATE("Bal. Account No.",VendorPostGrp."Payables Account");
                                        END;

                                    IF DocumentDate <> 0D THEN BEGIN
                                      GenJnlLine.VALIDATE("Posting Date",DocumentDate);
                                      GenJnlLine."Posting Date" := PostingDate;
                                    END;

                                    IF NOT GenJnlLine.INSERT(TRUE) THEN
                                      GenJnlLine.MODIFY(TRUE);
                                  END;
                                END;

               ReqFilterFields=No.,Currency Code,Country/Region Code,Vendor Posting Group,Blocked }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
                   IF PostingDate = 0D THEN
                     PostingDate := WORKDATE;
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Bilagstype;
                             ENU=Document Type];
                  ToolTipML=[DAN=Angiver typen af det salgsdokument, der behandles af rapporten eller k�rslen.;
                             ENU=Specifies the type of document that is processed by the report or batch job.];
                  OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                   ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DocumentTypes }

      { 4   ;2   ;Field     ;
                  CaptionML=[DAN=Bogf�ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver datoen for k�rslens bogf�ring. Arbejdsdatoen angives som standard, men du kan �ndre den.;
                             ENU=Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PostingDate;
                  OnValidate=BEGIN
                               CheckPostingDate;
                             END;
                              }

      { 6   ;2   ;Field     ;
                  CaptionML=[DAN=Bilagsdato;
                             ENU=Document Date];
                  ToolTipML=[DAN=Angiver den dokumentdato, der vil blive indsat i de oprettede records.;
                             ENU=Specifies the document date that will be inserted on the created records.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DocumentDate }

      { 12  ;2   ;Field     ;
                  CaptionML=[DAN=Kladdetype;
                             ENU=Journal Template];
                  ToolTipML=[DAN=Angiver den kladdeskabelon, som kreditorkladdelinjen er baseret p�.;
                             ENU=Specifies the journal template that the vendor journal is based on.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=JournalTemplate;
                  TableRelation="Gen. Journal Batch".Name;
                  OnValidate=BEGIN
                               CheckJournalTemplate;
                             END;

                  OnLookup=VAR
                             GenJnlTemplate@1001 : Record 80;
                             GenJnlTemplates@1000 : Page 101;
                           BEGIN
                             GenJnlTemplate.SETRANGE(Type,GenJnlTemplate.Type::General);
                             GenJnlTemplate.SETRANGE(Recurring,FALSE);
                             GenJnlTemplates.SETTABLEVIEW(GenJnlTemplate);

                             GenJnlTemplates.LOOKUPMODE := TRUE;
                             GenJnlTemplates.EDITABLE := FALSE;
                             IF GenJnlTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
                               GenJnlTemplates.GETRECORD(GenJnlTemplate);
                               JournalTemplate := GenJnlTemplate.Name;
                             END;
                           END;
                            }

      { 8   ;2   ;Field     ;
                  CaptionML=[DAN=Kladdenavn;
                             ENU=Batch Name];
                  ToolTipML=[DAN=Angiver navnet p� den kladdek�rsel, et personligt kladdelayout, som kladden er baseret p�.;
                             ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=BatchName;
                  TableRelation="Gen. Journal Batch".Name;
                  OnValidate=BEGIN
                               CheckBatchName;
                             END;

                  OnLookup=VAR
                             GenJnlBatches@1001 : Page 251;
                           BEGIN
                             IF JournalTemplate <> '' THEN BEGIN
                               GenJnlBatch.SETRANGE("Journal Template Name",JournalTemplate);
                               GenJnlBatches.SETTABLEVIEW(GenJnlBatch);
                             END;

                             GenJnlBatches.LOOKUPMODE := TRUE;
                             GenJnlBatches.EDITABLE := FALSE;
                             IF GenJnlBatches.RUNMODAL = ACTION::LookupOK THEN BEGIN
                               GenJnlBatches.GETRECORD(GenJnlBatch);
                               BatchName := GenJnlBatch.Name;
                             END;
                           END;
                            }

      { 10  ;2   ;Field     ;
                  CaptionML=[DAN=Standardfinanskladde;
                             ENU=Standard General Journal];
                  ToolTipML=[DAN=Angiver den standardfinanskladde, som k�rslen bruger.;
                             ENU=Specifies the standard general journal that the batch job uses.];
                  ApplicationArea=#Suite;
                  SourceExpr=TemplateCode;
                  TableRelation="Standard General Journal".Code;
                  OnLookup=VAR
                             StdGenJournal1@1005 : Record 750;
                             StdGenJnls@1000 : Page 750;
                           BEGIN
                             IF JournalTemplate <> '' THEN BEGIN
                               StdGenJournal1.SETRANGE("Journal Template Name",JournalTemplate);
                               StdGenJnls.SETTABLEVIEW(StdGenJournal1);
                             END;

                             StdGenJnls.LOOKUPMODE := TRUE;
                             StdGenJnls.EDITABLE := FALSE;
                             IF StdGenJnls.RUNMODAL = ACTION::LookupOK THEN BEGIN
                               StdGenJnls.GETRECORD(StdGenJournal1);
                               TemplateCode := StdGenJournal1.Code;
                             END;
                           END;
                            }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      StdGenJournal@1007 : Record 750;
      GenJnlBatch@1011 : Record 232;
      GenJnlLine@1006 : Record 81;
      LastGenJnlLine@1005 : Record 81;
      VendorPostGrp@1009 : Record 93;
      DocumentTypes@1000 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
      PostingDate@1001 : Date;
      DocumentDate@1002 : Date;
      BatchName@1003 : Code[10];
      TemplateCode@1004 : Code[20];
      LineNo@1008 : Integer;
      JournalTemplate@1015 : Text[10];
      Text001@1016 : TextConst 'DAN=Skabelonen for den generelle kladde har ikke et navn.;ENU=Gen. Journal Template name is blank.';
      Text002@1013 : TextConst 'DAN=Den generelle massebogf�ringskladde har ikke et navn.;ENU=Gen. Journal Batch name is blank.';
      Text004@1017 : TextConst 'DAN=De generelle kladdelinjer er oprettet.;ENU=General journal lines are successfully created.';
      PostingDateIsEmptyErr@1010 : TextConst 'DAN=Bogf�ringsdatoen er tom.;ENU=The posting date is empty.';

    LOCAL PROCEDURE GetStandardJournalLine@3() : Boolean;
    VAR
      StdGenJounalLine@1000 : Record 751;
    BEGIN
      IF TemplateCode = '' THEN
        EXIT;
      StdGenJounalLine.SETRANGE("Journal Template Name",StdGenJournal."Journal Template Name");
      StdGenJounalLine.SETRANGE("Standard Journal Code",StdGenJournal.Code);
      EXIT(StdGenJounalLine.FINDFIRST);
    END;

    [External]
    PROCEDURE Initialize@15(VAR StdGenJnl@1001 : Record 750;JnlBatchName@1000 : Code[10]);
    BEGIN
      GenJnlLine."Journal Template Name" := StdGenJnl."Journal Template Name";
      GenJnlLine."Journal Batch Name" := JnlBatchName;
      GenJnlLine.SETRANGE("Journal Template Name",StdGenJnl."Journal Template Name");
      GenJnlLine.SETRANGE("Journal Batch Name",JnlBatchName);

      LastGenJnlLine.SETRANGE("Journal Template Name",StdGenJnl."Journal Template Name");
      LastGenJnlLine.SETRANGE("Journal Batch Name",JnlBatchName);

      IF LastGenJnlLine.FINDLAST THEN;

      GenJnlBatch.SETRANGE("Journal Template Name",StdGenJnl."Journal Template Name");
      GenJnlBatch.SETRANGE(Name,JnlBatchName);

      IF GenJnlBatch.FINDFIRST THEN;
    END;

    LOCAL PROCEDURE CopyGenJnlFromStdJnl@1(StdGenJnlLine@1001 : Record 751;VAR GenJnlLine@1002 : Record 81);
    VAR
      GenJnlManagement@1000 : Codeunit 230;
      Balance@1007 : Decimal;
      TotalBalance@1006 : Decimal;
      ShowBalance@1005 : Boolean;
      ShowTotalBalance@1004 : Boolean;
    BEGIN
      GenJnlLine.INIT;
      GenJnlLine."Line No." := 0;
      GenJnlManagement.CalcBalance(GenJnlLine,LastGenJnlLine,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
      GenJnlLine.SetUpNewLine(LastGenJnlLine,Balance,TRUE);
      IF LastGenJnlLine."Line No." <> 0 THEN
        GenJnlLine."Line No." := LastGenJnlLine."Line No." + 10000
      ELSE
        GenJnlLine."Line No." := 10000;

      GenJnlLine.TRANSFERFIELDS(StdGenJnlLine,FALSE);
      GenJnlLine.UpdateLineBalance;
      GenJnlLine.VALIDATE("Currency Code");

      IF GenJnlLine."VAT Prod. Posting Group" <> '' THEN
        GenJnlLine.VALIDATE("VAT Prod. Posting Group");
      IF (GenJnlLine."VAT %" <> 0) AND GenJnlBatch."Allow VAT Difference" THEN
        GenJnlLine.VALIDATE("VAT Amount",StdGenJnlLine."VAT Amount");
      GenJnlLine.VALIDATE("Bal. VAT Prod. Posting Group");

      IF GenJnlBatch."Allow VAT Difference" THEN
        GenJnlLine.VALIDATE("Bal. VAT Amount",StdGenJnlLine."Bal. VAT Amount");
      GenJnlLine.INSERT(TRUE);

      LastGenJnlLine := GenJnlLine;
    END;

    [External]
    PROCEDURE InitializeRequest@2(DocumentTypesFrom@1000 : Option;PostingDateFrom@1001 : Date;DocumentDateFrom@1002 : Date);
    BEGIN
      DocumentTypes := DocumentTypesFrom;
      PostingDate := PostingDateFrom;
      DocumentDate := DocumentDateFrom;
    END;

    [External]
    PROCEDURE InitializeRequestTemplate@4(JournalTemplateFrom@1000 : Text[10];BatchNameFrom@1001 : Code[10];TemplateCodeFrom@1002 : Code[20]);
    BEGIN
      JournalTemplate := JournalTemplateFrom;
      BatchName := BatchNameFrom;
      TemplateCode := TemplateCodeFrom;
    END;

    LOCAL PROCEDURE CheckPostingDate@24();
    BEGIN
      IF PostingDate = 0D THEN
        ERROR(PostingDateIsEmptyErr);
    END;

    LOCAL PROCEDURE CheckBatchName@32();
    BEGIN
      IF BatchName = '' THEN
        ERROR(Text002);
    END;

    LOCAL PROCEDURE CheckJournalTemplate@33();
    BEGIN
      IF JournalTemplate = '' THEN
        ERROR(Text001);
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

