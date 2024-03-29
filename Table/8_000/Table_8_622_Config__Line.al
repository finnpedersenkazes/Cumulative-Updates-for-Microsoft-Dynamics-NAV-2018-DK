OBJECT Table 8622 Config. Line
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    DataCaptionFields=Name;
    OnDelete=VAR
               ConfigRelatedTable@1000 : Record 8625;
             BEGIN
               IF CountWorksheetTableOccurrences("Table ID") = 1 THEN BEGIN
                 ConfigRelatedTable.SETRANGE("Table ID","Table ID");
                 ConfigRelatedTable.DELETEALL(TRUE);
               END;
             END;

    CaptionML=[DAN=Konfig.linje;
               ENU=Config. Line];
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 2   ;   ;Line Type           ;Option        ;OnValidate=BEGIN
                                                                IF "Line Type" <> "Line Type"::Table THEN
                                                                  TESTFIELD("Table ID",0);
                                                              END;

                                                   CaptionML=[DAN=Linjetype;
                                                              ENU=Line Type];
                                                   OptionCaptionML=[DAN=Omr�de,Gruppe,Tabel;
                                                                    ENU=Area,Group,Table];
                                                   OptionString=Area,Group,Table }
    { 3   ;   ;Table ID            ;Integer       ;TableRelation=IF (Line Type=CONST(Table)) Object.ID WHERE (Type=CONST(Table),
                                                                                                              ID=FILTER(..99000999|2000000004|2000000005));
                                                   OnValidate=VAR
                                                                RecRef@1000 : RecordRef;
                                                              BEGIN
                                                                IF CurrFieldNo > 0 THEN
                                                                  TESTFIELD("Line Type","Line Type"::Table);

                                                                IF ("Table ID" <> xRec."Table ID") AND (xRec."Table ID" > 0) THEN
                                                                  TESTFIELD("Dimensions as Columns",FALSE);

                                                                IF ("Table ID" <> xRec."Table ID") AND ("Package Code" <> '') THEN
                                                                  IF CONFIRM(Text003,FALSE) THEN
                                                                    "Package Code" := ''
                                                                  ELSE BEGIN
                                                                    "Table ID" := xRec."Table ID";
                                                                    EXIT;
                                                                  END;

                                                                IF "Table ID" > 0 THEN BEGIN
                                                                  RecRef.OPEN("Table ID");
                                                                  VALIDATE(Name,RecRef.CAPTION);
                                                                  "Page ID" := ConfigMgt.FindPage("Table ID");
                                                                  "Copying Available" := ConfigMgt.TransferContents("Table ID",'',FALSE);
                                                                  GetRelatedTables;
                                                                END ELSE
                                                                  IF xRec."Table ID" > 0 THEN
                                                                    ERROR(Text001);
                                                              END;

                                                   OnLookup=VAR
                                                              ConfigValidateMgt@1000 : Codeunit 8617;
                                                            BEGIN
                                                              TESTFIELD("Line Type","Line Type"::Table);
                                                              ConfigValidateMgt.LookupTable("Table ID");
                                                              VALIDATE("Table ID");
                                                            END;

                                                   CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 4   ;   ;Name                ;Text250       ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 5   ;   ;Company Filter      ;Text30        ;FieldClass=FlowFilter;
                                                   TableRelation=Company;
                                                   CaptionML=[DAN=Virksomhedsfilter;
                                                              ENU=Company Filter] }
    { 6   ;   ;Company Filter (Source Table);Text30;
                                                   FieldClass=FlowFilter;
                                                   TableRelation=Company;
                                                   CaptionML=[DAN=Virksomhedsfilter (kildetabel);
                                                              ENU=Company Filter (Source Table)] }
    { 8   ;   ;No. of Records      ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Table Information"."No. of Records" WHERE (Company Name=FIELD(Company Filter),
                                                                                                               Table No.=FIELD(Table ID)));
                                                   CaptionML=[DAN=Antal records;
                                                              ENU=No. of Records];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 9   ;   ;No. of Records (Source Table);Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Table Information"."No. of Records" WHERE (Company Name=FIELD("Company Filter (Source Table)"),
                                                                                                               Table No.=FIELD(Table ID)));
                                                   CaptionML=[DAN=Antal records (kildetabel);
                                                              ENU=No. of Records (Source Table)];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 10  ;   ;Licensed Table      ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("License Permission" WHERE (Object Type=CONST(TableData),
                                                                                                 Object Number=FIELD(Table ID),
                                                                                                 Read Permission=CONST(Yes),
                                                                                                 Insert Permission=CONST(Yes),
                                                                                                 Modify Permission=CONST(Yes),
                                                                                                 Delete Permission=CONST(Yes)));
                                                   CaptionML=[DAN=Tabel, der er givet i licens;
                                                              ENU=Licensed Table];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 11  ;   ;Promoted Table      ;Boolean       ;OnValidate=BEGIN
                                                                IF "Promoted Table" THEN
                                                                  TESTFIELD("Line Type","Line Type"::Table);
                                                              END;

                                                   CaptionML=[DAN=Forfremmet tabel;
                                                              ENU=Promoted Table] }
    { 12  ;   ;Dimensions as Columns;Boolean      ;OnValidate=VAR
                                                                ConfigPackageTable@1000 : Record 8613;
                                                              BEGIN
                                                                TESTFIELD("Line Type","Line Type"::Table);
                                                                TESTFIELD("Table ID");
                                                                TESTFIELD("Package Code");
                                                                ConfigPackageTable.GET("Package Code","Table ID");
                                                                ConfigPackageTable.SetHideValidationDialog(HideValidationDialog);
                                                                ConfigPackageTable.VALIDATE("Dimensions as Columns","Dimensions as Columns");
                                                                ConfigPackageTable.MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Dimensioner som kolonner;
                                                              ENU=Dimensions as Columns] }
    { 13  ;   ;Copying Available   ;Boolean       ;CaptionML=[DAN=Kopiering disponibel;
                                                              ENU=Copying Available];
                                                   Editable=No }
    { 14  ;   ;Page ID             ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Page));
                                                   OnLookup=VAR
                                                              ConfigValidateMgt@1000 : Codeunit 8617;
                                                            BEGIN
                                                              ConfigValidateMgt.LookupPage("Page ID");
                                                              VALIDATE("Page ID");
                                                            END;

                                                   CaptionML=[DAN=Side-id;
                                                              ENU=Page ID] }
    { 15  ;   ;Page Caption        ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Name" WHERE (Object Type=CONST(Page),
                                                                                                             Object ID=FIELD(Page ID)));
                                                   CaptionML=[DAN=Sideoverskrift;
                                                              ENU=Page Caption];
                                                   Editable=No }
    { 18  ;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                IF ("Starting Date" <> 0D) AND (xRec."Starting Date" <> 0D) AND ("Ending Date" <> 0D) THEN
                                                                  "Ending Date" := "Ending Date" + ("Starting Date" - xRec."Starting Date");
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 19  ;   ;Ending Date         ;Date          ;CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 20  ;   ;Responsible ID      ;Code50        ;TableRelation=User."User Name";
                                                   OnValidate=VAR
                                                                UserMgt@1000 : Codeunit 418;
                                                              BEGIN
                                                                UserMgt.ValidateUserID("Responsible ID");
                                                              END;

                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Responsible ID");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Ansvarlig bruger-id;
                                                              ENU=Responsible ID] }
    { 21  ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=" ,Igangv�rende,Afsluttet,Ignoreret,Sp�rret";
                                                                    ENU=" ,In Progress,Completed,Ignored,Blocked"];
                                                   OptionString=[ ,In Progress,Completed,Ignored,Blocked] }
    { 25  ;   ;Vertical Sorting    ;Integer       ;CaptionML=[DAN=Lodret sortering;
                                                              ENU=Vertical Sorting] }
    { 26  ;   ;Data Origin         ;Text50        ;CaptionML=[DAN=Dataoprindelse;
                                                              ENU=Data Origin] }
    { 28  ;   ;Reference           ;Text250       ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=Reference;
                                                              ENU=Reference] }
    { 30  ;   ;Licensed Page       ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("License Permission" WHERE (Object Type=CONST(Page),
                                                                                                 Object Number=FIELD(Page ID),
                                                                                                 Execute Permission=CONST(Yes)));
                                                   CaptionML=[DAN=Side, der er givet i licens;
                                                              ENU=Licensed Page];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 31  ;   ;No. of Question Groups;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Config. Question Area" WHERE (Table ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Antal sp�rgsm�lsgrupper;
                                                              ENU=No. of Question Groups];
                                                   Editable=No }
    { 32  ;   ;Parent Line No.     ;Integer       ;CaptionML=[DAN=Overordnet linjenr.;
                                                              ENU=Parent Line No.] }
    { 36  ;   ;Package Code        ;Code20        ;TableRelation="Config. Package";
                                                   CaptionML=[DAN=Pakkekode;
                                                              ENU=Package Code] }
    { 37  ;   ;Package Caption     ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Config. Package"."Package Name" WHERE (Code=FIELD(Package Code)));
                                                   CaptionML=[DAN=Overskrift - pakke;
                                                              ENU=Package Caption];
                                                   Editable=No }
    { 38  ;   ;Package Exists      ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Config. Package" WHERE (Code=FIELD(Package Code)));
                                                   CaptionML=[DAN=Pakke findes;
                                                              ENU=Package Exists];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Line No.                                ;Clustered=Yes }
    {    ;Line Type,Status,Promoted Table          }
    {    ;Table ID                                 }
    {    ;Vertical Sorting                         }
    {    ;Line Type,Parent Line No.                }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ConfigMgt@1001 : Codeunit 8616;
      ConfigPackageMgt@1008 : Codeunit 8611;
      Text001@1000 : TextConst 'DAN=Slet linjen i stedet.;ENU=Delete the line instead.';
      Text002@1002 : TextConst 'DAN=Statussen %1 underst�ttes ikke.;ENU=The status %1 is not supported.';
      Text003@1003 : TextConst 'DAN=Den tabel, du fors�ger at omd�be, er knyttet til en pakke. Vil du fjerne denne tilknytning?;ENU=The table you are trying to rename is linked to a package. Do you want to remove the link?';
      Text004@1004 : TextConst 'DAN=Du kan ikke behandle linjen for tabel %1 og pakkekode %2, da den er blokeret.;ENU=You cannot process line for table %1 and package code %2 because it is blocked.';
      HideValidationDialog@1005 : Boolean;
      NoDuplicateLinesMsg@1006 : TextConst 'DAN=Der findes ingen dubletlinjer.;ENU=There are no duplicate lines.';
      NoOfDuplicateLinesDeletedMsg@1007 : TextConst 'DAN=%1 linjer blev slettet.;ENU=%1 line(s) were deleted.';

    [External]
    PROCEDURE CheckBlocked@4();
    BEGIN
      IF Status = Status::Blocked THEN
        ERROR(Text004,"Table ID","Package Code");
    END;

    [External]
    PROCEDURE ShowTableData@3();
    BEGIN
      IF ("Line Type" = "Line Type"::Table) AND ("Page ID" <> 0) THEN
        PAGE.RUN("Page ID");
    END;

    [External]
    PROCEDURE ShowQuestions@10();
    VAR
      ConfigQuestionArea@1000 : Record 8611;
      ConfigQuestionAreaPage@1001 : Page 8611;
    BEGIN
      TESTFIELD("Line Type","Line Type"::Table);
      TESTFIELD("Table ID");

      ConfigQuestionArea.SETRANGE("Table ID","Table ID");
      ConfigQuestionArea.FINDFIRST;

      ConfigQuestionArea.RESET;
      ConfigQuestionArea.FILTERGROUP(2);
      ConfigQuestionArea.SETRANGE("Table ID","Table ID");
      ConfigQuestionArea.FILTERGROUP(0);
      ConfigQuestionAreaPage.SETTABLEVIEW(ConfigQuestionArea);
      ConfigQuestionAreaPage.RUNMODAL;
      CLEAR(ConfigQuestionAreaPage);
    END;

    [External]
    PROCEDURE GetProgress@1() : Integer;
    VAR
      Total@1001 : Integer;
      TotalStatusWeight@1005 : Decimal;
    BEGIN
      Total := GetNoTables;
      TotalStatusWeight := GetTotalStatusWeight;

      IF Total = 0 THEN
        EXIT(0);

      EXIT(ROUND(100 * TotalStatusWeight / Total,1));
    END;

    [External]
    PROCEDURE GetNoOfDirectChildrenTables@2() : Integer;
    VAR
      ConfigLine@1000 : Record 8622;
    BEGIN
      WITH ConfigLine DO BEGIN
        RESET;
        SETCURRENTKEY("Line Type");
        SETRANGE("Line Type","Line Type"::Table);
        SETRANGE("Parent Line No.",Rec."Line No.");
        EXIT(COUNT);
      END;
    END;

    [External]
    PROCEDURE GetDirectChildrenTablesStatusWeight@8() StatusWeight : Decimal;
    VAR
      ConfigLine@1000 : Record 8622;
    BEGIN
      WITH ConfigLine DO BEGIN
        RESET;
        SETCURRENTKEY("Line Type");
        SETRANGE("Line Type","Line Type"::Table);
        SETRANGE("Parent Line No.",Rec."Line No.");
        IF FINDSET THEN
          REPEAT
            StatusWeight += GetLineStatusWeight;
          UNTIL NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE GetNoTables@7() Total : Integer;
    VAR
      ConfigLine@1001 : Record 8622;
    BEGIN
      CASE "Line Type" OF
        "Line Type"::Table:
          Total := 0;
        "Line Type"::Group:
          Total := GetNoOfDirectChildrenTables;
        "Line Type"::Area:
          BEGIN
            Total := GetNoOfDirectChildrenTables;

            ConfigLine.SETRANGE("Line Type",ConfigLine."Line Type"::Group);
            ConfigLine.SETRANGE("Parent Line No.","Line No.");
            IF ConfigLine.FINDSET THEN
              REPEAT
                Total += ConfigLine.GetNoOfDirectChildrenTables;
              UNTIL ConfigLine.NEXT = 0;
          END;
      END;
    END;

    LOCAL PROCEDURE GetTotalStatusWeight@13() Total : Decimal;
    VAR
      ConfigLine@1001 : Record 8622;
    BEGIN
      CASE "Line Type" OF
        "Line Type"::Table:
          Total := 0;
        "Line Type"::Group:
          Total := GetDirectChildrenTablesStatusWeight;
        "Line Type"::Area:
          BEGIN
            Total := GetDirectChildrenTablesStatusWeight;

            ConfigLine.SETRANGE("Line Type",ConfigLine."Line Type"::Group);
            ConfigLine.SETRANGE("Parent Line No.","Line No.");
            IF ConfigLine.FINDSET THEN
              REPEAT
                Total += ConfigLine.GetDirectChildrenTablesStatusWeight;
              UNTIL ConfigLine.NEXT = 0;
          END;
      END;
    END;

    LOCAL PROCEDURE GetRelatedTables@5();
    VAR
      ConfigRelatedTable@1000 : Record 8625;
      ConfigRelatedField@1002 : Record 8624;
      Field@1001 : Record 2000000041;
    BEGIN
      ConfigPackageMgt.SetFieldFilter(Field,"Table ID",0);
      IF Field.FINDSET THEN
        REPEAT
          IF Field.RelationTableNo <> 0 THEN
            IF NOT ConfigRelatedField.GET("Table ID",Field."No.") THEN BEGIN
              ConfigRelatedField.INIT;
              ConfigRelatedField."Table ID" := "Table ID";
              ConfigRelatedField."Field ID" := Field."No.";
              ConfigRelatedField."Relation Table ID" := Field.RelationTableNo;
              ConfigRelatedField.INSERT;
            END;
        UNTIL Field.NEXT = 0;

      IF ConfigRelatedField.FINDSET THEN
        REPEAT
          IF NOT ConfigRelatedTable.GET(ConfigRelatedField."Table ID",ConfigRelatedField."Relation Table ID") THEN BEGIN
            ConfigRelatedTable."Table ID" := ConfigRelatedField."Table ID";
            ConfigRelatedTable."Relation Table ID" := ConfigRelatedField."Relation Table ID";
            ConfigRelatedTable.INSERT;
          END;
        UNTIL ConfigRelatedField.NEXT = 0;
    END;

    [External]
    PROCEDURE GetLineStatusWeight@6() : Decimal;
    BEGIN
      CASE Status OF
        Status::" ":
          EXIT(0);
        Status::Completed,Status::Ignored:
          EXIT(1);
        Status::"In Progress",Status::Blocked:
          EXIT(0.5);
        ELSE
          ERROR(Text002,Status);
      END;
    END;

    LOCAL PROCEDURE CountWorksheetTableOccurrences@9(TableID@1000 : Integer) : Integer;
    VAR
      ConfigLine@1001 : Record 8622;
    BEGIN
      ConfigLine.SETRANGE("Table ID",TableID);
      EXIT(ConfigLine.COUNT);
    END;

    [External]
    PROCEDURE SetHideValidationDialog@14(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    [Internal]
    PROCEDURE GetNoOfRecords@11() : Integer;
    BEGIN
      EXIT(GetNoOfDatabaseRecords("Table ID","Company Filter"));
    END;

    [Internal]
    PROCEDURE GetNoOfRecordsSourceTable@12() : Integer;
    BEGIN
      EXIT(GetNoOfDatabaseRecords("Table ID","Company Filter (Source Table)"));
    END;

    LOCAL PROCEDURE GetNoOfDatabaseRecords@15(TableID@1002 : Integer;Filter@1003 : Text) : Integer;
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      IF TableID = 0 THEN
        EXIT(0);

      RecRef.OPEN(TableID,FALSE,Filter);
      EXIT(RecRef.COUNT);
    END;

    [External]
    PROCEDURE DeleteDuplicateLines@16();
    VAR
      ConfigLine@1001 : Record 8622;
      TempConfigLine@1002 : TEMPORARY Record 8622;
      NoOfDuplicateLines@1003 : Integer;
    BEGIN
      IF FINDSET THEN
        REPEAT
          TempConfigLine.RESET;
          TempConfigLine.SETRANGE("Line Type","Line Type"::Table);
          TempConfigLine.SETRANGE("Table ID","Table ID");
          TempConfigLine.SETRANGE("Package Code","Package Code");
          IF NOT TempConfigLine.ISEMPTY THEN BEGIN
            ConfigLine.GET("Line No.");
            ConfigLine.DELETE(TRUE);
            NoOfDuplicateLines := NoOfDuplicateLines + 1;
          END ELSE BEGIN
            TempConfigLine.INIT;
            TempConfigLine := Rec;
            TempConfigLine.INSERT;
          END;
        UNTIL NEXT = 0;

      IF NoOfDuplicateLines = 0 THEN
        MESSAGE(NoDuplicateLinesMsg)
      ELSE
        MESSAGE(NoOfDuplicateLinesDeletedMsg,NoOfDuplicateLines);
    END;

    BEGIN
    END.
  }
}

