OBJECT Page 2503 Extension Installation
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Installation af udvidelse;
               ENU=Extension Installation];
    SourceTable=Table2000000160;
    PageType=NavigatePage;
    SourceTableTemporary=Yes;
    OnOpenPage=VAR
                 WinLanguagesTable@1000 : Record 2000000045;
                 NavAppTable@1001 : Record 2000000160;
                 NavExtensionInstallationMgmt@1002 : Codeunit 2500;
               BEGIN
                 GetDetailsFromFilters;
                 ExtensionPkgId := "Package ID";
                 ExtensionAppId := ID;
                 TelemetryUrl := responseUrl;
                 ReviewVisible := FALSE;

                 RESET;

                 NavAppTable.SETFILTER("Package ID",'%1',ExtensionPkgId);
                 ExtensionNotFound := NOT NavAppTable.FINDFIRST;

                 NotFoundMsg := STRSUBSTNO(ExtensionNotFoundLbl,'Package',ExtensionPkgId);

                 // If extension not found by package id, search for app id
                 IF ExtensionNotFound AND (NOT ISNULLGUID(ExtensionAppId)) THEN BEGIN
                   NavAppTable.SETFILTER("Package ID",'%1',NavExtensionInstallationMgmt.GetLatestVersionPackageId(ExtensionAppId));
                   ExtensionNotFound := NOT NavAppTable.FINDFIRST;
                   NotFoundMsg := STRSUBSTNO(ExtensionNotFoundLbl,'App',ExtensionAppId);
                 END;

                 IF NOT ExtensionNotFound THEN BEGIN
                   ReviewVisible := TRUE;

                   IF Name = '' THEN
                     "Package ID" := NavAppTable."Package ID";

                   LanguageID := GLOBALLANGUAGE;
                   WinLanguagesTable.SETRANGE("Language ID",LanguageID);
                   IF WinLanguagesTable.FINDFIRST THEN
                     LanguageName := WinLanguagesTable.Name;
                 END;

                 CurrPage.UPDATE;
               END;

    ActionList=ACTIONS
    {
      { 10      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 17      ;1   ;Action    ;
                      Name=Ok;
                      ApplicationArea=#Basic,#Suite;
                      Visible=ExtensionNotFound;
                      InFooterBar=Yes;
                      Image=NextRecord;
                      OnAction=BEGIN
                                 CurrPage.CLOSE;
                               END;
                                }
      { 11      ;1   ;Action    ;
                      Name=Install;
                      CaptionML=[DAN=Installer;
                                 ENU=Install];
                      ApplicationArea=#Basic,#Suite;
                      Visible=ReviewVisible;
                      InFooterBar=Yes;
                      Image=Approve;
                      OnAction=VAR
                                 NavExtensionInstallationMgmt@1003 : Codeunit 2500;
                                 ExtensionInstallationDialog@1002 : Page 2505;
                                 Dependencies@1000 : Text;
                                 CanChange@1001 : Boolean;
                                 Result@1005 : Option;
                               BEGIN
                                 CanChange := NavExtensionInstallationMgmt.IsInstalled("Package ID");

                                 IF CanChange THEN BEGIN
                                   MESSAGE(STRSUBSTNO(AlreadyInstalledMsg,Name));
                                   EXIT;
                                 END;

                                 Dependencies := NavExtensionInstallationMgmt.GetDependenciesForExtensionToInstall("Package ID");
                                 CanChange := (STRLEN(Dependencies) = 0);

                                 IF NOT CanChange THEN
                                   CanChange := CONFIRM(STRSUBSTNO(DependenciesFoundQst,Name,Dependencies),FALSE);

                                 Result := OperationResult::Successful;
                                 IF CanChange THEN BEGIN
                                   ExtensionInstallationDialog.SETRECORD(Rec);
                                   ExtensionInstallationDialog.SetLanguageId(LanguageID);
                                   IF NOT (ExtensionInstallationDialog.RUNMODAL = ACTION::OK) THEN
                                     Result := OperationResult::DeploymentFailedDueToPackage;
                                 END;

                                 MakeTelemetryCallback(Result);
                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                Name=Container;
                ContainerType=ContentArea }

    { 7   ;1   ;Group     ;
                Visible=ReviewVisible;
                GroupType=Group;
                Layout=Columns }

    { 9   ;2   ;Part      ;
                Name=ReviewPart;
                CaptionML=[DAN=Gennemse oplysninger om udvidelse;
                           ENU=Review Extension Installation Details];
                ApplicationArea=#Basic,#Suite;
                SubPageView=SORTING(Package ID)
                            ORDER(Ascending);
                SubPageLink=Package ID=FIELD(Package ID);
                PagePartID=Page2504;
                PartType=Page;
                ShowFilter=No }

    { 3   ;2   ;Group     ;
                GroupType=Group }

    { 6   ;3   ;Field     ;
                Name=Language;
                CaptionML=[DAN=Sprog;
                           ENU=Language];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=LanguageName;
                OnValidate=VAR
                             WinLanguagesTable@1000 : Record 2000000045;
                           BEGIN
                             WinLanguagesTable.SETRANGE(Name,LanguageName);
                             WinLanguagesTable.SETRANGE("Globally Enabled",TRUE);
                             WinLanguagesTable.SETRANGE("Localization Exist",TRUE);
                             IF WinLanguagesTable.FINDFIRST THEN
                               LanguageID := WinLanguagesTable."Language ID"
                             ELSE
                               ERROR(LanguageNotFoundErr,LanguageName);
                           END;

                OnLookup=VAR
                           WinLanguagesTable@1000 : Record 2000000045;
                         BEGIN
                           WinLanguagesTable.SETRANGE("Globally Enabled",TRUE);
                           WinLanguagesTable.SETRANGE("Localization Exist",TRUE);
                           IF PAGE.RUNMODAL(PAGE::"Windows Languages",WinLanguagesTable) = ACTION::LookupOK THEN BEGIN
                             LanguageID := WinLanguagesTable."Language ID";
                             LanguageName := WinLanguagesTable.Name;
                           END;
                         END;
                          }

    { 2   ;1   ;Group     ;
                Visible=ExtensionNotFound;
                GroupType=Group }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Udvidelse ikke fundet;
                           ENU=Extension not found];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NotFoundMsg;
                Editable=FALSE;
                MultiLine=Yes;
                ShowCaption=No }

  }
  CODE
  {
    VAR
      LanguageNotFoundErr@1004 : TextConst '@@@="Error message to notify user that the entered language was not found. This could mean that the language doesn''t exist or that the language is not valid within the filter set for the lookup. %1=Entered value.";DAN=Det angivne sprog %1 blev ikke fundet. Tryk p† knappen til opslag for at v‘lge et sprog.;ENU=Cannot find the specified language, %1. Choose the lookup button to select a language.';
      LanguageID@1005 : Integer;
      LanguageName@1006 : Text;
      AlreadyInstalledMsg@1008 : TextConst '@@@="%1=name of app";DAN=Udvidelsen %1 er allerede installeret.;ENU=The extension %1 is already installed.';
      ExtensionPkgId@1014 : Text;
      ExtensionAppId@1000 : Text;
      NotFoundMsg@1017 : Text;
      ExtensionNotFound@1013 : Boolean;
      ReviewVisible@1001 : Boolean;
      ExtensionNotFoundLbl@1002 : TextConst '@@@="%1=id type (package vs app), %2=target extension id";DAN=Der blev ikke fundet en udvidelse til det angivne m†l %1 med id''et %2.\\Udvidelsen er ikke udgivet.;ENU=Could not find an extension for the specified target, %1 with the ID %2.\\Extension is not published.';
      DependenciesFoundQst@1003 : TextConst '@@@="%1=name of app, %2=semicolon separated list of uninstalled dependencies";DAN=Udvidelsen %1 har en afh‘ngighed af en eller flere udvidelser: %2.\\Vil du installere %1 og alle dens afh‘ngigheder?;ENU=The extension %1 has a dependency on one or more extensions: %2.\\Do you wish to install %1 and all of its dependencies?';
      TelemetryUrl@1010 : Text;
      OperationResult@1012 : 'UserNotAuthorized,DeploymentFailedDueToPackage,DeploymentFailed,Successful,UserCancel,UserTimeOut';

    LOCAL PROCEDURE GetDetailsFromFilters@1();
    VAR
      Field@1000 : Record 2000000041;
      TypeHelper@1002 : Codeunit 10;
      RecRef@1001 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      IF TypeHelper.FindFields(RecRef.NUMBER,Field) THEN
        REPEAT
          ParseFilter(RecRef.FIELD(Field."No."));
        UNTIL Field.NEXT = 0;
      RecRef.SETTABLE(Rec);
    END;

    LOCAL PROCEDURE ParseFilter@2(FieldRef@1003 : FieldRef);
    VAR
      FilterPrefixRegEx@1002 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
      SingleQuoteRegEx@1001 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
      EscapedEqualityRegEx@1004 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
      Filter@1000 : Text;
    BEGIN
      FilterPrefixRegEx := FilterPrefixRegEx.Regex('^@\*([^\\]+)\*$');
      SingleQuoteRegEx := SingleQuoteRegEx.Regex('^''([^\\]+)''$');
      EscapedEqualityRegEx := EscapedEqualityRegEx.Regex('~');
      Filter := FieldRef.GETFILTER;
      Filter := FilterPrefixRegEx.Replace(Filter,'$1');
      Filter := SingleQuoteRegEx.Replace(Filter,'$1');
      Filter := EscapedEqualityRegEx.Replace(Filter,'=');

      IF Filter <> '' THEN
        FieldRef.VALUE(Filter);
    END;

    LOCAL PROCEDURE MakeTelemetryCallback@4(Result@1000 : 'UserNotAuthorized,DeploymentFailedDueToPackage,DeploymentFailed,Successful,UserCancel,UserTimeOut');
    VAR
      ExtensionMarketplaceMgmt@1001 : Codeunit 2501;
    BEGIN
      IF TelemetryUrl <> '' THEN
        ExtensionMarketplaceMgmt.MakeMarketplaceTelemetryCallback(TelemetryUrl,Result,"Package ID");
    END;

    BEGIN
    END.
  }
}

