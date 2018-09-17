OBJECT Page 617 Handled IC Inbox Transactions
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=H†ndterede IC-indbakketransaktioner;
               ENU=Handled IC Inbox Transactions];
    InsertAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table420;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Funktioner,Udbakketransaktion;
                                ENU=New,Process,Report,Functions,Outbox Transaction];
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Indbakketransaktion;
                                 ENU=&Inbox Transaction];
                      Image=Import }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Detaljer;
                                 ENU=Details];
                      ToolTipML=[DAN=F† vist transaktionsdetaljer.;
                                 ENU=View transaction details.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDetails;
                               END;
                                }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Bem‘rkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 620;
                      RunPageLink=Table Name=CONST(Handled IC Inbox Transaction),
                                  Transaction No.=FIELD(Transaction No.),
                                  IC Partner Code=FIELD(IC Partner Code),
                                  Transaction Source=FIELD(Transaction Source);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 25      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 28      ;2   ;Action    ;
                      CaptionML=[DAN=Genopret indbakketransaktion;
                                 ENU=Re-create Inbox Transaction];
                      ToolTipML=[DAN=Gendanner en transaktion i indbakken. Hvis du f.eks. har accepteret en transaktion i indbakken, men efterf›lgende har slettet dokumentet eller kladden i stedet for at bogf›re den/det, kan du gendanne indbakkeposten og acceptere den igen.;
                                 ENU=Re-creates a transaction in the inbox. For example, if you accepted a transaction in your inbox but then deleted the document or journal instead of posting it, you can re-create the inbox entry and accept it again.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=NewStatusChange;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 InboxOutboxMgt@1000 : Codeunit 427;
                               BEGIN
                                 InboxOutboxMgt.RecreateInboxTransaction(Rec);
                                 CurrPage.UPDATE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transaktionens l›benummer.;
                           ENU=Specifies the transaction's entry number.];
                ApplicationArea=#Intercompany;
                SourceExpr="Transaction No.";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncerninterne partner, som transaktionen er relateret til, hvis posten blev oprettet fra en koncernintern transaktion.;
                           ENU=Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken handling der er blevet foretaget for transaktionen.;
                           ENU=Specifies what action has been taken on the transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr=Status;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen blev oprettet i en kladde, et salgsdokument eller et k›bsdokument.;
                           ENU=Specifies whether the transaction was created in a journal, a sales document, or a purchase document.];
                ApplicationArea=#Intercompany;
                SourceExpr="Source Type";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver type af det relaterede bilag.;
                           ENU=Specifies the type of the related document.];
                ApplicationArea=#Intercompany;
                SourceExpr="Document Type";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det relaterede bilag.;
                           ENU=Specifies the number of the related document.];
                ApplicationArea=#Intercompany;
                SourceExpr="Document No.";
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Intercompany;
                SourceExpr="Posting Date";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken virksomhed der har oprettet transaktionen.;
                           ENU=Specifies which company created the transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="Transaction Source";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Intercompany;
                SourceExpr="Document Date";
                Editable=FALSE }

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

