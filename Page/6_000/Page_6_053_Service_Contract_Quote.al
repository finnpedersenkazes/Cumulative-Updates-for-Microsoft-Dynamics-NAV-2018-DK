OBJECT Page 6053 Service Contract Quote
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Servicekontrakttilbud;
               ENU=Service Contract Quote];
    SourceTable=Table5965;
    SourceTableView=WHERE(Contract Type=FILTER(Quote));
    PageType=Document;
    RefreshOnActivate=Yes;
    OnInit=BEGIN
             InvoiceAfterServiceEnable := TRUE;
             PrepaidEnable := TRUE;
           END;

    OnOpenPage=BEGIN
                 IF UserMgt.GetServiceFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetServiceFilter);
                   FILTERGROUP(0);
                 END;
               END;

    OnAfterGetRecord=BEGIN
                       UpdateShiptoCode;
                     END;

    OnNewRecord=BEGIN
                  "Responsibility Center" := UserMgt.GetServiceFilter;
                END;

    OnAfterGetCurrRecord=BEGIN
                           CALCFIELDS("Calcd. Annual Amount");
                           ActivateFields;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 6       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Tilbud;
                                 ENU=&Quote];
                      Image=Quote }
      { 70      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 71      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Service Contract),
                                  Table Subtype=FIELD(Contract Type),
                                  No.=FIELD(Contract No.),
                                  Table Line No.=CONST(0);
                      Image=ViewComments }
      { 81      ;2   ;Action    ;
                      CaptionML=[DAN=Servicera&batter;
                                 ENU=Service Dis&counts];
                      ToolTipML=[DAN=Vis eller rediger de rabatter, som du giver i kontrakten pÜ reservedele (specielt serviceartikelgrupper), rabatterne pÜ ressourcetidsforbrug (specielt ressourcegrupper) og rabatterne pÜ bestemte serviceomkostninger.;
                                 ENU=View or edit the discounts that you grant for the contract on spare parts in particular service item groups, the discounts on resource hours for resources in particular resource groups, and the discounts on particular service costs.];
                      ApplicationArea=#Service;
                      RunObject=Page 6058;
                      RunPageLink=Contract Type=FIELD(Contract Type),
                                  Contract No.=FIELD(Contract No.);
                      Image=Discount }
      { 72      ;2   ;Action    ;
                      CaptionML=[DAN=Serv.&Übn.tider;
                                 ENU=Service &Hours];
                      ToolTipML=[DAN=Vis de Übningstider, der gëlder for servicekontrakten. I vinduet vises Übnings- og lukketider for hver dag i henhold til servicekontrakten.;
                                 ENU=View the service hours that are valid for the service contract. This window displays the starting and ending service hours for the contract for each weekday.];
                      ApplicationArea=#Service;
                      RunObject=Page 5916;
                      RunPageLink=Service Contract No.=FIELD(Contract No.),
                                  Service Contract Type=FILTER(Quote);
                      Image=ServiceHours }
      { 98      ;2   ;Action    ;
                      CaptionML=[DAN=&Arkiv. kontrakttilbud;
                                 ENU=&Filed Contract Quotes];
                      ToolTipML=[DAN=Vis arkiverede kontrakttilbud.;
                                 ENU=View filed contract quotes.];
                      ApplicationArea=#Service;
                      RunObject=Page 6073;
                      RunPageView=SORTING(Contract Type Relation,Contract No. Relation,File Date,File Time)
                                  ORDER(Descending);
                      RunPageLink=Contract Type Relation=FIELD(Contract Type),
                                  Contract No. Relation=FIELD(Contract No.);
                      Image=Quote }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 101     ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 103     ;2   ;Action    ;
                      CaptionML=[DAN=&Vëlg kontrakttilbudslinjer;
                                 ENU=&Select Contract Quote Lines];
                      ToolTipML=[DAN="èbn listen over alle serviceartikler, som er registreret for debitoren, og vëlg, hvilke der skal inkluderes i kontrakttilbuddet. ";
                                 ENU="Open the list of all the service items that are registered to the customer and select which to include in the contract quote. "];
                      ApplicationArea=#Service;
                      Image=CalculateLines;
                      OnAction=BEGIN
                                 CheckRequiredFields;
                                 GetServItemLine;
                               END;
                                }
      { 36      ;2   ;Action    ;
                      CaptionML=[DAN=Ko&piÇr dokument...;
                                 ENU=Copy &Document...];
                      ToolTipML=[DAN=KopiÇr dokumentlinjer og sidehovedoplysninger fra en anden servicekontrakt til denne kontrakt, sÜ der hurtigt kan oprettes et lignende bilag.;
                                 ENU=Copy document lines and header information from another service contractor to this contract to quickly create a similar document.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=CopyDocument;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CheckRequiredFields;
                                 CLEAR(CopyServDoc);
                                 CopyServDoc.SetServContractHeader(Rec);
                                 CopyServDoc.RUNMODAL;
                               END;
                                }
      { 122     ;2   ;Action    ;
                      CaptionML=[DAN=&Arkiver kontrakttilbud;
                                 ENU=&File Contract Quote];
                      ToolTipML=[DAN=Registrer og arkivÇr en kopi af kontrakttilbuddet. Servicekontrakttilbud arkiveres automatisk, nÜr du konverterer kontrakttilbud til servicekontrakter eller annullerer servicekontrakter.;
                                 ENU=Record and archive a copy of the contract quote. Service contract quotes are automatically filed when you convert contract quotes to service contracts or cancel service contracts.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=FileContract;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 IF CONFIRM(Text001) THEN
                                   FiledServContract.FileContract(Rec);
                               END;
                                }
      { 77      ;2   ;Action    ;
                      CaptionML=[DAN=Opdater &rabatpct. pÜ alle linjer;
                                 ENU=Update &Discount % on All Lines];
                      ToolTipML=[DAN=Opdater tilbudsrabatten pÜ alle serviceartiklerne i et servicekontrakttilbud. Du skal angive det tal, som du vil fõje til eller trëkke fra den tilbudsrabatprocent, som du har angivet i tabellen Kontrakt-/servicerabat. Ved kõrslen opdateres tilbudsbelõbene derefter tilsvarende.;
                                 ENU=Update the quote discount on all the service items in a service contract quote. You need to specify the number that you want to add to or subtract from the quote discount percentage that you have specified in the Contract/Service Discount table. The batch job then updates the quote amounts accordingly.];
                      ApplicationArea=#Service;
                      Image=Refresh;
                      OnAction=BEGIN
                                 ServContractLine.RESET;
                                 ServContractLine.SETRANGE("Contract Type","Contract Type");
                                 ServContractLine.SETRANGE("Contract No.","Contract No.");
                                 REPORT.RUNMODAL(REPORT::"Upd. Disc.% on Contract",TRUE,TRUE,ServContractLine);
                               END;
                                }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Opdater med kontrakts&kabelon;
                                 ENU=Update with Contract &Template];
                      ToolTipML=[DAN=Implementer kladdeoplysninger i kontrakten.;
                                 ENU=Implement template information on the contract.];
                      ApplicationArea=#Service;
                      Image=Refresh;
                      OnAction=BEGIN
                                 IF NOT CONFIRM(Text002,TRUE) THEN
                                   EXIT;
                                 CurrPage.UPDATE(TRUE);
                                 CLEAR(ServContrQuoteTmplUpd);
                                 ServContrQuoteTmplUpd.RUN(Rec);
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=&LÜs;
                                 ENU=Loc&k];
                      ToolTipML=[DAN=Sõrg for, at kontrakten ikke kan ëndres.;
                                 ENU=Make sure that the contract cannot be changed.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Lock;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 LockOpenServContract.LockServContract(Rec);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 20      ;2   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=&èbn;
                                 ENU=&Open];
                      ToolTipML=[DAN=èbn servicekontrakttilbuddet.;
                                 ENU=Open the service contract quote.];
                      ApplicationArea=#Service;
                      Image=Edit;
                      OnAction=BEGIN
                                 LockOpenServContract.OpenServContract(Rec);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 86      ;1   ;Action    ;
                      CaptionML=[DAN=&Opret kontrakt;
                                 ENU=&Make Contract];
                      ToolTipML=[DAN=Gõr dig klar til at oprette en servicekontrakt.;
                                 ENU=Prepare to create a service contract.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=MakeAgreement;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SignServContractDoc@1001 : Codeunit 5944;
                               BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 SignServContractDoc.SignContractQuote(Rec);
                               END;
                                }
      { 141     ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Gõr dig klar til at udskrive bilaget. Der Übnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages pÜ udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DocPrint@1001 : Codeunit 229;
                               BEGIN
                                 DocPrint.PrintServiceContract(Rec);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1905622906;1 ;Action    ;
                      CaptionML=[DAN=Servicetilbudsdetaljer;
                                 ENU=Service Quote Details];
                      ToolTipML=[DAN=Vis detaljerne i tilbuddet.;
                                 ENU=View details information for the quote.];
                      ApplicationArea=#Service;
                      RunObject=Report 5973;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1905017306;1 ;Action    ;
                      CaptionML=[DAN=Kontrakttilbud til underskrift;
                                 ENU=Contract Quotes to be Signed];
                      ToolTipML=[DAN=Vis kontraktnummer, kundens navn og adresse, sëlgerkode, startdato, sandsynlighed, tilbudsbelõb og forecast. Du kan udskrive alle oplysninger om de kontrakttilbud, der skal underskrives.;
                                 ENU=View the contract number, customer name and address, salesperson code, starting date, probability, quoted amount, and forecast. You can print all your information about contract quotes to be signed.];
                      ApplicationArea=#Service;
                      RunObject=Report 5974;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
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
                ToolTipML=[DAN=Angiver nummeret pÜ servicekontrakten eller servicekontrakttilbuddet.;
                           ENU=Specifies the number of the service contract or service contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Contract No.";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af servicekontrakten.;
                           ENU=Specifies a description of the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som ejer serviceartiklerne i servicekontrakten/kontrakttilbuddet.;
                           ENU=Specifies the number of the customer who owns the service items in the service contract/contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             CustomerNoOnAfterValidate;
                           END;
                            }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som vil modtage serviceleverancen.;
                           ENU=Specifies the number of the contact who will receive the service delivery.];
                ApplicationArea=#Service;
                SourceExpr="Contact No." }

    { 40  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren i servicekontrakten.;
                           ENU=Specifies the name of the customer in the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Name }

    { 10  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver debitorens adresse.;
                           ENU=Specifies the customer's address.];
                ApplicationArea=#Service;
                SourceExpr=Address }

    { 19  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Service;
                SourceExpr="Address 2" }

    { 26  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Service;
                SourceExpr="Post Code" }

    { 111 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ den by, hvor debitoren befinder sig.;
                           ENU=Specifies the name of the city in where the customer is located.];
                ApplicationArea=#Service;
                SourceExpr=City }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt kontakter, nÜr du handler med debitoren i servicekontrakten.;
                           ENU=Specifies the name of the person you regularly contact when you do business with the customer in this service contract.];
                ApplicationArea=#Service;
                SourceExpr="Contact Name" }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer phone number.];
                ApplicationArea=#Service;
                SourceExpr="Phone No." }

    { 124 ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver debitorens mailadresse.;
                           ENU=Specifies the customer's email address.];
                ApplicationArea=#Service;
                SourceExpr="E-Mail" }

    { 108 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontraktgruppekode, der er tildelt servicekontrakten.;
                           ENU=Specifies the contract group code assigned to the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Contract Group Code" }

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den sëlger, der er tilknyttet servicekontrakten.;
                           ENU=Specifies the code of the salesperson assigned to this service contract.];
                ApplicationArea=#Service;
                SourceExpr="Salesperson Code" }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for servicekontrakttilbuddet.;
                           ENU=Specifies the type of the service contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Quote Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for servicekontrakten.;
                           ENU=Specifies the starting date of the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Starting Date";
                Importance=Promoted;
                OnValidate=BEGIN
                             StartingDateOnAfterValidate;
                           END;
                            }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies the status of the service contract or contract quote.];
                OptionCaptionML=[DAN=" ,,Annulleret";
                                 ENU=" ,,Canceled"];
                ApplicationArea=#Service;
                SourceExpr=Status;
                Importance=Promoted;
                Editable=TRUE;
                OnValidate=BEGIN
                             StatusOnAfterValidate;
                           END;
                            }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en servicekontrakt eller et kontrakttilbud er lÜst eller Übent for ëndringer.;
                           ENU=Specifies if a service contract or contract quote is locked or open for changes.];
                ApplicationArea=#Service;
                SourceExpr="Change Status" }

    { 18  ;1   ;Part      ;
                Name=ServContractLines;
                ApplicationArea=#Service;
                SubPageLink=Contract No.=FIELD(Contract No.);
                PagePartID=Page6054;
                PartType=Page }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             BilltoCustomerNoOnAfterValidat;
                           END;
                            }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen pÜ debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact No." }

    { 84  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Name" }

    { 80  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, som du vil sende fakturaen til.;
                           ENU=Specifies the address of the customer to whom you will send the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address" }

    { 79  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver en supplerende linje i adressen.;
                           ENU=Specifies an additional line of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address 2" }

    { 107 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Post Code" }

    { 87  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to City" }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact" }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens referencenummer.;
                           ENU=Specifies the customer's reference number.];
                ApplicationArea=#Service;
                SourceExpr="Your Reference" }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der er knyttet til servicekontraktkontogruppen.;
                           ENU=Specifies the code associated with the service contract account group.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Contract Acc. Gr. Code" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Service;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valuta, der bruges til at beregne belõbene i de dokumenter, der vedrõrer kontrakten.;
                           ENU=Specifies the currency used to calculate the amounts in the documents related to this contract.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code";
                Importance=Promoted }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             ShiptoCodeOnAfterValidate;
                           END;
                            }

    { 127 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name" }

    { 129 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address" }

    { 131 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address 2" }

    { 152 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver postnummeret pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Post Code";
                Importance=Promoted }

    { 112 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to City" }

    { 1902138501;1;Group  ;
                CaptionML=[DAN=Service;
                           ENU=Service] }

    { 159 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicezonen for debitorens leveringsadresse.;
                           ENU=Specifies the code of the service zone of the customer ship-to address.];
                ApplicationArea=#Service;
                SourceExpr="Service Zone Code";
                Importance=Promoted }

    { 144 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en standardserviceperiode for varerne i kontrakten.;
                           ENU=Specifies a default service period for the items in the contract.];
                ApplicationArea=#Service;
                SourceExpr="Service Period";
                Importance=Promoted;
                OnValidate=BEGIN
                             ServicePeriodOnAfterValidate;
                           END;
                            }

    { 143 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for den fõrste forventede reparation af serviceartiklerne i kontrakten.;
                           ENU=Specifies the date of the first expected service for the service items in the contract.];
                ApplicationArea=#Service;
                SourceExpr="First Service Date";
                Importance=Promoted }

    { 142 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver svartiden for servicekontrakten.;
                           ENU=Specifies the response time for the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Response Time (Hours)";
                OnValidate=BEGIN
                             ResponseTimeHoursOnAfterValida;
                           END;
                            }

    { 139 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den serviceordretype, der tildeles de serviceordrer, som er knyttet til kontrakten.;
                           ENU=Specifies the service order type assigned to service orders linked to this contract.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type" }

    { 1905361901;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details] }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der vil blive faktureret pr. Ür for servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies the amount that will be invoiced annually for the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Annual Amount";
                OnValidate=BEGIN
                             AnnualAmountOnAfterValidate;
                           END;
                            }

    { 154 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om indholdet i feltet Beregnet Ürligt belõb kopieres til feltet èrligt belõb i servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies if the contents of the Calcd. Annual Amount field are copied into the Annual Amount field in the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Allow Unbalanced Amounts";
                OnValidate=BEGIN
                             AllowUnbalancedAmountsOnAfterV;
                           END;
                            }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af vërdierne i feltet Linjebelõb pÜ alle kontraktlinjer, der er tilknyttet servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies the sum of the Line Amount field values on all contract lines associated with the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Calcd. Annual Amount" }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fakturaperioden for servicekontrakten.;
                           ENU=Specifies the invoice period for the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Invoice Period";
                Importance=Promoted }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for den nëste faktura for servicekontrakten.;
                           ENU=Specifies the date of the next invoice for this service contract.];
                ApplicationArea=#Service;
                SourceExpr="Next Invoice Date";
                Importance=Promoted }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der vil blive faktureret for hver faktureringsperiode for servicekontrakten.;
                           ENU=Specifies the amount that will be invoiced for each invoice period for the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Amount per Period" }

    { 147 ;2   ;Field     ;
                CaptionML=[DAN=Nëste faktureringsperiode;
                           ENU=Next Invoice Period];
                ToolTipML=[DAN=Angiver den nëste faktureringsperiode for det arkiverede servicekontrakttilbud: den fõrste dato i perioden og slutdatoen.;
                           ENU=Specifies the next invoice period for the filed service contract quote: the first date of the period and the ending date.];
                ApplicationArea=#Service;
                SourceExpr=NextInvoicePeriod }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at servicekontrakten er forudbetalt.;
                           ENU=Specifies that this service contract is prepaid.];
                ApplicationArea=#Service;
                SourceExpr=Prepaid;
                Enabled=PrepaidEnable;
                OnValidate=BEGIN
                             PrepaidOnAfterValidate;
                           END;
                            }

    { 138 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der oprettes en kreditnota, nÜr du fjerner en kontraktlinje.;
                           ENU=Specifies that a credit memo is created when you remove a contract line.];
                ApplicationArea=#Service;
                SourceExpr="Automatic Credit Memos" }

    { 133 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kun kan fakturere kontrakten, hvis du har bogfõrt en serviceordre, siden du sidst fakturerede kontrakten.;
                           ENU=Specifies that you can only invoice the contract if you have posted a service order since last time you invoiced the contract.];
                ApplicationArea=#Service;
                SourceExpr="Invoice after Service";
                Enabled=InvoiceAfterServiceEnable;
                OnValidate=BEGIN
                             InvoiceafterServiceOnAfterVali;
                           END;
                            }

    { 145 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du vil kombinere fakturaer for denne servicekontrakt med fakturaer for andre servicekontrakter med samme faktureringsdebitor.;
                           ENU=Specifies you want to combine invoices for this service contract with invoices for other service contracts with the same bill-to customer.];
                ApplicationArea=#Service;
                SourceExpr="Combine Invoices" }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at linjerne for kontrakten skal vises som tekst pÜ fakturaen.;
                           ENU=Specifies that you want the lines for this contract to appear as text on the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Contract Lines on Invoice" }

    { 1904390801;1;Group  ;
                CaptionML=[DAN=Prisregulering;
                           ENU=Price Update] }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisopdateringsperioden for servicekontrakten.;
                           ENU=Specifies the price update period for this service contract.];
                ApplicationArea=#Service;
                SourceExpr="Price Update Period";
                Importance=Promoted }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nëste dato, hvor kontraktpriserne skal opdateres.;
                           ENU=Specifies the next date you want contract prices to be updated.];
                ApplicationArea=#Service;
                SourceExpr="Next Price Update Date";
                Importance=Promoted }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den standardtekstkode, der udskrives pÜ servicefakturaer og informerer debitoren om, hvilke priser der er opdateret siden sidste faktura.;
                           ENU=Specifies the standard text code printed on service invoices, informing the customer which prices have been updated since the last invoice.];
                ApplicationArea=#Service;
                SourceExpr="Price Inv. Increase Code" }

    { 1901902601;1;Group  ;
                CaptionML=[DAN=Detaljer;
                           ENU=Details] }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicekontrakten udlõber.;
                           ENU=Specifies the date when the service contract expires.];
                ApplicationArea=#Service;
                SourceExpr="Expiration Date";
                OnValidate=BEGIN
                             ExpirationDateOnAfterValidate;
                           END;
                            }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den maksimale enhedspris, der kan angives for en ressource pÜ alle serviceordrer og -linjer for servicekontrakten.;
                           ENU=Specifies the maximum unit price that can be set for a resource on all service orders and lines for the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Max. Labor Unit Price" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, inden hvilken debitoren skal acceptere kontrakttilbuddet.;
                           ENU=Specifies the date before which the customer must accept this contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Accept Before" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor sandsynligt det er, at debitoren godkender servicekontrakttilbuddet.;
                           ENU=Specifies the probability of the customer approving the service contract quote.];
                ApplicationArea=#Service;
                SourceExpr=Probability }

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
      Text000@1000 : TextConst '@@@=Contract No. must not be blank in Service Contract Header SC00004;DAN=%1 mÜ ikke vëre tom i %2 %3;ENU=%1 must not be blank in %2 %3';
      Text001@1001 : TextConst 'DAN=Skal kontrakttilbuddet arkiveres?;ENU=Do you want to file the contract quote?';
      Text002@1002 : TextConst 'DAN=Skal kontrakten opdateres ved hjëlp af en kontraktskabelon?;ENU=Do you want to update the contract quote using a contract template?';
      FiledServContract@1004 : Record 5970;
      ServContractLine@1005 : Record 5964;
      CopyServDoc@1012 : Report 5979;
      UserMgt@1007 : Codeunit 5700;
      ServContrQuoteTmplUpd@1008 : Codeunit 5942;
      Text003@1003 : TextConst '@@@=Status must not be blank in Signed SC00001;DAN=%1 mÜ ikke vëre %2 i %3 %4;ENU=%1 must not be %2 in %3 %4';
      LockOpenServContract@1010 : Codeunit 5943;
      PrepaidEnable@19025160 : Boolean INDATASET;
      InvoiceAfterServiceEnable@19024761 : Boolean INDATASET;

    LOCAL PROCEDURE ActivateFields@2();
    BEGIN
      PrepaidEnable := (NOT "Invoice after Service" OR Prepaid);
      InvoiceAfterServiceEnable := (NOT Prepaid OR "Invoice after Service");
    END;

    LOCAL PROCEDURE CheckRequiredFields@1();
    BEGIN
      IF "Contract No." = '' THEN
        ERROR(Text000,FIELDCAPTION("Contract No."),TABLECAPTION,"Contract No.");
      IF "Customer No." = '' THEN
        ERROR(Text000,FIELDCAPTION("Customer No."),TABLECAPTION,"Contract No.");
      IF FORMAT("Service Period") = '' THEN
        ERROR(Text000,FIELDCAPTION("Service Period"),TABLECAPTION,"Contract No.");
      IF "First Service Date" = 0D THEN
        ERROR(Text000,FIELDCAPTION("First Service Date"),TABLECAPTION,"Contract No.");
      IF Status = Status::Canceled THEN
        ERROR(Text003,FIELDCAPTION(Status),FORMAT(Status),TABLECAPTION,"Contract No.");
      IF "Change Status" = "Change Status"::Locked THEN
        ERROR(Text003,FIELDCAPTION("Change Status"),FORMAT("Change Status"),TABLECAPTION,"Contract No.");
    END;

    LOCAL PROCEDURE GetServItemLine@5();
    VAR
      ContractLineSelection@1005 : Page 6057;
    BEGIN
      CLEAR(ContractLineSelection);
      ContractLineSelection.SetSelection("Customer No.","Ship-to Code","Contract Type","Contract No.");
      ContractLineSelection.RUNMODAL;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE StatusOnAfterValidate@19072689();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE CustomerNoOnAfterValidate@19016267();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE StartingDateOnAfterValidate@19020273();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE BilltoCustomerNoOnAfterValidat@19044114();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ShiptoCodeOnAfterValidate@19065015();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ResponseTimeHoursOnAfterValida@19023139();
    BEGIN
      CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE AnnualAmountOnAfterValidate@19051853();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE InvoiceafterServiceOnAfterVali@19065496();
    BEGIN
      ActivateFields;
    END;

    LOCAL PROCEDURE AllowUnbalancedAmountsOnAfterV@19018309();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE PrepaidOnAfterValidate@19004759();
    BEGIN
      ActivateFields;
    END;

    LOCAL PROCEDURE ExpirationDateOnAfterValidate@19018149();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ServicePeriodOnAfterValidate@19066190();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

