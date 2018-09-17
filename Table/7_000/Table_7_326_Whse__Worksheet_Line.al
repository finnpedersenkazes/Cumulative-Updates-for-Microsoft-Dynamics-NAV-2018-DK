OBJECT Table 7326 Whse. Worksheet Line
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
               WhseWkshTemplate@1001 : Record 7328;
               ItemTrackingMgt@1000 : Codeunit 6500;
             BEGIN
               WhseWkshTemplate.GET("Worksheet Template Name");
               IF WhseWkshTemplate.Type = WhseWkshTemplate.Type::Movement THEN BEGIN
                 UpdateMovActivLines;
                 ItemTrackingMgt.DeleteWhseItemTrkgLines(
                   DATABASE::"Whse. Worksheet Line",0,Name,"Worksheet Template Name",0,"Line No.","Location Code",TRUE);
               END;
             END;

    CaptionML=[DAN=Lageraktivitetskladdelinje;
               ENU=Whse. Worksheet Line];
  }
  FIELDS
  {
    { 1   ;   ;Worksheet Template Name;Code10     ;TableRelation="Whse. Worksheet Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Worksheet Template Name];
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Code10        ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   NotBlank=Yes }
    { 3   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.];
                                                   Editable=No }
    { 4   ;   ;Source Type         ;Integer       ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   Editable=No }
    { 5   ;   ;Source Subtype      ;Option        ;CaptionML=[DAN=Kildeundertype;
                                                              ENU=Source Subtype];
                                                   OptionCaptionML=[DAN=0,1,2,3,4,5,6,7,8,9,10;
                                                                    ENU=0,1,2,3,4,5,6,7,8,9,10];
                                                   OptionString=0,1,2,3,4,5,6,7,8,9,10;
                                                   Editable=No }
    { 6   ;   ;Source No.          ;Code20        ;CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.];
                                                   Editable=No }
    { 7   ;   ;Source Line No.     ;Integer       ;CaptionML=[DAN=Kildelinjenr.;
                                                              ENU=Source Line No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 8   ;   ;Source Subline No.  ;Integer       ;CaptionML=[DAN=Kildeunderlinjenr.;
                                                              ENU=Source Subline No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 9   ;   ;Source Document     ;Option        ;CaptionML=[DAN=Kildedokument;
                                                              ENU=Source Document];
                                                   OptionCaptionML=[DAN=,Salgsordre,,,Salgsreturv.ordre,K�bsordre,,,K�bsreturv.ordre,Ind. overf�rsel,Udg. overf�rsel,Prod.forbrug,,,,,,,,,Montageforbrug,Montageordre;
                                                                    ENU=,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,Inbound Transfer,Outbound Transfer,Prod. Consumption,,,,,,,,,Assembly Consumption,Assembly Order];
                                                   OptionString=,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,Inbound Transfer,Outbound Transfer,Prod. Consumption,,,,,,,,,Assembly Consumption,Assembly Order;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 10  ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   Editable=No }
    { 11  ;   ;Shelf No.           ;Code10        ;CaptionML=[DAN=Placeringsnr.;
                                                              ENU=Shelf No.] }
    { 12  ;   ;From Zone Code      ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                IF "From Zone Code" <> xRec."From Zone Code" THEN
                                                                  "From Bin Code" := '';
                                                              END;

                                                   CaptionML=[DAN=Fra zonekode;
                                                              ENU=From Zone Code] }
    { 13  ;   ;From Bin Code       ;Code20        ;OnValidate=VAR
                                                                WMSMgt@1000 : Codeunit 7302;
                                                              BEGIN
                                                                IF "From Bin Code" <> '' THEN
                                                                  WMSMgt.FindBinContent("Location Code","From Bin Code","Item No.","Variant Code","From Zone Code");

                                                                IF CurrFieldNo = FIELDNO("From Bin Code") THEN
                                                                  CheckBin("Location Code","From Bin Code",FALSE);

                                                                IF "From Bin Code" <> '' THEN BEGIN
                                                                  GetBin("Location Code","From Bin Code");
                                                                  "From Zone Code" := Bin."Zone Code";
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              WMSMgt@1000 : Codeunit 7302;
                                                              BinCode@1001 : Code[20];
                                                            BEGIN
                                                              BinCode := WMSMgt.BinContentLookUp("Location Code","Item No.","Variant Code","From Zone Code","From Bin Code");
                                                              IF BinCode <> '' THEN
                                                                VALIDATE("From Bin Code",BinCode);
                                                            END;

                                                   CaptionML=[DAN=Fra placeringskode;
                                                              ENU=From Bin Code] }
    { 14  ;   ;To Bin Code         ;Code20        ;TableRelation=IF (To Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                              Code=FIELD(To Bin Code))
                                                                                                              ELSE IF (To Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                  Zone Code=FIELD(To Zone Code),
                                                                                                                                                                  Code=FIELD(To Bin Code));
                                                   OnValidate=BEGIN
                                                                IF CurrFieldNo = FIELDNO("To Bin Code") THEN
                                                                  CheckBin("Location Code","To Bin Code",TRUE);

                                                                IF "To Bin Code" <> '' THEN BEGIN
                                                                  GetBin("Location Code","To Bin Code");
                                                                  "To Zone Code" := Bin."Zone Code";
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Til placeringskode;
                                                              ENU=To Bin Code] }
    { 15  ;   ;To Zone Code        ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                IF "To Zone Code" <> xRec."To Zone Code" THEN
                                                                  "To Bin Code" := '';
                                                              END;

                                                   CaptionML=[DAN=Til zonekode;
                                                              ENU=To Zone Code] }
    { 16  ;   ;Item No.            ;Code20        ;TableRelation=Item WHERE (Type=CONST(Inventory));
                                                   OnValidate=BEGIN
                                                                IF "Item No." <> '' THEN BEGIN
                                                                  GetItemUnitOfMeasure;
                                                                  Description := Item.Description;
                                                                  VALIDATE("Unit of Measure Code",ItemUnitOfMeasure.Code);
                                                                END ELSE BEGIN
                                                                  Description := '';
                                                                  "Variant Code" := '';
                                                                  VALIDATE("Unit of Measure Code",'');
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 17  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                IF Quantity < "Qty. Handled" THEN
                                                                  FIELDERROR(Quantity,STRSUBSTNO(Text010,"Qty. Handled"));

                                                                VALIDATE("Qty. Outstanding",(Quantity - "Qty. Handled"));

                                                                "Qty. (Base)" := CalcBaseQty(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 18  ;   ;Qty. (Base)         ;Decimal       ;CaptionML=[DAN=Antal (basis);
                                                              ENU=Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 19  ;   ;Qty. Outstanding    ;Decimal       ;OnValidate=BEGIN
                                                                "Qty. Outstanding (Base)" := CalcBaseQty("Qty. Outstanding");
                                                                VALIDATE("Qty. to Handle","Qty. Outstanding");
                                                              END;

                                                   CaptionML=[DAN=Antal udest�ende;
                                                              ENU=Qty. Outstanding];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 20  ;   ;Qty. Outstanding (Base);Decimal    ;CaptionML=[DAN=Antal udest�ende (basis);
                                                              ENU=Qty. Outstanding (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 21  ;   ;Qty. to Handle      ;Decimal       ;OnValidate=VAR
                                                                WhseWkshTemplate@1002 : Record 7328;
                                                                Confirmed@1000 : Boolean;
                                                                AvailableQty@1001 : Decimal;
                                                              BEGIN
                                                                IF "Qty. to Handle" > "Qty. Outstanding" THEN
                                                                  ERROR(
                                                                    Text000,
                                                                    "Qty. Outstanding");

                                                                "Qty. to Handle (Base)" := CalcBaseQty("Qty. to Handle");
                                                                IF "Qty. to Handle (Base)" > 0 THEN BEGIN
                                                                  WhseWkshTemplate.GET("Worksheet Template Name");
                                                                  IF WhseWkshTemplate.Type = WhseWkshTemplate.Type::Pick THEN BEGIN
                                                                    Confirmed := TRUE;
                                                                    IF (CurrFieldNo = FIELDNO("Qty. to Handle")) AND
                                                                       ("Shipping Advice" = "Shipping Advice"::Complete) AND
                                                                       ("Qty. to Handle" <> "Qty. Outstanding")
                                                                    THEN
                                                                      Confirmed := CONFIRM(
                                                                          Text001 +
                                                                          Text002,
                                                                          FALSE,
                                                                          FIELDCAPTION("Shipping Advice"),
                                                                          "Shipping Advice",
                                                                          FIELDCAPTION("Qty. to Handle"),
                                                                          "Qty. Outstanding");

                                                                    IF NOT Confirmed THEN
                                                                      ERROR(Text003);

                                                                    GetLocation("Location Code");
                                                                    IF Location."Bin Mandatory" THEN BEGIN
                                                                      IF CurrFieldNo <> FIELDNO("Qty. to Handle") THEN BEGIN
                                                                        AvailableQty := CalcAvailableQtyBase(FALSE);
                                                                        IF NOT Location."Always Create Pick Line" THEN
                                                                          IF "Qty. to Handle (Base)" > AvailableQty THEN BEGIN
                                                                            IF ("Shipping Advice" = "Shipping Advice"::Complete) OR
                                                                               (AvailableQty < 0)
                                                                            THEN
                                                                              "Qty. to Handle (Base)" := 0
                                                                            ELSE
                                                                              "Qty. to Handle (Base)" := AvailableQty;
                                                                          END;
                                                                      END
                                                                    END ELSE BEGIN
                                                                      AvailableQty := CalcAvailableQtyBase(FALSE);
                                                                      IF "Qty. to Handle (Base)" > AvailableQty THEN BEGIN
                                                                        IF ("Shipping Advice" = "Shipping Advice"::Complete) OR
                                                                           (AvailableQty < 0)
                                                                        THEN
                                                                          "Qty. to Handle (Base)" := 0
                                                                        ELSE
                                                                          "Qty. to Handle (Base)" := AvailableQty;

                                                                        IF (NOT HideValidationDialog) AND (CurrFieldNo = FIELDNO("Qty. to Handle")) THEN
                                                                          ERROR(
                                                                            Text004,
                                                                            AvailableQty);
                                                                      END;
                                                                    END;
                                                                  END ELSE
                                                                    IF WhseWkshTemplate.Type = WhseWkshTemplate.Type::Movement THEN
                                                                      IF CurrFieldNo <> FIELDNO("Qty. to Handle") THEN BEGIN
                                                                        AvailableQty := CheckAvailQtytoMove;
                                                                        IF AvailableQty < 0 THEN
                                                                          "Qty. to Handle (Base)" := 0
                                                                        ELSE
                                                                          IF "Qty. to Handle (Base)" > AvailableQty THEN
                                                                            "Qty. to Handle (Base)" := AvailableQty;
                                                                      END;

                                                                  CheckBin("Location Code","From Bin Code",FALSE);
                                                                  CheckBin("Location Code","To Bin Code",TRUE);
                                                                END;

                                                                TESTFIELD("Qty. per Unit of Measure");
                                                                IF "Qty. to Handle (Base)" = "Qty. Outstanding (Base)" THEN
                                                                  "Qty. to Handle" := "Qty. Outstanding"
                                                                ELSE
                                                                  "Qty. to Handle" := ROUND("Qty. to Handle (Base)" / "Qty. per Unit of Measure",0.00001);
                                                              END;

                                                   CaptionML=[DAN=H�ndteringsantal;
                                                              ENU=Qty. to Handle];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 22  ;   ;Qty. to Handle (Base);Decimal      ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Qty. to Handle","Qty. to Handle (Base)");
                                                              END;

                                                   CaptionML=[DAN=H�ndteringsantal (basis);
                                                              ENU=Qty. to Handle (Base)];
                                                   DecimalPlaces=0:5 }
    { 23  ;   ;Qty. Handled        ;Decimal       ;OnValidate=BEGIN
                                                                "Qty. Handled (Base)" := CalcBaseQty("Qty. Handled");
                                                                VALIDATE("Qty. Outstanding",Quantity - "Qty. Handled");
                                                              END;

                                                   CaptionML=[DAN=H�ndteret antal;
                                                              ENU=Qty. Handled];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 24  ;   ;Qty. Handled (Base) ;Decimal       ;OnValidate=BEGIN
                                                                "Qty. Handled" := CalcQty("Qty. Handled (Base)");
                                                                VALIDATE("Qty. Outstanding",Quantity - "Qty. Handled");
                                                              END;

                                                   CaptionML=[DAN=H�ndteret antal (basis);
                                                              ENU=Qty. Handled (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 27  ;   ;From Unit of Measure Code;Code10   ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=VAR
                                                                FromItemUnitOfMeasure@1000 : Record 5404;
                                                              BEGIN
                                                                IF "Item No." <> '' THEN BEGIN
                                                                  GetItemUnitOfMeasure;
                                                                  IF NOT FromItemUnitOfMeasure.GET(Item."No.","From Unit of Measure Code") THEN
                                                                    FromItemUnitOfMeasure.GET(Item."No.",Item."Base Unit of Measure");
                                                                  "Qty. per From Unit of Measure" := FromItemUnitOfMeasure."Qty. per Unit of Measure";
                                                                END ELSE
                                                                  "Qty. per From Unit of Measure" := 1;
                                                              END;

                                                   CaptionML=[DAN=Fra enhedskode;
                                                              ENU=From Unit of Measure Code];
                                                   NotBlank=Yes }
    { 28  ;   ;Qty. per From Unit of Measure;Decimal;
                                                   InitValue=1;
                                                   CaptionML=[DAN=Antal pr. fra enhed;
                                                              ENU=Qty. per From Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 29  ;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=BEGIN
                                                                IF "Item No." <> '' THEN BEGIN
                                                                  GetItemUnitOfMeasure;
                                                                  "Qty. per Unit of Measure" := ItemUnitOfMeasure."Qty. per Unit of Measure";
                                                                END ELSE
                                                                  "Qty. per Unit of Measure" := 1;

                                                                "From Unit of Measure Code" := "Unit of Measure Code";
                                                                "Qty. per From Unit of Measure" := "Qty. per Unit of Measure";
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code];
                                                   NotBlank=Yes }
    { 30  ;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 31  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=VAR
                                                                ItemVariant@1000 : Record 5401;
                                                              BEGIN
                                                                IF "Variant Code" <> '' THEN BEGIN
                                                                  ItemVariant.GET("Item No.","Variant Code");
                                                                  Description := ItemVariant.Description;
                                                                END ELSE
                                                                  GetItem("Item No.",Description);
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 32  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 33  ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 35  ;   ;Sorting Sequence No.;Integer       ;CaptionML=[DAN=Sorteringsr�kkef�lgenr.;
                                                              ENU=Sorting Sequence No.];
                                                   Editable=No }
    { 36  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 39  ;   ;Destination Type    ;Option        ;CaptionML=[DAN=Destinationstype;
                                                              ENU=Destination Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Lokation";
                                                                    ENU=" ,Customer,Vendor,Location"];
                                                   OptionString=[ ,Customer,Vendor,Location];
                                                   Editable=No }
    { 40  ;   ;Destination No.     ;Code20        ;TableRelation=IF (Destination Type=CONST(Customer)) Customer.No.
                                                                 ELSE IF (Destination Type=CONST(Vendor)) Vendor.No.
                                                                 ELSE IF (Destination Type=CONST(Location)) Location.Code;
                                                   CaptionML=[DAN=Destinationsnr.;
                                                              ENU=Destination No.];
                                                   Editable=No }
    { 41  ;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Spedit�rkode;
                                                              ENU=Shipping Agent Code] }
    { 42  ;   ;Shipping Agent Service Code;Code10 ;TableRelation="Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));
                                                   CaptionML=[DAN=Spedit�rservicekode;
                                                              ENU=Shipping Agent Service Code] }
    { 43  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   CaptionML=[DAN=Leveringskode;
                                                              ENU=Shipment Method Code] }
    { 44  ;   ;Shipping Advice     ;Option        ;CaptionML=[DAN=Afsendelsesadvis;
                                                              ENU=Shipping Advice];
                                                   OptionCaptionML=[DAN=Delvis,Komplet;
                                                                    ENU=Partial,Complete];
                                                   OptionString=Partial,Complete;
                                                   Editable=No }
    { 45  ;   ;Shipment Date       ;Date          ;CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
    { 46  ;   ;Whse. Document Type ;Option        ;CaptionML=[DAN=Lagerdokumenttype;
                                                              ENU=Whse. Document Type];
                                                   OptionCaptionML=[DAN=" ,Modtagelse,Leverance,Intern l�g-p�-lager,Internt pluk,Produktion,Bev.kladde (logistik),Intern flytning,Montage";
                                                                    ENU=" ,Receipt,Shipment,Internal Put-away,Internal Pick,Production,Whse. Mov.-Worksheet,Internal Movement,Assembly"];
                                                   OptionString=[ ,Receipt,Shipment,Internal Put-away,Internal Pick,Production,Whse. Mov.-Worksheet,Internal Movement,Assembly];
                                                   Editable=No }
    { 47  ;   ;Whse. Document No.  ;Code20        ;TableRelation=IF (Whse. Document Type=CONST(Receipt)) "Posted Whse. Receipt Header".No. WHERE (No.=FIELD(Whse. Document No.))
                                                                 ELSE IF (Whse. Document Type=CONST(Shipment)) "Warehouse Shipment Header".No. WHERE (No.=FIELD(Whse. Document No.))
                                                                 ELSE IF (Whse. Document Type=CONST(Internal Put-away)) "Whse. Internal Put-away Header".No. WHERE (No.=FIELD(Whse. Document No.))
                                                                 ELSE IF (Whse. Document Type=CONST(Internal Pick)) "Whse. Internal Pick Header".No. WHERE (No.=FIELD(Whse. Document No.))
                                                                 ELSE IF (Whse. Document Type=CONST(Production)) "Production Order".No. WHERE (No.=FIELD(Whse. Document No.))
                                                                 ELSE IF (Whse. Document Type=CONST(Assembly)) "Assembly Header".No. WHERE (Document Type=CONST(Order),
                                                                                                                                            No.=FIELD(Whse. Document No.));
                                                   CaptionML=[DAN=Lagerdokumentnr.;
                                                              ENU=Whse. Document No.];
                                                   Editable=No }
    { 48  ;   ;Whse. Document Line No.;Integer    ;TableRelation=IF (Whse. Document Type=CONST(Receipt)) "Posted Whse. Receipt Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                                                       Line No.=FIELD(Whse. Document Line No.))
                                                                                                                                                       ELSE IF (Whse. Document Type=CONST(Shipment)) "Warehouse Shipment Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                 Line No.=FIELD(Whse. Document Line No.))
                                                                                                                                                                                                                                                 ELSE IF (Whse. Document Type=CONST(Internal Put-away)) "Whse. Internal Put-away Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                                                         Line No.=FIELD(Whse. Document Line No.))
                                                                                                                                                                                                                                                                                                                                                         ELSE IF (Whse. Document Type=CONST(Internal Pick)) "Whse. Internal Pick Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                                                                                                                                                         Line No.=FIELD(Whse. Document Line No.))
                                                                                                                                                                                                                                                                                                                                                                                                                                                         ELSE IF (Whse. Document Type=CONST(Production)) "Prod. Order Line"."Line No." WHERE (Status=CONST(Released),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Prod. Order No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Line No.=FIELD(Line No.))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ELSE IF (Whse. Document Type=CONST(Assembly)) "Assembly Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Document No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Line No.=FIELD(Whse. Document Line No.));
                                                   CaptionML=[DAN=Lagerdokumentlinjenr.;
                                                              ENU=Whse. Document Line No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Worksheet Template Name,Name,Location Code,Line No.;
                                                   Clustered=Yes }
    {    ;Worksheet Template Name,Name,Location Code,Sorting Sequence No. }
    {    ;Item No.,Location Code,Worksheet Template Name,Variant Code,Unit of Measure Code;
                                                   SumIndexFields=Qty. to Handle (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Whse. Document Type,Whse. Document No.,Whse. Document Line No. }
    {    ;Worksheet Template Name,Name,Location Code,Item No.;
                                                   MaintainSQLIndex=No }
    {    ;Worksheet Template Name,Name,Location Code,Due Date;
                                                   MaintainSQLIndex=No }
    {    ;Worksheet Template Name,Name,Location Code,Destination Type,Destination No.;
                                                   MaintainSQLIndex=No }
    {    ;Worksheet Template Name,Name,Location Code,Source Document,Source No.;
                                                   MaintainSQLIndex=No }
    {    ;Worksheet Template Name,Name,Location Code,To Bin Code;
                                                   MaintainSQLIndex=No }
    {    ;Worksheet Template Name,Name,Location Code,Shelf No.;
                                                   MaintainSQLIndex=No }
    {    ;Source Type,Source Subtype,Source No.,Source Line No.,Source Subline No. }
    {    ;Item No.,From Bin Code,Location Code,Variant Code,From Unit of Measure Code;
                                                   SumIndexFields=Qty. to Handle,Qty. to Handle (Base);
                                                   MaintainSIFTIndex=No }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke h�ndtere mere end de udest�ende %1 enheder.;ENU=You cannot handle more than the outstanding %1 units.';
      Text001@1003 : TextConst 'DAN=%1 er sat til %2. %3 skal v�re %4.\\;ENU=%1 is set to %2. %3 should be %4.\\';
      Text002@1002 : TextConst 'DAN=Er den indtastede v�rdi acceptabel?;ENU=Accept the entered value?';
      Text003@1001 : TextConst 'DAN=Opdateringen blev afbrudt pga. advarslen.;ENU=The update was interrupted to respect the warning.';
      WhseWorksheetLine@1018 : Record 7326;
      Location@1005 : Record 14;
      Item@1011 : Record 27;
      Bin@1006 : Record 7354;
      BinType@1017 : Record 7303;
      ItemUnitOfMeasure@1014 : Record 5404;
      Text004@1004 : TextConst 'DAN=Du kan ikke h�ndtere mere end de disponible %1 enheder.;ENU=You cannot handle more than the available %1 units.';
      Text005@1008 : TextConst 'DAN=STANDARD;ENU=DEFAULT';
      Text006@1007 : TextConst 'DAN=Standard%1kladde;ENU=Default %1 Worksheet';
      Text007@1009 : TextConst 'DAN=Du skal f�rst oprette brugeren %1 som lagermedarbejder.;ENU=You must first set up user %1 as a warehouse employee.';
      Text008@1010 : TextConst 'DAN=%1 Kladde;ENU=%1 Worksheet';
      Text009@1012 : TextConst 'DAN=Lokationen for %1 i %2 %3 er ikke aktiveret for brugeren %4.;ENU=The location %1 of %2 %3 is not enabled for user %4.';
      Text010@1013 : TextConst 'DAN=m� ikke v�re mindre end %1 enheder;ENU=must not be less than %1 units';
      CreatePick@1021 : Codeunit 7312;
      WhseAvailMgt@1023 : Codeunit 7314;
      LastLineNo@1019 : Integer;
      HideValidationDialog@1015 : Boolean;
      Text011@1016 : TextConst 'DAN=Den m�ngde, der kan plukkes, er ikke tilstr�kkelig til at udfylde alle linjerne.;ENU=Quantity available to pick is not enough to fill in all the lines.';
      OpenFromBatch@1022 : Boolean;
      CurrentFieldNo@1020 : Integer;

    [External]
    PROCEDURE CalcBaseQty@14(Qty@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    END;

    [External]
    PROCEDURE CalcQty@5(QtyBase@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(QtyBase / "Qty. per Unit of Measure",0.00001));
    END;

    [External]
    PROCEDURE AutofillQtyToHandle@10(VAR WhseWkshLine@1000 : Record 7326);
    VAR
      NotEnough@1001 : Boolean;
    BEGIN
      WITH WhseWkshLine DO BEGIN
        NotEnough := FALSE;
        SetHideValidationDialog(TRUE);
        LOCKTABLE;
        IF FIND('-') THEN
          REPEAT
            VALIDATE("Qty. to Handle","Qty. Outstanding");
            MODIFY;
            IF NOT NotEnough THEN
              IF "Qty. to Handle" < "Qty. Outstanding" THEN
                NotEnough := TRUE;
          UNTIL NEXT = 0;
        SetHideValidationDialog(FALSE);
        IF NotEnough THEN
          MESSAGE(Text011);
      END;
    END;

    [External]
    PROCEDURE DeleteQtyToHandle@11(VAR WhseWkshLine@1000 : Record 7326);
    BEGIN
      WITH WhseWkshLine DO BEGIN
        LOCKTABLE;
        IF FIND('-') THEN
          REPEAT
            VALIDATE("Qty. to Handle",0);
            MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE AssignedQtyOnReservedLines@29() : Decimal;
    VAR
      WhseWkshLine@1000 : Record 7326;
      TempWhseActivLine@1002 : TEMPORARY Record 5767;
      LineReservedQtyBase@1001 : Decimal;
      TotalReservedAndAssignedBase@1003 : Decimal;
      ReservedAndAssignedBase@1004 : Decimal;
    BEGIN
      WhseWkshLine.SETCURRENTKEY(
        "Item No.","Location Code","Worksheet Template Name","Variant Code");
      WhseWkshLine.SETRANGE("Item No.","Item No.");
      WhseWkshLine.SETRANGE("Location Code","Location Code");
      WhseWkshLine.SETRANGE("Worksheet Template Name","Worksheet Template Name");
      WhseWkshLine.SETRANGE("Variant Code","Variant Code");
      IF WhseWkshLine.FIND('-') THEN
        REPEAT
          IF RECORDID <> WhseWkshLine.RECORDID THEN BEGIN
            LineReservedQtyBase :=
              ABS(
                WhseAvailMgt.CalcLineReservedQtyOnInvt(
                  WhseWkshLine."Source Type",WhseWkshLine."Source Subtype",
                  WhseWkshLine."Source No.",WhseWkshLine."Source Line No.",
                  WhseWkshLine."Source Subline No.",
                  TRUE,'','',TempWhseActivLine));
            IF LineReservedQtyBase > 0 THEN BEGIN
              IF LineReservedQtyBase <= WhseWkshLine."Qty. to Handle (Base)" THEN
                ReservedAndAssignedBase := LineReservedQtyBase
              ELSE
                ReservedAndAssignedBase := WhseWkshLine."Qty. to Handle (Base)";
              TotalReservedAndAssignedBase := TotalReservedAndAssignedBase + ReservedAndAssignedBase;
            END;
          END;
        UNTIL WhseWkshLine.NEXT = 0;
      EXIT(TotalReservedAndAssignedBase);
    END;

    [External]
    PROCEDURE CalcAvailableQtyBase@1(ExcludeLine@1102601000 : Boolean) AvailableQty@1000 : Decimal;
    VAR
      TempWhseActivLine@1001 : TEMPORARY Record 5767;
      AvailQtyBase@1003 : Decimal;
      QtyAssgndOnWkshBase@1006 : Decimal;
      QtyReservedOnPickShip@1007 : Decimal;
      QtyReservedForCurrLine@1004 : Decimal;
    BEGIN
      ExcludeLine := FALSE; // obsolete, will be deleted in the next major release
      GetItem("Item No.",Description);
      GetLocation("Location Code");

      IF Location."Directed Put-away and Pick" THEN BEGIN
        QtyAssgndOnWkshBase := WhseAvailMgt.CalcQtyAssgndOnWksh(Rec,NOT Location."Allow Breakbulk",TRUE);

        AvailQtyBase :=
          CreatePick.CalcTotalAvailQtyToPick(
            "Location Code","Item No.","Variant Code",'','',"Source Type","Source Subtype","Source No.","Source Line No.",
            "Source Subline No.","Qty. to Handle (Base)",FALSE);
      END ELSE BEGIN
        QtyAssgndOnWkshBase := WhseAvailMgt.CalcQtyAssgndOnWksh(Rec,TRUE,TRUE);

        IF Location."Require Pick" THEN
          QtyReservedOnPickShip :=
            WhseAvailMgt.CalcReservQtyOnPicksShips("Location Code","Item No.","Variant Code",TempWhseActivLine);

        QtyReservedForCurrLine :=
          ABS(
            WhseAvailMgt.CalcLineReservedQtyOnInvt(
              "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",TRUE,'','',TempWhseActivLine));

        AvailQtyBase :=
          WhseAvailMgt.CalcInvtAvailQty(Item,Location,"Variant Code",TempWhseActivLine) +
          QtyReservedOnPickShip + QtyReservedForCurrLine;
      END;

      AvailableQty := AvailQtyBase - QtyAssgndOnWkshBase + AssignedQtyOnReservedLines;
    END;

    PROCEDURE CalcReservedNotFromILEQty@41(QtyBaseAvailToPick@1002 : Decimal;VAR QtyToPick@1001 : Decimal;VAR QtyToPickBase@1000 : Decimal);
    BEGIN
      CreatePick.CheckReservation(
        QtyBaseAvailToPick,"Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",FALSE,
        "Qty. per Unit of Measure",QtyToPick,QtyToPickBase);
    END;

    [External]
    PROCEDURE CheckAvailQtytoMove@25() AvailableQtyToMoveBase@1000 : Decimal;
    BEGIN
      AvailableQtyToMoveBase := CalcAvailQtyToMove + xRec."Qty. to Handle (Base)";
    END;

    LOCAL PROCEDURE CalcAvailQtyToMove@23() : Decimal;
    VAR
      BinContent@1000 : Record 7302;
      WhseWkshLine@1002 : Record 7326;
      QtyAvailToMoveBase@1001 : Decimal;
    BEGIN
      IF ("Location Code" <> '') AND ("From Bin Code" <> '') AND
         ("Item No." <> '') AND ("From Unit of Measure Code" <> '')
      THEN BEGIN
        GetLocation("Location Code");
        IF BinContent.GET(
             "Location Code","From Bin Code","Item No.","Variant Code","From Unit of Measure Code")
        THEN BEGIN
          QtyAvailToMoveBase := BinContent.CalcQtyAvailToTake(0);
          WhseWkshLine.SETCURRENTKEY(
            "Item No.","From Bin Code","Location Code","Variant Code","From Unit of Measure Code");
          WhseWkshLine.SETRANGE("Item No.","Item No.");
          WhseWkshLine.SETRANGE("From Bin Code","From Bin Code");
          WhseWkshLine.SETRANGE("Location Code","Location Code");
          WhseWkshLine.SETRANGE("Variant Code","Variant Code");
          WhseWkshLine.SETRANGE("From Unit of Measure Code","From Unit of Measure Code");
          WhseWkshLine.CALCSUMS("Qty. to Handle (Base)");
          QtyAvailToMoveBase := QtyAvailToMoveBase - WhseWkshLine."Qty. to Handle (Base)";
        END;
      END;
      EXIT(QtyAvailToMoveBase);
    END;

    [External]
    PROCEDURE SortWhseWkshLines@3(WhseWkshTemplate@1005 : Code[10];WhseWkshName@1002 : Code[10];LocationCode@1004 : Code[10];SortingMethod@1003 : ' ,Item,Document,Shelf/Bin No.,Due Date,Ship-To');
    VAR
      WhseWkshLine@1001 : Record 7326;
      SequenceNo@1000 : Integer;
    BEGIN
      WhseWkshLine.SETRANGE("Worksheet Template Name",WhseWkshTemplate);
      WhseWkshLine.SETRANGE(Name,WhseWkshName);
      WhseWkshLine.SETRANGE("Location Code",LocationCode);
      CASE SortingMethod OF
        SortingMethod::Item:
          WhseWkshLine.SETCURRENTKEY(
            "Worksheet Template Name",Name,"Location Code","Item No.");
        SortingMethod::Document:
          WhseWkshLine.SETCURRENTKEY(
            "Worksheet Template Name",Name,"Location Code","Source Document","Source No.");
        SortingMethod::"Shelf/Bin No.":
          BEGIN
            GetLocation(LocationCode);
            IF Location."Bin Mandatory" THEN
              WhseWkshLine.SETCURRENTKEY(
                "Worksheet Template Name",Name,"Location Code","To Bin Code")
            ELSE
              WhseWkshLine.SETCURRENTKEY(
                "Worksheet Template Name",Name,"Location Code","Shelf No.");
          END;
        SortingMethod::"Due Date":
          WhseWkshLine.SETCURRENTKEY(
            "Worksheet Template Name",Name,"Location Code","Due Date");
        SortingMethod::"Ship-To":
          WhseWkshLine.SETCURRENTKEY(
            "Worksheet Template Name",Name,"Location Code","Destination Type","Destination No.");
      END;

      IF WhseWkshLine.FIND('-') THEN BEGIN
        SequenceNo := 10000;
        REPEAT
          WhseWkshLine."Sorting Sequence No." := SequenceNo;
          WhseWkshLine.MODIFY;
          SequenceNo := SequenceNo + 10000;
        UNTIL WhseWkshLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE GetLocation@4(LocationCode@1000 : Code[10]);
    BEGIN
      IF Location.Code <> LocationCode THEN BEGIN
        IF LocationCode = '' THEN
          Location.GetLocationSetup(LocationCode,Location)
        ELSE
          Location.GET(LocationCode);
      END;
    END;

    [External]
    PROCEDURE GetItem@13(ItemNo@1000 : Code[20];VAR ItemDescription@1001 : Text[50]);
    BEGIN
      IF ItemNo = '' THEN
        ItemDescription := ''
      ELSE
        IF ItemNo <> Item."No." THEN BEGIN
          ItemDescription := '';
          IF Item.GET(ItemNo) THEN
            ItemDescription := Item.Description;
        END ELSE
          ItemDescription := Item.Description;
    END;

    LOCAL PROCEDURE GetItemUnitOfMeasure@18();
    BEGIN
      GetItem("Item No.",Description);
      IF (Item."No." <> ItemUnitOfMeasure."Item No.") OR
         ("Unit of Measure Code" <> ItemUnitOfMeasure.Code)
      THEN
        IF NOT ItemUnitOfMeasure.GET(Item."No.","Unit of Measure Code") THEN
          ItemUnitOfMeasure.GET(Item."No.",Item."Base Unit of Measure");
    END;

    LOCAL PROCEDURE GetBin@19(LocationCode@1000 : Code[10];BinCode@1002 : Code[20]);
    BEGIN
      IF (LocationCode = '') OR (BinCode = '') THEN
        CLEAR(Bin)
      ELSE
        IF (Bin."Location Code" <> LocationCode) OR
           (Bin.Code <> BinCode)
        THEN
          Bin.GET(LocationCode,BinCode);
    END;

    [External]
    PROCEDURE CheckBin@17(LocationCode@1000 : Code[10];BinCode@1001 : Code[20];Inbound@1002 : Boolean);
    VAR
      WhseWkshTemplate@1008 : Record 7328;
      BinContent@1006 : Record 7302;
      WMSMgt@1003 : Codeunit 7302;
      Cubage@1004 : Decimal;
      Weight@1005 : Decimal;
    BEGIN
      GetLocation(LocationCode);
      IF NOT Location."Directed Put-away and Pick" THEN
        EXIT;

      GetBin(LocationCode,BinCode);
      Bin.CALCFIELDS("Adjustment Bin");
      Bin.TESTFIELD("Adjustment Bin",FALSE);
      IF (BinCode <> '') AND ("Item No." <> '') THEN BEGIN
        IF Bin."Bin Type Code" <> '' THEN BEGIN
          WhseWkshTemplate.GET("Worksheet Template Name");
          IF WhseWkshTemplate.Type = WhseWkshTemplate.Type::Movement THEN BEGIN
            GetBinType(Bin."Bin Type Code");
            BinType.TESTFIELD(Receive,FALSE);
          END;
        END;

        IF Inbound THEN BEGIN
          WMSMgt.CalcCubageAndWeight(
            "Item No.","From Unit of Measure Code","Qty. to Handle",Cubage,Weight);
          IF BinContent.GET(
               "Location Code",BinCode,"Item No.","Variant Code","Unit of Measure Code")
          THEN
            BinContent.CheckIncreaseBinContent(
              "Qty. to Handle (Base)",0,0,0,Cubage,Weight,FALSE,FALSE)
          ELSE
            Bin.CheckIncreaseBin(BinCode,"Item No.","Qty. to Handle",0,0,Cubage,Weight,FALSE,FALSE);
        END ELSE BEGIN
          BinContent.GET(
            "Location Code",BinCode,"Item No.","Variant Code","From Unit of Measure Code");
          IF BinContent."Block Movement" IN [
                                             BinContent."Block Movement"::Outbound,BinContent."Block Movement"::All]
          THEN
            BinContent.FIELDERROR("Block Movement");
        END;
      END;
    END;

    LOCAL PROCEDURE GetBinType@26(BinTypeCode@1000 : Code[10]);
    BEGIN
      IF BinTypeCode = '' THEN
        BinType.INIT
      ELSE
        IF BinType.Code <> BinTypeCode THEN
          BinType.GET(BinTypeCode);
    END;

    [External]
    PROCEDURE PutAwayCreate@8(VAR WhsePutAwayWkshLine@1000 : Record 7326);
    VAR
      CreatePutAwayFromWhseSource@1001 : Report 7305;
    BEGIN
      CreatePutAwayFromWhseSource.SetWhseWkshLine(WhsePutAwayWkshLine);
      CreatePutAwayFromWhseSource.RUNMODAL;
      CreatePutAwayFromWhseSource.GetResultMessage(1);
      CLEAR(CreatePutAwayFromWhseSource);
    END;

    [External]
    PROCEDURE MovementCreate@22(VAR WhseWkshLine@1000 : Record 7326);
    VAR
      CreateMovFromWhseSource@1001 : Report 7305;
    BEGIN
      CreateMovFromWhseSource.SetWhseWkshLine(WhseWkshLine);
      CreateMovFromWhseSource.RUNMODAL;
      CreateMovFromWhseSource.GetResultMessage(3);
      CLEAR(CreateMovFromWhseSource);
    END;

    [External]
    PROCEDURE TemplateSelection@16(PageID@1006 : Integer;PageTemplate@1000 : 'Put-away,Pick,Movement';VAR WhseWkshLine@1005 : Record 7326;VAR WhseWkshSelected@1001 : Boolean);
    VAR
      WhseWkshTemplate@1002 : Record 7328;
    BEGIN
      WhseWkshSelected := TRUE;

      WhseWkshTemplate.RESET;
      WhseWkshTemplate.SETRANGE("Page ID",PageID);
      WhseWkshTemplate.SETRANGE(Type,PageTemplate);

      CASE WhseWkshTemplate.COUNT OF
        0:
          BEGIN
            WhseWkshTemplate.INIT;
            WhseWkshTemplate.VALIDATE(Type,PageTemplate);
            WhseWkshTemplate.VALIDATE("Page ID");
            WhseWkshTemplate.Name :=
              FORMAT(WhseWkshTemplate.Type,MAXSTRLEN(WhseWkshTemplate.Name));
            WhseWkshTemplate.Description := STRSUBSTNO(Text008,WhseWkshTemplate.Type);
            WhseWkshTemplate.INSERT;
            COMMIT;
          END;
        1:
          WhseWkshTemplate.FINDFIRST;
        ELSE
          WhseWkshSelected := PAGE.RUNMODAL(0,WhseWkshTemplate) = ACTION::LookupOK;
      END;
      IF WhseWkshSelected THEN BEGIN
        WhseWkshLine.FILTERGROUP := 2;
        WhseWkshLine.SETRANGE("Worksheet Template Name",WhseWkshTemplate.Name);
        WhseWkshLine.FILTERGROUP := 0;
        IF OpenFromBatch THEN BEGIN
          WhseWkshLine."Worksheet Template Name" := '';
          PAGE.RUN(WhseWkshTemplate."Page ID",WhseWkshLine);
        END;
      END;
    END;

    [External]
    PROCEDURE TemplateSelectionFromBatch@36(VAR WhseWkshName@1003 : Record 7327);
    VAR
      WhseWkshLine@1000 : Record 7326;
      WhseWkshTemplate@1002 : Record 7328;
    BEGIN
      OpenFromBatch := TRUE;
      WhseWkshTemplate.GET(WhseWkshName."Worksheet Template Name");
      WhseWkshTemplate.TESTFIELD("Page ID");
      WhseWkshName.TESTFIELD(Name);

      WhseWkshLine.FILTERGROUP := 2;
      WhseWkshLine.SETRANGE("Worksheet Template Name",WhseWkshTemplate.Name);
      WhseWkshLine.FILTERGROUP := 0;

      WhseWkshLine."Worksheet Template Name" := '';
      WhseWkshLine.Name := WhseWkshName.Name;
      WhseWkshLine."Location Code" := WhseWkshName."Location Code";
      PAGE.RUN(WhseWkshTemplate."Page ID",WhseWkshLine);
    END;

    [External]
    PROCEDURE OpenWhseWksh@12(VAR WhseWkshLine@1001 : Record 7326;VAR CurrentWkshTemplateName@1003 : Code[10];VAR CurrentWkshName@1000 : Code[10];VAR CurrentLocationCode@1002 : Code[10]);
    BEGIN
      CheckWhseEmployee;
      CurrentWkshTemplateName := WhseWkshLine.GETRANGEMAX("Worksheet Template Name");
      CheckTemplateName(CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode);
      WhseWkshLine.FILTERGROUP := 2;
      WhseWkshLine.SETRANGE(Name,CurrentWkshName);
      IF CurrentLocationCode <> '' THEN
        WhseWkshLine.SETRANGE("Location Code",CurrentLocationCode);
      WhseWkshLine.FILTERGROUP := 0;
    END;

    [External]
    PROCEDURE OpenWhseWkshBatch@37(VAR WhseWkshName@1005 : Record 7327);
    VAR
      WhseWkshTemplate@1003 : Record 7328;
      WhseWkshLine@1001 : Record 7326;
      WmsMgt@1002 : Codeunit 7302;
      JnlSelected@1004 : Boolean;
    BEGIN
      IF WhseWkshName.GETFILTER("Worksheet Template Name") <> '' THEN
        EXIT;
      WhseWkshName.FILTERGROUP(2);
      IF WhseWkshName.GETFILTER("Worksheet Template Name") <> '' THEN BEGIN
        WhseWkshName.FILTERGROUP(0);
        EXIT;
      END;
      WhseWkshName.FILTERGROUP(0);

      IF NOT WhseWkshName.FIND('-') THEN
        FOR WhseWkshTemplate.Type := WhseWkshTemplate.Type::"Put-away" TO WhseWkshTemplate.Type::Movement DO BEGIN
          WhseWkshTemplate.SETRANGE(Type,WhseWkshTemplate.Type);
          IF NOT WhseWkshTemplate.FINDFIRST THEN
            TemplateSelection(0,WhseWkshTemplate.Type,WhseWkshLine,JnlSelected);
          IF WhseWkshTemplate.FINDFIRST THEN BEGIN
            IF WhseWkshName."Location Code" = '' THEN
              WhseWkshName."Location Code" := WmsMgt.GetDefaultLocation;
            CheckTemplateName(WhseWkshTemplate.Name,WhseWkshName.Name,WhseWkshName."Location Code");
          END;
        END;

      WhseWkshName.FIND('-');
      JnlSelected := TRUE;
      WhseWkshName.CALCFIELDS("Template Type");
      WhseWkshTemplate.SETRANGE(Type,WhseWkshName."Template Type");
      IF WhseWkshName.GETFILTER("Worksheet Template Name") <> '' THEN
        WhseWkshTemplate.SETRANGE(Name,WhseWkshName.GETFILTER("Worksheet Template Name"));
      CASE WhseWkshTemplate.COUNT OF
        1:
          WhseWkshTemplate.FINDFIRST;
        ELSE
          JnlSelected := PAGE.RUNMODAL(0,WhseWkshTemplate) = ACTION::LookupOK;
      END;
      IF NOT JnlSelected THEN
        ERROR('');

      WhseWkshName.FILTERGROUP(0);
      WhseWkshName.SETRANGE("Worksheet Template Name",WhseWkshTemplate.Name);
      WhseWkshName.FILTERGROUP(2);
    END;

    LOCAL PROCEDURE CheckTemplateName@20(CurrentWkshTemplateName@1000 : Code[10];VAR CurrentWkshName@1001 : Code[10];VAR CurrentLocationCode@1005 : Code[10]);
    VAR
      WhseWkshTemplate@1006 : Record 7328;
      WhseWkshName@1002 : Record 7327;
      WhseEmployee@1004 : Record 7301;
      WmsMgt@1003 : Codeunit 7302;
      FoundLocation@1007 : Boolean;
    BEGIN
      WhseWkshTemplate.GET(CurrentWkshTemplateName);
      WhseWkshName.SETRANGE("Worksheet Template Name",CurrentWkshTemplateName);
      IF NOT WhseWkshName.GET(CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode) OR
         ((USERID <> '') AND NOT WhseEmployee.GET(USERID,CurrentLocationCode))
      THEN BEGIN
        IF USERID <> '' THEN BEGIN
          CurrentLocationCode := WmsMgt.GetDefaultLocation;
          WhseWkshName.SETRANGE("Location Code",CurrentLocationCode);
        END;
        IF NOT WhseWkshName.FINDFIRST THEN BEGIN
          IF USERID <> '' THEN BEGIN
            WhseEmployee.SETCURRENTKEY(Default);
            WhseEmployee.SETRANGE(Default,FALSE);
            WhseEmployee.SETRANGE("User ID",USERID);
            IF WhseEmployee.FIND('-') THEN
              REPEAT
                WhseWkshName.SETRANGE("Location Code",WhseEmployee."Location Code");
                FoundLocation := WhseWkshName.FINDFIRST;
              UNTIL (WhseEmployee.NEXT = 0) OR FoundLocation;
          END;
          IF NOT FoundLocation THEN BEGIN
            WhseWkshName.INIT;
            WhseWkshName."Worksheet Template Name" := CurrentWkshTemplateName;
            WhseWkshName.SetupNewName;
            WhseWkshName.Name := Text005;
            WhseWkshName.Description :=
              STRSUBSTNO(Text006,WhseWkshTemplate.Type);
            WhseWkshName.INSERT(TRUE);
          END;
          CurrentLocationCode := WhseWkshName."Location Code";
          COMMIT;
        END;
        CurrentWkshName := WhseWkshName.Name;
        CurrentLocationCode := WhseWkshName."Location Code";
      END;
    END;

    [External]
    PROCEDURE CheckWhseWkshName@21(CurrentWkshName@1000 : Code[10];CurrentLocationCode@1003 : Code[10];VAR WhseWkshLine@1001 : Record 7326);
    VAR
      WhseWkshName@1002 : Record 7327;
      WhseEmployee@1004 : Record 7301;
    BEGIN
      WhseWkshName.GET(
        WhseWkshLine.GETRANGEMAX("Worksheet Template Name"),CurrentWkshName,CurrentLocationCode);
      IF (USERID <> '') AND NOT WhseEmployee.GET(USERID,CurrentLocationCode) THEN
        ERROR(Text009,CurrentLocationCode,WhseWkshName.TABLECAPTION,CurrentWkshName,USERID);
    END;

    LOCAL PROCEDURE CheckWhseEmployee@15();
    VAR
      WhseEmployee@1000 : Record 7301;
    BEGIN
      IF USERID <> '' THEN BEGIN
        WhseEmployee.SETRANGE("User ID",USERID);
        IF WhseEmployee.ISEMPTY THEN
          ERROR(Text007,USERID);
      END;
    END;

    [External]
    PROCEDURE SetWhseWkshName@7(CurrentWkshName@1000 : Code[10];CurrentLocationCode@1002 : Code[10];VAR WhseWkshLine@1001 : Record 7326);
    BEGIN
      WhseWkshLine.FILTERGROUP := 2;
      WhseWkshLine.SETRANGE(Name,CurrentWkshName);
      WhseWkshLine.SETRANGE("Location Code",CurrentLocationCode);
      WhseWkshLine.FILTERGROUP := 0;
      IF WhseWkshLine.FIND('-') THEN;
    END;

    [External]
    PROCEDURE LookupWhseWkshName@9(VAR WhseWkshLine@1001 : Record 7326;VAR CurrentWkshName@1000 : Code[10];VAR CurrentLocationCode@1003 : Code[10]);
    VAR
      WhseWkshName@1002 : Record 7327;
    BEGIN
      COMMIT;
      WhseWkshName."Worksheet Template Name" := WhseWkshLine.GETRANGEMAX("Worksheet Template Name");
      WhseWkshName.Name := WhseWkshLine.GETRANGEMAX(Name);
      WhseWkshName.FILTERGROUP(2);
      WhseWkshName.SETRANGE("Worksheet Template Name",WhseWkshName."Worksheet Template Name");
      WhseWkshName.FILTERGROUP(0);
      IF PAGE.RUNMODAL(0,WhseWkshName) = ACTION::LookupOK THEN BEGIN
        CurrentWkshName := WhseWkshName.Name;
        CurrentLocationCode := WhseWkshName."Location Code";
        SetWhseWkshName(CurrentWkshName,WhseWkshName."Location Code",WhseWkshLine);
      END;
    END;

    LOCAL PROCEDURE UpdateMovActivLines@35();
    VAR
      WhseActivLine@1001 : Record 5767;
      WhseActivLine2@1000 : Record 5767;
    BEGIN
      WhseActivLine.SETCURRENTKEY(
        "Whse. Document No.","Whse. Document Type","Activity Type","Whse. Document Line No.");
      WhseActivLine.SETRANGE("Whse. Document No.",Name);
      WhseActivLine.SETRANGE("Whse. Document Type",WhseActivLine."Whse. Document Type"::"Movement Worksheet");
      WhseActivLine.SETRANGE("Activity Type",WhseActivLine."Activity Type"::Movement);
      WhseActivLine.SETRANGE("Whse. Document Line No.","Line No.");
      WhseActivLine.SETRANGE("Source Type",DATABASE::"Whse. Worksheet Line");
      WhseActivLine.SETRANGE("Source No.","Worksheet Template Name");
      WhseActivLine.SETRANGE("Location Code","Location Code");
      IF WhseActivLine.FIND('-') THEN
        REPEAT
          WhseActivLine2.COPY(WhseActivLine);
          WhseActivLine2."Source Type" := 0;
          WhseActivLine2."Source No." := '';
          WhseActivLine2."Source Line No." := 0;
          WhseActivLine2.MODIFY;
        UNTIL WhseActivLine.NEXT = 0;
    END;

    [External]
    PROCEDURE SetHideValidationDialog@24(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500();
    VAR
      WhseItemTrackingForm@1000 : Page 6550;
    BEGIN
      TESTFIELD("Item No.");
      TESTFIELD("Qty. (Base)");
      CASE "Whse. Document Type" OF
        "Whse. Document Type"::Receipt:
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Posted Whse. Receipt Line");
        "Whse. Document Type"::Shipment:
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Warehouse Shipment Line");
        "Whse. Document Type"::"Internal Put-away":
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Whse. Internal Put-away Line");
        "Whse. Document Type"::"Internal Pick":
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Whse. Internal Pick Line");
        "Whse. Document Type"::Production:
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Prod. Order Component");
        "Whse. Document Type"::Assembly:
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Assembly Line");
        ELSE
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Whse. Worksheet Line");
      END;

      WhseItemTrackingForm.RUNMODAL;
    END;

    [External]
    PROCEDURE AvailableQtyToPick@38() : Decimal;
    BEGIN
      IF "Qty. per Unit of Measure" <> 0 THEN
        EXIT(ROUND(CalcAvailableQtyBase(FALSE) / "Qty. per Unit of Measure",0.00001));
      EXIT(0);
    END;

    [External]
    PROCEDURE InitLineWithItem@40(DocumentType@1007 : Option;DocumentNo@1001 : Code[20];DocumentLineNo@1002 : Integer;LocationCode@1003 : Code[10];ItemNo@1004 : Code[20];VariantCode@1000 : Code[10];Qty@1005 : Decimal;QtyToHandle@1008 : Decimal;QtyPerUoM@1006 : Decimal);
    BEGIN
      INIT;
      "Whse. Document Type" := DocumentType;
      "Whse. Document No." := DocumentNo;
      "Whse. Document Line No." := DocumentLineNo;
      "Location Code" := LocationCode;
      "Item No." := ItemNo;
      "Variant Code" := VariantCode;
      "Qty. (Base)" := Qty;
      "Qty. to Handle (Base)" := QtyToHandle;
      "Qty. per Unit of Measure" := QtyPerUoM;
    END;

    [External]
    PROCEDURE SetUpNewLine@28(WhseWkshTemplate@1003 : Code[10];WhseWkshName@1002 : Code[10];LocationCode@1001 : Code[10];SortingMethod@1000 : ' ,Item,Document,Shelf/Bin No.,Due Date,Ship-To';LineNo@1004 : Integer);
    BEGIN
      WhseWorksheetLine.RESET;
      WhseWorksheetLine.SETRANGE("Worksheet Template Name",WhseWkshTemplate);
      WhseWorksheetLine.SETRANGE(Name,WhseWkshName);
      WhseWorksheetLine.SETRANGE("Location Code",LocationCode);
      IF WhseWorksheetLine.COUNT = 0 THEN
        LastLineNo := 0
      ELSE
        LastLineNo := LineNo;

      "Worksheet Template Name" := WhseWkshTemplate;
      Name := WhseWkshName;
      "Location Code" := LocationCode;
      "Line No." := GetNextLineNo(SortingMethod);
      "Whse. Document Type" := "Whse. Document Type"::"Whse. Mov.-Worksheet";
      "Whse. Document No." := WhseWkshName;
      "Whse. Document Line No." := "Line No.";
    END;

    LOCAL PROCEDURE GetNextLineNo@31(SortMethod@1000 : ' ,Item,Document,Shelf/Bin No.,Due Date,Ship-To') : Integer;
    VAR
      WhseWorksheetLine2@1003 : Record 7326;
      HigherLineNo@1002 : Integer;
      LowerLineNo@1001 : Integer;
    BEGIN
      WhseWorksheetLine2.COPY(WhseWorksheetLine);
      IF SortMethod <> SortMethod::" " THEN
        EXIT(GetLastLineNo + 10000);

      WhseWorksheetLine2 := Rec;
      WhseWorksheetLine2."Line No." := LastLineNo;
      IF WhseWorksheetLine2.FIND('<') THEN
        LowerLineNo := WhseWorksheetLine2."Line No."
      ELSE
        IF WhseWorksheetLine2.FIND('>') THEN
          EXIT(LastLineNo DIV 2)
        ELSE
          EXIT(LastLineNo + 10000);

      WhseWorksheetLine2 := Rec;
      WhseWorksheetLine2."Line No." := LastLineNo;
      IF WhseWorksheetLine2.FIND('>') THEN
        HigherLineNo := LastLineNo
      ELSE
        EXIT(LastLineNo + 10000);
      EXIT(LowerLineNo + (HigherLineNo - LowerLineNo) DIV 2);
    END;

    LOCAL PROCEDURE GetLastLineNo@30() : Integer;
    VAR
      WhseWorksheetLine2@1000 : Record 7326;
    BEGIN
      WhseWorksheetLine2.COPYFILTERS(WhseWorksheetLine);
      IF WhseWorksheetLine2.FINDLAST THEN
        EXIT(WhseWorksheetLine2."Line No.");
      EXIT(0);
    END;

    [External]
    PROCEDURE GetSortSeqNo@33(SortMethod@1000 : ' ,Item,Document,Shelf/Bin No.,Due Date,Ship-To') : Integer;
    VAR
      WhseWorksheetLine2@1004 : Record 7326;
      HigherSeqNo@1002 : Integer;
      LowerSeqNo@1003 : Integer;
      LastSeqNo@1001 : Integer;
    BEGIN
      WhseWorksheetLine2 := Rec;
      WhseWorksheetLine2.SETRECFILTER;
      WhseWorksheetLine2.SETRANGE("Line No.");

      CASE SortMethod OF
        SortMethod::" ":
          WhseWorksheetLine2.SETCURRENTKEY(
            "Worksheet Template Name",Name,"Location Code","Line No.");
        SortMethod::Item:
          WhseWorksheetLine2.SETCURRENTKEY(
            "Worksheet Template Name",Name,"Location Code","Item No.");
        SortMethod::Document:
          WhseWorksheetLine2.SETCURRENTKEY(
            "Worksheet Template Name",Name,"Location Code","Source Document","Source No.");
        SortMethod::"Shelf/Bin No.":
          BEGIN
            GetLocation("Location Code");
            IF Location."Bin Mandatory" THEN
              WhseWorksheetLine2.SETCURRENTKEY(
                "Worksheet Template Name",Name,"Location Code","To Bin Code")
            ELSE
              WhseWorksheetLine2.SETCURRENTKEY(
                "Worksheet Template Name",Name,"Location Code","Shelf No.");
          END;
        SortMethod::"Due Date":
          WhseWorksheetLine2.SETCURRENTKEY(
            "Worksheet Template Name",Name,"Location Code","Due Date");
        SortMethod::"Ship-To":
          WhseWorksheetLine2.SETCURRENTKEY(
            "Worksheet Template Name",Name,"Location Code","Destination Type","Destination No.")
      END;

      LastSeqNo := GetLastSeqNo(WhseWorksheetLine2);
      IF WhseWorksheetLine2.FIND('<') THEN
        LowerSeqNo := WhseWorksheetLine2."Sorting Sequence No."
      ELSE
        IF WhseWorksheetLine2.FIND('>') THEN
          EXIT(WhseWorksheetLine2."Sorting Sequence No." DIV 2)
        ELSE
          LowerSeqNo := 10000;

      WhseWorksheetLine2 := Rec;
      IF WhseWorksheetLine2.FIND('>') THEN
        HigherSeqNo := WhseWorksheetLine2."Sorting Sequence No."
      ELSE
        IF WhseWorksheetLine2.FIND('<') THEN
          EXIT(LastSeqNo + 10000)
        ELSE
          HigherSeqNo := LastSeqNo;
      EXIT(LowerSeqNo + (HigherSeqNo - LowerSeqNo) DIV 2);
    END;

    LOCAL PROCEDURE GetLastSeqNo@32(WhseWorksheetLine2@1000 : Record 7326) : Integer;
    BEGIN
      WhseWorksheetLine2.SETRECFILTER;
      WhseWorksheetLine2.SETRANGE("Line No.");
      WhseWorksheetLine2.SETCURRENTKEY("Worksheet Template Name",Name,"Location Code","Sorting Sequence No.");
      IF WhseWorksheetLine2.FINDLAST THEN
        EXIT(WhseWorksheetLine2."Sorting Sequence No.");
      EXIT(0);
    END;

    [External]
    PROCEDURE SetItemTrackingLines@34(SerialNo@1000 : Code[20];LotNo@1001 : Code[20];ExpirationDate@1004 : Date;QtyToEmpty@1002 : Decimal);
    VAR
      WhseItemTrackingForm@1003 : Page 6550;
    BEGIN
      TESTFIELD("Item No.");
      TESTFIELD("Qty. (Base)");
      CASE "Whse. Document Type" OF
        "Whse. Document Type"::Receipt:
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Posted Whse. Receipt Line");
        "Whse. Document Type"::Shipment:
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Warehouse Shipment Line");
        "Whse. Document Type"::"Internal Put-away":
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Whse. Internal Put-away Line");
        "Whse. Document Type"::"Internal Pick":
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Whse. Internal Pick Line");
        "Whse. Document Type"::Production:
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Prod. Order Component");
        "Whse. Document Type"::Assembly:
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Assembly Line");
        ELSE
          WhseItemTrackingForm.SetSource(Rec,DATABASE::"Whse. Worksheet Line");
      END;

      WhseItemTrackingForm.InsertItemTrackingLine(Rec,SerialNo,LotNo,ExpirationDate,QtyToEmpty);
    END;

    [External]
    PROCEDURE SetCurrentFieldNo@39(FieldNo@1000 : Integer);
    BEGIN
      IF CurrentFieldNo <> CurrFieldNo THEN
        CurrentFieldNo := FieldNo;
    END;

    [External]
    PROCEDURE SetSourceFilter@42(SourceType@1004 : Integer;SourceSubType@1003 : Option;SourceNo@1002 : Code[20];SourceLineNo@1001 : Integer;SetKey@1005 : Boolean);
    BEGIN
      IF SetKey THEN
        SETCURRENTKEY("Source Type","Source Subtype","Source No.","Source Line No.");
      SETRANGE("Source Type",SourceType);
      IF SourceSubType >= 0 THEN
        SETRANGE("Source Subtype",SourceSubType);
      SETRANGE("Source No.",SourceNo);
      IF SourceLineNo >= 0 THEN
        SETRANGE("Source Line No.",SourceLineNo);
    END;

    BEGIN
    END.
  }
}

