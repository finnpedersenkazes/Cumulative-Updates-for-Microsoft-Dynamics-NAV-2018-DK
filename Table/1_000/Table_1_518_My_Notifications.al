OBJECT Table 1518 My Notifications
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Mine notifikationer;
               ENU=My Notifications];
  }
  FIELDS
  {
    { 1   ;   ;User Id             ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User Id];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 2   ;   ;Notification Id     ;GUID          ;CaptionML=[DAN=Notifikations-id;
                                                              ENU=Notification Id];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 3   ;   ;Apply to Table Id   ;Integer       ;CaptionML=[DAN=Anvend p† tabel-id;
                                                              ENU=Apply to Table Id];
                                                   Editable=No }
    { 4   ;   ;Enabled             ;Boolean       ;OnValidate=BEGIN
                                                                IF Enabled <> xRec.Enabled THEN
                                                                  OnStateChanged("Notification Id",Enabled);
                                                              END;

                                                   CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
    { 5   ;   ;Apply to Table Filter;BLOB         ;CaptionML=[DAN=Filtrer;
                                                              ENU=Filter] }
    { 6   ;   ;Name                ;Text128       ;CaptionML=[DAN=Notifikation;
                                                              ENU=Notification];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 7   ;   ;Description         ;BLOB          ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
  }
  KEYS
  {
    {    ;User Id,Notification Id                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ViewFilterDetailsTxt@1005 : TextConst 'DAN=(Vis filterdetaljer);ENU=(View filter details)';
      DefineFiltersTxt@1006 : TextConst 'DAN=Definer filtre...;ENU=Define filters...';

    [External]
    PROCEDURE Disable@4(NotificationId@1000 : GUID) : Boolean;
    BEGIN
      IF GET(USERID,NotificationId) THEN BEGIN
        VALIDATE(Enabled,FALSE);
        MODIFY;
        EXIT(TRUE)
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsFilterEnabled@5() : Boolean;
    BEGIN
      EXIT(("Apply to Table Id" <> 0) AND Enabled);
    END;

    LOCAL PROCEDURE InitRecord@9(NotificationId@1000 : GUID;NotificationName@1002 : Text[128];DescriptionText@1001 : Text) Result : Boolean;
    VAR
      OutStream@1003 : OutStream;
    BEGIN
      IF NOT GET(USERID,NotificationId) THEN BEGIN
        INIT;
        "User Id" := USERID;
        "Notification Id" := NotificationId;
        Enabled := TRUE;
        Name := NotificationName;
        Description.CREATEOUTSTREAM(OutStream);
        OutStream.WRITE(DescriptionText);
        Result := TRUE;
      END;
    END;

    [External]
    PROCEDURE InsertDefault@12(NotificationId@1000 : GUID;NotificationName@1002 : Text[128];DescriptionText@1003 : Text;DefaultState@1001 : Boolean);
    BEGIN
      IF InitRecord(NotificationId,NotificationName,DescriptionText) THEN BEGIN
        Enabled := DefaultState;
        INSERT;
      END;
    END;

    [External]
    PROCEDURE InsertDefaultWithTableNum@13(NotificationId@1000 : GUID;NotificationName@1003 : Text[128];DescriptionText@1002 : Text;TableNum@1001 : Integer);
    BEGIN
      IF InitRecord(NotificationId,NotificationName,DescriptionText) THEN BEGIN
        "Apply to Table Id" := TableNum;
        INSERT;
      END;
    END;

    [External]
    PROCEDURE GetDescription@2() Ret : Text;
    VAR
      InStream@1000 : InStream;
    BEGIN
      CALCFIELDS(Description);
      IF NOT Description.HASVALUE THEN
        EXIT;
      Description.CREATEINSTREAM(InStream);
      InStream.READ(Ret);
    END;

    LOCAL PROCEDURE GetFilteredRecord@10(VAR RecordRef@1003 : RecordRef;Filters@1001 : Text);
    VAR
      TempBlob@1000 : Record 99008535;
      RequestPageParametersHelper@1002 : Codeunit 1530;
      FiltersOutStream@1004 : OutStream;
    BEGIN
      TempBlob.INIT;
      TempBlob.Blob.CREATEOUTSTREAM(FiltersOutStream);
      FiltersOutStream.WRITE(Filters);

      RecordRef.OPEN("Apply to Table Id");
      RequestPageParametersHelper.ConvertParametersToFilters(RecordRef,TempBlob);
    END;

    [Internal]
    PROCEDURE GetFiltersAsDisplayText@1() : Text;
    VAR
      RecordRef@1002 : RecordRef;
    BEGIN
      IF NOT IsFilterEnabled THEN
        EXIT;

      GetFilteredRecord(RecordRef,GetFiltersAsText);

      IF RecordRef.GETFILTERS <> '' THEN
        EXIT(RecordRef.GETFILTERS);

      EXIT(ViewFilterDetailsTxt);
    END;

    LOCAL PROCEDURE GetFiltersAsText@8() Filters : Text;
    VAR
      FiltersInStream@1000 : InStream;
    BEGIN
      IF NOT IsFilterEnabled THEN
        EXIT;

      CALCFIELDS("Apply to Table Filter");
      IF NOT "Apply to Table Filter".HASVALUE THEN
        EXIT;
      "Apply to Table Filter".CREATEINSTREAM(FiltersInStream);
      FiltersInStream.READ(Filters);
    END;

    [Internal]
    PROCEDURE OpenFilterSettings@17() Changed : Boolean;
    VAR
      DummyMyNotifications@1003 : Record 1518;
      RecordRef@1002 : RecordRef;
      FiltersOutStream@1000 : OutStream;
      NewFilters@1001 : Text;
    BEGIN
      IF NOT IsFilterEnabled THEN
        EXIT;

      IF RunDynamicRequestPage(NewFilters,
           GetFiltersAsText,
           "Apply to Table Id")
      THEN BEGIN
        GetFilteredRecord(RecordRef,NewFilters);
        IF RecordRef.GETFILTERS = '' THEN
          "Apply to Table Filter" := DummyMyNotifications."Apply to Table Filter"
        ELSE BEGIN
          "Apply to Table Filter".CREATEOUTSTREAM(FiltersOutStream);
          FiltersOutStream.WRITE(NewFilters);
        END;
        MODIFY;
        Changed := TRUE;
      END;
    END;

    LOCAL PROCEDURE RunDynamicRequestPage@20(VAR ReturnFilters@1004 : Text;Filters@1005 : Text;TableNum@1001 : Integer) FiltersSet : Boolean;
    VAR
      RequestPageParametersHelper@1002 : Codeunit 1530;
      FilterPageBuilder@1003 : FilterPageBuilder;
    BEGIN
      IF NOT RequestPageParametersHelper.BuildDynamicRequestPage(FilterPageBuilder,DefineFiltersTxt,TableNum) THEN
        EXIT(FALSE);

      IF Filters <> '' THEN
        IF NOT RequestPageParametersHelper.SetViewOnDynamicRequestPage(
             FilterPageBuilder,Filters,DefineFiltersTxt,TableNum)
        THEN
          EXIT(FALSE);

      FilterPageBuilder.PAGECAPTION := DefineFiltersTxt;
      IF NOT FilterPageBuilder.RUNMODAL THEN
        EXIT(FALSE);

      ReturnFilters :=
        RequestPageParametersHelper.GetViewFromDynamicRequestPage(FilterPageBuilder,DefineFiltersTxt,TableNum);

      FiltersSet := TRUE;
    END;

    [External]
    PROCEDURE IsEnabledForRecord@11(NotificationId@1008 : GUID;Record@1000 : Variant) : Boolean;
    VAR
      RecordRef@1007 : RecordRef;
      RecordRefPassed@1006 : RecordRef;
      Filters@1001 : Text;
    BEGIN
      IF NOT IsEnabled(NotificationId) THEN
        EXIT(FALSE);

      IF NOT Record.ISRECORD THEN
        EXIT(TRUE);

      RecordRefPassed.GETTABLE(Record);
      RecordRefPassed.FILTERGROUP(2);
      RecordRefPassed.SETRECFILTER;
      RecordRefPassed.FILTERGROUP(0);

      Filters := GetFiltersAsText;
      IF Filters = '' THEN
        EXIT(TRUE);

      GetFilteredRecord(RecordRef,Filters);
      RecordRefPassed.SETVIEW(RecordRef.GETVIEW);
      EXIT(NOT RecordRefPassed.ISEMPTY);
    END;

    [External]
    PROCEDURE IsEnabled@14(NotificationId@1000 : GUID) : Boolean;
    BEGIN
      IF NOT GET(USERID,NotificationId) THEN
        EXIT(TRUE);

      EXIT(Enabled);
    END;

    [Integration]
    [External]
    PROCEDURE OnStateChanged@3(NotificationId@1001 : GUID;NewEnabledState@1000 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

