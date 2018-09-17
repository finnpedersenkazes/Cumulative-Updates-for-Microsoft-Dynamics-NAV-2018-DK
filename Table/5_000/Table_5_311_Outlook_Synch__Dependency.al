OBJECT Table 5311 Outlook Synch. Dependency
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Synch. Entity Code;
    OnInsert=BEGIN
               CheckUserSetup;

               IF ISNULLGUID("Record GUID") THEN
                 "Record GUID" := CREATEGUID;

               TESTFIELD("Table Relation");
             END;

    OnDelete=BEGIN
               CheckUserSetup;

               OSynchFilter.RESET;
               OSynchFilter.SETRANGE("Record GUID","Record GUID");
               OSynchFilter.DELETEALL;
             END;

    OnRename=BEGIN
               CheckUserSetup;

               OSynchFilter.RESET;
               OSynchFilter.SETRANGE("Record GUID","Record GUID");
               OSynchFilter.DELETEALL;
               Condition := '';
               "Table Relation" := '';
             END;

    CaptionML=[DAN=Afh‘ngighed for Outlook-synkronisering;
               ENU=Outlook Synch. Dependency];
    PasteIsValid=No;
    LookupPageID=Page5311;
    DrillDownPageID=Page5311;
  }
  FIELDS
  {
    { 1   ;   ;Synch. Entity Code  ;Code10        ;TableRelation="Outlook Synch. Entity Element"."Synch. Entity Code";
                                                   OnValidate=BEGIN
                                                                TESTFIELD("Element No.");
                                                              END;

                                                   CaptionML=[DAN=Synkroniseringsenhedskode;
                                                              ENU=Synch. Entity Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Element No.         ;Integer       ;CaptionML=[DAN=Elementnr.;
                                                              ENU=Element No.] }
    { 3   ;   ;Depend. Synch. Entity Code;Code10  ;TableRelation="Outlook Synch. Entity".Code;
                                                   OnValidate=BEGIN
                                                                IF "Synch. Entity Code" = "Depend. Synch. Entity Code" THEN
                                                                  ERROR(Text001,"Synch. Entity Code");

                                                                LoopCheck("Depend. Synch. Entity Code","Synch. Entity Code");

                                                                CALCFIELDS(Description);
                                                              END;

                                                   CaptionML=[DAN=Enhedskode til afh‘ngighedsforhold for synkronisering;
                                                              ENU=Depend. Synch. Entity Code] }
    { 4   ;   ;Description         ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Outlook Synch. Entity".Description WHERE (Code=FIELD(Depend. Synch. Entity Code)));
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 5   ;   ;Condition           ;Text250       ;CaptionML=[DAN=Betingelse;
                                                              ENU=Condition];
                                                   Editable=No }
    { 6   ;   ;Table Relation      ;Text250       ;OnValidate=BEGIN
                                                                TESTFIELD("Table Relation");
                                                              END;

                                                   CaptionML=[DAN=Tabelrelation;
                                                              ENU=Table Relation];
                                                   Editable=No }
    { 7   ;   ;Record GUID         ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-GUID;
                                                              ENU=Record GUID];
                                                   Editable=No }
    { 8   ;   ;Depend. Synch. Entity Tab. No.;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Lookup("Outlook Synch. Entity"."Table No." WHERE (Code=FIELD(Depend. Synch. Entity Code)));
                                                   CaptionML=[DAN=Enhedstabelnr. til afh‘ngighedsforhold for synkronisering;
                                                              ENU=Depend. Synch. Entity Tab. No.];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Synch. Entity Code,Element No.,Depend. Synch. Entity Code;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text001@1000 : TextConst 'DAN=Den markerede enhed m† ikke v‘re identisk med enheden %1.;ENU=The selected entity cannot be the same as the %1 entity.';
      Text002@1001 : TextConst 'DAN=Denne enhed kan ikke tilf›jes, fordi den allerede er konfigureret som afh‘ngig enhed for en eller flere af sine egne afh‘ngigheder.;ENU=You cannot add this entity because it is already setup as a dependency for one or more of its own dependencies.';
      OSynchFilter@1002 : Record 5303;
      Text003@1003 : TextConst 'DAN=Denne afh‘ngighed kan ikke ‘ndres for samlingen %1 i enheden %2, fordi den er konfigureret til synkronisering.;ENU=You cannot change this dependency for the %1 collection of the %2 entity because it is set up for synchronization.';

    [External]
    PROCEDURE LoopCheck@21(DependSynchEntityCode@1003 : Code[10];SynchEntityCode@1000 : Code[10]);
    VAR
      OSynchDependency@1002 : Record 5311;
    BEGIN
      OSynchDependency.RESET;
      OSynchDependency.SETRANGE("Synch. Entity Code",DependSynchEntityCode);
      OSynchDependency.SETRANGE("Depend. Synch. Entity Code",SynchEntityCode);
      IF OSynchDependency.FIND('-') THEN
        ERROR(Text002);

      OSynchDependency.SETRANGE("Depend. Synch. Entity Code");
      IF OSynchDependency.FIND('-') THEN
        REPEAT
          IF OSynchDependency."Depend. Synch. Entity Code" = "Synch. Entity Code" THEN
            ERROR(Text002);

          LoopCheck(OSynchDependency."Depend. Synch. Entity Code",OSynchDependency."Synch. Entity Code");
        UNTIL OSynchDependency.NEXT = 0;
    END;

    [External]
    PROCEDURE CheckUserSetup@1();
    VAR
      OSynchEntityElement@1002 : Record 5301;
      OSynchUserSetup@1000 : Record 5305;
      OSynchSetupDetail@1001 : Record 5310;
    BEGIN
      OSynchUserSetup.RESET;
      OSynchUserSetup.SETRANGE("Synch. Entity Code","Synch. Entity Code");
      IF NOT OSynchUserSetup.FIND('-') THEN
        EXIT;

      REPEAT
        OSynchUserSetup.CALCFIELDS("No. of Elements");
        IF OSynchUserSetup."No. of Elements" > 0 THEN
          IF OSynchSetupDetail.GET(OSynchUserSetup."User ID","Synch. Entity Code","Element No.") THEN BEGIN
            OSynchEntityElement.GET("Synch. Entity Code","Element No.");
            ERROR(
              Text003,
              OSynchEntityElement."Outlook Collection",
              OSynchEntityElement."Synch. Entity Code");
          END;
      UNTIL OSynchUserSetup.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

