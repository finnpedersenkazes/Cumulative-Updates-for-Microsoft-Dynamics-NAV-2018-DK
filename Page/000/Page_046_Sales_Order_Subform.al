OBJECT Page 46 Sales Order Subform
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348,NAVDK11.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table37;
    DelayedInsert=Yes;
    SourceTableView=WHERE(Document Type=FILTER(Order));
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
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1906587504;2 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1905623604;3 ;Action    ;
                      Name=GetPrice;
                      AccessByPermission=TableData 7002=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent pris;
                                 ENU=Get Price];
                      ToolTipML=[DAN=Inds‘t den laveste mulige pris i feltet Enhedspris i henhold til enhver specialpris, du har angivet.;
                                 ENU=Insert the lowest possible price in the Unit Price field according to any special price that you have set up.];
                      ApplicationArea=#Advanced;
                      Image=Price;
                      OnAction=BEGIN
                                 ShowPrices;
                               END;
                                }
      { 1901770504;3 ;Action    ;
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
      { 1901741804;3 ;Action    ;
                      Name=ExplodeBOM_Functions;
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
      { 1903099004;3 ;Action    ;
                      Name=Insert Ext. Texts;
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
      { 1905427504;3 ;Action    ;
                      Name=Reserve;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den n›dvendige m‘ngde p† den bilagslinje, som vinduet blev †bnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Advanced;
                      Image=Reserve;
                      OnAction=BEGIN
                                 FIND;
                                 ShowReservation;
                               END;
                                }
      { 1903502504;3 ;Action    ;
                      Name=OrderTracking;
                      CaptionML=[DAN=&Ordresporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den tilsvarende eftersp›rgsel. P† denne m†de kan du finde den oprindelige foresp›rgsel, der oprettede en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Advanced;
                      Image=OrderTracking;
                      OnAction=BEGIN
                                 ShowTracking;
                               END;
                                }
      { 1905968604;3 ;Action    ;
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
      { 1900580804;2 ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 5       ;3   ;Action    ;
                      Name=<Action3>;
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
      { 1904522204;3 ;Action    ;
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
      { 1902056104;3 ;Action    ;
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
      { 1900639404;3 ;Action    ;
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
      { 15      ;3   ;Action    ;
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
      { 33      ;2   ;ActionGroup;
                      CaptionML=[DAN=Relaterede oplysninger;
                                 ENU=Related Information] }
      { 1900186704;3 ;Action    ;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=Reservationsposter;
                                 ENU=Reservation Entries];
                      ToolTipML=[DAN=Vis posterne for hver reservation, der er foretaget, enten manuelt eller automatisk.;
                                 ENU=View the entries for every reservation that is made, either manually or automatically.];
                      ApplicationArea=#Advanced;
                      Image=ReservationLedger;
                      OnAction=BEGIN
                                 ShowReservationEntries(TRUE);
                               END;
                                }
      { 1905987604;3 ;Action    ;
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
      { 1901633104;3 ;Action    ;
                      Name=SelectItemSubstitution;
                      AccessByPermission=TableData 5715=R;
                      CaptionML=[DAN=V‘lg erstatningsvare;
                                 ENU=Select Item Substitution];
                      ToolTipML=[DAN=V‘lg en anden vare, der er blevet konfigureret til at blive solgt i stedet for den originale vare, hvis den ikke er tilg‘ngelig.;
                                 ENU=Select another item that has been set up to be sold instead of the original item if it is unavailable.];
                      ApplicationArea=#Suite;
                      Image=SelectItemSubstitution;
                      OnAction=BEGIN
                                 CurrPage.SAVERECORD;
                                 ShowItemSub;
                                 CurrPage.UPDATE(TRUE);
                                 AutoReserve;
                               END;
                                }
      { 1902085804;3 ;Action    ;
                      Name=Dimensions;
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
      { 1903418704;3 ;Action    ;
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
      { 1907184504;3 ;Action    ;
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
      { 1905403704;3 ;Action    ;
                      Name=OrderPromising;
                      AccessByPermission=TableData 99000880=R;
                      CaptionML=[DAN=Beregning af leverings&tid;
                                 ENU=Order &Promising];
                      ToolTipML=[DAN=Beregn afsendelses- og leveringsdatoerne ud fra varens kendte og forventede tilg‘ngelighedsdatoer, og oplys derefter datoerne til debitoren.;
                                 ENU=Calculate the shipment and delivery dates based on the item's known and expected availability dates, and then promise the dates to the customer.];
                      ApplicationArea=#Planning;
                      Image=OrderPromising;
                      OnAction=BEGIN
                                 OrderPromisingLine;
                               END;
                                }
      { 7       ;3   ;ActionGroup;
                      CaptionML=[DAN=Montage til ordre;
                                 ENU=Assemble to Order];
                      ActionContainerType=NewDocumentItems;
                      Image=AssemblyBOM }
      { 9       ;4   ;Action    ;
                      Name=AssembleToOrderLines;
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
      { 11      ;4   ;Action    ;
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
      { 13      ;4   ;Action    ;
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
      { 31      ;3   ;Action    ;
                      Name=DeferralSchedule;
                      CaptionML=[DAN=Periodiseringsplan;
                                 ENU=Deferral Schedule];
                      ToolTipML=[DAN=F† vist eller rediger den periodiseringsplan, der styrer, hvordan indt‘gter fra dette salgsdokument periodiseres til forskellige regnskabsperioder, n†r dokumentet bogf›res.;
                                 ENU=View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.];
                      ApplicationArea=#Suite;
                      Enabled="Deferral Code" <> '';
                      Image=PaymentPeriod;
                      OnAction=BEGIN
                                 SalesHeader.GET("Document Type","Document No.");
                                 ShowDeferrals(SalesHeader."Posting Date",SalesHeader."Currency Code");
                               END;
                                }
      { 1905926804;1 ;ActionGroup;
                      CaptionML=[DAN=O&rdre;
                                 ENU=O&rder];
                      Image=Order }
      { 1903645604;2 ;ActionGroup;
                      CaptionML=[DAN=Di&rekte levering;
                                 ENU=Dr&op Shipment];
                      Image=Delivery }
      { 1907981104;3 ;Action    ;
                      AccessByPermission=TableData 120=R;
                      CaptionML=[DAN=K›bs&ordre;
                                 ENU=Purchase &Order];
                      ToolTipML=[DAN=Vis den k›bsordre, der er sammenk‘det med salgsordren, ved direkte levering eller specialordre.;
                                 ENU=View the purchase order that is linked to the sales order, for drop shipment or special order.];
                      ApplicationArea=#Suite;
                      Image=Document;
                      OnAction=BEGIN
                                 OpenPurchOrderForm;
                               END;
                                }
      { 1903587004;2 ;ActionGroup;
                      CaptionML=[DAN=Spe&cialordre;
                                 ENU=Speci&al Order];
                      Image=SpecialOrder }
      { 1903192904;3 ;Action    ;
                      Name=OpenSpecialPurchaseOrder;
                      AccessByPermission=TableData 120=R;
                      CaptionML=[DAN=K›bs&ordre;
                                 ENU=Purchase &Order];
                      ToolTipML=[DAN=Vis den k›bsordre, der er sammenk‘det med salgsordren, ved direkte levering eller specialordre.;
                                 ENU=View the purchase order that is linked to the sales order, for drop shipment or special order.];
                      ApplicationArea=#Advanced;
                      Image=Document;
                      OnAction=BEGIN
                                 OpenSpecialPurchOrderForm;
                               END;
                                }
      { 666     ;2   ;Action    ;
                      Name=BlanketOrder;
                      CaptionML=[DAN=Rammeordre;
                                 ENU=Blanket Order];
                      ToolTipML=[DAN=Vis rammesalgsordren.;
                                 ENU=View the blanket sales order.];
                      ApplicationArea=#Advanced;
                      Image=BlanketOrder;
                      OnAction=VAR
                                 SalesHeader@1000 : Record 36;
                                 BlanketSalesOrder@1001 : Page 507;
                               BEGIN
                                 TESTFIELD("Blanket Order No.");
                                 SalesHeader.SETRANGE("No.","Blanket Order No.");
                                 IF NOT SalesHeader.ISEMPTY THEN BEGIN
                                   BlanketSalesOrder.SETTABLEVIEW(SalesHeader);
                                   BlanketSalesOrder.EDITABLE := FALSE;
                                   BlanketSalesOrder.RUN;
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

    { 37  ;2   ;Field     ;
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
                             NoOnAfterValidate;
                             UpdateEditableOnRow;
                             ShowShortcutDimCode(ShortcutDimCode);

                             QuantityOnAfterValidate;
                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                             UpdateTypeText;
                           END;

                ShowMandatory=NOT IsCommentLine }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dine og din kreditors og debitors varenummer, vil dette nummer tilsides‘tte standardvarenummeret, n†r du angiver krydsreferencenummeret p† et salgs- eller k›bsbilag.;
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

    { 1136;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncerninterne partner, som transaktionen er relateret til, hvis posten blev oprettet fra en koncernintern transaktion.;
                           ENU=Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Visible=FALSE }

    { 130 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den vare eller konto i IC-partnerens virksomhed, der svarer til varen eller kontoen p† linjen.;
                           ENU=Specifies the item or account in your IC partner's company that corresponds to the item or account on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Ref. Type";
                Visible=FALSE }

    { 132 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den koncernspecifikke partner. Hvis denne linje sendes til en af dine koncerninterne partnere, bruges dette felt sammen med feltet Ref.type for IC-partner for at angive den vare eller den konto i partnerens regnskab, der svarer til linjen.;
                           ENU=Specifies the IC partner. If the line is being sent to one of your intercompany partners, this field is used together with the IC Partner Ref. Type field to indicate the item or account in your partner's company that corresponds to the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Reference";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE;
                OnValidate=BEGIN
                             VariantCodeOnAfterValidate;
                           END;
                            }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der findes en erstatning for varen p† salgslinjen.;
                           ENU=Specifies that a substitute is available for the item on the sales line.];
                ApplicationArea=#Suite;
                SourceExpr="Substitution Available";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indk›ber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchasing Code";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen ikke er en lagervare.;
                           ENU=Specifies that this item is a nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 78  ;2   ;Field     ;
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

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om din kreditor sender varerne p† linjen direkte til din debitor.;
                           ENU=Specifies if your vendor ships the items directly to your customer.];
                ApplicationArea=#Suite;
                SourceExpr="Drop Shipment";
                Visible=FALSE }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen p† salgslinjen er en specialordrevare.;
                           ENU=Specifies that the item on the sales line is a special-order item.];
                ApplicationArea=#Advanced;
                SourceExpr="Special Order";
                Visible=FALSE }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken lagerlokation de solgte varer skal tages fra, og hvor lagerreduktionen registreres.;
                           ENU=Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.];
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

    { 114 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der kan foretages en reservation for varer p† denne linje.;
                           ENU=Specifies whether a reservation can be made for items on this line.];
                ApplicationArea=#Advanced;
                SourceExpr=Reserve;
                Visible=FALSE;
                OnValidate=BEGIN
                             ReserveOnAfterValidate;
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

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af salgslinjeantallet, som du vil forsyne via montage.;
                           ENU=Specifies how many units of the sales line quantity that you want to supply by assembly.];
                ApplicationArea=#Assembly;
                BlankZero=Yes;
                SourceExpr="Qty. to Assemble to Order";
                Visible=FALSE;
                OnValidate=BEGIN
                             QtyToAsmToOrderOnAfterValidate;
                           END;

                OnDrillDown=BEGIN
                              ShowAsmToOrderLines;
                            END;
                             }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der er blevet reserveret.;
                           ENU=Specifies how many units of the item on the line have been reserved.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Reserved Quantity";
                QuickEntry=FALSE }

    { 44  ;2   ;Field     ;
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

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens enhedspris p† kladdelinjen.;
                           ENU=Specifies the unit cost of the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 112 ;2   ;Field     ;
                Name=SalesPriceExist;
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

    { 76  ;2   ;Field     ;
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

    { 1060000;2;Field     ;
                ToolTipML=[DAN=Angiver bel›b inkl. moms for hele bilaget. Feltet udfyldes muligvis automatisk.;
                           ENU=Specifies the amount including VAT for the whole document. The field may be filled automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Including VAT" }

    { 116 ;2   ;Field     ;
                Name=SalesLineDiscExists;
                CaptionML=[DAN=Salgslinjerabat findes;
                           ENU=Sales Line Disc. Exists];
                ToolTipML=[DAN=Angiver, at der er en rabat, der er specifik for denne debitor.;
                           ENU=Specifies that there is a specific discount for this customer.];
                ApplicationArea=#Advanced;
                SourceExpr=LineDiscExists;
                Visible=FALSE;
                Editable=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel›b, der ydes p† varen, p† linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Line Discount Amount";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 136 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forudbetalingsprocenten, der skal bruges til at beregne forudbetalingen for salg.;
                           ENU=Specifies the prepayment percentage to use to calculate the prepayment for sales.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepayment %";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 138 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forudbetalingsbel›bet for linjen i samme valuta som salgsdokumentet, hvis der er angivet en forudbetalingsprocent for salgslinjen.;
                           ENU=Specifies the prepayment amount of the line in the currency of the sales document if a prepayment percentage is specified for the sales line.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt. Line Amount";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 140 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forudbetalingsbel›b, der allerede er faktureret til debitoren for salgslinjen.;
                           ENU=Specifies the prepayment amount that has already been invoiced to the customer for this sales line.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt. Amt. Inv.";
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
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede beregnede fakturarabatbel›b for linjen.;
                           ENU=Specifies the total calculated invoice discount amount for the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det faktiske fakturarabatbel›b, der skal bogf›res for linjen i n‘ste faktura.;
                           ENU=Specifies the actual invoice discount amount that will be posted for the line in next invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inv. Disc. Amount to Invoice";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der mangler at blive afsendt.;
                           ENU=Specifies the quantity of items that remain to be shipped.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Qty. to Ship";
                OnValidate=BEGIN
                             IF "Qty. to Asm. to Order (Base)" <> 0 THEN BEGIN
                               CurrPage.SAVERECORD;
                               CurrPage.UPDATE(FALSE);
                             END;
                           END;
                            }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der allerede er blevet bogf›rt som leveret.;
                           ENU=Specifies how many units of the item on the line have been posted as shipped.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Quantity Shipped";
                QuickEntry=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler at blive faktureret. Det beregnes som Antal - Faktureret antal.;
                           ENU=Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Qty. to Invoice" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der allerede er blevet bogf›rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Quantity Invoiced" }

    { 142 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forudbetalingsbel›b, der allerede er fratrukket almindelige fakturaer, der er bogf›rt for denne salgsordrelinje.;
                           ENU=Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this sales order line.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt Amt to Deduct";
                Visible=FALSE }

    { 144 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forudbetalingsbel›b, der allerede er fratrukket almindelige fakturaer, der er bogf›rt for denne salgsordrelinje.;
                           ENU=Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this sales order line.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt Amt Deducted";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kan tildele varegebyrer til linjen.;
                           ENU=Specifies that you can assign item charges to this line.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Allow Item Charge Assignment";
                Visible=FALSE }

    { 5800;2   ;Field     ;
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

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varegebyrer, der var tildelt en bestemt vare, da du bogf›rte salgslinjen.;
                           ENU=Specifies the quantity of the item charge that was assigned to a specified item when you posted this sales line.];
                ApplicationArea=#ItemCharges;
                BlankZero=Yes;
                SourceExpr="Qty. Assigned";
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              ShowItemChargeAssgnt;
                              CurrPage.UPDATE(FALSE);
                            END;

                QuickEntry=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Indeholder den dato, hvor debitoren har ›nsket varerne leveret.;
                           ENU=Specifies the date that the customer has asked for the order to be delivered.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Requested Delivery Date";
                Visible=FALSE;
                OnValidate=BEGIN
                             UpdateForm(TRUE);
                           END;
                            }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, du har lovet at levere ordren som resultat af funktionen Beregning af leveringstid.;
                           ENU=Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.];
                ApplicationArea=#Advanced;
                SourceExpr="Promised Delivery Date";
                Visible=FALSE;
                OnValidate=BEGIN
                             UpdateForm(TRUE);
                           END;
                            }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den planlagte dato, hvor leverancen leveres p† debitorens adresse. Hvis debitoren anmoder om en leveringsdato, beregner programmet, om varerne er disponible for levering p† denne dato. Hvis varerne er disponible, er den planlagte leveringsdato den samme som den anmodede leveringsdato. Hvis ikke, beregner programmet den dato, hvor varerne er disponible for levering, og angiver denne dato i feltet Planlagt leveringsdato.;
                           ENU=Specifies the planned date that the shipment will be delivered at the customer's address. If the customer requests a delivery date, the program calculates whether the items will be available for delivery on this date. If the items are available, the planned delivery date will be the same as the requested delivery date. If not, the program calculates the date that the items are available for delivery and enters this date in the Planned Delivery Date field.];
                ApplicationArea=#Planning;
                SourceExpr="Planned Delivery Date";
                OnValidate=BEGIN
                             UpdateForm(TRUE);
                           END;

                QuickEntry=FALSE }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor leverancen skal sendes fra lageret. Hvis debitoren anmoder om en leveringsdato, beregner programmet den planlagte leveringsdato ved at tr‘kke fragttiden fra den anmodede leveringsdato. Hvis debitoren ikke anmoder om en leveringsdato, eller den anmodede leveringsdato ikke kan opfyldes, beregner programmet indholdet af dette felt ved at tilf›je fragttiden til leveringsdatoen.;
                           ENU=Specifies the date that the shipment should ship from the warehouse. If the customer requests a delivery date, the program calculates the planned shipment date by subtracting the shipping time from the requested delivery date. If the customer does not request a delivery date or the requested delivery date cannot be met, the program calculates the content of this field by adding the shipment time to the shipping date.];
                ApplicationArea=#Planning;
                SourceExpr="Planned Shipment Date";
                OnValidate=BEGIN
                             UpdateForm(TRUE);
                           END;
                            }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Shipment Date";
                OnValidate=BEGIN
                             ShipmentDateOnAfterValidate;
                           END;

                QuickEntry=FALSE }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Service Code";
                Visible=FALSE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid der g†r, fra varerne er sendt fra lageret, til de er leveret.;
                           ENU=Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipping Time";
                Visible=FALSE }

    { 134 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen vedr›rer, n†r salget er relateret til en sag.;
                           ENU=Specifies which work type the resource applies to when the sale is related to a job.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Type Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder p† salgsordrelinjen, der forbliver til behandling i lagerdokumenter.;
                           ENU=Specifies how many units on the sales order line remain to be handled in warehouse documents.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Outstanding Qty.";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder p† salgsordrelinjen, der forbliver til behandling i lagerdokumenter.;
                           ENU=Specifies how many units on the sales order line remain to be handled in warehouse documents.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Outstanding Qty. (Base)";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hvor mange ordremontageenheder p† salgsordrelinjen, der skal samles og behandles i lagerdokumenter.;
                           ENU=Specifies how many assemble-to-order units on the sales order line need to be assembled and handled in warehouse documents.];
                ApplicationArea=#Warehouse;
                SourceExpr="ATO Whse. Outstanding Qty.";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver hvor mange ordremontageenheder p† salgsordrelinjen, der mangler at blive samlet og behandlet i lagerdokumenter.;
                           ENU=Specifies how many assemble-to-order units on the sales order line remain to be assembled and handled in warehouse documents.];
                ApplicationArea=#Warehouse;
                SourceExpr="ATO Whse. Outstd. Qty. (Base)";
                Visible=FALSE }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver en datoformel for den tid, det tager at g›re varerne klar til forsendelse fra denne lokation. Tidselementet anvendes ved beregning af leveringsdatoen p† f›lgende m†de: Afsendelsesdato + Udg†ende lagerekspeditionstid = Planlagt afsendelsesdato + Transporttid = Planlagt leveringsdato.";
                           ENU="Specifies a date formula for the time it takes to get items ready to ship from this location. The time element is used in the calculation of the delivery date as follows: Shipment Date + Outbound Warehouse Handling Time = Planned Shipment Date + Shipping Time = Planned Delivery Date."];
                ApplicationArea=#Warehouse;
                SourceExpr="Outbound Whse. Handling Time";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordrelinje, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, der skal benyttes p† relaterede anl‘gsfinansposter.;
                           ENU=Specifies the date that will be used on related fixed asset ledger entries.];
                ApplicationArea=#Advanced;
                SourceExpr="FA Posting Date";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om afskrivningen er beregnet op til linjens anl‘gsbogf›ringsdato.;
                           ENU=Specifies if depreciation was calculated until the FA posting date of the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Depr. until FA Posting Date";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf›res til, hvis du har valgt Anl‘gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#Advanced;
                SourceExpr="Depreciation Book Code";
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver, om typen er Anl‘g, at oplysningerne p† linjen skal bogf›res til alle de anl‘gsaktiver, der er defineret i afskrivningsprofiler. ";
                           ENU="Specifies, if the type is Fixed Asset, that information on the line is to be posted to all the assets defined depreciation books. "];
                ApplicationArea=#Advanced;
                SourceExpr="Use Duplication List";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en afskrivningsprofilkode, hvis kladdelinjen b†de skal bogf›res til den p†g‘ldende afskrivningsprofil og til afskrivningsprofilen i feltet Afskrivningsprofilkode.;
                           ENU=Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.];
                ApplicationArea=#Advanced;
                SourceExpr="Duplicate in Depreciation Book";
                Visible=FALSE }

    { 108 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette bilag eller denne kladdelinje udlignes fra.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Appl.-from Item Entry";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette dokument eller denne kladdelinje udlignes p†.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied -to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den periodiseringsskabelon, der styrer, hvordan indt‘gter fra dette salgsdokument periodiseres til de forskellige regnskabsperioder, n†r varen eller tjenesten leveres.;
                           ENU=Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.];
                ApplicationArea=#Suite;
                SourceExpr="Deferral Code";
                TableRelation="Deferral Template"."Deferral Code";
                Visible=FALSE;
                Enabled=(Type <> Type::"Fixed Asset") AND (Type <> Type::" ") }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
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
                             ValidateSaveShortcutDimCode(5,ShortcutDimCode[5]);
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
                             ValidateSaveShortcutDimCode(6,ShortcutDimCode[6]);
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
                             ValidateSaveShortcutDimCode(7,ShortcutDimCode[7]);
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
                             ValidateSaveShortcutDimCode(8,ShortcutDimCode[8]);
                           END;
                            }

    { 146 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret.;
                           ENU=Specifies the document number.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No.";
                Visible=FALSE;
                Editable=FALSE }

    { 148 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret.;
                           ENU=Specifies the line number.];
                ApplicationArea=#Advanced;
                SourceExpr="Line No.";
                Visible=FALSE;
                Editable=FALSE }

    { 1060002;2;Field     ;
                ToolTipML=[DAN="Angiver kontokoden for debitoren. ";
                           ENU="Specifies the account code of the customer. "];
                SourceExpr="Account Code";
                Visible=FALSE }

    { 51  ;1   ;Group     ;
                GroupType=Group }

    { 45  ;2   ;Group     ;
                GroupType=Group }

    { 35  ;3   ;Field     ;
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

    { 43  ;3   ;Field     ;
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

    { 41  ;3   ;Field     ;
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
                             InvoiceDiscountAmount := ROUND(TotalSalesLine."Line Amount" * InvoiceDiscountPct / 100,Currency."Amount Rounding Precision");
                             ValidateInvoiceDiscountAmount;
                           END;
                            }

    { 28  ;2   ;Group     ;
                GroupType=Group }

    { 27  ;3   ;Field     ;
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

    { 25  ;3   ;Field     ;
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

    { 23  ;3   ;Field     ;
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
      Currency@1021 : Record 4;
      TotalSalesHeader@1016 : Record 36;
      TotalSalesLine@1009 : Record 37;
      SalesHeader@1000 : Record 36;
      ApplicationAreaSetup@1010 : Record 9178;
      SalesSetup@1015 : Record 311;
      TempOptionLookupBuffer@1013 : TEMPORARY Record 1670;
      SalesPriceCalcMgt@1006 : Codeunit 7000;
      TransferExtendedText@1002 : Codeunit 378;
      ItemAvailFormsMgt@1001 : Codeunit 353;
      SalesCalcDiscountByType@1008 : Codeunit 56;
      DocumentTotals@1007 : Codeunit 57;
      VATAmount@1005 : Decimal;
      ShortcutDimCode@1003 : ARRAY [8] OF Code[20];
      Text001@1004 : TextConst 'DAN=Funktionen Udfold stykliste kan ikke anvendes, da der er faktureret en forudbetaling af salgsordren.;ENU=You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
      LocationCodeMandatory@1017 : Boolean;
      InvDiscAmountEditable@1014 : Boolean;
      UnitofMeasureCodeIsChangeable@1011 : Boolean;
      LocationCodeVisible@1020 : Boolean;
      IsFoundation@1019 : Boolean;
      IsCommentLine@1024 : Boolean;
      InvoiceDiscountAmount@1022 : Decimal;
      InvoiceDiscountPct@1023 : Decimal;
      UpdateInvDiscountQst@1012 : TextConst 'DAN=En eller flere linjer er blevet faktureret. Rabatten p† de fakturerede linjer medregnes ikke.\\Vil du opdatere fakturarabatten?;ENU=One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?';
      ItemChargeStyleExpression@1029 : Text;
      TypeAsText@1018 : Text[30];

    [External]
    PROCEDURE ApproveCalcInvDisc@1();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
    END;

    LOCAL PROCEDURE ValidateInvoiceDiscountAmount@30();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader.GET("Document Type","Document No.");
      IF SalesHeader.InvoicedLineExists THEN
        IF NOT CONFIRM(UpdateInvDiscountQst,FALSE) THEN
          EXIT;

      SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE CalcInvDisc@6();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",Rec);
    END;

    [External]
    PROCEDURE ExplodeBOM@3();
    BEGIN
      IF "Prepmt. Amt. Inv." <> 0 THEN
        ERROR(Text001);
      CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
    END;

    [External]
    PROCEDURE OpenPurchOrderForm@4();
    VAR
      PurchHeader@1000 : Record 38;
      PurchOrder@1001 : Page 50;
    BEGIN
      TESTFIELD("Purchase Order No.");
      PurchHeader.SETRANGE("No.","Purchase Order No.");
      PurchOrder.SETTABLEVIEW(PurchHeader);
      PurchOrder.EDITABLE := FALSE;
      PurchOrder.RUN;
    END;

    [External]
    PROCEDURE OpenSpecialPurchOrderForm@14();
    VAR
      PurchHeader@1001 : Record 38;
      PurchRcptHeader@1002 : Record 120;
      PurchOrder@1000 : Page 50;
    BEGIN
      TESTFIELD("Special Order Purchase No.");
      PurchHeader.SETRANGE("No.","Special Order Purchase No.");
      IF NOT PurchHeader.ISEMPTY THEN BEGIN
        PurchOrder.SETTABLEVIEW(PurchHeader);
        PurchOrder.EDITABLE := FALSE;
        PurchOrder.RUN;
      END ELSE BEGIN
        PurchRcptHeader.SETRANGE("Order No.","Special Order Purchase No.");
        IF PurchRcptHeader.COUNT = 1 THEN
          PAGE.RUN(PAGE::"Posted Purchase Receipt",PurchRcptHeader)
        ELSE
          PAGE.RUN(PAGE::"Posted Purchase Receipts",PurchRcptHeader);
      END;
    END;

    [External]
    PROCEDURE InsertExtendedText@5(Unconditionally@1000 : Boolean);
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
    PROCEDURE ShowNonstockItems@11();
    BEGIN
      ShowNonstock;
    END;

    [External]
    PROCEDURE ShowTracking@13();
    VAR
      TrackingForm@1000 : Page 99000822;
    BEGIN
      TrackingForm.SetSalesLine(Rec);
      TrackingForm.RUNMODAL;
    END;

    [External]
    PROCEDURE ItemChargeAssgnt@5800();
    BEGIN
      ShowItemChargeAssgnt;
    END;

    [External]
    PROCEDURE UpdateForm@12(SetSaveRecord@1000 : Boolean);
    BEGIN
      CurrPage.UPDATE(SetSaveRecord);
    END;

    [Internal]
    PROCEDURE ShowPrices@15();
    BEGIN
      SalesHeader.GET("Document Type","Document No.");
      CLEAR(SalesPriceCalcMgt);
      SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader,Rec);
    END;

    [External]
    PROCEDURE ShowLineDisc@16();
    BEGIN
      SalesHeader.GET("Document Type","Document No.");
      CLEAR(SalesPriceCalcMgt);
      SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader,Rec);
    END;

    [External]
    PROCEDURE OrderPromisingLine@17();
    VAR
      OrderPromisingLine@1000 : TEMPORARY Record 99000880;
      OrderPromisingLines@1001 : Page 99000959;
    BEGIN
      OrderPromisingLine.SETRANGE("Source Type","Document Type");
      OrderPromisingLine.SETRANGE("Source ID","Document No.");
      OrderPromisingLine.SETRANGE("Source Line No.","Line No.");

      OrderPromisingLines.SetSourceType(OrderPromisingLine."Source Type"::Sales);
      OrderPromisingLines.SETTABLEVIEW(OrderPromisingLine);
      OrderPromisingLines.RUNMODAL;
    END;

    LOCAL PROCEDURE NoOnAfterValidate@409();
    BEGIN
      InsertExtendedText(FALSE);
      IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
         (xRec."No." <> '')
      THEN
        CurrPage.SAVERECORD;

      SaveAndAutoAsmToOrder;

      IF Reserve = Reserve::Always THEN BEGIN
        CurrPage.SAVERECORD;
        IF ("Outstanding Qty. (Base)" <> 0) AND ("No." <> xRec."No.") THEN BEGIN
          AutoReserve;
          CurrPage.UPDATE(FALSE);
        END;
      END;
    END;

    LOCAL PROCEDURE VariantCodeOnAfterValidate@21();
    BEGIN
      SaveAndAutoAsmToOrder;
    END;

    LOCAL PROCEDURE LocationCodeOnAfterValidate@8594();
    BEGIN
      SaveAndAutoAsmToOrder;

      IF (Reserve = Reserve::Always) AND
         ("Outstanding Qty. (Base)" <> 0) AND
         ("Location Code" <> xRec."Location Code")
      THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE ReserveOnAfterValidate@8303();
    BEGIN
      IF (Reserve = Reserve::Always) AND ("Outstanding Qty. (Base)" <> 0) THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE QuantityOnAfterValidate@6272();
    VAR
      UpdateIsDone@1001 : Boolean;
    BEGIN
      IF Type = Type::Item THEN
        CASE Reserve OF
          Reserve::Always:
            BEGIN
              CurrPage.SAVERECORD;
              AutoReserve;
              CurrPage.UPDATE(FALSE);
              UpdateIsDone := TRUE;
            END;
          Reserve::Optional:
            IF (Quantity < xRec.Quantity) AND (xRec.Quantity > 0) THEN BEGIN
              CurrPage.SAVERECORD;
              CurrPage.UPDATE(FALSE);
              UpdateIsDone := TRUE;
            END;
        END;

      IF (Type = Type::Item) AND
         (Quantity <> xRec.Quantity) AND
         NOT UpdateIsDone
      THEN
        CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE QtyToAsmToOrderOnAfterValidate@19();
    BEGIN
      CurrPage.SAVERECORD;
      IF Reserve = Reserve::Always THEN
        AutoReserve;
      CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE UnitofMeasureCodeOnAfterValida@1752();
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

    LOCAL PROCEDURE SaveAndAutoAsmToOrder@20();
    BEGIN
      IF (Type = Type::Item) AND IsAsmToOrderRequired THEN BEGIN
        CurrPage.SAVERECORD;
        AutoAsmToOrder;
        CurrPage.UPDATE(FALSE);
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
        IF NOT Currency.GET(TotalSalesHeader."Currency Code") THEN BEGIN
          CLEAR(Currency);
          Currency.InitRoundingPrecision;
        END
    END;

    LOCAL PROCEDURE CalculateTotals@8();
    BEGIN
      GetTotalSalesHeader;
      TotalSalesHeader.CALCFIELDS("Recalculate Invoice Disc.");

      IF SalesSetup."Calc. Inv. Discount" AND ("Document No." <> '') AND (TotalSalesHeader."Customer Posting Group" <> '') AND
         TotalSalesHeader."Recalculate Invoice Disc."
      THEN
        IF FIND THEN
          CalcInvDisc;

      DocumentTotals.CalculateSalesTotals(TotalSalesLine,VATAmount,Rec);
      InvoiceDiscountAmount := TotalSalesLine."Inv. Discount Amount";
      InvoiceDiscountPct := SalesCalcDiscountByType.GetCustInvoiceDiscountPct(Rec);
    END;

    LOCAL PROCEDURE RedistributeTotalsOnAfterValidate@2();
    BEGIN
      CurrPage.SAVERECORD;

      SalesHeader.GET("Document Type","Document No.");
      DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ValidateSaveShortcutDimCode@7(FieldNumber@1001 : Integer;VAR ShortcutDimCode@1000 : Code[20]);
    BEGIN
      ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
      CurrPage.SAVERECORD;
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
            SalesCalcDiscountByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") AND CurrPage.EDITABLE;
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
      IF AssignedItemCharge AND ("Qty. Assigned" <> Quantity) THEN
        ItemChargeStyleExpression := 'Unfavorable';
    END;

    BEGIN
    END.
  }
}

