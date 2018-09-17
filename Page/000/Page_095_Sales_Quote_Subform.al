OBJECT Page 95 Sales Quote Subform
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table37;
    DelayedInsert=Yes;
    SourceTableView=WHERE(Document Type=FILTER(Quote));
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInit=VAR
             ApplicationAreaSetup@1001 : Record 9178;
           BEGIN
             SalesSetup.GET;
             Currency.InitRoundingPrecision;
             TempOptionLookupBuffer.FillBuffer(TempOptionLookupBuffer."Lookup Type"::Sales);
             IsFoundation := ApplicationAreaSetup.IsFoundationEnabled;
           END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                       UpdateTypeText;
                       SetItemChargeFieldsStyle;
                     END;

    OnNewRecord=VAR
                  ApplicationAreaSetup@1001 : Record 9178;
                BEGIN
                  InitType;
                  IF ApplicationAreaSetup.IsFoundationEnabled THEN
                    IF xRec."Document No." = '' THEN
                      Type := Type::Item;

                  CLEAR(ShortcutDimCode);
                  UpdateTypeText;
                END;

    OnDeleteRecord=VAR
                     ReserveSalesLine@1000 : Codeunit 99000832;
                   BEGIN
                     IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
                       COMMIT;
                       IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
                         EXIT(FALSE);
                       ReserveSalesLine.DeleteLine(Rec);
                     END;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           CalculateTotals;
                           UpdateEditableOnRow;
                           UpdateTypeText;
                           SetItemChargeFieldsStyle;
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 17      ;1   ;Action    ;
                      Name=InsertExtTexts;
                      AccessByPermission=TableData 279=R;
                      CaptionML=[DAN=&Inds‘t udv. tekster;
                                 ENU=Insert &Ext. Texts];
                      ToolTipML=[DAN=Inds‘t den forl‘ngede varebeskrivelse, som h›rer til varen, der behandles p† linjen.;
                                 ENU=Insert the extended item description that is set up for the item that is being processed on the line.];
                      ApplicationArea=#Suite;
                      Image=Text;
                      OnAction=BEGIN
                                 InsertExtendedText(TRUE);
                               END;
                                }
      { 1907075804;1 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1901743104;2 ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikles over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 1907981204;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder, f.eks. dag, uge eller m†ned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByPeriod)
                               END;
                                }
      { 1903587104;3 ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByVariant)
                               END;
                                }
      { 1903134404;3 ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByLocation)
                               END;
                                }
      { 26      ;3   ;Action    ;
                      AccessByPermission=TableData 5870=R;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByBOM)
                               END;
                                }
      { 1901092104;2 ;Action    ;
                      CaptionML=[DAN=V‘lg erstatningsvare;
                                 ENU=Select Item Substitution];
                      ToolTipML=[DAN=V‘lg en anden vare, der er blevet konfigureret til at blive solgt i stedet for den originale vare, hvis den ikke er tilg‘ngelig.;
                                 ENU=Select another item that has been set up to be sold instead of the original item if it is unavailable.];
                      ApplicationArea=#Suite;
                      Image=SelectItemSubstitution;
                      OnAction=BEGIN
                                 ShowItemSub;
                               END;
                                }
      { 1902027204;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      Image=ViewComments;
                      OnAction=BEGIN
                                 ShowLineComments;
                               END;
                                }
      { 1907184504;2 ;Action    ;
                      AccessByPermission=TableData 5800=R;
                      CaptionML=[DAN=Varege&byrtildeling;
                                 ENU=Item Charge &Assignment];
                      ToolTipML=[DAN=Tildel ekstra direkte omkostninger, f.eks. for fragt, p† varen p† linjen.;
                                 ENU=Assign additional direct costs, for example for freight, to the item on the line.];
                      ApplicationArea=#ItemCharges;
                      Image=ItemCosts;
                      OnAction=BEGIN
                                 ItemChargeAssgnt;
                                 SetItemChargeFieldsStyle;
                               END;
                                }
      { 1905987604;2 ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=VAR
                                 Item@1001 : Record 27;
                               BEGIN
                                 Item.GET("No.");
                                 Item.TESTFIELD("Assembly Policy",Item."Assembly Policy"::"Assemble-to-Stock");
                                 TESTFIELD("Qty. to Asm. to Order (Base)",0);
                                 OpenItemTrackingLines;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      AccessByPermission=TableData 5718=R;
                      CaptionML=[DAN=V‘lg &katalogvarer;
                                 ENU=Select Nonstoc&k Items];
                      ToolTipML=[DAN="F† vist listen over eksisterende katalogvarer i systemet. ";
                                 ENU="View the list of nonstock items that exist in the system. "];
                      ApplicationArea=#Basic,#Suite;
                      Image=NonStockItem;
                      OnAction=BEGIN
                                 ShowNonstockItems;
                               END;
                                }
      { 15      ;2   ;ActionGroup;
                      CaptionML=[DAN=Montage til ordre;
                                 ENU=Assemble to Order];
                      ActionContainerType=NewDocumentItems;
                      Image=AssemblyBOM }
      { 3       ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=Montage til ordre-linjer;
                                 ENU=Assemble-to-Order Lines];
                      ToolTipML=[DAN=Vis eventuelle tilknyttede montageordrelinjer, hvis bilagene repr‘senterer et ordremontagesalg.;
                                 ENU=View any linked assembly order lines if the documents represents an assemble-to-order sale.];
                      ApplicationArea=#Assembly;
                      OnAction=BEGIN
                                 ShowAsmToOrderLines;
                               END;
                                }
      { 9       ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Akkumuleret &pris;
                                 ENU=Roll Up &Price];
                      ToolTipML=[DAN=Opdater enhedsprisen for montageelementet i overensstemmelse med de ‘ndringer, du har foretaget i montagekomponenterne.;
                                 ENU=Update the unit price of the assembly item according to any changes that you have made to the assembly components.];
                      ApplicationArea=#Assembly;
                      OnAction=BEGIN
                                 RollupAsmPrice;
                               END;
                                }
      { 7       ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Akkum. &varekostpris;
                                 ENU=Roll Up &Cost];
                      ToolTipML=[DAN=Opdater kostprisen for montageelementet i overensstemmelse med de ‘ndringer, du har foretaget i montagekomponenterne.;
                                 ENU=Update the unit cost of the assembly item according to any changes that you have made to the assembly components.];
                      ApplicationArea=#Assembly;
                      OnAction=BEGIN
                                 RollUpAsmCost;
                               END;
                                }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 23      ;2   ;Action    ;
                      AccessByPermission=TableData 7002=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent pris;
                                 ENU=Get &Price];
                      ToolTipML=[DAN=Inds‘t den laveste mulige pris i feltet Enhedspris i henhold til enhver specialpris, du har angivet.;
                                 ENU=Insert the lowest possible price in the Unit Price field according to any special price that you have set up.];
                      ApplicationArea=#Advanced;
                      Image=Price;
                      OnAction=BEGIN
                                 ShowPrices
                               END;
                                }
      { 21      ;2   ;Action    ;
                      AccessByPermission=TableData 7004=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=H&ent linjerabat;
                                 ENU=Get Li&ne Discount];
                      ToolTipML=[DAN=Inds‘t den bedste mulige rabat i feltet Linjerabat i henhold til enhver specialrabat, du har angivet.;
                                 ENU=Insert the best possible discount in the Line Discount field according to any special discounts that you have set up.];
                      ApplicationArea=#Advanced;
                      Image=LineDiscount;
                      OnAction=BEGIN
                                 ShowLineDisc
                               END;
                                }
      { 19      ;2   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=U&dfold stykliste;
                                 ENU=E&xplode BOM];
                      ToolTipML=[DAN=Inds‘t nye linjer for komponenterne p† styklisten, f.eks. for at s‘lge den overordnede vare som en pakke. ADVARSEL! Linjen for den overordnede vare bliver slettet og kun repr‘senteret af en beskrivelse. Hvis du vil fortryde, skal du slette komponentlinjerne og tilf›je en linje igen for den overordnede vare.;
                                 ENU=Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.];
                      ApplicationArea=#Suite;
                      Image=ExplodeBOM;
                      OnAction=BEGIN
                                 ExplodeBOM;
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
                ToolTipML=[DAN=Angiver typen af objekt, der skal bogf›res for denne salgslinje, f.eks vare, ressource eller finanskonto.;
                           ENU=Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.];
                ApplicationArea=#Advanced;
                SourceExpr=Type;
                OnValidate=BEGIN
                             NoOnAfterValidate;

                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                             UpdateEditableOnRow;
                             UpdateTypeText;
                           END;
                            }

    { 41  ;2   ;Field     ;
                Name=FilteredTypeField;
                CaptionML=[DAN=Type;
                           ENU=Type];
                ToolTipML=[DAN=Angiver typen af objekt, der skal bogf›res for denne salgslinje, f.eks. vare eller finanskonto.;
                           ENU=Specifies the type of entity that will be posted for this sales line, such as Item,, or G/L Account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TypeAsText;
                TableRelation="Option Lookup Buffer"."Option Caption" WHERE (Lookup Type=CONST(Sales));
                Visible=IsFoundation;
                LookupPageID=Option Lookup List;
                OnValidate=BEGIN
                             IF TempOptionLookupBuffer.AutoCompleteOption(TypeAsText,TempOptionLookupBuffer."Lookup Type"::Sales) THEN
                               VALIDATE(Type,TempOptionLookupBuffer.ID);
                             TempOptionLookupBuffer.ValidateOption(TypeAsText);
                             UpdateEditableOnRow;
                             UpdateTypeText;
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† en finanskonto, vare, ressource, ekstra omkostning eller anl‘gsaktiv, afh‘ngigt af hvad du har valgt i feltet Type.;
                           ENU=Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No.";
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                             NoOnAfterValidate;

                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;

                             UpdateEditableOnRow;
                             UpdateTypeText;
                           END;

                ShowMandatory=NOT IsCommentLine }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dine og din kreditors og debitors varenummer, vil dette nummer tilsides‘tte standardvarenummeret, n†r du angiver krydsreferencenummeret p† et salgs- eller k›bsbilag.;
                           ENU=Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor's or customer's item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cross-Reference No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             CrossReferenceNoOnAfterValidat;
                             NoOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           CrossReferenceNoLookUp;
                           InsertExtendedText(FALSE);
                           NoOnAfterValidate;
                         END;
                          }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE;
                OnValidate=BEGIN
                             VariantCodeOnAfterValidate
                           END;
                            }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der findes en erstatning for varen p† salgslinjen.;
                           ENU=Specifies that a substitute is available for the item on the sales line.];
                ApplicationArea=#Suite;
                SourceExpr="Substitution Available";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen ikke er en lagervare.;
                           ENU=Specifies that this item is a nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsproduktbogf›ringsgruppen. Knytter forretningstransaktioner for varen, ressourcen eller finanskontoen til finansregnskabet for at g›re rede for momsbel›bet som f›lge af handlen med den p†g‘ldende record.;
                           ENU=Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten for det produkt, der skal s‘lges. Hvis du vil tilf›je en ikke-transaktionsbaseret tekstlinje, skal du kun udfylde feltet Beskrivelse.;
                           ENU=Specifies a description of the entry of the product to be sold. To add a non-transactional text line, fill in the Description field only.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                OnValidate=BEGIN
                             UpdateEditableOnRow;

                             IF "No." = xRec."No." THEN
                               EXIT;

                             ShowShortcutDimCode(ShortcutDimCode);
                             NoOnAfterValidate;

                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;

                             UpdateTypeText;
                           END;

                ShowMandatory=NOT IsCommentLine }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken lagerlokation de solgte varer skal tages fra, og hvor lagerreduktionen registreres.;
                           ENU=Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             LocationCodeOnAfterValidate;
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder der s‘lges.;
                           ENU=Specifies how many units are being sold.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=Quantity;
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             QuantityOnAfterValidate;
                             RedistributeTotalsOnAfterValidate;
                           END;

                ShowMandatory=(NOT IsCommentLine) AND ("No." <> '') }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af salgslinjeantallet, som du vil forsyne via montage.;
                           ENU=Specifies how many units of the sales line quantity that you want to supply by assembly.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. to Assemble to Order";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                StyleExpr=ItemChargeStyleExpression;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             CurrPage.UPDATE(TRUE);
                           END;

                OnDrillDown=BEGIN
                              ShowAsmToOrderLines;
                            END;
                             }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code";
                Enabled=UnitofMeasureCodeIsChangeable;
                Editable=UnitofMeasureCodeIsChangeable;
                OnValidate=BEGIN
                             UnitofMeasureCodeOnAfterValida;
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver m†leenheden for varen eller ressourcen p† salgslinjen.;
                           ENU=Specifies the unit of measure for the item or resource on the sales line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens enhedspris p† kladdelinjen.;
                           ENU=Specifies the unit cost of the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                CaptionML=[DAN=Salgspris findes;
                           ENU=Sales Price Exists];
                ToolTipML=[DAN=Angiver, at der er en pris, der er specifik for denne debitor.;
                           ENU=Specifies that there is a specific price for this customer.];
                ApplicationArea=#Advanced;
                SourceExpr=PriceExists;
                Visible=FALSE;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver pris for en enhed p† salgslinjen.;
                           ENU=Specifies the price for one unit on the sales line.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Unit Price";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;

                ShowMandatory=(NOT IsCommentLine) AND ("No." <> '') }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p† linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Line Discount %";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobel›b uden eventuelt fakturarabatbel›b, som skal betales for produkterne p† linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Line Amount";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;

                ShowMandatory=(NOT IsCommentLine) AND ("No." <> '') }

    { 60  ;2   ;Field     ;
                CaptionML=[DAN=Salgslinjerabat findes;
                           ENU=Sales Line Disc. Exists];
                ToolTipML=[DAN=Angiver, at der er en rabat, der er specifik for denne debitor.;
                           ENU=Specifies that there is a specific discount for this customer.];
                ApplicationArea=#Advanced;
                SourceExpr=LineDiscExists;
                Visible=FALSE;
                Editable=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel›b, der ydes p† varen, p† linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Line Discount Amount";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, n†r fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
                             InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * InvoiceDiscountPct / 100,Currency."Amount Rounding Precision");
                             ValidateInvoiceDiscountAmount;
                           END;
                            }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fakturarabatbel›bet for hele linjen.;
                           ENU=Specifies the invoice discount amount for the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE;
                Editable=FALSE;
                OnValidate=BEGIN
                             UpdatePage;
                           END;
                            }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kan tildele varegebyrer til linjen.;
                           ENU=Specifies that you can assign item charges to this line.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Allow Item Charge Assignment";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varegebyret bliver tildelt linjen.;
                           ENU=Specifies how many units of the item charge will be assigned to the line.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Qty. to Assign";
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              ShowItemChargeAssgnt;
                              UpdateForm(FALSE);
                            END;
                             }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor meget af varegebyret der er blevet tildelt.;
                           ENU=Specifies how much of the item charge has been assigned.];
                ApplicationArea=#ItemCharges;
                BlankZero=Yes;
                SourceExpr="Qty. Assigned";
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              ShowItemChargeAssgnt;
                              UpdateForm(FALSE);
                            END;
                             }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Service Code";
                Visible=FALSE }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen vedr›rer, n†r salget er relateret til en sag.;
                           ENU=Specifies which work type the resource applies to when the sale is related to a job.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Type Code";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordrelinje, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette dokument eller denne kladdelinje udlignes p†.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied -to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[3];
                CaptionClass='1,2,3';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                           END;
                            }

    { 302 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[4];
                CaptionClass='1,2,4';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                           END;
                            }

    { 304 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[5];
                CaptionClass='1,2,5';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                           END;
                            }

    { 306 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[6];
                CaptionClass='1,2,6';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                           END;
                            }

    { 308 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[7];
                CaptionClass='1,2,7';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                           END;
                            }

    { 310 ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=ShortcutDimCode[8];
                CaptionClass='1,2,8';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE;
                OnValidate=BEGIN
                             ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                           END;
                            }

    { 53  ;1   ;Group     ;
                GroupType=Group }

    { 49  ;2   ;Group     ;
                GroupType=Group }

    { 37  ;3   ;Field     ;
                Name=Subtotal Excl. VAT;
                CaptionML=[DAN=Subtotal ekskl. moms;
                           ENU=Subtotal Excl. VAT];
                ToolTipML=[DAN=Angiver summen af v‘rdien i feltet Linjebel›b ekskl. moms p† alle linjer i dokumentet.;
                           ENU=Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TotalSalesLine."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code,TotalSalesHeader."Prices Including VAT");
                Editable=FALSE }

    { 47  ;3   ;Field     ;
                Name=Invoice Discount Amount;
                CaptionML=[DAN=Fakturarabatbel›b;
                           ENU=Invoice Discount Amount];
                ToolTipML=[DAN=Angiver et rabatbel›b, der tr‘kkes fra v‘rdien i feltet I alt inkl. moms. Du kan angive eller ‘ndre bel›bet manuelt.;
                           ENU=Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=InvoiceDiscountAmount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(FIELDCAPTION("Inv. Discount Amount"),Currency.Code);
                Editable=InvDiscAmountEditable;
                OnValidate=BEGIN
                             ValidateInvoiceDiscountAmount;
                           END;
                            }

    { 45  ;3   ;Field     ;
                Name=Invoice Disc. Pct.;
                CaptionML=[DAN=Fakturarabat i %;
                           ENU=Invoice Discount %];
                ToolTipML=[DAN=Angiver en rabatprocent, der ydes, hvis de kriterier, du har oprettet for debitoren, opfyldes.;
                           ENU=Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:2;
                SourceExpr=InvoiceDiscountPct;
                Editable=InvDiscAmountEditable;
                OnValidate=BEGIN
                             InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * InvoiceDiscountPct / 100,Currency."Amount Rounding Precision");
                             ValidateInvoiceDiscountAmount;
                           END;
                            }

    { 35  ;2   ;Group     ;
                GroupType=Group }

    { 33  ;3   ;Field     ;
                Name=Total Amount Excl. VAT;
                DrillDown=No;
                CaptionML=[DAN=I alt ekskl. moms;
                           ENU=Total Amount Excl. VAT];
                ToolTipML=[DAN=Angiver summen af v‘rdien i feltet Linjebel›b ekskl. moms p† alle linjer i dokumentet minus eventuelle rabatbel›b i feltet Fakturarabatbel›b.;
                           ENU=Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TotalSalesLine.Amount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                Editable=FALSE }

    { 31  ;3   ;Field     ;
                Name=Total VAT Amount;
                CaptionML=[DAN=Moms i alt;
                           ENU=Total VAT];
                ToolTipML=[DAN=Angiver summen af momsbel›b p† alle linjer i dokumentet.;
                           ENU=Specifies the sum of VAT amounts on all lines in the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=VATAmount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalVATCaption(Currency.Code);
                Editable=FALSE }

    { 29  ;3   ;Field     ;
                Name=Total Amount Incl. VAT;
                CaptionML=[DAN=I alt inkl. moms;
                           ENU=Total Amount Incl. VAT];
                ToolTipML=[DAN=Angiver summen af v‘rdien i feltet Linjebel›b inkl. moms p† alle linjer i dokumentet minus eventuelle rabatbel›b i feltet Fakturarabatbel›b.;
                           ENU=Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TotalSalesLine."Amount Including VAT";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                Editable=FALSE }

  }
  CODE
  {
    VAR
      TotalSalesHeader@1017 : Record 36;
      TotalSalesLine@1016 : Record 37;
      SalesHeader@1000 : Record 36;
      Currency@1005 : Record 4;
      SalesSetup@1018 : Record 311;
      TempOptionLookupBuffer@1020 : TEMPORARY Record 1670;
      TransferExtendedText@1002 : Codeunit 378;
      SalesPriceCalcMgt@1004 : Codeunit 7000;
      ItemAvailFormsMgt@1001 : Codeunit 353;
      SalesCalcDiscByType@1015 : Codeunit 56;
      DocumentTotals@1014 : Codeunit 57;
      VATAmount@1013 : Decimal;
      AmountWithDiscountAllowed@1021 : Decimal;
      ShortcutDimCode@1003 : ARRAY [8] OF Code[20];
      IsCommentLine@1012 : Boolean;
      UnitofMeasureCodeIsChangeable@1008 : Boolean;
      IsFoundation@1009 : Boolean;
      InvoiceDiscountAmount@1011 : Decimal;
      InvoiceDiscountPct@1006 : Decimal;
      InvDiscAmountEditable@1007 : Boolean;
      ItemChargeStyleExpression@1026 : Text;
      TypeAsText@1010 : Text[30];

    [External]
    PROCEDURE ApproveCalcInvDisc@1();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
    END;

    LOCAL PROCEDURE ValidateInvoiceDiscountAmount@22();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader.GET("Document Type","Document No.");
      SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE CalcInvDisc@17();
    VAR
      SalesCalcDiscount@1000 : Codeunit 60;
    BEGIN
      SalesCalcDiscount.CalculateInvoiceDiscountOnLine(Rec);
    END;

    LOCAL PROCEDURE ExplodeBOM@3();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
    END;

    LOCAL PROCEDURE InsertExtendedText@4(Unconditionally@1000 : Boolean);
    BEGIN
      IF TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
        CurrPage.SAVERECORD;
        COMMIT;
        TransferExtendedText.InsertSalesExtText(Rec);
      END;
      IF TransferExtendedText.MakeUpdate THEN
        UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShowItemSub@8();
    BEGIN
      ShowItemSub;
    END;

    LOCAL PROCEDURE ShowNonstockItems@10();
    BEGIN
      ShowNonstock;
    END;

    LOCAL PROCEDURE ItemChargeAssgnt@5800();
    BEGIN
      ShowItemChargeAssgnt;
    END;

    [External]
    PROCEDURE UpdateForm@12(SetSaveRecord@1000 : Boolean);
    BEGIN
      CurrPage.UPDATE(SetSaveRecord);
    END;

    LOCAL PROCEDURE ShowPrices@15();
    BEGIN
      SalesHeader.GET("Document Type","Document No.");
      CLEAR(SalesPriceCalcMgt);
      SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader,Rec);
    END;

    LOCAL PROCEDURE ShowLineDisc@16();
    BEGIN
      SalesHeader.GET("Document Type","Document No.");
      CLEAR(SalesPriceCalcMgt);
      SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader,Rec);
    END;

    LOCAL PROCEDURE ShowLineComments@11();
    BEGIN
      ShowLineComments;
    END;

    LOCAL PROCEDURE NoOnAfterValidate@19066594();
    BEGIN
      InsertExtendedText(FALSE);
      IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
         (xRec."No." <> '')
      THEN
        CurrPage.SAVERECORD;

      SaveAndAutoAsmToOrder;
    END;

    LOCAL PROCEDURE LocationCodeOnAfterValidate@2();
    BEGIN
      SaveAndAutoAsmToOrder;
    END;

    LOCAL PROCEDURE VariantCodeOnAfterValidate@9();
    BEGIN
      SaveAndAutoAsmToOrder;
    END;

    LOCAL PROCEDURE CrossReferenceNoOnAfterValidat@19048248();
    BEGIN
      InsertExtendedText(FALSE);
    END;

    LOCAL PROCEDURE QuantityOnAfterValidate@19032465();
    BEGIN
      IF Reserve = Reserve::Always THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
      END;

      IF (Type = Type::Item) AND
         (Quantity <> xRec.Quantity)
      THEN
        CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE UnitofMeasureCodeOnAfterValida@19057939();
    BEGIN
      IF Reserve = Reserve::Always THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
      END;
    END;

    LOCAL PROCEDURE SaveAndAutoAsmToOrder@13();
    BEGIN
      IF (Type = Type::Item) AND IsAsmToOrderRequired THEN BEGIN
        CurrPage.SAVERECORD;
        AutoAsmToOrder;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE RedistributeTotalsOnAfterValidate@7();
    BEGIN
      CurrPage.SAVERECORD;

      SalesHeader.GET("Document Type","Document No.");
      DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE UpdateEditableOnRow@19();
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      IsCommentLine := NOT HasTypeToFillMandatoryFields;
      IF NOT IsCommentLine THEN
        UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
      ELSE
        UnitofMeasureCodeIsChangeable := FALSE;

      IF TotalSalesHeader."No." <> '' THEN BEGIN
        SalesLine.SETRANGE("Document No.",TotalSalesHeader."No.");
        SalesLine.SETRANGE("Document Type",TotalSalesHeader."Document Type");
        IF NOT SalesLine.ISEMPTY THEN
          InvDiscAmountEditable :=
            SalesCalcDiscByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") AND CurrPage.EDITABLE;
      END;
    END;

    LOCAL PROCEDURE UpdatePage@20();
    VAR
      SalesHeader@1001 : Record 36;
    BEGIN
      CurrPage.UPDATE;
      SalesHeader.GET("Document Type","Document No.");
      SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(TotalSalesHeader."Invoice Discount Amount",SalesHeader);
    END;

    LOCAL PROCEDURE GetTotalSalesHeader@14();
    BEGIN
      IF NOT TotalSalesHeader.GET("Document Type","Document No.") THEN
        CLEAR(TotalSalesHeader);
      IF Currency.Code <> TotalSalesHeader."Currency Code" THEN
        IF NOT Currency.GET(TotalSalesHeader."Currency Code") THEN BEGIN
          CLEAR(Currency);
          Currency.InitRoundingPrecision;
        END
    END;

    LOCAL PROCEDURE CalculateTotals@6();
    BEGIN
      GetTotalSalesHeader;
      TotalSalesHeader.CALCFIELDS("Recalculate Invoice Disc.");

      IF SalesSetup."Calc. Inv. Discount" AND ("Document No." <> '') AND (TotalSalesHeader."Customer Posting Group" <> '') AND
         TotalSalesHeader."Recalculate Invoice Disc."
      THEN
        IF FIND THEN
          CalcInvDisc;

      DocumentTotals.CalculateSalesPageTotals(TotalSalesLine,VATAmount,Rec);
      AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
      InvoiceDiscountAmount := TotalSalesLine."Inv. Discount Amount";
      InvoiceDiscountPct := SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec);
    END;

    LOCAL PROCEDURE UpdateTypeText@24();
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
    END;

    LOCAL PROCEDURE SetItemChargeFieldsStyle@30();
    BEGIN
      ItemChargeStyleExpression := '';
      IF AssignedItemCharge THEN
        ItemChargeStyleExpression := 'Unfavorable';
    END;

    BEGIN
    END.
  }
}

