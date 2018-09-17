OBJECT Page 2107 O365 Sales Customer Card
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitor;
               ENU=Customer];
    SourceTable=Table18;
    DataCaptionExpr=Name;
    PageType=Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Detaljer;
                                ENU=New,Process,Report,Details];
    OnInit=VAR
             O365SalesInitialSetup@1000 : Record 2110;
             PostcodeServiceManager@1001 : Codeunit 9090;
           BEGIN
             IF O365SalesInitialSetup.GET THEN
               IsUsingVAT := O365SalesInitialSetup.IsUsingVAT;
             IsAddressLookupAvailable := PostcodeServiceManager.IsConfigured;
           END;

    OnOpenPage=BEGIN
                 CurrPage.EDITABLE := Blocked = Blocked::" ";
                 SETRANGE("Date Filter",0D,WORKDATE);
                 DeviceContactProviderIsAvailable := DeviceContactProvider.IsAvailable;
               END;

    OnNewRecord=BEGIN
                  OnNewRec;
                END;

    OnInsertRecord=BEGIN
                     IF Name = '' THEN
                       CustomerCardState := CustomerCardState::Prompt
                     ELSE
                       CustomerCardState := CustomerCardState::Keep;

                     EXIT(TRUE);
                   END;

    OnModifyRecord=BEGIN
                     IF Name = '' THEN
                       CustomerCardState := CustomerCardState::Prompt
                     ELSE
                       CustomerCardState := CustomerCardState::Keep;

                     EXIT(TRUE);
                   END;

    OnDeleteRecord=BEGIN
                     O365SalesManagement.BlockCustomerAndDeleteContact(Rec);
                   END;

    OnQueryClosePage=BEGIN
                       EXIT(CanExitAfterProcessingCustomer);
                     END;

    OnAfterGetCurrRecord=VAR
                           TempStandardAddress@1000 : TEMPORARY Record 730;
                           TaxArea@1001 : Record 318;
                         BEGIN
                           CreateCustomerFromTemplate;
                           CurrPageEditable := CurrPage.EDITABLE;

                           OverdueAmount := CalcOverdueBalance;

                           TempStandardAddress.CopyFromCustomer(Rec);
                           FullAddress := TempStandardAddress.ToString;

                           IF TaxArea.GET("Tax Area Code") THEN
                             TaxAreaDescription := TaxArea.GetDescriptionInCurrentLanguage;

                           UpdateInvoicesLbl;
                           UpdateEstimatesLbl;
                         END;

    ActionList=ACTIONS
    {
      { 11      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;Action    ;
                      Name=NewSalesInvoice;
                      CaptionML=[DAN=Ny faktura;
                                 ENU=New Invoice];
                      ToolTipML=[DAN=Opret en ny faktura til debitoren.;
                                 ENU=Create a new invoice for the customer.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NewSalesInvoice;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 O365SalesManagement.OpenNewInvoiceForCustomer(Rec);
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=NewSalesQuote;
                      CaptionML=[DAN=Nyt estimat;
                                 ENU=New Estimate];
                      ToolTipML=[DAN=Opret et estimat for kunden.;
                                 ENU=Create an estimate for the customer.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NewSalesQuote;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 O365SalesManagement.OpenNewQuoteForCustomer(Rec);
                               END;
                                }
      { 16      ;1   ;Action    ;
                      Name=Invoice Discounts;
                      CaptionML=[DAN=Fakturarabatter;
                                 ENU=Invoice Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter, som kan tilf›jes fakturaer til debitor. Der gives automatisk en fakturarabat til debitor, n†r det samlede fakturabel›b overstiger et vist bel›b.;
                                 ENU=Set up different discounts that are applied to invoices for the customer. An invoice discount is automatically granted to the customer when the total on a sales invoice exceeds a certain amount.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      Visible=FALSE;
                      Image=Discount;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 O365CustInvoiceDiscount@1000 : Page 2156;
                               BEGIN
                                 O365CustInvoiceDiscount.FillO365CustInvDiscount("No.");
                                 O365CustInvoiceDiscount.RUN;
                               END;
                                }
      { 20      ;1   ;Action    ;
                      Name=ImportDeviceContact;
                      CaptionML=[DAN=Import‚r kontakt;
                                 ENU=Import Contact];
                      ToolTipML=[DAN="Import‚r en kontaktperson direkte fra din iOS- eller Android-enhed, og f† de nye debitorfelter udfyldt automatisk. ";
                                 ENU="Import a contact directly from your iOS or Android device and have the new customer fields automatically populated. "];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      Visible=CurrPageEditable AND DeviceContactProviderIsAvailable;
                      PromotedIsBig=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IF DeviceContactProviderIsAvailable THEN BEGIN
                                   IF ISNULL(DeviceContactProvider) THEN
                                     DeviceContactProvider := DeviceContactProvider.Create;
                                   DeviceContactProvider.RequestDeviceContactAsync;
                                 END
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens navn.;
                           ENU=Specifies the customer's name.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Name;
                ShowCaption=No }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kontakten er en virksomhed eller en person.;
                           ENU=Specifies if the contact is a company or a person.];
                OptionCaptionML=[DAN=Virksomhedskontakt,Person;
                                 ENU=Company contact,Person];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Contact Type";
                OnValidate=BEGIN
                             VALIDATE("Prices Including VAT","Contact Type" = "Contact Type"::Person);
                           END;

                ShowCaption=No }

    { 4   ;2   ;Field     ;
                ExtendedDatatype=E-Mail;
                CaptionML=[DAN=Mailadresse;
                           ENU=Email Address];
                ToolTipML=[DAN=Angiver debitorens mailadresse.;
                           ENU=Specifies the customer's email address.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="E-Mail";
                Importance=Promoted;
                OnValidate=VAR
                             MailManagement@1000 : Codeunit 9520;
                           BEGIN
                             IF "E-Mail" <> '' THEN
                               MailManagement.CheckValidEmailAddress("E-Mail");
                           END;

                ShowCaption=No }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer's telephone number.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Phone No.";
                ShowCaption=No }

    { 17  ;2   ;Group     ;
                Visible="Balance (LCY)" <> 0;
                GroupType=Group }

    { 5   ;3   ;Field     ;
                Lookup=No;
                DrillDown=No;
                CaptionML=[DAN=Udest†ende;
                           ENU=Outstanding];
                ToolTipML=[DAN=Angiver debitorsaldo.;
                           ENU=Specifies the customer's balance.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Balance (LCY)";
                AutoFormatType=10;
                AutoFormatExpr='1';
                Importance=Additional }

    { 18  ;2   ;Group     ;
                Visible=OverdueAmount <> 0;
                GroupType=Group }

    { 6   ;3   ;Field     ;
                Lookup=No;
                DrillDown=No;
                CaptionML=[DAN=Forfald;
                           ENU=Overdue];
                ToolTipML=[DAN=Angiver betalinger fra debitoren, der er forfaldne pr. dags dato.;
                           ENU=Specifies payments from the customer that are overdue per today's date.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=OverdueAmount;
                AutoFormatType=10;
                AutoFormatExpr='1';
                Importance=Additional;
                Editable=FALSE;
                Style=Unfavorable;
                StyleExpr=OverdueAmount > 0 }

    { 8   ;2   ;Field     ;
                Lookup=No;
                DrillDown=No;
                CaptionML=[DAN=Samlet salg (ekskl. moms);
                           ENU=Total Sales (Excl. VAT)];
                ToolTipML=[DAN=Angiver det samlede nettobel›b i RV for salg til debitoren.;
                           ENU=Specifies the total net amount of sales to the customer in LCY.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Sales (LCY)";
                AutoFormatType=10;
                AutoFormatExpr='1';
                Importance=Additional }

    { 22  ;1   ;Group     ;
                CaptionML=[DAN=Detaljer;
                           ENU=Details];
                GroupType=Group }

    { 26  ;2   ;Group     ;
                GroupType=Group }

    { 13  ;3   ;Group     ;
                Visible=("Contact Type" = "Contact Type"::Company) AND IsUsingVAT;
                GroupType=Group }

    { 21  ;4   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="VAT Registration No." }

    { 23  ;3   ;Group     ;
                Visible=("Contact Type" = "Contact Type"::Person) AND IsAddressLookupAvailable AND CurrPageEditable;
                GroupType=Group }

    { 24  ;4   ;Field     ;
                Name=AddressLookup;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=AddressLookupLbl;
                Editable=FALSE;
                ShowCaption=No }

    { 27  ;3   ;Field     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=FullAddress;
                Editable=CurrPageEditable;
                OnAssistEdit=VAR
                               TempStandardAddress@1000 : TEMPORARY Record 730;
                             BEGIN
                               CurrPage.SAVERECORD;
                               COMMIT;
                               TempStandardAddress.CopyFromCustomer(Rec);
                               IF PAGE.RUNMODAL(PAGE::"O365 Address",TempStandardAddress) = ACTION::LookupOK THEN BEGIN
                                 GET("No.");
                                 FullAddress := TempStandardAddress.ToString;
                               END;
                             END;

                QuickEntry=FALSE }

    { 12  ;1   ;Group     ;
                Name=Tax Information;
                CaptionML=[DAN=Skat;
                           ENU=Tax];
                Visible=NOT IsUsingVAT;
                GroupType=Group }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om salgsfakturaen er med moms.;
                           ENU=Specifies if the sales invoice contains sales tax.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Tax Liable" }

    { 19  ;2   ;Field     ;
                Name=TaxAreaDescription;
                CaptionML=[DAN=Skattesats;
                           ENU=Tax Rate];
                ToolTipML=[DAN=Angiver debitorens skatteomr†de.;
                           ENU=Specifies the customer's tax area.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                NotBlank=Yes;
                SourceExpr=TaxAreaDescription;
                Editable=CurrPageEditable;
                OnLookup=VAR
                           TaxArea@1001 : Record 318;
                         BEGIN
                           IF PAGE.RUNMODAL(PAGE::"O365 Tax Area List",TaxArea) = ACTION::LookupOK THEN BEGIN
                             VALIDATE("Tax Area Code",TaxArea.Code);
                             TaxAreaDescription := TaxArea.GetDescriptionInCurrentLanguage;
                           END;
                         END;

                QuickEntry=FALSE }

    { 15  ;1   ;Group     ;
                Name=Documents;
                Visible=NOT CurrPageEditable;
                GroupType=Group }

    { 30  ;2   ;Field     ;
                Name=InvoicesForCustomer;
                DrillDown=Yes;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=InvoicesLabelText;
                Editable=FALSE;
                OnDrillDown=VAR
                              O365SalesDocument@1000 : Record 2103;
                            BEGIN
                              O365SalesDocument.SETRANGE("Document Type",O365SalesDocument."Document Type"::Invoice);
                              O365SalesDocument.SETRANGE("Sell-to Customer No.","No.");
                              PAGE.RUN(PAGE::"O365 Customer Sales Documents",O365SalesDocument);
                            END;

                ShowCaption=No }

    { 31  ;2   ;Field     ;
                Name=EstimatesForCustomer;
                DrillDown=Yes;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=EstimatesLabelText;
                Editable=FALSE;
                OnDrillDown=VAR
                              O365SalesDocument@1000 : Record 2103;
                            BEGIN
                              O365SalesDocument.SETRANGE("Document Type",O365SalesDocument."Document Type"::Quote);
                              O365SalesDocument.SETRANGE("Sell-to Customer No.","No.");
                              O365SalesDocument.SETRANGE(Posted,FALSE);
                              PAGE.RUN(PAGE::"O365 Customer Sales Documents",O365SalesDocument);
                            END;

                ShowCaption=No }

  }
  CODE
  {
    VAR
      CustContUpdate@1006 : Codeunit 5056;
      O365SalesManagement@1013 : Codeunit 2107;
      ProcessNewCustomerOptionQst@1001 : TextConst 'DAN=Bliv ved at redigere,Kass‚r;ENU=Keep editing,Discard';
      ProcessNewCustomerInstructionTxt@1003 : TextConst 'DAN=Navn mangler. Vil du bevare debitoren?;ENU=Name is missing. Keep the customer?';
      AddressLookupLbl@1009 : TextConst 'DAN=Find debitoradresse;ENU=Lookup customer address';
      InvoicesForCustomerLbl@1015 : TextConst '@@@="%1= positive or zero integer: the number of invoices for the customer";DAN=Fakturaer (%1);ENU=Invoices (%1)';
      EstimatesForCustomerLbl@1016 : TextConst '@@@="%1= positive or zero integer: the number of estimates for the customer";DAN=Estimater (%1);ENU=Estimates (%1)';
      DeviceContactProvider@1014 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.DeviceContactProvider" WITHEVENTS RUNONCLIENT;
      CustomerCardState@1017 : 'Keep,Delete,Prompt';
      DeviceContactProviderIsAvailable@1018 : Boolean;
      NewMode@1012 : Boolean;
      IsAddressLookupAvailable@1011 : Boolean;
      CurrPageEditable@1010 : Boolean;
      IsUsingVAT@1008 : Boolean;
      OverdueAmount@1007 : Decimal;
      FullAddress@1005 : Text;
      TaxAreaDescription@1004 : Text[50];
      InvoicesLabelText@1002 : Text;
      EstimatesLabelText@1000 : Text;

    LOCAL PROCEDURE CanExitAfterProcessingCustomer@2() : Boolean;
    VAR
      Response@1001 : ',KeepEditing,Discard';
    BEGIN
      IF "No." = '' THEN
        EXIT(TRUE);

      IF CustomerCardState = CustomerCardState::Delete THEN
        EXIT(DeleteCustomerRelatedData);

      IF GUIALLOWED AND (CustomerCardState = CustomerCardState::Prompt) AND (Blocked = Blocked::" ") THEN
        CASE STRMENU(ProcessNewCustomerOptionQst,Response::KeepEditing,ProcessNewCustomerInstructionTxt) OF
          Response::Discard:
            EXIT(DeleteCustomerRelatedData);
          ELSE
            EXIT(FALSE);
        END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE DeleteCustomerRelatedData@4() : Boolean;
    BEGIN
      CustContUpdate.DeleteCustomerContacts(Rec);

      // workaround for bug: delete for new empty record returns false
      IF DELETE(TRUE) THEN;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE OnNewRec@1();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      IF GUIALLOWED AND DocumentNoVisibility.CustomerNoSeriesIsDefault THEN
        NewMode := TRUE;
    END;

    LOCAL PROCEDURE CreateCustomerFromTemplate@3();
    VAR
      MiniCustomerTemplate@1001 : Record 1300;
      Customer@1000 : Record 18;
    BEGIN
      IF NewMode THEN BEGIN
        IF MiniCustomerTemplate.NewCustomerFromTemplate(Customer) THEN BEGIN
          COPY(Customer);
          CurrPage.UPDATE;
        END;
        CustomerCardState := CustomerCardState::Delete;
        NewMode := FALSE;
      END;
    END;

    LOCAL PROCEDURE UpdateInvoicesLbl@6();
    VAR
      SalesInvoiceHeader@1000 : Record 112;
      SalesHeader@1001 : Record 36;
      NumberOfInvoices@1002 : Integer;
    BEGIN
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Invoice);
      NumberOfInvoices := SalesHeader.COUNT;

      SalesInvoiceHeader.SETRANGE("Sell-to Customer No.","No.");
      NumberOfInvoices := NumberOfInvoices + SalesInvoiceHeader.COUNT;

      InvoicesLabelText := STRSUBSTNO(InvoicesForCustomerLbl,NumberOfInvoices);
    END;

    LOCAL PROCEDURE UpdateEstimatesLbl@7();
    VAR
      SalesHeader@1001 : Record 36;
      NumberOfEstimates@1000 : Integer;
    BEGIN
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Quote);
      NumberOfEstimates := SalesHeader.COUNT;

      EstimatesLabelText := STRSUBSTNO(EstimatesForCustomerLbl,NumberOfEstimates);
    END;

    EVENT DeviceContactProvider@1014::DeviceContactRetrieved@9(deviceContact@1000 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.DeviceContact");
    BEGIN
      IF deviceContact.Status <> 0 THEN
        EXIT;

      CreateCustomerFromTemplate;

      Name := COPYSTR(deviceContact.PreferredName,1,MAXSTRLEN(Name));
      "E-Mail" := COPYSTR(deviceContact.PreferredEmail,1,MAXSTRLEN("E-Mail"));
      "Phone No." := COPYSTR(deviceContact.PreferredPhoneNumber,1,MAXSTRLEN("Phone No."));
      Address := COPYSTR(deviceContact.PreferredAddress.StreetAddress,1,MAXSTRLEN(Address));
      City := COPYSTR(deviceContact.PreferredAddress.Locality,1,MAXSTRLEN(City));
      County := COPYSTR(deviceContact.PreferredAddress.Region,1,MAXSTRLEN(County));

      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

