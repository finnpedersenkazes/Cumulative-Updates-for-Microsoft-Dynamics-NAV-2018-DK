OBJECT Report 99001020 Carry Out Action Msg. - Plan.
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udf�r aktionsmedl. - plan.;
               ENU=Carry Out Action Msg. - Plan.];
    ProcessingOnly=Yes;
  }
  DATASET
  {
    { 3754;    ;DataItem;                    ;
               DataItemTable=Table246;
               DataItemTableView=SORTING(Worksheet Template Name,Journal Batch Name,Vendor No.,Sell-to Customer No.,Ship-to Code,Order Address Code,Currency Code,Ref. Order Type,Ref. Order Status,Ref. Order No.,Location Code,Transfer-from Code);
               ReqFilterHeadingML=[DAN=Planl�gningslinje;
                                   ENU=Planning Line];
               OnPreDataItem=BEGIN
                               LOCKTABLE;

                               SetReqLineFilters;
                               IF NOT FIND('-') THEN
                                 ERROR(Text000);

                               IF PurchOrderChoice = PurchOrderChoice::"Copy to Req. Wksh" THEN
                                 CheckCopyToWksh(ReqWkshTemp,ReqWksh);
                               IF TransOrderChoice = TransOrderChoice::"Copy to Req. Wksh" THEN
                                 CheckCopyToWksh(TransWkshTemp,TransWkshName);
                               IF ProdOrderChoice = ProdOrderChoice::"Copy to Req. Wksh" THEN
                                 CheckCopyToWksh(ProdWkshTempl,ProdWkshName);

                               Window.OPEN(Text012);
                               CheckPreconditions;
                               CounterTotal := COUNT;
                             END;

               OnAfterGetRecord=BEGIN
                                  WindowUpdate;

                                  IF NOT "Accept Action Message" THEN
                                    CurrReport.SKIP;
                                  LOCKTABLE;

                                  COMMIT;
                                  CASE "Ref. Order Type" OF
                                    "Ref. Order Type"::"Prod. Order":
                                      IF ProdOrderChoice <> ProdOrderChoice::" " THEN
                                        CarryOutActions(2,ProdOrderChoice,ProdWkshTempl,ProdWkshName);
                                    "Ref. Order Type"::Purchase:
                                      IF PurchOrderChoice = PurchOrderChoice::"Copy to Req. Wksh" THEN
                                        CarryOutActions(0,PurchOrderChoice,ReqWkshTemp,ReqWksh);
                                    "Ref. Order Type"::Transfer:
                                      IF TransOrderChoice <> TransOrderChoice::" " THEN BEGIN
                                        CarryOutAction.SetSplitTransferOrders(NOT CombineTransferOrders);
                                        CarryOutActions(1,TransOrderChoice,TransWkshTemp,TransWkshName);
                                      END;
                                    "Ref. Order Type"::Assembly:
                                      IF AsmOrderChoice <> AsmOrderChoice::" " THEN
                                        CarryOutActions(3,AsmOrderChoice,'','');
                                    ELSE
                                      CurrReport.SKIP;
                                  END;
                                  COMMIT;
                                END;

               OnPostDataItem=BEGIN
                                Window.CLOSE;

                                CarryOutAction.PrintTransferOrders;

                                IF PurchOrderChoice IN [PurchOrderChoice::"Make Purch. Orders",
                                                        PurchOrderChoice::"Make Purch. Orders & Print"]
                                THEN BEGIN
                                  SETRANGE("Accept Action Message",TRUE);

                                  IF PurchaseSuggestionExists("Requisition Line") THEN BEGIN
                                    PurchOrderHeader."Order Date" := WORKDATE;
                                    PurchOrderHeader."Posting Date" := WORKDATE;
                                    PurchOrderHeader."Expected Receipt Date" := WORKDATE;

                                    EndOrderDate := WORKDATE;

                                    PrintOrders := (PurchOrderChoice = PurchOrderChoice::"Make Purch. Orders & Print");

                                    CLEAR(ReqWkshMakeOrders);
                                    ReqWkshMakeOrders.SetCreatedDocumentBuffer(TempDocumentEntry);
                                    ReqWkshMakeOrders.Set(PurchOrderHeader,EndOrderDate,PrintOrders);
                                    IF NOT NoPlanningResiliency THEN
                                      ReqWkshMakeOrders.SetPlanningResiliency;
                                    ReqWkshMakeOrders.CarryOutBatchAction("Requisition Line");
                                    CounterFailed := CounterFailed + ReqWkshMakeOrders.GetFailedCounter;
                                  END;
                                END;

                                IF ReserveforPlannedProd THEN
                                  MESSAGE(Text010);

                                IF CounterFailed > 0 THEN
                                  IF GETLASTERRORTEXT = '' THEN
                                    MESSAGE(Text013,CounterFailed)
                                  ELSE
                                    MESSAGE(GETLASTERRORTEXT);
                              END;
                               }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnInit=BEGIN
               TransNameEnable := TRUE;
               TransTempEnable := TRUE;
               ReqNameEnable := TRUE;
               ReqTempEnable := TRUE;
             END;

      OnOpenPage=BEGIN
                   ReqTempEnable := PurchOrderChoice = PurchOrderChoice::"Copy to Req. Wksh";
                   ReqNameEnable := PurchOrderChoice = PurchOrderChoice::"Copy to Req. Wksh";
                   TransTempEnable := TransOrderChoice = TransOrderChoice::"Copy to Req. Wksh";
                   TransNameEnable := TransOrderChoice = TransOrderChoice::"Copy to Req. Wksh";
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  Name=ProductionOrder;
                  CaptionML=[DAN=Produktionsordre;
                             ENU=Production Order];
                  ToolTipML=[DAN=Angiver, at du vil oprette produktionsordrer for varen med genbestillingssystemet for Prod.ordre. Du kan v�lge at oprette en planlagt eller fastlagt produktionsordre, og du kan f� de nye ordredokumenter udskrevet.;
                             ENU=Specifies that you want to create production orders for item with the Prod. Order replenishment system. You can select to create either planned or firm planned production order, and you can have the new order documents printed.];
                  OptionCaptionML=[DAN=" ,Planlagt,Fastlagt,Fastlagt og udskriv";
                                   ENU=" ,Planned,Firm Planned,Firm Planned & Print"];
                  ApplicationArea=#Planning;
                  SourceExpr=ProdOrderChoice }

      { 14  ;2   ;Field     ;
                  CaptionML=[DAN=Montageordre;
                             ENU=Assembly Order];
                  ToolTipML=[DAN=Angiver de montageordrer, der oprettes for varer med genbestillingsmetoden Montage.;
                             ENU=Specifies the assembly orders that are created for items with the Assembly replenishment method.];
                  OptionCaptionML=[DAN=" ,Opret montageordrer,Opret montageordrer & udskriv";
                                   ENU=" ,Make Assembly Orders,Make Assembly Orders & Print"];
                  ApplicationArea=#Assembly;
                  SourceExpr=AsmOrderChoice }

      { 2   ;2   ;Field     ;
                  Name=PurchaseOrder;
                  CaptionML=[DAN=K�bsordre;
                             ENU=Purchase Order];
                  ToolTipML=[DAN=Angiver, at du vil oprette k�bsordrer for varer med genbestillingsmetoden for K�b. Du kan f� de nye ordredokumenter udskrevet.;
                             ENU=Specifies that you want to create purchase orders for items with the Purchase replenishment method. You can have the new order documents printed.];
                  OptionCaptionML=[DAN=" ,Opret k�bsordrer,Opret k�bsordrer og udskriv,Kopi�r til indk.kld.";
                                   ENU=" ,Make Purch. Orders,Make Purch. Orders & Print,Copy to Req. Wksh"];
                  ApplicationArea=#Planning;
                  SourceExpr=PurchOrderChoice;
                  OnValidate=BEGIN
                               ReqTempEnable := PurchOrderChoice = PurchOrderChoice::"Copy to Req. Wksh";
                               ReqNameEnable := PurchOrderChoice = PurchOrderChoice::"Copy to Req. Wksh";
                             END;
                              }

      { 9   ;2   ;Group     ;
                  GroupType=GridLayout;
                  Layout=Rows }

      { 13  ;3   ;Field     ;
                  ApplicationArea=#Planning;
                  Visible=FALSE }

      { 10  ;3   ;Group     ;
                  CaptionML=[DAN=Indk�bskladde;
                             ENU=Req. Worksheet];
                  GroupType=Group }

      { 11  ;4   ;Field     ;
                  Name=ReqTemp;
                  CaptionML=[DAN=Indk�bskladdetype;
                             ENU=Req. Wksh. Template];
                  ToolTipML=[DAN=Angiver, at du vil kopiere planl�gningslinjeforslagene for overflytningsordrer til denne indk�bskladdetype.;
                             ENU=Specifies that you want to copy the planning line proposals for transfer orders to this requisition worksheet template.];
                  ApplicationArea=#Planning;
                  SourceExpr=ReqWkshTemp;
                  TableRelation="Req. Wksh. Template";
                  Enabled=ReqTempEnable;
                  OnValidate=BEGIN
                               ReqWksh := '';
                             END;

                  OnLookup=BEGIN
                             IF PAGE.RUNMODAL(PAGE::"Req. Worksheet Templates",ReqWkshTmpl) = ACTION::LookupOK THEN BEGIN
                               Text := ReqWkshTmpl.Name;
                               EXIT(TRUE);
                             END;
                             EXIT(FALSE);
                           END;
                            }

      { 12  ;4   ;Field     ;
                  Name=ReqName;
                  CaptionML=[DAN=Indk�bskladdenavn;
                             ENU=Req. Wksh. Name];
                  ToolTipML=[DAN=Angiver, at du vil kopiere planl�gningslinjeforslagene for overflytningsordrer til dette indk�bskladdenavn.;
                             ENU=Specifies that you want to copy the planning line proposals for transfer orders to this requisition worksheet name.];
                  ApplicationArea=#Planning;
                  SourceExpr=ReqWksh;
                  TableRelation="Requisition Wksh. Name".Name;
                  Enabled=ReqNameEnable;
                  OnLookup=BEGIN
                             ReqWkshName.SETFILTER("Worksheet Template Name",ReqWkshTemp);
                             IF PAGE.RUNMODAL(PAGE::"Req. Wksh. Names",ReqWkshName) = ACTION::LookupOK THEN BEGIN
                               Text := ReqWkshName.Name;
                               EXIT(TRUE);
                             END;
                             EXIT(FALSE);
                           END;
                            }

      { 6   ;2   ;Field     ;
                  Name=TransOrderChoice;
                  CaptionML=[DAN=Overflytningsordre;
                             ENU=Transfer Order];
                  ToolTipML=[DAN=Angiver, at du vil oprette overflytningsordrer for varer med genbestillingsmetoden for Overf�rsel p� lagerkortet. Du kan f� de nye ordredokumenter udskrevet.;
                             ENU=Specifies that you want to create transfer orders for items with the Transfer replenishment method in the SKU card. You can have the new order documents printed.];
                  OptionCaptionML=[DAN=" ,Opret overfl.ordrer,Opret overfl.ordrer og udskriv,Kopier til indk.kld.";
                                   ENU=" ,Make Trans. Orders,Make Trans. Orders & Print,Copy to Req. Wksh"];
                  ApplicationArea=#Location;
                  SourceExpr=TransOrderChoice;
                  OnValidate=BEGIN
                               TransTempEnable := TransOrderChoice = TransOrderChoice::"Copy to Req. Wksh";
                               TransNameEnable := TransOrderChoice = TransOrderChoice::"Copy to Req. Wksh";
                             END;
                              }

      { 7   ;2   ;Group     ;
                  GroupType=GridLayout;
                  Layout=Rows }

      { 8   ;3   ;Field     ;
                  ApplicationArea=#Planning;
                  Visible=FALSE }

      { 3   ;3   ;Group     ;
                  CaptionML=[DAN=Indk�bskladde;
                             ENU=Req. Worksheet];
                  GroupType=Group }

      { 15  ;4   ;Field     ;
                  Name=TransTemp;
                  CaptionML=[DAN=Indk�bskladdetype;
                             ENU=Req. Wksh. Template];
                  ToolTipML=[DAN=Angiver, at du vil kopiere planl�gningslinjeforslagene for overflytningsordrer til denne indk�bskladdetype.;
                             ENU=Specifies that you want to copy the planning line proposals for transfer orders to this requisition worksheet template.];
                  ApplicationArea=#Planning;
                  SourceExpr=TransWkshTemp;
                  TableRelation="Req. Wksh. Template";
                  Enabled=TransTempEnable;
                  OnValidate=BEGIN
                               TransWkshName := '';
                             END;

                  OnLookup=BEGIN
                             IF PAGE.RUNMODAL(PAGE::"Req. Worksheet Templates",ReqWkshTmpl) = ACTION::LookupOK THEN BEGIN
                               Text := ReqWkshTmpl.Name;
                               EXIT(TRUE);
                             END;
                             EXIT(FALSE);
                           END;
                            }

      { 16  ;4   ;Field     ;
                  Name=TransName;
                  CaptionML=[DAN=Indk�bskladdenavn;
                             ENU=Req. Wksh. Name];
                  ToolTipML=[DAN=Angiver, at du vil kopiere planl�gningslinjeforslagene for overflytningsordrer til dette indk�bskladdenavn.;
                             ENU=Specifies that you want to copy the planning line proposals for transfer orders to this requisition worksheet name.];
                  ApplicationArea=#Planning;
                  SourceExpr=TransWkshName;
                  TableRelation="Requisition Wksh. Name".Name;
                  Enabled=TransNameEnable;
                  OnLookup=BEGIN
                             ReqWkshName.SETFILTER("Worksheet Template Name",TransWkshTemp);
                             IF PAGE.RUNMODAL(PAGE::"Req. Wksh. Names",ReqWkshName) = ACTION::LookupOK THEN BEGIN
                               Text := ReqWkshName.Name;
                               EXIT(TRUE);
                             END;
                             EXIT(FALSE);
                           END;
                            }

      { 5   ;2   ;Group     ;
                  GroupType=GridLayout;
                  Layout=Rows }

      { 18  ;3   ;Group     ;
                  CaptionML=[DAN=Kombiner overf�rselsordrer;
                             ENU=Combine Transfer Orders];
                  GroupType=Group }

      { 4   ;4   ;Field     ;
                  Name=CombineTransferOrders;
                  ApplicationArea=#Location;
                  SourceExpr=CombineTransferOrders;
                  ShowCaption=No }

      { 17  ;2   ;Field     ;
                  CaptionML=[DAN=Stop, og vis f�rste fejl;
                             ENU=Stop and Show First Error];
                  ToolTipML=[DAN=Angiver, om der skal stoppes, s� snart der opst�r en fejl i k�rslen.;
                             ENU=Specifies whether to stop as soon as the batch job encounters an error.];
                  ApplicationArea=#Planning;
                  SourceExpr=NoPlanningResiliency }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1029 : TextConst 'DAN=Der er ingen planl�gningslinjer at oprette ordrer for.;ENU=There are no planning lines to make orders for.';
      Text007@1000 : TextConst 'DAN="Denne skabelon og kladde er aktive. ";ENU="This template and worksheet are currently active. "';
      Text008@1001 : TextConst 'DAN=Du skal v�lge en anden skabelon eller et andet kladdenavn at kopiere til.;ENU=You must select a different template name or worksheet name to copy to.';
      PurchOrderHeader@1017 : Record 38;
      ReqWkshTmpl@1002 : Record 244;
      ReqWkshName@1003 : Record 245;
      ReqLineFilters@1026 : Record 246;
      TempDocumentEntry@1020 : TEMPORARY Record 265;
      CarryOutAction@1005 : Codeunit 99000813;
      ReqWkshMakeOrders@1018 : Codeunit 333;
      Window@1035 : Dialog;
      ReqWkshTemp@1007 : Code[10];
      ReqWksh@1008 : Code[10];
      TransWkshTemp@1009 : Code[10];
      TransWkshName@1010 : Code[10];
      ProdWkshTempl@1028 : Code[10];
      ProdWkshName@1027 : Code[10];
      CurrReqWkshTemp@1015 : Code[10];
      CurrReqWkshName@1014 : Code[10];
      ProdOrderChoice@1011 : ' ,Planned,Firm Planned,Firm Planned & Print,Copy to Req. Wksh';
      PurchOrderChoice@1012 : ' ,Make Purch. Orders,Make Purch. Orders & Print,Copy to Req. Wksh';
      TransOrderChoice@1013 : ' ,Make Trans. Orders,Make Trans. Orders & Print,Copy to Req. Wksh';
      Text009@1016 : TextConst 'DAN=Du skal v�lge en kladde at kopiere til;ENU=You must select a worksheet to copy to';
      AsmOrderChoice@1004 : ' ,Make Assembly Orders,Make Assembly Orders & Print';
      PrintOrders@1019 : Boolean;
      CombineTransferOrders@1006 : Boolean;
      ReserveforPlannedProd@1033 : Boolean;
      NoPlanningResiliency@1031 : Boolean;
      Text010@1030 : TextConst 'DAN=Komponenter blev ikke reserveret for ordrer med status Planlagt.;ENU=Components were not reserved for orders with status Planned.';
      Text011@1032 : TextConst 'DAN=Du skal lave en ordre for b�de linje %1 og %2, fordi de er knyttet til hinanden.;ENU=You must make order for both line %1 and %2 because they are associated.';
      Text012@1034 : TextConst 'DAN=Udf�rer handlinger    #1########## @2@@@@@@@@@@@@@;ENU=Carrying Out Actions  #1########## @2@@@@@@@@@@@@@';
      Counter@1036 : Integer;
      CounterTotal@1037 : Integer;
      CounterFailed@1038 : Integer;
      Text013@1039 : TextConst 'DAN=Ikke alle indk�bskladdelinjer blev udf�rt.\I alt %1 linjer blev ikke udf�rt som f�lge af fejl.;ENU=Not all Requisition Lines were carried out.\A total of %1 lines were not carried out because of errors encountered.';
      EndOrderDate@1022 : Date;
      ReqTempEnable@19040225 : Boolean INDATASET;
      ReqNameEnable@19051726 : Boolean INDATASET;
      TransTempEnable@19079481 : Boolean INDATASET;
      TransNameEnable@19074510 : Boolean INDATASET;

    LOCAL PROCEDURE CarryOutActions@20(SourceType@1004 : 'Purchase,Transfer,Production,Assembly';Choice@1002 : Option;WkshTempl@1001 : Code[10];WkshName@1000 : Code[10]);
    BEGIN
      IF NoPlanningResiliency THEN BEGIN
        CarryOutAction.SetTryParameters(SourceType,Choice,WkshTempl,WkshName);
        CarryOutAction.RUN("Requisition Line");
      END ELSE
        IF NOT CarryOutAction.TryCarryOutAction(SourceType,"Requisition Line",Choice,WkshTempl,WkshName) THEN
          CounterFailed := CounterFailed + 1;
    END;

    PROCEDURE SetCreatedDocumentBuffer@12(VAR TempDocumentEntryNew@1000 : TEMPORARY Record 265);
    BEGIN
      TempDocumentEntry.COPY(TempDocumentEntryNew,TRUE);
      CarryOutAction.SetCreatedDocumentBuffer(TempDocumentEntryNew);
    END;

    [External]
    PROCEDURE SetReqWkshLine@1(VAR CurrentReqLine@1000 : Record 246);
    BEGIN
      CurrReqWkshTemp := CurrentReqLine."Worksheet Template Name";
      CurrReqWkshName := CurrentReqLine."Journal Batch Name";
      ReqLineFilters.COPY(CurrentReqLine);
    END;

    [External]
    PROCEDURE SetDemandOrder@3(VAR ReqLine@1005 : Record 246;MfgUserTempl@1000 : Record 5525);
    BEGIN
      SetReqWkshLine(ReqLine);

      InitializeRequest(
        MfgUserTempl."Create Production Order",
        MfgUserTempl."Create Purchase Order",
        MfgUserTempl."Create Transfer Order",
        MfgUserTempl."Create Assembly Order");

      ReqWkshTemp := MfgUserTempl."Purchase Req. Wksh. Template";
      ReqWksh := MfgUserTempl."Purchase Wksh. Name";
      ProdWkshTempl := MfgUserTempl."Prod. Req. Wksh. Template";
      ProdWkshName := MfgUserTempl."Prod. Wksh. Name";
      TransWkshTemp := MfgUserTempl."Transfer Req. Wksh. Template";
      TransWkshName := MfgUserTempl."Transfer Wksh. Name";

      WITH ReqLineFilters DO
        CASE MfgUserTempl."Make Orders" OF
          MfgUserTempl."Make Orders"::"The Active Line":
            BEGIN
              ReqLineFilters := ReqLine;
              SETRECFILTER;
            END;
          MfgUserTempl."Make Orders"::"The Active Order":
            BEGIN
              SETCURRENTKEY(
                "User ID","Demand Type","Demand Subtype","Demand Order No.","Demand Line No.","Demand Ref. No.");
              COPYFILTERS(ReqLine);
              SETRANGE("Demand Type",ReqLine."Demand Type");
              SETRANGE("Demand Subtype",ReqLine."Demand Subtype");
              SETRANGE("Demand Order No.",ReqLine."Demand Order No.");
            END;
          MfgUserTempl."Make Orders"::"All Lines":
            BEGIN
              SETCURRENTKEY(
                "User ID","Worksheet Template Name","Journal Batch Name","Line No.");
              COPY(ReqLine);
            END;
        END;
    END;

    [External]
    PROCEDURE InitializeRequest@2(NewProdOrderChoice@1002 : Option;NewPurchOrderChoice@1001 : Option;NewTransOrderChoice@1000 : Option;NewAsmOrderChoice@1003 : Option);
    BEGIN
      ProdOrderChoice := NewProdOrderChoice;
      PurchOrderChoice := NewPurchOrderChoice;
      TransOrderChoice := NewTransOrderChoice;
      AsmOrderChoice := NewAsmOrderChoice;
    END;

    [External]
    PROCEDURE InitializeRequest2@11(NewProdOrderChoice@1006 : Option;NewPurchOrderChoice@1005 : Option;NewTransOrderChoice@1004 : Option;NewAsmOrderChoice@1007 : Option;NewReqWkshTemp@1002 : Code[10];NewReqWksh@1001 : Code[10];NewTransWkshTemp@1000 : Code[10];NewTransWkshName@1003 : Code[10]);
    BEGIN
      InitializeRequest(NewProdOrderChoice,NewPurchOrderChoice,NewTransOrderChoice,NewAsmOrderChoice);
      ReqWkshTemp := NewReqWkshTemp;
      ReqWksh := NewReqWksh;
      TransWkshTemp := NewTransWkshTemp;
      TransWkshName := NewTransWkshName;
    END;

    [External]
    LOCAL PROCEDURE SetReqLineFilters@5();
    BEGIN
      WITH "Requisition Line" DO BEGIN
        IF ReqLineFilters.GETFILTERS <> '' THEN
          COPYFILTERS(ReqLineFilters);
        SETRANGE("Worksheet Template Name",CurrReqWkshTemp);
        SETRANGE("Journal Batch Name",CurrReqWkshName);
        SETRANGE(Type,Type::Item);
        SETFILTER("Action Message",'<>%1',"Action Message"::" ");
      END;
    END;

    LOCAL PROCEDURE CheckCopyToWksh@4(ToReqWkshTempl@1000 : Code[10];ToReqWkshName@1001 : Code[10]);
    BEGIN
      IF (ToReqWkshTempl <> '') AND
         (CurrReqWkshTemp = ToReqWkshTempl) AND
         (CurrReqWkshName = ToReqWkshName)
      THEN
        ERROR(Text007 + Text008);

      IF (ToReqWkshTempl = '') OR (ToReqWkshName = '') THEN
        ERROR(Text009);
    END;

    LOCAL PROCEDURE CheckPreconditions@6();
    BEGIN
      WITH "Requisition Line" DO
        REPEAT
          CheckLine;
        UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE CheckLine@7();
    VAR
      SalesLine@1000 : Record 37;
      ProdOrderComp@1001 : Record 5407;
      ServLine@1006 : Record 5902;
      JobPlanningLine@1007 : Record 1003;
      AsmLine@1002 : Record 901;
      ReqLine2@1003 : Record 246;
    BEGIN
      WITH "Requisition Line" DO BEGIN
        IF "Planning Line Origin" <> "Planning Line Origin"::"Order Planning" THEN
          EXIT;

        CheckAssociations("Requisition Line");

        IF "Planning Level" > 0 THEN
          EXIT;

        IF "Replenishment System" IN ["Replenishment System"::Purchase,
                                      "Replenishment System"::Transfer]
        THEN
          TESTFIELD("Supply From");

        CASE "Demand Type" OF
          DATABASE::"Sales Line":
            BEGIN
              SalesLine.GET("Demand Subtype","Demand Order No.","Demand Line No.");
              SalesLine.TESTFIELD(Type,SalesLine.Type::Item);
              IF NOT (("Demand Date" = WORKDATE) AND (SalesLine."Shipment Date" IN [0D,WORKDATE])) THEN
                TESTFIELD("Demand Date",SalesLine."Shipment Date");
              TESTFIELD("No.",SalesLine."No.");
              TESTFIELD("Qty. per UOM (Demand)",SalesLine."Qty. per Unit of Measure");
              TESTFIELD("Variant Code",SalesLine."Variant Code");
              TESTFIELD("Location Code",SalesLine."Location Code");
              SalesLine.CALCFIELDS("Reserved Qty. (Base)");
              TESTFIELD(
                "Demand Quantity (Base)",
                -SalesLine.SignedXX(SalesLine."Outstanding Qty. (Base)" - SalesLine."Reserved Qty. (Base)"))
            END;
          DATABASE::"Prod. Order Component":
            BEGIN
              ProdOrderComp.GET("Demand Subtype","Demand Order No.","Demand Line No.","Demand Ref. No.");
              TESTFIELD("No.",ProdOrderComp."Item No.");
              IF NOT (("Demand Date" = WORKDATE) AND (ProdOrderComp."Due Date" IN [0D,WORKDATE])) THEN
                TESTFIELD("Demand Date",ProdOrderComp."Due Date");
              TESTFIELD("Qty. per UOM (Demand)",ProdOrderComp."Qty. per Unit of Measure");
              TESTFIELD("Variant Code",ProdOrderComp."Variant Code");
              TESTFIELD("Location Code",ProdOrderComp."Location Code");
              ProdOrderComp.CALCFIELDS("Reserved Qty. (Base)");
              TESTFIELD(
                "Demand Quantity (Base)",
                ProdOrderComp."Remaining Qty. (Base)" - ProdOrderComp."Reserved Qty. (Base)");
              IF (ProdOrderChoice = ProdOrderChoice::Planned) AND Reserve THEN
                ReserveforPlannedProd := TRUE;
            END;
          DATABASE::"Service Line":
            BEGIN
              ServLine.GET("Demand Subtype","Demand Order No.","Demand Line No.");
              ServLine.TESTFIELD(Type,ServLine.Type::Item);
              IF NOT (("Demand Date" = WORKDATE) AND (ServLine."Needed by Date" IN [0D,WORKDATE])) THEN
                TESTFIELD("Demand Date",ServLine."Needed by Date");
              TESTFIELD("No.",ServLine."No.");
              TESTFIELD("Qty. per UOM (Demand)",ServLine."Qty. per Unit of Measure");
              TESTFIELD("Variant Code",ServLine."Variant Code");
              TESTFIELD("Location Code",ServLine."Location Code");
              ServLine.CALCFIELDS("Reserved Qty. (Base)");
              TESTFIELD(
                "Demand Quantity (Base)",
                -ServLine.SignedXX(ServLine."Outstanding Qty. (Base)" - ServLine."Reserved Qty. (Base)"))
            END;
          DATABASE::"Job Planning Line":
            BEGIN
              JobPlanningLine.SETRANGE("Job Contract Entry No.","Demand Line No.");
              JobPlanningLine.FINDFIRST;
              JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::Item);
              JobPlanningLine.TESTFIELD("Job No.");
              JobPlanningLine.TESTFIELD(Status,JobPlanningLine.Status::Order);
              IF NOT (("Demand Date" = WORKDATE) AND (JobPlanningLine."Planning Date" IN [0D,WORKDATE])) THEN
                TESTFIELD("Demand Date",JobPlanningLine."Planning Date");
              TESTFIELD("No.",JobPlanningLine."No.");
              TESTFIELD("Qty. per UOM (Demand)",JobPlanningLine."Qty. per Unit of Measure");
              TESTFIELD("Variant Code",JobPlanningLine."Variant Code");
              TESTFIELD("Location Code",JobPlanningLine."Location Code");
              JobPlanningLine.CALCFIELDS("Reserved Qty. (Base)");
              TESTFIELD(
                "Demand Quantity (Base)",
                JobPlanningLine."Remaining Qty. (Base)" - JobPlanningLine."Reserved Qty. (Base)")
            END;
          DATABASE::"Assembly Line":
            BEGIN
              AsmLine.GET("Demand Subtype","Demand Order No.","Demand Line No.");
              AsmLine.TESTFIELD(Type,AsmLine.Type::Item);
              IF NOT (("Demand Date" = WORKDATE) AND (AsmLine."Due Date" IN [0D,WORKDATE])) THEN
                TESTFIELD("Demand Date",AsmLine."Due Date");
              TESTFIELD("No.",AsmLine."No.");
              TESTFIELD("Qty. per UOM (Demand)",AsmLine."Qty. per Unit of Measure");
              TESTFIELD("Variant Code",AsmLine."Variant Code");
              TESTFIELD("Location Code",AsmLine."Location Code");
              AsmLine.CALCFIELDS("Reserved Qty. (Base)");
              TESTFIELD(
                "Demand Quantity (Base)",
                -AsmLine.SignedXX(AsmLine."Remaining Quantity (Base)" - AsmLine."Reserved Qty. (Base)"))
            END;
        END;

        ReqLine2.SETCURRENTKEY(
          "User ID","Demand Type","Demand Subtype","Demand Order No.","Demand Line No.","Demand Ref. No.");
        ReqLine2.SETFILTER("User ID",'<>%1',USERID);
        ReqLine2.SETRANGE("Demand Type","Demand Type");
        ReqLine2.SETRANGE("Demand Subtype","Demand Subtype");
        ReqLine2.SETRANGE("Demand Order No.","Demand Order No.");
        ReqLine2.SETRANGE("Demand Line No.","Demand Line No.");
        ReqLine2.SETRANGE("Demand Ref. No.","Demand Ref. No.");
        ReqLine2.DELETEALL(TRUE);
      END;
    END;

    LOCAL PROCEDURE CheckAssociations@8(VAR ReqLine@1000 : Record 246);
    VAR
      ReqLine2@1002 : Record 246;
      ReqLine3@1001 : Record 246;
    BEGIN
      WITH ReqLine DO BEGIN
        ReqLine3.COPY(ReqLine);
        ReqLine2 := ReqLine;

        IF ReqLine2."Planning Level" > 0 THEN
          WHILE (ReqLine2.NEXT(-1) <> 0) AND (ReqLine2."Planning Level" > 0) DO;

        REPEAT
          ReqLine3 := ReqLine2;
          IF NOT ReqLine3.FIND THEN
            ERROR(Text011,"Line No.",ReqLine2."Line No.");
        UNTIL (ReqLine2.NEXT = 0) OR (ReqLine2."Planning Level" = 0)
      END;
    END;

    LOCAL PROCEDURE WindowUpdate@9();
    BEGIN
      Counter := Counter + 1;
      Window.UPDATE(1,"Requisition Line"."No.");
      Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
    END;

    LOCAL PROCEDURE PurchaseSuggestionExists@10(VAR RequisitionLine@1001 : Record 246) : Boolean;
    VAR
      StopLoop@1000 : Boolean;
      PurchaseExists@1002 : Boolean;
    BEGIN
      WITH RequisitionLine DO BEGIN
        IF FINDSET THEN
          REPEAT
            PurchaseExists := "Ref. Order Type" = "Ref. Order Type"::Purchase;
            IF NOT PurchaseExists THEN
              StopLoop := NEXT = 0
            ELSE
              StopLoop := TRUE;
          UNTIL StopLoop;
        IF PurchaseExists THEN
          SETRANGE("Ref. Order Type","Ref. Order Type"::Purchase);
      END;
      EXIT(PurchaseExists);
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

