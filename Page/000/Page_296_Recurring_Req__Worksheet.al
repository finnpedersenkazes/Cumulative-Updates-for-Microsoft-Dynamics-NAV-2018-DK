OBJECT Page 296 Recurring Req. Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Indk›bsgentag.kladde;
               ENU=Recurring Req. Worksheet];
    SaveValues=Yes;
    SourceTable=Table246;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 JnlSelected@1000 : Boolean;
               BEGIN
                 OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Worksheet Template Name" = '');
                 IF OpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 ReqJnlManagement.TemplateSelection(PAGE::"Recurring Req. Worksheet",TRUE,0,Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');
                 ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  ReqJnlManagement.SetUpNewLine(Rec,xRec);
                  CLEAR(ShortcutDimCode);
                END;

    OnAfterGetCurrRecord=BEGIN
                           ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 38      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om varen eller ressourcen.;
                                 ENU=View or change detailed information about the item or resource.];
                      ApplicationArea=#Planning;
                      RunObject=Codeunit 335;
                      Image=EditLines }
      { 74      ;2   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikles over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Planning;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 75      ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder, f.eks. dag, uge eller m†ned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Planning;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByPeriod)
                               END;
                                }
      { 76      ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at oprette hver varefarve som en separat vare kan du n›jes med ‚n vare i forskellige farvevarianter.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByVariant)
                               END;
                                }
      { 44      ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByLocation)
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
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByBOM)
                               END;
                                }
      { 69      ;2   ;Action    ;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=Reservationsposter;
                                 ENU=Reservation Entries];
                      ToolTipML=[DAN=Vis posterne for hver reservation, der er foretaget, enten manuelt eller automatisk.;
                                 ENU=View the entries for every reservation that is made, either manually or automatically.];
                      ApplicationArea=#Planning;
                      Image=ReservationLedger;
                      OnAction=BEGIN
                                 ShowReservationEntries(TRUE);
                               END;
                                }
      { 81      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 6500    ;2   ;Action    ;
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 40      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beregn plan;
                                 ENU=Calculate Plan];
                      ToolTipML=[DAN=Brug en k›rsel som hj‘lp til at beregne en forsyningsplan for varer og lagervarer, for hvilke feltet Genbestillingssystem er indstillet til K›b eller Overf›rsel.;
                                 ENU=Use a batch job to help you calculate a supply plan for items and stockkeeping units that have the Replenishment System field set to Purchase or Transfer.];
                      ApplicationArea=#Planning;
                      Image=CalculatePlan;
                      OnAction=BEGIN
                                 ReorderItems.SetTemplAndWorksheet("Worksheet Template Name","Journal Batch Name");
                                 ReorderItems.RUNMODAL;
                                 CLEAR(ReorderItems);
                               END;
                                }
      { 41      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udf›r aktionsmeddelelse;
                                 ENU=Carry &Out Action Message];
                      ToolTipML=[DAN=Brug en k›rsel som hj‘lp til at oprette faktiske forsyningsordrer ud fra ordreforslagene.;
                                 ENU=Use a batch job to help you create actual supply orders from the order proposals.];
                      ApplicationArea=#Planning;
                      Image=CarryOutActionMessage;
                      OnAction=VAR
                                 MakePurchOrder@1001 : Report 493;
                               BEGIN
                                 MakePurchOrder.SetReqWkshLine(Rec);
                                 MakePurchOrder.RUNMODAL;
                                 MakePurchOrder.GetReqWkshLine(Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 43      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserv‚r en eller flere enheder af varen p† sagsplanl‘gningslinjen, enten fra lageret eller den indg†ende forsyning.;
                                 ENU=Reserve one or more units of the item on the job planning line, either from inventory or from incoming supply.];
                      ApplicationArea=#Planning;
                      Image=Reserve;
                      OnAction=BEGIN
                                 CurrPage.SAVERECORD;
                                 ShowReservation;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 33  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† recorden.;
                           ENU=Specifies the name of the record.];
                ApplicationArea=#Planning;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             ReqJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           ReqJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et gentagelsesprincip, hvis du har angivet, at indk›bskladden skal gentages, i feltet Gentagelse.;
                           ENU=Specifies a recurring method, if you have indicated in the Recurring field that the worksheet is a recurring requisition worksheet.];
                ApplicationArea=#Planning;
                SourceExpr="Recurring Method" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et gentagelsesinterval, hvis det er angivet, at indk›bskladden skal gentages, i feltet Gentagelse.;
                           ENU=Specifies a recurring frequency, if it is indicated in the Recurring field that the worksheet is a recurring requisition worksheet.];
                ApplicationArea=#Planning;
                SourceExpr="Recurring Frequency" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type indk›bskladdelinje, du vil oprette.;
                           ENU=Specifies the type of requisition worksheet line you are creating.];
                ApplicationArea=#Planning;
                SourceExpr=Type;
                OnValidate=BEGIN
                             ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Planning;
                SourceExpr="No.";
                OnValidate=BEGIN
                             ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en handling for at genoprette balancen i forholdet mellem udbud og eftersp›rgsel.;
                           ENU=Specifies an action to take to rebalance the demand-supply situation.];
                ApplicationArea=#Planning;
                SourceExpr="Action Message" }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den aktionsmeddelelse, som foresl†s for linjen, skal godkendes.;
                           ENU=Specifies whether to accept the action message proposed for the line.];
                ApplicationArea=#Planning;
                SourceExpr="Accept Action Message" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tekst, der beskriver posten.;
                           ENU=Specifies text that describes the entry.];
                ApplicationArea=#Planning;
                SourceExpr=Description }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ekstra tekst til beskrivelse af posten eller en bem‘rkning om indk›bskladdelinjen.;
                           ENU=Specifies additional text describing the entry, or a remark about the requisition worksheet line.];
                ApplicationArea=#Planning;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lagerlokation, hvor de bestilte varer skal registreres p†.;
                           ENU=Specifies a code for an inventory location where the items that are being ordered will be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen eller ressourcen der skal angives p† linjen.;
                           ENU=Specifies the number of units of the item or resource specified on the line.];
                ApplicationArea=#Planning;
                SourceExpr=Quantity }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Planning;
                SourceExpr="Unit of Measure Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, der skal levere varerne i k›bsordren.;
                           ENU=Specifies the number of the vendor who will ship the items in the purchase order.];
                ApplicationArea=#Planning;
                SourceExpr="Vendor No.";
                OnValidate=BEGIN
                             ReqJnlManagement.GetDescriptionAndRcptName(Rec,Description2,BuyFromVendorName);
                             ShowShortcutDimCode(ShortcutDimCode);
                           END;
                            }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Planning;
                SourceExpr="Vendor Item No." }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
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

    { 35  ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver valutakoden for rekvisitionslinjerne.;
                           ENU=Specifies the currency code for the requisition lines.];
                ApplicationArea=#Planning;
                SourceExpr="Currency Code";
                Visible=FALSE;
                OnAssistEdit=BEGIN
                               ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
                               IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                                 VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);

                               CLEAR(ChangeExchangeRate);
                             END;
                              }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Planning;
                SourceExpr="Direct Unit Cost" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p† linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Planning;
                SourceExpr="Line Discount %";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Planning;
                SourceExpr="Order Date";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du kan forvente at modtage varerne.;
                           ENU=Specifies the date when you can expect to receive the items.];
                ApplicationArea=#Planning;
                SourceExpr="Due Date" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et p† den bruger, der bestiller varerne p† linjen.;
                           ENU=Specifies the ID of the user who is ordering the items on the line.];
                ApplicationArea=#Planning;
                SourceExpr="Requester ID";
                Visible=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Planning;
                SourceExpr="Prod. Order No.";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varerne p† linjen er blevet godkendt til k›b.;
                           ENU=Specifies whether the items on the line have been approved for purchase.];
                ApplicationArea=#Planning;
                SourceExpr=Confirmed;
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dato, hvor indk›bsgentagelseskladden bliver konverteret til en indk›bsordre.;
                           ENU=Specifies the last date on which the recurring requisition worksheet will be converted to a purchase order.];
                ApplicationArea=#Planning;
                SourceExpr="Expiration Date" }

    { 28  ;1   ;Group      }

    { 1902205001;2;Group  ;
                GroupType=FixedLayout }

    { 1903866901;3;Group  ;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description] }

    { 29  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del af kladdebeskrivelsen.;
                           ENU=Specifies an additional part of the worksheet description.];
                ApplicationArea=#Planning;
                SourceExpr=Description2;
                Editable=FALSE;
                ShowCaption=No }

    { 1902759701;3;Group  ;
                CaptionML=[DAN=Leverand›rnavn;
                           ENU=Buy-from Vendor Name] }

    { 31  ;4   ;Field     ;
                CaptionML=[DAN=Leverand›rnavn;
                           ENU=Buy-from Vendor Name];
                ToolTipML=[DAN=Angiver kreditoren i henhold til v‘rdierne i felterne Bilagsnr. og Dokumenttype.;
                           ENU=Specifies the vendor according to the values in the Document No. and Document Type fields.];
                ApplicationArea=#Planning;
                SourceExpr=BuyFromVendorName;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ReorderItems@1000 : Report 699;
      ReqJnlManagement@1002 : Codeunit 330;
      ItemAvailFormsMgt@1008 : Codeunit 353;
      ChangeExchangeRate@1001 : Page 511;
      CurrentJnlBatchName@1003 : Code[10];
      Description2@1004 : Text[50];
      BuyFromVendorName@1005 : Text[50];
      ShortcutDimCode@1006 : ARRAY [8] OF Code[20];
      OpenedFromBatch@1007 : Boolean;

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      ReqJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

