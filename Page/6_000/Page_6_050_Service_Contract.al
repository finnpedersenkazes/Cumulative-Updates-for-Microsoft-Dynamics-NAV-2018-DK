OBJECT Page 6050 Service Contract
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Servicekontrakt;
               ENU=Service Contract];
    SourceTable=Table5965;
    SourceTableView=WHERE(Contract Type=FILTER(Contract));
    PageType=Document;
    RefreshOnActivate=Yes;
    OnInit=BEGIN
             InvoiceAfterServiceEnable := TRUE;
             PrepaidEnable := TRUE;
             FirstServiceDateEditable := TRUE;
           END;

    OnOpenPage=BEGIN
                 IF UserMgt.GetServiceFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetServiceFilter);
                   FILTERGROUP(0);
                 END;

                 ActivateFields;
               END;

    OnAfterGetRecord=BEGIN
                       UpdateShiptoCode;
                     END;

    OnNewRecord=BEGIN
                  "Responsibility Center" := UserMgt.GetServiceFilter;
                END;

    OnAfterGetCurrRecord=BEGIN
                           CALCFIELDS("Calcd. Annual Amount","No. of Posted Invoices","No. of Unposted Invoices");
                           ActivateFields;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=Overview] }
      { 161     ;2   ;ActionGroup;
                      CaptionML=[DAN=Ser&viceoversigt;
                                 ENU=Ser&vice Overview];
                      Image=Tools }
      { 87      ;3   ;Action    ;
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
      { 88      ;3   ;Action    ;
                      CaptionML=[DAN=Bogfõrte serviceleverancer;
                                 ENU=Posted Service Shipments];
                      ToolTipML=[DAN=èbn listen over bogfõrte serviceleverancer.;
                                 ENU=Open the list of posted service shipments.];
                      ApplicationArea=#Service;
                      Image=PostedShipment;
                      OnAction=VAR
                                 TempServShptHeader@1001 : TEMPORARY Record 5990;
                               BEGIN
                                 CollectShpmntsByLineContractNo(TempServShptHeader);
                                 PAGE.RUNMODAL(PAGE::"Posted Service Shipments",TempServShptHeader);
                               END;
                                }
      { 29      ;3   ;Action    ;
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
      { 94      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&ontrakt;
                                 ENU=&Contract];
                      Image=Agreement }
      { 69      ;2   ;Action    ;
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
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=Servicera&batter;
                                 ENU=Service Dis&counts];
                      ToolTipML=[DAN=Vis eller rediger de rabatter, som du giver i kontrakten pÜ reservedele (specielt serviceartikelgrupper), rabatterne pÜ ressourcetidsforbrug (specielt ressourcegrupper) og rabatterne pÜ bestemte serviceomkostninger.;
                                 ENU=View or edit the discounts that you grant for the contract on spare parts in particular service item groups, the discounts on resource hours for resources in particular resource groups, and the discounts on particular service costs.];
                      ApplicationArea=#Service;
                      RunObject=Page 6058;
                      RunPageLink=Contract Type=FIELD(Contract Type),
                                  Contract No.=FIELD(Contract No.);
                      Image=Discount }
      { 136     ;2   ;Action    ;
                      CaptionML=[DAN=Serv.&Übn.tider;
                                 ENU=Service &Hours];
                      ToolTipML=[DAN=Vis de Übningstider, der gëlder for servicekontrakten. I vinduet vises Übnings- og lukketider for hver dag i henhold til servicekontrakten.;
                                 ENU=View the service hours that are valid for the service contract. This window displays the starting and ending service hours for the contract for each weekday.];
                      ApplicationArea=#Service;
                      RunObject=Page 5916;
                      RunPageLink=Service Contract No.=FIELD(Contract No.),
                                  Service Contract Type=FILTER(Contract);
                      Image=ServiceHours }
      { 21      ;2   ;ActionGroup;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      Image=Statistics }
      { 178     ;3   ;Action    ;
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
      { 97      ;3   ;Action    ;
                      CaptionML=[DAN=Tr&endscape;
                                 ENU=Tr&endscape];
                      ToolTipML=[DAN=Vis en detaljeret oversigt over serviceartikeltransaktioner sortert efter tidsintervaller.;
                                 ENU=View a detailed account of service item transactions by time intervals.];
                      ApplicationArea=#Service;
                      RunObject=Page 6060;
                      RunPageLink=Contract Type=CONST(Contract),
                                  Contract No.=FIELD(Contract No.);
                      Image=Trendscape }
      { 145     ;2   ;Action    ;
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
      { 99      ;2   ;Action    ;
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
      { 194     ;2   ;Action    ;
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
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History] }
      { 116     ;2   ;Action    ;
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
      { 149     ;2   ;Action    ;
                      CaptionML=[DAN=&Garantiposter;
                                 ENU=&Warranty Ledger Entries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogfõringstransaktioner i servicedokumenter, der indeholder garantiaftaler.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents that contain warranty agreements.];
                      ApplicationArea=#Service;
                      RunObject=Page 5913;
                      RunPageView=SORTING(Service Contract No.,Posting Date,Document No.);
                      RunPageLink=Service Contract No.=FIELD(Contract No.);
                      Image=WarrantyLedger }
      { 96      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Service&poster;
                                 ENU=Service Ledger E&ntries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogfõringstransaktioner i servicedokumenter.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Page 5912;
                      RunPageView=SORTING(Service Contract No.);
                      RunPageLink=Service Contract No.=FIELD(Contract No.);
                      Image=ServiceLedger }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Generelt;
                                 ENU=General] }
      { 112     ;2   ;Action    ;
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
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Nye dokumenter;
                                 ENU=New Documents] }
      { 110     ;2   ;Action    ;
                      CaptionML=[DAN=Opret servicekredit&nota;
                                 ENU=Create Service Credit &Memo];
                      ToolTipML=[DAN=Opret en ny kreditnota for den relaterede servicefaktura.;
                                 ENU=Create a new credit memo for the related service invoice.];
                      ApplicationArea=#Service;
                      Image=CreateCreditMemo;
                      OnAction=VAR
                                 W1@1000 : Dialog;
                                 CreditNoteNo@1001 : Code[20];
                                 i@1003 : Integer;
                                 j@1004 : Integer;
                                 LineFound@1005 : Boolean;
                               BEGIN
                                 CurrPage.UPDATE;
                                 TESTFIELD(Status,Status::Signed);
                                 IF "No. of Unposted Credit Memos" <> 0 THEN
                                   IF NOT CONFIRM(Text009) THEN
                                     EXIT;

                                 ServContractMgt.CopyCheckSCDimToTempSCDim(Rec);

                                 IF NOT CONFIRM(Text010,FALSE) THEN
                                   EXIT;

                                 ServContractLine.RESET;
                                 ServContractLine.SETCURRENTKEY("Contract Type","Contract No.",Credited,"New Line");
                                 ServContractLine.SETRANGE("Contract Type","Contract Type");
                                 ServContractLine.SETRANGE("Contract No.","Contract No.");
                                 ServContractLine.SETRANGE(Credited,FALSE);
                                 ServContractLine.SETFILTER("Credit Memo Date",'>%1&<=%2',0D,WORKDATE);
                                 i := ServContractLine.COUNT;
                                 j := 0;
                                 IF ServContractLine.FIND('-') THEN BEGIN
                                   LineFound := TRUE;
                                   W1.OPEN(
                                     Text011 +
                                     '@1@@@@@@@@@@@@@@@@@@@@@');
                                   CLEAR(ServContractMgt);
                                   ServContractMgt.InitCodeUnit;
                                   REPEAT
                                     ServContractLine1 := ServContractLine;
                                     CreditNoteNo := ServContractMgt.CreateContractLineCreditMemo(ServContractLine1,FALSE);
                                     j := j + 1;
                                     W1.UPDATE(1,ROUND(j / i * 10000,1));
                                   UNTIL ServContractLine.NEXT = 0;
                                   ServContractMgt.FinishCodeunit;
                                   W1.CLOSE;
                                   CurrPage.UPDATE(FALSE);
                                 END;
                                 ServContractLine.SETFILTER("Credit Memo Date",'>%1',WORKDATE);
                                 IF CreditNoteNo <> '' THEN
                                   MESSAGE(STRSUBSTNO(Text012,CreditNoteNo))
                                 ELSE
                                   IF NOT ServContractLine.FIND('-') OR LineFound THEN
                                     MESSAGE(Text013)
                                   ELSE
                                     MESSAGE(Text016,ServContractLine.FIELDCAPTION("Credit Memo Date"),ServContractLine."Credit Memo Date");
                               END;
                                }
      { 83      ;2   ;Action    ;
                      Name=CreateServiceInvoice;
                      CaptionML=[DAN=&Opret servicefaktura;
                                 ENU=Create Service &Invoice];
                      ToolTipML=[DAN="Opret en servicefaktura pÜ en servicekontrakt, der er forfalden til fakturering. ";
                                 ENU="Create a service invoice for a service contract that is due for invoicing. "];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=NewInvoice;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.UPDATE;
                                 TESTFIELD(Status,Status::Signed);
                                 TESTFIELD("Change Status","Change Status"::Locked);

                                 IF "No. of Unposted Invoices" <> 0 THEN
                                   IF NOT CONFIRM(Text003) THEN
                                     EXIT;

                                 IF "Invoice Period" = "Invoice Period"::None THEN
                                   ERROR(STRSUBSTNO(
                                       Text004,
                                       TABLECAPTION,"Contract No.",FIELDCAPTION("Invoice Period"),FORMAT("Invoice Period")));

                                 IF "Next Invoice Date" > WORKDATE THEN
                                   IF ("Last Invoice Date" = 0D) AND
                                      ("Starting Date" < "Next Invoice Period Start")
                                   THEN BEGIN
                                     CLEAR(ServContractMgt);
                                     ServContractMgt.InitCodeUnit;
                                     IF ServContractMgt.CreateRemainingPeriodInvoice(Rec) <> '' THEN
                                       MESSAGE(Text006);
                                     ServContractMgt.FinishCodeunit;
                                     EXIT;
                                   END ELSE
                                     ERROR(Text005);

                                 ServContractMgt.CopyCheckSCDimToTempSCDim(Rec);

                                 IF CONFIRM(Text007) THEN BEGIN
                                   CLEAR(ServContractMgt);
                                   ServContractMgt.InitCodeUnit;
                                   ServContractMgt.CreateInvoice(Rec);
                                   ServContractMgt.FinishCodeunit;
                                   MESSAGE(Text008);
                                 END;
                               END;
                                }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=LÜs;
                                 ENU=Lock] }
      { 73      ;2   ;Action    ;
                      Name=LockContract;
                      CaptionML=[DAN=&LÜs kontrakt;
                                 ENU=&Lock Contract];
                      ToolTipML=[DAN=Sõrg for, at ëndringerne indgÜr i kontrakten.;
                                 ENU=Make sure that the changes will be part of the contract.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Lock;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 LockOpenServContract@1001 : Codeunit 5943;
                               BEGIN
                                 CurrPage.UPDATE;
                                 LockOpenServContract.LockServContract(Rec);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 74      ;2   ;Action    ;
                      Name=OpenContract;
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
      { 137     ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 75      ;2   ;Action    ;
                      Name=SelectContractLines;
                      CaptionML=[DAN=&Vëlg kontraktlinjer;
                                 ENU=&Select Contract Lines];
                      ToolTipML=[DAN="èbn listen over alle serviceartikler, som er registreret for debitoren, og vëlg, hvilke der skal inkluderes i kontrakten. ";
                                 ENU="Open the list of all the service items that are registered to the customer and select which to include in the contract. "];
                      ApplicationArea=#Service;
                      Image=CalculateLines;
                      OnAction=BEGIN
                                 CheckRequiredFields;
                                 GetServItemLine;
                               END;
                                }
      { 77      ;2   ;Action    ;
                      CaptionML=[DAN=&Fjern kontraktlinjer;
                                 ENU=&Remove Contract Lines];
                      ToolTipML=[DAN=Fjern de valgte kontraktlinjer fra servicekontrakten, eksempelvis fordi du fjerner de tilsvarende serviceartikler, nÜr de er udlõbet eller beskadiget.;
                                 ENU=Remove the selected contract lines from the service contract, for example because you remove the corresponding service items as they are expired or broken.];
                      ApplicationArea=#Service;
                      Image=RemoveLine;
                      OnAction=BEGIN
                                 ServContractLine.RESET;
                                 ServContractLine.SETRANGE("Contract Type","Contract Type");
                                 ServContractLine.SETRANGE("Contract No.","Contract No.");
                                 REPORT.RUNMODAL(REPORT::"Remove Lines from Contract",TRUE,TRUE,ServContractLine);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 76      ;2   ;Action    ;
                      Name=SignContract;
                      CaptionML=[DAN=&Underskriv kontrakt;
                                 ENU=Si&gn Contract];
                      ToolTipML=[DAN=Bekrëft kontrakten.;
                                 ENU=Confirm the contract.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Signature;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SignServContractDoc@1001 : Codeunit 5944;
                               BEGIN
                                 CurrPage.UPDATE;
                                 SignServContractDoc.SignContract(Rec);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 103     ;2   ;Action    ;
                      CaptionML=[DAN=S&kift debitor;
                                 ENU=C&hange Customer];
                      ToolTipML=[DAN=Skift debitoren i en servicekontrakt. Hvis en serviceartikel, der er med i en servicekontrakt, er registreret i andre kontrakter, der tilhõrer debitoren, ëndres ejeren af alle serviceartikelrelaterede kontrakter og alle kontraktrelaterede serviceartikler automatisk.;
                                 ENU=Change the customer in a service contract. If a service item that is subject to a service contract is registered in other contracts owned by the customer, the owner is automatically changed for all service item-related contracts and all contract-related service items.];
                      ApplicationArea=#Service;
                      Image=ChangeCustomer;
                      OnAction=BEGIN
                                 CLEAR(ChangeCustomerinContract);
                                 ChangeCustomerinContract.SetRecord("Contract No.");
                                 ChangeCustomerinContract.RUNMODAL;
                               END;
                                }
      { 20      ;2   ;Action    ;
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
      { 150     ;2   ;Action    ;
                      CaptionML=[DAN=&Arkiver kontrakt;
                                 ENU=&File Contract];
                      ToolTipML=[DAN=Registrer og arkivÇr en kopi af kontrakten. Servicekontrakter arkiveres automatisk, nÜr du konverterer kontrakttilbud til servicekontrakter eller annullerer servicekontrakter.;
                                 ENU=Record and archive a copy of the contract. Service contracts are automatically filed when you convert contract quotes to service contracts or cancel service contracts.];
                      ApplicationArea=#Service;
                      Image=Agreement;
                      OnAction=BEGIN
                                 IF CONFIRM(Text014) THEN
                                   FiledServContract.FileContract(Rec);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1903183006;1 ;Action    ;
                      CaptionML=[DAN=Kontraktdetaljer;
                                 ENU=Contract Details];
                      ToolTipML=[DAN=Angiver fakturerbare priser for den sagsopgave, der er relateret til varer.;
                                 ENU=Specifies billable prices for the job task that are related to items.];
                      ApplicationArea=#Service;
                      RunObject=Report 5971;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906367306;1 ;Action    ;
                      CaptionML=[DAN=Gevinst-/tabsposter - kontrakt;
                                 ENU=Contract Gain/Loss Entries];
                      ToolTipML=[DAN=Angiver fakturerbare priser for den sagsopgave, der er relateret til finanskonti, anfõrt i den lokale valuta.;
                                 ENU=Specifies billable prices for the job task that are related to G/L accounts, expressed in the local currency.];
                      ApplicationArea=#Service;
                      RunObject=Report 5983;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906957906;1 ;Action    ;
                      CaptionML=[DAN=Kontraktfakturering;
                                 ENU=Contract Invoicing];
                      ToolTipML=[DAN=Angiver alle fakturerbare avancer for sagsopgaven.;
                                 ENU=Specifies all billable profits for the job task.];
                      ApplicationArea=#Service;
                      RunObject=Report 5984;
                      Promoted=Yes;
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
      { 1906186206;1 ;Action    ;
                      CaptionML=[DAN=Forudbetalt kontrakt;
                                 ENU=Prepaid Contract];
                      ToolTipML=[DAN=Vis den forudbetalte servicekontrakt.;
                                 ENU=View the prepaid service contract.];
                      ApplicationArea=#Prepayments;
                      RunObject=Report 5986;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1905491506;1 ;Action    ;
                      CaptionML=[DAN=Udlõbne kontraktlinjer;
                                 ENU=Expired Contract Lines];
                      ToolTipML=[DAN=Vis servicekontrakten, de serviceartikler, der skal fjernes, kontraktudlõbsdatoer og linjebelõb.;
                                 ENU=View the service contract, the service items to be removed, the contract expiration dates, and the line amounts.];
                      ApplicationArea=#Service;
                      RunObject=Report 5987;
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

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af servicekontrakten.;
                           ENU=Specifies a description of the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som ejer serviceartiklerne i servicekontrakten/kontrakttilbuddet.;
                           ENU=Specifies the number of the customer who owns the service items in the service contract/contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             CustomerNoOnAfterValidate;
                           END;
                            }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kontakt, som vil modtage serviceleverancen.;
                           ENU=Specifies the number of the contact who will receive the service delivery.];
                ApplicationArea=#Service;
                SourceExpr="Contact No." }

    { 42  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren i servicekontrakten.;
                           ENU=Specifies the name of the customer in the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Name }

    { 32  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver debitorens adresse.;
                           ENU=Specifies the customer's address.];
                ApplicationArea=#Service;
                SourceExpr=Address }

    { 120 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Service;
                SourceExpr="Address 2" }

    { 50  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Service;
                SourceExpr="Post Code" }

    { 126 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ den by, hvor debitoren befinder sig.;
                           ENU=Specifies the name of the city in where the customer is located.];
                ApplicationArea=#Service;
                SourceExpr=City }

    { 114 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ den person, du normalt kontakter, nÜr du handler med debitoren i servicekontrakten.;
                           ENU=Specifies the name of the person you regularly contact when you do business with the customer in this service contract.];
                ApplicationArea=#Service;
                SourceExpr="Contact Name" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer phone number.];
                ApplicationArea=#Service;
                SourceExpr="Phone No." }

    { 67  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver debitorens mailadresse.;
                           ENU=Specifies the customer's email address.];
                ApplicationArea=#Service;
                SourceExpr="E-Mail" }

    { 158 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontraktgruppekode, der er tildelt servicekontrakten.;
                           ENU=Specifies the contract group code assigned to the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Contract Group Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den sëlger, der er tilknyttet servicekontrakten.;
                           ENU=Specifies the code of the salesperson assigned to this service contract.];
                ApplicationArea=#Service;
                SourceExpr="Salesperson Code" }

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

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies the status of the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr=Status;
                Importance=Promoted;
                OnValidate=BEGIN
                             ActivateFields;
                             StatusOnAfterValidate;
                           END;
                            }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en servicekontrakt eller et kontrakttilbud er lÜst eller Übent for ëndringer.;
                           ENU=Specifies if a service contract or contract quote is locked or open for changes.];
                ApplicationArea=#Service;
                SourceExpr="Change Status" }

    { 93  ;1   ;Part      ;
                Name=ServContractLines;
                ApplicationArea=#Service;
                SubPageLink=Contract No.=FIELD(Contract No.);
                PagePartID=Page6052;
                PartType=Page }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 138 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             BilltoCustomerNoOnAfterValidat;
                           END;
                            }

    { 140 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen pÜ debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact No." }

    { 122 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Name" }

    { 123 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, du har sendt fakturaen til.;
                           ENU=Specifies the address of the customer to whom you sent the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address" }

    { 130 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver en supplerende linje i adressen.;
                           ENU=Specifies an additional line of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Address 2" }

    { 139 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Post Code" }

    { 131 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to City" }

    { 133 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact" }

    { 132 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens referencenummer.;
                           ENU=Specifies the customer's reference number.];
                ApplicationArea=#Service;
                SourceExpr="Your Reference" }

    { 118 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der er knyttet til servicekontraktkontogruppen.;
                           ENU=Specifies the code associated with the service contract account group.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Contract Acc. Gr. Code" }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Service;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valuta, der bruges til at beregne belõbene i de dokumenter, der vedrõrer kontrakten.;
                           ENU=Specifies the currency used to calculate the amounts in the documents related to this contract.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code";
                Importance=Promoted }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code";
                Importance=Promoted;
                OnValidate=BEGIN
                             ShiptoCodeOnAfterValidate;
                           END;
                            }

    { 162 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name" }

    { 164 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver den adresse, som varerne leveres til.;
                           ENU=Specifies the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address" }

    { 166 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver en supplerende del af leveringsadressen, hvis det er en lang adresse.;
                           ENU=Specifies an additional part of the ship-to address, in case it is a long address.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Address 2" }

    { 128 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver postnummeret pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Post Code";
                Importance=Promoted }

    { 127 ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver byen i den adresse, som varerne leveres til.;
                           ENU=Specifies the city of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to City" }

    { 1902138501;1;Group  ;
                CaptionML=[DAN=Service;
                           ENU=Service] }

    { 188 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicezonen for debitorens leveringsadresse.;
                           ENU=Specifies the code of the service zone of the customer ship-to address.];
                ApplicationArea=#Service;
                SourceExpr="Service Zone Code";
                Importance=Promoted }

    { 186 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en standardserviceperiode for varerne i kontrakten.;
                           ENU=Specifies a default service period for the items in the contract.];
                ApplicationArea=#Service;
                SourceExpr="Service Period";
                OnValidate=BEGIN
                             ServicePeriodOnAfterValidate;
                           END;
                            }

    { 183 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for den fõrste forventede reparation af serviceartiklerne i kontrakten.;
                           ENU=Specifies the date of the first expected service for the service items in the contract.];
                ApplicationArea=#Service;
                SourceExpr="First Service Date";
                Importance=Promoted;
                Editable=FirstServiceDateEditable;
                OnValidate=BEGIN
                             FirstServiceDateOnAfterValidat;
                           END;
                            }

    { 181 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver svartiden for servicekontrakten.;
                           ENU=Specifies the response time for the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Response Time (Hours)";
                OnValidate=BEGIN
                             ResponseTimeHoursOnAfterValida;
                           END;
                            }

    { 180 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den serviceordretype, der tildeles de serviceordrer, som er knyttet til kontrakten.;
                           ENU=Specifies the service order type assigned to service orders linked to this contract.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type" }

    { 1905361901;1;Group  ;
                CaptionML=[DAN=Fakturadetaljer;
                           ENU=Invoice Details] }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der vil blive faktureret pr. Ür for servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies the amount that will be invoiced annually for the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Annual Amount";
                OnValidate=BEGIN
                             AnnualAmountOnAfterValidate;
                           END;
                            }

    { 153 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om indholdet i feltet Beregnet Ürligt belõb kopieres til feltet èrligt belõb i servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies if the contents of the Calcd. Annual Amount field are copied into the Annual Amount field in the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Allow Unbalanced Amounts";
                OnValidate=BEGIN
                             AllowUnbalancedAmountsOnAfterV;
                           END;
                            }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af vërdierne i feltet Linjebelõb pÜ alle kontraktlinjer, der er tilknyttet servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies the sum of the Line Amount field values on all contract lines associated with the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Calcd. Annual Amount" }

    { 107 ;2   ;Field     ;
                Name=InvoicePeriod;
                ToolTipML=[DAN=Angiver fakturaperioden for servicekontrakten.;
                           ENU=Specifies the invoice period for the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Invoice Period";
                Importance=Promoted }

    { 16  ;2   ;Field     ;
                Name=NextInvoiceDate;
                ToolTipML=[DAN=Angiver datoen for den nëste faktura for servicekontrakten.;
                           ENU=Specifies the date of the next invoice for this service contract.];
                ApplicationArea=#Service;
                SourceExpr="Next Invoice Date";
                Importance=Promoted }

    { 12  ;2   ;Field     ;
                Name=AmountPerPeriod;
                ToolTipML=[DAN=Angiver det belõb, der vil blive faktureret for hver faktureringsperiode for servicekontrakten.;
                           ENU=Specifies the amount that will be invoiced for each invoice period for the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Amount per Period" }

    { 18  ;2   ;Field     ;
                Name=NextInvoicePeriod;
                CaptionML=[DAN=Nëste faktureringsperiode;
                           ENU=Next Invoice Period];
                ToolTipML=[DAN=Angiver slutdatoen for den nëste faktureringsperiode for servicekontrakten.;
                           ENU=Specifies the ending date of the next invoice period for the service contract.];
                ApplicationArea=#Service;
                SourceExpr=NextInvoicePeriod }

    { 134 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicekontrakten sidst blev faktureret.;
                           ENU=Specifies the date when this service contract was last invoiced.];
                ApplicationArea=#Service;
                SourceExpr="Last Invoice Date" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at servicekontrakten er forudbetalt.;
                           ENU=Specifies that this service contract is prepaid.];
                ApplicationArea=#Service;
                SourceExpr=Prepaid;
                Enabled=PrepaidEnable;
                OnValidate=BEGIN
                             PrepaidOnAfterValidate;
                           END;
                            }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der oprettes en kreditnota, nÜr du fjerner en kontraktlinje.;
                           ENU=Specifies that a credit memo is created when you remove a contract line.];
                ApplicationArea=#Service;
                SourceExpr="Automatic Credit Memos" }

    { 173 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kun kan fakturere kontrakten, hvis du har bogfõrt en serviceordre, siden du sidst fakturerede kontrakten.;
                           ENU=Specifies that you can only invoice the contract if you have posted a service order since last time you invoiced the contract.];
                ApplicationArea=#Service;
                SourceExpr="Invoice after Service";
                Enabled=InvoiceAfterServiceEnable;
                OnValidate=BEGIN
                             InvoiceafterServiceOnAfterVali;
                           END;
                            }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du vil kombinere fakturaer for denne servicekontrakt med fakturaer for andre servicekontrakter med samme faktureringsdebitor.;
                           ENU=Specifies you want to combine invoices for this service contract with invoices for other service contracts with the same bill-to customer.];
                ApplicationArea=#Service;
                SourceExpr="Combine Invoices" }

    { 151 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at linjerne for kontrakten skal vises som tekst pÜ fakturaen.;
                           ENU=Specifies that you want the lines for this contract to appear as text on the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Contract Lines on Invoice" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af ikke-bogfõrte servicefakturaer, der er knyttet til servicekontrakten.;
                           ENU=Specifies the number of unposted service invoices linked to the service contract.];
                ApplicationArea=#Service;
                SourceExpr="No. of Unposted Invoices" }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af ikke-bogfõrte kreditnotaer, der er knyttet til servicekontrakten.;
                           ENU=Specifies the number of unposted credit memos linked to the service contract.];
                ApplicationArea=#Service;
                SourceExpr="No. of Unposted Credit Memos" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af bogfõrte servicefakturaer, der er knyttet til servicekontrakten.;
                           ENU=Specifies the number of posted service invoices linked to the service contract.];
                ApplicationArea=#Service;
                SourceExpr="No. of Posted Invoices" }

    { 146 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af bogfõrte kreditnotaer, der er knyttet til servicekontrakten.;
                           ENU=Specifies the number of posted credit memos linked to this service contract.];
                ApplicationArea=#Service;
                SourceExpr="No. of Posted Credit Memos" }

    { 1904390801;1;Group  ;
                CaptionML=[DAN=Prisregulering;
                           ENU=Price Update] }

    { 155 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisopdateringsperioden for servicekontrakten.;
                           ENU=Specifies the price update period for this service contract.];
                ApplicationArea=#Service;
                SourceExpr="Price Update Period";
                Importance=Promoted }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nëste dato, hvor kontraktpriserne skal opdateres.;
                           ENU=Specifies the next date you want contract prices to be updated.];
                ApplicationArea=#Service;
                SourceExpr="Next Price Update Date";
                Importance=Promoted }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den prisopdateringsprocent, du brugte sidste gang, du opdaterede kontraktpriserne.;
                           ENU=Specifies the price update percentage you used the last time you updated the contract prices.];
                ApplicationArea=#Service;
                SourceExpr="Last Price Update %" }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du sidst opdaterede kontraktpriserne.;
                           ENU=Specifies the date you last updated the contract prices.];
                ApplicationArea=#Service;
                SourceExpr="Last Price Update Date" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den standardtekstkode, der udskrives pÜ servicefakturaer og informerer debitoren om, hvilke priser der er opdateret siden sidste faktura.;
                           ENU=Specifies the standard text code printed on service invoices, informing the customer which prices have been updated since the last invoice.];
                ApplicationArea=#Service;
                SourceExpr="Print Increase Text" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den standardtekstkode, der udskrives pÜ servicefakturaer og informerer debitoren om, hvilke priser der er opdateret siden sidste faktura.;
                           ENU=Specifies the standard text code printed on service invoices, informing the customer which prices have been updated since the last invoice.];
                ApplicationArea=#Service;
                SourceExpr="Price Inv. Increase Code" }

    { 1901902601;1;Group  ;
                CaptionML=[DAN=Detaljer;
                           ENU=Details] }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicekontrakten udlõber.;
                           ENU=Specifies the date when the service contract expires.];
                ApplicationArea=#Service;
                SourceExpr="Expiration Date";
                OnValidate=BEGIN
                             ExpirationDateOnAfterValidate;
                           END;
                            }

    { 168 ;2   ;Field     ;
                ToolTipML=[DAN=Angiveren Ürsagskode for annullering af servicekontrakten.;
                           ENU=Specifies a reason code for canceling the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Cancel Reason Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den maksimale enhedspris, der kan angives for en ressource pÜ alle serviceordrer og -linjer for servicekontrakten.;
                           ENU=Specifies the maximum unit price that can be set for a resource on all service orders and lines for the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Max. Labor Unit Price" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1902018507;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9082;
                Visible=TRUE;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Customer No.);
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
    VAR
      Text000@1016 : TextConst '@@@=Contract No. must not be blank in Service Contract Header SC00004;DAN=%1 mÜ ikke vëre tom i %2 %3;ENU=%1 must not be blank in %2 %3';
      Text003@1003 : TextConst 'DAN=Der er knyttet fakturaer, der ikke er bogfõrt, til denne kontrakt.\\Vil du fortsëtte?;ENU=There are unposted invoices associated with this contract.\\Do you want to continue?';
      Text004@1004 : TextConst '@@@=You cannot create an invoice for Service Contract Header Contract No. because Invoice Period is Month.;DAN=Du kan ikke oprette en faktura for %1 %2, fordi %3 er %4.;ENU=You cannot create an invoice for %1 %2 because %3 is %4.';
      Text005@1005 : TextConst 'DAN=Den nëste fakturadato er ikke udlõbet.;ENU=The next invoice date has not expired.';
      Text006@1006 : TextConst 'DAN=Der blev oprettet en faktura.;ENU=An invoice was created successfully.';
      Text007@1007 : TextConst 'DAN=Vil du oprette en faktura til kontrakten?;ENU=Do you want to create an invoice for the contract?';
      Text008@1008 : TextConst 'DAN=Fakturaen blev oprettet.;ENU=The invoice was created successfully.';
      Text009@1009 : TextConst 'DAN=Der er knyttet kreditnotaer, der ikke er bogfõrt, til denne kontrakt.\\Vil du fortsëtte?;ENU=There are unposted credit memos associated with this contract.\\Do you want to continue?';
      Text010@1010 : TextConst 'DAN=Vil du oprette en kreditnota til kontrakten?;ENU=Do you want to create a credit note for the contract?';
      Text011@1011 : TextConst 'DAN=Behandler...        \\;ENU=Processing...        \\';
      Text012@1012 : TextConst 'DAN=Kontraktlinjerne er blevet krediteret.\\Kreditnotaen %1 blev oprettet.;ENU=Contract lines have been credited.\\Credit memo %1 was created.';
      Text013@1013 : TextConst 'DAN=Der kan ikke oprettes en kreditnota. Der skal vëre mindst Çn faktureret og udlõbet servicekontraktlinje, der endnu ikke er krediteret.;ENU=A credit memo cannot be created. There must be at least one invoiced and expired service contract line which has not yet been credited.';
      Text014@1014 : TextConst 'DAN=Skal kontrakten arkiveres?;ENU=Do you want to file the contract?';
      ServContractLine@1015 : Record 5964;
      ServContractLine1@1001 : Record 5964;
      FiledServContract@1017 : Record 5970;
      ChangeCustomerinContract@1000 : Report 6037;
      CopyServDoc@1021 : Report 5979;
      ServContractMgt@1018 : Codeunit 5940;
      UserMgt@1019 : Codeunit 5700;
      Text015@1022 : TextConst '@@@=Status must not be Locked in Service Contract Header SC00005;DAN=%1 mÜ ikke vëre %2 i %3 %4;ENU=%1 must not be %2 in %3 %4';
      Text016@1023 : TextConst '@@@=A credit memo cannot be created, because the Credit Memo Date 03-02-11 is after the work date.;DAN=Der kan ikke oprettes en kreditnota, fordi %1 %2 er efter arbejdsdatoen.;ENU=A credit memo cannot be created, because the %1 %2 is after the work date.';
      FirstServiceDateEditable@19053837 : Boolean INDATASET;
      PrepaidEnable@19025160 : Boolean INDATASET;
      InvoiceAfterServiceEnable@19024761 : Boolean INDATASET;

    LOCAL PROCEDURE CollectShpmntsByLineContractNo@4(VAR TempServShptHeader@1002 : TEMPORARY Record 5990);
    VAR
      ServShptHeader@1000 : Record 5990;
      ServShptLine@1001 : Record 5991;
    BEGIN
      TempServShptHeader.RESET;
      TempServShptHeader.DELETEALL;
      ServShptLine.RESET;
      ServShptLine.SETCURRENTKEY("Contract No.");
      ServShptLine.SETRANGE("Contract No.","Contract No.");
      IF ServShptLine.FIND('-') THEN
        REPEAT
          IF ServShptHeader.GET(ServShptLine."Document No.") THEN BEGIN
            TempServShptHeader.COPY(ServShptHeader);
            IF TempServShptHeader.INSERT THEN;
          END;
        UNTIL ServShptLine.NEXT = 0;
    END;

    LOCAL PROCEDURE ActivateFields@2();
    BEGIN
      FirstServiceDateEditable := Status <> Status::Signed;
      PrepaidEnable := (NOT "Invoice after Service" OR Prepaid);
      InvoiceAfterServiceEnable := (NOT Prepaid OR "Invoice after Service");
    END;

    [External]
    PROCEDURE CheckRequiredFields@1();
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
        ERROR(Text015,FIELDCAPTION(Status),FORMAT(Status),TABLECAPTION,"Contract No.");
      IF "Change Status" = "Change Status"::Locked THEN
        ERROR(Text015,FIELDCAPTION("Change Status"),FORMAT("Change Status"),TABLECAPTION,"Contract No.");
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

    LOCAL PROCEDURE StartingDateOnAfterValidate@19020273();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE StatusOnAfterValidate@19072689();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE CustomerNoOnAfterValidate@19016267();
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

    LOCAL PROCEDURE ServicePeriodOnAfterValidate@19066190();
    BEGIN
      CurrPage.UPDATE;
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

    LOCAL PROCEDURE FirstServiceDateOnAfterValidat@6();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

