OBJECT Page 1650 Curr. Exch. Rate Service List
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Valutakurstjenester;
               ENU=Currency Exchange Rate Services];
    ModifyAllowed=No;
    SourceTable=Table1650;
    PageType=List;
    CardPageID=Curr. Exch. Rate Service Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Ops‘tning;
                                ENU=New,Process,Report,Setup];
    OnOpenPage=BEGIN
                 IF ISEMPTY THEN
                   CODEUNIT.RUN(CODEUNIT::"Set Up Curr Exch Rate Service");
               END;

    ActionList=ACTIONS
    {
      { 4       ;    ;ActionContainer;
                      Name=Setup;
                      CaptionML=[DAN=Konfigurer;
                                 ENU=Setup];
                      ActionContainerType=ActionItems }
      { 6       ;1   ;Action    ;
                      Name=Enable;
                      CaptionML=[DAN=Aktiver;
                                 ENU=Enable];
                      ToolTipML=[DAN=Aktiver en tjeneste, der holder valutakurserne opdateret. Du kan derefter ‘ndre den sag, der kontrollerer, hvor tit valutakurserne opdateres.;
                                 ENU=Enable a service for keeping your for currency exchange rates up to date. You can then change the job that controls how often exchange rates are updated.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Default;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 VALIDATE(Enabled,TRUE);
                                 MODIFY(TRUE);
                               END;
                                }
      { 11      ;1   ;Action    ;
                      Name=TestUpdate;
                      CaptionML=[DAN=Vis eksempel;
                                 ENU=Preview];
                      ToolTipML=[DAN=Kontroller ops‘tningen af valutakurstjenesten for at sikre, at tjenesten fungerer.;
                                 ENU=Test the setup of the currency exchange rate service to make sure the service is working.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReviewWorksheet;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 TempCurrencyExchangeRate@1001 : TEMPORARY Record 330;
                                 UpdateCurrencyExchangeRates@1000 : Codeunit 1281;
                               BEGIN
                                 UpdateCurrencyExchangeRates.GenerateTempDataFromService(TempCurrencyExchangeRate,Rec);
                                 PAGE.RUN(PAGE::"Currency Exchange Rates",TempCurrencyExchangeRate);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 5   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ops‘tningen af en service, der opdaterer valutakurserne.;
                           ENU=Specifies the setup of a service to update currency exchange rates.];
                ApplicationArea=#Suite;
                SourceExpr=Code }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ops‘tningen af en service, der opdaterer valutakurserne.;
                           ENU=Specifies the setup of a service to update currency exchange rates.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om valutakurstjenesten er aktiveret. Det er kun muligt at aktivere ‚n tjeneste ad gangen.;
                           ENU=Specifies if the currency exchange rate service is enabled. Only one service can be enabled at a time.];
                ApplicationArea=#Suite;
                SourceExpr=Enabled }

  }
  CODE
  {

    BEGIN
    END.
  }
}

