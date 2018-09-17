OBJECT Page 96 Sales Cr. Memo Subform
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836,NAVDK11.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table37;
    DelayedInsert=Yes;
    SourceTableView=WHERE(Document Type=FILTER(Credit Memo));
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInit=VAR
             ApplicationAreaSetup@1001 : Record 9178;
           BEGIN
             Currency.InitRoundingPrecision;
             TempOptionLookupBuffer.FillBuffer(TempOptionLookupBuffer."Lookup Type"::Sales);
             IsFoundation := ApplicationAreaSetup.IsFoundationEnabled;
           END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                       CLEAR(DocumentTotals);
                       UpdateTypeText;
                       SetItemChargeFieldsStyle
                     END;

    OnNewRecord=VAR
                  ApplicationAreaSetup@1001 : Record 9178;
                BEGIN
                  InitType;

                  // Default to Inventory for the first line and to previous line type for the others
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

                           IF SalesHeader.GET("Document Type","Document No.") THEN;
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1902056104;1 ;Action    ;
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
      { 1902740304;1 ;Action    ;
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
      { 19      ;1   ;Action    ;
                      Name=DeferralSchedule;
                      CaptionML=[DAN=Periodiseringsplan;
                                 ENU=Deferral Schedule];
                      ToolTipML=[DAN=F† vist eller rediger den periodiseringsplan, der styrer, hvordan indt‘gter fra dette salgsdokument periodiseres til forskellige regnskabsperioder, n†r dokumentet bogf›res.;
                                 ENU=View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.];
                      ApplicationArea=#Suite;
                      Enabled="Deferral Code" <> '';
                      Image=PaymentPeriod;
                      OnAction=BEGIN
                                 TotalSalesHeader.GET("Document Type","Document No.");
                                 ShowDeferrals(TotalSalesHeader."Posting Date",TotalSalesHeader."Currency Code");
                               END;
                                }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1904522204;2 ;Action    ;
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
                      AccessByPermission=TableData 6660=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Hent &returvaremodt.linjer;
                                 ENU=Get Return &Receipt Lines];
                      ToolTipML=[DAN=V‘lg en bogf›rt returvaremodtagelse for den vare, du vil tildele varegebyret til, f.eks. hvis du har modtaget en faktura for varegebyret, n†r du har bogf›rt den oprindelige returvaremodtagelse.;
                                 ENU=Select a posted return receipt for the item that you want to assign the item charge to, for example, if you received an invoice for the item charge after you posted the original return receipt.];
                      ApplicationArea=#Advanced;
                      Image=ReturnReceipt;
                      OnAction=BEGIN
                                 GetReturnReceipt;
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
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikles over tid i henhold til udbud og eftersp›rgsel.;
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
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder, f.eks. dag, uge eller m†ned.;
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
      { 7       ;3   ;Action    ;
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
      { 1907838004;2 ;Action    ;
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
                                 SetItemChargeFieldsStyle
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

    { 9   ;2   ;Field     ;
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
                             UpdateEditableOnRow;
                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                             UpdateTypeText;
                           END;

                ShowMandatory=NOT IsCommentLine }

    { 34  ;2   ;Field     ;
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

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncerninterne partner, som transaktionen er relateret til, hvis posten blev oprettet fra en koncernintern transaktion.;
                           ENU=Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den vare eller konto i IC-partnerens virksomhed, der svarer til varen eller kontoen p† linjen.;
                           ENU=Specifies the item or account in your IC partner's company that corresponds to the item or account on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Ref. Type";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
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
                ToolTipML=[DAN=Angiver en beskrivelse af posten, som er baseret p† indholdet af felterne Type og Nr.;
                           ENU=Specifies a description of the entry, which is based on the contents of the Type and No. fields.];
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
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken lagerlokation de solgte varer skal tages fra, og hvor lagerreduktionen registreres.;
                           ENU=Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
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

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der er blevet reserveret.;
                           ENU=Specifies how many units of the item on the line have been reserved.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Reserved Quantity";
                Visible=FALSE;
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              COMMIT;
                              ShowReservationEntries(TRUE);
                              UpdateForm(TRUE);
                            END;
                             }

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
                            }

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
                             }

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
                             }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sag. Hvis du udfylder dette felt og feltet Sagsopgavenr., bogf›res der en sagspost sammen med salgslinjen.;
                           ENU=Specifies the number of the related job. If you fill in this field and the Job Task No. field, then a job ledger entry will be posted together with the sales line.];
                ApplicationArea=#Advanced;
                SourceExpr="Job No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Advanced;
                SourceExpr="Job Task No.";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momskategorien i forbindelse med afsendelse af elektroniske dokumenter. N†r du f.eks. sender salgsdokumenter via PEPPOL-tjenesten, bruges v‘rdien i dette felt til at udfylde flere forskellige felter, f.eks. elementet ClassifiedTaxCategory i varegruppen. Det bruges ogs† til at udfylde elementet TaxCategory i grupperne TaxSubtotal og AllowanceCharge. Nummeret er baseret p† UNCL5305-standarden.;
                           ENU=Specifies the VAT category in connection with electronic document sending. For example, when you send sales documents through the PEPPOL service, the value in this field is used to populate several fields, such as the ClassifiedTaxCategory element in the Item group. It is also used to populate the TaxCategory element in both the TaxSubtotal and AllowanceCharge group. The number is based on the UNCL5305 standard.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Tax Category";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen vedr›rer, n†r salget er relateret til en sag.;
                           ENU=Specifies which work type the resource applies to when the sale is related to a job.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Type Code";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordrelinje, hvorfra recorden stammer.;
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

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den periodiseringsskabelon, der styrer, hvordan indt‘gter fra dette salgsdokument periodiseres til de forskellige regnskabsperioder, n†r varen eller tjenesten leveres.;
                           ENU=Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.];
                ApplicationArea=#Suite;
                SourceExpr="Deferral Code";
                TableRelation="Deferral Template"."Deferral Code";
                Visible=FALSE;
                Enabled=(Type <> Type::"Fixed Asset") AND (Type <> Type::" ") }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
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
                             ValidateSaveShortcutDimCode(3,ShortcutDimCode[3]);
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
                             ValidateSaveShortcutDimCode(4,ShortcutDimCode[4]);
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

    { 1060000;2;Field     ;
                ToolTipML=[DAN="Angiver kontokoden for debitoren. ";
                           ENU="Specifies the account code of the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Code";
                Visible=FALSE }

    { 39  ;1   ;Group     ;
                GroupType=Group }

    { 35  ;2   ;Group     ;
                GroupType=Group }

    { 27  ;3   ;Field     ;
                CaptionML=[DAN=Subtotal ekskl. moms;
                           ENU=Subtotal Excl. VAT];
                ToolTipML=[DAN=Angiver summen af v‘rdien i feltet Linjebel›b ekskl. moms p† alle linjer i bilaget.;
                           ENU=Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TotalSalesLine."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code,TotalSalesHeader."Prices Including VAT");
                Editable=FALSE }

    { 33  ;3   ;Field     ;
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

    { 31  ;3   ;Field     ;
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

    { 17  ;2   ;Group     ;
                GroupType=Group }

    { 15  ;3   ;Field     ;
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

    { 13  ;3   ;Field     ;
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

    { 11  ;3   ;Field     ;
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
      SalesHeader@1011 : Record 36;
      TotalSalesHeader@1021 : Record 36;
      TotalSalesLine@1020 : Record 37;
      Currency@1016 : Record 4;
      TempOptionLookupBuffer@1018 : TEMPORARY Record 1670;
      TransferExtendedText@1000 : Codeunit 378;
      ItemAvailFormsMgt@1004 : Codeunit 353;
      SalesCalcDiscountByType@1015 : Codeunit 56;
      DocumentTotals@1014 : Codeunit 57;
      VATAmount@1013 : Decimal;
      AmountWithDiscountAllowed@1012 : Decimal;
      ShortcutDimCode@1001 : ARRAY [8] OF Code[20];
      InvDiscAmountEditable@1010 : Boolean;
      UnitofMeasureCodeIsChangeable@1003 : Boolean;
      InvoiceDiscountAmount@1006 : Decimal;
      InvoiceDiscountPct@1005 : Decimal;
      IsFoundation@1007 : Boolean;
      IsCommentLine@1008 : Boolean;
      TypeAsText@1009 : Text[30];
      ItemChargeStyleExpression@1026 : Text;

    [External]
    PROCEDURE ApproveCalcInvDisc@1();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
    END;

    LOCAL PROCEDURE ExplodeBOM@3();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
    END;

    LOCAL PROCEDURE GetReturnReceipt@2();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Get Return Receipts",Rec);
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

    LOCAL PROCEDURE OpenItemTrackingLines@6500();
    BEGIN
      OpenItemTrackingLines;
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

    LOCAL PROCEDURE ShowLineComments@10();
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
    END;

    LOCAL PROCEDURE CrossReferenceNoOnAfterValidat@19048248();
    BEGIN
      InsertExtendedText(FALSE);
    END;

    LOCAL PROCEDURE ReserveOnAfterValidate@19004502();
    BEGIN
      IF (Reserve = Reserve::Always) AND ("Outstanding Qty. (Base)" <> 0) THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
      END;
    END;

    LOCAL PROCEDURE QuantityOnAfterValidate@19032465();
    BEGIN
      IF Reserve = Reserve::Always THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
      END;
    END;

    LOCAL PROCEDURE UnitofMeasureCodeOnAfterValida@19057939();
    BEGIN
      IF Reserve = Reserve::Always THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
      END;
    END;

    LOCAL PROCEDURE RedistributeTotalsOnAfterValidate@11();
    BEGIN
      CurrPage.SAVERECORD;

      TotalSalesHeader.GET("Document Type","Document No.");
      DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE ValidateSaveShortcutDimCode@6(FieldNumber@1001 : Integer;VAR ShortcutDimCode@1000 : Code[20]);
    BEGIN
      ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
      CurrPage.SAVERECORD;
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
            SalesCalcDiscountByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") AND CurrPage.EDITABLE;
      END;
    END;

    LOCAL PROCEDURE CalculateTotals@8();
    VAR
      SalesCalcDiscountByType@1000 : Codeunit 56;
    BEGIN
      GetTotalSalesHeader;
      TotalSalesHeader.CALCFIELDS("Recalculate Invoice Disc.");

      IF ("Document No." <> '') AND (TotalSalesHeader."Customer Posting Group" <> '') AND
         TotalSalesHeader."Recalculate Invoice Disc."
      THEN BEGIN
        SalesCalcDiscountByType.CalcInvoiceDiscOnLine(TRUE);
        SalesCalcDiscountByType.RUN(Rec);
      END;

      DocumentTotals.CalculateSalesTotals(TotalSalesLine,VATAmount,Rec);
      AmountWithDiscountAllowed := DocumentTotals.CalcTotalSalesAmountOnlyDiscountAllowed(Rec);
      InvoiceDiscountAmount := TotalSalesLine."Inv. Discount Amount";
      InvoiceDiscountPct := SalesCalcDiscountByType.GetCustInvoiceDiscountPct(Rec);
    END;

    LOCAL PROCEDURE GetTotalSalesHeader@13();
    BEGIN
      IF NOT TotalSalesHeader.GET("Document Type","Document No.") THEN
        CLEAR(TotalSalesHeader);
      IF Currency.Code <> TotalSalesHeader."Currency Code" THEN
        IF NOT Currency.GET(TotalSalesHeader."Currency Code") THEN BEGIN
          CLEAR(Currency);
          Currency.InitRoundingPrecision;
        END
    END;

    LOCAL PROCEDURE ValidateInvoiceDiscountAmount@22();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader.GET("Document Type","Document No.");
      SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE UpdateTypeText@7();
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

