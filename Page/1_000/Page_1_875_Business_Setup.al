OBJECT Page 1875 Business Setup
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Virksomhedskonfiguration;
               ENU=Business Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table1875;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 OnRegisterBusinessSetup(Rec);
               END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Konfiguration af Open Manual;
                                 ENU=Open Manual Setup];
                      ToolTipML=[DAN="Vis eller rediger ops‘tningsvinduerne for forskellige typer virksomhedsfunktioner, du kan konfigurere manuelt. ";
                                 ENU="View or edit the setup windows for various business functionality that you can set up manually. "];
                      ApplicationArea=#All;
                      Image=Edit;
                      Scope=Repeater;
                      OnAction=VAR
                                 Handled@1000 : Boolean;
                               BEGIN
                                 OnOpenBusinessSetupPage(Rec,Handled);
                                 IF (NOT Handled) AND ("Setup Page ID" <> 0) THEN
                                   PAGE.RUN("Setup Page ID");
                               END;
                                }
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
                ToolTipML=[DAN=Angiver navnet p† virksomheden.;
                           ENU=Specifies the name of the business.];
                ApplicationArea=#All;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af virksomheden.;
                           ENU=Specifies a description of the business.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omr†de med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#All;
                SourceExpr=Area }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke n›gleord der vedr›rer virksomhedskonfigurationen p† linjen.;
                           ENU=Specifies which keywords relate to the business setup on the line.];
                ApplicationArea=#All;
                SourceExpr=Keywords }

  }
  CODE
  {

    BEGIN
    END.
  }
}

