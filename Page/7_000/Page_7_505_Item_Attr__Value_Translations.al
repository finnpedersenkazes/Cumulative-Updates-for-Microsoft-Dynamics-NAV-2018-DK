OBJECT Page 7505 Item Attr. Value Translations
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Overs‘ttelser af vareattributv‘rdi;
               ENU=Item Attribute Value Translations];
    SourceTable=Table7503;
    DataCaptionExpr=DynamicCaption;
    DelayedInsert=Yes;
    PageType=List;
    OnAfterGetCurrRecord=BEGIN
                           UpdateWindowCaption
                         END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code";
                LookupPageID=Languages }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det oversatte navn p† vareattributv‘rdien.;
                           ENU=Specifies the translated name of the item attribute value.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

  }
  CODE
  {
    VAR
      DynamicCaption@1000 : Text;

    LOCAL PROCEDURE UpdateWindowCaption@1();
    VAR
      ItemAttributeValue@1000 : Record 7501;
    BEGIN
      IF ItemAttributeValue.GET("Attribute ID",ID) THEN
        DynamicCaption := ItemAttributeValue.Value
      ELSE
        DynamicCaption := '';
    END;

    BEGIN
    END.
  }
}

