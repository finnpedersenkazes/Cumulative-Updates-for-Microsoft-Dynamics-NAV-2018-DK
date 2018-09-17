OBJECT Table 121 Purch. Rcpt. Line
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    Permissions=TableData 32=r,
                TableData 5802=r;
    OnDelete=VAR
               PurchDocLineComments@1000 : Record 43;
             BEGIN
               PurchDocLineComments.SETRANGE("Document Type",PurchDocLineComments."Document Type"::Receipt);
               PurchDocLineComments.SETRANGE("No.","Document No.");
               PurchDocLineComments.SETRANGE("Document Line No.","Line No.");
               IF NOT PurchDocLineComments.ISEMPTY THEN
                 PurchDocLineComments.DELETEALL;
             END;

    CaptionML=[DAN=Kõbsleverancelinje;
               ENU=Purch. Rcpt. Line];
    LookupPageID=Page528;
    DrillDownPageID=Page528;
  }
  FIELDS
  {
    { 2   ;   ;Buy-from Vendor No. ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Leverandõrnr.;
                                                              ENU=Buy-from Vendor No.];
                                                   Editable=No }
    { 3   ;   ;Document No.        ;Code20        ;TableRelation="Purch. Rcpt. Header";
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 4   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 5   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,,Anlëg,Gebyr (vare)";
                                                                    ENU=" ,G/L Account,Item,,Fixed Asset,Charge (Item)"];
                                                   OptionString=[ ,G/L Account,Item,,Fixed Asset,Charge (Item)] }
    { 6   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   CaptionClass=GetCaptionClass(FIELDNO("No.")) }
    { 7   ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 8   ;   ;Posting Group       ;Code20        ;TableRelation=IF (Type=CONST(Item)) "Inventory Posting Group"
                                                                 ELSE IF (Type=CONST(Fixed Asset)) "FA Posting Group";
                                                   CaptionML=[DAN=Bogfõringsgruppe;
                                                              ENU=Posting Group];
                                                   Editable=No }
    { 10  ;   ;Expected Receipt Date;Date         ;CaptionML=[DAN=Forventet modt.dato;
                                                              ENU=Expected Receipt Date] }
    { 11  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 12  ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 13  ;   ;Unit of Measure     ;Text10        ;CaptionML=[DAN=Enhed;
                                                              ENU=Unit of Measure] }
    { 15  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 22  ;   ;Direct Unit Cost    ;Decimal       ;CaptionML=[DAN=Kõbspris;
                                                              ENU=Direct Unit Cost];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr=GetCurrencyCodeFromHeader }
    { 23  ;   ;Unit Cost (LCY)     ;Decimal       ;CaptionML=[DAN=Kostpris (RV);
                                                              ENU=Unit Cost (LCY)];
                                                   AutoFormatType=2 }
    { 25  ;   ;VAT %               ;Decimal       ;CaptionML=[DAN=Momspct.;
                                                              ENU=VAT %];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 27  ;   ;Line Discount %     ;Decimal       ;CaptionML=[DAN=Linjerabatpct.;
                                                              ENU=Line Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 31  ;   ;Unit Price (LCY)    ;Decimal       ;CaptionML=[DAN=Enhedspris (RV);
                                                              ENU=Unit Price (LCY)];
                                                   AutoFormatType=2 }
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
    { 39  ;   ;Item Rcpt. Entry No.;Integer       ;CaptionML=[DAN=Varelev.postlõbenr.;
                                                              ENU=Item Rcpt. Entry No.] }
    { 40  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 41  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 45  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 54  ;   ;Indirect Cost %     ;Decimal       ;CaptionML=[DAN=Indir. omkost.pct.;
                                                              ENU=Indirect Cost %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 58  ;   ;Qty. Rcd. Not Invoiced;Decimal     ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Modt. antal (ufakt.);
                                                              ENU=Qty. Rcd. Not Invoiced];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 61  ;   ;Quantity Invoiced   ;Decimal       ;CaptionML=[DAN=Faktureret (antal);
                                                              ENU=Quantity Invoiced];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 65  ;   ;Order No.           ;Code20        ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.] }
    { 66  ;   ;Order Line No.      ;Integer       ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Ordrelinjenr.;
                                                              ENU=Order Line No.] }
    { 68  ;   ;Pay-to Vendor No.   ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Faktureringsleverandõrnr.;
                                                              ENU=Pay-to Vendor No.] }
    { 70  ;   ;Vendor Item No.     ;Text20        ;CaptionML=[DAN=Leverandõrs varenr.;
                                                              ENU=Vendor Item No.] }
    { 71  ;   ;Sales Order No.     ;Code20        ;CaptionML=[DAN=Salgsordrenr.;
                                                              ENU=Sales Order No.] }
    { 72  ;   ;Sales Order Line No.;Integer       ;CaptionML=[DAN=Salgsordrelinjenr.;
                                                              ENU=Sales Order Line No.] }
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
    { 80  ;   ;Attached to Line No.;Integer       ;TableRelation="Purch. Rcpt. Line"."Line No." WHERE (Document No.=FIELD(Document No.));
                                                   CaptionML=[DAN=Tilknyttet linjenr.;
                                                              ENU=Attached to Line No.] }
    { 81  ;   ;Entry Point         ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=[DAN=Indfõrselssted;
                                                              ENU=Entry Point] }
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
    { 88  ;   ;Use Tax             ;Boolean       ;CaptionML=[DAN=Use Tax;
                                                              ENU=Use Tax] }
    { 89  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 90  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 91  ;   ;Currency Code       ;Code10        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Purch. Rcpt. Header"."Currency Code" WHERE (No.=FIELD(Document No.)));
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code];
                                                   Editable=No }
    { 97  ;   ;Blanket Order No.   ;Code20        ;TableRelation="Purchase Header".No. WHERE (Document Type=CONST(Blanket Order));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Rammeordrenr.;
                                                              ENU=Blanket Order No.] }
    { 98  ;   ;Blanket Order Line No.;Integer     ;TableRelation="Purchase Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                                                                   Document No.=FIELD(Blanket Order No.));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Rammeordrelinjenr.;
                                                              ENU=Blanket Order Line No.] }
    { 99  ;   ;VAT Base Amount     ;Decimal       ;CaptionML=[DAN=Momsgrundlag (belõb);
                                                              ENU=VAT Base Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCodeFromHeader }
    { 100 ;   ;Unit Cost           ;Decimal       ;CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   Editable=No;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr=GetCurrencyCodeFromHeader }
    { 107 ;   ;IC Partner Ref. Type;Option        ;DataClassification=CustomerContent;
                                                   CaptionML=[DAN=IC Partner Ref. Type;
                                                              ENU=IC Partner Ref. Type];
                                                   OptionCaptionML=[DAN=" ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No.";
                                                                    ENU=" ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No."];
                                                   OptionString=[ ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No.] }
    { 108 ;   ;IC Partner Reference;Code20        ;DataClassification=CustomerContent;
                                                   CaptionML=[DAN=IC Partner Reference;
                                                              ENU=IC Partner Reference] }
    { 131 ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 1001;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 1002;   ;Job Line Type       ;Option        ;CaptionML=[DAN=Linjetype for sag;
                                                              ENU=Job Line Type];
                                                   OptionCaptionML=[DAN=" ,Budget,Fakturerbar,BÜde budget og fakturerbar";
                                                                    ENU=" ,Budget,Billable,Both Budget and Billable"];
                                                   OptionString=[ ,Budget,Billable,Both Budget and Billable] }
    { 1003;   ;Job Unit Price      ;Decimal       ;CaptionML=[DAN=Enhedspris for sag;
                                                              ENU=Job Unit Price];
                                                   BlankZero=Yes }
    { 1004;   ;Job Total Price     ;Decimal       ;CaptionML=[DAN=Salgsbelõb for sag;
                                                              ENU=Job Total Price];
                                                   BlankZero=Yes }
    { 1005;   ;Job Line Amount     ;Decimal       ;CaptionML=[DAN=Linjebelõb for sag;
                                                              ENU=Job Line Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1006;   ;Job Line Discount Amount;Decimal   ;CaptionML=[DAN=Linjerabatbelõb for sag;
                                                              ENU=Job Line Discount Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Job Currency Code" }
    { 1007;   ;Job Line Discount % ;Decimal       ;CaptionML=[DAN=Linjerabat for sag i %;
                                                              ENU=Job Line Discount %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   BlankZero=Yes }
    { 1008;   ;Job Unit Price (LCY);Decimal       ;CaptionML=[DAN=Enhedspris for sag (RV);
                                                              ENU=Job Unit Price (LCY)];
                                                   BlankZero=Yes }
    { 1009;   ;Job Total Price (LCY);Decimal      ;CaptionML=[DAN=Salgsbelõb for sag (RV);
                                                              ENU=Job Total Price (LCY)];
                                                   BlankZero=Yes }
    { 1010;   ;Job Line Amount (LCY);Decimal      ;CaptionML=[DAN=Linjebelõb for sag (RV);
                                                              ENU=Job Line Amount (LCY)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 1011;   ;Job Line Disc. Amount (LCY);Decimal;CaptionML=[DAN=Linjerabatbelõb for sag (RV);
                                                              ENU=Job Line Disc. Amount (LCY)];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 1012;   ;Job Currency Factor ;Decimal       ;CaptionML=[DAN=Valutafaktor for sag;
                                                              ENU=Job Currency Factor];
                                                   BlankZero=Yes }
    { 1013;   ;Job Currency Code   ;Code20        ;CaptionML=[DAN=Valutakode for sag;
                                                              ENU=Job Currency Code] }
    { 5401;   ;Prod. Order No.     ;Code20        ;TableRelation="Production Order".No. WHERE (Status=FILTER(Released|Finished));
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Prod.ordrenr.;
                                                              ENU=Prod. Order No.] }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5403;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                 Item Filter=FIELD(No.),
                                                                                 Variant Filter=FIELD(Variant Code));
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5407;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE "Unit of Measure";
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 5415;   ;Quantity (Base)     ;Decimal       ;CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)];
                                                   DecimalPlaces=0:5 }
    { 5461;   ;Qty. Invoiced (Base);Decimal       ;CaptionML=[DAN=Faktureret antal (basis);
                                                              ENU=Qty. Invoiced (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5600;   ;FA Posting Date     ;Date          ;CaptionML=[DAN=Bogfõringsdato for anlëg;
                                                              ENU=FA Posting Date] }
    { 5601;   ;FA Posting Type     ;Option        ;CaptionML=[DAN=Anlëgsbogfõringstype;
                                                              ENU=FA Posting Type];
                                                   OptionCaptionML=[DAN=" ,Anskaffelse,Reparation";
                                                                    ENU=" ,Acquisition Cost,Maintenance"];
                                                   OptionString=[ ,Acquisition Cost,Maintenance] }
    { 5602;   ;Depreciation Book Code;Code10      ;TableRelation="Depreciation Book";
                                                   CaptionML=[DAN=Afskrivningsprofilkode;
                                                              ENU=Depreciation Book Code] }
    { 5603;   ;Salvage Value       ;Decimal       ;CaptionML=[DAN=Skrapvërdi;
                                                              ENU=Salvage Value];
                                                   AutoFormatType=1 }
    { 5605;   ;Depr. until FA Posting Date;Boolean;CaptionML=[DAN=Afskriv til bogfõringsdato for anlëg;
                                                              ENU=Depr. until FA Posting Date] }
    { 5606;   ;Depr. Acquisition Cost;Boolean     ;CaptionML=[DAN=Afskriv anskaffelse;
                                                              ENU=Depr. Acquisition Cost] }
    { 5609;   ;Maintenance Code    ;Code10        ;TableRelation=Maintenance;
                                                   CaptionML=[DAN=Reparationskode;
                                                              ENU=Maintenance Code] }
    { 5610;   ;Insurance No.       ;Code20        ;TableRelation=Insurance;
                                                   CaptionML=[DAN=Forsikringsnr.;
                                                              ENU=Insurance No.] }
    { 5611;   ;Budgeted FA No.     ;Code20        ;TableRelation="Fixed Asset";
                                                   CaptionML=[DAN=Budgetanlëgsnr.;
                                                              ENU=Budgeted FA No.] }
    { 5612;   ;Duplicate in Depreciation Book;Code10;
                                                   TableRelation="Depreciation Book";
                                                   CaptionML=[DAN=Kopier til afskr.profil;
                                                              ENU=Duplicate in Depreciation Book] }
    { 5613;   ;Use Duplication List;Boolean       ;CaptionML=[DAN=Brug kopiliste;
                                                              ENU=Use Duplication List] }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
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
    { 5709;   ;Item Category Code  ;Code20        ;TableRelation=IF (Type=CONST(Item)) "Item Category";
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
    { 5714;   ;Special Order Sales No.;Code20     ;CaptionML=[DAN=Salgsordrenr. for specialordre;
                                                              ENU=Special Order Sales No.] }
    { 5715;   ;Special Order Sales Line No.;Integer;
                                                   CaptionML=[DAN=Salgslinjenr. for specialordre;
                                                              ENU=Special Order Sales Line No.] }
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
    { 5794;   ;Planned Receipt Date;Date          ;CaptionML=[DAN=Planlagt modtagelsesdato;
                                                              ENU=Planned Receipt Date] }
    { 5795;   ;Order Date          ;Date          ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Ordredato;
                                                              ENU=Order Date] }
    { 5811;   ;Item Charge Base Amount;Decimal    ;CaptionML=[DAN=Varegebyrgrundlag (belõb);
                                                              ENU=Item Charge Base Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCodeFromHeader }
    { 5817;   ;Correction          ;Boolean       ;CaptionML=[DAN=Rettelse;
                                                              ENU=Correction];
                                                   Editable=No }
    { 6608;   ;Return Reason Code  ;Code10        ;TableRelation="Return Reason";
                                                   CaptionML=[DAN=ReturÜrsagskode;
                                                              ENU=Return Reason Code] }
    { 99000750;;Routing No.        ;Code20        ;TableRelation="Routing Header";
                                                   CaptionML=[DAN=Rutenr.;
                                                              ENU=Routing No.] }
    { 99000751;;Operation No.      ;Code10        ;TableRelation="Prod. Order Routing Line"."Operation No." WHERE (Status=FILTER(Released..),
                                                                                                                   Prod. Order No.=FIELD(Prod. Order No.),
                                                                                                                   Routing No.=FIELD(Routing No.));
                                                   CaptionML=[DAN=Operationsnr.;
                                                              ENU=Operation No.] }
    { 99000752;;Work Center No.    ;Code20        ;TableRelation="Work Center";
                                                   CaptionML=[DAN=Arbejdscenternr.;
                                                              ENU=Work Center No.] }
    { 99000754;;Prod. Order Line No.;Integer      ;TableRelation="Prod. Order Line"."Line No." WHERE (Status=FILTER(Released..),
                                                                                                      Prod. Order No.=FIELD(Prod. Order No.));
                                                   CaptionML=[DAN=Prod.ordrelinjenr.;
                                                              ENU=Prod. Order Line No.] }
    { 99000755;;Overhead Rate      ;Decimal       ;CaptionML=[DAN=IPO-bidrag;
                                                              ENU=Overhead Rate];
                                                   DecimalPlaces=0:5 }
    { 99000759;;Routing Reference No.;Integer     ;CaptionML=[DAN=Rutereferencenr.;
                                                              ENU=Routing Reference No.] }
  }
  KEYS
  {
    {    ;Document No.,Line No.                   ;Clustered=Yes }
    {    ;Order No.,Order Line No.                 }
    {    ;Blanket Order No.,Blanket Order Line No. }
    {    ;Item Rcpt. Entry No.                     }
    {    ;Pay-to Vendor No.                        }
    {    ;Buy-from Vendor No.                      }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Modtagelse nr. %1:;ENU=Receipt No. %1:';
      Text001@1001 : TextConst 'DAN=Kõbslinjen blev ikke fundet.;ENU=The program cannot find this purchase line.';
      Currency@1005 : Record 4;
      PurchRcptHeader@1004 : Record 120;
      DimMgt@1003 : Codeunit 408;
      CurrencyRead@1002 : Boolean;

    [External]
    PROCEDURE GetCurrencyCodeFromHeader@1() : Code[10];
    BEGIN
      IF "Document No." = PurchRcptHeader."No." THEN
        EXIT(PurchRcptHeader."Currency Code");
      IF PurchRcptHeader.GET("Document No.") THEN
        EXIT(PurchRcptHeader."Currency Code");
      EXIT('');
    END;

    [External]
    PROCEDURE ShowDimensions@25();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Document No.","Line No."));
    END;

    [External]
    PROCEDURE ShowItemTrackingLines@3();
    VAR
      ItemTrackingDocMgt@1000 : Codeunit 6503;
    BEGIN
      ItemTrackingDocMgt.ShowItemTrackingForShptRcptLine(DATABASE::"Purch. Rcpt. Line",0,"Document No.",'',0,"Line No.");
    END;

    [External]
    PROCEDURE InsertInvLineFromRcptLine@2(VAR PurchLine@1000 : Record 39);
    VAR
      PurchInvHeader@1010 : Record 38;
      PurchOrderHeader@1007 : Record 38;
      PurchOrderLine@1005 : Record 39;
      TempPurchLine@1003 : TEMPORARY Record 39;
      TransferOldExtLines@1002 : Codeunit 379;
      ItemTrackingMgt@1004 : Codeunit 6500;
      LanguageManagement@1008 : Codeunit 43;
      NextLineNo@1001 : Integer;
      ExtTextLine@1006 : Boolean;
      Handled@1009 : Boolean;
    BEGIN
      SETRANGE("Document No.","Document No.");

      TempPurchLine := PurchLine;
      IF PurchLine.FIND('+') THEN
        NextLineNo := PurchLine."Line No." + 10000
      ELSE
        NextLineNo := 10000;

      IF PurchInvHeader."No." <> TempPurchLine."Document No." THEN
        PurchInvHeader.GET(TempPurchLine."Document Type",TempPurchLine."Document No.");

      IF PurchLine."Receipt No." <> "Document No." THEN BEGIN
        PurchLine.INIT;
        PurchLine."Line No." := NextLineNo;
        PurchLine."Document Type" := TempPurchLine."Document Type";
        PurchLine."Document No." := TempPurchLine."Document No.";
        LanguageManagement.SetGlobalLanguageByCode(PurchInvHeader."Language Code");
        PurchLine.Description := STRSUBSTNO(Text000,"Document No.");
        LanguageManagement.RestoreGlobalLanguage;
        OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine(Rec,PurchLine,NextLineNo,Handled);
        IF NOT Handled THEN BEGIN
          PurchLine.INSERT;
          NextLineNo := NextLineNo + 10000;
        END;
      END;

      TransferOldExtLines.ClearLineNumbers;

      REPEAT
        ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);

        IF PurchOrderLine.GET(
             PurchOrderLine."Document Type"::Order,"Order No.","Order Line No.") AND
           NOT ExtTextLine
        THEN BEGIN
          IF (PurchOrderHeader."Document Type" <> PurchOrderLine."Document Type"::Order) OR
             (PurchOrderHeader."No." <> PurchOrderLine."Document No.")
          THEN
            PurchOrderHeader.GET(PurchOrderLine."Document Type"::Order,"Order No.");

          InitCurrency("Currency Code");

          IF PurchInvHeader."Prices Including VAT" THEN BEGIN
            IF NOT PurchOrderHeader."Prices Including VAT" THEN
              PurchOrderLine."Direct Unit Cost" :=
                ROUND(
                  PurchOrderLine."Direct Unit Cost" * (1 + PurchOrderLine."VAT %" / 100),
                  Currency."Unit-Amount Rounding Precision");
          END ELSE BEGIN
            IF PurchOrderHeader."Prices Including VAT" THEN
              PurchOrderLine."Direct Unit Cost" :=
                ROUND(
                  PurchOrderLine."Direct Unit Cost" / (1 + PurchOrderLine."VAT %" / 100),
                  Currency."Unit-Amount Rounding Precision");
          END;
        END ELSE BEGIN
          IF ExtTextLine THEN BEGIN
            PurchOrderLine.INIT;
            PurchOrderLine."Line No." := "Order Line No.";
            PurchOrderLine.Description := Description;
            PurchOrderLine."Description 2" := "Description 2";
          END ELSE
            ERROR(Text001);
        END;
        PurchLine := PurchOrderLine;
        PurchLine."Line No." := NextLineNo;
        PurchLine."Document Type" := TempPurchLine."Document Type";
        PurchLine."Document No." := TempPurchLine."Document No.";
        PurchLine."Variant Code" := "Variant Code";
        PurchLine."Location Code" := "Location Code";
        PurchLine."Quantity (Base)" := 0;
        PurchLine.Quantity := 0;
        PurchLine."Outstanding Qty. (Base)" := 0;
        PurchLine."Outstanding Quantity" := 0;
        PurchLine."Quantity Received" := 0;
        PurchLine."Qty. Received (Base)" := 0;
        PurchLine."Quantity Invoiced" := 0;
        PurchLine."Qty. Invoiced (Base)" := 0;
        PurchLine.Amount := 0;
        PurchLine."Amount Including VAT" := 0;
        PurchLine."Sales Order No." := '';
        PurchLine."Sales Order Line No." := 0;
        PurchLine."Drop Shipment" := FALSE;
        PurchLine."Special Order Sales No." := '';
        PurchLine."Special Order Sales Line No." := 0;
        PurchLine."Special Order" := FALSE;
        PurchLine."Receipt No." := "Document No.";
        PurchLine."Receipt Line No." := "Line No.";
        PurchLine."Appl.-to Item Entry" := 0;
        IF NOT ExtTextLine THEN BEGIN
          PurchLine.VALIDATE(Quantity,Quantity - "Quantity Invoiced");
          PurchLine.VALIDATE("Direct Unit Cost",PurchOrderLine."Direct Unit Cost");
          PurchOrderLine."Line Discount Amount" :=
            ROUND(
              PurchOrderLine."Line Discount Amount" * PurchLine.Quantity / PurchOrderLine.Quantity,
              Currency."Amount Rounding Precision");
          IF PurchInvHeader."Prices Including VAT" THEN BEGIN
            IF NOT PurchOrderHeader."Prices Including VAT" THEN
              PurchOrderLine."Line Discount Amount" :=
                ROUND(
                  PurchOrderLine."Line Discount Amount" *
                  (1 + PurchOrderLine."VAT %" / 100),Currency."Amount Rounding Precision");
          END ELSE
            IF PurchOrderHeader."Prices Including VAT" THEN
              PurchOrderLine."Line Discount Amount" :=
                ROUND(
                  PurchOrderLine."Line Discount Amount" /
                  (1 + PurchOrderLine."VAT %" / 100),Currency."Amount Rounding Precision");
          PurchLine.VALIDATE("Line Discount Amount",PurchOrderLine."Line Discount Amount");
          PurchLine."Line Discount %" := PurchOrderLine."Line Discount %";
          PurchLine.UpdatePrePaymentAmounts;
          IF PurchOrderLine.Quantity = 0 THEN
            PurchLine.VALIDATE("Inv. Discount Amount",0)
          ELSE
            PurchLine.VALIDATE(
              "Inv. Discount Amount",
              ROUND(
                PurchOrderLine."Inv. Discount Amount" * PurchLine.Quantity / PurchOrderLine.Quantity,
                Currency."Amount Rounding Precision"));
        END;

        PurchLine."Attached to Line No." :=
          TransferOldExtLines.TransferExtendedText(
            "Line No.",
            NextLineNo,
            "Attached to Line No.");
        PurchLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        PurchLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        PurchLine."Dimension Set ID" := "Dimension Set ID";

        IF "Sales Order No." = '' THEN
          PurchLine."Drop Shipment" := FALSE
        ELSE
          PurchLine."Drop Shipment" := TRUE;

        OnBeforeInsertInvLineFromRcptLine(Rec,PurchLine);
        PurchLine.INSERT;
        OnAfterInsertInvLineFromRcptLine(PurchLine);

        ItemTrackingMgt.CopyHandledItemTrkgToInvLine2(PurchOrderLine,PurchLine);

        NextLineNo := NextLineNo + 10000;
        IF "Attached to Line No." = 0 THEN
          SETRANGE("Attached to Line No.","Line No.");
      UNTIL (NEXT = 0) OR ("Attached to Line No." = 0);
    END;

    LOCAL PROCEDURE GetPurchInvLines@4(VAR TempPurchInvLine@1000 : TEMPORARY Record 123);
    VAR
      PurchInvLine@1003 : Record 123;
      ItemLedgEntry@1002 : Record 32;
      ValueEntry@1001 : Record 5802;
    BEGIN
      TempPurchInvLine.RESET;
      TempPurchInvLine.DELETEALL;

      IF Type <> Type::Item THEN
        EXIT;

      FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
      ItemLedgEntry.SETFILTER("Invoiced Quantity",'<>0');
      IF ItemLedgEntry.FINDSET THEN BEGIN
        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
        ValueEntry.SETRANGE("Entry Type",ValueEntry."Entry Type"::"Direct Cost");
        ValueEntry.SETFILTER("Invoiced Quantity",'<>0');
        REPEAT
          ValueEntry.SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
          IF ValueEntry.FINDSET THEN
            REPEAT
              IF ValueEntry."Document Type" = ValueEntry."Document Type"::"Purchase Invoice" THEN
                IF PurchInvLine.GET(ValueEntry."Document No.",ValueEntry."Document Line No.") THEN BEGIN
                  TempPurchInvLine.INIT;
                  TempPurchInvLine := PurchInvLine;
                  IF TempPurchInvLine.INSERT THEN;
                END;
            UNTIL ValueEntry.NEXT = 0;
        UNTIL ItemLedgEntry.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE CalcReceivedPurchNotReturned@6(VAR RemainingQty@1003 : Decimal;VAR RevUnitCostLCY@1005 : Decimal;ExactCostReverse@1006 : Boolean);
    VAR
      ItemLedgEntry@1000 : Record 32;
      TotalCostLCY@1007 : Decimal;
      TotalQtyBase@1002 : Decimal;
    BEGIN
      RemainingQty := 0;
      IF (Type <> Type::Item) OR (Quantity <= 0) THEN BEGIN
        RevUnitCostLCY := "Unit Cost (LCY)";
        EXIT;
      END;

      RevUnitCostLCY := 0;
      FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
      IF ItemLedgEntry.FINDSET THEN
        REPEAT
          RemainingQty := RemainingQty + ItemLedgEntry."Remaining Quantity";
          IF ExactCostReverse THEN BEGIN
            ItemLedgEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
            TotalCostLCY :=
              TotalCostLCY + ItemLedgEntry."Cost Amount (Expected)" + ItemLedgEntry."Cost Amount (Actual)";
            TotalQtyBase := TotalQtyBase + ItemLedgEntry.Quantity;
          END;
        UNTIL ItemLedgEntry.NEXT = 0;

      IF ExactCostReverse AND (RemainingQty <> 0) AND (TotalQtyBase <> 0) THEN
        RevUnitCostLCY := ABS(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
      ELSE
        RevUnitCostLCY := "Unit Cost (LCY)";

      RemainingQty := CalcQty(RemainingQty);
    END;

    LOCAL PROCEDURE CalcQty@10(QtyBase@1000 : Decimal) : Decimal;
    BEGIN
      IF "Qty. per Unit of Measure" = 0 THEN
        EXIT(QtyBase);
      EXIT(ROUND(QtyBase / "Qty. per Unit of Measure",0.00001));
    END;

    [External]
    PROCEDURE FilterPstdDocLnItemLedgEntries@5(VAR ItemLedgEntry@1000 : Record 32);
    BEGIN
      ItemLedgEntry.RESET;
      ItemLedgEntry.SETCURRENTKEY("Document No.");
      ItemLedgEntry.SETRANGE("Document No.","Document No.");
      ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Purchase Receipt");
      ItemLedgEntry.SETRANGE("Document Line No.","Line No.");
    END;

    [External]
    PROCEDURE ShowItemPurchInvLines@9();
    VAR
      TempPurchInvLine@1001 : TEMPORARY Record 123;
    BEGIN
      IF Type = Type::Item THEN BEGIN
        GetPurchInvLines(TempPurchInvLine);
        PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice Lines",TempPurchInvLine);
      END;
    END;

    LOCAL PROCEDURE InitCurrency@7(CurrencyCode@1001 : Code[10]);
    BEGIN
      IF (Currency.Code = CurrencyCode) AND CurrencyRead THEN
        EXIT;

      IF CurrencyCode <> '' THEN
        Currency.GET(CurrencyCode)
      ELSE
        Currency.InitRoundingPrecision;
      CurrencyRead := TRUE;
    END;

    [External]
    PROCEDURE ShowLineComments@11();
    VAR
      PurchCommentLine@1002 : Record 43;
    BEGIN
      PurchCommentLine.ShowComments(PurchCommentLine."Document Type"::Receipt,"Document No.","Line No.");
    END;

    [External]
    PROCEDURE InitFromPurchLine@12(PurchRcptHeader@1001 : Record 120;PurchLine@1002 : Record 39);
    VAR
      Factor@1000 : Decimal;
    BEGIN
      INIT;
      TRANSFERFIELDS(PurchLine);
      IF ("No." = '') AND (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) THEN
        Type := Type::" ";
      "Posting Date" := PurchRcptHeader."Posting Date";
      "Document No." := PurchRcptHeader."No.";
      Quantity := PurchLine."Qty. to Receive";
      "Quantity (Base)" := PurchLine."Qty. to Receive (Base)";
      IF ABS(PurchLine."Qty. to Invoice") > ABS(PurchLine."Qty. to Receive") THEN BEGIN
        "Quantity Invoiced" := PurchLine."Qty. to Receive";
        "Qty. Invoiced (Base)" := PurchLine."Qty. to Receive (Base)";
      END ELSE BEGIN
        "Quantity Invoiced" := PurchLine."Qty. to Invoice";
        "Qty. Invoiced (Base)" := PurchLine."Qty. to Invoice (Base)";
      END;
      "Qty. Rcd. Not Invoiced" := Quantity - "Quantity Invoiced";
      IF PurchLine."Document Type" = PurchLine."Document Type"::Order THEN BEGIN
        "Order No." := PurchLine."Document No.";
        "Order Line No." := PurchLine."Line No.";
      END;
      IF (PurchLine.Quantity <> 0) AND ("Job No." <> '') THEN BEGIN
        Factor := PurchLine."Qty. to Receive" / PurchLine.Quantity;
        IF Factor <> 1 THEN
          UpdateJobPrices(Factor);
      END;

      OnAfterInitFromPurchLine(PurchRcptHeader,PurchLine,Rec);
    END;

    PROCEDURE FormatType@144() : Text;
    VAR
      PurchaseLine@1000 : Record 39;
    BEGIN
      IF Type = Type::" " THEN
        EXIT(PurchaseLine.FormatType);

      EXIT(FORMAT(Type));
    END;

    LOCAL PROCEDURE UpdateJobPrices@13(Factor@1000 : Decimal);
    BEGIN
      "Job Total Price" :=
        ROUND("Job Total Price" * Factor,Currency."Amount Rounding Precision");
      "Job Total Price (LCY)" :=
        ROUND("Job Total Price (LCY)" * Factor,Currency."Amount Rounding Precision");
      "Job Line Amount" :=
        ROUND("Job Line Amount" * Factor,Currency."Amount Rounding Precision");
      "Job Line Amount (LCY)" :=
        ROUND("Job Line Amount (LCY)" * Factor,Currency."Amount Rounding Precision");
      "Job Line Discount Amount" :=
        ROUND("Job Line Discount Amount" * Factor,Currency."Amount Rounding Precision");
      "Job Line Disc. Amount (LCY)" :=
        ROUND("Job Line Disc. Amount (LCY)" * Factor,Currency."Amount Rounding Precision");
    END;

    LOCAL PROCEDURE GetFieldCaption@31(FieldNumber@1000 : Integer) : Text[100];
    VAR
      Field@1001 : Record 2000000041;
    BEGIN
      Field.GET(DATABASE::"Purch. Rcpt. Line",FieldNumber);
      EXIT(Field."Field Caption");
    END;

    LOCAL PROCEDURE GetCaptionClass@34(FieldNumber@1000 : Integer) : Text[80];
    BEGIN
      CASE FieldNumber OF
        FIELDNO("No."):
          EXIT(STRSUBSTNO('3,%1',GetFieldCaption(FieldNumber)));
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitFromPurchLine@8(PurchRcptHeader@1000 : Record 120;PurchLine@1001 : Record 39;VAR PurchRcptLine@1002 : Record 121);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertInvLineFromRcptLine@18(VAR PurchLine@1000 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertInvLineFromRcptLine@17(VAR PurchRcptLine@1000 : Record 121;VAR PurchLine@1001 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine@14(VAR PurchRcptLine@1000 : Record 121;VAR PurchLine@1001 : Record 39;NextLineNo@1002 : Integer;VAR Handled@1003 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

