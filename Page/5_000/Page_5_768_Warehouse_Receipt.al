OBJECT Page 5768 Warehouse Receipt
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagermodtagelse;
               ENU=Warehouse Receipt];
    SourceTable=Table7316;
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
                      CaptionML=[DAN=Modtagels&e;
                                 ENU=&Receipt];
                      Image=Receipt }
      { 101     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=FÜ vist alle eksisterende lagerdokumenter af denne type.;
                                 ENU=View all warehouse documents of this type that exist.];
                      ApplicationArea=#Advanced;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 LookupWhseRcptHeader(Rec);
                               END;
                                }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Whse. Receipt),
                                  Type=CONST(" "),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 6       ;2   ;Action    ;
                      CaptionML=[DAN=&Bogfõrte lagermodtagelser;
                                 ENU=Posted &Whse. Receipts];
                      ToolTipML=[DAN=FÜ vist det antal, der er bogfõrt som modtaget.;
                                 ENU=View the quantity that has been posted as received.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7333;
                      RunPageView=SORTING(Whse. Receipt No.);
                      RunPageLink=Whse. Receipt No.=FIELD(No.);
                      Promoted=Yes;
                      Image=PostedReceipts;
                      PromotedCategory=Process }
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
                                 ENU=Retrieve the released source document lines that define which items to receive or ship.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=UseFilters;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 GetSourceDocInbound@1001 : Codeunit 5751;
                               BEGIN
                                 GetSourceDocInbound.GetInboundDocs(Rec);
                                 "Document Status" := GetHeaderStatus(0);
                                 MODIFY;
                               END;
                                }
      { 23      ;2   ;Action    ;
                      ShortCutKey=Shift+F11;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent kildedokumenter;
                                 ENU=Get Source Documents];
                      ToolTipML=[DAN=èbn listen over frigivne kildedokumenter, f.eks. kõbsordrer, for at vëlge det bilag, der skal modtages varer for.;
                                 ENU="Open the list of released source documents, such as purchase orders, to select the document to receive items for. "];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 GetSourceDocInbound@1001 : Codeunit 5751;
                               BEGIN
                                 GetSourceDocInbound.GetSingleInboundDoc(Rec);
                                 "Document Status" := GetHeaderStatus(0);
                                 MODIFY;
                               END;
                                }
      { 24      ;2   ;Separator ;
                      CaptionML=[DAN="";
                                 ENU=""] }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Autofyld Modtag antal;
                                 ENU=Autofill Qty. to Receive];
                      ToolTipML=[DAN=FÜ systemet til at angive det udestÜende antal i feltet Modtag (antal).;
                                 ENU=Have the system enter the outstanding quantity in the Qty. to Receive field.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AutofillQtyToHandle;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 AutofillQtyToReceive;
                               END;
                                }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Slet Modtag antal;
                                 ENU=Delete Qty. to Receive];
                      ToolTipML=[DAN=FÜ systemet til at slette vërdien i feltet Modtag (antal).;
                                 ENU="Have the system clear the value in the Qty. To Receive field. "];
                      ApplicationArea=#Warehouse;
                      Image=DeleteQtyToHandle;
                      OnAction=BEGIN
                                 DeleteQtyToReceive;
                               END;
                                }
      { 40      ;2   ;Separator  }
      { 46      ;2   ;Action    ;
                      Name=CalculateCrossDock;
                      CaptionML=[DAN=Beregn direkte afsendelse;
                                 ENU=Calculate Cross-Dock];
                      ToolTipML=[DAN=èbn vinduet Mulighed for dir. afsend. for at fÜ vist detaljer om linjerne med bestilling pÜ varen, f.eks. dokumenttype, antal krëvede, og forfaldsdato. Disse oplysninger kan hjëlpe dig med at bestemme, hvor meget der skal afsendes direkte, hvor varerne skal anbringes i omrÜdet til direkte afsendelse, eller hvordan de skal grupperes.;
                                 ENU=Open the Cross-Dock Opportunities window to see details about the lines requesting the item, such as type of document, quantity requested, and due date. This information might help you to decide how much to cross-dock, where to place the items in the cross-dock area, or how to group them.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=CalculateCrossDock;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CrossDockOpp@1001 : Record 5768;
                                 CrossDockMgt@1000 : Codeunit 5780;
                               BEGIN
                                 CrossDockMgt.CalculateCrossDockLines(CrossDockOpp,'',"No.","Location Code");
                               END;
                                }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      Image=Post }
      { 25      ;2   ;Action    ;
                      Name=Post Receipt;
                      ShortCutKey=F9;
                      CaptionML=[DAN=B&ogfõr leverance;
                                 ENU=P&ost Receipt];
                      ToolTipML=[DAN=Bogfõr varerne som modtaget. Der oprettes automatisk et lëg-pÜ-lager-bilag.;
                                 ENU=Post the items as received. A put-away document is created automatically.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 WhsePostRcptYesNo;
                               END;
                                }
      { 47      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
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
                                 WhsePostRcptPrintPostedRcpt;
                               END;
                                }
      { 26      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+F9;
                      CaptionML=[DAN=Bogfõr og &udskriv lëg-pÜ-lager;
                                 ENU=Post and Print P&ut-away];
                      ToolTipML=[DAN=Bogfõr varerne som modtaget, og udskriv lëg-pÜ-lager-bilaget.;
                                 ENU=Post the items as received and print the put-away document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 WhsePostRcptPrint;
                               END;
                                }
      { 21      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Gõr dig klar til at udskrive bilaget. Der Übnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages pÜ udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 WhseDocPrint.PrintRcptHeader(Rec);
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
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne modtages.;
                           ENU=Specifies the code of the location in which the items are being received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           LookupLocation(Rec);
                           CurrPage.UPDATE(TRUE);
                         END;
                          }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den zone, hvor varerne modtages, hvis du bruger styret lëg-pÜ-lager og pluk.;
                           ENU=Specifies the zone in which the items are being received if you are using directed put-away and pick.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller lëgges pÜ lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for lagermodtagelsen.;
                           ENU=Specifies the status of the warehouse receipt.];
                ApplicationArea=#Warehouse;
                SourceExpr="Document Status" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogfõringsdatoen for lagermodtagelsen.;
                           ENU=Specifies the posting date of the warehouse receipt.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posting Date" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens leverancenummer. Det indsëttes i det tilsvarende felt pÜ kildedokumentet ved bogfõringen.;
                           ENU=Specifies the vendor's shipment number. It is inserted in the corresponding field on the source document during posting.];
                ApplicationArea=#Warehouse;
                SourceExpr="Vendor Shipment No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID" }

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
                ToolTipML=[DAN=Angiver, hvilken metode modtagelserne sorteres med.;
                           ENU=Specifies the method by which the receipts are sorted.];
                OptionCaptionML=[DAN=" ,Vare,Bilag,Placering,Forfaldsdato ";
                                 ENU=" ,Item,Document,Shelf or Bin,Due Date "];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method";
                OnValidate=BEGIN
                             SortingMethodOnAfterValidate;
                           END;
                            }

    { 97  ;1   ;Part      ;
                Name=WhseReceiptLines;
                ApplicationArea=#Warehouse;
                SubPageView=SORTING(No.,Sorting Sequence No.);
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page5769;
                PartType=Page }

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

    LOCAL PROCEDURE AutofillQtyToReceive@1();
    BEGIN
      CurrPage.WhseReceiptLines.PAGE.AutofillQtyToReceive;
    END;

    LOCAL PROCEDURE DeleteQtyToReceive@3();
    BEGIN
      CurrPage.WhseReceiptLines.PAGE.DeleteQtyToReceive;
    END;

    LOCAL PROCEDURE WhsePostRcptYesNo@4();
    BEGIN
      CurrPage.WhseReceiptLines.PAGE.WhsePostRcptYesNo;
    END;

    LOCAL PROCEDURE WhsePostRcptPrint@5();
    BEGIN
      CurrPage.WhseReceiptLines.PAGE.WhsePostRcptPrint;
    END;

    LOCAL PROCEDURE WhsePostRcptPrintPostedRcpt@2();
    BEGIN
      CurrPage.WhseReceiptLines.PAGE.WhsePostRcptPrintPostedRcpt;
    END;

    LOCAL PROCEDURE SortingMethodOnAfterValidate@19063061();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

