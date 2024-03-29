OBJECT Table 171 Standard Sales Line
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
               StdSalesCode.GET("Standard Sales Code");
             END;

    OnRename=BEGIN
               ERROR(Text000,TABLECAPTION);
             END;

    CaptionML=[DAN=Standardsalgslinje;
               ENU=Standard Sales Line];
  }
  FIELDS
  {
    { 1   ;   ;Standard Sales Code ;Code10        ;TableRelation="Standard Sales Code";
                                                   CaptionML=[DAN=Standardsalgskode;
                                                              ENU=Standard Sales Code];
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
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,Ressource,Anl�g,Gebyr (vare)";
                                                                    ENU=" ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)"];
                                                   OptionString=[ ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)] }
    { 4   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(" ")) "Standard Text"
                                                                 ELSE IF (Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(Resource)) Resource
                                                                 ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
                                                   OnValidate=VAR
                                                                GLAcc@1001 : Record 15;
                                                                Item@1002 : Record 27;
                                                                Res@1005 : Record 156;
                                                                ItemCharge@1006 : Record 5800;
                                                                FA@1003 : Record 5600;
                                                                StdTxt@1004 : Record 7;
                                                                StdSalesCode@1000 : Record 170;
                                                              BEGIN
                                                                Quantity := 0;
                                                                "Amount Excl. VAT" := 0;
                                                                "Unit of Measure Code" := '';
                                                                Description := '';
                                                                IF "No." = '' THEN
                                                                  EXIT;
                                                                StdSalesCode.GET("Standard Sales Code");
                                                                CASE Type OF
                                                                  Type::" ":
                                                                    BEGIN
                                                                      StdTxt.GET("No.");
                                                                      Description := StdTxt.Description;
                                                                    END;
                                                                  Type::"G/L Account":
                                                                    BEGIN
                                                                      GLAcc.GET("No.");
                                                                      GLAcc.CheckGLAcc;
                                                                      GLAcc.TESTFIELD("Direct Posting",TRUE);
                                                                      Description := GLAcc.Name;
                                                                    END;
                                                                  Type::Item:
                                                                    BEGIN
                                                                      Item.GET("No.");
                                                                      Item.TESTFIELD(Blocked,FALSE);
                                                                      Item.TESTFIELD("Gen. Prod. Posting Group");
                                                                      IF Item.Type = Item.Type::Inventory THEN
                                                                        Item.TESTFIELD("Inventory Posting Group");
                                                                      "Unit of Measure Code" := Item."Sales Unit of Measure";
                                                                      Description := Item.Description;
                                                                      "Variant Code" := '';
                                                                    END;
                                                                  Type::Resource:
                                                                    BEGIN
                                                                      Res.GET("No.");
                                                                      Res.CheckResourcePrivacyBlocked(FALSE);
                                                                      Res.TESTFIELD(Blocked,FALSE);
                                                                      Res.TESTFIELD("Gen. Prod. Posting Group");
                                                                      "Unit of Measure Code" := Res."Base Unit of Measure";
                                                                      Description := Res.Name;
                                                                    END;
                                                                  Type::"Fixed Asset":
                                                                    BEGIN
                                                                      FA.GET("No.");
                                                                      FA.TESTFIELD(Inactive,FALSE);
                                                                      FA.TESTFIELD(Blocked,FALSE);
                                                                      Description := FA.Description;
                                                                    END;
                                                                  Type::"Charge (Item)":
                                                                    BEGIN
                                                                      ItemCharge.GET("No.");
                                                                      Description := ItemCharge.Description;
                                                                    END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 5   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 6   ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD(Type);
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes }
    { 7   ;   ;Amount Excl. VAT    ;Decimal       ;OnValidate=BEGIN
                                                                IF (Type <> Type::"G/L Account") AND (Type <> Type::"Charge (Item)") THEN
                                                                  ERROR(Text001,FIELDCAPTION(Type),Type);
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
                                                                Item@1001 : Record 27;
                                                                ItemVariant@1000 : Record 5401;
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
    {    ;Standard Sales Code,Line No.            ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      StdSalesCode@1001 : Record 170;
      DimMgt@1000 : Codeunit 408;
      Text000@1003 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text001@1005 : TextConst 'DAN=%1 m� ikke v�re %2.;ENU=%1 must not be %2.';
      CommentLbl@1002 : TextConst 'DAN=Bem�rkning;ENU=Comment';

    [External]
    PROCEDURE EmptyLine@5() : Boolean;
    BEGIN
      EXIT(("No." = '') AND (Quantity = 0))
    END;

    [External]
    PROCEDURE InsertLine@1() : Boolean;
    BEGIN
      EXIT((Type = Type::" ") OR (NOT EmptyLine));
    END;

    LOCAL PROCEDURE GetCurrency@2() : Code[10];
    VAR
      StdSalesCode@1000 : Record 170;
    BEGIN
      IF StdSalesCode.GET("Standard Sales Code") THEN
        EXIT(StdSalesCode."Currency Code");

      EXIT('');
    END;

    [External]
    PROCEDURE ShowDimensions@3();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',"Standard Sales Code","Line No."));
      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
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

    PROCEDURE FormatType@4() : Text[20];
    BEGIN
      IF Type = Type::" " THEN
        EXIT(CommentLbl);

      EXIT(FORMAT(Type));
    END;

    BEGIN
    END.
  }
}

