OBJECT Page 5785 Warehouse Activity Lines
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
    CaptionML=[DAN=Lageraktivitetslinjer;
               ENU=Warehouse Activity Lines];
    SourceTable=Table5767;
    PageType=List;
    OnAfterGetCurrRecord=BEGIN
                           CurrPage.CAPTION := FormCaption;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 77      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 24      ;2   ;Action    ;
                      Name=Card;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=EditLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowActivityDoc;
                               END;
                                }
      { 78      ;2   ;Action    ;
                      CaptionML=[DAN=&Vis lagerdokument;
                                 ENU=Show &Whse. Document];
                      ToolTipML=[DAN=Vis det relaterede lagerbilag.;
                                 ENU=View the related warehouse document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=ViewOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowWhseDoc;
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
                ToolTipML=[DAN=Angiver handlingstypen for lageraktivitetslinjen.;
                           ENU=Specifies the action type for the warehouse activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Action Type";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen af lageraktivitet for linjen.;
                           ENU=Specifies the type of warehouse activity for the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Activity Type";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† lageraktivitetslinjen.;
                           ENU=Specifies the number of the warehouse activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Line No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type kildedokument, som lageraktivitetslinjen vedr›rer, f.eks. salg, k›b eller produktion.;
                           ENU=Specifies the type of source document to which the warehouse activity line relates, such as sales, purchase, and production.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Type";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kildeundertypen for det dokument, som vedr›rer lageranmodningen.;
                           ENU=Specifies the source subtype of the document related to the warehouse request.];
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
                ToolTipML=[DAN=Angiver kildeunderlinjenummeret.;
                           ENU=Specifies the source subline number.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Subline No.";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor aktiviteten forekommer.;
                           ENU=Specifies the code for the location where the activity occurs.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor placeringen p† linjen findes.;
                           ENU=Specifies the zone code where the bin on this line is located.];
                ApplicationArea=#Warehouse;
                SourceExpr="Zone Code";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hyldenummeret for varen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item for informational use.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shelf No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varenummeret p† den vare, som skal h†ndteres, f.eks. plukkes eller l‘gges p† lager.;
                           ENU=Specifies the item number of the item to be handled, such as picked or put away.];
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
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure Code" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet pr. enhed for varen p† linjen.;
                           ENU=Specifies the quantity per unit of measure of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Qty. per Unit of Measure" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p† linjen.;
                           ENU=Specifies a description of the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p† linjen.;
                           ENU=Specifies a description of the item on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, som skal h†ndteres, f.eks. modtages, l‘gges p† lager eller tildeles.;
                           ENU=Specifies the quantity of the item to be handled, such as received, put-away, or assigned.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, der skal h†ndteres, anf›rt i basisenheder.;
                           ENU=Specifies the quantity of the item to be handled, in the base unit of measure.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet varer, som endnu ikke er blevet h†ndteret for lageraktivitetslinjen.;
                           ENU=Specifies the number of items that have not yet been handled for this warehouse activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varer, anf›rt i basisenheder, som endnu ikke er blevet h†ndteret for lageraktivitetslinjen.;
                           ENU=Specifies the number of items, expressed in the base unit of measure, that have not yet been handled for this warehouse activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Outstanding (Base)" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder der skal h†ndteres i denne lageraktivitet.;
                           ENU=Specifies how many units to handle in this warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Handle" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varer, som skal h†ndteres i forbindelse med lageraktiviteten.;
                           ENU=Specifies the quantity of items to be handled in this warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. to Handle (Base)" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet varer p† linjen, som endnu ikke er blevet h†ndteret i forbindelse med lageraktiviteten.;
                           ENU=Specifies the number of items on the line that have been handled in this warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Handled" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet varer p† linjen, som endnu ikke er blevet h†ndteret i forbindelse med lageraktiviteten.;
                           ENU=Specifies the number of items on the line that have been handled in this warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Handled (Base)" }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det udstyr, der kr‘ves, n†r du udf›rer handlingen p† linjen.;
                           ENU=Specifies the code of the equipment required when you perform the action on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Special Equipment Code";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver afsendelsesadviset, som indeholder oplysninger om, hvorvidt delleverancer er acceptable.;
                           ENU=Specifies the shipping advice, which informs whether partial deliveries are acceptable.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Advice" }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lagerdokumenttype, som linjen stammer fra.;
                           ENU=Specifies the type of warehouse document from which the line originated.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document Type";
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det lagerdokument, som danner grundlag for handlingen p† linjen.;
                           ENU=Specifies the number of the warehouse document that is the basis for the action on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document No.";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den linje i lagerdokumentet, som danner grundlag for handlingen p† linjen.;
                           ENU=Specifies the number of the line in the warehouse document that is the basis for the action on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Document Line No.";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

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
      Text000@1001 : TextConst 'DAN=L‘g-p†-lager-linjer (log.);ENU=Warehouse Put-away Lines';
      Text001@1000 : TextConst 'DAN=Pluklinjer (logistik);ENU=Warehouse Pick Lines';
      Text002@1002 : TextConst 'DAN=Bev.linjer (logistik);ENU=Warehouse Movement Lines';
      Text003@1003 : TextConst 'DAN=Lageraktivitetslinjer;ENU=Warehouse Activity Lines';
      Text004@1004 : TextConst 'DAN=L‘g-p†-lager-linjer (lager);ENU=Inventory Put-away Lines';
      Text005@1005 : TextConst 'DAN=Pluklinjer (lager);ENU=Inventory Pick Lines';

    LOCAL PROCEDURE FormCaption@1() : Text[250];
    BEGIN
      CASE "Activity Type" OF
        "Activity Type"::"Put-away":
          EXIT(Text000);
        "Activity Type"::Pick:
          EXIT(Text001);
        "Activity Type"::Movement:
          EXIT(Text002);
        "Activity Type"::"Invt. Put-away":
          EXIT(Text004);
        "Activity Type"::"Invt. Pick":
          EXIT(Text005);
        ELSE
          EXIT(Text003);
      END;
    END;

    BEGIN
    END.
  }
}

