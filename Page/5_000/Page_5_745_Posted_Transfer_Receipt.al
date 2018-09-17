OBJECT Page 5745 Posted Transfer Receipt
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogf. overflytningskvittering;
               ENU=Posted Transfer Receipt];
    InsertAllowed=No;
    SourceTable=Table5746;
    PageType=Document;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Modtagelse;
                                ENU=New,Process,Report,Receipt];
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 50      ;1   ;ActionGroup;
                      CaptionML=[DAN=Modtagels&e;
                                 ENU=&Receipt];
                      Image=Receipt }
      { 56      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om overflytningsordren, f.eks. antal og samlet v‘gt, der overf›res.;
                                 ENU=View statistical information about the transfer order, such as the quantity and total weight transferred.];
                      ApplicationArea=#Location;
                      RunObject=Page 5757;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 57      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5750;
                      RunPageLink=Document Type=CONST(Posted Transfer Receipt),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 58      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 51      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 TransRcptHeader@1001 : Record 5746;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(TransRcptHeader);
                                 TransRcptHeader.PrintRecords(TRUE);
                               END;
                                }
      { 52      ;1   ;Action    ;
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
                ApplicationArea=#Location;
                SourceExpr="No.";
                Importance=Promoted;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the code of the location that items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Code";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes til.;
                           ENU=Specifies the code of the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Code";
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at overf›rslen ikke anvender en transitlokation.;
                           ENU=Specifies that the transfer does not use an in-transit location.];
                ApplicationArea=#Location;
                SourceExpr="Direct Transfer";
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transitkoden for overflytningsordren, f.eks. en spedit›r.;
                           ENU=Specifies the in-transit code for the transfer order, such as a shipping agent.];
                ApplicationArea=#Location;
                SourceExpr="In-Transit Code";
                Editable=FALSE }

    { 53  ;2   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede overflytningsordre.;
                           ENU=Specifies the number of the related transfer order.];
                ApplicationArea=#Location;
                SourceExpr="Transfer Order No.";
                Importance=Promoted;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor overflytningsordren blev oprettet.;
                           ENU=Specifies the date when the transfer order was created.];
                ApplicationArea=#Location;
                SourceExpr="Transfer Order Date";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for bilaget.;
                           ENU=Specifies the posting date for this document.];
                ApplicationArea=#Location;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Location;
                SourceExpr="Shortcut Dimension 1 Code";
                Importance=Additional;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Location;
                SourceExpr="Shortcut Dimension 2 Code";
                Importance=Additional;
                Editable=FALSE }

    { 49  ;1   ;Part      ;
                Name=TransferReceiptLines;
                ApplicationArea=#Location;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page5746;
                PartType=Page }

    { 5   ;1   ;Group     ;
                CaptionML=[DAN=Leverance;
                           ENU=Shipment];
                GroupType=Group }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Location;
                SourceExpr="Shipment Date";
                Editable=FALSE }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Location;
                SourceExpr="Shipment Method Code";
                Editable=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Agent Code";
                Editable=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Agent Service Code";
                Importance=Promoted;
                Editable=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver modtagelsesdatoen for overflytningsordren.;
                           ENU=Specifies the receipt date of the transfer order.];
                ApplicationArea=#Location;
                SourceExpr="Receipt Date";
                Importance=Promoted;
                Editable=FALSE }

    { 1904655901;1;Group  ;
                CaptionML=[DAN=Overflyt fra;
                           ENU=Transfer-from] }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† afsenderen p† den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the name of the sender at the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Name";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af navnet p† afsenderen p† den lokation, som varerne overflyttes fra.;
                           ENU=Specifies an additional part of the name of the sender at the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Name 2";
                Importance=Additional;
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the address of the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Address";
                Importance=Additional;
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af adressen p† den lokation, som varerne overflyttes fra.;
                           ENU=Specifies an additional part of the address of the location that items are transferred from..];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Address 2";
                Importance=Additional;
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the postal code of the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Post Code";
                Importance=Additional;
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the city of the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from City";
                Importance=Additional;
                Editable=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the name of the contact person at the location that the items are transferred from.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-from Contact";
                Importance=Additional;
                Editable=FALSE }

    { 1901454601;1;Group  ;
                CaptionML=[DAN=Overflyt til;
                           ENU=Transfer-to] }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† modtageren p† den lokation, som varerne overflyttes til.;
                           ENU=Specifies the name of the recipient at the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Name";
                Editable=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af navnet p† modtageren p† den lokation, som varerne overflyttes til.;
                           ENU=Specifies an additional part of the name of the recipient at the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Name 2";
                Importance=Additional;
                Editable=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen p† den lokation, som varerne overflyttes til.;
                           ENU=Specifies the address of the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Address";
                Importance=Additional;
                Editable=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af adressen p† den lokation, som varerne overflyttes til.;
                           ENU=Specifies an additional part of the address of the location that items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Address 2";
                Importance=Additional;
                Editable=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for den lokation, som varerne overflyttes til.;
                           ENU=Specifies the postal code of the location that the items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Post Code";
                Importance=Additional;
                Editable=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den lokation, som varer overflyttes til.;
                           ENU=Specifies the city of the location that items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to City";
                Importance=Additional;
                Editable=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kontaktpersonen p† den lokation, som varer overflyttes til.;
                           ENU=Specifies the name of the contact person at the location that items are transferred to.];
                ApplicationArea=#Location;
                SourceExpr="Transfer-to Contact";
                Importance=Additional;
                Editable=FALSE }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som bilaget repr‘senterer med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Type";
                Importance=Promoted;
                Editable=FALSE }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en specifikation af bilagets transaktion med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies a specification of the document's transaction, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transaction Specification";
                Editable=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transportm†den ved rapportering til INTRASTAT.;
                           ENU=Specifies the transport method, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Transport Method";
                Importance=Promoted;
                Editable=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omr†de med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area;
                Editable=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det indf›rselssted, hvor varerne er kommet ind i landet/omr†det, eller for udf›rselsstedet.;
                           ENU=Specifies the code of either the port of entry at which the items passed into your country/region, or the port of exit.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry/Exit Point";
                Editable=FALSE }

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

    BEGIN
    END.
  }
}

