OBJECT Page 6701 Contact Sync. Setup
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 1261=rimd;
    CaptionML=[DAN=Kontakt Ops‘tning af synkronisering;
               ENU=Contact Sync. Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table6700;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Filtrer,Logf›ring;
                                ENU=New,Process,Report,Filter,Logging];
    OnOpenPage=VAR
                 User@1000 : Record 2000000120;
               BEGIN
                 GetUser(User);
                 IF NOT O365SyncManagement.IsO365Setup(FALSE) THEN
                   ERROR(EmailMissingErr);
               END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=Proces;
                                 ENU=Process];
                      Image=Action }
      { 20      ;2   ;Action    ;
                      Name=Validate Exchange Connection;
                      CaptionML=[DAN=Kontroll‚r Exchange-forbindelse;
                                 ENU=Validate Exchange Connection];
                      ToolTipML=[DAN=Test, at den angivne Exchange Server-forbindelse fungerer.;
                                 ENU=Test that the provided exchange server connection works.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ValidateEmailLoggingSetup;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ProgressWindow.OPEN(ProgressWindowMsg);

                                 IF O365SyncManagement.CreateExchangeConnection(Rec) THEN
                                   MESSAGE(ConnectionSuccessMsg)
                                 ELSE BEGIN
                                   ProgressWindow.CLOSE;
                                   ERROR(ConnectionFailureErr);
                                 END;

                                 ProgressWindow.CLOSE;
                               END;
                                }
      { 4       ;2   ;Action    ;
                      Name=SyncO365;
                      CaptionML=[DAN=Synkroniser med Office 365;
                                 ENU=Sync with Office 365];
                      ToolTipML=[DAN=Synkroniser med Office 365 siden sidste synkroniseringsdato og sidste ‘ndringsdato. Alle ‘ndringer i Office 365 siden sidste synkroniseringsdato synkroniseres tilbage.;
                                 ENU=Synchronize with Office 365 based on last sync date and last modified date. All changes in Office 365 since the last sync date will be synchronized back.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Refresh;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CLEAR(O365SyncManagement);
                                 IF O365SyncManagement.IsO365Setup(FALSE) THEN
                                   O365SyncManagement.SyncExchangeContacts(Rec,FALSE);
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=SetSyncFilter;
                      CaptionML=[DAN=Angiv synkroniseringsfilter;
                                 ENU=Set Sync Filter];
                      ToolTipML=[DAN=Synkroniser, men ignorer datoerne for seneste synkronisering og seneste ‘ndring. Alle ‘ndringer videresendes til Office 365 og tager alle kontakter fra din Exchange-mappe og synkroniserer dem tilbage.;
                                 ENU=Synchronize, but ignore the last synchronized and last modified dates. All changes will be pushed to Office 365 and take all contacts from your Exchange folder and sync back.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Filter;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ExchangeContactSync@1001 : Codeunit 6703;
                               BEGIN
                                 ExchangeContactSync.GetRequestParameters(Rec);
                               END;
                                }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Logf›ring;
                                 ENU=Logging] }
      { 10      ;2   ;Action    ;
                      Name=ActivityLog;
                      CaptionML=[DAN=Aktivitetslogfil;
                                 ENU=Activity Log];
                      ToolTipML=[DAN=Vis status og eventuelle fejl relateret til forbindelsen til Exchange.;
                                 ENU=View the status and any errors related to the connection to Exchange.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Log;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 ActivityLog@1000 : Record 710;
                               BEGIN
                                 ActivityLog.ShowEntries(Rec);
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=DeleteActivityLog;
                      CaptionML=[DAN=Slet aktivitetslogfil;
                                 ENU=Delete Activity Log];
                      ToolTipML=[DAN=Slet logfilen for Exchange-synkronisering.;
                                 ENU=Delete the exchange synchronization log file.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Delete;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 DeleteActivityLog;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 3   ;2   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID";
                Editable=false }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den offentlige mappe p† Exchange-serveren, som du vil bruge til dine k›- og lagermapper.;
                           ENU=Specifies the public folder on the Exchange server that you want to use for your queue and storage folders.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Folder ID" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sidste dato/tidspunkt, hvor Exchange Server blev synkroniseret.;
                           ENU=Specifies the last date/time that the Exchange server was synchronized.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Sync Date Time" }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Aktiv‚r baggrundssynkronisering;
                           ENU=Enable Background Synchronization];
                ToolTipML=[DAN=Angiver, at der kan forekomme datasynkronisering, mens brugeren udf›rer relaterede opgaver.;
                           ENU=Specifies that data synchronization can occur while users perform related tasks.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Enabled }

  }
  CODE
  {
    VAR
      O365SyncManagement@1002 : Codeunit 6700;
      ProgressWindow@1008 : Dialog;
      ProgressWindowMsg@1004 : TextConst 'DAN=Validering af forbindelsen til Exchange.;ENU=Validating the connection to Exchange.';
      ConnectionSuccessMsg@1006 : TextConst 'DAN=Der er oprettet forbindelse til Exchange.;ENU=Connected successfully to Exchange.';
      ConnectionFailureErr@1005 : TextConst 'DAN=Kan ikke oprette forbindelse til Exchange. Kontroll‚r brugernavn, adgangskode og mappe-id, og pr›v derefter igen.;ENU=Cannot connect to Exchange. Check your user name, password and Folder ID, and then try again.';
      EmailMissingErr@1007 : TextConst 'DAN=Der skal angives en godkendelsesmail og Exchange-adgangskode for at konfigurere synkronisering af kontakter.;ENU=An authentication email and Exchange password must be set in order to set up contact synchronization.';

    LOCAL PROCEDURE GetUser@3(VAR User@1000 : Record 2000000120) : Boolean;
    BEGIN
      User.SETRANGE("User Name",USERID);
      EXIT(User.FINDFIRST);
    END;

    BEGIN
    END.
  }
}

