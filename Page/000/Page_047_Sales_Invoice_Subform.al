OBJECT Page 47 Sales Invoice Subform
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
    SourceTableView=WHERE(Document Type=FILTER(Invoice));
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInit=BEGIN
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
                           UpdateEditableOnRow;
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
      { 1903079504;3 ;Action    ;
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
      { 1907415004;3 ;Action    ;
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
      { 1903098604;3 ;Action    ;
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
      { 1900206204;3 ;Action    ;
                      Name=InsertExtTexts;
                      AccessByPermission=TableData 279=R;
                      CaptionML=[DAN=&Inds‘t udv. tekster;
                                 ENU=Insert &Ext. Texts];
                      ToolTipML=[DAN=Inds‘t den forl‘ngede varebeskrivelse, som h›rer til varen, der behandles p† linjen.;
                                 ENU=Insert the extended item description that is set up for the item that is being processed on the line.];
                      ApplicationArea=#Suite;
                      Image=Text;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 InsertExtendedText(TRUE);
                               END;
                                }
      { 1900545004;3 ;Action    ;
                      Name=GetShipmentLines;
                      AccessByPermission=TableData 110=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent salgsleverancelinjer;
                                 ENU=Get &Shipment Lines];
                      ToolTipML=[DAN=V‘lg flere leveringer til den samme debitor, fordi du vil kombinere dem p† ‚n faktura.;
                                 ENU=Select multiple shipments to the same customer because you want to combine them on one invoice.];
                      ApplicationArea=#Suite;
                      Image=Shipment;
                      OnAction=BEGIN
                                 GetShipment;
                               END;
                                }
      { 1905427604;2 ;ActionGroup;
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
      { 1900639404;3 ;Action    ;
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
      { 1904974904;3 ;Action    ;
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
      { 1904945204;3 ;Action    ;
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
      { 23      ;2   ;ActionGroup;
                      CaptionML=[DAN=Relaterede oplysninger;
                                 ENU=Related Information] }
      { 1904522204;3 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1900948904;3 ;Action    ;
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
                                 ShowItemChargeAssgnt;
                                 SetItemChargeFieldsStyle;
                               END;
                                }
      { 1905987604;3 ;Action    ;
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
      { 17      ;3   ;Action    ;
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
                             UpdateEditableOnRow;

                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;

                             UpdateTypeText;
                           END;
                            }

    { 77  ;2   ;Field     ;
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
                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                             UpdateTypeText;
                           END;

                ShowMandatory=Type <> Type::" " }

    { 58  ;2   ;Field     ;
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

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncerninterne partner, som transaktionen er relateret til, hvis posten blev oprettet fra en koncernintern transaktion.;
                           ENU=Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den vare eller konto i IC-partnerens virksomhed, der svarer til varen eller kontoen p† linjen.;
                           ENU=Specifies the item or account in your IC partner's company that corresponds to the item or account on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Ref. Type";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
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
                Visible=FALSE }

    { 62  ;2   ;Field     ;
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

                             NoOnAfterValidate;
                             ShowShortcutDimCode(ShortcutDimCode);
                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                             UpdateTypeText;
                           END;

                ShowMandatory=NOT IsCommentLine }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken lagerlokation de solgte varer skal tages fra, og hvor lagerreduktionen registreres.;
                           ENU=Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=LocationCodeVisible;
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder der s‘lges.;
                           ENU=Specifies how many units are being sold.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=Quantity;
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             ValidateAutoReserve;
                             RedistributeTotalsOnAfterValidate;
                           END;

                ShowMandatory=(NOT IsCommentLine) AND ("No." <> '') }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code";
                Enabled=UnitofMeasureCodeIsChangeable;
                Editable=UnitofMeasureCodeIsChangeable;
                OnValidate=BEGIN
                             ValidateAutoReserve;
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver m†leenheden for varen eller ressourcen p† salgslinjen.;
                           ENU=Specifies the unit of measure for the item or resource on the sales line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens enhedspris p† kladdelinjen.;
                           ENU=Specifies the unit cost of the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 88  ;2   ;Field     ;
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

    { 64  ;2   ;Field     ;
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

    { 90  ;2   ;Field     ;
                CaptionML=[DAN=Salgslinjerabat findes;
                           ENU=Sales Line Disc. Exists];
                ToolTipML=[DAN=Angiver, at der er en rabat, der er specifik for denne debitor.;
                           ENU=Specifies that there is a specific discount for this customer.];
                ApplicationArea=#Advanced;
                SourceExpr=LineDiscExists;
                Visible=FALSE;
                Editable=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel›b, der ydes p† varen, p† linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Line Discount Amount";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 42  ;2   ;Field     ;
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

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fakturarabatbel›bet for hele linjen.;
                           ENU=Specifies the invoice discount amount for the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
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
                StyleExpr=ItemChargeStyleExpression;
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              ShowItemChargeAssgnt;
                              UpdatePage(FALSE);
                            END;
                             }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varegebyrer, der var tildelt en bestemt vare, da du bogf›rte salgslinjen.;
                           ENU=Specifies the quantity of the item charge that was assigned to a specified item when you posted this sales line.];
                ApplicationArea=#ItemCharges;
                BlankZero=Yes;
                SourceExpr="Qty. Assigned";
                Visible=FALSE;
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              ShowItemChargeAssgnt;
                              UpdatePage(FALSE);
                            END;
                             }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sag. Hvis du udfylder dette felt og feltet Sagsopgavenr., bogf›res der en sagspost sammen med salgslinjen.;
                           ENU=Specifies the number of the related job. If you fill in this field and the Job Task No. field, then a job ledger entry will be posted together with the sales line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                Visible=FALSE;
                Editable=FALSE;
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No.";
                Visible=FALSE;
                Editable=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l›benummeret p† den jobplanl‘gningslinje, som salgslinjen er tilknyttet.;
                           ENU=Specifies the entry number of the job planning line that the sales line is linked to.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Contract Entry No.";
                Visible=FALSE;
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momskategorien i forbindelse med afsendelse af elektroniske dokumenter. N†r du f.eks. sender salgsdokumenter via PEPPOL-tjenesten, bruges v‘rdien i dette felt til at udfylde flere forskellige felter, f.eks. elementet ClassifiedTaxCategory i varegruppen. Det bruges ogs† til at udfylde elementet TaxCategory i grupperne TaxSubtotal og AllowanceCharge. Nummeret er baseret p† UNCL5305-standarden.;
                           ENU=Specifies the VAT category in connection with electronic document sending. For example, when you send sales documents through the PEPPOL service, the value in this field is used to populate several fields, such as the ClassifiedTaxCategory element in the Item group. It is also used to populate the TaxCategory element in both the TaxSubtotal and AllowanceCharge group. The number is based on the UNCL5305 standard.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Tax Category";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den spedit›r, som transporterer varerne.;
                           ENU=Specifies the code for the shipping agent who is transporting the items.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Code";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for servicen, f.eks. levering samme dag, som tilbydes af spedit›ren.;
                           ENU=Specifies the code for the service, such as a one-day delivery, that is offered by the shipping agent.];
                ApplicationArea=#Suite;
                SourceExpr="Shipping Agent Service Code";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen vedr›rer, n†r salget er relateret til en sag.;
                           ENU=Specifies which work type the resource applies to when the sale is related to a job.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Type Code";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordrelinje, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, der skal benyttes p† relaterede anl‘gsfinansposter.;
                           ENU=Specifies the date that will be used on related fixed asset ledger entries.];
                ApplicationArea=#Advanced;
                SourceExpr="FA Posting Date";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om afskrivningen er beregnet op til linjens anl‘gsbogf›ringsdato.;
                           ENU=Specifies if depreciation was calculated until the FA posting date of the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Depr. until FA Posting Date";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf›res til, hvis du har valgt Anl‘gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#Advanced;
                SourceExpr="Depreciation Book Code";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver, om typen er Anl‘g, at oplysningerne p† linjen skal bogf›res til alle de anl‘gsaktiver, der er defineret i afskrivningsprofiler. ";
                           ENU="Specifies, if the type is Fixed Asset, that information on the line is to be posted to all the assets defined depreciation books. "];
                ApplicationArea=#Advanced;
                SourceExpr="Use Duplication List";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en afskrivningsprofilkode, hvis kladdelinjen b†de skal bogf›res til den p†g‘ldende afskrivningsprofil og til afskrivningsprofilen i feltet Afskrivningsprofilkode.;
                           ENU=Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.];
                ApplicationArea=#Advanced;
                SourceExpr="Duplicate in Depreciation Book";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
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

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den periodiseringsskabelon, der styrer, hvordan indt‘gter fra dette salgsdokument periodiseres til de forskellige regnskabsperioder, n†r varen eller tjenesten leveres.;
                           ENU=Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.];
                ApplicationArea=#Suite;
                SourceExpr="Deferral Code";
                Visible=FALSE;
                Enabled=(Type <> Type::"Fixed Asset") AND (Type <> Type::" ") }

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

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret.;
                           ENU=Specifies the document number.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No.";
                Visible=FALSE;
                Editable=FALSE }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret.;
                           ENU=Specifies the line number.];
                ApplicationArea=#Advanced;
                SourceExpr="Line No.";
                Visible=FALSE;
                Editable=FALSE }

    { 1060000;2;Field     ;
                ToolTipML=[DAN="Angiver kontokoden for debitoren. ";
                           ENU="Specifies the account code of the customer. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Code" }

    { 39  ;1   ;Group     ;
                GroupType=Group }

    { 33  ;2   ;Group     ;
                GroupType=Group }

    { 7   ;3   ;Field     ;
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

    { 31  ;3   ;Field     ;
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

    { 29  ;3   ;Field     ;
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

    { 15  ;2   ;Group     ;
                GroupType=Group }

    { 13  ;3   ;Field     ;
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

    { 11  ;3   ;Field     ;
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

    { 9   ;3   ;Field     ;
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
      TotalSalesHeader@1014 : Record 36;
      TotalSalesLine@1013 : Record 37;
      Currency@1024 : Record 4;
      SalesSetup@1010 : Record 311;
      ApplicationAreaSetup@1008 : Record 9178;
      TempOptionLookupBuffer@1018 : TEMPORARY Record 1670;
      TransferExtendedText@1003 : Codeunit 378;
      SalesPriceCalcMgt@1005 : Codeunit 7000;
      ItemAvailFormsMgt@1001 : Codeunit 353;
      SalesCalcDiscByType@1015 : Codeunit 56;
      DocumentTotals@1016 : Codeunit 57;
      VATAmount@1017 : Decimal;
      InvoiceDiscountAmount@1009 : Decimal;
      InvoiceDiscountPct@1023 : Decimal;
      AmountWithDiscountAllowed@1021 : Decimal;
      ShortcutDimCode@1004 : ARRAY [8] OF Code[20];
      UpdateAllowedVar@1002 : Boolean;
      Text000@1006 : TextConst 'DAN=Denne funktion kan ikke k›res i visningstilstand.;ENU=Unable to run this function while in View mode.';
      LocationCodeVisible@1007 : Boolean;
      InvDiscAmountEditable@1012 : Boolean;
      IsCommentLine@1000 : Boolean;
      UnitofMeasureCodeIsChangeable@1011 : Boolean;
      IsFoundation@1020 : Boolean;
      ItemChargeStyleExpression@1022 : Text;
      TypeAsText@1098 : Text[30];

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
    PROCEDURE CalcInvDisc@8();
    VAR
      SalesCalcDiscount@1000 : Codeunit 60;
    BEGIN
      SalesCalcDiscount.CalculateInvoiceDiscountOnLine(Rec);
    END;

    [External]
    PROCEDURE ExplodeBOM@3();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
    END;

    [External]
    PROCEDURE GetShipment@4();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Sales-Get Shipment",Rec);
    END;

    [External]
    PROCEDURE InsertExtendedText@7(Unconditionally@1000 : Boolean);
    BEGIN
      IF TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
        CurrPage.SAVERECORD;
        COMMIT;
        TransferExtendedText.InsertSalesExtText(Rec);
      END;
      IF TransferExtendedText.MakeUpdate THEN
        UpdatePage(TRUE);
    END;

    [External]
    PROCEDURE UpdatePage@12(SetSaveRecord@1000 : Boolean);
    BEGIN
      CurrPage.UPDATE(SetSaveRecord);
    END;

    [Internal]
    PROCEDURE ShowPrices@15();
    BEGIN
      TotalSalesHeader.GET("Document Type","Document No.");
      CLEAR(SalesPriceCalcMgt);
      SalesPriceCalcMgt.GetSalesLinePrice(TotalSalesHeader,Rec);
    END;

    [External]
    PROCEDURE ShowLineDisc@16();
    BEGIN
      TotalSalesHeader.GET("Document Type","Document No.");
      CLEAR(SalesPriceCalcMgt);
      SalesPriceCalcMgt.GetSalesLineLineDisc(TotalSalesHeader,Rec);
    END;

    [External]
    PROCEDURE SetUpdateAllowed@5(UpdateAllowed@1000 : Boolean);
    BEGIN
      UpdateAllowedVar := UpdateAllowed;
    END;

    [External]
    PROCEDURE UpdateAllowed@20() : Boolean;
    BEGIN
      IF UpdateAllowedVar = FALSE THEN BEGIN
        MESSAGE(Text000);
        EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE NoOnAfterValidate@19066594();
    BEGIN
      InsertExtendedText(FALSE);

      IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND (xRec."No." <> '') THEN
        CurrPage.SAVERECORD;
    END;

    LOCAL PROCEDURE UpdateEditableOnRow@11();
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

    LOCAL PROCEDURE ValidateAutoReserve@19032465();
    BEGIN
      IF Reserve = Reserve::Always THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
      END;
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

    LOCAL PROCEDURE CalculateTotals@6();
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

    LOCAL PROCEDURE RedistributeTotalsOnAfterValidate@2();
    BEGIN
      CurrPage.SAVERECORD;

      TotalSalesHeader.GET("Document Type","Document No.");
      DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE UpdateTypeText@18();
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

    BEGIN
    END.
  }
}

