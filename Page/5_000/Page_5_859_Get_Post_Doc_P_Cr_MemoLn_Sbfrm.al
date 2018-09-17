OBJECT Page 5859 Get Post.Doc-P.Cr.MemoLn Sbfrm
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
    SourceTable=Table125;
    PageType=ListPart;
    OnFindRecord=BEGIN
                   IF FIND(Which) THEN BEGIN
                     PurchCrMemoLine := Rec;
                     WHILE TRUE DO BEGIN
                       ShowRec := IsShowRec(Rec);
                       IF ShowRec THEN
                         EXIT(TRUE);
                       IF NEXT(1) = 0 THEN BEGIN
                         Rec := PurchCrMemoLine;
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
                   RealSteps@1000 : Integer;
                   NextSteps@1001 : Integer;
                 BEGIN
                   IF Steps = 0 THEN
                     EXIT;

                   PurchCrMemoLine := Rec;
                   REPEAT
                     NextSteps := NEXT(Steps / ABS(Steps));
                     ShowRec := IsShowRec(Rec);
                     IF ShowRec THEN BEGIN
                       RealSteps := RealSteps + NextSteps;
                       PurchCrMemoLine := Rec;
                     END;
                   UNTIL (NextSteps = 0) OR (RealSteps = Steps);
                   Rec := PurchCrMemoLine;
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
      { 1900206104;2 ;Action    ;
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
      { 1901652504;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 Dimensions;
                               END;
                                }
      { 1903098904;2 ;Action    ;
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
                ToolTipML=[DAN=Angiver nummeret pÜ kreditnotaen.;
                           ENU=Specifies the credit memo number.];
                ApplicationArea=#Suite;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 36  ;2   ;Field     ;
                CaptionML=[DAN=Bogfõringsdato;
                           ENU=Posting Date];
                ToolTipML=[DAN=Angiver bogfõringsdatoen for recorden.;
                           ENU=Specifies the posting date of the record.];
                ApplicationArea=#Suite;
                SourceExpr=PurchCrMemoHeader."Posting Date" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor varerne blev modtaget.;
                           ENU=Specifies the date the items were received.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Expected Receipt Date";
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

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor kreditnotalinjen er registreret.;
                           ENU=Specifies the code for the location where the credit memo line is registered.];
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
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal angives pÜ kreditnotalinjen.;
                           ENU=Specifies the number of units of the item specified on the credit memo line.];
                ApplicationArea=#Suite;
                SourceExpr=Quantity }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 76  ;2   ;Field     ;
                CaptionML=[DAN=Kõbspris;
                           ENU=Direct Unit Cost];
                ToolTipML=[DAN="Angiver den direkte kostpris. ";
                           ENU="Specifies the direct unit cost. "];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=DirectUnitCost;
                AutoFormatType=2;
                AutoFormatExpr=PurchCrMemoHeader."Currency Code";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                CaptionML=[DAN=Linjebelõb;
                           ENU=Line Amount];
                ToolTipML=[DAN=Angiver det nettobelõb uden eventuelt fakturarabatbelõb, som skal betales for produkterne pÜ linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Suite;
                SourceExpr=LineAmount;
                AutoFormatType=1;
                AutoFormatExpr=PurchCrMemoHeader."Currency Code" }

    { 80  ;2   ;Field     ;
                CaptionML=[DAN=Valutakode;
                           ENU=Currency Code];
                ToolTipML=[DAN=Angiver koden for den valuta, som belõbene vises i.;
                           ENU=Specifies the code for the currency that amounts are shown in.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=PurchCrMemoHeader."Currency Code";
                Visible=FALSE }

    { 82  ;2   ;Field     ;
                CaptionML=[DAN=Priser inkl. moms;
                           ENU=Prices Including VAT];
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebelõb pÜ bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=PurchCrMemoHeader."Prices Including VAT";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen pÜ linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Line Discount %" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbelõb, der ydes pÜ varen, pÜ linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Line Discount Amount";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, nÜr fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
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

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
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
      PurchCrMemoHeader@1006 : Record 124;
      PurchCrMemoLine@1001 : Record 125;
      TempPurchCrMemoLine@1002 : TEMPORARY Record 125;
      DirectUnitCost@1007 : Decimal;
      LineAmount@1012 : Decimal;
      DocumentNoHideValue@19020538 : Boolean INDATASET;
      ShowRec@1000 : Boolean;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    BEGIN
      TempPurchCrMemoLine.RESET;
      TempPurchCrMemoLine.COPYFILTERS(Rec);
      TempPurchCrMemoLine.SETRANGE("Document No.","Document No.");
      IF NOT TempPurchCrMemoLine.FINDFIRST THEN BEGIN
        PurchCrMemoLine.COPYFILTERS(Rec);
        PurchCrMemoLine.SETRANGE("Document No.","Document No.");
        IF NOT PurchCrMemoLine.FINDFIRST THEN
          EXIT(FALSE);
        TempPurchCrMemoLine := PurchCrMemoLine;
        TempPurchCrMemoLine.INSERT;
      END;

      IF "Document No." <> PurchCrMemoHeader."No." THEN
        PurchCrMemoHeader.GET("Document No.");

      DirectUnitCost := "Direct Unit Cost";
      LineAmount := "Line Amount";

      EXIT("Line No." = TempPurchCrMemoLine."Line No.");
    END;

    LOCAL PROCEDURE IsShowRec@3(PurchCrMemoLine2@1000 : Record 125) : Boolean;
    BEGIN
      WITH PurchCrMemoLine2 DO BEGIN
        IF "Document No." <> PurchCrMemoHeader."No." THEN
          PurchCrMemoHeader.GET("Document No.");
        IF PurchCrMemoHeader."Prepayment Credit Memo" THEN
          EXIT(FALSE);
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE GetSelectedLine@1(VAR FromPurchCrMemoLine@1000 : Record 125);
    BEGIN
      FromPurchCrMemoLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(FromPurchCrMemoLine);
    END;

    LOCAL PROCEDURE ShowDocument@5();
    BEGIN
      IF NOT PurchCrMemoHeader.GET("Document No.") THEN
        EXIT;
      PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHeader);
    END;

    LOCAL PROCEDURE Dimensions@7();
    VAR
      FromPurchCrMemoLine@1003 : Record 125;
    BEGIN
      GetSelectedLine(FromPurchCrMemoLine);
      FromPurchCrMemoLine.ShowDimensions;
    END;

    LOCAL PROCEDURE ItemTrackingLines@8();
    VAR
      FromPurchCrMemoLine@1000 : Record 125;
    BEGIN
      GetSelectedLine(FromPurchCrMemoLine);
      FromPurchCrMemoLine.ShowItemTrackingLines;
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

