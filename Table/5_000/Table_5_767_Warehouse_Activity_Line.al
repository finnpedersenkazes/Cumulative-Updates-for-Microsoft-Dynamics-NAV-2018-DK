OBJECT Table 5767 Warehouse Activity Line
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    Permissions=TableData 6550=rmd;
    OnDelete=BEGIN
               DeleteRelatedWhseActivLines(Rec,FALSE);
             END;

    OnRename=BEGIN
               ERROR(Text001,TABLECAPTION);
             END;

    CaptionML=[DAN=Lageraktivitetslinje;
               ENU=Warehouse Activity Line];
    LookupPageID=Page5785;
    DrillDownPageID=Page5785;
  }
  FIELDS
  {
    { 1   ;   ;Activity Type       ;Option        ;CaptionML=[DAN=Aktivitetstype;
                                                              ENU=Activity Type];
                                                   OptionCaptionML=[DAN=" ,L�g-p�-lager,Pluk,Bev�gelse,L�g-p�-lager (lager),Pluk (lager),Flytning (lager)";
                                                                    ENU=" ,Put-away,Pick,Movement,Invt. Put-away,Invt. Pick,Invt. Movement"];
                                                   OptionString=[ ,Put-away,Pick,Movement,Invt. Put-away,Invt. Pick,Invt. Movement];
                                                   Editable=No }
    { 2   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   Editable=No }
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
                                                   OptionCaptionML=[DAN=" ,Salgsordre,,,Salgsreturvareordre,K�bsordre,,,K�bsreturvareordre,Indg�ende overf�rsel,Udg�ende overf�rsel,Prod.forbrug,Prod.afgang,Serviceordre,,,,,,,Montageforbrug,Montageordre";
                                                                    ENU=" ,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,Inbound Transfer,Outbound Transfer,Prod. Consumption,Prod. Output,,,,,,Service Order,,Assembly Consumption,Assembly Order"];
                                                   OptionString=[ ,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,Inbound Transfer,Outbound Transfer,Prod. Consumption,Prod. Output,,,,,,Service Order,,Assembly Consumption,Assembly Order];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 11  ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   Editable=No }
    { 12  ;   ;Shelf No.           ;Code10        ;CaptionML=[DAN=Placeringsnr.;
                                                              ENU=Shelf No.] }
    { 13  ;   ;Sorting Sequence No.;Integer       ;CaptionML=[DAN=Sorteringsr�kkef�lgenr.;
                                                              ENU=Sorting Sequence No.];
                                                   Editable=No }
    { 14  ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   OnValidate=BEGIN
                                                                IF "Item No." <> xRec."Item No." THEN
                                                                  "Variant Code" := '';

                                                                IF "Item No." <> '' THEN BEGIN
                                                                  GetItemUnitOfMeasure;
                                                                  Description := Item.Description;
                                                                  "Description 2" := Item."Description 2";
                                                                  VALIDATE("Unit of Measure Code",ItemUnitOfMeasure.Code);
                                                                END ELSE BEGIN
                                                                  Description := '';
                                                                  "Description 2" := '';
                                                                  "Variant Code" := '';
                                                                  VALIDATE("Unit of Measure Code",'');
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.];
                                                   Editable=No }
    { 15  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=VAR
                                                                ItemVariant@1000 : Record 5401;
                                                              BEGIN
                                                                IF "Variant Code" = '' THEN
                                                                  VALIDATE("Item No.")
                                                                ELSE BEGIN
                                                                  ItemVariant.GET("Item No.","Variant Code");
                                                                  Description := ItemVariant.Description;
                                                                  "Description 2" := ItemVariant."Description 2";
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code];
                                                   Editable=No }
    { 16  ;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=BEGIN
                                                                IF "Item No." <> '' THEN BEGIN
                                                                  GetItemUnitOfMeasure;
                                                                  "Qty. per Unit of Measure" := ItemUnitOfMeasure."Qty. per Unit of Measure";
                                                                END ELSE
                                                                  "Qty. per Unit of Measure" := 1;

                                                                VALIDATE(Quantity);
                                                                VALIDATE("Qty. Outstanding");
                                                                VALIDATE("Qty. to Handle");
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code];
                                                   Editable=No }
    { 17  ;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 18  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 19  ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2];
                                                   Editable=No }
    { 20  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Qty. Outstanding",(Quantity - "Qty. Handled"));
                                                                "Qty. (Base)" := CalcBaseQty(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 21  ;   ;Qty. (Base)         ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Qty. (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 24  ;   ;Qty. Outstanding    ;Decimal       ;OnValidate=BEGIN
                                                                "Qty. Outstanding (Base)" := CalcBaseQty("Qty. Outstanding");
                                                                VALIDATE("Qty. to Handle","Qty. Outstanding");
                                                              END;

                                                   CaptionML=[DAN=Antal udest�ende;
                                                              ENU=Qty. Outstanding];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 25  ;   ;Qty. Outstanding (Base);Decimal    ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE("Qty. Outstanding","Qty. Outstanding (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal udest�ende (basis);
                                                              ENU=Qty. Outstanding (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 26  ;   ;Qty. to Handle      ;Decimal       ;OnValidate=BEGIN
                                                                IF "Qty. to Handle" > "Qty. Outstanding" THEN
                                                                  ERROR(
                                                                    Text002,
                                                                    "Qty. Outstanding");

                                                                GetLocation("Location Code");
                                                                IF Location."Directed Put-away and Pick" THEN
                                                                  WMSMgt.CalcCubageAndWeight(
                                                                    "Item No.","Unit of Measure Code","Qty. to Handle",Cubage,Weight);

                                                                IF (CurrFieldNo <> 0) AND
                                                                   ("Action Type" = "Action Type"::Place) AND
                                                                   ("Breakbulk No." = 0) AND
                                                                   ("Qty. to Handle" > 0) AND
                                                                   Location."Directed Put-away and Pick"
                                                                THEN
                                                                  IF GetBin("Location Code","Bin Code") THEN
                                                                    CheckIncreaseCapacity(TRUE);

                                                                IF NOT UseBaseQty THEN BEGIN
                                                                  "Qty. to Handle (Base)" := CalcBaseQty("Qty. to Handle");
                                                                  IF "Qty. to Handle (Base)" > "Qty. Outstanding (Base)" THEN // rounding error- qty same, not base qty
                                                                    "Qty. to Handle (Base)" := "Qty. Outstanding (Base)";
                                                                END;

                                                                IF ("Activity Type" = "Activity Type"::"Put-away") AND
                                                                   ("Action Type" = "Action Type"::Take) AND
                                                                   (CurrFieldNo <> 0)
                                                                THEN
                                                                  IF ("Breakbulk No." <> 0) OR "Original Breakbulk" THEN
                                                                    UpdateBreakbulkQtytoHandle;

                                                                IF ("Activity Type" IN ["Activity Type"::Pick,"Activity Type"::"Invt. Pick"]) AND
                                                                   ("Action Type" <> "Action Type"::Place) AND ("Lot No." <> '') AND (CurrFieldNo <> 0)
                                                                THEN
                                                                  CheckReservedItemTrkg(1,"Lot No.");

                                                                IF ("Qty. to Handle" = 0) AND RegisteredWhseActLineIsEmpty THEN
                                                                  UpdateReservation(Rec,FALSE)
                                                              END;

                                                   CaptionML=[DAN=H�ndteringsantal;
                                                              ENU=Qty. to Handle];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 27  ;   ;Qty. to Handle (Base);Decimal      ;OnValidate=BEGIN
                                                                UseBaseQty := TRUE;
                                                                VALIDATE("Qty. to Handle",CalcQty("Qty. to Handle (Base)"));
                                                              END;

                                                   CaptionML=[DAN=H�ndteringsantal (basis);
                                                              ENU=Qty. to Handle (Base)];
                                                   DecimalPlaces=0:5 }
    { 28  ;   ;Qty. Handled        ;Decimal       ;OnValidate=BEGIN
                                                                "Qty. Handled (Base)" := CalcBaseQty("Qty. Handled");
                                                              END;

                                                   CaptionML=[DAN=H�ndteret antal;
                                                              ENU=Qty. Handled];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 29  ;   ;Qty. Handled (Base) ;Decimal       ;CaptionML=[DAN=H�ndteret antal (basis);
                                                              ENU=Qty. Handled (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 31  ;   ;Shipping Advice     ;Option        ;FieldClass=Normal;
                                                   CaptionML=[DAN=Afsendelsesadvis;
                                                              ENU=Shipping Advice];
                                                   OptionCaptionML=[DAN=Delvis,Komplet;
                                                                    ENU=Partial,Complete];
                                                   OptionString=Partial,Complete;
                                                   Editable=No }
    { 34  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 39  ;   ;Destination Type    ;Option        ;CaptionML=[DAN=Destinationstype;
                                                              ENU=Destination Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Lokation,Vare,Familie,Salgsordre";
                                                                    ENU=" ,Customer,Vendor,Location,Item,Family,Sales Order"];
                                                   OptionString=[ ,Customer,Vendor,Location,Item,Family,Sales Order];
                                                   Editable=No }
    { 40  ;   ;Destination No.     ;Code20        ;TableRelation=IF (Destination Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Destination Type=CONST(Customer)) Customer
                                                                 ELSE IF (Destination Type=CONST(Location)) Location
                                                                 ELSE IF (Destination Type=CONST(Item)) Item
                                                                 ELSE IF (Destination Type=CONST(Family)) Family
                                                                 ELSE IF (Destination Type=CONST(Sales Order)) "Sales Header".No. WHERE (Document Type=CONST(Order));
                                                   CaptionML=[DAN=Destinationsnr.;
                                                              ENU=Destination No.];
                                                   Editable=No }
    { 42  ;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   CaptionML=[DAN=Spedit�rkode;
                                                              ENU=Shipping Agent Code] }
    { 43  ;   ;Shipping Agent Service Code;Code10 ;TableRelation="Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));
                                                   CaptionML=[DAN=Spedit�rservicekode;
                                                              ENU=Shipping Agent Service Code] }
    { 44  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   CaptionML=[DAN=Leveringskode;
                                                              ENU=Shipment Method Code] }
    { 47  ;   ;Starting Date       ;Date          ;CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 900 ;   ;Assemble to Order   ;Boolean       ;AccessByPermission=TableData 90=R;
                                                   CaptionML=[DAN=Montage til ordre;
                                                              ENU=Assemble to Order];
                                                   Editable=No }
    { 901 ;   ;ATO Component       ;Boolean       ;CaptionML=[DAN=MTO-komponent;
                                                              ENU=ATO Component];
                                                   Editable=No }
    { 6500;   ;Serial No.          ;Code20        ;OnValidate=BEGIN
                                                                IF "Serial No." <> '' THEN BEGIN
                                                                  ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.",SNRequired,LNRequired,TRUE);
                                                                  TESTFIELD("Qty. per Unit of Measure",1);

                                                                  IF "Activity Type" IN ["Activity Type"::Pick,"Activity Type"::"Invt. Pick"] THEN
                                                                    CheckReservedItemTrkg(0,"Serial No.");

                                                                  CheckSNSpecificationExists;

                                                                  IF SNRequired AND LNRequired THEN
                                                                    FindLotNoBySerialNo;
                                                                END;

                                                                IF "Serial No." <> xRec."Serial No." THEN
                                                                  "Expiration Date" := 0D;
                                                              END;

                                                   OnLookup=VAR
                                                              LookUpBinContent@1000 : Boolean;
                                                            BEGIN
                                                              LookUpBinContent := ("Activity Type" <= "Activity Type"::Movement) OR ("Action Type" <> "Action Type"::Place);
                                                              LookUpTrackingSummary(Rec,LookUpBinContent,-1,0);
                                                            END;

                                                   CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.] }
    { 6501;   ;Lot No.             ;Code20        ;OnValidate=BEGIN
                                                                IF "Lot No." <> '' THEN BEGIN
                                                                  ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.",SNRequired,LNRequired,TRUE);

                                                                  IF "Activity Type" IN ["Activity Type"::Pick,"Activity Type"::"Invt. Pick"] THEN
                                                                    CheckReservedItemTrkg(1,"Lot No.");
                                                                END;

                                                                IF "Lot No." <> xRec."Lot No." THEN
                                                                  "Expiration Date" := 0D;
                                                              END;

                                                   OnLookup=VAR
                                                              LookUpBinContent@1000 : Boolean;
                                                            BEGIN
                                                              LookUpBinContent := ("Activity Type" <= "Activity Type"::Movement) OR ("Action Type" <> "Action Type"::Place);
                                                              LookUpTrackingSummary(Rec,LookUpBinContent,-1,1);
                                                            END;

                                                   CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.] }
    { 6502;   ;Warranty Date       ;Date          ;CaptionML=[DAN=Garantioph�r den;
                                                              ENU=Warranty Date] }
    { 6503;   ;Expiration Date     ;Date          ;OnValidate=VAR
                                                                WhseActivLine@1000 : Record 5767;
                                                              BEGIN
                                                                IF "Lot No." <> '' THEN
                                                                  WITH WhseActivLine DO BEGIN
                                                                    RESET;
                                                                    SETCURRENTKEY("No.","Line No.","Activity Type");
                                                                    SETRANGE("No.",Rec."No.");
                                                                    SETRANGE("Item No.",Rec."Item No.");
                                                                    SETRANGE("Lot No.",Rec."Lot No.");

                                                                    IF FINDSET THEN
                                                                      REPEAT
                                                                        IF ("Line No." <> Rec."Line No.") AND ("Expiration Date" <> Rec."Expiration Date") AND
                                                                           (Rec."Expiration Date" <> 0D) AND ("Expiration Date" <> 0D)
                                                                        THEN
                                                                          Rec.FIELDERROR("Expiration Date");
                                                                      UNTIL NEXT = 0;
                                                                  END;
                                                              END;

                                                   CaptionML=[DAN=Udl�bsdato;
                                                              ENU=Expiration Date] }
    { 6504;   ;Serial No. Blocked  ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Serial No. Information".Blocked WHERE (Item No.=FIELD(Item No.),
                                                                                                              Variant Code=FIELD(Variant Code),
                                                                                                              Serial No.=FIELD(Serial No.)));
                                                   CaptionML=[DAN=Serienummeret er blokeret;
                                                              ENU=Serial No. Blocked];
                                                   Editable=No }
    { 6505;   ;Lot No. Blocked     ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Lot No. Information".Blocked WHERE (Item No.=FIELD(Item No.),
                                                                                                           Variant Code=FIELD(Variant Code),
                                                                                                           Lot No.=FIELD(Lot No.)));
                                                   CaptionML=[DAN=Lotnummeret er blokeret;
                                                              ENU=Lot No. Blocked];
                                                   Editable=No }
    { 7300;   ;Bin Code            ;Code20        ;TableRelation=IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                                                                 ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                  Zone Code=FIELD(Zone Code));
                                                   OnValidate=VAR
                                                                BinContent@1000 : Record 7302;
                                                                BinType@1002 : Record 7303;
                                                                QtyAvailBase@1001 : Decimal;
                                                                AvailableQtyBase@1006 : Decimal;
                                                                UOMCode@1003 : Code[10];
                                                                NewBinCode@1005 : Code[20];
                                                              BEGIN
                                                                CheckBinInSourceDoc;

                                                                IF "Bin Code" <> '' THEN
                                                                  IF NOT "Assemble to Order" AND ("Action Type" = "Action Type"::Take) THEN
                                                                    WMSMgt.FindBinContent("Location Code","Bin Code","Item No.","Variant Code","Zone Code")
                                                                  ELSE
                                                                    WMSMgt.FindBin("Location Code","Bin Code","Zone Code");

                                                                IF "Bin Code" <> xRec."Bin Code" THEN BEGIN
                                                                  CheckInvalidBinCode;
                                                                  IF GetBin("Location Code","Bin Code") THEN BEGIN
                                                                    IF CurrFieldNo <> 0 THEN BEGIN
                                                                      IF ("Activity Type" = "Activity Type"::"Put-away") AND
                                                                         ("Breakbulk No." <> 0)
                                                                      THEN
                                                                        ERROR(Text005,FIELDCAPTION("Bin Code"));
                                                                      CheckWhseDocLine;
                                                                      IF "Action Type" = "Action Type"::Take THEN BEGIN
                                                                        IF (("Whse. Document Type" <> "Whse. Document Type"::Receipt) AND
                                                                            (Bin."Bin Type Code" <> ''))
                                                                        THEN
                                                                          IF BinType.GET(Bin."Bin Type Code") THEN
                                                                            BinType.TESTFIELD(Receive,FALSE);
                                                                        GetLocation("Location Code");
                                                                        IF Location."Directed Put-away and Pick" THEN
                                                                          UOMCode := "Unit of Measure Code"
                                                                        ELSE
                                                                          UOMCode := WMSMgt.GetBaseUOM("Item No.");
                                                                        NewBinCode := "Bin Code";
                                                                        IF BinContent.GET("Location Code","Bin Code","Item No.","Variant Code",UOMCode) THEN BEGIN
                                                                          IF "Activity Type" IN ["Activity Type"::Pick,"Activity Type"::"Invt. Pick","Activity Type"::"Invt. Movement"] THEN
                                                                            QtyAvailBase := BinContent.CalcQtyAvailToPick(0)
                                                                          ELSE
                                                                            QtyAvailBase := BinContent.CalcQtyAvailToTake(0);
                                                                          IF Location."Directed Put-away and Pick" THEN BEGIN
                                                                            CreatePick.SetCrossDock(Bin."Cross-Dock Bin");
                                                                            AvailableQtyBase :=
                                                                              CreatePick.CalcTotalAvailQtyToPick(
                                                                                "Location Code","Item No.","Variant Code","Lot No.","Serial No.",
                                                                                "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",0,FALSE);
                                                                            AvailableQtyBase += "Qty. Outstanding (Base)";
                                                                            IF AvailableQtyBase < 0 THEN
                                                                              AvailableQtyBase := 0;

                                                                            IF AvailableQtyBase = 0 THEN
                                                                              ERROR(Text015);
                                                                          END ELSE
                                                                            AvailableQtyBase := QtyAvailBase;

                                                                          IF AvailableQtyBase < QtyAvailBase THEN
                                                                            QtyAvailBase := AvailableQtyBase;
                                                                        END;

                                                                        IF (QtyAvailBase < "Qty. Outstanding (Base)") AND NOT "Assemble to Order" THEN BEGIN
                                                                          IF NOT
                                                                             CONFIRM(
                                                                               STRSUBSTNO(
                                                                                 Text012,
                                                                                 FIELDCAPTION("Qty. Outstanding (Base)"),"Qty. Outstanding (Base)",
                                                                                 QtyAvailBase,BinContent.TABLECAPTION,FIELDCAPTION("Bin Code")),
                                                                               FALSE)
                                                                          THEN
                                                                            ERROR(Text006);

                                                                          "Bin Code" := NewBinCode;
                                                                          MODIFY;
                                                                        END;
                                                                      END ELSE BEGIN
                                                                        IF "Qty. to Handle" > 0 THEN
                                                                          CheckIncreaseCapacity(FALSE);
                                                                        xRec.DeleteBinContent(xRec."Action Type"::Place);
                                                                      END;
                                                                    END;
                                                                    Dedicated := Bin.Dedicated;
                                                                    IF Location."Directed Put-away and Pick" THEN BEGIN
                                                                      "Bin Ranking" := Bin."Bin Ranking";
                                                                      "Bin Type Code" := Bin."Bin Type Code";
                                                                      "Zone Code" := Bin."Zone Code";
                                                                    END;
                                                                  END ELSE BEGIN
                                                                    xRec.DeleteBinContent(xRec."Action Type"::Place);
                                                                    Dedicated := FALSE;
                                                                    "Bin Ranking" := 0;
                                                                    "Bin Type Code" := '';
                                                                  END;
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              BinCode@1000 : Code[20];
                                                            BEGIN
                                                              IF "Action Type" = "Action Type"::Take THEN
                                                                BinCode := WMSMgt.BinContentLookUp2("Location Code","Item No.","Variant Code","Zone Code","Lot No.","Serial No.","Bin Code")
                                                              ELSE
                                                                BinCode := WMSMgt.BinLookUp("Location Code","Item No.","Variant Code","Zone Code");

                                                              IF BinCode <> '' THEN BEGIN
                                                                VALIDATE("Bin Code",BinCode);
                                                                MODIFY;
                                                              END;
                                                            END;

                                                   AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 7301;   ;Zone Code           ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                IF xRec."Zone Code" <> "Zone Code" THEN BEGIN
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Directed Put-away and Pick");
                                                                  xRec.DeleteBinContent(xRec."Action Type"::Place);
                                                                  "Bin Code" := '';
                                                                  "Bin Ranking" := 0;
                                                                  "Bin Type Code" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Zonekode;
                                                              ENU=Zone Code] }
    { 7305;   ;Action Type         ;Option        ;CaptionML=[DAN=Handlingstype;
                                                              ENU=Action Type];
                                                   OptionCaptionML=[DAN=" ,Hent,Placer";
                                                                    ENU=" ,Take,Place"];
                                                   OptionString=[ ,Take,Place];
                                                   Editable=No }
    { 7306;   ;Whse. Document Type ;Option        ;CaptionML=[DAN=Lagerdokumenttype;
                                                              ENU=Whse. Document Type];
                                                   OptionCaptionML=[DAN=" ,Modtagelse,Afsendelse,Intern l�g-p�-lager,Internt pluk,Produktion,Bev�gelseskladde,,Montage";
                                                                    ENU=" ,Receipt,Shipment,Internal Put-away,Internal Pick,Production,Movement Worksheet,,Assembly"];
                                                   OptionString=[ ,Receipt,Shipment,Internal Put-away,Internal Pick,Production,Movement Worksheet,,Assembly];
                                                   Editable=No }
    { 7307;   ;Whse. Document No.  ;Code20        ;TableRelation=IF (Whse. Document Type=CONST(Receipt)) "Posted Whse. Receipt Header".No. WHERE (No.=FIELD(Whse. Document No.))
                                                                 ELSE IF (Whse. Document Type=CONST(Shipment)) "Warehouse Shipment Header".No. WHERE (No.=FIELD(Whse. Document No.))
                                                                 ELSE IF (Whse. Document Type=CONST(Internal Put-away)) "Whse. Internal Put-away Header".No. WHERE (No.=FIELD(Whse. Document No.))
                                                                 ELSE IF (Whse. Document Type=CONST(Internal Pick)) "Whse. Internal Pick Header".No. WHERE (No.=FIELD(Whse. Document No.))
                                                                 ELSE IF (Whse. Document Type=CONST(Production)) "Production Order".No. WHERE (No.=FIELD(Whse. Document No.))
                                                                 ELSE IF (Whse. Document Type=CONST(Assembly)) "Assembly Header".No. WHERE (Document Type=CONST(Order),
                                                                                                                                            No.=FIELD(Whse. Document No.));
                                                   CaptionML=[DAN=Lagerdokumentnr.;
                                                              ENU=Whse. Document No.];
                                                   Editable=No }
    { 7308;   ;Whse. Document Line No.;Integer    ;TableRelation=IF (Whse. Document Type=CONST(Receipt)) "Posted Whse. Receipt Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                                                       Line No.=FIELD(Whse. Document Line No.))
                                                                                                                                                       ELSE IF (Whse. Document Type=CONST(Shipment)) "Warehouse Shipment Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                 Line No.=FIELD(Whse. Document Line No.))
                                                                                                                                                                                                                                                 ELSE IF (Whse. Document Type=CONST(Internal Put-away)) "Whse. Internal Put-away Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                                                         Line No.=FIELD(Whse. Document Line No.))
                                                                                                                                                                                                                                                                                                                                                         ELSE IF (Whse. Document Type=CONST(Internal Pick)) "Whse. Internal Pick Line"."Line No." WHERE (No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                                                                                                                                                         Line No.=FIELD(Whse. Document Line No.))
                                                                                                                                                                                                                                                                                                                                                                                                                                                         ELSE IF (Whse. Document Type=CONST(Production)) "Prod. Order Line"."Line No." WHERE (Prod. Order No.=FIELD(No.),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Line No.=FIELD(Line No.))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ELSE IF (Whse. Document Type=CONST(Assembly)) "Assembly Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Document No.=FIELD(Whse. Document No.),
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Line No.=FIELD(Whse. Document Line No.));
                                                   CaptionML=[DAN=Lagerdokumentlinjenr.;
                                                              ENU=Whse. Document Line No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 7309;   ;Bin Ranking         ;Integer       ;CaptionML=[DAN=Placeringsniveau;
                                                              ENU=Bin Ranking];
                                                   Editable=No }
    { 7310;   ;Cubage              ;Decimal       ;CaptionML=[DAN=Rumm�l;
                                                              ENU=Cubage];
                                                   DecimalPlaces=0:5 }
    { 7311;   ;Weight              ;Decimal       ;CaptionML=[DAN=V�gt;
                                                              ENU=Weight];
                                                   DecimalPlaces=0:5 }
    { 7312;   ;Special Equipment Code;Code10      ;TableRelation="Special Equipment";
                                                   CaptionML=[DAN=Specialudstyrskode;
                                                              ENU=Special Equipment Code] }
    { 7313;   ;Bin Type Code       ;Code10        ;TableRelation="Bin Type";
                                                   CaptionML=[DAN=Placeringstypekode;
                                                              ENU=Bin Type Code] }
    { 7314;   ;Breakbulk No.       ;Integer       ;CaptionML=[DAN=Nedbrydningsnr.;
                                                              ENU=Breakbulk No.];
                                                   BlankZero=Yes }
    { 7315;   ;Original Breakbulk  ;Boolean       ;CaptionML=[DAN=Oprindelig nedbrydning;
                                                              ENU=Original Breakbulk] }
    { 7316;   ;Breakbulk           ;Boolean       ;CaptionML=[DAN=Nedbrydning;
                                                              ENU=Breakbulk] }
    { 7317;   ;Cross-Dock Information;Option      ;CaptionML=[DAN=Oplysn. om dir. afsend.;
                                                              ENU=Cross-Dock Information];
                                                   OptionCaptionML=[DAN=" ,Dir.afs.varer,Nogle varer til dir.afs.";
                                                                    ENU=" ,Cross-Dock Items,Some Items Cross-Docked"];
                                                   OptionString=[ ,Cross-Dock Items,Some Items Cross-Docked] }
    { 7318;   ;Dedicated           ;Boolean       ;CaptionML=[DAN=Dedikeret;
                                                              ENU=Dedicated];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Activity Type,No.,Line No.              ;SumIndexFields=Qty. to Handle (Base);
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;No.,Line No.,Activity Type               }
    {    ;Source Type,Source Subtype,Source No.,Source Line No.,Source Subline No.,Unit of Measure Code,Action Type,Breakbulk No.,Original Breakbulk,Activity Type,Assemble to Order;
                                                   SumIndexFields=Qty. Outstanding,Qty. Outstanding (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Activity Type,No.,Sorting Sequence No.  ;MaintainSQLIndex=No }
    {    ;Activity Type,No.,Shelf No.             ;MaintainSQLIndex=No }
    {    ;Activity Type,No.,Location Code,Source Document,Source No.,Action Type,Zone Code;
                                                   MaintainSQLIndex=No }
    {    ;Activity Type,No.,Due Date,Action Type,Bin Code;
                                                   MaintainSQLIndex=No }
    {    ;Activity Type,No.,Bin Code,Breakbulk No.,Action Type;
                                                   MaintainSQLIndex=No }
    {    ;Activity Type,No.,Bin Ranking,Breakbulk No.,Action Type;
                                                   MaintainSQLIndex=No }
    {    ;Activity Type,No.,Destination Type,Destination No.,Action Type,Bin Code;
                                                   MaintainSQLIndex=No }
    {    ;Activity Type,No.,Whse. Document Type,Whse. Document No.,Whse. Document Line No.;
                                                   MaintainSQLIndex=No }
    {    ;Activity Type,No.,Action Type,Bin Code  ;MaintainSQLIndex=No }
    {    ;Activity Type,No.,Item No.,Variant Code,Action Type,Bin Code;
                                                   MaintainSQLIndex=No }
    {    ;Whse. Document No.,Whse. Document Type,Activity Type,Whse. Document Line No.,Action Type,Unit of Measure Code,Original Breakbulk,Breakbulk No.,Lot No.,Serial No.,Assemble to Order;
                                                   SumIndexFields=Qty. Outstanding (Base),Qty. Outstanding;
                                                   MaintainSIFTIndex=No }
    {    ;Item No.,Bin Code,Location Code,Action Type,Variant Code,Unit of Measure Code,Breakbulk No.,Activity Type,Lot No.,Serial No.,Original Breakbulk,Assemble to Order,ATO Component;
                                                   SumIndexFields=Quantity,Qty. (Base),Qty. Outstanding,Qty. Outstanding (Base),Cubage,Weight;
                                                   MaintainSIFTIndex=No }
    {    ;Item No.,Location Code,Activity Type,Bin Type Code,Unit of Measure Code,Variant Code,Breakbulk No.,Action Type,Lot No.,Serial No.,Assemble to Order;
                                                   SumIndexFields=Qty. Outstanding (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Bin Code,Location Code,Action Type,Breakbulk No.;
                                                   SumIndexFields=Cubage,Weight;
                                                   MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Location Code,Activity Type              }
    {    ;Source No.,Source Line No.,Source Subline No.,Serial No.,Lot No.;
                                                   MaintainSQLIndex=No }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text002@1002 : TextConst 'DAN=Du kan ikke h�ndtere mere end de udest�ende %1 enheder.;ENU=You cannot handle more than the outstanding %1 units.';
      Text003@1003 : TextConst 'DAN=m� ikke v�re %1;ENU=must not be %1';
      Text004@1004 : TextConst 'DAN=Hvis du sletter %1 %2, %3 %4, %5 %6,\vil det antal der skal %7es, ikke stemme.\Vil du stadig slette %8?;ENU=If you delete %1 %2, %3 %4, %5 %6\the quantity to %7 will be imbalanced.\Do you still want to delete the %8?';
      Text005@1045 : TextConst 'DAN=Du m� ikke �ndre %1 i nedbrydningslinjer.;ENU=You must not change the %1 in breakbulk lines.';
      Text006@1006 : TextConst 'DAN=Opdateringen blev afbrudt pga. advarslen.;ENU=The update was interrupted to respect the warning.';
      Location@1026 : Record 14;
      Item@1008 : Record 27;
      Bin@1025 : Record 7354;
      ItemUnitOfMeasure@1010 : Record 5404;
      ItemTrackingCode@1020 : Record 6502;
      ItemTrackingMgt@1005 : Codeunit 6500;
      ItemTrackingDataCollection@1018 : Codeunit 6501;
      WMSMgt@1019 : Codeunit 7302;
      CreatePick@1032 : Codeunit 7312;
      Text007@1007 : TextConst 'DAN=Du kan ikke opdele nedbrydningslinjer.;ENU=You must not split breakbulk lines.';
      Text008@1022 : TextConst 'DAN=Den m�ngde, der kan plukkes, er ikke tilstr�kkelig til at udfylde alle linjerne.;ENU=Quantity available to pick is not enough to fill in all the lines.';
      Text009@1023 : TextConst 'DAN=Hvis du vil slette %1,\skal du gendanne de relaterede lageraktivitetslinjer manuelt.\\Vil du slette %1?;ENU=If you delete the %1\you must recreate related Warehouse Worksheet Lines manually.\\Do you want to delete the %1?';
      Text011@1027 : TextConst 'DAN=Du kan ikke angive %1 for %2 som %3.;ENU=You cannot enter the %1 of the %2 as %3.';
      Text012@1028 : TextConst 'DAN=%1 %2 overstiger det antal, der er disponibelt til pluk %3 i %4.\Vil du stadig angive denne %5?;ENU=The %1 %2 exceeds the quantity available to pick %3 of the %4.\Do you still want to enter this %5?';
      Text013@1029 : TextConst 'DAN=Alle relaterede lageraktivitetslinjer er blevet slettet.;ENU=All related Warehouse Activity Lines are deleted.';
      ConfirmDeleteLine@1014 : Boolean;
      SNRequired@1009 : Boolean;
      LNRequired@1015 : Boolean;
      Text014@1030 : TextConst 'DAN=%1 %2 er allerede reserveret til et andet dokument.;ENU=%1 %2 has already been reserved for another document.';
      Text015@1031 : TextConst 'DAN=Det samlede disponible antal er allerede udlignet.;ENU=The total available quantity has already been applied.';
      Text017@1000 : TextConst 'DAN=%1 %2 er ikke disponibel p� lager, er allerede reserveret til et andet dokument, eller det disponible antal er lavere end det antal, der skal h�ndteres, som er angivet p� linjen.;ENU=%1 %2 is not available in inventory, it has already been reserved for another document, or the quantity available is lower than the quantity to handle specified on the line.';
      UseBaseQty@1017 : Boolean;
      Text018@1024 : TextConst '@@@=Warehouse Activity Line already exists with Serial No. XXX;DAN=%1 findes allerede med %2 %3.;ENU=%1 already exists with %2 %3.';
      Text019@1011 : TextConst 'DAN=Placeringskoden %1 skal v�re en anden end placeringskoden %2 p� lokationen %3.;ENU=The %1 bin code must be different from the %2 bin code on location %3.';
      Text020@1012 : TextConst 'DAN=Placeringskoden %1 m� ikke v�re den modtagelsesplaceringskode eller leveringsplaceringskode, der er konfigureret p� lokationen %2.;ENU=The %1 bin code must not be the Receipt Bin Code or the Shipment Bin Code that are set up on location %2.';

    LOCAL PROCEDURE CalcBaseQty@14(Qty@1000 : Decimal) : Decimal;
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
    PROCEDURE AutofillQtyToHandle@10(VAR WhseActivLine@1000 : Record 5767);
    VAR
      NotEnough@1001 : Boolean;
    BEGIN
      WITH WhseActivLine DO BEGIN
        NotEnough := FALSE;
        IF FIND('-') THEN
          REPEAT
            VALIDATE("Qty. to Handle","Qty. Outstanding");
            IF "Qty. to Handle (Base)" <> "Qty. Outstanding (Base)" THEN
              VALIDATE("Qty. to Handle (Base)","Qty. Outstanding (Base)");
            MODIFY;
            OnAfterAutofillQtyToHandleLine(WhseActivLine);

            IF NOT NotEnough THEN
              IF "Qty. to Handle" < "Qty. Outstanding" THEN
                NotEnough := TRUE;
          UNTIL NEXT = 0;

        IF NotEnough THEN
          MESSAGE(Text008);
      END;
    END;

    [External]
    PROCEDURE DeleteQtyToHandle@11(VAR WhseActivLine@1000 : Record 5767);
    BEGIN
      WITH WhseActivLine DO BEGIN
        IF FIND('-') THEN
          REPEAT
            VALIDATE("Qty. to Handle",0);
            MODIFY;
            OnAfterUpdateQtyToHandleWhseActivLine(WhseActivLine);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE GetItem@15();
    BEGIN
      IF Item."No." = "Item No." THEN
        EXIT;

      Item.GET("Item No.");
      IF Item."Item Tracking Code" <> '' THEN
        ItemTrackingCode.GET(Item."Item Tracking Code")
      ELSE
        CLEAR(ItemTrackingCode);
    END;

    [External]
    PROCEDURE DeleteRelatedWhseActivLines@13(WhseActivLine@1003 : Record 5767;CalledFromHeader@1000 : Boolean);
    VAR
      WhseActivLine2@1002 : Record 5767;
      WhseActivLine3@1005 : Record 5767;
      WhseWkshLine@1001 : Record 7326;
      Confirmed@1004 : Boolean;
    BEGIN
      WITH WhseActivLine DO BEGIN
        IF ("Activity Type" IN ["Activity Type"::"Invt. Put-away","Activity Type"::"Invt. Pick"]) AND
           (NOT CalledFromHeader)
        THEN
          EXIT;

        WhseActivLine2.SETCURRENTKEY(
          "Activity Type","No.","Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
        WhseActivLine2.SETRANGE("Activity Type","Activity Type");
        WhseActivLine2.SETRANGE("No.","No.");
        WhseWkshLine.SETCURRENTKEY("Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
        IF WhseActivLine2.FIND('-') THEN
          REPEAT
            WhseWkshLine.SETRANGE("Whse. Document Type",WhseActivLine2."Whse. Document Type");
            WhseWkshLine.SETRANGE("Whse. Document No.",WhseActivLine2."Whse. Document No.");
            WhseWkshLine.SETRANGE("Whse. Document Line No.",WhseActivLine2."Whse. Document Line No.");
            IF NOT WhseWkshLine.ISEMPTY THEN BEGIN
              IF NOT CONFIRM(Text009,FALSE,TABLECAPTION) THEN
                ERROR(Text006);

              Confirmed := TRUE;
            END;
          UNTIL (WhseActivLine2.NEXT = 0) OR Confirmed;

        IF (NOT CalledFromHeader) AND
           ("Action Type" <> "Action Type"::" ")
        THEN BEGIN
          WhseActivLine2.SETRANGE("Whse. Document Type","Whse. Document Type");
          WhseActivLine2.SETRANGE("Whse. Document No.","Whse. Document No.");
          WhseActivLine2.SETRANGE("Whse. Document Line No.","Whse. Document Line No.");
          WhseActivLine2.SETRANGE("Breakbulk No.","Breakbulk No.");
          WhseActivLine2.SETRANGE("Source No.","Source No.");
          WhseActivLine2.SETRANGE("Source Line No.","Source Line No.");
          WhseActivLine2.SETRANGE("Source Subline No.","Source Subline No.");
          WhseActivLine2.SETRANGE("Serial No.","Serial No.");
          WhseActivLine2.SETRANGE("Lot No.","Lot No.");
          IF WhseActivLine2.FIND('-') THEN BEGIN
            WhseActivLine3.COPY(WhseActivLine2);
            WhseActivLine3.SETRANGE("Action Type","Action Type");
            WhseActivLine3.SETFILTER("Line No.",'<>%1',"Line No.");
            IF NOT WhseActivLine3.ISEMPTY THEN BEGIN
              IF NOT ConfirmDeleteLine THEN
                IF NOT
                   CONFIRM(
                     STRSUBSTNO(
                       Text004,
                       FIELDCAPTION("Activity Type"),"Activity Type",FIELDCAPTION("No."),"No.",
                       FIELDCAPTION("Line No."),"Line No.","Action Type",TABLECAPTION),
                     FALSE)
                THEN
                  ERROR(Text006);
              ConfirmDeleteLine := TRUE;
              EXIT;
            END;
          END;
        END;
        IF NOT CalledFromHeader THEN
          IF "Action Type" <> "Action Type"::" " THEN
            WhseActivLine2.SETFILTER("Line No.",'<>%1',"Line No.")
          ELSE
            WhseActivLine2.SETRANGE("Line No.","Line No.");
        IF WhseActivLine2.FIND('-') THEN
          REPEAT
            WhseActivLine2.DELETE; // to ensure correct item tracking update
            WhseActivLine2.DeleteBinContent(WhseActivLine2."Action Type"::Place);
            UpdateRelatedItemTrkg(WhseActivLine2);
          UNTIL WhseActivLine2.NEXT = 0;
        IF (NOT CalledFromHeader) AND
           ("Action Type" <> "Action Type"::" ")
        THEN BEGIN
          WhseActivLine2.RESET;
          WhseActivLine2.SETRANGE("Activity Type","Activity Type");
          WhseActivLine2.SETRANGE("No.","No.");
          IF WhseActivLine2.FIND('-') THEN
            MESSAGE(Text013);
        END;
      END;
    END;

    [External]
    PROCEDURE CheckWhseDocLine@1();
    VAR
      PostedWhseRcptLine@1004 : Record 7319;
      WhseShptLine@1001 : Record 7321;
      WhseInternalPutAwayLine@1005 : Record 7332;
      WhseInternalPickLine@1002 : Record 7334;
      ProdOrderCompLine@1000 : Record 5407;
      AssemblyLine@1003 : Record 901;
      WhseDocType2@1006 : Option;
    BEGIN
      IF "Bin Code" <> '' THEN BEGIN
        IF "Breakbulk No." <> 0 THEN
          EXIT;
        IF ("Activity Type" = "Activity Type"::Pick) AND
           ("Action Type" = "Action Type"::Place)
        THEN BEGIN
          IF ("Whse. Document Type" = "Whse. Document Type"::Shipment) AND "Assemble to Order" THEN
            WhseDocType2 := "Whse. Document Type"::Assembly
          ELSE
            WhseDocType2 := "Whse. Document Type";
          CASE WhseDocType2 OF
            "Whse. Document Type"::Shipment:
              BEGIN
                WhseShptLine.GET("Whse. Document No.","Whse. Document Line No.");
                TESTFIELD("Bin Code",WhseShptLine."Bin Code");
              END;
            "Whse. Document Type"::"Internal Pick":
              BEGIN
                WhseInternalPickLine.GET("Whse. Document No.","Whse. Document Line No.");
                TESTFIELD("Bin Code",WhseInternalPickLine."To Bin Code");
              END;
            "Whse. Document Type"::Production:
              BEGIN
                GetLocation("Location Code");
                IF Location."Directed Put-away and Pick" THEN BEGIN
                  ProdOrderCompLine.GET("Source Subtype","Source No.","Source Line No.","Source Subline No.");
                  TESTFIELD("Bin Code",ProdOrderCompLine."Bin Code");
                END;
              END;
            "Whse. Document Type"::Assembly:
              BEGIN
                GetLocation("Location Code");
                IF Location."Directed Put-away and Pick" THEN BEGIN
                  AssemblyLine.GET("Source Subtype","Source No.","Source Line No.");
                  TESTFIELD("Bin Code",AssemblyLine."Bin Code");
                END;
              END;
          END;
        END;
        IF ("Activity Type" = "Activity Type"::"Put-away") AND
           ("Action Type" = "Action Type"::Take)
        THEN
          CASE "Whse. Document Type" OF
            "Whse. Document Type"::Receipt:
              BEGIN
                PostedWhseRcptLine.GET("Whse. Document No.","Whse. Document Line No.");
                TESTFIELD("Bin Code",PostedWhseRcptLine."Bin Code");
              END;
            "Whse. Document Type"::"Internal Put-away":
              BEGIN
                WhseInternalPutAwayLine.GET("Whse. Document No.","Whse. Document Line No.");
                TESTFIELD("Bin Code",WhseInternalPutAwayLine."From Bin Code");
              END;
          END;
      END;
    END;

    [External]
    PROCEDURE CheckBinInSourceDoc@8();
    VAR
      ProdOrderComponentLine@1001 : Record 5407;
      AssemblyLine@1000 : Record 901;
    BEGIN
      IF NOT (("Activity Type" = "Activity Type"::"Invt. Movement") AND
              ("Action Type" = "Action Type"::Place) AND
              ("Source Type" <> 0))
      THEN
        EXIT;

      CASE "Source Type" OF
        DATABASE::"Prod. Order Component":
          BEGIN
            ProdOrderComponentLine.GET(
              "Source Subtype","Source No.",
              "Source Line No.","Source Subline No.");
            TESTFIELD("Bin Code",ProdOrderComponentLine."Bin Code");
          END;
        DATABASE::"Assembly Line":
          BEGIN
            AssemblyLine.GET(
              "Source Subtype","Source No.",
              "Source Line No.");
            TESTFIELD("Bin Code",AssemblyLine."Bin Code");
          END;
      END;
    END;

    [External]
    PROCEDURE GetBin@19(LocationCode@1000 : Code[10];BinCode@1002 : Code[20]) : Boolean;
    BEGIN
      IF (Bin."Location Code" <> LocationCode) OR
         (Bin.Code <> BinCode)
      THEN BEGIN
        GetLocation(LocationCode);
        IF NOT Location."Directed Put-away and Pick" THEN
          EXIT(TRUE);
        IF Bin.GET(LocationCode,BinCode) THEN BEGIN
          CheckBin;
          EXIT(TRUE);
        END;
        EXIT(FALSE);
      END;

      CheckBin;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetItemUnitOfMeasure@18();
    BEGIN
      GetItem;
      Item.TESTFIELD("No.");
      IF (Item."No." <> ItemUnitOfMeasure."Item No.") OR
         ("Unit of Measure Code" <> ItemUnitOfMeasure.Code)
      THEN
        IF NOT ItemUnitOfMeasure.GET(Item."No.","Unit of Measure Code") THEN
          ItemUnitOfMeasure.GET(Item."No.",Item."Base Unit of Measure");
    END;

    LOCAL PROCEDURE GetLocation@2(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE CheckBin@17();
    BEGIN
      GetLocation("Location Code");
      Location.TESTFIELD("Directed Put-away and Pick");
      IF Location."Adjustment Bin Code" <> '' THEN
        IF "Bin Code" = Location."Adjustment Bin Code" THEN
          ERROR(
            Text011,
            Location.FIELDCAPTION("Adjustment Bin Code"),Location.TABLECAPTION,
            FIELDCAPTION("Bin Code"));
    END;

    LOCAL PROCEDURE CheckIncreaseCapacity@6(DeductLineCapacity@1003 : Boolean);
    VAR
      BinContent@1002 : Record 7302;
      DeductCubage@1001 : Decimal;
      DeductWeight@1000 : Decimal;
    BEGIN
      IF DeductLineCapacity THEN BEGIN
        DeductCubage := xRec.Cubage;
        DeductWeight := xRec.Weight;
      END;

      IF BinContent.GET("Location Code","Bin Code","Item No.","Variant Code","Unit of Measure Code") THEN
        BinContent.CheckIncreaseBinContent(
          "Qty. to Handle (Base)","Qty. Outstanding (Base)",
          DeductCubage,DeductWeight,Cubage,Weight,FALSE,FALSE)
      ELSE
        Bin.CheckIncreaseBin(
          "Bin Code","Item No.","Qty. to Handle",
          DeductCubage,DeductWeight,Cubage,Weight,FALSE,FALSE);
    END;

    [External]
    PROCEDURE SplitLine@27(VAR WhseActivLine@1000 : Record 5767);
    VAR
      NewWhseActivLine@1002 : Record 5767;
      LineSpacing@1001 : Integer;
      NewLineNo@1005 : Integer;
    BEGIN
      WhseActivLine.TESTFIELD("Qty. to Handle");
      IF WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::"Put-away" THEN BEGIN
        IF WhseActivLine."Breakbulk No." <> 0 THEN
          ERROR(Text007);
        WhseActivLine.TESTFIELD("Action Type",WhseActivLine."Action Type"::Place);
      END;
      IF WhseActivLine."Qty. to Handle" = WhseActivLine."Qty. Outstanding" THEN
        WhseActivLine.FIELDERROR(
          "Qty. to Handle",STRSUBSTNO(Text003,WhseActivLine.FIELDCAPTION("Qty. Outstanding")));
      NewWhseActivLine := WhseActivLine;
      NewWhseActivLine.SETRANGE("No.",WhseActivLine."No.");
      IF NewWhseActivLine.FIND('>') THEN
        LineSpacing :=
          (NewWhseActivLine."Line No." - WhseActivLine."Line No.") DIV 2
      ELSE
        LineSpacing := 10000;

      IF LineSpacing = 0 THEN BEGIN
        ReNumberAllLines(NewWhseActivLine,WhseActivLine."Line No.",NewLineNo);
        WhseActivLine.GET(WhseActivLine."Activity Type",WhseActivLine."No.",NewLineNo);
        LineSpacing := 5000;
      END;

      NewWhseActivLine.RESET;
      NewWhseActivLine.INIT;
      NewWhseActivLine := WhseActivLine;
      NewWhseActivLine."Line No." := NewWhseActivLine."Line No." + LineSpacing;
      NewWhseActivLine.Quantity :=
        WhseActivLine."Qty. Outstanding" - WhseActivLine."Qty. to Handle";
      NewWhseActivLine."Qty. (Base)" :=
        WhseActivLine."Qty. Outstanding (Base)" - WhseActivLine."Qty. to Handle (Base)";
      NewWhseActivLine."Qty. Outstanding" := NewWhseActivLine.Quantity;
      NewWhseActivLine."Qty. Outstanding (Base)" := NewWhseActivLine."Qty. (Base)";
      NewWhseActivLine."Qty. to Handle" := NewWhseActivLine.Quantity;
      NewWhseActivLine."Qty. to Handle (Base)" := NewWhseActivLine."Qty. (Base)";
      NewWhseActivLine."Qty. Handled" := 0;
      NewWhseActivLine."Qty. Handled (Base)" := 0;
      GetLocation("Location Code");
      IF Location."Directed Put-away and Pick" THEN BEGIN
        WMSMgt.CalcCubageAndWeight(
          NewWhseActivLine."Item No.",NewWhseActivLine."Unit of Measure Code",
          NewWhseActivLine."Qty. to Handle",NewWhseActivLine.Cubage,NewWhseActivLine.Weight);
        IF NOT
           (((NewWhseActivLine."Activity Type" = NewWhseActivLine."Activity Type"::"Put-away") AND
             (NewWhseActivLine."Action Type" = NewWhseActivLine."Action Type"::Take)) OR
            ((NewWhseActivLine."Activity Type" = NewWhseActivLine."Activity Type"::Pick) AND
             (NewWhseActivLine."Action Type" = NewWhseActivLine."Action Type"::Place)) OR
            ("Breakbulk No." <> 0))
        THEN BEGIN
          NewWhseActivLine."Zone Code" := '';
          NewWhseActivLine."Bin Code" := '';
        END;
      END;
      NewWhseActivLine.INSERT;

      WhseActivLine.Quantity := WhseActivLine."Qty. to Handle" + WhseActivLine."Qty. Handled";
      WhseActivLine."Qty. (Base)" :=
        WhseActivLine."Qty. to Handle (Base)" + WhseActivLine."Qty. Handled (Base)";
      WhseActivLine."Qty. Outstanding" := WhseActivLine."Qty. to Handle";
      WhseActivLine."Qty. Outstanding (Base)" := WhseActivLine."Qty. to Handle (Base)";
      IF Location."Directed Put-away and Pick" THEN
        WMSMgt.CalcCubageAndWeight(
          WhseActivLine."Item No.",WhseActivLine."Unit of Measure Code",
          WhseActivLine."Qty. to Handle",WhseActivLine.Cubage,WhseActivLine.Weight);
      WhseActivLine.MODIFY;
    END;

    LOCAL PROCEDURE UpdateBreakbulkQtytoHandle@4();
    VAR
      WhseActivLine@1000 : Record 5767;
    BEGIN
      WhseActivLine.SETCURRENTKEY(
        "Activity Type","No.","Whse. Document Type",
        "Whse. Document No.","Whse. Document Line No.");
      WhseActivLine.SETRANGE("Activity Type","Activity Type");
      WhseActivLine.SETRANGE("No.","No.");
      WhseActivLine.SETRANGE("Whse. Document Type","Whse. Document Type");
      WhseActivLine.SETRANGE("Whse. Document No.","Whse. Document No.");
      WhseActivLine.SETRANGE("Whse. Document Line No.","Whse. Document Line No.");
      WhseActivLine.SETRANGE("Bin Code","Bin Code");
      WhseActivLine.SETRANGE("Lot No.","Lot No.");
      IF "Original Breakbulk" THEN
        WhseActivLine.SETRANGE("Original Breakbulk",TRUE)
      ELSE
        WhseActivLine.SETRANGE("Breakbulk No.","Breakbulk No.");
      WhseActivLine.SETRANGE("Action Type",WhseActivLine."Action Type"::Place);
      IF WhseActivLine.FINDFIRST THEN BEGIN
        WhseActivLine."Qty. to Handle (Base)" := "Qty. to Handle (Base)";
        WhseActivLine."Qty. to Handle" := WhseActivLine.CalcQty("Qty. to Handle (Base)");
        WMSMgt.CalcCubageAndWeight(
          WhseActivLine."Item No.",WhseActivLine."Unit of Measure Code",
          WhseActivLine."Qty. to Handle",WhseActivLine.Cubage,WhseActivLine.Weight);
        WhseActivLine.MODIFY;

        WhseActivLine.SETRANGE("Action Type",WhseActivLine."Action Type"::Take);
        IF "Original Breakbulk" THEN BEGIN
          WhseActivLine.SETRANGE("Original Breakbulk");
          WhseActivLine.SETRANGE("Breakbulk No.",WhseActivLine."Breakbulk No.")
        END ELSE BEGIN
          WhseActivLine.SETRANGE("Breakbulk No.");
          WhseActivLine.SETRANGE("Original Breakbulk",TRUE);
        END;
        IF WhseActivLine.FINDFIRST THEN BEGIN
          WhseActivLine."Qty. to Handle (Base)" := "Qty. to Handle (Base)";
          WhseActivLine."Qty. to Handle" := WhseActivLine.CalcQty("Qty. to Handle (Base)");
          WMSMgt.CalcCubageAndWeight(
            WhseActivLine."Item No.",WhseActivLine."Unit of Measure Code",
            WhseActivLine."Qty. to Handle",WhseActivLine.Cubage,WhseActivLine.Weight);
          WhseActivLine.MODIFY;
        END;
      END;
    END;

    [External]
    PROCEDURE ShowWhseDoc@22();
    VAR
      WhseShptHeader@1015 : Record 7320;
      PostedWhseRcptHeader@1014 : Record 7318;
      WhseIntPickHeader@1013 : Record 7333;
      WhseIntPutawayHeader@1012 : Record 7331;
      RelProdOrder@1001 : Record 5405;
      AssemblyHeader@1002 : Record 900;
      WhseShptCard@1011 : Page 7335;
      PostedWhseRcptCard@1006 : Page 7330;
      WhseIntPickCard@1004 : Page 7357;
      WhseIntPutawayCard@1000 : Page 7354;
    BEGIN
      CASE "Whse. Document Type" OF
        "Whse. Document Type"::Shipment:
          BEGIN
            WhseShptHeader.SETRANGE("No.","Whse. Document No.");
            WhseShptCard.SETTABLEVIEW(WhseShptHeader);
            WhseShptCard.RUNMODAL;
          END;
        "Whse. Document Type"::Receipt:
          BEGIN
            PostedWhseRcptHeader.SETRANGE("No.","Whse. Document No.");
            PostedWhseRcptCard.SETTABLEVIEW(PostedWhseRcptHeader);
            PostedWhseRcptCard.RUNMODAL;
          END;
        "Whse. Document Type"::"Internal Pick":
          BEGIN
            WhseIntPickHeader.SETRANGE("No.","Whse. Document No.");
            WhseIntPickHeader.FINDFIRST;
            WhseIntPickCard.SETRECORD(WhseIntPickHeader);
            WhseIntPickCard.SETTABLEVIEW(WhseIntPickHeader);
            WhseIntPickCard.RUNMODAL;
          END;
        "Whse. Document Type"::"Internal Put-away":
          BEGIN
            WhseIntPutawayHeader.SETRANGE("No.","Whse. Document No.");
            WhseIntPutawayHeader.FINDFIRST;
            WhseIntPutawayCard.SETRECORD(WhseIntPutawayHeader);
            WhseIntPutawayCard.SETTABLEVIEW(WhseIntPutawayHeader);
            WhseIntPutawayCard.RUNMODAL;
          END;
        "Whse. Document Type"::Production:
          BEGIN
            RelProdOrder.SETRANGE(Status,"Source Subtype");
            RelProdOrder.SETRANGE("No.","Source No.");
            PAGE.RUNMODAL(PAGE::"Released Production Order",RelProdOrder);
          END;
        "Whse. Document Type"::Assembly:
          BEGIN
            AssemblyHeader.SETRANGE("Document Type","Source Subtype");
            AssemblyHeader.SETRANGE("No.","Source No.");
            PAGE.RUNMODAL(PAGE::"Assembly Order",AssemblyHeader);
          END;
      END;
    END;

    [External]
    PROCEDURE ShowActivityDoc@23();
    VAR
      WhseActivHeader@1001 : Record 5766;
      WhsePickCard@1011 : Page 5779;
      WhsePutawayCard@1006 : Page 5770;
      WhseMovCard@1004 : Page 7315;
      InvtPickCard@1000 : Page 7377;
      InvtPutAwayCard@1002 : Page 7375;
    BEGIN
      WhseActivHeader.SETRANGE(Type,"Activity Type");
      WhseActivHeader.SETRANGE("No.","No.");
      CASE "Activity Type" OF
        "Activity Type"::Pick:
          BEGIN
            WhsePickCard.SETTABLEVIEW(WhseActivHeader);
            WhsePickCard.RUNMODAL;
          END;
        "Activity Type"::"Put-away":
          BEGIN
            WhsePutawayCard.SETTABLEVIEW(WhseActivHeader);
            WhsePutawayCard.RUNMODAL;
          END;
        "Activity Type"::Movement:
          BEGIN
            WhseMovCard.SETTABLEVIEW(WhseActivHeader);
            WhseMovCard.RUNMODAL;
          END;
        "Activity Type"::"Invt. Pick":
          BEGIN
            InvtPickCard.SETTABLEVIEW(WhseActivHeader);
            InvtPickCard.RUNMODAL;
          END;
        "Activity Type"::"Invt. Put-away":
          BEGIN
            InvtPutAwayCard.SETTABLEVIEW(WhseActivHeader);
            InvtPutAwayCard.RUNMODAL;
          END;
        "Activity Type"::"Invt. Movement":
          PAGE.RUNMODAL(PAGE::"Inventory Movement",WhseActivHeader);
      END;
    END;

    [External]
    PROCEDURE ChangeUOMCode@35(VAR WhseActivLine@1000 : Record 5767;VAR WhseActivLine2@1003 : Record 5767);
    BEGIN
      IF "Breakbulk No." = 0 THEN
        IF (Quantity <> "Qty. to Handle") OR ("Qty. Handled" <> 0) THEN
          CreateNewUOMLine("Action Type",WhseActivLine,WhseActivLine2)
        ELSE BEGIN
          Rec := WhseActivLine2;
          GetLocation("Location Code");
          IF Location."Directed Put-away and Pick" THEN
            WMSMgt.CalcCubageAndWeight(
              "Item No.","Unit of Measure Code","Qty. to Handle",Cubage,Weight);
          MODIFY;
        END;
    END;

    LOCAL PROCEDURE CreateNewUOMLine@34(ActType@1000 : ',Take,Place';WhseActivLine@1001 : Record 5767;WhseActivLine2@1002 : Record 5767);
    VAR
      NewWhseActivLine@1004 : Record 5767;
      LineSpacing@1003 : Integer;
    BEGIN
      NewWhseActivLine := WhseActivLine;
      IF NewWhseActivLine.FIND('>') THEN
        LineSpacing :=
          (NewWhseActivLine."Line No." - WhseActivLine."Line No.") DIV 2
      ELSE
        LineSpacing := 10000;

      NewWhseActivLine.RESET;
      NewWhseActivLine.INIT;
      NewWhseActivLine := WhseActivLine2;
      NewWhseActivLine."Line No." := NewWhseActivLine."Line No." + LineSpacing;
      GetLocation("Location Code");
      IF Location."Directed Put-away and Pick" THEN
        WMSMgt.CalcCubageAndWeight(
          NewWhseActivLine."Item No.",NewWhseActivLine."Unit of Measure Code",
          NewWhseActivLine."Qty. to Handle",NewWhseActivLine.Cubage,NewWhseActivLine.Weight);
      NewWhseActivLine."Action Type" := ActType;
      NewWhseActivLine.VALIDATE("Qty. Handled",0);
      NewWhseActivLine.INSERT;

      WhseActivLine."Qty. Outstanding" :=
        WhseActivLine."Qty. Outstanding" - WhseActivLine."Qty. to Handle";
      WhseActivLine."Qty. Outstanding (Base)" :=
        WhseActivLine."Qty. Outstanding (Base)" - WhseActivLine."Qty. to Handle (Base)";
      WhseActivLine.Quantity :=
        WhseActivLine.Quantity - WhseActivLine."Qty. to Handle";
      WhseActivLine."Qty. (Base)" :=
        WhseActivLine."Qty. (Base)" - WhseActivLine."Qty. to Handle (Base)";
      WhseActivLine.VALIDATE("Qty. to Handle",WhseActivLine."Qty. Outstanding");
      IF Location."Directed Put-away and Pick" THEN
        WMSMgt.CalcCubageAndWeight(
          WhseActivLine."Item No.",WhseActivLine."Unit of Measure Code",
          WhseActivLine."Qty. to Handle",WhseActivLine.Cubage,WhseActivLine.Weight);
      WhseActivLine.MODIFY;
    END;

    LOCAL PROCEDURE UpdateRelatedItemTrkg@3(WhseActivLine@1000 : Record 5767);
    VAR
      WhseItemTrkgLine@1002 : Record 6550;
      WhseDocType2@1001 : Option;
    BEGIN
      IF WhseActivLine.TrackingExists THEN BEGIN
        WhseItemTrkgLine.SETCURRENTKEY("Serial No.","Lot No.");
        WhseItemTrkgLine.SETRANGE("Serial No.",WhseActivLine."Serial No.");
        WhseItemTrkgLine.SETRANGE("Lot No.",WhseActivLine."Lot No.");
        IF (WhseActivLine."Whse. Document Type" = WhseActivLine."Whse. Document Type"::Shipment) AND
           WhseActivLine."Assemble to Order"
        THEN
          WhseDocType2 := WhseActivLine."Whse. Document Type"::Assembly
        ELSE
          WhseDocType2 := WhseActivLine."Whse. Document Type";
        CASE WhseDocType2 OF
          WhseActivLine."Whse. Document Type"::Shipment:
            BEGIN
              WhseItemTrkgLine.SETRANGE("Source Type",DATABASE::"Warehouse Shipment Line");
              WhseItemTrkgLine.SETRANGE("Source ID",WhseActivLine."Whse. Document No.");
              WhseItemTrkgLine.SETRANGE("Source Ref. No.",WhseActivLine."Whse. Document Line No.");
            END;
          WhseActivLine."Whse. Document Type"::"Internal Pick":
            BEGIN
              WhseItemTrkgLine.SETRANGE("Source Type",DATABASE::"Whse. Internal Pick Line");
              WhseItemTrkgLine.SETRANGE("Source ID",WhseActivLine."Whse. Document No.");
              WhseItemTrkgLine.SETRANGE("Source Ref. No.",WhseActivLine."Whse. Document Line No.");
            END;
          WhseActivLine."Whse. Document Type"::"Internal Put-away":
            BEGIN
              WhseItemTrkgLine.SETRANGE("Source Type",DATABASE::"Whse. Internal Put-away Line");
              WhseItemTrkgLine.SETRANGE("Source ID",WhseActivLine."Whse. Document No.");
              WhseItemTrkgLine.SETRANGE("Source Ref. No.",WhseActivLine."Whse. Document Line No.");
            END;
          WhseActivLine."Whse. Document Type"::Production:
            BEGIN
              WhseItemTrkgLine.SETRANGE("Source Type",WhseActivLine."Source Type");
              WhseItemTrkgLine.SETRANGE("Source Subtype",WhseActivLine."Source Subtype");
              WhseItemTrkgLine.SETRANGE("Source ID",WhseActivLine."Source No.");
              WhseItemTrkgLine.SETRANGE("Source Prod. Order Line",WhseActivLine."Source Line No.");
              WhseItemTrkgLine.SETRANGE("Source Ref. No.",WhseActivLine."Source Subline No.");
            END;
          WhseActivLine."Whse. Document Type"::Assembly:
            BEGIN
              WhseItemTrkgLine.SETRANGE("Source Type",WhseActivLine."Source Type");
              WhseItemTrkgLine.SETRANGE("Source Subtype",WhseActivLine."Source Subtype");
              WhseItemTrkgLine.SETRANGE("Source ID",WhseActivLine."Source No.");
              WhseItemTrkgLine.SETRANGE("Source Ref. No.",WhseActivLine."Source Line No.");
            END;
        END;
        IF WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::"Invt. Movement" THEN
          CASE WhseActivLine."Source Type" OF
            DATABASE::"Prod. Order Component":
              BEGIN
                WhseItemTrkgLine.SETRANGE("Source Type",DATABASE::"Prod. Order Component");
                WhseItemTrkgLine.SETRANGE("Source Subtype",WhseActivLine."Source Subtype");
                WhseItemTrkgLine.SETRANGE("Source ID",WhseActivLine."Source No.");
                WhseItemTrkgLine.SETRANGE("Source Prod. Order Line",WhseActivLine."Source Line No.");
                WhseItemTrkgLine.SETRANGE("Source Ref. No.",WhseActivLine."Source Subline No.");
              END;
            DATABASE::"Assembly Line":
              BEGIN
                WhseItemTrkgLine.SETRANGE("Source Type",DATABASE::"Assembly Line");
                WhseItemTrkgLine.SETRANGE("Source Subtype",WhseActivLine."Source Subtype");
                WhseItemTrkgLine.SETRANGE("Source ID",WhseActivLine."Source No.");
                WhseItemTrkgLine.SETRANGE("Source Ref. No.",WhseActivLine."Source Line No.");
              END;
          END;
        IF WhseItemTrkgLine.FIND('-') THEN
          REPEAT
            ItemTrackingMgt.CalcWhseItemTrkgLine(WhseItemTrkgLine);
            UpdateReservation(WhseActivLine,TRUE);
            IF ((WhseActivLine."Whse. Document Type" IN
                 [WhseActivLine."Whse. Document Type"::Production,WhseActivLine."Whse. Document Type"::Assembly]) OR
                (WhseActivLine."Activity Type" = WhseActivLine."Activity Type"::"Invt. Movement")) AND
               (WhseItemTrkgLine."Quantity Handled (Base)" = 0)
            THEN
              WhseItemTrkgLine.DELETE
            ELSE
              WhseItemTrkgLine.MODIFY;
          UNTIL WhseItemTrkgLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE LookUpTrackingSummary@50(VAR WhseActivLine@1000 : Record 5767;SearchForSupply@1003 : Boolean;SignFactor@1004 : Integer;TrackingType@1002 : 'SerialNo,LotNo');
    VAR
      TempTrackingSpecification@1001 : TEMPORARY Record 336;
    BEGIN
      WITH WhseActivLine DO BEGIN
        InitTrackingSpecFromWhseActivLine(TempTrackingSpecification,WhseActivLine);
        TempTrackingSpecification."Quantity (Base)" := "Qty. Outstanding (Base)";
        TempTrackingSpecification."Qty. to Handle" := "Qty. Outstanding";
        TempTrackingSpecification."Qty. to Handle (Base)" := "Qty. Outstanding (Base)";
        TempTrackingSpecification."Qty. to Invoice" := 0;
        TempTrackingSpecification."Qty. to Invoice (Base)" := 0;
        TempTrackingSpecification."Quantity Handled (Base)" := 0;
        TempTrackingSpecification."Quantity Invoiced (Base)" := 0;

        GetItem;
        IF NOT ItemTrackingDataCollection.CurrentDataSetMatches("Item No.","Variant Code","Location Code") THEN
          CLEAR(ItemTrackingDataCollection);
        ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode("Bin Code",ItemTrackingCode);
        ItemTrackingDataCollection.AssistEditTrackingNo(
          TempTrackingSpecification,SearchForSupply,SignFactor,TrackingType,"Qty. Outstanding");

        CASE TrackingType OF
          TrackingType::SerialNo:
            IF TempTrackingSpecification."Serial No." <> '' THEN BEGIN
              VALIDATE("Serial No.",TempTrackingSpecification."Serial No.");
              VALIDATE("Lot No.",TempTrackingSpecification."Lot No.");
              VALIDATE("Expiration Date",TempTrackingSpecification."Expiration Date");
              MODIFY;
            END;
          TrackingType::LotNo:
            IF TempTrackingSpecification."Lot No." <> '' THEN BEGIN
              VALIDATE("Lot No.",TempTrackingSpecification."Lot No.");
              VALIDATE("Expiration Date",TempTrackingSpecification."Expiration Date");
              MODIFY;
            END;
        END;
      END;
    END;

    LOCAL PROCEDURE CheckReservedItemTrkg@7(CheckType@1001 : 'Serial No.,Lot No.';ItemTrkgCode@1000 : Code[20]);
    VAR
      Item@1006 : Record 27;
      ReservEntry@1002 : Record 337;
      ReservEntry2@1003 : Record 337;
      TempWhseActivLine@1005 : TEMPORARY Record 5767;
      WhseAvailMgt@1004 : Codeunit 7314;
      LineReservedQty@1007 : Decimal;
      AvailQtyFromOtherResvLines@1008 : Decimal;
    BEGIN
      IF ("Activity Type" = "Activity Type"::"Invt. Pick") AND "Assemble to Order" THEN
        EXIT;
      CASE CheckType OF
        CheckType::"Serial No.":
          BEGIN
            ReservEntry.SETCURRENTKEY("Item No.","Variant Code","Location Code","Reservation Status");
            ReservEntry.SETRANGE("Item No.","Item No.");
            ReservEntry.SETRANGE("Variant Code","Variant Code");
            ReservEntry.SETRANGE("Location Code","Location Code");
            ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Reservation);
            ReservEntry.SETRANGE("Serial No.",ItemTrkgCode);
            ReservEntry.SETRANGE(Positive,FALSE);
            IF ReservEntry.FIND('-') AND
               ((ReservEntry."Source Type" <> "Source Type") OR
                (ReservEntry."Source Subtype" <> "Source Subtype") OR
                (ReservEntry."Source ID" <> "Source No.") OR
                (((ReservEntry."Source Ref. No." <> "Source Line No.") AND
                  (ReservEntry."Source Type" <> DATABASE::"Prod. Order Component")) OR
                 (((ReservEntry."Source Prod. Order Line" <> "Source Line No.") OR
                   (ReservEntry."Source Ref. No." <> "Source Subline No.")) AND
                  (ReservEntry."Source Type" = DATABASE::"Prod. Order Component"))))
            THEN
              ERROR(Text014,FIELDCAPTION("Serial No."),ItemTrkgCode);
          END;
        CheckType::"Lot No.":
          BEGIN
            Item.GET("Item No.");
            Item.SETRANGE("Location Filter","Location Code");
            Item.SETRANGE("Variant Filter","Variant Code");
            Item.SETRANGE("Lot No. Filter",ItemTrkgCode);
            Item.CALCFIELDS(Inventory,"Reserved Qty. on Inventory");
            LineReservedQty :=
              WhseAvailMgt.CalcLineReservedQtyOnInvt(
                "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",TRUE,'',
                ItemTrkgCode,TempWhseActivLine);
            ReservEntry.SETCURRENTKEY("Item No.","Variant Code","Location Code","Reservation Status");
            ReservEntry.SETRANGE("Item No.","Item No.");
            ReservEntry.SETRANGE("Variant Code","Variant Code");
            ReservEntry.SETRANGE("Location Code","Location Code");
            ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Reservation);
            ReservEntry.SETRANGE("Lot No.",ItemTrkgCode);
            ReservEntry.SETRANGE(Positive,TRUE);
            IF ReservEntry.FIND('-') THEN
              REPEAT
                ReservEntry2.GET(ReservEntry."Entry No.",FALSE);
                IF ((ReservEntry2."Source Type" <> "Source Type") OR
                    (ReservEntry2."Source Subtype" <> "Source Subtype") OR
                    (ReservEntry2."Source ID" <> "Source No.") OR
                    (((ReservEntry2."Source Ref. No." <> "Source Line No.") AND
                      (ReservEntry2."Source Type" <> DATABASE::"Prod. Order Component")) OR
                     (((ReservEntry2."Source Prod. Order Line" <> "Source Line No.") OR
                       (ReservEntry2."Source Ref. No." <> "Source Subline No.")) AND
                      (ReservEntry2."Source Type" = DATABASE::"Prod. Order Component")))) AND
                   (ReservEntry2."Lot No." = '')
                THEN
                  AvailQtyFromOtherResvLines := AvailQtyFromOtherResvLines + ABS(ReservEntry2."Quantity (Base)");
              UNTIL ReservEntry.NEXT = 0;

            IF (Item.Inventory - ABS(Item."Reserved Qty. on Inventory") +
                LineReservedQty + AvailQtyFromOtherResvLines +
                WhseAvailMgt.CalcReservQtyOnPicksShips("Location Code","Item No.","Variant Code",TempWhseActivLine)) <
               "Qty. to Handle (Base)"
            THEN
              ERROR(Text017,FIELDCAPTION("Lot No."),ItemTrkgCode);
          END;
      END;
    END;

    [External]
    PROCEDURE DeleteBinContent@21(ActionType@1002 : Option);
    VAR
      BinContent@1000 : Record 7302;
    BEGIN
      IF "Action Type" <> ActionType THEN
        EXIT;

      IF BinContent.GET("Location Code","Bin Code","Item No.","Variant Code","Unit of Measure Code") THEN
        IF NOT BinContent.Fixed AND
           (BinContent."Min. Qty." = 0) AND (BinContent."Max. Qty." = 0)
        THEN BEGIN
          BinContent.CALCFIELDS("Quantity (Base)","Positive Adjmt. Qty. (Base)","Put-away Quantity (Base)");
          IF (BinContent."Quantity (Base)" = 0) AND
             (BinContent."Positive Adjmt. Qty. (Base)" = 0) AND
             (BinContent."Put-away Quantity (Base)" - "Qty. Outstanding (Base)" <= 0)
          THEN
            BinContent.DELETE;
        END;
    END;

    LOCAL PROCEDURE UpdateReservation@90(TempWhseActivLine2@1000 : TEMPORARY Record 5767;Deletion@1002 : Boolean);
    VAR
      TempTrackingSpecification@1001 : TEMPORARY Record 336;
    BEGIN
      WITH TempWhseActivLine2 DO BEGIN
        IF ("Action Type" <> "Action Type"::Take) AND ("Breakbulk No." = 0) AND
           ("Whse. Document Type" = "Whse. Document Type"::Shipment)
        THEN BEGIN
          InitTrackingSpecFromWhseActivLine(TempTrackingSpecification,TempWhseActivLine2);
          IF "Source Type" <> DATABASE::"Prod. Order Component" THEN BEGIN
            TempTrackingSpecification."Source Prod. Order Line" := 0;
            TempTrackingSpecification."Source Ref. No." := "Source Line No.";
          END;
          TempTrackingSpecification."Qty. to Handle (Base)" := 0;
          TempTrackingSpecification."Entry No." := TempTrackingSpecification."Entry No." + 1;
          TempTrackingSpecification."Creation Date" := TODAY;
          TempTrackingSpecification."Warranty Date" := "Warranty Date";
          TempTrackingSpecification."Expiration Date" := "Expiration Date";
          TempTrackingSpecification.Correction := TRUE;
          TempTrackingSpecification.INSERT;
        END;
        ItemTrackingMgt.SetPick("Activity Type" = "Activity Type"::Pick);
        ItemTrackingMgt.SynchronizeWhseItemTracking(TempTrackingSpecification,'',Deletion);
      END;
    END;

    [External]
    PROCEDURE TransferFromPickWkshLine@29(WhseWkshLine@1010 : Record 7326);
    VAR
      WhseShptLine@1000 : Record 7321;
      AssembleToOrderLink@1002 : Record 904;
    BEGIN
      "Activity Type" := "Activity Type"::Pick;
      "Source Type" := WhseWkshLine."Source Type";
      "Source Subtype" := WhseWkshLine."Source Subtype";
      "Source No." := WhseWkshLine."Source No.";
      "Source Line No." := WhseWkshLine."Source Line No.";
      "Source Subline No." := WhseWkshLine."Source Subline No.";
      "Shelf No." := WhseWkshLine."Shelf No.";
      "Item No." := WhseWkshLine."Item No.";
      "Variant Code" := WhseWkshLine."Variant Code";
      Description := WhseWkshLine.Description;
      "Description 2" := WhseWkshLine."Description 2";
      "Due Date" := WhseWkshLine."Due Date";
      "Starting Date" := WORKDATE;
      "Destination Type" := WhseWkshLine."Destination Type";
      "Destination No." := WhseWkshLine."Destination No.";
      "Shipping Agent Code" := WhseWkshLine."Shipping Agent Code";
      "Shipping Agent Service Code" := WhseWkshLine."Shipping Agent Service Code";
      "Shipment Method Code" := WhseWkshLine."Shipment Method Code";
      "Shipping Advice" := WhseWkshLine."Shipping Advice";
      "Whse. Document Type" := WhseWkshLine."Whse. Document Type";
      "Whse. Document No." := WhseWkshLine."Whse. Document No.";
      "Whse. Document Line No." := WhseWkshLine."Whse. Document Line No.";

      CASE "Whse. Document Type" OF
        "Whse. Document Type"::Shipment:
          BEGIN
            WhseShptLine.GET("Whse. Document No.","Whse. Document Line No.");
            "Assemble to Order" := WhseShptLine."Assemble to Order";
            "ATO Component" := WhseShptLine."Assemble to Order";
          END;
        "Whse. Document Type"::Assembly:
          BEGIN
            "Assemble to Order" := AssembleToOrderLink.GET("Source Subtype","Source No.");
            "ATO Component" := TRUE;
          END;
      END;
    END;

    [External]
    PROCEDURE TransferFromShptLine@28(WhseShptLine@1005 : Record 7321);
    BEGIN
      "Activity Type" := "Activity Type"::Pick;
      "Source Type" := WhseShptLine."Source Type";
      "Source Subtype" := WhseShptLine."Source Subtype";
      "Source No." := WhseShptLine."Source No.";
      "Source Line No." := WhseShptLine."Source Line No.";
      "Shelf No." := WhseShptLine."Shelf No.";
      "Item No." := WhseShptLine."Item No.";
      "Variant Code" := WhseShptLine."Variant Code";
      Description := WhseShptLine.Description;
      "Description 2" := WhseShptLine."Description 2";
      "Due Date" := WhseShptLine."Due Date";
      "Starting Date" := WhseShptLine."Shipment Date";
      "Destination Type" := WhseShptLine."Destination Type";
      "Destination No." := WhseShptLine."Destination No.";
      "Shipping Advice" := WhseShptLine."Shipping Advice";
      "Whse. Document Type" := "Whse. Document Type"::Shipment;
      "Whse. Document No." := WhseShptLine."No.";
      "Whse. Document Line No." := WhseShptLine."Line No.";
    END;

    [External]
    PROCEDURE TransferFromATOShptLine@12(WhseShptLine@1005 : Record 7321;AssemblyLine@1000 : Record 901);
    BEGIN
      WhseShptLine.TESTFIELD("Assemble to Order",TRUE);
      TransferFromShptLine(WhseShptLine);
      TransferAllButWhseDocDetailsFromAssemblyLine(AssemblyLine);
    END;

    [External]
    PROCEDURE TransferFromIntPickLine@26(WhseInternalPickLine@1005 : Record 7334);
    BEGIN
      "Activity Type" := "Activity Type"::Pick;
      "Shelf No." := WhseInternalPickLine."Shelf No.";
      "Item No." := WhseInternalPickLine."Item No.";
      "Variant Code" := WhseInternalPickLine."Variant Code";
      Description := WhseInternalPickLine.Description;
      "Description 2" := WhseInternalPickLine."Description 2";
      "Due Date" := WhseInternalPickLine."Due Date";
      "Starting Date" := WORKDATE;
      "Source Type" := DATABASE::"Whse. Internal Pick Line";
      "Source No." := WhseInternalPickLine."No.";
      "Source Line No." := WhseInternalPickLine."Line No.";
      "Whse. Document Type" := "Whse. Document Type"::"Internal Pick";
      "Whse. Document No." := WhseInternalPickLine."No.";
      "Whse. Document Line No." := WhseInternalPickLine."Line No.";
    END;

    [External]
    PROCEDURE TransferFromCompLine@25(ProdOrderCompLine@1005 : Record 5407);
    BEGIN
      "Activity Type" := "Activity Type"::Pick;
      "Source Type" := DATABASE::"Prod. Order Component";
      "Source Subtype" := ProdOrderCompLine.Status;
      "Source No." := ProdOrderCompLine."Prod. Order No.";
      "Source Line No." := ProdOrderCompLine."Prod. Order Line No.";
      "Source Subline No." := ProdOrderCompLine."Line No.";
      "Item No." := ProdOrderCompLine."Item No.";
      "Variant Code" := ProdOrderCompLine."Variant Code";
      Description := ProdOrderCompLine.Description;
      "Due Date" := ProdOrderCompLine."Due Date";
      "Whse. Document Type" := "Whse. Document Type"::Production;
      "Whse. Document No." := ProdOrderCompLine."Prod. Order No.";
      "Whse. Document Line No." := ProdOrderCompLine."Prod. Order Line No.";
    END;

    [External]
    PROCEDURE TransferFromAssemblyLine@24(AssemblyLine@1005 : Record 901);
    BEGIN
      TransferAllButWhseDocDetailsFromAssemblyLine(AssemblyLine);
      "Whse. Document Type" := "Whse. Document Type"::Assembly;
      "Whse. Document No." := AssemblyLine."Document No.";
      "Whse. Document Line No." := AssemblyLine."Line No.";
    END;

    [External]
    PROCEDURE TransferFromMovWkshLine@20(WhseWkshLine@1010 : Record 7326);
    BEGIN
      "Activity Type" := "Activity Type"::Movement;
      "Item No." := WhseWkshLine."Item No.";
      "Variant Code" := WhseWkshLine."Variant Code";
      "Starting Date" := WORKDATE;
      Description := WhseWkshLine.Description;
      "Description 2" := WhseWkshLine."Description 2";
      "Due Date" := WhseWkshLine."Due Date";
      Dedicated := Bin.Dedicated;
      "Zone Code" := Bin."Zone Code";
      "Bin Ranking" := Bin."Bin Ranking";
      "Bin Type Code" := Bin."Bin Type Code";
      "Whse. Document Type" := "Whse. Document Type"::"Movement Worksheet";
      "Whse. Document No." := WhseWkshLine.Name;
      "Whse. Document Line No." := WhseWkshLine."Line No.";
    END;

    LOCAL PROCEDURE TransferAllButWhseDocDetailsFromAssemblyLine@31(AssemblyLine@1000 : Record 901);
    VAR
      AsmHeader@1001 : Record 900;
    BEGIN
      "Activity Type" := "Activity Type"::Pick;
      "Source Type" := DATABASE::"Assembly Line";
      "Source Subtype" := AssemblyLine."Document Type";
      "Source No." := AssemblyLine."Document No.";
      "Source Line No." := AssemblyLine."Line No.";
      "Source Subline No." := 0;
      AssemblyLine.TESTFIELD(Type,AssemblyLine.Type::Item);
      "Item No." := AssemblyLine."No.";
      "Variant Code" := AssemblyLine."Variant Code";
      Description := AssemblyLine.Description;
      "Description 2" := AssemblyLine."Description 2";
      "Due Date" := AssemblyLine."Due Date";
      AsmHeader.GET(AssemblyLine."Document Type",AssemblyLine."Document No.");
      AsmHeader.CALCFIELDS("Assemble to Order");
      "Assemble to Order" := AsmHeader."Assemble to Order";
      "ATO Component" := TRUE;
    END;

    LOCAL PROCEDURE CheckSNSpecificationExists@30();
    VAR
      WarehouseActivityLine@1000 : Record 5767;
    BEGIN
      IF "Serial No." <> '' THEN BEGIN
        WarehouseActivityLine.SETCURRENTKEY("Item No.");
        WarehouseActivityLine.SETRANGE("Activity Type","Activity Type");
        WarehouseActivityLine.SETRANGE("Action Type","Action Type");
        WarehouseActivityLine.SETRANGE("No.","No.");
        WarehouseActivityLine.SETRANGE("Item No.","Item No.");
        WarehouseActivityLine.SETFILTER("Line No.",'<>%1',"Line No.");
        WarehouseActivityLine.SETRANGE("Serial No.","Serial No.");
        IF NOT WarehouseActivityLine.ISEMPTY THEN
          ERROR(Text018,TABLECAPTION,FIELDCAPTION("Serial No."),"Serial No.");
      END;
    END;

    LOCAL PROCEDURE InitTrackingSpecFromWhseActivLine@37(VAR TrackingSpecification@1001 : Record 336;VAR WhseActivityLine@1000 : Record 5767);
    BEGIN
      WITH WhseActivityLine DO BEGIN
        TrackingSpecification.INIT;
        TrackingSpecification.SetSource(
          "Source Type","Source Subtype","Source No.","Source Line No.",'',"Source Subline No.");
        TrackingSpecification."Item No." := "Item No.";
        TrackingSpecification."Location Code" := "Location Code";
        TrackingSpecification.Description := Description;
        TrackingSpecification."Variant Code" := "Variant Code";
        TrackingSpecification."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
        TrackingSpecification."Serial No." := "Serial No.";
        TrackingSpecification."Lot No." := "Lot No.";
        TrackingSpecification."Expiration Date" := "Expiration Date";
        TrackingSpecification."Bin Code" := "Bin Code";
        TrackingSpecification."Qty. to Handle (Base)" := "Qty. to Handle (Base)";
      END;
    END;

    LOCAL PROCEDURE FindLotNoBySerialNo@32();
    VAR
      TempTrackingSpecification@1000 : TEMPORARY Record 336;
      CheckGlobalEntrySummary@1001 : Boolean;
      LotNo@1003 : Code[20];
    BEGIN
      InitTrackingSpecFromWhseActivLine(TempTrackingSpecification,Rec);
      CheckGlobalEntrySummary :=
        ("Activity Type" <> "Activity Type"::"Put-away") AND
        (NOT ("Source Document" IN
              ["Source Document"::"Purchase Order","Source Document"::"Prod. Output","Source Document"::"Assembly Order"]));
      IF CheckGlobalEntrySummary THEN
        VALIDATE("Lot No.",ItemTrackingDataCollection.FindLotNoBySN(TempTrackingSpecification))
      ELSE BEGIN
        IF NOT ItemTrackingDataCollection.FindLotNoBySNSilent(LotNo,TempTrackingSpecification) THEN
          LotNo := TempTrackingSpecification."Lot No.";
        VALIDATE("Lot No.",LotNo);
      END;
    END;

    LOCAL PROCEDURE CheckInvalidBinCode@33();
    VAR
      WhseActivLine@1000 : Record 5767;
      Location@1002 : Record 14;
      Direction@1001 : Text[1];
    BEGIN
      Location.GET("Location Code");
      IF ("Action Type" = 0) OR (NOT Location."Bin Mandatory") THEN
        EXIT;
      WhseActivLine := Rec;
      WhseActivLine.SETRANGE("Activity Type","Activity Type");
      WhseActivLine.SETRANGE("No.","No.");
      WhseActivLine.SETRANGE("Whse. Document Line No.","Whse. Document Line No.");
      WhseActivLine.SETFILTER("Action Type",'<>%1',"Action Type");
      IF "Action Type" = "Action Type"::Take THEN
        Direction := '>'
      ELSE
        Direction := '<';
      IF WhseActivLine.FIND(Direction) THEN BEGIN
        IF ("Location Code" = WhseActivLine."Location Code") AND
           ("Bin Code" = WhseActivLine."Bin Code") AND
           ("Unit of Measure Code" = WhseActivLine."Unit of Measure Code")
        THEN
          ERROR(Text019,FORMAT("Action Type"),FORMAT(WhseActivLine."Action Type"),Location.Code);

        IF (("Activity Type" = "Activity Type"::"Put-away") AND ("Action Type" = "Action Type"::Place) AND
            Location.IsBWReceive OR ("Activity Type" = "Activity Type"::Pick) AND
            ("Action Type" = "Action Type"::Take) AND Location.IsBWShip) AND Location.IsBinBWReceiveOrShip("Bin Code")
        THEN
          ERROR(Text020,FORMAT("Action Type"),Location.Code);
      END;
    END;

    LOCAL PROCEDURE RegisteredWhseActLineIsEmpty@45() : Boolean;
    VAR
      RegisteredWhseActivityLine@1000 : Record 5773;
    BEGIN
      RegisteredWhseActivityLine.SETRANGE("Activity Type","Activity Type"::Pick);
      RegisteredWhseActivityLine.SETRANGE("Source No.","Source No.");
      RegisteredWhseActivityLine.SETRANGE("Source Line No.","Source Line No.");
      RegisteredWhseActivityLine.SETRANGE("Source Type","Source Type");
      RegisteredWhseActivityLine.SETRANGE("Source Subtype","Source Subtype");
      RegisteredWhseActivityLine.SETRANGE("Lot No.","Lot No.");
      RegisteredWhseActivityLine.SETRANGE("Serial No.","Serial No.");
      EXIT(RegisteredWhseActivityLine.ISEMPTY);
    END;

    [External]
    PROCEDURE ShowItemAvailabilityByPeriod@36();
    VAR
      ItemAvailFormsMgt@1000 : Codeunit 353;
    BEGIN
      ItemAvailFormsMgt.ShowItemAvailFromWhseActivLine(Rec,ItemAvailFormsMgt.ByPeriod);
    END;

    [External]
    PROCEDURE ShowItemAvailabilityByVariant@40();
    VAR
      ItemAvailFormsMgt@1000 : Codeunit 353;
    BEGIN
      ItemAvailFormsMgt.ShowItemAvailFromWhseActivLine(Rec,ItemAvailFormsMgt.ByVariant);
    END;

    [External]
    PROCEDURE ShowItemAvailabilityByLocation@41();
    VAR
      ItemAvailFormsMgt@1000 : Codeunit 353;
    BEGIN
      ItemAvailFormsMgt.ShowItemAvailFromWhseActivLine(Rec,ItemAvailFormsMgt.ByLocation);
    END;

    [External]
    PROCEDURE ShowItemAvailabilityByEvent@38();
    VAR
      ItemAvailFormsMgt@1000 : Codeunit 353;
    BEGIN
      ItemAvailFormsMgt.ShowItemAvailFromWhseActivLine(Rec,ItemAvailFormsMgt.ByEvent);
    END;

    [External]
    PROCEDURE ActivityExists@16(SourceType@1004 : Integer;SourceSubtype@1003 : Option;SourceNo@1002 : Code[20];SourceLineNo@1001 : Integer;SourceSublineNo@1000 : Integer;ActivityType@1005 : Option) : Boolean;
    BEGIN
      IF ActivityType <> 0 THEN
        SETRANGE("Activity Type",ActivityType);
      SetSourceFilter(SourceType,SourceSubtype,SourceNo,SourceLineNo,SourceSublineNo,FALSE);
      EXIT(NOT ISEMPTY);
    END;

    [External]
    PROCEDURE TrackingExists@39() : Boolean;
    BEGIN
      EXIT(("Lot No." <> '') OR ("Serial No." <> ''));
    END;

    [External]
    PROCEDURE SetSource@9(SourceType@1000 : Integer;SourceSubtype@1001 : Option;SourceNo@1002 : Code[20];SourceLineNo@1003 : Integer;SourceSublineNo@1004 : Integer);
    BEGIN
      "Source Type" := SourceType;
      "Source Subtype" := SourceSubtype;
      "Source No." := SourceNo;
      "Source Line No." := SourceLineNo;
      "Source Subline No." := SourceSublineNo;
    END;

    [External]
    PROCEDURE SetSourceFilter@42(SourceType@1004 : Integer;SourceSubType@1003 : Option;SourceNo@1002 : Code[20];SourceLineNo@1001 : Integer;SourceSubLineNo@1000 : Integer;SetKey@1005 : Boolean);
    BEGIN
      IF SetKey THEN
        SETCURRENTKEY("Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
      SETRANGE("Source Type",SourceType);
      IF SourceSubType >= 0 THEN
        SETRANGE("Source Subtype",SourceSubType);
      SETRANGE("Source No.",SourceNo);
      SETRANGE("Source Line No.",SourceLineNo);
      IF SourceSubLineNo >= 0 THEN
        SETRANGE("Source Subline No.",SourceSubLineNo);
    END;

    [External]
    PROCEDURE ClearSourceFilter@46();
    BEGIN
      SETRANGE("Source Type");
      SETRANGE("Source Subtype");
      SETRANGE("Source No.");
      SETRANGE("Source Line No.");
      SETRANGE("Source Subline No.");
    END;

    [External]
    PROCEDURE ClearTracking@47();
    BEGIN
      "Serial No." := '';
      "Lot No." := '';
    END;

    [External]
    PROCEDURE ClearTrackingFilter@44();
    BEGIN
      SETRANGE("Serial No.");
      SETRANGE("Lot No.");
    END;

    [External]
    PROCEDURE CopyTrackingFromSpec@62(TrackingSpecification@1000 : Record 336);
    BEGIN
      "Serial No." := TrackingSpecification."Serial No.";
      "Lot No." := TrackingSpecification."Lot No.";
      "Expiration Date" := TrackingSpecification."Expiration Date";
    END;

    [External]
    PROCEDURE SetTrackingFilter@43(SerialNo@1000 : Code[20];LotNo@1001 : Code[20]);
    BEGIN
      SETRANGE("Serial No.",SerialNo);
      SETRANGE("Lot No.",LotNo);
    END;

    LOCAL PROCEDURE ReNumberAllLines@51(VAR NewWhseActivityLine@1000 : Record 5767;OldLineNo@1004 : Integer;VAR NewLineNo@1001 : Integer);
    VAR
      WarehouseActivityLine@1002 : Record 5767;
      LineNo@1003 : Integer;
    BEGIN
      LineNo := 10000 * NewWhseActivityLine.COUNT;
      NewWhseActivityLine.FIND('+');
      REPEAT
        WarehouseActivityLine := NewWhseActivityLine;
        NewWhseActivityLine.DELETE;
        NewWhseActivityLine := WarehouseActivityLine;
        NewWhseActivityLine."Line No." := LineNo;
        NewWhseActivityLine.INSERT;

        IF WarehouseActivityLine."Line No." = OldLineNo THEN
          NewLineNo := LineNo;
        LineNo -= 10000;
      UNTIL NewWhseActivityLine.NEXT(-1) = 0;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAutofillQtyToHandleLine@48(VAR WarehouseActivityLine@1000 : Record 5767);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateQtyToHandleWhseActivLine@49(VAR WarehouseActivityLine@1000 : Record 5767);
    BEGIN
    END;

    BEGIN
    END.
  }
}

