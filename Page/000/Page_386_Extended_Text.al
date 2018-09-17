OBJECT Page 386 Extended Text
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udvidet tekst;
               ENU=Extended Text];
    SourceTable=Table279;
    DataCaptionExpr=GetCaption;
    PopulateAllFields=Yes;
    PageType=ListPlus;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der bruges ved overs‘ttelse af angivet tekst i bilag til udenlandske forretningspartnere, f.eks. en beskrivelse af varen p† en ordrebekr‘ftelse.;
                           ENU=Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.];
                ApplicationArea=#Suite;
                SourceExpr="Language Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal bruges til alle sprogkoder. Hvis der er valgt en sprogkode i feltet Sprogkode tilsides‘ttes den af denne funktion.;
                           ENU=Specifies whether the text should be used for all language codes. If a language code has been chosen in the Language Code field, it will be overruled by this function.];
                ApplicationArea=#Suite;
                SourceExpr="All Language Codes" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver indholdet af den forl‘ngede varebeskrivelse.;
                           ENU=Specifies the content of the extended item description.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en dato, hvorfra teksten skal benyttes p† varen, kontoen, ressourcen eller teksten.;
                           ENU=Specifies a date from which the text will be used on the item, account, resource or standard text.];
                ApplicationArea=#Suite;
                SourceExpr="Starting Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en dato, hvorfra teksten ikke l‘ngere skal benyttes p† varen, kontoen, ressourcen eller teksten.;
                           ENU=Specifies a date on which the text will no longer be used on the item, account, resource or standard text.];
                ApplicationArea=#Suite;
                SourceExpr="Ending Date" }

    { 25  ;1   ;Part      ;
                ApplicationArea=#Suite;
                SubPageLink=Table Name=FIELD(Table Name),
                            No.=FIELD(No.),
                            Language Code=FIELD(Language Code),
                            Text No.=FIELD(Text No.);
                PagePartID=Page387 }

    { 1904305601;1;Group  ;
                CaptionML=[DAN=Salg;
                           ENU=Sales] }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† salgstilbud.;
                           ENU=Specifies whether the text will be available on sales quotes.];
                ApplicationArea=#Suite;
                SourceExpr="Sales Quote";
                Importance=Additional }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† salgsrammeordrer.;
                           ENU=Specifies whether the text will be available on sales blanket orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Blanket Order";
                Importance=Additional }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† salgsordrer.;
                           ENU=Specifies whether the text will be available on sales orders.];
                ApplicationArea=#Suite;
                SourceExpr="Sales Order";
                Importance=Additional }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† salgsfakturaer.;
                           ENU=Specifies whether the text will be available on sales invoices.];
                ApplicationArea=#Suite;
                SourceExpr="Sales Invoice" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† salgsreturvareordrer.;
                           ENU=Specifies whether the text will be available on sales return orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Return Order";
                Importance=Additional }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† salgskreditnotaer.;
                           ENU=Specifies whether the text will be available on sales credit memos.];
                ApplicationArea=#Suite;
                SourceExpr="Sales Credit Memo" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den udvidede tekst skal vises p† rykkere.;
                           ENU=Specifies whether the extended text will be available on reminders.];
                ApplicationArea=#Advanced;
                SourceExpr=Reminder }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den udvidede tekst skal vises p† rentenotaer.;
                           ENU=Specifies whether the extended text will be available on finance charge memos.];
                ApplicationArea=#Advanced;
                SourceExpr="Finance Charge Memo" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† forudbetalingssalgsfakturaer.;
                           ENU=Specifies whether the text will be available on prepayment sales invoices.];
                ApplicationArea=#Advanced;
                SourceExpr="Prepmt. Sales Invoice";
                Importance=Additional }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† forudbetalingssalgskreditnotaer.;
                           ENU=Specifies whether the text will be available on prepayment sales credit memos.];
                ApplicationArea=#Advanced;
                SourceExpr="Prepmt. Sales Credit Memo";
                Importance=Additional }

    { 1907458401;1;Group  ;
                CaptionML=[DAN=K›b;
                           ENU=Purchases] }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† k›bsrekvisitioner.;
                           ENU=Specifies whether the text will be available on purchase quotes.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchase Quote" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† k›bsrammeordrer.;
                           ENU=Specifies whether the text will be available on purchase blanket orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchase Blanket Order" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† k›bsordrer.;
                           ENU=Specifies whether the text will be available on purchase orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchase Order" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† k›bsfakturaer.;
                           ENU=Specifies whether the text will be available on purchase invoices.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchase Invoice" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† k›bsreturvareordrer.;
                           ENU=Specifies whether the text will be available on purchase return orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchase Return Order" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† k›bskreditnotaer.;
                           ENU=Specifies whether the text will be available on purchase credit memos.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchase Credit Memo" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† forudbetalingsk›bsfakturaer.;
                           ENU=Specifies whether the text will be available on prepayment purchase invoices.];
                ApplicationArea=#Advanced;
                SourceExpr="Prepmt. Purchase Invoice" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om teksten skal vises p† forudbetalingsk›bskreditnotaer.;
                           ENU=Specifies whether the text will be available on prepayment purchase credit memos.];
                ApplicationArea=#Advanced;
                SourceExpr="Prepmt. Purchase Credit Memo" }

    { 1902138501;1;Group  ;
                CaptionML=[DAN=Service;
                           ENU=Service] }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den udvidede tekst for en vare, konto eller andre faktorer vil v‘re tilg‘ngelig p† servicelinjerne i serviceordrer.;
                           ENU=Specifies that the extended text for an item, account or other factor will be available on service lines in service orders.];
                ApplicationArea=#Service;
                SourceExpr="Service Quote" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den udvidede tekst for en vare, konto eller andre faktorer vil v‘re tilg‘ngelig p† servicelinjerne i serviceordrer.;
                           ENU=Specifies that the extended text for an item, account or other factor will be available on service lines in service orders.];
                ApplicationArea=#Service;
                SourceExpr="Service Order" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den udvidede tekst for en vare, konto eller andre faktorer vil v‘re tilg‘ngelig p† servicelinjerne i serviceordrer.;
                           ENU=Specifies that the extended text for an item, account or other factor will be available on service lines in service orders.];
                ApplicationArea=#Service;
                SourceExpr="Service Invoice" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den udvidede tekst for en vare, konto eller andre faktorer vil v‘re tilg‘ngelig p† servicelinjerne i serviceordrer.;
                           ENU=Specifies that the extended text for an item, account or other factor will be available on service lines in service orders.];
                ApplicationArea=#Service;
                SourceExpr="Service Credit Memo" }

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

