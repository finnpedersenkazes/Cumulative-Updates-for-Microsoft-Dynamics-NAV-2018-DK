OBJECT Table 124 Purch. Cr. Memo Hdr.
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Buy-from Vendor Name;
    OnDelete=VAR
               PostedDeferralHeader@1000 : Record 1704;
               PostPurchDelete@1002 : Codeunit 364;
               DeferralUtilities@1001 : Codeunit 1720;
             BEGIN
               PostPurchDelete.IsDocumentDeletionAllowed("Posting Date");
               LOCKTABLE;
               PostPurchDelete.DeletePurchCrMemoLines(Rec);

               PurchCommentLine.SETRANGE("Document Type",PurchCommentLine."Document Type"::"Posted Credit Memo");
               PurchCommentLine.SETRANGE("No.","No.");
               PurchCommentLine.DELETEALL;

               ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
               PostedDeferralHeader.DeleteForDoc(DeferralUtilities.GetPurchDeferralDocType,'','',
                 PurchCommentLine."Document Type"::"Posted Credit Memo","No.");
             END;

    CaptionML=[DAN=Kõbskreditnotahoved;
               ENU=Purch. Cr. Memo Hdr.];
    LookupPageID=Page147;
    DrillDownPageID=Page147;
  }
  FIELDS
  {
    { 2   ;   ;Buy-from Vendor No. ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Leverandõrnr.;
                                                              ENU=Buy-from Vendor No.];
                                                   NotBlank=Yes }
    { 3   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 4   ;   ;Pay-to Vendor No.   ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Faktureringsleverandõrnr.;
                                                              ENU=Pay-to Vendor No.];
                                                   NotBlank=Yes }
    { 5   ;   ;Pay-to Name         ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Pay-to Name] }
    { 6   ;   ;Pay-to Name 2       ;Text50        ;CaptionML=[DAN=Navn 2;
                                                              ENU=Pay-to Name 2] }
    { 7   ;   ;Pay-to Address      ;Text50        ;CaptionML=[DAN=Adresse;
                                                              ENU=Pay-to Address] }
    { 8   ;   ;Pay-to Address 2    ;Text50        ;CaptionML=[DAN=Adresse 2;
                                                              ENU=Pay-to Address 2] }
    { 9   ;   ;Pay-to City         ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=Pay-to City] }
    { 10  ;   ;Pay-to Contact      ;Text50        ;CaptionML=[DAN=Attention;
                                                              ENU=Pay-to Contact] }
    { 11  ;   ;Your Reference      ;Text35        ;CaptionML=[DAN=Reference;
                                                              ENU=Your Reference] }
    { 12  ;   ;Ship-to Code        ;Code10        ;TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(Sell-to Customer No.));
                                                   CaptionML=[DAN=Leveringsadressekode;
                                                              ENU=Ship-to Code] }
    { 13  ;   ;Ship-to Name        ;Text50        ;CaptionML=[DAN=Leveringsnavn;
                                                              ENU=Ship-to Name] }
    { 14  ;   ;Ship-to Name 2      ;Text50        ;CaptionML=[DAN=Leveringsnavn 2;
                                                              ENU=Ship-to Name 2] }
    { 15  ;   ;Ship-to Address     ;Text50        ;CaptionML=[DAN=Leveringsadresse;
                                                              ENU=Ship-to Address] }
    { 16  ;   ;Ship-to Address 2   ;Text50        ;CaptionML=[DAN=Leveringsadresse 2;
                                                              ENU=Ship-to Address 2] }
    { 17  ;   ;Ship-to City        ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Leveringsby;
                                                              ENU=Ship-to City] }
    { 18  ;   ;Ship-to Contact     ;Text50        ;CaptionML=[DAN=Leveres attention;
                                                              ENU=Ship-to Contact] }
    { 20  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 21  ;   ;Expected Receipt Date;Date         ;CaptionML=[DAN=Forventet modt.dato;
                                                              ENU=Expected Receipt Date] }
    { 22  ;   ;Posting Description ;Text50        ;CaptionML=[DAN=Bogfõringsbeskrivelse;
                                                              ENU=Posting Description] }
    { 23  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   CaptionML=[DAN=Betalingsbeting.kode;
                                                              ENU=Payment Terms Code] }
    { 24  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 25  ;   ;Payment Discount %  ;Decimal       ;CaptionML=[DAN=Kontantrabatpct.;
                                                              ENU=Payment Discount %];
                                                   DecimalPlaces=0:5 }
    { 26  ;   ;Pmt. Discount Date  ;Date          ;CaptionML=[DAN=Kont.rabatdato;
                                                              ENU=Pmt. Discount Date] }
    { 27  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   CaptionML=[DAN=Leveringskode;
                                                              ENU=Shipment Method Code] }
    { 28  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 29  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 30  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 31  ;   ;Vendor Posting Group;Code20        ;TableRelation="Vendor Posting Group";
                                                   CaptionML=[DAN=Kreditorbogfõringsgruppe;
                                                              ENU=Vendor Posting Group];
                                                   Editable=No }
    { 32  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code];
                                                   Editable=No }
    { 33  ;   ;Currency Factor     ;Decimal       ;CaptionML=[DAN=Valutafaktor;
                                                              ENU=Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0 }
    { 35  ;   ;Prices Including VAT;Boolean       ;CaptionML=[DAN=Priser inkl. moms;
                                                              ENU=Prices Including VAT] }
    { 37  ;   ;Invoice Disc. Code  ;Code20        ;CaptionML=[DAN=Fakturarabatkode;
                                                              ENU=Invoice Disc. Code] }
    { 41  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 43  ;   ;Purchaser Code      ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Indkõberkode;
                                                              ENU=Purchaser Code] }
    { 46  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Purch. Comment Line" WHERE (Document Type=CONST(Posted Credit Memo),
                                                                                                  No.=FIELD(No.),
                                                                                                  Document Line No.=CONST(0)));
                                                   CaptionML=[DAN=Bemërkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 47  ;   ;No. Printed         ;Integer       ;CaptionML=[DAN=Udskrevet;
                                                              ENU=No. Printed];
                                                   Editable=No }
    { 51  ;   ;On Hold             ;Code3         ;CaptionML=[DAN=Afvent;
                                                              ENU=On Hold] }
    { 52  ;   ;Applies-to Doc. Type;Option        ;CaptionML=[DAN=Udligningsbilagstype;
                                                              ENU=Applies-to Doc. Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 53  ;   ;Applies-to Doc. No. ;Code20        ;OnLookup=BEGIN
                                                              VendLedgEntry.SETCURRENTKEY("Document No.");
                                                              VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                                                              VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                                                              PAGE.RUN(0,VendLedgEntry);
                                                            END;

                                                   CaptionML=[DAN=Udligningsbilagsnr.;
                                                              ENU=Applies-to Doc. No.] }
    { 55  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 60  ;   ;Amount              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purch. Cr. Memo Line".Amount WHERE (Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Amount Including VAT;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purch. Cr. Memo Line"."Amount Including VAT" WHERE (Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Belõb inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 69  ;   ;Vendor Cr. Memo No. ;Code35        ;CaptionML=[DAN=Kreditors kr.notanr.;
                                                              ENU=Vendor Cr. Memo No.] }
    { 70  ;   ;VAT Registration No.;Text20        ;CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
    { 72  ;   ;Sell-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.] }
    { 73  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 74  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 76  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   CaptionML=[DAN=Transaktionsart;
                                                              ENU=Transaction Type] }
    { 77  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   CaptionML=[DAN=TransportmÜde;
                                                              ENU=Transport Method] }
    { 78  ;   ;VAT Country/Region Code;Code10     ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode for moms;
                                                              ENU=VAT Country/Region Code] }
    { 79  ;   ;Buy-from Vendor Name;Text50        ;CaptionML=[DAN=Leverandõrnavn;
                                                              ENU=Buy-from Vendor Name] }
    { 80  ;   ;Buy-from Vendor Name 2;Text50      ;CaptionML=[DAN=Leverandõrnavn 2;
                                                              ENU=Buy-from Vendor Name 2] }
    { 81  ;   ;Buy-from Address    ;Text50        ;CaptionML=[DAN=Leverandõradresse;
                                                              ENU=Buy-from Address] }
    { 82  ;   ;Buy-from Address 2  ;Text50        ;CaptionML=[DAN=Leverandõradresse 2;
                                                              ENU=Buy-from Address 2] }
    { 83  ;   ;Buy-from City       ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Leverandõrby;
                                                              ENU=Buy-from City] }
    { 84  ;   ;Buy-from Contact    ;Text50        ;CaptionML=[DAN=Leverandõrattention;
                                                              ENU=Buy-from Contact] }
    { 85  ;   ;Pay-to Post Code    ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Pay-to Post Code] }
    { 86  ;   ;Pay-to County       ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=Pay-to County] }
    { 87  ;   ;Pay-to Country/Region Code;Code10  ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode til fakturering;
                                                              ENU=Pay-to Country/Region Code] }
    { 88  ;   ;Buy-from Post Code  ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Leverandõrpostnr.;
                                                              ENU=Buy-from Post Code] }
    { 89  ;   ;Buy-from County     ;Text30        ;CaptionML=[DAN=Leverandõramt;
                                                              ENU=Buy-from County] }
    { 90  ;   ;Buy-from Country/Region Code;Code10;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode for leverandõr;
                                                              ENU=Buy-from Country/Region Code] }
    { 91  ;   ;Ship-to Post Code   ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Leveringspostnr.;
                                                              ENU=Ship-to Post Code] }
    { 92  ;   ;Ship-to County      ;Text30        ;CaptionML=[DAN=Leveringsamt;
                                                              ENU=Ship-to County] }
    { 93  ;   ;Ship-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode for levering;
                                                              ENU=Ship-to Country/Region Code] }
    { 94  ;   ;Bal. Account Type   ;Option        ;CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Bankkonto;
                                                                    ENU=G/L Account,Bank Account];
                                                   OptionString=G/L Account,Bank Account }
    { 95  ;   ;Order Address Code  ;Code10        ;TableRelation="Order Address".Code WHERE (Vendor No.=FIELD(Buy-from Vendor No.));
                                                   CaptionML=[DAN=Bestillingsadressekode;
                                                              ENU=Order Address Code] }
    { 97  ;   ;Entry Point         ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=[DAN=Indfõrselssted;
                                                              ENU=Entry Point] }
    { 98  ;   ;Correction          ;Boolean       ;CaptionML=[DAN=Rettelse;
                                                              ENU=Correction] }
    { 99  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 101 ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=[DAN=OmrÜde;
                                                              ENU=Area] }
    { 102 ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 104 ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   CaptionML=[DAN=Betalingsformskode;
                                                              ENU=Payment Method Code] }
    { 107 ;   ;Pre-Assigned No. Series;Code20     ;TableRelation="No. Series";
                                                   CaptionML=[DAN=ForhÜndstildelt nr.serie;
                                                              ENU=Pre-Assigned No. Series] }
    { 108 ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 111 ;   ;Pre-Assigned No.    ;Code20        ;CaptionML=[DAN=ForhÜndstildelt nr.;
                                                              ENU=Pre-Assigned No.] }
    { 112 ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 113 ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 114 ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=SkatteomrÜdekode;
                                                              ENU=Tax Area Code] }
    { 115 ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 116 ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 119 ;   ;VAT Base Discount % ;Decimal       ;CaptionML=[DAN=Momsgrundlagsrabat %;
                                                              ENU=VAT Base Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 138 ;   ;Prepmt. Cr. Memo No. Series;Code20 ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie til forudbetalingskreditnota;
                                                              ENU=Prepmt. Cr. Memo No. Series] }
    { 140 ;   ;Prepayment Credit Memo;Boolean     ;CaptionML=[DAN=Forudbetalingskreditnota;
                                                              ENU=Prepayment Credit Memo] }
    { 141 ;   ;Prepayment Order No.;Code20        ;CaptionML=[DAN=Ordrenr. til forudbetaling;
                                                              ENU=Prepayment Order No.] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 1302;   ;Paid                ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=-Exist("Vendor Ledger Entry" WHERE (Entry No.=FIELD(Vendor Ledger Entry No.),
                                                                                                   Open=FILTER(Yes)));
                                                   CaptionML=[DAN=Betalt;
                                                              ENU=Paid];
                                                   Editable=No }
    { 1303;   ;Remaining Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor Ledger Entry No.=FIELD(Vendor Ledger Entry No.)));
                                                   CaptionML=[DAN=Restbelõb;
                                                              ENU=Remaining Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1304;   ;Vendor Ledger Entry No.;Integer    ;TableRelation="Vendor Ledger Entry"."Entry No.";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kreditorlõbenr.;
                                                              ENU=Vendor Ledger Entry No.];
                                                   Editable=No }
    { 1305;   ;Invoice Discount Amount;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purch. Cr. Memo Line"."Inv. Discount Amount" WHERE (Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Fakturarabatbelõb;
                                                              ENU=Invoice Discount Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1310;   ;Cancelled           ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Cancelled Document" WHERE (Source ID=CONST(124),
                                                                                                 Cancelled Doc. No.=FIELD(No.)));
                                                   CaptionML=[DAN=Annulleret;
                                                              ENU=Cancelled];
                                                   Editable=No }
    { 1311;   ;Corrective          ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Cancelled Document" WHERE (Source ID=CONST(122),
                                                                                                 Cancelled By Doc. No.=FIELD(No.)));
                                                   CaptionML=[DAN=Korrigerende;
                                                              ENU=Corrective];
                                                   Editable=No }
    { 5050;   ;Campaign No.        ;Code20        ;TableRelation=Campaign;
                                                   CaptionML=[DAN=Kampagnenr.;
                                                              ENU=Campaign No.] }
    { 5052;   ;Buy-from Contact No.;Code20        ;TableRelation=Contact;
                                                   CaptionML=[DAN=Leverandõrattentionnr.;
                                                              ENU=Buy-from Contact No.] }
    { 5053;   ;Pay-to Contact No.  ;Code20        ;TableRelation=Contact;
                                                   CaptionML=[DAN=Faktureringsleverandõr - attentionsnr.;
                                                              ENU=Pay-to Contact No.] }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 6601;   ;Return Order No.    ;Code20        ;AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Returvareordrenr.;
                                                              ENU=Return Order No.] }
    { 6602;   ;Return Order No. Series;Code20     ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Returvareordrenr.serie;
                                                              ENU=Return Order No. Series] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Pre-Assigned No.                         }
    {    ;Vendor Cr. Memo No.,Posting Date         }
    {    ;Return Order No.                         }
    {    ;Buy-from Vendor No.                      }
    {    ;Prepayment Order No.                     }
    {    ;Pay-to Vendor No.                        }
    {    ;Posting Date                             }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Buy-from Vendor No.,Pay-to Vendor No.,Posting Date,Posting Description }
  }
  CODE
  {
    VAR
      PurchCrMemoHeader@1000 : Record 124;
      PurchCommentLine@1001 : Record 43;
      VendLedgEntry@1002 : Record 25;
      DimMgt@1004 : Codeunit 408;
      ApprovalsMgmt@1008 : Codeunit 1535;
      UserSetupMgt@1005 : Codeunit 5700;

    [External]
    PROCEDURE PrintRecords@1(ShowRequestForm@1000 : Boolean);
    VAR
      ReportSelection@1001 : Record 77;
    BEGIN
      WITH PurchCrMemoHeader DO BEGIN
        COPY(Rec);
        ReportSelection.PrintWithGUIYesNoVendor(
          ReportSelection.Usage::"P.Cr.Memo",PurchCrMemoHeader,ShowRequestForm,FIELDNO("Buy-from Vendor No."));
      END;
    END;

    [External]
    PROCEDURE Navigate@2();
    VAR
      NavigateForm@1000 : Page 344;
    BEGIN
      NavigateForm.SetDoc("Posting Date","No.");
      NavigateForm.RUN;
    END;

    [External]
    PROCEDURE ShowDimensions@3();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
    END;

    [External]
    PROCEDURE SetSecurityFilterOnRespCenter@4();
    BEGIN
      IF UserSetupMgt.GetPurchasesFilter <> '' THEN BEGIN
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserSetupMgt.GetPurchasesFilter);
        FILTERGROUP(0);
      END;
    END;

    [External]
    PROCEDURE ShowCanceledOrCorrInvoice@6();
    BEGIN
      CALCFIELDS(Cancelled,Corrective);
      CASE TRUE OF
        Cancelled:
          ShowCorrectiveInvoice;
        Corrective:
          ShowCancelledInvoice;
      END;
    END;

    [External]
    PROCEDURE ShowCorrectiveInvoice@16();
    VAR
      CancelledDocument@1000 : Record 1900;
      PurchInvHeader@1001 : Record 122;
    BEGIN
      CALCFIELDS(Cancelled);
      IF NOT Cancelled THEN
        EXIT;

      IF CancelledDocument.FindPurchCancelledCrMemo("No.") THEN BEGIN
        PurchInvHeader.GET(CancelledDocument."Cancelled By Doc. No.");
        PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
      END;
    END;

    [External]
    PROCEDURE ShowCancelledInvoice@5();
    VAR
      CancelledDocument@1000 : Record 1900;
      PurchInvHeader@1001 : Record 122;
    BEGIN
      CALCFIELDS(Corrective);
      IF NOT Corrective THEN
        EXIT;

      IF CancelledDocument.FindPurchCorrectiveCrMemo("No.") THEN BEGIN
        PurchInvHeader.GET(CancelledDocument."Cancelled Doc. No.");
        PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
      END;
    END;

    BEGIN
    END.
  }
}

