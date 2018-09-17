OBJECT Table 5310 Outlook Synch. Setup Detail
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               CheckOSynchEntity;
               SetTableNo;
             END;

    OnModify=BEGIN
               CheckOSynchEntity;
               SetTableNo;
             END;

    CaptionML=[DAN=Konfigurationsdetaljer for Outlook-synkronisering;
               ENU=Outlook Synch. Setup Detail];
    LookupPageID=Page5310;
    DrillDownPageID=Page5310;
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation="Outlook Synch. User Setup"."User ID";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 2   ;   ;Synch. Entity Code  ;Code10        ;TableRelation="Outlook Synch. Entity Element"."Synch. Entity Code";
                                                   CaptionML=[DAN=Synkroniseringsenhedskode;
                                                              ENU=Synch. Entity Code];
                                                   Editable=No }
    { 3   ;   ;Element No.         ;Integer       ;TableRelation="Outlook Synch. Entity Element"."Element No.";
                                                   OnValidate=BEGIN
                                                                CALCFIELDS("Outlook Collection");
                                                              END;

                                                   CaptionML=[DAN=Elementnr.;
                                                              ENU=Element No.];
                                                   Editable=No }
    { 4   ;   ;Outlook Collection  ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Outlook Synch. Entity Element"."Outlook Collection" WHERE (Synch. Entity Code=FIELD(Synch. Entity Code),
                                                                                                                                  Element No.=FIELD(Element No.)));
                                                   OnLookup=VAR
                                                              ElementNo@1000 : Integer;
                                                            BEGIN
                                                              ElementNo := OSynchSetupMgt.ShowOEntityCollections("User ID","Synch. Entity Code");

                                                              IF (ElementNo <> 0) AND ("Element No." <> ElementNo) THEN
                                                                VALIDATE("Element No.",ElementNo);
                                                            END;

                                                   CaptionML=[DAN=Outlook-samling;
                                                              ENU=Outlook Collection];
                                                   Editable=No }
    { 5   ;   ;Table No.           ;Integer       ;CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.] }
  }
  KEYS
  {
    {    ;User ID,Synch. Entity Code,Element No.  ;Clustered=Yes }
    {    ;Table No.                                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      OSynchSetupMgt@1000 : Codeunit 5300;
      Text001@1001 : TextConst 'DAN=Denne samling kan ikke synkroniseres, fordi relationen mellem denne samling og den afh�ngige enhed %1 ikke er angivet.;ENU=This collection cannot be synchronized because the relation between this collection and the dependent entity %1 was not defined.';

    [External]
    PROCEDURE CheckOSynchEntity@3();
    VAR
      OSynchEntityElement@1000 : Record 5301;
      OSynchDependency@1001 : Record 5311;
    BEGIN
      OSynchEntityElement.GET("Synch. Entity Code","Element No.");
      OSynchEntityElement.TESTFIELD("Table No.");
      OSynchEntityElement.TESTFIELD("Outlook Collection");
      OSynchEntityElement.TESTFIELD("Table Relation");

      OSynchEntityElement.CALCFIELDS("No. of Dependencies");
      IF OSynchEntityElement."No. of Dependencies" = 0 THEN
        EXIT;

      OSynchDependency.RESET;
      OSynchDependency.SETRANGE("Synch. Entity Code",OSynchEntityElement."Synch. Entity Code");
      OSynchDependency.SETRANGE("Element No.",OSynchEntityElement."Element No.");
      IF OSynchDependency.FIND('-') THEN
        REPEAT
          IF OSynchDependency."Table Relation" = '' THEN
            ERROR(Text001,OSynchDependency."Depend. Synch. Entity Code");
        UNTIL OSynchDependency.NEXT = 0;
    END;

    [External]
    PROCEDURE SetTableNo@2();
    VAR
      OSynchEntityElement@1000 : Record 5301;
    BEGIN
      OSynchEntityElement.GET("Synch. Entity Code","Element No.");
      "Table No." := OSynchEntityElement."Table No.";
    END;

    BEGIN
    END.
  }
}

