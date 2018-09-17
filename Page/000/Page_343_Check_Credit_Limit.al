OBJECT Page 343 Check Credit Limit
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=[DAN=Kontroller kreditmaksimum;
               ENU=Check Credit Limit];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table18;
    DataCaptionExpr='';
    PageType=ConfirmationDialog;
    InstructionalTextML=[DAN=Der kr‘ves en handling vedr›rende kontrol af kreditgr‘nse.;
                         ENU=An action is requested regarding the Credit Limit check.];
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Administrer,Opret;
                                ENU=New,Process,Report,Manage,Create];
    OnOpenPage=BEGIN
                 COPY(Cust2);
               END;

    OnAfterGetRecord=BEGIN
                       CalcCreditLimitLCY;
                       CalcOverdueBalanceLCY;

                       SetParametersOnDetails;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Debitor;
                                 ENU=&Customer];
                      Image=Customer }
      { 25      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=F† vist oplysninger om den valgte record.;
                                 ENU=View details for the selected record.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Image=EditLines }
      { 26      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Se statistik for kreditgr‘nseposter.;
                                 ENU=View statistics for credit limit entries.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 151;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 2   ;1   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                CaptionClass=FORMAT(STRSUBSTNO(Text000,Heading));
                MultiLine=Yes }

    { 6   ;1   ;Field     ;
                CaptionML=[DAN=Vis ikke denne meddelelse igen.;
                           ENU=Do not show this message again.];
                ToolTipML=[DAN=Angiver, at denne meddelelse ikke l‘ngere skal vises ved arbejde med dette dokument, hvis debitoren er over kreditmaksimum;
                           ENU=Specifies to no longer show this message when working with this document while the customer is over credit limit];
                ApplicationArea=#Advanced;
                SourceExpr=HideMessage;
                Visible=HideMessageVisible }

    { 8   ;1   ;Part      ;
                Name=CreditLimitDetails;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page1871;
                PartType=Page;
                UpdatePropagation=Both }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 Vil du registrere bel›bet alligevel?;ENU=%1 Do you still want to record the amount?';
      Text002@1002 : TextConst 'DAN=Debitorens kreditmaksimum er overskredet.;ENU=The customer''s credit limit has been exceeded.';
      Text003@1003 : TextConst 'DAN=Der er forfaldne bel›b p† debitoren.;ENU=This customer has an overdue balance.';
      CurrExchRate@1004 : Record 330;
      SalesHeader@1005 : Record 36;
      SalesLine@1006 : Record 37;
      ServHeader@1021 : Record 5900;
      ServLine@1020 : Record 5902;
      Cust2@1007 : Record 18;
      SalesSetup@1008 : Record 311;
      CustNo@1009 : Code[20];
      Heading@1010 : Text[250];
      SecondHeading@1024 : Text[250];
      NotificationId@1001 : GUID;
      NewOrderAmountLCY@1011 : Decimal;
      OldOrderAmountLCY@1012 : Decimal;
      OrderAmountThisOrderLCY@1013 : Decimal;
      OrderAmountTotalLCY@1014 : Decimal;
      CustCreditAmountLCY@1015 : Decimal;
      ShippedRetRcdNotIndLCY@1016 : Decimal;
      OutstandingRetOrdersLCY@1017 : Decimal;
      RcdNotInvdRetOrdersLCY@1018 : Decimal;
      DeltaAmount@1022 : Decimal;
      HideMessage@1023 : Boolean;
      HideMessageVisible@1026 : Boolean;

    [Internal]
    PROCEDURE GenJnlLineShowWarning@2(GenJnlLine@1000 : Record 81) : Boolean;
    BEGIN
      SalesSetup.GET;
      IF SalesSetup."Credit Warnings" =
         SalesSetup."Credit Warnings"::"No Warning"
      THEN
        EXIT(FALSE);
      IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
        EXIT(ShowWarning(GenJnlLine."Account No.",GenJnlLine."Amount (LCY)",0,TRUE));
      EXIT(ShowWarning(GenJnlLine."Bal. Account No.",-GenJnlLine.Amount,0,TRUE));
    END;

    [Internal]
    PROCEDURE GenJnlLineShowWarningAndGetCause@26(GenJnlLine@1003 : Record 81;VAR NotificationContextGuidOut@1001 : GUID) : Boolean;
    VAR
      Result@1002 : Boolean;
    BEGIN
      Result := GenJnlLineShowWarning(GenJnlLine);
      NotificationContextGuidOut := NotificationId;
      EXIT(Result);
    END;

    [Internal]
    PROCEDURE SalesHeaderShowWarning@3(SalesHeader@1000 : Record 36) : Boolean;
    VAR
      OldSalesHeader@1001 : Record 36;
      AssignDeltaAmount@1002 : Boolean;
    BEGIN
      // Used when additional lines are inserted
      SalesSetup.GET;
      IF SalesSetup."Credit Warnings" =
         SalesSetup."Credit Warnings"::"No Warning"
      THEN
        EXIT(FALSE);
      IF SalesHeader."Currency Code" = '' THEN
        NewOrderAmountLCY := SalesHeader."Amount Including VAT"
      ELSE
        NewOrderAmountLCY :=
          ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              WORKDATE,SalesHeader."Currency Code",
              SalesHeader."Amount Including VAT",SalesHeader."Currency Factor"));

      IF NOT (SalesHeader."Document Type" IN
              [SalesHeader."Document Type"::Quote,
               SalesHeader."Document Type"::Order,
               SalesHeader."Document Type"::"Return Order"])
      THEN
        NewOrderAmountLCY := NewOrderAmountLCY + SalesLineAmount(SalesHeader."Document Type",SalesHeader."No.");
      OldSalesHeader := SalesHeader;
      IF OldSalesHeader.FIND THEN
        // If "Bill-To Customer" is the same and Sales Header exists then do not consider amount in credit limit calculation since it's already included in "Outstanding Amount"
        // If "Bill-To Customer" was changed the consider amount in credit limit calculation since changes was not yet commited and not included in "Outstanding Amount"
        AssignDeltaAmount := OldSalesHeader."Bill-to Customer No." <> SalesHeader."Bill-to Customer No."
      ELSE
        // If Sales Header is not inserted yet then consider the amount in credit limit calculation
        AssignDeltaAmount := TRUE;
      IF AssignDeltaAmount THEN
        DeltaAmount := NewOrderAmountLCY;
      EXIT(ShowWarning(SalesHeader."Bill-to Customer No.",NewOrderAmountLCY,0,TRUE));
    END;

    [Internal]
    PROCEDURE SalesHeaderShowWarningAndGetCause@16(SalesHeader@1000 : Record 36;VAR NotificationContextGuidOut@1001 : GUID) : Boolean;
    VAR
      Result@1002 : Boolean;
    BEGIN
      Result := SalesHeaderShowWarning(SalesHeader);
      NotificationContextGuidOut := NotificationId;
      EXIT(Result);
    END;

    [Internal]
    PROCEDURE SalesLineShowWarning@4(SalesLine@1000 : Record 37) : Boolean;
    BEGIN
      SalesSetup.GET;
      IF SalesSetup."Credit Warnings" =
         SalesSetup."Credit Warnings"::"No Warning"
      THEN
        EXIT(FALSE);
      IF (SalesHeader."Document Type" <> SalesLine."Document Type") OR
         (SalesHeader."No." <> SalesLine."Document No.")
      THEN
        SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.");
      NewOrderAmountLCY := SalesLine."Outstanding Amount (LCY)" + SalesLine."Shipped Not Invoiced (LCY)";

      IF SalesLine.FIND THEN
        OldOrderAmountLCY := SalesLine."Outstanding Amount (LCY)" + SalesLine."Shipped Not Invoiced (LCY)"
      ELSE
        OldOrderAmountLCY := 0;

      DeltaAmount := NewOrderAmountLCY - OldOrderAmountLCY;
      NewOrderAmountLCY :=
        DeltaAmount + SalesLineAmount(SalesLine."Document Type",SalesLine."Document No.");

      EXIT(ShowWarning(SalesHeader."Bill-to Customer No.",NewOrderAmountLCY,OldOrderAmountLCY,FALSE))
    END;

    [Internal]
    PROCEDURE SalesLineShowWarningAndGetCause@18(SalesLine@1003 : Record 37;VAR NotificationContextGuidOut@1001 : GUID) : Boolean;
    VAR
      Result@1002 : Boolean;
    BEGIN
      Result := SalesLineShowWarning(SalesLine);
      NotificationContextGuidOut := NotificationId;
      EXIT(Result);
    END;

    [Internal]
    PROCEDURE ServiceHeaderShowWarning@8(ServHeader@1000 : Record 5900) : Boolean;
    VAR
      ServSetup@1002 : Record 5911;
      OldServHeader@1001 : Record 5900;
      AssignDeltaAmount@1003 : Boolean;
    BEGIN
      ServSetup.GET;
      SalesSetup.GET;
      IF SalesSetup."Credit Warnings" =
         SalesSetup."Credit Warnings"::"No Warning"
      THEN
        EXIT(FALSE);

      NewOrderAmountLCY := 0;
      ServLine.RESET;
      ServLine.SETRANGE("Document Type",ServHeader."Document Type");
      ServLine.SETRANGE("Document No.",ServHeader."No.");
      IF ServLine.FINDSET THEN
        REPEAT
          IF ServHeader."Currency Code" = '' THEN
            NewOrderAmountLCY := NewOrderAmountLCY + ServLine."Amount Including VAT"
          ELSE
            NewOrderAmountLCY := NewOrderAmountLCY +
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  WORKDATE,ServHeader."Currency Code",
                  ServLine."Amount Including VAT",ServHeader."Currency Factor"));
        UNTIL ServLine.NEXT = 0;

      IF ServHeader."Document Type" <> ServHeader."Document Type"::Order THEN
        NewOrderAmountLCY := NewOrderAmountLCY + ServLineAmount(ServHeader."Document Type",ServHeader."No.",ServLine);
      OldServHeader := ServHeader;
      IF OldServHeader.FIND THEN
        AssignDeltaAmount := OldServHeader."Bill-to Customer No." <> ServHeader."Bill-to Customer No."
      ELSE
        AssignDeltaAmount := TRUE;
      IF AssignDeltaAmount THEN
        DeltaAmount := NewOrderAmountLCY;
      EXIT(ShowWarning(ServHeader."Bill-to Customer No.",NewOrderAmountLCY,0,TRUE));
    END;

    [Internal]
    PROCEDURE ServiceHeaderShowWarningAndGetCause@19(ServHeader@1003 : Record 5900;VAR NotificationContextGuidOut@1001 : GUID) : Boolean;
    VAR
      Result@1002 : Boolean;
    BEGIN
      Result := ServiceHeaderShowWarning(ServHeader);
      NotificationContextGuidOut := NotificationId;
      EXIT(Result);
    END;

    [Internal]
    PROCEDURE ServiceLineShowWarning@10(ServLine@1000 : Record 5902) : Boolean;
    BEGIN
      SalesSetup.GET;
      IF SalesSetup."Credit Warnings" =
         SalesSetup."Credit Warnings"::"No Warning"
      THEN
        EXIT(FALSE);
      IF (ServHeader."Document Type" <> ServLine."Document Type") OR
         (ServHeader."No." <> ServLine."Document No.")
      THEN
        ServHeader.GET(ServLine."Document Type",ServLine."Document No.");
      NewOrderAmountLCY := ServLine."Outstanding Amount (LCY)" + ServLine."Shipped Not Invoiced (LCY)";

      IF ServLine.FIND THEN
        OldOrderAmountLCY := ServLine."Outstanding Amount (LCY)" + ServLine."Shipped Not Invoiced (LCY)"
      ELSE
        OldOrderAmountLCY := 0;

      DeltaAmount := NewOrderAmountLCY - OldOrderAmountLCY;
      NewOrderAmountLCY :=
        DeltaAmount + ServLineAmount(ServLine."Document Type",ServLine."Document No.",ServLine);

      EXIT(ShowWarning(ServHeader."Bill-to Customer No.",NewOrderAmountLCY,OldOrderAmountLCY,FALSE))
    END;

    [Internal]
    PROCEDURE ServiceLineShowWarningAndGetCause@21(ServLine@1003 : Record 5902;VAR NotificationContextGuidOut@1001 : GUID) : Boolean;
    VAR
      Result@1002 : Boolean;
    BEGIN
      Result := ServiceLineShowWarning(ServLine);
      NotificationContextGuidOut := NotificationId;
      EXIT(Result);
    END;

    [Internal]
    PROCEDURE ServiceContractHeaderShowWarning@11(ServiceContractHeader@1000 : Record 5965) : Boolean;
    BEGIN
      SalesSetup.GET;
      IF SalesSetup."Credit Warnings" =
         SalesSetup."Credit Warnings"::"No Warning"
      THEN
        EXIT(FALSE);
      EXIT(ShowWarning(ServiceContractHeader."Bill-to Customer No.",0,0,TRUE));
    END;

    [Internal]
    PROCEDURE ServiceContractHeaderShowWarningAndGetCause@22(ServiceContractHeader@1003 : Record 5965;VAR NotificationContextGuidOut@1001 : GUID) : Boolean;
    VAR
      Result@1002 : Boolean;
    BEGIN
      Result := ServiceContractHeaderShowWarning(ServiceContractHeader);
      NotificationContextGuidOut := NotificationId;
      EXIT(Result);
    END;

    LOCAL PROCEDURE SalesLineAmount@5(DocType@1000 : Integer;DocNo@1001 : Code[20]) : Decimal;
    BEGIN
      SalesLine.RESET;
      SalesLine.SETRANGE("Document Type",DocType);
      SalesLine.SETRANGE("Document No.",DocNo);
      SalesLine.CALCSUMS("Outstanding Amount (LCY)","Shipped Not Invoiced (LCY)");
      EXIT(SalesLine."Outstanding Amount (LCY)" + SalesLine."Shipped Not Invoiced (LCY)");
    END;

    LOCAL PROCEDURE ServLineAmount@12(DocType@1000 : Integer;DocNo@1001 : Code[20];VAR ServLine2@1002 : Record 5902) : Decimal;
    BEGIN
      ServLine2.RESET;
      ServLine2.SETRANGE("Document Type",DocType);
      ServLine2.SETRANGE("Document No.",DocNo);
      ServLine2.CALCSUMS("Outstanding Amount (LCY)","Shipped Not Invoiced (LCY)");
      EXIT(ServLine2."Outstanding Amount (LCY)" + ServLine2."Shipped Not Invoiced (LCY)");
    END;

    LOCAL PROCEDURE ShowWarning@1(NewCustNo@1000 : Code[20];NewOrderAmountLCY2@1001 : Decimal;OldOrderAmountLCY2@1002 : Decimal;CheckOverDueBalance@1003 : Boolean) : Boolean;
    VAR
      CustCheckCrLimit@1007 : Codeunit 312;
      ExitValue@1004 : Integer;
    BEGIN
      IF NewCustNo = '' THEN
        EXIT;
      CustNo := NewCustNo;
      NewOrderAmountLCY := NewOrderAmountLCY2;
      OldOrderAmountLCY := OldOrderAmountLCY2;
      GET(CustNo);
      SETRANGE("No.","No.");
      Cust2.COPY(Rec);

      IF (SalesSetup."Credit Warnings" IN
          [SalesSetup."Credit Warnings"::"Both Warnings",
           SalesSetup."Credit Warnings"::"Credit Limit"]) AND
         CustCheckCrLimit.IsCreditLimitNotificationEnabled(Rec)
      THEN BEGIN
        CalcCreditLimitLCY;
        IF (CustCreditAmountLCY > "Credit Limit (LCY)") AND ("Credit Limit (LCY)" <> 0) THEN
          ExitValue := 1;
      END;
      IF CheckOverDueBalance AND
         (SalesSetup."Credit Warnings" IN
          [SalesSetup."Credit Warnings"::"Both Warnings",
           SalesSetup."Credit Warnings"::"Overdue Balance"]) AND
         CustCheckCrLimit.IsOverdueBalanceNotificationEnabled(Rec)
      THEN BEGIN
        CalcOverdueBalanceLCY;
        IF "Balance Due (LCY)" > 0 THEN
          ExitValue := ExitValue + 2;
      END;

      IF ExitValue > 0 THEN BEGIN
        CASE ExitValue OF
          1:
            BEGIN
              Heading := Text002;
              NotificationId := CustCheckCrLimit.GetCreditLimitNotificationId;
            END;
          2:
            BEGIN
              Heading := Text003;
              NotificationId := CustCheckCrLimit.GetOverdueBalanceNotificationId;
            END;
          3:
            BEGIN
              Heading := Text002;
              SecondHeading := Text003;
              NotificationId := CustCheckCrLimit.GetBothNotificationsId;
            END;
        END;
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE CalcCreditLimitLCY@6();
    BEGIN
      IF GETFILTER("Date Filter") = '' THEN
        SETFILTER("Date Filter",'..%1',WORKDATE);
      CALCFIELDS("Balance (LCY)","Shipped Not Invoiced (LCY)","Serv Shipped Not Invoiced(LCY)");
      CalcReturnAmounts(OutstandingRetOrdersLCY,RcdNotInvdRetOrdersLCY);

      OrderAmountTotalLCY := CalcTotalOutstandingAmt - OutstandingRetOrdersLCY + DeltaAmount;
      ShippedRetRcdNotIndLCY := "Shipped Not Invoiced (LCY)" + "Serv Shipped Not Invoiced(LCY)" - RcdNotInvdRetOrdersLCY;
      IF "No." = CustNo THEN
        OrderAmountThisOrderLCY := NewOrderAmountLCY
      ELSE
        OrderAmountThisOrderLCY := 0;

      CustCreditAmountLCY :=
        "Balance (LCY)" + "Shipped Not Invoiced (LCY)" + "Serv Shipped Not Invoiced(LCY)" - RcdNotInvdRetOrdersLCY +
        OrderAmountTotalLCY - GetInvoicedPrepmtAmountLCY;
    END;

    LOCAL PROCEDURE CalcOverdueBalanceLCY@7();
    BEGIN
      IF GETFILTER("Date Filter") = '' THEN
        SETFILTER("Date Filter",'..%1',WORKDATE);
      CALCFIELDS("Balance Due (LCY)");
    END;

    LOCAL PROCEDURE CalcReturnAmounts@9(VAR OutstandingRetOrdersLCY2@1001 : Decimal;VAR RcdNotInvdRetOrdersLCY2@1002 : Decimal);
    BEGIN
      SalesLine.RESET;
      SalesLine.SETCURRENTKEY("Document Type","Bill-to Customer No.","Currency Code");
      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::"Return Order");
      SalesLine.SETRANGE("Bill-to Customer No.","No.");
      SalesLine.CALCSUMS("Outstanding Amount (LCY)","Return Rcd. Not Invd. (LCY)");
      OutstandingRetOrdersLCY2 := SalesLine."Outstanding Amount (LCY)";
      RcdNotInvdRetOrdersLCY2 := SalesLine."Return Rcd. Not Invd. (LCY)";
    END;

    LOCAL PROCEDURE CalcTotalOutstandingAmt@13() : Decimal;
    VAR
      SalesLine@1000 : Record 37;
      SalesOutstandingAmountFromShipment@1001 : Decimal;
      ServOutstandingAmountFromShipment@1002 : Decimal;
    BEGIN
      CALCFIELDS(
        "Outstanding Invoices (LCY)","Outstanding Orders (LCY)","Outstanding Serv.Invoices(LCY)","Outstanding Serv. Orders (LCY)");
      SalesOutstandingAmountFromShipment := SalesLine.OutstandingInvoiceAmountFromShipment("No.");
      ServOutstandingAmountFromShipment := ServLine.OutstandingInvoiceAmountFromShipment("No.");

      EXIT(
        "Outstanding Orders (LCY)" + "Outstanding Invoices (LCY)" + "Outstanding Serv. Orders (LCY)" +
        "Outstanding Serv.Invoices(LCY)" - SalesOutstandingAmountFromShipment - ServOutstandingAmountFromShipment);
    END;

    [External]
    PROCEDURE SetHideMessageVisible@40(HideMsgVisible@1000 : Boolean);
    BEGIN
      HideMessageVisible := HideMsgVisible;
    END;

    [External]
    PROCEDURE SetHideMessage@20(HideMsg@1000 : Boolean);
    BEGIN
      HideMessage := HideMsg;
    END;

    [External]
    PROCEDURE GetHideMessage@24() : Boolean;
    BEGIN
      EXIT(HideMessage);
    END;

    [External]
    PROCEDURE GetHeading@14() : Text[250];
    BEGIN
      EXIT(Heading);
    END;

    [External]
    PROCEDURE GetSecondHeading@23() : Text[250];
    BEGIN
      EXIT(SecondHeading);
    END;

    [External]
    PROCEDURE GetNotificationId@17() : GUID;
    BEGIN
      EXIT(NotificationId);
    END;

    [Internal]
    PROCEDURE PopulateDataOnNotification@25(CreditLimitNotification@1000 : Notification);
    BEGIN
      CurrPage.CreditLimitDetails.PAGE.SetCustomerNumber("No.");
      SetParametersOnDetails;
      CurrPage.CreditLimitDetails.PAGE.PopulateDataOnNotification(CreditLimitNotification);
    END;

    LOCAL PROCEDURE SetParametersOnDetails@15();
    BEGIN
      CurrPage.CreditLimitDetails.PAGE.SetOrderAmountTotalLCY(OrderAmountTotalLCY);
      CurrPage.CreditLimitDetails.PAGE.SetShippedRetRcdNotIndLCY(ShippedRetRcdNotIndLCY);
      CurrPage.CreditLimitDetails.PAGE.SetOrderAmountThisOrderLCY(OrderAmountThisOrderLCY);
      CurrPage.CreditLimitDetails.PAGE.SetCustCreditAmountLCY(CustCreditAmountLCY);
    END;

    BEGIN
    END.
  }
}

