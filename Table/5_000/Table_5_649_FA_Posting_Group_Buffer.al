OBJECT Table 5649 FA Posting Group Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anl‘gsbogf›ringsgruppebuffer;
               ENU=FA Posting Group Buffer];
  }
  FIELDS
  {
    { 1   ;   ;FA Posting Group    ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Anl‘gsbogf›ringsgruppe;
                                                              ENU=FA Posting Group] }
    { 2   ;   ;Posting Type        ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringstype;
                                                              ENU=Posting Type];
                                                   OptionCaptionML=[DAN=Anskaf,Afskr,Nedskr,Opskr,Br1,Br2,AfskrUdlb,Rep,Salg,Finans,ModpV,AnskSalg,AfskrSalg,NskrSalg,OskrSalg,B1Salg,B2Salg,ModpNskr,ModpOskr,ModpB1,ModpB2;
                                                                    ENU=Acq,Depr,WD,Appr,C1,C2,DeprExp,Maint,Disp,GL,BV,DispAcq,DispDepr,DispWD,DispAppr,DispC1,DispC2,BalWD,BalAppr,BalC1,BalC2];
                                                   OptionString=Acq,Depr,WD,Appr,C1,C2,DeprExp,Maint,Disp,GL,BV,DispAcq,DispDepr,DispWD,DispAppr,DispC1,DispC2,BalWD,BalAppr,BalC1,BalC2 }
    { 3   ;   ;Account No.         ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 4   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount] }
    { 5   ;   ;Account Name        ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontonavn;
                                                              ENU=Account Name] }
    { 6   ;   ;FA FieldCaption     ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Anl‘g - feltnavn;
                                                              ENU=FA FieldCaption] }
  }
  KEYS
  {
    {    ;FA Posting Group,Posting Type,Account No.;
                                                   Clustered=Yes }
    {    ;Account No.                             ;SumIndexFields=Amount }
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

