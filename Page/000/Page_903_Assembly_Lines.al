OBJECT Page 903 Assembly Lines
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
    CaptionML=[DAN=Montagelinjer;
               ENU=Assembly Lines];
    SourceTable=Table901;
    PopulateAllFields=Yes;
    PageType=List;
    AutoSplitKey=Yes;
    ActionList=ACTIONS
    {
      { 19      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 16      ;1   ;ActionGroup;
                      Name=Line;
                      CaptionML=[DAN=Linje;
                                 ENU=Line];
                      Image=Line }
      { 4       ;2   ;Action    ;
                      Name=Show Document;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vi&s bilag;
                                 ENU=&Show Document];
                      ToolTipML=[DAN=èbn det bilag, som oplysningerne pÜ linjen stammer fra.;
                                 ENU=Open the document that the information on the line comes from.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=View;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 AssemblyHeader@1001 : Record 900;
                               BEGIN
                                 AssemblyHeader.GET("Document Type","Document No.");
                                 PAGE.RUN(PAGE::"Assembly Order",AssemblyHeader);
                               END;
                                }
      { 23      ;2   ;Action    ;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=Reservationsposter;
                                 ENU=Reservation Entries];
                      ToolTipML=[DAN=Vis posterne for hver reservation, der er foretaget, enten manuelt eller automatisk.;
                                 ENU=View the entries for every reservation that is made, either manually or automatically.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReservationLedger;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowReservationEntries(TRUE);
                               END;
                                }
      { 22      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen pÜ bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ItemTrackingLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den montagedokumenttype, som montageordrehovedet reprësenterer i ordremontagescenerier.;
                           ENU=Specifies the type of assembly document that the assembly order header represents in assemble-to-order scenarios.];
                ApplicationArea=#Assembly;
                SourceExpr="Document Type" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ montageordrehovedet, som montageordrelinjen refererer til.;
                           ENU=Specifies the number of the assembly order header that the assembly order line refers to.];
                ApplicationArea=#Assembly;
                SourceExpr="Document No." }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om montageordrelinjen er af typen Vare eller Ressource.;
                           ENU=Specifies if the assembly order line is of type Item or Resource.];
                ApplicationArea=#Assembly;
                SourceExpr=Type }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Variant Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af montagekomponenten.;
                           ENU=Specifies the description of the assembly component.];
                ApplicationArea=#Assembly;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den anden beskrivelse af montagekomponenten.;
                           ENU=Specifies the second description of the assembly component.];
                ApplicationArea=#Assembly;
                SourceExpr="Description 2";
                Visible=False }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, som du vil bogfõre forbruget af montagekomponenten for.;
                           ENU=Specifies the location from which you want to post consumption of the assembly component.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, hvor montagekomponenter skal placeres fõr montage, og hvorfra de bogfõres som forbrugte.;
                           ENU=Specifies the code of the bin where assembly components must be placed prior to assembly and from where they are posted as consumed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten, der krëves for at samle et montageelement.;
                           ENU=Specifies how many units of the assembly component are required to assemble one assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr="Quantity per" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der forventes at blive forbrugt.;
                           ENU=Specifies how many units of the assembly component are expected to be consumed.];
                ApplicationArea=#Assembly;
                SourceExpr=Quantity }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der er bogfõrt som forbrugt under montagen.;
                           ENU=Specifies how many units of the assembly component have been posted as consumed during the assembly.];
                ApplicationArea=#Assembly;
                SourceExpr="Consumed Quantity" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der mangler at blive brugt under montagen.;
                           ENU=Specifies how many units of the assembly component remain to be consumed during assembly.];
                ApplicationArea=#Assembly;
                SourceExpr="Remaining Quantity" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montagekomponenten skal vëre tilgëngelig for forbrug ifõlge montageordren.;
                           ENU=Specifies the date when the assembly component must be available for consumption by the assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr="Due Date";
                Visible=False }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der er reserveret til montageordrelinjen.;
                           ENU=Specifies how many units of the assembly component have been reserved for this assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr="Reserved Quantity" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antal pr. enhed for komponentvaren pÜ montageordrelinjen.;
                           ENU=Specifies the quantity per unit of measure of the component item on the assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. per Unit of Measure" }

    { 10  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 9   ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 7   ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

