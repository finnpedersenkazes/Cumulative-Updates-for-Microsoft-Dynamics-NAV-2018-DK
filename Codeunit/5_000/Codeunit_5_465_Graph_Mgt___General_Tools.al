OBJECT Codeunit 5465 Graph Mgt - General Tools
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    Permissions=TableData 112=rimd,
                TableData 122=rimd;
    OnRun=BEGIN
            ApiSetup;
          END;

  }
  CODE
  {
    VAR
      CannotChangeIDErr@1002 : TextConst '@@@={Locked};DAN=Value of Id is immutable.;ENU=Value of Id is immutable.';
      CannotChangeLastDateTimeModifiedErr@1001 : TextConst '@@@={Locked};DAN=Value of LastDateTimeModified is immutable.;ENU=Value of LastDateTimeModified is immutable.';
      MissingFieldValueErr@1000 : TextConst '@@@={Locked};DAN=%1 must be specified.;ENU=%1 must be specified.';

    PROCEDURE GetMandatoryStringPropertyFromJObject@51(VAR JsonObject@1000 : DotNet "'Newtonsoft.Json'.Newtonsoft.Json.Linq.JObject";PropertyName@1003 : Text;VAR PropertyValue@1004 : Text);
    VAR
      JSONManagement@1001 : Codeunit 5459;
      Found@1002 : Boolean;
    BEGIN
      Found := JSONManagement.GetStringPropertyValueFromJObjectByName(JsonObject,PropertyName,PropertyValue);
      IF NOT Found THEN
        ERROR(MissingFieldValueErr,PropertyName);
    END;

    PROCEDURE UpdateIntegrationRecords@3(VAR SourceRecordRef@1000 : RecordRef;FieldNumber@1008 : Integer;OnlyRecordsWithoutID@1009 : Boolean);
    VAR
      IntegrationRecord@1007 : Record 5151;
      UpdatedIntegrationRecord@1006 : Record 5151;
      IntegrationManagement@1005 : Codeunit 5150;
      FilterFieldRef@1010 : FieldRef;
      IDFieldRef@1003 : FieldRef;
      NullGuid@1004 : GUID;
    BEGIN
      IF OnlyRecordsWithoutID THEN BEGIN
        FilterFieldRef := SourceRecordRef.FIELD(FieldNumber);
        FilterFieldRef.SETRANGE(NullGuid);
      END;

      IF SourceRecordRef.FINDSET THEN
        REPEAT
          IDFieldRef := SourceRecordRef.FIELD(FieldNumber);
          IF NOT IntegrationRecord.GET(IDFieldRef.VALUE) THEN BEGIN
            IntegrationManagement.InsertUpdateIntegrationRecord(SourceRecordRef,CURRENTDATETIME);
            IF ISNULLGUID(FORMAT(IDFieldRef.VALUE)) THEN BEGIN
              UpdatedIntegrationRecord.SETRANGE("Record ID",SourceRecordRef.RECORDID);
              UpdatedIntegrationRecord.FINDFIRST;
              IDFieldRef.VALUE := IntegrationManagement.GetIdWithoutBrackets(UpdatedIntegrationRecord."Integration ID");
            END;

            SourceRecordRef.MODIFY(FALSE);
          END;
        UNTIL SourceRecordRef.NEXT = 0;
    END;

    PROCEDURE HandleUpdateReferencedIdFieldOnItem@19(VAR RecRef@1000 : RecordRef;NewId@1001 : GUID;VAR Handled@1002 : Boolean;DatabaseNumber@1006 : Integer;RecordFieldNumber@1007 : Integer);
    VAR
      IdFieldRef@1003 : FieldRef;
    BEGIN
      IF Handled THEN
        EXIT;

      IF RecRef.NUMBER <> DatabaseNumber THEN
        EXIT;

      IdFieldRef := RecRef.FIELD(RecordFieldNumber);
      IdFieldRef.VALUE(NewId);

      Handled := TRUE;
    END;

    PROCEDURE HandleGetPredefinedIdValue@21(VAR Id@1000 : GUID;VAR RecRef@1001 : RecordRef;VAR Handled@1002 : Boolean;DatabaseNumber@1007 : Integer;RecordFieldNumber@1008 : Integer);
    VAR
      IntegrationRecord@1006 : Record 5151;
      IdFieldRef@1003 : FieldRef;
      FieldValue@1005 : GUID;
    BEGIN
      IF Handled THEN
        EXIT;

      IF RecRef.NUMBER <> DatabaseNumber THEN
        EXIT;

      IdFieldRef := RecRef.FIELD(RecordFieldNumber);
      FieldValue := FORMAT(IdFieldRef.VALUE);

      IF ISNULLGUID(FieldValue) THEN
        EXIT;

      EVALUATE(Id,FieldValue);
      IF IntegrationRecord.GET(Id) THEN BEGIN
        CLEAR(Id);
        EXIT;
      END;

      Handled := TRUE;
    END;

    PROCEDURE InsertOrUpdateODataType@17(NewKey@1001 : Code[50];NewDescription@1002 : Text[250];OdmDefinition@1004 : Text);
    VAR
      ODataEdmType@1000 : Record 2000000179;
      ODataOutStream@1003 : OutStream;
      RecordExist@1005 : Boolean;
    BEGIN
      IF NOT ODataEdmType.WRITEPERMISSION THEN
        EXIT;

      RecordExist := ODataEdmType.GET(NewKey);

      IF NOT RecordExist THEN BEGIN
        CLEAR(ODataEdmType);
        ODataEdmType.Key := NewKey;
      END;

      ODataEdmType.VALIDATE(Description,NewDescription);
      ODataEdmType."Edm Xml".CREATEOUTSTREAM(ODataOutStream,TEXTENCODING::UTF8);
      ODataOutStream.WRITETEXT(OdmDefinition);

      IF RecordExist THEN
        ODataEdmType.MODIFY(TRUE)
      ELSE
        ODataEdmType.INSERT(TRUE);
    END;

    PROCEDURE ProcessNewRecordFromAPI@5(VAR InsertedRecordRef@1000 : RecordRef;VAR TempFieldSet@1003 : Record 2000000041;ModifiedDateTime@1002 : DateTime);
    VAR
      IntegrationManagement@1004 : Codeunit 5150;
      ConfigTemplateManagement@1005 : Codeunit 8612;
      UpdatedRecRef@1001 : RecordRef;
    BEGIN
      IF ConfigTemplateManagement.ApplyTemplate(InsertedRecordRef,TempFieldSet,UpdatedRecRef) THEN
        InsertedRecordRef := UpdatedRecRef.DUPLICATE;

      IntegrationManagement.InsertUpdateIntegrationRecord(InsertedRecordRef,ModifiedDateTime);
    END;

    PROCEDURE ErrorIdImmutable@2();
    BEGIN
      ERROR(CannotChangeIDErr);
    END;

    PROCEDURE ErrorLastDateTimeModifiedImmutable@4();
    BEGIN
      ERROR(CannotChangeLastDateTimeModifiedErr);
    END;

    [Integration]
    PROCEDURE ApiSetup@1();
    BEGIN
    END;

    PROCEDURE IsApiEnabled@34() : Boolean;
    VAR
      ServerConfigSettingHandler@1000 : Codeunit 6723;
      Handled@1001 : Boolean;
      IsAPIEnabled@1002 : Boolean;
    BEGIN
      OnGetIsAPIEnabled(Handled,IsAPIEnabled);
      IF Handled THEN
        EXIT(IsAPIEnabled);

      EXIT(ServerConfigSettingHandler.GetApiServicesEnabled);
    END;

    PROCEDURE APISetupIfEnabled@11();
    BEGIN
      IF IsApiEnabled THEN
        ApiSetup;
    END;

    [EventSubscriber(Codeunit,5150,OnGetIntegrationActivated)]
    LOCAL PROCEDURE OnGetIntegrationActivated@12(VAR IsSyncEnabled@1000 : Boolean);
    VAR
      ApiWebService@1001 : Record 2000000193;
      ODataEdmType@1003 : Record 2000000179;
      ForceIsApiEnabledVerification@1002 : Boolean;
    BEGIN
      OnForceIsApiEnabledVerification(ForceIsApiEnabledVerification);

      IF NOT ForceIsApiEnabledVerification AND IsSyncEnabled THEN
        EXIT;

      IF ForceIsApiEnabledVerification THEN
        IF NOT IsApiEnabled THEN
          EXIT;

      IF NOT ApiWebService.READPERMISSION THEN
        EXIT;

      ApiWebService.SETRANGE("Object Type",ApiWebService."Object Type"::Page);
      ApiWebService.SETRANGE(Published,TRUE);
      IF ApiWebService.ISEMPTY THEN
        EXIT;
      IF NOT ODataEdmType.READPERMISSION THEN
        EXIT;

      IsSyncEnabled := NOT ODataEdmType.ISEMPTY;
    END;

    PROCEDURE TranslateNAVCurrencyCodeToCurrencyCode@8(VAR CachedLCYCurrencyCode@1001 : Code[10];CurrencyCode@1000 : Code[10]) : Code[10];
    VAR
      GeneralLedgerSetup@1002 : Record 98;
    BEGIN
      IF CurrencyCode <> '' THEN
        EXIT(CurrencyCode);

      IF CachedLCYCurrencyCode = '' THEN BEGIN
        GeneralLedgerSetup.GET;
        CachedLCYCurrencyCode := GeneralLedgerSetup."LCY Code";
      END;

      EXIT(CachedLCYCurrencyCode);
    END;

    PROCEDURE TranslateCurrencyCodeToNAVCurrencyCode@7(VAR CachedLCYCurrencyCode@1000 : Code[10];CurrentCurrencyCode@1001 : Code[10]) : Code[10];
    VAR
      GeneralLedgerSetup@1002 : Record 98;
    BEGIN
      IF CurrentCurrencyCode = '' THEN
        EXIT('');

      // Update LCY cache
      IF CachedLCYCurrencyCode = '' THEN BEGIN
        GeneralLedgerSetup.GET;
        CachedLCYCurrencyCode := GeneralLedgerSetup."LCY Code";
      END;

      IF CachedLCYCurrencyCode = CurrentCurrencyCode THEN
        EXIT('');

      EXIT(CurrentCurrencyCode);
    END;

    [EventSubscriber(Codeunit,2,OnCompanyInitialize,"",Skip,Skip)]
    LOCAL PROCEDURE InitDemoCompanyApisForSaaS@10();
    VAR
      CompanyInformation@1001 : Record 79;
      APIEntitiesSetup@1003 : Record 5466;
      PermissionManager@1000 : Codeunit 9002;
      GraphMgtGeneralTools@1002 : Codeunit 5465;
    BEGIN
      IF NOT PermissionManager.SoftwareAsAService THEN
        EXIT;

      IF NOT CompanyInformation.GET THEN
        EXIT;

      IF NOT CompanyInformation."Demo Company" THEN
        EXIT;

      APIEntitiesSetup.SafeGet;

      IF APIEntitiesSetup."Demo Company API Initialized" THEN
        EXIT;

      GraphMgtGeneralTools.ApiSetup;

      APIEntitiesSetup.SafeGet;
      APIEntitiesSetup.VALIDATE("Demo Company API Initialized",TRUE);
      APIEntitiesSetup.MODIFY(TRUE);
    END;

    [Integration]
    LOCAL PROCEDURE OnGetIsAPIEnabled@6(VAR Handled@1000 : Boolean;VAR IsAPIEnabled@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnForceIsApiEnabledVerification@9(VAR ForceIsApiEnabledVerification@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

