OBJECT Table 9160 TempStack
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=TempStack;
               ENU=TempStack];
  }
  FIELDS
  {
    { 1   ;   ;StackOrder          ;Integer       ;CaptionML=[DAN=StackOrder;
                                                              ENU=StackOrder] }
    { 2   ;   ;Value               ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V�rdi;
                                                              ENU=Value] }
  }
  KEYS
  {
    {    ;StackOrder                              ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      LastIndex@1000 : Integer;

    [External]
    PROCEDURE Push@1(NewValue@1000 : RecordID);
    BEGIN
      VALIDATE(StackOrder,LastIndex);
      VALIDATE(Value,NewValue);
      INSERT;
      LastIndex := LastIndex + 1;
    END;

    [External]
    PROCEDURE Pop@2(VAR TopValue@1000 : RecordID) : Boolean;
    BEGIN
      IF FINDLAST THEN BEGIN
        TopValue := Value;
        DELETE;
        LastIndex := LastIndex - 1;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE Peek@5(VAR TopValue@1000 : RecordID) : Boolean;
    BEGIN
      IF FINDLAST THEN BEGIN
        TopValue := Value;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    BEGIN
    END.
  }
}

