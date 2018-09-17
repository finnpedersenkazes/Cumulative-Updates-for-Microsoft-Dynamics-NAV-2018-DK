OBJECT Page 7336 Whse. Shipment Subform
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    InsertAllowed=No;
    LinksAllowed=No;
    SourceTable=Table7321;
    DelayedInsert=Yes;
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnAfterGetRecord=BEGIN
                       CrossDockMgt.CalcCrossDockedItems("Item No.","Variant Code","Unit of Measure Code","Location Code",
                         QtyCrossDockedUOMBase,
                         QtyCrossDockedAllUOMBase);
                       QtyCrossDockedUOM := 0;
                       IF  "Qty. per Unit of Measure" <> 0 THEN
                         QtyCrossDockedUOM := ROUND(QtyCrossDockedUOMBase / "Qty. per Unit of Measure",0.00001);
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1900724404;2 ;Action    ;
                      CaptionML=[DAN=&Kildedokumentlinje;
                                 ENU=Source &Document Line];
                      ToolTipML=[DAN=F† vist linjen p† et frigivet kildedokument, som lageraktiviteten vedr›rer.;
                                 ENU="View the line on a released source document that the warehouse activity is for. "];
                      ApplicationArea=#Warehouse;
                      Image=SourceDocLine;
                      OnAction=BEGIN
                                 ShowSourceLine;
                               END;
                                }
      { 1903866704;2 ;Action    ;
                      AccessByPermission=TableData 7302=R;
                      CaptionML=[DAN=&Placeringsindh.oversigt;
                                 ENU=&Bin Contents List];
                      ToolTipML=[DAN=F† vist indholdet af hver placering og de parametre, der definerer, hvordan varer sendes gennem placeringen.;
                                 ENU=View the contents of each bin and the parameters that define how items are routed through the bin.];
                      ApplicationArea=#Warehouse;
                      Image=BinContent;
                      OnAction=BEGIN
                                 ShowBinContents;
                               END;
                                }
      { 1900295504;2 ;Action    ;
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
      { 5       ;2   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=Montage til ordre;
                                 ENU=Assemble to Order];
                      ToolTipML=[DAN=Vis den tilknyttede montageordre, hvis leverancen var til et ordremontagesalg.;
                                 ENU=View the linked assembly order if the shipment was for an assemble-to-order sale.];
                      ApplicationArea=#Assembly;
                      Image=AssemblyBOM;
                      OnAction=VAR
                                 ATOLink@1001 : Record 904;
                                 ATOSalesLine@1000 : Record 37;
                               BEGIN
                                 TESTFIELD("Assemble to Order",TRUE);
                                 TESTFIELD("Source Type",DATABASE::"Sales Line");
                                 ATOSalesLine.GET("Source Subtype","Source No.","Source Line No.");
                                 ATOLink.ShowAsm(ATOSalesLine);
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

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the line number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Line No.";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den destinationstype, der er tilknyttet lagerleverancelinjen.;
                           ENU=Specifies the type of destination associated with the warehouse shipment line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, kreditor eller lokation, som varerne skal leveres til.;
                           ENU=Specifies the number of the customer, vendor, or location to which the items should be shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, der skal leveres.;
                           ENU=Specifies the number of the item that should be shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen p† linjen.;
                           ENU=Specifies the description of the item in the line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne p† linjen leveres fra.;
                           ENU=Specifies the code of the location from which the items on the line are being shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE;
                Editable=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor placeringen p† leverancelinjen findes.;
                           ENU=Specifies the code of the zone where the bin on this shipment line is located.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE;
                OnValidate=BEGIN
                             BinCodeOnAfterValidate;
                           END;
                            }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for informational use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal leveres.;
                           ENU=Specifies the quantity that should be shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity;
                OnValidate=BEGIN
                             QuantityOnAfterValidate;
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal leveres, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that should be shipped, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der mangler at blive afsendt.;
                           ENU=Specifies the quantity of items that remain to be shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Ship" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af varen p† linjen, der er bogf›rt som leveret.;
                           ENU=Specifies the quantity of the item on the line that is posted as shipped.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Shipped" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver i basisenheder det antal, som leveres, n†r lagerleverancen er bogf›rt.;
                           ENU=Specifies the quantity, in base units of measure, that will be shipped when the warehouse shipment is posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Ship (Base)";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er bogf›rt som leveret, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that is posted as shipped expressed in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Shipped (Base)";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der stadig mangler at blive h†ndteret.;
                           ENU=Specifies the quantity that still needs to be handled.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding";
                Visible=TRUE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler at blive h†ndteret, anf›rt i basisenheder.;
                           ENU=Specifies the quantity that still needs to be handled, expressed in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding (Base)";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der if›lge plukinstruktionerne skal plukkes til lagerleverancelinjen.;
                           ENU=Specifies the quantity in pick instructions assigned to be picked for the warehouse shipment line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Pick Qty.";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, anf›rt i basisenheder, der if›lge plukinstruktionerne skal plukkes til lagerleverancelinjen.;
                           ENU=Specifies the quantity, in the base unit of measure, in pick instructions, that is assigned to be picked for the warehouse shipment line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Pick Qty. (Base)";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor stor en del af det samlede leveranceantal der er registreret som plukket.;
                           ENU=Specifies how many of the total shipment quantity have been registered as picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Picked";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor stor en del af det samlede leveranceantal der er registreret som plukket, anf›rt i basisenheder.;
                           ENU=Specifies how many of the total shipment quantity in the base unit of measure have been registered as picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Picked (Base)";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede lageraktivitet, som f.eks. pluk, skal v‘re afsluttet for at sikre, at varerne kan leveres p† afsendelsesdatoen.;
                           ENU=Specifies the date when the related warehouse activity, such as a pick, must be completed to ensure items can be shipped by the shipment date.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange basisenheder der g†r p† den enhed, der er angivet for varen p† linjen.;
                           ENU=Specifies the number of base units of measure that are in the unit of measure specified for the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure" }

    { 54  ;2   ;Field     ;
                CaptionML=[DAN=Ant. p† dir. afs. placering;
                           ENU=Qty. on Cross-Dock Bin];
                ToolTipML=[DAN=Angiver summen af alle udg†ende linjer med bestilling p† varen inden for tidshorisonten minus antallet af de varer, der allerede er placeret i omr†det til direkte afsendelse.;
                           ENU=Specifies the sum of all the outbound lines requesting the item within the look-ahead period, minus the quantity of the items that have already been placed in the cross-dock area.];
                ApplicationArea=#Warehouse;
                DecimalPlaces=0:5;
                SourceExpr=QtyCrossDockedUOM;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",TRUE);
                            END;
                             }

    { 56  ;2   ;Field     ;
                CaptionML=[DAN=Ant. p† dir. afs. placering (basis);
                           ENU=Qty. on Cross-Dock Bin (Base)];
                ToolTipML=[DAN=Angiver summen af alle udg†ende linjer med bestilling p† varen inden for tidshorisonten minus antallet af de varer, der allerede er placeret i omr†det til direkte afsendelse.;
                           ENU=Specifies the sum of all the outbound lines requesting the item within the look-ahead period, minus the quantity of the items that have already been placed in the cross-dock area.];
                ApplicationArea=#Warehouse;
                DecimalPlaces=0:5;
                SourceExpr=QtyCrossDockedUOMBase;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",TRUE);
                            END;
                             }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Ant. p† dir. afs. placering (basis alle enh.);
                           ENU=Qty. on Cross-Dock Bin (Base all UOM)];
                ToolTipML=[DAN=Angiver summen af alle udg†ende linjer med bestilling p† varen inden for tidshorisonten minus antallet af de varer, der allerede er placeret i omr†det til direkte afsendelse.;
                           ENU=Specifies the sum of all the outbound lines requesting the item within the look-ahead period, minus the quantity of the items that have already been placed in the cross-dock area.];
                ApplicationArea=#Warehouse;
                DecimalPlaces=0:5;
                SourceExpr=QtyCrossDockedAllUOMBase;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              CrossDockMgt.ShowBinContentsCrossDocked("Item No.","Variant Code","Unit of Measure Code","Location Code",FALSE);
                            END;
                             }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lagerleverancelinjen g‘lder elementer, der monteres under en salgsordre, f›r den leveres.;
                           ENU=Specifies if the warehouse shipment line is for items that are assembled to a sales order before it is shipped.];
                ApplicationArea=#Assembly;
                SourceExpr="Assemble to Order";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      WMSMgt@1000 : Codeunit 7302;
      CrossDockMgt@1004 : Codeunit 5780;
      QtyCrossDockedUOM@1003 : Decimal;
      QtyCrossDockedAllUOMBase@1002 : Decimal;
      QtyCrossDockedUOMBase@1001 : Decimal;

    LOCAL PROCEDURE ShowSourceLine@1();
    BEGIN
      WMSMgt.ShowSourceDocLine("Source Type","Source Subtype","Source No.","Source Line No.",0);
    END;

    [External]
    PROCEDURE PostShipmentYesNo@3();
    VAR
      WhseShptLine@1001 : Record 7321;
    BEGIN
      WhseShptLine.COPY(Rec);
      CODEUNIT.RUN(CODEUNIT::"Whse.-Post Shipment (Yes/No)",WhseShptLine);
      RESET;
      SETCURRENTKEY("No.","Sorting Sequence No.");
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE PostShipmentPrintYesNo@2();
    VAR
      WhseShptLine@1001 : Record 7321;
    BEGIN
      WhseShptLine.COPY(Rec);
      CODEUNIT.RUN(CODEUNIT::"Whse.-Post Shipment + Print",WhseShptLine);
      RESET;
      SETCURRENTKEY("No.","Sorting Sequence No.");
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE AutofillQtyToHandle@10();
    VAR
      WhseShptLine@1000 : Record 7321;
    BEGIN
      WhseShptLine.COPY(Rec);
      AutofillQtyToHandle(WhseShptLine);
    END;

    [External]
    PROCEDURE DeleteQtyToHandle@8();
    VAR
      WhseShptLine@1000 : Record 7321;
    BEGIN
      WhseShptLine.COPY(Rec);
      DeleteQtyToHandle(WhseShptLine);
    END;

    LOCAL PROCEDURE ShowBinContents@6();
    VAR
      BinContent@1000 : Record 7302;
    BEGIN
      BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    END;

    [External]
    PROCEDURE PickCreate@4();
    VAR
      WhseShptHeader@1001 : Record 7320;
      WhseShptLine@1000 : Record 7321;
      ReleaseWhseShipment@1002 : Codeunit 7310;
    BEGIN
      WhseShptLine.COPY(Rec);
      WhseShptHeader.GET(WhseShptLine."No.");
      IF WhseShptHeader.Status = WhseShptHeader.Status::Open THEN
        ReleaseWhseShipment.Release(WhseShptHeader);
      CreatePickDoc(WhseShptLine,WhseShptHeader);
    END;

    LOCAL PROCEDURE OpenItemTrackingLines@6500();
    BEGIN
      OpenItemTrackingLines;
    END;

    LOCAL PROCEDURE BinCodeOnAfterValidate@19073508();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE QuantityOnAfterValidate@19032465();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

