OBJECT Table 1003 Job Planning Line
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               LOCKTABLE;
               GetJob;
               IF Job.Blocked = Job.Blocked::All THEN
                 Job.TestBlocked;
               JobTask.GET("Job No.","Job Task No.");
               JobTask.TESTFIELD("Job Task Type",JobTask."Job Task Type"::Posting);
               InitJobPlanningLine;
               IF Quantity <> 0 THEN
                 UpdateReservation(0);

               IF "Schedule Line" THEN
                 Job.UpdateOverBudgetValue("Job No.",FALSE,"Total Cost (LCY)");
             END;

    OnModify=BEGIN
               "Last Date Modified" := TODAY;
               "User ID" := USERID;

               IF ((Quantity <> 0) OR (xRec.Quantity <> 0)) AND ItemExists(xRec."No.") THEN
                 UpdateReservation(0);

               IF "Schedule Line" THEN
                 Job.UpdateOverBudgetValue("Job No.",FALSE,"Total Cost (LCY)");
             END;

    OnDelete=VAR
               JobUsageLink@1000 : Record 1020;
             BEGIN
               ValidateModification(TRUE);
               CheckRelatedJobPlanningLineInvoice;

               IF "Usage Link" THEN BEGIN
                 JobUsageLink.SETRANGE("Job No.","Job No.");
                 JobUsageLink.SETRANGE("Job Task No.","Job Task No.");
                 JobUsageLink.SETRANGE("Line No.","Line No.");
                 IF NOT JobUsageLink.ISEMPTY THEN
                   ERROR(JobUsageLinkErr,TABLECAPTION);
               END;

               IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
                 JobPlanningLineReserve.DeleteLine(Rec);
                 CALCFIELDS("Reserved Qty. (Base)");
                 TESTFIELD("Reserved Qty. (Base)",0);
               END;

               IF "Schedule Line" THEN
                 Job.UpdateOverBudgetValue("Job No.",FALSE,"Total Cost (LCY)");
             END;

    OnRename=BEGIN
               ERROR(RecordRenameErr,FIELDCAPTION("Job No."),FIELDCAPTION("Job Task No."),TABLECAPTION);
             END;

    CaptionML=[DAN=Sagsplanl�gningslinje;
               ENU=Job Planning Line];
    LookupPageID=Page1007;
    DrillDownPageID=Page1007;
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.];
                                                   Editable=No }
    { 2   ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.];
                                                   NotBlank=Yes }
    { 3   ;   ;Planning Date       ;Date          ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Planning Date" <> "Planning Date");

                                                                VALIDATE("Document Date","Planning Date");
                                                                IF ("Currency Date" = 0D) OR ("Currency Date" = xRec."Planning Date") THEN
                                                                  VALIDATE("Currency Date","Planning Date");
                                                                IF (Type <> Type::Text) AND ("No." <> '') THEN
                                                                  UpdateAllAmounts;
                                                                IF "Planning Date" <> 0D THEN
                                                                  CheckItemAvailable(FIELDNO("Planning Date"));
                                                                IF CurrFieldNo = FIELDNO("Planned Delivery Date") THEN
                                                                  UpdateReservation(CurrFieldNo)
                                                                ELSE
                                                                  UpdateReservation(FIELDNO("Planning Date"));
                                                                "Planned Delivery Date" := "Planning Date";
                                                              END;

                                                   CaptionML=[DAN=Planl�gningsdato;
                                                              ENU=Planning Date] }
    { 4   ;   ;Document No.        ;Code20        ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Document No." <> "Document No.");
                                                              END;

                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 5   ;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                ValidateModification(xRec.Type <> Type);

                                                                UpdateReservation(FIELDNO(Type));

                                                                VALIDATE("No.",'');
                                                                IF Type = Type::Item THEN BEGIN
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Ressource,Vare,Finanskonto,Tekst;
                                                                    ENU=Resource,Item,G/L Account,Text];
                                                   OptionString=Resource,Item,G/L Account,Text }
    { 7   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(Resource)) Resource
                                                                 ELSE IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Type=CONST(Text)) "Standard Text";
                                                   OnValidate=BEGIN
                                                                ValidateModification(xRec."No." <> "No.");

                                                                CheckUsageLinkRelations;

                                                                UpdateReservation(FIELDNO("No."));

                                                                UpdateDescription;

                                                                IF ("No." = '') OR ("No." <> xRec."No.") THEN BEGIN
                                                                  "Unit of Measure Code" := '';
                                                                  "Qty. per Unit of Measure" := 1;
                                                                  "Variant Code" := '';
                                                                  "Work Type Code" := '';
                                                                  "Gen. Bus. Posting Group" := '';
                                                                  "Gen. Prod. Posting Group" := '';
                                                                  DeleteAmounts;
                                                                  "Cost Factor" := 0;
                                                                  IF "No." = '' THEN
                                                                    EXIT;
                                                                END;

                                                                GetJob;
                                                                "Customer Price Group" := Job."Customer Price Group";

                                                                CASE Type OF
                                                                  Type::Resource:
                                                                    BEGIN
                                                                      Res.GET("No.");
                                                                      Res.CheckResourcePrivacyBlocked(FALSE);
                                                                      Res.TESTFIELD(Blocked,FALSE);
                                                                      IF Description = '' THEN
                                                                        Description := Res.Name;
                                                                      IF "Description 2" = '' THEN
                                                                        "Description 2" := Res."Name 2";
                                                                      "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                                                                      "Resource Group No." := Res."Resource Group No.";
                                                                      VALIDATE("Unit of Measure Code",Res."Base Unit of Measure");
                                                                    END;
                                                                  Type::Item:
                                                                    BEGIN
                                                                      GetItem;
                                                                      Item.TESTFIELD(Blocked,FALSE);
                                                                      Description := Item.Description;
                                                                      "Description 2" := Item."Description 2";
                                                                      IF Job."Language Code" <> '' THEN
                                                                        GetItemTranslation;
                                                                      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                                                                      VALIDATE("Unit of Measure Code",Item."Base Unit of Measure");
                                                                      IF "Usage Link" THEN
                                                                        IF Item.Reserve = Item.Reserve::Optional THEN
                                                                          Reserve := Job.Reserve
                                                                        ELSE
                                                                          Reserve := Item.Reserve;
                                                                    END;
                                                                  Type::"G/L Account":
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
                                                                    END;
                                                                  Type::Text:
                                                                    BEGIN
                                                                      StandardText.GET("No.");
                                                                      Description := StandardText.Description;
                                                                    END;
                                                                END;

                                                                IF Type <> Type::Text THEN
                                                                  VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 8   ;   ;Description         ;Text50        ;OnValidate=BEGIN
                                                                ValidateModification(xRec.Description <> Description);
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 9   ;   ;Quantity            ;Decimal       ;OnValidate=VAR
                                                                Delta@1000 : Decimal;
                                                              BEGIN
                                                                IF "Usage Link" THEN
                                                                  IF NOT BypassQtyValidation THEN BEGIN
                                                                    IF ("Qty. Posted" > 0) AND (Quantity < "Qty. Posted") THEN
                                                                      ERROR(QtyLessErr,FIELDCAPTION(Quantity),FIELDCAPTION("Qty. Posted"));
                                                                    IF ("Qty. Posted" < 0) AND (Quantity > "Qty. Posted") THEN
                                                                      ERROR(QtyGreaterErr,FIELDCAPTION(Quantity),FIELDCAPTION("Qty. Posted"));
                                                                  END;

                                                                CALCFIELDS("Qty. Transferred to Invoice");
                                                                IF ("Qty. Transferred to Invoice" > 0) AND (Quantity < "Qty. Transferred to Invoice") THEN
                                                                  ERROR(QtyLessErr,FIELDCAPTION(Quantity),FIELDCAPTION("Qty. Transferred to Invoice"));
                                                                IF ("Qty. Transferred to Invoice" < 0) AND (Quantity > "Qty. Transferred to Invoice") THEN
                                                                  ERROR(QtyGreaterErr,FIELDCAPTION(Quantity),FIELDCAPTION("Qty. Transferred to Invoice"));

                                                                CASE Type OF
                                                                  Type::Item:
                                                                    IF NOT Item.GET("No.") THEN
                                                                      ERROR(MissingItemResourceGLErr,Type,Item.FIELDCAPTION("No."));
                                                                  Type::Resource:
                                                                    IF NOT Res.GET("No.") THEN
                                                                      ERROR(MissingItemResourceGLErr,Type,Res.FIELDCAPTION("No."));
                                                                  Type::"G/L Account":
                                                                    IF NOT GLAcc.GET("No.") THEN
                                                                      ERROR(MissingItemResourceGLErr,Type,GLAcc.FIELDCAPTION("No."));
                                                                END;

                                                                "Quantity (Base)" := CalcBaseQty(Quantity);

                                                                IF "Usage Link" AND (xRec."No." = "No.") THEN BEGIN
                                                                  Delta := Quantity - xRec.Quantity;
                                                                  VALIDATE("Remaining Qty.","Remaining Qty." + Delta);
                                                                  VALIDATE("Qty. to Transfer to Journal","Qty. to Transfer to Journal" + Delta);
                                                                END;

                                                                UpdateQtyToTransfer;
                                                                UpdateQtyToInvoice;

                                                                CheckItemAvailable(FIELDNO(Quantity));
                                                                UpdateReservation(FIELDNO(Quantity));

                                                                UpdateAllAmounts;
                                                                BypassQtyValidation := FALSE;
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 11  ;   ;Direct Unit Cost (LCY);Decimal     ;CaptionML=[DAN=K�bspris (RV);
                                                              ENU=Direct Unit Cost (LCY)];
                                                   AutoFormatType=2 }
    { 12  ;   ;Unit Cost (LCY)     ;Decimal       ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Unit Cost (LCY)" <> "Unit Cost (LCY)");

                                                                IF (Type = Type::Item) AND
                                                                   Item.GET("No.") AND
                                                                   (Item."Costing Method" = Item."Costing Method"::Standard)
                                                                THEN
                                                                  UpdateAllAmounts
                                                                ELSE BEGIN
                                                                  InitRoundingPrecisions;
                                                                  "Unit Cost" := ROUND(
                                                                      CurrExchRate.ExchangeAmtLCYToFCY(
                                                                        "Currency Date","Currency Code",
                                                                        "Unit Cost (LCY)","Currency Factor"),
                                                                      UnitAmountRoundingPrecisionFCY);
                                                                  UpdateAllAmounts;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Kostpris (RV);
                                                              ENU=Unit Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 13  ;   ;Total Cost (LCY)    ;Decimal       ;CaptionML=[DAN=Kostbel�b (RV);
                                                              ENU=Total Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 14  ;   ;Unit Price (LCY)    ;Decimal       ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Unit Price (LCY)" <> "Unit Price (LCY)");

                                                                InitRoundingPrecisions;
                                                                "Unit Price" := ROUND(
                                                                    CurrExchRate.ExchangeAmtLCYToFCY(
                                                                      "Currency Date","Currency Code",
                                                                      "Unit Price (LCY)","Currency Factor"),
                                                                    UnitAmountRoundingPrecisionFCY);
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Enhedspris (RV);
                                                              ENU=Unit Price (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 15  ;   ;Total Price (LCY)   ;Decimal       ;CaptionML=[DAN=Salgsbel�b (RV);
                                                              ENU=Total Price (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 16  ;   ;Resource Group No.  ;Code20        ;TableRelation="Resource Group";
                                                   CaptionML=[DAN=Ressourcegruppenr.;
                                                              ENU=Resource Group No.];
                                                   Editable=No }
    { 17  ;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.))
                                                                 ELSE "Unit of Measure";
                                                   OnValidate=VAR
                                                                Resource@1000 : Record 156;
                                                              BEGIN
                                                                ValidateModification(xRec."Unit of Measure Code" <> "Unit of Measure Code");

                                                                GetGLSetup;
                                                                CASE Type OF
                                                                  Type::Item:
                                                                    BEGIN
                                                                      Item.GET("No.");
                                                                      "Qty. per Unit of Measure" :=
                                                                        UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
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
                                                                      ResourceUnitOfMeasure.GET("No.","Unit of Measure Code");
                                                                      "Qty. per Unit of Measure" := ResourceUnitOfMeasure."Qty. per Unit of Measure";
                                                                      "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
                                                                    END;
                                                                  Type::"G/L Account":
                                                                    "Qty. per Unit of Measure" := 1;
                                                                END;
                                                                CheckItemAvailable(FIELDNO("Unit of Measure Code"));
                                                                UpdateReservation(FIELDNO("Unit of Measure Code"));
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 20  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                ValidateModification(xRec."Location Code" <> "Location Code");

                                                                "Bin Code" := '';
                                                                IF Type = Type::Item THEN BEGIN
                                                                  GetLocation("Location Code");
                                                                  Location.TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                  CheckItemAvailable(FIELDNO("Location Code"));
                                                                  UpdateReservation(FIELDNO("Location Code"));
                                                                  VALIDATE(Quantity);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 29  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 30  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 32  ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   OnValidate=BEGIN
                                                                ValidateModification(xRec."Work Type Code" <> "Work Type Code");
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
                                                                    IF ResourceUnitOfMeasure.GET("No.","Unit of Measure Code") THEN
                                                                      "Qty. per Unit of Measure" := ResourceUnitOfMeasure."Qty. per Unit of Measure";
                                                                  END ELSE BEGIN
                                                                    Res.GET("No.");
                                                                    "Unit of Measure Code" := Res."Base Unit of Measure";
                                                                    VALIDATE("Unit of Measure Code");
                                                                  END;
                                                                VALIDATE(Quantity);
                                                              END;

                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 33  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   OnValidate=BEGIN
                                                                IF (Type = Type::Item) AND ("No." <> '') THEN
                                                                  UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Debitorprisgruppe;
                                                              ENU=Customer Price Group] }
    { 79  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code];
                                                   Editable=No }
    { 80  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group];
                                                   Editable=No }
    { 81  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group];
                                                   Editable=No }
    { 83  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 1000;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.];
                                                   NotBlank=Yes }
    { 1001;   ;Line Amount (LCY)   ;Decimal       ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Line Amount (LCY)" <> "Line Amount (LCY)");

                                                                InitRoundingPrecisions;
                                                                "Line Amount" := ROUND(
                                                                    CurrExchRate.ExchangeAmtLCYToFCY(
                                                                      "Currency Date","Currency Code",
                                                                      "Line Amount (LCY)","Currency Factor"),
                                                                    AmountRoundingPrecisionFCY);
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjebel�b (RV);
                                                              ENU=Line Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1002;   ;Unit Cost           ;Decimal       ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Unit Cost" <> "Unit Cost");

                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 1003;   ;Total Cost          ;Decimal       ;CaptionML=[DAN=Kostbel�b;
                                                              ENU=Total Cost];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1004;   ;Unit Price          ;Decimal       ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Unit Price" <> "Unit Price");

                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 1005;   ;Total Price         ;Decimal       ;CaptionML=[DAN=Salgsbel�b;
                                                              ENU=Total Price];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1006;   ;Line Amount         ;Decimal       ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Line Amount" <> "Line Amount");

                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjebel�b;
                                                              ENU=Line Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1007;   ;Line Discount Amount;Decimal       ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Line Discount Amount" <> "Line Discount Amount");

                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjerabatbel�b;
                                                              ENU=Line Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1008;   ;Line Discount Amount (LCY);Decimal ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Line Discount Amount (LCY)" <> "Line Discount Amount (LCY)");

                                                                InitRoundingPrecisions;
                                                                "Line Discount Amount" := ROUND(
                                                                    CurrExchRate.ExchangeAmtLCYToFCY(
                                                                      "Currency Date","Currency Code",
                                                                      "Line Discount Amount (LCY)","Currency Factor"),
                                                                    AmountRoundingPrecisionFCY);
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjerabatbel�b (RV);
                                                              ENU=Line Discount Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1015;   ;Cost Factor         ;Decimal       ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Cost Factor" <> "Cost Factor");

                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Kostfaktor;
                                                              ENU=Cost Factor];
                                                   Editable=No }
    { 1019;   ;Serial No.          ;Code20        ;CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.];
                                                   Editable=No }
    { 1020;   ;Lot No.             ;Code20        ;CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.];
                                                   Editable=No }
    { 1021;   ;Line Discount %     ;Decimal       ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Line Discount %" <> "Line Discount %");

                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Linjerabatpct.;
                                                              ENU=Line Discount %];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes }
    { 1022;   ;Line Type           ;Option        ;OnValidate=BEGIN
                                                                "Schedule Line" := TRUE;
                                                                "Contract Line" := TRUE;
                                                                IF "Line Type" = "Line Type"::Budget THEN
                                                                  "Contract Line" := FALSE;
                                                                IF "Line Type" = "Line Type"::Billable THEN
                                                                  "Schedule Line" := FALSE;

                                                                IF NOT "Contract Line" AND (("Qty. Transferred to Invoice" <> 0) OR ("Qty. Invoiced" <> 0)) THEN
                                                                  ERROR(LineTypeErr,TABLECAPTION,FIELDCAPTION("Line Type"),"Line Type");

                                                                ControlUsageLink;
                                                              END;

                                                   CaptionML=[DAN=Linjetype;
                                                              ENU=Line Type];
                                                   OptionCaptionML=[DAN=Budget,Fakturerbar,B�de budget og fakturerbar;
                                                                    ENU=Budget,Billable,Both Budget and Billable];
                                                   OptionString=Budget,Billable,Both Budget and Billable }
    { 1023;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                ValidateModification(xRec."Currency Code" <> "Currency Code");

                                                                UpdateCurrencyFactor;
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code];
                                                   Editable=No }
    { 1024;   ;Currency Date       ;Date          ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Currency Date" <> "Currency Date");

                                                                UpdateCurrencyFactor;
                                                                IF (CurrFieldNo <> FIELDNO("Planning Date")) AND ("No." <> '') THEN
                                                                  UpdateFromCurrency;
                                                              END;

                                                   AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Valutadato;
                                                              ENU=Currency Date] }
    { 1025;   ;Currency Factor     ;Decimal       ;OnValidate=BEGIN
                                                                ValidateModification(xRec."Currency Factor" <> "Currency Factor");

                                                                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                                                                  FIELDERROR("Currency Factor",STRSUBSTNO(CurrencyFactorErr,FIELDCAPTION("Currency Code")));
                                                                UpdateAllAmounts;
                                                              END;

                                                   CaptionML=[DAN=Valutafaktor;
                                                              ENU=Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0;
                                                   Editable=No }
    { 1026;   ;Schedule Line       ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Budgetlinje;
                                                              ENU=Schedule Line];
                                                   Editable=No }
    { 1027;   ;Contract Line       ;Boolean       ;CaptionML=[DAN=<Fakturerbar linje>;
                                                              ENU=<Billable Line>];
                                                   Editable=No }
    { 1030;   ;Job Contract Entry No.;Integer     ;CaptionML=[DAN=L�benr. for sagskontrakt;
                                                              ENU=Job Contract Entry No.];
                                                   Editable=No }
    { 1035;   ;Invoiced Amount (LCY);Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line Invoice"."Invoiced Amount (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                              Job Task No.=FIELD(Job Task No.),
                                                                                                                              Job Planning Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Fakturabel�b (RV);
                                                              ENU=Invoiced Amount (LCY)];
                                                   Editable=No }
    { 1036;   ;Invoiced Cost Amount (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line Invoice"."Invoiced Cost Amount (LCY)" WHERE (Job No.=FIELD(Job No.),
                                                                                                                                   Job Task No.=FIELD(Job Task No.),
                                                                                                                                   Job Planning Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Faktureret kostbel�b (RV);
                                                              ENU=Invoiced Cost Amount (LCY)];
                                                   Editable=No }
    { 1037;   ;VAT Unit Price      ;Decimal       ;CaptionML=[DAN=Momsenhedspris;
                                                              ENU=VAT Unit Price] }
    { 1038;   ;VAT Line Discount Amount;Decimal   ;CaptionML=[DAN=Momslinjerabatbel�b;
                                                              ENU=VAT Line Discount Amount] }
    { 1039;   ;VAT Line Amount     ;Decimal       ;CaptionML=[DAN=Momslinjebel�b;
                                                              ENU=VAT Line Amount] }
    { 1041;   ;VAT %               ;Decimal       ;CaptionML=[DAN=Momspct.;
                                                              ENU=VAT %] }
    { 1042;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 1043;   ;Job Ledger Entry No.;Integer       ;TableRelation="Job Ledger Entry";
                                                   CaptionML=[DAN=Sagspostl�benr.;
                                                              ENU=Job Ledger Entry No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 1048;   ;Status              ;Option        ;InitValue=Order;
                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Skabelon,Tilbud,Ordre,Afsluttet;
                                                                    ENU=Planning,Quote,Order,Completed];
                                                   OptionString=Planning,Quote,Order,Completed;
                                                   Editable=No }
    { 1050;   ;Ledger Entry Type   ;Option        ;CaptionML=[DAN=Posteringstype;
                                                              ENU=Ledger Entry Type];
                                                   OptionCaptionML=[DAN=" ,Ressource,Vare,Finanskonto";
                                                                    ENU=" ,Resource,Item,G/L Account"];
                                                   OptionString=[ ,Resource,Item,G/L Account] }
    { 1051;   ;Ledger Entry No.    ;Integer       ;TableRelation=IF (Ledger Entry Type=CONST(Resource)) "Res. Ledger Entry"
                                                                 ELSE IF (Ledger Entry Type=CONST(Item)) "Item Ledger Entry"
                                                                 ELSE IF (Ledger Entry Type=CONST(G/L Account)) "G/L Entry";
                                                   CaptionML=[DAN=Posteringsl�benr.;
                                                              ENU=Ledger Entry No.];
                                                   BlankZero=Yes }
    { 1052;   ;System-Created Entry;Boolean       ;CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry] }
    { 1053;   ;Usage Link          ;Boolean       ;OnValidate=BEGIN
                                                                IF "Usage Link" AND ("Line Type" = "Line Type"::Billable) THEN
                                                                  ERROR(UsageLinkErr,FIELDCAPTION("Usage Link"),TABLECAPTION,FIELDCAPTION("Line Type"),"Line Type");

                                                                ControlUsageLink;

                                                                CheckItemAvailable(FIELDNO("Usage Link"));
                                                                UpdateReservation(FIELDNO("Usage Link"));
                                                              END;

                                                   CaptionML=[DAN=Anvendelseslink;
                                                              ENU=Usage Link] }
    { 1060;   ;Remaining Qty.      ;Decimal       ;OnValidate=BEGIN
                                                                VALIDATE("Remaining Qty. (Base)",CalcBaseQty("Remaining Qty."));
                                                              END;

                                                   CaptionML=[DAN=Restantal;
                                                              ENU=Remaining Qty.];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 1061;   ;Remaining Qty. (Base);Decimal      ;CaptionML=[DAN=Restantal (basis);
                                                              ENU=Remaining Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 1062;   ;Remaining Total Cost;Decimal       ;CaptionML=[DAN=Resterende kostbel�b;
                                                              ENU=Remaining Total Cost];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1063;   ;Remaining Total Cost (LCY);Decimal ;CaptionML=[DAN=Resterende kostbel�b (RV);
                                                              ENU=Remaining Total Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1064;   ;Remaining Line Amount;Decimal      ;CaptionML=[DAN=Resterende linjebel�b;
                                                              ENU=Remaining Line Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1065;   ;Remaining Line Amount (LCY);Decimal;CaptionML=[DAN=Resterende linjebel�b (RV);
                                                              ENU=Remaining Line Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1070;   ;Qty. Posted         ;Decimal       ;CaptionML=[DAN=Bogf. antal;
                                                              ENU=Qty. Posted];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 1071;   ;Qty. to Transfer to Journal;Decimal;CaptionML=[DAN=Antal, der skal overf�res til kladde;
                                                              ENU=Qty. to Transfer to Journal];
                                                   DecimalPlaces=0:5 }
    { 1072;   ;Posted Total Cost   ;Decimal       ;CaptionML=[DAN=Bogf�rt kostbel�b;
                                                              ENU=Posted Total Cost];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1073;   ;Posted Total Cost (LCY);Decimal    ;CaptionML=[DAN=Bogf�rt kostbel�b (RV);
                                                              ENU=Posted Total Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1074;   ;Posted Line Amount  ;Decimal       ;CaptionML=[DAN=Bogf�rt linjebel�b;
                                                              ENU=Posted Line Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1075;   ;Posted Line Amount (LCY);Decimal   ;CaptionML=[DAN=Bogf�rt linjebel�b (RV);
                                                              ENU=Posted Line Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1080;   ;Qty. Transferred to Invoice;Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line Invoice"."Quantity Transferred" WHERE (Job No.=FIELD(Job No.),
                                                                                                                             Job Task No.=FIELD(Job Task No.),
                                                                                                                             Job Planning Line No.=FIELD(Line No.)));
                                                   CaptionML=[DAN=Antal overf�rt til faktura;
                                                              ENU=Qty. Transferred to Invoice];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 1081;   ;Qty. to Transfer to Invoice;Decimal;OnValidate=BEGIN
                                                                IF "Qty. to Transfer to Invoice" = 0 THEN
                                                                  EXIT;

                                                                IF "Contract Line" THEN BEGIN
                                                                  IF Quantity = "Qty. Transferred to Invoice" THEN
                                                                    ERROR(QtyAlreadyTransferredErr,TABLECAPTION);

                                                                  IF Quantity > 0 THEN BEGIN
                                                                    IF ("Qty. to Transfer to Invoice" > 0) AND ("Qty. to Transfer to Invoice" > (Quantity - "Qty. Transferred to Invoice")) OR
                                                                       ("Qty. to Transfer to Invoice" < 0)
                                                                    THEN
                                                                      ERROR(QtyToTransferToInvoiceErr,FIELDCAPTION("Qty. to Transfer to Invoice"),0,Quantity - "Qty. Transferred to Invoice");
                                                                  END ELSE BEGIN
                                                                    IF ("Qty. to Transfer to Invoice" > 0) OR
                                                                       ("Qty. to Transfer to Invoice" < 0) AND ("Qty. to Transfer to Invoice" < (Quantity - "Qty. Transferred to Invoice"))
                                                                    THEN
                                                                      ERROR(QtyToTransferToInvoiceErr,FIELDCAPTION("Qty. to Transfer to Invoice"),Quantity - "Qty. Transferred to Invoice",0);
                                                                  END;
                                                                END ELSE
                                                                  ERROR(NoContractLineErr,FIELDCAPTION("Qty. to Transfer to Invoice"),TABLECAPTION,"Line Type");
                                                              END;

                                                   CaptionML=[DAN=Antal, der skal overf. til faktura;
                                                              ENU=Qty. to Transfer to Invoice];
                                                   DecimalPlaces=0:5 }
    { 1090;   ;Qty. Invoiced       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Job Planning Line Invoice"."Quantity Transferred" WHERE (Job No.=FIELD(Job No.),
                                                                                                                             Job Task No.=FIELD(Job Task No.),
                                                                                                                             Job Planning Line No.=FIELD(Line No.),
                                                                                                                             Document Type=FILTER(Posted Invoice|Posted Credit Memo)));
                                                   CaptionML=[DAN=Fakt. antal;
                                                              ENU=Qty. Invoiced];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 1091;   ;Qty. to Invoice     ;Decimal       ;CaptionML=[DAN=Fakturer (antal);
                                                              ENU=Qty. to Invoice];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 1100;   ;Reserved Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry".Quantity WHERE (Source Type=CONST(1003),
                                                                                                        Source Subtype=FIELD(Status),
                                                                                                        Source ID=FIELD(Job No.),
                                                                                                        Source Ref. No.=FIELD(Job Contract Entry No.),
                                                                                                        Reservation Status=CONST(Reservation)));
                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Reserveret antal;
                                                              ENU=Reserved Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 1101;   ;Reserved Qty. (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Reservation Entry"."Quantity (Base)" WHERE (Source Type=CONST(1003),
                                                                                                                 Source Subtype=FIELD(Status),
                                                                                                                 Source ID=FIELD(Job No.),
                                                                                                                 Source Ref. No.=FIELD(Job Contract Entry No.),
                                                                                                                 Reservation Status=CONST(Reservation)));
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure");
                                                                UpdatePlanned;
                                                              END;

                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Reserveret antal (basis);
                                                              ENU=Reserved Qty. (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 1102;   ;Reserve             ;Option        ;OnValidate=BEGIN
                                                                IF Reserve <> Reserve::Never THEN BEGIN
                                                                  TESTFIELD(Type,Type::Item);
                                                                  TESTFIELD("No.");
                                                                  TESTFIELD("Usage Link");
                                                                END;
                                                                CALCFIELDS("Reserved Qty. (Base)");
                                                                IF (Reserve = Reserve::Never) AND ("Reserved Qty. (Base)" > 0) THEN
                                                                  TESTFIELD("Reserved Qty. (Base)",0);

                                                                IF xRec.Reserve = Reserve::Always THEN BEGIN
                                                                  GetItem;
                                                                  IF Item.Reserve = Item.Reserve::Always THEN
                                                                    TESTFIELD(Reserve,Reserve::Always);
                                                                END;
                                                              END;

                                                   AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Reserver;
                                                              ENU=Reserve];
                                                   OptionCaptionML=[DAN=Aldrig,Eventuelt,Altid;
                                                                    ENU=Never,Optional,Always];
                                                   OptionString=Never,Optional,Always }
    { 1103;   ;Planned             ;Boolean       ;CaptionML=[DAN=Planlagt;
                                                              ENU=Planned];
                                                   Editable=No }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   OnValidate=BEGIN
                                                                ValidateModification(xRec."Variant Code" <> "Variant Code");

                                                                IF "Variant Code" = '' THEN BEGIN
                                                                  IF Type = Type::Item THEN BEGIN
                                                                    Item.GET("No.");
                                                                    Description := Item.Description;
                                                                    "Description 2" := Item."Description 2";
                                                                    GetItemTranslation;
                                                                  END
                                                                END ELSE BEGIN
                                                                  TESTFIELD(Type,Type::Item);

                                                                  ItemVariant.GET("No.","Variant Code");
                                                                  Description := ItemVariant.Description;
                                                                  "Description 2" := ItemVariant."Description 2";
                                                                END;
                                                                VALIDATE(Quantity);
                                                                CheckItemAvailable(FIELDNO("Variant Code"));
                                                                UpdateReservation(FIELDNO("Variant Code"));
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5403;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                ValidateModification(xRec."Bin Code" <> "Bin Code");

                                                                TESTFIELD("Location Code");
                                                                CheckItemAvailable(FIELDNO("Bin Code"));
                                                                UpdateReservation(FIELDNO("Bin Code"));
                                                              END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5410;   ;Quantity (Base)     ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Qty. per Unit of Measure",1);
                                                                VALIDATE(Quantity,"Quantity (Base)");
                                                              END;

                                                   CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 5790;   ;Requested Delivery Date;Date       ;OnValidate=BEGIN
                                                                IF ("Requested Delivery Date" <> xRec."Requested Delivery Date") AND
                                                                   ("Promised Delivery Date" <> 0D)
                                                                THEN
                                                                  ERROR(
                                                                    RequestedDeliveryDateErr,
                                                                    FIELDCAPTION("Requested Delivery Date"),
                                                                    FIELDCAPTION("Promised Delivery Date"));

                                                                IF "Requested Delivery Date" <> 0D THEN
                                                                  VALIDATE("Planned Delivery Date","Requested Delivery Date")
                                                              END;

                                                   CaptionML=[DAN=�nsket leveringsdato;
                                                              ENU=Requested Delivery Date] }
    { 5791;   ;Promised Delivery Date;Date        ;OnValidate=BEGIN
                                                                IF "Promised Delivery Date" <> 0D THEN
                                                                  VALIDATE("Planned Delivery Date","Promised Delivery Date")
                                                                ELSE
                                                                  VALIDATE("Requested Delivery Date");
                                                              END;

                                                   CaptionML=[DAN=Bekr�ftet leveringsdato;
                                                              ENU=Promised Delivery Date] }
    { 5794;   ;Planned Delivery Date;Date         ;OnValidate=BEGIN
                                                                VALIDATE("Planning Date","Planned Delivery Date");
                                                              END;

                                                   CaptionML=[DAN=Planlagt leveringsdato;
                                                              ENU=Planned Delivery Date] }
    { 5900;   ;Service Order No.   ;Code20        ;CaptionML=[DAN=Serviceordrenr.;
                                                              ENU=Service Order No.] }
  }
  KEYS
  {
    {    ;Job No.,Job Task No.,Line No.           ;Clustered=Yes }
    {    ;Job No.,Job Task No.,Schedule Line,Planning Date;
                                                   SumIndexFields=Total Price (LCY),Total Cost (LCY),Line Amount (LCY),Remaining Total Cost (LCY),Remaining Line Amount (LCY) }
    {    ;Job No.,Job Task No.,Contract Line,Planning Date;
                                                   SumIndexFields=Line Amount (LCY),Total Price (LCY),Total Cost (LCY) }
    {    ;Job No.,Job Task No.,Schedule Line,Currency Date }
    {    ;Job No.,Job Task No.,Contract Line,Currency Date }
    {    ;Job No.,Schedule Line,Type,No.,Planning Date;
                                                   SumIndexFields=Quantity (Base) }
    {    ;Job No.,Schedule Line,Type,Resource Group No.,Planning Date;
                                                   SumIndexFields=Quantity (Base) }
    {    ;Status,Schedule Line,Type,No.,Planning Date;
                                                   SumIndexFields=Quantity (Base) }
    {    ;Status,Schedule Line,Type,Resource Group No.,Planning Date;
                                                   SumIndexFields=Quantity (Base) }
    {    ;Job No.,Contract Line                    }
    {    ;Job Contract Entry No.                   }
    {    ;Type,No.,Job No.,Job Task No.,Usage Link,System-Created Entry }
    {    ;Status,Type,No.,Variant Code,Location Code,Planning Date;
                                                   SumIndexFields=Remaining Qty. (Base) }
    {    ;Job No.,Planning Date,Document No.       }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GLAcc@1018 : Record 15;
      Location@1013 : Record 14;
      Item@1014 : Record 27;
      JobTask@1001 : Record 1001;
      ItemVariant@1004 : Record 5401;
      Res@1006 : Record 156;
      ResCost@1007 : Record 202;
      WorkType@1009 : Record 200;
      Job@1002 : Record 167;
      ResourceUnitOfMeasure@1010 : Record 205;
      CurrExchRate@1025 : Record 330;
      SKU@1022 : Record 5700;
      StandardText@1030 : Record 7;
      ItemTranslation@1032 : Record 30;
      GLSetup@1015 : Record 98;
      JobPlanningLineReserve@1011 : Codeunit 1032;
      UOMMgt@1017 : Codeunit 5402;
      ItemCheckAvail@1012 : Codeunit 311;
      CurrencyFactorErr@1020 : TextConst '@@@="%1 = Currency Code field name";DAN=m� ikke indtastes uden %1;ENU=cannot be specified without %1';
      RecordRenameErr@1024 : TextConst '@@@="%1 = Job Number field name; %2 = Job Task Number field name; %3 = Job Planning Line table name";DAN=Du kan ikke �ndre %1 eller %2 for denne %3.;ENU=You cannot change the %1 or %2 of this %3.';
      CurrencyDate@1023 : Date;
      MissingItemResourceGLErr@1031 : TextConst '@@@="%1 = Document Type (Item, Resoure, or G/L); %2 = Field name";DAN=Du skal angive %1 %2 p� planl�gningslinjen.;ENU=You must specify %1 %2 in planning line.';
      HasGotGLSetup@1016 : Boolean;
      UnitAmountRoundingPrecision@1019 : Decimal;
      AmountRoundingPrecision@1028 : Decimal;
      QtyLessErr@1027 : TextConst '@@@="%1 = Name of first field to compare; %2 = Name of second field to compare";DAN=%1 kan ikke v�re mindre end %2.;ENU=%1 cannot be less than %2.';
      ControlUsageLinkErr@1029 : TextConst '@@@="%1 = Job Planning Line table name; %2 = Caption for field Schedule Line; %3 = Captiion for field Usage Link";DAN=%1 skal v�re en %2, og %3 skal v�re aktiveret, da der findes tilknyttede sagsposter.;ENU=The %1 must be a %2 and %3 must be enabled, because linked Job Ledger Entries exist.';
      JobUsageLinkErr@1034 : TextConst '@@@="%1 = Job Planning Line table name";DAN=Denne %1 kan ikke slettes, da der findes tilknyttede sagsposter.;ENU=This %1 cannot be deleted because linked job ledger entries exist.';
      BypassQtyValidation@1035 : Boolean;
      LinkedJobLedgerErr@1033 : TextConst 'DAN=Du kan ikke �ndre denne v�rdi, fordi der findes tilknyttede sagsposter.;ENU=You cannot change this value because linked job ledger entries exist.';
      LineTypeErr@1003 : TextConst '@@@=The Job Planning Line cannot be of Line Type Schedule, because it is transferred to an invoice.;DAN=%1 kan ikke v�re %2 %3, fordi den er overf�rt til en faktura.;ENU=The %1 cannot be of %2 %3 because it is transferred to an invoice.';
      QtyToTransferToInvoiceErr@1005 : TextConst '@@@="%1 = Qty. to Transfer to Invoice field name; %2 = First value in comparison; %3 = Second value in comparison";DAN=%1 m� ikke v�re lavere end %2 og m� ikke overskride %3.;ENU=%1 may not be lower than %2 and may not exceed %3.';
      AutoReserveQst@1040 : TextConst 'DAN=Automatisk reservation er ikke mulig.\Vil du reservere varerne manuelt?;ENU=Automatic reservation is not possible.\Do you want to reserve items manually?';
      NoContractLineErr@1021 : TextConst '@@@="%1 = Qty. to Transfer to Invoice field name; %2 = Job Planning Line table name; %3 = The job''s line type";DAN=%1 kan ikke v�re angivet p� en %2 af typen %3.;ENU=%1 cannot be set on a %2 of type %3.';
      QtyAlreadyTransferredErr@1038 : TextConst '@@@="%1 = Job Planning Line table name";DAN=%1 er allerede overf�rt.;ENU=The %1 has already been completely transferred.';
      UsageLinkErr@1039 : TextConst '@@@=Usage Link cannot be enabled on a Job Planning Line with Line Type Schedule;DAN=%1 kan ikke aktiveres p� en %2 med %3 %4.;ENU=%1 cannot be enabled on a %2 with %3 %4.';
      QtyGreaterErr@1041 : TextConst '@@@="%1 = Caption for field Quantity; %2 = Captiion for field Qty. Transferred to Invoice";DAN=%1 kan ikke v�re st�rre end %2.;ENU=%1 cannot be higher than %2.';
      RequestedDeliveryDateErr@1026 : TextConst '@@@="%1 = Caption for field Requested Delivery Date; %2 = Captiion for field Promised Delivery Date";DAN=%1 kan ikke �ndres, n�r %2 er udfyldt.;ENU=You cannot change the %1 when the %2 has been filled in.';
      UnitAmountRoundingPrecisionFCY@1036 : Decimal;
      AmountRoundingPrecisionFCY@1037 : Decimal;
      NotPossibleJobPlanningLineErr@1000 : TextConst 'DAN=Det er ikke muligt at slette en sagsplanl�gningslinje, der er overf�rt til en faktura.;ENU=It is not possible to deleted job planning line transferred to an invoice.';

    LOCAL PROCEDURE CalcBaseQty@14(Qty@1000 : Decimal) : Decimal;
    BEGIN
      TESTFIELD("Qty. per Unit of Measure");
      EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    END;

    LOCAL PROCEDURE CheckItemAvailable@5(CalledByFieldNo@1000 : Integer);
    BEGIN
      IF CurrFieldNo <> CalledByFieldNo THEN
        EXIT;
      IF Reserve = Reserve::Always THEN
        EXIT;
      IF (Type <> Type::Item) OR ("No." = '') THEN
        EXIT;
      IF Quantity <= 0 THEN
        EXIT;
      IF NOT (Status IN [Status::Order]) THEN
        EXIT;

      IF ItemCheckAvail.JobPlanningLineCheck(Rec) THEN
        ItemCheckAvail.RaiseUpdateInterruptedError;
    END;

    LOCAL PROCEDURE GetLocation@7300(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE GetJob@2();
    BEGIN
      IF ("Job No." <> Job."No.") AND ("Job No." <> '') THEN
        Job.GET("Job No.");
    END;

    [Internal]
    PROCEDURE UpdateCurrencyFactor@17();
    BEGIN
      IF "Currency Code" <> '' THEN BEGIN
        IF "Currency Date" = 0D THEN
          CurrencyDate := WORKDATE
        ELSE
          CurrencyDate := "Currency Date";
        "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
      END ELSE
        "Currency Factor" := 0;
    END;

    LOCAL PROCEDURE ItemExists@54(ItemNo@1000 : Code[20]) : Boolean;
    VAR
      Item2@1001 : Record 27;
    BEGIN
      IF Type = Type::Item THEN
        IF NOT Item2.GET(ItemNo) THEN
          EXIT(FALSE);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetItem@19();
    BEGIN
      IF "No." <> Item."No." THEN
        IF NOT Item.GET("No.") THEN
          CLEAR(Item);
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
    PROCEDURE Caption@8() : Text[250];
    VAR
      Job@1000 : Record 167;
      JobTask@1001 : Record 1001;
    BEGIN
      IF NOT Job.GET("Job No.") THEN
        EXIT('');
      IF NOT JobTask.GET("Job No.","Job Task No.") THEN
        EXIT('');
      EXIT(STRSUBSTNO('%1 %2 %3 %4',
          Job."No.",
          Job.Description,
          JobTask."Job Task No.",
          JobTask.Description));
    END;

    [Internal]
    PROCEDURE SetUpNewLine@9(LastJobPlanningLine@1000 : Record 1003);
    BEGIN
      "Document Date" := LastJobPlanningLine."Planning Date";
      "Document No." := LastJobPlanningLine."Document No.";
      Type := LastJobPlanningLine.Type;
      VALIDATE("Line Type",LastJobPlanningLine."Line Type");
      GetJob;
      "Currency Code" := Job."Currency Code";
      UpdateCurrencyFactor;
      IF LastJobPlanningLine."Planning Date" <> 0D THEN
        VALIDATE("Planning Date",LastJobPlanningLine."Planning Date");
    END;

    [Internal]
    PROCEDURE InitJobPlanningLine@4();
    VAR
      JobJnlManagement@1000 : Codeunit 1020;
    BEGIN
      GetJob;
      IF "Planning Date" = 0D THEN
        VALIDATE("Planning Date",WORKDATE);
      "Currency Code" := Job."Currency Code";
      UpdateCurrencyFactor;
      "VAT Unit Price" := 0;
      "VAT Line Discount Amount" := 0;
      "VAT Line Amount" := 0;
      "VAT %" := 0;
      "Job Contract Entry No." := JobJnlManagement.GetNextEntryNo;
      "User ID" := USERID;
      "Last Date Modified" := 0D;
      Status := Job.Status;
      ControlUsageLink;
    END;

    LOCAL PROCEDURE DeleteAmounts@10();
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
      "Remaining Total Cost" := 0;
      "Remaining Total Cost (LCY)" := 0;
      "Remaining Line Amount" := 0;
      "Remaining Line Amount (LCY)" := 0;

      "Qty. Posted" := 0;
      "Qty. to Transfer to Journal" := 0;
      "Posted Total Cost" := 0;
      "Posted Total Cost (LCY)" := 0;
      "Posted Line Amount" := 0;
      "Posted Line Amount (LCY)" := 0;

      "Qty. to Transfer to Invoice" := 0;
      "Qty. to Invoice" := 0;
    END;

    LOCAL PROCEDURE UpdateFromCurrency@1();
    BEGIN
      UpdateAllAmounts;
    END;

    LOCAL PROCEDURE GetItemTranslation@42();
    BEGIN
      GetJob;
      IF ItemTranslation.GET("No.","Variant Code",Job."Language Code") THEN BEGIN
        Description := ItemTranslation.Description;
        "Description 2" := ItemTranslation."Description 2";
      END;
    END;

    LOCAL PROCEDURE GetGLSetup@6();
    BEGIN
      IF HasGotGLSetup THEN
        EXIT;
      GLSetup.GET;
      HasGotGLSetup := TRUE;
    END;

    LOCAL PROCEDURE UpdateAllAmounts@11();
    BEGIN
      InitRoundingPrecisions;

      UpdateUnitCost;
      UpdateTotalCost;
      FindPriceAndDiscount(Rec,CurrFieldNo);
      HandleCostFactor;
      UpdateUnitPrice;
      UpdateTotalPrice;
      UpdateAmountsAndDiscounts;
      UpdateRemainingCostsAndAmounts;
      IF Type = Type::Text THEN
        FIELDERROR(Type);
    END;

    LOCAL PROCEDURE UpdateUnitCost@20();
    VAR
      RetrievedCost@1000 : Decimal;
    BEGIN
      GetJob;
      IF (Type = Type::Item) AND Item.GET("No.") THEN
        IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
          IF RetrieveCostPrice THEN BEGIN
            IF GetSKU THEN
              "Unit Cost (LCY)" := ROUND(SKU."Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision)
            ELSE
              "Unit Cost (LCY)" := ROUND(Item."Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision);
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Currency Date","Currency Code",
                  "Unit Cost (LCY)","Currency Factor"),
                UnitAmountRoundingPrecisionFCY);
          END ELSE
            RecalculateAmounts(Job."Exch. Calculation (Cost)",xRec."Unit Cost","Unit Cost","Unit Cost (LCY)");
        END ELSE BEGIN
          IF RetrieveCostPrice THEN BEGIN
            IF GetSKU THEN
              RetrievedCost := SKU."Unit Cost" * "Qty. per Unit of Measure"
            ELSE
              RetrievedCost := Item."Unit Cost" * "Qty. per Unit of Measure";
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Currency Date","Currency Code",
                  RetrievedCost,"Currency Factor"),
                UnitAmountRoundingPrecisionFCY);
            "Unit Cost (LCY)" := ROUND(RetrievedCost,UnitAmountRoundingPrecision);
          END ELSE
            RecalculateAmounts(Job."Exch. Calculation (Cost)",xRec."Unit Cost","Unit Cost","Unit Cost (LCY)");
        END
      ELSE
        IF (Type = Type::Resource) AND Res.GET("No.") THEN BEGIN
          IF RetrieveCostPrice THEN BEGIN
            ResCost.INIT;
            ResCost.Code := "No.";
            ResCost."Work Type Code" := "Work Type Code";
            // ResourceFindCost.RUN(ResCost);
            CODEUNIT.RUN(CODEUNIT::"Resource-Find Cost",ResCost);
            "Direct Unit Cost (LCY)" := ROUND(ResCost."Direct Unit Cost" * "Qty. per Unit of Measure",UnitAmountRoundingPrecision);
            RetrievedCost := ResCost."Unit Cost" * "Qty. per Unit of Measure";
            "Unit Cost" := ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Currency Date","Currency Code",
                  RetrievedCost,"Currency Factor"),
                UnitAmountRoundingPrecisionFCY);
            "Unit Cost (LCY)" := ROUND(RetrievedCost,UnitAmountRoundingPrecision);
          END ELSE
            RecalculateAmounts(Job."Exch. Calculation (Cost)",xRec."Unit Cost","Unit Cost","Unit Cost (LCY)");
        END ELSE
          RecalculateAmounts(Job."Exch. Calculation (Cost)",xRec."Unit Cost","Unit Cost","Unit Cost (LCY)");
    END;

    LOCAL PROCEDURE RetrieveCostPrice@13() : Boolean;
    BEGIN
      CASE Type OF
        Type::Item:
          IF ("No." <> xRec."No.") OR
             ("Location Code" <> xRec."Location Code") OR
             ("Variant Code" <> xRec."Variant Code") OR
             (NOT BypassQtyValidation AND (Quantity <> xRec.Quantity)) OR
             ("Unit of Measure Code" <> xRec."Unit of Measure Code")
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

    LOCAL PROCEDURE UpdateTotalCost@24();
    BEGIN
      "Total Cost" := ROUND("Unit Cost" * Quantity,AmountRoundingPrecisionFCY);
      "Total Cost (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Currency Date","Currency Code",
            "Total Cost","Currency Factor"),
          AmountRoundingPrecision);
    END;

    LOCAL PROCEDURE FindPriceAndDiscount@60(VAR JobPlanningLine@1000 : Record 1003;CalledByFieldNo@1001 : Integer);
    VAR
      SalesPriceCalcMgt@1002 : Codeunit 7000;
      PurchPriceCalcMgt@1003 : Codeunit 7010;
    BEGIN
      IF RetrieveCostPrice AND ("No." <> '') THEN BEGIN
        SalesPriceCalcMgt.FindJobPlanningLinePrice(JobPlanningLine,CalledByFieldNo);

        IF Type <> Type::"G/L Account" THEN
          PurchPriceCalcMgt.FindJobPlanningLinePrice(JobPlanningLine,CalledByFieldNo)
        ELSE BEGIN
          // Because the SalesPriceCalcMgt.FindJobJnlLinePrice function also retrieves costs for G/L Account,
          // cost and total cost need to get updated again.
          UpdateUnitCost;
          UpdateTotalCost;
        END;
      END;
    END;

    LOCAL PROCEDURE HandleCostFactor@22();
    BEGIN
      IF ("Cost Factor" <> 0) AND (("Unit Cost" <> xRec."Unit Cost") OR ("Cost Factor" <> xRec."Cost Factor")) THEN
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
      GetJob;
      RecalculateAmounts(Job."Exch. Calculation (Price)",xRec."Unit Price","Unit Price","Unit Price (LCY)");
    END;

    LOCAL PROCEDURE RecalculateAmounts@35(JobExchCalculation@1003 : 'Fixed FCY,Fixed LCY';xAmount@1000 : Decimal;VAR Amount@1001 : Decimal;VAR AmountLCY@1002 : Decimal);
    BEGIN
      IF (xRec."Currency Factor" <> "Currency Factor") AND
         (Amount = xAmount) AND (JobExchCalculation = JobExchCalculation::"Fixed LCY")
      THEN
        Amount := ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              "Currency Date","Currency Code",
              AmountLCY,"Currency Factor"),
            UnitAmountRoundingPrecisionFCY)
      ELSE
        AmountLCY := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date","Currency Code",
              Amount,"Currency Factor"),
            UnitAmountRoundingPrecision);
    END;

    LOCAL PROCEDURE UpdateTotalPrice@26();
    BEGIN
      "Total Price" := ROUND(Quantity * "Unit Price",AmountRoundingPrecisionFCY);
      "Total Price (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Currency Date","Currency Code",
            "Total Price","Currency Factor"),
          AmountRoundingPrecision);
    END;

    LOCAL PROCEDURE UpdateAmountsAndDiscounts@31();
    BEGIN
      IF "Total Price" = 0 THEN BEGIN
        "Line Amount" := 0;
        "Line Discount Amount" := 0;
      END ELSE
        IF ("Line Amount" <> xRec."Line Amount") AND ("Line Discount Amount" = xRec."Line Discount Amount") THEN BEGIN
          "Line Amount" := ROUND("Line Amount",AmountRoundingPrecisionFCY);
          "Line Discount Amount" := "Total Price" - "Line Amount";
          "Line Discount %" :=
            ROUND("Line Discount Amount" / "Total Price" * 100,0.00001);
        END ELSE
          IF ("Line Discount Amount" <> xRec."Line Discount Amount") AND ("Line Amount" = xRec."Line Amount") THEN BEGIN
            "Line Discount Amount" := ROUND("Line Discount Amount",AmountRoundingPrecisionFCY);
            "Line Amount" := "Total Price" - "Line Discount Amount";
            "Line Discount %" :=
              ROUND("Line Discount Amount" / "Total Price" * 100,0.00001);
          END ELSE
            IF ("Line Discount Amount" = xRec."Line Discount Amount") AND
               (("Line Amount" <> xRec."Line Amount") OR ("Line Discount %" <> xRec."Line Discount %") OR
                ("Total Price" <> xRec."Total Price"))
            THEN BEGIN
              "Line Discount Amount" :=
                ROUND("Total Price" * "Line Discount %" / 100,AmountRoundingPrecisionFCY);
              "Line Amount" := "Total Price" - "Line Discount Amount";
            END;

      "Line Amount (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Currency Date","Currency Code",
            "Line Amount","Currency Factor"),
          AmountRoundingPrecision);

      "Line Discount Amount (LCY)" := ROUND(
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Currency Date","Currency Code",
            "Line Discount Amount","Currency Factor"),
          AmountRoundingPrecision);
    END;

    [Internal]
    PROCEDURE Use@30(PostedQty@1001 : Decimal;PostedTotalCost@1000 : Decimal;PostedLineAmount@1002 : Decimal);
    BEGIN
      IF "Usage Link" THEN BEGIN
        InitRoundingPrecisions;
        // Update Quantity Posted
        VALIDATE("Qty. Posted","Qty. Posted" + PostedQty);

        // Update Posted Costs and Amounts.
        "Posted Total Cost" += ROUND(PostedTotalCost,AmountRoundingPrecisionFCY);
        "Posted Total Cost (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date","Currency Code",
              "Posted Total Cost","Currency Factor"),
            AmountRoundingPrecision);

        "Posted Line Amount" += ROUND(PostedLineAmount,AmountRoundingPrecisionFCY);
        "Posted Line Amount (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date","Currency Code",
              "Posted Line Amount","Currency Factor"),
            AmountRoundingPrecision);

        // Update Remaining Quantity
        IF (PostedQty >= 0) = ("Remaining Qty." >= 0) THEN
          IF ABS(PostedQty) <= ABS("Remaining Qty.") THEN
            VALIDATE("Remaining Qty.","Remaining Qty." - PostedQty)
          ELSE BEGIN
            VALIDATE(Quantity,Quantity + PostedQty - "Remaining Qty.");
            VALIDATE("Remaining Qty.",0);
          END
        ELSE
          VALIDATE("Remaining Qty.","Remaining Qty." - PostedQty);

        // Update Remaining Costs and Amounts
        UpdateRemainingCostsAndAmounts;

        // Update Quantity to Post
        VALIDATE("Qty. to Transfer to Journal","Remaining Qty.");
      END ELSE
        ClearValues;

      MODIFY(TRUE);
    END;

    LOCAL PROCEDURE UpdateRemainingCostsAndAmounts@3();
    BEGIN
      IF "Usage Link" THEN BEGIN
        InitRoundingPrecisions;
        "Remaining Total Cost" := ROUND("Unit Cost" * "Remaining Qty.",AmountRoundingPrecisionFCY);
        "Remaining Total Cost (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date","Currency Code",
              "Remaining Total Cost","Currency Factor"),
            AmountRoundingPrecision);
        "Remaining Line Amount" := CalcLineAmount("Remaining Qty.");
        "Remaining Line Amount (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Currency Date","Currency Code",
              "Remaining Line Amount","Currency Factor"),
            AmountRoundingPrecision);
      END ELSE
        ClearValues;
    END;

    [External]
    PROCEDURE UpdateQtyToTransfer@29();
    BEGIN
      IF "Contract Line" THEN BEGIN
        CALCFIELDS("Qty. Transferred to Invoice");
        VALIDATE("Qty. to Transfer to Invoice",Quantity - "Qty. Transferred to Invoice");
      END ELSE
        VALIDATE("Qty. to Transfer to Invoice",0);
    END;

    [External]
    PROCEDURE UpdateQtyToInvoice@28();
    BEGIN
      IF "Contract Line" THEN BEGIN
        CALCFIELDS("Qty. Invoiced");
        VALIDATE("Qty. to Invoice",Quantity - "Qty. Invoiced")
      END ELSE
        VALIDATE("Qty. to Invoice",0);
    END;

    [External]
    PROCEDURE UpdatePostedTotalCost@33(AdjustJobCost@1000 : Decimal;AdjustJobCostLCY@1001 : Decimal);
    BEGIN
      IF "Usage Link" THEN BEGIN
        InitRoundingPrecisions;
        "Posted Total Cost" += ROUND(AdjustJobCost,AmountRoundingPrecisionFCY);
        "Posted Total Cost (LCY)" += ROUND(AdjustJobCostLCY,AmountRoundingPrecision);
      END;
    END;

    LOCAL PROCEDURE ValidateModification@21(FieldChanged@1000 : Boolean);
    BEGIN
      IF FieldChanged THEN BEGIN
        CALCFIELDS("Qty. Transferred to Invoice");
        TESTFIELD("Qty. Transferred to Invoice",0);
      END;
    END;

    LOCAL PROCEDURE CheckUsageLinkRelations@7();
    VAR
      JobUsageLink@1000 : Record 1020;
    BEGIN
      JobUsageLink.SETRANGE("Job No.","Job No.");
      JobUsageLink.SETRANGE("Job Task No.","Job Task No.");
      JobUsageLink.SETRANGE("Line No.","Line No.");
      IF NOT JobUsageLink.ISEMPTY THEN
        ERROR(LinkedJobLedgerErr);
    END;

    LOCAL PROCEDURE ControlUsageLink@18();
    VAR
      JobUsageLink@1000 : Record 1020;
    BEGIN
      GetJob;

      IF Job."Apply Usage Link" THEN BEGIN
        IF "Schedule Line" THEN
          "Usage Link" := TRUE
        ELSE
          "Usage Link" := FALSE;
      END ELSE BEGIN
        IF NOT "Schedule Line" THEN
          "Usage Link" := FALSE;
      END;

      JobUsageLink.SETRANGE("Job No.","Job No.");
      JobUsageLink.SETRANGE("Job Task No.","Job Task No.");
      JobUsageLink.SETRANGE("Line No.","Line No.");
      IF NOT JobUsageLink.ISEMPTY AND NOT "Usage Link" THEN
        ERROR(ControlUsageLinkErr,TABLECAPTION,FIELDCAPTION("Schedule Line"),FIELDCAPTION("Usage Link"));

      VALIDATE("Remaining Qty.",Quantity - "Qty. Posted");
      VALIDATE("Qty. to Transfer to Journal",Quantity - "Qty. Posted");
      UpdateRemainingCostsAndAmounts;

      UpdateQtyToTransfer;
      UpdateQtyToInvoice;
    END;

    LOCAL PROCEDURE CalcLineAmount@12(Qty@1000 : Decimal) : Decimal;
    VAR
      TotalPrice@1001 : Decimal;
    BEGIN
      InitRoundingPrecisions;
      TotalPrice := ROUND(Qty * "Unit Price",AmountRoundingPrecisionFCY);
      EXIT(TotalPrice - ROUND(TotalPrice * "Line Discount %" / 100,AmountRoundingPrecisionFCY));
    END;

    [External]
    PROCEDURE Overdue@27() : Boolean;
    BEGIN
      IF ("Planning Date" < WORKDATE) AND ("Remaining Qty." > 0) THEN
        EXIT(TRUE);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE SetBypassQtyValidation@32(Bypass@1000 : Boolean);
    BEGIN
      BypassQtyValidation := Bypass;
    END;

    LOCAL PROCEDURE UpdateReservation@15(CalledByFieldNo@1000 : Integer);
    VAR
      ReservationCheckDateConfl@1001 : Codeunit 99000815;
    BEGIN
      IF (CurrFieldNo <> CalledByFieldNo) AND (CurrFieldNo <> 0) THEN
        EXIT;
      CASE CalledByFieldNo OF
        FIELDNO("Planning Date"),FIELDNO("Planned Delivery Date"):
          IF (xRec."Planning Date" <> "Planning Date") AND
             (Quantity <> 0) AND
             (Reserve <> Reserve::Never)
          THEN
            ReservationCheckDateConfl.JobPlanningLineCheck(Rec,TRUE);
        FIELDNO(Quantity):
          JobPlanningLineReserve.VerifyQuantity(Rec,xRec);
        FIELDNO("Usage Link"):
          IF (Type = Type::Item) AND "Usage Link" THEN BEGIN
            GetItem;
            IF Item.Reserve = Item.Reserve::Optional THEN BEGIN
              GetJob;
              Reserve := Job.Reserve
            END ELSE
              Reserve := Item.Reserve;
          END ELSE
            Reserve := Reserve::Never;
      END;
      JobPlanningLineReserve.VerifyChange(Rec,xRec);
      UpdatePlanned;
    END;

    LOCAL PROCEDURE UpdateDescription@38();
    BEGIN
      IF (xRec.Type = xRec.Type::Resource) AND (xRec."No." <> '') THEN BEGIN
        Res.GET(xRec."No.");
        IF Description = Res.Name THEN
          Description := '';
        IF "Description 2" = Res."Name 2" THEN
          "Description 2" := '';
      END;
    END;

    [External]
    PROCEDURE ShowReservation@74();
    VAR
      Reservation@1000 : Page 498;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      TESTFIELD(Reserve);
      TESTFIELD("Usage Link");
      Reservation.SetJobPlanningLine(Rec);
      Reservation.RUNMODAL;
    END;

    [External]
    PROCEDURE ShowReservationEntries@72(Modal@1000 : Boolean);
    VAR
      ReservEntry@1003 : Record 337;
      ReservEngineMgt@1001 : Codeunit 99000831;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
      JobPlanningLineReserve.FilterReservFor(ReservEntry,Rec);
      IF Modal THEN
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
      ELSE
        PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    END;

    [External]
    PROCEDURE AutoReserve@73();
    VAR
      ReservMgt@1000 : Codeunit 99000845;
      FullAutoReservation@1001 : Boolean;
      QtyToReserve@1002 : Decimal;
      QtyToReserveBase@1003 : Decimal;
    BEGIN
      TESTFIELD(Type,Type::Item);
      TESTFIELD("No.");
      IF Reserve = Reserve::Never THEN
        FIELDERROR(Reserve);
      JobPlanningLineReserve.ReservQuantity(Rec,QtyToReserve,QtyToReserveBase);
      IF QtyToReserveBase <> 0 THEN BEGIN
        ReservMgt.SetJobPlanningLine(Rec);
        TESTFIELD("Planning Date");
        ReservMgt.AutoReserve(FullAutoReservation,'',"Planning Date",QtyToReserve,QtyToReserveBase);
        FIND;
        IF NOT FullAutoReservation THEN BEGIN
          COMMIT;
          IF CONFIRM(AutoReserveQst,TRUE) THEN BEGIN
            ShowReservation;
            FIND;
          END;
        END;
        UpdatePlanned;
      END;
    END;

    [External]
    PROCEDURE ShowTracking@16();
    VAR
      OrderTrackingForm@1000 : Page 99000822;
    BEGIN
      OrderTrackingForm.SetJobPlanningLine(Rec);
      OrderTrackingForm.RUNMODAL;
    END;

    [External]
    PROCEDURE ShowOrderPromisingLine@64();
    VAR
      OrderPromisingLine@1000 : Record 99000880;
      OrderPromisingLines@1001 : Page 99000959;
    BEGIN
      OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::Job);
      OrderPromisingLine.SETRANGE("Source Type",OrderPromisingLine."Source Type"::Job);
      OrderPromisingLine.SETRANGE("Source ID","Job No.");
      OrderPromisingLine.SETRANGE("Source Line No.","Job Contract Entry No.");

      OrderPromisingLines.SetSourceType(OrderPromisingLine."Source Type"::Job);
      OrderPromisingLines.SETTABLEVIEW(OrderPromisingLine);
      OrderPromisingLines.RUNMODAL;
    END;

    [External]
    PROCEDURE FilterLinesWithItemToPlan@70(VAR Item@1000 : Record 27);
    BEGIN
      RESET;
      SETCURRENTKEY(Status,Type,"No.","Variant Code","Location Code","Planning Date");
      SETRANGE(Status,Status::Order);
      SETRANGE(Type,Type::Item);
      SETRANGE("No.",Item."No.");
      SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
      SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
      SETFILTER("Planning Date",Item.GETFILTER("Date Filter"));
      SETFILTER("Remaining Qty. (Base)",'<>0');
    END;

    [External]
    PROCEDURE FindLinesWithItemToPlan@68(VAR Item@1000 : Record 27) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item);
      EXIT(FIND('-'));
    END;

    [External]
    PROCEDURE LinesWithItemToPlanExist@67(VAR Item@1000 : Record 27) : Boolean;
    BEGIN
      FilterLinesWithItemToPlan(Item);
      EXIT(NOT ISEMPTY);
    END;

    [External]
    PROCEDURE DrillDownJobInvoices@34();
    VAR
      JobInvoices@1000 : Page 1029;
    BEGIN
      JobInvoices.SetShowDetails(FALSE);
      JobInvoices.SetPrJobPlanningLine(Rec);
      JobInvoices.RUN;
    END;

    LOCAL PROCEDURE CheckRelatedJobPlanningLineInvoice@36();
    VAR
      JobPlanningLineInvoice@1000 : Record 1022;
    BEGIN
      JobPlanningLineInvoice.SETRANGE("Job No.","Job No.");
      JobPlanningLineInvoice.SETRANGE("Job Task No.","Job Task No.");
      JobPlanningLineInvoice.SETRANGE("Job Planning Line No.","Line No.");
      IF NOT JobPlanningLineInvoice.ISEMPTY THEN
        ERROR(NotPossibleJobPlanningLineErr);
    END;

    [External]
    PROCEDURE RowID1@44() : Text[250];
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
    BEGIN
      EXIT(
        ItemTrackingMgt.ComposeRowID(DATABASE::"Job Planning Line",Status,
          "Job No.",'',0,"Job Contract Entry No."));
    END;

    [External]
    PROCEDURE UpdatePlanned@37() : Boolean;
    BEGIN
      CALCFIELDS("Reserved Quantity");
      IF Planned = ("Reserved Quantity" = "Remaining Qty.") THEN
        EXIT(FALSE);
      Planned := NOT Planned;
      EXIT(TRUE);
    END;

    PROCEDURE ClearValues@46();
    BEGIN
      VALIDATE("Remaining Qty.",0);
      "Remaining Total Cost" := 0;
      "Remaining Total Cost (LCY)" := 0;
      "Remaining Line Amount" := 0;
      "Remaining Line Amount (LCY)" := 0;
      VALIDATE("Qty. Posted",0);
      VALIDATE("Qty. to Transfer to Journal",0);
      "Posted Total Cost" := 0;
      "Posted Total Cost (LCY)" := 0;
      "Posted Line Amount" := 0;
      "Posted Line Amount (LCY)" := 0;
    END;

    PROCEDURE InitFromJobPlanningLine@39(FromJobPlanningLine@1000 : Record 1003;NewQuantity@1001 : Decimal);
    VAR
      ToJobPlanningLine@1003 : Record 1003;
      JobJnlManagement@1002 : Codeunit 1020;
    BEGIN
      ToJobPlanningLine := Rec;

      ToJobPlanningLine.INIT;
      ToJobPlanningLine.TRANSFERFIELDS(FromJobPlanningLine);
      ToJobPlanningLine."Line No." := GetNextJobLineNo(FromJobPlanningLine);
      ToJobPlanningLine.VALIDATE("Line Type","Line Type"::Billable);
      ToJobPlanningLine.ClearValues;
      ToJobPlanningLine."Job Contract Entry No." := JobJnlManagement.GetNextEntryNo;
      IF ToJobPlanningLine.Type <> ToJobPlanningLine.Type::Text THEN BEGIN
        ToJobPlanningLine.VALIDATE(Quantity,NewQuantity);
        ToJobPlanningLine.VALIDATE("Currency Code",FromJobPlanningLine."Currency Code");
        ToJobPlanningLine.VALIDATE("Currency Date",FromJobPlanningLine."Currency Date");
        ToJobPlanningLine.VALIDATE("Currency Factor",FromJobPlanningLine."Currency Factor");
        ToJobPlanningLine.VALIDATE("Unit Cost",FromJobPlanningLine."Unit Cost");
        ToJobPlanningLine.VALIDATE("Unit Price",FromJobPlanningLine."Unit Price");
      END;

      Rec := ToJobPlanningLine;
    END;

    LOCAL PROCEDURE GetNextJobLineNo@41(FromJobPlanningLine@1000 : Record 1003) : Integer;
    VAR
      JobPlanningLine@1001 : Record 1003;
    BEGIN
      JobPlanningLine.SETRANGE("Job No.",FromJobPlanningLine."Job No.");
      JobPlanningLine.SETRANGE("Job Task No.",FromJobPlanningLine."Job Task No.");
      IF JobPlanningLine.FINDLAST THEN;
      EXIT(JobPlanningLine."Line No." + 10000);
    END;

    PROCEDURE IsServiceItem@69() : Boolean;
    BEGIN
      IF Type <> Type::Item THEN
        EXIT(FALSE);
      IF "No." = '' THEN
        EXIT(FALSE);
      GetItem;
      EXIT(Item.Type = Item.Type::Service);
    END;

    BEGIN
    END.
  }
}

