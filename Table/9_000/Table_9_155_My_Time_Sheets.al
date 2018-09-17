OBJECT Table 9155 My Time Sheets
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Mine timesedler;
               ENU=My Time Sheets];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Time Sheet No.      ;Code20        ;CaptionML=[DAN=Timeseddelnr.;
                                                              ENU=Time Sheet No.];
                                                   Description=Specifies the number of the time sheet. }
    { 3   ;   ;Start Date          ;Date          ;CaptionML=[DAN=Startdato;
                                                              ENU=Start Date];
                                                   Description=Specifies the start date of the assignment. }
    { 4   ;   ;End Date            ;Date          ;CaptionML=[DAN=Slutdato;
                                                              ENU=End Date];
                                                   Description=Specifies the end date of the assignment. }
    { 5   ;   ;Comment             ;Boolean       ;CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Description=Specifies if any comments are available about the assignment. }
  }
  KEYS
  {
    {    ;User ID,Time Sheet No.                  ;Clustered=Yes }
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

