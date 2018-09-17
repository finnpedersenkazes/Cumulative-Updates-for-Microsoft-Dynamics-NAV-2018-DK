OBJECT Page 9321 Service Contracts
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
    CaptionML=[DAN=Servicekontrakter;
               ENU=Service Contracts];
    SourceTable=Table5965;
    SourceTableView=WHERE(Contract Type=CONST(Contract));
    PageType=List;
    CardPageID=Service Contract;
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=K&ontrakt;
                                 ENU=&Contract];
                      Image=Agreement }
      { 1102601002;2 ;Action    ;
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
      { 1102601004;2 ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Serviceposter;
                                 ENU=Service Ledger E&ntries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogfõringstransaktioner i servicedokumenter.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Page 5912;
                      RunPageView=SORTING(Service Contract No.);
                      RunPageLink=Service Contract No.=FIELD(Contract No.);
                      Image=ServiceLedger }
      { 1102601005;2 ;Action    ;
                      CaptionML=[DAN=&Garantiposter;
                                 ENU=&Warranty Ledger Entries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogfõringstransaktioner i servicedokumenter, der indeholder garantiaftaler.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents that contain warranty agreements.];
                      ApplicationArea=#Service;
                      RunObject=Page 5913;
                      RunPageView=SORTING(Service Contract No.,Posting Date,Document No.);
                      RunPageLink=Service Contract No.=FIELD(Contract No.);
                      Image=WarrantyLedger }
      { 1102601007;2 ;Action    ;
                      CaptionML=[DAN=Servicera&batter;
                                 ENU=Service Dis&counts];
                      ToolTipML=[DAN=Vis eller rediger de rabatter, som du giver i kontrakten pÜ reservedele (specielt serviceartikelgrupper), rabatterne pÜ ressourcetidsforbrug (specielt ressourcegrupper) og rabatterne pÜ bestemte serviceomkostninger.;
                                 ENU=View or edit the discounts that you grant for the contract on spare parts in particular service item groups, the discounts on resource hours for resources in particular resource groups, and the discounts on particular service costs.];
                      ApplicationArea=#Service;
                      RunObject=Page 6058;
                      RunPageLink=Contract Type=FIELD(Contract Type),
                                  Contract No.=FIELD(Contract No.);
                      Image=Discount }
      { 1102601008;2 ;Action    ;
                      CaptionML=[DAN=Serv.&Übn.tider;
                                 ENU=Service &Hours];
                      ToolTipML=[DAN=Vis de Übningstider, der gëlder for servicekontrakten. I vinduet vises Übnings- og lukketider for hver dag i henhold til servicekontrakten.;
                                 ENU=View the service hours that are valid for the service contract. This window displays the starting and ending service hours for the contract for each weekday.];
                      ApplicationArea=#Service;
                      RunObject=Page 5916;
                      RunPageLink=Service Contract No.=FIELD(Contract No.),
                                  Service Contract Type=FILTER(Contract);
                      Image=ServiceHours }
      { 1102601010;2 ;Action    ;
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
      { 1102601012;2 ;ActionGroup;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      Image=Statistics }
      { 1102601013;3 ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 6059;
                      RunPageLink=Contract Type=CONST(Contract),
                                  Contract No.=FIELD(Contract No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 1102601014;3 ;Action    ;
                      CaptionML=[DAN=Tr&endscape;
                                 ENU=Tr&endscape];
                      ToolTipML=[DAN=Vis en detaljeret oversigt over serviceartikeltransaktioner sortert efter tidsintervaller.;
                                 ENU=View a detailed account of service item transactions by time intervals.];
                      ApplicationArea=#Service;
                      RunObject=Page 6060;
                      RunPageLink=Contract Type=CONST(Contract),
                                  Contract No.=FIELD(Contract No.);
                      Image=Trendscape }
      { 1102601017;2 ;Action    ;
                      CaptionML=[DAN=Arkiverede kontrakter;
                                 ENU=Filed Contracts];
                      ToolTipML=[DAN=Vis servicekontrakter, der er arkiveret.;
                                 ENU=View service contracts that are filed.];
                      ApplicationArea=#Service;
                      RunObject=Page 6073;
                      RunPageView=SORTING(Contract Type Relation,Contract No. Relation,File Date,File Time)
                                  ORDER(Descending);
                      RunPageLink=Contract Type Relation=FIELD(Contract Type),
                                  Contract No. Relation=FIELD(Contract No.);
                      Image=Agreement }
      { 1102601018;2 ;ActionGroup;
                      CaptionML=[DAN=Ser&viceoversigt;
                                 ENU=Ser&vice Overview];
                      Image=Tools }
      { 1102601019;3 ;Action    ;
                      CaptionML=[DAN=Serviceordrer;
                                 ENU=Service Orders];
                      ToolTipML=[DAN=èbn oversigten over igangvërende serviceordrer.;
                                 ENU=Open the list of ongoing service orders.];
                      ApplicationArea=#Service;
                      RunObject=Page 5901;
                      RunPageView=SORTING(Contract No.);
                      RunPageLink=Document Type=CONST(Order),
                                  Contract No.=FIELD(Contract No.);
                      Image=Document }
      { 1102601021;3 ;Action    ;
                      CaptionML=[DAN=Bogfõrte servicefakturaer;
                                 ENU=Posted Service Invoices];
                      ToolTipML=[DAN=èbn listen over bogfõrte servicefakturaer.;
                                 ENU=Open the list of posted service invoices.];
                      ApplicationArea=#Service;
                      RunObject=Page 5968;
                      RunPageView=SORTING(Source Document Type,Source Document No.,Destination Document Type,Destination Document No.)
                                  WHERE(Source Document Type=CONST(Contract),
                                        Destination Document Type=CONST(Posted Invoice));
                      RunPageLink=Source Document No.=FIELD(Contract No.);
                      Image=PostedServiceOrder }
      { 1102601022;2 ;Action    ;
                      CaptionML=[DAN=&índringslog;
                                 ENU=C&hange Log];
                      ToolTipML=[DAN=Vis alle ëndringer, der er foretaget i servicekontrakten.;
                                 ENU=View all changes that have been made to the service contract.];
                      ApplicationArea=#Service;
                      RunObject=Page 6063;
                      RunPageView=SORTING(Contract No.)
                                  ORDER(Descending);
                      RunPageLink=Contract No.=FIELD(Contract No.);
                      Image=ChangeLog }
      { 1102601023;2 ;Action    ;
                      CaptionML=[DAN=Gevi&nst/tabsposter;
                                 ENU=&Gain/Loss Entries];
                      ToolTipML=[DAN=FÜ vist kontraktnummer, Ürsagskode, kontraktgruppekode, ansvarscenter, debitornummer, leveringsadressekode, debitornavn og ëndringstype og kontaktgevinst/tab. Du kan udskrive alle dine kontraktgevinst-/tabsposter.;
                                 ENU=View the contract number, reason code, contract group code, responsibility center, customer number, ship-to code, customer name, and type of change, as well as the contract gain and loss. You can print all your service contract gain/loss entries.];
                      ApplicationArea=#Service;
                      RunObject=Page 6064;
                      RunPageView=SORTING(Contract No.,Change Date)
                                  ORDER(Descending);
                      RunPageLink=Contract No.=FIELD(Contract No.);
                      Image=GainLossEntries }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102601024;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1102601029;2 ;Action    ;
                      CaptionML=[DAN=&Underskriv kontrakt;
                                 ENU=Si&gn Contract];
                      ToolTipML=[DAN=Bekrëft kontrakten.;
                                 ENU=Confirm the contract.];
                      ApplicationArea=#Service;
                      Image=Signature;
                      OnAction=VAR
                                 SignServContractDoc@1001 : Codeunit 5944;
                               BEGIN
                                 CurrPage.UPDATE;
                                 SignServContractDoc.SignContract(Rec);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 1102601037;2 ;Action    ;
                      CaptionML=[DAN=&LÜs kontrakt;
                                 ENU=&Lock Contract];
                      ToolTipML=[DAN=Sõrg for, at ëndringerne indgÜr i kontrakten.;
                                 ENU=Make sure that the changes will be part of the contract.];
                      ApplicationArea=#Service;
                      Image=Lock;
                      OnAction=VAR
                                 LockOpenServContract@1001 : Codeunit 5943;
                               BEGIN
                                 CurrPage.UPDATE;
                                 LockOpenServContract.LockServContract(Rec);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 1102601038;2 ;Action    ;
                      CaptionML=[DAN=&èbn kontrakt;
                                 ENU=&Open Contract];
                      ToolTipML=[DAN=èbn servicekontrakten.;
                                 ENU=Open the service contract.];
                      ApplicationArea=#Service;
                      Image=ReOpen;
                      OnAction=VAR
                                 LockOpenServContract@1001 : Codeunit 5943;
                               BEGIN
                                 CurrPage.UPDATE;
                                 LockOpenServContract.OpenServContract(Rec);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 50      ;1   ;Action    ;
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
      { 1900960706;1 ;Action    ;
                      CaptionML=[DAN=Kontrakt, serviceordre - kontrol;
                                 ENU=Contract, Service Order Test];
                      ToolTipML=[DAN=Vis antallet af kontrakter, numre og navne pÜ kunder samt en rëkke andre oplysninger om de serviceordrer, der er oprettet for den angivne periode. Du kan teste, hvilke servicekontrakter der omfatter serviceartikler, som er forfaldne til service inden for den angivne periode.;
                                 ENU=View the numbers of contracts, the numbers and the names of customers, as well as some other information relating to the service orders that are created for the period that you have specified. You can test which service contracts include service items that are due for service within the specified period.];
                      ApplicationArea=#Service;
                      RunObject=Report 5988;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906775606;1 ;Action    ;
                      CaptionML=[DAN=Servicebesõg - planlëgning;
                                 ENU=Maintenance Visit - Planning];
                      ToolTipML=[DAN=FÜ vist servicezonekoden, gruppekoden, kontraktnummeret, debitornummeret, serviceperioden og servicedatoen. Du kan vëlge at udskrive planen for et eller flere ansvarscentre. Rapporten viser servicedatoerne for alle servicebesõg for de valgte ansvarscentre. Du kan udskrive alle dine planer over servicebesõg.;
                                 ENU=View the service zone code, group code, contract number, customer number, service period, as well as the service date. You can select the schedule for one or more responsibility centers. The report shows the service dates of all the maintenance visits for the chosen responsibility centers. You can print all your schedules for maintenance visits.];
                      ApplicationArea=#Service;
                      RunObject=Report 5980;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1904666406;1 ;Action    ;
                      CaptionML=[DAN=Servicekontraktoplysninger;
                                 ENU=Service Contract Details];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om servicekontrakten.;
                                 ENU=View detailed information for the service contract.];
                      ApplicationArea=#Service;
                      RunObject=Report 5971;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1907252806;1 ;Action    ;
                      CaptionML=[DAN=Servicekontraktavancebelõb;
                                 ENU=Service Contract Profit];
                      ToolTipML=[DAN=Vis servicekontraktens avanceoplysninger.;
                                 ENU=View profit information for the service contract.];
                      ApplicationArea=#Service;
                      RunObject=Report 5976;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903269806;1 ;Action    ;
                      CaptionML=[DAN=Kontraktfaktura - kontrol;
                                 ENU=Contract Invoice Test];
                      ToolTipML=[DAN=Angiver fakturerbare avancer for den sagsopgave, der er relateret til varer.;
                                 ENU=Specifies billable profits for the job task that are related to items.];
                      ApplicationArea=#Service;
                      RunObject=Report 5984;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1907657006;1 ;Action    ;
                      CaptionML=[DAN=Servicekontrakt - debitor;
                                 ENU=Service Contract-Customer];
                      ToolTipML=[DAN=Vis oplysninger om status, nëste faktureringsdato, faktureringsperiode, belõb pr. periode og Ürligt belõb. Du kan udskrive en liste over servicekontrakter for hver debitor i en valgt tidsperiode.;
                                 ENU=View information about status, next invoice date, invoice period, amount per period, and annual amount. You can print a list of service contracts for each customer in a selected time period.];
                      ApplicationArea=#Service;
                      RunObject=Report 5977;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1901090606;1 ;Action    ;
                      CaptionML=[DAN=Servicekontrakt - sëlger;
                                 ENU=Service Contract-Salesperson];
                      ToolTipML=[DAN=Vis debitornummer, navn, beskrivelse, startdato og det Ürlige belõb for hver servicekontrakt. Du kan bruge rapporten til beregning og dokumentation af sëlgerprovision. Du kan udskrive en oversigt over servicekontrakter for hver sëlger i en udvalgt periode.;
                                 ENU=View customer number, name, description, starting date and the annual amount for each service contract. You can use the report to calculate and document sales commission. You can print a list of service contracts for each salesperson for a selected period.];
                      ApplicationArea=#Service;
                      RunObject=Report 5978;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902585006;1 ;Action    ;
                      CaptionML=[DAN=Kontraktsalgsbelõbopd. - kontrol;
                                 ENU=Contract Price Update - Test];
                      ToolTipML=[DAN=Vis kontraktnumrene, debitornumrene, kontraktbelõbene, prisreguleringsprocenterne og de fejl, der evt. opstÜr. Du kan teste, hvilke servicekontrakter der har behov for prisreguleringer op til den dato, du har angivet.;
                                 ENU=View the contracts numbers, customer numbers, contract amounts, price update percentages, and any errors that occur. You can test which service contracts need price updates up to the date that you have specified.];
                      ApplicationArea=#Service;
                      RunObject=Report 5985;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900914206;1 ;Action    ;
                      CaptionML=[DAN=Serviceart. - garanti udlõbet;
                                 ENU=Service Items Out of Warranty];
                      ToolTipML=[DAN=Vis oplysninger om garantiudlõbsdatoer, serienumre, antal aktive kontrakter, varebeskrivelse og navne pÜ debitorer. Du kan udskrive en oversigt over serviceartikler, hvis garanti er udlõbet.;
                                 ENU=View information about warranty end dates, serial numbers, number of active contracts, items description, and names of customers. You can print a list of service items that are out of warranty.];
                      ApplicationArea=#Service;
                      RunObject=Report 5937;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ servicekontrakten eller servicekontrakttilbuddet.;
                           ENU=Specifies the number of the service contract or service contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies the status of the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr=Status }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af servicekontrakten.;
                           ENU=Specifies a description of the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som ejer serviceartiklerne i servicekontrakten/kontrakttilbuddet.;
                           ENU=Specifies the number of the customer who owns the service items in the service contract/contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren i servicekontrakten.;
                           ENU=Specifies the name of the customer in the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Name;
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for servicekontrakten.;
                           ENU=Specifies the starting date of the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Starting Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicekontrakten udlõber.;
                           ENU=Specifies the date when the service contract expires.];
                ApplicationArea=#Service;
                SourceExpr="Expiration Date" }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver, om en servicekontrakt eller et kontrakttilbud er lÜst eller Übent for ëndringer.;
                           ENU=Specifies if a service contract or contract quote is locked or open for changes.];
                ApplicationArea=#Service;
                SourceExpr="Change Status";
                Visible=FALSE }

    { 1102601025;2;Field  ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Service;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 1102601027;2;Field  ;
                ToolTipML=[DAN=Angiver den valuta, der bruges til at beregne belõbene i de dokumenter, der vedrõrer kontrakten.;
                           ENU=Specifies the currency used to calculate the amounts in the documents related to this contract.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 1102601030;2;Field  ;
                ToolTipML=[DAN=Angiver datoen for den fõrste forventede reparation af serviceartiklerne i kontrakten.;
                           ENU=Specifies the date of the first expected service for the service items in the contract.];
                ApplicationArea=#Service;
                SourceExpr="First Service Date";
                Visible=FALSE }

    { 1102601033;2;Field  ;
                ToolTipML=[DAN=Angiver den serviceordretype, der tildeles de serviceordrer, som er knyttet til kontrakten.;
                           ENU=Specifies the service order type assigned to service orders linked to this contract.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type";
                Visible=FALSE }

    { 1102601035;2;Field  ;
                ToolTipML=[DAN=Angiver fakturaperioden for servicekontrakten.;
                           ENU=Specifies the invoice period for the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Invoice Period";
                Visible=FALSE }

    { 1102601039;2;Field  ;
                ToolTipML=[DAN=Angiver den nëste dato, hvor kontraktpriserne skal opdateres.;
                           ENU=Specifies the next date you want contract prices to be updated.];
                ApplicationArea=#Service;
                SourceExpr="Next Price Update Date";
                Visible=FALSE }

    { 1102601041;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor du sidst opdaterede kontraktpriserne.;
                           ENU=Specifies the date you last updated the contract prices.];
                ApplicationArea=#Service;
                SourceExpr="Last Price Update Date";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1902018507;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Bill-to Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9082;
                Visible=TRUE;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9084;
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

    BEGIN
    END.
  }
}

