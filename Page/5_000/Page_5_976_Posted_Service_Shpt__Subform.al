OBJECT Page 5976 Posted Service Shpt. Subform
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5989;
    DelayedInsert=Yes;
    PageType=ListPart;
    AutoSplitKey=Yes;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1901741704;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1900206304;2 ;ActionGroup;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      Image=ViewComments }
      { 1902425004;3 ;Action    ;
                      CaptionML=[DAN=Fejl;
                                 ENU=Faults];
                      ToolTipML=[DAN=F† vist eller rediger de forskellige fejlkoder, som du kan tildele til serviceartikler. Du kan bruge fejlkoderne til at identificere de forskellige serviceartikelfejl eller de handlinger, der skal udf›res p† serviceartikler, for hver kombination af fejlomr†der og symptomkoder.;
                                 ENU=View or edit the different fault codes that you can assign to service items. You can use fault codes to identify the different service item faults or the actions taken on service items for each combination of fault area and symptom codes.];
                      ApplicationArea=#Service;
                      Image=Error;
                      OnAction=BEGIN
                                 ShowComments(1);
                               END;
                                }
      { 1906760504;3 ;Action    ;
                      CaptionML=[DAN=L›sninger;
                                 ENU=Resolutions];
                      ToolTipML=[DAN=F† vist eller rediger de forskellige l›sningskoder, som du kan tildele serviceartikler. Du kan bruge l›sningskoder til at identificere de metoder, der bruges til at l›se typiske serviceproblemer.;
                                 ENU=View or edit the different resolution codes that you can assign to service items. You can use resolution codes to identify methods used to solve typical service problems.];
                      ApplicationArea=#Service;
                      Image=Completed;
                      OnAction=BEGIN
                                 ShowComments(2);
                               END;
                                }
      { 1902366404;3 ;Action    ;
                      CaptionML=[DAN=Intern;
                                 ENU=Internal];
                      ToolTipML=[DAN=F† vist eller registr‚r interne bem‘rkninger til serviceartiklen igen. Interne bem‘rkninger er kun til intern brug og udskrives ikke i rapporter.;
                                 ENU=View or reregister internal comments for the service item. Internal comments are for internal use only and are not printed on reports.];
                      ApplicationArea=#Service;
                      Image=Comment;
                      OnAction=BEGIN
                                 ShowComments(4);
                               END;
                                }
      { 1901972304;3 ;Action    ;
                      CaptionML=[DAN=Tilbeh›r;
                                 ENU=Accessories];
                      ToolTipML=[DAN=F† vist eller registr‚r bem‘rkninger til tilbeh›r til serviceartiklen.;
                                 ENU=View or register comments for the accessories to the service item.];
                      ApplicationArea=#Service;
                      Image=ServiceAccessories;
                      OnAction=BEGIN
                                 ShowComments(3);
                               END;
                                }
      { 1906307804;3 ;Action    ;
                      CaptionML=[DAN=Udl†nte varer;
                                 ENU=Lent Loaners];
                      ToolTipML=[DAN=F† vist de udl†nsvarer, der er blevet udl†nt midlertidigt for at erstatte serviceartiklen.;
                                 ENU=View the loaners that have been lend out temporarily to replace the service item.];
                      ApplicationArea=#Service;
                      OnAction=BEGIN
                                 ShowComments(5);
                               END;
                                }
      { 1903841704;2 ;Action    ;
                      CaptionML=[DAN=Serviceartikell&og;
                                 ENU=Service Item &Log];
                      ToolTipML=[DAN=F† vist en liste over de ‘ndringer af serviceartikler, der er blevet registreret, f.eks. hvis garantien er blevet ‘ndret, eller der er tilf›jet en komponent. I dette vindue vises det felt, der er blevet ‘ndret, den gamle v‘rdi og den nye v‘rdi, samt datoen og klokkesl‘ttet for ‘ndringen.;
                                 ENU=View a list of the service item changes that have been logged, for example, when the warranty has changed or a component has been added. This window displays the field that was changed, the old value and the new value, and the date and time that the field was changed.];
                      ApplicationArea=#Service;
                      Image=Log;
                      OnAction=BEGIN
                                 ShowServItemEventLog;
                               END;
                                }
      { 1906587504;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1903098504;2 ;Action    ;
                      CaptionML=[DAN=&Modtag udl†nsvare;
                                 ENU=&Receive Loaner];
                      ToolTipML=[DAN=Registrer, at udl†nsvaren er modtaget p† din virksomhed.;
                                 ENU=Record that the loaner is received at your company.];
                      ApplicationArea=#Service;
                      Image=ReceiveLoaner;
                      OnAction=BEGIN
                                 ReceiveLoaner;
                               END;
                                }
      { 1901820904;1 ;ActionGroup;
                      CaptionML=[DAN=&Leverance;
                                 ENU=&Shipment];
                      Image=Shipment }
      { 1902395304;2 ;Action    ;
                      Name=ServiceShipmentLines;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Serviceleverancelinjer;
                                 ENU=Service Shipment Lines];
                      ToolTipML=[DAN=Vis den relaterede leverancelinje.;
                                 ENU=View the related shipment line.];
                      ApplicationArea=#Service;
                      Image=ShipmentLines;
                      OnAction=BEGIN
                                 ShowServShipmentLines;
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
                ToolTipML=[DAN=Angiver nummeret p† linjen.;
                           ENU=Specifies the number of this line.];
                ApplicationArea=#Service;
                SourceExpr="Line No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† serviceartiklen, som er registreret i tabellen Serviceartikel og knyttet til debitoren.;
                           ENU=Specifies the number of the service item registered in the Service Item table and associated with the customer.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No." }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den gruppe, som er knyttet til serviceartiklen.;
                           ENU=Specifies the code for the group associated with this service item.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Group Code" }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs† i tilf‘lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, som denne bogf›rte serviceartikel vedr›rer.;
                           ENU=Specifies the number of the item to which this posted service item is related.];
                ApplicationArea=#Service;
                SourceExpr="Item No." }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p† serviceartiklen.;
                           ENU=Specifies the serial number of this service item.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af den serviceartikel, der er angivet i feltet Serviceartikelnr., p† linjen.;
                           ENU=Specifies a description of the service item specified in the Service Item No. field on this line.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende beskrivelse af serviceartiklen.;
                           ENU=Specifies an additional description of this service item.];
                ApplicationArea=#Service;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der er en fejlbem‘rkning for serviceartiklen.;
                           ENU=Specifies that there is a fault comment for this service item.];
                ApplicationArea=#Service;
                SourceExpr="Fault Comment";
                Visible=FALSE;
                OnDrillDown=BEGIN
                              ShowComments(1);
                            END;
                             }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der er en l›sningsbem‘rkning for serviceartiklen.;
                           ENU=Specifies that there is a resolution comment for this service item.];
                ApplicationArea=#Service;
                SourceExpr="Resolution Comment";
                Visible=FALSE;
                OnDrillDown=BEGIN
                              ShowComments(2);
                            END;
                             }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den placering af serviceartiklen, hvor serviceartiklen opbevares, mens reparationen foreg†r.;
                           ENU=Specifies the number of the service shelf where the service item is stored while it is in the repair shop.];
                ApplicationArea=#Service;
                SourceExpr="Service Shelf No.";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der er garanti p† reservedele eller arbejde for servicerartiklen.;
                           ENU=Specifies that there is a warranty on either parts or labor for this service item.];
                ApplicationArea=#Service;
                SourceExpr=Warranty }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor garantien tr‘der i kraft for reservedele til serviceartiklen.;
                           ENU=Specifies the date when the warranty starts on the service item spare parts.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Starting Date (Parts)";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor reservedelsgarantien udl›ber for serviceartiklen.;
                           ENU=Specifies the date when the spare parts warranty expires for this service item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Ending Date (Parts)";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af reservedelsomkostningerne, der d‘kkes af garantien p† serviceartiklen.;
                           ENU=Specifies the percentage of spare parts costs covered by the warranty for this service item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty % (Parts)";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af arbejdsomkostningerne, der d‘kkes af garantien p† serviceartiklen.;
                           ENU=Specifies the percentage of labor costs covered by the warranty on this service item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty % (Labor)";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor arbejdsgarantien for den bogf›rte serviceartikel tr‘der i kraft.;
                           ENU=Specifies the date when the labor warranty for the posted service item starts.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Starting Date (Labor)";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor arbejdsgarantien udl›ber for den bogf›rte serviceartikel.;
                           ENU=Specifies the date when the labor warranty expires on the posted service item.];
                ApplicationArea=#Service;
                SourceExpr="Warranty Ending Date (Labor)";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontrakt, som er knyttet til den bogf›rte serviceartikel.;
                           ENU=Specifies the number of the contract associated with the posted service item.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den fejl†rsagskode, der er tildelt den bogf›rte serviceartikel.;
                           ENU=Specifies the fault reason code assigned to the posted service item.];
                ApplicationArea=#Service;
                SourceExpr="Fault Reason Code";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den serviceprisgruppe, som er knyttet til serviceartiklen.;
                           ENU=Specifies the code of the service price group associated with this service item.];
                ApplicationArea=#Service;
                SourceExpr="Service Price Group Code";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der identificerer omr†det med den fejl, der er fundet i forbindelse med serviceartiklen.;
                           ENU=Specifies the code that identifies the area of the fault encountered with this service item.];
                ApplicationArea=#Service;
                SourceExpr="Fault Area Code";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der identificerer symptomet p† fejlen i serviceartiklen.;
                           ENU=Specifies the code to identify the symptom of the service item fault.];
                ApplicationArea=#Service;
                SourceExpr="Symptom Code";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der identificerer fejlen i den bogf›rte serviceartikel eller de handlinger, der udf›res med artiklen.;
                           ENU=Specifies the code to identify the fault of the posted service item or the actions taken on the item.];
                ApplicationArea=#Service;
                SourceExpr="Fault Code";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den l›sningskode, der er knyttet til varen.;
                           ENU=Specifies the resolution code assigned to this item.];
                ApplicationArea=#Service;
                SourceExpr="Resolution Code";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serviceprioriteten for den bogf›rte serviceartikel.;
                           ENU=Specifies the service priority for this posted service item.];
                ApplicationArea=#Service;
                SourceExpr=Priority }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det ansl†ede antal timer mellem oprettelsen af serviceordren og det tidspunkt, hvor reparationsstatussen ‘ndres fra Oprettet til I arbejde.;
                           ENU=Specifies the estimated hours between the creation of the service order, to the time when the repair status changes from Initial, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Response Time (Hours)" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ansl†ede dato, hvor servicen p† denne serviceartikel p†begyndes.;
                           ENU=Specifies the estimated date when service starts on this service item.];
                ApplicationArea=#Service;
                SourceExpr="Response Date" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor servicen p† denne serviceartikel forventes at begynde.;
                           ENU=Specifies the time when service is expected to start on this service item.];
                ApplicationArea=#Service;
                SourceExpr="Response Time" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den udl†nsvare, der er l†nt ud til debitoren som erstatning for serviceartiklen.;
                           ENU=Specifies the number of the loaner that has been lent to the customer to replace this service item.];
                ApplicationArea=#Service;
                SourceExpr="Loaner No." }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, der solgte serviceartiklen.;
                           ENU=Specifies the number of the vendor who sold this service item.];
                ApplicationArea=#Service;
                SourceExpr="Vendor No.";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Service;
                SourceExpr="Vendor Item No.";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicen p† denne serviceartikel blev p†begyndt.;
                           ENU=Specifies the date when service on this service item started.];
                ApplicationArea=#Service;
                SourceExpr="Starting Date";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor servicen p† denne serviceartikel blev p†begyndt.;
                           ENU=Specifies the time when service on this service item started.];
                ApplicationArea=#Service;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor servicen p† denne serviceartikel er fuldf›rt.;
                           ENU=Specifies the time when service on this service item is finished.];
                ApplicationArea=#Service;
                SourceExpr="Finishing Date";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl‘t, hvor servicen p† ordren er fuldf›rt.;
                           ENU=Specifies the time when the service on the order is finished.];
                ApplicationArea=#Service;
                SourceExpr="Finishing Time";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      ServLoanerMgt@1000 : Codeunit 5901;
      Text000@1001 : TextConst 'DAN=Du kan kun f† vist serviceartikellogfilen for serviceartikellinjer med det specifikke serviceartikelnr.;ENU=You can view the Service Item Log only for service item lines with the specified Service Item No.';

    LOCAL PROCEDURE ShowServShipmentLines@2();
    VAR
      ServShipmentLine@1000 : Record 5991;
      ServShipmentLines@1001 : Page 5970;
    BEGIN
      TESTFIELD("No.");
      CLEAR(ServShipmentLine);
      ServShipmentLine.SETRANGE("Document No.","No.");
      ServShipmentLine.FILTERGROUP(2);
      CLEAR(ServShipmentLines);
      ServShipmentLines.Initialize("Line No.");
      ServShipmentLines.SETTABLEVIEW(ServShipmentLine);
      ServShipmentLines.RUNMODAL;
      ServShipmentLine.FILTERGROUP(0);
    END;

    [External]
    PROCEDURE ReceiveLoaner@1();
    BEGIN
      ServLoanerMgt.ReceiveLoanerShipment(Rec);
    END;

    LOCAL PROCEDURE ShowServItemEventLog@13();
    VAR
      ServItemLog@1000 : Record 5942;
    BEGIN
      IF "Service Item No." = '' THEN
        ERROR(Text000);
      CLEAR(ServItemLog);
      ServItemLog.SETRANGE("Service Item No.","Service Item No.");
      PAGE.RUNMODAL(PAGE::"Service Item Log",ServItemLog);
    END;

    BEGIN
    END.
  }
}

