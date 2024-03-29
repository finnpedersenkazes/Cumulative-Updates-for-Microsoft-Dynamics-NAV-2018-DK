OBJECT Table 5405 Production Order
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Description;
    OnInsert=VAR
               InvtAdjmtEntryOrder@1000 : Record 5896;
             BEGIN
               MfgSetup.GET;
               IF "No." = '' THEN BEGIN
                 TestNoSeries;
                 NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Due Date","No.","No. Series");
               END;

               IF Status = Status::Released THEN BEGIN
                 IF ProdOrder.GET(Status::Finished,"No.") THEN
                   ERROR(Text007,Status,TABLECAPTION,ProdOrder."No.",ProdOrder.Status);
                 InvtAdjmtEntryOrder.SETRANGE("Order Type",InvtAdjmtEntryOrder."Order Type"::Production);
                 InvtAdjmtEntryOrder.SETRANGE("Order No.","No.");
                 IF NOT InvtAdjmtEntryOrder.ISEMPTY THEN
                   ERROR(Text007,Status,TABLECAPTION,ProdOrder."No.",InvtAdjmtEntryOrder.TABLECAPTION);
               END;

               InitRecord;

               "Starting Time" := MfgSetup."Normal Starting Time";
               "Ending Time" := MfgSetup."Normal Ending Time";
               "Creation Date" := TODAY;
               UpdateDatetime;
             END;

    OnModify=BEGIN
               "Last Date Modified" := TODAY;
               IF Status = Status::Finished THEN
                 ERROR(Text006);
             END;

    OnDelete=VAR
               ItemLedgEntry@1000 : Record 32;
               CapLedgEntry@1001 : Record 5832;
               PurchLine@1002 : Record 39;
             BEGIN
               IF Status = Status::Released THEN BEGIN
                 ItemLedgEntry.SETRANGE("Order Type",ItemLedgEntry."Order Type"::Production);
                 ItemLedgEntry.SETRANGE("Order No.","No.");
                 IF NOT ItemLedgEntry.ISEMPTY THEN
                   ERROR(
                     Text000,
                     Status,TABLECAPTION,"No.",ItemLedgEntry.TABLECAPTION);

                 CapLedgEntry.SETRANGE("Order Type",CapLedgEntry."Order Type"::Production);
                 CapLedgEntry.SETRANGE("Order No.","No.");
                 IF NOT CapLedgEntry.ISEMPTY THEN
                   ERROR(
                     Text000,
                     Status,TABLECAPTION,"No.",CapLedgEntry.TABLECAPTION);
               END;

               IF Status IN [Status::Released,Status::Finished] THEN BEGIN
                 PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
                 PurchLine.SETRANGE(Type,PurchLine.Type::Item);
                 PurchLine.SETRANGE("Prod. Order No.","No.");
                 IF NOT PurchLine.ISEMPTY THEN
                   ERROR(
                     Text000,
                     Status,TABLECAPTION,"No.",PurchLine.TABLECAPTION);
               END;

               IF Status = Status::Finished THEN
                 DeleteFnshdProdOrderRelations
               ELSE
                 DeleteRelations;
             END;

    OnRename=BEGIN
               ERROR(Text001,TABLECAPTION);
             END;

    CaptionML=[DAN=Produktionsordre;
               ENU=Production Order];
    LookupPageID=Page99000815;
    DrillDownPageID=Page99000815;
  }
  FIELDS
  {
    { 1   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Simuleret,Planlagt,Fastlagt,Frigivet,Udf�rt;
                                                                    ENU=Simulated,Planned,Firm Planned,Released,Finished];
                                                   OptionString=Simulated,Planned,Firm Planned,Released,Finished }
    { 2   ;   ;No.                 ;Code20        ;TableRelation="Production Order".No. WHERE (Status=FIELD(Status));
                                                   OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  MfgSetup.GET;
                                                                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   ValidateTableRelation=No;
                                                   AltSearchField=Search Description;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 3   ;   ;Description         ;Text50        ;OnValidate=BEGIN
                                                                "Search Description" := Description;
                                                              END;

                                                   CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Search Description  ;Code50        ;CaptionML=[DAN=S�gebeskrivelse;
                                                              ENU=Search Description] }
    { 5   ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 6   ;   ;Creation Date       ;Date          ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date];
                                                   Editable=No }
    { 7   ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 9   ;   ;Source Type         ;Option        ;OnValidate=BEGIN
                                                                IF "Source Type" <> xRec."Source Type" THEN
                                                                  CheckProdOrderStatus(FIELDCAPTION("Source Type"));
                                                              END;

                                                   CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=Vare,Familie,Salgshoved;
                                                                    ENU=Item,Family,Sales Header];
                                                   OptionString=Item,Family,Sales Header }
    { 10  ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Item)) Item WHERE (Type=CONST(Inventory))
                                                                 ELSE IF (Source Type=CONST(Family)) Family
                                                                 ELSE IF (Status=CONST(Simulated),
                                                                          Source Type=CONST(Sales Header)) "Sales Header".No. WHERE (Document Type=CONST(Quote))
                                                                          ELSE IF (Status=FILTER(Planned..),
                                                                                   Source Type=CONST(Sales Header)) "Sales Header".No. WHERE (Document Type=CONST(Order));
                                                   OnValidate=VAR
                                                                Item@1000 : Record 27;
                                                                Family@1001 : Record 99000773;
                                                                SalesHeader@1002 : Record 36;
                                                              BEGIN
                                                                IF "Source No." <> xRec."Source No." THEN
                                                                  CheckProdOrderStatus(FIELDCAPTION("Source No."));

                                                                IF "Source No." = '' THEN
                                                                  EXIT;

                                                                CASE "Source Type" OF
                                                                  "Source Type"::Item:
                                                                    BEGIN
                                                                      Item.GET("Source No.");
                                                                      Item.TESTFIELD(Blocked,FALSE);
                                                                      Description := Item.Description;
                                                                      "Description 2" := Item."Description 2";
                                                                      "Routing No." := Item."Routing No.";
                                                                      "Inventory Posting Group" := Item."Inventory Posting Group";
                                                                      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                                                                      "Unit Cost" := Item."Unit Cost";
                                                                      CreateDim(DATABASE::Item,"Source No.");
                                                                    END;
                                                                  "Source Type"::Family:
                                                                    BEGIN
                                                                      Family.GET("Source No.");
                                                                      Description := Family.Description;
                                                                      "Description 2" := Family."Description 2";
                                                                      "Routing No." := Family."Routing No.";
                                                                      "Inventory Posting Group" := '';
                                                                      "Gen. Prod. Posting Group" := '';
                                                                      "Unit Cost" := 0;
                                                                    END;
                                                                  "Source Type"::"Sales Header":
                                                                    BEGIN
                                                                      IF Status = Status::Simulated THEN
                                                                        SalesHeader.GET(SalesHeader."Document Type"::Quote,"Source No.")
                                                                      ELSE
                                                                        SalesHeader.GET(SalesHeader."Document Type"::Order,"Source No.");
                                                                      Description := SalesHeader."Ship-to Name";
                                                                      "Description 2" := SalesHeader."Ship-to Name 2";
                                                                      "Routing No." := '';
                                                                      "Inventory Posting Group" := '';
                                                                      "Gen. Prod. Posting Group" := '';
                                                                      "Gen. Bus. Posting Group" := SalesHeader."Gen. Bus. Posting Group";
                                                                      "Unit Cost" := 0;
                                                                      "Location Code" := SalesHeader."Location Code";
                                                                      "Due Date" := SalesHeader."Shipment Date";
                                                                      "Ending Date" := SalesHeader."Shipment Date";
                                                                      "Dimension Set ID" := SalesHeader."Dimension Set ID";
                                                                      "Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
                                                                      "Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
                                                                    END;
                                                                END;
                                                                VALIDATE(Description);
                                                                InitRecord;
                                                                UpdateDatetime;
                                                              END;

                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 11  ;   ;Routing No.         ;Code20        ;TableRelation="Routing Header";
                                                   CaptionML=[DAN=Rutenr.;
                                                              ENU=Routing No.] }
    { 15  ;   ;Inventory Posting Group;Code20     ;TableRelation="Inventory Posting Group";
                                                   CaptionML=[DAN=Varebogf�ringsgruppe;
                                                              ENU=Inventory Posting Group] }
    { 16  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 17  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 19  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Prod. Order Comment Line" WHERE (Status=FIELD(Status),
                                                                                                       Prod. Order No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 20  ;   ;Starting Time       ;Time          ;OnValidate=BEGIN
                                                                ProdOrderLine.SETCURRENTKEY(Status,"Prod. Order No.","Planning Level Code");
                                                                ProdOrderLine.ASCENDING(FALSE);
                                                                ProdOrderLine.SETRANGE(Status,Status);
                                                                ProdOrderLine.SETRANGE("Prod. Order No.","No.");
                                                                ProdOrderLine.SETFILTER("Item No.",'<>%1','');
                                                                ProdOrderLine.SETFILTER("Planning Level Code",'>%1',0);
                                                                IF ProdOrderLine.FIND('-') THEN BEGIN
                                                                  "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
                                                                  MODIFY;
                                                                  MultiLevelMessage;
                                                                  EXIT;
                                                                END;
                                                                "Due Date" := 0D;
                                                                ProdOrderLine.SETRANGE("Planning Level Code");
                                                                IF ProdOrderLine.FIND('-') THEN
                                                                  REPEAT
                                                                    ProdOrderLine."Starting Time" := "Starting Time";
                                                                    ProdOrderLine."Starting Date" := "Starting Date";
                                                                    ProdOrderLine.MODIFY;
                                                                    CalcProdOrder.SetParameter(TRUE);
                                                                    CalcProdOrder.Recalculate(ProdOrderLine,0,TRUE);
                                                                    IF ProdOrderLine."Planning Level Code" > 0 THEN
                                                                      ProdOrderLine."Due Date" := ProdOrderLine."Ending Date"
                                                                    ELSE
                                                                      ProdOrderLine."Due Date" :=
                                                                        LeadTimeMgt.PlannedDueDate(
                                                                          ProdOrderLine."Item No.",
                                                                          ProdOrderLine."Location Code",
                                                                          ProdOrderLine."Variant Code",
                                                                          ProdOrderLine."Ending Date",
                                                                          '',
                                                                          2);

                                                                    IF "Due Date" = 0D THEN
                                                                      "Due Date" := ProdOrderLine."Due Date";
                                                                    "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
                                                                    ProdOrderLine.MODIFY(TRUE);
                                                                    ProdOrderLine.CheckEndingDate(CurrFieldNo <> 0);
                                                                  UNTIL ProdOrderLine.NEXT = 0
                                                                ELSE BEGIN
                                                                  "Ending Date" := "Starting Date";
                                                                  "Ending Time" := "Starting Time";
                                                                END;
                                                                AdjustStartEndingDate;
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Starttidspunkt;
                                                              ENU=Starting Time] }
    { 21  ;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Starting Time");
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 22  ;   ;Ending Time         ;Time          ;OnValidate=BEGIN
                                                                ProdOrderLine.SETCURRENTKEY(Status,"Prod. Order No.","Planning Level Code");
                                                                ProdOrderLine.ASCENDING(TRUE);
                                                                ProdOrderLine.SETRANGE(Status,Status);
                                                                ProdOrderLine.SETRANGE("Prod. Order No.","No.");
                                                                ProdOrderLine.SETFILTER("Item No.",'<>%1','');
                                                                ProdOrderLine.SETFILTER("Planning Level Code",'>%1',0);
                                                                IF ProdOrderLine.FIND('-') THEN BEGIN
                                                                  "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
                                                                  MODIFY;
                                                                  MultiLevelMessage;
                                                                  EXIT;
                                                                END;
                                                                "Due Date" := 0D;
                                                                ProdOrderLine.SETRANGE("Planning Level Code");
                                                                IF ProdOrderLine.FIND('-') THEN
                                                                  REPEAT
                                                                    ProdOrderLine."Ending Time" := "Ending Time";
                                                                    ProdOrderLine."Ending Date" := "Ending Date";
                                                                    ProdOrderLine.MODIFY;
                                                                    CalcProdOrder.SetParameter(TRUE);
                                                                    CalcProdOrder.Recalculate(ProdOrderLine,1,TRUE);
                                                                    IF ProdOrderLine."Planning Level Code" > 0 THEN
                                                                      ProdOrderLine."Due Date" := ProdOrderLine."Ending Date"
                                                                    ELSE
                                                                      ProdOrderLine."Due Date" :=
                                                                        LeadTimeMgt.PlannedDueDate(
                                                                          ProdOrderLine."Item No.",
                                                                          ProdOrderLine."Location Code",
                                                                          ProdOrderLine."Variant Code",
                                                                          ProdOrderLine."Ending Date",
                                                                          '',
                                                                          2);
                                                                    IF "Due Date" = 0D THEN
                                                                      "Due Date" := ProdOrderLine."Due Date";
                                                                    "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
                                                                    ProdOrderLine.MODIFY(TRUE);
                                                                    ProdOrderLine.CheckEndingDate(CurrFieldNo <> 0);
                                                                  UNTIL ProdOrderLine.NEXT = 0
                                                                ELSE BEGIN
                                                                  "Starting Date" := "Ending Date";
                                                                  "Starting Time" := "Ending Time";
                                                                END;
                                                                AdjustStartEndingDate;
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Sluttidspunkt;
                                                              ENU=Ending Time] }
    { 23  ;   ;Ending Date         ;Date          ;OnValidate=BEGIN
                                                                VALIDATE("Ending Time");
                                                              END;

                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date] }
    { 24  ;   ;Due Date            ;Date          ;OnValidate=BEGIN
                                                                IF "Due Date" = 0D THEN
                                                                  EXIT;
                                                                IF (CurrFieldNo = FIELDNO("Due Date")) OR
                                                                   (CurrFieldNo = FIELDNO("Location Code")) OR
                                                                   UpdateEndDate
                                                                THEN BEGIN
                                                                  ProdOrderLine.SETCURRENTKEY(Status,"Prod. Order No.","Planning Level Code");
                                                                  ProdOrderLine.ASCENDING(TRUE);
                                                                  ProdOrderLine.SETRANGE(Status,Status);
                                                                  ProdOrderLine.SETRANGE("Prod. Order No.","No.");
                                                                  ProdOrderLine.SETFILTER("Item No.",'<>%1','');
                                                                  ProdOrderLine.SETFILTER("Planning Level Code",'>%1',0);
                                                                  IF NOT ProdOrderLine.ISEMPTY THEN BEGIN
                                                                    ProdOrderLine.SETRANGE("Planning Level Code",0);
                                                                    IF "Source Type" = "Source Type"::Family THEN BEGIN
                                                                      UpdateEndingDate(ProdOrderLine);
                                                                    END ELSE BEGIN
                                                                      IF ProdOrderLine.FIND('-') THEN
                                                                        "Ending Date" :=
                                                                          LeadTimeMgt.PlannedEndingDate(ProdOrderLine."Item No.","Location Code",'',"Due Date",'',2)
                                                                      ELSE
                                                                        "Ending Date" := "Due Date";
                                                                      "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
                                                                      MultiLevelMessage;
                                                                      EXIT;
                                                                    END;
                                                                  END ELSE BEGIN
                                                                    ProdOrderLine.SETRANGE("Planning Level Code");
                                                                    IF NOT ProdOrderLine.ISEMPTY THEN
                                                                      UpdateEndingDate(ProdOrderLine)
                                                                    ELSE BEGIN
                                                                      IF "Source Type" = "Source Type"::Item THEN
                                                                        "Ending Date" :=
                                                                          LeadTimeMgt.PlannedEndingDate(
                                                                            "Source No.",
                                                                            "Location Code",
                                                                            '',
                                                                            "Due Date",
                                                                            '',
                                                                            2)
                                                                      ELSE
                                                                        "Ending Date" := "Due Date";
                                                                      "Starting Date" := "Ending Date";
                                                                      "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
                                                                      "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
                                                                    END;
                                                                    AdjustStartEndingDate;
                                                                    MODIFY;
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 25  ;   ;Finished Date       ;Date          ;CaptionML=[DAN=F�rdig den;
                                                              ENU=Finished Date];
                                                   Editable=No }
    { 28  ;   ;Blocked             ;Boolean       ;CaptionML=[DAN=Sp�rret;
                                                              ENU=Blocked] }
    { 30  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 31  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 32  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=BEGIN
                                                                GetDefaultBin;

                                                                VALIDATE("Due Date"); // Scheduling consider Calendar assigned to Location
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 33  ;   ;Bin Code            ;Code20        ;TableRelation=IF (Source Type=CONST(Item)) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                              Item Filter=FIELD(Source No.))
                                                                                                              ELSE IF (Source Type=FILTER(<>Item)) Bin.Code WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=VAR
                                                                WhseIntegrationMgt@1000 : Codeunit 7317;
                                                              BEGIN
                                                                IF "Bin Code" <> '' THEN
                                                                  WhseIntegrationMgt.CheckBinTypeCode(DATABASE::"Production Order",
                                                                    FIELDCAPTION("Bin Code"),
                                                                    "Location Code",
                                                                    "Bin Code",0);
                                                              END;

                                                   CaptionML=[DAN=Placeringskode;
                                                              ENU=Bin Code] }
    { 34  ;   ;Replan Ref. No.     ;Code20        ;CaptionML=[DAN=Omplan.ref.nr.;
                                                              ENU=Replan Ref. No.];
                                                   Editable=No }
    { 35  ;   ;Replan Ref. Status  ;Option        ;CaptionML=[DAN=Omplan.ref.status;
                                                              ENU=Replan Ref. Status];
                                                   OptionCaptionML=[DAN=Simuleret,Planlagt,Fastlagt,Frigivet,Udf�rt;
                                                                    ENU=Simulated,Planned,Firm Planned,Released,Finished];
                                                   OptionString=Simulated,Planned,Firm Planned,Released,Finished;
                                                   Editable=No }
    { 38  ;   ;Low-Level Code      ;Integer       ;CaptionML=[DAN=Laveste-niveau-kode;
                                                              ENU=Low-Level Code];
                                                   Editable=No }
    { 40  ;   ;Quantity            ;Decimal       ;OnValidate=BEGIN
                                                                IF "Source Type" = "Source Type"::Item THEN
                                                                  "Cost Amount" := ROUND(Quantity * "Unit Cost")
                                                                ELSE
                                                                  "Cost Amount" := 0;
                                                              END;

                                                   CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0 }
    { 41  ;   ;Unit Cost           ;Decimal       ;CaptionML=[DAN=Kostpris;
                                                              ENU=Unit Cost];
                                                   DecimalPlaces=2:5 }
    { 42  ;   ;Cost Amount         ;Decimal       ;CaptionML=[DAN=Kostbel�b;
                                                              ENU=Cost Amount];
                                                   DecimalPlaces=2:2 }
    { 47  ;   ;Work Center Filter  ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation="Work Center";
                                                   CaptionML=[DAN=Arbejdscenterfilter;
                                                              ENU=Work Center Filter] }
    { 48  ;   ;Capacity Type Filter;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Kapacitetstypefilter;
                                                              ENU=Capacity Type Filter];
                                                   OptionCaptionML=[DAN=Arbejdscenter,Produktionsressource;
                                                                    ENU=Work Center,Machine Center];
                                                   OptionString=Work Center,Machine Center }
    { 49  ;   ;Capacity No. Filter ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=IF (Capacity Type Filter=CONST(Work Center)) "Machine Center"
                                                                 ELSE IF (Capacity Type Filter=CONST(Machine Center)) "Work Center";
                                                   CaptionML=[DAN=Kapacitetsnr.filter;
                                                              ENU=Capacity No. Filter] }
    { 50  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 51  ;   ;Expected Operation Cost Amt.;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Routing Line"."Expected Operation Cost Amt." WHERE (Status=FIELD(Status),
                                                                                                                                    Prod. Order No.=FIELD(No.)));
                                                   CaptionML=[DAN=Forventede operationsomkostninger;
                                                              ENU=Expected Operation Cost Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 52  ;   ;Expected Component Cost Amt.;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Component"."Cost Amount" WHERE (Status=FIELD(Status),
                                                                                                                Prod. Order No.=FIELD(No.),
                                                                                                                Due Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Forventet komponentomkostning;
                                                              ENU=Expected Component Cost Amt.];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 55  ;   ;Actual Time Used    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Capacity Ledger Entry".Quantity WHERE (Order Type=CONST(Production),
                                                                                                           Order No.=FIELD(No.),
                                                                                                           Type=FIELD(Capacity Type Filter),
                                                                                                           No.=FIELD(Capacity No. Filter),
                                                                                                           Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Faktisk tidsforbrug;
                                                              ENU=Actual Time Used];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 56  ;   ;Allocated Capacity Need;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Capacity Need"."Needed Time" WHERE (Status=FIELD(Status),
                                                                                                                    Prod. Order No.=FIELD(No.),
                                                                                                                    Type=FIELD(Capacity Type Filter),
                                                                                                                    No.=FIELD(Capacity No. Filter),
                                                                                                                    Work Center No.=FIELD(Work Center Filter),
                                                                                                                    Date=FIELD(Date Filter),
                                                                                                                    Requested Only=CONST(No)));
                                                   CaptionML=[DAN=Allokeret kapacitetsbehov;
                                                              ENU=Allocated Capacity Need];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 57  ;   ;Expected Capacity Need;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Capacity Need"."Needed Time" WHERE (Status=FIELD(Status),
                                                                                                                    Prod. Order No.=FIELD(No.),
                                                                                                                    Type=FIELD(Capacity Type Filter),
                                                                                                                    No.=FIELD(Capacity No. Filter),
                                                                                                                    Work Center No.=FIELD(Work Center Filter),
                                                                                                                    Date=FIELD(Date Filter),
                                                                                                                    Requested Only=CONST(No)));
                                                   CaptionML=[DAN=Forventet kapacitetsbehov;
                                                              ENU=Expected Capacity Need];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 80  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 82  ;   ;Planned Order No.   ;Code20        ;CaptionML=[DAN=Planlagt ordrenr.;
                                                              ENU=Planned Order No.] }
    { 83  ;   ;Firm Planned Order No.;Code20      ;CaptionML=[DAN=Fastlagt ordrenr.;
                                                              ENU=Firm Planned Order No.] }
    { 85  ;   ;Simulated Order No. ;Code20        ;CaptionML=[DAN=Simuleret ordrenr.;
                                                              ENU=Simulated Order No.] }
    { 92  ;   ;Expected Material Ovhd. Cost;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Component"."Overhead Amount" WHERE (Status=FIELD(Status),
                                                                                                                    Prod. Order No.=FIELD(No.)));
                                                   CaptionML=[DAN=Forventet indir. mat.kostpris;
                                                              ENU=Expected Material Ovhd. Cost];
                                                   DecimalPlaces=2:2;
                                                   Editable=No }
    { 94  ;   ;Expected Capacity Ovhd. Cost;Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Prod. Order Routing Line"."Expected Capacity Ovhd. Cost" WHERE (Status=FIELD(Status),
                                                                                                                                    Prod. Order No.=FIELD(No.)));
                                                   CaptionML=[DAN=Forventet indir. kap.kostpris;
                                                              ENU=Expected Capacity Ovhd. Cost];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 98  ;   ;Starting Date-Time  ;DateTime      ;OnValidate=BEGIN
                                                                "Starting Date" := DT2DATE("Starting Date-Time");
                                                                "Starting Time" := DT2TIME("Starting Date-Time");
                                                                VALIDATE("Starting Time");
                                                              END;

                                                   CaptionML=[DAN=Startdato/-tidspunkt;
                                                              ENU=Starting Date-Time] }
    { 99  ;   ;Ending Date-Time    ;DateTime      ;OnValidate=BEGIN
                                                                "Ending Date" := DT2DATE("Ending Date-Time");
                                                                "Ending Time" := DT2TIME("Ending Date-Time");
                                                                VALIDATE("Ending Time");
                                                              END;

                                                   CaptionML=[DAN=Slutdato/-tidspunkt;
                                                              ENU=Ending Date-Time] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=BEGIN
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ShowDocDim;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 7300;   ;Completely Picked   ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Min("Prod. Order Component"."Completely Picked" WHERE (Status=FIELD(Status),
                                                                                                                      Prod. Order No.=FIELD(No.),
                                                                                                                      Supplied-by Line No.=FILTER(0)));
                                                   CaptionML=[DAN=Fuldt plukket;
                                                              ENU=Completely Picked] }
    { 9000;   ;Assigned User ID    ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
  }
  KEYS
  {
    {    ;Status,No.                              ;Clustered=Yes }
    {    ;No.,Status                               }
    {    ;Search Description                       }
    {    ;Low-Level Code,Replan Ref. No.,Replan Ref. Status }
    { No ;Source Type,Source No.                   }
    {    ;Description                              }
    {    ;Source No.                               }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Description,Source No.,Source Type   }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst '@@@="%1 = Document status; %2 = Table caption; %3 = Field value; %4 = Table Caption";DAN=Du kan ikke slette %1 %2 %3, fordi der er tilknyttet mindst �n %4.;ENU=You cannot delete %1 %2 %3 because there is at least one %4 associated with it.';
      Text001@1001 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Text002@1002 : TextConst '@@@="%1 = Field caption; %2 = Document status; %3 = Table caption; %4 = Field value; %5 = Table Caption";DAN=Du kan ikke �ndre %1 p� %2 %3 %4 fordi der er tilknyttet mindst �n %5.;ENU=You cannot change %1 on %2 %3 %4 because there is at least one %5 associated with it.';
      Text003@1003 : TextConst 'DAN=Produktionsordren indeholder linjer, der er forbundet i en struktur med flere niveauer, og produktionslinjerne er ikke blevet omplanlagt automatisk.\;ENU=The production order contains lines connected in a multi-level structure and the production order lines have not been automatically rescheduled.\';
      Text005@1005 : TextConst 'DAN=Brug Opdater, hvis du vil omplanl�gge linjerne.;ENU=Use Refresh if you want to reschedule the lines.';
      MfgSetup@1006 : Record 99000765;
      ProdOrder@1007 : Record 5405;
      ProdOrderLine@1008 : Record 5406;
      Location@1004 : Record 14;
      NoSeriesMgt@1010 : Codeunit 396;
      CalcProdOrder@1011 : Codeunit 99000773;
      LeadTimeMgt@1013 : Codeunit 5404;
      DimMgt@1014 : Codeunit 408;
      Text006@1016 : TextConst 'DAN=Du kan ikke �ndre en f�rdig produktionsordre.;ENU=A Finished Production Order cannot be modified.';
      Text007@1017 : TextConst 'DAN=%1 %2 %3 kan ikke oprettes, fordi %4 %2 %3 allerede findes.;ENU=%1 %2 %3 cannot be created, because a %4 %2 %3 already exists.';
      ItemTrackingMgt@1020 : Codeunit 6500;
      CalendarMgt@1025 : Codeunit 99000755;
      HideValidationDialog@1018 : Boolean;
      Text008@1019 : TextConst 'DAN=Der er intet at h�ndtere.;ENU=Nothing to handle.';
      UpdateEndDate@1012 : Boolean;
      Text010@1023 : TextConst 'DAN=Du har muligvis �ndret en dimension.\\Vil du opdatere linjerne?;ENU=You may have changed a dimension.\\Do you want to update the lines?';
      Text011@1024 : TextConst 'DAN=Du kan ikke �ndre dimensionen F�rdig produktionsordre.;ENU=You cannot change Finished Production Order dimensions.';

    [External]
    PROCEDURE InitRecord@10();
    BEGIN
      IF "Due Date" = 0D THEN
        VALIDATE("Due Date",WORKDATE);
      IF ("Source Type" = "Source Type"::Item) AND ("Source No." <> '') THEN
        "Ending Date" :=
          LeadTimeMgt.PlannedEndingDate(
            "Source No.",
            "Location Code",
            '',
            "Due Date",
            '',
            2)
      ELSE
        "Ending Date" := "Due Date";
      "Starting Date" := "Ending Date";
      "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
      "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
    END;

    [External]
    PROCEDURE TestNoSeries@5();
    BEGIN
      MfgSetup.GET;

      CASE Status OF
        Status::Simulated:
          MfgSetup.TESTFIELD("Simulated Order Nos.");
        Status::Planned:
          MfgSetup.TESTFIELD("Planned Order Nos.");
        Status::"Firm Planned":
          MfgSetup.TESTFIELD("Firm Planned Order Nos.");
        Status::Released:
          MfgSetup.TESTFIELD("Released Order Nos.");
      END;
    END;

    [External]
    PROCEDURE AssistEdit@7(OldProdOrder@1000 : Record 5405) : Boolean;
    BEGIN
      WITH ProdOrder DO BEGIN
        ProdOrder := Rec;
        MfgSetup.GET;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldProdOrder."No. Series","No. Series") THEN BEGIN
          NoSeriesMgt.SetSeries("No.");
          Rec := ProdOrder;
          EXIT(TRUE);
        END;
      END;
    END;

    [External]
    PROCEDURE GetNoSeriesCode@6() : Code[20];
    BEGIN
      MfgSetup.GET;

      CASE Status OF
        Status::Simulated:
          EXIT(MfgSetup."Simulated Order Nos.");
        Status::Planned:
          EXIT(MfgSetup."Planned Order Nos.");
        Status::"Firm Planned":
          EXIT(MfgSetup."Firm Planned Order Nos.");
        Status::Released:
          EXIT(MfgSetup."Released Order Nos.");
      END;
    END;

    LOCAL PROCEDURE CheckProdOrderStatus@3(Name@1000 : Text[80]);
    VAR
      ItemLedgEntry@1001 : Record 32;
      CapLedgEntry@1002 : Record 5832;
    BEGIN
      IF Status <> Status::Released THEN
        EXIT;

      IF Status IN [Status::Released,Status::Finished] THEN BEGIN
        ItemLedgEntry.SETRANGE("Order Type",ItemLedgEntry."Order Type"::Production);
        ItemLedgEntry.SETRANGE("Order No.","No.");
        IF NOT ItemLedgEntry.ISEMPTY THEN
          ERROR(
            Text002,
            Name,Status,TABLECAPTION,"No.",ItemLedgEntry.TABLECAPTION);

        CapLedgEntry.SETRANGE("Order Type",CapLedgEntry."Order Type"::Production);
        CapLedgEntry.SETRANGE("Order No.","No.");
        IF NOT CapLedgEntry.ISEMPTY THEN
          ERROR(
            Text002,
            Name,Status,TABLECAPTION,"No.",CapLedgEntry.TABLECAPTION);
      END;
    END;

    LOCAL PROCEDURE DeleteRelations@2();
    VAR
      ProdOrderComment@1000 : Record 5414;
      WhseRequest@1001 : Record 7325;
      ReservMgt@1002 : Codeunit 99000845;
    BEGIN
      ProdOrderComment.SETRANGE(Status,Status);
      ProdOrderComment.SETRANGE("Prod. Order No.","No.");
      ProdOrderComment.DELETEALL;

      ReservMgt.DeleteDocumentReservation(DATABASE::"Prod. Order Line",Status,"No.",HideValidationDialog);

      ProdOrderLine.LOCKTABLE;
      ProdOrderLine.SETRANGE(Status,Status);
      ProdOrderLine.SETRANGE("Prod. Order No.","No.");
      ProdOrderLine.DELETEALL(TRUE);

      WhseRequest.SETRANGE("Document Type",WhseRequest."Document Type"::Production);
      WhseRequest.SETRANGE("Document Subtype",Status);
      WhseRequest.SETRANGE("Document No.","No.");
      IF NOT WhseRequest.ISEMPTY THEN
        WhseRequest.DELETEALL(TRUE);
      ItemTrackingMgt.DeleteWhseItemTrkgLines(
        DATABASE::"Prod. Order Component",Status,"No.",'',0,0,'',FALSE);
    END;

    LOCAL PROCEDURE DeleteFnshdProdOrderRelations@12();
    VAR
      FnshdProdOrderRtngLine@1001 : Record 5409;
      FnshdProdOrderLine@1003 : Record 5406;
      FnshdProdOrderComp@1004 : Record 5407;
      FnshdProdOrderRtngTool@1005 : Record 5411;
      FnshdProdOrderRtngPers@1006 : Record 5412;
      FnshdProdOrderRtngQltyMeas@1007 : Record 5413;
      FnshdProdOrderComment@1008 : Record 5414;
      FnshdProdOrderRtngCmt@1009 : Record 5415;
      FnshdProdOrderBOMComment@1010 : Record 5416;
    BEGIN
      FnshdProdOrderRtngLine.SETRANGE(Status,Status);
      FnshdProdOrderRtngLine.SETRANGE("Prod. Order No.","No.");
      FnshdProdOrderRtngLine.DELETEALL;

      FnshdProdOrderLine.SETRANGE(Status,Status);
      FnshdProdOrderLine.SETRANGE("Prod. Order No.","No.");
      FnshdProdOrderLine.DELETEALL;

      FnshdProdOrderComp.SETRANGE(Status,Status);
      FnshdProdOrderComp.SETRANGE("Prod. Order No.","No.");
      FnshdProdOrderComp.DELETEALL;

      FnshdProdOrderRtngTool.SETRANGE(Status,Status);
      FnshdProdOrderRtngTool.SETRANGE("Prod. Order No.","No.");
      FnshdProdOrderRtngTool.DELETEALL;

      FnshdProdOrderRtngPers.SETRANGE(Status,Status);
      FnshdProdOrderRtngPers.SETRANGE("Prod. Order No.","No.");
      FnshdProdOrderRtngPers.DELETEALL;

      FnshdProdOrderRtngQltyMeas.SETRANGE(Status,Status);
      FnshdProdOrderRtngQltyMeas.SETRANGE("Prod. Order No.","No.");
      FnshdProdOrderRtngQltyMeas.DELETEALL;

      FnshdProdOrderComment.SETRANGE(Status,Status);
      FnshdProdOrderComment.SETRANGE("Prod. Order No.","No.");
      FnshdProdOrderComment.DELETEALL;

      FnshdProdOrderRtngCmt.SETRANGE(Status,Status);
      FnshdProdOrderRtngCmt.SETRANGE("Prod. Order No.","No.");
      FnshdProdOrderRtngCmt.DELETEALL;

      FnshdProdOrderBOMComment.SETRANGE(Status,Status);
      FnshdProdOrderBOMComment.SETRANGE("Prod. Order No.","No.");
      FnshdProdOrderBOMComment.DELETEALL;
    END;

    LOCAL PROCEDURE AdjustStartEndingDate@1();
    BEGIN
      ProdOrderLine.RESET;
      ProdOrderLine.SETRANGE(Status,Status);
      ProdOrderLine.SETRANGE("Prod. Order No.","No.");

      IF NOT ProdOrderLine.FIND('-') THEN
        EXIT;

      "Starting Date" := CalendarMgt.GetMaxDate;
      "Starting Time" := 235959T;
      "Ending Date" := 0D;
      "Ending Time" := 000000T;

      REPEAT
        IF (ProdOrderLine."Starting Date" < "Starting Date") OR
           ((ProdOrderLine."Starting Date" = "Starting Date") AND
            (ProdOrderLine."Starting Time" < "Starting Time"))
        THEN BEGIN
          "Starting Time" := ProdOrderLine."Starting Time";
          "Starting Date" := ProdOrderLine."Starting Date";
        END;
        IF (ProdOrderLine."Ending Date" > "Ending Date") OR
           ((ProdOrderLine."Ending Date" = "Ending Date") AND
            (ProdOrderLine."Ending Time" > "Ending Time"))
        THEN BEGIN
          "Ending Time" := ProdOrderLine."Ending Time";
          "Ending Date" := ProdOrderLine."Ending Date";
        END;
      UNTIL ProdOrderLine.NEXT = 0;
      UpdateDatetime;
    END;

    LOCAL PROCEDURE MultiLevelMessage@4();
    BEGIN
      MESSAGE(
        Text003 +
        Text005);
    END;

    [External]
    PROCEDURE UpdateDatetime@11();
    BEGIN
      IF ("Starting Date" <> 0D) AND ("Starting Time" <> 0T) THEN
        "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time")
      ELSE
        "Starting Date-Time" := 0DT;

      IF ("Ending Date" <> 0D) AND ("Ending Time" <> 0T) THEN
        "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time")
      ELSE
        "Ending Date-Time" := 0DT;
    END;

    LOCAL PROCEDURE CreateDim@8(Type1@1000 : Integer;No1@1001 : Code[20]);
    VAR
      TableID@1002 : ARRAY [10] OF Integer;
      No@1003 : ARRAY [10] OF Code[20];
    BEGIN
      TableID[1] := Type1;
      No[1] := No1;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,'',"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@13(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    VAR
      OldDimSetID@1002 : Integer;
    BEGIN
      OldDimSetID := "Dimension Set ID";
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");

      IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
        IF Status = Status::Finished THEN
          ERROR(Text011);
        MODIFY;
        IF SalesLinesExist THEN
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
      END;
    END;

    [External]
    PROCEDURE Navigate@9();
    VAR
      NavigateForm@1000 : Page 344;
    BEGIN
      NavigateForm.SetDoc("Due Date","No.");
      NavigateForm.RUN;
    END;

    [External]
    PROCEDURE CreatePick@7300(AssignedUserID@1009 : Code[50];SortingMethod@1008 : Option;SetBreakBulkFilter@1007 : Boolean;DoNotFillQtyToHandle@1006 : Boolean;PrintDocument@1005 : Boolean);
    VAR
      ProdOrderCompLine@1001 : Record 5407;
      WhseWkshLine@1004 : Record 7326;
      CreatePickFromWhseSource@1002 : Report 7305;
      ItemTrackingMgt@1003 : Codeunit 6500;
    BEGIN
      ProdOrderCompLine.RESET;
      ProdOrderCompLine.SETRANGE(Status,Status);
      ProdOrderCompLine.SETRANGE("Prod. Order No.","No.");
      IF ProdOrderCompLine.FIND('-') THEN
        REPEAT
          ItemTrackingMgt.InitItemTrkgForTempWkshLine(
            WhseWkshLine."Whse. Document Type"::Production,ProdOrderCompLine."Prod. Order No.",
            ProdOrderCompLine."Prod. Order Line No.",DATABASE::"Prod. Order Component",
            ProdOrderCompLine.Status,ProdOrderCompLine."Prod. Order No.",
            ProdOrderCompLine."Prod. Order Line No.",ProdOrderCompLine."Line No.");
        UNTIL ProdOrderCompLine.NEXT = 0;
      COMMIT;

      TESTFIELD(Status,Status::Released);
      CALCFIELDS("Completely Picked");
      IF "Completely Picked" THEN
        ERROR(Text008);

      ProdOrderCompLine.RESET;
      ProdOrderCompLine.SETRANGE(Status,Status);
      ProdOrderCompLine.SETRANGE("Prod. Order No.","No.");
      ProdOrderCompLine.SETFILTER(
        "Flushing Method",'%1|%2|%3',
        ProdOrderCompLine."Flushing Method"::Manual,
        ProdOrderCompLine."Flushing Method"::"Pick + Forward",
        ProdOrderCompLine."Flushing Method"::"Pick + Backward");
      ProdOrderCompLine.SETRANGE("Planning Level Code",0);
      ProdOrderCompLine.SETFILTER("Expected Quantity",'>0');
      IF ProdOrderCompLine.FIND('-') THEN BEGIN
        CreatePickFromWhseSource.SetProdOrder(Rec);
        CreatePickFromWhseSource.SetHideValidationDialog(HideValidationDialog);
        IF HideValidationDialog THEN
          CreatePickFromWhseSource.Initialize(AssignedUserID,SortingMethod,PrintDocument,DoNotFillQtyToHandle,SetBreakBulkFilter);
        CreatePickFromWhseSource.USEREQUESTPAGE(NOT HideValidationDialog);
        CreatePickFromWhseSource.RUNMODAL;
        CreatePickFromWhseSource.GetResultMessage(2);
        CLEAR(CreatePickFromWhseSource);
      END ELSE
        IF NOT HideValidationDialog THEN
          MESSAGE(Text008);
    END;

    [External]
    PROCEDURE SetHideValidationDialog@7301(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    [External]
    PROCEDURE CreateInvtPutAwayPick@29();
    VAR
      WhseRequest@1000 : Record 5765;
    BEGIN
      TESTFIELD(Status,Status::Released);

      WhseRequest.RESET;
      WhseRequest.SETCURRENTKEY("Source Document","Source No.");
      WhseRequest.SETFILTER(
        "Source Document",'%1|%2',
        WhseRequest."Source Document"::"Prod. Consumption",
        WhseRequest."Source Document"::"Prod. Output");
      WhseRequest.SETRANGE("Source No.","No.");
      REPORT.RUNMODAL(REPORT::"Create Invt Put-away/Pick/Mvmt",TRUE,FALSE,WhseRequest);
    END;

    LOCAL PROCEDURE GetDefaultBin@50();
    VAR
      WMSManagement@1000 : Codeunit 7302;
    BEGIN
      "Bin Code" := '';
      IF "Source Type" <> "Source Type"::Item THEN
        EXIT;

      IF "Location Code" <> '' THEN BEGIN
        GetLocation("Location Code");
        IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
          "Bin Code" := Location."From-Production Bin Code";
      END;
      IF ("Bin Code" = '') AND ("Source No." <> '') THEN
        WMSManagement.GetDefaultBin("Source No.",'',"Location Code","Bin Code");
    END;

    LOCAL PROCEDURE GetLocation@15(LocationCode@1000 : Code[10]);
    BEGIN
      IF Location.Code <> LocationCode THEN
        Location.GET(LocationCode);
    END;

    [External]
    PROCEDURE SetUpdateEndDate@16();
    BEGIN
      UpdateEndDate := TRUE;
    END;

    LOCAL PROCEDURE UpdateEndingDate@17(VAR ProdOrderLine@1000 : Record 5406);
    BEGIN
      IF ProdOrderLine.FINDSET(TRUE) THEN
        REPEAT
          ProdOrderLine."Due Date" := "Due Date";
          ProdOrderLine.MODIFY;
          CalcProdOrder.SetParameter(TRUE);
          ProdOrderLine."Ending Date" :=
            LeadTimeMgt.PlannedEndingDate(
              ProdOrderLine."Item No.",
              ProdOrderLine."Location Code",
              ProdOrderLine."Variant Code",
              ProdOrderLine."Due Date",
              '',
              2);
          CalcProdOrder.Recalculate(ProdOrderLine,1,TRUE);
          "Starting Date-Time" := CREATEDATETIME("Starting Date","Starting Time");
          "Ending Date-Time" := CREATEDATETIME("Ending Date","Ending Time");
          ProdOrderLine.MODIFY(TRUE);
          ProdOrderLine.CheckEndingDate(CurrFieldNo <> 0);
        UNTIL ProdOrderLine.NEXT = 0
    END;

    [External]
    PROCEDURE ShowDocDim@18();
    VAR
      OldDimSetID@1000 : Integer;
    BEGIN
      OldDimSetID := "Dimension Set ID";
      TESTFIELD("No.");
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
        IF Status = Status::Finished THEN
          ERROR(Text011);
        MODIFY;
        IF SalesLinesExist THEN
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
      END;
    END;

    LOCAL PROCEDURE SalesLinesExist@14() : Boolean;
    BEGIN
      ProdOrderLine.RESET;
      ProdOrderLine.SETRANGE("Prod. Order No.","No.");
      ProdOrderLine.SETRANGE(Status,Status);
      EXIT(ProdOrderLine.FINDFIRST);
    END;

    LOCAL PROCEDURE UpdateAllLineDim@34(NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 : Integer);
    VAR
      NewDimSetID@1002 : Integer;
      OldDimSetID@1003 : Integer;
    BEGIN
      // Update all lines with changed dimensions.

      IF NewParentDimSetID = OldParentDimSetID THEN
        EXIT;
      IF NOT CONFIRM(Text010) THEN
        EXIT;

      ProdOrderLine.RESET;
      ProdOrderLine.SETRANGE("Prod. Order No.","No.");
      ProdOrderLine.SETRANGE(Status,Status);
      ProdOrderLine.LOCKTABLE;
      IF ProdOrderLine.FIND('-') THEN
        REPEAT
          OldDimSetID := ProdOrderLine."Dimension Set ID";
          NewDimSetID := DimMgt.GetDeltaDimSetID(ProdOrderLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
          IF ProdOrderLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
            ProdOrderLine."Dimension Set ID" := NewDimSetID;
            DimMgt.UpdateGlobalDimFromDimSetID(
              ProdOrderLine."Dimension Set ID",ProdOrderLine."Shortcut Dimension 1 Code",ProdOrderLine."Shortcut Dimension 2 Code");
            ProdOrderLine.MODIFY;
            ProdOrderLine.UpdateProdOrderCompDim(NewDimSetID,OldDimSetID);
          END;
        UNTIL ProdOrderLine.NEXT = 0;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@138(VAR ProductionOrder@1000 : Record 5405;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

