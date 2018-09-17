OBJECT Table 6305 Power BI Chart Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Power BI-diagrambuffer;
               ENU=Power BI Chart Buffer];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 20  ;   ;Row No.             ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Rëkkenr.;
                                                              ENU=Row No.] }
    { 30  ;   ;Value               ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Vërdi;
                                                              ENU=Value] }
    { 40  ;   ;Period Type         ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodetype;
                                                              ENU=Period Type];
                                                   OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr,Regnskabsperiode;
                                                                    ENU=Day,Week,Month,Quarter,Year,Accounting Period];
                                                   OptionString=Day,Week,Month,Quarter,Year,Accounting Period }
    { 50  ;   ;Date                ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato;
                                                              ENU=Date] }
    { 60  ;   ;Measure Name        ;Text120       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Navn pÜ mÜl;
                                                              ENU=Measure Name] }
    { 70  ;   ;Date Filter         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 80  ;   ;Date Sorting        ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Datosortering;
                                                              ENU=Date Sorting] }
    { 90  ;   ;Chart Type          ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Diagramtype;
                                                              ENU=Chart Type];
                                                   OptionCaptionML=[DAN=" ,Linje,Trinlinje,Kolonne,Stablet sõjlediagram";
                                                                    ENU=" ,Line,StepLine,Column,StackedColumn"];
                                                   OptionString=[ ,Line,StepLine,Column,StackedColumn] }
    { 100 ;   ;Measure No.         ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=MÜl nr.;
                                                              ENU=Measure No.] }
    { 110 ;   ;Period Type Sorting ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodetypesortering;
                                                              ENU=Period Type Sorting] }
    { 120 ;   ;Show Orders         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Vis ordrer;
                                                              ENU=Show Orders] }
    { 130 ;   ;Values to Calculate ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Vërdier til beregning;
                                                              ENU=Values to Calculate] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
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

