OBJECT Page 9075 RapidStart Services Activities
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Aktiviteter;
               ENU=Activities];
    SourceTable=Table9061;
    PageType=CardPart;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;

                 SETFILTER("User ID Filter",USERID);
               END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Tabeller;
                           ENU=Tables];
                GroupType=CueGroup }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af konfigurationstabeller, der er opgraderet. Bilagene filtreres efter dags dato.;
                           ENU=Specifies the number of configuration tables that have been promoted. The documents are filtered by today's date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Promoted;
                DrillDownPageID=Config. Tables }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af konfigurationstabeller, der er ikke er startet. Bilagene filtreres efter dags dato.;
                           ENU=Specifies the number of configuration tables that have not been started. The documents are filtered by today's date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Not Started";
                DrillDownPageID=Config. Tables }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af konfigurationstabeller, der er i gang. Bilagene filtreres efter dags dato.;
                           ENU=Specifies the number of configuration tables that are in progress. The documents are filtered by today's date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="In Progress";
                DrillDownPageID=Config. Tables }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af konfigurationstabeller, der er fuldf›rt. Bilagene filtreres efter dags dato.;
                           ENU=Specifies the number of configuration tables that have been completed. The documents are filtered by today's date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Completed;
                DrillDownPageID=Config. Tables }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af konfigurationstabeller, som du har udpeget til at blive ignoreret. Bilagene filtreres efter dags dato.;
                           ENU=Specifies the number of configuration tables that you have designated to be ignored. The documents are filtered by today's date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Ignored;
                DrillDownPageID=Config. Tables }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Blocked;
                DrillDownPageID=Config. Tables }

    { 9   ;1   ;Group     ;
                CaptionML=[DAN=Mine brugeropgaver;
                           ENU=My User Tasks];
                GroupType=CueGroup }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Ventende brugeropgaver;
                           ENU=Pending User Tasks];
                ToolTipML=[DAN=Angiver det antal ventende opgaver, som du er blevet tildelt.;
                           ENU=Specifies the number of pending tasks that are assigned to you.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pending Tasks";
                DrillDownPageID=User Task List;
                Image=Checklist }

  }
  CODE
  {

    BEGIN
    END.
  }
}

