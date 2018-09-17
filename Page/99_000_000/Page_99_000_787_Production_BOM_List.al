OBJECT Page 99000787 Production BOM List
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
    CaptionML=[DAN=Prod.styklisteoversigt;
               ENU=Production BOM List];
    SourceTable=Table99000771;
    DataCaptionFields=No.;
    PageType=List;
    CardPageID=Production BOM;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=&P.stykliste;
                                 ENU=&Prod. BOM];
                      Image=BOM }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000784;
                      RunPageLink=Table Name=CONST(Production BOM Header),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 11      ;2   ;Action    ;
                      CaptionML=[DAN=Versioner;
                                 ENU=Versions];
                      ToolTipML=[DAN=Vis alle alternative versioner af produktionsstyklisten.;
                                 ENU=View any alternate versions of the production BOM.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000800;
                      RunPageLink=Production BOM No.=FIELD(No.);
                      Promoted=No;
                      Image=BOMVersions;
                      PromotedCategory=Process }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Matri&x pr. version;
                                 ENU=Ma&trix per Version];
                      ToolTipML=[DAN=Vis en liste over alle versioner og varer og det anvendte antal pr. vare i en produktionsstykliste. Du kan bruge matrixen til at sammenligne produktionsstyklisteversioner vedr›rende de anvendte varer pr. version.;
                                 ENU=View a list of all versions and items and the used quantity per item of a production BOM. You can use the matrix to compare different production BOM versions concerning the used items per version.];
                      ApplicationArea=#Manufacturing;
                      Image=ProdBOMMatrixPerVersion;
                      OnAction=VAR
                                 BOMMatrixForm@1001 : Page 99000812;
                               BEGIN
                                 BOMMatrixForm.Set(Rec);

                                 BOMMatrixForm.RUN;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=Indg†r-i;
                                 ENU=Where-used];
                      ToolTipML=[DAN=F† vist en liste over styklister, hvor varen anvendes.;
                                 ENU=View a list of BOMs in which the item is used.];
                      ApplicationArea=#Manufacturing;
                      Image=Where-Used;
                      OnAction=BEGIN
                                 ProdBOMWhereUsed.SetProdBOM(Rec,WORKDATE);

                                 ProdBOMWhereUsed.RUN;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907995704;1 ;Action    ;
                      CaptionML=[DAN=Erstat prod.styklistevare;
                                 ENU=Exchange Production BOM Item];
                      ToolTipML=[DAN=Erstat varer, der ikke l‘ngere bruges i produktionsstyklister. Du kan eksempelvis erstatte en vare med en ny vare eller en ny produktionsstykliste. Du kan oprette nye versioner og erstatte en vare i produktionsstyklisterne.;
                                 ENU=Replace items that are no longer used in production BOMs. You can exchange an item, for example, with a new item or a new production BOM. You can create new versions while exchanging an item in the production BOMs.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99001043;
                      Promoted=Yes;
                      Image=ExchProdBOMItem;
                      PromotedCategory=Process }
      { 1907829704;1 ;Action    ;
                      CaptionML=[DAN=Slet udl›bne komponenter;
                                 ENU=Delete Expired Components];
                      ToolTipML=[DAN=Fjern styklistelinjer, hvor slutdatoerne er udl›bet. Styklistehovedet ‘ndres ikke.;
                                 ENU=Remove BOM lines that have expired ending dates. The BOM header will not be changed.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99001041;
                      Promoted=Yes;
                      Image=DeleteExpiredComponents;
                      PromotedCategory=Process }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1901845606;1 ;Action    ;
                      CaptionML=[DAN=Indg†r-i (h›jeste niveau);
                                 ENU=Where-Used (Top Level)];
                      ToolTipML=[DAN=Vis, hvor og i hvilke m‘ngder varen bruges, i produktstrukturen. Rapporten viser kun oplysninger for varen p† ›verste niveau. Hvis varen A f.eks. anvendes til at producere varen B, og varen B anvendes til at producere varen C, viser rapporten varen B, hvis du k›rer en rapport for varen A. Hvis du k›rer rapporten for varen B, vises varen C som Indg†r-i.;
                                 ENU=View where and in what quantities the item is used in the product structure. The report only shows information for the top-level item. For example, if item "A" is used to produce item "B", and item "B" is used to produce item "C", the report will show item B if you run this report for item A. If you run this report for item B, then item C will be shown as where-used.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000757;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1907778006;1 ;Action    ;
                      CaptionML=[DAN=Styklisteudfold. - antal;
                                 ENU=Quantity Explosion of BOM];
                      ToolTipML=[DAN=Vis en niveaudelt styklisteoversigt med de varer, du angiver i filtrene. Produktionsstyklisten er fuldst‘ndig udfoldet (alle niveauer).;
                                 ENU=View an indented BOM listing for the item or items that you specify in the filters. The production BOM is completely exploded for all levels.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000753;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1907846806;1 ;Action    ;
                      CaptionML=[DAN=Sammenligningsoversigt;
                                 ENU=Compare List];
                      ToolTipML=[DAN=F† vist en sammenligning af komponenter for to varer. Udskriften sammenligner komponenterne, deres kostpris, kostfordeling og kostpris pr. komponent.;
                                 ENU=View a comparison of components for two items. The printout compares the components, their unit cost, cost share and cost per component.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000758;
                      Promoted=No;
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
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af produkionsstyklisten.;
                           ENU=Specifies a description for the production BOM.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en udvidet beskrivelse af styklisten, hvis der ikke er plads nok i feltet Beskrivelse.;
                           ENU=Specifies an extended description for the BOM if there is not enough space in the Description field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for produktionsstyklisten.;
                           ENU=Specifies the status of the production BOM.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Status }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et alternativt navn, du kan bruge til at s›ge efter den ›nskede record, hvis du ikke kan huske v‘rdien i feltet Navn.;
                           ENU=Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Search Name";
                Visible=FALSE }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver det versionsnummer, som produktionsstyklisteversionerne henviser til.;
                           ENU=Specifies the version number series that the production BOM versions refer to.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Version Nos.";
                Visible=FALSE }

    { 1102601002;2;Field  ;
                ToolTipML=[DAN=Angiver den sidste ‘ndringsdato.;
                           ENU=Specifies the last date that was modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified";
                Visible=FALSE }

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
    VAR
      ProdBOMWhereUsed@1000 : Page 99000811;

    BEGIN
    END.
  }
}

