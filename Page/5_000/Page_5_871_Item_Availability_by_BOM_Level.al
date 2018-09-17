OBJECT Page 5871 Item Availability by BOM Level
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varedisponering pr. styklisteniveau;
               ENU=Item Availability by BOM Level];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5870;
    PageType=Worksheet;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 ShowTotalAvailability := TRUE;
                 IF DemandDate = 0D THEN
                   DemandDate := WORKDATE;
                 RefreshPage;
               END;

    OnAfterGetRecord=VAR
                       DummyBOMWarningLog@1000 : Record 5874;
                     BEGIN
                       IsParentExpr := NOT "Is Leaf";

                       HasWarning := NOT IsLineOk(FALSE,DummyBOMWarningLog);
                     END;

    ActionList=ACTIONS
    {
      { 35      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      Image=Item }
      { 33      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Varedisponering pr.;
                                 ENU=&Item Availability by];
                      Image=ItemAvailability }
      { 32      ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg�ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp�rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Advanced;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvail(ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 31      ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m�ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Advanced;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvail(ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 30      ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvail(ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 29      ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Advanced;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvail(ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 37      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 36      ;1   ;Action    ;
                      CaptionML=[DAN=Forrige periode;
                                 ENU=Previous Period];
                      ToolTipML=[DAN=F� vist oplysningerne baseret p� den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen f�r.;
                                 ENU=Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousRecord;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 DemandDate := CALCDATE('<-1D>',DemandDate);
                                 RefreshPage;
                               END;
                                }
      { 34      ;1   ;Action    ;
                      CaptionML=[DAN=N�ste periode;
                                 ENU=Next Period];
                      ToolTipML=[DAN=Vis oplysningerne baseret p� den n�ste periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen efter.;
                                 ENU=Show the information based on the next period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextRecord;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 DemandDate := CALCDATE('<+1D>',DemandDate);
                                 RefreshPage;
                               END;
                                }
      { 40      ;1   ;Action    ;
                      CaptionML=[DAN=Vis advarsler;
                                 ENU=Show Warnings];
                      ToolTipML=[DAN=F� vist oplysninger om flaskehalse.;
                                 ENU=View details about bottlenecks.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ErrorLog;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowWarningsForAllLines;
                               END;
                                }
      { 38      ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 39      ;1   ;Action    ;
                      CaptionML=[DAN=Vare - i stand til at overholde (tidslinje);
                                 ENU=Item - Able to Make (Timeline)];
                      ToolTipML=[DAN=F� vist fem n�gledisponeringstal over tid for den valgte overordnede vare. Tallene �ndrer sig i henhold til udbud og eftersp�rgsel og til forsyning, som er baseret p� tilg�ngelige komponenter, der kan samles eller fremstilles. Du kan bruge rapporten til at se, om du kan opfylde en salgsordre for en vare p� en bestemt dato, ved at se p� den aktuelle disponering sammen med de mulige antal, som dens komponenter kan levere, hvis en montageordre startes.;
                                 ENU=View five key availability figures over time for the selected parent item. The figures change according to expected supply and demand events and to supply that is based on available components that can be assembled or produced. You can use the report to see whether you can fulfill a sales order for an item on a specified date by looking at its current availability in combination with the potential quantities that its components can supply if an assembly order were started.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Trendscape;
                      PromotedCategory=Report;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowAbleToMakeTimeline;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 20  ;1   ;Group     ;
                CaptionML=[DAN=Indstilling;
                           ENU=Option];
                GroupType=Group }

    { 19  ;2   ;Field     ;
                CaptionML=[DAN=Varefilter;
                           ENU=Item Filter];
                ToolTipML=[DAN=Angiver den vare, du vil have vist tilg�ngelighedsoplysninger for.;
                           ENU=Specifies the item you want to show availability information for.];
                ApplicationArea=#Assembly;
                SourceExpr=ItemFilter;
                OnValidate=BEGIN
                             IsCalculated := FALSE;
                             RefreshPage;
                           END;

                OnLookup=VAR
                           Item@1001 : Record 27;
                           ItemList@1000 : Page 31;
                         BEGIN
                           ItemList.SETTABLEVIEW(Item);
                           ItemList.LOOKUPMODE := TRUE;
                           IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             ItemList.GETRECORD(Item);
                             Text := Item."No.";
                             EXIT(TRUE);
                           END;
                           EXIT(FALSE);
                         END;
                          }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Lokationsfilter;
                           ENU=Location Filter];
                ToolTipML=[DAN=Angiver den lokation, som du vil have vist varetilg�ngeligheden for.;
                           ENU=Specifies the location that you want to show item availability for.];
                ApplicationArea=#Assembly;
                SourceExpr=LocationFilter;
                OnValidate=BEGIN
                             IsCalculated := FALSE;
                             RefreshPage;
                           END;

                OnLookup=VAR
                           Location@1001 : Record 14;
                           LocationList@1000 : Page 15;
                         BEGIN
                           LocationList.SETTABLEVIEW(Location);
                           LocationList.LOOKUPMODE := TRUE;
                           IF LocationList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             LocationList.GETRECORD(Location);
                             Text := Location.Code;
                             EXIT(TRUE);
                           END;
                           EXIT(FALSE);
                         END;
                          }

    { 16  ;2   ;Field     ;
                CaptionML=[DAN=Variantfilter;
                           ENU=Variant Filter];
                ToolTipML=[DAN=Angiver den varevariant, som du vil have vist tilg�ngeligheden for.;
                           ENU=Specifies the item variant you want to show availability for.];
                ApplicationArea=#Advanced;
                SourceExpr=VariantFilter;
                OnValidate=BEGIN
                             IsCalculated := FALSE;
                             RefreshPage;
                           END;

                OnLookup=VAR
                           ItemVariant@1001 : Record 5401;
                           ItemVariants@1000 : Page 5401;
                         BEGIN
                           ItemVariant.SETFILTER("Item No.",ItemFilter);
                           ItemVariants.SETTABLEVIEW(ItemVariant);
                           ItemVariants.LOOKUPMODE := TRUE;
                           IF ItemVariants.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             ItemVariants.GETRECORD(ItemVariant);
                             Text := ItemVariant.Code;
                             EXIT(TRUE);
                           END;
                           EXIT(FALSE);
                         END;
                          }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Behovsdato;
                           ENU=Demand Date];
                ToolTipML=[DAN=Angiver den dato, hvor du muligvis vil fremstille de overordnede varer eller topvarer, der vises i vinduet Varedisponering pr. styklisteniveau.;
                           ENU=Specifies the date when you want to potentially make the parents, or top items, shown in the Item Availability by BOM Level window.];
                ApplicationArea=#Assembly;
                SourceExpr=DemandDate;
                OnValidate=BEGIN
                             IsCalculated := FALSE;
                             RefreshPage;
                           END;
                            }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Beregnet;
                           ENU=Calculated];
                ToolTipML=[DAN=Angiver, at laveste-niveau-koden for varen p� linjen er beregnet.;
                           ENU=Specifies that the low-level code of the item on the line has been calculated.];
                ApplicationArea=#Assembly;
                SourceExpr=IsCalculated;
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                CaptionML=[DAN=Vis samlet disponering;
                           ENU=Show Total Availability];
                ToolTipML=[DAN=Angiver, om vinduet Varedisponering pr. styklisteniveau viser tilg�ngeligheden for alle varer, herunder den potentielle tilg�ngelighed for overordnede varer.;
                           ENU=Specifies whether the Item Availability by BOM Level window shows availability of all items, including the potential availability of parents.];
                ApplicationArea=#Assembly;
                SourceExpr=ShowTotalAvailability;
                OnValidate=BEGIN
                             IsCalculated := FALSE;
                             RefreshPage;
                           END;
                            }

    { 2   ;1   ;Group     ;
                Name=Group;
                CaptionML=[DAN=Linjer;
                           ENU=Lines];
                IndentationColumnName=Indentation;
                ShowAsTree=Yes;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No.";
                Editable=FALSE;
                Style=Strong;
                StyleExpr=IsParentExpr }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens beskrivelse.;
                           ENU=Specifies the item's description.];
                ApplicationArea=#Assembly;
                SourceExpr=Description;
                Editable=FALSE }

    { 41  ;2   ;Field     ;
                CaptionML=[DAN=Advarsel;
                           ENU=Warning];
                ToolTipML=[DAN=Angiver, om styklistelinjen er konfigureret eller om der er dataproblemer. V�lg feltet for at �bne vinduet Styklisteadvarselslog for at f� vist en beskrivelse af problemet.;
                           ENU=Specifies if the BOM line has setup or data issues. Choose the field to open the BOM Warning Log window to see a description of the issue.];
                ApplicationArea=#Assembly;
                BlankZero=Yes;
                SourceExpr=HasWarning;
                Editable=FALSE;
                Style=Attention;
                StyleExpr=HasWarning;
                OnDrillDown=BEGIN
                              IF HasWarning THEN
                                ShowWarnings;
                            END;
                             }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken vare i styklistestrukturen, der begr�nser dig i at fremstille en st�rre m�ngde end den m�ngde, der vises i feltet Kan blive topvare.;
                           ENU=Specifies which item in the BOM structure restricts you from making a larger quantity than what is shown in the Able to Make Top Item field.];
                ApplicationArea=#Assembly;
                SourceExpr=Bottleneck;
                Editable=FALSE;
                Style=Strong;
                StyleExpr=TRUE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den variantkode, du har indtastet i feltet Variantfilter i vinduet Varedisponering pr. styklisteniveau.;
                           ENU=Specifies the variant code that you entered in the Variant Filter field in the Item Availability by BOM Level window.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten, der kr�ves for at samle eller producere �n enhed af den overordnede vare.;
                           ENU=Specifies how many units of the component are required to assemble or produce one unit of the parent.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr="Qty. per Parent";
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten, der kr�ves for at samle eller producere �n enhed af topvaren.;
                           ENU=Specifies how many units of the component are required to assemble or produce one unit of the top item.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr="Qty. per Top Item";
                Visible=FALSE;
                Editable=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens genbestillingssystem.;
                           ENU=Specifies the item's replenishment system.];
                ApplicationArea=#Assembly;
                SourceExpr="Replenishment System";
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen p� linjen der er tilg�ngelige, uanset hvor mange overordnede varer, du kan fremstille med varen.;
                           ENU=Specifies how many units of the item on the line are available, regardless of how many parents you can make with the item.];
                ApplicationArea=#Assembly;
                BlankZero=Yes;
                SourceExpr="Available Quantity";
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den del af varens samlede tilg�ngelighed, der ikke kr�ves for at fremstille de antal, der er vist i felterne.;
                           ENU=Specifies the part of the item's total availability that is not required to make the quantities that are shown in the fields.];
                ApplicationArea=#Advanced;
                SourceExpr="Unused Quantity";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r varen skal v�re tilg�ngelig for at fremstille den overordnede vare eller topvaren.;
                           ENU=Specifies when the item must be available to make the parent or top item.];
                ApplicationArea=#Assembly;
                SourceExpr="Needed by Date";
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af styklistevaren p� linjen ovenfor, som kan skjules, der kan samles eller fremstilles.;
                           ENU=Specifies how many units of the BOM item on the collapsible line above it can be assembled or produced.];
                ApplicationArea=#Assembly;
                BlankZero=Yes;
                SourceExpr="Able to Make Parent";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af styklistevaren p� den �verste linje der kan samles eller fremstilles.;
                           ENU=Specifies how many units of the BOM item on the top line can be assembled or produced.];
                ApplicationArea=#Assembly;
                BlankZero=Yes;
                SourceExpr="Able to Make Top Item";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede behov for varen.;
                           ENU=Specifies the total demand for the item.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Gross Requirement";
                Visible=FALSE;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der er indg�ende p� ordrer.;
                           ENU=Specifies how many units of the item are inbound on orders.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Scheduled Receipts";
                Visible=FALSE;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhver sikkerhedstid, der er defineret for varen.;
                           ENU=Specifies any safety lead time that is defined for the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Safety Lead Time";
                Visible=FALSE;
                Editable=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den akkumulerede leveringstid for komponenter under en overordnet vare.;
                           ENU=Specifies the cumulative lead time of components under a parent item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Rolled-up Lead-Time Offset";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      Item@1004 : Record 27;
      AsmHeader@1009 : Record 900;
      ProdOrderLine@1002 : Record 5406;
      ItemAvailFormsMgt@1011 : Codeunit 353;
      IsParentExpr@1010 : Boolean INDATASET;
      ItemFilter@1008 : Code[250];
      LocationFilter@1007 : Code[250];
      VariantFilter@1006 : Code[250];
      DemandDate@1003 : Date;
      IsCalculated@1000 : Boolean;
      ShowTotalAvailability@1001 : Boolean;
      ShowBy@1005 : 'Item,Assembly,Production';
      Text000@1012 : TextConst 'DAN=Der blev ikke fundet varer med styklisteniveauer.;ENU=Could not find items with BOM levels.';
      Text001@1013 : TextConst 'DAN=Der er ingen advarsler.;ENU=There are no warnings.';
      HasWarning@1014 : Boolean INDATASET;

    [External]
    PROCEDURE InitItem@1(VAR NewItem@1000 : Record 27);
    BEGIN
      Item.COPY(NewItem);
      ItemFilter := Item."No.";
      VariantFilter := Item.GETFILTER("Variant Filter");
      LocationFilter := Item.GETFILTER("Location Filter");
      ShowBy := ShowBy::Item;
    END;

    [External]
    PROCEDURE InitAsmOrder@5(NewAsmHeader@1000 : Record 900);
    BEGIN
      AsmHeader := NewAsmHeader;
      ShowBy := ShowBy::Assembly;
    END;

    [External]
    PROCEDURE InitProdOrder@6(NewProdOrderLine@1000 : Record 5406);
    BEGIN
      ProdOrderLine := NewProdOrderLine;
      ShowBy := ShowBy::Production;
    END;

    [External]
    PROCEDURE InitDate@4(NewDemandDate@1000 : Date);
    BEGIN
      DemandDate := NewDemandDate;
    END;

    LOCAL PROCEDURE RefreshPage@2();
    VAR
      CalcBOMTree@1000 : Codeunit 5870;
    BEGIN
      Item.SETRANGE("Date Filter",0D,DemandDate);
      Item.SETFILTER("Location Filter",LocationFilter);
      Item.SETFILTER("Variant Filter",VariantFilter);
      Item.SETFILTER("No.",ItemFilter);
      CalcBOMTree.SetItemFilter(Item);

      CalcBOMTree.SetShowTotalAvailability(ShowTotalAvailability);
      CASE ShowBy OF
        ShowBy::Item:
          BEGIN
            Item.FINDFIRST;
            IF NOT Item.HasBOM THEN
              ERROR(Text000);
            CalcBOMTree.GenerateTreeForItems(Item,Rec,1);
          END;
        ShowBy::Production:
          BEGIN
            ProdOrderLine."Due Date" := DemandDate;
            CalcBOMTree.GenerateTreeForProdLine(ProdOrderLine,Rec,1);
          END;
        ShowBy::Assembly:
          BEGIN
            AsmHeader."Due Date" := DemandDate;
            CalcBOMTree.GenerateTreeForAsm(AsmHeader,Rec,1);
          END;
      END;

      CurrPage.UPDATE(FALSE);
      IsCalculated := TRUE;
    END;

    [External]
    PROCEDURE GetSelectedDate@3() : Date;
    BEGIN
      EXIT(DemandDate);
    END;

    LOCAL PROCEDURE ItemAvail@7(AvailType@1000 : Option);
    VAR
      Item@1001 : Record 27;
    BEGIN
      TESTFIELD(Type,Type::Item);

      Item.GET("No.");
      Item.SETFILTER("No.","No.");
      Item.SETRANGE("Date Filter",0D,"Needed by Date");
      Item.SETFILTER("Location Filter",LocationFilter);
      Item.SETFILTER("Variant Filter","Variant Code");
      IF ShowBy <> ShowBy::Item THEN
        Item.SETFILTER("Location Filter","Location Code");
      IF Indentation = 0 THEN
        Item.SETFILTER("Variant Filter",VariantFilter);

      ItemAvailFormsMgt.ShowItemAvailFromItem(Item,AvailType);
    END;

    LOCAL PROCEDURE ShowAbleToMakeTimeline@8();
    VAR
      Item@1001 : Record 27;
      ItemAbleToMakeTimeline@1002 : Report 5871;
    BEGIN
      TESTFIELD(Type,Type::Item);

      Item.GET("No.");
      Item.SETFILTER("No.","No.");

      WITH ItemAbleToMakeTimeline DO BEGIN
        IF Indentation = 0 THEN BEGIN
          CASE ShowBy OF
            ShowBy::Item:
              BEGIN
                Item.SETFILTER("Location Filter",LocationFilter);
                Item.SETFILTER("Variant Filter",VariantFilter);
              END;
            ShowBy::Assembly:
              InitAsmOrder(AsmHeader);
            ShowBy::Production:
              InitProdOrder(ProdOrderLine);
          END;
        END ELSE BEGIN
          Item.SETFILTER("Location Filter",LocationFilter);
          Item.SETFILTER("Variant Filter",VariantFilter);
        END;

        SETTABLEVIEW(Item);
        Initialize("Needed by Date",0,7,TRUE);
        RUN;
      END;
    END;

    LOCAL PROCEDURE ShowWarnings@10();
    VAR
      TempBOMWarningLog@1001 : TEMPORARY Record 5874;
    BEGIN
      IF IsLineOk(TRUE,TempBOMWarningLog) THEN
        MESSAGE(Text001)
      ELSE
        PAGE.RUNMODAL(PAGE::"BOM Warning Log",TempBOMWarningLog);
    END;

    LOCAL PROCEDURE ShowWarningsForAllLines@27();
    VAR
      TempBOMWarningLog@1001 : TEMPORARY Record 5874;
    BEGIN
      IF AreAllLinesOk(TempBOMWarningLog) THEN
        MESSAGE(Text001)
      ELSE
        PAGE.RUNMODAL(PAGE::"BOM Warning Log",TempBOMWarningLog);
    END;

    BEGIN
    END.
  }
}

