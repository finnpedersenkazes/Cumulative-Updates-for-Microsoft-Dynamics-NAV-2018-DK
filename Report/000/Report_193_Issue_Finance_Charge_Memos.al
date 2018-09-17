OBJECT Report 193 Issue Finance Charge Memos
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348,NAVDK11.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udsted rentenotaer;
               ENU=Issue Finance Charge Memos];
    ProcessingOnly=Yes;
  }
  DATASET
  {
    { 8733;    ;DataItem;                    ;
               DataItemTable=Table302;
               DataItemTableView=SORTING(No.);
               ReqFilterHeadingML=[DAN=Rentenota;
                                   ENU=Finance Charge Memo];
               OnPreDataItem=BEGIN
                               IF ReplacePostingDate AND (PostingDateReq = 0D) THEN
                                 ERROR(Text000);
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
                                  CLEAR(FinChrgMemoIssue);
                                  FinChrgMemoIssue.Set("Finance Charge Memo Header",ReplacePostingDate,PostingDateReq);
                                  IF NoOfRecords = 1 THEN BEGIN
                                    OIOXMLCheckFinChargeMemo.RUN("Finance Charge Memo Header");
                                    FinChrgMemoIssue.RUN;
                                    "Finance Charge Memo Header".MARK := FALSE;
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
                                    "Finance Charge Memo Header".MARK := NOT OIOXMLCheckFinChargeMemo.RUN("Finance Charge Memo Header");
                                    IF NOT "Finance Charge Memo Header".MARK THEN
                                      "Finance Charge Memo Header".MARK := NOT FinChrgMemoIssue.RUN;
                                  END;

                                  IF (PrintDoc <> PrintDoc::" ") AND NOT "Finance Charge Memo Header".MARK THEN BEGIN
                                    FinChrgMemoIssue.GetIssuedFinChrgMemo(IssuedFinChrgMemoHeader);
                                    TempIssuedFinChrgMemoHeader := IssuedFinChrgMemoHeader;
                                    TempIssuedFinChrgMemoHeader.INSERT;
                                  END;
                                END;

               OnPostDataItem=BEGIN
                                Window.CLOSE;
                                COMMIT;
                                IF PrintDoc <> PrintDoc::" " THEN
                                  IF TempIssuedFinChrgMemoHeader.FINDSET THEN
                                    REPEAT
                                      IssuedFinChrgMemoHeader := TempIssuedFinChrgMemoHeader;
                                      IssuedFinChrgMemoHeader.SETRECFILTER;
                                      IssuedFinChrgMemoHeader.PrintRecords(FALSE,PrintDoc = PrintDoc::Email,HideDialog);
                                    UNTIL TempIssuedFinChrgMemoHeader.NEXT = 0;
                                "Finance Charge Memo Header".MARKEDONLY := TRUE;
                                IF "Finance Charge Memo Header".FIND('-') THEN
                                  IF CONFIRM(Text003,TRUE) THEN
                                    PAGE.RUNMODAL(0,"Finance Charge Memo Header");
                              END;

               ReqFilterFields=No. }

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

      { 3   ;2   ;Field     ;
                  Name=PrintDoc;
                  CaptionML=[DAN=Udskriv;
                             ENU=Print];
                  ToolTipML=[DAN=Angiver, om rapporten skal udskrive rentenotaerne, n†r de udstedes.;
                             ENU=Specifies if you want the program to print the finance charge memos when they are issued.];
                  ApplicationArea=#Advanced;
                  SourceExpr=PrintDoc }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Erstat bogf›ringsdato;
                             ENU=Replace Posting Date];
                  ToolTipML=[DAN=Angiver, om du vil erstatte rentenotaernes bogf›ringsdato med den dato, der er angivet i feltet nedenfor.;
                             ENU=Specifies if you want to replace the finance charge memos' posting date with the date entered in the field below.];
                  ApplicationArea=#Advanced;
                  SourceExpr=ReplacePostingDate }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Bogf›ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver bogf›ringsdatoen. Hvis du markerer afkrydsningsfeltet herover, bruges denne dato p† alle rentenotaerne, n†r du bogf›rer.;
                             ENU=Specifies the posting date. If you place a check mark in the check box above, the program will use this date on all finance charge memos when you post.];
                  ApplicationArea=#Advanced;
                  SourceExpr=PostingDateReq }

      { 4   ;2   ;Field     ;
                  Name=HideEmailDialog;
                  CaptionML=[DAN=Skjul maildialogboks;
                             ENU=Hide Email Dialog];
                  ToolTipML=[DAN=Angiver, om du vil skjule maildialogboksen.;
                             ENU=Specifies if you want to hide email dialog.];
                  ApplicationArea=#Advanced;
                  SourceExpr=HideDialog }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Angiv bogf›ringsdatoen.;ENU=Enter the posting date.';
      Text001@1001 : TextConst 'DAN=Opretter rentenotaer...;ENU=Issuing finance charge memo...';
      Text002@1002 : TextConst 'DAN=Opretter rentenotaer         @1@@@@@@@@@@@@@;ENU=Issuing finance charge memos @1@@@@@@@@@@@@@';
      Text003@1003 : TextConst 'DAN=Det var ikke muligt at udstede alle de valgte rentenotaer.\Vil du se disse rentenotaer?;ENU=It was not possible to issue some of the selected finance charge memos.\Do you want to see these finance charge memos?';
      IssuedFinChrgMemoHeader@1005 : Record 304;
      TempIssuedFinChrgMemoHeader@1004 : TEMPORARY Record 304;
      FinChrgMemoIssue@1006 : Codeunit 395;
      Window@1007 : Dialog;
      NoOfRecords@1008 : Integer;
      RecordNo@1009 : Integer;
      NewProgress@1010 : Integer;
      OldProgress@1011 : Integer;
      NewDateTime@1012 : DateTime;
      OldDateTime@1013 : DateTime;
      PostingDateReq@1014 : Date;
      ReplacePostingDate@1015 : Boolean;
      PrintDoc@1016 : ' ,Print,Email';
      OIOXMLCheckFinChargeMemo@1101100000 : Codeunit 13603;
      HideDialog@1017 : Boolean;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

