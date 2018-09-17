OBJECT Table 6521 Item Tracing History Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Historikbuffer for varesporing;
               ENU=Item Tracing History Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Level               ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Niveau;
                                                              ENU=Level] }
    { 10  ;   ;Serial No. Filter   ;Code250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Serienr.filter;
                                                              ENU=Serial No. Filter] }
    { 11  ;   ;Lot No. Filter      ;Code250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lotnr.filter;
                                                              ENU=Lot No. Filter] }
    { 12  ;   ;Item No. Filter     ;Code250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varenummerfilter;
                                                              ENU=Item No. Filter] }
    { 13  ;   ;Variant Filter      ;Code250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantfilter;
                                                              ENU=Variant Filter] }
    { 14  ;   ;Trace Method        ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sporingsmetode;
                                                              ENU=Trace Method];
                                                   OptionCaptionML=[DAN=Oprindelse->Brug,Brug->Oprindelse;
                                                                    ENU=Origin->Usage,Usage->Origin];
                                                   OptionString=Origin->Usage,Usage->Origin }
    { 15  ;   ;Show Components     ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Vis komponenter;
                                                              ENU=Show Components];
                                                   OptionCaptionML=[DAN=Nej,Kun varesporing,Alle;
                                                                    ENU=No,Item-tracked only,All];
                                                   OptionString=No,Item-tracked only,All }
  }
  KEYS
  {
    {    ;Entry No.,Level                         ;Clustered=Yes }
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

