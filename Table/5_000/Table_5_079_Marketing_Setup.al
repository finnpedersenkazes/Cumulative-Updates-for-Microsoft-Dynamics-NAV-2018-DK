OBJECT Table 5079 Marketing Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 1261=rimd;
    CaptionML=[DAN=Marketingops‘tning;
               ENU=Marketing Setup];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Prim‘rn›gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;Contact Nos.        ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Kontaktnumre;
                                                              ENU=Contact Nos.] }
    { 3   ;   ;Campaign Nos.       ;Code20        ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 5071=R;
                                                   CaptionML=[DAN=Kampagnenumre;
                                                              ENU=Campaign Nos.] }
    { 4   ;   ;Segment Nos.        ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=M†lgruppenumre;
                                                              ENU=Segment Nos.] }
    { 5   ;   ;To-do Nos.          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Opgavenr.;
                                                              ENU=Task Nos.] }
    { 6   ;   ;Opportunity Nos.    ;Code20        ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 5090=R;
                                                   CaptionML=[DAN=Salgsmulighednumre;
                                                              ENU=Opportunity Nos.] }
    { 7   ;   ;Bus. Rel. Code for Customers;Code10;TableRelation="Business Relation";
                                                   CaptionML=[DAN=Forretn.forb.kode - Debitorer;
                                                              ENU=Bus. Rel. Code for Customers] }
    { 8   ;   ;Bus. Rel. Code for Vendors;Code10  ;TableRelation="Business Relation";
                                                   CaptionML=[DAN=Forretn.forb.kode - Kreditorer;
                                                              ENU=Bus. Rel. Code for Vendors] }
    { 9   ;   ;Bus. Rel. Code for Bank Accs.;Code10;
                                                   TableRelation="Business Relation";
                                                   CaptionML=[DAN=Forretn.forb.kode - Bankkonti;
                                                              ENU=Bus. Rel. Code for Bank Accs.] }
    { 22  ;   ;Inherit Salesperson Code;Boolean   ;InitValue=Yes;
                                                   CaptionML=[DAN=Overf›r s‘lgerkode;
                                                              ENU=Inherit Salesperson Code] }
    { 23  ;   ;Inherit Territory Code;Boolean     ;InitValue=Yes;
                                                   CaptionML=[DAN=Overf›r distriktskode;
                                                              ENU=Inherit Territory Code] }
    { 24  ;   ;Inherit Country/Region Code;Boolean;InitValue=Yes;
                                                   CaptionML=[DAN=Overf›r lande-/omr†dekode;
                                                              ENU=Inherit Country/Region Code] }
    { 25  ;   ;Inherit Language Code;Boolean      ;InitValue=Yes;
                                                   CaptionML=[DAN=Overf›r sprogkode;
                                                              ENU=Inherit Language Code] }
    { 26  ;   ;Inherit Address Details;Boolean    ;InitValue=Yes;
                                                   CaptionML=[DAN=Overf›r adressedetaljer;
                                                              ENU=Inherit Address Details] }
    { 27  ;   ;Inherit Communication Details;Boolean;
                                                   InitValue=Yes;
                                                   CaptionML=[DAN=Overf›r kommunikationsdetaljer;
                                                              ENU=Inherit Communication Details] }
    { 28  ;   ;Default Salesperson Code;Code20    ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Standards‘lgerkode;
                                                              ENU=Default Salesperson Code] }
    { 29  ;   ;Default Territory Code;Code10      ;TableRelation=Territory;
                                                   CaptionML=[DAN=Standarddistriktskode;
                                                              ENU=Default Territory Code] }
    { 30  ;   ;Default Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Standardlande-/omr†dekode;
                                                              ENU=Default Country/Region Code] }
    { 31  ;   ;Default Language Code;Code10       ;TableRelation=Language;
                                                   CaptionML=[DAN=Standardsprogkode;
                                                              ENU=Default Language Code] }
    { 33  ;   ;Default Sales Cycle Code;Code10    ;TableRelation="Sales Cycle";
                                                   CaptionML=[DAN=Standardsalgsproceskode;
                                                              ENU=Default Sales Cycle Code] }
    { 35  ;   ;Attachment Storage Type;Option     ;CaptionML=[DAN=Lagringstype for vedh‘ftet fil;
                                                              ENU=Attachment Storage Type];
                                                   OptionCaptionML=[DAN=Integreret,Diskfil;
                                                                    ENU=Embedded,Disk File];
                                                   OptionString=Embedded,Disk File }
    { 36  ;   ;Attachment Storage Location;Text250;CaptionML=[DAN=Lagringsplacering;
                                                              ENU=Attachment Storage Location] }
    { 37  ;   ;Autosearch for Duplicates;Boolean  ;InitValue=Yes;
                                                   OnValidate=BEGIN
                                                                IF "Autosearch for Duplicates" THEN
                                                                  VALIDATE("Maintain Dupl. Search Strings",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Automatisk dublets›gning;
                                                              ENU=Autosearch for Duplicates] }
    { 38  ;   ;Search Hit %        ;Integer       ;InitValue=60;
                                                   CaptionML=[DAN=Hitpct. ved s›gning;
                                                              ENU=Search Hit %];
                                                   MinValue=1;
                                                   MaxValue=100;
                                                   NotBlank=Yes }
    { 39  ;   ;Maintain Dupl. Search Strings;Boolean;
                                                   InitValue=Yes;
                                                   OnValidate=BEGIN
                                                                "Autosearch for Duplicates" := "Maintain Dupl. Search Strings";
                                                                IF "Maintain Dupl. Search Strings" AND NOT xRec."Maintain Dupl. Search Strings" THEN
                                                                  IF CONFIRM(DuplicateSearchQst) THEN
                                                                    REPORT.RUN(REPORT::"Generate Dupl. Search String");
                                                              END;

                                                   CaptionML=[DAN=Vedligehold dublets›gestrenge;
                                                              ENU=Maintain Dupl. Search Strings];
                                                   NotBlank=Yes }
    { 50  ;   ;Mergefield Language ID;Integer     ;TableRelation="Windows Language";
                                                   CaptionML=[DAN=Flettefelt - sprog-id;
                                                              ENU=Mergefield Language ID];
                                                   BlankZero=Yes }
    { 51  ;   ;Def. Company Salutation Code;Code10;TableRelation=Salutation;
                                                   CaptionML=[DAN=Std. starthilsenkode - virks.;
                                                              ENU=Def. Company Salutation Code] }
    { 52  ;   ;Default Person Salutation Code;Code10;
                                                   TableRelation=Salutation;
                                                   CaptionML=[DAN=Std.starthilsenkode - person;
                                                              ENU=Default Person Salutation Code] }
    { 53  ;   ;Default Correspondence Type;Option ;CaptionML=[DAN=Standardkorrespondancetype;
                                                              ENU=Default Correspondence Type];
                                                   OptionCaptionML=[DAN=" ,Papirformat,Mail,Telefax";
                                                                    ENU=" ,Hard Copy,Email,Fax"];
                                                   OptionString=[ ,Hard Copy,Email,Fax] }
    { 56  ;   ;Queue Folder Path   ;Text250       ;CaptionML=[DAN=K›mappesti;
                                                              ENU=Queue Folder Path];
                                                   Editable=No }
    { 57  ;   ;Queue Folder UID    ;BLOB          ;CaptionML=[DAN=K›mappe-UID;
                                                              ENU=Queue Folder UID] }
    { 59  ;   ;Storage Folder Path ;Text250       ;CaptionML=[DAN=Lagringsmappesti;
                                                              ENU=Storage Folder Path];
                                                   Editable=No }
    { 60  ;   ;Storage Folder UID  ;BLOB          ;CaptionML=[DAN=Lagringsmappe-UID;
                                                              ENU=Storage Folder UID] }
    { 67  ;   ;Default To-do Date Calculation;DateFormula;
                                                   CaptionML=[DAN=Beregning af standardopgavedato;
                                                              ENU=Default Task Date Calculation] }
    { 69  ;   ;Autodiscovery E-Mail Address;Text250;
                                                   CaptionML=[DAN=Automatisk opdagelse af mailadresse;
                                                              ENU=Autodiscovery Email Address] }
    { 70  ;   ;Email Batch Size    ;Integer       ;CaptionML=[DAN=Mailbatchst›rrelse;
                                                              ENU=Email Batch Size];
                                                   MinValue=0 }
    { 71  ;   ;Exchange Service URL;Text250       ;CaptionML=[DAN=URL-adresse til Exchange-tjeneste;
                                                              ENU=Exchange Service URL] }
    { 72  ;   ;Exchange Account User Name;Text250 ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugernavn til Exchange-konto;
                                                              ENU=Exchange Account User Name] }
    { 73  ;   ;Exchange Account Password Key;GUID ;CaptionML=[DAN=Adgangskoden›gle til Exchange-konto;
                                                              ENU=Exchange Account Password Key] }
    { 74  ;   ;Sync with Microsoft Graph;Boolean  ;OnValidate=VAR
                                                                WebhookManagement@1002 : Codeunit 5377;
                                                              BEGIN
                                                                IF WebhookManagement.IsSyncAllowed AND "Sync with Microsoft Graph" THEN BEGIN
                                                                  CODEUNIT.RUN(CODEUNIT::"Graph Data Setup");
                                                                  "WebHook Run Notification As" := GetWebhookSubscriptionUser;
                                                                  IF UserIsNotValidForWebhookSubscription("WebHook Run Notification As") THEN
                                                                    IF CurrentUserHasPermissionsForWebhookSubscription THEN
                                                                      TrySetWebhookSubscriptionUser(USERSECURITYID);
                                                                END ELSE
                                                                  "Sync with Microsoft Graph" := FALSE;
                                                              END;

                                                   CaptionML=[DAN=Synkroniser med Microsoft Graph;
                                                              ENU=Sync with Microsoft Graph];
                                                   Editable=No }
    { 75  ;   ;WebHook Run Notification As;GUID   ;CaptionML=[DAN=WebHook - k›r notifikation som;
                                                              ENU=WebHook Run Notification As] }
    { 76  ;   ;Cust. Template Company Code;Code10 ;CaptionML=[DAN=Debitors skabelonfirmakode;
                                                              ENU=Cust. Template Company Code] }
    { 77  ;   ;Cust. Template Person Code;Code10  ;CaptionML=[DAN=Debitors skabelonpersonkode;
                                                              ENU=Cust. Template Person Code] }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text010@1000 : TextConst 'DAN=K›- og lagermapper m† ikke v‘re de samme. V‘lg en anden mappe.;ENU=The queue and storage folders cannot be the same. Choose a different folder.';
      ExchangeAccountNotConfiguredErr@1001 : TextConst 'DAN=Du skal konfigurere en Exchange-konto til maillogf›ring.;ENU=You must set up an Exchange account for email logging.';
      DuplicateSearchQst@1002 : TextConst 'DAN=Vil du oprette dublets›gestrenge?;ENU=Do you want to generate duplicate search strings?';

    [Internal]
    PROCEDURE SetQueueFolder@2(ExchangeFolder@1000 : Record 5320);
    VAR
      InStream@1001 : InStream;
      OutStream@1002 : OutStream;
    BEGIN
      IF (ExchangeFolder.FullPath = "Storage Folder Path") AND (ExchangeFolder.FullPath <> '') THEN
        ERROR(Text010);
      IF (ExchangeFolder.ReadUniqueID = GetStorageFolderUID) AND ExchangeFolder."Unique ID".HASVALUE THEN
        ERROR(Text010);

      "Queue Folder Path" := ExchangeFolder.FullPath;

      ExchangeFolder."Unique ID".CREATEINSTREAM(InStream);
      "Queue Folder UID".CREATEOUTSTREAM(OutStream);
      COPYSTREAM(OutStream,InStream);
      MODIFY;
    END;

    [Internal]
    PROCEDURE SetStorageFolder@3(ExchangeFolder@1000 : Record 5320);
    VAR
      InStream@1001 : InStream;
      OutStream@1002 : OutStream;
    BEGIN
      IF (ExchangeFolder.FullPath = "Queue Folder Path") AND (ExchangeFolder.FullPath <> '') THEN
        ERROR(Text010);
      IF (ExchangeFolder.ReadUniqueID = GetQueueFolderUID) AND ExchangeFolder."Unique ID".HASVALUE THEN
        ERROR(Text010);

      "Storage Folder Path" := ExchangeFolder.FullPath;

      ExchangeFolder."Unique ID".CREATEINSTREAM(InStream);
      "Storage Folder UID".CREATEOUTSTREAM(OutStream);
      COPYSTREAM(OutStream,InStream);
      MODIFY;
    END;

    [External]
    PROCEDURE GetQueueFolderUID@7() Return : Text;
    VAR
      Stream@1000 : InStream;
    BEGIN
      CALCFIELDS("Queue Folder UID");
      "Queue Folder UID".CREATEINSTREAM(Stream);
      Stream.READTEXT(Return);
    END;

    [External]
    PROCEDURE GetStorageFolderUID@8() Return : Text;
    VAR
      Stream@1000 : InStream;
    BEGIN
      CALCFIELDS("Storage Folder UID");
      "Storage Folder UID".CREATEINSTREAM(Stream);
      Stream.READTEXT(Return);
    END;

    [External]
    PROCEDURE SetExchangeAccountPassword@4(PasswordText@1001 : Text);
    VAR
      ServicePassword@1000 : Record 1261;
    BEGIN
      IF ISNULLGUID("Exchange Account Password Key") OR NOT ServicePassword.GET("Exchange Account Password Key") THEN BEGIN
        ServicePassword.SavePassword(PasswordText);
        ServicePassword.INSERT(TRUE);
        "Exchange Account Password Key" := ServicePassword.Key;
      END ELSE BEGIN
        ServicePassword.SavePassword(PasswordText);
        ServicePassword.MODIFY;
      END;
    END;

    [External]
    PROCEDURE CreateExchangeAccountCredentials@5(VAR WebCredentials@1000 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.WebCredentials");
    VAR
      ServicePassword@1001 : Record 1261;
    BEGIN
      IF "Exchange Account User Name" = '' THEN
        ERROR(ExchangeAccountNotConfiguredErr);
      IF ISNULLGUID("Exchange Account Password Key") OR NOT ServicePassword.GET("Exchange Account Password Key") THEN
        ERROR(ExchangeAccountNotConfiguredErr);

      WebCredentials := WebCredentials.WebCredentials("Exchange Account User Name",ServicePassword.GetPassword);
    END;

    [External]
    PROCEDURE TrySetWebhookSubscriptionUser@24(UserSecurityID@1000 : GUID) : Boolean;
    VAR
      WebhookManagement@1002 : Codeunit 5377;
    BEGIN
      IF "WebHook Run Notification As" <> UserSecurityID THEN
        IF WebhookManagement.IsValidNotificationRunAsUser(UserSecurityID) THEN BEGIN
          "WebHook Run Notification As" := UserSecurityID;
          EXIT(TRUE);
        END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE GetWebhookSubscriptionUser@23() : GUID;
    VAR
      MarketingSetup@1000 : Record 5079;
    BEGIN
      IF MarketingSetup.GET THEN
        EXIT(MarketingSetup."WebHook Run Notification As");
    END;

    LOCAL PROCEDURE UserIsNotValidForWebhookSubscription@36(UserSecurityID@1000 : GUID) : Boolean;
    VAR
      WebhookManagement@1002 : Codeunit 5377;
    BEGIN
      EXIT(NOT WebhookManagement.IsValidNotificationRunAsUser(UserSecurityID));
    END;

    LOCAL PROCEDURE CurrentUserHasPermissionsForWebhookSubscription@6() : Boolean;
    VAR
      Contact@1004 : Record 5050;
      Customer@1003 : Record 18;
    BEGIN
      EXIT(Customer.WRITEPERMISSION AND Contact.WRITEPERMISSION)
    END;

    [External]
    PROCEDURE TrySetWebhookSubscriptionUserAsCurrentUser@32() : GUID;
    VAR
      MarketingSetup@1005 : Record 5079;
    BEGIN
      IF NOT MarketingSetup.GET THEN
        MarketingSetup.INSERT(TRUE);

      IF UserIsNotValidForWebhookSubscription(MarketingSetup."WebHook Run Notification As") THEN
        IF CurrentUserHasPermissionsForWebhookSubscription THEN
          IF MarketingSetup.TrySetWebhookSubscriptionUser(USERSECURITYID) THEN
            MarketingSetup.MODIFY(TRUE);

      EXIT(MarketingSetup."WebHook Run Notification As");
    END;

    [External]
    PROCEDURE GetCustomerTemplate@1(ContactType@1000 : 'Company,Person') : Code[10];
    VAR
      MarketingSetup@1001 : Record 5079;
    BEGIN
      MarketingSetup.GET;

      CASE ContactType OF
        ContactType::Company:
          EXIT(MarketingSetup."Cust. Template Company Code");
        ContactType::Person:
          EXIT(MarketingSetup."Cust. Template Person Code");
      END
    END;

    BEGIN
    END.
  }
}

