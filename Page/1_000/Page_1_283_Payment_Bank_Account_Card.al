OBJECT Page 1283 Payment Bank Account Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Betalingsbankkontokort;
               ENU=Payment Bank Account Card];
    SourceTable=Table270;
    ActionList=ACTIONS
    {
      { 19      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oplysninger;
                                 ENU=Information];
                      Image=Customer }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Detaljerede oplysninger;
                                 ENU=Detailed Information];
                      ToolTipML=[DAN=F† vist eller rediger yderligere oplysninger om bankkontoen. Du kan ogs† kontrollere saldoen p† kontoen.;
                                 ENU=View or edit additional information about the bank account, such as the account. You can also check the balance on the account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 370;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=ViewDetails;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 4   ;0   ;Container ;
                ContainerType=ContentArea }

    { 5   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr="No.";
                ShowMandatory=True }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† din bank.;
                           ENU=Specifies the name of the bank where you have the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den bankkonto, der benyttes af banken.;
                           ENU=Specifies the number used by the bank for the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Account No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankkontoens internationale bankkontonummer.;
                           ENU=Specifies the bank account's international bank account number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=IBAN }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for bankkontobogf›ringsgruppe for bankkontoen.;
                           ENU=Specifies a code for the bank account posting group for the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Acc. Posting Group";
                ShowMandatory=True }

    { 23  ;2   ;Group     ;
                CaptionML=[DAN=Tolerance for betalingsmatch;
                           ENU=Payment Match Tolerance];
                GroupType=Group }

    { 22  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, med hvilken tolerance den automatiske betalingsudligningsfunktion indregner reglen Bel›b inkl. tolerance er matchet for denne bankkonto.;
                           ENU=Specifies by which tolerance the automatic payment application function will apply the Amount Incl. Tolerance Matched rule for this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Match Tolerance Type" }

    { 21  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om den automatiske betalingsudligningsfunktion indregner reglen Bel›b inkl. tolerance er matchet i procent eller bel›b.;
                           ENU=Specifies if the automatic payment application function will apply the Amount Incl. Tolerance Matched rule by Percentage or Amount.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:2;
                SourceExpr="Match Tolerance Value" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver formatet p† bankkontoudtogsfilen, der kan importeres til denne bankkonto.;
                           ENU=Specifies the format of the bank statement file that can be imported into this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Statement Import Format";
                ShowMandatory=True }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den relevante valutakode til bankkontoen.;
                           ENU=Specifies the relevant currency code for the bank account.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det sidste bankkontoudtog, der blev importeret som et feed eller en fil.;
                           ENU=Specifies the number of the last bank statement that was imported, either as a feed or a file.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Payment Statement No." }

    { 8   ;1   ;Group     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                GroupType=Group }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bankens telefonnummer.;
                           ENU=Specifies the telephone number of the bank where you have the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 10  ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver bankkontoens mailadresse.;
                           ENU=Specifies the email address associated with the bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den person i banken, der som regel kontaktes i forbindelse med denne konto.;
                           ENU=Specifies the name of the bank employee regularly contacted in connection with this bank account.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

  }
  CODE
  {

    BEGIN
    END.
  }
}

