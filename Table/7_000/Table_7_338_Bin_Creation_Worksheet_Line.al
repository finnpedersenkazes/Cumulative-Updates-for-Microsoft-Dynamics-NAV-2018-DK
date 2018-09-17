OBJECT Table 7338 Bin Creation Worksheet Line
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
               GetLocation("Location Code");
               IF Location."Bin Mandatory" THEN
                 TESTFIELD("Bin Code");
               "User ID" := USERID;
             END;

    OnModify=BEGIN
               GetLocation("Location Code");
               IF Location."Bin Mandatory" THEN
                 TESTFIELD("Bin Code");
             END;

    CaptionML=[DAN=Placeringsopr.kladdelinje;
               ENU=Bin Creation Worksheet Line];
    LookupPageID=Page7372;
  }
  FIELDS
  {
    { 1   ;   ;Worksheet Template Name;Code10     ;TableRelation="Bin Creation Wksh. Template".Name WHERE (Type=FIELD(Type));
                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Worksheet Template Name] }
    { 2   ;   ;Name                ;Code10        ;TableRelation="Bin Creation Wksh. Name".Name WHERE (Worksheet Template Name=FIELD(Worksheet Template Name));
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 4   ;   ;Type                ;Option        ;OnValidate=VAR
                                                                BinCreateWkshLine@1000 : Record 7338;
                                                              BEGIN
                                                                IF Type <> xRec.Type THEN BEGIN
                                                                  BinCreateWkshLine := Rec;
                                                                  "Item No." := '';
                                                                  "Bin Code" := '';
                                                                  "Zone Code" := '';
                                                                  "Variant Code" := '';
                                                                  INIT;
                                                                  Type := BinCreateWkshLine.Type;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Placering,Plac.indh.;
                                                                    ENU=Bin,Bin Content];
                                                   OptionString=Bin,Bin Content }
    { 5   ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Bin Mandatory=CONST(Yes));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   NotBlank=Yes }
    { 6   ;   ;Zone Code           ;Code10        ;TableRelation=Zone.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                GetLocation("Location Code");
                                                                Location.TESTFIELD("Directed Put-away and Pick");
                                                                GetZone("Location Code","Zone Code");
                                                                "Bin Type Code" := Zone."Bin Type Code";
                                                                VALIDATE("Warehouse Class Code",Zone."Warehouse Class Code");
                                                                "Special Equipment Code" := Zone."Special Equipment Code";
                                                                "Bin Ranking" := Zone."Zone Ranking";
                                                                "Cross-Dock Bin" := Zone."Cross-Dock Bin Zone";
                                                              END;

                                                   CaptionML=[DAN=Zonekode;
                                                              ENU=Zone Code] }
    { 7   ;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                IF ("Bin Code" <> '') AND (Type = Type::"Bin Content") THEN BEGIN
                                                                  Bin.GET("Location Code","Bin Code");
                                                                  Dedicated := Bin.Dedicated;
                                                                  "Bin Type Code" := Bin."Bin Type Code";
                                                                  VALIDATE("Warehouse Class Code",Bin."Warehouse Class Code");
                                                                  "Special Equipment Code" := Bin."Special Equipment Code";
                                                                  "Block Movement" := Bin."Block Movement";
                                                                  "Bin Ranking" := Bin."Bin Ranking";
                                                                  "Cross-Dock Bin" := Bin."Cross-Dock Bin";
                                                                  "Zone Code" := Bin."Zone Code";
                                                                END;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code];
                                                   NotBlank=Yes }
    { 8   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   OnValidate=VAR
                                                                Item@1000 : Record 27;
                                                              BEGIN
                                                                IF "Item No." <> '' THEN BEGIN
                                                                  GetItem("Item No.");
                                                                  Description := Item.Description;
                                                                  GetItemUnitOfMeasure;
                                                                  VALIDATE("Unit of Measure Code",ItemUnitOfMeasure.Code);
                                                                  CheckWhseClass("Item No.");
                                                                END ELSE BEGIN
                                                                  Description := '';
                                                                  "Variant Code" := '';
                                                                  VALIDATE("Unit of Measure Code",'');
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.];
                                                   NotBlank=Yes }
    { 9   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 10  ;   ;Bin Type Code       ;Code10        ;TableRelation="Bin Type";
                                                   CaptionML=[DAN=Placeringstypekode;
                                                              ENU=Bin Type Code] }
    { 11  ;   ;Warehouse Class Code;Code10        ;TableRelation="Warehouse Class";
                                                   OnValidate=BEGIN
                                                                IF ("Item No." <> '') AND (Type = Type::"Bin Content") THEN
                                                                  CheckWhseClass("Item No.");
                                                              END;

                                                   CaptionML=[DAN=Lagerklassekode;
                                                              ENU=Warehouse Class Code] }
    { 12  ;   ;Block Movement      ;Option        ;CaptionML=[DAN=Bloker bev‘gelse;
                                                              ENU=Block Movement];
                                                   OptionCaptionML=[DAN=" ,Indg†ende,Udg†ende,Alle";
                                                                    ENU=" ,Inbound,Outbound,All"];
                                                   OptionString=[ ,Inbound,Outbound,All] }
    { 15  ;   ;Min. Qty.           ;Decimal       ;OnValidate=BEGIN
                                                                IF "Min. Qty." > "Max. Qty." THEN
                                                                  ERROR(
                                                                    Text009,
                                                                    FIELDCAPTION("Max. Qty."),"Max. Qty.",
                                                                    FIELDCAPTION("Min. Qty."),"Min. Qty.");
                                                              END;

                                                   CaptionML=[DAN=Min.antal;
                                                              ENU=Min. Qty.];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 16  ;   ;Max. Qty.           ;Decimal       ;OnValidate=BEGIN
                                                                IF "Max. Qty." <> xRec."Max. Qty." THEN
                                                                  CheckMaxQtyBinContent(TRUE);

                                                                IF "Min. Qty." > "Max. Qty." THEN
                                                                  ERROR(
                                                                    Text009,
                                                                    FIELDCAPTION("Max. Qty."),"Max. Qty.",
                                                                    FIELDCAPTION("Min. Qty."),"Min. Qty.");
                                                              END;

                                                   CaptionML=[DAN=Maks.antal;
                                                              ENU=Max. Qty.];
                                                   DecimalPlaces=0:5;
                                                   MinValue=1 }
    { 20  ;   ;Special Equipment Code;Code10      ;TableRelation="Special Equipment";
                                                   CaptionML=[DAN=Specialudstyrskode;
                                                              ENU=Special Equipment Code] }
    { 21  ;   ;Bin Ranking         ;Integer       ;CaptionML=[DAN=Placeringsniveau;
                                                              ENU=Bin Ranking] }
    { 22  ;   ;Maximum Cubage      ;Decimal       ;OnValidate=BEGIN
                                                                CheckMaxQtyBinContent(FALSE);
                                                              END;

                                                   CaptionML=[DAN=Maks. rumm†l;
                                                              ENU=Maximum Cubage];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   BlankZero=Yes }
    { 23  ;   ;Maximum Weight      ;Decimal       ;OnValidate=BEGIN
                                                                CheckMaxQtyBinContent(TRUE);
                                                              END;

                                                   CaptionML=[DAN=Maks. v‘gt;
                                                              ENU=Maximum Weight];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   BlankZero=Yes }
    { 37  ;   ;Fixed               ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Fast;
                                                              ENU=Fixed] }
    { 38  ;   ;Default             ;Boolean       ;OnValidate=BEGIN
                                                                IF Default THEN
                                                                  IF WMSMgt.CheckDefaultBin("Item No.","Variant Code","Location Code","Bin Code") THEN
                                                                    ERROR(Text010,"Location Code","Item No.","Variant Code");
                                                              END;

                                                   CaptionML=[DAN=Standard;
                                                              ENU=Default] }
    { 40  ;   ;Cross-Dock Bin      ;Boolean       ;CaptionML=[DAN=Dir.afs.placering;
                                                              ENU=Cross-Dock Bin] }
    { 67  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
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
    { 5402;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   OnValidate=VAR
                                                                ItemVariant@1000 : Record 5401;
                                                              BEGIN
                                                                IF "Variant Code" <> '' THEN BEGIN
                                                                  ItemVariant.GET("Item No.","Variant Code");
                                                                  Description := ItemVariant.Description;
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
                                                                GetItem("Item No.");
                                                                "Qty. per Unit of Measure" :=
                                                                  UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code];
                                                   NotBlank=Yes }
    { 5408;   ;Dedicated           ;Boolean       ;CaptionML=[DAN=Dedikeret;
                                                              ENU=Dedicated] }
  }
  KEYS
  {
    {    ;Worksheet Template Name,Name,Location Code,Line No.;
                                                   Clustered=Yes }
    {    ;Location Code,Zone Code,Bin Code,Item No.,Variant Code }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      BinCreateWkshTemplate@1019 : Record 7336;
      Location@1009 : Record 14;
      Zone@1000 : Record 7300;
      Text001@1002 : TextConst 'DAN=%1 Kladde;ENU=%1 Worksheet';
      Text002@1015 : TextConst 'DAN=Standardkladde;ENU=Default Worksheet';
      Text003@1004 : TextConst 'DAN=Annulleret.;ENU=Cancelled.';
      Bin@1016 : Record 7354;
      Item@1012 : Record 27;
      ItemUnitOfMeasure@1017 : Record 5404;
      WMSMgt@1005 : Codeunit 7302;
      Text004@1003 : TextConst 'DAN=STANDARD;ENU=DEFAULT';
      Text005@1006 : TextConst 'DAN=Det samlede rumm†l %1 for %2 i placeringsindholdet overstiger det angivne %3 %4.\Er du sikker p†, at du vil angive %3?;ENU=The Total Cubage %1 of the %2 in the bin contents exceeds the entered %3 %4.\Do you still want to enter this %3?';
      Text007@1008 : TextConst 'DAN=%1 %2 %3 stemmer ikke overens med %4 %5.;ENU=The %1 %2 %3 does not match the %4 %5.';
      Text008@1018 : TextConst 'DAN=Lokationen %1 for placeringsoprettelseskladdenavnet %2 er ikke aktiveret for brugeren %3.;ENU=The location %1 of bin creation  Wksh. batch %2 is not enabled for user %3.';
      Text009@1013 : TextConst 'DAN=%1 %2 m† ikke v‘re mindre end %3 %4.;ENU=The %1 %2 must not be less than the %3 %4.';
      UOMMgt@1014 : Codeunit 5402;
      Text010@1001 : TextConst 'DAN=Der findes allerede et standardplaceringsindhold for lokationskoden %1, varenr. %2 og variantkoden %3.;ENU=There is already a default bin content for location code %1, item no. %2 and variant code %3.';
      OpenFromBatch@1010 : Boolean;

    [External]
    PROCEDURE EmptyLine@7() : Boolean;
    BEGIN
      IF Type = Type::Bin THEN
        EXIT(("Bin Code" = '') AND ("Location Code" = '') AND ("Zone Code" = ''));

      EXIT(("Bin Code" = '') AND ("Location Code" = '') AND ("Zone Code" = '') AND
        ("Item No." = '') AND ("Unit of Measure Code" = ''))
    END;

    [External]
    PROCEDURE SetUpNewLine@8(CurrentWkshTemplateName@1000 : Code[10]);
    BEGIN
      IF BinCreateWkshTemplate.Name <> CurrentWkshTemplateName THEN
        BinCreateWkshTemplate.GET(CurrentWkshTemplateName);
      Type := BinCreateWkshTemplate.Type;
    END;

    [External]
    PROCEDURE TemplateSelection@18(PageID@1004 : Integer;PageTemplate@1000 : Option;VAR BinCreateWkshLine@1003 : Record 7338;VAR WkshSelected@1002 : Boolean);
    VAR
      BinCreateWkshTemplate@1001 : Record 7336;
    BEGIN
      WkshSelected := TRUE;

      BinCreateWkshTemplate.RESET;
      IF NOT OpenFromBatch THEN
        BinCreateWkshTemplate.SETRANGE("Page ID",PageID);
      BinCreateWkshTemplate.SETRANGE(Type,PageTemplate);
      CASE BinCreateWkshTemplate.COUNT OF
        0:
          BEGIN
            BinCreateWkshTemplate.INIT;
            BinCreateWkshTemplate.Type := PageTemplate;
            BinCreateWkshTemplate.Name :=
              FORMAT(BinCreateWkshTemplate.Type,MAXSTRLEN(BinCreateWkshTemplate.Name));
            BinCreateWkshTemplate.Description :=
              STRSUBSTNO(Text001,BinCreateWkshTemplate.Type);
            BinCreateWkshTemplate.VALIDATE("Page ID");
            BinCreateWkshTemplate.INSERT;
            COMMIT;
          END;
        1:
          BinCreateWkshTemplate.FINDFIRST;
        ELSE
          WkshSelected := PAGE.RUNMODAL(0,BinCreateWkshTemplate) = ACTION::LookupOK;
      END;
      IF WkshSelected THEN BEGIN
        BinCreateWkshLine.FILTERGROUP := 2;
        BinCreateWkshLine.SETRANGE("Worksheet Template Name",BinCreateWkshTemplate.Name);
        BinCreateWkshLine.SETRANGE(Type,BinCreateWkshTemplate.Type);
        BinCreateWkshLine.FILTERGROUP := 0;
        IF OpenFromBatch THEN BEGIN
          BinCreateWkshLine."Worksheet Template Name" := '';
          PAGE.RUN(BinCreateWkshTemplate."Page ID",BinCreateWkshLine);
        END;
      END;
    END;

    [External]
    PROCEDURE TemplateSelectionFromBatch@9(VAR BinCreateWkshName@1003 : Record 7337);
    VAR
      BinCreateWkshLine@1000 : Record 7338;
      JnlSelected@1001 : Boolean;
    BEGIN
      OpenFromBatch := TRUE;
      BinCreateWkshName.CALCFIELDS("Template Type");
      BinCreateWkshLine.Name := BinCreateWkshName.Name;
      BinCreateWkshLine."Location Code" := BinCreateWkshName."Location Code";
      TemplateSelection(0,BinCreateWkshName."Template Type",BinCreateWkshLine,JnlSelected);
    END;

    [External]
    PROCEDURE OpenWksh@17(VAR CurrentWkshName@1000 : Code[10];VAR CurrentLocationCode@1002 : Code[10];VAR BinCreateWkshLine@1001 : Record 7338);
    BEGIN
      WMSMgt.CheckUserIsWhseEmployee;
      CheckTemplateName(
        BinCreateWkshLine.GETRANGEMAX("Worksheet Template Name"),
        CurrentLocationCode,CurrentWkshName);
      BinCreateWkshLine.FILTERGROUP := 2;
      BinCreateWkshLine.SETRANGE(Name,CurrentWkshName);
      IF CurrentLocationCode <> '' THEN
        BinCreateWkshLine.SETRANGE("Location Code",CurrentLocationCode);
      BinCreateWkshTemplate.GET(BinCreateWkshLine.GETRANGEMAX("Worksheet Template Name"));
      BinCreateWkshLine.SETRANGE(Type,BinCreateWkshTemplate.Type);
      BinCreateWkshLine.FILTERGROUP := 0;
    END;

    [External]
    PROCEDURE OpenWkshBatch@3(VAR BinCreateWkshName@1005 : Record 7337);
    VAR
      CopyOfBinCreateWkshName@1000 : Record 7337;
      BinCreateWkshTemplate@1001 : Record 7336;
      BinCreateWkshLine@1002 : Record 7338;
      JnlSelected@1003 : Boolean;
    BEGIN
      CopyOfBinCreateWkshName := BinCreateWkshName;
      IF NOT BinCreateWkshName.FIND('-') THEN BEGIN
        FOR BinCreateWkshTemplate.Type := BinCreateWkshTemplate.Type::Bin TO BinCreateWkshTemplate.Type::"Bin Content" DO BEGIN
          BinCreateWkshTemplate.SETRANGE(Type,BinCreateWkshTemplate.Type);
          IF NOT BinCreateWkshTemplate.FINDFIRST THEN
            TemplateSelection(0,BinCreateWkshTemplate.Type,BinCreateWkshLine,JnlSelected);
          IF BinCreateWkshTemplate.FINDFIRST THEN
            CheckTemplateName(BinCreateWkshTemplate.Name,BinCreateWkshName.Name,BinCreateWkshName."Location Code");
        END;
        IF BinCreateWkshName.FIND('-') THEN;
        CopyOfBinCreateWkshName := BinCreateWkshName;
      END;
      BinCreateWkshName := CopyOfBinCreateWkshName;
    END;

    LOCAL PROCEDURE CheckTemplateName@16(CurrentWkshTemplateName@1000 : Code[10];VAR CurrentLocationCode@1003 : Code[10];VAR CurrentWkshName@1001 : Code[10]);
    VAR
      BinCreateWkshName@1002 : Record 7337;
    BEGIN
      WMSMgt.GetWMSLocation(CurrentLocationCode);

      BinCreateWkshName.SETRANGE("Worksheet Template Name",CurrentWkshTemplateName);
      BinCreateWkshName.SETRANGE("Location Code",CurrentLocationCode);
      BinCreateWkshName.SETRANGE(Name,CurrentWkshName);
      IF NOT BinCreateWkshName.ISEMPTY THEN
        EXIT;

      BinCreateWkshName.SETRANGE(Name);
      IF NOT BinCreateWkshName.FINDFIRST THEN BEGIN
        BinCreateWkshName.INIT;
        BinCreateWkshName."Worksheet Template Name" := CurrentWkshTemplateName;
        BinCreateWkshName.SetupNewName;
        BinCreateWkshName."Location Code" := CurrentLocationCode;
        BinCreateWkshName.Name := Text004;
        BinCreateWkshName.Description := Text002;
        BinCreateWkshName.INSERT(TRUE);
        COMMIT;
      END;
      CurrentWkshName := BinCreateWkshName.Name;
    END;

    [External]
    PROCEDURE CheckName@14(CurrentWkshName@1000 : Code[10];CurrentLocationCode@1003 : Code[10];VAR BinCreateWkshLine@1001 : Record 7338);
    VAR
      BinCreateWkshName@1002 : Record 7337;
      WhseEmployee@1004 : Record 7301;
    BEGIN
      BinCreateWkshName.GET(
        BinCreateWkshLine.GETRANGEMAX(
          "Worksheet Template Name"),CurrentWkshName,CurrentLocationCode);
      IF (USERID <> '') AND NOT WhseEmployee.GET(USERID,CurrentLocationCode) THEN
        ERROR(Text008,CurrentLocationCode,CurrentWkshName,USERID);
    END;

    [External]
    PROCEDURE SetName@13(CurrentWkshName@1000 : Code[10];CurrentLocationCode@1002 : Code[10];VAR BinCreateWkshLine@1001 : Record 7338);
    BEGIN
      BinCreateWkshLine.FILTERGROUP := 2;
      BinCreateWkshLine.SETRANGE(Name,CurrentWkshName);
      BinCreateWkshLine.SETRANGE("Location Code",CurrentLocationCode);
      BinCreateWkshLine.FILTERGROUP := 0;
      IF BinCreateWkshLine.FIND('-') THEN;
    END;

    [External]
    PROCEDURE LookupBinCreationName@19(VAR CurrentWkshName@1000 : Code[10];VAR CurrentLocationCode@1003 : Code[10];VAR BinCreateWkshLine@1001 : Record 7338);
    VAR
      BinCreateWkshName@1002 : Record 7337;
    BEGIN
      COMMIT;
      BinCreateWkshName."Worksheet Template Name" :=
        BinCreateWkshLine.GETRANGEMAX("Worksheet Template Name");
      BinCreateWkshName.Name := BinCreateWkshLine.GETRANGEMAX(Name);
      BinCreateWkshName.SETRANGE(
        "Worksheet Template Name",BinCreateWkshName."Worksheet Template Name");
      IF PAGE.RUNMODAL(
           PAGE::"Bin Creation Wksh. Name List",BinCreateWkshName) = ACTION::LookupOK
      THEN BEGIN
        CurrentWkshName := BinCreateWkshName.Name;
        CurrentLocationCode := BinCreateWkshName."Location Code";
        SetName(CurrentWkshName,CurrentLocationCode,BinCreateWkshLine);
      END;
    END;

    LOCAL PROCEDURE CheckMaxQtyBinContent@4(CheckWeight@1000 : Boolean);
    VAR
      BinContent@1001 : Record 7302;
      TotalCubage@1002 : Decimal;
      TotalWeight@1003 : Decimal;
      Cubage@1004 : Decimal;
      Weight@1005 : Decimal;
    BEGIN
      IF ("Maximum Cubage" <> 0) OR ("Maximum Weight" <> 0) THEN BEGIN
        BinContent.SETRANGE("Location Code","Location Code");
        BinContent.SETRANGE("Zone Code","Zone Code");
        BinContent.SETRANGE("Bin Code","Bin Code");
        IF BinContent.FIND('-') THEN
          REPEAT
            WMSMgt.CalcCubageAndWeight(
              BinContent."Item No.",BinContent."Unit of Measure Code",
              BinContent."Max. Qty.",Cubage,Weight);
            TotalCubage := TotalCubage + Cubage;
            TotalWeight := TotalWeight + Weight;
          UNTIL BinContent.NEXT = 0;

        IF (NOT CheckWeight) AND
           ("Maximum Cubage" > 0) AND ("Maximum Cubage" - TotalCubage < 0)
        THEN
          IF NOT CONFIRM(Text005,FALSE,
               TotalCubage,BinContent.FIELDCAPTION("Max. Qty."),
               FIELDCAPTION("Maximum Cubage"),"Maximum Cubage")
          THEN
            ERROR(Text003);
        IF CheckWeight AND ("Maximum Weight" > 0) AND ("Maximum Weight" - TotalWeight < 0) THEN
          IF NOT CONFIRM(Text005,FALSE,
               TotalWeight,BinContent.FIELDCAPTION("Max. Qty."),
               FIELDCAPTION("Maximum Weight"),"Maximum Weight")
          THEN
            ERROR(Text003);
      END;
    END;

    LOCAL PROCEDURE CheckWhseClass@6(ItemNo@1000 : Code[20]);
    BEGIN
      GetItem(ItemNo);
      IF (Item."Warehouse Class Code" <> '') AND
         (Item."Warehouse Class Code" <> "Warehouse Class Code")
      THEN
        ERROR(
          Text007,
          TABLECAPTION,FIELDCAPTION("Warehouse Class Code"),"Warehouse Class Code",
          Item.TABLECAPTION,Item.FIELDCAPTION("Warehouse Class Code"));
    END;

    LOCAL PROCEDURE GetLocation@10(LocationCode@1000 : Code[10]);
    BEGIN
      IF Location.Code <> LocationCode THEN
        Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE GetItem@2(ItemNo@1000 : Code[20]);
    BEGIN
      IF ItemNo <> Item."No." THEN
        Item.GET(ItemNo);
    END;

    LOCAL PROCEDURE GetZone@1(LocationCode@1000 : Code[10];ZoneCode@1001 : Code[10]);
    BEGIN
      TESTFIELD("Location Code");
      TESTFIELD("Zone Code");
      IF (Zone."Location Code" <> LocationCode) OR
         (Zone.Code <> ZoneCode)
      THEN
        Zone.GET("Location Code","Zone Code");
    END;

    LOCAL PROCEDURE GetItemUnitOfMeasure@11();
    BEGIN
      GetItem("Item No.");
      IF (Item."No." <> ItemUnitOfMeasure."Item No.") OR
         ("Unit of Measure Code" <> ItemUnitOfMeasure.Code)
      THEN
        IF NOT ItemUnitOfMeasure.GET(Item."No.","Unit of Measure Code") THEN
          ItemUnitOfMeasure.GET(Item."No.",Item."Base Unit of Measure");
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
    PROCEDURE GetUnitOfMeasureDescr@24(UOMCode@1002 : Code[10];VAR UOMDescription@1000 : Text[50]);
    VAR
      UOM@1001 : Record 204;
    BEGIN
      UOMDescription := '';
      IF UOMCode = '' THEN
        CLEAR(UOM)
      ELSE
        IF UOMCode <> UOM.Code THEN
          IF UOM.GET(UOMCode) THEN;
      UOMDescription := UOM.Description;
    END;

    BEGIN
    END.
  }
}

