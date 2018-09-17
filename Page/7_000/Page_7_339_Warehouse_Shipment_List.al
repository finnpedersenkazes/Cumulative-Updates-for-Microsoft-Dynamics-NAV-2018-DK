OBJECT Page 7339 Warehouse Shipment List
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
    CaptionML=[DAN=Lagerleveranceoversigt;
               ENU=Warehouse Shipment List];
    SourceTable=Table7320;
    DataCaptionFields=No.;
    PageType=List;
    CardPageID=Warehouse Shipment;
    OnOpenPage=BEGIN
                 ErrorIfUserIsNotWhseEmployee;
               END;

    OnFindRecord=BEGIN
                   EXIT(FindFirstAllowedRec(Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(FindNextAllowedRec(Steps));
                 END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=&Leverance;
                                 ENU=&Shipment];
                      Image=Shipment }
      { 1102601002;2 ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Whse. Shipment),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102601003;2 ;Action    ;
                      CaptionML=[DAN=Pluklinjer;
                                 ENU=Pick Lines];
                      ToolTipML=[DAN=Vis de relaterede pluk.;
                                 ENU=View the related picks.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5785;
                      RunPageView=SORTING(Whse. Document No.,Whse. Document Type,Activity Type)
                                  WHERE(Activity Type=CONST(Pick));
                      RunPageLink=Whse. Document Type=CONST(Shipment),
                                  Whse. Document No.=FIELD(No.);
                      Image=PickLines }
      { 1102601004;2 ;Action    ;
                      CaptionML=[DAN=&Registrerede pluklinjer;
                                 ENU=Registered P&ick Lines];
                      ToolTipML=[DAN=Vis oversigten over lagerpluk, der er foretaget for ordren.;
                                 ENU=View the list of warehouse picks that have been made for the order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7364;
                      RunPageView=SORTING(Whse. Document Type,Whse. Document No.,Whse. Document Line No.)
                                  WHERE(Whse. Document Type=CONST(Shipment));
                      RunPageLink=Whse. Document No.=FIELD(No.);
                      Image=RegisteredDocs }
      { 1102601005;2 ;Action    ;
                      CaptionML=[DAN=&Bogf. lagerleverancer;
                                 ENU=Posted &Whse. Shipments];
                      ToolTipML=[DAN=FÜ vist det antal, der er bogfõrt som leveret.;
                                 ENU=View the quantity that has been posted as shipped.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7340;
                      RunPageView=SORTING(Whse. Shipment No.);
                      RunPageLink=Whse. Shipment No.=FIELD(No.);
                      Image=PostedReceipt }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 18      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den pÜgëldende record pÜ bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Warehouse;
                      Image=EditLines;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"Warehouse Shipment",Rec);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102601009;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1102601013;2 ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Warehouse;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleaseWhseShptDoc@1000 : Codeunit 7310;
                               BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 IF Status = Status::Open THEN
                                   ReleaseWhseShptDoc.Release(Rec);
                               END;
                                }
      { 1102601014;2 ;Action    ;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen ved ekstra lageraktivitet.;
                                 ENU=Reopen the document for additional warehouse activity.];
                      ApplicationArea=#Warehouse;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleaseWhseShptDoc@1000 : Codeunit 7310;
                               BEGIN
                                 ReleaseWhseShptDoc.Reopen(Rec);
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
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne leveres fra.;
                           ENU=Specifies the code of the location from which the items are being shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken metode leverancerne sorteres med.;
                           ENU=Specifies the method by which the shipments are sorted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver statussen for leverancen, som udfyldes af programmet.;
                           ENU=Specifies the status of the shipment and is filled in by the program.];
                ApplicationArea=#Warehouse;
                SourceExpr=Status }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver koden for zonen pÜ leverancehovedet.;
                           ENU=Specifies the code of the zone on this shipment header.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller lëgges pÜ lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 1102601010;2;Field  ;
                ToolTipML=[DAN=Angiver statusniveauet for lagerekspeditionen pÜ linjerne i lagerleverancen.;
                           ENU=Specifies the progress level of warehouse handling on lines in the warehouse shipment.];
                ApplicationArea=#Warehouse;
                SourceExpr="Document Status";
                Visible=FALSE }

    { 1102601012;2;Field  ;
                ToolTipML=[DAN=Angiver en bogfõringsdato. Hvis du indtaster en dato, opdateres bogfõringsdatoen for kildedokumenterne ved bogfõringen.;
                           ENU=Specifies a posting date. If you enter a date, the posting date of the source documents is updated during posting.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 1102601016;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the date when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Date";
                Visible=FALSE }

    { 1102601018;2;Field  ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipment Date";
                Visible=FALSE }

    { 1102601020;2;Field  ;
                ToolTipML=[DAN=Angiver koden for den speditõr, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 1102601022;2;Field  ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af speditõren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Agent Service Code";
                Visible=FALSE }

    { 1102601024;2;Field  ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipment Method Code";
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

    BEGIN
    END.
  }
}

