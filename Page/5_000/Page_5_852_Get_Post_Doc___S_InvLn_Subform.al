OBJECT Page 5852 Get Post.Doc - S.InvLn Subform
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
    SourceTable=Table113;
    PageType=ListPart;
    OnFindRecord=BEGIN
                   IF NOT Visible THEN
                     EXIT(FALSE);

                   IF FIND(Which) THEN BEGIN
                     SalesInvLine := Rec;
                     WHILE TRUE DO BEGIN
                       ShowRec := IsShowRec(Rec);
                       IF ShowRec THEN
                         EXIT(TRUE);
                       IF NEXT(1) = 0 THEN BEGIN
                         Rec := SalesInvLine;
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

                   SalesInvLine := Rec;
                   REPEAT
                     NextSteps := NEXT(Steps / ABS(Steps));
                     ShowRec := IsShowRec(Rec);
                     IF ShowRec THEN BEGIN
                       RealSteps := RealSteps + NextSteps;
                       SalesInvLine := Rec;
                     END;
                   UNTIL (NextSteps = 0) OR (RealSteps = Steps);
                   Rec := SalesInvLine;
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
                      ToolTipML=[DAN=�bn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Basic,#Suite;
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
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
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
                ToolTipML=[DAN=Angiver fakturanummeret.;
                           ENU=Specifies the invoice number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 36  ;2   ;Field     ;
                CaptionML=[DAN=Bogf�ringsdato;
                           ENU=Posting Date];
                ToolTipML=[DAN=Angiver bogf�ringsdatoen for recorden.;
                           ENU=Specifies the posting date of the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SalesInvHeader."Posting Date" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r varerne p� bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en �nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Date";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver krydsreferencenummeret for den vare, der er angivet p� linjen.;
                           ENU=Specifies the cross-reference number of the item specified on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Cross-Reference No.";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
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
                ToolTipML=[DAN=Angiver navnet p� varen eller finanskontoen eller en beskrivende tekst.;
                           ENU=Specifies the name of the item or general ledger account, or some descriptive text.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken lokation fakturalinjen er registreret p�.;
                           ENU=Specifies the location in which the invoice line was registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l�gges p� lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
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
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal angives p� linjen.;
                           ENU=Specifies the number of units of the item specified on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Quantity }

    { 44  ;2   ;Field     ;
                CaptionML=[DAN=Antal ikke returneret;
                           ENU=Qty. Not Returned];
                ToolTipML=[DAN=Angiver det antal fra den bogf�rte dokumentlinje, der er leveret til debitoren og ikke er returneret af debitoren.;
                           ENU=Specifies the quantity from the posted document line that has been shipped to the customer and not returned by the customer.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=QtyNotReturned }

    { 38  ;2   ;Field     ;
                CaptionML=[DAN=Antal returneret;
                           ENU=Qty. Returned];
                ToolTipML=[DAN=Angiver det antal, der er returneret.;
                           ENU=Specifies the quantity that was returned.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=CalcQtyReturned }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                CaptionML=[DAN=Tilbagef�r kostpris (RV);
                           ENU=Reverse Unit Cost (LCY)];
                ToolTipML=[DAN=Angiver den kostpris, der vil fremg� af de nye dokumentlinjer.;
                           ENU=Specifies the unit cost that will appear on the new document lines.];
                ApplicationArea=#Advanced;
                SourceExpr=RevUnitCostLCY;
                AutoFormatType=2;
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                CaptionML=[DAN=Enhedspris;
                           ENU=Unit Price];
                ToolTipML=[DAN=Angiver varens enhedspris.;
                           ENU=Specifies the item's unit price.];
                ApplicationArea=#Advanced;
                SourceExpr=UnitPrice;
                AutoFormatType=2;
                AutoFormatExpr=SalesInvHeader."Currency Code";
                Visible=FALSE }

    { 76  ;2   ;Field     ;
                CaptionML=[DAN=Linjebel�b;
                           ENU=Line Amount];
                ToolTipML=[DAN=Angiver det nettobel�b uden eventuelt fakturarabatbel�b, som skal betales for produkterne p� linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=LineAmount;
                AutoFormatType=1;
                AutoFormatExpr=SalesInvHeader."Currency Code" }

    { 78  ;2   ;Field     ;
                CaptionML=[DAN=Valutakode;
                           ENU=Currency Code];
                ToolTipML=[DAN=Angiver koden for den valuta, som bel�bene vises i.;
                           ENU=Specifies the code for the currency that amounts are shown in.];
                ApplicationArea=#Advanced;
                SourceExpr=SalesInvHeader."Currency Code";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                CaptionML=[DAN=Priser inkl. moms;
                           ENU=Prices Including VAT];
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel�b p� bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Advanced;
                SourceExpr=SalesInvHeader."Prices Including VAT";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p� linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Line Discount %" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel�b, der ydes p� varen, p� linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Line Discount Amount";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, n�r fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede beregnede fakturarabatbel�b for linjen.;
                           ENU=Specifies the total calculated invoice discount amount for the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Advanced;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den rammeordrelinje, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette bilag eller denne kladdelinje udlignes fra.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied from.];
                ApplicationArea=#Advanced;
                SourceExpr="Appl.-from Item Entry";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den varepost, som dette dokument eller denne kladdelinje udlignes p�.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#Advanced;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      ToSalesHeader@1010 : Record 36;
      SalesInvHeader@1008 : Record 112;
      SalesInvLine@1003 : Record 113;
      TempSalesInvLine@1002 : TEMPORARY Record 113;
      QtyNotReturned@1004 : Decimal;
      RevUnitCostLCY@1000 : Decimal;
      UnitPrice@1009 : Decimal;
      LineAmount@1005 : Decimal;
      RevQtyFilter@1001 : Boolean;
      FillExactCostReverse@1006 : Boolean;
      Visible@1011 : Boolean;
      ShowRec@1013 : Boolean;
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    VAR
      SalesInvHeader2@1003 : Record 112;
      SalesInvLine2@1000 : Record 113;
      QtyNotReturned2@1001 : Decimal;
      RevUnitCostLCY2@1002 : Decimal;
    BEGIN
      TempSalesInvLine.RESET;
      TempSalesInvLine.COPYFILTERS(Rec);
      TempSalesInvLine.SETRANGE("Document No.","Document No.");
      IF NOT TempSalesInvLine.FINDFIRST THEN BEGIN
        SalesInvHeader2 := SalesInvHeader;
        QtyNotReturned2 := QtyNotReturned;
        RevUnitCostLCY2 := RevUnitCostLCY;
        SalesInvLine2.COPYFILTERS(Rec);
        SalesInvLine2.SETRANGE("Document No.","Document No.");
        IF NOT SalesInvLine2.FINDSET THEN
          EXIT(FALSE);
        REPEAT
          ShowRec := IsShowRec(SalesInvLine2);
          IF ShowRec THEN BEGIN
            TempSalesInvLine := SalesInvLine2;
            TempSalesInvLine.INSERT;
          END;
        UNTIL (SalesInvLine2.NEXT = 0) OR ShowRec;
        SalesInvHeader := SalesInvHeader2;
        QtyNotReturned := QtyNotReturned2;
        RevUnitCostLCY := RevUnitCostLCY2;
      END;

      IF "Document No." <> SalesInvHeader."No." THEN
        SalesInvHeader.GET("Document No.");

      UnitPrice := "Unit Price";
      LineAmount := "Line Amount";

      EXIT("Line No." = TempSalesInvLine."Line No.");
    END;

    LOCAL PROCEDURE IsShowRec@3(SalesInvLine2@1000 : Record 113) : Boolean;
    BEGIN
      WITH SalesInvLine2 DO BEGIN
        QtyNotReturned := 0;
        IF "Document No." <> SalesInvHeader."No." THEN
          SalesInvHeader.GET("Document No.");
        IF SalesInvHeader."Prepayment Invoice" THEN
          EXIT(FALSE);
        IF RevQtyFilter THEN BEGIN
          IF SalesInvHeader."Currency Code" <> ToSalesHeader."Currency Code" THEN
            EXIT(FALSE);
          IF Type = Type::" " THEN
            EXIT("Attached to Line No." = 0);
        END;
        IF Type <> Type::Item THEN
          EXIT(TRUE);
        CalcShippedSaleNotReturned(QtyNotReturned,RevUnitCostLCY,FillExactCostReverse);
        IF NOT RevQtyFilter THEN
          EXIT(TRUE);
        EXIT(QtyNotReturned > 0);
      END;
    END;

    LOCAL PROCEDURE CalcQtyReturned@6() : Decimal;
    BEGIN
      IF (Type = Type::Item) AND (Quantity - QtyNotReturned > 0) THEN
        EXIT(Quantity - QtyNotReturned);
      EXIT(0);
    END;

    [External]
    PROCEDURE Initialize@4(NewToSalesHeader@1002 : Record 36;NewRevQtyFilter@1000 : Boolean;NewFillExactCostReverse@1001 : Boolean;NewVisible@1003 : Boolean);
    BEGIN
      ToSalesHeader := NewToSalesHeader;
      RevQtyFilter := NewRevQtyFilter;
      FillExactCostReverse := NewFillExactCostReverse;
      Visible := NewVisible;

      IF Visible THEN BEGIN
        TempSalesInvLine.RESET;
        TempSalesInvLine.DELETEALL;
      END;
    END;

    [External]
    PROCEDURE GetSelectedLine@1(VAR FromSalesInvLine@1000 : Record 113);
    BEGIN
      FromSalesInvLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(FromSalesInvLine);
    END;

    LOCAL PROCEDURE ShowDocument@7();
    BEGIN
      IF NOT SalesInvHeader.GET("Document No.") THEN
        EXIT;
      PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvHeader);
    END;

    LOCAL PROCEDURE ItemTrackingLines@12();
    VAR
      FromSalesInvLine@1000 : Record 113;
    BEGIN
      GetSelectedLine(FromSalesInvLine);
      FromSalesInvLine.ShowItemTrackingLines;
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

