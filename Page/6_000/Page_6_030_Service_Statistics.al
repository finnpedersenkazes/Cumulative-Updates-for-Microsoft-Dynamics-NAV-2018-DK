OBJECT Page 6030 Service Statistics
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Servicestatistik;
               ENU=Service Statistics];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table5900;
    PageType=ListPlus;
    OnOpenPage=BEGIN
                 SalesSetup.GET;
                 AllowInvDisc :=
                   NOT (SalesSetup."Calc. Inv. Discount" AND CustInvDiscRecExists("Invoice Disc. Code"));
                 AllowVATDifference :=
                   SalesSetup."Allow VAT Difference" AND
                   ("Document Type" <> "Document Type"::Quote);
                 CurrPage.EDITABLE :=
                   AllowVATDifference OR AllowInvDisc;
                 SetVATSpecification;
                 CurrPage.SubForm.PAGE.SetParentControl := PAGE::"Service Statistics";
               END;

    OnAfterGetRecord=VAR
                       ServLine@1000 : Record 5902;
                       TempServLine@1001 : TEMPORARY Record 5902;
                     BEGIN
                       CurrPage.CAPTION(STRSUBSTNO(Text000,"Document Type"));

                       IF PrevNo = "No." THEN BEGIN
                         GetVATSpecification;
                         EXIT;
                       END;
                       PrevNo := "No.";
                       FILTERGROUP(2);
                       SETRANGE("No.",PrevNo);
                       FILTERGROUP(0);

                       CLEAR(ServLine);
                       CLEAR(TotalServLine);
                       CLEAR(TotalServLineLCY);
                       CLEAR(ServAmtsMgt);

                       FOR i := 1 TO 7 DO BEGIN
                         IF i IN [1,5,6,7] THEN BEGIN
                           TempServLine.DELETEALL;
                           CLEAR(TempServLine);
                           ServAmtsMgt.GetServiceLines(Rec,TempServLine,i - 1);

                           ServAmtsMgt.SumServiceLinesTemp(
                             Rec,TempServLine,i - 1,TotalServLine[i],TotalServLineLCY[i],
                             VATAmount[i],VATAmountText[i],ProfitLCY[i],ProfitPct[i],TotalAdjCostLCY[i]);

                           IF TotalServLineLCY[i].Amount = 0 THEN
                             ProfitPct[i] := 0
                           ELSE
                             ProfitPct[i] := ROUND(100 * ProfitLCY[i] / TotalServLineLCY[i].Amount,0.1);

                           AdjProfitLCY[i] := TotalServLineLCY[i].Amount - TotalAdjCostLCY[i];
                           IF TotalServLineLCY[i].Amount <> 0 THEN
                             AdjProfitPct[i] := ROUND(AdjProfitLCY[i] / TotalServLineLCY[i].Amount * 100,0.1);

                           IF "Prices Including VAT" THEN BEGIN
                             TotalAmount2[i] := TotalServLine[i].Amount;
                             TotalAmount1[i] := TotalAmount2[i] + VATAmount[i];
                             TotalServLine[i]."Line Amount" := TotalAmount1[i] + TotalServLine[i]."Inv. Discount Amount";
                           END ELSE BEGIN
                             TotalAmount1[i] := TotalServLine[i].Amount;
                             TotalAmount2[i] := TotalServLine[i]."Amount Including VAT";
                           END;
                         END;
                       END;

                       IF Cust.GET("Bill-to Customer No.") THEN
                         Cust.CALCFIELDS("Balance (LCY)")
                       ELSE
                         CLEAR(Cust);
                       IF Cust."Credit Limit (LCY)" = 0 THEN
                         CreditLimitLCYExpendedPct := 0
                       ELSE
                         IF Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0 THEN
                           CreditLimitLCYExpendedPct := 0
                         ELSE
                           IF Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1 THEN
                             CreditLimitLCYExpendedPct := 10000
                           ELSE
                             CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000,1);

                       TempServLine.DELETEALL;
                       CLEAR(TempServLine);
                       ServAmtsMgt.GetServiceLines(Rec,TempServLine,0);
                       ServLine.CalcVATAmountLines(0,Rec,TempServLine,TempVATAmountLine,FALSE);
                       TempVATAmountLine.MODIFYALL(Modified,FALSE);

                       SetVATSpecification;
                     END;

    OnQueryClosePage=BEGIN
                       GetVATSpecification;
                       IF TempVATAmountLine.GetAnyLineModified THEN
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

    { 129 ;2   ;Field     ;
                Name=Amount_General;
                CaptionML=[DAN=Bel›b;
                           ENU=Amount];
                ToolTipML=[DAN=Angiver bel›bet for den relevante serviceordre.;
                           ENU=Specifies the amount for the relevant service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[1]."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text002,FALSE);
                Editable=FALSE }

    { 93  ;2   ;Field     ;
                Name=Inv. Discount Amount_General;
                CaptionML=[DAN=Fakturarabatbel›b;
                           ENU=Inv. Discount Amount];
                ToolTipML=[DAN=Angiver fakturarabatbel›bet for hele servicedokumentet.;
                           ENU=Specifies the invoice discount amount for the entire service document.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[1]."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                OnValidate=BEGIN
                             UpdateInvDiscAmount;
                           END;
                            }

    { 80  ;2   ;Field     ;
                CaptionML=[DAN=I alt;
                           ENU=Total];
                ToolTipML=[DAN=Angiver hele det samlede bel›b p† servicelinjerne (inklusive og eksklusive moms), momsdelen, kostbel›b og avance p† servicelinjerne.;
                           ENU=Specifies the total amount on the service lines (including and excluding VAT), VAT part, cost, and profit on the service lines.];
                ApplicationArea=#Service;
                SourceExpr=TotalAmount1[1];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,FALSE);
                OnValidate=BEGIN
                             UpdateTotalAmount(1);
                           END;
                            }

    { 75  ;2   ;Field     ;
                Name=VAT Amount_General;
                CaptionML=[DAN=Momsbel›b;
                           ENU=VAT Amount];
                ToolTipML=[DAN=Angiver det samlede momsbel›b, der er beregnet for alle linjer i servicedokumentet.;
                           ENU=Specifies the total VAT amount that has been calculated for all the lines in the service document.];
                ApplicationArea=#Service;
                SourceExpr=VATAmount[1];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=FORMAT(VATAmountText[1]);
                Editable=FALSE }

    { 76  ;2   ;Field     ;
                Name=Total Incl. VAT_General;
                CaptionML=[DAN=I alt inkl. moms;
                           ENU=Total Incl. VAT];
                ToolTipML=[DAN=Angiver det samlede bel›b i servicedokumentet inklusive moms. Det er dette bel›b, der bogf›res p† debitorens konto for alle linjerne i servicedokumentet.;
                           ENU=Specifies the total amount on the service document, including VAT. This is the amount that will be posted to the customer's account for all the lines in the service document.];
                ApplicationArea=#Service;
                SourceExpr=TotalAmount2[1];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,TRUE);
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                Name=Sales (LCY)_General;
                CaptionML=[DAN=Salg (RV);
                           ENU=Sales (LCY)];
                ToolTipML=[DAN=Angiver den samlede servicesalgsoms‘tning i regnskabs†ret. Den beregnes ud fra bel›bene, ekskl. moms, p† alle afsluttede og †bne servicesalgsfakturaer og -kreditnotaer.;
                           ENU=Specifies your total service sales turnover in the fiscal year. It is calculated from amounts excluding VAT on all completed and open service sales invoices and credit memos.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[1].Amount;
                AutoFormatType=1;
                Editable=FALSE }

    { 79  ;2   ;Field     ;
                CaptionML=[DAN=Oprindeligt avancebel›b (RV);
                           ENU=Original Profit (LCY)];
                ToolTipML=[DAN=Angiver den oprindelige avance, der blev knyttet til servicedokumentet.;
                           ENU=Specifies the original profit that was associated with the service document.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[1];
                AutoFormatType=1;
                Editable=FALSE }

    { 52  ;2   ;Field     ;
                CaptionML=[DAN=Justeret avancebel›b (RV);
                           ENU=Adjusted Profit (LCY)];
                ToolTipML=[DAN=Angiver avancebel›bet for servicedokumentet, i RV, justeret for evt. ‘ndringer i de oprindelige varepriser.;
                           ENU=Specifies the amount of profit for the service document, in LCY, adjusted for any changes in the original item costs.];
                ApplicationArea=#Service;
                SourceExpr=AdjProfitLCY[1];
                AutoFormatType=1;
                Editable=FALSE }

    { 81  ;2   ;Field     ;
                CaptionML=[DAN=Oprindelig avance i %;
                           ENU=Original Profit %];
                ToolTipML=[DAN=Angiver bel›bet for den oprindelige avance i servicedokumentet udtrykt som en procentdel af bel›bet i feltet Bel›b.;
                           ENU=Specifies the amount of the original profit on the service document, expressed as percentage of the amount in the Amount field.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=ProfitPct[1];
                Editable=FALSE }

    { 54  ;2   ;Field     ;
                CaptionML=[DAN=Justeret avance i %;
                           ENU=Adjusted Profit %];
                ToolTipML=[DAN=Angiver bel›bet for den regulerede avance i servicedokumentet udtrykt som en procentdel af bel›bet i feltet Bel›b.;
                           ENU=Specifies the amount of the adjusted profit on the service document, expressed as percentage of the amount in the Amount field.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=AdjProfitPct[1];
                Editable=FALSE }

    { 95  ;2   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m‘ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[1].Quantity;
                Editable=FALSE }

    { 73  ;2   ;Field     ;
                CaptionML=[DAN=Kolli;
                           ENU=Parcels];
                ToolTipML=[DAN=Angiver det samlede antal kolli i den bogf›rte servicekreditnota.;
                           ENU=Specifies the total number of parcels in the posted service credit memo.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[1]."Units per Parcel";
                Editable=FALSE }

    { 91  ;2   ;Field     ;
                CaptionML=[DAN=Nettov‘gt;
                           ENU=Net Weight];
                ToolTipML=[DAN=Angiver nettov‘gten af de varer, der er angivet p† servicelinjerne i bilaget.;
                           ENU=Specifies the net weight of the items specified on the service lines in the document.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[1]."Net Weight";
                Editable=FALSE }

    { 82  ;2   ;Field     ;
                CaptionML=[DAN=Bruttov‘gt;
                           ENU=Gross Weight];
                ToolTipML=[DAN=Angiver bruttov‘gten af varerne p† servicelinjerne i bilaget.;
                           ENU=Specifies the gross weight of the items on the service lines in the document.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[1]."Gross Weight";
                Editable=FALSE }

    { 71  ;2   ;Field     ;
                CaptionML=[DAN=Rumfang;
                           ENU=Volume];
                ToolTipML=[DAN=Angiver volumen af varerne p† servicelinjerne i bilaget.;
                           ENU=Specifies the volume of the items on the service lines in the document.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[1]."Unit Volume";
                Editable=FALSE }

    { 78  ;2   ;Field     ;
                CaptionML=[DAN=Oprindeligt kostbel›b (RV);
                           ENU=Original Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel›b (i RV) for finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i servicedokumentet. Kostbel›bet beregnes som et produkt af kostpris multipliceret med antallet af de relevante varer, ressourcer og/eller omkostninger.;
                           ENU=Specifies the total cost (in LCY) of the G/L account entries, costs, items and/or resource hours on the service document. The cost is calculated as a product of unit cost multiplied by quantity of the relevant items, resources and/or costs.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[1]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 56  ;2   ;Field     ;
                CaptionML=[DAN=Justerede omkostninger (RV);
                           ENU=Adjusted Cost (LCY)];
                ToolTipML=[DAN=Angiver de samlede omkostninger i RV for varerne i servicedokumentet, justeret s† der er taget h›jde for evt. ‘ndringer i de oprindelige omkostninger for disse varer.;
                           ENU=Specifies the total cost, in LCY, of the items in the service document, adjusted for any changes in the original costs of these items.];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[1];
                AutoFormatType=1;
                Editable=FALSE }

    { 58  ;2   ;Field     ;
                CaptionML=[DAN=Overd‘kningsbel›b (RV);
                           ENU=Cost Adjmt. Amount (LCY)];
                ToolTipML=[DAN=Angiver forskellen mellem de oprindelige omkostninger og den samlede regulerede kostpris for varerne i servicedokumentet.;
                           ENU=Specifies the difference between the original cost and the total adjusted cost of the items in the service document.];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[1] - TotalServLineLCY[1]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE;
                OnLookup=BEGIN
                           LookupAdjmtValueEntries(0);
                         END;
                          }

    { 5   ;1   ;Part      ;
                Name=SubForm;
                ApplicationArea=#Service;
                PagePartID=Page576;
                PartType=Page }

    { 1903781401;1;Group  ;
                CaptionML=[DAN=Servicelinje;
                           ENU=Service Line] }

    { 1904230801;2;Group  ;
                GroupType=FixedLayout }

    { 1900725501;3;Group  ;
                CaptionML=[DAN=Varer;
                           ENU=Items] }

    { 8   ;4   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m‘ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[5].Quantity;
                Editable=FALSE }

    { 10  ;4   ;Field     ;
                Name=Amount_Items;
                CaptionML=[DAN=Bel›b;
                           ENU=Amount];
                ToolTipML=[DAN=Angiver bel›bet for den relevante serviceordre.;
                           ENU=Specifies the amount for the relevant service order.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[5]."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 12  ;4   ;Field     ;
                Name=Inv. Discount Amount_Items;
                CaptionML=[DAN=Fakturarabatbel›b;
                           ENU=Inv. Discount Amount];
                ToolTipML=[DAN=Angiver fakturarabatbel›bet for hele servicedokumentet.;
                           ENU=Specifies the invoice discount amount for the entire service document.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[5]."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 14  ;4   ;Field     ;
                Name=Total;
                CaptionML=[DAN=I alt;
                           ENU=Total];
                ToolTipML=[DAN=Angiver hele det samlede bel›b p† servicelinjerne (inklusive og eksklusive moms), momsdelen, kostbel›b og avance p† servicelinjerne.;
                           ENU=Specifies the total amount on the service lines (including and excluding VAT), VAT part, cost, and profit on the service lines.];
                ApplicationArea=#Service;
                SourceExpr=TotalAmount1[5];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE;
                OnValidate=BEGIN
                             UpdateTotalAmount(2);
                           END;
                            }

    { 21  ;4   ;Field     ;
                Name=VAT Amount_Items;
                CaptionML=[DAN=Momsbel›b;
                           ENU=VAT Amount];
                ToolTipML=[DAN=Angiver det samlede momsbel›b, der er beregnet for alle linjer i servicedokumentet.;
                           ENU=Specifies the total VAT amount that has been calculated for all the lines in the service document.];
                ApplicationArea=#Service;
                SourceExpr=VATAmount[5];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 24  ;4   ;Field     ;
                Name=Total Incl. VAT_Items;
                CaptionML=[DAN=I alt;
                           ENU=Total Amount];
                ToolTipML=[DAN=Angiver hele det samlede bel›b p† servicelinjerne inklusive og eksklusive moms, momsdelen, kostbel›b og avance p† servicelinjerne.;
                           ENU=Specifies the total amount on the service lines including and excluding VAT, VAT part, cost, and profit on the service lines.];
                ApplicationArea=#Service;
                SourceExpr=TotalAmount2[5];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 27  ;4   ;Field     ;
                Name=Sales (LCY)_Items;
                CaptionML=[DAN=Salg (RV);
                           ENU=Sales (LCY)];
                ToolTipML=[DAN=Angiver den samlede servicesalgsoms‘tning i regnskabs†ret. Den beregnes ud fra bel›bene, ekskl. moms, p† alle afsluttede og †bne servicesalgsfakturaer og -kreditnotaer.;
                           ENU=Specifies your total service sales turnover in the fiscal year. It is calculated from amounts excluding VAT on all completed and open service sales invoices and credit memos.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[5].Amount;
                AutoFormatType=1;
                Editable=FALSE }

    { 43  ;4   ;Field     ;
                CaptionML=[DAN=Oprindeligt avancebel›b (RV);
                           ENU=Original Profit (LCY)];
                ToolTipML=[DAN=Angiver den oprindelige avance, der blev knyttet til servicedokumentet.;
                           ENU=Specifies the original profit that was associated with the service document.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[5];
                AutoFormatType=1;
                Editable=FALSE }

    { 61  ;4   ;Field     ;
                CaptionML=[DAN=Justeret avancebel›b (RV);
                           ENU=Adjusted Profit (LCY)];
                ToolTipML=[DAN=Angiver avancebel›bet for servicedokumentet, i RV, justeret for evt. ‘ndringer i de oprindelige varepriser.;
                           ENU=Specifies the amount of profit for the service document, in LCY, adjusted for any changes in the original item costs.];
                ApplicationArea=#Service;
                SourceExpr=AdjProfitLCY[5];
                AutoFormatType=1;
                Editable=FALSE }

    { 47  ;4   ;Field     ;
                CaptionML=[DAN=Oprindelig avance i %;
                           ENU=Original Profit %];
                ToolTipML=[DAN=Angiver bel›bet for den oprindelige avance i servicedokumentet udtrykt som en procentdel af bel›bet i feltet Bel›b.;
                           ENU=Specifies the amount of the original profit on the service document, expressed as percentage of the amount in the Amount field.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=ProfitPct[5];
                Editable=FALSE }

    { 65  ;4   ;Field     ;
                CaptionML=[DAN=Justeret avance i %;
                           ENU=Adjusted Profit %];
                ToolTipML=[DAN=Angiver bel›bet for den regulerede avance i servicedokumentet udtrykt som en procentdel af bel›bet i feltet Bel›b.;
                           ENU=Specifies the amount of the adjusted profit on the service document, expressed as percentage of the amount in the Amount field.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=AdjProfitPct[5];
                Editable=FALSE }

    { 30  ;4   ;Field     ;
                CaptionML=[DAN=Oprindeligt kostbel›b (RV);
                           ENU=Original Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel›b (i RV) for finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i servicedokumentet. Kostbel›bet beregnes som et produkt af kostpris multipliceret med antallet af de relevante varer, ressourcer og/eller omkostninger.;
                           ENU=Specifies the total cost (in LCY) of the G/L account entries, costs, items and/or resource hours on the service document. The cost is calculated as a product of unit cost multiplied by quantity of the relevant items, resources and/or costs.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[5]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 77  ;4   ;Field     ;
                CaptionML=[DAN=Justerede omkostninger (RV);
                           ENU=Adjusted Cost (LCY)];
                ToolTipML=[DAN=Angiver de samlede omkostninger i RV for varerne i servicedokumentet, justeret s† der er taget h›jde for evt. ‘ndringer i de oprindelige omkostninger for disse varer.;
                           ENU=Specifies the total cost, in LCY, of the items in the service document, adjusted for any changes in the original costs of these items.];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[5];
                AutoFormatType=1;
                Editable=FALSE }

    { 104 ;4   ;Field     ;
                CaptionML=[DAN=Overd‘kningsbel›b (RV);
                           ENU=Cost Adjmt. Amount (LCY)];
                ToolTipML=[DAN=Angiver forskellen mellem de oprindelige omkostninger og den samlede regulerede kostpris for varerne i servicedokumentet.;
                           ENU=Specifies the difference between the original cost and the total adjusted cost of the items in the service document.];
                ApplicationArea=#Service;
                SourceExpr=TotalAdjCostLCY[5] - TotalServLineLCY[5]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE;
                OnLookup=BEGIN
                           LookupAdjmtValueEntries(1);
                         END;
                          }

    { 1903867001;3;Group  ;
                CaptionML=[DAN=Ressourcer;
                           ENU=Resources] }

    { 19  ;4   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m‘ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[6].Quantity;
                Editable=FALSE }

    { 18  ;4   ;Field     ;
                Name=Amount_Resources;
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[6]."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text002,FALSE);
                Editable=FALSE }

    { 17  ;4   ;Field     ;
                Name=Inv. Discount Amount_Resources;
                CaptionML=[DAN=Fakturarabatbel›b;
                           ENU=Inv. Discount Amount];
                ToolTipML=[DAN=Angiver fakturarabatbel›bet for hele servicedokumentet.;
                           ENU=Specifies the invoice discount amount for the entire service document.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[6]."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 16  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount1[6];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,FALSE);
                Editable=FALSE;
                OnValidate=BEGIN
                             UpdateTotalAmount(2);
                           END;
                            }

    { 23  ;4   ;Field     ;
                Name=VAT Amount_Resources;
                ApplicationArea=#Service;
                SourceExpr=VATAmount[6];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE;
                ShowCaption=No }

    { 26  ;4   ;Field     ;
                Name=Total Incl. VAT_Resources;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount2[6];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,TRUE);
                Editable=FALSE }

    { 29  ;4   ;Field     ;
                Name=Sales (LCY)_Resources;
                CaptionML=[DAN=Bel›b (RV);
                           ENU=Amount (LCY)];
                ToolTipML=[DAN=Angiver bel›bet i finansposten i den lokale valuta.;
                           ENU=Specifies the amount of the ledger entry, in the local currency.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[6].Amount;
                AutoFormatType=1;
                Editable=FALSE }

    { 45  ;4   ;Field     ;
                CaptionML=[DAN=Avancebel›b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver den avance, der er relateret til bilaget, i den lokale valuta.;
                           ENU=Specifies the profit related to the service document, in local currency.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[6];
                AutoFormatType=1;
                Editable=FALSE }

    { 60  ;4   ;Field     ;
                CaptionML=[DAN=Avancebel›b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver den avance, der er relateret til bilaget, i den lokale valuta.;
                           ENU=Specifies the profit related to the service document, in local currency.];
                ApplicationArea=#Service;
                SourceExpr=AdjProfitLCY[6];
                AutoFormatType=1;
                Editable=FALSE }

    { 49  ;4   ;Field     ;
                CaptionML=[DAN=Avancepct.;
                           ENU=Profit %];
                ToolTipML=[DAN=Angiver avancebel›bet i procent af det fakturerede bel›b.;
                           ENU=Specifies the amount of profit as percentage of the invoiced amount.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=ProfitPct[6];
                Editable=FALSE }

    { 63  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 32  ;4   ;Field     ;
                CaptionML=[DAN=Kostbel›b (RV);
                           ENU=Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel›b i RV.;
                           ENU=Specifies the total cost of the service in LCY.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[6]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 85  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 98  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 1900295701;3;Group  ;
                CaptionML=[DAN=Omkostninger && finanskonti;
                           ENU=Costs && G/L Accounts] }

    { 37  ;4   ;Field     ;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver m‘ngden af alle finanskontoposter, omkostninger, varer og/eller ressourcetidsforbrug i serviceordren.;
                           ENU=Specifies the quantity of all G/L account entries, costs, items and/or resource hours in the service order.];
                ApplicationArea=#Service;
                DecimalPlaces=0:5;
                SourceExpr=TotalServLine[7].Quantity;
                Editable=FALSE }

    { 36  ;4   ;Field     ;
                Name=Amount_Costs;
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[7]."Line Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text002,FALSE);
                Editable=FALSE }

    { 35  ;4   ;Field     ;
                Name=Inv. Discount Amount_Costs;
                CaptionML=[DAN=Fakturarabatbel›b;
                           ENU=Inv. Discount Amount];
                ToolTipML=[DAN=Angiver fakturarabatbel›bet for hele servicedokumentet.;
                           ENU=Specifies the invoice discount amount for the entire service document.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLine[7]."Inv. Discount Amount";
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE }

    { 33  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount1[7];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,FALSE);
                Editable=FALSE;
                OnValidate=BEGIN
                             UpdateTotalAmount(2);
                           END;
                            }

    { 39  ;4   ;Field     ;
                Name=VAT Amount_Costs;
                ApplicationArea=#Service;
                SourceExpr=VATAmount[7];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                Editable=FALSE;
                ShowCaption=No }

    { 40  ;4   ;Field     ;
                Name=Total Incl. VAT_Costs;
                ApplicationArea=#Service;
                SourceExpr=TotalAmount2[7];
                AutoFormatType=1;
                AutoFormatExpr="Currency Code";
                CaptionClass=GetCaptionClass(Text001,TRUE);
                Editable=FALSE }

    { 41  ;4   ;Field     ;
                Name=Sales (LCY)_Costs;
                CaptionML=[DAN=Bel›b (RV);
                           ENU=Amount (LCY)];
                ToolTipML=[DAN=Angiver bel›bet i finansposten i den lokale valuta.;
                           ENU=Specifies the amount of the ledger entry, in the local currency.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[7].Amount;
                AutoFormatType=1;
                Editable=FALSE }

    { 46  ;4   ;Field     ;
                CaptionML=[DAN=Avancebel›b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver den avance, der er relateret til bilaget, i den lokale valuta.;
                           ENU=Specifies the profit related to the service document, in local currency.];
                ApplicationArea=#Service;
                SourceExpr=ProfitLCY[7];
                AutoFormatType=1;
                Editable=FALSE }

    { 51  ;4   ;Field     ;
                CaptionML=[DAN=Avancebel›b (RV);
                           ENU=Profit (LCY)];
                ToolTipML=[DAN=Angiver den avance, der er relateret til bilaget, i den lokale valuta.;
                           ENU=Specifies the profit related to the service document, in local currency.];
                ApplicationArea=#Service;
                SourceExpr=AdjProfitLCY[7];
                AutoFormatType=1;
                Editable=FALSE }

    { 50  ;4   ;Field     ;
                CaptionML=[DAN=Avancepct.;
                           ENU=Profit %];
                ToolTipML=[DAN=Angiver avancebel›bet i procent af det fakturerede bel›b.;
                           ENU=Specifies the amount of profit as percentage of the invoiced amount.];
                ApplicationArea=#Service;
                DecimalPlaces=1:1;
                SourceExpr=ProfitPct[7];
                Editable=FALSE }

    { 64  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 42  ;4   ;Field     ;
                CaptionML=[DAN=Kostbel›b (RV);
                           ENU=Cost (LCY)];
                ToolTipML=[DAN=Angiver det samlede kostbel›b i RV.;
                           ENU=Specifies the total cost of the service in LCY.];
                ApplicationArea=#Service;
                SourceExpr=TotalServLineLCY[7]."Unit Cost (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 87  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 99  ;4   ;Field     ;
                ApplicationArea=#Service;
                SourceExpr=Text006;
                Visible=FALSE }

    { 1903289601;1;Group  ;
                CaptionML=[DAN=Debitor;
                           ENU=Customer] }

    { 67  ;2   ;Field     ;
                CaptionML=[DAN=Saldo (RV);
                           ENU=Balance (LCY)];
                ToolTipML=[DAN=Angiver saldoen i RV p† debitorens konto.;
                           ENU=Specifies the balance in LCY on the customer's account.];
                ApplicationArea=#Service;
                SourceExpr=Cust."Balance (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 68  ;2   ;Field     ;
                Name=Credit Limit (LCY);
                CaptionML=[DAN=Kreditmaksimum (RV);
                           ENU=Credit Limit (LCY)];
                ToolTipML=[DAN=Angiver oplysninger om debitorens kreditmaksimum.;
                           ENU=Specifies information about the customer's credit limit.];
                ApplicationArea=#Service;
                SourceExpr=Cust."Credit Limit (LCY)";
                AutoFormatType=1;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
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
      Text002@1002 : TextConst 'DAN=Bel›b;ENU=Amount';
      Text003@1003 : TextConst 'DAN=%1 m† ikke v‘re 0.;ENU=%1 must not be 0.';
      Text004@1004 : TextConst 'DAN=%1 m† ikke v‘re st›rre end %2.;ENU=%1 must not be greater than %2.';
      Text005@1005 : TextConst '@@@=You cannot change the invoice discount because there is a Cust. Invoice Disc. record for Invoice Disc. Code 10000.;DAN=Du kan ikke ‘ndre fakturarabatten, fordi der findes en record af typen %1 for %2 %3.;ENU=You cannot change the invoice discount because there is a %1 record for %2 %3.';
      TotalServLine@1006 : ARRAY [7] OF Record 5902;
      TotalServLineLCY@1007 : ARRAY [7] OF Record 5902;
      Cust@1008 : Record 18;
      TempVATAmountLine@1009 : TEMPORARY Record 290;
      SalesSetup@1010 : Record 311;
      ServAmtsMgt@1011 : Codeunit 5986;
      TotalAmount1@1012 : ARRAY [7] OF Decimal;
      TotalAmount2@1013 : ARRAY [7] OF Decimal;
      AdjProfitPct@1025 : ARRAY [7] OF Decimal;
      AdjProfitLCY@1024 : ARRAY [7] OF Decimal;
      TotalAdjCostLCY@1023 : ARRAY [7] OF Decimal;
      VATAmount@1014 : ARRAY [7] OF Decimal;
      VATAmountText@1015 : ARRAY [7] OF Text[30];
      ProfitLCY@1016 : ARRAY [7] OF Decimal;
      ProfitPct@1017 : ARRAY [7] OF Decimal;
      CreditLimitLCYExpendedPct@1018 : Decimal;
      i@1022 : Integer;
      PrevNo@1019 : Code[20];
      AllowInvDisc@1020 : Boolean;
      AllowVATDifference@1021 : Boolean;
      Text006@1026 : TextConst 'DAN=Pladsholder;ENU=Placeholder';

    LOCAL PROCEDURE UpdateHeaderInfo@5(IndexNo@1003 : Integer;VAR VATAmountLine@1002 : Record 290);
    VAR
      CurrExchRate@1000 : Record 330;
      UseDate@1001 : Date;
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
      IF TotalServLineLCY[IndexNo].Amount = 0 THEN
        ProfitPct[IndexNo] := 0
      ELSE
        ProfitPct[IndexNo] := ROUND(100 * ProfitLCY[IndexNo] / TotalServLineLCY[IndexNo].Amount,0.1);

      AdjProfitLCY[IndexNo] := TotalServLineLCY[IndexNo].Amount - TotalAdjCostLCY[IndexNo];
      IF TotalServLineLCY[IndexNo].Amount = 0 THEN
        AdjProfitPct[IndexNo] := 0
      ELSE
        AdjProfitPct[IndexNo] := ROUND(100 * AdjProfitLCY[IndexNo] / TotalServLineLCY[IndexNo].Amount,0.1);
    END;

    LOCAL PROCEDURE GetVATSpecification@21();
    BEGIN
      CurrPage.SubForm.PAGE.GetTempVATAmountLine(TempVATAmountLine);
      UpdateHeaderInfo(1,TempVATAmountLine);
    END;

    LOCAL PROCEDURE SetVATSpecification@11();
    BEGIN
      CurrPage.SubForm.PAGE.SetServHeader := Rec;
      CurrPage.SubForm.PAGE.SetTempVATAmountLine(TempVATAmountLine);
      CurrPage.SubForm.PAGE.InitGlobals(
        "Currency Code",AllowVATDifference,AllowVATDifference,
        "Prices Including VAT",AllowInvDisc,"VAT Base Discount %");
    END;

    LOCAL PROCEDURE UpdateTotalAmount@16(IndexNo@1001 : Integer);
    VAR
      SaveTotalAmount@1000 : Decimal;
    BEGIN
      CheckAllowInvDisc;
      IF "Prices Including VAT" THEN BEGIN
        SaveTotalAmount := TotalAmount1[IndexNo];
        UpdateInvDiscAmount;
        TotalAmount1[IndexNo] := SaveTotalAmount;
      END;

      WITH TotalServLine[IndexNo] DO
        "Inv. Discount Amount" := "Line Amount" - TotalAmount1[IndexNo];
      UpdateInvDiscAmount;
    END;

    LOCAL PROCEDURE UpdateInvDiscAmount@3();
    VAR
      InvDiscBaseAmount@1000 : Decimal;
    BEGIN
      CheckAllowInvDisc;
      InvDiscBaseAmount := TempVATAmountLine.GetTotalInvDiscBaseAmount(FALSE,"Currency Code");
      IF InvDiscBaseAmount = 0 THEN
        ERROR(Text003,TempVATAmountLine.FIELDCAPTION("Inv. Disc. Base Amount"));

      IF TotalServLine[1]."Inv. Discount Amount" / InvDiscBaseAmount > 1 THEN
        ERROR(
          Text004,
          TotalServLine[1].FIELDCAPTION("Inv. Discount Amount"),
          TempVATAmountLine.FIELDCAPTION("Inv. Disc. Base Amount"));

      TempVATAmountLine.SetInvoiceDiscountAmount(
        TotalServLine[1]."Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");
      UpdateHeaderInfo(1,TempVATAmountLine);
      CurrPage.SubForm.PAGE.SetTempVATAmountLine(TempVATAmountLine);

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
      GetVATSpecification;
      IF TempVATAmountLine.GetAnyLineModified THEN BEGIN
        ServLine.UpdateVATOnLines(0,Rec,ServLine,TempVATAmountLine);
        ServLine.UpdateVATOnLines(1,Rec,ServLine,TempVATAmountLine);
      END;
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

    BEGIN
    END.
  }
}

