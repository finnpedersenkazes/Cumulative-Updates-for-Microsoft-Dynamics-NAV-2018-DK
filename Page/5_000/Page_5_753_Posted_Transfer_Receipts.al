OBJECT Page 5753 Posted Transfer Receipts
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
    CaptionML=[DAN=Bogf. overflytn.kvitteringer;
               ENU=Posted Transfer Receipts];
    SourceTable=Table5746;
    PageType=List;
    CardPageID=Posted Transfer Receipt;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport�r,Modtagelse;
                                ENU=New,Process,Report,Receipt];
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Modtagelse;
                                 ENU=&Receipt];
                      Image=Receipt }
      { 21      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om overflytningsordren, f.eks. antal og samlet v�gt, der overf�res.;
                                 ENU=View statistical information about the transfer order, such as the quantity and total weight transferred.];
                      ApplicationArea=#Location;
                      RunObject=Page 5757;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5750;
                      RunPageLink=Document Type=CONST(Posted Transfer Receipt),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102601000;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
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
      { 19      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du f�r vist et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p� udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(TransRcptHeader);
                                 TransRcptHeader.PrintRecords(TRUE);
                               END;
                                }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf�ringsdatoen p� den valgte post eller det valgte bilag.;
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
                ToolTipML=[DAN=Angiver bogf�ringsdatoen for bilaget.;
                           ENU=Specifies the posting date for this document.];
                ApplicationArea=#Location;
                SourceExpr="Posting Date" }

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

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn�r varerne p� bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en �nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Location;
                SourceExpr="Shipment Date";
                Visible=FALSE }

    { 1102601003;2;Field  ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Location;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver koden for den spedit�r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Location;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN=Angiver modtagelsesdatoen for overflytningsordren.;
                           ENU=Specifies the receipt date of the transfer order.];
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
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      TransRcptHeader@1000 : Record 5746;

    BEGIN
    END.
  }
}

