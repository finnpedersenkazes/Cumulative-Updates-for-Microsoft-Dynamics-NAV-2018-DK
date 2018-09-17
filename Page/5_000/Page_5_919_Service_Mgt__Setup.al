OBJECT Page 5919 Service Mgt. Setup
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Serviceops‘tning;
               ENU=Service Mgt. Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5911;
    PageType=Card;
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 145 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange timer inden svartiden den f›rste automatiske advarsel udsendes om, at svartiden for en serviceordre n‘rmer sig.;
                           ENU=Specifies the number of hours before the response time that the program sends the first warning about the response time approaching for a service order.];
                ApplicationArea=#Service;
                SourceExpr="First Warning Within (Hours)" }

    { 135 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den mailadresse, der bruges til at sende f›rste advarsel om, at svartiden for en serviceordre n‘rmer sig.;
                           ENU=Specifies the email address that will be used to send the first warning about the response time for a service order that is approaching.];
                ApplicationArea=#Service;
                SourceExpr="Send First Warning To" }

    { 147 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange timer inden svartiden den anden automatiske advarsel udsendes om, at svartiden for en serviceordre n‘rmer sig.;
                           ENU=Specifies the number of hours before the response time that the program sends the second warning about the response time approaching for a service order.];
                ApplicationArea=#Service;
                SourceExpr="Second Warning Within (Hours)" }

    { 141 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den mailadresse, der bruges til at sende anden advarsel om, at svartiden for en serviceordre n‘rmer sig.;
                           ENU=Specifies the email address that will be used to send the second warning about the response time for a service order that is approaching.];
                ApplicationArea=#Service;
                SourceExpr="Send Second Warning To" }

    { 149 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange timer inden svartiden den tredje automatiske advarsel udsendes om, at svartiden for en serviceordre n‘rmer sig.;
                           ENU=Specifies the number of hours before the response time that the program sends the third warning about the response time approaching for a service order.];
                ApplicationArea=#Service;
                SourceExpr="Third Warning Within (Hours)" }

    { 143 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den mailadresse, der bruges til at sende tredje advarsel om, at svartiden for en serviceordre n‘rmer sig.;
                           ENU=Specifies the email address that will be used to send the third warning about the response time for a service order that is approaching.];
                ApplicationArea=#Service;
                SourceExpr="Send Third Warning To" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det ansvarsomr†de, der er angivet for funktionalitetsomr†det i modulet Service.;
                           ENU=Specifies the code of the job responsibility designated for the service management application area.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Job Responsibility Code" }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan den n‘ste planlagte servicedato for serviceartikler i servicekontrakter automatisk skal genberegnes.;
                           ENU=Specifies how you want the program to recalculate the next planned service date for service items in service contracts.];
                ApplicationArea=#Service;
                SourceExpr="Next Service Calc. Method" }

    { 137 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for et startgebyr p† serviceordrer.;
                           ENU=Specifies the code for a service order starting fee.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Starting Fee" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at hvis du bogf›rer en manuelt oprettet faktura, oprettes der en bogf›rt leverance ud over en bogf›rt faktura.;
                           ENU=Specifies that if you post a manually-created invoice, this will create a posted shipment, in addition to a posted invoice.];
                ApplicationArea=#Service;
                SourceExpr="Shipment on Invoice" }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kun kan angive ‚n serviceartikellinje for hver serviceordre.;
                           ENU=Specifies that you can enter only one service item line for each service order.];
                ApplicationArea=#Service;
                SourceExpr="One Service Item Line/Order" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at servicelinjerne for ressourcer og varer skal knyttes til en serviceartikellinje.;
                           ENU=Specifies that service lines for resources and items must be linked to a service item line.];
                ApplicationArea=#Service;
                SourceExpr="Link Service to Service Item" }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan ressourcekvalifikationer identificeres i virksomheden, n†r du allokerer ressourcer til serviceartikler.;
                           ENU=Specifies how to identify resource skills in your company when you allocate resources to service items.];
                ApplicationArea=#Service;
                SourceExpr="Resource Skills Option" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan servicezoner identificeres i virksomheden, n†r du allokerer ressourcer til serviceartikler.;
                           ENU=Specifies how to identify service zones in your company when you allocate resources to service items.];
                ApplicationArea=#Service;
                SourceExpr="Service Zones Option" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det fejlrapporteringsniveau, som din virksomheden benytter i funktionalitetsomr†det i modulet Service.;
                           ENU=Specifies the level of fault reporting that your company uses in the Service Management application area.];
                ApplicationArea=#Service;
                SourceExpr="Fault Reporting Level" }

    { 7   ;2   ;Field     ;
                DrillDown=Yes;
                ToolTipML=[DAN=Angiver en redigerbar kalender for serviceplanl‘gning, der indeholder serviceafdelingens arbejdsdage og fridage.;
                           ENU=Specifies a customizable calendar for service planning that holds the service department's working days and holidays.];
                ApplicationArea=#Service;
                SourceExpr="Base Calendar Code";
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              TESTFIELD("Base Calendar Code");
                              CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."Source Type"::Service,'','',"Base Calendar Code");
                            END;
                             }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bem‘rkninger skal kopieres fra serviceordrer til servicefakturaer.;
                           ENU=Specifies whether to copy comments from service orders to service invoices.];
                ApplicationArea=#Service;
                SourceExpr="Copy Comments Order to Invoice" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bem‘rkninger skal kopieres fra serviceordrer til serviceleverancer.;
                           ENU=Specifies whether to copy comments from service orders to shipments.];
                ApplicationArea=#Service;
                SourceExpr="Copy Comments Order to Shpt." }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen af virksomhedens logo p† breve og dokumenter, f.eks. servicefakturaer og serviceleverancer.;
                           ENU=Specifies the position of your company logo on your business letters and documents, such as service invoices and service shipments.];
                ApplicationArea=#Service;
                SourceExpr="Logo Position on Documents" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om godkendte timeseddellinjer kopieres til den relaterede serviceordre. Mark‚r dette felt for at v‘re sikker p†, at det tidsforbrug, der er registreret p† godkendte timeseddellinjer, bogf›res med den relaterede serviceordre.;
                           ENU=Specifies if approved time sheet lines are copied to the related service order. Select this field to make sure that time usage registered on approved time sheet lines is posted with the related service order.];
                ApplicationArea=#Service;
                SourceExpr="Copy Time Sheet to Order" }

    { 1904867001;1;Group  ;
                CaptionML=[DAN=Obligatoriske felter;
                           ENU=Mandatory Fields] }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en serviceordre skal have tildelt en serviceordretype, inden serviceordren kan bogf›res.;
                           ENU=Specifies that a service order must have a service order type assigned before the order can be posted.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Type Mandatory" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at felterne Startdato og Starttidspunkt p† en serviceordre skal udfyldes, inden du kan bogf›re serviceordren.;
                           ENU=Specifies that the Starting Date and Starting Time fields on a service order must be filled in before you can post the service order.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Start Mandatory" }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at felterne Slutdato og Sluttidspunkt p† en serviceordre skal udfyldes, inden du kan bogf›re serviceordren.;
                           ENU=Specifies that the Finishing Date and Finishing Time fields on a service order must be filled in before you can post the service order.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Finish Mandatory" }

    { 93  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at feltet Svartid (timer) p† servicekontraktlinjerne skal udfyldes, inden et tilbud kan konverteres til en kontrakt.;
                           ENU=Specifies that the Response Time (Hours) field must be filled on service contract lines before you can convert a quote to a contract.];
                ApplicationArea=#Service;
                SourceExpr="Contract Rsp. Time Mandatory" }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du skal v‘lge en enhed for alle operationer, der behandler serviceartikler.;
                           ENU=Specifies if you must select a unit of measure for all operations that deal with service items.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Mandatory" }

    { 113 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at feltet Fejl†rsagskode skal udfyldes, f›r du kan bogf›re serviceordren.;
                           ENU=Specifies that the Fault Reason Code field must be filled in before you can post the service order.];
                ApplicationArea=#Service;
                SourceExpr="Fault Reason Code Mandatory" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at feltet Arbejdstypekode med typen Ressource skal udfyldes, f›r du kan bogf›re linjen.;
                           ENU=Specifies that the Work Type Code field with type Resource must be filled in before you can post the line.];
                ApplicationArea=#Service;
                SourceExpr="Work Type Code Mandatory" }

    { 155 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du skal udfylde feltet S‘lgerkode i hoveder p† serviceordrer, fakturaer, kreditnotaer og servicekontrakter.;
                           ENU=Specifies that you must fill in the Salesperson Code field on the headers of service orders, invoices, credit memos, and service contracts.];
                ApplicationArea=#Service;
                SourceExpr="Salesperson Mandatory" }

    { 1902985101;1;Group  ;
                CaptionML=[DAN=Standardindstillinger;
                           ENU=Defaults] }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardsvartiden i timer, som det kr‘ver for at p†begynde en service, p† en serviceordre eller en serviceartikellinje.;
                           ENU=Specifies the default response time, in hours, required to start service, either on a service order or on a service item line.];
                ApplicationArea=#Service;
                SourceExpr="Default Response Time (Hours)" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardgarantirabatprocenten p† reservedele.;
                           ENU=Specifies the default warranty discount percentage on spare parts.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Disc. % (Parts)" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardgarantirabatprocenten p† arbejde.;
                           ENU=Specifies the default warranty discount percentage on labor.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Disc. % (Labor)" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardvarigheden for garantirabatter p† serviceartikler.;
                           ENU=Specifies the default duration for warranty discounts on service items.];
                ApplicationArea=#Service;
                SourceExpr="Default Warranty Duration" }

    { 1902001801;1;Group  ;
                CaptionML=[DAN=Kontrakter;
                           ENU=Contracts] }

    { 77  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimale antal dage, du kan bruge som datointerval, hver gang du udf›rer k›rslen Opret kontraktserviceordrer.;
                           ENU=Specifies the maximum number of days you can use as the date range each time you run the Create Contract Service Orders batch job.];
                ApplicationArea=#Service;
                SourceExpr="Contract Serv. Ord.  Max. Days" }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at en †rsagskode er angivet, n†r du annullerer en servicekontrakt.;
                           ENU=Specifies that a reason code is entered when you cancel a service contract.];
                ApplicationArea=#Service;
                SourceExpr="Use Contract Cancel Reason" }

    { 103 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at ‘ndringer af servicekontrakter automatisk skal registreres i tabellen Kontrakt‘ndringslog.;
                           ENU=Specifies that you want the program to log changes to service contracts in the Contract Change Log table.];
                ApplicationArea=#Service;
                SourceExpr="Register Contract Changes" }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den standardtekst, som inds‘ttes i feltet Beskrivelse p† linjen i en kontraktfaktura.;
                           ENU=Specifies the code for the standard text entered in the Description field on the line in a contract invoice.];
                ApplicationArea=#Service;
                SourceExpr="Contract Inv. Line Text Code" }

    { 127 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den standardtekst, som inds‘ttes i feltet Beskrivelse p† linjen i en kontraktfaktura.;
                           ENU=Specifies the code for the standard text entered in the Description field on the line in a contract invoice.];
                ApplicationArea=#Service;
                SourceExpr="Contract Line Inv. Text Code" }

    { 133 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den standardtekst, som inds‘ttes i feltet Beskrivelse p† linjen i en kontraktfaktura.;
                           ENU=Specifies the code for the standard text entered in the Description field on the line in a contract invoice.];
                ApplicationArea=#Service;
                SourceExpr="Contract Inv. Period Text Code" }

    { 123 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den standardtekst, som inds‘ttes i feltet Beskrivelse p† linjen i en kontraktkreditnota.;
                           ENU=Specifies the code for the standard text that entered in the Description field on the line in a contract credit memo.];
                ApplicationArea=#Service;
                SourceExpr="Contract Credit Line Text Code" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den metode, som skal bruges til beregning af standardkontraktv‘rdien for serviceartikler, n†r de oprettes.;
                           ENU=Specifies the method to use for calculating the default contract value of service items when they are created.];
                ApplicationArea=#Service;
                SourceExpr="Contract Value Calc. Method" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel, som bruges til beregning af standardkontraktv‘rdien for en serviceartikel, n†r den oprettes.;
                           ENU=Specifies the percentage used to calculate the default contract value of a service item when it is created.];
                ApplicationArea=#Service;
                SourceExpr="Contract Value %" }

    { 1904569201;1;Group  ;
                CaptionML=[DAN=Nummerering;
                           ENU=Numbering] }

    { 95  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til serviceartikler.;
                           ENU=Specifies the number series code that will be used to assign numbers to service items.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Nos." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummerserien for servicetilbuddet.;
                           ENU=Specifies the number series for the service quotes.];
                ApplicationArea=#Service;
                SourceExpr="Service Quote Nos." }

    { 79  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til serviceordrer.;
                           ENU=Specifies the number series code that will be used to assign numbers to service orders.];
                ApplicationArea=#Service;
                SourceExpr="Service Order Nos." }

    { 117 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til fakturaer.;
                           ENU=Specifies the number series code that will be used to assign numbers to invoices.];
                ApplicationArea=#Service;
                SourceExpr="Service Invoice Nos." }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til servicefakturaer, n†r de bogf›res.;
                           ENU=Specifies the number series code that will be used to assign numbers to service invoices when they are posted.];
                ApplicationArea=#Service;
                SourceExpr="Posted Service Invoice Nos." }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til kreditnotaer.;
                           ENU=Specifies the number series code used to assign numbers to service credit memos.];
                ApplicationArea=#Service;
                SourceExpr="Service Credit Memo Nos." }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til servicekreditnotaer, n†r de bogf›res.;
                           ENU=Specifies the number series code that will be used to assign numbers to service credit memos when they are posted.];
                ApplicationArea=#Service;
                SourceExpr="Posted Serv. Credit Memo Nos." }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til leverancer, n†r de bogf›res.;
                           ENU=Specifies the number series code that will be used to assign numbers to shipments when they are posted.];
                ApplicationArea=#Service;
                SourceExpr="Posted Service Shipment Nos." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til udl†nsvarer.;
                           ENU=Specifies the number series code that will be used to assign numbers to loaners.];
                ApplicationArea=#Service;
                SourceExpr="Loaner Nos." }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til fejlfindingsretningslinjer.;
                           ENU=Specifies the number series code that will be used to assign numbers to troubleshooting guidelines.];
                ApplicationArea=#Service;
                SourceExpr="Troubleshooting Nos." }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til servicekontrakter.;
                           ENU=Specifies the number series code that will be used to assign numbers to service contracts.];
                ApplicationArea=#Service;
                SourceExpr="Service Contract Nos." }

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til kontraktskabeloner.;
                           ENU=Specifies the number series code that will be used to assign numbers to contract templates.];
                ApplicationArea=#Service;
                SourceExpr="Contract Template Nos." }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til fakturaer, der er oprettet til servicekontrakter.;
                           ENU=Specifies the number series code that will be used to assign numbers to invoices created for service contracts.];
                ApplicationArea=#Service;
                SourceExpr="Contract Invoice Nos." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til kreditnotaer for servicekontrakter.;
                           ENU=Specifies the number series code that will be used to assign numbers to credit memos for service contracts.];
                ApplicationArea=#Service;
                SourceExpr="Contract Credit Memo Nos." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele et bilagsnummer til kladdelinjer.;
                           ENU=Specifies the number series code that will be used to assign a document number to the journal lines.];
                ApplicationArea=#Service;
                SourceExpr="Prepaid Posting Document Nos." }

    { 1903305101;1;Group  ;
                CaptionML=[DAN=OIOUBL;
                           ENU=OIOUBL] }

    { 1101100002;2;Group  ;
                CaptionML=[DAN=Outputstier;
                           ENU=Output Paths] }

    { 1101100000;3;Field  ;
                CaptionML=[DAN=Servicefakturasti;
                           ENU=Service Invoice Path];
                ToolTipML=[DAN=Angiver stien til og navnet p† den mappe, hvor du vil gemme filer for elektroniske fakturaer.;
                           ENU=Specifies the path and name of the folder where you want to store the files for electronic invoices.];
                ApplicationArea=#Service;
                SourceExpr="OIOUBL Service Invoice Path" }

    { 1101100003;3;Field  ;
                CaptionML=[DAN=Servicekreditnotasti;
                           ENU=Service Cr. Memo Path];
                ToolTipML=[DAN=Angiver stien til og navnet p† den mappe, hvor du vil gemme filer for elektroniske kreditnotaer.;
                           ENU=Specifies the path and name of the folder where you want to store the files for electronic credit memos.];
                ApplicationArea=#Service;
                SourceExpr="OIOUBL Service Cr. Memo Path" }

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
      CustomizedCalEntry@1000 : Record 7603;
      CalendarMgmt@1001 : Codeunit 7600;

    BEGIN
    END.
  }
}

