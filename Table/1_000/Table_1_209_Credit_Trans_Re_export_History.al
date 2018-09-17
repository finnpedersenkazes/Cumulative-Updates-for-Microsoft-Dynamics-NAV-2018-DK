OBJECT Table 1209 Credit Trans Re-export History
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
               "Re-export Date" := CURRENTDATETIME;
               "Re-exported By" := USERID;
             END;

    CaptionML=[DAN=Historik for reeksport af kreditoverf›rsel;
               ENU=Credit Trans Re-export History];
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Credit Transfer Register No.;Integer;
                                                   TableRelation="Credit Transfer Register";
                                                   CaptionML=[DAN=Kreditoverf›rselsjournalnr.;
                                                              ENU=Credit Transfer Register No.] }
    { 3   ;   ;Re-export Date      ;DateTime      ;CaptionML=[DAN=Reeksportdato;
                                                              ENU=Re-export Date] }
    { 4   ;   ;Re-exported By      ;Code50        ;DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Reeksporteret af;
                                                              ENU=Re-exported By] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
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

