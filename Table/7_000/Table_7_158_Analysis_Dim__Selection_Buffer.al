OBJECT Table 7158 Analysis Dim. Selection Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer til analysedimensionsvalg;
               ENU=Analysis Dim. Selection Buffer];
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
    { 4   ;   ;New Dimension Value Code;Code20    ;TableRelation=IF (Code=CONST(Item)) Item.No.
                                                                 ELSE IF (Code=CONST(Location)) Location.Code
                                                                 ELSE "Dimension Value".Code WHERE (Dimension Code=FIELD(Code));
                                                   OnValidate=BEGIN
                                                                Selected := TRUE;
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ny dimensionsv�rdikode;
                                                              ENU=New Dimension Value Code] }
    { 5   ;   ;Dimension Value Filter;Code250     ;TableRelation=IF (Code=CONST(Item)) Item.No.
                                                                 ELSE IF (Code=CONST(Location)) Location.Code
                                                                 ELSE "Dimension Value".Code WHERE (Dimension Code=FIELD(Code));
                                                   OnValidate=BEGIN
                                                                Selected := (Level <> Level::" ") OR ("Dimension Value Filter" <> '');
                                                              END;

                                                   ValidateTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsv�rdifilter;
                                                              ENU=Dimension Value Filter] }
    { 6   ;   ;Level               ;Option        ;OnValidate=BEGIN
                                                                Selected := (Level <> Level::" ") OR ("Dimension Value Filter" <> '');
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Niveau;
                                                              ENU=Level];
                                                   OptionCaptionML=[DAN=" ,Niveau 1,Niveau 2,Niveau 3";
                                                                    ENU=" ,Level 1,Level 2,Level 3"];
                                                   OptionString=[ ,Level 1,Level 2,Level 3] }
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
      Text002@1002 : TextConst 'DAN="Angiv dine �ndringer igen i vinduet Dimensionsvalg ved at klikke p� AssistButton i feltet %1. ";ENU="Enter your changes again in the Dimension Selection window by clicking the AssistButton in the %1 field. "';
      AnalysisSelectedDim@1004 : Record 7159;

    [External]
    PROCEDURE CompareDimText@2(ObjectType@1000 : Integer;ObjectID@1001 : Integer;AnalysisArea@1007 : Integer;AnalysisViewCode@1002 : Code[10];SelectedDimText@1003 : Text[250];DimTextFieldName@1004 : Text[100]);
    VAR
      AnalysisSelectedDim@1005 : Record 7159;
      SelectedDimTextFromDb@1006 : Text[250];
    BEGIN
      SelectedDimTextFromDb := '';
      AnalysisSelectedDim.SETCURRENTKEY(
        "User ID","Object Type","Object ID","Analysis Area","Analysis View Code",Level,"Dimension Code");
      AnalysisSelectedDim.SETRANGE("User ID",USERID);
      AnalysisSelectedDim.SETRANGE("Object Type",ObjectType);
      AnalysisSelectedDim.SETRANGE("Object ID",ObjectID);
      AnalysisSelectedDim.SETRANGE("Analysis Area",AnalysisArea);
      AnalysisSelectedDim.SETRANGE("Analysis View Code",AnalysisViewCode);
      IF AnalysisSelectedDim.FIND('-') THEN
        REPEAT
          AddDimCodeToText(AnalysisSelectedDim."Dimension Code",SelectedDimTextFromDb);
        UNTIL AnalysisSelectedDim.NEXT = 0;
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
          Text := STRSUBSTNO('%1; %2',Text,DimCode)
        ELSE
          Text := STRSUBSTNO('%1;...',Text)
    END;

    [External]
    PROCEDURE SetDimSelection@5(ObjectType@1000 : Integer;ObjectID@1001 : Integer;AnalysisArea@1005 : Integer;AnalysisViewCode@1002 : Code[10];VAR SelectedDimText@1003 : Text[250];VAR AnalysisDimSelBuf@1004 : Record 7158);
    BEGIN
      AnalysisSelectedDim.SETRANGE("User ID",USERID);
      AnalysisSelectedDim.SETRANGE("Object Type",ObjectType);
      AnalysisSelectedDim.SETRANGE("Object ID",ObjectID);
      AnalysisSelectedDim.SETRANGE("Analysis Area",AnalysisArea);
      AnalysisSelectedDim.SETRANGE("Analysis View Code",AnalysisViewCode);
      AnalysisSelectedDim.DELETEALL;
      SelectedDimText := '';
      AnalysisDimSelBuf.SETCURRENTKEY(Level,Code);
      AnalysisDimSelBuf.SETRANGE(Selected,TRUE);
      IF AnalysisDimSelBuf.FIND('-') THEN
        REPEAT
          AnalysisSelectedDim."User ID" := USERID;
          AnalysisSelectedDim."Object Type" := ObjectType;
          AnalysisSelectedDim."Object ID" := ObjectID;
          AnalysisSelectedDim."Analysis Area" := AnalysisArea;
          AnalysisSelectedDim."Analysis View Code" := AnalysisViewCode;
          AnalysisSelectedDim."Dimension Code" := AnalysisDimSelBuf.Code;
          AnalysisSelectedDim."New Dimension Value Code" := AnalysisDimSelBuf."New Dimension Value Code";
          AnalysisSelectedDim."Dimension Value Filter" := AnalysisDimSelBuf."Dimension Value Filter";
          AnalysisSelectedDim.Level := AnalysisDimSelBuf.Level;
          AnalysisSelectedDim.INSERT;
          AddDimCodeToText(AnalysisSelectedDim."Dimension Code",SelectedDimText);
        UNTIL AnalysisDimSelBuf.NEXT = 0;
    END;

    [External]
    PROCEDURE SetDimSelectionLevel@40(ObjectType@1000 : Integer;ObjectID@1001 : Integer;AnalysisArea@1009 : Integer;AnalysisViewCode@1002 : Code[10];VAR SelectedDimText@1003 : Text[250]);
    VAR
      Item@1007 : Record 27;
      Location@1010 : Record 14;
      ItemAnalysisView@1004 : Record 7152;
      Dim@1005 : Record 348;
      TempAnalysisDimSelBuf@1006 : TEMPORARY Record 7158;
      AnalysisDimSelectionLevel@1008 : Page 7161;
    BEGIN
      CLEAR(AnalysisDimSelectionLevel);
      IF ItemAnalysisView.GET(AnalysisArea,AnalysisViewCode) THEN BEGIN
        IF Dim.GET(ItemAnalysisView."Dimension 1 Code") THEN
          AnalysisDimSelectionLevel.InsertDimSelBuf(
            AnalysisSelectedDim.GET(USERID,ObjectType,ObjectID,AnalysisArea,AnalysisViewCode,Dim.Code),
            Dim.Code,Dim.GetMLName(GLOBALLANGUAGE),
            AnalysisSelectedDim."Dimension Value Filter",AnalysisSelectedDim.Level);

        IF Dim.GET(ItemAnalysisView."Dimension 2 Code") THEN
          AnalysisDimSelectionLevel.InsertDimSelBuf(
            AnalysisSelectedDim.GET(USERID,ObjectType,ObjectID,AnalysisArea,AnalysisViewCode,Dim.Code),
            Dim.Code,Dim.GetMLName(GLOBALLANGUAGE),
            AnalysisSelectedDim."Dimension Value Filter",AnalysisSelectedDim.Level);

        IF Dim.GET(ItemAnalysisView."Dimension 3 Code") THEN
          AnalysisDimSelectionLevel.InsertDimSelBuf(
            AnalysisSelectedDim.GET(USERID,ObjectType,ObjectID,AnalysisArea,AnalysisViewCode,Dim.Code),
            Dim.Code,Dim.GetMLName(GLOBALLANGUAGE),
            AnalysisSelectedDim."Dimension Value Filter",AnalysisSelectedDim.Level);

        AnalysisDimSelectionLevel.InsertDimSelBuf(
          AnalysisSelectedDim.GET(USERID,ObjectType,ObjectID,AnalysisArea,AnalysisViewCode,Item.TABLECAPTION),
          Item.TABLECAPTION,Item.TABLECAPTION,
          AnalysisSelectedDim."Dimension Value Filter",AnalysisSelectedDim.Level);
        AnalysisDimSelectionLevel.InsertDimSelBuf(
          AnalysisSelectedDim.GET(USERID,ObjectType,ObjectID,AnalysisArea,AnalysisViewCode,Location.TABLECAPTION),
          Location.TABLECAPTION,Location.TABLECAPTION,
          AnalysisSelectedDim."Dimension Value Filter",AnalysisSelectedDim.Level);
      END;

      AnalysisDimSelectionLevel.LOOKUPMODE := TRUE;
      IF AnalysisDimSelectionLevel.RUNMODAL = ACTION::LookupOK THEN BEGIN
        AnalysisDimSelectionLevel.GetDimSelBuf(TempAnalysisDimSelBuf);
        SetDimSelection(ObjectType,ObjectID,AnalysisArea,AnalysisViewCode,SelectedDimText,TempAnalysisDimSelBuf);
      END;
    END;

    BEGIN
    END.
  }
}

