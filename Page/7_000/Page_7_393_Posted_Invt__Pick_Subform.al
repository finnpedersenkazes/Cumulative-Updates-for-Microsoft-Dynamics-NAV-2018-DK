OBJECT Page 7393 Posted Invt. Pick Subform
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
    InsertAllowed=No;
    LinksAllowed=No;
    SourceTable=Table7343;
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
                      CaptionML=[DAN=Placeringsindh.ov.sigt;
                                 ENU=Bin Contents List];
                      ToolTipML=[DAN=F† vist indholdet af den valgte placering og de parametre, der definerer, hvordan varer sendes gennem placeringen.;
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

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver handlingstypen for lagerpluklinjen. Hvis det drejer sig om lagerpluklinjer, er handlingstypen altid Hent, hvilket betyder, at varerne hentes fra placeringen.;
                           ENU=Specifies the action type for the inventory pick line. For posted inventory pick lines, the action type is always Take, meaning that the items are being taken out of the bin.];
                ApplicationArea=#Warehouse;
                SourceExpr="Action Type";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                OptionCaptionML=[DAN=" ,,,,Salgsreturv.ordre,K›bsordre,,,,Indg†ende overflyt.";
                                 ENU=" ,,,,Sales Return Order,Purchase Order,,,,Inbound Transfer"];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, der er plukket.;
                           ENU=Specifies the number of the item that was picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af den vare, der er plukket.;
                           ENU=Specifies a description of the item that was picked.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p† den vare, der er plukket.;
                           ENU=Specifies the serial number for the item that was picked.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lotnummeret p† den vare, der er plukket.;
                           ENU=Specifies the lot number for the item that was picked.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE }

    { 1106000000;2;Field  ;
                ToolTipML=[DAN=Angiver udl›bsdatoen for den vare, der er plukket.;
                           ENU=Specifies the expiration date for the item that was picked.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Expiration Date";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden til den lokation, hvor varerne er plukket fra.;
                           ENU=Specifies the code for the location at which the items were pick.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                OnValidate=BEGIN
                             BinCodeOnAfterValidate;
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for informational use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, som er plukket.;
                           ENU=Specifies the quantity of the item that was picked.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i basisenheder af den vare, der er plukket.;
                           ENU=Specifies the quantity, in the base unit of measure, of the item that was picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i enheder af den vare, der er plukket.;
                           ENU=Specifies the quantity per unit of measure of the item that was picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den destinationstype, der er tilknyttet den bogf›rte lagerpluklinje.;
                           ENU=Specifies the type of destination associated with the posted inventory pick line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer eller den kode for debitoren eller kreditoren, som er knyttet til linjen.;
                           ENU=Specifies the number or the code of the customer or vendor linked to the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No.";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver specialudstyrskoden for den vare, der er plukket.;
                           ENU=Specifies the special equipment code for the item that was picked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Special Equipment Code";
                Visible=FALSE }

  }
  CODE
  {

    LOCAL PROCEDURE ShowBinContents@7301();
    VAR
      BinContent@1000 : Record 7302;
    BEGIN
      BinContent.ShowBinContents("Location Code","Item No.","Variant Code","Bin Code");
    END;

    LOCAL PROCEDURE BinCodeOnAfterValidate@19073508();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

