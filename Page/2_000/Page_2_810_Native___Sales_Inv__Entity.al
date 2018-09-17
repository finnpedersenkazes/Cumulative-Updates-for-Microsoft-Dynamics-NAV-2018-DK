OBJECT Page 2810 Native - Sales Inv. Entity
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
               DAN=nativeInvoicingSalesInvoices;
               ENU=nativeInvoicingSalesInvoices];
    SourceTable=Table5475;
    DelayedInsert=Yes;
    PageType=List;
    OnOpenPage=BEGIN
                 BINDSUBSCRIPTION(NativeAPILanguageHandler);
               END;

    OnAfterGetRecord=VAR
                       SalesInvoiceAggregator@1001 : Codeunit 5477;
                     BEGIN
                       SetCalculatedFields;
                       SalesInvoiceAggregator.RedistributeInvoiceDiscounts(Rec);
                     END;

    OnNewRecord=BEGIN
                  ClearCalculatedFields;
                END;

    OnInsertRecord=VAR
                     SalesInvoiceAggregator@1002 : Codeunit 5477;
                   BEGIN
                     CheckCustomer;
                     ProcessBillingPostalAddress;

                     SalesInvoiceAggregator.PropagateOnInsert(Rec,TempFieldBuffer);
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
                     SalesInvoiceAggregator@1002 : Codeunit 5477;
                   BEGIN
                     IF Posted THEN BEGIN
                       IF NOT IsAttachmentsSet THEN
                         ERROR(CannotModifyPostedInvioceErr);
                       UpdateAttachments;
                       SetAttachmentsJSON;
                       EXIT(FALSE);
                     END;

                     IF xRec.Id <> Id THEN
                       ERROR(CannotChangeIDErr);

                     ProcessBillingPostalAddress;

                     SalesInvoiceAggregator.PropagateOnModify(Rec,TempFieldBuffer);

                     UpdateAttachments;
                     UpdateLines;
                     UpdateDiscount;
                     UpdateCoupons;
                     SetNoteForCustomer;

                     SetCalculatedFields;

                     EXIT(FALSE);
                   END;

    OnDeleteRecord=VAR
                     SalesInvoiceAggregator@1000 : Codeunit 5477;
                   BEGIN
                     SalesInvoiceAggregator.PropagateOnDelete(Rec);

                     EXIT(FALSE);
                   END;

    ODataKeyFields=Id;
  }
  CONTROLS
  {
    { 21  ;0   ;Container ;
                ContainerType=ContentArea }

    { 20  ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 19  ;2   ;Field     ;
                Name=id;
                CaptionML=[@@@={Locked};
                           DAN=id;
                           ENU=id];
                ApplicationArea=#All;
                SourceExpr=Id;
                OnValidate=BEGIN
                             CheckStatus;
                             RegisterFieldSet(FIELDNO(Id));
                           END;
                            }

    { 18  ;2   ;Field     ;
                Name=number;
                CaptionML=[@@@={Locked};
                           DAN=Number;
                           ENU=Number];
                ApplicationArea=#All;
                SourceExpr="No.";
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                Name=customerId;
                CaptionML=[@@@={Locked};
                           DAN=customerId;
                           ENU=customerId];
                ApplicationArea=#All;
                SourceExpr="Customer Id";
                OnValidate=VAR
                             O365SalesInvoiceMgmt@1000 : Codeunit 2310;
                           BEGIN
                             CheckStatus;

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

    { 23  ;2   ;Field     ;
                Name=graphContactId;
                CaptionML=[@@@={Locked};
                           DAN=graphContactId;
                           ENU=graphContactId];
                ApplicationArea=#All;
                SourceExpr="Contact Graph Id";
                OnValidate=VAR
                             Contact@1000 : Record 5050;
                             Customer@1001 : Record 18;
                             GraphIntContact@1003 : Codeunit 5461;
                           BEGIN
                             CheckStatus;

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

    { 36  ;2   ;Field     ;
                Name=customerNumber;
                CaptionML=[@@@={Locked};
                           DAN=customerNumber;
                           ENU=customerNumber];
                ApplicationArea=#All;
                SourceExpr="Sell-to Customer No.";
                OnValidate=VAR
                             O365SalesInvoiceMgmt@1000 : Codeunit 2310;
                           BEGIN
                             CheckStatus;

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

    { 3   ;2   ;Field     ;
                Name=taxLiable;
                CaptionML=[DAN=taxLiable;
                           ENU=taxLiable];
                ToolTipML=[DAN=Angiver, om salgsfakturaen omfatter moms.;
                           ENU=Specifies if the sales invoice contains sales tax.];
                ApplicationArea=#All;
                SourceExpr="Tax Liable";
                Importance=Additional;
                OnValidate=BEGIN
                             CheckStatus;
                             RegisterFieldSet(FIELDNO("Tax Liable"));
                           END;
                            }

    { 26  ;2   ;Field     ;
                Name=taxAreaId;
                CaptionML=[DAN=taxAreaId;
                           ENU=taxAreaId];
                ApplicationArea=#All;
                SourceExpr="Tax Area ID";
                OnValidate=BEGIN
                             CheckStatus;

                             RegisterFieldSet(FIELDNO("Tax Area ID"));

                             IF IsUsingVAT THEN
                               RegisterFieldSet(FIELDNO("VAT Bus. Posting Group"))
                             ELSE
                               RegisterFieldSet(FIELDNO("Tax Area Code"));
                           END;
                            }

    { 33  ;2   ;Field     ;
                Name=taxAreaDisplayName;
                CaptionML=[DAN=taxAreaDisplayName;
                           ENU=taxAreaDisplayName];
                ToolTipML=[DAN=Angiver skatteomr†dets viste navn.;
                           ENU=Specifies the tax area display name.];
                ApplicationArea=#All;
                SourceExpr=TaxAreaDisplayName;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                Name=taxRegistrationNumber;
                CaptionML=[DAN=taxRegistrationNumber;
                           ENU=taxRegistrationNumber];
                ApplicationArea=#All;
                SourceExpr="VAT Registration No.";
                OnValidate=BEGIN
                             CheckStatus;
                             RegisterFieldSet(FIELDNO("VAT Registration No."));
                           END;
                            }

    { 15  ;2   ;Field     ;
                Name=customerName;
                CaptionML=[@@@={Locked};
                           DAN=customerName;
                           ENU=customerName];
                ApplicationArea=#All;
                SourceExpr="Sell-to Customer Name";
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                Name=customerEmail;
                CaptionML=[@@@={Locked};
                           DAN=customerEmail;
                           ENU=customerEmail];
                ToolTipML=[DAN=Angiver mailadressen for debitoren.;
                           ENU=Specifies the email address of the customer.];
                ApplicationArea=#All;
                SourceExpr=CustomerEmail;
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                Name=invoiceDate;
                CaptionML=[@@@={Locked};
                           DAN=invoiceDate;
                           ENU=invoiceDate];
                ApplicationArea=#All;
                SourceExpr="Document Date";
                OnValidate=BEGIN
                             CheckStatus;

                             DocumentDateVar := "Document Date";
                             DocumentDateSet := TRUE;

                             RegisterFieldSet(FIELDNO("Document Date"));
                             RegisterFieldSet(FIELDNO("Posting Date"));
                           END;
                            }

    { 24  ;2   ;Field     ;
                Name=dueDate;
                CaptionML=[@@@={Locked};
                           DAN=dueDate;
                           ENU=dueDate];
                ApplicationArea=#All;
                SourceExpr="Due Date";
                OnValidate=BEGIN
                             CheckStatus;

                             DueDateVar := "Due Date";
                             DueDateSet := TRUE;

                             RegisterFieldSet(FIELDNO("Due Date"));
                           END;
                            }

    { 6   ;2   ;Field     ;
                Name=billingPostalAddress;
                CaptionML=[@@@={Locked};
                           DAN=billingPostalAddress;
                           ENU=billingPostalAddress];
                ToolTipML=[DAN=Angiver faktureringsadressen i salgsfakturaen.;
                           ENU=Specifies the billing address of the Sales Invoice.];
                ApplicationArea=#All;
                SourceExpr=BillingPostalAddressJSONText;
                OnValidate=BEGIN
                             CheckStatus;
                             BillingPostalAddressSet := TRUE;
                           END;

                ODataEDMType=POSTALADDRESS }

    { 28  ;2   ;Field     ;
                Name=pricesIncludeTax;
                CaptionML=[@@@={Locked};
                           DAN=pricesIncludeTax;
                           ENU=pricesIncludeTax];
                ApplicationArea=#All;
                SourceExpr="Prices Including VAT";
                Editable=FALSE }

    { 1   ;2   ;Field     ;
                Name=lines;
                CaptionML=[@@@={Locked};
                           DAN=lines;
                           ENU=lines];
                ToolTipML=[DAN=Angiver salgsfakturalinjer;
                           ENU=Specifies Sales Invoice Lines];
                ApplicationArea=#All;
                SourceExpr=SalesInvoiceLinesJSON;
                OnValidate=BEGIN
                             CheckStatus;
                             SalesLinesSet := PreviousSalesInvoiceLinesJSON <> SalesInvoiceLinesJSON;
                           END;

                ODataEDMType=Collection(NATIVE-SALESINVOICE-LINE) }

    { 17  ;2   ;Field     ;
                Name=subtotalAmount;
                CaptionML=[DAN=subtotalAmount;
                           ENU=subtotalAmount];
                ApplicationArea=#All;
                SourceExpr="Subtotal Amount";
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                Name=discountAmount;
                CaptionML=[@@@={Locked};
                           DAN=discountAmount;
                           ENU=discountAmount];
                ApplicationArea=#All;
                SourceExpr="Invoice Discount Amount";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                Name=discountAppliedBeforeTax;
                CaptionML=[@@@={Locked};
                           DAN=discountAppliedBeforeTax;
                           ENU=discountAppliedBeforeTax];
                ApplicationArea=#All;
                SourceExpr="Discount Applied Before Tax";
                Editable=FALSE }

    { 25  ;2   ;Field     ;
                Name=coupons;
                CaptionML=[@@@={Locked};
                           DAN=coupons;
                           ENU=coupons];
                ToolTipML=[DAN=Angiver salgsfakturakuponer.;
                           ENU=Specifies Sales Invoice Coupons.];
                ApplicationArea=#All;
                SourceExpr=CouponsJSON;
                OnValidate=BEGIN
                             CheckStatus;
                             CouponsSet := PreviousCouponsJSON <> CouponsJSON;
                           END;

                ODataEDMType=Collection(NATIVE-SALESDOCUMENT-COUPON) }

    { 9   ;2   ;Field     ;
                Name=totalAmountExcludingTax;
                CaptionML=[@@@={Locked};
                           DAN=totalAmountExcludingTax;
                           ENU=totalAmountExcludingTax];
                ApplicationArea=#All;
                SourceExpr=Amount;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                Name=totalTaxAmount;
                CaptionML=[@@@={Locked};
                           DAN=totalTaxAmount;
                           ENU=totalTaxAmount];
                ToolTipML=[DAN=Angiver det samlede momsbel›b p† salgsfakturaen.;
                           ENU=Specifies the total tax amount for the sales invoice.];
                ApplicationArea=#All;
                SourceExpr="Total Tax Amount";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                Name=totalAmountIncludingTax;
                CaptionML=[@@@={Locked};
                           DAN=totalAmountIncludingTax;
                           ENU=totalAmountIncludingTax];
                ApplicationArea=#All;
                SourceExpr="Amount Including VAT";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                Name=noteForCustomer;
                CaptionML=[DAN=noteForCustomer;
                           ENU=noteForCustomer];
                ToolTipML=[DAN=Angiver bem‘rkningen til debitoren.;
                           ENU=Specifies the note for the customer.];
                ApplicationArea=#All;
                SourceExpr=WorkDescription;
                OnValidate=BEGIN
                             CheckStatus;
                             NoteForCustomerSet := TRUE;
                           END;
                            }

    { 13  ;2   ;Field     ;
                Name=status;
                CaptionML=[@@@={Locked};
                           DAN=status;
                           ENU=status];
                ToolTipML=[DAN=Angiver status for salgsfakturaen (annulleret, betalt, afventer, oprettet).;
                           ENU=Specifies the status of the Sales Invoice (cancelled, paid, on hold, created).];
                ApplicationArea=#All;
                SourceExpr=Status;
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                Name=lastModifiedDateTime;
                CaptionML=[@@@={Locked};
                           DAN=lastModifiedDateTime;
                           ENU=lastModifiedDateTime];
                ApplicationArea=#All;
                SourceExpr="Last Modified Date Time";
                Editable=FALSE }

    { 30  ;2   ;Field     ;
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

    { 4   ;2   ;Field     ;
                Name=invoiceDiscountCalculation;
                CaptionML=[DAN=invoiceDiscountCalculation;
                           ENU=invoiceDiscountCalculation];
                OptionCaptionML=[@@@={Locked};
                                 DAN=,%,Amount;
                                 ENU=,%,Amount];
                ApplicationArea=#All;
                SourceExpr="Invoice Discount Calculation";
                OnValidate=BEGIN
                             CheckStatus;
                             RegisterFieldSet(FIELDNO("Invoice Discount Calculation"));
                             DiscountAmountSet := TRUE;
                           END;
                            }

    { 31  ;2   ;Field     ;
                Name=invoiceDiscountValue;
                CaptionML=[DAN=invoiceDiscountValue;
                           ENU=invoiceDiscountValue];
                ApplicationArea=#All;
                SourceExpr="Invoice Discount Value";
                OnValidate=BEGIN
                             CheckStatus;
                             RegisterFieldSet(FIELDNO("Invoice Discount Value"));
                             DiscountAmountSet := TRUE;
                           END;
                            }

    { 32  ;2   ;Field     ;
                Name=remainingAmount;
                CaptionML=[DAN=Restbel›b;
                           ENU=remainingAmount];
                ToolTipML=[DAN=Angiver statussen for fakturaen.;
                           ENU=Specifies the Status for the Invoice];
                ApplicationArea=#All;
                SourceExpr=RemainingAmountVar;
                Editable=FALSE }

    { 34  ;2   ;Field     ;
                Name=lastEmailSentStatus;
                CaptionML=[@@@={Locked};
                           DAN=lastEmailSentStatus;
                           ENU=lastEmailSentStatus];
                ToolTipML=[DAN=Angiver status for den sidste afsendte mail: Ikke sendt, Igangsat, F‘rdig eller Fejl.;
                           ENU=Specifies the status of the last sent email, Not Sent, In Process, Finished, or Error.];
                ApplicationArea=#All;
                SourceExpr="Last Email Sent Status";
                Editable=FALSE }

    { 35  ;2   ;Field     ;
                Name=lastEmailSentTime;
                CaptionML=[@@@={Locked};
                           DAN=lastEmailSentTime;
                           ENU=lastEmailSentTime];
                ToolTipML=[DAN=Angiver tidspunktet, den sidste mail blev sendt p†.;
                           ENU=Specifies the time that the last email was sent.];
                ApplicationArea=#All;
                SourceExpr=LastEmailSentTime;
                Editable=FALSE }

    { 29  ;2   ;Part      ;
                Name=Payments;
                CaptionML=[@@@={Locked};
                           DAN=Payments;
                           ENU=Payments];
                ApplicationArea=#All;
                SubPageLink=Applies-to Invoice Id=FIELD(Id);
                PagePartID=Page2831;
                PartType=Page }

  }
  CODE
  {
    VAR
      CannotChangeIDErr@1004 : TextConst '@@@={Locked};DAN=The id cannot be changed.;ENU=The id cannot be changed.';
      TempFieldBuffer@1001 : TEMPORARY Record 8450;
      Customer@1003 : Record 18;
      DummySalesLine@1017 : Record 37;
      NativeAPILanguageHandler@1040 : Codeunit 2850;
      BillingPostalAddressJSONText@1002 : Text;
      CustomerEmail@1010 : Text;
      SalesInvoiceLinesJSON@1006 : Text;
      PreviousSalesInvoiceLinesJSON@1009 : Text;
      CouponsJSON@1022 : Text;
      PreviousCouponsJSON@1023 : Text;
      AttachmentsJSON@1025 : Text;
      PreviousAttachmentsJSON@1026 : Text;
      TaxAreaDisplayName@1035 : Text;
      BillingPostalAddressSet@1000 : Boolean;
      CannotFindCustomerErr@1005 : TextConst '@@@={Locked};DAN=The customer cannot be found.;ENU=The customer cannot be found.';
      ContactIdHasToHaveValueErr@1007 : TextConst 'DAN=Der skal angives en v‘rdi for kontakt-id''et.;ENU=Contact Id must have a value set.';
      SalesLinesSet@1008 : Boolean;
      CouponsSet@1024 : Boolean;
      DiscountAmountSet@1013 : Boolean;
      IsAttachmentsSet@1027 : Boolean;
      InvoiceDiscountAmount@1011 : Decimal;
      CustomerNotProvidedErr@1012 : TextConst '@@@={Locked};DAN=A customerNumber or a customerID must be provided.;ENU=A customerNumber or a customerID must be provided.';
      InvoiceDiscountPct@1030 : Decimal;
      WorkDescription@1014 : Text;
      NoteForCustomerSet@1015 : Boolean;
      CannotChangeWorkDescriptionOnPostedInvoiceErr@1016 : TextConst 'DAN=Bem‘rkningen til debitoren kan ikke ‘ndres p† den sendte faktura.;ENU=The Note for customer cannot be changed on the sent invoice.';
      DocumentDateSet@1018 : Boolean;
      DocumentDateVar@1019 : Date;
      DueDateSet@1020 : Boolean;
      DueDateVar@1021 : Date;
      PostedInvoiceActionErr@1041 : TextConst 'DAN=Handlingen kan kun anvendes til en bogf›rt faktura.;ENU=The action can be applied to a posted invoice only.';
      DraftInvoiceActionErr@1042 : TextConst 'DAN=Handlingen kan kun anvendes til en kladdefaktura.;ENU=The action can be applied to a draft invoice only.';
      CannotFindInvoiceErr@1043 : TextConst 'DAN=Fakturaen blev ikke fundet.;ENU=The invoice cannot be found.';
      CancelingInvoiceFailedCreditMemoCreatedAndPostedErr@1046 : TextConst '@@@=%1 - Error Message;DAN=Fakturaen kunne ikke annulleres p† grund af f›lgende fejl: \\%1\\Der er bogf›rt en kreditnota.;ENU=Canceling the invoice failed because of the following error: \\%1\\A credit memo is posted.';
      CancelingInvoiceFailedCreditMemoCreatedButNotPostedErr@1047 : TextConst '@@@=%1 - Error Message;DAN=Fakturaen kunne ikke annulleres p† grund af f›lgende fejl: \\%1\\Der er oprettet, men ikke bogf›rt en kreditnota.;ENU=Canceling the invoice failed because of the following error: \\%1\\A credit memo is created but not posted.';
      CancelingInvoiceFailedNothingCreatedErr@1048 : TextConst '@@@=%1 - Error Message;DAN=Fakturaen kunne ikke annulleres p† grund af f›lgende fejl: \\%1.;ENU=Canceling the invoice failed because of the following error: \\%1.';
      EmptyEmailErr@1049 : TextConst 'DAN=Modtagers mailadresse er tom. Angiv mailadressen for debitoren eller for fakturaen i mailvisningen.;ENU=The send-to email is empty. Specify email either for the customer or for the invoice in email preview.';
      AlreadyCanceledErr@1031 : TextConst 'DAN=Fakturaen kan ikke annulleres, fordi den allerede er blevet annulleret.;ENU=The invoice cannot be canceled because it has already been canceled.';
      MailNotConfiguredErr@1032 : TextConst 'DAN=Du skal konfigurere en mailkonto for at kunne sende mails.;ENU=An email account must be configured to send emails.';
      InvoiceDiscountPctMustBePositiveErr@1028 : TextConst 'DAN=Fakturaens rabatprocent skal v‘re positiv.;ENU=Invoice discount percentage must be positive.';
      InvoiceDiscountPctMustBeBelowHundredErr@1029 : TextConst 'DAN=Fakturaens rabatprocent skal v‘re under 100.;ENU=Invoice discount percentage must be below 100.';
      InvoiceDiscountAmtMustBePositiveErr@1033 : TextConst 'DAN=Fakturaens rabat skal v‘re positiv.;ENU=Invoice discount must be positive.';
      RemainingAmountVar@1034 : Decimal;
      CustomerIdSet@1037 : Boolean;
      LastEmailSentTime@1036 : DateTime;
      CannotModifyPostedInvioceErr@1038 : TextConst 'DAN=Fakturaen er blevet bogf›rt og kan ikke l‘ngere ‘ndres. Du kan kun ‘ndre de vedh‘ftede filer.;ENU=The invoice has been posted and can no longer be modified. You are only allowed to change the attachments.';

    LOCAL PROCEDURE SetAttachmentsJSON@37();
    VAR
      NativeAttachments@1004 : Codeunit 2820;
    BEGIN
      AttachmentsJSON := NativeAttachments.GenerateAttachmentsJSON(Id);
      PreviousAttachmentsJSON := AttachmentsJSON;
    END;

    LOCAL PROCEDURE SetCalculatedFields@6();
    VAR
      TempSalesInvoiceLineAggregate@1002 : TEMPORARY Record 5476;
      DummyNativeAPITaxSetup@1005 : Record 2850;
      GraphMgtSalesInvoice@1000 : Codeunit 5475;
      NativeEDMTypes@1001 : Codeunit 2801;
      NativeCoupons@1003 : Codeunit 2815;
    BEGIN
      DocumentDateVar := "Document Date";
      DueDateVar := "Due Date";
      BillingPostalAddressJSONText := GraphMgtSalesInvoice.BillToCustomerAddressToJSON(Rec);
      IF Customer.GET("Sell-to Customer No.") THEN
        CustomerEmail := Customer."E-Mail"
      ELSE
        CustomerEmail := '';

      LoadLines(TempSalesInvoiceLineAggregate,Rec);
      SalesInvoiceLinesJSON :=
        NativeEDMTypes.WriteSalesLinesJSON(TempSalesInvoiceLineAggregate);
      PreviousSalesInvoiceLinesJSON := SalesInvoiceLinesJSON;

      CouponsJSON := NativeCoupons.WriteCouponsJSON(DummySalesLine."Document Type"::Invoice,"No.",Posted);
      PreviousCouponsJSON := CouponsJSON;

      SetAttachmentsJSON;
      TaxAreaDisplayName := DummyNativeAPITaxSetup.GetTaxAreaDisplayName("Tax Area ID");
      GetNoteForCustomer;
      GetRemainingAmount;
      GetLastEmailSentTime;
    END;

    LOCAL PROCEDURE ClearCalculatedFields@10();
    BEGIN
      CLEAR(BillingPostalAddressJSONText);
      CLEAR(SalesInvoiceLinesJSON);
      CLEAR(PreviousSalesInvoiceLinesJSON);
      CLEAR(SalesLinesSet);
      CLEAR(CouponsJSON);
      CLEAR(PreviousCouponsJSON);
      CLEAR(CouponsSet);
      CLEAR(AttachmentsJSON);
      CLEAR(PreviousAttachmentsJSON);
      CLEAR(IsAttachmentsSet);
      CLEAR(WorkDescription);
      CLEAR(DueDateSet);
      "Due Date" := 010199D;
      CLEAR(DocumentDateSet);
      CLEAR(DocumentDateVar);
      CLEAR(RemainingAmountVar);
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
      TempFieldBuffer."Table ID" := DATABASE::"Sales Invoice Entity Aggregate";
      TempFieldBuffer."Field ID" := FieldNo;
      TempFieldBuffer.INSERT;
    END;

    LOCAL PROCEDURE ProcessBillingPostalAddress@5();
    VAR
      GraphMgtSalesInvoice@1000 : Codeunit 5475;
    BEGIN
      IF NOT BillingPostalAddressSet THEN
        EXIT;

      GraphMgtSalesInvoice.ProcessComplexTypes(Rec,BillingPostalAddressJSONText);

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

    LOCAL PROCEDURE LoadLines@1(VAR TempSalesInvoiceLineAggregate@1000 : TEMPORARY Record 5476;VAR SalesInvoiceEntityAggregate@1001 : Record 5475);
    VAR
      SalesInvoiceAggregator@1002 : Codeunit 5477;
    BEGIN
      TempSalesInvoiceLineAggregate.SETRANGE("Document Id",SalesInvoiceEntityAggregate.Id);
      SalesInvoiceAggregator.LoadLines(TempSalesInvoiceLineAggregate,TempSalesInvoiceLineAggregate.GETFILTER("Document Id"));
    END;

    LOCAL PROCEDURE UpdateLines@4();
    VAR
      TempSalesInvoiceLineAggregate@1002 : TEMPORARY Record 5476;
      SalesInvoiceAggregator@1000 : Codeunit 5477;
      NativeEDMTypes@1001 : Codeunit 2801;
    BEGIN
      IF NOT SalesLinesSet THEN
        EXIT;

      NativeEDMTypes.ParseSalesLinesJSON(
        DummySalesLine."Document Type"::Invoice,SalesInvoiceLinesJSON,TempSalesInvoiceLineAggregate,Id);
      TempSalesInvoiceLineAggregate.SETRANGE("Document Id",Id);
      SalesInvoiceAggregator.PropagateMultipleLinesUpdate(TempSalesInvoiceLineAggregate);
      FIND;
    END;

    LOCAL PROCEDURE UpdateDiscount@13();
    VAR
      SalesHeader@1002 : Record 36;
      SalesLine@1004 : Record 37;
      TotalSalesLine@1006 : Record 37;
      CustInvDisc@1008 : Record 19;
      SalesInvoiceAggregator@1000 : Codeunit 5477;
      SalesCalcDiscountByType@1001 : Codeunit 56;
      O365Discounts@1003 : Codeunit 2155;
      DocumentTotals@1005 : Codeunit 57;
      VatAmount@1007 : Decimal;
    BEGIN
      IF Posted THEN
        EXIT;

      IF SalesLinesSet AND (NOT DiscountAmountSet) THEN BEGIN
        SalesInvoiceAggregator.RedistributeInvoiceDiscounts(Rec);
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

      SalesHeader.GET("Document Type"::Invoice,"No.");
      IF InvoiceDiscountPct <> 0 THEN BEGIN
        O365Discounts.ApplyInvoiceDiscountPercentage(SalesHeader,InvoiceDiscountPct);
        SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.",SalesHeader."No.");
        IF SalesLine.FINDFIRST THEN BEGIN
          SalesInvoiceAggregator.RedistributeInvoiceDiscounts(Rec);
          DocumentTotals.CalculateSalesTotals(TotalSalesLine,VatAmount,SalesLine);
          "Invoice Discount Amount" := TotalSalesLine."Inv. Discount Amount";
          RegisterFieldSet(FIELDNO("Invoice Discount Amount"));
        END;
      END ELSE BEGIN
        CustInvDisc.SETRANGE(Code,"No.");
        CustInvDisc.DELETEALL;
        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
        SalesInvoiceAggregator.RedistributeInvoiceDiscounts(Rec);
      END;
    END;

    LOCAL PROCEDURE UpdateCoupons@14();
    VAR
      NativeEDMTypes@1000 : Codeunit 2801;
    BEGIN
      IF NOT CouponsSet THEN
        EXIT;

      NativeEDMTypes.ParseCouponsJSON("Contact Graph Id",DummySalesLine."Document Type"::Invoice,"No.",CouponsJSON);
    END;

    LOCAL PROCEDURE UpdateAttachments@7();
    VAR
      NativeAttachments@1001 : Codeunit 2820;
    BEGIN
      IF NOT IsAttachmentsSet THEN
        EXIT;

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

    LOCAL PROCEDURE CheckStatus@28();
    BEGIN
      IF Posted THEN
        ERROR(CannotModifyPostedInvioceErr);
    END;

    LOCAL PROCEDURE GetNoteForCustomer@9();
    VAR
      SalesInvoiceHeader@1000 : Record 112;
      SalesHeader@1001 : Record 36;
      WorkDescriptionInStream@1002 : InStream;
    BEGIN
      CLEAR(WorkDescription);
      IF Posted THEN BEGIN
        SalesInvoiceHeader.SETAUTOCALCFIELDS("Work Description");
        SalesInvoiceHeader.GET("No.");
        SalesInvoiceHeader."Work Description".CREATEINSTREAM(WorkDescriptionInStream);
      END ELSE BEGIN
        SalesHeader.SETAUTOCALCFIELDS("Work Description");
        SalesHeader.GET(SalesHeader."Document Type"::Invoice,"No.");
        SalesHeader."Work Description".CREATEINSTREAM(WorkDescriptionInStream);
      END;

      WorkDescriptionInStream.READ(WorkDescription);
    END;

    LOCAL PROCEDURE GetLastEmailSentTime@23();
    VAR
      SalesInvoiceHeader@1000 : Record 112;
      SalesHeader@1001 : Record 36;
    BEGIN
      CLEAR(LastEmailSentTime);
      IF Posted THEN BEGIN
        SalesInvoiceHeader.SETAUTOCALCFIELDS("Last Email Sent Time");
        SalesInvoiceHeader.GET("No.");
        LastEmailSentTime := SalesInvoiceHeader."Last Email Sent Time";
      END ELSE BEGIN
        SalesHeader.SETAUTOCALCFIELDS("Last Email Sent Time");
        SalesHeader.GET(SalesHeader."Document Type"::Invoice,"No.");
        LastEmailSentTime := SalesHeader."Last Email Sent Time";
      END;
    END;

    LOCAL PROCEDURE GetRemainingAmount@16();
    VAR
      SalesInvoiceHeader@1000 : Record 112;
    BEGIN
      RemainingAmountVar := "Amount Including VAT";
      IF Posted THEN
        IF SalesInvoiceHeader.GET("No.") THEN BEGIN
          RemainingAmountVar := SalesInvoiceHeader.GetRemainingAmount;
          IF IsInvoiceCanceled THEN
            RemainingAmountVar := 0;
        END;
    END;

    LOCAL PROCEDURE SetNoteForCustomer@22();
    VAR
      SalesHeader@1000 : Record 36;
      WorkDescriptionOutStream@1001 : OutStream;
    BEGIN
      IF NOT NoteForCustomerSet THEN
        EXIT;

      IF Posted THEN
        ERROR(CannotChangeWorkDescriptionOnPostedInvoiceErr);

      SalesHeader.GET(SalesHeader."Document Type"::Invoice,"No.");
      SalesHeader."Work Description".CREATEOUTSTREAM(WorkDescriptionOutStream);
      WorkDescriptionOutStream.WRITE(WorkDescription);
      SalesHeader.MODIFY(TRUE);
      FIND;
    END;

    LOCAL PROCEDURE SetDates@8();
    VAR
      SalesInvoiceAggregator@1000 : Codeunit 5477;
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

      SalesInvoiceAggregator.PropagateOnModify(Rec,TempFieldBuffer);
      FIND;
    END;

    LOCAL PROCEDURE GetPostedInvoice@35(VAR SalesInvoiceHeader@1000 : Record 112);
    BEGIN
      IF NOT Posted THEN
        ERROR(PostedInvoiceActionErr);

      SalesInvoiceHeader.SETRANGE(Id,Id);
      IF NOT SalesInvoiceHeader.FINDFIRST THEN
        ERROR(CannotFindInvoiceErr);
    END;

    LOCAL PROCEDURE GetDraftInvoice@36(VAR SalesHeader@1000 : Record 36);
    BEGIN
      IF Posted THEN
        ERROR(DraftInvoiceActionErr);

      SalesHeader.SETRANGE(Id,Id);
      IF NOT SalesHeader.FINDFIRST THEN
        ERROR(CannotFindInvoiceErr);
    END;

    LOCAL PROCEDURE CheckSmtpMailSetup@30();
    VAR
      O365SetupEmail@1001 : Codeunit 2135;
    BEGIN
      IF NOT O365SetupEmail.SMTPEmailIsSetUp THEN
        ERROR(MailNotConfiguredErr);
    END;

    LOCAL PROCEDURE CheckSendToEmailAddress@21(DocumentNo@1000 : Code[20]);
    BEGIN
      IF GetSendToEmailAddress(DocumentNo) = '' THEN
        ERROR(EmptyEmailErr);
    END;

    LOCAL PROCEDURE GetSendToEmailAddress@26(DocumentNo@1001 : Code[20]) : Text[250];
    VAR
      EmailAddress@1000 : Text[250];
    BEGIN
      EmailAddress := GetDocumentEmailAddress(DocumentNo);
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

    LOCAL PROCEDURE GetDocumentEmailAddress@58(DocumentNo@1000 : Code[20]) : Text[250];
    VAR
      EmailParameter@1002 : Record 9510;
    BEGIN
      IF NOT EmailParameter.GET(DocumentNo,"Document Type",EmailParameter."Parameter Type"::Address) THEN
        EXIT('');
      EXIT(EmailParameter."Parameter Value");
    END;

    LOCAL PROCEDURE CheckInvoiceCanBeCanceled@32(VAR SalesInvoiceHeader@1000 : Record 112);
    VAR
      CorrectPostedSalesInvoice@1001 : Codeunit 1303;
    BEGIN
      IF IsInvoiceCanceled THEN
        ERROR(AlreadyCanceledErr);
      CorrectPostedSalesInvoice.TestCorrectInvoiceIsAllowed(SalesInvoiceHeader,TRUE);
    END;

    LOCAL PROCEDURE IsInvoiceCanceled@25() : Boolean;
    BEGIN
      EXIT(Status = Status::Canceled);
    END;

    LOCAL PROCEDURE PostInvoice@20(VAR SalesHeader@1001 : Record 36;VAR SalesInvoiceHeader@1000 : Record 112);
    VAR
      DummyO365SalesDocument@1003 : Record 2103;
      LinesInstructionMgt@1005 : Codeunit 1320;
      O365SendResendInvoice@1002 : Codeunit 2104;
      PreAssignedNo@1006 : Code[20];
    BEGIN
      O365SendResendInvoice.CheckDocumentIfNoItemsExists(SalesHeader,FALSE,DummyO365SalesDocument);
      LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(SalesHeader);
      PreAssignedNo := SalesHeader."No.";
      SalesHeader.SendToPosting(CODEUNIT::"Sales-Post");
      SalesInvoiceHeader.SETCURRENTKEY("Pre-Assigned No.");
      SalesInvoiceHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
      SalesInvoiceHeader.FINDFIRST;
    END;

    LOCAL PROCEDURE SendPostedInvoice@34(VAR SalesInvoiceHeader@1000 : Record 112);
    VAR
      GraphIntBusinessProfile@1001 : Codeunit 5442;
    BEGIN
      CheckSmtpMailSetup;
      CheckSendToEmailAddress(SalesInvoiceHeader."No.");
      GraphIntBusinessProfile.SyncFromGraphSynchronously;
      SalesInvoiceHeader.SETRECFILTER;
      SalesInvoiceHeader.EmailRecords(FALSE);
    END;

    LOCAL PROCEDURE SendDraftInvoice@15(VAR SalesHeader@1000 : Record 36);
    VAR
      DummyO365SalesDocument@1003 : Record 2103;
      LinesInstructionMgt@1002 : Codeunit 1320;
      O365SendResendInvoice@1001 : Codeunit 2104;
      GraphIntBusinessProfile@1004 : Codeunit 5442;
    BEGIN
      O365SendResendInvoice.CheckDocumentIfNoItemsExists(SalesHeader,FALSE,DummyO365SalesDocument);
      LinesInstructionMgt.SalesCheckAllLinesHaveQuantityAssigned(SalesHeader);
      CheckSmtpMailSetup;
      CheckSendToEmailAddress(SalesHeader."No.");

      GraphIntBusinessProfile.SyncFromGraphSynchronously;
      SalesHeader.SETRECFILTER;
      SalesHeader.EmailRecords(FALSE);
    END;

    LOCAL PROCEDURE SendCanceledInvoice@41(VAR SalesInvoiceHeader@1000 : Record 112);
    VAR
      JobQueueEntry@1001 : Record 472;
      GraphIntBusinessProfile@1002 : Codeunit 5442;
    BEGIN
      CheckSmtpMailSetup;
      CheckSendToEmailAddress(SalesInvoiceHeader."No.");
      GraphIntBusinessProfile.SyncFromGraphSynchronously;

      JobQueueEntry.INIT;
      JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
      JobQueueEntry."Object ID to Run" := CODEUNIT::"O365 Sales Cancel Invoice";
      JobQueueEntry."Maximum No. of Attempts to Run" := 3;
      JobQueueEntry."Record ID to Process" := SalesInvoiceHeader.RECORDID;
      CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry);
    END;

    LOCAL PROCEDURE CancelInvoice@39(VAR SalesInvoiceHeader@1000 : Record 112);
    VAR
      SalesCrMemoHeader@1007 : Record 114;
      SalesHeader@1001 : Record 36;
    BEGIN
      GetPostedInvoice(SalesInvoiceHeader);
      CheckInvoiceCanBeCanceled(SalesInvoiceHeader);
      IF NOT CODEUNIT.RUN(CODEUNIT::"Correct Posted Sales Invoice",SalesInvoiceHeader) THEN BEGIN
        SalesCrMemoHeader.SETRANGE("Applies-to Doc. No.",SalesInvoiceHeader."No.");
        IF SalesCrMemoHeader.FINDFIRST THEN
          ERROR(CancelingInvoiceFailedCreditMemoCreatedAndPostedErr,GETLASTERRORTEXT);
        SalesHeader.SETRANGE("Applies-to Doc. No.",SalesInvoiceHeader."No.");
        IF SalesHeader.FINDFIRST THEN
          ERROR(CancelingInvoiceFailedCreditMemoCreatedButNotPostedErr,GETLASTERRORTEXT);
        ERROR(CancelingInvoiceFailedNothingCreatedErr,GETLASTERRORTEXT);
      END;
    END;

    LOCAL PROCEDURE SetActionResponse@47(VAR ActionContext@1004 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext";InvoiceId@1000 : GUID);
    VAR
      ODataActionManagement@1003 : Codeunit 6711;
    BEGIN
      ODataActionManagement.AddKey(FIELDNO(Id),InvoiceId);
      ODataActionManagement.SetDeleteResponseLocation(ActionContext,PAGE::"Native - Sales Inv. Entity");
    END;

    [ServiceEnabled]
    [External]
    PROCEDURE Post@18(VAR ActionContext@1000 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext");
    VAR
      SalesHeader@1001 : Record 36;
      SalesInvoiceHeader@1002 : Record 112;
    BEGIN
      GetDraftInvoice(SalesHeader);
      PostInvoice(SalesHeader,SalesInvoiceHeader);
      SetActionResponse(ActionContext,SalesInvoiceHeader.Id);
    END;

    [ServiceEnabled]
    [External]
    PROCEDURE PostAndSend@33(VAR ActionContext@1000 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext");
    VAR
      SalesHeader@1005 : Record 36;
      SalesInvoiceHeader@1002 : Record 112;
    BEGIN
      GetDraftInvoice(SalesHeader);
      PostInvoice(SalesHeader,SalesInvoiceHeader);
      COMMIT;
      SendPostedInvoice(SalesInvoiceHeader);
      SetActionResponse(ActionContext,SalesInvoiceHeader.Id);
    END;

    [ServiceEnabled]
    [External]
    PROCEDURE Send@17(VAR ActionContext@1000 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext");
    VAR
      SalesHeader@1005 : Record 36;
      SalesInvoiceHeader@1002 : Record 112;
    BEGIN
      IF Posted THEN BEGIN
        GetPostedInvoice(SalesInvoiceHeader);
        IF IsInvoiceCanceled THEN
          SendCanceledInvoice(SalesInvoiceHeader)
        ELSE
          SendPostedInvoice(SalesInvoiceHeader);
        SetActionResponse(ActionContext,SalesInvoiceHeader.Id);
        EXIT;
      END;
      GetDraftInvoice(SalesHeader);
      SendDraftInvoice(SalesHeader);
      SetActionResponse(ActionContext,SalesHeader.Id);
    END;

    [ServiceEnabled]
    [External]
    PROCEDURE Cancel@19(VAR ActionContext@1000 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext");
    VAR
      SalesInvoiceHeader@1002 : Record 112;
    BEGIN
      GetPostedInvoice(SalesInvoiceHeader);
      CancelInvoice(SalesInvoiceHeader);
      SetActionResponse(ActionContext,SalesInvoiceHeader.Id);
    END;

    [ServiceEnabled]
    [External]
    PROCEDURE CancelAndSend@51(VAR ActionContext@1000 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext");
    VAR
      SalesInvoiceHeader@1002 : Record 112;
    BEGIN
      GetPostedInvoice(SalesInvoiceHeader);
      CancelInvoice(SalesInvoiceHeader);
      SendCanceledInvoice(SalesInvoiceHeader);
      SetActionResponse(ActionContext,SalesInvoiceHeader.Id);
    END;

    BEGIN
    END.
  }
}

