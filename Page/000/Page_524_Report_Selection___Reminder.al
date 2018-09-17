OBJECT Page 524 Report Selection - Reminder
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rapportvalg - rykker;
               ENU=Report Selection - Reminder];
    SaveValues=Yes;
    SourceTable=Table77;
    PageType=Worksheet;
    OnOpenPage=BEGIN
                 SetUsageFilter(FALSE);
               END;

    OnNewRecord=BEGIN
                  NewRecord;
                END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 11  ;1   ;Field     ;
                CaptionML=[DAN=Rapporttype;
                           ENU=Usage];
                ToolTipML=[DAN=Angiver den dokumenttype, som rapporten anvendes til.;
                           ENU=Specifies which type of document the report is used for.];
                OptionCaptionML=[DAN=Rykker,Rente,Rykkertest,Rentetest;
                                 ENU=Reminder,Fin. Charge,Reminder Test,Fin. Charge Test];
                ApplicationArea=#Advanced;
                SourceExpr=ReportUsage2;
                OnValidate=BEGIN
                             SetUsageFilter(TRUE);
                           END;
                            }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket nummer i udskrivningsr�kkef�lgen den aktuelle rapport har.;
                           ENU=Specifies a number that indicates where this report is in the printing order.];
                ApplicationArea=#Advanced;
                SourceExpr=Sequence }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens objekt-id.;
                           ENU=Specifies the object ID of the report.];
                ApplicationArea=#Advanced;
                SourceExpr="Report ID";
                LookupPageID=Objects }

    { 4   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver rapportens viste navn.;
                           ENU=Specifies the display name of the report.];
                ApplicationArea=#Advanced;
                SourceExpr="Report Caption";
                LookupPageID=Objects }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der skal inds�ttes opsummerede oplysninger, f.eks. fakturanummer, forfaldsdato, i meddelelsesteksten p� den mail, som du sender.;
                           ENU=Specifies whether to insert summarized information, such as invoice number, due date in the body of the email that you send.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Use for Email Body" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om det relaterede dokument skal vedh�ftes mailen.;
                           ENU=Specifies whether to attach the related document to the email.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Use for Email Attachment" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver layout-id for br�dtekst i mail, som anvendes.;
                           ENU=Specifies the ID of the email body layout that is used.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Email Body Layout Code";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af layout for br�dtekst i mail, som anvendes.;
                           ENU=Specifies a description of the email body layout that is used.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Email Body Layout Description";
                OnDrillDown=VAR
                              CustomReportLayout@1000 : Record 9650;
                            BEGIN
                              IF CustomReportLayout.LookupLayoutOK("Report ID") THEN
                                VALIDATE("Email Body Layout Code",CustomReportLayout.Code);
                            END;
                             }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ReportUsage2@1000 : 'Reminder,Fin. Charge,Reminder Test,Fin. Charge Test';

    LOCAL PROCEDURE SetUsageFilter@1(ModifyRec@1000 : Boolean);
    BEGIN
      IF ModifyRec THEN
        IF MODIFY THEN;
      FILTERGROUP(2);
      CASE ReportUsage2 OF
        ReportUsage2::Reminder:
          SETRANGE(Usage,Usage::Reminder);
        ReportUsage2::"Fin. Charge":
          SETRANGE(Usage,Usage::"Fin.Charge");
        ReportUsage2::"Reminder Test":
          SETRANGE(Usage,Usage::"Rem.Test");
        ReportUsage2::"Fin. Charge Test":
          SETRANGE(Usage,Usage::"F.C.Test");
      END;
      FILTERGROUP(0);
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

