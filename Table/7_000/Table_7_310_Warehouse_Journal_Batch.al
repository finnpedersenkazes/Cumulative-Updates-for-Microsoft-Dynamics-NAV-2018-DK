OBJECT Table 7310 Warehouse Journal Batch
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Name,Description;
    OnInsert=BEGIN
               LOCKTABLE;
               WhseJnlTemplate.GET("Journal Template Name");
             END;

    OnDelete=BEGIN
               WhseJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
               WhseJnlLine.SETRANGE("Journal Batch Name",Name);
               WhseJnlLine.SETRANGE("Location Code","Location Code");
               WhseJnlLine.DELETEALL(TRUE);
             END;

    OnRename=BEGIN
               WhseJnlLine.SETRANGE("Journal Template Name",xRec."Journal Template Name");
               WhseJnlLine.SETRANGE("Journal Batch Name",xRec.Name);
               WhseJnlLine.SETRANGE("Location Code",xRec."Location Code");
               WHILE WhseJnlLine.FINDFIRST DO
                 WhseJnlLine.RENAME("Journal Template Name",Name,"Location Code",WhseJnlLine."Line No.");
             END;

    CaptionML=[DAN=Lagerkladdenavn (logistik);
               ENU=Warehouse Journal Batch];
    LookupPageID=Page7323;
  }
  FIELDS
  {
    { 1   ;   ;Journal Template Name;Code10       ;TableRelation="Warehouse Journal Template";
                                                   CaptionML=[DAN=Kladdetypenavn;
                                                              ENU=Journal Template Name];
                                                   NotBlank=Yes }
    { 2   ;   ;Name                ;Code10        ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   OnValidate=BEGIN
                                                                IF "Reason Code" <> xRec."Reason Code" THEN BEGIN
                                                                  WhseJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
                                                                  WhseJnlLine.SETRANGE("Journal Batch Name",Name);
                                                                  WhseJnlLine.SETRANGE("Location Code","Location Code");
                                                                  WhseJnlLine.MODIFYALL("Reason Code","Reason Code");
                                                                  MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 5   ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "No. Series" <> '' THEN
                                                                  IF "No. Series" = "Registering No. Series" THEN
                                                                    VALIDATE("Registering No. Series",'');
                                                              END;

                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 6   ;   ;Registering No. Series;Code20      ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF ("Registering No. Series" = "No. Series") AND ("Registering No. Series" <> '') THEN
                                                                  FIELDERROR("Registering No. Series",STRSUBSTNO(Text000,"Registering No. Series"));
                                                                WhseJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
                                                                WhseJnlLine.SETRANGE("Journal Batch Name",Name);
                                                                WhseJnlLine.SETRANGE("Location Code","Location Code");
                                                                WhseJnlLine.MODIFYALL("Registering No. Series","Registering No. Series");
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Registreringsnr.serie;
                                                              ENU=Registering No. Series] }
    { 7   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   OnValidate=VAR
                                                                Location@1000 : Record 14;
                                                              BEGIN
                                                                Location.GET("Location Code");
                                                                Location.TESTFIELD("Directed Put-away and Pick",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code];
                                                   NotBlank=Yes }
    { 21  ;   ;Template Type       ;Option        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Warehouse Journal Template".Type WHERE (Name=FIELD(Journal Template Name)));
                                                   CaptionML=[DAN=Skabelontype;
                                                              ENU=Template Type];
                                                   OptionCaptionML=[DAN=Vare,Lageropgõrelse,Ompostering;
                                                                    ENU=Item,Physical Inventory,Reclassification];
                                                   OptionString=Item,Physical Inventory,Reclassification;
                                                   Editable=No }
    { 7700;   ;Assigned User ID    ;Code50        ;TableRelation="Warehouse Employee" WHERE (Location Code=FIELD(Location Code));
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
  }
  KEYS
  {
    {    ;Journal Template Name,Name,Location Code;Clustered=Yes }
    {    ;Location Code,Assigned User ID           }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1001 : TextConst 'DAN=mÜ ikke vëre %1;ENU=must not be %1';
      WhseJnlTemplate@1002 : Record 7309;
      WhseJnlLine@1003 : Record 7311;

    [External]
    PROCEDURE SetupNewBatch@3();
    BEGIN
      WhseJnlTemplate.GET("Journal Template Name");
      "No. Series" := WhseJnlTemplate."No. Series";
      "Registering No. Series" := WhseJnlTemplate."Registering No. Series";
      "Reason Code" := WhseJnlTemplate."Reason Code";
    END;

    BEGIN
    END.
  }
}

