OBJECT Table 9152 My Item
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Min vare;
               ENU=My Item];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   OnValidate=BEGIN
                                                                SetItemFields;
                                                              END;

                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.];
                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 4   ;   ;Unit Price          ;Decimal       ;CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   Editable=No }
    { 5   ;   ;Inventory           ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(Item No.)));
                                                   CaptionML=[DAN=Lagerbeholdning;
                                                              ENU=Inventory];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;User ID,Item No.                        ;Clustered=Yes }
    {    ;Description                              }
    {    ;Unit Price                               }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    LOCAL PROCEDURE SetItemFields@1();
    VAR
      Item@1000 : Record 27;
    BEGIN
      IF Item.GET("Item No.") THEN BEGIN
        Description := Item.Description;
        "Unit Price" := Item."Unit Price";
      END;
    END;

    BEGIN
    END.
  }
}

