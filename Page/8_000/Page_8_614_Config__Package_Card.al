OBJECT Page 8614 Config. Package Card
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfig.pakkekort;
               ENU=Config. Package Card];
    SourceTable=Table8623;
    PageType=Document;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Administrer,Pakke;
                                ENU=New,Process,Report,Manage,Package];
    OnInit=BEGIN
             SetActionVisibility;
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
      { 11      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=Pakke;
                                 ENU=Package] }
      { 23      ;2   ;Action    ;
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
      { 22      ;2   ;Action    ;
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
      { 21      ;2   ;Action    ;
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
                                 IF CONFIRM(Text004,TRUE,Code,ConfigPackageTable.COUNT) THEN
                                   ConfigExcelExchange.ExportExcelFromTables(ConfigPackageTable);
                               END;
                                }
      { 20      ;2   ;Action    ;
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
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktioner;
                                 ENU=F&unctions] }
      { 17      ;2   ;Action    ;
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
      { 15      ;2   ;Action    ;
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
      { 13      ;2   ;Action    ;
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
      { 8       ;2   ;Action    ;
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
                                 TempConfigPackageTable@1001 : TEMPORARY Record 8613;
                                 ConfigPackageMgt@1002 : Codeunit 8611;
                               BEGIN
                                 IF CONFIRM(Text002,TRUE,"Package Name") THEN BEGIN
                                   ConfigPackageTable.SETRANGE("Package Code",Code);
                                   ConfigPackageMgt.ValidatePackageRelations(ConfigPackageTable,TempConfigPackageTable,TRUE);
                                 END;
                               END;
                                }
      { 7       ;2   ;Separator  }
      { 6       ;2   ;Action    ;
                      CaptionML=[DAN=Udl‘s til overs‘ttelse;
                                 ENU=Export to Translation];
                      ToolTipML=[DAN=Eksport‚r dataene til en fil, der er egnet til overs‘ttelse.;
                                 ENU=Export the data to a file that is suited for translation.];
                      ApplicationArea=#Advanced;
                      Visible=FALSE;
                      Image=Export;
                      OnAction=VAR
                                 ConfigPackageTable@1001 : Record 8613;
                               BEGIN
                                 TESTFIELD(Code);

                                 ConfigXMLExchange.SetAdvanced(TRUE);
                                 ConfigPackageTable.SETRANGE("Package Code",Code);
                                 IF CONFIRM(Text004,TRUE,Code,ConfigPackageTable.COUNT) THEN
                                   ConfigXMLExchange.ExportPackageXML(ConfigPackageTable,'');
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=ProcessData;
                      CaptionML=[DAN=Behandl data;
                                 ENU=Process Data];
                      ToolTipML=[DAN=Behandl data i konfigurationspakken, f›r du anvender dem i databasen. For eksempel kan du konvertere datoer og decimaler til det format, der kr‘ves af de regionale indstillinger p† en brugers computer og fjerne foranstillede/efterstillede mellemrum eller specialtegn.;
                                 ENU=Process data in the configuration package before you apply it to the database. For example, convert dates and decimals to the format required by the regional settings on a user's computer and remove leading/trailing spaces or special characters.];
                      ApplicationArea=#Basic,#Suite;
                      Image=DataEntry;
                      OnAction=BEGIN
                                 ProcessPackageTablesWithDefaultProcessingReport;
                                 ProcessPackageTablesWithCustomProcessingReports;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for konfigurationspakken.;
                           ENU=Specifies a code for the configuration package.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code;
                ShowMandatory=TRUE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† pakken.;
                           ENU=Specifies the name of the package.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Package Name";
                ShowMandatory=TRUE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den version af produktet, som du konfigurerer. Du kan bruge dette felt til at skelne mellem forskellige versioner af en l›sning.;
                           ENU=Specifies the version of the product that you are configuring. You can use this field to help differentiate among various versions of a solution.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Product Version" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det id for Windows-sproget, der skal bruges til konfigurationspakken. V‘lg feltet, og v‘lg et sprog-id p† listen.;
                           ENU=Specifies the ID of the Windows language to use for the configuration package. Choose the field and select a language ID from the list.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language ID" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ordre, hvori pakken skal behandles.;
                           ENU=Specifies the order in which the package is to be processed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Processing Order" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om konfigurationstabeller skal udelukkes fra pakken. Mark‚r afkrydsningsfeltet for at udelukke disse tabeltyper.;
                           ENU=Specifies whether to exclude configuration tables from the package. Select the check box to exclude these types of tables.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Exclude Config. Tables" }

    { 10  ;1   ;Part      ;
                ApplicationArea=#Advanced;
                SubPageView=SORTING(Package Code,Table ID);
                SubPageLink=Package Code=FIELD(Code);
                PagePartID=Page8625;
                PartType=Page }

    { 16  ;1   ;Part      ;
                ApplicationArea=#Basic,#Suite;
                SubPageView=SORTING(Package Code,Table ID);
                SubPageLink=Package Code=FIELD(Code);
                PagePartID=Page8637;
                Visible=NOT ActionVisible;
                PartType=Page }

  }
  CODE
  {
    VAR
      ConfigXMLExchange@1001 : Codeunit 8614;
      Text002@1005 : TextConst 'DAN=Valider pakke %1?;ENU=Validate package %1?';
      Text003@1004 : TextConst 'DAN=Anvend data fra pakke %1?;ENU=Apply data from package %1?';
      Text004@1003 : TextConst 'DAN=Udl‘s pakke %1 med tabellerne %2?;ENU=Export package %1 with %2 tables?';
      ActionVisible@1000 : Boolean;
      UnsupportedNewErr@1002 : TextConst 'DAN=Du kan ikke oprette nye konfigurationspakker.;ENU=You cannot create new Config. Packages.';
      UnsupportedEditErr@1006 : TextConst 'DAN=Du kan ikke redigere konfigurationspakker.;ENU=You cannot edit Config. Packages.';
      UnsupportedDeleteErr@1007 : TextConst 'DAN=Du kan ikke slette konfigurationspakker.;ENU=You cannot delete Config. Packages.';

    LOCAL PROCEDURE ProcessPackageTablesWithDefaultProcessingReport@2();
    VAR
      ConfigPackageTable@1000 : Record 8613;
    BEGIN
      ConfigPackageTable.SETRANGE("Package Code",Code);
      ConfigPackageTable.SETRANGE("Processing Report ID",0);
      IF NOT ConfigPackageTable.ISEMPTY THEN
        REPORT.RUNMODAL(REPORT::"Config. Package - Process",FALSE,FALSE,ConfigPackageTable);
    END;

    LOCAL PROCEDURE ProcessPackageTablesWithCustomProcessingReports@3();
    VAR
      ConfigPackageTable@1000 : Record 8613;
    BEGIN
      ConfigPackageTable.SETRANGE("Package Code",Code);
      ConfigPackageTable.SETFILTER("Processing Report ID",'<>0',0);
      IF ConfigPackageTable.FINDSET THEN
        REPEAT
          REPORT.RUNMODAL(ConfigPackageTable."Processing Report ID",FALSE,FALSE,ConfigPackageTable)
        UNTIL ConfigPackageTable.NEXT = 0;
    END;

    LOCAL PROCEDURE SetActionVisibility@1();
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      ActionVisible := NOT ApplicationAreaSetup.IsFoundationEnabled;  // Only hide for Basic and Suite
    END;

    BEGIN
    END.
  }
}

