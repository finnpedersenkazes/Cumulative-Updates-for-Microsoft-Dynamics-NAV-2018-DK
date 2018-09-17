OBJECT Page 5335 Integration Table Mapping List
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Integrationstabelkoblinger;
               ENU=Integration Table Mappings];
    InsertAllowed=No;
    SourceTable=Table5335;
    SourceTableView=WHERE(Delete After Synchronization=CONST(No));
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Synkronisering,Kobling;
                                ENU=New,Process,Report,Synchronization,Mapping];
    OnAfterGetRecord=BEGIN
                       IntegrationTableCaptionValue := ObjectTranslation.TranslateObject(ObjectTranslation."Object Type"::Table,"Integration Table ID");
                       TableCaptionValue := ObjectTranslation.TranslateObject(ObjectTranslation."Object Type"::Table,"Table ID");
                       IntegrationFieldCaptionValue := GetFieldCaption;
                       IntegrationFieldTypeValue := GetFieldType;

                       TableFilter := GetTableFilter;
                       IntegrationTableFilter := GetIntegrationTableFilter;

                       HasRecords := NOT ISEMPTY;
                     END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 18      ;1   ;Action    ;
                      Name=FieldMapping;
                      CaptionML=[DAN=Felter;
                                 ENU=Fields];
                      ToolTipML=[DAN=Vis felter i Dynamics 365 for Sales-integrationstabeller, der er tilknyttet til felter i Dynamics NAV.;
                                 ENU=View fields in Dynamics 365 for Sales integration tables that are mapped to fields in Dynamics NAV.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5361;
                      RunPageLink=Integration Table Mapping Name=FIELD(Name);
                      Promoted=Yes;
                      Enabled=HasRecords;
                      PromotedIsBig=Yes;
                      Image=Relationship;
                      PromotedCategory=Category5;
                      RunPageMode=View }
      { 10      ;1   ;Action    ;
                      Name=View Integration Synch. Job Log;
                      CaptionML=[DAN=Logfil til integrationssynk.job;
                                 ENU=Integration Synch. Job Log];
                      ToolTipML=[DAN=Vis status for de enkelte synkroniseringsjobs, der har v‘ret k›rt for Dynamics 365 for Sales-integrationen. Dette omfatter synkroniseringsjobs, der er k›rt fra opgavek›en og manuelle synkroniseringsjobs, der blev udf›rt p† records fra Business Edition-klienten.;
                                 ENU=View the status of the individual synchronization jobs that have been run for the Dynamics 365 for Sales integration. This includes synchronization jobs that have been run from the job queue and manual synchronization jobs that were performed on records from the Business Edition client.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=HasRecords;
                      PromotedIsBig=Yes;
                      Image=Log;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 ShowLog('');
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Name=SynchronizeNow;
                      CaptionML=[DAN=Synkroniser ‘ndrede records;
                                 ENU=Synchronize Modified Records];
                      ToolTipML=[DAN=Synkroniser records, der er ‘ndret siden sidste gang, de blev synkroniseret.;
                                 ENU=Synchronize records that have been modified since the last time they were synchronized.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=HasRecords AND ("Parent Name" = '');
                      PromotedIsBig=Yes;
                      Image=Refresh;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 IntegrationSynchJobList@1000 : Page 5338;
                               BEGIN
                                 IF ISEMPTY THEN
                                   EXIT;

                                 SynchronizeNow(FALSE);
                                 MESSAGE(SynchronizedModifiedCompletedMsg,IntegrationSynchJobList.CAPTION);
                               END;
                                }
      { 14      ;1   ;Action    ;
                      Name=SynchronizeAll;
                      CaptionML=[DAN=K›r fuld synkronisering;
                                 ENU=Run Full Synchronization];
                      ToolTipML=[DAN=Start alle standardintegrationsjobs til synkronisering af Dynamics NAV-recordtyper og Dynamics 365 for Sales-poster som defineret i vinduet Integrationstabelkoblinger.;
                                 ENU=Start all the default integration jobs for synchronizing Dynamics NAV record types and Dynamics 365 for Sales entities, as defined in the Integration Table Mappings window.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=HasRecords AND ("Parent Name" = '');
                      Image=RefreshLines;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 IntegrationSynchJobList@1000 : Page 5338;
                               BEGIN
                                 IF ISEMPTY THEN
                                   EXIT;

                                 IF NOT CONFIRM(StartFullSynchronizationQst) THEN
                                   EXIT;
                                 SynchronizeNow(TRUE);
                                 MESSAGE(FullSynchronizationCompletedMsg,IntegrationSynchJobList.CAPTION);
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
                ToolTipML=[DAN=Angiver navnet p† posten for integrationstabeltilknytningen.;
                           ENU=Specifies the name of the integration table mapping entry.];
                ApplicationArea=#Suite;
                SourceExpr=Name;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Tabel;
                           ENU=Table];
                ToolTipML=[DAN=Angiver navnet p† den forretningsdatatabel i Dynamics NAV, der skal knyttes til integrationstabellen.;
                           ENU=Specifies the name of the business data table in Dynamics NAV to map to the integration table.];
                ApplicationArea=#Suite;
                SourceExpr=TableCaptionValue;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                Name=TableFilterValue;
                CaptionML=[DAN=Tabelfilter;
                           ENU=Table Filter];
                ToolTipML=[DAN=Angiver et filter for forretningsdatatabellen i Dynamics NAV til styring af, hvilke records der kan synkroniseres med de tilsvarende records i integrationstabellen, der er angivet i feltet Integrationstabel-id.;
                           ENU=Specifies a filter on the business data table in Dynamics NAV to control which records can be synchronized with the corresponding records in the integration table that is specified by the Integration Table ID field.];
                ApplicationArea=#Suite;
                SourceExpr=TableFilter;
                OnAssistEdit=VAR
                               FilterPageBuilder@1000 : FilterPageBuilder;
                             BEGIN
                               FilterPageBuilder.ADDTABLE(TableCaptionValue,"Table ID");
                               IF TableFilter <> '' THEN
                                 FilterPageBuilder.SETVIEW(TableCaptionValue,TableFilter);
                               IF FilterPageBuilder.RUNMODAL THEN BEGIN
                                 TableFilter := FilterPageBuilder.GETVIEW(TableCaptionValue,TRUE);
                                 SetTableFilter(TableFilter);
                               END;
                             END;
                              }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver synkroniseringsretningen.;
                           ENU=Specifies the synchronization direction.];
                ApplicationArea=#Suite;
                SourceExpr=Direction;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Integrationstabel;
                           ENU=Integration Table];
                ToolTipML=[DAN=Angiver id'et for den integrationstabel, der skal knyttes til forretningstabellen.;
                           ENU=Specifies the ID of the integration table to map to the business table.];
                ApplicationArea=#Suite;
                SourceExpr=IntegrationTableCaptionValue;
                Enabled=FALSE }

    { 16  ;2   ;Field     ;
                Name=IntegrationFieldCaption;
                CaptionML=[DAN=Integrationsfelt;
                           ENU=Integration Field];
                ToolTipML=[DAN=Angiver id'et for feltet i den integrationstabel, der skal knyttes til forretningstabellen.;
                           ENU=Specifies the ID of the field in the integration table to map to the business table.];
                ApplicationArea=#Suite;
                SourceExpr=IntegrationFieldCaptionValue;
                Editable=FALSE;
                OnDrillDown=VAR
                              CRMOptionMapping@1002 : Record 5334;
                              Field@1001 : Record 2000000041;
                            BEGIN
                              IF "Int. Table UID Field Type" = Field.Type::Option THEN BEGIN
                                CRMOptionMapping.FILTERGROUP(2);
                                CRMOptionMapping.SETRANGE("Table ID","Table ID");
                                CRMOptionMapping.FILTERGROUP(0);
                                PAGE.RUNMODAL(PAGE::"CRM Option Mapping",CRMOptionMapping);
                              END;
                            END;
                             }

    { 17  ;2   ;Field     ;
                Name=IntegrationFieldType;
                CaptionML=[DAN=Integrationsfelttype;
                           ENU=Integration Field Type];
                ToolTipML=[DAN=Angiver typen af feltet i den integrationstabel, der skal knyttes til forretningstabellen.;
                           ENU=Specifies the type of the field in the integration table to map to the business table.];
                ApplicationArea=#Suite;
                SourceExpr=IntegrationFieldTypeValue;
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                Name=IntegrationTableFilter;
                CaptionML=[DAN=Integrationstabelfilter;
                           ENU=Integration Table Filter];
                ToolTipML=[DAN=Angiver et filter for integrationstabellen for at styre, hvilke records der kan synkroniseres med de tilsvarende records i forretningsdatatabellen, der er angivet i feltet Tabel.;
                           ENU=Specifies a filter on the integration table to control which records can be synchronized with the corresponding records in the business data table that is specified by the Table field.];
                ApplicationArea=#Suite;
                SourceExpr=IntegrationTableFilter;
                OnAssistEdit=VAR
                               FilterPageBuilder@1000 : FilterPageBuilder;
                             BEGIN
                               FilterPageBuilder.ADDTABLE(IntegrationTableCaptionValue,"Integration Table ID");
                               IF IntegrationTableFilter <> '' THEN
                                 FilterPageBuilder.SETVIEW(IntegrationTableCaptionValue,IntegrationTableFilter);
                               IF FilterPageBuilder.RUNMODAL THEN BEGIN
                                 IntegrationTableFilter := FilterPageBuilder.GETVIEW(IntegrationTableCaptionValue,TRUE);
                                 SetIntegrationTableFilter(IntegrationTableFilter);
                               END;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den konfigurationsskabelon, der skal bruges ved oprettelse af nye records i Dynamics NAV-forretningstabellen (der er angivet i feltet Tabel-id) under synkroniseringen.;
                           ENU=Specifies a configuration template to use when creating new records in the Dynamics NAV business table (specified by the Table ID field) during synchronization.];
                ApplicationArea=#Suite;
                SourceExpr="Table Config Template Code" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en konfigurationsskabelonen, der skal bruges til oprettelse af nye records i den eksterne databasetabel, f.eks Dynamics 365 for Sales.;
                           ENU=Specifies a configuration template to use for creating new records in the external database table, such as Dynamics 365 for Sales.];
                ApplicationArea=#Suite;
                SourceExpr="Int. Tbl. Config Template Code" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan records der ikke er sammenk‘det i Dynamics 365 for Sales-enheder og Dynamics NAV-tabeller, skal h†ndteres, n†r synkroniseringen udf›res af et integrationssynkroniseringsjob.;
                           ENU=Specifies how to handle uncoupled records in Dynamics 365 for Sales entities and Dynamics NAV tables when synchronization is performed by an integration synchronization job.];
                ApplicationArea=#Suite;
                SourceExpr="Synch. Only Coupled Records" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tekst, der vises f›r titlen p† integrationstabellen, hvor denne titel bruges.;
                           ENU=Specifies text that appears before the caption of the integration table wherever the caption is used.];
                ApplicationArea=#Suite;
                SourceExpr="Int. Tbl. Caption Prefix";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      ObjectTranslation@1002 : Record 377;
      TypeHelper@1011 : Codeunit 10;
      TableCaptionValue@1000 : Text[250];
      IntegrationFieldCaptionValue@1009 : Text;
      IntegrationFieldTypeValue@1010 : Text;
      IntegrationTableCaptionValue@1001 : Text[250];
      TableFilter@1003 : Text;
      IntegrationTableFilter@1004 : Text;
      StartFullSynchronizationQst@1005 : TextConst 'DAN=Du er ved at synkronisere alle data i tilknytningen. Det kan tage flere minutter.\\Vil du forts‘tte?;ENU=You are about synchronize all data within the mapping. This process may take several minutes.\\Do you want to continue?';
      SynchronizedModifiedCompletedMsg@1006 : TextConst '@@@=%1 caption from page 5338;DAN=Synkronisering af ‘ndrede records fuldf›rt.\I vinduet %1 finder du detaljer.;ENU=Synchronized Modified Records completed.\See the %1 window for details.';
      FullSynchronizationCompletedMsg@1007 : TextConst '@@@=%1 caption from page 5338;DAN=Fuld synkronisering er fuldf›rt.\Detaljerne kan ses i vinduet %1.;ENU=Full Synchronization completed.\See the %1 window for details.';
      HasRecords@1008 : Boolean;

    LOCAL PROCEDURE GetFieldCaption@4() : Text;
    VAR
      Field@1000 : Record 2000000041;
    BEGIN
      IF TypeHelper.GetField("Integration Table ID","Integration Table UID Fld. No.",Field) THEN
        EXIT(Field."Field Caption");
    END;

    LOCAL PROCEDURE GetFieldType@1() : Text;
    VAR
      Field@1000 : Record 2000000041;
    BEGIN
      Field.Type := "Int. Table UID Field Type";
      EXIT(FORMAT(Field.Type))
    END;

    BEGIN
    END.
  }
}

