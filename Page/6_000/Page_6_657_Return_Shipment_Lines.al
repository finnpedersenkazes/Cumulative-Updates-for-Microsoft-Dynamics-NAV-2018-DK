OBJECT Page 6657 Return Shipment Lines
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
    CaptionML=[DAN=Returvarelev.linjer;
               ENU=Return Shipment Lines];
    SourceTable=Table6651;
    PageType=List;
    OnOpenPage=BEGIN
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
                      ApplicationArea=#PurchReturnOrder;
                      Image=View;
                      OnAction=VAR
                                 ReturnShptHeader@1001 : Record 6650;
                               BEGIN
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
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Buy-from Vendor No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#PurchReturnOrder;
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
                ApplicationArea=#PurchReturnOrder;
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
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren p� salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af enheder af varen, finanskontoen eller varegebyret p� linjen.;
                           ENU=Specifies the number of units of the item, general ledger account, or item charge on the line.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=Quantity }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Unit of Measure Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den varepost, som dette dokument eller denne kladdelinje udlignes p�.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Prod. Order No." }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p�g�ldende vare der allerede er blevet bogf�rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#PurchReturnOrder;
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
      FromReturnShptLine@1000 : Record 6651;
      TempReturnShptLine@1001 : TEMPORARY Record 6651;
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

    LOCAL PROCEDURE IsFirstLine@2(DocNo@1000 : Code[20];LineNo@1001 : Integer) : Boolean;
    VAR
      ReturnShptLine@1002 : Record 6651;
    BEGIN
      TempReturnShptLine.RESET;
      TempReturnShptLine.COPYFILTERS(Rec);
      TempReturnShptLine.SETRANGE("Document No.",DocNo);
      IF NOT TempReturnShptLine.FINDFIRST THEN BEGIN
        ReturnShptLine.COPYFILTERS(Rec);
        ReturnShptLine.SETRANGE("Document No.",DocNo);
        ReturnShptLine.FINDFIRST;
        TempReturnShptLine := ReturnShptLine;
        TempReturnShptLine.INSERT;
      END;
      IF TempReturnShptLine."Line No." = LineNo THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE LookupOKOnPush@19031339();
    BEGIN
      FromReturnShptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(FromReturnShptLine);
      IF FromReturnShptLine.FINDFIRST THEN BEGIN
        ItemChargeAssgntPurch."Unit Cost" := UnitCost;
        AssignItemChargePurch.CreateShptChargeAssgnt(FromReturnShptLine,ItemChargeAssgntPurch);
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

