OBJECT Page 5851 Get Post.Doc - S.ShptLn Sbfrm
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
    SourceTable=Table111;
    PageType=ListPart;
    OnFindRecord=BEGIN
                   IF NOT Visible THEN
                     EXIT(FALSE);

                   IF FIND(Which) THEN BEGIN
                     SalesShptLine := Rec;
                     WHILE TRUE DO BEGIN
                       ShowRec := IsShowRec(Rec);
                       IF ShowRec THEN
                         EXIT(TRUE);
                       IF NEXT(1) = 0 THEN BEGIN
                         Rec := SalesShptLine;
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

                   SalesShptLine := Rec;
                   REPEAT
                     NextSteps := NEXT(Steps / ABS(Steps));
                     ShowRec := IsShowRec(Rec);
                     IF ShowRec THEN BEGIN
                       RealSteps := RealSteps + NextSteps;
                       SalesShptLine := Rec;
                     END;
                   UNTIL (NextSteps = 0) OR (RealSteps = Steps);
                   Rec := SalesShptLine;
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
                      Name=ShowDocument;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#SalesReturnOrder;
                      Image=View;
                      OnAction=BEGIN
                                 ShowPostedShipment;
                               END;
                                }
      { 1900206204;2 ;Action    ;
                      Name=Dimensions;
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
                      Name=ItemTrackingLines;
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
                ToolTipML=[DAN=Angiver nummeret pÜ det relaterede bilag.;
                           ENU=Specifies the number of the related document.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipment Date" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ debitoren.;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dit og din kreditors og debitors varenummer, vil dette nummer tilsidesëtte standardvarenummeret, nÜr du angiver krydsreferencenummeret pÜ et salgs- eller kõbsbilag.;
                           ENU=Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor's or customer's item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.];
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
                ToolTipML=[DAN=Angiver, at varen pÜ salgslinjen er en katalogvare, dvs. den opbevares normalt ikke pÜ lageret.;
                           ENU=Specifies that the item on the sales line is a nonstock item, which means it is not normally kept in inventory.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ eller beskrivelsen af varen, finanskontoen eller varegebyret.;
                           ENU=Specifies either the name of or the description of the item, general ledger account or item charge.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Description }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken lokation fakturalinjen er registreret pÜ.;
                           ENU=Specifies the location in which the invoice line was registered.];
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
                ToolTipML=[DAN=Angiver antallet af enheder af varen, finanskontoen eller varegebyret pÜ linjen.;
                           ENU=Specifies the number of units of the item, general ledger account, or item charge on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Quantity }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den leverede vare, der er bogfõrt som leveret, men som endnu ikke er bogfõrt som faktureret.;
                           ENU=Specifies the quantity of the shipped item that has been posted as shipped but that has not yet been posted as invoiced.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Qty. Shipped Not Invoiced" }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Antal ikke returneret;
                           ENU=Qty. Not Returned];
                ToolTipML=[DAN=Angiver det antal fra den bogfõrte dokumentlinje, der er leveret til debitoren og ikke er returneret af debitoren.;
                           ENU=Specifies the quantity from the posted document line that has been shipped to the customer and not returned by the customer.];
                ApplicationArea=#SalesReturnOrder;
                DecimalPlaces=0:5;
                SourceExpr=QtyNotReturned }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=Antal returneret;
                           ENU=Qty. Returned];
                ToolTipML=[DAN=Angiver det antal, der er returneret.;
                           ENU=Specifies the quantity that was returned.];
                ApplicationArea=#SalesReturnOrder;
                DecimalPlaces=0:5;
                SourceExpr=CalcQtyReturned }

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
                ToolTipML=[DAN=Angiver den kostpris, der vil fremgÜ af de nye bilagslinjer.;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette bilag eller denne kladdelinje udlignes fra.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Appl.-from Item Entry";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den varepost, som dette dokument eller denne kladdelinje udlignes pÜ.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Appl.-to Item Entry" }

  }
  CODE
  {
    VAR
      SalesShptLine@1003 : Record 111;
      TempSalesShptLine@1002 : TEMPORARY Record 111;
      QtyNotReturned@1004 : Decimal;
      RevUnitCostLCY@1000 : Decimal;
      RevQtyFilter@1005 : Boolean;
      FillExactCostReverse@1007 : Boolean;
      Visible@1009 : Boolean;
      ShowRec@1001 : Boolean;
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    VAR
      SalesShptLine2@1000 : Record 111;
      QtyNotReturned2@1002 : Decimal;
      RevUnitCostLCY2@1001 : Decimal;
    BEGIN
      TempSalesShptLine.RESET;
      TempSalesShptLine.COPYFILTERS(Rec);
      TempSalesShptLine.SETRANGE("Document No.","Document No.");
      IF NOT TempSalesShptLine.FINDFIRST THEN BEGIN
        QtyNotReturned2 := QtyNotReturned;
        RevUnitCostLCY2 := RevUnitCostLCY;
        SalesShptLine2.COPYFILTERS(Rec);
        SalesShptLine2.SETRANGE("Document No.","Document No.");
        IF NOT SalesShptLine2.FINDSET THEN
          EXIT(FALSE);
        REPEAT
          ShowRec := IsShowRec(SalesShptLine2);
          IF ShowRec THEN BEGIN
            TempSalesShptLine := SalesShptLine2;
            TempSalesShptLine.INSERT;
          END;
        UNTIL (SalesShptLine2.NEXT = 0) OR ShowRec;
        QtyNotReturned := QtyNotReturned2;
        RevUnitCostLCY := RevUnitCostLCY2;
      END;

      EXIT("Line No." = TempSalesShptLine."Line No.");
    END;

    LOCAL PROCEDURE IsShowRec@3(SalesShptLine2@1000 : Record 111) : Boolean;
    BEGIN
      WITH SalesShptLine2 DO BEGIN
        QtyNotReturned := 0;
        IF RevQtyFilter AND (Type = Type::" ") THEN
          EXIT("Attached to Line No." = 0);
        IF Type <> Type::Item THEN
          EXIT(TRUE);
        CalcShippedSaleNotReturned(QtyNotReturned,RevUnitCostLCY,FillExactCostReverse);
        IF NOT RevQtyFilter THEN
          EXIT(TRUE);
        EXIT(QtyNotReturned > 0);
      END;
    END;

    LOCAL PROCEDURE CalcQtyReturned@5() : Decimal;
    BEGIN
      IF (Type = Type::Item) AND (Quantity - QtyNotReturned > 0) THEN
        EXIT(Quantity - QtyNotReturned);
      EXIT(0);
    END;

    [External]
    PROCEDURE Initialize@4(NewRevQtyFilter@1000 : Boolean;NewFillExactCostReverse@1001 : Boolean;NewVisible@1002 : Boolean);
    BEGIN
      RevQtyFilter := NewRevQtyFilter;
      FillExactCostReverse := NewFillExactCostReverse;
      Visible := NewVisible;

      IF Visible THEN BEGIN
        TempSalesShptLine.RESET;
        TempSalesShptLine.DELETEALL;
      END;
    END;

    [External]
    PROCEDURE GetSelectedLine@1(VAR FromSalesShptLine@1000 : Record 111);
    BEGIN
      FromSalesShptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(FromSalesShptLine);
    END;

    LOCAL PROCEDURE ShowPostedShipment@6();
    VAR
      SalesShptHeader@1001 : Record 110;
    BEGIN
      IF NOT SalesShptHeader.GET("Document No.") THEN
        EXIT;
      PAGE.RUN(PAGE::"Posted Sales Shipment",SalesShptHeader);
    END;

    LOCAL PROCEDURE ItemTrackingLines@12();
    VAR
      FromSalesShptLine@1000 : Record 111;
    BEGIN
      GetSelectedLine(FromSalesShptLine);
      FromSalesShptLine.ShowItemTrackingLines;
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

