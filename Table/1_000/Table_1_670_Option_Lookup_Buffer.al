OBJECT Table 1670 Option Lookup Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer for indstillingsopslag;
               ENU=Option Lookup Buffer];
    LookupPageID=Page1670;
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID];
                                                   Editable=No }
    { 2   ;   ;Option Caption      ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indstillingstitel;
                                                              ENU=Option Caption];
                                                   Editable=No }
    { 3   ;   ;Lookup Type         ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Opslagstype;
                                                              ENU=Lookup Type];
                                                   OptionCaptionML=[DAN=Salg,K›b;
                                                                    ENU=Sales,Purchases];
                                                   OptionString=Sales,Purchases;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Option Caption                          ;Clustered=Yes }
    {    ;ID                                       }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      UnsupportedTypeErr@1001 : TextConst 'DAN=Ikke-underst›ttet opslagstype.;ENU=Unsupported Lookup Type.';
      InvalidTypeErr@1000 : TextConst '@@@="%1 = Type caption. Fx. Item";DAN=''%1'' er ikke en gyldig datatype for dette bilag.;ENU=''%1'' is not a valid type for this document.';

    PROCEDURE FillBuffer@1(LookupType@1007 : Option);
    VAR
      SalesLine@1000 : Record 37;
      PurchaseLine@1003 : Record 39;
    BEGIN
      CASE LookupType OF
        "Lookup Type"::Sales:
          FillBufferInternal(DATABASE::"Sales Line",SalesLine.FIELDNO(Type),SalesLine.FIELDNO("No."),LookupType);
        "Lookup Type"::Purchases:
          FillBufferInternal(DATABASE::"Purchase Line",PurchaseLine.FIELDNO(Type),PurchaseLine.FIELDNO("No."),LookupType);
        ELSE
          ERROR(UnsupportedTypeErr);
      END;
    END;

    PROCEDURE AutoCompleteOption@2(VAR Option@1000 : Text[30];LookupType@1001 : Option) : Boolean;
    VAR
      SalesLine@1002 : Record 37;
      PurchaseLine@1003 : Record 39;
    BEGIN
      Option := DELCHR(Option,'<>');
      IF Option = '' THEN
        CASE LookupType OF
          "Lookup Type"::Sales:
            Option := SalesLine.FormatType;
          "Lookup Type"::Purchases:
            Option := PurchaseLine.FormatType;
          ELSE
            EXIT(FALSE);
        END;

      SETRANGE("Option Caption");
      IF ISEMPTY THEN
        FillBuffer(LookupType);

      SETRANGE("Option Caption",Option);
      IF FINDFIRST THEN
        EXIT(TRUE);

      SETFILTER("Option Caption",'%1','@' + Option + '*');
      IF FINDFIRST THEN BEGIN
        Option := "Option Caption";
        EXIT(TRUE);
      END;

      SETFILTER("Option Caption",'%1','@*' + Option + '*');
      IF NOT FINDFIRST THEN
        EXIT(FALSE);

      Option := "Option Caption";
      EXIT(TRUE);
    END;

    PROCEDURE ValidateOption@4(Option@1000 : Text[30]);
    BEGIN
      SETRANGE("Option Caption",Option);
      IF ISEMPTY THEN
        ERROR(InvalidTypeErr,Option);

      SETRANGE("Option Caption");
    END;

    PROCEDURE FormatOption@17(FieldRef@1000 : FieldRef) : Text[30];
    VAR
      SalesLine@1001 : Record 37;
      PurchaseLine@1002 : Record 39;
      Option@1003 : Option;
    BEGIN
      Option := FieldRef.VALUE;
      CASE FieldRef.RECORD.NUMBER OF
        DATABASE::"Sales Line", DATABASE::"Standard Sales Line":
          IF Option = SalesLine.Type::" " THEN
            EXIT(SalesLine.FormatType);
        DATABASE::"Purchase Line", DATABASE::"Standard Purchase Line":
          IF Option = PurchaseLine.Type::" " THEN
            EXIT(PurchaseLine.FormatType);
      END;

      EXIT(FORMAT(FieldRef));
    END;

    LOCAL PROCEDURE CreateNew@6(OptionID@1000 : Integer;OptionText@1002 : Text[30];LookupType@1003 : Option);
    BEGIN
      INIT;
      ID := OptionID;
      "Option Caption" := OptionText;
      "Lookup Type" := LookupType;
      INSERT;
    END;

    LOCAL PROCEDURE FillBufferInternal@3(TableNo@1010 : Integer;FieldNo@1006 : Integer;RelationFieldNo@1007 : Integer;LookupType@1009 : Option);
    VAR
      TypeHelper@1005 : Codeunit 10;
      RecRef@1004 : RecordRef;
      RelatedRecRef@1003 : RecordRef;
      FieldRef@1002 : FieldRef;
      FieldRefRelation@1008 : FieldRef;
      OptionIndex@1001 : Integer;
      RelatedTableNo@1000 : Integer;
    BEGIN
      RecRef.OPEN(TableNo);
      FieldRef := RecRef.FIELD(FieldNo);
      FOR OptionIndex := 0 TO TypeHelper.GetNumberOfOptions(FieldRef.OPTIONSTRING) DO BEGIN
        FieldRef.VALUE(OptionIndex);
        IF IncludeOption(LookupType,OptionIndex) THEN BEGIN
          FieldRefRelation := RecRef.FIELD(RelationFieldNo);
          RelatedTableNo := FieldRefRelation.RELATION;
          IF RelatedTableNo = 0 THEN
            CreateNew(OptionIndex,FormatOption(FieldRef),LookupType)
          ELSE BEGIN
            RelatedRecRef.OPEN(RelatedTableNo);
            IF RelatedRecRef.READPERMISSION THEN
              CreateNew(OptionIndex,FormatOption(FieldRef),LookupType);
            RelatedRecRef.CLOSE;
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE IncludeOption@7(LookupType@1000 : Option;Option@1001 : Integer) : Boolean;
    VAR
      SalesLine@1002 : Record 37;
      PurchaseLine@1003 : Record 39;
      ApplicationAreaSetup@1004 : Record 9178;
    BEGIN
      CASE LookupType OF
        "Lookup Type"::Sales:
          CASE Option OF
            SalesLine.Type::" ",SalesLine.Type::"G/L Account",SalesLine.Type::Item:
              EXIT(TRUE);
            SalesLine.Type::"Charge (Item)":
              IF ApplicationAreaSetup.IsItemChargesEnabled THEN
                EXIT(TRUE);
          END;
        "Lookup Type"::Purchases:
          CASE Option OF
            PurchaseLine.Type::" ",PurchaseLine.Type::"G/L Account",PurchaseLine.Type::Item:
              EXIT(TRUE);
            PurchaseLine.Type::"Charge (Item)":
              IF ApplicationAreaSetup.IsItemChargesEnabled THEN
                EXIT(TRUE);
          END;
      END;
    END;

    BEGIN
    END.
  }
}

