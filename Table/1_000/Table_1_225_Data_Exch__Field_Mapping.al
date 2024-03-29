OBJECT Table 1225 Data Exch. Field Mapping
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               TESTFIELD("Column No.");

               IF IsValidToUseMultiplier AND (Multiplier = 0) THEN
                 VALIDATE(Multiplier,1);
             END;

    OnModify=BEGIN
               IF IsValidToUseMultiplier AND (Multiplier = 0) THEN
                 VALIDATE(Multiplier,1);
             END;

    CaptionML=[DAN=Kobling af feltet Dataudveksling;
               ENU=Data Exch. Field Mapping];
  }
  FIELDS
  {
    { 1   ;   ;Data Exch. Def Code ;Code20        ;TableRelation="Data Exch. Def".Code;
                                                   CaptionML=[DAN=Dataudvekslingsdefinitionskode;
                                                              ENU=Data Exch. Def Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Table ID            ;Integer       ;TableRelation="Data Exch. Mapping"."Table ID";
                                                   CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID];
                                                   NotBlank=Yes }
    { 3   ;   ;Column No.          ;Integer       ;TableRelation="Data Exch. Column Def"."Column No." WHERE (Data Exch. Def Code=FIELD(Data Exch. Def Code),
                                                                                                             Data Exch. Line Def Code=FIELD(Data Exch. Line Def Code));
                                                   CaptionML=[DAN=Kolonnenr.;
                                                              ENU=Column No.];
                                                   NotBlank=Yes }
    { 4   ;   ;Field ID            ;Integer       ;TableRelation=Field.No. WHERE (TableNo=FIELD(Table ID));
                                                   CaptionML=[DAN=Felt-id;
                                                              ENU=Field ID] }
    { 5   ;   ;Optional            ;Boolean       ;CaptionML=[DAN=Valgfri;
                                                              ENU=Optional] }
    { 6   ;   ;Use Default Value   ;Boolean       ;OnValidate=BEGIN
                                                                IF NOT "Use Default Value" THEN
                                                                  "Default Value" := '';
                                                              END;

                                                   CaptionML=[DAN=Brug standardv�rdi;
                                                              ENU=Use Default Value] }
    { 7   ;   ;Default Value       ;Text250       ;OnValidate=BEGIN
                                                                VALIDATE("Use Default Value",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Standardv�rdi;
                                                              ENU=Default Value] }
    { 8   ;   ;Data Exch. Line Def Code;Code20    ;TableRelation="Data Exch. Line Def".Code WHERE (Data Exch. Def Code=FIELD(Data Exch. Def Code));
                                                   CaptionML=[DAN=Definitionskode for dataudvekslingslinje;
                                                              ENU=Data Exch. Line Def Code];
                                                   NotBlank=Yes }
    { 9   ;   ;Multiplier          ;Decimal       ;InitValue=1;
                                                   OnValidate=BEGIN
                                                                IF IsValidToUseMultiplier AND (Multiplier = 0) THEN
                                                                  ERROR(ZeroNotAllowedErr);
                                                              END;

                                                   CaptionML=[DAN=Multiplikator;
                                                              ENU=Multiplier] }
    { 10  ;   ;Target Table ID     ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table));
                                                   CaptionML=[DAN=M�ltabel-id;
                                                              ENU=Target Table ID] }
    { 11  ;   ;Target Field ID     ;Integer       ;TableRelation=Field.No. WHERE (TableNo=FIELD(Target Table ID));
                                                   OnLookup=VAR
                                                              Field@1001 : Record 2000000041;
                                                              FieldsLookup@1000 : Page 9806;
                                                            BEGIN
                                                              Field.SETRANGE(TableNo,"Target Table ID");
                                                              Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
                                                              FieldsLookup.SETTABLEVIEW(Field);
                                                              FieldsLookup.LOOKUPMODE(TRUE);
                                                              IF FieldsLookup.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                                                FieldsLookup.GETRECORD(Field);
                                                                VALIDATE("Target Field ID",Field."No.");
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=M�lfelt-id;
                                                              ENU=Target Field ID] }
    { 12  ;   ;Target Table Caption;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Table Metadata".Caption WHERE (ID=FIELD(Target Table ID)));
                                                   CaptionML=[DAN=Titel p� m�ltabel;
                                                              ENU=Target Table Caption] }
    { 13  ;   ;Target Field Caption;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Target Table ID),
                                                                                                   No.=FIELD(Target Field ID)));
                                                   CaptionML=[DAN=Titel p� m�lfelt;
                                                              ENU=Target Field Caption] }
    { 20  ;   ;Transformation Rule ;Code20        ;TableRelation="Transformation Rule";
                                                   CaptionML=[DAN=Transformationsregel;
                                                              ENU=Transformation Rule] }
    { 21  ;   ;Overwrite Value     ;Boolean       ;CaptionML=[DAN=Overskriv v�rdi;
                                                              ENU=Overwrite Value] }
  }
  KEYS
  {
    {    ;Data Exch. Def Code,Data Exch. Line Def Code,Table ID,Column No.,Field ID;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ZeroNotAllowedErr@1000 : TextConst 'DAN=Alle numeriske v�rdier er tilladt bortset fra nul.;ENU=All numeric values are allowed except zero.';

    [External]
    PROCEDURE InsertRec@1(DataExchDefCode@1003 : Code[20];DataExchLineDefCode@1005 : Code[20];TableId@1000 : Integer;ColumnNo@1001 : Integer;FieldId@1002 : Integer;NewOptional@1004 : Boolean;NewMultiplier@1006 : Decimal);
    BEGIN
      INIT;
      VALIDATE("Data Exch. Def Code",DataExchDefCode);
      VALIDATE("Data Exch. Line Def Code",DataExchLineDefCode);
      "Table ID" := TableId;
      "Column No." := ColumnNo;
      "Field ID" := FieldId;
      VALIDATE(Optional,NewOptional);
      VALIDATE(Multiplier,NewMultiplier);
      INSERT;
    END;

    [External]
    PROCEDURE FillSourceRecord@2(Field@1000 : Record 2000000041);
    BEGIN
      SETRANGE("Field ID");
      INIT;

      "Table ID" := Field.TableNo;
      "Field ID" := Field."No.";
    END;

    [External]
    PROCEDURE GetColumnCaption@7() : Text;
    VAR
      DataExchColDef@1000 : Record 1223;
    BEGIN
      DataExchColDef.SETRANGE("Data Exch. Def Code","Data Exch. Def Code");
      DataExchColDef.SETRANGE("Data Exch. Line Def Code","Data Exch. Line Def Code");
      DataExchColDef.SETRANGE("Column No.","Column No.");
      IF DataExchColDef.FINDFIRST THEN
        EXIT(DataExchColDef.Name);
      EXIT('');
    END;

    [Internal]
    PROCEDURE GetFieldCaption@12() : Text;
    VAR
      recRef@1000 : RecordRef;
      fieldRef@1001 : FieldRef;
    BEGIN
      recRef.OPEN("Table ID");
      fieldRef := recRef.FIELD("Field ID");
      EXIT(fieldRef.CAPTION);
    END;

    LOCAL PROCEDURE IsValidToUseMultiplier@8() : Boolean;
    VAR
      DataExchDef@1000 : Record 1222;
      DataExchColumnDef@1001 : Record 1223;
    BEGIN
      DataExchDef.GET("Data Exch. Def Code");
      IF DataExchColumnDef.GET("Data Exch. Def Code","Data Exch. Line Def Code","Column No.") THEN
        EXIT(DataExchColumnDef."Data Type" = DataExchColumnDef."Data Type"::Decimal);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE GetPath@3() : Text;
    VAR
      DataExchColDef@1000 : Record 1223;
    BEGIN
      DataExchColDef.SETRANGE("Data Exch. Def Code","Data Exch. Def Code");
      DataExchColDef.SETRANGE("Data Exch. Line Def Code","Data Exch. Line Def Code");
      DataExchColDef.SETRANGE("Column No.","Column No.");
      IF DataExchColDef.FINDFIRST THEN
        EXIT(DataExchColDef.Path);
      EXIT('');
    END;

    BEGIN
    END.
  }
}

