OBJECT Table 99000854 Inventory Profile Track Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sporingsbuffer for lagerprofil;
               ENU=Inventory Profile Track Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 2   ;   ;Priority            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Prioritet;
                                                              ENU=Priority] }
    { 3   ;   ;Demand Line No.     ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Behovslinjenr.;
                                                              ENU=Demand Line No.] }
    { 4   ;   ;Sequence No.        ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=R‘kkef›lgenr.;
                                                              ENU=Sequence No.] }
    { 21  ;   ;Source Type         ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type] }
    { 23  ;   ;Source ID           ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kilde-id;
                                                              ENU=Source ID] }
    { 72  ;   ;Quantity Tracked    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Antal sporet;
                                                              ENU=Quantity Tracked] }
    { 73  ;   ;Surplus Type        ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Overskudstype;
                                                              ENU=Surplus Type];
                                                   OptionCaptionML=[DAN=Ingen,Forecast,Rammeordre,Sikkerhedslager,Genbestillingspunkt,Maksimallager,Fast ordreantal,Maksimumsordre,Minimumsordre,Bestil flere,Aktionsgr‘nseantal,Planl‘gningsfleksibilitet,Ikke-defineret,Akutordre;
                                                                    ENU=None,Forecast,BlanketOrder,SafetyStock,ReorderPoint,MaxInventory,FixedOrderQty,MaxOrder,MinOrder,OrderMultiple,DampenerQty,PlanningFlexibility,Undefined,EmergencyOrder];
                                                   OptionString=None,Forecast,BlanketOrder,SafetyStock,ReorderPoint,MaxInventory,FixedOrderQty,MaxOrder,MinOrder,OrderMultiple,DampenerQty,PlanningFlexibility,Undefined,EmergencyOrder }
    { 75  ;   ;Warning Level       ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Advarselsniveau;
                                                              ENU=Warning Level];
                                                   OptionCaptionML=[DAN=,N›dsituation,Undtagelse,Opm‘rksomhed;
                                                                    ENU=,Emergency,Exception,Attention];
                                                   OptionString=,Emergency,Exception,Attention }
  }
  KEYS
  {
    {    ;Line No.,Priority,Demand Line No.,Sequence No.;
                                                   SumIndexFields=Quantity Tracked;
                                                   MaintainSIFTIndex=No;
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

