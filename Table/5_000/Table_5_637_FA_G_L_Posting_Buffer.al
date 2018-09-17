OBJECT Table 5637 FA G/L Posting Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anl-finansbogf.buffer;
               ENU=FA G/L Posting Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Account No.         ;Code20        ;TableRelation="G/L Account";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 3   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 4   ;   ;Correction          ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Rettelse;
                                                              ENU=Correction] }
    { 5   ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 6   ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 7   ;   ;FA Entry Type       ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Anl‘gstype;
                                                              ENU=FA Entry Type];
                                                   OptionCaptionML=[DAN=" ,Anl‘g,Reparation";
                                                                    ENU=" ,Fixed Asset,Maintenance"];
                                                   OptionString=[ ,Fixed Asset,Maintenance] }
    { 8   ;   ;FA Entry No.        ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Anl‘gsl›benr.;
                                                              ENU=FA Entry No.] }
    { 9   ;   ;Automatic Entry     ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Automatisk postering;
                                                              ENU=Automatic Entry] }
    { 10  ;   ;FA Posting Group    ;Code20        ;TableRelation="FA Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Anl‘gsbogf›ringsgruppe;
                                                              ENU=FA Posting Group] }
    { 11  ;   ;FA Allocation Type  ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Anl‘gsfordelingstype;
                                                              ENU=FA Allocation Type];
                                                   OptionCaptionML=[DAN=Anskaffelse,Afskrivning,Nedskrivning,Opskrivning,Bruger 1,Bruger 2,Salg,Reparation,Gevinst,Tab,Bogf›rt v‘rdi (afgang);
                                                                    ENU=Acquisition,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance,Gain,Loss,Book Value];
                                                   OptionString=Acquisition,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance,Gain,Loss,Book Value }
    { 12  ;   ;FA Allocation Line No.;Integer     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Anl‘gsfordelingslinjenr.;
                                                              ENU=FA Allocation Line No.] }
    { 15  ;   ;Original General Journal Line;Boolean;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Oprindelig finanskladdelinje;
                                                              ENU=Original General Journal Line] }
    { 16  ;   ;Net Disposal        ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nettosalg;
                                                              ENU=Net Disposal] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
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

