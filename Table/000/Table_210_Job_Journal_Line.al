OBJECT Table 210 Job Journal Line
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               LOCKTABLE;
               JobJnlTemplate.GET("Journal Template Name");
               JobJnlBatch.GET("Journal Template Name","Journal Batch Name");

               ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
               ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
             END;

    OnModify=BEGIN
               IF (Type = Type::Item) AND (xRec.Type = Type::Item) THEN
                 ReserveJobJnlLine.VerifyChange(Rec,xRec)
               ELSE
                 IF (Type <> Type::Item) AND (xRec.Type = Type::Item) THEN
                   ReserveJobJnlLine.DeleteLine(xRec);
             END;

    OnDelete=BEGIN
               IF Type = Type::Item THEN
                 ReserveJobJnlLine.DeleteLine(Rec);
             END;

    OnRename=BEGIN
               ReserveJobJnlLine.RenameLine(Rec,xRec);
             END;

    CaptionML=[DAN=Sagskladdelinje;
               ENU=Job Journal Line];
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code10       ;TableRelation="Job Journal Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   OnValidate=BEGIN
                                                                IF "Job No." = '' THEN BEGIN
                                                                  VALIDATE("Currency Code",'');
                                                                  VALIDATE("Job Task No.",'');
                                                                  CreateDim(
                                                                    DATABASE::Job,"Job No.",
                                                                    DimMgt.TypeToTableID2(Type),"No.",
                                                                    DATABASE::"Resource Group","Resource Group No.");
                                                                  EXIT;
                                                                END;

                                                                GetJob;
                                                                Job.TestBlocked;
                                                                Job.TESTFIELD("Bill-to Customer No.");
                                                                Cust.GET(Job."Bill-to Customer No.");
                                                                VALIDATE("Job Task No.",'');
                                                                "Customer Price Group" := Job."Customer Price Group";
                                                                VALIDATE("Currency Code",Job."Currency Code");
                                                                CreateDim(
                                                                  DATABASE::Job,"Job No.",
                                                                  DimMgt.TypeToTableID2(Type),"No.",
                                                                  DATABASE::"Resource Group","Resource Group No.");
                                                                VALIDATE("Country/Region Code",Job."Bill-to Country/Region Code");
                                                              END;

                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 4   ;   ;Posting Date        ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Document Date","Posting Date");
                                                                IF "Currency Code" <> '' THEN BEGIN
                                                                  UpdateCurrencyFactor;
                                                                  UpdateAllAmounts;
                                                                END
                                                              END;

                                                   CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 5   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 6   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                VALIDATE("No.",'');
                                                                IF Type = Type::Item THEN BEGIN
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Ressource,Vare,Finanskonto;
                                                                    ENU=Resource,Item,G/L Account];
                                                   OptionString=Resource,Item,G/L Account }
    { 8   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(Resource)) Resource
                                                                 ELSE IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(G/L Account)) "G/L Account";
                                                   OnValidate=BEGIN
                                                                IF ("No." = '') OR ("No." <> xRec."No.") THEN BEGIN
                                                                  Description := '';
                                                                  "Unit of Measure Code" := '';
                                                                  "Qty. per Unit of Measure" := 1;
                                                                  "Variant Code" := '';
                                                                  "Work Type Code" := '';
                                                                  DeleteAmounts;
                                                                  "Cost Factor" := 0;
                                                                  "Applies-to Entry" := 0;
                                                                  "Applies-from Entry" := 0;
                                                                  CheckedAvailability := FALSE;
                                                                  "Job Planning Line No." := 0;
                                                                  IF "No." = '' THEN BEGIN
                                                                    UpdateDimensions;
                                                                    EXIT;
                                                                  END
                                                                END;

                                                                CASE Type OF
                                                                  Type::Resource:
                                                                    CopyFromResource;
                                                                  Type::Item:
                                                                    CopyFromItem;
                                                                  Type::"G/L Account":
                                                                    CopyFromGLAccount;
                                                                END;

                                                                VALIDATE(Quantity);
                                                                UpdateDimensions;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 9   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 10  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                "Quantity (Base)" := CalcBaseQty(Quantity);
                                                                UpdateAllAmounts;

                                                                IF "Job Planning Line No." <> 0 THEN
                                                                  VALIDATE("Job Planning Line No.");

                                                                CheckItemAvailable;
                                                                IF Item."Item Tracking Code" <> '' THEN
                                                                  ReserveJobJnlLine.VerifyQuantity(Rec,xRec);
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 12  ;   ;Direct Unit Cost (LCY);Decimal     ;CaptionML=[DAN=K�bspris (RV);
                                                              ENU=Direct Unit Cost (LCY)];
                                                   MinValue=0;
                                                   AutoFormatType=2 }
    { 13  ;   ;Unit Cost (LCY)     ;Decimal       ;OnValidate=BEGIN
                                                                IF (Type = Type::Item) AND
                                                                   Item.GET("No.") AND
                                                                   (Item."Costing Method" = Item."Costing Method"::Standard)
                                                                THEN
                                                                  UpdateAllAmounts
                                                                ELSE BEGIN
                                                                  InitRoundingPrecisions;
                                                                  "Unit Cost" := ROUND(
                                                                      CurrExchRate.ExchangeAmtLCYToFCY(
                                                                        "Posting Date","Currency Code",
                                                                        "Unit Cost (LCY)","Currency Factor"),
                                                                      UnitAmountRoundingPrecisionFCY);
                                                                  UpdateAllAmounts;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Kostpris (RV);
                                                              ENU=Unit Cost (LCY)];
                                                   MinValue=0;
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 14  ;   ;Total Cost (LCY)    ;Decimal       ;CaptionML=[DAN=Kostbel�b (RV);
                                                              ENU=Total Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 15  ;   ;Unit Price (LCY)    ;Decimal       ;OnValidate=BEGIN
                                                                InitRoundingPrecisions;
                                                                "Unit Price" := ROUND(
                                                                    CurrExchRate.ExchangeAmtLCYToFCY(
                                                                      "Posting Date","Currency Code",
                                                                      "Unit Price (LCY)","Currency Factor"),
                                                                    UnitAmountRoundingPrecisionFCY);
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Enhedspris (RV);
                                                              ENU=Unit Price (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 16  ;   ;Total Price (LCY)   ;Decimal       ;CaptionML=[DAN=Salgsbel�b (RV);
                                                              ENU=Total Price (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 17  ;   ;Resource Group No.  ;Code20        ;TableRelation="Resource Group";
                                                   OnValidate=BEGIN
                                                                CreateDim(
                                                                  DATABASE::"Resource Group","Resource Group No.",
                                                                  DATABASE::Job,"Job No.",
                                                                  DimMgt.TypeToTableID2(Type),"No.");
                                                              END;

                                                   CaptionML=[DAN=Ressourcegruppenr.;
                                                              ENU=Resource Group No.];
                                                   Editable=No }
    { 18  ;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.))
                                                                 ELSE "Unit of Measure";
                                                   OnValidate=VAR
                                                                Resource@1000 : Record 156;
                                                              BEGIN
                                                                GetGLSetup;
                                                                CASE Type OF
                                                                  Type::Item:
                                                                    BEGIN
                                                                      Item.GET("No.");
                                                                      "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                                                                      OnAfterAssignItemUoM(Rec,Item);
                                                                    END;
                                                                  Type::Resource:
                                                                    BEGIN
                                                                      IF CurrFieldNo <> FIELDNO("Work Type Code") THEN
                                                                        IF "Work Type Code" <> '' THEN BEGIN
                                                                          WorkType.GET("Work Type Code");
                                                                          IF WorkType."Unit of Measure Code" <> '' THEN
                                                                            TESTFIELD("Unit of Measure Code",WorkType."Unit of Measure Code");
                                                                        END ELSE
                                                                          TESTFIELD("Work Type Code",'');
                                                                      IF "Unit of Measure Code" = '' THEN BEGIN
                                                                        Resource.GET("No.");
                                                                        "Unit of Measure Code" := Resource."Base Unit of Measure";
                                                                      END;
                                                                      ResUnitofMeasure.GET("No.","Unit of Measure Code");
                                                                      "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                                                                      "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
                                                                      OnAfterAssignResourceUoM(Rec,Res);
                                                                    END;
                                                                  Type::"G/L Account":
                                                                    "Qty. per Unit of Measure" := 1;
                                                                END;
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 21  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                "Bin Code" := '';
                                                                IF "Location Code" <> '' THEN
                                                                  IF IsServiceItem THEN
                                                                    Item.TESTFIELD(Type,Item.Type::Inventory);
                                                                GetLocation("Location Code");
                                                                Location.TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 22  ;   ;Chargeable          ;Boolean       ;InitValue=Yes;
                                                   OnValidate=BEGIN
                                                                IF Chargeable <> xRec.Chargeable THEN
                                                                  IF NOT Chargeable THEN
                                                                    VALIDATE("Unit Price",0)
                                                                  ELSE
                                                                    VALIDATE("No.");
                                                              END;

                                                   CaptionML=[DAN=Fakturerbar;
                                                              ENU=Chargeable] }
    { 30  ;   ;Posting Group       ;Code20        ;TableRelation=IF (Type=CONST(Item)) "Inventory Posting Group";
                                                   CaptionML=[DAN=Sagsbogf�ringsgruppe;
                                                              ENU=Posting Group];
                                                   Editable=No }
    { 31  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 32  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 33  ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Type,Type::Resource);
                                                                VALIDATE("Line Discount %",0);
                                                                IF ("Work Type Code" = '') AND (xRec."Work Type Code" <> '') THEN BEGIN
                                                                  Res.GET("No.");
                                                                  "Unit of Measure Code" := Res."Base Unit of Measure";
                                                                  VALIDATE("Unit of Measure Code");
                                                                END;
                                                                IF WorkType.GET("Work Type Code") THEN
                                                                  IF WorkType."Unit of Measure Code" <> '' THEN BEGIN
                                                                    "Unit of Measure Code" := WorkType."Unit of Measure Code";
                                                                    IF ResUnitofMeasure.GET("No.","Unit of Measure Code") THEN
                                                                      "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                                                                  END ELSE BEGIN
                                                                    Res.GET("No.");
                                                                    "Unit of Measure Code" := Res."Base Unit of Measure";
                                                                    VALIDATE("Unit of Measure Code");
                                                                  END;
                                                                OnBeforeValidateWorkTypeCodeQty(Rec,xRec,Res,WorkType);
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 34  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   OnValidate=BEGIN
                                                                IF (Type = Type::Item) AND ("No." <> '') THEN
                                                                  UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Debitorprisgruppe;
                                                              ENU=Customer Price Group] }
    { 37  ;   ;Applies-to Entry    ;Integer       ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                              BEGIN
                                                                InitRoundingPrecisions;
                                                                TESTFIELD(Type,Type::Item);
                                                                IF "Applies-to Entry" <> 0 THEN BEGIN
                                                                  ItemLedgEntry.GET("Applies-to Entry");
                                                                  TESTFIELD(Quantity);
                                                                  IF Quantity < 0 THEN
                                                                    FIELDERROR(Quantity,Text002);
                                                                  ItemLedgEntry.TESTFIELD(Open,TRUE);
                                                                  ItemLedgEntry.TESTFIELD(Positive,TRUE);
                                                                  "Location Code" := ItemLedgEntry."Location Code";
                                                                  "Variant Code" := ItemLedgEntry."Variant Code";
                                                                  GetItem;
                                                                  IF Item."Costing Method" <> Item."Costing Method"::Standard THEN BEGIN
                                                                    "Unit Cost" := ROUND(
                                                                        CurrExchRate.ExchangeAmtLCYToFCY(
                                                                          "Posting Date","Currency Code",
                                                                          CalcUnitCost(ItemLedgEntry),"Currency Factor"),
                                                                        UnitAmountRoundingPrecisionFCY);
                                                                    UpdateAllAmounts;
                                                                  END;
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              SelectItemEntry(FIELDNO("Applies-to Entry"));
                                                            END;

                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udlign.postl�benr.;
                                                              ENU=Applies-to Entry] }
    { 61  ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Forbrug,Salg;
                                                                    ENU=Usage,Sale];
                                                   OptionString=Usage,Sale;
                                                   Editable=No }
    { 62  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code];
                                                   Editable=No }
    { 73  ;   ;Journal Batch Name  ;Code10        ;TableRelation="Job Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 74  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 75  ;   ;Recurring Method    ;Option        ;CaptionML=[DAN=Gentagelsesprincip;
                                                              ENU=Recurring Method];
                                                   OptionCaptionML=[DAN=,Fast,Variabel;
                                                                    ENU=,Fixed,Variable];
                                                   OptionString=,Fixed,Variable;
                                                   BlankZero=Yes }
    { 76  ;   ;Expiration Date     ;Date          ;CaptionML=[DAN=Udl�bsdato;
                                                              ENU=Expiration Date] }
    { 77  ;   ;Recurring Frequency ;DateFormula   ;CaptionML=[DAN=Gentagelsesinterval;
                                                              ENU=Recurring Frequency] }
    { 79  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 80  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 81  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   CaptionML=[DAN=Transaktionsart;
                                                              ENU=Transaction Type] }
    { 82  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   CaptionML=[DAN=Transportm�de;
                                                              ENU=Transport Method] }
    { 83  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code] }
    { 86  ;   ;Entry/Exit Point    ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=[DAN=Indf�rsels-/udf�rselssted;
                                                              ENU=Entry/Exit Point] }
    { 87  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 88  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 89  ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=[DAN=Omr�de;
                                                              ENU=Area] }
    { 90  ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 91  ;   ;Serial No.          ;Code20        ;OnLookup=BEGIN
                                                              TESTFIELD(Type,Type::Item);
                                                              SelectItemEntry(FIELDNO("Serial No."));
                                                            END;

                                                   CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.] }
    { 92  ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogf�ringsnummerserie;
                                                              ENU=Posting No. Series] }
    { 93  ;   ;Source Currency Code;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Kildevalutakode;
                                                              ENU=Source Currency Code];
                                                   Editable=No }
    { 94  ;   ;Source Currency Total Cost;Decimal ;CaptionML=[DAN=Kildevaluta (kostbel�b);
                                                              ENU=Source Currency Total Cost];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 95  ;   ;Source Currency Total Price;Decimal;CaptionML=[DAN=Kildevaluta (salgsbel�b);
                                                              ENU=Source Currency Total Price];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 96  ;   ;Source Currency Line Amount;Decimal;CaptionML=[DAN=Linjebel�b i kildevaluta;
                                                              ENU=Source Currency Line Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=BEGIN
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 950 ;   ;Time Sheet No.      ;Code20        ;TableRelation="Time Sheet Header";
                                                   CaptionML=[DAN=Timeseddelnr.;
                                                              ENU=Time Sheet No.] }
    { 951 ;   ;Time Sheet Line No. ;Integer       ;TableRelation="Time Sheet Line"."Line No." WHERE (Time Sheet No.=FIELD(Time Sheet No.));
                                                   CaptionML=[DAN=Timeseddellinjenr.;
                                                              ENU=Time Sheet Line No.] }
    { 952 ;   ;Time Sheet Date     ;Date          ;TableRelation="Time Sheet Detail".Date WHERE (Time Sheet No.=FIELD(Time Sheet No.),
                                                                                                 Time Sheet Line No.=FIELD(Time Sheet Line No.));
                                                   CaptionML=[DAN=Dato p� timeseddel;
                                                              ENU=Time Sheet Date] }
    { 1000;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   OnValidate=VAR
                                                                JobTask@1000 : Record 1001;
                                                              BEGIN
                                                                IF ("Job Task No." = '') OR (("Job Task No." <> xRec."Job Task No.") AND (xRec."Job Task No." <> '')) THEN BEGIN
                                                                  VALIDATE("No.",'');
                                                                  EXIT;
                                                                END;

                                                                TESTFIELD("Job No.");
                                                                JobTask.GET("Job No.","Job Task No.");
                                                                JobTask.TESTFIELD("Job Task Type",JobTask."Job Task Type"::Posting);
                                                                UpdateDimensions;
                                                              END;

                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 1001;   ;Total Cost          ;Decimal       ;CaptionML=[DAN=Kostbel�b;
                                                              ENU=Total Cost];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1002;   ;Unit Price          ;Decimal       ;OnValidate=BEGIN
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   MinValue=0;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 1003;   ;Line Type           ;Option        ;OnValidate=BEGIN
                                                                IF "Job Planning Line No." <> 0 THEN
                                                                  ERROR(Text006,FIELDCAPTION("Line Type"),FIELDCAPTION("Job Planning Line No."));
                                                              END;

                                                   CaptionML=[DAN=Linjetype;
                                                              ENU=Line Type];
                                                   OptionCaptionML=[DAN=" ,Budget,Fakturerbar,B�de budget og fakturerbar";
                                                                    ENU=" ,Budget,Billable,Both Budget and Billable"];
                                                   OptionString=[ ,Budget,Billable,Both Budget and Billable] }
    { 1004;   ;Applies-from Entry  ;Integer       ;OnValidate=VAR
                                                                ItemLedgEntry@1000 : Record 32;
                                                              BEGIN
                                                                InitRoundingPrecisions;
                                                                TESTFIELD(Type,Type::Item);
                                                                IF "Applies-from Entry" <> 0 THEN BEGIN
                                                                  TESTFIELD(Quantity);
                                                                  IF Quantity > 0 THEN
                                                                    FIELDERROR(Quantity,Text003);
                                                                  ItemLedgEntry.GET("Applies-from Entry");
                                                                  ItemLedgEntry.TESTFIELD(Positive,FALSE);
                                                                  IF Item."Costing Method" <> Item."Costing Method"::Standard THEN BEGIN
                                                                    "Unit Cost" := ROUND(
                                                                        CurrExchRate.ExchangeAmtLCYToFCY(
                                                                          "Posting Date","Currency Code",
                                                                          CalcUnitCostFrom(ItemLedgEntry),"Currency Factor"),
                                                                        UnitAmountRoundingPrecisionFCY);
                                                                    UpdateAllAmounts;
                                                                  END;
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              SelectItemEntry(FIELDNO("Applies-from Entry"));
                                                            END;

                                                   CaptionML=[DAN=Udlign fra-post;
                                                              ENU=Applies-from Entry];
                                                   MinValue=0 }
    { 1005;   ;Job Posting Only    ;Boolean       ;CaptionML=[DAN=Kun sagsbogf�ring;
                                                              ENU=Job Posting Only] }
    { 1006;   ;Line Discount %     ;Decimal       ;OnValidate=BEGIN
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjerabatpct.;
                                                              ENU=Line Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 1007;   ;Line Discount Amount;Decimal       ;OnValidate=BEGIN
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjerabatbel�b;
                                                              ENU=Line Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1008;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                UpdateCurrencyFactor;
                                                              END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code];
                                                   Editable=No }
    { 1009;   ;Line Amount         ;Decimal       ;OnValidate=BEGIN
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjebel�b;
                                                              ENU=Line Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1010;   ;Currency Factor     ;Decimal       ;OnValidate=BEGIN
                                                                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                                                                  FIELDERROR("Currency Factor",STRSUBSTNO(Text001,FIELDCAPTION("Currency Code")));
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Valutafaktor;
                                                              ENU=Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0;
                                                   Editable=No }
    { 1011;   ;Unit Cost           ;Decimal       ;OnValidate=BEGIN
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 1012;   ;Line Amount (LCY)   ;Decimal       ;OnValidate=BEGIN
                                                                InitRoundingPrecisions;
                                                                "Line Amount" := ROUND(
                                                                    CurrExchRate.ExchangeAmtLCYToFCY(
                                                                      "Posting Date","Currency Code",
                                                                      "Line Amount (LCY)","Currency Factor"),
                                                                    AmountRoundingPrecisionFCY);
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjebel�b (RV);
                                                              ENU=Line Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1013;   ;Line Discount Amount (LCY);Decimal ;OnValidate=BEGIN
                                                                InitRoundingPrecisions;
                                                                "Line Discount Amount" := ROUND(
                                                                    CurrExchRate.ExchangeAmtLCYToFCY(
                                                                      "Posting Date","Currency Code",
                                                                      "Line Discount Amount (LCY)","Currency Factor"),
                                                                    AmountRoundingPrecisionFCY);
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjerabatbel�b (RV);
                                                              ENU=Line Discount Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1014;   ;Total Price         ;Decimal       ;CaptionML=[DAN=Salgsbel�b;
                                                              ENU=Total Price];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1015;   ;Cost Factor         ;Decimal       ;CaptionML=[DAN=Kostfaktor;
                                                              ENU=Cost Factor];
                                                   Editable=No }
    { 1016;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 1017;   ;Ledger Entry Type   ;Option        ;CaptionML=[DAN=Posteringstype;
                                                              ENU=Ledger Entry Type];
                                                   OptionCaptionML=[DAN=" ,Ressource,Vare,Finanskonto";
                                                                    ENU=" ,Resource,Item,G/L Account"];
                                                   OptionString=[ ,Resource,Item,G/L Account] }
    { 1018;   ;Ledger Entry No.    ;Integer       ;TableRelation=IF (Ledger Entry Type=CONST(Resource)) "Res. Ledger Entry"
                                                                 ELSE IF (Ledger Entry Type=CONST(Item)) "Item Ledger Entry"
                                                                 ELSE IF (Ledger Entry Type=CONST(G/L Account)) "G/L Entry";
                                                   CaptionML=[DAN=Posteringsl�benr.;
                                                              ENU=Ledger Entry No.];
                                                   BlankZero=Yes }
    { 1019;   ;Job Planning Line No.;Integer      ;OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 1003;
                                                              BEGIN
                                                                IF "Job Planning Line No." <> 0 THEN BEGIN
                                                                  ValidateJobPlanningLineLink;
                                                                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");

                                                                  JobPlanningLine.TESTFIELD("Job No.","Job No.");
                                                                  JobPlanningLine.TESTFIELD("Job Task No.","Job Task No.");
                                                                  JobPlanningLine.TESTFIELD(Type,Type);
                                                                  JobPlanningLine.TESTFIELD("No.","No.");
                                                                  JobPlanningLine.TESTFIELD("Usage Link",TRUE);
                                                                  JobPlanningLine.TESTFIELD("System-Created Entry",FALSE);

                                                                  "Line Type" := JobPlanningLine."Line Type" + 1;
                                                                  VALIDATE("Remaining Qty.",CalcQtyFromBaseQty(JobPlanningLine."Remaining Qty. (Base)" - "Quantity (Base)"));
                                                                END ELSE
                                                                  VALIDATE("Remaining Qty.",0);
                                                              END;

                                                   OnLookup=VAR
                                                              JobPlanningLine@1000 : Record 1003;
                                                              Resource@1002 : Record 156;
                                                              Filter@1003 : Text;
                                                            BEGIN
                                                              JobPlanningLine.SETRANGE("Job No.","Job No.");
                                                              JobPlanningLine.SETRANGE("Job Task No.","Job Task No.");
                                                              JobPlanningLine.SETRANGE(Type,Type);
                                                              JobPlanningLine.SETRANGE("No.","No.");
                                                              JobPlanningLine.SETRANGE("Usage Link",TRUE);
                                                              JobPlanningLine.SETRANGE("System-Created Entry",FALSE);
                                                              IF Type = Type::Resource THEN BEGIN
                                                                Filter := Resource.GetUnitOfMeasureFilter("No.","Unit of Measure Code");
                                                                JobPlanningLine.SETFILTER("Unit of Measure Code",Filter);
                                                              END;

                                                              IF PAGE.RUNMODAL(0,JobPlanningLine) = ACTION::LookupOK THEN
                                                                VALIDATE("Job Planning Line No.",JobPlanningLine."Line No.");
                                                            END;

                                                   CaptionML=[DAN=Sagsplanl�gningslinjenr.;
                                                              ENU=Job Planning Line No.];
                                                   BlankZero=Yes }
    { 1030;   ;Remaining Qty.      ;Decimal       ;OnValidate=VAR
                                                                JobPlanningLine@1000 : Record 1003;
                                                              BEGIN
                                                                IF ("Remaining Qty." <> 0) AND ("Job Planning Line No." = 0) THEN
                                                                  ERROR(Text004,FIELDCAPTION("Remaining Qty."),FIELDCAPTION("Job Planning Line No."));

                                                                IF "Job Planning Line No." <> 0 THEN BEGIN
                                                                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                                                                  IF JobPlanningLine.Quantity >= 0 THEN BEGIN
                                                                    IF "Remaining Qty." < 0 THEN
                                                                      "Remaining Qty." := 0;
                                                                  END ELSE BEGIN
                                                                    IF "Remaining Qty." > 0 THEN
                                                                      "Remaining Qty." := 0;
                                                                  END;
                                                                END;
                                                                "Remaining Qty. (Base)" := CalcBaseQty("Remaining Qty.");

                                                                CheckItemAvailable;
                                                              END;

                                                   CaptionML=[DAN=Restantal;
                                                              ENU=Remaining Qty.];
                                                   DecimalPlaces=0:5 }
    { 1031;   ;Remaining Qty. (Base);Decimal      ;OnValidate=BEGIN
                                                                VALIDATE("Remaining Qty.",CalcQtyFromBaseQty("Remaining Qty. (Base)"));
                                                              END;

                                                   CaptionML=[DAN=Restantal (basis);
                                                              ENU=Remaining Qty. (Base)] }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   OnValidate=BEGIN
                                                                IF "Variant Code" = '' THEN BEGIN
                                                                  IF Type = Type::Item THEN BEGIN
                                                                    Item.GET("No.");
                                                                    Description := Item.Description;
                                                                    "Description 2" := Item."Description 2";
                                                                    GetItemTranslation;
                                                                  END;
                                                                  EXIT;
                                                                END;

                                                                TESTFIELD(Type,Type::Item);

                                                                ItemVariant.GET("No.","Variant Code");
                                                                Description := ItemVariant.Description;
                                                                "Description 2" := ItemVariant."Description 2";

                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5403;   ;Bin Code            ;Code20        ;OnValidate=BEGIN
                                                                TESTFIELD("Location Code");
                                                                IF "Bin Code" <> '' THEN BEGIN
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Bin Mandatory");
                                                                END;
                                                                TESTFIELD(Type,Type::Item);
                                                                CheckItemAvailable;
                                                                WMSManagement.FindBinContent("Location Code","Bin Code","No.","Variant Code",'')
                                                              END;

                                                   OnLookup=VAR
                                                              BinCode@1000 : Code[20];
                                                            BEGIN
                                                              TESTFIELD("Location Code");
                                                              TESTFIELD(Type,Type::Item);
                                                              BinCode := WMSManagement.BinContentLookUp("Location Code","No.","Variant Code",'',"Bin Code");
                                                              IF BinCode <> '' THEN
                                                                VALIDATE("Bin Code",BinCode);
                                                            END;

                                                   AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5410;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE(Quantity,CalcQtyFromBaseQty("Quantity (Base)"));
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 5468;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Journal Template Name),
                                                                                                                Source Ref. No.=FIELD(Line No.),
                                                                                                                Source Type=CONST(1011),
                                                                                                                Source Subtype=FIELD(Entry Type),
                                                                                                                Source Batch Name=FIELD(Journal Batch Name),
                                                                                                                Source Prod. Order Line=CONST(0),
                                                                                                                Reservation Status=CONST(Reservation)));
                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Reserveret antal (basis);
                                                              ENU=Reserved Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5900;   ;Service Order No.   ;Code20        ;CaptionML=[DAN=Serviceordrenr.;
                                                              ENU=Service Order No.] }
    { 5901;   ;Posted Service Shipment No.;Code20 ;CaptionML=[DAN=Bogf�rt serviceleverancenr.;
                                                              ENU=Posted Service Shipment No.] }
    { 6501;   ;Lot No.             ;Code20        ;CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Journal Template Name,Journal Batch Name,Line No.;
                                                   Clustered=Yes }
    {    ;Journal Template Name,Journal Batch Name,Type,No.,Unit of Measure Code,Work Type Code;
                                                   MaintainSQLIndex=No }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke �ndre %1, n�r %2 er %3.;ENU=You cannot change %1 when %2 is %3.';
      Location@1007 : Record 14;
      Item@1001 : Record 27;
      Res@1002 : Record 156;
      Cust@1039 : Record 18;
      ItemJnlLine@1003 : Record 83;
      GLAcc@1004 : Record 15;
      Job@1005 : Record 167;
      WorkType@1009 : Record 200;
      JobJnlTemplate@1011 : Record 209;
      JobJnlBatch@1012 : Record 237;
      JobJnlLine@1013 : Record 210;
      ItemVariant@1015 : Record 5401;
      ResUnitofMeasure@1008 : Record 205;
      ResCost@1018 : Record 202;
      ItemTranslation@1040 : Record 30;
      CurrExchRate@1029 : Record 330;
      SKU@1028 : Record 5700;
      GLSetup@1010 : Record 98;
      ItemCheckAvail@1020 : Codeunit 311;
      NoSeriesMgt@1021 : Codeunit 396;
      UOMMgt@1022 : Codeunit 5402;
      DimMgt@1023 : Codeunit 408;
      ReserveJobJnlLine@1032 : Codeunit 99000844;
      WMSManagement@1035 : Codeunit 7302;
      DontCheckStandardCost@1037 : Boolean;
      Text001@1060 : TextConst 'DAN=m� ikke indtastes uden %1;ENU=cannot be specified without %1';
      Text002@1033 : TextConst 'DAN=skal v�re positiv;ENU=must be positive';
      Text003@1038 : TextConst 'DAN=skal v�re negativ;ENU=must be negative';
      HasGotGLSetup@1016 : Boolean;
      CurrencyDate@1030 : Date;
      UnitAmountRoundingPrecision@1024 : Decimal;
      AmountRoundingPrecision@1025 : Decimal;
      UnitAmountRoundingPrecisionFCY@1026 : Decimal;
      AmountRoundingPrecisionFCY@1036 : Decimal;
      CheckedAvailability@1017 : Boolean;
      Text004@1019 : TextConst 'DAN=%1 kan kun redigeres, n�r en %2 er defineret.;ENU=%1 is only editable when a %2 is defined.';
      Text006@1034 : TextConst 'DAN=%1 kan ikke �ndres, n�r %2 er angivet.;ENU=%1 cannot be changed when %2 is set.';
      Text007@1006 : TextConst '@@@=Job Journal Line job DEFAULT 30000 is already linked to Job Planning Line  DEERFIELD, 8 WP 1120 10000. Hence Remaining Qty. cannot be calculated correctly. Posting the line may update the linked %3 unexpectedly. Do you want to continue?;DAN=%1 %2 er allerede knyttet til %3 %4. Derfor kan %5 ikke beregnes korrekt. Hvis linjen bogf�res, opdateres den tilknyttede %3 m�ske uventet. Vil du forts�tte?;ENU=%1 %2 is already linked to %3 %4. Hence %5 cannot be calculated correctly. Posting the line may update the linked %3 unexpectedly. Do you want to continue?';

    LOCAL PROCEDURE CalcBaseQty@14(Qty@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE CalcQtyFromBaseQty@20(BaseQty@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(BaseQty / "Qty. per Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE CopyFromResource@27();
    VAR
      Resource@1000 : Record 156;
    BEGIN
      Resource.GET("No.");
      Resource.CheckResourcePrivacyBlocked(FALSE);
      Resource.TESTFIELD(Blocked,FALSE);
      Description := Resource.Name;
      "Description 2" := Resource."Name 2";
      "Resource Group No." := Resource."Resource Group No.";
      "Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
      VALIDATE("Unit of Measure Code",Resource."Base Unit of Measure");
      IF "Time Sheet No." = '' THEN
        Resource.TESTFIELD("Use Time Sheet",FALSE);

      OnAfterAssignResourceValues(Rec,Res);
    END;

    LOCAL PROCEDURE CopyFromItem@30();
    BEGIN
      GetItem;
      Item.TESTFIELD(Blocked,FALSE);
      Description := Item.Description;
      "Description 2" := Item."Description 2";
      GetJob;
      IF Job."Language Code" <> '' THEN
        GetItemTranslation;
      "Posting Group" := Item."Inventory Posting Group";
      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
      VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");

      OnAfterAssignItemValues(Rec,Item);
    END;

    LOCAL PROCEDURE CopyFromGLAccount@38();
    BEGIN
      GLAcc.GET("No.");
      GLAcc.CheckGLAcc;
      GLAcc.TESTFIELD("Direct Posting",TRUE);
      Description := GLAcc.Name;
      "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
      "Unit of Measure Code" := '';
      "Direct Unit Cost (LCY)" := 0;
      "Unit Cost (LCY)" := 0;
      "Unit Price" := 0;

      OnAfterAssignGLAccountValues(Rec,GLAcc);
    END;

    LOCAL PROCEDURE CheckItemAvailable@5();
    VAR
      JobPlanningLine@1000 : Record 1003;
    BEGIN
      IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND (Quantity > 0) AND NOT CheckedAvailability THEN BEGIN
        ItemJnlLine."Item No." := "No.";
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
        ItemJnlLine."Location Code" := "Location Code";
        ItemJnlLine."Variant Code" := "Variant Code";
        ItemJnlLine."Bin Code" := "Bin Code";
        ItemJnlLine."Unit of Measure Code" := "Unit of Measure Code";
        ItemJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
        IF "Job Planning Line No." = 0 THEN
          ItemJnlLine.Quantity := Quantity
        ELSE BEGIN
          JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
          IF JobPlanningLine."Remaining Qty." < (Quantity + "Remaining Qty.") THEN
            ItemJnlLine.Quantity := (Quantity + "Remaining Qty.") - JobPlanningLine."Remaining Qty."
          ELSE
            EXIT;
        END;
        IF ItemCheckAvail.ItemJnlCheckLine(ItemJnlLine) THEN
          ItemCheckAvail.RaiseUpdateInterruptedError;
        CheckedAvailability := TRUE;
      END;
    END;

    [External]
    PROCEDURE EmptyLine@8() : Boolean;
    BEGIN
      EXIT(("Job No." = '') AND ("No." = '') AND (Quantity = 0));
    END;

    [External]
    PROCEDURE SetUpNewLine@9(LastJobJnlLine@1000 : Record 210);
    BEGIN
      JobJnlTemplate.GET("Journal Template Name");
      JobJnlBatch.GET("Journal Template Name","Journal Batch Name");
      JobJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
      JobJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
      IF JobJnlLine.FINDFIRST THEN BEGIN
        "Posting Date" := LastJobJnlLine."Posting Date";
        "Document Date" := LastJobJnlLine."Posting Date";
        "Document No." := LastJobJnlLine."Document No.";
        Type := LastJobJnlLine.Type;
        VALIDATE("Line Type",LastJobJnlLine."Line Type");
      END ELSE BEGIN
        "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
        IF JobJnlBatch."No. Series" <> '' THEN BEGIN
          CLEAR(NoSeriesMgt);
          "Document No." := NoSeriesMgt.TryGetNextNo(JobJnlBatch."No. Series","Posting Date");
        END;
      END;
      "Recurring Method" := LastJobJnlLine."Recurring Method";
      "Entry Type" := "Entry Type"::Usage;
      "Source Code" := JobJnlTemplate."Source Code";
      "Reason Code" := JobJnlBatch."Reason Code";
      "Posting No. Series" := JobJnlBatch."Posting No. Series";
    END;

    LOCAL PROCEDURE CreateDim@13(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20]);
    VAR
      TableID@1006 : ARRAY [10] OF Integer;
      No@1007 : ARRAY [10] OF Code[20];
    BEGIN
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,"Source Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@10(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE LookupShortcutDimCode@18(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE ShowShortcutDimCode@15(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    END;

    LOCAL PROCEDURE GetLocation@7300(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE GetJob@16();
    BEGIN
      TESTFIELD("Job No.");
      IF "Job No." <> Job."No." THEN
        Job.GET("Job No.");
    END;

    LOCAL PROCEDURE UpdateCurrencyFactor@17();
    BEGIN
      IF "Currency Code" <> '' THEN BEGIN
        IF "Posting Date" = 0D THEN
          CurrencyDate := WORKDATE
        ELSE
          CurrencyDate := "Posting Date";
        "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
      END ELSE
        "Currency Factor" := 0;
    END;

    LOCAL PROCEDURE GetItem@19();
    BEGIN
      TESTFIELD("No.");
      IF "No." <> Item."No." THEN
        Item.GET("No.");
    END;

    LOCAL PROCEDURE GetSKU@5806() : Boolean;
    BEGIN
      IF (SKU."Location Code" = "Location Code") AND
         (SKU."Item No." = "No.") AND
         (SKU."Variant Code" = "Variant Code")
      THEN
        EXIT(TRUE);

      IF SKU.GET("Location Code","No.","Variant Code") THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE IsInbound@7() : Boolean;
    BEGIN
      IF "Entry Type" IN ["Entry Type"::Usage,"Entry Type"::Sale] THEN
        EXIT("Quantity (Base)" < 0);

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE OpenItemTrackingLines@6500(IsReclass@1000 : Boolean);
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      ReserveJobJnlLine.CallItemTracking(Rec,IsReclass);
    END;

    LOCAL PROCEDURE InitRoundingPrecisions@23();
    VAR
      Currency@1000 : Record 4;
    BEGIN
      IF (AmountRoundingPrecision = 0) OR
         (UnitAmountRoundingPrecision = 0) OR
         (AmountRoundingPrecisionFCY = 0) OR
         (UnitAmountRoundingPrecisionFCY = 0)
      THEN BEGIN
        CLEAR(Currency);
        Currency.InitRoundingPrecision;
        AmountRoundingPrecision := Currency."Amount Rounding Precision";
        UnitAmountRoundingPrecision := Currency."Unit-Amount Rounding Precision";

        IF "Currency Code" <> '' THEN BEGIN
          Currency.GET("Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
          Currency.TESTFIELD("Unit-Amount Rounding Precision");
        END;

        AmountRoundingPrecisionFCY := Currency."Amount Rounding Precision";
        UnitAmountRoundingPrecisionFCY := Currency."Unit-Amount Rounding Precision";
      END;
    END;

    [External]
    PROCEDURE DontCheckStdCost@26();
    BEGIN
      DontCheckStandardCost := TRUE;
    END;

    LOCAL PROCEDURE CalcUnitCost@5809(ItemLedgEntry@1000 : Record 32) : Decimal;
    VAR
      ValueEntry@1001 : Record 5802;
      UnitCost@1004 : Decimal;
    BEGIN
      ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
      ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
      ValueEntry.CALCSUMS("Cost Amount (Actual)","Cost Amount (Expected)");
      UnitCost :=
        (ValueEntry."Cost Amount (Expected)" + ValueEntry."Cost Amount (Actual)") / ItemLedgEntry.Quantity;

      EXIT(ABS(UnitCost * "Qty. per Unit of Measure"));
    END;

    LOCAL PROCEDURE CalcUnitCostFrom@5804(ItemLedgEntry@1000 : Record 32) : Decimal;
    VAR
      ValueEntry@1001 : Record 5802;
    BEGIN
      ValueEntry.RESET;
      ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
      ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
      ValueEntry.CALCSUMS("Cost Amount (Actual)","Cost Amount (Expected)");
      EXIT(
        (ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)") /
        ItemLedgEntry.Quantity * "Qty. per Unit of Measure");
    END;

    LOCAL PROCEDURE SelectItemEntry@1(CurrentFieldNo@1000 : Integer);
    VAR
      ItemLedgEntry@1001 : Record 32;
      JobJnlLine2@1002 : Record 210;
    BEGIN
      ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code");
      ItemLedgEntry.SETRANGE("Item No.","No.");
      ItemLedgEntry.SETRANGE(Correction,FALSE);

      IF "Location Code" <> '' THEN
        ItemLedgEntry.SETRANGE("Location Code","Location Code");

      IF CurrentFieldNo = FIELDNO("Applies-to Entry") THEN BEGIN
        ItemLedgEntry.SETRANGE(Positive,TRUE);
        ItemLedgEntry.SETRANGE(Open,TRUE);
      END ELSE
        ItemLedgEntry.SETRANGE(Positive,FALSE);

      IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
        JobJnlLine2 := Rec;
        IF CurrentFieldNo = FIELDNO("Applies-to Entry") THEN
          JobJnlLine2.VALIDATE("Applies-to Entry",ItemLedgEntry."Entry No.")
        ELSE
          JobJnlLine2.VALIDATE("Applies-from Entry",ItemLedgEntry."Entry No.");
        Rec := JobJnlLine2;
      END;
    END;

    [External]
    PROCEDURE DeleteAmounts@4();
    BEGIN
      Quantity := 0;
      "Quantity (Base)" := 0;
      "Direct Unit Cost (LCY)" := 0;
      "Unit Cost (LCY)" := 0;
      "Unit Cost" := 0;
      "Total Cost (LCY)" := 0;
      "Total Cost" := 0;
      "Unit Price (LCY)" := 0;
      "Unit Price" := 0;
      "Total Price (LCY)" := 0;
      "Total Price" := 0;
      "Line Amount (LCY)" := 0;
      "Line Amount" := 0;
      "Line Discount %" := 0;
      "Line Discount Amount (LCY)" := 0;
      "Line Discount Amount" := 0;
      "Remaining Qty." := 0;
      "Remaining Qty. (Base)" := 0;

      OnAfterDeleteAmounts(Rec);
    END;

    [External]
    PROCEDURE SetCurrencyFactor@11(Factor@1000 : Decimal);
    BEGIN
      "Currency Factor" := Factor;
    END;

    LOCAL PROCEDURE GetItemTranslation@42();
    BEGIN
      GetJob;
      IF ItemTranslation.GET("No.","Variant Code",Job."Language Code") THEN BEGIN
        Description := ItemTranslation.Description;
        "Description 2" := ItemTranslation."Description 2";
      END;
    END;

    LOCAL PROCEDURE GetGLSetup@24();
    BEGIN
      IF HasGotGLSetup THEN
        EXIT;
      GLSetup.GET;
      HasGotGLSetup := TRUE;
    END;

    LOCAL PROCEDURE UpdateAllAmounts@37();
    BEGIN
      OnBeforeUpdateAllAmounts(Rec,xRec);
      InitRoundingPrecisions;

      UpdateUnitCost;
      UpdateTotalCost;
      FindPriceAndDiscount(Rec,CurrFieldNo);
      HandleCostFactor;
      UpdateUnitPrice;
      UpdateTotalPrice;
      UpdateAmountsAndDiscounts;

      OnAfterUpdateAllAmounts(Rec,xRec);
    END;

    LOCAL PROCEDURE UpdateUnitCost@36();
    VAR
      RetrievedCost@1000 : Decimal;
    BEGIN
      IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
        IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
          IF NOT DontCheckStandardCost THEN BEGIN
            // Prevent manual change of unit cost on items with standard cost
            IF (("Unit Cost" <> xRec."Unit Cost") OR ("Unit Cost (LCY)" <> xRec."Unit Cost (LCY)")) AND
               (("No." = xRec."No.") AND ("Location Code" = xRec."Location Code") AND
                ("Variant Code" = xRec."Variant Code") AND ("Unit of Measure Code" = xRec."Unit of Measure Code"))
            THEN
              ERROR(
                Text000,
                FIELDCAPTION("Unit Cost"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
          END;
          IF RetrieveCostPrice THEN BEGIN
            IF GetSKU THEN
              "Unit Cost (LCY)" := ROUND(SKU."Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision)
            ELSE
              "Unit Cost (LCY)" := ROUND(Item."Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision);
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",
                  "Unit Cost (LCY)","Currency Factor"),
                UnitAmountRoundingPrecisionFCY);
          END ELSE BEGIN
            IF "Unit Cost" <> xRec."Unit Cost" THEN
              "Unit Cost (LCY)" := ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    "Posting Date","Currency Code",
                    "Unit Cost","Currency Factor"),
                  UnitAmountRoundingPrecision)
            ELSE
              "Unit Cost" := ROUND(
                  CurrExchRate.ExchangeAmtLCYToFCY(
                    "Posting Date","Currency Code",
                    "Unit Cost (LCY)","Currency Factor"),
                  UnitAmountRoundingPrecisionFCY);
          END;
        END ELSE BEGIN
          IF RetrieveCostPrice THEN BEGIN
            IF GetSKU THEN
              RetrievedCost := SKU."Unit Cost" * "Qty. per Unit of Measure"
            ELSE
              RetrievedCost := Item."Unit Cost" * "Qty. per Unit of Measure";
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",
                  RetrievedCost,"Currency Factor"),
                UnitAmountRoundingPrecisionFCY);
            "Unit Cost (LCY)" := ROUND(RetrievedCost,UnitAmountRoundingPrecision);
          END ELSE
            "Unit Cost (LCY)" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  "Posting Date","Currency Code",
                  "Unit Cost","Currency Factor"),
                UnitAmountRoundingPrecision);
        END;
      END ELSE
        IF (Type = Type::Resource) AND Res.GET("No.") THEN BEGIN
          IF RetrieveCostPrice THEN BEGIN
            ResCost.INIT;
            ResCost.Code := "No.";
            ResCost."Work Type Code" := "Work Type Code";
            CODEUNIT.RUN(CODEUNIT::"Resource-Find Cost",ResCost);
            "Direct Unit Cost (LCY)" := ROUND(ResCost."Direct Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision);
            RetrievedCost := ResCost."Unit Cost" * "Qty. per Unit of Measure";
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",
                  RetrievedCost,"Currency Factor"),
                UnitAmountRoundingPrecisionFCY);
            "Unit Cost (LCY)" := ROUND(RetrievedCost,UnitAmountRoundingPrecision);
          END ELSE
            "Unit Cost (LCY)" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  "Posting Date","Currency Code",
                  "Unit Cost","Currency Factor"),
                UnitAmountRoundingPrecision);
        END ELSE
          "Unit Cost (LCY)" := ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                "Posting Date","Currency Code",
                "Unit Cost","Currency Factor"),
              UnitAmountRoundingPrecision);
    END;

    LOCAL PROCEDURE RetrieveCostPrice@35() : Boolean;
    BEGIN
      CASE Type OF
        Type::Item:
          IF ("No." <> xRec."No.") OR
             ("Location Code" <> xRec."Location Code") OR
             ("Variant Code" <> xRec."Variant Code") OR
             (Quantity <> xRec.Quantity) OR
             ("Unit of Measure Code" <> xRec."Unit of Measure Code") AND
             (("Applies-to Entry" = 0) AND ("Applies-from Entry" = 0))
          THEN
            EXIT(TRUE);
        Type::Resource:
          IF ("No." <> xRec."No.") OR
             ("Work Type Code" <> xRec."Work Type Code") OR
             ("Unit of Measure Code" <> xRec."Unit of Measure Code")
          THEN
            EXIT(TRUE);
        Type::"G/L Account":
          IF "No." <> xRec."No." THEN
            EXIT(TRUE);
        ELSE
          EXIT(FALSE);
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE UpdateTotalCost@34();
    BEGIN
      "Total Cost" := ROUND("Unit Cost" * Quantity,AmountRoundingPrecisionFCY);
      "Total Cost (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Currency Code","Total Cost","Currency Factor"),AmountRoundingPrecision);

      OnAfterUpdateTotalCost(Rec);
    END;

    LOCAL PROCEDURE FindPriceAndDiscount@33(VAR JobJnlLine@1000 : Record 210;CalledByFieldNo@1001 : Integer);
    VAR
      SalesPriceCalcMgt@1002 : Codeunit 7000;
      PurchPriceCalcMgt@1003 : Codeunit 7010;
    BEGIN
      IF RetrieveCostPrice AND ("No." <> '') THEN BEGIN
        SalesPriceCalcMgt.FindJobJnlLinePrice(JobJnlLine,CalledByFieldNo);

        IF Type <> Type::"G/L Account" THEN
          PurchPriceCalcMgt.FindJobJnlLinePrice(JobJnlLine,CalledByFieldNo)
        ELSE BEGIN
          // Because the SalesPriceCalcMgt.FindJobJnlLinePrice function also retrieves costs for G/L Account,
          // cost and total cost need to get updated again.
          UpdateUnitCost;
          UpdateTotalCost;
        END;
      END;
    END;

    LOCAL PROCEDURE HandleCostFactor@32();
    BEGIN
      IF ("Cost Factor" <> 0) AND
         ((("Unit Cost" <> xRec."Unit Cost") OR ("Cost Factor" <> xRec."Cost Factor")) OR
          ((Quantity <> xRec.Quantity) OR ("Location Code" <> xRec."Location Code")))
      THEN
        "Unit Price" := ROUND("Unit Cost" * "Cost Factor",UnitAmountRoundingPrecisionFCY)
      ELSE
        IF (Item."Price/Profit Calculation" = Item."Price/Profit Calculation"::"Price=Cost+Profit") AND
           (Item."Profit %" < 100) AND
           ("Unit Cost" <> xRec."Unit Cost")
        THEN
          "Unit Price" := ROUND("Unit Cost" / (1 - Item."Profit %" / 100),UnitAmountRoundingPrecisionFCY);
    END;

    LOCAL PROCEDURE UpdateUnitPrice@25();
    BEGIN
      "Unit Price (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Currency Code",
            "Unit Price","Currency Factor"),
          UnitAmountRoundingPrecision);
    END;

    LOCAL PROCEDURE UpdateTotalPrice@6();
    BEGIN
      "Total Price" := Quantity * "Unit Price";
      "Total Price (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Currency Code","Total Price","Currency Factor"),AmountRoundingPrecision);
      "Total Price" := ROUND("Total Price",AmountRoundingPrecisionFCY);

      OnAfterUpdateTotalPrice(Rec);
    END;

    LOCAL PROCEDURE UpdateAmountsAndDiscounts@31();
    BEGIN
      IF "Total Price" <> 0 THEN BEGIN
        IF ("Line Amount" <> xRec."Line Amount") AND ("Line Discount Amount" = xRec."Line Discount Amount") THEN BEGIN
          "Line Amount" := ROUND("Line Amount",AmountRoundingPrecisionFCY);
          "Line Discount Amount" := "Total Price" - "Line Amount";
          "Line Amount (LCY)" := ROUND("Line Amount (LCY)",AmountRoundingPrecision);
          "Line Discount Amount (LCY)" := "Total Price (LCY)" - "Line Amount (LCY)";
          "Line Discount %" := ROUND("Line Discount Amount" / "Total Price" * 100,0.00001);
        END ELSE
          IF ("Line Discount Amount" <> xRec."Line Discount Amount") AND ("Line Amount" = xRec."Line Amount") THEN BEGIN
            "Line Discount Amount" := ROUND("Line Discount Amount",AmountRoundingPrecisionFCY);
            "Line Amount" := "Total Price" - "Line Discount Amount";
            "Line Discount Amount (LCY)" := ROUND("Line Discount Amount (LCY)",AmountRoundingPrecision);
            "Line Amount (LCY)" := "Total Price (LCY)" - "Line Discount Amount (LCY)";
            "Line Discount %" := ROUND("Line Discount Amount" / "Total Price" * 100,0.00001);
          END ELSE
            IF ("Line Discount Amount" <> xRec."Line Discount Amount") OR ("Line Amount" <> xRec."Line Amount") OR
               ("Total Price" <> xRec."Total Price") OR ("Line Discount %" <> xRec."Line Discount %")
            THEN BEGIN
              "Line Discount Amount" := ROUND("Total Price" * "Line Discount %" / 100,AmountRoundingPrecisionFCY);
              "Line Amount" := "Total Price" - "Line Discount Amount";
              "Line Discount Amount (LCY)" := ROUND("Total Price (LCY)" * "Line Discount %" / 100,AmountRoundingPrecision);
              "Line Amount (LCY)" := "Total Price (LCY)" - "Line Discount Amount (LCY)";
            END;
      END ELSE BEGIN
        "Line Amount" := 0;
        "Line Discount Amount" := 0;
        "Line Amount (LCY)" := 0;
        "Line Discount Amount (LCY)" := 0;
      END;

      OnAfterUpdateAmountsAndDiscounts(Rec);
    END;

    LOCAL PROCEDURE ValidateJobPlanningLineLink@3();
    VAR
      JobPlanningLine@1000 : Record 1003;
      JobJournalLine@1001 : Record 210;
    BEGIN
      JobJournalLine.SETRANGE("Job No.","Job No.");
      JobJournalLine.SETRANGE("Job Task No.","Job Task No.");
      JobJournalLine.SETRANGE("Job Planning Line No.","Job Planning Line No.");

      IF JobJournalLine.FINDFIRST THEN
        IF ("Journal Template Name" <> JobJournalLine."Journal Template Name") OR
           ("Journal Batch Name" <> JobJournalLine."Journal Batch Name") OR
           ("Line No." <> JobJournalLine."Line No.")
        THEN BEGIN
          JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
          IF NOT CONFIRM(Text007,FALSE,
               TABLECAPTION,
               STRSUBSTNO('%1, %2, %3',"Journal Template Name","Journal Batch Name","Line No."),
               JobPlanningLine.TABLECAPTION,
               STRSUBSTNO('%1, %2, %3',JobPlanningLine."Job No.",JobPlanningLine."Job Task No.",JobPlanningLine."Line No."),
               FIELDCAPTION("Remaining Qty."))
          THEN
            ERROR('');
        END;
    END;

    [External]
    PROCEDURE ShowDimensions@2();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."));
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE UpdateDimensions@12();
    VAR
      DimensionSetIDArr@1000 : ARRAY [10] OF Integer;
    BEGIN
      CreateDim(
        DimMgt.TypeToTableID2(Type),"No.",
        DATABASE::Job,"Job No.",
        DATABASE::"Resource Group","Resource Group No.");
      IF "Job Task No." <> '' THEN BEGIN
        DimensionSetIDArr[1] := "Dimension Set ID";
        DimensionSetIDArr[2] :=
          DimMgt.CreateDimSetFromJobTaskDim("Job No.",
            "Job Task No.","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        DimMgt.CreateDimForJobJournalLineWithHigherPriorities(
          Rec,CurrFieldNo,DimensionSetIDArr[3],"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Source Code",DATABASE::Job);
        "Dimension Set ID" :=
          DimMgt.GetCombinedDimensionSetID(
            DimensionSetIDArr,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      END
    END;

    [External]
    PROCEDURE IsOpenedFromBatch@22() : Boolean;
    VAR
      JobJournalBatch@1002 : Record 237;
      TemplateFilter@1001 : Text;
      BatchFilter@1000 : Text;
    BEGIN
      BatchFilter := GETFILTER("Journal Batch Name");
      IF BatchFilter <> '' THEN BEGIN
        TemplateFilter := GETFILTER("Journal Template Name");
        IF TemplateFilter <> '' THEN
          JobJournalBatch.SETFILTER("Journal Template Name",TemplateFilter);
        JobJournalBatch.SETFILTER(Name,BatchFilter);
        JobJournalBatch.FINDFIRST;
      END;

      EXIT((("Journal Batch Name" <> '') AND ("Journal Template Name" = '')) OR (BatchFilter <> ''));
    END;

    [External]
    PROCEDURE IsServiceItem@68() : Boolean;
    BEGIN
      IF Type <> Type::Item THEN
        EXIT(FALSE);
      IF "No." = '' THEN
        EXIT(FALSE);
      GetItem;
      EXIT(Item.Type = Item.Type::Service);
    END;

    [External]
    PROCEDURE RowID1@44() : Text[250];
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
    BEGIN
      EXIT(
        ItemTrackingMgt.ComposeRowID(DATABASE::"Job Journal Line","Entry Type",
          "Journal Template Name","Journal Batch Name",0,"Line No."));
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignGLAccountValues@39(VAR JobJournalLine@1000 : Record 210;GLAccount@1001 : Record 15);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignItemValues@136(VAR JobJournalLine@1000 : Record 210;Item@1001 : Record 27);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignResourceValues@29(VAR JobJournalLine@1000 : Record 210;Resource@1001 : Record 156);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignItemUoM@43(VAR JobJournalLine@1000 : Record 210;Item@1001 : Record 27);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterAssignResourceUoM@45(VAR JobJournalLine@1000 : Record 210;Resource@1001 : Record 156);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterDeleteAmounts@41(VAR JobJournalLine@1000 : Record 210);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateTotalCost@46(VAR JobJournalLine@1000 : Record 210);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateTotalPrice@47(VAR JobJournalLine@1000 : Record 210);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateAmountsAndDiscounts@48(VAR JobJournalLine@1000 : Record 210);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@164(VAR JobJournalLine@1000 : Record 210;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeValidateWorkTypeCodeQty@40(VAR JobJournalLine@1000 : Record 210;xJobJournalLine@1001 : Record 210;Resource@1002 : Record 156;WorkType@1003 : Record 200);
    BEGIN
    END;

    [Integration(TRUE,TRUE)]
    LOCAL PROCEDURE OnBeforeUpdateAllAmounts@1001(VAR JobJournalLine@1000 : Record 210;xJobJournalLine@1001 : Record 210);
    BEGIN
    END;

    [Integration(TRUE,TRUE)]
    LOCAL PROCEDURE OnAfterUpdateAllAmounts@1002(VAR JobJournalLine@1000 : Record 210;xJobJournalLine@1001 : Record 210);
    BEGIN
    END;

    BEGIN
    END.
  }
}

