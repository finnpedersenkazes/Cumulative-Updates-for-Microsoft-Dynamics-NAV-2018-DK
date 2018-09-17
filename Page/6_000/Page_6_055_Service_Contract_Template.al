OBJECT Page 6055 Service Contract Template
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Skabelon til servicekontrakt;
               ENU=Service Contract Template];
    SourceTable=Table5968;
    PageType=Card;
    OnInit=BEGIN
             InvoiceAfterServiceEnable := TRUE;
             PrepaidEnable := TRUE;
           END;

    OnOpenPage=BEGIN
                 ActivateFields;
               END;

    OnAfterGetCurrRecord=BEGIN
                           ActivateFields;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&ontraktskabelon;
                                 ENU=&Contract Template];
                      Image=Template }
      { 21      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5968),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 52      ;2   ;Action    ;
                      CaptionML=[DAN=Servicera&batter;
                                 ENU=Service Dis&counts];
                      ToolTipML=[DAN=Vis eller rediger de rabatter, som du giver i kontrakten pÜ reservedele (specielt serviceartikelgrupper), rabatterne pÜ ressourcetidsforbrug (specielt ressourcegrupper) og rabatterne pÜ bestemte serviceomkostninger.;
                                 ENU=View or edit the discounts that you grant for the contract on spare parts in particular service item groups, the discounts on resource hours for resources in particular resource groups, and the discounts on particular service costs.];
                      ApplicationArea=#Service;
                      RunObject=Page 6058;
                      RunPageLink=Contract Type=CONST(Template),
                                  Contract No.=FIELD(No.);
                      Image=Discount }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               AssistEdit(Rec);
                             END;
                              }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af servicekontrakten.;
                           ENU=Specifies a description of the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontraktgruppekoden for servicekontrakten.;
                           ENU=Specifies the contract group code of the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Contract Group Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den serviceordretype, der tildeles de serviceordrer, som er knyttet til servicekontrakten.;
                           ENU=Specifies the service order type assigned to service orders linked to this service contract.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardserviceperioden for varerne i kontrakten.;
                           ENU=Specifies the default service period for the items in the contract.];
                ApplicationArea=#Service;
                SourceExpr="Default Service Period" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisopdateringsperioden for servicekontrakten.;
                           ENU=Specifies the price update period for this service contract.];
                ApplicationArea=#Service;
                SourceExpr="Price Update Period" }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardsvartiden for den servicekontrakt, der er oprettet ud fra denne servicekontraktskabelon.;
                           ENU=Specifies the default response time for the service contract created from this service contract template.];
                ApplicationArea=#Service;
                SourceExpr="Default Response Time (Hours)" }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den maksimale enhedspris, der kan angives for en ressource pÜ linjer for serviceordrer, der er tilknyttet servicekontrakten.;
                           ENU=Specifies the maximum unit price that can be set for a resource on lines for service orders associated with the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Max. Labor Unit Price" }

    { 1904200701;1;Group  ;
                CaptionML=[DAN=Faktura;
                           ENU=Invoice] }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der er knyttet til servicekontraktkontogruppen.;
                           ENU=Specifies the code associated with the service contract account group.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Contract Acc. Gr. Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fakturaperioden for servicekontrakten.;
                           ENU=Specifies the invoice period for the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Invoice Period" }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=Udvidet kontrakttekst;
                           ENU=Contract Increase Text];
                ToolTipML=[DAN=Angiver alle fakturerbare priser for sagsopgaven, anfõrt i den lokale valuta.;
                           ENU=Specifies all billable prices for the job task, expressed in the local currency.];
                ApplicationArea=#Service;
                SourceExpr="Price Inv. Increase Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at servicekontrakten er forudbetalt.;
                           ENU=Specifies that this service contract is prepaid.];
                ApplicationArea=#Service;
                SourceExpr=Prepaid;
                Enabled=PrepaidEnable;
                OnValidate=BEGIN
                             PrepaidOnAfterValidate;
                           END;
                            }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om indholdet i feltet Beregnet Ürligt belõb kopieres til feltet èrligt belõb i servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies if the contents of the Calcd. Annual Amount field are copied into the Annual Amount field in the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Allow Unbalanced Amounts" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du vil kombinere fakturaer for denne servicekontrakt med fakturaer for andre servicekontrakter med samme faktureringsdebitor.;
                           ENU=Specifies you want to combine invoices for this service contract with invoices for other service contracts with the same bill-to customer.];
                ApplicationArea=#Service;
                SourceExpr="Combine Invoices" }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der oprettes en kreditnota, nÜr du fjerner en kontraktlinje fra servicekontrakten under bestemte betingelser.;
                           ENU=Specifies that a credit memo is created when you remove a contract line from the service contract under certain conditions.];
                ApplicationArea=#Service;
                SourceExpr="Automatic Credit Memos" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at kontraktlinjerne skal vises som tekst pÜ fakturaen.;
                           ENU=Specifies you want contract lines to appear as text on the invoice.];
                ApplicationArea=#Service;
                SourceExpr="Contract Lines on Invoice" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kun kan fakturere kontrakten, hvis du har bogfõrt en serviceordre, der er knyttet til kontrakten, efter du sidst fakturerede kontrakten.;
                           ENU=Specifies you can only invoice the contract if you have posted a service order linked to the contract since you last invoiced the contract.];
                ApplicationArea=#Service;
                SourceExpr="Invoice after Service";
                Enabled=InvoiceAfterServiceEnable;
                OnValidate=BEGIN
                             InvoiceafterServiceOnAfterVali;
                           END;
                            }

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
      PrepaidEnable@19025160 : Boolean INDATASET;
      InvoiceAfterServiceEnable@19024761 : Boolean INDATASET;

    LOCAL PROCEDURE ActivateFields@2();
    BEGIN
      PrepaidEnable := (NOT "Invoice after Service" OR Prepaid);
      InvoiceAfterServiceEnable := (NOT Prepaid OR "Invoice after Service");
    END;

    LOCAL PROCEDURE InvoiceafterServiceOnAfterVali@19065496();
    BEGIN
      ActivateFields;
    END;

    LOCAL PROCEDURE PrepaidOnAfterValidate@19004759();
    BEGIN
      ActivateFields;
    END;

    BEGIN
    END.
  }
}

