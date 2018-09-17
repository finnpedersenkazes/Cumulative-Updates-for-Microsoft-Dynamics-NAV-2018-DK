OBJECT Page 323 EC Sales List Reports
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
    CaptionML=[DAN=Rapporter over EU-salg;
               ENU=EC Sales List Reports];
    DeleteAllowed=No;
    SourceTable=Table740;
    SourceTableView=WHERE(VAT Report Config. Code=FILTER(EC Sales List));
    PageType=List;
    CardPageID=ECSL Report;
    OnAfterGetRecord=VAR
                       VATReportArchive@1015 : Record 747;
                     BEGIN
                       IF VATReportArchive.GET("VAT Report Type","No.") THEN BEGIN
                         SubmittedBy := VATReportArchive."Submitted By";
                         SubmittedDate := VATReportArchive."Submittion Date";
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 20      ;    ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante konfigurationskode for rapporter med oversigt over EU-salg.;
                           ENU=Specifies the appropriate configuration code for EC Sales List Reports.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Report Config. Code";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil oprette en ny momsrapport, eller om du vil ëndre en tidligere afsendt rapport.;
                           ENU=Specifies if you want to create a new VAT report, or if you want to change a previously submitted report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Report Type";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapporteringsperiodens fõrste dato.;
                           ENU=Specifies the first date of the reporting period.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Start Date";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste dato i rapporten med oversigt over EU-salg.;
                           ENU=Specifies the last date of the EC sales list report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="End Date";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Series";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den oprindelige rapport.;
                           ENU=Specifies the number of the original report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Original Report No.";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapporteringsperiodens lëngde.;
                           ENU=Specifies the length of the reporting period.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Period Type" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rapporteringsperiode, som skal bruges over oversigten over EU-salg.;
                           ENU=Specifies the EC sales list reporting period to use.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Period No." }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Üret for rapporteringsperioden.;
                           ENU=Specifies the year of the reporting period.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Period Year" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den rapport, der viser salg til andre EU-lande/-omrÜder.;
                           ENU=Specifies the message ID of the report listing sales to other EU countries/regions.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Message Id";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ angivelsesskabelonen fra rapporten med oversigt over EU-salg.;
                           ENU=Specifies the name of the statement template from the EC Sales List Report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Statement Template Name";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ angivelsen fra rapporten med oversigt over EU-salg.;
                           ENU=Specifies the name of the statement from the EC Sales List Report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Statement Name";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsrapportens version.;
                           ENU=Specifies the version of the VAT report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Report Version";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver status for rapporten, f.eks. èben eller Sendt. ";
                           ENU="Specifies the status of the report, such as Open or Submitted. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status }

    { 18  ;2   ;Field     ;
                Name=Submitted By;
                CaptionML=[DAN=Sendt af;
                           ENU=Submitted By];
                ToolTipML=[DAN="Angiver navnet pÜ den person, der sendte rapporten. ";
                           ENU="Specifies the name of the person who submitted the report. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SubmittedBy }

    { 19  ;2   ;Field     ;
                Name=Submitted Date;
                CaptionML=[DAN=Sendt dato;
                           ENU=Submitted Date];
                ToolTipML=[DAN="Angiver den dato, hvor rapporten blev sendt. ";
                           ENU="Specifies the date when the report was submitted. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SubmittedDate }

  }
  CODE
  {
    VAR
      SubmittedBy@1050 : Code[50];
      SubmittedDate@1051 : Date;

    BEGIN
    END.
  }
}

