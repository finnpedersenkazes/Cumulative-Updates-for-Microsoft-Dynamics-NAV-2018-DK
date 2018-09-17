OBJECT Page 5857 Get Post.Doc - P.InvLn Subform
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
    SourceTable=Table123;
    PageType=ListPart;
    OnFindRecord=BEGIN
                   IF NOT Visible THEN
                     EXIT(FALSE);

                   IF FIND(Which) THEN BEGIN
                     PurchInvLine := Rec;
                     WHILE TRUE DO BEGIN
                       ShowRec := IsShowRec(Rec);
                       IF ShowRec THEN
                         EXIT(TRUE);
                       IF NEXT(1) = 0 THEN BEGIN
                         Rec := PurchInvLine;
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

                   PurchInvLine := Rec;
                   REPEAT
                     NextSteps := NEXT(Steps / ABS(Steps));
                     ShowRec := IsShowRec(Rec);
                     IF ShowRec THEN BEGIN
                       RealSteps := RealSteps + NextSteps;
                       PurchInvLine := Rec;
                     END;
                   UNTIL (NextSteps = 0) OR (RealSteps = Steps);
                   Rec := PurchInvLine;
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
      { 1903099004;2 ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Suite;
                      Image=View;
                      OnAction=BEGIN
                                 ShowDocument;
                               END;
                                }
      { 1900545404;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1901991804;2 ;Action    ;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den faktura, som denne linje tilhõrer.;
                           ENU=Specifies the number of the invoice that this line belongs to.];
                ApplicationArea=#Suite;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Bogfõringsdato;
                           ENU=Posting Date];
                ToolTipML=[DAN=Angiver bogfõringsdatoen for recorden.;
                           ENU=Specifies the posting date of the record.];
                ApplicationArea=#Suite;
                SourceExpr=PurchInvHeader."Posting Date" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor varerne blev forventet modtaget.;
                           ENU=Specifies the date when the items were expected.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Expected Receipt Date";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Vendor No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#Suite;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Suite;
                SourceExpr="No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dine og din kreditors og debitors varenummer, vil dette nummer tilsidesëtte standardvarenummeret, nÜr du angiver krydsreferencenummeret pÜ et salgs- eller kõbsbilag.;
                           ENU=Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor's or customer's item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cross-Reference No.";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen ikke er en lagervare.;
                           ENU=Specifies that this item is a nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ eller en beskrivelse af varen eller finanskontoen.;
                           ENU=Specifies either the name of, or a description of, the item or general ledger account.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor fakturalinjen er registreret.;
                           ENU=Specifies the code for the location where the invoice line is registered.];
                ApplicationArea=#Location;
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
                ApplicationArea=#Suite;
                SourceExpr="Unit of Measure Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er bogfõrt fra linjen.;
                           ENU=Specifies the quantity posted from the line.];
                ApplicationArea=#Suite;
                SourceExpr=Quantity }

    { 44  ;2   ;Field     ;
                CaptionML=[DAN=Restantal;
                           ENU=Remaining Quantity];
                ToolTipML=[DAN=Angiver det antal fra den bogfõrte dokumentlinje, der er tilbage pÜ lageret, hvilket vil sige, at det ikke er solgt, returneret eller forbrugt.;
                           ENU=Specifies the quantity from the posted document line that remains in inventory, meaning that it has not been sold, returned, or consumed.];
                ApplicationArea=#Suite;
                DecimalPlaces=0:5;
                SourceExpr=RemainingQty }

    { 36  ;2   ;Field     ;
                CaptionML=[DAN=Udlignet antal;
                           ENU=Applied Quantity];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der er anvendt.;
                           ENU=Specifies how many units of the item that have been applied.];
                ApplicationArea=#Suite;
                DecimalPlaces=0:5;
                SourceExpr=CalcAppliedQty }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                CaptionML=[DAN=Tilbagefõr kostpris (RV);
                           ENU=Reverse Unit Cost (LCY)];
                ToolTipML=[DAN=Angiver den kostpris, der vil fremgÜ af de nye dokumentlinjer.;
                           ENU=Specifies the unit cost that will appear on the new document lines.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=RevUnitCostLCY;
                AutoFormatType=2;
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                CaptionML=[DAN=Kõbspris;
                           ENU=Direct Unit Cost];
                ToolTipML=[DAN="Angiver den direkte kostpris. ";
                           ENU="Specifies the direct unit cost. "];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=DirectUnitCost;
                AutoFormatType=2;
                AutoFormatExpr=PurchInvHeader."Currency Code";
                Visible=FALSE }

    { 76  ;2   ;Field     ;
                CaptionML=[DAN=Linjebelõb;
                           ENU=Line Amount];
                ToolTipML=[DAN=Angiver det nettobelõb uden eventuelt fakturarabatbelõb, som skal betales for produkterne pÜ linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Suite;
                SourceExpr=LineAmount;
                AutoFormatType=1;
                AutoFormatExpr=PurchInvHeader."Currency Code" }

    { 78  ;2   ;Field     ;
                CaptionML=[DAN=Valutakode;
                           ENU=Currency Code];
                ToolTipML=[DAN=Angiver koden for den valuta, som belõbene vises i.;
                           ENU=Specifies the code for the currency that amounts are shown in.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=PurchInvHeader."Currency Code";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                CaptionML=[DAN=Priser inkl. moms;
                           ENU=Prices Including VAT];
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=PurchInvHeader."Prices Including VAT";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen pÜ linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Line Discount %" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbelõb, der ydes pÜ varen, pÜ linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Line Discount Amount";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, nÜr fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede beregnede fakturarabatbelõb for linjen.;
                           ENU=Specifies the total calculated invoice discount amount for the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
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
      ToPurchHeader@1005 : Record 38;
      PurchInvHeader@1008 : Record 122;
      PurchInvLine@1003 : Record 123;
      TempPurchInvLine@1002 : TEMPORARY Record 123;
      RemainingQty@1004 : Decimal;
      RevUnitCostLCY@1000 : Decimal;
      DirectUnitCost@1009 : Decimal;
      LineAmount@1012 : Decimal;
      RevQtyFilter@1001 : Boolean;
      FillExactCostReverse@1006 : Boolean;
      Visible@1010 : Boolean;
      ShowRec@1013 : Boolean;
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    VAR
      PurchInvHeader2@1003 : Record 122;
      PurchInvLine2@1000 : Record 123;
      RemainingQty2@1002 : Decimal;
      RevUnitCostLCY2@1001 : Decimal;
    BEGIN
      TempPurchInvLine.RESET;
      TempPurchInvLine.COPYFILTERS(Rec);
      TempPurchInvLine.SETRANGE("Document No.","Document No.");
      IF NOT TempPurchInvLine.FINDFIRST THEN BEGIN
        PurchInvHeader2 := PurchInvHeader;
        RemainingQty2 := RemainingQty;
        RevUnitCostLCY2 := RevUnitCostLCY;
        PurchInvLine2.COPYFILTERS(Rec);
        PurchInvLine2.SETRANGE("Document No.","Document No.");
        IF NOT PurchInvLine2.FINDSET THEN
          EXIT(FALSE);
        REPEAT
          ShowRec := IsShowRec(PurchInvLine2);
          IF ShowRec THEN BEGIN
            TempPurchInvLine := PurchInvLine2;
            TempPurchInvLine.INSERT;
          END;
        UNTIL (PurchInvLine2.NEXT = 0) OR ShowRec;
        PurchInvHeader := PurchInvHeader2;
        RemainingQty := RemainingQty2;
        RevUnitCostLCY := RevUnitCostLCY2;
      END;

      IF "Document No." <> PurchInvHeader."No." THEN
        PurchInvHeader.GET("Document No.");

      DirectUnitCost := "Direct Unit Cost";
      LineAmount := "Line Amount";

      EXIT("Line No." = TempPurchInvLine."Line No.");
    END;

    LOCAL PROCEDURE IsShowRec@3(PurchInvLine2@1000 : Record 123) : Boolean;
    BEGIN
      WITH PurchInvLine2 DO BEGIN
        RemainingQty := 0;
        IF "Document No." <> PurchInvHeader."No." THEN
          PurchInvHeader.GET("Document No.");
        IF PurchInvHeader."Prepayment Invoice" THEN
          EXIT(FALSE);
        IF RevQtyFilter THEN BEGIN
          IF PurchInvHeader."Currency Code" <> ToPurchHeader."Currency Code" THEN
            EXIT(FALSE);
          IF Type = Type::" " THEN
            EXIT("Attached to Line No." = 0);
        END;
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

    [External]
    PROCEDURE Initialize@4(NewToPurchHeader@1003 : Record 38;NewRevQtyFilter@1000 : Boolean;NewFillExactCostReverse@1001 : Boolean;NewVisible@1002 : Boolean);
    BEGIN
      ToPurchHeader := NewToPurchHeader;
      RevQtyFilter := NewRevQtyFilter;
      FillExactCostReverse := NewFillExactCostReverse;
      Visible := NewVisible;

      IF Visible THEN BEGIN
        TempPurchInvLine.RESET;
        TempPurchInvLine.DELETEALL;
      END;
    END;

    LOCAL PROCEDURE CalcAppliedQty@6() : Decimal;
    BEGIN
      IF (Type = Type::Item) AND (Quantity - RemainingQty > 0) THEN
        EXIT(Quantity - RemainingQty);
      EXIT(0);
    END;

    [External]
    PROCEDURE GetSelectedLine@1(VAR FromPurchInvLine@1000 : Record 123);
    BEGIN
      FromPurchInvLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(FromPurchInvLine);
    END;

    LOCAL PROCEDURE ShowDocument@5();
    BEGIN
      IF NOT PurchInvHeader.GET("Document No.") THEN
        EXIT;
      PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
    END;

    LOCAL PROCEDURE ItemTrackingLines@8();
    VAR
      FromPurchInvLine@1002 : Record 123;
    BEGIN
      GetSelectedLine(FromPurchInvLine);
      FromPurchInvLine.ShowItemTrackingLines;
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

