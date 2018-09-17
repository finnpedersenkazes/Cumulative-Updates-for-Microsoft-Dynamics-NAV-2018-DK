OBJECT Page 510 Blanket Purchase Order Subform
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table39;
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
                           IF PurchHeader.GET("Document Type","Document No.") THEN;

                           DocumentTotals.PurchaseUpdateTotalsControls(Rec,TotalPurchaseHeader,TotalPurchaseLine,RefreshMessageEnabled,
                             TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,VATAmount);

                           UpdateCurrency;
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1901312904;2 ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=&Udfold stykliste;
                                 ENU=E&xplode BOM];
                      ToolTipML=[DAN=Inds�t nye linjer for komponenterne p� styklisten, f.eks. for at s�lge den overordnede vare som en pakke. ADVARSEL! Linjen for den overordnede vare bliver slettet og kun repr�senteret af en beskrivelse. Hvis du vil fortryde, skal du slette komponentlinjerne og tilf�je en linje igen for den overordnede vare.;
                                 ENU=Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.];
                      ApplicationArea=#Advanced;
                      Image=ExplodeBOM;
                      OnAction=BEGIN
                                 ExplodeBOM;
                               END;
                                }
      { 1901313304;2 ;Action    ;
                      AccessByPermission=TableData 279=R;
                      CaptionML=[DAN=&Inds�t udv. tekster;
                                 ENU=Insert &Ext. Texts];
                      ToolTipML=[DAN=Inds�t den forl�ngede varebeskrivelse, som h�rer til varen, der behandles p� linjen.;
                                 ENU=Insert the extended item description that is set up for the item that is being processed on the line.];
                      ApplicationArea=#Advanced;
                      Image=Text;
                      OnAction=BEGIN
                                 InsertExtendedText(TRUE);
                               END;
                                }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1901991404;2 ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg�ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp�rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Advanced;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 1900205704;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m�ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Advanced;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByPeriod)
                               END;
                                }
      { 1901652104;3 ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByVariant)
                               END;
                                }
      { 1901313404;3 ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Advanced;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByLocation)
                               END;
                                }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F� vist tilg�ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p� tilg�ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Advanced;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByBOM)
                               END;
                                }
      { 1903868004;2 ;ActionGroup;
                      CaptionML=[DAN=Ikkebogf�rte linjer;
                                 ENU=Unposted Lines];
                      Image=Order }
      { 1903100004;3 ;Action    ;
                      CaptionML=[DAN=Ordrer;
                                 ENU=Orders];
                      ToolTipML=[DAN=Vis alle relaterede k�bsordrer.;
                                 ENU=View related purchase orders.];
                      ApplicationArea=#Advanced;
                      Image=Document;
                      OnAction=BEGIN
                                 ShowOrders;
                               END;
                                }
      { 1900546404;3 ;Action    ;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangv�rende k�bsfakturaer for ordren.;
                                 ENU=View a list of ongoing purchase invoices for the order.];
                      ApplicationArea=#Advanced;
                      Image=Invoice;
                      OnAction=BEGIN
                                 ShowInvoices;
                               END;
                                }
      { 1903098504;3 ;Action    ;
                      AccessByPermission=TableData 6650=R;
                      CaptionML=[DAN=Returvareordrer;
                                 ENU=Return Orders];
                      ToolTipML=[DAN=�bn oversigten over igangv�rende returordrer.;
                                 ENU=Open the list of ongoing return orders.];
                      ApplicationArea=#Advanced;
                      Image=ReturnOrder;
                      OnAction=BEGIN
                                 ShowReturnOrders;
                               END;
                                }
      { 1901992804;3 ;Action    ;
                      CaptionML=[DAN=Kreditnotaer;
                                 ENU=Credit Memos];
                      ToolTipML=[DAN=Vis en liste med igangv�rende kreditnotaer for ordren.;
                                 ENU=View a list of ongoing credit memos for the order.];
                      ApplicationArea=#Advanced;
                      Image=CreditMemo;
                      OnAction=BEGIN
                                 ShowCreditMemos;
                               END;
                                }
      { 1901314404;2 ;ActionGroup;
                      CaptionML=[DAN=Bogf�rte linjer;
                                 ENU=Posted Lines];
                      Image=Post }
      { 1900296804;3 ;Action    ;
                      CaptionML=[DAN=Modtagelser;
                                 ENU=Receipts];
                      ToolTipML=[DAN=Vis en liste over bogf�rte k�bsmodtagelser for ordren.;
                                 ENU=View a list of posted purchase receipts for the order.];
                      ApplicationArea=#Advanced;
                      Image=PostedReceipts;
                      OnAction=BEGIN
                                 ShowPostedReceipts;
                               END;
                                }
      { 1904522204;3 ;Action    ;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangv�rende k�bsfakturaer for ordren.;
                                 ENU=View a list of ongoing purchase invoices for the order.];
                      ApplicationArea=#Advanced;
                      Image=Invoice;
                      OnAction=BEGIN
                                 ShowPostedInvoices;
                               END;
                                }
      { 1903926304;3 ;Action    ;
                      CaptionML=[DAN=Returvaremodtagelse;
                                 ENU=Return Receipts];
                      ToolTipML=[DAN=Vis en liste over bogf�rte returvaremodtagelser for ordren.;
                                 ENU=View a list of posted return receipts for the order.];
                      ApplicationArea=#Advanced;
                      Image=ReturnReceipt;
                      OnAction=BEGIN
                                 ShowPostedReturnReceipts;
                               END;
                                }
      { 1902056104;3 ;Action    ;
                      CaptionML=[DAN=Kreditnotaer;
                                 ENU=Credit Memos];
                      ToolTipML=[DAN=Vis en liste med igangv�rende kreditnotaer for ordren.;
                                 ENU=View a list of ongoing credit memos for the order.];
                      ApplicationArea=#Advanced;
                      Image=CreditMemo;
                      OnAction=BEGIN
                                 ShowPostedCreditMemos;
                               END;
                                }
      { 1906874004;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1900978604;2 ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      Image=ViewComments;
                      OnAction=BEGIN
                                 ShowLineComments;
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
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

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dit og din kreditors og debitors varenummer, vil dette nummer tilsides�tte standardvarenummeret, n�r du angiver krydsreferencenummeret p� et salgs- eller k�bsbilag.;
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

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf�ringsops�tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af rammek�bsordren.;
                           ENU=Specifies a description of the blanket purchase order.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet for k�bsordrelinjen.;
                           ENU=Specifies the quantity of the purchase order line.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr=Quantity;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� vare- eller ressourcekortet.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure Code";
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Direct Unit Cost";
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k�bspris, der omfatter indirekte omkostninger, s�som fragt, der er knyttet til k�bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Indirect Cost %";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for �n enhed af varen eller ressourcen i RV. Du kan angive en pris manuelt eller f� den angivet i henhold til feltet Avancepct.beregning p� det dertilh�rende kort.;
                           ENU=Specifies the price, in LCY, of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Price (LCY)";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p� linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Line Discount %";
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobel�b uden eventuelt fakturarabatbel�b, som skal betales for produkterne p� linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Line Amount";
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel�b, der ydes p� varen, p� linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Line Discount Amount";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, n�r fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der endnu ikke er modtaget.;
                           ENU=Specifies the quantity of items that remains to be received.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Qty. to Receive" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p�g�ldende vare der allerede er blevet bogf�rt som modtaget.;
                           ENU=Specifies how many units of the item on the line have been posted as received.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Quantity Received" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p�g�ldende vare der allerede er blevet bogf�rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Quantity Invoiced" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilg�ngelige p� lageret. Hvis du lader feltet v�re tomt, bliver det beregnet p� f�lgende m�de: Planlagt modtagelsesdato + Sikkerhedstid + Indg�ende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Receipt Date";
                Visible=FALSE }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
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

    { 37  ;1   ;Group     ;
                GroupType=Group }

    { 33  ;2   ;Group     ;
                GroupType=Group }

    { 31  ;3   ;Field     ;
                Name=Invoice Discount Amount;
                CaptionML=[DAN=Fakturarabatbel�b;
                           ENU=Invoice Discount Amount];
                ToolTipML=[DAN=Angiver et rabatbel�b, der tr�kkes fra v�rdien i feltet I alt inkl. moms.;
                           ENU=Specifies a discount amount that is deducted from the value in the Total Incl. VAT field.];
                ApplicationArea=#Advanced;
                SourceExpr=TotalPurchaseLine."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(FIELDCAPTION("Inv. Discount Amount"),Currency.Code);
                Editable=InvDiscAmountEditable;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled;
                OnValidate=VAR
                             PurchaseHeader@1000 : Record 38;
                           BEGIN
                             PurchaseHeader.GET("Document Type","Document No.");
                             PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(TotalPurchaseLine."Inv. Discount Amount",PurchaseHeader);
                             CurrPage.UPDATE(FALSE);
                           END;
                            }

    { 29  ;3   ;Field     ;
                Name=Invoice Disc. Pct.;
                CaptionML=[DAN=Fakturarabat i %;
                           ENU=Invoice Discount %];
                ToolTipML=[DAN=Angiver en rabatprocent, der ydes, hvis de kriterier, du har oprettet for debitoren, er opfyldt.;
                           ENU=Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:2;
                SourceExpr=PurchCalcDiscByType.GetVendInvoiceDiscountPct(Rec);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 15  ;2   ;Group     ;
                GroupType=Group }

    { 13  ;3   ;Field     ;
                Name=Total Amount Excl. VAT;
                DrillDown=No;
                CaptionML=[DAN=I alt ekskl. moms;
                           ENU=Total Amount Excl. VAT];
                ToolTipML=[DAN=Angiver summen af v�rdien i feltet Linjebel�b ekskl. moms p� alle linjer i bilaget minus eventuelle rabatbel�b i feltet Fakturarabatbel�b.;
                           ENU=Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#Advanced;
                SourceExpr=TotalPurchaseLine.Amount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 11  ;3   ;Field     ;
                Name=Total VAT Amount;
                CaptionML=[DAN=Moms i alt;
                           ENU=Total VAT];
                ToolTipML=[DAN=Angiver summen af momsbel�b p� alle linjer i bilaget.;
                           ENU=Specifies the sum of VAT amounts on all lines in the document.];
                ApplicationArea=#Advanced;
                SourceExpr=VATAmount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalVATCaption(Currency.Code);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 9   ;3   ;Field     ;
                Name=Total Amount Incl. VAT;
                CaptionML=[DAN=I alt inkl. moms;
                           ENU=Total Amount Incl. VAT];
                ToolTipML=[DAN=Angiver summen af v�rdien i feltet Linjebel�b inkl. moms p� alle linjer i bilaget minus eventuelle rabatbel�b i feltet Fakturarabatbel�b.;
                           ENU=Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#Advanced;
                SourceExpr=TotalPurchaseLine."Amount Including VAT";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                Editable=FALSE;
                StyleExpr=TotalAmountStyle }

    { 7   ;3   ;Field     ;
                Name=RefreshTotals;
                DrillDown=Yes;
                ApplicationArea=#Advanced;
                SourceExpr=RefreshMessageText;
                Enabled=RefreshMessageEnabled;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);
                              DocumentTotals.PurchaseUpdateTotalsControls(Rec,TotalPurchaseHeader,TotalPurchaseLine,RefreshMessageEnabled,
                                TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,VATAmount);
                            END;

                ShowCaption=No }

  }
  CODE
  {
    VAR
      TotalPurchaseHeader@1013 : Record 38;
      TotalPurchaseLine@1012 : Record 39;
      PurchHeader@1016 : Record 38;
      PurchLine@1001 : Record 39;
      CurrentPurchLine@1000 : Record 39;
      Currency@1005 : Record 4;
      TransferExtendedText@1002 : Codeunit 378;
      ItemAvailFormsMgt@1004 : Codeunit 353;
      PurchCalcDiscByType@1015 : Codeunit 66;
      DocumentTotals@1014 : Codeunit 57;
      ShortcutDimCode@1003 : ARRAY [8] OF Code[20];
      VATAmount@1011 : Decimal;
      InvDiscAmountEditable@1010 : Boolean;
      TotalAmountStyle@1009 : Text;
      RefreshMessageEnabled@1008 : Boolean;
      RefreshMessageText@1007 : Text;

    [External]
    PROCEDURE ApproveCalcInvDisc@7();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)",Rec);
    END;

    LOCAL PROCEDURE ExplodeBOM@3();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM",Rec);
    END;

    LOCAL PROCEDURE InsertExtendedText@6(Unconditionally@1000 : Boolean);
    BEGIN
      IF TransferExtendedText.PurchCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
        CurrPage.SAVERECORD;
        TransferExtendedText.InsertPurchExtText(Rec);
      END;
      IF TransferExtendedText.MakeUpdate THEN
        UpdateForm(TRUE);
    END;

    [External]
    PROCEDURE UpdateForm@12(SetSaveRecord@1000 : Boolean);
    BEGIN
      CurrPage.UPDATE(SetSaveRecord);
    END;

    LOCAL PROCEDURE ShowOrders@2();
    BEGIN
      CurrentPurchLine := Rec;
      PurchLine.RESET;
      PurchLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
      PurchLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
      PurchLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
    END;

    LOCAL PROCEDURE ShowInvoices@4();
    BEGIN
      CurrentPurchLine := Rec;
      PurchLine.RESET;
      PurchLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Invoice);
      PurchLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
      PurchLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
    END;

    LOCAL PROCEDURE ShowReturnOrders@9();
    BEGIN
      CurrentPurchLine := Rec;
      PurchLine.RESET;
      PurchLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::"Return Order");
      PurchLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
      PurchLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
    END;

    LOCAL PROCEDURE ShowCreditMemos@10();
    BEGIN
      CurrentPurchLine := Rec;
      PurchLine.RESET;
      PurchLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::"Credit Memo");
      PurchLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
      PurchLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
    END;

    LOCAL PROCEDURE ShowPostedReceipts@17();
    VAR
      PurchRcptLine@1000 : Record 121;
    BEGIN
      CurrentPurchLine := Rec;
      PurchRcptLine.RESET;
      PurchRcptLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
      PurchRcptLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
      PurchRcptLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Posted Purchase Receipt Lines",PurchRcptLine);
    END;

    LOCAL PROCEDURE ShowPostedInvoices@14();
    VAR
      PurchInvLine@1000 : Record 123;
    BEGIN
      CurrentPurchLine := Rec;
      PurchInvLine.RESET;
      PurchInvLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
      PurchInvLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
      PurchInvLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice Lines",PurchInvLine);
    END;

    LOCAL PROCEDURE ShowPostedReturnReceipts@13();
    VAR
      ReturnShptLine@1000 : Record 6651;
    BEGIN
      CurrentPurchLine := Rec;
      ReturnShptLine.RESET;
      ReturnShptLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
      ReturnShptLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
      ReturnShptLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Posted Return Shipment Lines",ReturnShptLine);
    END;

    LOCAL PROCEDURE ShowPostedCreditMemos@11();
    VAR
      PurchCrMemoLine@1000 : Record 125;
    BEGIN
      CurrentPurchLine := Rec;
      PurchCrMemoLine.RESET;
      PurchCrMemoLine.SETCURRENTKEY("Blanket Order No.","Blanket Order Line No.");
      PurchCrMemoLine.SETRANGE("Blanket Order No.",CurrentPurchLine."Document No.");
      PurchCrMemoLine.SETRANGE("Blanket Order Line No.",CurrentPurchLine."Line No.");
      PAGE.RUNMODAL(PAGE::"Posted Purchase Cr. Memo Lines",PurchCrMemoLine);
    END;

    LOCAL PROCEDURE NoOnAfterValidate@19066594();
    BEGIN
      InsertExtendedText(FALSE);
    END;

    LOCAL PROCEDURE CrossReferenceNoOnAfterValidat@19048248();
    BEGIN
      InsertExtendedText(FALSE);
    END;

    LOCAL PROCEDURE RedistributeTotalsOnAfterValidate@8();
    BEGIN
      CurrPage.SAVERECORD;

      PurchHeader.GET("Document Type","Document No.");
      IF DocumentTotals.PurchaseCheckNumberOfLinesLimit(PurchHeader) THEN
        DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE UpdateCurrency@1();
    BEGIN
      IF Currency.Code <> TotalPurchaseHeader."Currency Code" THEN
        IF NOT Currency.GET(TotalPurchaseHeader."Currency Code") THEN BEGIN
          CLEAR(Currency);
          Currency.InitRoundingPrecision;
        END
    END;

    BEGIN
    END.
  }
}

