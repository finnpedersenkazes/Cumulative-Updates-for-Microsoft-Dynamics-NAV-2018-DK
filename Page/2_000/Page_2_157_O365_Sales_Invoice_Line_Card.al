OBJECT Page 2157 O365 Sales Invoice Line Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Fakturalinje;
               ENU=Invoice Line];
    DeleteAllowed=No;
    SourceTable=Table37;
    PageType=Card;
    RefreshOnActivate=Yes;
    OnInit=VAR
             O365SalesInitialSetup@1000 : Record 2110;
           BEGIN
             SalesSetup.GET;
             IF TaxSetup.GET THEN;
             Currency.InitRoundingPrecision;
             O365SalesInvoiceMgmt.ConstructCurrencyFormatString(Rec,CurrencyFormat);
             IsUsingVAT := O365SalesInitialSetup.IsUsingVAT;
             EnterQuantity := FALSE;
             EnterDiscount := FALSE;
           END;

    OnOpenPage=BEGIN
                 EnterQuantity := Quantity > 1;
                 EnterDiscount := ("Line Discount %" > 0) OR ("Line Discount Amount" > 0);
               END;

    OnAfterGetRecord=BEGIN
                       UpdatePriceDescription;
                       O365SalesInvoiceMgmt.ConstructCurrencyFormatString(Rec,CurrencyFormat);
                     END;

    OnNewRecord=VAR
                  SalesLine@1000 : Record 37;
                BEGIN
                  Type := Type::Item;
                  SalesLine.SETRANGE("Document Type","Document Type");
                  SalesLine.SETRANGE("Document No.","Document No.");
                  IF SalesLine.FINDLAST THEN;
                  "Line No." := SalesLine."Line No." + 10000;
                  TaxRate := 0;
                  CLEAR(VATProductPostingGroupDescription);
                END;

    OnModifyRecord=BEGIN
                     UpdatePriceDescription
                   END;

    OnAfterGetCurrRecord=VAR
                           TaxDetail@1000 : Record 322;
                         BEGIN
                           UpdatePageCaption;
                           CALCFIELDS("Posting Date");
                           TaxRate := TaxDetail.GetSalesTaxRate("Tax Area Code","Tax Group Code","Posting Date","Tax Liable");
                           UpdateTaxRateText;
                           CalculateTotals;
                           DescriptionSelected := Description <> '';
                           LineQuantity := Quantity;
                           TaxRateEditable := DescriptionSelected AND (TaxSetup."Non-Taxable Tax Group Code" <> "Tax Group Code");
                           UpdateVATPostingGroupDescription;
                         END;

    ActionList=ACTIONS
    {
      { 4       ;    ;ActionContainer;
                      CaptionML=[DAN=Nyt;
                                 ENU=New];
                      ActionContainerType=ActionItems }
      { 15      ;1   ;Action    ;
                      Name=DeleteLine;
                      CaptionML=[DAN=Slet linje;
                                 ENU=Delete Line];
                      ToolTipML=[DAN=Slet den valgte linje.;
                                 ENU=Delete the selected line.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      Image=Delete;
                      Scope=Repeater;
                      OnAction=VAR
                                 IdentityManagement@1000 : Codeunit 9801;
                               BEGIN
                                 IF "No." = '' THEN
                                   EXIT;

                                 IF NOT CONFIRM(DeleteQst,TRUE) THEN
                                   EXIT;
                                 DELETE(TRUE);
                                 IF NOT IdentityManagement.IsInvAppId THEN
                                   CurrPage.UPDATE;
                               END;

                      Gesture=RightSwipe }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=grpGeneral;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="No.";
                Visible=FALSE;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 23  ;2   ;Group     ;
                Name=grpPricelist;
                CaptionML=[DAN="";
                           ENU=""];
                GroupType=Group }

    { 22  ;3   ;Field     ;
                CaptionML=[DAN=V�lg fra prisliste;
                           ENU=Choose from price list];
                ToolTipML=[DAN=Angiver en beskrivelse af varen eller tjenesten p� linjen.;
                           ENU=Specifies a description of the item or service on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Description;
                LookupPageID=O365 Sales Item Lookup;
                OnValidate=BEGIN
                             IF IsLookupRequested THEN
                               IF NOT O365SalesInvoiceMgmt.LookupDescription(Rec,Description,DescriptionSelected) THEN
                                 ERROR('');

                             RedistributeTotalsOnAfterValidate;
                             DescriptionSelected := Description <> '';
                           END;

                ShowCaption=No }

    { 21  ;2   ;Group     ;
                Name=grpEnterQuantity;
                CaptionML=[DAN=Antal og pris;
                           ENU=Quantity & Price];
                Visible=Description <> '';
                GroupType=Group }

    { 20  ;3   ;Field     ;
                Name=EnterQuantity;
                CaptionML=[DAN=Angiv et antal;
                           ENU=Enter a quantity];
                ToolTipML=[DAN=Angiver, om brugeren angiver antallet af varen eller tjenesten p� linjen.;
                           ENU=Specifies if the user enters the quantity of the item or service on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=EnterQuantity }

    { 18  ;2   ;Group     ;
                Name=grpQuantity;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=(Description <> '') AND EnterQuantity;
                GroupType=Group }

    { 5   ;3   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver antallet af varen eller tjenesten p� linjen.;
                           ENU=Specifies the quantity of the item or service on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                DecimalPlaces=0:5;
                SourceExpr=LineQuantity;
                Enabled=DescriptionSelected;
                OnValidate=BEGIN
                             VALIDATE(Quantity,LineQuantity);
                             RedistributeTotalsOnAfterValidate;
                             ShowInvoiceDiscountNotification;
                           END;
                            }

    { 12  ;3   ;Field     ;
                CaptionML=[DAN=Pris;
                           ENU=Price];
                ToolTipML=[DAN=Angiver pris for �n enhed p� salgslinjen.;
                           ENU=Specifies the price for one unit on the sales line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit Price";
                Enabled=DescriptionSelected;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 11  ;3   ;Field     ;
                Width=5;
                CaptionML=[DAN=Enhed;
                           ENU=Unit];
                ToolTipML=[DAN=Angiver salgsenheden for produktet eller tjenesten.;
                           ENU=Specifies the sales unit of measure for this product or service.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit of Measure";
                Editable=FALSE }

    { 13  ;2   ;Group     ;
                Name=grpGiveDiscount;
                CaptionML=[DAN=Rabat;
                           ENU=Discount];
                Visible=Description <> '';
                GroupType=Group }

    { 26  ;3   ;Field     ;
                Name=EnterDiscount;
                CaptionML=[DAN=Giv rabat;
                           ENU=Give a discount];
                ToolTipML=[DAN=Angiver, om brugeren angiver rabatbel�bet p� linjen.;
                           ENU=Specifies if the user enters the discount on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=EnterDiscount;
                OnValidate=BEGIN
                             IF NOT EnterDiscount THEN
                               VALIDATE("Line Discount %",0);
                           END;
                            }

    { 16  ;2   ;Group     ;
                Name=grpDiscount;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=(Description <> '') AND EnterDiscount;
                GroupType=Group }

    { 17  ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Line Discount %";
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                             IF HasShownInvoiceDiscountNotification THEN
                               InvoiceDiscountNotification.RECALL;
                           END;
                            }

    { 7   ;3   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Line Discount Amount";
                OnValidate=VAR
                             LineDiscountAmount@1000 : Decimal;
                           BEGIN
                             GetTotalSalesHeader;
                             LineDiscountAmount :=
                               O365SalesInvoiceMgmt.GetValueWithinBounds(
                                 "Line Discount Amount",0,"Unit Price" * Quantity,AmountOutsideOfBoundsNotificationSend,TotalSalesHeader.RECORDID);
                             IF LineDiscountAmount <> "Line Discount Amount" THEN
                               VALIDATE("Line Discount Amount",LineDiscountAmount);
                             RedistributeTotalsOnAfterValidate;
                             IF HasShownInvoiceDiscountNotification THEN
                               InvoiceDiscountNotification.RECALL;
                           END;
                            }

    { 19  ;1   ;Group     ;
                Visible=Description <> '';
                GroupType=Group }

    { 28  ;2   ;Group     ;
                Name=grpEnterTax;
                CaptionML=[DAN=Skat;
                           ENU=Tax];
                Visible=NOT IsUsingVAT;
                GroupType=Group }

    { 29  ;3   ;Field     ;
                CaptionML=[DAN=Skattegruppe;
                           ENU=Tax Group];
                ToolTipML=[DAN=Angiver skattegruppekoden for indtastning af skatteoplysninger.;
                           ENU=Specifies the tax group code for the tax-detail entry.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                NotBlank=Yes;
                SourceExpr="Tax Group Code";
                Editable=DescriptionSelected;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;
                            }

    { 25  ;2   ;Group     ;
                Name=grpTax;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=NOT IsUsingVAT;
                GroupType=Group }

    { 8   ;3   ;Field     ;
                Name=TaxRate;
                CaptionML=[DAN=Skatteprocent;
                           ENU=Tax %];
                ToolTipML=[DAN=Angiver den momsprocent, der anvendes til salgs- og k�bslinjer med dette moms-id.;
                           ENU=Specifies the VAT % that was used on the sales or purchase lines with this VAT Identifier.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                DecimalPlaces=0:3;
                SourceExpr=TaxRateText;
                Enabled=TaxRateEditable;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;

                OnLookup=VAR
                           TaxDetail@1001 : Record 322;
                           TaxArea@1000 : Record 318;
                           SalesHeader@1003 : Record 36;
                         BEGIN
                           CALCFIELDS("Posting Date");
                           IF PAGE.RUNMODAL(PAGE::"O365 Tax Area List",TaxArea) = ACTION::LookupOK THEN BEGIN
                             IF SalesHeader.GET("Document Type","Document No.") THEN
                               SalesHeader.VALIDATE("Tax Area Code",TaxArea.Code);
                             TaxRate := TaxDetail.GetSalesTaxRate("Tax Area Code","Tax Group Code","Posting Date","Tax Liable");
                             UpdateTaxRateText;
                           END;
                         END;

                ShowCaption=No;
                QuickEntry=FALSE }

    { 24  ;2   ;Group     ;
                Name=grpVAT;
                CaptionML=[DAN=Moms;
                           ENU=VAT];
                Visible=IsUsingVAT;
                GroupType=Group }

    { 27  ;3   ;Field     ;
                CaptionML=[DAN=Moms;
                           ENU=VAT];
                ToolTipML=[DAN=Angiver momsgruppekoden for denne vare.;
                           ENU=Specifies the VAT group code for this item.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                NotBlank=Yes;
                SourceExpr=VATProductPostingGroupDescription;
                Enabled=DescriptionSelected;
                OnValidate=BEGIN
                             RedistributeTotalsOnAfterValidate;
                           END;

                OnLookup=VAR
                           VATProductPostingGroup@1000 : Record 324;
                         BEGIN
                           IF PAGE.RUNMODAL(PAGE::"O365 VAT Product Posting Gr.",VATProductPostingGroup) = ACTION::LookupOK THEN BEGIN
                             VALIDATE("VAT Prod. Posting Group",VATProductPostingGroup.Code);
                             VATProductPostingGroupDescription := VATProductPostingGroup.Description;
                             RedistributeTotalsOnAfterValidate;
                           END;
                         END;

                ShowCaption=No;
                QuickEntry=FALSE }

    { 6   ;1   ;Group     ;
                Name=grpTotal;
                CaptionML=[DAN="";
                           ENU=""];
                Visible=Description <> '';
                GroupType=Group }

    { 9   ;2   ;Field     ;
                Name=LineAmountExclVAT;
                CaptionML=[DAN=Linjebel�b;
                           ENU=Line Amount];
                ToolTipML=[DAN=Angiver det nettobel�b uden eventuelt fakturarabatbel�b, som skal betales for produkterne p� linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=GetLineAmountExclVAT;
                AutoFormatType=10;
                AutoFormatExpr=CurrencyFormat;
                Editable=False }

    { 10  ;2   ;Field     ;
                Name=LineAmountInclVAT;
                CaptionML=[DAN=Linjebel�b inkl. moms;
                           ENU=Line Amount Incl. VAT];
                ToolTipML=[DAN=Angiver det nettobel�b med moms og uden eventuel fakturarabat, der skal betales for produkterne p� linjen.;
                           ENU=Specifies the net amount, including VAT and excluding any invoice discount, that must be paid for products on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=GetLineAmountInclVAT;
                AutoFormatType=10;
                AutoFormatExpr=CurrencyFormat;
                Editable=False }

  }
  CODE
  {
    VAR
      Currency@1008 : Record 4;
      SalesSetup@1007 : Record 311;
      TotalSalesHeader@1006 : Record 36;
      TotalSalesLine@1005 : Record 37;
      TaxSetup@1012 : Record 326;
      O365SalesInvoiceMgmt@1021 : Codeunit 2310;
      DocumentTotals@1004 : Codeunit 57;
      InvoiceDiscountNotification@1019 : Notification;
      CurrencyFormat@1001 : Text;
      TaxRateText@1018 : Text;
      VATProductPostingGroupDescription@1027 : Text[50];
      VATAmount@1002 : Decimal;
      TaxRate@1009 : Decimal;
      LineQuantity@1003 : Decimal;
      TaxRateEditable@1011 : Boolean;
      HasShownInvoiceDiscountNotification@1000 : Boolean;
      AmountOutsideOfBoundsNotificationSend@1023 : Boolean;
      DescriptionSelected@1010 : Boolean;
      DeleteQst@1013 : TextConst 'DAN=Er du sikker?;ENU=Are you sure?';
      IsUsingVAT@1017 : Boolean;
      InvoiceCaptionTxt@1025 : TextConst 'DAN=Fakturalinje;ENU=Invoice Line';
      EstimateCaptionTxt@1026 : TextConst 'DAN=Estimatlinje;ENU=Estimate Line';
      EnterQuantity@1014 : Boolean;
      EnterDiscount@1015 : Boolean;
      PercentTxt@1020 : TextConst 'DAN=%;ENU=%';

    LOCAL PROCEDURE CalculateTotals@6();
    BEGIN
      GetTotalSalesHeader;
      IF SalesSetup."Calc. Inv. Discount" AND ("Document No." <> '') AND (TotalSalesHeader."Customer Posting Group" <> '') THEN
        CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",Rec);

      DocumentTotals.CalculateSalesTotals(TotalSalesLine,VATAmount,Rec);
    END;

    LOCAL PROCEDURE RedistributeTotalsOnAfterValidate@2();
    BEGIN
      CurrPage.SAVERECORD;

      TotalSalesHeader.GET("Document Type","Document No.");
      DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE GetTotalSalesHeader@13();
    BEGIN
      IF NOT TotalSalesHeader.GET("Document Type","Document No.") THEN
        CLEAR(TotalSalesHeader);
      IF Currency.Code <> TotalSalesHeader."Currency Code" THEN
        IF NOT Currency.GET(TotalSalesHeader."Currency Code") THEN
          Currency.InitRoundingPrecision;
    END;

    LOCAL PROCEDURE UpdateTaxRateText@8();
    BEGIN
      TaxRateText := FORMAT(TaxRate) + PercentTxt;
    END;

    LOCAL PROCEDURE ShowInvoiceDiscountNotification@4();
    BEGIN
      IF HasShownInvoiceDiscountNotification THEN
        EXIT;
      IF "Line Discount %" = xRec."Line Discount %" THEN
        EXIT;
      GetTotalSalesHeader;
      O365SalesInvoiceMgmt.ShowInvoiceDiscountNotification(InvoiceDiscountNotification,TotalSalesHeader.RECORDID);
      HasShownInvoiceDiscountNotification := TRUE;
    END;

    LOCAL PROCEDURE UpdatePageCaption@5();
    BEGIN
      IF "Document Type" = "Document Type"::Invoice THEN
        CurrPage.CAPTION := InvoiceCaptionTxt
      ELSE
        IF "Document Type" = "Document Type"::Quote THEN
          CurrPage.CAPTION := EstimateCaptionTxt;
    END;

    LOCAL PROCEDURE UpdateVATPostingGroupDescription@10();
    VAR
      VATProductPostingGroup@1000 : Record 324;
    BEGIN
      IF VATProductPostingGroup.GET("VAT Prod. Posting Group") THEN
        VATProductPostingGroupDescription := VATProductPostingGroup.Description
      ELSE
        CLEAR(VATProductPostingGroup);
    END;

    BEGIN
    END.
  }
}

