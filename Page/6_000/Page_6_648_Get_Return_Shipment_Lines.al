OBJECT Page 6648 Get Return Shipment Lines
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
    CaptionML=[DAN=Hent returvarelev.linjer;
               ENU=Get Return Shipment Lines];
    SourceTable=Table6651;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       DocumentNoHideValue := FALSE;
                       DocumentNoOnFormat;
                     END;

    OnQueryClosePage=BEGIN
                       IF CloseAction = ACTION::LookupOK THEN
                         LookupOKOnPush;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 46      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=�bn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#SalesReturnOrder;
                      Image=View;
                      OnAction=BEGIN
                                 ReturnShptHeader.GET("Document No.");
                                 PAGE.RUN(PAGE::"Posted Return Shipment",ReturnShptHeader);
                               END;
                                }
      { 47      ;2   ;Action    ;
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
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Vare&sporingsposter;
                                 ENU=Item &Tracking Entries];
                      ToolTipML=[DAN=Vis serie- eller lotnumre, der er tildelt til varer.;
                                 ENU=View serial or lot numbers that are assigned to items.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLedger;
                      OnAction=BEGIN
                                 ShowItemTrackingLines;
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
                ToolTipML=[DAN=Angiver nummeret p� det relaterede bilag.;
                           ENU=Specifies the number of the related document.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Buy-from Vendor No." }

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

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� eller beskrivelsen af varen, finanskontoen eller varegebyret.;
                           ENU=Specifies either the name of or the description of the item, general ledger account or item charge.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Description }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                Lookup=No;
                DrillDown=No;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Currency Code";
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

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren p� salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit of Measure Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den varepost, som dette dokument eller denne kladdelinje udlignes p�.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af enheder af varen, finanskontoen eller varegebyret p� linjen.;
                           ENU=Specifies the number of units of the item, general ledger account, or item charge on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Quantity }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Prod. Order No.";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p�g�ldende vare der allerede er blevet bogf�rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Quantity Invoiced" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af varen, som er bogf�rt som leveret, men endnu ikke er bogf�rt som faktureret.;
                           ENU=Specifies the quantity of the item that has been posted as shipped but has not yet been posted as invoiced.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Qty. Shipped Not Invd." }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      PurchHeader@1000 : Record 38;
      ReturnShptHeader@1001 : Record 6650;
      TempReturnShptLine@1002 : TEMPORARY Record 6651;
      GetReturnShipments@1003 : Codeunit 6648;
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    [External]
    PROCEDURE SetPurchHeader@1(VAR PurchHeader2@1000 : Record 38);
    BEGIN
      PurchHeader.GET(PurchHeader2."Document Type",PurchHeader2."No.");
      PurchHeader.TESTFIELD("Document Type",PurchHeader."Document Type"::"Credit Memo");
    END;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    VAR
      ReturnShptLine@1000 : Record 6651;
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
      IF "Line No." = TempReturnShptLine."Line No." THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE LookupOKOnPush@19031339();
    BEGIN
      CurrPage.SETSELECTIONFILTER(Rec);
      GetReturnShipments.SetPurchHeader(PurchHeader);
      GetReturnShipments.CreateInvLines(Rec);
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

