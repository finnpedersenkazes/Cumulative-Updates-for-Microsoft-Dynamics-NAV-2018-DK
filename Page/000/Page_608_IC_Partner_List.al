OBJECT Page 608 IC Partner List
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
    CaptionML=[DAN=Koncerninterne partnere;
               ENU=Intercompany Partners];
    SourceTable=Table413;
    PageType=List;
    CardPageID=IC Partner Card;
    OnOpenPage=VAR
                 CompanyInformation@1000 : Record 79;
               BEGIN
                 CompanyInformation.GET;
                 IF CompanyInformation."IC Partner Code" = '' THEN
                   IF CONFIRM(SetupICQst) THEN
                     PAGE.RUNMODAL(PAGE::"IC Setup");

                 CompanyInformation.FIND;
                 IF CompanyInformation."IC Partner Code" = '' THEN
                   ERROR('');
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=IC-&partner;
                                 ENU=IC &Partner];
                      Image=ICPartner }
      { 27      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - enkelt;
                                 ENU=Dimensions-Single];
                      ToolTipML=[DAN=F† vist eller rediger de enkelte s‘t af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(413),
                                  No.=FIELD(Code);
                      Promoted=Yes;
                      Image=Dimensions;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
      { 9       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Koncernintern ops‘tning;
                                 ENU=Intercompany Setup];
                      ToolTipML=[DAN=Se eller rediger koncernintern ops‘tning for den aktuelle virksomhed.;
                                 ENU=View or edit the intercompany setup for the current company.];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 621;
                      Promoted=Yes;
                      Image=Intercompany;
                      PromotedCategory=Process;
                      PromotedOnly=Yes }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den koncerninterne partnerkode.;
                           ENU=Specifies the intercompany partner code.];
                ApplicationArea=#Intercompany;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den koncerninterne partner.;
                           ENU=Specifies the name of the intercompany partner.];
                ApplicationArea=#Intercompany;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#Intercompany;
                SourceExpr="Currency Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type indbakke den koncerninterne partner har. Filplacering. Du sender partneren en fil, der indeholder koncerninterne transaktioner. Database: Partneren konfigureres som en anden virksomhed i den samme database. Mail. Du sender partnertransaktionerne pr. mail.;
                           ENU=Specifies what type of inbox the intercompany partner has. File Location. You send the partner a file containing intercompany transactions. Database: The partner is set up as another company in the same database. Email: You send the partner transactions by email.];
                ApplicationArea=#Advanced;
                SourceExpr="Inbox Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysningerne om den koncerninterne partners indbakke.;
                           ENU=Specifies the details of the intercompany partner's inbox.];
                ApplicationArea=#Intercompany;
                SourceExpr="Inbox Details" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktioner fra denne partner accepteres automatisk.;
                           ENU=Specifies if transactions from this partner will be accepted automatically.];
                ApplicationArea=#Intercompany;
                SourceExpr="Auto. Accept Transactions" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den debitor, som er tilknyttet denne koncerninterne partner.;
                           ENU=Specifies the customer number that this intercompany partner is linked to.];
                ApplicationArea=#Intercompany;
                SourceExpr="Customer No." }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, som er tilknyttet denne koncerneinterne partner.;
                           ENU=Specifies the vendor number that this intercompany partner is linked to.];
                ApplicationArea=#Intercompany;
                SourceExpr="Vendor No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer tilgodehavender fra debitorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post receivables from customers in this posting group.];
                ApplicationArea=#Intercompany;
                SourceExpr="Receivables Account" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† finanskontoen, du skal bruge, n†r du bogf›rer betalinger til kreditorer i denne bogf›ringsgruppe.;
                           ENU=Specifies the general ledger account to use when you post payables due to vendors in this posting group.];
                ApplicationArea=#Intercompany;
                SourceExpr="Payables Account" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Intercompany;
                SourceExpr=Blocked }

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
      SetupICQst@1000 : TextConst 'DAN=Koncerninterne oplysninger er ikke konfigureret for din virksomhed.\\Vil du konfigurere dem nu?;ENU=Intercompany information is not set up for your company.\\Do you want to set it up now?';

    [Internal]
    PROCEDURE GetSelectionFilter@4() : Text;
    VAR
      Partner@1001 : Record 413;
      SelectionFilterManagement@1002 : Codeunit 46;
    BEGIN
      CurrPage.SETSELECTIONFILTER(Partner);
      EXIT(SelectionFilterManagement.GetSelectionFilterForICPartner(Partner));
    END;

    BEGIN
    END.
  }
}

