OBJECT Page 9084 Customer Details FactBox
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitoroplysninger;
               ENU=Customer Details];
    SourceTable=Table18;
    PageType=CardPart;
    OnInit=BEGIN
             ShowCustomerNo := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       StyleTxt := SetStyle;
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Handlinger;
                                 ENU=Actions];
                      Image=Action }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Leveringsadresse;
                                 ENU=Ship-to Address];
                      ToolTipML=[DAN=Vis den leveringsadresse, der er angivet for debitoren.;
                                 ENU=View the ship-to address that is specified for the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 301;
                      RunPageLink=Customer No.=FIELD(No.) }
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Bem�rkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Customer),
                                  No.=FIELD(No.);
                      Image=ViewComments }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 11  ;1   ;Field     ;
                CaptionML=[DAN=Debitornr.;
                           ENU=Customer No.];
                ToolTipML=[DAN=Angiver debitorens nummer. Feltet udfyldes enten automatisk fra en defineret nummerserie, eller du kan indtaste nummeret manuelt, fordi du har aktiveret manuel nummerindtastning i ops�tningen af nummerserier.;
                           ENU=Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Visible=ShowCustomerNo;
                OnDrillDown=BEGIN
                              ShowDetails;
                            END;
                             }

    { 16  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer's telephone number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Phone No." }

    { 1   ;1   ;Field     ;
                ExtendedDatatype=E-Mail;
                ToolTipML=[DAN=Angiver debitorens mailadresse.;
                           ENU=Specifies the customer's email address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="E-Mail" }

    { 18  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens faxnummer.;
                           ENU=Specifies the customer's fax number.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Fax No." }

    { 3   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver det maksimale bel�b, som du tillader, at debitoren overskrider betalingssaldoen med, f�r der udstedes advarsler.;
                           ENU=Specifies the maximum amount you allow the customer to exceed the payment balance before warnings are issued.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Credit Limit (LCY)";
                StyleExpr=StyleTxt }

    { 2   ;1   ;Field     ;
                Name=AvailableCreditLCY;
                CaptionML=[DAN=Disponibel kredit (RV);
                           ENU=Available Credit (LCY)];
                ToolTipML=[DAN=Angiver en debitors disponible kredit. Hvis den tilg�ngelige kredit er 0, og debitorens kreditgr�nse ogs� er 0, har debitoren ubegr�nset kredit, eftersom der ikke er defineret nogen kreditgr�nse.;
                           ENU=Specifies a customer's available credit. If the available credit is 0 and the customer's credit limit is also 0, then the customer has unlimited credit because no credit limit has been defined.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CalcAvailableCreditUI;
                OnDrillDown=BEGIN
                              PAGE.RUN(PAGE::"Available Credit",Rec);
                            END;
                             }

    { 5   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbel�b.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code" }

    { 7   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� en fast kontakt hos debitoren.;
                           ENU=Specifies the name of the person you regularly contact when you do business with this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Contact }

  }
  CODE
  {
    VAR
      StyleTxt@1000 : Text;
      ShowCustomerNo@1001 : Boolean;

    LOCAL PROCEDURE ShowDetails@1102601000();
    BEGIN
      PAGE.RUN(PAGE::"Customer Card",Rec);
    END;

    [External]
    PROCEDURE SetCustomerNoVisibility@1(Visible@1000 : Boolean);
    BEGIN
      ShowCustomerNo := Visible;
    END;

    BEGIN
    END.
  }
}

