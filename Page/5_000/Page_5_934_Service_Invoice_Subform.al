OBJECT Page 5934 Service Invoice Subform
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
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table5902;
    DelayedInsert=Yes;
    SourceTableView=WHERE(Document Type=FILTER(Invoice));
    PageType=ListPart;
    AutoSplitKey=Yes;
    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  Type := xRec.Type;
                  CLEAR(ShortcutDimCode);
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
      { 1903079504;2 ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent pris;
                                 ENU=Get &Price];
                      ToolTipML=[DAN=Inds�t den laveste mulige pris i feltet Enhedspris i henhold til enhver specialpris, du har angivet.;
                                 ENU=Insert the lowest possible price in the Unit Price field according to any special price that you have set up.];
                      ApplicationArea=#Advanced;
                      Image=Price;
                      OnAction=BEGIN
                                 ShowPrices
                               END;
                                }
      { 1907415004;2 ;Action    ;
                      AccessByPermission=TableData 7004=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=H&ent linjerabat;
                                 ENU=Get Li&ne Discount];
                      ToolTipML=[DAN=Inds�t den bedste mulige rabat i feltet Linjerabat i henhold til enhver specialrabat, du har angivet.;
                                 ENU=Insert the best possible discount in the Line Discount field according to any special discounts that you have set up.];
                      ApplicationArea=#Advanced;
                      Image=LineDiscount;
                      OnAction=BEGIN
                                 ShowLineDisc
                               END;
                                }
      { 1900206204;2 ;Action    ;
                      AccessByPermission=TableData 279=R;
                      CaptionML=[DAN=&Inds�t udv. tekster;
                                 ENU=Insert &Ext. Texts];
                      ToolTipML=[DAN=Inds�t den forl�ngede varebeskrivelse, som h�rer til varen, der behandles p� linjen.;
                                 ENU=Insert the extended item description that is set up for the item that is being processed on the line.];
                      ApplicationArea=#Advanced;
                      Image=Text;
                      OnAction=BEGIN
                                 InsertExtendedText(TRUE);
                               END;
                                }
      { 1900545004;2 ;Action    ;
                      Name=GetShipmentLines;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Hent salgsleverancelinjer;
                                 ENU=Get &Shipment Lines];
                      ToolTipML=[DAN=V�lg flere leveringer til den samme debitor, fordi du vil kombinere dem p� �n faktura.;
                                 ENU=Select multiple shipments to the same customer because you want to combine them on one invoice.];
                      ApplicationArea=#Advanced;
                      Image=Shipment;
                      OnAction=BEGIN
                                 GetShipment;
                               END;
                                }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1905427604;2 ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg�ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp�rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Advanced;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 1900639404;3 ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m�ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Advanced;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByPeriod);
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
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 1904945204;3 ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Advanced;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 5       ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F� vist tilg�ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p� tilg�ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Advanced;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 1904522204;2 ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1905987604;2 ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p� bilags- eller kladdelinjen.;
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
                ToolTipML=[DAN=Angiver typen for servicelinjen.;
                           ENU=Specifies the type of the service line.];
                ApplicationArea=#Service;
                SourceExpr=Type;
                OnValidate=BEGIN
                             NoOnAfterValidate;
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No.";
                OnValidate=BEGIN
                             ShowShortcutDimCode(ShortcutDimCode);
                             NoOnAfterValidate;
                           END;
                            }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen er en katalogvare.;
                           ENU=Specifies that the item is a nonstock item.];
                ApplicationArea=#Service;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf�ringsops�tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Service;
                SourceExpr="VAT Prod. Posting Group";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af en vare, ressource, omkostning eller standardtekst p� linjen.;
                           ENU=Specifies the description of an item, resource, cost, or a standard text on the line.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Service;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lagerlokation, som varerne p� linjen skal tages fra, og hvor de skal registreres.;
                           ENU=Specifies the inventory location from where the items on the line should be taken and where they should be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l�gges p� lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder, ressourcetimer eller omkostninger p� servicelinjen.;
                           ENU=Specifies the number of item units, resource hours, cost on the service line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr=Quantity;
                OnValidate=BEGIN
                             QuantityOnAfterValidate;
                           END;
                            }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code";
                OnValidate=BEGIN
                             UnitofMeasureCodeOnAfterValida;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Service;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for �n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f� den angivet i henhold til feltet Avancepct.beregning p� det dertilh�rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Unit Price" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p� linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Line Discount %" }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobel�b uden eventuelt fakturarabatbel�b, som skal betales for produkterne p� linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Line Amount" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel�b, der ydes p� varen, p� linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Service;
                SourceExpr="Line Discount Amount";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, n�r fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Service;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 80  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede beregnede fakturarabatbel�b for linjen.;
                           ENU=Specifies the total calculated invoice discount amount for the line.];
                ApplicationArea=#Service;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for serviceprisreguleringsgruppen, som g�lder for linjen.;
                           ENU=Specifies the service price adjustment group code that applies to this line.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Price Adjmt. Gr. Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� kontrakten, hvis serviceordren stammer fra en servicekontrakt.;
                           ENU=Specifies the number of the contract, if the service order originated from a service contract.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det serviceartikelnummer, som er knyttet til servicelinjen.;
                           ENU=Specifies the service item number linked to this service line.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No.";
                Visible=FALSE }

    { 78  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det servicepostnummer, som linjen udlignes med.;
                           ENU=Specifies the service ledger entry number this line is applied to.];
                ApplicationArea=#Service;
                SourceExpr="Appl.-to Service Entry";
                Visible=TRUE }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den type arbejde, der udf�res af ressourcen, som er registreret p� linjen.;
                           ENU=Specifies a code for the type of work performed by the resource registered on this line.];
                ApplicationArea=#Service;
                SourceExpr="Work Type Code";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den varepost, som dette dokument eller denne kladdelinje udlignes p�.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#Service;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
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
      ServHeader@1000 : Record 5900;
      TransferExtendedText@1003 : Codeunit 378;
      SalesPriceCalcMgt@1005 : Codeunit 7000;
      ItemAvailFormsMgt@1001 : Codeunit 353;
      ShortcutDimCode@1004 : ARRAY [8] OF Code[20];
      Text000@1002 : TextConst 'DAN=Denne servicefaktura er oprettet ud fra servicekontrakten. Hvis du vil hente leverancelinjer, skal du oprette en ny servicefaktura.;ENU=This service invoice was created from the service contract. If you want to get shipment lines, you must create another service invoice.';

    [External]
    PROCEDURE ApproveCalcInvDisc@1();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"Service-Disc. (Yes/No)",Rec);
    END;

    [External]
    PROCEDURE GetShipment@4();
    BEGIN
      ServHeader.GET("Document Type","Document No.");
      IF ServHeader."Contract No." <> '' THEN
        ERROR(Text000);
      CODEUNIT.RUN(CODEUNIT::"Service-Get Shipment",Rec);
    END;

    LOCAL PROCEDURE InsertExtendedText@7(Unconditionally@1000 : Boolean);
    BEGIN
      IF TransferExtendedText.ServCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
        CurrPage.SAVERECORD;
        TransferExtendedText.InsertServExtText(Rec);
      END;
      IF TransferExtendedText.MakeUpdate THEN
        UpdateForm(TRUE);
    END;

    [External]
    PROCEDURE UpdateForm@12(SetSaveRecord@1000 : Boolean);
    BEGIN
      CurrPage.UPDATE(SetSaveRecord);
    END;

    LOCAL PROCEDURE ShowPrices@15();
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

    LOCAL PROCEDURE UnitofMeasureCodeOnAfterValida@19057939();
    BEGIN
      IF Reserve = Reserve::Always THEN BEGIN
        CurrPage.SAVERECORD;
        AutoReserve;
      END;
    END;

    BEGIN
    END.
  }
}

