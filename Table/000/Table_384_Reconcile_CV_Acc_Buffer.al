OBJECT Table 384 Reconcile CV Acc Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Afstem kunde/lev.kontobuffer;
               ENU=Reconcile CV Acc Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Table ID            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 2   ;   ;Currency code       ;Code10        ;TableRelation=Currency;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency code] }
    { 3   ;   ;Posting Group       ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsgruppe;
                                                              ENU=Posting Group] }
    { 6   ;   ;Field No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 7   ;   ;G/L Account No.     ;Code20        ;TableRelation="G/L Account";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Finanskontonr.;
                                                              ENU=G/L Account No.] }
  }
  KEYS
  {
    {    ;Table ID,Currency code,Posting Group,Field No.;
                                                   Clustered=Yes }
    {    ;G/L Account No.                          }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

