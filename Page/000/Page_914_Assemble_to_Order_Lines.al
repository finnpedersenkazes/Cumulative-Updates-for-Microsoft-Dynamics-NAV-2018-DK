OBJECT Page 914 Assemble-to-Order Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Montage efter ordre-linjer;
               ENU=Assemble-to-Order Lines];
    SourceTable=Table901;
    DataCaptionExpr=GetCaption;
    DelayedInsert=Yes;
    PopulateAllFields=Yes;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnAfterGetRecord=BEGIN
                       UpdateAvailWarning;
                     END;

    OnDeleteRecord=VAR
                     AssemblyLineReserve@1000 : Codeunit 926;
                   BEGIN
                     IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
                       COMMIT;
                       IF NOT AssemblyLineReserve.DeleteLineConfirm(Rec) THEN
                         EXIT(FALSE);
                       AssemblyLineReserve.DeleteLine(Rec);
                     END;
                   END;

    ActionList=ACTIONS
    {
      { 27      ;    ;ActionContainer;
                      CaptionML=[DAN=Linje;
                                 ENU=Line];
                      ActionContainerType=ActionItems }
      { 37      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den nõdvendige mëngde pÜ den bilagslinje, som vinduet blev Übnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=LineReserve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowReservation;
                               END;
                                }
      { 26      ;1   ;Action    ;
                      CaptionML=[DAN=Vëlg erstatningsvare;
                                 ENU=Select Item Substitution];
                      ToolTipML=[DAN=Vëlg en anden vare, der er konfigureret til at blive handlet i stedet for den originale vare, hvis den ikke er tilgëngelig.;
                                 ENU=Select another item that has been set up to be traded instead of the original item if it is unavailable.];
                      ApplicationArea=#Suite;
                      Image=SelectItemSubstitution;
                      OnAction=BEGIN
                                 ShowItemSub;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Udfold stykliste;
                                 ENU=Explode BOM];
                      ToolTipML=[DAN=Indsët nye linjer for komponenterne pÜ styklisten, f.eks. for at sëlge den overordnede vare som en pakke. ADVARSEL! Linjen for den overordnede vare bliver slettet og kun reprësenteret af en beskrivelse. Hvis du vil fortryde, skal du slette komponentlinjerne og tilfõje en linje igen for den overordnede vare.;
                                 ENU=Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.];
                      ApplicationArea=#Assembly;
                      Image=ExplodeBOM;
                      OnAction=BEGIN
                                 ExplodeAssemblyList;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=Montagestykliste;
                                 ENU=Assembly BOM];
                      ToolTipML=[DAN=FÜ vist eller rediger den stykliste, der angiver, hvilke varer og ressourcer der krëves for at samle montageelementet.;
                                 ENU=View or edit the bill of material that specifies which items and resources are required to assemble the assembly item.];
                      ApplicationArea=#Assembly;
                      Image=BulletList;
                      OnAction=BEGIN
                                 ShowAssemblyList;
                               END;
                                }
      { 44      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret flytning (l&ager);
                                 ENU=Create Inventor&y Movement];
                      ToolTipML=[DAN=Opret en flytning (lager) for at hÜndtere varerne i bilaget i henhold til en grundlëggende lageropsëtning.;
                                 ENU=Create an inventory movement to handle items on the document according to a basic warehouse configuration.];
                      ApplicationArea=#Warehouse;
                      Image=CreatePutAway;
                      OnAction=VAR
                                 AssemblyHeader@1000 : Record 900;
                                 ATOMovementsCreated@1001 : Integer;
                                 TotalATOMovementsToBeCreated@1002 : Integer;
                               BEGIN
                                 AssemblyHeader.GET("Document Type","Document No.");
                                 AssemblyHeader.CreateInvtMovement(FALSE,FALSE,FALSE,ATOMovementsCreated,TotalATOMovementsToBeCreated);
                               END;
                                }
      { 45      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 36      ;1   ;Action    ;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=View;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ATOLink@1002 : Record 904;
                                 SalesLine@1000 : Record 37;
                               BEGIN
                                 ATOLink.GET("Document Type","Document No.");
                                 SalesLine.GET(ATOLink."Document Type",ATOLink."Document No.",ATOLink."Document Line No.");
                                 ATOLink.ShowAsm(SalesLine);
                               END;
                                }
      { 23      ;1   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 40      ;1   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen pÜ bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Promoted=Yes;
                      Image=ItemTrackingLines;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      ActionContainerType=NewDocumentItems;
                      Image=ItemAvailability }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilgëngelige saldo for en vare udvikler sig over tid i henhold til udbud og efterspõrgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Assembly;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller mÜned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Assembly;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Assembly;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 29      ;2   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=FÜ vist tilgëngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret pÜ tilgëngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=Bemërkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 907;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  Document No.=FIELD(Document No.),
                                  Document Line No.=FIELD(Line No.);
                      Image=ViewComments }
      { 34      ;1   ;Action    ;
                      Name=ShowWarning;
                      CaptionML=[DAN=Vis advarsel;
                                 ENU=Show Warning];
                      ToolTipML=[DAN=FÜ vist oplysninger om tilgëngelighedsproblemer.;
                                 ENU=View details about availability issues.];
                      ApplicationArea=#Assembly;
                      Image=ShowWarning;
                      OnAction=BEGIN
                                 ShowAvailabilityWarning;
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

    { 33  ;2   ;Field     ;
                DrillDown=Yes;
                ToolTipML=[DAN=Angiver Ja, hvis montagekomponenten ikke er tilgëngelig i den mëngde og med den forfaldsdato, der er angivet for montageordrelinjen.;
                           ENU=Specifies Yes if the assembly component is not available in the quantity and on the due date of the assembly order line.];
                ApplicationArea=#Assembly;
                BlankZero=Yes;
                SourceExpr="Avail. Warning";
                OnDrillDown=BEGIN
                              ShowAvailabilityWarning;
                            END;
                             }

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
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, som du vil bogfõre forbruget af montagekomponenten for.;
                           ENU=Specifies the location from which you want to post consumption of the assembly component.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
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

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der er reserveret til montageordrelinjen.;
                           ENU=Specifies how many units of the assembly component have been reserved for this assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr="Reserved Quantity" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der er bogfõrt som forbrugt under montagen.;
                           ENU=Specifies how many units of the assembly component have been posted as consumed during the assembly.];
                ApplicationArea=#Assembly;
                SourceExpr="Consumed Quantity";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der er flyttet eller plukket for montageordrelinjen.;
                           ENU=Specifies how many units of the assembly component have been moved or picked for the assembly order line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Qty. Picked";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der i õjeblikket findes pÜ pluklinjerne for lagerstedet.;
                           ENU=Specifies how many units of the assembly component are currently on warehouse pick lines.];
                ApplicationArea=#Warehouse;
                SourceExpr="Pick Qty.";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montagekomponenten skal vëre tilgëngelig for forbrug ifõlge montageordren.;
                           ENU=Specifies the date when the assembly component must be available for consumption by the assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr="Due Date";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den gennemlõbstid, der er defineret for montagekomponenten pÜ montagestyklisten.;
                           ENU=Specifies the lead-time offset that is defined for the assembly component on the assembly BOM.];
                ApplicationArea=#Assembly;
                SourceExpr="Lead-Time Offset";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, hvor montagekomponenter skal placeres fõr montage, og hvorfra de bogfõres som forbrugte.;
                           ENU=Specifies the code of the bin where assembly components must be placed prior to assembly and from where they are posted as consumed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver links mellem forretningstransaktioner, som er lavet til varen, og en lagerkonto i finansposterne for at samle belõbene for denne varetype i en gruppe.;
                           ENU=Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.];
                ApplicationArea=#Assembly;
                SourceExpr="Inventory Posting Group";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Cost";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for montageordrelinjen.;
                           ENU=Specifies the cost of the assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr="Cost Amount" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antal pr. enhed for komponentvaren pÜ montageordrelinjen.;
                           ENU=Specifies the quantity per unit of measure of the component item on the assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. per Unit of Measure";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan kostprisen pÜ ressourcen pÜ montageordrelinjen tildeles montageelementet.;
                           ENU=Specifies how the cost of the resource on the assembly order line is allocated to the assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr="Resource Usage Type" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den varepost, som dette dokument eller denne kladdelinje udlignes pÜ.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#Assembly;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette bilag eller denne kladdelinje udlignes fra.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied from.];
                ApplicationArea=#Assembly;
                SourceExpr="Appl.-from Item Entry";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      ItemAvailFormsMgt@1000 : Codeunit 353;

    LOCAL PROCEDURE GetCaption@1() : Text[250];
    VAR
      ObjTransln@1009 : Record 377;
      AsmHeader@1003 : Record 900;
      SourceTableName@1002 : Text[250];
      SourceFilter@1001 : Text[200];
      Description@1000 : Text[100];
    BEGIN
      Description := '';

      IF AsmHeader.GET("Document Type","Document No.") THEN BEGIN
        SourceTableName := ObjTransln.TranslateObject(ObjTransln."Object Type"::Table,27);
        SourceFilter := AsmHeader."Item No.";
        Description := AsmHeader.Description;
      END;
      EXIT(STRSUBSTNO('%1 %2 %3',SourceTableName,SourceFilter,Description));
    END;

    BEGIN
    END.
  }
}

