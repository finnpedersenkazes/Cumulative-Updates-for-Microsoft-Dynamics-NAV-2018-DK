OBJECT Table 5802 Value Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Vërdipost;
               ENU=Value Entry];
    LookupPageID=Page5802;
    DrillDownPageID=Page5802;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Item No.            ;Code20        ;TableRelation=Item;
                                                   CaptionML=[DAN=Varenr.;
                                                              ENU=Item No.] }
    { 3   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 4   ;   ;Item Ledger Entry Type;Option      ;CaptionML=[DAN=Vareposttype;
                                                              ENU=Item Ledger Entry Type];
                                                   OptionCaptionML=[DAN=Kõb,Salg,Opregulering,Nedregulering,Overfõrsel,Forbrug,Afgang, ,Montageforbrug,Montageoutput;
                                                                    ENU=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output];
                                                   OptionString=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output }
    { 5   ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) Customer
                                                                 ELSE IF (Source Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Source Type=CONST(Item)) Item;
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 6   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 7   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 8   ;   ;Location Code       ;Code10        ;TableRelation=Location;
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 9   ;   ;Inventory Posting Group;Code20     ;TableRelation="Inventory Posting Group";
                                                   CaptionML=[DAN=Varebogfõringsgruppe;
                                                              ENU=Inventory Posting Group] }
    { 10  ;   ;Source Posting Group;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) "Customer Posting Group"
                                                                 ELSE IF (Source Type=CONST(Vendor)) "Vendor Posting Group"
                                                                 ELSE IF (Source Type=CONST(Item)) "Inventory Posting Group";
                                                   CaptionML=[DAN=Kildebogf.gruppe;
                                                              ENU=Source Posting Group] }
    { 11  ;   ;Item Ledger Entry No.;Integer      ;TableRelation="Item Ledger Entry";
                                                   CaptionML=[DAN=Varepostlõbenr.;
                                                              ENU=Item Ledger Entry No.] }
    { 12  ;   ;Valued Quantity     ;Decimal       ;CaptionML=[DAN=Vërdiansat antal;
                                                              ENU=Valued Quantity];
                                                   DecimalPlaces=0:5 }
    { 13  ;   ;Item Ledger Entry Quantity;Decimal ;CaptionML=[DAN=Varepostmëngde;
                                                              ENU=Item Ledger Entry Quantity];
                                                   DecimalPlaces=0:5 }
    { 14  ;   ;Invoiced Quantity   ;Decimal       ;CaptionML=[DAN=Faktureret antal;
                                                              ENU=Invoiced Quantity];
                                                   DecimalPlaces=0:5 }
    { 15  ;   ;Cost per Unit       ;Decimal       ;CaptionML=[DAN=Kostvërdi pr. enhed;
                                                              ENU=Cost per Unit];
                                                   AutoFormatType=2 }
    { 17  ;   ;Sales Amount (Actual);Decimal      ;CaptionML=[DAN=Salgsbelõb (faktisk);
                                                              ENU=Sales Amount (Actual)];
                                                   AutoFormatType=1 }
    { 22  ;   ;Salespers./Purch. Code;Code20      ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Sëlger/indkõberkode;
                                                              ENU=Salespers./Purch. Code] }
    { 23  ;   ;Discount Amount     ;Decimal       ;CaptionML=[DAN=Rabatbelõb;
                                                              ENU=Discount Amount];
                                                   AutoFormatType=1 }
    { 24  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 25  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 28  ;   ;Applies-to Entry    ;Integer       ;CaptionML=[DAN=Udlign.postlõbenr.;
                                                              ENU=Applies-to Entry] }
    { 33  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 34  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 41  ;   ;Source Type         ;Option        ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Vare";
                                                                    ENU=" ,Customer,Vendor,Item"];
                                                   OptionString=[ ,Customer,Vendor,Item] }
    { 43  ;   ;Cost Amount (Actual);Decimal       ;CaptionML=[DAN=Kostbelõb (faktisk);
                                                              ENU=Cost Amount (Actual)];
                                                   AutoFormatType=1 }
    { 45  ;   ;Cost Posted to G/L  ;Decimal       ;CaptionML=[DAN=Bogfõrt kostvërdi;
                                                              ENU=Cost Posted to G/L];
                                                   AutoFormatType=1 }
    { 46  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   AccessByPermission=TableData 223=R;
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 47  ;   ;Drop Shipment       ;Boolean       ;CaptionML=[DAN=Direkte levering;
                                                              ENU=Drop Shipment] }
    { 48  ;   ;Journal Batch Name  ;Code10        ;TestTableRelation=No;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 57  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 58  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogfõringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 60  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 61  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 68  ;   ;Cost Amount (Actual) (ACY);Decimal ;CaptionML=[DAN=Kostbelõb (faktisk) (EV);
                                                              ENU=Cost Amount (Actual) (ACY)];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 70  ;   ;Cost Posted to G/L (ACY);Decimal   ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Bogfõrt kostvërdi (EV);
                                                              ENU=Cost Posted to G/L (ACY)];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 72  ;   ;Cost per Unit (ACY) ;Decimal       ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Kostvërdi pr. enhed (EV);
                                                              ENU=Cost per Unit (ACY)];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 79  ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Salgsleverance,Salgsfaktura,Salgsreturvarekvittering,Salgskreditnota,Kõbsleverance,Kõbsfaktura,Kõbsreturvarekvittering,Kõbskreditnota,Overfõrselsleverance,Overfõrselskvittering,Serviceleverance,Servicefaktura,Servicekreditnota,Bogfõrt montage";
                                                                    ENU=" ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly"];
                                                   OptionString=[ ,Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Transfer Shipment,Transfer Receipt,Service Shipment,Service Invoice,Service Credit Memo,Posted Assembly] }
    { 80  ;   ;Document Line No.   ;Integer       ;CaptionML=[DAN=Dokumentlinjenr.;
                                                              ENU=Document Line No.] }
    { 90  ;   ;Order Type          ;Option        ;CaptionML=[DAN=Ordretype;
                                                              ENU=Order Type];
                                                   OptionCaptionML=[DAN=" ,Produktion,Overfõrsel,Service,Montage";
                                                                    ENU=" ,Production,Transfer,Service,Assembly"];
                                                   OptionString=[ ,Production,Transfer,Service,Assembly];
                                                   Editable=No }
    { 91  ;   ;Order No.           ;Code20        ;CaptionML=[DAN=Ordrenr.;
                                                              ENU=Order No.];
                                                   Editable=No }
    { 92  ;   ;Order Line No.      ;Integer       ;CaptionML=[DAN=Ordrelinjenr.;
                                                              ENU=Order Line No.];
                                                   Editable=No }
    { 98  ;   ;Expected Cost       ;Boolean       ;CaptionML=[DAN=Forventet kostpris;
                                                              ENU=Expected Cost] }
    { 99  ;   ;Item Charge No.     ;Code20        ;TableRelation="Item Charge";
                                                   CaptionML=[DAN=Varegebyrnr.;
                                                              ENU=Item Charge No.] }
    { 100 ;   ;Valued By Average Cost;Boolean     ;CaptionML=[DAN=Vërdisat efter gnsn. kostpris;
                                                              ENU=Valued By Average Cost] }
    { 102 ;   ;Partial Revaluation ;Boolean       ;CaptionML=[DAN=Delvis vërdiregulering;
                                                              ENU=Partial Revaluation] }
    { 103 ;   ;Inventoriable       ;Boolean       ;CaptionML=[DAN=Lagermëssig;
                                                              ENU=Inventoriable] }
    { 104 ;   ;Valuation Date      ;Date          ;CaptionML=[DAN=Vërdiansëttelsesdato;
                                                              ENU=Valuation Date] }
    { 105 ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Kõbspris,Vërdiregulering,Afrunding,Indir. omkostning,Afvigelse;
                                                                    ENU=Direct Cost,Revaluation,Rounding,Indirect Cost,Variance];
                                                   OptionString=Direct Cost,Revaluation,Rounding,Indirect Cost,Variance;
                                                   Editable=No }
    { 106 ;   ;Variance Type       ;Option        ;CaptionML=[DAN=Afvigelsestype;
                                                              ENU=Variance Type];
                                                   OptionCaptionML=[DAN=" ,Kõb,Materiale,Kapacitet,Indirekte kap.kostpris,Indirekte prod.kostpris,Underleverandõr";
                                                                    ENU=" ,Purchase,Material,Capacity,Capacity Overhead,Manufacturing Overhead,Subcontracted"];
                                                   OptionString=[ ,Purchase,Material,Capacity,Capacity Overhead,Manufacturing Overhead,Subcontracted];
                                                   Editable=No }
    { 148 ;   ;Purchase Amount (Actual);Decimal   ;CaptionML=[DAN=Kõbsbelõb (faktisk);
                                                              ENU=Purchase Amount (Actual)];
                                                   AutoFormatType=1 }
    { 149 ;   ;Purchase Amount (Expected);Decimal ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Kõbsbelõb (forventet);
                                                              ENU=Purchase Amount (Expected)];
                                                   AutoFormatType=1 }
    { 150 ;   ;Sales Amount (Expected);Decimal    ;AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Salgsbelõb (forventet);
                                                              ENU=Sales Amount (Expected)];
                                                   AutoFormatType=1 }
    { 151 ;   ;Cost Amount (Expected);Decimal     ;CaptionML=[DAN=Kostbelõb (forventet);
                                                              ENU=Cost Amount (Expected)];
                                                   AutoFormatType=1 }
    { 152 ;   ;Cost Amount (Non-Invtbl.);Decimal  ;AccessByPermission=TableData 5800=R;
                                                   CaptionML=[DAN=Kostbelõb (ikke-lager);
                                                              ENU=Cost Amount (Non-Invtbl.)];
                                                   AutoFormatType=1 }
    { 156 ;   ;Cost Amount (Expected) (ACY);Decimal;
                                                   CaptionML=[DAN=Kostbelõb (forventet) (EV);
                                                              ENU=Cost Amount (Expected) (ACY)];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 157 ;   ;Cost Amount (Non-Invtbl.)(ACY);Decimal;
                                                   AccessByPermission=TableData 5800=R;
                                                   CaptionML=[DAN=Kostbelõb (ikke-lager) (EV);
                                                              ENU=Cost Amount (Non-Invtbl.)(ACY)];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 158 ;   ;Expected Cost Posted to G/L;Decimal;CaptionML=[DAN=Bogfõrt forventet kostpris;
                                                              ENU=Expected Cost Posted to G/L];
                                                   AutoFormatType=1 }
    { 159 ;   ;Exp. Cost Posted to G/L (ACY);Decimal;
                                                   CaptionML=[DAN=Bogfõrt forv. kostpris (EV);
                                                              ENU=Exp. Cost Posted to G/L (ACY)];
                                                   AutoFormatType=1 }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 1000;   ;Job No.             ;Code20        ;TableRelation=Job.No.;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 1001;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 1002;   ;Job Ledger Entry No.;Integer       ;TableRelation="Job Ledger Entry"."Entry No.";
                                                   CaptionML=[DAN=Sagspostlõbenr.;
                                                              ENU=Job Ledger Entry No.];
                                                   BlankZero=Yes }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation="Item Variant".Code WHERE (Item No.=FIELD(Item No.));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5818;   ;Adjustment          ;Boolean       ;CaptionML=[DAN=Regulering;
                                                              ENU=Adjustment];
                                                   Editable=No }
    { 5819;   ;Average Cost Exception;Boolean     ;CaptionML=[DAN=Tilpasning af gennemsnitlig kostpris;
                                                              ENU=Average Cost Exception] }
    { 5831;   ;Capacity Ledger Entry No.;Integer  ;TableRelation="Capacity Ledger Entry";
                                                   CaptionML=[DAN=Kapacitetspostlõbenr.;
                                                              ENU=Capacity Ledger Entry No.] }
    { 5832;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Arbejdscenter,Produktionsressource, ,Ressource;
                                                                    ENU=Work Center,Machine Center, ,Resource];
                                                   OptionString=Work Center,Machine Center, ,Resource }
    { 5834;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(Machine Center)) "Machine Center"
                                                                 ELSE IF (Type=CONST(Work Center)) "Work Center"
                                                                 ELSE IF (Type=CONST(Resource)) Resource;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 6602;   ;Return Reason Code  ;Code10        ;TableRelation="Return Reason";
                                                   CaptionML=[DAN=ReturÜrsagskode;
                                                              ENU=Return Reason Code] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Item Ledger Entry No.,Entry Type        ;SumIndexFields=Invoiced Quantity,Sales Amount (Expected),Sales Amount (Actual),Cost Amount (Expected),Cost Amount (Actual),Cost Amount (Non-Invtbl.),Cost Amount (Expected) (ACY),Cost Amount (Actual) (ACY),Cost Amount (Non-Invtbl.)(ACY),Purchase Amount (Actual),Purchase Amount (Expected),Discount Amount }
    { No ;Item Ledger Entry No.,Document No.,Document Line No.;
                                                   MaintainSQLIndex=No }
    {    ;Item No.,Posting Date,Item Ledger Entry Type,Entry Type,Variance Type,Item Charge No.,Location Code,Variant Code;
                                                   SumIndexFields=Invoiced Quantity,Sales Amount (Expected),Sales Amount (Actual),Cost Amount (Expected),Cost Amount (Actual),Cost Amount (Non-Invtbl.),Purchase Amount (Actual),Expected Cost Posted to G/L,Cost Posted to G/L,Item Ledger Entry Quantity }
    { No ;Item No.,Posting Date,Item Ledger Entry Type,Entry Type,Variance Type,Item Charge No.,Location Code,Variant Code,Global Dimension 1 Code,Global Dimension 2 Code,Source Type,Source No.;
                                                   SumIndexFields=Invoiced Quantity,Sales Amount (Expected),Sales Amount (Actual),Cost Amount (Expected),Cost Amount (Actual),Cost Amount (Non-Invtbl.),Purchase Amount (Actual),Expected Cost Posted to G/L,Cost Posted to G/L,Item Ledger Entry Quantity }
    {    ;Document No.                             }
    {    ;Item No.,Valuation Date,Location Code,Variant Code;
                                                   SumIndexFields=Cost Amount (Expected),Cost Amount (Actual),Cost Amount (Expected) (ACY),Cost Amount (Actual) (ACY),Item Ledger Entry Quantity }
    {    ;Source Type,Source No.,Item No.,Posting Date,Entry Type,Adjustment,Item Ledger Entry Type;
                                                   SumIndexFields=Discount Amount,Cost Amount (Non-Invtbl.),Cost Amount (Actual),Cost Amount (Expected),Sales Amount (Actual),Sales Amount (Expected),Invoiced Quantity }
    {    ;Item Charge No.,Inventory Posting Group,Item No. }
    {    ;Capacity Ledger Entry No.,Entry Type    ;SumIndexFields=Cost Amount (Actual),Cost Amount (Actual) (ACY) }
    {    ;Order Type,Order No.,Order Line No.      }
    { No ;Source Type,Source No.,Global Dimension 1 Code,Global Dimension 2 Code,Item No.,Posting Date,Entry Type,Adjustment;
                                                   SumIndexFields=Discount Amount,Cost Amount (Non-Invtbl.),Cost Amount (Actual),Cost Amount (Expected),Sales Amount (Actual),Sales Amount (Expected),Invoiced Quantity }
    {    ;Job No.,Job Task No.,Document No.        }
    {    ;Item Ledger Entry Type,Posting Date,Item No.,Inventory Posting Group,Dimension Set ID;
                                                   SumIndexFields=Invoiced Quantity,Sales Amount (Actual),Purchase Amount (Actual) }
    { No ;Item Ledger Entry No.,Valuation Date     }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Item Ledger Entry Type,Item Ledger Entry No.,Item No.,Posting Date,Source No.,Document No. }
  }
  CODE
  {
    VAR
      GLSetup@1000 : Record 98;
      GLSetupRead@1002 : Boolean;

    LOCAL PROCEDURE GetCurrencyCode@1() : Code[10];
    BEGIN
      IF NOT GLSetupRead THEN BEGIN
        GLSetup.GET;
        GLSetupRead := TRUE;
      END;
      EXIT(GLSetup."Additional Reporting Currency");
    END;

    [External]
    PROCEDURE GetValuationDate@55() : Date;
    BEGIN
      IF "Valuation Date" < "Posting Date" THEN
        EXIT("Posting Date");
      EXIT("Valuation Date");
    END;

    [External]
    PROCEDURE AddCost@3(InvtAdjmtBuffer@1000 : Record 5895);
    BEGIN
      "Cost Amount (Expected)" := "Cost Amount (Expected)" + InvtAdjmtBuffer."Cost Amount (Expected)";
      "Cost Amount (Expected) (ACY)" := "Cost Amount (Expected) (ACY)" + InvtAdjmtBuffer."Cost Amount (Expected) (ACY)";
      "Cost Amount (Actual)" := "Cost Amount (Actual)" + InvtAdjmtBuffer."Cost Amount (Actual)";
      "Cost Amount (Actual) (ACY)" := "Cost Amount (Actual) (ACY)" + InvtAdjmtBuffer."Cost Amount (Actual) (ACY)";
    END;

    [Internal]
    PROCEDURE SumCostsTillValuationDate@4(VAR ValueEntry@1000 : Record 5802);
    VAR
      AccountingPeriod@1002 : Record 50;
      PrevValueEntrySum@1008 : Record 5802;
      Item@1010 : Record 27;
      FromDate@1005 : Date;
      ToDate@1006 : Date;
      CostCalcIsChanged@1004 : Boolean;
      QtyFactor@1009 : Decimal;
    BEGIN
      Item.GET(ValueEntry."Item No.");
      IF Item."Costing Method" = Item."Costing Method"::Average THEN
        ToDate := GetAvgToDate(ValueEntry."Valuation Date")
      ELSE
        ToDate := ValueEntry."Valuation Date";

      REPEAT
        IF Item."Costing Method" = Item."Costing Method"::Average THEN
          FromDate := GetAvgFromDate(ToDate,AccountingPeriod,CostCalcIsChanged)
        ELSE
          FromDate := 0D;

        QtyFactor := 1;
        RESET;
        SETCURRENTKEY("Item No.","Valuation Date","Location Code","Variant Code");
        SETRANGE("Item No.",ValueEntry."Item No.");
        SETRANGE("Valuation Date",FromDate,ToDate);
        IF (AccountingPeriod."Average Cost Calc. Type" =
            AccountingPeriod."Average Cost Calc. Type"::"Item & Location & Variant") OR
           (Item."Costing Method" <> Item."Costing Method"::Average)
        THEN BEGIN
          SETRANGE("Location Code",ValueEntry."Location Code");
          SETRANGE("Variant Code",ValueEntry."Variant Code");
        END ELSE
          IF CostCalcIsChanged THEN
            QtyFactor := ValueEntry.CalcQtyFactor(FromDate,ToDate);

        CALCSUMS(
          "Item Ledger Entry Quantity","Invoiced Quantity",
          "Cost Amount (Actual)","Cost Amount (Actual) (ACY)",
          "Cost Amount (Expected)","Cost Amount (Expected) (ACY)");

        "Item Ledger Entry Quantity" :=
          ROUND("Item Ledger Entry Quantity" * QtyFactor,0.00001) + PrevValueEntrySum."Item Ledger Entry Quantity";
        "Invoiced Quantity" :=
          ROUND("Invoiced Quantity" * QtyFactor,0.00001) + PrevValueEntrySum."Invoiced Quantity";
        "Cost Amount (Actual)" :=
          "Cost Amount (Actual)" * QtyFactor + PrevValueEntrySum."Cost Amount (Actual)";
        "Cost Amount (Expected)" :=
          "Cost Amount (Expected)" * QtyFactor + PrevValueEntrySum."Cost Amount (Expected)";
        "Cost Amount (Expected) (ACY)" :=
          "Cost Amount (Expected) (ACY)" * QtyFactor + PrevValueEntrySum."Cost Amount (Expected) (ACY)";
        "Cost Amount (Actual) (ACY)" :=
          "Cost Amount (Actual) (ACY)" * QtyFactor + PrevValueEntrySum."Cost Amount (Actual) (ACY)";
        PrevValueEntrySum := Rec;

        IF FromDate <> 0D THEN
          ToDate := CALCDATE('<-1D>',FromDate);
      UNTIL FromDate = 0D;
    END;

    [External]
    PROCEDURE CalcItemLedgEntryCost@5(ItemLedgEntryNo@1000 : Integer;Expected@1001 : Boolean);
    VAR
      ItemLedgEntryQty@1006 : Decimal;
      CostAmtActual@1002 : Decimal;
      CostAmtActualACY@1003 : Decimal;
      CostAmtExpected@1004 : Decimal;
      CostAmtExpectedACY@1005 : Decimal;
    BEGIN
      RESET;
      SETCURRENTKEY("Item Ledger Entry No.");
      SETRANGE("Item Ledger Entry No.",ItemLedgEntryNo);
      IF FIND('-') THEN
        REPEAT
          IF "Expected Cost" = Expected THEN BEGIN
            ItemLedgEntryQty := ItemLedgEntryQty + "Item Ledger Entry Quantity";
            CostAmtActual := CostAmtActual + "Cost Amount (Actual)";
            CostAmtActualACY := CostAmtActualACY + "Cost Amount (Actual) (ACY)";
            CostAmtExpected := CostAmtExpected + "Cost Amount (Expected)";
            CostAmtExpectedACY := CostAmtExpectedACY + "Cost Amount (Expected) (ACY)";
          END;
        UNTIL NEXT = 0;

      "Item Ledger Entry Quantity" := ItemLedgEntryQty;
      "Cost Amount (Actual)" := CostAmtActual;
      "Cost Amount (Actual) (ACY)" := CostAmtActualACY;
      "Cost Amount (Expected)" := CostAmtExpected;
      "Cost Amount (Expected) (ACY)" := CostAmtExpectedACY;
    END;

    [External]
    PROCEDURE NotInvdRevaluationExists@7(ItemLedgEntryNo@1000 : Integer) : Boolean;
    BEGIN
      RESET;
      SETCURRENTKEY("Item Ledger Entry No.","Entry Type");
      SETRANGE("Item Ledger Entry No.",ItemLedgEntryNo);
      SETRANGE("Entry Type","Entry Type"::Revaluation);
      SETRANGE("Applies-to Entry",0);
      EXIT(FINDSET);
    END;

    [External]
    PROCEDURE CalcQtyFactor@8(FromDate@1000 : Date;ToDate@1002 : Date) QtyFactor : Decimal;
    VAR
      ValueEntry2@1001 : Record 5802;
    BEGIN
      ValueEntry2.SETCURRENTKEY("Item No.","Valuation Date","Location Code","Variant Code");
      ValueEntry2.SETRANGE("Item No.","Item No.");
      ValueEntry2.SETRANGE("Valuation Date",FromDate,ToDate);
      ValueEntry2.SETRANGE("Location Code","Location Code");
      ValueEntry2.SETRANGE("Variant Code","Variant Code");
      ValueEntry2.CALCSUMS("Item Ledger Entry Quantity");
      QtyFactor := ValueEntry2."Item Ledger Entry Quantity";

      ValueEntry2.SETRANGE("Location Code");
      ValueEntry2.SETRANGE("Variant Code");
      ValueEntry2.CALCSUMS("Item Ledger Entry Quantity");
      IF ValueEntry2."Item Ledger Entry Quantity" <> 0 THEN
        QtyFactor := QtyFactor / ValueEntry2."Item Ledger Entry Quantity";

      EXIT(QtyFactor);
    END;

    [External]
    PROCEDURE ShowGL@9();
    VAR
      GLItemLedgRelation@1000 : Record 5823;
      GLEntry@1002 : Record 17;
      TempGLEntry@1001 : TEMPORARY Record 17;
    BEGIN
      GLItemLedgRelation.SETCURRENTKEY("Value Entry No.");
      GLItemLedgRelation.SETRANGE("Value Entry No.","Entry No.");
      IF GLItemLedgRelation.FINDSET THEN
        REPEAT
          GLEntry.GET(GLItemLedgRelation."G/L Entry No.");
          TempGLEntry.INIT;
          TempGLEntry := GLEntry;
          TempGLEntry.INSERT;
        UNTIL GLItemLedgRelation.NEXT = 0;

      PAGE.RUNMODAL(0,TempGLEntry);
    END;

    [External]
    PROCEDURE IsAvgCostException@10(IsAvgCostCalcTypeItem@1000 : Boolean) : Boolean;
    VAR
      ItemApplnEntry@1001 : Record 339;
      ItemLedgEntry@1002 : Record 32;
      TempItemLedgEntry@1005 : TEMPORARY Record 32;
    BEGIN
      IF "Partial Revaluation" THEN
        EXIT(TRUE);
      IF "Item Charge No." <> '' THEN
        EXIT(TRUE);

      ItemLedgEntry.GET("Item Ledger Entry No.");
      IF ItemLedgEntry.Positive THEN
        EXIT(FALSE);

      ItemApplnEntry.GetVisitedEntries(ItemLedgEntry,TempItemLedgEntry,TRUE);
      TempItemLedgEntry.SETCURRENTKEY("Item No.",Positive,"Location Code","Variant Code");
      TempItemLedgEntry.SETRANGE("Item No.","Item No.");
      TempItemLedgEntry.SETRANGE(Positive,TRUE);
      IF NOT IsAvgCostCalcTypeItem THEN BEGIN
        TempItemLedgEntry.SETRANGE("Location Code","Location Code");
        TempItemLedgEntry.SETRANGE("Variant Code","Variant Code");
      END;
      EXIT(NOT TempItemLedgEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE ShowDimensions@11();
    VAR
      DimMgt@1000 : Codeunit 408;
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    [Internal]
    PROCEDURE GetAvgToDate@2(ToDate@1002 : Date) : Date;
    VAR
      CalendarPeriod@1000 : Record 2000000007;
      AvgCostAdjmtEntryPoint@1001 : Record 5804;
    BEGIN
      CalendarPeriod."Period Start" := ToDate;
      AvgCostAdjmtEntryPoint."Valuation Date" := ToDate;
      AvgCostAdjmtEntryPoint.GetValuationPeriod(CalendarPeriod);
      EXIT(CalendarPeriod."Period End");
    END;

    PROCEDURE GetAvgFromDate@6(ToDate@1002 : Date;VAR AccountingPeriod@1007 : Record 50;VAR CostCalcIsChanged@1001 : Boolean) FromDate : Date;
    VAR
      PrevAccountingPeriod@1000 : Record 50;
    BEGIN
      FromDate := ToDate;
      AccountingPeriod.SETRANGE("Starting Date",0D,ToDate);
      AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
      IF NOT AccountingPeriod.FIND('+') THEN BEGIN
        AccountingPeriod.SETRANGE("Starting Date");
        AccountingPeriod.FIND('-');
      END;

      WHILE (FromDate = ToDate) AND (FromDate <> 0D) DO BEGIN
        PrevAccountingPeriod := AccountingPeriod;
        CASE TRUE OF
          AccountingPeriod."Average Cost Calc. Type" = AccountingPeriod."Average Cost Calc. Type"::Item:
            FromDate := 0D;
          AccountingPeriod.NEXT(-1) = 0:
            FromDate := 0D;
          AccountingPeriod."Average Cost Calc. Type" <> PrevAccountingPeriod."Average Cost Calc. Type":
            BEGIN
              AccountingPeriod := PrevAccountingPeriod;
              FromDate := PrevAccountingPeriod."Starting Date";
              CostCalcIsChanged := TRUE;
              EXIT;
            END;
        END;
      END;
      AccountingPeriod := PrevAccountingPeriod;
    END;

    PROCEDURE FindFirstValueEntryByItemLedgerEntryNo@13(ItemLedgerEntryNo@1000 : Integer);
    BEGIN
      RESET;
      SETCURRENTKEY("Item Ledger Entry No.");
      SETRANGE("Item Ledger Entry No.",ItemLedgerEntryNo);
      FINDFIRST;
    END;

    [External]
    PROCEDURE IsInbound@12() : Boolean;
    BEGIN
      IF (("Item Ledger Entry Type" IN
           ["Item Ledger Entry Type"::Purchase,
            "Item Ledger Entry Type"::"Positive Adjmt.",
            "Item Ledger Entry Type"::"Assembly Output"]) OR
          ("Item Ledger Entry Type" = "Item Ledger Entry Type"::Output) AND ("Invoiced Quantity" > 0))
      THEN
        EXIT(TRUE);
      EXIT(FALSE);
    END;

    BEGIN
    END.
  }
}

