OBJECT Table 169 Job Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               Job.UpdateOverBudgetValue("Job No.",TRUE,"Total Cost (LCY)");
             END;

    OnModify=BEGIN
               Job.UpdateOverBudgetValue("Job No.",TRUE,"Total Cost (LCY)");
             END;

    OnDelete=BEGIN
               Job.UpdateOverBudgetValue("Job No.",TRUE,"Total Cost (LCY)");
             END;

    CaptionML=[DAN=Sagspost;
               ENU=Job Ledger Entry];
    LookupPageID=Page92;
    DrillDownPageID=Page92;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenummer;
                                                              ENU=Entry No.] }
    { 2   ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 3   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogfõringsdato;
                                                              ENU=Posting Date] }
    { 4   ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 5   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Ressource,Vare,Finanskonto;
                                                                    ENU=Resource,Item,G/L Account];
                                                   OptionString=Resource,Item,G/L Account }
    { 7   ;   ;No.                 ;Code20        ;TableRelation=IF (Type=CONST(Resource)) Resource
                                                                 ELSE IF (Type=CONST(Item)) Item
                                                                 ELSE IF (Type=CONST(G/L Account)) "G/L Account";
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 8   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 9   ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 11  ;   ;Direct Unit Cost (LCY);Decimal     ;CaptionML=[DAN=Kõbspris (RV);
                                                              ENU=Direct Unit Cost (LCY)];
                                                   AutoFormatType=2 }
    { 12  ;   ;Unit Cost (LCY)     ;Decimal       ;CaptionML=[DAN=Kostpris (RV);
                                                              ENU=Unit Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 13  ;   ;Total Cost (LCY)    ;Decimal       ;CaptionML=[DAN=Kostbelõb (RV);
                                                              ENU=Total Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 14  ;   ;Unit Price (LCY)    ;Decimal       ;CaptionML=[DAN=Enhedspris (RV);
                                                              ENU=Unit Price (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 15  ;   ;Total Price (LCY)   ;Decimal       ;CaptionML=[DAN=Salgsbelõb (RV);
                                                              ENU=Total Price (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 16  ;   ;Resource Group No.  ;Code20        ;TableRelation="Resource Group";
                                                   CaptionML=[DAN=Ressourcegruppenr.;
                                                              ENU=Resource Group No.];
                                                   Editable=No }
    { 17  ;   ;Unit of Measure Code;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                                                                 ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.));
                                                   CaptionML=[DAN=Enhedskode;
                                                              ENU=Unit of Measure Code] }
    { 20  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 29  ;   ;Job Posting Group   ;Code20        ;TableRelation="Inventory Posting Group";
                                                   CaptionML=[DAN=Sagsbogfõringsgruppe;
                                                              ENU=Job Posting Group] }
    { 30  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 31  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 32  ;   ;Work Type Code      ;Code10        ;TableRelation="Work Type";
                                                   CaptionML=[DAN=Arbejdstypekode;
                                                              ENU=Work Type Code] }
    { 33  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   CaptionML=[DAN=Debitorprisgruppe;
                                                              ENU=Customer Price Group] }
    { 37  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 38  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 60  ;   ;Amt. to Post to G/L ;Decimal       ;CaptionML=[DAN=Igangv. arb. belõb;
                                                              ENU=Amt. to Post to G/L];
                                                   AutoFormatType=1 }
    { 61  ;   ;Amt. Posted to G/L  ;Decimal       ;CaptionML=[DAN=Bogf. igv.arb.belõb;
                                                              ENU=Amt. Posted to G/L];
                                                   AutoFormatType=1 }
    { 64  ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Postens type;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Forbrug,Salg;
                                                                    ENU=Usage,Sale];
                                                   OptionString=Usage,Sale }
    { 75  ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 76  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=èrsagskode;
                                                              ENU=Reason Code] }
    { 77  ;   ;Transaction Type    ;Code10        ;TableRelation="Transaction Type";
                                                   CaptionML=[DAN=Transaktionsart;
                                                              ENU=Transaction Type] }
    { 78  ;   ;Transport Method    ;Code10        ;TableRelation="Transport Method";
                                                   CaptionML=[DAN=TransportmÜde;
                                                              ENU=Transport Method] }
    { 79  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode;
                                                              ENU=Country/Region Code] }
    { 80  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogfõringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 81  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogfõringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 82  ;   ;Entry/Exit Point    ;Code10        ;TableRelation="Entry/Exit Point";
                                                   CaptionML=[DAN=Indfõrsels-/udfõrselssted;
                                                              ENU=Entry/Exit Point] }
    { 83  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 84  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 85  ;   ;Area                ;Code10        ;TableRelation=Area;
                                                   CaptionML=[DAN=OmrÜde;
                                                              ENU=Area] }
    { 86  ;   ;Transaction Specification;Code10   ;TableRelation="Transaction Specification";
                                                   CaptionML=[DAN=Transaktionsspecifikation;
                                                              ENU=Transaction Specification] }
    { 87  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 88  ;   ;Additional-Currency Total Cost;Decimal;
                                                   CaptionML=[DAN=Ekstra valuta (kostbelõb);
                                                              ENU=Additional-Currency Total Cost];
                                                   AutoFormatType=1 }
    { 89  ;   ;Add.-Currency Total Price;Decimal  ;CaptionML=[DAN=Ekstra valuta (salgsbelõb);
                                                              ENU=Add.-Currency Total Price];
                                                   AutoFormatType=1 }
    { 94  ;   ;Add.-Currency Line Amount;Decimal  ;CaptionML=[DAN=Linjebelõb i ekstra valuta;
                                                              ENU=Add.-Currency Line Amount];
                                                   AutoFormatType=1 }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 1000;   ;Job Task No.        ;Code20        ;TableRelation="Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
                                                   CaptionML=[DAN=Sagsopgavenr.;
                                                              ENU=Job Task No.] }
    { 1001;   ;Line Amount (LCY)   ;Decimal       ;CaptionML=[DAN=Linjebelõb (RV);
                                                              ENU=Line Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1002;   ;Unit Cost           ;Decimal       ;CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 1003;   ;Total Cost          ;Decimal       ;CaptionML=[DAN=Kostbelõb;
                                                              ENU=Total Cost];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1004;   ;Unit Price          ;Decimal       ;CaptionML=[DAN=Enhedspris;
                                                              ENU=Unit Price];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 1005;   ;Total Price         ;Decimal       ;CaptionML=[DAN=Salgsbelõb;
                                                              ENU=Total Price];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1006;   ;Line Amount         ;Decimal       ;CaptionML=[DAN=Linjebelõb;
                                                              ENU=Line Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1007;   ;Line Discount Amount;Decimal       ;CaptionML=[DAN=Linjerabatbelõb;
                                                              ENU=Line Discount Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1008;   ;Line Discount Amount (LCY);Decimal ;CaptionML=[DAN=Linjerabatbelõb (RV);
                                                              ENU=Line Discount Amount (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1009;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 1010;   ;Currency Factor     ;Decimal       ;CaptionML=[DAN=Valutafaktor;
                                                              ENU=Currency Factor] }
    { 1016;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 1017;   ;Ledger Entry Type   ;Option        ;CaptionML=[DAN=Posteringstype;
                                                              ENU=Ledger Entry Type];
                                                   OptionCaptionML=[DAN=" ,Ressource,Vare,Finanskonto";
                                                                    ENU=" ,Resource,Item,G/L Account"];
                                                   OptionString=[ ,Resource,Item,G/L Account] }
    { 1018;   ;Ledger Entry No.    ;Integer       ;TableRelation=IF (Ledger Entry Type=CONST(Resource)) "Res. Ledger Entry"
                                                                 ELSE IF (Ledger Entry Type=CONST(Item)) "Item Ledger Entry"
                                                                 ELSE IF (Ledger Entry Type=CONST(G/L Account)) "G/L Entry";
                                                   CaptionML=[DAN=Posteringslõbenr;
                                                              ENU=Ledger Entry No.];
                                                   BlankZero=Yes }
    { 1019;   ;Serial No.          ;Code20        ;CaptionML=[DAN=Serienr.;
                                                              ENU=Serial No.] }
    { 1020;   ;Lot No.             ;Code20        ;CaptionML=[DAN=Lotnr.;
                                                              ENU=Lot No.] }
    { 1021;   ;Line Discount %     ;Decimal       ;CaptionML=[DAN=Linjerabatpct.;
                                                              ENU=Line Discount %];
                                                   DecimalPlaces=0:5 }
    { 1022;   ;Line Type           ;Option        ;CaptionML=[DAN=Linjetype;
                                                              ENU=Line Type];
                                                   OptionCaptionML=[DAN=" ,Budget,Fakturerbar,BÜde budget og fakturerbar";
                                                                    ENU=" ,Budget,Billable,Both Budget and Billable"];
                                                   OptionString=[ ,Budget,Billable,Both Budget and Billable] }
    { 1023;   ;Original Unit Cost (LCY);Decimal   ;CaptionML=[DAN=Oprindelig kostpris (RV);
                                                              ENU=Original Unit Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=2 }
    { 1024;   ;Original Total Cost (LCY);Decimal  ;CaptionML=[DAN=Oprindeligt kostbelõb (RV);
                                                              ENU=Original Total Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 1025;   ;Original Unit Cost  ;Decimal       ;CaptionML=[DAN=Oprindelig kostpris;
                                                              ENU=Original Unit Cost];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 1026;   ;Original Total Cost ;Decimal       ;CaptionML=[DAN=Oprindeligt kostbelõb;
                                                              ENU=Original Total Cost];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1027;   ;Original Total Cost (ACY);Decimal  ;CaptionML=[DAN=Oprindeligt kostbelõb (EV);
                                                              ENU=Original Total Cost (ACY)];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 1028;   ;Adjusted            ;Boolean       ;CaptionML=[DAN=Reguleret;
                                                              ENU=Adjusted] }
    { 1029;   ;DateTime Adjusted   ;DateTime      ;CaptionML=[DAN=Dato/klokkeslët reguleret;
                                                              ENU=DateTime Adjusted] }
    { 5402;   ;Variant Code        ;Code10        ;TableRelation=IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
                                                   CaptionML=[DAN=Variantkode;
                                                              ENU=Variant Code] }
    { 5403;   ;Bin Code            ;Code20        ;TableRelation=Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 5404;   ;Qty. per Unit of Measure;Decimal   ;CaptionML=[DAN=Antal pr. enhed;
                                                              ENU=Qty. per Unit of Measure];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 5405;   ;Quantity (Base)     ;Decimal       ;CaptionML=[DAN=Antal (basis);
                                                              ENU=Quantity (Base)] }
    { 5900;   ;Service Order No.   ;Code20        ;CaptionML=[DAN=Serviceordrenr.;
                                                              ENU=Service Order No.] }
    { 5901;   ;Posted Service Shipment No.;Code20 ;CaptionML=[DAN=Bogfõrt serviceleverancenr.;
                                                              ENU=Posted Service Shipment No.] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Job No.,Job Task No.,Entry Type,Posting Date;
                                                   SumIndexFields=Total Cost (LCY),Line Amount (LCY),Total Cost,Line Amount }
    {    ;Document No.,Posting Date                }
    {    ;Job No.,Posting Date                     }
    {    ;Entry Type,Type,No.,Posting Date         }
    {    ;Service Order No.,Posting Date           }
    {    ;Job No.,Entry Type,Type,No.              }
    {    ;Type,Entry Type,Country/Region Code,Source Code,Posting Date }
    {    ;Job No.,Entry Type,Type,Posting Date    ;SumIndexFields=Total Cost (LCY),Line Amount (LCY),Total Cost,Line Amount;
                                                   MaintainSQLIndex=No }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Job No.,Posting Date,Document No. }
  }
  CODE
  {
    VAR
      Job@1001 : Record 167;
      DimMgt@1000 : Codeunit 408;

    [External]
    PROCEDURE ShowDimensions@1();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    BEGIN
    END.
  }
}

