OBJECT Page 508 Blanket Sales Order Subform
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019,NAVDK11.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table37;
    DelayedInsert=Yes;
    SourceTableView=WHERE(Document Type=FILTER(Blanket Order));
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInit=BEGIN
             Currency.InitRoundingPrecision;
           END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                       CLEAR(DocumentTotals);
                     END;

    OnNewRecord=BEGIN
                  InitType;
                  CLEAR(ShortcutDimCode);
                END;

    OnAfterGetCurrRecord=BEGIN
                           IF SalesHeader.GET("Document Type","Document No.") THEN;

                           DocumentTotals.SalesUpdateTotalsControls(Rec,TotalSalesHeader,TotalSalesLine,RefreshMessageEnabled,
                             TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,CurrPage.EDITABLE,VATAmount);

                           UpdateCurrency;
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1903866504;2 ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilgëngelige saldo for en vare udvikler sig over tid i henhold til udbud og efterspõrgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Advanced;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 1900544904;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller mÜned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Advanced;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByPeriod)
                               END;
                                }
      { 1901991304;3 ;Action    ;
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
      { 1901652204;3 ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Advanced;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByLocation)
                               END;
                                }
      { 25      ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=FÜ vist tilgëngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret pÜ tilgëngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Advanced;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByBOM)
                               END;
                                }
      { 1902740304;2 ;ActionGroup;
                      CaptionML=[DAN=Ikkebogfõrte linjer;
                                 ENU=Unposted Lines];
                      Image=Order }
      { 1907075804;3 ;Action    ;
                      CaptionML=[DAN=Ordrer;
                                 ENU=Orders];
                      ToolTipML=[DAN=Vis de relaterede salgsordrer.;
                                 ENU=View related sales orders.];
                      ApplicationArea=#Advanced;
                      Image=Document;
                      OnAction=BEGIN
                                 ShowOrders;
                               END;
                                }
      { 1900639404;3 ;Action    ;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangvërende salgsfakturaer for ordren.;
                                 ENU=View a list of ongoing sales invoices for the order.];
                      ApplicationArea=#Advanced;
                      Image=Invoice;
                      OnAction=BEGIN
                                 ShowInvoices;
                               END;
                                }
      { 1906421304;3 ;Action    ;
                      AccessByPermission=TableData 6660=R;
                      CaptionML=[DAN=Returvareordrer;
                                 ENU=Return Orders];
                      ToolTipML=[DAN=èbn oversigten over igangvërende returordrer.;
                                 ENU=Open the list of ongoing return orders.];
                      ApplicationArea=#Advanced;
                      Image=ReturnOrder;
                      OnAction=BEGIN
                                 ShowReturnOrders;
                               END;
                                }
      { 1900609704;3 ;Action    ;
                      CaptionML=[DAN=Kreditnotaer;
                                 ENU=Credit Memos];
                      ToolTipML=[DAN=Vis en liste med igangvërende kreditnotaer for ordren.;
                                 ENU=View a list of ongoing credit memos for the order.];
                      ApplicationArea=#Advanced;
                      Image=CreditMemo;
                      OnAction=BEGIN
                                 ShowCreditMemos;
                               END;
                                }
      { 1904974904;2 ;ActionGroup;
                      CaptionML=[DAN=Bogfõrte linjer;
                                 ENU=Posted Lines];
                      Image=Post }
      { 1904945204;3 ;Action    ;
                      CaptionML=[DAN=Leverancer;
                                 ENU=Shipments];
                      ToolTipML=[DAN=Vis en liste med igangvërende leverancer for ordren.;
                                 ENU=View a list of ongoing sales shipments for the order.];
                      ApplicationArea=#Advanced;
                      Image=Shipment;
                      OnAction=BEGIN
                                 ShowPostedOrders;
                               END;
                                }
      { 1901092104;3 ;Action    ;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangvërende salgsfakturaer for ordren.;
                                 ENU=View a list of ongoing sales invoices for the order.];
                      ApplicationArea=#Advanced;
                      Image=Invoice;
                      OnAction=BEGIN
                                 ShowPostedInvoices;
                               END;
                                }
      { 1903984904;3 ;Action    ;
                      AccessByPermission=TableData 6660=R;
                      CaptionML=[DAN=Returvaremodtagelse;
                                 ENU=Return Receipts];
                      ToolTipML=[DAN=Vis en liste over bogfõrte returvaremodtagelser for ordren.;
                                 ENU=View a list of posted return receipts for the order.];
                      ApplicationArea=#Advanced;
                      Image=ReturnReceipt;
                      OnAction=BEGIN
                                 ShowPostedReturnReceipts;
                               END;
                                }
      { 1901033504;3 ;Action    ;
                      CaptionML=[DAN=Kreditnotaer;
                                 ENU=Credit Memos];
                      ToolTipML=[DAN=Vis en liste med igangvërende kreditnotaer for ordren.;
                                 ENU=View a list of ongoing credit memos for the order.];
                      ApplicationArea=#Advanced;
                      Image=CreditMemo;
                      OnAction=BEGIN
                                 ShowPostedCreditMemos;
                               END;
                                }
      { 1900186704;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1900978604;2 ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      Image=ViewComments;
                      OnAction=BEGIN
                                 ShowLineComments;
                               END;
                                }
      { 15      ;2   ;ActionGroup;
                      CaptionML=[DAN=Montage til ordre;
                                 ENU=Assemble to Order];
                      ActionContainerType=NewDocumentItems;
                      Image=AssemblyBOM }
      { 5       ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=Montage efter ordre-linjer;
                                 ENU=Assemble-to-Order Lines];
                      ToolTipML=[DAN=Vis eventuelle tilknyttede montageordrelinjer, hvis bilagene reprësenterer et ordremontagesalg.;
                                 ENU=View any linked assembly order lines if the documents represents an assemble-to-order sale.];
                      ApplicationArea=#Assembly;
                      OnAction=BEGIN
                                 ShowAsmToOrderLines;
                               END;
                                }
      { 13      ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Akkumuleret &pris;
                                 ENU=Roll Up &Price];
                      ToolTipML=[DAN=Opdater enhedsprisen for montageelementet i overensstemmelse med de ëndringer, du har foretaget i montagekomponenterne.;
                                 ENU=Update the unit price of the assembly item according to any changes that you have made to the assembly components.];
                      ApplicationArea=#Assembly;
                      OnAction=BEGIN
                                 RollupAsmPrice;
                               END;
                                }
      { 9       ;3   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Akkum. &varekostpris;
                                 ENU=Roll Up &Cost];
                      ToolTipML=[DAN=Opdater kostprisen for montageelementet i overensstemmelse med de ëndringer, du har foretaget i montagekomponenterne.;
                                 ENU=Update the unit cost of the assembly item according to any changes that you have made to the assembly components.];
                      ApplicationArea=#Assembly;
                      OnAction=BEGIN
                                 RollUpAsmCost;
                               END;
                                }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 21      ;2   ;Action    ;
                      AccessByPermission=TableData 7002=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent pris;
                                 ENU=Get &Price];
                      ToolTipML=[DAN=Indsët den laveste mulige pris i feltet Enhedspris i henhold til enhver specialpris, du har angivet.;
                                 ENU=Insert the lowest possible price in the Unit Price field according to any special price that you have set up.];
                      ApplicationArea=#Advanced;
                      Image=Price;
                      OnAction=BEGIN
                                 ShowPrices
                               END;
                                }
      { 19      ;2   ;Action    ;
                      AccessByPermission=TableData 7004=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=H&ent linjerabat;
                                 ENU=Get Li&ne Discount];
                      ToolTipML=[DAN=Indsët den bedste mulige rabat i feltet Linjerabat i henhold til enhver specialrabat, du har angivet.;
                                 ENU=Insert the best possible discount in the Line Discount field according to any special discounts that you have set up.];
                      ApplicationArea=#Advanced;
                      Image=LineDiscount;
                      OnAction=BEGIN
                                 ShowLineDisc
                               END;
                                }
      { 17      ;2   ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=U&dfold stykliste;
                                 ENU=E&xplode BOM];
                      ToolTipML=[DAN=Indsët nye linjer for komponenterne pÜ styklisten, f.eks. for at sëlge den overordnede vare som en pakke. ADVARSEL! Linjen for den overordnede vare bliver slettet og kun reprësenteret af en beskrivelse. Hvis du vil fortryde, skal du slette komponentlinjerne og tilfõje en linje igen for den overordnede vare.;
                                 ENU=Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.];
                      ApplicationArea=#Advanced;
                      Image=ExplodeBOM;
                      OnAction=BEGIN
                                 ExplodeBOM;
                               END;
                                }
      { 11      ;2   ;Action    ;
                      AccessByPermission=TableData 279=R;
                      CaptionML=[DAN=&Indsët udv. tekster;
                                 ENU=Insert &Ext. Texts];
                      ToolTipML=[DAN=Indsët den forlëngede varebeskrivelse, som hõrer til varen, der behandles pÜ linjen.;
                                 ENU=Insert the extended item description that is set up for the item that is being processed on the line.];
                      ApplicationArea=#Advanced;
                      Image=Text;
                      OnAction=BEGIN
                                 InsertExtendedText(TRUE);
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
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#Advanced;
                SourceExpr=Type;
                OnValidate=BEGIN
                             NoOnAfterValidate;

                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No.";
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                             NoOnAfterValidate;

                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dit og din kreditors og debitors varenummer, vil dette nummer tilsidesëtte standardvarenummeret, nÜr du angiver krydsreferencenummeret pÜ et salgs- eller kõbsbilag.;
                           ENU=Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor's or customer's item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.];
                ApplicationArea=#Advanced;
                SourceExpr="Cross-Reference No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             CrossReferenceNoOnAfterValidat;
                           END;

                OnLookup=BEGIN
                           CrossReferenceNoLookUp;
                           InsertExtendedText(FALSE);
                         END;
                          }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE;
                OnValidate=BEGIN
                             VariantCodeOnAfterValidate
                           END;
                            }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogfõringsopsëtning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af rammesalgsordren.;
                           ENU=Specifies a description of the blanket sales order.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren pÜ salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code";
                OnValidate=BEGIN
                             LocationCodeOnAfterValidate
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet for salgsordrelinjen.;
                           ENU=Specifies the quantity of the sales order line.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=Quantity;
                OnValidate=BEGIN
                             QuantityOnAfterValidate;
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af rammesalgslinjeantallet, som du vil forsyne via montage.;
                           ENU=Specifies how many units of the blanket sales line quantity that you want to supply by assembly.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. to Assemble to Order";
                Visible=FALSE;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             CurrPage.UPDATE(TRUE);
                           END;

                OnDrillDown=BEGIN
                              ShowAsmToOrderLines;
                            END;
                             }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdstypekoden for den servicelinje, der er knyttet til posten.;
                           ENU=Specifies the work type code of the service line linked to this entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Type Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ vare- eller ressourcekortet.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure Code";
                OnValidate=BEGIN
                             UnitofMeasureCodeOnAfterValida;
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                CaptionML=[DAN=Salgspris findes;
                           ENU=Sale Price Exists];
                ToolTipML=[DAN=Angiver, at der er en specifik pris for debitoren. Salgsprisen kan ses i vinduet Salgspriser.;
                           ENU=Specifies that there is a specific price for this customer. The sales prices can be seen in the Sales Prices window.];
                ApplicationArea=#Advanced;
                SourceExpr=PriceExists;
                Visible=FALSE;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for Çn enhed af varen eller ressourcen. Du kan angive en pris manuelt eller fÜ den angivet i henhold til feltet Avancepct.beregning pÜ det dertilhõrende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Unit Price";
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen pÜ linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Line Discount %";
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobelõb uden eventuelt fakturarabatbelõb, som skal betales for produkterne pÜ linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Line Amount";
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 40  ;2   ;Field     ;
                CaptionML=[DAN=Salgslinjerabat findes;
                           ENU=Sales Line Disc. Exists];
                ToolTipML=[DAN=Angiver, at der er en specifik rabat for debitoren. Salgslinjerabatterne kan ses i vinduet Salgslinjerabatter.;
                           ENU=Specifies that there is a specific discount for this customer. The sales line discounts can be seen in the Sales Line Discounts window.];
                ApplicationArea=#Advanced;
                SourceExpr=LineDiscExists;
                Visible=FALSE;
                Editable=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbelõb, der ydes pÜ varen, pÜ linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Line Discount Amount";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, nÜr fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der mangler at blive afsendt.;
                           ENU=Specifies the quantity of items that remain to be shipped.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Qty. to Ship" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den pÜgëldende vare der allerede er blevet bogfõrt som leveret.;
                           ENU=Specifies how many units of the item on the line have been posted as shipped.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Quantity Shipped" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den pÜgëldende vare der allerede er blevet bogfõrt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Quantity Invoiced" }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr varerne pÜ bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en õnsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
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
                ApplicationArea=#Dimensions;
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
                ApplicationArea=#Dimensions;
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
                ApplicationArea=#Dimensions;
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
                ApplicationArea=#Dimensions;
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
                ApplicationArea=#Dimensions;
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

    { 1101100000;2;Field  ;
                ToolTipML=[DAN="Angiver kontokoden for debitoren. ";
                           ENU="Specifies the account code of the customer. "];
                ApplicationArea=#Advanced;
                SourceExpr="Account Code";
                Visible=FALSE }

    { 53  ;1   ;Group     ;
                GroupType=Group }

    { 49  ;2   ;Group     ;
                GroupType=Group }

    { 48  ;3   ;Field     ;
                Name=Invoice Discount Amount;
                CaptionML=[DAN=Fakturarabatbelõb;
                           ENU=Invoice Discount Amount];
                ToolTipML=[DAN=Angiver et rabatbelõb, der trëkkes fra vërdien i feltet I alt inkl. moms.;
                           ENU=Specifies a discount amount that is deducted from the value in the Total Incl. VAT field.];
                ApplicationArea=#Advanced;
                SourceExpr=TotalSalesLine."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(FIELDCAPTION("Inv. Discount Amount"),Currency.Code);
                Editable=InvDiscAmountEditable;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled;
                OnValidate=VAR
                             SalesHeader@1000 : Record 36;
                           BEGIN
                             SalesHeader.GET("Document Type","Document No.");
                             SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(TotalSalesLine."Inv. Discount Amount",SalesHeader);
                             CurrPage.UPDATE(FALSE);
                           END;
                            }

    { 47  ;3   ;Field     ;
                Name=Invoice Disc. Pct.;
                CaptionML=[DAN=Fakturarabat i %;
                           ENU=Invoice Discount %];
                ToolTipML=[DAN=Angiver en rabatprocent, der ydes, hvis de kriterier, du har oprettet for debitoren, er opfyldt.;
                           ENU=Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:2;
                SourceExpr=SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 35  ;2   ;Group     ;
                GroupType=Group }

    { 33  ;3   ;Field     ;
                Name=Total Amount Excl. VAT;
                DrillDown=No;
                CaptionML=[DAN=I alt ekskl. moms;
                           ENU=Total Amount Excl. VAT];
                ToolTipML=[DAN=Angiver summen af vërdien i feltet Linjebelõb ekskl. moms pÜ alle linjer i bilaget minus eventuelle rabatbelõb i feltet Fakturarabatbelõb.;
                           ENU=Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#Advanced;
                SourceExpr=TotalSalesLine.Amount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 31  ;3   ;Field     ;
                Name=Total VAT Amount;
                CaptionML=[DAN=Moms i alt;
                           ENU=Total VAT];
                ToolTipML=[DAN=Angiver summen af momsbelõb pÜ alle linjer i bilaget.;
                           ENU=Specifies the sum of VAT amounts on all lines in the document.];
                ApplicationArea=#Advanced;
                SourceExpr=VATAmount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalVATCaption(Currency.Code);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 29  ;3   ;Field     ;
                Name=Total Amount Incl. VAT;
                CaptionML=[DAN=I alt inkl. moms;
                           ENU=Total Amount Incl. VAT];
                ToolTipML=[DAN=Angiver summen af vërdien i feltet Linjebelõb inkl. moms pÜ alle linjer i bilaget minus eventuelle rabatbelõb i feltet Fakturarabatbelõb.;
                           ENU=Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#Advanced;
                SourceExpr=TotalSalesLine."Amount Including VAT";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                Editable=FALSE;
                StyleExpr=TotalAmountStyle }

    { 27  ;3   ;Field     ;
                Name=RefreshTotals;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=RefreshMessageText;
                Enabled=RefreshMessageEnabled;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
                              DocumentTotals.SalesUpdateTotalsControls(Rec,TotalSalesHeader,TotalSalesLine,RefreshMessageEnabled,
                                TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,CurrPage.EDITABLE,VATAmount);
                            END;

                ShowCaption=No }

  }
  CODE
  {
    VAR
      CurrentSalesLine@1005 : Record 37;
      SalesLine@1001 : Record 37;
      TotalSalesHeader@1014 : Record 36;
      TotalSalesLine@1013 : Record 37;
      SalesHeader@1000 : Record 36;
      Currency@1007 : Record 4;
      TransferExtendedText@1002 : Codeunit 378;
      SalesPriceCalcMgt@1004 : Codeunit 7000;
      ItemAvailFormsMgt@1006 : Codeunit 353;
      SalesCalcDiscByType@1017 : Codeunit 56;
      DocumentTotals@1016 : Codeunit 57;
      VATAmount@1015 : Decimal;
      ShortcutDimCode@1003 : ARRAY [8] OF Code[20];
      InvDiscAmountEditable@1012 : Boolean;
      TotalAmountStyle@1011 : Text;
      RefreshMessageEnabled@1010 : Boolean;
      RefreshMessageText@1009 : Text;

    [External]
    PROCEDURE ApproveCalcInvDisc@6();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
    END;

    LOCAL PROCEDURE ExplodeBOM@3();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
    END;

    LOCAL PROCEDURE InsertExtendedText@5(Unconditionally@1000 : Boolean);
    BEGIN
      IF TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
        CurrPage.SAVERECORD;
        COMMIT;
        TransferExtendedText.InsertSalesExtText(Rec);
      END;
      IF TransferExtendedText.MakeUpdate THEN
        UpdateForm(TRUE);
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

    LOCAL PROCEDURE ShowOrders@2();
    BEGIN
      CurrentSalesLine := Rec;
      SalesLine.RESET;
      SalesLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
      SalesLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
      SalesLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine);
    END;

    LOCAL PROCEDURE ShowInvoices@4();
    BEGIN
      CurrentSalesLine := Rec;
      SalesLine.RESET;
      SalesLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Invoice);
      SalesLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
      SalesLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine);
    END;

    LOCAL PROCEDURE ShowReturnOrders@9();
    BEGIN
      CurrentSalesLine := Rec;
      SalesLine.RESET;
      SalesLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::"Return Order");
      SalesLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
      SalesLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine);
    END;

    LOCAL PROCEDURE ShowCreditMemos@10();
    BEGIN
      CurrentSalesLine := Rec;
      SalesLine.RESET;
      SalesLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::"Credit Memo");
      SalesLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
      SalesLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine);
    END;

    LOCAL PROCEDURE ShowPostedOrders@17();
    VAR
      SaleShptLine@1000 : Record 111;
    BEGIN
      CurrentSalesLine := Rec;
      SaleShptLine.RESET;
      SaleShptLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
      SaleShptLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
      SaleShptLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Posted Sales Shipment Lines",SaleShptLine);
    END;

    LOCAL PROCEDURE ShowPostedInvoices@14();
    VAR
      SalesInvLine@1000 : Record 113;
    BEGIN
      CurrentSalesLine := Rec;
      SalesInvLine.RESET;
      SalesInvLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
      SalesInvLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
      SalesInvLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Posted Sales Invoice Lines",SalesInvLine);
    END;

    LOCAL PROCEDURE ShowPostedReturnReceipts@13();
    VAR
      ReturnRcptLine@1000 : Record 6661;
    BEGIN
      CurrentSalesLine := Rec;
      ReturnRcptLine.RESET;
      ReturnRcptLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
      ReturnRcptLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
      ReturnRcptLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Posted Return Receipt Lines",ReturnRcptLine);
    END;

    LOCAL PROCEDURE ShowPostedCreditMemos@11();
    VAR
      SalesCrMemoLine@1000 : Record 115;
    BEGIN
      CurrentSalesLine := Rec;
      SalesCrMemoLine.RESET;
      SalesCrMemoLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
      SalesCrMemoLine.SETRANGE("Blanket Order No.",CurrentSalesLine."Document No.");
      SalesCrMemoLine.SETRANGE("Blanket Order Line No.",CurrentSalesLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memo Lines",SalesCrMemoLine);
    END;

    LOCAL PROCEDURE NoOnAfterValidate@19066594();
    BEGIN
      InsertExtendedText(FALSE);

      SaveAndAutoAsmToOrder;
    END;

    LOCAL PROCEDURE LocationCodeOnAfterValidate@20();
    BEGIN
      SaveAndAutoAsmToOrder;
    END;

    LOCAL PROCEDURE VariantCodeOnAfterValidate@19();
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

    LOCAL PROCEDURE SaveAndAutoAsmToOrder@23();
    BEGIN
      IF (Type = Type::Item) AND IsAsmToOrderRequired THEN BEGIN
        CurrPage.SAVERECORD;
        AutoAsmToOrder;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE RedistributeTotalsOnAfterValidate@8();
    BEGIN
      CurrPage.SAVERECORD;

      SalesHeader.GET("Document Type","Document No.");
      IF DocumentTotals.SalesCheckNumberOfLinesLimit(SalesHeader) THEN
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE UpdateCurrency@1();
    BEGIN
      IF Currency.Code <> TotalSalesHeader."Currency Code" THEN
        IF NOT Currency.GET(TotalSalesHeader."Currency Code") THEN BEGIN
          CLEAR(Currency);
          Currency.InitRoundingPrecision;
        END
    END;

    BEGIN
    END.
  }
}

