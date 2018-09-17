OBJECT Page 5749 Transfer Lines
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
    CaptionML=[DAN=Overflytningslinjer;
               ENU=Transfer Lines];
    SourceTable=Table5741;
    PageType=List;
    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 7       ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis dokument;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=View;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 TransferHeader@1000 : Record 5740;
                               BEGIN
                                 TransferHeader.GET("Document No.");
                                 PAGE.RUN(PAGE::"Transfer Order",TransferHeader);
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
                ToolTipML=[DAN=Angiver det bilagsnummer, der er knyttet til linjen eller posten.;
                           ENU=Specifies the document number that is associated with the line or entry.];
                ApplicationArea=#Location;
                SourceExpr="Document No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, der overflyttes.;
                           ENU=Specifies the number of the item that is transferred.];
                ApplicationArea=#Location;
                SourceExpr="Item No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of the item.];
                ApplicationArea=#Location;
                SourceExpr=Description }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Location;
                SourceExpr="Shipment Date" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, der er i transit.;
                           ENU=Specifies the quantity of the item that is in transit.];
                ApplicationArea=#Location;
                SourceExpr="Qty. in Transit" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der mangler at blive afsendt.;
                           ENU=Specifies the quantity of the items that remains to be shipped.];
                ApplicationArea=#Location;
                SourceExpr="Outstanding Quantity" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Location;
                SourceExpr="Unit of Measure" }

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

    BEGIN
    END.
  }
}

