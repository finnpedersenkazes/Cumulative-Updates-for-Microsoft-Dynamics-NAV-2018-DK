OBJECT Page 1344 Vendor Template Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kreditorskabelon;
               ENU=Vendor Template];
    SourceTable=Table1303;
    DataCaptionExpr="Template Name";
    PageType=Card;
    SourceTableTemporary=Yes;
    CardPageID=Vendor Template Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚rer,Stamdata;
                                ENU=New,Process,Reports,Master Data];
    OnOpenPage=BEGIN
                 IF Vendor."No." <> '' THEN
                   CreateConfigTemplateFromExistingVendor(Vendor,Rec);
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

    { 2   ;2   ;Field     ;
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

    { 13  ;2   ;Field     ;
                Name=NoSeries;
                CaptionML=[DAN=No. Series;
                           ENU=No. Series];
                ToolTipML=[DAN=Specifies the code for the number series that will be used to assign numbers to vendors.;
                           ENU=Specifies the code for the number series that will be used to assign numbers to vendors.];
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
                CaptionML=[DAN=Kundeoplysninger;
                           ENU=Address Details];
                GroupType=Group }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummer.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Post Code";
                Importance=Promoted }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens by.;
                           ENU=Specifies the vendor's city.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=City }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr†de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 21  ;1   ;Group     ;
                Name=Invoicing;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing];
                GroupType=Group }

    { 4   ;2   ;Field     ;
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
                ToolTipML=[DAN=Angiver kreditorens handelstype for at knytte transaktioner, der er foretaget for denne kreditoren, til den relevante finanskonto i overensstemmelse med den generelle bogf›ringsops‘tning.;
                           ENU=Specifies the vendor's trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Bus. Posting Group";
                Importance=Promoted }

    { 18  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens momsspecifikation for at knytte transaktioner, der er foretaget for denne kreditoren, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the vendor's VAT specification to link transactions made for this vendor with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group" }

    { 17  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens markedstype for at knytte forretningstransaktioner, der er foretaget for denne kreditor, til den relevante finanskonto.;
                           ENU=Specifies the vendor's market type to link business transactions made for the vendor with the appropriate account in the general ledger.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Posting Group";
                Importance=Promoted }

    { 15  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens fakturarabatkode. N†r du opretter et nyt kreditorkort, inds‘ttes det nummer, du har angivet i feltet Nummer, automatisk.;
                           ENU=Specifies the vendor's invoice discount code. When you set up a new vendor card, the number you have entered in the No. field is automatically inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoice Disc. Code";
                Importance=Promoted }

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
                ToolTipML=[DAN=Angiver en standardvalutakode for kreditoren.;
                           ENU=Specifies a default currency code for the vendor.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted }

    { 9   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver sproget p† udskrifter for denne kreditor.;
                           ENU=Specifies the language on printouts for this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Language Code" }

    { 8   ;1   ;Group     ;
                Name=Payments;
                CaptionML=[DAN=Betalinger;
                           ENU=Payments];
                GroupType=Group }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan du kan udligne betalinger p† poster for denne kreditor.;
                           ENU=Specifies how to apply payments to entries for this vendor.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Application Method" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode, der angiver, hvilke betalingsbetingelser kreditoren s‘dvanligvis forlanger.;
                           ENU=Specifies a code that indicates the payment terms that the vendor usually requires.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Terms Code";
                Importance=Promoted }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan kreditoren kr‘ver, at du sender betaling, f.eks. via bankoverf›rsel eller check.;
                           ENU=Specifies how the vendor requires you to submit payment, such as bank transfer or check.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Payment Method Code";
                Importance=Promoted }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan kreditoren beregner renter.;
                           ENU=Specifies how the vendor calculates finance charges.];
                ApplicationArea=#Advanced;
                SourceExpr="Fin. Charge Terms Code";
                Importance=Promoted }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kreditoren tillader betalingstolerance.;
                           ENU=Specifies if the vendor allows payment tolerance.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Block Payment Tolerance" }

  }
  CODE
  {
    VAR
      Vendor@1002 : Record 23;
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
    PROCEDURE CreateFromVend@1(FromVendor@1000 : Record 23);
    BEGIN
      Vendor := FromVendor;
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

