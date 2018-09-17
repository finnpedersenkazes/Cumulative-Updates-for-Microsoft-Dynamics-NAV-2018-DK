OBJECT Page 5351 CRM Quote List
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
    CaptionML=[DAN=Tilbud - Microsoft Dynamics 365 for Sales;
               ENU=Quotes - Microsoft Dynamics 365 for Sales];
    InsertAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5351;
    SourceTableView=SORTING(Name);
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Dynamics 365 for Sales;
                                ENU=New,Process,Report,Dynamics 365 for Sales];
    OnInit=BEGIN
             CODEUNIT.RUN(CODEUNIT::"CRM Integration Management");
           END;

    ActionList=ACTIONS
    {
      { 11      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 10      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales] }
      { 9       ;2   ;Action    ;
                      Name=CRMGoToQuote;
                      CaptionML=[DAN=Tilbud;
                                 ENU=Quote];
                      ToolTipML=[DAN=èbn det valgte Dynamics 365 for Sales-tilbud.;
                                 ENU=Open the selected Dynamics 365 for Sales quote.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=CoupledQuote;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 HYPERLINK(CRMIntegrationManagement.GetCRMEntityUrlFromCRMID(DATABASE::"CRM Quote",QuoteId));
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
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ recorden.;
                           ENU=Specifies the name of the record.];
                ApplicationArea=#Suite;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Status;
                           ENU=Status];
                ToolTipML=[DAN=Angiver oplysninger, der er relateret til Dynamics 365 for Sales-forbindelsen.;
                           ENU="Specifies information related to the Dynamics 365 for Sales connection. "];
                OptionCaptionML=[DAN=Kladde,Aktiv,Vundet,Lukket;
                                 ENU=Draft,Active,Won,Closed];
                ApplicationArea=#Suite;
                SourceExpr=StateCode }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Totale belõb;
                           ENU=Total Amount];
                ToolTipML=[DAN=Angiver oplysninger, der er relateret til Dynamics 365 for Sales-forbindelsen.;
                           ENU="Specifies information related to the Dynamics 365 for Sales connection. "];
                ApplicationArea=#Suite;
                SourceExpr=TotalAmount }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Gëlder fra;
                           ENU=Effective From];
                ToolTipML=[DAN=Angiver den dato, som salgstilbuddet er gyldigt fra.;
                           ENU=Specifies which date the sales quote is valid from.];
                ApplicationArea=#Suite;
                SourceExpr=EffectiveFrom }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Gëlder til;
                           ENU=Effective To];
                ToolTipML=[DAN=Angiver den dato, som salgstilbuddet er gyldigt til.;
                           ENU=Specifies which date the sales quote is valid to.];
                ApplicationArea=#Suite;
                SourceExpr=EffectiveTo }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Lukket den;
                           ENU=Closed On];
                ToolTipML=[DAN=Angiver den dato, hvor tilbuddet blev lukket.;
                           ENU=Specifies the date when quote was closed.];
                ApplicationArea=#Suite;
                SourceExpr=ClosedOn }

  }
  CODE
  {

    BEGIN
    END.
  }
}

