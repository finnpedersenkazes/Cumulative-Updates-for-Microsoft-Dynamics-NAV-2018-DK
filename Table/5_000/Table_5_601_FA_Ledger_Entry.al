OBJECT Table 5601 FA Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anlëgsfinanspost;
               ENU=FA Ledger Entry];
    LookupPageID=Page5604;
    DrillDownPageID=Page5604;
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
    { 11  ;   ;Depreciation Book Code;Code10      ;TableRelation="Depreciation Book";
                                                   CaptionML=[DAN=Afskrivningsprofilkode;
                                                              ENU=Depreciation Book Code] }
    { 12  ;   ;FA Posting Category ;Option        ;CaptionML=[DAN=Anlëgsbogfõringskategori;
                                                              ENU=FA Posting Category];
                                                   OptionCaptionML=[DAN=" ,Salg,Modpost salg";
                                                                    ENU=" ,Disposal,Bal. Disposal"];
                                                   OptionString=[ ,Disposal,Bal. Disposal] }
    { 13  ;   ;FA Posting Type     ;Option        ;CaptionML=[DAN=Anlëgsbogfõringstype;
                                                              ENU=FA Posting Type];
                                                   OptionCaptionML=[DAN=Anskaffelse,Afskrivning,Nedskrivning,Opskrivning,Bruger 1,Bruger 2,Salg,Scrapvërdi,Tab/Vinding,Bogfõrt vërdi ved salg;
                                                                    ENU=Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Proceeds on Disposal,Salvage Value,Gain/Loss,Book Value on Disposal];
                                                   OptionString=Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Proceeds on Disposal,Salvage Value,Gain/Loss,Book Value on Disposal }
    { 14  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 15  ;   ;Debit Amount        ;Decimal       ;CaptionML=[DAN=Debetbelõb;
                                                              ENU=Debit Amount];
                                                   AutoFormatType=1 }
    { 16  ;   ;Credit Amount       ;Decimal       ;CaptionML=[DAN=Kreditbelõb;
                                                              ENU=Credit Amount];
                                                   AutoFormatType=1 }
    { 17  ;   ;Reclassification Entry;Boolean     ;CaptionML=[DAN=Omposteringspost;
                                                              ENU=Reclassification Entry] }
    { 18  ;   ;Part of Book Value  ;Boolean       ;CaptionML=[DAN=Del af bogfõrt vërdi;
                                                              ENU=Part of Book Value] }
    { 19  ;   ;Part of Depreciable Basis;Boolean  ;CaptionML=[DAN=Del af afskrivningsgrundlag;
                                                              ENU=Part of Depreciable Basis] }
    { 20  ;   ;Disposal Calculation Method;Option ;CaptionML=[DAN=Beregningsmetode ved salg;
                                                              ENU=Disposal Calculation Method];
                                                   OptionCaptionML=[DAN=" ,Netto,Brutto";
                                                                    ENU=" ,Net,Gross"];
                                                   OptionString=[ ,Net,Gross] }
    { 21  ;   ;Disposal Entry No.  ;Integer       ;CaptionML=[DAN=Salgslõbenr.;
                                                              ENU=Disposal Entry No.];
                                                   BlankZero=Yes }
    { 22  ;   ;No. of Depreciation Days;Integer   ;CaptionML=[DAN=Antal afskrivningsdage;
                                                              ENU=No. of Depreciation Days] }
    { 23  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 24  ;   ;FA No./Budgeted FA No.;Code20      ;TableRelation="Fixed Asset";
                                                   CaptionML=[DAN=Anlëgsnr./budgetanlëgsnr.;
                                                              ENU=FA No./Budgeted FA No.] }
    { 25  ;   ;FA Subclass Code    ;Code10        ;TableRelation="FA Subclass";
                                                   CaptionML=[DAN=Anlëgsgruppekode;
                                                              ENU=FA Subclass Code] }
    { 26  ;   ;FA Location Code    ;Code10        ;TableRelation="FA Location";
                                                   CaptionML=[DAN=Anlëgslokationskode;
                                                              ENU=FA Location Code] }
    { 27  ;   ;FA Posting Group    ;Code20        ;TableRelation="FA Posting Group";
                                                   CaptionML=[DAN=Anlëgsbogfõringsgruppe;
                                                              ENU=FA Posting Group] }
    { 28  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 29  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 30  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 32  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 33  ;   ;Depreciation Method ;Option        ;CaptionML=[DAN=Afskrivningsmetode;
                                                              ENU=Depreciation Method];
                                                   OptionCaptionML=[DAN=Lineër,Saldo 1,Saldo 2,Saldo 1/Lineër,Saldo 2/Lineër,Brugerdefineret,Manuel;
                                                                    ENU=Straight-Line,Declining-Balance 1,Declining-Balance 2,DB1/SL,DB2/SL,User-Defined,Manual];
                                                   OptionString=Straight-Line,Declining-Balance 1,Declining-Balance 2,DB1/SL,DB2/SL,User-Defined,Manual }
    { 34  ;   ;Depreciation Starting Date;Date    ;CaptionML=[DAN=Afskriv fra den;
                                                              ENU=Depreciation Starting Date] }
    { 35  ;   ;Straight-Line %     ;Decimal       ;CaptionML=[DAN=Lineër pct.;
                                                              ENU=Straight-Line %];
                                                   DecimalPlaces=1:1 }
    { 36  ;   ;No. of Depreciation Years;Decimal  ;CaptionML=[DAN=Antal afskrivningsÜr;
                                                              ENU=No. of Depreciation Years];
                                                   DecimalPlaces=0:3 }
    { 37  ;   ;Fixed Depr. Amount  ;Decimal       ;CaptionML=[DAN=Fast afskr.belõb;
                                                              ENU=Fixed Depr. Amount];
                                                   AutoFormatType=1 }
    { 38  ;   ;Declining-Balance % ;Decimal       ;CaptionML=[DAN=Saldopct.;
                                                              ENU=Declining-Balance %];
                                                   DecimalPlaces=1:1 }
    { 39  ;   ;Depreciation Table Code;Code10     ;TableRelation="Depreciation Table Header";
                                                   CaptionML=[DAN=Afskrivningstabelkode;
                                                              ENU=Depreciation Table Code] }
    { 40  ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 41  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 42  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 43  ;   ;Transaction No.     ;Integer       ;CaptionML=[DAN=Transaktionsnr.;
                                                              ENU=Transaction No.] }
    { 44  ;   ;Bal. Account Type   ;Option        ;CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anlëg;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset }
    { 45  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset";
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 46  ;   ;VAT Amount          ;Decimal       ;CaptionML=[DAN=Momsbelõb;
                                                              ENU=VAT Amount];
                                                   AutoFormatType=1 }
    { 47  ;   ;Gen. Posting Type   ;Option        ;CaptionML=[DAN=Bogfõringstype;
                                                              ENU=Gen. Posting Type];
                                                   OptionCaptionML=[DAN=" ,Kõb,Salg,Afregning";
                                                                    ENU=" ,Purchase,Sale,Settlement"];
                                                   OptionString=[ ,Purchase,Sale,Settlement] }
    { 48  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 49  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogfõringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 50  ;   ;FA Class Code       ;Code10        ;TableRelation="FA Class";
                                                   CaptionML=[DAN=Anlëgsartskode;
                                                              ENU=FA Class Code] }
    { 51  ;   ;FA Exchange Rate    ;Decimal       ;CaptionML=[DAN=Anlëgsvalutakurs;
                                                              ENU=FA Exchange Rate];
                                                   AutoFormatType=1 }
    { 52  ;   ;Amount (LCY)        ;Decimal       ;CaptionML=[DAN=Belõb (RV);
                                                              ENU=Amount (LCY)];
                                                   AutoFormatType=1 }
    { 53  ;   ;Result on Disposal  ;Option        ;CaptionML=[DAN=Resultat af salg;
                                                              ENU=Result on Disposal];
                                                   OptionCaptionML=[DAN=" ,Gevinst,Tab";
                                                                    ENU=" ,Gain,Loss"];
                                                   OptionString=[ ,Gain,Loss] }
    { 54  ;   ;Correction          ;Boolean       ;CaptionML=[DAN=Rettelse;
                                                              ENU=Correction] }
    { 55  ;   ;Index Entry         ;Boolean       ;CaptionML=[DAN=Indekspost;
                                                              ENU=Index Entry] }
    { 56  ;   ;Canceled from FA No.;Code20        ;TableRelation="Fixed Asset";
                                                   CaptionML=[DAN=Annulleret fra anlëgsnr.;
                                                              ENU=Canceled from FA No.] }
    { 57  ;   ;Depreciation Ending Date;Date      ;CaptionML=[DAN=Afskriv til den;
                                                              ENU=Depreciation Ending Date] }
    { 58  ;   ;Use FA Ledger Check ;Boolean       ;CaptionML=[DAN=Brug anlëgsbogf.kontrol;
                                                              ENU=Use FA Ledger Check] }
    { 59  ;   ;Automatic Entry     ;Boolean       ;CaptionML=[DAN=Automatisk postering;
                                                              ENU=Automatic Entry] }
    { 60  ;   ;Depr. Starting Date (Custom 1);Date;CaptionML=[DAN=Afskriv fra den (bruger 1);
                                                              ENU=Depr. Starting Date (Custom 1)] }
    { 61  ;   ;Depr. Ending Date (Custom 1);Date  ;CaptionML=[DAN=Afskriv til den (bruger 1);
                                                              ENU=Depr. Ending Date (Custom 1)] }
    { 62  ;   ;Accum. Depr. % (Custom 1);Decimal  ;CaptionML=[DAN=Akkum. afskr.pct (bruger 1);
                                                              ENU=Accum. Depr. % (Custom 1)];
                                                   DecimalPlaces=1:1 }
    { 63  ;   ;Depr. % this year (Custom 1);Decimal;
                                                   CaptionML=[DAN=Afskr.pct. dette Ür (bruger 1);
                                                              ENU=Depr. % this year (Custom 1)];
                                                   DecimalPlaces=1:1 }
    { 64  ;   ;Property Class (Custom 1);Option   ;CaptionML=[DAN=Anlëgstype (bruger 1);
                                                              ENU=Property Class (Custom 1)];
                                                   OptionCaptionML=[DAN=" ,Lõsõre,Fast ejendom";
                                                                    ENU=" ,Personal Property,Real Property"];
                                                   OptionString=[ ,Personal Property,Real Property] }
    { 65  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 66  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=SkatteomrÜdekode;
                                                              ENU=Tax Area Code] }
    { 67  ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 68  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 69  ;   ;Use Tax             ;Boolean       ;CaptionML=[DAN=Use Tax;
                                                              ENU=Use Tax] }
    { 70  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 71  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 72  ;   ;Reversed            ;Boolean       ;CaptionML=[DAN=Tilbagefõrt;
                                                              ENU=Reversed] }
    { 73  ;   ;Reversed by Entry No.;Integer      ;TableRelation="FA Ledger Entry";
                                                   CaptionML=[DAN=Tilbagefõrt af lõbenr.;
                                                              ENU=Reversed by Entry No.];
                                                   BlankZero=Yes }
    { 74  ;   ;Reversed Entry No.  ;Integer       ;TableRelation="FA Ledger Entry";
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
    {    ;FA No.,Depreciation Book Code,FA Posting Category,FA Posting Type,FA Posting Date,Part of Book Value,Reclassification Entry;
                                                   SumIndexFields=Amount }
    {    ;FA No.,Depreciation Book Code,Part of Book Value,FA Posting Date;
                                                   SumIndexFields=Amount }
    {    ;FA No.,Depreciation Book Code,Part of Depreciable Basis,FA Posting Date;
                                                   SumIndexFields=Amount }
    {    ;FA No.,Depreciation Book Code,FA Posting Category,FA Posting Type,Posting Date;
                                                   SumIndexFields=Amount }
    {    ;Canceled from FA No.,Depreciation Book Code,FA Posting Date }
    {    ;Document No.,Posting Date                }
    {    ;G/L Entry No.                            }
    {    ;Document Type,Document No.               }
    {    ;Transaction No.                          }
    {    ;FA No.,Depreciation Book Code,FA Posting Category,FA Posting Type,Document No. }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,FA No.,FA Posting Date,FA Posting Type,Document Type }
  }
  CODE
  {
    VAR
      FAJnlSetup@1000 : Record 5605;
      DimMgt@1001 : Codeunit 408;
      NextLineNo@1002 : Integer;

    [External]
    PROCEDURE MoveToGenJnl@3(VAR GenJnlLine@1000 : Record 81);
    BEGIN
      NextLineNo := GenJnlLine."Line No.";
      GenJnlLine."Line No." := 0;
      GenJnlLine.INIT;
      FAJnlSetup.SetGenJnlTrailCodes(GenJnlLine);
      GenJnlLine."FA Posting Type" := ConvertPostingType + 1;
      GenJnlLine."Posting Date" := "Posting Date";
      GenJnlLine."FA Posting Date" := "FA Posting Date";
      IF GenJnlLine."Posting Date" = GenJnlLine."FA Posting Date" THEN
        GenJnlLine."FA Posting Date" := 0D;
      GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"Fixed Asset");
      GenJnlLine.VALIDATE("Account No.","FA No.");
      GenJnlLine.VALIDATE("Depreciation Book Code","Depreciation Book Code");
      GenJnlLine.VALIDATE(Amount,Amount);
      GenJnlLine.VALIDATE(Correction,Correction);
      GenJnlLine."Document Type" := "Document Type";
      GenJnlLine."Document No." := "Document No.";
      GenJnlLine."Document Date" := "Document Date";
      GenJnlLine."External Document No." := "External Document No.";
      GenJnlLine.Quantity := Quantity;
      GenJnlLine."No. of Depreciation Days" := "No. of Depreciation Days";
      GenJnlLine."FA Reclassification Entry" := "Reclassification Entry";
      GenJnlLine."Index Entry" := "Index Entry";
      GenJnlLine."Line No." := NextLineNo;
      GenJnlLine."Dimension Set ID" := "Dimension Set ID";

      OnAfterMoveToGenJnlLine(GenJnlLine,Rec);
    END;

    [External]
    PROCEDURE MoveToFAJnl@2(VAR FAJnlLine@1000 : Record 5621);
    BEGIN
      NextLineNo := FAJnlLine."Line No.";
      FAJnlLine."Line No." := 0;
      FAJnlLine.INIT;
      FAJnlSetup.SetFAJnlTrailCodes(FAJnlLine);
      FAJnlLine."FA Posting Type" := ConvertPostingType;
      FAJnlLine."Posting Date" := "Posting Date";
      FAJnlLine."FA Posting Date" := "FA Posting Date";
      IF FAJnlLine."Posting Date" = FAJnlLine."FA Posting Date" THEN
        FAJnlLine."Posting Date" := 0D;
      FAJnlLine.VALIDATE("FA No.","FA No.");
      FAJnlLine.VALIDATE("Depreciation Book Code","Depreciation Book Code");
      FAJnlLine.VALIDATE(Amount,Amount);
      FAJnlLine.VALIDATE(Correction,Correction);
      FAJnlLine.Quantity := Quantity;
      FAJnlLine."Document Type" := "Document Type";
      FAJnlLine."Document No." := "Document No.";
      FAJnlLine."Document Date" := "Document Date";
      FAJnlLine."External Document No." := "External Document No.";
      FAJnlLine."No. of Depreciation Days" := "No. of Depreciation Days";
      FAJnlLine."FA Reclassification Entry" := "Reclassification Entry";
      FAJnlLine."Index Entry" := "Index Entry";
      FAJnlLine."Line No." := NextLineNo;
      FAJnlLine."Dimension Set ID" := "Dimension Set ID";

      OnAfterMoveToFAJnlLine(FAJnlLine,Rec);
    END;

    [External]
    PROCEDURE ConvertPostingType@1() : Option;
    VAR
      FAJnlLine@1000 : Record 5621;
    BEGIN
      CASE "FA Posting Type" OF
        "FA Posting Type"::"Acquisition Cost":
          FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::"Acquisition Cost";
        "FA Posting Type"::Depreciation:
          FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::Depreciation;
        "FA Posting Type"::"Write-Down":
          FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::"Write-Down";
        "FA Posting Type"::Appreciation:
          FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::Appreciation;
        "FA Posting Type"::"Custom 1":
          FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::"Custom 1";
        "FA Posting Type"::"Custom 2":
          FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::"Custom 2";
        "FA Posting Type"::"Proceeds on Disposal":
          FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::Disposal;
        "FA Posting Type"::"Salvage Value":
          FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::"Salvage Value";
      END;
      EXIT(FAJnlLine."FA Posting Type");
    END;

    [External]
    PROCEDURE ShowDimensions@4();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterMoveToGenJnlLine@6(VAR GenJournalLine@1000 : Record 81;FALedgerEntry@1001 : Record 5601);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterMoveToFAJnlLine@5(VAR FAJournalLine@1000 : Record 5621;FALedgerEntry@1001 : Record 5601);
    BEGIN
    END;

    BEGIN
    END.
  }
}

