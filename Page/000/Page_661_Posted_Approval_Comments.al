OBJECT Page 661 Posted Approval Comments
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
    CaptionML=[DAN=Bogf›rte godkendelsesbem‘rkninger;
               ENU=Posted Approval Comments];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table457;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       PostedRecordID := FORMAT("Posted Record ID",0,1);
                     END;

    OnAfterGetCurrRecord=BEGIN
                           PostedRecordID := FORMAT("Posted Record ID",0,1);
                         END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No.";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et p† den bruger, der oprettede denne godkendelsesbem‘rkning.;
                           ENU=Specifies the ID of the user who created this approval comment.];
                ApplicationArea=#Advanced;
                SourceExpr="User ID";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kommentaren. Du kan bruge op til 250 tegn (b†de tal og bogstaver).;
                           ENU=Specifies the comment. You can enter a maximum of 250 characters, both numbers and letters.];
                ApplicationArea=#Suite;
                SourceExpr=Comment }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret p† det tilbud, den ordre, faktura, kreditnota, returvareordre eller rammeordre, som bem‘rkningen vedr›rer.;
                           ENU=Specifies the document number of the quote, order, invoice, credit memo, return order, or blanket order that the comment applies to.];
                ApplicationArea=#Suite;
                SourceExpr="Document No." }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dato og klokkesl‘t for oprettelsen af bem‘rkningen.;
                           ENU=Specifies the date and time that the comment was made.];
                ApplicationArea=#Suite;
                SourceExpr="Date and Time" }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Godkendt;
                           ENU=Approved];
                ToolTipML=[DAN=Angiver, om godkendelsesanmodningen er blevet godkendt.;
                           ENU=Specifies that the approval request has been approved.];
                ApplicationArea=#Suite;
                SourceExpr=PostedRecordID }

  }
  CODE
  {
    VAR
      PostedRecordID@1000 : Text;

    BEGIN
    END.
  }
}

