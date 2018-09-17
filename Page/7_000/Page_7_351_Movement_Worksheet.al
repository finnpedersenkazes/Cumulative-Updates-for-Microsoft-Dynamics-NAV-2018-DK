OBJECT Page 7351 Movement Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bev‘gelseskladde;
               ENU=Movement Worksheet];
    SaveValues=Yes;
    SourceTable=Table7326;
    DelayedInsert=Yes;
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
                 TemplateSelection(PAGE::"Movement Worksheet",2,Rec,WhseWkshSelected);
                 IF NOT WhseWkshSelected THEN
                   ERROR('');
                 OpenWhseWksh(Rec,CurrentWkshTemplateName,CurrentWkshName,CurrentLocationCode);
               END;

    OnAfterGetRecord=BEGIN
                       IF NOT ItemUOM.GET("Item No.","From Unit of Measure Code") THEN
                         ItemUOM.INIT;
                     END;

    OnNewRecord=BEGIN
                  SetUpNewLine(
                    CurrentWkshTemplateName,CurrentWkshName,
                    CurrentLocationCode,CurrentSortingMethod,xRec."Line No.");
                END;

    OnInsertRecord=BEGIN
                     "Sorting Sequence No." := GetSortSeqNo(CurrentSortingMethod);
                   END;

    OnModifyRecord=BEGIN
                     "Sorting Sequence No." := GetSortSeqNo(CurrentSortingMethod);
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
      { 41      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 42      ;2   ;Action    ;
                      Name=ItemTrackingLines;
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
                      ApplicationArea=#Advanced;
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
                      RunPageView=SORTING(Item No.,Location Code,Variant Code);
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
                      ApplicationArea=#Advanced;
                      RunObject=Page 38;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(Item No.),
                                  Variant Code=FIELD(Variant Code),
                                  Location Code=FIELD(Location Code);
                      Promoted=Yes;
                      Image=ItemLedger;
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
                                 WhseWkshLine@1000 : Record 7326;
                               BEGIN
                                 WhseWkshLine.COPY(Rec);
                                 AutofillQtyToHandle(WhseWkshLine);
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
                                 WhseWkshLine@1000 : Record 7326;
                               BEGIN
                                 WhseWkshLine.COPY(Rec);
                                 DeleteQtyToHandle(WhseWkshLine);
                               END;
                                }
      { 54      ;2   ;Separator  }
      { 2       ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Beregn genopfyldning;
                                 ENU=Calculate Bin &Replenishment];
                      ToolTipML=[DAN=Beregn varernes bev‘gelser fra masseopbevaringsplaceringer med lave placeringsniveauer til placeringer med h›je placeringsniveauer i plukomr†derne.;
                                 ENU=Calculate the movement of items from bulk storage bins with lower bin rankings to bins with a high bin ranking in the picking areas.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=CalculateBinReplenishment;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Location@1001 : Record 14;
                                 BinContent@1003 : Record 7302;
                                 ReplenishBinContent@1000 : Report 7300;
                               BEGIN
                                 Location.GET("Location Code");
                                 ReplenishBinContent.InitializeRequest(
                                   "Worksheet Template Name",Name,"Location Code",
                                   Location."Allow Breakbulk",FALSE,FALSE);

                                 ReplenishBinContent.SETTABLEVIEW(BinContent);
                                 ReplenishBinContent.RUN;
                                 CLEAR(ReplenishBinContent);
                               END;
                                }
      { 27      ;2   ;Action    ;
                      AccessByPermission=TableData 7302=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent placeringsindh.;
                                 ENU=Get Bin Content];
                      ToolTipML=[DAN=Brug en funktion til oprettelse af overflytningslinjer med varer, der skal l‘gges p† lager eller plukkes, baseret p† det faktiske indhold p† den angivne placering.;
                                 ENU=Use a function to create transfer lines with items to put away or pick based on the actual content in the specified bin.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      Image=GetBinContent;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 BinContent@1001 : Record 7302;
                                 DummyRec@1000 : Record 7331;
                                 GetBinContent@1002 : Report 7391;
                               BEGIN
                                 BinContent.SETRANGE("Location Code","Location Code");
                                 GetBinContent.SETTABLEVIEW(BinContent);
                                 GetBinContent.InitializeReport(Rec,DummyRec,0);
                                 GetBinContent.RUN;
                               END;
                                }
      { 3       ;2   ;Separator  }
      { 55      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret bev‘gelse;
                                 ENU=Create Movement];
                      ToolTipML=[DAN=Opret de angivne bev‘gelsesbilag.;
                                 ENU=Create the specified warehouse movement documents.];
                      ApplicationArea=#Warehouse;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CreateMovement;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 WhseWkshLine@1002 : Record 7326;
                               BEGIN
                                 WhseWkshLine.SETFILTER(Quantity,'>0');
                                 WhseWkshLine.COPYFILTERS(Rec);
                                 IF WhseWkshLine.FINDFIRST THEN
                                   MovementCreate(WhseWkshLine)
                                 ELSE
                                   ERROR(Text001);

                                 WhseWkshLine.RESET;
                                 COPYFILTERS(WhseWkshLine);
                                 FILTERGROUP(2);
                                 SETRANGE("Worksheet Template Name","Worksheet Template Name");
                                 SETRANGE(Name,Name);
                                 SETRANGE("Location Code",CurrentLocationCode);
                                 FILTERGROUP(0);
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
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† den kladde, som du planl‘gger lagerbev‘gelser i.;
                           ENU=Specifies the name of the worksheet in which you plan movements of inventory in the warehouse.];
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
                ToolTipML=[DAN=Angiver den lokation, som du vil flytte lagervarer til p† lageret.;
                           ENU=Specifies the location where you plan to move inventory in the warehouse.];
                ApplicationArea=#Warehouse;
                SourceExpr=CurrentLocationCode;
                Editable=FALSE }

    { 56  ;1   ;Field     ;
                CaptionML=[DAN=Sorteringsmetode;
                           ENU=Sorting Method];
                ToolTipML=[DAN=Angiver, hvilken metode bev‘gelseskladdelinjerne sorteres med.;
                           ENU=Specifies the method by which the movement worksheet lines are sorted.];
                OptionCaptionML=[DAN=" ,Vare,,Til placeringskode,Forfaldsdato";
                                 ENU=" ,Item,,To Bin Code,Due Date"];
                ApplicationArea=#Warehouse;
                SourceExpr=CurrentSortingMethod;
                OnValidate=BEGIN
                             CurrentSortingMethodOnAfterVal;
                           END;
                            }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, som linjen vedr›rer.;
                           ENU=Specifies the number of the item that the line concerns.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No.";
                OnValidate=BEGIN
                             GetItem("Item No.",ItemDescription);
                             ItemNoOnAfterValidate;
                           END;
                            }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen p† linjen.;
                           ENU=Specifies the description of the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den zone, som varerne skal hentes fra.;
                           ENU=Specifies the zone from which the items should be taken.];
                ApplicationArea=#Warehouse;
                SourceExpr="From Zone Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, hvor varerne skal tages fra.;
                           ENU=Specifies the code of the bin from which the items should be taken.];
                ApplicationArea=#Warehouse;
                SourceExpr="From Bin Code" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor varerne skal placeres.;
                           ENU=Specifies the code of the zone in which the items should be placed.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Zone Code" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, hvor varerne skal placeres.;
                           ENU=Specifies the code of the bin into which the items should be placed.];
                ApplicationArea=#Warehouse;
                SourceExpr="To Bin Code";
                OnValidate=BEGIN
                             ToBinCodeOnAfterValidate;
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen du vil flytte.;
                           ENU=Specifies how many units of the item you want to move.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity;
                OnValidate=BEGIN
                             QuantityOnAfterValidate;
                           END;
                            }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal h†ndteres, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that should be handled in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der stadig mangler at blive h†ndteret.;
                           ENU=Specifies the quantity that still needs to be handled.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler at blive h†ndteret, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that still needs to be handled, expressed in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding (Base)";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen du vil flytte.;
                           ENU=Specifies how many units of the item you want to move.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Handle";
                OnValidate=BEGIN
                             QtytoHandleOnAfterValidate;
                           END;
                            }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, som du vil h†ndtere, anf›rt i basisenheder.;
                           ENU=Specifies the quantity you want to handle, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Handle (Base)";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, som er h†ndteret og registreret.;
                           ENU=Specifies the quantity that has been handled and registered.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Handled" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er h†ndteret og registreret, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that has been handled and registered, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Handled (Base)";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for linjen.;
                           ENU=Specifies the due date of the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date";
                OnValidate=BEGIN
                             DueDateOnAfterValidate;
                           END;
                            }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Disp. antal til flytning;
                           ENU=Available Qty. to Move];
                ToolTipML=[DAN=Angiver, hvor mange enheder der er tilg‘ngelige og kan flyttes fra placeringen Fra, n†r der tages h›jde for andre lagerbev‘gelser for varen.;
                           ENU=Specifies how many item units are available to be moved from the From bin, taking into account other warehouse movements for the item.];
                ApplicationArea=#Warehouse;
                DecimalPlaces=0:5;
                SourceExpr=ROUND(CheckAvailQtytoMove / ItemUOM."Qty. per Unit of Measure",0.00001);
                Editable=FALSE }

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
      ItemUOM@1007 : Record 5404;
      CurrentWkshTemplateName@1005 : Code[10];
      CurrentWkshName@1006 : Code[10];
      CurrentLocationCode@1003 : Code[10];
      CurrentSortingMethod@1000 : ' ,Item,,Shelf/Bin No.,Due Date';
      ItemDescription@1004 : Text[50];
      Text001@1002 : TextConst 'DAN=Der er intet at h†ndtere.;ENU=There is nothing to handle.';
      OpenedFromBatch@1001 : Boolean;

    LOCAL PROCEDURE ItemNoOnAfterValidate@19061248();
    BEGIN
      IF CurrentSortingMethod = CurrentSortingMethod::Item THEN
        CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ToBinCodeOnAfterValidate@19037373();
    BEGIN
      IF CurrentSortingMethod = CurrentSortingMethod::"Shelf/Bin No." THEN
        CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE QuantityOnAfterValidate@19032465();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE QtytoHandleOnAfterValidate@19067087();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE DueDateOnAfterValidate@19011747();
    BEGIN
      IF CurrentSortingMethod = CurrentSortingMethod::"Due Date" THEN
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
        CurrentWkshTemplateName,CurrentWkshName,
        CurrentLocationCode,CurrentSortingMethod);
      CurrPage.UPDATE(FALSE);
      SETCURRENTKEY("Worksheet Template Name",Name,"Location Code","Sorting Sequence No.");
    END;

    BEGIN
    END.
  }
}

