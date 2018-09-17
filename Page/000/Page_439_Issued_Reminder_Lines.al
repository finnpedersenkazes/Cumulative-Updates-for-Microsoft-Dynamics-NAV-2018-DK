OBJECT Page 439 Issued Reminder Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table298;
    PageType=ListPart;
    AutoSplitKey=Yes;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver linjetypen.;
                           ENU=Specifies the line type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for den debitorpost, som denne rykkerlinje vedr›rer.;
                           ENU=Specifies the posting date of the customer ledger entry that this reminder line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dokumenttypen for den debitorpost, rykkerlinjen vedr›rer.;
                           ENU=Specifies the document type of the customer ledger entry this reminder line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for den debitorpost, rykkerlinjen vedr›rer.;
                           ENU=Specifies the document number of the customer ledger entry this reminder line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for den debitorpost, denne rykkerlinje vedr›rer.;
                           ENU=Specifies the due date of the customer ledger entry this reminder line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en postbeskrivelse, som er baseret p† indholdet af feltet Type.;
                           ENU=Specifies an entry description, based on the contents of the Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det oprindelige bel›b for den debitorpost, som denne rykkerlinje vedr›rer.;
                           ENU=Specifies the original amount of the customer ledger entry that this reminder line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Original Amount";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det resterende bel›b for den debitorpost, rykkerlinjen vedr›rer.;
                           ENU=Specifies the remaining amount of the customer ledger entry this reminder line is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet i den valuta, der er angivet p† rykkeren.;
                           ENU=Specifies the amount in the currency of the reminder.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Rykkerniveau;
                           ENU=Reminder Level];
                ToolTipML=[DAN=Angiver et nummer, der angiver rykkerens niveau.;
                           ENU=Specifies a number that indicates the reminder level.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Reminders";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bogf›rt bilag, som dette bilag eller denne kladdelinje udlignes med, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-To Document Type";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bogf›rte bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Applies-To Document No.";
                Visible=FALSE }

    { 1101100000;2;Field  ;
                ToolTipML=[DAN=Angiver kontokoden for debitoren.;
                           ENU=Specifies the account code of the customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Code" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

