OBJECT Page 5970 Posted Service Shipment Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogf›rte serviceleverancelinjer;
               ENU=Posted Service Shipment Lines];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table5991;
    DelayedInsert=Yes;
    DataCaptionFields=Document No.;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=BEGIN
                 CLEAR(SelectionFilter);
                 SetSelectionFilter;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 21      ;2   ;Action    ;
                      Name=Dimenions;
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
      { 60      ;2   ;Action    ;
                      Name=ItemTrackingEntries;
                      CaptionML=[DAN=Vare&sporingsposter;
                                 ENU=Item &Tracking Entries];
                      ToolTipML=[DAN=Vis serie- eller lotnumre, der er tildelt til varer.;
                                 ENU=View serial or lot numbers that are assigned to items.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLedger;
                      OnAction=BEGIN
                                 ShowItemTrackingLines;
                               END;
                                }
      { 27      ;2   ;Separator  }
      { 38      ;2   ;Action    ;
                      Name=ItemInvoiceLines;
                      CaptionML=[DAN=Varefaktura&linjer;
                                 ENU=Item Invoice &Lines];
                      ToolTipML=[DAN="Vis bogf›rte salgsfakturalinjer for varen. ";
                                 ENU="View posted sales invoice lines for the item. "];
                      ApplicationArea=#Advanced;
                      Image=ItemInvoice;
                      OnAction=BEGIN
                                 TESTFIELD(Type,Type::Item);
                                 ShowItemServInvLines;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 57      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 82      ;2   ;Action    ;
                      CaptionML=[DAN=&Ordresporing;
                                 ENU=&Order Tracking];
                      ToolTipML=[DAN=Spor forbindelsen mellem udbud og den dertil h›rende eftersp›rgsel. P† denne m†de kan du finde den oprindelige eftersp›rgsel, der medf›rte en specifik produktionsordre eller k›bsordre.;
                                 ENU=Track the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#ItemTracking;
                      Image=OrderTracking;
                      OnAction=BEGIN
                                 ShowTracking;
                               END;
                                }
      { 86      ;2   ;Separator  }
      { 77      ;2   ;Action    ;
                      Name=UndoShipment;
                      CaptionML=[DAN=&Annuller leverance;
                                 ENU=&Undo Shipment];
                      ToolTipML=[DAN=Tr‘k linjen fra leverancen. Det er nyttigt, hvis du vil foretage rettelser, fordi linjen ikke bliver slettet. Du kan foretage ‘ndringer og bogf›re den igen.;
                                 ENU=Withdraw the line from the shipment. This is useful for making corrections, because the line is not deleted. You can make changes and post it again.];
                      ApplicationArea=#Advanced;
                      Image=UndoShipment;
                      OnAction=BEGIN
                                 UndoServShptPosting;
                               END;
                                }
      { 79      ;2   ;Action    ;
                      Name=UndoConsumption;
                      CaptionML=[DAN=Fo&rtryd forbrug;
                                 ENU=U&ndo Consumption];
                      ToolTipML=[DAN=Annuller forbruget af serviceordren, eksempelvis fordi den er bogf›rt ved en fejltagelse.;
                                 ENU=Cancel the consumption on the service order, for example because it was posted by mistake.];
                      ApplicationArea=#Manufacturing;
                      Image=Undo;
                      OnAction=BEGIN
                                 UndoServConsumption;
                               END;
                                }
      { 39      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 44  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 94  ;2   ;Field     ;
                CaptionML=[DAN=Valgfilter;
                           ENU=Selection Filter];
                ToolTipML=[DAN=Angiver et valgfilter.;
                           ENU=Specifies a selection filter.];
                OptionCaptionML=[DAN=Alle serviceleverancelinjer,Linjer pr. markeret serviceartikel,Linjer - ikke artikelrelaterede;
                                 ENU=All Service Shipment Lines,Lines per Selected Service Item,Lines Not Item Related];
                ApplicationArea=#Service;
                SourceExpr=SelectionFilter;
                OnValidate=BEGIN
                             SelectionFilterOnAfterValidate;
                           END;
                            }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceartikellinje, som servicelinjen er tilknyttet.;
                           ENU=Specifies the number of the service item line to which this service line is linked.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Line No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceartikel, som servicelinjen er tilknyttet.;
                           ENU=Specifies the number of the service item to which this service line is linked.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No.";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p† den serviceartikel, som leverancelinjen er tilknyttet.;
                           ENU=Specifies the serial number of the service item to which this shipment line is linked.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Service Item Serial No.";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for leverancelinjen.;
                           ENU=Specifies the type of this shipment line.];
                ApplicationArea=#Service;
                SourceExpr=Type }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af en vare, ressource, omkostning eller standardtekst p† servicelinjen.;
                           ENU=Specifies the description of an item, resource, cost, or a standard text on the service line.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den type arbejde, der er udf›rt if›lge den bogf›rte serviceordre.;
                           ENU=Specifies a code for the type of work performed under the posted service order.];
                ApplicationArea=#Service;
                SourceExpr="Work Type Code";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder, ressourcetimer, finanskontobetalinger eller omkostninger, der er leveret til debitoren.;
                           ENU=Specifies the number of item units, resource hours, general ledger account payments, or cost that have been shipped to the customer.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr=Quantity }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den p†g‘ldende vare der allerede er blevet bogf›rt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Quantity Invoiced" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder, ressourcetimer, finanskontobetalinger eller omkostninger, der er bogf›rt som forbrugt.;
                           ENU=Specifies the number of units of items, resource hours, general ledger account payments, or costs that have been posted as consumed.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Quantity Consumed" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den leverede vare, der er bogf›rt som leveret, men som endnu ikke er bogf›rt som faktureret.;
                           ENU=Specifies the quantity of the shipped item that has been posted as shipped but that has not yet been posted as invoiced.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Qty. Shipped Not Invoiced" }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det fejlomr†de, der er knyttet til servicelinjen.;
                           ENU=Specifies the code of the fault area associated with this service line.];
                ApplicationArea=#Service;
                SourceExpr="Fault Area Code" }

    { 90  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det symptom, der er knyttet til serviceleverancelinjen.;
                           ENU=Specifies the code of the symptom associated with this service shipment line.];
                ApplicationArea=#Service;
                SourceExpr="Symptom Code" }

    { 92  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den fejlkode, der er knyttet til serviceleverancelinjen.;
                           ENU=Specifies the fault code associated with this service shipment line.];
                ApplicationArea=#Service;
                SourceExpr="Fault Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fejl†rsagskoden for serviceleverancelinjen.;
                           ENU=Specifies the code of the fault reason for the service shipment line.];
                ApplicationArea=#Service;
                SourceExpr="Fault Reason Code";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den l›sning, der er knyttet til serviceleverancelinjen.;
                           ENU=Specifies the code of the resolution associated with this service shipment line.];
                ApplicationArea=#Service;
                SourceExpr="Resolution Code" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, eksempelvis lagersted eller distributionscenter, som varerne p† linjen skal tages fra, og hvor de skal registreres.;
                           ENU=Specifies the location, such as warehouse or distribution center, from which the items should be taken and where they should be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varen er anvendt til at erstatte hele serviceartiklen, en af serviceartikelkomponenterne, installeret som en ny komponent eller blot anvendt som et supplerende v‘rkt›j i serviceprocessen.;
                           ENU=Specifies whether the item has been used to replace the whole service item, one of the service item components, installed as a new component, or as a supplementary tool in the service process.];
                ApplicationArea=#Service;
                SourceExpr="Spare Part Action" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for den serviceartikelkomponent, der er erstattet med varen p† servicelinjen.;
                           ENU=Specifies the type of the service item component replaced by the item on the service line.];
                ApplicationArea=#Service;
                SourceExpr="Replaced Item Type" }

    { 84  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceartikelkomponent, der er erstattet med varen p† servicelinjen.;
                           ENU=Specifies the number of the service item component replaced by the item on the service line.];
                ApplicationArea=#Service;
                SourceExpr="Replaced Item No." }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontrakt, som er knyttet til den bogf›rte serviceordre.;
                           ENU=Specifies the number of the contract associated with the posted service order.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den bogf›ringsgruppe, der blev anvendt, da servicelinjen blev bogf›rt.;
                           ENU=Specifies the code for the posting group used when the service line was posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Group";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicelinjen blev bogf›rt.;
                           ENU=Specifies the date when the service line was posted.];
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
      SelectionFilter@1000 : 'All Shipment Lines,Lines per Selected Service Item,Lines Not Item Related';
      ServItemLineNo@1001 : Integer;

    [External]
    PROCEDURE Initialize@1(ServItemLineNo2@1000 : Integer);
    BEGIN
      ServItemLineNo := ServItemLineNo2;
    END;

    [External]
    PROCEDURE SetSelectionFilter@2();
    BEGIN
      CASE SelectionFilter OF
        SelectionFilter::"All Shipment Lines":
          SETRANGE("Service Item Line No.");
        SelectionFilter::"Lines per Selected Service Item":
          SETRANGE("Service Item Line No.",ServItemLineNo);
        SelectionFilter::"Lines Not Item Related":
          SETFILTER("Service Item Line No.",'=%1',0);
      END;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ShowTracking@3();
    VAR
      ItemLedgEntry@1000 : Record 32;
      TempItemLedgEntry@1002 : TEMPORARY Record 32;
      TrackingForm@1001 : Page 99000822;
    BEGIN
      TESTFIELD(Type,Type::Item);
      IF "Item Shpt. Entry No." <> 0 THEN BEGIN
        ItemLedgEntry.GET("Item Shpt. Entry No.");
        TrackingForm.SetItemLedgEntry(ItemLedgEntry);
      END ELSE
        TrackingForm.SetMultipleItemLedgEntries(TempItemLedgEntry,
          DATABASE::"Service Shipment Line",0,"Document No.",'',0,"Line No.");
      TrackingForm.RUNMODAL;
    END;

    LOCAL PROCEDURE UndoServShptPosting@6();
    VAR
      ServShptLine@1000 : Record 5991;
    BEGIN
      ServShptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(ServShptLine);
      CODEUNIT.RUN(CODEUNIT::"Undo Service Shipment Line",ServShptLine);
    END;

    LOCAL PROCEDURE UndoServConsumption@7();
    VAR
      ServShptLine@1000 : Record 5991;
    BEGIN
      ServShptLine.COPY(Rec);
      CurrPage.SETSELECTIONFILTER(ServShptLine);
      CODEUNIT.RUN(CODEUNIT::"Undo Service Consumption Line",ServShptLine);
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

