OBJECT Page 5988 Service Items
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
    CaptionML=[DAN=Serviceartikler;
               ENU=Service Items];
    SourceTable=Table5940;
    DataCaptionExpr=GetCaption;
    PageType=List;
    CardPageID=Service Item Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Serviceart.;
                                 ENU=&Serv. Item];
                      Image=ServiceItem }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Service Item),
                                  Table Subtype=CONST(0),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 19      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Service&poster;
                                 ENU=Service Ledger E&ntries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf›ringstransaktioner i servicedokumenter.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents.];
                      ApplicationArea=#Service;
                      RunObject=Page 5912;
                      RunPageView=SORTING(Service Item No. (Serviced),Entry Type,Moved from Prepaid Acc.,Type,Posting Date);
                      RunPageLink=Service Item No. (Serviced)=FIELD(No.),
                                  Service Order No.=FIELD(Service Order Filter),
                                  Service Contract No.=FIELD(Contract Filter),
                                  Posting Date=FIELD(Date Filter);
                      Image=ServiceLedger }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=&Garantiposter;
                                 ENU=&Warranty Ledger Entries];
                      ToolTipML=[DAN=Vis alle poster for den serviceartikel eller serviceordre, der stammer fra bogf›ringstransaktioner i servicedokumenter, der indeholder garantiaftaler.;
                                 ENU=View all the ledger entries for the service item or service order that result from posting transactions in service documents that contain warranty agreements.];
                      ApplicationArea=#Service;
                      RunObject=Page 5913;
                      RunPageView=SORTING(Service Item No. (Serviced),Posting Date,Document No.);
                      RunPageLink=Service Item No. (Serviced)=FIELD(No.);
                      Image=WarrantyLedger }
      { 21      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5982;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=&Trendscape;
                                 ENU=&Trendscape];
                      ToolTipML=[DAN=Vis en oversigt, som du kan rulle op og ned i, over serviceposter, der vedr›rer en bestemt serviceartikel. Oversigten oprettes for et bestemt tidsinterval.;
                                 ENU=View a scrollable summary of service ledger entries that are related to a specific service item. This summary is generated for a specific time period.];
                      ApplicationArea=#Service;
                      RunObject=Page 5983;
                      RunPageLink=No.=FIELD(No.);
                      Image=Trendscape }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=L&og;
                                 ENU=L&og];
                      ToolTipML=[DAN=F† vist listen over de ‘ndringer af serviceartikler, der er blevet registreret, f.eks. hvis garantien er blevet ‘ndret, eller der er tilf›jet en komponent. I dette vindue vises det felt, der er blevet ‘ndret, den gamle v‘rdi og den nye v‘rdi, samt datoen og klokkesl‘ttet for ‘ndringen.;
                                 ENU=View the list of the service item changes that have been logged, for example, when the warranty has changed or a component has been added. This window displays the field that was changed, the old value and the new value, and the date and time that the field was changed.];
                      ApplicationArea=#Service;
                      RunObject=Page 5989;
                      RunPageLink=Service Item No.=FIELD(No.);
                      Image=Approve }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Ko&mponenter;
                                 ENU=Com&ponents];
                      ToolTipML=[DAN=Vis oversigten over komponenter i serviceartiklen.;
                                 ENU=View the list of components in the service item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5986;
                      RunPageView=SORTING(Active,Parent Service Item No.,Line No.);
                      RunPageLink=Active=CONST(Yes),
                                  Parent Service Item No.=FIELD(No.);
                      Image=Components }
      { 38      ;2   ;Separator  }
      { 43      ;2   ;ActionGroup;
                      CaptionML=[DAN=Ops‘tning af fejl&finding;
                                 ENU=Trou&bleshooting  Setup];
                      Image=Troubleshoot }
      { 44      ;3   ;Action    ;
                      Name=ServiceItemGroup;
                      CaptionML=[DAN=Serviceartikelgruppe;
                                 ENU=Service Item Group];
                      ToolTipML=[DAN=Vis eller rediger grupper af serviceartikler.;
                                 ENU=View or edit groupings of service items.];
                      ApplicationArea=#Service;
                      RunObject=Page 5993;
                      RunPageLink=Type=CONST(Service Item Group),
                                  No.=FIELD(Service Item Group Code);
                      Image=ServiceItemGroup }
      { 45      ;3   ;Action    ;
                      Name=ServiceItem;
                      CaptionML=[DAN=Serviceartikel;
                                 ENU=Service Item];
                      ToolTipML=[DAN=Opret en ny serviceartikel.;
                                 ENU=Create a new service item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5993;
                      RunPageLink=Type=CONST(Service Item),
                                  No.=FIELD(No.);
                      Image=Report }
      { 46      ;3   ;Action    ;
                      Name=Item;
                      CaptionML=[DAN=Vare;
                                 ENU=Item];
                      ToolTipML=[DAN=Vis og rediger detaljerede oplysninger om varen.;
                                 ENU=View and edit detailed information for the item.];
                      ApplicationArea=#Service;
                      RunObject=Page 5993;
                      RunPageLink=Type=CONST(Item),
                                  No.=FIELD(Item No.);
                      Image=Item }
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
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p† varen.;
                           ENU=Specifies the serial number of this item.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som ejer varen.;
                           ENU=Specifies the number of the customer who owns this item.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
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
      Text000@1000 : TextConst '@@@="%1=Cust.""No.""  %2=Cust.Name";DAN=%1 %2;ENU=%1 %2';
      Text001@1001 : TextConst '@@@="%1 = Item no, %2 = Item description";DAN=%1 %2;ENU=%1 %2';

    LOCAL PROCEDURE GetCaption@1() : Text[80];
    VAR
      Cust@1000 : Record 18;
      Item@1001 : Record 27;
    BEGIN
      CASE TRUE OF
        GETFILTER("Customer No.") <> '':
          BEGIN
            IF Cust.GET(GETRANGEMIN("Customer No.")) THEN
              EXIT(STRSUBSTNO(Text000,Cust."No.",Cust.Name));
            EXIT(STRSUBSTNO('%1 %2',GETRANGEMIN("Customer No.")));
          END;
        GETFILTER("Item No.") <> '':
          BEGIN
            IF Item.GET(GETRANGEMIN("Item No.")) THEN
              EXIT(STRSUBSTNO(Text001,Item."No.",Item.Description));
            EXIT(STRSUBSTNO('%1 %2',GETRANGEMIN("Item No.")));
          END;
        ELSE
          EXIT('');
      END;
    END;

    BEGIN
    END.
  }
}

