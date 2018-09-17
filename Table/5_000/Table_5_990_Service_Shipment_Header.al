OBJECT Table 5990 Service Shipment Header
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Name;
    OnDelete=VAR
               CertificateOfSupply@1000 : Record 780;
             BEGIN
               TESTFIELD("No. Printed");
               LOCKTABLE;

               ServShptItemLine.RESET;
               ServShptItemLine.SETRANGE("No.","No.");
               ServShptItemLine.DELETEALL;

               ServShptLine.RESET;
               ServShptLine.SETRANGE("Document No.","No.");
               ServShptLine.DELETEALL;

               ServCommentLine.RESET;
               ServCommentLine.SETRANGE("Table Name",ServCommentLine."Table Name"::"Service Shipment Header");
               ServCommentLine.SETRANGE("No.","No.");
               ServCommentLine.DELETEALL;

               IF CertificateOfSupply.GET(CertificateOfSupply."Document Type"::"Service Shipment","No.") THEN
                 CertificateOfSupply.DELETE(TRUE);
             END;

    CaptionML=[DAN=Serviceleverancehoved;
               ENU=Service Shipment Header];
    LookupPageID=Page5974;
    DrillDownPageID=Page5974;
  }
  FIELDS
  {
    { 2   ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.];
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
    { 12  ;   ;Ship-to Code        ;Code10        ;TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(Customer No.));
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
                                                              ENU=Order Date];
                                                   NotBlank=Yes }
    { 20  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
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
    { 44  ;   ;Order No.           ;Code20        ;CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.] }
    { 46  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Service Comment Line" WHERE (Table Name=CONST(Service Shipment Header),
                                                                                                   No.=FIELD(No.),
                                                                                                   Type=CONST(General)));
                                                   CaptionML=[DAN=Bemërkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 47  ;   ;No. Printed         ;Integer       ;CaptionML=[DAN=Udskrevet;
                                                              ENU=No. Printed];
                                                   Editable=No }
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
    { 79  ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 80  ;   ;Name 2              ;Text50        ;CaptionML=[DAN=Navn 2;
                                                              ENU=Name 2] }
    { 81  ;   ;Address             ;Text50        ;CaptionML=[DAN=Adresse;
                                                              ENU=Address] }
    { 82  ;   ;Address 2           ;Text50        ;CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2] }
    { 83  ;   ;City                ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City] }
    { 84  ;   ;Contact Name        ;Text50        ;CaptionML=[DAN=Kontaktnavn;
                                                              ENU=Contact Name] }
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
    { 88  ;   ;Post Code           ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 89  ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 90  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode;
                                                              ENU=Country/Region Code] }
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
    { 101 ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=[DAN=OmrÜde;
                                                              ENU=Area] }
    { 102 ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 104 ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   CaptionML=[DAN=Betalingsformskode;
                                                              ENU=Payment Method Code] }
    { 109 ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 110 ;   ;Order No. Series    ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Ordrenummerserie;
                                                              ENU=Order No. Series] }
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
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 5052;   ;Contact No.         ;Code20        ;TableRelation=Contact;
                                                   CaptionML=[DAN=Kontaktnr.;
                                                              ENU=Contact No.] }
    { 5053;   ;Bill-to Contact No. ;Code20        ;TableRelation=Contact;
                                                   CaptionML=[DAN=Faktureres attentionnr.;
                                                              ENU=Bill-to Contact No.] }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 5796;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 5902;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 5904;   ;Service Order Type  ;Code10        ;TableRelation="Service Order Type";
                                                   CaptionML=[DAN=Serviceordretype;
                                                              ENU=Service Order Type] }
    { 5905;   ;Link Service to Service Item;Boolean;
                                                   CaptionML=[DAN=Sammenkëd service med artikel;
                                                              ENU=Link Service to Service Item] }
    { 5907;   ;Priority            ;Option        ;CaptionML=[DAN=Prioritet;
                                                              ENU=Priority];
                                                   OptionCaptionML=[DAN=Lav,Medium,Hõj;
                                                                    ENU=Low,Medium,High];
                                                   OptionString=Low,Medium,High;
                                                   Editable=No }
    { 5911;   ;Allocated Hours     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Order Allocation"."Allocated Hours" WHERE (Document Type=CONST(Order),
                                                                                                                       Document No.=FIELD(Order No.),
                                                                                                                       Resource No.=FIELD(Resource Filter),
                                                                                                                       Resource Group No.=FIELD(Resource Group Filter),
                                                                                                                       Status=FILTER(Active|Finished)));
                                                   CaptionML=[DAN=Allokerede timer;
                                                              ENU=Allocated Hours];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5915;   ;Phone No.           ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.] }
    { 5916;   ;E-Mail              ;Text80        ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                MailManagement.ValidateEmailAddressField("E-Mail");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Mail;
                                                              ENU=Email] }
    { 5917;   ;Phone No. 2         ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon 2;
                                                              ENU=Phone No. 2] }
    { 5918;   ;Fax No.             ;Text30        ;CaptionML=[DAN=Telefax;
                                                              ENU=Fax No.] }
    { 5921;   ;No. of Unallocated Items;Integer   ;FieldClass=FlowField;
                                                   CalcFormula=Count("Service Item Line" WHERE (Document Type=CONST(Order),
                                                                                                Document No.=FIELD(No.),
                                                                                                No. of Active/Finished Allocs=CONST(0)));
                                                   CaptionML=[DAN=Antal ikkeallokerede artikler;
                                                              ENU=No. of Unallocated Items];
                                                   Editable=No }
    { 5923;   ;Order Time          ;Time          ;CaptionML=[DAN=Ordretidspunkt;
                                                              ENU=Order Time] }
    { 5924;   ;Default Response Time (Hours);Decimal;
                                                   CaptionML=[DAN=Standardsvartid (timer);
                                                              ENU=Default Response Time (Hours)];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 5925;   ;Actual Response Time (Hours);Decimal;
                                                   CaptionML=[DAN=Reel svartid (timer);
                                                              ENU=Actual Response Time (Hours)];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 5926;   ;Service Time (Hours);Decimal       ;CaptionML=[DAN=Servicetid (timer);
                                                              ENU=Service Time (Hours)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5927;   ;Response Date       ;Date          ;CaptionML=[DAN=Svardato;
                                                              ENU=Response Date];
                                                   Editable=No }
    { 5928;   ;Response Time       ;Time          ;CaptionML=[DAN=Svartidspunkt;
                                                              ENU=Response Time];
                                                   Editable=No }
    { 5929;   ;Starting Date       ;Date          ;CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 5930;   ;Starting Time       ;Time          ;CaptionML=[DAN=Starttidspunkt;
                                                              ENU=Starting Time] }
    { 5931;   ;Finishing Date      ;Date          ;CaptionML=[DAN=Fërdiggõrelsesdato;
                                                              ENU=Finishing Date] }
    { 5932;   ;Finishing Time      ;Time          ;CaptionML=[DAN=Fërdiggõrelsestidspunkt;
                                                              ENU=Finishing Time] }
    { 5933;   ;Contract Serv. Hours Exist;Boolean ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Service Hour" WHERE (Service Contract No.=FIELD(Contract No.)));
                                                   CaptionML=[DAN=Kontraktserv.Übn.tider findes;
                                                              ENU=Contract Serv. Hours Exist];
                                                   Editable=No }
    { 5934;   ;Reallocation Needed ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Service Order Allocation" WHERE (Status=CONST(Reallocation Needed),
                                                                                                       Resource No.=FIELD(Resource Filter),
                                                                                                       Document Type=CONST(Order),
                                                                                                       Document No.=FIELD(No.),
                                                                                                       Resource Group No.=FIELD(Resource Group Filter)));
                                                   CaptionML=[DAN=Genallokering nõdvendig;
                                                              ENU=Reallocation Needed];
                                                   Editable=No }
    { 5936;   ;Notify Customer     ;Option        ;CaptionML=[DAN=Underret kunde;
                                                              ENU=Notify Customer];
                                                   OptionCaptionML=[DAN=Nej,Via telefon 1,Via telefon 2,Via telefax,Via mail;
                                                                    ENU=No,By Phone 1,By Phone 2,By Fax,By Email];
                                                   OptionString=No,By Phone 1,By Phone 2,By Fax,By Email }
    { 5937;   ;Max. Labor Unit Price;Decimal      ;CaptionML=[DAN=Maks. arbejdsenhedspris;
                                                              ENU=Max. Labor Unit Price];
                                                   BlankZero=Yes;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 5938;   ;Warning Status      ;Option        ;CaptionML=[DAN=Advarselsstatus;
                                                              ENU=Warning Status];
                                                   OptionCaptionML=[DAN=" ,Fõrste advarsel,Anden advarsel,Tredje advarsel";
                                                                    ENU=" ,First Warning,Second Warning,Third Warning"];
                                                   OptionString=[ ,First Warning,Second Warning,Third Warning] }
    { 5939;   ;No. of Allocations  ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Service Order Allocation" WHERE (Document Type=CONST(Order),
                                                                                                       Document No.=FIELD(No.),
                                                                                                       Resource No.=FIELD(Resource Filter),
                                                                                                       Resource Group No.=FIELD(Resource Group Filter),
                                                                                                       Status=FILTER(Active|Finished)));
                                                   CaptionML=[DAN=Antal allokeringer;
                                                              ENU=No. of Allocations];
                                                   Editable=No }
    { 5940;   ;Contract No.        ;Code20        ;TableRelation="Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract),
                                                                                                                 Customer No.=FIELD(Customer No.),
                                                                                                                 Ship-to Code=FIELD(Ship-to Code),
                                                                                                                 Bill-to Customer No.=FIELD(Bill-to Customer No.));
                                                   CaptionML=[DAN=Kontraktnr.;
                                                              ENU=Contract No.] }
    { 5951;   ;Type Filter         ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Typefilter;
                                                              ENU=Type Filter];
                                                   OptionCaptionML=[DAN=" ,Ressource,Vare,Serviceomkostninger,Servicekontrakt";
                                                                    ENU=" ,Resource,Item,Service Cost,Service Contract"];
                                                   OptionString=[ ,Resource,Item,Service Cost,Service Contract] }
    { 5952;   ;Customer Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Customer.No.;
                                                   CaptionML=[DAN=Debitorfilter;
                                                              ENU=Customer Filter] }
    { 5953;   ;Resource Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Resource;
                                                   CaptionML=[DAN=Ressourcefilter;
                                                              ENU=Resource Filter] }
    { 5954;   ;Contract Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract));
                                                   CaptionML=[DAN=Kontraktfilter;
                                                              ENU=Contract Filter] }
    { 5955;   ;Ship-to Fax No.     ;Text30        ;CaptionML=[DAN=Leveringstelefax;
                                                              ENU=Ship-to Fax No.] }
    { 5956;   ;Ship-to E-Mail      ;Text80        ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                MailManagement.ValidateEmailAddressField("Ship-to E-Mail");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Leveringsmail;
                                                              ENU=Ship-to Email] }
    { 5957;   ;Resource Group Filter;Code20       ;FieldClass=FlowFilter;
                                                   TableRelation="Resource Group";
                                                   CaptionML=[DAN=Ressourcegruppefilter;
                                                              ENU=Resource Group Filter] }
    { 5958;   ;Ship-to Phone       ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Levering/telefon;
                                                              ENU=Ship-to Phone] }
    { 5959;   ;Ship-to Phone 2     ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Levering/telefon 2;
                                                              ENU=Ship-to Phone 2] }
    { 5966;   ;Service Zone Filter ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="Service Zone".Code;
                                                   CaptionML=[DAN=Servicezonefilter;
                                                              ENU=Service Zone Filter] }
    { 5968;   ;Service Zone Code   ;Code10        ;TableRelation="Service Zone".Code;
                                                   CaptionML=[DAN=Servicezonekode;
                                                              ENU=Service Zone Code] }
    { 5981;   ;Expected Finishing Date;Date       ;CaptionML=[DAN=Forventet fërdiggõrelsesdato;
                                                              ENU=Expected Finishing Date] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Customer No.,Posting Date                }
    {    ;Order No.                                }
    {    ;Bill-to Customer No.                     }
    {    ;Customer No.,No.                         }
    {    ;Contract No.,Posting Date                }
    {    ;Responsibility Center,Posting Date       }
    {    ;Posting Date                             }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Customer No.,Contract No.,Posting Date }
  }
  CODE
  {
    VAR
      CustLedgEntry@1001 : Record 21;
      ServCommentLine@1004 : Record 5906;
      ServShptItemLine@1007 : Record 5989;
      ServShptHeader@1003 : Record 5990;
      ServShptLine@1005 : Record 5991;
      DimMgt@1006 : Codeunit 408;
      UserSetupMgt@1000 : Codeunit 5700;

    [External]
    PROCEDURE PrintRecords@3(ShowRequestForm@1000 : Boolean);
    VAR
      ReportSelection@1001 : Record 77;
    BEGIN
      WITH ServShptHeader DO BEGIN
        COPY(Rec);
        ReportSelection.PrintWithGUIYesNo(
          ReportSelection.Usage::"SM.Shipment",ServShptHeader,ShowRequestForm,FIELDNO("Bill-to Customer No."));
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
    PROCEDURE ShowDimensions@1();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
    END;

    [External]
    PROCEDURE SetSecurityFilterOnRespCenter@4();
    BEGIN
      IF UserSetupMgt.GetServiceFilter <> '' THEN BEGIN
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserSetupMgt.GetServiceFilter);
        FILTERGROUP(0);
      END;
    END;

    BEGIN
    END.
  }
}

