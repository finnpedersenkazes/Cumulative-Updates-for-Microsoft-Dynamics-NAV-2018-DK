OBJECT Page 6051 Service Contract List
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
    CaptionML=[DAN=Servicekontraktoversigt;
               ENU=Service Contract List];
    SourceTable=Table5965;
    DataCaptionFields=Contract Type;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 17      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Service;
                      Image=EditLines;
                      OnAction=BEGIN
                                 CASE "Contract Type" OF
                                   "Contract Type"::Quote:
                                     PAGE.RUN(PAGE::"Service Contract Quote",Rec);
                                   "Contract Type"::Contract:
                                     PAGE.RUN(PAGE::"Service Contract",Rec);
                                 END;
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Generelt;
                                 ENU=General];
                      Image=Report }
      { 1900914206;2 ;Action    ;
                      CaptionML=[DAN=Serviceart. - garanti udl›bet;
                                 ENU=Service Items Out of Warranty];
                      ToolTipML=[DAN=Vis oplysninger om garantiudl›bsdatoer, serienumre, antal aktive kontrakter, varebeskrivelse og navne p† debitorer. Du kan udskrive en oversigt over serviceartikler, hvis garanti er udl›bet.;
                                 ENU=View information about warranty end dates, serial numbers, number of active contracts, items description, and names of customers. You can print a list of service items that are out of warranty.];
                      ApplicationArea=#Service;
                      RunObject=Report 5937;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Kontrakt;
                                 ENU=Contract];
                      Image=Report }
      { 1907657006;2 ;Action    ;
                      CaptionML=[DAN=Servicekontrakt - debitor;
                                 ENU=Service Contract-Customer];
                      ToolTipML=[DAN=Vis oplysninger om status, n‘ste faktureringsdato, faktureringsperiode, bel›b pr. periode og †rligt bel›b. Du kan udskrive en liste over servicekontrakter for hver debitor i en valgt tidsperiode.;
                                 ENU=View information about status, next invoice date, invoice period, amount per period, and annual amount. You can print a list of service contracts for each customer in a selected time period.];
                      ApplicationArea=#Service;
                      RunObject=Report 5977;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1901090606;2 ;Action    ;
                      CaptionML=[DAN=Servicekontrakt - s‘lger;
                                 ENU=Service Contract-Salesperson];
                      ToolTipML=[DAN=Vis debitornummer, navn, beskrivelse, startdato og det †rlige bel›b for hver servicekontrakt. Du kan bruge rapporten til beregning og dokumentation af s‘lgerprovision. Du kan udskrive en oversigt over servicekontrakter for hver s‘lger i en udvalgt periode.;
                                 ENU=View customer number, name, description, starting date and the annual amount for each service contract. You can use the report to calculate and document sales commission. You can print a list of service contracts for each salesperson for a selected period.];
                      ApplicationArea=#Service;
                      RunObject=Report 5978;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1904666406;2 ;Action    ;
                      CaptionML=[DAN=Servicekontraktoplysninger;
                                 ENU=Service Contract Details];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om servicekontrakten.;
                                 ENU=View detailed information for the service contract.];
                      ApplicationArea=#Service;
                      RunObject=Report 5971;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1907252806;2 ;Action    ;
                      CaptionML=[DAN=Servicekontraktavancebel›b;
                                 ENU=Service Contract Profit];
                      ToolTipML=[DAN=Vis servicekontraktens avanceoplysninger.;
                                 ENU=View profit information for the service contract.];
                      ApplicationArea=#Service;
                      RunObject=Report 5976;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906775606;2 ;Action    ;
                      CaptionML=[DAN=Servicebes›g - planl‘gning;
                                 ENU=Maintenance Visit - Planning];
                      ToolTipML=[DAN=F† vist servicezonekoden, gruppekoden, kontraktnummeret, kundenummeret, serviceperioden og servicedatoen. Du kan v‘lge at udskrive planen for et eller flere ansvarscentre. Rapporten viser servicedatoerne for alle servicebes›g for de valgte ansvarscentre. Du kan udskrive alle dine planer over servicebes›g.;
                                 ENU=View the service zone code, group code, contract number, customer number, service period, as well as the service date. You can select the schedule for one or more responsibility centers. The report shows the service dates of all the maintenance visits for the chosen responsibility centers. You can print all your schedules for maintenance visits.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5980;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Report }
      { 1900960706;2 ;Action    ;
                      CaptionML=[DAN=Kontrakt, serviceordre - kontrol;
                                 ENU=Contract, Service Order Test];
                      ToolTipML=[DAN=Vis antallet af kontrakter, numre og navne p† kunder samt en r‘kke andre oplysninger om de serviceordrer, der er oprettet for den angivne periode. Du kan teste, hvilke servicekontrakter der omfatter serviceartikler, som er forfaldne til service inden for den angivne periode.;
                                 ENU=View the numbers of contracts, the numbers and the names of customers, as well as some other information relating to the service orders that are created for the period that you have specified. You can test which service contracts include service items that are due for service within the specified period.];
                      ApplicationArea=#Service;
                      RunObject=Report 5988;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903269806;2 ;Action    ;
                      CaptionML=[DAN=Kontraktfaktura - kontrol;
                                 ENU=Contract Invoice Test];
                      ToolTipML=[DAN=Angiver fakturerbare avancer for den sagsopgave, der er relateret til finanskonti.;
                                 ENU=Specifies billable profits for the job task that are related to G/L accounts.];
                      ApplicationArea=#Service;
                      RunObject=Report 5984;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902585006;2 ;Action    ;
                      CaptionML=[DAN=Kontraktsalgsbel›bopd. - kontrol;
                                 ENU=Contract Price Update - Test];
                      ToolTipML=[DAN=Vis kontraktnumrene, debitornumrene, kontraktbel›bene, prisreguleringsprocenterne og de fejl, der evt. opst†r. Du kan teste, hvilke servicekontrakter der har behov for prisreguleringer op til den dato, du har angivet.;
                                 ENU=View the contracts numbers, customer numbers, contract amounts, price update percentages, and any errors that occur. You can test which service contracts need price updates up to the date that you have specified.];
                      ApplicationArea=#Service;
                      RunObject=Report 5985;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
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

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontraktens type.;
                           ENU=Specifies the type of the contract.];
                ApplicationArea=#Service;
                SourceExpr="Contract Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† servicekontrakten eller servicekontrakttilbuddet.;
                           ENU=Specifies the number of the service contract or service contract quote.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

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

