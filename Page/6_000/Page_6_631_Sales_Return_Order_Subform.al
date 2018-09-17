OBJECT Page 6631 Sales Return Order Subform
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783,NAVDK11.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table37;
    DelayedInsert=Yes;
    SourceTableView=WHERE(Document Type=FILTER(Return Order));
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInit=VAR
             ApplicationAreaSetup@1000 : Record 9178;
           BEGIN
             SalesSetup.GET;
             Currency.InitRoundingPrecision;
             TempOptionLookupBuffer.FillBuffer(TempOptionLookupBuffer."Lookup Type"::Sales);
             IsFoundation := ApplicationAreaSetup.IsFoundationEnabled;
           END;

    OnOpenPage=VAR
                 Location@1000 : Record 14;
               BEGIN
                 IF Location.READPERMISSION THEN
                   LocationCodeVisible := NOT Location.ISEMPTY;
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                       UpdateTypeText;
                       SetItemChargeFieldsStyle;
                     END;

    OnNewRecord=BEGIN
                  InitType;

                  // Default to Item for the first line and to previous line type for the others
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
                           SetLocationCodeMandatory;
                           UpdateEditableOnRow;
                           UpdateTypeText;
                           SetItemChargeFieldsStyle;
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
      { 1901991504;2 ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=&Udfold stykliste;
                                 ENU=E&xplode BOM];
                      ToolTipML=[DAN=Inds‘t nye linjer for komponenterne p† styklisten, f.eks. for at s‘lge den overordnede vare som en pakke. ADVARSEL! Linjen for den overordnede vare bliver slettet og kun repr‘senteret af en beskrivelse. Hvis du vil fortryde, skal du slette komponentlinjerne og tilf›je en linje igen for den overordnede vare.;
                                 ENU=Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.];
                      ApplicationArea=#Suite;
                      Image=ExplodeBOM;
                      OnAction=BEGIN
                                 ExplodeBOM;
                               END;
                                }
      { 1901991804;2 ;Action    ;
                      AccessByPermission=TableData 279=R;
                      CaptionML=[DAN=&Inds‘t udv. tekster;
                                 ENU=Insert &Ext. Texts];
                      ToolTipML=[DAN=Inds‘t den forl‘ngede varebeskrivelse, som h›rer til varen, der behandles p† linjen.;
                                 ENU=Insert the extended item description that is set up for the item that is being processed on the line.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Text;
                      OnAction=BEGIN
                                 InsertExtendedText(TRUE);
                               END;
                                }
      { 1902085804;2 ;Action    ;
                      Name=Reserve;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den n›dvendige m‘ngde p† den bilagslinje, som vinduet blev †bnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Advanced;
                      Image=Reserve;
                      OnAction=BEGIN
                                 PageShowReservation;
                               END;
                                }
      { 1906421304;2 ;Action    ;
                      CaptionML=[DAN=&Ordresporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den tilsvarende eftersp›rgsel. P† denne m†de kan du finde den oprindelige foresp›rgsel, der oprettede en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#ItemTracking;
                      Image=OrderTracking;
                      OnAction=BEGIN
                                 ShowTracking;
                               END;
                                }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1907981204;2 ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 1903587104;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m†ned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByPeriod)
                               END;
                                }
      { 1903193004;3 ;Action    ;
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
      { 1901743104;3 ;Action    ;
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
      { 3       ;3   ;Action    ;
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
      { 1902740304;2 ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1900525904;2 ;Action    ;
                      Name=Comments;
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
                      Name=ItemTrackingLines;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
      { 19      ;2   ;Action    ;
                      Name=DeferralSchedule;
                      CaptionML=[DAN=Periodiseringsplan;
                                 ENU=Deferral Schedule];
                      ToolTipML=[DAN=F† vist eller rediger den periodiseringsplan, der styrer, hvordan indt‘gter fra dette salgsdokument periodiseres til forskellige regnskabsperioder, n†r dokumentet bogf›res.;
                                 ENU=View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.];
                      ApplicationArea=#Advanced;
                      Enabled="Deferral Code" <> '';
                      Image=PaymentPeriod;
                      OnAction=VAR
                                 DeferralUtilities@1000 : Codeunit 1720;
                               BEGIN
                                 TotalSalesHeader.GET("Document Type","Document No.");
                                 IF ShowDeferrals(TotalSalesHeader."Posting Date",TotalSalesHeader."Currency Code") THEN BEGIN
                                   "Returns Deferral Start Date" :=
                                     DeferralUtilities.GetDeferralStartDate(DeferralUtilities.GetSalesDeferralDocType,"Document Type",
                                       "Document No.","Line No.","Deferral Code",TotalSalesHeader."Posting Date");
                                   CurrPage.SAVERECORD;
                                 END;
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
                             SetLocationCodeMandatory;

                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                             UpdateEditableOnRow;
                             UpdateTypeText;
                           END;
                            }

    { 39  ;2   ;Field     ;
                Name=FilteredTypeField;
                CaptionML=[DAN=Type;
                           ENU=Type];
                ToolTipML=[DAN=Angiver typen af objekt, der skal bogf›res for denne k›bslinje, f.eks. vare eller finanskonto.;
                           ENU=Specifies the type of entity that will be posted for this purchase line, such as Item,, or G/L Account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TypeAsText;
                TableRelation="Option Lookup Buffer"."Option Caption" WHERE (Lookup Type=CONST(Purchases));
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
                             NoOnAfterValidate;
                             UpdateEditableOnRow;
                             ShowShortcutDimCode(ShortcutDimCode);

                             QuantityOnAfterValidate;
                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                             UpdateTypeText;
                           END;

                ShowMandatory=NOT IsCommentLine }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dit og din kreditors og debitors varenummer, vil dette nummer tilsides‘tte standardvarenummeret, n†r du angiver krydsreferencenummeret p† et salgs- eller k›bsbilag.;
                           ENU=Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor's or customer's item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cross-Reference No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             NoOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           CrossReferenceNoLookUp;
                           NoOnAfterValidate;
                         END;
                          }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den vare eller konto i IC-partnerens virksomhed, der svarer til varen eller kontoen p† linjen.;
                           ENU=Specifies the item or account in your IC partner's company that corresponds to the item or account on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Ref. Type";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den koncernspecifikke partner. Hvis denne linje sendes til en af dine koncerninterne partnere, bruges dette felt sammen med feltet Ref.type for IC-partner for at angive den vare eller den konto i partnerens regnskab, der svarer til linjen.;
                           ENU=Specifies the IC partner. If the line is being sent to one of your intercompany partners, this field is used together with the IC Partner Ref. Type field to indicate the item or account in your partner's company that corresponds to the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Reference";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen ikke er en lagervare.;
                           ENU=Specifies that this item is a nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsproduktbogf›ringsgruppen. Knytter forretningstransaktioner for varen, ressourcen eller finanskontoen til finansregnskabet for at g›re rede for momsbel›bet som f›lge af handlen med den p†g‘ldende record.;
                           ENU=Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten for det produkt, der skal s‘lges. Hvis du vil tilf›je en ikke-transaktionsbaseret tekstlinje, skal du kun udfylde feltet Beskrivelse.;
                           ENU=Specifies a description of the entry of the product to be sold. To add a non-transactional text line, fill in the Description field only.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                OnValidate=BEGIN
                             UpdateEditableOnRow;

                             IF "No." = xRec."No." THEN
                               EXIT;

                             NoOnAfterValidate;
                             ShowShortcutDimCode(ShortcutDimCode);
                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                             UpdateTypeText;
                           END;

                ShowMandatory=NOT IsCommentLine;
                QuickEntry=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Return Reason Code" }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvorfra lagervarer til debitoren p† salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=LocationCodeVisible;
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             LocationCodeOnAfterValidate;
                           END;

                ShowMandatory=LocationCodeMandatory;
                QuickEntry=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varer aldrig, automatisk (altid) eller eventuelt kan reserveres til denne debitor. Valgfri betyder, at du manuelt skal reservere varer til denne debitor.;
                           ENU=Specifies whether items will never, automatically (Always), or optionally be reserved for this customer. Optional means that you must manually reserve items for this customer.];
                ApplicationArea=#Advanced;
                SourceExpr=Reserve;
                Visible=FALSE;
                OnValidate=BEGIN
                             ReserveOnAfterValidate;
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder der returneres.;
                           ENU=Specifies how many units are being returned.];
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

    { 26  ;2   ;Field     ;
                Name=Reserved Quantity;
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=ReverseReservedQtySign;
                CaptionClass=FIELDCAPTION("Reserved Quantity");
                Visible=FALSE;
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              COMMIT;
                              ShowReservationEntries(TRUE);
                              UpdateForm(TRUE);
                            END;

                QuickEntry=FALSE }

    { 22  ;2   ;Field     ;
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

                QuickEntry=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver m†leenheden for varen eller ressourcen p† salgslinjen.;
                           ENU=Specifies the unit of measure for the item or resource on the sales line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens enhedspris p† kladdelinjen.;
                           ENU=Specifies the unit cost of the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed p† salgslinjen.;
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

    { 92  ;2   ;Field     ;
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

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel›b, der ydes p† varen, p† linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Line Discount Amount";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 54  ;2   ;Field     ;
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

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fakturarabatbel›bet for hele linjen.;
                           ENU=Specifies the invoice discount amount for the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der mangler at blive afsendt.;
                           ENU=Specifies the quantity of items that remain to be shipped.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Return Qty. to Receive" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der allerede er blevet bogf›rt som leveret.;
                           ENU=Specifies how many units of the item on the line have been posted as shipped.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Return Qty. Received" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler at blive faktureret. Det beregnes som Antal - Faktureret antal.;
                           ENU=Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Qty. to Invoice" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der allerede er blevet bogf›rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Quantity Invoiced" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kan tildele varegebyrer til linjen.;
                           ENU=Specifies that you can assign item charges to this line.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Allow Item Charge Assignment";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varegebyret bliver tildelt linjen.;
                           ENU=Specifies how many units of the item charge will be assigned to the line.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Qty. to Assign";
                StyleExpr=ItemChargeStyleExpression;
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              ShowItemChargeAssgnt;
                              UpdateForm(FALSE);
                            END;

                QuickEntry=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varegebyrer, der var tildelt en bestemt vare, da du bogf›rte salgslinjen.;
                           ENU=Specifies the quantity of the item charge that was assigned to a specified item when you posted this sales line.];
                ApplicationArea=#ItemCharges;
                BlankZero=Yes;
                SourceExpr="Qty. Assigned";
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              ShowItemChargeAssgnt;
                              UpdateForm(FALSE);
                            END;

                QuickEntry=FALSE }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Indeholder den dato, hvor debitoren har ›nsket varerne leveret.;
                           ENU=Specifies the date that the customer has asked for the order to be delivered.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Requested Delivery Date";
                Visible=FALSE;
                OnValidate=BEGIN
                             UpdateForm(TRUE);
                           END;
                            }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du har lovet at levere ordren som resultat af funktionen Beregning af leveringstid.;
                           ENU=Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.];
                ApplicationArea=#Advanced;
                SourceExpr="Promised Delivery Date";
                Visible=FALSE;
                OnValidate=BEGIN
                             UpdateForm(TRUE);
                           END;
                            }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den planlagte dato, hvor leverancen leveres p† debitorens adresse. Hvis debitoren anmoder om en leveringsdato, beregner programmet, om varerne er disponible for levering p† denne dato. Hvis varerne er disponible, er den planlagte leveringsdato den samme som den anmodede leveringsdato. Hvis ikke, beregner programmet den dato, hvor varerne er disponible for levering, og angiver denne dato i feltet Planlagt leveringsdato.;
                           ENU=Specifies the planned date that the shipment will be delivered at the customer's address. If the customer requests a delivery date, the program calculates whether the items will be available for delivery on this date. If the items are available, the planned delivery date will be the same as the requested delivery date. If not, the program calculates the date that the items are available for delivery and enters this date in the Planned Delivery Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Planned Delivery Date";
                Visible=FALSE;
                OnValidate=BEGIN
                             UpdateForm(TRUE);
                           END;

                QuickEntry=FALSE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor leverancen skal sendes fra lageret. Hvis debitoren anmoder om en leveringsdato, beregner programmet den planlagte leveringsdato ved at tr‘kke fragttiden fra den anmodede leveringsdato. Hvis debitoren ikke anmoder om en leveringsdato, eller den anmodede leveringsdato ikke kan opfyldes, beregner programmet indholdet af dette felt ved at tilf›je fragttiden til leveringsdatoen.;
                           ENU=Specifies the date that the shipment should ship from the warehouse. If the customer requests a delivery date, the program calculates the planned shipment date by subtracting the shipping time from the requested delivery date. If the customer does not request a delivery date or the requested delivery date cannot be met, the program calculates the content of this field by adding the shipment time to the shipping date.];
                ApplicationArea=#Advanced;
                SourceExpr="Planned Shipment Date";
                Visible=FALSE;
                OnValidate=BEGIN
                             UpdateForm(TRUE);
                           END;
                            }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Date";
                Visible=FALSE;
                OnValidate=BEGIN
                             ShipmentDateOnAfterValidate;
                           END;

                QuickEntry=FALSE }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Shipping Agent Service Code";
                Visible=FALSE }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid der g†r, fra varerne er sendt fra lageret, til de er leveret.;
                           ENU=Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Time";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

    { 5810;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette bilag eller denne kladdelinje udlignes fra.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Appl.-from Item Entry";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette dokument eller denne kladdelinje udlignes p†.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied -to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den periodiseringsskabelon, der styrer, hvordan indt‘gter fra dette salgsdokument periodiseres til de forskellige regnskabsperioder, n†r varen eller tjenesten leveres.;
                           ENU=Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Deferral Code";
                Visible=FALSE;
                Enabled=(Type <> Type::"Fixed Asset") AND (Type <> Type::" ") }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for returneringernes periodisering.;
                           ENU=Specifies the starting date of the returns deferral period.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Returns Deferral Start Date";
                Visible=FALSE;
                Enabled=(Type <> Type::"Fixed Asset") AND (Type <> Type::" ") }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 3.;
                           ENU=Specifies the code for Shortcut Dimension 3.];
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
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 4.;
                           ENU=Specifies the code for Shortcut Dimension 4.];
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
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 5.;
                           ENU=Specifies the code for Shortcut Dimension 5.];
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
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 6.;
                           ENU=Specifies the code for Shortcut Dimension 6.];
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
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 7.;
                           ENU=Specifies the code for Shortcut Dimension 7.];
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
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 8.;
                           ENU=Specifies the code for Shortcut Dimension 8.];
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
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Account Code";
                Visible=FALSE }

    { 37  ;1   ;Group     ;
                GroupType=Group }

    { 33  ;2   ;Group     ;
                GroupType=Group }

    { 31  ;3   ;Field     ;
                Name=Invoice Discount Amount;
                CaptionML=[DAN=Fakturarabatbel›b;
                           ENU=Invoice Discount Amount];
                ToolTipML=[DAN=Angiver et rabatbel›b, der tr‘kkes fra v‘rdien i feltet I alt inkl. moms. Du kan angive eller ‘ndre bel›bet manuelt.;
                           ENU=Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=InvoiceDiscountAmount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(FIELDCAPTION("Inv. Discount Amount"),Currency.Code);
                Editable=InvDiscAmountEditable;
                Style=Subordinate;
                OnValidate=BEGIN
                             ValidateInvoiceDiscountAmount;
                           END;
                            }

    { 29  ;3   ;Field     ;
                Name=Invoice Disc. Pct.;
                CaptionML=[DAN=Fakturarabat i %;
                           ENU=Invoice Discount %];
                ToolTipML=[DAN=Angiver en rabatprocent, der ydes, hvis de kriterier, du har oprettet for debitoren, er opfyldt.;
                           ENU=Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.];
                ApplicationArea=#SalesReturnOrder;
                DecimalPlaces=0:2;
                SourceExpr=InvoiceDiscountPct;
                Editable=FALSE;
                Style=Subordinate;
                OnValidate=BEGIN
                             InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * InvoiceDiscountPct / 100,Currency."Amount Rounding Precision");
                             ValidateInvoiceDiscountAmount;
                           END;
                            }

    { 15  ;2   ;Group     ;
                GroupType=Group }

    { 13  ;3   ;Field     ;
                Name=Total Amount Excl. VAT;
                DrillDown=No;
                CaptionML=[DAN=I alt ekskl. moms;
                           ENU=Total Amount Excl. VAT];
                ToolTipML=[DAN=Angiver summen af v‘rdien i feltet Linjebel›b ekskl. moms p† alle linjer i bilaget minus eventuelle rabatbel›b i feltet Fakturarabatbel›b.;
                           ENU=Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TotalSalesLine.Amount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                Editable=FALSE;
                Style=Subordinate }

    { 11  ;3   ;Field     ;
                Name=Total VAT Amount;
                CaptionML=[DAN=Moms i alt;
                           ENU=Total VAT];
                ToolTipML=[DAN=Angiver summen af momsbel›b p† alle linjer i bilaget.;
                           ENU=Specifies the sum of VAT amounts on all lines in the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=VATAmount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalVATCaption(Currency.Code);
                Editable=FALSE;
                Style=Subordinate }

    { 9   ;3   ;Field     ;
                Name=Total Amount Incl. VAT;
                CaptionML=[DAN=I alt inkl. moms;
                           ENU=Total Amount Incl. VAT];
                ToolTipML=[DAN=Angiver summen af v‘rdien i feltet Linjebel›b inkl. moms p† alle linjer i bilaget minus eventuelle rabatbel›b i feltet Fakturarabatbel›b.;
                           ENU=Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TotalSalesLine."Amount Including VAT";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                Editable=FALSE }

    { 7   ;3   ;Field     ;
                Name=RefreshTotals;
                DrillDown=Yes;
                ApplicationArea=#SalesReturnOrder;
                SourceExpr=RefreshMessageText;
                Editable=FALSE;
                OnDrillDown=VAR
                              SalesHeader@1000 : Record 36;
                            BEGIN
                              IF SalesHeader.GET("Document Type","Document No.") THEN BEGIN
                                SalesHeader."Invoice Discount Value" := InvoiceDiscountAmount;
                                SalesHeader.MODIFY;
                              END;
                              DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
                              CurrPage.UPDATE(FALSE);
                            END;

                ShowCaption=No }

  }
  CODE
  {
    VAR
      Currency@1021 : Record 4;
      TotalSalesHeader@1005 : Record 36;
      TotalSalesLine@1004 : Record 37;
      ApplicationAreaSetup@1028 : Record 9178;
      SalesSetup@1022 : Record 311;
      TempOptionLookupBuffer@1013 : TEMPORARY Record 1670;
      TransferExtendedText@1000 : Codeunit 378;
      ItemAvailFormsMgt@1002 : Codeunit 353;
      SalesCalcDiscByType@1008 : Codeunit 56;
      DocumentTotals@1007 : Codeunit 57;
      VATAmount@1006 : Decimal;
      AmountWithDiscountAllowed@1009 : Decimal;
      InvoiceDiscountAmount@1012 : Decimal;
      InvoiceDiscountPct@1010 : Decimal;
      ShortcutDimCode@1017 : ARRAY [8] OF Code[20];
      LocationCodeMandatory@1018 : Boolean;
      InvDiscAmountEditable@1014 : Boolean;
      RefreshMessageText@1011 : Text;
      TypeAsText@1016 : Text[30];
      ItemChargeStyleExpression@1026 : Text;
      IsFoundation@1015 : Boolean;
      UnitofMeasureCodeIsChangeable@1027 : Boolean;
      LocationCodeVisible@1020 : Boolean;
      IsCommentLine@1024 : Boolean;

    [External]
    PROCEDURE ApproveCalcInvDisc@1();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
    END;

    [External]
    PROCEDURE CalcInvDisc@6();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",Rec);
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

    LOCAL PROCEDURE PageShowReservation@2();
    BEGIN
      FIND;
      ShowReservation;
    END;

    LOCAL PROCEDURE ShowTracking@13();
    VAR
      TrackingForm@1000 : Page 99000822;
    BEGIN
      TrackingForm.SetSalesLine(Rec);
      TrackingForm.RUNMODAL;
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

    LOCAL PROCEDURE NoOnAfterValidate@19066594();
    BEGIN
      InsertExtendedText(FALSE);
      IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
         (xRec."No." <> '')
      THEN
        CurrPage.SAVERECORD;
    END;

    LOCAL PROCEDURE LocationCodeOnAfterValidate@8594();
    BEGIN
      IF (Reserve = Reserve::Always) AND
         ("Outstanding Qty. (Base)" <> 0) AND
         ("Location Code" <> xRec."Location Code")
      THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE ReserveOnAfterValidate@19004502();
    BEGIN
      IF (Reserve = Reserve::Always) AND ("Outstanding Qty. (Base)" <> 0) THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE QuantityOnAfterValidate@19032465();
    BEGIN
      IF Reserve = Reserve::Always THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE ShipmentDateOnAfterValidate@2525();
    BEGIN
      IF (Reserve = Reserve::Always) AND
         ("Outstanding Qty. (Base)" <> 0) AND
         ("Shipment Date" <> xRec."Shipment Date")
      THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
        CurrPage.UPDATE(FALSE);
      END ELSE
        CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE UnitofMeasureCodeOnAfterValida@19057939();
    BEGIN
      IF Reserve = Reserve::Always THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
      END;
    END;

    LOCAL PROCEDURE SetLocationCodeMandatory@22();
    VAR
      InventorySetup@1000 : Record 313;
    BEGIN
      InventorySetup.GET;
      LocationCodeMandatory := InventorySetup."Location Mandatory" AND (Type = Type::Item);
    END;

    LOCAL PROCEDURE GetTotalSalesHeader@9();
    BEGIN
      IF NOT TotalSalesHeader.GET("Document Type","Document No.") THEN
        CLEAR(TotalSalesHeader);
      IF Currency.Code <> TotalSalesHeader."Currency Code" THEN
        IF NOT Currency.GET(TotalSalesHeader."Currency Code") THEN
          Currency.InitRoundingPrecision;
    END;

    LOCAL PROCEDURE CalculateTotals@26();
    BEGIN
      GetTotalSalesHeader;
      TotalSalesHeader.CALCFIELDS("Recalculate Invoice Disc.");

      IF SalesSetup."Calc. Inv. Discount" AND ("Document No." <> '') AND (TotalSalesHeader."Customer Posting Group" <> '') AND
         TotalSalesHeader."Recalculate Invoice Disc."
      THEN
        IF FIND THEN
          CalcInvDisc;

      DocumentTotals.CalculateSalesTotals(TotalSalesLine,VATAmount,Rec);
      AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
      InvoiceDiscountAmount := TotalSalesLine."Inv. Discount Amount";
      InvoiceDiscountPct := SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec);
    END;

    LOCAL PROCEDURE RedistributeTotalsOnAfterValidate@8();
    BEGIN
      CurrPage.SAVERECORD;

      TotalSalesHeader.GET("Document Type","Document No.");
      DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ReverseReservedQtySign@7() : Decimal;
    BEGIN
      CALCFIELDS("Reserved Quantity");
      EXIT(-"Reserved Quantity");
    END;

    LOCAL PROCEDURE UpdateEditableOnRow@18();
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

    LOCAL PROCEDURE UpdateTypeText@10();
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
    END;

    LOCAL PROCEDURE SetItemChargeFieldsStyle@24();
    BEGIN
      ItemChargeStyleExpression := '';
      IF AssignedItemCharge THEN
        ItemChargeStyleExpression := 'Unfavorable';
    END;

    LOCAL PROCEDURE UpdateCurrency@4();
    BEGIN
      IF Currency.Code <> TotalSalesHeader."Currency Code" THEN
        IF NOT Currency.GET(TotalSalesHeader."Currency Code") THEN BEGIN
          CLEAR(Currency);
          Currency.InitRoundingPrecision;
        END
    END;

    LOCAL PROCEDURE ValidateInvoiceDiscountAmount@30();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader.GET("Document Type","Document No.");
      SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

