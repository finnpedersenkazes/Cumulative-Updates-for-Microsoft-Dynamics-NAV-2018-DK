OBJECT Page 6064 Contract Gain/Loss Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Gevinst-/tabsposter - kontrakt;
               ENU=Contract Gain/Loss Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5969;
    DataCaptionFields=Contract No.;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kontraktnummer, der er knyttet til gevinst- eller tabsposten for kontrakten.;
                           ENU=Specifies the contract number linked to this contract gain/loss entry.];
                ApplicationArea=#Service;
                SourceExpr="Contract No.";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontraktgruppekode, der er knyttet til gevinst- eller tabsposten for kontrakten.;
                           ENU=Specifies the contract group code linked to this contract gain/loss entry.];
                ApplicationArea=#Service;
                SourceExpr="Contract Group Code";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ‘ndringen af servicekontrakten blev foretaget.;
                           ENU=Specifies the date when the change on the service contract occurred.];
                ApplicationArea=#Service;
                SourceExpr="Change Date";
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode for ansvarscenteret (f.eks. et distributionscenter), som er tildelt den involverede bruger, virksomhed, debitor eller kreditor.;
                           ENU=Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsibility Center" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Service;
                SourceExpr="User ID";
                Visible=FALSE;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Service;
                SourceExpr="Reason Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen af ‘ndring i servicekontrakten.;
                           ENU=Specifies the type of change on the service contract.];
                ApplicationArea=#Service;
                SourceExpr="Type of Change";
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det debitornummer, der er knyttet til gevinst- eller tabsposten for kontrakten.;
                           ENU=Specifies the customer number that is linked to this contract gain/loss entry.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code";
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver ‘ndringen af det †rlige bel›b i servicekontrakten.;
                           ENU=Specifies the change in annual amount on the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Amount;
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

    BEGIN
    END.
  }
}

