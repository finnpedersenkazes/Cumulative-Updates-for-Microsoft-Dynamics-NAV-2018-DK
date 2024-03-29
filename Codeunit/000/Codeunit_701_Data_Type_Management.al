OBJECT Codeunit 701 Data Type Management
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {

    [External]
    PROCEDURE GetRecordRefAndFieldRef@21(RecRelatedVariant@1001 : Variant;FieldNumber@1000 : Integer;VAR RecordRef@1002 : RecordRef;VAR FieldRef@1003 : FieldRef) : Boolean;
    BEGIN
      IF NOT GetRecordRef(RecRelatedVariant,RecordRef) THEN
        EXIT(FALSE);

      FieldRef := RecordRef.FIELD(FieldNumber);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE GetRecordRef@24(RecRelatedVariant@1001 : Variant;VAR ResultRecordRef@1002 : RecordRef) : Boolean;
    VAR
      RecID@1000 : RecordID;
    BEGIN
      CASE TRUE OF
        RecRelatedVariant.ISRECORD:
          ResultRecordRef.GETTABLE(RecRelatedVariant);
        RecRelatedVariant.ISRECORDREF:
          ResultRecordRef := RecRelatedVariant;
        RecRelatedVariant.ISRECORDID:
          BEGIN
            RecID := RecRelatedVariant;
            IF RecID.TABLENO = 0 THEN
              EXIT(FALSE);
            IF NOT ResultRecordRef.GET(RecID) THEN
              ResultRecordRef.OPEN(RecID.TABLENO);
          END;
        ELSE
          EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE FindFieldByName@22(RecordRef@1001 : RecordRef;VAR FieldRef@1003 : FieldRef;FieldNameTxt@1000 : Text) : Boolean;
    VAR
      Field@1002 : Record 2000000041;
    BEGIN
      Field.SETRANGE(TableNo,RecordRef.NUMBER);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      Field.SETRANGE(FieldName,FieldNameTxt);

      IF NOT Field.FINDFIRST THEN
        EXIT(FALSE);

      FieldRef := RecordRef.FIELD(Field."No.");
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE SetFieldValue@1(VAR RecordVariant@1000 : Variant;FieldName@1001 : Text;FieldValue@1002 : Variant) : Boolean;
    VAR
      RecRef@1003 : RecordRef;
      FieldRef@1004 : FieldRef;
    BEGIN
      IF NOT GetRecordRef(RecordVariant,RecRef) THEN
        EXIT;
      IF NOT FindFieldByName(RecRef,FieldRef,FieldName) THEN
        EXIT;

      FieldRef.VALUE := FieldValue;
      RecRef.SETTABLE(RecordVariant);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE ValidateFieldValue@2(VAR RecordVariant@1002 : Variant;FieldName@1001 : Text;FieldValue@1000 : Variant) : Boolean;
    VAR
      RecRef@1004 : RecordRef;
      FieldRef@1003 : FieldRef;
    BEGIN
      IF NOT GetRecordRef(RecordVariant,RecRef) THEN
        EXIT;
      IF NOT FindFieldByName(RecRef,FieldRef,FieldName) THEN
        EXIT;

      FieldRef.VALIDATE(FieldValue);
      RecRef.SETTABLE(RecordVariant);
      EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

