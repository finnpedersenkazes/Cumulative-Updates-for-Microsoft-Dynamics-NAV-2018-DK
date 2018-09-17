OBJECT Page 6700 Exchange Sync. Setup
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
    CaptionML=[DAN=Opsëtning af Exchange-synkronisering;
               ENU=Exchange Sync. Setup];
    InsertAllowed=No;
    LinksAllowed=No;
    SourceTable=Table6700;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Naviger;
                                ENU=New,Process,Report,Navigate];
    OnOpenPage=VAR
                 User@1000 : Record 2000000120;
                 AzureADMgt@1001 : Codeunit 6300;
               BEGIN
                 RESET;
                 GetUser(User);

                 IF User."Authentication Email" = '' THEN
                   ERROR(EmailMissingErr);

                 ExchangeAccountUserName := User."Authentication Email";

                 IF NOT GET(USERID) THEN BEGIN
                   INIT;
                   "User ID" := USERID;
                   "Folder ID" := PRODUCTNAME.SHORT;
                   INSERT;
                   COMMIT;
                 END;

                 PasswordRequired := AzureADMgt.GetAccessToken(AzureADMgt.GetO365Resource,AzureADMgt.GetO365ResourceName,FALSE) = '';

                 IF (ExchangeAccountUserName <> '') AND (NOT ISNULLGUID("Exchange Account Password Key")) THEN
                   ExchangeAccountPasswordTemp := '**********';
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
                      CaptionML=[DAN=KontrollÇr Exchange-forbindelse;
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
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=Naviger;
                                 ENU=Navigate] }
      { 30      ;2   ;Action    ;
                      Name=SetupBookingSync;
                      CaptionML=[DAN=Opsëtning af Bookings-synkronisering;
                                 ENU=Bookings Sync. Setup];
                      ToolTipML=[DAN=èbn siden til synkroniseringskonfiguration af Bookings.;
                                 ENU=Open the Bookings Sync. Setup page.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=BookingsLogo;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF PasswordRequired AND ISNULLGUID("Exchange Account Password Key") THEN
                                   ERROR(PasswordMissingErr);

                                 PAGE.RUNMODAL(PAGE::"Booking Sync. Setup");
                               END;
                                }
      { 4       ;2   ;Action    ;
                      Name=SetupContactSync;
                      CaptionML=[DAN=Kontakt Opsëtning af synkronisering;
                                 ENU=Contact Sync. Setup];
                      ToolTipML=[DAN=èbn siden til konfiguration af kontaktsynkronisering.;
                                 ENU=Open the Contact Sync. Setup page.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ExportSalesPerson;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF PasswordRequired AND ISNULLGUID("Exchange Account Password Key") THEN
                                   ERROR(PasswordMissingErr);

                                 PAGE.RUNMODAL(PAGE::"Contact Sync. Setup",Rec);
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
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogfõrt posten, der skal bruges, f.eks. i ëndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID";
                Editable=false }

    { 5   ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                CaptionML=[DAN=Godkendelsesmailadresse;
                           ENU=Authentication Email];
                ToolTipML=[DAN=Angiver den mailadresse, du vil bruge til bekrëfte din ëgthed pÜ Exchange-serveren.;
                           ENU=Specifies the email address that you use to authenticate yourself on the Exchange server.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ExchangeAccountUserName;
                Enabled=false;
                Editable=false }

    { 19  ;2   ;Field     ;
                ExtendedDatatype=Masked;
                CaptionML=[DAN=Adgangskode til Exchange-konto;
                           ENU=Exchange Account Password];
                ToolTipML=[DAN=Angiver adgangskoden til den brugerkonto, der har adgang til Exchange.;
                           ENU=Specifies the password of the user account that has access to Exchange.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ExchangeAccountPasswordTemp;
                Visible=PasswordRequired;
                OnValidate=BEGIN
                             SetExchangeAccountPassword(ExchangeAccountPasswordTemp);
                             COMMIT;
                           END;
                            }

  }
  CODE
  {
    VAR
      O365SyncManagement@1002 : Codeunit 6700;
      ProgressWindow@1008 : Dialog;
      ExchangeAccountPasswordTemp@1000 : Text;
      ProgressWindowMsg@1004 : TextConst 'DAN=Validering af forbindelsen til Exchange.;ENU=Validating the connection to Exchange.';
      ConnectionSuccessMsg@1006 : TextConst 'DAN=Der er oprettet forbindelse til Exchange.;ENU=Connected successfully to Exchange.';
      ExchangeAccountUserName@1001 : Text[250];
      ConnectionFailureErr@1005 : TextConst 'DAN=Kan ikke oprette forbindelse til Exchange. KontrollÇr brugernavn, adgangskode og mappe-id, og prõv derefter igen.;ENU=Cannot connect to Exchange. Check your user name, password and Folder ID, and then try again.';
      EmailMissingErr@1007 : TextConst 'DAN=Du skal angive en godkendelsesmailadresse for denne bruger.;ENU=You must specify an authentication email address for this user.';
      PasswordMissingErr@1009 : TextConst 'DAN=Du skal fõrst angive dine Exchange-legitimationsoplysninger for denne bruger.;ENU=You must specify your Exchange credentials for this user first.';
      PasswordRequired@1010 : Boolean;

    LOCAL PROCEDURE GetUser@3(VAR User@1000 : Record 2000000120) : Boolean;
    BEGIN
      WITH User DO BEGIN
        SETRANGE("User Name",USERID);
        IF FINDFIRST THEN
          EXIT(TRUE);
      END;
    END;

    BEGIN
    END.
  }
}

