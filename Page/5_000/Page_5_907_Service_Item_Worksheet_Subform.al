OBJECT Page 5907 Service Item Worksheet Subform
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table5902;
    DelayedInsert=Yes;
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  Type := xRec.Type;
                  CLEAR(ShortcutDimCode);
                  VALIDATE("Service Item Line No.",ServItemLineNo);
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1903098804;2 ;Action    ;
                      Name=Insert Ext. Texts;
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
      { 1900545204;2 ;Action    ;
                      Name=Insert Starting Fee;
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
      { 1902085804;2 ;Action    ;
                      Name=Insert Travel Fee;
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
      { 1903984904;2 ;Action    ;
                      CaptionML=[DAN=Reserver;
                                 ENU=Reserve];
                      ToolTipML=[DAN=Reserv‚r varer til den valgte linje.;
                                 ENU=Reserve items for the selected line.];
                      ApplicationArea=#Advanced;
                      Image=Reserve;
                      OnAction=BEGIN
                                 FIND;
                                 ShowReservation;
                               END;
                                }
      { 1904320404;2 ;Action    ;
                      CaptionML=[DAN=Ordresporing;
                                 ENU=Order Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den tilsvarende eftersp›rgsel. P† denne m†de kan du finde den oprindelige foresp›rgsel, der oprettede en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Service;
                      Image=OrderTracking;
                      OnAction=BEGIN
                                 FIND;
                                 ShowTracking;
                               END;
                                }
      { 1901742204;2 ;Action    ;
                      AccessByPermission=TableData 5718=R;
                      CaptionML=[DAN=K&atalogvarer;
                                 ENU=&Nonstock Items];
                      ToolTipML=[DAN="Vis oversigten over varer, du ikke lagerf›rer. ";
                                 ENU="View the list of items that you do not carry in inventory. "];
                      ApplicationArea=#Service;
                      Image=NonStockItem;
                      OnAction=BEGIN
                                 ShowNonstock;
                               END;
                                }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1901652104;2 ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 9       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Planning;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 1903099904;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m†ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Planning;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 1900546304;3 ;Action    ;
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
      { 1900296704;3 ;Action    ;
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
      { 11      ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Planning;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 1907981204;2 ;Action    ;
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
      { 1900545004;2 ;Action    ;
                      AccessByPermission=TableData 5715=R;
                      CaptionML=[DAN=V‘lg erstatningsvare;
                                 ENU=Select Item Substitution];
                      ToolTipML=[DAN=V‘lg en anden vare, der er konfigureret til at blive handlet i stedet for den originale vare, hvis den ikke er tilg‘ngelig.;
                                 ENU=Select another item that has been set up to be traded instead of the original item if it is unavailable.];
                      ApplicationArea=#Service;
                      Image=SelectItemSubstitution;
                      OnAction=BEGIN
                                 SelectItemSubstitution;
                               END;
                                }
      { 1903098604;2 ;Action    ;
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
      { 1907838004;2 ;Action    ;
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
      { 5       ;2   ;Action    ;
                      AccessByPermission=TableData 99000880=R;
                      CaptionML=[DAN=Linje for &beregn. af lev.tid;
                                 ENU=Order &Promising Line];
                      ToolTipML=[DAN=Vis den beregnede leveringsdato.;
                                 ENU=View the calculated delivery date.];
                      ApplicationArea=#Planning;
                      OnAction=BEGIN
                                 ShowOrderPromisingLine;
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

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen er en katalogvare.;
                           ENU=Specifies that the item is a nonstock item.];
                ApplicationArea=#Service;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af en vare, ressource, omkostning eller standardtekst p† linjen.;
                           ENU=Specifies the description of an item, resource, cost, or a standard text on the line.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den type arbejde, der udf›res af ressourcen, som er registreret p† linjen.;
                           ENU=Specifies a code for the type of work performed by the resource registered on this line.];
                ApplicationArea=#Service;
                SourceExpr="Work Type Code";
                Visible=FALSE }

    { 86  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der kan foretages en reservation for varer p† denne linje.;
                           ENU=Specifies whether a reservation can be made for items on this line.];
                ApplicationArea=#Service;
                SourceExpr=Reserve;
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lagerlokation, som varerne p† linjen skal tages fra, og hvor de skal registreres.;
                           ENU=Specifies the inventory location from where the items on the line should be taken and where they should be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                OnValidate=BEGIN
                             LocationCodeOnAfterValidate;
                           END;
                            }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder, ressourcetimer eller omkostninger p† servicelinjen.;
                           ENU=Specifies the number of item units, resource hours, cost on the service line.];
                ApplicationArea=#Service;
                SourceExpr=Quantity;
                OnValidate=BEGIN
                             QuantityOnAfterValidate;
                           END;
                            }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange vareenheder p† linjen der er reserveret.;
                           ENU=Specifies how many item units on this line have been reserved.];
                ApplicationArea=#Service;
                SourceExpr="Reserved Quantity";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fejl†rsagskoden for servicelinjen.;
                           ENU=Specifies the code of the fault reason for this service line.];
                ApplicationArea=#Service;
                SourceExpr="Fault Reason Code" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det fejlomr†de, der er knyttet til linjen.;
                           ENU=Specifies the code of the fault area associated with this line.];
                ApplicationArea=#Service;
                SourceExpr="Fault Area Code" }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det symptom, der er knyttet til linjen.;
                           ENU=Specifies the code of the symptom associated with this line.];
                ApplicationArea=#Service;
                SourceExpr="Symptom Code" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den fejl, der er knyttet til linjen.;
                           ENU=Specifies the code of the fault associated with this line.];
                ApplicationArea=#Service;
                SourceExpr="Fault Code" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den l›sning, der er knyttet til linjen.;
                           ENU=Specifies the code of the resolution associated with this line.];
                ApplicationArea=#Service;
                SourceExpr="Resolution Code" }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for serviceprisreguleringsgruppen, som g‘lder for linjen.;
                           ENU=Specifies the service price adjustment group code that applies to this line.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Price Adjmt. Gr. Code";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Service;
                SourceExpr="Unit Price" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabat, der er defineret for en bestemt gruppe, vare eller kombination af de to.;
                           ENU=Specifies the discount defined for a particular group, item, or combination of the two.];
                ApplicationArea=#Service;
                SourceExpr="Line Discount %" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel›b, der ydes p† varen, p† linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Service;
                SourceExpr="Line Discount Amount" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for den linjerabat, der er tildelt linjen.;
                           ENU=Specifies the type of the line discount assigned to this line.];
                ApplicationArea=#Service;
                SourceExpr="Line Discount Type" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘rdien af produkter p† kladdelinjen.;
                           ENU=Specifies the value of products on the worksheet line.];
                ApplicationArea=#Service;
                SourceExpr="Line Amount" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at garantirabatten er udelukket p† denne linje.;
                           ENU=Specifies that the warranty discount is excluded on this line.];
                ApplicationArea=#Service;
                SourceExpr="Exclude Warranty" }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at kontraktrabatten er udelukket for varen, ressourcen eller omkostningen p† linjen.;
                           ENU=Specifies that the contract discount is excluded for the item, resource, or cost on this line.];
                ApplicationArea=#Service;
                SourceExpr="Exclude Contract Discount" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der gives en garantirabat p† linjen af typen Vare eller Ressource.;
                           ENU=Specifies that a warranty discount is available on this line of type Item or Resource.];
                ApplicationArea=#Service;
                SourceExpr=Warranty }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af garantirabatten, der g‘lder for varerne eller ressourcerne p† linjen.;
                           ENU=Specifies the percentage of the warranty discount that is valid for the items or resources on this line.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Disc. %";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kontrakten, hvis serviceordren stammer fra en servicekontrakt.;
                           ENU=Specifies the number of the contract, if the service order originated from a service contract.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontraktrabatprocent, der g‘lder for varerne, ressourcerne og omkostningerne p† linjen.;
                           ENU=Specifies the contract discount percentage that is valid for the items, resources, and costs on this line.];
                ApplicationArea=#Service;
                SourceExpr="Contract Disc. %";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den momsprocent, der bruges til at beregne Bel›b inkl. moms p† linjen.;
                           ENU=Specifies the VAT percentage used to calculate Amount Including VAT on this line.];
                ApplicationArea=#Service;
                SourceExpr="VAT %";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, der fungerer som grundlag for beregning i feltet Bel›b inkl. moms.;
                           ENU=Specifies the amount that serves as a base for calculating the Amount Including VAT field.];
                ApplicationArea=#Service;
                SourceExpr="VAT Base Amount";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nettobel›bet inklusive moms for denne linje.;
                           ENU=Specifies the net amount, including VAT, for this line.];
                ApplicationArea=#Service;
                SourceExpr="Amount Including VAT";
                Visible=FALSE }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Service;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Service;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 82  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Service;
                SourceExpr="VAT Bus. Posting Group";
                Visible=FALSE }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Service;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicelinjen skal bogf›res.;
                           ENU=Specifies the date when the service line should be posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date";
                Visible=FALSE;
                OnValidate=BEGIN
                             PostingDateOnAfterValidate;
                           END;
                            }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den planlagte dato, hvor leverancen leveres p† debitorens adresse. Hvis debitoren anmoder om en leveringsdato, beregner programmet, om varerne er disponible for levering p† denne dato. Hvis varerne er disponible, er den planlagte leveringsdato den samme som den anmodede leveringsdato. Hvis ikke, beregner programmet den dato, hvor varerne er disponible for levering, og angiver denne dato i feltet Planlagt leveringsdato.;
                           ENU=Specifies the planned date that the shipment will be delivered at the customer's address. If the customer requests a delivery date, the program calculates whether the items will be available for delivery on this date. If the items are available, the planned delivery date will be the same as the requested delivery date. If not, the program calculates the date that the items are available for delivery and enters this date in the Planned Delivery Date field.];
                ApplicationArea=#Service;
                SourceExpr="Planned Delivery Date" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du kr‘ver, at varen skal v‘re tilg‘ngelig for en serviceordre.;
                           ENU=Specifies the date when you require the item to be available for a service order.];
                ApplicationArea=#Service;
                SourceExpr="Needed by Date" }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 104 ;2   ;Field     ;
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

    { 106 ;2   ;Field     ;
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

    { 108 ;2   ;Field     ;
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

    { 110 ;2   ;Field     ;
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

    { 112 ;2   ;Field     ;
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

    { 28  ;2   ;Field     ;
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

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke †bne vinduet, fordi %1 er %2 i tabellen %3.;ENU=You cannot open the window because %1 is %2 in the %3 table.';
      ServMgtSetup@1001 : Record 5911;
      ItemAvailFormsMgt@1002 : Codeunit 353;
      ServItemLineNo@1005 : Integer;
      ShortcutDimCode@1007 : ARRAY [8] OF Code[20];

    [External]
    PROCEDURE SetValues@1(TempServItemLineNo@1000 : Integer);
    BEGIN
      ServItemLineNo := TempServItemLineNo;
      SETFILTER("Service Item Line No.",'=%1|=%2',0,ServItemLineNo);
    END;

    LOCAL PROCEDURE InsertStartFee@8();
    VAR
      ServOrderMgt@1000 : Codeunit 5900;
    BEGIN
      CLEAR(ServOrderMgt);
      IF ServOrderMgt.InsertServCost(Rec,1,TRUE) THEN
        CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE InsertTravelFee@6();
    VAR
      ServOrderMgt@1000 : Codeunit 5900;
    BEGIN
      CLEAR(ServOrderMgt);
      IF ServOrderMgt.InsertServCost(Rec,0,TRUE) THEN
        CurrPage.UPDATE;
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

    LOCAL PROCEDURE ShowReservationEntries@10();
    BEGIN
      ShowReservationEntries(TRUE);
    END;

    LOCAL PROCEDURE SelectFaultResolutionCode@15();
    VAR
      ServItemLine@1000 : Record 5901;
      FaultResolutionRelation@1001 : Page 5930;
    BEGIN
      ServMgtSetup.GET;
      CASE ServMgtSetup."Fault Reporting Level" OF
        ServMgtSetup."Fault Reporting Level"::None:
          ERROR(
            Text000,
            ServMgtSetup.FIELDCAPTION("Fault Reporting Level"),ServMgtSetup."Fault Reporting Level",ServMgtSetup.TABLECAPTION);
      END;
      ServItemLine.GET("Document Type","Document No.","Service Item Line No.");
      CLEAR(FaultResolutionRelation);
      FaultResolutionRelation.SetDocument(DATABASE::"Service Line","Document Type","Document No.","Line No.");
      FaultResolutionRelation.SetFilters("Symptom Code","Fault Code","Fault Area Code",ServItemLine."Service Item Group Code");
      FaultResolutionRelation.RUNMODAL;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE SelectItemSubstitution@13();
    BEGIN
      ShowItemSub;
      MODIFY;
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
        CurrPage.UPDATE(FALSE);
      END;
    END;

    LOCAL PROCEDURE QuantityOnAfterValidate@19032465();
    BEGIN
      IF Type = Type::Item THEN
        CASE Reserve OF
          Reserve::Always:
            BEGIN
              CurrPage.SAVERECORD;
              AutoReserve;
              CurrPage.UPDATE(FALSE);
            END;
          Reserve::Optional:
            IF (Quantity < xRec.Quantity) AND (xRec.Quantity > 0) THEN BEGIN
              CurrPage.SAVERECORD;
              CurrPage.UPDATE(FALSE);
            END;
        END;
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

    BEGIN
    END.
  }
}

