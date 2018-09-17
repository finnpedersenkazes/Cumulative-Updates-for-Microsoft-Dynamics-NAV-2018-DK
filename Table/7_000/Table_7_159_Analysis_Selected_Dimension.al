OBJECT Table 7159 Analysis Selected Dimension
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dimension for valgt analyse;
               ENU=Analysis Selected Dimension];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Object Type         ;Integer       ;CaptionML=[DAN=Objekttype;
                                                              ENU=Object Type] }
    { 3   ;   ;Object ID           ;Integer       ;CaptionML=[DAN=Objekt-id;
                                                              ENU=Object ID] }
    { 4   ;   ;Dimension Code      ;Text30        ;CaptionML=[DAN=Dimensionskode;
                                                              ENU=Dimension Code] }
    { 5   ;   ;New Dimension Value Code;Code20    ;CaptionML=[DAN=Ny dimensionsv‘rdikode;
                                                              ENU=New Dimension Value Code] }
    { 6   ;   ;Dimension Value Filter;Code250     ;CaptionML=[DAN=Dimensionsv‘rdifilter;
                                                              ENU=Dimension Value Filter] }
    { 7   ;   ;Level               ;Option        ;CaptionML=[DAN=Niveau;
                                                              ENU=Level];
                                                   OptionCaptionML=[DAN=" ,Niveau 1,Niveau 2,Niveau 3";
                                                                    ENU=" ,Level 1,Level 2,Level 3"];
                                                   OptionString=[ ,Level 1,Level 2,Level 3] }
    { 8   ;   ;Analysis View Code  ;Code10        ;TableRelation="Item Analysis View".Code WHERE (Analysis Area=FIELD(Analysis Area));
                                                   CaptionML=[DAN=Analysevisningskode;
                                                              ENU=Analysis View Code] }
    { 9   ;   ;Analysis Area       ;Option        ;CaptionML=[DAN=Analyseomr†de;
                                                              ENU=Analysis Area];
                                                   OptionCaptionML=[DAN=Salg,K›b,Lager;
                                                                    ENU=Sales,Purchase,Inventory];
                                                   OptionString=Sales,Purchase,Inventory }
  }
  KEYS
  {
    {    ;User ID,Object Type,Object ID,Analysis Area,Analysis View Code,Dimension Code;
                                                   Clustered=Yes }
    {    ;User ID,Object Type,Object ID,Analysis Area,Analysis View Code,Level,Dimension Code }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE GetSelectedDim@9(UserID2@1000 : Code[50];ObjectType@1001 : Integer;ObjectID@1002 : Integer;AnalysisArea@1005 : Integer;AnalysisViewCode@1003 : Code[10];VAR TempAnalysisSelectedDim@1004 : TEMPORARY Record 7159);
    BEGIN
      SETRANGE("User ID",UserID2);
      SETRANGE("Object Type",ObjectType);
      SETRANGE("Object ID",ObjectID);
      SETRANGE("Analysis Area",AnalysisArea);
      SETRANGE("Analysis View Code",AnalysisViewCode);
      IF FIND('-') THEN
        REPEAT
          TempAnalysisSelectedDim := Rec;
          TempAnalysisSelectedDim.INSERT;
        UNTIL NEXT = 0;
    END;

    BEGIN
    END.
  }
}

