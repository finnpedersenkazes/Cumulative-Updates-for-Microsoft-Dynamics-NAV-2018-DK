OBJECT Page 6667 Return Receipt Lines
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
    CaptionML=[DAN=Returvaremodtagelseslinjer;
               ENU=Return Receipt Lines];
    SourceTable=Table6661;
    PageType=List;
    OnOpenPage=BEGIN
                 IF AssignmentType = AssignmentType::Sale THEN
                   SETRANGE("Sell-to Customer No.",SellToCustomerNo);
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
                      ApplicationArea=#SalesReturnOrder;
                      Image=View;
                      OnAction=VAR
                                 ReturnRcptHeader@1001 : Record 6660;
                               BEGIN
                                 ReturnRcptHeader.GET("Document No.");
                                 PAGE.RUN(PAGE::"Posted Return Receipt",ReturnRcptHeader);
                               END;
                                }
      { 49      ;2   ;Action    ;
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
                ToolTipML=[DAN=Angiver nummeret p� debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Customer No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Customer No.";
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
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l�gges p� lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af enheder af varen, finanskontoen eller varegebyret p� linjen.;
                           ENU=Specifies the number of units of the item, general ledger account, or item charge on the line.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=Quantity }

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

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p�g�ldende vare der allerede er blevet bogf�rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#SalesReturnOrder;
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
      FromReturnRcptLine@1000 : Record 6661;
      TempReturnRcptLine@1001 : TEMPORARY Record 6661;
      ItemChargeAssgntSales@1002 : Record 5809;
      ItemChargeAssgntPurch@1006 : Record 5805;
      AssignItemChargeSales@1003 : Codeunit 5807;
      AssignItemChargePurch@1008 : Codeunit 5805;
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
    PROCEDURE InitializePurchase@3(NewItemChargeAssgnt@1000 : Record 5805;NewUnitCost@1001 : Decimal);
    BEGIN
      ItemChargeAssgntPurch := NewItemChargeAssgnt;
      UnitCost := NewUnitCost;
      AssignmentType := AssignmentType::Purchase;
    END;

    LOCAL PROCEDURE IsFirstLine@2(DocNo@1000 : Code[20];LineNo@1001 : Integer) : Boolean;
    VAR
      ReturnRcptLine@1002 : Record 6661;
    BEGIN
      TempReturnRcptLine.RESET;
      TempReturnRcptLine.COPYFILTERS(Rec);
      TempReturnRcptLine.SETRANGE("Document No.",DocNo);
      IF NOT TempReturnRcptLine.FINDFIRST THEN BEGIN
        ReturnRcptLine.COPYFILTERS(Rec);
        ReturnRcptLine.SETRANGE("Document No.",DocNo);
        ReturnRcptLine.FINDFIRST;
        TempReturnRcptLine := ReturnRcptLine;
        TempReturnRcptLine.INSERT;
      END;
      IF TempReturnRcptLine."Line No." = LineNo THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE LookupOKOnPush@19031339();
    BEGIN
      FromReturnRcptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(FromReturnRcptLine);
      IF FromReturnRcptLine.FINDFIRST THEN
        // CETAF start
        IF AssignmentType = AssignmentType::Sale THEN BEGIN
          ItemChargeAssgntSales."Unit Cost" := UnitCost;
          AssignItemChargeSales.CreateRcptChargeAssgnt(FromReturnRcptLine,ItemChargeAssgntSales);
        END ELSE
          IF AssignmentType = AssignmentType::Purchase THEN BEGIN
            ItemChargeAssgntPurch."Unit Cost" := UnitCost;
            AssignItemChargePurch.CreateReturnRcptChargeAssgnt(FromReturnRcptLine,ItemChargeAssgntPurch);
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

