OBJECT Page 5981 Service Item List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Serviceartikeloversigt;
               ENU=Service Item List];
    SourceTable=Table5940;
    PageType=List;
    CardPageID=Service Item Card;
    RefreshOnActivate=Yes;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Serviceartikel;
                                 ENU=&Service Item];
                      Image=ServiceItem }
      { 31      ;2   ;Action    ;
                      CaptionML=[DAN=K&omponentoversigt;
                                 ENU=Com&ponent List];
                      ToolTipML=[DAN=Vis oversigten over komponenter i serviceartiklen.;
                                 ENU=View the list of components in the service item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5986;
                      RunPageView=SORTING(Active,Parent Service Item No.,Line No.);
                      RunPageLink=Active=CONST(Yes),
                                  Parent Service Item No.=FIELD(No.);
                      Image=Components }
      { 19      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 15      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=&Dimensioner - enkelt;
                                 ENU=&Dimensions-Single];
                      ToolTipML=[DAN=FÜ vist eller rediger dimensioner som f.eks. omrÜde, projekt eller afdeling, som du kan tildele til kladdelinjer for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5940),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 18      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Dimensions;
                      Image=DimensionSets;
                      OnAction=VAR
                                 ServiceItem@1001 : Record 5940;
                                 DefaultDimMultiple@1000 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ServiceItem);
                                 DefaultDimMultiple.SetMultiServiceItem(ServiceItem);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 11      ;2   ;ActionGroup;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      Image=Statistics }
      { 59      ;3   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5982;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 60      ;3   ;Action    ;
                      CaptionML=[DAN=Tr&endscape;
                                 ENU=Tr&endscape];
                      ToolTipML=[DAN=Vis en detaljeret oversigt over serviceartikeltransaktioner sortert efter tidsintervaller.;
                                 ENU=View a detailed account of service item transactions by time intervals.];
                      ApplicationArea=#Service;
                      RunObject=Page 5983;
                      RunPageLink=No.=FIELD(No.);
                      Image=Trendscape }
      { 7       ;2   ;ActionGroup;
                      CaptionML=[DAN=Fejlfinding;
                                 ENU=Troubleshooting];
                      Image=Troubleshoot }
      { 44      ;3   ;Action    ;
                      CaptionML=[DAN=Opsëtning af fejlfinding;
                                 ENU=Troubleshooting Setup];
                      ToolTipML=[DAN=Vis eller rediger indstillingerne for fejlfinding til serviceartikler.;
                                 ENU=View or edit your settings for troubleshooting service items.];
                      ApplicationArea=#Service;
                      RunObject=Page 5993;
                      RunPageLink=Type=CONST(Service Item),
                                  No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Troubleshoot;
                      PromotedCategory=Process }
      { 3       ;3   ;Action    ;
                      CaptionML=[DAN=Fejlfinding;
                                 ENU=Troubleshooting];
                      ToolTipML=[DAN=Vis eller rediger oplysninger om tekniske problemer med en serviceartikel.;
                                 ENU=View or edit information about technical problems with a service item.];
                      ApplicationArea=#Service;
                      Image=Troubleshoot;
                      OnAction=VAR
                                 TroubleshootingHeader@1000 : Record 5943;
                               BEGIN
                                 TroubleshootingHeader.ShowForServItem(Rec);
                               END;
                                }
      { 54      ;2   ;Action    ;
                      CaptionML=[DAN=Ressourcekvalifikationer;
                                 ENU=Resource Skills];
                      ToolTipML=[DAN=Vis tildelingen af kvalifikationer til ressourcer, varer, serviceartikelgrupper og serviceartikler. Du kan bruge kvalifikationskoderne til at allokere kvalificerede ressourcer til serviceartikler eller varer, hvor der ved reparation krëves specialviden.;
                                 ENU=View the assignment of skills to resources, items, service item groups, and service items. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.];
                      ApplicationArea=#Service;
                      RunObject=Page 6019;
                      RunPageLink=Type=CONST(Service Item),
                                  No.=FIELD(No.);
                      Image=ResourceSkills }
      { 55      ;2   ;Action    ;
                      CaptionML=[DAN=Kva&l. ressourcer;
                                 ENU=S&killed Resources];
                      ToolTipML=[DAN=Vis listen over ressourcer, der har de nõdvendige kvalifikationer til at hÜndtere serviceartikler.;
                                 ENU=View the list of resources that have the skills required to handle service items.];
                      ApplicationArea=#Service;
                      Image=ResourceSkills;
                      OnAction=BEGIN
                                 CLEAR(SkilledResourceList);
                                 SkilledResourceList.Initialize(ResourceSkill.Type::"Service Item","No.",Description);
                                 SkilledResourceList.RUNMODAL;
                               END;
                                }
      { 57      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Service Item),
                                  Table Subtype=CONST(0),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 63      ;2   ;ActionGroup;
                      CaptionML=[DAN=S&erviceordrer;
                                 ENU=S&ervice Orders];
                      Image=Order }
      { 64      ;3   ;Action    ;
                      CaptionML=[DAN=Ser&v.art.linjer;
                                 ENU=&Item Lines];
                      ToolTipML=[DAN="Vis igangvërende serviceartikellinjer for varen. ";
                                 ENU="View ongoing service item lines for the item. "];
                      ApplicationArea=#Service;
                      RunObject=Page 5903;
                      RunPageView=SORTING(Service Item No.);
                      RunPageLink=Service Item No.=FIELD(No.);
                      Image=ItemLines }
      { 65      ;3   ;Action    ;
                      CaptionML=[DAN=&Servicelinjer;
                                 ENU=&Service Lines];
                      ToolTipML=[DAN=Vis igangvërende servicelinjer for varen.;
                                 ENU=View ongoing service lines for the item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5904;
                      RunPageView=SORTING(Service Item No.);
                      RunPageLink=Service Item No.=FIELD(No.);
                      Image=ServiceLines }
      { 66      ;2   ;ActionGroup;
                      CaptionML=[DAN=Ser&viceleverancer;
                                 ENU=Service Shi&pments];
                      Image=Shipment }
      { 67      ;3   ;Action    ;
                      CaptionML=[DAN=Ser&v.art.linjer;
                                 ENU=&Item Lines];
                      ToolTipML=[DAN="Vis igangvërende serviceartikellinjer for varen. ";
                                 ENU="View ongoing service item lines for the item. "];
                      ApplicationArea=#Service;
                      RunObject=Page 5950;
                      RunPageView=SORTING(Service Item No.);
                      RunPageLink=Service Item No.=FIELD(No.);
                      Image=ItemLines }
      { 68      ;3   ;Action    ;
                      CaptionML=[DAN=&Servicelinjer;
                                 ENU=&Service Lines];
                      ToolTipML=[DAN=Vis igangvërende servicelinjer for varen.;
                                 ENU=View ongoing service lines for the item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5949;
                      RunPageView=SORTING(Service Item No.);
                      RunPageLink=Service Item No.=FIELD(No.);
                      Image=ServiceLines }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=S&ervicekontrakter;
                                 ENU=Ser&vice Contracts];
                      ToolTipML=[DAN=èbn oversigten over igangvërende servicekontrakter.;
                                 ENU=Open the list of ongoing service contracts.];
                      ApplicationArea=#Service;
                      RunObject=Page 6075;
                      RunPageView=SORTING(Service Item No.,Contract Status);
                      RunPageLink=Service Item No.=FIELD(No.);
                      Promoted=Yes;
                      Image=ServiceAgreement;
                      PromotedCategory=Process }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 62      ;2   ;Action    ;
                      CaptionML=[DAN=Service&artikellog;
                                 ENU=Service Item Lo&g];
                      ToolTipML=[DAN=FÜ vist en liste over de ëndringer i servicedokumentet, der er registreret. I programmet oprettes der poster i vinduet, f.eks. nÜr svartiden eller serviceordrens status er ëndret, en ressource er allokeret, en serviceordre er leveret eller faktureret osv. Hver linje i vinduet identificerer den hëndelse, der er forekommet i servicedokumentet. Linjen indeholder oplysninger om det felt, der er ëndret, dets gamle og nye vërdi, datoen og tidspunktet for, hvornÜr ëndringen fandt sted, og id'et for den bruger, som foretog ëndringerne.;
                                 ENU=View a list of the service document changes that have been logged. The program creates entries in the window when, for example, the response time or service order status changed, a resource was allocated, a service order was shipped or invoiced, and so on. Each line in this window identifies the event that occurred to the service document. The line contains the information about the field that was changed, its old and new value, the date and time when the change took place, and the ID of the user who actually made the changes.];
                      ApplicationArea=#Service;
                      RunObject=Page 5989;
                      RunPageLink=Service Item No.=FIELD(No.);
                      Image=Log }
      { 28      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Service&poster;
                                 ENU=Service Ledger E&ntries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogfõringstransaktioner i servicedokumenter.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Page 5912;
                      RunPageView=SORTING(Service Item No. (Serviced),Entry Type,Moved from Prepaid Acc.,Type,Posting Date);
                      RunPageLink=Service Item No. (Serviced)=FIELD(No.),
                                  Service Order No.=FIELD(Service Order Filter),
                                  Service Contract No.=FIELD(Contract Filter),
                                  Posting Date=FIELD(Date Filter);
                      Image=ServiceLedger }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=&Garantiposter;
                                 ENU=&Warranty Ledger Entries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogfõringstransaktioner i servicedokumenter, der indeholder garantiaftaler.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents that contain warranty agreements.];
                      ApplicationArea=#Service;
                      RunObject=Page 5913;
                      RunPageView=SORTING(Service Item No. (Serviced),Posting Date,Document No.);
                      RunPageLink=Service Item No. (Serviced)=FIELD(No.);
                      Image=WarrantyLedger }
      { 1900000005;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Ny;
                                 ENU=New] }
      { 1900294905;2 ;Action    ;
                      CaptionML=[DAN=Ny vare;
                                 ENU=New Item];
                      ToolTipML=[DAN=Opret et varekort, der er baseret pÜ lagervaren.;
                                 ENU=Create an item card based on the stockkeeping unit.];
                      ApplicationArea=#Service;
                      RunObject=Page 30;
                      Promoted=Yes;
                      Image=NewItem;
                      PromotedCategory=New;
                      RunPageMode=Create }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1904837406;1 ;Action    ;
                      CaptionML=[DAN=Serviceartikel;
                                 ENU=Service Item];
                      ToolTipML=[DAN=Opret en ny serviceartikel.;
                                 ENU=Create a new service item.];
                      ApplicationArea=#Service;
                      RunObject=Report 5935;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1905919306;1 ;Action    ;
                      CaptionML=[DAN=Serviceartikel - etiket;
                                 ENU=Service Item Label];
                      ToolTipML=[DAN=Vis oversigten over serviceartikler i serviceordrer. Rapporten viser ordrenummer, serviceartikelnummer, serienummer og navnet pÜ varen.;
                                 ENU=View the list of service items on service orders. The report shows the order number, service item number, serial number, and the name of the item.];
                      ApplicationArea=#Service;
                      RunObject=Report 5901;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1907713806;1 ;Action    ;
                      CaptionML=[DAN=Serviceart. - ressourceforbrug;
                                 ENU=Service Item Resource usage];
                      ToolTipML=[DAN=Vis oplysninger om den samlede brug af serviceartikler, bÜde omkostninger og belõb, avancebelõb og avanceprocent.;
                                 ENU=View details about the total use of service items, both cost and amount, profit amount, and profit percentage.];
                      ApplicationArea=#Service;
                      RunObject=Report 5939;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1901646906;1 ;Action    ;
                      CaptionML=[DAN=Serviceart. - garanti udlõbet;
                                 ENU=Service Item Out of Warranty];
                      ToolTipML=[DAN=Vis oplysninger om garantiudlõbsdatoer, serienumre, antal aktive kontrakter, varebeskrivelse og navne pÜ debitorer. Du kan udskrive en oversigt over serviceartikler, hvis garanti er udlõbet.;
                                 ENU=View information about warranty end dates, serial numbers, number of active contracts, items description, and names of customers. You can print a list of service items that are out of warranty.];
                      ApplicationArea=#Service;
                      RunObject=Report 5937;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of this item.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det varenummer, som er knyttet til serviceartiklen.;
                           ENU=Specifies the item number linked to the service item.];
                ApplicationArea=#Service;
                SourceExpr="Item No." }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den vare, som serviceartiklen er tilknyttet.;
                           ENU=Specifies the description of the item that the service item is linked to.];
                ApplicationArea=#Service;
                SourceExpr="Item Description" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret pÜ varen.;
                           ENU=Specifies the serial number of this item.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som ejer varen.;
                           ENU=Specifies the number of the customer who owns this item.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code" }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for reservedelsgarantien for varen.;
                           ENU=Specifies the starting date of the spare parts warranty for this item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Starting Date (Parts)" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for reservedelsgarantien for varen.;
                           ENU=Specifies the ending date of the spare parts warranty for this item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Ending Date (Parts)" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for arbejdsgarantien for varen.;
                           ENU=Specifies the starting date of the labor warranty for this item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Starting Date (Labor)" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for arbejdsgarantien for varen.;
                           ENU=Specifies the ending date of the labor warranty for this item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Ending Date (Labor)" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en alternativ beskrivelse til sõgning efter serviceartiklen.;
                           ENU=Specifies an alternate description to search for the service item.];
                ApplicationArea=#Service;
                SourceExpr="Search Description" }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver statussen for serviceartiklen.;
                           ENU=Specifies the status of the service item.];
                ApplicationArea=#Service;
                SourceExpr=Status;
                Visible=FALSE }

    { 1102601002;2;Field  ;
                ToolTipML=[DAN=Angiver serviceprioriteten for varen.;
                           ENU=Specifies the service priority for this item.];
                ApplicationArea=#Service;
                SourceExpr=Priority;
                Visible=FALSE }

    { 1102601004;2;Field  ;
                ToolTipML=[DAN=Angiver datoen for den sidste service pÜ varen.;
                           ENU=Specifies the date of the last service on this item.];
                ApplicationArea=#Service;
                SourceExpr="Last Service Date";
                Visible=FALSE }

    { 1102601006;2;Field  ;
                ToolTipML=[DAN=Angiver, at serviceartiklen er tilknyttet en eller flere servicekontrakter eller -tilbud.;
                           ENU=Specifies that this service item is associated with one or more service contracts/quotes.];
                ApplicationArea=#Service;
                SourceExpr="Service Contracts";
                Visible=FALSE }

    { 1102601008;2;Field  ;
                ToolTipML=[DAN=Angiver nummeret pÜ kreditoren for varen.;
                           ENU=Specifies the number of the vendor for this item.];
                ApplicationArea=#Service;
                SourceExpr="Vendor No.";
                Visible=FALSE }

    { 1102601010;2;Field  ;
                ToolTipML=[DAN=Angiver kreditornavnet for varen.;
                           ENU=Specifies the vendor name for this item.];
                ApplicationArea=#Service;
                SourceExpr="Vendor Name";
                Visible=FALSE }

    { 1102601012;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor varen blev installeret pÜ debitorens adresse.;
                           ENU=Specifies the date when this item was installed at the customer's site.];
                ApplicationArea=#Service;
                SourceExpr="Installation Date";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ResourceSkill@1001 : Record 5956;
      SkilledResourceList@1003 : Page 6023;

    BEGIN
    END.
  }
}

