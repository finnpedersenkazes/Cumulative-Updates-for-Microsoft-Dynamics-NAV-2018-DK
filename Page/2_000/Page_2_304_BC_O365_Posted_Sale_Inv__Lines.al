OBJECT Page 2304 BC O365 Posted Sale Inv. Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Sendte fakturalinjer;
               ENU=Sent Invoice Lines];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table113;
    PageType=ListPart;
    OnInit=VAR
             O365SalesInitialSetup@6115 : Record 2110;
           BEGIN
             IsUsingVAT := O365SalesInitialSetup.IsUsingVAT;
           END;

    OnAfterGetRecord=VAR
                       VATProductPostingGroup@1000 : Record 324;
                     BEGIN
                       UpdatePriceDescription;
                       UpdateCurrencyFormat;
                       IF VATProductPostingGroup.GET("VAT Prod. Posting Group") THEN
                         VATProductPostingGroupDescription := VATProductPostingGroup.Description
                       ELSE
                         CLEAR(VATProductPostingGroup);
                       LineQuantity := Quantity;
                     END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen eller servicen p† linjen.;
                           ENU=Specifies a description of the item or service on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Description }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver antallet af varen eller tjenesten p† linjen.;
                           ENU=Specifies the quantity of the item or service on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                DecimalPlaces=0:5;
                SourceExpr=LineQuantity;
                Enabled=FALSE }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Pris pr.;
                           ENU=Price Per];
                ToolTipML=[DAN=Angiver enhedskoden for varen.;
                           ENU=Specifies the unit of measure code for the item.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit of Measure" }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Pris;
                           ENU=Price];
                ToolTipML=[DAN=Angiver prisen for ‚n enhed p† salgslinjen.;
                           ENU=Specifies the price for one unit on the sales line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit Price";
                AutoFormatType=10;
                AutoFormatExpr=CurrencyFormat }

    { 11  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Line Discount %" }

    { 38  ;2   ;Field     ;
                CaptionML=[DAN=Moms;
                           ENU=VAT];
                ToolTipML=[DAN=Angiver momsgruppekoden for denne vare.;
                           ENU=Specifies the VAT group code for this item.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                NotBlank=Yes;
                SourceExpr=VATProductPostingGroupDescription;
                Visible=IsUsingVAT;
                QuickEntry=FALSE }

    { 5   ;2   ;Field     ;
                Name=LineAmountInclVAT;
                CaptionML=[DAN=Linjebel›b inkl. moms;
                           ENU=Line Amount Incl. VAT];
                ToolTipML=[DAN=Angiver de nettobel›b med moms og uden eventuel fakturarabat, der skal betales for produkterne p† linjen.;
                           ENU=Specifies the net amounts, including VAT and excluding any invoice discount, that must be paid for products on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=GetLineAmountInclVAT;
                AutoFormatType=10;
                AutoFormatExpr=CurrencyFormat }

  }
  CODE
  {
    VAR
      CurrencyFormat@1000 : Text;
      VATProductPostingGroupDescription@1002 : Text[50];
      LineQuantity@1004 : Decimal;
      IsUsingVAT@1001 : Boolean;

    LOCAL PROCEDURE UpdateCurrencyFormat@3();
    VAR
      Currency@1003 : Record 4;
      GLSetup@1002 : Record 98;
      SalesInvoiceHeader@1001 : Record 112;
      CurrencySymbol@1000 : Text[10];
    BEGIN
      SalesInvoiceHeader.GET("Document No.");
      IF SalesInvoiceHeader."Currency Code" = '' THEN BEGIN
        GLSetup.GET;
        CurrencySymbol := GLSetup.GetCurrencySymbol;
      END ELSE BEGIN
        IF Currency.GET(SalesInvoiceHeader."Currency Code") THEN;
        CurrencySymbol := Currency.GetCurrencySymbol;
      END;
      CurrencyFormat := STRSUBSTNO('%1<precision, 2:2><standard format, 0>',CurrencySymbol);
    END;

    BEGIN
    END.
  }
}

