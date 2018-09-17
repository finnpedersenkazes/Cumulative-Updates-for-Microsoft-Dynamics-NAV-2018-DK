OBJECT Table 5912 Service Document Log
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
               ServOrderLog.RESET;
               ServOrderLog.SETRANGE("Document Type","Document Type");
               ServOrderLog.SETRANGE("Document No.","Document No.");
               IF ServOrderLog.FINDLAST THEN
                 "Entry No." := ServOrderLog."Entry No." + 1
               ELSE
                 "Entry No." := 1;

               "Change Date" := TODAY;
               "Change Time" := TIME;
               "User ID" := USERID;
             END;

    CaptionML=[DAN=Servicedokumentlog;
               ENU=Service Document Log];
    LookupPageID=Page5920;
    DrillDownPageID=Page5920;
  }
  FIELDS
  {
    { 1   ;   ;Document No.        ;Code20        ;TableRelation=IF (Document Type=CONST(Quote)) "Service Header".No. WHERE (Document Type=CONST(Quote))
                                                                 ELSE IF (Document Type=CONST(Order)) "Service Header".No. WHERE (Document Type=CONST(Order))
                                                                 ELSE IF (Document Type=CONST(Invoice)) "Service Header".No. WHERE (Document Type=CONST(Invoice))
                                                                 ELSE IF (Document Type=CONST(Credit Memo)) "Service Header".No. WHERE (Document Type=CONST(Credit Memo))
                                                                 ELSE IF (Document Type=CONST(Shipment)) "Service Shipment Header"
                                                                 ELSE IF (Document Type=CONST(Posted Invoice)) "Service Invoice Header"
                                                                 ELSE IF (Document Type=CONST(Posted Credit Memo)) "Service Cr.Memo Header";
                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 2   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 3   ;   ;Event No.           ;Integer       ;CaptionML=[DAN=H‘ndelsesnr.;
                                                              ENU=Event No.] }
    { 4   ;   ;Service Item Line No.;Integer      ;CaptionML=[DAN=Serviceartikellinjenr.;
                                                              ENU=Service Item Line No.] }
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
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota,Levering,Bogf›rt faktura,Bogf›rt kreditnota;
                                                                    ENU=Quote,Order,Invoice,Credit Memo,Shipment,Posted Invoice,Posted Credit Memo];
                                                   OptionString=Quote,Order,Invoice,Credit Memo,Shipment,Posted Invoice,Posted Credit Memo;
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Document Type,Document No.,Entry No.    ;Clustered=Yes }
    {    ;Change Date,Change Time                  }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ServOrderLog@1000 : Record 5912;

    [External]
    PROCEDURE CopyServLog@3(DocType@1000 : Option;DocNo@1001 : Code[20]);
    VAR
      ServDocLog@1002 : Record 5912;
    BEGIN
      ServDocLog.RESET;
      ServDocLog.SETRANGE("Document Type",DocType);
      ServDocLog.SETRANGE("Document No.",DocNo);
      IF ServDocLog.FINDSET THEN
        REPEAT
          Rec := ServDocLog;
          INSERT;
        UNTIL ServDocLog.NEXT = 0;
    END;

    LOCAL PROCEDURE FillTempServDocLog@1(VAR ServHeader@1000 : Record 5900;VAR TempServDocLog@1001 : TEMPORARY Record 5912);
    VAR
      ServDocLog@1002 : Record 5912;
    BEGIN
      WITH ServHeader DO BEGIN
        TempServDocLog.RESET;
        TempServDocLog.DELETEALL;

        IF "No." <> '' THEN BEGIN
          TempServDocLog.CopyServLog("Document Type","No.");
          TempServDocLog.CopyServLog(ServDocLog."Document Type"::Shipment,"No.");
          TempServDocLog.CopyServLog(ServDocLog."Document Type"::"Posted Invoice","No.");
          TempServDocLog.CopyServLog(ServDocLog."Document Type"::"Posted Credit Memo","No.");
        END;

        TempServDocLog.RESET;
        TempServDocLog.SETCURRENTKEY("Change Date","Change Time");
        TempServDocLog.ASCENDING(FALSE);
      END;
    END;

    [External]
    PROCEDURE ShowServDocLog@2(VAR ServHeader@1000 : Record 5900);
    VAR
      TempServDocLog@1001 : TEMPORARY Record 5912;
    BEGIN
      FillTempServDocLog(ServHeader,TempServDocLog);
      PAGE.RUN(0,TempServDocLog);
    END;

    BEGIN
    END.
  }
}

