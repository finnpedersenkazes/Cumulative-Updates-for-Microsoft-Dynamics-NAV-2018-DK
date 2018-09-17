OBJECT Table 98 General Ledger Setup
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opsëtning af Finans;
               ENU=General Ledger Setup];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Primërnõgle;
                                                              ENU=Primary Key] }
    { 2   ;   ;Allow Posting From  ;Date          ;CaptionML=[DAN=Bogf. tilladt fra;
                                                              ENU=Allow Posting From] }
    { 3   ;   ;Allow Posting To    ;Date          ;CaptionML=[DAN=Bogf. tilladt til;
                                                              ENU=Allow Posting To] }
    { 4   ;   ;Register Time       ;Boolean       ;CaptionML=[DAN=Registrer tid;
                                                              ENU=Register Time] }
    { 28  ;   ;Pmt. Disc. Excl. VAT;Boolean       ;OnValidate=BEGIN
                                                                IF "Pmt. Disc. Excl. VAT" THEN
                                                                  TESTFIELD("Adjust for Payment Disc.",FALSE)
                                                                ELSE
                                                                  TESTFIELD("VAT Tolerance %",0);
                                                              END;

                                                   CaptionML=[DAN=Kont.rabat fõr moms;
                                                              ENU=Pmt. Disc. Excl. VAT] }
    { 41  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 42  ;   ;Global Dimension 1 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Global Dimension 1 Code));
                                                   CaptionML=[DAN=Global dimension 1-filter;
                                                              ENU=Global Dimension 1 Filter];
                                                   CaptionClass='1,3,1' }
    { 43  ;   ;Global Dimension 2 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Dimension Code=FIELD(Global Dimension 2 Code));
                                                   CaptionML=[DAN=Global dimension 2-filter;
                                                              ENU=Global Dimension 2 Filter];
                                                   CaptionClass='1,3,2' }
    { 44  ;   ;Cust. Balances Due  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Initial Entry Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Forf. deb.belõb (RV);
                                                              ENU=Cust. Balances Due];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 45  ;   ;Vendor Balances Due ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Initial Entry Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Forf.kred.belõb;
                                                              ENU=Vendor Balances Due];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 48  ;   ;Unrealized VAT      ;Boolean       ;OnValidate=BEGIN
                                                                IF NOT "Unrealized VAT" THEN BEGIN
                                                                  VATPostingSetup.SETFILTER(
                                                                    "Unrealized VAT Type",'>=%1',VATPostingSetup."Unrealized VAT Type"::Percentage);
                                                                  IF VATPostingSetup.FINDFIRST THEN
                                                                    ERROR(
                                                                      Text000,VATPostingSetup.TABLECAPTION,
                                                                      VATPostingSetup."VAT Bus. Posting Group",VATPostingSetup."VAT Prod. Posting Group",
                                                                      VATPostingSetup.FIELDCAPTION("Unrealized VAT Type"),VATPostingSetup."Unrealized VAT Type");
                                                                  TaxJurisdiction.SETFILTER(
                                                                    "Unrealized VAT Type",'>=%1',TaxJurisdiction."Unrealized VAT Type"::Percentage);
                                                                  IF TaxJurisdiction.FINDFIRST THEN
                                                                    ERROR(
                                                                      Text001,TaxJurisdiction.TABLECAPTION,
                                                                      TaxJurisdiction.Code,TaxJurisdiction.FIELDCAPTION("Unrealized VAT Type"),
                                                                      TaxJurisdiction."Unrealized VAT Type");
                                                                END;
                                                                IF "Unrealized VAT" THEN
                                                                  "Prepayment Unrealized VAT" := TRUE
                                                                ELSE
                                                                  "Prepayment Unrealized VAT" := FALSE;
                                                              END;

                                                   CaptionML=[DAN=Urealiseret moms;
                                                              ENU=Unrealized VAT] }
    { 49  ;   ;Adjust for Payment Disc.;Boolean   ;OnValidate=BEGIN
                                                                IF "Adjust for Payment Disc." THEN BEGIN
                                                                  TESTFIELD("Pmt. Disc. Excl. VAT",FALSE);
                                                                  TESTFIELD("VAT Tolerance %",0);
                                                                END ELSE BEGIN
                                                                  VATPostingSetup.SETRANGE("Adjust for Payment Discount",TRUE);
                                                                  IF VATPostingSetup.FINDFIRST THEN
                                                                    ERROR(
                                                                      Text002,VATPostingSetup.TABLECAPTION,
                                                                      VATPostingSetup."VAT Bus. Posting Group",VATPostingSetup."VAT Prod. Posting Group",
                                                                      VATPostingSetup.FIELDCAPTION("Adjust for Payment Discount"));
                                                                  TaxJurisdiction.SETRANGE("Adjust for Payment Discount",TRUE);
                                                                  IF TaxJurisdiction.FINDFIRST THEN
                                                                    ERROR(
                                                                      Text003,TaxJurisdiction.TABLECAPTION,
                                                                      TaxJurisdiction.Code,TaxJurisdiction.FIELDCAPTION("Adjust for Payment Discount"));
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Reguler moms ved kontantrabat;
                                                              ENU=Adjust for Payment Disc.] }
    { 56  ;   ;Mark Cr. Memos as Corrections;Boolean;
                                                   CaptionML=[DAN=Marker kr.notaer som rettelser;
                                                              ENU=Mark Cr. Memos as Corrections] }
    { 57  ;   ;Local Address Format;Option        ;CaptionML=[DAN=Lokalt adresseformat;
                                                              ENU=Local Address Format];
                                                   OptionCaptionML=[DAN=Postnummer+by,By+postnummer,By+amt+postnummer,Tom linje+postnummer+by;
                                                                    ENU=Post Code+City,City+Post Code,City+County+Post Code,Blank Line+Post Code+City];
                                                   OptionString=Post Code+City,City+Post Code,City+County+Post Code,Blank Line+Post Code+City }
    { 58  ;   ;Inv. Rounding Precision (LCY);Decimal;
                                                   OnValidate=BEGIN
                                                                IF "Amount Rounding Precision" <> 0 THEN
                                                                  IF "Inv. Rounding Precision (LCY)" <> ROUND("Inv. Rounding Precision (LCY)","Amount Rounding Precision") THEN
                                                                    ERROR(
                                                                      Text004,
                                                                      FIELDCAPTION("Inv. Rounding Precision (LCY)"),"Amount Rounding Precision");
                                                              END;

                                                   CaptionML=[DAN=Fakturaafrundingsprëcision-RV;
                                                              ENU=Inv. Rounding Precision (LCY)];
                                                   AutoFormatType=1 }
    { 59  ;   ;Inv. Rounding Type (LCY);Option    ;CaptionML=[DAN=Fakturaafrundingsretning-RV;
                                                              ENU=Inv. Rounding Type (LCY)];
                                                   OptionCaptionML=[DAN=Nërmeste,Op,Ned;
                                                                    ENU=Nearest,Up,Down];
                                                   OptionString=Nearest,Up,Down }
    { 60  ;   ;Local Cont. Addr. Format;Option    ;InitValue=After Company Name;
                                                   CaptionML=[DAN=Personnavn;
                                                              ENU=Local Cont. Addr. Format];
                                                   OptionCaptionML=[DAN=Fõrst,Efter virks.navn,Sidst;
                                                                    ENU=First,After Company Name,Last];
                                                   OptionString=First,After Company Name,Last }
    { 63  ;   ;Bank Account Nos.   ;Code20        ;TableRelation="No. Series";
                                                   AccessByPermission=TableData 270=R;
                                                   CaptionML=[DAN=Bankkontonumre;
                                                              ENU=Bank Account Nos.] }
    { 65  ;   ;Summarize G/L Entries;Boolean      ;CaptionML=[DAN=Sammenfat finansposter;
                                                              ENU=Summarize G/L Entries] }
    { 66  ;   ;Amount Decimal Places;Text5        ;InitValue=2:2;
                                                   OnValidate=BEGIN
                                                                CheckDecimalPlacesFormat("Amount Decimal Places");
                                                              END;

                                                   CaptionML=[DAN=Belõbsdecimalpladser;
                                                              ENU=Amount Decimal Places] }
    { 67  ;   ;Unit-Amount Decimal Places;Text5   ;InitValue=2:5;
                                                   OnValidate=BEGIN
                                                                CheckDecimalPlacesFormat("Unit-Amount Decimal Places");
                                                              END;

                                                   CaptionML=[DAN=Pris-decimalpladser;
                                                              ENU=Unit-Amount Decimal Places] }
    { 68  ;   ;Additional Reporting Currency;Code10;
                                                   TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                IF ("Additional Reporting Currency" <> xRec."Additional Reporting Currency") AND
                                                                   ("Additional Reporting Currency" <> '')
                                                                THEN BEGIN
                                                                  AdjAddReportingCurr.SetAddCurr("Additional Reporting Currency");
                                                                  AdjAddReportingCurr.RUNMODAL;
                                                                  IF NOT AdjAddReportingCurr.IsExecuted THEN
                                                                    "Additional Reporting Currency" := xRec."Additional Reporting Currency";
                                                                END;
                                                                IF ("Additional Reporting Currency" <> xRec."Additional Reporting Currency") AND
                                                                   AdjAddReportingCurr.IsExecuted
                                                                THEN
                                                                  DeleteIntrastatJnl;
                                                                IF ("Additional Reporting Currency" <> xRec."Additional Reporting Currency") AND
                                                                   ("Additional Reporting Currency" <> '') AND
                                                                   AdjAddReportingCurr.IsExecuted
                                                                THEN
                                                                  DeleteAnalysisView;
                                                              END;

                                                   CaptionML=[DAN=Ekstra rapporteringsvaluta;
                                                              ENU=Additional Reporting Currency] }
    { 69  ;   ;VAT Tolerance %     ;Decimal       ;OnValidate=BEGIN
                                                                IF "VAT Tolerance %" <> 0 THEN BEGIN
                                                                  TESTFIELD("Adjust for Payment Disc.",FALSE);
                                                                  TESTFIELD("Pmt. Disc. Excl. VAT",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Momstolerance %;
                                                              ENU=VAT Tolerance %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 70  ;   ;EMU Currency        ;Boolean       ;CaptionML=[DAN=ùMU-valuta;
                                                              ENU=EMU Currency] }
    { 71  ;   ;LCY Code            ;Code10        ;OnValidate=VAR
                                                                Currency@1000 : Record 4;
                                                              BEGIN
                                                                IF "Local Currency Symbol" = '' THEN
                                                                  "Local Currency Symbol" := Currency.ResolveCurrencySymbol("LCY Code");

                                                                IF "Local Currency Description" = '' THEN
                                                                  "Local Currency Description" := COPYSTR(Currency.ResolveCurrencyDescription("LCY Code"),1,MAXSTRLEN("Local Currency Description"));
                                                              END;

                                                   CaptionML=[DAN=Regnskabsvalutakode (RV);
                                                              ENU=LCY Code] }
    { 72  ;   ;VAT Exchange Rate Adjustment;Option;CaptionML=[DAN=Valutakursregulering (moms);
                                                              ENU=VAT Exchange Rate Adjustment];
                                                   OptionCaptionML=[DAN=Ingen regulering,Regul. belõb,Regul. ekstra valutabelõb;
                                                                    ENU=No Adjustment,Adjust Amount,Adjust Additional-Currency Amount];
                                                   OptionString=No Adjustment,Adjust Amount,Adjust Additional-Currency Amount }
    { 73  ;   ;Amount Rounding Precision;Decimal  ;InitValue=0,01;
                                                   OnValidate=BEGIN
                                                                IF "Amount Rounding Precision" <> 0 THEN
                                                                  "Inv. Rounding Precision (LCY)" := ROUND("Inv. Rounding Precision (LCY)","Amount Rounding Precision");

                                                                RoundingErrorCheck(FIELDCAPTION("Amount Rounding Precision"));

                                                                IF HideDialog THEN
                                                                  MESSAGE(Text021);
                                                              END;

                                                   CaptionML=[DAN=Afrundingsprëcision;
                                                              ENU=Amount Rounding Precision];
                                                   DecimalPlaces=0:5 }
    { 74  ;   ;Unit-Amount Rounding Precision;Decimal;
                                                   InitValue=0,00001;
                                                   OnValidate=BEGIN
                                                                IF HideDialog THEN
                                                                  MESSAGE(Text022);
                                                              END;

                                                   CaptionML=[DAN=Pris - afrundingsprëcision;
                                                              ENU=Unit-Amount Rounding Precision];
                                                   DecimalPlaces=0:9 }
    { 75  ;   ;Appln. Rounding Precision;Decimal  ;CaptionML=[DAN=Udlign. afrundingsprëcision;
                                                              ENU=Appln. Rounding Precision];
                                                   MinValue=0;
                                                   AutoFormatType=1 }
    { 79  ;   ;Global Dimension 1 Code;Code20     ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                "Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                                                              END;

                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   Editable=No }
    { 80  ;   ;Global Dimension 2 Code;Code20     ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                "Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                                                              END;

                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   Editable=No }
    { 81  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation=Dimension;
                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   Editable=No }
    { 82  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation=Dimension;
                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   Editable=No }
    { 83  ;   ;Shortcut Dimension 3 Code;Code20   ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 3 Code","Shortcut Dimension 3 Code",3);
                                                              END;

                                                   AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Genvejsdimension 3-kode;
                                                              ENU=Shortcut Dimension 3 Code] }
    { 84  ;   ;Shortcut Dimension 4 Code;Code20   ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 4 Code","Shortcut Dimension 4 Code",4);
                                                              END;

                                                   AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Genvejsdimension 4-kode;
                                                              ENU=Shortcut Dimension 4 Code] }
    { 85  ;   ;Shortcut Dimension 5 Code;Code20   ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 5 Code","Shortcut Dimension 5 Code",5);
                                                              END;

                                                   AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Genvejsdimension 5-kode;
                                                              ENU=Shortcut Dimension 5 Code] }
    { 86  ;   ;Shortcut Dimension 6 Code;Code20   ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 6 Code","Shortcut Dimension 6 Code",6);
                                                              END;

                                                   AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Genvejsdimension 6-kode;
                                                              ENU=Shortcut Dimension 6 Code] }
    { 87  ;   ;Shortcut Dimension 7 Code;Code20   ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 7 Code","Shortcut Dimension 7 Code",7);
                                                              END;

                                                   AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Genvejsdimension 7-kode;
                                                              ENU=Shortcut Dimension 7 Code] }
    { 88  ;   ;Shortcut Dimension 8 Code;Code20   ;TableRelation=Dimension;
                                                   OnValidate=BEGIN
                                                                UpdateDimValueGlobalDimNo(xRec."Shortcut Dimension 8 Code","Shortcut Dimension 8 Code",8);
                                                              END;

                                                   AccessByPermission=TableData 350=R;
                                                   CaptionML=[DAN=Genvejsdimension 8-kode;
                                                              ENU=Shortcut Dimension 8 Code] }
    { 89  ;   ;Max. VAT Difference Allowed;Decimal;OnValidate=BEGIN
                                                                IF "Max. VAT Difference Allowed" <> ROUND("Max. VAT Difference Allowed") THEN
                                                                  ERROR(
                                                                    Text004,
                                                                    FIELDCAPTION("Max. VAT Difference Allowed"),"Amount Rounding Precision");

                                                                "Max. VAT Difference Allowed" := ABS("Max. VAT Difference Allowed");
                                                              END;

                                                   CaptionML=[DAN=Maks. momsdifference tilladt;
                                                              ENU=Max. VAT Difference Allowed];
                                                   AutoFormatType=1 }
    { 90  ;   ;VAT Rounding Type   ;Option        ;CaptionML=[DAN=Momsafrundingstype;
                                                              ENU=VAT Rounding Type];
                                                   OptionCaptionML=[DAN=Nërmeste,Op,Ned;
                                                                    ENU=Nearest,Up,Down];
                                                   OptionString=Nearest,Up,Down }
    { 92  ;   ;Pmt. Disc. Tolerance Posting;Option;CaptionML=[DAN=Bogf. af kont.rabattolerance;
                                                              ENU=Pmt. Disc. Tolerance Posting];
                                                   OptionCaptionML=[DAN=Betalingstolerancekonti,Kontantrabatkonti;
                                                                    ENU=Payment Tolerance Accounts,Payment Discount Accounts];
                                                   OptionString=Payment Tolerance Accounts,Payment Discount Accounts }
    { 93  ;   ;Payment Discount Grace Period;DateFormula;
                                                   CaptionML=[DAN=Kontantrabat - respitperiode;
                                                              ENU=Payment Discount Grace Period] }
    { 94  ;   ;Payment Tolerance % ;Decimal       ;CaptionML=[DAN=Betalingstolerancepct.;
                                                              ENU=Payment Tolerance %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Editable=No }
    { 95  ;   ;Max. Payment Tolerance Amount;Decimal;
                                                   CaptionML=[DAN=Maks. betalingstolerancebelõb;
                                                              ENU=Max. Payment Tolerance Amount];
                                                   MinValue=0;
                                                   Editable=No }
    { 96  ;   ;Adapt Main Menu to Permissions;Boolean;
                                                   InitValue=Yes;
                                                   CaptionML=[DAN=Tilpas hovedmenu til rettigheder;
                                                              ENU=Adapt Main Menu to Permissions] }
    { 97  ;   ;Allow G/L Acc. Deletion Before;Date;CaptionML=[DAN=Tillad sletning af finanskonti fõr;
                                                              ENU=Allow G/L Acc. Deletion Before] }
    { 98  ;   ;Check G/L Account Usage;Boolean    ;CaptionML=[DAN=Kontroller brug af finanskonto;
                                                              ENU=Check G/L Account Usage] }
    { 99  ;   ;Payment Tolerance Posting;Option   ;CaptionML=[DAN=Bogf. af betalingstolerance;
                                                              ENU=Payment Tolerance Posting];
                                                   OptionCaptionML=[DAN=Betalingstolerancekonti,Kontantrabatkonti;
                                                                    ENU=Payment Tolerance Accounts,Payment Discount Accounts];
                                                   OptionString=Payment Tolerance Accounts,Payment Discount Accounts }
    { 100 ;   ;Pmt. Disc. Tolerance Warning;Boolean;
                                                   CaptionML=[DAN=Kont.rabattolerance - advarsel;
                                                              ENU=Pmt. Disc. Tolerance Warning] }
    { 101 ;   ;Payment Tolerance Warning;Boolean  ;CaptionML=[DAN=Betalingstolerance - advarsel;
                                                              ENU=Payment Tolerance Warning] }
    { 102 ;   ;Last IC Transaction No.;Integer    ;CaptionML=[DAN=Seneste IC-transaktionsnr.;
                                                              ENU=Last IC Transaction No.] }
    { 103 ;   ;Bill-to/Sell-to VAT Calc.;Option   ;CaptionML=[DAN=Momsbrn. for fakturering/kunde;
                                                              ENU=Bill-to/Sell-to VAT Calc.];
                                                   OptionCaptionML=[DAN=Faktureres til/leverandõrnr.,kunde/leverandõrnr.;
                                                                    ENU=Bill-to/Pay-to No.,Sell-to/Buy-from No.];
                                                   OptionString=Bill-to/Pay-to No.,Sell-to/Buy-from No. }
    { 110 ;   ;Acc. Sched. for Balance Sheet;Code10;
                                                   TableRelation="Acc. Schedule Name";
                                                   CaptionML=[DAN=Kontoskema for balance;
                                                              ENU=Acc. Sched. for Balance Sheet] }
    { 111 ;   ;Acc. Sched. for Income Stmt.;Code10;TableRelation="Acc. Schedule Name";
                                                   CaptionML=[DAN=Kontoskema for resultatopgõrelse;
                                                              ENU=Acc. Sched. for Income Stmt.] }
    { 112 ;   ;Acc. Sched. for Cash Flow Stmt;Code10;
                                                   TableRelation="Acc. Schedule Name";
                                                   CaptionML=[DAN=Kontoskema for pengestrõmsopgõrelse;
                                                              ENU=Acc. Sched. for Cash Flow Stmt] }
    { 113 ;   ;Acc. Sched. for Retained Earn.;Code10;
                                                   TableRelation="Acc. Schedule Name";
                                                   CaptionML=[DAN=Kontoskema for overfõrt fra sidste Ür;
                                                              ENU=Acc. Sched. for Retained Earn.] }
    { 150 ;   ;Print VAT specification in LCY;Boolean;
                                                   CaptionML=[DAN=Udskriv momsspecifikation i RV;
                                                              ENU=Print VAT specification in LCY] }
    { 151 ;   ;Prepayment Unrealized VAT;Boolean  ;OnValidate=BEGIN
                                                                IF "Unrealized VAT" AND xRec."Prepayment Unrealized VAT" THEN
                                                                  ERROR(DependentFieldActivatedErr,FIELDCAPTION("Prepayment Unrealized VAT"),FIELDCAPTION("Unrealized VAT"));

                                                                IF NOT "Prepayment Unrealized VAT" THEN BEGIN
                                                                  VATPostingSetup.SETFILTER(
                                                                    "Unrealized VAT Type",'>=%1',VATPostingSetup."Unrealized VAT Type"::Percentage);
                                                                  IF VATPostingSetup.FINDFIRST THEN
                                                                    ERROR(
                                                                      Text000,VATPostingSetup.TABLECAPTION,
                                                                      VATPostingSetup."VAT Bus. Posting Group",VATPostingSetup."VAT Prod. Posting Group",
                                                                      VATPostingSetup.FIELDCAPTION("Unrealized VAT Type"),VATPostingSetup."Unrealized VAT Type");
                                                                  TaxJurisdiction.SETFILTER(
                                                                    "Unrealized VAT Type",'>=%1',TaxJurisdiction."Unrealized VAT Type"::Percentage);
                                                                  IF TaxJurisdiction.FINDFIRST THEN
                                                                    ERROR(
                                                                      Text001,TaxJurisdiction.TABLECAPTION,
                                                                      TaxJurisdiction.Code,TaxJurisdiction.FIELDCAPTION("Unrealized VAT Type"),
                                                                      TaxJurisdiction."Unrealized VAT Type");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Urealiseret moms ved forudbetaling;
                                                              ENU=Prepayment Unrealized VAT] }
    { 152 ;   ;Use Legacy G/L Entry Locking;Boolean;
                                                   OnValidate=VAR
                                                                InventorySetup@1000 : Record 313;
                                                              BEGIN
                                                                IF NOT "Use Legacy G/L Entry Locking" THEN BEGIN
                                                                  IF InventorySetup.GET THEN
                                                                    IF InventorySetup."Automatic Cost Posting" THEN
                                                                      ERROR(Text025,
                                                                        FIELDCAPTION("Use Legacy G/L Entry Locking"),
                                                                        "Use Legacy G/L Entry Locking",
                                                                        InventorySetup.FIELDCAPTION("Automatic Cost Posting"),
                                                                        InventorySetup.TABLECAPTION,
                                                                        InventorySetup."Automatic Cost Posting");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Brug lÜsning af ëldre finansposter;
                                                              ENU=Use Legacy G/L Entry Locking] }
    { 160 ;   ;Payroll Trans. Import Format;Code20;TableRelation="Data Exch. Def" WHERE (Type=CONST(Payroll Import));
                                                   CaptionML=[DAN=Format til import af lõntransaktion;
                                                              ENU=Payroll Trans. Import Format] }
    { 161 ;   ;VAT Reg. No. Validation URL;Text250;OnValidate=BEGIN
                                                                ERROR(ObsoleteErr);
                                                              END;

                                                   CaptionML=[DAN=URL-adresse til validering af SE/CVR-nr.;
                                                              ENU=VAT Reg. No. Validation URL] }
    { 162 ;   ;Local Currency Symbol;Text10       ;CaptionML=[DAN=Lokal valutas symbol;
                                                              ENU=Local Currency Symbol] }
    { 163 ;   ;Local Currency Description;Text60  ;CaptionML=[DAN=Beskrivelse af lokal valuta;
                                                              ENU=Local Currency Description] }
    { 164 ;   ;Show Amounts        ;Option        ;CaptionML=[DAN=Vis belõb;
                                                              ENU=Show Amounts];
                                                   OptionCaptionML=[DAN=Kun belõb,Kun debet/kredit,Alle belõb;
                                                                    ENU=Amount Only,Debit/Credit Only,All Amounts];
                                                   OptionString=Amount Only,Debit/Credit Only,All Amounts }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 %2 %3 har %4 til %5.;ENU=%1 %2 %3 have %4 to %5.';
      Text001@1001 : TextConst 'DAN=%1 %2 har %3 til %4.;ENU=%1 %2 have %3 to %4.';
      Text002@1002 : TextConst 'DAN=%1 %2 %3 bruger %4.;ENU=%1 %2 %3 use %4.';
      Text003@1003 : TextConst 'DAN=%1 %2 bruger %3.;ENU=%1 %2 use %3.';
      Text004@1004 : TextConst 'DAN=%1 skal afrundes til nërmeste %2.;ENU=%1 must be rounded to the nearest %2.';
      Text016@1013 : TextConst 'DAN="Indtast enten et eller to tal adskilt af et kolon. ";ENU="Enter one number or two numbers separated by a colon. "';
      Text017@1014 : TextConst 'DAN=Skërmhjëlpen til dette felt beskriver, hvordan feltet kan udfyldes.;ENU=The online Help for this field describes how you can fill in the field.';
      Text018@1015 : TextConst 'DAN=Du kan ikke ëndre oplysningerne i feltet %1, fordi der er bogfõrte poster.;ENU=You cannot change the contents of the %1 field because there are posted ledger entries.';
      Text021@1018 : TextConst 'DAN=Du skal lukke programmet og starte det igen for at aktivere funktionen til belõbsafrunding.;ENU=You must close the program and start again in order to activate the amount-rounding feature.';
      Text022@1019 : TextConst 'DAN=Du skal lukke programmet og starte det igen for at aktivere funktionen Pris - afrundingsprëcision.;ENU=You must close the program and start again in order to activate the unit-amount rounding feature.';
      Text023@1020 : TextConst 'DAN=%1\Du kan ikke bruge samme dimension to gange i samme opsëtning.;ENU=%1\You cannot use the same dimension twice in the same setup.';
      Dim@1021 : Record 348;
      GLEntry@1022 : Record 17;
      ItemLedgerEntry@1023 : Record 32;
      JobLedgEntry@1024 : Record 169;
      ResLedgEntry@1025 : Record 203;
      FALedgerEntry@1026 : Record 5601;
      MaintenanceLedgerEntry@1027 : Record 5625;
      InsCoverageLedgerEntry@1028 : Record 5629;
      VATPostingSetup@1029 : Record 325;
      TaxJurisdiction@1030 : Record 320;
      AnalysisView@1032 : Record 363;
      AnalysisViewEntry@1033 : Record 365;
      AnalysisViewBudgetEntry@1034 : Record 366;
      AdjAddReportingCurr@1005 : Report 86;
      ErrorMessage@1036 : Boolean;
      DependentFieldActivatedErr@1009 : TextConst 'DAN=%1 kan ikke ëndres, fordi %2 er valgt.;ENU=You cannot change %1 because %2 is selected.';
      Text025@1016 : TextConst 'DAN=Feltet %1 skal ikke angives til %2, hvis feltet %3 i tabellen %4 er angivet til %5, da der kan opstÜ deadlocks.;ENU=The field %1 should not be set to %2 if field %3 in %4 table is set to %5 because deadlocks can occur.';
      ObsoleteErr@1617 : TextConst 'DAN=Dette felt er forëldet. Det er blevet erstattes af tabel 248 SE/CVR-nr. srv.konfig.;ENU=This field is obsolete, it has been replaced by Table 248 VAT Reg. No. Srv Config.';

    [External]
    PROCEDURE CheckDecimalPlacesFormat@1(VAR DecimalPlaces@1000 : Text[5]);
    VAR
      OK@1001 : Boolean;
      ColonPlace@1002 : Integer;
      DecimalPlacesPart1@1003 : Integer;
      DecimalPlacesPart2@1004 : Integer;
      Check@1005 : Text[5];
    BEGIN
      OK := TRUE;
      ColonPlace := STRPOS(DecimalPlaces,':');

      IF ColonPlace = 0 THEN BEGIN
        IF NOT EVALUATE(DecimalPlacesPart1,DecimalPlaces) THEN
          OK := FALSE;
        IF (DecimalPlacesPart1 < 0) OR (DecimalPlacesPart1 > 9) THEN
          OK := FALSE;
      END ELSE BEGIN
        Check := COPYSTR(DecimalPlaces,1,ColonPlace - 1);
        IF Check = '' THEN
          OK := FALSE;
        IF NOT EVALUATE(DecimalPlacesPart1,Check) THEN
          OK := FALSE;
        Check := COPYSTR(DecimalPlaces,ColonPlace + 1,STRLEN(DecimalPlaces));
        IF Check = '' THEN
          OK := FALSE;
        IF NOT EVALUATE(DecimalPlacesPart2,Check) THEN
          OK := FALSE;
        IF DecimalPlacesPart1 > DecimalPlacesPart2 THEN
          OK := FALSE;
        IF (DecimalPlacesPart1 < 0) OR (DecimalPlacesPart1 > 9) THEN
          OK := FALSE;
        IF (DecimalPlacesPart2 < 0) OR (DecimalPlacesPart2 > 9) THEN
          OK := FALSE;
      END;

      IF NOT OK THEN
        ERROR(
          Text016 +
          Text017);

      IF ColonPlace = 0 THEN
        DecimalPlaces := FORMAT(DecimalPlacesPart1)
      ELSE
        DecimalPlaces := STRSUBSTNO('%1:%2',DecimalPlacesPart1,DecimalPlacesPart2);
    END;

    [External]
    PROCEDURE GetCurrencyCode@6(CurrencyCode@1000 : Code[10]) : Code[10];
    BEGIN
      CASE CurrencyCode OF
        '':
          EXIT("LCY Code");
        "LCY Code":
          EXIT('');
        ELSE
          EXIT(CurrencyCode);
      END;
    END;

    [External]
    PROCEDURE GetCurrencySymbol@8() : Text[10];
    BEGIN
      IF "Local Currency Symbol" <> '' THEN
        EXIT("Local Currency Symbol");

      EXIT("LCY Code");
    END;

    LOCAL PROCEDURE RoundingErrorCheck@2(NameOfField@1000 : Text[100]);
    BEGIN
      ErrorMessage := FALSE;
      IF GLEntry.FINDFIRST THEN
        ErrorMessage := TRUE;
      IF ItemLedgerEntry.FINDFIRST THEN
        ErrorMessage := TRUE;
      IF JobLedgEntry.FINDFIRST THEN
        ErrorMessage := TRUE;
      IF ResLedgEntry.FINDFIRST THEN
        ErrorMessage := TRUE;
      IF FALedgerEntry.FINDFIRST THEN
        ErrorMessage := TRUE;
      IF MaintenanceLedgerEntry.FINDFIRST THEN
        ErrorMessage := TRUE;
      IF InsCoverageLedgerEntry.FINDFIRST THEN
        ErrorMessage := TRUE;
      IF ErrorMessage THEN
        ERROR(
          Text018,
          NameOfField);
    END;

    LOCAL PROCEDURE DeleteIntrastatJnl@3();
    VAR
      IntrastatJnlBatch@1000 : Record 262;
      IntrastatJnlLine@1001 : Record 263;
    BEGIN
      IntrastatJnlBatch.SETRANGE(Reported,FALSE);
      IntrastatJnlBatch.SETRANGE("Amounts in Add. Currency",TRUE);
      IF IntrastatJnlBatch.FIND('-') THEN
        REPEAT
          IntrastatJnlLine.SETRANGE("Journal Template Name",IntrastatJnlBatch."Journal Template Name");
          IntrastatJnlLine.SETRANGE("Journal Batch Name",IntrastatJnlBatch.Name);
          IntrastatJnlLine.DELETEALL;
        UNTIL IntrastatJnlBatch.NEXT = 0;
    END;

    LOCAL PROCEDURE DeleteAnalysisView@33();
    BEGIN
      IF AnalysisView.FIND('-') THEN
        REPEAT
          IF AnalysisView.Blocked = FALSE THEN BEGIN
            AnalysisViewEntry.SETRANGE("Analysis View Code",AnalysisView.Code);
            AnalysisViewEntry.DELETEALL;
            AnalysisViewBudgetEntry.SETRANGE("Analysis View Code",AnalysisView.Code);
            AnalysisViewBudgetEntry.DELETEALL;
            AnalysisView."Last Entry No." := 0;
            AnalysisView."Last Budget Entry No." := 0;
            AnalysisView."Last Date Updated" := 0D;
            AnalysisView.MODIFY;
          END ELSE BEGIN
            AnalysisView."Refresh When Unblocked" := TRUE;
            AnalysisView.MODIFY;
          END;
        UNTIL AnalysisView.NEXT = 0;
    END;

    [External]
    PROCEDURE IsPostingAllowed@22(PostingDate@1000 : Date) : Boolean;
    BEGIN
      EXIT(PostingDate >= "Allow Posting From");
    END;

    [External]
    PROCEDURE OptimGLEntLockForMultiuserEnv@4() : Boolean;
    VAR
      InventorySetup@1000 : Record 313;
    BEGIN
      IF "Use Legacy G/L Entry Locking" THEN
        EXIT(FALSE);

      IF InventorySetup.GET THEN
        IF InventorySetup."Automatic Cost Posting" THEN
          EXIT(FALSE);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE FirstAllowedPostingDate@78() AllowedPostingDate : Date;
    VAR
      InvtPeriod@1000 : Record 5814;
    BEGIN
      AllowedPostingDate := "Allow Posting From";
      IF NOT InvtPeriod.IsValidDate(AllowedPostingDate) THEN
        AllowedPostingDate := CALCDATE('<+1D>',AllowedPostingDate);
    END;

    [External]
    PROCEDURE UpdateDimValueGlobalDimNo@7(xDimCode@1001 : Code[20];DimCode@1002 : Code[20];ShortcutDimNo@1003 : Integer);
    VAR
      DimensionValue@1000 : Record 349;
    BEGIN
      IF Dim.CheckIfDimUsed(DimCode,ShortcutDimNo,'','',0) THEN
        ERROR(Text023,Dim.GetCheckDimErr);
      IF xDimCode <> '' THEN BEGIN
        DimensionValue.SETRANGE("Dimension Code",xDimCode);
        DimensionValue.MODIFYALL("Global Dimension No.",0);
      END;
      IF DimCode <> '' THEN BEGIN
        DimensionValue.SETRANGE("Dimension Code",DimCode);
        DimensionValue.MODIFYALL("Global Dimension No.",ShortcutDimNo);
      END;
      MODIFY;
    END;

    LOCAL PROCEDURE HideDialog@5() : Boolean;
    BEGIN
      EXIT((CurrFieldNo = 0) OR NOT GUIALLOWED);
    END;

    PROCEDURE UseVat@9() : Boolean;
    VAR
      GeneralLedgerSetupRecordRef@1000 : RecordRef;
      UseVATFieldRef@1001 : FieldRef;
      UseVATFieldNo@1002 : Integer;
    BEGIN
      GeneralLedgerSetupRecordRef.OPEN(DATABASE::"General Ledger Setup",FALSE);

      UseVATFieldNo := 10001;

      IF NOT GeneralLedgerSetupRecordRef.FIELDEXIST(UseVATFieldNo) THEN
        EXIT(TRUE);

      IF NOT GeneralLedgerSetupRecordRef.FINDFIRST THEN
        EXIT(FALSE);

      UseVATFieldRef := GeneralLedgerSetupRecordRef.FIELD(UseVATFieldNo);
      EXIT(UseVATFieldRef.VALUE);
    END;

    BEGIN
    END.
  }
}

