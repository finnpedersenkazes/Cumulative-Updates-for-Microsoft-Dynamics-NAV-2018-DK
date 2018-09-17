OBJECT Table 5766 Warehouse Activity Header
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 TestNoSeries;
                 NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
               END;

               NoSeriesMgt.SetDefaultSeries("Registering No. Series",GetRegisteringNoSeriesCode);
             END;

    OnDelete=BEGIN
               DeleteWhseActivHeader;
             END;

    OnRename=BEGIN
               ERROR(Text000,TABLECAPTION);
             END;

    CaptionML=[DAN=Lageraktivitetshoved;
               ENU=Warehouse Activity Header];
    LookupPageID=Page5774;
  }
  FIELDS
  {
    { 1   ;   ;Type                ;Option        ;CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=" ,L�g-p�-lager,Pluk,Bev�gelse,L�g-p�-lager (lager),Pluk (lager),Flytning (lager)";
                                                                    ENU=" ,Put-away,Pick,Movement,Invt. Put-away,Invt. Pick,Invt. Movement"];
                                                   OptionString=[ ,Put-away,Pick,Movement,Invt. Put-away,Invt. Pick,Invt. Movement] }
    { 2   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 3   ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   OnValidate=VAR
                                                                WMSManagement@1200 : Codeunit 7302;
                                                              BEGIN
                                                                IF "Location Code" <> '' THEN
                                                                  IF NOT WMSManagement.LocationIsAllowed("Location Code") THEN
                                                                    ERROR(STRSUBSTNO(Text001,USERID) + STRSUBSTNO(' %1 %2.',FIELDCAPTION("Location Code"),"Location Code"));

                                                                GetLocation("Location Code");
                                                                CASE Type OF
                                                                  Type::"Invt. Put-away":
                                                                    IF Location.RequireReceive("Location Code") AND ("Source Document" <> "Source Document"::"Prod. Output") THEN
                                                                      VALIDATE("Source Document","Source Document"::"Prod. Output");
                                                                  Type::"Invt. Pick":
                                                                    IF Location.RequireShipment("Location Code") THEN
                                                                      Location.TESTFIELD("Require Shipment",FALSE);
                                                                  Type::"Invt. Movement":
                                                                    Location.TESTFIELD("Directed Put-away and Pick",FALSE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 4   ;   ;Assigned User ID    ;Code50        ;TableRelation="Warehouse Employee" WHERE (Location Code=FIELD(Location Code));
                                                   OnValidate=BEGIN
                                                                IF "Assigned User ID" <> '' THEN BEGIN
                                                                  "Assignment Date" := TODAY;
                                                                  "Assignment Time" := TIME;
                                                                END ELSE BEGIN
                                                                  "Assignment Date" := 0D;
                                                                  "Assignment Time" := 0T;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
    { 5   ;   ;Assignment Date     ;Date          ;CaptionML=[DAN=Tildelt den;
                                                              ENU=Assignment Date];
                                                   Editable=No }
    { 6   ;   ;Assignment Time     ;Time          ;CaptionML=[DAN=Tildelt kl.;
                                                              ENU=Assignment Time];
                                                   Editable=No }
    { 7   ;   ;Sorting Method      ;Option        ;OnValidate=BEGIN
                                                                IF "Sorting Method" <> xRec."Sorting Method" THEN
                                                                  SortWhseDoc;
                                                              END;

                                                   CaptionML=[DAN=Sorteringsmetode;
                                                              ENU=Sorting Method];
                                                   OptionCaptionML=[DAN=" ,Vare,Bilag,Placering,Forfaldsdato,Levering,Placeringsniv.,Handlingstype";
                                                                    ENU=" ,Item,Document,Shelf or Bin,Due Date,Ship-To,Bin Ranking,Action Type"];
                                                   OptionString=[ ,Item,Document,Shelf or Bin,Due Date,Ship-To,Bin Ranking,Action Type] }
    { 9   ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 10  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Warehouse Comment Line" WHERE (Table Name=CONST(Whse. Activity Header),
                                                                                                     Type=FIELD(Type),
                                                                                                     No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 12  ;   ;No. Printed         ;Integer       ;CaptionML=[DAN=Udskrevet;
                                                              ENU=No. Printed];
                                                   Editable=No }
    { 13  ;   ;No. of Lines        ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Warehouse Activity Line" WHERE (Activity Type=FIELD(Type),
                                                                                                      No.=FIELD(No.),
                                                                                                      Source Type=FIELD(Source Type Filter),
                                                                                                      Source Subtype=FIELD(Source Subtype Filter),
                                                                                                      Source No.=FIELD(Source No. Filter),
                                                                                                      Location Code=FIELD(Location Filter)));
                                                   CaptionML=[DAN=Antal linjer;
                                                              ENU=No. of Lines];
                                                   Editable=No }
    { 14  ;   ;Source Type Filter  ;Integer       ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Kildetypefilter;
                                                              ENU=Source Type Filter] }
    { 15  ;   ;Source Subtype Filter;Option       ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Kildeundertypefilter;
                                                              ENU=Source Subtype Filter];
                                                   OptionCaptionML=[DAN=0,1,2,3,4,5,6,7,8,9,10;
                                                                    ENU=0,1,2,3,4,5,6,7,8,9,10];
                                                   OptionString=0,1,2,3,4,5,6,7,8,9,10 }
    { 16  ;   ;Source No. Filter   ;Code250       ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Kildenummerfilter;
                                                              ENU=Source No. Filter] }
    { 17  ;   ;Location Filter     ;Code250       ;FieldClass=FlowFilter;
                                                   TableRelation=Location;
                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Lokationsfilter;
                                                              ENU=Location Filter] }
    { 20  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 61  ;   ;Registering No.     ;Code20        ;CaptionML=[DAN=Registreringsnr.;
                                                              ENU=Registering No.] }
    { 62  ;   ;Last Registering No.;Code20        ;TableRelation=IF (Type=CONST(Put-away)) "Registered Whse. Activity Hdr.".No. WHERE (Type=CONST(Put-away))
                                                                 ELSE IF (Type=CONST(Pick)) "Registered Whse. Activity Hdr.".No. WHERE (Type=CONST(Pick))
                                                                 ELSE IF (Type=CONST(Movement)) "Registered Whse. Activity Hdr.".No. WHERE (Type=CONST(Movement));
                                                   CaptionML=[DAN=Sidste registreringsnr.;
                                                              ENU=Last Registering No.];
                                                   Editable=No }
    { 63  ;   ;Registering No. Series;Code20      ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "Registering No. Series" <> '' THEN BEGIN
                                                                  WhseSetup.GET;
                                                                  TestNoSeries;
                                                                  NoSeriesMgt.TestSeries(GetRegisteringNoSeriesCode,"Registering No. Series");
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              WITH WhseActivHeader DO BEGIN
                                                                WhseActivHeader := Rec;
                                                                WhseSetup.GET;
                                                                TestNoSeries;
                                                                IF NoSeriesMgt.LookupSeries(GetRegisteringNoSeriesCode,"Registering No. Series") THEN
                                                                  VALIDATE("Registering No. Series");
                                                                Rec := WhseActivHeader;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Registreringsnr.serie;
                                                              ENU=Registering No. Series] }
    { 7303;   ;Date of Last Printing;Date         ;CaptionML=[DAN=Sidste udskriftsdato;
                                                              ENU=Date of Last Printing];
                                                   Editable=No }
    { 7304;   ;Time of Last Printing;Time         ;CaptionML=[DAN=Sidste udskriftstidspunkt;
                                                              ENU=Time of Last Printing];
                                                   Editable=No }
    { 7305;   ;Breakbulk Filter    ;Boolean       ;OnValidate=BEGIN
                                                                IF "Breakbulk Filter" <> xRec."Breakbulk Filter" THEN
                                                                  SetBreakbulkFilter;
                                                              END;

                                                   AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Nedbrydningsfilter;
                                                              ENU=Breakbulk Filter] }
    { 7306;   ;Source No.          ;Code20        ;OnValidate=VAR
                                                                WhseRequest@1002 : Record 5765;
                                                                CreateInvtPutAway@1001 : Codeunit 7321;
                                                                CreateInvtPick@1000 : Codeunit 7322;
                                                              BEGIN
                                                                IF "Source No." <> xRec."Source No." THEN BEGIN
                                                                  IF LineExist THEN
                                                                    ERROR(Text002,FIELDCAPTION("Source No."));
                                                                  IF "Source No." <> '' THEN BEGIN
                                                                    TESTFIELD("Location Code");
                                                                    TESTFIELD("Source Document");
                                                                  END;
                                                                  ClearDestinationFields;

                                                                  IF ("Source Type" <> 0) AND ("Source No." <> '') THEN BEGIN
                                                                    IF Type = Type::"Invt. Put-away" THEN BEGIN
                                                                      WhseRequest.GET(
                                                                        WhseRequest.Type::Inbound,"Location Code","Source Type","Source Subtype","Source No.");
                                                                      WhseRequest.TESTFIELD("Document Status",WhseRequest."Document Status"::Released);
                                                                      CreateInvtPutAway.SetWhseRequest(WhseRequest,TRUE);
                                                                      CreateInvtPutAway.RUN(Rec);
                                                                    END;
                                                                    IF Type = Type::"Invt. Pick" THEN BEGIN
                                                                      WhseRequest.GET(
                                                                        WhseRequest.Type::Outbound,"Location Code","Source Type","Source Subtype","Source No.");
                                                                      WhseRequest.TESTFIELD("Document Status",WhseRequest."Document Status"::Released);
                                                                      CreateInvtPick.SetWhseRequest(WhseRequest,TRUE);
                                                                      CreateInvtPick.RUN(Rec);
                                                                    END;
                                                                    IF Type = Type::"Invt. Movement" THEN BEGIN
                                                                      WhseRequest.GET(
                                                                        WhseRequest.Type::Outbound,"Location Code","Source Type","Source Subtype","Source No.");
                                                                      WhseRequest.TESTFIELD("Document Status",WhseRequest."Document Status"::Released);
                                                                      CreateInvtPick.SetInvtMovement(TRUE);
                                                                      CreateInvtPick.SetWhseRequest(WhseRequest,TRUE);
                                                                      CreateInvtPick.RUN(Rec);
                                                                    END;
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 7307;   ;Source Document     ;Option        ;OnValidate=VAR
                                                                AssemblyLine@1000 : Record 901;
                                                              BEGIN
                                                                IF "Source Document" <> xRec."Source Document" THEN BEGIN
                                                                  IF LineExist THEN
                                                                    ERROR(Text002,FIELDCAPTION("Source Document"));
                                                                  "Source No." := '';
                                                                  ClearDestinationFields;
                                                                  IF Type = Type::"Invt. Put-away" THEN BEGIN
                                                                    GetLocation("Location Code");
                                                                    IF Location.RequireReceive("Location Code") THEN
                                                                      TESTFIELD("Source Document","Source Document"::"Prod. Output");
                                                                  END;
                                                                END;

                                                                CASE "Source Document" OF
                                                                  "Source Document"::"Purchase Order":
                                                                    BEGIN
                                                                      "Source Type" := 39;
                                                                      "Source Subtype" := 1;
                                                                    END;
                                                                  "Source Document"::"Purchase Return Order":
                                                                    BEGIN
                                                                      "Source Type" := 39;
                                                                      "Source Subtype" := 5;
                                                                    END;
                                                                  "Source Document"::"Sales Order":
                                                                    BEGIN
                                                                      "Source Type" := 37;
                                                                      "Source Subtype" := 1;
                                                                    END;
                                                                  "Source Document"::"Sales Return Order":
                                                                    BEGIN
                                                                      "Source Type" := 37;
                                                                      "Source Subtype" := 5;
                                                                    END;
                                                                  "Source Document"::"Outbound Transfer":
                                                                    BEGIN
                                                                      "Source Type" := 5741;
                                                                      "Source Subtype" := 0;
                                                                    END;
                                                                  "Source Document"::"Inbound Transfer":
                                                                    BEGIN
                                                                      "Source Type" := 5741;
                                                                      "Source Subtype" := 1;
                                                                    END;
                                                                  "Source Document"::"Prod. Consumption":
                                                                    BEGIN
                                                                      "Source Type" := 5407;
                                                                      "Source Subtype" := 3;
                                                                    END;
                                                                  "Source Document"::"Prod. Output":
                                                                    BEGIN
                                                                      "Source Type" := 5406;
                                                                      "Source Subtype" := 3;
                                                                    END;
                                                                  "Source Document"::"Assembly Consumption":
                                                                    BEGIN
                                                                      "Source Type" := DATABASE::"Assembly Line";
                                                                      "Source Subtype" := AssemblyLine."Document Type"::Order;
                                                                    END;
                                                                END;

                                                                IF "Source Document" = 0 THEN BEGIN
                                                                  "Source Type" := 0;
                                                                  "Source Subtype" := 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Kildedokument;
                                                              ENU=Source Document];
                                                   OptionCaptionML=[DAN=" ,Salgsordre,,,Salgsreturvareordre,K�bsordre,,,K�bsreturvareordre,Indg�ende overf�rsel,Udg�ende overf�rsel,Prod.forbrug,Prod.afgang,,,,,,,,Montageforbrug,Montageordre";
                                                                    ENU=" ,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,Inbound Transfer,Outbound Transfer,Prod. Consumption,Prod. Output,,,,,,,,Assembly Consumption,Assembly Order"];
                                                   OptionString=[ ,Sales Order,,,Sales Return Order,Purchase Order,,,Purchase Return Order,Inbound Transfer,Outbound Transfer,Prod. Consumption,Prod. Output,,,,,,,,Assembly Consumption,Assembly Order];
                                                   BlankZero=Yes }
    { 7308;   ;Source Type         ;Integer       ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type] }
    { 7309;   ;Source Subtype      ;Option        ;CaptionML=[DAN=Kildeundertype;
                                                              ENU=Source Subtype];
                                                   OptionCaptionML=[DAN=0,1,2,3,4,5,6,7,8,9,10;
                                                                    ENU=0,1,2,3,4,5,6,7,8,9,10];
                                                   OptionString=0,1,2,3,4,5,6,7,8,9,10;
                                                   Editable=No }
    { 7310;   ;Destination Type    ;Option        ;CaptionML=[DAN=Destinationstype;
                                                              ENU=Destination Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Lokation,Vare,Familie,Salgsordre";
                                                                    ENU=" ,Customer,Vendor,Location,Item,Family,Sales Order"];
                                                   OptionString=[ ,Customer,Vendor,Location,Item,Family,Sales Order] }
    { 7311;   ;Destination No.     ;Code20        ;TableRelation=IF (Destination Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Destination Type=CONST(Customer)) Customer
                                                                 ELSE IF (Destination Type=CONST(Location)) Location
                                                                 ELSE IF (Destination Type=CONST(Item)) Item
                                                                 ELSE IF (Destination Type=CONST(Family)) Family
                                                                 ELSE IF (Destination Type=CONST(Sales Order)) "Sales Header".No. WHERE (Document Type=CONST(Order));
                                                   CaptionML=[DAN=Destinationsnr.;
                                                              ENU=Destination No.] }
    { 7312;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 7313;   ;Expected Receipt Date;Date         ;CaptionML=[DAN=Forventet modt.dato;
                                                              ENU=Expected Receipt Date] }
    { 7314;   ;Shipment Date       ;Date          ;CaptionML=[DAN=Afsendelsesdato;
                                                              ENU=Shipment Date] }
    { 7315;   ;External Document No.2;Code35      ;CaptionML=[DAN=Eksternt bilagsnr. 2;
                                                              ENU=External Document No.2] }
  }
  KEYS
  {
    {    ;Type,No.                                ;Clustered=Yes }
    {    ;Location Code                            }
    {    ;Source Document,Source No.,Location Code }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      Location@1012 : Record 14;
      WhseActivHeader@1006 : Record 5766;
      WhseSetup@1008 : Record 5769;
      InvtSetup@1002 : Record 313;
      NoSeriesMgt@1010 : Codeunit 396;
      Text001@1001 : TextConst 'DAN=Du skal f�rst oprette brugeren %1 som lagermedarbejder.;ENU=You must first set up user %1 as a warehouse employee.';
      Text002@1003 : TextConst 'DAN=Du kan ikke �ndre %1, da der findes en eller flere linjer.;ENU=You cannot change %1 because one or more lines exist.';

    [External]
    PROCEDURE AssistEdit@8(OldWhseActivHeader@1000 : Record 5766) : Boolean;
    BEGIN
      WITH WhseActivHeader DO BEGIN
        WhseActivHeader := Rec;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldWhseActivHeader."No. Series","No. Series")
        THEN BEGIN
          NoSeriesMgt.SetSeries("No.");
          Rec := WhseActivHeader;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE GetNoSeriesCode@7() : Code[20];
    BEGIN
      CASE Type OF
        Type::"Put-away":
          BEGIN
            WhseSetup.GET;
            EXIT(WhseSetup."Whse. Put-away Nos.");
          END;
        Type::Pick:
          BEGIN
            WhseSetup.GET;
            EXIT(WhseSetup."Whse. Pick Nos.");
          END;
        Type::Movement:
          BEGIN
            WhseSetup.GET;
            EXIT(WhseSetup."Whse. Movement Nos.");
          END;
        Type::"Invt. Put-away":
          BEGIN
            InvtSetup.GET;
            EXIT(InvtSetup."Inventory Put-away Nos.");
          END;
        Type::"Invt. Pick":
          BEGIN
            InvtSetup.GET;
            EXIT(InvtSetup."Inventory Pick Nos.");
          END;
        Type::"Invt. Movement":
          BEGIN
            InvtSetup.GET;
            EXIT(InvtSetup."Inventory Movement Nos.");
          END;
      END;
    END;

    LOCAL PROCEDURE TestNoSeries@5();
    BEGIN
      CASE Type OF
        Type::"Put-away":
          BEGIN
            WhseSetup.GET;
            WhseSetup.TESTFIELD("Whse. Put-away Nos.");
          END;
        Type::Pick:
          BEGIN
            WhseSetup.GET;
            WhseSetup.TESTFIELD("Whse. Pick Nos.");
          END;
        Type::Movement:
          BEGIN
            WhseSetup.GET;
            WhseSetup.TESTFIELD("Whse. Movement Nos.");
          END;
        Type::"Invt. Put-away":
          BEGIN
            InvtSetup.GET;
            InvtSetup.TESTFIELD("Inventory Put-away Nos.");
          END;
        Type::"Invt. Pick":
          BEGIN
            InvtSetup.GET;
            InvtSetup.TESTFIELD("Inventory Pick Nos.");
          END;
        Type::"Invt. Movement":
          BEGIN
            InvtSetup.GET;
            InvtSetup.TESTFIELD("Inventory Movement Nos.");
          END;
      END;
    END;

    LOCAL PROCEDURE GetRegisteringNoSeriesCode@9() : Code[20];
    VAR
      InventorySetup@1000 : Record 313;
    BEGIN
      WhseSetup.GET;
      CASE Type OF
        Type::"Put-away":
          EXIT(WhseSetup."Registered Whse. Put-away Nos.");
        Type::Pick:
          EXIT(WhseSetup."Registered Whse. Pick Nos.");
        Type::Movement:
          EXIT(WhseSetup."Registered Whse. Movement Nos.");
        Type::"Invt. Movement":
          BEGIN
            InventorySetup.GET;
            EXIT(InventorySetup."Registered Invt. Movement Nos.");
          END;
      END;
    END;

    [External]
    PROCEDURE SortWhseDoc@3();
    VAR
      WhseActivLine2@1001 : Record 5767;
      WhseActivLine3@1002 : Record 5767;
      BreakBulkWhseActivLine@1003 : Record 5767;
      TempWhseActivLine@1004 : TEMPORARY Record 5767;
      SequenceNo@1000 : Integer;
      SortingOrder@1005 : 'Bin,Shelf';
    BEGIN
      WhseActivLine2.LOCKTABLE;
      WhseActivLine2.SETRANGE("Activity Type",Type);
      WhseActivLine2.SETRANGE("No.","No.");
      CASE "Sorting Method" OF
        "Sorting Method"::Item:
          WhseActivLine2.SETCURRENTKEY("Activity Type","No.","Item No.");
        "Sorting Method"::Document:
          WhseActivLine2.SETCURRENTKEY(
            "Activity Type","No.","Location Code","Source Document","Source No.");
        "Sorting Method"::"Shelf or Bin":
          BEGIN
            GetLocation("Location Code");
            IF Location."Bin Mandatory" THEN BEGIN
              WhseActivLine2.SETCURRENTKEY("Activity Type","No.","Bin Code");
              IF WhseActivLine2.FIND('-') THEN
                IF WhseActivLine2."Activity Type" <> WhseActivLine2."Activity Type"::Pick
                THEN BEGIN
                  SequenceNo := 10000;
                  WhseActivLine2.SETRANGE("Action Type",WhseActivLine2."Action Type"::Place);
                  WhseActivLine2.SETRANGE("Breakbulk No.",0);
                  IF WhseActivLine2.FIND('-') THEN
                    REPEAT
                      TempWhseActivLine.INIT;
                      TempWhseActivLine.COPY(WhseActivLine2);
                      TempWhseActivLine.INSERT;
                    UNTIL WhseActivLine2.NEXT = 0;
                  TempWhseActivLine.SETRANGE("Breakbulk No.",0);
                  IF TempWhseActivLine.FIND('-') THEN
                    REPEAT
                      WhseActivLine2.SETRANGE("Breakbulk No.",0);
                      WhseActivLine2.SETRANGE(
                        "Action Type",WhseActivLine2."Action Type"::Take);
                      WhseActivLine2.SETRANGE(
                        "Whse. Document Type",TempWhseActivLine."Whse. Document Type");
                      WhseActivLine2.SETRANGE(
                        "Whse. Document No.",TempWhseActivLine."Whse. Document No.");
                      WhseActivLine2.SETRANGE(
                        "Whse. Document Line No.",TempWhseActivLine."Whse. Document Line No.");
                      IF WhseActivLine2.FIND('-') THEN
                        REPEAT
                          SortTakeLines(WhseActivLine2,SequenceNo);
                          WhseActivLine3.GET(
                            TempWhseActivLine."Activity Type",
                            TempWhseActivLine."No.",TempWhseActivLine."Line No.");
                          WhseActivLine3."Sorting Sequence No." := SequenceNo;
                          WhseActivLine3.MODIFY;
                          SequenceNo := SequenceNo + 10000;
                        UNTIL WhseActivLine2.NEXT = 0;
                    UNTIL TempWhseActivLine.NEXT = 0;
                END ELSE BEGIN
                  SortLinesBinShelf(WhseActivLine2,SequenceNo,SortingOrder::Bin);
                  WhseActivLine2.SETCURRENTKEY("Activity Type","No.","Sorting Sequence No.");
                END;
            END ELSE BEGIN
              SortLinesBinShelf(WhseActivLine2,SequenceNo,SortingOrder::Shelf);
              WhseActivLine2.SETCURRENTKEY("Activity Type","No.","Sorting Sequence No.");
            END;
          END;
        "Sorting Method"::"Due Date":
          WhseActivLine2.SETCURRENTKEY("Activity Type","No.","Due Date");
        "Sorting Method"::"Ship-To":
          WhseActivLine2.SETCURRENTKEY(
            "Activity Type","No.","Destination Type","Destination No.");
        "Sorting Method"::"Bin Ranking":
          BEGIN
            WhseActivLine2.SETCURRENTKEY("Activity Type","No.","Bin Ranking");
            WhseActivLine2.SETRANGE("Breakbulk No.",0);
            IF WhseActivLine2.FIND('-') THEN BEGIN
              SequenceNo := 10000;
              WhseActivLine2.SETRANGE("Action Type",WhseActivLine2."Action Type"::Take);
              IF WhseActivLine2.FIND('-') THEN
                REPEAT
                  SetActivityFilter(WhseActivLine2,WhseActivLine3);
                  IF WhseActivLine3.FIND('-') THEN
                    REPEAT
                      WhseActivLine3."Sorting Sequence No." := SequenceNo;
                      WhseActivLine3.MODIFY;
                      SequenceNo := SequenceNo + 10000;
                      BreakBulkWhseActivLine.COPY(WhseActivLine3);
                      BreakBulkWhseActivLine.SETRANGE("Action Type",WhseActivLine3."Action Type"::Place);
                      BreakBulkWhseActivLine.SETRANGE("Breakbulk No.",WhseActivLine3."Breakbulk No.");
                      IF BreakBulkWhseActivLine.FIND('-') THEN
                        REPEAT
                          BreakBulkWhseActivLine."Sorting Sequence No." := SequenceNo;
                          BreakBulkWhseActivLine.MODIFY;
                          SequenceNo := SequenceNo + 10000;
                        UNTIL BreakBulkWhseActivLine.NEXT = 0;
                    UNTIL WhseActivLine3.NEXT = 0;
                  WhseActivLine2."Sorting Sequence No." := SequenceNo;
                  WhseActivLine2.MODIFY;
                  SequenceNo := SequenceNo + 10000;
                UNTIL WhseActivLine2.NEXT = 0;
              WhseActivLine2.SETRANGE("Action Type",WhseActivLine2."Action Type"::Place);
              WhseActivLine2.SETRANGE("Breakbulk No.",0);
              IF WhseActivLine2.FIND('-') THEN
                REPEAT
                  WhseActivLine2."Sorting Sequence No." := SequenceNo;
                  WhseActivLine2.MODIFY;
                  SequenceNo := SequenceNo + 10000;
                UNTIL WhseActivLine2.NEXT = 0;
            END;
          END;
        "Sorting Method"::"Action Type":
          BEGIN
            WhseActivLine2.SETCURRENTKEY("Activity Type","No.","Action Type","Bin Code");
            WhseActivLine2.SETRANGE("Action Type",WhseActivLine2."Action Type"::Take);
            IF WhseActivLine2.FIND('-') THEN BEGIN
              SequenceNo := 10000;
              REPEAT
                WhseActivLine2."Sorting Sequence No." := SequenceNo;
                WhseActivLine2.MODIFY;
                SequenceNo := SequenceNo + 10000;
                IF WhseActivLine2."Breakbulk No." <> 0 THEN BEGIN
                  WhseActivLine3.COPY(WhseActivLine2);
                  WhseActivLine3.SETRANGE("Action Type",WhseActivLine2."Action Type"::Place);
                  WhseActivLine3.SETRANGE("Breakbulk No.",WhseActivLine2."Breakbulk No.");
                  IF WhseActivLine3.FIND('-') THEN
                    REPEAT
                      WhseActivLine3."Sorting Sequence No." := SequenceNo;
                      WhseActivLine3.MODIFY;
                      SequenceNo := SequenceNo + 10000;
                    UNTIL WhseActivLine3.NEXT = 0;
                END;
              UNTIL WhseActivLine2.NEXT = 0;
            END;
            WhseActivLine2.SETRANGE("Action Type",WhseActivLine2."Action Type"::Place);
            WhseActivLine2.SETRANGE("Breakbulk No.",0);
            IF WhseActivLine2.FIND('-') THEN
              REPEAT
                WhseActivLine2."Sorting Sequence No." := SequenceNo;
                WhseActivLine2.MODIFY;
                SequenceNo := SequenceNo + 10000;
              UNTIL WhseActivLine2.NEXT = 0;
          END;
      END;

      IF SequenceNo = 0 THEN BEGIN
        WhseActivLine2.SETRANGE("Breakbulk No.",0);
        IF WhseActivLine2.FIND('-') THEN BEGIN
          SequenceNo := 10000;
          REPEAT
            SetActivityFilter(WhseActivLine2,WhseActivLine3);
            IF WhseActivLine3.FIND('-') THEN
              REPEAT
                WhseActivLine3."Sorting Sequence No." := SequenceNo;
                WhseActivLine3.MODIFY;
                SequenceNo := SequenceNo + 10000;
              UNTIL WhseActivLine3.NEXT = 0;

            WhseActivLine2."Sorting Sequence No." := SequenceNo;
            WhseActivLine2.MODIFY;
            SequenceNo := SequenceNo + 10000;
          UNTIL WhseActivLine2.NEXT = 0;
        END;
      END;
    END;

    LOCAL PROCEDURE SortTakeLines@10(VAR NewWhseActivLine2@1000 : Record 5767;VAR NewSequenceNo@1001 : Integer);
    VAR
      WhseActivLine3@1002 : Record 5767;
    BEGIN
      IF NOT NewWhseActivLine2.MARK THEN BEGIN
        WhseActivLine3.COPY(NewWhseActivLine2);
        WhseActivLine3.SETRANGE("Bin Code",NewWhseActivLine2."Bin Code");
        WhseActivLine3.SETFILTER("Breakbulk No.",'<>0');
        WhseActivLine3.SETRANGE("Action Type");
        IF WhseActivLine3.FIND('-') THEN
          REPEAT
            WhseActivLine3."Sorting Sequence No." := NewSequenceNo;
            WhseActivLine3.MODIFY;
            NewSequenceNo := NewSequenceNo + 10000;
          UNTIL WhseActivLine3.NEXT = 0;

        NewWhseActivLine2.MARK(TRUE);
        NewWhseActivLine2."Sorting Sequence No." := NewSequenceNo;
        NewWhseActivLine2.MODIFY;
        NewSequenceNo := NewSequenceNo + 10000;
      END;
    END;

    LOCAL PROCEDURE SortLinesBinShelf@12(VAR WarehouseActivityLineParam@1000 : Record 5767;VAR SeqNo@1001 : Integer;SortOrder@1002 : 'Bin,Shelf');
    VAR
      WarehouseActivityLineLocal@1003 : Record 5767;
      TempWarehouseActivityLine@1004 : TEMPORARY Record 5767;
      NewSequenceNo@1005 : Integer;
    BEGIN
      TempWarehouseActivityLine.DELETEALL;
      SeqNo := 0;
      WarehouseActivityLineLocal.COPY(WarehouseActivityLineParam);
      WarehouseActivityLineLocal.SETCURRENTKEY("Activity Type","No.","Line No.");
      IF NOT WarehouseActivityLineLocal.FINDSET THEN
        EXIT;
      REPEAT
        IF WarehouseActivityLineLocal."Action Type" = WarehouseActivityLineLocal."Action Type"::Take THEN BEGIN
          TempWarehouseActivityLine := WarehouseActivityLineLocal;
          TempWarehouseActivityLine.INSERT;
        END;
      UNTIL WarehouseActivityLineLocal.NEXT = 0;
      CASE SortOrder OF
        SortOrder::Bin:
          TempWarehouseActivityLine.SETCURRENTKEY("Activity Type","No.","Bin Code");
        SortOrder::Shelf:
          TempWarehouseActivityLine.SETCURRENTKEY("Activity Type","No.","Shelf No.");
      END;
      IF NOT TempWarehouseActivityLine.FIND('-') THEN
        EXIT;
      NewSequenceNo := 0;
      REPEAT
        NewSequenceNo += 10000;
        WarehouseActivityLineLocal.GET(
          TempWarehouseActivityLine."Activity Type",TempWarehouseActivityLine."No.",TempWarehouseActivityLine."Line No.");
        WarehouseActivityLineLocal."Sorting Sequence No." := NewSequenceNo;
        WarehouseActivityLineLocal.MODIFY;
        NewSequenceNo += 10000;
        IF WarehouseActivityLineLocal.NEXT <> 0 THEN
          IF WarehouseActivityLineLocal."Action Type" = WarehouseActivityLineLocal."Action Type"::Place THEN BEGIN
            WarehouseActivityLineLocal."Sorting Sequence No." := NewSequenceNo;
            WarehouseActivityLineLocal.MODIFY;
          END;
      UNTIL TempWarehouseActivityLine.NEXT = 0;
      SeqNo := NewSequenceNo;
    END;

    LOCAL PROCEDURE SetBreakbulkFilter@6();
    VAR
      WhseActivLine@1000 : Record 5767;
    BEGIN
      WhseActivLine.SETRANGE("Activity Type",Type);
      WhseActivLine.SETRANGE("No.","No.");
      WhseActivLine.SETRANGE("Original Breakbulk",TRUE);
      IF "Breakbulk Filter" THEN
        WhseActivLine.MODIFYALL(Breakbulk,TRUE)
      ELSE
        WhseActivLine.MODIFYALL(Breakbulk,FALSE)
    END;

    LOCAL PROCEDURE SetActivityFilter@18(VAR WhseActivLineFrom@1000 : Record 5767;VAR WhseActivLineTo@1001 : Record 5767);
    BEGIN
      WhseActivLineTo.COPY(WhseActivLineFrom);
      WhseActivLineTo.SETRANGE("Bin Code",WhseActivLineFrom."Bin Code");
      WhseActivLineTo.SETFILTER("Breakbulk No.",'<>0');
      WhseActivLineTo.SETRANGE("Whse. Document Type",WhseActivLineFrom."Whse. Document Type");
      WhseActivLineTo.SETRANGE("Whse. Document No.",WhseActivLineFrom."Whse. Document No.");
      WhseActivLineTo.SETRANGE("Whse. Document Line No.",WhseActivLineFrom."Whse. Document Line No.");
    END;

    LOCAL PROCEDURE DeleteWhseActivHeader@11();
    VAR
      WhseActivLine2@1000 : Record 5767;
      WhseCommentLine@1001 : Record 5770;
    BEGIN
      WhseActivLine2.SETRANGE("Activity Type",Type);
      WhseActivLine2.SETRANGE("No.","No.");
      IF WhseActivLine2.FINDFIRST THEN
        WhseActivLine2.DeleteRelatedWhseActivLines(WhseActivLine2,TRUE);

      WhseCommentLine.SETRANGE("Table Name",WhseCommentLine."Table Name"::"Whse. Activity Header");
      WhseCommentLine.SETRANGE(Type,Type);
      WhseCommentLine.SETRANGE("No.","No.");
      WhseCommentLine.DELETEALL;
    END;

    LOCAL PROCEDURE GetLocation@4(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        CLEAR(Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    [External]
    PROCEDURE LookupActivityHeader@1(VAR CurrentLocationCode@1000 : Code[10];VAR WhseActivHeader@1001 : Record 5766);
    BEGIN
      COMMIT;
      IF USERID <> '' THEN BEGIN
        WhseActivHeader.FILTERGROUP := 2;
        WhseActivHeader.SETRANGE("Location Code");
      END;
      IF PAGE.RUNMODAL(0,WhseActivHeader) = ACTION::LookupOK THEN;
      IF USERID <> '' THEN BEGIN
        WhseActivHeader.FILTERGROUP := 2;
        WhseActivHeader.SETRANGE("Location Code",WhseActivHeader."Location Code");
        WhseActivHeader.FILTERGROUP := 0;
      END;
      CurrentLocationCode := WhseActivHeader."Location Code";
    END;

    [External]
    PROCEDURE LineExist@2() : Boolean;
    VAR
      WhseActivLine@1000 : Record 5767;
    BEGIN
      WhseActivLine.SETRANGE("Activity Type",Type);
      WhseActivLine.SETRANGE("No.","No.");
      EXIT(NOT WhseActivLine.ISEMPTY);
    END;

    [External]
    PROCEDURE FindFirstAllowedRec@13(Which@1000 : Text[1024]) : Boolean;
    VAR
      WhseActivHeader@1010 : Record 5766;
      WMSManagement@1001 : Codeunit 7302;
    BEGIN
      IF FIND(Which) THEN BEGIN
        WhseActivHeader := Rec;
        WHILE TRUE DO BEGIN
          IF WMSManagement.LocationIsAllowedToView("Location Code") THEN
            EXIT(TRUE);

          IF NEXT(1) = 0 THEN BEGIN
            Rec := WhseActivHeader;
            IF FIND(Which) THEN
              WHILE TRUE DO BEGIN
                IF WMSManagement.LocationIsAllowedToView("Location Code") THEN
                  EXIT(TRUE);

                IF NEXT(-1) = 0 THEN
                  EXIT(FALSE);
              END;
          END;
        END;
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE FindNextAllowedRec@14(Steps@1000 : Integer) : Integer;
    VAR
      WhseActivHeader@1010 : Record 5766;
      WMSManagement@1001 : Codeunit 7302;
      RealSteps@1003 : Integer;
      NextSteps@1002 : Integer;
    BEGIN
      RealSteps := 0;
      IF Steps <> 0 THEN BEGIN
        WhseActivHeader := Rec;
        REPEAT
          NextSteps := NEXT(Steps / ABS(Steps));
          IF WMSManagement.LocationIsAllowedToView("Location Code") THEN BEGIN
            RealSteps := RealSteps + NextSteps;
            WhseActivHeader := Rec;
          END;
        UNTIL (NextSteps = 0) OR (RealSteps = Steps);
        Rec := WhseActivHeader;
        IF NOT FIND THEN ;
      END;
      EXIT(RealSteps);
    END;

    [External]
    PROCEDURE ErrorIfUserIsNotWhseEmployee@15();
    VAR
      WhseEmployee@1000 : Record 7301;
    BEGIN
      IF USERID <> '' THEN BEGIN
        WhseEmployee.SETRANGE("User ID",USERID);
        IF WhseEmployee.ISEMPTY THEN
          ERROR(Text001,USERID);
      END;
    END;

    [External]
    PROCEDURE GetUserLocation@17() : Code[10];
    VAR
      WarehouseEmployee@1000 : Record 7301;
    BEGIN
      WarehouseEmployee.SETCURRENTKEY(Default);
      WarehouseEmployee.SETRANGE("User ID",USERID);
      WarehouseEmployee.SETRANGE(Default,TRUE);
      IF WarehouseEmployee.FINDFIRST THEN
        EXIT(WarehouseEmployee."Location Code");

      WarehouseEmployee.SETRANGE(Default);
      WarehouseEmployee.FINDFIRST;
      EXIT(WarehouseEmployee."Location Code");
    END;

    LOCAL PROCEDURE ClearDestinationFields@16();
    BEGIN
      "Destination Type" := "Destination Type"::" ";
      "Destination No." := '';
    END;

    BEGIN
    END.
  }
}

