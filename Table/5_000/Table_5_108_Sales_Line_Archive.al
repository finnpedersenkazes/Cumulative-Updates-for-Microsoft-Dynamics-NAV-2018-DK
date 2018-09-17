OBJECT Table 5108 Sales Line Archive
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836,NAVDK11.00.00.21836;
  }
  PROPERTIES
  {
    OnDelete=VAR
               SalesCommentLinearch@1000 : Record 5126;
               DeferralHeaderArchive@1001 : Record 5127;
             BEGIN
               SalesCommentLinearch.SETRANGE("Document Type","Document Type");
               SalesCommentLinearch.SETRANGE("No.","Document No.");
               SalesCommentLinearch.SETRANGE("Document Line No.","Line No.");
               SalesCommentLinearch.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               SalesCommentLinearch.SETRANGE("Version No.","Version No.");
               IF NOT SalesCommentLinearch.ISEMPTY THEN
                 SalesCommentLinearch.DELETEALL;

               IF "Deferral Code" <> '' THEN
                 DeferralHeaderArchive.DeleteHeader(DeferralUtilities.GetSalesDeferralDocType,
                   "Document Type","Document No.","Doc. No. Occurrence","Version No.","Line No.");
             END;

    CaptionML=[DAN=Salgslinjearkiv;
               ENU=Sales Line Archive];
    PasteIsValid=No;
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
    { 3   ;   ;Document No.        ;Code20        ;TableRelation="Sales Header Archive".No. WHERE (Document Type=FIELD(Document Type),
                                                                                                   Version No.=FIELD(Version No.));
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 4   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 5   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,Ressource,Anlëg,Gebyr (vare)";
                                                                    ENU=" ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)"];
                                                   OptionString=[ ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)] }
    { 6   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(" ")) "Standard Text"
                                                                 ELSE IF (Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(Resource)) Resource
                                                                 ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 7   ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 8   ;   ;Posting Group       ;Code20        ;TableRelation=IF (Type=CONST(Item)) "Inventory Posting Group"
                                                                 ELSE IF (Type=CONST(Fixed Asset)) "FA Posting Group";
                                                   CaptionML=[DAN=Bogfõringsgruppe;
                                                              ENU=Posting Group] }
    { 9   ;   ;Quantity Disc. Code ;Code20        ;CaptionML=[DAN=Mëngderabatkode;
                                                              ENU=Quantity Disc. Code] }
    { 10  ;   ;Shipment Date       ;Date          ;CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
    { 11  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 12  ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 13  ;   ;Unit of Measure     ;Text10        ;CaptionML=[DAN=Enhed;
                                                              ENU=Unit of Measure] }
    { 15  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 16  ;   ;Outstanding Quantity;Decimal       ;CaptionML=[DAN=UdestÜende antal;
                                                              ENU=Outstanding Quantity];
                                                   DecimalPlaces=0:5 }
    { 17  ;   ;Qty. to Invoice     ;Decimal       ;CaptionML=[DAN=Fakturer (antal);
                                                              ENU=Qty. to Invoice];
                                                   DecimalPlaces=0:5 }
    { 18  ;   ;Qty. to Ship        ;Decimal       ;AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Lever (antal);
                                                              ENU=Qty. to Ship];
                                                   DecimalPlaces=0:5 }
    { 22  ;   ;Unit Price          ;Decimal       ;CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Unit Price")) }
    { 23  ;   ;Unit Cost (LCY)     ;Decimal       ;CaptionML=[DAN=Kostpris (RV);
                                                              ENU=Unit Cost (LCY)];
                                                   AutoFormatType=2 }
    { 25  ;   ;VAT %               ;Decimal       ;CaptionML=[DAN=Momspct.;
                                                              ENU=VAT %];
                                                   DecimalPlaces=0:5 }
    { 26  ;   ;Quantity Disc. %    ;Decimal       ;CaptionML=[DAN=Mëngderabatpct.;
                                                              ENU=Quantity Disc. %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 27  ;   ;Line Discount %     ;Decimal       ;CaptionML=[DAN=Linjerabatpct.;
                                                              ENU=Line Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 28  ;   ;Line Discount Amount;Decimal       ;CaptionML=[DAN=Linjerabatbelõb;
                                                              ENU=Line Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 29  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Belõb;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 30  ;   ;Amount Including VAT;Decimal       ;CaptionML=[DAN=Belõb inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 32  ;   ;Allow Invoice Disc. ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad fakturarabat;
                                                              ENU=Allow Invoice Disc.] }
    { 34  ;   ;Gross Weight        ;Decimal       ;CaptionML=[DAN=Bruttovëgt;
                                                              ENU=Gross Weight];
                                                   DecimalPlaces=0:5 }
    { 35  ;   ;Net Weight          ;Decimal       ;CaptionML=[DAN=Nettovëgt;
                                                              ENU=Net Weight];
                                                   DecimalPlaces=0:5 }
    { 36  ;   ;Units per Parcel    ;Decimal       ;CaptionML=[DAN=Antal pr. kolli;
                                                              ENU=Units per Parcel];
                                                   DecimalPlaces=0:5 }
    { 37  ;   ;Unit Volume         ;Decimal       ;CaptionML=[DAN=Rumfang;
                                                              ENU=Unit Volume];
                                                   DecimalPlaces=0:5 }
    { 38  ;   ;Appl.-to Item Entry ;Integer       ;AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udl.varepostlõbenr.;
                                                              ENU=Appl.-to Item Entry] }
    { 40  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 41  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 42  ;   ;Price Group Code    ;Code10        ;TableRelation="Customer Price Group";
                                                   CaptionML=[DAN=Prisgruppekode;
                                                              ENU=Price Group Code] }
    { 43  ;   ;Allow Quantity Disc.;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad mëngderabat;
                                                              ENU=Allow Quantity Disc.] }
    { 45  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 52  ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 55  ;   ;Cust./Item Disc. %  ;Decimal       ;CaptionML=[DAN=Deb./varerabatpct.;
                                                              ENU=Cust./Item Disc. %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 57  ;   ;Outstanding Amount  ;Decimal       ;CaptionML=[DAN=UdestÜende belõb;
                                                              ENU=Outstanding Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 58  ;   ;Qty. Shipped Not Invoiced;Decimal  ;CaptionML=[DAN=Lev. antal (ufakt.);
                                                              ENU=Qty. Shipped Not Invoiced];
                                                   DecimalPlaces=0:5 }
    { 59  ;   ;Shipped Not Invoiced;Decimal       ;CaptionML=[DAN=Lev. belõb (ufakt.);
                                                              ENU=Shipped Not Invoiced];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 60  ;   ;Quantity Shipped    ;Decimal       ;AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Leveret (antal);
                                                              ENU=Quantity Shipped];
                                                   DecimalPlaces=0:5 }
    { 61  ;   ;Quantity Invoiced   ;Decimal       ;CaptionML=[DAN=Faktureret (antal);
                                                              ENU=Quantity Invoiced];
                                                   DecimalPlaces=0:5 }
    { 63  ;   ;Shipment No.        ;Code20        ;CaptionML=[DAN=Leverancenr.;
                                                              ENU=Shipment No.] }
    { 64  ;   ;Shipment Line No.   ;Integer       ;CaptionML=[DAN=Salgslev.linjenr.;
                                                              ENU=Shipment Line No.] }
    { 67  ;   ;Profit %            ;Decimal       ;CaptionML=[DAN=Avancepct.;
                                                              ENU=Profit %];
                                                   DecimalPlaces=0:5 }
    { 68  ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.] }
    { 69  ;   ;Inv. Discount Amount;Decimal       ;CaptionML=[DAN=Fakturarabatbelõb;
                                                              ENU=Inv. Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 71  ;   ;Purchase Order No.  ;Code20        ;TableRelation=IF (Drop Shipment=CONST(Yes)) "Purchase Header".No. WHERE (Document Type=CONST(Order));
                                                   CaptionML=[DAN=Kõbsordrenr.;
                                                              ENU=Purchase Order No.] }
    { 72  ;   ;Purch. Order Line No.;Integer      ;TableRelation=IF (Drop Shipment=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                                 Document No.=FIELD(Purchase Order No.));
                                                   CaptionML=[DAN=Kõbsordrelinjenr.;
                                                              ENU=Purch. Order Line No.] }
    { 73  ;   ;Drop Shipment       ;Boolean       ;AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Direkte levering;
                                                              ENU=Drop Shipment] }
    { 74  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 75  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogfõringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 77  ;   ;VAT Calculation Type;Option        ;CaptionML=[DAN=Momsberegningstype;
                                                              ENU=VAT Calculation Type];
                                                   OptionCaptionML=[DAN=Normal moms,Modtagermoms,Momskorrektion,Sales tax;
                                                                    ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax }
    { 78  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   CaptionML=[DAN=Transaktionsart;
                                                              ENU=Transaction Type] }
    { 79  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   CaptionML=[DAN=TransportmÜde;
                                                              ENU=Transport Method] }
    { 80  ;   ;Attached to Line No.;Integer       ;TableRelation="Sales Line Archive"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                                                        Document No.=FIELD(Document No.),
                                                                                                        Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                                                        Version No.=FIELD(Version No.));
                                                   CaptionML=[DAN=Tilknyttet linjenr.;
                                                              ENU=Attached to Line No.] }
    { 81  ;   ;Exit Point          ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=[DAN=Udfõrselssted;
                                                              ENU=Exit Point] }
    { 82  ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=[DAN=OmrÜde;
                                                              ENU=Area] }
    { 83  ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 85  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=SkatteomrÜdekode;
                                                              ENU=Tax Area Code] }
    { 86  ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 87  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 88  ;   ;VAT Clause Code     ;Code20        ;TableRelation="VAT Clause";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=[DAN=Momsklausulkode;
                                                              ENU=VAT Clause Code] }
    { 89  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 90  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 91  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 92  ;   ;Outstanding Amount (LCY);Decimal   ;CaptionML=[DAN=UdestÜende belõb (RV);
                                                              ENU=Outstanding Amount (LCY)];
                                                   AutoFormatType=1 }
    { 93  ;   ;Shipped Not Invoiced (LCY);Decimal ;CaptionML=[DAN=Lev. belõb ufakt. (RV);
                                                              ENU=Shipped Not Invoiced (LCY)];
                                                   AutoFormatType=1 }
    { 96  ;   ;Reserve             ;Option        ;AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Reserver;
                                                              ENU=Reserve];
                                                   OptionCaptionML=[DAN=Aldrig,Eventuelt,Altid;
                                                                    ENU=Never,Optional,Always];
                                                   OptionString=Never,Optional,Always }
    { 97  ;   ;Blanket Order No.   ;Code20        ;TableRelation="Sales Header".No. WHERE (Document Type=CONST(Blanket Order));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Rammeordrenr.;
                                                              ENU=Blanket Order No.] }
    { 98  ;   ;Blanket Order Line No.;Integer     ;TableRelation="Sales Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                                                                Document No.=FIELD(Blanket Order No.));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Rammeordrelinjenr.;
                                                              ENU=Blanket Order Line No.] }
    { 99  ;   ;VAT Base Amount     ;Decimal       ;CaptionML=[DAN=Momsgrundlag (belõb);
                                                              ENU=VAT Base Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 100 ;   ;Unit Cost           ;Decimal       ;CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 101 ;   ;System-Created Entry;Boolean       ;CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry] }
    { 103 ;   ;Line Amount         ;Decimal       ;CaptionML=[DAN=Linjebelõb;
                                                              ENU=Line Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Line Amount")) }
    { 104 ;   ;VAT Difference      ;Decimal       ;CaptionML=[DAN=Momsdifference;
                                                              ENU=VAT Difference];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 105 ;   ;Inv. Disc. Amount to Invoice;Decimal;
                                                   CaptionML=[DAN=Fakturer fakt.rabatbelõb;
                                                              ENU=Inv. Disc. Amount to Invoice];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 106 ;   ;VAT Identifier      ;Code20        ;CaptionML=[DAN=Moms-id;
                                                              ENU=VAT Identifier] }
    { 107 ;   ;IC Partner Ref. Type;Option        ;CaptionML=[DAN=Ref.type for IC-partner;
                                                              ENU=IC Partner Ref. Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,,,Gebyr (vare),Varereference,Fëlles varenr.";
                                                                    ENU=" ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No."];
                                                   OptionString=[ ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.] }
    { 108 ;   ;IC Partner Reference;Code20        ;CaptionML=[DAN=Reference for IC-partner;
                                                              ENU=IC Partner Reference] }
    { 109 ;   ;Prepayment %        ;Decimal       ;CaptionML=[DAN=Forudbetaling i %;
                                                              ENU=Prepayment %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 110 ;   ;Prepmt. Line Amount ;Decimal       ;CaptionML=[DAN=Linjebelõb for forudbetaling;
                                                              ENU=Prepmt. Line Amount];
                                                   MinValue=0;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt. Line Amount")) }
    { 111 ;   ;Prepmt. Amt. Inv.   ;Decimal       ;CaptionML=[DAN=Forudbetalt belõb faktureret;
                                                              ENU=Prepmt. Amt. Inv.];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt. Amt. Inv.")) }
    { 112 ;   ;Prepmt. Amt. Incl. VAT;Decimal     ;CaptionML=[DAN=Forudbetalingsbelõb inkl. moms;
                                                              ENU=Prepmt. Amt. Incl. VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 113 ;   ;Prepayment Amount   ;Decimal       ;CaptionML=[DAN=Forudbetalingsbelõb;
                                                              ENU=Prepayment Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 114 ;   ;Prepmt. VAT Base Amt.;Decimal      ;CaptionML=[DAN=Momsgrundlagsbelõb for forudbetaling;
                                                              ENU=Prepmt. VAT Base Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 115 ;   ;Prepayment VAT %    ;Decimal       ;CaptionML=[DAN=Moms i % af forudbetaling;
                                                              ENU=Prepayment VAT %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   Editable=No }
    { 116 ;   ;Prepmt. VAT Calc. Type;Option      ;CaptionML=[DAN=Beregningstype for moms af forudbetaling;
                                                              ENU=Prepmt. VAT Calc. Type];
                                                   OptionCaptionML=[DAN=Normal moms,Modtagermoms,Momskorrektion,Sales tax;
                                                                    ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax;
                                                   Editable=No }
    { 117 ;   ;Prepayment VAT Identifier;Code20   ;CaptionML=[DAN=Moms-id for forudbetaling;
                                                              ENU=Prepayment VAT Identifier];
                                                   Editable=No }
    { 118 ;   ;Prepayment Tax Area Code;Code20    ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=SkatteomrÜdekode for forudbetaling;
                                                              ENU=Prepayment Tax Area Code] }
    { 119 ;   ;Prepayment Tax Liable;Boolean      ;CaptionML=[DAN=Skattepligtig forudbetaling;
                                                              ENU=Prepayment Tax Liable] }
    { 120 ;   ;Prepayment Tax Group Code;Code20   ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Skattegruppekode for forudbetaling;
                                                              ENU=Prepayment Tax Group Code] }
    { 121 ;   ;Prepmt Amt to Deduct;Decimal       ;CaptionML=[DAN=Forudbetalingsbelõb, der fratrëkkes;
                                                              ENU=Prepmt Amt to Deduct];
                                                   MinValue=0;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt Amt to Deduct")) }
    { 122 ;   ;Prepmt Amt Deducted ;Decimal       ;CaptionML=[DAN=Fratrukket forudbetalingsbelõb;
                                                              ENU=Prepmt Amt Deducted];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code";
                                                   CaptionClass=GetCaptionClass(FIELDNO("Prepmt Amt Deducted")) }
    { 123 ;   ;Prepayment Line     ;Boolean       ;CaptionML=[DAN=Forudbetalingslinje;
                                                              ENU=Prepayment Line];
                                                   Editable=No }
    { 124 ;   ;Prepmt. Amount Inv. Incl. VAT;Decimal;
                                                   CaptionML=[DAN=Forudbetalt belõb faktureret inkl. moms;
                                                              ENU=Prepmt. Amount Inv. Incl. VAT];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 130 ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=IC-partner kode;
                                                              ENU=IC Partner Code] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 1700;   ;Deferral Code       ;Code10        ;TableRelation="Deferral Template"."Deferral Code";
                                                   CaptionML=[DAN=Periodiseringskode;
                                                              ENU=Deferral Code] }
    { 1702;   ;Returns Deferral Start Date;Date   ;CaptionML=[DAN=Returnerer startdato for periodisering;
                                                              ENU=Returns Deferral Start Date] }
    { 5047;   ;Version No.         ;Integer       ;CaptionML=[DAN=Versionsnr.;
                                                              ENU=Version No.] }
    { 5048;   ;Doc. No. Occurrence ;Integer       ;CaptionML=[DAN=Forekomster af dok.nr.;
                                                              ENU=Doc. No. Occurrence] }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5403;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;InitValue=1;
                                                   CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5 }
    { 5405;   ;Planned             ;Boolean       ;CaptionML=[DAN=Planlagt;
                                                              ENU=Planned] }
    { 5407;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE "Unit of Measure";
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 5415;   ;Quantity (Base)     ;Decimal       ;CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 5416;   ;Outstanding Qty. (Base);Decimal    ;CaptionML=[DAN=UdestÜende antal (basis);
                                                              ENU=Outstanding Qty. (Base)];
                                                   DecimalPlaces=0:5 }
    { 5417;   ;Qty. to Invoice (Base);Decimal     ;CaptionML=[DAN=Fakturer antal (basis);
                                                              ENU=Qty. to Invoice (Base)];
                                                   DecimalPlaces=0:5 }
    { 5418;   ;Qty. to Ship (Base) ;Decimal       ;CaptionML=[DAN=Lever antal (basis);
                                                              ENU=Qty. to Ship (Base)];
                                                   DecimalPlaces=0:5 }
    { 5458;   ;Qty. Shipped Not Invd. (Base);Decimal;
                                                   CaptionML=[DAN=Lev. antal ufakt. (basis);
                                                              ENU=Qty. Shipped Not Invd. (Base)];
                                                   DecimalPlaces=0:5 }
    { 5460;   ;Qty. Shipped (Base) ;Decimal       ;CaptionML=[DAN=Leveret antal (basis);
                                                              ENU=Qty. Shipped (Base)];
                                                   DecimalPlaces=0:5 }
    { 5461;   ;Qty. Invoiced (Base);Decimal       ;CaptionML=[DAN=Faktureret antal (basis);
                                                              ENU=Qty. Invoiced (Base)];
                                                   DecimalPlaces=0:5 }
    { 5600;   ;FA Posting Date     ;Date          ;CaptionML=[DAN=Bogfõringsdato for anlëg;
                                                              ENU=FA Posting Date] }
    { 5602;   ;Depreciation Book Code;Code10      ;TableRelation="Depreciation Book";
                                                   CaptionML=[DAN=Afskrivningsprofilkode;
                                                              ENU=Depreciation Book Code] }
    { 5605;   ;Depr. until FA Posting Date;Boolean;CaptionML=[DAN=Afskriv til bogfõringsdato for anlëg;
                                                              ENU=Depr. until FA Posting Date] }
    { 5612;   ;Duplicate in Depreciation Book;Code10;
                                                   TableRelation="Depreciation Book";
                                                   CaptionML=[DAN=Kopier til afskr.profil;
                                                              ENU=Duplicate in Depreciation Book] }
    { 5613;   ;Use Duplication List;Boolean       ;CaptionML=[DAN=Brug kopiliste;
                                                              ENU=Use Duplication List] }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 5701;   ;Out-of-Stock Substitution;Boolean  ;CaptionML=[DAN=Erstatningsvare;
                                                              ENU=Out-of-Stock Substitution] }
    { 5702;   ;Substitution Available;Boolean     ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Item Substitution" WHERE (Type=CONST(Item),
                                                                                                No.=FIELD(No.),
                                                                                                Substitute Type=CONST(Item)));
                                                   CaptionML=[DAN=Erstatningsvare findes;
                                                              ENU=Substitution Available];
                                                   Editable=No }
    { 5703;   ;Originally Ordered No.;Code20      ;TableRelation=IF (Type=CONST(Item)) Item;
                                                   CaptionML=[DAN=Oprindeligt bestilt nr.;
                                                              ENU=Originally Ordered No.] }
    { 5704;   ;Originally Ordered Var. Code;Code10;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(Originally Ordered No.));
                                                   CaptionML=[DAN=Oprind. bestilt variantkode;
                                                              ENU=Originally Ordered Var. Code] }
    { 5705;   ;Cross-Reference No. ;Code20        ;AccessByPermission=TableData 5717=R;
                                                   CaptionML=[DAN=Varereferencenr.;
                                                              ENU=Cross-Reference No.] }
    { 5706;   ;Unit of Measure (Cross Ref.);Code10;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
                                                   CaptionML=[DAN=Enhed (vareref.);
                                                              ENU=Unit of Measure (Cross Ref.)] }
    { 5707;   ;Cross-Reference Type;Option        ;CaptionML=[DAN=Varereferencetype;
                                                              ENU=Cross-Reference Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Stregkode";
                                                                    ENU=" ,Customer,Vendor,Bar Code"];
                                                   OptionString=[ ,Customer,Vendor,Bar Code] }
    { 5708;   ;Cross-Reference Type No.;Code30    ;CaptionML=[DAN=Varereferencetypenr.;
                                                              ENU=Cross-Reference Type No.] }
    { 5709;   ;Item Category Code  ;Code20        ;TableRelation="Item Category";
                                                   CaptionML=[DAN=Varekategorikode;
                                                              ENU=Item Category Code] }
    { 5710;   ;Nonstock            ;Boolean       ;CaptionML=[DAN=Katalogvare;
                                                              ENU=Nonstock] }
    { 5711;   ;Purchasing Code     ;Code10        ;TableRelation=Purchasing;
                                                   CaptionML=[DAN=Indkõbskode;
                                                              ENU=Purchasing Code] }
    { 5712;   ;Product Group Code  ;Code10        ;TableRelation="Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
                                                   ValidateTableRelation=No;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Product Groups became first level children of Item Categories.;
                                                   CaptionML=[DAN=Produktgruppekode;
                                                              ENU=Product Group Code] }
    { 5713;   ;Special Order       ;Boolean       ;CaptionML=[DAN=Specialordre;
                                                              ENU=Special Order] }
    { 5714;   ;Special Order Purchase No.;Code20  ;TableRelation=IF (Special Order=CONST(Yes)) "Purchase Header".No. WHERE (Document Type=CONST(Order));
                                                   CaptionML=[DAN=Kõbsordrenr. for specialordre;
                                                              ENU=Special Order Purchase No.] }
    { 5715;   ;Special Order Purch. Line No.;Integer;
                                                   TableRelation=IF (Special Order=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                                                                 Document No.=FIELD(Special Order Purchase No.));
                                                   CaptionML=[DAN=Kõbslinjenr. for specialordre;
                                                              ENU=Special Order Purch. Line No.] }
    { 5752;   ;Completely Shipped  ;Boolean       ;CaptionML=[DAN=Levering komplet;
                                                              ENU=Completely Shipped] }
    { 5790;   ;Requested Delivery Date;Date       ;AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=ùnsket leveringsdato;
                                                              ENU=Requested Delivery Date] }
    { 5791;   ;Promised Delivery Date;Date        ;CaptionML=[DAN=Bekrëftet leveringsdato;
                                                              ENU=Promised Delivery Date] }
    { 5792;   ;Shipping Time       ;DateFormula   ;AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Transporttid;
                                                              ENU=Shipping Time] }
    { 5793;   ;Outbound Whse. Handling Time;DateFormula;
                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=UdgÜende lagerekspeditionstid;
                                                              ENU=Outbound Whse. Handling Time] }
    { 5794;   ;Planned Delivery Date;Date         ;CaptionML=[DAN=Planlagt leveringsdato;
                                                              ENU=Planned Delivery Date] }
    { 5795;   ;Planned Shipment Date;Date         ;CaptionML=[DAN=Planlagt afsendelsesdato;
                                                              ENU=Planned Shipment Date] }
    { 5796;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Speditõrkode;
                                                              ENU=Shipping Agent Code] }
    { 5797;   ;Shipping Agent Service Code;Code10 ;TableRelation="Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));
                                                   CaptionML=[DAN=Speditõrservicekode;
                                                              ENU=Shipping Agent Service Code] }
    { 5800;   ;Allow Item Charge Assignment;Boolean;
                                                   InitValue=Yes;
                                                   AccessByPermission=TableData 5800=R;
                                                   CaptionML=[DAN=Tillad varegebyrtildeling;
                                                              ENU=Allow Item Charge Assignment] }
    { 5803;   ;Return Qty. to Receive;Decimal     ;CaptionML=[DAN=Antal til modtagelse retur;
                                                              ENU=Return Qty. to Receive];
                                                   DecimalPlaces=0:5 }
    { 5804;   ;Return Qty. to Receive (Base);Decimal;
                                                   CaptionML=[DAN=Ant. retur til modtag. (basis);
                                                              ENU=Return Qty. to Receive (Base)];
                                                   DecimalPlaces=0:5 }
    { 5805;   ;Return Qty. Rcd. Not Invd.;Decimal ;CaptionML=[DAN=Modtaget retur ufaktureret;
                                                              ENU=Return Qty. Rcd. Not Invd.];
                                                   DecimalPlaces=0:5 }
    { 5806;   ;Ret. Qty. Rcd. Not Invd.(Base);Decimal;
                                                   CaptionML=[DAN=Modtaget retur ufakt. (basis);
                                                              ENU=Ret. Qty. Rcd. Not Invd.(Base)];
                                                   DecimalPlaces=0:5 }
    { 5807;   ;Return Amt. Rcd. Not Invd.;Decimal ;CaptionML=[DAN=Modtaget retur ufakt. (belõb);
                                                              ENU=Return Amt. Rcd. Not Invd.];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 5808;   ;Ret. Amt. Rcd. Not Invd. (LCY);Decimal;
                                                   CaptionML=[DAN=Modtaget retur ufakt. (RV);
                                                              ENU=Ret. Amt. Rcd. Not Invd. (LCY)];
                                                   AutoFormatType=1 }
    { 5809;   ;Return Qty. Received;Decimal       ;CaptionML=[DAN=Antal modtaget retur;
                                                              ENU=Return Qty. Received];
                                                   DecimalPlaces=0:5 }
    { 5810;   ;Return Qty. Received (Base);Decimal;CaptionML=[DAN=Antal modtaget retur (basis);
                                                              ENU=Return Qty. Received (Base)];
                                                   DecimalPlaces=0:5 }
    { 5811;   ;Appl.-from Item Entry;Integer      ;AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udlign fra-varepost;
                                                              ENU=Appl.-from Item Entry];
                                                   MinValue=0 }
    { 5900;   ;Service Contract No.;Code20        ;TableRelation="Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract),
                                                                                                                 Customer No.=FIELD(Sell-to Customer No.),
                                                                                                                 Bill-to Customer No.=FIELD(Bill-to Customer No.));
                                                   CaptionML=[DAN=Servicekontraktnr.;
                                                              ENU=Service Contract No.] }
    { 5901;   ;Service Order No.   ;Code20        ;CaptionML=[DAN=Serviceordrenr.;
                                                              ENU=Service Order No.] }
    { 5902;   ;Service Item No.    ;Code20        ;TableRelation="Service Item".No. WHERE (Customer No.=FIELD(Sell-to Customer No.));
                                                   CaptionML=[DAN=Serviceartikelnr.;
                                                              ENU=Service Item No.] }
    { 5903;   ;Appl.-to Service Entry;Integer     ;CaptionML=[DAN=Udl.servicepostlõbenr.;
                                                              ENU=Appl.-to Service Entry] }
    { 5904;   ;Service Item Line No.;Integer      ;CaptionML=[DAN=Serviceartikellinjenr.;
                                                              ENU=Service Item Line No.] }
    { 5907;   ;Serv. Price Adjmt. Gr. Code;Code10 ;TableRelation="Service Price Adjustment Group";
                                                   CaptionML=[DAN=Serviceprisreg.gruppekode;
                                                              ENU=Serv. Price Adjmt. Gr. Code] }
    { 5909;   ;BOM Item No.        ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Styklistevarenr.;
                                                              ENU=BOM Item No.] }
    { 6600;   ;Return Receipt No.  ;Code20        ;CaptionML=[DAN=Returvaremodt.nr.;
                                                              ENU=Return Receipt No.] }
    { 6601;   ;Return Receipt Line No.;Integer    ;CaptionML=[DAN=Returvarekvit.linjenr.;
                                                              ENU=Return Receipt Line No.] }
    { 6608;   ;Return Reason Code  ;Code10        ;TableRelation="Return Reason";
                                                   CaptionML=[DAN=ReturÜrsagskode;
                                                              ENU=Return Reason Code] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
    { 7002;   ;Customer Disc. Group;Code20        ;TableRelation="Customer Discount Group";
                                                   CaptionML=[DAN=Debitorrabatgruppe;
                                                              ENU=Customer Disc. Group] }
    { 13602;  ;Account Code        ;Text30        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontokode;
                                                              ENU=Account Code] }
  }
  KEYS
  {
    {    ;Document Type,Document No.,Doc. No. Occurrence,Version No.,Line No.;
                                                   SumIndexFields=Amount,Amount Including VAT,Outstanding Amount,Shipped Not Invoiced,Outstanding Amount (LCY),Shipped Not Invoiced (LCY);
                                                   Clustered=Yes }
    {    ;Document Type,Document No.,Line No.,Doc. No. Occurrence,Version No. }
    {    ;Sell-to Customer No.                     }
    {    ;Bill-to Customer No.                     }
    {    ;Type,No.                                 }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      DimMgt@1000 : Codeunit 408;
      DeferralUtilities@1001 : Codeunit 1720;

    LOCAL PROCEDURE GetCaptionClass@34(FieldNumber@1000 : Integer) : Text[80];
    VAR
      SalesHeaderArchive@1001 : Record 5107;
    BEGIN
      IF NOT SalesHeaderArchive.GET("Document Type","Document No.","Doc. No. Occurrence","Version No.") THEN BEGIN
        SalesHeaderArchive."No." := '';
        SalesHeaderArchive.INIT;
      END;
      IF SalesHeaderArchive."Prices Including VAT" THEN
        EXIT('2,1,' + GetFieldCaption(FieldNumber));

      EXIT('2,0,' + GetFieldCaption(FieldNumber));
    END;

    LOCAL PROCEDURE GetFieldCaption@31(FieldNumber@1000 : Integer) : Text[100];
    VAR
      Field@1001 : Record 2000000041;
    BEGIN
      Field.GET(DATABASE::"Sales Line",FieldNumber);
      EXIT(Field."Field Caption");
    END;

    [External]
    PROCEDURE ShowDimensions@25();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","Document No."));
    END;

    [External]
    PROCEDURE ShowLineComments@1();
    VAR
      SalesCommentLineArch@1000 : Record 5126;
      SalesArchCommentSheet@1001 : Page 5180;
    BEGIN
      SalesCommentLineArch.SETRANGE("Document Type","Document Type");
      SalesCommentLineArch.SETRANGE("No.","Document No.");
      SalesCommentLineArch.SETRANGE("Document Line No.","Line No.");
      SalesCommentLineArch.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
      SalesCommentLineArch.SETRANGE("Version No.","Version No.");
      CLEAR(SalesArchCommentSheet);
      SalesArchCommentSheet.SETTABLEVIEW(SalesCommentLineArch);
      SalesArchCommentSheet.RUNMODAL;
    END;

    [External]
    PROCEDURE ShowDeferrals@2();
    BEGIN
      DeferralUtilities.OpenLineScheduleArchive(
        "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,
        "Document Type","Document No.",
        "Doc. No. Occurrence","Version No.","Line No.");
    END;

    [External]
    PROCEDURE CopyTempLines@4(SalesHeaderArchive@1003 : Record 5107;VAR TempSalesLine@1000 : TEMPORARY Record 37);
    VAR
      SalesLineArchive@1001 : Record 5108;
    BEGIN
      DELETEALL;

      SalesLineArchive.SETRANGE("Document Type",SalesHeaderArchive."Document Type");
      SalesLineArchive.SETRANGE("Document No.",SalesHeaderArchive."No.");
      SalesLineArchive.SETRANGE("Version No.",SalesHeaderArchive."Version No.");
      IF SalesLineArchive.FINDSET THEN
        REPEAT
          INIT;
          Rec := SalesLineArchive;
          INSERT;
          TempSalesLine.TRANSFERFIELDS(SalesLineArchive);
          TempSalesLine.INSERT;
        UNTIL SalesLineArchive.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

