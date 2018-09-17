OBJECT Table 1102 Cost Journal Batch
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnInsert=VAR
               CostJnlTemplate@1000 : Record 1100;
             BEGIN
               LOCKTABLE;
               TESTFIELD(Name);
               CostJnlTemplate.GET("Journal Template Name");
             END;

    OnDelete=VAR
               CostJnlLine@1000 : Record 1101;
             BEGIN
               CostJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
               CostJnlLine.SETRANGE("Journal Batch Name",Name);
               CostJnlLine.DELETEALL;
             END;

    CaptionML=[DAN=Omkostningskladdenavn;
               ENU=Cost Journal Batch];
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code10       ;TableRelation="Cost Journal Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name];
                                                   NotBlank=No }
    { 2   ;   ;Name                ;Code10        ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 9   ;   ;Bal. Cost Type No.  ;Code20        ;TableRelation="Cost Type";
                                                   OnValidate=BEGIN
                                                                IF CostType.GET("Bal. Cost Type No.") THEN BEGIN
                                                                  CostType.TESTFIELD(Blocked,FALSE);
                                                                  CostType.TESTFIELD(Type,CostType.Type::"Cost Type");
                                                                  "Bal. Cost Center Code" := CostType."Cost Center Code";
                                                                  "Bal. Cost Object Code" := CostType."Cost Object Code";
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Bal.omk.typenr.;
                                                              ENU=Bal. Cost Type No.] }
    { 10  ;   ;Bal. Cost Center Code;Code20       ;TableRelation="Cost Center";
                                                   CaptionML=[DAN=Bal.omk.stedskode;
                                                              ENU=Bal. Cost Center Code] }
    { 11  ;   ;Bal. Cost Object Code;Code20       ;TableRelation="Cost Object";
                                                   CaptionML=[DAN=Bal.omk.emnekode;
                                                              ENU=Bal. Cost Object Code] }
    { 12  ;   ;Delete after Posting;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Slet efter bogfõring;
                                                              ENU=Delete after Posting] }
  }
  KEYS
  {
    {    ;Journal Template Name,Name              ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CostType@1000 : Record 1103;

    BEGIN
    END.
  }
}

