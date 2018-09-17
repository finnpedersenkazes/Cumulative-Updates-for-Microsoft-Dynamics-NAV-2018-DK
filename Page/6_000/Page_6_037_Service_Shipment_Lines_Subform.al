OBJECT Page 6037 Service Shipment Lines Subform
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
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    SaveValues=Yes;
    LinksAllowed=No;
    SourceTable=Table5991;
    PageType=ListPart;
    OnAfterGetRecord=BEGIN
                       StyleIsStrong := IsFirstDocLine;
                       DocumentNoHideValue := NOT IsFirstDocLine;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver nummeret p† leverancen.;
                           ENU=Specifies the number of this shipment.];
                ApplicationArea=#Service;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som ejer varerne p† serviceordren.;
                           ENU=Specifies the number of the customer who owns the items on the service order.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for leverancelinjen.;
                           ENU=Specifies the type of this shipment line.];
                ApplicationArea=#Service;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen p† leverancelinjen er en katalogvare.;
                           ENU=Specifies that the item on the shipment line is a nonstock item.];
                ApplicationArea=#Service;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af en vare, ressource, omkostning eller standardtekst p† servicelinjen.;
                           ENU=Specifies the description of an item, resource, cost, or a standard text on the service line.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Service;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                Lookup=No;
                DrillDown=No;
                ToolTipML=[DAN=Angiver valutakoden for de forskellige bel›b p† leverancen.;
                           ENU=Specifies the currency code for various amounts on the shipment.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, eksempelvis lagersted eller distributionscenter, som varerne p† linjen skal tages fra, og hvor de skal registreres.;
                           ENU=Specifies the location, such as warehouse or distribution center, from which the items should be taken and where they should be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, hvor varerne plukkes eller l‘gges p† lager.;
                           ENU=Specifies the bin where the items are picked or put away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder, ressourcetimer, finanskontobetalinger eller omkostninger, der er leveret til debitoren.;
                           ENU=Specifies the number of item units, resource hours, general ledger account payments, or cost that have been shipped to the customer.];
                ApplicationArea=#Service;
                SourceExpr=Quantity }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Service;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p† linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Line Discount %" }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, n†r fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Service;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      TempServShptLine@1002 : TEMPORARY Record 5991;
      StyleIsStrong@1000 : Boolean INDATASET;
      DocumentNoHideValue@1001 : Boolean INDATASET;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    VAR
      ServShptLine@1000 : Record 5991;
    BEGIN
      TempServShptLine.RESET;
      TempServShptLine.COPYFILTERS(Rec);
      TempServShptLine.SETRANGE("Document No.","Document No.");
      IF NOT TempServShptLine.FINDFIRST THEN BEGIN
        ServShptLine.COPYFILTERS(Rec);
        ServShptLine.SETRANGE("Document No.","Document No.");
        IF NOT ServShptLine.FINDFIRST THEN
          EXIT(FALSE);
        TempServShptLine := ServShptLine;
        TempServShptLine.INSERT;
      END;
      IF "Line No." = TempServShptLine."Line No." THEN
        EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

