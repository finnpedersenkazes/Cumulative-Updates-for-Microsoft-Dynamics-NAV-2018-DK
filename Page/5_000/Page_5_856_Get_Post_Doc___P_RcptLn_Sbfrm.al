OBJECT Page 5856 Get Post.Doc - P.RcptLn Sbfrm
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
    SaveValues=Yes;
    LinksAllowed=No;
    SourceTable=Table121;
    PageType=ListPart;
    OnFindRecord=BEGIN
                   IF NOT Visible THEN
                     EXIT(FALSE);

                   IF FIND(Which) THEN BEGIN
                     PurchRcptLine := Rec;
                     WHILE TRUE DO BEGIN
                       ShowRec := IsShowRec(Rec);
                       IF ShowRec THEN
                         EXIT(TRUE);
                       IF NEXT(1) = 0 THEN BEGIN
                         Rec := PurchRcptLine;
                         IF FIND(Which) THEN
                           WHILE TRUE DO BEGIN
                             ShowRec := IsShowRec(Rec);
                             IF ShowRec THEN
                               EXIT(TRUE);
                             IF NEXT(-1) = 0 THEN
                               EXIT(FALSE);
                           END;
                       END;
                     END;
                   END;
                   EXIT(FALSE);
                 END;

    OnNextRecord=VAR
                   RealSteps@1001 : Integer;
                   NextSteps@1000 : Integer;
                 BEGIN
                   IF Steps = 0 THEN
                     EXIT;

                   PurchRcptLine := Rec;
                   REPEAT
                     NextSteps := NEXT(Steps / ABS(Steps));
                     ShowRec := IsShowRec(Rec);
                     IF ShowRec THEN BEGIN
                       RealSteps := RealSteps + NextSteps;
                       PurchRcptLine := Rec;
                     END;
                   UNTIL (NextSteps = 0) OR (RealSteps = Steps);
                   Rec := PurchRcptLine;
                   FIND;
                   EXIT(RealSteps);
                 END;

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
      { 1902759804;2 ;Action    ;
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
      { 1900206204;2 ;Action    ;
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
      { 1901652604;2 ;Action    ;
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
                ToolTipML=[DAN=Angiver kvitteringsnummeret.;
                           ENU=Specifies the receipt number.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor varerne blev forventet modtaget.;
                           ENU=Specifies the date the items were expected.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Expected Receipt Date" }

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

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen ikke er en lagervare.;
                           ENU=Specifies that this item is a nonstock item.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ eller en beskrivelse af varen eller finanskontoen.;
                           ENU=Specifies either the name of or a description of the item or general ledger account.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Description }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor modtagelseslinjen er registreret.;
                           ENU=Specifies the code for the location where the receipt line is registered.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
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

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit of Measure Code" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal angives pÜ linjen.;
                           ENU=Specifies the number of units of the item specified on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Quantity }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af returvaren, der er bogfõrt som modtaget, men som endnu ikke er bogfõrt som faktureret.;
                           ENU=Specifies the quantity of the returned item that has been posted as received but that has not yet been posted as invoiced.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Qty. Rcd. Not Invoiced" }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Restantal;
                           ENU=Remaining Quantity];
                ToolTipML=[DAN=Angiver mëngden fra den bogfõrte dokumentlinje, der er tilbage pÜ lageret.;
                           ENU=Specifies the quantity from the posted document line that remains in inventory.];
                ApplicationArea=#SalesReturnOrder;
                DecimalPlaces=0:5;
                SourceExpr=RemainingQty }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=Udlignet antal;
                           ENU=Applied Quantity];
                ToolTipML=[DAN=Angiver antallet af den vare pÜ den linje, som er brugt til udgÜende transaktioner.;
                           ENU=Specifies the quantity of the item in the line that has been used for outbound transactions.];
                ApplicationArea=#SalesReturnOrder;
                DecimalPlaces=0:5;
                SourceExpr=CalcAppliedQty }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Tilbagefõr kostpris (RV);
                           ENU=Reverse Unit Cost (LCY)];
                ToolTipML=[DAN=Angiver den kostpris, der vil fremgÜ af de nye dokumentlinjer.;
                           ENU=Specifies the unit cost that will appear on the new document lines.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=RevUnitCostLCY;
                AutoFormatType=2;
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den rammeordrelinje, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      PurchRcptLine@1003 : Record 121;
      TempPurchRcptLine@1002 : TEMPORARY Record 121;
      RemainingQty@1004 : Decimal;
      RevUnitCostLCY@1000 : Decimal;
      RevQtyFilter@1005 : Boolean;
      FillExactCostReverse@1007 : Boolean;
      Visible@1010 : Boolean;
      ShowRec@1001 : Boolean;
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    VAR
      PurchRcptLine2@1000 : Record 121;
      RemainingQty2@1001 : Decimal;
      RevUnitCostLCY2@1002 : Decimal;
    BEGIN
      TempPurchRcptLine.RESET;
      TempPurchRcptLine.COPYFILTERS(Rec);
      TempPurchRcptLine.SETRANGE("Document No.","Document No.");
      IF NOT TempPurchRcptLine.FINDFIRST THEN BEGIN
        RemainingQty2 := RemainingQty;
        RevUnitCostLCY2 := RevUnitCostLCY;
        PurchRcptLine2.COPYFILTERS(Rec);
        PurchRcptLine2.SETRANGE("Document No.","Document No.");
        IF NOT PurchRcptLine2.FINDSET THEN
          EXIT(FALSE);
        REPEAT
          ShowRec := IsShowRec(PurchRcptLine2);
          IF ShowRec THEN BEGIN
            TempPurchRcptLine := PurchRcptLine2;
            TempPurchRcptLine.INSERT;
          END;
        UNTIL (PurchRcptLine2.NEXT = 0) OR ShowRec;
        RemainingQty := RemainingQty2;
        RevUnitCostLCY := RevUnitCostLCY2;
      END;

      EXIT("Line No." = TempPurchRcptLine."Line No.");
    END;

    LOCAL PROCEDURE IsShowRec@3(PurchRcptLine2@1000 : Record 121) : Boolean;
    BEGIN
      WITH PurchRcptLine2 DO BEGIN
        RemainingQty := 0;
        IF RevQtyFilter AND (Type = Type::" ") THEN
          EXIT("Attached to Line No." = 0);
        IF Type <> Type::Item THEN
          EXIT(TRUE);
        IF ("Job No." <> '') OR ("Prod. Order No." <> '') THEN
          EXIT(NOT RevQtyFilter);
        CalcReceivedPurchNotReturned(RemainingQty,RevUnitCostLCY,FillExactCostReverse);
        IF NOT RevQtyFilter THEN
          EXIT(TRUE);
        EXIT(RemainingQty > 0);
      END;
    END;

    LOCAL PROCEDURE CalcAppliedQty@6() : Decimal;
    BEGIN
      IF (Type = Type::Item) AND (Quantity - RemainingQty > 0) THEN
        EXIT(Quantity - RemainingQty);
      EXIT(0);
    END;

    [External]
    PROCEDURE Initialize@4(NewRevQtyFilter@1000 : Boolean;NewFillExactCostReverse@1001 : Boolean;NewVisible@1003 : Boolean);
    BEGIN
      RevQtyFilter := NewRevQtyFilter;
      FillExactCostReverse := NewFillExactCostReverse;
      Visible := NewVisible;

      IF Visible THEN BEGIN
        TempPurchRcptLine.RESET;
        TempPurchRcptLine.DELETEALL;
      END;
    END;

    [External]
    PROCEDURE GetSelectedLine@1(VAR FromPurchRcptLine@1000 : Record 121);
    BEGIN
      FromPurchRcptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(FromPurchRcptLine);
    END;

    LOCAL PROCEDURE ShowDocument@5();
    VAR
      PurchRcptHeader@1000 : Record 120;
    BEGIN
      IF NOT PurchRcptHeader.GET("Document No.") THEN
        EXIT;
      PAGE.RUN(PAGE::"Posted Purchase Receipt",PurchRcptHeader);
    END;

    LOCAL PROCEDURE ItemTrackingLines@8();
    VAR
      FromPurchRcptLine@1000 : Record 121;
    BEGIN
      GetSelectedLine(FromPurchRcptLine);
      FromPurchRcptLine.ShowItemTrackingLines;
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

