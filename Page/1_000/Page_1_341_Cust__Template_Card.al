OBJECT Page 1341 Cust. Template Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitorskabelon;
               ENU=Customer Template];
    SourceTable=Table1300;
    DataCaptionExpr="Template Name";
    PageType=Card;
    SourceTableTemporary=Yes;
    CardPageID=Cust. Template Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚rer,Stamdata;
                                ENU=New,Process,Reports,Master Data];
    OnOpenPage=BEGIN
                 IF Customer."No." <> '' THEN
                   CreateConfigTemplateFromExistingCustomer(Customer,Rec);
               END;

    OnDeleteRecord=BEGIN
                     CheckTemplateNameProvided
                   END;

    OnQueryClosePage=BEGIN
                       CASE CloseAction OF
                         ACTION::LookupOK:
                           IF Code <> '' THEN
                             CheckTemplateNameProvided;
                         ACTION::LookupCancel:
                           IF DELETE(TRUE) THEN;
                       END;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           SetDimensionsEnabled;
                           SetTemplateEnabled;
                           SetNoSeries;
                         END;

    ActionList=ACTIONS
    {
      { 27      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=Stamdata;
                                 ENU=Master Data];
                      ActionContainerType=NewDocumentItems }
      { 31      ;2   ;Action    ;
                      Name=Default Dimensions;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1343;
                      RunPageLink=Table Id=CONST(18),
                                  Master Record Template Code=FIELD(Code);
                      Promoted=Yes;
                      Enabled=DimensionsEnabled;
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4 }
    }
  }
  CONTROLS
  {
    { 29  ;0   ;Container ;
                ContainerType=ContentArea }

    { 28  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† skabelonen.;
                           ENU=Specifies the name of the template.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Template Name";
                OnValidate=BEGIN
                             SetDimensionsEnabled;
                           END;
                            }

    { 35  ;2   ;Field     ;
                Name=TemplateEnabled;
                CaptionML=[DAN=Aktiveret;
                           ENU=Enabled];
                ToolTipML=[DAN=Angiver, om skabelonen er klar til at blive brugt;
                           ENU=Specifies if the template is ready to be used];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=TemplateEnabled;
                OnValidate=VAR
                             ConfigTemplateHeader@1000 : Record 8618;
                           BEGIN
                             IF ConfigTemplateHeader.GET(Code) THEN
                               ConfigTemplateHeader.SetTemplateEnabled(TemplateEnabled);
                           END;
                            }

    { 37  ;2   ;Field     ;
                Name=NoSeries;
                CaptionML=[DAN=No. Series;
                           ENU=No. Series];
                ToolTipML=[DAN=Specifies the code for the number series that will be used to assign numbers to customers.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to customers.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=NoSeries;
                TableRelation="No. Series";
                OnValidate=VAR
                             ConfigTemplateHeader@1000 : Record 8618;
                           BEGIN
                             IF ConfigTemplateHeader.GET(Code) THEN
                               ConfigTemplateHeader.SetNoSeries(NoSeries);
                           END;
                            }

    { 25  ;1   ;Group     ;
                Name=AddressDetails;
                CaptionML=[DAN=Adresse og kontakt;
                           ENU=Address & Contact];
                GroupType=Group }

    { 34  ;2   ;Group     ;
                CaptionML=[DAN=Adresse;
                           ENU=Address];
                GroupType=Group }

    { 24  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Importance=Promoted }

    { 23  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens by.;
                           ENU=Specifies the customer's city.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 22  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 32  ;2   ;Group     ;
                CaptionML=[DAN=Kontakt;
                           ENU=Contact];
                GroupType=Group }

    { 33  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den foretrukne metode til modtagelse af dokumenter til denne debitor.;
                           ENU=Specifies the preferred method of sending documents to this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Sending Profile" }

    { 21  ;1   ;Group     ;
                Name=Invoicing;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing];
                GroupType=Group }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om momsregistreringsnummeret er valideret af momsnummervalideringsservicen.;
                           ENU=Specifies if the VAT registration number has been validated by the VAT number validation service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Validate EU Vat Reg. No." }

    { 20  ;2   ;Group     ;
                Name=PostingDetails;
                CaptionML=[DAN=Bogf›ringsoplysninger;
                           ENU=Posting Details];
                GroupType=Group }

    { 19  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens handelstype for at knytte transaktioner, der er foretaget for denne debitor, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the customer's trade type to link transactions made for this customer with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group";
                Importance=Promoted }

    { 18  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens momsspecifikation, hvortil der skal knyttes transaktioner for denne debitor.;
                           ENU=Specifies the customer's VAT specification to link transactions made for this customer to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group" }

    { 17  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver debitorens markedstype, hvortil der skal knyttes forretningstransaktioner.;
                           ENU=Specifies the customer's market type to link business transactions to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Posting Group";
                Importance=Promoted }

    { 16  ;2   ;Group     ;
                Name=PricesandDiscounts;
                CaptionML=[DAN=Priser og rabatter;
                           ENU=Prices and Discounts];
                GroupType=Group }

    { 15  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den debitorprisgruppekode, du kan bruge til at oprette salgspriser i vinduet Salgspriser.;
                           ENU=Specifies the customer price group code, which you can use to set up special sales prices in the Sales Prices window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Price Group";
                Importance=Promoted }

    { 14  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den debitorrabatgruppekode, du kan bruge som kriterie for at oprette specialrabatter i vinduet Salgslinjerabatter.;
                           ENU=Specifies the customer discount group code, which you can use as a criterion to set up special discounts in the Sales Line Discounts window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Customer Disc. Group";
                Importance=Promoted }

    { 13  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om der beregnes salgslinjerabat, n†r en s‘rlig salgspris tilbydes i overensstemmelse med ops‘tningen i vinduet Salgspriser.;
                           ENU=Specifies if a sales line discount is calculated when a special sales price is offered according to setup in the Sales Prices window.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Allow Line Disc." }

    { 12  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, om felterne Enhedspris og Linjebel›b p† bilagslinjer skal vises med eller uden moms.;
                           ENU=Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Prices Including VAT" }

    { 11  ;2   ;Group     ;
                Name=ForeignTrade;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade];
                GroupType=Group }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver en standardvalutakode for debitoren.;
                           ENU=Specifies a default currency code for the customer.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted }

    { 9   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det sprog, der skal anvendes p† udskrifter til denne debitor.;
                           ENU=Specifies the language to be used on printouts for this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code" }

    { 1060004;2;Group     ;
                Name=E-invoicing;
                CaptionML=[DAN=E-fakturering;
                           ENU=E-invoicing];
                GroupType=Group }

    { 1060001;3;Field     ;
                ToolTipML=[DAN=Angiver den profil, som debitoren kr‘ver til elektroniske dokumenter.;
                           ENU=Specifies the profile that this customer requires for electronic documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Profile Code" }

    { 1060000;3;Field     ;
                ToolTipML=[DAN=Angiver, om debitoren kr‘ver en profilkode til elektroniske dokumenter.;
                           ENU=Specifies if this customer requires a profile code for electronic documents.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="OIOUBL Profile Code Required" }

    { 8   ;1   ;Group     ;
                Name=Payments;
                CaptionML=[DAN=Betalinger;
                           ENU=Payments];
                GroupType=Group }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan du kan udligne betalinger p† poster for denne debitor.;
                           ENU=Specifies how to apply payments to entries for this customer.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Application Method" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver under hvilke betingelser, du kr‘ver, at debitoren betaler for produkter.;
                           ENU=Specifies at which terms you require the customer to pay for products.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan betaling af salgsdokumentet skal sendes, f.eks. bankoverf›rsel eller check.;
                           ENU=Specifies how payment for the sales document must be submitted, such as bank transfer or check.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code";
                Importance=Promoted }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan rykkere om forfaldne betalinger h†ndteres for denne debitor.;
                           ENU=Specifies how reminders about late payments are handled for this customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Reminder Terms Code";
                Importance=Promoted }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de renter, der beregnes for debitoren.;
                           ENU=Specifies the finance charges that are calculated for the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Fin. Charge Terms Code";
                Importance=Promoted }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om denne debitor skal medtages ved udskrivning af kontoudtog.;
                           ENU=Specifies whether to include this customer when you print the Statement report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Print Statements" }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der ikke m† ydes betalingstolerance til debitoren.;
                           ENU=Specifies that the customer is not allowed a payment tolerance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Block Payment Tolerance" }

  }
  CODE
  {
    VAR
      Customer@1002 : Record 18;
      NoSeries@1004 : Code[20];
      DimensionsEnabled@1000 : Boolean INDATASET;
      ProvideTemplateNameErr@1001 : TextConst '@@@=%1 Template Name;DAN=Du skal angive en %1.;ENU=You must enter a %1.';
      TemplateEnabled@1003 : Boolean;

    LOCAL PROCEDURE SetDimensionsEnabled@4();
    BEGIN
      DimensionsEnabled := "Template Name" <> '';
    END;

    LOCAL PROCEDURE SetTemplateEnabled@5();
    VAR
      ConfigTemplateHeader@1000 : Record 8618;
    BEGIN
      TemplateEnabled := ConfigTemplateHeader.GET(Code) AND ConfigTemplateHeader.Enabled;
    END;

    LOCAL PROCEDURE CheckTemplateNameProvided@2();
    BEGIN
      IF "Template Name" = '' THEN
        ERROR(STRSUBSTNO(ProvideTemplateNameErr,FIELDCAPTION("Template Name")));
    END;

    [External]
    PROCEDURE CreateFromCust@1(FromCustomer@1000 : Record 18);
    BEGIN
      Customer := FromCustomer;
    END;

    LOCAL PROCEDURE SetNoSeries@7();
    VAR
      ConfigTemplateHeader@1000 : Record 8618;
    BEGIN
      NoSeries := '';
      IF ConfigTemplateHeader.GET(Code) THEN
        NoSeries := ConfigTemplateHeader."Instance No. Series";
    END;

    BEGIN
    END.
  }
}

