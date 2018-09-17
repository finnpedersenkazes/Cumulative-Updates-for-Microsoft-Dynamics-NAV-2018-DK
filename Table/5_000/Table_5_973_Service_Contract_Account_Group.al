OBJECT Table 5973 Service Contract Account Group
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Servicekontraktkontogruppe;
               ENU=Service Contract Account Group];
    LookupPageID=Page6070;
    DrillDownPageID=Page6070;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code10        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 3   ;   ;Non-Prepaid Contract Acc.;Code20   ;TableRelation="G/L Account".No.;
                                                   OnValidate=BEGIN
                                                                IF "Non-Prepaid Contract Acc." <> '' THEN BEGIN
                                                                  GlAcc.GET("Non-Prepaid Contract Acc.");
                                                                  GlAcc.TESTFIELD("Gen. Prod. Posting Group");
                                                                  GlAcc.TESTFIELD("VAT Prod. Posting Group");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Ikkeforudbet. kontraktkonto;
                                                              ENU=Non-Prepaid Contract Acc.] }
    { 4   ;   ;Prepaid Contract Acc.;Code20       ;TableRelation="G/L Account".No.;
                                                   OnValidate=BEGIN
                                                                IF "Prepaid Contract Acc." <> '' THEN BEGIN
                                                                  GlAcc.GET("Prepaid Contract Acc.");
                                                                  GlAcc.TESTFIELD("Gen. Prod. Posting Group");
                                                                  GlAcc.TESTFIELD("VAT Prod. Posting Group");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Forudbet. kontraktkonto;
                                                              ENU=Prepaid Contract Acc.] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      GlAcc@1000 : Record 15;

    BEGIN
    END.
  }
}

