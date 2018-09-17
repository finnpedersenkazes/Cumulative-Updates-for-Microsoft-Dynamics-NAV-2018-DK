OBJECT Page 5349 CRM Case List
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
    CaptionML=[DAN=Sager - Microsoft Dynamics 365 for Sales;
               ENU=Cases - Microsoft Dynamics 365 for Sales];
    InsertAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5349;
    SourceTableView=SORTING(Title);
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Dynamics 365 for Sales;
                                ENU=New,Process,Report,Dynamics 365 for Sales];
    OnInit=BEGIN
             CODEUNIT.RUN(CODEUNIT::"CRM Integration Management");
           END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 8       ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales] }
      { 7       ;2   ;Action    ;
                      Name=CRMGoToCase;
                      CaptionML=[DAN=Sag;
                                 ENU=Case];
                      ToolTipML=[DAN=F† vist sagen.;
                                 ENU=View the case.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=CoupledOrder;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 HYPERLINK(CRMIntegrationManagement.GetCRMEntityUrlFromCRMID(DATABASE::"CRM Incident",IncidentId));
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
                CaptionML=[DAN=Sagstitel;
                           ENU=Case Title];
                ToolTipML=[DAN=Angiver navnet p† sagen.;
                           ENU=Specifies the name of the case.];
                ApplicationArea=#Suite;
                SourceExpr=Title }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Status;
                           ENU=Status];
                ToolTipML=[DAN=Angiver status for sagen.;
                           ENU=Specifies the status of the case.];
                OptionCaptionML=[DAN=Aktiv,L›st,Annulleret;
                                 ENU=Active,Resolved,Canceled];
                ApplicationArea=#Suite;
                SourceExpr=StateCode }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Sagsnummer;
                           ENU=Case Number];
                ToolTipML=[DAN=Angiver nummeret p† sagen.;
                           ENU=Specifies the number of the case.];
                ApplicationArea=#Suite;
                SourceExpr=TicketNumber }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Oprettet d.;
                           ENU=Created On];
                ToolTipML=[DAN=Angiver, hvorn†r salgsordren blev oprettet.;
                           ENU=Specifies when the sales order was created.];
                ApplicationArea=#Suite;
                SourceExpr=CreatedOn }

  }
  CODE
  {

    BEGIN
    END.
  }
}

