OBJECT Table 1018 Job WIP Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=VIA-buffer for sag;
               ENU=Job WIP Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Posting Group       ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsgruppe;
                                                              ENU=Posting Group] }
    { 2   ;   ;Type                ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Udlignede omkostninger,Udlignet salg,Realiserede omkostninger,Realiseret salg,Periodiserede omkostninger,Periodiseret salg;
                                                                    ENU=Applied Costs,Applied Sales,Recognized Costs,Recognized Sales,Accrued Costs,Accrued Sales];
                                                   OptionString=Applied Costs,Applied Sales,Recognized Costs,Recognized Sales,Accrued Costs,Accrued Sales }
    { 3   ;   ;WIP Entry Amount    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›rt VIA-bel›b;
                                                              ENU=WIP Entry Amount] }
    { 4   ;   ;G/L Account No.     ;Code20        ;TableRelation="G/L Account";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Finanskontonr.;
                                                              ENU=G/L Account No.] }
    { 5   ;   ;Bal. G/L Account No.;Code20        ;TableRelation="G/L Account";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Saldokontonr.;
                                                              ENU=Bal. G/L Account No.] }
    { 6   ;   ;WIP Method          ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=VIA-metode;
                                                              ENU=WIP Method];
                                                   Editable=No }
    { 7   ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 8   ;   ;Job Complete        ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sagen er afsluttet;
                                                              ENU=Job Complete] }
    { 9   ;   ;Job WIP Total Entry No.;Integer    ;TableRelation="Job WIP Total";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benr. for sags-VIA-total;
                                                              ENU=Job WIP Total Entry No.] }
    { 22  ;   ;Reverse             ;Boolean       ;InitValue=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Tilbagef›r;
                                                              ENU=Reverse] }
    { 23  ;   ;WIP Posting Method Used;Option     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Anvendt VIA-bogf›ringsmetode;
                                                              ENU=WIP Posting Method Used];
                                                   OptionCaptionML=[DAN=Pr. sag,Pr. sagspost;
                                                                    ENU=Per Job,Per Job Ledger Entry];
                                                   OptionString=Per Job,Per Job Ledger Entry }
    { 71  ;   ;Dim Combination ID  ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dim kombination ID;
                                                              ENU=Dim Combination ID] }
  }
  KEYS
  {
    {    ;Job No.,Job WIP Total Entry No.,Type,Posting Group,Dim Combination ID,Reverse,G/L Account No.;
                                                   Clustered=Yes }
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

