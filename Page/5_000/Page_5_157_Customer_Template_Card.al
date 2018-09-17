OBJECT Page 5157 Customer Template Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitorskabelonkort;
               ENU=Customer Template Card];
    SourceTable=Table5105;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Debitorskabelon;
                                 ENU=&Customer Template];
                      Image=Template }
      { 31      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5105),
                                  No.=FIELD(Code);
                      Image=Dimensions }
      { 27      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Salg;
                                 ENU=S&ales];
                      Image=Sales }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=&Fakturarabatter;
                                 ENU=Invoice &Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter, som kan tilf›jes fakturaer til debitor. Der gives automatisk en fakturarabat til debitor, n†r det samlede fakturabel›b overstiger et vist bel›b.;
                                 ENU=Set up different discounts that are applied to invoices for the customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 23;
                      RunPageLink=Code=FIELD(Invoice Disc. Code);
                      Image=CalculateInvoiceDiscount }
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
                ToolTipML=[DAN=Angiver koden for debitorskabelonen. Du kan oprette et ubegr‘nset antal koder. Koden skal v‘re entydig. Det vil sige, at du ikke kan bruge den samme kode to gange i samme tabel.;
                           ENU=Specifies the code for the customer template. You can set up as many codes as you want. The code must be unique. You cannot have the same code twice in one table.];
                ApplicationArea=#All;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af debitorskabelonen.;
                           ENU=Specifies the description of the customer template.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontakttypen for debitorskabelonen.;
                           ENU=Specifies the contact type of the customer template.];
                ApplicationArea=#All;
                SourceExpr="Contact Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Country/Region Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver distriktskoden for debitorskabelonen.;
                           ENU=Specifies the territory code for the customer template.];
                ApplicationArea=#Advanced;
                SourceExpr="Territory Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for debitorskabelonen.;
                           ENU=Specifies the currency code for the customer template.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Bus. Posting Group" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Group" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den debitorbogf›ringsgruppe, som debitorskabelonen skal tilh›re. Klik i feltet for at se debitorbogf›ringsgrupperne i vinduet Debitorbogf›ringsgrupper.;
                           ENU=Specifies a code for the customer posting group to which the customer template will belong. To see the customer posting group codes in the Customer Posting Groups window, click the field.];
                ApplicationArea=#Advanced;
                SourceExpr="Customer Posting Group" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den debitorprisgruppe, som debitorskabelonen skal tilh›re. Klik i feltet for at se prisgruppekoderne i vinduet Debitorprisgrupper.;
                           ENU=Specifies a code for the customer price group to which the customer template will belong. To see the price group codes in the Customer Price Groups window, click the field.];
                ApplicationArea=#Advanced;
                SourceExpr="Customer Price Group" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den debitorrabatgruppe, som debitorskabelonen bliver knyttet til. Klik i feltet, hvis du vil se, hvilke debitorrabatgruppekoder der er oprettet i tabellen Debitorrabatgruppe.;
                           ENU=Specifies the code for the customer discount group to which the customer template will belong. To see the customer discount group codes in the Customer Discount Group table, click the field.];
                ApplicationArea=#Advanced;
                SourceExpr="Customer Disc. Group" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der beregnes linjerabat, n†r salgsprisen tilbydes.;
                           ENU=Specifies that a line discount is calculated when the sales price is offered.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Allow Line Disc." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fakturarabatkoden for debitorskabelonen.;
                           ENU=Specifies the invoice discount code for the customer template.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Invoice Disc. Code" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel›b p† bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prices Including VAT" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Payment Terms Code" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf›rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Payment Method Code" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Shipment Method Code" }

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

