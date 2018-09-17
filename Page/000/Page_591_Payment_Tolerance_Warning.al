OBJECT Page 591 Payment Tolerance Warning
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Betalingstolerance - advarsel;
               ENU=Payment Tolerance Warning];
    PageType=ConfirmationDialog;
    InstructionalTextML=[DAN=Der kr‘ves en handling vedr›rende advarsel om betalingstolerance.;
                         ENU=An action is requested regarding the Payment Tolerance Warning.];
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 Posting := Posting::"Remaining Amount";

                 UpdateAmounts;
               END;

    OnQueryClosePage=BEGIN
                       IF CloseAction = ACTION::No THEN
                         NoOnPush;
                       IF CloseAction = ACTION::Yes THEN
                         YesOnPush;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 3   ;1   ;Field     ;
                CaptionML=[DAN=V‘lg, hvad du vil g›re med saldobel›bet:;
                           ENU=Regarding the Balance amount, do you want to:];
                OptionCaptionML=[DAN=,Vil du bogf›re saldoen som betalingstolerance?,Vil du efterlade et restbel›b?;
                                 ENU=,Post the Balance as Payment Tolerance?,Leave a Remaining Amount?];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Posting;
                OnValidate=BEGIN
                             UpdateAmounts;
                           END;
                            }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Detaljer;
                           ENU=Details] }

    { 1   ;2   ;Group     ;
                Visible=Posting = Posting::"Payment Tolerance Accounts";
                GroupType=Group;
                InstructionalTextML=[DAN=Hvis du bogf›rer denne udligning, opst†r der en udest†ende saldo. Du kan lukke alle poster ved at bogf›re saldoen som et betalingstolerancebel›b.;
                                     ENU=Posting this application will create an outstanding balance. You can close all entries by posting the balance as a payment tolerance amount.];
                Layout=Rows }

    { 4   ;2   ;Group     ;
                Visible=Posting = Posting::"Remaining Amount";
                GroupType=Group;
                InstructionalTextML=[DAN=Bogf›ringen af denne udligning behandles som en delvis betaling med en resterende saldo. Dokumentet lukkes ikke.;
                                     ENU=Posting this application will be handled as a partial payment with a remaining balance. The document will not be closed.] }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Bogf›ringsdato;
                           ENU=Posting Date];
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for det bilag, der skal betales.;
                           ENU=Specifies the posting date of the document to be paid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=PostingDate;
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                CaptionML=[DAN=Nej.;
                           ENU=No.];
                ToolTipML=[DAN=Angiver nummeret p† den record, som betalingstoleranceadvarslen henviser til.;
                           ENU=Specifies the number of the record that the payment tolerance warning refers to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CustVendNo;
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                CaptionML=[DAN=Bilagsnr.;
                           ENU=Document No.];
                ToolTipML=[DAN=Angiver det bilag, som betalingen d‘kker.;
                           ENU=Specifies the document that the payment is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DocNo;
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                CaptionML=[DAN=Valutakode;
                           ENU=Currency Code];
                ToolTipML=[DAN=Angiver koden for den valuta, som bel›bene vises i.;
                           ENU=Specifies the code for the currency that amounts are shown in.];
                ApplicationArea=#Suite;
                SourceExpr=CurrencyCode;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Bel›b;
                           ENU=Amount];
                ToolTipML=[DAN=Angiver det bel›b, som betalingstoleranceadvarslen henviser til.;
                           ENU=Specifies the amount that the payment tolerance warning refers to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ApplyingAmount;
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                CaptionML=[DAN=Udligningsbel›b;
                           ENU=Applied Amount];
                ToolTipML=[DAN=Angiver det udlignede bel›b, som betalingstoleranceadvarslen henviser til.;
                           ENU=Specifies the applied amount that the payment tolerance warning refers to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AppliedAmount;
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Saldo;
                           ENU=Balance];
                ToolTipML=[DAN=Angiver det betalingsbel›b, som debitoren skylder for afsluttede salg.;
                           ENU=Specifies the payment amount that the customer owes for completed sales.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=BalanceAmount;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      PostingDate@1002 : Date;
      CustVendNo@1023 : Code[20];
      DocNo@1003 : Code[20];
      CurrencyCode@1001 : Code[10];
      OriginalApplyingAmount@1006 : Decimal;
      OriginalAppliedAmount@1011 : Decimal;
      ApplyingAmount@1007 : Decimal;
      AppliedAmount@1000 : Decimal;
      BalanceAmount@1004 : Decimal;
      Posting@1015 : ' ,Payment Tolerance Accounts,Remaining Amount';
      NewPostingAction@1005 : Integer;

    [External]
    PROCEDURE SetValues@1(ShowPostingDate@1000 : Date;ShowCustVendNo@1001 : Code[20];ShowDocNo@1003 : Code[20];ShowCurrencyCode@1002 : Code[10];ShowAmount@1004 : Decimal;ShowAppliedAmount@1005 : Decimal;ShowBalance@1007 : Decimal);
    VAR
      BalAmount@1006 : Decimal;
    BEGIN
      CLEAR(BalAmount);
      PostingDate := ShowPostingDate;
      CustVendNo := ShowCustVendNo;
      DocNo := ShowDocNo;
      CurrencyCode := ShowCurrencyCode;
      OriginalApplyingAmount := ShowAmount;
      OriginalAppliedAmount := ShowAppliedAmount;
      BalAmount := ShowBalance;
    END;

    [External]
    PROCEDURE GetValues@2(VAR PostingAction@1001 : Integer);
    BEGIN
      PostingAction := NewPostingAction
    END;

    LOCAL PROCEDURE YesOnPush@19065578();
    BEGIN
      IF Posting = Posting::"Payment Tolerance Accounts" THEN
        NewPostingAction := 1
      ELSE
        IF Posting = Posting::"Remaining Amount" THEN
          NewPostingAction := 2;
    END;

    LOCAL PROCEDURE NoOnPush@19040112();
    BEGIN
      NewPostingAction := 3;
    END;

    [External]
    PROCEDURE InitializeOption@3(OptionValue@1000 : Integer);
    BEGIN
      NewPostingAction := OptionValue;
    END;

    LOCAL PROCEDURE UpdateAmounts@6();
    BEGIN
      CASE Posting OF
        Posting::"Payment Tolerance Accounts":
          BEGIN
            ApplyingAmount := OriginalApplyingAmount;
            AppliedAmount := OriginalAppliedAmount;
            BalanceAmount := 0;
          END;
        Posting::"Remaining Amount":
          BEGIN
            IF ABS(OriginalApplyingAmount) < ABS(OriginalAppliedAmount) THEN BEGIN
              ApplyingAmount := OriginalApplyingAmount;
              AppliedAmount := -OriginalApplyingAmount;
            END ELSE BEGIN
              ApplyingAmount := -OriginalAppliedAmount;
              AppliedAmount := OriginalAppliedAmount;
            END;
            BalanceAmount := OriginalApplyingAmount + OriginalAppliedAmount;
          END;
      END;
    END;

    BEGIN
    END.
  }
}

