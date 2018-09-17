OBJECT Page 7387 Reg. Invt. Movement Lines
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
    CaptionML=[DAN=Reg. linjer for flytning (lager);
               ENU=Reg. Invt. Movement Lines];
    SourceTable=Table7345;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 77      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 24      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis registreret dokument;
                                 ENU=Show Registered Document];
                      ToolTipML=[DAN=Vis det relaterede fuldf›rte lagerbilag.;
                                 ENU=View the related completed warehouse document.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 7384;
                      RunPageView=SORTING(No.);
                      RunPageLink=No.=FIELD(No.);
                      Image=ViewRegisteredOrder }
      { 78      ;2   ;Action    ;
                      CaptionML=[DAN=Vis kildedokument;
                                 ENU=Show Source Document];
                      ToolTipML=[DAN=Vis det relaterede kildebilag.;
                                 ENU=View the related source document.];
                      ApplicationArea=#Advanced;
                      Image=ViewOrder;
                      OnAction=VAR
                                 WMSMgt@1000 : Codeunit 7302;
                               BEGIN
                                 WMSMgt.ShowSourceDocCard("Source Type","Source Subtype","Source No.");
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

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver handlingstypen for linjen for lagerflytning.;
                           ENU=Specifies the action type for the inventory movement line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Action Type";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede lagerflytningslinje.;
                           ENU=Specifies the number of the related inventory movement line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Line No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Reg. lageraktivitetslinje.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Line table.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Type";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Reg. lageraktivitetslinje.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Line table.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Subtype";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the line number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Line No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† underlinjen for den tilknyttede lagerflytning.;
                           ENU=Specifies the number of the subline on the related inventory movement.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Subline No.";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Reg. lageraktivitetslinje.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Line table.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor placeringen for den registrerede lagerflytning findes.;
                           ENU=Specifies the zone code where the bin on the registered inventory movement is located.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for informational use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No.";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Reg. lageraktivitetslinje.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Line table.];
                ApplicationArea=#Warehouse;
                SourceExpr="Item No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Reg. lageraktivitetslinje.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Line table.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. per Unit of Measure" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Reg. lageraktivitetslinje.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Line table.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den anden beskrivelse af varen.;
                           ENU=Specifies the second description of the item.];
                ApplicationArea=#Warehouse;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Reg. lageraktivitetslinje.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Line table.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Reg. lageraktivitetslinje.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Line table.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samme som feltet med samme navn i vinduet Reg. lageraktivitetslinje.;
                           ENU=Specifies the same as the field with the same name in the Registered Whse. Activity Line table.];
                ApplicationArea=#Warehouse;
                SourceExpr="Special Equipment Code";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver afsendelsesadviset for den bogf›rte lagerflytningslinje.;
                           ENU=Specifies the shipping advice for the registered inventory movement line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Advice" }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

