OBJECT Table 1470 Product Video Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Produktvideobuffer;
               ENU=Product Video Buffer];
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Integer       ;AutoIncrement=Yes;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id;
                                                              ENU=ID];
                                                   Editable=No }
    { 2   ;   ;Title               ;Text250       ;TableRelation="Assisted Setup".Name;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Titel;
                                                              ENU=Title] }
    { 3   ;   ;Video Url           ;Text250       ;TableRelation="Assisted Setup"."Video Url";
                                                   TestTableRelation=No;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Video-URL-adresse;
                                                              ENU=Video Url] }
    { 4   ;   ;Assisted Setup ID   ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Assisteret ops�tnings-id;
                                                              ENU=Assisted Setup ID] }
    { 5   ;   ;Indentation         ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indrykning;
                                                              ENU=Indentation] }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      EntryNo@1001 : Integer;

    PROCEDURE InitBuffer@4(VAR TempProductVideoBuffer@1000 : TEMPORARY Record 1470;Category@1003 : Option);
    BEGIN
      TempProductVideoBuffer.DELETEALL;

      InitVideoTree(TempProductVideoBuffer,Category);
      TempProductVideoBuffer.SETCURRENTKEY(ID);
      IF TempProductVideoBuffer.FINDFIRST THEN;
    END;

    LOCAL PROCEDURE InitVideoTree@7(VAR TempProductVideoBuffer@1000 : TEMPORARY Record 1470;Category@1003 : Option);
    VAR
      ProductVideoCategory@1001 : Record 1471;
    BEGIN
      CASE Category OF
        ProductVideoCategory.Category::" ":
          AddAllVideos(TempProductVideoBuffer);
        ELSE
          AddVideosToCategory(TempProductVideoBuffer,Category);
      END;
    END;

    LOCAL PROCEDURE AddAllVideos@3(VAR TempProductVideoBuffer@1000 : TEMPORARY Record 1470);
    VAR
      ProductVideoCategory@1006 : Record 1471;
      TypeHelper@1005 : Codeunit 10;
      RecRef@1001 : RecordRef;
      FieldRef@1002 : FieldRef;
      Index@1004 : Integer;
    BEGIN
      RecRef.OPEN(DATABASE::"Product Video Category");
      FieldRef := RecRef.FIELD(ProductVideoCategory.FIELDNO(Category));

      FOR Index := 1 TO TypeHelper.GetNumberOfOptions(FieldRef.OPTIONSTRING) DO
        InitVideoTree(TempProductVideoBuffer,Index);
    END;

    LOCAL PROCEDURE AddVideosToCategory@2(VAR TempProductVideoBuffer@1000 : TEMPORARY Record 1470;Category@1003 : Option);
    VAR
      ProductVideoswithCategory@1004 : Query 1470;
    BEGIN
      ProductVideoswithCategory.SETRANGE(Category,Category);
      ProductVideoswithCategory.OPEN;
      IF ProductVideoswithCategory.READ THEN BEGIN
        AddCategory(TempProductVideoBuffer,FORMAT(ProductVideoswithCategory.Category));
        REPEAT
          IF ProductVideoswithCategory.Alternate_Title <> '' THEN
            AddVideoToCategory(TempProductVideoBuffer,ProductVideoswithCategory.Assisted_Setup_ID,
              ProductVideoswithCategory.Alternate_Title,ProductVideoswithCategory.Video_Url)
          ELSE
            AddVideoToCategory(TempProductVideoBuffer,ProductVideoswithCategory.Assisted_Setup_ID,
              ProductVideoswithCategory.Name,ProductVideoswithCategory.Video_Url);
        UNTIL ProductVideoswithCategory.READ = FALSE;
      END;
      ProductVideoswithCategory.CLOSE;
    END;

    LOCAL PROCEDURE AddCategory@1(VAR TempProductVideoBuffer@1002 : TEMPORARY Record 1470;CategoryName@1004 : Text[250]);
    BEGIN
      InsertRec(TempProductVideoBuffer,0,CategoryName,'',0);
    END;

    LOCAL PROCEDURE AddVideoToCategory@5(VAR TempProductVideoBuffer@1002 : TEMPORARY Record 1470;Id@1004 : Integer;VideoName@1000 : Text[250];VideoUrl@1001 : Text[250]);
    BEGIN
      InsertRec(TempProductVideoBuffer,Id,VideoName,VideoUrl,1);
    END;

    LOCAL PROCEDURE InsertRec@6(VAR TempProductVideoBuffer@1003 : TEMPORARY Record 1470;Id@1004 : Integer;VideoName@1000 : Text[250];VideoUrl@1001 : Text[250];Indent@1002 : Integer);
    BEGIN
      EntryNo := EntryNo + 1;
      TempProductVideoBuffer.INIT;
      TempProductVideoBuffer.ID := EntryNo;
      TempProductVideoBuffer.Title := VideoName;
      TempProductVideoBuffer."Video Url" := VideoUrl;
      TempProductVideoBuffer."Assisted Setup ID" := Id;
      TempProductVideoBuffer.Indentation := Indent;
      TempProductVideoBuffer.INSERT;
    END;

    BEGIN
    END.
  }
}

