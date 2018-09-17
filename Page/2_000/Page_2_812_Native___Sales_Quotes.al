OBJECT Page 2812 Native - Sales Quotes
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[@@@={Locked};
               DAN=nativeInvoicingSalesQuotes;
               ENU=nativeInvoicingSalesQuotes];
    SourceTable=Table5505;
    DelayedInsert=Yes;
    PageType=List;
    OnOpenPage=BEGIN
                 BINDSUBSCRIPTION(NativeAPILanguageHandler);
               END;

    OnAfterGetRecord=VAR
                       GraphMgtSalesQuoteBuffer@1000 : Codeunit 5506;
                     BEGIN
                       SetCalculatedFields;
                       GraphMgtSalesQuoteBuffer.RedistributeInvoiceDiscounts(Rec);
                     END;

    OnNewRecord=BEGIN
                  ClearCalculatedFields;
                END;

    OnInsertRecord=VAR
                     GraphMgtSalesQuoteBuffer@1001 : Codeunit 5506;
                   BEGIN
                     CheckCustomer;
                     ProcessBillingPostalAddress;

                     GraphMgtSalesQuoteBuffer.PropagateOnInsert(Rec,TempFieldBuffer);
                     SetDates;

                     UpdateAttachments;
                     UpdateLines;
                     UpdateDiscount;
                     UpdateCoupons;
                     SetNoteForCustomer;

                     SetCalculatedFields;

                     EXIT(FALSE);
                   END;

    OnModifyRecord=VAR
                     GraphMgtSalesQuoteBuffer@1000 : Codeunit 5506;
                   BEGIN
                     IF xRec.Id <> Id THEN
                       ERROR(CannotChangeIDErr);

                     ProcessBillingPostalAddress;

                     GraphMgtSalesQuoteBuffer.PropagateOnModify(Rec,TempFieldBuffer);

                     UpdateAttachments;
                     UpdateLines;
                     UpdateDiscount;
                     UpdateCoupons;
                     SetNoteForCustomer;

                     SetCalculatedFields;

                     EXIT(FALSE);
                   END;

    OnDeleteRecord=VAR
                     GraphMgtSalesQuoteBuffer@1000 : Codeunit 5506;
                   BEGIN
                     GraphMgtSalesQuoteBuffer.PropagateOnDelete(Rec);

                     EXIT(FALSE);
                   END;

    ODataKeyFields=Id;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 18  ;2   ;Field     ;
                Name=id;
                CaptionML=[@@@={Locked};
                           DAN=id;
                           ENU=id];
                ApplicationArea=#All;
                SourceExpr=Id;
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO(Id));
                           END;
                            }

    { 19  ;2   ;Field     ;
                Name=number;
                CaptionML=[@@@={Locked};
                           DAN=Number;
                           ENU=Number];
                ApplicationArea=#All;
                SourceExpr="No.";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("No."));
                           END;
                            }

    { 16  ;2   ;Field     ;
                Name=quoteDate;
                CaptionML=[@@@={Locked};
                           DAN=quoteDate;
                           ENU=quoteDate];
                ApplicationArea=#All;
                SourceExpr="Document Date";
                OnValidate=BEGIN
                             DocumentDateVar := "Document Date";
                             DocumentDateSet := TRUE;

                             RegisterFieldSet(FIELDNO("Document Date"));
                             RegisterFieldSet(FIELDNO("Posting Date"));
                           END;
                            }

    { 10  ;2   ;Field     ;
                Name=dueDate;
                CaptionML=[@@@={Locked};
                           DAN=dueDate;
                           ENU=dueDate];
                ApplicationArea=#All;
                SourceExpr="Due Date";
                OnValidate=BEGIN
                             DueDateVar := "Due Date";
                             DueDateSet := TRUE;

                             RegisterFieldSet(FIELDNO("Due Date"));
                           END;
                            }

    { 24  ;2   ;Field     ;
                Name=validUntilDate;
                CaptionML=[@@@={Locked};
                           DAN=validUntilDate;
                           ENU=validUntilDate];
                ApplicationArea=#All;
                SourceExpr="Quote Valid Until Date";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Quote Valid Until Date"));
                           END;
                            }

    { 25  ;2   ;Field     ;
                Name=status;
                CaptionML=[@@@={Locked};
                           DAN=status;
                           ENU=status];
                ToolTipML=[DAN=Angiver status for salgstilbuddet (Kladde,Sendt,Accepteret,Udl›bet).;
                           ENU=Specifies the status of the Sales Quote (Draft,Sent,Accepted,Expired).];
                ApplicationArea=#All;
                SourceExpr=Status;
                Editable=FALSE }

    { 36  ;2   ;Field     ;
                Name=accepted;
                CaptionML=[DAN=accepteret;
                           ENU=accepted];
                ApplicationArea=#All;
                SourceExpr="Quote Accepted";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Quote Accepted"));
                           END;
                            }

    { 9   ;2   ;Field     ;
                Name=acceptedDate;
                CaptionML=[@@@={Locked};
                           DAN=acceptedDate;
                           ENU=acceptedDate];
                ApplicationArea=#All;
                SourceExpr="Quote Accepted Date" }

    { 7   ;2   ;Field     ;
                Name=customerId;
                CaptionML=[@@@={Locked};
                           DAN=customerId;
                           ENU=customerId];
                ApplicationArea=#All;
                SourceExpr="Customer Id";
                OnValidate=VAR
                             O365SalesInvoiceMgmt@1000 : Codeunit 2310;
                           BEGIN
                             Customer.SETRANGE(Id,"Customer Id");
                             IF NOT Customer.FINDFIRST THEN
                               ERROR(CannotFindCustomerErr);

                             O365SalesInvoiceMgmt.EnforceCustomerTemplateIntegrity(Customer);

                             "Sell-to Customer No." := Customer."No.";
                             RegisterFieldSet(FIELDNO("Customer Id"));
                             RegisterFieldSet(FIELDNO("Sell-to Customer No."));
                             CustomerIdSet := TRUE;
                           END;
                            }

    { 6   ;2   ;Field     ;
                Name=graphContactId;
                CaptionML=[@@@={Locked};
                           DAN=contactId;
                           ENU=contactId];
                ApplicationArea=#All;
                SourceExpr="Contact Graph Id";
                OnValidate=VAR
                             Contact@1000 : Record 5050;
                             Customer@1001 : Record 18;
                             GraphIntContact@1003 : Codeunit 5461;
                           BEGIN
                             IF ("Contact Graph Id" = '') AND CustomerIdSet THEN
                               EXIT;

                             RegisterFieldSet(FIELDNO("Contact Graph Id"));

                             IF "Contact Graph Id" = '' THEN
                               ERROR(ContactIdHasToHaveValueErr);

                             IF NOT GraphIntContact.FindOrCreateCustomerFromGraphContactSafe("Contact Graph Id",Customer,Contact) THEN
                               EXIT;

                             UpdateCustomerFromGraphContactId(Customer);

                             IF Contact."Company No." = Customer."No." THEN BEGIN
                               VALIDATE("Sell-to Contact No.",Contact."No.");
                               VALIDATE("Sell-to Contact",Contact.Name);

                               RegisterFieldSet(FIELDNO("Sell-to Contact No."));
                               RegisterFieldSet(FIELDNO("Sell-to Contact"));
                             END;
                           END;
                            }

    { 5   ;2   ;Field     ;
                Name=customerNumber;
                CaptionML=[@@@={Locked};
                           DAN=customerNumber;
                           ENU=customerNumber];
                ApplicationArea=#All;
                SourceExpr="Sell-to Customer No.";
                OnValidate=VAR
                             O365SalesInvoiceMgmt@1000 : Codeunit 2310;
                           BEGIN
                             IF Customer."No." <> '' THEN
                               EXIT;

                             IF NOT Customer.GET("Sell-to Customer No.") THEN
                               ERROR(CannotFindCustomerErr);

                             O365SalesInvoiceMgmt.EnforceCustomerTemplateIntegrity(Customer);

                             "Customer Id" := Customer.Id;
                             RegisterFieldSet(FIELDNO("Customer Id"));
                             RegisterFieldSet(FIELDNO("Sell-to Customer No."));
                           END;
                            }

    { 4   ;2   ;Field     ;
                Name=customerName;
                CaptionML=[@@@={Locked};
                           DAN=customerName;
                           ENU=customerName];
                ApplicationArea=#All;
                SourceExpr="Sell-to Customer Name";
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                Name=customerEmail;
                CaptionML=[@@@={Locked};
                           DAN=customerEmail;
                           ENU=customerEmail];
                ToolTipML=[DAN=Angiver mailadressen for debitoren.;
                           ENU=Specifies the email address of the customer];
                ApplicationArea=#All;
                SourceExpr=CustomerEmail;
                Editable=FALSE }

    { 23  ;2   ;Field     ;
                Name=taxLiable;
                CaptionML=[DAN=taxLiable;
                           ENU=taxLiable];
                ToolTipML=[DAN=Angiver, om salgsfakturaen omfatter moms.;
                           ENU=Specifies if the sales invoice contains sales tax.];
                ApplicationArea=#All;
                SourceExpr="Tax Liable";
                Importance=Additional;
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Tax Liable"));
                           END;
                            }

    { 20  ;2   ;Field     ;
                Name=taxAreaId;
                CaptionML=[DAN=taxAreaId;
                           ENU=taxAreaId];
                ApplicationArea=#All;
                SourceExpr="Tax Area ID";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Tax Area ID"));

                             IF IsUsingVAT THEN
                               RegisterFieldSet(FIELDNO("VAT Bus. Posting Group"))
                             ELSE
                               RegisterFieldSet(FIELDNO("Tax Area Code"));
                           END;
                            }

    { 35  ;2   ;Field     ;
                Name=taxAreaDisplayName;
                CaptionML=[DAN=taxAreaDisplayName;
                           ENU=taxAreaDisplayName];
                ToolTipML=[DAN=Angiver skatteomr†dets viste navn.;
                           ENU=Specifies the tax area display name.];
                ApplicationArea=#All;
                SourceExpr=TaxAreaDisplayName;
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                Name=taxRegistrationNumber;
                CaptionML=[DAN=taxRegistrationNumber;
                           ENU=taxRegistrationNumber];
                ApplicationArea=#All;
                SourceExpr="VAT Registration No.";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("VAT Registration No."));
                           END;
                            }

    { 3   ;2   ;Field     ;
                Name=billingPostalAddress;
                CaptionML=[@@@={Locked};
                           DAN=billingPostalAddress;
                           ENU=billingPostalAddress];
                ToolTipML=[DAN=Angiver faktureringsadressen i salgsfakturaen.;
                           ENU=Specifies the billing address of the Sales Invoice.];
                ApplicationArea=#All;
                SourceExpr=BillingPostalAddressJSONText;
                OnValidate=BEGIN
                             BillingPostalAddressSet := TRUE;
                           END;

                ODataEDMType=POSTALADDRESS }

    { 29  ;2   ;Field     ;
                Name=pricesIncludeTax;
                CaptionML=[@@@={Locked};
                           DAN=pricesIncludeTax;
                           ENU=pricesIncludeTax];
                ApplicationArea=#All;
                SourceExpr="Prices Including VAT";
                Editable=FALSE;
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Prices Including VAT"));
                           END;
                            }

    { 12  ;2   ;Field     ;
                Name=shipmentMethod;
                CaptionML=[@@@={Locked};
                           DAN=shipmentMethod;
                           ENU=shipmentMethod];
                ApplicationArea=#All;
                SourceExpr="Shipment Method Code";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Shipment Method Code"));
                           END;
                            }

    { 11  ;2   ;Field     ;
                Name=salesperson;
                CaptionML=[@@@={Locked};
                           DAN=salesperson;
                           ENU=salesperson];
                ApplicationArea=#All;
                SourceExpr="Salesperson Code";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Salesperson Code"));
                           END;
                            }

    { 8   ;2   ;Field     ;
                Name=lines;
                CaptionML=[@@@={Locked};
                           DAN=lines;
                           ENU=lines];
                ToolTipML=[DAN=Angiver salgsfakturalinjer;
                           ENU=Specifies Sales Invoice Lines];
                ApplicationArea=#All;
                SourceExpr=SalesQuoteLinesJSON;
                OnValidate=BEGIN
                             SalesLinesSet := PreviousSalesQuoteLinesJSON <> SalesQuoteLinesJSON;
                           END;

                ODataEDMType=Collection(NATIVE-SALESQUOTE-LINE) }

    { 30  ;2   ;Field     ;
                Name=subtotalAmount;
                CaptionML=[DAN=subtotalAmount;
                           ENU=subtotalAmount];
                ApplicationArea=#All;
                SourceExpr="Subtotal Amount";
                Editable=FALSe }

    { 14  ;2   ;Field     ;
                Name=discountAmount;
                CaptionML=[@@@={Locked};
                           DAN=discountAmount;
                           ENU=discountAmount];
                ApplicationArea=#All;
                SourceExpr="Invoice Discount Amount";
                Editable=False }

    { 32  ;2   ;Field     ;
                Name=discountAppliedBeforeTax;
                CaptionML=[@@@={Locked};
                           DAN=discountAppliedBeforeTax;
                           ENU=discountAppliedBeforeTax];
                ApplicationArea=#All;
                SourceExpr="Discount Applied Before Tax" }

    { 31  ;2   ;Field     ;
                Name=coupons;
                CaptionML=[@@@={Locked};
                           DAN=coupons;
                           ENU=coupons];
                ToolTipML=[DAN=Angiver salgsfakturakuponer.;
                           ENU=Specifies Sales Invoice Coupons.];
                ApplicationArea=#All;
                SourceExpr=CouponsJSON;
                OnValidate=BEGIN
                             CouponsSet := PreviousCouponsJSON <> CouponsJSON;
                           END;

                ODataEDMType=Collection(NATIVE-SALESDOCUMENT-COUPON) }

    { 22  ;2   ;Field     ;
                Name=totalAmountExcludingTax;
                CaptionML=[@@@={Locked};
                           DAN=totalAmountExcludingTax;
                           ENU=totalAmountExcludingTax];
                ApplicationArea=#All;
                SourceExpr=Amount;
                Editable=FALSE }

    { 21  ;2   ;Field     ;
                Name=totalTaxAmount;
                CaptionML=[@@@={Locked};
                           DAN=totalTaxAmount;
                           ENU=totalTaxAmount];
                ToolTipML=[DAN=Angiver det samlede momsbel›b p† salgsfakturaen.;
                           ENU=Specifies the total tax amount for the sales invoice.];
                ApplicationArea=#All;
                SourceExpr="Total Tax Amount";
                Editable=FALSE;
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Total Tax Amount"));
                           END;
                            }

    { 17  ;2   ;Field     ;
                Name=totalAmountIncludingTax;
                CaptionML=[@@@={Locked};
                           DAN=totalAmountIncludingTax;
                           ENU=totalAmountIncludingTax];
                ApplicationArea=#All;
                SourceExpr="Amount Including VAT";
                Editable=FALSE;
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Amount Including VAT"));
                           END;
                            }

    { 27  ;2   ;Field     ;
                Name=noteForCustomer;
                CaptionML=[DAN=noteForCustomer;
                           ENU=noteForCustomer];
                ToolTipML=[DAN=Angiver bem‘rkningen til debitoren.;
                           ENU=Specifies the note for the customer.];
                ApplicationArea=#All;
                SourceExpr=WorkDescription;
                OnValidate=BEGIN
                             NoteForCustomerSet := TRUE;
                           END;
                            }

    { 15  ;2   ;Field     ;
                Name=lastModifiedDateTime;
                CaptionML=[@@@={Locked};
                           DAN=lastModifiedDateTime;
                           ENU=lastModifiedDateTime];
                ApplicationArea=#All;
                SourceExpr="Last Modified Date Time";
                Editable=FALSE }

    { 33  ;2   ;Field     ;
                Name=attachments;
                CaptionML=[@@@={Locked};
                           DAN=attachments;
                           ENU=attachments];
                ToolTipML=[DAN=Angiver vedh‘ftede filer;
                           ENU=Specifies Attachments];
                ApplicationArea=#All;
                SourceExpr=AttachmentsJSON;
                OnValidate=BEGIN
                             IsAttachmentsSet := AttachmentsJSON <> PreviousAttachmentsJSON;
                           END;

                ODataEDMType=Collection(NATIVE-ATTACHMENT) }

    { 34  ;2   ;Field     ;
                Name=invoiceDiscountCalculation;
                CaptionML=[DAN=invoiceDiscountCalculation;
                           ENU=invoiceDiscountCalculation];
                OptionCaptionML=[@@@={Locked};
                                 DAN=,%,Amount;
                                 ENU=,%,Amount];
                ApplicationArea=#All;
                SourceExpr="Invoice Discount Calculation";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Invoice Discount Calculation"));
                             DiscountAmountSet := TRUE;
                           END;
                            }

    { 28  ;2   ;Field     ;
                Name=invoiceDiscountValue;
                CaptionML=[DAN=invoiceDiscountValue;
                           ENU=invoiceDiscountValue];
                ApplicationArea=#All;
                SourceExpr="Invoice Discount Value";
                OnValidate=BEGIN
                             RegisterFieldSet(FIELDNO("Invoice Discount Value"));
                             DiscountAmountSet := TRUE;
                           END;
                            }

    { 46  ;2   ;Field     ;
                Name=lastEmailSentStatus;
                CaptionML=[@@@={Locked};
                           DAN=lastEmailSentStatus;
                           ENU=lastEmailSentStatus];
                ToolTipML=[DAN=Angiver status for den sidste afsendte mail: Ikke sendt, Igangsat, F‘rdig eller Fejl.;
                           ENU=Specifies the status of the last sent email, Not Sent, In Process, Finished, or Error.];
                ApplicationArea=#All;
                SourceExpr="Last Email Sent Status";
                Editable=FALSE }

    { 37  ;2   ;Field     ;
                Name=lastEmailSentTime;
                CaptionML=[@@@={Locked};
                           DAN=lastEmailSentTime;
                           ENU=lastEmailSentTime];
                ToolTipML=[DAN=Angiver tidspunktet, den sidste mail blev sendt p†.;
                           ENU=Specifies the time that the last email was sent.];
                ApplicationArea=#All;
                SourceExpr=LastEmailSentTime;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      TempFieldBuffer@1004 : TEMPORARY Record 8450;
      Customer@1006 : Record 18;
      DummySalesLine@1002 : Record 37;
      NativeAPILanguageHandler@1033 : Codeunit 2850;
      BillingPostalAddressJSONText@1000 : Text;
      CustomerEmail@1010 : Text;
      SalesQuoteLinesJSON@1003 : Text;
      PreviousSalesQuoteLinesJSON@1001 : Text;
      CouponsJSON@1022 : Text;
      PreviousCouponsJSON@1021 : Text;
      AttachmentsJSON@1024 : Text;
      TaxAreaDisplayName@1030 : Text;
      PreviousAttachmentsJSON@1025 : Text;
      BillingPostalAddressSet@1005 : Boolean;
      CannotFindCustomerErr@1008 : TextConst 'DAN=Debitoren blev ikke fundet.;ENU=The customer cannot be found.';
      ContactIdHasToHaveValueErr@1007 : TextConst 'DAN=Der skal angives en v‘rdi for kontakt-id''et.;ENU=Contact Id must have a value set.';
      CannotChangeIDErr@1009 : TextConst 'DAN=Id''et kan ikke ‘ndres.;ENU=The id cannot be changed.';
      SalesLinesSet@1015 : Boolean;
      CouponsSet@1023 : Boolean;
      DiscountAmountSet@1014 : Boolean;
      IsAttachmentsSet@1026 : Boolean;
      InvoiceDiscountAmount@1013 : Decimal;
      WorkDescription@1012 : Text;
      CustomerNotProvidedErr@1016 : TextConst 'DAN=Der skal angives et customerNumber eller customerID.;ENU=A customerNumber or a customerID must be provided.';
      NoteForCustomerSet@1017 : Boolean;
      DocumentDateSet@1020 : Boolean;
      DocumentDateVar@1019 : Date;
      DueDateSet@1018 : Boolean;
      DueDateVar@1011 : Date;
      CannotFindQuoteErr@1041 : TextConst 'DAN=Tilbuddet blev ikke fundet.;ENU=The quote cannot be found.';
      EmptyEmailErr@1043 : TextConst 'DAN=Modtagers mailadresse er tom. Angiv mailadressen for debitoren eller for tilbuddet i mailvisningen.;ENU=The send-to email is empty. Specify email either for the customer or for the quote in email preview.';
      MailNotConfiguredErr@1044 : TextConst 'DAN=Du skal konfigurere en mailkonto for at kunne sende mails.;ENU=An email account must be configured to send emails.';
      InvoiceDiscountPctMustBePositiveErr@1028 : TextConst 'DAN=Fakturaens rabatprocent skal v‘re positiv.;ENU=Invoice discount percentage must be positive.';
      InvoiceDiscountPctMustBeBelowHundredErr@1027 : TextConst 'DAN=Fakturaens rabatprocent skal v‘re under 100.;ENU=Invoice discount percentage must be below 100.';
      InvoiceDiscountAmtMustBePositiveErr@1029 : TextConst 'DAN=Fakturaens rabat skal v‘re positiv.;ENU=Invoice discount must be positive.';
      CustomerIdSet@1032 : Boolean;
      LastEmailSentTime@1031 : DateTime;

    LOCAL PROCEDURE SetCalculatedFields@6();
    VAR
      TempSalesInvoiceLineAggregate@1002 : TEMPORARY Record 5476;
      DummyNativeAPITaxSetup@1005 : Record 2850;
      GraphMgtSalesQuote@1000 : Codeunit 5505;
      NativeEDMTypes@1001 : Codeunit 2801;
      NativeCoupons@1003 : Codeunit 2815;
      NativeAttachments@1004 : Codeunit 2820;
    BEGIN
      BillingPostalAddressJSONText := GraphMgtSalesQuote.BillToCustomerAddressToJSON(Rec);
      IF Customer.GET("Sell-to Customer No.") THEN
        CustomerEmail := Customer."E-Mail"
      ELSE
        CustomerEmail := '';

      LoadLines(TempSalesInvoiceLineAggregate,Rec);
      SalesQuoteLinesJSON := NativeEDMTypes.WriteSalesLinesJSON(TempSalesInvoiceLineAggregate);
      PreviousSalesQuoteLinesJSON := SalesQuoteLinesJSON;

      CouponsJSON := NativeCoupons.WriteCouponsJSON(DummySalesLine."Document Type"::Quote,"No.",FALSE);
      PreviousCouponsJSON := CouponsJSON;

      AttachmentsJSON := NativeAttachments.GenerateAttachmentsJSON(Id);
      PreviousAttachmentsJSON := AttachmentsJSON;
      TaxAreaDisplayName := DummyNativeAPITaxSetup.GetTaxAreaDisplayName("Tax Area ID");

      GetNoteForCustomer;
      GetLastEmailSentTime;
    END;

    LOCAL PROCEDURE ClearCalculatedFields@10();
    BEGIN
      CLEAR(BillingPostalAddressJSONText);
      CLEAR(SalesQuoteLinesJSON);
      CLEAR(PreviousSalesQuoteLinesJSON);
      CLEAR(SalesLinesSet);
      CLEAR(AttachmentsJSON);
      CLEAR(PreviousAttachmentsJSON);
      CLEAR(IsAttachmentsSet);
      CLEAR(WorkDescription);
      CLEAR(TaxAreaDisplayName);
      CLEAR(LastEmailSentTime);
      TempFieldBuffer.DELETEALL;
    END;

    LOCAL PROCEDURE RegisterFieldSet@11(FieldNo@1000 : Integer);
    VAR
      LastOrderNo@1001 : Integer;
    BEGIN
      LastOrderNo := 1;
      IF TempFieldBuffer.FINDLAST THEN
        LastOrderNo := TempFieldBuffer.Order + 1;

      CLEAR(TempFieldBuffer);
      TempFieldBuffer.Order := LastOrderNo;
      TempFieldBuffer."Table ID" := DATABASE::"Sales Quote Entity Buffer";
      TempFieldBuffer."Field ID" := FieldNo;
      TempFieldBuffer.INSERT;
    END;

    LOCAL PROCEDURE ProcessBillingPostalAddress@5();
    VAR
      GraphMgtSalesQuote@1000 : Codeunit 5505;
    BEGIN
      IF NOT BillingPostalAddressSet THEN
        EXIT;

      GraphMgtSalesQuote.ProcessComplexTypes(Rec,BillingPostalAddressJSONText);

      IF xRec."Sell-to Address" <> "Sell-to Address" THEN
        RegisterFieldSet(FIELDNO("Sell-to Address"));

      IF xRec."Sell-to Address 2" <> "Sell-to Address 2" THEN
        RegisterFieldSet(FIELDNO("Sell-to Address 2"));

      IF xRec."Sell-to City" <> "Sell-to City" THEN
        RegisterFieldSet(FIELDNO("Sell-to City"));

      IF xRec."Sell-to Country/Region Code" <> "Sell-to Country/Region Code" THEN
        RegisterFieldSet(FIELDNO("Sell-to Country/Region Code"));

      IF xRec."Sell-to Post Code" <> "Sell-to Post Code" THEN
        RegisterFieldSet(FIELDNO("Sell-to Post Code"));

      IF xRec."Sell-to County" <> "Sell-to County" THEN
        RegisterFieldSet(FIELDNO("Sell-to County"));
    END;

    LOCAL PROCEDURE UpdateCustomerFromGraphContactId@2(VAR Customer@1001 : Record 18);
    VAR
      O365SalesInvoiceMgmt@1002 : Codeunit 2310;
      UpdateCustomer@1000 : Boolean;
    BEGIN
      UpdateCustomer := "Sell-to Customer No." = '';
      IF NOT UpdateCustomer THEN BEGIN
        TempFieldBuffer.RESET;
        TempFieldBuffer.SETRANGE("Field ID",FIELDNO("Customer Id"));
        UpdateCustomer := NOT TempFieldBuffer.FINDFIRST;
        TempFieldBuffer.RESET;
      END;

      IF UpdateCustomer THEN BEGIN
        VALIDATE("Customer Id",Customer.Id);
        VALIDATE("Sell-to Customer No.",Customer."No.");
        RegisterFieldSet(FIELDNO("Customer Id"));
        RegisterFieldSet(FIELDNO("Sell-to Customer No."));
      END;

      O365SalesInvoiceMgmt.EnforceCustomerTemplateIntegrity(Customer);
    END;

    LOCAL PROCEDURE LoadLines@1(VAR TempSalesInvoiceLineAggregate@1000 : TEMPORARY Record 5476;VAR SalesQuoteEntityBuffer@1001 : Record 5505);
    VAR
      GraphMgtSalesQuoteBuffer@1002 : Codeunit 5506;
    BEGIN
      TempSalesInvoiceLineAggregate.SETRANGE("Document Id",SalesQuoteEntityBuffer.Id);
      GraphMgtSalesQuoteBuffer.LoadLines(TempSalesInvoiceLineAggregate,TempSalesInvoiceLineAggregate.GETFILTER("Document Id"));
    END;

    LOCAL PROCEDURE UpdateLines@4();
    VAR
      TempSalesInvoiceLineAggregate@1002 : TEMPORARY Record 5476;
      GraphMgtSalesQuoteBuffer@1000 : Codeunit 5506;
      NativeEDMTypes@1001 : Codeunit 2801;
    BEGIN
      IF NOT SalesLinesSet THEN
        EXIT;

      NativeEDMTypes.ParseSalesLinesJSON(
        DummySalesLine."Document Type"::Quote,SalesQuoteLinesJSON,TempSalesInvoiceLineAggregate,Id);
      TempSalesInvoiceLineAggregate.SETRANGE("Document Id",Id);
      GraphMgtSalesQuoteBuffer.PropagateMultipleLinesUpdate(TempSalesInvoiceLineAggregate);
      FIND;
    END;

    LOCAL PROCEDURE UpdateDiscount@13();
    VAR
      SalesHeader@1002 : Record 36;
      SalesLine@1009 : Record 37;
      TotalSalesLine@1008 : Record 37;
      CustInvDisc@1007 : Record 19;
      SalesCalcDiscountByType@1006 : Codeunit 56;
      O365Discounts@1005 : Codeunit 2155;
      DocumentTotals@1004 : Codeunit 57;
      GraphMgtSalesQuoteBuffer@1000 : Codeunit 5506;
      VatAmount@1003 : Decimal;
      InvoiceDiscountPct@1001 : Decimal;
    BEGIN
      IF SalesLinesSet AND (NOT DiscountAmountSet) THEN BEGIN
        GraphMgtSalesQuoteBuffer.RedistributeInvoiceDiscounts(Rec);
        EXIT;
      END;

      IF NOT DiscountAmountSet THEN
        EXIT;

      CASE "Invoice Discount Calculation" OF
        "Invoice Discount Calculation"::"%":
          BEGIN
            IF "Invoice Discount Value" < 0 THEN
              ERROR(InvoiceDiscountPctMustBePositiveErr);
            IF "Invoice Discount Value" > 100 THEN
              ERROR(InvoiceDiscountPctMustBeBelowHundredErr);
            InvoiceDiscountPct := "Invoice Discount Value";
          END;
        "Invoice Discount Calculation"::Amount:
          BEGIN
            InvoiceDiscountAmount := "Invoice Discount Value";
            IF "Invoice Discount Value" < 0 THEN
              ERROR(InvoiceDiscountAmtMustBePositiveErr);
          END;
      END;

      SalesHeader.GET("Document Type"::Quote,"No.");
      IF InvoiceDiscountPct <> 0 THEN BEGIN
        O365Discounts.ApplyInvoiceDiscountPercentage(SalesHeader,InvoiceDiscountPct);
        SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.",SalesHeader."No.");
        IF SalesLine.FINDFIRST THEN BEGIN
          GraphMgtSalesQuoteBuffer.RedistributeInvoiceDiscounts(Rec);
          DocumentTotals.CalculateSalesTotals(TotalSalesLine,VatAmount,SalesLine);
          "Invoice Discount Amount" := TotalSalesLine."Inv. Discount Amount";
        END;
      END ELSE BEGIN
        CustInvDisc.SETRANGE(Code,"No.");
        CustInvDisc.DELETEALL;
        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
        GraphMgtSalesQuoteBuffer.RedistributeInvoiceDiscounts(Rec);
      END;
    END;

    LOCAL PROCEDURE UpdateCoupons@14();
    VAR
      NativeEDMTypes@1000 : Codeunit 2801;
    BEGIN
      IF NOT CouponsSet THEN
        EXIT;

      NativeEDMTypes.ParseCouponsJSON("Contact Graph Id",DummySalesLine."Document Type"::Quote,"No.",CouponsJSON);
    END;

    LOCAL PROCEDURE UpdateAttachments@7();
    VAR
      NativeAttachments@1001 : Codeunit 2820;
    BEGIN
      IF NOT IsAttachmentsSet THEN
        EXIT;

      // Here we now know that user has specified different attachments than before.
      // We should patch the attachments. This means:
      // Delete the ones not in use anymore.
      // Add new ones.
      // Keep old ones.

      NativeAttachments.UpdateAttachments(Id,AttachmentsJSON,PreviousAttachmentsJSON);
    END;

    LOCAL PROCEDURE CheckCustomer@3();
    VAR
      BlankGUID@1000 : GUID;
    BEGIN
      IF ("Sell-to Customer No." = '') AND
         ("Customer Id" = BlankGUID)
      THEN
        ERROR(CustomerNotProvidedErr);
    END;

    LOCAL PROCEDURE GetLastEmailSentTime@19();
    VAR
      SalesHeader@1001 : Record 36;
    BEGIN
      CLEAR(LastEmailSentTime);
      SalesHeader.SETAUTOCALCFIELDS("Last Email Sent Time");
      SalesHeader.GET("Document Type","No.");
      LastEmailSentTime := SalesHeader."Last Email Sent Time";
    END;

    LOCAL PROCEDURE GetNoteForCustomer@9();
    VAR
      SalesHeader@1001 : Record 36;
      WorkDescriptionInStream@1002 : InStream;
    BEGIN
      CLEAR(WorkDescription);

      SalesHeader.SETAUTOCALCFIELDS("Work Description");
      SalesHeader.GET(SalesHeader."Document Type"::Quote,"No.");
      SalesHeader."Work Description".CREATEINSTREAM(WorkDescriptionInStream);

      WorkDescriptionInStream.READ(WorkDescription);
    END;

    LOCAL PROCEDURE SetNoteForCustomer@22();
    VAR
      SalesHeader@1000 : Record 36;
      WorkDescriptionOutStream@1001 : OutStream;
    BEGIN
      IF NOT NoteForCustomerSet THEN
        EXIT;

      SalesHeader.GET(SalesHeader."Document Type"::Quote,"No.");
      SalesHeader."Work Description".CREATEOUTSTREAM(WorkDescriptionOutStream);
      WorkDescriptionOutStream.WRITE(WorkDescription);
      SalesHeader.MODIFY(TRUE);
      FIND;
    END;

    LOCAL PROCEDURE SetDates@8();
    VAR
      GraphMgtSalesQuoteBuffer@1000 : Codeunit 5506;
    BEGIN
      IF NOT (DueDateSet OR DocumentDateSet) THEN
        EXIT;

      TempFieldBuffer.RESET;
      TempFieldBuffer.DELETEALL;

      IF DocumentDateSet THEN BEGIN
        "Document Date" := DocumentDateVar;
        "Posting Date" := DocumentDateVar;
        RegisterFieldSet(FIELDNO("Document Date"));
        RegisterFieldSet(FIELDNO("Posting Date"));
      END;

      IF DueDateSet THEN BEGIN
        "Due Date" := DueDateVar;
        RegisterFieldSet(FIELDNO("Due Date"));
      END;

      GraphMgtSalesQuoteBuffer.PropagateOnModify(Rec,TempFieldBuffer);
      FIND;
    END;

    LOCAL PROCEDURE GetQuote@36(VAR SalesHeader@1000 : Record 36);
    BEGIN
      SalesHeader.SETRANGE(Id,Id);
      IF NOT SalesHeader.FINDFIRST THEN
        ERROR(CannotFindQuoteErr);
    END;

    LOCAL PROCEDURE CheckSmtpMailSetup@30();
    VAR
      O365SetupEmail@1001 : Codeunit 2135;
    BEGIN
      IF NOT O365SetupEmail.SMTPEmailIsSetUp THEN
        ERROR(MailNotConfiguredErr);
    END;

    LOCAL PROCEDURE CheckSendToEmailAddress@21();
    BEGIN
      IF GetSendToEmailAddress = '' THEN
        ERROR(EmptyEmailErr);
    END;

    LOCAL PROCEDURE GetSendToEmailAddress@26() : Text[250];
    VAR
      EmailAddress@1000 : Text[250];
    BEGIN
      EmailAddress := GetDocumentEmailAddress;
      IF EmailAddress <> '' THEN
        EXIT(EmailAddress);
      EmailAddress := GetCustomerEmailAddress;
      EXIT(EmailAddress);
    END;

    LOCAL PROCEDURE GetCustomerEmailAddress@24() : Text[250];
    BEGIN
      IF NOT Customer.GET("Sell-to Customer No.") THEN
        EXIT('');
      EXIT(Customer."E-Mail");
    END;

    LOCAL PROCEDURE GetDocumentEmailAddress@58() : Text[250];
    VAR
      EmailParameter@1002 : Record 9510;
    BEGIN
      IF NOT EmailParameter.GET("No.","Document Type",EmailParameter."Parameter Type"::Address) THEN
        EXIT('');
      EXIT(EmailParameter."Parameter Value");
    END;

    LOCAL PROCEDURE SendQuote@34(VAR SalesHeader@1000 : Record 36);
    VAR
      DummyO365SalesDocument@1003 : Record 2103;
      LinesInstructionMgt@1002 : Codeunit 1320;
      O365SendResendInvoice@1001 : Codeunit 2104;
      GraphIntBusinessProfile@1004 : Codeunit 5442;
    BEGIN
      O365SendResendInvoice.CheckDocumentIfNoItemsExists(SalesHeader,FALSE,DummyO365SalesDocument);
      LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(SalesHeader);
      CheckSmtpMailSetup;
      CheckSendToEmailAddress;
      GraphIntBusinessProfile.SyncFromGraphSynchronously;

      SalesHeader.SETRECFILTER;
      SalesHeader.EmailRecords(FALSE);
    END;

    LOCAL PROCEDURE SetActionResponse@47(VAR ActionContext@1004 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext";VAR SalesHeader@1000 : Record 36);
    VAR
      ODataActionManagement@1003 : Codeunit 6711;
    BEGIN
      ODataActionManagement.AddKey(FIELDNO(Id),SalesHeader.Id);
      IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN
        ODataActionManagement.SetDeleteResponseLocation(ActionContext,PAGE::"Native - Sales Inv. Entity")
      ELSE
        ODataActionManagement.SetDeleteResponseLocation(ActionContext,PAGE::"Native - Sales Quotes");
    END;

    [ServiceEnabled]
    [External]
    PROCEDURE MakeInvoice@15(VAR ActionContext@1000 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext");
    VAR
      SalesHeader@1001 : Record 36;
      SalesQuoteToInvoice@1005 : Codeunit 1305;
    BEGIN
      GetQuote(SalesHeader);
      SalesHeader.SETRECFILTER;
      SalesQuoteToInvoice.RUN(SalesHeader);
      SalesQuoteToInvoice.GetSalesInvoiceHeader(SalesHeader);
      SetActionResponse(ActionContext,SalesHeader);
    END;

    [ServiceEnabled]
    [External]
    PROCEDURE Send@17(VAR ActionContext@1000 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext");
    VAR
      SalesHeader@1005 : Record 36;
    BEGIN
      GetQuote(SalesHeader);
      SendQuote(SalesHeader);
      SetActionResponse(ActionContext,SalesHeader);
    END;

    BEGIN
    END.
  }
}

