OBJECT Table 405 Change Log Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=’ndringslogpost;
               ENU=Change Log Entry];
    LookupPageID=Page595;
    DrillDownPageID=Page595;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;BigInteger    ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Date and Time       ;DateTime      ;CaptionML=[DAN=Dato og tidspunkt;
                                                              ENU=Date and Time] }
    { 3   ;   ;Time                ;Time          ;CaptionML=[DAN=Tidspunkt;
                                                              ENU=Time] }
    { 4   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 5   ;   ;Table No.           ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table));
                                                   CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.] }
    { 6   ;   ;Table Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Table),
                                                                                                                Object ID=FIELD(Table No.)));
                                                   CaptionML=[DAN=Tabeltitel;
                                                              ENU=Table Caption] }
    { 7   ;   ;Field No.           ;Integer       ;TableRelation=Field.No. WHERE (TableNo=FIELD(Table No.));
                                                   CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 8   ;   ;Field Caption       ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                                                                   No.=FIELD(Field No.)));
                                                   CaptionML=[DAN=Felttitel;
                                                              ENU=Field Caption] }
    { 9   ;   ;Type of Change      ;Option        ;CaptionML=[DAN=’ndringstype;
                                                              ENU=Type of Change];
                                                   OptionCaptionML=[DAN=Inds‘ttelse,’ndring,Sletning;
                                                                    ENU=Insertion,Modification,Deletion];
                                                   OptionString=Insertion,Modification,Deletion }
    { 10  ;   ;Old Value           ;Text250       ;CaptionML=[DAN=Gammel v‘rdi;
                                                              ENU=Old Value] }
    { 11  ;   ;New Value           ;Text250       ;CaptionML=[DAN=Ny v‘rdi;
                                                              ENU=New Value] }
    { 12  ;   ;Primary Key         ;Text250       ;CaptionML=[DAN=Prim‘rn›gle;
                                                              ENU=Primary Key] }
    { 13  ;   ;Primary Key Field 1 No.;Integer    ;TableRelation=Field.No. WHERE (TableNo=FIELD(Table No.));
                                                   CaptionML=[DAN=Nr. p† prim‘rn›glefelt 1;
                                                              ENU=Primary Key Field 1 No.] }
    { 14  ;   ;Primary Key Field 1 Caption;Text80 ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                                                                   No.=FIELD(Primary Key Field 1 No.)));
                                                   CaptionML=[DAN=Overskrift for prim‘rn›glefelt 1;
                                                              ENU=Primary Key Field 1 Caption] }
    { 15  ;   ;Primary Key Field 1 Value;Text50   ;CaptionML=[DAN=V‘rdi for prim‘rn›glefelt 1;
                                                              ENU=Primary Key Field 1 Value] }
    { 16  ;   ;Primary Key Field 2 No.;Integer    ;TableRelation=Field.No. WHERE (TableNo=FIELD(Table No.));
                                                   CaptionML=[DAN=Nr. p† prim‘rn›glefelt 2;
                                                              ENU=Primary Key Field 2 No.] }
    { 17  ;   ;Primary Key Field 2 Caption;Text80 ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                                                                   No.=FIELD(Primary Key Field 2 No.)));
                                                   CaptionML=[DAN=Overskrift for prim‘rn›glefelt 2;
                                                              ENU=Primary Key Field 2 Caption] }
    { 18  ;   ;Primary Key Field 2 Value;Text50   ;CaptionML=[DAN=V‘rdi for prim‘rn›glefelt 2;
                                                              ENU=Primary Key Field 2 Value] }
    { 19  ;   ;Primary Key Field 3 No.;Integer    ;TableRelation=Field.No. WHERE (TableNo=FIELD(Table No.));
                                                   CaptionML=[DAN=Nr. p† prim‘rn›glefelt 3;
                                                              ENU=Primary Key Field 3 No.] }
    { 20  ;   ;Primary Key Field 3 Caption;Text80 ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                                                                   No.=FIELD(Primary Key Field 3 No.)));
                                                   CaptionML=[DAN=Overskrift for prim‘rn›glefelt 3;
                                                              ENU=Primary Key Field 3 Caption] }
    { 21  ;   ;Primary Key Field 3 Value;Text50   ;CaptionML=[DAN=V‘rdi for prim‘rn›glefelt 3;
                                                              ENU=Primary Key Field 3 Value] }
    { 22  ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Table No.,Primary Key Field 1 Value      }
    {    ;Table No.,Date and Time                  }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [Internal]
    PROCEDURE GetPrimaryKeyFriendlyName@1() : Text[250];
    VAR
      RecRef@1000 : RecordRef;
      FriendlyName@1004 : Text[250];
      p@1001 : Integer;
    BEGIN
      IF "Primary Key" = '' THEN
        EXIT('');

      // Retain existing formatting of old data
      IF (STRPOS("Primary Key",'CONST(') = 0) AND (STRPOS("Primary Key",'0(') = 0) THEN
        EXIT("Primary Key");

      RecRef.OPEN("Table No.");
      RecRef.SETPOSITION("Primary Key");
      FriendlyName := RecRef.GETPOSITION(TRUE);
      RecRef.CLOSE;

      FriendlyName := DELCHR(FriendlyName,'=','()');
      p := STRPOS(FriendlyName,'CONST');
      WHILE p > 0 DO BEGIN
        FriendlyName := DELSTR(FriendlyName,p,5);
        p := STRPOS(FriendlyName,'CONST');
      END;
      EXIT(FriendlyName);
    END;

    [Internal]
    PROCEDURE GetLocalOldValue@3() : Text;
    BEGIN
      EXIT(GetLocalValue("Old Value"));
    END;

    [Internal]
    PROCEDURE GetLocalNewValue@4() : Text;
    BEGIN
      EXIT(GetLocalValue("New Value"));
    END;

    LOCAL PROCEDURE GetLocalValue@5(Value@1000 : Text) : Text;
    VAR
      Object@1005 : Record 2000000001;
      ChangeLogManagement@1001 : Codeunit 423;
      RecordRef@1002 : RecordRef;
      FieldRef@1003 : FieldRef;
      HasCultureNeutralValues@1004 : Boolean;
    BEGIN
      // The culture neutral storage format was added simultaneously with the Record ID field
      HasCultureNeutralValues := FORMAT("Record ID") <> '';
      Object.SETRANGE(Type,Object.Type::Table);
      Object.SETRANGE(ID,"Table No.");

      IF NOT Object.ISEMPTY AND (Value <> '') AND HasCultureNeutralValues THEN BEGIN
        RecordRef.OPEN("Table No.");
        IF RecordRef.FIELDEXIST("Field No.") THEN BEGIN
          FieldRef := RecordRef.FIELD("Field No.");
          IF ChangeLogManagement.EvaluateTextToFieldRef(Value,FieldRef) THEN
            EXIT(FORMAT(FieldRef.VALUE,0,1));
        END;
      END;

      EXIT(Value);
    END;

    BEGIN
    END.
  }
}

