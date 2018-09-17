OBJECT Report 8613 Create Item Journal Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opret varekladdelinjer;
               ENU=Create Item Journal Lines];
    ProcessingOnly=Yes;
    OnPostReport=BEGIN
                   MESSAGE(Text004);
                 END;

  }
  DATASET
  {
    { 1   ;    ;DataItem;                    ;
               DataItemTable=Table27;
               DataItemTableView=SORTING(No.);
               OnPreDataItem=BEGIN
                               CheckJournalTemplate;
                               CheckBatchName;
                               CheckPostingDate;

                               ItemJnlLine.SETRANGE("Journal Template Name",JournalTemplate);
                               ItemJnlLine.SETRANGE("Journal Batch Name",BatchName);
                               IF ItemJnlLine.FINDLAST THEN
                                 LineNo := ItemJnlLine."Line No." + 10000
                               ELSE
                                 LineNo := 10000;

                               ItemJnlBatch.GET(JournalTemplate,BatchName);
                               IF TemplateCode <> '' THEN
                                 StdItemJnl.GET(JournalTemplate,TemplateCode);
                             END;

               OnAfterGetRecord=VAR
                                  StdItemJnlLine@1000 : Record 753;
                                BEGIN
                                  ItemJnlLine.INIT;
                                  IF GetStandardJournalLine THEN BEGIN
                                    Initialize(StdItemJnl,ItemJnlBatch.Name);

                                    StdItemJnlLine.SETRANGE("Journal Template Name",StdItemJnl."Journal Template Name");
                                    StdItemJnlLine.SETRANGE("Standard Journal Code",StdItemJnl.Code);
                                    IF StdItemJnlLine.FINDSET THEN
                                      REPEAT
                                        CopyItemJnlFromStdJnl(StdItemJnlLine,ItemJnlLine);
                                        ItemJnlLine.VALIDATE("Entry Type",EntryTypes);
                                        ItemJnlLine.VALIDATE("Item No.","No.");

                                        IF PostingDate <> 0D THEN
                                          ItemJnlLine.VALIDATE("Posting Date",PostingDate);

                                        IF DocumentDate <> 0D THEN BEGIN
                                          ItemJnlLine.VALIDATE("Posting Date",DocumentDate);
                                          ItemJnlLine."Posting Date" := PostingDate;
                                        END;

                                        IF NOT ItemJnlLine.INSERT(TRUE) THEN
                                          ItemJnlLine.MODIFY(TRUE);
                                      UNTIL StdItemJnlLine.NEXT = 0;
                                  END ELSE BEGIN
                                    ItemJnlLine.VALIDATE("Journal Template Name",ItemJnlLine.GETFILTER("Journal Template Name"));
                                    ItemJnlLine.VALIDATE("Journal Batch Name",BatchName);
                                    ItemJnlLine."Line No." := LineNo;
                                    LineNo := LineNo + 10000;

                                    ItemJnlLine.VALIDATE("Entry Type",EntryTypes);
                                    ItemJnlLine.VALIDATE("Item No.","No.");

                                    IF PostingDate <> 0D THEN
                                      ItemJnlLine.VALIDATE("Posting Date",PostingDate);

                                    IF DocumentDate <> 0D THEN BEGIN
                                      ItemJnlLine.VALIDATE("Posting Date",DocumentDate);
                                      ItemJnlLine."Posting Date" := PostingDate;
                                    END;

                                    IF NOT ItemJnlLine.INSERT(TRUE) THEN
                                      ItemJnlLine.MODIFY(TRUE);
                                  END;
                                END;

               ReqFilterFields=No.,Statistics Group,Vendor No.,Blocked }

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
                  CaptionML=[DAN=Posttype;
                             ENU=Entry Type];
                  ToolTipML=[DAN=Angiver posttypen.;
                             ENU=Specifies the entry type.];
                  OptionCaptionML=[DAN=K�b,Salg,Opregulering,Nedregulering;
                                   ENU=Purchase,Sale,Positive Adjmt.,Negative Adjmt.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=EntryTypes }

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
                  ToolTipML=[DAN=Angiver den kladdeskabelon, som varekladden er baseret p�.;
                             ENU=Specifies the journal template that the item journal is based on.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=JournalTemplate;
                  TableRelation="Gen. Journal Batch".Name;
                  OnValidate=BEGIN
                               CheckJournalTemplate;
                             END;

                  OnLookup=VAR
                             ItemJnlTemplate@1001 : Record 82;
                             ItemJnlTemplates@1000 : Page 102;
                           BEGIN
                             ItemJnlTemplate.SETRANGE(Type,ItemJnlTemplate.Type::Item);
                             ItemJnlTemplate.SETRANGE(Recurring,FALSE);
                             ItemJnlTemplates.SETTABLEVIEW(ItemJnlTemplate);

                             ItemJnlTemplates.LOOKUPMODE := TRUE;
                             ItemJnlTemplates.EDITABLE := FALSE;
                             IF ItemJnlTemplates.RUNMODAL = ACTION::LookupOK THEN BEGIN
                               ItemJnlTemplates.GETRECORD(ItemJnlTemplate);
                               JournalTemplate := ItemJnlTemplate.Name;
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
                  OnValidate=BEGIN
                               CheckBatchName;
                             END;

                  OnLookup=VAR
                             ItemJnlBatches@1000 : Page 262;
                           BEGIN
                             IF JournalTemplate <> '' THEN BEGIN
                               ItemJnlBatch.SETRANGE("Journal Template Name",JournalTemplate);
                               ItemJnlBatches.SETTABLEVIEW(ItemJnlBatch);
                             END;

                             ItemJnlBatches.LOOKUPMODE := TRUE;
                             ItemJnlBatches.EDITABLE := FALSE;
                             IF ItemJnlBatches.RUNMODAL = ACTION::LookupOK THEN BEGIN
                               ItemJnlBatches.GETRECORD(ItemJnlBatch);
                               BatchName := ItemJnlBatch.Name;
                             END;
                           END;
                            }

      { 10  ;2   ;Field     ;
                  CaptionML=[DAN=Standardvarekladde;
                             ENU=Standard Item Journal];
                  ToolTipML=[DAN=Angiver den standardvarekladde, som k�rslen bruger.;
                             ENU=Specifies the standard item journal that the batch job uses.];
                  ApplicationArea=#Suite;
                  SourceExpr=TemplateCode;
                  TableRelation="Standard Item Journal".Code;
                  OnLookup=VAR
                             StdItemJnl1@1001 : Record 752;
                             StdItemJnls@1000 : Page 753;
                           BEGIN
                             IF JournalTemplate <> '' THEN BEGIN
                               StdItemJnl1.SETRANGE("Journal Template Name",JournalTemplate);
                               StdItemJnls.SETTABLEVIEW(StdItemJnl1);
                             END;

                             StdItemJnls.LOOKUPMODE := TRUE;
                             StdItemJnls.EDITABLE := FALSE;
                             IF StdItemJnls.RUNMODAL = ACTION::LookupOK THEN BEGIN
                               StdItemJnls.GETRECORD(StdItemJnl1);
                               TemplateCode := StdItemJnl1.Code;
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
      StdItemJnl@1007 : Record 752;
      ItemJnlBatch@1006 : Record 233;
      LastItemJnlLine@1012 : Record 83;
      ItemJnlLine@1011 : Record 83;
      EntryTypes@1000 : 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.';
      PostingDate@1001 : Date;
      DocumentDate@1002 : Date;
      BatchName@1003 : Code[10];
      TemplateCode@1004 : Code[20];
      LineNo@1008 : Integer;
      JournalTemplate@1015 : Text[10];
      Text001@1018 : TextConst 'DAN=Varekladdeskabelonen har ikke et navn.;ENU=Item Journal Template name is blank.';
      Text002@1017 : TextConst 'DAN=Massebogf�ringskladden til varer har ikke et navn.;ENU=Item Journal Batch name is blank.';
      Text004@1005 : TextConst 'DAN=Varekladdelinjerne er oprettet.;ENU=Item Journal lines are successfully created.';
      PostingDateIsEmptyErr@1009 : TextConst 'DAN=Bogf�ringsdatoen er tom.;ENU=The Posting Date is empty.';

    LOCAL PROCEDURE GetStandardJournalLine@3() : Boolean;
    VAR
      StdItemJnlLine@1000 : Record 753;
    BEGIN
      IF TemplateCode = '' THEN
        EXIT;
      StdItemJnlLine.SETRANGE("Journal Template Name",StdItemJnl."Journal Template Name");
      StdItemJnlLine.SETRANGE("Standard Journal Code",StdItemJnl.Code);
      EXIT(StdItemJnlLine.FINDFIRST);
    END;

    [External]
    PROCEDURE Initialize@2(StdItemJnl@1000 : Record 752;JnlBatchName@1001 : Code[10]);
    BEGIN
      ItemJnlLine."Journal Template Name" := StdItemJnl."Journal Template Name";
      ItemJnlLine."Journal Batch Name" := JnlBatchName;
      ItemJnlLine.SETRANGE("Journal Template Name",StdItemJnl."Journal Template Name");
      ItemJnlLine.SETRANGE("Journal Batch Name",JnlBatchName);

      LastItemJnlLine.SETRANGE("Journal Template Name",StdItemJnl."Journal Template Name");
      LastItemJnlLine.SETRANGE("Journal Batch Name",JnlBatchName);

      IF LastItemJnlLine.FINDLAST THEN;
    END;

    LOCAL PROCEDURE CopyItemJnlFromStdJnl@7(StdItemJnlLine@1000 : Record 753;VAR ItemJnlLine@1001 : Record 83);
    BEGIN
      ItemJnlLine.INIT;
      ItemJnlLine."Line No." := 0;
      ItemJnlLine.SetUpNewLine(LastItemJnlLine);
      IF LastItemJnlLine."Line No." <> 0 THEN
        ItemJnlLine."Line No." := LastItemJnlLine."Line No." + 10000
      ELSE
        ItemJnlLine."Line No." := 10000;

      ItemJnlLine.TRANSFERFIELDS(StdItemJnlLine,FALSE);

      IF (ItemJnlLine."Item No." <> '') AND (ItemJnlLine."Unit Amount" = 0) THEN
        ItemJnlLine.RecalculateUnitAmount;

      IF (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Output) AND
         (ItemJnlLine."Value Entry Type" <> ItemJnlLine."Value Entry Type"::Revaluation)
      THEN
        ItemJnlLine."Invoiced Quantity" := 0
      ELSE
        ItemJnlLine."Invoiced Quantity" := ItemJnlLine.Quantity;
      ItemJnlLine.TESTFIELD("Qty. per Unit of Measure");
      ItemJnlLine."Invoiced Qty. (Base)" := ROUND(ItemJnlLine."Invoiced Quantity" * ItemJnlLine."Qty. per Unit of Measure",0.00001);

      ItemJnlLine.INSERT(TRUE);

      LastItemJnlLine := ItemJnlLine;
    END;

    [External]
    PROCEDURE InitializeRequest@1(EntryTypesFrom@1000 : Option;PostingDateFrom@1001 : Date;DocumentDateFrom@1002 : Date);
    BEGIN
      EntryTypes := EntryTypesFrom;
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

