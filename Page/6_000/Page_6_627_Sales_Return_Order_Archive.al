OBJECT Page 6627 Sales Return Order Archive
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
    CaptionML=[DAN=Salgsreturvareordrearkiv;
               ENU=Sales Return Order Archive];
    DeleteAllowed=No;
    SourceTable=Table5107;
    SourceTableView=WHERE(Document Type=CONST(Return Order));
    PageType=Document;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 123     ;1   ;ActionGroup;
                      CaptionML=[DAN=Ver&sion;
                                 ENU=Ver&sion];
                      Image=Versions }
      { 126     ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om debitoren i salgsbilaget.;
                                 ENU=View or edit detailed information about the customer on the sales document.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Sell-to Customer No.);
                      Image=EditLines }
      { 127     ;2   ;Action    ;
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
      { 140     ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5180;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0),
                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                  Version No.=FIELD(Version No.);
                      Image=ViewComments }
      { 137     ;2   ;Action    ;
                      CaptionML=[DAN=Udskriv;
                                 ENU=Print];
                      ToolTipML=[DAN=Udskriv oplysningerne i vinduet. Du f†r vist et anmodningsvindue for udskrivningen, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Print the information in the window. A print request window opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
                      Image=Print;
                      OnAction=BEGIN
                                 DocPrint.PrintSalesHeaderArch(Rec);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 130     ;1   ;Action    ;
                      Name=Restore;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Gendan;
                                 ENU=&Restore];
                      ToolTipML=[DAN=Genopret det bogf›rte dokument, den blev arkiveret fra.;
                                 ENU=Recreate the posted document that it was archived from.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Restore;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ArchiveManagement@1000 : Codeunit 5063;
                               BEGIN
                                 ArchiveManagement.RestoreSalesDocument(Rec);
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
                ApplicationArea=#Advanced;
                SourceExpr="No.";
                Importance=Additional }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Debitornr.;
                           ENU=Customer No.];
                ToolTipML=[DAN=Angiver nummeret p† den debitor, der er tilknyttet salgsreturvaren.;
                           ENU=Specifies the number of the customer associated with the sales return.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer No." }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Debitor;
                           ENU=Customer];
                ToolTipML=[DAN=Angiver navnet p† debitoren for salgsreturvareordren.;
                           ENU=Specifies the name of the customer for the sales return order.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer Name";
                Importance=Promoted }

    { 3   ;2   ;Group     ;
                CaptionML=[DAN=Kunde;
                           ENU=Sell-to];
                GroupType=Group }

    { 8   ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen p† debitorens placering.;
                           ENU=Specifies the address where the customer is located.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Address";
                Importance=Additional }

    { 10  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen.;
                           ENU=Specifies an additional part of the shipping address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Address 2";
                Importance=Additional }

    { 12  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Post Code";
                Importance=Additional }

    { 121 ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen i debitorens adresse.;
                           ENU=Specifies the city of the customer's address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to City";
                Importance=Additional }

    { 132 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† faktureringsadressen.;
                           ENU=Specifies the number of the contact person at the billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact No.";
                Importance=Additional }

    { 14  ;2   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† leveringsadressen.;
                           ENU=Specifies the name of the contact person at the shipping address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Date" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Advanced;
                SourceExpr="External Document No." }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken s‘lger der er tilknyttet salgsreturvareordren.;
                           ENU=Specifies which salesperson is associated with the sales return order.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, bilaget er knyttet til.;
                           ENU=Specifies the campaign number the document is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Campaign No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bilaget er †bent, venter p† godkendelse, er faktureret til forudbetaling eller er frigivet til n‘ste fase i behandlingen.;
                           ENU=Specifies whether the document is open, waiting to be approved, has been invoiced for prepayment, or has been released to the next stage of processing.];
                ApplicationArea=#Advanced;
                SourceExpr=Status }

    { 122 ;1   ;Part      ;
                Name=SalesLinesArchive;
                ApplicationArea=#Advanced;
                SubPageLink=Document No.=FIELD(No.),
                            Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                            Version No.=FIELD(Version No.);
                PagePartID=Page6628 }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details];
                GroupType=Group }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code" }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel›b p† bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Group" }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr‘senterer med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogf›rt bilag, som dette bilag eller denne kladdelinje udlignes med, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-to Doc. Type" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bogf›rte bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-to Doc. No." }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id for poster, der udlignes, n†r du v‘lger handlingen Udlign poster.;
                           ENU=Specifies the ID of entries that will be applied to when you choose the Apply Entries action.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-to ID" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Forsendelse og fakturering;
                           ENU=Shipping and Billing];
                GroupType=Group }

    { 5   ;2   ;Group     ;
                CaptionML=[DAN=Leveres til;
                           ENU=Ship-to];
                GroupType=Group }

    { 7   ;3   ;Field     ;
                CaptionML=[DAN=Kode;
                           ENU=Code];
                ToolTipML=[DAN=Angiver returnerings†rsagen.;
                           ENU=Specifies the reason for the return.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code";
                Importance=Promoted }

    { 69  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† den debitor, som produkterne i salgsbilaget skal leveres til.;
                           ENU=Specifies the name of the customer to whom products on the sales document will be shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name" }

    { 64  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen p† debitorens placering.;
                           ENU=Specifies the address where the customer is located.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address" }

    { 63  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen.;
                           ENU=Specifies an additional part of the shipping address.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Address 2" }

    { 62  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code" }

    { 61  ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen i debitorens adresse.;
                           ENU=Specifies the city of the customer's address.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to City" }

    { 60  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† leveringsadressen.;
                           ENU=Specifies the name of the contact person at the shipping address.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact" }

    { 73  ;2   ;Group     ;
                CaptionML=[DAN=Faktureres til;
                           ENU=Bill-to];
                GroupType=Group }

    { 38  ;3   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† den debitor, som produkterne i salgsbilaget skal leveres til.;
                           ENU=Specifies the name of the customer to whom products on the sales document will be shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Name";
                Importance=Promoted }

    { 40  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ToolTipML=[DAN=Angiver adressen p† debitorens placering.;
                           ENU=Specifies the address where the customer is located.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Address";
                Importance=Additional }

    { 42  ;3   ;Field     ;
                CaptionML=[DAN=Adresse 2;
                           ENU=Address 2];
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen.;
                           ENU=Specifies an additional part of the shipping address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Address 2";
                Importance=Additional }

    { 44  ;3   ;Field     ;
                CaptionML=[DAN=Postnr.;
                           ENU=Post Code];
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Post Code";
                Importance=Additional }

    { 120 ;3   ;Field     ;
                CaptionML=[DAN=By;
                           ENU=City];
                ToolTipML=[DAN=Angiver byen i debitorens adresse.;
                           ENU=Specifies the city of the customer's address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to City";
                Importance=Additional }

    { 134 ;3   ;Field     ;
                CaptionML=[DAN=Kontaktnr.;
                           ENU=Contact No.];
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† faktureringsadressen.;
                           ENU=Specifies the number of the contact person at the billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact No.";
                Importance=Additional }

    { 46  ;3   ;Field     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† leveringsadressen.;
                           ENU=Specifies the name of the contact person at the shipping address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact" }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Advanced;
                SourceExpr="EU 3-Party Trade" }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm†den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method" }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udf›rselssted, hvor varerne blev udf›rt af landet/omr†det med henblik p† rapportering til Intrastat.;
                           ENU=Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.];
                ApplicationArea=#Advanced;
                SourceExpr="Exit Point" }

    { 108 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omr†de med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 1904291901;1;Group  ;
                CaptionML=[DAN=Version;
                           ENU=Version] }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver versionsnummeret p† det arkiverede salgsbilag.;
                           ENU=Specifies the version number of the archived document.];
                ApplicationArea=#Advanced;
                SourceExpr="Version No." }

    { 112 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bruger-id'et for den person, der arkiverede dokumentet.;
                           ENU=Specifies the user ID of the person who archived this document.];
                ApplicationArea=#Advanced;
                SourceExpr="Archived By" }

    { 114 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor dokumentet blev arkiveret.;
                           ENU=Specifies the date when the document was archived.];
                ApplicationArea=#Advanced;
                SourceExpr="Date Archived" }

    { 116 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tidspunkt, hvor bilaget blev arkiveret.;
                           ENU=Specifies what time the document was archived.];
                ApplicationArea=#Advanced;
                SourceExpr="Time Archived" }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at det arkiverede dokument er knyttet til en interaktionslogpost.;
                           ENU=Specifies that the archived document is linked to an interaction log entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Interaction Exist" }

  }
  CODE
  {
    VAR
      DocPrint@1000 : Codeunit 229;

    LOCAL PROCEDURE PricesIncludingVATOnAfterValid@19009096();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

