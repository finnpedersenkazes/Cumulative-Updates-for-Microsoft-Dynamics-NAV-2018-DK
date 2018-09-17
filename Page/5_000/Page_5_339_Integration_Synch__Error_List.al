OBJECT Page 5339 Integration Synch. Error List
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
    CaptionML=[DAN=Integrationsynkroniseringsfejl;
               ENU=Integration Synchronization Errors];
    InsertAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5339;
    SourceTableView=SORTING(Date/Time,Integration Synch. Job ID)
                    ORDER(Descending);
    PageType=List;
    OnAfterGetRecord=VAR
                       RecID@1002 : RecordID;
                     BEGIN
                       RecID := "Source Record ID";
                       OpenSourcePageTxt := GetPageLink(RecID);

                       RecID := "Destination Record ID";
                       OpenDestinationPageTxt := GetPageLink(RecID);

                       HasRecords := NOT ISEMPTY;
                     END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 11      ;1   ;Action    ;
                      Name=Delete7days;
                      CaptionML=[DAN=Slet poster ‘ldre end syv dage;
                                 ENU=Delete Entries Older Than 7 Days];
                      ToolTipML=[DAN=Slet fejllogoplysninger om opgavek›poster, der er ‘ldre end syv dage.;
                                 ENU=Delete error log information for job queue entries that are older than seven days.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=HasRecords;
                      Image=ClearLog;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DeleteEntries(7);
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=Delete0days;
                      CaptionML=[DAN=Slet alle poster;
                                 ENU=Delete All Entries];
                      ToolTipML=[DAN=Slet alle fejllogoplysninger om opgavek›poster.;
                                 ENU=Delete all error log information for job queue entries.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=HasRecords;
                      Image=Delete;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DeleteEntries(0);
                               END;
                                }
      { 17      ;1   ;ActionGroup;
                      Name=ActionGroupCRM;
                      CaptionML=[DAN=Dynamics 365 for Sales;
                                 ENU=Dynamics 365 for Sales] }
      { 15      ;2   ;Action    ;
                      Name=CRMSynchronizeNow;
                      CaptionML=[DAN=Synkroniser;
                                 ENU=Synchronize];
                      ToolTipML=[DAN=Send eller hent opdaterede data til eller fra Dynamics 365 for Sales.;
                                 ENU=Send or get updated data to or from Dynamics 365 for Sales.];
                      ApplicationArea=#Suite;
                      Enabled=HasRecords;
                      Image=Refresh;
                      OnAction=VAR
                                 CRMIntegrationManagement@1001 : Codeunit 5330;
                                 LocalRecordID@1000 : RecordID;
                               BEGIN
                                 IF ISEMPTY THEN
                                   EXIT;

                                 GetRecordID(LocalRecordID);
                                 CRMIntegrationManagement.UpdateOneNow(LocalRecordID);
                               END;
                                }
      { 14      ;2   ;ActionGroup;
                      Name=Coupling;
                      CaptionML=[@@@=Coupling is a noun;
                                 DAN=Sammenk‘dning;
                                 ENU=Coupling];
                      ToolTipML=[DAN=Opret, rediger eller slet en sammenk‘dning mellem Dynamics 365-recorden og en Dynamics 365 for Sales-record.;
                                 ENU=Create, change, or delete a coupling between the Dynamics 365 record and a Dynamics 365 for Sales record.];
                      Image=LinkAccount }
      { 13      ;3   ;Action    ;
                      Name=ManageCRMCoupling;
                      CaptionML=[DAN=Konfigurer sammenk‘dning;
                                 ENU=Set Up Coupling];
                      ToolTipML=[DAN=Opret eller rediger sammenk‘dningen med en Dynamics 365 for Sales-enhed.;
                                 ENU=Create or modify the coupling to a Dynamics 365 for Sales entity.];
                      ApplicationArea=#Suite;
                      Enabled=HasRecords;
                      Image=LinkAccount;
                      OnAction=VAR
                                 CRMIntegrationManagement@1000 : Codeunit 5330;
                                 LocalRecordID@1001 : RecordID;
                               BEGIN
                                 IF ISEMPTY THEN
                                   EXIT;

                                 GetRecordID(LocalRecordID);
                                 CRMIntegrationManagement.DefineCoupling(LocalRecordID);
                               END;
                                }
      { 12      ;3   ;Action    ;
                      Name=DeleteCRMCoupling;
                      CaptionML=[DAN=Slet sammenk‘dning;
                                 ENU=Delete Coupling];
                      ToolTipML=[DAN=Slet sammenk‘dningen med en Dynamics 365 for Sales-enhed.;
                                 ENU=Delete the coupling to a Dynamics 365 for Sales entity.];
                      ApplicationArea=#Suite;
                      Enabled=HasRecords;
                      Image=UnLinkAccount;
                      OnAction=VAR
                                 CRMCouplingManagement@1000 : Codeunit 5331;
                                 LocalRecordID@1001 : RecordID;
                               BEGIN
                                 IF ISEMPTY THEN
                                   EXIT;

                                 GetRecordID(LocalRecordID);
                                 CRMCouplingManagement.RemoveCoupling(LocalRecordID);
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

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dato og klokkesl‘t, hvor fejlen i integrationssynkroniseringsjobbet opstod.;
                           ENU=Specifies the date and time that the error in the integration synchronization job occurred.];
                ApplicationArea=#Suite;
                SourceExpr="Date/Time" }

    { 3   ;2   ;Field     ;
                Width=100;
                ToolTipML=[DAN=Angiver den fejl, der opstod i integrationssynkroniseringsjobbet.;
                           ENU=Specifies the error that occurred in the integration synchronization job.];
                ApplicationArea=#Suite;
                SourceExpr=Message }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den undtagelse, der opstod i integrationssynkroniseringsjobbet.;
                           ENU=Specifies the exception that occurred in the integration synchronization job.];
                ApplicationArea=#Suite;
                SourceExpr="Exception Detail" }

    { 16  ;2   ;Field     ;
                Name=Source;
                CaptionML=[DAN=Kilde;
                           ENU=Source];
                ToolTipML=[DAN=Angiver den record, der leverede dataene til destinationsrecorden i det integrationssynkroniseringsjob, der mislykkedes.;
                           ENU=Specifies the record that supplied the data to destination record in integration synchronization job that failed.];
                ApplicationArea=#Suite;
                SourceExpr=OpenSourcePageTxt;
                OnDrillDown=VAR
                              OpenRecordID@1000 : RecordID;
                            BEGIN
                              OpenRecordID := "Source Record ID";
                              ShowPage(OpenRecordID);
                            END;
                             }

    { 18  ;2   ;Field     ;
                Name=Destination;
                CaptionML=[DAN=Destination;
                           ENU=Destination];
                ToolTipML=[DAN=Angiver den record, der modtag dataene fra kilderecorden i det integrationssynkroniseringsjob, der mislykkedes.;
                           ENU=Specifies the record that received the data from the source record in integration synchronization job that failed.];
                ApplicationArea=#Suite;
                SourceExpr=OpenDestinationPageTxt;
                OnDrillDown=VAR
                              OpenRecordID@1000 : RecordID;
                            BEGIN
                              OpenRecordID := "Destination Record ID";
                              ShowPage(OpenRecordID);
                            END;
                             }

  }
  CODE
  {
    VAR
      UnableToFindPageForRecordErr@1002 : TextConst '@@@=%1 ID of the record;DAN=Side til recorden %1 kan ikke findes.;ENU=Unable to find page for record %1.';
      InvalidOrMissingSourceErr@1003 : TextConst 'DAN=Kilderecorden blev ikke fundet.;ENU=The source record was not found.';
      InvalidOrMissingDestinationErr@1004 : TextConst 'DAN=Destinationsrecorden blev ikke fundet.;ENU=The destination record was not found.';
      OpenSourcePageTxt@1005 : Text;
      OpenDestinationPageTxt@1006 : Text;
      OpenPageTok@1007 : TextConst 'DAN=Vis;ENU=View';
      HasRecords@1000 : Boolean;

    LOCAL PROCEDURE ShowPage@5(RecordID@1000 : RecordID);
    VAR
      TableMetadata@1003 : Record 2000000136;
      PageManagement@1002 : Codeunit 700;
      CRMIntegrationManagement@1001 : Codeunit 5330;
      CrmId@1007 : GUID;
      CrmIdFormattet@1008 : Text;
    BEGIN
      IF RecordID.TABLENO = 0 THEN
        EXIT;
      IF NOT TableMetadata.GET(RecordID.TABLENO) THEN
        EXIT;

      IF NOT TableMetadata.DataIsExternal THEN BEGIN
        PageManagement.PageRun(RecordID);
        EXIT;
      END;

      IF TableMetadata.TableType = TableMetadata.TableType::CRM THEN BEGIN
        CrmIdFormattet := FORMAT(RecordID);
        CrmIdFormattet := COPYSTR(CrmIdFormattet,STRPOS(CrmIdFormattet,':') + 1);
        EVALUATE(CrmId,CrmIdFormattet);
        HYPERLINK(CRMIntegrationManagement.GetCRMEntityUrlFromCRMID(RecordID.TABLENO,CrmId));
        EXIT;
      END;

      ERROR(STRSUBSTNO(UnableToFindPageForRecordErr,FORMAT(RecordID,0,1)));
    END;

    LOCAL PROCEDURE GetRecordID@8(VAR LocalRecordID@1001 : RecordID);
    VAR
      TableMetadata@1000 : Record 2000000136;
    BEGIN
      LocalRecordID := "Source Record ID";
      IF LocalRecordID.TABLENO = 0 THEN
        ERROR(InvalidOrMissingSourceErr);

      IF NOT TableMetadata.GET(LocalRecordID.TABLENO) THEN
        ERROR(InvalidOrMissingSourceErr);

      IF TableMetadata.TableType <> TableMetadata.TableType::CRM THEN
        EXIT;

      LocalRecordID := "Destination Record ID";
      IF LocalRecordID.TABLENO = 0 THEN
        ERROR(InvalidOrMissingDestinationErr);
    END;

    LOCAL PROCEDURE GetPageLink@7(VAR RecID@1000 : RecordID) : Text;
    VAR
      TableMetadata@1002 : Record 2000000136;
      ReferenceRecordRef@1003 : RecordRef;
    BEGIN
      TableMetadata.SETRANGE(ID,RecID.TABLENO);
      IF TableMetadata.FINDFIRST THEN
        IF TableMetadata.TableType = TableMetadata.TableType::MicrosoftGraph THEN
          EXIT('');

      IF NOT ReferenceRecordRef.GET(RecID) THEN
        EXIT('');

      EXIT(OpenPageTok);
    END;

    BEGIN
    END.
  }
}

