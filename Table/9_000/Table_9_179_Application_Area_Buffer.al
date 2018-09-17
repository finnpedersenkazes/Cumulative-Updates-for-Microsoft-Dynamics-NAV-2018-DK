OBJECT Table 9179 Application Area Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnModify=VAR
               ApplicationAreaSetup@1000 : Record 9178;
               TempApplicationAreaBuffer@1001 : TEMPORARY Record 9179;
             BEGIN
               CASE TRUE OF
                 (NOT Selected) AND ("Field No." = ApplicationAreaSetup.FIELDNO(Basic)):
                   MODIFYALL(Selected,FALSE);
                 Selected AND ("Field No." <> ApplicationAreaSetup.FIELDNO(Basic)):
                   BEGIN
                     TempApplicationAreaBuffer.COPY(Rec,TRUE);
                     TempApplicationAreaBuffer.GET(ApplicationAreaSetup.FIELDNO(Basic));
                     TempApplicationAreaBuffer.Selected := TRUE;
                     TempApplicationAreaBuffer.MODIFY;
                   END;
               END;
             END;

    CaptionML=[DAN=Buffer for funktionalitetsomr†de;
               ENU=Application Area Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Field No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 2   ;   ;Application Area    ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Funktionalitetsomr†de;
                                                              ENU=Application Area] }
    { 3   ;   ;Selected            ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valgt;
                                                              ENU=Selected] }
  }
  KEYS
  {
    {    ;Field No.                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

