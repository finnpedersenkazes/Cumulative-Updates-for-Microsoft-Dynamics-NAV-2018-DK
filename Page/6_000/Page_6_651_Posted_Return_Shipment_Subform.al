OBJECT Page 6651 Posted Return Shipment Subform
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
    SourceTable=Table6651;
    PageType=ListPart;
    AutoSplitKey=Yes;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1901653604;2 ;Action    ;
                      CaptionML=[DAN=&Annuller returvarelev.;
                                 ENU=&Undo Return Shipment];
                      ToolTipML=[DAN=Fortryd den antalsbogf›ring, der er foretaget for returvareleverancen. Der inds‘ttes automatisk en rettelseslinje i det bogf›rte bilag, og felterne Antal sendt retur og Afs. ret.vare - ikke fakt. p† returvareordren nulstilles.;
                                 ENU=Undo the quantity posting made with the return shipment. A corrective line is inserted in the posted document, and the Return Qty. Shipped and Return Shpd. Not Invd. fields on the return order are set to zero.];
                      ApplicationArea=#PurchReturnOrder;
                      OnAction=BEGIN
                                 UndoReturnShipment;
                               END;
                                }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1900295304;2 ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1907504604;2 ;Action    ;
                      Name=Comments;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#PurchReturnOrder;
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
      { 1903100004;2 ;Action    ;
                      Name=ItemCreditMemoLines;
                      CaptionML=[DAN=Varekreditnota&linjer;
                                 ENU=Item Credit Memo &Lines];
                      ToolTipML=[DAN=Vis de relaterede kreditnotalinjer.;
                                 ENU=View the related credit memo lines.];
                      ApplicationArea=#PurchReturnOrder;
                      OnAction=BEGIN
                                 PageShowItemPurchCrMemoLines;
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
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=Type }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="No." }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dit og din kreditors og debitors varenummer, vil dette nummer tilsides‘tte standardvarenummeret, n†r du angiver krydsreferencenummeret p† et salgs- eller k›bsbilag.;
                           ENU=Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor's or customer's item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Cross-Reference No.";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af den leverance, der er returneret til kreditor, og som blev bogf›rt;
                           ENU=Specifies a description of the shipment that was returned to vendor, that was posted];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=Description }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Return Reason Code" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren p† salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Location Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af enheder af varen, finanskontoen eller varegebyret p† linjen.;
                           ENU=Specifies the number of units of the item, general ledger account, or item charge on the line.];
                ApplicationArea=#PurchReturnOrder;
                BlankZero=Yes;
                SourceExpr=Quantity }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† vare- eller ressourcekortet.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Unit of Measure Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#PurchReturnOrder;
                BlankZero=Yes;
                SourceExpr="Direct Unit Cost" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der allerede er blevet bogf›rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Quantity Invoiced" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet fra den linje, der er bogf›rt som leveret, men som endnu ikke er bogf›rt som faktureret.;
                           ENU=Specifies the quantity from the line that has been posted as shipped but that has not yet been posted as invoiced.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Return Qty. Shipped Not Invd.";
                Visible=FALSE;
                Editable=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Prod. Order No.";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den varepost, som dette dokument eller denne kladdelinje udlignes p†.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at posten skal v‘re en rettelsespost. Du kan bruge feltet, hvis du har brug for at postere en rettelse til en konto.;
                           ENU=Specifies the entry as a corrective entry. You can use the field if you need to post a corrective entry to an account.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=Correction;
                Visible=FALSE;
                Enabled=TRUE;
                Editable=FALSE }

  }
  CODE
  {

    LOCAL PROCEDURE UndoReturnShipment@1();
    VAR
      ReturnShptLine@1000 : Record 6651;
    BEGIN
      ReturnShptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(ReturnShptLine);
      CODEUNIT.RUN(CODEUNIT::"Undo Return Shipment Line",ReturnShptLine);
    END;

    LOCAL PROCEDURE PageShowItemPurchCrMemoLines@2();
    BEGIN
      TESTFIELD(Type,Type::Item);
      ShowItemPurchCrMemoLines;
    END;

    BEGIN
    END.
  }
}

