OBJECT Page 1754 Data Subject
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Dataemne;
               ENU=Data Subject];
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table1180;
    PageType=List;
    SourceTableTemporary=Yes;
    ShowFilter=No;
    OnInit=VAR
             DataClassificationMgt@1000 : Codeunit 1750;
           BEGIN
             DataClassificationMgt.OnGetPrivacyMasterTables(Rec);
           END;

    ActionList=ACTIONS
    {
      { 10      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 6       ;1   ;Action    ;
                      Name=Data Privacy Setup;
                      CaptionML=[DAN=Vërktõj til databeskyttelse;
                                 ENU=Data Privacy Utility];
                      ToolTipML=[DAN=èbn siden til konfiguration af databeskyttelse.;
                                 ENU=Open the Data Privacy Setup page.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=Setup;
                      OnAction=VAR
                                 DataPrivacyWizard@1000 : Page 1180;
                               BEGIN
                                 IF "Table Caption" <> '' THEN BEGIN
                                   DataPrivacyWizard.SetEntitityType(Rec,"Table Caption");
                                   DataPrivacyWizard.RUNMODAL;
                                 END;
                               END;
                                }
      { 5       ;1   ;Action    ;
                      Name=Data Privacy Activity;
                      CaptionML=[DAN=Databeskyttelselsesaktivitet;
                                 ENU=Data Privacy Activity];
                      ToolTipML=[DAN=èbn logfilen Databeskyttelsesaktivitet.;
                                 ENU=Open the Data Privacy Activity log.];
                      ApplicationArea=#All;
                      RunObject=Codeunit 1180;
                      Promoted=Yes;
                      Image=Log }
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
                ApplicationArea=#All;
                SourceExpr="Table Caption";
                Style=StandardAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              PAGE.RUN("Page No.");
                            END;

                ShowCaption=No }

  }
  CODE
  {

    BEGIN
    END.
  }
}

