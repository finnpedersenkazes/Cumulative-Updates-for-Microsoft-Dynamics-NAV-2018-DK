OBJECT Page 1651 Curr. Exch. Rate Service Card
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Valutakurstjeneste;
               ENU=Currency Exch. Rate Service];
    SourceTable=Table1650;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Ops‘tning;
                                ENU=New,Process,Report,Setup];
    OnOpenPage=VAR
                 PermissionManager@1000 : Codeunit 9002;
               BEGIN
                 CODEUNIT.RUN(CODEUNIT::"Check App. Area Only Basic");

                 UpdateBasedOnEnable;
                 IsSoftwareAsService := PermissionManager.SoftwareAsAService;
               END;

    OnInsertRecord=VAR
                     TempField@1002 : TEMPORARY Record 2000000041;
                     MapCurrencyExchangeRate@1001 : Codeunit 1280;
                   BEGIN
                     MapCurrencyExchangeRate.GetSuggestedFields(TempField);
                     CurrPage.SimpleDataExchSetup.PAGE.SetSuggestedField(TempField);
                     UpdateSimpleMappingsPart;
                   END;

    OnQueryClosePage=BEGIN
                       IF NOT Enabled THEN
                         IF NOT CONFIRM(STRSUBSTNO(EnableServiceQst,CurrPage.CAPTION),TRUE) THEN
                           EXIT(FALSE);
                     END;

    OnAfterGetCurrRecord=BEGIN
                           GetWebServiceURL(WebServiceURL);
                           IF WebServiceURL <> '' THEN
                             GenerateXMLStructure;

                           UpdateSimpleMappingsPart;
                           UpdateBasedOnEnable;
                         END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      Name=Process;
                      CaptionML=[DAN=Proces;
                                 ENU=Process];
                      ActionContainerType=ActionItems }
      { 10      ;1   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis eksempel;
                                 ENU=Preview];
                      ToolTipML=[DAN=Kontroller ops‘tningen af valutakurstjenesten for at sikre, at tjenesten fungerer.;
                                 ENU=Test the setup of the currency exchange rate service to make sure the service is working.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReviewWorksheet;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 TempCurrencyExchangeRate@1001 : TEMPORARY Record 330;
                                 UpdateCurrencyExchangeRates@1000 : Codeunit 1281;
                               BEGIN
                                 TESTFIELD(Code);
                                 VerifyServiceURL;
                                 VerifyDataExchangeLineDefinition;
                                 UpdateCurrencyExchangeRates.GenerateTempDataFromService(TempCurrencyExchangeRate,Rec);
                                 PAGE.RUN(PAGE::"Currency Exchange Rates",TempCurrencyExchangeRate);
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=JobQueueEntry;
                      CaptionML=[DAN=Opgavek›post;
                                 ENU=Job Queue Entry];
                      ToolTipML=[DAN=Se eller rediger den sag, der opdaterer valutakurserne fra tjenesten, f.eks. kan du f† vist status eller ‘ndre, hvor hyppigt kurserne opdateres.;
                                 ENU=View or edit the job that updates the exchange rates from the service. For example, you can see the status or change how often rates are updated.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=Enabled;
                      Image=JobListSetup;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowJobQueueEntry;
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
                GroupType=Group }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ops‘tningen af en service, der opdaterer valutakurserne.;
                           ENU=Specifies the setup of a service to update currency exchange rates.];
                ApplicationArea=#Suite;
                SourceExpr=Code;
                Editable=EditableByNotEnabled }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ops‘tningen af en service, der opdaterer valutakurserne.;
                           ENU=Specifies the setup of a service to update currency exchange rates.];
                ApplicationArea=#Suite;
                SourceExpr=Description;
                Editable=EditableByNotEnabled }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om valutakurstjenesten er aktiveret. Det er kun muligt at aktivere ‚n tjeneste ad gangen.;
                           ENU=Specifies if the currency exchange rate service is enabled. Only one service can be enabled at a time.];
                ApplicationArea=#Suite;
                SourceExpr=Enabled;
                OnValidate=BEGIN
                             EditableByNotEnabled := NOT Enabled;
                             CurrPage.UPDATE;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShowEnableWarning;
                Enabled=NOT EditableByNotEnabled;
                Editable=false;
                OnDrillDown=BEGIN
                              DrilldownCode;
                            END;
                             }

    { 4   ;1   ;Group     ;
                CaptionML=[DAN=Service;
                           ENU=Service];
                GroupType=Group }

    { 11  ;2   ;Field     ;
                Name=ServiceURL;
                CaptionML=[DAN=URL-adresse til tjeneste;
                           ENU=Service URL];
                ToolTipML=[DAN=Angiver, om valutakurstjenesten er aktiveret. Det er kun muligt at aktivere ‚n tjeneste ad gangen.;
                           ENU=Specifies if the currency exchange rate service is enabled. Only one service can be enabled at a time.];
                ApplicationArea=#Suite;
                SourceExpr=WebServiceURL;
                Editable=EditableByNotEnabled;
                MultiLine=Yes;
                OnValidate=BEGIN
                             SetWebServiceURL(WebServiceURL);
                             GenerateXMLStructure;
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† tjenesteudbyderen.;
                           ENU=Specifies the name of the service provider.];
                ApplicationArea=#Suite;
                SourceExpr="Service Provider";
                Editable=EditableByNotEnabled }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver URL-adressen p† tjenesteudbyderens servicevilk†r.;
                           ENU=Specifies the URL of the service provider's terms of service.];
                ApplicationArea=#Suite;
                SourceExpr="Terms of Service";
                Editable=EditableByNotEnabled }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om webanmodninger, som optr‘der i forbindelse med tjenesten, bliver logf›rt. Logfilen er placeres i serverens midlertidige mappe.;
                           ENU=Specifies if web requests occurring in connection with the service are logged. The log is located in the server Temp folder.];
                ApplicationArea=#Advanced;
                SourceExpr="Log Web Requests";
                Visible=NOT IsSoftwareAsService;
                Editable=EditableByNotEnabled }

    { 6   ;1   ;Part      ;
                Name=SimpleDataExchSetup;
                ApplicationArea=#Suite;
                PagePartID=Page1265;
                Editable=EditableByNotEnabled;
                PartType=Page }

  }
  CODE
  {
    VAR
      TempXMLBuffer@1001 : TEMPORARY Record 1235;
      WebServiceURL@1000 : Text;
      EditableByNotEnabled@1002 : Boolean;
      EnabledWarningTok@1004 : TextConst 'DAN=Du skal deaktivere tjenesten, f›r du kan foretage ‘ndringer.;ENU=You must disable the service before you can make changes.';
      DisableEnableQst@1003 : TextConst 'DAN=Vil du deaktivere valutakurstjenesten?;ENU=Do you want to disable currency exchange rate service?';
      IsSoftwareAsService@1008 : Boolean;
      ShowEnableWarning@1005 : Text;
      EnableServiceQst@1006 : TextConst '@@@="%1 = This Page Caption (Currency Exch. Rate Service)";DAN=%1 er ikke aktiveret. Er du sikker p†, at du vil afslutte?;ENU=The %1 is not enabled. Are you sure you want to exit?';
      XmlStructureIsNotSupportedErr@1007 : TextConst 'DAN=" Den angivne webadresse indeholder ikke en underst›ttet struktur.";ENU=" The provided url does not contain a supported structure."';
      InternalErr@1009 : TextConst 'DAN=Tjenesten er ikke tilg‘ngelig i ›jeblikket. Pr›v igen senere.;ENU=The service is temporarily unavailable. Please try again later.';
      YahooInternalErrorTok@1010 : TextConst '@@@={Locked};DAN=No definition found for Table;ENU=No definition found for Table';

    LOCAL PROCEDURE UpdateSimpleMappingsPart@2();
    BEGIN
      CurrPage.SimpleDataExchSetup.PAGE.SetDataExchDefCode("Data Exch. Def Code");
      CurrPage.SimpleDataExchSetup.PAGE.UpdateData;
      CurrPage.SimpleDataExchSetup.PAGE.UPDATE(FALSE);
      CurrPage.SimpleDataExchSetup.PAGE.SetSourceToBeMandatory("Web Service URL".HASVALUE);
    END;

    LOCAL PROCEDURE GenerateXMLStructure@1();
    BEGIN
      TempXMLBuffer.RESET;
      TempXMLBuffer.DELETEALL;
      IF GetXMLStructure(TempXMLBuffer,WebServiceURL) THEN BEGIN
        TempXMLBuffer.RESET;
        CurrPage.SimpleDataExchSetup.PAGE.SetXMLDefinition(TempXMLBuffer);
      END ELSE
        ShowHttpError;
    END;

    LOCAL PROCEDURE UpdateBasedOnEnable@4();
    BEGIN
      EditableByNotEnabled := NOT Enabled;
      ShowEnableWarning := '';
      IF CurrPage.EDITABLE AND Enabled THEN
        ShowEnableWarning := EnabledWarningTok;
    END;

    LOCAL PROCEDURE DrilldownCode@3();
    BEGIN
      IF CONFIRM(DisableEnableQst,TRUE) THEN BEGIN
        Enabled := FALSE;
        UpdateBasedOnEnable;
        CurrPage.UPDATE;
      END;
    END;

    LOCAL PROCEDURE ShowHttpError@8();
    VAR
      ActivityLog@1000 : Record 710;
      WebRequestHelper@1006 : Codeunit 1299;
      XMLDOMMgt@1005 : Codeunit 6224;
      WebException@1004 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Net.WebException";
      XmlNode@1003 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlNode";
      ResponseInputStream@1002 : InStream;
      ErrorText@1001 : Text;
    BEGIN
      ErrorText := WebRequestHelper.GetWebResponseError(WebException,WebServiceURL);

      ActivityLog.LogActivity(Rec,ActivityLog.Status::Failed,"Service Provider",Description,ErrorText);

      IF ISNULL(WebException.Response) THEN
        ERROR(ErrorText);

      ResponseInputStream := WebException.Response.GetResponseStream;

      XMLDOMMgt.LoadXMLNodeFromInStream(ResponseInputStream,XmlNode);

      ErrorText := XMLDOMMgt.FindNodeText(XmlNode,'description');
      IF STRPOS(ErrorText,YahooInternalErrorTok) <> 0 THEN
        ErrorText := InternalErr
      ELSE
        ErrorText := XmlStructureIsNotSupportedErr;

      ERROR(ErrorText);
    END;

    BEGIN
    END.
  }
}

