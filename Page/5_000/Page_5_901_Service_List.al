OBJECT Page 5901 Service List
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
    CaptionML=[DAN=Serviceoversigt;
               ENU=Service List];
    SourceTable=Table5900;
    DataCaptionFields=Document Type,No.;
    PageType=List;
    OnInit=BEGIN
             ResponseTimeVisible := TRUE;
             ResponseDateVisible := TRUE;
           END;

    OnOpenPage=BEGIN
                 IF "Document Type" = "Document Type"::Order THEN BEGIN
                   ResponseDateVisible := TRUE;
                   ResponseTimeVisible := TRUE;
                 END ELSE BEGIN
                   ResponseDateVisible := FALSE;
                   ResponseTimeVisible := FALSE;
                 END;

                 CopyCustomerFilter;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 29      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p�g�ldende record p� bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Service;
                      Image=EditLines;
                      OnAction=VAR
                                 PageManagement@1000 : Codeunit 700;
                               BEGIN
                                 PageManagement.PageRun(Rec);
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

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serviceordrens status, som afspejler reparations- eller vedligeholdelsesstatus for alle serviceartikler i serviceordren.;
                           ENU=Specifies the service order status, which reflects the repair or maintenance status of all service items on the service order.];
                ApplicationArea=#Service;
                SourceExpr=Status }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for servicedokumentet p� linjen.;
                           ENU=Specifies the type of the service document on the line.];
                ApplicationArea=#Service;
                SourceExpr="Document Type" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor ordren blev oprettet.;
                           ENU=Specifies the date when the order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det klokkesl�t, hvor serviceordren blev oprettet.;
                           ENU=Specifies the time when the service order was created.];
                ApplicationArea=#Service;
                SourceExpr="Order Time" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som ejer varerne i servicedokumentet.;
                           ENU=Specifies the number of the customer who owns the items in the service document.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs� i tilf�lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den debitor, som varerne i bilaget skal leveres til.;
                           ENU=Specifies the name of the customer to whom the items on the document will be shipped.];
                ApplicationArea=#Service;
                SourceExpr=Name }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for lokationen (f.eks. lagersted eller distributionscenter) for de varer, der er angivet p� serviceartikellinjerne.;
                           ENU=Specifies the code of the location (for example, warehouse or distribution center) of the items specified on the service item lines.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ansl�ede dato, hvor arbejdet p� ordren skal p�begyndes, dvs. n�r serviceordrens status �ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the estimated date when work on the order should start, that is, when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Response Date";
                Visible=ResponseDateVisible }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det ansl�ede klokkesl�t, hvor arbejdet p� ordren begynder, dvs. n�r serviceordrens status �ndres fra Igangsat til I arbejde.;
                           ENU=Specifies the estimated time when work on the order starts, that is, when the service order status changes from Pending, to In Process.];
                ApplicationArea=#Service;
                SourceExpr="Response Time";
                Visible=ResponseTimeVisible }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prioriteten for serviceordren.;
                           ENU=Specifies the priority of the service order.];
                ApplicationArea=#Service;
                SourceExpr=Priority }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Service;
                SourceExpr="Assigned User ID" }

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
      ResponseDateVisible@19066074 : Boolean INDATASET;
      ResponseTimeVisible@19074545 : Boolean INDATASET;

    BEGIN
    END.
  }
}

