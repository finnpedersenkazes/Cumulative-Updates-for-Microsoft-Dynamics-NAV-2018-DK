OBJECT Page 460 Purchases & Payables Setup
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ops‘tning af K›b;
               ENU=Purchases & Payables Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table312;
    DataCaptionExpr='';
    PageType=Card;
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
               END;

    ActionList=ACTIONS
    {
      { 33      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 31      ;1   ;Action    ;
                      CaptionML=[DAN=Kreditorbogf›ringsgrupper;
                                 ENU=Vendor Posting Groups];
                      ToolTipML=[DAN=Ops‘t de bogf›ringsgrupper, du kan v‘lge mellem, n†r du ops‘tter kreditorkort, der skal knytte forretningstransaktioner for kreditoren til den relevante finanskonto.;
                                 ENU=Set up the posting groups to select from when you set up vendor cards to link business transactions made for the vendor with the appropriate account in the general ledger.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 111;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Vendor;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 29      ;1   ;Action    ;
                      CaptionML=[DAN=Ops‘tning af indg†ende bilag;
                                 ENU=Incoming Documents Setup];
                      ToolTipML=[DAN=Ops‘t den kladdetype, der skal bruges til at oprette finanskladdelinjer fra elektroniske eksterne dokumenter som f.eks. fakturaer fra kreditorer via mail.;
                                 ENU=Set up the journal template that will be used to create general journal lines from electronic external documents, such as invoices from your vendors on email.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 191;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Documents;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type k›bsrabatter der skal bogf›res separat. Ingen rabat: Rabatter bogf›res ikke separat, men skal i stedet fratr‘kke rabatten inden bogf›ringen. Fakturarabatter: Fakturarabatten og fakturabel›bet bogf›res samtidigt, baseret p† feltet K›bsfakturarabatkonto i vinduet Bogf›ringsops‘tning. Linjerabatter: Linjerabatten og fakturabel›bet bogf›res samtidigt, baseret p† feltet K›bslinjerabatkonto i vinduet Bogf›ringsops‘tning. Alle rabatter: Faktura- og linjerabatterne samt fakturabel›bet bogf›res samtidigt, baseret p† feltet K›bsfakturarabatkonto og feltet K›bslinjerabatkonto i vinduet Bogf›ringsops‘tning.;
                           ENU=Specifies the type of purchase discounts to post separately. No Discounts: Discounts are not posted separately but instead will subtract the discount before posting. Invoice Discounts: The invoice discount and invoice amount are posted simultaneously, based on the Purch. Inv. Disc. Account field in the General Posting Setup window. Line Discounts: The line discount and the invoice amount will be posted simultaneously, based on Purch. Line Disc. Account field in the General Posting Setup window. All Discounts: The invoice and line discounts and the invoice amount will be posted simultaneously, based on the Purch. Inv. Disc. Account field and Purch. Line. Disc. Account fields in the General Posting Setup window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Discount Posting" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en bogf›rt modtagelse og en bogf›rt faktura oprettes automatisk, n†r du bogf›rer en faktura.;
                           ENU=Specifies that a posted receipt and a posted invoice are automatically created when you post an invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Receipt on Invoice";
                Importance=Additional }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en bogf›rt returvareleverance og en bogf›rt k›bskreditnota oprettes automatisk, n†r du bogf›rer en kreditnota.;
                           ENU=Specifies that a posted return shipment and a posted purchase credit memo are automatically created when you post a credit memo.];
                ApplicationArea=#Advanced;
                SourceExpr="Return Shipment on Credit Memo";
                Importance=Additional }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at bel›bene afrundes for k›bsfakturaer.;
                           ENU=Specifies that amounts are rounded for purchase invoices.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoice Rounding" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der altid skal inds‘ttes et eksternt bilagsnummer.;
                           ENU=Specifies whether it is mandatory to enter an external document number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ext. Doc. No. Mandatory" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om manuel regulering af momsbel›b i k›bsdokumenter skal tillades.;
                           ENU=Specifies whether to allow the manual adjustment of VAT amounts in purchase documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow VAT Difference" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturarabatbel›bet skal beregnes automatisk med k›bsdokumenter.;
                           ENU=Specifies whether the invoice discount amount is automatically calculated with purchase documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Calc. Inv. Discount" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at fakturarabatbel›bet beregnes i henhold til moms-id'et.;
                           ENU=Specifies that the invoice discount is calculated according to VAT Identifier.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Calc. Inv. Disc. per VAT ID" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, i hvor stor udstr‘kning posterne skal udlignes i forskellige valutaer i funktionalitetsomr†det i modulet K›b.;
                           ENU=Specifies to what extent the application of entries in different currencies is allowed in the Purchases and Payables application area.];
                ApplicationArea=#Suite;
                SourceExpr="Appln. between Currencies" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bem‘rkninger skal kopieres automatisk fra rammeordrer til k›bsordrer.;
                           ENU=Specifies whether to copy comments from blanket orders to purchase orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Copy Comments Blanket to Order";
                Importance=Additional }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bem‘rkninger skal kopieres fra k›bsordrer til k›bsfakturaer.;
                           ENU=Specifies whether to copy comments from purchase orders to purchase invoices.];
                ApplicationArea=#Advanced;
                SourceExpr="Copy Comments Order to Invoice";
                Importance=Additional }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bem‘rkninger skal kopieres fra k›bsordrer til modtagelser.;
                           ENU=Specifies whether to copy comments from purchase orders to receipts.];
                ApplicationArea=#Advanced;
                SourceExpr="Copy Comments Order to Receipt";
                Importance=Additional }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bem‘rkninger skal kopieres automatisk fra k›bsreturvareordrer til salgskreditnotaer.;
                           ENU=Specifies whether to copy comments from purchase return orders to sales credit memos.];
                ApplicationArea=#Advanced;
                SourceExpr="Copy Cmts Ret.Ord. to Cr. Memo";
                Importance=Additional }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at bem‘rkninger kopieres fra returvareordren til den bogf›rte returvareleverance.;
                           ENU=Specifies that comments are copied from the return order to the posted return shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Copy Cmts Ret.Ord. to Ret.Shpt";
                Importance=Additional }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en returtransaktion ikke vil blive bogf›rt, medmindre feltet Udl.varepostl›benr. p† k›bsordrelinjen angiver en post.;
                           ENU=Specifies that a return transaction cannot be posted unless the Appl.-to Item Entry field on the purchase order line Specifies an entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Exact Cost Reversing Mandatory" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der vises en advarselsmeddelelse, hvis du modtager eller fakturerer en ordre med et forudbetalingsbel›b, der ikke er betalt.;
                           ENU=Specifies that a warning message is shown when you receive or invoice an order that has an unpaid prepayment amount.];
                ApplicationArea=#Prepayments;
                SourceExpr="Check Prepmt. when Posting";
                Importance=Additional }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil arkivere k›bsrekvisitioner og k›bsordrer automatisk, f›r de slettes under processen til oprettelse af ordrer eller bogf›ring.;
                           ENU=Specifies whether to automatically archive purchase quotes and purchase orders before they are deleted during the make order or posting processes.];
                ApplicationArea=#Advanced;
                SourceExpr="Archive Quotes and Orders";
                Importance=Additional }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan feltet Bogf›ringsdato skal bruges i k›bsdokumenter.;
                           ENU=Specifies how to use the Posting Date field on purchase documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default Posting Date" }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den standardv‘rdi, der inds‘ttes i feltet Antal til modtagelse retur p† k›bsordrelinjerne og i feltet Til afsendelse retur p† k›bsreturvareordrelinjerne.;
                           ENU=Specifies the default value inserted in the Qty. to Receive field in purchase order lines and in the Return Qty. to Ship field in purchase return order lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Default Qty. to Receive";
                Importance=Additional }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om og hvorn†r bogf›rte k›bsdokumenter kan slettes. Hvis du angiver en dato, kan de bogf›rte k›bsdokumenter med en bogf›ringsdato p† eller efter denne dato ikke slettes.;
                           ENU=Specifies if and when posted purchase documents can be deleted. If you enter a date, posted purchase documents with a posting date on or after this date cannot be deleted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow Document Deletion Before";
                Importance=Additional }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om adresse‘ndringer, der er foretaget p† k›bsbilag, kopieres til kreditorkortet. Som standard kopieres ‘ndringer til kreditorkortet.;
                           ENU=Specifies if changes to addresses made on purchase documents are copied to the vendor card. By default, changes are copied to the vendor card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ignore Updated Addresses" }

    { 1904569201;1;Group  ;
                CaptionML=[DAN=Nummerserie;
                           ENU=Number Series];
                GroupType=Group }

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til kreditorer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to vendors.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Nos." }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til k›bsrekvisitioner.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to purchase quotes.];
                ApplicationArea=#Advanced;
                SourceExpr="Quote Nos.";
                Importance=Additional }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til rammek›bsordrer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to blanket purchase orders.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order Nos.";
                Importance=Additional }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til k›bsordrer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to purchase orders.];
                ApplicationArea=#Suite;
                SourceExpr="Order Nos.";
                Importance=Additional }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der bruges til at tildele numre til nye k›bsreturvareordrer.;
                           ENU=Specifies the number series that is used to assign numbers to new purchase return orders.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Return Order Nos.";
                Importance=Additional }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til k›bsfakturaer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to purchase invoices.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoice Nos." }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til k›bsfakturaer, n†r de er bogf›rte.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to purchase invoices when they are posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posted Invoice Nos." }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til k›bskreditnotaer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to purchase credit memos.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Memo Nos." }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til k›bskreditnotaer, n†r de er bogf›rte.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to purchase credit memos when they are posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posted Credit Memo Nos." }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til bogf›rte modtagelser.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to posted receipts.];
                ApplicationArea=#Suite;
                SourceExpr="Posted Receipt Nos.";
                Importance=Additional }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, der skal bruges ved bogf›ring af returvareleverancer.;
                           ENU=Specifies the number series to be used when you post return shipments.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Posted Return Shpt. Nos.";
                Importance=Additional }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til k›bsforudbetalingsfakturaer, n†r de er bogf›rte.;
                           ENU=Specifies the code for the number series that is used to assign numbers to purchase prepayment invoices when they are posted.];
                ApplicationArea=#Prepayments;
                SourceExpr="Posted Prepmt. Inv. Nos.";
                Importance=Additional }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der skal bruges til at tildele numre til k›bsforudbetalingskreditnotaer.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to purchase prepayment credit memos.];
                ApplicationArea=#Prepayments;
                SourceExpr="Posted Prepmt. Cr. Memo Nos.";
                Importance=Additional }

    { 7   ;1   ;Group     ;
                CaptionML=[DAN=Baggrundsbogf›ring;
                           ENU=Background Posting];
                GroupType=Group }

    { 23  ;2   ;Group     ;
                CaptionML=[DAN=Bogf›r;
                           ENU=Post];
                GroupType=Group }

    { 19  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om forretningsprocessen bruger sagsk›er i baggrunden til at bogf›re bilag, inklusive ordrer, fakturaer, returvareordrer og kreditnotaer.;
                           ENU=Specifies if your business process uses job queues in the background to post documents, including orders, invoices, return orders, and credit memos.];
                ApplicationArea=#Suite;
                SourceExpr="Post with Job Queue" }

    { 17  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver prioriteten p† sagsk›en, n†r den k›res i forbindelse med baggrundsbogf›ring. Du kan angive forskellige prioriteter for bogf›ringen samt bogf›rings- og udskriftsindstillinger. Standardindstillingen er 1000.;
                           ENU=Specifies the priority of the job queue when you run it in the context of background posting. You can set different priorities for the post and post and print settings. The default setting is 1000.];
                ApplicationArea=#Suite;
                SourceExpr="Job Queue Priority for Post" }

    { 13  ;2   ;Group     ;
                CaptionML=[DAN=Bogf›r & udskriv;
                           ENU=Post & Print];
                GroupType=Group }

    { 15  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om forretningsprocessen bruger sagsk›er til at bogf›re og udskrive k›bsdokumenter. Mark‚r dette afkrydsningsfelt for at aktivere bogf›ring og udskrivning i baggrunden.;
                           ENU=Specifies whether your business process uses job queues to post and print purchase documents. Select this check box to enable background posting and printing.];
                ApplicationArea=#Suite;
                SourceExpr="Post & Print with Job Queue" }

    { 11  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver prioriteten p† sagsk›en, n†r den k›res i forbindelse med baggrundsbogf›ring. Du kan angive forskellige prioriteter for bogf›ringen samt bogf›rings- og udskriftsindstillinger. Standardindstillingen er 1000.;
                           ENU=Specifies the priority of the job queue when you run it in the context of background posting. You can set different priorities for the post and post and print settings. The default setting is 1000.];
                ApplicationArea=#Suite;
                SourceExpr="Job Q. Prio. for Post & Print" }

    { 9   ;2   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 5   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den sagsk›kategori, som du vil tilknytte med baggrundsbogf›ringen.;
                           ENU=Specifies the code for the category of the job queue that you want to associate with background posting.];
                ApplicationArea=#Suite;
                SourceExpr="Job Queue Category Code" }

    { 3   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om der afsendes en notifikation, n†r bogf›ringen og udskrivningen er fuldf›rt.;
                           ENU=Specifies if a notification is sent when posting and printing is successfully completed.];
                ApplicationArea=#Suite;
                SourceExpr="Notify On Success" }

    { 21  ;1   ;Group     ;
                CaptionML=[DAN=Standardkonti;
                           ENU=Default Accounts];
                GroupType=Group }

    { 25  ;2   ;Field     ;
                CaptionML=[DAN=Standarddebetkonto til ikke-varelinjer;
                           ENU=Default Debit Account for Non-Item Lines];
                ToolTipML=[DAN=Angiver den debetkonto, der inds‘ttes p† k›bskreditnotalinjer som standard.;
                           ENU=Specifies the debit account that is inserted on purchase credit memo lines by default.];
                ApplicationArea=#Suite;
                SourceExpr="Debit Acc. for Non-Item Lines" }

    { 27  ;2   ;Field     ;
                CaptionML=[DAN=Standardkreditkonto til ikke-varelinjer;
                           ENU=Default Credit Account for Non-Item Lines];
                ToolTipML=[DAN=Angiver den debetkonto, der inds‘ttes p† k›bskreditnotalinjer som standard.;
                           ENU=Specifies the debit account that is inserted on purchase credit memo lines by default.];
                ApplicationArea=#Suite;
                SourceExpr="Credit Acc. for Non-Item Lines" }

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

