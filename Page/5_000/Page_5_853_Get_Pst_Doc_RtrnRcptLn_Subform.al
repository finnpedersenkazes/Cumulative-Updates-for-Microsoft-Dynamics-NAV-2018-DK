OBJECT Page 5853 Get Pst.Doc-RtrnRcptLn Subform
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
    SourceTable=Table6661;
    PageType=ListPart;
    OnAfterGetRecord=BEGIN
                       DocumentNoHideValue := FALSE;
                       DocumentNoOnFormat;
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1901742204;2 ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=�bn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#SalesReturnOrder;
                      Image=View;
                      OnAction=BEGIN
                                 ShowDocument;
                               END;
                                }
      { 1903866904;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1901313304;2 ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=F� vist eller rediger serienummer og lotnumre, der er tildelt varen p� bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 ItemTrackingLines;
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
                Lookup=No;
                ToolTipML=[DAN=Angiver nummeret p� returvaremodtagelsen.;
                           ENU=Specifies the number of the return receipt.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r varerne p� bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en �nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipment Date" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Customer No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer.;
                           ENU=Specifies the cross-reference number related to the item.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Cross-Reference No.";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen ikke er en lagervare.;
                           ENU=Specifies that this item is a nonstock item.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� eller beskrivelsen af varen eller finanskontoen eller varegebyret.;
                           ENU=Specifies either the name of, or the description of, the item, general ledger account, or item charge.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Description }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                Lookup=No;
                DrillDown=No;
                ToolTipML=[DAN=Angiver valutakoden for bel�bet p� denne linje.;
                           ENU=Specifies the currency code for the amount on this line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken lokation returvaremodtagelseslinjen er registreret p�.;
                           ENU=Specifies the location in which the return receipt line was registered.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l�gges p� lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit of Measure Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af enheder af varen, finanskontoen eller varegebyret p� linjen.;
                           ENU=Specifies the number of units of the item, general ledger account, or item charge specified on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Quantity }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet fra den linje, der er bogf�rt som modtaget, men som endnu ikke er bogf�rt som faktureret.;
                           ENU=Specifies the quantity from the line that has been posted as received but that has not yet been posted as invoiced.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Qty. Rcd. Not Invd." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den rammeordrelinje, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette bilag eller denne kladdelinje udlignes fra.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Appl.-from Item Entry";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den varepost, som dette dokument eller denne kladdelinje udlignes p�.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      ReturnRcptLine@1001 : Record 6661;
      TempReturnRcptLine@1002 : TEMPORARY Record 6661;
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    BEGIN
      TempReturnRcptLine.RESET;
      TempReturnRcptLine.COPYFILTERS(Rec);
      TempReturnRcptLine.SETRANGE("Document No.","Document No.");
      IF NOT TempReturnRcptLine.FINDFIRST THEN BEGIN
        ReturnRcptLine.COPYFILTERS(Rec);
        ReturnRcptLine.SETRANGE("Document No.","Document No.");
        IF NOT ReturnRcptLine.FINDFIRST THEN
          EXIT(FALSE);
        TempReturnRcptLine := ReturnRcptLine;
        TempReturnRcptLine.INSERT;
      END;

      EXIT("Line No." = TempReturnRcptLine."Line No.");
    END;

    [External]
    PROCEDURE GetSelectedLine@1(VAR FromReturnRcptLine@1000 : Record 6661);
    BEGIN
      FromReturnRcptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(FromReturnRcptLine);
    END;

    LOCAL PROCEDURE ShowDocument@7();
    VAR
      ReturnRcptHeader@1000 : Record 6660;
    BEGIN
      IF NOT ReturnRcptHeader.GET("Document No.") THEN
        EXIT;
      PAGE.RUN(PAGE::"Posted Return Receipt",ReturnRcptHeader);
    END;

    LOCAL PROCEDURE ItemTrackingLines@12();
    VAR
      FromReturnRcptLine@1000 : Record 6661;
    BEGIN
      GetSelectedLine(FromReturnRcptLine);
      FromReturnRcptLine.ShowItemTrackingLines;
    END;

    LOCAL PROCEDURE DocumentNoOnFormat@19001080();
    BEGIN
      IF NOT IsFirstDocLine THEN
        DocumentNoHideValue := TRUE;
    END;

    BEGIN
    END.
  }
}

