OBJECT Page 5333 CRM Skipped Records
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Records Skipped During Synchronization;
               ENU=Records Skipped During Synchronization];
    SourceTable=Table5331;
    SourceTableView=SORTING(Skipped,Table ID)
                    WHERE(Skipped=CONST(Yes));
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚r,Synkronisering;
                                ENU=New,Process,Report,Synchronization];
    OnAfterGetCurrRecord=BEGIN
                           AreRecordsExist := TRUE;
                         END;

    ActionList=ACTIONS
    {
      { 4       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 6       ;1   ;Action    ;
                      Name=Restore;
                      AccessByPermission=TableData 5331=IM;
                      CaptionML=[DAN=Gendan;
                                 ENU=Restore];
                      ToolTipML=[DAN=Gendan de valgte records i yderligere Dynamics 365 for Sales-synkronisering.;
                                 ENU=Restore selected records for further Dynamics 365 for Sales synchronization.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=AreRecordsExist;
                      PromotedIsBig=Yes;
                      Image=Restore;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CRMIntegrationRecord@1000 : Record 5331;
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(CRMIntegrationRecord);
                                 CRMIntegrationManagement.UpdateSkippedNow(CRMIntegrationRecord);
                                 AreRecordsExist := FALSE;
                               END;
                                }
      { 5       ;1   ;Action    ;
                      Name=ShowLog;
                      CaptionML=[DAN=Synkroniseringslog;
                                 ENU=Synchronization Log];
                      ToolTipML=[DAN=Vis integrationssynkroniseringsjobs for den oversprungne record.;
                                 ENU=View integration synchronization jobs for the skipped record.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=AreRecordsExist;
                      PromotedIsBig=Yes;
                      Image=Log;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 IntegrationRecord@1001 : Record 5151;
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 IntegrationRecord.FindByIntegrationId("Integration ID");
                                 CRMIntegrationManagement.ShowLog(IntegrationRecord."Record ID");
                               END;
                                }
      { 9       ;1   ;Action    ;
                      Name=CRMSynchronizeNow;
                      CaptionML=[DAN=Synchronize;
                                 ENU=Synchronize];
                      ToolTipML=[DAN=Send or get updated data to or from Dynamics 365 for Sales.;
                                 ENU=Send or get updated data to or from Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=AreRecordsExist;
                      PromotedIsBig=Yes;
                      Image=Refresh;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CRMIntegrationRecord@1000 : Record 5331;
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(CRMIntegrationRecord);
                                 CRMIntegrationManagement.UpdateMultipleNow(CRMIntegrationRecord);
                                 AreRecordsExist := FALSE;
                               END;
                                }
      { 11      ;1   ;Action    ;
                      Name=ManageCRMCoupling;
                      CaptionML=[DAN=Set Up Coupling;
                                 ENU=Set Up Coupling];
                      ToolTipML=[DAN=Create or modify the coupling to a Dynamics 365 for Sales entity.;
                                 ENU=Create or modify the coupling to a Dynamics 365 for Sales entity.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=AreRecordsExist;
                      Image=LinkAccount;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 IntegrationRecord@1002 : Record 5151;
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                               BEGIN
                                 IntegrationRecord.GET("Integration ID");
                                 CRMIntegrationManagement.DefineCoupling(IntegrationRecord."Record ID");
                                 AreRecordsExist := FALSE;
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=DeleteCRMCoupling;
                      AccessByPermission=TableData 5331=D;
                      CaptionML=[DAN=Delete Coupling;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Delete the coupling to a Dynamics 365 for Sales entity.;
                                 ENU=Delete the coupling to a Dynamics 365 for Sales entity.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=AreRecordsExist;
                      Image=UnLinkAccount;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 IntegrationRecord@1002 : Record 5151;
                                 CRMCouplingManagement@1000 : Codeunit 5331;
                               BEGIN
                                 IntegrationRecord.GET("Integration ID");
                                 CRMCouplingManagement.RemoveCoupling(IntegrationRecord."Record ID");
                                 AreRecordsExist := FALSE;
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
                Name=TableName;
                CaptionML=[DAN=Tabelnavn;
                           ENU=Table Name];
                ToolTipML=[DAN=Angiver navnet p† tabellen, hvor en record ikke kunne synkroniseres.;
                           ENU=Specifies the name of the table where a record failed to synchronize.];
                ApplicationArea=#Suite;
                SourceExpr=GetTableCaption }

    { 8   ;2   ;Field     ;
                Name=Description;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ToolTipML=[DAN=Angiver den prim‘re n›gle for den record, der ikke kunne synkroniseres.;
                           ENU=Specifies the primary key of the record that failed to synchronize.];
                ApplicationArea=#Suite;
                SourceExpr=GetRecDescription }

    { 7   ;2   ;Field     ;
                Name=LatestError;
                CaptionML=[DAN=Fejl;
                           ENU=Error];
                ToolTipML=[DAN=Angiver fejlmeddelelsen for synkroniseringen.;
                           ENU=Specifies the synchronization error message.];
                ApplicationArea=#Suite;
                SourceExpr=GetLatestError }

  }
  CODE
  {
    VAR
      AreRecordsExist@1000 : Boolean;

    LOCAL PROCEDURE GetTableCaption@3() : Text;
    VAR
      AllObjWithCaption@1000 : Record 2000000058;
    BEGIN
      IF "Table ID" = 0 THEN
        EXIT('');
      IF AllObjWithCaption.GET(AllObjWithCaption."Object Type"::Table,"Table ID") THEN
        EXIT(AllObjWithCaption."Object Caption");
    END;

    BEGIN
    END.
  }
}

