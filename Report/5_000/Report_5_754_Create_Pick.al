OBJECT Report 5754 Create Pick
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opret pluk;
               ENU=Create Pick];
    ProcessingOnly=Yes;
  }
  DATASET
  {
    { 5444;    ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               CLEAR(CreatePick);
                               CreatePick.SetValues(
                                 AssignedID,0,SortPick,1,MaxNoOfSourceDoc,MaxNoOfLines,PerZone,
                                 DoNotFillQtytoHandle,BreakbulkFilter,PerBin);
                             END;

               OnAfterGetRecord=BEGIN
                                  PickWkshLine.SETFILTER("Qty. to Handle (Base)",'>%1',0);
                                  PickWkshLineFilter.COPYFILTERS(PickWkshLine);

                                  IF PickWkshLine.FIND('-') THEN BEGIN
                                    IF PickWkshLine."Location Code" = '' THEN
                                      Location.INIT
                                    ELSE
                                      Location.GET(PickWkshLine."Location Code");
                                    REPEAT
                                      PickWkshLine.CheckBin(PickWkshLine."Location Code",PickWkshLine."To Bin Code",TRUE);
                                      TempNo := TempNo + 1;

                                      IF PerWhseDoc THEN BEGIN
                                        PickWkshLine.SETRANGE("Whse. Document Type",PickWkshLine."Whse. Document Type");
                                        PickWkshLine.SETRANGE("Whse. Document No.",PickWkshLine."Whse. Document No.");
                                      END;
                                      IF PerDestination THEN BEGIN
                                        PickWkshLine.SETRANGE("Destination Type",PickWkshLine."Destination Type");
                                        PickWkshLine.SETRANGE("Destination No.",PickWkshLine."Destination No.");
                                        SetPickFilters;
                                        PickWkshLineFilter.COPYFILTER("Destination Type",PickWkshLine."Destination Type");
                                        PickWkshLineFilter.COPYFILTER("Destination No.",PickWkshLine."Destination No.");
                                      END ELSE BEGIN
                                        PickWkshLineFilter.COPYFILTER("Destination Type",PickWkshLine."Destination Type");
                                        PickWkshLineFilter.COPYFILTER("Destination No.",PickWkshLine."Destination No.");
                                        SetPickFilters;
                                      END;
                                      PickWkshLineFilter.COPYFILTER("Whse. Document Type",PickWkshLine."Whse. Document Type");
                                      PickWkshLineFilter.COPYFILTER("Whse. Document No.",PickWkshLine."Whse. Document No.");
                                    UNTIL NOT PickWkshLine.FIND('-');
                                    CheckPickActivity;
                                  END ELSE
                                    ERROR(Text000);
                                END;
                                 }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
                   IF LocationCode <> '' THEN BEGIN
                     Location.GET(LocationCode);
                     IF Location."Use ADCS" THEN
                       DoNotFillQtytoHandle := TRUE;
                   END;
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 13  ;2   ;Group     ;
                  CaptionML=[DAN=Opret pluk;
                             ENU=Create Pick] }

      { 21  ;3   ;Field     ;
                  CaptionML=[DAN=Pr. lagerdokument;
                             ENU=Per Whse. Document];
                  ToolTipML=[DAN=Angiver, om du vil oprette separate plukdokumenter til kladdelinjer med samme lagerkildedokument.;
                             ENU=Specifies if you want to create separate pick documents for worksheet lines with the same warehouse source document.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=PerWhseDoc }

      { 3   ;3   ;Field     ;
                  CaptionML=[DAN=Pr. deb./kred./lok.;
                             ENU=Per Cust./Vend./Loc.];
                  ToolTipML=[DAN=Angiver, om du vil oprette separate plukdokumenter for hver debitor (salgsordrer), kreditor (k�bsreturordrer) og lokation (overflytningsordrer).;
                             ENU=Specifies if you want to create separate pick documents for each customer (sale orders), vendor (purchase return orders), and location (transfer orders).];
                  ApplicationArea=#Warehouse;
                  SourceExpr=PerDestination }

      { 6   ;3   ;Field     ;
                  CaptionML=[DAN=Pr. vare;
                             ENU=Per Item];
                  ToolTipML=[DAN=Angiver, om du vil oprette separate plukdokumenter for hver vare i plukkladden.;
                             ENU=Specifies if you want to create separate pick documents for each item in the pick worksheet.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=PerItem }

      { 23  ;3   ;Field     ;
                  CaptionML=[DAN=Pr. fra-zone;
                             ENU=Per From Zone];
                  ToolTipML=[DAN=Angiver, om du vil oprette separate plukdokumenter for hver zone, som du �nsker at tage varerne fra.;
                             ENU=Specifies if you want to create separate pick documents for each zone that you will take the items from.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=PerZone }

      { 8   ;3   ;Field     ;
                  CaptionML=[DAN=Pr. placering;
                             ENU=Per Bin];
                  ToolTipML=[DAN=Angiver, om du vil oprette separate plukdokumenter for hver placering, som du �nsker at tage varerne fra.;
                             ENU=Specifies if you want to create separate pick documents for each bin that you will take the items from.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=PerBin }

      { 10  ;3   ;Field     ;
                  CaptionML=[DAN=Pr. forfaldsdato;
                             ENU=Per Due Date];
                  ToolTipML=[DAN=Angiver, om du vil oprette separate plukdokumenter for kildedokumenter med den samme forfaldsdato.;
                             ENU=Specifies if you want to create separate pick documents for source documents that have the same due date.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=PerDate }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Maks. antal pluklinjer;
                             ENU=Max. No. of Pick Lines];
                  ToolTipML=[DAN=Angiver, om du vil oprette plukdokumenter, der h�jst har det angivne antal linjer i hvert bilag.;
                             ENU=Specifies if you want to create pick documents that have no more than the specified number of lines in each document.];
                  ApplicationArea=#Warehouse;
                  BlankZero=Yes;
                  SourceExpr=MaxNoOfLines;
                  MultiLine=Yes }

      { 12  ;2   ;Field     ;
                  CaptionML=[DAN=Maks. antal plukkildedok.;
                             ENU=Max. No. of Pick Source Docs.];
                  ToolTipML=[DAN=Angiver, om du vil oprette plukdokumenter, der hver is�r h�jst d�kker det angivne antal kildedokumenter.;
                             ENU=Specifies if you want to create pick documents that each cover no more than the specified number of source documents.];
                  ApplicationArea=#Warehouse;
                  BlankZero=Yes;
                  SourceExpr=MaxNoOfSourceDoc;
                  MultiLine=Yes }

      { 16  ;2   ;Field     ;
                  CaptionML=[DAN=Tildelt bruger-id;
                             ENU=Assigned User ID];
                  ToolTipML=[DAN=Angiver id'et for den tildelte bruger, der skal udf�re plukinstruktionen.;
                             ENU=Specifies the ID of the assigned user to perform the pick instruction.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=AssignedID;
                  TableRelation="Warehouse Employee";
                  OnValidate=VAR
                               WhseEmployee@1000 : Record 7301;
                             BEGIN
                               IF AssignedID <> '' THEN
                                 WhseEmployee.GET(AssignedID,LocationCode);
                             END;

                  OnLookup=VAR
                             WhseEmployee@1000 : Record 7301;
                             LookupWhseEmployee@1001 : Page 7348;
                           BEGIN
                             WhseEmployee.SETCURRENTKEY("Location Code");
                             WhseEmployee.SETRANGE("Location Code",LocationCode);
                             LookupWhseEmployee.LOOKUPMODE(TRUE);
                             LookupWhseEmployee.SETTABLEVIEW(WhseEmployee);
                             IF LookupWhseEmployee.RUNMODAL = ACTION::LookupOK THEN BEGIN
                               LookupWhseEmployee.GETRECORD(WhseEmployee);
                               AssignedID := WhseEmployee."User ID";
                             END;
                           END;
                            }

      { 18  ;2   ;Field     ;
                  CaptionML=[DAN=Sorteringsm�de for pluklinjer;
                             ENU=Sorting Method for Pick Lines];
                  ToolTipML=[DAN=Angiver, at du vil v�lge mellem tilg�ngelige indstillinger for at sortere linjer i det oprettede plukdokument.;
                             ENU=Specifies that you want to select from the available options to sort lines in the created pick document.];
                  OptionCaptionML=[DAN=" ,Vare,Bilag,Placering,Forfaldsdato,Destination,Placeringsniv.,Handlingstype";
                                   ENU=" ,Item,Document,Shelf/Bin No.,Due Date,Destination,Bin Ranking,Action Type"];
                  ApplicationArea=#Warehouse;
                  SourceExpr=SortPick;
                  MultiLine=Yes }

      { 26  ;2   ;Field     ;
                  CaptionML=[DAN=Angiv nedbrydningsfilter;
                             ENU=Set Breakbulk Filter];
                  ToolTipML=[DAN=Angiver, at du ikke vil vise de midlertidige nedbrydningspluklinjer, n�r en st�rre m�leenhed konverteres til en mindre m�leenhed og plukkes fuldt ud.;
                             ENU=Specifies if you do not want to view the intermediate breakbulk pick lines, when a larger unit of measure is converted to a smaller unit of measure and completely picked.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=BreakbulkFilter }

      { 24  ;2   ;Field     ;
                  CaptionML=[DAN=Udfyld ikke h�ndteringsantal;
                             ENU=Do Not Fill Qty. to Handle];
                  ToolTipML=[DAN=Angiver, om du vil lade feltet Antal til h�ndtering i de oprettede pluklinjer st� tomt.;
                             ENU=Specifies if you want to leave the Quantity to Handle field in the created pick lines empty.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=DoNotFillQtytoHandle }

      { 14  ;2   ;Field     ;
                  CaptionML=[DAN=Udskriv pluk;
                             ENU=Print Pick];
                  ToolTipML=[DAN=Angiver, at du vil udskrive plukdokumenterne, n�r de oprettes.;
                             ENU=Specifies that you want to print the pick documents when they are created.];
                  ApplicationArea=#Warehouse;
                  SourceExpr=PrintPick }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Der er intet at h�ndtere.;ENU=There is nothing to handle.';
      Text001@1001 : TextConst 'DAN=Plukaktiviteten nr. %1 er blevet oprettet.;ENU=Pick activity no. %1 has been created.';
      Text002@1002 : TextConst 'DAN=Plukaktiviteterne nr. %1 til %2 er blevet oprettet.;ENU=Pick activities no. %1 to %2 have been created.';
      Location@1006 : Record 14;
      PickWkshLine@1004 : Record 7326;
      PickWkshLineFilter@1005 : Record 7326;
      Cust@1011 : Record 18;
      CreatePick@1038 : Codeunit 7312;
      LocationCode@1009 : Code[10];
      AssignedID@1017 : Code[50];
      FirstPickNo@1018 : Code[20];
      FirstSetPickNo@1010 : Code[20];
      LastPickNo@1019 : Code[20];
      MaxNoOfLines@1020 : Integer;
      MaxNoOfSourceDoc@1021 : Integer;
      TempNo@1024 : Integer;
      SortPick@1029 : ' ,Item,Document,Shelf No.,Due Date,Destination,Bin Ranking,Action Type';
      PerDestination@1030 : Boolean;
      PerItem@1031 : Boolean;
      PerZone@1037 : Boolean;
      PerBin@1032 : Boolean;
      PerWhseDoc@1027 : Boolean;
      PerDate@1033 : Boolean;
      PrintPick@1034 : Boolean;
      DoNotFillQtytoHandle@1003 : Boolean;
      Text003@1008 : TextConst 'DAN="Du kan kun oprette et pluk for disponible antal i %1 %2 = %3,%4 = %5,%6 = %7,%8 = %9.";ENU="You can create a Pick only for the available quantity in %1 %2 = %3,%4 = %5,%6 = %7,%8 = %9."';
      BreakbulkFilter@1007 : Boolean;
      NothingToHandleErr@1012 : TextConst 'DAN=Der er intet at h�ndtere. %1.;ENU=There is nothing to handle. %1.';

    LOCAL PROCEDURE CreateTempLine@1();
    VAR
      PickWhseActivHeader@1001 : Record 5766;
      TempWhseItemTrkgLine@1002 : TEMPORARY Record 6550;
      ItemTrackingMgt@1003 : Codeunit 6500;
      PickQty@1000 : Decimal;
      PickQtyBase@1005 : Decimal;
      TempMaxNoOfSourceDoc@1004 : Integer;
      OldFirstSetPickNo@1006 : Code[20];
      TotalQtyPickedBase@1007 : Decimal;
    BEGIN
      PickWkshLine.LOCKTABLE;
      REPEAT
        IF Location."Bin Mandatory" AND
           (NOT Location."Always Create Pick Line")
        THEN
          IF PickWkshLine.CalcAvailableQtyBase(TRUE) < PickWkshLine."Qty. to Handle" THEN
            ERROR(
              Text003,
              PickWkshLine.TABLECAPTION,PickWkshLine.FIELDCAPTION("Worksheet Template Name"),
              PickWkshLine."Worksheet Template Name",PickWkshLine.FIELDCAPTION(Name),
              PickWkshLine.Name,PickWkshLine.FIELDCAPTION("Location Code"),
              PickWkshLine."Location Code",PickWkshLine.FIELDCAPTION("Line No."),
              PickWkshLine."Line No.");

        PickWkshLine.TESTFIELD("Qty. per Unit of Measure");
        CreatePick.SetWhseWkshLine(PickWkshLine,TempNo);
        CASE PickWkshLine."Whse. Document Type" OF
          PickWkshLine."Whse. Document Type"::Shipment:
            CreatePick.SetTempWhseItemTrkgLine(
              PickWkshLine."Whse. Document No.",DATABASE::"Warehouse Shipment Line",'',0,
              PickWkshLine."Whse. Document Line No.",PickWkshLine."Location Code");
          PickWkshLine."Whse. Document Type"::Assembly:
            CreatePick.SetTempWhseItemTrkgLine(
              PickWkshLine."Whse. Document No.",DATABASE::"Assembly Line",'',0,
              PickWkshLine."Whse. Document Line No.",PickWkshLine."Location Code");
          PickWkshLine."Whse. Document Type"::"Internal Pick":
            CreatePick.SetTempWhseItemTrkgLine(
              PickWkshLine."Whse. Document No.",DATABASE::"Whse. Internal Pick Line",'',0,
              PickWkshLine."Whse. Document Line No.",PickWkshLine."Location Code");
          PickWkshLine."Whse. Document Type"::Production:
            CreatePick.SetTempWhseItemTrkgLine(
              PickWkshLine."Source No.",PickWkshLine."Source Type",'',PickWkshLine."Source Line No.",
              PickWkshLine."Source Subline No.",PickWkshLine."Location Code");
          ELSE // Movement Worksheet Line
            CreatePick.SetTempWhseItemTrkgLine(
              PickWkshLine.Name,DATABASE::"Prod. Order Component",PickWkshLine."Worksheet Template Name",
              0,PickWkshLine."Line No.",PickWkshLine."Location Code");
        END;

        PickQty := PickWkshLine."Qty. to Handle";
        PickQtyBase := PickWkshLine."Qty. to Handle (Base)";
        IF (PickQty > 0) AND
           (PickWkshLine."Destination Type" = PickWkshLine."Destination Type"::Customer)
        THEN BEGIN
          PickWkshLine.TESTFIELD("Destination No.");
          Cust.GET(PickWkshLine."Destination No.");
          Cust.CheckBlockedCustOnDocs(Cust,PickWkshLine."Source Document",FALSE,FALSE);
        END;

        CreatePick.SetCalledFromWksh(TRUE);

        WITH PickWkshLine DO
          CreatePick.CreateTempLine("Location Code","Item No.","Variant Code",
            "Unit of Measure Code",'',"To Bin Code","Qty. per Unit of Measure",PickQty,PickQtyBase);

        TotalQtyPickedBase := CreatePick.GetActualQtyPickedBase;

        // Update/delete lines
        PickWkshLine."Qty. to Handle (Base)" := PickWkshLine.CalcBaseQty(PickWkshLine."Qty. to Handle");
        IF PickWkshLine."Qty. (Base)" =
           PickWkshLine."Qty. Handled (Base)" + TotalQtyPickedBase
        THEN
          PickWkshLine.DELETE(TRUE)
        ELSE BEGIN
          PickWkshLine."Qty. Handled" := PickWkshLine."Qty. Handled" + PickWkshLine.CalcQty(TotalQtyPickedBase);
          PickWkshLine."Qty. Handled (Base)" := PickWkshLine.CalcBaseQty(PickWkshLine."Qty. Handled");
          PickWkshLine."Qty. Outstanding" := PickWkshLine.Quantity - PickWkshLine."Qty. Handled";
          PickWkshLine."Qty. Outstanding (Base)" := PickWkshLine.CalcBaseQty(PickWkshLine."Qty. Outstanding");
          PickWkshLine."Qty. to Handle" := 0;
          PickWkshLine."Qty. to Handle (Base)" := 0;
          PickWkshLine.MODIFY;
        END;
      UNTIL PickWkshLine.NEXT = 0;

      OldFirstSetPickNo := FirstSetPickNo;
      CreatePick.CreateWhseDocument(FirstSetPickNo,LastPickNo,FALSE);
      IF FirstSetPickNo = OldFirstSetPickNo THEN
        EXIT;

      IF FirstPickNo = '' THEN
        FirstPickNo := FirstSetPickNo;
      CreatePick.ReturnTempItemTrkgLines(TempWhseItemTrkgLine);
      ItemTrackingMgt.UpdateWhseItemTrkgLines(TempWhseItemTrkgLine);
      COMMIT;

      TempMaxNoOfSourceDoc := MaxNoOfSourceDoc;
      PickWhseActivHeader.SETRANGE(Type,PickWhseActivHeader.Type::Pick);
      PickWhseActivHeader.SETRANGE("No.",FirstSetPickNo,LastPickNo);
      PickWhseActivHeader.FIND('-');
      REPEAT
        IF SortPick > 0 THEN
          PickWhseActivHeader.SortWhseDoc;
        COMMIT;
        IF PrintPick THEN BEGIN
          REPORT.RUN(REPORT::"Picking List",FALSE,FALSE,PickWhseActivHeader);
          TempMaxNoOfSourceDoc -= 1;
        END;
      UNTIL ((PickWhseActivHeader.NEXT = 0) OR (TempMaxNoOfSourceDoc = 0));
    END;

    PROCEDURE SetWkshPickLine@4(VAR PickWkshLine2@1000 : Record 7326);
    BEGIN
      PickWkshLine.COPYFILTERS(PickWkshLine2);
      LocationCode := PickWkshLine2."Location Code";
    END;

    PROCEDURE GetResultMessage@2() : Boolean;
    BEGIN
      IF FirstPickNo <> '' THEN
        IF FirstPickNo = LastPickNo THEN
          MESSAGE(Text001,FirstPickNo)
        ELSE
          MESSAGE(Text002,FirstPickNo,LastPickNo);
      EXIT(FirstPickNo <> '');
    END;

    PROCEDURE InitializeReport@3(AssignedID2@1013 : Code[50];MaxNoOfLines2@1010 : Integer;MaxNoOfSourceDoc2@1009 : Integer;SortPick2@1007 : ' ,Item,Document,Shelf/Bin No.,Due Date,Ship-To,Bin Ranking,Action Type';PerDestination2@1006 : Boolean;PerItem2@1005 : Boolean;PerZone2@1004 : Boolean;PerBin2@1003 : Boolean;PerWhseDoc2@1002 : Boolean;PerDate2@1001 : Boolean;PrintPick2@1000 : Boolean;DoNotFillQtytoHandle2@1008 : Boolean;BreakbulkFilter2@1011 : Boolean);
    BEGIN
      AssignedID := AssignedID2;
      MaxNoOfLines := MaxNoOfLines2;
      MaxNoOfSourceDoc := MaxNoOfSourceDoc2;
      SortPick := SortPick2;
      PerDestination := PerDestination2;
      PerItem := PerItem2;
      PerZone := PerZone2;
      PerBin := PerBin2;
      PerWhseDoc := PerWhseDoc2;
      PerDate := PerDate2;
      PrintPick := PrintPick2;
      DoNotFillQtytoHandle := DoNotFillQtytoHandle2;
      BreakbulkFilter := BreakbulkFilter2;
    END;

    LOCAL PROCEDURE CheckPickActivity@5();
    BEGIN
      IF FirstPickNo = '' THEN
        ERROR(NothingToHandleErr,CreatePick.GetExpiredItemMessage);
    END;

    LOCAL PROCEDURE SetPickFilters@6();
    BEGIN
      IF PerItem THEN BEGIN
        PickWkshLine.SETRANGE("Item No.",PickWkshLine."Item No.");
        IF PerBin THEN
          SetPerBinFilters
        ELSE BEGIN
          IF NOT Location."Bin Mandatory" THEN
            PickWkshLineFilter.COPYFILTER("Shelf No.",PickWkshLine."Shelf No.");
          SetPerDateFilters;
        END;
        PickWkshLineFilter.COPYFILTER("Item No.",PickWkshLine."Item No.");
      END ELSE BEGIN
        PickWkshLineFilter.COPYFILTER("Item No.",PickWkshLine."Item No.");
        IF PerBin THEN
          SetPerBinFilters
        ELSE BEGIN
          IF NOT Location."Bin Mandatory" THEN
            PickWkshLineFilter.COPYFILTER("Shelf No.",PickWkshLine."Shelf No.");
          SetPerDateFilters;
        END;
      END;
    END;

    LOCAL PROCEDURE SetPerBinFilters@7();
    BEGIN
      IF NOT Location."Bin Mandatory" THEN
        PickWkshLine.SETRANGE("Shelf No.",PickWkshLine."Shelf No.");
      IF PerDate THEN BEGIN
        PickWkshLine.SETRANGE("Due Date",PickWkshLine."Due Date");
        CreateTempLine;
        PickWkshLineFilter.COPYFILTER("Due Date",PickWkshLine."Due Date");
      END ELSE BEGIN
        PickWkshLineFilter.COPYFILTER("Due Date",PickWkshLine."Due Date");
        CreateTempLine;
      END;
      IF NOT Location."Bin Mandatory" THEN
        PickWkshLineFilter.COPYFILTER("Shelf No.",PickWkshLine."Shelf No.");
    END;

    LOCAL PROCEDURE SetPerDateFilters@10();
    BEGIN
      IF PerDate THEN BEGIN
        PickWkshLine.SETRANGE("Due Date",PickWkshLine."Due Date");
        CreateTempLine;
        PickWkshLineFilter.COPYFILTER("Due Date",PickWkshLine."Due Date");
      END ELSE BEGIN
        PickWkshLineFilter.COPYFILTER("Due Date",PickWkshLine."Due Date");
        CreateTempLine;
      END;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

