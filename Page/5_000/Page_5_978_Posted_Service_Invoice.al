OBJECT Page 5978 Posted Service Invoice
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogf›rt servicefaktura;
               ENU=Posted Service Invoice];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table5992;
    PageType=Document;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;
               END;

    OnFindRecord=BEGIN
                   IF FIND(Which) THEN
                     EXIT(TRUE);
                   SETRANGE("No.");
                   EXIT(FIND(Which));
                 END;

    OnAfterGetRecord=BEGIN
                       DocExchStatusStyle := GetDocExchStatusStyle;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           DocExchStatusStyle := GetDocExchStatusStyle;
                           DocExchStatusVisible := "Document Exchange Status" <> "Document Exchange Status"::"Not Sent";
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 55      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&aktura;
                                 ENU=&Invoice];
                      Image=Invoice }
      { 8       ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 6033;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 57      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Type=CONST(General),
                                  Table Name=CONST(Service Invoice Header),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 89      ;2   ;Action    ;
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
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Servicedokumentlo&g;
                                 ENU=Service Document Lo&g];
                      ToolTipML=[DAN=F† vist en liste over de ‘ndringer i servicedokumentet, der er registreret. I programmet oprettes der poster i vinduet, f.eks. n†r svartiden eller serviceordrens status er ‘ndret, en ressource er allokeret, en serviceordre er leveret eller faktureret osv. Hver linje i vinduet identificerer den h‘ndelse, der er forekommet i servicedokumentet. Linjen indeholder oplysninger om det felt, der er ‘ndret, dets gamle og nye v‘rdi, datoen og tidspunktet for, hvorn†r ‘ndringen fandt sted, og id'et for den bruger, som foretog ‘ndringerne.;
                                 ENU=View a list of the service document changes that have been logged. The program creates entries in the window when, for example, the response time or service order status changed, a resource was allocated, a service order was shipped or invoiced, and so on. Each line in this window identifies the event that occurred to the service document. The line contains the information about the field that was changed, its old and new value, the date and time when the change took place, and the ID of the user who actually made the changes.];
                      ApplicationArea=#Service;
                      Image=Log;
                      OnAction=VAR
                                 TempServDocLog@1000 : TEMPORARY Record 5912;
                               BEGIN
                                 TempServDocLog.RESET;
                                 TempServDocLog.DELETEALL;
                                 TempServDocLog.CopyServLog(TempServDocLog."Document Type"::"Posted Invoice","No.");
                                 TempServDocLog.CopyServLog(TempServDocLog."Document Type"::Order,"Order No.");
                                 TempServDocLog.CopyServLog(TempServDocLog."Document Type"::Invoice,"Pre-Assigned No.");

                                 TempServDocLog.RESET;
                                 TempServDocLog.SETCURRENTKEY("Change Date","Change Time");
                                 TempServDocLog.ASCENDING(FALSE);

                                 PAGE.RUN(0,TempServDocLog);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1101100000;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1101100001;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret elektronisk faktura;
                                 ENU=Create Electronic Invoice];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=ElectronicDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ServiceInvHeader := Rec;
                                 ServiceInvHeader.SETRECFILTER;

                                 REPORT.RUNMODAL(REPORT::"Create Elec. Service Invoices",TRUE,FALSE,ServiceInvHeader);
                               END;
                                }
      { 3       ;1   ;Action    ;
                      Name=SendCustom;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Send;
                                 ENU=Send];
                      ToolTipML=[DAN=Klarg›r bilaget til afsendelse i henhold til debitorens afsendelsesprofil, f.eks. vedh‘ftet en mail. Vinduet Send dokument til vises, s† du kan bekr‘fte eller v‘lge en afsendelsesprofil.;
                                 ENU=Prepare to send the document according to the customer's sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendToMultiple;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ServiceInvHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(ServiceInvHeader);
                                 ServiceInvHeader.SendRecords;
                               END;
                                }
      { 58      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ServiceInvHeader);
                                 ServiceInvHeader.PrintRecords(TRUE);
                               END;
                                }
      { 59      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
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
      { 9       ;1   ;Action    ;
                      Name=ActivityLog;
                      CaptionML=[DAN=Aktivitetslogfil;
                                 ENU=Activity Log];
                      ToolTipML=[DAN=Se status og eventuelle fejl, hvis dokumentet blev sendt som et elektronisk dokument eller OCR-fil via dokumentudvekslingstjenesten.;
                                 ENU=View the status and any errors if the document was sent as an electronic document or OCR file through the document exchange service.];
                      ApplicationArea=#Service;
                      Image=Log;
                      OnAction=BEGIN
                                 ShowActivityLog;
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
                ApplicationArea=#Service;
                SourceExpr="No.";
                Importance=Promoted;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som ejer varerne p† fakturaen.;
                           ENU=Specifies the number of the customer who owns the items on the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                Importance=Promoted;
                Editable=FALSE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontakt hos debitoren, som du leverede servicen til.;
                           ENU=Specifies the number of the contact at the customer to whom you shipped the service.];
                ApplicationArea=#Service;
                SourceExpr="Contact No.";
                Editable=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† servicefakturaen.;
                           ENU=Specifies the name of the customer on the service invoice.];
                ApplicationArea=#Service;
                SourceExpr=Name;
                Editable=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† debitoren p† fakturaen.;
                           ENU=Specifies the address of the customer on the invoice.];
                ApplicationArea=#Service;
                SourceExpr=Address;
                Editable=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Service;
                SourceExpr="Address 2";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Service;
                SourceExpr="Post Code";
                Editable=FALSE }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr=City;
                Editable=FALSE }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen i debitorens virksomhed.;
                           ENU=Specifies the name of the contact person at the customer company.];
                ApplicationArea=#Service;
                SourceExpr="Contact Name";
                Editable=FALSE }

    { 1101100002;2;Field  ;
                ToolTipML=[DAN="Angiver rollen for kontaktpersonen hos debitoren. ";
                           ENU="Specifies the role of the contact person at the customer. "];
                SourceExpr="Contact Role";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor fakturaen blev bogf›rt.;
                           ENU=Specifies the date when the invoice was posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 11  ;2   ;Group     ;
                Visible=DocExchStatusVisible;
                GroupType=Group }

    { 5   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver status for dokumentet, hvis du bruger en dokumentudvekslingstjeneste til at sende det som et elektronisk dokument. Statusv‘rdierne rapporteres af dokumentudvekslingstjenesten.;
                           ENU=Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.];
                ApplicationArea=#Service;
                SourceExpr="Document Exchange Status";
                Editable=FALSE;
                StyleExpr=DocExchStatusStyle;
                OnDrillDown=VAR
                              DocExchServDocStatus@1000 : Codeunit 1420;
                            BEGIN
                              DocExchServDocStatus.DocExchStatusDrillDown(Rec);
                            END;
                             }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Service;
                SourceExpr="Document Date";
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceordre, hvorfra fakturaen blev bogf›rt.;
                           ENU=Specifies the number of the service order from which this invoice was posted.];
                ApplicationArea=#Service;
                SourceExpr="Order No.";
                Importance=Promoted;
                Editable=FALSE }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det servicedokumentet, som den bogf›rte faktura blev oprettet fra.;
                           ENU=Specifies the number of the service document from which the posted invoice was created.];
                ApplicationArea=#Service;
                SourceExpr="Pre-Assigned No.";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger, der er knyttet til fakturaen.;
                           ENU=Specifies the code of the salesperson associated with the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Salesperson Code";
                Editable=FALSE }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center";
                Editable=FALSE }

    { 1060000;2;Field     ;
                ToolTipML=[DAN=Angiver debitorens reference.;
                           ENU=Specifies the customer's reference.];
                ApplicationArea=#Service;
                SourceExpr="Your Reference";
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Service;
                SourceExpr="No. Printed";
                Editable=FALSE }

    { 54  ;1   ;Part      ;
                Name=ServInvLines;
                ApplicationArea=#Service;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page5979;
                PartType=Page }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No.";
                Importance=Promoted;
                Editable=FALSE }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact No.";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Name";
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den debitor, du har sendt fakturaen til.;
                           ENU=Specifies the address of the customer to whom you sent the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address";
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende linje i adressen.;
                           ENU=Specifies an additional line of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address 2";
                Editable=FALSE }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Post Code";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to City";
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact";
                Editable=FALSE }

    { 1101100004;2;Field  ;
                ToolTipML=[DAN=Angiver EAN-lokationsnummeret for debitoren.;
                           ENU=Specifies the EAN location number for the customer.];
                ApplicationArea=#Service;
                SourceExpr="EAN No.";
                Editable=FALSE }

    { 1101100006;2;Field  ;
                ToolTipML=[DAN=Angiver kontokoden for debitoren.;
                           ENU=Specifies the account code of the customer.];
                ApplicationArea=#Service;
                SourceExpr="Account Code";
                Editable=FALSE }

    { 1060001;2;Field     ;
                ToolTipML=[DAN=Angiver den profil, som debitoren kr‘ver til elektroniske dokumenter.;
                           ENU=Specifies the profile that this customer requires for electronic documents.];
                ApplicationArea=#Service;
                SourceExpr="OIOUBL Profile Code";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Editable=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Editable=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r den relaterede faktura skal betales.;
                           ENU=Specifies when the related invoice must be paid.];
                ApplicationArea=#Service;
                SourceExpr="Due Date";
                Importance=Promoted;
                Editable=FALSE }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code";
                Importance=Promoted;
                Editable=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name";
                Editable=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address";
                Editable=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address 2";
                Editable=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p† den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Post Code";
                Importance=Promoted;
                Editable=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to City";
                Editable=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Contact";
                Editable=FALSE }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationen, eksempelvis lagerstedet eller distributionscenteret, hvorfra servicen blev sendt.;
                           ENU=Specifies the location, such as warehouse or distribution center, from which the service was shipped.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Editable=FALSE }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel›bene p† fakturaen.;
                           ENU=Specifies the currency code for the amounts on the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                               ChangeExchangeRate.EDITABLE(FALSE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                                 "Currency Factor" := ChangeExchangeRate.GetParameter;
                                 MODIFY;
                               END;
                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen er relateret til handel med tredjepart i EU.;
                           ENU=Specifies if the transaction is related to trade with a third party within the EU.];
                ApplicationArea=#Service;
                SourceExpr="EU 3-Party Trade";
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
      ServiceInvHeader@1000 : Record 5992;
      ChangeExchangeRate@1001 : Page 511;
      DocExchStatusStyle@1002 : Text;
      DocExchStatusVisible@1003 : Boolean;

    BEGIN
    END.
  }
}

