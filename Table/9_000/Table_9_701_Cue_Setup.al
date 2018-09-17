OBJECT Table 9701 Cue Setup
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ops‘tning af k›indikator;
               ENU=Cue Setup];
  }
  FIELDS
  {
    { 1   ;   ;User Name           ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User Name");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Brugernavn;
                                                              ENU=User Name] }
    { 2   ;   ;Table ID            ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table),
                                                                                                      Object Name=FILTER(*Cue));
                                                   OnValidate=BEGIN
                                                                // Force a calculation, even if the FieldNo hasn't yet been filled out (i.e. the record hasn't been inserted yet)
                                                                CALCFIELDS("Table Name")
                                                              END;

                                                   CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 3   ;   ;Field No.           ;Integer       ;TableRelation=Field.No.;
                                                   OnLookup=VAR
                                                              Field@1001 : Record 2000000041;
                                                              FieldsLookup@1000 : Page 9806;
                                                              Filter@1002 : Text[250];
                                                            BEGIN
                                                              // Look up in the Fields virtual table
                                                              // Filter on Table No=Table No and Type=Decimal|Integer. This should give us approximately the
                                                              // fields that are "valid" for a cue control.
                                                              Field.SETRANGE(TableNo,"Table ID");
                                                              Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
                                                              Filter := FORMAT(Field.Type::Decimal) + '|' + FORMAT(Field.Type::Integer);
                                                              Field.SETFILTER(Type,Filter);
                                                              FieldsLookup.SETTABLEVIEW(Field);
                                                              FieldsLookup.LOOKUPMODE(TRUE);
                                                              IF FieldsLookup.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                                                FieldsLookup.GETRECORD(Field);
                                                                "Field No." := Field."No.";
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=K›indikator-id;
                                                              ENU=Cue ID] }
    { 4   ;   ;Field Name          ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table ID),
                                                                                                   No.=FIELD(Field No.)));
                                                   CaptionML=[DAN=K›indikatornavn;
                                                              ENU=Cue Name] }
    { 5   ;   ;Low Range Style     ;Option        ;CaptionML=[@@@=The Style to use if the cue's value is below Threshold 1;
                                                              DAN=Typen Lavt interval;
                                                              ENU=Low Range Style];
                                                   OptionCaptionML=[DAN=Ingen,,,,,,,Favorabel,Ikke-favorabel,Tvetydig,Underordnet;
                                                                    ENU=None,,,,,,,Favorable,Unfavorable,Ambiguous,Subordinate];
                                                   OptionString=None,,,,,,,Favorable,Unfavorable,Ambiguous,Subordinate }
    { 6   ;   ;Threshold 1         ;Decimal       ;OnValidate=BEGIN
                                                                ValidateThresholds;
                                                              END;

                                                   CaptionML=[DAN=Gr‘nse 1;
                                                              ENU=Threshold 1] }
    { 7   ;   ;Middle Range Style  ;Option        ;CaptionML=[@@@=The Style to use if the cue's value is between Threshold 1 and Threshold 2;
                                                              DAN=Typen Mellem interval;
                                                              ENU=Middle Range Style];
                                                   OptionCaptionML=[DAN=Ingen,,,,,,,Favorabel,Ikke-favorabel,Tvetydig,Underordnet;
                                                                    ENU=None,,,,,,,Favorable,Unfavorable,Ambiguous,Subordinate];
                                                   OptionString=None,,,,,,,Favorable,Unfavorable,Ambiguous,Subordinate }
    { 8   ;   ;Threshold 2         ;Decimal       ;OnValidate=BEGIN
                                                                ValidateThresholds;
                                                              END;

                                                   CaptionML=[DAN=Gr‘nse 2;
                                                              ENU=Threshold 2] }
    { 9   ;   ;High Range Style    ;Option        ;CaptionML=[@@@=The Style to use if the cue's value is above Threshold 2;
                                                              DAN=Typen H›jt interval;
                                                              ENU=High Range Style];
                                                   OptionCaptionML=[DAN=Ingen,,,,,,,Favorabel,Ikke-favorabel,Tvetydig,Underordnet;
                                                                    ENU=None,,,,,,,Favorable,Unfavorable,Ambiguous,Subordinate];
                                                   OptionString=None,,,,,,,Favorable,Unfavorable,Ambiguous,Subordinate }
    { 10  ;   ;Table Name          ;Text249       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object ID=FIELD(Table ID),
                                                                                                                Object Type=CONST(Table)));
                                                   CaptionML=[DAN=Tabelnavn;
                                                              ENU=Table Name] }
    { 11  ;   ;Personalized        ;Boolean       ;CaptionML=[DAN=Tilpasset;
                                                              ENU=Personalized] }
  }
  KEYS
  {
    {    ;User Name,Table ID,Field No.            ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Table Name,Field Name,Threshold 1,Personalized,Threshold 2 }
  }
  CODE
  {
    VAR
      TextErr001@1000 : TextConst 'DAN=%1 skal v‘re st›rre end %2.;ENU=%1 must be greater than %2.';

    [External]
    PROCEDURE ConvertStyleToStyleText@6(Style@1005 : Option) : Text;
    VAR
      RecordRef@1000 : RecordRef;
      FieldRef@1001 : FieldRef;
      StyleIndex@1002 : Integer;
    BEGIN
      RecordRef.GETTABLE(Rec);
      FieldRef := RecordRef.FIELD(FIELDNO("Low Range Style"));

      // Default to return the None Style
      StyleIndex := 1;

      // The style must be in the range of existing style options
      IF (Style > 0) AND (Style <= 10) THEN
        StyleIndex := Style + 1;

      EXIT(SELECTSTR(StyleIndex,FieldRef.OPTIONSTRING));
    END;

    [External]
    PROCEDURE GetStyleForValue@1(CueValue@1000 : Decimal) : Integer;
    BEGIN
      IF CueValue < "Threshold 1" THEN
        EXIT("Low Range Style");
      IF CueValue > "Threshold 2" THEN
        EXIT("High Range Style");
      EXIT("Middle Range Style");
    END;

    LOCAL PROCEDURE ValidateThresholds@2();
    BEGIN
      IF "Threshold 2" <= "Threshold 1" THEN
        ERROR(
          TextErr001,
          FIELDCAPTION("Threshold 2"),
          FIELDCAPTION("Threshold 1"));
    END;

    BEGIN
    END.
  }
}

