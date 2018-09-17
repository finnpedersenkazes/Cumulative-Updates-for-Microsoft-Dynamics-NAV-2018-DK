OBJECT Page 5601 Fixed Asset List
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
    CaptionML=[DAN=Anl‘gsoversigt;
               ENU=Fixed Asset List];
    SourceTable=Table5600;
    PageType=List;
    CardPageID=Fixed Asset Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Anl‘g;
                                 ENU=Fixed &Asset];
                      Image=FixedAssets }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Afskriv&ningsprofiler;
                                 ENU=Depreciation &Books];
                      ToolTipML=[DAN=Vis eller rediger den afskrivningsprofil eller de afskrivningsprofiler, der skal bruges til hvert enkelt anl‘g. Du kan ogs† angive, hvordan afskrivningen skal beregnes.;
                                 ENU=View or edit the depreciation book or books that must be used for each of the fixed assets. Here you also specify the way depreciation must be calculated.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5619;
                      RunPageLink=FA No.=FIELD(No.);
                      Image=DepreciationBooks }
      { 46      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis detaljerede historiske oplysninger om anl‘gget.;
                                 ENU=View detailed historical information about the fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5602;
                      RunPageLink=FA No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 49      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      Image=Dimensions }
      { 41      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=F† vist eller rediger de enkelte s‘t af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Suite;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5600),
                                  No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process }
      { 50      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=DimensionSets;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 FA@1001 : Record 5600;
                                 DefaultDimMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(FA);
                                 DefaultDimMultiple.SetMultiFA(FA);
                                 DefaultDimMultiple.RUNMODAL;
                               END;
                                }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Rep&arationsposter;
                                 ENU=Main&tenance Ledger Entries];
                      ToolTipML=[DAN="Vis alle reparationsposter for et anl‘gsaktiv. ";
                                 ENU="View all the maintenance ledger entries for a fixed asset. "];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5641;
                      RunPageView=SORTING(FA No.);
                      RunPageLink=FA No.=FIELD(No.);
                      Image=MaintenanceLedgerEntries }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Billede;
                                 ENU=Picture];
                      ToolTipML=[DAN=Tilf›j eller vis et billede af anl‘gget.;
                                 ENU=Add or view a picture of the fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5620;
                      RunPageLink=No.=FIELD(No.);
                      Image=Picture }
      { 48      ;2   ;Action    ;
                      CaptionML=[DAN=Anl‘gsbogf.typeoversigt;
                                 ENU=FA Posting Types Overview];
                      ToolTipML=[DAN=Vis akkumulerede bel›b for hvert felt, f.eks. bogf›rt v‘rdi, anskaffelsespris, afskrivning, og for hvert anl‘g. For hvert anl‘g vises en separat linje for hver afskrivningsprofil, der er knyttet til anl‘gget.;
                                 ENU=View accumulated amounts for each field, such as book value, acquisition cost, and depreciation, and for each fixed asset. For every fixed asset, a separate line is shown for each depreciation book linked to the asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5662;
                      Promoted=Yes;
                      Image=ShowMatrix;
                      PromotedCategory=Process }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Fixed Asset),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Hovedanl‘g;
                                 ENU=Main Asset];
                      Image=Components }
      { 44      ;2   ;Action    ;
                      CaptionML=[DAN=&Hovedanl‘g;
                                 ENU=M&ain Asset Components];
                      ToolTipML=[DAN=Vis eller rediger anl‘gskomponenter for det hovedanl‘g, som er repr‘senteret af anl‘gskortet.;
                                 ENU=View or edit fixed asset components of the main fixed asset that is represented by the fixed asset card.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5658;
                      RunPageLink=Main Asset No.=FIELD(No.);
                      Image=Components }
      { 47      ;2   ;Action    ;
                      CaptionML=[DAN=Ho&vedanl‘g - statistik;
                                 ENU=Ma&in Asset Statistics];
                      ToolTipML=[DAN=Vis detaljerede historiske oplysninger om alle de komponenter, der samlet udg›r hovedanl‘gget.;
                                 ENU=View detailed historical information about all the components that make up the main asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5603;
                      RunPageLink=FA No.=FIELD(No.);
                      Image=StatisticsDocument }
      { 45      ;2   ;Separator ;
                      CaptionML=[DAN="";
                                 ENU=""] }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 37      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Vis historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5604;
                      RunPageView=SORTING(FA No.)
                                  ORDER(Descending);
                      RunPageLink=FA No.=FIELD(No.);
                      Image=FixedAssetLedger }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Fejlposter;
                                 ENU=Error Ledger Entries];
                      ToolTipML=[DAN=Vis de poster, der er blevet bogf›rt, fordi du har brugt funktionen Annuller til at annullere en post.;
                                 ENU=View the entries that have been posted as a result of you using the Cancel function to cancel an entry.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5605;
                      RunPageView=SORTING(Canceled from FA No.)
                                  ORDER(Descending);
                      RunPageLink=Canceled from FA No.=FIELD(No.);
                      Image=ErrorFALedgerEntries }
      { 43      ;2   ;Action    ;
                      CaptionML=[DAN=Reparations&registrering;
                                 ENU=Maintenance &Registration];
                      ToolTipML=[DAN=Vis eller rediger reparationskoder for forskellige former for reparation, vedligeholdelse og serviceydelser p† dine anl‘g. Du kan derefter angive koden i feltet Reparationskode i kladder.;
                                 ENU=View or edit maintenance codes for the various types of maintenance, repairs, and services performed on your fixed assets. You can then enter the code in the Maintenance Code field on journals.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5625;
                      RunPageLink=FA No.=FIELD(No.);
                      Image=MaintenanceRegistrations }
      { 7       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;Action    ;
                      CaptionML=[DAN=Anl‘gskladde;
                                 ENU=Fixed Asset Journal];
                      ToolTipML=[DAN="Bogf›r anl‘gstransaktioner med en afskrivningsprofil, der ikke er integreret i finansregnskabet, med henblik p† intern administration. Der oprettes kun anl‘gsposter. ";
                                 ENU="Post fixed asset transactions with a depreciation book that is not integrated with the general ledger, for internal management. Only fixed asset ledger entries are created. "];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5629;
                      Image=Journal }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Anl‘gskassekladde;
                                 ENU=Fixed Asset G/L Journal];
                      ToolTipML=[DAN="Bogf›r anl‘gstransaktioner med en afskrivningsprofil, der ikke er integreret i finansregnskabet, med henblik p† finansiel rapportering. Der oprettes b†de anl‘gsposter og finansposter. ";
                                 ENU="Post fixed asset transactions with a depreciation book that is integrated with the general ledger, for financial reporting. Both fixed asset ledger entries are general ledger entries are created. "];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5628;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Journal;
                      PromotedCategory=Process }
      { 61      ;1   ;Action    ;
                      CaptionML=[DAN=Anl‘gsomposteringskladde;
                                 ENU=Fixed Asset Reclassification Journal];
                      ToolTipML=[DAN=Overf›r, opdel eller kombiner anl‘g.;
                                 ENU=Transfer, split, or combine fixed assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5636;
                      Image=Journal }
      { 60      ;1   ;Action    ;
                      CaptionML=[DAN=Anl‘gsgentagelseskladde;
                                 ENU=Recurring Fixed Asset Journal];
                      ToolTipML=[DAN=Bogf›r gentagelsesposter i en afskrivningsprofil uden integration med finansregnskabet.;
                                 ENU=Post recurring entries to a depreciation book without integration with general ledger.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5634;
                      Image=Journal }
      { 11      ;1   ;Action    ;
                      Name=CalculateDepreciation;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beregn afskrivninger;
                                 ENU=Calculate Depreciation];
                      ToolTipML=[DAN=Beregn afskrivningen i overensstemmelse med de betingelser, du definerer. Hvis den relaterede afskrivningsprofil er konfigureret til integration med finans, overf›res de beregnede poster til finanskladden for anl‘gsaktiver. Ellers overf›res de beregnede poster til kladden for faste anl‘gsaktiver. Du kan derefter gennemse posterne og bogf›re kladden.;
                                 ENU=Calculate depreciation according to conditions that you specify. If the related depreciation book is set up to integrate with the general ledger, then the calculated entries are transferred to the fixed asset general ledger journal. Otherwise, the calculated entries are transferred to the fixed asset journal. You can then review the entries and post the journal.];
                      ApplicationArea=#FixedAssets;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CalculateDepreciation;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Calculate Depreciation",TRUE,FALSE,Rec);
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier anl&‘g;
                                 ENU=C&opy Fixed Asset];
                      ToolTipML=[DAN=Opret et eller flere nye anl‘gsaktiver ved at kopiere fra et eksisterende anl‘gsaktiv med lignende oplysninger.;
                                 ENU=Create one or more new fixed assets by copying from an existing fixed asset that has similar information.];
                      ApplicationArea=#FixedAssets;
                      Image=CopyFixedAssets;
                      OnAction=VAR
                                 CopyFA@1000 : Report 5685;
                               BEGIN
                                 CopyFA.SetFANo("No.");
                                 CopyFA.RUNMODAL;
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1907091306;1 ;Action    ;
                      CaptionML=[DAN=Anl‘gsliste;
                                 ENU=Fixed Assets List];
                      ToolTipML=[DAN=Vis listen over anl‘g, der findes i systemet.;
                                 ENU=View the list of fixed assets that exist in the system .];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5601;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903109606;1 ;Action    ;
                      CaptionML=[DAN=Anskaffelsesoversigt;
                                 ENU=Acquisition List];
                      ToolTipML=[DAN=Vis de relaterede anskaffelser.;
                                 ENU=View the related acquisitions.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5608;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1901902606;1 ;Action    ;
                      CaptionML=[DAN=Detaljer;
                                 ENU=Details];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om de anl‘gsposter, der er bogf›rt i en bestemt afskrivningsprofil for hvert enkelt anl‘g.;
                                 ENU=View detailed information about the fixed asset ledger entries that have been posted to a specified depreciation book for each fixed asset.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5604;
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Report }
      { 1905598506;1 ;Action    ;
                      CaptionML=[DAN=Anl‘g - bogf›rt v‘rdi;
                                 ENU=FA Book Value];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om anskaffelsesbel›b, afskrivninger og bogf›rte v‘rdier for b†de enkelte anl‘g og grupper af anl‘g. For hver af de tre bel›bstyper beregnes bel›bene ved begyndelsen og ved slutningen af den valgte periode samt for selve perioden.;
                                 ENU=View detailed information about acquisition cost, depreciation and book value for both individual assets and groups of assets. For each of these three amount types, amounts are calculated at the beginning and at the end of a specified period as well as for the period itself.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5605;
                      Image=Report }
      { 1905598606;1 ;Action    ;
                      CaptionML=[DAN=Anl‘gs bogf›rte v‘rdi - Op- og nedskrivning;
                                 ENU=FA Book Val. - Appr. & Write-D];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om anskaffelsesbel›b, afskrivninger, opskrivninger, nedskrivninger og bogf›rte v‘rdier i forbindelse med b†de enkelte anl‘g og grupper af anl‘g. For hver af bel›bstyperne beregnes bel›bene ved begyndelsen og ved slutningen af den valgte periode samt for selve perioden.;
                                 ENU=View detailed information about acquisition cost, depreciation, appreciation, write-down and book value for both individual assets and groups of assets. For each of these categories, amounts are calculated at the beginning and at the end of a specified period, as well as for the period itself.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5606;
                      Image=Report }
      { 1901105406;1 ;Action    ;
                      CaptionML=[DAN=Analyse;
                                 ENU=Analysis];
                      ToolTipML=[DAN=Vis en analyse af anl‘gsaktiverne med forskellige typer data for b†de enkelte anl‘gsaktiver og grupper af anl‘gsaktiver.;
                                 ENU=View an analysis of your fixed assets with various types of data for both individual assets and groups of fixed assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5600;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902048606;1 ;Action    ;
                      CaptionML=[DAN=Forventet v‘rdi;
                                 ENU=Projected Value];
                      ToolTipML=[DAN=Vis den beregnede fremtidige afskrivning og den bogf›rte v‘rdi. Du kan udskrive rapporten for ‚n afskrivningsprofil ad gangen.;
                                 ENU=View the calculated future depreciation and book value. You can print the report for one depreciation book at a time.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5607;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903345906;1 ;Action    ;
                      CaptionML=[DAN=Finansanalyse;
                                 ENU=G/L Analysis];
                      ToolTipML=[DAN=Vis en analyse af anl‘gsaktiverne med forskellige typer data for enkelte anl‘gsaktiver og/eller grupper af anl‘gsaktiver.;
                                 ENU=View an analysis of your fixed assets with various types of data for individual assets and/or groups of fixed assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5610;
                      Image=Report }
      { 1903807106;1 ;Action    ;
                      CaptionML=[DAN=Journal;
                                 ENU=Register];
                      ToolTipML=[DAN=Vis registre, der indeholder alle poster for faste anl‘gsaktiver, som er oprettet. Hvert register viser det f›rste og sidste l›benummer for dets poster.;
                                 ENU=View registers containing all the fixed asset entries that are created. Each register shows the first and last entry number of its entries.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Report 5603;
                      Image=Confirm }
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
                ToolTipML=[DAN=Angiver en beskrivelse af anl‘gget.;
                           ENU=Specifies a description of the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, som du har k›bt anl‘gget af.;
                           ENU=Specifies the number of the vendor from which you purchased this fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Vendor No.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, som udf›rer reparationer og vedligeholdelse p† anl‘gget.;
                           ENU=Specifies the number of the vendor who performs repairs and maintenance on the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Maintenance Vendor No.";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den medarbejder, der er ansvarlig for anl‘gget.;
                           ENU=Specifies which employee is responsible for the fixed asset.];
                ApplicationArea=#Advanced;
                SourceExpr="Responsible Employee" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den art, som anl‘gsaktivet tilh›rer.;
                           ENU=Specifies the class that the fixed asset belongs to.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Class Code" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver gruppen under den art, som anl‘gget tilh›rer.;
                           ENU=Specifies the subclass of the class that the fixed asset belongs to.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Subclass Code" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, f.eks. en bygning, hvor anl‘gget er placeret.;
                           ENU=Specifies the location, such as a building, where the fixed asset is located.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Location Code" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om anl‘gget er til budgetform†l.;
                           ENU=Specifies if the asset is for budgeting purposes.];
                ApplicationArea=#Suite;
                SourceExpr="Budgeted Asset";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en s›gebeskrivelse for anl‘gget.;
                           ENU=Specifies a search description for the fixed asset.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Description" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at anl‘gget er blevet anskaffet.;
                           ENU=Specifies that the fixed asset has been acquired.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Acquired }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

