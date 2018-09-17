OBJECT Report 189 Suggest Reminder Lines
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Foresl† rykkerlinjer;
               ENU=Suggest Reminder Lines];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  CustLedgEntry.COPY(CustLedgEntry2)
                END;

  }
  DATASET
  {
    { 4775;    ;DataItem;                    ;
               DataItemTable=Table295;
               DataItemTableView=SORTING(No.);
               ReqFilterHeadingML=[DAN=Rykkermeddelelse;
                                   ENU=Reminder];
               OnPreDataItem=BEGIN
                               NoOfRecords := COUNT;
                               IF NoOfRecords = 1 THEN
                                 Window.OPEN(Text000)
                               ELSE BEGIN
                                 Window.OPEN(Text001);
                                 OldDateTime := CURRENTDATETIME;
                               END;
                             END;

               OnAfterGetRecord=BEGIN
                                  RecordNo := RecordNo + 1;
                                  CLEAR(MakeReminder);
                                  MakeReminder.SuggestLines("Reminder Header",CustLedgEntry,OverdueEntriesOnly,IncludeEntriesOnHold,CustLedgEntryLineFeeOn);
                                  IF NoOfRecords = 1 THEN BEGIN
                                    MakeReminder.Code;
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
                                    MARK := NOT MakeReminder.RUN;
                                  END;
                                END;

               OnPostDataItem=BEGIN
                                COMMIT;
                                Window.CLOSE;
                                MARKEDONLY := TRUE;
                                IF FIND('-') THEN
                                  IF CONFIRM(Text002,TRUE) THEN
                                    PAGE.RUNMODAL(0,"Reminder Header");
                              END;

               ReqFilterFields=No. }

    { 9065;    ;DataItem;CustLedgEntry2      ;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Customer No.);
               OnPreDataItem=BEGIN
                               CurrReport.BREAK;
                             END;

               ReqFilterFields=Document Type }

    { 1000;    ;DataItem;CustLedgEntryLineFeeOn;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Entry No.)
                                 ORDER(Ascending);
               ReqFilterHeadingML=[DAN=Anvend gebyr pr. linje p†;
                                   ENU=Apply Fee per Line On];
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
    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Kun poster med forfaldne bel›b;
                             ENU=Only Entries with Overdue Amounts];
                  ToolTipML=[DAN=Angiver, om k›rslen kun inds‘tter †bne poster, der er forfaldne, hvilket vil sige, at de har en forfaldsdato, der er tidligere end bilagsdatoen p† rykkerhovedet.;
                             ENU=Specifies if the batch job will only insert open entries that are overdue, meaning they have a due date earlier than the document date on the reminder header.];
                  ApplicationArea=#Advanced;
                  SourceExpr=OverdueEntriesOnly;
                  MultiLine=Yes }

      { 1102601000;2;Field  ;
                  CaptionML=[DAN=Medtag afventende poster;
                             ENU=Include Entries On Hold];
                  ToolTipML=[DAN=Angiver, om k›rslen ogs† inds‘tter forfaldne †bne poster, der afventer.;
                             ENU=Specifies if the batch job will also insert overdue open entries that are on hold.];
                  ApplicationArea=#Advanced;
                  SourceExpr=IncludeEntriesOnHold }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Foresl†r linjer...;ENU=Suggesting lines...';
      Text001@1001 : TextConst 'DAN=Foresl†r linjer  @1@@@@@@@@@@@@@;ENU=Suggesting lines @1@@@@@@@@@@@@@';
      Text002@1002 : TextConst 'DAN=Det var ikke muligt at behandle alle de valgte rykkere.\Vil du se disse rykkere?;ENU=It was not possible to process some of the selected reminders.\Do you want to see these reminders?';
      CustLedgEntry@1004 : Record 21;
      MakeReminder@1005 : Codeunit 392;
      Window@1006 : Dialog;
      NoOfRecords@1007 : Integer;
      RecordNo@1008 : Integer;
      NewProgress@1009 : Integer;
      OldProgress@1010 : Integer;
      NewDateTime@1011 : DateTime;
      OldDateTime@1012 : DateTime;
      OverdueEntriesOnly@1013 : Boolean;
      IncludeEntriesOnHold@1102601000 : Boolean;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

