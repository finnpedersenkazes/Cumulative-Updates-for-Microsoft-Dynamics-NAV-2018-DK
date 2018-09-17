OBJECT Page 137 Posted Purchase Rcpt. Subform
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table121;
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
      { 1900544904;2 ;Action    ;
                      Name=OrderTracking;
                      CaptionML=[DAN=&Ordresporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil h›rende eftersp›rgsel. P† denne m†de kan du finde den oprindelige eftersp›rgsel, der medf›rte en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Advanced;
                      Image=OrderTracking;
                      OnAction=BEGIN
                                 ShowTracking;
                               END;
                                }
      { 1900546304;2 ;Action    ;
                      CaptionML=[DAN=&Annuller modtagelse;
                                 ENU=&Undo Receipt];
                      ToolTipML=[DAN=Annuller antalsbogf›ringen p† den valgte bogf›rte modtagelseslinje. Der inds‘ttes en rettelseslinje under den valgte modtagelseslinje. Hvis antallet blev modtaget i en lagermodtagelse, inds‘ttes en rettelseslinje i den bogf›rte lagermodtagelse. Felterne Modtaget (antal) og Modt. antal (ufakt.) p† den relaterede k›bsordre indstilles til nul.;
                                 ENU=Cancel the quantity posting on the selected posted receipt line. A corrective line is inserted under the selected receipt line. If the quantity was received in a warehouse receipt, then a corrective line is inserted in the posted warehouse receipt. The Quantity Received and Qty. Rcd. Not Invoiced fields on the related purchase order are set to zero.];
                      ApplicationArea=#Suite;
                      Image=Undo;
                      OnAction=BEGIN
                                 UndoReceiptLine;
                               END;
                                }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1901741704;2 ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1902740304;2 ;Action    ;
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
      { 1903645704;2 ;Action    ;
                      Name=ItemInvoiceLines;
                      CaptionML=[DAN=Varefaktura&linjer;
                                 ENU=Item Invoice &Lines];
                      ToolTipML=[DAN="Vis bogf›rte salgsfakturalinjer for varen. ";
                                 ENU="View posted sales invoice lines for the item. "];
                      ApplicationArea=#Advanced;
                      Image=ItemInvoice;
                      OnAction=BEGIN
                                 PageShowItemPurchInvLines;
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
                ApplicationArea=#Suite;
                SourceExpr="No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dine og din kreditors og debitors varenummer, vil dette nummer tilsides‘tte standardvarenummeret, n†r du angiver krydsreferencenummeret p† et salgs- eller k›bsbilag.;
                           ENU=Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor's or customer's item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.];
                ApplicationArea=#Suite;
                SourceExpr="Cross-Reference No.";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen eller tjenesten p† linjen.;
                           ENU=Specifies a description of the item or service on the line.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varen eller tjenesten p† linjen.;
                           ENU=Specifies the quantity of the item or service on the line.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=Quantity }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Suite;
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
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Quantity Invoiced" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen p† linjen, der er blevet modtaget, men endnu ikke faktureret.;
                           ENU=Specifies how many units of the item on the line have been received and not yet invoiced.];
                ApplicationArea=#Suite;
                SourceExpr="Qty. Rcd. Not Invoiced";
                Visible=FALSE;
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som du har bedt kreditoren om at levere ordren p† til leveringsadressen. V‘rdien i feltet bruges til at beregne, hvilken dato du senest kan bestille varerne, hvis de skal v‘re leveret p† den ›nskede modtagelsesdato. Hvis det ikke er n›dvendigt med levering p† en bestemt dato, kan du lade feltet st† tomt.;
                           ENU=Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.];
                ApplicationArea=#Suite;
                SourceExpr="Requested Receipt Date";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som kreditoren har lovet at levere ordren.;
                           ENU=Specifies the date that the vendor has promised to deliver the order.];
                ApplicationArea=#Advanced;
                SourceExpr="Promised Receipt Date";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor varen skal ankomme p† lageret. Forl‘ns beregning: planlagt modtagelsesdato = ordredato + kreditors leveringstid (if›lge kreditorens kalender og afrundet til n‘ste arbejdsdag f›rst i kreditorens kalender og derefter lokationens kalender). Hvis der ingen kalender findes hos kreditoren: planlagt modtagelsesdato = ordredato + kreditors leveringstid (if›lge lokationens kalender). Bagl‘ns beregning: ordredato = planlagt modtagelsesdato - kreditors leveringstid (if›lge kreditorens kalender og afrundet til den forrige arbejdsdag f›rst i kreditorens kalender og derefter lokationens kalender). Hvis der ingen kalender findes hos kreditoren: ordredato = planlagt modtagelsesdato - kreditors leveringstid (if›lge lokations kalender).";
                           ENU="Specifies the date when the item is planned to arrive in inventory. Forward calculation: planned receipt date = order date + vendor lead time (per the vendor calendar and rounded to the next working day in first the vendor calendar and then the location calendar). If no vendor calendar exists, then: planned receipt date = order date + vendor lead time (per the location calendar). Backward calculation: order date = planned receipt date - vendor lead time (per the vendor calendar and rounded to the previous working day in first the vendor calendar and then the location calendar). If no vendor calendar exists, then: order date = planned receipt date - vendor lead time (per the location calendar)."];
                ApplicationArea=#Advanced;
                SourceExpr="Planned Receipt Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilg‘ngelige p† lageret. Hvis du lader feltet v‘re tomt, bliver det beregnet p† f›lgende m†de: Planlagt modtagelsesdato + Sikkerhedstid + Indg†ende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Receipt Date" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Suite;
                SourceExpr="Order Date" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datoformel for det tidsrum, det tager at genbestille varen.;
                           ENU=Specifies a date formula for the amount of time it takes to replenish the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Lead Time Calculation";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Advanced;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order No.";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, det tager at g›re varer tilg‘ngelige fra lageret, efter varerne er bogf›rt som modtaget.;
                           ENU=Specifies the time it takes to make items part of available inventory, after the items have been posted as received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Inbound Whse. Handling Time";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den varepost, som dette dokument eller denne kladdelinje udlignes p†.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#Suite;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at posten skal v‘re en rettelsespost. Du kan bruge feltet, hvis du har brug for at postere en rettelse til en konto.;
                           ENU=Specifies the entry as a corrective entry. You can use the field if you need to post a corrective entry to an account.];
                ApplicationArea=#Advanced;
                SourceExpr=Correction;
                Visible=FALSE }

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
      IF "Item Rcpt. Entry No." <> 0 THEN BEGIN
        ItemLedgEntry.GET("Item Rcpt. Entry No.");
        TrackingForm.SetItemLedgEntry(ItemLedgEntry);
      END ELSE
        TrackingForm.SetMultipleItemLedgEntries(TempItemLedgEntry,
          DATABASE::"Purch. Rcpt. Line",0,"Document No.",'',0,"Line No.");

      TrackingForm.RUNMODAL;
    END;

    LOCAL PROCEDURE UndoReceiptLine@2();
    VAR
      PurchRcptLine@1002 : Record 121;
    BEGIN
      PurchRcptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(PurchRcptLine);
      CODEUNIT.RUN(CODEUNIT::"Undo Purchase Receipt Line",PurchRcptLine);
    END;

    LOCAL PROCEDURE PageShowItemPurchInvLines@4();
    BEGIN
      TESTFIELD(Type,Type::Item);
      ShowItemPurchInvLines;
    END;

    BEGIN
    END.
  }
}

