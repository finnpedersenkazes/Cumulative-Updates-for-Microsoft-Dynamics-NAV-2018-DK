OBJECT Page 529 Posted Purchase Invoice Lines
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
    CaptionML=[DAN=Bogf�rte k�bsfakturalinjer;
               ENU=Posted Purchase Invoice Lines];
    SourceTable=Table123;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 71      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 72      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=Show Document];
                      ToolTipML=[DAN=�bn det bilag, hvor den valgte linje findes.;
                                 ENU=Open the document that the selected line exists on.];
                      ApplicationArea=#Basic,#Suite;
                      Image=View;
                      OnAction=BEGIN
                                 PurchInvHeader.GET("Document No.");
                                 PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
                               END;
                                }
      { 73      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 6500    ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=F� vist eller rediger serienummer og lotnumre, der er tildelt varen p� bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
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
                ToolTipML=[DAN=Angiver bilagsnummeret.;
                           ENU=Specifies the document number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Vendor No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� eller en beskrivelse af varen eller finanskontoen.;
                           ENU=Specifies either the name of, or a description of, the item or general ledger account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf�ringstypen, hvis feltet Kontotype indeholder Anl�gsaktiv.;
                           ENU=Specifies the posting type, if Account Type field contains Fixed Asset.];
                ApplicationArea=#Advanced;
                SourceExpr="FA Posting Type" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf�res til, hvis du har valgt Anl�gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#Advanced;
                SourceExpr="Depreciation Book Code" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der er bogf�rt fra linjen.;
                           ENU=Specifies the quantity posted from the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Quantity }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen pr. enhed af den valgte vare eller ressource.;
                           ENU=Specifies the cost of one unit of the selected item or resource.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Unit Cost" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k�bspris, der omfatter indirekte omkostninger, s�som fragt, der er knyttet til k�bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Indirect Cost %" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, i RV, p� �n enhed af varen eller ressourcen p� linjen.;
                           ENU=Specifies the cost, in LCY, of one unit of the item or resource on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost (LCY)" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for �n enhed af varen eller ressourcen i RV. Du kan angive en pris manuelt eller f� den angivet i henhold til feltet Avancepct.beregning p� det dertilh�rende kort.;
                           ENU=Specifies the price, in LCY, of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Price (LCY)" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjens nettobel�b.;
                           ENU=Specifies the line's net amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nettobel�bet inklusive moms for denne linje.;
                           ENU=Specifies the net amount, including VAT, for this line.];
                ApplicationArea=#Advanced;
                SourceExpr="Amount Including VAT" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p� linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Line Discount %" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rabatbel�b, der ydes p� varen, p� linjen.;
                           ENU=Specifies the discount amount that is granted for the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Line Discount Amount" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om fakturalinjen bliver medtaget, n�r fakturarabatten beregnes.;
                           ENU=Specifies if the invoice line is included when the invoice discount is calculated.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc." }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede beregnede fakturarabatbel�b for linjen.;
                           ENU=Specifies the total calculated invoice discount amount for the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inv. Discount Amount" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den varepost, som dette dokument eller denne kladdelinje udlignes p�.;
                           ENU=Specifies the number of the item ledger entry that the document or journal line is applied to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Appl.-to Item Entry" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Advanced;
                SourceExpr="Job No." }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forsikringsnummeret fra k�bsfakturalinjen.;
                           ENU=Specifies the insurance number on the purchase invoice line.];
                ApplicationArea=#Advanced;
                SourceExpr="Insurance No." }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om afskrivningen er beregnet op til linjens anl�gsbogf�ringsdato.;
                           ENU=Specifies if depreciation was calculated until the FA posting date of the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Depr. until FA Posting Date" }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den ekstra anskaffelsespris, der er bogf�rt p� linjen, blev afskrevet (da denne linje blev bogf�rt) i forhold til det bel�b, som anl�gget allerede var afskrevet med.;
                           ENU=Specifies if, when this line was posted, the additional acquisition cost posted on the line was depreciated in proportion to the amount by which the fixed asset had already been depreciated.];
                ApplicationArea=#Advanced;
                SourceExpr="Depr. Acquisition Cost" }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angivet nummeret for et anl�gsaktiv, hvor afkrydsningsfeltet Budgetanl�g er markeret. N�r du bogf�rer kladde- eller bilagslinje, oprettes en ekstra post for det budgetterede anl�gsaktiv, hvor bel�bet har det modsatte fortegn.;
                           ENU=Specifies the number of a fixed asset with the Budgeted Asset check box selected. When you post the journal or document line, an additional entry is created for the budgeted fixed asset where the amount has the opposite sign.];
                ApplicationArea=#Advanced;
                SourceExpr="Budgeted FA No." }

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
      PurchInvHeader@1000 : Record 122;

    BEGIN
    END.
  }
}

