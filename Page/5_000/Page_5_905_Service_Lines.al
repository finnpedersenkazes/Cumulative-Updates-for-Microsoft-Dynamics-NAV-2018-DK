OBJECT Page 5905 Service Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Servicelinjer;
               ENU=Service Lines];
    SourceTable=Table5902;
    DelayedInsert=Yes;
    PopulateAllFields=Yes;
    DataCaptionFields=Document Type,Document No.;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=BEGIN
                 CLEAR(SelectionFilter);
                 SelectionFilter := SelectionFilter::"Lines per Selected Service Item";
                 SetSelectionFilter;

                 ServMgtSetup.GET;
                 CASE ServMgtSetup."Fault Reporting Level" OF
                   ServMgtSetup."Fault Reporting Level"::None:
                     BEGIN
                       FaultAreaCodeVisible := FALSE;
                       SymptomCodeVisible := FALSE;
                       FaultCodeVisible := FALSE;
                       ResolutionCodeVisible := FALSE;
                     END;
                   ServMgtSetup."Fault Reporting Level"::Fault:
                     BEGIN
                       FaultAreaCodeVisible := FALSE;
                       SymptomCodeVisible := FALSE;
                       FaultCodeVisible := TRUE;
                       ResolutionCodeVisible := TRUE;
                     END;
                   ServMgtSetup."Fault Reporting Level"::"Fault+Symptom":
                     BEGIN
                       FaultAreaCodeVisible := FALSE;
                       SymptomCodeVisible := TRUE;
                       FaultCodeVisible := TRUE;
                       ResolutionCodeVisible := TRUE;
                     END;
                   ServMgtSetup."Fault Reporting Level"::"Fault+Symptom+Area (IRIS)":
                     BEGIN
                       FaultAreaCodeVisible := TRUE;
                       SymptomCodeVisible := TRUE;
                       FaultCodeVisible := TRUE;
                       ResolutionCodeVisible := TRUE;
                     END;
                 END;
               END;

    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  CLEAR(ShortcutDimCode);

                  IF ServHeader.GET("Document Type","Document No.") THEN BEGIN
                    IF ServHeader."Link Service to Service Item" THEN
                      IF SelectionFilter <> SelectionFilter::"Lines Not Item Related" THEN
                        VALIDATE("Service Item Line No.",ServItemLineNo)
                      ELSE
                        VALIDATE("Service Item Line No.",0)
                    ELSE
                      VALIDATE("Service Item Line No.",0);
                  END;
                END;

    OnInsertRecord=BEGIN
                     IF NOT AddExtendedText THEN
                       "Line No." := GetNextLineNo(xRec,BelowxRec);
                   END;

    OnDeleteRecord=VAR
                     ReserveServLine@1000 : Codeunit 99000842;
                   BEGIN
                     IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
                       COMMIT;
                       IF NOT ReserveServLine.DeleteLineConfirm(Rec) THEN
                         EXIT(FALSE);
                       ReserveServLine.DeleteLine(Rec);
                     END;
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 148     ;1   ;ActionGroup;
                      CaptionML=[DAN=O&rdre;
                                 ENU=O&rder];
                      Image=Order }
      { 152     ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Servicepo&ster;
                                 ENU=Service Ledger E&ntries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf›ringstransaktioner i servicedokumenter.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Page 5912;
                      RunPageView=SORTING(Service Order No.,Service Item No. (Serviced),Entry Type,Moved from Prepaid Acc.,Posting Date,Open,Type);
                      RunPageLink=Service Order No.=FIELD(Document No.);
                      Image=ServiceLedger }
      { 153     ;2   ;Action    ;
                      CaptionML=[DAN=&Garantiposter;
                                 ENU=&Warranty Ledger Entries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf›ringstransaktioner i servicedokumenter, der indeholder garantiaftaler.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents that contain warranty agreements.];
                      ApplicationArea=#Service;
                      RunObject=Page 5913;
                      RunPageView=SORTING(Service Order No.,Posting Date,Document No.);
                      RunPageLink=Service Order No.=FIELD(Document No.);
                      Image=WarrantyLedger }
      { 154     ;2   ;Action    ;
                      CaptionML=[DAN=&Sagsposter;
                                 ENU=&Job Ledger Entries];
                      ToolTipML=[DAN=Vis alle sagsposter, der stammer fra bogf›ringstransaktioner i servicedokumentet, som omfatter en sag.;
                                 ENU=View all the job ledger entries that result from posting transactions in the service document that involve a job.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 92;
                      RunPageView=SORTING(Service Order No.,Posting Date)
                                  WHERE(Entry Type=CONST(Usage));
                      RunPageLink=Service Order No.=FIELD(Document No.);
                      Image=JobLedger }
      { 158     ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=D&ebitorkort;
                                 ENU=&Customer Card];
                      ToolTipML=[DAN=F† vist detaljerede oplysninger om debitoren.;
                                 ENU=View detailed information about the customer.];
                      ApplicationArea=#Service;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Customer No.);
                      Image=Customer }
      { 162     ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Service Header),
                                  Table Subtype=FIELD(Document Type),
                                  No.=FIELD(Document No.),
                                  Type=CONST(General);
                      Image=ViewComments }
      { 163     ;2   ;Action    ;
                      CaptionML=[DAN=L&everancer;
                                 ENU=S&hipments];
                      ToolTipML=[DAN=F† vist relaterede bogf›rte serviceleverancer.;
                                 ENU=View related posted service shipments.];
                      ApplicationArea=#Service;
                      Image=Shipment;
                      OnAction=VAR
                                 ServShptHeader@1000 : Record 5990;
                               BEGIN
                                 ServShptHeader.RESET;
                                 ServShptHeader.FILTERGROUP(2);
                                 ServShptHeader.SETRANGE("Order No.","Document No.");
                                 ServShptHeader.FILTERGROUP(0);
                                 PAGE.RUNMODAL(0,ServShptHeader)
                               END;
                                }
      { 164     ;2   ;Action    ;
                      CaptionML=[DAN=Fakturaer;
                                 ENU=Invoices];
                      ToolTipML=[DAN=Vis en liste med igangv‘rende salgsfakturaer for ordren.;
                                 ENU=View a list of ongoing sales invoices for the order.];
                      ApplicationArea=#Service;
                      Image=Invoice;
                      OnAction=VAR
                                 ServInvHeader@1000 : Record 5992;
                               BEGIN
                                 ServInvHeader.RESET;
                                 ServInvHeader.FILTERGROUP(2);
                                 ServInvHeader.SETRANGE("Order No.","Document No.");
                                 ServInvHeader.FILTERGROUP(0);
                                 PAGE.RUNMODAL(0,ServInvHeader)
                               END;
                                }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Lagerleverancelinjer;
                                 ENU=Whse. Shipment Lines];
                      ToolTipML=[DAN=Vis igangv‘rende lagerleverancer for bilaget, i avancerede lagerops‘tninger.;
                                 ENU=View ongoing warehouse shipments for the document, in advanced warehouse configurations.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7341;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.);
                      RunPageLink=Source Type=CONST(5902),
                                  Source Subtype=FIELD(Document Type),
                                  Source No.=FIELD(Document No.);
                      Image=ShipmentLines }
      { 109     ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 116     ;2   ;Action    ;
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
      { 110     ;2   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Planning;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByEvent);
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 111     ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m†ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Planning;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByPeriod);
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 112     ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByVariant);
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 113     ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByLocation);
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 23      ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Planning;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByBOM);
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 115     ;2   ;Action    ;
                      Name=ReservationEntries;
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
      { 26      ;2   ;Action    ;
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
      { 17      ;2   ;Action    ;
                      Name=SelectItemSubstitution;
                      AccessByPermission=TableData 5715=R;
                      CaptionML=[DAN=V‘lg erstatningsvare;
                                 ENU=Select Item Substitution];
                      ToolTipML=[DAN=V‘lg en anden vare, der er konfigureret til at blive handlet i stedet for den originale vare, hvis den ikke er tilg‘ngelig.;
                                 ENU=Select another item that has been set up to be traded instead of the original item if it is unavailable.];
                      ApplicationArea=#Advanced;
                      Image=SelectItemSubstitution;
                      OnAction=BEGIN
                                 CurrPage.SAVERECORD;
                                 ShowItemSub;
                                 CurrPage.UPDATE(TRUE);
                                 AutoReserve;
                               END;
                                }
      { 133     ;2   ;Action    ;
                      CaptionML=[DAN=&Fejl/l›sn.koderelationer;
                                 ENU=&Fault/Resol. Codes Relationships];
                      ToolTipML=[DAN=F† vist eller rediger forholdet mellem fejlkode, herunder fejl, fejlomr†der og symptomkoder, samt l›sningskoder og serviceartikelgrupper. De eksisterende kombinationer af disse koder vises for serviceartikelgruppen for den serviceartikel, hvorfra du har f†et adgang til vinduet, og antallet af forekomster for hver enkelt vises ogs†.;
                                 ENU=View or edit the relationships between fault codes, including the fault, fault area, and symptom codes, as well as resolution codes and service item groups. It displays the existing combinations of these codes for the service item group of the service item from which you accessed the window and the number of occurrences for each one.];
                      ApplicationArea=#Service;
                      Image=FaultDefault;
                      OnAction=BEGIN
                                 SelectFaultResolutionCode;
                               END;
                                }
      { 185     ;2   ;Action    ;
                      AccessByPermission=TableData 99000880=R;
                      CaptionML=[DAN=Beregning af leverings&tid;
                                 ENU=Order &Promising];
                      ToolTipML=[DAN=Beregn afsendelses- og leveringsdatoerne ud fra varens kendte og forventede tilg‘ngelighedsdatoer, og oplys derefter datoerne til debitoren.;
                                 ENU=Calculate the shipment and delivery dates based on the item's known and expected availability dates, and then promise the dates to the customer.];
                      ApplicationArea=#Planning;
                      Image=OrderPromising;
                      OnAction=BEGIN
                                 ShowOrderPromisingLine;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 94      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 97      ;2   ;Action    ;
                      AccessByPermission=TableData 279=R;
                      CaptionML=[DAN=&Inds‘t udv. tekster;
                                 ENU=Insert &Ext. Texts];
                      ToolTipML=[DAN=Inds‘t den forl‘ngede varebeskrivelse, som h›rer til varen, der behandles p† linjen.;
                                 ENU=Insert the extended item description that is set up for the item that is being processed on the line.];
                      ApplicationArea=#Service;
                      Image=Text;
                      OnAction=BEGIN
                                 InsertExtendedText(TRUE);
                               END;
                                }
      { 98      ;2   ;Action    ;
                      CaptionML=[DAN=Inds‘t &startgebyr;
                                 ENU=Insert &Starting Fee];
                      ToolTipML=[DAN=Tilf›j et generelt startgebyr for serviceordren.;
                                 ENU=Add a general starting fee for the service order.];
                      ApplicationArea=#Service;
                      Image=InsertStartingFee;
                      OnAction=BEGIN
                                 InsertStartFee;
                               END;
                                }
      { 16      ;2   ;Action    ;
                      CaptionML=[DAN=Inds‘t r&ejseomkostninger;
                                 ENU=Insert &Travel Fee];
                      ToolTipML=[DAN=Tilf›j generelle rejseomkostninger for serviceordren.;
                                 ENU=Add a general travel fee for the service order.];
                      ApplicationArea=#Service;
                      Image=InsertTravelFee;
                      OnAction=BEGIN
                                 InsertTravelFee;
                               END;
                                }
      { 99      ;2   ;Action    ;
                      CaptionML=[DAN=Op&del ressourcelinje;
                                 ENU=S&plit Resource Line];
                      ToolTipML=[DAN=Fordel en ressources arbejde p† flere serviceartikellinjer. Hvis den samme ressource (f.eks. en tekniker) arbejder p† alle serviceartiklerne i serviceordren, kan du registrere de samlede ressourcetimer for kun ‚n serviceartikel og derefter opdele ressourcelinjen for at opdele ressourcetimerne p† ressourcelinjerne for de andre serviceartikler.;
                                 ENU=Distribute a resource's work on multiple service item lines. If the same resource works on all the service items in the service order, you can register the total resource hours for one service item only and then split the resource line to divide the resource hours onto the resource lines for the other service items.];
                      ApplicationArea=#Service;
                      Image=Split;
                      OnAction=BEGIN
                                 SplitResourceLine;
                               END;
                                }
      { 114     ;2   ;Action    ;
                      Name=Reserve;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den n›dvendige m‘ngde p† den bilagslinje, som vinduet blev †bnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Service;
                      Image=Reserve;
                      OnAction=BEGIN
                                 ShowReservation;
                               END;
                                }
      { 183     ;2   ;Action    ;
                      CaptionML=[DAN=Ordre&sporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil h›rende eftersp›rgsel. P† denne m†de kan du finde den oprindelige eftersp›rgsel, der medf›rte en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Service;
                      Image=OrderTracking;
                      OnAction=BEGIN
                                 ShowTracking;
                               END;
                                }
      { 27      ;2   ;Action    ;
                      AccessByPermission=TableData 5718=R;
                      CaptionML=[DAN=K&atalogvarer;
                                 ENU=Nonstoc&k Items];
                      ToolTipML=[DAN="Vis oversigten over varer, du ikke lagerf›rer. ";
                                 ENU="View the list of items that you do not carry in inventory. "];
                      ApplicationArea=#Service;
                      Image=NonStockItem;
                      OnAction=BEGIN
                                 ShowNonstock;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=&Opret linjer fra timesedler;
                                 ENU=&Create Lines from Time Sheets];
                      ToolTipML=[DAN=Inds‘t servicelinjer i henhold til en eksisterende timeseddel.;
                                 ENU=Insert service lines according to an existing time sheet.];
                      ApplicationArea=#Service;
                      Image=CreateLinesFromTimesheet;
                      OnAction=VAR
                                 TimeSheetMgt@1000 : Codeunit 950;
                               BEGIN
                                 IF CONFIRM(Text012,TRUE) THEN BEGIN
                                   ServHeader.GET("Document Type","Document No.");
                                   TimeSheetMgt.CreateServDocLinesFromTS(ServHeader);
                                 END;
                               END;
                                }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Pris/rabat;
                                 ENU=Price/Discount];
                      Image=Price }
      { 172     ;2   ;Action    ;
                      CaptionML=[DAN=Hent pris;
                                 ENU=Get Price];
                      ToolTipML=[DAN=Inds‘t den laveste mulige pris i feltet Enhedspris i henhold til enhver specialpris, du har angivet.;
                                 ENU=Insert the lowest possible price in the Unit Price field according to any special price that you have set up.];
                      ApplicationArea=#Service;
                      Image=Price;
                      OnAction=BEGIN
                                 ShowPrices;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 96      ;2   ;Action    ;
                      CaptionML=[DAN=Reguler servicepris;
                                 ENU=Adjust Service Price];
                      ToolTipML=[DAN=Reguler eksisterende servicepriser i henhold til ‘ndrede omkostninger, reservedele og ressourcetidsforbrug. Bem‘rk, at priserne ikke reguleres for serviceartikler, der h›rer til servicekontrakter, serviceartikler med garanti, serviceartikler p† linjer, der er helt eller delvist faktureret. N†r du k›rer serviceprisreguleringen, erstattes alle rabatter i ordren med serviceprisreguleringens v‘rdier.;
                                 ENU=Adjust existing service prices according to changed costs, spare parts, and resource hours. Note that prices are not adjusted for service items that belong to service contracts, service items with a warranty, items service on lines that are partially or fully invoiced. When you run the service price adjustment, all discounts in the order are replaced by the values of the service price adjustment.];
                      ApplicationArea=#Service;
                      Image=PriceAdjustment;
                      OnAction=VAR
                                 ServPriceMgmt@1001 : Codeunit 6080;
                               BEGIN
                                 ServItemLine.GET("Document Type","Document No.",ServItemLineNo);
                                 ServPriceMgmt.ShowPriceAdjustment(ServItemLine);
                               END;
                                }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=Annuller prisregulering;
                                 ENU=Undo Price Adjustment];
                      ToolTipML=[DAN=Annuller den seneste pris‘ndring, og nulstil den forrige pris.;
                                 ENU=Cancel the latest price change and reset the previous price.];
                      ApplicationArea=#Service;
                      Image=Undo;
                      OnAction=VAR
                                 ServPriceMgmt@1000 : Codeunit 6080;
                               BEGIN
                                 IF CONFIRM(Text011,FALSE) THEN BEGIN
                                   ServPriceMgmt.CheckServItemGrCode(Rec);
                                   ServPriceMgmt.ResetAdjustedLines(Rec);
                                 END;
                               END;
                                }
      { 173     ;2   ;Action    ;
                      AccessByPermission=TableData 7004=R;
                      CaptionML=[DAN=H&ent linjerabat;
                                 ENU=Get Li&ne Discount];
                      ToolTipML=[DAN=Inds‘t den bedste mulige rabat i feltet Linjerabat i henhold til enhver specialrabat, du har angivet.;
                                 ENU=Insert the best possible discount in the Line Discount field according to any special discounts that you have set up.];
                      ApplicationArea=#Service;
                      Image=LineDiscount;
                      OnAction=BEGIN
                                 ShowLineDisc;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 147     ;2   ;Action    ;
                      Name=Calculate Invoice Discount;
                      CaptionML=[DAN=&Beregn fakturarabat;
                                 ENU=Calculate &Invoice Discount];
                      ToolTipML=[DAN=Beregn fakturarabatten for serviceordren.;
                                 ENU=Calculate the invoice discount that applies to the service order.];
                      ApplicationArea=#Service;
                      Image=CalculateInvoiceDiscount;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Service-Disc. (Yes/No)",Rec);
                               END;
                                }
      { 79      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf›ring;
                                 ENU=P&osting];
                      Image=Post }
      { 93      ;2   ;Action    ;
                      Name=Post;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf›r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F‘rdigg›r bilaget eller kladden ved at bogf›re bel›b og antal p† de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ServLine@1001 : Record 5902;
                                 TempServLine@1007 : TEMPORARY Record 5902;
                                 ServPostYesNo@1008 : Codeunit 5981;
                               BEGIN
                                 CLEAR(ServLine);
                                 MODIFY(TRUE);
                                 CurrPage.SAVERECORD;
                                 CurrPage.SETSELECTIONFILTER(ServLine);

                                 IF ServLine.FINDFIRST THEN
                                   REPEAT
                                     TempServLine.INIT;
                                     TempServLine := ServLine;
                                     TempServLine.INSERT;
                                   UNTIL ServLine.NEXT = 0
                                 ELSE
                                   EXIT;

                                 ServHeader.GET("Document Type","Document No.");
                                 CLEAR(ServPostYesNo);
                                 ServPostYesNo.PostDocumentWithLines(ServHeader,TempServLine);

                                 ServLine.SETRANGE("Document Type",ServHeader."Document Type");
                                 ServLine.SETRANGE("Document No.",ServHeader."No.");
                                 IF NOT ServLine.FIND('-') THEN BEGIN
                                   RESET;
                                   CurrPage.CLOSE;
                                 END ELSE
                                   CurrPage.UPDATE;
                               END;
                                }
      { 29      ;2   ;Action    ;
                      Name=Preview;
                      CaptionML=[DAN=Vis bogf›ring;
                                 ENU=Preview Posting];
                      ToolTipML=[DAN=Gennemse de forskellige typer poster, der oprettes, n†r du bogf›rer bilaget eller kladden.;
                                 ENU=Review the different types of entries that will be created when you post the document or journal.];
                      ApplicationArea=#Service;
                      Image=ViewPostedOrder;
                      OnAction=VAR
                                 ServLine@1002 : Record 5902;
                                 TempServLine@1001 : TEMPORARY Record 5902;
                                 ServPostYesNo@1000 : Codeunit 5981;
                               BEGIN
                                 CLEAR(ServLine);
                                 CurrPage.SAVERECORD;
                                 CurrPage.SETSELECTIONFILTER(ServLine);

                                 IF ServLine.FINDFIRST THEN
                                   REPEAT
                                     TempServLine.INIT;
                                     TempServLine := ServLine;
                                     IF TempServLine.INSERT THEN;
                                   UNTIL NEXT = 0
                                 ELSE
                                   EXIT;

                                 ServHeader.GET("Document Type","Document No.");
                                 ServPostYesNo.PreviewDocumentWithLines(ServHeader,TempServLine);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 107 ;1   ;Field     ;
                CaptionML=[DAN=Servicelinjefilter;
                           ENU=Service Lines Filter];
                ToolTipML=[DAN=Angiver et servicelinjefilter.;
                           ENU=Specifies a service line filter.];
                OptionCaptionML=[DAN=Alle,Pr. valgt serviceartikellinje,Serviceartikellinjer - ikke relaterede;
                                 ENU=All,Per Selected Service Item Line,Service Item Line Non-Related];
                ApplicationArea=#Service;
                SourceExpr=SelectionFilter;
                OnValidate=BEGIN
                             SelectionFilterOnAfterValidate;
                           END;
                            }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det linjenummer for serviceartiklen, som er knyttet til servicelinjen.;
                           ENU=Specifies the service item line number linked to this service line.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Line No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det serviceartikelnummer, som er knyttet til servicelinjen.;
                           ENU=Specifies the service item number linked to this service line.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No." }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret for serviceartiklen, som er knyttet til servicelinjen.;
                           ENU=Specifies the service item serial number linked to this line.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Service Item Serial No.";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver beskrivelsen af serviceartikellinjen i serviceordren.;
                           ENU=Specifies the description of the service item line in the service order.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Line Description";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for servicelinjen.;
                           ENU=Specifies the type of the service line.];
                ApplicationArea=#Service;
                SourceExpr=Type;
                OnValidate=BEGIN
                             NoOnAfterValidate;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No.";
                OnValidate=BEGIN
                             NoOnAfterValidate;
                           END;
                            }

    { 138 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 131 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen er en katalogvare.;
                           ENU=Specifies that the item is a nonstock item.];
                ApplicationArea=#Service;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 140 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der findes en erstatning til varen.;
                           ENU=Specifies whether a substitute is available for the item.];
                ApplicationArea=#Service;
                SourceExpr="Substitution Available";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af en vare, ressource, omkostning eller standardtekst p† linjen.;
                           ENU=Specifies the description of an item, resource, cost, or a standard text on the line.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende beskrivelse af varen, ressourcen eller omkostningen.;
                           ENU=Specifies an additional description of the item, resource, or cost.];
                ApplicationArea=#Service;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lagerlokation, som varerne p† linjen skal tages fra, og hvor de skal registreres.;
                           ENU=Specifies the inventory location from where the items on the line should be taken and where they should be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                OnValidate=BEGIN
                             LocationCodeOnAfterValidate;
                           END;
                            }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 134 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der kan foretages en reservation for varer p† denne linje.;
                           ENU=Specifies whether a reservation can be made for items on this line.];
                ApplicationArea=#Service;
                SourceExpr=Reserve;
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder, ressourcetimer eller omkostninger p† servicelinjen.;
                           ENU=Specifies the number of item units, resource hours, cost on the service line.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=Quantity;
                OnValidate=BEGIN
                             QuantityOnAfterValidate;
                           END;
                            }

    { 143 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange vareenheder p† linjen der er reserveret.;
                           ENU=Specifies how many item units on this line have been reserved.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Reserved Quantity";
                Visible=FALSE }

    { 126 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Unit Price" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobel›b uden eventuelt fakturarabatbel›b, som skal betales for produkterne p† linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Line Amount" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p† linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Line Discount %" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel›b, der ydes p† varen, p† linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Line Discount Amount" }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for den linjerabat, der er tildelt linjen.;
                           ENU=Specifies the type of the line discount assigned to this line.];
                ApplicationArea=#Service;
                SourceExpr="Line Discount Type" }

    { 101 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, der mangler at blive afsendt.;
                           ENU=Specifies the quantity of items that remain to be shipped.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Qty. to Ship" }

    { 136 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der allerede er blevet bogf›rt som leveret.;
                           ENU=Specifies how many units of the item on the line have been posted as shipped.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Quantity Shipped" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af de varer, ressourcer, omkostninger eller finanskontobetalinger, der skal faktureres.;
                           ENU=Specifies the quantity of the items, resources, costs, or general ledger account payments, which should be invoiced.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Qty. to Invoice" }

    { 145 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der allerede er blevet bogf›rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Quantity Invoiced" }

    { 124 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal varer, ressourcetimer, omkostninger eller finanskontobetalinger, der skal forbruges.;
                           ENU=Specifies the quantity of items, resource hours, costs, or G/L account payments that should be consumed.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Qty. to Consume" }

    { 130 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal af varer, ressourcetimer, omkostninger eller finanskontobetalinger for linjen, som allerede er bogf›rt eller forbrugt.;
                           ENU=Specifies the quantity of items, resource hours, costs, or general ledger account payments on this line, which have been posted as consumed.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Quantity Consumed" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der mangler for at afslutte en sag.;
                           ENU=Specifies the quantity that remains to complete a job.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Job Remaining Qty.";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det resterende kostbel›b som summen af omkostninger for de sagsplanl‘gningslinjer, der er knyttet til ordren.;
                           ENU=Specifies the remaining total cost, as the sum of costs from job planning lines associated with the order.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Job Remaining Total Cost";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det resterende kostbel›b for den sagsplanl‘gningslinje, der er knyttet til serviceordren.;
                           ENU=Specifies the remaining total cost for the job planning line associated with the service order.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Job Remaining Total Cost (LCY)";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nettobel›bet for sagsplanl‘gningslinjen.;
                           ENU=Specifies the net amount of the job planning line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Job Remaining Line Amount";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den type arbejde, der udf›res af ressourcen, som er registreret p† linjen.;
                           ENU=Specifies a code for the type of work performed by the resource registered on this line.];
                ApplicationArea=#Service;
                SourceExpr="Work Type Code";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fejl†rsagskoden for servicelinjen.;
                           ENU=Specifies the code of the fault reason for this service line.];
                ApplicationArea=#Service;
                SourceExpr="Fault Reason Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det fejlomr†de, der er knyttet til linjen.;
                           ENU=Specifies the code of the fault area associated with this line.];
                ApplicationArea=#Service;
                SourceExpr="Fault Area Code";
                Visible=FaultAreaCodeVisible }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det symptom, der er knyttet til linjen.;
                           ENU=Specifies the code of the symptom associated with this line.];
                ApplicationArea=#Service;
                SourceExpr="Symptom Code";
                Visible=SymptomCodeVisible }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den fejl, der er knyttet til linjen.;
                           ENU=Specifies the code of the fault associated with this line.];
                ApplicationArea=#Service;
                SourceExpr="Fault Code";
                Visible=FaultCodeVisible }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den l›sning, der er knyttet til linjen.;
                           ENU=Specifies the code of the resolution associated with this line.];
                ApplicationArea=#Service;
                SourceExpr="Resolution Code";
                Visible=ResolutionCodeVisible }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for serviceprisreguleringsgruppen, som g‘lder for linjen.;
                           ENU=Specifies the service price adjustment group code that applies to this line.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Price Adjmt. Gr. Code";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, n†r fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Service;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede beregnede fakturarabatbel›b for linjen.;
                           ENU=Specifies the total calculated invoice discount amount for the line.];
                ApplicationArea=#Service;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at garantirabatten er udelukket p† denne linje.;
                           ENU=Specifies that the warranty discount is excluded on this line.];
                ApplicationArea=#Service;
                SourceExpr="Exclude Warranty" }

    { 117 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at kontraktrabatten er udelukket for varen, ressourcen eller omkostningen p† linjen.;
                           ENU=Specifies that the contract discount is excluded for the item, resource, or cost on this line.];
                ApplicationArea=#Service;
                SourceExpr="Exclude Contract Discount" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der gives en garantirabat p† linjen af typen Vare eller Ressource.;
                           ENU=Specifies that a warranty discount is available on this line of type Item or Resource.];
                ApplicationArea=#Service;
                SourceExpr=Warranty }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af garantirabatten, der g‘lder for varerne eller ressourcerne p† linjen.;
                           ENU=Specifies the percentage of the warranty discount that is valid for the items or resources on this line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Warranty Disc. %";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontrakten, hvis serviceordren stammer fra en servicekontrakt.;
                           ENU=Specifies the number of the contract, if the service order originated from a service contract.];
                ApplicationArea=#Service;
                SourceExpr="Contract No.";
                Editable=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontraktrabatprocent, der g‘lder for varerne, ressourcerne og omkostningerne p† linjen.;
                           ENU=Specifies the contract discount percentage that is valid for the items, resources, and costs on this line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Contract Disc. %";
                Visible=FALSE }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den momsprocent, der bruges til at beregne Bel›b inkl. moms p† linjen.;
                           ENU=Specifies the VAT percentage used to calculate Amount Including VAT on this line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="VAT %";
                Visible=FALSE }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, der fungerer som grundlag for beregning i feltet Bel›b inkl. moms.;
                           ENU=Specifies the amount that serves as a base for calculating the Amount Including VAT field.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="VAT Base Amount";
                Visible=FALSE }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nettobel›bet inklusive moms for denne linje.;
                           ENU=Specifies the net amount, including VAT, for this line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Amount Including VAT";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Service;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Service;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lagerbogf›ringsgruppe, der er tildelt varen.;
                           ENU=Specifies the inventory posting group assigned to the item.];
                ApplicationArea=#Service;
                SourceExpr="Posting Group";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den planlagte dato, hvor leverancen leveres p† debitorens adresse. Hvis debitoren anmoder om en leveringsdato, beregner programmet, om varerne er disponible for levering p† denne dato. Hvis varerne er disponible, er den planlagte leveringsdato den samme som den anmodede leveringsdato. Hvis ikke, beregner programmet den dato, hvor varerne er disponible for levering, og angiver denne dato i feltet Planlagt leveringsdato.;
                           ENU=Specifies the planned date that the shipment will be delivered at the customer's address. If the customer requests a delivery date, the program calculates whether the items will be available for delivery on this date. If the items are available, the planned delivery date will be the same as the requested delivery date. If not, the program calculates the date that the items are available for delivery and enters this date in the Planned Delivery Date field.];
                ApplicationArea=#Service;
                SourceExpr="Planned Delivery Date" }

    { 159 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du kr‘ver, at varen skal v‘re tilg‘ngelig for en serviceordre.;
                           ENU=Specifies the date when you require the item to be available for a service order.];
                ApplicationArea=#Service;
                SourceExpr="Needed by Date" }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicelinjen skal bogf›res.;
                           ENU=Specifies the date when the service line should be posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date";
                OnValidate=BEGIN
                             PostingDateOnAfterValidate;
                           END;
                            }

    { 174 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Service;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 176 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Service;
                SourceExpr="Job Task No.";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sagsplanl‘gningslinjenummer, som er knyttet til linjen. Dermed oprettes et link, der kan bruges til at beregne faktisk forbrug.;
                           ENU=Specifies the job planning line number associated with this line. This establishes a link that can be used to calculate actual usage.];
                ApplicationArea=#Service;
                SourceExpr="Job Planning Line No.";
                Visible=FALSE }

    { 178 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kladdelinjetype, der oprettes i tabellen Sagsplanl‘gningslinje ud fra linjen.;
                           ENU=Specifies the type of journal line that is created in the Job Planning Line table from this line.];
                ApplicationArea=#Service;
                SourceExpr="Job Line Type";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
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

    { 81  ;2   ;Field     ;
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

    { 83  ;2   ;Field     ;
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

    { 85  ;2   ;Field     ;
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

    { 87  ;2   ;Field     ;
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

    { 89  ;2   ;Field     ;
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

    { 91  ;2   ;Field     ;
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
                ApplicationArea=#Service;
                SourceExpr="Account Code";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1904739907;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(Document No.),
                            Line No.=FIELD(Line No.);
                PagePartID=Page9124;
                Visible=FALSE;
                PartType=Page }

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
      Text008@1008 : TextConst 'DAN=Du kan ikke †bne vinduet, fordi %1 er %2 i tabellen %3.;ENU=You cannot open the window because %1 is %2 in the %3 table.';
      ServMgtSetup@1023 : Record 5911;
      ServHeader@1009 : Record 5900;
      ServItemLine@1011 : Record 5901;
      SalesPriceCalcMgt@1001 : Codeunit 7000;
      ItemAvailFormsMgt@1002 : Codeunit 353;
      ShortcutDimCode@1020 : ARRAY [8] OF Code[20];
      ServItemLineNo@1021 : Integer;
      SelectionFilter@1022 : 'All Service Lines,Lines per Selected Service Item,Lines Not Item Related';
      Text011@1012 : TextConst 'DAN=Dette vil nulstille alle prisjusterede linjer. Vil du forts‘tte?;ENU=This will reset all price adjusted lines to default values. Do you want to continue?';
      FaultAreaCodeVisible@19067961 : Boolean INDATASET;
      SymptomCodeVisible@19078417 : Boolean INDATASET;
      FaultCodeVisible@19037502 : Boolean INDATASET;
      ResolutionCodeVisible@19021279 : Boolean INDATASET;
      Text012@1000 : TextConst 'DAN=Vil du oprette servicelinjer ud fra timesedler?;ENU=Do you want to create service lines from time sheets?';
      AddExtendedText@1003 : Boolean;

    [External]
    PROCEDURE CalcInvDisc@3(VAR ServLine@1000 : Record 5902);
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Service-Calc. Discount",ServLine);
    END;

    [External]
    PROCEDURE Initialize@5(ServItemLine@1000 : Integer);
    BEGIN
      ServItemLineNo := ServItemLine;
    END;

    [External]
    PROCEDURE SetSelectionFilter@2();
    BEGIN
      CASE SelectionFilter OF
        SelectionFilter::"All Service Lines":
          SETRANGE("Service Item Line No.");
        SelectionFilter::"Lines per Selected Service Item":
          SETRANGE("Service Item Line No.",ServItemLineNo);
        SelectionFilter::"Lines Not Item Related":
          SETRANGE("Service Item Line No.",0);
      END;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE InsertExtendedText@7(Unconditionally@1000 : Boolean);
    VAR
      TransferExtendedText@1001 : Codeunit 378;
    BEGIN
      IF TransferExtendedText.ServCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
        AddExtendedText := TRUE;
        CurrPage.SAVERECORD;
        AddExtendedText := FALSE;
        TransferExtendedText.InsertServExtText(Rec);
      END;
      IF TransferExtendedText.MakeUpdate THEN
        CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE InsertStartFee@8();
    VAR
      ServOrderMgt@1000 : Codeunit 5900;
    BEGIN
      CLEAR(ServOrderMgt);
      IF ServOrderMgt.InsertServCost(Rec,1,FALSE) THEN
        CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE InsertTravelFee@6();
    VAR
      ServOrderMgt@1000 : Codeunit 5900;
    BEGIN
      CLEAR(ServOrderMgt);
      IF ServOrderMgt.InsertServCost(Rec,0,FALSE) THEN
        CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE SelectFaultResolutionCode@15();
    VAR
      ServSetup@1000 : Record 5911;
      FaultResolutionRelation@1001 : Page 5930;
    BEGIN
      ServSetup.GET;
      CASE ServSetup."Fault Reporting Level" OF
        ServSetup."Fault Reporting Level"::None:
          ERROR(
            Text008,
            ServSetup.FIELDCAPTION("Fault Reporting Level"),
            ServSetup."Fault Reporting Level",ServSetup.TABLECAPTION);
      END;
      ServItemLine.GET("Document Type","Document No.","Service Item Line No.");
      CLEAR(FaultResolutionRelation);
      FaultResolutionRelation.SetDocument(DATABASE::"Service Line","Document Type","Document No.","Line No.");
      FaultResolutionRelation.SetFilters("Symptom Code","Fault Code","Fault Area Code",ServItemLine."Service Item Group Code");
      FaultResolutionRelation.RUNMODAL;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ShowPrices@4();
    BEGIN
      ServHeader.GET("Document Type","Document No.");
      CLEAR(SalesPriceCalcMgt);
      SalesPriceCalcMgt.GetServLinePrice(ServHeader,Rec);
    END;

    LOCAL PROCEDURE ShowLineDisc@16();
    BEGIN
      ServHeader.GET("Document Type","Document No.");
      CLEAR(SalesPriceCalcMgt);
      SalesPriceCalcMgt.GetServLineLineDisc(ServHeader,Rec);
    END;

    LOCAL PROCEDURE NoOnAfterValidate@19066594();
    BEGIN
      InsertExtendedText(FALSE);

      IF (Reserve = Reserve::Always) AND
         ("Outstanding Qty. (Base)" <> 0) AND
         ("No." <> xRec."No.")
      THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE LocationCodeOnAfterValidate@19034787();
    BEGIN
      IF (Reserve = Reserve::Always) AND
         ("Outstanding Qty. (Base)" <> 0) AND
         ("Location Code" <> xRec."Location Code")
      THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
      END;
      CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE QuantityOnAfterValidate@19032465();
    VAR
      UpdateIsDone@1000 : Boolean;
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
         ((Quantity <> xRec.Quantity) OR ("Line No." = 0)) AND
         NOT UpdateIsDone
      THEN
        CurrPage.UPDATE(TRUE);
    END;

    LOCAL PROCEDURE PostingDateOnAfterValidate@19003005();
    BEGIN
      IF (Reserve = Reserve::Always) AND
         ("Outstanding Qty. (Base)" <> 0) AND
         ("Posting Date" <> xRec."Posting Date")
      THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE SelectionFilterOnAfterValidate@19033692();
    BEGIN
      CurrPage.UPDATE;
      SetSelectionFilter;
    END;

    BEGIN
    END.
  }
}

