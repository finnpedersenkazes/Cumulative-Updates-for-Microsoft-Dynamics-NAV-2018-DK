OBJECT Table 48 Invt. Posting Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagerbogf.buffer;
               ENU=Invt. Posting Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Account Type        ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontotype;
                                                              ENU=Account Type];
                                                   OptionCaptionML=[DAN=Lager (mellemkto.),Lagerperiod.konto (mellemkto.),Lager,VIA-v‘rdi,Lagerregulering,Tillagte direkte omkostninger,Tillagte indir. prod.omkostninger,K›bsafvigelse,Vareforbrug,Vareforbrug (mellemkto.),Mat. omk.afvigelse,Kap.omk.afvigelse,Underlev.kostafvigelse,Indir. kap.kostprisafv.,Indir. prod.omkostningsafv.;
                                                                    ENU=Inventory (Interim),Invt. Accrual (Interim),Inventory,WIP Inventory,Inventory Adjmt.,Direct Cost Applied,Overhead Applied,Purchase Variance,COGS,COGS (Interim),Material Variance,Capacity Variance,Subcontracted Variance,Cap. Overhead Variance,Mfg. Overhead Variance];
                                                   OptionString=Inventory (Interim),Invt. Accrual (Interim),Inventory,WIP Inventory,Inventory Adjmt.,Direct Cost Applied,Overhead Applied,Purchase Variance,COGS,COGS (Interim),Material Variance,Capacity Variance,Subcontracted Variance,Cap. Overhead Variance,Mfg. Overhead Variance }
    { 2   ;   ;Location Code       ;Code10        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 3   ;   ;Inventory Posting Group;Code20     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varebogf›ringsgruppe;
                                                              ENU=Inventory Posting Group] }
    { 4   ;   ;Dimension Entry No. ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsl›benr.;
                                                              ENU=Dimension Entry No.] }
    { 5   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount] }
    { 6   ;   ;Amount (ACY)        ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b (EV);
                                                              ENU=Amount (ACY)] }
    { 7   ;   ;Interim Account     ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Mellemregningskonto;
                                                              ENU=Interim Account] }
    { 8   ;   ;Account No.         ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 9   ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 10  ;   ;Gen. Bus. Posting Group;Code20     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Virksomhedsbogf›ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 11  ;   ;Gen. Prod. Posting Group;Code20    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Produktbogf›ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 12  ;   ;Negative            ;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Negativ;
                                                              ENU=Negative] }
    { 13  ;   ;Entry No.           ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 14  ;   ;Bal. Account Type   ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Lager (mellemkto.),Lagerperiod.konto (mellemkto.),Lager,VIA-v‘rdi,Lagerregulering,Tillagte direkte omkostninger,Tillagte indir. prod.omkostninger,K›bsafvigelse,Vareforbrug,Vareforbrug (mellemkto.),Mat. omk.afvigelse,Kap.omk.afvigelse,Underlev.kostafvigelse,Indir. kap.kostprisafv.,Indir. prod. omkostningsafv.;
                                                                    ENU=Inventory (Interim),Invt. Accrual (Interim),Inventory,WIP Inventory,Inventory Adjmt.,Direct Cost Applied,Overhead Applied,Purchase Variance,COGS,COGS (Interim),Material Variance,Capacity Variance,Subcontracted Variance,Cap. Overhead Variance,Mfg. Overhead Variance];
                                                   OptionString=Inventory (Interim),Invt. Accrual (Interim),Inventory,WIP Inventory,Inventory Adjmt.,Direct Cost Applied,Overhead Applied,Purchase Variance,COGS,COGS (Interim),Material Variance,Capacity Variance,Subcontracted Variance,Cap. Overhead Variance,Mfg. Overhead Variance }
    { 15  ;   ;Job No.             ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Posting Date,Account Type,Location Code,Inventory Posting Group,Gen. Bus. Posting Group,Gen. Prod. Posting Group,Dimension Set ID,Negative,Bal. Account Type;
                                                   Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE UseInvtPostSetup@9() : Boolean;
    BEGIN
      EXIT(
        "Account Type" IN
        ["Account Type"::Inventory,
         "Account Type"::"Inventory (Interim)",
         "Account Type"::"WIP Inventory",
         "Account Type"::"Material Variance",
         "Account Type"::"Capacity Variance",
         "Account Type"::"Subcontracted Variance",
         "Account Type"::"Cap. Overhead Variance",
         "Account Type"::"Mfg. Overhead Variance"]);
    END;

    BEGIN
    END.
  }
}

