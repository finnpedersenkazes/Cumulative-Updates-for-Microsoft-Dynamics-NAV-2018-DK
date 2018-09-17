OBJECT Page 5806 Purch. Receipt Lines
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
    CaptionML=[DAN=K�bsmodtagelseslinjer;
               ENU=Purch. Receipt Lines];
    SourceTable=Table121;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport�r,Linje;
                                ENU=New,Process,Report,Line];
    OnInit=BEGIN
             CurrPage.LOOKUPMODE := TRUE;
           END;

    OnOpenPage=BEGIN
                 FILTERGROUP(2);
                 SETRANGE(Type,Type::Item);
                 SETFILTER(Quantity,'<>0');
                 SETRANGE(Correction,FALSE);
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
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 50      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=�bn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 PurchRcptHeader@1001 : Record 120;
                               BEGIN
                                 PurchRcptHeader.GET("Document No.");
                                 PAGE.RUN(PAGE::"Posted Purchase Receipt",PurchRcptHeader);
                               END;
                                }
      { 51      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 6500    ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p� bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      Image=ItemTrackingLines;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
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
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Vendor No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af en liste over k�b, der er bogf�rt.;
                           ENU=Specifies a description of a list of purchases that were posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Location Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder der blev bogf�rt som modtaget eller modtaget og faktureret.;
                           ENU=Specifies how many units were posted as received or received and invoiced.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Quantity }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Direct Unit Cost";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k�bspris, der omfatter indirekte omkostninger, s�som fragt, der er knyttet til k�bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Indirect Cost %";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p�g�ldende vare der allerede er blevet bogf�rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Quantity Invoiced";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p� den ordre, som oprettede posten.;
                           ENU=Specifies the line number of the order that created the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order No.";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p� den ordre, som oprettede posten.;
                           ENU=Specifies the line number of the order that created the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order Line No.";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Item No.";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Cost";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prod. Order No.";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i enheder af den vare, der er modtaget.;
                           ENU=Specifies the quantity per unit of measure of the item that was received.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Qty. per Unit of Measure";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� vare- eller ressourcekortet.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code";
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
      FromPurchRcptLine@1000 : Record 121;
      TempPurchRcptLine@1001 : TEMPORARY Record 121;
      ItemChargeAssgntPurch@1002 : Record 5805;
      AssignItemChargePurch@1003 : Codeunit 5805;
      UnitCost@1004 : Decimal;
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    [External]
    PROCEDURE Initialize@1(NewItemChargeAssgntPurch@1000 : Record 5805;NewUnitCost@1001 : Decimal);
    BEGIN
      ItemChargeAssgntPurch := NewItemChargeAssgntPurch;
      UnitCost := NewUnitCost;
    END;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    VAR
      PurchRcptLine@1000 : Record 121;
    BEGIN
      TempPurchRcptLine.RESET;
      TempPurchRcptLine.COPYFILTERS(Rec);
      TempPurchRcptLine.SETRANGE("Document No.","Document No.");
      IF NOT TempPurchRcptLine.FINDFIRST THEN BEGIN
        FILTERGROUP(2);
        PurchRcptLine.COPYFILTERS(Rec);
        FILTERGROUP(0);
        PurchRcptLine.SETRANGE("Document No.","Document No.");
        IF NOT PurchRcptLine.FINDFIRST THEN
          EXIT(FALSE);
        TempPurchRcptLine := PurchRcptLine;
        TempPurchRcptLine.INSERT;
      END;
      IF "Line No." = TempPurchRcptLine."Line No." THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE LookupOKOnPush@19031339();
    BEGIN
      FromPurchRcptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(FromPurchRcptLine);
      IF FromPurchRcptLine.FINDFIRST THEN BEGIN
        ItemChargeAssgntPurch."Unit Cost" := UnitCost;
        AssignItemChargePurch.CreateRcptChargeAssgnt(FromPurchRcptLine,ItemChargeAssgntPurch);
      END;
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

