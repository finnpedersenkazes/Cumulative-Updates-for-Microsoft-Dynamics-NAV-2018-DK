OBJECT Table 6302 Power BI Report Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Power BI-rapportbuffer;
               ENU=Power BI Report Buffer];
  }
  FIELDS
  {
    { 1   ;   ;ReportID            ;GUID          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=ReportID;
                                                              ENU=ReportID] }
    { 2   ;   ;ReportName          ;Text100       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=ReportName;
                                                              ENU=ReportName] }
    { 3   ;   ;EmbedUrl            ;Text250       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=EmbedUrl;
                                                              ENU=EmbedUrl] }
    { 4   ;   ;Enabled             ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Aktiveret;
                                                              ENU=Enabled] }
  }
  KEYS
  {
    {    ;ReportID                                ;Clustered=Yes }
    {    ;ReportName                               }
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

