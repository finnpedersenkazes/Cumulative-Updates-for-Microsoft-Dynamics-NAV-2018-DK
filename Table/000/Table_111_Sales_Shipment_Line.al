OBJECT Table 111 Sales Shipment Line
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 32=r,
                TableData 5802=r;
    OnDelete=VAR
               ServItem@1000 : Record 5940;
               SalesDocLineComments@1001 : Record 44;
             BEGIN
               ServItem.RESET;
               ServItem.SETCURRENTKEY("Sales/Serv. Shpt. Document No.","Sales/Serv. Shpt. Line No.");
               ServItem.SETRANGE("Sales/Serv. Shpt. Document No.","Document No.");
               ServItem.SETRANGE("Sales/Serv. Shpt. Line No.","Line No.");
               ServItem.SETRANGE("Shipment Type",ServItem."Shipment Type"::Sales);
               IF ServItem.FIND('-') THEN
                 REPEAT
                   ServItem.VALIDATE("Sales/Serv. Shpt. Document No.",'');
                   ServItem.VALIDATE("Sales/Serv. Shpt. Line No.",0);
                   ServItem.MODIFY(TRUE);
                 UNTIL ServItem.NEXT = 0;

               SalesDocLineComments.SETRANGE("Document Type",SalesDocLineComments."Document Type"::Shipment);
               SalesDocLineComments.SETRANGE("No.","Document No.");
               SalesDocLineComments.SETRANGE("Document Line No.","Line No.");
               IF NOT SalesDocLineComments.ISEMPTY THEN
                 SalesDocLineComments.DELETEALL;

               PostedATOLink.DeleteAsmFromSalesShptLine(Rec);
             END;

    CaptionML=[DAN=Salgsleverancelinje;
               ENU=Sales Shipment Line];
    LookupPageID=Page525;
    DrillDownPageID=Page525;
  }
  FIELDS
  {
    { 2   ;   ;Sell-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Kundenr.;
                                                              ENU=Sell-to Customer No.];
                                                   Editable=No }
    { 3   ;   ;Document No.        ;Code20        ;TableRelation="Sales Shipment Header";
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
                                                   AutoFormatExpr=GetCurrencyCode }
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
    { 39  ;   ;Item Shpt. Entry No.;Integer       ;CaptionML=[DAN=Varelev.postl�benr.;
                                                              ENU=Item Shpt. Entry No.] }
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
    { 58  ;   ;Qty. Shipped Not Invoiced;Decimal  ;AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Lev. antal (ufakt.);
                                                              ENU=Qty. Shipped Not Invoiced];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 61  ;   ;Quantity Invoiced   ;Decimal       ;CaptionML=[DAN=Faktureret (antal);
                                                              ENU=Quantity Invoiced];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 65  ;   ;Order No.           ;Code20        ;CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.] }
    { 66  ;   ;Order Line No.      ;Integer       ;CaptionML=[DAN=Ordrelinjenr.;
                                                              ENU=Order Line No.] }
    { 68  ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.];
                                                   Editable=No }
    { 71  ;   ;Purchase Order No.  ;Code20        ;CaptionML=[DAN=K�bsordrenr.;
                                                              ENU=Purchase Order No.] }
    { 72  ;   ;Purch. Order Line No.;Integer      ;CaptionML=[DAN=K�bsordrelinjenr.;
                                                              ENU=Purch. Order Line No.] }
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
    { 80  ;   ;Attached to Line No.;Integer       ;TableRelation="Sales Shipment Line"."Line No." WHERE (Document No.=FIELD(Document No.));
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
    { 85  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=Skatteomr�dekode;
                                                              ENU=Tax Area Code] }
    { 86  ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 87  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 89  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 90  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 91  ;   ;Currency Code       ;Code10        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Sales Shipment Header"."Currency Code" WHERE (No.=FIELD(Document No.)));
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code];
                                                   Editable=No }
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
    { 107 ;   ;IC Partner Ref. Type;Option        ;DataClassification=CustomerContent;
                                                   CaptionML=[DAN=Ref.type for IC-partner;
                                                              ENU=IC Partner Ref. Type];
                                                   OptionCaptionML=[DAN=" ,Finanskonto,Vare,,,Gebyr (vare),Varereference,F�lles varenr.";
                                                                    ENU=" ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No."];
                                                   OptionString=[ ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No.] }
    { 108 ;   ;IC Partner Reference;Code20        ;DataClassification=CustomerContent;
                                                   CaptionML=[DAN=Reference for IC-partner;
                                                              ENU=IC Partner Reference] }
    { 131 ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 826 ;   ;Authorized for Credit Card;Boolean ;CaptionML=[DAN=Godkendt for kreditkort;
                                                              ENU=Authorized for Credit Card] }
    { 1001;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.];
                                                   Editable=No }
    { 1002;   ;Job Contract Entry No.;Integer     ;CaptionML=[DAN=L�benr. for sagskontrakt;
                                                              ENU=Job Contract Entry No.];
                                                   Editable=No }
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
    { 5790;   ;Requested Delivery Date;Date       ;AccessByPermission=TableData 99000880=R;
                                                   CaptionML=[DAN=�nsket leveringsdato;
                                                              ENU=Requested Delivery Date];
                                                   Editable=No }
    { 5791;   ;Promised Delivery Date;Date        ;CaptionML=[DAN=Bekr�ftet leveringsdato;
                                                              ENU=Promised Delivery Date];
                                                   Editable=No }
    { 5792;   ;Shipping Time       ;DateFormula   ;AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Transporttid;
                                                              ENU=Shipping Time] }
    { 5793;   ;Outbound Whse. Handling Time;DateFormula;
                                                   AccessByPermission=TableData 14=R;
                                                   CaptionML=[DAN=Udg�ende lagerekspeditionstid;
                                                              ENU=Outbound Whse. Handling Time] }
    { 5794;   ;Planned Delivery Date;Date         ;CaptionML=[DAN=Planlagt leveringsdato;
                                                              ENU=Planned Delivery Date];
                                                   Editable=No }
    { 5795;   ;Planned Shipment Date;Date         ;CaptionML=[DAN=Planlagt afsendelsesdato;
                                                              ENU=Planned Shipment Date];
                                                   Editable=No }
    { 5811;   ;Appl.-from Item Entry;Integer      ;AccessByPermission=TableData 27=R;
                                                   CaptionML=[DAN=Udlign fra-varepost;
                                                              ENU=Appl.-from Item Entry];
                                                   MinValue=0 }
    { 5812;   ;Item Charge Base Amount;Decimal    ;CaptionML=[DAN=Varegebyrgrundlag (bel�b);
                                                              ENU=Item Charge Base Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 5817;   ;Correction          ;Boolean       ;CaptionML=[DAN=Rettelse;
                                                              ENU=Correction];
                                                   Editable=No }
    { 6608;   ;Return Reason Code  ;Code10        ;TableRelation="Return Reason";
                                                   CaptionML=[DAN=Retur�rsagskode;
                                                              ENU=Return Reason Code] }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
    { 7002;   ;Customer Disc. Group;Code20        ;TableRelation="Customer Discount Group";
                                                   CaptionML=[DAN=Debitorrabatgruppe;
                                                              ENU=Customer Disc. Group] }
  }
  KEYS
  {
    {    ;Document No.,Line No.                   ;Clustered=Yes }
    {    ;Order No.,Order Line No.                 }
    {    ;Blanket Order No.,Blanket Order Line No. }
    {    ;Item Shpt. Entry No.                     }
    {    ;Sell-to Customer No.                     }
    {    ;Bill-to Customer No.                     }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Document No.,Line No.,Sell-to Customer No.,Type,No.,Shipment Date }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Leverancenr. %1:;ENU=Shipment No. %1:';
      Text001@1001 : TextConst 'DAN=Salgslinjen blev ikke fundet.;ENU=The program cannot find this Sales line.';
      Currency@1002 : Record 4;
      SalesShptHeader@1005 : Record 110;
      PostedATOLink@1006 : Record 914;
      DimMgt@1003 : Codeunit 408;
      CurrencyRead@1004 : Boolean;

    [External]
    PROCEDURE GetCurrencyCode@1() : Code[10];
    BEGIN
      IF "Document No." = SalesShptHeader."No." THEN
        EXIT(SalesShptHeader."Currency Code");
      IF SalesShptHeader.GET("Document No.") THEN
        EXIT(SalesShptHeader."Currency Code");
      EXIT('');
    END;

    [External]
    PROCEDURE ShowDimensions@25();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Document No.","Line No."));
    END;

    [External]
    PROCEDURE ShowItemTrackingLines@6500();
    VAR
      ItemTrackingDocMgt@1000 : Codeunit 6503;
    BEGIN
      ItemTrackingDocMgt.ShowItemTrackingForShptRcptLine(DATABASE::"Sales Shipment Line",0,"Document No.",'',0,"Line No.");
    END;

    PROCEDURE InsertInvLineFromShptLine@2(VAR SalesLine@1000 : Record 37);
    VAR
      SalesInvHeader@1011 : Record 36;
      SalesOrderHeader@1008 : Record 36;
      SalesOrderLine@1005 : Record 37;
      TempSalesLine@1002 : TEMPORARY Record 37;
      TransferOldExtLines@1007 : Codeunit 379;
      ItemTrackingMgt@1009 : Codeunit 6500;
      LanguageManagement@1010 : Codeunit 43;
      ExtTextLine@1006 : Boolean;
      NextLineNo@1001 : Integer;
      Handled@1003 : Boolean;
    BEGIN
      SETRANGE("Document No.","Document No.");

      TempSalesLine := SalesLine;
      IF SalesLine.FIND('+') THEN
        NextLineNo := SalesLine."Line No." + 10000
      ELSE
        NextLineNo := 10000;

      IF SalesInvHeader."No." <> TempSalesLine."Document No." THEN
        SalesInvHeader.GET(TempSalesLine."Document Type",TempSalesLine."Document No.");

      IF SalesLine."Shipment No." <> "Document No." THEN BEGIN
        SalesLine.INIT;
        SalesLine."Line No." := NextLineNo;
        SalesLine."Document Type" := TempSalesLine."Document Type";
        SalesLine."Document No." := TempSalesLine."Document No.";
        LanguageManagement.SetGlobalLanguageByCode(SalesInvHeader."Language Code");
        SalesLine.Description := STRSUBSTNO(Text000,"Document No.");
        LanguageManagement.RestoreGlobalLanguage;
        OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(Rec,SalesLine,NextLineNo,Handled);
        IF NOT Handled THEN BEGIN
          SalesLine.INSERT;
          NextLineNo := NextLineNo + 10000;
        END;
      END;

      TransferOldExtLines.ClearLineNumbers;

      REPEAT
        ExtTextLine := (TransferOldExtLines.GetNewLineNumber("Attached to Line No.") <> 0);

        IF (Type <> Type::" ") AND SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Order No.","Order Line No.")
        THEN BEGIN
          IF (SalesOrderHeader."Document Type" <> SalesOrderLine."Document Type"::Order) OR
             (SalesOrderHeader."No." <> SalesOrderLine."Document No.")
          THEN
            SalesOrderHeader.GET(SalesOrderLine."Document Type"::Order,"Order No.");

          InitCurrency("Currency Code");

          IF SalesInvHeader."Prices Including VAT" THEN BEGIN
            IF NOT SalesOrderHeader."Prices Including VAT" THEN
              SalesOrderLine."Unit Price" :=
                ROUND(
                  SalesOrderLine."Unit Price" * (1 + SalesOrderLine."VAT %" / 100),
                  Currency."Unit-Amount Rounding Precision");
          END ELSE BEGIN
            IF SalesOrderHeader."Prices Including VAT" THEN
              SalesOrderLine."Unit Price" :=
                ROUND(
                  SalesOrderLine."Unit Price" / (1 + SalesOrderLine."VAT %" / 100),
                  Currency."Unit-Amount Rounding Precision");
          END;
        END ELSE BEGIN
          SalesOrderHeader.INIT;
          IF ExtTextLine OR (Type = Type::" ") THEN BEGIN
            SalesOrderLine.INIT;
            SalesOrderLine."Line No." := "Order Line No.";
            SalesOrderLine.Description := Description;
            SalesOrderLine."Description 2" := "Description 2";
          END ELSE
            ERROR(Text001);
        END;

        SalesLine := SalesOrderLine;
        SalesLine."Line No." := NextLineNo;
        SalesLine."Document Type" := TempSalesLine."Document Type";
        SalesLine."Document No." := TempSalesLine."Document No.";
        SalesLine."Variant Code" := "Variant Code";
        SalesLine."Location Code" := "Location Code";
        SalesLine."Quantity (Base)" := 0;
        SalesLine.Quantity := 0;
        SalesLine."Outstanding Qty. (Base)" := 0;
        SalesLine."Outstanding Quantity" := 0;
        SalesLine."Quantity Shipped" := 0;
        SalesLine."Qty. Shipped (Base)" := 0;
        SalesLine."Quantity Invoiced" := 0;
        SalesLine."Qty. Invoiced (Base)" := 0;
        SalesLine.Amount := 0;
        SalesLine."Amount Including VAT" := 0;
        SalesLine."Purchase Order No." := '';
        SalesLine."Purch. Order Line No." := 0;
        SalesLine."Drop Shipment" := "Drop Shipment";
        SalesLine."Special Order Purchase No." := '';
        SalesLine."Special Order Purch. Line No." := 0;
        SalesLine."Special Order" := FALSE;
        SalesLine."Shipment No." := "Document No.";
        SalesLine."Shipment Line No." := "Line No.";
        SalesLine."Appl.-to Item Entry" := 0;
        SalesLine."Appl.-from Item Entry" := 0;
        IF NOT ExtTextLine AND (SalesLine.Type <> 0) THEN BEGIN
          SalesLine.VALIDATE(Quantity,Quantity - "Quantity Invoiced");
          CalcBaseQuantities(SalesLine,"Quantity (Base)" / Quantity);
          SalesLine.VALIDATE("Unit Price",SalesOrderLine."Unit Price");
          SalesLine."Allow Line Disc." := SalesOrderLine."Allow Line Disc.";
          SalesLine."Allow Invoice Disc." := SalesOrderLine."Allow Invoice Disc.";
          SalesOrderLine."Line Discount Amount" :=
            ROUND(
              SalesOrderLine."Line Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
              Currency."Amount Rounding Precision");
          IF SalesInvHeader."Prices Including VAT" THEN BEGIN
            IF NOT SalesOrderHeader."Prices Including VAT" THEN
              SalesOrderLine."Line Discount Amount" :=
                ROUND(
                  SalesOrderLine."Line Discount Amount" *
                  (1 + SalesOrderLine."VAT %" / 100),Currency."Amount Rounding Precision");
          END ELSE BEGIN
            IF SalesOrderHeader."Prices Including VAT" THEN
              SalesOrderLine."Line Discount Amount" :=
                ROUND(
                  SalesOrderLine."Line Discount Amount" /
                  (1 + SalesOrderLine."VAT %" / 100),Currency."Amount Rounding Precision");
          END;
          SalesLine.VALIDATE("Line Discount Amount",SalesOrderLine."Line Discount Amount");
          SalesLine."Line Discount %" := SalesOrderLine."Line Discount %";
          SalesLine.UpdatePrePaymentAmounts;
          IF SalesOrderLine.Quantity = 0 THEN
            SalesLine.VALIDATE("Inv. Discount Amount",0)
          ELSE
            SalesLine.VALIDATE(
              "Inv. Discount Amount",
              ROUND(
                SalesOrderLine."Inv. Discount Amount" * SalesLine.Quantity / SalesOrderLine.Quantity,
                Currency."Amount Rounding Precision"));
        END;

        SalesLine."Attached to Line No." :=
          TransferOldExtLines.TransferExtendedText(
            SalesOrderLine."Line No.",
            NextLineNo,
            "Attached to Line No.");
        SalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        SalesLine."Dimension Set ID" := "Dimension Set ID";
        OnBeforeInsertInvLineFromShptLine(Rec,SalesLine);
        SalesLine.INSERT;
        OnAfterInsertInvLineFromShptLine(SalesLine);

        ItemTrackingMgt.CopyHandledItemTrkgToInvLine(SalesOrderLine,SalesLine);

        NextLineNo := NextLineNo + 10000;
        IF "Attached to Line No." = 0 THEN
          SETRANGE("Attached to Line No.","Line No.");
      UNTIL (NEXT = 0) OR ("Attached to Line No." = 0);

      IF SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order,"Order No.") THEN BEGIN
        SalesOrderHeader."Get Shipment Used" := TRUE;
        SalesOrderHeader.MODIFY;
      END;
    END;

    LOCAL PROCEDURE GetSalesInvLines@4(VAR TempSalesInvLine@1000 : TEMPORARY Record 113);
    VAR
      SalesInvLine@1003 : Record 113;
      ItemLedgEntry@1002 : Record 32;
      ValueEntry@1001 : Record 5802;
    BEGIN
      TempSalesInvLine.RESET;
      TempSalesInvLine.DELETEALL;

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
              IF ValueEntry."Document Type" = ValueEntry."Document Type"::"Sales Invoice" THEN
                IF SalesInvLine.GET(ValueEntry."Document No.",ValueEntry."Document Line No.") THEN BEGIN
                  TempSalesInvLine.INIT;
                  TempSalesInvLine := SalesInvLine;
                  IF TempSalesInvLine.INSERT THEN;
                END;
            UNTIL ValueEntry.NEXT = 0;
        UNTIL ItemLedgEntry.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE CalcShippedSaleNotReturned@3(VAR ShippedQtyNotReturned@1003 : Decimal;VAR RevUnitCostLCY@1005 : Decimal;ExactCostReverse@1006 : Boolean);
    VAR
      ItemLedgEntry@1000 : Record 32;
      TotalCostLCY@1007 : Decimal;
      TotalQtyBase@1002 : Decimal;
    BEGIN
      ShippedQtyNotReturned := 0;
      IF (Type <> Type::Item) OR (Quantity <= 0) THEN BEGIN
        RevUnitCostLCY := "Unit Cost (LCY)";
        EXIT;
      END;

      RevUnitCostLCY := 0;
      FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
      IF ItemLedgEntry.FINDSET THEN
        REPEAT
          ShippedQtyNotReturned := ShippedQtyNotReturned - ItemLedgEntry."Shipped Qty. Not Returned";
          IF ExactCostReverse THEN BEGIN
            ItemLedgEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
            TotalCostLCY :=
              TotalCostLCY + ItemLedgEntry."Cost Amount (Expected)" + ItemLedgEntry."Cost Amount (Actual)";
            TotalQtyBase := TotalQtyBase + ItemLedgEntry.Quantity;
          END;
        UNTIL ItemLedgEntry.NEXT = 0;

      IF ExactCostReverse AND (ShippedQtyNotReturned <> 0) AND (TotalQtyBase <> 0) THEN
        RevUnitCostLCY := ABS(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
      ELSE
        RevUnitCostLCY := "Unit Cost (LCY)";

      ShippedQtyNotReturned := CalcQty(ShippedQtyNotReturned);
    END;

    LOCAL PROCEDURE CalcQty@9(QtyBase@1000 : Decimal) : Decimal;
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
      ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Sales Shipment");
      ItemLedgEntry.SETRANGE("Document Line No.","Line No.");
    END;

    [External]
    PROCEDURE ShowItemSalesInvLines@8();
    VAR
      TempSalesInvLine@1001 : TEMPORARY Record 113;
    BEGIN
      IF Type = Type::Item THEN BEGIN
        GetSalesInvLines(TempSalesInvLine);
        PAGE.RUNMODAL(PAGE::"Posted Sales Invoice Lines",TempSalesInvLine);
      END;
    END;

    LOCAL PROCEDURE InitCurrency@6(CurrencyCode@1001 : Code[10]);
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
    PROCEDURE ShowLineComments@10();
    VAR
      SalesCommentLine@1000 : Record 44;
    BEGIN
      SalesCommentLine.ShowComments(SalesCommentLine."Document Type"::Shipment,"Document No.","Line No.");
    END;

    [External]
    PROCEDURE ShowAsmToOrder@11();
    BEGIN
      PostedATOLink.ShowPostedAsm(Rec);
    END;

    [External]
    PROCEDURE AsmToShipmentExists@72(VAR PostedAsmHeader@1000 : Record 910) : Boolean;
    VAR
      PostedAssembleToOrderLink@1001 : Record 914;
    BEGIN
      IF NOT PostedAssembleToOrderLink.AsmExistsForPostedShipmentLine(Rec) THEN
        EXIT(FALSE);
      EXIT(PostedAsmHeader.GET(PostedAssembleToOrderLink."Assembly Document No."));
    END;

    [External]
    PROCEDURE InitFromSalesLine@12(SalesShptHeader@1001 : Record 110;SalesLine@1002 : Record 37);
    BEGIN
      INIT;
      TRANSFERFIELDS(SalesLine);
      IF ("No." = '') AND (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) THEN
        Type := Type::" ";
      "Posting Date" := SalesShptHeader."Posting Date";
      "Document No." := SalesShptHeader."No.";
      Quantity := SalesLine."Qty. to Ship";
      "Quantity (Base)" := SalesLine."Qty. to Ship (Base)";
      IF ABS(SalesLine."Qty. to Invoice") > ABS(SalesLine."Qty. to Ship") THEN BEGIN
        "Quantity Invoiced" := SalesLine."Qty. to Ship";
        "Qty. Invoiced (Base)" := SalesLine."Qty. to Ship (Base)";
      END ELSE BEGIN
        "Quantity Invoiced" := SalesLine."Qty. to Invoice";
        "Qty. Invoiced (Base)" := SalesLine."Qty. to Invoice (Base)";
      END;
      "Qty. Shipped Not Invoiced" := Quantity - "Quantity Invoiced";
      IF SalesLine."Document Type" = SalesLine."Document Type"::Order THEN BEGIN
        "Order No." := SalesLine."Document No.";
        "Order Line No." := SalesLine."Line No.";
      END;

      OnAfterInitFromSalesLine(SalesShptHeader,SalesLine,Rec);
    END;

    PROCEDURE FormatType@144() : Text;
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      IF Type = Type::" " THEN
        EXIT(SalesLine.FormatType);

      EXIT(FORMAT(Type));
    END;

    LOCAL PROCEDURE CalcBaseQuantities@13(VAR SalesLine@1000 : Record 37;QtyFactor@1001 : Decimal);
    BEGIN
      SalesLine."Quantity (Base)" := ROUND(SalesLine.Quantity * QtyFactor,0.00001);
      SalesLine."Qty. to Asm. to Order (Base)" := ROUND(SalesLine."Qty. to Assemble to Order" * QtyFactor,0.00001);
      SalesLine."Outstanding Qty. (Base)" := ROUND(SalesLine."Outstanding Quantity" * QtyFactor,0.00001);
      SalesLine."Qty. to Ship (Base)" := ROUND(SalesLine."Qty. to Ship" * QtyFactor,0.00001);
      SalesLine."Qty. Shipped (Base)" := ROUND(SalesLine."Quantity Shipped" * QtyFactor,0.00001);
      SalesLine."Qty. Shipped Not Invd. (Base)" := ROUND(SalesLine."Qty. Shipped Not Invoiced" * QtyFactor,0.00001);
      SalesLine."Qty. to Invoice (Base)" := ROUND(SalesLine."Qty. to Invoice" * QtyFactor,0.00001);
      SalesLine."Qty. Invoiced (Base)" := ROUND(SalesLine."Quantity Invoiced" * QtyFactor,0.00001);
      SalesLine."Return Qty. to Receive (Base)" := ROUND(SalesLine."Return Qty. to Receive" * QtyFactor,0.00001);
      SalesLine."Return Qty. Received (Base)" := ROUND(SalesLine."Return Qty. Received" * QtyFactor,0.00001);
      SalesLine."Ret. Qty. Rcd. Not Invd.(Base)" := ROUND(SalesLine."Return Qty. Rcd. Not Invd." * QtyFactor,0.00001);
    END;

    LOCAL PROCEDURE GetFieldCaption@31(FieldNumber@1000 : Integer) : Text[100];
    VAR
      Field@1001 : Record 2000000041;
    BEGIN
      Field.GET(DATABASE::"Sales Shipment Line",FieldNumber);
      EXIT(Field."Field Caption");
    END;

    [External]
    PROCEDURE GetCaptionClass@34(FieldNumber@1000 : Integer) : Text[80];
    BEGIN
      CASE FieldNumber OF
        FIELDNO("No."):
          EXIT(STRSUBSTNO('3,%1',GetFieldCaption(FieldNumber)));
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitFromSalesLine@7(SalesShptHeader@1000 : Record 110;SalesLine@1001 : Record 37;VAR SalesShptLine@1002 : Record 111);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertInvLineFromShptLine@18(SalesLine@1000 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertInvLineFromShptLine@17(VAR SalesShptLine@1000 : Record 111;VAR SalesLine@1001 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine@14(VAR SalesShptLine@1000 : Record 111;VAR SalesLine@1001 : Record 37;NextLineNo@1002 : Integer;VAR Handled@1003 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

