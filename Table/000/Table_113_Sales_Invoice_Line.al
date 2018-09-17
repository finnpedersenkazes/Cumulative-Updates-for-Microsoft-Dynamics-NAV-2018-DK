OBJECT Table 113 Sales Invoice Line
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441,NAVDK11.00.00.21441;
  }
  PROPERTIES
  {
    Permissions=TableData 32=r,
                TableData 5802=r;
    OnDelete=VAR
               SalesDocLineComments@1000 : Record 44;
               PostedDeferralHeader@1001 : Record 1704;
             BEGIN
               SalesDocLineComments.SETRANGE("Document Type",SalesDocLineComments."Document Type"::"Posted Invoice");
               SalesDocLineComments.SETRANGE("No.","Document No.");
               SalesDocLineComments.SETRANGE("Document Line No.","Line No.");
               IF NOT SalesDocLineComments.ISEMPTY THEN
                 SalesDocLineComments.DELETEALL;

               PostedDeferralHeader.DeleteHeader(DeferralUtilities.GetSalesDeferralDocType,'','',
                 SalesDocLineComments."Document Type"::"Posted Invoice","Document No.","Line No.");
             END;

    CaptionML=[DAN=Salgsfakturalinje;
               ENU=Sales Invoice Line];
    LookupPageID=Page526;
    DrillDownPageID=Page526;
  }
  FIELDS
  {
    { 2   ;   ;Sell-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.];
                                                   Editable=No }
    { 3   ;   ;Document No.        ;Code20        ;TableRelation="Sales Invoice Header";
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 4   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 5   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,Ressource,Anl�g,Gebyr (vare)";
                                                                    ENU=" ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)"];
                                                   OptionString=[ ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)] }
    { 6   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(Resource)) Resource
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
                                                   CaptionML=[DAN=Bogf�ringsgruppe;
                                                              ENU=Posting Group];
                                                   Editable=No }
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
    { 22  ;   ;Unit Price          ;Decimal       ;CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr=GetCurrencyCode;
                                                   CaptionClass=GetCaptionClass(FIELDNO("Unit Price")) }
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
    { 28  ;   ;Line Discount Amount;Decimal       ;CaptionML=[DAN=Linjerabatbel�b;
                                                              ENU=Line Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 29  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 30  ;   ;Amount Including VAT;Decimal       ;CaptionML=[DAN=Bel�b inkl. moms;
                                                              ENU=Amount Including VAT];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 32  ;   ;Allow Invoice Disc. ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad fakturarabat;
                                                              ENU=Allow Invoice Disc.] }
    { 34  ;   ;Gross Weight        ;Decimal       ;CaptionML=[DAN=Bruttov�gt;
                                                              ENU=Gross Weight];
                                                   DecimalPlaces=0:5 }
    { 35  ;   ;Net Weight          ;Decimal       ;CaptionML=[DAN=Nettov�gt;
                                                              ENU=Net Weight];
                                                   DecimalPlaces=0:5 }
    { 36  ;   ;Units per Parcel    ;Decimal       ;CaptionML=[DAN=Antal pr. kolli;
                                                              ENU=Units per Parcel];
                                                   DecimalPlaces=0:5 }
    { 37  ;   ;Unit Volume         ;Decimal       ;CaptionML=[DAN=Rumfang;
                                                              ENU=Unit Volume];
                                                   DecimalPlaces=0:5 }
    { 38  ;   ;Appl.-to Item Entry ;Integer       ;AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udl.varepostl�benr.;
                                                              ENU=Appl.-to Item Entry] }
    { 40  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 41  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 42  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   CaptionML=[DAN=Debitorprisgruppe;
                                                              ENU=Customer Price Group] }
    { 45  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 52  ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 63  ;   ;Shipment No.        ;Code20        ;CaptionML=[DAN=Leverancenr.;
                                                              ENU=Shipment No.];
                                                   Editable=No }
    { 64  ;   ;Shipment Line No.   ;Integer       ;CaptionML=[DAN=Salgslev.linjenr.;
                                                              ENU=Shipment Line No.];
                                                   Editable=No }
    { 68  ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.];
                                                   Editable=No }
    { 69  ;   ;Inv. Discount Amount;Decimal       ;CaptionML=[DAN=Fakturarabatbel�b;
                                                              ENU=Inv. Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 73  ;   ;Drop Shipment       ;Boolean       ;AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=Direkte levering;
                                                              ENU=Drop Shipment] }
    { 74  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 75  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
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
                                                   CaptionML=[DAN=Transportm�de;
                                                              ENU=Transport Method] }
    { 80  ;   ;Attached to Line No.;Integer       ;TableRelation="Sales Invoice Line"."Line No." WHERE (Document No.=FIELD(Document No.));
                                                   CaptionML=[DAN=Tilknyttet linjenr.;
                                                              ENU=Attached to Line No.] }
    { 81  ;   ;Exit Point          ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=[DAN=Udf�rselssted;
                                                              ENU=Exit Point] }
    { 82  ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=[DAN=Omr�de;
                                                              ENU=Area] }
    { 83  ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 84  ;   ;Tax Category        ;Code10        ;CaptionML=[DAN=Momskategori;
                                                              ENU=Tax Category] }
    { 85  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=Skatteomr�dekode;
                                                              ENU=Tax Area Code] }
    { 86  ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 87  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 88  ;   ;VAT Clause Code     ;Code20        ;TableRelation="VAT Clause";
                                                   CaptionML=[DAN=Momsklausulkode;
                                                              ENU=VAT Clause Code] }
    { 89  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 90  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 97  ;   ;Blanket Order No.   ;Code20        ;TableRelation="Sales Header".No. WHERE (Document Type=CONST(Blanket Order));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Rammeordrenr.;
                                                              ENU=Blanket Order No.] }
    { 98  ;   ;Blanket Order Line No.;Integer     ;TableRelation="Sales Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                                                                Document No.=FIELD(Blanket Order No.));
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Rammeordrelinjenr.;
                                                              ENU=Blanket Order Line No.] }
    { 99  ;   ;VAT Base Amount     ;Decimal       ;CaptionML=[DAN=Momsgrundlag (bel�b);
                                                              ENU=VAT Base Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 100 ;   ;Unit Cost           ;Decimal       ;CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   Editable=No;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 101 ;   ;System-Created Entry;Boolean       ;CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry];
                                                   Editable=No }
    { 103 ;   ;Line Amount         ;Decimal       ;CaptionML=[DAN=Linjebel�b;
                                                              ENU=Line Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode;
                                                   CaptionClass=GetCaptionClass(FIELDNO("Line Amount")) }
    { 104 ;   ;VAT Difference      ;Decimal       ;CaptionML=[DAN=Momsdifference;
                                                              ENU=VAT Difference];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 106 ;   ;VAT Identifier      ;Code20        ;CaptionML=[DAN=Moms-id;
                                                              ENU=VAT Identifier];
                                                   Editable=No }
    { 107 ;   ;IC Partner Ref. Type;Option        ;CaptionML=[DAN=Ref.type for IC-partner;
                                                              ENU=IC Partner Ref. Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,,,Gebyr (vare),Varereference,F�lles varenr.";
                                                                    ENU=" ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No."];
                                                   OptionString=[ ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No.] }
    { 108 ;   ;IC Partner Reference;Code20        ;CaptionML=[DAN=Reference for IC-partner;
                                                              ENU=IC Partner Reference] }
    { 123 ;   ;Prepayment Line     ;Boolean       ;CaptionML=[DAN=Forudbetalingslinje;
                                                              ENU=Prepayment Line];
                                                   Editable=No }
    { 130 ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=IC-partner kode;
                                                              ENU=IC Partner Code] }
    { 131 ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 180 ;   ;Line Discount Calculation;Option   ;CaptionML=[DAN=Beregning af linjerabat;
                                                              ENU=Line Discount Calculation];
                                                   OptionCaptionML=[DAN=Ingen,%,Bel�b;
                                                                    ENU=None,%,Amount];
                                                   OptionString=None,%,Amount }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 1001;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.];
                                                   Editable=No }
    { 1002;   ;Job Contract Entry No.;Integer     ;CaptionML=[DAN=L�benr. for sagskontrakt;
                                                              ENU=Job Contract Entry No.];
                                                   Editable=No }
    { 1700;   ;Deferral Code       ;Code10        ;TableRelation="Deferral Template"."Deferral Code";
                                                   CaptionML=[DAN=Periodiseringskode;
                                                              ENU=Deferral Code] }
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
    { 5600;   ;FA Posting Date     ;Date          ;CaptionML=[DAN=Bogf�ringsdato for anl�g;
                                                              ENU=FA Posting Date] }
    { 5602;   ;Depreciation Book Code;Code10      ;TableRelation="Depreciation Book";
                                                   CaptionML=[DAN=Afskrivningsprofilkode;
                                                              ENU=Depreciation Book Code] }
    { 5605;   ;Depr. until FA Posting Date;Boolean;CaptionML=[DAN=Afskriv til bogf�ringsdato for anl�g;
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
                                                   CaptionML=[DAN=Indk�bskode;
                                                              ENU=Purchasing Code] }
    { 5712;   ;Product Group Code  ;Code10        ;TableRelation="Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
                                                   ValidateTableRelation=No;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Product Groups became first level children of Item Categories.;
                                                   CaptionML=[DAN=Produktgruppekode;
                                                              ENU=Product Group Code] }
    { 5811;   ;Appl.-from Item Entry;Integer      ;AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udlign fra-varepost;
                                                              ENU=Appl.-from Item Entry];
                                                   MinValue=0 }
    { 6608;   ;Return Reason Code  ;Code10        ;TableRelation="Return Reason";
                                                   CaptionML=[DAN=Retur�rsagskode;
                                                              ENU=Return Reason Code] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
    { 7002;   ;Customer Disc. Group;Code20        ;TableRelation="Customer Discount Group";
                                                   CaptionML=[DAN=Debitorrabatgruppe;
                                                              ENU=Customer Disc. Group] }
    { 7004;   ;Price description   ;Text80        ;CaptionML=[DAN=Prisbeskrivelse;
                                                              ENU=Price description] }
    { 13600;  ;Account Code        ;Text30        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontokode;
                                                              ENU=Account Code] }
  }
  KEYS
  {
    {    ;Document No.,Line No.                   ;SumIndexFields=Amount,Amount Including VAT,Inv. Discount Amount;
                                                   MaintainSIFTIndex=No;
                                                   Clustered=Yes }
    {    ;Blanket Order No.,Blanket Order Line No. }
    {    ;Sell-to Customer No.                     }
    { No ;Sell-to Customer No.,Type,Document No.  ;MaintainSQLIndex=No }
    {    ;Shipment No.,Shipment Line No.           }
    {    ;Job Contract Entry No.                   }
    {    ;Bill-to Customer No.                     }
  }
  FIELDGROUPS
  {
    { 1   ;Brick               ;No.,Description,Line Amount,Price description,Quantity,Unit of Measure Code }
  }
  CODE
  {
    VAR
      SalesInvoiceHeader@1002 : Record 112;
      Currency@1003 : Record 4;
      DimMgt@1001 : Codeunit 408;
      DeferralUtilities@1000 : Codeunit 1720;
      PriceDescriptionTxt@1004 : TextConst '@@@={Locked};DAN=x%1 (%2%3/%4);ENU=x%1 (%2%3/%4)';
      PriceDescriptionWithLineDiscountTxt@1066 : TextConst '@@@={Locked};DAN=x%1 (%2%3/%4) - %5%;ENU=x%1 (%2%3/%4) - %5%';

    [External]
    PROCEDURE GetCurrencyCode@1() : Code[10];
    BEGIN
      GetHeader;
      EXIT(SalesInvoiceHeader."Currency Code");
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
      ItemTrackingDocMgt.ShowItemTrackingForInvoiceLine(RowID1);
    END;

    [External]
    PROCEDURE CalcVATAmountLines@2(SalesInvHeader@1000 : Record 112;VAR TempVATAmountLine@1001 : TEMPORARY Record 290);
    BEGIN
      TempVATAmountLine.DELETEALL;
      SETRANGE("Document No.",SalesInvHeader."No.");
      IF FIND('-') THEN
        REPEAT
          TempVATAmountLine.INIT;
          TempVATAmountLine.CopyFromSalesInvLine(Rec);
          TempVATAmountLine.InsertLine;
        UNTIL NEXT = 0;
    END;

    PROCEDURE GetLineAmountExclVAT@149() : Decimal;
    BEGIN
      GetHeader;
      IF NOT SalesInvoiceHeader."Prices Including VAT" THEN
        EXIT("Line Amount");

      EXIT(ROUND("Line Amount" / (1 + "VAT %" / 100),Currency."Amount Rounding Precision"));
    END;

    PROCEDURE GetLineAmountInclVAT@151() : Decimal;
    BEGIN
      GetHeader;
      IF SalesInvoiceHeader."Prices Including VAT" THEN
        EXIT("Line Amount");

      EXIT(ROUND("Line Amount" * (1 + "VAT %" / 100),Currency."Amount Rounding Precision"));
    END;

    LOCAL PROCEDURE GetHeader@15();
    BEGIN
      IF SalesInvoiceHeader."No." = "Document No." THEN
        EXIT;
      IF NOT SalesInvoiceHeader.GET("Document No.") THEN
        SalesInvoiceHeader.INIT;

      IF SalesInvoiceHeader."Currency Code" = '' THEN
        Currency.InitRoundingPrecision
      ELSE
        IF NOT Currency.GET(SalesInvoiceHeader."Currency Code") THEN
          Currency.InitRoundingPrecision;
    END;

    LOCAL PROCEDURE GetFieldCaption@31(FieldNumber@1000 : Integer) : Text[100];
    VAR
      Field@1001 : Record 2000000041;
    BEGIN
      Field.GET(DATABASE::"Sales Invoice Line",FieldNumber);
      EXIT(Field."Field Caption");
    END;

    [External]
    PROCEDURE GetCaptionClass@34(FieldNumber@1000 : Integer) : Text[80];
    BEGIN
      GetHeader;
      CASE FieldNumber OF
        FIELDNO("No."):
          EXIT(STRSUBSTNO('3,%1',GetFieldCaption(FieldNumber)));
        ELSE BEGIN
          IF SalesInvoiceHeader."Prices Including VAT" THEN
            EXIT('2,1,' + GetFieldCaption(FieldNumber));
          EXIT('2,0,' + GetFieldCaption(FieldNumber));
        END
      END;
    END;

    [External]
    PROCEDURE RowID1@44() : Text[250];
    VAR
      ItemTrackingMgt@1000 : Codeunit 6500;
    BEGIN
      EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Invoice Line",
          0,"Document No.",'',0,"Line No."));
    END;

    LOCAL PROCEDURE GetSalesShptLines@4(VAR TempSalesShptLine@1000 : TEMPORARY Record 111);
    VAR
      SalesShptLine@1003 : Record 111;
      ItemLedgEntry@1002 : Record 32;
      ValueEntry@1001 : Record 5802;
    BEGIN
      TempSalesShptLine.RESET;
      TempSalesShptLine.DELETEALL;

      IF Type <> Type::Item THEN
        EXIT;

      FilterPstdDocLineValueEntries(ValueEntry);
      IF ValueEntry.FINDSET THEN
        REPEAT
          ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
          IF ItemLedgEntry."Document Type" = ItemLedgEntry."Document Type"::"Sales Shipment" THEN
            IF SalesShptLine.GET(ItemLedgEntry."Document No.",ItemLedgEntry."Document Line No.") THEN BEGIN
              TempSalesShptLine.INIT;
              TempSalesShptLine := SalesShptLine;
              IF TempSalesShptLine.INSERT THEN;
            END;
        UNTIL ValueEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE CalcShippedSaleNotReturned@5(VAR ShippedQtyNotReturned@1006 : Decimal;VAR RevUnitCostLCY@1004 : Decimal;ExactCostReverse@1003 : Boolean);
    VAR
      TempItemLedgEntry@1002 : TEMPORARY Record 32;
      TotalCostLCY@1009 : Decimal;
      TotalQtyBase@1007 : Decimal;
    BEGIN
      ShippedQtyNotReturned := 0;
      IF (Type <> Type::Item) OR (Quantity <= 0) THEN BEGIN
        RevUnitCostLCY := "Unit Cost (LCY)";
        EXIT;
      END;

      RevUnitCostLCY := 0;
      GetItemLedgEntries(TempItemLedgEntry,FALSE);
      IF TempItemLedgEntry.FINDSET THEN
        REPEAT
          ShippedQtyNotReturned := ShippedQtyNotReturned - TempItemLedgEntry."Shipped Qty. Not Returned";
          IF ExactCostReverse THEN BEGIN
            TempItemLedgEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
            TotalCostLCY :=
              TotalCostLCY + TempItemLedgEntry."Cost Amount (Expected)" + TempItemLedgEntry."Cost Amount (Actual)";
            TotalQtyBase := TotalQtyBase + TempItemLedgEntry.Quantity;
          END;
        UNTIL TempItemLedgEntry.NEXT = 0;

      IF ExactCostReverse AND (ShippedQtyNotReturned <> 0) AND (TotalQtyBase <> 0) THEN
        RevUnitCostLCY := ABS(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
      ELSE
        RevUnitCostLCY := "Unit Cost (LCY)";
      ShippedQtyNotReturned := CalcQty(ShippedQtyNotReturned);

      IF ShippedQtyNotReturned > Quantity THEN
        ShippedQtyNotReturned := Quantity;
    END;

    LOCAL PROCEDURE CalcQty@11(QtyBase@1000 : Decimal) : Decimal;
    BEGIN
      IF "Qty. per Unit of Measure" = 0 THEN
        EXIT(QtyBase);
      EXIT(ROUND(QtyBase / "Qty. per Unit of Measure",0.00001));
    END;

    [External]
    PROCEDURE GetItemLedgEntries@6(VAR TempItemLedgEntry@1000 : TEMPORARY Record 32;SetQuantity@1003 : Boolean);
    VAR
      ItemLedgEntry@1002 : Record 32;
      ValueEntry@1001 : Record 5802;
    BEGIN
      IF SetQuantity THEN BEGIN
        TempItemLedgEntry.RESET;
        TempItemLedgEntry.DELETEALL;

        IF Type <> Type::Item THEN
          EXIT;
      END;

      FilterPstdDocLineValueEntries(ValueEntry);
      ValueEntry.SETFILTER("Invoiced Quantity",'<>0');
      IF ValueEntry.FINDSET THEN
        REPEAT
          ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
          TempItemLedgEntry := ItemLedgEntry;
          IF SetQuantity THEN BEGIN
            TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
            IF ABS(TempItemLedgEntry."Shipped Qty. Not Returned") > ABS(TempItemLedgEntry.Quantity) THEN
              TempItemLedgEntry."Shipped Qty. Not Returned" := TempItemLedgEntry.Quantity;
          END;
          IF TempItemLedgEntry.INSERT THEN;
        UNTIL ValueEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE FilterPstdDocLineValueEntries@7(VAR ValueEntry@1000 : Record 5802);
    BEGIN
      ValueEntry.RESET;
      ValueEntry.SETCURRENTKEY("Document No.");
      ValueEntry.SETRANGE("Document No.","Document No.");
      ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Invoice");
      ValueEntry.SETRANGE("Document Line No.","Line No.");
    END;

    [External]
    PROCEDURE ShowItemShipmentLines@9();
    VAR
      TempSalesShptLine@1000 : TEMPORARY Record 111;
    BEGIN
      IF Type = Type::Item THEN BEGIN
        GetSalesShptLines(TempSalesShptLine);
        PAGE.RUNMODAL(0,TempSalesShptLine);
      END;
    END;

    [External]
    PROCEDURE ShowLineComments@8();
    VAR
      SalesCommentLine@1000 : Record 44;
    BEGIN
      SalesCommentLine.ShowComments(SalesCommentLine."Document Type"::"Posted Invoice","Document No.","Line No.");
    END;

    [External]
    PROCEDURE InitFromSalesLine@12(SalesInvHeader@1002 : Record 112;SalesLine@1001 : Record 37);
    BEGIN
      INIT;
      TRANSFERFIELDS(SalesLine);
      IF ("No." = '') AND (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) THEN
        Type := Type::" ";
      "Posting Date" := SalesInvHeader."Posting Date";
      "Document No." := SalesInvHeader."No.";
      Quantity := SalesLine."Qty. to Invoice";
      "Quantity (Base)" := SalesLine."Qty. to Invoice (Base)";

      OnAfterInitFromSalesLine(Rec,SalesInvHeader,SalesLine);
    END;

    [External]
    PROCEDURE ShowDeferrals@13();
    BEGIN
      DeferralUtilities.OpenLineScheduleView(
        "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
        GetDocumentType,"Document No.","Line No.");
    END;

    PROCEDURE UpdatePriceDescription@143();
    VAR
      Currency@1000 : Record 4;
    BEGIN
      "Price description" := '';
      IF Type IN [Type::"Charge (Item)",Type::"Fixed Asset",Type::Item,Type::Resource] THEN BEGIN
        IF "Line Discount %" = 0 THEN
          "Price description" := STRSUBSTNO(
              PriceDescriptionTxt,Quantity,Currency.ResolveGLCurrencySymbol(GetCurrencyCode),
              "Unit Price","Unit of Measure")
        ELSE
          "Price description" := STRSUBSTNO(
              PriceDescriptionWithLineDiscountTxt,Quantity,Currency.ResolveGLCurrencySymbol(GetCurrencyCode),
              "Unit Price","Unit of Measure","Line Discount %")
      END;
    END;

    PROCEDURE FormatType@144() : Text;
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      IF Type = Type::" " THEN
        EXIT(SalesLine.FormatType);

      EXIT(FORMAT(Type));
    END;

    [External]
    PROCEDURE GetDocumentType@14() : Integer;
    VAR
      SalesCommentLine@1000 : Record 44;
    BEGIN
      EXIT(SalesCommentLine."Document Type"::"Posted Invoice")
    END;

    PROCEDURE IsCancellationSupported@29() : Boolean;
    BEGIN
      EXIT(Type IN [Type::" ",Type::Item,Type::"G/L Account",Type::"Charge (Item)"]);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitFromSalesLine@10(VAR SalesInvLine@1002 : Record 113;SalesInvHeader@1000 : Record 112;SalesLine@1001 : Record 37);
    BEGIN
    END;

    BEGIN
    END.
  }
}

