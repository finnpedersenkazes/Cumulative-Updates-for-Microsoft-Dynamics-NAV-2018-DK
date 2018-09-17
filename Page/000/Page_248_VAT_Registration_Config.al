OBJECT Page 248 VAT Registration Config
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Serviceops‘tning for validering af SE/CVR-nr. for EU;
               ENU=EU VAT Reg. No. Validation Service Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table248;
    DataCaptionExpr='';
    PopulateAllFields=No;
    PageType=Card;
    ShowFilter=No;
    OnOpenPage=BEGIN
                 IF NOT GET THEN
                   InitVATRegNrValidationSetup
               END;

    ActionList=ACTIONS
    {
      { 4       ;    ;ActionContainer;
                      Name=General;
                      ActionContainerType=NewDocumentItems }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Generelt;
                                 ENU=General] }
      { 6       ;2   ;Action    ;
                      Name=SettoDefault;
                      CaptionML=[DAN=Angiv standardslutpunkt;
                                 ENU=Set Default Endpoint];
                      ToolTipML=[DAN=Angiv URL-standardadressen i feltet Slutpunkt for tjeneste.;
                                 ENU=Set the default URL in the Service Endpoint field.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Default;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 VATLookupExtDataHndl@1000 : Codeunit 248;
                               BEGIN
                                 IF Enabled THEN
                                   IF CONFIRM(DisableServiceQst) THEN
                                     Enabled := FALSE
                                   ELSE
                                     EXIT;

                                 "Service Endpoint" := VATLookupExtDataHndl.GetVATRegNrValidationWebServiceURL;
                                 MODIFY(TRUE);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                CaptionML=[DAN=Serviceops‘tning for validering af SE/CVR-nr. for EU;
                           ENU=EU VAT Reg. No. Validation Service Setup];
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group;
                InstructionalTextML=[DAN=VAT Information Exchange System (system til udveksling af momsoplysninger) er en elektronisk metode til kontrol af momsnumre tilh›rende ›konomiske beslutningstagere i EU ved transaktioner af varer og tjenester p† tv‘rs af lande-/omr†degr‘nser.;
                                     ENU=VAT Information Exchange System is an electronic means of validating VAT identification numbers of economic operators registered in the European Union for cross-border transactions on goods and services.] }

    { 5   ;2   ;Field     ;
                Name=ServiceEndpoint;
                ToolTipML=[DAN=Angiver slutpunktet for CVR-nummerets valideringsservice.;
                           ENU=Specifies the endpoint of the VAT registration number validation service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Service Endpoint";
                Editable=NOT Enabled }

    { 3   ;2   ;Field     ;
                Name=Enabled;
                ToolTipML=[DAN=Angiver, om tjenesten er aktiveret.;
                           ENU=Specifies if the service is enabled.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Enabled;
                OnValidate=BEGIN
                             IF Enabled = xRec.Enabled THEN
                               EXIT;

                             IF Enabled THEN BEGIN
                               TESTFIELD("Service Endpoint");
                               MESSAGE(TermsAndAgreementMsg);
                             END;
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et link til oplysninger om ansvarsfraskrivelse for tjenesten.;
                           ENU=Specifies a hyperlink to disclaimer information for the service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TermsOfServiceLbl;
                Editable=FALSE;
                OnDrillDown=VAR
                              VATRegistrationLogMgt@1000 : Codeunit 249;
                            BEGIN
                              HYPERLINK(VATRegistrationLogMgt.GetServiceDisclaimerUR);
                            END;

                ShowCaption=No }

  }
  CODE
  {
    VAR
      DisableServiceQst@1000 : TextConst 'DAN=Du skal sl† tjenesten fra, mens du angiver standardv‘rdierne. Skal vi sl† den fra for dig?;ENU=You must turn off the service while you set default values. Should we turn it off for you?';
      TermsAndAgreementMsg@1003 : TextConst 'DAN=Du er ved at †bne et websted og en service fra en tredjepart. Gennemse ansvarsfraskrivelsen, f›r du forts‘tter.;ENU=You are accessing a third-party website and service. Review the disclaimer before you continue.';
      TermsOfServiceLbl@1002 : TextConst 'DAN=Ansvarsfraskrivelse for momsregistreringstjeneste;ENU=VAT registration service (VIES) disclaimer';

    LOCAL PROCEDURE InitVATRegNrValidationSetup@22();
    VAR
      PermissionManager@1002 : Codeunit 9002;
      VATLookupExtDataHndl@1001 : Codeunit 248;
    BEGIN
      IF FINDFIRST THEN
        EXIT;

      INIT;
      "Service Endpoint" := VATLookupExtDataHndl.GetVATRegNrValidationWebServiceURL;
      Enabled := NOT PermissionManager.SoftwareAsAService;
      INSERT;
    END;

    BEGIN
    END.
  }
}

