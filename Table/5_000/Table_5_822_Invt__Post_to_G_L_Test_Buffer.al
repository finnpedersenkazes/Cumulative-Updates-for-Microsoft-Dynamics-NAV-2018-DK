OBJECT Table 5822 Invt. Post to G/L Test Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagerbogf. til finanstestbuffer;
               ENU=Invt. Post to G/L Test Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Line No.            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 2   ;   ;Account No.         ;Code20        ;TableRelation="G/L Account";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kontonr.;
                                                              ENU=Account No.] }
    { 3   ;   ;Posting Date        ;Date          ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date];
                                                   ClosingDates=Yes }
    { 4   ;   ;Document No.        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 5   ;   ;Description         ;Text50        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 6   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 8   ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code];
                                                   Editable=No }
    { 9   ;   ;System-Created Entry;Boolean       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry];
                                                   Editable=No }
    { 10  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Virksomhedsbogf›ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 11  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Produktbogf›ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 13  ;   ;Additional-Currency Posting;Option ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Ekstra valuta (postering);
                                                              ENU=Additional-Currency Posting];
                                                   OptionCaptionML=[DAN=Ingen,Kun bel›b,Kun ekstra valutabel›b;
                                                                    ENU=None,Amount Only,Additional-Currency Amount Only];
                                                   OptionString=None,Amount Only,Additional-Currency Amount Only;
                                                   Editable=No }
    { 14  ;   ;Source Currency Code;Code10        ;TableRelation=Currency;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildevalutakode;
                                                              ENU=Source Currency Code];
                                                   Editable=No }
    { 15  ;   ;Source Currency Amount;Decimal     ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kildevalutabel›b;
                                                              ENU=Source Currency Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 16  ;   ;Value Entry No.     ;Integer       ;TableRelation="Value Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘rdil›benr.;
                                                              ENU=Value Entry No.];
                                                   Editable=No }
    { 17  ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 18  ;   ;Invt. Posting Group Code;Code20    ;TableRelation="Inventory Posting Group";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Varebogf›ringsgruppekode;
                                                              ENU=Invt. Posting Group Code] }
    { 19  ;   ;Inventory Account Type;Option      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lagerkontotype;
                                                              ENU=Inventory Account Type];
                                                   OptionCaptionML=[DAN=Lager (mellemkto.),Lagerperiod.konto (mellemkto.),Lager,VIA-v‘rdi,Lagerregulering,Tillagte direkte omkostninger,Tillagte indir. prod.omkostninger,K›bsafvigelse,Vareforbrug,Vareforbrug (mellemkto.),Mat. omk.afvigelse,Kap.omk.afvigelse,Underlev.kostafvigelse,Indir. kap.kostprisafv.,Indir. prod. omkostningsafv.;
                                                                    ENU=Inventory (Interim),Invt. Accrual (Interim),Inventory,WIP Inventory,Inventory Adjmt.,Direct Cost Applied,Overhead Applied,Purchase Variance,COGS,COGS (Interim),Material Variance,Capacity Variance,Subcontracted Variance,Cap. Overhead Variance,Mfg. Overhead Variance];
                                                   OptionString=Inventory (Interim),Invt. Accrual (Interim),Inventory,WIP Inventory,Inventory Adjmt.,Direct Cost Applied,Overhead Applied,Purchase Variance,COGS,COGS (Interim),Material Variance,Capacity Variance,Subcontracted Variance,Cap. Overhead Variance,Mfg. Overhead Variance }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Line No.                                ;Clustered=Yes }
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

