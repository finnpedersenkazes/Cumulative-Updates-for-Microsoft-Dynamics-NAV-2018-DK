OBJECT Page 6065 Customer Service Contracts
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
    CaptionML=[DAN=Debitorservicekontrakter;
               ENU=Customer Service Contracts];
    SourceTable=Table5965;
    SourceTableView=WHERE(Contract Type=FILTER(Contract));
    DataCaptionFields=Customer No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 38      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&ontrakt;
                                 ENU=&Contract];
                      Image=Agreement }
      { 39      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=&Kort;
                                 ENU=&Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om servicekontrakten.;
                                 ENU=View or edit detailed information for the service contract.];
                      ApplicationArea=#Service;
                      RunObject=Page 6050;
                      RunPageLink=Contract Type=FIELD(Contract Type),
                                  Contract No.=FIELD(Contract No.);
                      Image=EditLines }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies the status of the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr=Status }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� servicekontrakten eller servicekontrakttilbuddet.;
                           ENU=Specifies the number of the service contract or service contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af servicekontrakten.;
                           ENU=Specifies a description of the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som ejer serviceartiklerne i servicekontrakten/kontrakttilbuddet.;
                           ENU=Specifies the number of the customer who owns the service items in the service contract/contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� debitoren i servicekontrakten.;
                           ENU=Specifies the name of the customer in the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Name;
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs� i tilf�lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� debitoren p� den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for servicekontrakten.;
                           ENU=Specifies the starting date of the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Starting Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicekontrakten udl�ber.;
                           ENU=Specifies the date when the service contract expires.];
                ApplicationArea=#Service;
                SourceExpr="Expiration Date" }

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

