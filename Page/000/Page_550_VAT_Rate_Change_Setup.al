OBJECT Page 550 VAT Rate Change Setup
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfiguration af ‘ndring af momssats;
               ENU=VAT Rate Change Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table550;
    PageType=Card;
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
               END;

    ActionList=ACTIONS
    {
      { 18      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ops‘tning;
                                 ENU=S&etup];
                      Image=Setup }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Konv. momsproduktbogf.gruppe;
                                 ENU=VAT Prod. Posting Group Conv.];
                      ToolTipML=[DAN=Vis eller rediger momsproduktbogf›ringsgrupper for konvertering af momssats‘ndring. Momsproduktbogf›ringsgruppen bestemmer beregningen og bogf›ringen af moms i overensstemmelse med den vare- eller ressourcetype, der k›bes, eller den vare- eller ressourcetype, der s‘lges. Vinduet indeholder for hver konvertering af momsproduktbogf›ringsgruppe en linje, hvor du skal angive, om den aktuelle bogf›ringsgruppe opdateres med den nye bogf›ringsgruppe.;
                                 ENU=View or edit the VAT product posting groups for VAT rate change conversion. The VAT product group codes determine calculation and posting of VAT according to the type of item or resource being purchased or the type of item or resource being sold. For each VAT product posting group conversion, the window contains a line where you specify if the current posting group will be updated by the new posting group.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 551;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Registered;
                      PromotedCategory=Process }
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=Konv. produktbogf.grp.;
                                 ENU=Gen. Prod. Posting Group Conv.];
                      ToolTipML=[DAN=Vis eller rediger generelle produktbogf›ringsgrupper for konvertering af momssats‘ndring. Den generelle produktbogf›ringsgruppes koder bestemmer bogf›ringen i overensstemmelse med den vare- og ressourcetype, der k›bes eller s‘lges. Vinduet indeholder for hver konvertering af den generelle produktbogf›ringsgruppe en linje, hvor du skal angive den aktuelle bogf›ringsgruppe, der opdateres med den nye bogf›ringsgruppe.;
                                 ENU=View or edit the general product posting groups for VAT rate change conversion. The general product posting group codes determine posting according to the type of item and resource being purchased or sold. For each general product posting group conversion, the window contains a line where you specify the current posting group that will be updated by the new posting group.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 552;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GeneralPostingSetup;
                      PromotedCategory=Process }
      { 39      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&unktion;
                                 ENU=F&unction];
                      Image=Action }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=&Konverter;
                                 ENU=&Convert];
                      ToolTipML=[DAN=Konverter den valgte momssats.;
                                 ENU=Convert the selected VAT rate.];
                      ApplicationArea=#Advanced;
                      RunObject=Codeunit 550;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=’ndringslogposter for momssats;
                                 ENU=VAT Rate Change Log Entries];
                      ToolTipML=[DAN=Den generelle produktbogf›ringsgruppes koder bestemmer bogf›ringen i overensstemmelse med den vare- og ressourcetype, der k›bes eller s‘lges. Vinduet indeholder for hver konvertering af den generelle produktbogf›ringsgruppe en linje, hvor du skal angive den aktuelle bogf›ringsgruppe, der opdateres med den nye bogf›ringsgruppe.;
                                 ENU=The general product posting group codes determine posting according to the type of item and resource being purchased or sold. For each general product posting group conversion, the window contains a line where you specify the current posting group that will be updated by the new posting group.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 553;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ChangeLog;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om konvertering af momssats‘ndring er fuldf›rt.;
                           ENU=Specifies if the VAT rate change conversion is complete.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Rate Change Tool Completed" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der er udf›rt konvertering af momssats p† eksisterende data.;
                           ENU=Specifies that the VAT rate conversion is performed on existing data.];
                ApplicationArea=#Advanced;
                SourceExpr="Perform Conversion" }

    { 9   ;1   ;Group     ;
                CaptionML=[DAN=Stamdata;
                           ENU=Master Data];
                GroupType=Group }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† finanskontiene.;
                           ENU=Specifies the VAT rate change for general ledger accounts.];
                ApplicationArea=#Advanced;
                SourceExpr="Update G/L Accounts" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke konti der vil blive opdateret ved indstilling af de relevante filtre.;
                           ENU=Specifies which accounts will be updated by setting appropriate filters.];
                ApplicationArea=#Advanced;
                SourceExpr="Account Filter";
                OnLookup=BEGIN
                           EXIT(LookUpGLAccountFilter(Text));
                         END;
                          }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† varerne.;
                           ENU=Specifies the VAT rate change for items.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Items" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke varer der vil blive opdateret ved indstilling af de relevante filtre.;
                           ENU=Specifies which items will be updated by setting appropriate filters.];
                ApplicationArea=#Advanced;
                SourceExpr="Item Filter";
                OnLookup=BEGIN
                           EXIT(LookUpItemFilter(Text));
                         END;
                          }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† ressourcerne.;
                           ENU=Specifies the VAT rate change for resources.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Resources" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke ressourcer der vil blive opdateret ved indstilling af de relevante filtre.;
                           ENU=Specifies which resources will be updated by setting appropriate filters.];
                ApplicationArea=#Advanced;
                SourceExpr="Resource Filter";
                OnLookup=BEGIN
                           EXIT(LookUpResourceFilter(Text));
                         END;
                          }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at ‘ndringer af momssats er opdateret for varekategorier.;
                           ENU=Specifies that VAT rate changes are updated for item categories.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Item Templates" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring for varegebyrer.;
                           ENU=Specifies the VAT rate change for item charges.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Update Item Charges" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† produktbogf›ringsgrupper.;
                           ENU=Specifies the VAT rate change for general product posting groups.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Gen. Prod. Post. Groups" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring for serviceprisreguleringsoplysningerne.;
                           ENU=Specifies the VAT rate change for service price adjustment detail.];
                ApplicationArea=#Service;
                SourceExpr="Update Serv. Price Adj. Detail" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring for arbejdscentre.;
                           ENU=Specifies the VAT rate change for work centers.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Update Work Centers" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring for maskincentre.;
                           ENU=Specifies the VAT rate change for machine centers.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Update Machine Centers" }

    { 37  ;1   ;Group     ;
                CaptionML=[DAN=Kladder;
                           ENU=Journals];
                GroupType=Group }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† finanskladdelinjerne.;
                           ENU=Specifies the VAT rate change for general journal lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Gen. Journal Lines" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring for finanskladdeallokering.;
                           ENU=Specifies the VAT rate change for general journal allocation.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Gen. Journal Allocation" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† standardfinanskladdelinjer.;
                           ENU=Specifies the VAT rate change for standard general journal lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Std. Gen. Jnl. Lines" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† ressourcekladdelinjerne.;
                           ENU=Specifies the VAT rate change for resource journal lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Res. Journal Lines" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† sagskladdelinjerne.;
                           ENU=Specifies the VAT rate change for job journal lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Job Journal Lines" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† rekvisitionslinjerne.;
                           ENU=Specifies the VAT rate change for requisition lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Requisition Lines" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† standardvarekladdelinjer.;
                           ENU=Specifies the VAT rate change for standard item journal lines.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Std. Item Jnl. Lines" }

    { 27  ;1   ;Group     ;
                CaptionML=[DAN=Dokumenter;
                           ENU=Documents];
                GroupType=Group }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† salgsdokumenter.;
                           ENU=Specifies the VAT rate change for sales documents.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Sales Documents" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at alle eksisterende salgsdokumenter, uanset status, herunder bilag med Frigivet som status, er opdateret.;
                           ENU=Specifies that all existing sales documents regardless of status, including documents with a status of released, are updated.];
                ApplicationArea=#Advanced;
                SourceExpr="Ignore Status on Sales Docs." }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† k›bsdokumenter.;
                           ENU=Specifies the VAT rate change for purchase documents.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Purchase Documents" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at alle eksisterende k›bsdokumenter, uanset status, herunder bilag med Frigivet som status, er opdateret.;
                           ENU=Specifies all existing purchase documents regardless of status, including documents with a status of released, are updated.];
                ApplicationArea=#Advanced;
                SourceExpr="Ignore Status on Purch. Docs." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring for servicelinjer.;
                           ENU=Specifies the VAT rate change for service lines.];
                ApplicationArea=#Service;
                SourceExpr="Update Service Docs." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at alle eksisterende servicedokumenter uanset frigivelsesstatus opdateres.;
                           ENU=Specifies that all existing service documents regardless of release status are updated.];
                ApplicationArea=#Service;
                SourceExpr="Ignore Status on Service Docs." }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† produktionsordrer.;
                           ENU=Specifies the VAT rate change for production orders.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Update Production Orders" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring p† rykkere.;
                           ENU=Specifies the VAT rate change for reminders.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Reminders" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver konvertering af momssats‘ndring for rentenotaer.;
                           ENU=Specifies the VAT rate change for finance charge memos.];
                ApplicationArea=#Advanced;
                SourceExpr="Update Finance Charge Memos" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

