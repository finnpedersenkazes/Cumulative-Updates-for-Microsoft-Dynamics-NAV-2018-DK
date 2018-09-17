OBJECT Page 6641 Purchase Return Order Subform
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table39;
    DelayedInsert=Yes;
    SourceTableView=WHERE(Document Type=FILTER(Return Order));
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInit=VAR
             ApplicationAreaSetup@1000 : Record 9178;
           BEGIN
             TempOptionLookupBuffer.FillBuffer(TempOptionLookupBuffer."Lookup Type"::Purchases);
             IsFoundation := ApplicationAreaSetup.IsFoundationEnabled;
             Currency.InitRoundingPrecision;
           END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                       CLEAR(DocumentTotals);
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
                     ReservePurchLine@1000 : Codeunit 99000834;
                   BEGIN
                     IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
                       COMMIT;
                       IF NOT ReservePurchLine.DeleteLineConfirm(Rec) THEN
                         EXIT(FALSE);
                       ReservePurchLine.DeleteLine(Rec);
                     END;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateEditableOnRow;
                           IF PurchHeader.GET("Document Type","Document No.") THEN;

                           DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);
                           DocumentTotals.PurchaseUpdateTotalsControls(Rec,TotalPurchaseHeader,TotalPurchaseLine,RefreshMessageEnabled,
                             TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,VATAmount);
                           UpdateCurrency;
                           UpdateTypeText;
                           SetItemChargeFieldsStyle;
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1903098704;2 ;Action    ;
                      AccessByPermission=TableData 90=R;
                      CaptionML=[DAN=&Udfold stykliste;
                                 ENU=E&xplode BOM];
                      ToolTipML=[DAN=Indsët nye linjer for komponenterne pÜ styklisten, f.eks. for at sëlge den overordnede vare som en pakke. ADVARSEL! Linjen for den overordnede vare bliver slettet og kun reprësenteret af en beskrivelse. Hvis du vil fortryde, skal du slette komponentlinjerne og tilfõje en linje igen for den overordnede vare.;
                                 ENU=Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.];
                      ApplicationArea=#PurchReturnOrder;
                      Image=ExplodeBOM;
                      OnAction=BEGIN
                                 ExplodeBOM;
                               END;
                                }
      { 1901742204;2 ;Action    ;
                      AccessByPermission=TableData 279=R;
                      CaptionML=[DAN=&Indsët udv. tekster;
                                 ENU=Insert &Ext. Texts];
                      ToolTipML=[DAN=Indsët den forlëngede varebeskrivelse, som hõrer til varen, der behandles pÜ linjen.;
                                 ENU=Insert the extended item description that is set up for the item that is being processed on the line.];
                      ApplicationArea=#PurchReturnOrder;
                      Image=Text;
                      OnAction=BEGIN
                                 InsertExtendedText(TRUE);
                               END;
                                }
      { 1902479904;2 ;Action    ;
                      Name=Reserve;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=ReservÇr en eller flere enheder af varen pÜ sagsplanlëgningslinjen, enten fra lageret eller den indgÜende forsyning.;
                                 ENU=Reserve one or more units of the item on the job planning line, either from inventory or from incoming supply.];
                      ApplicationArea=#Advanced;
                      Image=Reserve;
                      OnAction=BEGIN
                                 PageShowReservation;
                               END;
                                }
      { 1906421304;2 ;Action    ;
                      CaptionML=[DAN=&Ordresporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil hõrende efterspõrgsel. PÜ denne mÜde kan du finde den oprindelige efterspõrgsel, der medfõrte en specifik produktionsordre eller kõbsordre.;
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
      { 1903645704;2 ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilgëngelige saldo for en vare udvikler sig over tid i henhold til udbud og efterspõrgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 1903587104;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller mÜned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByPeriod)
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
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByVariant)
                               END;
                                }
      { 1900296704;3 ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByLocation)
                               END;
                                }
      { 7       ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=FÜ vist tilgëngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret pÜ tilgëngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByBOM)
                               END;
                                }
      { 1902740304;2 ;Action    ;
                      Name=Dimensions;
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
      { 1900920004;2 ;Action    ;
                      Name=Comments;
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
      { 1907184504;2 ;Action    ;
                      AccessByPermission=TableData 5800=R;
                      CaptionML=[DAN=Varege&byrtildeling;
                                 ENU=Item Charge &Assignment];
                      ToolTipML=[DAN=Tildel ekstra direkte omkostninger, f.eks. for fragt, pÜ varen pÜ linjen.;
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
                      ToolTipML=[DAN=FÜ vist eller rediger serienummer og lotnumre, der er tildelt varen pÜ bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
      { 27      ;2   ;Action    ;
                      Name=DeferralSchedule;
                      CaptionML=[DAN=Periodiseringsplan;
                                 ENU=Deferral Schedule];
                      ToolTipML=[DAN=FÜ vist den periodiseringsplan, som styrer, hvordan udgifter, der betales med dette kõbsdokument, blev periodiseret til forskellige regnskabsperioder, da dokumentet blev bogfõrt.;
                                 ENU=View the deferral schedule that governs how expenses paid with this purchase document were deferred to different accounting periods when the document was posted.];
                      ApplicationArea=#Suite;
                      Enabled="Deferral Code" <> '';
                      Image=PaymentPeriod;
                      OnAction=VAR
                                 DeferralUtilities@1000 : Codeunit 1720;
                               BEGIN
                                 PurchHeader.GET("Document Type","Document No.");
                                 IF ShowDeferrals(PurchHeader."Posting Date",PurchHeader."Currency Code") THEN BEGIN
                                   "Returns Deferral Start Date" :=
                                     DeferralUtilities.GetDeferralStartDate(DeferralUtilities.GetPurchDeferralDocType,"Document Type",
                                       "Document No.","Line No.","Deferral Code",PurchHeader."Posting Date");
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
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
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

    { 29  ;2   ;Field     ;
                Name=FilteredTypeField;
                CaptionML=[DAN=Type;
                           ENU=Type];
                ToolTipML=[DAN=Angiver typen af objekt, der skal bogfõres for denne kõbslinje, f.eks. vare eller finanskonto.;
                           ENU=Specifies the type of entity that will be posted for this purchase line, such as Item,, or G/L Account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TypeAsText;
                TableRelation="Option Lookup Buffer"."Option Caption" WHERE (Lookup Type=CONST(Purchases));
                Visible=IsFoundation;
                LookupPageID=Option Lookup List;
                OnValidate=BEGIN
                             IF TempOptionLookupBuffer.AutoCompleteOption(TypeAsText,TempOptionLookupBuffer."Lookup Type"::Purchases) THEN
                               VALIDATE(Type,TempOptionLookupBuffer.ID);
                             TempOptionLookupBuffer.ValidateOption(TypeAsText);
                             UpdateEditableOnRow;
                             UpdateTypeText;
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ en finanskonto, en vare, en ekstra kostpris eller et anlëg, afhëngig af hvad du har valgt i feltet Type.;
                           ENU=Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="No.";
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                             NoOnAfterValidate;

                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                             UpdateTypeText;
                           END;

                ShowMandatory=NOT IsCommentLine }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dit og din kreditors og debitors varenummer, vil dette nummer tilsidesëtte standardvarenummeret, nÜr du angiver krydsreferencenummeret pÜ et salgs- eller kõbsbilag.;
                           ENU=Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor's or customer's item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.];
                ApplicationArea=#PurchReturnOrder;
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

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den vare eller konto i IC-partnerens virksomhed, der svarer til varen eller kontoen pÜ linjen.;
                           ENU=Specifies the item or account in your IC partner's company that corresponds to the item or account on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Ref. Type";
                Visible=FALSE }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den koncernspecifikke partner. Hvis denne linje sendes til en af dine koncerninterne partnere, bruges dette felt sammen med feltet Ref.type for IC-partner for at angive den vare eller den konto i partnerens regnskab, der svarer til linjen.;
                           ENU=Specifies the IC partner. If the line is being sent to one of your intercompany partners, this field is used together with the IC Partner Ref. Type field to indicate the item or account in your partner's company that corresponds to the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Reference";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen ikke er en lagervare.;
                           ENU=Specifies that this item is a nonstock item.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsproduktbogfõringsgruppen. Knytter forretningstransaktioner for varen, ressourcen eller finanskontoen til finansregnskabet for at gõre rede for momsbelõbet som fõlge af handlen med den pÜgëldende record.;
                           ENU=Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten for det produkt, der skal kõbes. Hvis du vil tilfõje en ikke-transaktionsbaseret tekstlinje, skal du kun udfylde feltet Beskrivelse.;
                           ENU=Specifies a description of the entry of the product to be purchased. To add a non-transactional text line, fill in the Description field only.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=Description }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Return Reason Code" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller lëgges pÜ lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal angives pÜ linjen.;
                           ENU=Specifies the number of units of the item specified on the line.];
                ApplicationArea=#PurchReturnOrder;
                BlankZero=Yes;
                SourceExpr=Quantity;
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;

                ShowMandatory=(NOT IsCommentLine) AND ("No." <> '') }

    { 84  ;2   ;Field     ;
                Name=Reserved Quantity;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den pÜgëldende vare der er blevet reserveret.;
                           ENU=Specifies how many units of the item on the line have been reserved.];
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
                             }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Unit of Measure Code";
                Visible=FALSE;
                Enabled=UnitofMeasureCodeIsChangeable;
                Editable=UnitofMeasureCodeIsChangeable;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enheden.;
                           ENU=Specifies the unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#PurchReturnOrder;
                BlankZero=Yes;
                SourceExpr="Direct Unit Cost";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;

                ShowMandatory=(NOT IsCommentLine) AND ("No." <> '') }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste kõbspris, der omfatter indirekte omkostninger, sÜsom fragt, der er knyttet til kõbet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Indirect Cost %";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens enhedspris pÜ kladdelinjen.;
                           ENU=Specifies the unit cost of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen i RV for en enhed af varen.;
                           ENU=Specifies the price, in LCY, for one unit of the item.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Unit Price (LCY)";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen pÜ linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#PurchReturnOrder;
                BlankZero=Yes;
                SourceExpr="Line Discount %";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobelõb uden eventuelt fakturarabatbelõb, som skal betales for produkterne pÜ linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#PurchReturnOrder;
                BlankZero=Yes;
                SourceExpr="Line Amount";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbelõb, der ydes pÜ varen, pÜ linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Line Discount Amount";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, nÜr fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fakturarabatbelõbet for hele linjen.;
                           ENU=Specifies the invoice discount amount for the line.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der mangler at blive afsendt.;
                           ENU=Specifies the quantity of items that remains to be shipped.];
                ApplicationArea=#PurchReturnOrder;
                BlankZero=Yes;
                SourceExpr="Return Qty. to Ship";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den pÜgëldende vare der allerede er blevet bogfõrt som leveret.;
                           ENU=Specifies how many units of the item on the line have been posted as shipped.];
                ApplicationArea=#PurchReturnOrder;
                BlankZero=Yes;
                SourceExpr="Return Qty. Shipped";
                Enabled=NOT IsCommentLine }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler at blive faktureret. Det beregnes som Antal - Faktureret antal.;
                           ENU=Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.];
                ApplicationArea=#PurchReturnOrder;
                BlankZero=Yes;
                SourceExpr="Qty. to Invoice" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den pÜgëldende vare der allerede er blevet bogfõrt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#PurchReturnOrder;
                BlankZero=Yes;
                SourceExpr="Quantity Invoiced" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kan tildele varegebyrer til linjen.;
                           ENU=Specifies that you can assign item charges to this line.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Allow Item Charge Assignment";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
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
                             }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor meget af varegebyret som er blevet tildelt.;
                           ENU=Specifies how much of the item charge that has been assigned.];
                ApplicationArea=#ItemCharges;
                BlankZero=Yes;
                SourceExpr="Qty. Assigned";
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              ShowItemChargeAssgnt;
                              UpdateForm(FALSE);
                            END;
                             }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Prod. Order No.";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forsikringsnummer, der bruges til at bogfõre forsikringsposten.;
                           ENU=Specifies the insurance number to post an insurance coverage entry to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Insurance No.";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angivet nummeret for et anlëgsaktiv, hvor afkrydsningsfeltet Budgetanlëg er markeret. NÜr du bogfõrer kladde- eller bilagslinje, oprettes en ekstra post for det budgetterede anlëgsaktiv, hvor belõbet har det modsatte fortegn.;
                           ENU=Specifies the number of a fixed asset with the Budgeted Asset check box selected. When you post the journal or document line, an additional entry is created for the budgeted fixed asset where the amount has the opposite sign.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Budgeted FA No.";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, der skal benyttes pÜ relaterede anlëgsfinansposter.;
                           ENU=Specifies the date that will be used on related fixed asset ledger entries.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="FA Posting Type";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om afskrivningen er beregnet op til linjens anlëgsbogfõringsdato.;
                           ENU=Specifies if depreciation was calculated until the FA posting date of the line.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Depr. until FA Posting Date";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogfõres til, hvis du har valgt Anlëgsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Depreciation Book Code";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den ekstra anskaffelsespris, der er bogfõrt pÜ linjen, blev afskrevet (da denne linje blev bogfõrt) i forhold til det belõb, som anlëgget allerede var afskrevet med.;
                           ENU=Specifies if, when this line was posted, the additional acquisition cost posted on the line was depreciated in proportion to the amount by which the fixed asset had already been depreciated.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Depr. Acquisition Cost";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette dokument eller denne kladdelinje udlignes pÜ.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied -to.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No.";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kladdelinjetype, der oprettes i tabellen Sagsplanlëgningslinje ud fra linjen.;
                           ENU=Specifies the type of journal line that is created in the Job Planning Line table from this line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Type";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den periodiseringsskabelon, der styrer, hvordan udgifter der er betalt med dette kõbsbilag, periodiseres til forskellige regnskabsperioder, nÜr udgiften eller indtëgten indtrëffer.;
                           ENU=Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Deferral Code";
                TableRelation="Deferral Template"."Deferral Code";
                Visible=FALSE;
                Enabled=(Type <> Type::"Fixed Asset") AND (Type <> Type::" ") }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for returneringernes periodisering.;
                           ENU=Specifies the starting date of the returns deferral period.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr="Returns Deferral Start Date";
                Visible=FALSE;
                Enabled=(Type <> Type::"Fixed Asset") AND (Type <> Type::" ") }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
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

    { 43  ;1   ;Group     ;
                GroupType=Group }

    { 39  ;2   ;Group     ;
                GroupType=Group }

    { 37  ;3   ;Field     ;
                Name=Invoice Discount Amount;
                CaptionML=[DAN=Fakturarabatbelõb;
                           ENU=Invoice Discount Amount];
                ToolTipML=[DAN=Angiver det belõb, der beregnes og vises, i feltet Fakturarabatbelõb. Fakturarabatbelõbet fratrëkkes den vërdi, der vises i feltet I alt inkl. moms.;
                           ENU=Specifies the amount that is calculated and shown in the Invoice Discount Amount field. The invoice discount amount is deducted from the value shown in the Total Amount Incl. VAT field.];
                ApplicationArea=#PurchReturnOrder;
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
                             IF PurchaseHeader.InvoicedLineExists THEN
                               IF NOT CONFIRM(UpdateInvDiscountQst,FALSE) THEN
                                 EXIT;

                             PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(TotalPurchaseLine."Inv. Discount Amount",PurchaseHeader);
                             CurrPage.UPDATE(FALSE);
                           END;
                            }

    { 35  ;3   ;Field     ;
                Name=Invoice Disc. Pct.;
                CaptionML=[DAN=Fakturarabat i %;
                           ENU=Invoice Discount %];
                ToolTipML=[DAN=Angiver en rabatprocent, der ydes, hvis de kriterier, du har oprettet for debitoren, opfyldes. Det beregnede rabatbelõb indsëttes i feltet Fakturarabatbelõb, men du kan ëndre det manuelt.;
                           ENU=Specifies a discount percentage that is granted if criteria that you have set up for the customer are met. The calculated discount amount is inserted in the Invoice Discount Amount field, but you can change it manually.];
                ApplicationArea=#PurchReturnOrder;
                DecimalPlaces=0:2;
                SourceExpr=PurchCalcDiscByType.GetVendInvoiceDiscountPct(Rec);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 21  ;2   ;Group     ;
                GroupType=Group }

    { 19  ;3   ;Field     ;
                Name=Total Amount Excl. VAT;
                DrillDown=No;
                CaptionML=[DAN=I alt ekskl. moms;
                           ENU=Total Amount Excl. VAT];
                ToolTipML=[DAN=Angiver summen af vërdien i feltet Linjebelõb ekskl. moms pÜ alle linjer i bilaget minus eventuelle rabatbelõb i feltet Fakturarabatbelõb.;
                           ENU=Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=TotalPurchaseLine.Amount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 17  ;3   ;Field     ;
                Name=Total VAT Amount;
                CaptionML=[DAN=Moms i alt;
                           ENU=Total VAT];
                ToolTipML=[DAN=Angiver summen af momsbelõb pÜ alle linjer i bilaget.;
                           ENU=Specifies the sum of VAT amounts on all lines in the document.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=VATAmount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalVATCaption(Currency.Code);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 15  ;3   ;Field     ;
                Name=Total Amount Incl. VAT;
                CaptionML=[DAN=I alt inkl. moms;
                           ENU=Total Amount Incl. VAT];
                ToolTipML=[DAN=Angiver summen af vërdien i feltet Linjebelõb inkl. moms pÜ alle linjer i bilaget minus eventuelle rabatbelõb i feltet Fakturarabatbelõb.;
                           ENU=Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#PurchReturnOrder;
                SourceExpr=TotalPurchaseLine."Amount Including VAT";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                Editable=FALSE;
                StyleExpr=TotalAmountStyle }

    { 13  ;3   ;Field     ;
                Name=RefreshTotals;
                DrillDown=Yes;
                ApplicationArea=#PurchReturnOrder;
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
      TotalPurchaseHeader@1011 : Record 38;
      TotalPurchaseLine@1010 : Record 39;
      PurchHeader@1012 : Record 38;
      Currency@1027 : Record 4;
      ApplicationAreaSetup@1026 : Record 9178;
      TempOptionLookupBuffer@1001 : TEMPORARY Record 1670;
      TransferExtendedText@1002 : Codeunit 378;
      ItemAvailFormsMgt@1000 : Codeunit 353;
      ConnotExplodeBOMErr@1025 : TextConst 'DAN=Funktionen Udfold stykliste kan ikke anvendes, da der er faktureret en forudbetaling af kõbsordren.;ENU=You cannot use the Explode BOM function because a prepayment of the purchase order has been invoiced.';
      PurchCalcDiscByType@1020 : Codeunit 66;
      DocumentTotals@1013 : Codeunit 57;
      ShortcutDimCode@1003 : ARRAY [8] OF Code[20];
      VATAmount@1009 : Decimal;
      InvDiscAmountEditable@1008 : Boolean;
      TotalAmountStyle@1007 : Text;
      RefreshMessageEnabled@1006 : Boolean;
      RefreshMessageText@1005 : Text;
      TypeAsText@1004 : Text[30];
      ItemChargeStyleExpression@1017 : Text;
      IsCommentLine@1019 : Boolean;
      IsFoundation@1015 : Boolean;
      UnitofMeasureCodeIsChangeable@1022 : Boolean;
      UpdateInvDiscountQst@1014 : TextConst 'DAN=ên eller flere linjer er blevet faktureret. Den rabat, der er fordelt pÜ de fakturerede linjer, medregnes ikke.\\Vil du opdatere fakturarabatten?;ENU=One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?';

    [External]
    PROCEDURE ApproveCalcInvDisc@6();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)",Rec);
    END;

    LOCAL PROCEDURE ExplodeBOM@3();
    BEGIN
      IF "Prepmt. Amt. Inv." <> 0 THEN
        ERROR(ConnotExplodeBOMErr);
      CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM",Rec);
    END;

    LOCAL PROCEDURE InsertExtendedText@5(Unconditionally@1000 : Boolean);
    BEGIN
      IF TransferExtendedText.PurchCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
        CurrPage.SAVERECORD;
        TransferExtendedText.InsertPurchExtText(Rec);
      END;
      IF TransferExtendedText.MakeUpdate THEN
        UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE PageShowReservation@9();
    BEGIN
      FIND;
      ShowReservation;
    END;

    LOCAL PROCEDURE ShowTracking@13();
    VAR
      TrackingForm@1000 : Page 99000822;
    BEGIN
      TrackingForm.SetPurchLine(Rec);
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
      UpdateEditableOnRow;
      InsertExtendedText(FALSE);
      IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
         (xRec."No." <> '')
      THEN
        CurrPage.SAVERECORD;
    END;

    LOCAL PROCEDURE CrossReferenceNoOnAfterValidat@19048248();
    BEGIN
      InsertExtendedText(FALSE);
    END;

    LOCAL PROCEDURE ReverseReservedQtySign@20() : Decimal;
    BEGIN
      CALCFIELDS("Reserved Quantity");
      EXIT(-"Reserved Quantity");
    END;

    LOCAL PROCEDURE RedistributeTotalsOnAfterValidate@8();
    BEGIN
      CurrPage.SAVERECORD;

      PurchHeader.GET("Document Type","Document No.");
      IF DocumentTotals.PurchaseCheckNumberOfLinesLimit(PurchHeader) THEN
        DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE UpdateEditableOnRow@23();
    BEGIN
      UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode;
      IsCommentLine := Type = Type::" ";
    END;

    LOCAL PROCEDURE UpdateTypeText@14();
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
    END;

    LOCAL PROCEDURE SetItemChargeFieldsStyle@22();
    BEGIN
      ItemChargeStyleExpression := '';
      IF AssignedItemCharge THEN
        ItemChargeStyleExpression := 'Unfavorable';
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

