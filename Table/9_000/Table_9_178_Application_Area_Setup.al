OBJECT Table 9178 Application Area Setup
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    CaptionML=[DAN=Konfiguration af funktionalitetsomr†de;
               ENU=Application Area Setup];
  }
  FIELDS
  {
    { 1   ;   ;Company Name        ;Text30        ;TableRelation=Company;
                                                   CaptionML=[DAN=Firmanavn;
                                                              ENU=Company Name] }
    { 2   ;   ;Profile ID          ;Code30        ;TableRelation=Profile;
                                                   CaptionML=[DAN=Profil-id;
                                                              ENU=Profile ID] }
    { 3   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 40  ;   ;Invoicing           ;Boolean       ;CaptionML=[DAN=Fakturering;
                                                              ENU=Invoicing] }
    { 100 ;   ;Basic               ;Boolean       ;CaptionML=[DAN=Basis;
                                                              ENU=Basic] }
    { 200 ;   ;Suite               ;Boolean       ;CaptionML=[DAN=Suite;
                                                              ENU=Suite] }
    { 300 ;   ;Relationship Mgmt   ;Boolean       ;CaptionML=[DAN=Relationsstyring;
                                                              ENU=Relationship Mgmt] }
    { 400 ;   ;Jobs                ;Boolean       ;CaptionML=[DAN=Sager;
                                                              ENU=Jobs] }
    { 500 ;   ;Fixed Assets        ;Boolean       ;CaptionML=[DAN=Anl‘g;
                                                              ENU=Fixed Assets] }
    { 600 ;   ;Location            ;Boolean       ;CaptionML=[DAN=Lokation;
                                                              ENU=Location] }
    { 700 ;   ;BasicHR             ;Boolean       ;CaptionML=[DAN=BasicHR;
                                                              ENU=BasicHR] }
    { 800 ;   ;Assembly            ;Boolean       ;CaptionML=[DAN=Montage;
                                                              ENU=Assembly] }
    { 900 ;   ;Item Charges        ;Boolean       ;CaptionML=[DAN=Varegebyrer;
                                                              ENU=Item Charges] }
    { 1000;   ;Advanced            ;Boolean       ;CaptionML=[DAN=Avanceret;
                                                              ENU=Advanced] }
    { 1100;   ;Warehouse           ;Boolean       ;CaptionML=[DAN=Lagersted;
                                                              ENU=Warehouse] }
    { 1200;   ;Service             ;Boolean       ;CaptionML=[DAN=Tjeneste;
                                                              ENU=Service] }
    { 1300;   ;Manufacturing       ;Boolean       ;CaptionML=[DAN=Produktion;
                                                              ENU=Manufacturing] }
    { 1400;   ;Planning            ;Boolean       ;CaptionML=[DAN=Planl‘gning;
                                                              ENU=Planning] }
    { 1500;   ;Dimensions          ;Boolean       ;CaptionML=[DAN=Dimensioner;
                                                              ENU=Dimensions] }
    { 1600;   ;Item Tracking       ;Boolean       ;CaptionML=[DAN=Varesporing;
                                                              ENU=Item Tracking] }
    { 1700;   ;Intercompany        ;Boolean       ;CaptionML=[DAN=Koncernintern;
                                                              ENU=Intercompany] }
    { 1800;   ;Sales Return Order  ;Boolean       ;CaptionML=[DAN=Salgsreturvareordre;
                                                              ENU=Sales Return Order] }
    { 1900;   ;Purch Return Order  ;Boolean       ;CaptionML=[DAN=K›bsreturvareordre;
                                                              ENU=Purch Return Order] }
    { 2000;   ;Prepayments         ;Boolean       ;CaptionML=[DAN=Forudbetalinger;
                                                              ENU=Prepayments] }
    { 2100;   ;Cost Accounting     ;Boolean       ;CaptionML=[DAN=Omkostningsregnskab;
                                                              ENU=Cost Accounting] }
    { 2200;   ;Sales Budget        ;Boolean       ;CaptionML=[DAN=Salgsbudget;
                                                              ENU=Sales Budget] }
    { 2300;   ;Purchase Budget     ;Boolean       ;CaptionML=[DAN=K›bsbudget;
                                                              ENU=Purchase Budget] }
    { 2400;   ;Item Budget         ;Boolean       ;CaptionML=[DAN=Varebudget;
                                                              ENU=Item Budget] }
    { 2500;   ;Sales Analysis      ;Boolean       ;CaptionML=[DAN=Salgsanalyse;
                                                              ENU=Sales Analysis] }
    { 2600;   ;Purchase Analysis   ;Boolean       ;CaptionML=[DAN=K›bsanalyse;
                                                              ENU=Purchase Analysis] }
    { 2700;   ;XBRL                ;Boolean       ;CaptionML=[DAN=XBRL;
                                                              ENU=XBRL] }
  }
  KEYS
  {
    {    ;Company Name,Profile ID,User ID         ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ValuesNotAllowedErr@1000 : TextConst 'DAN=" Det valgte oplevelsesniveau underst›ttes ikke.\\I vinduet Funktionalitetsomr†de kan du definere, hvad der skal vises p† brugergr‘nsefladen.";ENU=" The selected experience tier is not supported.\\In the Application Area window, you define what is shown in the user interface."';

    LOCAL PROCEDURE GetApplicationAreaSetupRec@3(VAR ApplicationAreaSetup@1000 : Record 9178) : Boolean;
    VAR
      ConfPersonalizationMgt@1001 : Codeunit 9170;
    BEGIN
      IF NOT ApplicationAreaSetup.GET('','',USERID) THEN
        IF NOT ApplicationAreaSetup.GET('',ConfPersonalizationMgt.GetCurrentProfileIDNoError) THEN
          EXIT(GetApplicationAreaSetupRecFromCompany(ApplicationAreaSetup));
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetApplicationAreaSetupRecFromCompany@13(VAR ApplicationAreaSetup@1000 : Record 9178) : Boolean;
    BEGIN
      IF NOT ApplicationAreaSetup.GET(COMPANYNAME) THEN
        EXIT(ApplicationAreaSetup.GET);
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE GetApplicationAreaSetup@66() ApplicationAreas : Text;
    VAR
      Field@1001 : Record 2000000041;
      ApplicationAreaSetup@1003 : Record 9178;
      TypeHelper@1006 : Codeunit 10;
      RecRef@1002 : RecordRef;
      FieldRef@1005 : FieldRef;
      Separator@1000 : Text;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(ApplicationAreas);

      RecRef.GETTABLE(ApplicationAreaSetup);

      IF TypeHelper.FindFields(RecRef.NUMBER,Field) THEN
        REPEAT
          FieldRef := RecRef.FIELD(Field."No.");
          IF NOT IsInPrimaryKey(FieldRef) THEN
            IF FieldRef.VALUE THEN BEGIN
              ApplicationAreas += Separator + '#' + DELCHR(FieldRef.NAME);
              Separator := ',';
            END;
        UNTIL Field.NEXT = 0;
    END;

    [Internal]
    PROCEDURE GetApplicationAreaBuffer@2(VAR TempApplicationAreaBuffer@1000 : TEMPORARY Record 9179);
    VAR
      Field@1001 : Record 2000000041;
      ApplicationAreaSetup@1003 : Record 9178;
      TypeHelper@1006 : Codeunit 10;
      RecRef@1002 : RecordRef;
      FieldRef@1005 : FieldRef;
    BEGIN
      GetApplicationAreaSetupRec(ApplicationAreaSetup);
      RecRef.GETTABLE(ApplicationAreaSetup);

      Field.SETFILTER("No.",'%1..',GetFirstPublicAppAreaFieldNo);
      IF TypeHelper.FindFields(RecRef.NUMBER,Field) THEN
        REPEAT
          FieldRef := RecRef.FIELD(Field."No.");
          TempApplicationAreaBuffer."Field No." := FieldRef.NUMBER;
          TempApplicationAreaBuffer."Application Area" := FieldRef.CAPTION;
          TempApplicationAreaBuffer.Selected := FieldRef.VALUE;
          TempApplicationAreaBuffer.INSERT(TRUE);
        UNTIL Field.NEXT = 0;
    END;

    [External]
    PROCEDURE IsFoundationEnabled@4() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Basic OR ApplicationAreaSetup.Suite);
    END;

    [External]
    PROCEDURE IsBasicOnlyEnabled@14() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Basic AND NOT ApplicationAreaSetup.Suite AND NOT ApplicationAreaSetup.Advanced);
    END;

    [External]
    PROCEDURE IsAdvanced@6() : Boolean;
    BEGIN
      EXIT(NOT IsFoundationEnabled);
    END;

    [External]
    PROCEDURE IsFixedAssetEnabled@22() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup."Fixed Assets");
    END;

    [External]
    PROCEDURE IsJobsEnabled@15() : Boolean;
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Jobs);
    END;

    [External]
    PROCEDURE IsBasicHREnabled@19() : Boolean;
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.BasicHR);
    END;

    [External]
    PROCEDURE IsDimensionEnabled@37() : Boolean;
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Dimensions);
    END;

    [External]
    PROCEDURE IsLocationEnabled@18() : Boolean;
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Location);
    END;

    [External]
    PROCEDURE IsAssemblyEnabled@27() : Boolean;
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Assembly);
    END;

    [External]
    PROCEDURE IsItemChargesEnabled@28() : Boolean;
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup."Item Charges");
    END;

    [External]
    PROCEDURE IsItemTrackingEnabled@36() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup."Item Tracking");
    END;

    [External]
    PROCEDURE IsIntercompanyEnabled@38() : Boolean;
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Intercompany);
    END;

    [External]
    PROCEDURE IsSalesReturnOrderEnabled@31() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup."Sales Return Order");
    END;

    [External]
    PROCEDURE IsPurchaseReturnOrderEnabled@40() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup."Purch Return Order");
    END;

    [External]
    PROCEDURE IsCostAccountingEnabled@41() : Boolean;
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup."Cost Accounting");
    END;

    [External]
    PROCEDURE IsInvoicingOnlyEnabled@29() : Boolean;
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(
        ApplicationAreaSetup.Invoicing AND
        NOT ApplicationAreaSetup.Basic AND
        NOT ApplicationAreaSetup.Suite AND
        NOT ApplicationAreaSetup.Advanced AND
        NOT ApplicationAreaSetup."Relationship Mgmt" AND
        NOT ApplicationAreaSetup.Jobs AND
        NOT ApplicationAreaSetup."Fixed Assets" AND
        NOT ApplicationAreaSetup.Location AND
        NOT ApplicationAreaSetup.BasicHR AND
        NOT ApplicationAreaSetup.Assembly AND
        NOT ApplicationAreaSetup.Dimensions AND
        NOT ApplicationAreaSetup."Item Charges" AND
        NOT ApplicationAreaSetup."Item Tracking" AND
        NOT ApplicationAreaSetup."Cost Accounting" AND
        NOT ApplicationAreaSetup.Manufacturing AND
        NOT ApplicationAreaSetup.Planning AND
        NOT ApplicationAreaSetup.Service AND
        NOT ApplicationAreaSetup.Warehouse AND
        NOT ApplicationAreaSetup.Intercompany AND
        NOT ApplicationAreaSetup.Prepayments);
    END;

    [External]
    PROCEDURE IsManufacturingEnabled@32() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Manufacturing);
    END;

    [External]
    PROCEDURE IsPlanningEnabled@33() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Planning);
    END;

    [External]
    PROCEDURE IsRelationshipMgmtEnabled@39() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup."Relationship Mgmt");
    END;

    [External]
    PROCEDURE IsServiceEnabled@34() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Service);
    END;

    [External]
    PROCEDURE IsWarehouseEnabled@35() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Warehouse);
    END;

    [External]
    PROCEDURE IsSuiteEnabled@16() : Boolean;
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);

      EXIT(ApplicationAreaSetup.Suite);
    END;

    [External]
    PROCEDURE IsAllDisabled@17() : Boolean;
    BEGIN
      EXIT(NOT IsAnyEnabled);
    END;

    LOCAL PROCEDURE IsAnyEnabled@21() : Boolean;
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRec(ApplicationAreaSetup) THEN
        EXIT(FALSE);
      EXIT(SelectedAppAreaCount(ApplicationAreaSetup) > 0);
    END;

    PROCEDURE IsAdvancedSaaSEnabled@30() : Boolean;
    VAR
      PermissionManager@1001 : Codeunit 9002;
    BEGIN
      EXIT(PermissionManager.IsSandboxConfiguration);
    END;

    LOCAL PROCEDURE SelectedAppAreaCount@25(ApplicationAreaSetup@1000 : Record 9178) : Integer;
    VAR
      Field@1005 : Record 2000000041;
      TypeHelper@1006 : Codeunit 10;
      RecRef@1003 : RecordRef;
      FieldRef@1002 : FieldRef;
      Count@1004 : Integer;
    BEGIN
      RecRef.GETTABLE(ApplicationAreaSetup);

      Field.SETFILTER("No.",'%1..',GetFirstPublicAppAreaFieldNo);
      IF TypeHelper.FindFields(RecRef.NUMBER,Field) THEN
        REPEAT
          FieldRef := RecRef.FIELD(Field."No.");
          IF FieldRef.VALUE THEN
            Count += 1;
        UNTIL Field.NEXT = 0;
      EXIT(Count);
    END;

    PROCEDURE GetFirstPublicAppAreaFieldNo@42() : Integer;
    VAR
      ApplicationAreaSetup@1002 : Record 9178;
    BEGIN
      EXIT(ApplicationAreaSetup.FIELDNO(Basic));
    END;

    LOCAL PROCEDURE SaveApplicationArea@5(VAR TempApplicationAreaBuffer@1000 : TEMPORARY Record 9179;ApplicationAreaSetup@1006 : Record 9178;NoApplicationAreasExist@1007 : Boolean);
    VAR
      ExistingTempApplicationAreaBuffer@1009 : TEMPORARY Record 9179;
      UserPreference@1010 : Record 1306;
      RecRef@1002 : RecordRef;
      FieldRef@1005 : FieldRef;
      ApplicationAreasChanged@1001 : Boolean;
    BEGIN
      GetApplicationAreaBuffer(ExistingTempApplicationAreaBuffer);
      RecRef.GETTABLE(ApplicationAreaSetup);

      TempApplicationAreaBuffer.FINDFIRST;
      ExistingTempApplicationAreaBuffer.FINDFIRST;
      REPEAT
        FieldRef := RecRef.FIELD(TempApplicationAreaBuffer."Field No.");
        FieldRef.VALUE := TempApplicationAreaBuffer.Selected;
        IF TempApplicationAreaBuffer.Selected <> ExistingTempApplicationAreaBuffer.Selected THEN
          ApplicationAreasChanged := TRUE;
      UNTIL (TempApplicationAreaBuffer.NEXT = 0) AND (ExistingTempApplicationAreaBuffer.NEXT = 0);

      IF NoApplicationAreasExist THEN BEGIN
        IF ApplicationAreasChanged THEN
          RecRef.INSERT(TRUE);
      END ELSE
        RecRef.MODIFY(TRUE);

      UserPreference.SETFILTER("User ID",USERID);
      UserPreference.DELETEALL;

      SetupApplicationArea;
    END;

    LOCAL PROCEDURE TrySaveApplicationArea@8(VAR TempApplicationAreaBuffer@1000 : TEMPORARY Record 9179;ApplicationAreaSetup@1003 : Record 9178;NoApplicationAreaExist@1002 : Boolean) IsApplicationAreaChanged : Boolean;
    VAR
      OldApplicationArea@1001 : Text;
    BEGIN
      OldApplicationArea := APPLICATIONAREA;
      SaveApplicationArea(TempApplicationAreaBuffer,ApplicationAreaSetup,NoApplicationAreaExist);
      IsApplicationAreaChanged := OldApplicationArea <> APPLICATIONAREA;
    END;

    [Internal]
    PROCEDURE TrySaveApplicationAreaCurrentCompany@11(VAR TempApplicationAreaBuffer@1000 : TEMPORARY Record 9179) IsApplicationAreaChanged : Boolean;
    VAR
      ApplicationAreaSetup@1003 : Record 9178;
      NoCompanyApplicationAreasExist@1002 : Boolean;
    BEGIN
      IF NOT ApplicationAreaSetup.GET(COMPANYNAME) THEN BEGIN
        ApplicationAreaSetup."Company Name" := COMPANYNAME;
        NoCompanyApplicationAreasExist := TRUE;
      END;

      IsApplicationAreaChanged :=
        TrySaveApplicationArea(TempApplicationAreaBuffer,ApplicationAreaSetup,NoCompanyApplicationAreasExist);
    END;

    [Internal]
    PROCEDURE TrySaveApplicationAreaCurrentUser@12(VAR TempApplicationAreaBuffer@1000 : TEMPORARY Record 9179) IsApplicationAreaChanged : Boolean;
    VAR
      ApplicationAreaSetup@1003 : Record 9178;
      NoUserApplicationAreasExist@1002 : Boolean;
    BEGIN
      IF NOT ApplicationAreaSetup.GET('','',USERID) THEN BEGIN
        ApplicationAreaSetup."User ID" := USERID;
        NoUserApplicationAreasExist := TRUE;
      END;

      IsApplicationAreaChanged :=
        TrySaveApplicationArea(TempApplicationAreaBuffer,ApplicationAreaSetup,NoUserApplicationAreasExist);
    END;

    [Internal]
    PROCEDURE SetupApplicationArea@1();
    BEGIN
      APPLICATIONAREA(GetApplicationAreaSetup);
    END;

    LOCAL PROCEDURE IsInPrimaryKey@7(FieldRef@1000 : FieldRef) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
      KeyRef@1001 : KeyRef;
      FieldIndex@1002 : Integer;
    BEGIN
      RecRef := FieldRef.RECORD;

      KeyRef := RecRef.KEYINDEX(1);
      FOR FieldIndex := 1 TO KeyRef.FIELDCOUNT DO
        IF KeyRef.FIELDINDEX(FieldIndex).NUMBER = FieldRef.NUMBER THEN
          EXIT(TRUE);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE GetExperienceTierCurrentCompany@9(VAR ExperienceTier@1000 : ',,,,,Basic,,,,,,,,,,Suite,,,,,Custom,,,,,Advanced');
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF NOT GetApplicationAreaSetupRecFromCompany(ApplicationAreaSetup) THEN
        EXIT;

      IF GetApplicationAreaSetup = '' THEN BEGIN
        IF IsAdvancedSaaSEnabled THEN
          ExperienceTier := ExperienceTier::Advanced;
        EXIT;
      END;

      WITH ApplicationAreaSetup DO
        CASE TRUE OF
          (SelectedAppAreaCount(ApplicationAreaSetup) = 15) AND
          Basic AND Suite AND "Relationship Mgmt" AND Jobs AND "Fixed Assets" AND Location AND
          BasicHR AND Assembly AND "Item Charges" AND Intercompany AND "Sales Return Order" AND
          "Purch Return Order" AND Prepayments AND "Cost Accounting" AND "Item Tracking":
            ExperienceTier := ExperienceTier::Suite;
          (SelectedAppAreaCount(ApplicationAreaSetup) = 2) AND Basic AND "Relationship Mgmt":
            ExperienceTier := ExperienceTier::Basic;
          Basic AND Suite AND Advanced:
            ExperienceTier := ExperienceTier::Advanced;
          ELSE
            ExperienceTier := ExperienceTier::Custom;
        END;
    END;

    [External]
    PROCEDURE SetExperienceTierCurrentCompany@10(ExperienceTier@1000 : ',,,,,Basic,,,,,,,,,,Suite,,,,,Custom,,,,,Advanced');
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
    BEGIN
      IF ExperienceTier = ExperienceTier::Custom THEN
        ERROR(ValuesNotAllowedErr);

      WITH ApplicationAreaSetup DO BEGIN
        IF NOT GET(COMPANYNAME,'','') THEN BEGIN
          "Company Name" := COMPANYNAME;
          INSERT;
        END;

        SetExperienceTier(ExperienceTier);
        MODIFY;
      END;

      SetupApplicationArea;
    END;

    PROCEDURE SetExperienceTier@23(ExperienceTier@1000 : ' ,,,,,Basic,,,,,,,,,,Suite,,,,,Custom,,,,,Advanced');
    BEGIN
      IF ExperienceTier = ExperienceTier::Advanced THEN BEGIN
        Basic := FALSE;
        Suite := FALSE;
        Advanced := FALSE;
      END ELSE BEGIN
        Basic := ExperienceTier <> ExperienceTier::" ";
        Suite := ExperienceTier = ExperienceTier::Suite;
        Advanced := FALSE;
      END;
      SetApplicationAreasMatchingCurrentExperienceTier;
    END;

    PROCEDURE GetFirstPublicAppAreaFieldIndex@20() : Integer;
    VAR
      RecRef@1000 : RecordRef;
      FirstPublicAppAreaFieldRef@1001 : FieldRef;
      i@1003 : Integer;
    BEGIN
      RecRef.GETTABLE(Rec);
      FirstPublicAppAreaFieldRef := RecRef.FIELD(FIELDNO(Basic));
      FOR i := 1 TO RecRef.FIELDCOUNT DO
        IF RecRef.FIELDINDEX(i).NUMBER = FirstPublicAppAreaFieldRef.NUMBER THEN
          EXIT(i);
    END;

    PROCEDURE SetApplicationAreasMatchingCurrentExperienceTier@26();
    BEGIN
      "Relationship Mgmt" := Basic;
      Assembly := Suite;
      Jobs := Suite;
      "Fixed Assets" := Suite;
      Location := Suite;
      BasicHR := Suite;
      "Item Charges" := Suite;
      Intercompany := Suite;
      "Sales Return Order" := Suite;
      "Purch Return Order" := Suite;
      Prepayments := Suite;
      "Cost Accounting" := Suite;
      "Item Tracking" := Suite;
      Dimensions := Advanced;
      Manufacturing := Advanced;
      Planning := Advanced;
      Service := Advanced;
      Warehouse := Advanced;
    END;

    PROCEDURE ResetNonSelectableApplicationAreas@24();
    VAR
      ApplicationAreaSetup@1000 : Record 9178;
    BEGIN
      IF ApplicationAreaSetup.FINDSET(TRUE) THEN
        REPEAT
          ApplicationAreaSetup.SetApplicationAreasMatchingCurrentExperienceTier;
          ApplicationAreaSetup.MODIFY;
        UNTIL ApplicationAreaSetup.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

