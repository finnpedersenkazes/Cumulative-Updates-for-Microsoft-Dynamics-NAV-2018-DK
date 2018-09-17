OBJECT Page 5645 Insurance List
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
    CaptionML=[DAN=Forsikringsoversigt;
               ENU=Insurance List];
    SourceTable=Table5628;
    PageType=List;
    CardPageID=Insurance Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 27      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&orsikring;
                                 ENU=Ins&urance];
                      Image=Insurance }
      { 31      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Coverage Ledger E&ntries];
                      ToolTipML=[DAN=Vis de forsikringsposter, der bliver dannet, n†r du posterer til en forsikringskonto fra en k›bsfaktura, en kreditnota eller en kladdelinje.;
                                 ENU=View insurance ledger entries that were created when you post to an insurance account from a purchase invoice, credit memo or journal line.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5647;
                      RunPageView=SORTING(Insurance No.,Disposed FA,Posting Date)
                                  WHERE(Disposed FA=FILTER(No|Yes));
                      RunPageLink=Insurance No.=FIELD(No.);
                      Image=GeneralLedger }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Insurance),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 16      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 84      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=F† vist eller rediger de enkelte s‘t af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5628),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 17      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Suite;
                      Image=DimensionSets;
                      OnAction=VAR
                                 Insurance@1001 : Record 5628;
                                 DefaultDimMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Insurance);
                                 DefaultDimMultiple.SetMultiInsurance(Insurance);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 34      ;2   ;Separator  }
      { 6       ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis detaljerede historiske oplysninger om det faste anl‘gsaktiv.;
                                 ENU=View detailed historical information about the fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5646;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=&Forsikringssummer pr. anl‘g;
                                 ENU=Total Value Ins&ured per FA];
                      ToolTipML=[DAN=I et matrixvindue kan du f† vist forsikringsbel›bet for hvert aktiv, der er registreret for hver police. Det er forsikringsrelaterede summer, som du har bogf›rt fra en kladde.;
                                 ENU=View, in a matrix window, the amount of insurance registered with each insurance policy. These are the insurance-related amounts that you posted from a journal.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5622;
                      Promoted=Yes;
                      Image=TotalValueInsuredperFA;
                      PromotedCategory=Process }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1900084706;1 ;Action    ;
                      CaptionML=[DAN=Oversigt;
                                 ENU=List];
                      ToolTipML=[DAN=F† vist eller rediger listen over forsikringspolicer p† dit system.;
                                 ENU=View or edit the list of insurance policies in the system.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5621;
                      Promoted=Yes;
                      Image=OpportunitiesList;
                      PromotedCategory=Report }
      { 1901158106;1 ;Action    ;
                      CaptionML=[DAN=Ikke fors. anl‘g;
                                 ENU=Uninsured FAs];
                      ToolTipML=[DAN=F† vist de faste anl‘gsaktiver, der ikke har f†et bogf›rt bel›b til en forsikringspolice. Rapporten viser anskaffelsessummen for hvert enkelt fast anl‘gsaktiv, akkumuleret afskrivning og bogf›rt v‘rdi.;
                                 ENU=View the individual fixed assets for which amounts have not been posted to an insurance policy. For each fixed asset, the report shows the asset's acquisition cost, accumulated depreciation, and book value.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5626;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1907944406;1 ;Action    ;
                      CaptionML=[DAN=Forsikringssummer i alt;
                                 ENU=Tot. Value Insured];
                      ToolTipML=[DAN=F† vist hvert faste anl‘gsaktiv med de bel›b, du bogf›rte imod hver forsikringspolice. Posterne i denne rapport svarer til alle posterne i tabellen Forsikringspost. De bel›b, der vises for hvert enkelt anl‘gsaktiv, kan v‘re st›rre eller mindre end den faktiske d‘kning p† forsikringspolicen. De viste bel›b kan variere fra den faktiske bogf›rte v‘rdi for anl‘gsaktivet.;
                                 ENU=View each fixed asset with the amounts that you posted to each insurance policy. The entries in this report correspond to all of the entries in the Ins. Coverage Ledger Entry table. The amounts shown for each asset can be more or less than the actual insurance policy's coverage. The amounts shown can differ from the actual book value of the asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5625;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1904097106;1 ;Action    ;
                      CaptionML=[DAN=Forsikringsposter;
                                 ENU=Coverage Details];
                      ToolTipML=[DAN=F† vist de individuelle faste anl‘gsaktiver, der er knyttet til hver enkelt forsikringspolice. Hver police kan indeholde flere bel›b for de enkelte anl‘gsaktiver. Det er de bel›b, der skal d‘kkes ved forsikring. Bel›bene kan v‘re forskellige fra den faktiske forsikringsd‘kning.;
                                 ENU=View the individual fixed assets that are linked to each insurance policy. For each insurance policy, the report shows one or more amounts for each asset. These are the amounts that need insurance coverage. These amounts can differ from the actual insurance policy's coverage.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5624;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903807106;1 ;Action    ;
                      CaptionML=[DAN=Journal;
                                 ENU=Register];
                      ToolTipML=[DAN=Vis registre, der indeholder alle poster for faste anl‘gsaktiver, som er oprettet. Hvert register viser det f›rste og sidste l›benummer for dets poster.;
                                 ENU=View registers containing all the fixed asset entries that are created. Every register shows the first and last entry number of its entries.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5623;
                      Promoted=Yes;
                      Image=Confirm;
                      PromotedCategory=Report }
      { 1901105406;1 ;Action    ;
                      CaptionML=[DAN=Analyse;
                                 ENU=Analysis];
                      ToolTipML=[DAN=Vis en analyse af anl‘gsaktiverne med oplysninger om b†de enkelte anl‘gsaktiver og grupper af anl‘gsaktiver.;
                                 ENU=View an analysis of your fixed assets with various types of data for both individual assets and groups of assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5620;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#FixedAssets;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af forsikringspolicen.;
                           ENU=Specifies a description of the insurance policy.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forsikringstype (f.eks. tyveri eller brand), som forsikringspolicen d‘kker.;
                           ENU=Specifies the type of insurance (for example, theft or fire) that is covered by this insurance policy.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Insurance Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, som du har k›bt forsikringspolicen af.;
                           ENU=Specifies the number of the vendor from whom you purchased this insurance policy.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Insurance Vendor No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den anl‘gsartskode, der skal tildeles forsikringspolicen.;
                           ENU=Specifies a fixed asset class code to assign to the insurance policy.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Class Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den anl‘gsunderartskode, der skal tildeles forsikringspolicen.;
                           ENU=Specifies a fixed asset subclass code to assign to the insurance policy.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Subclass Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationskoden for det eller de anl‘g, der er knyttet til forsikringspolicen.;
                           ENU=Specifies the code of the location of the fixed asset(s) linked to the insurance policy.];
                ApplicationArea=#Advanced;
                SourceExpr="FA Location Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en s›gebeskrivelse for forsikringspolicen.;
                           ENU=Specifies a search description for the insurance policy.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Description" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

