OBJECT Page 2124 O365 Item Basket Part
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Priser;
               ENU=Prices];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table2101;
    SourceTableView=SORTING(Description);
    PageType=List;
    SourceTableTemporary=Yes;
    OnClosePage=BEGIN
                  IF AnySelectionMade THEN
                    IF CONFIRM(UpdateQst,TRUE) THEN
                      GetSalesLines(GlobalSalesLine);
                END;

    OnFindRecord=VAR
                   Found@1001 : Boolean;
                 BEGIN
                   CopyFiltersToItem(Item);
                   Found := Item.FIND(Which);
                   IF Found THEN
                     CopyFromItem(Item);
                   EXIT(Found);
                 END;

    OnNextRecord=VAR
                   ResultSteps@1000 : Integer;
                 BEGIN
                   CopyFiltersToItem(Item);
                   ResultSteps := Item.NEXT(Steps);
                   IF ResultSteps <> 0 THEN
                     CopyFromItem(Item);
                   EXIT(ResultSteps);
                 END;

    OnAfterGetRecord=BEGIN
                       "Brick Text 2" := '';
                       Quantity := 0;
                       IF TempO365ItemBasketEntry.GET("Item No.") THEN BEGIN
                         IF TempO365ItemBasketEntry."Line Total" <> 0 THEN
                           "Brick Text 2" := FORMAT(TempO365ItemBasketEntry."Line Total",0,'<Precision,2><Standard Format,0>');
                         Quantity := TempO365ItemBasketEntry.Quantity;
                         "Unit Price" := TempO365ItemBasketEntry."Unit Price";
                         Description := TempO365ItemBasketEntry.Description;
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 10      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 11      ;1   ;Action    ;
                      Name=AddToBasket;
                      CaptionML=[DAN=+1;
                                 ENU=+1];
                      ToolTipML=[DAN=Tilf�j en vare til fakturaen.;
                                 ENU=Add an item to the invoice.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Add;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 AddToBasket;
                               END;

                      Gesture=LeftSwipe }
      { 12      ;1   ;Action    ;
                      Name=ReduceBasket;
                      CaptionML=[DAN=-1;
                                 ENU=-1];
                      ToolTipML=[DAN=Fjern en vare fra fakturaen.;
                                 ENU=Remove an item from the invoice.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=RemoveLine;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 RemoveFromBasket;
                               END;

                      Gesture=RightSwipe }
      { 16      ;1   ;Action    ;
                      Name=Card;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p�g�ldende record p� bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Scope=Repeater;
                      OnAction=VAR
                                 Item@1000 : Record 27;
                               BEGIN
                                 IF NOT Item.GET("Item No.") THEN
                                   EXIT;
                                 PAGE.RUNMODAL(PAGE::"O365 Item Card",Item);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 14  ;1   ;Group     ;
                GroupType=Group;
                InstructionalTextML=[DAN=Stryg til h�jre for at tilf�je varer, og stryg til venstre for at fjerne dem;
                                     ENU=Swipe right to add line items, swipe left to remove] }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet for linjen.;
                           ENU=Specifies the quantity for the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=Quantity;
                Style=StandardAccent;
                StyleExpr=TRUE;
                OnValidate=BEGIN
                             ChangeBasket(Quantity - xRec.Quantity);
                           END;
                            }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varenummeret.;
                           ENU=Specifies the item number.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Item No.";
                Editable=false }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varebeskrivelsen.;
                           ENU=Specifies the item description.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Description;
                Editable=false }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enheden for varen.;
                           ENU=Specifies the item unit of measure.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Base Unit of Measure";
                Editable=false }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for �n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f� den angivet i henhold til feltet Avancepct.beregning p� det dertilh�rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit Price";
                AutoFormatType=10;
                AutoFormatExpr='2';
                Editable=false }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et billede af varen.;
                           ENU=Specifies a picture of the item.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Picture }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetotal for denne vare.;
                           ENU=Specifies the line total for this item.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Brick Text 2";
                Editable=false;
                Style=StandardAccent;
                StyleExpr=TRUE }

  }
  CODE
  {
    VAR
      GlobalSalesLine@1001 : Record 37;
      Item@1004 : Record 27;
      TempO365ItemBasketEntry@1000 : TEMPORARY Record 2101;
      AnySelectionMade@1002 : Boolean;
      UpdateQst@1005 : TextConst 'DAN=Vil du opdatere faktura?;ENU=Update invoice?';

    LOCAL PROCEDURE CopyFiltersToItem@7(VAR Item@1000 : Record 27);
    BEGIN
      FILTERGROUP(-1);
      Item.FILTERGROUP(-1);
      COPYFILTER(Description,Item.Description);
      COPYFILTER("Item No.",Item."No.");
      COPYFILTER("Unit Price",Item."Unit Price");
      COPYFILTER("Base Unit of Measure",Item."Base Unit of Measure");
      FILTERGROUP(0);
      Item.FILTERGROUP(0);
      Item.SETCURRENTKEY(Description);
      IF Item.GET("Item No.") THEN;
    END;

    LOCAL PROCEDURE GetBasketEntry@5(VAR O365ItemBasketEntry@1000 : Record 2101);
    BEGIN
      IF O365ItemBasketEntry.GET("Item No.") THEN
        EXIT;
      O365ItemBasketEntry.INIT;
      O365ItemBasketEntry."Item No." := "Item No.";
      O365ItemBasketEntry.Description := Description;
      O365ItemBasketEntry.INSERT;
    END;

    LOCAL PROCEDURE AddToBasket@3();
    BEGIN
      ChangeBasket(1);
    END;

    LOCAL PROCEDURE RemoveFromBasket@4();
    BEGIN
      ChangeBasket(-1);
    END;

    LOCAL PROCEDURE ChangeBasket@17(QuantityChange@1000 : Decimal);
    BEGIN
      GetBasketEntry(TempO365ItemBasketEntry);
      TempO365ItemBasketEntry.Quantity += QuantityChange;
      IF TempO365ItemBasketEntry.Quantity <= 0 THEN
        TempO365ItemBasketEntry.DELETE
      ELSE BEGIN
        TempO365ItemBasketEntry."Unit Price" := "Unit Price";
        TempO365ItemBasketEntry."Line Total" := ROUND(TempO365ItemBasketEntry.Quantity * TempO365ItemBasketEntry."Unit Price");
        TempO365ItemBasketEntry.MODIFY;
      END;
      AnySelectionMade := TRUE;
    END;

    LOCAL PROCEDURE CopyFromItem@6(VAR Item@1000 : Record 27);
    BEGIN
      IF NOT GET(Item."No.") THEN BEGIN
        INIT;
        "Item No." := Item."No.";
        "Unit Price" := Item."Unit Price";
        Description := Item.Description;
        "Base Unit of Measure" := Item."Base Unit of Measure";
        Picture := Item.Picture;
        INSERT;
      END ELSE
        MODIFY;
    END;

    [External]
    PROCEDURE SetSalesLines@1(VAR OrgSalesLine@1000 : Record 37);
    VAR
      SalesHeader@1002 : Record 36;
      SalesLine@1001 : Record 37;
    BEGIN
      TempO365ItemBasketEntry.DELETEALL;
      OrgSalesLine.FILTERGROUP(4);
      IF OrgSalesLine.GETFILTERS = '' THEN
        EXIT;
      IF NOT SalesHeader.GET(OrgSalesLine.GETRANGEMIN("Document Type"),OrgSalesLine.GETRANGEMIN("Document No.")) THEN
        EXIT;
      GlobalSalesLine.COPY(OrgSalesLine);
      OrgSalesLine.FILTERGROUP(0);
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      IF SalesLine.FINDSET THEN
        REPEAT
          TempO365ItemBasketEntry.INIT;
          TempO365ItemBasketEntry."Item No." := SalesLine."No.";
          IF NOT TempO365ItemBasketEntry.FIND THEN
            TempO365ItemBasketEntry.INSERT;
          TempO365ItemBasketEntry.Quantity += SalesLine.Quantity;
          TempO365ItemBasketEntry."Unit Price" := SalesLine."Unit Price";
          TempO365ItemBasketEntry."Line Total" := ROUND(TempO365ItemBasketEntry.Quantity * TempO365ItemBasketEntry."Unit Price");
          TempO365ItemBasketEntry.Description := SalesLine.Description;
          TempO365ItemBasketEntry."Base Unit of Measure" := SalesLine."Unit of Measure";
          TempO365ItemBasketEntry.MODIFY;
        UNTIL SalesLine.NEXT = 0;
    END;

    [External]
    PROCEDURE GetSalesLines@2(VAR OrgSalesLine@1000 : Record 37);
    VAR
      SalesHeader@1002 : Record 36;
      SalesLine@1001 : Record 37;
    BEGIN
      OrgSalesLine.FILTERGROUP(4);
      IF OrgSalesLine.GETFILTERS = '' THEN
        EXIT;
      IF NOT SalesHeader.GET(OrgSalesLine.GETRANGEMIN("Document Type"),OrgSalesLine.GETRANGEMIN("Document No.")) THEN
        EXIT;
      OrgSalesLine.FILTERGROUP(0);
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      SalesLine.DELETEALL(TRUE);
      SalesLine."Document Type" := SalesHeader."Document Type";
      SalesLine."Document No." := SalesHeader."No.";
      SalesLine."Line No." := 0;
      SalesLine.SetHideValidationDialog(TRUE);
      IF TempO365ItemBasketEntry.FINDSET THEN
        REPEAT
          SalesLine.INIT;
          SalesLine."Line No." += 10000;
          SalesLine.Type := SalesLine.Type::Item;
          SalesLine.VALIDATE("No.",TempO365ItemBasketEntry."Item No.");
          SalesLine.Description := TempO365ItemBasketEntry.Description;
          SalesLine.VALIDATE("Unit of Measure",TempO365ItemBasketEntry."Base Unit of Measure");
          SalesLine.VALIDATE("Unit Price",TempO365ItemBasketEntry."Unit Price");
          SalesLine.VALIDATE(Quantity,TempO365ItemBasketEntry.Quantity);
          SalesLine.INSERT;
        UNTIL TempO365ItemBasketEntry.NEXT = 0;
    END;

    BEGIN
    END.
  }
}

