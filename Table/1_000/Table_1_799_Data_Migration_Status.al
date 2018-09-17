OBJECT Table 1799 Data Migration Status
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    OnModify=BEGIN
               IF ("Total Number" <> 0) AND ("Migrated Number" <= "Total Number") THEN
                 "Progress Percent" := "Migrated Number" / "Total Number" * 10000; // 10000 = 100%
             END;

    CaptionML=[DAN=Status for dataoverf›rsel;
               ENU=Data Migration Status];
  }
  FIELDS
  {
    { 1   ;   ;Migration Type      ;Text250       ;CaptionML=[DAN=Overf›rselstype;
                                                              ENU=Migration Type] }
    { 2   ;   ;Destination Table ID;Integer       ;CaptionML=[DAN=Destinationstabel-id;
                                                              ENU=Destination Table ID] }
    { 3   ;   ;Total Number        ;Integer       ;CaptionML=[DAN=Samlet antal;
                                                              ENU=Total Number] }
    { 4   ;   ;Migrated Number     ;Integer       ;CaptionML=[DAN=Overf›rt antal;
                                                              ENU=Migrated Number] }
    { 5   ;   ;Progress Percent    ;Decimal       ;ExtendedDatatype=Ratio;
                                                   CaptionML=[DAN=Status i procent;
                                                              ENU=Progress Percent] }
    { 6   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Ventende,Igangv‘rende,Fuldf›rt,Fuldf›rt med fejl,Stoppet,Mislykkedes;
                                                                    ENU=Pending,In Progress,Completed,Completed with Errors,Stopped,Failed];
                                                   OptionString=Pending,In Progress,Completed,Completed with Errors,Stopped,Failed }
    { 7   ;   ;Source Staging Table ID;Integer    ;CaptionML=[DAN=Kildens stadieinddelingstabel-id;
                                                              ENU=Source Staging Table ID] }
    { 8   ;   ;Migration Codeunit To Run;Integer  ;CaptionML=[DAN=Overf›rsels-codeunit, der skal k›res;
                                                              ENU=Migration Codeunit To Run] }
    { 9   ;   ;Error Count         ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Data Migration Error" WHERE (Migration Type=FIELD(Migration Type),
                                                                                                   Destination Table ID=FIELD(Destination Table ID)));
                                                   CaptionML=[DAN=Antal fejl;
                                                              ENU=Error Count] }
  }
  KEYS
  {
    {    ;Migration Type,Destination Table ID     ;Clustered=Yes }
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

