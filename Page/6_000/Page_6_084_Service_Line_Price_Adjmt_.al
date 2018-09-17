OBJECT Page 6084 Service Line Price Adjmt.
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Prisregulering p† servicelinje;
               ENU=Service Line Price Adjmt.];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table6084;
    DataCaptionFields=Document Type,Document No.;
    PageType=Worksheet;
    OnOpenPage=BEGIN
                 OKPressed := FALSE;
               END;

    OnAfterGetRecord=BEGIN
                       UpdateAmounts;
                     END;

    OnQueryClosePage=BEGIN
                       IF CloseAction IN [ACTION::OK,ACTION::LookupOK] THEN
                         OKOnPush;
                       IF NOT OKPressed THEN
                         IF NOT CONFIRM(Text001,FALSE) THEN
                           EXIT(FALSE);
                       EXIT(TRUE);
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 38      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Reguler servicepris;
                                 ENU=Adjust Service Price];
                      ToolTipML=[DAN=Reguler eksisterende servicepriser i henhold til ‘ndrede omkostninger, reservedele og ressourcetidsforbrug. Bem‘rk, at priserne ikke reguleres for serviceartikler, der h›rer til servicekontrakter, serviceartikler med garanti, serviceartikler p† linjer, der er helt eller delvist faktureret. N†r du k›rer serviceprisreguleringen, erstattes alle rabatter i ordren med serviceprisreguleringens v‘rdier.;
                                 ENU=Adjust existing service prices according to changed costs, spare parts, and resource hours. Note that prices are not adjusted for service items that belong to service contracts, service items with a warranty, items service on lines that are partially or fully invoiced. When you run the service price adjustment, all discounts in the order are replaced by the values of the service price adjustment.];
                      ApplicationArea=#Service;
                      Image=PriceAdjustment;
                      OnAction=VAR
                                 ServHeader@1000 : Record 5900;
                                 ServPriceGrSetup@1001 : Record 6081;
                                 ServInvLinePriceAdjmt@1003 : Record 6084;
                                 ServPriceMgmt@1002 : Codeunit 6080;
                               BEGIN
                                 ServHeader.GET("Document Type","Document No.");
                                 ServItemLine.GET("Document Type","Document No.","Service Item Line No.");
                                 ServPriceMgmt.GetServPriceGrSetup(ServPriceGrSetup,ServHeader,ServItemLine);
                                 ServInvLinePriceAdjmt := Rec;
                                 ServPriceMgmt.AdjustLines(ServInvLinePriceAdjmt,ServPriceGrSetup);
                                 UpdateAmounts;
                                 CurrPage.UPDATE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 20  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den serviceartikel, der er registreret i tabellen Serviceartikel.;
                           ENU=Specifies the number of the service item that is registered in the Service Item table.];
                ApplicationArea=#Service;
                SourceExpr="Service Item No.";
                Editable=FALSE }

    { 51  ;2   ;Field     ;
                CaptionML=[DAN=Beskrivelse;
                           ENU=Description];
                ToolTipML=[DAN=Angiver beskrivelsen af den serviceartikel, som prisen skal reguleres for.;
                           ENU=Specifies the description of the service item for which the price is going to be adjusted.];
                ApplicationArea=#Service;
                SourceExpr=ServItemLine.Description;
                Editable=FALSE }

    { 53  ;2   ;Field     ;
                CaptionML=[DAN=Serviceprisgruppekode;
                           ENU=Service Price Group Code];
                ToolTipML=[DAN=Angiver koden for den serviceprisreguleringsgruppe, som er knyttet til serviceartiklen p† linjen.;
                           ENU=Specifies the code of the service price adjustment group associated with the service item on this line.];
                ApplicationArea=#Service;
                SourceExpr="Service Price Group Code";
                Editable=FALSE }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den prisreguleringsgruppe, der er knyttet til den bogf›rte servicelinje.;
                           ENU=Specifies the code of the service price adjustment group that applies to the posted service line.];
                ApplicationArea=#Service;
                SourceExpr="Serv. Price Adjmt. Gr. Code";
                Editable=FALSE }

    { 57  ;2   ;Field     ;
                CaptionML=[DAN=Reguleringstype;
                           ENU=Adjustment Type];
                ToolTipML=[DAN=Angiver reguleringstypen for linjen.;
                           ENU=Specifies the adjustment type for this line.];
                ApplicationArea=#Service;
                SourceExpr="Adjustment Type";
                Editable=FALSE }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for linjen, som kan v‘re Vare, Ressource, Omkostning eller Finanskonto.;
                           ENU=Specifies the type of this line, which can be item, resource, cost, or general ledger Account.];
                ApplicationArea=#Service;
                SourceExpr=Type }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den serviceartikel, ressource eller serviceomkostning, som prisen skal reguleres for.;
                           ENU=Specifies the service item, resource, or service cost, of which the price is going to be adjusted.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘rdien for den serviceartikellinje, der vil blive reguleret.;
                           ENU=Specifies the value of the service line that will be adjusted.];
                ApplicationArea=#Service;
                SourceExpr=Quantity }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Service;
                SourceExpr="Unit Price" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedsprisen for den vare, ressource eller omkostning, der er angivet p† servicelinjen.;
                           ENU=Specifies the unit price of the item, resource, or cost specified on the service line.];
                ApplicationArea=#Service;
                SourceExpr="New Unit Price";
                OnValidate=BEGIN
                             NewUnitPriceOnAfterValidate;
                           END;
                            }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, du vil give af bel›bet p† den tilsvarende servicelinje.;
                           ENU=Specifies the discount percentage you want to provide on the amount on the corresponding service line.];
                ApplicationArea=#Service;
                SourceExpr="Discount %" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabat, du vil give p† bel›bet p† servicelinjen.;
                           ENU=Specifies the discount you want to provide on the amount on this service line.];
                ApplicationArea=#Service;
                SourceExpr="Discount Amount" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede nettobel›b p† servicelinjen.;
                           ENU=Specifies the total net amount on the service line.];
                ApplicationArea=#Service;
                SourceExpr=Amount }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, der skal faktureres.;
                           ENU=Specifies the amount to invoice.];
                ApplicationArea=#Service;
                SourceExpr="New Amount";
                OnValidate=BEGIN
                             NewAmountOnAfterValidate;
                           END;
                            }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede bel›b, som servicelinjen skal reguleres med, inklusive moms.;
                           ENU=Specifies the total amount that the service line is going to be adjusted, including VAT.];
                ApplicationArea=#Service;
                SourceExpr="Amount incl. VAT" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nyt bel›b inkl. moms.;
                           ENU=Specifies a new amount, including VAT.];
                ApplicationArea=#Service;
                SourceExpr="New Amount incl. VAT";
                OnValidate=BEGIN
                             NewAmountinclVATOnAfterValidat;
                           END;
                            }

    { 2   ;1   ;Group      }

    { 1900116601;2;Group  ;
                GroupType=FixedLayout }

    { 1900295901;3;Group  ;
                CaptionML=[DAN=I alt;
                           ENU=Total] }

    { 5   ;4   ;Field     ;
                CaptionML=[DAN=Bel›b;
                           ENU=Amount];
                ToolTipML=[DAN=Angiver det samlede bel›b, som servicelinjerne reguleres efter.;
                           ENU=Specifies the total amount that the service lines will be adjusted to.];
                ApplicationArea=#Service;
                SourceExpr=TotalAmount;
                Editable=FALSE }

    { 1900725601;3;Group  ;
                CaptionML=[DAN=Regulering;
                           ENU=To Adjust] }

    { 7   ;4   ;Field     ;
                CaptionML=[DAN=Regulering;
                           ENU=To Adjust];
                ToolTipML=[DAN=Angiver det samlede bel›b for de servicelinjer, der skal reguleres.;
                           ENU=Specifies the total value of the service lines that need to be adjusted.];
                ApplicationArea=#Service;
                SourceExpr=AmountToAdjust;
                Editable=FALSE }

    { 1900724401;3;Group  ;
                CaptionML=[DAN=Resterende;
                           ENU=Remaining] }

    { 3   ;4   ;Field     ;
                CaptionML=[DAN=Resterende;
                           ENU=Remaining];
                ToolTipML=[DAN=Angiver differencen mellem det samlede bel›b, som servicelinjerne reguleres for, og den faktiske samlede v‘rdi for servicelinjerne.;
                           ENU=Specifies the difference between the total amount that the service lines will be adjusted to, and actual total value of the service lines.];
                ApplicationArea=#Service;
                SourceExpr=Remaining;
                Editable=FALSE }

    { 1900206001;3;Group  ;
                CaptionML=[DAN=Inkl. moms;
                           ENU=Incl. VAT] }

    { 42  ;4   ;Field     ;
                CaptionML=[DAN=Inkl. moms;
                           ENU=Incl. VAT];
                ToolTipML=[DAN=Angiver, at bel›bet for servicelinjerne inkluderer moms.;
                           ENU=Specifies that the amount of the service lines includes VAT.];
                ApplicationArea=#Service;
                SourceExpr=InclVat;
                Editable=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ServItemLine@1000 : Record 5901;
      ServInvLinePriceAdjmt@1004 : Record 6084;
      TotalAmount@1001 : Decimal;
      AmountToAdjust@1002 : Decimal;
      Remaining@1003 : Decimal;
      InclVat@1005 : Boolean;
      OKPressed@1006 : Boolean;
      Text001@1007 : TextConst 'DAN=Skal prisreguleringen annulleres?;ENU=Cancel price adjustment?';

    [External]
    PROCEDURE SetVars@1(SetTotalAmount@1000 : Decimal;SetInclVat@1001 : Boolean);
    BEGIN
      TotalAmount := SetTotalAmount;
      InclVat := SetInclVat;
    END;

    [External]
    PROCEDURE UpdateAmounts@3();
    BEGIN
      IF NOT ServItemLine.GET("Document Type","Document No.","Service Item Line No.") THEN
        CLEAR(ServItemLine);
      ServInvLinePriceAdjmt := Rec;
      ServInvLinePriceAdjmt.RESET;
      ServInvLinePriceAdjmt.SETRANGE("Document Type","Document Type");
      ServInvLinePriceAdjmt.SETRANGE("Document No.","Document No.");
      ServInvLinePriceAdjmt.SETRANGE("Service Item Line No.","Service Item Line No.");
      ServInvLinePriceAdjmt.CALCSUMS("New Amount","New Amount incl. VAT","New Amount Excl. VAT");
      IF InclVat THEN BEGIN
        AmountToAdjust := ServInvLinePriceAdjmt."New Amount incl. VAT";
        Remaining := TotalAmount - ServInvLinePriceAdjmt."New Amount incl. VAT";
      END ELSE BEGIN
        AmountToAdjust := ServInvLinePriceAdjmt."New Amount Excl. VAT";
        Remaining := TotalAmount - ServInvLinePriceAdjmt."New Amount Excl. VAT";
      END;
    END;

    LOCAL PROCEDURE NewUnitPriceOnAfterValidate@19017697();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE NewAmountOnAfterValidate@19019893();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE NewAmountinclVATOnAfterValidat@19061003();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE OKOnPush@19066895();
    BEGIN
      OKPressed := TRUE;
    END;

    BEGIN
    END.
  }
}

