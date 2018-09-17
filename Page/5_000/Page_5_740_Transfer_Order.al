OBJECT Page 5740 Transfer Order
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Overflytningsordre;
               ENU=Transfer Order];
    SourceTable=Table5740;
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Frigiv,Bogfõring,Ordre,Bilag;
                                ENU=New,Process,Report,Release,Posting,Order,Documents];
    OnOpenPage=BEGIN
                 SetDocNoVisible;
                 EnableTransferFields := NOT IsPartiallyShipped;
               END;

    OnAfterGetRecord=BEGIN
                       EnableTransferFields := NOT IsPartiallyShipped;
                     END;

    OnDeleteRecord=BEGIN
                     TESTFIELD(Status,Status::Open);
                   END;

    OnAfterGetCurrRecord=BEGIN
                           IF NOT DisableEditDirectTransfer THEN
                             DisableEditDirectTransfer := "Direct Transfer" AND HasTransferLines;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ordre;
                                 ENU=O&rder];
                      Image=Order }
      { 27      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om overflytningsordren, f.eks. antal og samlet vëgt, der overfõres.;
                                 ENU=View statistical information about the transfer order, such as the quantity and total weight transferred.];
                      ApplicationArea=#Location;
                      RunObject=Page 5755;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5750;
                      RunPageLink=Document Type=CONST(Transfer Order),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 65      ;2   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 81      ;2   ;Action    ;
                      CaptionML=[DAN=Le&verancer;
                                 ENU=S&hipments];
                      ToolTipML=[DAN=FÜ vist relaterede bogfõrte overflytningsleverancer.;
                                 ENU=View related posted transfer shipments.];
                      ApplicationArea=#Location;
                      RunObject=Page 5752;
                      RunPageLink=Transfer Order No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Shipment;
                      PromotedCategory=Category7;
                      PromotedOnly=Yes }
      { 82      ;2   ;Action    ;
                      CaptionML=[DAN=Modtage&lser;
                                 ENU=Re&ceipts];
                      ToolTipML=[DAN=FÜ vist relaterede bogfõrte overflytningskvitteringer.;
                                 ENU=View related posted transfer receipts.];
                      ApplicationArea=#Location;
                      RunObject=Page 5753;
                      RunPageLink=Transfer Order No.=FIELD(No.);
                      Promoted=Yes;
                      Image=PostedReceipts;
                      PromotedCategory=Category7;
                      PromotedOnly=Yes }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 98      ;2   ;Action    ;
                      CaptionML=[DAN=Lag&erleverancer;
                                 ENU=Whse. Shi&pments];
                      ToolTipML=[DAN=FÜ vist udgÜende varer, der er afsendt med lageraktiviteter for overflytningsordren.;
                                 ENU=View outbound items that have been shipped with warehouse activities for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7341;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(5741),
                                  Source Subtype=CONST(0),
                                  Source No.=FIELD(No.);
                      Image=Shipment }
      { 97      ;2   ;Action    ;
                      CaptionML=[DAN=L&agermodtagelser;
                                 ENU=&Whse. Receipts];
                      ToolTipML=[DAN=FÜ vist indgÜende varer, der er modtaget med lageraktiviteter for overflytningsordren.;
                                 ENU=View inbound items that have been received with warehouse activities for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7342;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(5741),
                                  Source Subtype=CONST(1),
                                  Source No.=FIELD(No.);
                      Image=Receipt }
      { 85      ;2   ;Action    ;
                      CaptionML=[DAN=L&ëg-pÜ-lager/pluklinjer (lag.);
                                 ENU=In&vt. Put-away/Pick Lines];
                      ToolTipML=[DAN=FÜ vist ind- eller udgÜende varer pÜ lëg-pÜ-lager- eller lagerplukningsbilag for overflytningsordren.;
                                 ENU=View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5774;
                      RunPageView=SORTING(Source Document,Source No.,Location Code);
                      RunPageLink=Source Document=FILTER(Inbound Transfer|Outbound Transfer),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 69      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages pÜ udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 DocPrint@1001 : Codeunit 229;
                               BEGIN
                                 DocPrint.PrintTransferHeader(Rec);
                               END;
                                }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 59      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Location;
                      RunObject=Codeunit 5708;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 48      ;2   ;Action    ;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Reo&pen];
                      ToolTipML=[DAN=èbn overflytningsordren igen efter frigivelse til lagerekspedition.;
                                 ENU=Reopen the transfer order after being released for warehouse handling.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      Image=ReOpen;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ReleaseTransferDoc@1001 : Codeunit 5708;
                               BEGIN
                                 ReleaseTransferDoc.Reopen(Rec);
                               END;
                                }
      { 58      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 5778    ;2   ;Action    ;
                      AccessByPermission=TableData 7320=R;
                      CaptionML=[DAN=Opre&t lagerleverance;
                                 ENU=Create Whse. S&hipment];
                      ToolTipML=[DAN=Opret en lagerleverance for at starte et pluk eller en leveringsproces i henhold til en avanceret lageropsëtning.;
                                 ENU=Create a warehouse shipment to start a pick a ship process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewShipment;
                      OnAction=VAR
                                 GetSourceDocOutbound@1001 : Codeunit 5752;
                               BEGIN
                                 GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
                               END;
                                }
      { 84      ;2   ;Action    ;
                      AccessByPermission=TableData 7316=R;
                      CaptionML=[DAN=Opr&et lagermodtagelse;
                                 ENU=Create &Whse. Receipt];
                      ToolTipML=[DAN=Opret en lagermodtagelse for at starte en lëg-pÜ-lager-proces i henhold til en avanceret lageropsëtning.;
                                 ENU=Create a warehouse receipt to start a receive and put-away process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewReceipt;
                      OnAction=VAR
                                 GetSourceDocInbound@1001 : Codeunit 5751;
                               BEGIN
                                 GetSourceDocInbound.CreateFromInbndTransferOrder(Rec);
                               END;
                                }
      { 94      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret l&ëg-pÜ-lager (lager)/pluk (lager);
                                 ENU=Create Inventor&y Put-away/Pick];
                      ToolTipML=[DAN=Opret en lëg-pÜ-lager-aktivitet eller et lagerpluk til hÜndtering af varer pÜ bilaget med en grundlëggende lagerproces, der ikke krëver lagermodtagelse eller leverancedokumenter.;
                                 ENU=Create an inventory put-away or inventory pick to handle items on the document with a basic warehouse process that does not require warehouse receipt or shipment documents.];
                      ApplicationArea=#Warehouse;
                      Image=CreateInventoryPickup;
                      OnAction=BEGIN
                                 CreateInvtPutAwayPick;
                               END;
                                }
      { 95      ;2   ;Action    ;
                      AccessByPermission=TableData 7302=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent placeringsindh.;
                                 ENU=Get Bin Content];
                      ToolTipML=[DAN=Brug en funktion til oprettelse af overflytningslinjer med varer, der skal lëgges pÜ lager eller plukkes, baseret pÜ det faktiske indhold pÜ den angivne placering.;
                                 ENU=Use a function to create transfer lines with items to put away or pick based on the actual content in the specified bin.];
                      ApplicationArea=#Warehouse;
                      Image=GetBinContent;
                      OnAction=VAR
                                 BinContent@1002 : Record 7302;
                                 GetBinContent@1000 : Report 7391;
                               BEGIN
                                 BinContent.SETRANGE("Location Code","Transfer-from Code");
                                 GetBinContent.SETTABLEVIEW(BinContent);
                                 GetBinContent.InitializeTransferHeader(Rec);
                                 GetBinContent.RUNMODAL;
                               END;
                                }
      { 62      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      Image=Post }
      { 66      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogfõr;
                                 ENU=P&ost];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden ved at bogfõre belõb og antal pÜ de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post (Yes/No)",Rec);
                                 IF NOT DisableEditDirectTransfer THEN
                                   DisableEditDirectTransfer := HasShippedItems;
                               END;
                                }
      { 67      ;2   ;Action    ;
                      Name=PostAndPrint;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogfõr og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden fërdiggõres og forberedes til udskrivning. Vërdierne og antallene bogfõres pÜ de relaterede konti. Du fÜr vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post + Print",Rec);
                                 IF NOT DisableEditDirectTransfer THEN
                                   DisableEditDirectTransfer := HasShippedItems;
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1901320106;1 ;Action    ;
                      CaptionML=[DAN=Lager - indgÜende overflytning;
                                 ENU=Inventory - Inbound Transfer];
                      ToolTipML=[DAN=FÜ vist, hvilke varer der i õjeblikket findes pÜ indgÜende overflytningsordrer.;
                                 ENU=View which items are currently on inbound transfer orders.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 5702;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Location;
                SourceExpr="No.";
                Importance=Promoted;
                Visible=DocNoVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the code of the location that items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Code";
                Importance=Promoted;
                Editable=(Status = Status::Open) AND EnableTransferFields }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes til.;
                           ENU=Specifies the code of the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Code";
                Importance=Promoted;
                Editable=(Status = Status::Open) AND EnableTransferFields }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at overfõrslen ikke anvender en transitlokation. NÜr du overfõrer direkte, lÜses feltet Modtag (antal) med samme vërdi som det antal, der skal leveres.;
                           ENU=Specifies that the transfer does not use an in-transit location. When you transfer directly, the Qty. to Receive field will be locked with the same value as the quantity to ship.];
                ApplicationArea=#Location;
                SourceExpr="Direct Transfer";
                Importance=Promoted;
                Editable=(NOT DisableEditDirectTransfer) AND (Status = Status::Open) AND EnableTransferFields;
                OnValidate=BEGIN
                             CurrPage.UPDATE;
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transitkoden for overflytningsordren, f.eks. en speditõr.;
                           ENU=Specifies the in-transit code for the transfer order, such as a shipping agent.];
                ApplicationArea=#Location;
                SourceExpr="In-Transit Code";
                Enabled=(NOT "Direct Transfer") AND (Status = Status::Open);
                Editable=EnableTransferFields }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogfõringsdatoen for overflytningsordren.;
                           ENU=Specifies the posting date of the transfer order.];
                ApplicationArea=#Location;
                SourceExpr="Posting Date";
                OnValidate=BEGIN
                             PostingDateOnAfterValidate;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Location;
                SourceExpr="Shortcut Dimension 1 Code";
                Importance=Additional;
                Editable=EnableTransferFields }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Location;
                SourceExpr="Shortcut Dimension 2 Code";
                Importance=Additional;
                Editable=EnableTransferFields }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Location;
                SourceExpr="Assigned User ID";
                Importance=Additional;
                Editable=EnableTransferFields }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om overflytningsordren er Üben eller frigivet til nëste trin i behandlingen.;
                           ENU=Specifies whether the transfer order is open or has been released for warehouse handling.];
                ApplicationArea=#Location;
                SourceExpr=Status;
                Importance=Promoted }

    { 55  ;1   ;Part      ;
                Name=TransferLines;
                ApplicationArea=#Location;
                SubPageLink=Document No.=FIELD(No.),
                            Derived From Line No.=CONST(0);
                PagePartID=Page5741;
                PartType=Page;
                UpdatePropagation=Both }

    { 11  ;1   ;Group     ;
                CaptionML=[DAN=Leverance;
                           ENU=Shipment];
                Editable=(Status = Status::Open) AND EnableTransferFields;
                GroupType=Group }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Location;
                SourceExpr="Shipment Date";
                OnValidate=BEGIN
                             ShipmentDateOnAfterValidate;
                           END;
                            }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en datoformel for den tid, det tager at gõre varerne klar til forsendelse fra denne lokation. Tidselementet anvendes ved beregning af leveringsdatoen pÜ fõlgende mÜde: Afsendelsesdato + UdgÜende lagerekspeditionstid = Planlagt afsendelsesdato + Transporttid = Planlagt leveringsdato.";
                           ENU="Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date."];
                ApplicationArea=#Warehouse;
                SourceExpr="Outbound Whse. Handling Time";
                OnValidate=BEGIN
                             OutboundWhseHandlingTimeOnAfte;
                           END;
                            }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Location;
                SourceExpr="Shipment Method Code" }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den speditõr, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Agent Code";
                OnValidate=BEGIN
                             ShippingAgentCodeOnAfterValida;
                           END;
                            }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af speditõren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Agent Service Code";
                Importance=Additional;
                OnValidate=BEGIN
                             ShippingAgentServiceCodeOnAfte;
                           END;
                            }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid der gÜr, fra varerne er sendt fra lageret, til de er leveret.;
                           ENU=Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Time";
                OnValidate=BEGIN
                             ShippingTimeOnAfterValidate;
                           END;
                            }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en instruktion til det lager, der afsender varerne, f.eks. at det er tilladt at foretage delleveringer.;
                           ENU=Specifies an instruction to the warehouse that ships the items, for example, that it is acceptable to do partial shipment.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Advice";
                Importance=Additional;
                OnValidate=BEGIN
                             IF "Shipping Advice" <> xRec."Shipping Advice" THEN
                               IF NOT CONFIRM(Text000,FALSE,FIELDCAPTION("Shipping Advice")) THEN
                                 ERROR('');
                           END;
                            }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forventede dato for modtagelsen af leverancen til den lokation, der overflyttes til.;
                           ENU=Specifies the date that you expect the transfer-to location to receive the shipment.];
                ApplicationArea=#Location;
                SourceExpr="Receipt Date";
                OnValidate=BEGIN
                             ReceiptDateOnAfterValidate;
                           END;
                            }

    { 1904655901;1;Group  ;
                CaptionML=[DAN=Overflyt fra;
                           ENU=Transfer-from];
                Editable=(Status = Status::Open) AND EnableTransferFields }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ afsenderen pÜ den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the name of the sender at the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Name" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af navnet pÜ afsenderen pÜ den lokation, som varerne overflyttes fra.;
                           ENU=Specifies an additional part of the name of the sender at the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Name 2";
                Importance=Additional }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the address of the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Address";
                Importance=Additional }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af adressen pÜ den lokation, som varerne overflyttes fra.;
                           ENU=Specifies an additional part of the address of the location that items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Address 2";
                Importance=Additional }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the postal code of the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Post Code";
                Importance=Additional }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the city of the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from City";
                Importance=Additional }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the name of the contact person at the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Contact";
                Importance=Additional }

    { 1901454601;1;Group  ;
                CaptionML=[DAN=Overflyt til;
                           ENU=Transfer-to];
                Editable=(Status = Status::Open) AND EnableTransferFields }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ modtageren pÜ den lokation, som varerne overflyttes til.;
                           ENU=Specifies the name of the recipient at the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Name" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af navnet pÜ modtageren pÜ den lokation, som varerne overflyttes til.;
                           ENU=Specifies an additional part of the name of the recipient at the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Name 2";
                Importance=Additional }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ den lokation, som varerne overflyttes til.;
                           ENU=Specifies the address of the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Address";
                Importance=Additional }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af adressen pÜ den lokation, som varerne overflyttes til.;
                           ENU=Specifies an additional part of the address of the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Address 2";
                Importance=Additional }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for den lokation, som varerne overflyttes til.;
                           ENU=Specifies the postal code of the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Post Code";
                Importance=Additional }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den lokation, som varer overflyttes til.;
                           ENU=Specifies the city of the location that items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to City";
                Importance=Additional }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den lokation, som varer overflyttes til.;
                           ENU=Specifies the name of the contact person at the location that items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Contact";
                Importance=Additional }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, det tager at gõre varer tilgëngelige fra lageret, efter varerne er bogfõrt som modtaget.;
                           ENU=Specifies the time it takes to make items part of available inventory, after the items have been posted as received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Inbound Whse. Handling Time";
                OnValidate=BEGIN
                             InboundWhseHandlingTimeOnAfter;
                           END;
                            }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade];
                Editable=(Status = Status::Open) AND EnableTransferFields }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget reprësenterer med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type";
                Importance=Promoted }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification" }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportmÜden ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method";
                Importance=Promoted }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omrÜde med henblik pÜ rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det indfõrselssted, hvor varerne er kommet ind i landet/omrÜdet, eller for udfõrselsstedet.;
                           ENU=Specifies the code of either the port of entry at which the items passed into your country/region, or the port of exit.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry/Exit Point" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Vil du ëndre %1 i alle tilknyttede records pÜ lageret?;ENU=Do you want to change %1 in all related records in the warehouse?';
      DocNoVisible@1001 : Boolean;
      DisableEditDirectTransfer@1002 : Boolean;
      EnableTransferFields@1003 : Boolean;

    LOCAL PROCEDURE PostingDateOnAfterValidate@19003005();
    BEGIN
      CurrPage.TransferLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShipmentDateOnAfterValidate@19068710();
    BEGIN
      CurrPage.TransferLines.PAGE.UpdateForm(FALSE);
    END;

    LOCAL PROCEDURE ShippingAgentServiceCodeOnAfte@19046563();
    BEGIN
      CurrPage.TransferLines.PAGE.UpdateForm(FALSE);
    END;

    LOCAL PROCEDURE ShippingAgentCodeOnAfterValida@19008956();
    BEGIN
      CurrPage.TransferLines.PAGE.UpdateForm(FALSE);
    END;

    LOCAL PROCEDURE ShippingTimeOnAfterValidate@19029567();
    BEGIN
      CurrPage.TransferLines.PAGE.UpdateForm(FALSE);
    END;

    LOCAL PROCEDURE OutboundWhseHandlingTimeOnAfte@19078070();
    BEGIN
      CurrPage.TransferLines.PAGE.UpdateForm(FALSE);
    END;

    LOCAL PROCEDURE ReceiptDateOnAfterValidate@19074743();
    BEGIN
      CurrPage.TransferLines.PAGE.UpdateForm(FALSE);
    END;

    LOCAL PROCEDURE InboundWhseHandlingTimeOnAfter@19076948();
    BEGIN
      CurrPage.TransferLines.PAGE.UpdateForm(FALSE);
    END;

    LOCAL PROCEDURE SetDocNoVisible@2();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      DocNoVisible := DocumentNoVisibility.TransferOrderNoIsVisible;
    END;

    LOCAL PROCEDURE IsPartiallyShipped@1() : Boolean;
    VAR
      TransferLine@1000 : Record 5741;
    BEGIN
      TransferLine.SETRANGE("Document No.","No.");
      TransferLine.SETFILTER("Quantity Shipped",'> 0');
      EXIT(NOT TransferLine.ISEMPTY);
    END;

    BEGIN
    END.
  }
}

