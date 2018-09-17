OBJECT Page 592 Change Log Setup
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ops‘tning af ‘ndringslog;
               ENU=Change Log Setup];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table402;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Ops‘tning;
                                ENU=New,Process,Report,Setup];
    OnOpenPage=BEGIN
                 RESET;
                 IF NOT GET THEN BEGIN
                   INIT;
                   INSERT;
                 END;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ops‘tning;
                                 ENU=&Setup];
                      Image=Setup }
      { 6       ;2   ;Action    ;
                      Name=Tables;
                      CaptionML=[DAN=Tabeller;
                                 ENU=Tables];
                      ToolTipML=[DAN=F† vist, hvad der skal logf›res for hver tabel.;
                                 ENU=View what must be logged for each table.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Table;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ChangeLogSetupList@1000 : Page 593;
                               BEGIN
                                 ChangeLogSetupList.SetSource;
                                 ChangeLogSetupList.RUNMODAL;
                               END;
                                }
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
                ToolTipML=[DAN=Angiver, at ‘ndringsloggen er aktiv.;
                           ENU=Specifies that the change log is active.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Change Log Activated" }

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

