OBJECT Table 7823 MS-QBO Modified Field List
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=MS-QBO Rettet feltoversigt;
               ENU=MS-QBO Modified Field List];
  }
  FIELDS
  {
    { 1   ;   ;Record Id           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record Id] }
    { 2   ;   ;Field Id            ;Integer       ;CaptionML=[DAN=Felt-id;
                                                              ENU=Field Id] }
    { 3   ;   ;Field Value         ;BLOB          ;CaptionML=[DAN=Feltv‘rdi;
                                                              ENU=Field Value] }
  }
  KEYS
  {
    {    ;Record Id,Field Id                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE InsertBase@7(RecordId@1001 : RecordID;FieldId@1000 : Integer);
    BEGIN
      INIT;
      "Record Id" := RecordId;
      "Field Id" := FieldId;
    END;

    LOCAL PROCEDURE InsertVariant@2(RecordId@1005 : RecordID;FieldId@1000 : Integer;FieldValue@1004 : Variant);
    VAR
      TypeHelper@1001 : Codeunit 10;
      RecordRef@1003 : RecordRef;
      FieldRef@1002 : FieldRef;
    BEGIN
      InsertBase(RecordId,FieldId);
      RecordRef.GETTABLE(Rec);
      FieldRef := RecordRef.FIELD(FIELDNO("Field Value"));
      TypeHelper.WriteBlob(FieldRef,FORMAT(FieldValue,0,9));
      RecordRef.SETTABLE(Rec);
      INSERT;
    END;

    LOCAL PROCEDURE InsertBlob@4(RecordId@1002 : RecordID;BlobFieldRef@1000 : FieldRef);
    BEGIN
      InsertBase(RecordId,BlobFieldRef.NUMBER);
      "Field Value" := BlobFieldRef.VALUE;
      INSERT;
    END;

    PROCEDURE ExtractValueFromRecord@14(FieldRef@1002 : FieldRef);
    BEGIN
      IF FORMAT(FieldRef.TYPE) = 'BLOB' THEN
        InsertBlob(FieldRef.RECORD.RECORDID,FieldRef)
      ELSE
        InsertVariant(FieldRef.RECORD.RECORDID,FieldRef.NUMBER,FieldRef.VALUE);
    END;

    PROCEDURE ApplyValuesToRecord@8(VAR RecordRef@1000 : RecordRef);
    VAR
      MSQBOTableMgt@1003 : Codeunit 7820;
      CurrentRecordRef@1004 : RecordRef;
      FieldRef@1001 : FieldRef;
      CurrentFieldRef@1005 : FieldRef;
    BEGIN
      SETRANGE("Record Id","Record Id");
      IF FINDSET THEN
        REPEAT
          FieldRef := RecordRef.FIELD("Field Id");
          CurrentRecordRef.GETTABLE(Rec);
          CurrentFieldRef := CurrentRecordRef.FIELD(FIELDNO("Field Value"));
          IF FORMAT(FieldRef.TYPE) = 'BLOB' THEN
            FieldRef.VALUE := CurrentFieldRef.VALUE
          ELSE
            MSQBOTableMgt.WriteTextToField(FieldRef,MSQBOTableMgt.GetTextValueFromField(CurrentFieldRef));
        UNTIL NEXT = 0;
    END;

    BEGIN
    END.
  }
}

