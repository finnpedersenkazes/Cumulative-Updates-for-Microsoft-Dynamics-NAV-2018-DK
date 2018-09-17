OBJECT Page 7364 Registered Whse. Act.-Lines
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
    CaptionML=[DAN=Registrerede lagerakt.linjer;
               ENU=Registered Whse. Act.-Lines];
    SourceTable=Table5773;
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
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis registreret dokument;
                                 ENU=Show Registered Document];
                      ToolTipML=[DAN=Vis det relaterede fuldf›rte lagerbilag.;
                                 ENU=View the related completed warehouse document.];
                      ApplicationArea=#Warehouse;
                      Image=ViewRegisteredOrder;
                      OnAction=BEGIN
                                 ShowRegisteredActivityDoc;
                               END;
                                }
      { 78      ;2   ;Action    ;
                      CaptionML=[DAN=Vi&s lagerdokument;
                                 ENU=Show &Whse. Document];
                      ToolTipML=[DAN=Vis det relaterede lagerbilag.;
                                 ENU=View the related warehouse document.];
                      ApplicationArea=#Warehouse;
                      Image=ViewOrder;
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
                ToolTipML=[DAN=Angiver, hvilken handling du skal udf›re i forbindelse med varerne p† linjen.;
                           ENU=Specifies the action you must perform for the items on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Action Type";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type aktivitet, eksempelvis l‘g-p†-lager, pluk eller bev‘gelse, som lagerstedet udf›rte for linjen.;
                           ENU=Specifies the type of activity that the warehouse performed on the line, such as put-away, pick, or movement.];
                ApplicationArea=#Warehouse;
                SourceExpr="Activity Type";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den registrerede lageraktivitetslinje.;
                           ENU=Specifies the number of the registered warehouse activity line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Line No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den transaktionstype, som kildedokumentet er tilknyttet, f.eks. salg, k›b eller produktion.;
                           ENU=Specifies the type of transaction the source document is associated with, such as sales, purchase, and production.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Type";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kildeundertypen for det dokument, som vedr›rer den registrerede aktivitetslinje.;
                           ENU=Specifies the source subtype of the document related to the registered activity line.];
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
                ToolTipML=[DAN=Angiver nummeret p† den kildedokumentunderlinje, som vedr›rer aktivitetslinjen.;
                           ENU=Specifies the number of the source document subline related to this activity line.];
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
                           ENU=Specifies the code for the location at which the activity occurs.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den zone, hvor placeringen p† linjen findes.;
                           ENU=Specifies the code of the zone in which the bin on this line is located.];
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
                ToolTipML=[DAN=Angiver hyldenummeret for varen p† linjen til brugerens orientering.;
                           ENU=Specifies the shelf number of the item on the line for information use.];
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
                ApplicationArea=#Warehouse;
                SourceExpr="Unit of Measure Code" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet pr. enhed for varen p† linjen.;
                           ENU=Specifies the quantity per unit of measure of the item on the line.];
                ApplicationArea=#Warehouse;
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
                ToolTipML=[DAN=Angiver det antal varer, som blev lagt p† lager, plukket eller overflyttet.;
                           ENU=Specifies the quantity of the item that was put-away, picked or moved.];
                ApplicationArea=#Warehouse;
                SourceExpr=Quantity }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, som blev lagt p† lager, plukket eller overflyttet.;
                           ENU=Specifies the quantity of the item that was put-away, picked or moved.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. (Base)";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det udstyr, der kr‘ves, n†r du udf›rer handlingen p† linjen.;
                           ENU=Specifies the code of the equipment required when you perform the action on the line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Special Equipment Code";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver afsendelsesadviset om, hvorvidt en delleverance er acceptabel for ordremodtageren.;
                           ENU=Specifies the shipping advice about whether a partial delivery was acceptable to the order recipient.];
                ApplicationArea=#Warehouse;
                SourceExpr="Shipping Advice" }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lageraktiviteten skal v‘re afsluttet.;
                           ENU=Specifies the date when the warehouse activity must be completed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Due Date" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dokumenttype, som linjen stammer fra.;
                           ENU=Specifies the type of document that the line originated from.];
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
      Text000@1001 : TextConst 'DAN=Reg. l‘g-p†-lager-linjer (log.);ENU=Registered Whse. Put-away Lines';
      Text001@1000 : TextConst 'DAN=Reg. pluklinjer (logistik);ENU=Registered Whse. Pick Lines';
      Text002@1002 : TextConst 'DAN=Reg. bev‘gelseslinjer (logistik);ENU=Registered Whse. Movement Lines';
      Text003@1003 : TextConst 'DAN=Registrerede lageraktivitetslinjer;ENU=Registered Whse. Activity Lines';

    LOCAL PROCEDURE FormCaption@1() : Text[250];
    BEGIN
      CASE "Activity Type" OF
        "Activity Type"::"Put-away":
          EXIT(Text000);
        "Activity Type"::Pick:
          EXIT(Text001);
        "Activity Type"::Movement:
          EXIT(Text002);
        ELSE
          EXIT(Text003);
      END;
    END;

    BEGIN
    END.
  }
}

