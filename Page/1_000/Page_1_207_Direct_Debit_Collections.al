OBJECT Page 1207 Direct Debit Collections
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
    CaptionML=[DAN=Direct Debit-opkr‘vninger;
               ENU=Direct Debit Collections];
    SourceTable=Table1207;
    DataCaptionFields=No.,Identifier,Created Date-Time;
    PageType=List;
    ActionList=ACTIONS
    {
      { 14      ;    ;ActionContainer;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ActionContainerType=NewDocumentItems }
      { 15      ;1   ;Action    ;
                      Name=NewCollection;
                      CaptionML=[DAN=Opret Direct Debit-opkr‘vning;
                                 ENU=Create Direct Debit Collection];
                      ToolTipML=[DAN=Opret en Direct Debit-opkr‘vning for at opkr‘ve fakturabetalinger direkte fra en kundes bankkonto p† baggrund af Direct Debit-betalingsaftaler.;
                                 ENU=Create a direct-debit collection to collect invoice payments directly from a customer's bank account based on direct-debit mandates.];
                      ApplicationArea=#Suite;
                      RunObject=Report 1200;
                      Promoted=Yes;
                      Image=NewInvoice }
      { 20      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 21      ;1   ;Action    ;
                      Name=Export;
                      CaptionML=[DAN=Udl‘s Direct Debit-fil;
                                 ENU=Export Direct Debit File];
                      ToolTipML=[DAN=Gem posterne for Direct Debit-opkr‘vningen i en fil, som du sender eller overf›rer til din elektroniske bank til behandling.;
                                 ENU=Save the entries for the direct-debit collection to a file that you send or upload to your electronic bank for processing.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=ExportFile;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Export;
                               END;
                                }
      { 19      ;1   ;Action    ;
                      Name=Close;
                      CaptionML=[DAN=Luk opkr‘vning;
                                 ENU=Close Collection];
                      ToolTipML=[DAN=Luk en Direct Debit-opkr‘vning, s† du kan begynde at bogf›re betalingskvitteringer til relaterede salgsfakturaer. N†r de er afsluttet, kan du ikke registrere betalinger for opkr‘vningen.;
                                 ENU=Close a direct-debit collection so you begin to post payment receipts for related sales invoices. Once closed, you cannot register payments for the collection.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Close;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CloseCollection;
                               END;
                                }
      { 18      ;1   ;Action    ;
                      Name=Post;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r betalingskvitteringer;
                                 ENU=Post Payment Receipts];
                      ToolTipML=[DAN=Bogf›r betalingskvitteringer for salgsfakturaer. Det kan du g›re, efter at Direct Debit-opkr‘vningen er behandlet af banken.;
                                 ENU=Post receipts of a payment for sales invoices. You can do this after the direct-debit collection is successfully processed by the bank.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=ReceivablesPayables;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PostDirectDebitCollection@1000 : Report 1201;
                               BEGIN
                                 TESTFIELD(Status,Status::"File Created");
                                 PostDirectDebitCollection.SetCollectionEntry("No.");
                                 PostDirectDebitCollection.RUN;
                               END;
                                }
      { 16      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 17      ;1   ;Action    ;
                      Name=Entries;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Poster i Direct Debit-opkr‘vning;
                                 ENU=Direct Debit Collect. Entries];
                      ToolTipML=[DAN=Se og rediger poster, der genereres for Direct Debit-opkr‘vningen.;
                                 ENU=View and edit entries that are generated for the direct-debit collection.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1208;
                      RunPageLink=Direct Debit Collection No.=FIELD(No.);
                      Promoted=Yes;
                      Image=EditLines;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sammen med nummerserien, hvilken Direct Debit-opkr‘vning, som posten til Direct Debit-opkr‘vningen tilh›rer.;
                           ENU=Specifies, together with the number series, which direct debit collection a direct-debit collection entry is related to.];
                ApplicationArea=#Suite;
                SourceExpr=Identifier }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Oprettet dato/klokkesl‘t;
                           ENU=Created Date-Time];
                ToolTipML=[DAN=Angiver, hvorn†r Direct Debit-opkr‘vningen blev oprettet.;
                           ENU=Specifies when the direct debit collection was created.];
                ApplicationArea=#Suite;
                SourceExpr=FORMAT("Created Date-Time") }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bruger, som oprettede Direct Debit-opkr‘vningen.;
                           ENU=Specifies which user created the direct debit collection.];
                ApplicationArea=#Suite;
                SourceExpr="Created by User" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for Direct Debit-opkr‘vningen. Du har f›lgende muligheder.;
                           ENU=Specifies the status of the direct debit collection. The following options exist.];
                ApplicationArea=#Suite;
                SourceExpr=Status }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange Direct Debit-transaktioner, der er udf›rt for Direct Debit-opkr‘vningen.;
                           ENU=Specifies how many direct debit transactions have been performed for the direct debit collection.];
                ApplicationArea=#Suite;
                SourceExpr="No. of Transfers" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den bankkonto, som Direct Debit-opkr‘vningen skal overf›res til.;
                           ENU=Specifies the number of the bank account that the direct debit collection will be transferred to.];
                ApplicationArea=#Suite;
                SourceExpr="To Bank Account No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den bankkonto, som Direct Debit-samlingen skal overf›res til.;
                           ENU=Specifies the name of the bank account that the direct debit collection will be transferred to.];
                ApplicationArea=#Suite;
                SourceExpr="To Bank Account Name" }

    { 11  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 12  ;1   ;Part      ;
                PartType=System;
                SystemPartID=Notes }

    { 13  ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {

    BEGIN
    END.
  }
}

