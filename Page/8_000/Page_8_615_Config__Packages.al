OBJECT Page 8615 Config. Packages
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
    CaptionML=[DAN=Konfig.pakker;
               ENU=Config. Packages];
    SourceTable=Table8623;
    PageType=List;
    CardPageID=Config. Package Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Administrer,Pakke;
                                ENU=New,Process,Report,Manage,Package];
    OnInit=BEGIN
             SetActionVisibility;
           END;

    OnOpenPage=VAR
                 PermissionManager@1001 : Codeunit 9002;
                 OriginalFilterGroup@1000 : Integer;
               BEGIN
                 IF PermissionManager.SoftwareAsAService THEN BEGIN
                   CheckSaaSPackage;
                   OriginalFilterGroup := FILTERGROUP;
                   FILTERGROUP(25);
                   SETFILTER(Code,SaaSPackageCodeTxt);
                   FILTERGROUP(OriginalFilterGroup);
                 END;
               END;

    OnNewRecord=BEGIN
                  IF NOT ActionVisible THEN
                    ERROR(UnsupportedNewErr);
                END;

    OnInsertRecord=BEGIN
                     IF NOT ActionVisible THEN
                       ERROR(UnsupportedEditErr);
                   END;

    OnModifyRecord=BEGIN
                     IF NOT ActionVisible THEN
                       ERROR(UnsupportedEditErr);
                   END;

    OnDeleteRecord=BEGIN
                     IF NOT ActionVisible THEN
                       ERROR(UnsupportedDeleteErr);
                   END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=Pakke;
                                 ENU=Package] }
      { 22      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udl‘s pakke;
                                 ENU=Export Package];
                      ToolTipML=[DAN=Opret en .rapidstart-fil, som leverer pakkeindholdet i et komprimeret format. Konfigurationssp›rgeskemaer, konfigurationsskabeloner og konfigurationsregneark f›jes automatisk til pakken, medmindre du udtrykkeligt v‘lger at udelukke dem.;
                                 ENU=Create a .rapidstart file that which delivers the package contents in a compressed format. Configuration questionnaires, configuration templates, and the configuration worksheet are added to the package automatically unless you specifically decide to exclude them.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Export;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TESTFIELD(Code);
                                 ConfigXMLExchange.ExportPackage(Rec);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indl‘s pakke;
                                 ENU=Import Package];
                      ToolTipML=[DAN=Importer en .rapidstart-pakkefil.;
                                 ENU=Import a .rapidstart package file.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ConfigXMLExchange.ImportPackageXMLFromClient;
                               END;
                                }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Udl‘s til Excel;
                                 ENU=Export to Excel];
                      ToolTipML=[DAN=Eksport‚r dataene i pakken til Excel.;
                                 ENU=Export the data in the package to Excel.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ExportToExcel;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 ConfigPackageTable@1000 : Record 8613;
                                 ConfigExcelExchange@1001 : Codeunit 8618;
                               BEGIN
                                 TESTFIELD(Code);

                                 ConfigPackageTable.SETRANGE("Package Code",Code);
                                 IF CONFIRM(Text004,TRUE,Code) THEN
                                   ConfigExcelExchange.ExportExcelFromTables(ConfigPackageTable);
                               END;
                                }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Indl‘s fra Excel;
                                 ENU=Import from Excel];
                      ToolTipML=[DAN=Begynd migreringen af ‘ldre data.;
                                 ENU=Begin the migration of legacy data.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ImportExcel;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 ConfigExcelExchange@1000 : Codeunit 8618;
                               BEGIN
                                 ConfigExcelExchange.ImportExcelFromPackage;
                               END;
                                }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktioner;
                                 ENU=F&unctions] }
      { 19      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent tabeller;
                                 ENU=Get Tables];
                      ToolTipML=[DAN=V‘lg tabeller, som du vil f›je til konfigurationspakken.;
                                 ENU=Select tables that you want to add to the configuration package.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GetLines;
                      PromotedCategory=New;
                      OnAction=VAR
                                 GetPackageTables@1000 : Report 8616;
                               BEGIN
                                 CurrPage.SAVERECORD;
                                 GetPackageTables.Set(Code);
                                 GetPackageTables.RUNMODAL;
                                 CLEAR(GetPackageTables);
                               END;
                                }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Anvend pakke;
                                 ENU=Apply Package];
                      ToolTipML=[DAN=Importer konfigurationspakken, og anvend alle pakkedatabasedata p† samme tid.;
                                 ENU=Import the configuration package and apply the package database data at the same time.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Apply;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ConfigPackageTable@1002 : Record 8613;
                                 ConfigPackageMgt@1000 : Codeunit 8611;
                               BEGIN
                                 TESTFIELD(Code);
                                 IF CONFIRM(Text003,TRUE,Code) THEN BEGIN
                                   ConfigPackageTable.SETRANGE("Package Code",Code);
                                   ConfigPackageMgt.ApplyPackage(Rec,ConfigPackageTable,TRUE);
                                 END;
                               END;
                                }
      { 14      ;2   ;Action    ;
                      CaptionML=[DAN=Kopi‚r pakke;
                                 ENU=Copy Package];
                      ToolTipML=[DAN=Kopi‚r en eksisterende konfigurationspakke for at oprette en ny pakke baseret p† det samme indhold.;
                                 ENU=Copy an existing configuration package to create a new package based on the same content.];
                      ApplicationArea=#Advanced;
                      Image=CopyWorksheet;
                      OnAction=VAR
                                 CopyPackage@1000 : Report 8615;
                               BEGIN
                                 TESTFIELD(Code);
                                 CopyPackage.Set(Rec);
                                 CopyPackage.RUNMODAL;
                                 CLEAR(CopyPackage);
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Name=ValidatePackage;
                      CaptionML=[DAN=Valider pakke;
                                 ENU=Validate Package];
                      ToolTipML=[DAN=Bestem, om du har lavet fejl s†som ikke at inkludere tabeller, som konfigurationen er afh‘ngig af.;
                                 ENU=Determine if you have introduced errors, such as not including tables that the configuration relies on.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CheckRulesSyntax;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ConfigPackageTable@1000 : Record 8613;
                                 ActiveSession@1004 : Record 2000000110;
                                 SessionEvent@1005 : Record 2000000111;
                                 ConfigProgressBar@1001 : Codeunit 8615;
                                 Canceled@1002 : Boolean;
                               BEGIN
                                 IF CONFIRM(Text002,TRUE,"Package Name") THEN BEGIN
                                   ConfigPackageTable.SETRANGE("Package Code",Code);
                                   ConfigProgressBar.Init(ConfigPackageTable.COUNT,1,ValidatingTableRelationsMsg);

                                   BackgroundSessionId := 0;
                                   STARTSESSION(BackgroundSessionId,CODEUNIT::"Config. Validate Package",COMPANYNAME,ConfigPackageTable);

                                   ConfigPackageTable.SETRANGE(Validated,FALSE);
                                   ConfigPackageTable.SETCURRENTKEY("Package Processing Order","Processing Order");

                                   SLEEP(1000);
                                   WHILE NOT Canceled AND ActiveSession.GET(SERVICEINSTANCEID,BackgroundSessionId) AND ConfigPackageTable.FINDFIRST DO BEGIN
                                     ConfigPackageTable.CALCFIELDS("Table Name");
                                     Canceled := NOT ConfigProgressBar.UpdateCount(ConfigPackageTable."Table Name",ConfigPackageTable.COUNT);
                                     SLEEP(1000);
                                   END;

                                   IF ActiveSession.GET(SERVICEINSTANCEID,BackgroundSessionId) THEN
                                     STOPSESSION(BackgroundSessionId,ValidationCanceledMsg);

                                   IF NOT Canceled AND ConfigPackageTable.FINDFIRST THEN BEGIN
                                     SessionEvent.SETASCENDING("Event Datetime",TRUE);
                                     SessionEvent.SETRANGE("User ID",USERID);
                                     SessionEvent.SETRANGE("Server Instance ID",SERVICEINSTANCEID);
                                     SessionEvent.SETRANGE("Session ID",BackgroundSessionId);
                                     SessionEvent.FINDLAST;
                                     MESSAGE(SessionEvent.Comment);
                                   END;

                                   ConfigProgressBar.Close;
                                 END;
                               END;
                                }
      { 12      ;2   ;Separator  }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Udl‘s til overs‘ttelse;
                                 ENU=Export to Translation];
                      ToolTipML=[DAN=Eksport‚r dataene til en fil, der er egnet til overs‘ttelse.;
                                 ENU=Export the data to a file that is suited translation.];
                      ApplicationArea=#Advanced;
                      Visible=FALSE;
                      Image=Export;
                      OnAction=VAR
                                 ConfigPackageTable@1001 : Record 8613;
                               BEGIN
                                 TESTFIELD(Code);
                                 ConfigXMLExchange.SetAdvanced(TRUE);
                                 ConfigPackageTable.SETRANGE("Package Code",Code);
                                 IF CONFIRM(Text004,TRUE,Code) THEN
                                   ConfigXMLExchange.ExportPackageXML(ConfigPackageTable,'');
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                GroupType=Repeater }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for konfigurationspakken.;
                           ENU=Specifies a code for the configuration package.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† pakken.;
                           ENU=Specifies the name of the package.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Package Name" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det id for Windows-sproget, der skal bruges til konfigurationspakken. V‘lg feltet, og v‘lg et sprog-id p† listen.;
                           ENU=Specifies the ID of the Windows language to use for the configuration package. Choose the field and select a language ID from the list.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language ID" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den version af produktet, som du konfigurerer. Du kan bruge dette felt til at skelne mellem forskellige versioner af en l›sning.;
                           ENU=Specifies the version of the product that you are configuring. You can use this field to help differentiate among various versions of a solution.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Product Version" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ordre, hvori pakken skal behandles.;
                           ENU=Specifies the order in which the package is to be processed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Processing Order" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om konfigurationstabeller skal udelukkes fra pakken. Mark‚r afkrydsningsfeltet for at udelukke disse tabeltyper.;
                           ENU=Specifies whether to exclude configuration tables from the package. Select the check box to exclude these types of tables.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Exclude Config. Tables" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af tabeller, som pakken indeholder.;
                           ENU=Specifies the number of tables that the package contains.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Tables" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af records i pakken.;
                           ENU=Specifies the number of records in the package.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Records" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af fejl, som pakken indeholder.;
                           ENU=Specifies the number of errors that the package contains.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Errors" }

  }
  CODE
  {
    VAR
      ConfigXMLExchange@1000 : Codeunit 8614;
      Text002@1002 : TextConst 'DAN=Valider pakke %1?;ENU=Validate package %1?';
      Text003@1003 : TextConst 'DAN=Anvend data fra pakke %1?;ENU=Apply data from package %1?';
      Text004@1005 : TextConst 'DAN=Udl‘s pakke %1?;ENU=Export package %1?';
      ValidatingTableRelationsMsg@1004 : TextConst 'DAN=Validerer tabelrelationer;ENU=Validating table relations';
      ValidationCanceledMsg@1001 : TextConst 'DAN=Validering blev annulleret.;ENU=Validation canceled.';
      BackgroundSessionId@1007 : Integer;
      ActionVisible@1006 : Boolean;
      UnsupportedNewErr@1008 : TextConst 'DAN=Du kan ikke oprette nye konfigurationspakker.;ENU=You cannot create new Config. Packages.';
      UnsupportedEditErr@1009 : TextConst 'DAN=Du kan ikke redigere konfigurationspakker.;ENU=You cannot edit Config. Packages.';
      UnsupportedDeleteErr@1010 : TextConst 'DAN=Du kan ikke slette konfigurationspakker.;ENU=You cannot delete Config. Packages.';
      SaaSPackageCodeTxt@1011 : TextConst '@@@={Locked};DAN=DYNAMICS365;ENU=DYNAMICS365';
      PackageUpdateQst@1013 : TextConst 'DAN=Opdater Dynamics NAV-pakke?;ENU=Update the Dynamics NAV Package?';
      UpdateErrorMsg@1012 : TextConst 'DAN=Kunne ikke opdatere Dynamics NAV-pakken.;ENU=Unable to update the Dynamics NAV package.';
      OldSaaSPackageCodeTxt@1014 : TextConst '@@@={Locked};DAN=D365;ENU=D365';

    LOCAL PROCEDURE SetActionVisibility@1();
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      ActionVisible := NOT ApplicationAreaSetup.IsFoundationEnabled;  // Only hide for Basic and Suite
    END;

    LOCAL PROCEDURE CheckSaaSPackage@2();
    VAR
      ConfigPackage@1001 : Record 8623;
    BEGIN
      IF NOT ConfigPackage.WRITEPERMISSION THEN
        EXIT;

      DeleteOldSaaSPackage;

      IF NOT ConfigPackage.GET(SaaSPackageCodeTxt) THEN BEGIN
        CODEUNIT.RUN(CODEUNIT::"Create D365 RapidStart Package");
        EXIT;
      END;

      IF IsNewerSaaSPackage THEN
        IF CONFIRM(PackageUpdateQst,FALSE) THEN
          IF ConfigPackage.DELETE(TRUE) THEN
            CODEUNIT.RUN(CODEUNIT::"Create D365 RapidStart Package")
          ELSE
            MESSAGE(UpdateErrorMsg);
    END;

    LOCAL PROCEDURE IsNewerSaaSPackage@3() : Boolean;
    VAR
      ConfigPackageField@1000 : Record 8616;
    BEGIN
      IF ConfigPackageField.GET(SaaSPackageCodeTxt,3,8) THEN
        IF ConfigPackageField."Include Field" = FALSE THEN
          EXIT(FALSE);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE DeleteOldSaaSPackage@5();
    VAR
      ConfigPackage@1000 : Record 8623;
    BEGIN
      IF ConfigPackage.GET(OldSaaSPackageCodeTxt) THEN
        ConfigPackage.DELETE(TRUE);
    END;

    BEGIN
    END.
  }
}

