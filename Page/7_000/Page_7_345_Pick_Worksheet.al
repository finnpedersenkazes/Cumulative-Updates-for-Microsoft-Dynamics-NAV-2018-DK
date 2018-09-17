OBJECT Page 7345 Pick Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Plukkladde;
               ENU=Pick Worksheet];
    SaveValues=Yes;
    InsertAllowed=No;
    SourceTable=Table7326;
    SourceTableView=SORTING(Worksheet Template Name,Name,Location Code,Sorting Sequence No.);
    DataCaptionFields=Name;
    PageType=Worksheet;
    RefreshOnActivate=Yes;
    OnOpenPage=VAR
                 WhseWkshSelected@1000 : Boolean;
               BEGIN
                 OpenedFromBatch := (Name <> '') AND ("Worksheet Template Name" = '');
                 IF OpenedFromBatch THEN BEGIN
                   CurrentWkshName := Name;
                   CurrentLocationCode := "Location Code";
                   OpenWhseWksh(Rec,CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode);
                   EXIT;
                 END;
                 TemplateSelection(PAGE::"Pick Worksheet",1,Rec,WhseWkshSelected);
                 IF NOT WhseWkshSelected THEN
                   ERROR('');
                 OpenWhseWksh(Rec,CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode);
               END;

    OnAfterGetRecord=BEGIN
                       CrossDockMgt.CalcCrossDockedItems("Item No.","Variant Code","Unit of Measure Code","Location Code",
                         QtyCrossDockedUOMBase,
                         QtyCrossDockedAllUOMBase);
                       QtyCrossDockedUOM := 0;
                       IF  "Qty. per Unit of Measure" <> 0 THEN
                         QtyCrossDockedUOM := ROUND(QtyCrossDockedUOMBase / "Qty. per Unit of Measure",0.00001);
                     END;

    OnDeleteRecord=BEGIN
                     ItemDescription := '';
                   END;

    OnAfterGetCurrRecord=BEGIN
                           GetItem("Item No.",ItemDescription);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 46      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 47      ;2   ;Action    ;
                      CaptionML=[DAN=&Kildedokumentlinje;
                                 ENU=Source &Document Line];
                      ToolTipML=[DAN=F† vist linjen p† et frigivet kildedokument, som lageraktiviteten vedr›rer.;
                                 ENU="View the line on a released source document that the warehouse activity is for. "];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SourceDocLine;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 WMSMgt.ShowSourceDocLine(
                                   "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.");
                               END;
                                }
      { 66      ;2   ;Action    ;
                      CaptionML=[DAN=Lagerdokumentlinje;
                                 ENU=Whse. Document Line];
                      ToolTipML=[DAN=F† vist linjen p† et andet lagerdokument, som lageraktiviteten vedr›rer.;
                                 ENU=View the line on another warehouse document that the warehouse activity is for.];
                      ApplicationArea=#Warehouse;
                      Image=Line;
                      OnAction=BEGIN
                                 WMSMgt.ShowWhseDocLine(
                                   "Whse. Document Type","Whse. Document No.","Whse. Document Line No.");
                               END;
                                }
      { 69      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      Image=Item }
      { 30      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 30;
                      RunPageLink=No.=FIELD(Item No.);
                      Image=EditLines }
      { 4       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Lagerposter;
                                 ENU=Warehouse Entries];
                      ToolTipML=[DAN=Vis afsluttede lageraktiviteter, der er knyttet til bilaget.;
                                 ENU=View completed warehouse activities related to the document.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7318;
                      RunPageView=SORTING(Item No.,Location Code,Variant Code,Bin Type Code,Unit of Measure Code,Lot No.,Serial No.);
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Location Code=FIELD(Location Code);
                      Promoted=Yes;
                      Image=BinLedger;
                      PromotedCategory=Process }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 38;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Location Code=FIELD(Location Code);
                      Promoted=Yes;
                      Image=CustomerLedger;
                      PromotedCategory=Process }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Placeringsindh.;
                                 ENU=Bin Contents];
                      ToolTipML=[DAN=Vis varer i placeringen, hvis den valgte linje indeholder en placeringskode.;
                                 ENU=View items in the bin if the selected line contains a bin code.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7305;
                      RunPageView=SORTING(Location Code,Item No.,Variant Code);
                      RunPageLink=Location Code=FIELD(Location Code),
                                  Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code);
                      Promoted=Yes;
                      Image=BinContent;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 32      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 2       ;2   ;Action    ;
                      Name=Get Warehouse Documents;
                      ShortCutKey=Shift+F11;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent lagerdokumenter;
                                 ENU=Get Warehouse Documents];
                      ToolTipML=[DAN=V‘lg et lagerdokument, der skal plukkes til, f.eks. en lagerleverance.;
                                 ENU=Select a warehouse document to pick for, such as a warehouse shipment.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 RetrieveWhsePickDoc@1001 : Codeunit 5752;
                               BEGIN
                                 RetrieveWhsePickDoc.GetSingleWhsePickDoc(
                                   CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode);
                                 SortWhseWkshLines(
                                   CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode,CurrentSortingMethod);
                               END;
                                }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=Autofyld h†ndteringsantal;
                                 ENU=Autofill Qty. to Handle];
                      ToolTipML=[DAN=F† systemet til at angive det udest†ende antal i feltet H†ndteringsantal.;
                                 ENU=Have the system enter the outstanding quantity in the Qty. to Handle field.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=AutofillQtyToHandle;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PickWkshLine@1000 : Record 7326;
                               BEGIN
                                 PickWkshLine.COPY(Rec);
                                 AutofillQtyToHandle(PickWkshLine);
                               END;
                                }
      { 6       ;2   ;Action    ;
                      CaptionML=[DAN=Slet h†ndteringsantal;
                                 ENU=Delete Qty. to Handle];
                      ToolTipML=[DAN="F† systemet til at slette v‘rdien i feltet H†ndteringsantal. ";
                                 ENU="Have the system clear the value in the Qty. To Handle field. "];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=DeleteQtyToHandle;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PickWkshLine@1000 : Record 7326;
                               BEGIN
                                 PickWkshLine.COPY(Rec);
                                 DeleteQtyToHandle(PickWkshLine);
                               END;
                                }
      { 55      ;2   ;Action    ;
                      Name=CreatePick;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret pluk;
                                 ENU=Create Pick];
                      ToolTipML=[DAN="Opret lagerplukdokumenter for de angivne pluk. ";
                                 ENU="Create warehouse pick documents for the specified picks. "];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CreateInventoryPickup;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Whse. Create Pick",Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 25  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som kladden er baseret p†.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#Warehouse;
                SourceExpr=CurrentWkshName;
                OnValidate=BEGIN
                             CheckWhseWkshName(CurrentWkshName,CurrentLocationCode,Rec);
                             CurrentWkshNameOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           LookupWhseWkshName(Rec,CurrentWkshName,CurrentLocationCode);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 9   ;1   ;Field     ;
                CaptionML=[DAN=Lokationskode;
                           ENU=Location Code];
                ToolTipML=[DAN="Angiver den lokation, hvor lageraktiviteten finder sted. ";
                           ENU="Specifies the location where the warehouse activity takes place. "];
                ApplicationArea=#Warehouse;
                SourceExpr=CurrentLocationCode;
                Editable=FALSE }

    { 56  ;1   ;Field     ;
                CaptionML=[DAN=Sorteringsmetode;
                           ENU=Sorting Method];
                ToolTipML=[DAN=Angiver, hvilken metode bev‘gelseslinjerne sorteres med.;
                           ENU=Specifies the method by which the movement lines are sorted.];
                OptionCaptionML=[DAN=" ,Vare,Bilag,Placering,Forfaldsdato,Levering";
                                 ENU=" ,Item,Document,Shelf or Bin,Due Date,Ship-To"];
                ApplicationArea=#Warehouse;
                SourceExpr=CurrentSortingMethod;
                OnValidate=BEGIN
                             CurrentSortingMethodOnAfterVal;
                           END;
                            }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for det lagerdokument, som linjen er tilknyttet.;
                           ENU=Specifies the type of warehouse document this line is associated with.];
                OptionCaptionML=[DAN=" ,,Leverance,,Internt pluk,Produktion,,,Montage";
                                 ENU=" ,,Shipment,,Internal Pick,Production,,,Assembly"];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document Type" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† lagerdokumentet.;
                           ENU=Specifies the number of the warehouse document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document No." }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den linje i lagerdokumentet, som danner grundlag for kladdelinjen.;
                           ENU=Specifies the number of the line in the warehouse document that is the basis for the worksheet line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document Line No.";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, som linjen vedr›rer.;
                           ENU=Specifies the number of the item that the line concerns.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No.";
                Editable=FALSE;
                OnValidate=BEGIN
                             GetItem("Item No.",ItemDescription);
                           END;
                            }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen p† linjen.;
                           ENU=Specifies the description of the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description;
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor varerne skal placeres.;
                           ENU=Specifies the code of the zone in which the items should be placed.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Zone Code";
                Visible=FALSE;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, hvor varerne skal placeres.;
                           ENU=Specifies the code of the bin into which the items should be placed.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Bin Code";
                Visible=FALSE;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for information use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen du vil flytte.;
                           ENU=Specifies how many units of the item you want to move.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity;
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen du vil flytte.;
                           ENU=Specifies how many units of the item you want to move.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Handle";
                OnValidate=BEGIN
                             QtytoHandleOnAfterValidate;
                           END;
                            }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der stadig mangler at blive h†ndteret.;
                           ENU=Specifies the quantity that still needs to be handled.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding" }

    { 52  ;2   ;Field     ;
                CaptionML=[DAN=Disp. antal til pluk;
                           ENU=Available Qty. to Pick];
                ToolTipML=[DAN=Angiver det antal p† plukkladdelinjen, som er tilg‘ngeligt for pluk. Antallet omfatter frigivne lagerleverancelinjer.;
                           ENU=Specifies the quantity on the pick worksheet line that is available to pick. This quantity includes released warehouse shipment lines.];
                ApplicationArea=#Warehouse;
                DecimalPlaces=0:5;
                SourceExpr=AvailableQtyToPick;
                Editable=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for linjen.;
                           ENU=Specifies the due date of the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code";
                Editable=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver afsendelsesadviset p† den lagerleverancelinje, der er knyttet til kladdelinjen.;
                           ENU=Specifies the shipping advice on the warehouse shipment line associated with this worksheet line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Advice" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den destinationstype, der er tilknyttet lagerkladdelinjen.;
                           ENU=Specifies the type of destination associated with the warehouse worksheet line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, kreditor eller lokation, som varerne skal h†nderes for.;
                           ENU=Specifies the number of the customer, vendor, or location for which the items should be processed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No." }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No.";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the line number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Line No.";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                CaptionML=[DAN=Ant. p† dir. afs. placering;
                           ENU=Qty. on Cross-Dock Bin];
                ToolTipML=[DAN=Angiver det antal varer, der skal sendes direkte.;
                           ENU=Specifies the quantity of items to be cross-docked.];
                ApplicationArea=#Warehouse;
                DecimalPlaces=0:5;
                SourceExpr=QtyCrossDockedUOM;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",TRUE);
                            END;
                             }

    { 70  ;2   ;Field     ;
                CaptionML=[DAN=Antal til dir. afs. (basis);
                           ENU=Qty. on Cross-Dock (Base)];
                ToolTipML=[DAN=Angiver det antal varer, der skal sendes direkte.;
                           ENU=Specifies the quantity of items to be cross-docked.];
                ApplicationArea=#Warehouse;
                DecimalPlaces=0:5;
                SourceExpr=QtyCrossDockedUOMBase;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",TRUE);
                            END;
                             }

    { 72  ;2   ;Field     ;
                CaptionML=[DAN=Ant. p† dir. afs. placering (basis alle enh.);
                           ENU=Qty. on Cross-Dock Bin (Base all UOM)];
                ToolTipML=[DAN=Angiver det antal varer, der skal sendes direkte.;
                           ENU="Specifies the quantity of items to be cross-docked. "];
                ApplicationArea=#Warehouse;
                DecimalPlaces=0:5;
                SourceExpr=QtyCrossDockedAllUOMBase;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",FALSE);
                            END;
                             }

    { 22  ;1   ;Group      }

    { 1900669001;2;Group  ;
                GroupType=FixedLayout }

    { 1901652601;3;Group  ;
                CaptionML=[DAN=Varebeskrivelse;
                           ENU=Item Description] }

    { 23  ;4   ;Field     ;
                ApplicationArea=#Warehouse;
                SourceExpr=ItemDescription;
                Editable=FALSE;
                ShowCaption=No }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 8   ;1   ;Part      ;
                ApplicationArea=#ItemTracking;
                SubPageLink=Item No.=FIELD(Item No.),
                            Variant Code=FIELD(Variant Code),
                            Location Code=FIELD(Location Code);
                PagePartID=Page9126;
                Visible=FALSE;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      WMSMgt@1001 : Codeunit 7302;
      CrossDockMgt@1009 : Codeunit 5780;
      CurrentWkshTemplateName@1002 : Code[10];
      CurrentWkshName@1005 : Code[10];
      CurrentLocationCode@1003 : Code[10];
      CurrentSortingMethod@1000 : ' ,Item,Document,Shelf/Bin No.,Due Date,Ship-To';
      ItemDescription@1004 : Text[50];
      QtyCrossDockedUOM@1008 : Decimal;
      QtyCrossDockedAllUOMBase@1007 : Decimal;
      QtyCrossDockedUOMBase@1006 : Decimal;
      OpenedFromBatch@1010 : Boolean;

    LOCAL PROCEDURE QtytoHandleOnAfterValidate@19067087();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE CurrentWkshNameOnAfterValidate@19009494();
    BEGIN
      CurrPage.SAVERECORD;
      SetWhseWkshName(CurrentWkshName,CurrentLocationCode,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE CurrentSortingMethodOnAfterVal@19078525();
    BEGIN
      SortWhseWkshLines(
        CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode,CurrentSortingMethod);
      CurrPage.UPDATE(FALSE);
      SETCURRENTKEY("Worksheet Template Name",Name,"Location Code","Sorting Sequence No.");
    END;

    BEGIN
    END.
  }
}

