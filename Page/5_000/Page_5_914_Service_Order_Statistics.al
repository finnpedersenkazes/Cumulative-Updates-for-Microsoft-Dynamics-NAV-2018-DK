OBJECT Page 5914 Service Order Statistics
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Serviceordrestatistik;
               ENU=Service Order Statistics];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5900;
    PageType=Card;
    OnOpenPage=BEGIN
                 SalesSetup.GET;
                 AllowInvDisc := NOT (SalesSetup."Calc. Inv. Discount" AND CustInvDiscRecExists("Invoice Disc. Code"));
                 AllowVATDifference :=
                   SalesSetup."Allow VAT Difference" AND
                   ("Document Type" <> "Document Type"::Quote);
                 VATLinesFormIsEditable := AllowVATDifference OR AllowInvDisc;
                 CurrPage.EDITABLE := VATLinesFormIsEditable;
               END;

    OnAfterGetRecord=VAR
                       ServLine@1000 : Record 5902;
                       TempServLine@1001 : TEMPORARY Record 5902;
                     BEGIN
                       CurrPage.CAPTION(STRSUBSTNO(Text000,"Document Type"));

                       IF PrevNo = "No." THEN
                         EXIT;
                       PrevNo := "No.";
                       FILTERGROUP(2);
                       SETRANGE("No.",PrevNo);
                       FILTERGROUP(0);

                       CLEAR(ServLine);
                       CLEAR(TotalServLine);
                       CLEAR(TotalServLineLCY);
                       CLEAR(ServAmtsMgt);

                       FOR i := 1 TO 7 DO BEGIN
                         TempServLine.DELETEALL;
                         CLEAR(TempServLine);
                         ServAmtsMgt.GetServiceLines(Rec,TempServLine,i - 1);

                         CASE i OF
                           1:
                             ServLine.CalcVATAmountLines(0,Rec,TempServLine,TempVATAmountLine1,FALSE);
                           2:
                             ServLine.CalcVATAmountLines(0,Rec,TempServLine,TempVATAmountLine2,FALSE);
                           3:
                             ServLine.CalcVATAmountLines(0,Rec,TempServLine,TempVATAmountLine3,FALSE);
                         END;

                         ServAmtsMgt.SumServiceLinesTemp(
                           Rec,TempServLine,i - 1,TotalServLine[i],TotalServLineLCY[i],
                           VATAmount[i],VATAmountText[i],ProfitLCY[i],ProfitPct[i],TotalAdjCostLCY[i]);
                         ProfitLCY[i] := MakeNegativeZero(ProfitLCY[i]);

                         IF i = 3 THEN
                           TotalAdjCostLCY[i] := TotalServLineLCY[i]."Unit Cost (LCY)";

                         IF TotalServLineLCY[i].Amount = 0 THEN
                           ProfitPct[i] := 0
                         ELSE
                           ProfitPct[i] := ROUND(100 * ProfitLCY[i] / TotalServLineLCY[i].Amount,0.1);

                         AdjProfitLCY[i] := TotalServLineLCY[i].Amount - TotalAdjCostLCY[i];
                         AdjProfitLCY[i] := MakeNegativeZero(AdjProfitLCY[i]);
                         IF TotalServLineLCY[i].Amount <> 0 THEN
                           AdjProfitPct[i] := ROUND(100 * AdjProfitLCY[i] / TotalServLineLCY[i].Amount,0.1);

                         IF "Prices Including VAT" THEN BEGIN
                           TotalAmount2[i] := TotalServLine[i].Amount;
                           TotalAmount1[i] := TotalAmount2[i] + VATAmount[i];
                           TotalServLine[i]."Line Amount" := TotalAmount1[i] + TotalServLine[i]."Inv. Discount Amount";
                         END ELSE BEGIN
                           TotalAmount1[i] := TotalServLine[i].Amount;
                           TotalAmount2[i] := TotalServLine[i]."Amount Including VAT";
                         END;
                       END;

                       IF Cust.GET("Bill-to Customer No.") THEN
                         Cust.CALCFIELDS("Balance (LCY)")
                       ELSE
                         CLEAR(Cust);

                       CASE TRUE OF
                         Cust."Credit Limit (LCY)" = 0:
                           CreditLimitLCYExpendedPct := 0;
                         Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0:
                           CreditLimitLCYExpendedPct := 0;
                         Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1:
                           CreditLimitLCYExpendedPct := 10000;
                         ELSE
                           CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000,1);
                       END;

                       TempVATAmountLine1.MODIFYALL(Modified,FALSE);
                       TempVATAmountLine2.MODIFYALL(Modified,FALSE);
                       TempVATAmountLine3.MODIFYALL(Modified,FALSE);

                       PrevTab := -1;
                     END;

    OnQueryClosePage=BEGIN
                       GetVATSpecification(PrevTab);
                       IF TempVATAmountLine1.GetAnyLineModified OR TempVATAmountLine2.GetAnyLineModified THEN
                         UpdateVATOnServLines;
                       EXIT(TRUE);
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 39  ;2   ;Field     ;
                Name=Amount_General;
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[1]."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text002,FALSE);
                Editable=FALSE }

    { 30  ;2   ;Field     ;
                Name=Inv. Discount Amount_General;
                CaptionML=[DAN=Fakturarabatbel�b;
                           ENU=Inv. Discount Amount];
                ToolTipML=[DAN=Angiver fakturarabatbel�bet for hele serviceordren.;
                           ENU=Specifies the invoice discount amount for the entire service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[1]."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                OnValidate=BEGIN
                             ActiveTab := ActiveTab::General;
                             UpdateInvDiscAmount(1);
                           END;
                            }

    { 20  ;2   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount1[1];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,FALSE);
                OnValidate=BEGIN
                             ActiveTab := ActiveTab::General;
                             UpdateTotalAmount(1);
                           END;
                            }

    { 16  ;2   ;Field     ;
                Name=VAT Amount_General;
                CaptionML=[DAN=Momsbel�b;
                           ENU=VAT Amount];
                ToolTipML=[DAN=Angiver det samlede momsbel�b, der er beregnet for alle linjer i serviceordren.;
                           ENU=Specifies the total VAT amount that has been calculated for all the lines in the service order.];
                ApplicationArea=#Service;
                SourceExpr=VATAmount[1];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=FORMAT(VATAmountText[1]);
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                Name=Total Incl. VAT_General;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount2[1];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,TRUE);
                Editable=FALSE;
                OnValidate=BEGIN
                             TotalAmount21OnAfterValidate;
                           END;
                            }

    { 7   ;2   ;Field     ;
                Name=Sales (LCY)_General;
                CaptionML=[DAN=Salg (RV);
                           ENU=Sales (LCY)];
                ToolTipML=[DAN=Angiver den samlede servicesalgsoms�tning i regnskabs�ret. Den beregnes ud fra bel�bene, ekskl. moms, p� alle afsluttede og �bne servicesalgsfakturaer og -kreditnotaer.;
                           ENU=Specifies your total service sales turnover in the fiscal year. It is calculated from amounts excluding VAT on all completed and open service sales invoices and credit memos.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[1].Amount;
                AutoFormatType=1;
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                CaptionML=[DAN=Oprindeligt avancebel�b (RV);
                           ENU=Original Profit (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b, i RV, for finanskontoposter, omkostninger, varer og/eller ressourcer i serviceorden. Kostbel�bet beregnes som et produkt af kostprisen multipliceret med antallet af den relevante vare eller ressource.;
                           ENU=Specifies the total cost, in LCY, of the G/L account entries, costs, items and/or resources in the service order. The cost is calculated as a product of unit cost multiplied by quantity of the relevant items or resources.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[1];
                AutoFormatType=1;
                Editable=FALSE }

    { 135 ;2   ;Field     ;
                CaptionML=[DAN=Justeret avancebel�b (RV);
                           ENU=Adjusted Profit (LCY)];
                ToolTipML=[DAN=Angiver avancebel�bet for serviceordren, i RV, justeret for evt. �ndringer i de oprindelige varepriser.;
                           ENU=Specifies the amount of profit for the service order, in LCY, adjusted for any changes in the original item costs.];
                ApplicationArea=#Service;
                SourceExpr=AdjProfitLCY[1];
                AutoFormatType=1;
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                CaptionML=[DAN=Oprindelig avance i %;
                           ENU=Original Profit %];
                ToolTipML=[DAN=Angiver avanceprocentdelen f�r evt. vareprisreguleringer af serviceordren.;
                           ENU=Specifies the profit percentage prior to any item cost adjustments on the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=ProfitPct[1];
                Editable=FALSE }

    { 137 ;2   ;Field     ;
                CaptionML=[DAN=Justeret avance i %;
                           ENU=Adjusted Profit %];
                ToolTipML=[DAN=Angiver bel�bet i den regulerede avance i serviceordren udtrykt som en procentdel af bel�bet i feltet Bel�b ekskl. moms (Bel�b inkl. moms).;
                           ENU=Specifies the amount of the adjusted profit on the service order, expressed as percentage of the amount in the Amount Excl. VAT (Amount Incl. VAT) field.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=AdjProfitPct[1];
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m�ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[1].Quantity;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Kolli;
                           ENU=Parcels];
                ToolTipML=[DAN=Angiver antallet af alle kolli i de varer, der er angivet p� servicelinjerne i ordren.;
                           ENU=Specifies the quantity of parcels of the items specified on the service lines in the order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[1]."Units per Parcel";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Nettov�gt;
                           ENU=Net Weight];
                ToolTipML=[DAN=Angiver nettov�gten af de varer, der er angivet p� servicelinjerne i ordren.;
                           ENU=Specifies the net weight of the items specified on the service lines in the order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[1]."Net Weight";
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                CaptionML=[DAN=Bruttov�gt;
                           ENU=Gross Weight];
                ToolTipML=[DAN=Angiver bruttov�gten af varerne p� servicelinjerne i ordren.;
                           ENU=Specifies the gross weight of the items on the service lines in the order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[1]."Gross Weight";
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Rumfang;
                           ENU=Volume];
                ToolTipML=[DAN=Angiver volumen af varerne p� servicelinjerne i ordren.;
                           ENU=Specifies the volume of the items on the service lines in the order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[1]."Unit Volume";
                Editable=FALSE }

    { 37  ;2   ;Field     ;
                Name=OriginalCostLCY;
                CaptionML=[DAN=Oprindeligt kostbel�b (RV);
                           ENU=Original Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b, i RV, for finanskontoposter, omkostninger, varer og/eller ressourcer i serviceorden. Kostbel�bet beregnes som et produkt af kostprisen multipliceret med antallet af den relevante vare.;
                           ENU=Specifies the total cost, in LCY, of the G/L account entries, costs, items and/or resources in the service order. The cost is calculated as a product of unit cost multiplied by quantity of the relevant items.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[1]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 141 ;2   ;Field     ;
                Name=AdjustedCostLCY;
                CaptionML=[DAN=Justerede omkostninger (RV);
                           ENU=Adjusted Cost (LCY)];
                ToolTipML=[DAN=Angiver de samlede omkostninger i RV for varerne i serviceordren, justeret s� der er taget h�jde for evt. �ndringer i de oprindelige omkostninger for disse varer.;
                           ENU=Specifies the total cost, in LCY, of the items in the service order, adjusted for any changes in the original costs of these items];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[1];
                AutoFormatType=1;
                Editable=FALSE }

    { 139 ;2   ;Field     ;
                CaptionML=[DAN=Overd�kningsbel�b (RV);
                           ENU=Cost Adjmt. Amount (LCY)];
                ToolTipML=[DAN=Angiver forskellen mellem de oprindelige omkostninger og den samlede regulerede kostpris for varerne i serviceordren.;
                           ENU=Specifies the difference between the original cost and the total adjusted cost of the items in the service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[1] - TotalServLineLCY[1]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE;
                OnLookup=BEGIN
                           LookupAdjmtValueEntries(0);
                         END;
                          }

    { 1102601000;2;Field  ;
                Name=No. of VAT Lines_General;
                DrillDown=Yes;
                CaptionML=[DAN=Antal momslinjer;
                           ENU=No. of VAT Lines];
                ToolTipML=[DAN=Angiver nummeret p� de serviceordrelinjer, der er tilknyttet momspostlinjen.;
                           ENU=Specifies the number of service order lines that are associated with the VAT ledger line.];
                ApplicationArea=#Service;
                SourceExpr=TempVATAmountLine1.COUNT;
                OnDrillDown=BEGIN
                              VATLinesDrillDown(TempVATAmountLine1,FALSE);
                              UpdateHeaderInfo(1,TempVATAmountLine1);
                            END;
                             }

    { 1901902601;1;Group  ;
                CaptionML=[DAN=Detaljer;
                           ENU=Details] }

    { 1904230801;2;Group  ;
                GroupType=FixedLayout }

    { 1905623601;3;Group  ;
                CaptionML=[DAN=Fakturering;
                           ENU=Invoicing] }

    { 166 ;4   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m�ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[2].Quantity;
                Editable=FALSE }

    { 156 ;4   ;Field     ;
                Name=Amount_Invoicing;
                CaptionML=[DAN=Bel�b;
                           ENU=Amount];
                ToolTipML=[DAN=Angiver bel�bet for den relevante serviceordre.;
                           ENU=Specifies the amount for the relevant service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[2]."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 153 ;4   ;Field     ;
                Name=Inv. Discount Amount_Invoicing;
                CaptionML=[DAN=Fakturarabatbel�b;
                           ENU=Inv. Discount Amount];
                ToolTipML=[DAN=Angiver fakturarabatbel�bet for hele serviceordren.;
                           ENU=Specifies the invoice discount amount for the entire service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[2]."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                OnValidate=BEGIN
                             ActiveTab := ActiveTab::Details;
                             UpdateInvDiscAmount(2);
                           END;
                            }

    { 150 ;4   ;Field     ;
                Name=Total;
                CaptionML=[DAN=I alt;
                           ENU=Total];
                ToolTipML=[DAN=Angiver det samlede bel�b.;
                           ENU=Specifies the total amount.];
                ApplicationArea=#Service;
                SourceExpr=TotalAmount1[2];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                OnValidate=BEGIN
                             ActiveTab := ActiveTab::Details;
                             UpdateTotalAmount(2);
                           END;
                            }

    { 147 ;4   ;Field     ;
                Name=VAT Amount_Invoicing;
                CaptionML=[DAN=Momsbel�b;
                           ENU=VAT Amount];
                ToolTipML=[DAN=Angiver det samlede momsbel�b, der er beregnet for alle linjer i serviceordren.;
                           ENU=Specifies the total VAT amount that has been calculated for all the lines in the service order.];
                ApplicationArea=#Service;
                SourceExpr=VATAmount[2];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 144 ;4   ;Field     ;
                Name=Total Incl. VAT_Invoicing;
                CaptionML=[DAN=I alt;
                           ENU=Total Amount];
                ToolTipML=[DAN=Angiver de samlede bel�b i serviceordren, der er resultatet, n�r faktureringsbel�bene l�gges sammen med forbrugsbel�bene.;
                           ENU=Specifies the total amounts on the service order that result from adding the invoicing amounts to the consuming amounts.];
                ApplicationArea=#Service;
                SourceExpr=TotalAmount2[2];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 117 ;4   ;Field     ;
                Name=Sales (LCY)_Invoicing;
                CaptionML=[DAN=Salg (RV);
                           ENU=Sales (LCY)];
                ToolTipML=[DAN=Angiver den samlede servicesalgsoms�tning i regnskabs�ret. Den beregnes ud fra bel�bene, ekskl. moms, p� alle afsluttede og �bne servicesalgsfakturaer og -kreditnotaer.;
                           ENU=Specifies your total service sales turnover in the fiscal year. It is calculated from amounts excluding VAT on all completed and open service sales invoices and credit memos.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[2].Amount;
                AutoFormatType=1;
                Editable=FALSE }

    { 107 ;4   ;Field     ;
                CaptionML=[DAN=Oprindeligt avancebel�b (RV);
                           ENU=Original Profit (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b, i RV, for finanskontoposter, omkostninger, varer og/eller ressourcer i serviceorden. Kostbel�bet beregnes som et produkt af kostprisen multipliceret med antallet af den relevante vare eller ressource.;
                           ENU=Specifies the total cost, in LCY, of the G/L account entries, costs, items and/or resources in the service order. The cost is calculated as a product of unit cost multiplied by quantity of the relevant items or resources.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[2];
                AutoFormatType=1;
                Editable=FALSE }

    { 104 ;4   ;Field     ;
                CaptionML=[DAN=Justeret avancebel�b (RV);
                           ENU=Adjusted Profit (LCY)];
                ToolTipML=[DAN=Angiver avancebel�bet for serviceordren, i RV, justeret for evt. �ndringer i de oprindelige varepriser.;
                           ENU=Specifies the amount of profit for the service order, in LCY, adjusted for any changes in the original item costs.];
                ApplicationArea=#Service;
                SourceExpr=AdjProfitLCY[2];
                AutoFormatType=1;
                Editable=FALSE }

    { 102 ;4   ;Field     ;
                CaptionML=[DAN=Oprindelig avance i %;
                           ENU=Original Profit %];
                ToolTipML=[DAN=Angiver avanceprocentdelen f�r evt. vareprisreguleringer af serviceordren.;
                           ENU=Specifies the profit percentage prior to any item cost adjustments on the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=ProfitPct[2];
                Editable=FALSE }

    { 105 ;4   ;Field     ;
                CaptionML=[DAN=Justeret avance i %;
                           ENU=Adjusted Profit %];
                ToolTipML=[DAN=Angiver bel�bet i den regulerede avance i serviceordren udtrykt som en procentdel af bel�bet i feltet Bel�b ekskl. moms (Bel�b inkl. moms).;
                           ENU=Specifies the amount of the adjusted profit on the service order, expressed as percentage of the amount in the Amount Excl. VAT (Amount Incl. VAT) field.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=AdjProfitPct[2];
                Editable=FALSE }

    { 99  ;4   ;Field     ;
                CaptionML=[DAN=Oprindeligt kostbel�b (RV);
                           ENU=Original Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b, i RV, for finanskontoposter, omkostninger, varer og/eller ressourcer i serviceorden. Kostbel�bet beregnes som et produkt af kostprisen multipliceret med antallet af den relevante vare eller ressource.;
                           ENU=Specifies the total cost, in LCY, of the G/L account entries, costs, items and/or resources in the service order. The cost is calculated as a product of unit cost multiplied by quantity of the relevant items or resources.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[2]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 101 ;4   ;Field     ;
                CaptionML=[DAN=Justerede omkostninger (RV);
                           ENU=Adjusted Cost (LCY)];
                ToolTipML=[DAN=Angiver de samlede omkostninger i RV for varerne i serviceordren, justeret s� der er taget h�jde for evt. �ndringer i de oprindelige omkostninger for disse varer.;
                           ENU=Specifies the total cost, in LCY, of the items in the service order, adjusted for any changes in the original costs of these items];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[2];
                AutoFormatType=1;
                Editable=FALSE }

    { 100 ;4   ;Field     ;
                CaptionML=[DAN=Overd�kningsbel�b (RV);
                           ENU=Cost Adjmt. Amount (LCY)];
                ToolTipML=[DAN=Angiver forskellen mellem de oprindelige omkostninger og den samlede regulerede kostpris for varerne i serviceordren.;
                           ENU=Specifies the difference between the original cost and the total adjusted cost of the items in the service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[2] - TotalServLineLCY[2]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE;
                OnLookup=BEGIN
                           LookupAdjmtValueEntries(1);
                         END;
                          }

    { 1901770501;3;Group  ;
                CaptionML=[DAN=Forbrug;
                           ENU=Consuming] }

    { 165 ;4   ;Field     ;
                Name=Quantity_Consuming;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m�ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[4].Quantity;
                Editable=FALSE }

    { 45  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 46  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 47  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 48  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 49  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 50  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 109 ;4   ;Field     ;
                CaptionML=[DAN=Oprindeligt avancebel�b (RV);
                           ENU=Original Profit (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b, i RV, for finanskontoposter, omkostninger, varer og/eller ressourcer i serviceorden. Kostbel�bet beregnes som et produkt af kostprisen multipliceret med antallet af den relevante vare eller ressource.;
                           ENU=Specifies the total cost, in LCY, of the G/L account entries, costs, items and/or resources in the service order. The cost is calculated as a product of unit cost multiplied by quantity of the relevant items or resources.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[4];
                AutoFormatType=1;
                Editable=FALSE }

    { 106 ;4   ;Field     ;
                CaptionML=[DAN=Justeret avancebel�b (RV);
                           ENU=Adjusted Profit (LCY)];
                ToolTipML=[DAN=Angiver avancebel�bet for serviceordren, i RV, justeret for evt. �ndringer i de oprindelige varepriser.;
                           ENU=Specifies the amount of profit for the service order, in LCY, adjusted for any changes in the original item costs.];
                ApplicationArea=#Service;
                SourceExpr=AdjProfitLCY[4];
                AutoFormatType=1;
                Editable=FALSE }

    { 98  ;4   ;Field     ;
                CaptionML=[DAN=Oprindelig avance i %;
                           ENU=Original Profit %];
                ToolTipML=[DAN=Angiver bel�bet i den oprindelige avance for serviceordren (i RV) f�r en evt. vareprisregulering. Bel�bet beregnes i programmet som forskellen mellem v�rdierne i felterne Bel�b ekskl. moms (Bel�b inkl. moms) og Oprindeligt kostbel�b (RV).;
                           ENU=Specifies the amount of original profit for the service order (in LCY), prior to any item cost adjustment. The program calculates the amount as the difference between the values in the Amount Excl. VAT (Amount Incl. VAT) and the Original Cost (LCY) fields.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=ProfitPct[4];
                Editable=FALSE }

    { 96  ;4   ;Field     ;
                CaptionML=[DAN=Justeret avance i %;
                           ENU=Adjusted Profit %];
                ToolTipML=[DAN=Angiver bel�bet i den regulerede avance i serviceordren udtrykt som en procentdel af bel�bet i feltet Bel�b ekskl. moms (Bel�b inkl. moms).;
                           ENU=Specifies the amount of the adjusted profit on the service order, expressed as percentage of the amount in the Amount Excl. VAT (Amount Incl. VAT) field.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=AdjProfitPct[4];
                Editable=FALSE }

    { 92  ;4   ;Field     ;
                CaptionML=[DAN=Kostbel�b (RV);
                           ENU=Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b i RV.;
                           ENU=Specifies the total cost of the service in LCY.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[4]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 94  ;4   ;Field     ;
                CaptionML=[DAN=Justerede omkostninger (RV);
                           ENU=Adjusted Cost (LCY)];
                ToolTipML=[DAN=Angiver de samlede omkostninger i RV for varerne i serviceordren, justeret s� der er taget h�jde for evt. �ndringer i de oprindelige omkostninger for disse varer.;
                           ENU=Specifies the total cost, in LCY, of the items in the service order, adjusted for any changes in the original costs of these items];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[4];
                AutoFormatType=1;
                Editable=FALSE }

    { 93  ;4   ;Field     ;
                CaptionML=[DAN=Justeringsomkostning (RV);
                           ENU=Adjustment Cost (LCY)];
                ToolTipML=[DAN=Angiver de samlede omkostninger i RV for varerne i serviceordren, justeret s� der er taget h�jde for evt. �ndringer i de oprindelige omkostninger for disse varer.;
                           ENU=Specifies the total cost, in LCY, of the items in the service order, adjusted for any changes in the original costs of these items.];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[4] - TotalServLineLCY[4]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE;
                OnLookup=BEGIN
                           LookupAdjmtValueEntries(1);
                         END;
                          }

    { 1906106001;3;Group  ;
                CaptionML=[DAN=I alt;
                           ENU=Total] }

    { 168 ;4   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m�ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[2].Quantity + TotalServLine[4].Quantity;
                Editable=FALSE }

    { 162 ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[2]."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text002,FALSE);
                Editable=FALSE }

    { 155 ;4   ;Field     ;
                CaptionML=[DAN=Fakturarabatbel�b;
                           ENU=Inv. Discount Amount];
                ToolTipML=[DAN=Angiver fakturarabatbel�bet for hele serviceordren.;
                           ENU=Specifies the invoice discount amount for the entire service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[2]."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE;
                OnValidate=BEGIN
                             ActiveTab := ActiveTab::Details;
                             UpdateInvDiscAmount(2);
                           END;
                            }

    { 152 ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount1[2];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,FALSE);
                Editable=FALSE;
                OnValidate=BEGIN
                             ActiveTab := ActiveTab::Details;
                             UpdateTotalAmount(2);
                           END;
                            }

    { 149 ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=VATAmount[2];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE;
                ShowCaption=No }

    { 146 ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount2[2];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,TRUE);
                Editable=FALSE }

    { 143 ;4   ;Field     ;
                CaptionML=[DAN=Bel�b (RV);
                           ENU=Amount (LCY)];
                ToolTipML=[DAN=Angiver bel�bet i finansposten i den lokale valuta.;
                           ENU=Specifies the amount of the ledger entry, in the local currency.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[2].Amount;
                AutoFormatType=1;
                Editable=FALSE }

    { 108 ;4   ;Field     ;
                CaptionML=[DAN=Avancebel�b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver den avance, der er relateret til serviceordren, i den lokale valuta.;
                           ENU=Specifies the profit related to the service order, in local currency.];
                ApplicationArea=#Service;
                SourceExpr=AdjProfitLCY[2] + AdjProfitLCY[4];
                AutoFormatType=1;
                Editable=FALSE }

    { 103 ;4   ;Field     ;
                CaptionML=[DAN=Avancebel�b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver den avance, der er relateret til serviceordren, i den lokale valuta.;
                           ENU=Specifies the profit related to the service order, in local currency.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[2] + ProfitLCY[4];
                AutoFormatType=1;
                Editable=FALSE }

    { 97  ;4   ;Field     ;
                CaptionML=[DAN=Avancepct.;
                           ENU=Profit %];
                ToolTipML=[DAN=Angiver den procentdel af avancen, der er relateret til serviceordren.;
                           ENU=Specifies the percent of profit related to the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=GetDetailsTotal;
                Editable=FALSE }

    { 95  ;4   ;Field     ;
                CaptionML=[DAN=Avancepct.;
                           ENU=Profit %];
                ToolTipML=[DAN=Angiver den procentdel af avancen, der er relateret til serviceordren.;
                           ENU=Specifies the percent of profit related to the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=GetAdjDetailsTotal;
                Editable=FALSE }

    { 91  ;4   ;Field     ;
                CaptionML=[DAN=Kostbel�b (RV);
                           ENU=Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b i RV.;
                           ENU=Specifies the total cost of the service in LCY.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[2]."Unit Cost (LCY)" + TotalServLineLCY[4]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 90  ;4   ;Field     ;
                CaptionML=[DAN=Kostbel�b (RV);
                           ENU=Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b i RV.;
                           ENU=Specifies the total cost of the service in LCY.];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[2] + TotalAdjCostLCY[4];
                AutoFormatType=1;
                Editable=FALSE }

    { 89  ;4   ;Field     ;
                Name=DetailedTotalLCYCost;
                CaptionML=[DAN=Kostbel�b (RV);
                           ENU=Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b i RV.;
                           ENU=Specifies the total cost of the service in LCY.];
                ApplicationArea=#Service;
                SourceExpr=(TotalAdjCostLCY[2] - TotalServLineLCY[2]."Unit Cost (LCY)") + (TotalAdjCostLCY[4] - TotalServLineLCY[4]."Unit Cost (LCY)");
                AutoFormatType=1;
                Editable=FALSE }

    { 1906801201;1;Group  ;
                CaptionML=[DAN=Levering;
                           ENU=Shipping] }

    { 190 ;2   ;Field     ;
                Name=Amount_Shipping;
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[3]."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text002,FALSE);
                Editable=FALSE }

    { 187 ;2   ;Field     ;
                Name=Inv. Discount Amount_Shipping;
                CaptionML=[DAN=Fakturarabatbel�b;
                           ENU=Inv. Discount Amount];
                ToolTipML=[DAN=Angiver fakturarabatbel�bet for hele serviceordren.;
                           ENU=Specifies the invoice discount amount for the entire service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[3]."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 186 ;2   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount1[3];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,FALSE);
                Editable=FALSE }

    { 185 ;2   ;Field     ;
                Name=VAT Amount_Shipping;
                ApplicationArea=#Service;
                SourceExpr=VATAmount[3];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=FORMAT(VATAmountText[3]);
                Editable=FALSE }

    { 184 ;2   ;Field     ;
                Name=Total Incl. VAT_Shipping;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount2[3];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,TRUE);
                Editable=FALSE }

    { 43  ;2   ;Field     ;
                Name=Sales (LCY)_Shipping;
                CaptionML=[DAN=Salg (RV);
                           ENU=Sales (LCY)];
                ToolTipML=[DAN=Angiver den samlede servicesalgsoms�tning i regnskabs�ret. Den beregnes ud fra bel�bene, ekskl. moms, p� alle afsluttede og �bne servicesalgsfakturaer og -kreditnotaer.;
                           ENU=Specifies your total service sales turnover in the fiscal year. It is calculated from amounts excluding VAT on all completed and open service sales invoices and credit memos.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[3].Amount;
                AutoFormatType=1;
                Editable=FALSE }

    { 41  ;2   ;Field     ;
                CaptionML=[DAN=Kostbel�b (RV);
                           ENU=Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b i RV.;
                           ENU=Specifies the total cost of the service in LCY.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[3]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 35  ;2   ;Field     ;
                CaptionML=[DAN=Avancebel�b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver den avance, der er relateret til serviceordren, i den lokale valuta.;
                           ENU=Specifies the profit related to the service order, in local currency.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[3];
                AutoFormatType=1;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Avancepct.;
                           ENU=Profit %];
                ToolTipML=[DAN=Angiver den procentdel af avancen, der er relateret til serviceordren.;
                           ENU=Specifies the percent of profit related to the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=ProfitPct[3];
                Editable=FALSE }

    { 188 ;2   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m�ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[3].Quantity;
                Editable=FALSE }

    { 182 ;2   ;Field     ;
                CaptionML=[DAN=Kolli;
                           ENU=Parcels];
                ToolTipML=[DAN=Angiver antallet af alle kolli i de varer, der er angivet p� servicelinjerne i ordren.;
                           ENU=Specifies the quantity of parcels of the items specified on the service lines in the order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[3]."Units per Parcel";
                Editable=FALSE }

    { 180 ;2   ;Field     ;
                CaptionML=[DAN=Nettov�gt;
                           ENU=Net Weight];
                ToolTipML=[DAN=Angiver nettov�gten af de varer, der er angivet p� servicelinjerne i ordren.;
                           ENU=Specifies the net weight of the items specified on the service lines in the order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[3]."Net Weight";
                Editable=FALSE }

    { 178 ;2   ;Field     ;
                CaptionML=[DAN=Bruttov�gt;
                           ENU=Gross Weight];
                ToolTipML=[DAN=Angiver bruttov�gten af varerne p� servicelinjerne i ordren.;
                           ENU=Specifies the gross weight of the items on the service lines in the order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[3]."Gross Weight";
                Editable=FALSE }

    { 172 ;2   ;Field     ;
                CaptionML=[DAN=Rumfang;
                           ENU=Volume];
                ToolTipML=[DAN=Angiver volumen af varerne p� servicelinjerne i ordren.;
                           ENU=Specifies the volume of the items on the service lines in the order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[3]."Unit Volume";
                Editable=FALSE }

    { 1102601002;2;Field  ;
                Name=No. of VAT Lines_Shipping;
                DrillDown=Yes;
                CaptionML=[DAN=Antal momslinjer;
                           ENU=No. of VAT Lines];
                ToolTipML=[DAN=Angiver nummeret p� de serviceordrelinjer, der er tilknyttet momspostlinjen.;
                           ENU=Specifies the number of service order lines that are associated with the VAT ledger line.];
                ApplicationArea=#Service;
                SourceExpr=TempVATAmountLine3.COUNT;
                OnDrillDown=BEGIN
                              VATLinesDrillDown(TempVATAmountLine3,FALSE);
                            END;
                             }

    { 1903781401;1;Group  ;
                CaptionML=[DAN=Servicelinje;
                           ENU=Service Line] }

    { 1903442601;2;Group  ;
                GroupType=FixedLayout }

    { 1903866501;3;Group  ;
                CaptionML=[DAN=Varer;
                           ENU=Items] }

    { 69  ;4   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m�ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[5].Quantity;
                Editable=FALSE }

    { 68  ;4   ;Field     ;
                Name=Amount_Items;
                CaptionML=[DAN=Bel�b;
                           ENU=Amount];
                ToolTipML=[DAN=Angiver bel�bet for den relevante serviceordre.;
                           ENU=Specifies the amount for the relevant service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[5]."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 67  ;4   ;Field     ;
                Name=Inv. Discount Amount_Items;
                CaptionML=[DAN=Fakturarabatbel�b;
                           ENU=Inv. Discount Amount];
                ToolTipML=[DAN=Angiver fakturarabatbel�bet for hele serviceordren.;
                           ENU=Specifies the invoice discount amount for the entire service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[5]."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 66  ;4   ;Field     ;
                Name=Total2;
                CaptionML=[DAN=I alt;
                           ENU=Total];
                ToolTipML=[DAN=Angiver det samlede bel�b.;
                           ENU=Specifies the total amount.];
                ApplicationArea=#Service;
                SourceExpr=TotalAmount1[5];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 71  ;4   ;Field     ;
                Name=VAT Amount_Items;
                CaptionML=[DAN=Momsbel�b;
                           ENU=VAT Amount];
                ToolTipML=[DAN=Angiver det samlede momsbel�b, der er beregnet for alle linjer i serviceordren.;
                           ENU=Specifies the total VAT amount that has been calculated for all the lines in the service order.];
                ApplicationArea=#Service;
                SourceExpr=VATAmount[5];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 73  ;4   ;Field     ;
                Name=Total Incl. VAT_Items;
                CaptionML=[DAN=I alt;
                           ENU=Total Amount];
                ToolTipML=[DAN=Angiver det samlede bel�b minus et evt. fakturarabatbel�b for serviceordren. V�rdien omfatter ikke moms.;
                           ENU=Specifies the total amount minus any invoice discount amount for the service order. The value does not include VAT.];
                ApplicationArea=#Service;
                SourceExpr=TotalAmount2[5];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 75  ;4   ;Field     ;
                Name=Sales (LCY)_Items;
                CaptionML=[DAN=Salg (RV);
                           ENU=Sales (LCY)];
                ToolTipML=[DAN=Angiver den samlede servicesalgsoms�tning i regnskabs�ret. Den beregnes ud fra bel�bene, ekskl. moms, p� alle afsluttede og �bne servicesalgsfakturaer og -kreditnotaer.;
                           ENU=Specifies your total service sales turnover in the fiscal year. It is calculated from amounts excluding VAT on all completed and open service sales invoices and credit memos.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[5].Amount;
                AutoFormatType=1;
                Editable=FALSE }

    { 79  ;4   ;Field     ;
                CaptionML=[DAN=Oprindeligt avancebel�b (RV);
                           ENU=Original Profit (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b, i RV, for finanskontoposter, omkostninger, varer og/eller ressourcer i serviceorden. Kostbel�bet beregnes som et produkt af kostprisen multipliceret med antallet af den relevante vare eller ressource.;
                           ENU=Specifies the total cost, in LCY, of the G/L account entries, costs, items and/or resources in the service order. The cost is calculated as a product of unit cost multiplied by quantity of the relevant items or resources.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[5];
                AutoFormatType=1;
                Editable=FALSE }

    { 159 ;4   ;Field     ;
                CaptionML=[DAN=Justeret avancebel�b (RV);
                           ENU=Adjusted Profit (LCY)];
                ToolTipML=[DAN=Angiver avancebel�bet for serviceordren, i RV, justeret for evt. �ndringer i de oprindelige varepriser.;
                           ENU=Specifies the amount of profit for the service order, in LCY, adjusted for any changes in the original item costs.];
                ApplicationArea=#Service;
                SourceExpr=AdjProfitLCY[5];
                AutoFormatType=1;
                Editable=FALSE }

    { 81  ;4   ;Field     ;
                CaptionML=[DAN=Oprindelig avance i %;
                           ENU=Original Profit %];
                ToolTipML=[DAN=Angiver bel�bet i den oprindelige avance for serviceordren (i RV) f�r en evt. vareprisregulering. Bel�bet beregnes i programmet som forskellen mellem v�rdierne i felterne Bel�b ekskl. moms (Bel�b inkl. moms) og Oprindeligt kostbel�b (RV).;
                           ENU=Specifies the amount of original profit for the service order (in LCY), prior to any item cost adjustment. The program calculates the amount as the difference between the values in the Amount Excl. VAT (Amount Incl. VAT) and the Original Cost (LCY) fields.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=ProfitPct[5];
                Editable=FALSE }

    { 163 ;4   ;Field     ;
                CaptionML=[DAN=Justeret avance i %;
                           ENU=Adjusted Profit %];
                ToolTipML=[DAN=Angiver bel�bet i den regulerede avance i serviceordren udtrykt som en procentdel af bel�bet i feltet Bel�b ekskl. moms (Bel�b inkl. moms).;
                           ENU=Specifies the amount of the adjusted profit on the service order, expressed as percentage of the amount in the Amount Excl. VAT (Amount Incl. VAT) field.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=AdjProfitPct[5];
                Editable=FALSE }

    { 77  ;4   ;Field     ;
                CaptionML=[DAN=Oprindeligt kostbel�b (RV);
                           ENU=Original Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b, i RV, for finanskontoposter, omkostninger, varer og/eller ressourcer i serviceorden. Kostbel�bet beregnes som et produkt af kostprisen multipliceret med antallet af den relevante vare.;
                           ENU=Specifies the total cost, in LCY, of the G/L account entries, costs, items and/or resources in the service order. The cost is calculated as a product of unit cost multiplied by quantity of the relevant items.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[5]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 174 ;4   ;Field     ;
                CaptionML=[DAN=Justerede omkostninger (RV);
                           ENU=Adjusted Cost (LCY)];
                ToolTipML=[DAN=Angiver de samlede omkostninger i RV for varerne i serviceordren, justeret s� der er taget h�jde for evt. �ndringer i de oprindelige omkostninger for disse varer.;
                           ENU=Specifies the total cost, in LCY, of the items in the service order, adjusted for any changes in the original costs of these items];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[5];
                AutoFormatType=1;
                Editable=FALSE }

    { 173 ;4   ;Field     ;
                CaptionML=[DAN=Overd�kningsbel�b (RV);
                           ENU=Cost Adjmt. Amount (LCY)];
                ToolTipML=[DAN=Angiver forskellen mellem de oprindelige omkostninger og den samlede regulerede kostpris for varerne i serviceordren.;
                           ENU=Specifies the difference between the original cost and the total adjusted cost of the items in the service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[5] - TotalServLineLCY[5]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE;
                OnLookup=BEGIN
                           LookupAdjmtValueEntries(1);
                         END;
                          }

    { 1901992801;3;Group  ;
                CaptionML=[DAN=Ressourcer;
                           ENU=Resources] }

    { 86  ;4   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m�ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[6].Quantity;
                Editable=FALSE }

    { 85  ;4   ;Field     ;
                Name=Amount_Resources;
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[6]."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text002,FALSE);
                Editable=FALSE }

    { 84  ;4   ;Field     ;
                Name=Inv. Discount Amount_Resources;
                CaptionML=[DAN=Fakturarabatbel�b;
                           ENU=Inv. Discount Amount];
                ToolTipML=[DAN=Angiver fakturarabatbel�bet for hele serviceordren.;
                           ENU=Specifies the invoice discount amount for the entire service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[6]."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 83  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount1[6];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,FALSE);
                Editable=FALSE }

    { 88  ;4   ;Field     ;
                Name=VAT Amount_Resources;
                ApplicationArea=#Service;
                SourceExpr=VATAmount[6];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE;
                ShowCaption=No }

    { 119 ;4   ;Field     ;
                Name=Total Incl. VAT_Resources;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount2[6];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,TRUE);
                Editable=FALSE }

    { 120 ;4   ;Field     ;
                Name=Sales (LCY)_Resources;
                CaptionML=[DAN=Bel�b (RV);
                           ENU=Amount (LCY)];
                ToolTipML=[DAN=Angiver bel�bet i finansposten i den lokale valuta.;
                           ENU=Specifies the amount of the ledger entry, in the local currency.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[6].Amount;
                AutoFormatType=1;
                Editable=FALSE }

    { 122 ;4   ;Field     ;
                CaptionML=[DAN=Avancebel�b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver den avance, der er relateret til serviceordren, i den lokale valuta.;
                           ENU=Specifies the profit related to the service order, in local currency.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[6];
                AutoFormatType=1;
                Editable=FALSE }

    { 158 ;4   ;Field     ;
                CaptionML=[DAN=Avancebel�b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver den avance, der er relateret til serviceordren, i den lokale valuta.;
                           ENU=Specifies the profit related to the service order, in local currency.];
                ApplicationArea=#Service;
                SourceExpr=AdjProfitLCY[6];
                AutoFormatType=1;
                Editable=FALSE }

    { 123 ;4   ;Field     ;
                CaptionML=[DAN=Avancepct.;
                           ENU=Profit %];
                ToolTipML=[DAN=Angiver den procentdel af avancen, der er relateret til serviceordren.;
                           ENU=Specifies the percent of profit related to the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=ProfitPct[6];
                Editable=FALSE }

    { 51  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 121 ;4   ;Field     ;
                CaptionML=[DAN=Kostbel�b (RV);
                           ENU=Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b i RV.;
                           ENU=Specifies the total cost of the service in LCY.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[6]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 53  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 55  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 1903502501;3;Group  ;
                CaptionML=[DAN=Omkostninger && finanskonti;
                           ENU=Costs && G/L Accounts] }

    { 127 ;4   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m�ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[7].Quantity;
                Editable=FALSE }

    { 126 ;4   ;Field     ;
                Name=Amount_Costs;
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[7]."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text002,FALSE);
                Editable=FALSE }

    { 125 ;4   ;Field     ;
                Name=Inv. Discount Amount_Costs;
                CaptionML=[DAN=Fakturarabatbel�b;
                           ENU=Inv. Discount Amount];
                ToolTipML=[DAN=Angiver fakturarabatbel�bet for hele serviceordren.;
                           ENU=Specifies the invoice discount amount for the entire service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[7]."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 124 ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount1[7];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,FALSE);
                Editable=FALSE }

    { 129 ;4   ;Field     ;
                Name=VAT Amount_Costs;
                ApplicationArea=#Service;
                SourceExpr=VATAmount[7];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE;
                ShowCaption=No }

    { 130 ;4   ;Field     ;
                Name=Total Incl. VAT_Costs;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount2[7];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,TRUE);
                Editable=FALSE }

    { 131 ;4   ;Field     ;
                Name=Sales (LCY)_Costs;
                CaptionML=[DAN=Bel�b (RV);
                           ENU=Amount (LCY)];
                ToolTipML=[DAN=Angiver bel�bet i finansposten i den lokale valuta.;
                           ENU=Specifies the amount of the ledger entry, in the local currency.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[7].Amount;
                AutoFormatType=1;
                Editable=FALSE }

    { 133 ;4   ;Field     ;
                CaptionML=[DAN=Avancebel�b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver den avance, der er relateret til serviceordren, i den lokale valuta.;
                           ENU=Specifies the profit related to the service order, in local currency.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[7];
                AutoFormatType=1;
                Editable=FALSE }

    { 157 ;4   ;Field     ;
                CaptionML=[DAN=Avancebel�b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver den avance, der er relateret til serviceordren, i den lokale valuta.;
                           ENU=Specifies the profit related to the service order, in local currency.];
                ApplicationArea=#Service;
                SourceExpr=AdjProfitLCY[7];
                AutoFormatType=1;
                Editable=FALSE }

    { 134 ;4   ;Field     ;
                CaptionML=[DAN=Avancepct.;
                           ENU=Profit %];
                ToolTipML=[DAN=Angiver den procentdel af avancen, der er relateret til serviceordren.;
                           ENU=Specifies the percent of profit related to the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=ProfitPct[7];
                Editable=FALSE }

    { 52  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 132 ;4   ;Field     ;
                CaptionML=[DAN=Kostbel�b (RV);
                           ENU=Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel�b i RV.;
                           ENU=Specifies the total cost of the service in LCY.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[7]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 54  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 56  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 1903289601;1;Group  ;
                CaptionML=[DAN=Debitor;
                           ENU=Customer] }

    { 28  ;2   ;Field     ;
                CaptionML=[DAN=Saldo (RV);
                           ENU=Balance (LCY)];
                ToolTipML=[DAN=Angiver saldoen i RV p� debitorens konto.;
                           ENU=Specifies the balance in LCY on the customer's account.];
                ApplicationArea=#Service;
                SourceExpr=Cust."Balance (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                Name=Credit Limit (LCY)_Customer;
                CaptionML=[DAN=Kreditmaksimum (RV);
                           ENU=Credit Limit (LCY)];
                ToolTipML=[DAN=Angiver oplysninger om debitorens kreditmaksimum.;
                           ENU=Specifies information about the customer's credit limit.];
                ApplicationArea=#Service;
                SourceExpr=Cust."Credit Limit (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                ExtendedDatatype=Ratio;
                CaptionML=[DAN=Udnyttet pct. af kreditmaksimum (RV);
                           ENU=Expended % of Credit Limit (LCY)];
                ToolTipML=[DAN=Angiver den forventede procentdel af kreditmaksimum i (RV).;
                           ENU=Specifies the expended percentage of the credit limit in (LCY).];
                ApplicationArea=#Service;
                SourceExpr=CreditLimitLCYExpendedPct }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Statistik for service%1;ENU=Service %1 Statistics';
      Text001@1001 : TextConst 'DAN=I alt;ENU=Total';
      Text002@1002 : TextConst 'DAN=Bel�b;ENU=Amount';
      Text003@1003 : TextConst 'DAN=%1 m� ikke v�re 0.;ENU=%1 must not be 0.';
      Text004@1004 : TextConst 'DAN=%1 m� ikke v�re st�rre end %2.;ENU=%1 must not be greater than %2.';
      Text005@1005 : TextConst '@@@=You cannot change the invoice discount because there is a Cust. Invoice Disc. record for Invoice Disc. Code 10000.;DAN=Du kan ikke �ndre fakturarabatten, fordi der findes en record af typen %1 for %2 %3.;ENU=You cannot change the invoice discount because there is a %1 record for %2 %3.';
      TotalServLine@1006 : ARRAY [7] OF Record 5902;
      TotalServLineLCY@1007 : ARRAY [7] OF Record 5902;
      Cust@1008 : Record 18;
      TempVATAmountLine1@1009 : TEMPORARY Record 290;
      TempVATAmountLine2@1010 : TEMPORARY Record 290;
      TempVATAmountLine3@1011 : TEMPORARY Record 290;
      SalesSetup@1012 : Record 311;
      ServAmtsMgt@1029 : Codeunit 5986;
      VATLinesForm@1025 : Page 9401;
      TotalAmount1@1014 : ARRAY [7] OF Decimal;
      TotalAmount2@1015 : ARRAY [7] OF Decimal;
      AdjProfitLCY@1031 : ARRAY [7] OF Decimal;
      AdjProfitPct@1030 : ARRAY [7] OF Decimal;
      TotalAdjCostLCY@1013 : ARRAY [7] OF Decimal;
      VATAmount@1016 : ARRAY [7] OF Decimal;
      VATAmountText@1017 : ARRAY [7] OF Text[30];
      ProfitLCY@1018 : ARRAY [7] OF Decimal;
      ProfitPct@1019 : ARRAY [7] OF Decimal;
      CreditLimitLCYExpendedPct@1020 : Decimal;
      i@1021 : Integer;
      PrevNo@1022 : Code[20];
      ActiveTab@1023 : 'General,Details,Shipping';
      PrevTab@1024 : 'General,Details,Shipping';
      VATLinesFormIsEditable@1026 : Boolean;
      AllowInvDisc@1027 : Boolean;
      AllowVATDifference@1028 : Boolean;
      Text006@1032 : TextConst 'DAN=Pladsholder;ENU=Placeholder';

    LOCAL PROCEDURE UpdateHeaderInfo@5(IndexNo@1000 : Integer;VAR VATAmountLine@1001 : Record 290);
    VAR
      CurrExchRate@1002 : Record 330;
      UseDate@1003 : Date;
    BEGIN
      TotalServLine[IndexNo]."Inv. Discount Amount" := VATAmountLine.GetTotalInvDiscAmount;
      TotalAmount1[IndexNo] :=
        TotalServLine[IndexNo]."Line Amount" - TotalServLine[IndexNo]."Inv. Discount Amount";
      VATAmount[IndexNo] := VATAmountLine.GetTotalVATAmount;
      IF "Prices Including VAT" THEN BEGIN
        TotalAmount1[IndexNo] := VATAmountLine.GetTotalAmountInclVAT;
        TotalAmount2[IndexNo] := TotalAmount1[IndexNo] - VATAmount[IndexNo];
        TotalServLine[IndexNo]."Line Amount" :=
          TotalAmount1[IndexNo] + TotalServLine[IndexNo]."Inv. Discount Amount";
      END ELSE
        TotalAmount2[IndexNo] := TotalAmount1[IndexNo] + VATAmount[IndexNo];

      IF "Prices Including VAT" THEN
        TotalServLineLCY[IndexNo].Amount := TotalAmount2[IndexNo]
      ELSE
        TotalServLineLCY[IndexNo].Amount := TotalAmount1[IndexNo];
      IF "Currency Code" <> '' THEN
        IF ("Document Type" = "Document Type"::Quote) AND
           ("Posting Date" = 0D)
        THEN
          UseDate := WORKDATE
        ELSE
          UseDate := "Posting Date";

      TotalServLineLCY[IndexNo].Amount :=
        CurrExchRate.ExchangeAmtFCYToLCY(
          UseDate,"Currency Code",TotalServLineLCY[IndexNo].Amount,"Currency Factor");

      ProfitLCY[IndexNo] := TotalServLineLCY[IndexNo].Amount - TotalServLineLCY[IndexNo]."Unit Cost (LCY)";
      ProfitLCY[IndexNo] := MakeNegativeZero(ProfitLCY[IndexNo]);
      IF TotalServLineLCY[IndexNo].Amount = 0 THEN
        ProfitPct[IndexNo] := 0
      ELSE
        ProfitPct[IndexNo] := ROUND(100 * ProfitLCY[IndexNo] / TotalServLineLCY[IndexNo].Amount,0.1);

      AdjProfitLCY[IndexNo] := TotalServLineLCY[IndexNo].Amount - TotalAdjCostLCY[IndexNo];
      AdjProfitLCY[IndexNo] := MakeNegativeZero(AdjProfitLCY[IndexNo]);
      IF TotalServLineLCY[IndexNo].Amount = 0 THEN
        AdjProfitPct[IndexNo] := 0
      ELSE
        AdjProfitPct[IndexNo] := ROUND(100 * AdjProfitLCY[IndexNo] / TotalServLineLCY[IndexNo].Amount,0.1);
    END;

    LOCAL PROCEDURE GetVATSpecification@21(QtyType@1000 : 'General,Details,Shipping');
    BEGIN
      CASE QtyType OF
        QtyType::General:
          BEGIN
            VATLinesForm.GetTempVATAmountLine(TempVATAmountLine1);
            UpdateHeaderInfo(1,TempVATAmountLine1);
          END;
        QtyType::Details:
          BEGIN
            VATLinesForm.GetTempVATAmountLine(TempVATAmountLine2);
            UpdateHeaderInfo(2,TempVATAmountLine2);
          END;
        QtyType::Shipping:
          VATLinesForm.GetTempVATAmountLine(TempVATAmountLine3);
      END;
    END;

    LOCAL PROCEDURE UpdateTotalAmount@16(IndexNo@1000 : Integer);
    VAR
      SaveTotalAmount@1001 : Decimal;
    BEGIN
      CheckAllowInvDisc;
      IF "Prices Including VAT" THEN BEGIN
        SaveTotalAmount := TotalAmount1[IndexNo];
        UpdateInvDiscAmount(IndexNo);
        TotalAmount1[IndexNo] := SaveTotalAmount;
      END;

      WITH TotalServLine[IndexNo] DO
        "Inv. Discount Amount" := "Line Amount" - TotalAmount1[IndexNo];
      UpdateInvDiscAmount(IndexNo);
    END;

    LOCAL PROCEDURE UpdateInvDiscAmount@3(ModifiedIndexNo@1000 : Integer);
    VAR
      PartialInvoicing@1001 : Boolean;
      MaxIndexNo@1002 : Integer;
      IndexNo@1003 : ARRAY [2] OF Integer;
      i@1004 : Integer;
      InvDiscBaseAmount@1005 : Decimal;
    BEGIN
      CheckAllowInvDisc;
      IF NOT (ModifiedIndexNo IN [1,2]) THEN
        EXIT;

      IF ModifiedIndexNo = 1 THEN
        InvDiscBaseAmount := TempVATAmountLine1.GetTotalInvDiscBaseAmount(FALSE,"Currency Code")
      ELSE
        InvDiscBaseAmount := TempVATAmountLine2.GetTotalInvDiscBaseAmount(FALSE,"Currency Code");

      IF InvDiscBaseAmount = 0 THEN
        ERROR(Text003,TempVATAmountLine2.FIELDCAPTION("Inv. Disc. Base Amount"));

      IF TotalServLine[ModifiedIndexNo]."Inv. Discount Amount" / InvDiscBaseAmount > 1 THEN
        ERROR(
          Text004,
          TotalServLine[ModifiedIndexNo].FIELDCAPTION("Inv. Discount Amount"),
          TempVATAmountLine2.FIELDCAPTION("Inv. Disc. Base Amount"));

      PartialInvoicing := (TotalServLine[1]."Line Amount" <> TotalServLine[2]."Line Amount");

      IndexNo[1] := ModifiedIndexNo;
      IndexNo[2] := 3 - ModifiedIndexNo;
      IF (ModifiedIndexNo = 2) AND PartialInvoicing THEN
        MaxIndexNo := 1
      ELSE
        MaxIndexNo := 2;

      IF NOT PartialInvoicing THEN
        IF ModifiedIndexNo = 1 THEN
          TotalServLine[2]."Inv. Discount Amount" := TotalServLine[1]."Inv. Discount Amount"
        ELSE
          TotalServLine[1]."Inv. Discount Amount" := TotalServLine[2]."Inv. Discount Amount";

      FOR i := 1 TO MaxIndexNo DO
        WITH TotalServLine[IndexNo[i]] DO BEGIN
          IF (i = 1) OR NOT PartialInvoicing THEN
            IF IndexNo[i] = 1 THEN BEGIN
              TempVATAmountLine1.SetInvoiceDiscountAmount(
                "Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");
            END ELSE
              TempVATAmountLine2.SetInvoiceDiscountAmount(
                "Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");

          IF (i = 2) AND PartialInvoicing THEN
            IF IndexNo[i] = 1 THEN BEGIN
              InvDiscBaseAmount := TempVATAmountLine2.GetTotalInvDiscBaseAmount(FALSE,"Currency Code");
              IF InvDiscBaseAmount = 0 THEN
                TempVATAmountLine1.SetInvoiceDiscountPercent(
                  0,"Currency Code","Prices Including VAT",FALSE,"VAT Base Discount %")
              ELSE
                TempVATAmountLine1.SetInvoiceDiscountPercent(
                  100 * TempVATAmountLine2.GetTotalInvDiscAmount / InvDiscBaseAmount,
                  "Currency Code","Prices Including VAT",FALSE,"VAT Base Discount %");
            END ELSE BEGIN
              InvDiscBaseAmount := TempVATAmountLine1.GetTotalInvDiscBaseAmount(FALSE,"Currency Code");
              IF InvDiscBaseAmount = 0 THEN
                TempVATAmountLine2.SetInvoiceDiscountPercent(
                  0,"Currency Code","Prices Including VAT",FALSE,"VAT Base Discount %")
              ELSE
                TempVATAmountLine2.SetInvoiceDiscountPercent(
                  100 * TempVATAmountLine1.GetTotalInvDiscAmount / InvDiscBaseAmount,
                  "Currency Code","Prices Including VAT",FALSE,"VAT Base Discount %");
            END;
        END;

      UpdateHeaderInfo(1,TempVATAmountLine1);
      UpdateHeaderInfo(2,TempVATAmountLine2);

      IF ModifiedIndexNo = 1 THEN
        VATLinesForm.SetTempVATAmountLine(TempVATAmountLine1)
      ELSE
        VATLinesForm.SetTempVATAmountLine(TempVATAmountLine2);

      "Invoice Discount Calculation" := "Invoice Discount Calculation"::Amount;
      "Invoice Discount Value" := TotalServLine[1]."Inv. Discount Amount";
      MODIFY;

      UpdateVATOnServLines;
    END;

    LOCAL PROCEDURE GetCaptionClass@2(FieldCaption@1000 : Text[100];ReverseCaption@1001 : Boolean) : Text[80];
    BEGIN
      IF "Prices Including VAT" XOR ReverseCaption THEN
        EXIT('2,1,' + FieldCaption);
      EXIT('2,0,' + FieldCaption);
    END;

    LOCAL PROCEDURE UpdateVATOnServLines@1();
    VAR
      ServLine@1000 : Record 5902;
    BEGIN
      GetVATSpecification(ActiveTab);
      IF TempVATAmountLine1.GetAnyLineModified THEN
        ServLine.UpdateVATOnLines(0,Rec,ServLine,TempVATAmountLine1);
      IF TempVATAmountLine2.GetAnyLineModified THEN
        ServLine.UpdateVATOnLines(1,Rec,ServLine,TempVATAmountLine2);
      PrevNo := '';
    END;

    LOCAL PROCEDURE CustInvDiscRecExists@4(InvDiscCode@1000 : Code[20]) : Boolean;
    VAR
      CustInvDisc@1001 : Record 19;
    BEGIN
      CustInvDisc.SETRANGE(Code,InvDiscCode);
      EXIT(CustInvDisc.FINDFIRST);
    END;

    LOCAL PROCEDURE CheckAllowInvDisc@8();
    VAR
      CustInvDisc@1000 : Record 19;
    BEGIN
      IF NOT AllowInvDisc THEN
        ERROR(
          Text005,
          CustInvDisc.TABLECAPTION,FIELDCAPTION("Invoice Disc. Code"),"Invoice Disc. Code");
    END;

    LOCAL PROCEDURE GetDetailsTotal@6() : Decimal;
    BEGIN
      IF TotalServLineLCY[2].Amount = 0 THEN
        EXIT(0);
      EXIT(ROUND(100 * (ProfitLCY[2] + ProfitLCY[4]) / TotalServLineLCY[2].Amount,0.01));
    END;

    LOCAL PROCEDURE GetAdjDetailsTotal@7() : Decimal;
    BEGIN
      IF TotalServLineLCY[2].Amount = 0 THEN
        EXIT(0);
      EXIT(ROUND(100 * (AdjProfitLCY[2] + AdjProfitLCY[4]) / TotalServLineLCY[2].Amount,0.01));
    END;

    LOCAL PROCEDURE VATLinesDrillDown@1102601000(VAR VATLinesToDrillDown@1000 : Record 290;ThisTabAllowsVATEditing@1001 : Boolean);
    BEGIN
      CLEAR(VATLinesForm);
      VATLinesForm.SetTempVATAmountLine(VATLinesToDrillDown);
      VATLinesForm.InitGlobals(
        "Currency Code",AllowVATDifference,AllowVATDifference AND ThisTabAllowsVATEditing,
        "Prices Including VAT",AllowInvDisc,"VAT Base Discount %");
      VATLinesForm.RUNMODAL;
      VATLinesForm.GetTempVATAmountLine(VATLinesToDrillDown);
    END;

    LOCAL PROCEDURE TotalAmount21OnAfterValidate@19074760();
    BEGIN
      WITH TotalServLine[1] DO BEGIN
        IF "Prices Including VAT" THEN
          "Inv. Discount Amount" := "Line Amount" - "Amount Including VAT"
        ELSE
          "Inv. Discount Amount" := "Line Amount" - Amount;
      END;
      ActiveTab := ActiveTab::General;
      UpdateInvDiscAmount(1);
    END;

    LOCAL PROCEDURE MakeNegativeZero@10(Amount@1000 : Decimal) : Decimal;
    BEGIN
      IF Amount < 0 THEN
        EXIT(0);
      EXIT(Amount);
    END;

    BEGIN
    END.
  }
}

