OBJECT Page 6000 Dispatch Board
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ordreoversigt;
               ENU=Dispatch Board];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table5900;
    SourceTableView=SORTING(Status,Response Date,Response Time,Priority);
    DataCaptionFields=Status;
    PageType=Worksheet;
    OnOpenPage=BEGIN
                 IF UserMgt.GetServiceFilter <> '' THEN BEGIN
                   FILTERGROUP(2);
                   SETRANGE("Responsibility Center",UserMgt.GetServiceFilter);
                   FILTERGROUP(0);
                 END;
                 SetAllFilters;

                 IF ISEMPTY THEN BEGIN
                   ServOrderFilter := '';
                   SetServOrderFilter;
                 END;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 59      ;1   ;ActionGroup;
                      CaptionML=[DAN=Or&dreoversigt;
                                 ENU=&Dispatch Board];
                      Image=ServiceMan }
      { 60      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=&Vis dokument;
                                 ENU=&Show Document];
                      ToolTipML=[DAN=�bn det bilag, som oplysningerne p� linjen stammer fra.;
                                 ENU=Open the document that the information on the line comes from.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=View;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PageManagement@1000 : Codeunit 700;
                               BEGIN
                                 PageManagement.PageRunModal(Rec);
                               END;
                                }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Planl�gn.;
                                 ENU=Pla&nning];
                      Image=Planning }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Ressourceallo&keringer;
                                 ENU=Resource &Allocations];
                      ToolTipML=[DAN=F� vist eller alloker ressourcer, f.eks. teknikere, eller ressourcegrupper til serviceartikler. Allokeringen kan foretages efter ressourcenummer eller ressourcegruppenummer, allokeringsdato og allokerede timer. Du kan ogs� genallokere og annullere allokeringer. Der kan kun v�re �n aktiv allokering pr. serviceartikel.;
                                 ENU=View or allocate resources, such as technicians or resource groups to service items. The allocation can be made by resource number or resource group number, allocation date and allocated hours. You can also reallocate and cancel allocations. You can only have one active allocation per service item.];
                      ApplicationArea=#Service;
                      RunObject=Page 6005;
                      RunPageView=SORTING(Status,Document Type,Document No.,Service Item Line No.,Allocation Date,Starting Time,Posted)
                                  WHERE(Status=FILTER(<>Canceled));
                      RunPageLink=Document Type=FIELD(Document Type),
                                  Document No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ResourcePlanning;
                      PromotedCategory=Process }
      { 55      ;2   ;Action    ;
                      CaptionML=[DAN=Behovsoversigt;
                                 ENU=Demand Overview];
                      ToolTipML=[DAN=F� et overblik over behovet for dine varer ved planl�gning af salg, produktion, sager eller servicestyring, og hvorn�r de er tilg�ngelige.;
                                 ENU=Get an overview of demand for your items when planning sales, production, jobs, or service management and when they will be available.];
                      ApplicationArea=#Service;
                      Image=Forecast;
                      OnAction=VAR
                                 DemandOverview@1000 : Page 5830;
                               BEGIN
                                 DemandOverview.SetCalculationParameter(TRUE);
                                 DemandOverview.Initialize(0D,4,'','','');
                                 DemandOverview.RUNMODAL;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 47      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      Image=Print }
      { 48      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udskriv Or&dreoversigt;
                                 ENU=Print &Dispatch Board];
                      ToolTipML=[DAN=Udskriv oplysningerne p� ordreoversigten.;
                                 ENU=Print the information on the dispatch board.];
                      ApplicationArea=#Service;
                      Image=Print;
                      OnAction=BEGIN
                                 REPORT.RUN(REPORT::"Dispatch Board",TRUE,TRUE,Rec);
                               END;
                                }
      { 49      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udskriv service&ordre;
                                 ENU=Print Service &Order];
                      ToolTipML=[DAN=Udskriv den valgte serviceordre.;
                                 ENU=Print the selected service order.];
                      ApplicationArea=#Service;
                      Image=Print;
                      OnAction=BEGIN
                                 CLEAR(ServHeader);
                                 ServHeader.SETRANGE("Document Type","Document Type");
                                 ServHeader.SETRANGE("No.","No.");
                                 REPORT.RUN(REPORT::"Service Order",TRUE,TRUE,ServHeader);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 22  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 24  ;2   ;Field     ;
                CaptionML=[DAN=Ressourcefilter;
                           ENU=Resource Filter];
                ToolTipML=[DAN=Angiver det filter, der viser en oversigt over bilag med serviceartikellinjer, som en bestemt ressource er allokeret til.;
                           ENU=Specifies the filter that displays an overview of documents with service item lines that a certain resource is allocated to.];
                ApplicationArea=#Service;
                SourceExpr=ResourceFilter;
                OnValidate=BEGIN
                             SetResourceFilter;
                             ResourceFilterOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           Res.RESET;
                           IF PAGE.RUNMODAL(0,Res) = ACTION::LookupOK THEN BEGIN
                             Text := Res."No.";
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 39  ;2   ;Field     ;
                CaptionML=[DAN=Ressourcegruppefilter;
                           ENU=Resource Group Filter];
                ToolTipML=[DAN=Angiver det filter, der viser en oversigt over bilag med serviceartikellinjer, som en bestemt ressourcegruppe er allokeret til.;
                           ENU=Specifies the filter that displays an overview of documents with service item lines that a certain resource group is allocated to.];
                ApplicationArea=#Service;
                SourceExpr=ResourceGroupFilter;
                OnValidate=BEGIN
                             SetResourceGroupFilter;
                             ResourceGroupFilterOnAfterVali;
                           END;

                OnLookup=BEGIN
                           ResourceGroup.RESET;
                           IF PAGE.RUNMODAL(0,ResourceGroup) = ACTION::LookupOK THEN BEGIN
                             Text := ResourceGroup."No.";
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 42  ;2   ;Field     ;
                CaptionML=[DAN=Svardatofilter;
                           ENU=Response Date Filter];
                ToolTipML=[DAN=Angiver det filter, der viser en oversigt over bilag med den angivne v�rdi, i feltet Svardato.;
                           ENU=Specifies the filter that displays an overview of documents with the specified value in the Response Date field.];
                ApplicationArea=#Service;
                SourceExpr=RespDateFilter;
                OnValidate=BEGIN
                             SetRespDateFilter;
                             RespDateFilterOnAfterValidate;
                           END;
                            }

    { 30  ;2   ;Field     ;
                CaptionML=[DAN=Allokeringsfilter;
                           ENU=Allocation Filter];
                ToolTipML=[DAN=Angiver det filter, der viser oversigten over bilag fra deres allokeringsanalysesynspunkt.;
                           ENU=Specifies the filter that displays the overview of documents from their allocation analysis point of view.];
                OptionCaptionML=[DAN=" ,Ing. el. delvis allokering,Fuld allokering,Genallokering n�dv.";
                                 ENU=" ,No or Partial Allocation,Full Allocation,Reallocation Needed"];
                ApplicationArea=#Service;
                SourceExpr=AllocationFilter;
                OnValidate=BEGIN
                             SetAllocFilter;
                             AllocationFilterOnAfterValidat;
                           END;
                            }

    { 26  ;2   ;Field     ;
                CaptionML=[DAN=Dokumentfilter;
                           ENU=Document Filter];
                ToolTipML=[DAN=Angiver det filter, der viser en oversigt over bilag af den angivne type.;
                           ENU=Specifies the filter that displays the overview of the documents of the specified type.];
                OptionCaptionML=[DAN=Ordre,Tilbud,Alle;
                                 ENU=Order,Quote,All];
                ApplicationArea=#Service;
                SourceExpr=DocFilter;
                OnValidate=BEGIN
                             SetDocFilter;
                             DocFilterOnAfterValidate;
                           END;
                            }

    { 65  ;2   ;Field     ;
                CaptionML=[DAN=Nummerfilter;
                           ENU=No. Filter];
                ToolTipML=[DAN=Angiver det filter, der bruges til at se det angivne bilag.;
                           ENU=Specifies the filter that is used to see the specified document.];
                ApplicationArea=#Service;
                SourceExpr=ServOrderFilter;
                OnValidate=BEGIN
                             SetServOrderFilter;
                             ServOrderFilterOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           ServHeader.RESET;
                           SetDocFilter2(ServHeader);
                           IF PAGE.RUNMODAL(0,ServHeader) = ACTION::LookupOK THEN BEGIN
                             Text := ServHeader."No.";
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 79  ;2   ;Field     ;
                CaptionML=[DAN=Statusfilter;
                           ENU=Status Filter];
                ToolTipML=[DAN=Angiver det filter, der viser en oversigt over bilag med en bestemt v�rdi, i feltet Status.;
                           ENU=Specifies the filter that displays an overview of documents with a certain value in the Status field.];
                OptionCaptionML=[DAN=" ,Igangsat,I arbejde,Udf�rt,Afvent";
                                 ENU=" ,Pending,In Process,Finished,On Hold"];
                ApplicationArea=#Service;
                SourceExpr=StatusFilter;
                OnValidate=BEGIN
                             SetStatusFilter;
                             StatusFilterOnAfterValidate;
                           END;
                            }

    { 45  ;2   ;Field     ;
                CaptionML=[DAN=Debitorfilter;
                           ENU=Customer Filter];
                ToolTipML=[DAN=Angiver det filter, der viser en oversigt over bilag med en bestemt v�rdi, i feltet Debitornr.;
                           ENU=Specifies the filter that displays an overview of documents with a certain value in the Customer No. field.];
                ApplicationArea=#Service;
                SourceExpr=CustomFilter;
                OnValidate=BEGIN
                             SetCustFilter;
                             CustomFilterOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           Cust.RESET;
                           IF PAGE.RUNMODAL(0,Cust) = ACTION::LookupOK THEN BEGIN
                             Text := Cust."No.";
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 43  ;2   ;Field     ;
                CaptionML=[DAN=Kontraktfilter;
                           ENU=Contract Filter];
                ToolTipML=[DAN=Angiver alle fakturerbare priser for sagsopgaven.;
                           ENU=Specifies all billable prices for the job task.];
                ApplicationArea=#Service;
                SourceExpr=ContractFilter;
                OnValidate=BEGIN
                             SetContractFilter;
                             ContractFilterOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           ServiceContract.RESET;
                           ServiceContract.SETRANGE("Contract Type",ServiceContract."Contract Type"::Contract);
                           IF PAGE.RUNMODAL(0,ServiceContract) = ACTION::LookupOK THEN BEGIN
                             Text := ServiceContract."Contract No.";
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 37  ;2   ;Field     ;
                CaptionML=[DAN=Zonefilter;
                           ENU=Zone Filter];
                ToolTipML=[DAN=Angiver det filter, der viser en oversigt over bilag med en bestemt v�rdi, i feltet Servicezonekode.;
                           ENU=Specifies the filter that displays an overview of documents with a certain value in the Service Zone Code field.];
                ApplicationArea=#Service;
                SourceExpr=ZoneFilter;
                OnValidate=BEGIN
                             SetZoneFilter;
                             ZoneFilterOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           ServiceZones.RESET;
                           IF PAGE.RUNMODAL(0,ServiceZones) = ACTION::LookupOK THEN BEGIN
                             Text := ServiceZones.Code;
                             EXIT(TRUE);
                           END;
                         END;
                          }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ansl�ede dato, hvor arbejdet p� ordren skal p�begyndes, dvs. n�r serviceordrens status �ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the estimated date when work on the order should start, that is, when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Response Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det ansl�ede klokkesl�t, hvor arbejdet p� ordren begynder, dvs. n�r serviceordrens status �ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the estimated time when work on the order starts, that is, when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Response Time" }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prioriteten for serviceordren.;
                           ENU=Specifies the priority of the service order.];
                ApplicationArea=#Service;
                SourceExpr=Priority }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for servicedokumentet p� linjen.;
                           ENU=Specifies the type of the service document on the line.];
                ApplicationArea=#Service;
                SourceExpr="Document Type" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af servicedokumentet, f.eks Ordre 2001.;
                           ENU=Specifies a short description of the service document, such as Order 2001.];
                ApplicationArea=#Service;
                SourceExpr=Description;
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serviceordrens status, som afspejler reparations- eller vedligeholdelsesstatus for alle serviceartikler i serviceordren.;
                           ENU=Specifies the service order status, which reflects the repair or maintenance status of all service items on the service order.];
                ApplicationArea=#Service;
                SourceExpr=Status }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som ejer varerne i servicedokumentet.;
                           ENU=Specifies the number of the customer who owns the items in the service document.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den debitor, som varerne i bilaget skal leveres til.;
                           ENU=Specifies the name of the customer to whom the items on the document will be shipped.];
                ApplicationArea=#Service;
                SourceExpr=Name }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kontrakt, som er knyttet til ordren.;
                           ENU=Specifies the number of the contract associated with the order.];
                ApplicationArea=#Service;
                SourceExpr="Contract No.";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver servicezonekoden for debitorens leveringsadresse i serviceordren.;
                           ENU=Specifies the service zone code of the customer's ship-to address in the service order.];
                ApplicationArea=#Service;
                SourceExpr="Service Zone Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af ressourceallokeringer til serviceartiklerne i ordren.;
                           ENU=Specifies the number of resource allocations to service items in this order.];
                ApplicationArea=#Service;
                SourceExpr="No. of Allocations" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den relaterede ordre blev oprettet.;
                           ENU=Specifies the date when the related order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Date" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl�t, hvor serviceordren blev oprettet.;
                           ENU=Specifies the time when the service order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Time" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du skal allokere ressourcerne p� ny til mindst �n serviceartikel i serviceordren.;
                           ENU=Specifies that you must reallocate resources to at least one service item in this service order.];
                ApplicationArea=#Service;
                SourceExpr="Reallocation Needed" }

    { 94  ;1   ;Group      }

    { 92  ;2   ;Field     ;
                Name=Description2;
                CaptionML=[DAN=Beskrivelse af serviceordre;
                           ENU=Service Order Description];
                ToolTipML=[DAN=Angiver en kort beskrivelse af servicedokumentet, f.eks Ordre 2001.;
                           ENU=Specifies a short description of the service document, such as Order 2001.];
                ApplicationArea=#Service;
                SourceExpr=Description;
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
      ServiceZones@1018 : Record 5957;
      Cust@1017 : Record 18;
      Res@1020 : Record 156;
      ResourceGroup@1023 : Record 152;
      ServHeader@1004 : Record 5900;
      ServiceContract@1019 : Record 5965;
      UserMgt@1005 : Codeunit 5700;
      DocFilter@1006 : 'Order,Quote,All';
      StatusFilter@1007 : ' ,Pending,In Process,Finished,On Hold';
      RespDateFilter@1010 : Text;
      ServOrderFilter@1009 : Text;
      CustomFilter@1013 : Text;
      ZoneFilter@1014 : Text;
      ContractFilter@1015 : Text;
      ResourceFilter@1016 : Text;
      ResourceGroupFilter@1022 : Text;
      AllocationFilter@1008 : ' ,No or Partial Allocation,Full Allocation,Reallocation Needed';

    [External]
    PROCEDURE SetAllFilters@3();
    BEGIN
      SetDocFilter;
      SetStatusFilter;
      SetRespDateFilter;
      SetServOrderFilter;
      SetCustFilter;
      SetZoneFilter;
      SetContractFilter;
      SetResourceFilter;
      SetResourceGroupFilter;
      SetAllocFilter;
    END;

    [External]
    PROCEDURE SetDocFilter@7();
    BEGIN
      FILTERGROUP(2);
      SetDocFilter2(Rec);
      FILTERGROUP(0);
    END;

    [External]
    PROCEDURE SetDocFilter2@2(VAR ServHeader@1000 : Record 5900);
    BEGIN
      WITH ServHeader DO BEGIN
        FILTERGROUP(2);
        CASE DocFilter OF
          DocFilter::Order:
            SETRANGE("Document Type","Document Type"::Order);
          DocFilter::Quote:
            SETRANGE("Document Type","Document Type"::Quote);
          DocFilter::All:
            SETFILTER("Document Type",'%1|%2',"Document Type"::Order,"Document Type"::Quote);
        END;
        FILTERGROUP(0);
      END;
    END;

    [External]
    PROCEDURE SetStatusFilter@8();
    BEGIN
      FILTERGROUP(2);
      CASE StatusFilter OF
        StatusFilter::" ":
          SETRANGE(Status);
        StatusFilter::Pending:
          SETRANGE(Status,Status::Pending);
        StatusFilter::"In Process":
          SETRANGE(Status,Status::"In Process");
        StatusFilter::Finished:
          SETRANGE(Status,Status::Finished);
        StatusFilter::"On Hold":
          SETRANGE(Status,Status::"On Hold");
      END;
      FILTERGROUP(0);
    END;

    [External]
    PROCEDURE SetRespDateFilter@9();
    BEGIN
      FILTERGROUP(2);
      SETFILTER("Response Date",RespDateFilter);
      RespDateFilter := GETFILTER("Response Date");
      FILTERGROUP(0);
    END;

    [External]
    PROCEDURE SetServOrderFilter@10();
    BEGIN
      FILTERGROUP(2);
      SETFILTER("No.",ServOrderFilter);
      ServOrderFilter := GETFILTER("No.");
      FILTERGROUP(0);
    END;

    [External]
    PROCEDURE SetCustFilter@11();
    BEGIN
      FILTERGROUP(2);
      SETFILTER("Customer No.",CustomFilter);
      CustomFilter := GETFILTER("Customer No.");
      FILTERGROUP(0);
    END;

    [External]
    PROCEDURE SetZoneFilter@12();
    BEGIN
      FILTERGROUP(2);
      SETFILTER("Service Zone Code",ZoneFilter);
      ZoneFilter := GETFILTER("Service Zone Code");
      FILTERGROUP(0);
    END;

    [External]
    PROCEDURE SetContractFilter@13();
    BEGIN
      FILTERGROUP(2);
      SETFILTER("Contract No.",ContractFilter);
      ContractFilter := GETFILTER("Contract No.");
      FILTERGROUP(0);
    END;

    [External]
    PROCEDURE SetResourceFilter@4();
    BEGIN
      FILTERGROUP(2);
      IF ResourceFilter <> '' THEN BEGIN
        SETFILTER("No. of Allocations",'>0');
        SETFILTER("Resource Filter",ResourceFilter);
        ResourceFilter := GETFILTER("Resource Filter");
      END ELSE BEGIN
        IF ResourceGroupFilter = '' THEN
          SETRANGE("No. of Allocations");
        SETRANGE("Resource Filter");
      END;
      FILTERGROUP(0);
    END;

    [External]
    PROCEDURE SetResourceGroupFilter@6();
    BEGIN
      FILTERGROUP(2);
      IF ResourceGroupFilter <> '' THEN BEGIN
        SETFILTER("No. of Allocations",'>0');
        SETFILTER("Resource Group Filter",ResourceGroupFilter);
        ResourceGroupFilter := GETFILTER("Resource Group Filter");
      END ELSE BEGIN
        IF ResourceFilter = '' THEN
          SETRANGE("No. of Allocations");
        SETRANGE("Resource Group Filter");
      END;
      FILTERGROUP(0);
    END;

    [External]
    PROCEDURE SetAllocFilter@1();
    BEGIN
      FILTERGROUP(2);
      CASE AllocationFilter OF
        AllocationFilter::" ":
          BEGIN
            SETRANGE("No. of Unallocated Items");
            SETRANGE("Reallocation Needed");
          END;
        AllocationFilter::"No or Partial Allocation":
          BEGIN
            SETFILTER("No. of Unallocated Items",'>0');
            SETRANGE("Reallocation Needed",FALSE);
          END;
        AllocationFilter::"Full Allocation":
          BEGIN
            SETRANGE("No. of Unallocated Items",0);
            SETRANGE("Reallocation Needed",FALSE);
          END;
        AllocationFilter::"Reallocation Needed":
          BEGIN
            SETRANGE("No. of Unallocated Items");
            SETRANGE("Reallocation Needed",TRUE);
          END;
      END;
      FILTERGROUP(0);
    END;

    LOCAL PROCEDURE RespDateFilterOnAfterValidate@19063229();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ServOrderFilterOnAfterValidate@19063213();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE StatusFilterOnAfterValidate@19021475();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ZoneFilterOnAfterValidate@19076430();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE CustomFilterOnAfterValidate@19018481();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ContractFilterOnAfterValidate@19030304();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ResourceFilterOnAfterValidate@19005532();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE DocFilterOnAfterValidate@19004301();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE AllocationFilterOnAfterValidat@19066130();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ResourceGroupFilterOnAfterVali@19056724();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

