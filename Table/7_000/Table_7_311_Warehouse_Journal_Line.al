OBJECT Table 7311 Warehouse Journal Line
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               "User ID" := USERID;
             END;

    OnModify=BEGIN
               IF "User ID" = '' THEN
                 "User ID" := USERID;
             END;

    OnDelete=BEGIN
               ItemTrackingMgt.DeleteWhseItemTrkgLines(
                 DATABASE::"Warehouse Journal Line",0,"Journal Batch Name",
                 "Journal Template Name",0,"Line No.","Location Code",TRUE);
             END;

    CaptionML=[DAN=Lagerkladdelinje;
               ENU=Warehouse Journal Line];
    LookupPageID=Page7319;
    DrillDownPageID=Page7319;
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code10       ;TableRelation="Warehouse Journal Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name] }
    { 2   ;   ;Journal Batch Name  ;Code10        ;TableRelation="Warehouse Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 3   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 4   ;   ;Registering Date    ;Date          ;CaptionML=[DAN=Registreringsdato;
                                                              ENU=Registering Date] }
    { 5   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 6   ;   ;From Zone Code      ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                IF "From Zone Code" <> xRec."From Zone Code" THEN BEGIN
                                                                  "From Bin Code" := '';
                                                                  "From Bin Type Code" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Fra zonekode;
                                                              ENU=From Zone Code] }
    { 7   ;   ;From Bin Code       ;Code20        ;TableRelation=IF (Phys. Inventory=CONST(No),
                                                                     Item No.=FILTER(''),
                                                                     From Zone Code=FILTER('')) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code))
                                                                     ELSE IF (Phys. Inventory=CONST(No),
                                                                              Item No.=FILTER(<>''),
                                                                              From Zone Code=FILTER('')) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                         Item No.=FIELD(Item No.))
                                                                                                                                         ELSE IF (Phys. Inventory=CONST(No),
                                                                                                                                                  Item No.=FILTER(''),
                                                                                                                                                  From Zone Code=FILTER(<>'')) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                               Zone Code=FIELD(From Zone Code))
                                                                                                                                                                                                               ELSE IF (Phys. Inventory=CONST(No),
                                                                                                                                                                                                                        Item No.=FILTER(<>''),
                                                                                                                                                                                                                        From Zone Code=FILTER(<>'')) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                                                                                                     Item No.=FIELD(Item No.),
                                                                                                                                                                                                                                                                                     Zone Code=FIELD(From Zone Code))
                                                                                                                                                                                                                                                                                     ELSE IF (Phys. Inventory=CONST(Yes),
                                                                                                                                                                                                                                                                                              From Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                                                                                                                                                                                                                                                                                              ELSE IF (Phys. Inventory=CONST(Yes),
                                                                                                                                                                                                                                                                                                       From Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                                                                                                                                                                    Zone Code=FIELD(From Zone Code));
                                                   OnValidate=BEGIN
                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                IF CurrFieldNo = FIELDNO("From Bin Code") THEN
                                                                  IF "From Bin Code" <> xRec."From Bin Code" THEN
                                                                    CheckBin("Location Code","From Bin Code",FALSE);

                                                                "From Bin Type Code" :=
                                                                  GetBinType("Location Code","From Bin Code");

                                                                Bin.CALCFIELDS("Adjustment Bin");
                                                                IF Bin."Adjustment Bin" AND ("Entry Type" <> "Entry Type"::"Positive Adjmt.") THEN
                                                                  Bin.FIELDERROR("Adjustment Bin");

                                                                IF "From Bin Code" <> '' THEN
                                                                  "From Zone Code" := Bin."Zone Code";
                                                              END;

                                                   CaptionML=[DAN=Fra placeringskode;
                                                              ENU=From Bin Code] }
    { 8   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 9   ;   ;Item No.            ;Code20        ;TableRelation=Item WHERE (Type=CONST(Inventory));
                                                   OnValidate=BEGIN
                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                IF "Item No." <> '' THEN BEGIN
                                                                  IF "Item No." <> xRec."Item No." THEN
                                                                    "Variant Code" := '';
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
    { 10  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                WhseJnlTemplate.GET("Journal Template Name");
                                                                IF WhseJnlTemplate.Type = WhseJnlTemplate.Type::Reclassification THEN BEGIN
                                                                  IF Quantity < 0 THEN
                                                                    FIELDERROR(Quantity,Text000);
                                                                END ELSE BEGIN
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Adjustment Bin Code");
                                                                END;

                                                                "Qty. (Base)" := CalcBaseQty(Quantity);
                                                                "Qty. (Absolute)" := ABS(Quantity);
                                                                "Qty. (Absolute, Base)" := ABS("Qty. (Base)");
                                                                IF (xRec.Quantity < 0) AND (Quantity >= 0) OR
                                                                   (xRec.Quantity >= 0) AND (Quantity < 0)
                                                                THEN
                                                                  ExchangeFromToBin;

                                                                IF Quantity > 0 THEN
                                                                  WMSMgt.CalcCubageAndWeight(
                                                                    "Item No.","Unit of Measure Code","Qty. (Absolute)",Cubage,Weight)
                                                                ELSE BEGIN
                                                                  Cubage := 0;
                                                                  Weight := 0;
                                                                END;

                                                                IF Quantity <> xRec.Quantity THEN BEGIN
                                                                  CheckBin("Location Code","From Bin Code",FALSE);
                                                                  CheckBin("Location Code","To Bin Code",TRUE);
                                                                END;

                                                                ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.",SNRequired,LNRequired,FALSE);
                                                                IF SNRequired AND NOT "Phys. Inventory" AND
                                                                   ("Serial No." <> '') AND ((Quantity < 0) OR (Quantity > 1))
                                                                THEN
                                                                  ERROR(Text006,FIELDCAPTION(Quantity));
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 11  ;   ;Qty. (Base)         ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Qty. (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Qty. (Base)];
                                                   DecimalPlaces=0:5 }
    { 12  ;   ;Qty. (Absolute)     ;Decimal       ;OnValidate=BEGIN
                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                "Qty. (Absolute, Base)" := CalcBaseQty("Qty. (Absolute)");

                                                                IF Quantity > 0 THEN
                                                                  WMSMgt.CalcCubageAndWeight(
                                                                    "Item No.","Unit of Measure Code","Qty. (Absolute)",Cubage,Weight)
                                                                ELSE BEGIN
                                                                  Cubage := 0;
                                                                  Weight := 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Antal (absolut);
                                                              ENU=Qty. (Absolute)];
                                                   DecimalPlaces=0:5 }
    { 13  ;   ;Qty. (Absolute, Base);Decimal      ;OnValidate=VAR
                                                                NewValue@1000 : Decimal;
                                                              BEGIN
                                                                NewValue := ROUND("Qty. (Absolute, Base)",0.00001);
                                                                VALIDATE(Quantity,CalcQty("Qty. (Absolute, Base)") * Quantity / ABS(Quantity));
                                                                // Take care of rounding issues
                                                                "Qty. (Absolute, Base)" := NewValue;
                                                                "Qty. (Base)" := NewValue * "Qty. (Base)" / ABS("Qty. (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal (absolut, basis);
                                                              ENU=Qty. (Absolute, Base)];
                                                   DecimalPlaces=0:5 }
    { 14  ;   ;Zone Code           ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                IF "Zone Code" <> xRec."Zone Code" THEN
                                                                  "Bin Code" := '';

                                                                IF Quantity < 0 THEN
                                                                  VALIDATE("From Zone Code","Zone Code")
                                                                ELSE
                                                                  VALIDATE("To Zone Code","Zone Code");
                                                              END;

                                                   CaptionML=[DAN=Zonekode;
                                                              ENU=Zone Code] }
    { 15  ;   ;Bin Code            ;Code20        ;TableRelation=IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                                                                 ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                  Zone Code=FIELD(Zone Code));
                                                   OnValidate=BEGIN
                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                IF Quantity < 0 THEN BEGIN
                                                                  VALIDATE("From Bin Code","Bin Code");
                                                                  IF "Bin Code" <> xRec."Bin Code" THEN
                                                                    CheckBin("Location Code","Bin Code",FALSE);
                                                                END ELSE BEGIN
                                                                  VALIDATE("To Bin Code","Bin Code");
                                                                  IF "Bin Code" <> xRec."Bin Code" THEN
                                                                    CheckBin("Location Code","Bin Code",TRUE);
                                                                END;

                                                                IF "Bin Code" <> '' THEN BEGIN
                                                                  GetBin("Location Code","Bin Code");
                                                                  "Zone Code" := Bin."Zone Code";
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 20  ;   ;Source Type         ;Integer       ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   Editable=No }
    { 21  ;   ;Source Subtype      ;Option        ;CaptionML=[DAN=Kildeundertype;
                                                              ENU=Source Subtype];
                                                   OptionCaptionML=[DAN=0,1,2,3,4,5,6,7,8,9,10;
                                                                    ENU=0,1,2,3,4,5,6,7,8,9,10];
                                                   OptionString=0,1,2,3,4,5,6,7,8,9,10;
                                                   Editable=No }
    { 22  ;   ;Source No.          ;Code20        ;CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.];
                                                   Editable=No }
    { 23  ;   ;Source Line No.     ;Integer       ;CaptionML=[DAN=Kildelinjenr.;
                                                              ENU=Source Line No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 24  ;   ;Source Subline No.  ;Integer       ;CaptionML=[DAN=Kildeunderlinjenr.;
                                                              ENU=Source Subline No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 25  ;   ;Source Document     ;Option        ;CaptionML=[DAN=Kildedokument;
                                                              ENU=Source Document];
                                                   OptionCaptionML=[DAN=,S.ordre,S.faktura,S.kreditnota,S.returv.ordre,K.ordre,K.faktura,K.kreditnota,K.returv.ordre,Indg. overf�r.,Udg. overf�r.,Prod.forbrug,Varekld.,Lageropg.kld.,Ompost.kld.,Forbrugskld.,Afgangskld.,Styklistekld.,Serv.ordre,Sagskld.,Montageforbrug,Montageordre;
                                                                    ENU=,S. Order,S. Invoice,S. Credit Memo,S. Return Order,P. Order,P. Invoice,P. Credit Memo,P. Return Order,Inb. Transfer,Outb. Transfer,Prod. Consumption,Item Jnl.,Phys. Invt. Jnl.,Reclass. Jnl.,Consumption Jnl.,Output Jnl.,BOM Jnl.,Serv Order,Job Jnl.,Assembly Consumption,Assembly Order];
                                                   OptionString=,S. Order,S. Invoice,S. Credit Memo,S. Return Order,P. Order,P. Invoice,P. Credit Memo,P. Return Order,Inb. Transfer,Outb. Transfer,Prod. Consumption,Item Jnl.,Phys. Invt. Jnl.,Reclass. Jnl.,Consumption Jnl.,Output Jnl.,BOM Jnl.,Serv Order,Job Jnl.,Assembly Consumption,Assembly Order;
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 26  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code];
                                                   Editable=No }
    { 27  ;   ;To Zone Code        ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                IF "To Zone Code" <> xRec."To Zone Code" THEN
                                                                  "To Bin Code" := '';
                                                              END;

                                                   CaptionML=[DAN=Til zonekode;
                                                              ENU=To Zone Code] }
    { 28  ;   ;To Bin Code         ;Code20        ;TableRelation=IF (To Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                                                                 ELSE IF (To Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                     Zone Code=FIELD(To Zone Code));
                                                   OnValidate=BEGIN
                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                IF CurrFieldNo = FIELDNO("To Bin Code") THEN
                                                                  IF "To Bin Code" <> xRec."To Bin Code" THEN
                                                                    CheckBin("Location Code","To Bin Code",TRUE);

                                                                GetBin("Location Code","To Bin Code");

                                                                Bin.CALCFIELDS("Adjustment Bin");
                                                                IF Bin."Adjustment Bin" AND ("Entry Type" <> "Entry Type"::"Negative Adjmt.") THEN
                                                                  Bin.FIELDERROR("Adjustment Bin");

                                                                IF "To Bin Code" <> '' THEN
                                                                  "To Zone Code" := Bin."Zone Code";
                                                              END;

                                                   CaptionML=[DAN=Til placeringskode;
                                                              ENU=To Bin Code] }
    { 29  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 33  ;   ;Registering No. Series;Code20      ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Registreringsnr.serie;
                                                              ENU=Registering No. Series] }
    { 35  ;   ;From Bin Type Code  ;Code10        ;TableRelation="Bin Type";
                                                   CaptionML=[DAN=Fra placeringstypekode;
                                                              ENU=From Bin Type Code] }
    { 40  ;   ;Cubage              ;Decimal       ;CaptionML=[DAN=Rumm�l;
                                                              ENU=Cubage];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 41  ;   ;Weight              ;Decimal       ;CaptionML=[DAN=V�gt;
                                                              ENU=Weight];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 50  ;   ;Whse. Document No.  ;Code20        ;CaptionML=[DAN=Lagerdokumentnr.;
                                                              ENU=Whse. Document No.] }
    { 51  ;   ;Whse. Document Type ;Option        ;CaptionML=[DAN=Lagerdokumenttype;
                                                              ENU=Whse. Document Type];
                                                   OptionCaptionML=[DAN=Lagerkladde,Modtagelse,Leverance,Internt l�g-p�-lager,Internt pluk,Produktion,Lagerplac.opg., ,Montage;
                                                                    ENU=Whse. Journal,Receipt,Shipment,Internal Put-away,Internal Pick,Production,Whse. Phys. Inventory, ,Assembly];
                                                   OptionString=Whse. Journal,Receipt,Shipment,Internal Put-away,Internal Pick,Production,Whse. Phys. Inventory, ,Assembly }
    { 52  ;   ;Whse. Document Line No.;Integer    ;CaptionML=[DAN=Lagerdokumentlinjenr.;
                                                              ENU=Whse. Document Line No.];
                                                   BlankZero=Yes }
    { 53  ;   ;Qty. (Calculated)   ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Qty. (Phys. Inventory)");
                                                              END;

                                                   CaptionML=[DAN=Antal (beregnet);
                                                              ENU=Qty. (Calculated)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 54  ;   ;Qty. (Phys. Inventory);Decimal     ;OnValidate=BEGIN
                                                                TESTFIELD("Phys. Inventory",TRUE);

                                                                IF "Serial No." <> '' THEN
                                                                  IF ("Qty. (Phys. Inventory)" < 0) OR ("Qty. (Phys. Inventory)" > 1) THEN
                                                                    ERROR(Text006,FIELDCAPTION("Qty. (Phys. Inventory)"));

                                                                PhysInvtEntered := TRUE;
                                                                Quantity := 0;
                                                                VALIDATE(Quantity,"Qty. (Phys. Inventory)" - "Qty. (Calculated)");
                                                                IF "Qty. (Phys. Inventory)" = "Qty. (Calculated)" THEN
                                                                  VALIDATE("Qty. (Phys. Inventory) (Base)","Qty. (Calculated) (Base)")
                                                                ELSE
                                                                  VALIDATE("Qty. (Phys. Inventory) (Base)",ROUND("Qty. (Phys. Inventory)" * "Qty. per Unit of Measure",0.00001));
                                                                PhysInvtEntered := FALSE;
                                                              END;

                                                   CaptionML=[DAN=Antal (optalt);
                                                              ENU=Qty. (Phys. Inventory)];
                                                   DecimalPlaces=0:5 }
    { 55  ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Nedregulering,Opregulering,Bev�gelse;
                                                                    ENU=Negative Adjmt.,Positive Adjmt.,Movement];
                                                   OptionString=Negative Adjmt.,Positive Adjmt.,Movement }
    { 56  ;   ;Phys. Inventory     ;Boolean       ;CaptionML=[DAN=Lageropg�relse;
                                                              ENU=Phys. Inventory];
                                                   Editable=No }
    { 60  ;   ;Reference Document  ;Option        ;CaptionML=[DAN=Referencedokument;
                                                              ENU=Reference Document];
                                                   OptionCaptionML=[DAN=" ,Bogf�rt modt.,Bogf. k�bsfakt.,Bogf. returv.modt.,Bogf. k�bskred.nota,Bogf. leverance,Bogf. salgsfakt.,Bogf. returv.leverance,Bogf. salgskred.nota,Bogf. overf�r.kvit.,Bogf. overf�r.lev.,Varekladde,Prod.,L�g-p�-lager,Pluk,Bev�gelse,Styklistekld.,Sagskladde,Montage";
                                                                    ENU=" ,Posted Rcpt.,Posted P. Inv.,Posted Rtrn. Rcpt.,Posted P. Cr. Memo,Posted Shipment,Posted S. Inv.,Posted Rtrn. Shipment,Posted S. Cr. Memo,Posted T. Receipt,Posted T. Shipment,Item Journal,Prod.,Put-away,Pick,Movement,BOM Journal,Job Journal,Assembly"];
                                                   OptionString=[ ,Posted Rcpt.,Posted P. Inv.,Posted Rtrn. Rcpt.,Posted P. Cr. Memo,Posted Shipment,Posted S. Inv.,Posted Rtrn. Shipment,Posted S. Cr. Memo,Posted T. Receipt,Posted T. Shipment,Item Journal,Prod.,Put-away,Pick,Movement,BOM Journal,Job Journal,Assembly] }
    { 61  ;   ;Reference No.       ;Code20        ;CaptionML=[DAN=Referencenr.;
                                                              ENU=Reference No.] }
    { 67  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 68  ;   ;Qty. (Calculated) (Base);Decimal   ;CaptionML=[DAN=Antal (beregnet) (basis);
                                                              ENU=Qty. (Calculated) (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 69  ;   ;Qty. (Phys. Inventory) (Base);Decimal;
                                                   OnValidate=BEGIN
                                                                "Qty. (Base)" := "Qty. (Phys. Inventory) (Base)" - "Qty. (Calculated) (Base)";
                                                                "Qty. (Absolute, Base)" := ABS("Qty. (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal (Optalt) (basis);
                                                              ENU=Qty. (Phys. Inventory) (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=VAR
                                                                ItemVariant@1000 : Record 5401;
                                                              BEGIN
                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                IF "Variant Code" <> '' THEN BEGIN
                                                                  ItemVariant.GET("Item No.","Variant Code");
                                                                  Description := ItemVariant.Description;
                                                                END ELSE
                                                                  GetItem("Item No.",Description);

                                                                IF "Variant Code" <> xRec."Variant Code" THEN BEGIN
                                                                  CheckBin("Location Code","From Bin Code",FALSE);
                                                                  CheckBin("Location Code","To Bin Code",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5407;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=BEGIN
                                                                IF NOT PhysInvtEntered THEN
                                                                  TESTFIELD("Phys. Inventory",FALSE);

                                                                IF "Item No." <> '' THEN BEGIN
                                                                  TESTFIELD("Unit of Measure Code");
                                                                  GetItemUnitOfMeasure;
                                                                  "Qty. per Unit of Measure" := ItemUnitOfMeasure."Qty. per Unit of Measure";
                                                                  CheckBin("Location Code","From Bin Code",FALSE);
                                                                  CheckBin("Location Code","To Bin Code",TRUE);
                                                                END ELSE
                                                                  "Qty. per Unit of Measure" := 1;
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 6500;   ;Serial No.          ;Code20        ;OnValidate=BEGIN
                                                                IF "Serial No." <> '' THEN
                                                                  ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.",SNRequired,LNRequired,TRUE);

                                                                IF (Quantity < 0) OR (Quantity > 1) THEN
                                                                  ERROR(Text006,FIELDCAPTION(Quantity));
                                                              END;

                                                   OnLookup=BEGIN
                                                              ItemTrackingMgt.LookupLotSerialNoInfo("Item No.","Variant Code",0,"Serial No.");
                                                            END;

                                                   CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.] }
    { 6501;   ;Lot No.             ;Code20        ;OnValidate=BEGIN
                                                                IF "Lot No." <> '' THEN
                                                                  ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.",SNRequired,LNRequired,TRUE);
                                                              END;

                                                   OnLookup=BEGIN
                                                              ItemTrackingMgt.LookupLotSerialNoInfo("Item No.","Variant Code",1,"Lot No.");
                                                            END;

                                                   CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.] }
    { 6502;   ;Warranty Date       ;Date          ;CaptionML=[DAN=Garantioph�r den;
                                                              ENU=Warranty Date];
                                                   Editable=No }
    { 6503;   ;Expiration Date     ;Date          ;CaptionML=[DAN=Udl�bsdato;
                                                              ENU=Expiration Date];
                                                   Editable=No }
    { 6504;   ;New Serial No.      ;Code20        ;CaptionML=[DAN=Nyt serienr.;
                                                              ENU=New Serial No.];
                                                   Editable=No }
    { 6505;   ;New Lot No.         ;Code20        ;CaptionML=[DAN=Nyt lotnr.;
                                                              ENU=New Lot No.];
                                                   Editable=No }
    { 6506;   ;New Expiration Date ;Date          ;CaptionML=[DAN=Ny udl�bsdato;
                                                              ENU=New Expiration Date];
                                                   Editable=No }
    { 7380;   ;Phys Invt Counting Period Code;Code10;
                                                   TableRelation="Phys. Invt. Counting Period";
                                                   CaptionML=[DAN=Lageropg.-opt�llingsperiodekode;
                                                              ENU=Phys Invt Counting Period Code];
                                                   Editable=No }
    { 7381;   ;Phys Invt Counting Period Type;Option;
                                                   AccessByPermission=TableData 7380=R;
                                                   CaptionML=[DAN=Lageropg.-opt�llingsperiodetype;
                                                              ENU=Phys Invt Counting Period Type];
                                                   OptionCaptionML=[DAN=" ,Vare,Lagervare";
                                                                    ENU=" ,Item,SKU"];
                                                   OptionString=[ ,Item,SKU];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Journal Template Name,Journal Batch Name,Location Code,Line No.;
                                                   Clustered=Yes }
    {    ;Item No.,Location Code,Entry Type,From Bin Type Code,Variant Code,Unit of Measure Code;
                                                   SumIndexFields="Qty. (Absolute, Base)";
                                                   MaintainSIFTIndex=No }
    {    ;Item No.,From Bin Code,Location Code,Entry Type,Variant Code,Unit of Measure Code,Lot No.,Serial No.;
                                                   SumIndexFields="Qty. (Absolute, Base)",Qty. (Absolute),Cubage,Weight;
                                                   MaintainSIFTIndex=No }
    {    ;Item No.,To Bin Code,Location Code,Variant Code,Unit of Measure Code,Lot No.,Serial No.;
                                                   SumIndexFields="Qty. (Absolute, Base)",Qty. (Absolute);
                                                   MaintainSIFTIndex=No }
    {    ;To Bin Code,Location Code               ;SumIndexFields=Cubage,Weight,Qty. (Absolute);
                                                   MaintainSIFTIndex=No }
    {    ;Location Code,Item No.,Variant Code      }
    {    ;Location Code,Bin Code,Item No.,Variant Code }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Location@1001 : Record 14;
      Item@1000 : Record 27;
      Bin@1015 : Record 7354;
      WhseJnlTemplate@1004 : Record 7309;
      WhseJnlBatch@1003 : Record 7310;
      WhseJnlLine@1005 : Record 7311;
      ItemUnitOfMeasure@1002 : Record 5404;
      NoSeriesMgt@1006 : Codeunit 396;
      WMSMgt@1007 : Codeunit 7302;
      ItemTrackingMgt@1016 : Codeunit 6500;
      OldItemNo@1055 : Code[20];
      PhysInvtEntered@1008 : Boolean;
      Text000@1009 : TextConst 'DAN=m� ikke v�re negativ;ENU=must not be negative';
      Text001@1014 : TextConst 'DAN=%1kladde;ENU=%1 Journal';
      Text002@1013 : TextConst 'DAN=STANDARD;ENU=DEFAULT';
      Text003@1012 : TextConst 'DAN=Standardkladde;ENU=Default Journal';
      Text005@1011 : TextConst 'DAN=Lokationen %1 for lagerkladdenavnet %2 er ikke aktiveret for brugeren %3.;ENU=The location %1 of warehouse journal batch %2 is not enabled for user %3.';
      Text006@1017 : TextConst 'DAN=%1 skal v�re 0 eller 1 for en vare der, spores ved hj�lp af serienummer.;ENU=%1 must be 0 or 1 for an Item tracked by Serial Number.';
      SNRequired@1019 : Boolean;
      LNRequired@1018 : Boolean;
      OpenFromBatch@1020 : Boolean;
      StockProposal@1021 : Boolean;

    [External]
    PROCEDURE GetItem@18(ItemNo@1000 : Code[20];VAR ItemDescription@1001 : Text[50]);
    BEGIN
      IF ItemNo <> OldItemNo THEN BEGIN
        ItemDescription := '';
        IF ItemNo <> '' THEN
          IF Item.GET(ItemNo) THEN
            ItemDescription := Item.Description;
        OldItemNo := ItemNo;
      END ELSE
        ItemDescription := Item.Description;
    END;

    [External]
    PROCEDURE SetUpNewLine@8(LastWhseJnlLine@1000 : Record 7311);
    BEGIN
      WhseJnlTemplate.GET("Journal Template Name");
      WhseJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      WhseJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      WhseJnlLine.SETRANGE("Location Code","Location Code");
      IF WhseJnlLine.FINDFIRST THEN BEGIN
        WhseJnlBatch.GET(
          "Journal Template Name","Journal Batch Name",LastWhseJnlLine."Location Code");
        "Registering Date" := LastWhseJnlLine."Registering Date";
        "Whse. Document No." := LastWhseJnlLine."Whse. Document No.";
        "Entry Type" := LastWhseJnlLine."Entry Type";
        "Location Code" := LastWhseJnlLine."Location Code";
      END ELSE BEGIN
        "Registering Date" := WORKDATE;
        WhseJnlBatch.GET("Journal Template Name","Journal Batch Name","Location Code");
        IF WhseJnlBatch."No. Series" <> '' THEN BEGIN
          CLEAR(NoSeriesMgt);
          "Whse. Document No." :=
            NoSeriesMgt.TryGetNextNo(WhseJnlBatch."No. Series","Registering Date");
        END;
      END;
      IF WhseJnlTemplate.Type = WhseJnlTemplate.Type::"Physical Inventory" THEN BEGIN
        "Source Document" := "Source Document"::"Phys. Invt. Jnl.";
        "Whse. Document Type" := "Whse. Document Type"::"Whse. Phys. Inventory";
      END;
      "Source Code" := WhseJnlTemplate."Source Code";
      "Reason Code" := WhseJnlBatch."Reason Code";
      "Registering No. Series" := WhseJnlBatch."Registering No. Series";
      IF WhseJnlTemplate.Type <> WhseJnlTemplate.Type::Reclassification THEN BEGIN
        IF Quantity >= 0 THEN
          "Entry Type" := "Entry Type"::"Positive Adjmt."
        ELSE
          "Entry Type" := "Entry Type"::"Negative Adjmt.";
        SetUpAdjustmentBin;
      END ELSE
        "Entry Type" := "Entry Type"::Movement;
    END;

    [External]
    PROCEDURE SetUpAdjustmentBin@100();
    VAR
      Location@1001 : Record 14;
    BEGIN
      WhseJnlTemplate.GET("Journal Template Name");
      IF WhseJnlTemplate.Type = WhseJnlTemplate.Type::Reclassification THEN
        EXIT;

      Location.GET("Location Code");
      GetBin(Location.Code,Location."Adjustment Bin Code");
      CASE "Entry Type" OF
        "Entry Type"::"Positive Adjmt.":
          BEGIN
            "From Zone Code" := Bin."Zone Code";
            "From Bin Code" := Bin.Code;
            "From Bin Type Code" := Bin."Bin Type Code";
          END;
        "Entry Type"::"Negative Adjmt.":
          BEGIN
            "To Zone Code" := Bin."Zone Code";
            "To Bin Code" := Bin.Code;
          END;
      END;
    END;

    LOCAL PROCEDURE CalcBaseQty@14(Qty@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE CalcQty@3(QtyBase@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(QtyBase / "Qty. per Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE GetItemUnitOfMeasure@1();
    BEGIN
      GetItem("Item No.",Description);
      IF (Item."No." <> ItemUnitOfMeasure."Item No.") OR
         ("Unit of Measure Code" <> ItemUnitOfMeasure.Code)
      THEN
        IF NOT ItemUnitOfMeasure.GET(Item."No.","Unit of Measure Code") THEN
          ItemUnitOfMeasure.GET(Item."No.",Item."Base Unit of Measure");
    END;

    [External]
    PROCEDURE EmptyLine@5() : Boolean;
    BEGIN
      EXIT(
        ("Item No." = '') AND (Quantity = 0));
    END;

    LOCAL PROCEDURE ExchangeFromToBin@16();
    VAR
      WhseJnlLine@1001 : Record 7311;
    BEGIN
      GetLocation("Location Code");
      WhseJnlLine := Rec;
      "From Zone Code" := WhseJnlLine."To Zone Code";
      "From Bin Code" := WhseJnlLine."To Bin Code";
      "From Bin Type Code" :=
        GetBinType("Location Code","From Bin Code");
      IF ("Location Code" = Location.Code) AND
         ("From Bin Code" = Location."Adjustment Bin Code")
      THEN
        WMSMgt.CheckAdjmtBin(Location,"Qty. (Absolute)",Quantity > 0);

      "To Zone Code" := WhseJnlLine."From Zone Code";
      "To Bin Code" := WhseJnlLine."From Bin Code";
      IF ("Location Code" = Location.Code) AND
         ("To Bin Code" = Location."Adjustment Bin Code")
      THEN
        WMSMgt.CheckAdjmtBin(Location,"Qty. (Absolute)",Quantity > 0);

      IF WhseJnlTemplate.Type <> WhseJnlTemplate.Type::Reclassification THEN BEGIN
        IF Quantity >= 0 THEN
          "Entry Type" := "Entry Type"::"Positive Adjmt."
        ELSE
          "Entry Type" := "Entry Type"::"Negative Adjmt.";
        SetUpAdjustmentBin;
      END;
    END;

    LOCAL PROCEDURE GetLocation@2(LocationCode@1000 : Code[10]);
    BEGIN
      IF Location.Code <> LocationCode THEN
        Location.GET(LocationCode);
      Location.TESTFIELD("Directed Put-away and Pick");
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

    LOCAL PROCEDURE CheckBin@4(LocationCode@1000 : Code[10];BinCode@1001 : Code[20];Inbound@1002 : Boolean);
    VAR
      BinContent@1003 : Record 7302;
      WhseJnlLine@1007 : Record 7311;
    BEGIN
      IF (BinCode <> '') AND ("Item No." <> '') THEN BEGIN
        GetLocation(LocationCode);
        IF BinCode = Location."Adjustment Bin Code" THEN
          EXIT;
        BinContent.SetProposalMode(StockProposal);
        IF Inbound THEN BEGIN
          GetBinType(LocationCode,BinCode);
          IF Location."Bin Capacity Policy" IN
             [Location."Bin Capacity Policy"::"Allow More Than Max. Capacity",
              Location."Bin Capacity Policy"::"Prohibit More Than Max. Cap."]
          THEN BEGIN
            WhseJnlLine.SETCURRENTKEY("To Bin Code","Location Code");
            WhseJnlLine.SETRANGE("To Bin Code",BinCode);
            WhseJnlLine.SETRANGE("Location Code",LocationCode);
            WhseJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
            WhseJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
            WhseJnlLine.SETRANGE("Line No.","Line No.");
            WhseJnlLine.CALCSUMS("Qty. (Absolute)",Cubage,Weight);
          END;
          IF BinContent.GET(
               "Location Code",BinCode,"Item No.","Variant Code","Unit of Measure Code")
          THEN
            BinContent.CheckIncreaseBinContent(
              "Qty. (Absolute, Base)",WhseJnlLine."Qty. (Absolute, Base)",
              WhseJnlLine.Cubage,WhseJnlLine.Weight,Cubage,Weight,FALSE,FALSE)
          ELSE BEGIN
            GetBin(LocationCode,BinCode);
            Bin.CheckIncreaseBin(
              BinCode,"Item No.","Qty. (Absolute)",
              WhseJnlLine.Cubage,WhseJnlLine.Weight,Cubage,Weight,FALSE,FALSE);
          END;
        END ELSE BEGIN
          BinContent.GET(
            "Location Code",BinCode,"Item No.","Variant Code","Unit of Measure Code");
          IF BinContent."Block Movement" IN [
                                             BinContent."Block Movement"::Outbound,BinContent."Block Movement"::All]
          THEN
            IF NOT StockProposal THEN
              BinContent.FIELDERROR("Block Movement");
        END;
        BinContent.SetProposalMode(FALSE);
      END;
    END;

    LOCAL PROCEDURE GetBinType@20(LocationCode@1002 : Code[10];BinCode@1001 : Code[20]) : Code[10];
    VAR
      BinType@1000 : Record 7303;
    BEGIN
      GetBin(LocationCode,BinCode);
      WhseJnlTemplate.GET("Journal Template Name");
      IF WhseJnlTemplate.Type = WhseJnlTemplate.Type::Reclassification THEN
        IF Bin."Bin Type Code" <> '' THEN
          IF BinType.GET(Bin."Bin Type Code") THEN
            BinType.TESTFIELD(Receive,FALSE);

      EXIT(Bin."Bin Type Code");
    END;

    [External]
    PROCEDURE TemplateSelection@13(PageID@1004 : Integer;PageTemplate@1000 : 'Adjustment,Phys. Inventory,Reclassification';VAR WhseJnlLine@1003 : Record 7311;VAR JnlSelected@1001 : Boolean);
    VAR
      WhseJnlTemplate@1002 : Record 7309;
    BEGIN
      JnlSelected := TRUE;

      WhseJnlTemplate.RESET;
      IF NOT OpenFromBatch THEN
        WhseJnlTemplate.SETRANGE("Page ID",PageID);
      WhseJnlTemplate.SETRANGE(Type,PageTemplate);

      CASE WhseJnlTemplate.COUNT OF
        0:
          BEGIN
            WhseJnlTemplate.INIT;
            WhseJnlTemplate.VALIDATE(Type,PageTemplate);
            WhseJnlTemplate.VALIDATE("Page ID");
            WhseJnlTemplate.Name := FORMAT(WhseJnlTemplate.Type,MAXSTRLEN(WhseJnlTemplate.Name));
            WhseJnlTemplate.Description := STRSUBSTNO(Text001,WhseJnlTemplate.Type);
            WhseJnlTemplate.INSERT;
            COMMIT;
          END;
        1:
          WhseJnlTemplate.FINDFIRST;
        ELSE
          JnlSelected := PAGE.RUNMODAL(0,WhseJnlTemplate) = ACTION::LookupOK;
      END;
      IF JnlSelected THEN BEGIN
        WhseJnlLine.FILTERGROUP := 2;
        WhseJnlLine.SETRANGE("Journal Template Name",WhseJnlTemplate.Name);
        WhseJnlLine.FILTERGROUP := 0;
        IF OpenFromBatch THEN BEGIN
          WhseJnlLine."Journal Template Name" := '';
          PAGE.RUN(WhseJnlTemplate."Page ID",WhseJnlLine);
        END;
      END;
    END;

    [External]
    PROCEDURE TemplateSelectionFromBatch@21(VAR WhseJnlBatch@1000 : Record 7310);
    VAR
      WhseJnlLine@1002 : Record 7311;
      JnlSelected@1001 : Boolean;
    BEGIN
      OpenFromBatch := TRUE;
      WhseJnlBatch.CALCFIELDS("Template Type");
      WhseJnlLine."Journal Batch Name" := WhseJnlBatch.Name;
      WhseJnlLine."Location Code" := WhseJnlBatch."Location Code";
      TemplateSelection(0,WhseJnlBatch."Template Type",WhseJnlLine,JnlSelected);
    END;

    [External]
    PROCEDURE OpenJnl@12(VAR CurrentJnlBatchName@1000 : Code[10];VAR CurrentLocationCode@1002 : Code[10];VAR WhseJnlLine@1001 : Record 7311);
    BEGIN
      WMSMgt.CheckUserIsWhseEmployee;
      CheckTemplateName(
        WhseJnlLine.GETRANGEMAX("Journal Template Name"),CurrentLocationCode,CurrentJnlBatchName);
      WhseJnlLine.FILTERGROUP := 2;
      WhseJnlLine.SETRANGE("Journal Batch Name",CurrentJnlBatchName);
      IF CurrentLocationCode <> '' THEN
        WhseJnlLine.SETRANGE("Location Code",CurrentLocationCode);
      WhseJnlLine.FILTERGROUP := 0;
    END;

    LOCAL PROCEDURE CheckTemplateName@11(CurrentJnlTemplateName@1000 : Code[10];VAR CurrentLocationCode@1005 : Code[10];VAR CurrentJnlBatchName@1001 : Code[10]);
    VAR
      WhseJnlBatch@1002 : Record 7310;
    BEGIN
      CurrentLocationCode := WMSMgt.GetDefaultDirectedPutawayAndPickLocation;

      WhseJnlBatch.SETRANGE("Journal Template Name",CurrentJnlTemplateName);
      WhseJnlBatch.SETRANGE("Location Code",CurrentLocationCode);
      WhseJnlBatch.SETRANGE(Name,CurrentJnlBatchName);
      IF NOT WhseJnlBatch.ISEMPTY THEN
        EXIT;

      WhseJnlBatch.SETRANGE(Name);
      IF NOT WhseJnlBatch.FINDFIRST THEN BEGIN
        WhseJnlBatch.INIT;
        WhseJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
        WhseJnlBatch.SetupNewBatch;
        WhseJnlBatch."Location Code" := CurrentLocationCode;
        WhseJnlBatch.Name := Text002;
        WhseJnlBatch.Description := Text003;
        WhseJnlBatch.INSERT(TRUE);
        COMMIT;
      END;
      CurrentJnlBatchName := WhseJnlBatch.Name;
    END;

    [External]
    PROCEDURE CheckName@10(CurrentJnlBatchName@1000 : Code[10];CurrentLocationCode@1003 : Code[10];VAR WhseJnlLine@1001 : Record 7311);
    VAR
      WhseJnlBatch@1002 : Record 7310;
      WhseEmployee@1004 : Record 7301;
    BEGIN
      WhseJnlBatch.GET(
        WhseJnlLine.GETRANGEMAX("Journal Template Name"),CurrentJnlBatchName,CurrentLocationCode);
      IF (USERID <> '') AND NOT WhseEmployee.GET(USERID,CurrentLocationCode) THEN
        ERROR(Text005,CurrentLocationCode,CurrentJnlBatchName,USERID);
    END;

    [External]
    PROCEDURE SetName@9(CurrentJnlBatchName@1000 : Code[10];CurrentLocationCode@1002 : Code[10];VAR WhseJnlLine@1001 : Record 7311);
    BEGIN
      WhseJnlLine.FILTERGROUP := 2;
      WhseJnlLine.SETRANGE("Journal Batch Name",CurrentJnlBatchName);
      WhseJnlLine.SETRANGE("Location Code",CurrentLocationCode);
      WhseJnlLine.FILTERGROUP := 0;
      IF WhseJnlLine.FIND('-') THEN;
    END;

    [External]
    PROCEDURE LookupName@7(VAR CurrentJnlBatchName@1000 : Code[10];VAR CurrentLocationCode@1003 : Code[10];VAR WhseJnlLine@1001 : Record 7311);
    VAR
      WhseJnlBatch@1002 : Record 7310;
    BEGIN
      COMMIT;
      WhseJnlBatch."Journal Template Name" := WhseJnlLine.GETRANGEMAX("Journal Template Name");
      WhseJnlBatch.Name := WhseJnlLine.GETRANGEMAX("Journal Batch Name");
      WhseJnlBatch.SETRANGE("Journal Template Name",WhseJnlBatch."Journal Template Name");
      IF PAGE.RUNMODAL(PAGE::"Whse. Journal Batches List",WhseJnlBatch) = ACTION::LookupOK THEN BEGIN
        CurrentJnlBatchName := WhseJnlBatch.Name;
        CurrentLocationCode := WhseJnlBatch."Location Code";
        SetName(CurrentJnlBatchName,CurrentLocationCode,WhseJnlLine);
      END;
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500();
    VAR
      WhseWkshLine@1000 : Record 7326;
      WhseItemTrackingLines@1001 : Page 6550;
    BEGIN
      TESTFIELD("Item No.");
      TESTFIELD("Qty. (Base)");
      WhseWkshLine.INIT;
      WhseWkshLine."Worksheet Template Name" := "Journal Template Name";
      WhseWkshLine.Name := "Journal Batch Name";
      WhseWkshLine."Location Code" := "Location Code";
      WhseWkshLine."Line No." := "Line No.";
      WhseWkshLine."Item No." := "Item No.";
      WhseWkshLine."Variant Code" := "Variant Code";
      WhseWkshLine."Qty. (Base)" := "Qty. (Base)";
      WhseWkshLine."Qty. to Handle (Base)" := "Qty. (Base)";
      WhseItemTrackingLines.SetSource(WhseWkshLine,DATABASE::"Warehouse Journal Line");
      WhseItemTrackingLines.RUNMODAL;
      CLEAR(WhseItemTrackingLines);
    END;

    LOCAL PROCEDURE ItemTrackingExist@17(TemplateName@1000 : Code[10];BatchName@1001 : Code[10];LocationCode@1004 : Code[10];LineNo@1002 : Integer;VAR WhseItemTrkgLine@1005 : Record 6550) : Boolean;
    BEGIN
      WITH WhseItemTrkgLine DO BEGIN
        RESET;
        SETCURRENTKEY(
          "Source ID","Source Type","Source Subtype","Source Batch Name",
          "Source Prod. Order Line","Source Ref. No.","Location Code");
        SETRANGE("Source Type",DATABASE::"Warehouse Journal Line");
        SETRANGE("Source Subtype",0);
        SETRANGE("Source Batch Name",TemplateName);
        SETRANGE("Source ID",BatchName);
        SETRANGE("Location Code",LocationCode);
        IF LineNo <> 0 THEN
          SETRANGE("Source Ref. No.",LineNo);
        SETRANGE("Source Prod. Order Line",0);

        EXIT(NOT ISEMPTY);
      END;
    END;

    [External]
    PROCEDURE ItemTrackingReclass@22(TemplateName@1000 : Code[10];BatchName@1001 : Code[10];LocationCode@1004 : Code[10];LineNo@1002 : Integer) : Boolean;
    VAR
      WhseItemTrkgLine@1003 : Record 6550;
    BEGIN
      IF NOT IsReclass(TemplateName) THEN
        EXIT(FALSE);

      WITH WhseItemTrkgLine DO BEGIN
        IF ItemTrackingExist(TemplateName,BatchName,LocationCode,LineNo,WhseItemTrkgLine) THEN BEGIN
          FINDSET;
          REPEAT
            IF ("Lot No." <> "New Lot No.") OR
               ("Serial No." <> "New Serial No.") OR
               ("Expiration Date" <> "New Expiration Date")
            THEN
              EXIT(TRUE);
          UNTIL NEXT = 0;
        END;
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE IsReclass@6(CurrentJnlTemplateName@1000 : Code[10]) : Boolean;
    VAR
      WhseJnlTemplate@1001 : Record 7309;
    BEGIN
      IF WhseJnlTemplate.GET(CurrentJnlTemplateName) THEN
        EXIT(WhseJnlTemplate.Type = WhseJnlTemplate.Type::Reclassification);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE SetProposal@23(NewValue@1000 : Boolean);
    BEGIN
      StockProposal := NewValue;
    END;

    [External]
    PROCEDURE IsOpenedFromBatch@42() : Boolean;
    VAR
      WarehouseJournalBatch@1002 : Record 7310;
      TemplateFilter@1001 : Text;
      BatchFilter@1000 : Text;
    BEGIN
      BatchFilter := GETFILTER("Journal Batch Name");
      IF BatchFilter <> '' THEN BEGIN
        TemplateFilter := GETFILTER("Journal Template Name");
        IF TemplateFilter <> '' THEN
          WarehouseJournalBatch.SETFILTER("Journal Template Name",TemplateFilter);
        WarehouseJournalBatch.SETFILTER(Name,BatchFilter);
        WarehouseJournalBatch.FINDFIRST;
      END;

      EXIT((("Journal Batch Name" <> '') AND ("Journal Template Name" = '')) OR (BatchFilter <> ''));
    END;

    [External]
    PROCEDURE SetSource@24(SourceType@1000 : Integer;SourceSubtype@1001 : Integer;SourceNo@1002 : Code[20];SourceLineNo@1003 : Integer;SourceSublineNo@1005 : Integer);
    BEGIN
      "Source Type" := SourceType;
      IF SourceSubtype >= 0 THEN
        "Source Subtype" := SourceSubtype;
      "Source No." := SourceNo;
      "Source Line No." := SourceLineNo;
      IF SourceSublineNo >= 0 THEN
        "Source Subline No." := SourceSublineNo;
    END;

    [External]
    PROCEDURE SetTracking@37(SerialNo@1001 : Code[20];LotNo@1000 : Code[20];WarrantyDate@1002 : Date;ExpirationDate@1003 : Date);
    BEGIN
      "Serial No." := SerialNo;
      "Lot No." := LotNo;
      "Warranty Date" := WarrantyDate;
      "Expiration Date" := ExpirationDate;
    END;

    [External]
    PROCEDURE SetWhseDoc@25(DocType@1000 : Option;DocNo@1001 : Code[20];DocLineNo@1002 : Integer);
    BEGIN
      "Whse. Document Type" := DocType;
      "Whse. Document No." := DocNo;
      "Whse. Document Line No." := DocLineNo;
    END;

    BEGIN
    END.
  }
}

