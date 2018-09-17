OBJECT Page 5858 Get Pst.Doc-RtrnShptLn Subform
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
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
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
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
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
                      ToolTipML=[DAN=FÜ vist eller rediger serienummer og lotnumre, der er tildelt varen pÜ bilags- eller kladdelinjen.;
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
                ToolTipML=[DAN=Angiver nummeret pÜ returvareleverancen.;
                           ENU=Specifies the number of the return shipment.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the number of the vendor that you received the invoice from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Pay-to Vendor No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Buy-from Vendor No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
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
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
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
                ToolTipML=[DAN=Angiver navnet pÜ eller en beskrivelse af varen eller finanskontoen eller varegebyret.;
                           ENU=Specifies either the name of, or a description of, the item, general ledger account, or item charge.];
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
                ToolTipML=[DAN=Angiver valutakoden for belõbet pÜ denne linje.;
                           ENU=Specifies the currency code for the amount on this line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne pÜ linjen placeres.;
                           ENU=Specifies the code for the location where items on the line are placed.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller lëgges pÜ lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit of Measure Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af enheder af varen, finanskontoen eller varegebyret pÜ linjen.;
                           ENU=Specifies the number of units of the item, general ledger account, or item charge specified on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Quantity }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af returvaren, der er bogfõrt som leveret, men som endnu ikke er bogfõrt som faktureret.;
                           ENU=Specifies the quantity of the returned item that has been posted as shipped but that has not yet been posted as invoiced.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Qty. Shipped Not Invd." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den rammeordrelinje, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den varepost, som dette dokument eller denne kladdelinje udlignes pÜ.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      ReturnShptLine@1001 : Record 6651;
      TempReturnShptLine@1002 : TEMPORARY Record 6651;
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    BEGIN
      TempReturnShptLine.RESET;
      TempReturnShptLine.COPYFILTERS(Rec);
      TempReturnShptLine.SETRANGE("Document No.","Document No.");
      IF NOT TempReturnShptLine.FINDFIRST THEN BEGIN
        ReturnShptLine.COPYFILTERS(Rec);
        ReturnShptLine.SETRANGE("Document No.","Document No.");
        IF NOT ReturnShptLine.FINDFIRST THEN
          EXIT(FALSE);
        TempReturnShptLine := ReturnShptLine;
        TempReturnShptLine.INSERT;
      END;

      EXIT("Line No." = TempReturnShptLine."Line No.");
    END;

    [External]
    PROCEDURE GetSelectedLine@1(VAR FromReturnShptLine@1000 : Record 6651);
    BEGIN
      FromReturnShptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(FromReturnShptLine);
    END;

    LOCAL PROCEDURE ShowDocument@5();
    VAR
      ReturnShptHeader@1001 : Record 6650;
    BEGIN
      IF NOT ReturnShptHeader.GET("Document No.") THEN
        EXIT;
      PAGE.RUN(PAGE::"Posted Return Shipment",ReturnShptHeader);
    END;

    LOCAL PROCEDURE ItemTrackingLines@8();
    VAR
      FromReturnShptLine@1000 : Record 6651;
    BEGIN
      GetSelectedLine(FromReturnShptLine);
      FromReturnShptLine.ShowItemTrackingLines;
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

