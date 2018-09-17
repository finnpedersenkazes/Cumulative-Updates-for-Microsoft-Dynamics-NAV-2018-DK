OBJECT Page 6039 Service Cr. Memo Lines Subform
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
    LinksAllowed=No;
    SourceTable=Table5995;
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
                ToolTipML=[DAN=Angiver nummeret p† kreditnotaen.;
                           ENU=Specifies the number of the credit memo.];
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
                ToolTipML=[DAN=Angiver nummeret p† den debitor, der skal modtage servicen p† kreditnotaen.;
                           ENU=Specifies the number of the customer to receive the service on the credit memo.];
                ApplicationArea=#Service;
                SourceExpr="Customer No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for kreditnotalinjen.;
                           ENU=Specifies the type of the credit memo line.];
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

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at varen p† kreditnotalinjen er en katalogvare.;
                           ENU=Specifies that the item on the credit memo line is a nonstock item.];
                ApplicationArea=#Dimensions;
                SourceExpr=Nonstock;
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† en vare, ressource, omkostning, finanskonto eller en vilk†rlig beskrivende tekst p† servicekreditnotalinjen.;
                           ENU=Specifies the name of an item, resource, cost, general ledger account, or some descriptive text on the service credit memo line.];
                ApplicationArea=#Dimensions;
                SourceExpr=Description }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kode, der forklarer, hvorfor varen blev returneret.;
                           ENU=Specifies the code explaining why the item was returned.];
                ApplicationArea=#Dimensions;
                SourceExpr="Return Reason Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationen, eksempelvis lagerstedet eller distributionscenteret, hvor kreditnotalinjen blev registreret.;
                           ENU=Specifies the location, such as warehouse or distribution center, in which the credit memo line was registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
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

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af vareenheder, ressourcetimer, finanskontobetalinger eller omkostninger, der er angivet p† kreditnotalinjen.;
                           ENU=Specifies the number of item units, resource hours, general ledger account payments, or cost specified on the credit memo line.];
                ApplicationArea=#Service;
                SourceExpr=Quantity }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Service;
                SourceExpr="Unit Cost (LCY)";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p† linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Service;
                BlankZero=Yes;
                SourceExpr="Line Discount %" }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel›b, der ydes p† varen, p† linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Service;
                SourceExpr="Line Discount Amount";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, n†r fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Service;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede beregnede fakturarabatbel›b for linjen.;
                           ENU=Specifies the total calculated invoice discount amount for the line.];
                ApplicationArea=#Service;
                SourceExpr="Inv. Discount Amount";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontrakt, som er knyttet til den bogf›rte servicekreditnota.;
                           ENU=Specifies the number of the contract associated with the posted service credit memo.];
                ApplicationArea=#Service;
                SourceExpr="Contract No.";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den bogf›rte leverance for kreditnotalinjen.;
                           ENU=Specifies the number of the posted shipment for this credit memo line.];
                ApplicationArea=#Service;
                SourceExpr="Shipment No.";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceartikel, der er knyttet til kreditnotalinjen.;
                           ENU=Specifies the number of the service item linked to this credit memo line.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No.";
                Visible=FALSE }

    { 66  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den servicepost, der er udlignet med servicekreditnotaen.;
                           ENU=Specifies the number of the service ledger entry applied to this service credit memo.];
                ApplicationArea=#Service;
                SourceExpr="Appl.-to Service Entry";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af den varepost, som dette bilag eller denne kladdelinje udlignes fra.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied from.];
                ApplicationArea=#Service;
                SourceExpr="Appl.-from Item Entry";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      TempServCrMemoLine@1002 : TEMPORARY Record 5995;
      StyleIsStrong@1000 : Boolean INDATASET;
      DocumentNoHideValue@1001 : Boolean INDATASET;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    VAR
      ServCrMemoLine@1000 : Record 5995;
    BEGIN
      TempServCrMemoLine.RESET;
      TempServCrMemoLine.COPYFILTERS(Rec);
      TempServCrMemoLine.SETRANGE("Document No.","Document No.");
      IF NOT TempServCrMemoLine.FINDFIRST THEN BEGIN
        ServCrMemoLine.COPYFILTERS(Rec);
        ServCrMemoLine.SETRANGE("Document No.","Document No.");
        IF NOT ServCrMemoLine.FINDFIRST THEN
          EXIT(FALSE);
        TempServCrMemoLine := ServCrMemoLine;
        TempServCrMemoLine.INSERT;
      END;
      EXIT("Line No." = TempServCrMemoLine."Line No.");
    END;

    BEGIN
    END.
  }
}

