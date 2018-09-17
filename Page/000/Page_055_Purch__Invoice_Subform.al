OBJECT Page 55 Purch. Invoice Subform
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
    SourceTable=Table39;
    DelayedInsert=Yes;
    SourceTableView=WHERE(Document Type=FILTER(Invoice));
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnInit=VAR
             ApplicationAreaSetup@1000 : Record 9178;
           BEGIN
             PurchasesPayablesSetup.GET;
             Currency.InitRoundingPrecision;
             TempOptionLookupBuffer.FillBuffer(TempOptionLookupBuffer."Lookup Type"::Sales);
             IsFoundation := ApplicationAreaSetup.IsFoundationEnabled;
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

    OnInsertRecord=BEGIN
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
                           CalculateTotals;
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
      { 1900205804;3 ;Action    ;
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
      { 1901652204;3 ;Action    ;
                      Name=GetReceiptLines;
                      AccessByPermission=TableData 120=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent k›bsleverancelinjer;
                                 ENU=&Get Receipt Lines];
                      ToolTipML=[DAN=V‘lg en bogf›rt k›bsleverance for den vare, som varegebyret skal tildeles p†.;
                                 ENU=Select a posted purchase receipt for the item that you want to assign the item charge to.];
                      ApplicationArea=#Suite;
                      Image=Receipt;
                      OnAction=BEGIN
                                 GetReceipt;
                               END;
                                }
      { 1904945204;2 ;ActionGroup;
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
      { 1901092104;3 ;Action    ;
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
      { 1905427604;3 ;Action    ;
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
      { 1907075804;3 ;Action    ;
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
      { 35      ;2   ;ActionGroup;
                      CaptionML=[DAN=Relaterede oplysninger;
                                 ENU=Related Information] }
      { 1904974904;3 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1901431304;3 ;Action    ;
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
      { 19      ;3   ;Action    ;
                      Name=DeferralSchedule;
                      CaptionML=[DAN=Periodiseringsplan;
                                 ENU=Deferral Schedule];
                      ToolTipML=[DAN=Vis eller rediger den periodiseringsplan, der styrer, hvordan p†l›bne udgifter fra dette k›bsdokument periodiseres til forskellige regnskabsperioder, n†r bilaget bogf›res.;
                                 ENU=View or edit the deferral schedule that governs how expenses incurred with this purchase document is deferred to different accounting periods when the document is posted.];
                      ApplicationArea=#Suite;
                      Enabled="Deferral Code" <> '';
                      Image=PaymentPeriod;
                      OnAction=VAR
                                 PurchHeader@1000 : Record 38;
                               BEGIN
                                 PurchHeader.GET("Document Type","Document No.");
                                 ShowDeferrals(PurchHeader."Posting Date",PurchHeader."Currency Code");
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

    { 7   ;2   ;Field     ;
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
                           ENU=Specifies the number of a general ledger account, an item, an additional cost or a fixed asset, depending on what you selected in the Type field.];
                ApplicationArea=#All;
                SourceExpr="No.";
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                             NoOnAfterValidate;

                             IF xRec."No." <> '' THEN
                               RedistributeTotalsOnAfterValidate;
                             UpdateTypeText;
                           END;

                ShowMandatory=Type <> Type::" " }

    { 72  ;2   ;Field     ;
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

    { 186 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncerninterne partner, som transaktionen er relateret til, hvis posten blev oprettet fra en koncernintern transaktion.;
                           ENU=Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Visible=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den vare eller konto i IC-partnerens virksomhed, der svarer til varen eller kontoen p† linjen.;
                           ENU=Specifies the item or account in your IC partner's company that corresponds to the item or account on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Ref. Type";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
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

    { 74  ;2   ;Field     ;
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
                CaptionML=[DAN=Beskrivelse/bem‘rkning;
                           ENU=Description/Comment];
                ToolTipML=[DAN=Angiver en beskrivelse af posten for det produkt, der skal k›bes. Hvis du vil tilf›je en ikke-transaktionsbaseret tekstlinje, skal du kun udfylde feltet Beskrivelse.;
                           ENU=Specifies a description of the entry of the product to be purchased. To add a non-transactional text line, fill in the Description field only.];
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

                ShowMandatory=Type <> Type::" " }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Advanced;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne p† linjen bliver placeret.;
                           ENU=Specifies the code for the location where the items on the line will be located.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal angives p† linjen.;
                           ENU=Specifies the number of units of the item specified on the line.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr=Quantity;
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
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
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedsbetegnelsen for varen, f.eks. 1 flaske eller 1 stk.;
                           ENU=Specifies the name of the unit of measure for the item, such as 1 bottle or 1 piece.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Basic,#Suite;
                BlankZero=Yes;
                SourceExpr="Direct Unit Cost";
                Enabled=NOT IsCommentLine;
                Editable=NOT IsCommentLine;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;

                ShowMandatory=(NOT IsCommentLine) AND ("No." <> '') }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k›bspris, der omfatter indirekte omkostninger, s†som fragt, der er knyttet til k›bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Indirect Cost %";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens enhedspris p† kladdelinjen.;
                           ENU=Specifies the unit cost of the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver pris for en enhed af varen.;
                           ENU=Specifies the price for one unit of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Price (LCY)";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

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

    { 52  ;2   ;Field     ;
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

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel›b, der ydes p† varen, p† linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Line Discount Amount";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, n†r fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE;
                OnValidate=BEGIN
                             CurrPage.SAVERECORD;
                             AmountWithDiscountAllowed := DocumentTotals.CalcTotalPurchAmountOnlyDiscountAllowed(Rec);
                             InvoiceDiscountAmount := ROUND(AmountWithDiscountAllowed * InvoiceDiscountPct / 100,Currency."Amount Rounding Precision");
                             ValidateInvoiceDiscountAmount;
                           END;
                            }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fakturarabatbel›bet for hele linjen.;
                           ENU=Specifies the invoice discount amount for the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kan tildele varegebyrer til linjen.;
                           ENU=Specifies that you can assign item charges to this line.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Allow Item Charge Assignment";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
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

    { 42  ;2   ;Field     ;
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

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sag. Hvis du udfylder dette felt og feltet Sagsopgavenr., bogf›res der en sagspost sammen med k›bslinjen.;
                           ENU=Specifies the number of the related job. If you fill in this field and the Job Task No. field, then a job ledger entry will be posted together with the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No.";
                Visible=FALSE }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type planl‘gningslinje, der blev oprettet, da sagsposten blev bogf›rt fra k›bslinjen. Hvis feltet er tomt, er der ikke oprettet planl‘gningslinjer for denne post.;
                           ENU=Specifies the type of planning line that was created when the job ledger entry is posted from the purchase line. If the field is empty, no planning lines were created for this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Type";
                Visible=FALSE }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsprisen pr. enhed, der g‘lder for den vare eller finansudgift, der bogf›res.;
                           ENU=Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Unit Price";
                Visible=FALSE }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjebel›bet for den sagspost, der er relateret til k›bslinjen.;
                           ENU=Specifies the line amount of the job ledger entry that is related to the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Amount";
                Visible=FALSE }

    { 108 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjerabatbel›bet for den sagspost, der er relateret til k›bslinjen.;
                           ENU=Specifies the line discount amount of the job ledger entry that is related to the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Discount Amount";
                Visible=FALSE }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjerabatprocentdelen for den sagspost, der er relateret til k›bslinjen.;
                           ENU=Specifies the line discount percentage of the job ledger entry that is related to the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Discount %";
                Visible=FALSE }

    { 94  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bruttobel›bet for den linje, som k›bslinjen vedr›rer.;
                           ENU=Specifies the gross amount of the line that the purchase line applies to.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Total Price";
                Visible=FALSE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsprisen pr. enhed, der g‘lder for den vare eller finansudgift, der bogf›res.;
                           ENU=Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Unit Price (LCY)";
                Visible=FALSE }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjens bruttobel›b angivet i den lokale valuta.;
                           ENU=Specifies the gross amount of the line, in the local currency.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Total Price (LCY)";
                Visible=FALSE }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjebel›bet for den sagspost, der er relateret til k›bslinjen.;
                           ENU=Specifies the line amount of the job ledger entry that is related to the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Amount (LCY)";
                Visible=FALSE }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjerabatbel›bet for den sagspost, der er relateret til k›bslinjen.;
                           ENU=Specifies the line discount amount of the job ledger entry that is related to the purchase line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Line Disc. Amount (LCY)";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order No.";
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordre, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order No.";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rammeordrelinje, hvorfra recorden stammer.;
                           ENU=Specifies the number of the blanket order line that the record originates from.];
                ApplicationArea=#Advanced;
                SourceExpr="Blanket Order Line No.";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et forsikringsnummer, hvis du har valgt indstillingen Anskaffelsespris i feltet Anl‘gsbogf›ringstype.;
                           ENU=Specifies an insurance number if you have selected the Acquisition Cost option in the FA Posting Type field.];
                ApplicationArea=#Advanced;
                SourceExpr="Insurance No.";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angivet nummeret for et anl‘gsaktiv, hvor afkrydsningsfeltet Budgetanl‘g er markeret. N†r du bogf›rer kladde- eller bilagslinje, oprettes en ekstra post for det budgetterede anl‘gsaktiv, hvor bel›bet har det modsatte fortegn.;
                           ENU=Specifies the number of a fixed asset with the Budgeted Asset check box selected. When you post the journal or document line, an additional entry is created for the budgeted fixed asset where the amount has the opposite sign.];
                ApplicationArea=#Advanced;
                SourceExpr="Budgeted FA No.";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver anl‘gsbogf›ringstypen, hvis du har valgt Anl‘gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the FA posting type if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#Advanced;
                SourceExpr="FA Posting Type";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf›res til, hvis du har valgt Anl‘gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#Advanced;
                SourceExpr="Depreciation Book Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om afskrivningen er beregnet op til linjens anl‘gsbogf›ringsdato.;
                           ENU=Specifies if depreciation was calculated until the FA posting date of the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Depr. until FA Posting Date";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den ekstra anskaffelsespris, der er bogf›rt p† linjen, blev afskrevet (da denne linje blev bogf›rt) i forhold til det bel›b, som anl‘gget allerede var afskrevet med.;
                           ENU=Specifies if, when this line was posted, the additional acquisition cost posted on the line was depreciated in proportion to the amount by which the fixed asset had already been depreciated.];
                ApplicationArea=#Advanced;
                SourceExpr="Depr. Acquisition Cost";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en afskrivningsprofilkode, hvis kladdelinjen b†de skal bogf›res til den p†g‘ldende afskrivningsprofil og til afskrivningsprofilen i feltet Afskrivningsprofilkode.;
                           ENU=Specifies a depreciation book code if you want the journal line to be posted to that depreciation book, as well as to the depreciation book in the Depreciation Book Code field.];
                ApplicationArea=#Advanced;
                SourceExpr="Duplicate in Depreciation Book";
                Visible=FALSE }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver, om typen er Anl‘g, at oplysningerne p† linjen skal bogf›res til alle de anl‘gsaktiver, der er defineret i afskrivningsprofiler. ";
                           ENU="Specifies, if the type is Fixed Asset, that information on the line is to be posted to all the assets defined depreciation books. "];
                ApplicationArea=#Advanced;
                SourceExpr="Use Duplication List";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette dokument eller denne kladdelinje udlignes p†.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied -to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den periodiseringsskabelon, der styrer, hvordan udgifter der er betalt med dette k›bsbilag, periodiseres til forskellige regnskabsperioder, n†r udgiften eller indt‘gten indtr‘ffer.;
                           ENU=Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.];
                ApplicationArea=#Suite;
                SourceExpr="Deferral Code";
                TableRelation="Deferral Template"."Deferral Code";
                Visible=FALSE;
                Enabled=(Type <> Type::"Fixed Asset") AND (Type <> Type::" ") }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
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

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret.;
                           ENU=Specifies the document number.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No.";
                Visible=FALSE;
                Editable=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjenummeret.;
                           ENU=Specifies the line's number.];
                ApplicationArea=#Advanced;
                SourceExpr="Line No.";
                Visible=FALSE;
                Editable=FALSE }

    { 39  ;1   ;Group     ;
                GroupType=Group }

    { 33  ;2   ;Group     ;
                GroupType=Group }

    { 25  ;3   ;Field     ;
                Name=AmountBeforeDiscount;
                CaptionML=[DAN=Subtotal ekskl. moms;
                           ENU=Subtotal Excl. VAT];
                ToolTipML=[DAN=Angiver summen af v‘rdien i feltet Linjebel›b ekskl. moms p† alle linjer i dokumentet.;
                           ENU=Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TotalPurchaseLine."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code,TotalPurchaseHeader."Prices Including VAT");
                Editable=FALSE }

    { 31  ;3   ;Field     ;
                Name=InvoiceDiscountAmount;
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
                ToolTipML=[DAN=Angiver et rabatbel›b, der tr‘kkes fra v‘rdien i feltet I alt inkl. moms. Du kan angive eller ‘ndre bel›bet manuelt.;
                           ENU=Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.];
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
                SourceExpr=TotalPurchaseLine.Amount;
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalExclVATCaption(Currency.Code);
                Editable=FALSE }

    { 11  ;3   ;Field     ;
                Name=Total VAT Amount;
                CaptionML=[DAN=Moms i alt;
                           ENU=Total VAT];
                ToolTipML=[DAN=Angiver summen af v‘rdien i feltet Linjebel›b ekskl. moms p† alle linjer i dokumentet minus eventuelle rabatbel›b i feltet Fakturarabatbel›b.;
                           ENU=Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.];
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
                SourceExpr=TotalPurchaseLine."Amount Including VAT";
                AutoFormatType=1;
                AutoFormatExpr=Currency.Code;
                CaptionClass=DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                Editable=FALSE }

  }
  CODE
  {
    VAR
      Currency@1026 : Record 4;
      PurchasesPayablesSetup@1013 : Record 312;
      TotalPurchaseHeader@1008 : Record 38;
      TotalPurchaseLine@1007 : Record 39;
      ApplicationAreaSetup@1000 : Record 9178;
      TempOptionLookupBuffer@1004 : TEMPORARY Record 1670;
      TransferExtendedText@1002 : Codeunit 378;
      ItemAvailFormsMgt@1006 : Codeunit 353;
      PurchCalcDiscByType@1010 : Codeunit 66;
      DocumentTotals@1009 : Codeunit 57;
      ShortcutDimCode@1003 : ARRAY [8] OF Code[20];
      VATAmount@1017 : Decimal;
      AmountWithDiscountAllowed@1015 : Decimal;
      IsFoundation@1005 : Boolean;
      InvDiscAmountEditable@1016 : Boolean;
      IsCommentLine@1019 : Boolean;
      UnitofMeasureCodeIsChangeable@1001 : Boolean;
      InvoiceDiscountAmount@1020 : Decimal;
      InvoiceDiscountPct@1014 : Decimal;
      TypeAsText@1011 : Text[30];
      ItemChargeStyleExpression@1012 : Text;

    [External]
    PROCEDURE ApproveCalcInvDisc@7();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)",Rec);
    END;

    LOCAL PROCEDURE ValidateInvoiceDiscountAmount@22();
    VAR
      PurchaseHeader@1000 : Record 38;
    BEGIN
      PurchaseHeader.GET("Document Type","Document No.");
      PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,PurchaseHeader);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE CalcInvDisc@1();
    VAR
      PurchCalcDiscount@1000 : Codeunit 70;
    BEGIN
      PurchCalcDiscount.CalculateInvoiceDiscountOnLine(Rec);
    END;

    LOCAL PROCEDURE ExplodeBOM@3();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM",Rec);
    END;

    LOCAL PROCEDURE GetReceipt@4();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Purch.-Get Receipt",Rec);
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

    LOCAL PROCEDURE RedistributeTotalsOnAfterValidate@8();
    BEGIN
      CurrPage.SAVERECORD;

      DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);

      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE UpdateEditableOnRow@14();
    VAR
      PurchaseLine@1000 : Record 39;
    BEGIN
      IF Type <> Type::" " THEN
        UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
      ELSE
        UnitofMeasureCodeIsChangeable := FALSE;

      IF TotalPurchaseHeader."No." <> '' THEN BEGIN
        PurchaseLine.SETRANGE("Document No.",TotalPurchaseHeader."No.");
        PurchaseLine.SETRANGE("Document Type",TotalPurchaseHeader."Document Type");
        IF NOT PurchaseLine.ISEMPTY THEN
          InvDiscAmountEditable :=
            PurchCalcDiscByType.InvoiceDiscIsAllowed(TotalPurchaseHeader."Invoice Disc. Code") AND CurrPage.EDITABLE;
      END;

      IsCommentLine := Type = Type::" ";
    END;

    LOCAL PROCEDURE GetTotalPurchHeader@13();
    BEGIN
      IF NOT TotalPurchaseHeader.GET("Document Type","Document No.") THEN
        CLEAR(TotalPurchaseHeader);
      IF Currency.Code <> TotalPurchaseHeader."Currency Code" THEN
        IF NOT Currency.GET(TotalPurchaseHeader."Currency Code") THEN BEGIN
          CLEAR(Currency);
          Currency.InitRoundingPrecision;
        END
    END;

    LOCAL PROCEDURE CalculateTotals@25();
    BEGIN
      GetTotalPurchHeader;
      TotalPurchaseHeader.CALCFIELDS("Recalculate Invoice Disc.");

      IF PurchasesPayablesSetup."Calc. Inv. Discount" AND ("Document No." <> '') AND
         (TotalPurchaseHeader."Vendor Posting Group" <> '') AND TotalPurchaseHeader."Recalculate Invoice Disc."
      THEN
        IF FIND THEN
          CalcInvDisc;

      DocumentTotals.CalculatePurchasePageTotals(TotalPurchaseLine,VATAmount,Rec);
      AmountWithDiscountAllowed := DocumentTotals.CalcTotalPurchAmountOnlyDiscountAllowed(Rec);
      InvoiceDiscountAmount := TotalPurchaseLine."Inv. Discount Amount";
      InvoiceDiscountPct := PurchCalcDiscByType.GetVendInvoiceDiscountPct(Rec);
    END;

    LOCAL PROCEDURE UpdateTypeText@10();
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.FIELD(FIELDNO(Type)));
    END;

    LOCAL PROCEDURE SetItemChargeFieldsStyle@2();
    BEGIN
      ItemChargeStyleExpression := '';
      IF AssignedItemCharge THEN
        ItemChargeStyleExpression := 'Unfavorable';
    END;

    BEGIN
    END.
  }
}

