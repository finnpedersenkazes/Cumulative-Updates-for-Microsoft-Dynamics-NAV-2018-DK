OBJECT Table 5625 Maintenance Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Reparationspost;
               ENU=Maintenance Ledger Entry];
    LookupPageID=Page5641;
    DrillDownPageID=Page5641;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;G/L Entry No.       ;Integer       ;TableRelation="G/L Entry";
                                                   CaptionML=[DAN=Finanslõbenr.;
                                                              ENU=G/L Entry No.];
                                                   BlankZero=Yes }
    { 3   ;   ;FA No.              ;Code20        ;TableRelation="Fixed Asset";
                                                   CaptionML=[DAN=Anlëgsnr.;
                                                              ENU=FA No.] }
    { 4   ;   ;FA Posting Date     ;Date          ;CaptionML=[DAN=Bogfõringsdato for anlëg;
                                                              ENU=FA Posting Date] }
    { 5   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 6   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 7   ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 8   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 9   ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 10  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 12  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 13  ;   ;Debit Amount        ;Decimal       ;CaptionML=[DAN=Debetbelõb;
                                                              ENU=Debit Amount];
                                                   AutoFormatType=1 }
    { 14  ;   ;Credit Amount       ;Decimal       ;CaptionML=[DAN=Kreditbelõb;
                                                              ENU=Credit Amount];
                                                   AutoFormatType=1 }
    { 15  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 16  ;   ;FA No./Budgeted FA No.;Code20      ;TableRelation="Fixed Asset";
                                                   CaptionML=[DAN=Anlëgsnr./budgetanlëgsnr.;
                                                              ENU=FA No./Budgeted FA No.] }
    { 17  ;   ;FA Subclass Code    ;Code10        ;TableRelation="FA Subclass";
                                                   CaptionML=[DAN=Anlëgsgruppekode;
                                                              ENU=FA Subclass Code] }
    { 18  ;   ;FA Location Code    ;Code10        ;TableRelation="FA Location";
                                                   CaptionML=[DAN=Anlëgslokationskode;
                                                              ENU=FA Location Code] }
    { 19  ;   ;FA Posting Group    ;Code20        ;TableRelation="FA Posting Group";
                                                   CaptionML=[DAN=Anlëgsbogfõringsgruppe;
                                                              ENU=FA Posting Group] }
    { 20  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 21  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 22  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 24  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 25  ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 26  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 27  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 28  ;   ;Transaction No.     ;Integer       ;CaptionML=[DAN=Transaktionsnr.;
                                                              ENU=Transaction No.] }
    { 29  ;   ;Bal. Account Type   ;Option        ;CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anlëg;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset }
    { 30  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 31  ;   ;VAT Amount          ;Decimal       ;CaptionML=[DAN=Momsbelõb;
                                                              ENU=VAT Amount];
                                                   AutoFormatType=1 }
    { 32  ;   ;Gen. Posting Type   ;Option        ;CaptionML=[DAN=Bogfõringstype;
                                                              ENU=Gen. Posting Type];
                                                   OptionCaptionML=[DAN=" ,Kõb,Salg,Afregning";
                                                                    ENU=" ,Purchase,Sale,Settlement"];
                                                   OptionString=[ ,Purchase,Sale,Settlement] }
    { 33  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 34  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogfõringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 35  ;   ;FA Class Code       ;Code10        ;TableRelation="FA Class";
                                                   CaptionML=[DAN=Anlëgsartskode;
                                                              ENU=FA Class Code] }
    { 36  ;   ;Depreciation Book Code;Code10      ;TableRelation="Depreciation Book";
                                                   CaptionML=[DAN=Afskrivningsprofilkode;
                                                              ENU=Depreciation Book Code] }
    { 37  ;   ;FA Exchange Rate    ;Decimal       ;CaptionML=[DAN=Anlëgsvalutakurs;
                                                              ENU=FA Exchange Rate];
                                                   AutoFormatType=1 }
    { 38  ;   ;Amount (LCY)        ;Decimal       ;CaptionML=[DAN=Belõb (RV);
                                                              ENU=Amount (LCY)];
                                                   AutoFormatType=1 }
    { 39  ;   ;Maintenance Code    ;Code10        ;TableRelation=Maintenance;
                                                   CaptionML=[DAN=Reparationskode;
                                                              ENU=Maintenance Code] }
    { 40  ;   ;Correction          ;Boolean       ;CaptionML=[DAN=Rettelse;
                                                              ENU=Correction] }
    { 41  ;   ;Index Entry         ;Boolean       ;CaptionML=[DAN=Indekspost;
                                                              ENU=Index Entry] }
    { 42  ;   ;Automatic Entry     ;Boolean       ;CaptionML=[DAN=Automatisk postering;
                                                              ENU=Automatic Entry] }
    { 43  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 44  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=SkatteomrÜdekode;
                                                              ENU=Tax Area Code] }
    { 45  ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 46  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 47  ;   ;Use Tax             ;Boolean       ;CaptionML=[DAN=Use Tax;
                                                              ENU=Use Tax] }
    { 48  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 49  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 50  ;   ;Reversed            ;Boolean       ;CaptionML=[DAN=Tilbagefõrt;
                                                              ENU=Reversed] }
    { 51  ;   ;Reversed by Entry No.;Integer      ;TableRelation="Maintenance Ledger Entry";
                                                   CaptionML=[DAN=Tilbagefõrt af lõbenr.;
                                                              ENU=Reversed by Entry No.];
                                                   BlankZero=Yes }
    { 52  ;   ;Reversed Entry No.  ;Integer       ;TableRelation="Maintenance Ledger Entry";
                                                   CaptionML=[DAN=Tilbagefõrt lõbenr.;
                                                              ENU=Reversed Entry No.];
                                                   BlankZero=Yes }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;FA No.,Depreciation Book Code,FA Posting Date;
                                                   SumIndexFields=Amount }
    {    ;FA No.,Depreciation Book Code,Posting Date;
                                                   SumIndexFields=Amount }
    {    ;FA No.,Depreciation Book Code,Maintenance Code,FA Posting Date;
                                                   SumIndexFields=Amount }
    {    ;FA No.,Depreciation Book Code,Maintenance Code,Posting Date;
                                                   SumIndexFields=Amount }
    {    ;Document No.,Posting Date                }
    {    ;G/L Entry No.                            }
    {    ;Transaction No.                          }
    {    ;FA No.,Depreciation Book Code,Document No. }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Description,FA No.,FA Posting Date }
  }
  CODE
  {
    VAR
      DimMgt@1000 : Codeunit 408;

    [External]
    PROCEDURE ShowDimensions@1();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    BEGIN
    END.
  }
}

