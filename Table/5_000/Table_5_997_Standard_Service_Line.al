OBJECT Table 5997 Standard Service Line
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
               StdServCode.GET("Standard Service Code");
             END;

    OnRename=BEGIN
               ERROR(Text000,TABLECAPTION);
             END;

    CaptionML=[DAN=Standardservicelinje;
               ENU=Standard Service Line];
  }
  FIELDS
  {
    { 1   ;   ;Standard Service Code;Code10       ;TableRelation="Standard Service Code";
                                                   CaptionML=[DAN=Standardservicekode;
                                                              ENU=Standard Service Code];
                                                   Editable=No }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.];
                                                   Editable=No }
    { 3   ;   ;Type                ;Option        ;OnValidate=VAR
                                                                OldType@1000 : Integer;
                                                              BEGIN
                                                                OldType := Type;
                                                                INIT;
                                                                Type := OldType;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Vare,Ressource,Omkostning,Finanskonto";
                                                                    ENU=" ,Item,Resource,Cost,G/L Account"];
                                                   OptionString=[ ,Item,Resource,Cost,G/L Account] }
    { 4   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(" ")) "Standard Text"
                                                                 ELSE IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(Resource)) Resource
                                                                 ELSE IF (Type=CONST(Cost)) "Service Cost"
                                                                 ELSE IF (Type=CONST(G/L Account)) "G/L Account";
                                                   OnValidate=VAR
                                                                StdTxt@1000 : Record 7;
                                                                GLAcc@1001 : Record 15;
                                                                Item@1002 : Record 27;
                                                                Res@1003 : Record 156;
                                                                ServCost@1004 : Record 5905;
                                                              BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  Quantity := 0;
                                                                  "Amount Excl. VAT" := 0;
                                                                  "Unit of Measure Code" := '';
                                                                  Description := '';
                                                                  IF "No." = '' THEN
                                                                    EXIT;
                                                                  StdServCode.GET("Standard Service Code");
                                                                  CASE Type OF
                                                                    Type::" ":
                                                                      BEGIN
                                                                        StdTxt.GET("No.");
                                                                        Description := StdTxt.Description;
                                                                      END;
                                                                    Type::Item:
                                                                      BEGIN
                                                                        Item.GET("No.");
                                                                        Item.TESTFIELD(Blocked,FALSE);
                                                                        Item.TESTFIELD("Inventory Posting Group");
                                                                        Item.TESTFIELD("Gen. Prod. Posting Group");
                                                                        Description := Item.Description;
                                                                        "Unit of Measure Code" := Item."Sales Unit of Measure";
                                                                        "Variant Code" := '';
                                                                      END;
                                                                    Type::Resource:
                                                                      BEGIN
                                                                        Res.GET("No.");
                                                                        Res.CheckResourcePrivacyBlocked(FALSE);
                                                                        Res.TESTFIELD(Blocked,FALSE);
                                                                        Res.TESTFIELD("Gen. Prod. Posting Group");
                                                                        Description := Res.Name;
                                                                        "Unit of Measure Code" := Res."Base Unit of Measure";
                                                                      END;
                                                                    Type::Cost:
                                                                      BEGIN
                                                                        ServCost.GET("No.");
                                                                        GLAcc.GET(ServCost."Account No.");
                                                                        GLAcc.TESTFIELD("Gen. Prod. Posting Group");
                                                                        Description := ServCost.Description;
                                                                        Quantity := ServCost."Default Quantity";
                                                                        "Unit of Measure Code" := ServCost."Unit of Measure Code";
                                                                      END;
                                                                    Type::"G/L Account":
                                                                      BEGIN
                                                                        GLAcc.GET("No.");
                                                                        GLAcc.CheckGLAcc;
                                                                        GLAcc.TESTFIELD("Direct Posting",TRUE);
                                                                        Description := GLAcc.Name;
                                                                      END;
                                                                  END;
                                                                END;

                                                                CreateDim(DimMgt.TypeToTableID5(Type),"No.");
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 5   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 6   ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD(Type);
                                                                TESTFIELD("No.");
                                                                IF Quantity < 0 THEN
                                                                  FIELDERROR(Quantity,Text002);
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes }
    { 7   ;   ;Amount Excl. VAT    ;Decimal       ;OnValidate=BEGIN
                                                                IF Type <> Type::"G/L Account" THEN
                                                                  FIELDERROR(Type,STRSUBSTNO(Text001,Type));
                                                              END;

                                                   CaptionML=[DAN=Bel�b ekskl. moms;
                                                              ENU=Amount Excl. VAT];
                                                   BlankZero=Yes;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr=GetCurrency }
    { 8   ;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE "Unit of Measure";
                                                   OnValidate=BEGIN
                                                                TESTFIELD(Type);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 9   ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 10  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 11  ;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   OnValidate=VAR
                                                                Item@1000 : Record 27;
                                                                ItemVariant@1001 : Record 5401;
                                                              BEGIN
                                                                IF "Variant Code" = '' THEN BEGIN
                                                                  IF Type = Type::Item THEN BEGIN
                                                                    Item.GET("No.");
                                                                    Description := Item.Description;
                                                                  END;
                                                                  EXIT;
                                                                END;

                                                                TESTFIELD(Type,Type::Item);
                                                                ItemVariant.GET("No.","Variant Code");
                                                                Description := ItemVariant.Description;
                                                              END;

                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
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
  }
  KEYS
  {
    {    ;Standard Service Code,Line No.          ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      StdServCode@1001 : Record 5996;
      DimMgt@1002 : Codeunit 408;
      Text000@1003 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text001@1004 : TextConst 'DAN=m� ikke v�re %1;ENU=must not be %1';
      Text002@1005 : TextConst 'DAN=skal v�re positiv;ENU=must be positive';

    [External]
    PROCEDURE EmptyLine@5() : Boolean;
    BEGIN
      EXIT(("No." = '') AND (Quantity = 0))
    END;

    [External]
    PROCEDURE InsertLine@1() : Boolean;
    BEGIN
      EXIT((Type = Type::" ") OR NOT EmptyLine);
    END;

    LOCAL PROCEDURE GetCurrency@2() : Code[10];
    BEGIN
      IF StdServCode.GET("Standard Service Code") THEN
        EXIT(StdServCode."Currency Code");
      EXIT('');
    END;

    [External]
    PROCEDURE ShowDimensions@25();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"No.","Line No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      MODIFY;
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE LookupShortcutDimCode@28(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE ShowShortcutDimCode@27(VAR ShortcutDimCode@1000 : ARRAY [8] OF Code[20]);
    BEGIN
      DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    END;

    LOCAL PROCEDURE CreateDim@26(Type1@1000 : Integer;No1@1001 : Code[20]);
    VAR
      SourceCodeSetup@1006 : Record 242;
      TableID@1007 : ARRAY [10] OF Integer;
      No@1008 : ARRAY [10] OF Code[20];
    BEGIN
      SourceCodeSetup.GET;

      TableID[1] := Type1;
      No[1] := No1;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup."Service Management",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@138(VAR StandardServiceLine@1000 : Record 5997;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

