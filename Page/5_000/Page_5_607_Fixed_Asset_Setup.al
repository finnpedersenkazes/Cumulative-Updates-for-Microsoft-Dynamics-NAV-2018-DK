OBJECT Page 5607 Fixed Asset Setup
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anl‘gsops‘tning;
               ENU=Fixed Asset Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5603;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Generelt,Afskrivninger,Bogf›ring,Kladdetyper;
                                ENU=New,Process,Report,General,Depreciation,Posting,Journal Templates];
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
               END;

    ActionList=ACTIONS
    {
      { 20      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=Afskrivningsprofiler;
                                 ENU=Depreciation Books];
                      ToolTipML=[DAN=Konfigurer afskrivningsprofiler til forskellige afskrivningsform†l, f.eks. skatteregnskaber eller †rsregnskaber.;
                                 ENU=Set up depreciation books for various depreciation purposes, such as tax and financial statements.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5611;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=DepreciationBooks;
                      PromotedCategory=Category5 }
      { 18      ;1   ;Action    ;
                      CaptionML=[DAN=Afskrivningstabeller;
                                 ENU=Depreciation Tables];
                      ToolTipML=[DAN=Konfigurer de forskellige afskrivningsmetoder, du vil bruge til afskrivning af anl‘gsaktiver.;
                                 ENU=Set up the different depreciation methods that you will use to depreciate fixed assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5663;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Table;
                      PromotedCategory=Category5 }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Anl‘gsarter;
                                 ENU=FA Classes];
                      ToolTipML=[DAN=Konfigurer de forskellige aktivklasser, som f.eks. materielle aktiver og immaterielle aktiver, for at gruppere anl‘gsaktiver efter kategorier.;
                                 ENU=Set up different asset classes, such as Tangible Assets and Intangible Assets, to group your fixed assets by categories.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5615;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=FARegisters;
                      PromotedCategory=Category4 }
      { 16      ;1   ;Action    ;
                      CaptionML=[DAN=Anl‘gsgrupper;
                                 ENU=FA Subclasses];
                      ToolTipML=[DAN=Konfigurer anl‘gsaktiver i forskellige grupper, f.eks. anl‘g og fast ejendom samt maskiner og udstyr, som du kan tildele til anl‘gsaktiver og forsikringspolicer.;
                                 ENU=Set up different asset subclasses, such as Plant and Property and Machinery and Equipment, that you can assign to fixed assets and insurance policies.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5616;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=FARegisters;
                      PromotedCategory=Category4 }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Anl‘gslokationer;
                                 ENU=FA Locations];
                      ToolTipML=[DAN=Konfigurer de forskellige lokationer, som f.eks. et lager eller en lokation p† et lager, som du kan allokere til anl‘gsaktiver.;
                                 ENU=Set up different locations, such as a warehouse or a location within a warehouse, that you can assign to fixed assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5617;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=FixedAssets;
                      PromotedCategory=Category4 }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=Bogf›ring;
                                 ENU=Posting] }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Anl‘gsbogf.typeops‘tning;
                                 ENU=FA Posting Type Setup];
                      ToolTipML=[DAN=Definer, hvordan du h†ndterer bogf›ringstyperne nedskrivning, opskrivning, bruger 1 og bruger 2, n†r du bogf›rer p† anl‘gsaktiver.;
                                 ENU=Define how to handle the Write-Down, Appreciation, Custom 1, and Custom 2 posting types that you use when posting to fixed assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5608;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GeneralPostingSetup;
                      PromotedCategory=Category6 }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Anl‘gsbogf›ringsgrupper;
                                 ENU=FA Posting Groups];
                      ToolTipML=[DAN=Konfigurer de konti, som transaktioner for anl‘gsaktiver skal bogf›res p† for hver bogf›ringsgruppe, s† du kan tildele dem til de relevante anl‘gsaktiver.;
                                 ENU=Set up the accounts to which transactions are posted for fixed assets for each posting group, so that you can assign them to the relevant fixed assets.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5613;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GeneralPostingSetup;
                      PromotedCategory=Category6 }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=Anl‘gskladdetyper;
                                 ENU=FA Journal Templates];
                      ToolTipML=[DAN=Konfigurer nummerserier og †rsagskoder i de kladder, du bruger til bogf›ring af anl‘gsaktiver. Ved at bruge de forskellige kladder kan du udforme vinduer med forskelligt layout, og du kan tildele sporingskoder, nummerserier og rapporter til hver kladde.;
                                 ENU=Set up number series and reason codes in the journals that you use for fixed asset posting. By using different templates you can design windows with different layouts and you can assign trace codes, number series, and reports to each template.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5630;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=JournalSetup;
                      PromotedCategory=Category7 }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Anl‘gsompost.kladdetyper;
                                 ENU=FA Reclass. Journal Templates];
                      ToolTipML=[DAN=Konfigurer nummerserier og †rsagskoder i den kladde, du bruger til ompostering af anl‘gsaktiver. Ved at bruge de forskellige kladder kan du udforme vinduer med forskelligt layout, og du kan tildele sporingskoder, nummerserier og rapporter til hver kladde.;
                                 ENU=Set up number series and reason codes in the journal that you use to reclassify fixed assets. By using different templates you can design windows with different layouts and you can assign trace codes, number series, and reports to each template.];
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5637;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=JournalSetup;
                      PromotedCategory=Category7 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver standardafskrivningsprofilen p† kladdelinjer og k›bslinjer, og n†r du aktiverer k›rsler og rapporter.;
                           ENU=Specifies the default depreciation book on journal lines and purchase lines and when you run batch jobs and reports.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Default Depr. Book" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du har opdelt dine anl‘g i hovedanl‘g og komponenter og vil kunne bogf›re direkte p† hovedanl‘ggene.;
                           ENU=Specifies whether you have split your fixed assets into main assets and components, and you want to be able to post directly to main assets.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Allow Posting to Main Assets" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tidligste dato, hvor det er tilladt at bogf›re for anl‘ggene.;
                           ENU=Specifies the earliest date when posting to the fixed assets is allowed.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Allow FA Posting From" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den seneste dato, hvor det er tilladt at bogf›re for anl‘ggene.;
                           ENU=Specifies the latest date when posting to the fixed assets is allowed.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Allow FA Posting To" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en afskrivningsprofilkode. Hvis du bruger forsikringsmodulet, skal du indtaste en kode for at kunne bogf›re forsikringsposter.;
                           ENU=Specifies a depreciation book code. If you use the insurance facilities, you must enter a code to post insurance coverage ledger entries.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Insurance Depr. Book";
                Importance=Additional }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du vil bogf›re forsikringsposter, n†r du bogf›rer anskaffelsesposter, og feltet Forsikringsnr. er udfyldt.;
                           ENU=Specifies you want to post insurance coverage ledger entries when you post acquisition cost entries with the Insurance No. field filled in.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Automatic Insurance Posting";
                Importance=Additional }

    { 1904569201;1;Group  ;
                CaptionML=[DAN=Nummerering;
                           ENU=Numbering] }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der bruges til at tildele numre til anl‘g.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to fixed assets.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Fixed Asset Nos." }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele numre til forsikringspolicer.;
                           ENU=Specifies the number series code that will be used to assign numbers to insurance policies.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Insurance Nos." }

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

    BEGIN
    END.
  }
}

