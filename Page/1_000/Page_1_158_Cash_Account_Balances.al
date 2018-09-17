OBJECT Page 1158 Cash Account Balances
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
    CaptionML=[DAN=Saldo for kassekonto;
               ENU=Cash Account Balances];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table15;
    PageType=CardPart;
    OnOpenPage=BEGIN
                 SETRANGE("Account Category","Account Category"::Assets);
                 SETRANGE("Account Type","Account Type"::Posting);
                 SETRANGE("Account Subcategory Entry No.",3);
               END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                Name=No.;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                Name=Name;
                ToolTipML=[DAN=Angiver navnet p† kassekontoen.;
                           ENU=Specifies the name of the cash account.];
                ApplicationArea=#All;
                SourceExpr=Name }

    { 5   ;2   ;Field     ;
                Name=Balance;
                ToolTipML=[DAN=Angiver kassekontoens saldo.;
                           ENU=Specifies the balance of the cash account.];
                ApplicationArea=#All;
                SourceExpr=Balance;
                OnDrillDown=VAR
                              Company@2000 : Record 2000000006;
                              HyperLinkUrl@1000 : Text[500];
                            BEGIN
                              Company.GET(COMPANYNAME);
                              IF Company."Evaluation Company" THEN
                                HyperLinkUrl := GETURL(CLIENTTYPE::Web,COMPANYNAME,OBJECTTYPE::Page,20) +
                                  '&profile=BUSINESS%20MANAGER' + STRSUBSTNO(FilterForBalanceDrillDwnTxt,"No.")
                              ELSE
                                HyperLinkUrl := GETURL(CLIENTTYPE::Web,COMPANYNAME,OBJECTTYPE::Page,20) + STRSUBSTNO(FilterForBalanceDrillDwnTxt,"No.");
                              HYPERLINK(HyperLinkUrl);
                            END;
                             }

  }
  CODE
  {
    VAR
      FilterForBalanceDrillDwnTxt@1000 : TextConst '@@@=%1 - G/L Account record No. which data type of CODE.;DAN="&filter=''G/L Entry''.''G/L Account No.'' IS ''%1''";ENU="&filter=''G/L Entry''.''G/L Account No.'' IS ''%1''"';

    BEGIN
    END.
  }
}

