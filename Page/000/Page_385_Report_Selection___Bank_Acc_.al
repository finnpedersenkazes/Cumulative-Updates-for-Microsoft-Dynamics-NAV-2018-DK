OBJECT Page 385 Report Selection - Bank Acc.
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rapportvalg - bankkonto;
               ENU=Report Selection - Bank Acc.];
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
                ToolTipML=[DAN=Angiver dokumenttypen, hvortil rapporten anvendes.;
                           ENU=Specifies which type of document the report is used for.];
                OptionCaptionML=[DAN=Kontoudtog,Afstemning - kontrol,Check;
                                 ENU=Statement,Reconciliation - Test,Check];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ReportUsage2;
                OnValidate=BEGIN
                             SetUsageFilter(TRUE);
                           END;
                            }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket nummer i udskrivningsr‘kkef›lgen den aktuelle rapport har.;
                           ENU=Specifies a number that indicates where this report is in the printing order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Sequence }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens objekt-id.;
                           ENU=Specifies the object ID of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report ID";
                LookupPageID=Objects }

    { 4   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver rapportens viste navn.;
                           ENU=Specifies the display name of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report Caption" }

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
      ReportUsage2@1000 : 'Statement,Reconciliation - Test,Check';

    LOCAL PROCEDURE SetUsageFilter@1(ModifyRec@1000 : Boolean);
    BEGIN
      IF ModifyRec THEN
        IF MODIFY THEN;
      FILTERGROUP(2);
      SETRANGE(Usage,Usage::"B.Stmt" + ReportUsage2);
      FILTERGROUP(0);
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

