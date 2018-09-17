OBJECT Page 850 Cash Flow Forecast Entries
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
    CaptionML=[DAN=Pengestr›msprognoseposter;
               ENU=Cash Flow Forecast Entries];
    SourceTable=Table847;
    PageType=List;
    OnFindRecord=BEGIN
                   EXIT(FIND(Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(NEXT(Steps));
                 END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1051    ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 1052    ;2   ;Action    ;
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
                               END;
                                }
      { 4       ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr‘ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Suite;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
                               END;
                                }
      { 1053    ;2   ;Action    ;
                      Name=GLDimensionOverview;
                      CaptionML=[DAN=Finansdimensionsoversigt;
                                 ENU=G/L Dimension Overview];
                      ToolTipML=[DAN=Vis en oversigt over finansposter og dimensioner.;
                                 ENU=View an overview of general ledger entries and dimensions.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"CF Entries Dim. Overview",Rec);
                               END;
                                }
      { 1       ;1   ;Action    ;
                      Name=ShowSource;
                      CaptionML=[DAN=Vi&s;
                                 ENU=&Show];
                      ToolTipML=[DAN=Vis de faktiske pengestr›msprognoseposter.;
                                 ENU=View the actual cash flow forecast entries.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=View;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowSource(FALSE);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000;1   ;Group     ;
                GroupType=Repeater }

    { 1001;2   ;Field     ;
                ToolTipML=[DAN=Angiver den pengestr›msdato, posten er bogf›rt p†.;
                           ENU=Specifies the cash flow date that the entry is posted to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cash Flow Date" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver, om posten er relateret til en forfalden betaling. ";
                           ENU="Specifies if the entry is related to an overdue payment. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Overdue }

    { 1005;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nummer p† pengestr›msprognosen.;
                           ENU=Specifies a number for the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cash Flow Forecast No." }

    { 1007;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den pengestr›mskonto, som prognoseposten bogf›res til.;
                           ENU=Specifies the number of the cash flow account that the forecast entry is posted to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Cash Flow Account No." }

    { 1011;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bilag, der repr‘senterer prognoseposten.;
                           ENU=Specifies the document that represents the forecast entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 1013;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af pengestr›msprognoseposten.;
                           ENU=Specifies a description of the cash flow forecast entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                OnDrillDown=BEGIN
                              ShowSource(FALSE);
                            END;
                             }

    { 1003;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kildetype, der g‘lder for det kildenummer, som vises i feltet Kildenr.;
                           ENU=Specifies the source type that applies to the source number that is shown in the Source No. field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Type" }

    { 1017;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source No.";
                OnDrillDown=BEGIN
                              ShowSource(TRUE);
                            END;
                             }

    { 1025;2   ;Field     ;
                ToolTipML=[DAN=Angiver den mulige kontantrabatprocent for pengestr›msprognosen.;
                           ENU=Specifies the possible payment discount for the cash flow forecast.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Discount" }

    { 1027;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code" }

    { 1029;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet p† prognoselinjen i RV. Indt‘gter indtastes uden et plus- eller minustegn. Udgifter indtastes med et minustegn.;
                           ENU=Specifies the amount of the forecast line in LCY. Revenues are entered without a plus or minus sign. Expenses are entered with a minus sign.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount (LCY)" }

    { 1033;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 1043;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID" }

    { 1045;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No." }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv‘rdier. De faktiske v‘rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension Set ID";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      DimensionSetIDFilter@1000 : Page 481;

    BEGIN
    END.
  }
}

