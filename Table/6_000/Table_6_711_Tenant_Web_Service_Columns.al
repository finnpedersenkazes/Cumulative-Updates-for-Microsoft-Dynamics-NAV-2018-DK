OBJECT Table 6711 Tenant Web Service Columns
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
    CaptionML=[DAN=Webtjenestekolonner for lejer;
               ENU=Tenant Web Service Columns];
  }
  FIELDS
  {
    { 1   ;   ;Entry ID            ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Post-id;
                                                              ENU=Entry ID] }
    { 2   ;   ;Data Item           ;Integer       ;CaptionML=[DAN=Dataelement;
                                                              ENU=Data Item] }
    { 3   ;   ;Field Number        ;Integer       ;CaptionML=[DAN=Feltnummer;
                                                              ENU=Field Number] }
    { 4   ;   ;Field Name          ;Text250       ;CaptionML=[DAN=Rapportoverskrift;
                                                              ENU=Report Caption] }
    { 5   ;   ;TenantWebServiceID  ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=TenantWebServiceID;
                                                              ENU=TenantWebServiceID] }
    { 6   ;   ;Data Item Caption   ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Table),
                                                                                                                Object ID=FIELD(Data Item)));
                                                   CaptionML=[DAN=Tabel;
                                                              ENU=Table] }
    { 7   ;   ;Include             ;Boolean       ;CaptionML=[DAN=Inkluder;
                                                              ENU=Include] }
    { 8   ;   ;Field Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Data Item),
                                                                                                   No.=FIELD(Field Number)));
                                                   CaptionML=[DAN=Felttitel;
                                                              ENU=Field Caption] }
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

    PROCEDURE GetTableName@1(DataItem@1001 : Integer) : Text;
    VAR
      AllObjWithCaption@1000 : Record 2000000058;
    BEGIN
      AllObjWithCaption."Object Type" := AllObjWithCaption."Object Type"::Table;
      AllObjWithCaption."Object ID" := DataItem;
      IF AllObjWithCaption.FINDFIRST THEN
        EXIT(AllObjWithCaption."Object Caption");
    END;

    PROCEDURE CreateFromTemp@2(VAR TempTenantWebServiceColumns@1000 : TEMPORARY Record 6711;TenantWebServiceRecordId@1001 : RecordID);
    BEGIN
      IF TempTenantWebServiceColumns.FINDSET THEN BEGIN
        SETRANGE(TenantWebServiceID,TenantWebServiceRecordId);
        DELETEALL;

        REPEAT
          INIT;
          TRANSFERFIELDS(TempTenantWebServiceColumns,TRUE);
          "Entry ID" := 0;
          TenantWebServiceID := TenantWebServiceRecordId;
          INSERT;
        UNTIL TempTenantWebServiceColumns.NEXT = 0;
      END;
    END;

    BEGIN
    END.
  }
}

