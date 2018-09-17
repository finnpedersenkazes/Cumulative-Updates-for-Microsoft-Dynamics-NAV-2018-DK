OBJECT Page 136 Posted Purchase Receipt
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogf›rt k›bsleverance;
               ENU=Posted Purchase Receipt];
    InsertAllowed=No;
    SourceTable=Table120;
    PageType=Document;
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=Modtagels&e;
                                 ENU=&Receipt];
                      Image=Receipt }
      { 8       ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 399;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 72      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 66;
                      RunPageLink=Document Type=CONST(Receipt),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 77      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 99      ;2   ;Action    ;
                      AccessByPermission=TableData 456=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=F† vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvorn†r den blev sendt og hvorn†r den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Suite;
                      Image=Approvals;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.ShowPostedApprovalEntries(RECORDID);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 47      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(PurchRcptHeader);
                                 PurchRcptHeader.PrintRecords(TRUE);
                               END;
                                }
      { 48      ;1   ;Action    ;
                      CaptionML=[DAN=N&aviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Advanced;
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
                ToolTipML=[DAN=Angiver nummeret p† en finanskonto, en vare, en ekstra kostpris eller et anl‘g, afh‘ngig af hvad du har valgt i feltet Type.;
                           ENU=Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.];
                ApplicationArea=#Suite;
                SourceExpr="No.";
                Importance=Promoted;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Vendor No.";
                Importance=Promoted;
                Editable=FALSE }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen hos den kreditor, der leverede varerne.;
                           ENU=Specifies the number of the contact person at the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact No.";
                Editable=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Vendor Name";
                Editable=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den kreditor, der leverede varerne.;
                           ENU=Specifies the address of the vendor who delivered the items.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Address";
                Editable=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af adressen p† den leverand›r, der leverede varerne.;
                           ENU=Specifies an additional part of the address of the vendor who delivered the items.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Address 2";
                Editable=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den kreditor, der leverede varerne.;
                           ENU=Specifies the city of the vendor who delivered the items.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from City";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den kreditor, der leverede varerne.;
                           ENU=Specifies the post code of the vendor who delivered the items.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Post Code";
                Editable=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen hos den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the contact person at the vendor who delivered the items.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Contact";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Advanced;
                SourceExpr="No. Printed";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for recorden.;
                           ENU=Specifies the posting date of the record.];
                ApplicationArea=#Suite;
                SourceExpr="Posting Date";
                Importance=Promoted;
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor k›bsbilaget blev oprettet.;
                           ENU=Specifies the date when the purchase document was created.];
                ApplicationArea=#Suite;
                SourceExpr="Document Date";
                Editable=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som du har bedt kreditoren om at levere ordren p† til leveringsadressen. V‘rdien i feltet bruges til at beregne, hvilken dato du senest kan bestille varerne, hvis de skal v‘re leveret p† den ›nskede modtagelsesdato. Hvis det ikke er n›dvendigt med levering p† en bestemt dato, kan du lade feltet st† tomt.;
                           ENU=Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.];
                ApplicationArea=#Suite;
                SourceExpr="Requested Receipt Date" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som kreditoren har lovet at levere ordren.;
                           ENU=Specifies the date that the vendor has promised to deliver the order.];
                ApplicationArea=#Advanced;
                SourceExpr="Promised Receipt Date" }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tilbudsnummeret p† den bogf›rte k›bsleverance.;
                           ENU=Specifies the quote number for the posted purchase receipt.];
                ApplicationArea=#Advanced;
                SourceExpr="Quote No." }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p† den ordre, som oprettede posten.;
                           ENU=Specifies the line number of the order that created the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Order No.";
                Editable=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens ordrenummer.;
                           ENU=Specifies the vendor's order number.];
                ApplicationArea=#Suite;
                SourceExpr="Vendor Order No.";
                Importance=Promoted;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens leverancenummer. Det inds‘ttes i det tilsvarende felt p† kildedokumentet ved bogf›ringen.;
                           ENU=Specifies the vendor's shipment number. It is inserted in the corresponding field on the source document during posting.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Shipment No.";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Address Code";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indk›ber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Purchaser Code";
                Editable=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ansvarscenterkode, der er knyttet til denne bogf›rte returvaremodtagelse.;
                           ENU=Specifies the responsibility center code that is linked to this posted return receipt.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Editable=FALSE }

    { 44  ;1   ;Part      ;
                Name=PurchReceiptLines;
                ApplicationArea=#Suite;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page137;
                PartType=Page }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the number of the vendor that you received the invoice from.];
                ApplicationArea=#Suite;
                SourceExpr="Pay-to Vendor No.";
                Importance=Promoted;
                Editable=FALSE }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† en kontaktperson hos den kreditor, fakturaen er sendt fra.;
                           ENU=Specifies the number of the person to contact about an invoice from this vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact no.";
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the name of the vendor who you received the invoice from.];
                ApplicationArea=#Suite;
                SourceExpr="Pay-to Name";
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the address of the vendor that you received the invoice from.];
                ApplicationArea=#Suite;
                SourceExpr="Pay-to Address";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en yderligere del af adressen p† den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies an additional part of the address of the vendor that the invoice was received from.];
                ApplicationArea=#Suite;
                SourceExpr="Pay-to Address 2";
                Editable=FALSE }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the post code of the vendor that you received the invoice from.];
                ApplicationArea=#Suite;
                SourceExpr="Pay-to Post Code";
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the city of the vendor that you received the invoice from.];
                ApplicationArea=#Suite;
                SourceExpr="Pay-to City";
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktpersonen hos den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the contact person at the vendor that you received the invoice from.];
                ApplicationArea=#Suite;
                SourceExpr="Pay-to Contact";
                Editable=FALSE }

    { 61  ;2   ;Field     ;
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
                ToolTipML=[DAN=Angiver navnet p† den debitor, som varerne p† k›bsordren blev sendt til, som en direkte levering.;
                           ENU=Specifies the name of the customer that items on the purchase order were shipped to, as a drop shipment.];
                ApplicationArea=#Suite;
                SourceExpr="Ship-to Name";
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, som varerne i k›bsordren blev leveret til, som en direkte levering.;
                           ENU=Specifies the address that items on the purchase order were shipped to, as a drop shipment..];
                ApplicationArea=#Suite;
                SourceExpr="Ship-to Address";
                Editable=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Suite;
                SourceExpr="Ship-to Address 2";
                Editable=FALSE }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret, som varerne i k›bsordren blev leveret til, som en direkte levering.;
                           ENU=Specifies the post code that items on the purchase order were shipped to, as a drop shipment.];
                ApplicationArea=#Suite;
                SourceExpr="Ship-to Post Code";
                Editable=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Suite;
                SourceExpr="Ship-to City";
                Editable=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktpersonen hos den debitor, som varerne p† k›bsordren blev sendt til, som en direkte levering.;
                           ENU=Specifies the contact person at the customer that items on the purchase order were shipped to, as a drop shipment.];
                ApplicationArea=#Suite;
                SourceExpr="Ship-to Contact";
                Editable=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted;
                Editable=FALSE }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, det tager at g›re varer tilg‘ngelige fra lageret, efter varerne er bogf›rt som modtaget.;
                           ENU=Specifies the time it takes to make items part of available inventory, after the items have been posted as received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Inbound Whse. Handling Time" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Suite;
                SourceExpr="Shipment Method Code";
                Editable=FALSE }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datoformel for det tidsrum, det tager at genbestille varen.;
                           ENU=Specifies a date formula for the amount of time it takes to replenish the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Lead Time Calculation" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilg‘ngelige p† lageret. Hvis du lader feltet v‘re tomt, bliver det beregnet p† f›lgende m†de: Planlagt modtagelsesdato + Sikkerhedstid + Indg†ende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#Suite;
                SourceExpr="Expected Receipt Date";
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
      PurchRcptHeader@1000 : Record 120;

    BEGIN
    END.
  }
}

