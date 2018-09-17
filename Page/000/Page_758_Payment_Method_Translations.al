OBJECT Page 758 Payment Method Translations
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Overs‘ttelser af betalingsform;
               ENU=Payment Method Translations];
    SourceTable=Table466;
    DataCaptionFields=Payment Method Code;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i dokumenter til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to business partners abroad, such as an item description on an order confirmation.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transaktionen for betalingsformen.;
                           ENU=Specifies the translation of the payment method.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 3   ;    ;Container ;
                ContainerType=FactBoxArea }

    { 6   ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 7   ;1   ;Part      ;
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

