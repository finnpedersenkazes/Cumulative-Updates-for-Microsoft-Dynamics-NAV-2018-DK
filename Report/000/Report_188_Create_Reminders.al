OBJECT Report 188 Create Reminders
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opret rykkere;
               ENU=Create Reminders];
    ProcessingOnly=Yes;
    OnInitReport=BEGIN
                   OverdueEntriesOnly := TRUE;
                 END;

    OnPreReport=BEGIN
                  CustLedgEntry.COPY(CustLedgEntry2);
                  IF CustLedgEntryLineFeeOnFilters.GETFILTERS <> '' THEN
                    CustLedgEntryLineFeeOn.COPYFILTERS(CustLedgEntryLineFeeOnFilters);
                END;

  }
  DATASET
  {
    { 6836;    ;DataItem;                    ;
               DataItemTable=Table18;
               DataItemTableView=SORTING(No.);
               OnPreDataItem=VAR
                               SalesSetup@1000 : Record 311;
                             BEGIN
                               IF ReminderHeaderReq."Document Date" = 0D THEN
                                 ERROR(Text000,ReminderHeaderReq.FIELDCAPTION("Document Date"));
                               FILTERGROUP := 2;
                               SETFILTER("Reminder Terms Code",'<>%1','');
                               FILTERGROUP := 0;
                               NoOfRecords := COUNT;
                               SalesSetup.GET;
                               SalesSetup.TESTFIELD("Reminder Nos.");
                               IF NoOfRecords = 1 THEN
                                 Window.OPEN(Text001)
                               ELSE BEGIN
                                 Window.OPEN(Text002);
                                 OldDateTime := CURRENTDATETIME;
                               END;
                               ReminderHeaderReq."Use Header Level" := UseHeaderLevel;
                             END;

               OnAfterGetRecord=BEGIN
                                  RecordNo := RecordNo + 1;
                                  CLEAR(MakeReminder);
                                  MakeReminder.Set(Customer,CustLedgEntry,ReminderHeaderReq,OverdueEntriesOnly,IncludeEntriesOnHold,CustLedgEntryLineFeeOn);
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
                                    MARK := NOT MakeReminder.Code;
                                  END;
                                END;

               OnPostDataItem=BEGIN
                                Window.CLOSE;
                                MARKEDONLY := TRUE;
                                COMMIT;
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
      OnOpenPage=BEGIN
                   IF ReminderHeaderReq."Document Date" = 0D THEN BEGIN
                     ReminderHeaderReq."Document Date" := WORKDATE;
                     ReminderHeaderReq."Posting Date" := WORKDATE;
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
                  ToolTipML=[DAN=Angiver den bogf›ringsdato, som skal fremg† p† rykkerhovedet p† den rykker, der oprettes i forbindelse med k›rslen.;
                             ENU=Specifies the date that will appear as the posting date on the header of the reminder that is created by the batch job.];
                  ApplicationArea=#Advanced;
                  SourceExpr=ReminderHeaderReq."Posting Date" }

      { 1   ;2   ;Field     ;
                  Name=DocumentDate;
                  CaptionML=[DAN=Bilagsdato;
                             ENU=Document Date];
                  ToolTipML=[DAN=Angiver den dato, der skal v‘re bilagsdato p† rykkerhovedet for de rykkere, som oprettes i forbindelse med k›rslen. Datoen bruges til renteberegning og til at angive rykkerens forfaldsdato.;
                             ENU=Specifies the date that will appear as the document date on the header of the reminder that is created by the batch job. This date is used for any interest calculations and to determine the due date of the reminder.];
                  ApplicationArea=#Advanced;
                  SourceExpr=ReminderHeaderReq."Document Date" }

      { 5   ;2   ;Field     ;
                  CaptionML=[DAN=Kun poster med forfaldne bel›b;
                             ENU=Only Entries with Overdue Amounts];
                  ToolTipML=[DAN=Angiver, om k›rslen kun inds‘tter †bne poster, der er forfaldne, hvilket vil sige, at de har en forfaldsdato, der er tidligere end bilagsdatoen p† rykkerhovedet.;
                             ENU=Specifies if the batch job will only insert open entries that are overdue, meaning they have a due date earlier than the document date on the reminder header.];
                  ApplicationArea=#Advanced;
                  SourceExpr=OverdueEntriesOnly;
                  MultiLine=Yes }

      { 1102601001;2;Field  ;
                  CaptionML=[DAN=Medtag afventende poster;
                             ENU=Include Entries On Hold];
                  ToolTipML=[DAN=Angiver, om du vil oprette rykkere for poster, der afventer.;
                             ENU=Specifies if you want to create reminders for entries that are on hold.];
                  ApplicationArea=#Advanced;
                  SourceExpr=IncludeEntriesOnHold }

      { 7   ;2   ;Field     ;
                  CaptionML=[DAN=Brug hovedniveau;
                             ENU=Use Header Level];
                  ToolTipML=[DAN=Angiver, om k›rslen vil anvende betingelsen for rykkerniveauet p† alle rykkerlinjerne.;
                             ENU=Specifies if the batch job will apply the condition of the reminder level to all the reminder lines.];
                  ApplicationArea=#Advanced;
                  SourceExpr=UseHeaderLevel }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be specified.';
      Text001@1001 : TextConst 'DAN=Opretter rykkere...;ENU=Making reminders...';
      Text002@1002 : TextConst 'DAN=Opretter rykkere @1@@@@@@@@@@@@@;ENU=Making reminders @1@@@@@@@@@@@@@';
      Text003@1003 : TextConst 'DAN=Det var ikke muligt at oprette rykkere til alle de valgte debitorer.\Vil du se disse debitorer?;ENU=It was not possible to create reminders for some of the selected customers.\Do you want to see these customers?';
      CustLedgEntry@1005 : Record 21;
      ReminderHeaderReq@1006 : Record 295;
      CustLedgEntryLineFeeOnFilters@1004 : Record 21;
      MakeReminder@1007 : Codeunit 392;
      Window@1008 : Dialog;
      NoOfRecords@1009 : Integer;
      RecordNo@1010 : Integer;
      NewProgress@1011 : Integer;
      OldProgress@1012 : Integer;
      NewDateTime@1013 : DateTime;
      OldDateTime@1014 : DateTime;
      OverdueEntriesOnly@1015 : Boolean;
      UseHeaderLevel@1016 : Boolean;
      IncludeEntriesOnHold@1102601000 : Boolean;

    PROCEDURE InitializeRequest@1(DocumentDate@1000 : Date;PostingDate@1001 : Date;OverdueEntries@1002 : Boolean;NewUseHeaderLevel@1003 : Boolean;IncludeEntries@1004 : Boolean);
    BEGIN
      ReminderHeaderReq."Document Date" := DocumentDate;
      ReminderHeaderReq."Posting Date" := PostingDate;
      OverdueEntriesOnly := OverdueEntries;
      UseHeaderLevel := NewUseHeaderLevel;
      IncludeEntriesOnHold := IncludeEntries;
    END;

    PROCEDURE SetApplyLineFeeOnFilters@1000(VAR CustLedgEntryLineFeeOn2@1000 : Record 21);
    BEGIN
      CustLedgEntryLineFeeOnFilters.COPYFILTERS(CustLedgEntryLineFeeOn2);
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

