OBJECT Page 648 Handled IC Inbox Sales Doc.
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=H†ndteret salgsbilag for IC-indbakke;
               ENU=Handled IC Inbox Sales Doc.];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table438;
    PageType=Document;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 13      ;1   ;ActionGroup;
                      Name=Document;
                      CaptionML=[DAN=&Dokument;
                                 ENU=&Document];
                      Image=Document }
      { 14      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 652;
                      RunPageLink=Table ID=CONST(438),
                                  Transaction No.=FIELD(IC Transaction No.),
                                  IC Partner Code=FIELD(IC Partner Code),
                                  Transaction Source=FIELD(Transaction Source),
                                  Line No.=CONST(0);
                      Promoted=Yes;
                      Image=Dimensions;
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
                ToolTipML=[DAN=Angiver type af det relaterede bilag.;
                           ENU=Specifies the type of the related document.];
                ApplicationArea=#Intercompany;
                SourceExpr="Document Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Intercompany;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† koncernintern transaktion. Transaktionsnummeret angiver, hvilken linje i tabellen IC-udbakketransaktion som dokumentet er relateret til.;
                           ENU=Specifies the number of the intercompany transaction. The transaction number indicates which line in the IC Outbox Transaction table the document is related to.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Transaction No." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncerninterne partner, som transaktionen er relateret til, hvis posten blev oprettet fra en koncernintern transaktion.;
                           ENU=Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken virksomhed der har oprettet transaktionen.;
                           ENU=Specifies which company created the transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="Transaction Source" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Intercompany;
                SourceExpr="Sell-to Customer No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Intercompany;
                SourceExpr="Bill-to Customer No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Intercompany;
                SourceExpr="Posting Date" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Intercompany;
                SourceExpr="Document Date" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r den relaterede faktura skal betales.;
                           ENU=Specifies when the related invoice must be paid.];
                ApplicationArea=#Intercompany;
                SourceExpr="Due Date" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bel›bet i posten skal v‘re betalt, for at der kan opn†s kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Intercompany;
                SourceExpr="Pmt. Discount Date" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis debitoren betaler p† eller f›r den dato, der er angivet i feltet Kont.rabatdato. Rabatprocenten er angivet i feltet Betalingsbetingelseskode.;
                           ENU=Specifies the payment discount percentage that is granted if the customer pays on or before the date entered in the Pmt. Discount Date field. The discount percentage is specified in the Payment Terms Code field.];
                ApplicationArea=#Intercompany;
                SourceExpr="Payment Discount %" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#Intercompany;
                SourceExpr="Currency Code" }

    { 41  ;1   ;Part      ;
                Name=ICInboxSalesLines;
                ApplicationArea=#Intercompany;
                SubPageLink=IC Transaction No.=FIELD(IC Transaction No.),
                            IC Partner Code=FIELD(IC Partner Code),
                            Transaction Source=FIELD(Transaction Source);
                PagePartID=Page649;
                PartType=Page }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Intercompany;
                SourceExpr="Ship-to Name" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Intercompany;
                SourceExpr="Ship-to Address" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Intercompany;
                SourceExpr="Ship-to City" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du har lovet at levere ordren som resultat af funktionen Beregning af leveringstid.;
                           ENU=Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.];
                ApplicationArea=#Intercompany;
                SourceExpr="Promised Delivery Date" }

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

