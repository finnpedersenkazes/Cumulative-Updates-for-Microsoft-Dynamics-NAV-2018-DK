OBJECT Page 7335 Warehouse Shipment
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagerleverance;
               ENU=Warehouse Shipment];
    SourceTable=Table7320;
    PopulateAllFields=Yes;
    PageType=Document;
    RefreshOnActivate=Yes;
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
      { 100     ;1   ;ActionGroup;
                      CaptionML=[DAN=L&everance;
                                 ENU=&Shipment];
                      Image=Shipment }
      { 101     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=FÜ vist alle eksisterende lagerdokumenter af denne type.;
                                 ENU=View all warehouse documents of this type that exist.];
                      ApplicationArea=#Advanced;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 LookupWhseShptHeader(Rec);
                               END;
                                }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Whse. Shipment),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 52      ;2   ;Action    ;
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
      { 54      ;2   ;Action    ;
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
      { 53      ;2   ;Action    ;
                      CaptionML=[DAN=&Bogf. lagerleverancer;
                                 ENU=Posted &Whse. Shipments];
                      ToolTipML=[DAN=FÜ vist det antal, der er bogfõrt som leveret.;
                                 ENU=View the quantity that has been posted as shipped.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7340;
                      RunPageView=SORTING(Whse. Shipment No.);
                      RunPageLink=Whse. Shipment No.=FIELD(No.);
                      Image=PostedReceipt }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 34      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Brug filtre til at hente kildedok.;
                                 ENU=Use Filters to Get Src. Docs.];
                      ToolTipML=[DAN=Hent de frigivne kildedokumentlinjer, som definerer, hvilke varer der skal modtages eller leveres.;
                                 ENU=retrieve the released source document lines that define which items to receive or ship.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=UseFilters;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 GetSourceDocOutbound@1001 : Codeunit 5752;
                               BEGIN
                                 TESTFIELD(Status,Status::Open);
                                 GetSourceDocOutbound.GetOutboundDocs(Rec);
                               END;
                                }
      { 23      ;2   ;Action    ;
                      ShortCutKey=Shift+F11;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent kildedokumenter;
                                 ENU=Get Source Documents];
                      ToolTipML=[DAN=èbn listen over frigivne kildedokumenter, f.eks. salgsordrer, for at vëlge det bilag, der skal leveres varer for.;
                                 ENU="Open the list of released source documents, such as sales orders, to select the document to ship items for. "];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 GetSourceDocOutbound@1001 : Codeunit 5752;
                               BEGIN
                                 TESTFIELD(Status,Status::Open);
                                 GetSourceDocOutbound.GetSingleOutboundDoc(Rec);
                               END;
                                }
      { 44      ;2   ;Separator  }
      { 45      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=ReleaseDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ReleaseWhseShptDoc@1000 : Codeunit 7310;
                               BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 IF Status = Status::Open THEN
                                   ReleaseWhseShptDoc.Release(Rec);
                               END;
                                }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen ved ekstra lageraktivitet.;
                                 ENU=Reopen the document for additional warehouse activity.];
                      ApplicationArea=#Advanced;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleaseWhseShptDoc@1000 : Codeunit 7310;
                               BEGIN
                                 ReleaseWhseShptDoc.Reopen(Rec);
                               END;
                                }
      { 17      ;2   ;Separator  }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Autofyld Lever (antal);
                                 ENU=Autofill Qty. to Ship];
                      ToolTipML=[DAN=FÜ systemet til at angive det udestÜende antal i feltet Lever (antal).;
                                 ENU=Have the system enter the outstanding quantity in the Qty. to Ship field.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AutofillQtyToHandle;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 AutofillQtyToHandle;
                               END;
                                }
      { 49      ;2   ;Action    ;
                      CaptionML=[DAN=Annuller Lever (antal);
                                 ENU=Delete Qty. to Ship];
                      ToolTipML=[DAN=FÜ systemet til at slette vërdien i feltet Lever (antal).;
                                 ENU="Have the system clear the value in the Qty. To Ship field. "];
                      ApplicationArea=#Advanced;
                      Image=DeleteQtyToHandle;
                      OnAction=BEGIN
                                 DeleteQtyToHandle;
                               END;
                                }
      { 51      ;2   ;Separator  }
      { 24      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret pluk;
                                 ENU=Create Pick];
                      ToolTipML=[DAN=Opret et lagerpluk for de varer, der skal leveres.;
                                 ENU=Create a warehouse pick for the items to be shipped.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=CreateInventoryPickup;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 CurrPage.WhseShptLines.PAGE.PickCreate;
                               END;
                                }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      Image=Post }
      { 25      ;2   ;Action    ;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogfõr lev.;
                                 ENU=P&ost Shipment];
                      ToolTipML=[DAN=Bogfõr varerne som leveret. Relaterede pluk-dokumenter registreres automatisk.;
                                 ENU=Post the items as shipped. Related pick documents are registered automatically.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PostShipmentYesNo;
                               END;
                                }
      { 26      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogfõr og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden fërdiggõres og forberedes til udskrivning. Vërdierne og antallene bogfõres pÜ de relaterede konti. Du fÜr vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PostShipmentPrintYesNo;
                               END;
                                }
      { 57      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Gõr dig klar til at udskrive bilaget. Der Übnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages pÜ udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 WhseDocPrint.PrintShptHeader(Rec);
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
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No.";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne leveres fra.;
                           ENU=Specifies the code of the location from which the items are being shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           LookupLocation(Rec);
                           CurrPage.UPDATE(TRUE);
                         END;
                          }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for zonen pÜ leverancehovedet.;
                           ENU=Specifies the code of the zone on this shipment header.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller lëgges pÜ lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver statusniveauet for lagerekspeditionen pÜ linjerne i lagerleverancen.;
                           ENU=Specifies the progress level of warehouse handling on lines in the warehouse shipment.];
                ApplicationArea=#Warehouse;
                SourceExpr="Document Status";
                Importance=Promoted }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver statussen for leverancen, som udfyldes af programmet.;
                           ENU=Specifies the status of the shipment and is filled in by the program.];
                ApplicationArea=#Warehouse;
                SourceExpr=Status }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en bogfõringsdato. Hvis du indtaster en dato, opdateres bogfõringsdatoen for kildedokumenterne ved bogfõringen.;
                           ENU=Specifies a posting date. If you enter a date, the posting date of the source documents is updated during posting.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posting Date" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID";
                Importance=Promoted }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the date when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Date";
                Editable=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkeslët, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the time when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Time";
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken metode leverancerne sorteres med.;
                           ENU=Specifies the method by which the shipments are sorted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method";
                OnValidate=BEGIN
                             SortingMethodOnAfterValidate;
                           END;
                            }

    { 97  ;1   ;Part      ;
                Name=WhseShptLines;
                ApplicationArea=#Warehouse;
                SubPageView=SORTING(No.,Sorting Sequence No.);
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page7336;
                PartType=Page }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No.";
                Importance=Promoted }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipment Date";
                Importance=Promoted }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den speditõr, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Agent Code" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af speditõren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Agent Service Code";
                Importance=Promoted }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipment Method Code" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1901796907;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Item No.);
                PagePartID=Page9109;
                ProviderID=97;
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
      WhseDocPrint@1000 : Codeunit 5776;

    LOCAL PROCEDURE AutofillQtyToHandle@1();
    BEGIN
      CurrPage.WhseShptLines.PAGE.AutofillQtyToHandle;
    END;

    LOCAL PROCEDURE DeleteQtyToHandle@2();
    BEGIN
      CurrPage.WhseShptLines.PAGE.DeleteQtyToHandle;
    END;

    LOCAL PROCEDURE PostShipmentYesNo@3();
    BEGIN
      CurrPage.WhseShptLines.PAGE.PostShipmentYesNo;
    END;

    LOCAL PROCEDURE PostShipmentPrintYesNo@4();
    BEGIN
      CurrPage.WhseShptLines.PAGE.PostShipmentPrintYesNo;
    END;

    LOCAL PROCEDURE SortingMethodOnAfterValidate@19063061();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

