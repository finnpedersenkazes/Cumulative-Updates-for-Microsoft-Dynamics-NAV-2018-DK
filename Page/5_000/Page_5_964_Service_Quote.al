OBJECT Page 5964 Service Quote
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Servicetilbud;
               ENU=Service Quote];
    SourceTable=Table5900;
    SourceTableView=WHERE(Document Type=FILTER(Quote));
    PageType=Document;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 IF UserMgt.GetServiceFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetServiceFilter);
                   FILTERGROUP(0);
                 END;
               END;

    OnNewRecord=BEGIN
                  "Document Type" := "Document Type"::Quote;
                  "Responsibility Center" := UserMgt.GetServiceFilter;
                  IF "No." = '' THEN
                    SetCustomerFromFilter;
                END;

    OnInsertRecord=BEGIN
                     CheckCreditMaxBeforeInsert(FALSE);
                   END;

    OnDeleteRecord=BEGIN
                     CurrPage.SAVERECORD;
                     EXIT(ConfirmDeletion);
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 138     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Tilbud;
                                 ENU=&Quote];
                      Image=Quote }
      { 112     ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=&Dimensioner;
                                 ENU=&Dimensions];
                      ToolTipML=[DAN=F† vist eller rediger dimensioner som f.eks. omr†de, projekt eller afdeling, som du kan tildele til kladdelinjer for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Enabled="No." <> '';
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Service Header),
                                  Table Subtype=FIELD(Document Type),
                                  No.=FIELD(No.),
                                  Type=CONST(General);
                      Image=ViewComments }
      { 102     ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CalcInvDiscForHeader;
                                 COMMIT;
                                 PAGE.RUNMODAL(PAGE::"Service Statistics",Rec);
                               END;
                                }
      { 60      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Debitorkort;
                                 ENU=Customer Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om debitoren.;
                                 ENU=View or edit detailed information for the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Customer No.);
                      Image=Customer }
      { 104     ;2   ;Action    ;
                      CaptionML=[DAN=Servicedokumentlo&g;
                                 ENU=Service Document Lo&g];
                      ToolTipML=[DAN=F† vist en liste over de ‘ndringer i servicedokumentet, der er registreret. I programmet oprettes der poster i vinduet, f.eks. n†r svartiden eller serviceordrens status er ‘ndret, en ressource er allokeret, en serviceordre er leveret eller faktureret osv. Hver linje i vinduet identificerer den h‘ndelse, der er forekommet i servicedokumentet. Linjen indeholder oplysninger om det felt, der er ‘ndret, dets gamle og nye v‘rdi, datoen og tidspunktet for, hvorn†r ‘ndringen fandt sted, og id'et for den bruger, som foretog ‘ndringerne.;
                                 ENU=View a list of the service document changes that have been logged. The program creates entries in the window when, for example, the response time or service order status changed, a resource was allocated, a service order was shipped or invoiced, and so on. Each line in this window identifies the event that occurred to the service document. The line contains the information about the field that was changed, its old and new value, the date and time when the change took place, and the ID of the user who actually made the changes.];
                      ApplicationArea=#Service;
                      Image=Log;
                      OnAction=VAR
                                 ServDocLog@1000 : Record 5912;
                               BEGIN
                                 ServDocLog.ShowServDocLog(Rec);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=Funk&tion;
                                 ENU=F&unctions];
                      Image=Action }
      { 152     ;2   ;Action    ;
                      CaptionML=[DAN=&Opret debitor;
                                 ENU=&Create Customer];
                      ToolTipML=[DAN=Opret et nyt debitorkort for debitoren i servicedokumentet.;
                                 ENU=Create a new customer card for the customer on the service document.];
                      ApplicationArea=#Service;
                      Image=NewCustomer;
                      OnAction=BEGIN
                                 CLEAR(ServOrderMgt);
                                 ServOrderMgt.CreateNewCustomer(Rec);
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 33      ;1   ;Action    ;
                      CaptionML=[DAN=Lav &ordre;
                                 ENU=Make &Order];
                      ToolTipML=[DAN=Omdan servicetilbuddet til en serviceordre. Serviceordren indeholder servicetilbudsnummeret.;
                                 ENU=Convert the service quote to a service order. The service order will contain the service quote number.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=MakeOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.UPDATE;
                                 CODEUNIT.RUN(CODEUNIT::"Serv-Quote to Order (Yes/No)",Rec);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 40      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DocPrint@1001 : Codeunit 229;
                               BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 DocPrint.PrintServiceHeader(Rec);
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

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No.";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af servicedokumentet, f.eks Ordre 2001.;
                           ENU=Specifies a short description of the service document, such as Order 2001.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som ejer varerne i servicedokumentet.;
                           ENU=Specifies the number of the customer who owns the items in the service document.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             CustomerNoOnAfterValidate;
                           END;
                            }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontakt, som servicen skal leveres til.;
                           ENU=Specifies the number of the contact to whom you will deliver the service.];
                ApplicationArea=#Service;
                SourceExpr="Contact No.";
                OnValidate=BEGIN
                             IF GETFILTER("Contact No.") = xRec."Contact No." THEN
                               IF "Contact No." <> xRec."Contact No." THEN
                                 SETRANGE("Contact No.");
                           END;
                            }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som varerne i bilaget skal leveres til.;
                           ENU=Specifies the name of the customer to whom the items on the document will be shipped.];
                ApplicationArea=#Service;
                SourceExpr=Name }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den debitor, som servicen skal leveres til.;
                           ENU=Specifies the address of the customer to whom the service will be shipped.];
                ApplicationArea=#Service;
                SourceExpr=Address }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Service;
                SourceExpr="Address 2" }

    { 120 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Service;
                SourceExpr="Post Code" }

    { 126 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kontakt, som vil modtage servicen.;
                           ENU=Specifies the name of the contact who will receive the service.];
                ApplicationArea=#Service;
                SourceExpr="Contact Name" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver telefonnummeret til debitoren i serviceordren.;
                           ENU=Specifies the phone number of the customer in this service order.];
                ApplicationArea=#Service;
                SourceExpr="Phone No." }

    { 63  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver mailadressen til debitoren i serviceordren.;
                           ENU=Specifies the email address of the customer in this service order.];
                ApplicationArea=#Service;
                SourceExpr="E-Mail" }

    { 156 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr=City }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens alternative telefonnummer.;
                           ENU=Specifies your customer's alternate phone number.];
                ApplicationArea=#Service;
                SourceExpr="Phone No. 2" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan debitoren ›nsker at modtage notifikationer om f‘rdigg›relse af servicen.;
                           ENU=Specifies how the customer wants to receive notifications about service completion.];
                ApplicationArea=#Service;
                SourceExpr="Notify Customer" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for serviceordren.;
                           ENU=Specifies the type of this service order.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type" }

    { 190 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontrakt, som er knyttet til ordren.;
                           ENU=Specifies the number of the contract associated with the order.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ansl†ede dato, hvor arbejdet p† ordren skal p†begyndes, dvs. n†r serviceordrens status ‘ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the estimated date when work on the order should start, that is, when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Response Date";
                Importance=Promoted }

    { 134 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det ansl†ede klokkesl‘t, hvor arbejdet p† ordren begynder, dvs. n†r serviceordrens status ‘ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the estimated time when work on the order starts, that is, when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Response Time" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prioriteten for serviceordren.;
                           ENU=Specifies the priority of the service order.];
                ApplicationArea=#Service;
                SourceExpr=Priority;
                Importance=Promoted }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serviceordrens status, som afspejler reparations- eller vedligeholdelsesstatus for alle serviceartikler i serviceordren.;
                           ENU=Specifies the service order status, which reflects the repair or maintenance status of all service items on the service order.];
                ApplicationArea=#Service;
                SourceExpr=Status }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 207 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Service;
                SourceExpr="Assigned User ID" }

    { 46  ;1   ;Part      ;
                Name=ServItemLine;
                ApplicationArea=#Advanced;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page5965 }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 75  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             BilltoCustomerNoOnAfterValidat;
                           END;
                            }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact No." }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Name" }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den debitor, som du vil sende fakturaen til.;
                           ENU=Specifies the address of the customer to whom you will send the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address" }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende linje i adressen.;
                           ENU=Specifies an additional line of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address 2" }

    { 107 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Post Code" }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to City" }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact" }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en debitorreference, som bruges ved udskrivning af servicedokumenter.;
                           ENU=Specifies a customer reference, which will be used when printing service documents.];
                ApplicationArea=#Service;
                SourceExpr="Your Reference" }

    { 175 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger, der er tilknyttet servicedokumentet.;
                           ENU=Specifies the code of the salesperson assigned to this service document.];
                ApplicationArea=#Service;
                SourceExpr="Salesperson Code" }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den maksimale enhedspris, der kan angives for en ressource (f.eks. en tekniker) p† alle servicelinjer, som er knyttet til ordren.;
                           ENU=Specifies the maximum unit price that can be set for a resource (for example, a technician) on all service lines linked to this order.];
                ApplicationArea=#Service;
                SourceExpr="Max. Labor Unit Price" }

    { 118 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Service;
                SourceExpr="Document Date" }

    { 180 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 170 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel›b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Service;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 171 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r den relaterede faktura skal betales.;
                           ENU=Specifies when the related invoice must be paid.];
                ApplicationArea=#Service;
                SourceExpr="Due Date";
                Importance=Promoted }

    { 172 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontantrabatprocent, der gives, hvis debitoren betaler inden den dato, der er angivet i feltet Kont.rabatdato.;
                           ENU=Specifies the percentage of payment discount given, if the customer pays by the date entered in the Pmt. Discount Date field.];
                ApplicationArea=#Service;
                SourceExpr="Payment Discount %" }

    { 173 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bel›bet i posten skal v‘re betalt, for at der kan opn†s kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Service;
                SourceExpr="Pmt. Discount Date" }

    { 174 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverf›rsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Service;
                SourceExpr="Payment Method Code" }

    { 177 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel›b p† bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Service;
                SourceExpr="Prices Including VAT";
                OnValidate=BEGIN
                             PricesIncludingVATOnAfterValid;
                           END;
                            }

    { 179 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Service;
                SourceExpr="VAT Bus. Posting Group" }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             ShiptoCodeOnAfterValidate;
                           END;
                            }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name" }

    { 133 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address" }

    { 141 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address 2" }

    { 147 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Post Code";
                Importance=Promoted }

    { 149 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to City" }

    { 157 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Contact";
                Importance=Promoted }

    { 159 ;2   ;Field     ;
                CaptionML=[DAN=Leveringstlf./telefon 2;
                           ENU=Ship-to Phone/Phone 2];
                ToolTipML=[DAN=Angiver telefonnummeret p† den adresse, hvor serviceartiklerne i ordren er placeret.;
                           ENU=Specifies the phone number of the address where the service items in the order are located.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Phone" }

    { 123 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et supplerende telefonnummer p† den adresse, som varerne leveres til.;
                           ENU=Specifies an additional phone number at address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Phone 2" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver mailadressen for den adresse, som varerne leveres til.;
                           ENU=Specifies the email address at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to E-Mail" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serviceartiklens lokation, eksempelvis et lagersted eller distributionscenter.;
                           ENU=Specifies the location of the service item, such as a warehouse or distribution center.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 1901902601;1;Group  ;
                CaptionML=[DAN=Detaljer;
                           ENU=Details] }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver advarselsstatus for svartiden p† ordren.;
                           ENU=Specifies the response time warning status for the order.];
                ApplicationArea=#Service;
                SourceExpr="Warning Status";
                Importance=Promoted }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at servicelinjerne for varer og ressourcer skal knyttes til en serviceartikellinje.;
                           ENU=Specifies that service lines for items and resources must be linked to a service item line.];
                ApplicationArea=#Service;
                SourceExpr="Link Service to Service Item" }

    { 124 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af timer, der er allokeret til varerne i serviceordren.;
                           ENU=Specifies the number of hours allocated to the items in this service order.];
                ApplicationArea=#Service;
                SourceExpr="Allocated Hours" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af ressourceallokeringer til serviceartiklerne i ordren.;
                           ENU=Specifies the number of resource allocations to service items in this order.];
                ApplicationArea=#Service;
                SourceExpr="No. of Allocations" }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af serviceartikler i ordren, som ikke er allokeret til ressourcer.;
                           ENU=Specifies the number of service items in this order that are not allocated to resources.];
                ApplicationArea=#Service;
                SourceExpr="No. of Unallocated Items" }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver servicezonekoden for debitorens leveringsadresse i serviceordren.;
                           ENU=Specifies the service zone code of the customer's ship-to address in the service order.];
                ApplicationArea=#Service;
                SourceExpr="Service Zone Code" }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Date";
                OnValidate=BEGIN
                             OrderDateOnAfterValidate;
                           END;
                            }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor serviceordren blev oprettet.;
                           ENU=Specifies the time when the service order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Time";
                OnValidate=BEGIN
                             OrderTimeOnAfterValidate;
                           END;
                            }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for servicen, dvs. den dato, hvor serviceordrens status ‘ndres fra Igangsat til I arbejde for f›rste gang.;
                           ENU=Specifies the starting date of the service, that is, the date when the order status changes from Pending, to In Process for the first time.];
                ApplicationArea=#Service;
                SourceExpr="Starting Date";
                Importance=Promoted }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl‘ttet for servicen, dvs. det klokkesl‘t hvor serviceordrens status ‘ndres fra Igangsat til I arbejde for f›rste gang.;
                           ENU=Specifies the starting time of the service, that is, the time when the order status changes from Pending, to In Process for the first time.];
                ApplicationArea=#Service;
                SourceExpr="Starting Time" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af timer fra ordreoprettelsen til det tidspunkt, hvor serviceordrens status ‘ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the number of hours from order creation, to when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Actual Response Time (Hours)" }

    { 182 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver f‘rdigg›relsesdatoen for servicen, dvs. den dato, hvor feltet Status ‘ndres til Udf›rt.;
                           ENU=Specifies the finishing date of the service, that is, the date when the Status field changes to Finished.];
                ApplicationArea=#Service;
                SourceExpr="Finishing Date" }

    { 184 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver f‘rdigg›relsesklokkesl‘ttet for servicen, dvs. det klokkesl‘t, hvor feltet Status ‘ndres til Udf›rt.;
                           ENU=Specifies the finishing time of the service, that is, the time when the Status field changes to Finished.];
                ApplicationArea=#Service;
                SourceExpr="Finishing Time";
                OnValidate=BEGIN
                             FinishingTimeOnAfterValidate;
                           END;
                            }

    { 1903873101;1;Group  ;
                CaptionML=[DAN=" Udenrigshandel";
                           ENU=" Foreign Trade"] }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for de forskellige bel›b p† servicelinjerne.;
                           ENU=Specifies the currency code for various amounts on the service lines.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               CLEAR(ChangeExchangeRate);
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
                                 CurrPage.UPDATE;
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 137 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Service;
                SourceExpr="EU 3-Party Trade" }

    { 142 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr‘senterer med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr="Transaction Type" }

    { 153 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr="Transaction Specification" }

    { 146 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm†den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr="Transport Method" }

    { 150 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udf›rselssted, hvor varerne blev udf›rt af landet/omr†det med henblik p† rapportering til Intrastat.;
                           ENU=Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.];
                ApplicationArea=#Service;
                SourceExpr="Exit Point" }

    { 154 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omr†de med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Service;
                SourceExpr=Area }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1902018507;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9082;
                Visible=FALSE;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Customer No.);
                PagePartID=Page9084;
                Visible=FALSE;
                PartType=Page }

    { 1907829707;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Customer No.);
                PagePartID=Page9085;
                Visible=TRUE;
                PartType=Page }

    { 1902613707;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9086;
                Visible=FALSE;
                PartType=Page }

    { 1906530507;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9088;
                ProviderID=46;
                Visible=TRUE;
                PartType=Page }

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
      ServOrderMgt@1019 : Codeunit 5900;
      UserMgt@1024 : Codeunit 5700;
      ChangeExchangeRate@1000 : Page 511;

    LOCAL PROCEDURE CustomerNoOnAfterValidate@19016267();
    BEGIN
      IF GETFILTER("Customer No.") = xRec."Customer No." THEN
        IF "Customer No." <> xRec."Customer No." THEN
          SETRANGE("Customer No.");
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE BilltoCustomerNoOnAfterValidat@19044114();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE PricesIncludingVATOnAfterValid@19009096();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ShiptoCodeOnAfterValidate@19065015();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE OrderTimeOnAfterValidate@19056033();
    BEGIN
      UpdateResponseDateTime;
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE OrderDateOnAfterValidate@19077772();
    BEGIN
      UpdateResponseDateTime;
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE FinishingTimeOnAfterValidate@19010371();
    BEGIN
      CurrPage.UPDATE(TRUE);
    END;

    BEGIN
    END.
  }
}

