OBJECT Page 5742 Transfer Orders
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
    CaptionML=[DAN=Overflytningsordrer;
               ENU=Transfer Orders];
    SourceTable=Table5740;
    PageType=List;
    CardPageID=Transfer Order;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport�r,Frigiv,Bogf�ring,Ordre,Bilag;
                                ENU=New,Process,Report,Release,Posting,Order,Documents];
    OnInit=VAR
             ApplicationAreaSetup@1000 : Record 9178;
           BEGIN
             IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
           END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=O&rdre;
                                 ENU=O&rder];
                      Image=Order }
      { 1102601002;2 ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om overflytningsordren, f.eks. antal og samlet v�gt, der overf�res.;
                                 ENU=View statistical information about the transfer order, such as the quantity and total weight transferred.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5755;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes }
      { 1102601003;2 ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5750;
                      RunPageLink=Document Type=CONST(Transfer Order),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102601006;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 1102601004;2 ;Action    ;
                      CaptionML=[DAN=Le&verancer;
                                 ENU=S&hipments];
                      ToolTipML=[DAN=F� vist relaterede bogf�rte overflytningsleverancer.;
                                 ENU=View related posted transfer shipments.];
                      ApplicationArea=#Location;
                      RunObject=Page 5752;
                      RunPageLink=Transfer Order No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Shipment;
                      PromotedCategory=Category7;
                      PromotedOnly=Yes }
      { 1102601005;2 ;Action    ;
                      CaptionML=[DAN=Modtage&lser;
                                 ENU=Re&ceipts];
                      ToolTipML=[DAN=F� vist relaterede bogf�rte overflytningskvitteringer.;
                                 ENU=View related posted transfer receipts.];
                      ApplicationArea=#Location;
                      RunObject=Page 5753;
                      RunPageLink=Transfer Order No.=FIELD(No.);
                      Promoted=Yes;
                      Image=PostedReceipts;
                      PromotedCategory=Category7;
                      PromotedOnly=Yes }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Warehouse }
      { 1102601007;2 ;Action    ;
                      CaptionML=[DAN=Lag&erleverancer;
                                 ENU=Whse. Shi&pments];
                      ToolTipML=[DAN=F� vist udg�ende varer, der er afsendt med lageraktiviteter for overflytningsordren.;
                                 ENU=View outbound items that have been shipped with warehouse activities for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7341;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(5741),
                                  Source Subtype=CONST(0),
                                  Source No.=FIELD(No.);
                      Image=Shipment }
      { 1102601008;2 ;Action    ;
                      CaptionML=[DAN=L&agermodtagelser;
                                 ENU=&Whse. Receipts];
                      ToolTipML=[DAN=F� vist indg�ende varer, der er modtaget med lageraktiviteter for overflytningsordren.;
                                 ENU=View inbound items that have been received with warehouse activities for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7342;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(5741),
                                  Source Subtype=CONST(1),
                                  Source No.=FIELD(No.);
                      Image=Receipt }
      { 1102601009;2 ;Action    ;
                      CaptionML=[DAN=L&�g-p�-lager/pluklinjer (lag.);
                                 ENU=In&vt. Put-away/Pick Lines];
                      ToolTipML=[DAN=F� vist ind- eller udg�ende varer p� l�g-p�-lager- eller lagerplukningsbilag for overflytningsordren.;
                                 ENU=View items that are inbound or outbound on inventory put-away or inventory pick documents for the transfer order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5774;
                      RunPageView=SORTING(Source Document,Source No.,Location Code);
                      RunPageLink=Source Document=FILTER(Inbound Transfer|Outbound Transfer),
                                  Source No.=FIELD(No.);
                      Image=PickLines }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Overflytningsruter;
                                 ENU=Transfer Routes];
                      ToolTipML=[DAN=F� vist en liste med overflytningsruter, der er konfigureret til overflytning af varer fra en lokation til en anden.;
                                 ENU=View the list of transfer routes that are set up to transfer items from one location to another.];
                      ApplicationArea=#Location;
                      RunObject=Page 5747;
                      Promoted=Yes;
                      Image=Setup;
                      PromotedCategory=Category6;
                      PromotedOnly=Yes }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 150     ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du f�r vist et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p� udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
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
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Frigiv;
                                 ENU=Release];
                      Image=ReleaseDoc }
      { 15      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til n�ste behandlingstrin. N�r et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal gen�bne bilaget, f�r du kan foretage �ndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Advanced;
                      RunObject=Codeunit 5708;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 1102601017;2 ;Action    ;
                      CaptionML=[DAN=&�bn igen;
                                 ENU=Reo&pen];
                      ToolTipML=[DAN=�bn overflytningsordren igen efter frigivelse til lagerekspedition.;
                                 ENU=Reopen the transfer order after being released for warehouse handling.];
                      ApplicationArea=#Advanced;
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
      { 1102601010;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1102601013;2 ;Action    ;
                      AccessByPermission=TableData 7320=R;
                      CaptionML=[DAN=Opre&t lagerleverance;
                                 ENU=Create Whse. S&hipment];
                      ToolTipML=[DAN=Opret en lagerleverance for at starte et pluk eller en leveringsproces i henhold til en avanceret lagerops�tning.;
                                 ENU=Create a warehouse shipment to start a pick a ship process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewShipment;
                      OnAction=VAR
                                 GetSourceDocOutbound@1001 : Codeunit 5752;
                               BEGIN
                                 GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
                               END;
                                }
      { 1102601012;2 ;Action    ;
                      AccessByPermission=TableData 7316=R;
                      CaptionML=[DAN=Opr&et lagermodtagelse;
                                 ENU=Create &Whse. Receipt];
                      ToolTipML=[DAN=Opret en lagermodtagelse for at starte en l�g-p�-lager-proces i henhold til en avanceret lagerops�tning.;
                                 ENU=Create a warehouse receipt to start a receive and put-away process according to an advanced warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=NewReceipt;
                      OnAction=VAR
                                 GetSourceDocInbound@1001 : Codeunit 5751;
                               BEGIN
                                 GetSourceDocInbound.CreateFromInbndTransferOrder(Rec);
                               END;
                                }
      { 1102601014;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret l&�g-p�-lager (lager)/pluk (lager);
                                 ENU=Create Inventor&y Put-away/Pick];
                      ToolTipML=[DAN=Opret en l�g-p�-lager-aktivitet eller et lagerpluk til h�ndtering af varer p� bilaget i overensstemmelse med en grundl�ggende lagerops�tning, der ikke kr�ver lagermodtagelse eller leverancedokumenter.;
                                 ENU=Create an inventory put-away or inventory pick to handle items on the document according to a basic warehouse configuration that does not require warehouse receipt or shipment documents.];
                      ApplicationArea=#Warehouse;
                      Image=CreatePutawayPick;
                      OnAction=BEGIN
                                 CreateInvtPutAwayPick;
                               END;
                                }
      { 1102601015;2 ;Action    ;
                      AccessByPermission=TableData 7302=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent placeringsindh.;
                                 ENU=Get Bin Content];
                      ToolTipML=[DAN=Brug en funktion til oprettelse af overflytningslinjer med varer, der skal l�gges p� lager eller plukkes, baseret p� det faktiske indhold p� den angivne placering.;
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
      { 1102601018;1 ;ActionGroup;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&osting];
                      Image=Post }
      { 1102601019;2 ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=B&ogf�r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden ved at bogf�re bel�b og antal p� de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post (Yes/No)",Rec);
                               END;
                                }
      { 1102601020;2 ;Action    ;
                      Name=PostAndPrint;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf�r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f�rdigg�res og forberedes til udskrivning. V�rdierne og antallene bogf�res p� de relaterede konti. Du f�r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"TransferOrder-Post + Print",Rec);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1901320106;1 ;Action    ;
                      CaptionML=[DAN=Lager - indg�ende overflytning;
                                 ENU=Inventory - Inbound Transfer];
                      ToolTipML=[DAN=F� vist, hvilke varer der i �jeblikket findes p� indg�ende overflytningsordrer.;
                                 ENU=View which items are currently on inbound transfer orders.];
                      ApplicationArea=#Location;
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Location;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the code of the location that items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes til.;
                           ENU=Specifies the code of the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transitkoden for overflytningsordren, f.eks. en spedit�r.;
                           ENU=Specifies the in-transit code for the transfer order, such as a shipping agent.];
                ApplicationArea=#Location;
                SourceExpr="In-Transit Code" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om overflytningsordren er �ben eller frigivet til n�ste trin i behandlingen.;
                           ENU=Specifies whether the transfer order is open or has been released for warehouse handling.];
                ApplicationArea=#Location;
                SourceExpr=Status }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at overf�rslen ikke anvender en transitlokation.;
                           ENU=Specifies that the transfer does not use an in-transit location.];
                ApplicationArea=#Location;
                SourceExpr="Direct Transfer" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Location;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Location;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Location;
                SourceExpr="Assigned User ID";
                Visible=NOT IsFoundationEnabled }

    { 1102601021;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn�r varerne p� bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en �nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Location;
                SourceExpr="Shipment Date";
                Visible=FALSE }

    { 1102601023;2;Field  ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Location;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 1102601025;2;Field  ;
                ToolTipML=[DAN=Angiver koden for den spedit�r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 1102601027;2;Field  ;
                ToolTipML=[DAN=Angiver en instruktion til det lager, der afsender varerne, f.eks. at det er tilladt at foretage delleveringer.;
                           ENU=Specifies an instruction to the warehouse that ships the items, for example, that it is acceptable to do partial shipment.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Advice";
                Visible=FALSE }

    { 1102601029;2;Field  ;
                ToolTipML=[DAN=Angiver den forventede dato for modtagelsen af leverancen til den lokation, der overflyttes til.;
                           ENU=Specifies the date that you expect the transfer-to location to receive the shipment.];
                ApplicationArea=#Location;
                SourceExpr="Receipt Date";
                Visible=FALSE }

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
      IsFoundationEnabled@1000 : Boolean;

    BEGIN
    END.
  }
}

