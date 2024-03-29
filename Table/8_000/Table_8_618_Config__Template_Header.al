OBJECT Table 8618 Config. Template Header
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    OnDelete=VAR
               ConfigTmplSelectionRules@1000 : Record 8620;
             BEGIN
               CALCFIELDS("Used In Hierarchy");
               IF NOT "Used In Hierarchy" THEN BEGIN
                 ConfigTemplateLine.SETRANGE("Data Template Code",Code);
                 ConfigTemplateLine.DELETEALL;
               END;

               ConfigTmplSelectionRules.SETRANGE("Template Code",Code);
               ConfigTmplSelectionRules.DELETEALL;
             END;

    OnRename=BEGIN
               CALCFIELDS("Used In Hierarchy");
               IF NOT "Used In Hierarchy" THEN BEGIN
                 ConfigTemplateLine.SETRANGE("Data Template Code",xRec.Code);
                 ConfigTemplateLine.FIND('-');
                 REPEAT
                   ConfigTemplateLine.RENAME(Code,ConfigTemplateLine."Line No.");
                 UNTIL ConfigTemplateLine.NEXT = 0;
               END;
             END;

    CaptionML=[DAN=Konfig.skabelonhoved;
               ENU=Config. Template Header];
    LookupPageID=Page8620;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Table ID            ;Integer       ;OnValidate=BEGIN
                                                                TestXRec;
                                                                CALCFIELDS("Table Name");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ConfigValidateMgt.LookupTable("Table ID");
                                                              IF "Table ID" <> 0 THEN
                                                                VALIDATE("Table ID");
                                                            END;

                                                   CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 4   ;   ;Table Name          ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Name" WHERE (Object Type=CONST(Table),
                                                                                                             Object ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Tabelnavn;
                                                              ENU=Table Name];
                                                   Editable=No }
    { 5   ;   ;Table Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Table),
                                                                                                                Object ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Tabeltitel;
                                                              ENU=Table Caption];
                                                   Editable=No }
    { 6   ;   ;Used In Hierarchy   ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Config. Template Line" WHERE (Data Template Code=FIELD(Code),
                                                                                                    Type=CONST(Template)));
                                                   CaptionML=[DAN=Bruges i hierarki;
                                                              ENU=Used In Hierarchy];
                                                   Editable=No }
    { 7   ;   ;Enabled             ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
    { 8   ;   ;Instance No. Series ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Forekomstnummerserie;
                                                              ENU=Instance No. Series] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Der findes skabelonlinjer, som er tilknyttet %1. Slet linjerne for at �ndre tabel-id''et.;ENU=Template lines that relate to %1 exists. Delete the lines to change the Table ID.';
      ConfigTemplateLine@1001 : Record 8619;
      Text001@1002 : TextConst '@@@="%2 = Table ID, %3 = Table Caption";DAN=En nye forekomst af %1 er oprettet i tabellen %2 %3.;ENU=A new instance %1 has been created in table %2 %3.';
      ConfigValidateMgt@1003 : Codeunit 8617;

    LOCAL PROCEDURE TestXRec@1();
    VAR
      ConfigTemplateLine@1000 : Record 8619;
    BEGIN
      ConfigTemplateLine.SETRANGE("Data Template Code",Code);
      IF ConfigTemplateLine.FINDFIRST THEN
        IF xRec."Table ID" <> "Table ID" THEN
          ERROR(Text000,xRec."Table ID");
    END;

    [External]
    PROCEDURE ConfirmNewInstance@2(VAR RecRef@1000 : RecordRef);
    VAR
      KeyRef@1004 : KeyRef;
      FieldRef@1003 : FieldRef;
      KeyFieldCount@1002 : Integer;
      MessageString@1001 : Text[1024];
    BEGIN
      KeyRef := RecRef.KEYINDEX(1);
      FOR KeyFieldCount := 1 TO KeyRef.FIELDCOUNT DO BEGIN
        FieldRef := KeyRef.FIELDINDEX(KeyFieldCount);
        MessageString := MessageString + ' ' + FORMAT(FieldRef.VALUE);
        MessageString := DELCHR(MessageString,'<');
        MESSAGE(STRSUBSTNO(Text001,MessageString,RecRef.NUMBER,RecRef.CAPTION));
      END;
    END;

    [External]
    PROCEDURE SetTemplateEnabled@3(IsEnabled@1000 : Boolean);
    BEGIN
      VALIDATE(Enabled,IsEnabled);
      MODIFY(TRUE);
    END;

    [External]
    PROCEDURE SetNoSeries@4(NoSeries@1000 : Code[20]);
    BEGIN
      VALIDATE("Instance No. Series",NoSeries);
      MODIFY(TRUE);
    END;

    BEGIN
    END.
  }
}

