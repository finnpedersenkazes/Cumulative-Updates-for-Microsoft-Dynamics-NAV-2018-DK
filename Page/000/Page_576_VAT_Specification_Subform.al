OBJECT Page 576 VAT Specification Subform
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table290;
    PageType=ListPart;
    SourceTableTemporary=Yes;
    OnInit=BEGIN
             InvoiceDiscountAmountEditable := TRUE;
             VATAmountEditable := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       IF MainFormActiveTab = MainFormActiveTab::Other THEN
                         VATAmountEditable := AllowVATDifference AND NOT "Includes Prepayment"
                       ELSE
                         VATAmountEditable := AllowVATDifference;
                       InvoiceDiscountAmountEditable := AllowInvDisc AND NOT "Includes Prepayment";
                     END;

    OnModifyRecord=BEGIN
                     ModifyRec;
                     EXIT(FALSE);
                   END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver indholdet af dette felt fra feltet Moms-id i tabellen Momsbogf›ringsops‘tning.;
                           ENU=Specifies the contents of this field from the VAT Identifier field in the VAT Posting Setup table.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Identifier";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den momsprocent, der anvendes til salgs- og k›bslinjer med dette moms-id.;
                           ENU=Specifies the VAT percentage that was used on the sales or purchase lines with this VAT Identifier.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT %" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan moms skal beregnes ved k›b eller salg af varer med den aktuelle kombination af momsvirksomheds- og momsproduktbogf›ringsgruppe.;
                           ENU=Specifies how VAT will be calculated for purchases or sales of items with this particular combination of VAT business posting group and VAT product posting group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Calculation Type";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede bel›b for salgs- og k›bslinjer med et bestemt moms-id.;
                           ENU=Specifies the total amount for sales or purchase lines with a specific VAT identifier.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Line Amount";
                AutoFormatType=1;
                AutoFormatExpr=CurrencyCode }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver grundbel›bet for fakturarabatten.;
                           ENU=Specifies the invoice discount base amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inv. Disc. Base Amount";
                AutoFormatType=1;
                AutoFormatExpr=CurrencyCode;
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fakturarabatbel›bet for et bestemt moms-id.;
                           ENU=Specifies the invoice discount amount for a specific VAT identifier.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Invoice Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr=CurrencyCode;
                Visible=FALSE;
                Editable=InvoiceDiscountAmountEditable;
                OnValidate=BEGIN
                             CalcVATFields(CurrencyCode,PricesIncludingVAT,VATBaseDiscPct);
                             ModifyRec;
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede nettobel›b (bel›b ekskl. moms) for salgs- og k›bslinjer med et bestemt moms-id.;
                           ENU=Specifies the total net amount (amount excluding VAT) for sales or purchase lines with a specific VAT Identifier.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Base";
                AutoFormatType=1;
                AutoFormatExpr=CurrencyCode }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsbel›bet, som er inkluderet i totalbel›bet.;
                           ENU=Specifies the amount of VAT that is included in the total amount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Amount";
                AutoFormatType=1;
                AutoFormatExpr=CurrencyCode;
                Editable=VATAmountEditable;
                OnValidate=BEGIN
                             IF AllowVATDifference AND NOT AllowVATDifferenceOnThisTab THEN
                               IF ParentControl = PAGE::"Service Order Statistics" THEN
                                 ERROR(Text000,FIELDCAPTION("VAT Amount"),Text002)
                               ELSE
                                 ERROR(Text000,FIELDCAPTION("VAT Amount"),Text003);

                             IF PricesIncludingVAT THEN
                               "VAT Base" := "Amount Including VAT" - "VAT Amount"
                             ELSE
                               "Amount Including VAT" := "VAT Amount" + "VAT Base";

                             FormCheckVATDifference;
                             ModifyRec;
                           END;
                            }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det beregnede momsbel›b og bruges kun som reference, n†r brugeren ‘ndrer momsbel›bet manuelt.;
                           ENU=Specifies the calculated VAT amount and is only used for reference when the user changes the VAT Amount manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Calculated VAT Amount";
                AutoFormatType=1;
                AutoFormatExpr=CurrencyCode;
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver differencen mellem det beregnede momsbel›b og et momsbel›b, du har angivet manuelt.;
                           ENU=Specifies the difference between the calculated VAT amount and a VAT amount that you have entered manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Difference";
                AutoFormatType=1;
                AutoFormatExpr=CurrencyCode;
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nettobel›bet inklusive moms for denne linje.;
                           ENU=Specifies the net amount, including VAT, for this line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Including VAT";
                AutoFormatType=1;
                AutoFormatExpr=CurrencyCode;
                OnValidate=BEGIN
                             FormCheckVATDifference;
                           END;
                            }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 kan kun ‘ndres under fanen %2.;ENU=%1 can only be modified on the %2 tab.';
      Text001@1001 : TextConst 'DAN=Den samlede %1 for et dokument m† ikke overstige v‘rdien %2 i feltet %3.;ENU=The total %1 for a document must not exceed the value %2 in the %3 field.';
      Currency@1003 : Record 4;
      ServHeader@1011 : Record 5900;
      CurrencyCode@1004 : Code[10];
      AllowVATDifference@1005 : Boolean;
      AllowVATDifferenceOnThisTab@1006 : Boolean;
      PricesIncludingVAT@1007 : Boolean;
      AllowInvDisc@1008 : Boolean;
      VATBaseDiscPct@1009 : Decimal;
      ParentControl@1010 : Integer;
      Text002@1012 : TextConst 'DAN=Detaljer;ENU=Details';
      Text003@1013 : TextConst 'DAN=Fakturering;ENU=Invoicing';
      CurrentTabNo@1002 : Integer;
      MainFormActiveTab@1014 : 'Other,Prepayment';
      VATAmountEditable@19075252 : Boolean INDATASET;
      InvoiceDiscountAmountEditable@19042140 : Boolean INDATASET;

    [External]
    PROCEDURE SetTempVATAmountLine@1(VAR NewVATAmountLine@1000 : Record 290);
    BEGIN
      DELETEALL;
      IF NewVATAmountLine.FIND('-') THEN
        REPEAT
          COPY(NewVATAmountLine);
          INSERT;
        UNTIL NewVATAmountLine.NEXT = 0;
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE GetTempVATAmountLine@5(VAR NewVATAmountLine@1000 : Record 290);
    BEGIN
      NewVATAmountLine.DELETEALL;
      IF FIND('-') THEN
        REPEAT
          NewVATAmountLine.COPY(Rec);
          NewVATAmountLine.INSERT;
        UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE InitGlobals@2(NewCurrencyCode@1000 : Code[10];NewAllowVATDifference@1001 : Boolean;NewAllowVATDifferenceOnThisTab@1002 : Boolean;NewPricesIncludingVAT@1003 : Boolean;NewAllowInvDisc@1004 : Boolean;NewVATBaseDiscPct@1005 : Decimal);
    BEGIN
      CurrencyCode := NewCurrencyCode;
      AllowVATDifference := NewAllowVATDifference;
      AllowVATDifferenceOnThisTab := NewAllowVATDifferenceOnThisTab;
      PricesIncludingVAT := NewPricesIncludingVAT;
      AllowInvDisc := NewAllowInvDisc;
      VATBaseDiscPct := NewVATBaseDiscPct;
      VATAmountEditable := AllowVATDifference;
      InvoiceDiscountAmountEditable := AllowInvDisc;
      IF CurrencyCode = '' THEN
        Currency.InitRoundingPrecision
      ELSE
        Currency.GET(CurrencyCode);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE FormCheckVATDifference@4();
    VAR
      VATAmountLine2@1000 : Record 290;
      TotalVATDifference@1001 : Decimal;
    BEGIN
      CheckVATDifference(CurrencyCode,AllowVATDifference);
      VATAmountLine2 := Rec;
      TotalVATDifference := ABS("VAT Difference") - ABS(xRec."VAT Difference");
      IF FIND('-') THEN
        REPEAT
          TotalVATDifference := TotalVATDifference + ABS("VAT Difference");
        UNTIL NEXT = 0;
      Rec := VATAmountLine2;
      IF TotalVATDifference > Currency."Max. VAT Difference Allowed" THEN
        ERROR(
          Text001,FIELDCAPTION("VAT Difference"),
          Currency."Max. VAT Difference Allowed",Currency.FIELDCAPTION("Max. VAT Difference Allowed"));
    END;

    LOCAL PROCEDURE ModifyRec@3();
    VAR
      ServLine@1000 : Record 5902;
    BEGIN
      Modified := TRUE;
      MODIFY;

      IF ((ParentControl = PAGE::"Service Order Statistics") AND
          (CurrentTabNo <> 1)) OR
         (ParentControl = PAGE::"Service Statistics")
      THEN
        IF GetAnyLineModified THEN BEGIN
          ServLine.UpdateVATOnLines(0,ServHeader,ServLine,Rec);
          ServLine.UpdateVATOnLines(1,ServHeader,ServLine,Rec);
        END;
    END;

    [External]
    PROCEDURE SetParentControl@6(ID@1000 : Integer);
    BEGIN
      ParentControl := ID;
    END;

    [External]
    PROCEDURE SetServHeader@7(ServiceHeader@1000 : Record 5900);
    BEGIN
      ServHeader := ServiceHeader;
    END;

    [External]
    PROCEDURE SetCurrentTabNo@8(TabNo@1000 : Integer);
    BEGIN
      CurrentTabNo := TabNo;
    END;

    BEGIN
    END.
  }
}

