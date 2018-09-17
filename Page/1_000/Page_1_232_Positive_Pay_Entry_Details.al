OBJECT Page 1232 Positive Pay Entry Details
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
    CaptionML=[DAN=Oplysninger om Positive Pay-betalingspost;
               ENU=Positive Pay Entry Details];
    SourceTable=Table1232;
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontonummeret. Hvis du v‘lger Saldo til dato, vises saldoen fra og med den sidste dag i det valgte tidsinterval.;
                           ENU=Specifies the bank account number. If you select Balance at Date, the balance as of the last day in the relevant time interval is displayed.];
                ApplicationArea=#Suite;
                SourceExpr="Bank Account No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Suite;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† checken.;
                           ENU=Specifies the number on the check.];
                ApplicationArea=#Suite;
                SourceExpr="Check No." }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel›bet p† linjen.;
                           ENU=Specifies the currency code for the amount on the line.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for bilaget p† linjen.;
                           ENU=Specifies the type of the document on the line.];
                ApplicationArea=#Suite;
                SourceExpr="Document Type" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Suite;
                SourceExpr="Document Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingsbel›bet.;
                           ENU=Specifies the payment amount.];
                ApplicationArea=#Suite;
                SourceExpr=Amount }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver betalingens modtager.;
                           ENU=Specifies the recipient of the payment.];
                ApplicationArea=#Suite;
                SourceExpr=Payee }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Suite;
                SourceExpr="User ID" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r Positive Pay-eksporten blev opdateret.;
                           ENU=Specifies when the Positive Pay export was updated.];
                ApplicationArea=#Suite;
                SourceExpr="Update Date" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

