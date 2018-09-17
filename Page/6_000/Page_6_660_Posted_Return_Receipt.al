OBJECT Page 6660 Posted Return Receipt
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogf›rt returvaremodt.;
               ENU=Posted Return Receipt];
    InsertAllowed=No;
    SourceTable=Table6660;
    PageType=Document;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;
               END;

    OnModifyRecord=BEGIN
                     CODEUNIT.RUN(CODEUNIT::"Return Receipt - Printed",Rec);
                     EXIT(FALSE);
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=R&eturvarekvit.;
                                 ENU=&Return Rcpt.];
                      Image=Receipt }
      { 10      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 6665;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 78      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#SalesReturnOrder;
                      RunObject=Page 67;
                      RunPageLink=Document Type=CONST(Posted Return Receipt),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 80      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 62      ;2   ;Action    ;
                      AccessByPermission=TableData 456=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F† vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn†r den blev sendt og hvorn†r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#SalesReturnOrder;
                      Image=Approvals;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ShowPostedApprovalEntries(RECORDID);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 49      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ReturnRcptHeader);
                                 ReturnRcptHeader.PrintRecords(TRUE);
                               END;
                                }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf›ringsdatoen p† det valgte bogf›rte salgsbilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected posted sales document.];
                      ApplicationArea=#SalesReturnOrder;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
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
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="No.";
                Importance=Promoted;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Customer No.";
                Importance=Promoted;
                Editable=FALSE }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† debitorens prim‘re adresse.;
                           ENU=Specifies the number of the contact person at the customer's main address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Contact No.";
                Editable=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Customer Name";
                Editable=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens prim‘re adresse.;
                           ENU=Specifies the main address of the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Address";
                Editable=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del i adressen.;
                           ENU=Specifies an additional part of the address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Address 2";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens prim‘re adresse.;
                           ENU=Specifies the postal code of the customer's main address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Post Code";
                Editable=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i debitorens prim‘re adresse.;
                           ENU=Specifies the city of the customer's main address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to City";
                Editable=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens prim‘re adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Sell-to Contact";
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Posting Date";
                Importance=Promoted;
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Document Date";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den returvareordre, der bogf›rer en returvaremodtagelse.;
                           ENU=Specifies the number of the return order that will post a return receipt.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Order No.";
                Importance=Promoted;
                Editable=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="External Document No.";
                Importance=Promoted;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken s‘lger der er tilknyttet den bogf›rte returvaremodtagelse.;
                           ENU=Specifies which salesperson is associated with the posted return receipt.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Salesperson Code";
                Editable=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="No. Printed";
                Editable=FALSE }

    { 46  ;1   ;Part      ;
                Name=ReturnRcptLines;
                ApplicationArea=#SalesReturnOrder;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page6661;
                PartType=Page }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Customer No.";
                Importance=Promoted;
                Editable=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Contact No.";
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Name";
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den debitor, du har sendt fakturaen til.;
                           ENU=Specifies the address of the customer to whom you sent the invoice.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Address";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende linje i adressen.;
                           ENU=Specifies an additional line of the address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Address 2";
                Editable=FALSE }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Post Code";
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to City";
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Bill-to Contact";
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Editable=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Editable=FALSE }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Code";
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Name";
                Editable=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Address";
                Editable=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Address 2";
                Editable=FALSE }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Post Code";
                Editable=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to City";
                Editable=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Ship-to Contact";
                Editable=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Location Code";
                Importance=Promoted;
                Editable=FALSE }

    { 7   ;2   ;Group     ;
                CaptionML=[DAN=Leveringsform;
                           ENU=Shipment Method];
                GroupType=Group }

    { 42  ;3   ;Field     ;
                CaptionML=[DAN=Kode;
                           ENU=Code];
                ToolTipML=[DAN=Angiver †rsagen for den bogf›rte returvare.;
                           ENU=Specifies the reason for the posted return.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipment Method Code";
                Editable=FALSE }

    { 3   ;3   ;Field     ;
                CaptionML=[DAN=Spedit›r;
                           ENU=Agent];
                ToolTipML=[DAN=Angiver, hvilken spedit›r der bruges til at transportere varerne p† salgsbilaget til debitoren.;
                           ENU=Specifies which shipping agent is used to transport the items on the sales document to the customer.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipping Agent Code";
                Importance=Additional }

    { 5   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver spedit›rens pakkenummer.;
                           ENU=Specifies the shipping agent's package number.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Package Tracking No.";
                Importance=Additional }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipment Date";
                Importance=Promoted;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ReturnRcptHeader@1000 : Record 6660;

    BEGIN
    END.
  }
}

