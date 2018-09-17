OBJECT Page 612 IC Outbox Jnl. Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kladdelinjer i IC-udbakke;
               ENU=IC Outbox Jnl. Lines];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table415;
    DataCaptionFields=IC Partner Code;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 6       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 7       ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=&Dimensioner;
                                 ENU=&Dimensions];
                      ToolTipML=[DAN=F† vist eller rediger dimensioner som f.eks. omr†de, projekt eller afdeling, som du kan tildele til kladdelinjer for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 619;
                      RunPageLink=Table ID=CONST(415),
                                  Transaction No.=FIELD(Transaction No.),
                                  IC Partner Code=FIELD(IC Partner Code),
                                  Transaction Source=FIELD(Transaction Source),
                                  Line No.=FIELD(Line No.);
                      Promoted=Yes;
                      Image=Dimensions;
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
                ToolTipML=[DAN=Angiver koden for den koncerninterne partner, som transaktionen er relateret til, hvis posten blev oprettet fra en koncernintern transaktion.;
                           ENU=Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontoens form†l. Nyoprettede konti f†r automatisk tildelt kontotypen Konto, men dette kan ‘ndres.;
                           ENU=Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this.];
                ApplicationArea=#Intercompany;
                SourceExpr="Account Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kontonummer, som posten i kladdelinjen skal inds‘ttes p†.;
                           ENU=Specifies the account number that the entry on the journal line will be posted to.];
                ApplicationArea=#Intercompany;
                SourceExpr="Account No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af transaktionen p† kladdelinjen.;
                           ENU=Specifies a description for the transaction on the journal line.];
                ApplicationArea=#Intercompany;
                SourceExpr=Description }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bruttobel›b (bel›b inkl. moms), der er indeholdt i kladdelinjen.;
                           ENU=Specifies the total amount (including VAT) that the journal line consists of.];
                ApplicationArea=#Intercompany;
                SourceExpr=Amount }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsbel›bet, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of VAT that is included in the total amount.];
                ApplicationArea=#Intercompany;
                SourceExpr="VAT Amount";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt i posten.;
                           ENU=Specifies the currency that is used on the entry.];
                ApplicationArea=#Intercompany;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r den relaterede faktura skal betales.;
                           ENU=Specifies when the related invoice must be paid.];
                ApplicationArea=#Intercompany;
                SourceExpr="Due Date" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis du betaler p† eller f›r den dato, der er angivet i feltet Kont.rabatdato. Rabatprocenten er angivet i feltet Betalingsbetingelseskode.;
                           ENU=Specifies the payment discount percentage that is granted if you pay on or before the date entered in the Pmt. Discount Date field. The discount percentage is specified in the Payment Terms Code field.];
                ApplicationArea=#Intercompany;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den sidste dato, hvor bel›bet p† kladdelinjen senest skal betales, hvis der skal opn†s kontantrabat p† ordren, og linjen er en fakturakladdelinje.;
                           ENU=Specifies the last date on which the amount in the journal line must be paid for the order to qualify for a payment discount if the line is an invoice journal line.];
                ApplicationArea=#Intercompany;
                SourceExpr="Payment Discount Date";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen der er angivet p† linjen.;
                           ENU=Specifies how many units of the item are specified on the line.];
                ApplicationArea=#Intercompany;
                SourceExpr=Quantity;
                Visible=FALSE }

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

