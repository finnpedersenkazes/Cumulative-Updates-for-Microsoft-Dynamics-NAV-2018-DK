OBJECT Table 1526 Workflow Record Change Archive
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Workflow ’ndring af record Arkiv;
               ENU=Workflow Record Change Archive];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L›benummer;
                                                              ENU=Entry No.] }
    { 2   ;   ;Table No.           ;Integer       ;CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.] }
    { 3   ;   ;Field No.           ;Integer       ;CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 4   ;   ;Old Value           ;Text250       ;CaptionML=[DAN=Gammel v‘rdi;
                                                              ENU=Old Value] }
    { 5   ;   ;New Value           ;Text250       ;CaptionML=[DAN=Ny v‘rdi;
                                                              ENU=New Value] }
    { 6   ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 7   ;   ;Workflow Step Instance ID;GUID     ;CaptionML=[DAN=Id for workflowtrininstans;
                                                              ENU=Workflow Step Instance ID] }
    { 9   ;   ;Inactive            ;Boolean       ;CaptionML=[DAN=Inaktiv;
                                                              ENU=Inactive] }
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

    BEGIN
    END.
  }
}

