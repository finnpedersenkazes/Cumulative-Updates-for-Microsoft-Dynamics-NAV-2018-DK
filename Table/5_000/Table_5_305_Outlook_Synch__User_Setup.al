OBJECT Table 5305 Outlook Synch. User Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF ISNULLGUID("Record GUID") THEN
                 "Record GUID" := CREATEGUID;
             END;

    OnDelete=BEGIN
               IF NOT CheckSetupDetail(Rec) THEN
                 ERROR('');

               OSynchSetupDetail.RESET;
               OSynchSetupDetail.SETRANGE("User ID","User ID");
               OSynchSetupDetail.SETRANGE("Synch. Entity Code","Synch. Entity Code");
               OSynchSetupDetail.DELETEALL;

               OSynchFilter.RESET;
               OSynchFilter.SETRANGE("Record GUID","Record GUID");
               OSynchFilter.DELETEALL;
             END;

    OnRename=BEGIN
               IF NOT CheckSetupDetail(xRec) THEN
                 ERROR('');

               IF xRec."Synch. Entity Code" = "Synch. Entity Code" THEN
                 EXIT;

               Condition := '';
               "Synch. Direction" := "Synch. Direction"::Bidirectional;
               "Last Synch. Time" := 0DT;

               OSynchSetupDetail.RESET;
               OSynchSetupDetail.SETRANGE("User ID","User ID");
               OSynchSetupDetail.SETRANGE("Synch. Entity Code",xRec."Synch. Entity Code");
               OSynchSetupDetail.DELETEALL;

               OSynchFilter.RESET;
               OSynchFilter.SETRANGE("Record GUID","Record GUID");
               OSynchFilter.DELETEALL;
             END;

    CaptionML=[DAN=Brugerkonfiguration af Outlook-synkronisering;
               ENU=Outlook Synch. User Setup];
    PasteIsValid=No;
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnValidate=BEGIN
                                                                UserMgt.ValidateUserID("User ID");
                                                              END;

                                                   OnLookup=BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   NotBlank=Yes }
    { 2   ;   ;Synch. Entity Code  ;Code10        ;TableRelation="Outlook Synch. Entity".Code;
                                                   OnValidate=BEGIN
                                                                IF "Synch. Entity Code" = xRec."Synch. Entity Code" THEN
                                                                  EXIT;

                                                                OSynchEntity.GET("Synch. Entity Code");
                                                                OSynchEntity.TESTFIELD(Description);
                                                                OSynchEntity.TESTFIELD("Table No.");
                                                                OSynchEntity.TESTFIELD("Outlook Item");

                                                                CALCFIELDS(Description,"No. of Elements");
                                                              END;

                                                   CaptionML=[DAN=Synkroniseringsenhedskode;
                                                              ENU=Synch. Entity Code];
                                                   NotBlank=Yes }
    { 3   ;   ;Description         ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Outlook Synch. Entity".Description WHERE (Code=FIELD(Synch. Entity Code)));
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 4   ;   ;Condition           ;Text250       ;CaptionML=[DAN=Betingelse;
                                                              ENU=Condition];
                                                   Editable=No }
    { 5   ;   ;Synch. Direction    ;Option        ;OnValidate=VAR
                                                                OSynchDependency@1000 : Record 5311;
                                                                RecRef@1002 : RecordRef;
                                                                FldRef@1001 : FieldRef;
                                                              BEGIN
                                                                IF "Synch. Direction" = xRec."Synch. Direction" THEN
                                                                  EXIT;

                                                                IF "Synch. Direction" = "Synch. Direction"::Bidirectional THEN
                                                                  EXIT;

                                                                CALCFIELDS("No. of Elements");
                                                                IF "No. of Elements" <> 0 THEN BEGIN
                                                                  OSynchSetupDetail.RESET;
                                                                  OSynchSetupDetail.SETRANGE("User ID","User ID");
                                                                  OSynchSetupDetail.SETRANGE("Synch. Entity Code","Synch. Entity Code");
                                                                  IF OSynchSetupDetail.FIND('-') THEN
                                                                    REPEAT
                                                                      OSynchEntityElement.GET(OSynchSetupDetail."Synch. Entity Code",OSynchSetupDetail."Element No.");
                                                                      MODIFY;
                                                                      OSynchEntityElement.CALCFIELDS("No. of Dependencies");
                                                                      IF OSynchEntityElement."No. of Dependencies" > 0 THEN
                                                                        IF NOT OSynchSetupMgt.CheckOCollectionAvailability(OSynchEntityElement,"User ID") THEN
                                                                          "Synch. Direction" := xRec."Synch. Direction";
                                                                    UNTIL OSynchSetupDetail.NEXT = 0;
                                                                END;

                                                                OSynchDependency.RESET;
                                                                OSynchDependency.SETRANGE("Depend. Synch. Entity Code","Synch. Entity Code");
                                                                IF OSynchDependency.FIND('-') THEN
                                                                  REPEAT
                                                                    IF OSynchUserSetup.GET("User ID",OSynchDependency."Synch. Entity Code") THEN
                                                                      IF OSynchSetupDetail.GET(
                                                                           OSynchUserSetup."User ID",
                                                                           OSynchUserSetup."Synch. Entity Code",
                                                                           OSynchDependency."Element No.")
                                                                      THEN
                                                                        IF "Synch. Direction" <> OSynchUserSetup."Synch. Direction" THEN BEGIN
                                                                          CLEAR(RecRef);
                                                                          CLEAR(FldRef);
                                                                          RecRef.GETTABLE(Rec);
                                                                          FldRef := RecRef.FIELD(FIELDNO("Synch. Direction"));
                                                                          ERROR(
                                                                            Text001,
                                                                            FIELDCAPTION("Synch. Direction"),
                                                                            SELECTSTR(OSynchUserSetup."Synch. Direction"::Bidirectional + 1,FldRef.OPTIONSTRING),
                                                                            OSynchDependency."Synch. Entity Code");
                                                                        END;
                                                                  UNTIL OSynchDependency.NEXT = 0;
                                                              END;

                                                   CaptionML=[DAN=Synkroniseringsretning;
                                                              ENU=Synch. Direction];
                                                   OptionCaptionML=[DAN=Begge retninger,Microsoft Dynamics NAV til Outlook,Outlook til Microsoft Dynamics NAV;
                                                                    ENU=Bidirectional,Microsoft Dynamics NAV to Outlook,Outlook to Microsoft Dynamics NAV];
                                                   OptionString=Bidirectional,Microsoft Dynamics NAV to Outlook,Outlook to Microsoft Dynamics NAV }
    { 6   ;   ;Last Synch. Time    ;DateTime      ;CaptionML=[DAN=Tidspunkt for sidste synkronisering;
                                                              ENU=Last Synch. Time] }
    { 7   ;   ;Record GUID         ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-GUID;
                                                              ENU=Record GUID];
                                                   Editable=No }
    { 8   ;   ;No. of Elements     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Outlook Synch. Setup Detail" WHERE (User ID=FIELD(User ID),
                                                                                                          Synch. Entity Code=FIELD(Synch. Entity Code),
                                                                                                          Outlook Collection=FILTER(<>'')));
                                                   CaptionML=[DAN=Antal elementer;
                                                              ENU=No. of Elements];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;User ID,Synch. Entity Code              ;Clustered=Yes }
    {    ;Record GUID                              }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      OSynchEntity@1004 : Record 5300;
      OSynchEntityElement@1002 : Record 5301;
      OSynchFilter@1000 : Record 5303;
      OSynchUserSetup@1005 : Record 5305;
      OSynchSetupDetail@1003 : Record 5310;
      UserMgt@1001 : Codeunit 418;
      OSynchSetupMgt@1008 : Codeunit 5300;
      Text001@1007 : TextConst 'DAN=V�rdien i feltet %1 skal enten v�re %2 eller svare til synkroniseringsretningen i enheden %3, fordi disse enheder er afh�ngige af hinanden.;ENU=The value of the %1 field must either be %2 or match the synchronization direction of the %3 entity because these entities are dependent.';
      Text002@1009 : TextConst 'DAN=Enheden %1 anvendes til synkronisering af en eller flere Outlook-elementsamlinger.\Hvis du sletter denne enhed, fjernes alle samlinger fra synkroniseringen. Vil du forts�tte?;ENU=The %1 entity is used for the synchronization of one or more Outlook item collections.\If you delete this entity, all collections will be removed from synchronization. Do you want to proceed?';

    [External]
    PROCEDURE CheckSetupDetail@2(OSynchUserSetup1@1002 : Record 5305) : Boolean;
    VAR
      OSynchDependency@1003 : Record 5311;
    BEGIN
      OSynchSetupDetail.RESET;
      OSynchSetupDetail.SETRANGE("User ID",OSynchUserSetup1."User ID");
      IF OSynchSetupDetail.FIND('-') THEN
        REPEAT
          IF OSynchDependency.GET(
               OSynchSetupDetail."Synch. Entity Code",
               OSynchSetupDetail."Element No.",
               OSynchUserSetup1."Synch. Entity Code")
          THEN
            OSynchSetupDetail.MARK(TRUE);
        UNTIL OSynchSetupDetail.NEXT = 0;

      OSynchSetupDetail.MARKEDONLY(TRUE);
      IF OSynchSetupDetail.COUNT > 0 THEN BEGIN
        IF CONFIRM(Text002,FALSE,OSynchUserSetup1."Synch. Entity Code") THEN BEGIN
          OSynchSetupDetail.DELETEALL;
          EXIT(TRUE);
        END;
        EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

