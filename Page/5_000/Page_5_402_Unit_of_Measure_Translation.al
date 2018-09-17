OBJECT Page 5402 Unit of Measure Translation
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Enhedstekst;
               ENU=Unit of Measure Translation];
    SourceTable=Table5402;
    DataCaptionFields=Code;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den m†leenhedskode, som du vil angive en omregning til.;
                           ENU=Specifies the unit of measure code for which you want to enter a translation.];
                ApplicationArea=#Advanced;
                SourceExpr=Code;
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den m†leenhedskode, som svarer til Kode p† det valgte fremmedsprog.;
                           ENU=Specifies the unit of measure code that corresponds to Code in the selected foreign language.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

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

