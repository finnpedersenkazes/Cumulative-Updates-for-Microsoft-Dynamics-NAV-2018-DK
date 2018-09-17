OBJECT Page 5824 Sales Shipment Lines
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
    CaptionML=[DAN=Salgsleverancelinjer;
               ENU=Sales Shipment Lines];
    SourceTable=Table111;
    PageType=List;
    OnOpenPage=BEGIN
                 IF AssignmentType = AssignmentType::Sale THEN BEGIN
                   SETCURRENTKEY("Sell-to Customer No.");
                   SETRANGE("Sell-to Customer No.",SellToCustomerNo);
                 END;
                 FILTERGROUP(2);
                 SETRANGE(Type,Type::Item);
                 SETFILTER(Quantity,'<>0');
                 SETRANGE(Correction,FALSE);
                 SETRANGE("Job No.",'');
                 FILTERGROUP(0);
               END;

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
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 48      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=�bn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Basic,#Suite;
                      Image=View;
                      OnAction=VAR
                                 SalesShptHeader@1001 : Record 110;
                               BEGIN
                                 SalesShptHeader.GET("Document No.");
                                 PAGE.RUN(PAGE::"Posted Sales Shipment",SalesShptHeader);
                               END;
                                }
      { 49      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
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
                ToolTipML=[DAN=Angiver leverancenummeret.;
                           ENU=Specifies the shipment number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Customer No.";
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

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varen eller finanskontoen eller en beskrivende tekst.;
                           ENU=Specifies the name of the item or general ledger account, or some descriptive text.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

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
                ToolTipML=[DAN=Angiver koden for varens lokation p� den leverancelinje, som er bogf�rt.;
                           ENU=Specifies the code for the location of the item on the shipment line which was posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal angives p� linjen.;
                           ENU=Specifies the number of units of the item specified on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Quantity }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den varepost, som dette dokument eller denne kladdelinje udlignes p�.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#Advanced;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Advanced;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r varerne p� bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en �nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p�g�ldende vare der allerede er blevet bogf�rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Quantity Invoiced" }

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
      FromSalesShptLine@1000 : Record 111;
      TempSalesShptLine@1001 : TEMPORARY Record 111;
      ItemChargeAssgntSales@1002 : Record 5809;
      ItemChargeAssgntPurch@1006 : Record 5805;
      AssignItemChargePurch@1008 : Codeunit 5805;
      AssignItemChargeSales@1003 : Codeunit 5807;
      SellToCustomerNo@1004 : Code[20];
      UnitCost@1005 : Decimal;
      AssignmentType@1007 : 'Sale,Purchase';
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    [External]
    PROCEDURE InitializeSales@1(NewItemChargeAssgnt@1000 : Record 5809;NewSellToCustomerNo@1001 : Code[20];NewUnitCost@1002 : Decimal);
    BEGIN
      ItemChargeAssgntSales := NewItemChargeAssgnt;
      SellToCustomerNo := NewSellToCustomerNo;
      UnitCost := NewUnitCost;
      AssignmentType := AssignmentType::Sale;
    END;

    [External]
    PROCEDURE InitializePurchase@4(NewItemChargeAssgnt@1000 : Record 5805;NewUnitCost@1002 : Decimal);
    BEGIN
      ItemChargeAssgntPurch := NewItemChargeAssgnt;
      UnitCost := NewUnitCost;
      AssignmentType := AssignmentType::Purchase;
    END;

    LOCAL PROCEDURE IsFirstLine@2(DocNo@1000 : Code[20];LineNo@1001 : Integer) : Boolean;
    VAR
      SalesShptLine@1002 : Record 111;
    BEGIN
      TempSalesShptLine.RESET;
      TempSalesShptLine.COPYFILTERS(Rec);
      TempSalesShptLine.SETRANGE("Document No.",DocNo);
      IF NOT TempSalesShptLine.FINDFIRST THEN BEGIN
        SalesShptLine.COPYFILTERS(Rec);
        SalesShptLine.SETRANGE("Document No.",DocNo);
        IF SalesShptLine.FINDFIRST THEN BEGIN
          TempSalesShptLine := SalesShptLine;
          TempSalesShptLine.INSERT;
        END;
      END;
      IF TempSalesShptLine."Line No." = LineNo THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE LookupOKOnPush@19031339();
    BEGIN
      FromSalesShptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(FromSalesShptLine);
      IF FromSalesShptLine.FINDFIRST THEN
        IF AssignmentType = AssignmentType::Sale THEN BEGIN
          ItemChargeAssgntSales."Unit Cost" := UnitCost;
          AssignItemChargeSales.CreateShptChargeAssgnt(FromSalesShptLine,ItemChargeAssgntSales);
        END ELSE
          IF AssignmentType = AssignmentType::Purchase THEN BEGIN
            ItemChargeAssgntPurch."Unit Cost" := UnitCost;
            AssignItemChargePurch.CreateSalesShptChargeAssgnt(FromSalesShptLine,ItemChargeAssgntPurch);
          END;
    END;

    LOCAL PROCEDURE DocumentNoOnFormat@19001080();
    BEGIN
      IF NOT IsFirstLine("Document No.","Line No.") THEN
        DocumentNoHideValue := TRUE;
    END;

    BEGIN
    END.
  }
}

