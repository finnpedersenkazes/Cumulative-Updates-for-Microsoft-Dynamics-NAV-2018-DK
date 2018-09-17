OBJECT Table 289 Payment Method
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232,NAVDK11.00.00.24232;
  }
  PROPERTIES
  {
    DataCaptionFields=Code,Description;
    OnInsert=BEGIN
               "Last Modified Date Time" := CURRENTDATETIME;
             END;

    OnModify=BEGIN
               "Last Modified Date Time" := CURRENTDATETIME;
             END;

    OnRename=BEGIN
               "Last Modified Date Time" := CURRENTDATETIME;
             END;

    CaptionML=[DAN=Betalingsform;
               ENU=Payment Method];
    LookupPageID=Page427;
    DrillDownPageID=Page427;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Bal. Account Type   ;Option        ;OnValidate=BEGIN
                                                                "Bal. Account No." := '';
                                                              END;

                                                   CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Bankkonto;
                                                                    ENU=G/L Account,Bank Account];
                                                   OptionString=G/L Account,Bank Account }
    { 4   ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
                                                   OnValidate=BEGIN
                                                                IF "Bal. Account No." <> '' THEN
                                                                  TESTFIELD("Direct Debit",FALSE);
                                                                IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN
                                                                  CheckGLAcc("Bal. Account No.");
                                                              END;

                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 6   ;   ;Direct Debit        ;Boolean       ;OnValidate=BEGIN
                                                                IF NOT "Direct Debit" THEN
                                                                  "Direct Debit Pmt. Terms Code" := '';
                                                                IF "Direct Debit" THEN
                                                                  TESTFIELD("Bal. Account No.",'');
                                                              END;

                                                   CaptionML=[DAN=Direct Debit;
                                                              ENU=Direct Debit] }
    { 7   ;   ;Direct Debit Pmt. Terms Code;Code10;TableRelation="Payment Terms";
                                                   OnValidate=BEGIN
                                                                IF "Direct Debit Pmt. Terms Code" <> '' THEN
                                                                  TESTFIELD("Direct Debit",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Kode for Direct Debit-betalingsbetingelser;
                                                              ENU=Direct Debit Pmt. Terms Code] }
    { 8   ;   ;Pmt. Export Line Definition;Code20 ;OnLookup=VAR
                                                              DataExchLineDef@1000 : Record 1227;
                                                              TempDataExchLineDef@1001 : TEMPORARY Record 1227;
                                                              DataExchDef@1002 : Record 1222;
                                                            BEGIN
                                                              DataExchLineDef.SETFILTER(Code,'<>%1','');
                                                              IF DataExchLineDef.FINDSET THEN BEGIN
                                                                REPEAT
                                                                  DataExchDef.GET(DataExchLineDef."Data Exch. Def Code");
                                                                  IF DataExchDef.Type = DataExchDef.Type::"Payment Export" THEN BEGIN
                                                                    TempDataExchLineDef.INIT;
                                                                    TempDataExchLineDef.Code := DataExchLineDef.Code;
                                                                    TempDataExchLineDef.Name := DataExchLineDef.Name;
                                                                    IF TempDataExchLineDef.INSERT THEN;
                                                                  END;
                                                                UNTIL DataExchLineDef.NEXT = 0;
                                                                IF PAGE.RUNMODAL(PAGE::"Pmt. Export Line Definitions",TempDataExchLineDef) = ACTION::LookupOK THEN
                                                                  "Pmt. Export Line Definition" := TempDataExchLineDef.Code;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Definition af betalingseksportlinje;
                                                              ENU=Pmt. Export Line Definition] }
    { 9   ;   ;Bank Data Conversion Pmt. Type;Text50;
                                                   TableRelation="Bank Data Conversion Pmt. Type";
                                                   CaptionML=[DAN=Betalingstype for bankdatakonvertering;
                                                              ENU=Bank Data Conversion Pmt. Type] }
    { 10  ;   ;Use for Invoicing   ;Boolean       ;CaptionML=[DAN=Angiv til fakturering;
                                                              ENU=Use for Invoicing] }
    { 11  ;   ;Last Modified Date Time;DateTime   ;CaptionML=[DAN=Dato/klokkesl‘t for seneste ‘ndring;
                                                              ENU=Last Modified Date Time];
                                                   Editable=No }
    { 8000;   ;Id                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 13600;  ;Payment Channel     ;Option        ;OnValidate=BEGIN
                                                                IF "Payment Channel" = "Payment Channel"::"Payment Slip" THEN
                                                                  ERROR(Text13600, FIELDCAPTION("Payment Channel"),"Payment Channel");
                                                              END;

                                                   CaptionML=[DAN=Betalingskanal;
                                                              ENU=Payment Channel];
                                                   OptionCaptionML=[DAN=" ,Betalingsbon,Kontooverf›rsel,National transaktion,Direct Debit";
                                                                    ENU=" ,Payment Slip,Account Transfer,National Clearing,Direct Debit"];
                                                   OptionString=[ ,Payment Slip,Account Transfer,National Clearing,Direct Debit] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;Code,Description                         }
  }
  CODE
  {
    VAR
      Text13600@13600 : TextConst 'DAN=%1 %2 underst›ttes ikke i denne version af OIOUBL.;ENU=%1 %2 is not supported in this version of OIOUBL.';

    LOCAL PROCEDURE CheckGLAcc@2(AccNo@1000 : Code[20]);
    VAR
      GLAcc@1001 : Record 15;
    BEGIN
      IF AccNo <> '' THEN BEGIN
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
        GLAcc.TESTFIELD("Direct Posting",TRUE);
      END;
    END;

    PROCEDURE TranslateDescription@3(Language@1001 : Code[10]);
    VAR
      PaymentMethodTranslation@1003 : Record 466;
    BEGIN
      IF PaymentMethodTranslation.GET(Code,Language) THEN
        VALIDATE(Description,COPYSTR(PaymentMethodTranslation.Description,1,MAXSTRLEN(Description)));
    END;

    PROCEDURE GetDescriptionInCurrentLanguage@1() : Text[100];
    VAR
      Language@1000 : Record 8;
      PaymentMethodTranslation@1001 : Record 466;
    BEGIN
      IF PaymentMethodTranslation.GET(Code,Language.GetUserLanguage) THEN
        EXIT(PaymentMethodTranslation.Description);

      EXIT(Description);
    END;

    BEGIN
    END.
  }
}

