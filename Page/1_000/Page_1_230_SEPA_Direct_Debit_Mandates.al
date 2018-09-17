OBJECT Page 1230 SEPA Direct Debit Mandates
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=SEPA Direct Debit-betalingsaftaler;
               ENU=SEPA Direct Debit Mandates];
    SourceTable=Table1230;
    DataCaptionFields=ID,Customer No.,Customer Bank Account Code;
    PageType=List;
    OnNewRecord=BEGIN
                  IF "Customer No." = '' THEN
                    IF GETFILTER("Customer No.") <> '' THEN
                      VALIDATE("Customer No.",GETRANGEMIN("Customer No."));
                  IF "Customer Bank Account Code" = '' THEN
                    IF GETFILTER("Customer Bank Account Code") <> '' THEN
                      VALIDATE("Customer Bank Account Code",GETRANGEMIN("Customer Bank Account Code"));
                END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for Direct Debit-betalingsaftalen.;
                           ENU=Specifies the ID of the direct-debit mandate.];
                ApplicationArea=#Suite;
                SourceExpr=ID }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den debitor, som Direct Debit-betalingsaftalen er aktiveret for.;
                           ENU=Specifies the customer that the direct-debit mandate is activated for.];
                ApplicationArea=#Advanced;
                SourceExpr="Customer No.";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den debitorbankkonto, som Direct Debit-betalingsaftalen er aktiveret for.;
                           ENU=Specifies customer bank account that the direct-debit mandate is activated for.];
                ApplicationArea=#Suite;
                SourceExpr="Customer Bank Account Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen, hvor Direct Debit-betalingsaftalen tr‘der i kraft.;
                           ENU=Specifies the date when the direct-debit mandate starts.];
                ApplicationArea=#Suite;
                SourceExpr="Valid From" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen, hvor Direct Debit-betalingsaftalen udl›ber.;
                           ENU=Specifies the date when the direct-debit mandate ends.];
                ApplicationArea=#Suite;
                SourceExpr="Valid To" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r Direct Debit-betalingsaftalen blev signeret af debitoren.;
                           ENU=Specifies when the direct-debit mandate was signed by the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Date of Signature" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om Direct Debit-transaktionen er den f›rste eller sidste if›lge det forventede antal Direct Debit-transaktioner, som du har angivet i feltet Forventet antal debiteringer.;
                           ENU=Specifies if the direct-debit transaction is the first or the last according to the expected number of direct-debit transactions that you entered in the Expected Number of Debits field.];
                ApplicationArea=#Suite;
                SourceExpr="Type of Payment" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange Direct Debit-transaktioner du forventer at udf›re ved hj‘lp af Direct Debit-betalingsaftalen. Dette felt bruges til at beregne, hvorn†r der skal angives F›rste eller Sidste i feltet Sekvenstype i vinduet Poster i Direct Debit-opkr‘vning.;
                           ENU=Specifies how many direct-debit transactions you expect to perform using the direct-debit mandate. This field is used to calculate when to enter First or Last in the Sequence Type field in the Direct Debit Collect. Entries window.];
                ApplicationArea=#Suite;
                SourceExpr="Expected Number of Debits" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange Direct Debit-transaktioner, der er udf›rt ved hj‘lp af Direct Debit-betalingsaftalen.;
                           ENU=Specifies how many direct-debit transactions have been performed using the direct-debit mandate.];
                ApplicationArea=#Suite;
                SourceExpr="Debit Counter";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Suite;
                SourceExpr=Blocked }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at Direct Debit-betalingsaftalen er lukket, f.eks. fordi datoen i feltet Gyldig til er overskredet.;
                           ENU=Specifies that the direct-debit mandate is closed, for example because the date in the Valid To field has been exceeded.];
                ApplicationArea=#Suite;
                SourceExpr=Closed }

    { 13  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 14  ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

    { 15  ;1   ;Part      ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

