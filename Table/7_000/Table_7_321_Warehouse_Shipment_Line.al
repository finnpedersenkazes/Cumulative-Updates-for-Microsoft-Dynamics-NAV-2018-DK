OBJECT Table 7321 Warehouse Shipment Line
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    OnDelete=VAR
               ItemTrackingMgt@1001 : Codeunit 6500;
               OrderStatus@1000 : Option;
             BEGIN
               TestReleased;

               IF "Assemble to Order" THEN
                 VALIDATE("Qty. to Ship",0);

               IF "Qty. Shipped" < "Qty. Picked" THEN
                 IF NOT CONFIRM(
                      STRSUBSTNO(
                        Text007,
                        FIELDCAPTION("Qty. Picked"),"Qty. Picked",FIELDCAPTION("Qty. Shipped"),
                        "Qty. Shipped",TABLECAPTION),FALSE)
                 THEN
                   ERROR('');

               ItemTrackingMgt.SetDeleteReservationEntries(TRUE);
               ItemTrackingMgt.DeleteWhseItemTrkgLines(
                 DATABASE::"Warehouse Shipment Line",0,"No.",'',0,"Line No.","Location Code",TRUE);

               OrderStatus :=
                 WhseShptHeader.GetDocumentStatus("Line No.");
               IF OrderStatus <> WhseShptHeader."Document Status" THEN BEGIN
                 WhseShptHeader.VALIDATE("Document Status",OrderStatus);
                 WhseShptHeader.MODIFY;
               END;
             END;

    OnRename=BEGIN
               ERROR(Text008,TABLECAPTION);
             END;

    CaptionML=[DAN=Lagerleverancelinje;
               ENU=Warehouse Shipment Line];
    LookupPageID=Page7341;
    DrillDownPageID=Page7341;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   Editable=No }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.];
                                                   Editable=No }
    { 3   ;   ;Source Type         ;Integer       ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   Editable=No }
    { 4   ;   ;Source Subtype      ;Option        ;CaptionML=[DAN=Kildeundertype;
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
                                                   Editable=No }
    { 9   ;   ;Source Document     ;Option        ;CaptionML=[DAN=Kildedokument;
                                                              ENU=Source Document];
                                                   OptionCaptionML=[DAN=,Salgsordre,,,Salgsreturvareordre,K�bsordre,,,K�bsreturvareordre,,Udg�ende overf�r.,,,,,,,,Serviceordre;
                                                                    ENU=,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,,Outbound Transfer,,,,,,,,Service Order];
                                                   OptionString=,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,,Outbound Transfer,,,,,,,,Service Order;
                                                   Editable=No }
    { 10  ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   Editable=No }
    { 11  ;   ;Shelf No.           ;Code10        ;CaptionML=[DAN=Placeringsnr.;
                                                              ENU=Shelf No.] }
    { 12  ;   ;Bin Code            ;Code20        ;TableRelation=IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                                                                 ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                  Zone Code=FIELD(Zone Code));
                                                   OnValidate=VAR
                                                                Bin@1000 : Record 7354;
                                                                WhseIntegrationMgt@1001 : Codeunit 7317;
                                                              BEGIN
                                                                TestReleased;
                                                                IF xRec."Bin Code" <> "Bin Code" THEN
                                                                  IF "Bin Code" <> '' THEN BEGIN
                                                                    GetLocation("Location Code");
                                                                    WhseIntegrationMgt.CheckBinTypeCode(DATABASE::"Warehouse Shipment Line",
                                                                      FIELDCAPTION("Bin Code"),
                                                                      "Location Code",
                                                                      "Bin Code",0);
                                                                    IF Location."Directed Put-away and Pick" THEN BEGIN
                                                                      Bin.GET("Location Code","Bin Code");
                                                                      "Zone Code" := Bin."Zone Code";
                                                                      CheckBin(0,0);
                                                                    END;
                                                                  END;
                                                              END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 13  ;   ;Zone Code           ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                TestReleased;
                                                                IF xRec."Zone Code" <> "Zone Code" THEN BEGIN
                                                                  IF "Zone Code" <> '' THEN BEGIN
                                                                    GetLocation("Location Code");
                                                                    Location.TESTFIELD("Directed Put-away and Pick");
                                                                  END;
                                                                  "Bin Code" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Zonekode;
                                                              ENU=Zone Code] }
    { 14  ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.];
                                                   Editable=No }
    { 15  ;   ;Quantity            ;Decimal       ;OnValidate=VAR
                                                                OrderStatus@1000 : Integer;
                                                              BEGIN
                                                                IF Quantity <= 0 THEN
                                                                  FIELDERROR(Quantity,Text003);
                                                                TestReleased;
                                                                CheckSourceDocLineQty;

                                                                IF Quantity < "Qty. Picked" THEN
                                                                  FIELDERROR(Quantity,STRSUBSTNO(Text001,"Qty. Picked"));
                                                                IF Quantity < "Qty. Shipped" THEN
                                                                  FIELDERROR(Quantity,STRSUBSTNO(Text001,"Qty. Shipped"));

                                                                "Qty. (Base)" := CalcBaseQty(Quantity);
                                                                InitOutstandingQtys;
                                                                "Completely Picked" := (Quantity = "Qty. Picked") OR ("Qty. (Base)" = "Qty. Picked (Base)");

                                                                GetLocation("Location Code");
                                                                IF Location."Directed Put-away and Pick" THEN
                                                                  CheckBin(xRec.Cubage,xRec.Weight);

                                                                Status := CalcStatusShptLine;
                                                                IF Status <> xRec.Status THEN BEGIN
                                                                  GetWhseShptHeader("No.");
                                                                  OrderStatus := WhseShptHeader.GetDocumentStatus(0);
                                                                  IF OrderStatus <> WhseShptHeader."Document Status" THEN BEGIN
                                                                    WhseShptHeader.VALIDATE("Document Status",OrderStatus);
                                                                    WhseShptHeader.MODIFY;
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 16  ;   ;Qty. (Base)         ;Decimal       ;CaptionML=[DAN=Antal (basis);
                                                              ENU=Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 19  ;   ;Qty. Outstanding    ;Decimal       ;OnValidate=VAR
                                                                WMSMgt@1000 : Codeunit 7302;
                                                              BEGIN
                                                                GetLocation("Location Code");
                                                                "Qty. Outstanding (Base)" := CalcBaseQty("Qty. Outstanding");
                                                                IF Location."Require Pick" THEN BEGIN
                                                                  IF "Assemble to Order" THEN
                                                                    VALIDATE("Qty. to Ship",0)
                                                                  ELSE
                                                                    VALIDATE("Qty. to Ship","Qty. Picked" - (Quantity - "Qty. Outstanding"));
                                                                END ELSE
                                                                  VALIDATE("Qty. to Ship","Qty. Outstanding");

                                                                IF Location."Directed Put-away and Pick" THEN
                                                                  WMSMgt.CalcCubageAndWeight(
                                                                    "Item No.","Unit of Measure Code","Qty. Outstanding",Cubage,Weight);
                                                              END;

                                                   CaptionML=[DAN=Antal udest�ende;
                                                              ENU=Qty. Outstanding];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 20  ;   ;Qty. Outstanding (Base);Decimal    ;CaptionML=[DAN=Antal udest�ende (basis);
                                                              ENU=Qty. Outstanding (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 21  ;   ;Qty. to Ship        ;Decimal       ;OnValidate=VAR
                                                                ATOLink@1001 : Record 904;
                                                                Confirmed@1000 : Boolean;
                                                              BEGIN
                                                                GetLocation("Location Code");
                                                                IF ("Qty. to Ship" > "Qty. Picked" - "Qty. Shipped") AND
                                                                   Location."Require Pick" AND
                                                                   NOT "Assemble to Order"
                                                                THEN
                                                                  FIELDERROR("Qty. to Ship",
                                                                    STRSUBSTNO(Text002,"Qty. Picked" - "Qty. Shipped"));

                                                                IF "Qty. to Ship" > "Qty. Outstanding" THEN
                                                                  ERROR(
                                                                    Text000,
                                                                    "Qty. Outstanding");

                                                                Confirmed := TRUE;
                                                                IF (CurrFieldNo = FIELDNO("Qty. to Ship")) AND
                                                                   ("Shipping Advice" = "Shipping Advice"::Complete) AND
                                                                   ("Qty. to Ship" <> "Qty. Outstanding") AND
                                                                   ("Qty. to Ship" > 0)
                                                                THEN
                                                                  Confirmed :=
                                                                    CONFIRM(
                                                                      Text009 +
                                                                      Text010,
                                                                      FALSE,
                                                                      FIELDCAPTION("Shipping Advice"),
                                                                      "Shipping Advice",
                                                                      FIELDCAPTION("Qty. to Ship"),
                                                                      "Qty. Outstanding");

                                                                IF NOT Confirmed THEN
                                                                  ERROR('');

                                                                IF CurrFieldNo <> FIELDNO("Qty. to Ship (Base)") THEN
                                                                  "Qty. to Ship (Base)" := CalcBaseQty("Qty. to Ship");

                                                                IF "Assemble to Order" THEN
                                                                  ATOLink.UpdateQtyToAsmFromWhseShptLine(Rec);
                                                              END;

                                                   CaptionML=[DAN=Lever (antal);
                                                              ENU=Qty. to Ship];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 22  ;   ;Qty. to Ship (Base) ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Qty. to Ship",CalcQty("Qty. to Ship (Base)"));
                                                              END;

                                                   CaptionML=[DAN=Lever antal (basis);
                                                              ENU=Qty. to Ship (Base)];
                                                   DecimalPlaces=0:5 }
    { 23  ;   ;Qty. Picked         ;Decimal       ;FieldClass=Normal;
                                                   OnValidate=BEGIN
                                                                "Qty. Picked (Base)" := CalcBaseQty("Qty. Picked");
                                                              END;

                                                   CaptionML=[DAN=Plukket antal;
                                                              ENU=Qty. Picked];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 24  ;   ;Qty. Picked (Base)  ;Decimal       ;CaptionML=[DAN=Plukket antal (basis);
                                                              ENU=Qty. Picked (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 25  ;   ;Qty. Shipped        ;Decimal       ;OnValidate=BEGIN
                                                                "Qty. Shipped (Base)" := CalcBaseQty("Qty. Shipped");
                                                              END;

                                                   CaptionML=[DAN=Leveret antal;
                                                              ENU=Qty. Shipped];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 26  ;   ;Qty. Shipped (Base) ;Decimal       ;CaptionML=[DAN=Leveret antal (basis);
                                                              ENU=Qty. Shipped (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 27  ;   ;Pick Qty.           ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Activity Line"."Qty. Outstanding" WHERE (Activity Type=CONST(Pick),
                                                                                                                       Whse. Document Type=CONST(Shipment),
                                                                                                                       Whse. Document No.=FIELD(No.),
                                                                                                                       Whse. Document Line No.=FIELD(Line No.),
                                                                                                                       Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                       Action Type=FILTER(' '|Place),
                                                                                                                       Original Breakbulk=CONST(No),
                                                                                                                       Breakbulk No.=CONST(0),
                                                                                                                       Assemble to Order=CONST(No)));
                                                   CaptionML=[DAN=Plukantal;
                                                              ENU=Pick Qty.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 28  ;   ;Pick Qty. (Base)    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Activity Line"."Qty. Outstanding (Base)" WHERE (Activity Type=CONST(Pick),
                                                                                                                              Whse. Document Type=CONST(Shipment),
                                                                                                                              Whse. Document No.=FIELD(No.),
                                                                                                                              Whse. Document Line No.=FIELD(Line No.),
                                                                                                                              Action Type=FILTER(' '|Place),
                                                                                                                              Original Breakbulk=CONST(No),
                                                                                                                              Breakbulk No.=CONST(0),
                                                                                                                              Assemble to Order=CONST(No)));
                                                   CaptionML=[DAN=Plukantal (basis);
                                                              ENU=Pick Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 29  ;   ;Unit of Measure Code;Code10        ;TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code];
                                                   Editable=No }
    { 30  ;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 31  ;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code];
                                                   Editable=No }
    { 32  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 33  ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2];
                                                   Editable=No }
    { 34  ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=" ,Delvist plukket,Delvist leveret,Fuldt plukket,Fuldt leveret";
                                                                    ENU=" ,Partially Picked,Partially Shipped,Completely Picked,Completely Shipped"];
                                                   OptionString=[ ,Partially Picked,Partially Shipped,Completely Picked,Completely Shipped];
                                                   Editable=No }
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
    { 41  ;   ;Cubage              ;Decimal       ;CaptionML=[DAN=Rumm�l;
                                                              ENU=Cubage];
                                                   DecimalPlaces=0:5 }
    { 42  ;   ;Weight              ;Decimal       ;CaptionML=[DAN=V�gt;
                                                              ENU=Weight];
                                                   DecimalPlaces=0:5 }
    { 44  ;   ;Shipping Advice     ;Option        ;CaptionML=[DAN=Afsendelsesadvis;
                                                              ENU=Shipping Advice];
                                                   OptionCaptionML=[DAN=Delvis,Komplet;
                                                                    ENU=Partial,Complete];
                                                   OptionString=Partial,Complete;
                                                   Editable=No }
    { 45  ;   ;Shipment Date       ;Date          ;CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
    { 46  ;   ;Completely Picked   ;Boolean       ;CaptionML=[DAN=Fuldt plukket;
                                                              ENU=Completely Picked];
                                                   Editable=No }
    { 48  ;   ;Not upd. by Src. Doc. Post.;Boolean;CaptionML=[DAN=Ikke opd. af kilde.dok.bogf.;
                                                              ENU=Not upd. by Src. Doc. Post.];
                                                   Editable=No }
    { 49  ;   ;Posting from Whse. Ref.;Integer    ;CaptionML=[DAN=Bogf�ring fra lagerref.;
                                                              ENU=Posting from Whse. Ref.];
                                                   Editable=No }
    { 900 ;   ;Assemble to Order   ;Boolean       ;AccessByPermission=TableData 90=R;
                                                   CaptionML=[DAN=Montage til ordre;
                                                              ENU=Assemble to Order];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;No.,Line No.                            ;Clustered=Yes }
    {    ;No.,Sorting Sequence No.                ;MaintainSQLIndex=No }
    {    ;No.,Item No.                            ;MaintainSQLIndex=No }
    {    ;No.,Source Document,Source No.          ;MaintainSQLIndex=No }
    {    ;No.,Shelf No.                           ;MaintainSQLIndex=No }
    {    ;No.,Bin Code                            ;MaintainSQLIndex=No }
    {    ;No.,Due Date                            ;MaintainSQLIndex=No }
    {    ;No.,Destination Type,Destination No.    ;MaintainSQLIndex=No }
    {    ;Source Type,Source Subtype,Source No.,Source Line No.,Assemble to Order;
                                                   SumIndexFields=Qty. Outstanding,Qty. Outstanding (Base);
                                                   MaintainSIFTIndex=No }
    {    ;No.,Source Type,Source Subtype,Source No.,Source Line No.;
                                                   MaintainSQLIndex=No }
    {    ;Item No.,Location Code,Variant Code,Due Date;
                                                   SumIndexFields=Qty. Outstanding (Base),Qty. Picked (Base),Qty. Shipped (Base);
                                                   MaintainSIFTIndex=No }
    {    ;Bin Code,Location Code                  ;SumIndexFields=Cubage,Weight;
                                                   MaintainSIFTIndex=No }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke h�ndtere mere end de udest�ende %1 enheder.;ENU=You cannot handle more than the outstanding %1 units.';
      Location@1001 : Record 14;
      Item@1016 : Record 27;
      WhseShptHeader@1002 : Record 7320;
      Text001@1003 : TextConst 'DAN=m� ikke v�re mindre end %1 enheder;ENU=must not be less than %1 units';
      Text002@1004 : TextConst 'DAN=m� ikke v�re mere end %1 enheder;ENU=must not be greater than %1 units';
      Text003@1005 : TextConst 'DAN=skal v�re st�rre end nul;ENU=must be greater than zero';
      Text005@1007 : TextConst 'DAN=Der er ikke plukket nok til at levere alle linjer.;ENU=The picked quantity is not enough to ship all lines.';
      HideValidationDialog@1008 : Boolean;
      Text007@1010 : TextConst '@@@="Qty. Picked = 2 is greater than Qty. Shipped = 0. If you delete the Warehouse Shipment Line, the items will remain in the shipping area until you put them away.\Related Item Tracking information defined during pick will be deleted.\Do you still want to delete the Warehouse Shipment Line?";DAN="%1 = %2 er st�rre end %3 = %4. Hvis du sletter %5, forbliver varerne i afsendelsesomr�det, indtil du l�gger dem p� lager.\Relaterede varesporingsoplysninger, der defineres under pluk, slettes.\Er du sikker p�, at du vil slette %5?";ENU="%1 = %2 is greater than %3 = %4. If you delete the %5, the items will remain in the shipping area until you put them away.\Related Item Tracking information defined during pick will be deleted.\Do you still want to delete the %5?"';
      Text008@1011 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text009@1013 : TextConst 'DAN=%1 er sat til %2. %3 skal v�re %4.\\;ENU=%1 is set to %2. %3 should be %4.\\';
      Text010@1012 : TextConst 'DAN=Er den indtastede v�rdi acceptabel?;ENU=Accept the entered value?';
      Text011@1014 : TextConst 'DAN=Der er intet at h�ndtere.;ENU=Nothing to handle.';
      IgnoreErrors@1006 : Boolean;
      ErrorOccured@1017 : Boolean;

    PROCEDURE InitNewLine@19(DocNo@1000 : Code[20]);
    BEGIN
      RESET;
      "No." := DocNo;
      SETRANGE("No.","No.");
      LOCKTABLE;
      IF FINDLAST THEN;

      INIT;
      SetIgnoreErrors;
      "Line No." := "Line No." + 10000;
    END;

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

    LOCAL PROCEDURE GetLocation@1(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        Location.GetLocationSetup(LocationCode,Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE TestReleased@37();
    BEGIN
      TESTFIELD("No.");
      GetWhseShptHeader("No.");
      WhseShptHeader.TESTFIELD(Status,WhseShptHeader.Status::Open);
    END;

    [External]
    PROCEDURE CheckBin@9(DeductCubage@1000 : Decimal;DeductWeight@1001 : Decimal);
    VAR
      Bin@1005 : Record 7354;
      BinContent@1004 : Record 7302;
    BEGIN
      IF "Bin Code" <> '' THEN BEGIN
        GetLocation("Location Code");
        IF NOT Location."Directed Put-away and Pick" THEN
          EXIT;

        IF BinContent.GET(
             "Location Code","Bin Code",
             "Item No.","Variant Code","Unit of Measure Code")
        THEN BEGIN
          IF NOT BinContent.CheckIncreaseBinContent(
               "Qty. Outstanding","Qty. Outstanding",
               DeductCubage,DeductWeight,Cubage,Weight,FALSE,IgnoreErrors)
          THEN
            ErrorOccured := TRUE;
        END ELSE BEGIN
          Bin.GET("Location Code","Bin Code");
          IF NOT Bin.CheckIncreaseBin(
               "Bin Code","Item No.","Qty. Outstanding",
               DeductCubage,DeductWeight,Cubage,Weight,FALSE,IgnoreErrors)
          THEN
            ErrorOccured := TRUE;
        END;
      END;
      IF ErrorOccured THEN
        "Bin Code" := '';
    END;

    [External]
    PROCEDURE CheckSourceDocLineQty@3();
    VAR
      WhseShptLine@1005 : Record 7321;
      SalesLine@1002 : Record 37;
      PurchaseLine@1003 : Record 39;
      TransferLine@1004 : Record 5741;
      ServiceLine@1007 : Record 5902;
      WhseQtyOutstandingBase@1006 : Decimal;
      QtyOutstandingBase@1000 : Decimal;
      QuantityBase@1001 : Decimal;
    BEGIN
      IF "Qty. (Base)" = 0 THEN
        QuantityBase := CalcBaseQty(Quantity)
      ELSE
        QuantityBase := "Qty. (Base)";

      WhseShptLine.SetSourceFilter("Source Type","Source Subtype","Source No.","Source Line No.",TRUE);
      WhseShptLine.CALCSUMS("Qty. Outstanding (Base)");
      IF WhseShptLine.FIND('-') THEN
        REPEAT
          IF (WhseShptLine."No." <> "No.") OR
             (WhseShptLine."Line No." <> "Line No.")
          THEN
            WhseQtyOutstandingBase := WhseQtyOutstandingBase + WhseShptLine."Qty. Outstanding (Base)";
        UNTIL WhseShptLine.NEXT = 0;

      CASE "Source Type" OF
        DATABASE::"Sales Line":
          BEGIN
            SalesLine.GET("Source Subtype","Source No.","Source Line No.");
            IF ABS(SalesLine."Outstanding Qty. (Base)") < WhseQtyOutstandingBase + QuantityBase THEN
              FIELDERROR(Quantity,STRSUBSTNO(Text002,CalcQty(SalesLine."Outstanding Qty. (Base)" - WhseQtyOutstandingBase)));
            QtyOutstandingBase := ABS(SalesLine."Outstanding Qty. (Base)");
          END;
        DATABASE::"Purchase Line":
          BEGIN
            PurchaseLine.GET("Source Subtype","Source No.","Source Line No.");
            IF ABS(PurchaseLine."Outstanding Qty. (Base)") < WhseQtyOutstandingBase + QuantityBase THEN
              FIELDERROR(Quantity,STRSUBSTNO(Text002,CalcQty(ABS(PurchaseLine."Outstanding Qty. (Base)") - WhseQtyOutstandingBase)));
            QtyOutstandingBase := ABS(PurchaseLine."Outstanding Qty. (Base)");
          END;
        DATABASE::"Transfer Line":
          BEGIN
            TransferLine.GET("Source No.","Source Line No.");
            IF TransferLine."Outstanding Qty. (Base)" < WhseQtyOutstandingBase + QuantityBase THEN
              FIELDERROR(Quantity,STRSUBSTNO(Text002,CalcQty(TransferLine."Outstanding Qty. (Base)" - WhseQtyOutstandingBase)));
            QtyOutstandingBase := TransferLine."Outstanding Qty. (Base)";
          END;
        DATABASE::"Service Line":
          BEGIN
            ServiceLine.GET("Source Subtype","Source No.","Source Line No.");
            IF ABS(ServiceLine."Outstanding Qty. (Base)") < WhseQtyOutstandingBase + QuantityBase THEN
              FIELDERROR(Quantity,STRSUBSTNO(Text002,CalcQty(ServiceLine."Outstanding Qty. (Base)" - WhseQtyOutstandingBase)));
            QtyOutstandingBase := ABS(ServiceLine."Outstanding Qty. (Base)");
          END;
      END;
      IF QuantityBase > QtyOutstandingBase THEN
        FIELDERROR(Quantity,STRSUBSTNO(Text002,FIELDCAPTION("Qty. Outstanding")));
    END;

    [External]
    PROCEDURE CalcStatusShptLine@4() : Integer;
    BEGIN
      IF (Quantity = "Qty. Shipped") OR ("Qty. (Base)" = "Qty. Shipped (Base)") THEN
        EXIT(Status::"Completely Shipped");
      IF "Qty. Shipped" > 0 THEN
        EXIT(Status::"Partially Shipped");
      IF (Quantity = "Qty. Picked") OR ("Qty. (Base)" = "Qty. Picked (Base)") THEN
        EXIT(Status::"Completely Picked");
      IF "Qty. Picked" > 0 THEN
        EXIT(Status::"Partially Picked");
      EXIT(Status::" ");
    END;

    [External]
    PROCEDURE AutofillQtyToHandle@10(VAR WhseShptLine@1000 : Record 7321);
    VAR
      NotEnough@1001 : Boolean;
    BEGIN
      WITH WhseShptLine DO BEGIN
        NotEnough := FALSE;
        SetHideValidationDialog(TRUE);
        IF FIND('-') THEN
          REPEAT
            GetLocation("Location Code");
            IF Location."Require Pick" THEN
              VALIDATE("Qty. to Ship (Base)","Qty. Picked (Base)" - "Qty. Shipped (Base)")
            ELSE
              VALIDATE("Qty. to Ship (Base)","Qty. Outstanding (Base)");
            MODIFY;
            IF NOT NotEnough THEN
              IF ("Qty. to Ship (Base)" < "Qty. Outstanding (Base)") AND
                 ("Shipping Advice" = "Shipping Advice"::Complete)
              THEN
                NotEnough := TRUE;
          UNTIL NEXT = 0;
        SetHideValidationDialog(FALSE);
        IF NotEnough THEN
          MESSAGE(Text005);
      END;
    END;

    [External]
    PROCEDURE DeleteQtyToHandle@11(VAR WhseShptLine@1000 : Record 7321);
    BEGIN
      WITH WhseShptLine DO BEGIN
        IF FIND('-') THEN
          REPEAT
            VALIDATE("Qty. to Ship",0);
            MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE SetHideValidationDialog@8(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    LOCAL PROCEDURE GetWhseShptHeader@6(WhseShptNo@1000 : Code[20]);
    BEGIN
      IF WhseShptHeader."No." <> WhseShptNo THEN
        WhseShptHeader.GET(WhseShptNo);
    END;

    [External]
    PROCEDURE CreatePickDoc@7(VAR WhseShptLine@1000 : Record 7321;WhseShptHeader2@1001 : Record 7320);
    VAR
      CreatePickFromWhseShpt@1002 : Report 7318;
    BEGIN
      WhseShptHeader2.TESTFIELD(Status,WhseShptHeader.Status::Released);
      WhseShptLine.SETFILTER(Quantity,'>0');
      WhseShptLine.SETRANGE("Completely Picked",FALSE);
      IF WhseShptLine.FIND('-') THEN BEGIN
        CreatePickFromWhseShpt.SetWhseShipmentLine(WhseShptLine,WhseShptHeader2);
        CreatePickFromWhseShpt.SetHideValidationDialog(HideValidationDialog);
        CreatePickFromWhseShpt.USEREQUESTPAGE(NOT HideValidationDialog);
        CreatePickFromWhseShpt.RUNMODAL;
        CreatePickFromWhseShpt.GetResultMessage;
        CLEAR(CreatePickFromWhseShpt);
      END ELSE
        IF NOT HideValidationDialog THEN
          MESSAGE(Text011);
    END;

    LOCAL PROCEDURE GetItem@15();
    BEGIN
      IF Item."No." <> "Item No." THEN
        Item.GET("Item No.");
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500();
    VAR
      PurchaseLine@1000 : Record 39;
      SalesLine@1001 : Record 37;
      ServiceLine@1009 : Record 5902;
      TransferLine@1002 : Record 5741;
      ReservePurchLine@1003 : Codeunit 99000834;
      ReserveSalesLine@1004 : Codeunit 99000832;
      ReserveTransferLine@1005 : Codeunit 99000836;
      ServiceLineReserve@1008 : Codeunit 99000842;
      SecondSourceQtyArray@1007 : ARRAY [3] OF Decimal;
      Direction@1006 : 'Outbound,Inbound';
    BEGIN
      TESTFIELD("No.");
      TESTFIELD("Qty. (Base)");

      GetItem;
      Item.TESTFIELD("Item Tracking Code");

      SecondSourceQtyArray[1] := DATABASE::"Warehouse Shipment Line";
      SecondSourceQtyArray[2] := "Qty. to Ship (Base)";
      SecondSourceQtyArray[3] := 0;

      CASE "Source Type" OF
        DATABASE::"Sales Line":
          BEGIN
            IF SalesLine.GET("Source Subtype","Source No.","Source Line No.") THEN
              ReserveSalesLine.CallItemTrackingSecondSource(SalesLine,SecondSourceQtyArray,"Assemble to Order");
          END;
        DATABASE::"Service Line":
          BEGIN
            IF ServiceLine.GET("Source Subtype","Source No.","Source Line No.") THEN
              ServiceLineReserve.CallItemTracking(ServiceLine);
          END;
        DATABASE::"Purchase Line":
          BEGIN
            IF PurchaseLine.GET("Source Subtype","Source No.","Source Line No.") THEN
              ReservePurchLine.CallItemTracking2(PurchaseLine,SecondSourceQtyArray);
          END;
        DATABASE::"Transfer Line":
          BEGIN
            Direction := Direction::Outbound;
            IF TransferLine.GET("Source No.","Source Line No.") THEN
              ReserveTransferLine.CallItemTracking2(TransferLine,Direction,SecondSourceQtyArray);
          END
      END;
    END;

    [External]
    PROCEDURE SetIgnoreErrors@12();
    BEGIN
      IgnoreErrors := TRUE;
    END;

    [External]
    PROCEDURE HasErrorOccured@13() : Boolean;
    BEGIN
      EXIT(ErrorOccured);
    END;

    [External]
    PROCEDURE GetATOAndNonATOLines@16(VAR ATOWhseShptLine@1001 : Record 7321;VAR NonATOWhseShptLine@1002 : Record 7321;VAR ATOLineFound@1004 : Boolean;VAR NonATOLineFound@1003 : Boolean);
    VAR
      WhseShptLine@1000 : Record 7321;
    BEGIN
      WhseShptLine.COPY(Rec);
      WhseShptLine.SetSourceFilter("Source Type","Source Subtype","Source No.","Source Line No.",FALSE);

      NonATOWhseShptLine.COPY(WhseShptLine);
      NonATOWhseShptLine.SETRANGE("Assemble to Order",FALSE);
      NonATOLineFound := NonATOWhseShptLine.FINDFIRST;

      ATOWhseShptLine.COPY(WhseShptLine);
      ATOWhseShptLine.SETRANGE("Assemble to Order",TRUE);
      ATOLineFound := ATOWhseShptLine.FINDFIRST;
    END;

    [External]
    PROCEDURE FullATOPosted@21() : Boolean;
    VAR
      SalesLine@1001 : Record 37;
      ATOWhseShptLine@1002 : Record 7321;
    BEGIN
      IF "Source Document" <> "Source Document"::"Sales Order" THEN
        EXIT(TRUE);
      SalesLine.SETRANGE("Document Type","Source Subtype");
      SalesLine.SETRANGE("Document No.","Source No.");
      SalesLine.SETRANGE("Line No.","Source Line No.");
      IF NOT SalesLine.FINDFIRST THEN
        EXIT(TRUE);
      IF SalesLine."Qty. Shipped (Base)" >= SalesLine."Qty. to Asm. to Order (Base)" THEN
        EXIT(TRUE);
      ATOWhseShptLine.SETRANGE("No.","No.");
      ATOWhseShptLine.SetSourceFilter("Source Type","Source Subtype","Source No.","Source Line No.",FALSE);
      ATOWhseShptLine.SETRANGE("Assemble to Order",TRUE);
      ATOWhseShptLine.CALCSUMS("Qty. to Ship (Base)");
      EXIT((SalesLine."Qty. Shipped (Base)" + ATOWhseShptLine."Qty. to Ship (Base)") >= SalesLine."Qty. to Asm. to Order (Base)");
    END;

    [External]
    PROCEDURE InitOutstandingQtys@2();
    BEGIN
      VALIDATE("Qty. Outstanding",Quantity - "Qty. Shipped");
      "Qty. Outstanding (Base)" := "Qty. (Base)" - "Qty. Shipped (Base)";
    END;

    [External]
    PROCEDURE GetWhseShptLine@17(ShipmentNo@1004 : Code[20];SourceType@1001 : Integer;SourceSubtype@1002 : Option;SourceNo@1003 : Code[20];SourceLineNo@1005 : Integer) : Boolean;
    BEGIN
      SETRANGE("No.",ShipmentNo);
      SetSourceFilter(SourceType,SourceSubtype,SourceNo,SourceLineNo,FALSE);
      IF FINDFIRST THEN
        EXIT(TRUE);
    END;

    [External]
    PROCEDURE CreateWhseItemTrackingLines@22();
    VAR
      WhseWkshLine@1007 : Record 7326;
      ATOSalesLine@1006 : Record 37;
      AsmHeader@1005 : Record 900;
      AsmLineMgt@1004 : Codeunit 905;
      ItemTrackingMgt@1003 : Codeunit 6500;
      WhseSNRequired@1002 : Boolean;
      WhseLNRequired@1001 : Boolean;
    BEGIN
      IF "Assemble to Order" THEN BEGIN
        TESTFIELD("Source Type",DATABASE::"Sales Line");
        ATOSalesLine.GET("Source Subtype","Source No.","Source Line No.");
        ATOSalesLine.AsmToOrderExists(AsmHeader);
        AsmLineMgt.CreateWhseItemTrkgForAsmLines(AsmHeader);
      END ELSE BEGIN
        ItemTrackingMgt.CheckWhseItemTrkgSetup("Item No.",WhseSNRequired,WhseLNRequired,FALSE);
        IF WhseSNRequired OR WhseLNRequired THEN
          ItemTrackingMgt.InitItemTrkgForTempWkshLine(
            WhseWkshLine."Whse. Document Type"::Shipment,"No.",
            "Line No.","Source Type",
            "Source Subtype","Source No.",
            "Source Line No.",0);
      END;
    END;

    PROCEDURE SetItemData@29(ItemNo@1000 : Code[20];ItemDescription@1001 : Text[50];ItemDescription2@1006 : Text[50];LocationCode@1002 : Code[10];VariantCode@1003 : Code[10];UoMCode@1005 : Code[10];QtyPerUoM@1004 : Decimal);
    BEGIN
      "Item No." := ItemNo;
      Description := ItemDescription;
      "Description 2" := ItemDescription2;
      "Location Code" := LocationCode;
      "Variant Code" := VariantCode;
      "Unit of Measure Code" := UoMCode;
      "Qty. per Unit of Measure" := QtyPerUoM;
    END;

    [External]
    PROCEDURE SetSource@18(SourceType@1003 : Integer;SourceSubType@1002 : Option;SourceNo@1001 : Code[20];SourceLineNo@1000 : Integer);
    VAR
      WhseMgt@1004 : Codeunit 5775;
    BEGIN
      "Source Type" := SourceType;
      "Source Subtype" := SourceSubType;
      "Source No." := SourceNo;
      "Source Line No." := SourceLineNo;
      "Source Document" := WhseMgt.GetSourceDocument("Source Type","Source Subtype");
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

    [External]
    PROCEDURE ClearSourceFilter@46();
    BEGIN
      SETRANGE("Source Type");
      SETRANGE("Source Subtype");
      SETRANGE("Source No.");
      SETRANGE("Source Line No.");
    END;

    BEGIN
    END.
  }
}

