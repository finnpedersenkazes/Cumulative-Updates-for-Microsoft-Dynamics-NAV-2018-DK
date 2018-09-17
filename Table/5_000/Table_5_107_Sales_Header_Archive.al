OBJECT Table 5107 Sales Header Archive
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783,NAVDK11.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Sell-to Customer Name,Version No.;
    OnDelete=VAR
               SalesLineArchive@1000 : Record 5108;
               DeferralHeaderArchive@1001 : Record 5127;
               NonstockItemMgt@1002 : Codeunit 5703;
               DeferralUtilities@1003 : Codeunit 1720;
             BEGIN
               SalesLineArchive.SETRANGE("Document Type","Document Type");
               SalesLineArchive.SETRANGE("Document No.","No.");
               SalesLineArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               SalesLineArchive.SETRANGE("Version No.","Version No.");
               SalesLineArchive.SETRANGE(Nonstock,TRUE);
               IF SalesLineArchive.FINDSET(TRUE) THEN
                 REPEAT
                   NonstockItemMgt.DelNonStockSalesArch(SalesLineArchive);
                 UNTIL SalesLineArchive.NEXT = 0;
               SalesLineArchive.SETRANGE(Nonstock);
               SalesLineArchive.DELETEALL;

               SalesCommentLineArch.SETRANGE("Document Type","Document Type");
               SalesCommentLineArch.SETRANGE("No.","No.");
               SalesCommentLineArch.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               SalesCommentLineArch.SETRANGE("Version No.","Version No.");
               SalesCommentLineArch.DELETEALL;

               DeferralHeaderArchive.SETRANGE("Deferral Doc. Type",DeferralUtilities.GetSalesDeferralDocType);
               DeferralHeaderArchive.SETRANGE("Document Type","Document Type");
               DeferralHeaderArchive.SETRANGE("Document No.","No.");
               DeferralHeaderArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               DeferralHeaderArchive.SETRANGE("Version No.","Version No.");
               DeferralHeaderArchive.DELETEALL(TRUE);
             END;

    CaptionML=[DAN=Salgshovedarkiv;
               ENU=Sales Header Archive];
    LookupPageID=Page5161;
    DrillDownPageID=Page5161;
  }
  FIELDS
  {
    { 1   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=Tilbud,Ordre,Faktura,Kreditnota,Rammeordre,Returv.ordre;
                                                                    ENU=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order];
                                                   OptionString=Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order }
    { 2   ;   ;Sell-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.] }
    { 3   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 4   ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.];
                                                   NotBlank=Yes }
    { 5   ;   ;Bill-to Name        ;Text50        ;CaptionML=[DAN=Faktureringsnavn;
                                                              ENU=Bill-to Name] }
    { 6   ;   ;Bill-to Name 2      ;Text50        ;CaptionML=[DAN=Faktureringsnavn 2;
                                                              ENU=Bill-to Name 2] }
    { 7   ;   ;Bill-to Address     ;Text50        ;CaptionML=[DAN=Faktureringsadresse;
                                                              ENU=Bill-to Address] }
    { 8   ;   ;Bill-to Address 2   ;Text50        ;CaptionML=[DAN=Faktureringsadresse 2;
                                                              ENU=Bill-to Address 2] }
    { 9   ;   ;Bill-to City        ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Faktureringsby;
                                                              ENU=Bill-to City] }
    { 10  ;   ;Bill-to Contact     ;Text50        ;CaptionML=[DAN=Faktureres attention;
                                                              ENU=Bill-to Contact] }
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
    { 19  ;   ;Order Date          ;Date          ;CaptionML=[DAN=Ordredato;
                                                              ENU=Order Date] }
    { 20  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 21  ;   ;Shipment Date       ;Date          ;CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
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
    { 31  ;   ;Customer Posting Group;Code20      ;TableRelation="Customer Posting Group";
                                                   CaptionML=[DAN=Debitorbogfõringsgruppe;
                                                              ENU=Customer Posting Group] }
    { 32  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 33  ;   ;Currency Factor     ;Decimal       ;CaptionML=[DAN=Valutafaktor;
                                                              ENU=Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0 }
    { 34  ;   ;Price Group Code    ;Code10        ;TableRelation="Customer Price Group";
                                                   CaptionML=[DAN=Prisgruppekode;
                                                              ENU=Price Group Code] }
    { 35  ;   ;Prices Including VAT;Boolean       ;CaptionML=[DAN=Priser inkl. moms;
                                                              ENU=Prices Including VAT] }
    { 37  ;   ;Invoice Disc. Code  ;Code20        ;CaptionML=[DAN=Fakturarabatkode;
                                                              ENU=Invoice Disc. Code] }
    { 40  ;   ;Cust./Item Disc. Gr.;Code20        ;TableRelation="Customer Discount Group";
                                                   CaptionML=[DAN=Deb./varerabatgrp.;
                                                              ENU=Cust./Item Disc. Gr.] }
    { 41  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 43  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Sëlgerkode;
                                                              ENU=Salesperson Code] }
    { 45  ;   ;Order Class         ;Code10        ;CaptionML=[DAN=Ordregruppe;
                                                              ENU=Order Class] }
    { 46  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Sales Comment Line Archive" WHERE (Document Type=FIELD(Document Type),
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
    { 57  ;   ;Ship                ;Boolean       ;CaptionML=[DAN=Lever;
                                                              ENU=Ship] }
    { 58  ;   ;Invoice             ;Boolean       ;CaptionML=[DAN=Fakturer;
                                                              ENU=Invoice] }
    { 60  ;   ;Amount              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line Archive".Amount WHERE (Document Type=FIELD(Document Type),
                                                                                                      Document No.=FIELD(No.),
                                                                                                      Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                                                      Version No.=FIELD(Version No.)));
                                                   CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Amount Including VAT;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line Archive"."Amount Including VAT" WHERE (Document Type=FIELD(Document Type),
                                                                                                                      Document No.=FIELD(No.),
                                                                                                                      Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                                                                      Version No.=FIELD(Version No.)));
                                                   CaptionML=[DAN=Belõb inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 62  ;   ;Shipping No.        ;Code20        ;CaptionML=[DAN=Tildelt salgslev.nr.;
                                                              ENU=Shipping No.] }
    { 63  ;   ;Posting No.         ;Code20        ;CaptionML=[DAN=Tildelt fakturanr.;
                                                              ENU=Posting No.] }
    { 64  ;   ;Last Shipping No.   ;Code20        ;TableRelation="Sales Shipment Header";
                                                   CaptionML=[DAN=Sidste salgslev.nr.;
                                                              ENU=Last Shipping No.] }
    { 65  ;   ;Last Posting No.    ;Code20        ;TableRelation="Sales Invoice Header";
                                                   CaptionML=[DAN=Sidste fakturanr.;
                                                              ENU=Last Posting No.] }
    { 66  ;   ;Prepayment No.      ;Code20        ;CaptionML=[DAN=Forudbetalingsnr.;
                                                              ENU=Prepayment No.] }
    { 67  ;   ;Last Prepayment No. ;Code20        ;TableRelation="Sales Invoice Header";
                                                   CaptionML=[DAN=Sidste forudbetalingsnr.;
                                                              ENU=Last Prepayment No.] }
    { 68  ;   ;Prepmt. Cr. Memo No.;Code20        ;CaptionML=[DAN=Forudbetalingskreditnota nr.;
                                                              ENU=Prepmt. Cr. Memo No.] }
    { 69  ;   ;Last Prepmt. Cr. Memo No.;Code20   ;TableRelation="Sales Invoice Header";
                                                   CaptionML=[DAN=Sidste forudbetalingskreditnota nr.;
                                                              ENU=Last Prepmt. Cr. Memo No.] }
    { 70  ;   ;VAT Registration No.;Text20        ;CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
    { 71  ;   ;Combine Shipments   ;Boolean       ;CaptionML=[DAN=Tillad samlefaktura;
                                                              ENU=Combine Shipments] }
    { 73  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 74  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 75  ;   ;EU 3-Party Trade    ;Boolean       ;CaptionML=[DAN=Trekantshandel;
                                                              ENU=EU 3-Party Trade] }
    { 76  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   CaptionML=[DAN=Transaktionsart;
                                                              ENU=Transaction Type] }
    { 77  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   CaptionML=[DAN=TransportmÜde;
                                                              ENU=Transport Method] }
    { 78  ;   ;VAT Country/Region Code;Code10     ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode for moms;
                                                              ENU=VAT Country/Region Code] }
    { 79  ;   ;Sell-to Customer Name;Text50       ;CaptionML=[DAN=Kundenavn;
                                                              ENU=Sell-to Customer Name] }
    { 80  ;   ;Sell-to Customer Name 2;Text50     ;CaptionML=[DAN=Kundenavn 2;
                                                              ENU=Sell-to Customer Name 2] }
    { 81  ;   ;Sell-to Address     ;Text50        ;CaptionML=[DAN=Kundeadresse;
                                                              ENU=Sell-to Address] }
    { 82  ;   ;Sell-to Address 2   ;Text50        ;CaptionML=[DAN=Kundeadresse 2;
                                                              ENU=Sell-to Address 2] }
    { 83  ;   ;Sell-to City        ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kundeby;
                                                              ENU=Sell-to City] }
    { 84  ;   ;Sell-to Contact     ;Text50        ;CaptionML=[DAN=Kundeattention;
                                                              ENU=Sell-to Contact] }
    { 85  ;   ;Bill-to Post Code   ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Faktureringspostnr.;
                                                              ENU=Bill-to Post Code] }
    { 86  ;   ;Bill-to County      ;Text30        ;CaptionML=[DAN=Faktureringsamt;
                                                              ENU=Bill-to County] }
    { 87  ;   ;Bill-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode til fakturering;
                                                              ENU=Bill-to Country/Region Code] }
    { 88  ;   ;Sell-to Post Code   ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kundepostnr.;
                                                              ENU=Sell-to Post Code] }
    { 89  ;   ;Sell-to County      ;Text30        ;CaptionML=[DAN=Kundeamt;
                                                              ENU=Sell-to County] }
    { 90  ;   ;Sell-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode for kunde;
                                                              ENU=Sell-to Country/Region Code] }
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
    { 97  ;   ;Exit Point          ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=[DAN=Udfõrselssted;
                                                              ENU=Exit Point] }
    { 98  ;   ;Correction          ;Boolean       ;CaptionML=[DAN=Rettelse;
                                                              ENU=Correction] }
    { 99  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 100 ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 101 ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=[DAN=OmrÜde;
                                                              ENU=Area] }
    { 102 ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 104 ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   CaptionML=[DAN=Betalingsformskode;
                                                              ENU=Payment Method Code] }
    { 105 ;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Speditõrkode;
                                                              ENU=Shipping Agent Code] }
    { 106 ;   ;Package Tracking No.;Text30        ;CaptionML=[DAN=Pakkesporingsnr.;
                                                              ENU=Package Tracking No.] }
    { 107 ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 108 ;   ;Posting No. Series  ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Bogfõringsnummerserie;
                                                              ENU=Posting No. Series] }
    { 109 ;   ;Shipping No. Series ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Leverancenummerserie;
                                                              ENU=Shipping No. Series] }
    { 114 ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=SkatteomrÜdekode;
                                                              ENU=Tax Area Code] }
    { 115 ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 116 ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 117 ;   ;Reserve             ;Option        ;CaptionML=[DAN=Reserver;
                                                              ENU=Reserve];
                                                   OptionCaptionML=[DAN=Aldrig,Eventuelt,Altid;
                                                                    ENU=Never,Optional,Always];
                                                   OptionString=Never,Optional,Always }
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
    { 125 ;   ;Sell-to IC Partner Code;Code20     ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=Kundes kode for IC-partner;
                                                              ENU=Sell-to IC Partner Code];
                                                   Editable=No }
    { 126 ;   ;Bill-to IC Partner Code;Code20     ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=Fakt.kode for IC-partner;
                                                              ENU=Bill-to IC Partner Code];
                                                   Editable=No }
    { 129 ;   ;IC Direction        ;Option        ;CaptionML=[DAN=IC-retning;
                                                              ENU=IC Direction];
                                                   OptionCaptionML=[DAN=UdgÜende,IndgÜende;
                                                                    ENU=Outgoing,Incoming];
                                                   OptionString=Outgoing,Incoming }
    { 130 ;   ;Prepayment %        ;Decimal       ;CaptionML=[DAN=Forudbetaling i %;
                                                              ENU=Prepayment %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 131 ;   ;Prepayment No. Series;Code20       ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Forudbetalingsnummerserie;
                                                              ENU=Prepayment No. Series] }
    { 132 ;   ;Compress Prepayment ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Komprimer forudbetaling;
                                                              ENU=Compress Prepayment] }
    { 133 ;   ;Prepayment Due Date ;Date          ;CaptionML=[DAN=Forfaldsdato for forudbetaling;
                                                              ENU=Prepayment Due Date] }
    { 134 ;   ;Prepmt. Cr. Memo No. Series;Code20 ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie til forudbetalingskreditnota;
                                                              ENU=Prepmt. Cr. Memo No. Series] }
    { 135 ;   ;Prepmt. Posting Description;Text50 ;CaptionML=[DAN=Beskrivelse af bogfõrt forudbetaling;
                                                              ENU=Prepmt. Posting Description] }
    { 138 ;   ;Prepmt. Pmt. Discount Date;Date    ;CaptionML=[DAN=Forudb. - dato for kont.rabat;
                                                              ENU=Prepmt. Pmt. Discount Date] }
    { 139 ;   ;Prepmt. Payment Terms Code;Code10  ;TableRelation="Payment Terms";
                                                   CaptionML=[DAN=Forudb. - kode for betal.betingelser;
                                                              ENU=Prepmt. Payment Terms Code] }
    { 140 ;   ;Prepmt. Payment Discount %;Decimal ;CaptionML=[DAN=Forudb. - kontantrabat i %;
                                                              ENU=Prepmt. Payment Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 145 ;   ;No. of Archived Versions;Integer   ;FieldClass=FlowField;
                                                   CalcFormula=Max("Sales Header Archive"."Version No." WHERE (Document Type=FIELD(Document Type),
                                                                                                               No.=FIELD(No.),
                                                                                                               Doc. No. Occurrence=FIELD(Doc. No. Occurrence)));
                                                   CaptionML=[DAN=Antal arkiverede versioner;
                                                              ENU=No. of Archived Versions];
                                                   Editable=No }
    { 151 ;   ;Sales Quote No.     ;Code20        ;TableRelation="Sales Header".No. WHERE (Document Type=CONST(Quote),
                                                                                           No.=FIELD(Sales Quote No.));
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Salgstilbudsnr.;
                                                              ENU=Sales Quote No.];
                                                   Editable=No }
    { 152 ;   ;Quote Valid Until Date;Date        ;CaptionML=[DAN=Tilbud gyldigt til dato;
                                                              ENU=Quote Valid Until Date] }
    { 153 ;   ;Quote Sent to Customer;DateTime    ;CaptionML=[DAN=Tilbud sendt til kunde;
                                                              ENU=Quote Sent to Customer] }
    { 154 ;   ;Quote Accepted      ;Boolean       ;CaptionML=[DAN=Tilbud accepteret;
                                                              ENU=Quote Accepted] }
    { 155 ;   ;Quote Accepted Date ;Date          ;CaptionML=[DAN=Dato for tilbud accepteret;
                                                              ENU=Quote Accepted Date];
                                                   Editable=No }
    { 200 ;   ;Work Description    ;BLOB          ;CaptionML=[DAN=Arbejdsbeskrivelse;
                                                              ENU=Work Description] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 827 ;   ;Credit Card No.     ;Code20        ;CaptionML=[DAN=Kreditkortnr.;
                                                              ENU=Credit Card No.] }
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
    { 5051;   ;Sell-to Customer Template Code;Code10;
                                                   TableRelation="Customer Template";
                                                   CaptionML=[DAN=Kundeskabelonkode;
                                                              ENU=Sell-to Customer Template Code] }
    { 5052;   ;Sell-to Contact No. ;Code20        ;TableRelation=Contact;
                                                   CaptionML=[DAN=Kundeattentionnr.;
                                                              ENU=Sell-to Contact No.] }
    { 5053;   ;Bill-to Contact No. ;Code20        ;TableRelation=Contact;
                                                   CaptionML=[DAN=Faktureres attentionnr.;
                                                              ENU=Bill-to Contact No.] }
    { 5054;   ;Bill-to Customer Template Code;Code10;
                                                   CaptionML=[DAN=Skabelonkode til Faktureres til kunde;
                                                              ENU=Bill-to Customer Template Code] }
    { 5055;   ;Opportunity No.     ;Code20        ;TableRelation=Opportunity.No. WHERE (Contact No.=FIELD(Sell-to Contact No.),
                                                                                        Closed=CONST(No));
                                                   CaptionML=[DAN=Salgsmulighednummer;
                                                              ENU=Opportunity No.] }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 5750;   ;Shipping Advice     ;Option        ;AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Afsendelsesadvis;
                                                              ENU=Shipping Advice];
                                                   OptionCaptionML=[DAN=Delvis,Komplet;
                                                                    ENU=Partial,Complete];
                                                   OptionString=Partial,Complete }
    { 5752;   ;Completely Shipped  ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Min("Sales Line Archive"."Completely Shipped" WHERE (Document Type=FIELD(Document Type),
                                                                                                                    Document No.=FIELD(No.),
                                                                                                                    Version No.=FIELD(Version No.),
                                                                                                                    Shipment Date=FIELD(Date Filter),
                                                                                                                    Location Code=FIELD(Location Filter)));
                                                   CaptionML=[DAN=Levering komplet;
                                                              ENU=Completely Shipped];
                                                   Editable=No }
    { 5753;   ;Posting from Whse. Ref.;Integer    ;CaptionML=[DAN=Bogfõring fra lagerref.;
                                                              ENU=Posting from Whse. Ref.] }
    { 5754;   ;Location Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Location;
                                                   CaptionML=[DAN=Lokationsfilter;
                                                              ENU=Location Filter] }
    { 5790;   ;Requested Delivery Date;Date       ;AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=ùnsket leveringsdato;
                                                              ENU=Requested Delivery Date] }
    { 5791;   ;Promised Delivery Date;Date        ;CaptionML=[DAN=Bekrëftet leveringsdato;
                                                              ENU=Promised Delivery Date] }
    { 5792;   ;Shipping Time       ;DateFormula   ;CaptionML=[DAN=Transporttid;
                                                              ENU=Shipping Time] }
    { 5793;   ;Outbound Whse. Handling Time;DateFormula;
                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=UdgÜende lagerekspeditionstid;
                                                              ENU=Outbound Whse. Handling Time] }
    { 5794;   ;Shipping Agent Service Code;Code10 ;TableRelation="Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));
                                                   CaptionML=[DAN=Speditõrservicekode;
                                                              ENU=Shipping Agent Service Code] }
    { 5795;   ;Late Order Shipping ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Sales Line Archive" WHERE (Document Type=FIELD(Document Type),
                                                                                                 Sell-to Customer No.=FIELD(Sell-to Customer No.),
                                                                                                 Document No.=FIELD(No.),
                                                                                                 Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                                                 Version No.=FIELD(Version No.),
                                                                                                 Shipment Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Forsinket leverance;
                                                              ENU=Late Order Shipping];
                                                   Editable=No }
    { 5796;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 5800;   ;Receive             ;Boolean       ;CaptionML=[DAN=Modtag;
                                                              ENU=Receive] }
    { 5801;   ;Return Receipt No.  ;Code20        ;CaptionML=[DAN=Returvaremodt.nr.;
                                                              ENU=Return Receipt No.] }
    { 5802;   ;Return Receipt No. Series;Code20   ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Returvaremodt.nummerserie;
                                                              ENU=Return Receipt No. Series] }
    { 5803;   ;Last Return Receipt No.;Code20     ;TableRelation="Return Receipt Header";
                                                   CaptionML=[DAN=Sidste returvaremodt.nr.;
                                                              ENU=Last Return Receipt No.] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
    { 7200;   ;Get Shipment Used   ;Boolean       ;CaptionML=[DAN=Hent anvendt levering;
                                                              ENU=Get Shipment Used];
                                                   Editable=No }
    { 9000;   ;Assigned User ID    ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
    { 13600;  ;EAN No.             ;Code13        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=EAN-nr.;
                                                              ENU=EAN No.] }
    { 13602;  ;Account Code        ;Text30        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontokode;
                                                              ENU=Account Code] }
    { 13605;  ;Sell-to Contact Phone No.;Text30   ;ExtendedDatatype=Phone No.;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Telefonnummer til kundekontakt;
                                                              ENU=Sell-to Contact Phone No.] }
    { 13606;  ;Sell-to Contact Fax No.;Text30     ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Faxnummer til kundekontakt;
                                                              ENU=Sell-to Contact Fax No.] }
    { 13607;  ;Sell-to Contact E-Mail;Text80      ;ExtendedDatatype=E-Mail;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Mailadresse til kundekontakt;
                                                              ENU=Sell-to Contact E-Mail] }
    { 13608;  ;Sell-to Contact Role;Option        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kundekontaktens rolle;
                                                              ENU=Sell-to Contact Role];
                                                   OptionCaptionML=[DAN=" ,,,Indkõbsansvarlig,,,Bogholder,,,Budgetansvarlig,,,Indkõber";
                                                                    ENU=" ,,,Purchase Responsible,,,Accountant,,,Budget Responsible,,,Requisitioner"];
                                                   OptionString=[ ,,,Purchase Responsible,,,Accountant,,,Budget Responsible,,,Requisitioner] }
    { 13620;  ;Payment Channel     ;Option        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Betalingskanal;
                                                              ENU=Payment Channel];
                                                   OptionCaptionML=[DAN=" ,Betalingsbon,Kontooverfõrsel,National transaktion,Direct Debit";
                                                                    ENU=" ,Payment Slip,Account Transfer,National Clearing,Direct Debit"];
                                                   OptionString=[ ,Payment Slip,Account Transfer,National Clearing,Direct Debit] }
  }
  KEYS
  {
    {    ;Document Type,No.,Doc. No. Occurrence,Version No.;
                                                   Clustered=Yes }
    {    ;Document Type,Sell-to Customer No.       }
    {    ;Document Type,Bill-to Customer No.       }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      SalesCommentLineArch@1001 : Record 5126;
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
      IF UserSetupMgt.GetSalesFilter <> '' THEN BEGIN
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
        FILTERGROUP(0);
      END;
    END;

    BEGIN
    END.
  }
}

