OBJECT Page 519 Item Journal Lines
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
    CaptionML=[DAN=Varekladdelinjer;
               ENU=Item Journal Lines];
    LinksAllowed=No;
    SourceTable=Table83;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  CLEAR(ShortcutDimCode);
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 28      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Vis kladde;
                                 ENU=Show Batch];
                      ToolTipML=[DAN=Vis kladdenavnet, som kladdelinjen er baseret p†.;
                                 ENU=Show the journal batch that the journal line is based on.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewDescription;
                      OnAction=BEGIN
                                 ItemJnlTemplate.GET("Journal Template Name");
                                 ItemJnlLine := Rec;
                                 ItemJnlLine.FILTERGROUP(2);
                                 ItemJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
                                 ItemJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
                                 ItemJnlLine.FILTERGROUP(0);
                                 PAGE.RUN(ItemJnlTemplate."Page ID",ItemJnlLine);
                               END;
                                }
      { 67      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 6500    ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=F† vist eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines(FALSE);
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
                ToolTipML=[DAN=Angiver navnet p† kladdetypen - grundlaget for den kladdek›rsel, som posterne blev bogf›rt fra.;
                           ENU=Specifies the name of the journal template, the basis of the journal batch, that the entries were posted from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Journal Template Name" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som posterne blev bogf›rt fra.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Journal Batch Name" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† kladdelinjen.;
                           ENU=Specifies the number of the journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Line No.";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date for the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion der skal bogf›res fra varekladdelinjen.;
                           ENU=Specifies the type of transaction that will be posted from the item journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry Type" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer for kladdelinjen.;
                           ENU=Specifies a document number for the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nummer p† kladdelinjen.;
                           ENU=Specifies the number of the item on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No." }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p† kladdelinjen.;
                           ENU=Specifies a description of the item on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[3];
                CaptionClass='1,2,3';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 302 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[4];
                CaptionClass='1,2,4';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 304 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[5];
                CaptionClass='1,2,5';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 306 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[6];
                CaptionClass='1,2,6';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 308 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[7];
                CaptionClass='1,2,7';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 310 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[8];
                CaptionClass='1,2,8';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lagerlokation, hvor varen p† kladdelinjen skal registreres.;
                           ENU=Specifies the code for the inventory location where the item on the journal line will be registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger eller indk›ber, der er knyttet til salget eller k›bet p† kladdelinjen.;
                           ENU=Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.];
                ApplicationArea=#Advanced;
                SourceExpr="Salespers./Purch. Code";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Bus. Posting Group";
                Visible=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Advanced;
                SourceExpr="Gen. Prod. Posting Group";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der skal indg† i linjen.;
                           ENU=Specifies the number of units of the item to be included on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Quantity }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, der er reserveret for linjen.;
                           ENU=Specifies the quantity of the item reserved for the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reserved Qty. (Base)" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code" }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen p† ‚n enhed af varen p† kladdelinjen.;
                           ENU=Specifies the price of one unit of the item on the journal line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Amount" }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjens nettobel›b.;
                           ENU=Specifies the line's net amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k›bspris, der omfatter indirekte omkostninger, s†som fragt, der er knyttet til k›bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Indirect Cost %";
                Visible=FALSE }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      ItemJnlLine@1000 : Record 83;
      ItemJnlTemplate@1001 : Record 82;
      ShortcutDimCode@1002 : ARRAY [8] OF Code[20];

    BEGIN
    END.
  }
}

