OBJECT Table 6712 Tenant Web Service Filter
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataPerCompany=No;
    CaptionML=[DAN=Webtjenestefilter for lejer;
               ENU=Tenant Web Service Filter];
  }
  FIELDS
  {
    { 1   ;   ;Entry ID            ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Post-id;
                                                              ENU=Entry ID] }
    { 2   ;   ;Filter              ;BLOB          ;CaptionML=[DAN=Filtrer;
                                                              ENU=Filter] }
    { 3   ;   ;TenantWebServiceID  ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=TenantWebServiceID;
                                                              ENU=TenantWebServiceID] }
    { 4   ;   ;Data Item           ;Integer       ;CaptionML=[DAN=Dataelement;
                                                              ENU=Data Item] }
  }
  KEYS
  {
    {    ;Entry ID                                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE SetFilter@1(FilterText@1000 : Text);
    VAR
      WriteStream@1001 : OutStream;
    BEGIN
      CLEAR(Filter);
      Filter.CREATEOUTSTREAM(WriteStream);
      WriteStream.WRITETEXT(FilterText);
    END;

    PROCEDURE GetFilter@2() : Text;
    VAR
      ReadStream@1000 : InStream;
      FilterText@1001 : Text;
    BEGIN
      CALCFIELDS(Filter);
      Filter.CREATEINSTREAM(ReadStream);
      ReadStream.READTEXT(FilterText);
      EXIT(FilterText);
    END;

    PROCEDURE CreateFromRecordRef@3(VAR RecRef@1000 : RecordRef;TenantWebServiceRecordId@1001 : RecordID);
    BEGIN
      SETRANGE(TenantWebServiceID,TenantWebServiceRecordId);
      DELETEALL;

      INIT;
      "Entry ID" := 0;
      "Data Item" := RecRef.NUMBER;
      TenantWebServiceID := TenantWebServiceRecordId;
      SetFilter(RecRef.GETVIEW);
      INSERT;
    END;

    BEGIN
    END.
  }
}

