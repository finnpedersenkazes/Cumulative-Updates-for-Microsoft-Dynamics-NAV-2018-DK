OBJECT Page 7331 Posted Whse. Receipt Subform
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
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table7319;
    DelayedInsert=Yes;
    PageType=ListPart;
    AutoSplitKey=Yes;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1900206304;2 ;Action    ;
                      CaptionML=[DAN=Bogfõrt kildedokument;
                                 ENU=Posted Source Document];
                      ToolTipML=[DAN=èbn listen over bogfõrte kildebilag.;
                                 ENU=Open the list of posted source documents.];
                      ApplicationArea=#Advanced;
                      Image=PostedOrder;
                      OnAction=BEGIN
                                 ShowPostedSourceDoc;
                               END;
                                }
      { 1901742304;2 ;Action    ;
                      CaptionML=[DAN=Lagerdokumentlinje;
                                 ENU=Whse. Document Line];
                      ToolTipML=[DAN=FÜ vist linjen pÜ et andet lagerdokument, som lageraktiviteten vedrõrer.;
                                 ENU=View the line on another warehouse document that the warehouse activity is for.];
                      ApplicationArea=#Warehouse;
                      Image=Line;
                      OnAction=BEGIN
                                 ShowWhseLine;
                               END;
                                }
      { 1903867004;2 ;Action    ;
                      CaptionML=[DAN=Placeringsindh.ov.sigt;
                                 ENU=Bin Contents List];
                      ToolTipML=[DAN=FÜ vist indholdet af den valgte placering og de parametre, der definerer, hvordan varer sendes gennem placeringen.;
                                 ENU=View the contents of the selected bin and the parameters that define how items are routed through the bin.];
                      ApplicationArea=#Warehouse;
                      Image=BinContent;
                      OnAction=BEGIN
                                 ShowBinContents;
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
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedrõrer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor modtagelseslinjen var forfalden til betaling.;
                           ENU=Specifies the date that the receipt line was due.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for informational use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for zonen pÜ den bogfõrte modtagelseslinje.;
                           ENU=Specifies the code of the zone on this posted receipt line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller lëgges pÜ lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den zonekode, der blev brugt til at oprette lëg-pÜ-lager-aktiviteten til direkte afsendelse, da modtagelsen blev bogfõrt.;
                           ENU=Specifies the zone code used to create the cross-dock put-away for this line when the receipt was posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Cross-Dock Zone Code";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placeringskode, der blev brugt til at oprette lëg-pÜ-lager-aktiviteten til direkte afsendelse, da modtagelsen blev bogfõrt.;
                           ENU=Specifies the bin code used to create the cross-dock put-away for this line when the receipt was posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Cross-Dock Bin Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, der er modtaget og bogfõrt.;
                           ENU=Specifies the number of the item that was received and posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af varen pÜ linjen.;
                           ENU=Specifies the description of the item in the line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en anden beskrivelse af varen pÜ linjen, hvis det er relevant.;
                           ENU=Specifies a second description of the item in the line, if any.];
                ApplicationArea=#Warehouse;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er modtaget.;
                           ENU=Specifies the quantity that was received.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er modtaget, anfõrt i basisenheder.;
                           ENU=Specifies the quantity that was received, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er lagt pÜ lager.;
                           ENU=Specifies the quantity that is put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Put Away";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varer, der var anfõrt i feltet Antal til dir. afsend. pÜ lagermodtagelseslinjen, da modtagelsen blev bogfõrt.;
                           ENU=Specifies the quantity of items that was in the Qty. To Cross-Dock field on the warehouse receipt line when it was posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Cross-Docked";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er lagt pÜ lager, anfõrt i basisenheder.;
                           ENU=Specifies the quantity that is put away, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Put Away (Base)";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det basisantal af varer, der var anfõrt i feltet Antal til dir. afsend. (basis) pÜ lagermodtagelseslinjen, da modtagelsen blev bogfõrt.;
                           ENU=Specifies the base quantity of items in the Qty. To Cross-Dock (Base) field on the warehouse receipt line when it was posted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Cross-Docked (Base)";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i lëg-pÜ-lager-instruktionerne, som er ved at blive lagt pÜ lager.;
                           ENU=Specifies the quantity on put-away instructions in the process of being put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Put-away Qty.";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i lëg-pÜ-lager-instruktionerne, anfõrt i basisenheder, som er ved at blive lagt pÜ lager.;
                           ENU=Specifies the quantity on put-away instructions, in the base unit of measure, in the process of being put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Put-away Qty. (Base)";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

  }
  CODE
  {
    VAR
      WMSMgt@1000 : Codeunit 7302;

    LOCAL PROCEDURE ShowPostedSourceDoc@1();
    BEGIN
      WMSMgt.ShowPostedSourceDoc("Posted Source Document","Posted Source No.");
    END;

    LOCAL PROCEDURE ShowBinContents@7301();
    VAR
      BinContent@1000 : Record 7302;
    BEGIN
      BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    END;

    LOCAL PROCEDURE ShowWhseLine@3();
    BEGIN
      WMSMgt.ShowWhseDocLine(0,"Whse. Receipt No.","Whse Receipt Line No.");
    END;

    [External]
    PROCEDURE PutAwayCreate@2();
    VAR
      PostedWhseRcptHdr@1000 : Record 7318;
      PostedWhseRcptLine@1002 : Record 7319;
    BEGIN
      PostedWhseRcptHdr.GET("No.");
      PostedWhseRcptLine.COPY(Rec);
      CreatePutAwayDoc(PostedWhseRcptLine,PostedWhseRcptHdr."Assigned User ID");
    END;

    BEGIN
    END.
  }
}

