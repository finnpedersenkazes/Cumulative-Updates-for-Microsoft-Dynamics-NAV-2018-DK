OBJECT Table 5805 Item Charge Assignment (Purch)
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    OnDelete=BEGIN
               TESTFIELD("Qty. Assigned",0);
             END;

    CaptionML=[DAN=Varegebyrtildeling (k›b);
               ENU=Item Charge Assignment (Purch)];
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota,Rammeordre,Returv.ordre;
                                                                    ENU=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order];
                                                   OptionString=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order }
    { 2   ;   ;Document No.        ;Code20        ;TableRelation="Purchase Header".No. WHERE (Document Type=FIELD(Document Type));
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 3   ;   ;Document Line No.   ;Integer       ;TableRelation="Purchase Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                                                   Document No.=FIELD(Document No.));
                                                   CaptionML=[DAN=Dokumentlinjenr.;
                                                              ENU=Document Line No.] }
    { 4   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 5   ;   ;Item Charge No.     ;Code20        ;TableRelation="Item Charge";
                                                   CaptionML=[DAN=Varegebyrnr.;
                                                              ENU=Item Charge No.];
                                                   NotBlank=Yes }
    { 6   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 7   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 8   ;   ;Qty. to Assign      ;Decimal       ;OnValidate=BEGIN
                                                                PurchLine.GET("Document Type","Document No.","Document Line No.");
                                                                PurchLine.TESTFIELD("Qty. to Invoice");

                                                                TESTFIELD("Applies-to Doc. Line No.");
                                                                IF ("Qty. to Assign" <> 0) AND ("Applies-to Doc. Type" = "Document Type") THEN
                                                                  IF PurchLineInvoiced THEN
                                                                    ERROR(Text000,PurchLine.TABLECAPTION);
                                                                VALIDATE("Amount to Assign");
                                                              END;

                                                   CaptionML=[DAN=Antal, der skal tildeles;
                                                              ENU=Qty. to Assign];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes }
    { 9   ;   ;Qty. Assigned       ;Decimal       ;CaptionML=[DAN=Antal tildelt;
                                                              ENU=Qty. Assigned];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 10  ;   ;Unit Cost           ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Amount to Assign");
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=2 }
    { 11  ;   ;Amount to Assign    ;Decimal       ;OnValidate=VAR
                                                                ItemChargeAssgntPurch@1000 : Codeunit 5805;
                                                              BEGIN
                                                                PurchLine.GET("Document Type","Document No.","Document Line No.");
                                                                IF NOT Currency.GET(PurchLine."Currency Code") THEN
                                                                  Currency.InitRoundingPrecision;
                                                                "Amount to Assign" := ROUND("Qty. to Assign" * "Unit Cost",Currency."Amount Rounding Precision");
                                                                ItemChargeAssgntPurch.SuggestAssgntFromLine(Rec);
                                                              END;

                                                   CaptionML=[DAN=Bel›b der skal tildeles;
                                                              ENU=Amount to Assign];
                                                   AutoFormatType=1 }
    { 12  ;   ;Applies-to Doc. Type;Option        ;CaptionML=[DAN=Udligningsbilagstype;
                                                              ENU=Applies-to Doc. Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota,Rammeordre,Returv.ordre,Modtagelse,Overflyt.kvit.,Returv.kvit.,Salgsleverance,Returvaremodt.;
                                                                    ENU=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Receipt,Transfer Receipt,Return Shipment,Sales Shipment,Return Receipt];
                                                   OptionString=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Receipt,Transfer Receipt,Return Shipment,Sales Shipment,Return Receipt }
    { 13  ;   ;Applies-to Doc. No. ;Code20        ;TableRelation=IF (Applies-to Doc. Type=CONST(Order)) "Purchase Header".No. WHERE (Document Type=CONST(Order))
                                                                 ELSE IF (Applies-to Doc. Type=CONST(Invoice)) "Purchase Header".No. WHERE (Document Type=CONST(Invoice))
                                                                 ELSE IF (Applies-to Doc. Type=CONST(Return Order)) "Purchase Header".No. WHERE (Document Type=CONST(Return Order))
                                                                 ELSE IF (Applies-to Doc. Type=CONST(Credit Memo)) "Purchase Header".No. WHERE (Document Type=CONST(Credit Memo))
                                                                 ELSE IF (Applies-to Doc. Type=CONST(Receipt)) "Purch. Rcpt. Header".No.
                                                                 ELSE IF (Applies-to Doc. Type=CONST(Return Shipment)) "Return Shipment Header".No.;
                                                   CaptionML=[DAN=Udligningsbilagsnr.;
                                                              ENU=Applies-to Doc. No.] }
    { 14  ;   ;Applies-to Doc. Line No.;Integer   ;TableRelation=IF (Applies-to Doc. Type=CONST(Order)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                                          Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                          ELSE IF (Applies-to Doc. Type=CONST(Invoice)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Invoice),
                                                                                                                                                                                                                          Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                                                                          ELSE IF (Applies-to Doc. Type=CONST(Return Order)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Return Order),
                                                                                                                                                                                                                                                                                                               Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                                                                                                                                                               ELSE IF (Applies-to Doc. Type=CONST(Credit Memo)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Credit Memo),
                                                                                                                                                                                                                                                                                                                                                                                                   Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                                                                                                                                                                                                                                                   ELSE IF (Applies-to Doc. Type=CONST(Receipt)) "Purch. Rcpt. Line"."Line No." WHERE (Document No.=FIELD(Applies-to Doc. No.))
                                                                                                                                                                                                                                                                                                                                                                                                   ELSE IF (Applies-to Doc. Type=CONST(Return Shipment)) "Return Shipment Line"."Line No." WHERE (Document No.=FIELD(Applies-to Doc. No.));
                                                   CaptionML=[DAN=Udlign.bilagslinjenr.;
                                                              ENU=Applies-to Doc. Line No.] }
    { 15  ;   ;Applies-to Doc. Line Amount;Decimal;CaptionML=[DAN=Udlign.bilagslinjebel›b;
                                                              ENU=Applies-to Doc. Line Amount];
                                                   AutoFormatType=1 }
  }
  KEYS
  {
    {    ;Document Type,Document No.,Document Line No.,Line No.;
                                                   SumIndexFields=Qty. to Assign,Qty. Assigned,Amount to Assign;
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;Applies-to Doc. Type,Applies-to Doc. No.,Applies-to Doc. Line No. }
    {    ;Applies-to Doc. Type                     }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke tildele varegebyr til %1, fordi den er blevet faktureret. I stedet kan du hente den bogf›rte dokumentlinje og derefter tildele varegebyret til denne linje.;ENU=You cannot assign item charges to the %1 because it has been invoiced. Instead you can get the posted document line and then assign the item charge to that line.';
      PurchLine@1001 : Record 39;
      Currency@1002 : Record 4;

    [External]
    PROCEDURE PurchLineInvoiced@1() : Boolean;
    BEGIN
      IF "Applies-to Doc. Type" <> "Document Type" THEN
        EXIT(FALSE);
      PurchLine.GET("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
      EXIT(PurchLine.Quantity = PurchLine."Quantity Invoiced");
    END;

    BEGIN
    END.
  }
}

