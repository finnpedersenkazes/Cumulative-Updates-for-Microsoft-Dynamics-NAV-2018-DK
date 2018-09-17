OBJECT Page 459 Sales & Receivables Setup
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019,NAVDK11.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ops‘tning af Salg;
               ENU=Sales & Receivables Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table311;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚r,Debitorgrupper,Betalinger;
                                ENU=New,Process,Report,Customer Groups,Payments];
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
               END;

    ActionList=ACTIONS
    {
      { 47      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 45      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorbogf›ringsgrupper;
                                 ENU=Customer Posting Groups];
                      ToolTipML=[DAN=Ops‘t de bogf›ringsgrupper, du kan v‘lge mellem, n†r du ops‘tter debitorkort, der skal knytte forretningstransaktioner for debitoren til den relevante finanskonto.;
                                 ENU=Set up the posting groups to select from when you set up customer cards to link business transactions made for the customer with the appropriate account in the general ledger.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 110;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CustomerGroup;
                      PromotedCategory=Category4 }
      { 43      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorprisgrupper;
                                 ENU=Customer Price Groups];
                      ToolTipML=[DAN=Ops‘t de bogf›ringsgrupper, du kan v‘lge mellem, n†r du ops‘tter debitorkort, der skal knytte forretningstransaktioner for debitoren til den relevante finanskonto.;
                                 ENU=Set up the posting groups to select from when you set up customer cards to link business transactions made for the customer with the appropriate account in the general ledger.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Price;
                      PromotedCategory=Category4 }
      { 54      ;1   ;Action    ;
                      CaptionML=[DAN=Debitorrabatgrupper;
                                 ENU=Customer Disc. Groups];
                      ToolTipML=[DAN=Ops‘t rabatgruppekoder, som du kan bruge som kriterier, n†r du definerer s‘rlige rabatter p† et debitor-, kreditor- eller varekort.;
                                 ENU=Set up discount group codes that you can use as criteria when you define special discounts on a customer, vendor, or item card.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 512;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Discount;
                      PromotedCategory=Category4 }
      { 53      ;1   ;ActionGroup;
                      CaptionML=[DAN=Betaling;
                                 ENU=Payment] }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Ops‘tning af betalingsregistrering;
                                 ENU=Payment Registration Setup];
                      ToolTipML=[DAN=Ops‘t den betalingskladdetype og den modkonto, der skal bruges til at bogf›re modtagne debitorbetalinger. Definer, hvordan du foretr‘kker at behandle debitorbetalinger i vinduet Betalingsregistrering.;
                                 ENU=Set up the payment journal template and the balancing account that is used to post received customer payments. Define how you prefer to process customer payments in the Payment Registration window.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 982;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PaymentJournal;
                      PromotedCategory=Category5 }
      { 51      ;2   ;Action    ;
                      CaptionML=[DAN=Betalingsformer;
                                 ENU=Payment Methods];
                      ToolTipML=[DAN=Ops‘t de betalingsmetoder, du kan v‘lge mellem p† debitorkortet for at definere, hvordan debitoren skal betale, f.eks. via bankoverf›rsel.;
                                 ENU=Set up the payment methods that you select from the customer card to define how the customer must pay, for example by bank transfer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 427;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Payment;
                      PromotedCategory=Category5 }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Betalingsbetingelser;
                                 ENU=Payment Terms];
                      ToolTipML=[DAN=Ops‘t de betalingsbetingelser, du kan v‘lge mellem p† debitorkort for at definere, hvorn†r debitoren skal betale, f.eks. inden for 14 dage.;
                                 ENU=Set up the payment terms that you select from on customer cards to define when the customer must pay, such as within 14 days.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 4;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Payment;
                      PromotedCategory=Category5 }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Rentebetingelser;
                                 ENU=Finance Charge Terms];
                      ToolTipML=[DAN=Ops‘t de rentebetingelser, du kan v‘lge mellem p† debitorkort for at definere, hvordan renten beregnes, hvis debitorens betaling er forsinket.;
                                 ENU=Set up the finance charge terms that you select from on customer cards to define how to calculate interest in case the customer's payment is late.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 6;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=FinChargeMemo;
                      PromotedCategory=Category5 }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Rykkerbetingelser;
                                 ENU=Reminder Terms];
                      ToolTipML=[DAN=Ops‘t de rykkerbetingelser, du kan v‘lge mellem p† debitorkort for at definere, hvorn†r og hvordan debitoren skal rykkes for forsinkede betalinger.;
                                 ENU=Set up reminder terms that you select from on customer cards to define when and how to remind the customer of late payments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 431;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReminderTerms;
                      PromotedCategory=Category5 }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Afrundingsmetoder;
                                 ENU=Rounding Methods];
                      ToolTipML=[DAN=Definer, hvordan bel›b afrundes, n†r du bruger funktioner til at regulere eller foresl† varepriser eller standardomkostninger.;
                                 ENU=Define how amounts are rounded when you use functions to adjust or suggest item prices or standard costs.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 65;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Calculate;
                      PromotedCategory=Category5 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type salgsrabatter der skal bogf›res separat. Ingen rabat: Rabatter bogf›res ikke separat, men skal i stedet fratr‘kke rabatten inden bogf›ringen. Fakturarabatter: Fakturarabatten og fakturabel›bet bogf›res samtidigt, baseret p† feltet Salgsfakturarabatkonto i vinduet Bogf›ringsops‘tning. Linjerabatter: Linjerabatten og fakturabel›bet bogf›res samtidigt, baseret p† feltet Salgslinjerabatkonto i vinduet Bogf›ringsops‘tning. Alle rabatter: Faktura- og linjerabatterne samt fakturabel›bet bogf›res samtidigt, baseret p† feltet Salgsfakturarabatkonto og feltet Salgslinjerabatkonto i vinduet Bogf›ringsops‘tning.;
                           ENU=Specifies the type of sales discounts to post separately. No Discounts: Discounts are not posted separately but instead will subtract the discount before posting. Invoice Discounts: The invoice discount and invoice amount are posted simultaneously, based on the Sales Inv. Disc. Account field in the General Posting Setup window. Line Discounts: The line discount and the invoice amount will be posted simultaneously, based on Sales Line Disc. Account field in the General Posting Setup window. All Discounts: The invoice and line discounts and the invoice amount will be posted simultaneously, based on the Sales Inv. Disc. Account field and Sales Line. Disc. Account fields in the General Posting Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Discount Posting" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil have vist en advarsel om debitors status i forbindelse med oprettelsen af en ordre eller en faktura.;
                           ENU=Specifies whether to warn about the customer's status when you create a sales order or invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Warnings" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en advarsel skal vises, n†r du angiver et antal i et salgsdokument, der bringer varens lagerniveau under nul.;
                           ENU=Specifies if a warning is displayed when you enter a quantity on a sales document that brings the item's inventory level below zero.];
                ApplicationArea=#Advanced;
                SourceExpr="Stockout Warning" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en bogf›rt leverance, og en bogf›rt faktura oprettes automatisk, n†r du bogf›rer en faktura.;
                           ENU=Specifies that a posted shipment and a posted invoice are automatically created when you post an invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment on Invoice";
                Importance=Additional }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en bogf›rt returvaremodtagelse, og en bogf›rt salgskreditnota oprettes automatisk, n†r du bogf›rer en kreditnota.;
                           ENU=Specifies that a posted return receipt and a posted sales credit memo are automatically created when you post a credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Return Receipt on Credit Memo";
                Importance=Additional }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at bel›bene afrundes for salgsfakturaerne.;
                           ENU=Specifies that amounts are rounded for sales invoices.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoice Rounding" }

    { 666 ;2   ;Field     ;
                Name=DefaultItemQuantity;
                CaptionML=[DAN=Standardvareantal;
                           ENU=Default Item Quantity];
                ToolTipML=[DAN=Angiver, at feltet Antal indstilles til 1, n†r du udfylder feltet Varenr.;
                           ENU=Specifies that the Quantity field is set to 1 when you fill the Item No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default Item Quantity" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om systemet vil foresl† at oprette en ny vare, n†r ingen varer matcher beskrivelsen. BEM’RK: Med denne indstilling kan du ikke tilf›je en ikke-transaktionsbaseret tekstlinje ved kun at udfylde feltet Beskrivelse.;
                           ENU=Specifies whether the system will suggest to create a new item when no item matches the description. NOTE: With this setting, you cannot add a non-transactional text line by filling in the Description field only.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Create Item from Description" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der altid skal inds‘ttes et eksternt bilagsnummer i feltet Eksternt bilagsnr. p† et salgshoved eller i feltet Eksternt bilagsnr. p† en finanskladdelinjen.;
                           ENU=Specifies whether it is mandatory to enter an external document number in the External Document No. field on a sales header or the External Document No. field on a general journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ext. Doc. No. Mandatory";
                Importance=Additional }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om det er tilladt at anvende debitorbetalinger i forskellige valutaer.;
                           ENU=Specifies whether it is allowed to apply customer payments in different currencies.];
                ApplicationArea=#Suite;
                SourceExpr="Appln. between Currencies" }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dit firmalogos placering p† forretningsbreve og -bilag.;
                           ENU=Specifies the position of your company logo on business letters and documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Logo Position on Documents" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanskonto, der skal bruges til fragtomkostninger.;
                           ENU=Specifies the general ledger account that must be used for freight charges.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Freight G/L Acc. No." }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan feltet Bogf›ringsdato skal bruges i salgsbilag.;
                           ENU=Specifies how to use the Posting Date field on sales documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default Posting Date" }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den standardv‘rdi, der inds‘ttes i feltet Lever (antal) p† salgsordrelinjerne og i feltet Antal til modtagelse retur p† salgsreturvareordrelinjerne.;
                           ENU=Specifies the default value that is inserted in the Qty. to Ship field on sales order lines and in the Return Qty. to Receive field on sales return order lines.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default Quantity to Ship";
                Importance=Additional }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bem‘rkninger skal kopieres automatisk fra rammeordrer til salgsordrer.;
                           ENU=Specifies whether to copy comments from blanket orders to sales orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Copy Comments Blanket to Order";
                Importance=Additional }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bem‘rkninger skal kopieres automatisk fra salgsordrer til salgsfakturaer.;
                           ENU=Specifies whether to copy comments from sales orders to sales invoices.];
                ApplicationArea=#Advanced;
                SourceExpr="Copy Comments Order to Invoice";
                Importance=Additional }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bem‘rkninger skal kopieres automatisk fra salgsordrer til salgsleverancer.;
                           ENU=Specifies whether to copy comments from sales orders to shipments.];
                ApplicationArea=#Advanced;
                SourceExpr="Copy Comments Order to Shpt.";
                Importance=Additional }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bem‘rkninger skal kopieres automatisk fra salgsreturvareordrer til salgskreditnotaer.;
                           ENU=Specifies whether to copy comments from sales return orders to sales credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Copy Cmts Ret.Ord. to Cr. Memo";
                Importance=Additional }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at bem‘rkninger kopieres fra salgskreditnotaen til den bogf›rte returvaremodtagelse.;
                           ENU=Specifies that comments are copied from the sales credit memo to the posted return receipt.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Copy Cmts Ret.Ord. to Ret.Rcpt";
                Importance=Additional }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om manuel regulering af momsbel›b i salgstyper skal tillades.;
                           ENU=Specifies whether to allow the manual adjustment of VAT amounts in sales documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow VAT Difference" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturarabatbel›bet skal beregnes automatisk med salgsdokumenter.;
                           ENU=Specifies whether the invoice discount amount is automatically calculated with sales documents.];
                ApplicationArea=#Advanced;
                SourceExpr="Calc. Inv. Discount" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at fakturarabatbel›bet beregnes i henhold til moms-id'et.;
                           ENU=Specifies that the invoice discount is calculated according to VAT Identifier.];
                ApplicationArea=#Advanced;
                SourceExpr="Calc. Inv. Disc. per VAT ID";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en momsvirksomhedsbogf›ringsgruppe for debitorer, som vareprisen, inkl. moms, skal anvendes p†.;
                           ENU=Specifies a VAT business posting group for customers for whom you want the item price including VAT, to apply.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Gr. (Price)" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en returtransaktion ikke vil blive bogf›rt, medmindre feltet Udlign fra-varepost p† salgsordrelinjen angiver en post.;
                           ENU=Specifies that a return transaction cannot be posted unless the Appl.-from Item Entry field on the sales order line Specifies an entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Exact Cost Reversing Mandatory";
                Importance=Additional }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du ikke kan levere eller fakturere en ordre med et forudbetalingsbel›b, der ikke er betalt.;
                           ENU=Specifies that you cannot ship or invoice an order that has an unpaid prepayment amount.];
                ApplicationArea=#Prepayments;
                SourceExpr="Check Prepmt. when Posting";
                Importance=Additional }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil arkivere salgstilbud og salgsordrer automatisk, n†r en salgstilbud/salgsordre slettes.;
                           ENU=Specifies whether to automatically archive sales quotes and sales orders when a sales quote/order is deleted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Archive Quotes and Orders";
                Importance=Additional }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om og hvorn†r bogf›rte salgsdokumenter kan slettes. Hvis du angiver en dato, kan de bogf›rte salgsdokumenter med en bogf›ringsdato p† eller efter denne dato ikke slettes.;
                           ENU=Specifies if and when posted sales documents can be deleted. If you enter a date, posted sales documents with a posting date on or after this date cannot be deleted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow Document Deletion Before";
                Importance=Additional }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Specifies if changes to addresses made on sales documents are copied to the customer card. By default, changes are copied to the customer card.;
                           ENU=Specifies if changes to addresses made on sales documents are copied to the customer card. By default, changes are copied to the customer card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ignore Updated Addresses" }

    { 1900309501;1;Group  ;
                CaptionML=[DAN=Dimensioner;
                           ENU=Dimensions] }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dimensionskoden for debitorgrupperne i analyserapporten.;
                           ENU=Specifies the dimension code for customer groups in your analysis report.];
                ApplicationArea=#Dimensions;
                SourceExpr="Customer Group Dimension Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dimensionskoden for s‘lgere i analyserapporten;
                           ENU=Specifies the dimension code for salespeople in your analysis report];
                ApplicationArea=#Dimensions;
                SourceExpr="Salesperson Dimension Code" }

    { 1904569201;1;Group  ;
                CaptionML=[DAN=Nummerserie;
                           ENU=Number Series];
                GroupType=Group }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til debitorer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to customers.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Nos." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til salgstilbud.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to sales quotes.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Quote Nos." }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til rammesalgsordrer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to blanket sales orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order Nos." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til salgsordrer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to sales orders.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Order Nos." }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der bruges til at tildele numre til nye returvareordrer.;
                           ENU=Specifies the number series that is used to assign numbers to new sales return orders.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Order Nos." }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til salgsfakturaer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to sales invoices.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoice Nos." }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til salgsfakturaer, n†r de er bogf›rte.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to sales invoices when they are posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posted Invoice Nos." }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til salgskreditnotaer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to sales credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Memo Nos." }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til salgskreditnotaer, n†r de er bogf›rte.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to sales credit memos when they are posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posted Credit Memo Nos." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til salgsleverancer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to shipments.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posted Shipment Nos." }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til bogf›rte returvaremodtagelser.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to posted return receipts.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Posted Return Receipt Nos." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til rykkere.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to reminders.];
                ApplicationArea=#Advanced;
                SourceExpr="Reminder Nos." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til rykkere, n†r de udstedes.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to reminders when they are issued.];
                ApplicationArea=#Advanced;
                SourceExpr="Issued Reminder Nos." }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til rentenotaer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to finance charge memos.];
                ApplicationArea=#Advanced;
                SourceExpr="Fin. Chrg. Memo Nos." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til rentenotaer, n†r de udstedes.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to finance charge memos when they are issued.];
                ApplicationArea=#Advanced;
                SourceExpr="Issued Fin. Chrg. M. Nos." }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til salgsforudbetalingsfakturaer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to sales prepayment invoices.];
                ApplicationArea=#Prepayments;
                SourceExpr="Posted Prepmt. Inv. Nos." }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der bruges til at tildele numre til salgsforudbetalingskreditnotaer, n†r de er bogf›rte.;
                           ENU=Specifies the code for the number series that is used to assign numbers to sales prepayment credit memos when they are posted.];
                ApplicationArea=#Prepayments;
                SourceExpr="Posted Prepmt. Cr. Memo Nos." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummerserien p† Direct Debit-betalingsaftalen.;
                           ENU=Specifies the number series for direct-debit mandates.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Debit Mandate Nos." }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Baggrundsbogf›ring;
                           ENU=Background Posting];
                GroupType=Group }

    { 23  ;2   ;Group     ;
                CaptionML=[DAN=Bogf›r;
                           ENU=Post];
                GroupType=Group }

    { 19  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om forretningsprocessen bruger sagsk›er i baggrunden til at bogf›re salgs- og k›bsdokumenter, inklusive ordrer, fakturaer, returvareordrer og kreditnotaer.;
                           ENU=Specifies if your business process uses job queues in the background to post sales and purchase documents, including orders, invoices, return orders, and credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post with Job Queue" }

    { 17  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver prioriteten p† sagsk›en, n†r den k›res i forbindelse med baggrundsbogf›ring. Du kan angive forskellige prioriteter for bogf›ringen samt bogf›rings- og udskriftsindstillinger. Standardindstillingen er 1000.;
                           ENU=Specifies the priority of the job queue when you run it in the context of background posting. You can set different priorities for the post and post and print settings. The default setting is 1000.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Job Queue Priority for Post" }

    { 13  ;2   ;Group     ;
                CaptionML=[DAN=Bogf›r & udskriv;
                           ENU=Post & Print];
                GroupType=Group }

    { 15  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om forretningsprocessen bruger opgavek›er til at bogf›re og udskrive salgsdokumenter.;
                           ENU=Specifies if your business process uses job queues to post and print sales documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post & Print with Job Queue" }

    { 11  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver prioriteten p† sagsk›en, n†r den k›res i forbindelse med baggrundsbogf›ring. Du kan angive forskellige prioriteter for bogf›ringen samt bogf›rings- og udskriftsindstillinger. Standardindstillingen er 1000.;
                           ENU=Specifies the priority of the job queue when you run it in the context of background posting. You can set different priorities for the post and post and print settings. The default setting is 1000.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Job Q. Prio. for Post & Print" }

    { 7   ;2   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 5   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den sagsk›kategori, som du vil tilknytte med baggrundsbogf›ringen.;
                           ENU=Specifies the code for the category of the job queue that you want to associate with background posting.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Job Queue Category Code" }

    { 4   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om der afsendes en notifikation, n†r bogf›ringen og udskrivningen er fuldf›rt.;
                           ENU=Specifies if a notification is sent when posting and printing is successfully completed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Notify On Success" }

    { 1903305101;1;Group  ;
                CaptionML=[DAN=OIOUBL;
                           ENU=OIOUBL] }

    { 1060001;2;Field     ;
                ToolTipML=[DAN=Angiver den standardprofil, som du vil bruge til de elektroniske dokumenter, som du sender til debitorer i den danske offentlige sektor.;
                           ENU=Specifies the default profile that you use in the electronic documents that you send to customers in the Danish public sector.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default OIOUBL Profile Code";
                ShowMandatory=TRUE }

    { 1101100004;2;Group  ;
                CaptionML=[DAN=Outputstier;
                           ENU=Output Paths] }

    { 1060000;3;Field     ;
                CaptionML=[DAN=Fakturasti;
                           ENU=Invoice Path];
                ToolTipML=[DAN=Angiver stien til og navnet p† den mappe, hvor du vil gemme filer for elektroniske fakturaer.;
                           ENU=Specifies the path and name of the folder where you want to store the files for electronic invoices.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Invoice Path";
                ShowMandatory=TRUE }

    { 1060002;3;Field     ;
                CaptionML=[DAN=Kreditnotasti;
                           ENU=Cr. Memo Path];
                ToolTipML=[DAN=Angiver stien til og navnet p† den mappe, hvor du vil gemme filer for elektroniske kreditnotaer.;
                           ENU=Specifies the path and name of the folder where you want to store the files for electronic credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Cr. Memo Path";
                ShowMandatory=TRUE }

    { 1101100000;3;Field  ;
                CaptionML=[DAN=Rykkersti;
                           ENU=Reminder Path];
                ToolTipML=[DAN=Angiver stien til og navnet p† den mappe, hvor du vil gemme filer for elektroniske rykkere.;
                           ENU=Specifies the path and name of the folder where you want to store the files for electronic reminders.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Reminder Path";
                ShowMandatory=TRUE }

    { 1101100002;3;Field  ;
                CaptionML=[DAN=Rentenotasti;
                           ENU=Fin. Chrg. Memo Path];
                ToolTipML=[DAN=Angiver stien til og navnet p† den mappe, hvor du vil gemme filer for elektroniske rentenotaer.;
                           ENU=Specifies the path and name of the folder where you want to store the files for electronic finance charge memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Fin. Chrg. Memo Path";
                ShowMandatory=TRUE }

    { 49  ;1   ;Group     ;
                CaptionML=[DAN=Dynamics 365 for Sales;
                           ENU=Dynamics 365 for Sales];
                GroupType=Group }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den salgslinjetype, der skal bruges til produkter, der skal rekvireres, i Dynamics 365 for Sales.;
                           ENU=Specifies the sales line type that will be used for write-in products in Dynamics 365 for Sales.];
                ApplicationArea=#Suite;
                SourceExpr="Write-in Product Type" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† varen eller ressourcen, afh‘ngigt af det produkt, der skal rekvireres og bruges til Dynamics 365 for Sales.;
                           ENU=Specifies the number of the item or resource depending on the write-in product type that will be used for Dynamics 365 for Sales.];
                ApplicationArea=#Suite;
                SourceExpr="Write-in Product No." }

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

