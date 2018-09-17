OBJECT Page 1295 Posted Payment Reconciliation
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Bogf›rte betalingsafstemninger;
               ENU=Posted Payment Reconciliation];
    SaveValues=No;
    SourceTable=Table1295;
    PageType=Document;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Bank,Matching;
                                ENU=New,Process,Report,Bank,Matching];
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den bankkonto, som den bogf›rte betaling blev behandlet for.;
                           ENU=Specifies the number of the bank account that the posted payment was processed for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret af det bankkontoudtog, som indeholdte den linje, der repr‘senterede den bogf›rte betaling.;
                           ENU=Specifies the number of the bank statement that contained the line that represented the posted payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Statement No." }

    { 11  ;1   ;Part      ;
                Name=StmtLine;
                CaptionML=[DAN=Linjer;
                           ENU=Lines];
                ApplicationArea=#Basic,#Suite;
                SubPageLink=Bank Account No.=FIELD(Bank Account No.),
                            Statement No.=FIELD(Statement No.);
                PagePartID=Page1296;
                PartType=Page }

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

