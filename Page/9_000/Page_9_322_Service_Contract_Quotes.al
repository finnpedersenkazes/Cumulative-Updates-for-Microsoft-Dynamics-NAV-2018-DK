OBJECT Page 9322 Service Contract Quotes
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
    CaptionML=[DAN=Servicekontrakttilbud;
               ENU=Service Contract Quotes];
    SourceTable=Table5965;
    SourceTableView=WHERE(Contract Type=CONST(Quote));
    PageType=List;
    CardPageID=Service Contract Quote;
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601018;1 ;ActionGroup;
                      CaptionML=[DAN=&Tilbud;
                                 ENU=&Quote];
                      Image=Quote }
      { 1102601020;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 1102601021;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Service Contract),
                                  Table Subtype=FIELD(Contract Type),
                                  No.=FIELD(Contract No.),
                                  Table Line No.=CONST(0);
                      Image=ViewComments }
      { 1102601022;2 ;Action    ;
                      CaptionML=[DAN=Servicera&batter;
                                 ENU=Service Dis&counts];
                      ToolTipML=[DAN=Vis eller rediger de rabatter, som du giver i kontrakten p† reservedele (specielt serviceartikelgrupper), rabatterne p† ressourcetidsforbrug (specielt ressourcegrupper) og rabatterne p† bestemte serviceomkostninger.;
                                 ENU=View or edit the discounts that you grant for the contract on spare parts in particular service item groups, the discounts on resource hours for resources in particular resource groups, and the discounts on particular service costs.];
                      ApplicationArea=#Service;
                      RunObject=Page 6058;
                      RunPageLink=Contract Type=FIELD(Contract Type),
                                  Contract No.=FIELD(Contract No.);
                      Image=Discount }
      { 1102601023;2 ;Action    ;
                      CaptionML=[DAN=Serv.&†bn.tider;
                                 ENU=Service &Hours];
                      ToolTipML=[DAN=Vis de †bningstider, der g‘lder for servicekontrakten. I vinduet vises †bnings- og lukketider for hver dag i henhold til servicekontrakten.;
                                 ENU=View the service hours that are valid for the service contract. This window displays the starting and ending service hours for the contract for each weekday.];
                      ApplicationArea=#Service;
                      RunObject=Page 5916;
                      RunPageLink=Service Contract No.=FIELD(Contract No.),
                                  Service Contract Type=FILTER(Quote);
                      Image=ServiceHours }
      { 1102601025;2 ;Action    ;
                      CaptionML=[DAN=&Arkiv. kontrakttilbud;
                                 ENU=&Filed Contract Quotes];
                      ToolTipML=[DAN=Vis arkiverede kontrakttilbud.;
                                 ENU=View filed contract quotes.];
                      ApplicationArea=#Service;
                      RunObject=Page 6073;
                      RunPageView=SORTING(Contract Type Relation,Contract No. Relation,File Date,File Time)
                                  ORDER(Descending);
                      RunPageLink=Contract Type Relation=FIELD(Contract Type),
                                  Contract No. Relation=FIELD(Contract No.);
                      Image=Quote }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 50      ;1   ;Action    ;
                      CaptionML=[DAN=&Opret kontrakt;
                                 ENU=&Make Contract];
                      ToolTipML=[DAN=G›r dig klar til at oprette en servicekontrakt.;
                                 ENU=Prepare to create a service contract.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=MakeAgreement;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SignServContractDoc@1001 : Codeunit 5944;
                               BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 SignServContractDoc.SignContractQuote(Rec);
                               END;
                                }
      { 51      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G›r dig klar til at udskrive bilaget. Der †bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p† udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DocPrint@1001 : Codeunit 229;
                               BEGIN
                                 DocPrint.PrintServiceContract(Rec);
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

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† servicekontrakten eller servicekontrakttilbuddet.;
                           ENU=Specifies the number of the service contract or service contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for servicekontrakten eller kontrakttilbuddet.;
                           ENU=Specifies the status of the service contract or contract quote.];
                ApplicationArea=#Service;
                SourceExpr=Status }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af servicekontrakten.;
                           ENU=Specifies a description of the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som ejer serviceartiklerne i servicekontrakten/kontrakttilbuddet.;
                           ENU=Specifies the number of the customer who owns the service items in the service contract/contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren i servicekontrakten.;
                           ENU=Specifies the name of the customer in the service contract.];
                ApplicationArea=#Service;
                SourceExpr=Name;
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† debitoren p† den adresse, som varerne leveres til.;
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
                ToolTipML=[DAN=Angiver den dato, hvor servicekontrakten udl›ber.;
                           ENU=Specifies the date when the service contract expires.];
                ApplicationArea=#Service;
                SourceExpr="Expiration Date" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1902018507;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Bill-to Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9082;
                Visible=TRUE;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Service;
                SubPageLink=No.=FIELD(Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9084;
                Visible=TRUE;
                PartType=Page }

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

    BEGIN
    END.
  }
}

