OBJECT Table 749 Date Lookup Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Buffer for datoopslag;
               ENU=Date Lookup Buffer];
    LookupPageID=Page749;
  }
  FIELDS
  {
    { 1   ;   ;Period Type         ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodetype;
                                                              ENU=Period Type];
                                                   OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr;
                                                                    ENU=Day,Week,Month,Quarter,Year];
                                                   OptionString=Day,Week,Month,Quarter,Year }
    { 2   ;   ;Period Start        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodestart;
                                                              ENU=Period Start] }
    { 3   ;   ;Period End          ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodeslut;
                                                              ENU=Period End] }
    { 4   ;   ;Period No.          ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodenr.;
                                                              ENU=Period No.] }
    { 5   ;   ;Period Name         ;Text30        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Periodenavn;
                                                              ENU=Period Name] }
  }
  KEYS
  {
    {    ;Period Type,Period Start                ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Period Name                              }
  }
  CODE
  {

    BEGIN
    END.
  }
}

