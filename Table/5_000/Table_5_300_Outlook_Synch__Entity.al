OBJECT Table 5300 Outlook Synch. Entity
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Code,Description;
    OnInsert=BEGIN
               IF ISNULLGUID("Record GUID") THEN
                 "Record GUID" := CREATEGUID;
             END;

    OnDelete=VAR
               OutlookSynchUserSetup@1000 : Record 5305;
             BEGIN
               OSynchDependency.RESET;
               OSynchDependency.SETRANGE("Depend. Synch. Entity Code",Code);
               IF NOT OSynchDependency.ISEMPTY THEN
                 IF NOT CONFIRM(Text004) THEN
                   ERROR('');

               OutlookSynchUserSetup.SETRANGE("Synch. Entity Code",Code);
               IF NOT OutlookSynchUserSetup.ISEMPTY THEN
                 ERROR(Text003,OutlookSynchUserSetup.TABLECAPTION);

               OSynchDependency.DELETEALL;
               OutlookSynchUserSetup.DELETEALL(TRUE);

               OSynchEntityElement.RESET;
               OSynchEntityElement.SETRANGE("Synch. Entity Code",Code);
               OSynchEntityElement.DELETEALL(TRUE);

               OSynchField.RESET;
               OSynchField.SETRANGE("Synch. Entity Code",Code);
               OSynchField.DELETEALL(TRUE);

               OSynchFilter.RESET;
               OSynchFilter.SETRANGE("Record GUID","Record GUID");
               OSynchFilter.DELETEALL;
             END;

    CaptionML=[DAN=Outlook-synkroniseringsenhed;
               ENU=Outlook Synch. Entity];
    PasteIsValid=No;
    LookupPageID=Page5302;
    DrillDownPageID=Page5302;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text80        ;OnValidate=VAR
                                                                OutlookSynchUserSetup@1000 : Record 5305;
                                                              BEGIN
                                                                IF Description <> '' THEN
                                                                  EXIT;

                                                                OutlookSynchUserSetup.SETRANGE("Synch. Entity Code",Code);
                                                                IF NOT OutlookSynchUserSetup.ISEMPTY THEN
                                                                  ERROR(Text005,FIELDCAPTION(Description),Code);
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Table No.           ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Table));
                                                   OnValidate=BEGIN
                                                                IF "Table No." = xRec."Table No." THEN
                                                                  EXIT;

                                                                CheckUserSetup;
                                                                TESTFIELD("Table No.");

                                                                IF NOT OSynchSetupMgt.CheckPKFieldsQuantity("Table No.") THEN
                                                                  EXIT;

                                                                IF xRec."Table No." <> 0 THEN BEGIN
                                                                  IF NOT
                                                                     CONFIRM(
                                                                       STRSUBSTNO(
                                                                         Text001,
                                                                         OSynchEntityElement.TABLECAPTION,
                                                                         OSynchField.TABLECAPTION,
                                                                         OSynchFilter.TABLECAPTION,
                                                                         OSynchDependency.TABLECAPTION))
                                                                  THEN BEGIN
                                                                    "Table No." := xRec."Table No.";
                                                                    EXIT;
                                                                  END;

                                                                  Condition := '';
                                                                  "Outlook Item" := '';

                                                                  OSynchDependency.RESET;
                                                                  OSynchDependency.SETRANGE("Depend. Synch. Entity Code",Code);
                                                                  OSynchDependency.DELETEALL(TRUE);

                                                                  OSynchEntityElement.RESET;
                                                                  OSynchEntityElement.SETRANGE("Synch. Entity Code",Code);
                                                                  OSynchEntityElement.DELETEALL(TRUE);

                                                                  OSynchField.RESET;
                                                                  OSynchField.SETRANGE("Synch. Entity Code",Code);
                                                                  OSynchField.DELETEALL(TRUE);

                                                                  OSynchFilter.RESET;
                                                                  OSynchFilter.SETRANGE("Record GUID","Record GUID");
                                                                  OSynchFilter.DELETEALL;
                                                                END;

                                                                CALCFIELDS("Table Caption");
                                                              END;

                                                   OnLookup=VAR
                                                              TableNo@1000 : Integer;
                                                            BEGIN
                                                              TableNo := OSynchSetupMgt.ShowTablesList;

                                                              IF TableNo <> 0 THEN
                                                                VALIDATE("Table No.",TableNo);
                                                            END;

                                                   CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.];
                                                   BlankZero=Yes }
    { 4   ;   ;Table Caption       ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Table),
                                                                                                                Object ID=FIELD(Table No.)));
                                                   CaptionML=[DAN=Tabeltitel;
                                                              ENU=Table Caption];
                                                   Editable=No }
    { 5   ;   ;Condition           ;Text250       ;OnValidate=VAR
                                                                RecordRef@1000 : RecordRef;
                                                              BEGIN
                                                                RecordRef.OPEN("Table No.");
                                                                RecordRef.SETVIEW(Condition);
                                                                Condition := RecordRef.GETVIEW(FALSE);
                                                              END;

                                                   CaptionML=[DAN=Betingelse;
                                                              ENU=Condition];
                                                   Editable=No }
    { 6   ;   ;Outlook Item        ;Text80        ;OnValidate=BEGIN
                                                                TESTFIELD("Outlook Item");
                                                                IF NOT OSynchSetupMgt.ValidateOutlookItemName("Outlook Item") THEN
                                                                  ERROR(Text002);

                                                                IF "Outlook Item" = xRec."Outlook Item" THEN
                                                                  EXIT;

                                                                CheckUserSetup;

                                                                IF xRec."Outlook Item" = '' THEN
                                                                  EXIT;

                                                                IF NOT
                                                                   CONFIRM(
                                                                     STRSUBSTNO(
                                                                       Text001,
                                                                       OSynchEntityElement.TABLECAPTION,
                                                                       OSynchField.TABLECAPTION,
                                                                       OSynchFilter.TABLECAPTION,
                                                                       OSynchDependency.TABLECAPTION))
                                                                THEN BEGIN
                                                                  "Outlook Item" := xRec."Outlook Item";
                                                                  EXIT;
                                                                END;

                                                                OSynchDependency.RESET;
                                                                OSynchDependency.SETRANGE("Depend. Synch. Entity Code",Code);
                                                                OSynchDependency.DELETEALL(TRUE);

                                                                OSynchEntityElement.RESET;
                                                                OSynchEntityElement.SETRANGE("Synch. Entity Code",Code);
                                                                OSynchEntityElement.DELETEALL(TRUE);

                                                                OSynchField.RESET;
                                                                OSynchField.SETRANGE("Synch. Entity Code",Code);
                                                                OSynchField.DELETEALL(TRUE);
                                                              END;

                                                   OnLookup=VAR
                                                              ItemName@1000 : Text[50];
                                                            BEGIN
                                                              ItemName := OSynchSetupMgt.ShowOItemsList;

                                                              IF ItemName <> '' THEN
                                                                VALIDATE("Outlook Item",ItemName);
                                                            END;

                                                   CaptionML=[DAN=Outlook-element;
                                                              ENU=Outlook Item] }
    { 7   ;   ;Record GUID         ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-GUID;
                                                              ENU=Record GUID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
    {    ;Record GUID                              }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      OSynchEntityElement@1003 : Record 5301;
      OSynchFilter@1002 : Record 5303;
      OSynchField@1001 : Record 5304;
      OSynchDependency@1010 : Record 5311;
      OSynchSetupMgt@1000 : Codeunit 5300;
      Text001@1005 : TextConst 'DAN=Hvis du �ndrer v�rdien i dette felt, slettes recorderne %1, %2, %3 og %4, som er relateret til dette element.\Vil du �ndre det alligevel?;ENU=If you change the value in this field, the %1, %2, %3 and %4 records related to this entity will be deleted.\Do you want to change it anyway?';
      Text002@1004 : TextConst 'DAN=Der findes ikke et Outlook-element med dette navn.\Klik p� AssistButton for at f� vist en liste over gyldige Outlook-elementer.;ENU=The Outlook item with this name does not exist.\Click the AssistButton to see a list of valid Outlook items';
      Text003@1009 : TextConst 'DAN=Denne enhed kan ikke slettes, fordi den er konfigureret til synkronisering. Bekr�ft %1.;ENU=You cannot delete this entity because it is set up for synchronization. Please verify %1.';
      Text004@1006 : TextConst 'DAN=Der findes poster, der er afh�ngige af denne enhed. Hvis du sletter den, fjernes relationen til de poster, der er afh�ngige af den.\Vil du slette den alligevel?;ENU=There are entities which depend on this entity. If you delete it, the relation to its dependencies will be removed.\Do you want to delete it anyway?';
      Text005@1011 : TextConst 'DAN=Feltet %1 m� ikke v�re tomt, fordi enheden %2 bruges med synkronisering.;ENU=The %1 field cannot be blank because the %2 entity is used with synchronization.';
      Text006@1012 : TextConst 'DAN=Denne enhed kan ikke �ndres, fordi den bruges med synkronisering for brugeren %1.;ENU=You cannot change this entity because it is used with synchronization for the user %1.';

    [External]
    PROCEDURE ShowEntityFields@1();
    BEGIN
      TESTFIELD("Outlook Item");
      IF "Table No." = 0 THEN
        FIELDERROR("Table No.");

      OSynchField.RESET;
      OSynchField.SETRANGE("Synch. Entity Code",Code);
      OSynchField.SETRANGE("Element No.",0);

      PAGE.RUNMODAL(PAGE::"Outlook Synch. Fields",OSynchField);
    END;

    LOCAL PROCEDURE CheckUserSetup@4();
    VAR
      OSynchUserSetup@1000 : Record 5305;
    BEGIN
      OSynchUserSetup.RESET;
      OSynchUserSetup.SETRANGE("Synch. Entity Code",Code);
      IF OSynchUserSetup.FINDFIRST THEN
        ERROR(Text006,OSynchUserSetup."User ID");
    END;

    BEGIN
    END.
  }
}

