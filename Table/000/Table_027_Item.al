OBJECT Table 27 Item
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=;
    DataCaptionFields=No.,Description;
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 GetInvtSetup;
                 InvtSetup.TESTFIELD("Item Nos.");
                 NoSeriesMgt.InitSeries(InvtSetup."Item Nos.",xRec."No. Series",0D,"No.","No. Series");
                 "Costing Method" := InvtSetup."Default Costing Method";
               END;

               DimMgt.UpdateDefaultDim(
                 DATABASE::Item,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");

               SetLastDateTimeModified;
             END;

    OnModify=BEGIN
               SetLastDateTimeModified;
               PlanningAssignment.ItemChange(Rec,xRec);
             END;

    OnDelete=BEGIN
               ApprovalsMgmt.OnCancelItemApprovalRequest(Rec);

               CheckJournalsAndWorksheets(0);
               CheckDocuments(0);

               MoveEntries.MoveItemEntries(Rec);

               ServiceItem.RESET;
               ServiceItem.SETRANGE("Item No.","No.");
               IF ServiceItem.FIND('-') THEN
                 REPEAT
                   ServiceItem.VALIDATE("Item No.",'');
                   ServiceItem.MODIFY(TRUE);
                 UNTIL ServiceItem.NEXT = 0;

               DeleteRelatedData;
             END;

    OnRename=VAR
               SalesLine@1000 : Record 37;
               PurchaseLine@1001 : Record 39;
               ItemAttributeValueMapping@1002 : Record 7505;
             BEGIN
               SalesLine.RenameNo(SalesLine.Type::Item,xRec."No.","No.");
               PurchaseLine.RenameNo(PurchaseLine.Type::Item,xRec."No.","No.");

               ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);
               ItemAttributeValueMapping.RenameItemAttributeValueMapping(xRec."No.","No.");
               SetLastDateTimeModified;
             END;

    CaptionML=[DAN=Vare;
               ENU=Item];
    LookupPageID=Page31;
    DrillDownPageID=Page31;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  GetInvtSetup;
                                                                  NoSeriesMgt.TestManual(InvtSetup."Item Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   AltSearchField=Search Description;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;No. 2               ;Code20        ;CaptionML=[DAN=Nr. 2;
                                                              ENU=No. 2] }
    { 3   ;   ;Description         ;Text50        ;OnValidate=BEGIN
                                                                IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
                                                                  "Search Description" := Description;

                                                                IF "Created From Nonstock Item" THEN BEGIN
                                                                  NonstockItem.SETCURRENTKEY("Item No.");
                                                                  NonstockItem.SETRANGE("Item No.","No.");
                                                                  IF NonstockItem.FINDFIRST THEN
                                                                    IF NonstockItem.Description = '' THEN BEGIN
                                                                      NonstockItem.Description := Description;
                                                                      NonstockItem.MODIFY;
                                                                    END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Search Description  ;Code50        ;CaptionML=[DAN=S�gebeskrivelse;
                                                              ENU=Search Description] }
    { 5   ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 6   ;   ;Assembly BOM        ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("BOM Component" WHERE (Parent Item No.=FIELD(No.)));
                                                   CaptionML=[DAN=Montagestykliste;
                                                              ENU=Assembly BOM];
                                                   Editable=No }
    { 8   ;   ;Base Unit of Measure;Code10        ;TableRelation="Unit of Measure";
                                                   OnValidate=VAR
                                                                UnitOfMeasure@1000 : Record 204;
                                                              BEGIN
                                                                UpdateUnitOfMeasureId;

                                                                IF "Base Unit of Measure" <> xRec."Base Unit of Measure" THEN BEGIN
                                                                  TestNoOpenEntriesExist(FIELDCAPTION("Base Unit of Measure"));

                                                                  "Sales Unit of Measure" := "Base Unit of Measure";
                                                                  "Purch. Unit of Measure" := "Base Unit of Measure";
                                                                  IF "Base Unit of Measure" <> '' THEN BEGIN
                                                                    UnitOfMeasure.GET("Base Unit of Measure");

                                                                    IF NOT ItemUnitOfMeasure.GET("No.","Base Unit of Measure") THEN BEGIN
                                                                      ItemUnitOfMeasure.INIT;
                                                                      IF ISTEMPORARY THEN
                                                                        ItemUnitOfMeasure."Item No." := "No."
                                                                      ELSE
                                                                        ItemUnitOfMeasure.VALIDATE("Item No.","No.");
                                                                      ItemUnitOfMeasure.VALIDATE(Code,"Base Unit of Measure");
                                                                      ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
                                                                      ItemUnitOfMeasure.INSERT;
                                                                    END ELSE BEGIN
                                                                      IF ItemUnitOfMeasure."Qty. per Unit of Measure" <> 1 THEN
                                                                        ERROR(STRSUBSTNO(BaseUnitOfMeasureQtyMustBeOneErr,"Base Unit of Measure",ItemUnitOfMeasure."Qty. per Unit of Measure"));
                                                                    END;
                                                                  END;
                                                                END;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Basisenhed;
                                                              ENU=Base Unit of Measure] }
    { 9   ;   ;Price Unit Conversion;Integer      ;CaptionML=[DAN=Prisfaktor;
                                                              ENU=Price Unit Conversion] }
    { 10  ;   ;Type                ;Option        ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                              BEGIN
                                                                ItemLedgEntry.RESET;
                                                                ItemLedgEntry.SETCURRENTKEY("Item No.");
                                                                ItemLedgEntry.SETRANGE("Item No.","No.");
                                                                IF NOT ItemLedgEntry.ISEMPTY THEN
                                                                  ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ItemLedgEntry.TABLECAPTION);

                                                                CheckJournalsAndWorksheets(FIELDNO(Type));
                                                                CheckDocuments(FIELDNO(Type));
                                                                IF Type = Type::Service THEN BEGIN
                                                                  CALCFIELDS("Assembly BOM");
                                                                  TESTFIELD("Assembly BOM",FALSE);

                                                                  CALCFIELDS("Stockkeeping Unit Exists");
                                                                  TESTFIELD("Stockkeeping Unit Exists",FALSE);

                                                                  VALIDATE("Assembly Policy","Assembly Policy"::"Assemble-to-Stock");
                                                                  VALIDATE("Replenishment System","Replenishment System"::Purchase);
                                                                  VALIDATE(Reserve,Reserve::Never);
                                                                  VALIDATE("Inventory Posting Group",'');
                                                                  VALIDATE("Item Tracking Code",'');
                                                                  VALIDATE("Costing Method","Costing Method"::FIFO);
                                                                  VALIDATE("Production BOM No.",'');
                                                                  VALIDATE("Routing No.",'');
                                                                  VALIDATE("Reordering Policy","Reordering Policy"::" ");
                                                                  VALIDATE("Order Tracking Policy","Order Tracking Policy"::None);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Lager,Service;
                                                                    ENU=Inventory,Service];
                                                   OptionString=Inventory,Service }
    { 11  ;   ;Inventory Posting Group;Code20     ;TableRelation="Inventory Posting Group";
                                                   OnValidate=BEGIN
                                                                IF "Inventory Posting Group" <> '' THEN
                                                                  TESTFIELD(Type,Type::Inventory);
                                                              END;

                                                   CaptionML=[DAN=Varebogf�ringsgruppe;
                                                              ENU=Inventory Posting Group] }
    { 12  ;   ;Shelf No.           ;Code10        ;CaptionML=[DAN=Placeringsnr.;
                                                              ENU=Shelf No.] }
    { 14  ;   ;Item Disc. Group    ;Code20        ;TableRelation="Item Discount Group";
                                                   CaptionML=[DAN=Varerabatgruppe;
                                                              ENU=Item Disc. Group] }
    { 15  ;   ;Allow Invoice Disc. ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad fakturarabat;
                                                              ENU=Allow Invoice Disc.] }
    { 16  ;   ;Statistics Group    ;Integer       ;CaptionML=[DAN=Statistikgruppe;
                                                              ENU=Statistics Group] }
    { 17  ;   ;Commission Group    ;Integer       ;CaptionML=[DAN=Provisionsgruppe;
                                                              ENU=Commission Group] }
    { 18  ;   ;Unit Price          ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Price/Profit Calculation");
                                                              END;

                                                   CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 19  ;   ;Price/Profit Calculation;Option    ;OnValidate=BEGIN
                                                                CASE "Price/Profit Calculation" OF
                                                                  "Price/Profit Calculation"::"Profit=Price-Cost":
                                                                    IF "Unit Price" <> 0 THEN
                                                                      IF "Unit Cost" = 0 THEN
                                                                        "Profit %" := 0
                                                                      ELSE
                                                                        "Profit %" :=
                                                                          ROUND(
                                                                            100 * (1 - "Unit Cost" /
                                                                                   ("Unit Price" / (1 + CalcVAT))),0.00001)
                                                                    ELSE
                                                                      "Profit %" := 0;
                                                                  "Price/Profit Calculation"::"Price=Cost+Profit":
                                                                    IF "Profit %" < 100 THEN BEGIN
                                                                      GetGLSetup;
                                                                      "Unit Price" :=
                                                                        ROUND(
                                                                          ("Unit Cost" / (1 - "Profit %" / 100)) *
                                                                          (1 + CalcVAT),
                                                                          GLSetup."Unit-Amount Rounding Precision");
                                                                    END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Avancepct.beregning;
                                                              ENU=Price/Profit Calculation];
                                                   OptionCaptionML=[DAN="Avance=Salgspris-Kostpris,Salgspris=Kostpris+Avance,Ingen";
                                                                    ENU="Profit=Price-Cost,Price=Cost+Profit,No Relationship"];
                                                   OptionString=Profit=Price-Cost,Price=Cost+Profit,No Relationship }
    { 20  ;   ;Profit %            ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Price/Profit Calculation");
                                                              END;

                                                   CaptionML=[DAN=Avancepct.;
                                                              ENU=Profit %];
                                                   DecimalPlaces=0:5 }
    { 21  ;   ;Costing Method      ;Option        ;OnValidate=BEGIN
                                                                IF "Costing Method" = xRec."Costing Method" THEN
                                                                  EXIT;

                                                                IF "Costing Method" <> "Costing Method"::FIFO THEN
                                                                  TESTFIELD(Type,Type::Inventory);

                                                                IF "Costing Method" = "Costing Method"::Specific THEN BEGIN
                                                                  TESTFIELD("Item Tracking Code");

                                                                  ItemTrackingCode.GET("Item Tracking Code");
                                                                  IF NOT ItemTrackingCode."SN Specific Tracking" THEN
                                                                    ERROR(
                                                                      Text018,
                                                                      ItemTrackingCode.FIELDCAPTION("SN Specific Tracking"),
                                                                      FORMAT(TRUE),ItemTrackingCode.TABLECAPTION,ItemTrackingCode.Code,
                                                                      FIELDCAPTION("Costing Method"),"Costing Method");
                                                                END;

                                                                TestNoEntriesExist(FIELDCAPTION("Costing Method"));

                                                                ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Costing Method"));
                                                              END;

                                                   CaptionML=[DAN=Kostprisberegningsmetode;
                                                              ENU=Costing Method];
                                                   OptionCaptionML=[DAN=FIFO,LIFO,Serienummer,Gennemsnit,Standard;
                                                                    ENU=FIFO,LIFO,Specific,Average,Standard];
                                                   OptionString=FIFO,LIFO,Specific,Average,Standard }
    { 22  ;   ;Unit Cost           ;Decimal       ;OnValidate=BEGIN
                                                                IF "Costing Method" = "Costing Method"::Standard THEN
                                                                  VALIDATE("Standard Cost","Unit Cost")
                                                                ELSE
                                                                  TestNoEntriesExist(FIELDCAPTION("Unit Cost"));
                                                                VALIDATE("Price/Profit Calculation");
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 24  ;   ;Standard Cost       ;Decimal       ;OnValidate=BEGIN
                                                                IF ("Costing Method" = "Costing Method"::Standard) AND (CurrFieldNo <> 0) THEN
                                                                  IF NOT GUIALLOWED THEN BEGIN
                                                                    "Standard Cost" := xRec."Standard Cost";
                                                                    EXIT;
                                                                  END ELSE
                                                                    IF NOT
                                                                       CONFIRM(
                                                                         Text020 +
                                                                         Text021 +
                                                                         Text022,FALSE,
                                                                         FIELDCAPTION("Standard Cost"))
                                                                    THEN BEGIN
                                                                      "Standard Cost" := xRec."Standard Cost";
                                                                      EXIT;
                                                                    END;

                                                                ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Standard Cost"));
                                                              END;

                                                   CaptionML=[DAN=Kostpris (standard);
                                                              ENU=Standard Cost];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 25  ;   ;Last Direct Cost    ;Decimal       ;CaptionML=[DAN=Sidste k�bspris;
                                                              ENU=Last Direct Cost];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 28  ;   ;Indirect Cost %     ;Decimal       ;OnValidate=BEGIN
                                                                ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Indirect Cost %"));
                                                              END;

                                                   CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 29  ;   ;Cost is Adjusted    ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Kostv�rdien er reguleret;
                                                              ENU=Cost is Adjusted];
                                                   Editable=No }
    { 30  ;   ;Allow Online Adjustment;Boolean    ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad onlineregulering;
                                                              ENU=Allow Online Adjustment];
                                                   Editable=No }
    { 31  ;   ;Vendor No.          ;Code20        ;TableRelation=Vendor;
                                                   OnValidate=BEGIN
                                                                IF (xRec."Vendor No." <> "Vendor No.") AND
                                                                   ("Vendor No." <> '')
                                                                THEN
                                                                  IF Vend.GET("Vendor No.") THEN
                                                                    "Lead Time Calculation" := Vend."Lead Time Calculation";
                                                              END;

                                                   ValidateTableRelation=Yes;
                                                   TestTableRelation=Yes;
                                                   CaptionML=[DAN=Leverand�rnr.;
                                                              ENU=Vendor No.] }
    { 32  ;   ;Vendor Item No.     ;Text20        ;CaptionML=[DAN=Leverand�rs varenr.;
                                                              ENU=Vendor Item No.] }
    { 33  ;   ;Lead Time Calculation;DateFormula  ;OnValidate=BEGIN
                                                                LeadTimeMgt.CheckLeadTimeIsNotNegative("Lead Time Calculation");
                                                              END;

                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Leveringstid;
                                                              ENU=Lead Time Calculation] }
    { 34  ;   ;Reorder Point       ;Decimal       ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Genbestillingspunkt;
                                                              ENU=Reorder Point];
                                                   DecimalPlaces=0:5 }
    { 35  ;   ;Maximum Inventory   ;Decimal       ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Maks. lagerbeholdning;
                                                              ENU=Maximum Inventory];
                                                   DecimalPlaces=0:5 }
    { 36  ;   ;Reorder Quantity    ;Decimal       ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Ordrekvantum;
                                                              ENU=Reorder Quantity];
                                                   DecimalPlaces=0:5 }
    { 37  ;   ;Alternative Item No.;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Alternativt varenr.;
                                                              ENU=Alternative Item No.] }
    { 38  ;   ;Unit List Price     ;Decimal       ;CaptionML=[DAN=Vejledende pris;
                                                              ENU=Unit List Price];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 39  ;   ;Duty Due %          ;Decimal       ;CaptionML=[DAN=Afgiftspct.;
                                                              ENU=Duty Due %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 40  ;   ;Duty Code           ;Code10        ;CaptionML=[DAN=Afgiftskode;
                                                              ENU=Duty Code] }
    { 41  ;   ;Gross Weight        ;Decimal       ;CaptionML=[DAN=Bruttov�gt;
                                                              ENU=Gross Weight];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 42  ;   ;Net Weight          ;Decimal       ;CaptionML=[DAN=Nettov�gt;
                                                              ENU=Net Weight];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 43  ;   ;Units per Parcel    ;Decimal       ;CaptionML=[DAN=Antal pr. kolli;
                                                              ENU=Units per Parcel];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 44  ;   ;Unit Volume         ;Decimal       ;CaptionML=[DAN=Rumfang;
                                                              ENU=Unit Volume];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 45  ;   ;Durability          ;Code10        ;CaptionML=[DAN=Holdbarhed;
                                                              ENU=Durability] }
    { 46  ;   ;Freight Type        ;Code10        ;CaptionML=[DAN=Fragtform;
                                                              ENU=Freight Type] }
    { 47  ;   ;Tariff No.          ;Code20        ;TableRelation="Tariff Number";
                                                   OnValidate=VAR
                                                                TariffNumber@1000 : Record 260;
                                                              BEGIN
                                                                IF "Tariff No." = '' THEN
                                                                  EXIT;

                                                                IF (NOT TariffNumber.WRITEPERMISSION) OR
                                                                   (NOT TariffNumber.READPERMISSION)
                                                                THEN
                                                                  EXIT;

                                                                IF TariffNumber.GET("Tariff No.") THEN
                                                                  EXIT;

                                                                TariffNumber.INIT;
                                                                TariffNumber."No." := "Tariff No.";
                                                                TariffNumber.INSERT;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Varekode;
                                                              ENU=Tariff No.] }
    { 48  ;   ;Duty Unit Conversion;Decimal       ;CaptionML=[DAN=Toldfaktor;
                                                              ENU=Duty Unit Conversion];
                                                   DecimalPlaces=0:5 }
    { 49  ;   ;Country/Region Purchased Code;Code10;
                                                   TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode for k�b;
                                                              ENU=Country/Region Purchased Code] }
    { 50  ;   ;Budget Quantity     ;Decimal       ;CaptionML=[DAN=Budget (antal);
                                                              ENU=Budget Quantity];
                                                   DecimalPlaces=0:5 }
    { 51  ;   ;Budgeted Amount     ;Decimal       ;CaptionML=[DAN=Budgetteret bel�b;
                                                              ENU=Budgeted Amount];
                                                   AutoFormatType=1 }
    { 52  ;   ;Budget Profit       ;Decimal       ;CaptionML=[DAN=Budget (avance);
                                                              ENU=Budget Profit];
                                                   AutoFormatType=1 }
    { 53  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Comment Line" WHERE (Table Name=CONST(Item),
                                                                                           No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 54  ;   ;Blocked             ;Boolean       ;OnValidate=BEGIN
                                                                IF NOT Blocked THEN
                                                                  "Block Reason" := '';
                                                              END;

                                                   CaptionML=[DAN=Sp�rret;
                                                              ENU=Blocked] }
    { 55  ;   ;Cost is Posted to G/L;Boolean      ;FieldClass=FlowField;
                                                   CalcFormula=-Exist("Post Value Entry to G/L" WHERE (Item No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bogf�rt kostpris;
                                                              ENU=Cost is Posted to G/L];
                                                   Editable=No }
    { 56  ;   ;Block Reason        ;Text250       ;OnValidate=BEGIN
                                                                TESTFIELD(Blocked,TRUE);
                                                              END;

                                                   CaptionML=[DAN=Blokerings�rsag;
                                                              ENU=Block Reason] }
    { 61  ;   ;Last DateTime Modified;DateTime    ;CaptionML=[DAN=Dato/klokkesl�t for seneste �ndring;
                                                              ENU=Last DateTime Modified];
                                                   Editable=No }
    { 62  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 63  ;   ;Last Time Modified  ;Time          ;CaptionML=[DAN=Sidst rettet kl.;
                                                              ENU=Last Time Modified];
                                                   Editable=No }
    { 64  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 65  ;   ;Global Dimension 1 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-filter;
                                                              ENU=Global Dimension 1 Filter];
                                                   CaptionClass='1,3,1' }
    { 66  ;   ;Global Dimension 2 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-filter;
                                                              ENU=Global Dimension 2 Filter];
                                                   CaptionClass='1,3,2' }
    { 67  ;   ;Location Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Location;
                                                   CaptionML=[DAN=Lokationsfilter;
                                                              ENU=Location Filter] }
    { 68  ;   ;Inventory           ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(No.),
                                                                                                       Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                       Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                       Location Code=FIELD(Location Filter),
                                                                                                       Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                       Variant Code=FIELD(Variant Filter),
                                                                                                       Lot No.=FIELD(Lot No. Filter),
                                                                                                       Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Lager;
                                                              ENU=Inventory];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 69  ;   ;Net Invoiced Qty.   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Item No.=FIELD(No.),
                                                                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Location Code=FIELD(Location Filter),
                                                                                                                  Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                  Variant Code=FIELD(Variant Filter),
                                                                                                                  Lot No.=FIELD(Lot No. Filter),
                                                                                                                  Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Faktureret beholdn.;
                                                              ENU=Net Invoiced Qty.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 70  ;   ;Net Change          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(No.),
                                                                                                       Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                       Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                       Location Code=FIELD(Location Filter),
                                                                                                       Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                       Variant Code=FIELD(Variant Filter),
                                                                                                       Lot No.=FIELD(Lot No. Filter),
                                                                                                       Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Bev�gelse;
                                                              ENU=Net Change];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 71  ;   ;Purchases (Qty.)    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Purchase),
                                                                                                                  Item No.=FIELD(No.),
                                                                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Location Code=FIELD(Location Filter),
                                                                                                                  Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                  Variant Code=FIELD(Variant Filter),
                                                                                                                  Posting Date=FIELD(Date Filter),
                                                                                                                  Lot No.=FIELD(Lot No. Filter),
                                                                                                                  Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=K�b (antal);
                                                              ENU=Purchases (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 72  ;   ;Sales (Qty.)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Value Entry"."Invoiced Quantity" WHERE (Item Ledger Entry Type=CONST(Sale),
                                                                                                             Item No.=FIELD(No.),
                                                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                             Location Code=FIELD(Location Filter),
                                                                                                             Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                             Variant Code=FIELD(Variant Filter),
                                                                                                             Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Salg (antal);
                                                              ENU=Sales (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 73  ;   ;Positive Adjmt. (Qty.);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Positive Adjmt.),
                                                                                                                  Item No.=FIELD(No.),
                                                                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Location Code=FIELD(Location Filter),
                                                                                                                  Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                  Variant Code=FIELD(Variant Filter),
                                                                                                                  Posting Date=FIELD(Date Filter),
                                                                                                                  Lot No.=FIELD(Lot No. Filter),
                                                                                                                  Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Opregulering (antal);
                                                              ENU=Positive Adjmt. (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 74  ;   ;Negative Adjmt. (Qty.);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Negative Adjmt.),
                                                                                                                   Item No.=FIELD(No.),
                                                                                                                   Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                   Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                   Location Code=FIELD(Location Filter),
                                                                                                                   Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                   Variant Code=FIELD(Variant Filter),
                                                                                                                   Posting Date=FIELD(Date Filter),
                                                                                                                   Lot No.=FIELD(Lot No. Filter),
                                                                                                                   Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Nedregulering (antal);
                                                              ENU=Negative Adjmt. (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 77  ;   ;Purchases (LCY)     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Purchase Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Purchase),
                                                                                                                   Item No.=FIELD(No.),
                                                                                                                   Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                   Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                   Location Code=FIELD(Location Filter),
                                                                                                                   Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                   Variant Code=FIELD(Variant Filter),
                                                                                                                   Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=K�b (RV);
                                                              ENU=Purchases (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 78  ;   ;Sales (LCY)         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Sales Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Sale),
                                                                                                                Item No.=FIELD(No.),
                                                                                                                Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                Location Code=FIELD(Location Filter),
                                                                                                                Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                Variant Code=FIELD(Variant Filter),
                                                                                                                Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Salg (RV);
                                                              ENU=Sales (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 79  ;   ;Positive Adjmt. (LCY);Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Positive Adjmt.),
                                                                                                               Item No.=FIELD(No.),
                                                                                                               Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                               Location Code=FIELD(Location Filter),
                                                                                                               Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                               Variant Code=FIELD(Variant Filter),
                                                                                                               Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Opregulering (bel�b);
                                                              ENU=Positive Adjmt. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 80  ;   ;Negative Adjmt. (LCY);Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Negative Adjmt.),
                                                                                                               Item No.=FIELD(No.),
                                                                                                               Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                               Location Code=FIELD(Location Filter),
                                                                                                               Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                               Variant Code=FIELD(Variant Filter),
                                                                                                               Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Nedregulering (bel�b);
                                                              ENU=Negative Adjmt. (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 83  ;   ;COGS (LCY)          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Sale),
                                                                                                                Item No.=FIELD(No.),
                                                                                                                Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                Location Code=FIELD(Location Filter),
                                                                                                                Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                Variant Code=FIELD(Variant Filter),
                                                                                                                Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Vareforbrug (RV);
                                                              ENU=COGS (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 84  ;   ;Qty. on Purch. Order;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Order),
                                                                                                                    Type=CONST(Item),
                                                                                                                    No.=FIELD(No.),
                                                                                                                    Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                    Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                    Location Code=FIELD(Location Filter),
                                                                                                                    Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                    Variant Code=FIELD(Variant Filter),
                                                                                                                    Expected Receipt Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Antal i k�bsordre;
                                                              ENU=Qty. on Purch. Order];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 85  ;   ;Qty. on Sales Order ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Order),
                                                                                                                 Type=CONST(Item),
                                                                                                                 No.=FIELD(No.),
                                                                                                                 Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                 Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                 Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                                                 Shipment Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Antal i salgsordre;
                                                              ENU=Qty. on Sales Order];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 87  ;   ;Price Includes VAT  ;Boolean       ;OnValidate=VAR
                                                                VATPostingSetup@1000 : Record 325;
                                                                SalesSetup@1001 : Record 311;
                                                              BEGIN
                                                                IF "Price Includes VAT" THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  IF SalesSetup."VAT Bus. Posting Gr. (Price)" <> '' THEN
                                                                    "VAT Bus. Posting Gr. (Price)" := SalesSetup."VAT Bus. Posting Gr. (Price)";
                                                                  VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group");
                                                                END;
                                                                VALIDATE("Price/Profit Calculation");
                                                              END;

                                                   CaptionML=[DAN=Salgspris inkl. moms;
                                                              ENU=Price Includes VAT] }
    { 89  ;   ;Drop Shipment Filter;Boolean       ;FieldClass=FlowFilter;
                                                   AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Direkte lev. filter;
                                                              ENU=Drop Shipment Filter] }
    { 90  ;   ;VAT Bus. Posting Gr. (Price);Code20;TableRelation="VAT Business Posting Group";
                                                   OnValidate=BEGIN
                                                                VALIDATE("Price/Profit Calculation");
                                                              END;

                                                   CaptionML=[DAN=Momsvirks.bogf.gruppe (pris);
                                                              ENU=VAT Bus. Posting Gr. (Price)] }
    { 91  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   OnValidate=BEGIN
                                                                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN BEGIN
                                                                  IF CurrFieldNo <> 0 THEN
                                                                    IF ProdOrderExist THEN
                                                                      IF NOT CONFIRM(
                                                                           Text024 +
                                                                           Text022,FALSE,
                                                                           FIELDCAPTION("Gen. Prod. Posting Group"))
                                                                      THEN BEGIN
                                                                        "Gen. Prod. Posting Group" := xRec."Gen. Prod. Posting Group";
                                                                        EXIT;
                                                                      END;

                                                                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                                                                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                                                                END;

                                                                VALIDATE("Price/Profit Calculation");
                                                              END;

                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 92  ;   ;Picture             ;MediaSet      ;CaptionML=[DAN=Billede;
                                                              ENU=Picture] }
    { 93  ;   ;Transferred (Qty.)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Ledger Entry"."Invoiced Quantity" WHERE (Entry Type=CONST(Transfer),
                                                                                                                  Item No.=FIELD(No.),
                                                                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Location Code=FIELD(Location Filter),
                                                                                                                  Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                  Variant Code=FIELD(Variant Filter),
                                                                                                                  Posting Date=FIELD(Date Filter),
                                                                                                                  Lot No.=FIELD(Lot No. Filter),
                                                                                                                  Serial No.=FIELD(Serial No. Filter)));
                                                   CaptionML=[DAN=Overf�rt (antal);
                                                              ENU=Transferred (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 94  ;   ;Transferred (LCY)   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Sales Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Transfer),
                                                                                                                Item No.=FIELD(No.),
                                                                                                                Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                Location Code=FIELD(Location Filter),
                                                                                                                Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                Variant Code=FIELD(Variant Filter),
                                                                                                                Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Overf�rt (RV);
                                                              ENU=Transferred (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 95  ;   ;Country/Region of Origin Code;Code10;
                                                   TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode for oprindelse;
                                                              ENU=Country/Region of Origin Code] }
    { 96  ;   ;Automatic Ext. Texts;Boolean       ;CaptionML=[DAN=Automatisk udv. tekster;
                                                              ENU=Automatic Ext. Texts] }
    { 97  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 98  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   OnValidate=BEGIN
                                                                UpdateTaxGroupId;
                                                              END;

                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 99  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   OnValidate=BEGIN
                                                                VALIDATE("Price/Profit Calculation");
                                                              END;

                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 100 ;   ;Reserve             ;Option        ;InitValue=Optional;
                                                   OnValidate=BEGIN
                                                                IF Reserve <> Reserve::Never THEN
                                                                  TESTFIELD(Type,Type::Inventory);
                                                              END;

                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Reserver;
                                                              ENU=Reserve];
                                                   OptionCaptionML=[DAN=Aldrig,Eventuelt,Altid;
                                                                    ENU=Never,Optional,Always];
                                                   OptionString=Never,Optional,Always }
    { 101 ;   ;Reserved Qty. on Inventory;Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                Source Type=CONST(32),
                                                                                                                Source Subtype=CONST(0),
                                                                                                                Reservation Status=CONST(Reservation),
                                                                                                                Serial No.=FIELD(Serial No. Filter),
                                                                                                                Lot No.=FIELD(Lot No. Filter),
                                                                                                                Location Code=FIELD(Location Filter),
                                                                                                                Variant Code=FIELD(Variant Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Reserv. antal p� lager;
                                                              ENU=Reserved Qty. on Inventory];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 102 ;   ;Reserved Qty. on Purch. Orders;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                Source Type=CONST(39),
                                                                                                                Source Subtype=CONST(1),
                                                                                                                Reservation Status=CONST(Reservation),
                                                                                                                Location Code=FIELD(Location Filter),
                                                                                                                Variant Code=FIELD(Variant Filter),
                                                                                                                Expected Receipt Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Reserv. antal i k�bsordre;
                                                              ENU=Reserved Qty. on Purch. Orders];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 103 ;   ;Reserved Qty. on Sales Orders;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                 Source Type=CONST(37),
                                                                                                                 Source Subtype=CONST(1),
                                                                                                                 Reservation Status=CONST(Reservation),
                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                                                 Shipment Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Reserv. antal i salgsordre;
                                                              ENU=Reserved Qty. on Sales Orders];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 105 ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 106 ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 107 ;   ;Res. Qty. on Outbound Transfer;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                 Source Type=CONST(5741),
                                                                                                                 Source Subtype=CONST(0),
                                                                                                                 Reservation Status=CONST(Reservation),
                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                                                 Shipment Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 5740=R;
                                                   CaptionML=[DAN=Reserv. antal i flytning ud;
                                                              ENU=Res. Qty. on Outbound Transfer];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 108 ;   ;Res. Qty. on Inbound Transfer;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                Source Type=CONST(5741),
                                                                                                                Source Subtype=CONST(1),
                                                                                                                Reservation Status=CONST(Reservation),
                                                                                                                Location Code=FIELD(Location Filter),
                                                                                                                Variant Code=FIELD(Variant Filter),
                                                                                                                Expected Receipt Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 5740=R;
                                                   CaptionML=[DAN=Reserv. antal i flytning ind;
                                                              ENU=Res. Qty. on Inbound Transfer];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 109 ;   ;Res. Qty. on Sales Returns;Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                Source Type=CONST(37),
                                                                                                                Source Subtype=CONST(5),
                                                                                                                Reservation Status=CONST(Reservation),
                                                                                                                Location Code=FIELD(Location Filter),
                                                                                                                Variant Code=FIELD(Variant Filter),
                                                                                                                Shipment Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Reserv. antal i salgsreturneringer;
                                                              ENU=Res. Qty. on Sales Returns];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 110 ;   ;Res. Qty. on Purch. Returns;Decimal;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                 Source Type=CONST(39),
                                                                                                                 Source Subtype=CONST(5),
                                                                                                                 Reservation Status=CONST(Reservation),
                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                                                 Expected Receipt Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Reserv. antal i k�bsreturneringer;
                                                              ENU=Res. Qty. on Purch. Returns];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 120 ;   ;Stockout Warning    ;Option        ;CaptionML=[DAN=Beholdningsadvarsel;
                                                              ENU=Stockout Warning];
                                                   OptionCaptionML=[DAN=Standard,Nej,Ja;
                                                                    ENU=Default,No,Yes];
                                                   OptionString=Default,No,Yes }
    { 121 ;   ;Prevent Negative Inventory;Option  ;CaptionML=[DAN=Forebyg negativt lager;
                                                              ENU=Prevent Negative Inventory];
                                                   OptionCaptionML=[DAN=Standard,Nej,Ja;
                                                                    ENU=Default,No,Yes];
                                                   OptionString=Default,No,Yes }
    { 200 ;   ;Cost of Open Production Orders;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Line"."Cost Amount" WHERE (Status=FILTER(Planned|Firm Planned|Released),
                                                                                                           Item No.=FIELD(No.)));
                                                   CaptionML=[DAN=Kostpris for �bne produktionsordrer;
                                                              ENU=Cost of Open Production Orders] }
    { 521 ;   ;Application Wksh. User ID;Code128  ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Programworkshopbruger-id;
                                                              ENU=Application Wksh. User ID] }
    { 910 ;   ;Assembly Policy     ;Option        ;OnValidate=BEGIN
                                                                IF "Assembly Policy" = "Assembly Policy"::"Assemble-to-Order" THEN
                                                                  TESTFIELD("Replenishment System","Replenishment System"::Assembly);
                                                                IF Type = Type::Service THEN
                                                                  TESTFIELD("Assembly Policy","Assembly Policy"::"Assemble-to-Stock");
                                                              END;

                                                   AccessByPermission=TableData 90=R;
                                                   CaptionML=[DAN=Montagepolitik;
                                                              ENU=Assembly Policy];
                                                   OptionCaptionML=[DAN=Montage til lager,Montage efter ordre;
                                                                    ENU=Assemble-to-Stock,Assemble-to-Order];
                                                   OptionString=Assemble-to-Stock,Assemble-to-Order }
    { 929 ;   ;Res. Qty. on Assembly Order;Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                Source Type=CONST(900),
                                                                                                                Source Subtype=CONST(1),
                                                                                                                Reservation Status=CONST(Reservation),
                                                                                                                Location Code=FIELD(Location Filter),
                                                                                                                Variant Code=FIELD(Variant Filter),
                                                                                                                Expected Receipt Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 90=R;
                                                   CaptionML=[DAN=Res. mgd. p� montageordre;
                                                              ENU=Res. Qty. on Assembly Order];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 930 ;   ;Res. Qty. on  Asm. Comp.;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                 Source Type=CONST(901),
                                                                                                                 Source Subtype=CONST(1),
                                                                                                                 Reservation Status=CONST(Reservation),
                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                                                 Shipment Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 90=R;
                                                   CaptionML=[DAN=Res. mgd. p� mont.komp.;
                                                              ENU=Res. Qty. on  Asm. Comp.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 977 ;   ;Qty. on Assembly Order;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Assembly Header"."Remaining Quantity (Base)" WHERE (Document Type=CONST(Order),
                                                                                                                        Item No.=FIELD(No.),
                                                                                                                        Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                        Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                        Location Code=FIELD(Location Filter),
                                                                                                                        Variant Code=FIELD(Variant Filter),
                                                                                                                        Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Mgd. p� montageordre;
                                                              ENU=Qty. on Assembly Order];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 978 ;   ;Qty. on Asm. Component;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Assembly Line"."Remaining Quantity (Base)" WHERE (Document Type=CONST(Order),
                                                                                                                      Type=CONST(Item),
                                                                                                                      No.=FIELD(No.),
                                                                                                                      Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                      Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                      Location Code=FIELD(Location Filter),
                                                                                                                      Variant Code=FIELD(Variant Filter),
                                                                                                                      Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Mgd. p� mont.komponent;
                                                              ENU=Qty. on Asm. Component];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 1001;   ;Qty. on Job Order   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Order),
                                                                                                                      Type=CONST(Item),
                                                                                                                      No.=FIELD(No.),
                                                                                                                      Location Code=FIELD(Location Filter),
                                                                                                                      Variant Code=FIELD(Variant Filter),
                                                                                                                      Planning Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Mgd. p� jobordre;
                                                              ENU=Qty. on Job Order];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 1002;   ;Res. Qty. on Job Order;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                 Source Type=CONST(1003),
                                                                                                                 Source Subtype=CONST(2),
                                                                                                                 Reservation Status=CONST(Reservation),
                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                                                 Shipment Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 167=R;
                                                   CaptionML=[DAN=Res. mgd. p� jobordre;
                                                              ENU=Res. Qty. on Job Order];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 1217;   ;GTIN                ;Code14        ;CaptionML=[DAN=GTIN;
                                                              ENU=GTIN];
                                                   Numeric=Yes }
    { 1700;   ;Default Deferral Template Code;Code10;
                                                   TableRelation="Deferral Template"."Deferral Code";
                                                   CaptionML=[DAN=Standardskabelonkode for periodisering;
                                                              ENU=Default Deferral Template Code] }
    { 5400;   ;Low-Level Code      ;Integer       ;CaptionML=[DAN=Laveste-niveau-kode;
                                                              ENU=Low-Level Code];
                                                   Editable=No }
    { 5401;   ;Lot Size            ;Decimal       ;AccessByPermission=TableData 5405=R;
                                                   CaptionML=[DAN=Lotst�rrelse;
                                                              ENU=Lot Size];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 5402;   ;Serial Nos.         ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "Serial Nos." <> '' THEN
                                                                  TESTFIELD("Item Tracking Code");
                                                              END;

                                                   CaptionML=[DAN=Serienr.;
                                                              ENU=Serial Nos.] }
    { 5403;   ;Last Unit Cost Calc. Date;Date     ;CaptionML=[DAN=Sidste kostprisberegn.dato;
                                                              ENU=Last Unit Cost Calc. Date];
                                                   Editable=No }
    { 5404;   ;Rolled-up Material Cost;Decimal    ;CaptionML=[DAN=Akkum. materialekostpris;
                                                              ENU=Rolled-up Material Cost];
                                                   DecimalPlaces=2:5;
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 5405;   ;Rolled-up Capacity Cost;Decimal    ;CaptionML=[DAN=Akkum. kapacitetskostpris;
                                                              ENU=Rolled-up Capacity Cost];
                                                   DecimalPlaces=2:5;
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 5407;   ;Scrap %             ;Decimal       ;AccessByPermission=TableData 5405=R;
                                                   CaptionML=[DAN=Spildpct.;
                                                              ENU=Scrap %];
                                                   DecimalPlaces=0:2;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 5409;   ;Inventory Value Zero;Boolean       ;OnValidate=BEGIN
                                                                CheckForProductionOutput("No.");
                                                              END;

                                                   CaptionML=[DAN=Lagerv�rdi - nul;
                                                              ENU=Inventory Value Zero] }
    { 5410;   ;Discrete Order Quantity;Integer    ;CaptionML=[DAN=Separat ordre (antal);
                                                              ENU=Discrete Order Quantity];
                                                   MinValue=0 }
    { 5411;   ;Minimum Order Quantity;Decimal     ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Min. ordrest�rrelse;
                                                              ENU=Minimum Order Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 5412;   ;Maximum Order Quantity;Decimal     ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Maks. ordrest�rrelse;
                                                              ENU=Maximum Order Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 5413;   ;Safety Stock Quantity;Decimal      ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Sikkerhedslager;
                                                              ENU=Safety Stock Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 5414;   ;Order Multiple      ;Decimal       ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Oprundingsfaktor;
                                                              ENU=Order Multiple];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 5415;   ;Safety Lead Time    ;DateFormula   ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Sikkerhedstid;
                                                              ENU=Safety Lead Time] }
    { 5417;   ;Flushing Method     ;Option        ;AccessByPermission=TableData 5405=R;
                                                   CaptionML=[DAN=Tr�kmetode;
                                                              ENU=Flushing Method];
                                                   OptionCaptionML=[DAN=Manuelt,Forl�ns,Bagl�ns,Pluk + Forl�ns,Pluk + Bagl�ns;
                                                                    ENU=Manual,Forward,Backward,Pick + Forward,Pick + Backward];
                                                   OptionString=Manual,Forward,Backward,Pick + Forward,Pick + Backward }
    { 5419;   ;Replenishment System;Option        ;OnValidate=BEGIN
                                                                IF "Replenishment System" <> "Replenishment System"::Assembly THEN
                                                                  TESTFIELD("Assembly Policy","Assembly Policy"::"Assemble-to-Stock");
                                                                IF "Replenishment System" <> "Replenishment System"::Purchase THEN
                                                                  TESTFIELD(Type,Type::Inventory);
                                                              END;

                                                   AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Genbestillingssystem;
                                                              ENU=Replenishment System];
                                                   OptionCaptionML=[DAN=K�b,Prod. Ordre,,Montage;
                                                                    ENU=Purchase,Prod. Order,,Assembly];
                                                   OptionString=Purchase,Prod. Order,,Assembly }
    { 5420;   ;Scheduled Receipt (Qty.);Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=FILTER(Firm Planned|Released),
                                                                                                                     Item No.=FIELD(No.),
                                                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Location Code=FIELD(Location Filter),
                                                                                                                     Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Fastlagt tilgang (antal);
                                                              ENU=Scheduled Receipt (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5421;   ;Scheduled Need (Qty.);Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Component"."Remaining Qty. (Base)" WHERE (Status=FILTER(Planned..Released),
                                                                                                                          Item No.=FIELD(No.),
                                                                                                                          Variant Code=FIELD(Variant Filter),
                                                                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                          Location Code=FIELD(Location Filter),
                                                                                                                          Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Planlagt behov (antal);
                                                              ENU=Scheduled Need (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5422;   ;Rounding Precision  ;Decimal       ;InitValue=1;
                                                   OnValidate=BEGIN
                                                                IF "Rounding Precision" <= 0 THEN
                                                                  FIELDERROR("Rounding Precision",Text027);
                                                              END;

                                                   AccessByPermission=TableData 5405=R;
                                                   CaptionML=[DAN=Afrundingspr�cision;
                                                              ENU=Rounding Precision];
                                                   DecimalPlaces=0:5 }
    { 5423;   ;Bin Filter          ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Filter));
                                                   CaptionML=[DAN=Placeringsfilter;
                                                              ENU=Bin Filter] }
    { 5424;   ;Variant Filter      ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   CaptionML=[DAN=Variantfilter;
                                                              ENU=Variant Filter] }
    { 5425;   ;Sales Unit of Measure;Code10       ;TableRelation=IF (No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE "Unit of Measure";
                                                   CaptionML=[DAN=Salgsenhed;
                                                              ENU=Sales Unit of Measure] }
    { 5426;   ;Purch. Unit of Measure;Code10      ;TableRelation=IF (No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE "Unit of Measure";
                                                   CaptionML=[DAN=K�bsenhed;
                                                              ENU=Purch. Unit of Measure] }
    { 5428;   ;Time Bucket         ;DateFormula   ;OnValidate=BEGIN
                                                                CalendarMgt.CheckDateFormulaPositive("Time Bucket");
                                                              END;

                                                   AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Interval;
                                                              ENU=Time Bucket] }
    { 5429;   ;Reserved Qty. on Prod. Order;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                Source Type=CONST(5406),
                                                                                                                Source Subtype=FILTER(1..3),
                                                                                                                Reservation Status=CONST(Reservation),
                                                                                                                Location Code=FIELD(Location Filter),
                                                                                                                Variant Code=FIELD(Variant Filter),
                                                                                                                Expected Receipt Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 5405=R;
                                                   CaptionML=[DAN=Reserveret antal i prod.ordre;
                                                              ENU=Reserved Qty. on Prod. Order];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5430;   ;Res. Qty. on Prod. Order Comp.;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                 Source Type=CONST(5407),
                                                                                                                 Source Subtype=FILTER(1..3),
                                                                                                                 Reservation Status=CONST(Reservation),
                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                                                 Shipment Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 5405=R;
                                                   CaptionML=[DAN=Reserv. antal i prod.o.komp.;
                                                              ENU=Res. Qty. on Prod. Order Comp.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5431;   ;Res. Qty. on Req. Line;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                Source Type=CONST(246),
                                                                                                                Source Subtype=FILTER(0),
                                                                                                                Reservation Status=CONST(Reservation),
                                                                                                                Location Code=FIELD(Location Filter),
                                                                                                                Variant Code=FIELD(Variant Filter),
                                                                                                                Expected Receipt Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Reserv. antal p� disp.linje;
                                                              ENU=Res. Qty. on Req. Line];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5440;   ;Reordering Policy   ;Option        ;OnValidate=BEGIN
                                                                "Include Inventory" :=
                                                                  "Reordering Policy" IN ["Reordering Policy"::"Lot-for-Lot",
                                                                                          "Reordering Policy"::"Maximum Qty.",
                                                                                          "Reordering Policy"::"Fixed Reorder Qty."];

                                                                IF "Reordering Policy" <> "Reordering Policy"::" " THEN
                                                                  TESTFIELD(Type,Type::Inventory);
                                                              END;

                                                   AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Genbestillingsmetode;
                                                              ENU=Reordering Policy];
                                                   OptionCaptionML=[DAN=" ,Fast genbestil.antal,Maks. antal,Ordre,Lot-for-lot";
                                                                    ENU=" ,Fixed Reorder Qty.,Maximum Qty.,Order,Lot-for-Lot"];
                                                   OptionString=[ ,Fixed Reorder Qty.,Maximum Qty.,Order,Lot-for-Lot] }
    { 5441;   ;Include Inventory   ;Boolean       ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Medtag lager;
                                                              ENU=Include Inventory] }
    { 5442;   ;Manufacturing Policy;Option        ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Produktionsmetode;
                                                              ENU=Manufacturing Policy];
                                                   OptionCaptionML=[DAN=Fremstil-til-lager,Fremstil-til-ordre;
                                                                    ENU=Make-to-Stock,Make-to-Order];
                                                   OptionString=Make-to-Stock,Make-to-Order }
    { 5443;   ;Rescheduling Period ;DateFormula   ;OnValidate=BEGIN
                                                                CalendarMgt.CheckDateFormulaPositive("Rescheduling Period");
                                                              END;

                                                   AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=�ndringsperiode;
                                                              ENU=Rescheduling Period] }
    { 5444;   ;Lot Accumulation Period;DateFormula;OnValidate=BEGIN
                                                                CalendarMgt.CheckDateFormulaPositive("Lot Accumulation Period");
                                                              END;

                                                   AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Akkumuleringsperiode for lot;
                                                              ENU=Lot Accumulation Period] }
    { 5445;   ;Dampener Period     ;DateFormula   ;OnValidate=BEGIN
                                                                CalendarMgt.CheckDateFormulaPositive("Dampener Period");
                                                              END;

                                                   AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Bufferperiode;
                                                              ENU=Dampener Period] }
    { 5446;   ;Dampener Quantity   ;Decimal       ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Bufferm�ngde;
                                                              ENU=Dampener Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 5447;   ;Overflow Level      ;Decimal       ;AccessByPermission=TableData 244=R;
                                                   CaptionML=[DAN=Overl�bsniveau;
                                                              ENU=Overflow Level];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 5449;   ;Planning Transfer Ship. (Qty).;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Requisition Line"."Quantity (Base)" WHERE (Replenishment System=CONST(Transfer),
                                                                                                               Type=CONST(Item),
                                                                                                               No.=FIELD(No.),
                                                                                                               Variant Code=FIELD(Variant Filter),
                                                                                                               Transfer-from Code=FIELD(Location Filter),
                                                                                                               Transfer Shipment Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Overflytningsleverance for planl�gning (antal);
                                                              ENU=Planning Transfer Ship. (Qty).];
                                                   Editable=No }
    { 5450;   ;Planning Worksheet (Qty.);Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Requisition Line"."Quantity (Base)" WHERE (Planning Line Origin=CONST(Planning),
                                                                                                               Type=CONST(Item),
                                                                                                               No.=FIELD(No.),
                                                                                                               Location Code=FIELD(Location Filter),
                                                                                                               Variant Code=FIELD(Variant Filter),
                                                                                                               Due Date=FIELD(Date Filter),
                                                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
                                                   CaptionML=[DAN=Planl�gningskladde (antal);
                                                              ENU=Planning Worksheet (Qty.)];
                                                   Editable=No }
    { 5700;   ;Stockkeeping Unit Exists;Boolean   ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Stockkeeping Unit" WHERE (Item No.=FIELD(No.)));
                                                   CaptionML=[DAN=Lagervare findes;
                                                              ENU=Stockkeeping Unit Exists];
                                                   Editable=No }
    { 5701;   ;Manufacturer Code   ;Code10        ;TableRelation=Manufacturer;
                                                   CaptionML=[DAN=Producentkode;
                                                              ENU=Manufacturer Code] }
    { 5702;   ;Item Category Code  ;Code20        ;TableRelation="Item Category";
                                                   OnValidate=VAR
                                                                ItemAttributeManagement@1000 : Codeunit 7500;
                                                              BEGIN
                                                                ItemAttributeManagement.InheritAttributesFromItemCategory(Rec,"Item Category Code",xRec."Item Category Code");
                                                              END;

                                                   CaptionML=[DAN=Varekategorikode;
                                                              ENU=Item Category Code] }
    { 5703;   ;Created From Nonstock Item;Boolean ;AccessByPermission=TableData 5718=R;
                                                   CaptionML=[DAN=Oprettet fra katalogvare;
                                                              ENU=Created From Nonstock Item];
                                                   Editable=No }
    { 5704;   ;Product Group Code  ;Code10        ;TableRelation="Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
                                                   ValidateTableRelation=No;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Product Groups became first level children of Item Categories.;
                                                   CaptionML=[DAN=Produktgruppekode;
                                                              ENU=Product Group Code] }
    { 5706;   ;Substitutes Exist   ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Item Substitution" WHERE (Type=CONST(Item),
                                                                                                No.=FIELD(No.)));
                                                   CaptionML=[DAN=Erstatning findes;
                                                              ENU=Substitutes Exist];
                                                   Editable=No }
    { 5707;   ;Qty. in Transit     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Transfer Line"."Qty. in Transit (Base)" WHERE (Derived From Line No.=CONST(0),
                                                                                                                   Item No.=FIELD(No.),
                                                                                                                   Transfer-to Code=FIELD(Location Filter),
                                                                                                                   Variant Code=FIELD(Variant Filter),
                                                                                                                   Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                   Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                   Receipt Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Antal i transit;
                                                              ENU=Qty. in Transit];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5708;   ;Trans. Ord. Receipt (Qty.);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Transfer Line"."Outstanding Qty. (Base)" WHERE (Derived From Line No.=CONST(0),
                                                                                                                    Item No.=FIELD(No.),
                                                                                                                    Transfer-to Code=FIELD(Location Filter),
                                                                                                                    Variant Code=FIELD(Variant Filter),
                                                                                                                    Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                    Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                    Receipt Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Overfly.ordremodt. (antal);
                                                              ENU=Trans. Ord. Receipt (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5709;   ;Trans. Ord. Shipment (Qty.);Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Transfer Line"."Outstanding Qty. (Base)" WHERE (Derived From Line No.=CONST(0),
                                                                                                                    Item No.=FIELD(No.),
                                                                                                                    Transfer-from Code=FIELD(Location Filter),
                                                                                                                    Variant Code=FIELD(Variant Filter),
                                                                                                                    Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                    Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                    Shipment Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Overfly.ordrelev. (antal);
                                                              ENU=Trans. Ord. Shipment (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5776;   ;Qty. Assigned to ship;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                              Location Code=FIELD(Location Filter),
                                                                                                                              Variant Code=FIELD(Variant Filter),
                                                                                                                              Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Antal tildelt til levering;
                                                              ENU=Qty. Assigned to ship];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5777;   ;Qty. Picked         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Warehouse Shipment Line"."Qty. Picked (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                         Location Code=FIELD(Location Filter),
                                                                                                                         Variant Code=FIELD(Variant Filter),
                                                                                                                         Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Plukket antal;
                                                              ENU=Qty. Picked];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5900;   ;Service Item Group  ;Code10        ;TableRelation="Service Item Group".Code;
                                                   OnValidate=VAR
                                                                ResSkill@1000 : Record 5956;
                                                              BEGIN
                                                                IF xRec."Service Item Group" <> "Service Item Group" THEN BEGIN
                                                                  IF NOT ResSkillMgt.ChangeRelationWithGroup(
                                                                       ResSkill.Type::Item,
                                                                       "No.",
                                                                       ResSkill.Type::"Service Item Group",
                                                                       "Service Item Group",
                                                                       xRec."Service Item Group")
                                                                  THEN
                                                                    "Service Item Group" := xRec."Service Item Group";
                                                                END ELSE
                                                                  ResSkillMgt.RevalidateRelation(
                                                                    ResSkill.Type::Item,
                                                                    "No.",
                                                                    ResSkill.Type::"Service Item Group",
                                                                    "Service Item Group")
                                                              END;

                                                   CaptionML=[DAN=Serviceartikelgruppe;
                                                              ENU=Service Item Group] }
    { 5901;   ;Qty. on Service Order;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Order),
                                                                                                                   Type=CONST(Item),
                                                                                                                   No.=FIELD(No.),
                                                                                                                   Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                   Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                   Location Code=FIELD(Location Filter),
                                                                                                                   Variant Code=FIELD(Variant Filter),
                                                                                                                   Needed by Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Antal p� serviceordre;
                                                              ENU=Qty. on Service Order];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5902;   ;Res. Qty. on Service Orders;Decimal;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                 Source Type=CONST(5902),
                                                                                                                 Source Subtype=CONST(1),
                                                                                                                 Reservation Status=CONST(Reservation),
                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                                                 Shipment Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 5900=R;
                                                   CaptionML=[DAN=Antal res. til serviceordre;
                                                              ENU=Res. Qty. on Service Orders];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 6500;   ;Item Tracking Code  ;Code10        ;TableRelation="Item Tracking Code";
                                                   OnValidate=BEGIN
                                                                IF "Item Tracking Code" <> '' THEN
                                                                  TESTFIELD(Type,Type::Inventory);
                                                                IF "Item Tracking Code" = xRec."Item Tracking Code" THEN
                                                                  EXIT;

                                                                IF NOT ItemTrackingCode.GET("Item Tracking Code") THEN
                                                                  CLEAR(ItemTrackingCode);

                                                                IF NOT ItemTrackingCode2.GET(xRec."Item Tracking Code") THEN
                                                                  CLEAR(ItemTrackingCode2);

                                                                IF (ItemTrackingCode."SN Specific Tracking" <> ItemTrackingCode2."SN Specific Tracking") OR
                                                                   (ItemTrackingCode."Lot Specific Tracking" <> ItemTrackingCode2."Lot Specific Tracking")
                                                                THEN
                                                                  TestNoEntriesExist(FIELDCAPTION("Item Tracking Code"));

                                                                IF "Costing Method" = "Costing Method"::Specific THEN BEGIN
                                                                  TestNoEntriesExist(FIELDCAPTION("Item Tracking Code"));

                                                                  TESTFIELD("Item Tracking Code");

                                                                  ItemTrackingCode.GET("Item Tracking Code");
                                                                  IF NOT ItemTrackingCode."SN Specific Tracking" THEN
                                                                    ERROR(
                                                                      Text018,
                                                                      ItemTrackingCode.FIELDCAPTION("SN Specific Tracking"),
                                                                      FORMAT(TRUE),ItemTrackingCode.TABLECAPTION,ItemTrackingCode.Code,
                                                                      FIELDCAPTION("Costing Method"),"Costing Method");
                                                                END;

                                                                TestNoOpenDocumentsWithTrackingExist;
                                                              END;

                                                   CaptionML=[DAN=Varesporingskode;
                                                              ENU=Item Tracking Code] }
    { 6501;   ;Lot Nos.            ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "Lot Nos." <> '' THEN
                                                                  TESTFIELD("Item Tracking Code");
                                                              END;

                                                   CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot Nos.] }
    { 6502;   ;Expiration Calculation;DateFormula ;CaptionML=[DAN=Udl�bsberegning;
                                                              ENU=Expiration Calculation] }
    { 6503;   ;Lot No. Filter      ;Code20        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Lotnr.filter;
                                                              ENU=Lot No. Filter] }
    { 6504;   ;Serial No. Filter   ;Code20        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Serienr.filter;
                                                              ENU=Serial No. Filter] }
    { 6650;   ;Qty. on Purch. Return;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Return Order),
                                                                                                                    Type=CONST(Item),
                                                                                                                    No.=FIELD(No.),
                                                                                                                    Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                    Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                    Location Code=FIELD(Location Filter),
                                                                                                                    Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                    Variant Code=FIELD(Variant Filter),
                                                                                                                    Expected Receipt Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Antal i k�bsreturnering;
                                                              ENU=Qty. on Purch. Return];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 6660;   ;Qty. on Sales Return;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Outstanding Qty. (Base)" WHERE (Document Type=CONST(Return Order),
                                                                                                                 Type=CONST(Item),
                                                                                                                 No.=FIELD(No.),
                                                                                                                 Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                 Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                 Drop Shipment=FIELD(Drop Shipment Filter),
                                                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                                                 Shipment Date=FIELD(Date Filter)));
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Antal i salgsreturnering;
                                                              ENU=Qty. on Sales Return];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 7171;   ;No. of Substitutes  ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Item Substitution" WHERE (Type=CONST(Item),
                                                                                                No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal erstatninger;
                                                              ENU=No. of Substitutes];
                                                   Editable=No }
    { 7300;   ;Warehouse Class Code;Code10        ;TableRelation="Warehouse Class";
                                                   CaptionML=[DAN=Lagerklassekode;
                                                              ENU=Warehouse Class Code] }
    { 7301;   ;Special Equipment Code;Code10      ;TableRelation="Special Equipment";
                                                   CaptionML=[DAN=Specialudstyrskode;
                                                              ENU=Special Equipment Code] }
    { 7302;   ;Put-away Template Code;Code10      ;TableRelation="Put-away Template Header";
                                                   CaptionML=[DAN=L�g-p�-lager-skabelonkode;
                                                              ENU=Put-away Template Code] }
    { 7307;   ;Put-away Unit of Measure Code;Code10;
                                                   TableRelation=IF (No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE "Unit of Measure";
                                                   AccessByPermission=TableData 7340=R;
                                                   CaptionML=[DAN=L�g-p�-lager-enhedskode;
                                                              ENU=Put-away Unit of Measure Code] }
    { 7380;   ;Phys Invt Counting Period Code;Code10;
                                                   TableRelation="Phys. Invt. Counting Period";
                                                   OnValidate=VAR
                                                                PhysInvtCountPeriod@1000 : Record 7381;
                                                                PhysInvtCountPeriodMgt@1001 : Codeunit 7380;
                                                              BEGIN
                                                                IF "Phys Invt Counting Period Code" <> '' THEN BEGIN
                                                                  PhysInvtCountPeriod.GET("Phys Invt Counting Period Code");
                                                                  PhysInvtCountPeriod.TESTFIELD("Count Frequency per Year");
                                                                  IF "Phys Invt Counting Period Code" <> xRec."Phys Invt Counting Period Code" THEN BEGIN
                                                                    IF CurrFieldNo <> 0 THEN
                                                                      IF NOT CONFIRM(
                                                                           Text7380,
                                                                           FALSE,
                                                                           FIELDCAPTION("Phys Invt Counting Period Code"),
                                                                           FIELDCAPTION("Next Counting Start Date"),
                                                                           FIELDCAPTION("Next Counting End Date"))
                                                                      THEN
                                                                        ERROR(Text7381);

                                                                    IF ("Last Counting Period Update" = 0D) OR
                                                                       ("Phys Invt Counting Period Code" <> xRec."Phys Invt Counting Period Code")
                                                                    THEN
                                                                      PhysInvtCountPeriodMgt.CalcPeriod(
                                                                        "Last Counting Period Update","Next Counting Start Date","Next Counting End Date",
                                                                        PhysInvtCountPeriod."Count Frequency per Year");
                                                                  END;
                                                                END ELSE BEGIN
                                                                  IF CurrFieldNo <> 0 THEN
                                                                    IF NOT CONFIRM(Text003,FALSE,FIELDCAPTION("Phys Invt Counting Period Code")) THEN
                                                                      ERROR(Text7381);
                                                                  "Next Counting Start Date" := 0D;
                                                                  "Next Counting End Date" := 0D;
                                                                  "Last Counting Period Update" := 0D;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Lageropg.-opt�llingsperiodekode;
                                                              ENU=Phys Invt Counting Period Code] }
    { 7381;   ;Last Counting Period Update;Date   ;AccessByPermission=TableData 7380=R;
                                                   CaptionML=[DAN=Sidste opt�l.periodeopdatering;
                                                              ENU=Last Counting Period Update];
                                                   Editable=No }
    { 7383;   ;Last Phys. Invt. Date;Date         ;FieldClass=FlowField;
                                                   CalcFormula=Max("Phys. Inventory Ledger Entry"."Posting Date" WHERE (Item No.=FIELD(No.),
                                                                                                                        Phys Invt Counting Period Type=FILTER(' '|Item)));
                                                   CaptionML=[DAN=Sidste lageropg�relsesdato;
                                                              ENU=Last Phys. Invt. Date];
                                                   Editable=No }
    { 7384;   ;Use Cross-Docking   ;Boolean       ;InitValue=Yes;
                                                   AccessByPermission=TableData 7302=R;
                                                   CaptionML=[DAN=Brug dir. afsendelse;
                                                              ENU=Use Cross-Docking] }
    { 7385;   ;Next Counting Start Date;Date      ;CaptionML=[DAN=N�ste opt�llings startdato;
                                                              ENU=Next Counting Start Date];
                                                   Editable=No }
    { 7386;   ;Next Counting End Date;Date        ;CaptionML=[DAN=N�ste opt�llings slutdato;
                                                              ENU=Next Counting End Date];
                                                   Editable=No }
    { 7700;   ;Identifier Code     ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Item Identifier".Code WHERE (Item No.=FIELD(No.)));
                                                   CaptionML=[DAN=Id-kode;
                                                              ENU=Identifier Code];
                                                   Editable=No }
    { 8000;   ;Id                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 8001;   ;Unit of Measure Id  ;GUID          ;TableRelation="Unit of Measure".Id;
                                                   OnValidate=BEGIN
                                                                UpdateUnitOfMeasureCode;
                                                              END;

                                                   CaptionML=[DAN=Enheds-id;
                                                              ENU=Unit of Measure Id] }
    { 8002;   ;Tax Group Id        ;GUID          ;TableRelation="Tax Group".Id;
                                                   OnValidate=BEGIN
                                                                UpdateTaxGroupCode;
                                                              END;

                                                   CaptionML=[DAN=Skattegruppe-id;
                                                              ENU=Tax Group Id] }
    { 99000750;;Routing No.        ;Code20        ;TableRelation="Routing Header";
                                                   OnValidate=BEGIN
                                                                IF "Routing No." <> '' THEN
                                                                  TESTFIELD(Type,Type::Inventory);

                                                                PlanningAssignment.RoutingReplace(Rec,xRec."Routing No.");

                                                                IF "Routing No." <> xRec."Routing No." THEN
                                                                  ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Routing No."));
                                                              END;

                                                   CaptionML=[DAN=Rutenr.;
                                                              ENU=Routing No.] }
    { 99000751;;Production BOM No. ;Code20        ;TableRelation="Production BOM Header";
                                                   OnValidate=VAR
                                                                MfgSetup@1000 : Record 99000765;
                                                                ProdBOMHeader@1001 : Record 99000771;
                                                                ItemUnitOfMeasure@1003 : Record 5404;
                                                              BEGIN
                                                                IF "Production BOM No." <> '' THEN
                                                                  TESTFIELD(Type,Type::Inventory);

                                                                PlanningAssignment.BomReplace(Rec,xRec."Production BOM No.");

                                                                IF "Production BOM No." <> xRec."Production BOM No." THEN
                                                                  ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Production BOM No."));

                                                                IF ("Production BOM No." <> '') AND ("Production BOM No." <> xRec."Production BOM No.") THEN BEGIN
                                                                  ProdBOMHeader.GET("Production BOM No.");
                                                                  ItemUnitOfMeasure.GET("No.",ProdBOMHeader."Unit of Measure Code");
                                                                  IF ProdBOMHeader.Status = ProdBOMHeader.Status::Certified THEN BEGIN
                                                                    MfgSetup.GET;
                                                                    IF MfgSetup."Dynamic Low-Level Code" THEN
                                                                      CODEUNIT.RUN(CODEUNIT::"Calculate Low-Level Code",Rec);
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Produktionsstyklistenr.;
                                                              ENU=Production BOM No.] }
    { 99000752;;Single-Level Material Cost;Decimal;CaptionML=[DAN=Materialekostpris (enkeltniv.);
                                                              ENU=Single-Level Material Cost];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 99000753;;Single-Level Capacity Cost;Decimal;CaptionML=[DAN=Kapacitetskostpris (enkeltniv);
                                                              ENU=Single-Level Capacity Cost];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 99000754;;Single-Level Subcontrd. Cost;Decimal;
                                                   CaptionML=[DAN=Underlev.kostpris (enkeltniv.);
                                                              ENU=Single-Level Subcontrd. Cost];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 99000755;;Single-Level Cap. Ovhd Cost;Decimal;
                                                   CaptionML=[DAN=Ind. kap.kostpris (enkeltniv.);
                                                              ENU=Single-Level Cap. Ovhd Cost];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 99000756;;Single-Level Mfg. Ovhd Cost;Decimal;
                                                   CaptionML=[DAN=Ind. prod.kostpris (enkeltniv);
                                                              ENU=Single-Level Mfg. Ovhd Cost];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 99000757;;Overhead Rate      ;Decimal       ;AccessByPermission=TableData 5405=R;
                                                   CaptionML=[DAN=IPO-bidrag;
                                                              ENU=Overhead Rate];
                                                   AutoFormatType=2 }
    { 99000758;;Rolled-up Subcontracted Cost;Decimal;
                                                   AccessByPermission=TableData 5405=R;
                                                   CaptionML=[DAN=Underlev.kostpris (akkum.);
                                                              ENU=Rolled-up Subcontracted Cost];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 99000759;;Rolled-up Mfg. Ovhd Cost;Decimal  ;CaptionML=[DAN=Ind. prod.kostpris (akkum.);
                                                              ENU=Rolled-up Mfg. Ovhd Cost];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 99000760;;Rolled-up Cap. Overhead Cost;Decimal;
                                                   CaptionML=[DAN=Faste omkostninger (akkum.);
                                                              ENU=Rolled-up Cap. Overhead Cost];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 99000761;;Planning Issues (Qty.);Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Planning Component"."Expected Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                          Due Date=FIELD(Date Filter),
                                                                                                                          Location Code=FIELD(Location Filter),
                                                                                                                          Variant Code=FIELD(Variant Filter),
                                                                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                          Planning Line Origin=CONST(" ")));
                                                   CaptionML=[DAN=Planl�gning - Forsyning (ant.);
                                                              ENU=Planning Issues (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000762;;Planning Receipt (Qty.);Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                                                               No.=FIELD(No.),
                                                                                                               Due Date=FIELD(Date Filter),
                                                                                                               Location Code=FIELD(Location Filter),
                                                                                                               Variant Code=FIELD(Variant Filter),
                                                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
                                                   CaptionML=[DAN=Planl�gning - Behov (ant.);
                                                              ENU=Planning Receipt (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000765;;Planned Order Receipt (Qty.);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Planned),
                                                                                                                     Item No.=FIELD(No.),
                                                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Location Code=FIELD(Location Filter),
                                                                                                                     Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Planlagt ordretilgang (antal);
                                                              ENU=Planned Order Receipt (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000766;;FP Order Receipt (Qty.);Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Firm Planned),
                                                                                                                     Item No.=FIELD(No.),
                                                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Location Code=FIELD(Location Filter),
                                                                                                                     Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Fastlagt ordretilgang (antal);
                                                              ENU=FP Order Receipt (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000767;;Rel. Order Receipt (Qty.);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Released),
                                                                                                                     Item No.=FIELD(No.),
                                                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Location Code=FIELD(Location Filter),
                                                                                                                     Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Frigivet ordretilgang (antal);
                                                              ENU=Rel. Order Receipt (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000768;;Planning Release (Qty.);Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                                                               No.=FIELD(No.),
                                                                                                               Starting Date=FIELD(Date Filter),
                                                                                                               Location Code=FIELD(Location Filter),
                                                                                                               Variant Code=FIELD(Variant Filter),
                                                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
                                                   CaptionML=[DAN=Planl�gning - Frigivet (ant.);
                                                              ENU=Planning Release (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000769;;Planned Order Release (Qty.);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=CONST(Planned),
                                                                                                                     Item No.=FIELD(No.),
                                                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Location Code=FIELD(Location Filter),
                                                                                                                     Starting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Planl. ordrefrigivelse (antal);
                                                              ENU=Planned Order Release (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000770;;Purch. Req. Receipt (Qty.);Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                                                               No.=FIELD(No.),
                                                                                                               Variant Code=FIELD(Variant Filter),
                                                                                                               Location Code=FIELD(Location Filter),
                                                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                               Due Date=FIELD(Date Filter),
                                                                                                               Planning Line Origin=CONST(" ")));
                                                   CaptionML=[DAN=Indk�bskld.tilgang (antal);
                                                              ENU=Purch. Req. Receipt (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000771;;Purch. Req. Release (Qty.);Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Requisition Line"."Quantity (Base)" WHERE (Type=CONST(Item),
                                                                                                               No.=FIELD(No.),
                                                                                                               Location Code=FIELD(Location Filter),
                                                                                                               Variant Code=FIELD(Variant Filter),
                                                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                               Order Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Indk�bskld.frigivelse (antal);
                                                              ENU=Purch. Req. Release (Qty.)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000773;;Order Tracking Policy;Option      ;OnValidate=VAR
                                                                ReservEntry@1000 : Record 337;
                                                                ActionMessageEntry@1001 : Record 99000849;
                                                                TempReservationEntry@1002 : TEMPORARY Record 337;
                                                              BEGIN
                                                                IF "Order Tracking Policy" <> "Order Tracking Policy"::None THEN
                                                                  TESTFIELD(Type,Type::Inventory);
                                                                IF xRec."Order Tracking Policy" = "Order Tracking Policy" THEN
                                                                  EXIT;
                                                                IF "Order Tracking Policy" > xRec."Order Tracking Policy" THEN BEGIN
                                                                  MESSAGE(Text99000000 +
                                                                    Text99000001,
                                                                    SELECTSTR("Order Tracking Policy",Text99000002));
                                                                END ELSE BEGIN
                                                                  ActionMessageEntry.SETCURRENTKEY("Reservation Entry");
                                                                  ReservEntry.SETCURRENTKEY("Item No.","Variant Code","Location Code","Reservation Status");
                                                                  ReservEntry.SETRANGE("Item No.","No.");
                                                                  ReservEntry.SETRANGE("Reservation Status",ReservEntry."Reservation Status"::Tracking,ReservEntry."Reservation Status"::Surplus);
                                                                  IF ReservEntry.FIND('-') THEN
                                                                    REPEAT
                                                                      ActionMessageEntry.SETRANGE("Reservation Entry",ReservEntry."Entry No.");
                                                                      ActionMessageEntry.DELETEALL;
                                                                      IF "Order Tracking Policy" = "Order Tracking Policy"::None THEN
                                                                        IF ReservEntry.TrackingExists THEN BEGIN
                                                                          TempReservationEntry := ReservEntry;
                                                                          TempReservationEntry."Reservation Status" := TempReservationEntry."Reservation Status"::Surplus;
                                                                          TempReservationEntry.INSERT;
                                                                        END ELSE
                                                                          ReservEntry.DELETE;
                                                                    UNTIL ReservEntry.NEXT = 0;

                                                                  IF TempReservationEntry.FIND('-') THEN
                                                                    REPEAT
                                                                      ReservEntry := TempReservationEntry;
                                                                      ReservEntry.MODIFY;
                                                                    UNTIL TempReservationEntry.NEXT = 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Ordresporingsmetode;
                                                              ENU=Order Tracking Policy];
                                                   OptionCaptionML=[DAN=Ingen,Kun sporing,Sporing & aktionsmedd.;
                                                                    ENU=None,Tracking Only,Tracking & Action Msg.];
                                                   OptionString=None,Tracking Only,Tracking & Action Msg. }
    { 99000774;;Prod. Forecast Quantity (Base);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Production Forecast Entry"."Forecast Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                                                                                 Production Forecast Name=FIELD(Production Forecast Name),
                                                                                                                                 Forecast Date=FIELD(Date Filter),
                                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                                 Component Forecast=FIELD(Component Forecast)));
                                                   CaptionML=[DAN=Prod.forecastantal (basis);
                                                              ENU=Prod. Forecast Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 99000775;;Production Forecast Name;Code10   ;FieldClass=FlowFilter;
                                                   TableRelation="Production Forecast Name";
                                                   CaptionML=[DAN=Produktionsforecastnavn;
                                                              ENU=Production Forecast Name] }
    { 99000776;;Component Forecast ;Boolean       ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Komponentforecast;
                                                              ENU=Component Forecast] }
    { 99000777;;Qty. on Prod. Order;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Line"."Remaining Qty. (Base)" WHERE (Status=FILTER(Planned..Released),
                                                                                                                     Item No.=FIELD(No.),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Location Code=FIELD(Location Filter),
                                                                                                                     Variant Code=FIELD(Variant Filter),
                                                                                                                     Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Antal p� produktionsordre;
                                                              ENU=Qty. on Prod. Order];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000778;;Qty. on Component Lines;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Component"."Remaining Qty. (Base)" WHERE (Status=FILTER(Planned..Released),
                                                                                                                          Item No.=FIELD(No.),
                                                                                                                          Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                          Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                          Location Code=FIELD(Location Filter),
                                                                                                                          Variant Code=FIELD(Variant Filter),
                                                                                                                          Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Antal p� komponentlinje;
                                                              ENU=Qty. on Component Lines];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 99000875;;Critical           ;Boolean       ;CaptionML=[DAN=Kritisk;
                                                              ENU=Critical] }
    { 99008500;;Common Item No.    ;Code20        ;CaptionML=[DAN=F�lles varenr.;
                                                              ENU=Common Item No.] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Description                       }
    {    ;Inventory Posting Group                  }
    {    ;Shelf No.                                }
    {    ;Vendor No.                               }
    {    ;Gen. Prod. Posting Group                 }
    {    ;Low-Level Code                           }
    {    ;Production BOM No.                       }
    {    ;Routing No.                              }
    {    ;Vendor Item No.,Vendor No.               }
    {    ;Common Item No.                          }
    {    ;Service Item Group                       }
    {    ;Cost is Adjusted,Allow Online Adjustment }
    {    ;Description                              }
    {    ;Base Unit of Measure                     }
    {    ;Type                                     }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Description,Base Unit of Measure,Unit Price }
    { 2   ;Brick               ;No.,Description,Inventory,Unit Price,Base Unit of Measure,Description 2,Picture }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der findes �n eller flere udest�ende forekomster af k�bs%3, der indeholder denne vare.;ENU=You cannot delete %1 %2 because there is at least one outstanding Purchase %3 that includes this item.';
      CannotDeleteItemIfSalesDocExistErr@1001 : TextConst '@@@=1: Type, 2 Item No. and 3 : Type of document Order,Invoice;DAN=Du kan ikke slette %1 %2, fordi der findes �n eller flere udest�ende forekomster af salgs%3, der indeholder denne vare.;ENU=You cannot delete %1 %2 because there is at least one outstanding Sales %3 that includes this item.';
      CannotDeleteItemIfSalesDocExistInvoicingErr@1041 : TextConst '@@@=1: Type, 2: Item No., 3: Description of document, 4: Document number;DAN=Du kan ikke slette %1 %2, fordi mindst �t salgsbilag (%3 %4) indeholder varen.;ENU=You cannot delete %1 %2 because at least one sales document (%3 %4) includes the item.';
      Text002@1002 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der er en eller flere produktionsordrer, der indeholder denne vare.;ENU=You cannot delete %1 %2 because there are one or more outstanding production orders that include this item.';
      Text003@1057 : TextConst 'DAN=Skal %1 �ndres?;ENU=Do you want to change %1?';
      Text004@1064 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der findes �n eller flere godkendte produktionsstyklister, der indeholder denne vare.;ENU=You cannot delete %1 %2 because there are one or more certified Production BOM that include this item.';
      CannotDeleteItemIfProdBOMVersionExistsErr@1084 : TextConst '@@@=%1 - Tablecaption, %2 - No.;DAN=Du kan ikke slette %1 %2, fordi der findes �n eller flere godkendte udgaver af produktionsstyklister, der indeholder denne vare.;ENU=You cannot delete %1 %2 because there are one or more certified production BOM version that include this item.';
      Text006@1003 : TextConst 'DAN=Priser inkl. moms kan ikke beregnes, n�r %1 er %2.;ENU=Prices including VAT cannot be calculated when %1 is %2.';
      Text007@1004 : TextConst 'DAN=Du kan ikke �ndre %1, fordi der er en eller flere poster p� varen.;ENU=You cannot change %1 because there are one or more ledger entries for this item.';
      Text008@1005 : TextConst 'DAN=Du kan ikke �ndre %1, fordi der findes mindst �n udest�ende k�bs%2, som indeholder denne vare.;ENU=You cannot change %1 because there is at least one outstanding Purchase %2 that include this item.';
      Text014@1006 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der findes �n eller flere produktionsordrekomponentlinjer, som indeholder denne vare, med et restantal, der ikke er 0.;ENU=You cannot delete %1 %2 because there are one or more production order component lines that include this item with a remaining quantity that is not 0.';
      Text016@1008 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der er en eller flere udest�ende overflytningsordrer, som indeholder denne vare.;ENU=You cannot delete %1 %2 because there are one or more outstanding transfer orders that include this item.';
      Text017@1009 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der er mindst �n %3 for en service, som indeholder denne vare.;ENU=You cannot delete %1 %2 because there is at least one outstanding Service %3 that includes this item.';
      Text018@1010 : TextConst 'DAN=%1 skal v�re %2 i %3 %4, n�r %5 er %6.;ENU=%1 must be %2 in %3 %4 when %5 is %6.';
      Text019@1011 : TextConst 'DAN=Du kan ikke �ndre %1, fordi der er en eller flere �bne poster p� denne vare.;ENU=You cannot change %1 because there are one or more open ledger entries for this item.';
      Text020@1012 : TextConst 'DAN="Der kan v�re ordrer og �bne poster p� varen. ";ENU="There may be orders and open ledger entries for the item. "';
      Text021@1013 : TextConst 'DAN=Hvis du �ndrer %1, vil det kun p�virke nye ordrer og poster.\\;ENU=If you change %1 it may affect new orders and entries.\\';
      Text022@1014 : TextConst 'DAN=Skal %1 �ndres?;ENU=Do you want to change %1?';
      GLSetup@1053 : Record 98;
      InvtSetup@1015 : Record 313;
      Text023@1066 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der findes mindst �n %3, der indeholder denne vare.;ENU=You cannot delete %1 %2 because there is at least one %3 that includes this item.';
      Text024@1072 : TextConst 'DAN=Hvis du �ndrer %1, kan det p�virke eksisterende produktionsordrer.\;ENU=If you change %1 it may affect existing production orders.\';
      Text025@1055 : TextConst 'DAN=%1 skal v�re et heltal, da %2 %3 er konfigureret til at anvende %4.;ENU=%1 must be an integer because %2 %3 is set up to use %4.';
      Text026@1077 : TextConst 'DAN=%1 kan ikke �ndres, da %2 har igangv�rende arbejde. Hvis v�rdien �ndres, kan det medf�re, at VIA-kontoen forskydes.;ENU=%1 cannot be changed because the %2 has work in process (WIP). Changing the value may offset the WIP account.';
      Text7380@1058 : TextConst '@@@=If you change the Phys Invt Counting Period Code, the Next Counting Start Date and Next Counting End Date are calculated.\Do you still want to change the Phys Invt Counting Period Code?;DAN=Hvis du �ndrer %1, beregnes %2 og %3.\Vil du stadig �ndre %1?;ENU=If you change the %1, the %2 and %3 are calculated.\Do you still want to change the %1?';
      Text7381@1056 : TextConst 'DAN=Annulleret.;ENU=Cancelled.';
      Text99000000@1017 : TextConst 'DAN=�ndringen p�virker ikke eksisterende poster.\;ENU=The change will not affect existing entries.\';
      CommentLine@1018 : Record 97;
      Text99000001@1019 : TextConst 'DAN=Hvis du vil generere %1 for eksisterende poster, skal du k�re en total omplanl�gning.;ENU=If you want to generate %1 for existing entries, you must run a regenerative planning.';
      ItemVend@1020 : Record 99;
      Text99000002@1021 : TextConst 'DAN=sporing, sporing og aktionsmeddelelser;ENU=tracking,tracking and action messages';
      SalesPrice@1022 : Record 7002;
      SalesLineDisc@1059 : Record 7004;
      SalesPrepmtPct@1051 : Record 459;
      PurchPrice@1060 : Record 7012;
      PurchLineDisc@1061 : Record 7014;
      PurchPrepmtPct@1076 : Record 460;
      ItemTranslation@1023 : Record 30;
      BOMComp@1024 : Record 90;
      VATPostingSetup@1027 : Record 325;
      ExtTextHeader@1028 : Record 279;
      GenProdPostingGrp@1029 : Record 251;
      ItemUnitOfMeasure@1030 : Record 5404;
      ItemVariant@1031 : Record 5401;
      ItemJnlLine@1007 : Record 83;
      ProdOrderLine@1032 : Record 5406;
      ProdOrderComp@1033 : Record 5407;
      PlanningAssignment@1035 : Record 99000850;
      SKU@1036 : Record 5700;
      ItemTrackingCode@1037 : Record 6502;
      ItemTrackingCode2@1038 : Record 6502;
      ServInvLine@1039 : Record 5902;
      ItemSub@1040 : Record 5715;
      TransLine@1042 : Record 5741;
      Vend@1016 : Record 23;
      NonstockItem@1034 : Record 5718;
      ProdBOMHeader@1062 : Record 99000771;
      ProdBOMLine@1063 : Record 99000772;
      ItemIdent@1065 : Record 7704;
      RequisitionLine@1067 : Record 246;
      ItemBudgetEntry@1075 : Record 7134;
      ItemAnalysisViewEntry@1074 : Record 7154;
      ItemAnalysisBudgViewEntry@1073 : Record 7156;
      TroubleshSetup@1050 : Record 5945;
      ServiceItem@1068 : Record 5940;
      ServiceContractLine@1069 : Record 5964;
      ServiceItemComponent@1070 : Record 5941;
      NoSeriesMgt@1043 : Codeunit 396;
      MoveEntries@1044 : Codeunit 361;
      DimMgt@1045 : Codeunit 408;
      NonstockItemMgt@1046 : Codeunit 5703;
      ItemCostMgt@1047 : Codeunit 5804;
      ResSkillMgt@1071 : Codeunit 5931;
      CalendarMgt@1054 : Codeunit 7600;
      LeadTimeMgt@1025 : Codeunit 5404;
      ApprovalsMgmt@1085 : Codeunit 1535;
      HasInvtSetup@1049 : Boolean;
      GLSetupRead@1052 : Boolean;
      Text027@1078 : TextConst '@@@=starts with "Rounding Precision";DAN=skal v�re st�rre end 0.;ENU=must be greater than 0.';
      Text028@1080 : TextConst 'DAN=Du kan ikke udf�re denne handling, da udligning af poster for varen %1 er annulleret i %2 af brugeren %3.;ENU=You cannot perform this action because entries for item %1 are unapplied in %2 by user %3.';
      CannotChangeFieldErr@1079 : TextConst '@@@="%1 = Field Caption, %2 = Item Table Name, %3 = Item No., %4 = Table Name";DAN=Du kan ikke �ndre %1-feltet p� %2 %3, fordi der findes mindst �n %4, der indeholder dette element.;ENU=You cannot change the %1 field on %2 %3 because at least one %4 exists for this item.';
      BaseUnitOfMeasureQtyMustBeOneErr@1081 : TextConst '@@@="%1 Name of Unit of measure (e.g. BOX, PCS, KG...), %2 Qty. of %1 per base unit of measure ";DAN=Antallet pr. basisenhed skal v�re 1. %1 er konfigureret med %2 pr. enhed.\\Du kan �ndre denne ops�tning i vinduet Vareenheder.;ENU=The quantity per base unit of measure must be 1. %1 is set up with %2 per unit of measure.\\You can change this setup in the Item Units of Measure window.';
      OpenDocumentTrackingErr@1082 : TextConst 'DAN="Du kan ikke �ndre ""Varesporingskode"", da der er mindst et �bent dokument, der indeholder denne vare med en angivet sporing: kildetype = %1, dokumentnr. = %2.";ENU="You cannot change ""Item Tracking Code"" because there is at least one open document that includes this item with specified tracking: Source Type = %1, Document No. = %2."';
      SelectItemErr@1083 : TextConst 'DAN=Du skal v�lge en eksisterende vare.;ENU=You must select an existing item.';
      SelectOrCreateItemErr@1026 : TextConst 'DAN=Du skal v�lge en eksisterende vare eller oprette en ny.;ENU=You must select an existing item or create a new.';
      CreateNewItemTxt@1187 : TextConst '@@@="%1 is the name to be used to create the customer. ";DAN=Opret et nyt varekort for %1.;ENU=Create a new item card for %1.';
      ItemNotRegisteredTxt@1186 : TextConst 'DAN=Denne vare er ikke registreret. V�lg en af f�lgende muligheder for at forts�tte:;ENU=This item is not registered. To continue, choose one of the following options:';
      SelectItemTxt@1185 : TextConst 'DAN=V�lg en eksisterende vare.;ENU=Select an existing item.';

    LOCAL PROCEDURE DeleteRelatedData@12();
    VAR
      BinContent@1002 : Record 7302;
      ItemCrossReference@1001 : Record 5717;
      SocialListeningSearchTopic@1000 : Record 871;
      MyItem@1003 : Record 9152;
      ItemAttributeValueMapping@1004 : Record 7505;
    BEGIN
      ItemBudgetEntry.SETCURRENTKEY("Analysis Area","Budget Name","Item No.");
      ItemBudgetEntry.SETRANGE("Item No.","No.");
      ItemBudgetEntry.DELETEALL(TRUE);

      ItemSub.RESET;
      ItemSub.SETRANGE(Type,ItemSub.Type::Item);
      ItemSub.SETRANGE("No.","No.");
      ItemSub.DELETEALL;

      ItemSub.RESET;
      ItemSub.SETRANGE("Substitute Type",ItemSub."Substitute Type"::Item);
      ItemSub.SETRANGE("Substitute No.","No.");
      ItemSub.DELETEALL;

      SKU.RESET;
      SKU.SETCURRENTKEY("Item No.");
      SKU.SETRANGE("Item No.","No.");
      SKU.DELETEALL;

      NonstockItemMgt.NonstockItemDel(Rec);
      CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Item);
      CommentLine.SETRANGE("No.","No.");
      CommentLine.DELETEALL;

      ItemVend.SETCURRENTKEY("Item No.");
      ItemVend.SETRANGE("Item No.","No.");
      ItemVend.DELETEALL;

      SalesPrice.SETRANGE("Item No.","No.");
      SalesPrice.DELETEALL;

      SalesLineDisc.SETRANGE(Type,SalesLineDisc.Type::Item);
      SalesLineDisc.SETRANGE(Code,"No.");
      SalesLineDisc.DELETEALL;

      SalesPrepmtPct.SETRANGE("Item No.","No.");
      SalesPrepmtPct.DELETEALL;

      PurchPrice.SETRANGE("Item No.","No.");
      PurchPrice.DELETEALL;

      PurchLineDisc.SETRANGE("Item No.","No.");
      PurchLineDisc.DELETEALL;

      PurchPrepmtPct.SETRANGE("Item No.","No.");
      PurchPrepmtPct.DELETEALL;

      ItemTranslation.SETRANGE("Item No.","No.");
      ItemTranslation.DELETEALL;

      ItemUnitOfMeasure.SETRANGE("Item No.","No.");
      ItemUnitOfMeasure.DELETEALL;

      ItemVariant.SETRANGE("Item No.","No.");
      ItemVariant.DELETEALL;

      ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::Item);
      ExtTextHeader.SETRANGE("No.","No.");
      ExtTextHeader.DELETEALL(TRUE);

      ItemAnalysisViewEntry.SETRANGE("Item No.","No.");
      ItemAnalysisViewEntry.DELETEALL;

      ItemAnalysisBudgViewEntry.SETRANGE("Item No.","No.");
      ItemAnalysisBudgViewEntry.DELETEALL;

      PlanningAssignment.SETRANGE("Item No.","No.");
      PlanningAssignment.DELETEALL;

      BOMComp.RESET;
      BOMComp.SETRANGE("Parent Item No.","No.");
      BOMComp.DELETEALL;

      TroubleshSetup.RESET;
      TroubleshSetup.SETRANGE(Type,TroubleshSetup.Type::Item);
      TroubleshSetup.SETRANGE("No.","No.");
      TroubleshSetup.DELETEALL;

      ResSkillMgt.DeleteItemResSkills("No.");
      DimMgt.DeleteDefaultDim(DATABASE::Item,"No.");

      ItemIdent.RESET;
      ItemIdent.SETCURRENTKEY("Item No.");
      ItemIdent.SETRANGE("Item No.","No.");
      ItemIdent.DELETEALL;

      ServiceItemComponent.RESET;
      ServiceItemComponent.SETRANGE(Type,ServiceItemComponent.Type::Item);
      ServiceItemComponent.SETRANGE("No.","No.");
      ServiceItemComponent.MODIFYALL("No.",'');

      BinContent.SETCURRENTKEY("Item No.");
      BinContent.SETRANGE("Item No.","No.");
      BinContent.DELETEALL;

      ItemCrossReference.SETRANGE("Item No.","No.");
      ItemCrossReference.DELETEALL;

      MyItem.SETRANGE("Item No.","No.");
      MyItem.DELETEALL;

      IF NOT SocialListeningSearchTopic.ISEMPTY THEN BEGIN
        SocialListeningSearchTopic.FindSearchTopic(SocialListeningSearchTopic."Source Type"::Item,"No.");
        SocialListeningSearchTopic.DELETEALL;
      END;

      ItemAttributeValueMapping.RESET;
      ItemAttributeValueMapping.SETRANGE("Table ID",DATABASE::Item);
      ItemAttributeValueMapping.SETRANGE("No.","No.");
      ItemAttributeValueMapping.DELETEALL;
    END;

    [External]
    PROCEDURE AssistEdit@2() : Boolean;
    BEGIN
      GetInvtSetup;
      InvtSetup.TESTFIELD("Item Nos.");
      IF NoSeriesMgt.SelectSeries(InvtSetup."Item Nos.",xRec."No. Series","No. Series") THEN BEGIN
        NoSeriesMgt.SetSeries("No.");
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE FindItemVend@5(VAR ItemVend@1000 : Record 99;LocationCode@1002 : Code[10]);
    VAR
      GetPlanningParameters@1004 : Codeunit 99000855;
    BEGIN
      TESTFIELD("No.");
      ItemVend.RESET;
      ItemVend.SETRANGE("Item No.","No.");
      ItemVend.SETRANGE("Vendor No.",ItemVend."Vendor No.");
      ItemVend.SETRANGE("Variant Code",ItemVend."Variant Code");

      IF NOT ItemVend.FIND('+') THEN BEGIN
        ItemVend."Item No." := "No.";
        ItemVend."Vendor Item No." := '';
        GetPlanningParameters.AtSKU(SKU,"No.",ItemVend."Variant Code",LocationCode);
        IF ItemVend."Vendor No." = '' THEN
          ItemVend."Vendor No." := SKU."Vendor No.";
        IF ItemVend."Vendor Item No." = '' THEN
          ItemVend."Vendor Item No." := SKU."Vendor Item No.";
        ItemVend."Lead Time Calculation" := SKU."Lead Time Calculation";
      END;
      IF FORMAT(ItemVend."Lead Time Calculation") = '' THEN
        IF Vend.GET(ItemVend."Vendor No.") THEN
          ItemVend."Lead Time Calculation" := Vend."Lead Time Calculation";
      ItemVend.RESET;
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@8(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Item,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    END;

    LOCAL PROCEDURE TestNoEntriesExist@1006(CurrentFieldName@1000 : Text[100]);
    VAR
      ItemLedgEntry@1001 : Record 32;
      PurchaseLine@1002 : Record 39;
    BEGIN
      IF "No." = '' THEN
        EXIT;

      ItemLedgEntry.SETCURRENTKEY("Item No.");
      ItemLedgEntry.SETRANGE("Item No.","No.");
      IF NOT ItemLedgEntry.ISEMPTY THEN
        ERROR(
          Text007,
          CurrentFieldName);

      PurchaseLine.SETCURRENTKEY("Document Type",Type,"No.");
      PurchaseLine.SETFILTER(
        "Document Type",'%1|%2',
        PurchaseLine."Document Type"::Order,
        PurchaseLine."Document Type"::"Return Order");
      PurchaseLine.SETRANGE(Type,PurchaseLine.Type::Item);
      PurchaseLine.SETRANGE("No.","No.");
      IF PurchaseLine.FINDFIRST THEN
        ERROR(
          Text008,
          CurrentFieldName,
          PurchaseLine."Document Type");
    END;

    LOCAL PROCEDURE TestNoOpenEntriesExist@4(CurrentFieldName@1000 : Text[100]);
    VAR
      ItemLedgEntry@1001 : Record 32;
    BEGIN
      ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
      ItemLedgEntry.SETRANGE("Item No.","No.");
      ItemLedgEntry.SETRANGE(Open,TRUE);
      IF NOT ItemLedgEntry.ISEMPTY THEN
        ERROR(
          Text019,
          CurrentFieldName);
    END;

    LOCAL PROCEDURE TestNoOpenDocumentsWithTrackingExist@42();
    VAR
      TrackingSpecification@1000 : Record 336;
      ReservationEntry@1001 : Record 337;
      RecRef@1004 : RecordRef;
      SourceType@1002 : Integer;
      SourceID@1003 : Code[20];
    BEGIN
      IF ItemTrackingCode2.Code = '' THEN
        EXIT;

      TrackingSpecification.SETRANGE("Item No.","No.");
      IF TrackingSpecification.FINDFIRST THEN BEGIN
        SourceType := TrackingSpecification."Source Type";
        SourceID := TrackingSpecification."Source ID";
      END ELSE BEGIN
        ReservationEntry.SETRANGE("Item No.","No.");
        ReservationEntry.SETFILTER("Item Tracking",'<>%1',ReservationEntry."Item Tracking"::None);
        IF ReservationEntry.FINDFIRST THEN BEGIN
          SourceType := ReservationEntry."Source Type";
          SourceID := ReservationEntry."Source ID";
        END;
      END;

      IF SourceType = 0 THEN
        EXIT;

      RecRef.OPEN(SourceType);
      ERROR(OpenDocumentTrackingErr,RecRef.CAPTION,SourceID);
    END;

    [External]
    PROCEDURE ItemSKUGet@11(VAR Item@1000 : Record 27;LocationCode@1001 : Code[10];VariantCode@1002 : Code[10]);
    VAR
      SKU@1003 : Record 5700;
    BEGIN
      IF Item.GET("No.") THEN BEGIN
        IF SKU.GET(LocationCode,Item."No.",VariantCode) THEN
          Item."Shelf No." := SKU."Shelf No.";
      END;
    END;

    LOCAL PROCEDURE GetInvtSetup@14();
    BEGIN
      IF NOT HasInvtSetup THEN BEGIN
        InvtSetup.GET;
        HasInvtSetup := TRUE;
      END;
    END;

    [External]
    PROCEDURE IsMfgItem@1() : Boolean;
    BEGIN
      EXIT("Replenishment System" = "Replenishment System"::"Prod. Order");
    END;

    [External]
    PROCEDURE IsAssemblyItem@24() : Boolean;
    BEGIN
      EXIT("Replenishment System" = "Replenishment System"::Assembly);
    END;

    [External]
    PROCEDURE HasBOM@18() : Boolean;
    BEGIN
      CALCFIELDS("Assembly BOM");
      EXIT("Assembly BOM" OR ("Production BOM No." <> ''));
    END;

    LOCAL PROCEDURE GetGLSetup@6();
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetup.GET;
      GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE ProdOrderExist@7() : Boolean;
    BEGIN
      ProdOrderLine.SETCURRENTKEY(Status,"Item No.");
      ProdOrderLine.SETFILTER(Status,'..%1',ProdOrderLine.Status::Released);
      ProdOrderLine.SETRANGE("Item No.","No.");
      IF NOT ProdOrderLine.ISEMPTY THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE CheckSerialNoQty@15(ItemNo@1000 : Code[20];FieldName@1001 : Text[30];Quantity@1002 : Decimal);
    VAR
      ItemRec@1003 : Record 27;
      ItemTrackingCode3@1004 : Record 6502;
    BEGIN
      IF Quantity = ROUND(Quantity,1) THEN
        EXIT;
      IF NOT ItemRec.GET(ItemNo) THEN
        EXIT;
      IF ItemRec."Item Tracking Code" = '' THEN
        EXIT;
      IF NOT ItemTrackingCode3.GET(ItemRec."Item Tracking Code") THEN
        EXIT;
      IF ItemTrackingCode3."SN Specific Tracking" THEN
        ERROR(Text025,
          FieldName,
          TABLECAPTION,
          ItemNo,
          ItemTrackingCode3.FIELDCAPTION("SN Specific Tracking"));
    END;

    LOCAL PROCEDURE CheckForProductionOutput@17(ItemNo@1000 : Code[20]);
    VAR
      ItemLedgEntry@1001 : Record 32;
    BEGIN
      CLEAR(ItemLedgEntry);
      ItemLedgEntry.SETCURRENTKEY("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
      ItemLedgEntry.SETRANGE("Item No.",ItemNo);
      ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::Output);
      IF NOT ItemLedgEntry.ISEMPTY THEN
        ERROR(Text026,FIELDCAPTION("Inventory Value Zero"),TABLECAPTION);
    END;

    [External]
    PROCEDURE CheckBlockedByApplWorksheet@19();
    VAR
      ApplicationWorksheet@1000 : Page 521;
    BEGIN
      IF "Application Wksh. User ID" <> '' THEN
        ERROR(Text028,"No.",ApplicationWorksheet.CAPTION,"Application Wksh. User ID");
    END;

    [External]
    PROCEDURE ShowTimelineFromItem@20(VAR Item@1000 : Record 27);
    VAR
      ItemAvailByTimeline@1001 : Page 5540;
    BEGIN
      ItemAvailByTimeline.SetItem(Item);
      ItemAvailByTimeline.RUN;
    END;

    [External]
    PROCEDURE ShowTimelineFromSKU@21(ItemNo@1000 : Code[20];LocationCode@1001 : Code[10];VariantCode@1002 : Code[10]);
    VAR
      Item@1003 : Record 27;
    BEGIN
      Item.GET(ItemNo);
      Item.SETRANGE("No.",Item."No.");
      Item.SETRANGE("Variant Filter",VariantCode);
      Item.SETRANGE("Location Filter",LocationCode);
      ShowTimelineFromItem(Item);
    END;

    LOCAL PROCEDURE CheckJournalsAndWorksheets@22(CurrFieldNo@1001 : Integer);
    BEGIN
      CheckItemJnlLine(CurrFieldNo);
      CheckStdCostWksh(CurrFieldNo);
      CheckReqLine(CurrFieldNo);
    END;

    LOCAL PROCEDURE CheckItemJnlLine@44(CurrFieldNo@1000 : Integer);
    BEGIN
      ItemJnlLine.SETRANGE("Item No.","No.");
      IF NOT ItemJnlLine.ISEMPTY THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text023,TABLECAPTION,"No.",ItemJnlLine.TABLECAPTION);
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ItemJnlLine.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckStdCostWksh@45(CurrFieldNo@1000 : Integer);
    VAR
      StdCostWksh@1001 : Record 5841;
    BEGIN
      StdCostWksh.RESET;
      StdCostWksh.SETRANGE(Type,StdCostWksh.Type::Item);
      StdCostWksh.SETRANGE("No.","No.");
      IF NOT StdCostWksh.ISEMPTY THEN
        IF CurrFieldNo = 0 THEN
          ERROR(Text023,TABLECAPTION,"No.",StdCostWksh.TABLECAPTION);
    END;

    LOCAL PROCEDURE CheckReqLine@46(CurrFieldNo@1000 : Integer);
    BEGIN
      RequisitionLine.SETCURRENTKEY(Type,"No.");
      RequisitionLine.SETRANGE(Type,RequisitionLine.Type::Item);
      RequisitionLine.SETRANGE("No.","No.");
      IF NOT RequisitionLine.ISEMPTY THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text023,TABLECAPTION,"No.",RequisitionLine.TABLECAPTION);
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",RequisitionLine.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckDocuments@23(CurrFieldNo@1002 : Integer);
    BEGIN
      IF "No." = '' THEN
        EXIT;

      CheckBOM(CurrFieldNo);
      CheckPurchLine(CurrFieldNo);
      CheckSalesLine(CurrFieldNo);
      CheckProdOrderLine(CurrFieldNo);
      CheckProdOrderCompLine(CurrFieldNo);
      CheckPlanningCompLine(CurrFieldNo);
      CheckTransLine(CurrFieldNo);
      CheckServLine(CurrFieldNo);
      CheckProdBOMLine(CurrFieldNo);
      CheckServContractLine(CurrFieldNo);
      CheckAsmHeader(CurrFieldNo);
      CheckAsmLine(CurrFieldNo);
      CheckJobPlanningLine(CurrFieldNo);

      OnAfterCheckDocuments(Rec,xRec,CurrFieldNo);
    END;

    LOCAL PROCEDURE CheckBOM@25(CurrFieldNo@1000 : Integer);
    BEGIN
      BOMComp.RESET;
      BOMComp.SETCURRENTKEY(Type,"No.");
      BOMComp.SETRANGE(Type,BOMComp.Type::Item);
      BOMComp.SETRANGE("No.","No.");
      IF NOT BOMComp.ISEMPTY THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text023,TABLECAPTION,"No.",BOMComp.TABLECAPTION);
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",BOMComp.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckPurchLine@26(CurrFieldNo@1000 : Integer);
    VAR
      PurchaseLine@1001 : Record 39;
    BEGIN
      PurchaseLine.SETCURRENTKEY(Type,"No.");
      PurchaseLine.SETRANGE(Type,PurchaseLine.Type::Item);
      PurchaseLine.SETRANGE("No.","No.");
      IF PurchaseLine.FINDFIRST THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text000,TABLECAPTION,"No.",PurchaseLine."Document Type");
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",PurchaseLine.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckSalesLine@28(CurrFieldNo@1000 : Integer);
    VAR
      SalesLine@1001 : Record 37;
      IdentityManagement@1002 : Codeunit 9801;
    BEGIN
      SalesLine.SETCURRENTKEY(Type,"No.");
      SalesLine.SETRANGE(Type,SalesLine.Type::Item);
      SalesLine.SETRANGE("No.","No.");
      IF SalesLine.FINDFIRST THEN BEGIN
        IF CurrFieldNo = 0 THEN BEGIN
          IF IdentityManagement.IsInvAppId THEN
            ERROR(CannotDeleteItemIfSalesDocExistInvoicingErr,TABLECAPTION,Description,
              SalesLine.GetDocumentTypeDescription,SalesLine."Document No.");
          ERROR(CannotDeleteItemIfSalesDocExistErr,TABLECAPTION,"No.",SalesLine."Document Type");
        END;
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",SalesLine.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckProdOrderLine@39(CurrFieldNo@1000 : Integer);
    BEGIN
      IF ProdOrderExist THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text002,TABLECAPTION,"No.");
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdOrderLine.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckProdOrderCompLine@31(CurrFieldNo@1000 : Integer);
    BEGIN
      ProdOrderComp.SETCURRENTKEY(Status,"Item No.");
      ProdOrderComp.SETFILTER(Status,'..%1',ProdOrderComp.Status::Released);
      ProdOrderComp.SETRANGE("Item No.","No.");
      IF NOT ProdOrderComp.ISEMPTY THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text014,TABLECAPTION,"No.");
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdOrderComp.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckPlanningCompLine@38(CurrFieldNo@1000 : Integer);
    VAR
      PlanningComponent@1005 : Record 99000829;
    BEGIN
      PlanningComponent.SETCURRENTKEY("Item No.","Variant Code","Location Code","Due Date","Planning Line Origin");
      PlanningComponent.SETRANGE("Item No.","No.");
      IF NOT PlanningComponent.ISEMPTY THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text023,TABLECAPTION,"No.",PlanningComponent.TABLECAPTION);
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",PlanningComponent.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckTransLine@37(CurrFieldNo@1000 : Integer);
    BEGIN
      TransLine.SETCURRENTKEY("Item No.");
      TransLine.SETRANGE("Item No.","No.");
      IF NOT TransLine.ISEMPTY THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text016,TABLECAPTION,"No.");
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",TransLine.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckServLine@36(CurrFieldNo@1000 : Integer);
    BEGIN
      ServInvLine.RESET;
      ServInvLine.SETCURRENTKEY(Type,"No.");
      ServInvLine.SETRANGE(Type,ServInvLine.Type::Item);
      ServInvLine.SETRANGE("No.","No.");
      IF NOT ServInvLine.ISEMPTY THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text017,TABLECAPTION,"No.",ServInvLine."Document Type");
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ServInvLine.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckProdBOMLine@30(CurrFieldNo@1000 : Integer);
    VAR
      ProductionBOMVersion@1001 : Record 99000779;
    BEGIN
      ProdBOMLine.RESET;
      ProdBOMLine.SETCURRENTKEY(Type,"No.");
      ProdBOMLine.SETRANGE(Type,ProdBOMLine.Type::Item);
      ProdBOMLine.SETRANGE("No.","No.");
      IF ProdBOMLine.FIND('-') THEN BEGIN
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ProdBOMLine.TABLECAPTION);
        IF CurrFieldNo = 0 THEN
          REPEAT
            IF ProdBOMHeader.GET(ProdBOMLine."Production BOM No.") AND
               (ProdBOMHeader.Status = ProdBOMHeader.Status::Certified)
            THEN
              ERROR(Text004,TABLECAPTION,"No.");
            IF ProductionBOMVersion.GET(ProdBOMLine."Production BOM No.",ProdBOMLine."Version Code") AND
               (ProductionBOMVersion.Status = ProductionBOMVersion.Status::Certified)
            THEN
              ERROR(CannotDeleteItemIfProdBOMVersionExistsErr,TABLECAPTION,"No.");
          UNTIL ProdBOMLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckServContractLine@35(CurrFieldNo@1000 : Integer);
    BEGIN
      ServiceContractLine.RESET;
      ServiceContractLine.SETRANGE("Item No.","No.");
      IF NOT ServiceContractLine.ISEMPTY THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text023,TABLECAPTION,"No.",ServiceContractLine.TABLECAPTION);
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",ServiceContractLine.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckAsmHeader@32(CurrFieldNo@1000 : Integer);
    VAR
      AsmHeader@1004 : Record 900;
    BEGIN
      AsmHeader.SETCURRENTKEY("Document Type","Item No.");
      AsmHeader.SETRANGE("Item No.","No.");
      IF NOT AsmHeader.ISEMPTY THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text023,TABLECAPTION,"No.",AsmHeader.TABLECAPTION);
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",AsmHeader.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CheckAsmLine@27(CurrFieldNo@1000 : Integer);
    VAR
      AsmLine@1003 : Record 901;
    BEGIN
      AsmLine.SETCURRENTKEY(Type,"No.");
      AsmLine.SETRANGE(Type,AsmLine.Type::Item);
      AsmLine.SETRANGE("No.","No.");
      IF NOT AsmLine.ISEMPTY THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text023,TABLECAPTION,"No.",AsmLine.TABLECAPTION);
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",AsmLine.TABLECAPTION);
      END;
    END;

    [External]
    PROCEDURE PreventNegativeInventory@33() : Boolean;
    VAR
      InventorySetup@1000 : Record 313;
    BEGIN
      CASE "Prevent Negative Inventory" OF
        "Prevent Negative Inventory"::Yes:
          EXIT(TRUE);
        "Prevent Negative Inventory"::No:
          EXIT(FALSE);
        "Prevent Negative Inventory"::Default:
          BEGIN
            InventorySetup.GET;
            EXIT(InventorySetup."Prevent Negative Inventory");
          END;
      END;
    END;

    LOCAL PROCEDURE CheckJobPlanningLine@34(CurrFieldNo@1000 : Integer);
    VAR
      JobPlanningLine@1001 : Record 1003;
    BEGIN
      JobPlanningLine.SETCURRENTKEY(Type,"No.");
      JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::Item);
      JobPlanningLine.SETRANGE("No.","No.");
      IF NOT JobPlanningLine.ISEMPTY THEN BEGIN
        IF CurrFieldNo = 0 THEN
          ERROR(Text023,TABLECAPTION,"No.",JobPlanningLine.TABLECAPTION);
        IF CurrFieldNo = FIELDNO(Type) THEN
          ERROR(CannotChangeFieldErr,FIELDCAPTION(Type),TABLECAPTION,"No.",JobPlanningLine.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE CalcVAT@40() : Decimal;
    BEGIN
      IF "Price Includes VAT" THEN BEGIN
        VATPostingSetup.GET("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group");
        CASE VATPostingSetup."VAT Calculation Type" OF
          VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
            VATPostingSetup."VAT %" := 0;
          VATPostingSetup."VAT Calculation Type"::"Sales Tax":
            ERROR(
              Text006,
              VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
              VATPostingSetup."VAT Calculation Type");
        END;
      END ELSE
        CLEAR(VATPostingSetup);

      EXIT(VATPostingSetup."VAT %" / 100);
    END;

    [External]
    PROCEDURE CalcUnitPriceExclVAT@41() : Decimal;
    BEGIN
      GetGLSetup;
      IF 1 + CalcVAT = 0 THEN
        EXIT(0);
      EXIT(ROUND("Unit Price" / (1 + CalcVAT),GLSetup."Unit-Amount Rounding Precision"));
    END;

    [Internal]
    PROCEDURE GetItemNo@10(ItemText@1000 : Text) : Code[20];
    VAR
      ItemNo@1001 : Text[50];
    BEGIN
      TryGetItemNo(ItemNo,ItemText,TRUE);
      EXIT(COPYSTR(ItemNo,1,MAXSTRLEN("No.")));
    END;

    [External]
    PROCEDURE TryGetItemNo@9(VAR ReturnValue@1007 : Text[50];ItemText@1000 : Text;DefaultCreate@1006 : Boolean) : Boolean;
    BEGIN
      EXIT(TryGetItemNoOpenCard(ReturnValue,ItemText,DefaultCreate,TRUE,TRUE));
    END;

    [Internal]
    PROCEDURE TryGetItemNoOpenCard@43(VAR ReturnValue@1007 : Text;ItemText@1000 : Text;DefaultCreate@1006 : Boolean;ShowItemCard@1008 : Boolean;ShowCreateItemOption@1011 : Boolean) : Boolean;
    VAR
      Item@1001 : Record 27;
      SalesLine@1004 : Record 37;
      FindRecordMgt@1009 : Codeunit 703;
      ItemNo@1002 : Code[20];
      ItemWithoutQuote@1005 : Text;
      ItemFilterContains@1003 : Text;
      FoundRecordCount@1010 : Integer;
    BEGIN
      ReturnValue := COPYSTR(ItemText,1,MAXSTRLEN(ReturnValue));
      IF ItemText = '' THEN
        EXIT(DefaultCreate);

      FoundRecordCount := FindRecordMgt.FindRecordByDescription(ReturnValue,SalesLine.Type::Item,ItemText);

      IF FoundRecordCount = 1 THEN
        EXIT(TRUE);

      ReturnValue := COPYSTR(ItemText,1,MAXSTRLEN(ReturnValue));
      IF FoundRecordCount = 0 THEN BEGIN
        IF NOT DefaultCreate THEN
          EXIT(FALSE);

        IF NOT GUIALLOWED THEN
          ERROR(SelectItemErr);

        IF Item.WRITEPERMISSION THEN
          IF ShowCreateItemOption THEN
            CASE STRMENU(
                   STRSUBSTNO('%1,%2',STRSUBSTNO(CreateNewItemTxt,CONVERTSTR(ItemText,',','.')),SelectItemTxt),1,ItemNotRegisteredTxt)
            OF
              0:
                ERROR('');
              1:
                BEGIN
                  ReturnValue := CreateNewItem(COPYSTR(ItemText,1,MAXSTRLEN(Item.Description)),ShowItemCard);
                  EXIT(TRUE);
                END;
            END
          ELSE
            ERROR(SelectOrCreateItemErr);
      END;

      IF NOT GUIALLOWED THEN
        ERROR(SelectItemErr);

      IF FoundRecordCount > 0 THEN BEGIN
        ItemWithoutQuote := CONVERTSTR(ItemText,'''','?');
        ItemFilterContains := '''@*' + ItemWithoutQuote + '*''';
        Item.FILTERGROUP(-1);
        Item.SETFILTER("No.",ItemFilterContains);
        Item.SETFILTER(Description,ItemFilterContains);
        Item.SETFILTER("Base Unit of Measure",ItemFilterContains);
      END;

      IF ShowItemCard THEN
        ItemNo := PickItem(Item)
      ELSE BEGIN
        ReturnValue := '';
        EXIT(TRUE);
      END;

      IF ItemNo <> '' THEN BEGIN
        ReturnValue := ItemNo;
        EXIT(TRUE);
      END;

      IF NOT DefaultCreate THEN
        EXIT(FALSE);
      ERROR('');
    END;

    LOCAL PROCEDURE CreateNewItem@3(ItemName@1000 : Text[50];ShowItemCard@1001 : Boolean) : Code[20];
    VAR
      Item@1005 : Record 27;
      ItemTemplate@1006 : Record 1301;
      ItemCard@1002 : Page 30;
    BEGIN
      IF NOT ItemTemplate.NewItemFromTemplate(Item) THEN
        ERROR(SelectItemErr);

      Item.Description := ItemName;
      Item.MODIFY(TRUE);
      COMMIT;
      IF NOT ShowItemCard THEN
        EXIT(Item."No.");
      Item.SETRANGE("No.",Item."No.");
      ItemCard.SETTABLEVIEW(Item);
      IF NOT (ItemCard.RUNMODAL = ACTION::OK) THEN
        ERROR(SelectItemErr);

      EXIT(Item."No.");
    END;

    PROCEDURE PickItem@51(VAR Item@1000 : Record 27) : Code[20];
    VAR
      ItemList@1001 : Page 31;
    BEGIN
      IF Item.FINDSET THEN
        REPEAT
          Item.MARK(TRUE);
        UNTIL Item.NEXT = 0;
      IF Item.FINDFIRST THEN;
      Item.MARKEDONLY := TRUE;

      ItemList.SETTABLEVIEW(Item);
      ItemList.SETRECORD(Item);
      ItemList.LOOKUPMODE := TRUE;
      IF ItemList.RUNMODAL = ACTION::LookupOK THEN
        ItemList.GETRECORD(Item)
      ELSE
        CLEAR(Item);

      EXIT(Item."No.");
    END;

    LOCAL PROCEDURE SetLastDateTimeModified@16();
    BEGIN
      "Last DateTime Modified" := CURRENTDATETIME;
      "Last Date Modified" := DT2DATE("Last DateTime Modified");
      "Last Time Modified" := DT2TIME("Last DateTime Modified");
    END;

    [External]
    PROCEDURE SetLastDateTimeFilter@29(DateFilter@1001 : DateTime);
    VAR
      DateFilterCalc@1004 : Codeunit 358;
      SyncDateTimeUtc@1002 : DateTime;
      CurrentFilterGroup@1003 : Integer;
    BEGIN
      SyncDateTimeUtc := DateFilterCalc.ConvertToUtcDateTime(DateFilter);
      CurrentFilterGroup := FILTERGROUP;
      SETFILTER("Last Date Modified",'>=%1',DT2DATE(SyncDateTimeUtc));
      FILTERGROUP(-1);
      SETFILTER("Last Date Modified",'>%1',DT2DATE(SyncDateTimeUtc));
      SETFILTER("Last Time Modified",'>%1',DT2TIME(SyncDateTimeUtc));
      FILTERGROUP(CurrentFilterGroup);
    END;

    [External]
    PROCEDURE UpdateReplenishmentSystem@54() : Boolean;
    BEGIN
      CALCFIELDS("Assembly BOM");

      IF "Assembly BOM" THEN BEGIN
        IF NOT ("Replenishment System" IN ["Replenishment System"::Assembly,"Replenishment System"::"Prod. Order"])
        THEN BEGIN
          VALIDATE("Replenishment System","Replenishment System"::Assembly);
          EXIT(TRUE);
        END
      END ELSE
        IF  "Replenishment System" = "Replenishment System"::Assembly THEN BEGIN
          IF "Assembly Policy" <> "Assembly Policy"::"Assemble-to-Order" THEN BEGIN
            VALIDATE("Replenishment System","Replenishment System"::Purchase);
            EXIT(TRUE);
          END
        END
    END;

    PROCEDURE UpdateUnitOfMeasureId@55();
    VAR
      UnitOfMeasure@1000 : Record 204;
    BEGIN
      IF "Base Unit of Measure" = '' THEN BEGIN
        CLEAR("Unit of Measure Id");
        EXIT;
      END;

      IF NOT UnitOfMeasure.GET("Base Unit of Measure") THEN
        EXIT;

      "Unit of Measure Id" := UnitOfMeasure.Id;
    END;

    PROCEDURE UpdateTaxGroupId@47();
    VAR
      TaxGroup@1000 : Record 321;
    BEGIN
      IF "Tax Group Code" = '' THEN BEGIN
        CLEAR("Tax Group Id");
        EXIT;
      END;

      IF NOT TaxGroup.GET("Tax Group Code") THEN
        EXIT;

      "Tax Group Id" := TaxGroup.Id;
    END;

    LOCAL PROCEDURE UpdateUnitOfMeasureCode@48();
    VAR
      UnitOfMeasure@1001 : Record 204;
    BEGIN
      IF NOT ISNULLGUID("Unit of Measure Id") THEN BEGIN
        UnitOfMeasure.SETRANGE(Id,"Unit of Measure Id");
        UnitOfMeasure.FINDFIRST;
      END;

      "Base Unit of Measure" := UnitOfMeasure.Code;
    END;

    LOCAL PROCEDURE UpdateTaxGroupCode@13();
    VAR
      TaxGroup@1001 : Record 321;
    BEGIN
      IF NOT ISNULLGUID("Tax Group Id") THEN BEGIN
        TaxGroup.SETRANGE(Id,"Tax Group Id");
        TaxGroup.FINDFIRST;
      END;

      VALIDATE("Tax Group Code",TaxGroup.Code);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCheckDocuments@74(VAR Item@1000 : Record 27;VAR xItem@1001 : Record 27;VAR CurrentFieldNo@1002 : Integer);
    BEGIN
    END;

    BEGIN
    END.
  }
}

