OBJECT Table 823 Name/Value Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Navne/v‘rdibuffer;
               ENU=Name/Value Buffer];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;AutoIncrement=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Name                ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Value               ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘rdi;
                                                              ENU=Value] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Name                                     }
    { 2   ;Brick               ;Name,Value                               }
  }
  CODE
  {
    VAR
      TemporaryErr@1000 : TextConst 'DAN=Recorden skal v‘re midlertidig.;ENU=The record must be temporary.';

    [External]
    PROCEDURE AddNewEntry@1001(NewName@1000 : Text[250];NewValue@1001 : Text[250]);
    VAR
      NewID@1002 : Integer;
    BEGIN
      IF NOT ISTEMPORARY THEN
        ERROR(TemporaryErr);

      CLEAR(Rec);

      NewID := 1;
      IF FINDLAST THEN
        NewID := ID + 1;

      ID := NewID;
      Name := NewName;
      Value := NewValue;

      INSERT(TRUE);
    END;

    BEGIN
    END.
  }
}

