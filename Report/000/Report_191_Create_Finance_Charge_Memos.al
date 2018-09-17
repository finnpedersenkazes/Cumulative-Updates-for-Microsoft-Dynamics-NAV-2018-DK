OBJECT Report 191 Create Finance Charge Memos
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opret rentenotaer;
               ENU=Create Finance Charge Memos];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  CustLedgEntry.COPY(CustLedgEntry2);
                END;

  }
  DATASET
  {
    { 6836;    ;DataItem;                    ;
               DataItemTable=Table18;
               DataItemTableView=SORTING(No.);
               OnPreDataItem=BEGIN
                               IF FinChrgMemoHeaderReq."Document Date" = 0D THEN
                                 ERROR(Text000,FinChrgMemoHeaderReq.FIELDCAPTION("Document Date"));
                               FILTERGROUP := 2;
                               SETFILTER("Fin. Charge Terms Code",'<>%1','');
                               FILTERGROUP := 0;
                               NoOfRecords := COUNT;
                               IF NoOfRecords = 1 THEN
                                 Window.OPEN(Text001)
                               ELSE BEGIN
                                 Window.OPEN(Text002);
                                 OldDateTime := CURRENTDATETIME;
                               END;
                             END;

               OnAfterGetRecord=BEGIN
                                  RecordNo := RecordNo + 1;
                                  CLEAR(MakeFinChrgMemo);
                                  MakeFinChrgMemo.Set(Customer,CustLedgEntry,FinChrgMemoHeaderReq);
                                  IF NoOfRecords = 1 THEN BEGIN
                                    MakeFinChrgMemo.Code;
                                    MARK := FALSE;
                                  END ELSE BEGIN
                                    NewDateTime := CURRENTDATETIME;
                                    IF (NewDateTime - OldDateTime > 100) OR (NewDateTime < OldDateTime) THEN BEGIN
                                      NewProgress := ROUND(RecordNo / NoOfRecords * 100,1);
                                      IF NewProgress <> OldProgress THEN BEGIN
                                        Window.UPDATE(1,NewProgress * 100);
                                        OldProgress := NewProgress;
                                      END;
                                      OldDateTime := CURRENTDATETIME;
                                    END;
                                    MARK := NOT MakeFinChrgMemo.Code;
                                  END;
                                  COMMIT;
                                END;

               OnPostDataItem=BEGIN
                                Window.CLOSE;
                                MARKEDONLY := TRUE;
                                IF FIND('-') THEN
                                  IF CONFIRM(Text003,TRUE) THEN
                                    PAGE.RUNMODAL(0,Customer);
                              END;

               ReqFilterFields=No. }

    { 9065;    ;DataItem;CustLedgEntry2      ;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Customer No.);
               OnPreDataItem=BEGIN
                               CurrReport.BREAK;
                             END;

               ReqFilterFields=Document Type }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
                   IF FinChrgMemoHeaderReq."Document Date" = 0D THEN BEGIN
                     FinChrgMemoHeaderReq."Document Date" := WORKDATE;
                     FinChrgMemoHeaderReq."Posting Date" := WORKDATE;
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

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Bogf›ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver den dato, der skal st† som bogf›ringsdato p† det rentenotahoved, som oprettes i forbindelse med k›rslen.;
                             ENU=Specifies the date that will appear as the posting date on the header of the finance charge memo created by the batch job.];
                  ApplicationArea=#Advanced;
                  SourceExpr=FinChrgMemoHeaderReq."Posting Date" }

      { 1   ;2   ;Field     ;
                  Name=DocumentDate;
                  CaptionML=[DAN=Bilagsdato;
                             ENU=Document Date];
                  ToolTipML=[DAN="Angiver en bilagsdato for rentenotaen. Denne dato bruges ogs† til at bestemme forfaldsdatoen for rentenotaen. ";
                             ENU="Specifies a document date for the finance charge memo. This date is also used to determine the due date for the finance charge memo. "];
                  ApplicationArea=#Advanced;
                  SourceExpr=FinChrgMemoHeaderReq."Document Date" }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be specified.';
      Text001@1001 : TextConst 'DAN=Opretter rentenotaer...;ENU=Making finance charge memos...';
      Text002@1002 : TextConst 'DAN=Opretter rentenotaer        @1@@@@@@@@@@@@@;ENU=Making finance charge memos @1@@@@@@@@@@@@@';
      Text003@1003 : TextConst 'DAN=Det var ikke muligt at oprette rentenotaer til alle de valgte debitorer.\Vil du se disse debitorer?;ENU=It was not possible to create finance charge memos for some of the selected customers.\Do you want to see these customers?';
      CustLedgEntry@1005 : Record 21;
      FinChrgMemoHeaderReq@1006 : Record 302;
      MakeFinChrgMemo@1007 : Codeunit 394;
      Window@1008 : Dialog;
      NoOfRecords@1009 : Integer;
      RecordNo@1010 : Integer;
      NewProgress@1011 : Integer;
      OldProgress@1012 : Integer;
      NewDateTime@1013 : DateTime;
      OldDateTime@1014 : DateTime;

    PROCEDURE InitializeRequest@1(PostingDate@1000 : Date;DocumentDate@1001 : Date);
    BEGIN
      FinChrgMemoHeaderReq."Posting Date" := PostingDate;
      FinChrgMemoHeaderReq."Document Date" := DocumentDate;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

