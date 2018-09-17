OBJECT Page 54 Purchase Order Subform
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
    SourceTableView=WHERE(Document Type=FILTER(Order));
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInit=VAR
             ApplicationAreaSetup@1001 : Record 9178;
           BEGIN
             TempOptionLookupBuffer.FillBuffer(TempOptionLookupBuffer."Lookup Type"::Purchases);
             IsFoundation := ApplicationAreaSetup.IsFoundationEnabled;
             Currency.InitRoundingPrecision;
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
                           CLEAR(DocumentTotals);
                           UpdateEditableOnRow;
                           IF PurchHeader.GET("Document Type","Document No.") THEN;

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
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1906421304;2 ;ActionGroup;
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
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 1902027204;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder, f.eks. dag, uge eller m†ned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByPeriod)
                               END;
                                }
      { 1901633104;3 ;Action    ;
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
      { 1902479904;3 ;Action    ;
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
      { 3       ;3   ;Action    ;
                      AccessByPermission=TableData 5870=R;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByBOM)
                               END;
                                }
      { 1902085804;2 ;Action    ;
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
      { 1905987604;2 ;Action    ;
                      Name=Item Tracking Lines;
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
      { 1903984904;2 ;Action    ;
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
      { 1903079404;2 ;Action    ;
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
                      Name=ItemChargeAssignment;
                      AccessByPermission=TableData 5800=R;
                      CaptionML=[DAN=Varege&byrtildeling;
                                 ENU=Item Charge &Assignment];
                      ToolTipML=[DAN=Tildel ekstra direkte omkostninger, f.eks. for fragt, p† varen p† linjen.;
                                 ENU=Assign additional direct costs, for example for freight, to the item on the line.];
                      ApplicationArea=#ItemCharges;
                      Image=ItemCosts;
                      OnAction=BEGIN
                                 ShowItemChargeAssgnt;
                                 SetItemChargeFieldsStyle;
                               END;
                                }
      { 23      ;2   ;Action    ;
                      Name=DeferralSchedule;
                      CaptionML=[DAN=Periodiseringsplan;
                                 ENU=Deferral Schedule];
                      ToolTipML=[DAN=F† vist eller rediger den periodiseringsplan, der styrer, hvordan indt‘gter fra dette salgsdokument periodiseres til forskellige regnskabsperioder, n†r dokumentet bogf›res.;
                                 ENU=View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.];
                      ApplicationArea=#Suite;
                      Enabled="Deferral Code" <> '';
                      Image=PaymentPeriod;
                      OnAction=BEGIN
                                 PurchHeader.GET("Document Type","Document No.");
                                 ShowDeferrals(PurchHeader."Posting Date",PurchHeader."Currency Code")
                               END;
                                }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1901312904;2 ;Action    ;
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
      { 1901313304;2 ;Action    ;
                      Name=Insert Ext. Texts;
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
      { 1906391504;2 ;Action    ;
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
      { 1903502504;2 ;Action    ;
                      Name=OrderTracking;
                      CaptionML=[DAN=&Ordresporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil h›rende eftersp›rgsel. P† denne m†de kan du finde den oprindelige eftersp›rgsel, der medf›rte en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Advanced;
                      Image=OrderTracking;
                      OnAction=BEGIN
                                 ShowTracking;
                               END;
                                }
      { 1905926804;1 ;ActionGroup;
                      CaptionML=[DAN=&Ordre;
                                 ENU=O&rder];
                      Image=Order }
      { 1903621804;2 ;ActionGroup;
                      CaptionML=[DAN=Di&rekte levering;
                                 ENU=Dr&op Shipment];
                      Image=Delivery }
      { 1903563204;3 ;Action    ;
                      AccessByPermission=TableData 110=R;
                      CaptionML=[DAN=&Salgsordre;
                                 ENU=Sales &Order];
                      ToolTipML=[DAN=Opret en ny salgsordre for en vare, der leveres direkte fra kreditoren til debitoren. Afkrydsningsfeltet Direkte levering skal v‘re markeret p† salgsordrelinjen, og feltet Kreditornr. skal v‘re udfyldt p† varekortet.;
                                 ENU=Create a new sales order for an item that is shipped directly from the vendor to the customer. The Drop Shipment check box must be selected on the sales order line, and the Vendor No. field must be filled on the item card.];
                      ApplicationArea=#Suite;
                      Image=Document;
                      OnAction=BEGIN
                                 OpenSalesOrderForm;
                               END;
                                }
      { 1903169104;2 ;ActionGroup;
                      CaptionML=[DAN=Spe&cialordre;
                                 ENU=Speci&al Order];
                      Image=SpecialOrder }
      { 1901038504;3 ;Action    ;
                      AccessByPermission=TableData 110=R;
                      CaptionML=[DAN=&Salgsordre;
                                 ENU=Sales &Order];
                      ToolTipML=[DAN=Opret en ny salgsordre for en vare, der leveres direkte fra kreditoren til debitoren. Afkrydsningsfeltet Direkte levering skal v‘re markeret p† salgsordrelinjen, og feltet Kreditornr. skal v‘re udfyldt p† varekortet.;
                                 ENU=Create a new sales order for an item that is shipped directly from the vendor to the customer. The Drop Shipment check box must be selected on the sales order line, and the Vendor No. field must be filled on the item card.];
                      ApplicationArea=#Advanced;
                      Image=Document;
                      OnAction=BEGIN
                                 OpenSpecOrderSalesOrderForm;
                               END;
                                }
      { 29      ;2   ;Action    ;
                      Name=BlanketOrder;
                      CaptionML=[DAN=Rammeordre;
                                 ENU=Blanket Order];
                      ToolTipML=[DAN=Vis rammek›bsordren.;
                                 ENU=View the blanket purchase order.];
                      ApplicationArea=#Advanced;
                      Image=BlanketOrder;
                      OnAction=VAR
                                 PurchaseHeader@1000 : Record 38;
                                 BlanketPurchaseOrder@1001 : Page 509;
                               BEGIN
                                 TESTFIELD("Blanket Order No.");
                                 PurchaseHeader.SETRANGE("No.","Blanket Order No.");
                                 IF NOT PurchaseHeader.ISEMPTY THEN BEGIN
                                   BlanketPurchaseOrder.SETTABLEVIEW(PurchaseHeader);
                                   BlanketPurchaseOrder.EDITABLE := FALSE;
                                   BlanketPurchaseOrder.RUN;
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

    { 31  ;2   ;Field     ;
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
                             IF TempOptionLookupBuffer.AutoCompleteOption(TypeAsText,TempOptionLookupBuffer."Lookup Type"::Purchases) THEN
                               VALIDATE(Type,TempOptionLookupBuffer.ID);
                             TempOptionLookupBuffer.ValidateOption(TypeAsText);
                             UpdateEditableOnRow;
                             UpdateTypeText;
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† en finanskonto, en vare, en ekstra kostpris eller et anl‘g, afh‘ngig af hvad du har valgt i feltet Type.;
                           ENU=Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.];
                ApplicationArea=#Suite;
                SourceExpr="No.";
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                             NoOnAfterValidate;

                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                             UpdateTypeText;
                           END;

                ShowMandatory=NOT IsCommentLine }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens krydsreferencenummer. Hvis du indtaster en krydsreference mellem dine og din kreditors og debitors varenummer, vil dette nummer tilsides‘tte standardvarenummeret, n†r du angiver krydsreferencenummeret p† et salgs- eller k›bsbilag.;
                           ENU=Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor's or customer's item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.];
                ApplicationArea=#Suite;
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

    { 1108;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncerninterne partner, som transaktionen er relateret til, hvis posten blev oprettet fra en koncernintern transaktion.;
                           ENU=Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Visible=FALSE }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den vare eller konto i IC-partnerens virksomhed, der svarer til varen eller kontoen p† linjen.;
                           ENU=Specifies the item or account in your IC partner's company that corresponds to the item or account on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Ref. Type";
                Visible=FALSE }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den koncernspecifikke partner. Hvis denne linje sendes til en af dine koncerninterne partnere, bruges dette felt sammen med feltet Ref.type for IC-partner for at angive den vare eller den konto i partnerens regnskab, der svarer til linjen.;
                           ENU=Specifies the IC partner. If the line is being sent to one of your intercompany partners, this field is used together with the IC Partner Ref. Type field to indicate the item or account in your partner's company that corresponds to the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Reference";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen ikke er en lagervare.;
                           ENU=Specifies that this item is a nonstock item.];
                ApplicationArea=#Suite;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 14  ;2   ;Field     ;
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
                ToolTipML=[DAN=Angiver en beskrivelse af posten for det produkt, der skal k›bes. Hvis du vil tilf›je en ikke-transaktionsbaseret tekstlinje, skal du kun udfylde feltet Beskrivelse.;
                           ENU=Specifies a description of the entry of the product to be purchased. To add a non-transactional text line, fill in the Description field only.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om din kreditor sender varerne p† linjen direkte til din debitor.;
                           ENU=Specifies if your vendor ships the items directly to your customer.];
                ApplicationArea=#Suite;
                SourceExpr="Drop Shipment";
                Visible=FALSE }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal angives p† linjen.;
                           ENU=Specifies the number of units of the item specified on the line.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr=Quantity;
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;

                ShowMandatory=(NOT IsCommentLine) AND ("No." <> '') }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange vareenheder p† linjen der er reserveret.;
                           ENU=Specifies how many item units on this line have been reserved.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Reserved Quantity" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler for at afslutte en sag.;
                           ENU=Specifies the quantity that remains to complete a job.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Job Remaining Qty.";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Suite;
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
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Direct Unit Cost";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;

                ShowMandatory=(NOT IsCommentLine) AND ("No." <> '') }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k›bspris, der omfatter indirekte omkostninger, s†som fragt, der er knyttet til k›bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Indirect Cost %";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens enhedspris p† kladdelinjen.;
                           ENU=Specifies the unit cost of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 30  ;2   ;Field     ;
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
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p† linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Line Discount %";
                Visible=FALSE;
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobel›b uden eventuelt fakturarabatbel›b, som skal betales for produkterne p† linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Line Amount";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel›b, der ydes p† varen, p† linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Suite;
                SourceExpr="Line Discount Amount";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 108 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forudbetalingsprocenten, der skal bruges til at beregne forudbetalingen for k›b.;
                           ENU=Specifies the prepayment percentage to use to calculate the prepayment for purchases.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepayment %";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 110 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forudbetalingsbel›bet for linjen i k›bsdokumentets valuta, hvis der er angivet en forudbetalingsprocent for k›bslinjen.;
                           ENU=Specifies the prepayment amount of the line in the currency of the purchase document if a prepayment percentage is specified for the purchase line.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt. Line Amount";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 112 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forudbetalingsbel›b, der allerede er faktureret til debitoren for k›bslinjen.;
                           ENU=Specifies the prepayment amount that has already been invoiced to the customer for this purchase line.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt. Amt. Inv.";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, n†r fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede beregnede fakturarabatbel›b for linjen.;
                           ENU=Specifies the total calculated invoice discount amount for the line.];
                ApplicationArea=#Suite;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det faktiske fakturarabatbel›b, der skal bogf›res for fakturalinjen.;
                           ENU=Specifies the actual invoice discount amount that will be posted for the line on the invoice.];
                ApplicationArea=#Suite;
                SourceExpr="Inv. Disc. Amount to Invoice";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der endnu ikke er modtaget.;
                           ENU=Specifies the quantity of items that remains to be received.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Qty. to Receive" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der allerede er blevet bogf›rt som modtaget.;
                           ENU=Specifies how many units of the item on the line have been posted as received.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Quantity Received" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler at blive faktureret. Det beregnes som Antal - Faktureret antal.;
                           ENU=Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Qty. to Invoice" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der allerede er blevet bogf›rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Suite;
                BlankZero=Yes;
                SourceExpr="Quantity Invoiced" }

    { 114 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forudbetalingsbel›b, der allerede er fratrukket almindelige fakturaer, der er bogf›rt for denne k›bsordrelinje.;
                           ENU=Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this purchase order line.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt Amt to Deduct";
                Visible=FALSE }

    { 116 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forudbetalingsbel›b, der allerede er fratrukket almindelige fakturaer, der er bogf›rt for denne k›bsordrelinje.;
                           ENU=Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this purchase order line.];
                ApplicationArea=#Prepayments;
                SourceExpr="Prepmt Amt Deducted";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kan tildele varegebyrer til linjen.;
                           ENU=Specifies that you can assign item charges to this line.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Allow Item Charge Assignment";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
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

    { 126 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sag. Hvis du udfylder dette felt og feltet Sagsopgavenr., bogf›res der en sagspost sammen med k›bslinjen.;
                           ENU=Specifies the number of the related job. If you fill in this field and the Job Task No. field, then a job ledger entry will be posted together with the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 128 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No.";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sagsplanl‘gningslinjenummer, som forbruget skal knyttes til, n†r sagskladden bogf›res. Du kan kun knytte til sagsplanl‘gningslinjer, hvor indstillingen Anvend anvendelseslink er aktiveret.;
                           ENU=Specifies the job planning line number to which the usage should be linked when the Job Journal is posted. You can only link to Job Planning Lines that have the Apply Usage Link option enabled.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Planning Line No.";
                Visible=FALSE }

    { 130 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type planl‘gningslinje, der blev oprettet, da sagsposten blev bogf›rt fra k›bslinjen. Hvis feltet er tomt, er der ikke oprettet planl‘gningslinjer for denne post.;
                           ENU=Specifies the type of planning line that was created when the job ledger entry is posted from the purchase line. If the field is empty, no planning lines were created for this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Type";
                Visible=FALSE }

    { 132 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsprisen pr. enhed, der g‘lder for den vare eller finansudgift, der bogf›res.;
                           ENU=Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Unit Price";
                Visible=FALSE }

    { 134 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjebel›bet for den sagspost, der er relateret til k›bslinjen.;
                           ENU=Specifies the line amount of the job ledger entry that is related to the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Amount";
                Visible=FALSE }

    { 136 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjerabatbel›bet for den sagspost, der er relateret til k›bslinjen.;
                           ENU=Specifies the line discount amount of the job ledger entry that is related to the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Discount Amount";
                Visible=FALSE }

    { 138 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjerabatprocentdelen for den sagspost, der er relateret til k›bslinjen.;
                           ENU=Specifies the line discount percentage of the job ledger entry that is related to the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Discount %";
                Visible=FALSE }

    { 140 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bruttobel›bet for den linje, som k›bslinjen vedr›rer.;
                           ENU=Specifies the gross amount of the line that the purchase line applies to.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Total Price";
                Visible=FALSE }

    { 142 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsprisen pr. enhed, der g‘lder for den vare eller finansudgift, der bogf›res.;
                           ENU=Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Unit Price (LCY)";
                Visible=FALSE }

    { 144 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjens bruttobel›b angivet i den lokale valuta.;
                           ENU=Specifies the gross amount of the line, in the local currency.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Total Price (LCY)";
                Visible=FALSE }

    { 146 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjebel›bet for den sagspost, der er relateret til k›bslinjen.;
                           ENU=Specifies the line amount of the job ledger entry that is related to the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Amount (LCY)";
                Visible=FALSE }

    { 148 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjerabatbel›bet for den sagspost, der er relateret til k›bslinjen.;
                           ENU=Specifies the line discount amount of the job ledger entry that is related to the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Disc. Amount (LCY)";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som du har bedt kreditoren om at levere ordren p† til leveringsadressen. V‘rdien i feltet bruges til at beregne, hvilken dato du senest kan bestille varerne, hvis de skal v‘re leveret p† den ›nskede modtagelsesdato. Hvis det ikke er n›dvendigt med levering p† en bestemt dato, kan du lade feltet st† tomt.;
                           ENU=Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.];
                ApplicationArea=#Suite;
                SourceExpr="Requested Receipt Date";
                Visible=FALSE }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som kreditoren har lovet at levere ordren.;
                           ENU=Specifies the date that the vendor has promised to deliver the order.];
                ApplicationArea=#Advanced;
                SourceExpr="Promised Receipt Date";
                Visible=FALSE }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor varen skal ankomme p† lageret. Forl‘ns beregning: planlagt modtagelsesdato = ordredato + kreditors leveringstid (if›lge kreditorens kalender og afrundet til n‘ste arbejdsdag f›rst i kreditorens kalender og derefter lokationens kalender). Hvis der ingen kalender findes hos kreditoren: planlagt modtagelsesdato = ordredato + kreditors leveringstid (if›lge lokationens kalender). Bagl‘ns beregning: ordredato = planlagt modtagelsesdato - kreditors leveringstid (if›lge kreditorens kalender og afrundet til den forrige arbejdsdag f›rst i kreditorens kalender og derefter lokationens kalender). Hvis der ingen kalender findes hos kreditoren: ordredato = planlagt modtagelsesdato - kreditors leveringstid (if›lge lokations kalender).";
                           ENU="Specifies the date when the item is planned to arrive in inventory. Forward calculation: planned receipt date = order date + vendor lead time (per the vendor calendar and rounded to the next working day in first the vendor calendar and then the location calendar). If no vendor calendar exists, then: planned receipt date = order date + vendor lead time (per the location calendar). Backward calculation: order date = planned receipt date - vendor lead time (per the vendor calendar and rounded to the previous working day in first the vendor calendar and then the location calendar). If no vendor calendar exists, then: order date = planned receipt date - vendor lead time (per the location calendar)."];
                ApplicationArea=#Advanced;
                SourceExpr="Planned Receipt Date" }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilg‘ngelige p† lageret. Hvis du lader feltet v‘re tomt, bliver det beregnet p† f›lgende m†de: Planlagt modtagelsesdato + Sikkerhedstid + Indg†ende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Receipt Date" }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#Suite;
                SourceExpr="Order Date";
                Visible=FALSE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datoformel for det tidsrum, det tager at genbestille varen.;
                           ENU=Specifies a date formula for the amount of time it takes to replenish the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Lead Time Calculation";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der tages h›jde for den forsyning, der repr‘senteres af linjen i planl‘gningssystemet, n†r der beregnes aktionsmeddelelser.;
                           ENU=Specifies whether the supply represented by this line is considered by the planning system when calculating action messages.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Planning Flexibility";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order No.";
                Visible=FALSE }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede produktionsordrelinje.;
                           ENU=Specifies the number of the related production order line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order Line No.";
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede produktionsfunktion.;
                           ENU=Specifies the number of the related production operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Operation No.";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdscenternummeret p† kladdelinjen.;
                           ENU=Specifies the work center number of the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Center No.";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at alle relaterede tjenester eller operationer er fuldf›rt.;
                           ENU=Specifies that any related service or operation is finished.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Finished;
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder p† k›bsordrelinjen, der forbliver til behandling i lagerdokumenter.;
                           ENU=Specifies how many units on the purchase order line remain to be handled in warehouse documents.];
                ApplicationArea=#Warehouse;
                SourceExpr="Whse. Outstanding Qty. (Base)";
                Visible=FALSE }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, det tager at g›re varer tilg‘ngelige fra lageret, efter varerne er bogf›rt som modtaget.;
                           ENU=Specifies the time it takes to make items part of available inventory, after the items have been posted as received.];
                ApplicationArea=#Warehouse;
                SourceExpr="Inbound Whse. Handling Time";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette dokument eller denne kladdelinje udlignes p†.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied -to.];
                ApplicationArea=#Suite;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den periodiseringsskabelon, der styrer, hvordan udgifter der er betalt med dette k›bsbilag, periodiseres til forskellige regnskabsperioder, n†r udgiften eller indt‘gten indtr‘ffer.;
                           ENU=Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.];
                ApplicationArea=#Suite;
                SourceExpr="Deferral Code";
                TableRelation="Deferral Template"."Deferral Code";
                Visible=FALSE;
                Enabled=(Type <> Type::"Fixed Asset") AND (Type <> Type::" ") }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 76  ;2   ;Field     ;
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

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret.;
                           ENU=Specifies the document number.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No.";
                Visible=FALSE;
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† linjen.;
                           ENU=Specifies the number of this line.];
                ApplicationArea=#Advanced;
                SourceExpr="Line No.";
                Visible=FALSE;
                Editable=FALSE }

    { 43  ;1   ;Group     ;
                GroupType=Group }

    { 37  ;2   ;Group     ;
                GroupType=Group }

    { 35  ;3   ;Field     ;
                Name=Invoice Discount Amount;
                CaptionML=[DAN=Fakturarabatbel›b;
                           ENU=Invoice Discount Amount];
                ToolTipML=[DAN=Angiver det bel›b, der beregnes og vises, i feltet Fakturarabatbel›b. Fakturarabatbel›bet fratr‘kkes den v‘rdi, der vises i feltet I alt inkl. moms.;
                           ENU=Specifies the amount that is calculated and shown in the Invoice Discount Amount field. The invoice discount amount is deducted from the value shown in the Total Amount Incl. VAT field.];
                ApplicationArea=#Suite;
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

    { 33  ;3   ;Field     ;
                Name=Invoice Disc. Pct.;
                CaptionML=[DAN=Fakturarabat i %;
                           ENU=Invoice Discount %];
                ToolTipML=[DAN=Angiver en rabatprocent, der ydes, hvis de kriterier, du har oprettet for debitoren, opfyldes. Det beregnede rabatbel›b inds‘ttes i feltet Fakturarabatbel›b, men du kan ‘ndre det manuelt.;
                           ENU=Specifies a discount percentage that is granted if criteria that you have set up for the customer are met. The calculated discount amount is inserted in the Invoice Discount Amount field, but you can change it manually.];
                ApplicationArea=#Suite;
                DecimalPlaces=0:2;
                SourceExpr=PurchCalcDiscByType.GetVendInvoiceDiscountPct(Rec);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 19  ;2   ;Group     ;
                GroupType=Group }

    { 17  ;3   ;Field     ;
                Name=Total Amount Excl. VAT;
                DrillDown=No;
                CaptionML=[DAN=I alt ekskl. moms;
                           ENU=Total Amount Excl. VAT];
                ToolTipML=[DAN=Angiver summen af v‘rdien i feltet Linjebel›b ekskl. moms p† alle linjer i dokumentet minus eventuelle rabatbel›b i feltet Fakturarabatbel›b.;
                           ENU=Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#Suite;
                SourceExpr=TotalPurchaseLine.Amount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 15  ;3   ;Field     ;
                Name=Total VAT Amount;
                CaptionML=[DAN=Moms i alt;
                           ENU=Total VAT];
                ToolTipML=[DAN=Angiver summen af momsbel›b p† alle linjer i bilaget.;
                           ENU=Specifies the sum of VAT amounts on all lines in the document.];
                ApplicationArea=#Suite;
                SourceExpr=VATAmount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalVATCaption(Currency.Code);
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=RefreshMessageEnabled }

    { 13  ;3   ;Field     ;
                Name=Total Amount Incl. VAT;
                CaptionML=[DAN=I alt inkl. moms;
                           ENU=Total Amount Incl. VAT];
                ToolTipML=[DAN=Angiver summen af v‘rdien i feltet Linjebel›b inkl. moms p† alle linjer i dokumentet minus eventuelle rabatbel›b i feltet Fakturarabatbel›b.;
                           ENU=Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
                ApplicationArea=#Suite;
                SourceExpr=TotalPurchaseLine."Amount Including VAT";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                Editable=FALSE;
                StyleExpr=TotalAmountStyle }

    { 11  ;3   ;Field     ;
                Name=RefreshTotals;
                DrillDown=Yes;
                ApplicationArea=#Suite;
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
      TotalPurchaseHeader@1009 : Record 38;
      TotalPurchaseLine@1008 : Record 39;
      PurchHeader@1005 : Record 38;
      Currency@1022 : Record 4;
      ApplicationAreaSetup@1000 : Record 9178;
      TempOptionLookupBuffer@1001 : TEMPORARY Record 1670;
      TransferExtendedText@1002 : Codeunit 378;
      ItemAvailFormsMgt@1006 : Codeunit 353;
      Text001@1007 : TextConst 'DAN=Funktionen Udfold stykliste kan ikke anvendes, da der er faktureret en forudbetaling af k›bsordren.;ENU=You cannot use the Explode BOM function because a prepayment of the purchase order has been invoiced.';
      PurchCalcDiscByType@1010 : Codeunit 66;
      DocumentTotals@1017 : Codeunit 57;
      ShortcutDimCode@1003 : ARRAY [8] OF Code[20];
      VATAmount@1018 : Decimal;
      TotalAmountStyle@1015 : Text;
      RefreshMessageText@1013 : Text;
      TypeAsText@1020 : Text[30];
      ItemChargeStyleExpression@1016 : Text;
      InvDiscAmountEditable@1012 : Boolean;
      RefreshMessageEnabled@1004 : Boolean;
      IsCommentLine@1019 : Boolean;
      IsFoundation@1021 : Boolean;
      UnitofMeasureCodeIsChangeable@1011 : Boolean;
      UpdateInvDiscountQst@1014 : TextConst 'DAN=En eller flere linjer er blevet faktureret. Rabatten p† de fakturerede linjer medregnes ikke.\\Vil du opdatere fakturarabatten?;ENU=One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?';

    [External]
    PROCEDURE ApproveCalcInvDisc@7();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)",Rec);
    END;

    LOCAL PROCEDURE ExplodeBOM@3();
    BEGIN
      IF "Prepmt. Amt. Inv." <> 0 THEN
        ERROR(Text001);
      CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM",Rec);
    END;

    LOCAL PROCEDURE OpenSalesOrderForm@5();
    VAR
      SalesHeader@1000 : Record 36;
      SalesOrder@1001 : Page 42;
    BEGIN
      TESTFIELD("Sales Order No.");
      SalesHeader.SETRANGE("No.","Sales Order No.");
      SalesOrder.SETTABLEVIEW(SalesHeader);
      SalesOrder.EDITABLE := FALSE;
      SalesOrder.RUN;
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
    PROCEDURE ShowTracking@10();
    VAR
      TrackingForm@1000 : Page 99000822;
    BEGIN
      TrackingForm.SetPurchLine(Rec);
      TrackingForm.RUNMODAL;
    END;

    LOCAL PROCEDURE OpenSpecOrderSalesOrderForm@12();
    VAR
      SalesHeader@1000 : Record 36;
      SalesOrder@1001 : Page 42;
    BEGIN
      TESTFIELD("Special Order Sales No.");
      SalesHeader.SETRANGE("No.","Special Order Sales No.");
      SalesOrder.SETTABLEVIEW(SalesHeader);
      SalesOrder.EDITABLE := FALSE;
      SalesOrder.RUN;
    END;

    [External]
    PROCEDURE UpdateForm@13(SetSaveRecord@1000 : Boolean);
    BEGIN
      CurrPage.UPDATE(SetSaveRecord);
    END;

    LOCAL PROCEDURE NoOnAfterValidate@409();
    BEGIN
      UpdateEditableOnRow;
      InsertExtendedText(FALSE);
      IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
         (xRec."No." <> '')
      THEN
        CurrPage.SAVERECORD;
    END;

    LOCAL PROCEDURE CrossReferenceNoOnAfterValidat@2059();
    BEGIN
      InsertExtendedText(FALSE);
    END;

    LOCAL PROCEDURE RedistributeTotalsOnAfterValidate@2();
    BEGIN
      CurrPage.SAVERECORD;

      PurchHeader.GET("Document Type","Document No.");
      IF DocumentTotals.PurchaseCheckNumberOfLinesLimit(PurchHeader) THEN
        DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE UpdateEditableOnRow@8();
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

    LOCAL PROCEDURE SetItemChargeFieldsStyle@77();
    BEGIN
      ItemChargeStyleExpression := '';
      IF AssignedItemCharge AND ("Qty. Assigned" <> Quantity) THEN
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

