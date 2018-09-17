OBJECT Page 5994 Get Service Shipment Lines
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
    CaptionML=[DAN=Hent serviceleverancelinjer;
               ENU=Get Service Shipment Lines];
    SourceTable=Table5991;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       StyleIsStrong := IsFirstDocLine;
                       DocumentNoHideValue := NOT IsFirstDocLine;
                     END;

    OnQueryClosePage=BEGIN
                       IF CloseAction IN [ACTION::OK,ACTION::LookupOK] THEN
                         OKOnPush;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 48      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Service;
                      Image=View;
                      OnAction=BEGIN
                                 ServiceShptHeader.GET("Document No.");
                                 PAGE.RUN(PAGE::"Posted Service Shipment",ServiceShptHeader);
                               END;
                                }
      { 49      ;2   ;Action    ;
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
                ToolTipML=[DAN=Angiver nummeret pÜ leverancen.;
                           ENU=Specifies the number of this shipment.];
                ApplicationArea=#Service;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No.";
                Visible=TRUE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som ejer varerne pÜ serviceordren.;
                           ENU=Specifies the number of the customer who owns the items on the service order.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for leverancelinjen.;
                           ENU=Specifies the type of this shipment line.];
                ApplicationArea=#Service;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af en vare, ressource, omkostning eller standardtekst pÜ servicelinjen.;
                           ENU=Specifies the description of an item, resource, cost, or a standard text on the service line.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 29  ;2   ;Field     ;
                Lookup=No;
                DrillDown=No;
                ToolTipML=[DAN=Angiver valutakoden for de forskellige belõb pÜ leverancen.;
                           ENU=Specifies the currency code for various amounts on the shipment.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code";
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

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren pÜ salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder, ressourcetimer, finanskontobetalinger eller omkostninger, der er leveret til debitoren.;
                           ENU=Specifies the number of item units, resource hours, general ledger account payments, or cost that have been shipped to the customer.];
                ApplicationArea=#Service;
                SourceExpr=Quantity }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den leverede vare, der er bogfõrt som leveret, men som endnu ikke er bogfõrt som faktureret.;
                           ENU=Specifies the quantity of the shipped item that has been posted as shipped but that has not yet been posted as invoiced.];
                ApplicationArea=#Service;
                SourceExpr="Qty. Shipped Not Invoiced" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den pÜgëldende vare der allerede er blevet bogfõrt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Service;
                SourceExpr="Quantity Invoiced" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den varepost, som dette dokument eller denne kladdelinje udlignes pÜ.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#Service;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

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
      ServiceShptHeader@1000 : Record 5990;
      ServiceHeader@1001 : Record 5900;
      TempServiceShptLine@1002 : TEMPORARY Record 5991;
      ServiceGetShpt@1003 : Codeunit 5932;
      StyleIsStrong@1004 : Boolean INDATASET;
      DocumentNoHideValue@1005 : Boolean INDATASET;

    [External]
    PROCEDURE SetServiceHeader@1(VAR ServiceHeader2@1000 : Record 5900);
    BEGIN
      ServiceHeader.GET(ServiceHeader2."Document Type",ServiceHeader2."No.");
      ServiceHeader.TESTFIELD("Document Type",ServiceHeader."Document Type"::Invoice);
    END;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    VAR
      ServiceShptLine@1000 : Record 5991;
    BEGIN
      TempServiceShptLine.RESET;
      TempServiceShptLine.COPYFILTERS(Rec);
      TempServiceShptLine.SETRANGE("Document No.","Document No.");
      IF NOT TempServiceShptLine.FINDFIRST THEN BEGIN
        ServiceShptLine.COPYFILTERS(Rec);
        ServiceShptLine.SETRANGE("Document No.","Document No.");
        IF NOT ServiceShptLine.FINDFIRST THEN
          EXIT(FALSE);
        TempServiceShptLine := ServiceShptLine;
        TempServiceShptLine.INSERT;
      END;
      IF "Line No." = TempServiceShptLine."Line No." THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE OKOnPush@19066895();
    BEGIN
      GetShipmentLines;
      CurrPage.CLOSE;
    END;

    [External]
    PROCEDURE GetShipmentLines@3();
    BEGIN
      CurrPage.SETSELECTIONFILTER(Rec);
      ServiceGetShpt.SetServiceHeader(ServiceHeader);
      ServiceGetShpt.CreateInvLines(Rec);
    END;

    BEGIN
    END.
  }
}

