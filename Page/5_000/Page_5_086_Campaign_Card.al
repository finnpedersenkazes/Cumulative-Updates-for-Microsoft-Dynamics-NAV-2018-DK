OBJECT Page 5086 Campaign Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kampagnekort;
               ENU=Campaign Card];
    SourceTable=Table5071;
    PopulateAllFields=Yes;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 32      ;1   ;ActionGroup;
                      CaptionML=[DAN=K&ampagne;
                                 ENU=C&ampaign];
                      Image=Campaign }
      { 34      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=E&ntries];
                      ToolTipML=[DAN=F† vist alle poster, der er knyttet til kampagnen. Du kan ikke oprette nye kampagneposter manuelt i dette vindue.;
                                 ENU=View all the entries linked to the campaign. In this window, you cannot manually create new campaign entries.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5089;
                      RunPageView=SORTING(Campaign No.);
                      RunPageLink=Campaign No.=FIELD(No.);
                      Image=Entries }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5072;
                      RunPageLink=Table Name=CONST(Campaign),
                                  No.=FIELD(No.),
                                  Sub No.=CONST(0);
                      Image=ViewComments }
      { 36      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist n›gletal vedr›rende din kampagne.;
                                 ENU=View key figures concerning your campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5088;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 37      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(5071),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=Opg&aver;
                                 ENU=T&asks];
                      ToolTipML=[DAN=Vis opgaver for kampagnen.;
                                 ENU=View tasks for the campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5096;
                      RunPageView=SORTING(Campaign No.);
                      RunPageLink=Campaign No.=FIELD(No.),
                                  System To-do Type=FILTER(Organizer);
                      Image=TaskList }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=M&†lgrupper;
                                 ENU=S&egments];
                      ToolTipML=[DAN=F† vist en liste over alle †bne m†lgrupper. For †bne m†lgrupper er der ikke blevet logf›rt en interaktion endnu.;
                                 ENU=View a list of all the open segments. Open segments are those for which the interaction has not been logged yet.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5093;
                      RunPageView=SORTING(Campaign No.);
                      RunPageLink=Campaign No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Segment;
                      PromotedCategory=Process }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=&Salgsmuligheder;
                                 ENU=Oppo&rtunities];
                      ToolTipML=[DAN=Vis salgsmuligheder for kampagnen.;
                                 ENU=View opportunities for the campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5123;
                      RunPageView=SORTING(Campaign No.);
                      RunPageLink=Campaign No.=FIELD(No.);
                      Image=OpportunitiesList }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=S&algspriser;
                                 ENU=Sales &Prices];
                      ToolTipML=[DAN=Definer, hvordan salgsprisaftaler skal oprettes. Salgspriserne kan g‘lde for individuelle debitorer, for debitorgrupper, for alle debitorer eller for en kampagne.;
                                 ENU=Define how to set up sales price agreements. These sales prices can be for individual customers, for a group of customers, for all customers, or for a campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 7002;
                      RunPageView=SORTING(Sales Type,Sales Code);
                      RunPageLink=Sales Type=CONST(Campaign),
                                  Sales Code=FIELD(No.);
                      Image=SalesPrices }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Salgsli&njerabatter;
                                 ENU=Sales &Line Discounts];
                      ToolTipML=[DAN=F† vist de tilg‘ngelige salgslinjerabatter. Disse rabataftaler kan g‘lde for individuelle debitorer, for debitorgrupper, for alle debitorer eller for en kampagne.;
                                 ENU=View the sales line discounts that are available. These discount agreements can be for individual customers, for a group of customers, for all customers or for a campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 7004;
                      RunPageView=SORTING(Sales Type,Sales Code);
                      RunPageLink=Sales Type=CONST(Campaign),
                                  Sales Code=FIELD(No.);
                      Image=SalesLineDisc }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 25      ;1   ;ActionGroup;
                      Name=Functions;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 26      ;2   ;Action    ;
                      Name=ActivateSalesPricesLineDisc;
                      CaptionML=[DAN=&Aktiver salgspriser/linjerabatter;
                                 ENU=&Activate Sales Prices/Line Discounts];
                      ToolTipML=[DAN=Aktiv‚r rabatter, der er knyttet til kampagnen.;
                                 ENU=Activate discounts that are associated with the campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=ActivateDiscounts;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CampaignMgmt.ActivateCampaign(Rec);
                               END;
                                }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=&Deaktiver salgspriser/linjerabatter;
                                 ENU=&Deactivate Sales Prices/Line Discounts];
                      ToolTipML=[DAN=Deaktiver rabatter, der er knyttet til kampagnen.;
                                 ENU=Deactivate discounts that are associated with the campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=DeactivateDiscounts;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CampaignMgmt.DeactivateCampaign(Rec,TRUE);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1904094006;1 ;Action    ;
                      CaptionML=[DAN=Kampagneoplysninger;
                                 ENU=Campaign Details];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om kampagnen.;
                                 ENU=Show detailed information about the campaign.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Report 5060;
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
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af kampagnen.;
                           ENU=Specifies the description of the campaign.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for kampagnen.;
                           ENU=Specifies the status code for the campaign.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Status Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvorfra kampagnen er gyldig. Der er bestemte regler for, hvordan datoer skal indtastes.;
                           ENU=Specifies the date on which the campaign is valid. There are certain rules for how dates should be entered.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Starting Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dato, hvor kampagnen er gyldig.;
                           ENU=Specifies the last day on which this campaign is valid.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Ending Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger, der er ansvarlig for kampagnen.;
                           ENU=Specifies the code of the salesperson responsible for the campaign.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Salesperson Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kampagnekortet sidst blev ‘ndret. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies the date when the campaign card was last modified. This field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Last Date Modified" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en salgslinjeprisrabat er aktiveret. N†r du har konfigureret en kampagne og oprettet m†lgrupper for den, kan du oprette rabatter for m†lgrupperne.;
                           ENU=Specifies if a sales lines price discount has been activated. After you set up a campaign and create segments for it, you can create discounts for targeted audiences.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Activated }

    { 1905885101;1;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Global Dimension 1 Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Global Dimension 2 Code" }

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
      CampaignMgmt@1000 : Codeunit 7030;

    BEGIN
    END.
  }
}

