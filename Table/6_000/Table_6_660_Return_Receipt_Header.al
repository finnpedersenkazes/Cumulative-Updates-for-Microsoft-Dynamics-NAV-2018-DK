OBJECT Table 6660 Return Receipt Header
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Sell-to Customer Name;
    OnDelete=VAR
               PostSalesDelete@1000 : Codeunit 363;
             BEGIN
               TESTFIELD("No. Printed");
               LOCKTABLE;
               PostSalesDelete.DeleteSalesRcptLines(Rec);

               SalesCommentLine.SETRANGE("Document Type",SalesCommentLine."Document Type"::"Posted Return Receipt");
               SalesCommentLine.SETRANGE("No.","No.");
               SalesCommentLine.DELETEALL;

               ApprovalsMgmt.DeletePostedApprovalEntries(RECORDID);
             END;

    CaptionML=[DAN=Returvaremodt.hoved;
               ENU=Return Receipt Header];
    LookupPageID=Page6662;
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
    { 9   ;   ;Bill-to City        ;Text30        ;TableRelation=IF (Bill-to Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Bill-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Bill-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(
                                                                  "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

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
    { 17  ;   ;Ship-to City        ;Text30        ;TableRelation=IF (Ship-to Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(
                                                                  "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

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
                                                   CalcFormula=Exist("Sales Comment Line" WHERE (Document Type=CONST(Posted Return Receipt),
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
    { 83  ;   ;Sell-to City        ;Text30        ;TableRelation=IF (Sell-to Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Sell-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Sell-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(
                                                                  "Sell-to City","Sell-to Post Code","Sell-to County","Sell-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kundeby;
                                                              ENU=Sell-to City] }
    { 84  ;   ;Sell-to Contact     ;Text50        ;CaptionML=[DAN=Kundeattention;
                                                              ENU=Sell-to Contact] }
    { 85  ;   ;Bill-to Post Code   ;Code20        ;TableRelation=IF (Bill-to Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Bill-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Bill-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(
                                                                  "Bill-to City","Bill-to Post Code","Bill-to County","Bill-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Faktureringspostnr.;
                                                              ENU=Bill-to Post Code] }
    { 86  ;   ;Bill-to County      ;Text30        ;CaptionML=[DAN=Faktureringsamt;
                                                              ENU=Bill-to County] }
    { 87  ;   ;Bill-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode til fakturering;
                                                              ENU=Bill-to Country/Region Code] }
    { 88  ;   ;Sell-to Post Code   ;Code20        ;TableRelation=IF (Sell-to Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Sell-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Sell-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(
                                                                  "Sell-to City","Sell-to Post Code","Sell-to County","Sell-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kundepostnr.;
                                                              ENU=Sell-to Post Code] }
    { 89  ;   ;Sell-to County      ;Text30        ;CaptionML=[DAN=Kundeamt;
                                                              ENU=Sell-to County] }
    { 90  ;   ;Sell-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode for kunde;
                                                              ENU=Sell-to Country/Region Code] }
    { 91  ;   ;Ship-to Post Code   ;Code20        ;TableRelation=IF (Ship-to Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(
                                                                  "Ship-to City","Ship-to Post Code","Ship-to County","Ship-to Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

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
                                                   CaptionML=[DAN=Speditõrkode;
                                                              ENU=Shipping Agent Code] }
    { 106 ;   ;Package Tracking No.;Text30        ;CaptionML=[DAN=Pakkesporingsnr.;
                                                              ENU=Package Tracking No.] }
    { 109 ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
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
    { 5790;   ;Requested Delivery Date;Date       ;CaptionML=[DAN=ùnsket leveringsdato;
                                                              ENU=Requested Delivery Date];
                                                   Editable=No }
    { 5791;   ;Promised Delivery Date;Date        ;CaptionML=[DAN=Bekrëftet leveringsdato;
                                                              ENU=Promised Delivery Date];
                                                   Editable=No }
    { 5792;   ;Shipping Time       ;DateFormula   ;CaptionML=[DAN=Transporttid;
                                                              ENU=Shipping Time];
                                                   Editable=No }
    { 5793;   ;Warehouse Handling Time;DateFormula;CaptionML=[DAN=Lagerekspeditionstid;
                                                              ENU=Warehouse Handling Time];
                                                   Editable=No }
    { 5797;   ;Late Order Shipping ;Boolean       ;CaptionML=[DAN=Forsinket leverance;
                                                              ENU=Late Order Shipping];
                                                   Editable=No }
    { 6601;   ;Return Order No.    ;Code20        ;CaptionML=[DAN=Returvareordrenr.;
                                                              ENU=Return Order No.] }
    { 6602;   ;Return Order No. Series;Code20     ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Returvareordrenr.serie;
                                                              ENU=Return Order No. Series] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Return Order No.                         }
    {    ;Sell-to Customer No.,External Document No. }
    {    ;Bill-to Customer No.                     }
    {    ;Posting Date                             }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ReturnRcptHeader@1000 : Record 6660;
      SalesCommentLine@1001 : Record 44;
      CustLedgEntry@1002 : Record 21;
      PostCode@1007 : Record 225;
      DimMgt@1004 : Codeunit 408;
      ApprovalsMgmt@1008 : Codeunit 1535;
      UserSetupMgt@1005 : Codeunit 5700;
      Text001@1006 : TextConst 'DAN=Bogfõrte dokumentdimensioner;ENU=Posted Document Dimensions';
      DocTxt@1003 : TextConst 'DAN=Kvittering;ENU=Receipt';

    [External]
    PROCEDURE PrintRecords@3(ShowRequestForm@1000 : Boolean);
    VAR
      ReportSelection@1001 : Record 77;
    BEGIN
      WITH ReturnRcptHeader DO BEGIN
        COPY(Rec);
        ReportSelection.PrintWithGUIYesNo(
          ReportSelection.Usage::"S.Ret.Rcpt.",ReturnRcptHeader,ShowRequestForm,FIELDNO("Bill-to Customer No."));
      END;
    END;

    [Internal]
    PROCEDURE EmailRecords@17(ShowDialog@1000 : Boolean);
    VAR
      DocumentSendingProfile@1003 : Record 60;
      DummyReportSelections@1001 : Record 77;
    BEGIN
      DocumentSendingProfile.TrySendToEMail(
        DummyReportSelections.Usage::"S.Ret.Rcpt.",Rec,FIELDNO("No."),DocTxt,FIELDNO("Bill-to Customer No."),ShowDialog);
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
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 - %3',TABLECAPTION,"No.",Text001));
    END;

    [External]
    PROCEDURE SetSecurityFilterOnRespCenter@4();
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

