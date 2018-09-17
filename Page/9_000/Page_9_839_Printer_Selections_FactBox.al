OBJECT Page 9839 Printer Selections FactBox
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Faktaboks for printervalg;
               ENU=Printer Selections FactBox];
    SourceTable=Table78;
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, som du skal angive rettigheder for.;
                           ENU=Specifies the ID of the user for whom you want to define permissions.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
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
                SourceExpr="Report Caption" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den printer, som den aktuelle bruger kan bruge, og som rapporten udskrives p†.;
                           ENU=Specifies the printer that the user will be allowed to use or on which the report will be printed.];
                ApplicationArea=#Advanced;
                SourceExpr="Printer Name";
                LookupPageID=Printers }

  }
  CODE
  {

    BEGIN
    END.
  }
}

