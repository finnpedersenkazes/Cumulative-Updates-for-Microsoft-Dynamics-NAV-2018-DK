OBJECT Table 8401 Record Set Tree
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Records‘ttr‘;
               ENU=Record Set Tree];
  }
  FIELDS
  {
    { 1   ;   ;Table No.           ;Integer       ;CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.] }
    { 3   ;   ;Node ID             ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Node-id;
                                                              ENU=Node ID] }
    { 10  ;   ;Value               ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘rdi;
                                                              ENU=Value] }
    { 11  ;   ;Parent Node ID      ;Integer       ;CaptionML=[DAN=Id for overordnet node;
                                                              ENU=Parent Node ID] }
  }
  KEYS
  {
    {    ;Table No.,Node ID                       ;Clustered=Yes }
    {    ;Table No.,Parent Node ID,Value           }
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

