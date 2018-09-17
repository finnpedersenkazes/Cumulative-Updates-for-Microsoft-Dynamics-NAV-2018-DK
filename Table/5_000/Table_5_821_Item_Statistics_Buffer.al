OBJECT Table 5821 Item Statistics Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Code;
    CaptionML=[DAN=Varestatistikbuffer;
               ENU=Item Statistics Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Item Filter         ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Item;
                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Varefilter;
                                                              ENU=Item Filter] }
    { 3   ;   ;Variant Filter      ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="Item Variant".Code;
                                                   CaptionML=[DAN=Variantfilter;
                                                              ENU=Variant Filter] }
    { 4   ;   ;Location Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Location;
                                                   CaptionML=[DAN=Lokationsfilter;
                                                              ENU=Location Filter] }
    { 5   ;   ;Budget Filter       ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="Item Budget Name".Name WHERE (Analysis Area=FIELD(Analysis Area Filter));
                                                   CaptionML=[DAN=Budgetfilter;
                                                              ENU=Budget Filter] }
    { 6   ;   ;Global Dimension 1 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-filter;
                                                              ENU=Global Dimension 1 Filter];
                                                   CaptionClass='1,3,1' }
    { 7   ;   ;Global Dimension 2 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-filter;
                                                              ENU=Global Dimension 2 Filter];
                                                   CaptionClass='1,3,2' }
    { 9   ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter];
                                                   ClosingDates=Yes }
    { 10  ;   ;Entry Type Filter   ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Posttypefilter;
                                                              ENU=Entry Type Filter];
                                                   OptionCaptionML=[DAN=K›bspris,V‘rdiregulering,Afrunding,Indir. omkostning,Afvigelse;
                                                                    ENU=Direct Cost,Revaluation,Rounding,Indirect Cost,Variance];
                                                   OptionString=Direct Cost,Revaluation,Rounding,Indirect Cost,Variance }
    { 11  ;   ;Item Ledger Entry Type Filter;Option;
                                                   FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Vareposttypefilter;
                                                              ENU=Item Ledger Entry Type Filter];
                                                   OptionCaptionML=[DAN=K›b,Salg,Opregulering,Nedregulering,Overf›rsel,Forbrug,Afgang, ,Montageforbrug,Montageoutput;
                                                                    ENU=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output];
                                                   OptionString=Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output }
    { 12  ;   ;Item Charge No. Filter;Code20      ;FieldClass=FlowFilter;
                                                   TableRelation="Item Charge";
                                                   CaptionML=[DAN=Varegebyrnr.filter;
                                                              ENU=Item Charge No. Filter] }
    { 13  ;   ;Source Type Filter  ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Kildetypefilter;
                                                              ENU=Source Type Filter];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,S‘lger/indk›ber,Vare";
                                                                    ENU=" ,Customer,Vendor,Salesperson/Purchaser,Item"];
                                                   OptionString=[ ,Customer,Vendor,Salesperson/Purchaser,Item] }
    { 14  ;   ;Source No. Filter   ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=IF (Source Type Filter=CONST(Customer)) Customer
                                                                 ELSE IF (Source Type Filter=CONST(Vendor)) Vendor
                                                                 ELSE IF (Source Type Filter=CONST(Item)) Item;
                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Kildenummerfilter;
                                                              ENU=Source No. Filter] }
    { 15  ;   ;Invoiced Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Invoiced Quantity" WHERE (Item No.=FIELD(Item Filter),
                                                                                                            Posting Date=FIELD(Date Filter),
                                                                                                            Variant Code=FIELD(Variant Filter),
                                                                                                            Location Code=FIELD(Location Filter),
                                                                                                            Entry Type=FIELD(Entry Type Filter),
                                                                                                            Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                            Variance Type=FIELD(Variance Type Filter),
                                                                                                            Item Charge No.=FIELD(Item Charge No. Filter),
                                                                                                            Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                            Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                            Source Type=FIELD(Source Type Filter),
                                                                                                            Source No.=FIELD(Source No. Filter)));
                                                   CaptionML=[DAN=Faktureret antal;
                                                              ENU=Invoiced Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 16  ;   ;Sales Amount (Actual);Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Sales Amount (Actual)" WHERE (Item No.=FIELD(Item Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                                Entry Type=FIELD(Entry Type Filter),
                                                                                                                Variance Type=FIELD(Variance Type Filter),
                                                                                                                Location Code=FIELD(Location Filter),
                                                                                                                Variant Code=FIELD(Variant Filter),
                                                                                                                Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                Item Charge No.=FIELD(Item Charge No. Filter),
                                                                                                                Source Type=FIELD(Source Type Filter),
                                                                                                                Source No.=FIELD(Source No. Filter)));
                                                   CaptionML=[DAN=Salgsbel›b (faktisk);
                                                              ENU=Sales Amount (Actual)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 17  ;   ;Cost Amount (Actual);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item No.=FIELD(Item Filter),
                                                                                                               Posting Date=FIELD(Date Filter),
                                                                                                               Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                               Entry Type=FIELD(Entry Type Filter),
                                                                                                               Variance Type=FIELD(Variance Type Filter),
                                                                                                               Location Code=FIELD(Location Filter),
                                                                                                               Variant Code=FIELD(Variant Filter),
                                                                                                               Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                               Item Charge No.=FIELD(Item Charge No. Filter),
                                                                                                               Source Type=FIELD(Source Type Filter),
                                                                                                               Source No.=FIELD(Source No. Filter)));
                                                   CaptionML=[DAN=Kostbel›b (faktisk);
                                                              ENU=Cost Amount (Actual)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 18  ;   ;Cost Amount (Non-Invtbl.);Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Cost Amount (Non-Invtbl.)" WHERE (Item No.=FIELD(Item Filter),
                                                                                                                    Posting Date=FIELD(Date Filter),
                                                                                                                    Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                                    Variance Type=FIELD(Variance Type Filter),
                                                                                                                    Entry Type=FIELD(Entry Type Filter),
                                                                                                                    Location Code=FIELD(Location Filter),
                                                                                                                    Variant Code=FIELD(Variant Filter),
                                                                                                                    Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                    Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                    Item Charge No.=FIELD(Item Charge No. Filter),
                                                                                                                    Source Type=FIELD(Source Type Filter),
                                                                                                                    Source No.=FIELD(Source No. Filter)));
                                                   CaptionML=[DAN=Kostbel›b (ikke-lager);
                                                              ENU=Cost Amount (Non-Invtbl.)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 19  ;   ;Variance Type Filter;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Afvigelsestypefilter;
                                                              ENU=Variance Type Filter];
                                                   OptionCaptionML=[DAN=" ,K›b,Materiale,Kapacitet,Indirekte kap.kostpris,Indirekte prod.kostpris,Underleverand›r";
                                                                    ENU=" ,Purchase,Material,Capacity,Capacity Overhead,Manufacturing Overhead,Subcontracted"];
                                                   OptionString=[ ,Purchase,Material,Capacity,Capacity Overhead,Manufacturing Overhead,Subcontracted] }
    { 20  ;   ;Sales (LCY)         ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Salg (RV);
                                                              ENU=Sales (LCY)] }
    { 21  ;   ;COGS (LCY)          ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Vareforbrug (RV);
                                                              ENU=COGS (LCY)] }
    { 22  ;   ;Profit (LCY)        ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Avancebel›b (RV);
                                                              ENU=Profit (LCY)] }
    { 23  ;   ;Profit %            ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Avancepct.;
                                                              ENU=Profit %] }
    { 24  ;   ;Inventoriable Costs ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lagerm‘ssige omk.;
                                                              ENU=Inventoriable Costs] }
    { 25  ;   ;Direct Cost (LCY)   ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=K›bspris (RV);
                                                              ENU=Direct Cost (LCY)] }
    { 26  ;   ;Revaluation (LCY)   ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=V‘rdiregulering (RV);
                                                              ENU=Revaluation (LCY)] }
    { 27  ;   ;Rounding (LCY)      ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afrunding (RV);
                                                              ENU=Rounding (LCY)] }
    { 28  ;   ;Indirect Cost (LCY) ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Indir. omkost. (RV);
                                                              ENU=Indirect Cost (LCY)] }
    { 29  ;   ;Variance (LCY)      ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Afvigelse (RV);
                                                              ENU=Variance (LCY)] }
    { 30  ;   ;Inventoriable Costs, Total;Integer ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lagerm‘ssige omk. i alt;
                                                              ENU=Inventoriable Costs, Total] }
    { 31  ;   ;Inventory (LCY)     ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Lagerbeholdning (RV);
                                                              ENU=Inventory (LCY)] }
    { 34  ;   ;Non-Invtbl. Costs (LCY);Integer    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kostpriser (ikke-lager) (RV);
                                                              ENU=Non-Invtbl. Costs (LCY)] }
    { 40  ;   ;Line Option         ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Linjeindstilling;
                                                              ENU=Line Option];
                                                   OptionCaptionML=[DAN=Avanceberegning,Kostprisspec.,K›bsvaregebyrspec.,Salgsvaregebyrspec.,Periode,Lokation;
                                                                    ENU=Profit Calculation,Cost Specification,Purch. Item Charge Spec.,Sales Item Charge Spec.,Period,Location];
                                                   OptionString=Profit Calculation,Cost Specification,Purch. Item Charge Spec.,Sales Item Charge Spec.,Period,Location }
    { 41  ;   ;Column Option       ;Option        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kolonneindstilling;
                                                              ENU=Column Option];
                                                   OptionCaptionML=[DAN=Avanceberegning,Kostprisspec.,K›bsvaregebyrspec.,Salgsvaregebyrspec.,Periode,Lokation;
                                                                    ENU=Profit Calculation,Cost Specification,Purch. Item Charge Spec.,Sales Item Charge Spec.,Period,Location];
                                                   OptionString=Profit Calculation,Cost Specification,Purch. Item Charge Spec.,Sales Item Charge Spec.,Period,Location }
    { 42  ;   ;Analysis Area Filter;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Analyseomr†defilter;
                                                              ENU=Analysis Area Filter];
                                                   OptionCaptionML=[DAN=Salg,K›b,Lager;
                                                                    ENU=Sale,Purchase,Inventory];
                                                   OptionString=Sale,Purchase,Inventory }
    { 45  ;   ;Quantity            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(Item Filter),
                                                                                                       Source Type=FIELD(Source Type Filter),
                                                                                                       Source No.=FIELD(Source No. Filter),
                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                       Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                       Location Code=FIELD(Location Filter),
                                                                                                       Variant Code=FIELD(Variant Filter),
                                                                                                       Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                       Global Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 46  ;   ;Sales Amount (Expected);Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Sales Amount (Expected)" WHERE (Item No.=FIELD(Item Filter),
                                                                                                                  Source Type=FIELD(Source Type Filter),
                                                                                                                  Source No.=FIELD(Source No. Filter),
                                                                                                                  Posting Date=FIELD(Date Filter),
                                                                                                                  Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                                  Variance Type=FIELD(Variance Type Filter),
                                                                                                                  Entry Type=FIELD(Entry Type Filter),
                                                                                                                  Location Code=FIELD(Location Filter),
                                                                                                                  Variant Code=FIELD(Variant Filter),
                                                                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Item Charge No.=FIELD(Item Charge No. Filter)));
                                                   CaptionML=[DAN=Salgsbel›b (forventet);
                                                              ENU=Sales Amount (Expected)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 47  ;   ;Cost Amount (Expected);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Value Entry"."Cost Amount (Expected)" WHERE (Item No.=FIELD(Item Filter),
                                                                                                                 Source Type=FIELD(Source Type Filter),
                                                                                                                 Source No.=FIELD(Source No. Filter),
                                                                                                                 Posting Date=FIELD(Date Filter),
                                                                                                                 Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                                 Variance Type=FIELD(Variance Type Filter),
                                                                                                                 Entry Type=FIELD(Entry Type Filter),
                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                 Variant Code=FIELD(Variant Filter),
                                                                                                                 Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                 Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                 Item Charge No.=FIELD(Item Charge No. Filter)));
                                                   CaptionML=[DAN=Kostbel›b (forventet);
                                                              ENU=Cost Amount (Expected)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 50  ;   ;Budgeted Quantity   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Budget Entry".Quantity WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                       Budget Name=FIELD(Budget Filter),
                                                                                                       Item No.=FIELD(Item Filter),
                                                                                                       Date=FIELD(Date Filter),
                                                                                                       Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                       Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                       Budget Dimension 1 Code=FIELD(Dimension 1 Filter),
                                                                                                       Budget Dimension 2 Code=FIELD(Dimension 2 Filter),
                                                                                                       Budget Dimension 3 Code=FIELD(Dimension 3 Filter),
                                                                                                       Source Type=FIELD(Source Type Filter),
                                                                                                       Source No.=FIELD(Source No. Filter),
                                                                                                       Location Code=FIELD(Location Filter)));
                                                   CaptionML=[DAN=Budgetteret antal;
                                                              ENU=Budgeted Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 51  ;   ;Budgeted Sales Amount;Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Budget Entry"."Sales Amount" WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                             Budget Name=FIELD(Budget Filter),
                                                                                                             Item No.=FIELD(Item Filter),
                                                                                                             Date=FIELD(Date Filter),
                                                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                             Budget Dimension 1 Code=FIELD(Dimension 1 Filter),
                                                                                                             Budget Dimension 2 Code=FIELD(Dimension 2 Filter),
                                                                                                             Budget Dimension 3 Code=FIELD(Dimension 3 Filter),
                                                                                                             Source Type=FIELD(Source Type Filter),
                                                                                                             Source No.=FIELD(Source No. Filter),
                                                                                                             Location Code=FIELD(Location Filter)));
                                                   CaptionML=[DAN=Budgetteret salgsbel›b;
                                                              ENU=Budgeted Sales Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 52  ;   ;Budgeted Cost Amount;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Budget Entry"."Cost Amount" WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                            Budget Name=FIELD(Budget Filter),
                                                                                                            Item No.=FIELD(Item Filter),
                                                                                                            Date=FIELD(Date Filter),
                                                                                                            Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                            Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                            Budget Dimension 1 Code=FIELD(Dimension 1 Filter),
                                                                                                            Budget Dimension 2 Code=FIELD(Dimension 2 Filter),
                                                                                                            Budget Dimension 3 Code=FIELD(Dimension 3 Filter),
                                                                                                            Source Type=FIELD(Source Type Filter),
                                                                                                            Source No.=FIELD(Source No. Filter),
                                                                                                            Location Code=FIELD(Location Filter)));
                                                   CaptionML=[DAN=Budgetteret kostbel›b;
                                                              ENU=Budgeted Cost Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 70  ;   ;Analysis View Filter;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="Item Analysis View".Code WHERE (Analysis Area=FIELD(Analysis Area Filter));
                                                   CaptionML=[DAN=Analysevisningsfilter;
                                                              ENU=Analysis View Filter] }
    { 71  ;   ;Dimension 1 Filter  ;Code20        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Dimension 1-filter;
                                                              ENU=Dimension 1 Filter] }
    { 72  ;   ;Dimension 2 Filter  ;Code20        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Dimension 2-filter;
                                                              ENU=Dimension 2 Filter] }
    { 73  ;   ;Dimension 3 Filter  ;Code20        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Dimension 3-filter;
                                                              ENU=Dimension 3 Filter] }
    { 80  ;   ;Analysis - Quantity ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Analysis View Entry".Quantity WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                              Analysis View Code=FIELD(Analysis View Filter),
                                                                                                              Item No.=FIELD(Item Filter),
                                                                                                              Location Code=FIELD(Location Filter),
                                                                                                              Dimension 1 Value Code=FIELD(Dimension 1 Filter),
                                                                                                              Dimension 2 Value Code=FIELD(Dimension 2 Filter),
                                                                                                              Dimension 3 Value Code=FIELD(Dimension 3 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Source Type=FIELD(Source Type Filter),
                                                                                                              Source No.=FIELD(Source No. Filter),
                                                                                                              Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                              Entry Type=FIELD(Entry Type Filter)));
                                                   CaptionML=[DAN=Analyse - antal;
                                                              ENU=Analysis - Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 81  ;   ;Analysis - Invoiced Quantity;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Analysis View Entry"."Invoiced Quantity" WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                                         Analysis View Code=FIELD(Analysis View Filter),
                                                                                                                         Item No.=FIELD(Item Filter),
                                                                                                                         Location Code=FIELD(Location Filter),
                                                                                                                         Dimension 1 Value Code=FIELD(Dimension 1 Filter),
                                                                                                                         Dimension 2 Value Code=FIELD(Dimension 2 Filter),
                                                                                                                         Dimension 3 Value Code=FIELD(Dimension 3 Filter),
                                                                                                                         Posting Date=FIELD(Date Filter),
                                                                                                                         Source Type=FIELD(Source Type Filter),
                                                                                                                         Source No.=FIELD(Source No. Filter),
                                                                                                                         Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                                         Entry Type=FIELD(Entry Type Filter)));
                                                   CaptionML=[DAN=Analyse - faktureret antal;
                                                              ENU=Analysis - Invoiced Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 82  ;   ;Analysis - Sales Amt. (Actual);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Analysis View Entry"."Sales Amount (Actual)" WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                                             Analysis View Code=FIELD(Analysis View Filter),
                                                                                                                             Item No.=FIELD(Item Filter),
                                                                                                                             Location Code=FIELD(Location Filter),
                                                                                                                             Dimension 1 Value Code=FIELD(Dimension 1 Filter),
                                                                                                                             Dimension 2 Value Code=FIELD(Dimension 2 Filter),
                                                                                                                             Dimension 3 Value Code=FIELD(Dimension 3 Filter),
                                                                                                                             Posting Date=FIELD(Date Filter),
                                                                                                                             Source Type=FIELD(Source Type Filter),
                                                                                                                             Source No.=FIELD(Source No. Filter),
                                                                                                                             Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                                             Entry Type=FIELD(Entry Type Filter)));
                                                   CaptionML=[DAN=Analyse - salgsbel›b (faktisk);
                                                              ENU=Analysis - Sales Amt. (Actual)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 83  ;   ;Analysis - Sales Amt. (Exp);Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Analysis View Entry"."Sales Amount (Expected)" WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                                               Analysis View Code=FIELD(Analysis View Filter),
                                                                                                                               Item No.=FIELD(Item Filter),
                                                                                                                               Location Code=FIELD(Location Filter),
                                                                                                                               Dimension 1 Value Code=FIELD(Dimension 1 Filter),
                                                                                                                               Dimension 2 Value Code=FIELD(Dimension 2 Filter),
                                                                                                                               Dimension 3 Value Code=FIELD(Dimension 3 Filter),
                                                                                                                               Posting Date=FIELD(Date Filter),
                                                                                                                               Source Type=FIELD(Source Type Filter),
                                                                                                                               Source No.=FIELD(Source No. Filter),
                                                                                                                               Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                                               Entry Type=FIELD(Entry Type Filter)));
                                                   CaptionML=[DAN=Analyse - salgsbel›b (forv.);
                                                              ENU=Analysis - Sales Amt. (Exp)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 84  ;   ;Analysis - Cost Amt. (Actual);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Analysis View Entry"."Cost Amount (Actual)" WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                                            Analysis View Code=FIELD(Analysis View Filter),
                                                                                                                            Item No.=FIELD(Item Filter),
                                                                                                                            Location Code=FIELD(Location Filter),
                                                                                                                            Dimension 1 Value Code=FIELD(Dimension 1 Filter),
                                                                                                                            Dimension 2 Value Code=FIELD(Dimension 2 Filter),
                                                                                                                            Dimension 3 Value Code=FIELD(Dimension 3 Filter),
                                                                                                                            Posting Date=FIELD(Date Filter),
                                                                                                                            Source Type=FIELD(Source Type Filter),
                                                                                                                            Source No.=FIELD(Source No. Filter),
                                                                                                                            Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                                            Entry Type=FIELD(Entry Type Filter)));
                                                   CaptionML=[DAN=Analyse - kostbel›b (faktisk);
                                                              ENU=Analysis - Cost Amt. (Actual)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 85  ;   ;Analysis - Cost Amt. (Exp);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Analysis View Entry"."Cost Amount (Expected)" WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                                              Analysis View Code=FIELD(Analysis View Filter),
                                                                                                                              Item No.=FIELD(Item Filter),
                                                                                                                              Location Code=FIELD(Location Filter),
                                                                                                                              Dimension 1 Value Code=FIELD(Dimension 1 Filter),
                                                                                                                              Dimension 2 Value Code=FIELD(Dimension 2 Filter),
                                                                                                                              Dimension 3 Value Code=FIELD(Dimension 3 Filter),
                                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                                              Source Type=FIELD(Source Type Filter),
                                                                                                                              Source No.=FIELD(Source No. Filter),
                                                                                                                              Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                                              Entry Type=FIELD(Entry Type Filter)));
                                                   CaptionML=[DAN=Analyse - kostbel›b (forv.);
                                                              ENU=Analysis - Cost Amt. (Exp)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 86  ;   ;Analysis CostAmt.(Non-Invtbl.);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Analysis View Entry"."Cost Amount (Non-Invtbl.)" WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                                                 Analysis View Code=FIELD(Analysis View Filter),
                                                                                                                                 Item No.=FIELD(Item Filter),
                                                                                                                                 Location Code=FIELD(Location Filter),
                                                                                                                                 Dimension 1 Value Code=FIELD(Dimension 1 Filter),
                                                                                                                                 Dimension 2 Value Code=FIELD(Dimension 2 Filter),
                                                                                                                                 Dimension 3 Value Code=FIELD(Dimension 3 Filter),
                                                                                                                                 Posting Date=FIELD(Date Filter),
                                                                                                                                 Source Type=FIELD(Source Type Filter),
                                                                                                                                 Source No.=FIELD(Source No. Filter),
                                                                                                                                 Item Ledger Entry Type=FIELD(Item Ledger Entry Type Filter),
                                                                                                                                 Entry Type=FIELD(Entry Type Filter)));
                                                   CaptionML=[DAN=Analyse - kostbl. (ikke-lager);
                                                              ENU=Analysis CostAmt.(Non-Invtbl.)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 91  ;   ;Analysis - Budgeted Quantity;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Analysis View Budg. Entry".Quantity WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                                    Analysis View Code=FIELD(Analysis View Filter),
                                                                                                                    Budget Name=FIELD(Budget Filter),
                                                                                                                    Item No.=FIELD(Item Filter),
                                                                                                                    Location Code=FIELD(Location Filter),
                                                                                                                    Dimension 1 Value Code=FIELD(Dimension 1 Filter),
                                                                                                                    Dimension 2 Value Code=FIELD(Dimension 2 Filter),
                                                                                                                    Dimension 3 Value Code=FIELD(Dimension 3 Filter),
                                                                                                                    Posting Date=FIELD(Date Filter),
                                                                                                                    Source Type=FIELD(Source Type Filter),
                                                                                                                    Source No.=FIELD(Source No. Filter)));
                                                   CaptionML=[DAN=Analyse - budgetteret antal;
                                                              ENU=Analysis - Budgeted Quantity];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 92  ;   ;Analysis - Budgeted Sales Amt.;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Analysis View Budg. Entry"."Sales Amount" WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                                          Analysis View Code=FIELD(Analysis View Filter),
                                                                                                                          Budget Name=FIELD(Budget Filter),
                                                                                                                          Item No.=FIELD(Item Filter),
                                                                                                                          Location Code=FIELD(Location Filter),
                                                                                                                          Dimension 1 Value Code=FIELD(Dimension 1 Filter),
                                                                                                                          Dimension 2 Value Code=FIELD(Dimension 2 Filter),
                                                                                                                          Dimension 3 Value Code=FIELD(Dimension 3 Filter),
                                                                                                                          Posting Date=FIELD(Date Filter),
                                                                                                                          Source Type=FIELD(Source Type Filter),
                                                                                                                          Source No.=FIELD(Source No. Filter)));
                                                   CaptionML=[DAN=Analyse - budget. salgsbel›b;
                                                              ENU=Analysis - Budgeted Sales Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 93  ;   ;Analysis - Budgeted Cost Amt.;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Item Analysis View Budg. Entry"."Cost Amount" WHERE (Analysis Area=FIELD(Analysis Area Filter),
                                                                                                                         Analysis View Code=FIELD(Analysis View Filter),
                                                                                                                         Budget Name=FIELD(Budget Filter),
                                                                                                                         Item No.=FIELD(Item Filter),
                                                                                                                         Location Code=FIELD(Location Filter),
                                                                                                                         Dimension 1 Value Code=FIELD(Dimension 1 Filter),
                                                                                                                         Dimension 2 Value Code=FIELD(Dimension 2 Filter),
                                                                                                                         Dimension 3 Value Code=FIELD(Dimension 3 Filter),
                                                                                                                         Posting Date=FIELD(Date Filter),
                                                                                                                         Source Type=FIELD(Source Type Filter),
                                                                                                                         Source No.=FIELD(Source No. Filter)));
                                                   CaptionML=[DAN=Analyse - budget. kostbel›b;
                                                              ENU=Analysis - Budgeted Cost Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1 }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

