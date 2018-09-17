OBJECT Table 373 Dimension Entry Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Dimensionsbogf›ringsbuffer;
               ENU=Dimension Entry Buffer];
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Dimension Entry No. ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsl›benr.;
                                                              ENU=Dimension Entry No.] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Dimension Entry No.                      }
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

