OBJECT Page 2318 BC O365 Sales Customer Card
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontakt;
               ENU=Contact];
    SourceTable=Table18;
    DataCaptionExpr=Name;
    PageType=Card;
    OnInit=VAR
             O365SalesInitialSetup@1000 : Record 2110;
           BEGIN
             IF O365SalesInitialSetup.GET THEN
               IsUsingVAT := O365SalesInitialSetup.IsUsingVAT;
           END;

    OnOpenPage=BEGIN
                 SETRANGE("Date Filter",0D,WORKDATE);
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
                           TaxArea@1001 : Record 318;
                         BEGIN
                           CreateCustomerFromTemplate;

                           OverdueAmount := CalcOverdueBalance;

                           IF TaxArea.GET("Tax Area Code") THEN
                             TaxAreaDescription := TaxArea.GetDescriptionInCurrentLanguage;

                           // Supergroup is visible only if one of the two subgroups is visible
                           SalesAndPaymentsVisible := (NOT TotalsHidden) OR
                             (("Contact Type" = "Contact Type"::Company) AND IsUsingVAT);
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
                      Visible=NewDocumentActionVisible;
                      Enabled=Name <> '';
                      PromotedIsBig=Yes;
                      Image=Invoicing-MDL-Invoice;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 O365SalesManagement.OpenNewInvoiceForCustomer(Rec);
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=NewSalesQuote;
                      CaptionML=[DAN=Nyt estimat;
                                 ENU=New Estimate];
                      ToolTipML=[DAN=Opret et estimat for debitoren.;
                                 ENU=Create an estimate for the customer.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      Visible=NewDocumentActionVisible;
                      Enabled=Name <> '';
                      PromotedIsBig=Yes;
                      Image=Invoicing-MDL-Quote;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 O365SalesManagement.OpenNewQuoteForCustomer(Rec);
                               END;
                                }
      { 24      ;1   ;Action    ;
                      Name=Delete;
                      CaptionML=[DAN=Slet;
                                 ENU=Delete];
                      ToolTipML=[DAN=Slet recorden.;
                                 ENU=Delete the record.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Invoicing-MDL-Delete;
                      OnAction=BEGIN
                                 IF NOT CONFIRM(DeleteQst,FALSE) THEN
                                   EXIT;
                                 O365SalesManagement.BlockCustomerAndDeleteContact(Rec);
                                 CurrPage.CLOSE;
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
                CaptionML=[DAN=Grundl‘ggende profil;
                           ENU=Basic Profile];
                GroupType=Group }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Kontaktnavn;
                           ENU=Contact Name];
                ToolTipML=[DAN=Angiver debitorens navn.;
                           ENU=Specifies the customer's name.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Name;
                Importance=Promoted }

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
                            }

    { 26  ;1   ;Group     ;
                CaptionML=[DAN=Kontaktoplysninger;
                           ENU=Contact Info];
                GroupType=Group }

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
                            }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens telefonnummer.;
                           ENU=Specifies the customer's telephone number.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Phone No.";
                Importance=Promoted }

    { 27  ;1   ;Group     ;
                CaptionML=[DAN=Firmaadresse;
                           ENU=Business Address];
                GroupType=Group }

    { 15  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Address }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver yderligere adresseoplysninger.;
                           ENU=Specifies additional address information.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Address 2" }

    { 18  ;2   ;Field     ;
                Lookup=No;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Post Code" }

    { 22  ;2   ;Field     ;
                Lookup=No;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=City }

    { 20  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=County }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Country/Region Code";
                LookupPageID=BC O365 Country/Region List }

    { 28  ;1   ;Group     ;
                CaptionML=[DAN=Salg og betalinger;
                           ENU=Sales and Payments];
                Visible=SalesAndPaymentsVisible;
                GroupType=Group }

    { 16  ;2   ;Group     ;
                Visible=NOT TotalsHidden;
                GroupType=Group }

    { 5   ;3   ;Field     ;
                Lookup=No;
                DrillDown=No;
                CaptionML=[DAN=Udest†ende;
                           ENU=Outstanding];
                ToolTipML=[DAN=Angiver debitorens saldo.;
                           ENU=Specifies the customer's balance.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Balance (LCY)";
                AutoFormatType=10;
                AutoFormatExpr='1' }

    { 6   ;3   ;Field     ;
                Lookup=No;
                DrillDown=No;
                CaptionML=[DAN=Forfalden;
                           ENU=Overdue];
                ToolTipML=[DAN=Angiver betalinger fra debitoren, der er forfaldne pr. dags dato.;
                           ENU=Specifies payments from the customer that are overdue per today's date.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=OverdueAmount;
                AutoFormatType=10;
                AutoFormatExpr='1';
                Editable=FALSE;
                Style=Unfavorable;
                StyleExpr=OverdueAmount > 0 }

    { 8   ;3   ;Field     ;
                Lookup=No;
                DrillDown=No;
                CaptionML=[DAN=Samlet salg (ekskl. moms);
                           ENU=Total Sales (Excl. VAT)];
                ToolTipML=[DAN=Angiver det samlede nettobel›b i RV for salg til debitoren.;
                           ENU=Specifies the total net amount of sales to the customer in LCY.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Sales (LCY)";
                AutoFormatType=10;
                AutoFormatExpr='1' }

    { 13  ;2   ;Group     ;
                Visible=("Contact Type" = "Contact Type"::Company) AND IsUsingVAT;
                GroupType=Group }

    { 21  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="VAT Registration No." }

    { 12  ;1   ;Group     ;
                Name=Tax Information;
                CaptionML=[DAN=Skat;
                           ENU=Tax];
                Visible=NOT IsUsingVAT;
                GroupType=Group }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om salgsfakturaen omfatter moms.;
                           ENU=Specifies if the sales invoice contains sales tax.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Tax Liable" }

    { 19  ;2   ;Field     ;
                CaptionML=[DAN=Skattesats;
                           ENU=Tax Rate];
                ToolTipML=[DAN=Angiver debitorens skatteomr†de.;
                           ENU=Specifies the customer's tax area.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                NotBlank=Yes;
                SourceExpr=TaxAreaDescription;
                Importance=Promoted;
                OnLookup=VAR
                           TaxArea@1001 : Record 318;
                         BEGIN
                           IF PAGE.RUNMODAL(PAGE::"O365 Tax Area List",TaxArea) = ACTION::LookupOK THEN BEGIN
                             VALIDATE("Tax Area Code",TaxArea.Code);
                             TaxAreaDescription := TaxArea.GetDescriptionInCurrentLanguage;
                           END;
                         END;

                QuickEntry=FALSE }

  }
  CODE
  {
    VAR
      CustContUpdate@1006 : Codeunit 5056;
      O365SalesManagement@1013 : Codeunit 2107;
      ProcessNewCustomerOptionQst@1001 : TextConst 'DAN=Forts‘t redigering,Kass‚r;ENU=Keep editing,Discard';
      ProcessNewCustomerInstructionTxt@1003 : TextConst 'DAN=Navn mangler. Vil du bevare debitoren?;ENU=Name is missing. Keep the customer?';
      CustomerCardState@1000 : 'Keep,Delete,Prompt';
      NewMode@1007 : Boolean;
      IsUsingVAT@1005 : Boolean;
      NewDocumentActionVisible@1010 : Boolean;
      OverdueAmount@1008 : Decimal;
      TaxAreaDescription@1004 : Text[50];
      DeleteQst@1002 : TextConst 'DAN=Er du sikker?;ENU=Are you sure?';
      TotalsHidden@1009 : Boolean;
      SalesAndPaymentsVisible@1011 : Boolean;

    LOCAL PROCEDURE CanExitAfterProcessingCustomer@2() : Boolean;
    VAR
      Response@1001 : ',KeepEditing,Discard';
    BEGIN
      IF "No." = '' THEN
        EXIT(TRUE);

      IF CustomerCardState = CustomerCardState::Delete THEN
        EXIT(DeleteCustomerRelatedData);

      IF GUIALLOWED AND (CustomerCardState = CustomerCardState::Prompt)
         AND (Blocked = Blocked::" ") AND NOT "Privacy Blocked"
      THEN
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
        IF MiniCustomerTemplate.NewCustomerFromTemplate(Customer) THEN
          COPY(Customer);

        TotalsHidden := TRUE;

        CustomerCardState := CustomerCardState::Delete;
        NewMode := FALSE;
        CurrPage.UPDATE;
      END;
    END;

    PROCEDURE SetNewDocumentActionsVisible@5();
    BEGIN
      NewDocumentActionVisible := TRUE;
    END;

    BEGIN
    END.
  }
}

