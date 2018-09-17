OBJECT Page 606 IC G/L Account Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Koncerninternt finanskontokort;
               ENU=Intercompany G/L Account Card];
    SourceTable=Table410;
    PageType=Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=IC-k&onto;
                                 ENU=IC A&ccount];
                      Image=Intercompany }
      { 16      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+L;
                      CaptionML=[DAN=&Oversigt;
                                 ENU=&List];
                      ToolTipML=[DAN=Vis oversigten over koncerninterne finanskonti.;
                                 ENU=View the list of intercompany G/L accounts.];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 607;
                      Promoted=Yes;
                      Image=OpportunitiesList;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
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
                ApplicationArea=#Intercompany;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den koncerninterne finanskonto.;
                           ENU=Specifies the name of the IC general ledger account.];
                ApplicationArea=#Intercompany;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver form†let med kontoen. I alt: Bruges til at samment‘lle en r‘kke saldi p† konti fra mange forskellige grupper. Lad feltet st† tomt, hvis du vil bruge I alt. Fra-Sum: En markering af begyndelsen af en r‘kke konti, der skal samment‘lles og slutter med en Til-sum-konto. Til-sum: Det samlede antal konti, der starter med den foreg†ende Fra-sum-konto. Det samlede antal er defineret i feltet Samment‘lling.;
                           ENU=Specifies the purpose of the account. Total: Used to total a series of balances on accounts from many different account groupings. To use Total, leave this field blank. Begin-Total: A marker for the beginning of a series of accounts to be totaled that ends with an End-Total account. End-Total: A total of a series of accounts that starts with the preceding Begin-Total account. The total is defined in the Totaling field.];
                ApplicationArea=#Intercompany;
                SourceExpr="Account Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en finanskonto er en resultatopg›relseskonto eller en balancekonto.;
                           ENU=Specifies whether a general ledger account is an income statement account or a balance sheet account.];
                ApplicationArea=#Intercompany;
                SourceExpr="Income/Balance" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Intercompany;
                SourceExpr=Blocked }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiverÿnummeret p† den finanskonto i din kontoplan, som svarer til den koncerninterne finanskonto.;
                           ENU=Specifies the number of the G/L account in your chart of accounts that corresponds to this intercompany G/L account.];
                ApplicationArea=#Intercompany;
                SourceExpr="Map-to G/L Acc. No." }

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

