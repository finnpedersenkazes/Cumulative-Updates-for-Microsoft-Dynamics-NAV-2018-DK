OBJECT Page 5793 Source Documents
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Kildedokumenter;
               ENU=Source Documents];
    SourceTable=Table5765;
    SourceTableView=SORTING(Type,Location Code,Completely Handled,Document Status,Expected Receipt Date,Shipment Date,Source Document,Source No.);
    DataCaptionFields=Type,Location Code;
    PageType=List;
    OnInit=BEGIN
             ShipmentDateVisible := TRUE;
             ExpectedReceiptDateVisible := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       UpdateVisible;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 25      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p�g�ldende record p� bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=EditLines;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PurchHeader@1001 : Record 38;
                                 SalesHeader@1002 : Record 36;
                                 TransHeader@1003 : Record 5740;
                                 ProdOrder@1004 : Record 5405;
                                 ServiceHeader@1005 : Record 5900;
                               BEGIN
                                 CASE "Source Document" OF
                                   "Source Document"::"Purchase Order":
                                     BEGIN
                                       PurchHeader.GET("Source Subtype","Source No.");
                                       PAGE.RUN(PAGE::"Purchase Order",PurchHeader);
                                     END;
                                   "Source Document"::"Purchase Return Order":
                                     BEGIN
                                       PurchHeader.GET("Source Subtype","Source No.");
                                       PAGE.RUN(PAGE::"Purchase Return Order",PurchHeader);
                                     END;
                                   "Source Document"::"Sales Order":
                                     BEGIN
                                       SalesHeader.GET("Source Subtype","Source No.");
                                       PAGE.RUN(PAGE::"Sales Order",SalesHeader);
                                     END;
                                   "Source Document"::"Sales Return Order":
                                     BEGIN
                                       SalesHeader.GET("Source Subtype","Source No.");
                                       PAGE.RUN(PAGE::"Sales Return Order",SalesHeader);
                                     END;
                                   "Source Document"::"Inbound Transfer","Source Document"::"Outbound Transfer":
                                     BEGIN
                                       TransHeader.GET("Source No.");
                                       PAGE.RUN(PAGE::"Transfer Order",TransHeader);
                                     END;
                                   "Source Document"::"Prod. Consumption","Source Document"::"Prod. Output":
                                     BEGIN
                                       ProdOrder.GET("Source Subtype","Source No.");
                                       PAGE.RUN(PAGE::"Released Production Order",ProdOrder);
                                     END;
                                   "Source Document"::"Service Order":
                                     BEGIN
                                       ServiceHeader.GET("Source Subtype","Source No.");
                                       PAGE.RUN(PAGE::"Service Order",ServiceHeader);
                                     END;
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokationskode, som bestillingslinjen er tilknyttet.;
                           ENU=Specifies the location code to which the request line is linked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor modtagelsen af varerne forventes.;
                           ENU=Specifies the date when receipt of the items is expected.];
                ApplicationArea=#Warehouse;
                SourceExpr="Expected Receipt Date";
                Visible=ExpectedReceiptDateVisible }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r varerne p� bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en �nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipment Date";
                Visible=ShipmentDateVisible }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den l�g-p�-lager-aktivitet eller det pluk, der er oprettet ud fra lageranmodningen.;
                           ENU=Specifies the number of the inventory put-away or pick that was created from this warehouse request.];
                ApplicationArea=#Warehouse;
                SourceExpr="Put-away / Pick No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr�rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den destinationstype, som er knyttet til lageranmodningen, er en debitor eller kreditor.;
                           ENU=Specifies whether the type of destination associated with the warehouse request is a customer or a vendor.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret eller koden for den debitor eller kreditor, som vedr�rer lageranmodningen.;
                           ENU=Specifies the number or code of the customer or vendor related to the warehouse request.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit�r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Agent Code" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver afsendelsesadviset, som indeholder oplysninger om, hvorvidt delleverancer er acceptable.;
                           ENU=Specifies the shipping advice, which informs whether partial deliveries are acceptable.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Advice" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ExpectedReceiptDateVisible@19074269 : Boolean INDATASET;
      ShipmentDateVisible@19011539 : Boolean INDATASET;

    [External]
    PROCEDURE GetResult@1(VAR WhseReq@1000 : Record 5765);
    BEGIN
      CurrPage.SETSELECTIONFILTER(WhseReq);
    END;

    LOCAL PROCEDURE UpdateVisible@2();
    BEGIN
      ExpectedReceiptDateVisible := Type = Type::Inbound;
      ShipmentDateVisible := Type = Type::Outbound;
    END;

    BEGIN
    END.
  }
}

