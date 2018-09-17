OBJECT Page 865 Report Selection - Cash Flow
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rapportvalg - pengestr›m;
               ENU=Report Selection - Cash Flow];
    SaveValues=Yes;
    SourceTable=Table856;
    PageType=Worksheet;
    OnNewRecord=BEGIN
                  NewRecord;
                END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1002;1   ;Group     ;
                GroupType=Repeater }

    { 1003;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket nummer i udskrivningsr‘kkef›lgen den aktuelle rapport har.;
                           ENU=Specifies a number that indicates where this report is in the printing order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Sequence }

    { 1005;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens objekt-id.;
                           ENU=Specifies the object ID of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report ID";
                LookupPageID=Objects }

    { 1007;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver rapportens viste navn.;
                           ENU=Specifies the display name of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report Caption";
                LookupPageID=Objects }

  }
  CODE
  {

    BEGIN
    END.
  }
}

