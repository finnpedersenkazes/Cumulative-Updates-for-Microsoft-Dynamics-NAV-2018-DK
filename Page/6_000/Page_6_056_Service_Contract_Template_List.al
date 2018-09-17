OBJECT Page 6056 Service Contract Template List
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
    CaptionML=[DAN=Skabelon til serv.kontrakt - oversigt;
               ENU=Service Contract Template List];
    SourceTable=Table5968;
    PageType=List;
    CardPageID=Service Contract Template;
    OnInit=BEGIN
             CurrPage.LOOKUPMODE := TRUE;
           END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 6       ;1   ;ActionGroup;
                      CaptionML=[DAN=K&ontrakt;
                                 ENU=&Contract];
                      Image=Agreement }
      { 21      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5968),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=Servicera&batter;
                                 ENU=Service Dis&counts];
                      ToolTipML=[DAN=Vis eller rediger de rabatter, som du giver i kontrakten p† reservedele (specielt serviceartikelgrupper), rabatterne p† ressourcetidsforbrug (specielt ressourcegrupper) og rabatterne p† bestemte serviceomkostninger.;
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af servicekontrakten.;
                           ENU=Specifies a description of the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at servicekontrakten er forudbetalt.;
                           ENU=Specifies that this service contract is prepaid.];
                ApplicationArea=#Service;
                SourceExpr=Prepaid }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der er knyttet til servicekontraktkontogruppen.;
                           ENU=Specifies the code associated with the service contract account group.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Contract Acc. Gr. Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fakturaperioden for servicekontrakten.;
                           ENU=Specifies the invoice period for the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Invoice Period" }

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

    BEGIN
    END.
  }
}

