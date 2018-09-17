OBJECT Page 2114 O365 Posted Sales Inv. Lines
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
             ShowOnlyOnBrick := TRUE;
           END;

    OnAfterGetRecord=VAR
                       Currency@1002 : Record 4;
                       GLSetup@1001 : Record 98;
                       SalesInvoiceHeader@1003 : Record 112;
                       CurrencySymbol@1000 : Text[10];
                     BEGIN
                       UpdatePriceDescription;
                       SalesInvoiceHeader.GET("Document No.");

                       IF SalesInvoiceHeader."Currency Code" = '' THEN BEGIN
                         GLSetup.GET;
                         CurrencySymbol := GLSetup.GetCurrencySymbol;
                       END ELSE BEGIN
                         IF Currency.GET(SalesInvoiceHeader."Currency Code") THEN;
                         CurrencySymbol := Currency.GetCurrencySymbol;
                       END;
                       CurrencyFormat := STRSUBSTNO('%1<precision, 2:2><standard format, 0>',CurrencySymbol);
                       ShowOnlyOnBrick := FALSE;
                     END;

    OnAfterGetCurrRecord=VAR
                           VATProductPostingGroup@1000 : Record 324;
                         BEGIN
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
                ToolTipML=[DAN=Angiver en beskrivelse af varen eller tjenesten p† linjen.;
                           ENU=Specifies a description of the item or service on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Description;
                ShowCaption=No }

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
                CaptionML=[DAN=Enhed;
                           ENU=Unit];
                ToolTipML=[DAN=Angiver enhedskoden for varen.;
                           ENU=Specifies the unit of measure code for the item.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit of Measure";
                ShowCaption=No }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Pris;
                           ENU=Price];
                ToolTipML=[DAN=Angiver pris for ‚n enhed p† salgslinjen.;
                           ENU=Specifies the price for one unit on the sales line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Unit Price";
                AutoFormatType=10;
                AutoFormatExpr=CurrencyFormat }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver skattegruppekoden for indtastning af skatteoplysninger.;
                           ENU=Specifies the tax group code for the tax-detail entry.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Tax Group Code";
                Visible=NOT IsUsingVAT }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den momsprocent, der anvendes til salgs- og k›bslinjer med dette moms-id.;
                           ENU=Specifies the VAT % that was used on the sales or purchase lines with this VAT Identifier.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="VAT %";
                Visible=NOT IsUsingVAT }

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

    { 11  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Line Discount %" }

    { 13  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Line Discount Amount" }

    { 8   ;2   ;Field     ;
                Name=LineAmountExclVAT;
                CaptionML=[DAN=Linjebel›b;
                           ENU=Line Amount];
                ToolTipML=[DAN=Angiver det nettobel›b uden eventuelt fakturarabatbel›b, som skal betales for produkterne p† linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=GetLineAmountExclVAT;
                AutoFormatType=10;
                AutoFormatExpr=CurrencyFormat }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Linjebel›b;
                           ENU=Line Amount];
                ToolTipML=[DAN=Angiver det nettobel›b uden eventuelt fakturarabatbel›b, som skal betales for produkterne p† linjen.;
                           ENU=Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Line Amount";
                AutoFormatType=10;
                AutoFormatExpr=CurrencyFormat;
                Visible=ShowOnlyOnBrick }

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

    { 17  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Price description";
                Visible=ShowOnlyOnBrick }

  }
  CODE
  {
    VAR
      CurrencyFormat@1000 : Text;
      VATProductPostingGroupDescription@1002 : Text[50];
      LineQuantity@1004 : Decimal;
      IsUsingVAT@1001 : Boolean;
      ShowOnlyOnBrick@1003 : Boolean;

    BEGIN
    END.
  }
}

