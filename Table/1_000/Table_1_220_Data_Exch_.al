OBJECT Table 1220 Data Exch.
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 1220=i,
                TableData 1221=rimd;
    OnDelete=VAR
               DataExchField@1000 : Record 1221;
             BEGIN
               DataExchField.SETRANGE("Data Exch. No.","Entry No.");
               DataExchField.DELETEALL;
             END;

    CaptionML=[DAN=Dataudveksling;
               ENU=Data Exch.];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;File Name           ;Text250       ;CaptionML=[DAN=Filnavn;
                                                              ENU=File Name] }
    { 3   ;   ;File Content        ;BLOB          ;CaptionML=[DAN=Filindhold;
                                                              ENU=File Content] }
    { 4   ;   ;Data Exch. Def Code ;Code20        ;TableRelation="Data Exch. Def";
                                                   CaptionML=[DAN=Dataudvekslingsdefinitionskode;
                                                              ENU=Data Exch. Def Code] }
    { 5   ;   ;Data Exch. Line Def Code;Code20    ;TableRelation="Data Exch. Line Def".Code WHERE (Data Exch. Def Code=FIELD(Data Exch. Def Code));
                                                   CaptionML=[DAN=Definitionskode for dataudvekslingslinje;
                                                              ENU=Data Exch. Line Def Code] }
    { 6   ;   ;Table Filters       ;BLOB          ;CaptionML=[DAN=Tabelfiltre;
                                                              ENU=Table Filters] }
    { 10  ;   ;Incoming Entry No.  ;Integer       ;TableRelation="Incoming Document";
                                                   CaptionML=[DAN=Indg�ende l�benummer;
                                                              ENU=Incoming Entry No.] }
    { 11  ;   ;Related Record      ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Relateret record;
                                                              ENU=Related Record] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ProgressWindowMsg@1000 : TextConst 'DAN=Vent venligst, mens operationen afsluttes.;ENU=Please wait while the operation is being completed.';
      TxtExtTok@1002 : TextConst '@@@={Locked};DAN=.txt;ENU=.txt';
      XmlExtTok@1001 : TextConst '@@@={Locked};DAN=.xml;ENU=.xml';
      JsonExtTok@1003 : TextConst '@@@={Locked};DAN=.json;ENU=.json';

    [External]
    PROCEDURE InsertRec@1(FileName@1001 : Text[250];VAR FileContent@1002 : InStream;DataExchDefCode@1003 : Code[20]);
    VAR
      DataExchLineDef@1000 : Record 1227;
      OutStream@1005 : OutStream;
    BEGIN
      INIT;
      VALIDATE("File Name",FileName);
      "File Content".CREATEOUTSTREAM(OutStream);
      COPYSTREAM(OutStream,FileContent);
      VALIDATE("Data Exch. Def Code",DataExchDefCode);
      DataExchLineDef.SETRANGE("Data Exch. Def Code",DataExchDefCode);
      IF DataExchLineDef.FINDFIRST THEN
        VALIDATE("Data Exch. Line Def Code",DataExchLineDef.Code);
      INSERT;
    END;

    [External]
    PROCEDURE ImportFileContent@5(DataExchDef@1000 : Record 1222) : Boolean;
    VAR
      DataExchLineDef@1001 : Record 1227;
      RelatedRecord@1003 : RecordID;
    BEGIN
      RelatedRecord := "Related Record";
      DataExchLineDef.SETRANGE("Data Exch. Def Code",DataExchDef.Code);
      IF DataExchLineDef.FINDFIRST THEN;

      INIT;
      "Data Exch. Def Code" := DataExchDef.Code;
      "Data Exch. Line Def Code" := DataExchLineDef.Code;
      "Related Record" := RelatedRecord;

      DataExchDef.TESTFIELD("Ext. Data Handling Codeunit");
      CODEUNIT.RUN(DataExchDef."Ext. Data Handling Codeunit",Rec);

      IF NOT "File Content".HASVALUE THEN
        EXIT(FALSE);

      INSERT;
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE ImportToDataExch@2(DataExchDef@1000 : Record 1222) : Boolean;
    VAR
      Source@1001 : InStream;
      ProgressWindow@1002 : Dialog;
    BEGIN
      IF NOT "File Content".HASVALUE THEN
        IF NOT ImportFileContent(DataExchDef) THEN
          EXIT(FALSE);

      ProgressWindow.OPEN(ProgressWindowMsg);

      "File Content".CREATEINSTREAM(Source);
      SETRANGE("Entry No.","Entry No.");
      IF DataExchDef."Reading/Writing Codeunit" > 0 THEN
        CODEUNIT.RUN(DataExchDef."Reading/Writing Codeunit",Rec)
      ELSE BEGIN
        DataExchDef.TESTFIELD("Reading/Writing XMLport");
        XMLPORT.IMPORT(DataExchDef."Reading/Writing XMLport",Source,Rec);
      END;

      ProgressWindow.CLOSE;

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE ExportFromDataExch@3(DataExchMapping@1000 : Record 1224);
    VAR
      DataExchDef@1001 : Record 1222;
    BEGIN
      DataExchMapping.TESTFIELD("Mapping Codeunit");

      DataExchDef.GET("Data Exch. Def Code");
      DataExchDef.TESTFIELD("Reading/Writing Codeunit");
      DataExchDef.TESTFIELD("Ext. Data Handling Codeunit");

      IF DataExchMapping."Pre-Mapping Codeunit" > 0 THEN
        CODEUNIT.RUN(DataExchMapping."Pre-Mapping Codeunit",Rec);

      CODEUNIT.RUN(DataExchMapping."Mapping Codeunit",Rec);

      IF DataExchMapping."Post-Mapping Codeunit" > 0 THEN
        CODEUNIT.RUN(DataExchMapping."Post-Mapping Codeunit",Rec);

      CODEUNIT.RUN(DataExchDef."Reading/Writing Codeunit",Rec);

      CODEUNIT.RUN(DataExchDef."Ext. Data Handling Codeunit",Rec);

      IF DataExchDef."User Feedback Codeunit" > 0 THEN
        CODEUNIT.RUN(DataExchDef."User Feedback Codeunit",Rec);
    END;

    [External]
    PROCEDURE GetFileExtension@8() : Text;
    VAR
      DataExchDef@1000 : Record 1222;
    BEGIN
      DataExchDef.GET("Data Exch. Def Code");
      CASE DataExchDef."File Type" OF
        DataExchDef."File Type"::Xml:
          EXIT(XmlExtTok);
        DataExchDef."File Type"::Json:
          EXIT(JsonExtTok);
        ELSE
          EXIT(TxtExtTok);
      END;
    END;

    BEGIN
    END.
  }
}

