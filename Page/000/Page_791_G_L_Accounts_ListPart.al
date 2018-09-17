OBJECT Page 791 G/L Accounts ListPart
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
    CaptionML=[DAN=Finanskontis ListPart;
               ENU=G/L Accounts ListPart];
    SourceTable=Table15;
    SourceTableView=WHERE(Account Type=CONST(Posting));
    PageType=ListPart;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† recorden.;
                           ENU=Specifies the name of the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om finanskontoen er en resultatopg›relseskonto eller en balancekonto.;
                           ENU=Specifies is the general ledger account is an income statement account or a balance sheet account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Income/Balance" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

