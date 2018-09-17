OBJECT Table 7302 Bin Content
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
               IF Default THEN
                 IF WMSManagement.CheckDefaultBin(
                      "Item No.","Variant Code","Location Code","Bin Code")
                 THEN
                   ERROR(Text010,"Location Code","Item No.","Variant Code");

               GetLocation("Location Code");
               IF Location."Directed Put-away and Pick" THEN
                 TESTFIELD("Zone Code")
               ELSE
                 TESTFIELD("Zone Code",'');

               IF "Min. Qty." > "Max. Qty." THEN
                 ERROR(
                   Text005,
                   FIELDCAPTION("Max. Qty."),"Max. Qty.",
                   FIELDCAPTION("Min. Qty."),"Min. Qty.");
             END;

    OnModify=BEGIN
               IF Default THEN
                 IF WMSManagement.CheckDefaultBin(
                      "Item No.","Variant Code","Location Code","Bin Code")
                 THEN
                   ERROR(Text010,"Location Code","Item No.","Variant Code");

               GetLocation("Location Code");
               IF Location."Directed Put-away and Pick" THEN
                 TESTFIELD("Zone Code")
               ELSE
                 TESTFIELD("Zone Code",'');

               IF "Min. Qty." > "Max. Qty." THEN
                 ERROR(
                   Text005,
                   FIELDCAPTION("Max. Qty."),"Max. Qty.",
                   FIELDCAPTION("Min. Qty."),"Min. Qty.");
             END;

    OnDelete=VAR
               BinContent@1000 : Record 7302;
             BEGIN
               BinContent := Rec;
               BinContent.CALCFIELDS(
                 "Quantity (Base)","Pick Quantity (Base)","Negative Adjmt. Qty. (Base)",
                 "Put-away Quantity (Base)","Positive Adjmt. Qty. (Base)");
               IF BinContent."Quantity (Base)" <> 0 THEN
                 ERROR(Text000,TABLECAPTION);

               IF (BinContent."Pick Quantity (Base)" <> 0) OR (BinContent."Negative Adjmt. Qty. (Base)" <> 0) OR
                  (BinContent."Put-away Quantity (Base)" <> 0) OR (BinContent."Positive Adjmt. Qty. (Base)" <> 0)
               THEN
                 ERROR(Text001,TABLECAPTION);
             END;

    CaptionML=[DAN=Placeringsindhold;
               ENU=Bin Content];
    LookupPageID=Page7305;
    DrillDownPageID=Page7305;
  }
  FIELDS
  {
    { 1   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   OnValidate=BEGIN
                                                                IF (CurrFieldNo <> 0) AND ("Location Code" <> xRec."Location Code") THEN BEGIN
                                                                  CheckManualChange(FIELDCAPTION("Location Code"));
                                                                  "Bin Code" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Zone Code           ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                IF (CurrFieldNo <> 0) AND ("Zone Code" <> xRec."Zone Code") THEN
                                                                  CheckManualChange(FIELDCAPTION("Zone Code"));
                                                              END;

                                                   CaptionML=[DAN=Zonekode;
                                                              ENU=Zone Code];
                                                   NotBlank=Yes;
                                                   Editable=No }
    { 3   ;   ;Bin Code            ;Code20        ;TableRelation=IF (Zone Code=FILTER('')) Bin.Code WHERE (Location Code=FIELD(Location Code))
                                                                 ELSE IF (Zone Code=FILTER(<>'')) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                  Zone Code=FIELD(Zone Code));
                                                   OnValidate=BEGIN
                                                                IF (CurrFieldNo <> 0) AND ("Bin Code" <> xRec."Bin Code") THEN BEGIN
                                                                  CheckManualChange(FIELDCAPTION("Bin Code"));
                                                                  GetBin("Location Code","Bin Code");
                                                                  Dedicated := Bin.Dedicated;
                                                                  "Bin Type Code" := Bin."Bin Type Code";
                                                                  "Warehouse Class Code" := Bin."Warehouse Class Code";
                                                                  "Bin Ranking" := Bin."Bin Ranking";
                                                                  "Block Movement" := Bin."Block Movement";
                                                                  "Zone Code" := Bin."Zone Code";
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code];
                                                   NotBlank=Yes }
    { 4   ;   ;Item No.            ;Code20        ;TableRelation=Item WHERE (Type=CONST(Inventory));
                                                   OnValidate=BEGIN
                                                                IF (CurrFieldNo <> 0) AND ("Item No." <> xRec."Item No.") THEN BEGIN
                                                                  CheckManualChange(FIELDCAPTION("Item No."));
                                                                  "Variant Code" := '';
                                                                END;

                                                                IF ("Item No." <> xRec."Item No.") AND ("Item No." <> '') THEN BEGIN
                                                                  GetItem("Item No.");
                                                                  VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.];
                                                   NotBlank=Yes }
    { 10  ;   ;Bin Type Code       ;Code10        ;TableRelation="Bin Type";
                                                   CaptionML=[DAN=Placeringstypekode;
                                                              ENU=Bin Type Code];
                                                   Editable=No }
    { 11  ;   ;Warehouse Class Code;Code10        ;TableRelation="Warehouse Class";
                                                   CaptionML=[DAN=Lagerklassekode;
                                                              ENU=Warehouse Class Code];
                                                   Editable=No }
    { 12  ;   ;Block Movement      ;Option        ;CaptionML=[DAN=Bloker bev�gelse;
                                                              ENU=Block Movement];
                                                   OptionCaptionML=[DAN=" ,Indg�ende,Udg�ende,Alle";
                                                                    ENU=" ,Inbound,Outbound,All"];
                                                   OptionString=[ ,Inbound,Outbound,All] }
    { 15  ;   ;Min. Qty.           ;Decimal       ;CaptionML=[DAN=Min.antal;
                                                              ENU=Min. Qty.];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 16  ;   ;Max. Qty.           ;Decimal       ;OnValidate=BEGIN
                                                                IF "Max. Qty." <> xRec."Max. Qty." THEN
                                                                  CheckBinMaxCubageAndWeight;
                                                              END;

                                                   CaptionML=[DAN=Maks.antal;
                                                              ENU=Max. Qty.];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 21  ;   ;Bin Ranking         ;Integer       ;CaptionML=[DAN=Placeringsniveau;
                                                              ENU=Bin Ranking];
                                                   Editable=No }
    { 26  ;   ;Quantity            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Entry".Quantity WHERE (Location Code=FIELD(Location Code),
                                                                                                     Bin Code=FIELD(Bin Code),
                                                                                                     Item No.=FIELD(Item No.),
                                                                                                     Variant Code=FIELD(Variant Code),
                                                                                                     Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                     Lot No.=FIELD(Lot No. Filter),
                                                                                                     Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 29  ;   ;Pick Qty.           ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Activity Line"."Qty. Outstanding" WHERE (Location Code=FIELD(Location Code),
                                                                                                                       Bin Code=FIELD(Bin Code),
                                                                                                                       Item No.=FIELD(Item No.),
                                                                                                                       Variant Code=FIELD(Variant Code),
                                                                                                                       Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                       Action Type=CONST(Take),
                                                                                                                       Lot No.=FIELD(Lot No. Filter),
                                                                                                                       Serial No.=FIELD(Serial No. Filter),
                                                                                                                       Assemble to Order=CONST(No)));
                                                   CaptionML=[DAN=Plukantal;
                                                              ENU=Pick Qty.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 30  ;   ;Neg. Adjmt. Qty.    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Journal Line"."Qty. (Absolute)" WHERE (Location Code=FIELD(Location Code),
                                                                                                                     From Bin Code=FIELD(Bin Code),
                                                                                                                     Item No.=FIELD(Item No.),
                                                                                                                     Variant Code=FIELD(Variant Code),
                                                                                                                     Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                     Lot No.=FIELD(Lot No. Filter),
                                                                                                                     Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Nedreguleringsantal;
                                                              ENU=Neg. Adjmt. Qty.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 31  ;   ;Put-away Qty.       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Activity Line"."Qty. Outstanding" WHERE (Location Code=FIELD(Location Code),
                                                                                                                       Bin Code=FIELD(Bin Code),
                                                                                                                       Item No.=FIELD(Item No.),
                                                                                                                       Variant Code=FIELD(Variant Code),
                                                                                                                       Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                       Action Type=CONST(Place),
                                                                                                                       Lot No.=FIELD(Lot No. Filter),
                                                                                                                       Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=L�g-p�-lager-antal;
                                                              ENU=Put-away Qty.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 32  ;   ;Pos. Adjmt. Qty.    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Journal Line"."Qty. (Absolute)" WHERE (Location Code=FIELD(Location Code),
                                                                                                                     To Bin Code=FIELD(Bin Code),
                                                                                                                     Item No.=FIELD(Item No.),
                                                                                                                     Variant Code=FIELD(Variant Code),
                                                                                                                     Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                     Lot No.=FIELD(Lot No. Filter),
                                                                                                                     Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Opreguleringsantal;
                                                              ENU=Pos. Adjmt. Qty.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 37  ;   ;Fixed               ;Boolean       ;CaptionML=[DAN=Fast;
                                                              ENU=Fixed] }
    { 40  ;   ;Cross-Dock Bin      ;Boolean       ;CaptionML=[DAN=Dir.afs.placering;
                                                              ENU=Cross-Dock Bin] }
    { 41  ;   ;Default             ;Boolean       ;OnValidate=BEGIN
                                                                IF (xRec.Default <> Default) AND Default THEN
                                                                  IF WMSManagement.CheckDefaultBin(
                                                                       "Item No.","Variant Code","Location Code","Bin Code")
                                                                  THEN
                                                                    ERROR(Text010,"Location Code","Item No.","Variant Code");
                                                              END;

                                                   CaptionML=[DAN=Standard;
                                                              ENU=Default] }
    { 50  ;   ;Quantity (Base)     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Entry"."Qty. (Base)" WHERE (Location Code=FIELD(Location Code),
                                                                                                          Bin Code=FIELD(Bin Code),
                                                                                                          Item No.=FIELD(Item No.),
                                                                                                          Variant Code=FIELD(Variant Code),
                                                                                                          Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                          Lot No.=FIELD(Lot No. Filter),
                                                                                                          Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 51  ;   ;Pick Quantity (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Activity Line"."Qty. Outstanding (Base)" WHERE (Location Code=FIELD(Location Code),
                                                                                                                              Bin Code=FIELD(Bin Code),
                                                                                                                              Item No.=FIELD(Item No.),
                                                                                                                              Variant Code=FIELD(Variant Code),
                                                                                                                              Unit of Measure Code=FIELD(Unit of Measure Filter),
                                                                                                                              Action Type=CONST(Take),
                                                                                                                              Lot No.=FIELD(Lot No. Filter),
                                                                                                                              Serial No.=FIELD(Serial No. Filter),
                                                                                                                              Assemble to Order=CONST(No)));
                                                   CaptionML=[DAN=Plukantal (basis);
                                                              ENU=Pick Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 52  ;   ;Negative Adjmt. Qty. (Base);Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Journal Line"."Qty. (Absolute, Base)" WHERE (Location Code=FIELD(Location Code),
                                                                                                                           From Bin Code=FIELD(Bin Code),
                                                                                                                           Item No.=FIELD(Item No.),
                                                                                                                           Variant Code=FIELD(Variant Code),
                                                                                                                           Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                           Lot No.=FIELD(Lot No. Filter),
                                                                                                                           Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Nedreguleringsantal (basis);
                                                              ENU=Negative Adjmt. Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 53  ;   ;Put-away Quantity (Base);Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Activity Line"."Qty. Outstanding (Base)" WHERE (Location Code=FIELD(Location Code),
                                                                                                                              Bin Code=FIELD(Bin Code),
                                                                                                                              Item No.=FIELD(Item No.),
                                                                                                                              Variant Code=FIELD(Variant Code),
                                                                                                                              Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                              Action Type=CONST(Place),
                                                                                                                              Lot No.=FIELD(Lot No. Filter),
                                                                                                                              Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=L�g-p�-lager-antal (basis);
                                                              ENU=Put-away Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 54  ;   ;Positive Adjmt. Qty. (Base);Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Journal Line"."Qty. (Absolute, Base)" WHERE (Location Code=FIELD(Location Code),
                                                                                                                           To Bin Code=FIELD(Bin Code),
                                                                                                                           Item No.=FIELD(Item No.),
                                                                                                                           Variant Code=FIELD(Variant Code),
                                                                                                                           Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                           Lot No.=FIELD(Lot No. Filter),
                                                                                                                           Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Opreguleringsantal (basis);
                                                              ENU=Positive Adjmt. Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 55  ;   ;ATO Components Pick Qty.;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Activity Line"."Qty. Outstanding" WHERE (Location Code=FIELD(Location Code),
                                                                                                                       Bin Code=FIELD(Bin Code),
                                                                                                                       Item No.=FIELD(Item No.),
                                                                                                                       Variant Code=FIELD(Variant Code),
                                                                                                                       Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                       Action Type=CONST(Take),
                                                                                                                       Lot No.=FIELD(Lot No. Filter),
                                                                                                                       Serial No.=FIELD(Serial No. Filter),
                                                                                                                       Assemble to Order=CONST(Yes),
                                                                                                                       ATO Component=CONST(Yes)));
                                                   CaptionML=[DAN=Plukantal af MTO-komponenter;
                                                              ENU=ATO Components Pick Qty.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 56  ;   ;ATO Components Pick Qty (Base);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Activity Line"."Qty. Outstanding (Base)" WHERE (Location Code=FIELD(Location Code),
                                                                                                                              Bin Code=FIELD(Bin Code),
                                                                                                                              Item No.=FIELD(Item No.),
                                                                                                                              Variant Code=FIELD(Variant Code),
                                                                                                                              Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                              Action Type=CONST(Take),
                                                                                                                              Lot No.=FIELD(Lot No. Filter),
                                                                                                                              Serial No.=FIELD(Serial No. Filter),
                                                                                                                              Assemble to Order=CONST(Yes),
                                                                                                                              ATO Component=CONST(Yes)));
                                                   CaptionML=[DAN=Plukantal (basis) af MTO-komponenter;
                                                              ENU=ATO Components Pick Qty (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=BEGIN
                                                                IF (CurrFieldNo <> 0) AND ("Variant Code" <> xRec."Variant Code") THEN
                                                                  CheckManualChange(FIELDCAPTION("Variant Code"));
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
                                                                IF (CurrFieldNo <> 0) AND ("Unit of Measure Code" <> xRec."Unit of Measure Code") THEN
                                                                  CheckManualChange(FIELDCAPTION("Unit of Measure Code"));

                                                                GetItem("Item No.");
                                                                "Qty. per Unit of Measure" :=
                                                                  UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code];
                                                   NotBlank=Yes }
    { 6500;   ;Lot No. Filter      ;Code20        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Lotnr.filter;
                                                              ENU=Lot No. Filter] }
    { 6501;   ;Serial No. Filter   ;Code20        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Serienr.filter;
                                                              ENU=Serial No. Filter] }
    { 6502;   ;Dedicated           ;Boolean       ;CaptionML=[DAN=Dedikeret;
                                                              ENU=Dedicated];
                                                   Editable=No }
    { 6503;   ;Unit of Measure Filter;Code10      ;FieldClass=FlowFilter;
                                                   TableRelation="Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Enhedsfilter;
                                                              ENU=Unit of Measure Filter] }
  }
  KEYS
  {
    {    ;Location Code,Bin Code,Item No.,Variant Code,Unit of Measure Code;
                                                   Clustered=Yes }
    {    ;Bin Type Code                            }
    {    ;Location Code,Item No.,Variant Code,Cross-Dock Bin,Qty. per Unit of Measure,Bin Ranking }
    {    ;Location Code,Warehouse Class Code,Fixed,Bin Ranking }
    {    ;Location Code,Item No.,Variant Code,Warehouse Class Code,Fixed,Bin Ranking }
    {    ;Item No.                                 }
    {    ;Default,Location Code,Item No.,Variant Code,Bin Code }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Item@1007 : Record 27;
      Location@1006 : Record 14;
      Bin@1000 : Record 7354;
      Text000@1001 : TextConst 'DAN=Du kan ikke slette %1, fordi %1 indeholder varer.;ENU=You cannot delete this %1, because the %1 contains items.';
      Text001@1002 : TextConst 'DAN=Du kan ikke slette %1, fordi der findes lagerdokumentlinjer med varer knyttet til %1.;ENU=You cannot delete this %1, because warehouse document lines have items allocated to this %1.';
      Text002@1003 : TextConst 'DAN=Det samlede rumm�l %1 i %2 for %5 overstiger %3 %4 i %5.\Vil du stadig angive %2?;ENU=The total cubage %1 of the %2 for the %5 exceeds the %3 %4 of the %5.\Do you still want enter this %2?';
      Text003@1005 : TextConst 'DAN=Den samlede v�gt %1 af %2 for %5 overstiger %3 %4 i %5.\Vil du stadig angive %2?;ENU=The total weight %1 of the %2 for the %5 exceeds the %3 %4 of the %5.\Do you still want enter this %2?';
      Text004@1004 : TextConst 'DAN=Annulleret.;ENU=Cancelled.';
      Text005@1008 : TextConst 'DAN=%1 %2 m� ikke v�re mindre end %3 %4.;ENU=The %1 %2 must not be less than the %3 %4.';
      Text006@1009 : TextConst 'DAN=m� ikke v�re mindre end %1;ENU=available must not be less than %1';
      UOMMgt@1010 : Codeunit 5402;
      Text007@1012 : TextConst 'DAN=Du kan ikke �ndre %1, fordi %2 indeholder varer.;ENU=You cannot modify the %1, because the %2 contains items.';
      Text008@1011 : TextConst 'DAN=Du kan ikke �ndre %1, fordi der findes lagerdokumentlinjer med varer knyttet til %2.;ENU=You cannot modify the %1, because warehouse document lines have items allocated to this %2.';
      Text009@1013 : TextConst 'DAN=Du skal f�rst oprette brugeren %1 som lagermedarbejder.;ENU=You must first set up user %1 as a warehouse employee.';
      Text010@1014 : TextConst 'DAN=Der findes allerede et standardplaceringsindhold for lokationskoden %1, varenr. %2 og variantkoden %3.;ENU=There is already a default bin content for location code %1, item no. %2 and variant code %3.';
      WMSManagement@1015 : Codeunit 7302;
      StockProposal@1016 : Boolean;

    [External]
    PROCEDURE SetUpNewLine@8();
    BEGIN
      GetBin("Location Code","Bin Code");
      Dedicated := Bin.Dedicated;
      "Bin Type Code" := Bin."Bin Type Code";
      "Warehouse Class Code" := Bin."Warehouse Class Code";
      "Bin Ranking" := Bin."Bin Ranking";
      "Block Movement" := Bin."Block Movement";
      "Zone Code" := Bin."Zone Code";
      "Cross-Dock Bin" := Bin."Cross-Dock Bin";
    END;

    LOCAL PROCEDURE CheckManualChange@6(CaptionField@1000 : Text[80]);
    BEGIN
      xRec.CALCFIELDS(
        "Quantity (Base)","Positive Adjmt. Qty. (Base)","Put-away Quantity (Base)",
        "Negative Adjmt. Qty. (Base)","Pick Quantity (Base)");
      IF xRec."Quantity (Base)" <> 0 THEN
        ERROR(Text007,CaptionField,TABLECAPTION);
      IF (xRec."Positive Adjmt. Qty. (Base)" <> 0) OR (xRec."Put-away Quantity (Base)" <> 0) OR
         (xRec."Negative Adjmt. Qty. (Base)" <> 0) OR (xRec."Pick Quantity (Base)" <> 0)
      THEN
        ERROR(Text008,CaptionField,TABLECAPTION);
    END;

    [External]
    PROCEDURE CalcQtyAvailToTake@15(ExcludeQtyBase@1000 : Decimal) : Decimal;
    BEGIN
      SetFilterOnUnitOfMeasure;
      CALCFIELDS("Quantity (Base)","Negative Adjmt. Qty. (Base)","Pick Quantity (Base)","ATO Components Pick Qty (Base)");
      EXIT(
        "Quantity (Base)" -
        (("Pick Quantity (Base)" + "ATO Components Pick Qty (Base)") - ExcludeQtyBase + "Negative Adjmt. Qty. (Base)"));
    END;

    [External]
    PROCEDURE CalcQtyAvailToTakeUOM@14() : Decimal;
    BEGIN
      GetItem("Item No.");
      IF Item."No." <> '' THEN
        EXIT(ROUND(CalcQtyAvailToTake(0) / UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code"),0.00001));
    END;

    LOCAL PROCEDURE CalcTotalQtyAvailToTake@26(ExcludeQtyBase@1000 : Decimal) : Decimal;
    VAR
      TotalQtyBase@1001 : Decimal;
      TotalNegativeAdjmtQtyBase@1002 : Decimal;
      TotalATOComponentsPickQtyBase@1003 : Decimal;
    BEGIN
      TotalQtyBase := CalcTotalQtyBase;
      TotalNegativeAdjmtQtyBase := CalcTotalNegativeAdjmtQtyBase;
      TotalATOComponentsPickQtyBase := CalcTotalATOComponentsPickQtyBase;
      SetFilterOnUnitOfMeasure;
      CALCFIELDS("Pick Quantity (Base)");
      EXIT(
        TotalQtyBase -
        ("Pick Quantity (Base)" + TotalATOComponentsPickQtyBase - ExcludeQtyBase + TotalNegativeAdjmtQtyBase));
    END;

    [External]
    PROCEDURE CalcQtyAvailToPick@2(ExcludeQtyBase@1000 : Decimal) : Decimal;
    BEGIN
      IF (NOT Dedicated) AND (NOT ("Block Movement" IN ["Block Movement"::Outbound,"Block Movement"::All])) THEN
        EXIT(CalcQtyAvailToTake(ExcludeQtyBase) - CalcQtyWithBlockedItemTracking);
    END;

    [External]
    PROCEDURE CalcQtyWithBlockedItemTracking@19() : Decimal;
    VAR
      SerialNoInfo@1005 : Record 6504;
      LotNoInfo@1004 : Record 6505;
      XBinContent@1003 : Record 7302;
      QtySNBlocked@1002 : Decimal;
      QtyLNBlocked@1001 : Decimal;
      QtySNAndLNBlocked@1000 : Decimal;
      SNGiven@1006 : Boolean;
      LNGiven@1007 : Boolean;
      NoITGiven@1008 : Boolean;
    BEGIN
      SerialNoInfo.SETRANGE("Item No.","Item No.");
      SerialNoInfo.SETRANGE("Variant Code","Variant Code");
      COPYFILTER("Serial No. Filter",SerialNoInfo."Serial No.");
      SerialNoInfo.SETRANGE(Blocked,TRUE);

      LotNoInfo.SETRANGE("Item No.","Item No.");
      LotNoInfo.SETRANGE("Variant Code","Variant Code");
      COPYFILTER("Lot No. Filter",LotNoInfo."Lot No.");
      LotNoInfo.SETRANGE(Blocked,TRUE);

      IF SerialNoInfo.ISEMPTY AND LotNoInfo.ISEMPTY THEN
        EXIT;

      SNGiven := NOT (GETFILTER("Serial No. Filter") = '');
      LNGiven := NOT (GETFILTER("Lot No. Filter") = '');

      XBinContent.COPY(Rec);
      SETRANGE("Serial No. Filter");
      SETRANGE("Lot No. Filter");

      NoITGiven := NOT SNGiven AND NOT LNGiven;
      IF SNGiven OR NoITGiven THEN
        IF SerialNoInfo.FINDSET THEN
          REPEAT
            SETRANGE("Serial No. Filter",SerialNoInfo."Serial No.");
            CALCFIELDS("Quantity (Base)");
            QtySNBlocked += "Quantity (Base)";
            SETRANGE("Serial No. Filter");
          UNTIL SerialNoInfo.NEXT = 0;

      IF LNGiven OR NoITGiven THEN
        IF LotNoInfo.FINDSET THEN
          REPEAT
            SETRANGE("Lot No. Filter",LotNoInfo."Lot No.");
            CALCFIELDS("Quantity (Base)");
            QtyLNBlocked += "Quantity (Base)";
            SETRANGE("Lot No. Filter");
          UNTIL LotNoInfo.NEXT = 0;

      IF (SNGiven AND LNGiven) OR NoITGiven THEN
        IF SerialNoInfo.FINDSET THEN
          REPEAT
            IF LotNoInfo.FINDSET THEN
              REPEAT
                SETRANGE("Serial No. Filter",SerialNoInfo."Serial No.");
                SETRANGE("Lot No. Filter",LotNoInfo."Lot No.");
                CALCFIELDS("Quantity (Base)");
                QtySNAndLNBlocked += "Quantity (Base)";
              UNTIL LotNoInfo.NEXT = 0;
          UNTIL SerialNoInfo.NEXT = 0;

      COPY(XBinContent);
      EXIT(QtySNBlocked + QtyLNBlocked - QtySNAndLNBlocked);
    END;

    LOCAL PROCEDURE CalcQtyAvailToPutAway@3(ExcludeQtyBase@1000 : Decimal) : Decimal;
    BEGIN
      CALCFIELDS("Quantity (Base)","Positive Adjmt. Qty. (Base)","Put-away Quantity (Base)");
      EXIT(
        ROUND("Max. Qty." * "Qty. per Unit of Measure",0.00001) -
        ("Quantity (Base)" + "Put-away Quantity (Base)" - ExcludeQtyBase + "Positive Adjmt. Qty. (Base)"));
    END;

    [External]
    PROCEDURE NeedToReplenish@16(ExcludeQtyBase@1000 : Decimal) : Boolean;
    BEGIN
      CALCFIELDS("Quantity (Base)","Positive Adjmt. Qty. (Base)","Put-away Quantity (Base)");
      EXIT(
        ROUND("Min. Qty." * "Qty. per Unit of Measure",0.00001) >
        "Quantity (Base)" +
        ABS("Put-away Quantity (Base)" - ExcludeQtyBase + "Positive Adjmt. Qty. (Base)"));
    END;

    [External]
    PROCEDURE CalcQtyToReplenish@24(ExcludeQtyBase@1000 : Decimal) : Decimal;
    BEGIN
      CALCFIELDS("Quantity (Base)","Positive Adjmt. Qty. (Base)","Put-away Quantity (Base)");
      EXIT(
        ROUND("Max. Qty." * "Qty. per Unit of Measure",0.00001) -
        ("Quantity (Base)" + "Put-away Quantity (Base)" - ExcludeQtyBase + "Positive Adjmt. Qty. (Base)"));
    END;

    LOCAL PROCEDURE CheckBinMaxCubageAndWeight@4();
    VAR
      BinContent@1000 : Record 7302;
      WMSMgt@1001 : Codeunit 7302;
      TotalCubage@1002 : Decimal;
      TotalWeight@1003 : Decimal;
      Cubage@1005 : Decimal;
      Weight@1004 : Decimal;
    BEGIN
      GetBin("Location Code","Bin Code");
      IF (Bin."Maximum Cubage" <> 0) OR (Bin."Maximum Weight" <> 0) THEN BEGIN
        BinContent.SETRANGE("Location Code","Location Code");
        BinContent.SETRANGE("Bin Code","Bin Code");
        IF BinContent.FIND('-') THEN
          REPEAT
            IF (BinContent."Location Code" = "Location Code") AND
               (BinContent."Bin Code" = "Bin Code") AND
               (BinContent."Item No." = "Item No.") AND
               (BinContent."Variant Code" = "Variant Code") AND
               (BinContent."Unit of Measure Code" = "Unit of Measure Code")
            THEN
              WMSMgt.CalcCubageAndWeight(
                "Item No.","Unit of Measure Code","Max. Qty.",Cubage,Weight)
            ELSE
              WMSMgt.CalcCubageAndWeight(
                BinContent."Item No.",BinContent."Unit of Measure Code",
                BinContent."Max. Qty.",Cubage,Weight);
            TotalCubage := TotalCubage + Cubage;
            TotalWeight := TotalWeight + Weight;
          UNTIL BinContent.NEXT = 0;

        IF (Bin."Maximum Cubage" > 0) AND (Bin."Maximum Cubage" - TotalCubage < 0) THEN
          IF NOT CONFIRM(
               Text002,
               FALSE,TotalCubage,FIELDCAPTION("Max. Qty."),
               Bin.FIELDCAPTION("Maximum Cubage"),Bin."Maximum Cubage",Bin.TABLECAPTION)
          THEN
            ERROR(Text004);
        IF (Bin."Maximum Weight" > 0) AND (Bin."Maximum Weight" - TotalWeight < 0) THEN
          IF NOT CONFIRM(
               Text003,
               FALSE,TotalWeight,FIELDCAPTION("Max. Qty."),
               Bin.FIELDCAPTION("Maximum Weight"),Bin."Maximum Weight",Bin.TABLECAPTION)
          THEN
            ERROR(Text004);
      END;
    END;

    [External]
    PROCEDURE CheckDecreaseBinContent@21(Qty@1004 : Decimal;VAR QtyBase@1009 : Decimal;DecreaseQtyBase@1001 : Decimal);
    VAR
      WhseActivLine@1003 : Record 5767;
      QtyAvailToPickBase@1000 : Decimal;
      QtyAvailToPick@1002 : Decimal;
    BEGIN
      IF "Block Movement" IN ["Block Movement"::Outbound,"Block Movement"::All] THEN
        FIELDERROR("Block Movement");

      GetLocation("Location Code");
      IF "Bin Code" = Location."Adjustment Bin Code" THEN
        EXIT;

      WhseActivLine.SETCURRENTKEY(
        "Item No.","Bin Code","Location Code","Action Type",
        "Variant Code","Unit of Measure Code","Breakbulk No.",
        "Activity Type","Lot No.","Serial No.","Original Breakbulk");
      WhseActivLine.SETRANGE("Item No.","Item No.");
      WhseActivLine.SETRANGE("Bin Code","Bin Code");
      WhseActivLine.SETRANGE("Location Code","Location Code");
      WhseActivLine.SETRANGE("Unit of Measure Code","Unit of Measure Code");
      WhseActivLine.SETRANGE("Variant Code","Variant Code");

      IF Location."Allow Breakbulk" THEN BEGIN
        WhseActivLine.SETRANGE("Action Type",WhseActivLine."Action Type"::Take);
        WhseActivLine.SETRANGE("Original Breakbulk",TRUE);
        WhseActivLine.SETRANGE("Breakbulk No.",0);
        WhseActivLine.CALCSUMS("Qty. (Base)");
        DecreaseQtyBase := DecreaseQtyBase + WhseActivLine."Qty. (Base)";
      END;

      QtyAvailToPickBase := CalcTotalQtyAvailToTake(DecreaseQtyBase);
      IF QtyAvailToPickBase < QtyBase THEN BEGIN
        GetItem("Item No.");
        QtyAvailToPick := ROUND(QtyAvailToPickBase / UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code"),0.00001);
        IF QtyAvailToPick = Qty THEN
          QtyBase := QtyAvailToPickBase // rounding issue- qty is same, but not qty (base)
        ELSE
          FIELDERROR("Quantity (Base)",STRSUBSTNO(Text006,ABS(QtyBase)));
      END;
    END;

    [External]
    PROCEDURE CheckIncreaseBinContent@22(QtyBase@1005 : Decimal;DeductQtyBase@1011 : Decimal;DeductCubage@1009 : Decimal;DeductWeight@1008 : Decimal;PutawayCubage@1007 : Decimal;PutawayWeight@1006 : Decimal;CalledbyPosting@1010 : Boolean;IgnoreError@1012 : Boolean) : Boolean;
    VAR
      WhseActivLine@1001 : Record 5767;
      WMSMgt@1002 : Codeunit 7302;
      QtyAvailToPutAwayBase@1000 : Decimal;
      AvailableWeight@1003 : Decimal;
      AvailableCubage@1004 : Decimal;
    BEGIN
      IF "Block Movement" IN ["Block Movement"::Inbound,"Block Movement"::All] THEN
        IF NOT StockProposal THEN
          FIELDERROR("Block Movement");

      GetLocation("Location Code");
      IF "Bin Code" = Location."Adjustment Bin Code" THEN
        EXIT;

      IF NOT CheckWhseClass(IgnoreError) THEN
        EXIT(FALSE);

      IF QtyBase <> 0 THEN
        IF Location."Bin Capacity Policy" IN
           [Location."Bin Capacity Policy"::"Allow More Than Max. Capacity",
            Location."Bin Capacity Policy"::"Prohibit More Than Max. Cap."]
        THEN
          IF "Max. Qty." <> 0 THEN BEGIN
            QtyAvailToPutAwayBase := CalcQtyAvailToPutAway(DeductQtyBase);
            WMSMgt.CheckPutAwayAvailability(
              "Bin Code",WhseActivLine.FIELDCAPTION("Qty. (Base)"),TABLECAPTION,QtyBase,QtyAvailToPutAwayBase,
              (Location."Bin Capacity Policy" =
               Location."Bin Capacity Policy"::"Prohibit More Than Max. Cap.") AND CalledbyPosting);
          END ELSE BEGIN
            GetBin("Location Code","Bin Code");
            IF (Bin."Maximum Cubage" <> 0) OR (Bin."Maximum Weight" <> 0) THEN BEGIN
              Bin.CalcCubageAndWeight(AvailableCubage,AvailableWeight,CalledbyPosting);
              IF NOT CalledbyPosting THEN BEGIN
                AvailableCubage := AvailableCubage + DeductCubage;
                AvailableWeight := AvailableWeight + DeductWeight;
              END;

              IF (Bin."Maximum Cubage" <> 0) AND (PutawayCubage > AvailableCubage) THEN
                WMSMgt.CheckPutAwayAvailability(
                  "Bin Code",WhseActivLine.FIELDCAPTION(Cubage),Bin.TABLECAPTION,PutawayCubage,AvailableCubage,
                  (Location."Bin Capacity Policy" =
                   Location."Bin Capacity Policy"::"Prohibit More Than Max. Cap.") AND CalledbyPosting);

              IF (Bin."Maximum Weight" <> 0) AND (PutawayWeight > AvailableWeight) THEN
                WMSMgt.CheckPutAwayAvailability(
                  "Bin Code",WhseActivLine.FIELDCAPTION(Weight),Bin.TABLECAPTION,PutawayWeight,AvailableWeight,
                  (Location."Bin Capacity Policy" =
                   Location."Bin Capacity Policy"::"Prohibit More Than Max. Cap.") AND CalledbyPosting);
            END;
          END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CheckWhseClass@5(IgnoreError@1000 : Boolean) : Boolean;
    BEGIN
      GetItem("Item No.");
      IF IgnoreError THEN
        EXIT("Warehouse Class Code" = Item."Warehouse Class Code");
      TESTFIELD("Warehouse Class Code",Item."Warehouse Class Code");
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE ShowBinContents@7(LocationCode@1002 : Code[10];ItemNo@1003 : Code[20];VariantCode@1004 : Code[10];BinCode@1005 : Code[20]);
    VAR
      BinContent@1000 : Record 7302;
      BinContentLookup@1001 : Page 7305;
    BEGIN
      IF BinCode <> '' THEN
        BinContent.SETRANGE("Bin Code",BinCode)
      ELSE
        BinContent.SETCURRENTKEY("Location Code","Item No.","Variant Code");
      BinContent.SETRANGE("Item No.",ItemNo);
      BinContent.SETRANGE("Variant Code",VariantCode);
      BinContentLookup.SETTABLEVIEW(BinContent);
      BinContentLookup.Initialize(LocationCode);
      BinContentLookup.RUNMODAL;
      CLEAR(BinContentLookup);
    END;

    LOCAL PROCEDURE GetLocation@10(LocationCode@1000 : Code[10]);
    BEGIN
      IF Location.Code <> LocationCode THEN
        Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE GetBin@1(LocationCode@1000 : Code[10];BinCode@1002 : Code[20]);
    BEGIN
      IF (LocationCode = '') OR (BinCode = '') THEN
        Bin.INIT
      ELSE
        IF (Bin."Location Code" <> LocationCode) OR
           (Bin.Code <> BinCode)
        THEN
          Bin.GET(LocationCode,BinCode);
    END;

    LOCAL PROCEDURE GetItem@18(ItemNo@1000 : Code[20]);
    BEGIN
      IF Item."No." = ItemNo THEN
        EXIT;

      IF ItemNo = '' THEN
        Item.INIT
      ELSE
        Item.GET(ItemNo);
    END;

    [External]
    PROCEDURE GetItemDescr@20(ItemNo@1000 : Code[20];VariantCode@1005 : Code[10];VAR ItemDescription@1001 : Text[50]);
    VAR
      Item@1002 : Record 27;
      ItemVariant@1004 : Record 5401;
      OldItemNo@1003 : Code[20];
    BEGIN
      ItemDescription := '';
      IF ItemNo <> OldItemNo THEN BEGIN
        ItemDescription := '';
        IF ItemNo <> '' THEN BEGIN
          IF Item.GET(ItemNo) THEN
            ItemDescription := Item.Description;
          IF VariantCode <> '' THEN
            IF ItemVariant.GET(ItemNo,VariantCode) THEN
              ItemDescription := ItemVariant.Description;
        END;
        OldItemNo := ItemNo;
      END;
    END;

    [External]
    PROCEDURE GetWhseLocation@9(VAR CurrentLocationCode@1002 : Code[10];VAR CurrentZoneCode@1004 : Code[10]);
    VAR
      Location@1001 : Record 14;
      WhseEmployee@1003 : Record 7301;
      WMSMgt@1000 : Codeunit 7302;
    BEGIN
      IF USERID <> '' THEN BEGIN
        WhseEmployee.SETRANGE("User ID",USERID);
        IF WhseEmployee.ISEMPTY THEN
          ERROR(Text009,USERID);
        IF CurrentLocationCode <> '' THEN BEGIN
          IF NOT Location.GET(CurrentLocationCode) THEN BEGIN
            CurrentLocationCode := '';
            CurrentZoneCode := '';
          END ELSE
            IF NOT Location."Bin Mandatory" THEN BEGIN
              CurrentLocationCode := '';
              CurrentZoneCode := '';
            END ELSE BEGIN
              WhseEmployee.SETRANGE("Location Code",CurrentLocationCode);
              IF WhseEmployee.ISEMPTY THEN BEGIN
                CurrentLocationCode := '';
                CurrentZoneCode := '';
              END;
            END
            ;
          IF CurrentLocationCode = '' THEN BEGIN
            CurrentLocationCode := WMSMgt.GetDefaultLocation;
            IF CurrentLocationCode <> '' THEN BEGIN
              Location.GET(CurrentLocationCode);
              IF NOT Location."Bin Mandatory" THEN
                CurrentLocationCode := '';
            END;
          END;
        END;
      END;
      FILTERGROUP := 2;
      IF CurrentLocationCode <> '' THEN
        SETRANGE("Location Code",CurrentLocationCode)
      ELSE
        SETRANGE("Location Code");
      IF CurrentZoneCode <> '' THEN
        SETRANGE("Zone Code",CurrentZoneCode)
      ELSE
        SETRANGE("Zone Code");
      FILTERGROUP := 0;
    END;

    [External]
    PROCEDURE CalcQtyonAdjmtBin@11() : Decimal;
    VAR
      WhseEntry@1000 : Record 7312;
    BEGIN
      GetLocation("Location Code");
      WhseEntry.SETCURRENTKEY(
        "Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code");
      WhseEntry.SETRANGE("Item No.","Item No.");
      WhseEntry.SETRANGE("Bin Code",Location."Adjustment Bin Code");
      WhseEntry.SETRANGE("Location Code","Location Code");
      WhseEntry.SETRANGE("Variant Code","Variant Code");
      WhseEntry.SETRANGE("Unit of Measure Code","Unit of Measure Code");
      WhseEntry.CALCSUMS("Qty. (Base)");
      EXIT(WhseEntry."Qty. (Base)");
    END;

    [External]
    PROCEDURE CalcQtyBase@49() : Decimal;
    VAR
      WhseActivLine@1004 : Record 5767;
      WhseJnlLine@1005 : Record 7311;
    BEGIN
      WhseActivLine.SETCURRENTKEY(
        "Item No.","Bin Code","Location Code",
        "Action Type","Variant Code","Unit of Measure Code",
        "Breakbulk No.","Activity Type","Lot No.","Serial No.");
      WhseActivLine.SETRANGE("Item No.","Item No." );
      WhseActivLine.SETRANGE("Bin Code","Bin Code");
      WhseActivLine.SETRANGE("Location Code","Location Code");
      WhseActivLine.SETRANGE("Variant Code","Variant Code");
      WhseActivLine.SETRANGE("Unit of Measure Code","Unit of Measure Code");
      COPYFILTER("Lot No. Filter",WhseActivLine."Lot No.");
      COPYFILTER("Serial No. Filter",WhseActivLine."Serial No.");
      WhseActivLine.CALCSUMS("Qty. Outstanding (Base)");

      WhseJnlLine.SETCURRENTKEY(
        "Item No.","From Bin Code","Location Code","Entry Type","Variant Code",
        "Unit of Measure Code","Lot No.","Serial No.");
      WhseJnlLine.SETRANGE("Item No.","Item No." );
      WhseJnlLine.SETRANGE("From Bin Code","Bin Code");
      WhseJnlLine.SETRANGE("Location Code","Location Code");
      WhseJnlLine.SETRANGE("Variant Code","Variant Code");
      WhseJnlLine.SETRANGE("Unit of Measure Code","Unit of Measure Code");
      COPYFILTER("Lot No. Filter",WhseJnlLine."Lot No.");
      COPYFILTER("Serial No. Filter",WhseJnlLine."Serial No.");
      WhseJnlLine.CALCSUMS("Qty. (Absolute, Base)");

      CALCFIELDS("Quantity (Base)");
      EXIT(
        "Quantity (Base)" +
        WhseActivLine."Qty. Outstanding (Base)" +
        WhseJnlLine."Qty. (Absolute, Base)");
    END;

    [External]
    PROCEDURE CalcQtyUOM@13() : Decimal;
    BEGIN
      GetItem("Item No.");
      CALCFIELDS("Quantity (Base)");
      IF Item."No." <> '' THEN
        EXIT(ROUND("Quantity (Base)" / UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code"),0.00001));
    END;

    [External]
    PROCEDURE GetCaption@12() : Text[250];
    VAR
      ObjTransl@1000 : Record 377;
      ReservEntry@1008 : Record 337;
      FormCaption@1005 : Text[250];
      Filter@1010 : Text;
    BEGIN
      FormCaption :=
        STRSUBSTNO(
          '%1 %2',
          ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DATABASE::Location),
          "Location Code");

      CASE TRUE OF
        GetFieldFilter(GETFILTER("Serial No. Filter"),Filter):
          GetPageCaption(FormCaption,FIELDNO("Serial No. Filter"),Filter,-1,ReservEntry.FIELDCAPTION("Serial No."));
        GetFieldFilter(GETFILTER("Lot No. Filter"),Filter):
          GetPageCaption(FormCaption,FIELDNO("Lot No. Filter"),Filter,-1,ReservEntry.FIELDCAPTION("Lot No."));
        GetFieldFilter(GETFILTER("Bin Code"),Filter):
          GetPageCaption(FormCaption,FIELDNO("Bin Code"),Filter,DATABASE::"Registered Invt. Movement Line",'');
        GetFieldFilter(GETFILTER("Variant Code"),Filter):
          GetPageCaption(FormCaption,FIELDNO("Variant Code"),Filter,DATABASE::"Item Variant",'');
        GetFieldFilter(GETFILTER("Item No."),Filter):
          GetPageCaption(FormCaption,FIELDNO("Item No."),Filter,DATABASE::Item,'');
      END;

      EXIT(FormCaption);
    END;

    [External]
    PROCEDURE SetProposalMode@17(NewValue@1000 : Boolean);
    BEGIN
      StockProposal := NewValue;
    END;

    LOCAL PROCEDURE GetFieldFilter@29(FieldFilter@1000 : Text;VAR Filter@1001 : Text) : Boolean;
    BEGIN
      Filter := FieldFilter;
      EXIT(STRLEN(Filter) > 0);
    END;

    LOCAL PROCEDURE GetPageCaption@33(VAR PageCaption@1000 : Text;FieldNo@1001 : Integer;Filter@1008 : Text;TableId@1004 : Integer;CustomDetails@1002 : Text);
    VAR
      ObjectTranslation@1005 : Record 377;
      FieldRef@1006 : FieldRef;
      RecRef@1007 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      FieldRef := RecRef.FIELD(FieldNo);
      FieldRef.SETFILTER(Filter);

      IF RecRef.FINDFIRST THEN BEGIN
        IF TableId > 0 THEN
          CustomDetails := ObjectTranslation.TranslateObject(ObjectTranslation."Object Type"::Table,TableId);

        PageCaption := STRSUBSTNO('%1 %2 %3',PageCaption,CustomDetails,FieldRef.VALUE);
      END;
    END;

    [External]
    PROCEDURE SetFilterOnUnitOfMeasure@23();
    BEGIN
      GetLocation("Location Code");
      IF Location."Directed Put-away and Pick" THEN
        SETRANGE("Unit of Measure Filter","Unit of Measure Code")
      ELSE
        SETRANGE("Unit of Measure Filter");
    END;

    LOCAL PROCEDURE CalcTotalQtyBase@25() : Decimal;
    VAR
      WarehouseEntry@1001 : Record 7312;
    BEGIN
      WarehouseEntry.SETRANGE("Location Code","Location Code");
      WarehouseEntry.SETRANGE("Bin Code","Bin Code");
      WarehouseEntry.SETRANGE("Item No.","Item No.");
      WarehouseEntry.SETRANGE("Variant Code","Variant Code");
      WarehouseEntry.SETFILTER("Lot No.",GETFILTER("Lot No. Filter"));
      WarehouseEntry.SETFILTER("Serial No.",GETFILTER("Serial No. Filter"));
      WarehouseEntry.CALCSUMS("Qty. (Base)");
      EXIT(WarehouseEntry."Qty. (Base)");
    END;

    LOCAL PROCEDURE CalcTotalNegativeAdjmtQtyBase@34() TotalNegativeAdjmtQtyBase : Decimal;
    VAR
      WarehouseJournalLine@1001 : Record 7311;
      WhseItemTrackingLine@1000 : Record 6550;
    BEGIN
      WarehouseJournalLine.SETRANGE("Location Code","Location Code");
      WarehouseJournalLine.SETRANGE("From Bin Code","Bin Code");
      WarehouseJournalLine.SETRANGE("Item No.","Item No.");
      WarehouseJournalLine.SETRANGE("Variant Code","Variant Code");
      IF (GETFILTER("Lot No. Filter") = '') AND (GETFILTER("Serial No. Filter") = '') THEN BEGIN
        WarehouseJournalLine.CALCSUMS("Qty. (Absolute, Base)");
        TotalNegativeAdjmtQtyBase := WarehouseJournalLine."Qty. (Absolute, Base)";
      END ELSE BEGIN
        WhseItemTrackingLine.SETRANGE("Location Code","Location Code");
        WhseItemTrackingLine.SETRANGE("Item No.","Item No.");
        WhseItemTrackingLine.SETRANGE("Variant Code","Variant Code");
        WhseItemTrackingLine.SETFILTER("Lot No.",GETFILTER("Lot No. Filter"));
        WhseItemTrackingLine.SETFILTER("Serial No.",GETFILTER("Serial No. Filter"));
        WhseItemTrackingLine.SETRANGE("Source Type",DATABASE::"Warehouse Journal Line");
        IF WarehouseJournalLine.FINDSET THEN
          REPEAT
            WhseItemTrackingLine.SETRANGE("Source ID",WarehouseJournalLine."Journal Batch Name");
            WhseItemTrackingLine.SETRANGE("Source Batch Name",WarehouseJournalLine."Journal Template Name");
            WhseItemTrackingLine.SETRANGE("Source Ref. No.",WarehouseJournalLine."Line No.");
            WhseItemTrackingLine.CALCSUMS("Quantity (Base)");
            TotalNegativeAdjmtQtyBase += WhseItemTrackingLine."Quantity (Base)";
          UNTIL WarehouseJournalLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CalcTotalATOComponentsPickQtyBase@27() : Decimal;
    VAR
      WarehouseActivityLine@1001 : Record 5767;
    BEGIN
      GetLocation("Location Code");
      WarehouseActivityLine.SETRANGE("Location Code","Location Code");
      WarehouseActivityLine.SETRANGE("Bin Code","Bin Code");
      WarehouseActivityLine.SETRANGE("Item No.","Item No.");
      WarehouseActivityLine.SETRANGE("Variant Code","Variant Code");
      IF Location."Allow Breakbulk" THEN
        WarehouseActivityLine.SETRANGE("Unit of Measure Code","Unit of Measure Code");
      WarehouseActivityLine.SETRANGE("Activity Type",WarehouseActivityLine."Activity Type"::Pick);
      WarehouseActivityLine.SETRANGE("Action Type",WarehouseActivityLine."Action Type"::Take);
      WarehouseActivityLine.SETRANGE("Assemble to Order",TRUE);
      WarehouseActivityLine.SETRANGE("ATO Component",TRUE);
      WarehouseActivityLine.SETFILTER("Lot No.",GETFILTER("Lot No. Filter"));
      WarehouseActivityLine.SETFILTER("Serial No.",GETFILTER("Serial No. Filter"));
      WarehouseActivityLine.CALCSUMS("Qty. (Base)");
      EXIT(WarehouseActivityLine."Qty. (Base)");
    END;

    BEGIN
    END.
  }
}

