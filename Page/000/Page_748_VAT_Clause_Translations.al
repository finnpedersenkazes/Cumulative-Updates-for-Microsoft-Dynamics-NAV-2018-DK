OBJECT Page 748 VAT Clause Translations
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Overs‘ttelser af momsklausul;
               ENU=VAT Clause Translations];
    SourceTable=Table561;
    DataCaptionFields=VAT Clause Code;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver overs‘ttelsen af momsklausulbeskrivelsen. Den oversatte version af beskrivelsen vises som momsklausulen baseret p† indstillingen for Sprogkoden p† Debitorkortet.;
                           ENU=Specifies the translation of the VAT clause description. The translated version of the description is displayed as the VAT clause, based on the Language Code setting on the Customer card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver overs‘ttelsen af den ekstra momsklausulbeskrivelse.;
                           ENU=Specifies the translation of the additional VAT clause description.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Description 2" }

    { 6   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 7   ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 8   ;1   ;Part      ;
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

