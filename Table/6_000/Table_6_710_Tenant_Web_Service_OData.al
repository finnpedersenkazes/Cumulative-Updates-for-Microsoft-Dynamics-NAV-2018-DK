OBJECT Table 6710 Tenant Web Service OData
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
    CaptionML=[DAN=Webtjeneste-OData for lejer;
               ENU=Tenant Web Service OData];
  }
  FIELDS
  {
    { 1   ;   ;TenantWebServiceID  ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=TenantWebServiceID;
                                                              ENU=TenantWebServiceID] }
    { 2   ;   ;ODataSelectClause   ;BLOB          ;CaptionML=[DAN=ODataSelectClause;
                                                              ENU=ODataSelectClause] }
    { 3   ;   ;ODataFilterClause   ;BLOB          ;CaptionML=[DAN=ODataFilterClause;
                                                              ENU=ODataFilterClause] }
    { 4   ;   ;ODataV4FilterClause ;BLOB          ;CaptionML=[DAN=ODataV4FilterClause;
                                                              ENU=ODataV4FilterClause] }
  }
  KEYS
  {
    {    ;TenantWebServiceID                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE SetOdataSelectClause@1(ODataText@1000 : Text);
    VAR
      WriteStream@1001 : OutStream;
    BEGIN
      CLEAR(ODataSelectClause);
      ODataSelectClause.CREATEOUTSTREAM(WriteStream);
      WriteStream.WRITETEXT(ODataText);
    END;

    [External]
    PROCEDURE GetOdataSelectClause@2() : Text;
    VAR
      ReadStream@1000 : InStream;
      ODataText@1001 : Text;
    BEGIN
      CALCFIELDS(ODataSelectClause);
      ODataSelectClause.CREATEINSTREAM(ReadStream);
      ReadStream.READTEXT(ODataText);
      EXIT(ODataText);
    END;

    [External]
    PROCEDURE SetOdataFilterClause@4(ODataText@1000 : Text);
    VAR
      WriteStream@1001 : OutStream;
    BEGIN
      CLEAR(ODataFilterClause);
      ODataFilterClause.CREATEOUTSTREAM(WriteStream);
      WriteStream.WRITETEXT(ODataText);
    END;

    [External]
    PROCEDURE SetOdataV4FilterClause@7(ODataText@1000 : Text);
    VAR
      WriteStream@1001 : OutStream;
    BEGIN
      CLEAR(ODataV4FilterClause);
      ODataV4FilterClause.CREATEOUTSTREAM(WriteStream);
      WriteStream.WRITETEXT(ODataText);
    END;

    [External]
    PROCEDURE GetOdataFilterClause@3() : Text;
    VAR
      ReadStream@1000 : InStream;
      ODataText@1001 : Text;
    BEGIN
      CALCFIELDS(ODataFilterClause);
      ODataFilterClause.CREATEINSTREAM(ReadStream);
      ReadStream.READTEXT(ODataText);
      EXIT(ODataText);
    END;

    [External]
    PROCEDURE GetOdataV4FilterClause@5() : Text;
    VAR
      ReadStream@1000 : InStream;
      ODataText@1001 : Text;
    BEGIN
      CALCFIELDS(ODataV4FilterClause);
      ODataV4FilterClause.CREATEINSTREAM(ReadStream);
      ReadStream.READTEXT(ODataText);
      EXIT(ODataText);
    END;

    BEGIN
    END.
  }
}

