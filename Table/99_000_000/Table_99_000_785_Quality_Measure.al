OBJECT Table 99000785 Quality Measure
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    OnDelete=VAR
               RoutingQualityMeasure@1000 : Record 99000805;
               ProdOrderRtngQltyMeas@1001 : Record 5413;
             BEGIN
               ProdOrderRtngQltyMeas.SETRANGE("Qlty Measure Code",Code);
               IF NOT ProdOrderRtngQltyMeas.ISEMPTY THEN
                 ERROR(CannotDeleteRecProdOrderErr);

               RoutingQualityMeasure.SETRANGE("Qlty Measure Code",Code);
               IF NOT RoutingQualityMeasure.ISEMPTY THEN
                 ERROR(CannotDeleteRecActRoutingErr);
             END;

    CaptionML=[DAN=Kvalitetsm†l;
               ENU=Quality Measure];
    LookupPageID=Page99000806;
    DrillDownPageID=Page99000806;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CannotDeleteRecProdOrderErr@1000 : TextConst 'DAN=Du kan ikke slette kvalitetsm†let, fordi det bruges til en eller flere aktive produktionsordrer.;ENU=You cannot delete the Quality Measure because it is being used on one or more active Production Orders.';
      CannotDeleteRecActRoutingErr@1001 : TextConst 'DAN=Du kan ikke slette kvalitetsm†let, fordi det bruges til en eller flere aktive ruter.;ENU=You cannot delete the Quality Measure because it is being used on one or more active Routings.';

    BEGIN
    END.
  }
}

