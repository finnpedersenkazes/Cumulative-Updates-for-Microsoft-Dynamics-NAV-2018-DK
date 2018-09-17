OBJECT Page 99000917 Report Selection - Prod. Order
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rapportvalg - prod.ordre;
               ENU=Report Selection - Prod. Order];
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
                OptionCaptionML=[DAN=Jobkort,Mat.& rekvisition,Mankoliste,Gantt-kort,Prod.ordre;
                                 ENU=Job Card,Mat. & Requisition,Shortage List,Gantt Chart,Prod. Order];
                ApplicationArea=#Manufacturing;
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
                ApplicationArea=#Manufacturing;
                SourceExpr=Sequence }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens objekt-id.;
                           ENU=Specifies the object ID of the report.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Report ID";
                LookupPageID=Objects }

    { 4   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver rapportens viste navn.;
                           ENU=Specifies the display name of the report.];
                ApplicationArea=#Manufacturing;
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
      ReportUsage2@1000 : 'Job Card,Mat. & Requisition,Shortage List,Gantt Chart,Prod. Order';

    LOCAL PROCEDURE SetUsageFilter@1(ModifyRec@1000 : Boolean);
    BEGIN
      IF ModifyRec THEN
        IF MODIFY THEN;
      FILTERGROUP(2);
      CASE ReportUsage2 OF
        ReportUsage2::"Job Card":
          SETRANGE(Usage,Usage::M1);
        ReportUsage2::"Mat. & Requisition":
          SETRANGE(Usage,Usage::M2);
        ReportUsage2::"Shortage List":
          SETRANGE(Usage,Usage::M3);
        ReportUsage2::"Gantt Chart":
          SETRANGE(Usage,Usage::M4);
        ReportUsage2::"Prod. Order":
          SETRANGE(Usage,Usage::"Prod. Order");
      END;
      FILTERGROUP(0);
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

