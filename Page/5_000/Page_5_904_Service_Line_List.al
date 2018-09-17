OBJECT Page 5904 Service Line List
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
    CaptionML=[DAN=Servicelinjeoversigt;
               ENU=Service Line List];
    SourceTable=Table5902;
    DataCaptionFields=Fault Reason Code;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 85      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 86      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Service;
                      Image=View;
                      OnAction=VAR
                                 PageManagement@1000 : Codeunit 700;
                               BEGIN
                                 IF ServHeader.GET("Document Type","Document No.") THEN
                                   PageManagement.PageRun(ServHeader);
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

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ linjen.;
                           ENU=Specifies the number of the line.];
                ApplicationArea=#Service;
                SourceExpr="Line No." }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor servicelinjen skal bogfõres.;
                           ENU=Specifies the date when the service line should be posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for det servicedokument, der er knyttet til linjen.;
                           ENU=Specifies the type of the service document associated with this line.];
                ApplicationArea=#Service;
                SourceExpr="Document Type" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det serviceordrenummer, der er knyttet til linjen.;
                           ENU=Specifies the service order number associated with this line.];
                ApplicationArea=#Service;
                SourceExpr="Document No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for servicelinjen.;
                           ENU=Specifies the type of the service line.];
                ApplicationArea=#Service;
                SourceExpr=Type }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lagerlokation, som varerne pÜ linjen skal tages fra, og hvor de skal registreres.;
                           ENU=Specifies the inventory location from where the items on the line should be taken and where they should be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, der ejer de varer, der skal repareres ifõlge serviceordren.;
                           ENU=Specifies the number of the customer who owns the items to be serviced under the service order.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Service;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Service;
                SourceExpr="Job Task No.";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kladdelinjetype, der oprettes i tabellen Sagsplanlëgningslinje ud fra linjen.;
                           ENU=Specifies the type of journal line that is created in the Job Planning Line table from this line.];
                ApplicationArea=#Service;
                SourceExpr="Job Line Type";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du krëver, at varen skal vëre tilgëngelig for en serviceordre.;
                           ENU=Specifies the date when you require the item to be available for a service order.];
                ApplicationArea=#Service;
                SourceExpr="Needed by Date" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder, ressourcetimer eller omkostninger pÜ servicelinjen.;
                           ENU=Specifies the number of item units, resource hours, cost on the service line.];
                ApplicationArea=#Service;
                SourceExpr=Quantity }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varer, ressourcetidsforbrug, omkostninger eller finanskontobetalinger anfõrt i basisenheder.;
                           ENU=Specifies the quantity of items, resource time, costs, or general ledger account payments, expressed in base units of measure.];
                ApplicationArea=#Service;
                SourceExpr="Quantity (Base)" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af registrerede varer, ressourcetidsforbrug, omkostninger eller betalinger til finanskontoen, som endnu ikke er leveret.;
                           ENU=Specifies the quantity of registered items, resource time, costs, or payments to the general ledger account that have not been shipped.];
                ApplicationArea=#Service;
                SourceExpr="Outstanding Qty. (Base)" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nettobelõb uden eventuelt fakturarabatbelõb, som skal betales for produkterne pÜ linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Service;
                SourceExpr="Line Amount" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen pÜ linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Service;
                SourceExpr="Line Discount %" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbelõb, der ydes pÜ varen, pÜ linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Service;
                SourceExpr="Line Discount Amount" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for den linjerabat, der er tildelt linjen.;
                           ENU=Specifies the type of the line discount assigned to this line.];
                ApplicationArea=#Service;
                SourceExpr="Line Discount Type" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varen blev anvendt til at erstatte hele serviceartiklen, en af serviceartikelkomponenterne, installeret som en ny komponent eller blot anvendt som et supplerende vërktõj.;
                           ENU=Specifies whether the item was used to replace the whole service item, one of the service item components, installed as a new component, or used as a supplementary tool.];
                ApplicationArea=#Service;
                SourceExpr="Spare Part Action";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fejlÜrsagskoden for servicelinjen.;
                           ENU=Specifies the code of the fault reason for this service line.];
                ApplicationArea=#Service;
                SourceExpr="Fault Reason Code";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at garantirabatten er udelukket pÜ denne linje.;
                           ENU=Specifies that the warranty discount is excluded on this line.];
                ApplicationArea=#Service;
                SourceExpr="Exclude Warranty" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der gives en garantirabat pÜ linjen af typen Vare eller Ressource.;
                           ENU=Specifies that a warranty discount is available on this line of type Item or Resource.];
                ApplicationArea=#Service;
                SourceExpr=Warranty }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kontrakten, hvis serviceordren stammer fra en servicekontrakt.;
                           ENU=Specifies the number of the contract, if the service order originated from a service contract.];
                ApplicationArea=#Service;
                SourceExpr="Contract No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det linjenummer for serviceartiklen, som er knyttet til servicelinjen.;
                           ENU=Specifies the service item line number linked to this service line.];
                ApplicationArea=#Service;
                SourceExpr="Service Item Line No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det serviceartikelnummer, som er knyttet til servicelinjen.;
                           ENU=Specifies the service item number linked to this service line.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No." }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det serienummer for serviceartiklen, som er knyttet til servicelinjen.;
                           ENU=Specifies the service item serial number linked to this line.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Service Item Serial No." }

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
      ServHeader@1000 : Record 5900;

    BEGIN
    END.
  }
}

