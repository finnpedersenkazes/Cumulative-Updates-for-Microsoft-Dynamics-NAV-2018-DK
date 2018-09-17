OBJECT Page 391 Extended Text List
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
    CaptionML=[DAN=Udvidet tekst - oversigt;
               ENU=Extended Text List];
    SourceTable=Table279;
    DataCaptionFields=No.;
    PageType=List;
    CardPageID=Extended Text;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver indholdet af den forl‘ngede varebeskrivelse.;
                           ENU=Specifies the content of the extended item description.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Suite;
                SourceExpr="Language Code" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal bruges til alle sprogkoder. Hvis der er valgt en sprogkode i feltet Sprogkode tilsides‘ttes den af denne funktion.;
                           ENU=Specifies whether the text should be used for all language codes. If a language code has been chosen in the Language Code field, it will be overruled by this function.];
                ApplicationArea=#Suite;
                SourceExpr="All Language Codes" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en dato, hvorfra teksten skal benyttes p† varen, kontoen, ressourcen eller teksten.;
                           ENU=Specifies a date from which the text will be used on the item, account, resource or standard text.];
                ApplicationArea=#Suite;
                SourceExpr="Starting Date" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en dato, hvorfra teksten ikke l‘ngere skal benyttes p† varen, kontoen, ressourcen eller teksten.;
                           ENU=Specifies a date on which the text will no longer be used on the item, account, resource or standard text.];
                ApplicationArea=#Suite;
                SourceExpr="Ending Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† salgstilbud.;
                           ENU=Specifies whether the text will be available on sales quotes.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Quote";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† salgsfakturaer.;
                           ENU=Specifies whether the text will be available on sales invoices.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Invoice";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† salgsordrer.;
                           ENU=Specifies whether the text will be available on sales orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Order";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† salgskreditnotaer.;
                           ENU=Specifies whether the text will be available on sales credit memos.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Credit Memo";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† k›bsrekvisitioner.;
                           ENU=Specifies whether the text will be available on purchase quotes.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchase Quote";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† k›bsfakturaer.;
                           ENU=Specifies whether the text will be available on purchase invoices.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchase Invoice";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† k›bsordrer.;
                           ENU=Specifies whether the text will be available on purchase orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchase Order";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† k›bskreditnotaer.;
                           ENU=Specifies whether the text will be available on purchase credit memos.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchase Credit Memo";
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

