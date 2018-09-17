OBJECT Table 5109 Purchase Header Archive
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Buy-from Vendor Name,Version No.;
    OnDelete=VAR
               PurchaseLineArchive@1001 : Record 5110;
               DeferralHeaderArchive@1000 : Record 5127;
               DeferralUtilities@1002 : Codeunit 1720;
             BEGIN
               PurchaseLineArchive.SETRANGE("Document Type","Document Type");
               PurchaseLineArchive.SETRANGE("Document No.","No.");
               PurchaseLineArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               PurchaseLineArchive.SETRANGE("Version No.","Version No.");
               PurchaseLineArchive.DELETEALL;

               PurchCommentLineArch.SETRANGE("Document Type","Document Type");
               PurchCommentLineArch.SETRANGE("No.","No.");
               PurchCommentLineArch.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               PurchCommentLineArch.SETRANGE("Version No.","Version No.");
               PurchCommentLineArch.DELETEALL;

               DeferralHeaderArchive.SETRANGE("Deferral Doc. Type",DeferralUtilities.GetPurchDeferralDocType);
               DeferralHeaderArchive.SETRANGE("Document Type","Document Type");
               DeferralHeaderArchive.SETRANGE("Document No.","No.");
               DeferralHeaderArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               DeferralHeaderArchive.SETRANGE("Version No.","Version No.");
               DeferralHeaderArchive.DELETEALL(TRUE);
             END;

    CaptionML=[DAN=Kõbshovedarkiv;
               ENU=Purchase Header Archive];
    LookupPageID=Page5166;
    DrillDownPageID=Page5166;
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota,Rammeordre,Returv.ordre;
                                                                    ENU=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order];
                                                   OptionString=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order }
    { 2   ;   ;Buy-from Vendor No. ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Leverandõrnr.;
                                                              ENU=Buy-from Vendor No.] }
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
    { 12  ;   ;Ship-to Code        ;Code10        ;CaptionML=[DAN=Leveringsadressekode;
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
    { 19  ;   ;Order Date          ;Date          ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Ordredato;
                                                              ENU=Order Date] }
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
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
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
                                                              ENU=Vendor Posting Group] }
    { 32  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
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
    { 45  ;   ;Order Class         ;Code10        ;CaptionML=[DAN=Ordregruppe;
                                                              ENU=Order Class] }
    { 46  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Purch. Comment Line Archive" WHERE (Document Type=FIELD(Document Type),
                                                                                                          No.=FIELD(No.),
                                                                                                          Document Line No.=CONST(0),
                                                                                                          Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                                                          Version No.=FIELD(Version No.)));
                                                   CaptionML=[DAN=Bemërkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 47  ;   ;No. Printed         ;Integer       ;CaptionML=[DAN=Udskrevet;
                                                              ENU=No. Printed] }
    { 51  ;   ;On Hold             ;Code3         ;CaptionML=[DAN=Afvent;
                                                              ENU=On Hold] }
    { 52  ;   ;Applies-to Doc. Type;Option        ;CaptionML=[DAN=Udligningsbilagstype;
                                                              ENU=Applies-to Doc. Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 53  ;   ;Applies-to Doc. No. ;Code20        ;CaptionML=[DAN=Udligningsbilagsnr.;
                                                              ENU=Applies-to Doc. No.] }
    { 55  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 57  ;   ;Receive             ;Boolean       ;CaptionML=[DAN=Modtag;
                                                              ENU=Receive] }
    { 58  ;   ;Invoice             ;Boolean       ;CaptionML=[DAN=Fakturer;
                                                              ENU=Invoice] }
    { 60  ;   ;Amount              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line Archive".Amount WHERE (Document Type=FIELD(Document Type),
                                                                                                         Document No.=FIELD(No.),
                                                                                                         Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                                                         Version No.=FIELD(Version No.)));
                                                   CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Amount Including VAT;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line Archive"."Amount Including VAT" WHERE (Document Type=FIELD(Document Type),
                                                                                                                         Document No.=FIELD(No.),
                                                                                                                         Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                                                                         Version No.=FIELD(Version No.)));
                                                   CaptionML=[DAN=Belõb inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 62  ;   ;Receiving No.       ;Code20        ;CaptionML=[DAN=Kõbslev.nr.;
                                                              ENU=Receiving No.] }
    { 63  ;   ;Posting No.         ;Code20        ;CaptionML=[DAN=Tildelt fakturanr.;
                                                              ENU=Posting No.] }
    { 64  ;   ;Last Receiving No.  ;Code20        ;TableRelation="Purch. Rcpt. Header";
                                                   CaptionML=[DAN=Sidste kõbslev.nr.;
                                                              ENU=Last Receiving No.] }
    { 65  ;   ;Last Posting No.    ;Code20        ;TableRelation="Purch. Inv. Header";
                                                   CaptionML=[DAN=Sidste fakturanr.;
                                                              ENU=Last Posting No.] }
    { 66  ;   ;Vendor Order No.    ;Code35        ;CaptionML=[DAN=Kreditors ordrenr.;
                                                              ENU=Vendor Order No.] }
    { 67  ;   ;Vendor Shipment No. ;Code35        ;CaptionML=[DAN=Kreditors lev.nr.;
                                                              ENU=Vendor Shipment No.] }
    { 68  ;   ;Vendor Invoice No.  ;Code35        ;CaptionML=[DAN=Kreditors fakturanr.;
                                                              ENU=Vendor Invoice No.] }
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
    { 107 ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 108 ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogfõringsnummerserie;
                                                              ENU=Posting No. Series] }
    { 109 ;   ;Receiving No. Series;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Kõbslev. nummerserie;
                                                              ENU=Receiving No. Series] }
    { 114 ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=SkatteomrÜdekode;
                                                              ENU=Tax Area Code] }
    { 115 ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 116 ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 118 ;   ;Applies-to ID       ;Code50        ;CaptionML=[DAN=Udlignings-id;
                                                              ENU=Applies-to ID] }
    { 119 ;   ;VAT Base Discount % ;Decimal       ;CaptionML=[DAN=Momsgrundlagsrabat %;
                                                              ENU=VAT Base Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 120 ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=èben,Frigivet,Afventer godkendelse,Afventer forudbetaling;
                                                                    ENU=Open,Released,Pending Approval,Pending Prepayment];
                                                   OptionString=Open,Released,Pending Approval,Pending Prepayment }
    { 121 ;   ;Invoice Discount Calculation;Option;CaptionML=[DAN=Beregning af fakturarabat;
                                                              ENU=Invoice Discount Calculation];
                                                   OptionCaptionML=[DAN=Ingen,%,Belõb;
                                                                    ENU=None,%,Amount];
                                                   OptionString=None,%,Amount }
    { 122 ;   ;Invoice Discount Value;Decimal     ;CaptionML=[DAN=Fakturarabatvërdi;
                                                              ENU=Invoice Discount Value];
                                                   AutoFormatType=1 }
    { 123 ;   ;Send IC Document    ;Boolean       ;CaptionML=[DAN=Send IC-dokument;
                                                              ENU=Send IC Document] }
    { 124 ;   ;IC Status           ;Option        ;CaptionML=[DAN=IC-status;
                                                              ENU=IC Status];
                                                   OptionCaptionML=[DAN=Ny,Ventende,Sendt;
                                                                    ENU=New,Pending,Sent];
                                                   OptionString=New,Pending,Sent }
    { 125 ;   ;Buy-from IC Partner Code;Code20    ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=Leverandõrkode for IC-partner;
                                                              ENU=Buy-from IC Partner Code];
                                                   Editable=No }
    { 126 ;   ;Pay-to IC Partner Code;Code20      ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=Fakt.kode for IC-partner;
                                                              ENU=Pay-to IC Partner Code];
                                                   Editable=No }
    { 129 ;   ;IC Direction        ;Option        ;CaptionML=[DAN=IC-retning;
                                                              ENU=IC Direction];
                                                   OptionCaptionML=[DAN=UdgÜende,IndgÜende;
                                                                    ENU=Outgoing,Incoming];
                                                   OptionString=Outgoing,Incoming }
    { 130 ;   ;Prepayment No.      ;Code20        ;CaptionML=[DAN=Forudbetalingsnr.;
                                                              ENU=Prepayment No.] }
    { 131 ;   ;Last Prepayment No. ;Code20        ;TableRelation="Sales Invoice Header";
                                                   CaptionML=[DAN=Sidste forudbetalingsnr.;
                                                              ENU=Last Prepayment No.] }
    { 132 ;   ;Prepmt. Cr. Memo No.;Code20        ;CaptionML=[DAN=Forudbetalingskreditnota nr.;
                                                              ENU=Prepmt. Cr. Memo No.] }
    { 133 ;   ;Last Prepmt. Cr. Memo No.;Code20   ;TableRelation="Sales Invoice Header";
                                                   CaptionML=[DAN=Sidste forudbetalingskreditnota nr.;
                                                              ENU=Last Prepmt. Cr. Memo No.] }
    { 134 ;   ;Prepayment %        ;Decimal       ;CaptionML=[DAN=Forudbetaling i %;
                                                              ENU=Prepayment %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 135 ;   ;Prepayment No. Series;Code20       ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Forudbetalingsnummerserie;
                                                              ENU=Prepayment No. Series] }
    { 136 ;   ;Compress Prepayment ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Komprimer forudbetaling;
                                                              ENU=Compress Prepayment] }
    { 137 ;   ;Prepayment Due Date ;Date          ;CaptionML=[DAN=Forfaldsdato for forudbetaling;
                                                              ENU=Prepayment Due Date] }
    { 138 ;   ;Prepmt. Cr. Memo No. Series;Code20 ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie til forudbetalingskreditnota;
                                                              ENU=Prepmt. Cr. Memo No. Series] }
    { 139 ;   ;Prepmt. Posting Description;Text50 ;CaptionML=[DAN=Beskrivelse af bogfõrt forudbetaling;
                                                              ENU=Prepmt. Posting Description] }
    { 142 ;   ;Prepmt. Pmt. Discount Date;Date    ;CaptionML=[DAN=Forudb. - dato for kont.rabat;
                                                              ENU=Prepmt. Pmt. Discount Date] }
    { 143 ;   ;Prepmt. Payment Terms Code;Code10  ;TableRelation="Payment Terms";
                                                   CaptionML=[DAN=Forudb. - kode for betal.betingelser;
                                                              ENU=Prepmt. Payment Terms Code] }
    { 144 ;   ;Prepmt. Payment Discount %;Decimal ;CaptionML=[DAN=Forudb. - kontantrabat i %;
                                                              ENU=Prepmt. Payment Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 145 ;   ;No. of Archived Versions;Integer   ;FieldClass=FlowField;
                                                   CalcFormula=Max("Purchase Header Archive"."Version No." WHERE (Document Type=FIELD(Document Type),
                                                                                                                  No.=FIELD(No.),
                                                                                                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence)));
                                                   CaptionML=[DAN=Antal arkiverede versioner;
                                                              ENU=No. of Archived Versions];
                                                   Editable=No }
    { 151 ;   ;Purchase Quote No.  ;Code20        ;TableRelation="Purchase Header".No. WHERE (Document Type=CONST(Quote),
                                                                                              No.=FIELD(Purchase Quote No.));
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kõbsrekvisitionsnr.;
                                                              ENU=Purchase Quote No.];
                                                   Editable=No }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 5043;   ;Interaction Exist   ;Boolean       ;CaptionML=[DAN=Interaktion findes;
                                                              ENU=Interaction Exist] }
    { 5044;   ;Time Archived       ;Time          ;CaptionML=[DAN=Arkiveringstidspunkt;
                                                              ENU=Time Archived] }
    { 5045;   ;Date Archived       ;Date          ;CaptionML=[DAN=Arkiveringsdato;
                                                              ENU=Date Archived] }
    { 5046;   ;Archived By         ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Archived By");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Arkiveret af;
                                                              ENU=Archived By];
                                                   Editable=No }
    { 5047;   ;Version No.         ;Integer       ;CaptionML=[DAN=Versionsnr.;
                                                              ENU=Version No.] }
    { 5048;   ;Doc. No. Occurrence ;Integer       ;CaptionML=[DAN=Forekomster af dok.nr.;
                                                              ENU=Doc. No. Occurrence] }
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
    { 5752;   ;Completely Received ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Min("Purchase Line Archive"."Completely Received" WHERE (Document Type=FIELD(Document Type),
                                                                                                                        Document No.=FIELD(No.),
                                                                                                                        Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                                                                        Version No.=FIELD(Version No.),
                                                                                                                        Expected Receipt Date=FIELD(Date Filter),
                                                                                                                        Location Code=FIELD(Location Filter)));
                                                   CaptionML=[DAN=Modtagelse komplet;
                                                              ENU=Completely Received];
                                                   Editable=No }
    { 5753;   ;Posting from Whse. Ref.;Integer    ;CaptionML=[DAN=Bogfõring fra lagerref.;
                                                              ENU=Posting from Whse. Ref.] }
    { 5754;   ;Location Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Location;
                                                   CaptionML=[DAN=Lokationsfilter;
                                                              ENU=Location Filter] }
    { 5790;   ;Requested Receipt Date;Date        ;AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=ùnsket modtagelsesdato;
                                                              ENU=Requested Receipt Date] }
    { 5791;   ;Promised Receipt Date;Date         ;CaptionML=[DAN=Bekrëftet modtagelsesdato;
                                                              ENU=Promised Receipt Date] }
    { 5792;   ;Lead Time Calculation;DateFormula  ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Leveringstid;
                                                              ENU=Lead Time Calculation] }
    { 5793;   ;Inbound Whse. Handling Time;DateFormula;
                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=IndgÜende lagerekspeditionstid;
                                                              ENU=Inbound Whse. Handling Time] }
    { 5796;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 5800;   ;Vendor Authorization No.;Code35    ;CaptionML=[DAN=Leverandõrautorisationsnr.;
                                                              ENU=Vendor Authorization No.] }
    { 5801;   ;Return Shipment No. ;Code20        ;CaptionML=[DAN=Returvareleverancenr.;
                                                              ENU=Return Shipment No.] }
    { 5802;   ;Return Shipment No. Series;Code20  ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Returvarelev.nummerserie;
                                                              ENU=Return Shipment No. Series] }
    { 5803;   ;Ship                ;Boolean       ;CaptionML=[DAN=Lever;
                                                              ENU=Ship] }
    { 5804;   ;Last Return Shipment No.;Code20    ;TableRelation="Return Shipment Header";
                                                   CaptionML=[DAN=Sidste returvareleverancenr.;
                                                              ENU=Last Return Shipment No.] }
    { 9000;   ;Assigned User ID    ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
  }
  KEYS
  {
    {    ;Document Type,No.,Doc. No. Occurrence,Version No.;
                                                   Clustered=Yes }
    {    ;Document Type,Buy-from Vendor No.        }
    {    ;Document Type,Pay-to Vendor No.          }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      PurchCommentLineArch@1001 : Record 5125;
      DimMgt@1002 : Codeunit 408;
      UserSetupMgt@1000 : Codeunit 5700;

    [External]
    PROCEDURE ShowDimensions@1();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","No."));
    END;

    [External]
    PROCEDURE SetSecurityFilterOnRespCenter@5();
    BEGIN
      IF UserSetupMgt.GetPurchasesFilter <> '' THEN BEGIN
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserSetupMgt.GetPurchasesFilter);
        FILTERGROUP(0);
      END;
    END;

    BEGIN
    END.
  }
}

