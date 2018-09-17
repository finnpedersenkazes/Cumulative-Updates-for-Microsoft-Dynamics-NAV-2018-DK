OBJECT Page 7377 Inventory Pick
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Pluk (lager);
               ENU=Inventory Pick];
    SaveValues=Yes;
    SourceTable=Table5766;
    SourceTableView=WHERE(Type=CONST(Invt. Pick));
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

    OnNewRecord=BEGIN
                  "Location Code" := GetUserLocation;
                END;

    OnDeleteRecord=BEGIN
                     CurrPage.UPDATE;
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 100     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Pluk;
                                 ENU=P&ick];
                      Image=CreateInventoryPickup }
      { 101     ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=F† vist alle eksisterende lagerdokumenter af denne type.;
                                 ENU=View all warehouse documents of this type that exist.];
                      ApplicationArea=#Warehouse;
                      Image=OpportunitiesList;
                      OnAction=BEGIN
                                 LookupActivityHeader("Location Code",Rec);
                               END;
                                }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Whse. Activity Header),
                                  Type=FIELD(Type),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=Bogf›rte pluk;
                                 ENU=Posted Picks];
                      ToolTipML=[DAN=Vis de m‘ngder, der allerede er blevet plukket.;
                                 ENU=View any quantities that have already been picked.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7395;
                      RunPageView=SORTING(Invt Pick No.);
                      RunPageLink=Invt Pick No.=FIELD(No.);
                      Image=PostedInventoryPick }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Kildedokument;
                                 ENU=Source Document];
                      ToolTipML=[DAN=Vis kildedokumentet for lageraktiviteten.;
                                 ENU=View the source document of the warehouse activity.];
                      ApplicationArea=#Warehouse;
                      Image=Order;
                      OnAction=VAR
                                 WMSMgt@1000 : Codeunit 7302;
                               BEGIN
                                 WMSMgt.ShowSourceDocCard("Source Type","Source Subtype","Source No.");
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 13      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent kildedokument;
                                 ENU=&Get Source Document];
                      ToolTipML=[DAN=V‘lg det kildedokument, som du vil plukke varer efter.;
                                 ENU=Select the source document that you want to pick items for.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Create Inventory Pick/Movement",Rec);
                               END;
                                }
      { 38      ;2   ;Action    ;
                      Name=AutofillQtyToHandle;
                      CaptionML=[DAN=Autofyld h†ndteringsantal;
                                 ENU=Autofill Qty. to Handle];
                      ToolTipML=[DAN=F† systemet til at angive det udest†ende antal i feltet H†ndteringsantal.;
                                 ENU=Have the system enter the outstanding quantity in the Qty. to Handle field.];
                      ApplicationArea=#Warehouse;
                      Image=AutofillQtyToHandle;
                      OnAction=BEGIN
                                 AutofillQtyToHandle;
                               END;
                                }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Slet h†ndteringsantal;
                                 ENU=Delete Qty. to Handle];
                      ToolTipML=[DAN="F† systemet til at slette v‘rdien i feltet H†ndteringsantal. ";
                                 ENU="Have the system clear the value in the Qty. To Handle field. "];
                      ApplicationArea=#Warehouse;
                      Image=DeleteQtyToHandle;
                      OnAction=BEGIN
                                 DeleteQtyToHandle;
                               END;
                                }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 28      ;2   ;Action    ;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PostPickYesNo;
                               END;
                                }
      { 41      ;2   ;Action    ;
                      Name=PostAndPrint;
                      ShortCutKey=Shift+F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Bilaget eller kladden f‘rdigg›res og forberedes til udskrivning. V‘rdierne og antallene bogf›res p† de relaterede konti. Du f†r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PostAndPrint;
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 WhseActPrint.PrintInvtPickHeader(Rec,FALSE);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1905733806;1 ;Action    ;
                      CaptionML=[DAN=Plukliste;
                                 ENU=Picking List];
                      ToolTipML=[DAN=F† vist eller udskriv en detaljeret liste over varer, som skal plukkes.;
                                 ENU=View or print a detailed list of items that must be picked.];
                      ApplicationArea=#Warehouse;
                      RunObject=Report 5752;
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
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor lageraktiviteten finder sted.;
                           ENU=Specifies the code for the location where the warehouse activity takes place.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 15  ;2   ;Field     ;
                Lookup=No;
                DrillDown=No;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No.";
                OnValidate=BEGIN
                             SourceNoOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           CODEUNIT.RUN(CODEUNIT::"Create Inventory Pick/Movement",Rec);
                           CurrPage.UPDATE;
                           CurrPage.WhseActivityLines.PAGE.UpdateForm;
                         END;
                          }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer eller den kode for debitoren eller kreditoren, som linjen er tilknyttet.;
                           ENU=Specifies the number or the code of the customer or vendor that the line is linked to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",0));
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† de pluk fra lageret, der bruges til disse udg†ende kildedokumenter: salgsordrer, k›bsreturvareordrer og udg†ende overflytningsordrer.;
                           ENU=Specifies the name of the inventory picks used for these outbound source documents: sales orders, purchase return orders, and outbound transfer orders.];
                ApplicationArea=#Warehouse;
                SourceExpr=WMSMgt.GetDestinationName("Destination Type","Destination No.");
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",1));
                Editable=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re registreret som bogf›rt.;
                           ENU=Specifies the date when the warehouse activity should be recorded as being posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Posting Date" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipment Date";
                Editable=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No.";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",2)) }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af det bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies an additional part of the document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No.2";
                CaptionClass=FORMAT(WMSMgt.GetCaption("Destination Type","Source Document",3)) }

    { 97  ;1   ;Part      ;
                Name=WhseActivityLines;
                ApplicationArea=#Warehouse;
                SubPageView=SORTING(Activity Type,No.,Sorting Sequence No.)
                            WHERE(Breakbulk=CONST(No));
                SubPageLink=Activity Type=FIELD(Type),
                            No.=FIELD(No.);
                PagePartID=Page7378;
                PartType=Page }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 4   ;1   ;Part      ;
                ApplicationArea=#ItemTracking;
                SubPageLink=Item No.=FIELD(Item No.),
                            Variant Code=FIELD(Variant Code),
                            Location Code=FIELD(Location Code);
                PagePartID=Page9126;
                ProviderID=97;
                Visible=FALSE;
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
      WhseActPrint@1000 : Codeunit 5776;
      WMSMgt@1001 : Codeunit 7302;

    LOCAL PROCEDURE AutofillQtyToHandle@1();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.AutofillQtyToHandle;
    END;

    LOCAL PROCEDURE DeleteQtyToHandle@2();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.DeleteQtyToHandle;
    END;

    LOCAL PROCEDURE PostPickYesNo@3();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.PostPickYesNo;
    END;

    LOCAL PROCEDURE PostAndPrint@4();
    BEGIN
      CurrPage.WhseActivityLines.PAGE.PostAndPrint;
    END;

    LOCAL PROCEDURE SourceNoOnAfterValidate@19036011();
    BEGIN
      CurrPage.UPDATE;
      CurrPage.WhseActivityLines.PAGE.UpdateForm;
    END;

    BEGIN
    END.
  }
}

