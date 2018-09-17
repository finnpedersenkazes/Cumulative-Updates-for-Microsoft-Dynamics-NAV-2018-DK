OBJECT Page 1638 Booking Items
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Bestillinger ikke faktureret;
               ENU=Bookings Not Invoiced];
    LinksAllowed=No;
    SourceTable=Table6707;
    PageType=List;
    SourceTableTemporary=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Fakturering;
                                ENU=New,Process,Report,Invoicing];
    OnAfterGetRecord=VAR
                       OutlookSynchTypeConv@1000 : Codeunit 5302;
                     BEGIN
                       StartDate := OutlookSynchTypeConv.UTC2LocalDT(GetStartDate);
                       CustomerName := "Customer Name";
                       IF CustomerName = '' THEN
                         CustomerName := NoCustomerSelectedTxt;
                     END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 10      ;1   ;Action    ;
                      Name=Invoice;
                      CaptionML=[DAN=Opret faktura;
                                 ENU=Create Invoice];
                      ToolTipML=[DAN=Opret en ny salgsfaktura for den valgte bestilling.;
                                 ENU=Create a new sales invoice for the selected booking.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=NewSalesInvoice;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=VAR
                                 TempBookingItem@1001 : TEMPORARY Record 6707;
                                 SalesHeader@1000 : Record 36;
                                 CountCust@1004 : Integer;
                               BEGIN
                                 IF NOT ActionAllowed THEN
                                   EXIT;

                                 GetSelectedRecords(TempBookingItem);

                                 IF TempBookingItem.FINDSET THEN
                                   REPEAT
                                     IF InvoiceItemsForCustomer(TempBookingItem,SalesHeader) THEN
                                       CountCust += 1;
                                   UNTIL TempBookingItem.NEXT = 0;

                                 OutputAction(CountCust,SalesHeader);
                               END;
                                }
      { 11      ;1   ;Action    ;
                      Name=Invoice Customer;
                      CaptionML=[DAN=Opret faktura til debitor;
                                 ENU=Create Invoice for Customer];
                      ToolTipML=[DAN=Opret en ny salgsfaktura for alle varer, der er bestilt af debitoren, i den valgte bestilling.;
                                 ENU=Create a new sales invoice for all items booked by the customer on the selected booking.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=SuggestCustomerBill;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 SalesHeader@1000 : Record 36;
                               BEGIN
                                 IF NOT ActionAllowed THEN
                                   EXIT;

                                 IF InvoiceItemsForCustomer(Rec,SalesHeader) THEN
                                   OutputAction(1,SalesHeader);
                               END;
                                }
      { 4       ;1   ;Action    ;
                      Name=MarkInvoiced;
                      CaptionML=[DAN=Mark‚r som faktureret;
                                 ENU=Mark as Invoiced];
                      ToolTipML=[DAN=Mark‚r de bestillinger, som du har valgt som faktureret. Dermed fjernes bestillingerne fra visningen.;
                                 ENU=Mark the bookings that you have selected as invoiced. This removes the bookings from this view.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ClearLog;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=VAR
                                 BookingItem@1001 : Record 6707;
                                 TempBookingItem@1004 : TEMPORARY Record 6707;
                                 InstructionMgt@1000 : Codeunit 1330;
                               BEGIN
                                 IF NOT ActionAllowed THEN
                                   EXIT;

                                 IF InstructionMgt.ShowConfirm(ConfirmMarkQst,InstructionMgt.MarkBookingAsInvoicedWarningCode) THEN BEGIN
                                   GetSelectedRecords(TempBookingItem);
                                   IF TempBookingItem.FINDSET THEN
                                     REPEAT
                                       BookingItem.GET(TempBookingItem.Id);
                                       BookingItem."Invoice Status" := BookingItem."Invoice Status"::open;
                                       BookingItem.MODIFY;
                                       RemoveFromView(TempBookingItem);
                                     UNTIL TempBookingItem.NEXT = 0;
                                 END;

                                 CurrPage.UPDATE;
                               END;

                      Gesture=None }
      { 12      ;1   ;Action    ;
                      Name=InvoiceAll;
                      CaptionML=[DAN=Fakturer alle;
                                 ENU=Invoice All];
                      ToolTipML=[DAN=Opret en ny salgsfaktura for alle ikke-fakturerede bestillinger.;
                                 ENU=Create a new sales invoice for all non-invoiced bookings.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=NewSalesInvoice;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 TempBookingItem@1000 : TEMPORARY Record 6707;
                                 SalesHeader@1001 : Record 36;
                                 CountCust@1002 : Integer;
                               BEGIN
                                 IF NOT ActionAllowed THEN
                                   EXIT;

                                 TempBookingItem.COPY(Rec,TRUE);

                                 TempBookingItem.SETFILTER("Customer Name",'<>''''');
                                 IF TempBookingItem.FINDSET THEN
                                   REPEAT
                                     IF InvoiceItemsForCustomer(TempBookingItem,SalesHeader) THEN
                                       CountCust += 1;
                                   UNTIL TempBookingItem.NEXT = 0;

                                 OutputAction(CountCust,SalesHeader);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Startdato;
                           ENU=Start Date];
                ToolTipML=[DAN=Angiver startdato og -klokkesl‘t for bestillingen.;
                           ENU=Specifies the start date and time of the booking.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=StartDate }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varigheden af bestillingen, der endnu ikke er faktureret.;
                           ENU=Specifies the duration of the booking that is not yet invoiced.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Duration }

    { 5   ;2   ;Field     ;
                Name=Customer;
                CaptionML=[DAN=Debitor;
                           ENU=Customer];
                ToolTipML=[DAN=Angiver navnet p† den debitor, som bestillingen er til.;
                           ENU=Specifies the name of the customer that the booking is for.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CustomerName;
                OnDrillDown=VAR
                              Customer@1000 : Record 18;
                            BEGIN
                              IF Customer.FindByEmail(Customer,"Customer Email") THEN
                                PAGE.RUN(PAGE::"Customer Card",Customer);
                            END;
                             }

    { 3   ;2   ;Field     ;
                Name=Service;
                ToolTipML=[DAN=Angiver emnet for bestillingen.;
                           ENU=Specifies the subject of the booking.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Service Name";
                OnDrillDown=VAR
                              BookingServiceMapping@1000 : Record 6706;
                              Item@1001 : Record 27;
                            BEGIN
                              IF BookingServiceMapping.GET("Service ID") THEN
                                IF Item.GET(BookingServiceMapping."Item No.") THEN
                                  PAGE.RUN(PAGE::"Item Card",Item);
                            END;
                             }

  }
  CODE
  {
    VAR
      ConfirmMarkQst@1002 : TextConst 'DAN=De aftaler, som du markerer som fakturerede, fjernes fra denne visning. Du vil ikke l‘ngere kunne administrere dem i dette vindue. Vil du forts‘tte?;ENU=The appointments that you mark as invoiced will be removed from this view. You will no longer be able to manage them in this window. Do you want to continue?';
      ConfirmSyncQst@1005 : TextConst '@@@=%1 - The name of the service or customer. %2 - short product name;DAN=%1 findes ikke i %2. Vil du synkronisere debitorer og tjenester under Bookings nu?;ENU=%1 does not exist in %2. Would you like to synchronize your Bookings customers and services now?';
      InvoicePostQst@1003 : TextConst 'DAN=Salgsfakturaer er blevet oprettet, men er ikke bogf›rt eller sendt. Vil du se din liste over ikke-bogf›rte salgsfakturaer?;ENU=Sales invoices have been created but have not been posted or sent. Would you like to view your list of unposted sales invoices?';
      AlreadyInvoicedMsg@1000 : TextConst 'DAN=De valgte aftaler er allerede blevet faktureret.;ENU=The selected appointments have already been invoiced.';
      StartDate@1004 : DateTime;
      NoCustomerFoundErr@1001 : TextConst '@@@=%1 - Short product name;DAN=Debitoren blev ikke fundet i %1.;ENU=Could not find the customer in %1.';
      NoCustomerSelectedTxt@1006 : TextConst '@@@=Indicates that a customer was not selected for the Bookings appointment.;DAN=<Ingen debitor valgt>;ENU=<No customer selected>';
      CustomerName@1007 : Text;
      NoCustomerSelectedMsg@1008 : TextConst 'DAN=Der skal v‘lges en debitor for at oprette en faktura for bestillingen. V‘lg en debitor til bestillingen i appen Bookings, og †bn derefter denne side igen.;ENU=A customer must be selected to create an invoice for the booking. Select a customer for the booking in the Bookings app, then re-open this page.';

    LOCAL PROCEDURE ActionAllowed@10() Allowed : Boolean;
    BEGIN
      Allowed := ("Service Name" <> '') AND NOT ISEMPTY;
      IF "Customer Name" = '' THEN BEGIN
        MESSAGE(NoCustomerSelectedMsg);
        Allowed := FALSE;
      END;
    END;

    LOCAL PROCEDURE CreateSalesHeader@2(VAR SalesHeader@1000 : Record 36;VAR BookingItem@1001 : Record 6707);
    VAR
      Customer@1002 : Record 18;
      BookingManager@1003 : Codeunit 6721;
    BEGIN
      IF NOT Customer.FindByEmail(Customer,BookingItem."Customer Email") THEN BEGIN
        IF CONFIRM(ConfirmSyncQst,TRUE,BookingItem."Customer Name",PRODUCTNAME.SHORT) THEN
          BookingManager.Synchronize(BookingItem);
        IF NOT Customer.FindByEmail(Customer,BookingItem."Customer Email") THEN
          ERROR(NoCustomerFoundErr,PRODUCTNAME.SHORT);
      END;

      SalesHeader.INIT;
      SalesHeader.VALIDATE("Document Type",SalesHeader."Document Type"::Invoice);
      SalesHeader.VALIDATE("Sell-to Customer No.",Customer."No.");
      SalesHeader.INSERT(TRUE);
    END;

    LOCAL PROCEDURE CreateSalesLine@1(VAR SalesHeader@1004 : Record 36;VAR BookingItem@1000 : Record 6707);
    VAR
      InvoicedBookingItem@1001 : Record 1638;
      SalesLine@1003 : Record 37;
      BookingServiceMapping@1009 : Record 6706;
      BookingManager@1008 : Codeunit 6721;
      LineNo@1002 : Integer;
    BEGIN
      IF NOT BookingServiceMapping.GET(BookingItem."Service ID") THEN BEGIN
        IF CONFIRM(ConfirmSyncQst,TRUE,BookingItem."Service Name",PRODUCTNAME.SHORT) THEN
          BookingManager.Synchronize(BookingItem);
        BookingServiceMapping.GET(BookingItem."Service ID");
      END;

      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type"::Invoice);
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      IF SalesLine.FINDLAST THEN
        LineNo := SalesLine."Line No." + 10000
      ELSE
        LineNo := 10000;
      CLEAR(SalesLine);

      InvoicedBookingItem.INIT;
      InvoicedBookingItem."Booking Item ID" := BookingItem.Id;
      InvoicedBookingItem."Document No." := SalesHeader."No.";
      InvoicedBookingItem.INSERT(TRUE);

      SalesLine.INIT;
      SalesLine.VALIDATE("Document Type",SalesHeader."Document Type"::Invoice);
      SalesLine.VALIDATE("Document No.",SalesHeader."No.");
      SalesLine.VALIDATE("Line No.",LineNo);
      SalesLine.VALIDATE("Sell-to Customer No.",SalesHeader."Sell-to Customer No.");
      SalesLine.VALIDATE(Type,SalesLine.Type::Item);
      SalesLine.VALIDATE("No.",BookingServiceMapping."Item No.");
      SalesLine.VALIDATE(Quantity,(BookingItem.GetEndDate - BookingItem.GetStartDate) / 3600000);
      SalesLine.VALIDATE("Unit Price",BookingItem.Price);
      SalesLine.VALIDATE(Description,STRSUBSTNO('%1 - %2',BookingItem."Service Name",DT2DATE(BookingItem.GetStartDate)));
      IF NOT SalesLine.INSERT(TRUE) THEN BEGIN
        InvoicedBookingItem.DELETE;
        ERROR(GETLASTERRORTEXT);
      END;
    END;

    LOCAL PROCEDURE GetSelectedRecords@3(VAR TempBookingItem@1000 : TEMPORARY Record 6707);
    BEGIN
      IF MARKEDONLY THEN BEGIN
        TempBookingItem.COPY(Rec,TRUE);
        TempBookingItem.MARKEDONLY(TRUE);
      END ELSE BEGIN
        TempBookingItem.COPY(Rec,TRUE);
        CurrPage.SETSELECTIONFILTER(TempBookingItem);
      END;
    END;

    LOCAL PROCEDURE InvoiceItemsForCustomer@12(VAR TempBookingItem@1000 : TEMPORARY Record 6707;VAR SalesHeader@1002 : Record 36) InvoiceCreated : Boolean;
    VAR
      NewTempBookingItem@1003 : TEMPORARY Record 6707;
      InvoicedBookingItem@1001 : Record 1638;
    BEGIN
      NewTempBookingItem.COPY(TempBookingItem,TRUE);
      IF NOT InvoicedBookingItem.GET(TempBookingItem.Id) THEN BEGIN
        NewTempBookingItem.SETRANGE("Customer Email",TempBookingItem."Customer Email");
        NewTempBookingItem.SETRANGE("Invoice Status",NewTempBookingItem."Invoice Status"::draft);
        NewTempBookingItem.SETFILTER("Invoice No.",'=''''');
        IF NewTempBookingItem.FINDSET THEN BEGIN
          CLEAR(SalesHeader);
          CreateSalesHeader(SalesHeader,NewTempBookingItem);
          REPEAT
            IF NOT InvoicedBookingItem.GET(NewTempBookingItem.Id) THEN
              CreateSalesLine(SalesHeader,NewTempBookingItem);
            RemoveFromView(NewTempBookingItem);
          UNTIL NewTempBookingItem.NEXT = 0;
          InvoiceCreated := TRUE;
        END;
      END;
    END;

    LOCAL PROCEDURE OutputAction@38(CountCust@1000 : Integer;SalesHeader@1002 : Record 36);
    BEGIN
      CASE CountCust OF
        0:
          MESSAGE(AlreadyInvoicedMsg);
        1:
          PAGE.RUN(PAGE::"Sales Invoice",SalesHeader);
        ELSE
          IF CONFIRM(InvoicePostQst) THEN
            PAGE.RUN(PAGE::"Sales Invoice List",SalesHeader);
      END;
    END;

    LOCAL PROCEDURE RemoveFromView@4(VAR TempBookingItem@1000 : TEMPORARY Record 6707);
    BEGIN
      GET(TempBookingItem.Id);
      DELETE;
    END;

    BEGIN
    END.
  }
}

