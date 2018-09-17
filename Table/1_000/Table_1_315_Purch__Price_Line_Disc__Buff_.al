OBJECT Table 1315 Purch. Price Line Disc. Buff.
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=K�bsprislinjerabatbuffer.;
               ENU=Purch. Price Line Disc. Buff.];
  }
  FIELDS
  {
    { 3   ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 4   ;   ;Starting Date       ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 5   ;   ;Line Discount %     ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjerabatpct.;
                                                              ENU=Line Discount %];
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   AutoFormatType=2 }
    { 6   ;   ;Direct Unit Cost    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=K�bspris;
                                                              ENU=Direct Unit Cost];
                                                   MinValue=0;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 14  ;   ;Minimum Quantity    ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Min. antal;
                                                              ENU=Minimum Quantity];
                                                   MinValue=0 }
    { 15  ;   ;Ending Date         ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 1300;   ;Line Type           ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjetype;
                                                              ENU=Line Type];
                                                   OptionCaptionML=[DAN=" ,K�bslinjerabat,K�bspris";
                                                                    ENU=" ,Purchase Line Discount,Purchase Price"];
                                                   OptionString=[ ,Purchase Line Discount,Purchase Price] }
    { 1301;   ;Item No.            ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.];
                                                   Editable=No }
    { 1303;   ;Vendor No.          ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditornr.;
                                                              ENU=Vendor No.];
                                                   Editable=No }
    { 5400;   ;Unit of Measure Code;Code20        ;TableRelation="Item Unit of Measure";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 5700;   ;Variant Code        ;Code20        ;TableRelation="Item Variant";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
  }
  KEYS
  {
    {    ;Line Type,Starting Date,Currency Code,Variant Code,Unit of Measure Code,Minimum Quantity,Item No.,Vendor No.;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE LoadDataForItem@7(Item@1000 : Record 27);
    VAR
      PurchasePrice@1002 : Record 7012;
      PurchaseLineDiscount@1001 : Record 7014;
    BEGIN
      RESET;
      DELETEALL;

      "Item No." := Item."No.";

      PurchasePrice.SETRANGE("Item No.","Item No.");
      LoadPurchasePrice(PurchasePrice);

      PurchaseLineDiscount.SETRANGE("Item No.","Item No.");
      LoadPurchaseLineDiscount(PurchaseLineDiscount);

      IF FINDFIRST THEN;
    END;

    LOCAL PROCEDURE LoadPurchaseLineDiscount@4(VAR PurchaseLineDiscount@1000 : Record 7014);
    BEGIN
      IF PurchaseLineDiscount.FINDSET THEN
        REPEAT
          INIT;
          "Line Type" := "Line Type"::"Purchase Line Discount";

          "Starting Date" := PurchaseLineDiscount."Starting Date";
          "Minimum Quantity" := PurchaseLineDiscount."Minimum Quantity";
          "Unit of Measure Code" := PurchaseLineDiscount."Unit of Measure Code";

          "Line Discount %" := PurchaseLineDiscount."Line Discount %";
          "Currency Code" := PurchaseLineDiscount."Currency Code";
          "Ending Date" := PurchaseLineDiscount."Ending Date";
          "Variant Code" := PurchaseLineDiscount."Variant Code";
          "Vendor No." := PurchaseLineDiscount."Vendor No.";
          INSERT;
        UNTIL PurchaseLineDiscount.NEXT = 0;
    END;

    LOCAL PROCEDURE LoadPurchasePrice@5(VAR PurchasePrice@1000 : Record 7012);
    BEGIN
      IF PurchasePrice.FINDSET THEN
        REPEAT
          INIT;
          "Line Type" := "Line Type"::"Purchase Price";

          "Starting Date" := PurchasePrice."Starting Date";
          "Minimum Quantity" := PurchasePrice."Minimum Quantity";
          "Unit of Measure Code" := PurchasePrice."Unit of Measure Code";
          "Direct Unit Cost" := PurchasePrice."Direct Unit Cost";
          "Currency Code" := PurchasePrice."Currency Code";
          "Ending Date" := PurchasePrice."Ending Date";
          "Variant Code" := PurchasePrice."Variant Code";
          "Vendor No." := PurchasePrice."Vendor No.";

          INSERT;
        UNTIL PurchasePrice.NEXT = 0;
    END;

    [External]
    PROCEDURE ItemHasLines@26(Item@1000 : Record 27) : Boolean;
    VAR
      PurchaseLineDiscount@1001 : Record 7014;
      PurchasePrice@1002 : Record 7012;
    BEGIN
      RESET;

      "Item No." := Item."No.";

      PurchasePrice.SETRANGE("Item No.","Item No.");
      IF NOT PurchasePrice.ISEMPTY THEN
        EXIT(TRUE);

      PurchaseLineDiscount.SETRANGE("Item No.","Item No.");
      IF NOT PurchaseLineDiscount.ISEMPTY THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    BEGIN
    END.
  }
}

