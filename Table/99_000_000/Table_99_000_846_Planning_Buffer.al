OBJECT Table 99000846 Planning Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Planl‘gning - buffer;
               ENU=Planning Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Buffer No.          ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Buffernr.;
                                                              ENU=Buffer No.] }
    { 2   ;   ;Date                ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dato;
                                                              ENU=Date] }
    { 3   ;   ;Document Type       ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Rekvisitionslinje,Planlagt prod.ordrekomp.,Fastlagt prod.ordrekomp.,Frigivet prod.ordrekomp.,Planl‘gningskomp.,Salgsordre,Planlagt prod.ordre,Planl‘gningslinje,Indk›bskld.linje,Fastlagt prod.ordre,Frigivet prod.ordre,K›bsordre,Antal p† lager,Serviceordre,Overflytning,Jobordre,Montageordre,Montageordrelinje,Produktionsforecast-salg,Produktionsforecast-komponent;
                                                                    ENU=Requisition Line,Planned Prod. Order Comp.,Firm Planned Prod. Order Comp.,Released Prod. Order Comp.,Planning Comp.,Sales Order,Planned Prod. Order,Planning Line,Req. Worksheet Line,Firm Planned Prod. Order,Released Prod. Order,Purchase Order,Quantity at Inventory,Service Order,Transfer,Job Order,Assembly Order,Assembly Order Line,Production Forecast-Sales,Production Forecast-Component];
                                                   OptionString=Requisition Line,Planned Prod. Order Comp.,Firm Planned Prod. Order Comp.,Released Prod. Order Comp.,Planning Comp.,Sales Order,Planned Prod. Order,Planning Line,Req. Worksheet Line,Firm Planned Prod. Order,Released Prod. Order,Purchase Order,Quantity at Inventory,Service Order,Transfer,Job Order,Assembly Order,Assembly Order Line,Production Forecast-Sales,Production Forecast-Component }
    { 4   ;   ;Document No.        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 6   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 7   ;   ;Description         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 8   ;   ;Gross Requirement   ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bruttobehov;
                                                              ENU=Gross Requirement];
                                                   DecimalPlaces=0:5 }
    { 10  ;   ;Planned Receipts    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Planlagt tilgang;
                                                              ENU=Planned Receipts];
                                                   DecimalPlaces=0:5 }
    { 11  ;   ;Scheduled Receipts  ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Fastlagt tilgang;
                                                              ENU=Scheduled Receipts];
                                                   DecimalPlaces=0:5 }
  }
  KEYS
  {
    {    ;Buffer No.                              ;Clustered=Yes }
    {    ;Item No.,Date                            }
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

