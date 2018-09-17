OBJECT Table 484 Change Global Dim. Header
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Header til Rediger glob. dim.;
               ENU=Change Global Dim. Header];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Prim�rn�gle;
                                                              ENU=Primary Key] }
    { 2   ;   ;Old Global Dimension 1 Code;Code20 ;TableRelation=Dimension;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Gammel global dimension 1-kode;
                                                              ENU=Old Global Dimension 1 Code] }
    { 3   ;   ;Old Global Dimension 2 Code;Code20 ;TableRelation=Dimension;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Gammel global dimension 2-kode;
                                                              ENU=Old Global Dimension 2 Code] }
    { 4   ;   ;Global Dimension 1 Code;Code20     ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                ValidateDimCode("Global Dimension 1 Code");
                                                                IF "Global Dimension 1 Code" = "Global Dimension 2 Code" THEN BEGIN
                                                                  "Global Dimension 2 Code" := '';
                                                                  "Change Type 2" := "Change Type 2"::Blank;
                                                                END;
                                                                CalcChangeType("Change Type 1","Global Dimension 1 Code","Old Global Dimension 1 Code","Old Global Dimension 2 Code");
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code] }
    { 5   ;   ;Global Dimension 2 Code;Code20     ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                ValidateDimCode("Global Dimension 2 Code");
                                                                IF "Global Dimension 2 Code" = "Global Dimension 1 Code" THEN BEGIN
                                                                  "Global Dimension 1 Code" := '';
                                                                  "Change Type 1" := "Change Type 1"::Blank;
                                                                END;
                                                                CalcChangeType("Change Type 2","Global Dimension 2 Code","Old Global Dimension 2 Code","Old Global Dimension 1 Code");
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code] }
    { 6   ;   ;Parallel Processing ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Parallel behandling;
                                                              ENU=Parallel Processing] }
    { 7   ;   ;Change Type 1       ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=�ndringstype 1;
                                                              ENU=Change Type 1];
                                                   OptionCaptionML=[DAN=Ingen,Tomt,Erstat,Ny;
                                                                    ENU=None,Blank,Replace,New];
                                                   OptionString=None,Blank,Replace,New }
    { 8   ;   ;Change Type 2       ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=�ndringstype 2;
                                                              ENU=Change Type 2];
                                                   OptionCaptionML=[DAN=Ingen,Tom,Erstat,Ny;
                                                                    ENU=None,Blank,Replace,New];
                                                   OptionString=None,Blank,Replace,New }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      DimIsUsedInGLSetupErr@1000 : TextConst '@@@=%1 - a dimension code, like PROJECT;DAN=Dimensionen %1 bruges i vinduet Ops�tning af Finans som en genvejsdimension.;ENU=The dimension %1 is used in General Ledger Setup window as a shortcut dimension.';
      GeneralLedgerSetup@1001 : Record 98;

    LOCAL PROCEDURE CalcChangeType@13(VAR ChangeType@1003 : 'None,Blank,Replace,New';Code@1002 : Code[20];OldCode@1000 : Code[20];OtherOldCode@1001 : Code[20]);
    BEGIN
      IF Code = OtherOldCode THEN
        ChangeType := ChangeType::Replace
      ELSE
        IF Code = OldCode THEN
          ChangeType := ChangeType::None
        ELSE
          IF Code = '' THEN
            ChangeType := ChangeType::Blank
          ELSE
            ChangeType := ChangeType::New
    END;

    PROCEDURE Refresh@1();
    BEGIN
      RefreshCurrentDimCodes;
      "Global Dimension 1 Code" := GeneralLedgerSetup."Global Dimension 1 Code";
      "Global Dimension 2 Code" := GeneralLedgerSetup."Global Dimension 2 Code";
      "Change Type 1" := "Change Type 1"::None;
      "Change Type 2" := "Change Type 2"::None;
    END;

    PROCEDURE RefreshCurrentDimCodes@2();
    BEGIN
      GeneralLedgerSetup.GET;
      "Old Global Dimension 1 Code" := GeneralLedgerSetup."Global Dimension 1 Code";
      "Old Global Dimension 2 Code" := GeneralLedgerSetup."Global Dimension 2 Code";
    END;

    LOCAL PROCEDURE IsUsedInShortcurDims@17(DimensionCode@1000 : Code[20]) : Boolean;
    BEGIN
      GeneralLedgerSetup.GET;
      EXIT(
        DimensionCode IN
        [GeneralLedgerSetup."Shortcut Dimension 3 Code",
         GeneralLedgerSetup."Shortcut Dimension 4 Code",
         GeneralLedgerSetup."Shortcut Dimension 5 Code",
         GeneralLedgerSetup."Shortcut Dimension 6 Code",
         GeneralLedgerSetup."Shortcut Dimension 7 Code",
         GeneralLedgerSetup."Shortcut Dimension 8 Code"]);
    END;

    LOCAL PROCEDURE ValidateDimCode@9(NewCode@1000 : Code[20]);
    VAR
      Dimension@1002 : Record 348;
    BEGIN
      IF NewCode <> '' THEN BEGIN
        Dimension.GET(NewCode);
        IF IsUsedInShortcurDims(NewCode) THEN
          ERROR(DimIsUsedInGLSetupErr,NewCode);
      END;
    END;

    BEGIN
    END.
  }
}

