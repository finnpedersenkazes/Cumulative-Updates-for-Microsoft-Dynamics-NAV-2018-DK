OBJECT Table 368 Dimension Selection Buffer
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer til dimensionsvalg;
               ENU=Dimension Selection Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code] }
    { 2   ;   ;Description         ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Selected            ;Boolean       ;OnValidate=BEGIN
                                                                "New Dimension Value Code" := '';
                                                                "Dimension Value Filter" := '';
                                                                Level := Level::" ";
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Markeret;
                                                              ENU=Selected] }
    { 4   ;   ;New Dimension Value Code;Code20    ;TableRelation=IF (Code=CONST(G/L Account)) "G/L Account".No.
                                                                 ELSE IF (Code=CONST(Business Unit)) "Business Unit".Code
                                                                 ELSE "Dimension Value".Code WHERE (Dimension Code=FIELD(Code));
                                                   OnValidate=BEGIN
                                                                Selected := TRUE;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny dimensionsv�rdikode;
                                                              ENU=New Dimension Value Code] }
    { 5   ;   ;Dimension Value Filter;Code250     ;TableRelation=IF (Filter Lookup Table No.=CONST(15)) "G/L Account".No.
                                                                 ELSE IF (Filter Lookup Table No.=CONST(220)) "Business Unit".Code
                                                                 ELSE IF (Filter Lookup Table No.=CONST(841)) "Cash Flow Account".No.
                                                                 ELSE IF (Filter Lookup Table No.=CONST(840)) "Cash Flow Forecast".No.
                                                                 ELSE "Dimension Value".Code WHERE (Dimension Code=FIELD(Code));
                                                   OnValidate=BEGIN
                                                                IF (Level = Level::" ") AND ("Dimension Value Filter" = '') THEN
                                                                  Selected := FALSE
                                                                ELSE
                                                                  Selected := TRUE;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv�rdifilter;
                                                              ENU=Dimension Value Filter] }
    { 6   ;   ;Level               ;Option        ;OnValidate=BEGIN
                                                                IF (Level = Level::" ") AND ("Dimension Value Filter" = '') THEN
                                                                  Selected := FALSE
                                                                ELSE
                                                                  Selected := TRUE;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Niveau;
                                                              ENU=Level];
                                                   OptionCaptionML=[DAN=" ,Niveau 1,Niveau 2,Niveau 3,Niveau 4";
                                                                    ENU=" ,Level 1,Level 2,Level 3,Level 4"];
                                                   OptionString=[ ,Level 1,Level 2,Level 3,Level 4] }
    { 7   ;   ;Filter Lookup Table No.;Integer    ;InitValue=349;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Filteropslagstabelnr.;
                                                              ENU=Filter Lookup Table No.];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
    {    ;Level,Code                               }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=En anden bruger har �ndret de valgte dimensioner for feltet %1, efter at du indl�ste det fra databasen.\;ENU=Another user has modified the selected dimensions for the %1 field after you retrieved it from the database.\';
      Text002@1002 : TextConst 'DAN="Angiv dine �ndringer igen i vinduet Dimensionsvalg ved at klikke p� AssistButton i feltet %1. ";ENU="Enter your changes again in the Dimension Selection window by clicking the AssistButton on the %1 field. "';

    [External]
    PROCEDURE SetDimSelectionMultiple@4(ObjectType@1000 : Integer;ObjectID@1001 : Integer;VAR SelectedDimText@1002 : Text[250]);
    VAR
      SelectedDim@1006 : Record 369;
      Dim@1003 : Record 348;
      TempDimSelectionBuf@1004 : TEMPORARY Record 368;
      DimSelectionMultiple@1005 : Page 562;
    BEGIN
      CLEAR(DimSelectionMultiple);
      IF Dim.FIND('-') THEN
        REPEAT
          DimSelectionMultiple.InsertDimSelBuf(
            SelectedDim.GET(USERID,ObjectType,ObjectID,'',Dim.Code),
            Dim.Code,Dim.GetMLName(GLOBALLANGUAGE));
        UNTIL Dim.NEXT = 0;

      IF DimSelectionMultiple.RUNMODAL = ACTION::OK THEN BEGIN
        DimSelectionMultiple.GetDimSelBuf(TempDimSelectionBuf);
        SetDimSelection(ObjectType,ObjectID,'',SelectedDimText,TempDimSelectionBuf);
      END;
    END;

    [External]
    PROCEDURE SetDimSelectionChange@1(ObjectType@1000 : Integer;ObjectID@1001 : Integer;VAR SelectedDimText@1002 : Text[250]);
    VAR
      SelectedDim@1006 : Record 369;
      Dim@1003 : Record 348;
      TempDimSelectionBuf@1004 : TEMPORARY Record 368;
      DimSelectionChange@1005 : Page 567;
    BEGIN
      CLEAR(DimSelectionChange);
      IF Dim.FIND('-') THEN
        REPEAT
          DimSelectionChange.InsertDimSelBuf(
            SelectedDim.GET(USERID,ObjectType,ObjectID,'',Dim.Code),
            Dim.Code,Dim.GetMLName(GLOBALLANGUAGE),
            SelectedDim."New Dimension Value Code",
            SelectedDim."Dimension Value Filter");
        UNTIL Dim.NEXT = 0;

      IF DimSelectionChange.RUNMODAL = ACTION::OK THEN BEGIN
        DimSelectionChange.GetDimSelBuf(TempDimSelectionBuf);
        SetDimSelection(ObjectType,ObjectID,'',SelectedDimText,TempDimSelectionBuf);
      END;
    END;

    [External]
    PROCEDURE CompareDimText@2(ObjectType@1000 : Integer;ObjectID@1001 : Integer;AnalysisViewCode@1002 : Code[10];SelectedDimText@1003 : Text[250];DimTextFieldName@1004 : Text[100]);
    VAR
      SelectedDim@1005 : Record 369;
      SelectedDimTextFromDb@1006 : Text[250];
    BEGIN
      SelectedDimTextFromDb := '';
      SelectedDim.SETCURRENTKEY(
        "User ID","Object Type","Object ID","Analysis View Code",Level,"Dimension Code");
      SetDefaultRangeOnSelectedDimTable(SelectedDim,ObjectType,ObjectID,AnalysisViewCode);
      IF SelectedDim.FIND('-') THEN
        REPEAT
          AddDimCodeToText(SelectedDim."Dimension Code",SelectedDimTextFromDb);
        UNTIL SelectedDim.NEXT = 0;
      IF SelectedDimTextFromDb <> SelectedDimText THEN
        ERROR(
          Text000 +
          Text002,
          DimTextFieldName);
    END;

    LOCAL PROCEDURE AddDimCodeToText@3(DimCode@1000 : Code[20];VAR Text@1001 : Text[250]);
    BEGIN
      IF Text = '' THEN
        Text := DimCode
      ELSE
        IF (STRLEN(Text) + STRLEN(DimCode)) <= (MAXSTRLEN(Text) - 4) THEN
          Text := STRSUBSTNO('%1;%2',Text,DimCode)
        ELSE
          IF COPYSTR(Text,STRLEN(Text) - 2,3) <> '...' THEN
            Text := STRSUBSTNO('%1;...',Text)
    END;

    [External]
    PROCEDURE SetDimSelection@5(ObjectType@1000 : Integer;ObjectID@1001 : Integer;AnalysisViewCode@1002 : Code[10];VAR SelectedDimText@1003 : Text[250];VAR DimSelectionBuf@1004 : Record 368);
    VAR
      SelectedDim@1005 : Record 369;
    BEGIN
      SetDefaultRangeOnSelectedDimTable(SelectedDim,ObjectType,ObjectID,AnalysisViewCode);
      SelectedDim.DELETEALL;
      SelectedDimText := '';
      DimSelectionBuf.SETCURRENTKEY(Level,Code);
      DimSelectionBuf.SETRANGE(Selected,TRUE);
      IF DimSelectionBuf.FIND('-') THEN BEGIN
        REPEAT
          SelectedDim."User ID" := USERID;
          SelectedDim."Object Type" := ObjectType;
          SelectedDim."Object ID" := ObjectID;
          SelectedDim."Analysis View Code" := AnalysisViewCode;
          SelectedDim."Dimension Code" := DimSelectionBuf.Code;
          SelectedDim."New Dimension Value Code" := DimSelectionBuf."New Dimension Value Code";
          SelectedDim."Dimension Value Filter" := DimSelectionBuf."Dimension Value Filter";
          SelectedDim.Level := DimSelectionBuf.Level;
          SelectedDim.INSERT;
        UNTIL DimSelectionBuf.NEXT = 0;
        SelectedDimText := GetDimSelectionText(ObjectType,ObjectID,AnalysisViewCode);
      END;
    END;

    [External]
    PROCEDURE SetDimSelectionLevelGLAcc@40(ObjectType@1000 : Integer;ObjectID@1001 : Integer;AnalysisViewCode@1002 : Code[10];VAR SelectedDimText@1003 : Text[250]);
    VAR
      GLAcc@1007 : Record 15;
    BEGIN
      SetDimSelectionLevelWithAutoSet(ObjectType,ObjectID,AnalysisViewCode,SelectedDimText,GLAcc.TABLECAPTION,FALSE);
    END;

    [External]
    PROCEDURE SetDimSelectionLevelGLAccAutoSet@9(ObjectType@1000 : Integer;ObjectID@1001 : Integer;AnalysisViewCode@1002 : Code[10];VAR SelectedDimText@1003 : Text[250]);
    VAR
      GLAcc@1007 : Record 15;
    BEGIN
      SetDimSelectionLevelWithAutoSet(ObjectType,ObjectID,AnalysisViewCode,SelectedDimText,GLAcc.TABLECAPTION,TRUE);
    END;

    [External]
    PROCEDURE SetDimSelectionLevelCFAcc@7(ObjectType@1000 : Integer;ObjectID@1001 : Integer;AnalysisViewCode@1002 : Code[10];VAR SelectedDimText@1003 : Text[250]);
    VAR
      CFAcc@1007 : Record 841;
    BEGIN
      SetDimSelectionLevelWithAutoSet(ObjectType,ObjectID,AnalysisViewCode,SelectedDimText,CFAcc.TABLECAPTION,FALSE);
    END;

    LOCAL PROCEDURE SetDimSelectionLevelWithAutoSet@13(ObjectType@1004 : Integer;ObjectID@1003 : Integer;AnalysisViewCode@1002 : Code[10];VAR SelectedDimText@1001 : Text[250];AccTableCaption@1000 : Text[30];AutoSet@1010 : Boolean);
    VAR
      SelectedDim@1009 : Record 369;
      AnalysisView@1008 : Record 363;
      Dim@1007 : Record 348;
      TempDimSelectionBuf@1006 : TEMPORARY Record 368;
      DimSelectionLevel@1005 : Page 564;
      SelectedDimLevel@1012 : Option;
      GetSelectedDim@1011 : Boolean;
      Finished@1013 : Boolean;
    BEGIN
      CLEAR(DimSelectionLevel);
      IF AnalysisView.GET(AnalysisViewCode) THEN BEGIN
        IF Dim.GET(AnalysisView."Dimension 1 Code") THEN BEGIN
          GetSelectedDim := SelectedDim.GET(USERID,ObjectType,ObjectID,AnalysisViewCode,Dim.Code);
          IF AutoSet AND (SelectedDim.Level = SelectedDim.Level::" ") THEN BEGIN
            SelectedDimLevel := SelectedDim.Level::"Level 2";
            GetSelectedDim := TRUE;
          END ELSE
            SelectedDimLevel := SelectedDim.Level;

          DimSelectionLevel.InsertDimSelBuf(
            GetSelectedDim,
            Dim.Code,Dim.GetMLName(GLOBALLANGUAGE),
            SelectedDim."Dimension Value Filter",SelectedDimLevel);
        END;

        IF Dim.GET(AnalysisView."Dimension 2 Code") THEN
          DimSelectionLevel.InsertDimSelBuf(
            SelectedDim.GET(USERID,ObjectType,ObjectID,AnalysisViewCode,Dim.Code),
            Dim.Code,Dim.GetMLName(GLOBALLANGUAGE),
            SelectedDim."Dimension Value Filter",SelectedDim.Level);

        IF Dim.GET(AnalysisView."Dimension 3 Code") THEN
          DimSelectionLevel.InsertDimSelBuf(
            SelectedDim.GET(USERID,ObjectType,ObjectID,AnalysisViewCode,Dim.Code),
            Dim.Code,Dim.GetMLName(GLOBALLANGUAGE),
            SelectedDim."Dimension Value Filter",SelectedDim.Level);

        IF Dim.GET(AnalysisView."Dimension 4 Code") THEN
          DimSelectionLevel.InsertDimSelBuf(
            SelectedDim.GET(USERID,ObjectType,ObjectID,AnalysisViewCode,Dim.Code),
            Dim.Code,Dim.GetMLName(GLOBALLANGUAGE),
            SelectedDim."Dimension Value Filter",SelectedDim.Level);

        GetSelectedDim := SelectedDim.GET(USERID,ObjectType,ObjectID,AnalysisViewCode,AccTableCaption);
        IF AutoSet AND (SelectedDim.Level = SelectedDim.Level::" ") THEN
          SelectedDimLevel := SelectedDim.Level::"Level 1"
        ELSE
          SelectedDimLevel := SelectedDim.Level;

        DimSelectionLevel.InsertDimSelBuf(
          GetSelectedDim,
          AccTableCaption,AccTableCaption,
          SelectedDim."Dimension Value Filter",SelectedDimLevel);
      END;

      IF NOT AutoSet THEN
        Finished := DimSelectionLevel.RUNMODAL = ACTION::OK
      ELSE
        Finished := TRUE;

      IF Finished THEN BEGIN
        DimSelectionLevel.GetDimSelBuf(TempDimSelectionBuf);
        SetDimSelection(ObjectType,ObjectID,AnalysisViewCode,SelectedDimText,TempDimSelectionBuf);
      END;
    END;

    [External]
    PROCEDURE GetDimSelectionText@6(ObjectType@1000 : Integer;ObjectID@1001 : Integer;AnalysisViewCode@1002 : Code[10]) : Text[250];
    VAR
      SelectedDim@1003 : Record 369;
      SelectedDimText@1004 : Text[250];
    BEGIN
      SetDefaultRangeOnSelectedDimTable(SelectedDim,ObjectType,ObjectID,AnalysisViewCode);
      SelectedDim.SETCURRENTKEY("User ID","Object Type","Object ID","Analysis View Code",Level,"Dimension Code");
      WITH SelectedDim DO BEGIN
        IF FIND('-') THEN
          REPEAT
            AddDimCodeToText("Dimension Code",SelectedDimText);
          UNTIL NEXT = 0;
      END;
      EXIT(SelectedDimText);
    END;

    LOCAL PROCEDURE SetDefaultRangeOnSelectedDimTable@10(VAR SelectedDim@1003 : Record 369;ObjectType@1002 : Integer;ObjectID@1001 : Integer;AnalysisViewCode@1000 : Code[10]);
    BEGIN
      SelectedDim.SETRANGE("User ID",USERID);
      SelectedDim.SETRANGE("Object Type",ObjectType);
      SelectedDim.SETRANGE("Object ID",ObjectID);
      SelectedDim.SETRANGE("Analysis View Code",AnalysisViewCode);
    END;

    BEGIN
    END.
  }
}

