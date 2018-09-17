OBJECT Table 5942 Service Item Log
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Service Item No.;
    OnInsert=BEGIN
               ServItemLog.LOCKTABLE;
               ServItemLog.RESET;
               ServItemLog.SETRANGE("Service Item No.","Service Item No.");
               IF ServItemLog.FINDLAST THEN
                 "Entry No." := ServItemLog."Entry No." + 1
               ELSE
                 "Entry No." := 1;

               "Change Date" := TODAY;
               "Change Time" := TIME;
               "User ID" := USERID;
             END;

    CaptionML=[DAN=Serviceartikellog;
               ENU=Service Item Log];
    LookupPageID=Page5989;
    DrillDownPageID=Page5989;
  }
  FIELDS
  {
    { 1   ;   ;Service Item No.    ;Code20        ;TableRelation="Service Item";
                                                   CaptionML=[DAN=Serviceartikelnr.;
                                                              ENU=Service Item No.];
                                                   NotBlank=Yes }
    { 2   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 3   ;   ;Event No.           ;Integer       ;CaptionML=[DAN=H‘ndelsesnr.;
                                                              ENU=Event No.] }
    { 4   ;   ;Document No.        ;Code20        ;TableRelation=IF (Document Type=CONST(Quote)) "Service Header".No. WHERE (Document Type=CONST(Quote))
                                                                 ELSE IF (Document Type=CONST(Order)) "Service Header".No. WHERE (Document Type=CONST(Order))
                                                                 ELSE IF (Document Type=CONST(Contract)) "Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 5   ;   ;After               ;Text50        ;CaptionML=[DAN=Efter;
                                                              ENU=After] }
    { 6   ;   ;Before              ;Text50        ;CaptionML=[DAN=F›r;
                                                              ENU=Before] }
    { 7   ;   ;Change Date         ;Date          ;CaptionML=[DAN=’ndringsdato;
                                                              ENU=Change Date] }
    { 8   ;   ;Change Time         ;Time          ;CaptionML=[DAN=’ndringstidspunkt;
                                                              ENU=Change Time] }
    { 9   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 10  ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Tilbud,Ordre,Kontrakt";
                                                                    ENU=" ,Quote,Order,Contract"];
                                                   OptionString=[ ,Quote,Order,Contract] }
  }
  KEYS
  {
    {    ;Service Item No.,Entry No.              ;Clustered=Yes }
    {    ;Change Date                              }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ServItemLog@1000 : Record 5942;

    BEGIN
    END.
  }
}

