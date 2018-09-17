OBJECT Page 983 Payment Registration Details
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Oplysninger om betalingsregistrering;
               ENU=Payment Registration Details];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table981;
    DataCaptionExpr=PageCaption;
    PageType=ListPlus;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Naviger;
                                ENU=New,Process,Report,Navigate];
    OnOpenPage=BEGIN
                 PageCaption := '';
               END;

    OnAfterGetRecord=BEGIN
                       SetUserInteractions;
                     END;

    ActionList=ACTIONS
    {
      { 12      ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Nyt bilag;
                                 ENU=New Document] }
      { 24      ;2   ;Action    ;
                      Name=FinanceChargeMemo;
                      CaptionML=[DAN=Rentenota;
                                 ENU=Finance Charge Memo];
                      ToolTipML=[DAN=Opret en rentenota til kunden p† den valgte linje, for eksempel for at udstede en rentenota for sen betaling.;
                                 ENU=Create a finance charge memo for the customer on the selected line, for example, to issue a finance charge for late payment.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 446;
                      RunPageLink=Customer No.=FIELD(Source No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=FinChargeMemo;
                      RunPageMode=Create }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Naviger;
                                 ENU=Navigate] }
      { 18      ;2   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=Naviger;
                                 ENU=Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Navigate;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 3   ;1   ;Group     ;
                CaptionML=[DAN=Dokumentnavn;
                           ENU=Document Name];
                GroupType=Group }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den debitor eller kreditor, som betalingen relaterer til.;
                           ENU=Specifies the name of the customer or vendor that the payment relates to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name;
                Editable=FALSE;
                StyleExpr=TRUE;
                OnDrillDown=VAR
                              Customer@1000 : Record 18;
                            BEGIN
                              Customer.GET("Source No.");
                              PAGE.RUN(PAGE::"Customer Card",Customer);
                            END;
                             }

    { 2   ;1   ;Group     ;
                Name=Document Details;
                CaptionML=[DAN=Dokumentoplysninger;
                           ENU=Document Details];
                GroupType=Group }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bilag, som betalingen relaterer til.;
                           ENU=Specifies the number of the document that the payment relates to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No.";
                Editable=FALSE;
                OnDrillDown=BEGIN
                              Navigate;
                            END;
                             }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for det bilag, som betalingen relaterer til.;
                           ENU=Specifies the type of document that the payment relates to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den fakturatransaktion, som betalingen relaterer til.;
                           ENU=Specifies the invoice transaction that the payment relates to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for betalingen p† det tilknyttede bilag.;
                           ENU=Specifies the payment due date on the related document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date";
                Editable=FALSE;
                StyleExpr=DueDateStyle }

    { 8   ;1   ;Group     ;
                Name=Payment Discount;
                CaptionML=[DAN=Kontantrabat;
                           ENU=Payment Discount];
                GroupType=Group }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bel›bet i posten skal v‘re betalt, for at der kan opn†s kontantrabat.;
                           ENU=Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Pmt. Discount Date";
                StyleExpr=PmtDiscStyle;
                OnValidate=BEGIN
                             SetUserInteractions;
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, der mangler at blive betalt p† bilaget.;
                           ENU=Specifies the amount that remains to be paid on the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount";
                Editable=FALSE;
                StyleExpr=PmtDiscStyle }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver restbel›bet, efter kontantrabatten er fratrukket.;
                           ENU=Specifies the remaining amount after the payment discount is deducted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Rem. Amt. after Discount";
                Editable=FALSE }

    { 22  ;1   ;Group     ;
                CaptionML=[DAN=Advarsel;
                           ENU=Warning];
                GroupType=Group }

    { 21  ;2   ;Group     ;
                GroupType=FixedLayout }

    { 20  ;3   ;Group     ;
                GroupType=Group }

    { 16  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en advarsel om betalingen, f.eks. overskredet forfaldsdato.;
                           ENU=Specifies a warning about the payment, such as past due date.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Warning;
                Editable=FALSE;
                Style=Unfavorable;
                StyleExpr=TRUE;
                ShowCaption=No }

  }
  CODE
  {
    VAR
      PmtDiscStyle@1002 : Text;
      DueDateStyle@1000 : Text;
      Warning@1001 : Text;
      PageCaption@1003 : Text;

    LOCAL PROCEDURE SetUserInteractions@1();
    BEGIN
      PmtDiscStyle := GetPmtDiscStyle;
      DueDateStyle := GetDueDateStyle;
      Warning := GetWarning;
    END;

    BEGIN
    END.
  }
}

