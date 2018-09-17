OBJECT Page 7502 Item Attribute Translations
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Overs‘ttelser af vareattribut;
               ENU=Item Attribute Translations];
    SourceTable=Table7502;
    DataCaptionFields=Attribute ID;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code";
                LookupPageID=Languages }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det oversatte navn p† vareattributten.;
                           ENU=Specifies the translated name of the item attribute.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

  }
  CODE
  {

    BEGIN
    END.
  }
}

