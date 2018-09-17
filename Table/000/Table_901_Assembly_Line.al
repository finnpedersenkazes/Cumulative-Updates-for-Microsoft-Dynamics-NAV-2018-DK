OBJECT Table 901 Assembly Line
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               TestStatusOpen;
               VerifyReservationQuantity(Rec,xRec);
             END;

    OnModify=BEGIN
               WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);
               VerifyReservationChange(Rec,xRec);
             END;

    OnDelete=VAR
               WhseAssemblyRelease@1000 : Codeunit 904;
               AssemblyLineReserve@1001 : Codeunit 926;
             BEGIN
               TestStatusOpen;
               WhseValidateSourceLine.AssemblyLineDelete(Rec);
               WhseAssemblyRelease.DeleteLine(Rec);
               AssemblyLineReserve.DeleteLine(Rec);
               CALCFIELDS("Reserved Qty. (Base)");
               TESTFIELD("Reserved Qty. (Base)",0);
             END;

    OnRename=BEGIN
               ERROR(Text002,TABLECAPTION);
             END;

    CaptionML=[DAN=Montagelinje;
               ENU=Assembly Line];
    LookupPageID=Page903;
    DrillDownPageID=Page903;
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                              END;

                                                   CaptionML=[DAN=Dokumenttype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,,,Rammeordre;
                                                                    ENU=Quote,Order,,,Blanket Order];
                                                   OptionString=Quote,Order,,,Blanket Order }
    { 2   ;   ;Document No.        ;Code20        ;TableRelation="Assembly Header".No. WHERE (Document Type=FIELD(Document Type));
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                              END;

                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 3   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.];
                                                   Editable=No }
    { 10  ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                TESTFIELD("Consumed Quantity",0);
                                                                VerifyReservationChange(Rec,xRec);
                                                                TestStatusOpen;

                                                                "No." := '';
                                                                "Variant Code" := '';
                                                                "Location Code" := '';
                                                                "Bin Code" := '';
                                                                InitResourceUsageType;
                                                                "Inventory Posting Group" := '';
                                                                "Gen. Prod. Posting Group" := '';
                                                                CLEAR("Lead-Time Offset");
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Vare,Ressource";
                                                                    ENU=" ,Item,Resource"];
                                                   OptionString=[ ,Item,Resource] }
    { 11  ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(Item)) Item WHERE (Type=CONST(Inventory))
                                                                 ELSE IF (Type=CONST(Resource)) Resource;
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Consumed Quantity",0);
                                                                CALCFIELDS("Reserved Quantity");
                                                                WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);
                                                                IF "No." <> '' THEN
                                                                  CheckItemAvailable(FIELDNO("No."));
                                                                VerifyReservationChange(Rec,xRec);
                                                                TestStatusOpen;

                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  "Variant Code" := '';
                                                                  InitResourceUsageType;
                                                                END;

                                                                IF "No." = '' THEN
                                                                  INIT
                                                                ELSE BEGIN
                                                                  GetHeader;
                                                                  "Due Date" := AssemblyHeader."Starting Date";
                                                                  CASE Type OF
                                                                    Type::Item:
                                                                      BEGIN
                                                                        "Location Code" := AssemblyHeader."Location Code";
                                                                        GetItemResource;
                                                                        Item.TESTFIELD("Inventory Posting Group");
                                                                        "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                                                                        "Inventory Posting Group" := Item."Inventory Posting Group";
                                                                        GetDefaultBin;
                                                                        Description := Item.Description;
                                                                        "Description 2" := Item."Description 2";
                                                                        "Unit Cost" := GetUnitCost;
                                                                        VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
                                                                        CreateDim(DATABASE::Item,"No.",AssemblyHeader."Dimension Set ID");
                                                                        Reserve := Item.Reserve;
                                                                        VALIDATE(Quantity);
                                                                        VALIDATE("Quantity to Consume",
                                                                          MinValue(MaxQtyToConsume,CalcQuantity("Quantity per",AssemblyHeader."Quantity to Assemble")));
                                                                      END;
                                                                    Type::Resource:
                                                                      BEGIN
                                                                        GetItemResource;
                                                                        Resource.TESTFIELD("Gen. Prod. Posting Group");
                                                                        "Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
                                                                        "Inventory Posting Group" := '';
                                                                        Description := Resource.Name;
                                                                        "Description 2" := Resource."Name 2";
                                                                        "Unit Cost" := GetUnitCost;
                                                                        VALIDATE("Unit of Measure Code",Resource."Base Unit of Measure");
                                                                        CreateDim(DATABASE::Resource,"No.",AssemblyHeader."Dimension Set ID");
                                                                        VALIDATE(Quantity);
                                                                        VALIDATE("Quantity to Consume",
                                                                          MinValue(MaxQtyToConsume,CalcQuantity("Quantity per",AssemblyHeader."Quantity to Assemble")));
                                                                      END;
                                                                  END
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 12  ;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.),
                                                                                                                  Code=FIELD(Variant Code));
                                                   OnValidate=VAR
                                                                ItemVariant@1000 : Record 5401;
                                                              BEGIN
                                                                TESTFIELD(Type,Type::Item);
                                                                TESTFIELD("Consumed Quantity",0);
                                                                CALCFIELDS("Reserved Quantity");
                                                                TESTFIELD("Reserved Quantity",0);
                                                                WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);
                                                                CheckItemAvailable(FIELDNO("Variant Code"));
                                                                VerifyReservationChange(Rec,xRec);
                                                                TestStatusOpen;

                                                                IF "Variant Code" = '' THEN BEGIN
                                                                  GetItemResource;
                                                                  Description := Item.Description;
                                                                  "Description 2" := Item."Description 2"
                                                                END ELSE BEGIN
                                                                  ItemVariant.GET("No.","Variant Code");
                                                                  Description := ItemVariant.Description;
                                                                  "Description 2" := ItemVariant."Description 2";
                                                                END;

                                                                GetDefaultBin;
                                                                "Unit Cost" := GetUnitCost;
                                                                "Cost Amount" := CalcCostAmount(Quantity,"Unit Cost");
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 13  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 14  ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 18  ;   ;Lead-Time Offset    ;DateFormula   ;OnValidate=BEGIN
                                                                GetHeader;
                                                                ValidateLeadTimeOffset(AssemblyHeader,"Lead-Time Offset",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Genneml�bstid;
                                                              ENU=Lead-Time Offset] }
    { 19  ;   ;Resource Usage Type ;Option        ;OnValidate=BEGIN
                                                                IF "Resource Usage Type" = xRec."Resource Usage Type" THEN
                                                                  EXIT;

                                                                IF Type = Type::Resource THEN
                                                                  TESTFIELD("Resource Usage Type")
                                                                ELSE
                                                                  TESTFIELD("Resource Usage Type","Resource Usage Type"::" ");

                                                                GetHeader;
                                                                VALIDATE(Quantity,CalcQuantity("Quantity per",AssemblyHeader.Quantity));
                                                              END;

                                                   CaptionML=[DAN=Ressourceanvendelsestype;
                                                              ENU=Resource Usage Type];
                                                   OptionCaptionML=[DAN=" ,Direkte,Fast";
                                                                    ENU=" ,Direct,Fixed"];
                                                   OptionString=[ ,Direct,Fixed] }
    { 20  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Type,Type::Item);
                                                                WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);
                                                                CheckItemAvailable(FIELDNO("Location Code"));
                                                                VerifyReservationChange(Rec,xRec);
                                                                TestStatusOpen;

                                                                GetDefaultBin;

                                                                "Unit Cost" := GetUnitCost;
                                                                "Cost Amount" := CalcCostAmount(Quantity,"Unit Cost");
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 21  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 22  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 23  ;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=VAR
                                                                WMSManagement@1000 : Codeunit 7302;
                                                                WhseIntegrationMgt@1001 : Codeunit 7317;
                                                              BEGIN
                                                                TestStatusOpen;
                                                                TESTFIELD(Type,Type::Item);
                                                                IF "Bin Code" <> '' THEN BEGIN
                                                                  TESTFIELD("Location Code");
                                                                  WMSManagement.FindBin("Location Code","Bin Code",'');
                                                                  WhseIntegrationMgt.CheckBinTypeCode(DATABASE::"Assembly Line",
                                                                    FIELDCAPTION("Bin Code"),
                                                                    "Location Code",
                                                                    "Bin Code",0);
                                                                  CheckBin;
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              WMSManagement@1000 : Codeunit 7302;
                                                              BinCode@1001 : Code[20];
                                                            BEGIN
                                                              TESTFIELD(Type,Type::Item);
                                                              IF Quantity > 0 THEN
                                                                BinCode := WMSManagement.BinContentLookUp("Location Code","No.","Variant Code",'',"Bin Code")
                                                              ELSE
                                                                BinCode := WMSManagement.BinLookUp("Location Code","No.","Variant Code",'');

                                                              IF BinCode <> '' THEN
                                                                VALIDATE("Bin Code",BinCode);
                                                            END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 25  ;   ;Position            ;Code10        ;CaptionML=[DAN=Position;
                                                              ENU=Position] }
    { 26  ;   ;Position 2          ;Code10        ;CaptionML=[DAN=Position 2;
                                                              ENU=Position 2] }
    { 27  ;   ;Position 3          ;Code10        ;CaptionML=[DAN=Position 3;
                                                              ENU=Position 3] }
    { 38  ;   ;Appl.-to Item Entry ;Integer       ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                              BEGIN
                                                                IF "Appl.-to Item Entry" <> 0 THEN BEGIN
                                                                  TESTFIELD(Type,Type::Item);
                                                                  TESTFIELD(Quantity);
                                                                  IF Quantity < 0 THEN
                                                                    FIELDERROR(Quantity,Text029);
                                                                  ItemLedgEntry.GET("Appl.-to Item Entry");
                                                                  ItemLedgEntry.TESTFIELD(Positive,TRUE);
                                                                  "Location Code" := ItemLedgEntry."Location Code";
                                                                  IF NOT ItemLedgEntry.Open THEN
                                                                    MESSAGE(Text042,"Appl.-to Item Entry");
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              SelectItemEntry(FIELDNO("Appl.-to Item Entry"));
                                                            END;

                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udl.varepostl�benr.;
                                                              ENU=Appl.-to Item Entry] }
    { 39  ;   ;Appl.-from Item Entry;Integer      ;OnLookup=BEGIN
                                                              SelectItemEntry(FIELDNO("Appl.-from Item Entry"));
                                                            END;

                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udlign fra-varepost;
                                                              ENU=Appl.-from Item Entry];
                                                   MinValue=0 }
    { 40  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);

                                                                RoundQty(Quantity);
                                                                "Quantity (Base)" := CalcBaseQty(Quantity);
                                                                InitRemainingQty;
                                                                InitQtyToConsume;

                                                                CheckItemAvailable(FIELDNO(Quantity));
                                                                VerifyReservationQuantity(Rec,xRec);

                                                                "Cost Amount" := CalcCostAmount(Quantity,"Unit Cost");
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 41  ;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Quantity (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 42  ;   ;Remaining Quantity  ;Decimal       ;CaptionML=[DAN=Restantal;
                                                              ENU=Remaining Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 43  ;   ;Remaining Quantity (Base);Decimal  ;CaptionML=[DAN=Restantal (basis);
                                                              ENU=Remaining Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 44  ;   ;Consumed Quantity   ;Decimal       ;CaptionML=[DAN=Forbrugt antal;
                                                              ENU=Consumed Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 45  ;   ;Consumed Quantity (Base);Decimal   ;CaptionML=[DAN=Forbrugt antal (basis);
                                                              ENU=Consumed Quantity (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 46  ;   ;Quantity to Consume ;Decimal       ;OnValidate=BEGIN
                                                                WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);
                                                                RoundQty("Quantity to Consume");
                                                                RoundQty("Remaining Quantity");
                                                                IF "Quantity to Consume" > "Remaining Quantity" THEN
                                                                  ERROR(Text003,
                                                                    FIELDCAPTION("Quantity to Consume"),FIELDCAPTION("Remaining Quantity"),"Remaining Quantity");

                                                                VALIDATE("Quantity to Consume (Base)",CalcBaseQty("Quantity to Consume"));
                                                              END;

                                                   CaptionML=[DAN=Antal til forbrug;
                                                              ENU=Quantity to Consume];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 47  ;   ;Quantity to Consume (Base);Decimal ;CaptionML=[DAN=Antal til forbrug (basis);
                                                              ENU=Quantity to Consume (Base)];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 48  ;   ;Reserved Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Document No.),
                                                                                                        Source Ref. No.=FIELD(Line No.),
                                                                                                        Source Type=CONST(901),
                                                                                                        Source Subtype=FIELD(Document Type),
                                                                                                        Reservation Status=CONST(Reservation)));
                                                   CaptionML=[DAN=Reserveret antal;
                                                              ENU=Reserved Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 49  ;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Document No.),
                                                                                                                 Source Ref. No.=FIELD(Line No.),
                                                                                                                 Source Type=CONST(901),
                                                                                                                 Source Subtype=FIELD(Document Type),
                                                                                                                 Reservation Status=CONST(Reservation)));
                                                   CaptionML=[DAN=Reserveret antal (basis);
                                                              ENU=Reserved Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 50  ;   ;Avail. Warning      ;Boolean       ;CaptionML=[DAN=Adv. findes;
                                                              ENU=Avail. Warning];
                                                   Editable=No }
    { 51  ;   ;Substitution Available;Boolean     ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Item Substitution" WHERE (Type=CONST(Item),
                                                                                                Substitute Type=CONST(Item),
                                                                                                No.=FIELD(No.),
                                                                                                Variant Code=FIELD(Variant Code)));
                                                   CaptionML=[DAN=Erstatningsvare findes;
                                                              ENU=Substitution Available];
                                                   Editable=No }
    { 52  ;   ;Due Date            ;Date          ;OnValidate=BEGIN
                                                                GetHeader;
                                                                ValidateDueDate(AssemblyHeader,"Due Date",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 53  ;   ;Reserve             ;Option        ;OnValidate=BEGIN
                                                                IF Reserve <> Reserve::Never THEN BEGIN
                                                                  TESTFIELD(Type,Type::Item);
                                                                  TESTFIELD("No.");
                                                                END;

                                                                CALCFIELDS("Reserved Qty. (Base)");
                                                                IF Reserve = Reserve::Never THEN
                                                                  TESTFIELD("Reserved Qty. (Base)",0);

                                                                IF xRec.Reserve = Reserve::Always THEN BEGIN
                                                                  GetItemResource;
                                                                  IF Item.Reserve = Item.Reserve::Always THEN
                                                                    TESTFIELD(Reserve,Reserve::Always);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Reserver;
                                                              ENU=Reserve];
                                                   OptionCaptionML=[DAN=Aldrig,Eventuelt,Altid;
                                                                    ENU=Never,Optional,Always];
                                                   OptionString=Never,Optional,Always }
    { 60  ;   ;Quantity per        ;Decimal       ;OnValidate=BEGIN
                                                                TestStatusOpen;
                                                                WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);
                                                                IF Type = Type::" " THEN
                                                                  ERROR(Text99000002,FIELDCAPTION("Quantity per"),FIELDCAPTION(Type),Type::" ");
                                                                RoundQty("Quantity per");

                                                                GetHeader;
                                                                VALIDATE(Quantity,CalcQuantity("Quantity per",AssemblyHeader.Quantity));
                                                                VALIDATE(
                                                                  "Quantity to Consume",
                                                                  MinValue(MaxQtyToConsume,CalcQuantity("Quantity per",AssemblyHeader."Quantity to Assemble")));
                                                              END;

                                                   CaptionML=[DAN=Antal pr.;
                                                              ENU=Quantity per];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 61  ;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 62  ;   ;Inventory Posting Group;Code20     ;TableRelation="Inventory Posting Group";
                                                   CaptionML=[DAN=Varebogf�ringsgruppe;
                                                              ENU=Inventory Posting Group] }
    { 63  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   OnValidate=BEGIN
                                                                TestStatusOpen;
                                                              END;

                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 65  ;   ;Unit Cost           ;Decimal       ;OnValidate=VAR
                                                                SkuItemUnitCost@1000 : Decimal;
                                                              BEGIN
                                                                TESTFIELD("No.");
                                                                GetItemResource;
                                                                IF Type = Type::Item THEN BEGIN
                                                                  SkuItemUnitCost := GetUnitCost;
                                                                  IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                                                                    IF "Unit Cost" <> SkuItemUnitCost THEN
                                                                      ERROR(
                                                                        Text99000002,
                                                                        FIELDCAPTION("Unit Cost"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
                                                                END;

                                                                "Cost Amount" := CalcCostAmount(Quantity,"Unit Cost");
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 67  ;   ;Cost Amount         ;Decimal       ;CaptionML=[DAN=Kostbel�b;
                                                              ENU=Cost Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 72  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 80  ;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.));
                                                   OnValidate=VAR
                                                                UOMMgt@1001 : Codeunit 5402;
                                                              BEGIN
                                                                WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);
                                                                TestStatusOpen;

                                                                GetItemResource;
                                                                CASE Type OF
                                                                  Type::Item:
                                                                    "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                                                                  Type::Resource:
                                                                    "Qty. per Unit of Measure" := UOMMgt.GetResQtyPerUnitOfMeasure(Resource,"Unit of Measure Code");
                                                                  ELSE
                                                                    "Qty. per Unit of Measure" := 1;
                                                                END;

                                                                CheckItemAvailable(FIELDNO("Unit of Measure Code"));
                                                                "Unit Cost" := GetUnitCost;
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=VAR
                                                                DimMgt@1000 : Codeunit 408;
                                                              BEGIN
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 7301;   ;Pick Qty.           ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Activity Line"."Qty. Outstanding" WHERE (Activity Type=FILTER(<>Put-away),
                                                                                                                       Source Type=CONST(901),
                                                                                                                       Source Subtype=FIELD(Document Type),
                                                                                                                       Source No.=FIELD(Document No.),
                                                                                                                       Source Line No.=FIELD(Line No.),
                                                                                                                       Source Subline No.=CONST(0),
                                                                                                                       Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                       Action Type=FILTER(' '|Place),
                                                                                                                       Original Breakbulk=CONST(No),
                                                                                                                       Breakbulk No.=CONST(0)));
                                                   CaptionML=[DAN=Plukantal;
                                                              ENU=Pick Qty.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 7302;   ;Pick Qty. (Base)    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Activity Line"."Qty. Outstanding (Base)" WHERE (Activity Type=FILTER(<>Put-away),
                                                                                                                              Source Type=CONST(901),
                                                                                                                              Source Subtype=FIELD(Document Type),
                                                                                                                              Source No.=FIELD(Document No.),
                                                                                                                              Source Line No.=FIELD(Line No.),
                                                                                                                              Source Subline No.=CONST(0),
                                                                                                                              Unit of Measure Code=FIELD(Unit of Measure Code),
                                                                                                                              Action Type=FILTER(' '|Place),
                                                                                                                              Original Breakbulk=CONST(No),
                                                                                                                              Breakbulk No.=CONST(0)));
                                                   CaptionML=[DAN=Plukantal (basis);
                                                              ENU=Pick Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 7303;   ;Qty. Picked         ;Decimal       ;OnValidate=BEGIN
                                                                "Qty. Picked (Base)" := CalcBaseQty("Qty. Picked");
                                                              END;

                                                   CaptionML=[DAN=Plukket antal;
                                                              ENU=Qty. Picked];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 7304;   ;Qty. Picked (Base)  ;Decimal       ;CaptionML=[DAN=Plukket antal (basis);
                                                              ENU=Qty. Picked (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Document Type,Document No.,Line No.     ;Clustered=Yes }
    {    ;Document Type,Document No.,Type,Location Code;
                                                   SumIndexFields=Cost Amount,Quantity }
    {    ;Document Type,Type,No.,Variant Code,Location Code,Due Date;
                                                   SumIndexFields=Remaining Quantity (Base),Qty. Picked (Base),Consumed Quantity (Base) }
    {    ;Type,No.                                 }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Item@1003 : Record 27;
      Resource@1004 : Record 156;
      Text001@1055 : TextConst 'DAN=Automatisk reservation er ikke mulig.\Vil du reservere varerne manuelt?;ENU=Automatic reservation is not possible.\Do you want to reserve items manually?';
      Text002@1017 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename an %1.';
      Text003@1012 : TextConst 'DAN=%1 m� ikke v�re h�jere end %2, som er %3.;ENU=%1 cannot be higher than the %2, which is %3.';
      Text029@1010 : TextConst '@@@=starts with "Quantity";DAN=skal v�re positiv;ENU=must be positive';
      Text042@1011 : TextConst 'DAN=N�r du bogf�rer udligningsposten, �bnes %1 f�rst.;ENU=When posting the Applied to Ledger Entry, %1 will be opened first.';
      Text99000002@1006 : TextConst 'DAN=Du kan ikke �ndre %1, n�r %2 er ''%3''.;ENU=You cannot change %1 when %2 is ''%3''.';
      AssemblyHeader@1002 : Record 900;
      StockkeepingUnit@1005 : Record 5700;
      GLSetup@1000 : Record 98;
      ItemSubstMgt@1007 : Codeunit 5701;
      WhseValidateSourceLine@1015 : Codeunit 5777;
      AssemblyLineReserve@1056 : Codeunit 926;
      GLSetupRead@1001 : Boolean;
      StatusCheckSuspended@1016 : Boolean;
      TestReservationDateConflict@1057 : Boolean;
      SkipVerificationsThatChangeDatabase@1018 : Boolean;
      Text049@1019 : TextConst 'DAN=%1 m� ikke v�re senere end %2, da %3 er angivet til %4.;ENU=%1 cannot be later than %2 because the %3 is set to %4.';
      Text050@1020 : TextConst 'DAN=Forfaldsdatoen %1 er f�r arbejdsdatoen %2.;ENU=Due Date %1 is before work date %2.';

    [External]
    PROCEDURE InitRemainingQty@51();
    BEGIN
      "Remaining Quantity" := MaxValue(Quantity - "Consumed Quantity",0);
      "Remaining Quantity (Base)" := MaxValue("Quantity (Base)" - "Consumed Quantity (Base)",0);
    END;

    [External]
    PROCEDURE InitQtyToConsume@53();
    BEGIN
      GetHeader;
      "Quantity to Consume" :=
        MinValue(MaxQtyToConsume,CalcQuantity("Quantity per",AssemblyHeader."Quantity to Assemble"));
      "Quantity to Consume (Base)" :=
        MinValue(
          MaxQtyToConsumeBase,
          CalcBaseQty(CalcQuantity("Quantity per",AssemblyHeader."Quantity to Assemble (Base)")));
    END;

    [External]
    PROCEDURE MaxQtyToConsume@7() : Decimal;
    BEGIN
      EXIT("Remaining Quantity");
    END;

    LOCAL PROCEDURE MaxQtyToConsumeBase@34() : Decimal;
    BEGIN
      EXIT("Remaining Quantity (Base)");
    END;

    LOCAL PROCEDURE GetSKU@5802() : Boolean;
    BEGIN
      IF Type = Type::Item THEN
        IF (StockkeepingUnit."Location Code" = "Location Code") AND
           (StockkeepingUnit."Item No." = "No.") AND
           (StockkeepingUnit."Variant Code" = "Variant Code")
        THEN
          EXIT(TRUE);
      IF StockkeepingUnit.GET("Location Code","No.","Variant Code") THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetUnitCost@23() : Decimal;
    VAR
      UnitCost@1000 : Decimal;
    BEGIN
      GetItemResource;

      CASE Type OF
        Type::Item:
          IF GetSKU THEN
            UnitCost := StockkeepingUnit."Unit Cost" * "Qty. per Unit of Measure"
          ELSE
            UnitCost := Item."Unit Cost" * "Qty. per Unit of Measure";
        Type::Resource:
          UnitCost := Resource."Unit Cost" * "Qty. per Unit of Measure";
      END;

      EXIT(RoundUnitAmount(UnitCost));
    END;

    LOCAL PROCEDURE CalcCostAmount@41(Qty@1000 : Decimal;UnitCost@1001 : Decimal) : Decimal;
    BEGIN
      EXIT(ROUND(Qty * UnitCost));
    END;

    LOCAL PROCEDURE RoundUnitAmount@59(UnitAmount@1000 : Decimal) : Decimal;
    BEGIN
      GetGLSetup;

      EXIT(ROUND(UnitAmount,GLSetup."Unit-Amount Rounding Precision"));
    END;

    [External]
    PROCEDURE ShowReservation@8();
    VAR
      Reservation@1000 : Page 498;
    BEGIN
      IF Type = Type::Item THEN BEGIN
        TESTFIELD("No.");
        TESTFIELD(Reserve);
        CLEAR(Reservation);
        Reservation.SetAssemblyLine(Rec);
        Reservation.RUNMODAL;
      END;
    END;

    [External]
    PROCEDURE ShowReservationEntries@21(Modal@1000 : Boolean);
    VAR
      ReservEntry@1001 : Record 337;
      ReservEngineMgt@1003 : Codeunit 99000831;
    BEGIN
      IF Type = Type::Item THEN BEGIN
        TESTFIELD("No.");
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
        AssemblyLineReserve.FilterReservFor(ReservEntry,Rec);
        IF Modal THEN
          PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
        ELSE
          PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
      END;
    END;

    [External]
    PROCEDURE UpdateAvailWarning@42() : Boolean;
    VAR
      ItemCheckAvail@1000 : Codeunit 311;
    BEGIN
      "Avail. Warning" := FALSE;
      IF Type = Type::Item THEN
        "Avail. Warning" := ItemCheckAvail.AsmOrderLineShowWarning(Rec);
      EXIT("Avail. Warning");
    END;

    LOCAL PROCEDURE CheckItemAvailable@49(CalledByFieldNo@1001 : Integer);
    VAR
      AssemblySetup@1002 : Record 905;
      ItemCheckAvail@1000 : Codeunit 311;
    BEGIN
      IF NOT UpdateAvailWarning THEN
        EXIT;

      IF "Document Type" <> "Document Type"::Order THEN
        EXIT;

      AssemblySetup.GET;
      IF NOT AssemblySetup."Stockout Warning" THEN
        EXIT;

      IF Reserve = Reserve::Always THEN
        EXIT;

      IF (CalledByFieldNo = CurrFieldNo) OR
         ((CalledByFieldNo = FIELDNO("No.")) AND (CurrFieldNo <> 0)) OR
         ((CalledByFieldNo = FIELDNO(Quantity)) AND (CurrFieldNo = FIELDNO("Quantity per")))
      THEN
        IF ItemCheckAvail.AssemblyLineCheck(Rec) THEN
          ItemCheckAvail.RaiseUpdateInterruptedError;
    END;

    [Internal]
    PROCEDURE ShowAvailabilityWarning@43();
    VAR
      ItemCheckAvail@1000 : Codeunit 311;
    BEGIN
      TESTFIELD(Type,Type::Item);

      IF "Due Date" = 0D THEN BEGIN
        GetHeader;
        IF AssemblyHeader."Due Date" <> 0D THEN
          VALIDATE("Due Date",AssemblyHeader."Due Date")
        ELSE
          VALIDATE("Due Date",WORKDATE);
      END;

      ItemCheckAvail.AssemblyLineCheck(Rec);
    END;

    LOCAL PROCEDURE CalcBaseQty@3(Qty@1000 : Decimal) : Decimal;
    VAR
      UOMMgt@1001 : Codeunit 5402;
    BEGIN
      EXIT(UOMMgt.CalcBaseQty(Qty,"Qty. per Unit of Measure"));
    END;

    LOCAL PROCEDURE CalcQtyFromBase@2(QtyBase@1000 : Decimal) : Decimal;
    VAR
      UOMMgt@1001 : Codeunit 5402;
    BEGIN
      EXIT(UOMMgt.CalcQtyFromBase(QtyBase,"Qty. per Unit of Measure"));
    END;

    [External]
    PROCEDURE IsInbound@97() : Boolean;
    BEGIN
      IF "Document Type" IN ["Document Type"::Order,"Document Type"::Quote,"Document Type"::"Blanket Order"] THEN
        EXIT("Quantity (Base)" < 0);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500();
    VAR
      AssemblyLineReserve@1000 : Codeunit 926;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      TESTFIELD("Quantity (Base)");
      AssemblyLineReserve.CallItemTracking(Rec);
    END;

    LOCAL PROCEDURE GetItemResource@1();
    BEGIN
      IF Type = Type::Item THEN
        IF Item."No." <> "No." THEN
          Item.GET("No.");
      IF Type = Type::Resource THEN
        IF Resource."No." <> "No." THEN
          Resource.GET("No.");
    END;

    LOCAL PROCEDURE GetGLSetup@11();
    BEGIN
      IF NOT GLSetupRead THEN BEGIN
        GLSetup.GET;
        GLSetupRead := TRUE
      END
    END;

    LOCAL PROCEDURE GetLocation@7300(VAR Location@1002 : Record 14;LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    [External]
    PROCEDURE AutoReserve@148();
    VAR
      ReservMgt@1002 : Codeunit 99000845;
      FullAutoReservation@1000 : Boolean;
    BEGIN
      IF Type <> Type::Item THEN
        EXIT;

      TESTFIELD("No.");
      IF Reserve <> Reserve::Always THEN
        EXIT;

      IF "Remaining Quantity (Base)" <> 0 THEN BEGIN
        TESTFIELD("Due Date");
        ReservMgt.SetAssemblyLine(Rec);
        ReservMgt.AutoReserve(FullAutoReservation,'',"Due Date","Remaining Quantity","Remaining Quantity (Base)");
        FIND;
        IF NOT FullAutoReservation AND (CurrFieldNo <> 0) THEN
          IF CONFIRM(Text001,TRUE) THEN BEGIN
            COMMIT;
            ShowReservation;
            FIND;
          END;
      END;
    END;

    [External]
    PROCEDURE ReservationStatus@58() : Integer;
    VAR
      Status@1000 : ' ,Partial,Complete';
    BEGIN
      IF (Reserve = Reserve::Never) OR ("Remaining Quantity" = 0) THEN
        EXIT(Status::" ");

      CALCFIELDS("Reserved Quantity");
      IF "Reserved Quantity" = 0 THEN BEGIN
        IF Reserve = Reserve::Always THEN
          EXIT(Status::Partial);
        EXIT(Status::" ");
      END;

      IF "Reserved Quantity" < "Remaining Quantity" THEN
        EXIT(Status::Partial);

      EXIT(Status::Complete);
    END;

    [External]
    PROCEDURE SetTestReservationDateConflict@155(NewTestReservationDateConflict@1000 : Boolean);
    BEGIN
      TestReservationDateConflict := NewTestReservationDateConflict;
    END;

    LOCAL PROCEDURE GetHeader@4();
    BEGIN
      IF (AssemblyHeader."No." <> "Document No.") AND ("Document No." <> '') THEN
        AssemblyHeader.GET("Document Type","Document No.");
    END;

    [External]
    PROCEDURE ShowDimensions@25();
    VAR
      DimMgt@1000 : Codeunit 408;
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Document Type","Document No.","Line No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE CreateDim@26(Type1@1000 : Integer;No1@1001 : Code[20];HeaderDimensionSetID@1009 : Integer);
    VAR
      SourceCodeSetup@1006 : Record 242;
      AssemblySetup@1002 : Record 905;
      DimMgt@1003 : Codeunit 408;
      TableID@1007 : ARRAY [10] OF Integer;
      No@1008 : ARRAY [10] OF Code[20];
      DimensionSetIDArr@1004 : ARRAY [10] OF Integer;
    BEGIN
      IF SkipVerificationsThatChangeDatabase THEN
        EXIT;

      SourceCodeSetup.GET;
      TableID[1] := Type1;
      No[1] := No1;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      AssemblySetup.GET;
      CASE AssemblySetup."Copy Component Dimensions from" OF
        AssemblySetup."Copy Component Dimensions from"::"Order Header":
          BEGIN
            DimensionSetIDArr[1] :=
              DimMgt.GetRecDefaultDimID(
                Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Assembly,
                "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
                0,0);
            DimensionSetIDArr[2] := HeaderDimensionSetID;
          END;
        AssemblySetup."Copy Component Dimensions from"::"Item/Resource Card":
          BEGIN
            DimensionSetIDArr[2] :=
              DimMgt.GetRecDefaultDimID(
                Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Assembly,
                "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
                0,0);
            DimensionSetIDArr[1] := HeaderDimensionSetID;
          END;
      END;

      "Dimension Set ID" :=
        DimMgt.GetCombinedDimensionSetID(DimensionSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE UpdateDim@10(NewHeaderSetID@1002 : Integer;OldHeaderSetID@1000 : Integer);
    VAR
      DimMgt@1003 : Codeunit 408;
    BEGIN
      "Dimension Set ID" := DimMgt.GetDeltaDimSetID("Dimension Set ID",NewHeaderSetID,OldHeaderSetID);
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    VAR
      DimMgt@1002 : Codeunit 408;
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [Internal]
    PROCEDURE ShowItemSub@30();
    BEGIN
      ItemSubstMgt.ItemAssemblySubstGet(Rec);
    END;

    [External]
    PROCEDURE ShowAssemblyList@39();
    VAR
      BomComponent@1001 : Record 90;
    BEGIN
      TESTFIELD(Type,Type::Item);
      BomComponent.SETRANGE("Parent Item No.","No.");
      PAGE.RUN(PAGE::"Assembly BOM",BomComponent);
    END;

    [Internal]
    PROCEDURE ExplodeAssemblyList@9();
    VAR
      AssemblyLineManagement@1000 : Codeunit 905;
    BEGIN
      AssemblyLineManagement.ExplodeAsmList(Rec);
    END;

    [External]
    PROCEDURE CalcQuantityPer@15(Qty@1000 : Decimal) : Decimal;
    BEGIN
      GetHeader;
      AssemblyHeader.TESTFIELD(Quantity);

      IF FixedUsage THEN
        EXIT(Qty);

      EXIT(Qty / AssemblyHeader.Quantity);
    END;

    [External]
    PROCEDURE CalcQuantityFromBOM@20(LineType@1004 : Option;QtyPer@1000 : Decimal;HeaderQty@1001 : Decimal;HeaderQtyPerUOM@1003 : Decimal;LineResourceUsageType@1002 : Option) : Decimal;
    BEGIN
      IF FixedUsage2(LineType,LineResourceUsageType) THEN
        EXIT(QtyPer);

      EXIT(QtyPer * HeaderQty * HeaderQtyPerUOM);
    END;

    LOCAL PROCEDURE CalcQuantity@115(LineQtyPer@1000 : Decimal;HeaderQty@1001 : Decimal) : Decimal;
    BEGIN
      EXIT(CalcQuantityFromBOM(Type,LineQtyPer,HeaderQty,1,"Resource Usage Type"));
    END;

    [External]
    PROCEDURE FilterLinesWithItemToPlan@33(VAR Item@1000 : Record 27;DocumentType@1002 : Option);
    BEGIN
      RESET;
      SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Location Code");
      SETRANGE("Document Type",DocumentType);
      SETRANGE(Type,Type::Item);
      SETRANGE("No.",Item."No.");
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Due Date",Item.GETFILTER("Date Filter"));
      SETFILTER("Shortcut Dimension 1 Code",Item.GETFILTER("Global Dimension 1 Filter"));
      SETFILTER("Shortcut Dimension 2 Code",Item.GETFILTER("Global Dimension 2 Filter"));
      SETFILTER("Remaining Quantity (Base)",'<>0');
    END;

    [External]
    PROCEDURE FindLinesWithItemToPlan@32(VAR Item@1000 : Record 27;DocumentType@1002 : Option) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item,DocumentType);
      EXIT(FIND('-'));
    END;

    [External]
    PROCEDURE LinesWithItemToPlanExist@31(VAR Item@1000 : Record 27;DocumentType@1002 : Option) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item,DocumentType);
      EXIT(NOT ISEMPTY);
    END;

    LOCAL PROCEDURE GetEarliestAvailDate@35(CompanyInfo@1001 : Record 79;GrossRequirement@1002 : Decimal;ExcludeQty@1004 : Decimal;ExcludeDate@1005 : Date) : Date;
    VAR
      AvailableToPromise@1000 : Codeunit 5790;
      QtyAvailable@1003 : Decimal;
    BEGIN
      GetItemResource;
      SetItemFilter(Item);

      EXIT(
        AvailableToPromise.EarliestAvailabilityDate(
          Item,
          GrossRequirement,
          "Due Date",
          ExcludeQty,
          ExcludeDate,
          QtyAvailable,
          CompanyInfo."Check-Avail. Time Bucket",
          CompanyInfo."Check-Avail. Period Calc."));
    END;

    LOCAL PROCEDURE SelectItemEntry@44(CurrentFieldNo@1000 : Integer);
    VAR
      ItemLedgEntry@1001 : Record 32;
      AsmLine3@1002 : Record 901;
    BEGIN
      ItemLedgEntry.SETRANGE("Item No.","No.");
      ItemLedgEntry.SETRANGE("Location Code","Location Code");
      ItemLedgEntry.SETRANGE("Variant Code","Variant Code");

      IF CurrentFieldNo = FIELDNO("Appl.-to Item Entry") THEN BEGIN
        ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
        ItemLedgEntry.SETRANGE(Positive,TRUE);
        ItemLedgEntry.SETRANGE(Open,TRUE);
      END ELSE BEGIN
        ItemLedgEntry.SETCURRENTKEY("Item No.",Positive);
        ItemLedgEntry.SETRANGE(Positive,FALSE);
        ItemLedgEntry.SETFILTER("Shipped Qty. Not Returned",'<0');
      END;
      IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
        AsmLine3 := Rec;
        IF CurrentFieldNo = FIELDNO("Appl.-to Item Entry") THEN
          AsmLine3.VALIDATE("Appl.-to Item Entry",ItemLedgEntry."Entry No.")
        ELSE
          AsmLine3.VALIDATE("Appl.-from Item Entry",ItemLedgEntry."Entry No.");
        Rec := AsmLine3;
      END;
    END;

    [External]
    PROCEDURE SetItemFilter@45(VAR Item@1000 : Record 27);
    BEGIN
      IF Type = Type::Item THEN BEGIN
        Item.GET("No.");
        IF "Due Date" = 0D THEN
          "Due Date" := WORKDATE;
        Item.SETRANGE("Date Filter",0D,"Due Date");
        Item.SETRANGE("Location Filter","Location Code");
        Item.SETRANGE("Variant Filter","Variant Code");
      END;
    END;

    LOCAL PROCEDURE CalcAvailQuantities@24(VAR Item@1001 : Record 27;VAR GrossRequirement@1002 : Decimal;VAR ScheduledReceipt@1004 : Decimal;VAR ExpectedInventory@1007 : Decimal;VAR AvailableInventory@1012 : Decimal;VAR EarliestDate@1010 : Date);
    VAR
      OldAssemblyLine@1011 : Record 901;
      CompanyInfo@1008 : Record 79;
      AvailableToPromise@1013 : Codeunit 5790;
      AvailabilityDate@1009 : Date;
      ReservedReceipt@1000 : Decimal;
      ReservedRequirement@1003 : Decimal;
      PeriodType@1006 : 'Day,Week,Month,Quarter,Year';
      LookaheadDateFormula@1005 : DateFormula;
    BEGIN
      SetItemFilter(Item);
      AvailableInventory := AvailableToPromise.CalcAvailableInventory(Item);
      ScheduledReceipt := AvailableToPromise.CalcScheduledReceipt(Item);
      ReservedReceipt := AvailableToPromise.CalcReservedReceipt(Item);
      ReservedRequirement := AvailableToPromise.CalcReservedRequirement(Item);
      GrossRequirement := AvailableToPromise.CalcGrossRequirement(Item);

      CompanyInfo.GET;
      LookaheadDateFormula := CompanyInfo."Check-Avail. Period Calc.";
      IF FORMAT(LookaheadDateFormula) <> '' THEN BEGIN
        AvailabilityDate := Item.GETRANGEMAX("Date Filter");
        PeriodType := CompanyInfo."Check-Avail. Time Bucket";

        GrossRequirement :=
          GrossRequirement +
          AvailableToPromise.CalculateLookahead(
            Item,PeriodType,
            AvailabilityDate + 1,
            AvailableToPromise.AdjustedEndingDate(CALCDATE(LookaheadDateFormula,AvailabilityDate),PeriodType));
      END;

      IF OrderLineExists(OldAssemblyLine) THEN
        GrossRequirement := GrossRequirement - OldAssemblyLine."Remaining Quantity (Base)"
      ELSE
        OldAssemblyLine.INIT;

      EarliestDate :=
        GetEarliestAvailDate(
          CompanyInfo,"Remaining Quantity (Base)",
          OldAssemblyLine."Remaining Quantity (Base)",OldAssemblyLine."Due Date");

      ExpectedInventory :=
        CalcExpectedInventory(AvailableInventory,ScheduledReceipt - ReservedReceipt,GrossRequirement - ReservedRequirement);

      AvailableInventory := CalcQtyFromBase(AvailableInventory);
      GrossRequirement := CalcQtyFromBase(GrossRequirement);
      ScheduledReceipt := CalcQtyFromBase(ScheduledReceipt);
      ExpectedInventory := CalcQtyFromBase(ExpectedInventory);
    END;

    LOCAL PROCEDURE CalcExpectedInventory@164(Inventory@1000 : Decimal;ScheduledReceipt@1002 : Decimal;GrossRequirement@1001 : Decimal) : Decimal;
    BEGIN
      EXIT(Inventory + ScheduledReceipt - GrossRequirement);
    END;

    [External]
    PROCEDURE CalcAvailToAssemble@47(AssemblyHeader@1012 : Record 900;VAR Item@1008 : Record 27;VAR GrossRequirement@1007 : Decimal;VAR ScheduledReceipt@1005 : Decimal;VAR ExpectedInventory@1002 : Decimal;VAR AvailableInventory@1013 : Decimal;VAR EarliestDate@1000 : Date;VAR AbleToAssemble@1010 : Decimal);
    VAR
      UOMMgt@1001 : Codeunit 5402;
    BEGIN
      TESTFIELD("Quantity per");

      CalcAvailQuantities(
        Item,
        GrossRequirement,
        ScheduledReceipt,
        ExpectedInventory,
        AvailableInventory,
        EarliestDate);

      IF ExpectedInventory < "Remaining Quantity (Base)" THEN BEGIN
        IF ExpectedInventory < 0 THEN
          AbleToAssemble := 0
        ELSE
          AbleToAssemble := ROUND(ExpectedInventory / "Quantity per",UOMMgt.QtyRndPrecision,'<')
      END ELSE BEGIN
        AbleToAssemble := AssemblyHeader."Remaining Quantity";
        EarliestDate := 0D;
      END;
    END;

    LOCAL PROCEDURE MaxValue@70(Value@1000 : Decimal;Value2@1001 : Decimal) : Decimal;
    BEGIN
      IF Value < Value2 THEN
        EXIT(Value2);

      EXIT(Value);
    END;

    LOCAL PROCEDURE MinValue@19(Value@1000 : Decimal;Value2@1001 : Decimal) : Decimal;
    BEGIN
      IF Value < Value2 THEN
        EXIT(Value);

      EXIT(Value2);
    END;

    LOCAL PROCEDURE RoundQty@46(VAR Qty@1000 : Decimal);
    VAR
      UOMMgt@1001 : Codeunit 5402;
    BEGIN
      Qty := UOMMgt.RoundQty(Qty);
    END;

    [External]
    PROCEDURE FixedUsage@40() : Boolean;
    BEGIN
      EXIT(FixedUsage2(Type,"Resource Usage Type"));
    END;

    LOCAL PROCEDURE FixedUsage2@61(LineType@1004 : Option;LineResourceUsageType@1000 : Option) : Boolean;
    BEGIN
      IF (LineType = Type::Resource) AND (LineResourceUsageType = "Resource Usage Type"::Fixed) THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE InitResourceUsageType@342();
    BEGIN
      CASE Type OF
        Type::" ",Type::Item:
          "Resource Usage Type" := "Resource Usage Type"::" ";
        Type::Resource:
          "Resource Usage Type" := "Resource Usage Type"::Direct;
      END;
    END;

    [External]
    PROCEDURE SignedXX@52(Value@1000 : Decimal) : Decimal;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::Quote,
        "Document Type"::Order,
        "Document Type"::"Blanket Order":
          EXIT(-Value);
      END;
    END;

    [External]
    PROCEDURE RowID1@48() : Text[250];
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
    BEGIN
      EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Assembly Line","Document Type","Document No.",'',0,"Line No."));
    END;

    LOCAL PROCEDURE CheckBin@54();
    VAR
      BinContent@1000 : Record 7302;
      Bin@1001 : Record 7354;
      Location@1002 : Record 14;
    BEGIN
      IF "Bin Code" <> '' THEN BEGIN
        GetLocation(Location,"Location Code");
        IF NOT Location."Directed Put-away and Pick" THEN
          EXIT;

        IF BinContent.GET(
             "Location Code","Bin Code",
             "No.","Variant Code","Unit of Measure Code")
        THEN
          BinContent.CheckWhseClass(FALSE)
        ELSE BEGIN
          Bin.GET("Location Code","Bin Code");
          Bin.CheckWhseClass("No.",FALSE);
        END;
      END;
    END;

    [External]
    PROCEDURE GetDefaultBin@50();
    BEGIN
      TESTFIELD(Type,Type::Item);
      IF (Quantity * xRec.Quantity > 0) AND
         ("No." = xRec."No.") AND
         ("Location Code" = xRec."Location Code") AND
         ("Variant Code" = xRec."Variant Code")
      THEN
        EXIT;

      VALIDATE("Bin Code",FindBin);
    END;

    [External]
    PROCEDURE FindBin@12() NewBinCode : Code[20];
    VAR
      Location@1001 : Record 14;
      WMSManagement@1000 : Codeunit 7302;
    BEGIN
      IF ("Location Code" <> '') AND ("No." <> '') THEN BEGIN
        GetLocation(Location,"Location Code");
        NewBinCode := Location."To-Assembly Bin Code";
        IF NewBinCode <> '' THEN
          EXIT;

        IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
          WMSManagement.GetDefaultBin("No.","Variant Code","Location Code",NewBinCode);
      END;
    END;

    LOCAL PROCEDURE TestStatusOpen@68();
    BEGIN
      IF StatusCheckSuspended THEN
        EXIT;
      GetHeader;
      IF Type IN [Type::Item,Type::Resource] THEN
        AssemblyHeader.TESTFIELD(Status,AssemblyHeader.Status::Open);
    END;

    [External]
    PROCEDURE SuspendStatusCheck@56(Suspend@1000 : Boolean);
    BEGIN
      StatusCheckSuspended := Suspend;
    END;

    [External]
    PROCEDURE CompletelyPicked@67() : Boolean;
    VAR
      Location@1000 : Record 14;
    BEGIN
      TESTFIELD(Type,Type::Item);
      GetLocation(Location,"Location Code");
      IF Location."Require Shipment" THEN
        EXIT("Qty. Picked (Base)" - "Consumed Quantity (Base)" >= "Remaining Quantity (Base)");
      EXIT("Qty. Picked (Base)" - "Consumed Quantity (Base)" >= "Quantity to Consume (Base)");
    END;

    [External]
    PROCEDURE CalcQtyToPick@60() : Decimal;
    BEGIN
      CALCFIELDS("Pick Qty.");
      EXIT("Remaining Quantity" - (CalcQtyPickedNotConsumed + "Pick Qty."));
    END;

    [External]
    PROCEDURE CalcQtyToPickBase@62() : Decimal;
    BEGIN
      CALCFIELDS("Pick Qty. (Base)");
      EXIT("Remaining Quantity (Base)" - (CalcQtyPickedNotConsumedBase + "Pick Qty. (Base)"));
    END;

    [External]
    PROCEDURE CalcQtyPickedNotConsumed@14() : Decimal;
    BEGIN
      EXIT("Qty. Picked" - "Consumed Quantity");
    END;

    [External]
    PROCEDURE CalcQtyPickedNotConsumedBase@5() : Decimal;
    BEGIN
      EXIT("Qty. Picked (Base)" - "Consumed Quantity (Base)");
    END;

    [External]
    PROCEDURE ItemExists@65(ItemNo@1000 : Code[20]) : Boolean;
    VAR
      Item2@1001 : Record 27;
    BEGIN
      IF Type <> Type::Item THEN
        EXIT(FALSE);

      IF NOT Item2.GET(ItemNo) THEN
        EXIT(FALSE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE ShowTracking@66();
    VAR
      OrderTracking@1000 : Page 99000822;
    BEGIN
      OrderTracking.SetAsmLine(Rec);
      OrderTracking.RUNMODAL;
    END;

    LOCAL PROCEDURE OrderLineExists@57(VAR AssemblyLine@1000 : Record 901) : Boolean;
    BEGIN
      EXIT(
        ("Document Type" = "Document Type"::Order) AND
        AssemblyLine.GET("Document Type","Document No.","Line No.") AND
        (AssemblyLine.Type = Type) AND
        (AssemblyLine."No." = "No.") AND
        (AssemblyLine."Location Code" = "Location Code") AND
        (AssemblyLine."Variant Code" = "Variant Code") AND
        (AssemblyLine."Bin Code" = "Bin Code") AND
        (AssemblyLine."Due Date" <= "Due Date"));
    END;

    [External]
    PROCEDURE VerifyReservationQuantity@63(VAR NewAsmLine@1002 : Record 901;VAR OldAsmLine@1001 : Record 901);
    BEGIN
      IF SkipVerificationsThatChangeDatabase THEN
        EXIT;
      AssemblyLineReserve.VerifyQuantity(NewAsmLine,OldAsmLine);
    END;

    [External]
    PROCEDURE VerifyReservationChange@64(VAR NewAsmLine@1001 : Record 901;VAR OldAsmLine@1000 : Record 901);
    BEGIN
      IF SkipVerificationsThatChangeDatabase THEN
        EXIT;
      AssemblyLineReserve.VerifyChange(NewAsmLine,OldAsmLine);
    END;

    [External]
    PROCEDURE VerifyReservationDateConflict@71(NewAsmLine@1001 : Record 901);
    VAR
      ReservationCheckDateConfl@1000 : Codeunit 99000815;
    BEGIN
      IF SkipVerificationsThatChangeDatabase THEN
        EXIT;
      ReservationCheckDateConfl.AssemblyLineCheck(NewAsmLine,(CurrFieldNo <> 0) OR TestReservationDateConflict);
    END;

    [External]
    PROCEDURE SetSkipVerificationsThatChangeDatabase@69(State@1000 : Boolean);
    BEGIN
      SkipVerificationsThatChangeDatabase := State;
    END;

    [Internal]
    PROCEDURE ValidateDueDate@72(AsmHeader@1000 : Record 900;NewDueDate@1001 : Date;ShowDueDateBeforeWorkDateMsg@1003 : Boolean);
    VAR
      MaxDate@1002 : Date;
    BEGIN
      "Due Date" := NewDueDate;
      TestStatusOpen;

      MaxDate := LatestPossibleDueDate(AsmHeader."Starting Date");
      IF "Due Date" > MaxDate THEN
        ERROR(Text049,FIELDCAPTION("Due Date"),MaxDate,AsmHeader.FIELDCAPTION("Starting Date"),AsmHeader."Starting Date");

      IF (xRec."Due Date" <> "Due Date") AND (Quantity <> 0) THEN
        VerifyReservationDateConflict(Rec);

      CheckItemAvailable(FIELDNO("Due Date"));
      WhseValidateSourceLine.AssemblyLineVerifyChange(Rec,xRec);

      IF ("Due Date" < WORKDATE) AND ShowDueDateBeforeWorkDateMsg THEN
        MESSAGE(Text050,"Due Date",WORKDATE);
    END;

    [Internal]
    PROCEDURE ValidateLeadTimeOffset@74(AsmHeader@1001 : Record 900;NewLeadTimeOffset@1000 : DateFormula;ShowDueDateBeforeWorkDateMsg@1003 : Boolean);
    VAR
      ZeroDF@1002 : DateFormula;
    BEGIN
      "Lead-Time Offset" := NewLeadTimeOffset;
      TestStatusOpen;

      IF Type <> Type::Item THEN
        TESTFIELD("Lead-Time Offset",ZeroDF);
      ValidateDueDate(AsmHeader,LatestPossibleDueDate(AsmHeader."Starting Date"),ShowDueDateBeforeWorkDateMsg);
    END;

    LOCAL PROCEDURE LatestPossibleDueDate@73(HeaderStartingDate@1000 : Date) : Date;
    BEGIN
      EXIT(HeaderStartingDate - (CALCDATE("Lead-Time Offset",WORKDATE) - WORKDATE));
    END;

    [External]
    PROCEDURE TestItemFields@6(ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];LocationCode@1002 : Code[10]);
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.",ItemNo);
      TESTFIELD("Variant Code",VariantCode);
      TESTFIELD("Location Code",LocationCode);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@138(VAR AssemblyLine@1000 : Record 901;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

