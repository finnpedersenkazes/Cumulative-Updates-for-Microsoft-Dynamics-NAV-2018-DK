OBJECT Page 5966 Service Quote Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Servicetilbudslinjer;
               ENU=Service Quote Lines];
    SourceTable=Table5902;
    DelayedInsert=Yes;
    PopulateAllFields=Yes;
    DataCaptionFields=Document Type,Document No.;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=BEGIN
                 CLEAR(SelectionFilter);
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
                  ServHeader.GET("Document Type","Document No.");
                  IF ServHeader."Link Service to Service Item" THEN
                    IF SelectionFilter <> SelectionFilter::"Lines Not Item Related" THEN
                      VALIDATE("Service Item Line No.",ServItemLineNo)
                    ELSE
                      VALIDATE("Service Item Line No.",0)
                  ELSE
                    VALIDATE("Service Item Line No.",0);
                END;

    OnInsertRecord=BEGIN
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
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 115     ;2   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 2       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Advanced;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 125     ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m†ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Advanced;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 126     ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 127     ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Advanced;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 27      ;2   ;Action    ;
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
      { 132     ;2   ;Action    ;
                      CaptionML=[DAN=V‘lg &erstatningsvare;
                                 ENU=Select Item &Substitution];
                      ToolTipML=[DAN=V‘lg en anden vare, der er blevet konfigureret til at blive solgt i stedet for den originale vare, hvis den ikke er tilg‘ngelig.;
                                 ENU=Select another item that has been set up to be sold instead of the original item if it is unavailable.];
                      ApplicationArea=#Advanced;
                      Image=SelectItemSubstitution;
                      OnAction=BEGIN
                                 ShowItemSub;
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 94      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 111     ;2   ;Action    ;
                      Name=CalculateInvoiceDiscount;
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
      { 123     ;2   ;Action    ;
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
      { 124     ;2   ;Action    ;
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
                      CaptionML=[DAN=Opdel &ressourcelinje;
                                 ENU=Split &Resource Line];
                      ToolTipML=[DAN=Opdel planl‘gningslinjer af typen Budget og Fakturerbar til to separate planl‘gningslinjer: Budget og Fakturerbar.;
                                 ENU=Split planning lines of type Budget and Billable into two separate planning lines: Budget and Billable.];
                      ApplicationArea=#Service;
                      Image=Split;
                      OnAction=BEGIN
                                 SplitResourceLine;
                               END;
                                }
      { 17      ;2   ;Action    ;
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
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 107 ;1   ;Field     ;
                CaptionML=[DAN=Filter til servicetilbudslinjer;
                           ENU=Service Quote Lines Filter];
                ToolTipML=[DAN=Angiver et valgfilter.;
                           ENU=Specifies a selection filter.];
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

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af en vare, ressource, omkostning eller standardtekst p† linjen.;
                           ENU=Specifies the description of an item, resource, cost, or a standard text on the line.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 112 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen er en katalogvare.;
                           ENU=Specifies that the item is a nonstock item.];
                ApplicationArea=#Service;
                SourceExpr=Nonstock }

    { 128 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende beskrivelse af varen, ressourcen eller omkostningen.;
                           ENU=Specifies an additional description of the item, resource, or cost.];
                ApplicationArea=#Service;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der findes en erstatning til varen.;
                           ENU=Specifies whether a substitute is available for the item.];
                ApplicationArea=#Service;
                SourceExpr="Substitution Available";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den type arbejde, der udf›res af ressourcen, som er registreret p† linjen.;
                           ENU=Specifies a code for the type of work performed by the resource registered on this line.];
                ApplicationArea=#Service;
                SourceExpr="Work Type Code";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lagerlokation, som varerne p† linjen skal tages fra, og hvor de skal registreres.;
                           ENU=Specifies the inventory location from where the items on the line should be taken and where they should be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

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

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Unit Price" }

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

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, n†r fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Service;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 137 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede beregnede fakturarabatbel›b for linjen.;
                           ENU=Specifies the total calculated invoice discount amount for the line.];
                ApplicationArea=#Service;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobel›b uden eventuelt fakturarabatbel›b, som skal betales for produkterne p† linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Line Amount" }

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
                SourceExpr="Amount Including VAT";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Unit Cost (LCY)";
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

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicelinjen skal bogf›res.;
                           ENU=Specifies the date when the service line should be posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date" }

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
      ServMgtSetup@1002 : Record 5911;
      ServHeader@1003 : Record 5900;
      SalesPriceCalcMgt@1006 : Codeunit 7000;
      ItemAvailFormsMgt@1000 : Codeunit 353;
      ShortcutDimCode@1012 : ARRAY [8] OF Code[20];
      ServItemLineNo@1013 : Integer;
      SelectionFilter@1014 : 'All Service Lines,Lines per Selected Service Item,Lines Not Item Related';
      FaultAreaCodeVisible@19067961 : Boolean INDATASET;
      SymptomCodeVisible@19078417 : Boolean INDATASET;
      FaultCodeVisible@19037502 : Boolean INDATASET;
      ResolutionCodeVisible@19021279 : Boolean INDATASET;

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
        CurrPage.SAVERECORD;
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
    END;

    LOCAL PROCEDURE QuantityOnAfterValidate@19032465();
    BEGIN
      IF Reserve = Reserve::Always THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
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

