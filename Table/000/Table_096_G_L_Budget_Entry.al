OBJECT Table 96 G/L Budget Entry
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    Permissions=TableData 366=rd;
    OnInsert=VAR
               TempDimSetEntry@1000 : TEMPORARY Record 480;
             BEGIN
               CheckIfBlocked;
               TESTFIELD(Date);
               TESTFIELD("G/L Account No.");
               TESTFIELD("Budget Name");
               LOCKTABLE;
               "User ID" := USERID;
               "Last Date Modified" := TODAY;
               IF "Entry No." = 0 THEN
                 "Entry No." := GetNextEntryNo;

               GetGLSetup;
               DimMgt.GetDimensionSet(TempDimSetEntry,"Dimension Set ID");
               UpdateDimSet(TempDimSetEntry,GLSetup."Global Dimension 1 Code","Global Dimension 1 Code");
               UpdateDimSet(TempDimSetEntry,GLSetup."Global Dimension 2 Code","Global Dimension 2 Code");
               UpdateDimSet(TempDimSetEntry,GLBudgetName."Budget Dimension 1 Code","Budget Dimension 1 Code");
               UpdateDimSet(TempDimSetEntry,GLBudgetName."Budget Dimension 2 Code","Budget Dimension 2 Code");
               UpdateDimSet(TempDimSetEntry,GLBudgetName."Budget Dimension 3 Code","Budget Dimension 3 Code");
               UpdateDimSet(TempDimSetEntry,GLBudgetName."Budget Dimension 4 Code","Budget Dimension 4 Code");
               VALIDATE("Dimension Set ID",DimMgt.GetDimensionSetID(TempDimSetEntry));
             END;

    OnModify=BEGIN
               CheckIfBlocked;
               "User ID" := USERID;
               "Last Date Modified" := TODAY;
             END;

    OnDelete=BEGIN
               CheckIfBlocked;
               DeleteAnalysisViewBudgetEntries;
             END;

    CaptionML=[DAN=Finansbudgetpost;
               ENU=G/L Budget Entry];
    LookupPageID=Page120;
    DrillDownPageID=Page120;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Budget Name         ;Code10        ;TableRelation="G/L Budget Name";
                                                   CaptionML=[DAN=Budgetnavn;
                                                              ENU=Budget Name] }
    { 3   ;   ;G/L Account No.     ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                IF (xRec."G/L Account No." <> '') AND (xRec."G/L Account No." <> "G/L Account No.") THEN
                                                                  VerifyNoRelatedAnalysisViewBudgetEntries(xRec);
                                                              END;

                                                   CaptionML=[DAN=Finanskontonr.;
                                                              ENU=G/L Account No.] }
    { 4   ;   ;Date                ;Date          ;OnValidate=BEGIN
                                                                IF (xRec.Date <> 0D) AND (xRec.Date <> Date) THEN
                                                                  VerifyNoRelatedAnalysisViewBudgetEntries(xRec);
                                                              END;

                                                   CaptionML=[DAN=Dato;
                                                              ENU=Date];
                                                   ClosingDates=Yes }
    { 5   ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                IF "Global Dimension 1 Code" = xRec."Global Dimension 1 Code" THEN
                                                                  EXIT;
                                                                GetGLSetup;
                                                                ValidateDimValue(GLSetup."Global Dimension 1 Code","Global Dimension 1 Code");
                                                                UpdateDimensionSetId(GLSetup."Global Dimension 1 Code","Global Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 6   ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                IF "Global Dimension 2 Code" = xRec."Global Dimension 2 Code" THEN
                                                                  EXIT;
                                                                GetGLSetup;
                                                                ValidateDimValue(GLSetup."Global Dimension 2 Code","Global Dimension 2 Code");
                                                                UpdateDimensionSetId(GLSetup."Global Dimension 2 Code","Global Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 7   ;   ;Amount              ;Decimal       ;OnValidate=BEGIN
                                                                IF (xRec.Amount <> 0) AND (xRec.Amount <> Amount) THEN
                                                                  VerifyNoRelatedAnalysisViewBudgetEntries(xRec);
                                                              END;

                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 9   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 10  ;   ;Business Unit Code  ;Code20        ;TableRelation="Business Unit";
                                                   CaptionML=[DAN=Konc.virksomhedskode;
                                                              ENU=Business Unit Code] }
    { 11  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
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
    { 12  ;   ;Budget Dimension 1 Code;Code20     ;OnValidate=BEGIN
                                                                IF "Budget Dimension 1 Code" = xRec."Budget Dimension 1 Code" THEN
                                                                  EXIT;
                                                                IF GLBudgetName.Name <> "Budget Name" THEN
                                                                  GLBudgetName.GET("Budget Name");
                                                                ValidateDimValue(GLBudgetName."Budget Dimension 1 Code","Budget Dimension 1 Code");
                                                                UpdateDimensionSetId(GLBudgetName."Budget Dimension 1 Code","Budget Dimension 1 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              "Budget Dimension 1 Code" := OnLookupDimCode(2,"Budget Dimension 1 Code");
                                                              ValidateDimValue(GLBudgetName."Budget Dimension 1 Code","Budget Dimension 1 Code");
                                                              UpdateDimensionSetId(GLBudgetName."Budget Dimension 1 Code","Budget Dimension 1 Code");
                                                            END;

                                                   AccessByPermission=TableData 348=R;
                                                   CaptionML=[DAN=Budgetdimension 1-kode;
                                                              ENU=Budget Dimension 1 Code];
                                                   CaptionClass=GetCaptionClass(1) }
    { 13  ;   ;Budget Dimension 2 Code;Code20     ;OnValidate=BEGIN
                                                                IF "Budget Dimension 2 Code" = xRec."Budget Dimension 2 Code" THEN
                                                                  EXIT;
                                                                IF GLBudgetName.Name <> "Budget Name" THEN
                                                                  GLBudgetName.GET("Budget Name");
                                                                ValidateDimValue(GLBudgetName."Budget Dimension 2 Code","Budget Dimension 2 Code");
                                                                UpdateDimensionSetId(GLBudgetName."Budget Dimension 2 Code","Budget Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              "Budget Dimension 2 Code" := OnLookupDimCode(3,"Budget Dimension 2 Code");
                                                              ValidateDimValue(GLBudgetName."Budget Dimension 2 Code","Budget Dimension 2 Code");
                                                              UpdateDimensionSetId(GLBudgetName."Budget Dimension 2 Code","Budget Dimension 2 Code");
                                                            END;

                                                   AccessByPermission=TableData 348=R;
                                                   CaptionML=[DAN=Budgetdimension 2-kode;
                                                              ENU=Budget Dimension 2 Code];
                                                   CaptionClass=GetCaptionClass(2) }
    { 14  ;   ;Budget Dimension 3 Code;Code20     ;OnValidate=BEGIN
                                                                IF "Budget Dimension 3 Code" = xRec."Budget Dimension 3 Code" THEN
                                                                  EXIT;
                                                                IF GLBudgetName.Name <> "Budget Name" THEN
                                                                  GLBudgetName.GET("Budget Name");
                                                                ValidateDimValue(GLBudgetName."Budget Dimension 3 Code","Budget Dimension 3 Code");
                                                                UpdateDimensionSetId(GLBudgetName."Budget Dimension 3 Code","Budget Dimension 3 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              "Budget Dimension 3 Code" := OnLookupDimCode(4,"Budget Dimension 3 Code");
                                                              ValidateDimValue(GLBudgetName."Budget Dimension 3 Code","Budget Dimension 3 Code");
                                                              UpdateDimensionSetId(GLBudgetName."Budget Dimension 3 Code","Budget Dimension 3 Code");
                                                            END;

                                                   AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Budgetdimension 3-kode;
                                                              ENU=Budget Dimension 3 Code];
                                                   CaptionClass=GetCaptionClass(3) }
    { 15  ;   ;Budget Dimension 4 Code;Code20     ;OnValidate=BEGIN
                                                                IF "Budget Dimension 4 Code" = xRec."Budget Dimension 4 Code" THEN
                                                                  EXIT;
                                                                IF GLBudgetName.Name <> "Budget Name" THEN
                                                                  GLBudgetName.GET("Budget Name");
                                                                ValidateDimValue(GLBudgetName."Budget Dimension 4 Code","Budget Dimension 4 Code");
                                                                UpdateDimensionSetId(GLBudgetName."Budget Dimension 4 Code","Budget Dimension 4 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              "Budget Dimension 4 Code" := OnLookupDimCode(5,"Budget Dimension 4 Code");
                                                              ValidateDimValue(GLBudgetName."Budget Dimension 4 Code","Budget Dimension 4 Code");
                                                              UpdateDimensionSetId(GLBudgetName."Budget Dimension 4 Code","Budget Dimension 4 Code");
                                                            END;

                                                   AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Budgetdimension 4-kode;
                                                              ENU=Budget Dimension 4 Code];
                                                   CaptionClass=GetCaptionClass(4) }
    { 16  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=BEGIN
                                                                IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                                                                  ERROR(DimMgt.GetDimCombErr);
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
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Budget Name,G/L Account No.,Date        ;SumIndexFields=Amount }
    {    ;Budget Name,G/L Account No.,Business Unit Code,Global Dimension 1 Code,Global Dimension 2 Code,Budget Dimension 1 Code,Budget Dimension 2 Code,Budget Dimension 3 Code,Budget Dimension 4 Code,Date;
                                                   SumIndexFields=Amount }
    {    ;Budget Name,G/L Account No.,Description,Date }
    {    ;G/L Account No.,Date,Budget Name,Dimension Set ID;
                                                   SumIndexFields=Amount }
    {    ;Last Date Modified,Budget Name           }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Dimensionsv�rdien %1 er ikke blevet angivet for dimension %2.;ENU=The dimension value %1 has not been set up for dimension %2.';
      Text001@1001 : TextConst 'DAN=1,5,,Budgetdimension 1-kode;ENU=1,5,,Budget Dimension 1 Code';
      Text002@1002 : TextConst 'DAN=1,5,,Budgetdimension 2-kode;ENU=1,5,,Budget Dimension 2 Code';
      Text003@1003 : TextConst 'DAN=1,5,,Budgetdimension 3-kode;ENU=1,5,,Budget Dimension 3 Code';
      Text004@1004 : TextConst 'DAN=1,5,,Budgetdimension 4-kode;ENU=1,5,,Budget Dimension 4 Code';
      GLBudgetName@1005 : Record 95;
      GLSetup@1006 : Record 98;
      DimVal@1009 : Record 349;
      DimMgt@1008 : Codeunit 408;
      GLSetupRetrieved@1007 : Boolean;
      AnalysisViewBudgetEntryExistsErr@1010 : TextConst 'DAN=Du kan ikke �ndre bel�bet p� denne finansbudgetpost, da der findes �n eller flere relaterede analysevisningsbudgetposter.\\Du skal foretage �ndringen p� den tilknyttede post i vinduet Finansbudget.;ENU=You cannot change the amount on this G/L budget entry because one or more related analysis view budget entries exist.\\You must make the change on the related entry in the G/L Budget window.';

    LOCAL PROCEDURE CheckIfBlocked@1();
    BEGIN
      IF "Budget Name" = GLBudgetName.Name THEN
        EXIT;
      IF GLBudgetName.Name <> "Budget Name" THEN
        GLBudgetName.GET("Budget Name");
      GLBudgetName.TESTFIELD(Blocked,FALSE);
    END;

    LOCAL PROCEDURE ValidateDimValue@5(DimCode@1000 : Code[20];VAR DimValueCode@1001 : Code[20]);
    VAR
      DimValue@1002 : Record 349;
    BEGIN
      IF DimValueCode = '' THEN
        EXIT;

      DimValue."Dimension Code" := DimCode;
      DimValue.Code := DimValueCode;
      DimValue.FIND('=><');
      IF DimValueCode <> COPYSTR(DimValue.Code,1,STRLEN(DimValueCode)) THEN
        ERROR(Text000,DimValueCode,DimCode);
      DimValueCode := DimValue.Code;
    END;

    LOCAL PROCEDURE GetGLSetup@2();
    BEGIN
      IF NOT GLSetupRetrieved THEN BEGIN
        GLSetup.GET;
        GLSetupRetrieved := TRUE;
      END;
    END;

    LOCAL PROCEDURE OnLookupDimCode@3(DimOption@1000 : 'Global Dimension 1,Global Dimension 2,Budget Dimension 1,Budget Dimension 2,Budget Dimension 3,Budget Dimension 4';DefaultValue@1001 : Code[20]) : Code[20];
    VAR
      DimValue@1002 : Record 349;
      DimValueList@1003 : Page 560;
    BEGIN
      IF DimOption IN [DimOption::"Global Dimension 1",DimOption::"Global Dimension 2"] THEN
        GetGLSetup
      ELSE
        IF GLBudgetName.Name <> "Budget Name" THEN
          GLBudgetName.GET("Budget Name");
      CASE DimOption OF
        DimOption::"Global Dimension 1":
          DimValue."Dimension Code" := GLSetup."Global Dimension 1 Code";
        DimOption::"Global Dimension 2":
          DimValue."Dimension Code" := GLSetup."Global Dimension 2 Code";
        DimOption::"Budget Dimension 1":
          DimValue."Dimension Code" := GLBudgetName."Budget Dimension 1 Code";
        DimOption::"Budget Dimension 2":
          DimValue."Dimension Code" := GLBudgetName."Budget Dimension 2 Code";
        DimOption::"Budget Dimension 3":
          DimValue."Dimension Code" := GLBudgetName."Budget Dimension 3 Code";
        DimOption::"Budget Dimension 4":
          DimValue."Dimension Code" := GLBudgetName."Budget Dimension 4 Code";
      END;
      DimValue.SETRANGE("Dimension Code",DimValue."Dimension Code");
      IF DimValue.GET(DimValue."Dimension Code",DefaultValue) THEN;
      DimValueList.SETTABLEVIEW(DimValue);
      DimValueList.SETRECORD(DimValue);
      DimValueList.LOOKUPMODE := TRUE;
      IF DimValueList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        DimValueList.GETRECORD(DimValue);
        EXIT(DimValue.Code);
      END;
      EXIT(DefaultValue);
    END;

    LOCAL PROCEDURE GetNextEntryNo@4() : Integer;
    VAR
      GLBudgetEntry@1000 : Record 96;
    BEGIN
      GLBudgetEntry.SETCURRENTKEY("Entry No.");
      IF GLBudgetEntry.FINDLAST THEN
        EXIT(GLBudgetEntry."Entry No." + 1);

      EXIT(1);
    END;

    LOCAL PROCEDURE GetCaptionClass@7(BudgetDimType@1000 : Integer) : Text[250];
    BEGIN
      IF GETFILTER("Budget Name") <> '' THEN BEGIN
        GLBudgetName.SETFILTER(Name,GETFILTER("Budget Name"));
        IF NOT GLBudgetName.FINDFIRST THEN
          CLEAR(GLBudgetName);
      END;
      CASE BudgetDimType OF
        1:
          BEGIN
            IF GLBudgetName."Budget Dimension 1 Code" <> '' THEN
              EXIT('1,5,' + GLBudgetName."Budget Dimension 1 Code");

            EXIT(Text001);
          END;
        2:
          BEGIN
            IF GLBudgetName."Budget Dimension 2 Code" <> '' THEN
              EXIT('1,5,' + GLBudgetName."Budget Dimension 2 Code");

            EXIT(Text002);
          END;
        3:
          BEGIN
            IF GLBudgetName."Budget Dimension 3 Code" <> '' THEN
              EXIT('1,5,' + GLBudgetName."Budget Dimension 3 Code");

            EXIT(Text003);
          END;
        4:
          BEGIN
            IF GLBudgetName."Budget Dimension 4 Code" <> '' THEN
              EXIT('1,5,' + GLBudgetName."Budget Dimension 4 Code");

            EXIT(Text004);
          END;
      END;
    END;

    [External]
    PROCEDURE ShowDimensions@8();
    VAR
      DimSetEntry@1000 : Record 480;
      OldDimSetID@1001 : Integer;
    BEGIN
      OldDimSetID := "Dimension Set ID";
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet(
          "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Budget Name","G/L Account No.","Entry No."));

      IF OldDimSetID = "Dimension Set ID" THEN
        EXIT;

      GetGLSetup;
      GLBudgetName.GET("Budget Name");

      "Global Dimension 1 Code" := '';
      "Global Dimension 2 Code" := '';
      "Budget Dimension 1 Code" := '';
      "Budget Dimension 2 Code" := '';
      "Budget Dimension 3 Code" := '';
      "Budget Dimension 4 Code" := '';

      IF DimSetEntry.GET("Dimension Set ID",GLSetup."Global Dimension 1 Code") THEN
        "Global Dimension 1 Code" := DimSetEntry."Dimension Value Code";
      IF DimSetEntry.GET("Dimension Set ID",GLSetup."Global Dimension 2 Code") THEN
        "Global Dimension 2 Code" := DimSetEntry."Dimension Value Code";
      IF DimSetEntry.GET("Dimension Set ID",GLBudgetName."Budget Dimension 1 Code") THEN
        "Budget Dimension 1 Code" := DimSetEntry."Dimension Value Code";
      IF DimSetEntry.GET("Dimension Set ID",GLBudgetName."Budget Dimension 2 Code") THEN
        "Budget Dimension 2 Code" := DimSetEntry."Dimension Value Code";
      IF DimSetEntry.GET("Dimension Set ID",GLBudgetName."Budget Dimension 3 Code") THEN
        "Budget Dimension 3 Code" := DimSetEntry."Dimension Value Code";
      IF DimSetEntry.GET("Dimension Set ID",GLBudgetName."Budget Dimension 4 Code") THEN
        "Budget Dimension 4 Code" := DimSetEntry."Dimension Value Code";
    END;

    [External]
    PROCEDURE UpdateDimSet@6(VAR TempDimSetEntry@1003 : TEMPORARY Record 480;DimCode@1000 : Code[20];DimValueCode@1001 : Code[20]);
    BEGIN
      IF DimCode = '' THEN
        EXIT;
      IF TempDimSetEntry.GET("Dimension Set ID",DimCode) THEN
        TempDimSetEntry.DELETE;
      IF DimValueCode = '' THEN
        DimVal.INIT
      ELSE
        DimVal.GET(DimCode,DimValueCode);
      TempDimSetEntry.INIT;
      TempDimSetEntry."Dimension Set ID" := "Dimension Set ID";
      TempDimSetEntry."Dimension Code" := DimCode;
      TempDimSetEntry."Dimension Value Code" := DimValueCode;
      TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
      TempDimSetEntry.INSERT;
    END;

    LOCAL PROCEDURE UpdateDimensionSetId@9(DimCode@1002 : Code[20];DimValueCode@1001 : Code[20]);
    VAR
      TempDimSetEntry@1000 : TEMPORARY Record 480;
    BEGIN
      DimMgt.GetDimensionSet(TempDimSetEntry,"Dimension Set ID");
      UpdateDimSet(TempDimSetEntry,DimCode,DimValueCode);
      "Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    END;

    LOCAL PROCEDURE DeleteAnalysisViewBudgetEntries@10();
    VAR
      AnalysisViewBudgetEntry@1000 : Record 366;
    BEGIN
      AnalysisViewBudgetEntry.SETRANGE("Budget Name","Budget Name");
      AnalysisViewBudgetEntry.SETRANGE("Entry No.","Entry No.");
      AnalysisViewBudgetEntry.DELETEALL;
    END;

    LOCAL PROCEDURE VerifyNoRelatedAnalysisViewBudgetEntries@11(GLBudgetEntry@1001 : Record 96);
    VAR
      AnalysisViewBudgetEntry@1000 : Record 366;
    BEGIN
      AnalysisViewBudgetEntry.SETRANGE("Budget Name",GLBudgetEntry."Budget Name");
      AnalysisViewBudgetEntry.SETRANGE("G/L Account No.",GLBudgetEntry."G/L Account No.");
      AnalysisViewBudgetEntry.SETRANGE("Posting Date",GLBudgetEntry.Date);
      AnalysisViewBudgetEntry.SETRANGE("Business Unit Code",GLBudgetEntry."Business Unit Code");
      IF NOT AnalysisViewBudgetEntry.ISEMPTY THEN
        ERROR(AnalysisViewBudgetEntryExistsErr);
    END;

    BEGIN
    END.
  }
}

