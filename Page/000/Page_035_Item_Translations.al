OBJECT Page 35 Item Translations
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varetekster;
               ENU=Item Translations];
    SourceTable=Table30;
    DataCaptionFields=Item No.;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nummer p† kortet.;
                           ENU=Specifies the item number of the item on the card.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varebeskrivelsen, der skal bruges, n†r denne sprogkode er markeret.;
                           ENU=Specifies the item description to use when this language code is selected.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver flere oplysninger om varen.;
                           ENU=Specifies more information about the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Description 2";
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

    BEGIN
    END.
  }
}

