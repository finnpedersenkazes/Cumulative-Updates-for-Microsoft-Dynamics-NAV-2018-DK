OBJECT Table 5531 Inventory Page Data
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagerbeholdningssidedata;
               ENU=Inventory Page Data];
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   Editable=No }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.];
                                                   Editable=No }
    { 3   ;   ;Period Type         ;Option        ;CaptionML=[DAN=Periodetype;
                                                              ENU=Period Type];
                                                   OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr;
                                                                    ENU=Day,Week,Month,Quarter,Year];
                                                   OptionString=Day,Week,Month,Quarter,Year;
                                                   Editable=No }
    { 4   ;   ;Period Start        ;Date          ;CaptionML=[DAN=Periodestart;
                                                              ENU=Period Start];
                                                   Editable=No }
    { 5   ;   ;Period End          ;Date          ;CaptionML=[DAN=Periodeslutning;
                                                              ENU=Period End];
                                                   Editable=No }
    { 6   ;   ;Period No.          ;Integer       ;CaptionML=[DAN=Periodenr.;
                                                              ENU=Period No.];
                                                   Editable=No }
    { 7   ;   ;Level               ;Integer       ;CaptionML=[DAN=Niveau;
                                                              ENU=Level];
                                                   Editable=No }
    { 9   ;   ;Source Line ID      ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildelinje-id;
                                                              ENU=Source Line ID];
                                                   Editable=No }
    { 10  ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.];
                                                   Editable=No }
    { 11  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code];
                                                   Editable=No }
    { 12  ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   Editable=No }
    { 13  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 14  ;   ;Availability Date   ;Date          ;CaptionML=[DAN=Disponibilitetsdato;
                                                              ENU=Availability Date];
                                                   Editable=No }
    { 15  ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Kõb,Salg,Kõbsreturvare,Salgsreturvare,Overfõrsel,Komponent,Produktion,Service,Sag,Forecast,Rammesalgsordre,Plan,Tilbagefõr plan,Montageordre,Montagekomponent";
                                                                    ENU=" ,Purchase,Sale,Purch. Return,Sales Return,Transfer,Component,Production,Service,Job,Forecast,Blanket Sales Order,Plan,Plan Revert,Assembly Order,Assembly Component"];
                                                   OptionString=[ ,Purchase,Sale,Purch. Return,Sales Return,Transfer,Component,Production,Service,Job,Forecast,Blanket Sales Order,Plan,Plan Revert,Assembly Order,Assembly Component];
                                                   Editable=No }
    { 16  ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.];
                                                   Editable=No }
    { 19  ;   ;Source              ;Text50        ;CaptionML=[DAN=Kilde;
                                                              ENU=Source];
                                                   Editable=No }
    { 20  ;   ;Remaining Quantity (Base);Decimal  ;CaptionML=[DAN=Restantal (basis);
                                                              ENU=Remaining Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 21  ;   ;Positive            ;Boolean       ;CaptionML=[DAN=Positiv;
                                                              ENU=Positive];
                                                   Editable=No }
    { 22  ;   ;Gross Requirement   ;Decimal       ;CaptionML=[DAN=Bruttobehov;
                                                              ENU=Gross Requirement];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 23  ;   ;Scheduled Receipt   ;Decimal       ;CaptionML=[DAN=Fastlagt tilgang;
                                                              ENU=Scheduled Receipt];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 24  ;   ;Forecast            ;Decimal       ;CaptionML=[DAN=Forecast;
                                                              ENU=Forecast];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 25  ;   ;Remaining Forecast  ;Decimal       ;CaptionML=[DAN=Restforecast;
                                                              ENU=Remaining Forecast];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 26  ;   ;Action Message Qty. ;Decimal       ;CaptionML=[DAN=Aktionsmeddelelsesantal;
                                                              ENU=Action Message Qty.];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 29  ;   ;Action Message      ;Option        ;CaptionML=[DAN=Aktionsmeddelelse;
                                                              ENU=Action Message];
                                                   OptionCaptionML=[DAN=" ,Ny,Ret antal,Omplanlëg,Omplanlëg & ret antal,Annuller";
                                                                    ENU=" ,New,Change Qty.,Reschedule,Resched. & Chg. Qty.,Cancel"];
                                                   OptionString=[ ,New,Change Qty.,Reschedule,Resched. & Chg. Qty.,Cancel];
                                                   Editable=No }
    { 30  ;   ;Source Document ID  ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildebilags-id;
                                                              ENU=Source Document ID];
                                                   Editable=No }
    { 31  ;   ;Attached to Line No.;Integer       ;CaptionML=[DAN=Tilknyttet linjenr.;
                                                              ENU=Attached to Line No.];
                                                   Editable=No }
    { 34  ;   ;Ref. Order No.      ;Code20        ;CaptionML=[DAN=Referenceordrenr.;
                                                              ENU=Ref. Order No.];
                                                   Editable=No }
    { 36  ;   ;Projected Inventory ;Decimal       ;CaptionML=[DAN=Planlagt beholdning;
                                                              ENU=Projected Inventory];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 37  ;   ;Forecasted Projected Inventory;Decimal;
                                                   CaptionML=[DAN=Prognosticeret planlagt beholdning;
                                                              ENU=Forecasted Projected Inventory];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 38  ;   ;Suggested Projected Inventory;Decimal;
                                                   CaptionML=[DAN=ForeslÜet planlagt beholdning;
                                                              ENU=Suggested Projected Inventory];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 39  ;   ;Reserved Requirement;Decimal       ;CaptionML=[DAN=Reserveret behov;
                                                              ENU=Reserved Requirement];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 40  ;   ;Reserved Receipt    ;Decimal       ;CaptionML=[DAN=Reserveret modtagelse;
                                                              ENU=Reserved Receipt];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Line No.                                 }
    {    ;Code,Line No.                           ;Clustered=Yes }
    {    ;Period Start,Line No.                    }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE UpdateInventorys@1(VAR RunningInventory@1000 : Decimal;VAR RunningInventoryForecast@1003 : Decimal;VAR RunningInventorySuggestion@1004 : Decimal);
    BEGIN
      "Projected Inventory" :=
        RunningInventory +
        ("Gross Requirement" - "Reserved Requirement") + ("Scheduled Receipt" - "Reserved Receipt");
      "Forecasted Projected Inventory" :=
        RunningInventoryForecast + "Remaining Forecast" +
        ("Gross Requirement" - "Reserved Requirement") + ("Scheduled Receipt" - "Reserved Receipt");
      "Suggested Projected Inventory" :=
        RunningInventorySuggestion + "Action Message Qty." + "Remaining Forecast" +
        ("Gross Requirement" - "Reserved Requirement") + ("Scheduled Receipt" - "Reserved Receipt");
      IF Level = 1 THEN BEGIN
        RunningInventory := "Projected Inventory";
        RunningInventoryForecast := "Forecasted Projected Inventory";
        RunningInventorySuggestion := "Suggested Projected Inventory"
      END;
    END;

    BEGIN
    END.
  }
}

