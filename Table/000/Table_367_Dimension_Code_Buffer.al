OBJECT Table 367 Dimension Code Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dimensionskodebuffer;
               ENU=Dimension Code Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code] }
    { 2   ;   ;Name                ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Totaling            ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Samment�lling;
                                                              ENU=Totaling] }
    { 4   ;   ;Period Start        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodestart;
                                                              ENU=Period Start] }
    { 5   ;   ;Period End          ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodeslutning;
                                                              ENU=Period End] }
    { 6   ;   ;Visible             ;Boolean       ;InitValue=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Synlig;
                                                              ENU=Visible] }
    { 7   ;   ;Indentation         ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indrykning;
                                                              ENU=Indentation] }
    { 8   ;   ;Show in Bold        ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Vis med fed tekst;
                                                              ENU=Show in Bold] }
    { 9   ;   ;Amount              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Analysis View Entry".Amount WHERE (Analysis View Code=CONST(''),
                                                                                                       Dimension 1 Value Code=FIELD(Dimension 1 Value Filter),
                                                                                                       Dimension 2 Value Code=FIELD(Dimension 2 Value Filter),
                                                                                                       Dimension 3 Value Code=FIELD(Dimension 3 Value Filter),
                                                                                                       Dimension 4 Value Code=FIELD(Dimension 4 Value Filter)));
                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 10  ;   ;Dimension 1 Value Filter;Code20    ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Dimension 1-v�rdifilter;
                                                              ENU=Dimension 1 Value Filter] }
    { 11  ;   ;Dimension 2 Value Filter;Code20    ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Dimension 2-v�rdifilter;
                                                              ENU=Dimension 2 Value Filter] }
    { 12  ;   ;Dimension 3 Value Filter;Code20    ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Dimension 3-v�rdifilter;
                                                              ENU=Dimension 3 Value Filter] }
    { 13  ;   ;Dimension 4 Value Filter;Code20    ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Dimension 4-v�rdifilter;
                                                              ENU=Dimension 4 Value Filter] }
    { 7101;   ;Quantity            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Analysis View Entry".Amount WHERE (Analysis View Code=CONST(''),
                                                                                                       Dimension 1 Value Code=FIELD(Dimension 1 Value Filter),
                                                                                                       Dimension 2 Value Code=FIELD(Dimension 2 Value Filter),
                                                                                                       Dimension 3 Value Code=FIELD(Dimension 3 Value Filter),
                                                                                                       Dimension 4 Value Code=FIELD(Dimension 4 Value Filter)));
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
    {    ;Period Start                             }
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

