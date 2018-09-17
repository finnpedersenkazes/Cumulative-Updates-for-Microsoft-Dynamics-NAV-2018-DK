OBJECT Page 131 Posted Sales Shpt. Subform
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
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table111;
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInit=VAR
             ApplicationAreaSetup@1008 : Record 9178;
           BEGIN
             IsFoundation := ApplicationAreaSetup.IsFoundationEnabled;
           END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1903098504;2 ;Action    ;
                      CaptionML=[DAN=Ordresp&oring;
                                 ENU=Order Tra&cking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den tilsvarende eftersp›rgsel. P† denne m†de kan du finde den oprindelige foresp›rgsel, der oprettede en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Advanced;
                      Image=OrderTracking;
                      OnAction=BEGIN
                                 ShowTracking;
                               END;
                                }
      { 1902740304;2 ;Action    ;
                      Name=UndoShipment;
                      CaptionML=[DAN=&Annuller leverance;
                                 ENU=&Undo Shipment];
                      ToolTipML=[DAN=Tr‘k linjen fra leverancen. Det er nyttigt, hvis du vil foretage rettelser, fordi linjen ikke bliver slettet. Du kan foretage ‘ndringer og bogf›re den igen.;
                                 ENU=Withdraw the line from the shipment. This is useful for making corrections, because the line is not deleted. You can make changes and post it again.];
                      ApplicationArea=#Basic,#Suite;
                      Image=UndoShipment;
                      OnAction=BEGIN
                                 UndoShipmentPosting;
                               END;
                                }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1903100004;2 ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1901092104;2 ;Action    ;
                      Name=Comments;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      Image=ViewComments;
                      OnAction=BEGIN
                                 ShowLineComments;
                               END;
                                }
      { 1905987604;2 ;Action    ;
                      Name=ItemTrackingEntries;
                      CaptionML=[DAN=Varesporingspos&ter;
                                 ENU=Item &Tracking Entries];
                      ToolTipML=[DAN=Vis serie- eller lotnumre, der er tildelt til varer.;
                                 ENU=View serial or lot numbers that are assigned to items.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLedger;
                      OnAction=BEGIN
                                 ShowItemTrackingLines;
                               END;
                                }
      { 3       ;2   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=Montage efter ordre;
                                 ENU=Assemble-to-Order];
                      ToolTipML=[DAN=Vis den tilknyttede montageordre, hvis leverancen var til et ordremontagesalg.;
                                 ENU=View the linked assembly order if the shipment was for an assemble-to-order sale.];
                      ApplicationArea=#Assembly;
                      OnAction=BEGIN
                                 ShowAsmToOrder;
                               END;
                                }
      { 1900609704;2 ;Action    ;
                      Name=ItemInvoiceLines;
                      CaptionML=[DAN=Varefaktura&linjer;
                                 ENU=Item Invoice &Lines];
                      ToolTipML=[DAN="Vis bogf›rte salgsfakturalinjer for varen. ";
                                 ENU="View posted sales invoice lines for the item. "];
                      ApplicationArea=#Advanced;
                      Image=ItemInvoice;
                      OnAction=BEGIN
                                 PageShowItemSalesInvLines;
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
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#Advanced;
                SourceExpr=Type }

    { 37  ;2   ;Field     ;
                Name=FilteredTypeField;
                CaptionML=[DAN=Type;
                           ENU=Type];
                ToolTipML=[DAN=Angiver typen for den transaktion, der blev bogf›rt med linjen.;
                           ENU=Specifies the type of transaction that was posted with the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=FormatType;
                Visible=IsFoundation }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dine og din kreditors og debitors varenummer, vil dette nummer tilsides‘tte standardvarenummeret, n†r du angiver krydsreferencenummeret p† et salgs- eller k›bsbilag.;
                           ENU=Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor's or customer's item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cross-Reference No.";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af recorden.;
                           ENU=Specifies a description of the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren p† salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal angives p† linjen.;
                           ENU=Specifies the number of units of the item specified on the line.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=Quantity }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der allerede er blevet bogf›rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Quantity Invoiced" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den leverede vare, der er bogf›rt som leveret, men som endnu ikke er bogf›rt som faktureret.;
                           ENU=Specifies the quantity of the shipped item that has been posted as shipped but that has not yet been posted as invoiced.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Qty. Shipped Not Invoiced";
                Visible=FALSE;
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Indeholder den dato, hvor debitoren har ›nsket varerne leveret.;
                           ENU=Specifies the date that the customer has asked for the order to be delivered.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Requested Delivery Date";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du har lovet at levere ordren som resultat af funktionen Beregning af leveringstid.;
                           ENU=Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.];
                ApplicationArea=#Advanced;
                SourceExpr="Promised Delivery Date";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den planlagte dato, hvor leverancen leveres p† debitorens adresse. Hvis debitoren anmoder om en leveringsdato, beregner programmet, om varerne er disponible for levering p† denne dato. Hvis varerne er disponible, er den planlagte leveringsdato den samme som den anmodede leveringsdato. Hvis ikke, beregner programmet den dato, hvor varerne er disponible for levering, og angiver denne dato i feltet Planlagt leveringsdato.;
                           ENU=Specifies the planned date that the shipment will be delivered at the customer's address. If the customer requests a delivery date, the program calculates whether the items will be available for delivery on this date. If the items are available, the planned delivery date will be the same as the requested delivery date. If not, the program calculates the date that the items are available for delivery and enters this date in the Planned Delivery Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Planned Delivery Date" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor leverancen skal sendes fra lageret. Hvis debitoren anmoder om en leveringsdato, beregner programmet den planlagte leveringsdato ved at tr‘kke fragttiden fra den anmodede leveringsdato. Hvis debitoren ikke anmoder om en leveringsdato, eller den anmodede leveringsdato ikke kan opfyldes, beregner programmet indholdet af dette felt ved at tilf›je fragttiden til leveringsdatoen.;
                           ENU=Specifies the date that the shipment should ship from the warehouse. If the customer requests a delivery date, the program calculates the planned shipment date by subtracting the shipping time from the requested delivery date. If the customer does not request a delivery date or the requested delivery date cannot be met, the program calculates the content of this field by adding the shipment time to the shipping date.];
                ApplicationArea=#Advanced;
                SourceExpr="Planned Shipment Date" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Date";
                Visible=TRUE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid der g†r, fra varerne er sendt fra lageret, til de er leveret.;
                           ENU=Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Time";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Advanced;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en datoformel for den tid, det tager at g›re varerne klar til forsendelse fra denne lokation. Tidselementet anvendes ved beregning af leveringsdatoen p† f›lgende m†de: Afsendelsesdato + Udg†ende lagerekspeditionstid = Planlagt afsendelsesdato + Transporttid = Planlagt leveringsdato.";
                           ENU="Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date."];
                ApplicationArea=#Warehouse;
                SourceExpr="Outbound Whse. Handling Time";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den varepost, som dette dokument eller denne kladdelinje udlignes p†.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#Advanced;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at denne salgsleverancelinje er blevet bogf›rt som en rettelsespost.;
                           ENU=Specifies that this sales shipment line has been posted as a corrective entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Correction;
                Visible=FALSE;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      IsFoundation@1020 : Boolean;

    LOCAL PROCEDURE ShowTracking@1();
    VAR
      ItemLedgEntry@1000 : Record 32;
      TempItemLedgEntry@1002 : TEMPORARY Record 32;
      TrackingForm@1001 : Page 99000822;
    BEGIN
      TESTFIELD(Type,Type::Item);
      IF "Item Shpt. Entry No." <> 0 THEN BEGIN
        ItemLedgEntry.GET("Item Shpt. Entry No.");
        TrackingForm.SetItemLedgEntry(ItemLedgEntry);
      END ELSE
        TrackingForm.SetMultipleItemLedgEntries(TempItemLedgEntry,
          DATABASE::"Sales Shipment Line",0,"Document No.",'',0,"Line No.");

      TrackingForm.RUNMODAL;
    END;

    LOCAL PROCEDURE UndoShipmentPosting@2();
    VAR
      SalesShptLine@1000 : Record 111;
    BEGIN
      SalesShptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(SalesShptLine);
      CODEUNIT.RUN(CODEUNIT::"Undo Sales Shipment Line",SalesShptLine);
    END;

    LOCAL PROCEDURE PageShowItemSalesInvLines@4();
    BEGIN
      TESTFIELD(Type,Type::Item);
      ShowItemSalesInvLines;
    END;

    BEGIN
    END.
  }
}

