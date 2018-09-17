OBJECT Table 114 Sales Cr.Memo Header
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783,NAVDK11.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Sell-to Customer Name;
    OnDelete=VAR
               PostedDeferralHeader@1002 : Record 1704;
               PostSalesDelete@1000 : Codeunit 363;
               DeferralUtilities@1001 : Codeunit 1720;
             BEGIN
               PostSalesDelete.IsDocumentDeletionAllowed("Posting Date");
               TESTFIELD("No. Printed");
               LOCKTABLE;
               PostSalesDelete.DeleteSalesCrMemoLines(Rec);

               SalesCommentLine.SETRANGE("Document Type",SalesCommentLine."Document Type"::"Posted Credit Memo");
               SalesCommentLine.SETRANGE("No.","No.");
               SalesCommentLine.DELETEALL;

               ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
               PostedDeferralHeader.DeleteForDoc(DeferralUtilities.GetSalesDeferralDocType,'','',
                 SalesCommentLine."Document Type"::"Posted Credit Memo","No.");
             END;

    CaptionML=[DAN=Salgskreditnotahoved;
               ENU=Sales Cr.Memo Header];
    LookupPageID=Page144;
    DrillDownPageID=Page144;
  }
  FIELDS
  {
    { 2   ;   ;Sell-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.];
                                                   NotBlank=Yes }
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
                                                              ENU=Customer Posting Group];
                                                   Editable=No }
    { 32  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code];
                                                   Editable=No }
    { 33  ;   ;Currency Factor     ;Decimal       ;CaptionML=[DAN=Valutafaktor;
                                                              ENU=Currency Factor];
                                                   DecimalPlaces=0:15;
                                                   MinValue=0 }
    { 34  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   CaptionML=[DAN=Debitorprisgruppe;
                                                              ENU=Customer Price Group] }
    { 35  ;   ;Prices Including VAT;Boolean       ;CaptionML=[DAN=Priser inkl. moms;
                                                              ENU=Prices Including VAT] }
    { 37  ;   ;Invoice Disc. Code  ;Code20        ;CaptionML=[DAN=Fakturarabatkode;
                                                              ENU=Invoice Disc. Code] }
    { 40  ;   ;Customer Disc. Group;Code20        ;TableRelation="Customer Discount Group";
                                                   CaptionML=[DAN=Debitorrabatgruppe;
                                                              ENU=Customer Disc. Group] }
    { 41  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 43  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Sëlgerkode;
                                                              ENU=Salesperson Code] }
    { 46  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Sales Comment Line" WHERE (Document Type=CONST(Posted Credit Memo),
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
                                                              CustLedgEntry.SETCURRENTKEY("Document No.");
                                                              CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                                                              CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                                                              PAGE.RUN(0,CustLedgEntry);
                                                            END;

                                                   CaptionML=[DAN=Udligningsbilagsnr.;
                                                              ENU=Applies-to Doc. No.] }
    { 55  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 60  ;   ;Amount              ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Cr.Memo Line".Amount WHERE (Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Amount Including VAT;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Cr.Memo Line"."Amount Including VAT" WHERE (Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Belõb inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 70  ;   ;VAT Registration No.;Text20        ;CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
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
    { 134 ;   ;Prepmt. Cr. Memo No. Series;Code20 ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie til forudbetalingskreditnota;
                                                              ENU=Prepmt. Cr. Memo No. Series] }
    { 136 ;   ;Prepayment Credit Memo;Boolean     ;CaptionML=[DAN=Forudbetalingskreditnota;
                                                              ENU=Prepayment Credit Memo] }
    { 137 ;   ;Prepayment Order No.;Code20        ;CaptionML=[DAN=Ordrenr. til forudbetaling;
                                                              ENU=Prepayment Order No.] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 710 ;   ;Document Exchange Identifier;Text50;CaptionML=[DAN=Dokumentudvekslings-id;
                                                              ENU=Document Exchange Identifier] }
    { 711 ;   ;Document Exchange Status;Option    ;CaptionML=[DAN=Status for dokumentudveksling;
                                                              ENU=Document Exchange Status];
                                                   OptionCaptionML=[DAN=Ikke sendt,Sendt til dokumentudvekslingstjeneste,Leveret til modtager,Levering mislykkedes,Afventer forbindelse til modtager;
                                                                    ENU=Not Sent,Sent to Document Exchange Service,Delivered to Recipient,Delivery Failed,Pending Connection to Recipient];
                                                   OptionString=Not Sent,Sent to Document Exchange Service,Delivered to Recipient,Delivery Failed,Pending Connection to Recipient }
    { 712 ;   ;Doc. Exch. Original Identifier;Text50;
                                                   CaptionML=[DAN=Oprindeligt dokumentudvekslings-id;
                                                              ENU=Doc. Exch. Original Identifier] }
    { 1302;   ;Paid                ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=-Exist("Cust. Ledger Entry" WHERE (Entry No.=FIELD(Cust. Ledger Entry No.),
                                                                                                  Open=FILTER(Yes)));
                                                   CaptionML=[DAN=Betalt;
                                                              ENU=Paid];
                                                   Editable=No }
    { 1303;   ;Remaining Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Cust. Ledger Entry No.=FIELD(Cust. Ledger Entry No.)));
                                                   CaptionML=[DAN=Restbelõb;
                                                              ENU=Remaining Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1304;   ;Cust. Ledger Entry No.;Integer     ;TableRelation="Cust. Ledger Entry"."Entry No.";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Debitorpostlõbenr.;
                                                              ENU=Cust. Ledger Entry No.];
                                                   Editable=No }
    { 1305;   ;Invoice Discount Amount;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Cr.Memo Line"."Inv. Discount Amount" WHERE (Document No.=FIELD(No.)));
                                                   CaptionML=[DAN=Fakturarabatbelõb;
                                                              ENU=Invoice Discount Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1310;   ;Cancelled           ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Cancelled Document" WHERE (Source ID=CONST(114),
                                                                                                 Cancelled Doc. No.=FIELD(No.)));
                                                   CaptionML=[DAN=Annulleret;
                                                              ENU=Cancelled];
                                                   Editable=No }
    { 1311;   ;Corrective          ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Cancelled Document" WHERE (Source ID=CONST(112),
                                                                                                 Cancelled By Doc. No.=FIELD(No.)));
                                                   CaptionML=[DAN=Korrigerende;
                                                              ENU=Corrective];
                                                   Editable=No }
    { 5050;   ;Campaign No.        ;Code20        ;TableRelation=Campaign;
                                                   CaptionML=[DAN=Kampagnenr.;
                                                              ENU=Campaign No.] }
    { 5052;   ;Sell-to Contact No. ;Code20        ;TableRelation=Contact;
                                                   CaptionML=[DAN=Kundeattentionnr.;
                                                              ENU=Sell-to Contact No.] }
    { 5053;   ;Bill-to Contact No. ;Code20        ;TableRelation=Contact;
                                                   CaptionML=[DAN=Faktureres attentionnr.;
                                                              ENU=Bill-to Contact No.] }
    { 5055;   ;Opportunity No.     ;Code20        ;TableRelation=Opportunity;
                                                   CaptionML=[DAN=Salgsmulighedsnummer;
                                                              ENU=Opportunity No.] }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 6601;   ;Return Order No.    ;Code20        ;AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Returvareordrenr.;
                                                              ENU=Return Order No.] }
    { 6602;   ;Return Order No. Series;Code20     ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Returvareordrenr.serie;
                                                              ENU=Return Order No. Series] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
    { 7200;   ;Get Return Receipt Used;Boolean    ;CaptionML=[DAN=Hent anvendte returvaremodt.;
                                                              ENU=Get Return Receipt Used] }
    { 8000;   ;Id                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 13600;  ;EAN No.             ;Code13        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=EAN-nr.;
                                                              ENU=EAN No.] }
    { 13601;  ;Electronic Credit Memo Created;Boolean;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Elektronisk kreditnota er oprettet;
                                                              ENU=Electronic Credit Memo Created];
                                                   Editable=No }
    { 13602;  ;Account Code        ;Text30        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontokode;
                                                              ENU=Account Code] }
    { 13604;  ;OIOUBL Profile Code ;Code10        ;TableRelation="OIOUBL Profile";
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=OIOUBL-profilkode;
                                                              ENU=OIOUBL Profile Code] }
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
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Pre-Assigned No.                         }
    {    ;Return Order No.                         }
    {    ;Sell-to Customer No.                     }
    {    ;Prepayment Order No.                     }
    {    ;Bill-to Customer No.                     }
    {    ;Posting Date                             }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Sell-to Customer No.,Bill-to Customer No.,Posting Date,Posting Description }
    { 2   ;Brick               ;No.,Sell-to Customer Name,Amount,Due Date,Amount Including VAT }
  }
  CODE
  {
    VAR
      SalesCommentLine@1001 : Record 44;
      CustLedgEntry@1002 : Record 21;
      ApprovalsMgmt@1004 : Codeunit 1535;
      DimMgt@1005 : Codeunit 408;
      UserSetupMgt@1006 : Codeunit 5700;
      DocTxt@1000 : TextConst 'DAN=Kreditnota;ENU=Credit Memo';

    [Internal]
    PROCEDURE SendRecords@12();
    VAR
      DocumentSendingProfile@1001 : Record 60;
      DummyReportSelections@1000 : Record 77;
    BEGIN
      DocumentSendingProfile.SendCustomerRecords(
        DummyReportSelections.Usage::"S.Cr.Memo",Rec,DocTxt,"Bill-to Customer No.","No.",
        FIELDNO("Bill-to Customer No."),FIELDNO("No."));
    END;

    [External]
    PROCEDURE SendProfile@6(VAR DocumentSendingProfile@1000 : Record 60);
    VAR
      DummyReportSelections@1002 : Record 77;
    BEGIN
      DocumentSendingProfile.Send(
        DummyReportSelections.Usage::"S.Cr.Memo",Rec,"No.","Bill-to Customer No.",
        DocTxt,FIELDNO("Bill-to Customer No."),FIELDNO("No."));
    END;

    [External]
    PROCEDURE PrintRecords@1(ShowRequestForm@1000 : Boolean);
    VAR
      DocumentSendingProfile@1002 : Record 60;
      DummyReportSelections@1001 : Record 77;
    BEGIN
      DocumentSendingProfile.TrySendToPrinter(
        DummyReportSelections.Usage::"S.Cr.Memo",Rec,FIELDNO("Bill-to Customer No."),ShowRequestForm);
    END;

    [Internal]
    PROCEDURE EmailRecords@17(ShowRequestForm@1000 : Boolean);
    VAR
      DocumentSendingProfile@1002 : Record 60;
      DummyReportSelections@1001 : Record 77;
    BEGIN
      DocumentSendingProfile.TrySendToEMail(
        DummyReportSelections.Usage::"S.Cr.Memo",Rec,FIELDNO("No."),DocTxt,FIELDNO("Bill-to Customer No."),ShowRequestForm);
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
    PROCEDURE LookupAdjmtValueEntries@3();
    VAR
      ValueEntry@1000 : Record 5802;
    BEGIN
      ValueEntry.SETCURRENTKEY("Document No.");
      ValueEntry.SETRANGE("Document No.","No.");
      ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Credit Memo");
      ValueEntry.SETRANGE(Adjustment,TRUE);
      PAGE.RUNMODAL(0,ValueEntry);
    END;

    [External]
    PROCEDURE GetCustomerVATRegistrationNumber@14() : Text;
    BEGIN
      EXIT("VAT Registration No.");
    END;

    [External]
    PROCEDURE GetCustomerVATRegistrationNumberLbl@15() : Text;
    BEGIN
      EXIT(FIELDCAPTION("VAT Registration No."));
    END;

    [External]
    PROCEDURE GetCustomerGlobalLocationNumber@8() : Text;
    BEGIN
      EXIT('');
    END;

    [External]
    PROCEDURE GetCustomerGlobalLocationNumberLbl@10() : Text;
    BEGIN
      EXIT('');
    END;

    [External]
    PROCEDURE GetLegalStatement@60() : Text;
    VAR
      SalesSetup@1000 : Record 311;
    BEGIN
      SalesSetup.GET;
      EXIT(SalesSetup.GetLegalStatement);
    END;

    [External]
    PROCEDURE ShowDimensions@4();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
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

    PROCEDURE AccountCodeLineSpecified@1101100000() : Boolean;
    VAR
      SalesCrMemoLine@1101100000 : Record 115;
    BEGIN
      SalesCrMemoLine.RESET;
      SalesCrMemoLine.SETRANGE("Document No.", "No.");
      SalesCrMemoLine.SETFILTER(Type, '>%1', SalesCrMemoLine.Type::" ");
      SalesCrMemoLine.SETFILTER("Account Code", '<>%1&<>%2', '', "Account Code");
      EXIT(NOT SalesCrMemoLine.ISEMPTY);
    END;

    PROCEDURE TaxLineSpecified@1101100001() : Boolean;
    VAR
      SalesCrMemoLine@1101100000 : Record 115;
    BEGIN
      SalesCrMemoLine.RESET;
      SalesCrMemoLine.SETRANGE("Document No.", "No.");
      SalesCrMemoLine.SETFILTER(Type, '>%1', SalesCrMemoLine.Type::" ");
      SalesCrMemoLine.FIND('-');
      SalesCrMemoLine.SETFILTER("VAT %", '<>%1', SalesCrMemoLine."VAT %");
      EXIT(NOT SalesCrMemoLine.ISEMPTY);
    END;

    [External]
    PROCEDURE GetDocExchStatusStyle@13() : Text;
    BEGIN
      CASE "Document Exchange Status" OF
        "Document Exchange Status"::"Not Sent":
          EXIT('Standard');
        "Document Exchange Status"::"Sent to Document Exchange Service":
          EXIT('Ambiguous');
        "Document Exchange Status"::"Delivered to Recipient":
          EXIT('Favorable');
        ELSE
          EXIT('Unfavorable');
      END;
    END;

    [External]
    PROCEDURE ShowActivityLog@116();
    VAR
      ActivityLog@1000 : Record 710;
    BEGIN
      ActivityLog.ShowEntries(RECORDID);
    END;

    [External]
    PROCEDURE DocExchangeStatusIsSent@112() : Boolean;
    BEGIN
      EXIT("Document Exchange Status" <> "Document Exchange Status"::"Not Sent");
    END;

    [External]
    PROCEDURE ShowCanceledOrCorrInvoice@18();
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
      SalesInvHeader@1001 : Record 112;
    BEGIN
      CALCFIELDS(Cancelled);
      IF NOT Cancelled THEN
        EXIT;

      IF CancelledDocument.FindSalesCancelledCrMemo("No.") THEN BEGIN
        SalesInvHeader.GET(CancelledDocument."Cancelled By Doc. No.");
        PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvHeader);
      END;
    END;

    [External]
    PROCEDURE ShowCancelledInvoice@37();
    VAR
      CancelledDocument@1000 : Record 1900;
      SalesInvHeader@1001 : Record 112;
    BEGIN
      CALCFIELDS(Corrective);
      IF NOT Corrective THEN
        EXIT;

      IF CancelledDocument.FindSalesCorrectiveCrMemo("No.") THEN BEGIN
        SalesInvHeader.GET(CancelledDocument."Cancelled Doc. No.");
        PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvHeader);
      END;
    END;

    BEGIN
    END.
  }
}

