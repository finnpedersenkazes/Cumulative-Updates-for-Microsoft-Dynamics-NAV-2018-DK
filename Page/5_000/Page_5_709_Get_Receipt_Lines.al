OBJECT Page 5709 Get Receipt Lines
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
    CaptionML=[DAN=Hent kõbsleverancelinjer;
               ENU=Get Receipt Lines];
    SourceTable=Table121;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       DocumentNoHideValue := FALSE;
                       DocumentNoOnFormat;
                     END;

    OnQueryClosePage=BEGIN
                       IF CloseAction IN [ACTION::OK,ACTION::LookupOK] THEN
                         CreateLines;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 45      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 46      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=èbn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 PurchRcptHeader.GET("Document No.");
                                 PAGE.RUN(PAGE::"Posted Purchase Receipt",PurchRcptHeader);
                               END;
                                }
      { 47      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Vare&sporingsposter;
                                 ENU=Item &Tracking Entries];
                      ToolTipML=[DAN=Vis serie- eller lotnumre, der er tildelt til varer.;
                                 ENU=View serial or lot numbers that are assigned to items.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLedger;
                      OnAction=BEGIN
                                 ShowItemTrackingLines;
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

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det relaterede bilag.;
                           ENU=Specifies the number of the related document.];
                ApplicationArea=#Suite;
                SourceExpr="Document No.";
                HideValue=DocumentNoHideValue;
                StyleExpr='Strong' }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Suite;
                SourceExpr="Buy-from Vendor No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#Suite;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Suite;
                SourceExpr="No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af de bogfõrte ekstra linjer.;
                           ENU=Specifies a description of additional receipts posted.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 29  ;2   ;Field     ;
                Lookup=No;
                DrillDown=No;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for den lokation, hvor varerne skal placeres efter modtagelse.;
                           ENU=Specifies a code for the location where you want the items to be placed when they are received.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen mÜles, f.eks. i enheder eller timer. Som standard indsëttes vërdien i feltet Basisenhed pÜ vare- eller ressourcekortet.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Suite;
                SourceExpr="Unit of Measure Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Suite;
                SourceExpr="Unit of Measure";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den varepost, som dette dokument eller denne kladdelinje udlignes pÜ.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#Suite;
                SourceExpr="Appl.-to Item Entry";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af varen pÜ linjen.;
                           ENU=Specifies the quantity of the item on the line.];
                ApplicationArea=#Suite;
                SourceExpr=Quantity }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order No.";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den dato, hvor du forventer, at varerne er tilgëngelige pÜ lageret. Hvis du lader feltet vëre tomt, bliver det beregnet pÜ fõlgende mÜde: Planlagt modtagelsesdato + Sikkerhedstid + IndgÜende lagerekspeditionstid = Forventet modtagelsesdato.";
                           ENU="Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date."];
                ApplicationArea=#Suite;
                SourceExpr="Expected Receipt Date";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af den pÜgëldende vare der allerede er blevet bogfõrt som faktureret.;
                           ENU=Specifies how many units of the item on the line have been posted as invoiced.];
                ApplicationArea=#Suite;
                SourceExpr="Quantity Invoiced" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den modtagne vare, der er bogfõrt som modtaget, men som endnu ikke er bogfõrt som faktureret.;
                           ENU=Specifies the quantity of the received item that has been posted as received but that has not yet been posted as invoiced.];
                ApplicationArea=#Suite;
                SourceExpr="Qty. Rcd. Not Invoiced" }

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
      PurchHeader@1000 : Record 38;
      PurchRcptHeader@1001 : Record 120;
      TempPurchRcptLine@1002 : TEMPORARY Record 121;
      GetReceipts@1003 : Codeunit 74;
      DocumentNoHideValue@19020538 : Boolean INDATASET;

    [External]
    PROCEDURE SetPurchHeader@1(VAR PurchHeader2@1000 : Record 38);
    BEGIN
      PurchHeader.GET(PurchHeader2."Document Type",PurchHeader2."No.");
      PurchHeader.TESTFIELD("Document Type",PurchHeader."Document Type"::Invoice);
    END;

    LOCAL PROCEDURE IsFirstDocLine@2() : Boolean;
    VAR
      PurchRcptLine@1000 : Record 121;
    BEGIN
      TempPurchRcptLine.RESET;
      TempPurchRcptLine.COPYFILTERS(Rec);
      TempPurchRcptLine.SETRANGE("Document No.","Document No.");
      IF NOT TempPurchRcptLine.FINDFIRST THEN BEGIN
        PurchRcptLine.COPYFILTERS(Rec);
        PurchRcptLine.SETRANGE("Document No.","Document No.");
        PurchRcptLine.SETFILTER("Qty. Rcd. Not Invoiced",'<>0');
        IF PurchRcptLine.FINDFIRST THEN BEGIN
          TempPurchRcptLine := PurchRcptLine;
          TempPurchRcptLine.INSERT;
        END;
      END;
      IF "Line No." = TempPurchRcptLine."Line No." THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateLines@19031339();
    BEGIN
      CurrPage.SETSELECTIONFILTER(Rec);
      GetReceipts.SetPurchHeader(PurchHeader);
      GetReceipts.CreateInvLines(Rec);
    END;

    LOCAL PROCEDURE DocumentNoOnFormat@19001080();
    BEGIN
      IF NOT IsFirstDocLine THEN
        DocumentNoHideValue := TRUE;
    END;

    BEGIN
    END.
  }
}

