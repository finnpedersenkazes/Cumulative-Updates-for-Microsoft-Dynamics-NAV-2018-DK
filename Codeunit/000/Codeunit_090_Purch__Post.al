OBJECT Codeunit 90 Purch.-Post
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    TableNo=38;
    Permissions=TableData 36=m,
                TableData 37=m,
                TableData 39=imd,
                TableData 49=imd,
                TableData 93=imd,
                TableData 94=imd,
                TableData 110=imd,
                TableData 111=imd,
                TableData 120=imd,
                TableData 121=imd,
                TableData 122=imd,
                TableData 123=imd,
                TableData 124=imd,
                TableData 125=imd,
                TableData 223=imd,
                TableData 6507=ri,
                TableData 6508=rid,
                TableData 6650=imd,
                TableData 6651=imd;
    OnRun=VAR
            PurchHeader@1005 : Record 38;
            PurchLine@1006 : Record 39;
            TempInvoicePostBuffer@1003 : TEMPORARY Record 49;
            TempCombinedPurchLine@1035 : TEMPORARY Record 39;
            TempVATAmountLine@1036 : TEMPORARY Record 290;
            TempVATAmountLineRemainder@1037 : TEMPORARY Record 290;
            TempDropShptPostBuffer@1000 : TEMPORARY Record 223;
            UpdateAnalysisView@1002 : Codeunit 410;
            UpdateItemAnalysisView@1008 : Codeunit 7150;
            EverythingInvoiced@1026 : Boolean;
            BiggestLineNo@1021 : Integer;
            ICGenJnlLineNo@1004 : Integer;
            LineCount@1027 : Integer;
          BEGIN
            OnBeforePostPurchaseDoc(Rec);

            ValidatePostingAndDocumentDate(Rec);

            IF PreviewMode THEN BEGIN
              CLEARALL;
              PreviewMode := TRUE;
            END ELSE
              CLEARALL;

            GetGLSetup;
            GetCurrency("Currency Code");

            PurchSetup.GET;
            PurchHeader := Rec;
            FillTempLines(PurchHeader);

            // Header
            CheckAndUpdate(PurchHeader);

            TempDeferralHeader.DELETEALL;
            TempDeferralLine.DELETEALL;
            TempInvoicePostBuffer.DELETEALL;
            TempDropShptPostBuffer.DELETEALL;
            EverythingInvoiced := TRUE;

            // Lines
            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type",PurchHeader."Document Type");
            PurchLine.SETRANGE("Document No.",PurchHeader."No.");

            LineCount := 0;
            RoundingLineInserted := FALSE;
            MergePurchLines(PurchHeader,PurchLine,TempPrepmtPurchLine,TempCombinedPurchLine);
            AdjustFinalInvWith100PctPrepmt(TempCombinedPurchLine);

            TempVATAmountLineRemainder.DELETEALL;
            PurchLine.CalcVATAmountLines(1,PurchHeader,TempCombinedPurchLine,TempVATAmountLine);

            PurchaseLinesProcessed := FALSE;
            IF PurchLine.FINDFIRST THEN
              REPEAT
                ItemJnlRollRndg := FALSE;
                LineCount := LineCount + 1;
                IF GUIALLOWED THEN
                  Window.UPDATE(2,LineCount);

                PostPurchLine(
                  PurchHeader,PurchLine,TempInvoicePostBuffer,TempVATAmountLine,TempVATAmountLineRemainder,
                  TempDropShptPostBuffer,EverythingInvoiced,ICGenJnlLineNo);

                IF RoundingLineInserted THEN
                  LastLineRetrieved := TRUE
                ELSE BEGIN
                  BiggestLineNo := MAX(BiggestLineNo,PurchLine."Line No.");
                  LastLineRetrieved := GetNextPurchline(PurchLine);
                  IF LastLineRetrieved AND PurchSetup."Invoice Rounding" THEN
                    InvoiceRounding(PurchHeader,PurchLine,FALSE,BiggestLineNo);
                END;
              UNTIL LastLineRetrieved;

            IF PurchHeader.IsCreditDocType THEN BEGIN
              ReverseAmount(TotalPurchLine);
              ReverseAmount(TotalPurchLineLCY);
            END;

            // Post combine shipment of sales order
            PostCombineSalesOrderShipment(PurchHeader,TempDropShptPostBuffer);

            IF PurchHeader.Invoice THEN
              PostGLAndVendor(PurchHeader,TempInvoicePostBuffer);

            IF ICGenJnlLineNo > 0 THEN
              PostICGenJnl;

            MakeInventoryAdjustment;
            UpdateLastPostingNos(PurchHeader);
            FinalizePosting(PurchHeader,TempDropShptPostBuffer,EverythingInvoiced);

            Rec := PurchHeader;

            IF NOT InvtPickPutaway THEN BEGIN
              COMMIT;
              UpdateAnalysisView.UpdateAll(0,TRUE);
              UpdateItemAnalysisView.UpdateAll(0,TRUE);
            END;

            OnAfterPostPurchaseDoc(
              Rec,GenJnlPostLine,PurchRcptHeader."No.",ReturnShptHeader."No.",PurchInvHeader."No.",PurchCrMemoHeader."No.");
          END;

  }
  CODE
  {
    VAR
      NothingToPostErr@1000 : TextConst 'DAN=Der er intet at bogf�re.;ENU=There is nothing to post.';
      DropShipmentErr@1001 : TextConst 'DAN=En direkte levering fra en k�bsordre kan ikke modtages og faktureres samtidig.;ENU=A drop shipment from a purchase order cannot be received and invoiced at the same time.';
      PostingLinesMsg@1004 : TextConst '@@@=Counter;DAN=Linjerne bogf�res          #2######\;ENU=Posting lines              #2######\';
      PostingPurchasesAndVATMsg@1005 : TextConst '@@@=Counter;DAN=K�b og moms bogf�res       #3######\;ENU=Posting purchases and VAT  #3######\';
      PostingVendorsMsg@1006 : TextConst '@@@=Counter;DAN=Kreditorerne bogf�res      #4######\;ENU=Posting to vendors         #4######\';
      PostingBalAccountMsg@1007 : TextConst '@@@=Counter;DAN=Bogf�rer p� modkonto       #5######;ENU=Posting to bal. account    #5######';
      PostingLines2Msg@1008 : TextConst '@@@=Counter;DAN=Linjerne bogf�res          #2######;ENU=Posting lines         #2######';
      InvoiceNoMsg@1009 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = Invoice No.";DAN=%1 %2 -> Faktura %3;ENU=%1 %2 -> Invoice %3';
      CreditMemoNoMsg@1010 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = Credit Memo No.";DAN=%1 %2 -> kreditnota %3;ENU=%1 %2 -> Credit Memo %3';
      CannotInvoiceBeforeAssosSalesOrderErr@1002 : TextConst '@@@="%1 = Document No.";DAN=Du kan ikke fakturere denne k�bsordre, f�r de tilknyttede salgsordrer er blevet faktureret. Fakturer salgsordren %1, f�r den tilknyttede k�bsordre faktureres.;ENU=You cannot invoice this purchase order before the associated sales orders have been invoiced. Please invoice sales order %1 before invoicing this purchase order.';
      ReceiptSameSignErr@1011 : TextConst 'DAN=skal have samme fortegn som k�bsleverancen;ENU=must have the same sign as the receipt';
      ReceiptLinesDeletedErr@1012 : TextConst 'DAN=K�bsleverancelinjerne er slettet.;ENU=Receipt lines have been deleted.';
      CannotPurchaseResourcesErr@1013 : TextConst 'DAN=Du kan ikke k�be ressourcer.;ENU=You cannot purchase resources.';
      PurchaseAlreadyExistsErr@1014 : TextConst '@@@="%1 = Document Type, %2 = Document No.";DAN=K�b %1 %2 findes allerede for denne kreditor.;ENU=Purchase %1 %2 already exists for this vendor.';
      InvoiceMoreThanReceivedErr@1015 : TextConst '@@@="%1 = Order No.";DAN=Du kan ikke fakturere ordre %1 for mere, end der er modtaget.;ENU=You cannot invoice order %1 for more than you have received.';
      CannotPostBeforeAssosSalesOrderErr@1016 : TextConst '@@@="%1 = Sales Order No.";DAN=Du kan ikke bogf�re denne k�bsordre, f�r de tilknyttede salgsordrer er blevet faktureret. Bogf�r salgsordren %1, f�r den tilknyttede k�bsordre bogf�res.;ENU=You cannot post this purchase order before the associated sales orders have been invoiced. Post sales order %1 before posting this purchase order.';
      ExtDocNoNeededErr@1183 : TextConst '@@@="%1 = Field caption of e.g. Vendor Invoice No.";DAN=Du skal indtaste bilagsnummeret for bilaget fra kreditoren i feltet %1, s�ledes at dette bilag bliver ved med at v�re knyttet til originalen.;ENU=You need to enter the document number of the document from the vendor in the %1 field, so that this document stays linked to the original.';
      VATAmountTxt@1017 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      VATRateTxt@1018 : TextConst '@@@="%1 = VAT Rate";DAN=%1% moms;ENU=%1% VAT';
      BlanketOrderQuantityGreaterThanErr@1019 : TextConst '@@@="%1 = Quantity";DAN=i den tilknyttede rammeordre m� ikke v�re st�rre end %1.;ENU=in the associated blanket order must not be greater than %1';
      BlanketOrderQuantityReducedErr@1020 : TextConst 'DAN=i den tilknyttede rammeordre skal reduceres;ENU=in the associated blanket order must be reduced';
      ReceiveInvoiceShipErr@1021 : TextConst 'DAN=Tast "Ja" i Modtag og/eller Fakturer og/eller Lever.;ENU=Please enter "Yes" in Receive and/or Invoice and/or Ship.';
      WarehouseRequiredErr@1022 : TextConst '@@@="%1/%2 = Document Type, %3/%4 - Document No.,%5/%6 = Line No.";DAN="Der kr�ves lagerekspedition for %1 = %2, %3 = %4, %5 = %6.";ENU="Warehouse handling is required for %1 = %2, %3 = %4, %5 = %6."';
      ReturnShipmentSamesSignErr@1024 : TextConst 'DAN=skal have samme fortegn som returvareleverancen;ENU=must have the same sign as the return shipment';
      ReturnShipmentInvoicedErr@1025 : TextConst '@@@="%1 = Line No., %2 = Document No.";DAN=Linje %1 i returvarekvitteringen %2, som du fors�ger at fakturere, er allerede blevet faktureret.;ENU=Line %1 of the return shipment %2, which you are attempting to invoice, has already been invoiced.';
      ReceiptInvoicedErr@1026 : TextConst '@@@="%1 = Line No., %2 = Document No.";DAN=Linje %1 i kvitteringen %2, som du fors�ger at fakturere, er allerede blevet faktureret.;ENU=Line %1 of the receipt %2, which you are attempting to invoice, has already been invoiced.';
      QuantityToInvoiceGreaterErr@1027 : TextConst '@@@="%1 = Receipt No.";DAN=Det antal, som du fors�ger at fakturere, er st�rre end antallet p� kvitteringen %1.;ENU=The quantity you are attempting to invoice is greater than the quantity in receipt %1.';
      DimensionIsBlockedErr@1028 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = Error text";DAN=Kombinationen af dimensioner, der bliver brugt i %1 %2, er sp�rret (Fejl: %3).;ENU=The combination of dimensions used in %1 %2 is blocked (Error: %3).';
      LineDimensionBlockedErr@1029 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = LineNo., %4 = Error text";DAN=Kombinationen af de dimensioner, der bliver brugt i %1 %2, linjenr. %3, er sp�rret (Fejl: %4).;ENU=The combination of dimensions used in %1 %2, line no. %3 is blocked (Error: %4).';
      InvalidDimensionsErr@1030 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = Error text";DAN=De dimensioner, der bliver brugt i %1 %2, er ugyldige (Fejl: %3).;ENU=The dimensions used in %1 %2 are invalid (Error: %3).';
      LineInvalidDimensionsErr@1031 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = LineNo., %4 = Error text";DAN=De dimensioner, der bliver brugt i %1 %2 linjenr. %3, er ugyldige (Fejl: %4).;ENU=The dimensions used in %1 %2, line no. %3 are invalid (Error: %4).';
      CannotAssignMoreErr@1032 : TextConst '@@@="%1 = Quantity, %2/%3 = Document Type, %4/%5 - Document No.,%6/%7 = Line No.";DAN="Du kan ikke tildele mere end %1 enheder i %2 = %3,%4 = %5,%6 = %7.";ENU="You cannot assign more than %1 units in %2 = %3,%4 = %5,%6 = %7."';
      MustAssignErr@1033 : TextConst 'DAN=Du skal tildele alle varegebyrer, hvis du fakturerer alt.;ENU=You must assign all item charges, if you invoice everything.';
      CannotAssignInvoicedErr@1034 : TextConst '@@@="%1 = Purchase Line, %2/%3 = Document Type, %4/%5 - Document No.,%6/%7 = Line No.";DAN="Du kan ikke tildele varegebyrer til %1 %2 = %3,%4 = %5, %6 = %7, fordi det er blevet faktureret.";ENU="You cannot assign item charges to the %1 %2 = %3,%4 = %5, %6 = %7, because it has been invoiced."';
      PurchSetup@1037 : Record 312;
      GLSetup@1038 : Record 98;
      GLEntry@1039 : Record 17;
      TempPurchLineGlobal@1040 : TEMPORARY Record 39;
      JobPurchLine@1169 : Record 39;
      TotalPurchLine@1043 : Record 39;
      TotalPurchLineLCY@1044 : Record 39;
      xPurchLine@1046 : Record 39;
      PurchLineACY@1047 : Record 39;
      TempPrepmtPurchLine@1167 : TEMPORARY Record 39;
      PurchRcptHeader@1048 : Record 120;
      PurchInvHeader@1050 : Record 122;
      PurchCrMemoHeader@1052 : Record 124;
      ReturnShptHeader@1054 : Record 6650;
      ReturnShptLine@1055 : Record 6651;
      SalesShptHeader@1058 : Record 110;
      SalesShptLine@1059 : Record 111;
      ItemChargeAssgntPurch@1045 : Record 5805;
      TempItemChargeAssgntPurch@1060 : TEMPORARY Record 5805;
      SourceCodeSetup@1065 : Record 242;
      Currency@1073 : Record 4;
      VendLedgEntry@1075 : Record 25;
      WhseRcptHeader@1023 : Record 7316;
      TempWhseRcptHeader@1142 : TEMPORARY Record 7316;
      WhseShptHeader@1143 : Record 7320;
      TempWhseShptHeader@1145 : TEMPORARY Record 7320;
      PostedWhseRcptHeader@1140 : Record 7318;
      PostedWhseRcptLine@1146 : Record 7319;
      PostedWhseShptHeader@1147 : Record 7322;
      PostedWhseShptLine@1151 : Record 7323;
      Location@1085 : Record 14;
      TempHandlingSpecification@1094 : TEMPORARY Record 336;
      TempTrackingSpecification@1137 : TEMPORARY Record 336;
      TempTrackingSpecificationInv@1158 : TEMPORARY Record 336;
      TempWhseSplitSpecification@1160 : TEMPORARY Record 336;
      TempValueEntryRelation@5555 : TEMPORARY Record 6508;
      Job@1093 : Record 167;
      TempICGenJnlLine@11093 : TEMPORARY Record 81;
      TempPrepmtDeductLCYPurchLine@1190 : TEMPORARY Record 39;
      TempSKU@1081 : TEMPORARY Record 5700;
      DeferralPostBuffer@1049 : ARRAY [2] OF Record 1703;
      TempDeferralHeader@1003 : TEMPORARY Record 1701;
      TempDeferralLine@1035 : TEMPORARY Record 1702;
      GenJnlPostLine@1087 : Codeunit 12;
      ItemJnlPostLine@1089 : Codeunit 22;
      SalesTaxCalculate@1091 : Codeunit 398;
      ReservePurchLine@1092 : Codeunit 99000834;
      ApprovalsMgmt@1250 : Codeunit 1535;
      WhsePurchRelease@1097 : Codeunit 5772;
      SalesPost@1101 : Codeunit 80;
      ItemTrackingMgt@1138 : Codeunit 6500;
      WhseJnlPostLine@1100 : Codeunit 7301;
      WhsePostRcpt@1148 : Codeunit 5760;
      WhsePostShpt@1149 : Codeunit 5763;
      CostCalcMgt@1162 : Codeunit 5836;
      JobPostLine@1172 : Codeunit 1001;
      ServItemMgt@1063 : Codeunit 5920;
      DeferralUtilities@1051 : Codeunit 1720;
      Window@1102 : Dialog;
      Usedate@1104 : Date;
      GenJnlLineDocNo@1105 : Code[20];
      GenJnlLineExtDocNo@1106 : Code[35];
      SrcCode@1107 : Code[10];
      ItemLedgShptEntryNo@1108 : Integer;
      GenJnlLineDocType@1110 : Integer;
      FALineNo@1111 : Integer;
      RoundingLineNo@1112 : Integer;
      DeferralLineNo@1053 : Integer;
      InvDefLineNo@1064 : Integer;
      RemQtyToBeInvoiced@1114 : Decimal;
      RemQtyToBeInvoicedBase@1115 : Decimal;
      RemAmt@1135 : Decimal;
      RemDiscAmt@1136 : Decimal;
      LastLineRetrieved@1119 : Boolean;
      RoundingLineInserted@1120 : Boolean;
      DropShipOrder@1121 : Boolean;
      GLSetupRead@1130 : Boolean;
      InvoiceGreaterThanReturnShipmentErr@1098 : TextConst '@@@="%1 = Return Shipment No.";DAN=Det antal, som du fors�ger at fakturere, er st�rre end antallet p� returvarekvitteringen %1.;ENU=The quantity you are attempting to invoice is greater than the quantity in return shipment %1.';
      ReturnShipmentLinesDeletedErr@1099 : TextConst 'DAN=K�bsreturvarekvitteringslinjer er blevet slettet.;ENU=Return shipment lines have been deleted.';
      InvoiceMoreThanShippedErr@1132 : TextConst '@@@="%1 = Order No.";DAN=Du kan ikke fakturere returvareordren %1 for mere end du har leveret.;ENU=You cannot invoice return order %1 for more than you have shipped.';
      RelatedItemLedgEntriesNotFoundErr@1165 : TextConst 'DAN=Relaterede vareposter blev ikke fundet.;ENU=Related item ledger entries cannot be found.';
      ItemTrackingWrongSignErr@1173 : TextConst 'DAN=Signering af varesporing er ugyldig.;ENU=Item Tracking is signed wrongly.';
      ItemTrackingMismatchErr@1163 : TextConst 'DAN=Varesporing stemmer ikke overens.;ENU=Item Tracking does not match.';
      PostingDateNotAllowedErr@1155 : TextConst 'DAN=er ikke inden for den tilladte bogf�ringsperiode;ENU=is not within your range of allowed posting dates';
      ItemTrackQuantityMismatchErr@1144 : TextConst '@@@="%1 = Quantity";DAN=%1 stemmer ikke overens med det antal, der er angivet i varesporing.;ENU=The %1 does not match the quantity defined in item tracking.';
      CannotBeGreaterThanErr@1141 : TextConst '@@@="%1 = Amount";DAN=m� ikke v�re st�rre end %1.;ENU=cannot be more than %1.';
      CannotBeSmallerThanErr@1129 : TextConst '@@@="%1 = Amount";DAN=skal mindst v�re %1.;ENU=must be at least %1.';
      ItemJnlRollRndg@1134 : Boolean;
      WhseReceive@1113 : Boolean;
      WhseShip@1150 : Boolean;
      InvtPickPutaway@1154 : Boolean;
      PositiveWhseEntrycreated@1191 : Boolean;
      PrepAmountToDeductToBigErr@1177 : TextConst '@@@="%1 = Prepmt Amt to Deduct, %2 = Max Amount";DAN=Den samlede %1 m� ikke v�re mere end %2.;ENU=The total %1 cannot be more than %2.';
      PrepAmountToDeductToSmallErr@1178 : TextConst '@@@="%1 = Prepmt Amt to Deduct, %2 = Max Amount";DAN=Den samlede %1 skal mindst v�re %2.;ENU=The total %1 must be at least %2.';
      UnpostedInvoiceDuplicateQst@1175 : TextConst '@@@="%1 = Order No.,%2 = Invoice No.";DAN=Der findes en ikkebogf�rt faktura for ordren %1. Slet ordren %1 eller fakturaen %2 for at undg� dobbelt bogf�ring.\Vil du stadig bogf�re ordren %1?;ENU=An unposted invoice for order %1 exists. To avoid duplicate postings, delete order %1 or invoice %2.\Do you still want to post order %1?';
      InvoiceDuplicateInboxQst@1176 : TextConst '@@@="%1 = Order No.";DAN=Der er en faktura for ordren %1 i IC-indbakken. Slet fakturaen %2 i IC-indbakken for at undg� dobbelt bogf�ring.\Vil du stadig bogf�re ordren %1?;ENU=An invoice for order %1 exists in the IC inbox. To avoid duplicate postings, cancel invoice %2 in the IC inbox.\Do you still want to post order %1?';
      PostedInvoiceDuplicateQst@1179 : TextConst '@@@="%1 = Invoice No., %2 = Order No.";DAN=Den bogf�rte faktura %1 findes allerede for ordren %2. Undlad at bogf�re ordren %2, hvis du vil undg� dobbelt bogf�ring.\Vil du stadig bogf�re ordren %2?;ENU=Posted invoice %1 already exists for order %2. To avoid duplicate postings, do not post order %2.\Do you still want to post order %2?';
      OrderFromSameTransactionQst@1180 : TextConst '@@@="%1 = Order No., %2 = Invoice No.";DAN=Ordren %1 stammer fra samme IC-transaktion som fakturaen %2. Slet ordren %1 eller fakturaen %2 for at undg� dobbelt bogf�ring.\Vil du stadig bogf�re fakturaen %2?;ENU=Order %1 originates from the same IC transaction as invoice %2. To avoid duplicate postings, delete order %1 or invoice %2.\Do you still want to post invoice %2?';
      DocumentFromSameTransactionQst@1181 : TextConst '@@@="%1 and %2 = Document No.";DAN=Der er et dokument i IC-indbakken, der stammer fra samme IC-transaktion som dokumentet %1. Annuller dokumentet %2 i IC-indbakken for at undg� dobbelt bogf�ring.\Vil du stadig bogf�re dokumentet %1?;ENU=A document originating from the same IC transaction as document %1 exists in the IC inbox. To avoid duplicate postings, cancel document %2 in the IC inbox.\Do you still want to post document %1?';
      PostedInvoiceFromSameTransactionQst@1182 : TextConst '@@@="%1 and %2 = Invoice No.";DAN=" Den bogf�rte faktura %1 stammer fra samme IC-transaktion som fakturaen %2. Undlad at bogf�re fakturaen %2, hvis du vil undg� dobbelt bogf�ring.\Vil du stadig bogf�re fakturaen %2?";ENU=Posted invoice %1 originates from the same IC transaction as invoice %2. To avoid duplicate postings, do not post invoice %2.\Do you still want to post invoice %2?';
      MustAssignItemChargeErr@1102601000 : TextConst '@@@="%1 = Item Charge No.";DAN=Du skal angive varegebyr %1, hvis du vil fakturere det.;ENU=You must assign item charge %1 if you want to invoice it.';
      CannotInvoiceItemChargeErr@1102601001 : TextConst '@@@="%1 = Item Charge No.";DAN=Du kan ikke fakturere varegebyr %1, da der ikke findes en varepost, som det kan tilknyttes.;ENU=You can not invoice item charge %1 because there is no item ledger entry to assign it to.';
      PurchaseLinesProcessed@1080 : Boolean;
      ReservationDisruptedQst@1200 : TextConst '@@@="One or more reservation entries exist for the item with No. = 1000, Location Code = SILVER, Variant Code = NEW which may be disrupted if you post this negative adjustment. Do you want to continue?";DAN="Der findes en eller flere reservationsposter til varen %1 = %2, %3 = %4, %5 = %6, som kan blive afbrudt, hvis du bogf�rer denne nedregulering. Vil du forts�tte?";ENU="One or more reservation entries exist for the item with %1 = %2, %3 = %4, %5 = %6 which may be disrupted if you post this negative adjustment. Do you want to continue?"';
      ReassignItemChargeErr@1199 : TextConst 'DAN=Ordrelinjen, som varegebyret oprindeligt blev knyttet til, er blevet fuldt bogf�rt. Du skal tilknytte varegebyret til den bogf�rte kvittering eller leverance igen.;ENU=The order line that the item charge was originally assigned to has been fully posted. You must reassign the item charge to the posted receipt or shipment.';
      PreviewMode@1036 : Boolean;
      NoDeferralScheduleErr@1068 : TextConst '@@@="%1=The item number of the sales transaction line, %2=The Deferral Template Code";DAN=Du skal oprette en periodiseringsplan, fordi du har angivet periodiseringskoden %2 i linje %1.;ENU=You must create a deferral schedule because you have specified the deferral code %2 in line %1.';
      ZeroDeferralAmtErr@1067 : TextConst '@@@="%1=The item number of the sales transaction line, %2=The Deferral Template Code";DAN=Periodiseringsbel�b m� ikke v�re 0. Linje: %1, periodiseringsskabelon: %2.;ENU=Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.';
      MixedDerpFAUntilPostingDateErr@1268 : TextConst '@@@=%1 - Fixed Asset No.;DAN=V�rdien i feltet Afskriv til bogf�ringsdato for anl�g skal v�re den samme i linjerne for samme anl�gsaktiv %1.;ENU=The value in the Depr. Until FA Posting Date field must be the same on lines for the same fixed asset %1.';
      CannotPostSameMultipleFAWhenDeprBookValueZeroErr@1274 : TextConst '@@@=%1 - Fixed Asset No.;DAN=Du kan ikke markere afkrydsningsfeltet Afskriv til bogf�ringsdato for anl�g, da der ikke er en tidligere anskaffelsespost for anl�gsaktivet %1.\\Hvis du vil afskrive nye anskaffelser, kan du markere afkrydsningsfeltet Afskriv anskaffelse i stedet.;ENU=You cannot select the Depr. Until FA Posting Date check box because there is no previous acquisition entry for fixed asset %1.\\If you want to depreciate new acquisitions, you can select the Depr. Acquisition Cost check box instead.';

    LOCAL PROCEDURE CopyToTempLines@174(PurchHeader@1001 : Record 38);
    VAR
      PurchLine@1000 : Record 39;
    BEGIN
      PurchLine.SETRANGE("Document Type",PurchHeader."Document Type");
      PurchLine.SETRANGE("Document No.",PurchHeader."No.");
      IF PurchLine.FINDSET THEN
        REPEAT
          TempPurchLineGlobal := PurchLine;
          TempPurchLineGlobal.INSERT;
        UNTIL PurchLine.NEXT = 0;
    END;

    LOCAL PROCEDURE FillTempLines@36(PurchHeader@1000 : Record 38);
    BEGIN
      TempPurchLineGlobal.RESET;
      IF TempPurchLineGlobal.ISEMPTY THEN
        CopyToTempLines(PurchHeader);
    END;

    LOCAL PROCEDURE ModifyTempLine@171(VAR TempPurchLineLocal@1000 : TEMPORARY Record 39);
    VAR
      PurchLine@1001 : Record 39;
    BEGIN
      TempPurchLineLocal.MODIFY;
      PurchLine := TempPurchLineLocal;
      PurchLine.MODIFY;
    END;

    LOCAL PROCEDURE RefreshTempLines@172(PurchHeader@1000 : Record 38);
    BEGIN
      TempPurchLineGlobal.RESET;
      TempPurchLineGlobal.DELETEALL;
      CopyToTempLines(PurchHeader);
    END;

    LOCAL PROCEDURE ResetTempLines@131(VAR TempPurchLineLocal@1000 : TEMPORARY Record 39);
    BEGIN
      TempPurchLineLocal.RESET;
      TempPurchLineLocal.COPY(TempPurchLineGlobal,TRUE);
    END;

    LOCAL PROCEDURE CalcInvoice@118(VAR PurchHeader@1000 : Record 38) NewInvoice : Boolean;
    VAR
      TempPurchLine@1001 : TEMPORARY Record 39;
    BEGIN
      WITH PurchHeader DO BEGIN
        ResetTempLines(TempPurchLine);
        TempPurchLine.SETFILTER(Quantity,'<>0');
        IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
          TempPurchLine.SETFILTER("Qty. to Invoice",'<>0');
        NewInvoice := NOT TempPurchLine.ISEMPTY;
        IF NewInvoice THEN
          CASE "Document Type" OF
            "Document Type"::Order:
              IF NOT Receive THEN BEGIN
                TempPurchLine.SETFILTER("Qty. Rcd. Not Invoiced",'<>0');
                NewInvoice := NOT TempPurchLine.ISEMPTY;
              END;
            "Document Type"::"Return Order":
              IF NOT Ship THEN BEGIN
                TempPurchLine.SETFILTER("Return Qty. Shipped Not Invd.",'<>0');
                NewInvoice := NOT TempPurchLine.ISEMPTY;
              END;
          END;
      END;
      EXIT(NewInvoice);
    END;

    LOCAL PROCEDURE CalcInvDiscount@134(VAR PurchHeader@1000 : Record 38);
    VAR
      PurchLine@1001 : Record 39;
      TempInvoice@1004 : Boolean;
      TempRcpt@1003 : Boolean;
      TempReturn@1002 : Boolean;
    BEGIN
      WITH PurchHeader DO BEGIN
        IF NOT (PurchSetup."Calc. Inv. Discount" AND (Status <> Status::Open)) THEN
          EXIT;

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.FINDFIRST;
        TempInvoice := Invoice;
        TempRcpt := Receive;
        TempReturn := Ship;
        CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount",PurchLine);
        GET("Document Type","No.");
        Invoice := TempInvoice;
        Receive := TempRcpt;
        Ship := TempReturn;
        IF NOT PreviewMode THEN
          COMMIT;
      END;
    END;

    LOCAL PROCEDURE CheckAndUpdate@147(VAR PurchHeader@1000 : Record 38);
    VAR
      GenJnlCheckLine@1001 : Codeunit 11;
      ModifyHeader@1003 : Boolean;
    BEGIN
      WITH PurchHeader DO BEGIN
        // Check
        CheckMandatoryHeaderFields(PurchHeader);
        IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
          FIELDERROR("Posting Date",PostingDateNotAllowedErr);

        SetPostingFlags(PurchHeader);
        InitProgressWindow(PurchHeader);

        InvtPickPutaway := "Posting from Whse. Ref." <> 0;
        "Posting from Whse. Ref." := 0;

        CheckDim(PurchHeader);

        IF Invoice THEN
          CheckFAPostingPossibility(PurchHeader);

        CheckPostRestrictions(PurchHeader);

        CheckICDocumentDuplicatePosting(PurchHeader);

        IF Invoice THEN
          Invoice := CalcInvoice(PurchHeader);

        IF Invoice THEN
          CopyAndCheckItemCharge(PurchHeader);

        IF Invoice AND NOT IsCreditDocType THEN
          TESTFIELD("Due Date");

        IF Receive THEN
          Receive := CheckTrackingAndWarehouseForReceive(PurchHeader);

        IF Ship THEN
          Ship := CheckTrackingAndWarehouseForShip(PurchHeader);

        IF NOT (Receive OR Invoice OR Ship) THEN
          ERROR(NothingToPostErr);

        IF Invoice THEN
          CheckAssosOrderLines(PurchHeader);

        IF Invoice AND PurchSetup."Ext. Doc. No. Mandatory" THEN
          CheckExtDocNo(PurchHeader);

        OnAfterCheckPurchDoc(PurchHeader);

        // Update
        IF Invoice THEN
          CreatePrepmtLines(PurchHeader,TempPrepmtPurchLine,TRUE);

        ModifyHeader := UpdatePostingNos(PurchHeader);

        DropShipOrder := UpdateAssosOrderPostingNos(PurchHeader);

        OnBeforePostCommitPurchaseDoc(PurchHeader,GenJnlPostLine,PreviewMode,ModifyHeader);
        IF NOT PreviewMode AND ModifyHeader THEN BEGIN
          MODIFY;
          COMMIT;
        END;

        CalcInvDiscount(PurchHeader);
        ReleasePurchDocument(PurchHeader);

        IF Receive OR Ship THEN
          ArchiveUnpostedOrder(PurchHeader);

        CheckICPartnerBlocked(PurchHeader);
        SendICDocument(PurchHeader,ModifyHeader);
        UpdateHandledICInboxTransaction(PurchHeader);

        LockTables;

        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup.Purchases;

        InsertPostedHeaders(PurchHeader);

        UpdateIncomingDocument("Incoming Document Entry No.","Posting Date",GenJnlLineDocNo);
      END;
    END;

    LOCAL PROCEDURE CheckExtDocNo@179(PurchaseHeader@1000 : Record 38);
    BEGIN
      WITH PurchaseHeader DO
        CASE "Document Type" OF
          "Document Type"::Order,
          "Document Type"::Invoice:
            IF "Vendor Invoice No." = '' THEN
              ERROR(ExtDocNoNeededErr,FIELDCAPTION("Vendor Invoice No."));
          ELSE
            IF "Vendor Cr. Memo No." = '' THEN
              ERROR(ExtDocNoNeededErr,FIELDCAPTION("Vendor Cr. Memo No."));
        END;
    END;

    LOCAL PROCEDURE PostPurchLine@152(PurchHeader@1001 : Record 38;VAR PurchLine@1000 : Record 39;VAR TempInvoicePostBuffer@1006 : TEMPORARY Record 49;VAR TempVATAmountLine@1005 : TEMPORARY Record 290;VAR TempVATAmountLineRemainder@1004 : TEMPORARY Record 290;VAR TempDropShptPostBuffer@1009 : TEMPORARY Record 223;VAR EverythingInvoiced@1003 : Boolean;VAR ICGenJnlLineNo@1008 : Integer);
    VAR
      PurchInvLine@1010 : Record 123;
      PurchCrMemoLine@1011 : Record 125;
      InvoicePostBuffer@1007 : Record 49;
      CostBaseAmount@1002 : Decimal;
    BEGIN
      WITH PurchLine DO BEGIN
        IF Type = Type::Item THEN
          CostBaseAmount := "Line Amount";
        UpdateQtyPerUnitOfMeasure(PurchLine);

        TestPurchLine(PurchHeader,PurchLine);
        UpdatePurchLineBeforePost(PurchHeader,PurchLine);

        IF "Qty. to Invoice" + "Quantity Invoiced" <> Quantity THEN
          EverythingInvoiced := FALSE;

        IF Quantity <> 0 THEN BEGIN
          TESTFIELD("No.");
          TESTFIELD(Type);
          TESTFIELD("Gen. Bus. Posting Group");
          TESTFIELD("Gen. Prod. Posting Group");
          DivideAmount(PurchHeader,PurchLine,1,"Qty. to Invoice",TempVATAmountLine,TempVATAmountLineRemainder);
        END ELSE
          TESTFIELD(Amount,0);

        CheckItemReservDisruption(PurchLine);
        RoundAmount(PurchHeader,PurchLine,"Qty. to Invoice");

        IF IsCreditDocType THEN BEGIN
          ReverseAmount(PurchLine);
          ReverseAmount(PurchLineACY);
        END;

        RemQtyToBeInvoiced := "Qty. to Invoice";
        RemQtyToBeInvoicedBase := "Qty. to Invoice (Base)";

        // Job Credit Memo Item Qty Check
        IF IsCreditDocType THEN
          IF ("Job No." <> '') AND (Type = Type::Item) AND ("Qty. to Invoice" <> 0) THEN
            JobPostLine.CheckItemQuantityPurchCredit(PurchHeader,PurchLine);

        PostItemTrackingLine(PurchHeader,PurchLine);

        CASE Type OF
          Type::"G/L Account":
            PostGLAccICLine(PurchHeader,PurchLine,ICGenJnlLineNo);
          Type::Item:
            PostItemLine(PurchHeader,PurchLine,TempDropShptPostBuffer);
          3:
            ERROR(CannotPurchaseResourcesErr);
          Type::"Charge (Item)":
            PostItemChargeLine(PurchHeader,PurchLine);
        END;

        IF (Type >= Type::"G/L Account") AND ("Qty. to Invoice" <> 0) THEN BEGIN
          AdjustPrepmtAmountLCY(PurchHeader,PurchLine);
          FillInvoicePostBuffer(PurchHeader,PurchLine,PurchLineACY,TempInvoicePostBuffer,InvoicePostBuffer);
          InsertPrepmtAdjInvPostingBuf(PurchHeader,PurchLine,TempInvoicePostBuffer,InvoicePostBuffer);
        END;

        IF (PurchRcptHeader."No." <> '') AND ("Receipt No." = '') AND
           NOT RoundingLineInserted AND NOT "Prepayment Line"
        THEN
          InsertReceiptLine(PurchRcptHeader,PurchLine,CostBaseAmount);

        IF (ReturnShptHeader."No." <> '') AND ("Return Shipment No." = '') AND
           NOT RoundingLineInserted
        THEN
          InsertReturnShipmentLine(ReturnShptHeader,PurchLine,CostBaseAmount);

        IF PurchHeader.Invoice THEN
          IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
            PurchInvLine.InitFromPurchLine(PurchInvHeader,xPurchLine);
            ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,COPYSTR(PurchInvLine.RowID1,1,100));
            OnBeforePurchInvLineInsert(PurchInvLine,PurchInvHeader,PurchLine);
            PurchInvLine.INSERT(TRUE);
            OnAfterPurchInvLineInsert(PurchInvLine,PurchInvHeader,PurchLine,ItemLedgShptEntryNo,WhseShip,WhseReceive);
            CreatePostedDeferralScheduleFromPurchDoc(xPurchLine,PurchInvLine.GetDocumentType,
              PurchInvHeader."No.",PurchInvLine."Line No.",PurchInvHeader."Posting Date");
          END ELSE BEGIN // Credit Memo
            PurchCrMemoLine.InitFromPurchLine(PurchCrMemoHeader,xPurchLine);
            ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,COPYSTR(PurchCrMemoLine.RowID1,1,100));
            OnBeforePurchCrMemoLineInsert(PurchCrMemoLine,PurchCrMemoHeader,PurchLine);
            PurchCrMemoLine.INSERT(TRUE);
            OnAfterPurchCrMemoLineInsert(PurchCrMemoLine,PurchCrMemoHeader,PurchLine);
            CreatePostedDeferralScheduleFromPurchDoc(xPurchLine,PurchCrMemoLine.GetDocumentType,
              PurchCrMemoHeader."No.",PurchCrMemoLine."Line No.",PurchCrMemoHeader."Posting Date");
          END;
      END;
    END;

    LOCAL PROCEDURE PostGLAndVendor@157(VAR PurchHeader@1000 : Record 38;VAR TempInvoicePostBuffer@1001 : TEMPORARY Record 49);
    BEGIN
      OnBeforePostGLAndVendor(PurchHeader,TempInvoicePostBuffer);

      WITH PurchHeader DO BEGIN
        // Post purchase and VAT to G/L entries from buffer
        PostInvoicePostingBuffer(PurchHeader,TempInvoicePostBuffer);

        // Check External Document number
        IF PurchSetup."Ext. Doc. No. Mandatory" OR (GenJnlLineExtDocNo <> '') THEN
          CheckExternalDocumentNumber(VendLedgEntry,PurchHeader);

        // Post vendor entries
        IF GUIALLOWED THEN
          Window.UPDATE(4,1);
        PostVendorEntry(
          PurchHeader,TotalPurchLine,TotalPurchLineLCY,GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);

        UpdatePurchaseHeader(VendLedgEntry);

        // Balancing account
        IF "Bal. Account No." <> '' THEN BEGIN
          IF GUIALLOWED THEN
            Window.UPDATE(5,1);
          PostBalancingEntry(
            PurchHeader,TotalPurchLine,TotalPurchLineLCY,GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);
        END;
      END;
    END;

    LOCAL PROCEDURE PostGLAccICLine@154(PurchHeader@1002 : Record 38;PurchLine@1000 : Record 39;VAR ICGenJnlLineNo@1003 : Integer);
    VAR
      GLAcc@1001 : Record 15;
    BEGIN
      IF (PurchLine."No." <> '') AND NOT PurchLine."System-Created Entry" THEN BEGIN
        GLAcc.GET(PurchLine."No.");
        GLAcc.TESTFIELD("Direct Posting");
        IF (PurchLine."Job No." <> '') AND (PurchLine."Qty. to Invoice" <> 0) THEN BEGIN
          CreateJobPurchLine(JobPurchLine,PurchLine,PurchHeader."Prices Including VAT");
          JobPostLine.PostJobOnPurchaseLine(PurchHeader,PurchInvHeader,PurchCrMemoHeader,JobPurchLine,SrcCode);
        END;
        IF (PurchLine."IC Partner Code" <> '') AND PurchHeader.Invoice THEN
          InsertICGenJnlLine(PurchHeader,xPurchLine,ICGenJnlLineNo);

        OnAfterPostAccICLine(PurchLine);
      END;
    END;

    LOCAL PROCEDURE PostItemLine@135(PurchHeader@1000 : Record 38;VAR PurchLine@1001 : Record 39;VAR TempDropShptPostBuffer@1003 : TEMPORARY Record 223);
    VAR
      DummyTrackingSpecification@1002 : Record 336;
    BEGIN
      ItemLedgShptEntryNo := 0;
      WITH PurchHeader DO BEGIN
        IF RemQtyToBeInvoiced <> 0 THEN
          ItemLedgShptEntryNo :=
            PostItemJnlLine(
              PurchHeader,PurchLine,
              RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
              RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
              0,'',DummyTrackingSpecification);
        IF IsCreditDocType THEN BEGIN
          IF ABS(PurchLine."Return Qty. to Ship") > ABS(RemQtyToBeInvoiced) THEN
            ItemLedgShptEntryNo :=
              PostItemJnlLine(
                PurchHeader,PurchLine,
                PurchLine."Return Qty. to Ship" - RemQtyToBeInvoiced,
                PurchLine."Return Qty. to Ship (Base)" - RemQtyToBeInvoicedBase,
                0,0,0,'',DummyTrackingSpecification);
        END ELSE BEGIN
          IF ABS(PurchLine."Qty. to Receive") > ABS(RemQtyToBeInvoiced) THEN
            ItemLedgShptEntryNo :=
              PostItemJnlLine(
                PurchHeader,PurchLine,
                PurchLine."Qty. to Receive" - RemQtyToBeInvoiced,
                PurchLine."Qty. to Receive (Base)" - RemQtyToBeInvoicedBase,
                0,0,0,'',DummyTrackingSpecification);
          IF (PurchLine."Qty. to Receive" <> 0) AND (PurchLine."Sales Order Line No." <> 0) THEN BEGIN
            TempDropShptPostBuffer."Order No." := PurchLine."Sales Order No.";
            TempDropShptPostBuffer."Order Line No." := PurchLine."Sales Order Line No.";
            TempDropShptPostBuffer.Quantity := PurchLine."Qty. to Receive";
            TempDropShptPostBuffer."Quantity (Base)" := PurchLine."Qty. to Receive (Base)";
            TempDropShptPostBuffer."Item Shpt. Entry No." :=
              PostAssocItemJnlLine(PurchHeader,PurchLine,TempDropShptPostBuffer.Quantity,TempDropShptPostBuffer."Quantity (Base)");
            TempDropShptPostBuffer.INSERT;
          END;
        END;

        OnAfterPostItemLine(PurchLine);
      END;
    END;

    LOCAL PROCEDURE PostItemChargeLine@146(PurchHeader@1002 : Record 38;PurchLine@1000 : Record 39);
    VAR
      PurchaseLineBackup@1001 : Record 39;
    BEGIN
      IF NOT (PurchHeader.Invoice AND (PurchLine."Qty. to Invoice" <> 0)) THEN
        EXIT;

      ItemJnlRollRndg := TRUE;
      PurchaseLineBackup.COPY(PurchLine);
      IF FindTempItemChargeAssgntPurch(PurchaseLineBackup."Line No.") THEN
        REPEAT
          CASE TempItemChargeAssgntPurch."Applies-to Doc. Type" OF
            TempItemChargeAssgntPurch."Applies-to Doc. Type"::Receipt:
              BEGIN
                PostItemChargePerRcpt(PurchHeader,PurchaseLineBackup);
                TempItemChargeAssgntPurch.MARK(TRUE);
              END;
            TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Transfer Receipt":
              BEGIN
                PostItemChargePerTransfer(PurchHeader,PurchaseLineBackup);
                TempItemChargeAssgntPurch.MARK(TRUE);
              END;
            TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Shipment":
              BEGIN
                PostItemChargePerRetShpt(PurchHeader,PurchaseLineBackup);
                TempItemChargeAssgntPurch.MARK(TRUE);
              END;
            TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Sales Shipment":
              BEGIN
                PostItemChargePerSalesShpt(PurchHeader,PurchaseLineBackup);
                TempItemChargeAssgntPurch.MARK(TRUE);
              END;
            TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Receipt":
              BEGIN
                PostItemChargePerRetRcpt(PurchHeader,PurchaseLineBackup);
                TempItemChargeAssgntPurch.MARK(TRUE);
              END;
            TempItemChargeAssgntPurch."Applies-to Doc. Type"::Order,
            TempItemChargeAssgntPurch."Applies-to Doc. Type"::Invoice,
            TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Order",
            TempItemChargeAssgntPurch."Applies-to Doc. Type"::"Credit Memo":
              CheckItemCharge(TempItemChargeAssgntPurch);
          END;
        UNTIL TempItemChargeAssgntPurch.NEXT = 0;
    END;

    LOCAL PROCEDURE PostItemTrackingLine@159(PurchHeader@1000 : Record 38;PurchLine@1001 : Record 39);
    VAR
      TempTrackingSpecification@1003 : TEMPORARY Record 336;
      TrackingSpecificationExists@1002 : Boolean;
    BEGIN
      IF PurchLine."Prepayment Line" THEN
        EXIT;

      IF PurchHeader.Invoice THEN
        IF PurchLine."Qty. to Invoice" = 0 THEN
          TrackingSpecificationExists := FALSE
        ELSE
          TrackingSpecificationExists :=
            ReservePurchLine.RetrieveInvoiceSpecification(PurchLine,TempTrackingSpecification);

      PostItemTracking(PurchHeader,PurchLine,TempTrackingSpecification,TrackingSpecificationExists);

      IF TrackingSpecificationExists THEN
        SaveInvoiceSpecification(TempTrackingSpecification);
    END;

    LOCAL PROCEDURE PostItemJnlLine@2(PurchHeader@1019 : Record 38;PurchLine@1000 : Record 39;QtyToBeReceived@1001 : Decimal;QtyToBeReceivedBase@1002 : Decimal;QtyToBeInvoiced@1003 : Decimal;QtyToBeInvoicedBase@1004 : Decimal;ItemLedgShptEntryNo@1005 : Integer;ItemChargeNo@1006 : Code[20];TrackingSpecification@1010 : Record 336) : Integer;
    VAR
      ItemJnlLine@1008 : Record 83;
      OriginalItemJnlLine@1014 : Record 83;
      TempWhseJnlLine@1012 : TEMPORARY Record 7311;
      TempWhseTrackingSpecification@1016 : TEMPORARY Record 336;
      TempTrackingSpecificationChargeAssmt@1030 : TEMPORARY Record 336;
      CurrExchRate@1007 : Record 330;
      TempReservationEntry@1011 : TEMPORARY Record 337;
      Factor@1009 : Decimal;
      PostWhseJnlLine@1013 : Boolean;
      CheckApplToItemEntry@1015 : Boolean;
      PostJobConsumptionBeforePurch@1018 : Boolean;
    BEGIN
      IF NOT ItemJnlRollRndg THEN BEGIN
        RemAmt := 0;
        RemDiscAmt := 0;
      END;
      WITH ItemJnlLine DO BEGIN
        INIT;
        CopyFromPurchHeader(PurchHeader);
        CopyFromPurchLine(PurchLine);

        IF QtyToBeReceived = 0 THEN
          IF PurchLine.IsCreditDocType THEN
            CopyDocumentFields(
              "Document Type"::"Purchase Credit Memo",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PurchHeader."Posting No. Series")
          ELSE
            CopyDocumentFields(
              "Document Type"::"Purchase Invoice",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PurchHeader."Posting No. Series")
        ELSE BEGIN
          IF PurchLine.IsCreditDocType THEN
            CopyDocumentFields(
              "Document Type"::"Purchase Return Shipment",
              ReturnShptHeader."No.",ReturnShptHeader."Vendor Authorization No.",SrcCode,ReturnShptHeader."No. Series")
          ELSE
            CopyDocumentFields(
              "Document Type"::"Purchase Receipt",
              PurchRcptHeader."No.",PurchRcptHeader."Vendor Shipment No.",SrcCode,PurchRcptHeader."No. Series");
          IF QtyToBeInvoiced <> 0 THEN BEGIN
            IF "Document No." = '' THEN
              IF PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo" THEN
                CopyDocumentFields(
                  "Document Type"::"Purchase Credit Memo",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PurchHeader."Posting No. Series")
              ELSE
                CopyDocumentFields(
                  "Document Type"::"Purchase Invoice",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PurchHeader."Posting No. Series");
          END;
        END;

        IF QtyToBeInvoiced <> 0 THEN
          "Invoice No." := GenJnlLineDocNo;

        CopyTrackingFromSpec(TrackingSpecification);
        "Item Shpt. Entry No." := ItemLedgShptEntryNo;

        Quantity := QtyToBeReceived;
        "Quantity (Base)" := QtyToBeReceivedBase;
        "Invoiced Quantity" := QtyToBeInvoiced;
        "Invoiced Qty. (Base)" := QtyToBeInvoicedBase;

        IF ItemChargeNo <> '' THEN BEGIN
          "Item Charge No." := ItemChargeNo;
          PurchLine."Qty. to Invoice" := QtyToBeInvoiced;
        END;

        IF QtyToBeInvoiced <> 0 THEN BEGIN
          IF (QtyToBeInvoicedBase <> 0) AND (PurchLine.Type = PurchLine.Type::Item)THEN
            Factor := QtyToBeInvoicedBase / PurchLine."Qty. to Invoice (Base)"
          ELSE
            Factor := QtyToBeInvoiced / PurchLine."Qty. to Invoice";
          Amount := PurchLine.Amount * Factor + RemAmt;
          IF PurchHeader."Prices Including VAT" THEN
            "Discount Amount" :=
              (PurchLine."Line Discount Amount" + PurchLine."Inv. Discount Amount") /
              (1 + PurchLine."VAT %" / 100) * Factor + RemDiscAmt
          ELSE
            "Discount Amount" :=
              (PurchLine."Line Discount Amount" + PurchLine."Inv. Discount Amount") * Factor + RemDiscAmt;
          RemAmt := Amount - ROUND(Amount);
          RemDiscAmt := "Discount Amount" - ROUND("Discount Amount");
          Amount := ROUND(Amount);
          "Discount Amount" := ROUND("Discount Amount");
        END ELSE BEGIN
          IF PurchHeader."Prices Including VAT" THEN
            Amount :=
              (QtyToBeReceived * PurchLine."Direct Unit Cost" * (1 - PurchLine."Line Discount %" / 100) /
               (1 + PurchLine."VAT %" / 100)) + RemAmt
          ELSE
            Amount :=
              (QtyToBeReceived * PurchLine."Direct Unit Cost" * (1 - PurchLine."Line Discount %" / 100)) + RemAmt;
          RemAmt := Amount - ROUND(Amount);
          IF PurchHeader."Currency Code" <> '' THEN
            Amount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  PurchHeader."Posting Date",PurchHeader."Currency Code",
                  Amount,PurchHeader."Currency Factor"))
          ELSE
            Amount := ROUND(Amount);
        END;

        IF PurchLine."Prod. Order No." <> '' THEN
          PostItemJnlLineCopyProdOrder(PurchLine,ItemJnlLine,QtyToBeReceived,QtyToBeInvoiced);

        CheckApplToItemEntry := SetCheckApplToItemEntry(PurchLine);

        PostWhseJnlLine := ShouldPostWhseJnlLine(PurchLine,ItemJnlLine,TempWhseJnlLine);

        IF QtyToBeReceivedBase <> 0 THEN BEGIN
          IF PurchLine.IsCreditDocType THEN
            ReservePurchLine.TransferPurchLineToItemJnlLine(
              PurchLine,ItemJnlLine,-QtyToBeReceivedBase,CheckApplToItemEntry)
          ELSE
            ReservePurchLine.TransferPurchLineToItemJnlLine(
              PurchLine,ItemJnlLine,QtyToBeReceivedBase,CheckApplToItemEntry);

          IF CheckApplToItemEntry AND (NOT PurchLine.IsServiceItem) THEN
            PurchLine.TESTFIELD("Appl.-to Item Entry");
        END;

        CollectPurchaseLineReservEntries(TempReservationEntry,ItemJnlLine);
        OriginalItemJnlLine := ItemJnlLine;

        IF PurchLine."Job No." <> '' THEN BEGIN
          PostJobConsumptionBeforePurch := IsPurchaseReturn;
          IF PostJobConsumptionBeforePurch THEN
            PostItemJnlLineJobConsumption(
              PurchHeader,PurchLine,OriginalItemJnlLine,TempReservationEntry,QtyToBeInvoiced,QtyToBeReceived);
        END;

        ItemJnlPostLine.RunWithCheck(ItemJnlLine);

        IF NOT Subcontracting THEN
          PostItemJnlLineTracking(
            PurchLine,TempWhseTrackingSpecification,TempTrackingSpecificationChargeAssmt,PostWhseJnlLine,QtyToBeInvoiced);

        IF PurchLine."Job No." <> '' THEN
          IF NOT PostJobConsumptionBeforePurch THEN
            PostItemJnlLineJobConsumption(
              PurchHeader,PurchLine,OriginalItemJnlLine,TempReservationEntry,QtyToBeInvoiced,QtyToBeReceived);

        IF PostWhseJnlLine THEN BEGIN
          PostItemJnlLineWhseLine(TempWhseJnlLine,TempWhseTrackingSpecification,PurchLine,PostJobConsumptionBeforePurch);
          OnAfterPostWhseJnlLine(PurchLine,ItemLedgShptEntryNo,WhseShip,WhseReceive);
        END;
        IF (PurchLine.Type = PurchLine.Type::Item) AND PurchHeader.Invoice THEN
          PostItemJnlLineItemCharges(
            PurchHeader,PurchLine,OriginalItemJnlLine,"Item Shpt. Entry No.",TempTrackingSpecificationChargeAssmt);
      END;

      EXIT(ItemJnlLine."Item Shpt. Entry No.");
    END;

    LOCAL PROCEDURE PostItemJnlLineCopyProdOrder@166(PurchLine@1000 : Record 39;VAR ItemJnlLine@1001 : Record 83;QtyToBeReceived@1002 : Decimal;QtyToBeInvoiced@1003 : Decimal);
    BEGIN
      WITH PurchLine DO BEGIN
        ItemJnlLine.Subcontracting := TRUE;
        ItemJnlLine."Quantity (Base)" := CalcBaseQty("No.","Unit of Measure Code",QtyToBeReceived);
        ItemJnlLine."Invoiced Qty. (Base)" := CalcBaseQty("No.","Unit of Measure Code",QtyToBeInvoiced);
        ItemJnlLine."Unit Cost" := "Unit Cost (LCY)";
        ItemJnlLine."Unit Cost (ACY)" := "Unit Cost";
        ItemJnlLine."Output Quantity (Base)" := ItemJnlLine."Quantity (Base)";
        ItemJnlLine."Output Quantity" := QtyToBeReceived;
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::Output;
        ItemJnlLine.Type := ItemJnlLine.Type::"Work Center";
        ItemJnlLine."No." := "Work Center No.";
        ItemJnlLine."Routing No." := "Routing No.";
        ItemJnlLine."Routing Reference No." := "Routing Reference No.";
        ItemJnlLine."Operation No." := "Operation No.";
        ItemJnlLine."Work Center No." := "Work Center No.";
        ItemJnlLine."Unit Cost Calculation" := ItemJnlLine."Unit Cost Calculation"::Units;
        IF Finished THEN
          ItemJnlLine.Finished := Finished;
      END;
      OnAfterPostItemJnlLineCopyProdOrder(ItemJnlLine,PurchLine,PurchRcptHeader,QtyToBeReceived);
    END;

    LOCAL PROCEDURE PostItemJnlLineItemCharges@161(PurchHeader@1000 : Record 38;PurchLine@1001 : Record 39;VAR OriginalItemJnlLine@1003 : Record 83;ItemShptEntryNo@1004 : Integer;VAR TempTrackingSpecificationChargeAssmt@1005 : TEMPORARY Record 336);
    VAR
      ItemChargePurchLine@1002 : Record 39;
    BEGIN
      WITH PurchLine DO BEGIN
        ClearItemChargeAssgntFilter;
        TempItemChargeAssgntPurch.SETCURRENTKEY(
          "Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type","Document Type");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.","Document No.");
        TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.","Line No.");
        IF TempItemChargeAssgntPurch.FIND('-') THEN
          REPEAT
            TESTFIELD("Allow Item Charge Assignment");
            GetItemChargeLine(PurchHeader,ItemChargePurchLine);
            ItemChargePurchLine.CALCFIELDS("Qty. Assigned");
            IF (ItemChargePurchLine."Qty. to Invoice" <> 0) OR
               (ABS(ItemChargePurchLine."Qty. Assigned") < ABS(ItemChargePurchLine."Quantity Invoiced"))
            THEN BEGIN
              OriginalItemJnlLine."Item Shpt. Entry No." := ItemShptEntryNo;
              PostItemChargePerOrder(
                PurchHeader,PurchLine,OriginalItemJnlLine,ItemChargePurchLine,TempTrackingSpecificationChargeAssmt);
              TempItemChargeAssgntPurch.MARK(TRUE);
            END;
          UNTIL TempItemChargeAssgntPurch.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE PostItemJnlLineTracking@162(PurchLine@1000 : Record 39;VAR TempWhseTrackingSpecification@1002 : TEMPORARY Record 336;VAR TempTrackingSpecificationChargeAssmt@1004 : TEMPORARY Record 336;PostWhseJnlLine@1001 : Boolean;QtyToBeInvoiced@1003 : Decimal);
    BEGIN
      IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification) THEN
        IF TempHandlingSpecification.FIND('-') THEN
          REPEAT
            TempTrackingSpecification := TempHandlingSpecification;
            TempTrackingSpecification.SetSourceFromPurchLine(PurchLine);
            IF TempTrackingSpecification.INSERT THEN;
            IF QtyToBeInvoiced <> 0 THEN BEGIN
              TempTrackingSpecificationInv := TempTrackingSpecification;
              IF TempTrackingSpecificationInv.INSERT THEN;
            END;
            IF PostWhseJnlLine THEN BEGIN
              TempWhseTrackingSpecification := TempTrackingSpecification;
              IF TempWhseTrackingSpecification.INSERT THEN;
            END;
            TempTrackingSpecificationChargeAssmt := TempTrackingSpecification;
            TempTrackingSpecificationChargeAssmt.INSERT;
          UNTIL TempHandlingSpecification.NEXT = 0;
    END;

    LOCAL PROCEDURE PostItemJnlLineWhseLine@165(VAR TempWhseJnlLine@1000 : TEMPORARY Record 7311;VAR TempWhseTrackingSpecification@1002 : TEMPORARY Record 336;PurchLine@1003 : Record 39;PostBefore@1004 : Boolean);
    VAR
      TempWhseJnlLine2@1001 : TEMPORARY Record 7311;
    BEGIN
      ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine,TempWhseJnlLine2,TempWhseTrackingSpecification,FALSE);
      IF TempWhseJnlLine2.FIND('-') THEN
        REPEAT
          IF PurchLine.IsCreditDocType AND (PurchLine.Quantity > 0) OR
             PurchLine.IsInvoiceDocType AND (PurchLine.Quantity < 0)
          THEN
            CreatePositiveEntry(TempWhseJnlLine2,PurchLine."Job No.",PostBefore);
          WhseJnlPostLine.RUN(TempWhseJnlLine2);
          IF RevertWarehouseEntry(TempWhseJnlLine2,PurchLine."Job No.",PostBefore) THEN
            WhseJnlPostLine.RUN(TempWhseJnlLine2);
        UNTIL TempWhseJnlLine2.NEXT = 0;
      TempWhseTrackingSpecification.DELETEALL;
    END;

    LOCAL PROCEDURE ShouldPostWhseJnlLine@167(PurchLine@1000 : Record 39;VAR ItemJnlLine@1001 : Record 83;VAR TempWhseJnlLine@1002 : TEMPORARY Record 7311) : Boolean;
    BEGIN
      WITH PurchLine DO
        IF ("Location Code" <> '') AND (Type = Type::Item) AND (ItemJnlLine.Quantity <> 0) AND
           NOT ItemJnlLine.Subcontracting
        THEN BEGIN
          GetLocation("Location Code");
          IF (("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) AND
              Location."Directed Put-away and Pick") OR
             (Location."Bin Mandatory" AND NOT (WhseReceive OR WhseShip OR InvtPickPutaway OR "Drop Shipment"))
          THEN BEGIN
            CreateWhseJnlLine(ItemJnlLine,PurchLine,TempWhseJnlLine);
            EXIT(TRUE);
          END;
        END;
    END;

    LOCAL PROCEDURE PostItemChargePerOrder@5801(PurchHeader@1013 : Record 38;PurchLine@1014 : Record 39;ItemJnlLine2@1001 : Record 83;ItemChargePurchLine@1002 : Record 39;VAR TempTrackingSpecificationChargeAssmt@1030 : TEMPORARY Record 336);
    VAR
      NonDistrItemJnlLine@1000 : Record 83;
      CurrExchRate@1003 : Record 330;
      OriginalAmt@1007 : Decimal;
      OriginalAmtACY@1008 : Decimal;
      OriginalDiscountAmt@1009 : Decimal;
      OriginalQty@1010 : Decimal;
      QtyToInvoice@1004 : Decimal;
      Factor@1005 : Decimal;
      TotalChargeAmt2@1011 : Decimal;
      TotalChargeAmtLCY2@1012 : Decimal;
      SignFactor@1006 : Integer;
    BEGIN
      WITH TempItemChargeAssgntPurch DO BEGIN
        PurchLine.TESTFIELD("Allow Item Charge Assignment",TRUE);
        ItemJnlLine2."Document No." := GenJnlLineDocNo;
        ItemJnlLine2."External Document No." := GenJnlLineExtDocNo;
        ItemJnlLine2."Item Charge No." := "Item Charge No.";
        ItemJnlLine2.Description := ItemChargePurchLine.Description;
        ItemJnlLine2."Document Line No." := ItemChargePurchLine."Line No.";
        ItemJnlLine2."Unit of Measure Code" := '';
        ItemJnlLine2."Qty. per Unit of Measure" := 1;
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          QtyToInvoice :=
            CalcQtyToInvoice(PurchLine."Return Qty. to Ship (Base)",PurchLine."Qty. to Invoice (Base)")
        ELSE
          QtyToInvoice :=
            CalcQtyToInvoice(PurchLine."Qty. to Receive (Base)",PurchLine."Qty. to Invoice (Base)");
        IF ItemJnlLine2."Invoiced Quantity" = 0 THEN BEGIN
          ItemJnlLine2."Invoiced Quantity" := ItemJnlLine2.Quantity;
          ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
        END;
        ItemJnlLine2.Amount := "Amount to Assign" * ItemJnlLine2."Invoiced Qty. (Base)" / QtyToInvoice;
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          ItemJnlLine2.Amount := -ItemJnlLine2.Amount;
        ItemJnlLine2."Unit Cost (ACY)" :=
          ROUND(
            ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
            Currency."Unit-Amount Rounding Precision");

        TotalChargeAmt2 := TotalChargeAmt2 + ItemJnlLine2.Amount;
        IF PurchHeader."Currency Code" <> '' THEN
          ItemJnlLine2.Amount :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              Usedate,PurchHeader."Currency Code",TotalChargeAmt2 + TotalPurchLine.Amount,PurchHeader."Currency Factor") -
            TotalChargeAmtLCY2 - TotalPurchLineLCY.Amount
        ELSE
          ItemJnlLine2.Amount := TotalChargeAmt2 - TotalChargeAmtLCY2;

        TotalChargeAmtLCY2 := TotalChargeAmtLCY2 + ItemJnlLine2.Amount;
        ItemJnlLine2."Unit Cost" := ROUND(
            ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",GLSetup."Unit-Amount Rounding Precision");
        ItemJnlLine2."Applies-to Entry" := ItemJnlLine2."Item Shpt. Entry No.";
        ItemJnlLine2."Overhead Rate" := 0;

        IF PurchHeader."Currency Code" <> '' THEN
          ItemJnlLine2."Discount Amount" := ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                Usedate,PurchHeader."Currency Code",(ItemChargePurchLine."Inv. Discount Amount" +
                                                     ItemChargePurchLine."Line Discount Amount") *
                ItemJnlLine2."Invoiced Qty. (Base)" /
                ItemChargePurchLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
                PurchHeader."Currency Factor"),GLSetup."Amount Rounding Precision")
        ELSE
          ItemJnlLine2."Discount Amount" := ROUND(
              (ItemChargePurchLine."Line Discount Amount" + ItemChargePurchLine."Inv. Discount Amount") *
              ItemJnlLine2."Invoiced Qty. (Base)" /
              ItemChargePurchLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
              GLSetup."Amount Rounding Precision");

        ItemJnlLine2."Shortcut Dimension 1 Code" := ItemChargePurchLine."Shortcut Dimension 1 Code";
        ItemJnlLine2."Shortcut Dimension 2 Code" := ItemChargePurchLine."Shortcut Dimension 2 Code";
        ItemJnlLine2."Dimension Set ID" := ItemChargePurchLine."Dimension Set ID";
        ItemJnlLine2."Gen. Prod. Posting Group" := ItemChargePurchLine."Gen. Prod. Posting Group";
      END;

      WITH TempTrackingSpecificationChargeAssmt DO BEGIN
        RESET;
        SETRANGE("Source Type",DATABASE::"Purchase Line");
        SETRANGE("Source ID",TempItemChargeAssgntPurch."Applies-to Doc. No.");
        SETRANGE("Source Ref. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
        IF ISEMPTY THEN
          ItemJnlPostLine.RunWithCheck(ItemJnlLine2)
        ELSE BEGIN
          FINDSET;
          NonDistrItemJnlLine := ItemJnlLine2;
          OriginalAmt := NonDistrItemJnlLine.Amount;
          OriginalAmtACY := NonDistrItemJnlLine."Amount (ACY)";
          OriginalDiscountAmt := NonDistrItemJnlLine."Discount Amount";
          OriginalQty := NonDistrItemJnlLine."Quantity (Base)";
          IF ("Quantity (Base)" / OriginalQty) > 0 THEN
            SignFactor := 1
          ELSE
            SignFactor := -1;
          REPEAT
            Factor := "Quantity (Base)" / OriginalQty * SignFactor;
            IF ABS("Quantity (Base)") < ABS(NonDistrItemJnlLine."Quantity (Base)") THEN BEGIN
              ItemJnlLine2."Quantity (Base)" := "Quantity (Base)";
              ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
              ItemJnlLine2."Amount (ACY)" :=
                ROUND(OriginalAmtACY * Factor,GLSetup."Amount Rounding Precision");
              ItemJnlLine2.Amount :=
                ROUND(OriginalAmt * Factor,GLSetup."Amount Rounding Precision");
              ItemJnlLine2."Unit Cost (ACY)" :=
                ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
                  Currency."Unit-Amount Rounding Precision") * SignFactor;
              ItemJnlLine2."Unit Cost" :=
                ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
                  GLSetup."Unit-Amount Rounding Precision") * SignFactor;
              ItemJnlLine2."Discount Amount" :=
                ROUND(OriginalDiscountAmt * Factor,GLSetup."Amount Rounding Precision");
              ItemJnlLine2."Item Shpt. Entry No." := "Item Ledger Entry No.";
              ItemJnlLine2."Applies-to Entry" := "Item Ledger Entry No.";
              ItemJnlLine2.CopyTrackingFromSpec(TempTrackingSpecificationChargeAssmt);
              ItemJnlPostLine.RunWithCheck(ItemJnlLine2);
              ItemJnlLine2."Location Code" := NonDistrItemJnlLine."Location Code";
              NonDistrItemJnlLine."Quantity (Base)" -= "Quantity (Base)";
              NonDistrItemJnlLine.Amount -= (ItemJnlLine2.Amount * SignFactor);
              NonDistrItemJnlLine."Amount (ACY)" -= (ItemJnlLine2."Amount (ACY)" * SignFactor);
              NonDistrItemJnlLine."Discount Amount" -= (ItemJnlLine2."Discount Amount" * SignFactor);
            END ELSE BEGIN
              NonDistrItemJnlLine."Quantity (Base)" := "Quantity (Base)";
              NonDistrItemJnlLine."Invoiced Qty. (Base)" := "Quantity (Base)";
              NonDistrItemJnlLine."Unit Cost" :=
                ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
                  GLSetup."Unit-Amount Rounding Precision") * SignFactor;
              NonDistrItemJnlLine."Unit Cost (ACY)" :=
                ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
                  Currency."Unit-Amount Rounding Precision") * SignFactor;
              NonDistrItemJnlLine."Item Shpt. Entry No." := "Item Ledger Entry No.";
              NonDistrItemJnlLine."Applies-to Entry" := "Item Ledger Entry No.";
              NonDistrItemJnlLine.CopyTrackingFromSpec(TempTrackingSpecificationChargeAssmt);
              ItemJnlPostLine.RunWithCheck(NonDistrItemJnlLine);
              NonDistrItemJnlLine."Location Code" := ItemJnlLine2."Location Code";
            END;
          UNTIL NEXT = 0;
        END;
      END;
    END;

    LOCAL PROCEDURE PostItemChargePerRcpt@5807(PurchHeader@1012 : Record 38;VAR PurchLine@1000 : Record 39);
    VAR
      PurchRcptLine@1002 : Record 121;
      TempItemLedgEntry@1003 : TEMPORARY Record 32;
      ItemTrackingMgt@1005 : Codeunit 6500;
      Sign@1011 : Decimal;
      DistributeCharge@1001 : Boolean;
    BEGIN
      IF NOT PurchRcptLine.GET(
           TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
      THEN
        ERROR(ReceiptLinesDeletedErr);

      Sign := GetSign(PurchRcptLine."Quantity (Base)");

      IF PurchRcptLine."Item Rcpt. Entry No." <> 0 THEN
        DistributeCharge :=
          CostCalcMgt.SplitItemLedgerEntriesExist(
            TempItemLedgEntry,PurchRcptLine."Quantity (Base)",PurchRcptLine."Item Rcpt. Entry No.")
      ELSE BEGIN
        DistributeCharge := TRUE;
        ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
          DATABASE::"Purch. Rcpt. Line",0,PurchRcptLine."Document No.",
          '',0,PurchRcptLine."Line No.",PurchRcptLine."Quantity (Base)");
      END;

      IF DistributeCharge THEN
        PostDistributeItemCharge(
          PurchHeader,PurchLine,TempItemLedgEntry,PurchRcptLine."Quantity (Base)",
          TempItemChargeAssgntPurch."Qty. to Assign",TempItemChargeAssgntPurch."Amount to Assign",
          Sign,PurchRcptLine."Indirect Cost %")
      ELSE
        PostItemCharge(PurchHeader,PurchLine,
          PurchRcptLine."Item Rcpt. Entry No.",PurchRcptLine."Quantity (Base)",
          TempItemChargeAssgntPurch."Amount to Assign" * Sign,
          TempItemChargeAssgntPurch."Qty. to Assign",
          PurchRcptLine."Indirect Cost %");
    END;

    LOCAL PROCEDURE PostItemChargePerRetShpt@5811(PurchHeader@1012 : Record 38;VAR PurchLine@1000 : Record 39);
    VAR
      ReturnShptLine@1002 : Record 6651;
      TempItemLedgEntry@1010 : TEMPORARY Record 32;
      ItemTrackingMgt@1009 : Codeunit 6500;
      Sign@1011 : Decimal;
      DistributeCharge@1001 : Boolean;
    BEGIN
      ReturnShptLine.GET(
        TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
      ReturnShptLine.TESTFIELD("Job No.",'');

      Sign := GetSign(PurchLine."Line Amount");
      IF PurchLine.IsCreditDocType THEN
        Sign := -Sign;

      IF ReturnShptLine."Item Shpt. Entry No." <> 0 THEN
        DistributeCharge :=
          CostCalcMgt.SplitItemLedgerEntriesExist(
            TempItemLedgEntry,-ReturnShptLine."Quantity (Base)",ReturnShptLine."Item Shpt. Entry No.")
      ELSE BEGIN
        DistributeCharge := TRUE;
        ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
          DATABASE::"Return Shipment Line",0,ReturnShptLine."Document No.",
          '',0,ReturnShptLine."Line No.",ReturnShptLine."Quantity (Base)");
      END;

      IF DistributeCharge THEN
        PostDistributeItemCharge(
          PurchHeader,PurchLine,TempItemLedgEntry,-ReturnShptLine."Quantity (Base)",
          TempItemChargeAssgntPurch."Qty. to Assign",ABS(TempItemChargeAssgntPurch."Amount to Assign"),
          Sign,ReturnShptLine."Indirect Cost %")
      ELSE
        PostItemCharge(PurchHeader,PurchLine,
          ReturnShptLine."Item Shpt. Entry No.",-ReturnShptLine."Quantity (Base)",
          ABS(TempItemChargeAssgntPurch."Amount to Assign") * Sign,
          TempItemChargeAssgntPurch."Qty. to Assign",
          ReturnShptLine."Indirect Cost %");
    END;

    LOCAL PROCEDURE PostItemChargePerTransfer@23(PurchHeader@1018 : Record 38;VAR PurchLine@1000 : Record 39);
    VAR
      TransRcptLine@1002 : Record 5747;
      ItemApplnEntry@1003 : Record 339;
      DummyTrackingSpecification@1001 : Record 336;
      PurchLine2@1016 : Record 39;
      CurrExchRate@1017 : Record 330;
      TotalAmountToPostFCY@1004 : Decimal;
      TotalAmountToPostLCY@1005 : Decimal;
      TotalDiscAmountToPost@1006 : Decimal;
      AmountToPostFCY@1007 : Decimal;
      AmountToPostLCY@1008 : Decimal;
      DiscAmountToPost@1009 : Decimal;
      RemAmountToPostFCY@1010 : Decimal;
      RemAmountToPostLCY@1011 : Decimal;
      RemDiscAmountToPost@1012 : Decimal;
      CalcAmountToPostFCY@1013 : Decimal;
      CalcAmountToPostLCY@1014 : Decimal;
      CalcDiscAmountToPost@1015 : Decimal;
    BEGIN
      WITH TempItemChargeAssgntPurch DO BEGIN
        TransRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
        PurchLine2 := PurchLine;
        PurchLine2."No." := "Item No.";
        PurchLine2."Variant Code" := TransRcptLine."Variant Code";
        PurchLine2."Location Code" := TransRcptLine."Transfer-to Code";
        PurchLine2."Bin Code" := '';
        PurchLine2."Line No." := "Document Line No.";

        IF TransRcptLine."Item Rcpt. Entry No." = 0 THEN
          PostItemChargePerITTransfer(PurchHeader,PurchLine,TransRcptLine)
        ELSE BEGIN
          TotalAmountToPostFCY := "Amount to Assign";
          IF PurchHeader."Currency Code" <> '' THEN
            TotalAmountToPostLCY :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                Usedate,PurchHeader."Currency Code",
                TotalAmountToPostFCY,PurchHeader."Currency Factor")
          ELSE
            TotalAmountToPostLCY := TotalAmountToPostFCY;

          TotalDiscAmountToPost :=
            ROUND(
              PurchLine2."Inv. Discount Amount" / PurchLine2.Quantity * "Qty. to Assign",
              GLSetup."Amount Rounding Precision");
          TotalDiscAmountToPost :=
            TotalDiscAmountToPost +
            ROUND(
              PurchLine2."Line Discount Amount" * ("Qty. to Assign" / PurchLine2."Qty. to Invoice"),
              GLSetup."Amount Rounding Precision");

          TotalAmountToPostLCY := ROUND(TotalAmountToPostLCY,GLSetup."Amount Rounding Precision");

          ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.","Item Ledger Entry No.","Cost Application");
          ItemApplnEntry.SETRANGE("Outbound Item Entry No.",TransRcptLine."Item Rcpt. Entry No.");
          ItemApplnEntry.SETFILTER("Item Ledger Entry No.",'<>%1',TransRcptLine."Item Rcpt. Entry No.");
          ItemApplnEntry.SETRANGE("Cost Application",TRUE);
          IF ItemApplnEntry.FINDSET THEN
            REPEAT
              PurchLine2."Appl.-to Item Entry" := ItemApplnEntry."Item Ledger Entry No.";
              CalcAmountToPostFCY :=
                ((TotalAmountToPostFCY / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
                RemAmountToPostFCY;
              AmountToPostFCY := ROUND(CalcAmountToPostFCY);
              RemAmountToPostFCY := CalcAmountToPostFCY - AmountToPostFCY;
              CalcAmountToPostLCY :=
                ((TotalAmountToPostLCY / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
                RemAmountToPostLCY;
              AmountToPostLCY := ROUND(CalcAmountToPostLCY);
              RemAmountToPostLCY := CalcAmountToPostLCY - AmountToPostLCY;
              CalcDiscAmountToPost :=
                ((TotalDiscAmountToPost / TransRcptLine."Quantity (Base)") * ItemApplnEntry.Quantity) +
                RemDiscAmountToPost;
              DiscAmountToPost := ROUND(CalcDiscAmountToPost);
              RemDiscAmountToPost := CalcDiscAmountToPost - DiscAmountToPost;
              PurchLine2.Amount := AmountToPostLCY;
              PurchLine2."Inv. Discount Amount" := DiscAmountToPost;
              PurchLine2."Line Discount Amount" := 0;
              PurchLine2."Unit Cost" :=
                ROUND(AmountToPostFCY / ItemApplnEntry.Quantity,GLSetup."Unit-Amount Rounding Precision");
              PurchLine2."Unit Cost (LCY)" :=
                ROUND(AmountToPostLCY / ItemApplnEntry.Quantity,GLSetup."Unit-Amount Rounding Precision");
              IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                PurchLine2.Amount := -PurchLine2.Amount;
              PostItemJnlLine(
                PurchHeader,PurchLine2,
                0,0,
                ItemApplnEntry.Quantity,ItemApplnEntry.Quantity,
                PurchLine2."Appl.-to Item Entry","Item Charge No.",DummyTrackingSpecification);
            UNTIL ItemApplnEntry.NEXT = 0;
        END;
      END;
    END;

    LOCAL PROCEDURE PostItemChargePerITTransfer@43(PurchHeader@1002 : Record 38;VAR PurchLine@1000 : Record 39;TransRcptLine@1017 : Record 5747);
    VAR
      TempItemLedgEntry@1016 : TEMPORARY Record 32;
      ItemTrackingMgt@1001 : Codeunit 6500;
    BEGIN
      WITH TempItemChargeAssgntPurch DO BEGIN
        ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
          DATABASE::"Transfer Receipt Line",0,TransRcptLine."Document No.",
          '',0,TransRcptLine."Line No.",TransRcptLine."Quantity (Base)");
        PostDistributeItemCharge(
          PurchHeader,PurchLine,TempItemLedgEntry,TransRcptLine."Quantity (Base)",
          "Qty. to Assign","Amount to Assign",1,0);
      END;
    END;

    LOCAL PROCEDURE PostItemChargePerSalesShpt@41(PurchHeader@1012 : Record 38;VAR PurchLine@1000 : Record 39);
    VAR
      SalesShptLine@1002 : Record 111;
      TempItemLedgEntry@1010 : TEMPORARY Record 32;
      ItemTrackingMgt@1009 : Codeunit 6500;
      Sign@1001 : Decimal;
      DistributeCharge@1011 : Boolean;
    BEGIN
      IF NOT SalesShptLine.GET(
           TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
      THEN
        ERROR(RelatedItemLedgEntriesNotFoundErr);
      SalesShptLine.TESTFIELD("Job No.",'');

      Sign := -GetSign(SalesShptLine."Quantity (Base)");

      IF SalesShptLine."Item Shpt. Entry No." <> 0 THEN
        DistributeCharge :=
          CostCalcMgt.SplitItemLedgerEntriesExist(
            TempItemLedgEntry,-SalesShptLine."Quantity (Base)",SalesShptLine."Item Shpt. Entry No.")
      ELSE BEGIN
        DistributeCharge := TRUE;
        ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
          DATABASE::"Sales Shipment Line",0,SalesShptLine."Document No.",
          '',0,SalesShptLine."Line No.",SalesShptLine."Quantity (Base)");
      END;

      IF DistributeCharge THEN
        PostDistributeItemCharge(
          PurchHeader,PurchLine,TempItemLedgEntry,-SalesShptLine."Quantity (Base)",
          TempItemChargeAssgntPurch."Qty. to Assign",TempItemChargeAssgntPurch."Amount to Assign",Sign,0)
      ELSE
        PostItemCharge(PurchHeader,PurchLine,
          SalesShptLine."Item Shpt. Entry No.",-SalesShptLine."Quantity (Base)",
          TempItemChargeAssgntPurch."Amount to Assign" * Sign,
          TempItemChargeAssgntPurch."Qty. to Assign",0)
    END;

    LOCAL PROCEDURE PostItemChargePerRetRcpt@37(PurchHeader@1012 : Record 38;VAR PurchLine@1001 : Record 39);
    VAR
      ReturnRcptLine@1000 : Record 6661;
      TempItemLedgEntry@1011 : TEMPORARY Record 32;
      ItemTrackingMgt@1010 : Codeunit 6500;
      Sign@1003 : Decimal;
      DistributeCharge@1002 : Boolean;
    BEGIN
      IF NOT ReturnRcptLine.GET(
           TempItemChargeAssgntPurch."Applies-to Doc. No.",TempItemChargeAssgntPurch."Applies-to Doc. Line No.")
      THEN
        ERROR(RelatedItemLedgEntriesNotFoundErr);
      ReturnRcptLine.TESTFIELD("Job No.",'');
      Sign := GetSign(ReturnRcptLine."Quantity (Base)");

      IF ReturnRcptLine."Item Rcpt. Entry No." <> 0 THEN
        DistributeCharge :=
          CostCalcMgt.SplitItemLedgerEntriesExist(
            TempItemLedgEntry,ReturnRcptLine."Quantity (Base)",ReturnRcptLine."Item Rcpt. Entry No.")
      ELSE BEGIN
        DistributeCharge := TRUE;
        ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
          DATABASE::"Return Receipt Line",0,ReturnRcptLine."Document No.",
          '',0,ReturnRcptLine."Line No.",ReturnRcptLine."Quantity (Base)");
      END;

      IF DistributeCharge THEN
        PostDistributeItemCharge(
          PurchHeader,PurchLine,TempItemLedgEntry,ReturnRcptLine."Quantity (Base)",
          TempItemChargeAssgntPurch."Qty. to Assign",TempItemChargeAssgntPurch."Amount to Assign",Sign,0)
      ELSE
        PostItemCharge(PurchHeader,PurchLine,
          ReturnRcptLine."Item Rcpt. Entry No.",ReturnRcptLine."Quantity (Base)",
          TempItemChargeAssgntPurch."Amount to Assign" * Sign,
          TempItemChargeAssgntPurch."Qty. to Assign",0)
    END;

    LOCAL PROCEDURE PostDistributeItemCharge@66(PurchHeader@1000 : Record 38;PurchLine@1001 : Record 39;VAR TempItemLedgEntry@1002 : TEMPORARY Record 32;NonDistrQuantity@1003 : Decimal;NonDistrQtyToAssign@1004 : Decimal;NonDistrAmountToAssign@1005 : Decimal;Sign@1009 : Decimal;IndirectCostPct@1010 : Decimal);
    VAR
      Factor@1006 : Decimal;
      QtyToAssign@1007 : Decimal;
      AmountToAssign@1008 : Decimal;
    BEGIN
      IF TempItemLedgEntry.FINDSET THEN BEGIN
        REPEAT
          Factor := TempItemLedgEntry.Quantity / NonDistrQuantity;
          QtyToAssign := NonDistrQtyToAssign * Factor;
          AmountToAssign := ROUND(NonDistrAmountToAssign * Factor,GLSetup."Amount Rounding Precision");
          IF Factor < 1 THEN BEGIN
            PostItemCharge(PurchHeader,PurchLine,
              TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
              AmountToAssign * Sign,QtyToAssign,IndirectCostPct);
            NonDistrQuantity := NonDistrQuantity - TempItemLedgEntry.Quantity;
            NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
            NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
          END ELSE // the last time
            PostItemCharge(PurchHeader,PurchLine,
              TempItemLedgEntry."Entry No.",TempItemLedgEntry.Quantity,
              NonDistrAmountToAssign * Sign,NonDistrQtyToAssign,IndirectCostPct);
        UNTIL TempItemLedgEntry.NEXT = 0;
      END ELSE
        ERROR(RelatedItemLedgEntriesNotFoundErr)
    END;

    LOCAL PROCEDURE PostAssocItemJnlLine@3(PurchHeader@1003 : Record 38;PurchLine@1004 : Record 39;QtyToBeShipped@1000 : Decimal;QtyToBeShippedBase@1001 : Decimal) : Integer;
    VAR
      ItemJnlLine@1009 : Record 83;
      TempHandlingSpecification2@1005 : TEMPORARY Record 336;
      ItemEntryRelation@1006 : Record 6507;
      CurrExchRate@1002 : Record 330;
      SalesOrderHeader@1008 : Record 36;
      SalesOrderLine@1007 : Record 37;
    BEGIN
      SalesOrderHeader.GET(
        SalesOrderHeader."Document Type"::Order,PurchLine."Sales Order No.");
      SalesOrderLine.GET(
        SalesOrderLine."Document Type"::Order,PurchLine."Sales Order No.",PurchLine."Sales Order Line No.");

      WITH ItemJnlLine DO BEGIN
        INIT;
        CopyDocumentFields(
          "Document Type"::"Sales Shipment",SalesOrderHeader."Shipping No.",'',SrcCode,SalesOrderHeader."Posting No. Series");

        CopyFromSalesHeader(SalesOrderHeader);
        "Country/Region Code" := GetCountryCode(SalesOrderLine,SalesOrderHeader);
        "Posting Date" := PurchHeader."Posting Date";
        "Document Date" := PurchHeader."Document Date";

        CopyFromSalesLine(SalesOrderLine);
        "Derived from Blanket Order" := SalesOrderLine."Blanket Order No." <> '';
        "Applies-to Entry" := ItemLedgShptEntryNo;

        Quantity := QtyToBeShipped;
        "Quantity (Base)" := QtyToBeShippedBase;
        "Invoiced Quantity" := 0;
        "Invoiced Qty. (Base)" := 0;
        "Source Currency Code" := PurchHeader."Currency Code";

        Amount := SalesOrderLine.Amount * QtyToBeShipped / SalesOrderLine.Quantity;
        IF SalesOrderHeader."Currency Code" <> '' THEN BEGIN
          Amount :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                SalesOrderHeader."Posting Date",SalesOrderHeader."Currency Code",
                Amount,SalesOrderHeader."Currency Factor"));
          "Discount Amount" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                SalesOrderHeader."Posting Date",SalesOrderHeader."Currency Code",
                SalesOrderLine."Line Discount Amount",SalesOrderHeader."Currency Factor"));
        END ELSE BEGIN
          Amount := ROUND(Amount);
          "Discount Amount" := SalesOrderLine."Line Discount Amount";
        END;
      END;

      IF SalesOrderLine."Job Contract Entry No." = 0 THEN BEGIN
        TransferReservToItemJnlLine(SalesOrderLine,ItemJnlLine,PurchLine,QtyToBeShippedBase,TRUE);
        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
        // Handle Item Tracking
        IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) THEN BEGIN
          IF TempHandlingSpecification2.FINDSET THEN
            REPEAT
              TempTrackingSpecification := TempHandlingSpecification2;
              TempTrackingSpecification.SetSourceFromSalesLine(SalesOrderLine);
              IF TempTrackingSpecification.INSERT THEN;
              ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification2);
              ItemEntryRelation.SetSource(DATABASE::"Sales Shipment Line",0,SalesOrderHeader."Shipping No.",SalesOrderLine."Line No.");
              ItemEntryRelation.SetOrderInfo(SalesOrderLine."Document No.",SalesOrderLine."Line No.");
              ItemEntryRelation.INSERT;
            UNTIL TempHandlingSpecification2.NEXT = 0;
          EXIT(0);
        END;
      END;

      EXIT(ItemJnlLine."Item Shpt. Entry No.");
    END;

    LOCAL PROCEDURE ReleasePurchDocument@136(VAR PurchHeader@1000 : Record 38);
    VAR
      ReleasePurchaseDocument@1005 : Codeunit 415;
      LinesWereModified@1006 : Boolean;
      TempInvoice@1004 : Boolean;
      TempRcpt@1003 : Boolean;
      TempReturn@1002 : Boolean;
      PrevStatus@1001 : Option;
    BEGIN
      WITH PurchHeader DO BEGIN
        IF NOT (Status = Status::Open) OR (Status = Status::"Pending Prepayment") THEN
          EXIT;

        TempInvoice := Invoice;
        TempRcpt := Receive;
        TempReturn := Ship;
        PrevStatus := Status;
        LinesWereModified := ReleasePurchaseDocument.ReleasePurchaseHeader(PurchHeader,PreviewMode);
        IF LinesWereModified THEN
          RefreshTempLines(PurchHeader);
        TESTFIELD(Status,Status::Released);
        Status := PrevStatus;
        Invoice := TempInvoice;
        Receive := TempRcpt;
        Ship := TempReturn;
        IF PreviewMode AND ("Posting No." = '') THEN
          "Posting No." := '***';
        IF NOT PreviewMode THEN BEGIN
          MODIFY;
          COMMIT;
        END;
        Status := Status::Released;
      END;
    END;

    LOCAL PROCEDURE TestPurchLine@139(PurchHeader@1004 : Record 38;PurchLine@1000 : Record 39);
    VAR
      FA@1001 : Record 5600;
      FASetup@1003 : Record 5603;
      DeprBook@1002 : Record 5611;
      DummyTrackingSpecification@1005 : Record 336;
    BEGIN
      OnBeforeTestPurchLine(PurchLine,PurchHeader);

      WITH PurchLine DO BEGIN
        IF Type = Type::Item THEN
          DummyTrackingSpecification.CheckItemTrackingQuantity(
            DATABASE::"Purchase Line","Document Type","Document No.","Line No.",
            "Qty. to Receive (Base)","Qty. to Invoice (Base)",PurchHeader.Receive,PurchHeader.Invoice);

        IF Type = Type::"Charge (Item)" THEN BEGIN
          TESTFIELD(Amount);
          TESTFIELD("Job No.",'');
        END;
        IF "Job No." <> '' THEN
          TESTFIELD("Job Task No.");
        IF Type = Type::"Fixed Asset" THEN BEGIN
          TESTFIELD("Job No.",'');
          TESTFIELD("Depreciation Book Code");
          TESTFIELD("FA Posting Type");
          FA.GET("No.");
          FA.TESTFIELD("Budgeted Asset",FALSE);
          DeprBook.GET("Depreciation Book Code");
          IF "Budgeted FA No." <> '' THEN BEGIN
            FA.GET("Budgeted FA No.");
            FA.TESTFIELD("Budgeted Asset",TRUE);
          END;
          IF "FA Posting Type" = "FA Posting Type"::Maintenance THEN BEGIN
            TESTFIELD("Insurance No.",'');
            TESTFIELD("Depr. until FA Posting Date",FALSE);
            TESTFIELD("Depr. Acquisition Cost",FALSE);
            DeprBook.TESTFIELD("G/L Integration - Maintenance",TRUE);
          END;
          IF "FA Posting Type" = "FA Posting Type"::"Acquisition Cost" THEN BEGIN
            TESTFIELD("Maintenance Code",'');
            DeprBook.TESTFIELD("G/L Integration - Acq. Cost",TRUE);
          END;
          IF "Insurance No." <> '' THEN BEGIN
            FASetup.GET;
            FASetup.TESTFIELD("Insurance Depr. Book","Depreciation Book Code");
          END;
        END ELSE BEGIN
          TESTFIELD("Depreciation Book Code",'');
          TESTFIELD("FA Posting Type",0);
          TESTFIELD("Maintenance Code",'');
          TESTFIELD("Insurance No.",'');
          TESTFIELD("Depr. until FA Posting Date",FALSE);
          TESTFIELD("Depr. Acquisition Cost",FALSE);
          TESTFIELD("Budgeted FA No.",'');
          TESTFIELD("FA Posting Date",0D);
          TESTFIELD("Salvage Value",0);
          TESTFIELD("Duplicate in Depreciation Book",'');
          TESTFIELD("Use Duplication List",FALSE);
        END;
        CASE "Document Type" OF
          "Document Type"::Order:
            TESTFIELD("Return Qty. to Ship",0);
          "Document Type"::Invoice:
            BEGIN
              IF "Receipt No." = '' THEN
                TESTFIELD("Qty. to Receive",Quantity);
              TESTFIELD("Return Qty. to Ship",0);
              TESTFIELD("Qty. to Invoice",Quantity);
            END;
          "Document Type"::"Return Order":
            TESTFIELD("Qty. to Receive",0);
          "Document Type"::"Credit Memo":
            BEGIN
              IF "Return Shipment No." = '' THEN
                TESTFIELD("Return Qty. to Ship",Quantity);
              TESTFIELD("Qty. to Receive",0);
              TESTFIELD("Qty. to Invoice",Quantity);
            END;
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateAssocOrder@4(VAR TempDropShptPostBuffer@1002 : TEMPORARY Record 223);
    VAR
      SalesSetup@1001 : Record 311;
      SalesOrderHeader@1004 : Record 36;
      SalesOrderLine@1003 : Record 37;
      ReserveSalesLine@1000 : Codeunit 99000832;
    BEGIN
      TempDropShptPostBuffer.RESET;
      IF TempDropShptPostBuffer.ISEMPTY THEN
        EXIT;
      SalesSetup.GET;
      IF TempDropShptPostBuffer.FINDSET THEN BEGIN
        REPEAT
          SalesOrderHeader.GET(
            SalesOrderHeader."Document Type"::Order,
            TempDropShptPostBuffer."Order No.");
          SalesOrderHeader."Last Shipping No." := SalesOrderHeader."Shipping No.";
          SalesOrderHeader."Shipping No." := '';
          SalesOrderHeader.MODIFY;
          ReserveSalesLine.UpdateItemTrackingAfterPosting(SalesOrderHeader);
          TempDropShptPostBuffer.SETRANGE("Order No.",TempDropShptPostBuffer."Order No.");
          REPEAT
            SalesOrderLine.GET(
              SalesOrderLine."Document Type"::Order,
              TempDropShptPostBuffer."Order No.",TempDropShptPostBuffer."Order Line No.");
            SalesOrderLine."Quantity Shipped" := SalesOrderLine."Quantity Shipped" + TempDropShptPostBuffer.Quantity;
            SalesOrderLine."Qty. Shipped (Base)" := SalesOrderLine."Qty. Shipped (Base)" + TempDropShptPostBuffer."Quantity (Base)";
            SalesOrderLine.InitOutstanding;
            IF SalesSetup."Default Quantity to Ship" <> SalesSetup."Default Quantity to Ship"::Blank THEN
              SalesOrderLine.InitQtyToShip
            ELSE BEGIN
              SalesOrderLine."Qty. to Ship" := 0;
              SalesOrderLine."Qty. to Ship (Base)" := 0;
            END;
            SalesOrderLine.MODIFY;
          UNTIL TempDropShptPostBuffer.NEXT = 0;
          TempDropShptPostBuffer.SETRANGE("Order No.");
        UNTIL TempDropShptPostBuffer.NEXT = 0;
        TempDropShptPostBuffer.DELETEALL;
      END;
    END;

    LOCAL PROCEDURE UpdateAssosOrderPostingNos@121(PurchHeader@1000 : Record 38) DropShipment : Boolean;
    VAR
      TempPurchLine@1001 : TEMPORARY Record 39;
      SalesOrderHeader@1002 : Record 36;
      NoSeriesMgt@1003 : Codeunit 396;
      ReleaseSalesDocument@1004 : Codeunit 414;
    BEGIN
      WITH PurchHeader DO BEGIN
        ResetTempLines(TempPurchLine);
        TempPurchLine.SETFILTER("Sales Order Line No.",'<>0');
        IF NOT TempPurchLine.ISEMPTY THEN BEGIN
          DropShipment := TRUE;
          IF Receive THEN BEGIN
            TempPurchLine.FINDSET;
            REPEAT
              IF SalesOrderHeader."No." <> TempPurchLine."Sales Order No." THEN BEGIN
                SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order,TempPurchLine."Sales Order No.");
                SalesOrderHeader.TESTFIELD("Bill-to Customer No.");
                SalesOrderHeader.Ship := TRUE;
                ReleaseSalesDocument.ReleaseSalesHeader(SalesOrderHeader,PreviewMode);
                IF SalesOrderHeader."Shipping No." = '' THEN BEGIN
                  SalesOrderHeader.TESTFIELD("Shipping No. Series");
                  SalesOrderHeader."Shipping No." :=
                    NoSeriesMgt.GetNextNo(SalesOrderHeader."Shipping No. Series","Posting Date",TRUE);
                  SalesOrderHeader.MODIFY;
                END;
              END;
            UNTIL TempPurchLine.NEXT = 0;
          END;
        END;
        EXIT(DropShipment);
      END;
    END;

    LOCAL PROCEDURE UpdateAfterPosting@137(PurchHeader@1001 : Record 38);
    VAR
      TempPurchLine@1002 : TEMPORARY Record 39;
    BEGIN
      WITH TempPurchLine DO BEGIN
        ResetTempLines(TempPurchLine);
        SETFILTER("Blanket Order Line No.",'<>0');
        IF FINDSET THEN
          REPEAT
            UpdateBlanketOrderLine(TempPurchLine,PurchHeader.Receive,PurchHeader.Ship,PurchHeader.Invoice);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UpdateLastPostingNos@153(VAR PurchHeader@1000 : Record 38);
    BEGIN
      WITH PurchHeader DO BEGIN
        IF Receive THEN BEGIN
          "Last Receiving No." := "Receiving No.";
          "Receiving No." := '';
        END;
        IF Invoice THEN BEGIN
          "Last Posting No." := "Posting No.";
          "Posting No." := '';
        END;
        IF Ship THEN BEGIN
          "Last Return Shipment No." := "Return Shipment No.";
          "Return Shipment No." := '';
        END;
      END;
    END;

    LOCAL PROCEDURE UpdatePostingNos@125(VAR PurchHeader@1000 : Record 38) ModifyHeader : Boolean;
    VAR
      NoSeriesMgt@1001 : Codeunit 396;
    BEGIN
      WITH PurchHeader DO BEGIN
        IF Receive AND ("Receiving No." = '') THEN
          IF ("Document Type" = "Document Type"::Order) OR
             (("Document Type" = "Document Type"::Invoice) AND PurchSetup."Receipt on Invoice")
          THEN BEGIN
            TESTFIELD("Receiving No. Series");
            "Receiving No." := NoSeriesMgt.GetNextNo("Receiving No. Series","Posting Date",TRUE);
            ModifyHeader := TRUE;
          END;

        IF Ship AND ("Return Shipment No." = '') THEN
          IF ("Document Type" = "Document Type"::"Return Order") OR
             (("Document Type" = "Document Type"::"Credit Memo") AND PurchSetup."Return Shipment on Credit Memo")
          THEN BEGIN
            TESTFIELD("Return Shipment No. Series");
            "Return Shipment No." := NoSeriesMgt.GetNextNo("Return Shipment No. Series","Posting Date",TRUE);
            ModifyHeader := TRUE;
          END;

        IF Invoice AND ("Posting No." = '') THEN BEGIN
          IF ("No. Series" <> '') OR
             ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
          THEN
            TESTFIELD("Posting No. Series");
          IF ("No. Series" <> "Posting No. Series") OR
             ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
          THEN BEGIN
            IF NOT PreviewMode THEN BEGIN
              "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series","Posting Date",TRUE);
              ModifyHeader := TRUE;
            END ELSE
              "Posting No." := '***';
          END;
        END;
      END;

      OnAfterUpdatePostingNos(PurchHeader,NoSeriesMgt);
    END;

    LOCAL PROCEDURE UpdatePurchLineBeforePost@138(PurchHeader@1000 : Record 38;VAR PurchLine@1001 : Record 39);
    BEGIN
      WITH PurchLine DO BEGIN
        OnBeforeUpdatePurchLineBeforePost(PurchLine,PurchHeader,WhseShip,WhseReceive);

        IF NOT (PurchHeader.Receive OR RoundingLineInserted) THEN BEGIN
          "Qty. to Receive" := 0;
          "Qty. to Receive (Base)" := 0;
        END;

        IF NOT (PurchHeader.Ship OR RoundingLineInserted) THEN BEGIN
          "Return Qty. to Ship" := 0;
          "Return Qty. to Ship (Base)" := 0;
        END;

        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) AND ("Receipt No." <> '') THEN BEGIN
          "Quantity Received" := Quantity;
          "Qty. Received (Base)" := "Quantity (Base)";
          "Qty. to Receive" := 0;
          "Qty. to Receive (Base)" := 0;
        END;

        IF (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo") AND ("Return Shipment No." <> '')
        THEN BEGIN
          "Return Qty. Shipped" := Quantity;
          "Return Qty. Shipped (Base)" := "Quantity (Base)";
          "Return Qty. to Ship" := 0;
          "Return Qty. to Ship (Base)" := 0;
        END;

        IF PurchHeader.Invoice THEN BEGIN
          IF ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice) THEN
            InitQtyToInvoice;
        END ELSE BEGIN
          "Qty. to Invoice" := 0;
          "Qty. to Invoice (Base)" := 0;
        END;
      END;
      OnAfterUpdatePurchLineBeforePost(PurchLine,WhseShip,WhseReceive);
    END;

    LOCAL PROCEDURE UpdateWhseDocuments@156();
    BEGIN
      IF WhseReceive THEN BEGIN
        WhsePostRcpt.PostUpdateWhseDocuments(WhseRcptHeader);
        TempWhseRcptHeader.DELETE;
      END;
      IF WhseShip THEN BEGIN
        WhsePostShpt.PostUpdateWhseDocuments(WhseShptHeader);
        TempWhseShptHeader.DELETE;
      END;
    END;

    LOCAL PROCEDURE DeleteAfterPosting@158(VAR PurchHeader@1000 : Record 38);
    VAR
      PurchCommentLine@1001 : Record 43;
      PurchLine@1004 : Record 39;
      TempPurchLine@1003 : TEMPORARY Record 39;
      WarehouseRequest@1002 : Record 5765;
    BEGIN
      WITH PurchHeader DO BEGIN
        IF HASLINKS THEN
          DELETELINKS;
        DELETE;

        ReservePurchLine.DeleteInvoiceSpecFromHeader(PurchHeader);
        ResetTempLines(TempPurchLine);
        IF TempPurchLine.FINDFIRST THEN
          REPEAT
            IF TempPurchLine."Deferral Code" <> '' THEN
              DeferralUtilities.RemoveOrSetDeferralSchedule(
                '',DeferralUtilities.GetPurchDeferralDocType,'','',
                TempPurchLine."Document Type",
                TempPurchLine."Document No.",
                TempPurchLine."Line No.",0,0D,
                TempPurchLine.Description,
                '',
                TRUE);
            IF TempPurchLine.HASLINKS THEN
              TempPurchLine.DELETELINKS;
          UNTIL TempPurchLine.NEXT = 0;

        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.DELETEALL;

        DeleteItemChargeAssgnt(PurchHeader);
        PurchCommentLine.DeleteComments("Document Type","No.");
        WarehouseRequest.DeleteRequest(DATABASE::"Purchase Line","Document Type","No.");
      END;
    END;

    LOCAL PROCEDURE FinalizePosting@155(VAR PurchHeader@1000 : Record 38;VAR TempDropShptPostBuffer@1003 : TEMPORARY Record 223;EverythingInvoiced@1001 : Boolean);
    VAR
      TempPurchLine@1002 : TEMPORARY Record 39;
      GenJnlPostPreview@1004 : Codeunit 19;
      ArchiveManagement@1005 : Codeunit 5063;
    BEGIN
      WITH PurchHeader DO BEGIN
        IF ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"]) AND
           (NOT EverythingInvoiced)
        THEN BEGIN
          MODIFY;
          InsertTrackingSpecification(PurchHeader);
          PostUpdateOrderLine(PurchHeader);
          UpdateAssocOrder(TempDropShptPostBuffer);
          UpdateWhseDocuments;
          WhsePurchRelease.Release(PurchHeader);
          UpdateItemChargeAssgnt;
        END ELSE BEGIN
          CASE "Document Type" OF
            "Document Type"::Invoice:
              BEGIN
                PostUpdateInvoiceLine;
                InsertTrackingSpecification(PurchHeader);
              END;
            "Document Type"::"Credit Memo":
              BEGIN
                PostUpdateCreditMemoLine;
                InsertTrackingSpecification(PurchHeader);
              END;
            ELSE BEGIN
              ResetTempLines(TempPurchLine);
              TempPurchLine.SETFILTER("Prepayment %",'<>0');
              IF TempPurchLine.FINDSET THEN
                REPEAT
                  DecrementPrepmtAmtInvLCY(
                    TempPurchLine,TempPurchLine."Prepmt. Amount Inv. (LCY)",TempPurchLine."Prepmt. VAT Amount Inv. (LCY)");
                UNTIL TempPurchLine.NEXT = 0;
            END;
          END;
          UpdateAfterPosting(PurchHeader);
          UpdateWhseDocuments;
          ArchiveManagement.AutoArchivePurchDocument(PurchHeader);
          ApprovalsMgmt.DeleteApprovalEntries(RECORDID);
          IF NOT PreviewMode THEN
            DeleteAfterPosting(PurchHeader);
        END;

        InsertValueEntryRelation;
      END;

      IF PreviewMode THEN BEGIN
        Window.CLOSE;
        GenJnlPostPreview.ThrowError;
      END;
      IF NOT InvtPickPutaway THEN
        COMMIT;
      ClearPostBuffers;
      IF GUIALLOWED THEN
        Window.CLOSE;

      OnAfterFinalizePosting(PurchHeader,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,ReturnShptHeader,GenJnlPostLine);
    END;

    LOCAL PROCEDURE FillInvoicePostBuffer@5804(PurchHeader@1012 : Record 38;PurchLine@1000 : Record 39;PurchLineACY@1001 : Record 39;VAR TempInvoicePostBuffer@1014 : TEMPORARY Record 49;VAR InvoicePostBuffer@1013 : Record 49);
    VAR
      GenPostingSetup@1007 : Record 252;
      TotalVAT@1005 : Decimal;
      TotalVATACY@1004 : Decimal;
      TotalAmount@1003 : Decimal;
      TotalAmountACY@1002 : Decimal;
      AmtToDefer@1011 : Decimal;
      AmtToDeferACY@1010 : Decimal;
      TotalVATBase@1015 : Decimal;
      TotalVATBaseACY@1006 : Decimal;
      DeferralAccount@1009 : Code[20];
      PurchAccount@1008 : Code[20];
    BEGIN
      GenPostingSetup.GET(PurchLine."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group");
      InvoicePostBuffer.PreparePurchase(PurchLine);
      InitAmounts(PurchLine,TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY,AmtToDefer,AmtToDeferACY,DeferralAccount);

      IF PurchSetup."Discount Posting" IN
         [PurchSetup."Discount Posting"::"Invoice Discounts",PurchSetup."Discount Posting"::"All Discounts"]
      THEN BEGIN
        CalcInvoiceDiscountPosting(PurchHeader,PurchLine,PurchLineACY,InvoicePostBuffer);

        IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" THEN
          InvoicePostBuffer.SetSalesTaxForPurchLine(PurchLine);

        IF (InvoicePostBuffer.Amount <> 0) OR (InvoicePostBuffer."Amount (ACY)" <> 0) THEN BEGIN
          GenPostingSetup.TESTFIELD("Purch. Inv. Disc. Account");
          IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
            FillInvoicePostBufferFADiscount(
              TempInvoicePostBuffer,InvoicePostBuffer,GenPostingSetup,PurchLine."No.",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
            InvoicePostBuffer.SetAccount(
              GenPostingSetup."Purch. Inv. Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
            InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
            UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
            InvoicePostBuffer.Type := InvoicePostBuffer.Type::"Fixed Asset";
          END ELSE BEGIN
            InvoicePostBuffer.SetAccount(
              GenPostingSetup."Purch. Inv. Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
            UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
          END;
        END;
      END;

      IF PurchSetup."Discount Posting" IN
         [PurchSetup."Discount Posting"::"Line Discounts",PurchSetup."Discount Posting"::"All Discounts"]
      THEN BEGIN
        CalcLineDiscountPosting(PurchHeader,PurchLine,PurchLineACY,InvoicePostBuffer);

        IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" THEN
          InvoicePostBuffer.SetSalesTaxForPurchLine(PurchLine);

        IF (InvoicePostBuffer.Amount <> 0) OR (InvoicePostBuffer."Amount (ACY)" <> 0) THEN BEGIN
          GenPostingSetup.TESTFIELD("Purch. Line Disc. Account");
          IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
            FillInvoicePostBufferFADiscount(
              TempInvoicePostBuffer,InvoicePostBuffer,GenPostingSetup,PurchLine."No.",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
            InvoicePostBuffer.SetAccount(
              GenPostingSetup."Purch. Line Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
            InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
            UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
            InvoicePostBuffer.Type := InvoicePostBuffer.Type::"Fixed Asset";
          END ELSE BEGIN
            InvoicePostBuffer.SetAccount(
              GenPostingSetup."Purch. Line Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
            UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
          END;
        END;
      END;
      // Don't adjust VAT Base Amounts when Deferrals are included
      DeferralUtilities.AdjustTotalAmountForDeferrals(PurchLine."Deferral Code",
        AmtToDefer,AmtToDeferACY,TotalAmount,TotalAmountACY,TotalVATBase,TotalVATBaseACY);

      IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
        IF PurchLine."Deferral Code" <> '' THEN
          InvoicePostBuffer.SetAmounts(
            TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY,PurchLine."VAT Difference",TotalVATBase,TotalVATBaseACY)
        ELSE
          InvoicePostBuffer.SetAmountsNoVAT(TotalAmount,TotalAmountACY,PurchLine."VAT Difference")
      END ELSE
        IF (NOT PurchLine."Use Tax") OR (PurchLine."VAT Calculation Type" <> PurchLine."VAT Calculation Type"::"Sales Tax") THEN
          InvoicePostBuffer.SetAmounts(
            TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY,PurchLine."VAT Difference",TotalVATBase,TotalVATBaseACY)
        ELSE
          InvoicePostBuffer.SetAmountsNoVAT(TotalAmount,TotalAmountACY,PurchLine."VAT Difference");

      IF PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" THEN
        InvoicePostBuffer.SetSalesTaxForPurchLine(PurchLine);

      IF (PurchLine.Type = PurchLine.Type::"G/L Account") OR (PurchLine.Type = PurchLine.Type::"Fixed Asset") THEN BEGIN
        PurchAccount := PurchLine."No.";
        InvoicePostBuffer.SetAccount(
          DefaultGLAccount(PurchLine."Deferral Code",AmtToDefer,PurchAccount,DeferralAccount),
          TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY)
      END ELSE
        IF PurchLine.IsCreditDocType THEN BEGIN
          PurchAccount := GenPostingSetup.GetPurchCrMemoAccount;
          InvoicePostBuffer.SetAccount(
            DefaultGLAccount(PurchLine."Deferral Code",AmtToDefer,PurchAccount,DeferralAccount),
            TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
        END ELSE BEGIN
          PurchAccount := GenPostingSetup.GetPurchAccount;
          InvoicePostBuffer.SetAccount(
            DefaultGLAccount(PurchLine."Deferral Code",AmtToDefer,PurchAccount,DeferralAccount),
            TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
        END;
      InvoicePostBuffer."Deferral Code" := PurchLine."Deferral Code";
      OnAfterFillInvoicePostBuffer(InvoicePostBuffer,PurchLine);
      UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
      FillDeferralPostingBuffer(PurchHeader,PurchLine,InvoicePostBuffer,AmtToDefer,AmtToDeferACY,DeferralAccount,PurchAccount);
    END;

    LOCAL PROCEDURE FillInvoicePostBufferFADiscount@81(VAR TempInvoicePostBuffer@1007 : TEMPORARY Record 49;VAR InvoicePostBuffer@1000 : Record 49;GenPostingSetup@1002 : Record 252;AccountNo@1008 : Code[20];TotalVAT@1003 : Decimal;TotalVATACY@1004 : Decimal;TotalAmount@1005 : Decimal;TotalAmountACY@1006 : Decimal);
    VAR
      DeprBook@1001 : Record 5611;
    BEGIN
      DeprBook.GET(InvoicePostBuffer."Depreciation Book Code");
      IF DeprBook."Subtract Disc. in Purch. Inv." THEN BEGIN
        GenPostingSetup.TESTFIELD("Purch. FA Disc. Account");
        InvoicePostBuffer.SetAccount(AccountNo,TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
        UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
        InvoicePostBuffer.ReverseAmounts;
        InvoicePostBuffer.SetAccount(GenPostingSetup."Purch. FA Disc. Account",TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
        InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
        UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer);
        InvoicePostBuffer.ReverseAmounts;
      END;
    END;

    LOCAL PROCEDURE UpdateInvoicePostBuffer@5(VAR TempInvoicePostBuffer@1001 : TEMPORARY Record 49;InvoicePostBuffer@1002 : Record 49);
    BEGIN
      IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
        FALineNo := FALineNo + 1;
        InvoicePostBuffer."Fixed Asset Line No." := FALineNo;
      END;

      TempInvoicePostBuffer.Update(InvoicePostBuffer,InvDefLineNo,DeferralLineNo);
    END;

    LOCAL PROCEDURE InsertPrepmtAdjInvPostingBuf@79(PurchHeader@1003 : Record 38;PrepmtPurchLine@1000 : Record 39;VAR TempInvoicePostBuffer@1005 : TEMPORARY Record 49;InvoicePostBuffer@1006 : Record 49);
    VAR
      PurchPostPrepayments@1002 : Codeunit 444;
      AdjAmount@1001 : Decimal;
    BEGIN
      WITH PrepmtPurchLine DO
        IF "Prepayment Line" THEN
          IF "Prepmt. Amount Inv. (LCY)" <> 0 THEN BEGIN
            AdjAmount := -"Prepmt. Amount Inv. (LCY)";
            TempInvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
              "No.",AdjAmount,PurchHeader."Currency Code" = '');
            TempInvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
              PurchPostPrepayments.GetCorrBalAccNo(PurchHeader,AdjAmount > 0),
              -AdjAmount,
              PurchHeader."Currency Code" = '');
          END ELSE
            IF ("Prepayment %" = 100) AND ("Prepmt. VAT Amount Inv. (LCY)" <> 0) THEN
              TempInvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
                PurchPostPrepayments.GetInvRoundingAccNo(PurchHeader."Vendor Posting Group"),
                "Prepmt. VAT Amount Inv. (LCY)",PurchHeader."Currency Code" = '');
    END;

    LOCAL PROCEDURE GetCurrency@17(CurrencyCode@1000 : Code[10]);
    BEGIN
      IF CurrencyCode = '' THEN
        Currency.InitRoundingPrecision
      ELSE BEGIN
        Currency.GET(CurrencyCode);
        Currency.TESTFIELD("Amount Rounding Precision");
      END;
    END;

    LOCAL PROCEDURE DivideAmount@8(PurchHeader@1004 : Record 38;VAR PurchLine@1005 : Record 39;QtyType@1000 : 'General,Invoicing,Shipping';PurchLineQty@1001 : Decimal;VAR TempVATAmountLine@1002 : TEMPORARY Record 290;VAR TempVATAmountLineRemainder@1003 : TEMPORARY Record 290);
    VAR
      OriginalDeferralAmount@1006 : Decimal;
    BEGIN
      IF RoundingLineInserted AND (RoundingLineNo = PurchLine."Line No.") THEN
        EXIT;
      WITH PurchLine DO
        IF (PurchLineQty = 0) OR ("Direct Unit Cost" = 0) THEN BEGIN
          "Line Amount" := 0;
          "Line Discount Amount" := 0;
          "Inv. Discount Amount" := 0;
          "VAT Base Amount" := 0;
          Amount := 0;
          "Amount Including VAT" := 0;
        END ELSE BEGIN
          OriginalDeferralAmount := GetDeferralAmount;
          TempVATAmountLine.GET(
            "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax",
            "Line Amount" >= 0);
          IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
            "VAT %" := TempVATAmountLine."VAT %";
          TempVATAmountLineRemainder := TempVATAmountLine;
          IF NOT TempVATAmountLineRemainder.FIND THEN BEGIN
            TempVATAmountLineRemainder.INIT;
            TempVATAmountLineRemainder.INSERT;
          END;
          "Line Amount" := GetLineAmountToHandle(PurchLineQty) + GetPrepmtDiffToLineAmount(PurchLine);
          IF PurchLineQty <> Quantity THEN
            "Line Discount Amount" :=
              ROUND("Line Discount Amount" * PurchLineQty / Quantity,Currency."Amount Rounding Precision");

          IF "Allow Invoice Disc." AND (TempVATAmountLine."Inv. Disc. Base Amount" <> 0) THEN
            IF QtyType = QtyType::Invoicing THEN
              "Inv. Discount Amount" := "Inv. Disc. Amount to Invoice"
            ELSE BEGIN
              TempVATAmountLineRemainder."Invoice Discount Amount" :=
                TempVATAmountLineRemainder."Invoice Discount Amount" +
                TempVATAmountLine."Invoice Discount Amount" * "Line Amount" /
                TempVATAmountLine."Inv. Disc. Base Amount";
              "Inv. Discount Amount" :=
                ROUND(
                  TempVATAmountLineRemainder."Invoice Discount Amount",Currency."Amount Rounding Precision");
              TempVATAmountLineRemainder."Invoice Discount Amount" :=
                TempVATAmountLineRemainder."Invoice Discount Amount" - "Inv. Discount Amount";
            END;

          IF PurchHeader."Prices Including VAT" THEN BEGIN
            IF (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" = 0) OR
               ("Line Amount" = 0)
            THEN BEGIN
              TempVATAmountLineRemainder."VAT Amount" := 0;
              TempVATAmountLineRemainder."Amount Including VAT" := 0;
            END ELSE BEGIN
              TempVATAmountLineRemainder."VAT Amount" :=
                TempVATAmountLineRemainder."VAT Amount" +
                TempVATAmountLine."VAT Amount" *
                ("Line Amount" - "Inv. Discount Amount") /
                (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
              TempVATAmountLineRemainder."Amount Including VAT" :=
                TempVATAmountLineRemainder."Amount Including VAT" +
                TempVATAmountLine."Amount Including VAT" *
                ("Line Amount" - "Inv. Discount Amount") /
                (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
            END;
            IF "Line Discount %" <> 100 THEN
              "Amount Including VAT" :=
                ROUND(TempVATAmountLineRemainder."Amount Including VAT",Currency."Amount Rounding Precision")
            ELSE
              "Amount Including VAT" := 0;
            Amount :=
              ROUND("Amount Including VAT",Currency."Amount Rounding Precision") -
              ROUND(TempVATAmountLineRemainder."VAT Amount",Currency."Amount Rounding Precision");
            "VAT Base Amount" :=
              ROUND(
                Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
            TempVATAmountLineRemainder."Amount Including VAT" :=
              TempVATAmountLineRemainder."Amount Including VAT" - "Amount Including VAT";
            TempVATAmountLineRemainder."VAT Amount" :=
              TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
          END ELSE
            IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
              IF "Line Discount %" <> 100 THEN
                "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount"
              ELSE
                "Amount Including VAT" := 0;
              Amount := 0;
              "VAT Base Amount" := 0;
            END ELSE BEGIN
              Amount := "Line Amount" - "Inv. Discount Amount";
              "VAT Base Amount" :=
                ROUND(
                  Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
              IF TempVATAmountLine."VAT Base" = 0 THEN
                TempVATAmountLineRemainder."VAT Amount" := 0
              ELSE
                TempVATAmountLineRemainder."VAT Amount" :=
                  TempVATAmountLineRemainder."VAT Amount" +
                  TempVATAmountLine."VAT Amount" *
                  ("Line Amount" - "Inv. Discount Amount") /
                  (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
              IF "Line Discount %" <> 100 THEN
                "Amount Including VAT" :=
                  Amount + ROUND(TempVATAmountLineRemainder."VAT Amount",Currency."Amount Rounding Precision")
              ELSE
                "Amount Including VAT" := 0;
              TempVATAmountLineRemainder."VAT Amount" :=
                TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
            END;

          TempVATAmountLineRemainder.MODIFY;
          IF "Deferral Code" <> '' THEN
            CalcDeferralAmounts(PurchHeader,PurchLine,OriginalDeferralAmount);
        END;
    END;

    LOCAL PROCEDURE RoundAmount@9(PurchHeader@1003 : Record 38;VAR PurchLine@1004 : Record 39;PurchLineQty@1000 : Decimal);
    VAR
      CurrExchRate@1002 : Record 330;
      NoVAT@1001 : Boolean;
    BEGIN
      WITH PurchLine DO BEGIN
        IncrAmount(PurchHeader,PurchLine,TotalPurchLine);
        Increment(TotalPurchLine."Net Weight",ROUND(PurchLineQty * "Net Weight",0.00001));
        Increment(TotalPurchLine."Gross Weight",ROUND(PurchLineQty * "Gross Weight",0.00001));
        Increment(TotalPurchLine."Unit Volume",ROUND(PurchLineQty * "Unit Volume",0.00001));
        Increment(TotalPurchLine.Quantity,PurchLineQty);
        IF "Units per Parcel" > 0 THEN
          Increment(TotalPurchLine."Units per Parcel",ROUND(PurchLineQty / "Units per Parcel",1,'>'));

        xPurchLine := PurchLine;
        PurchLineACY := PurchLine;
        IF PurchHeader."Currency Code" <> '' THEN BEGIN
          IF PurchHeader."Posting Date" = 0D THEN
            Usedate := WORKDATE
          ELSE
            Usedate := PurchHeader."Posting Date";

          NoVAT := Amount = "Amount Including VAT";
          "Amount Including VAT" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                Usedate,PurchHeader."Currency Code",
                TotalPurchLine."Amount Including VAT",PurchHeader."Currency Factor")) -
            TotalPurchLineLCY."Amount Including VAT";
          IF NoVAT THEN
            Amount := "Amount Including VAT"
          ELSE
            Amount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  Usedate,PurchHeader."Currency Code",
                  TotalPurchLine.Amount,PurchHeader."Currency Factor")) -
              TotalPurchLineLCY.Amount;
          "Line Amount" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                Usedate,PurchHeader."Currency Code",
                TotalPurchLine."Line Amount",PurchHeader."Currency Factor")) -
            TotalPurchLineLCY."Line Amount";
          "Line Discount Amount" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                Usedate,PurchHeader."Currency Code",
                TotalPurchLine."Line Discount Amount",PurchHeader."Currency Factor")) -
            TotalPurchLineLCY."Line Discount Amount";
          "Inv. Discount Amount" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                Usedate,PurchHeader."Currency Code",
                TotalPurchLine."Inv. Discount Amount",PurchHeader."Currency Factor")) -
            TotalPurchLineLCY."Inv. Discount Amount";
          "VAT Difference" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                Usedate,PurchHeader."Currency Code",
                TotalPurchLine."VAT Difference",PurchHeader."Currency Factor")) -
            TotalPurchLineLCY."VAT Difference";
        END;

        IncrAmount(PurchHeader,PurchLine,TotalPurchLineLCY);
        Increment(TotalPurchLineLCY."Unit Cost (LCY)",ROUND(PurchLineQty * "Unit Cost (LCY)"));
      END;
    END;

    LOCAL PROCEDURE ReverseAmount@10(VAR PurchLine@1000 : Record 39);
    BEGIN
      WITH PurchLine DO BEGIN
        "Qty. to Receive" := -"Qty. to Receive";
        "Qty. to Receive (Base)" := -"Qty. to Receive (Base)";
        "Return Qty. to Ship" := -"Return Qty. to Ship";
        "Return Qty. to Ship (Base)" := -"Return Qty. to Ship (Base)";
        "Qty. to Invoice" := -"Qty. to Invoice";
        "Qty. to Invoice (Base)" := -"Qty. to Invoice (Base)";
        "Line Amount" := -"Line Amount";
        Amount := -Amount;
        "VAT Base Amount" := -"VAT Base Amount";
        "VAT Difference" := -"VAT Difference";
        "Amount Including VAT" := -"Amount Including VAT";
        "Line Discount Amount" := -"Line Discount Amount";
        "Inv. Discount Amount" := -"Inv. Discount Amount";
        "Salvage Value" := -"Salvage Value";
      END;
    END;

    LOCAL PROCEDURE InvoiceRounding@12(PurchHeader@1003 : Record 38;VAR PurchLine@1005 : Record 39;UseTempData@1000 : Boolean;BiggestLineNo@1004 : Integer);
    VAR
      VendPostingGr@1002 : Record 93;
      TempPurchLineForCalc@1006 : TEMPORARY Record 39;
      InvoiceRoundingAmount@1001 : Decimal;
    BEGIN
      Currency.TESTFIELD("Invoice Rounding Precision");
      InvoiceRoundingAmount :=
        -ROUND(
          TotalPurchLine."Amount Including VAT" -
          ROUND(
            TotalPurchLine."Amount Including VAT",Currency."Invoice Rounding Precision",Currency.InvoiceRoundingDirection),
          Currency."Amount Rounding Precision");

      OnBeforeInvoiceRoundingAmount(PurchHeader,TotalPurchLine."Amount Including VAT",UseTempData,InvoiceRoundingAmount);
      IF InvoiceRoundingAmount <> 0 THEN BEGIN
        VendPostingGr.GET(PurchHeader."Vendor Posting Group");
        VendPostingGr.TESTFIELD("Invoice Rounding Account");
        WITH PurchLine DO BEGIN
          INIT;
          BiggestLineNo := BiggestLineNo + 10000;
          "System-Created Entry" := TRUE;
          IF UseTempData THEN BEGIN
            "Line No." := 0;
            Type := Type::"G/L Account";
            TempPurchLineForCalc := PurchLine;
            TempPurchLineForCalc.VALIDATE("No.",VendPostingGr."Invoice Rounding Account");
            PurchLine := TempPurchLineForCalc;
          END ELSE BEGIN
            "Line No." := BiggestLineNo;
            VALIDATE(Type,Type::"G/L Account");
            VALIDATE("No.",VendPostingGr."Invoice Rounding Account");
          END;
          VALIDATE(Quantity,1);
          IF IsCreditDocType THEN
            VALIDATE("Return Qty. to Ship",Quantity)
          ELSE
            VALIDATE("Qty. to Receive",Quantity);
          IF PurchHeader."Prices Including VAT" THEN
            VALIDATE("Direct Unit Cost",InvoiceRoundingAmount)
          ELSE
            VALIDATE(
              "Direct Unit Cost",
              ROUND(
                InvoiceRoundingAmount /
                (1 + (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                Currency."Amount Rounding Precision"));
          VALIDATE("Amount Including VAT",InvoiceRoundingAmount);
          "Line No." := BiggestLineNo;
          LastLineRetrieved := FALSE;
          RoundingLineInserted := TRUE;
          RoundingLineNo := "Line No.";
        END;
      END;
    END;

    LOCAL PROCEDURE IncrAmount@13(PurchHeader@1001 : Record 38;PurchLine@1002 : Record 39;VAR TotalPurchLine@1000 : Record 39);
    BEGIN
      WITH PurchLine DO BEGIN
        IF PurchHeader."Prices Including VAT" OR
           ("VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT")
        THEN
          Increment(TotalPurchLine."Line Amount","Line Amount");
        Increment(TotalPurchLine.Amount,Amount);
        Increment(TotalPurchLine."VAT Base Amount","VAT Base Amount");
        Increment(TotalPurchLine."VAT Difference","VAT Difference");
        Increment(TotalPurchLine."Amount Including VAT","Amount Including VAT");
        Increment(TotalPurchLine."Line Discount Amount","Line Discount Amount");
        Increment(TotalPurchLine."Inv. Discount Amount","Inv. Discount Amount");
        Increment(TotalPurchLine."Inv. Disc. Amount to Invoice","Inv. Disc. Amount to Invoice");
        Increment(TotalPurchLine."Prepmt. Line Amount","Prepmt. Line Amount");
        Increment(TotalPurchLine."Prepmt. Amt. Inv.","Prepmt. Amt. Inv.");
        Increment(TotalPurchLine."Prepmt Amt to Deduct","Prepmt Amt to Deduct");
        Increment(TotalPurchLine."Prepmt Amt Deducted","Prepmt Amt Deducted");
        Increment(TotalPurchLine."Prepayment VAT Difference","Prepayment VAT Difference");
        Increment(TotalPurchLine."Prepmt VAT Diff. to Deduct","Prepmt VAT Diff. to Deduct");
        Increment(TotalPurchLine."Prepmt VAT Diff. Deducted","Prepmt VAT Diff. Deducted");
      END;
    END;

    LOCAL PROCEDURE Increment@14(VAR Number@1000 : Decimal;Number2@1001 : Decimal);
    BEGIN
      Number := Number + Number2;
    END;

    [External]
    PROCEDURE GetPurchLines@16(VAR PurchHeader@1000 : Record 38;VAR PurchLine@1001 : Record 39;QtyType@1002 : 'General,Invoicing,Shipping');
    VAR
      OldPurchLine@1003 : Record 39;
      MergedPurchLines@1004 : TEMPORARY Record 39;
    BEGIN
      IF QtyType = QtyType::Invoicing THEN BEGIN
        CreatePrepmtLines(PurchHeader,TempPrepmtPurchLine,FALSE);
        MergePurchLines(PurchHeader,OldPurchLine,TempPrepmtPurchLine,MergedPurchLines);
        SumPurchLines2(PurchHeader,PurchLine,MergedPurchLines,QtyType,TRUE);
      END ELSE
        SumPurchLines2(PurchHeader,PurchLine,OldPurchLine,QtyType,TRUE);
    END;

    [External]
    PROCEDURE SumPurchLines@15(VAR NewPurchHeader@1000 : Record 38;QtyType@1001 : 'General,Invoicing,Shipping';VAR NewTotalPurchLine@1002 : Record 39;VAR NewTotalPurchLineLCY@1003 : Record 39;VAR VATAmount@1004 : Decimal;VAR VATAmountText@1005 : Text[30]);
    VAR
      OldPurchLine@1006 : Record 39;
    BEGIN
      SumPurchLinesTemp(
        NewPurchHeader,OldPurchLine,QtyType,NewTotalPurchLine,NewTotalPurchLineLCY,
        VATAmount,VATAmountText);
    END;

    [External]
    PROCEDURE SumPurchLinesTemp@24(VAR PurchHeader@1000 : Record 38;VAR OldPurchLine@1001 : Record 39;QtyType@1002 : 'General,Invoicing,Shipping';VAR NewTotalPurchLine@1003 : Record 39;VAR NewTotalPurchLineLCY@1004 : Record 39;VAR VATAmount@1005 : Decimal;VAR VATAmountText@1006 : Text[30]);
    VAR
      PurchLine@1007 : Record 39;
    BEGIN
      WITH PurchHeader DO BEGIN
        SumPurchLines2(PurchHeader,PurchLine,OldPurchLine,QtyType,FALSE);
        VATAmount := TotalPurchLine."Amount Including VAT" - TotalPurchLine.Amount;
        IF TotalPurchLine."VAT %" = 0 THEN
          VATAmountText := VATAmountTxt
        ELSE
          VATAmountText := STRSUBSTNO(VATRateTxt,TotalPurchLine."VAT %");
        NewTotalPurchLine := TotalPurchLine;
        NewTotalPurchLineLCY := TotalPurchLineLCY;
      END;
    END;

    LOCAL PROCEDURE SumPurchLines2@11(PurchHeader@1008 : Record 38;VAR NewPurchLine@1000 : Record 39;VAR OldPurchLine@1001 : Record 39;QtyType@1002 : 'General,Invoicing,Shipping';InsertPurchLine@1003 : Boolean);
    VAR
      PurchLine@1009 : Record 39;
      TempVATAmountLine@1006 : TEMPORARY Record 290;
      TempVATAmountLineRemainder@1007 : TEMPORARY Record 290;
      PurchLineQty@1004 : Decimal;
      BiggestLineNo@1005 : Integer;
    BEGIN
      TempVATAmountLineRemainder.DELETEALL;
      OldPurchLine.CalcVATAmountLines(QtyType,PurchHeader,OldPurchLine,TempVATAmountLine);
      WITH PurchHeader DO BEGIN
        GetGLSetup;
        PurchSetup.GET;
        GetCurrency("Currency Code");
        OldPurchLine.SETRANGE("Document Type","Document Type");
        OldPurchLine.SETRANGE("Document No.","No.");
        RoundingLineInserted := FALSE;
        IF OldPurchLine.FINDSET THEN
          REPEAT
            IF NOT RoundingLineInserted THEN
              PurchLine := OldPurchLine;
            CASE QtyType OF
              QtyType::General:
                PurchLineQty := PurchLine.Quantity;
              QtyType::Invoicing:
                PurchLineQty := PurchLine."Qty. to Invoice";
              QtyType::Shipping:
                BEGIN
                  IF IsCreditDocType THEN
                    PurchLineQty := PurchLine."Return Qty. to Ship"
                  ELSE
                    PurchLineQty := PurchLine."Qty. to Receive"
                END;
            END;
            DivideAmount(PurchHeader,PurchLine,QtyType,PurchLineQty,TempVATAmountLine,TempVATAmountLineRemainder);
            PurchLine.Quantity := PurchLineQty;
            IF PurchLineQty <> 0 THEN BEGIN
              IF (PurchLine.Amount <> 0) AND NOT RoundingLineInserted THEN
                IF TotalPurchLine.Amount = 0 THEN
                  TotalPurchLine."VAT %" := PurchLine."VAT %"
                ELSE
                  IF TotalPurchLine."VAT %" <> PurchLine."VAT %" THEN
                    TotalPurchLine."VAT %" := 0;
              RoundAmount(PurchHeader,PurchLine,PurchLineQty);
              PurchLine := xPurchLine;
            END;
            IF InsertPurchLine THEN BEGIN
              NewPurchLine := PurchLine;
              NewPurchLine.INSERT;
            END;
            IF RoundingLineInserted THEN
              LastLineRetrieved := TRUE
            ELSE BEGIN
              BiggestLineNo := MAX(BiggestLineNo,OldPurchLine."Line No.");
              LastLineRetrieved := OldPurchLine.NEXT = 0;
              IF LastLineRetrieved AND PurchSetup."Invoice Rounding" THEN
                InvoiceRounding(PurchHeader,PurchLine,TRUE,BiggestLineNo);
            END;
          UNTIL LastLineRetrieved;
      END;
    END;

    [External]
    PROCEDURE UpdateBlanketOrderLine@21(PurchLine@1000 : Record 39;Receive@1001 : Boolean;Ship@1006 : Boolean;Invoice@1002 : Boolean);
    VAR
      BlanketOrderPurchLine@1003 : Record 39;
      ModifyLine@1004 : Boolean;
      Sign@1005 : Decimal;
    BEGIN
      IF (PurchLine."Blanket Order No." <> '') AND (PurchLine."Blanket Order Line No." <> 0) AND
         ((Receive AND (PurchLine."Qty. to Receive" <> 0)) OR
          (Ship AND (PurchLine."Return Qty. to Ship" <> 0)) OR
          (Invoice AND (PurchLine."Qty. to Invoice" <> 0)))
      THEN
        IF BlanketOrderPurchLine.GET(
             BlanketOrderPurchLine."Document Type"::"Blanket Order",PurchLine."Blanket Order No.",
             PurchLine."Blanket Order Line No.")
        THEN BEGIN
          BlanketOrderPurchLine.TESTFIELD(Type,PurchLine.Type);
          BlanketOrderPurchLine.TESTFIELD("No.",PurchLine."No.");
          BlanketOrderPurchLine.TESTFIELD("Buy-from Vendor No.",PurchLine."Buy-from Vendor No.");

          ModifyLine := FALSE;
          CASE PurchLine."Document Type" OF
            PurchLine."Document Type"::Order,
            PurchLine."Document Type"::Invoice:
              Sign := 1;
            PurchLine."Document Type"::"Return Order",
            PurchLine."Document Type"::"Credit Memo":
              Sign := -1;
          END;
          IF Receive AND (PurchLine."Receipt No." = '') THEN BEGIN
            IF BlanketOrderPurchLine."Qty. per Unit of Measure" =
               PurchLine."Qty. per Unit of Measure"
            THEN
              BlanketOrderPurchLine."Quantity Received" :=
                BlanketOrderPurchLine."Quantity Received" + Sign * PurchLine."Qty. to Receive"
            ELSE
              BlanketOrderPurchLine."Quantity Received" :=
                BlanketOrderPurchLine."Quantity Received" +
                Sign *
                ROUND(
                  (PurchLine."Qty. per Unit of Measure" /
                   BlanketOrderPurchLine."Qty. per Unit of Measure") *
                  PurchLine."Qty. to Receive",0.00001);
            BlanketOrderPurchLine."Qty. Received (Base)" :=
              BlanketOrderPurchLine."Qty. Received (Base)" + Sign * PurchLine."Qty. to Receive (Base)";
            ModifyLine := TRUE;
          END;
          IF Ship AND (PurchLine."Return Shipment No." = '') THEN BEGIN
            IF BlanketOrderPurchLine."Qty. per Unit of Measure" =
               PurchLine."Qty. per Unit of Measure"
            THEN
              BlanketOrderPurchLine."Quantity Received" :=
                BlanketOrderPurchLine."Quantity Received" + Sign * PurchLine."Return Qty. to Ship"
            ELSE
              BlanketOrderPurchLine."Quantity Received" :=
                BlanketOrderPurchLine."Quantity Received" +
                Sign *
                ROUND(
                  (PurchLine."Qty. per Unit of Measure" /
                   BlanketOrderPurchLine."Qty. per Unit of Measure") *
                  PurchLine."Return Qty. to Ship",0.00001);
            BlanketOrderPurchLine."Qty. Received (Base)" :=
              BlanketOrderPurchLine."Qty. Received (Base)" + Sign * PurchLine."Return Qty. to Ship (Base)";
            ModifyLine := TRUE;
          END;

          IF Invoice THEN BEGIN
            IF BlanketOrderPurchLine."Qty. per Unit of Measure" =
               PurchLine."Qty. per Unit of Measure"
            THEN
              BlanketOrderPurchLine."Quantity Invoiced" :=
                BlanketOrderPurchLine."Quantity Invoiced" + Sign * PurchLine."Qty. to Invoice"
            ELSE
              BlanketOrderPurchLine."Quantity Invoiced" :=
                BlanketOrderPurchLine."Quantity Invoiced" +
                Sign *
                ROUND(
                  (PurchLine."Qty. per Unit of Measure" /
                   BlanketOrderPurchLine."Qty. per Unit of Measure") *
                  PurchLine."Qty. to Invoice",0.00001);
            BlanketOrderPurchLine."Qty. Invoiced (Base)" :=
              BlanketOrderPurchLine."Qty. Invoiced (Base)" + Sign * PurchLine."Qty. to Invoice (Base)";
            ModifyLine := TRUE;
          END;

          IF ModifyLine THEN BEGIN
            BlanketOrderPurchLine.InitOutstanding;

            IF (BlanketOrderPurchLine.Quantity * BlanketOrderPurchLine."Quantity Received" < 0) OR
               (ABS(BlanketOrderPurchLine.Quantity) < ABS(BlanketOrderPurchLine."Quantity Received"))
            THEN
              BlanketOrderPurchLine.FIELDERROR(
                "Quantity Received",
                STRSUBSTNO(
                  BlanketOrderQuantityGreaterThanErr,
                  BlanketOrderPurchLine.FIELDCAPTION(Quantity)));

            IF (BlanketOrderPurchLine."Quantity (Base)" *
                BlanketOrderPurchLine."Qty. Received (Base)" < 0) OR
               (ABS(BlanketOrderPurchLine."Quantity (Base)") <
                ABS(BlanketOrderPurchLine."Qty. Received (Base)"))
            THEN
              BlanketOrderPurchLine.FIELDERROR(
                "Qty. Received (Base)",
                STRSUBSTNO(
                  BlanketOrderQuantityGreaterThanErr,
                  BlanketOrderPurchLine.FIELDCAPTION("Quantity Received")));

            BlanketOrderPurchLine.CALCFIELDS("Reserved Qty. (Base)");
            IF ABS(BlanketOrderPurchLine."Outstanding Qty. (Base)") <
               ABS(BlanketOrderPurchLine."Reserved Qty. (Base)")
            THEN
              BlanketOrderPurchLine.FIELDERROR(
                "Reserved Qty. (Base)",BlanketOrderQuantityReducedErr);

            BlanketOrderPurchLine."Qty. to Invoice" :=
              BlanketOrderPurchLine.Quantity - BlanketOrderPurchLine."Quantity Invoiced";
            BlanketOrderPurchLine."Qty. to Receive" :=
              BlanketOrderPurchLine.Quantity - BlanketOrderPurchLine."Quantity Received";
            BlanketOrderPurchLine."Qty. to Invoice (Base)" :=
              BlanketOrderPurchLine."Quantity (Base)" - BlanketOrderPurchLine."Qty. Invoiced (Base)";
            BlanketOrderPurchLine."Qty. to Receive (Base)" :=
              BlanketOrderPurchLine."Quantity (Base)" - BlanketOrderPurchLine."Qty. Received (Base)";

            BlanketOrderPurchLine.MODIFY;
          END;
        END;
    END;

    LOCAL PROCEDURE UpdatePurchaseHeader@163(VendorLedgerEntry@1000 : Record 25);
    VAR
      GenJnlLine@1001 : Record 81;
    BEGIN
      CASE GenJnlLineDocType OF
        GenJnlLine."Document Type"::Invoice:
          BEGIN
            FindVendorLedgerEntry(GenJnlLineDocType,GenJnlLineDocNo,VendorLedgerEntry);
            PurchInvHeader."Vendor Ledger Entry No." := VendorLedgerEntry."Entry No.";
            PurchInvHeader.MODIFY;
          END;
        GenJnlLine."Document Type"::"Credit Memo":
          BEGIN
            FindVendorLedgerEntry(GenJnlLineDocType,GenJnlLineDocNo,VendorLedgerEntry);
            PurchCrMemoHeader."Vendor Ledger Entry No." := VendorLedgerEntry."Entry No.";
            PurchCrMemoHeader.MODIFY;
          END;
      END;
    END;

    LOCAL PROCEDURE PostVendorEntry@68(PurchHeader@1006 : Record 38;TotalPurchLine2@1005 : Record 39;TotalPurchLineLCY2@1004 : Record 39;DocType@1003 : Option;DocNo@1002 : Code[20];ExtDocNo@1001 : Code[35];SourceCode@1000 : Code[10]);
    VAR
      GenJnlLine@1007 : Record 81;
    BEGIN
      WITH GenJnlLine DO BEGIN
        InitNewLine(
          PurchHeader."Posting Date",PurchHeader."Document Date",PurchHeader."Posting Description",
          PurchHeader."Shortcut Dimension 1 Code",PurchHeader."Shortcut Dimension 2 Code",
          PurchHeader."Dimension Set ID",PurchHeader."Reason Code");

        CopyDocumentFields(DocType,DocNo,ExtDocNo,SourceCode,'');
        "Account Type" := "Account Type"::Vendor;
        "Account No." := PurchHeader."Pay-to Vendor No.";
        CopyFromPurchHeader(PurchHeader);
        SetCurrencyFactor(PurchHeader."Currency Code",PurchHeader."Currency Factor");
        "System-Created Entry" := TRUE;

        CopyFromPurchHeaderApplyTo(PurchHeader);
        CopyFromPurchHeaderPayment(PurchHeader);

        Amount := -TotalPurchLine2."Amount Including VAT";
        "Source Currency Amount" := -TotalPurchLine2."Amount Including VAT";
        "Amount (LCY)" := -TotalPurchLineLCY2."Amount Including VAT";
        "Sales/Purch. (LCY)" := -TotalPurchLineLCY2.Amount;
        "Inv. Discount (LCY)" := -TotalPurchLineLCY2."Inv. Discount Amount";

        OnBeforePostVendorEntry(GenJnlLine,PurchHeader,TotalPurchLine2,TotalPurchLineLCY2);
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        OnAfterPostVendorEntry(GenJnlLine,PurchHeader,TotalPurchLine2,TotalPurchLineLCY2);
      END;
    END;

    LOCAL PROCEDURE PostBalancingEntry@149(PurchHeader@1000 : Record 38;TotalPurchLine2@1006 : Record 39;TotalPurchLineLCY2@1005 : Record 39;DocType@1004 : Option;DocNo@1003 : Code[20];ExtDocNo@1002 : Code[35];SourceCode@1001 : Code[10]);
    VAR
      GenJnlLine@1007 : Record 81;
      VendLedgEntry@1008 : Record 25;
    BEGIN
      FindVendorLedgerEntry(DocType,DocNo,VendLedgEntry);

      WITH GenJnlLine DO BEGIN
        InitNewLine(
          PurchHeader."Posting Date",PurchHeader."Document Date",PurchHeader."Posting Description",
          PurchHeader."Shortcut Dimension 1 Code",PurchHeader."Shortcut Dimension 2 Code",
          PurchHeader."Dimension Set ID",PurchHeader."Reason Code");

        CopyDocumentFields(0,DocNo,ExtDocNo,SourceCode,'');
        "Account Type" := "Account Type"::Vendor;
        "Account No." := PurchHeader."Pay-to Vendor No.";
        CopyFromPurchHeader(PurchHeader);
        SetCurrencyFactor(PurchHeader."Currency Code",PurchHeader."Currency Factor");

        IF PurchHeader.IsCreditDocType THEN
          "Document Type" := "Document Type"::Refund
        ELSE
          "Document Type" := "Document Type"::Payment;

        SetApplyToDocNo(PurchHeader,GenJnlLine,DocType,DocNo);

        Amount := TotalPurchLine2."Amount Including VAT" + VendLedgEntry."Remaining Pmt. Disc. Possible";
        "Source Currency Amount" := Amount;
        VendLedgEntry.CALCFIELDS(Amount);
        IF VendLedgEntry.Amount = 0 THEN
          "Amount (LCY)" := TotalPurchLineLCY2."Amount Including VAT"
        ELSE
          "Amount (LCY)" :=
            TotalPurchLineLCY2."Amount Including VAT" +
            ROUND(VendLedgEntry."Remaining Pmt. Disc. Possible" / VendLedgEntry."Adjusted Currency Factor");
        "Allow Zero-Amount Posting" := TRUE;

        OnBeforePostBalancingEntry(GenJnlLine,PurchHeader,TotalPurchLine2,TotalPurchLineLCY2);
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        OnAfterPostBalancingEntry(GenJnlLine,PurchHeader,TotalPurchLine2,TotalPurchLineLCY2);
      END;
    END;

    LOCAL PROCEDURE SetApplyToDocNo@25(PurchHeader@1000 : Record 38;VAR GenJnlLine@1001 : Record 81;DocType@1002 : Option;DocNo@1003 : Code[20]);
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF PurchHeader."Bal. Account Type" = PurchHeader."Bal. Account Type"::"Bank Account" THEN
          "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
        "Bal. Account No." := PurchHeader."Bal. Account No.";
        "Applies-to Doc. Type" := DocType;
        "Applies-to Doc. No." := DocNo;
      END;
    END;

    LOCAL PROCEDURE FindVendorLedgerEntry@64(DocType@1000 : Option;DocNo@1001 : Code[20];VAR VendorLedgerEntry@1002 : Record 25);
    BEGIN
      VendorLedgerEntry.SETRANGE("Document Type",DocType);
      VendorLedgerEntry.SETRANGE("Document No.",DocNo);
      VendorLedgerEntry.FINDLAST;
    END;

    LOCAL PROCEDURE RunGenJnlPostLine@52(VAR GenJnlLine@1000 : Record 81) : Integer;
    BEGIN
      EXIT(GenJnlPostLine.RunWithCheck(GenJnlLine));
    END;

    LOCAL PROCEDURE CheckPostRestrictions@148(PurchaseHeader@1000 : Record 38);
    VAR
      Vendor@1002 : Record 23;
    BEGIN
      IF NOT PreviewMode THEN
        PurchaseHeader.OnCheckPurchasePostRestrictions;

      Vendor.GET(PurchaseHeader."Buy-from Vendor No.");
      Vendor.CheckBlockedVendOnDocs(Vendor,TRUE);
      IF PurchaseHeader."Pay-to Vendor No." <> PurchaseHeader."Buy-from Vendor No." THEN BEGIN
        Vendor.GET(PurchaseHeader."Pay-to Vendor No.");
        Vendor.CheckBlockedVendOnDocs(Vendor,TRUE);
      END;
    END;

    LOCAL PROCEDURE CheckDim@34(PurchHeader@1001 : Record 38);
    BEGIN
      CheckDimCombHeader(PurchHeader);
      CheckDimValuePostingHeader(PurchHeader);
      CheckDimLines(PurchHeader);
    END;

    LOCAL PROCEDURE CheckFAPostingPossibility@372(PurchaseHeader@1000 : Record 38);
    VAR
      PurchaseLine@1001 : Record 39;
      PurchaseLineToFind@1002 : Record 39;
      FADepreciationBook@1003 : Record 5612;
      HasBookValue@1004 : Boolean;
    BEGIN
      PurchaseLine.SETRANGE("Document Type",PurchaseHeader."Document Type");
      PurchaseLine.SETRANGE("Document No.",PurchaseHeader."No.");
      PurchaseLine.SETRANGE(Type,PurchaseLine.Type::"Fixed Asset");
      PurchaseLine.SETFILTER("No.",'<>%1','');
      IF PurchaseLine.FINDSET THEN
        REPEAT
          PurchaseLineToFind.COPYFILTERS(PurchaseLine);
          PurchaseLineToFind.SETRANGE("No.",PurchaseLine."No.");
          PurchaseLineToFind.SETRANGE("Depr. until FA Posting Date",NOT PurchaseLine."Depr. until FA Posting Date");
          IF NOT PurchaseLineToFind.ISEMPTY THEN
            ERROR(STRSUBSTNO(MixedDerpFAUntilPostingDateErr,PurchaseLine."No."));

          IF PurchaseLine."Depr. until FA Posting Date" THEN BEGIN
            PurchaseLineToFind.SETRANGE("Depr. until FA Posting Date",TRUE);
            PurchaseLineToFind.SETFILTER("Line No.",'<>%1',PurchaseLine."Line No.");
            IF NOT PurchaseLineToFind.ISEMPTY THEN BEGIN
              HasBookValue := FALSE;
              FADepreciationBook.SETRANGE("FA No.",PurchaseLine."No.");
              FADepreciationBook.FINDSET;
              REPEAT
                FADepreciationBook.CALCFIELDS("Book Value");
                HasBookValue := HasBookValue OR (FADepreciationBook."Book Value" <> 0);
              UNTIL (FADepreciationBook.NEXT = 0) OR HasBookValue;
              IF NOT HasBookValue THEN
                ERROR(STRSUBSTNO(CannotPostSameMultipleFAWhenDeprBookValueZeroErr,PurchaseLine."No."));
            END;
          END;
        UNTIL PurchaseLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimCombHeader@30(PurchHeader@1002 : Record 38);
    VAR
      DimMgt@1001 : Codeunit 408;
    BEGIN
      WITH PurchHeader DO
        IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
          ERROR(DimensionIsBlockedErr,"Document Type","No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimCombLine@49(PurchLine@1000 : Record 39);
    VAR
      DimMgt@1001 : Codeunit 408;
    BEGIN
      WITH PurchLine DO
        IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
          ERROR(LineDimensionBlockedErr,"Document Type","Document No.","Line No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimLines@168(PurchHeader@1002 : Record 38);
    VAR
      TempPurchLine@1001 : TEMPORARY Record 39;
    BEGIN
      WITH TempPurchLine DO BEGIN
        ResetTempLines(TempPurchLine);
        SETFILTER(Type,'<>%1',Type::" ");
        IF FINDSET THEN
          REPEAT
            IF (PurchHeader.Receive AND ("Qty. to Receive" <> 0)) OR
               (PurchHeader.Invoice AND ("Qty. to Invoice" <> 0)) OR
               (PurchHeader.Ship AND ("Return Qty. to Ship" <> 0))
            THEN BEGIN
              CheckDimCombLine(TempPurchLine);
              CheckDimValuePostingLine(TempPurchLine);
            END
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckDimValuePostingHeader@28(PurchHeader@1004 : Record 38);
    VAR
      DimMgt@1001 : Codeunit 408;
      TableIDArr@1002 : ARRAY [10] OF Integer;
      NumberArr@1003 : ARRAY [10] OF Code[20];
    BEGIN
      WITH PurchHeader DO BEGIN
        TableIDArr[1] := DATABASE::Vendor;
        NumberArr[1] := "Pay-to Vendor No.";
        TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
        NumberArr[2] := "Purchaser Code";
        TableIDArr[3] := DATABASE::Campaign;
        NumberArr[3] := "Campaign No.";
        TableIDArr[4] := DATABASE::"Responsibility Center";
        NumberArr[4] := "Responsibility Center";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,"Dimension Set ID") THEN
          ERROR(InvalidDimensionsErr,"Document Type","No.",DimMgt.GetDimValuePostingErr);
      END;
    END;

    LOCAL PROCEDURE CheckDimValuePostingLine@170(PurchLine@1000 : Record 39);
    VAR
      DimMgt@1003 : Codeunit 408;
      TableIDArr@1002 : ARRAY [10] OF Integer;
      NumberArr@1001 : ARRAY [10] OF Code[20];
    BEGIN
      WITH PurchLine DO BEGIN
        TableIDArr[1] := DimMgt.TypeToTableID3(Type);
        NumberArr[1] := "No.";
        TableIDArr[2] := DATABASE::Job;
        NumberArr[2] := "Job No.";
        TableIDArr[3] := DATABASE::"Work Center";
        NumberArr[3] := "Work Center No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,"Dimension Set ID") THEN
          ERROR(LineInvalidDimensionsErr,"Document Type","Document No.","Line No.",DimMgt.GetDimValuePostingErr);
      END;
    END;

    LOCAL PROCEDURE DeleteItemChargeAssgnt@5803(PurchHeader@1001 : Record 38);
    VAR
      ItemChargeAssgntPurch@1000 : Record 5805;
    BEGIN
      ItemChargeAssgntPurch.SETRANGE("Document Type",PurchHeader."Document Type");
      ItemChargeAssgntPurch.SETRANGE("Document No.",PurchHeader."No.");
      IF NOT ItemChargeAssgntPurch.ISEMPTY THEN
        ItemChargeAssgntPurch.DELETEALL;
    END;

    LOCAL PROCEDURE UpdateItemChargeAssgnt@5808();
    VAR
      ItemChargeAssgntPurch@1000 : Record 5805;
    BEGIN
      WITH TempItemChargeAssgntPurch DO BEGIN
        ClearItemChargeAssgntFilter;
        MARKEDONLY(TRUE);
        IF FINDSET THEN
          REPEAT
            ItemChargeAssgntPurch.GET("Document Type","Document No.","Document Line No.","Line No.");
            ItemChargeAssgntPurch."Qty. Assigned" :=
              ItemChargeAssgntPurch."Qty. Assigned" + "Qty. to Assign";
            ItemChargeAssgntPurch."Qty. to Assign" := 0;
            ItemChargeAssgntPurch."Amount to Assign" := 0;
            ItemChargeAssgntPurch.MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UpdatePurchOrderChargeAssgnt@5814(PurchOrderInvLine@1000 : Record 39;PurchOrderLine@1001 : Record 39);
    VAR
      PurchOrderLine2@1002 : Record 39;
      PurchOrderInvLine2@1003 : Record 39;
      PurchRcptLine@1004 : Record 121;
      ReturnShptLine@1005 : Record 6651;
    BEGIN
      WITH PurchOrderInvLine DO BEGIN
        ClearItemChargeAssgntFilter;
        TempItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
        TempItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
        TempItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
        TempItemChargeAssgntPurch.MARKEDONLY(TRUE);
        IF TempItemChargeAssgntPurch.FINDSET THEN
          REPEAT
            IF TempItemChargeAssgntPurch."Applies-to Doc. Type" = "Document Type" THEN BEGIN
              PurchOrderInvLine2.GET(
                TempItemChargeAssgntPurch."Applies-to Doc. Type",
                TempItemChargeAssgntPurch."Applies-to Doc. No.",
                TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
              IF ((PurchOrderLine."Document Type" = PurchOrderLine."Document Type"::Order) AND
                  (PurchOrderInvLine2."Receipt No." = "Receipt No.")) OR
                 ((PurchOrderLine."Document Type" = PurchOrderLine."Document Type"::"Return Order") AND
                  (PurchOrderInvLine2."Return Shipment No." = "Return Shipment No."))
              THEN BEGIN
                IF PurchOrderLine."Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
                  IF NOT
                     PurchRcptLine.GET(PurchOrderInvLine2."Receipt No.",PurchOrderInvLine2."Receipt Line No.")
                  THEN
                    ERROR(ReceiptLinesDeletedErr);
                  PurchOrderLine2.GET(
                    PurchOrderLine2."Document Type"::Order,
                    PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");
                END ELSE BEGIN
                  IF NOT
                     ReturnShptLine.GET(PurchOrderInvLine2."Return Shipment No.",PurchOrderInvLine2."Return Shipment Line No.")
                  THEN
                    ERROR(ReturnShipmentLinesDeletedErr);
                  PurchOrderLine2.GET(
                    PurchOrderLine2."Document Type"::"Return Order",
                    ReturnShptLine."Return Order No.",ReturnShptLine."Return Order Line No.");
                END;
                UpdatePurchChargeAssgntLines(
                  PurchOrderLine,
                  PurchOrderLine2."Document Type",
                  PurchOrderLine2."Document No.",
                  PurchOrderLine2."Line No.",
                  TempItemChargeAssgntPurch."Qty. to Assign");
              END;
            END ELSE
              UpdatePurchChargeAssgntLines(
                PurchOrderLine,
                TempItemChargeAssgntPurch."Applies-to Doc. Type",
                TempItemChargeAssgntPurch."Applies-to Doc. No.",
                TempItemChargeAssgntPurch."Applies-to Doc. Line No.",
                TempItemChargeAssgntPurch."Qty. to Assign");
          UNTIL TempItemChargeAssgntPurch.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UpdatePurchChargeAssgntLines@5813(PurchOrderLine@1000 : Record 39;ApplToDocType@1001 : Option;ApplToDocNo@1002 : Code[20];ApplToDocLineNo@1003 : Integer;QtytoAssign@1004 : Decimal);
    VAR
      ItemChargeAssgntPurch@1005 : Record 5805;
      TempItemChargeAssgntPurch2@1008 : Record 5805;
      LastLineNo@1006 : Integer;
      TotalToAssign@1007 : Decimal;
    BEGIN
      ItemChargeAssgntPurch.SETRANGE("Document Type",PurchOrderLine."Document Type");
      ItemChargeAssgntPurch.SETRANGE("Document No.",PurchOrderLine."Document No.");
      ItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchOrderLine."Line No.");
      ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",ApplToDocType);
      ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",ApplToDocNo);
      ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.",ApplToDocLineNo);
      IF ItemChargeAssgntPurch.FINDFIRST THEN BEGIN
        ItemChargeAssgntPurch."Qty. Assigned" :=
          ItemChargeAssgntPurch."Qty. Assigned" + QtytoAssign;
        ItemChargeAssgntPurch."Qty. to Assign" := 0;
        ItemChargeAssgntPurch."Amount to Assign" := 0;
        ItemChargeAssgntPurch.MODIFY;
      END ELSE BEGIN
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
        ItemChargeAssgntPurch.CALCSUMS("Qty. to Assign");

        TempItemChargeAssgntPurch2.SETRANGE("Document Type",TempItemChargeAssgntPurch."Document Type");
        TempItemChargeAssgntPurch2.SETRANGE("Document No.",TempItemChargeAssgntPurch."Document No.");
        TempItemChargeAssgntPurch2.SETRANGE("Document Line No.",TempItemChargeAssgntPurch."Document Line No.");
        TempItemChargeAssgntPurch2.CALCSUMS("Qty. to Assign");

        TotalToAssign := ItemChargeAssgntPurch."Qty. to Assign" +
          TempItemChargeAssgntPurch2."Qty. to Assign";

        IF ItemChargeAssgntPurch.FINDLAST THEN
          LastLineNo := ItemChargeAssgntPurch."Line No.";

        IF PurchOrderLine.Quantity < TotalToAssign THEN
          REPEAT
            TotalToAssign := TotalToAssign - ItemChargeAssgntPurch."Qty. to Assign";
            ItemChargeAssgntPurch."Qty. to Assign" := 0;
            ItemChargeAssgntPurch."Amount to Assign" := 0;
            ItemChargeAssgntPurch.MODIFY;
          UNTIL (ItemChargeAssgntPurch.NEXT(-1) = 0) OR
                (TotalToAssign = PurchOrderLine.Quantity);

        InsertAssocOrderCharge(
          PurchOrderLine,
          ApplToDocType,
          ApplToDocNo,
          ApplToDocLineNo,
          LastLineNo,
          TempItemChargeAssgntPurch."Applies-to Doc. Line Amount");
      END;
    END;

    LOCAL PROCEDURE InsertAssocOrderCharge@48(PurchOrderLine@1000 : Record 39;ApplToDocType@1002 : Option;ApplToDocNo@1003 : Code[20];ApplToDocLineNo@1004 : Integer;LastLineNo@1007 : Integer;ApplToDocLineAmt@1005 : Decimal);
    VAR
      NewItemChargeAssgntPurch@1001 : Record 5805;
    BEGIN
      WITH NewItemChargeAssgntPurch DO BEGIN
        INIT;
        "Document Type" := PurchOrderLine."Document Type";
        "Document No." := PurchOrderLine."Document No.";
        "Document Line No." := PurchOrderLine."Line No.";
        "Line No." := LastLineNo + 10000;
        "Item Charge No." := TempItemChargeAssgntPurch."Item Charge No.";
        "Item No." := TempItemChargeAssgntPurch."Item No.";
        "Qty. Assigned" := TempItemChargeAssgntPurch."Qty. to Assign";
        "Qty. to Assign" := 0;
        "Amount to Assign" := 0;
        Description := TempItemChargeAssgntPurch.Description;
        "Unit Cost" := TempItemChargeAssgntPurch."Unit Cost";
        "Applies-to Doc. Type" := ApplToDocType;
        "Applies-to Doc. No." := ApplToDocNo;
        "Applies-to Doc. Line No." := ApplToDocLineNo;
        "Applies-to Doc. Line Amount" := ApplToDocLineAmt;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE CopyAndCheckItemCharge@5806(PurchHeader@1000 : Record 38);
    VAR
      TempPurchLine@1001 : TEMPORARY Record 39;
      PurchLine@1002 : Record 39;
      InvoiceEverything@1004 : Boolean;
      AssignError@1005 : Boolean;
      QtyNeeded@1102601000 : Decimal;
    BEGIN
      TempItemChargeAssgntPurch.RESET;
      TempItemChargeAssgntPurch.DELETEALL;

      // Check for max qty posting
      WITH TempPurchLine DO BEGIN
        ResetTempLines(TempPurchLine);
        SETRANGE(Type,Type::"Charge (Item)");
        IF ISEMPTY THEN
          EXIT;

        ItemChargeAssgntPurch.RESET;
        ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
        ItemChargeAssgntPurch.SETFILTER("Qty. to Assign",'<>0');
        IF ItemChargeAssgntPurch.FINDSET THEN
          REPEAT
            TempItemChargeAssgntPurch.INIT;
            TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
            TempItemChargeAssgntPurch.INSERT;
          UNTIL ItemChargeAssgntPurch.NEXT = 0;

        SETFILTER("Qty. to Invoice",'<>0');
        IF FINDSET THEN
          REPEAT
            TESTFIELD("Job No.",'');
            IF PurchHeader.Invoice AND
               ("Qty. to Receive" + "Return Qty. to Ship" <> 0) AND
               ((PurchHeader.Ship OR PurchHeader.Receive) OR
                (ABS("Qty. to Invoice") >
                 ABS("Qty. Rcd. Not Invoiced" + "Qty. to Receive") +
                 ABS("Ret. Qty. Shpd Not Invd.(Base)" + "Return Qty. to Ship")))
            THEN
              TESTFIELD("Line Amount");

            IF NOT PurchHeader.Receive THEN
              "Qty. to Receive" := 0;
            IF NOT PurchHeader.Ship THEN
              "Return Qty. to Ship" := 0;
            IF ABS("Qty. to Invoice") >
               ABS("Quantity Received" + "Qty. to Receive" +
                 "Return Qty. Shipped" + "Return Qty. to Ship" -
                 "Quantity Invoiced")
            THEN
              "Qty. to Invoice" :=
                "Quantity Received" + "Qty. to Receive" +
                "Return Qty. Shipped (Base)" + "Return Qty. to Ship (Base)" -
                "Quantity Invoiced";

            CALCFIELDS("Qty. to Assign","Qty. Assigned");
            IF ABS("Qty. to Assign" + "Qty. Assigned") >
               ABS("Qty. to Invoice" + "Quantity Invoiced")
            THEN
              ERROR(CannotAssignMoreErr,
                "Qty. to Invoice" + "Quantity Invoiced" - "Qty. Assigned",
                FIELDCAPTION("Document Type"),"Document Type",
                FIELDCAPTION("Document No."),"Document No.",
                FIELDCAPTION("Line No."),"Line No.");
            IF Quantity = "Qty. to Invoice" + "Quantity Invoiced" THEN BEGIN
              IF "Qty. to Assign" <> 0 THEN
                IF Quantity = "Quantity Invoiced" THEN BEGIN
                  TempItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
                  TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type","Document Type");
                  IF TempItemChargeAssgntPurch.FINDSET THEN
                    REPEAT
                      PurchLine.GET(
                        TempItemChargeAssgntPurch."Applies-to Doc. Type",
                        TempItemChargeAssgntPurch."Applies-to Doc. No.",
                        TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
                      IF PurchLine.Quantity = PurchLine."Quantity Invoiced" THEN
                        ERROR(CannotAssignInvoicedErr,PurchLine.TABLECAPTION,
                          PurchLine.FIELDCAPTION("Document Type"),PurchLine."Document Type",
                          PurchLine.FIELDCAPTION("Document No."),PurchLine."Document No.",
                          PurchLine.FIELDCAPTION("Line No."),PurchLine."Line No.");
                    UNTIL TempItemChargeAssgntPurch.NEXT = 0;
                END;
              IF Quantity <> "Qty. to Assign" + "Qty. Assigned" THEN
                AssignError := TRUE;
            END;

            IF ("Qty. to Assign" + "Qty. Assigned") < ("Qty. to Invoice" + "Quantity Invoiced") THEN
              ERROR(MustAssignItemChargeErr,"No.");

            // check if all ILEs exist
            QtyNeeded := "Qty. to Assign";
            TempItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
            IF TempItemChargeAssgntPurch.FINDSET THEN
              REPEAT
                IF (TempItemChargeAssgntPurch."Applies-to Doc. Type" <> "Document Type") OR
                   (TempItemChargeAssgntPurch."Applies-to Doc. No." <> "Document No.")
                THEN
                  QtyNeeded := QtyNeeded - TempItemChargeAssgntPurch."Qty. to Assign"
                ELSE BEGIN
                  PurchLine.GET(
                    TempItemChargeAssgntPurch."Applies-to Doc. Type",
                    TempItemChargeAssgntPurch."Applies-to Doc. No.",
                    TempItemChargeAssgntPurch."Applies-to Doc. Line No.");
                  IF ItemLedgerEntryExist(PurchLine,PurchHeader.Receive OR PurchHeader.Ship) THEN
                    QtyNeeded := QtyNeeded - TempItemChargeAssgntPurch."Qty. to Assign";
                END;
              UNTIL TempItemChargeAssgntPurch.NEXT = 0;

            IF QtyNeeded > 0 THEN
              ERROR(CannotInvoiceItemChargeErr,"No.");
          UNTIL NEXT = 0;

        // Check purchlines
        IF AssignError THEN
          IF PurchHeader."Document Type" IN
             [PurchHeader."Document Type"::Invoice,PurchHeader."Document Type"::"Credit Memo"]
          THEN
            InvoiceEverything := TRUE
          ELSE BEGIN
            RESET;
            SETFILTER(Type,'%1|%2',Type::Item,Type::"Charge (Item)");
            IF FINDSET THEN
              REPEAT
                IF PurchHeader.Ship OR PurchHeader.Receive THEN
                  InvoiceEverything :=
                    Quantity = "Qty. to Invoice" + "Quantity Invoiced"
                ELSE
                  InvoiceEverything :=
                    (Quantity = "Qty. to Invoice" + "Quantity Invoiced") AND
                    ("Qty. to Invoice" =
                     "Qty. Rcd. Not Invoiced" + "Return Qty. Shipped Not Invd.");
              UNTIL (NEXT = 0) OR (NOT InvoiceEverything);
          END;

        IF InvoiceEverything AND AssignError THEN
          ERROR(MustAssignErr);
      END;
    END;

    LOCAL PROCEDURE ClearItemChargeAssgntFilter@27();
    BEGIN
      TempItemChargeAssgntPurch.SETRANGE("Document Line No.");
      TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
      TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
      TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
      TempItemChargeAssgntPurch.MARKEDONLY(FALSE);
    END;

    LOCAL PROCEDURE GetItemChargeLine@5809(PurchHeader@1001 : Record 38;VAR ItemChargePurchLine@1000 : Record 39);
    VAR
      QtyReceived@1003 : Decimal;
      QtyReturnShipped@1004 : Decimal;
    BEGIN
      WITH TempItemChargeAssgntPurch DO
        IF (ItemChargePurchLine."Document Type" <> "Document Type") OR
           (ItemChargePurchLine."Document No." <> "Document No.") OR
           (ItemChargePurchLine."Line No." <> "Document Line No.")
        THEN BEGIN
          ItemChargePurchLine.GET("Document Type","Document No.","Document Line No.");
          IF NOT PurchHeader.Receive THEN
            ItemChargePurchLine."Qty. to Receive" := 0;
          IF NOT PurchHeader.Ship THEN
            ItemChargePurchLine."Return Qty. to Ship" := 0;

          IF ItemChargePurchLine."Receipt No." = '' THEN
            QtyReceived := ItemChargePurchLine."Quantity Received"
          ELSE
            QtyReceived := "Qty. to Assign";
          IF ItemChargePurchLine."Return Shipment No." = '' THEN
            QtyReturnShipped := ItemChargePurchLine."Return Qty. Shipped"
          ELSE
            QtyReturnShipped := "Qty. to Assign";

          IF ABS(ItemChargePurchLine."Qty. to Invoice") >
             ABS(QtyReceived + ItemChargePurchLine."Qty. to Receive" +
               QtyReturnShipped + ItemChargePurchLine."Return Qty. to Ship" -
               ItemChargePurchLine."Quantity Invoiced")
          THEN
            ItemChargePurchLine."Qty. to Invoice" :=
              QtyReceived + ItemChargePurchLine."Qty. to Receive" +
              QtyReturnShipped + ItemChargePurchLine."Return Qty. to Ship" -
              ItemChargePurchLine."Quantity Invoiced";
        END;
    END;

    LOCAL PROCEDURE CalcQtyToInvoice@5810(QtyToHandle@1000 : Decimal;QtyToInvoice@1001 : Decimal) : Decimal;
    BEGIN
      IF ABS(QtyToHandle) > ABS(QtyToInvoice) THEN
        EXIT(QtyToHandle);

      EXIT(QtyToInvoice);
    END;

    LOCAL PROCEDURE GetGLSetup@20();
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetup.GET;
      GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE CheckWarehouse@7301(VAR TempItemPurchLine@1000 : TEMPORARY Record 39);
    VAR
      WhseValidateSourceLine@1003 : Codeunit 5777;
      ShowError@1002 : Boolean;
    BEGIN
      WITH TempItemPurchLine DO BEGIN
        IF "Prod. Order No." <> '' THEN
          EXIT;
        SETRANGE(Type,Type::Item);
        SETRANGE("Drop Shipment",FALSE);
        IF FINDSET THEN
          REPEAT
            GetLocation("Location Code");
            CASE "Document Type" OF
              "Document Type"::Order:
                IF ((Location."Require Receive" OR Location."Require Put-away") AND (Quantity >= 0)) OR
                   ((Location."Require Shipment" OR Location."Require Pick") AND (Quantity < 0))
                THEN BEGIN
                  IF Location."Directed Put-away and Pick" THEN
                    ShowError := TRUE
                  ELSE
                    IF WhseValidateSourceLine.WhseLinesExist(
                         DATABASE::"Purchase Line","Document Type","Document No.","Line No.",0,Quantity)
                    THEN
                      ShowError := TRUE;
                END;
              "Document Type"::"Return Order":
                IF ((Location."Require Receive" OR Location."Require Put-away") AND (Quantity < 0)) OR
                   ((Location."Require Shipment" OR Location."Require Pick") AND (Quantity >= 0))
                THEN BEGIN
                  IF Location."Directed Put-away and Pick" THEN
                    ShowError := TRUE
                  ELSE
                    IF WhseValidateSourceLine.WhseLinesExist(
                         DATABASE::"Purchase Line","Document Type","Document No.","Line No.",0,Quantity)
                    THEN
                      ShowError := TRUE;
                END;
              "Document Type"::Invoice,"Document Type"::"Credit Memo":
                IF Location."Directed Put-away and Pick" THEN
                  Location.TESTFIELD("Adjustment Bin Code");
            END;
            IF ShowError THEN
              ERROR(
                WarehouseRequiredErr,
                FIELDCAPTION("Document Type"),"Document Type",
                FIELDCAPTION("Document No."),"Document No.",
                FIELDCAPTION("Line No."),"Line No.");
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CreateWhseJnlLine@7302(ItemJnlLine@1000 : Record 83;PurchLine@1002 : Record 39;VAR TempWhseJnlLine@1001 : TEMPORARY Record 7311);
    VAR
      WhseMgt@1003 : Codeunit 5775;
      WMSMgt@1004 : Codeunit 7302;
    BEGIN
      WITH PurchLine DO BEGIN
        WMSMgt.CheckAdjmtBin(Location,ItemJnlLine.Quantity,TRUE);
        WMSMgt.CreateWhseJnlLine(ItemJnlLine,0,TempWhseJnlLine,FALSE);
        TempWhseJnlLine."Source Type" := DATABASE::"Purchase Line";
        TempWhseJnlLine."Source Subtype" := "Document Type";
        TempWhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(TempWhseJnlLine."Source Type",TempWhseJnlLine."Source Subtype");
        TempWhseJnlLine."Source No." := "Document No.";
        TempWhseJnlLine."Source Line No." := "Line No.";
        TempWhseJnlLine."Source Code" := SrcCode;
        CASE "Document Type" OF
          "Document Type"::Order:
            TempWhseJnlLine."Reference Document" :=
              TempWhseJnlLine."Reference Document"::"Posted Rcpt.";
          "Document Type"::Invoice:
            TempWhseJnlLine."Reference Document" :=
              TempWhseJnlLine."Reference Document"::"Posted P. Inv.";
          "Document Type"::"Credit Memo":
            TempWhseJnlLine."Reference Document" :=
              TempWhseJnlLine."Reference Document"::"Posted P. Cr. Memo";
          "Document Type"::"Return Order":
            TempWhseJnlLine."Reference Document" :=
              TempWhseJnlLine."Reference Document"::"Posted Rtrn. Rcpt.";
        END;
        TempWhseJnlLine."Reference No." := ItemJnlLine."Document No.";
      END;
    END;

    LOCAL PROCEDURE WhseHandlingRequired@7307(PurchLine@1001 : Record 39) : Boolean;
    VAR
      WhseSetup@1000 : Record 5769;
    BEGIN
      IF (PurchLine.Type = PurchLine.Type::Item) AND (NOT PurchLine."Drop Shipment") THEN BEGIN
        IF PurchLine."Location Code" = '' THEN BEGIN
          WhseSetup.GET;
          IF PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" THEN
            EXIT(WhseSetup."Require Pick");

          EXIT(WhseSetup."Require Receive");
        END;

        GetLocation(PurchLine."Location Code");
        IF PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" THEN
          EXIT(Location."Require Pick");

        EXIT(Location."Require Receive");
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetLocation@7300(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode = '' THEN
        Location.GetLocationSetup(LocationCode,Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE InsertRcptEntryRelation@38(VAR PurchRcptLine@1002 : Record 121) : Integer;
    VAR
      ItemEntryRelation@1001 : Record 6507;
    BEGIN
      TempHandlingSpecification.CopySpecification(TempTrackingSpecificationInv);
      TempHandlingSpecification.RESET;
      IF TempHandlingSpecification.FINDSET THEN BEGIN
        REPEAT
          ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification);
          ItemEntryRelation.TransferFieldsPurchRcptLine(PurchRcptLine);
          ItemEntryRelation.INSERT;
        UNTIL TempHandlingSpecification.NEXT = 0;
        TempHandlingSpecification.DELETEALL;
        EXIT(0);
      END;
      EXIT(ItemLedgShptEntryNo);
    END;

    LOCAL PROCEDURE InsertReturnEntryRelation@39(VAR ReturnShptLine@1002 : Record 6651) : Integer;
    VAR
      ItemEntryRelation@1001 : Record 6507;
    BEGIN
      TempHandlingSpecification.CopySpecification(TempTrackingSpecificationInv);
      TempHandlingSpecification.RESET;
      IF TempHandlingSpecification.FINDSET THEN BEGIN
        REPEAT
          ItemEntryRelation.INIT;
          ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification);
          ItemEntryRelation.TransferFieldsReturnShptLine(ReturnShptLine);
          ItemEntryRelation.INSERT;
        UNTIL TempHandlingSpecification.NEXT = 0;
        TempHandlingSpecification.DELETEALL;
        EXIT(0);
      END;
      EXIT(ItemLedgShptEntryNo);
    END;

    LOCAL PROCEDURE CheckTrackingSpecification@46(PurchHeader@1002 : Record 38;VAR TempItemPurchLine@1019 : TEMPORARY Record 39);
    VAR
      ReservationEntry@1001 : Record 337;
      Item@1016 : Record 27;
      ItemTrackingCode@1009 : Record 6502;
      ItemJnlLine@1006 : Record 83;
      CreateReservEntry@1004 : Codeunit 99000830;
      ItemTrackingManagement@1015 : Codeunit 6500;
      ErrorFieldCaption@1018 : Text[250];
      SignFactor@1005 : Integer;
      PurchLineQtyToHandle@1023 : Decimal;
      TrackingQtyToHandle@1003 : Decimal;
      Inbound@1010 : Boolean;
      SNRequired@1011 : Boolean;
      LotRequired@1012 : Boolean;
      SNInfoRequired@1013 : Boolean;
      LotInfoRequired@1014 : Boolean;
      CheckPurchLine@1008 : Boolean;
    BEGIN
      // if a PurchaseLine is posted with ItemTracking then tracked quantity must be equal to posted quantity
      IF NOT (PurchHeader."Document Type" IN
              [PurchHeader."Document Type"::Order,PurchHeader."Document Type"::"Return Order"])
      THEN
        EXIT;

      TrackingQtyToHandle := 0;

      WITH TempItemPurchLine DO BEGIN
        SETRANGE(Type,Type::Item);
        IF PurchHeader.Receive THEN BEGIN
          SETFILTER("Quantity Received",'<>%1',0);
          ErrorFieldCaption := FIELDCAPTION("Qty. to Receive");
        END ELSE BEGIN
          SETFILTER("Return Qty. Shipped",'<>%1',0);
          ErrorFieldCaption := FIELDCAPTION("Return Qty. to Ship");
        END;

        IF FINDSET THEN BEGIN
          ReservationEntry."Source Type" := DATABASE::"Purchase Line";
          ReservationEntry."Source Subtype" := PurchHeader."Document Type";
          SignFactor := CreateReservEntry.SignFactor(ReservationEntry);
          REPEAT
            // Only Item where no SerialNo or LotNo is required
            Item.GET("No.");
            IF Item."Item Tracking Code" <> '' THEN BEGIN
              Inbound := (Quantity * SignFactor) > 0;
              ItemTrackingCode.Code := Item."Item Tracking Code";
              ItemTrackingManagement.GetItemTrackingSettings(ItemTrackingCode,
                ItemJnlLine."Entry Type"::Purchase,Inbound,
                SNRequired,LotRequired,SNInfoRequired,LotInfoRequired);
              CheckPurchLine := NOT SNRequired AND NOT LotRequired;
              IF CheckPurchLine THEN
                CheckPurchLine := CheckTrackingExists(TempItemPurchLine);
            END ELSE
              CheckPurchLine := FALSE;

            TrackingQtyToHandle := 0;

            IF CheckPurchLine THEN BEGIN
              GetTrackingQuantities(TempItemPurchLine,TrackingQtyToHandle);
              TrackingQtyToHandle := TrackingQtyToHandle * SignFactor;
              IF PurchHeader.Receive THEN
                PurchLineQtyToHandle := "Qty. to Receive (Base)"
              ELSE
                PurchLineQtyToHandle := "Return Qty. to Ship (Base)";
              IF TrackingQtyToHandle <> PurchLineQtyToHandle THEN
                ERROR(STRSUBSTNO(ItemTrackQuantityMismatchErr,ErrorFieldCaption));
            END;
          UNTIL NEXT = 0;
        END;
      END;
    END;

    LOCAL PROCEDURE CheckTrackingExists@160(PurchLine@1000 : Record 39) : Boolean;
    VAR
      TrackingSpecification@1004 : Record 336;
      ReservEntry@1001 : Record 337;
    BEGIN
      TrackingSpecification.SetSourceFilter(
        DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.",TRUE);
      TrackingSpecification.SetSourceFilter2('',0);
      ReservEntry.SetSourceFilter(
        DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.",TRUE);
      ReservEntry.SetSourceFilter2('',0);

      TrackingSpecification.SETRANGE(Correction,FALSE);
      IF NOT TrackingSpecification.ISEMPTY THEN
        EXIT(TRUE);

      ReservEntry.SETFILTER("Serial No.",'<>%1','');
      IF NOT ReservEntry.ISEMPTY THEN
        EXIT(TRUE);
      ReservEntry.SETRANGE("Serial No.");
      ReservEntry.SETFILTER("Lot No.",'<>%1','');
      IF NOT ReservEntry.ISEMPTY THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetTrackingQuantities@47(PurchLine@1000 : Record 39;VAR TrackingQtyToHandle@1003 : Decimal);
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      ReservEntry.SetSourceFilter(
        DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.",TRUE);
      ReservEntry.SetSourceFilter2('',0);
      IF ReservEntry.FINDSET THEN
        REPEAT
          IF ReservEntry.TrackingExists THEN
            TrackingQtyToHandle := TrackingQtyToHandle + ReservEntry."Qty. to Handle (Base)";
        UNTIL ReservEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE SaveInvoiceSpecification@33(VAR TempInvoicingSpecification@1000 : TEMPORARY Record 336);
    BEGIN
      TempInvoicingSpecification.RESET;
      IF TempInvoicingSpecification.FINDSET THEN BEGIN
        REPEAT
          TempInvoicingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Quantity actual Handled (Base)";
          TempInvoicingSpecification."Quantity actual Handled (Base)" := 0;
          TempTrackingSpecification := TempInvoicingSpecification;
          TempTrackingSpecification."Buffer Status" := TempTrackingSpecification."Buffer Status"::MODIFY;
          IF NOT TempTrackingSpecification.INSERT THEN BEGIN
            TempTrackingSpecification.GET(TempInvoicingSpecification."Entry No.");
            TempTrackingSpecification."Qty. to Invoice (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
            TempTrackingSpecification."Quantity Invoiced (Base)" += TempInvoicingSpecification."Qty. to Invoice (Base)";
            TempTrackingSpecification."Qty. to Invoice" += TempInvoicingSpecification."Qty. to Invoice";
            TempTrackingSpecification.MODIFY;
          END;
        UNTIL TempInvoicingSpecification.NEXT = 0;
        TempInvoicingSpecification.DELETEALL;
      END;
    END;

    LOCAL PROCEDURE InsertTrackingSpecification@35(PurchHeader@1001 : Record 38);
    BEGIN
      IF NOT TempTrackingSpecification.ISEMPTY THEN BEGIN
        TempTrackingSpecification.InsertSpecification;
        ReservePurchLine.UpdateItemTrackingAfterPosting(PurchHeader);
      END;
    END;

    LOCAL PROCEDURE CalcBaseQty@29(ItemNo@1002 : Code[20];UOMCode@1004 : Code[10];Qty@1000 : Decimal) : Decimal;
    VAR
      Item@1003 : Record 27;
      UOMMgt@1001 : Codeunit 5402;
    BEGIN
      Item.GET(ItemNo);
      EXIT(ROUND(Qty * UOMMgt.GetQtyPerUnitOfMeasure(Item,UOMCode),0.00001));
    END;

    LOCAL PROCEDURE InsertValueEntryRelation@40();
    VAR
      ValueEntryRelation@1000 : Record 6508;
    BEGIN
      TempValueEntryRelation.RESET;
      IF TempValueEntryRelation.FINDSET THEN BEGIN
        REPEAT
          ValueEntryRelation := TempValueEntryRelation;
          ValueEntryRelation.INSERT;
        UNTIL TempValueEntryRelation.NEXT = 0;
        TempValueEntryRelation.DELETEALL;
      END;
    END;

    LOCAL PROCEDURE PostItemCharge@42(PurchHeader@1011 : Record 38;VAR PurchLine@1000 : Record 39;ItemEntryNo@1004 : Integer;QuantityBase@1005 : Decimal;AmountToAssign@1006 : Decimal;QtyToAssign@1007 : Decimal;IndirectCostPct@1008 : Decimal);
    VAR
      DummyTrackingSpecification@1001 : Record 336;
      PurchLineToPost@1009 : Record 39;
      CurrExchRate@1002 : Record 330;
      TotalChargeAmt@1003 : Decimal;
      TotalChargeAmtLCY@1010 : Decimal;
    BEGIN
      WITH TempItemChargeAssgntPurch DO BEGIN
        PurchLineToPost := PurchLine;
        PurchLineToPost."No." := "Item No.";
        PurchLineToPost."Line No." := "Document Line No.";
        PurchLineToPost."Appl.-to Item Entry" := ItemEntryNo;
        PurchLineToPost."Indirect Cost %" := IndirectCostPct;

        PurchLineToPost.Amount := AmountToAssign;

        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          PurchLineToPost.Amount := -PurchLineToPost.Amount;

        IF PurchLineToPost."Currency Code" <> '' THEN
          PurchLineToPost."Unit Cost" := ROUND(
              PurchLineToPost.Amount / QuantityBase,Currency."Unit-Amount Rounding Precision")
        ELSE
          PurchLineToPost."Unit Cost" := ROUND(
              PurchLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");

        TotalChargeAmt := TotalChargeAmt + PurchLineToPost.Amount;
        IF PurchHeader."Currency Code" <> '' THEN
          PurchLineToPost.Amount :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              Usedate,PurchHeader."Currency Code",TotalChargeAmt,PurchHeader."Currency Factor");

        PurchLineToPost.Amount := ROUND(PurchLineToPost.Amount,GLSetup."Amount Rounding Precision") - TotalChargeAmtLCY;
        IF PurchHeader."Currency Code" <> '' THEN
          TotalChargeAmtLCY := TotalChargeAmtLCY + PurchLineToPost.Amount;
        PurchLineToPost."Unit Cost (LCY)" :=
          ROUND(
            PurchLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");

        PurchLineToPost."Inv. Discount Amount" := ROUND(
            PurchLine."Inv. Discount Amount" / PurchLine.Quantity * QtyToAssign,
            GLSetup."Amount Rounding Precision");

        PurchLineToPost."Line Discount Amount" := ROUND(
            PurchLine."Line Discount Amount" / PurchLine.Quantity * QtyToAssign,
            GLSetup."Amount Rounding Precision");
        PurchLineToPost."Line Amount" := ROUND(
            PurchLine."Line Amount" / PurchLine.Quantity * QtyToAssign,
            GLSetup."Amount Rounding Precision");
        UpdatePurchLineDimSetIDFromAppliedEntry(PurchLineToPost,PurchLine);
        PurchLine."Inv. Discount Amount" := PurchLine."Inv. Discount Amount" - PurchLineToPost."Inv. Discount Amount";
        PurchLine."Line Discount Amount" := PurchLine."Line Discount Amount" - PurchLineToPost."Line Discount Amount";
        PurchLine."Line Amount" := PurchLine."Line Amount" - PurchLineToPost."Line Amount";
        PurchLine.Quantity := PurchLine.Quantity - QtyToAssign;
        PostItemJnlLine(
          PurchHeader,PurchLineToPost,
          0,0,
          QuantityBase,QuantityBase,
          PurchLineToPost."Appl.-to Item Entry","Item Charge No.",DummyTrackingSpecification);
      END;
    END;

    LOCAL PROCEDURE SaveTempWhseSplitSpec@45(PurchLine3@1000 : Record 39);
    BEGIN
      TempWhseSplitSpecification.RESET;
      TempWhseSplitSpecification.DELETEALL;
      IF TempHandlingSpecification.FINDSET THEN
        REPEAT
          TempWhseSplitSpecification := TempHandlingSpecification;
          TempWhseSplitSpecification."Source Type" := DATABASE::"Purchase Line";
          TempWhseSplitSpecification."Source Subtype" := PurchLine3."Document Type";
          TempWhseSplitSpecification."Source ID" := PurchLine3."Document No.";
          TempWhseSplitSpecification."Source Ref. No." := PurchLine3."Line No.";
          TempWhseSplitSpecification.INSERT;
        UNTIL TempHandlingSpecification.NEXT = 0;
    END;

    LOCAL PROCEDURE TransferReservToItemJnlLine@32(VAR SalesOrderLine@1000 : Record 37;VAR ItemJnlLine@1001 : Record 83;PurchLine@1007 : Record 39;QtyToBeShippedBase@1002 : Decimal;ApplySpecificItemTracking@1003 : Boolean);
    VAR
      ReserveSalesLine@1006 : Codeunit 99000832;
      RemainingQuantity@1004 : Decimal;
      CheckApplFromItemEntry@1005 : Boolean;
    BEGIN
      // Handle Item Tracking and reservations, also on drop shipment
      IF QtyToBeShippedBase = 0 THEN
        EXIT;

      IF NOT ApplySpecificItemTracking THEN
        ReserveSalesLine.TransferSalesLineToItemJnlLine(
          SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,FALSE)
      ELSE BEGIN
        TempTrackingSpecification.RESET;
        TempTrackingSpecification.SetSourceFilter(
          DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.",FALSE);
        TempTrackingSpecification.SetSourceFilter2('',0);
        IF TempTrackingSpecification.ISEMPTY THEN
          ReserveSalesLine.TransferSalesLineToItemJnlLine(
            SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,FALSE)
        ELSE BEGIN
          ReserveSalesLine.SetApplySpecificItemTracking(TRUE);
          ReserveSalesLine.SetOverruleItemTracking(TRUE);
          TempTrackingSpecification.FINDSET;
          IF TempTrackingSpecification."Quantity (Base)" / QtyToBeShippedBase < 0 THEN
            ERROR(ItemTrackingWrongSignErr);
          REPEAT
            ItemJnlLine.CopyTrackingFromSpec(TempTrackingSpecification);
            ItemJnlLine."Applies-to Entry" := TempTrackingSpecification."Item Ledger Entry No.";
            RemainingQuantity :=
              ReserveSalesLine.TransferSalesLineToItemJnlLine(
                SalesOrderLine,ItemJnlLine,TempTrackingSpecification."Quantity (Base)",CheckApplFromItemEntry,FALSE);
            IF RemainingQuantity <> 0 THEN
              ERROR(ItemTrackingMismatchErr);
          UNTIL TempTrackingSpecification.NEXT = 0;
          ItemJnlLine.ClearTracking;
          ItemJnlLine."Applies-to Entry" := 0;
        END;
      END;
    END;

    [External]
    PROCEDURE SetWhseRcptHeader@26(VAR WhseRcptHeader2@1000 : Record 7316);
    BEGIN
      WhseRcptHeader := WhseRcptHeader2;
      TempWhseRcptHeader := WhseRcptHeader;
      TempWhseRcptHeader.INSERT;
    END;

    [External]
    PROCEDURE SetWhseShptHeader@44(VAR WhseShptHeader2@1000 : Record 7320);
    BEGIN
      WhseShptHeader := WhseShptHeader2;
      TempWhseShptHeader := WhseShptHeader;
      TempWhseShptHeader.INSERT;
    END;

    LOCAL PROCEDURE GetNextPurchline@54(VAR PurchLine@1000 : Record 39) : Boolean;
    BEGIN
      IF NOT PurchaseLinesProcessed THEN
        IF PurchLine.NEXT = 1 THEN
          EXIT(FALSE);
      PurchaseLinesProcessed := TRUE;
      IF TempPrepmtPurchLine.FIND('-') THEN BEGIN
        PurchLine := TempPrepmtPurchLine;
        TempPrepmtPurchLine.DELETE;
        EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreatePrepmtLines@51(PurchHeader@1003 : Record 38;VAR TempPrepmtPurchLine@1004 : Record 39;CompleteFunctionality@1009 : Boolean);
    VAR
      GLAcc@1002 : Record 15;
      TempPurchLine@1000 : TEMPORARY Record 39;
      TempExtTextLine@1011 : TEMPORARY Record 280;
      GenPostingSetup@1005 : Record 252;
      TransferExtText@1012 : Codeunit 378;
      NextLineNo@1001 : Integer;
      Fraction@1008 : Decimal;
      VATDifference@1015 : Decimal;
      TempLineFound@1010 : Boolean;
      PrepmtAmtToDeduct@1016 : Decimal;
    BEGIN
      GetGLSetup;
      WITH TempPurchLine DO BEGIN
        FillTempLines(PurchHeader);
        ResetTempLines(TempPurchLine);
        IF NOT FINDLAST THEN
          EXIT;
        NextLineNo := "Line No." + 10000;
        SETFILTER(Quantity,'>0');
        SETFILTER("Qty. to Invoice",'>0');
        IF FINDSET THEN BEGIN
          IF CompleteFunctionality AND ("Document Type" = "Document Type"::Invoice) THEN
            TestGetRcptPPmtAmtToDeduct;
          REPEAT
            IF CompleteFunctionality THEN
              IF PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice THEN BEGIN
                IF NOT PurchHeader.Receive AND ("Qty. to Invoice" = Quantity - "Quantity Invoiced") THEN
                  IF "Qty. Rcd. Not Invoiced" < "Qty. to Invoice" THEN
                    VALIDATE("Qty. to Invoice","Qty. Rcd. Not Invoiced");
                Fraction := ("Qty. to Invoice" + "Quantity Invoiced") / Quantity;

                IF "Prepayment %" <> 100 THEN
                  CASE TRUE OF
                    ("Prepmt Amt to Deduct" <> 0) AND
                    (ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision") < "Prepmt Amt to Deduct"):
                      FIELDERROR(
                        "Prepmt Amt to Deduct",
                        STRSUBSTNO(
                          CannotBeGreaterThanErr,
                          ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision")));
                    ("Prepmt. Amt. Inv." <> 0) AND
                    (ROUND((1 - Fraction) * "Line Amount",Currency."Amount Rounding Precision") <
                     ROUND(
                       ROUND(
                         ROUND("Direct Unit Cost" * (Quantity - "Quantity Invoiced" - "Qty. to Invoice"),
                           Currency."Amount Rounding Precision") *
                         (1 - "Line Discount %" / 100),Currency."Amount Rounding Precision") *
                       "Prepayment %" / 100,Currency."Amount Rounding Precision")):
                      FIELDERROR(
                        "Prepmt Amt to Deduct",
                        STRSUBSTNO(
                          CannotBeSmallerThanErr,
                          ROUND(
                            "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" -
                            (1 - Fraction) * "Line Amount",Currency."Amount Rounding Precision")));
                  END;
              END;
            IF "Prepmt Amt to Deduct" <> 0 THEN BEGIN
              IF ("Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
                 ("Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
              THEN
                GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
              GLAcc.GET(GenPostingSetup.GetPurchPrepmtAccount);
              TempLineFound := FALSE;
              IF PurchHeader."Compress Prepayment" THEN BEGIN
                TempPrepmtPurchLine.SETRANGE("No.",GLAcc."No.");
                TempPrepmtPurchLine.SETRANGE("Job No.","Job No.");
                TempPrepmtPurchLine.SETRANGE("Dimension Set ID","Dimension Set ID");
                TempLineFound := TempPrepmtPurchLine.FINDFIRST;
              END;
              IF TempLineFound THEN BEGIN
                PrepmtAmtToDeduct :=
                  TempPrepmtPurchLine."Prepmt Amt to Deduct" +
                  InsertedPrepmtVATBaseToDeduct(
                    PurchHeader,TempPurchLine,TempPrepmtPurchLine."Line No.",TempPrepmtPurchLine."Direct Unit Cost");
                VATDifference := TempPrepmtPurchLine."VAT Difference";
                TempPrepmtPurchLine.VALIDATE(
                  "Direct Unit Cost",TempPrepmtPurchLine."Direct Unit Cost" + "Prepmt Amt to Deduct");
                TempPrepmtPurchLine.VALIDATE("VAT Difference",VATDifference - "Prepmt VAT Diff. to Deduct");
                TempPrepmtPurchLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                IF "Prepayment %" < TempPrepmtPurchLine."Prepayment %" THEN
                  TempPrepmtPurchLine."Prepayment %" := "Prepayment %";
                TempPrepmtPurchLine.MODIFY;
              END ELSE BEGIN
                TempPrepmtPurchLine.INIT;
                TempPrepmtPurchLine."Document Type" := PurchHeader."Document Type";
                TempPrepmtPurchLine."Document No." := PurchHeader."No.";
                TempPrepmtPurchLine."Line No." := 0;
                TempPrepmtPurchLine."System-Created Entry" := TRUE;
                IF CompleteFunctionality THEN
                  TempPrepmtPurchLine.VALIDATE(Type,TempPrepmtPurchLine.Type::"G/L Account")
                ELSE
                  TempPrepmtPurchLine.Type := TempPrepmtPurchLine.Type::"G/L Account";
                TempPrepmtPurchLine.VALIDATE("No.",GenPostingSetup."Purch. Prepayments Account");
                TempPrepmtPurchLine.VALIDATE(Quantity,-1);
                TempPrepmtPurchLine."Qty. to Receive" := TempPrepmtPurchLine.Quantity;
                TempPrepmtPurchLine."Qty. to Invoice" := TempPrepmtPurchLine.Quantity;
                PrepmtAmtToDeduct := InsertedPrepmtVATBaseToDeduct(PurchHeader,TempPurchLine,NextLineNo,0);
                TempPrepmtPurchLine.VALIDATE("Direct Unit Cost","Prepmt Amt to Deduct");
                TempPrepmtPurchLine.VALIDATE("VAT Difference",-"Prepmt VAT Diff. to Deduct");
                TempPrepmtPurchLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                TempPrepmtPurchLine."Prepayment %" := "Prepayment %";
                TempPrepmtPurchLine."Prepayment Line" := TRUE;
                TempPrepmtPurchLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                TempPrepmtPurchLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                TempPrepmtPurchLine."Dimension Set ID" := "Dimension Set ID";
                TempPrepmtPurchLine."Job No." := "Job No.";
                TempPrepmtPurchLine."Job Task No." := "Job Task No.";
                TempPrepmtPurchLine."Job Line Type" := "Job Line Type";
                TempPrepmtPurchLine."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 10000;
                TempPrepmtPurchLine.INSERT;

                TransferExtText.PrepmtGetAnyExtText(
                  TempPrepmtPurchLine."No.",DATABASE::"Purch. Inv. Line",
                  PurchHeader."Document Date",PurchHeader."Language Code",TempExtTextLine);
                IF TempExtTextLine.FIND('-') THEN
                  REPEAT
                    TempPrepmtPurchLine.INIT;
                    TempPrepmtPurchLine.Description := TempExtTextLine.Text;
                    TempPrepmtPurchLine."System-Created Entry" := TRUE;
                    TempPrepmtPurchLine."Prepayment Line" := TRUE;
                    TempPrepmtPurchLine."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 10000;
                    TempPrepmtPurchLine.INSERT;
                  UNTIL TempExtTextLine.NEXT = 0;
              END;
            END;
          UNTIL NEXT = 0
        END;
      END;
      DividePrepmtAmountLCY(TempPrepmtPurchLine,PurchHeader);
    END;

    LOCAL PROCEDURE InsertedPrepmtVATBaseToDeduct@82(PurchHeader@1004 : Record 38;PurchLine@1000 : Record 39;PrepmtLineNo@1001 : Integer;TotalPrepmtAmtToDeduct@1002 : Decimal) : Decimal;
    VAR
      PrepmtVATBaseToDeduct@1003 : Decimal;
    BEGIN
      WITH PurchLine DO BEGIN
        IF PurchHeader."Prices Including VAT" THEN
          PrepmtVATBaseToDeduct :=
            ROUND(
              (TotalPrepmtAmtToDeduct + "Prepmt Amt to Deduct") / (1 + "Prepayment VAT %" / 100),
              Currency."Amount Rounding Precision") -
            ROUND(
              TotalPrepmtAmtToDeduct / (1 + "Prepayment VAT %" / 100),
              Currency."Amount Rounding Precision")
        ELSE
          PrepmtVATBaseToDeduct := "Prepmt Amt to Deduct";
      END;
      WITH TempPrepmtDeductLCYPurchLine DO BEGIN
        TempPrepmtDeductLCYPurchLine := PurchLine;
        IF "Document Type" = "Document Type"::Order THEN
          "Qty. to Invoice" := GetQtyToInvoice(PurchLine,PurchHeader.Receive)
        ELSE
          GetLineDataFromOrder(TempPrepmtDeductLCYPurchLine);
        CalcPrepaymentToDeduct;
        "Line Amount" := GetLineAmountToHandle("Qty. to Invoice");
        "Attached to Line No." := PrepmtLineNo;
        "VAT Base Amount" := PrepmtVATBaseToDeduct;
        INSERT;
      END;
      EXIT(PrepmtVATBaseToDeduct);
    END;

    LOCAL PROCEDURE DividePrepmtAmountLCY@83(VAR PrepmtPurchLine@1000 : Record 39;PurchHeader@1006 : Record 38);
    VAR
      CurrExchRate@1001 : Record 330;
      ActualCurrencyFactor@1002 : Decimal;
    BEGIN
      WITH PrepmtPurchLine DO BEGIN
        RESET;
        SETFILTER(Type,'<>%1',Type::" ");
        IF FINDSET THEN
          REPEAT
            IF PurchHeader."Currency Code" <> '' THEN
              ActualCurrencyFactor :=
                ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    PurchHeader."Posting Date",
                    PurchHeader."Currency Code",
                    "Prepmt Amt to Deduct",
                    PurchHeader."Currency Factor")) /
                "Prepmt Amt to Deduct"
            ELSE
              ActualCurrencyFactor := 1;

            UpdatePrepmtAmountInvBuf("Line No.",ActualCurrencyFactor);
          UNTIL NEXT = 0;
        RESET;
      END;
    END;

    LOCAL PROCEDURE UpdatePrepmtAmountInvBuf@78(PrepmtSalesLineNo@1000 : Integer;CurrencyFactor@1004 : Decimal);
    VAR
      PrepmtAmtRemainder@1002 : Decimal;
    BEGIN
      WITH TempPrepmtDeductLCYPurchLine DO BEGIN
        RESET;
        SETRANGE("Attached to Line No.",PrepmtSalesLineNo);
        IF FINDSET(TRUE) THEN
          REPEAT
            "Prepmt. Amount Inv. (LCY)" :=
              CalcRoundedAmount(CurrencyFactor * "VAT Base Amount",PrepmtAmtRemainder);
            MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE AdjustPrepmtAmountLCY@84(PurchHeader@1008 : Record 38;VAR PrepmtPurchLine@1000 : Record 39);
    VAR
      PurchLine@1005 : Record 39;
      PurchInvoiceLine@1013 : Record 39;
      DeductionFactor@1001 : Decimal;
      PrepmtVATPart@1006 : Decimal;
      PrepmtVATAmtRemainder@1011 : Decimal;
      TotalRoundingAmount@1002 : ARRAY [2] OF Decimal;
      TotalPrepmtAmount@1003 : ARRAY [2] OF Decimal;
      FinalInvoice@1004 : Boolean;
      PricesInclVATRoundingAmount@1007 : ARRAY [2] OF Decimal;
    BEGIN
      IF PrepmtPurchLine."Prepayment Line" THEN BEGIN
        PrepmtVATPart :=
          (PrepmtPurchLine."Amount Including VAT" - PrepmtPurchLine.Amount) / PrepmtPurchLine."Direct Unit Cost";

        WITH TempPrepmtDeductLCYPurchLine DO BEGIN
          RESET;
          SETRANGE("Attached to Line No.",PrepmtPurchLine."Line No.");
          IF FINDSET(TRUE) THEN BEGIN
            FinalInvoice := IsFinalInvoice;
            REPEAT
              PurchLine := TempPrepmtDeductLCYPurchLine;
              PurchLine.FIND;
              IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                PurchInvoiceLine := PurchLine;
                GetPurchOrderLine(PurchLine,PurchInvoiceLine);
                PurchLine."Qty. to Invoice" := PurchInvoiceLine."Qty. to Invoice";
              END;
              IF PurchLine."Qty. to Invoice" <> "Qty. to Invoice" THEN
                PurchLine."Prepmt Amt to Deduct" := CalcPrepmtAmtToDeduct(PurchLine,PurchHeader.Receive);
              DeductionFactor :=
                PurchLine."Prepmt Amt to Deduct" /
                (PurchLine."Prepmt. Amt. Inv." - PurchLine."Prepmt Amt Deducted");

              "Prepmt. VAT Amount Inv. (LCY)" :=
                -CalcRoundedAmount(PurchLine."Prepmt Amt to Deduct" * PrepmtVATPart,PrepmtVATAmtRemainder);
              IF ("Prepayment %" <> 100) OR IsFinalInvoice OR ("Currency Code" <> '') THEN
                CalcPrepmtRoundingAmounts(TempPrepmtDeductLCYPurchLine,PurchLine,DeductionFactor,TotalRoundingAmount);
              MODIFY;

              IF PurchHeader."Prices Including VAT" THEN
                IF (("Prepayment %" <> 100) OR IsFinalInvoice) AND (DeductionFactor = 1) THEN BEGIN
                  PricesInclVATRoundingAmount[1] := TotalRoundingAmount[1];
                  PricesInclVATRoundingAmount[2] := TotalRoundingAmount[2];
                END;

              IF "VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT" THEN
                TotalPrepmtAmount[1] += "Prepmt. Amount Inv. (LCY)";
              TotalPrepmtAmount[2] += "Prepmt. VAT Amount Inv. (LCY)";
              FinalInvoice := FinalInvoice AND IsFinalInvoice;
            UNTIL NEXT = 0;
          END;
        END;

        UpdatePrepmtPurchLineWithRounding(
          PrepmtPurchLine,TotalRoundingAmount,TotalPrepmtAmount,
          FinalInvoice,PricesInclVATRoundingAmount);
      END;
    END;

    LOCAL PROCEDURE CalcPrepmtAmtToDeduct@53(PurchLine@1000 : Record 39;Receive@1001 : Boolean) : Decimal;
    BEGIN
      WITH PurchLine DO BEGIN
        "Qty. to Invoice" := GetQtyToInvoice(PurchLine,Receive);
        CalcPrepaymentToDeduct;
        EXIT("Prepmt Amt to Deduct");
      END;
    END;

    LOCAL PROCEDURE GetQtyToInvoice@94(PurchLine@1000 : Record 39;Receive@1002 : Boolean) : Decimal;
    VAR
      AllowedQtyToInvoice@1001 : Decimal;
    BEGIN
      WITH PurchLine DO BEGIN
        AllowedQtyToInvoice := "Qty. Rcd. Not Invoiced";
        IF Receive THEN
          AllowedQtyToInvoice := AllowedQtyToInvoice + "Qty. to Receive";
        IF "Qty. to Invoice" > AllowedQtyToInvoice THEN
          EXIT(AllowedQtyToInvoice);
        EXIT("Qty. to Invoice");
      END;
    END;

    LOCAL PROCEDURE GetLineDataFromOrder@95(VAR PurchLine@1000 : Record 39);
    VAR
      PurchRcptLine@1001 : Record 121;
      PurchOrderLine@1002 : Record 39;
    BEGIN
      WITH PurchLine DO BEGIN
        PurchRcptLine.GET("Receipt No.","Receipt Line No.");
        PurchOrderLine.GET("Document Type"::Order,PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");

        Quantity := PurchOrderLine.Quantity;
        "Qty. Rcd. Not Invoiced" := PurchOrderLine."Qty. Rcd. Not Invoiced";
        "Quantity Invoiced" := PurchOrderLine."Quantity Invoiced";
        "Prepmt Amt Deducted" := PurchOrderLine."Prepmt Amt Deducted";
        "Prepmt. Amt. Inv." := PurchOrderLine."Prepmt. Amt. Inv.";
        "Line Discount Amount" := PurchOrderLine."Line Discount Amount";
      END;
    END;

    LOCAL PROCEDURE CalcPrepmtRoundingAmounts@58(VAR PrepmtPurchLineBuf@1000 : Record 39;PurchLine@1003 : Record 39;DeductionFactor@1001 : Decimal;VAR TotalRoundingAmount@1002 : ARRAY [2] OF Decimal);
    VAR
      RoundingAmount@1004 : ARRAY [2] OF Decimal;
    BEGIN
      WITH PrepmtPurchLineBuf DO BEGIN
        IF "VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT" THEN BEGIN
          RoundingAmount[1] :=
            "Prepmt. Amount Inv. (LCY)" - ROUND(DeductionFactor * PurchLine."Prepmt. Amount Inv. (LCY)");
          "Prepmt. Amount Inv. (LCY)" := "Prepmt. Amount Inv. (LCY)" - RoundingAmount[1];
          TotalRoundingAmount[1] += RoundingAmount[1];
        END;
        RoundingAmount[2] :=
          "Prepmt. VAT Amount Inv. (LCY)" - ROUND(DeductionFactor * PurchLine."Prepmt. VAT Amount Inv. (LCY)");
        "Prepmt. VAT Amount Inv. (LCY)" := "Prepmt. VAT Amount Inv. (LCY)" - RoundingAmount[2];
        TotalRoundingAmount[2] += RoundingAmount[2];
      END;
    END;

    LOCAL PROCEDURE UpdatePrepmtPurchLineWithRounding@89(VAR PrepmtPurchLine@1002 : Record 39;TotalRoundingAmount@1001 : ARRAY [2] OF Decimal;TotalPrepmtAmount@1000 : ARRAY [2] OF Decimal;FinalInvoice@1005 : Boolean;PricesInclVATRoundingAmount@1006 : ARRAY [2] OF Decimal);
    VAR
      AdjustAmount@1008 : Boolean;
      NewAmountIncludingVAT@1003 : Decimal;
      Prepmt100PctVATRoundingAmt@1004 : Decimal;
      AmountRoundingPrecision@1007 : Decimal;
    BEGIN
      WITH PrepmtPurchLine DO BEGIN
        NewAmountIncludingVAT := TotalPrepmtAmount[1] + TotalPrepmtAmount[2] + TotalRoundingAmount[1] + TotalRoundingAmount[2];
        IF "Prepayment %" = 100 THEN
          TotalRoundingAmount[1] -= "Amount Including VAT" + NewAmountIncludingVAT;
        AmountRoundingPrecision :=
          GetAmountRoundingPrecisionInLCY("Document Type","Document No.","Currency Code");

        IF (ABS(TotalRoundingAmount[1]) <= AmountRoundingPrecision) AND
           (ABS(TotalRoundingAmount[2]) <= AmountRoundingPrecision)
        THEN BEGIN
          IF "Prepayment %" = 100 THEN
            Prepmt100PctVATRoundingAmt := TotalRoundingAmount[1];
          TotalRoundingAmount[1] := 0;
        END;
        "Prepmt. Amount Inv. (LCY)" := -TotalRoundingAmount[1];
        Amount := -(TotalPrepmtAmount[1] + TotalRoundingAmount[1]);

        IF (PricesInclVATRoundingAmount[1] <> 0) AND (TotalRoundingAmount[1] = 0) THEN BEGIN
          IF ("Prepayment %" = 100) AND FinalInvoice AND
             (Amount - TotalPrepmtAmount[2] = "Amount Including VAT")
          THEN
            Prepmt100PctVATRoundingAmt := 0;
          PricesInclVATRoundingAmount[1] := 0;
        END;

        IF ((TotalRoundingAmount[2] <> 0) OR FinalInvoice) AND (TotalRoundingAmount[1] = 0) THEN BEGIN
          IF ("Prepayment %" = 100) AND ("Prepmt. Amount Inv. (LCY)" = 0) THEN
            Prepmt100PctVATRoundingAmt += TotalRoundingAmount[2];
          TotalRoundingAmount[2] := 0;
        END;

        IF (PricesInclVATRoundingAmount[2] <> 0) AND (TotalRoundingAmount[2] = 0) THEN BEGIN
          IF ABS(Prepmt100PctVATRoundingAmt) <= AmountRoundingPrecision THEN
            Prepmt100PctVATRoundingAmt := 0;
          PricesInclVATRoundingAmount[2] := 0;
        END;

        "Prepmt. VAT Amount Inv. (LCY)" := -(TotalRoundingAmount[2] + Prepmt100PctVATRoundingAmt);
        NewAmountIncludingVAT := Amount - (TotalPrepmtAmount[2] + TotalRoundingAmount[2]);
        IF (PricesInclVATRoundingAmount[1] = 0) AND (PricesInclVATRoundingAmount[2] = 0) OR
           ("Currency Code" <> '') AND FinalInvoice
        THEN
          Increment(
            TotalPurchLineLCY."Amount Including VAT",
            -("Amount Including VAT" - NewAmountIncludingVAT + Prepmt100PctVATRoundingAmt));
        IF "Currency Code" = '' THEN
          TotalPurchLine."Amount Including VAT" := TotalPurchLineLCY."Amount Including VAT";
        "Amount Including VAT" := NewAmountIncludingVAT;

        IF FinalInvoice THEN
          AdjustAmount :=
            (TotalPurchLine.Amount = 0) AND (TotalPurchLine."Amount Including VAT" <> 0) AND
            (ABS(TotalPurchLine."Amount Including VAT") <= Currency."Amount Rounding Precision")
        ELSE
          AdjustAmount := (TotalPurchLineLCY.Amount < 0) AND (TotalPurchLineLCY."Amount Including VAT" < 0);
        IF AdjustAmount THEN BEGIN
          "Amount Including VAT" -= TotalPurchLineLCY."Amount Including VAT";
          TotalPurchLine."Amount Including VAT" := 0;
          TotalPurchLineLCY."Amount Including VAT" := 0;
        END;
      END;
    END;

    LOCAL PROCEDURE CalcRoundedAmount@91(Amount@1000 : Decimal;VAR Remainder@1001 : Decimal) : Decimal;
    VAR
      AmountRnded@1002 : Decimal;
    BEGIN
      Amount := Amount + Remainder;
      AmountRnded := ROUND(Amount,GLSetup."Amount Rounding Precision");
      Remainder := Amount - AmountRnded;
      EXIT(AmountRnded);
    END;

    LOCAL PROCEDURE GetPurchOrderLine@85(VAR PurchOrderLine@1000 : Record 39;PurchLine@1001 : Record 39);
    VAR
      PurchRcptLine@1002 : Record 121;
    BEGIN
      PurchRcptLine.GET(PurchLine."Receipt No.",PurchLine."Receipt Line No.");
      PurchOrderLine.GET(
        PurchOrderLine."Document Type"::Order,
        PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");
      PurchOrderLine."Prepmt Amt to Deduct" := PurchLine."Prepmt Amt to Deduct";
    END;

    LOCAL PROCEDURE DecrementPrepmtAmtInvLCY@86(PurchLine@1000 : Record 39;VAR PrepmtAmountInvLCY@1001 : Decimal;VAR PrepmtVATAmountInvLCY@1002 : Decimal);
    BEGIN
      TempPrepmtDeductLCYPurchLine.RESET;
      TempPrepmtDeductLCYPurchLine := PurchLine;
      IF TempPrepmtDeductLCYPurchLine.FIND THEN BEGIN
        PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYPurchLine."Prepmt. Amount Inv. (LCY)";
        PrepmtVATAmountInvLCY := PrepmtVATAmountInvLCY - TempPrepmtDeductLCYPurchLine."Prepmt. VAT Amount Inv. (LCY)";
      END;
    END;

    LOCAL PROCEDURE AdjustFinalInvWith100PctPrepmt@97(VAR CombinedPurchLine@1000 : Record 39);
    VAR
      DiffToLineDiscAmt@1001 : Decimal;
    BEGIN
      WITH TempPrepmtDeductLCYPurchLine DO BEGIN
        RESET;
        SETRANGE("Prepayment %",100);
        IF FINDSET(TRUE) THEN
          REPEAT
            IF IsFinalInvoice THEN BEGIN
              DiffToLineDiscAmt := "Prepmt Amt to Deduct" - "Line Amount";
              IF "Document Type" = "Document Type"::Order THEN
                DiffToLineDiscAmt := DiffToLineDiscAmt * Quantity / "Qty. to Invoice";
              IF DiffToLineDiscAmt <> 0 THEN BEGIN
                CombinedPurchLine.GET("Document Type","Document No.","Line No.");
                CombinedPurchLine."Line Discount Amount" -= DiffToLineDiscAmt;
                CombinedPurchLine.MODIFY;

                "Line Discount Amount" := CombinedPurchLine."Line Discount Amount";
                MODIFY;
              END;
            END;
          UNTIL NEXT = 0;
        RESET;
      END;
    END;

    LOCAL PROCEDURE GetPrepmtDiffToLineAmount@98(PurchLine@1000 : Record 39) : Decimal;
    BEGIN
      WITH TempPrepmtDeductLCYPurchLine DO
        IF PurchLine."Prepayment %" = 100 THEN
          IF GET(PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.") THEN
            EXIT("Prepmt Amt to Deduct" - "Line Amount");
      EXIT(0);
    END;

    LOCAL PROCEDURE MergePurchLines@50(PurchHeader@1000000004 : Record 38;VAR PurchLine@1000 : Record 39;VAR PurchLine2@1000000002 : Record 39;VAR MergedPurchLine@1000000003 : Record 39);
    BEGIN
      WITH PurchLine DO BEGIN
        SETRANGE("Document Type",PurchHeader."Document Type");
        SETRANGE("Document No.",PurchHeader."No.");
        IF FIND('-') THEN
          REPEAT
            MergedPurchLine := PurchLine;
            MergedPurchLine.INSERT;
          UNTIL NEXT = 0;
      END;
      WITH PurchLine2 DO BEGIN
        SETRANGE("Document Type",PurchHeader."Document Type");
        SETRANGE("Document No.",PurchHeader."No.");
        IF FIND('-') THEN
          REPEAT
            MergedPurchLine := PurchLine2;
            MergedPurchLine.INSERT;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE InsertICGenJnlLine@150(PurchHeader@1007 : Record 38;PurchLine@1000 : Record 39;VAR ICGenJnlLineNo@1006 : Integer);
    VAR
      ICGLAccount@1001 : Record 410;
      Cust@1002 : Record 18;
      Currency@1003 : Record 4;
      ICPartner@1004 : Record 413;
      CurrExchRate@1005 : Record 330;
      GenJnlLine@1008 : Record 81;
    BEGIN
      PurchHeader.TESTFIELD("Buy-from IC Partner Code",'');
      PurchHeader.TESTFIELD("Pay-to IC Partner Code",'');
      PurchLine.TESTFIELD("IC Partner Ref. Type",PurchLine."IC Partner Ref. Type"::"G/L Account");
      ICGLAccount.GET(PurchLine."IC Partner Reference");
      ICGenJnlLineNo := ICGenJnlLineNo + 1;

      WITH TempICGenJnlLine DO BEGIN
        InitNewLine(PurchHeader."Posting Date",PurchHeader."Document Date",PurchHeader."Posting Description",
          PurchLine."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 2 Code",PurchLine."Dimension Set ID",
          PurchHeader."Reason Code");
        "Line No." := ICGenJnlLineNo;

        CopyDocumentFields(GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PurchHeader."Posting No. Series");

        VALIDATE("Account Type","Account Type"::"IC Partner");
        VALIDATE("Account No.",PurchLine."IC Partner Code");
        "Source Currency Code" := PurchHeader."Currency Code";
        "Source Currency Amount" := Amount;
        Correction := PurchHeader.Correction;
        "Country/Region Code" := PurchHeader."VAT Country/Region Code";
        "Source Type" := GenJnlLine."Source Type"::Vendor;
        "Source No." := PurchHeader."Pay-to Vendor No.";
        "Source Line No." := PurchLine."Line No.";
        VALIDATE("Bal. Account Type","Bal. Account Type"::"G/L Account");
        VALIDATE("Bal. Account No.",PurchLine."No.");

        Cust.SETRANGE("IC Partner Code",PurchLine."IC Partner Code");
        IF Cust.FINDFIRST THEN BEGIN
          VALIDATE("Bal. Gen. Bus. Posting Group",Cust."Gen. Bus. Posting Group");
          VALIDATE("Bal. VAT Bus. Posting Group",Cust."VAT Bus. Posting Group");
        END;
        VALIDATE("Bal. VAT Prod. Posting Group",PurchLine."VAT Prod. Posting Group");
        "IC Partner Code" := PurchLine."IC Partner Code";
        "IC Partner G/L Acc. No." := PurchLine."IC Partner Reference";
        "IC Direction" := "IC Direction"::Outgoing;
        ICPartner.GET(PurchLine."IC Partner Code");
        IF ICPartner."Cost Distribution in LCY" AND (PurchLine."Currency Code" <> '') THEN BEGIN
          "Currency Code" := '';
          "Currency Factor" := 0;
          Currency.GET(PurchLine."Currency Code");
          IF PurchHeader.IsCreditDocType THEN
            Amount :=
              -ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  PurchHeader."Posting Date",PurchLine."Currency Code",
                  PurchLine.Amount,PurchHeader."Currency Factor"))
          ELSE
            Amount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  PurchHeader."Posting Date",PurchLine."Currency Code",
                  PurchLine.Amount,PurchHeader."Currency Factor"));
        END ELSE BEGIN
          Currency.InitRoundingPrecision;
          "Currency Code" := PurchHeader."Currency Code";
          "Currency Factor" := PurchHeader."Currency Factor";
          IF PurchHeader.IsCreditDocType THEN
            Amount := -PurchLine.Amount
          ELSE
            Amount := PurchLine.Amount;
        END;
        IF "Bal. VAT %" <> 0 THEN
          Amount := ROUND(Amount * (1 + "Bal. VAT %" / 100),Currency."Amount Rounding Precision");
        VALIDATE(Amount);
        INSERT;
      END;
    END;

    LOCAL PROCEDURE PostICGenJnl@151();
    VAR
      ICInboxOutboxMgt@1001 : Codeunit 427;
      ICTransactionNo@1000 : Integer;
    BEGIN
      TempICGenJnlLine.RESET;
      IF TempICGenJnlLine.FIND('-') THEN
        REPEAT
          ICTransactionNo := ICInboxOutboxMgt.CreateOutboxJnlTransaction(TempICGenJnlLine,FALSE);
          ICInboxOutboxMgt.CreateOutboxJnlLine(ICTransactionNo,1,TempICGenJnlLine);
          IF TempICGenJnlLine.Amount <> 0 THEN
            GenJnlPostLine.RunWithCheck(TempICGenJnlLine);
        UNTIL TempICGenJnlLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TestGetRcptPPmtAmtToDeduct@57();
    VAR
      TempPurchLine@1007 : TEMPORARY Record 39;
      TempRcvdPurchLine@1005 : TEMPORARY Record 39;
      TempTotalPurchLine@1004 : TEMPORARY Record 39;
      TempPurchRcptLine@1003 : TEMPORARY Record 121;
      PurchRcptLine@1000 : Record 121;
      MaxAmtToDeduct@1002 : Decimal;
    BEGIN
      WITH TempPurchLine DO BEGIN
        ResetTempLines(TempPurchLine);
        SETFILTER(Quantity,'>0');
        SETFILTER("Qty. to Invoice",'>0');
        SETFILTER("Receipt No.",'<>%1','');
        SETFILTER("Prepmt Amt to Deduct",'<>0');
        IF ISEMPTY THEN
          EXIT;

        SETRANGE("Prepmt Amt to Deduct");
        IF FINDSET THEN
          REPEAT
            IF PurchRcptLine.GET("Receipt No.","Receipt Line No.") THEN BEGIN
              TempRcvdPurchLine := TempPurchLine;
              TempRcvdPurchLine.INSERT;
              TempPurchRcptLine := PurchRcptLine;
              IF TempPurchRcptLine.INSERT THEN;

              IF NOT TempTotalPurchLine.GET("Document Type"::Order,PurchRcptLine."Order No.",PurchRcptLine."Order Line No.")
              THEN BEGIN
                TempTotalPurchLine.INIT;
                TempTotalPurchLine."Document Type" := "Document Type"::Order;
                TempTotalPurchLine."Document No." := PurchRcptLine."Order No.";
                TempTotalPurchLine."Line No." := PurchRcptLine."Order Line No.";
                TempTotalPurchLine.INSERT;
              END;
              TempTotalPurchLine."Qty. to Invoice" := TempTotalPurchLine."Qty. to Invoice" + "Qty. to Invoice";
              TempTotalPurchLine."Prepmt Amt to Deduct" := TempTotalPurchLine."Prepmt Amt to Deduct" + "Prepmt Amt to Deduct";
              AdjustInvLineWith100PctPrepmt(TempPurchLine,TempTotalPurchLine);
              TempTotalPurchLine.MODIFY;
            END;
          UNTIL NEXT = 0;

        IF TempRcvdPurchLine.FINDSET THEN
          REPEAT
            IF TempPurchRcptLine.GET(TempRcvdPurchLine."Receipt No.",TempRcvdPurchLine."Receipt Line No.") THEN
              IF   GET(TempRcvdPurchLine."Document Type"::Order,TempPurchRcptLine."Order No.",TempPurchRcptLine."Order Line No.") THEN
                IF TempTotalPurchLine.GET(
                     TempRcvdPurchLine."Document Type"::Order,TempPurchRcptLine."Order No.",TempPurchRcptLine."Order Line No.")
                THEN BEGIN
                  MaxAmtToDeduct := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";

                  IF TempTotalPurchLine."Prepmt Amt to Deduct" > MaxAmtToDeduct THEN
                    ERROR(STRSUBSTNO(PrepAmountToDeductToBigErr,FIELDCAPTION("Prepmt Amt to Deduct"),MaxAmtToDeduct));

                  IF (TempTotalPurchLine."Qty. to Invoice" = Quantity - "Quantity Invoiced") AND
                     (TempTotalPurchLine."Prepmt Amt to Deduct" <> MaxAmtToDeduct)
                  THEN
                    ERROR(STRSUBSTNO(PrepAmountToDeductToSmallErr,FIELDCAPTION("Prepmt Amt to Deduct"),MaxAmtToDeduct));
                END;
          UNTIL TempRcvdPurchLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE AdjustInvLineWith100PctPrepmt@99(VAR PurchInvoiceLine@1000 : Record 39;VAR TempTotalPurchLine@1001 : TEMPORARY Record 39);
    VAR
      PurchOrderLine@1003 : Record 39;
      DiffAmtToDeduct@1002 : Decimal;
    BEGIN
      IF PurchInvoiceLine."Prepayment %" = 100 THEN BEGIN
        PurchOrderLine := TempTotalPurchLine;
        PurchOrderLine.FIND;
        IF TempTotalPurchLine."Qty. to Invoice" = PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced" THEN BEGIN
          DiffAmtToDeduct :=
            PurchOrderLine."Prepmt. Amt. Inv." - PurchOrderLine."Prepmt Amt Deducted" - TempTotalPurchLine."Prepmt Amt to Deduct";
          IF DiffAmtToDeduct <> 0 THEN BEGIN
            PurchInvoiceLine."Prepmt Amt to Deduct" := PurchInvoiceLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
            PurchInvoiceLine."Line Amount" := PurchInvoiceLine."Prepmt Amt to Deduct";
            PurchInvoiceLine."Line Discount Amount" := PurchInvoiceLine."Line Discount Amount" - DiffAmtToDeduct;
            ModifyTempLine(PurchInvoiceLine);
            TempTotalPurchLine."Prepmt Amt to Deduct" := TempTotalPurchLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
          END;
        END;
      END;
    END;

    [External]
    PROCEDURE ArchiveUnpostedOrder@56(PurchHeader@1001 : Record 38);
    VAR
      PurchLine@1002 : Record 39;
      ArchiveManagement@1000 : Codeunit 5063;
    BEGIN
      PurchSetup.GET;
      IF NOT PurchSetup."Archive Quotes and Orders" THEN
        EXIT;
      IF NOT (PurchHeader."Document Type" IN [PurchHeader."Document Type"::Order,PurchHeader."Document Type"::"Return Order"]) THEN
        EXIT;

      PurchLine.RESET;
      PurchLine.SETRANGE("Document Type",PurchHeader."Document Type");
      PurchLine.SETRANGE("Document No.",PurchHeader."No.");
      PurchLine.SETFILTER(Quantity,'<>0');
      IF PurchHeader."Document Type" = PurchHeader."Document Type"::Order THEN
        PurchLine.SETFILTER("Qty. to Receive",'<>0')
      ELSE
        PurchLine.SETFILTER("Return Qty. to Ship",'<>0');
      IF NOT PurchLine.ISEMPTY AND NOT PreviewMode THEN BEGIN
        RoundDeferralsForArchive(PurchHeader,PurchLine);
        ArchiveManagement.ArchPurchDocumentNoConfirm(PurchHeader);
      END;
    END;

    LOCAL PROCEDURE PostItemJnlLineJobConsumption@59(PurchHeader@1007 : Record 38;VAR PurchLine@1000 : Record 39;ItemJournalLine@1008 : Record 83;VAR TempPurchReservEntry@1009 : TEMPORARY Record 337;QtyToBeInvoiced@1004 : Decimal;QtyToBeReceived@1002 : Decimal);
    VAR
      ItemLedgEntry@1102 : Record 32;
      TempReservationEntry@1003 : TEMPORARY Record 337;
    BEGIN
      WITH PurchLine DO
        IF "Job No." <> '' THEN BEGIN
          ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::"Negative Adjmt.";
          Job.GET("Job No.");
          ItemJournalLine."Source No." := Job."Bill-to Customer No.";
          IF PurchHeader.Invoice THEN BEGIN
            ItemLedgEntry.RESET;
            ItemLedgEntry.SETRANGE("Document No.",ReturnShptLine."Document No.");
            ItemLedgEntry.SETRANGE("Item No.",ReturnShptLine."No.");
            ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::"Negative Adjmt.");
            ItemLedgEntry.SETRANGE("Completely Invoiced",FALSE);
            IF ItemLedgEntry.FINDFIRST THEN
              ItemJournalLine."Item Shpt. Entry No." := ItemLedgEntry."Entry No.";
          END;
          ItemJournalLine."Source Type" := ItemJournalLine."Source Type"::Customer;
          ItemJournalLine."Discount Amount" := 0;
          IF "Quantity Received" > 0 THEN
            GetAppliedOutboundItemLedgEntryNo(ItemJournalLine)
          ELSE
            IF "Quantity Received" < 0 THEN
              GetAppliedInboundItemLedgEntryNo(ItemJournalLine);

          IF QtyToBeReceived <> 0 THEN
            CopyJobConsumptionReservation(
              TempReservationEntry,TempPurchReservEntry,ItemJournalLine."Entry Type",ItemJournalLine."Line No.");

          ItemJnlPostLine.RunPostWithReservation(ItemJournalLine,TempReservationEntry);

          IF QtyToBeInvoiced <> 0 THEN BEGIN
            "Qty. to Invoice" := QtyToBeInvoiced;
            JobPostLine.PostJobOnPurchaseLine(PurchHeader,PurchInvHeader,PurchCrMemoHeader,PurchLine,SrcCode);
          END;
        END;
    END;

    LOCAL PROCEDURE CopyJobConsumptionReservation@175(VAR TempReservEntryJobCons@1001 : TEMPORARY Record 337;VAR TempReservEntryPurchase@1002 : TEMPORARY Record 337;SourceSubtype@1003 : Option;SourceRefNo@1004 : Integer);
    VAR
      NextReservationEntryNo@1000 : Integer;
    BEGIN
      // Item tracking for consumption
      NextReservationEntryNo := 1;
      IF TempReservEntryPurchase.FINDSET THEN
        REPEAT
          TempReservEntryJobCons := TempReservEntryPurchase;

          WITH TempReservEntryJobCons DO BEGIN
            "Entry No." := NextReservationEntryNo;
            Positive := NOT Positive;
            "Quantity (Base)" := -"Quantity (Base)";
            "Shipment Date" := "Expected Receipt Date";
            "Expected Receipt Date" := 0D;
            Quantity := -Quantity;
            "Qty. to Handle (Base)" := -"Qty. to Handle (Base)";
            "Qty. to Invoice (Base)" := -"Qty. to Invoice (Base)";
            "Source Subtype" := SourceSubtype;
            "Source Ref. No." := SourceRefNo;
            INSERT;
          END;

          NextReservationEntryNo := NextReservationEntryNo + 1;
        UNTIL TempReservEntryPurchase.NEXT = 0;
    END;

    LOCAL PROCEDURE GetAppliedOutboundItemLedgEntryNo@80(VAR ItemJnlLine@1000 : Record 83);
    VAR
      ItemApplicationEntry@1001 : Record 339;
    BEGIN
      WITH ItemApplicationEntry DO BEGIN
        SETRANGE("Inbound Item Entry No.",ItemJnlLine."Item Shpt. Entry No.");
        IF FINDLAST THEN
          ItemJnlLine."Item Shpt. Entry No." := "Outbound Item Entry No.";
      END
    END;

    LOCAL PROCEDURE GetAppliedInboundItemLedgEntryNo@207(VAR ItemJnlLine@1000 : Record 83);
    VAR
      ItemApplicationEntry@1001 : Record 339;
    BEGIN
      WITH ItemApplicationEntry DO BEGIN
        SETRANGE("Outbound Item Entry No.",ItemJnlLine."Item Shpt. Entry No.");
        IF FINDLAST THEN
          ItemJnlLine."Item Shpt. Entry No." := "Inbound Item Entry No.";
      END
    END;

    LOCAL PROCEDURE ItemLedgerEntryExist@7(PurchLine2@1000 : Record 39;ReceiveOrShip@1002 : Boolean) : Boolean;
    VAR
      HasItemLedgerEntry@1001 : Boolean;
    BEGIN
      IF ReceiveOrShip THEN
        // item ledger entry will be created during posting in this transaction
        HasItemLedgerEntry :=
          ((PurchLine2."Qty. to Receive" + PurchLine2."Quantity Received") <> 0) OR
          ((PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced") <> 0) OR
          ((PurchLine2."Return Qty. to Ship" + PurchLine2."Return Qty. Shipped") <> 0)
      ELSE
        // item ledger entry must already exist
        HasItemLedgerEntry :=
          (PurchLine2."Quantity Received" <> 0) OR
          (PurchLine2."Return Qty. Shipped" <> 0);

      EXIT(HasItemLedgerEntry);
    END;

    LOCAL PROCEDURE LockTables@60();
    VAR
      PurchLine@1000 : Record 39;
      SalesLine@1001 : Record 37;
    BEGIN
      PurchLine.LOCKTABLE;
      SalesLine.LOCKTABLE;
      GetGLSetup;
      IF NOT GLSetup.OptimGLEntLockForMultiuserEnv THEN BEGIN
        GLEntry.LOCKTABLE;
        IF GLEntry.FINDLAST THEN;
      END;
    END;

    LOCAL PROCEDURE MAX@31(number1@1000 : Integer;number2@1001 : Integer) : Integer;
    BEGIN
      IF number1 > number2 THEN
        EXIT(number1);
      EXIT(number2);
    END;

    LOCAL PROCEDURE CreateJobPurchLine@22(VAR JobPurchLine2@1000 : Record 39;PurchLine2@1001 : Record 39;PricesIncludingVAT@1002 : Boolean);
    BEGIN
      JobPurchLine2 := PurchLine2;
      IF PricesIncludingVAT THEN
        IF JobPurchLine2."VAT Calculation Type" = JobPurchLine2."VAT Calculation Type"::"Full VAT" THEN
          JobPurchLine2."Direct Unit Cost" := 0
        ELSE
          JobPurchLine2."Direct Unit Cost" := JobPurchLine2."Direct Unit Cost" / (1 + JobPurchLine2."VAT %" / 100);
    END;

    LOCAL PROCEDURE RevertWarehouseEntry@62(VAR TempWhseJnlLine@1000 : TEMPORARY Record 7311;JobNo@1001 : Code[20];PostJobConsumptionBeforePurch@1002 : Boolean) : Boolean;
    BEGIN
      IF PostJobConsumptionBeforePurch OR (JobNo = '') OR PositiveWhseEntrycreated THEN
        EXIT(FALSE);
      WITH TempWhseJnlLine DO BEGIN
        "Entry Type" := "Entry Type"::"Negative Adjmt.";
        Quantity := -Quantity;
        "Qty. (Base)" := -"Qty. (Base)";
        "From Bin Code" := "To Bin Code";
        "To Bin Code" := '';
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreatePositiveEntry@93(WhseJnlLine@1000 : Record 7311;JobNo@1001 : Code[20];PostJobConsumptionBeforePurch@1002 : Boolean);
    BEGIN
      IF PostJobConsumptionBeforePurch OR (JobNo <> '') THEN BEGIN
        WITH WhseJnlLine DO BEGIN
          Quantity := -Quantity;
          "Qty. (Base)" := -"Qty. (Base)";
          "Qty. (Absolute)" := -"Qty. (Absolute)";
          "To Bin Code" := "From Bin Code";
          "From Bin Code" := '';
        END;
        WhseJnlPostLine.RUN(WhseJnlLine);
        PositiveWhseEntrycreated := TRUE;
      END;
    END;

    LOCAL PROCEDURE UpdateIncomingDocument@55(IncomingDocNo@1000 : Integer;PostingDate@1002 : Date;GenJnlLineDocNo@1003 : Code[20]);
    VAR
      IncomingDocument@1001 : Record 130;
    BEGIN
      IncomingDocument.UpdateIncomingDocumentFromPosting(IncomingDocNo,PostingDate,GenJnlLineDocNo);
    END;

    LOCAL PROCEDURE CheckItemCharge@61(ItemChargeAssignmentPurch@1000 : Record 5805);
    VAR
      PurchLineForCharge@1001 : Record 39;
    BEGIN
      WITH ItemChargeAssignmentPurch DO
        CASE "Applies-to Doc. Type" OF
          "Applies-to Doc. Type"::Order,
          "Applies-to Doc. Type"::Invoice:
            IF PurchLineForCharge.GET("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.") THEN
              IF (PurchLineForCharge."Quantity (Base)" = PurchLineForCharge."Qty. Received (Base)") AND
                 (PurchLineForCharge."Qty. Rcd. Not Invoiced (Base)" = 0)
              THEN
                ERROR(ReassignItemChargeErr);
          "Applies-to Doc. Type"::"Return Order",
          "Applies-to Doc. Type"::"Credit Memo":
            IF PurchLineForCharge.GET("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.") THEN
              IF (PurchLineForCharge."Quantity (Base)" = PurchLineForCharge."Return Qty. Shipped (Base)") AND
                 (PurchLineForCharge."Ret. Qty. Shpd Not Invd.(Base)" = 0)
              THEN
                ERROR(ReassignItemChargeErr);
        END;
    END;

    [External]
    PROCEDURE InitProgressWindow@105(PurchHeader@1000 : Record 38);
    BEGIN
      IF PurchHeader.Invoice THEN
        Window.OPEN(
          '#1#################################\\' +
          PostingLinesMsg +
          PostingPurchasesAndVATMsg +
          PostingVendorsMsg +
          PostingBalAccountMsg)
      ELSE
        Window.OPEN(
          '#1############################\\' +
          PostingLines2Msg);

      Window.UPDATE(1,STRSUBSTNO('%1 %2',PurchHeader."Document Type",PurchHeader."No."));
    END;

    [External]
    PROCEDURE SetPreviewMode@74(NewPreviewMode@1000 : Boolean);
    BEGIN
      PreviewMode := NewPreviewMode;
    END;

    LOCAL PROCEDURE UpdateQtyPerUnitOfMeasure@63(VAR PurchLine@1000 : Record 39);
    VAR
      ItemUnitOfMeasure@1001 : Record 5404;
    BEGIN
      IF PurchLine."Qty. per Unit of Measure" = 0 THEN
        IF (PurchLine.Type = PurchLine.Type::Item) AND
           (PurchLine."Unit of Measure" <> '') AND
           ItemUnitOfMeasure.GET(PurchLine."No.",PurchLine."Unit of Measure")
        THEN
          PurchLine."Qty. per Unit of Measure" := ItemUnitOfMeasure."Qty. per Unit of Measure"
        ELSE
          PurchLine."Qty. per Unit of Measure" := 1;
    END;

    LOCAL PROCEDURE UpdateQtyToBeInvoicedForReceipt@101(VAR QtyToBeInvoiced@1000 : Decimal;VAR QtyToBeInvoicedBase@1001 : Decimal;TrackingSpecificationExists@1002 : Boolean;PurchLine@1003 : Record 39;PurchRcptLine@1004 : Record 121;InvoicingTrackingSpecification@1006 : Record 336);
    BEGIN
      IF PurchLine."Qty. to Invoice" * PurchRcptLine.Quantity < 0 THEN
        PurchLine.FIELDERROR("Qty. to Invoice",ReceiptSameSignErr);
      IF TrackingSpecificationExists THEN BEGIN
        QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
        QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
      END ELSE BEGIN
        QtyToBeInvoiced := RemQtyToBeInvoiced - PurchLine."Qty. to Receive";
        QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - PurchLine."Qty. to Receive (Base)";
      END;
      IF ABS(QtyToBeInvoiced) > ABS(PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced") THEN BEGIN
        QtyToBeInvoiced := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
        QtyToBeInvoicedBase := PurchRcptLine."Quantity (Base)" - PurchRcptLine."Qty. Invoiced (Base)";
      END;
    END;

    LOCAL PROCEDURE UpdateQtyToBeInvoicedForReturnShipment@198(VAR QtyToBeInvoiced@1004 : Decimal;VAR QtyToBeInvoicedBase@1003 : Decimal;TrackingSpecificationExists@1002 : Boolean;PurchLine@1001 : Record 39;ReturnShipmentLine@1000 : Record 6651;InvoicingTrackingSpecification@1005 : Record 336);
    BEGIN
      IF PurchLine."Qty. to Invoice" * ReturnShipmentLine.Quantity > 0 THEN
        PurchLine.FIELDERROR("Qty. to Invoice",ReturnShipmentSamesSignErr);
      IF TrackingSpecificationExists THEN BEGIN
        QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
        QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
      END ELSE BEGIN
        QtyToBeInvoiced := RemQtyToBeInvoiced - PurchLine."Return Qty. to Ship";
        QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - PurchLine."Return Qty. to Ship (Base)";
      END;
      IF ABS(QtyToBeInvoiced) > ABS(ReturnShipmentLine.Quantity - ReturnShipmentLine."Quantity Invoiced") THEN BEGIN
        QtyToBeInvoiced := ReturnShipmentLine."Quantity Invoiced" - ReturnShipmentLine.Quantity;
        QtyToBeInvoicedBase := ReturnShipmentLine."Qty. Invoiced (Base)" - ReturnShipmentLine."Quantity (Base)";
      END;
    END;

    LOCAL PROCEDURE UpdateRemainingQtyToBeInvoiced@102(VAR RemQtyToInvoiceCurrLine@1000 : Decimal;VAR RemQtyToInvoiceCurrLineBase@1001 : Decimal;PurchRcptLine@1002 : Record 121);
    BEGIN
      RemQtyToInvoiceCurrLine := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";
      RemQtyToInvoiceCurrLineBase := PurchRcptLine."Quantity (Base)" - PurchRcptLine."Qty. Invoiced (Base)";
      IF RemQtyToInvoiceCurrLine > RemQtyToBeInvoiced THEN BEGIN
        RemQtyToInvoiceCurrLine := RemQtyToBeInvoiced;
        RemQtyToInvoiceCurrLineBase := RemQtyToBeInvoicedBase;
      END;
    END;

    LOCAL PROCEDURE GetCountryCode@75(SalesLine@1000 : Record 37;SalesHeader@1001 : Record 36) : Code[10];
    VAR
      SalesShipmentHeader@1003 : Record 110;
    BEGIN
      IF SalesLine."Shipment No." <> '' THEN BEGIN
        SalesShipmentHeader.GET(SalesLine."Shipment No.");
        EXIT(
          GetCountryRegionCode(
            SalesLine."Sell-to Customer No.",
            SalesShipmentHeader."Ship-to Code",
            SalesShipmentHeader."Sell-to Country/Region Code"));
      END;
      EXIT(
        GetCountryRegionCode(
          SalesLine."Sell-to Customer No.",
          SalesHeader."Ship-to Code",
          SalesHeader."Sell-to Country/Region Code"));
    END;

    LOCAL PROCEDURE GetCountryRegionCode@103(CustNo@1001 : Code[20];ShipToCode@1002 : Code[10];SellToCountryRegionCode@1003 : Code[10]) : Code[10];
    VAR
      ShipToAddress@1000 : Record 222;
    BEGIN
      IF ShipToCode <> '' THEN BEGIN
        ShipToAddress.GET(CustNo,ShipToCode);
        EXIT(ShipToAddress."Country/Region Code");
      END;
      EXIT(SellToCountryRegionCode);
    END;

    LOCAL PROCEDURE CheckItemReservDisruption@104(PurchLine@1002 : Record 39);
    VAR
      Item@1000 : Record 27;
      AvailableQty@1001 : Decimal;
    BEGIN
      WITH PurchLine DO BEGIN
        IF NOT IsCreditDocType OR (Type <> Type::Item) OR NOT ("Return Qty. to Ship (Base)" > 0) THEN
          EXIT;

        IF Nonstock OR "Special Order" OR "Drop Shipment" OR IsServiceItem OR
           TempSKU.GET("Location Code","No.","Variant Code") // Warn against item
        THEN
          EXIT;

        Item.GET("No.");
        Item.SETFILTER("Location Filter","Location Code");
        Item.SETFILTER("Variant Filter","Variant Code");
        Item.CALCFIELDS("Reserved Qty. on Inventory","Net Change");
        CALCFIELDS("Reserved Qty. (Base)");
        AvailableQty := Item."Net Change" - (Item."Reserved Qty. on Inventory" - ABS("Reserved Qty. (Base)"));

        IF (Item."Reserved Qty. on Inventory" > 0) AND
           (AvailableQty < "Return Qty. to Ship (Base)") AND
           (Item."Reserved Qty. on Inventory" > ABS("Reserved Qty. (Base)"))
        THEN BEGIN
          InsertTempSKU("Location Code","No.","Variant Code");
          IF NOT CONFIRM(
               ReservationDisruptedQst,FALSE,FIELDCAPTION("No."),Item."No.",FIELDCAPTION("Location Code"),
               "Location Code",FIELDCAPTION("Variant Code"),"Variant Code")
          THEN
            ERROR('');
        END;
      END;
    END;

    LOCAL PROCEDURE InsertTempSKU@106(LocationCode@1000 : Code[10];ItemNo@1001 : Code[20];VariantCode@1002 : Code[10]);
    BEGIN
      WITH TempSKU DO BEGIN
        INIT;
        "Location Code" := LocationCode;
        "Item No." := ItemNo;
        "Variant Code" := VariantCode;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE UpdatePurchLineDimSetIDFromAppliedEntry@67(VAR PurchLineToPost@1000 : Record 39;PurchLine@1001 : Record 39);
    VAR
      ItemLedgEntry@1002 : Record 32;
      DimensionMgt@1003 : Codeunit 408;
      DimSetID@1004 : ARRAY [10] OF Integer;
    BEGIN
      DimSetID[1] := PurchLine."Dimension Set ID";
      WITH PurchLineToPost DO BEGIN
        IF "Appl.-to Item Entry" <> 0 THEN BEGIN
          ItemLedgEntry.GET("Appl.-to Item Entry");
          DimSetID[2] := ItemLedgEntry."Dimension Set ID";
        END;
        "Dimension Set ID" :=
          DimensionMgt.GetCombinedDimensionSetID(DimSetID,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      END;
    END;

    LOCAL PROCEDURE CheckCertificateOfSupplyStatus@188(ReturnShptHeader@1000 : Record 6650;ReturnShptLine@1001 : Record 6651);
    VAR
      CertificateOfSupply@1002 : Record 780;
      VATPostingSetup@1003 : Record 325;
    BEGIN
      IF ReturnShptLine.Quantity <> 0 THEN
        IF VATPostingSetup.GET(ReturnShptHeader."VAT Bus. Posting Group",ReturnShptLine."VAT Prod. Posting Group") AND
           VATPostingSetup."Certificate of Supply Required"
        THEN BEGIN
          CertificateOfSupply.InitFromPurchase(ReturnShptHeader);
          CertificateOfSupply.SetRequired(ReturnShptHeader."No.")
        END;
    END;

    LOCAL PROCEDURE CheckSalesCertificateOfSupplyStatus@69(SalesShptHeader@1001 : Record 110;SalesShptLine@1000 : Record 111);
    VAR
      CertificateOfSupply@1002 : Record 780;
      VATPostingSetup@1003 : Record 325;
    BEGIN
      IF SalesShptLine.Quantity <> 0 THEN
        IF VATPostingSetup.GET(SalesShptHeader."VAT Bus. Posting Group",SalesShptLine."VAT Prod. Posting Group") AND
           VATPostingSetup."Certificate of Supply Required"
        THEN BEGIN
          CertificateOfSupply.InitFromSales(SalesShptHeader);
          CertificateOfSupply.SetRequired(SalesShptHeader."No.");
        END;
    END;

    LOCAL PROCEDURE InsertPostedHeaders@133(PurchHeader@1000 : Record 38);
    VAR
      PurchRcptLine@1001 : Record 121;
      GenJnlLine@1003 : Record 81;
    BEGIN
      WITH PurchHeader DO BEGIN
        // Insert receipt header
        IF Receive THEN
          IF ("Document Type" = "Document Type"::Order) OR
             (("Document Type" = "Document Type"::Invoice) AND PurchSetup."Receipt on Invoice")
          THEN BEGIN
            IF DropShipOrder THEN BEGIN
              PurchRcptHeader.LOCKTABLE;
              PurchRcptLine.LOCKTABLE;
              SalesShptHeader.LOCKTABLE;
              SalesShptLine.LOCKTABLE;
            END;
            InsertReceiptHeader(PurchHeader,PurchRcptHeader);
            ServItemMgt.CopyReservation(PurchHeader);
          END;

        // Insert return shipment header
        IF Ship THEN
          IF ("Document Type" = "Document Type"::"Return Order") OR
             (("Document Type" = "Document Type"::"Credit Memo") AND PurchSetup."Return Shipment on Credit Memo")
          THEN
            InsertReturnShipmentHeader(PurchHeader,ReturnShptHeader);

        // Insert invoice header or credit memo header
        IF Invoice THEN
          IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
            InsertInvoiceHeader(PurchHeader,PurchInvHeader);
            GenJnlLineDocType := GenJnlLine."Document Type"::Invoice;
            GenJnlLineDocNo := PurchInvHeader."No.";
            GenJnlLineExtDocNo := "Vendor Invoice No.";
          END ELSE BEGIN // Credit Memo
            InsertCrMemoHeader(PurchHeader,PurchCrMemoHeader);
            GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo";
            GenJnlLineDocNo := PurchCrMemoHeader."No.";
            GenJnlLineExtDocNo := "Vendor Cr. Memo No.";
          END;
      END;
    END;

    LOCAL PROCEDURE InsertReceiptHeader@71(VAR PurchHeader@1000 : Record 38;VAR PurchRcptHeader@1001 : Record 120);
    VAR
      PurchCommentLine@1002 : Record 43;
      RecordLinkManagement@1003 : Codeunit 447;
    BEGIN
      WITH PurchHeader DO BEGIN
        PurchRcptHeader.INIT;
        PurchRcptHeader.TRANSFERFIELDS(PurchHeader);
        PurchRcptHeader."No." := "Receiving No.";
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          PurchRcptHeader."Order No. Series" := "No. Series";
          PurchRcptHeader."Order No." := "No.";
        END;
        PurchRcptHeader."No. Printed" := 0;
        PurchRcptHeader."Source Code" := SrcCode;
        PurchRcptHeader."User ID" := USERID;
        OnBeforePurchRcptHeaderInsert(PurchRcptHeader,PurchHeader);
        PurchRcptHeader.INSERT(TRUE);
        OnAfterPurchRcptHeaderInsert(PurchRcptHeader,PurchHeader);

        ApprovalsMgmt.PostApprovalEntries(RECORDID,PurchRcptHeader.RECORDID,PurchRcptHeader."No.");

        IF PurchSetup."Copy Comments Order to Receipt" THEN BEGIN
          PurchCommentLine.CopyComments(
            "Document Type",PurchCommentLine."Document Type"::Receipt,"No.",PurchRcptHeader."No.");
          RecordLinkManagement.CopyLinks(PurchHeader,PurchRcptHeader);
        END;
        IF WhseReceive THEN BEGIN
          WhseRcptHeader.GET(TempWhseRcptHeader."No.");
          WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,"Receiving No.","Posting Date");
        END;
        IF WhseShip THEN BEGIN
          WhseShptHeader.GET(TempWhseShptHeader."No.");
          WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,"Receiving No.","Posting Date");
        END;
      END;
    END;

    LOCAL PROCEDURE InsertReceiptLine@143(PurchRcptHeader@1000 : Record 120;PurchLine@1001 : Record 39;CostBaseAmount@1006 : Decimal);
    VAR
      PurchRcptLine@1003 : Record 121;
      WhseRcptLine@1004 : Record 7317;
      WhseShptLine@1005 : Record 7321;
    BEGIN
      PurchRcptLine.InitFromPurchLine(PurchRcptHeader,xPurchLine);
      PurchRcptLine."Quantity Invoiced" := RemQtyToBeInvoiced;
      PurchRcptLine."Qty. Invoiced (Base)" := RemQtyToBeInvoicedBase;
      PurchRcptLine."Qty. Rcd. Not Invoiced" := PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";

      IF (PurchLine.Type = PurchLine.Type::Item) AND (PurchLine."Qty. to Receive" <> 0) THEN BEGIN
        IF WhseReceive THEN BEGIN
          WhseRcptLine.GetWhseRcptLine(
            WhseRcptHeader."No.",DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.");
          WhseRcptLine.TESTFIELD("Qty. to Receive",PurchRcptLine.Quantity);
          SaveTempWhseSplitSpec(PurchLine);
          WhsePostRcpt.CreatePostedRcptLine(
            WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
        END;
        IF WhseShip THEN BEGIN
          WhseShptLine.GetWhseShptLine(
            WhseShptHeader."No.",DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.");
          WhseShptLine.TESTFIELD("Qty. to Ship",-PurchRcptLine.Quantity);
          SaveTempWhseSplitSpec(PurchLine);
          WhsePostShpt.CreatePostedShptLine(
            WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
        END;
        PurchRcptLine."Item Rcpt. Entry No." := InsertRcptEntryRelation(PurchRcptLine);
        PurchRcptLine."Item Charge Base Amount" := ROUND(CostBaseAmount / PurchLine.Quantity * PurchRcptLine.Quantity);
      END;
      OnBeforePurchRcptLineInsert(PurchRcptLine,PurchRcptHeader,PurchLine);
      PurchRcptLine.INSERT(TRUE);
      OnAfterPurchRcptLineInsert(PurchLine,PurchRcptLine,ItemLedgShptEntryNo,WhseShip,WhseReceive);
    END;

    LOCAL PROCEDURE InsertReturnShipmentHeader@73(VAR PurchHeader@1000 : Record 38;VAR ReturnShptHeader@1001 : Record 6650);
    VAR
      PurchCommentLine@1002 : Record 43;
      RecordLinkManagement@1003 : Codeunit 447;
    BEGIN
      WITH PurchHeader DO BEGIN
        ReturnShptHeader.INIT;
        ReturnShptHeader.TRANSFERFIELDS(PurchHeader);
        ReturnShptHeader."No." := "Return Shipment No.";
        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
          ReturnShptHeader."Return Order No. Series" := "No. Series";
          ReturnShptHeader."Return Order No." := "No.";
        END;
        ReturnShptHeader."No. Series" := "Return Shipment No. Series";
        ReturnShptHeader."No. Printed" := 0;
        ReturnShptHeader."Source Code" := SrcCode;
        ReturnShptHeader."User ID" := USERID;
        OnBeforeReturnShptHeaderInsert(ReturnShptHeader,PurchHeader);
        ReturnShptHeader.INSERT(TRUE);
        OnAfterReturnShptHeaderInsert(ReturnShptHeader,PurchHeader);

        ApprovalsMgmt.PostApprovalEntries(RECORDID,ReturnShptHeader.RECORDID,ReturnShptHeader."No.");

        IF PurchSetup."Copy Cmts Ret.Ord. to Ret.Shpt" THEN BEGIN
          PurchCommentLine.CopyComments(
            "Document Type",PurchCommentLine."Document Type"::"Posted Return Shipment","No.",ReturnShptHeader."No.");
          RecordLinkManagement.CopyLinks(PurchHeader,ReturnShptHeader);
        END;
        IF WhseShip THEN BEGIN
          WhseShptHeader.GET(TempWhseShptHeader."No.");
          WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,"Return Shipment No.","Posting Date");
        END;
        IF WhseReceive THEN BEGIN
          WhseRcptHeader.GET(TempWhseRcptHeader."No.");
          WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,"Return Shipment No.","Posting Date");
        END;
      END;
    END;

    LOCAL PROCEDURE InsertReturnShipmentLine@145(ReturnShptHeader@1000 : Record 6650;PurchLine@1001 : Record 39;CostBaseAmount@1006 : Decimal);
    VAR
      ReturnShptLine@1005 : Record 6651;
      WhseRcptLine@1004 : Record 7317;
      WhseShptLine@1003 : Record 7321;
    BEGIN
      ReturnShptLine.InitFromPurchLine(ReturnShptHeader,xPurchLine);
      ReturnShptLine."Quantity Invoiced" := ABS(RemQtyToBeInvoiced);
      ReturnShptLine."Qty. Invoiced (Base)" := ABS(RemQtyToBeInvoicedBase);
      ReturnShptLine."Return Qty. Shipped Not Invd." := ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced";

      IF (PurchLine.Type = PurchLine.Type::Item) AND (PurchLine."Return Qty. to Ship" <> 0) THEN BEGIN
        IF WhseShip THEN BEGIN
          WhseShptLine.GetWhseShptLine(
            WhseShptHeader."No.",DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.");
          WhseShptLine.TESTFIELD("Qty. to Ship",ReturnShptLine.Quantity);
          SaveTempWhseSplitSpec(PurchLine);
          WhsePostShpt.CreatePostedShptLine(
            WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
        END;
        IF WhseReceive THEN BEGIN
          WhseRcptLine.GetWhseRcptLine(
            WhseRcptHeader."No.",DATABASE::"Purchase Line",PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.");
          WhseRcptLine.TESTFIELD("Qty. to Receive",-ReturnShptLine.Quantity);
          SaveTempWhseSplitSpec(PurchLine);
          WhsePostRcpt.CreatePostedRcptLine(
            WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
        END;

        ReturnShptLine."Item Shpt. Entry No." := InsertReturnEntryRelation(ReturnShptLine);
        ReturnShptLine."Item Charge Base Amount" := ROUND(CostBaseAmount / PurchLine.Quantity * ReturnShptLine.Quantity);
      END;
      OnBeforeReturnShptLineInsert(ReturnShptLine,ReturnShptHeader,PurchLine);
      ReturnShptLine.INSERT(TRUE);
      OnAfterReturnShptLineInsert(ReturnShptLine,ReturnShptHeader,PurchLine,ItemLedgShptEntryNo,WhseShip,WhseReceive);

      CheckCertificateOfSupplyStatus(ReturnShptHeader,ReturnShptLine);
    END;

    LOCAL PROCEDURE InsertInvoiceHeader@87(VAR PurchHeader@1000 : Record 38;VAR PurchInvHeader@1001 : Record 122);
    VAR
      PurchCommentLine@1002 : Record 43;
      RecordLinkManagement@1003 : Codeunit 447;
    BEGIN
      WITH PurchHeader DO BEGIN
        PurchInvHeader.INIT;
        PurchInvHeader.TRANSFERFIELDS(PurchHeader);
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          PurchInvHeader."Pre-Assigned No. Series" := '';
          IF PreviewMode THEN
            PurchInvHeader."No." := '***'
          ELSE
            PurchInvHeader."No." := "Posting No.";
          PurchInvHeader."Order No. Series" := "No. Series";
          PurchInvHeader."Order No." := "No.";
          IF GUIALLOWED THEN
            Window.UPDATE(1,STRSUBSTNO(InvoiceNoMsg,"Document Type","No.",PurchInvHeader."No."));
        END ELSE BEGIN
          IF "Posting No." <> '' THEN BEGIN
            PurchInvHeader."No." := "Posting No.";
            IF GUIALLOWED THEN
              Window.UPDATE(1,STRSUBSTNO(InvoiceNoMsg,"Document Type","No.",PurchInvHeader."No."));
          END;
          PurchInvHeader."Pre-Assigned No. Series" := "No. Series";
          PurchInvHeader."Pre-Assigned No." := "No.";
        END;
        PurchInvHeader."Creditor No." := "Creditor No.";
        PurchInvHeader."Payment Reference" := "Payment Reference";
        PurchInvHeader."Payment Method Code" := "Payment Method Code";
        PurchInvHeader."Source Code" := SrcCode;
        PurchInvHeader."User ID" := USERID;
        PurchInvHeader."No. Printed" := 0;
        OnBeforePurchInvHeaderInsert(PurchInvHeader,PurchHeader);
        PurchInvHeader.INSERT(TRUE);
        OnAfterPurchInvHeaderInsert(PurchInvHeader,PurchHeader);

        ApprovalsMgmt.PostApprovalEntries(RECORDID,PurchInvHeader.RECORDID,PurchInvHeader."No.");
        IF PurchSetup."Copy Comments Order to Invoice" THEN BEGIN
          PurchCommentLine.CopyComments(
            "Document Type",PurchCommentLine."Document Type"::"Posted Invoice","No.",PurchInvHeader."No.");
          RecordLinkManagement.CopyLinks(PurchHeader,PurchInvHeader);
        END;
      END;
    END;

    LOCAL PROCEDURE InsertCrMemoHeader@88(VAR PurchHeader@1000 : Record 38;VAR PurchCrMemoHdr@1001 : Record 124);
    VAR
      PurchCommentLine@1002 : Record 43;
      RecordLinkManagement@1003 : Codeunit 447;
    BEGIN
      WITH PurchHeader DO BEGIN
        PurchCrMemoHdr.INIT;
        PurchCrMemoHdr.TRANSFERFIELDS(PurchHeader);
        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
          PurchCrMemoHdr."No." := "Posting No.";
          PurchCrMemoHdr."Pre-Assigned No. Series" := '';
          PurchCrMemoHdr."Return Order No. Series" := "No. Series";
          PurchCrMemoHdr."Return Order No." := "No.";
          IF GUIALLOWED THEN
            Window.UPDATE(1,STRSUBSTNO(CreditMemoNoMsg,"Document Type","No.",PurchCrMemoHdr."No."));
        END ELSE BEGIN
          PurchCrMemoHdr."Pre-Assigned No. Series" := "No. Series";
          PurchCrMemoHdr."Pre-Assigned No." := "No.";
          IF "Posting No." <> '' THEN BEGIN
            PurchCrMemoHdr."No." := "Posting No.";
            IF GUIALLOWED THEN
              Window.UPDATE(1,STRSUBSTNO(CreditMemoNoMsg,"Document Type","No.",PurchCrMemoHdr."No."));
          END;
        END;
        PurchCrMemoHdr."Source Code" := SrcCode;
        PurchCrMemoHdr."User ID" := USERID;
        PurchCrMemoHdr."No. Printed" := 0;
        OnBeforePurchCrMemoHeaderInsert(PurchCrMemoHdr,PurchHeader);
        PurchCrMemoHdr.INSERT(TRUE);
        OnAfterPurchCrMemoHeaderInsert(PurchCrMemoHdr,PurchHeader);

        ApprovalsMgmt.PostApprovalEntries(RECORDID,PurchCrMemoHdr.RECORDID,PurchCrMemoHdr."No.");

        IF PurchSetup."Copy Cmts Ret.Ord. to Cr. Memo" THEN BEGIN
          PurchCommentLine.CopyComments(
            "Document Type",PurchCommentLine."Document Type"::"Posted Credit Memo","No.",PurchCrMemoHdr."No.");
          RecordLinkManagement.CopyLinks(PurchHeader,PurchCrMemoHdr);
        END;
      END;
    END;

    LOCAL PROCEDURE GetSign@90(Value@1000 : Decimal) : Integer;
    BEGIN
      IF Value > 0 THEN
        EXIT(1);

      EXIT(-1);
    END;

    LOCAL PROCEDURE CheckICDocumentDuplicatePosting@65(PurchHeader@1000 : Record 38);
    VAR
      PurchHeader2@1001 : Record 38;
      ICInboxPurchHeader@1002 : Record 436;
      PurchInvHeader@1003 : Record 122;
    BEGIN
      WITH PurchHeader DO BEGIN
        IF NOT Invoice THEN
          EXIT;
        IF "IC Direction" = "IC Direction"::Outgoing THEN BEGIN
          PurchInvHeader.SETRANGE("Your Reference","No.");
          PurchInvHeader.SETRANGE("Buy-from Vendor No.","Buy-from Vendor No.");
          PurchInvHeader.SETRANGE("Pay-to Vendor No.","Pay-to Vendor No.");
          IF PurchInvHeader.FINDFIRST THEN
            IF NOT CONFIRM(PostedInvoiceDuplicateQst,FALSE,PurchInvHeader."No.","No.") THEN
              ERROR('');
        END;
        IF "IC Direction" = "IC Direction"::Incoming THEN BEGIN
          IF "Document Type" = "Document Type"::Order THEN BEGIN
            PurchHeader2.SETRANGE("Document Type","Document Type"::Invoice);
            PurchHeader2.SETRANGE("Vendor Order No.","Vendor Order No.");
            IF PurchHeader2.FINDFIRST THEN
              IF NOT CONFIRM(UnpostedInvoiceDuplicateQst,TRUE,"No.",PurchHeader2."No.") THEN
                ERROR('');
            ICInboxPurchHeader.SETRANGE("Document Type","Document Type"::Invoice);
            ICInboxPurchHeader.SETRANGE("Vendor Order No.","Vendor Order No.");
            IF ICInboxPurchHeader.FINDFIRST THEN
              IF NOT CONFIRM(InvoiceDuplicateInboxQst,TRUE,"No.",ICInboxPurchHeader."No.") THEN
                ERROR('');
            PurchInvHeader.SETRANGE("Vendor Order No.","Vendor Order No.");
            IF PurchInvHeader.FINDFIRST THEN
              IF NOT CONFIRM(PostedInvoiceDuplicateQst,FALSE,PurchInvHeader."No.","No.") THEN
                ERROR('');
          END;
          IF ("Document Type" = "Document Type"::Invoice) AND ("Vendor Order No." <> '') THEN BEGIN
            PurchHeader2.SETRANGE("Document Type","Document Type"::Order);
            PurchHeader2.SETRANGE("Vendor Order No.","Vendor Order No.");
            IF PurchHeader2.FINDFIRST THEN
              IF NOT CONFIRM(OrderFromSameTransactionQst,TRUE,PurchHeader2."No.","No.") THEN
                ERROR('');
            ICInboxPurchHeader.SETRANGE("Document Type","Document Type"::Order);
            ICInboxPurchHeader.SETRANGE("Vendor Order No.","Vendor Order No.");
            IF ICInboxPurchHeader.FINDFIRST THEN
              IF NOT CONFIRM(DocumentFromSameTransactionQst,TRUE,"No.",ICInboxPurchHeader."No.") THEN
                ERROR('');
            PurchInvHeader.SETRANGE("Vendor Order No.","Vendor Order No.");
            IF PurchInvHeader.FINDFIRST THEN
              IF NOT CONFIRM(PostedInvoiceFromSameTransactionQst,FALSE,PurchInvHeader."No.","No.") THEN
                ERROR('');
            IF "Your Reference" <> '' THEN BEGIN
              PurchInvHeader.RESET;
              PurchInvHeader.SETRANGE("Order No.","Your Reference");
              PurchInvHeader.SETRANGE("Buy-from Vendor No.","Buy-from Vendor No.");
              PurchInvHeader.SETRANGE("Pay-to Vendor No.","Pay-to Vendor No.");
              IF PurchInvHeader.FINDFIRST THEN
                IF NOT CONFIRM(PostedInvoiceFromSameTransactionQst,FALSE,PurchInvHeader."No.","No.") THEN
                  ERROR('');
            END;
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE CheckICPartnerBlocked@70(PurchHeader@1000 : Record 38);
    VAR
      ICPartner@1001 : Record 413;
    BEGIN
      WITH PurchHeader DO BEGIN
        IF "Buy-from IC Partner Code" <> '' THEN
          IF ICPartner.GET("Buy-from IC Partner Code") THEN
            ICPartner.TESTFIELD(Blocked,FALSE);
        IF "Pay-to IC Partner Code" <> '' THEN
          IF ICPartner.GET("Pay-to IC Partner Code") THEN
            ICPartner.TESTFIELD(Blocked,FALSE);
      END;
    END;

    LOCAL PROCEDURE SendICDocument@77(VAR PurchHeader@1000 : Record 38;VAR ModifyHeader@1002 : Boolean);
    VAR
      ICInboxOutboxMgt@1001 : Codeunit 427;
    BEGIN
      WITH PurchHeader DO
        IF "Send IC Document" AND ("IC Status" = "IC Status"::New) AND ("IC Direction" = "IC Direction"::Outgoing) AND
           ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
        THEN BEGIN
          ICInboxOutboxMgt.SendPurchDoc(PurchHeader,TRUE);
          "IC Status" := "IC Status"::Pending;
          ModifyHeader := TRUE;
        END;
    END;

    LOCAL PROCEDURE UpdateHandledICInboxTransaction@100(PurchHeader@1000 : Record 38);
    VAR
      HandledICInboxTrans@1001 : Record 420;
      Vendor@1002 : Record 23;
    BEGIN
      WITH PurchHeader DO
        IF "IC Direction" = "IC Direction"::Incoming THEN BEGIN
          CASE "Document Type" OF
            "Document Type"::Invoice:
              HandledICInboxTrans.SETRANGE("Document No.","Vendor Invoice No.");
            "Document Type"::Order:
              HandledICInboxTrans.SETRANGE("Document No.","Vendor Order No.");
            "Document Type"::"Credit Memo":
              HandledICInboxTrans.SETRANGE("Document No.","Vendor Cr. Memo No.");
            "Document Type"::"Return Order":
              HandledICInboxTrans.SETRANGE("Document No.","Vendor Order No.");
          END;
          Vendor.GET("Buy-from Vendor No.");
          HandledICInboxTrans.SETRANGE("IC Partner Code",Vendor."IC Partner Code");
          HandledICInboxTrans.LOCKTABLE;
          IF HandledICInboxTrans.FINDFIRST THEN BEGIN
            HandledICInboxTrans.Status := HandledICInboxTrans.Status::Posted;
            HandledICInboxTrans.MODIFY;
          END;
        END;
    END;

    LOCAL PROCEDURE MakeInventoryAdjustment@72();
    VAR
      InvtSetup@1001 : Record 313;
      InvtAdjmt@1002 : Codeunit 5895;
    BEGIN
      InvtSetup.GET;
      IF InvtSetup."Automatic Cost Adjustment" <>
         InvtSetup."Automatic Cost Adjustment"::Never
      THEN BEGIN
        InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
        InvtAdjmt.SetJobUpdateProperties(FALSE);
        InvtAdjmt.MakeMultiLevelAdjmt;
      END;
    END;

    LOCAL PROCEDURE CheckTrackingAndWarehouseForReceive@19(PurchHeader@1000 : Record 38) Receive : Boolean;
    VAR
      TempPurchLine@1002 : TEMPORARY Record 39;
    BEGIN
      WITH TempPurchLine DO BEGIN
        ResetTempLines(TempPurchLine);
        SETFILTER(Quantity,'<>0');
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::Order THEN
          SETFILTER("Qty. to Receive",'<>0');
        SETRANGE("Receipt No.",'');
        Receive := FINDFIRST;
        WhseReceive := TempWhseRcptHeader.FINDFIRST;
        WhseShip := TempWhseShptHeader.FINDFIRST;
        IF Receive THEN BEGIN
          CheckTrackingSpecification(PurchHeader,TempPurchLine);
          IF NOT (WhseReceive OR WhseShip OR InvtPickPutaway) THEN
            CheckWarehouse(TempPurchLine);
        END;
        EXIT(Receive);
      END;
    END;

    LOCAL PROCEDURE CheckTrackingAndWarehouseForShip@132(PurchHeader@1000 : Record 38) Ship : Boolean;
    VAR
      TempPurchLine@1002 : TEMPORARY Record 39;
    BEGIN
      WITH TempPurchLine DO BEGIN
        ResetTempLines(TempPurchLine);
        SETFILTER(Quantity,'<>0');
        SETFILTER("Return Qty. to Ship",'<>0');
        SETRANGE("Return Shipment No.",'');
        Ship := FINDFIRST;
        WhseReceive := TempWhseRcptHeader.FINDFIRST;
        WhseShip := TempWhseShptHeader.FINDFIRST;
        IF Ship THEN BEGIN
          CheckTrackingSpecification(PurchHeader,TempPurchLine);
          IF NOT (WhseShip OR WhseReceive OR InvtPickPutaway) THEN
            CheckWarehouse(TempPurchLine);
        END;
        EXIT(Ship);
      END;
    END;

    LOCAL PROCEDURE CheckAssosOrderLines@120(PurchHeader@1000 : Record 38);
    VAR
      PurchLine@1001 : Record 39;
      SalesOrderLine@1002 : Record 37;
    BEGIN
      WITH PurchHeader DO BEGIN
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETFILTER("Sales Order Line No.",'<>0');
        IF PurchLine.FINDSET THEN
          REPEAT
            SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,
              PurchLine."Sales Order No.",PurchLine."Sales Order Line No.");
            IF Receive AND Invoice AND (PurchLine."Qty. to Invoice" <> 0) AND (PurchLine."Qty. to Receive" <> 0) THEN
              ERROR(DropShipmentErr);
            IF ABS(PurchLine."Quantity Received" - PurchLine."Quantity Invoiced") < ABS(PurchLine."Qty. to Invoice")
            THEN BEGIN
              PurchLine."Qty. to Invoice" := PurchLine."Quantity Received" - PurchLine."Quantity Invoiced";
              PurchLine."Qty. to Invoice (Base)" := PurchLine."Qty. Received (Base)" - PurchLine."Qty. Invoiced (Base)";
            END;
            IF ABS(PurchLine.Quantity - (PurchLine."Qty. to Invoice" + PurchLine."Quantity Invoiced")) <
               ABS(SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced")
            THEN
              ERROR(CannotInvoiceBeforeAssosSalesOrderErr,PurchLine."Sales Order No.");
          UNTIL PurchLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE PostCombineSalesOrderShipment@76(VAR PurchHeader@1001 : Record 38;VAR TempDropShptPostBuffer@1004 : TEMPORARY Record 223);
    VAR
      SalesSetup@1000 : Record 311;
      SalesCommentLine@1002 : Record 44;
      SalesOrderHeader@1006 : Record 36;
      SalesOrderLine@1005 : Record 37;
      RecordLinkManagement@1003 : Codeunit 447;
    BEGIN
      ArchiveSalesOrders(TempDropShptPostBuffer);
      WITH PurchHeader DO
        IF TempDropShptPostBuffer.FINDSET THEN BEGIN
          SalesSetup.GET;
          REPEAT
            SalesOrderHeader.GET(
              SalesOrderHeader."Document Type"::Order,
              TempDropShptPostBuffer."Order No.");
            SalesShptHeader.INIT;
            SalesShptHeader.TRANSFERFIELDS(SalesOrderHeader);
            SalesShptHeader."No." := SalesOrderHeader."Shipping No.";
            SalesShptHeader."Order No." := SalesOrderHeader."No.";
            SalesShptHeader."Posting Date" := "Posting Date";
            SalesShptHeader."Document Date" := "Document Date";
            SalesShptHeader."No. Printed" := 0;
            SalesShptHeader.INSERT(TRUE);

            ApprovalsMgmt.PostApprovalEntries(RECORDID,SalesShptHeader.RECORDID,SalesShptHeader."No.");

            IF SalesSetup."Copy Comments Order to Shpt." THEN BEGIN
              SalesCommentLine.CopyComments(
                SalesOrderHeader."Document Type",SalesCommentLine."Document Type"::Shipment,
                SalesOrderHeader."No.",SalesShptHeader."No.");
              RecordLinkManagement.CopyLinks(SalesOrderHeader,SalesShptHeader);
            END;
            TempDropShptPostBuffer.SETRANGE("Order No.",TempDropShptPostBuffer."Order No.");
            REPEAT
              SalesOrderLine.GET(
                SalesOrderLine."Document Type"::Order,
                TempDropShptPostBuffer."Order No.",TempDropShptPostBuffer."Order Line No.");
              SalesShptLine.INIT;
              SalesShptLine.TRANSFERFIELDS(SalesOrderLine);
              SalesShptLine."Posting Date" := SalesShptHeader."Posting Date";
              SalesShptLine."Document No." := SalesShptHeader."No.";
              SalesShptLine.Quantity := TempDropShptPostBuffer.Quantity;
              SalesShptLine."Quantity (Base)" := TempDropShptPostBuffer."Quantity (Base)";
              SalesShptLine."Quantity Invoiced" := 0;
              SalesShptLine."Qty. Invoiced (Base)" := 0;
              SalesShptLine."Order No." := SalesOrderLine."Document No.";
              SalesShptLine."Order Line No." := SalesOrderLine."Line No.";
              SalesShptLine."Qty. Shipped Not Invoiced" :=
                SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced";
              IF SalesShptLine.Quantity <> 0 THEN BEGIN
                SalesShptLine."Item Shpt. Entry No." := TempDropShptPostBuffer."Item Shpt. Entry No.";
                SalesShptLine."Item Charge Base Amount" := SalesOrderLine."Line Amount";
              END;
              SalesShptLine.INSERT;
              CheckSalesCertificateOfSupplyStatus(SalesShptHeader,SalesShptLine);

              SalesOrderLine."Qty. to Ship" := SalesShptLine.Quantity;
              SalesOrderLine."Qty. to Ship (Base)" := SalesShptLine."Quantity (Base)";
              ServItemMgt.CreateServItemOnSalesLineShpt(SalesOrderHeader,SalesOrderLine,SalesShptLine);
              SalesPost.UpdateBlanketOrderLine(SalesOrderLine,TRUE,FALSE,FALSE);

              SalesOrderLine.SETRANGE("Document Type",SalesOrderLine."Document Type"::Order);
              SalesOrderLine.SETRANGE("Document No.",TempDropShptPostBuffer."Order No.");
              SalesOrderLine.SETRANGE("Attached to Line No.",TempDropShptPostBuffer."Order Line No.");
              SalesOrderLine.SETRANGE(Type,SalesOrderLine.Type::" ");
              IF SalesOrderLine.FINDSET THEN
                REPEAT
                  SalesShptLine.INIT;
                  SalesShptLine.TRANSFERFIELDS(SalesOrderLine);
                  SalesShptLine."Document No." := SalesShptHeader."No.";
                  SalesShptLine."Order No." := SalesOrderLine."Document No.";
                  SalesShptLine."Order Line No." := SalesOrderLine."Line No.";
                  SalesShptLine.INSERT;
                UNTIL SalesOrderLine.NEXT = 0;

            UNTIL TempDropShptPostBuffer.NEXT = 0;
            TempDropShptPostBuffer.SETRANGE("Order No.");
          UNTIL TempDropShptPostBuffer.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE PostInvoicePostBufferLine@92(VAR PurchHeader@1000 : Record 38;InvoicePostBuffer@1001 : Record 49) GLEntryNo : Integer;
    VAR
      GenJnlLine@1002 : Record 81;
    BEGIN
      WITH GenJnlLine DO BEGIN
        InitNewLine(
          PurchHeader."Posting Date",PurchHeader."Document Date",PurchHeader."Posting Description",
          InvoicePostBuffer."Global Dimension 1 Code",InvoicePostBuffer."Global Dimension 2 Code",
          InvoicePostBuffer."Dimension Set ID",PurchHeader."Reason Code");

        CopyDocumentFields(GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,'');
        CopyFromPurchHeader(PurchHeader);
        CopyFromInvoicePostBuffer(InvoicePostBuffer);

        IF InvoicePostBuffer.Type <> InvoicePostBuffer.Type::"Prepmt. Exch. Rate Difference" THEN
          "Gen. Posting Type" := "Gen. Posting Type"::Purchase;
        IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
          IF InvoicePostBuffer."FA Posting Type" = InvoicePostBuffer."FA Posting Type"::"Acquisition Cost" THEN
            "FA Posting Type" := "FA Posting Type"::"Acquisition Cost";
          IF InvoicePostBuffer."FA Posting Type" = InvoicePostBuffer."FA Posting Type"::Maintenance THEN
            "FA Posting Type" := "FA Posting Type"::Maintenance;
          CopyFromInvoicePostBufferFA(InvoicePostBuffer);
        END;

        OnBeforePostInvPostBuffer(GenJnlLine,InvoicePostBuffer,PurchHeader);
        GLEntryNo := RunGenJnlPostLine(GenJnlLine);
        OnAfterPostInvPostBuffer(GenJnlLine,InvoicePostBuffer,PurchHeader,GLEntryNo);
      END;
    END;

    LOCAL PROCEDURE FindTempItemChargeAssgntPurch@96(PurchLineNo@1000 : Integer) : Boolean;
    BEGIN
      ClearItemChargeAssgntFilter;
      TempItemChargeAssgntPurch.SETCURRENTKEY("Applies-to Doc. Type");
      TempItemChargeAssgntPurch.SETRANGE("Document Line No.",PurchLineNo);
      EXIT(TempItemChargeAssgntPurch.FINDSET);
    END;

    LOCAL PROCEDURE UpdateInvoicedQtyOnPurchRcptLine@107(VAR PurchRcptLine@1000 : Record 121;QtyToBeInvoiced@1001 : Decimal;QtyToBeInvoicedBase@1002 : Decimal);
    BEGIN
      WITH PurchRcptLine DO BEGIN
        "Quantity Invoiced" := "Quantity Invoiced" + QtyToBeInvoiced;
        "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" + QtyToBeInvoicedBase;
        "Qty. Rcd. Not Invoiced" := Quantity - "Quantity Invoiced";
        MODIFY;
      END;
    END;

    LOCAL PROCEDURE FillDeferralPostingBuffer@123(PurchHeader@1008 : Record 38;PurchLine@1000 : Record 39;InvoicePostBuffer@1009 : Record 49;RemainAmtToDefer@1001 : Decimal;RemainAmtToDeferACY@1002 : Decimal;DeferralAccount@1003 : Code[20];PurchAccount@1004 : Code[20]);
    VAR
      DeferralTemplate@1007 : Record 1700;
    BEGIN
      IF PurchLine."Deferral Code" <> '' THEN BEGIN
        DeferralTemplate.GET(PurchLine."Deferral Code");

        IF TempDeferralHeader.GET(DeferralUtilities.GetPurchDeferralDocType,'','',
             PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.")
        THEN BEGIN
          IF TempDeferralHeader."Amount to Defer" <> 0 THEN BEGIN
            TempDeferralLine.SETRANGE("Deferral Doc. Type",DeferralUtilities.GetPurchDeferralDocType);
            TempDeferralLine.SETRANGE("Gen. Jnl. Template Name",'');
            TempDeferralLine.SETRANGE("Gen. Jnl. Batch Name",'');
            TempDeferralLine.SETRANGE("Document Type",PurchLine."Document Type");
            TempDeferralLine.SETRANGE("Document No.",PurchLine."Document No.");
            TempDeferralLine.SETRANGE("Line No.",PurchLine."Line No.");

            // The remaining amounts only need to be adjusted into the deferral account and are always reversed
            IF (RemainAmtToDefer <> 0) OR (RemainAmtToDeferACY <> 0) THEN BEGIN
              DeferralPostBuffer[1].PreparePurch(PurchLine,GenJnlLineDocNo);
              DeferralPostBuffer[1]."Amount (LCY)" := -RemainAmtToDefer;
              DeferralPostBuffer[1].Amount := -RemainAmtToDeferACY;
              DeferralPostBuffer[1]."Sales/Purch Amount (LCY)" := 0;
              DeferralPostBuffer[1]."Sales/Purch Amount" := 0;
              // DeferralPostBuffer[1].ReverseAmounts;
              DeferralPostBuffer[1]."G/L Account" := PurchAccount;
              DeferralPostBuffer[1]."Deferral Account" := DeferralAccount;
              // Remainder always goes to the Posting Date
              DeferralPostBuffer[1]."Posting Date" := PurchHeader."Posting Date";
              DeferralPostBuffer[1].Description := PurchHeader."Posting Description";
              DeferralPostBuffer[1]."Period Description" := DeferralTemplate."Period Description";
              DeferralPostBuffer[1]."Deferral Line No." := InvDefLineNo;
              DeferralPostBuffer[1]."Partial Deferral" := TRUE;
              UpdDeferralPostBuffer(InvoicePostBuffer);
            END;

            // Add the deferral lines for each period to the deferral posting buffer merging when they are the same
            IF TempDeferralLine.FINDSET THEN
              REPEAT
                IF (TempDeferralLine."Amount (LCY)" <> 0) OR (TempDeferralLine.Amount <> 0) THEN BEGIN
                  DeferralPostBuffer[1].PreparePurch(PurchLine,GenJnlLineDocNo);
                  DeferralPostBuffer[1]."Amount (LCY)" := TempDeferralLine."Amount (LCY)";
                  DeferralPostBuffer[1].Amount := TempDeferralLine.Amount;
                  DeferralPostBuffer[1]."Sales/Purch Amount (LCY)" := TempDeferralLine."Amount (LCY)";
                  DeferralPostBuffer[1]."Sales/Purch Amount" := TempDeferralLine.Amount;
                  IF PurchLine.IsCreditDocType THEN
                    DeferralPostBuffer[1].ReverseAmounts;
                  DeferralPostBuffer[1]."G/L Account" := PurchAccount;
                  DeferralPostBuffer[1]."Deferral Account" := DeferralAccount;
                  DeferralPostBuffer[1]."Posting Date" := TempDeferralLine."Posting Date";
                  DeferralPostBuffer[1].Description := TempDeferralLine.Description;
                  DeferralPostBuffer[1]."Period Description" := DeferralTemplate."Period Description";
                  DeferralPostBuffer[1]."Deferral Line No." := InvDefLineNo;
                  UpdDeferralPostBuffer(InvoicePostBuffer);
                END ELSE
                  ERROR(ZeroDeferralAmtErr,PurchLine."No.",PurchLine."Deferral Code");

              UNTIL TempDeferralLine.NEXT = 0

            ELSE
              ERROR(NoDeferralScheduleErr,PurchLine."No.",PurchLine."Deferral Code");
          END ELSE
            ERROR(NoDeferralScheduleErr,PurchLine."No.",PurchLine."Deferral Code")
        END ELSE
          ERROR(NoDeferralScheduleErr,PurchLine."No.",PurchLine."Deferral Code")
      END;
    END;

    LOCAL PROCEDURE UpdDeferralPostBuffer@124(InvoicePostBuffer@1000 : Record 49);
    BEGIN
      DeferralPostBuffer[1]."Dimension Set ID" := InvoicePostBuffer."Dimension Set ID";
      DeferralPostBuffer[1]."Global Dimension 1 Code" := InvoicePostBuffer."Global Dimension 1 Code";
      DeferralPostBuffer[1]."Global Dimension 2 Code" := InvoicePostBuffer."Global Dimension 2 Code";

      DeferralPostBuffer[2] := DeferralPostBuffer[1];
      IF DeferralPostBuffer[2].FIND THEN BEGIN
        DeferralPostBuffer[2].Amount += DeferralPostBuffer[1].Amount;
        DeferralPostBuffer[2]."Amount (LCY)" += DeferralPostBuffer[1]."Amount (LCY)";
        DeferralPostBuffer[2]."Sales/Purch Amount" += DeferralPostBuffer[1]."Sales/Purch Amount";
        DeferralPostBuffer[2]."Sales/Purch Amount (LCY)" += DeferralPostBuffer[1]."Sales/Purch Amount (LCY)";

        IF NOT DeferralPostBuffer[1]."System-Created Entry" THEN
          DeferralPostBuffer[2]."System-Created Entry" := FALSE;
        IF IsCombinedDeferralZero THEN
          DeferralPostBuffer[2].DELETE
        ELSE
          DeferralPostBuffer[2].MODIFY;
      END ELSE
        DeferralPostBuffer[1].INSERT;
    END;

    LOCAL PROCEDURE RoundDeferralsForArchive@126(PurchHeader@1000 : Record 38;VAR PurchLine@1001 : Record 39);
    VAR
      ArchiveManagement@1005 : Codeunit 5063;
    BEGIN
      ArchiveManagement.RoundPurchaseDeferralsForArchive(PurchHeader,PurchLine);
    END;

    LOCAL PROCEDURE GetAmountsForDeferral@127(PurchLine@1001 : Record 39;VAR AmtToDefer@1002 : Decimal;VAR AmtToDeferACY@1003 : Decimal;VAR DeferralAccount@1004 : Code[20]);
    VAR
      DeferralTemplate@1005 : Record 1700;
    BEGIN
      IF PurchLine."Deferral Code" <> '' THEN BEGIN
        DeferralTemplate.GET(PurchLine."Deferral Code");
        DeferralTemplate.TESTFIELD("Deferral Account");
        DeferralAccount := DeferralTemplate."Deferral Account";

        IF TempDeferralHeader.GET(DeferralUtilities.GetPurchDeferralDocType,'','',
             PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.")
        THEN BEGIN
          AmtToDeferACY := TempDeferralHeader."Amount to Defer";
          AmtToDefer := TempDeferralHeader."Amount to Defer (LCY)";
        END;

        IF PurchLine.IsCreditDocType THEN BEGIN
          AmtToDefer := -AmtToDefer;
          AmtToDeferACY := -AmtToDeferACY;
        END
      END ELSE BEGIN
        AmtToDefer := 0;
        AmtToDeferACY := 0;
        DeferralAccount := '';
      END;
    END;

    LOCAL PROCEDURE DefaultGLAccount@129(DeferralCode@1000 : Code[10];AmtToDefer@1001 : Decimal;GLAccNo@1002 : Code[20];DeferralAccNo@1003 : Code[20]) : Code[20];
    BEGIN
      IF (DeferralCode <> '') AND (AmtToDefer = 0) THEN
        EXIT(DeferralAccNo);

      EXIT(GLAccNo);
    END;

    LOCAL PROCEDURE IsCombinedDeferralZero@130() : Boolean;
    BEGIN
      IF (DeferralPostBuffer[2].Amount = 0) AND (DeferralPostBuffer[2]."Amount (LCY)" = 0) AND
         (DeferralPostBuffer[2]."Sales/Purch Amount" = 0) AND (DeferralPostBuffer[2]."Sales/Purch Amount (LCY)" = 0)
      THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CheckMandatoryHeaderFields@128(PurchHeader@1000 : Record 38);
    BEGIN
      PurchHeader.TESTFIELD("Document Type");
      PurchHeader.TESTFIELD("Buy-from Vendor No.");
      PurchHeader.TESTFIELD("Pay-to Vendor No.");
      PurchHeader.TESTFIELD("Posting Date");
      PurchHeader.TESTFIELD("Document Date");

      OnAfterCheckMandatoryFields(PurchHeader);
    END;

    LOCAL PROCEDURE InitVATAmounts@111(PurchLine@1002 : Record 39;VAR TotalVAT@1000 : Decimal;VAR TotalVATACY@1001 : Decimal;VAR TotalAmount@1003 : Decimal;VAR TotalAmountACY@1004 : Decimal);
    BEGIN
      TotalVAT := PurchLine."Amount Including VAT" - PurchLine.Amount;
      TotalVATACY := PurchLineACY."Amount Including VAT" - PurchLineACY.Amount;
      TotalAmount := PurchLine.Amount;
      TotalAmountACY := PurchLineACY.Amount;
    END;

    LOCAL PROCEDURE InitAmounts@109(PurchLine@1005 : Record 39;VAR TotalVAT@1004 : Decimal;VAR TotalVATACY@1003 : Decimal;VAR TotalAmount@1002 : Decimal;VAR TotalAmountACY@1001 : Decimal;VAR AmtToDefer@1006 : Decimal;VAR AmtToDeferACY@1007 : Decimal;VAR DeferralAccount@1008 : Code[20]);
    BEGIN
      InitVATAmounts(PurchLine,TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
      GetAmountsForDeferral(PurchLine,AmtToDefer,AmtToDeferACY,DeferralAccount);
    END;

    LOCAL PROCEDURE CalcInvoiceDiscountPosting@112(PurchHeader@1002 : Record 38;PurchLine@1001 : Record 39;PurchLineACY@1000 : Record 39;VAR InvoicePostBuffer@1003 : Record 49);
    BEGIN
      CASE PurchLine."VAT Calculation Type" OF
        PurchLine."VAT Calculation Type"::"Normal VAT",PurchLine."VAT Calculation Type"::"Full VAT":
          InvoicePostBuffer.CalcDiscount(
            PurchHeader."Prices Including VAT",-PurchLine."Inv. Discount Amount",-PurchLineACY."Inv. Discount Amount");
        PurchLine."VAT Calculation Type"::"Reverse Charge VAT":
          InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Inv. Discount Amount",-PurchLineACY."Inv. Discount Amount");
        PurchLine."VAT Calculation Type"::"Sales Tax":
          IF NOT PurchLine."Use Tax" THEN // Use Tax is calculated later, based on totals
            InvoicePostBuffer.CalcDiscount(
              PurchHeader."Prices Including VAT",-PurchLine."Inv. Discount Amount",-PurchLineACY."Inv. Discount Amount")
          ELSE
            InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Inv. Discount Amount",-PurchLineACY."Inv. Discount Amount");
      END;
    END;

    LOCAL PROCEDURE CalcLineDiscountPosting@110(PurchHeader@1002 : Record 38;PurchLine@1001 : Record 39;PurchLineACY@1000 : Record 39;VAR InvoicePostBuffer@1003 : Record 49);
    BEGIN
      CASE PurchLine."VAT Calculation Type" OF
        PurchLine."VAT Calculation Type"::"Normal VAT",PurchLine."VAT Calculation Type"::"Full VAT":
          InvoicePostBuffer.CalcDiscount(
            PurchHeader."Prices Including VAT",-PurchLine."Line Discount Amount",-PurchLineACY."Line Discount Amount");
        PurchLine."VAT Calculation Type"::"Reverse Charge VAT":
          InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Line Discount Amount",-PurchLineACY."Line Discount Amount");
        PurchLine."VAT Calculation Type"::"Sales Tax":
          IF NOT PurchLine."Use Tax" THEN // Use Tax is calculated later, based on totals
            InvoicePostBuffer.CalcDiscount(
              PurchHeader."Prices Including VAT",-PurchLine."Line Discount Amount",-PurchLineACY."Line Discount Amount")
          ELSE
            InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Line Discount Amount",-PurchLineACY."Line Discount Amount");
      END;
    END;

    LOCAL PROCEDURE ClearPostBuffers@113();
    BEGIN
      CLEAR(WhsePostRcpt);
      CLEAR(WhsePostShpt);
      CLEAR(GenJnlPostLine);
      CLEAR(JobPostLine);
      CLEAR(ItemJnlPostLine);
      CLEAR(WhseJnlPostLine);
    END;

    LOCAL PROCEDURE ValidatePostingAndDocumentDate@119(VAR PurchaseHeader@1000 : Record 38);
    VAR
      BatchProcessingMgt@1002 : Codeunit 1380;
      BatchPostParameterTypes@1003 : Codeunit 1370;
      PostingDate@1007 : Date;
      ModifyHeader@1001 : Boolean;
      PostingDateExists@1006 : Boolean;
      ReplacePostingDate@1005 : Boolean;
      ReplaceDocumentDate@1004 : Boolean;
    BEGIN
      PostingDateExists :=
        BatchProcessingMgt.GetParameterBoolean(
          PurchaseHeader.RECORDID,BatchPostParameterTypes.ReplacePostingDate,ReplacePostingDate) AND
        BatchProcessingMgt.GetParameterBoolean(
          PurchaseHeader.RECORDID,BatchPostParameterTypes.ReplaceDocumentDate,ReplaceDocumentDate) AND
        BatchProcessingMgt.GetParameterDate(
          PurchaseHeader.RECORDID,BatchPostParameterTypes.PostingDate,PostingDate);

      IF PostingDateExists AND (ReplacePostingDate OR (PurchaseHeader."Posting Date" = 0D)) THEN BEGIN
        PurchaseHeader."Posting Date" := PostingDate;
        PurchaseHeader.VALIDATE("Currency Code");
        ModifyHeader := TRUE;
      END;

      IF PostingDateExists AND (ReplaceDocumentDate OR (PurchaseHeader."Document Date" = 0D)) THEN BEGIN
        PurchaseHeader.VALIDATE("Document Date",PostingDate);
        ModifyHeader := TRUE;
      END;

      IF ModifyHeader THEN
        PurchaseHeader.MODIFY;
    END;

    LOCAL PROCEDURE CheckExternalDocumentNumber@117(VAR VendLedgEntry@1001 : Record 25;VAR PurchaseHeader@1000 : Record 38);
    VAR
      Handled@1002 : Boolean;
    BEGIN
      OnBeforeCheckExternalDocumentNumber(VendLedgEntry,PurchaseHeader,Handled);
      IF Handled THEN
        EXIT;

      VendLedgEntry.RESET;
      VendLedgEntry.SETCURRENTKEY("External Document No.");
      VendLedgEntry.SETRANGE("Document Type",GenJnlLineDocType);
      VendLedgEntry.SETRANGE("External Document No.",GenJnlLineExtDocNo);
      VendLedgEntry.SETRANGE("Vendor No.",PurchaseHeader."Pay-to Vendor No.");
      VendLedgEntry.SETRANGE(Reversed,FALSE);
      IF VendLedgEntry.FINDFIRST THEN
        ERROR(
          PurchaseAlreadyExistsErr,VendLedgEntry."Document Type",GenJnlLineExtDocNo);
    END;

    LOCAL PROCEDURE PostInvoicePostingBuffer@141(PurchHeader@1002 : Record 38;VAR TempInvoicePostBuffer@1005 : TEMPORARY Record 49);
    VAR
      VATPostingSetup@1001 : Record 325;
      CurrExchRate@1003 : Record 330;
      LineCount@1000 : Integer;
      GLEntryNo@1004 : Integer;
    BEGIN
      LineCount := 0;
      IF TempInvoicePostBuffer.FIND('+') THEN
        REPEAT
          LineCount := LineCount + 1;
          IF GUIALLOWED THEN
            Window.UPDATE(3,LineCount);

          CASE TempInvoicePostBuffer."VAT Calculation Type" OF
            TempInvoicePostBuffer."VAT Calculation Type"::"Reverse Charge VAT":
              BEGIN
                VATPostingSetup.GET(
                  TempInvoicePostBuffer."VAT Bus. Posting Group",TempInvoicePostBuffer."VAT Prod. Posting Group");
                TempInvoicePostBuffer."VAT Amount" :=
                  ROUND(
                    TempInvoicePostBuffer."VAT Base Amount" *
                    (1 - PurchHeader."VAT Base Discount %" / 100) * VATPostingSetup."VAT %" / 100);
                TempInvoicePostBuffer."VAT Amount (ACY)" :=
                  ROUND(
                    TempInvoicePostBuffer."VAT Base Amount (ACY)" * (1 - PurchHeader."VAT Base Discount %" / 100) *
                    VATPostingSetup."VAT %" / 100,Currency."Amount Rounding Precision");
              END;
            TempInvoicePostBuffer."VAT Calculation Type"::"Sales Tax":
              IF TempInvoicePostBuffer."Use Tax" THEN BEGIN
                TempInvoicePostBuffer."VAT Amount" :=
                  ROUND(
                    SalesTaxCalculate.CalculateTax(
                      TempInvoicePostBuffer."Tax Area Code",TempInvoicePostBuffer."Tax Group Code",
                      TempInvoicePostBuffer."Tax Liable",PurchHeader."Posting Date",
                      TempInvoicePostBuffer.Amount,TempInvoicePostBuffer.Quantity,0));
                IF GLSetup."Additional Reporting Currency" <> '' THEN
                  TempInvoicePostBuffer."VAT Amount (ACY)" :=
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      PurchHeader."Posting Date",GLSetup."Additional Reporting Currency",
                      TempInvoicePostBuffer."VAT Amount",0);
              END;
          END;

          GLEntryNo := PostInvoicePostBufferLine(PurchHeader,TempInvoicePostBuffer);

          IF (TempInvoicePostBuffer."Job No." <> '') AND
             (TempInvoicePostBuffer.Type = TempInvoicePostBuffer.Type::"G/L Account")
          THEN
            JobPostLine.PostPurchaseGLAccounts(TempInvoicePostBuffer,GLEntryNo);

        UNTIL TempInvoicePostBuffer.NEXT(-1) = 0;

      TempInvoicePostBuffer.DELETEALL;
    END;

    LOCAL PROCEDURE PostItemTracking@144(PurchHeader@1000 : Record 38;PurchLine@1005 : Record 39;VAR TempTrackingSpecification@1004 : TEMPORARY Record 336;TrackingSpecificationExists@1002 : Boolean);
    VAR
      PurchRcptLine@1006 : Record 121;
      ItemEntryRelation@1003 : Record 6507;
      EndLoop@1001 : Boolean;
      RemQtyToInvoiceCurrLine@1007 : Decimal;
      RemQtyToInvoiceCurrLineBase@1008 : Decimal;
      QtyToBeInvoiced@1010 : Decimal;
      QtyToBeInvoicedBase@1009 : Decimal;
      QtyToInvoiceBaseInTrackingSpec@1011 : Decimal;
    BEGIN
      WITH PurchHeader DO BEGIN
        EndLoop := FALSE;
        IF TrackingSpecificationExists THEN BEGIN
          TempTrackingSpecification.CALCSUMS("Qty. to Invoice (Base)");
          QtyToInvoiceBaseInTrackingSpec := TempTrackingSpecification."Qty. to Invoice (Base)";
          IF NOT TempTrackingSpecification.FINDFIRST THEN
            TempTrackingSpecification.INIT;
        END;

        IF IsCreditDocType THEN BEGIN
          IF (ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Return Qty. to Ship")) OR
             (ABS(RemQtyToBeInvoiced) >= ABS(QtyToInvoiceBaseInTrackingSpec)) AND (QtyToInvoiceBaseInTrackingSpec <> 0)
          THEN BEGIN
            ReturnShptLine.RESET;
            CASE "Document Type" OF
              "Document Type"::"Return Order":
                BEGIN
                  ReturnShptLine.SETCURRENTKEY("Return Order No.","Return Order Line No.");
                  ReturnShptLine.SETRANGE("Return Order No.",PurchLine."Document No.");
                  ReturnShptLine.SETRANGE("Return Order Line No.",PurchLine."Line No.");
                END;
              "Document Type"::"Credit Memo":
                BEGIN
                  ReturnShptLine.SETRANGE("Document No.",PurchLine."Return Shipment No.");
                  ReturnShptLine.SETRANGE("Line No.",PurchLine."Return Shipment Line No.");
                END;
            END;
            ReturnShptLine.SETFILTER("Return Qty. Shipped Not Invd.",'<>0');
            IF ReturnShptLine.FINDSET(TRUE,FALSE) THEN BEGIN
              ItemJnlRollRndg := TRUE;
              REPEAT
                IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
                  ItemEntryRelation.GET(TempTrackingSpecification."Item Ledger Entry No.");
                  ReturnShptLine.GET(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
                END ELSE
                  ItemEntryRelation."Item Entry No." := ReturnShptLine."Item Shpt. Entry No.";
                ReturnShptLine.TESTFIELD("Buy-from Vendor No.",PurchLine."Buy-from Vendor No.");
                ReturnShptLine.TESTFIELD(Type,PurchLine.Type);
                ReturnShptLine.TESTFIELD("No.",PurchLine."No.");
                ReturnShptLine.TESTFIELD("Gen. Bus. Posting Group",PurchLine."Gen. Bus. Posting Group");
                ReturnShptLine.TESTFIELD("Gen. Prod. Posting Group",PurchLine."Gen. Prod. Posting Group");
                ReturnShptLine.TESTFIELD("Job No.",PurchLine."Job No.");
                ReturnShptLine.TESTFIELD("Unit of Measure Code",PurchLine."Unit of Measure Code");
                ReturnShptLine.TESTFIELD("Variant Code",PurchLine."Variant Code");
                ReturnShptLine.TESTFIELD("Prod. Order No.",PurchLine."Prod. Order No.");
                UpdateQtyToBeInvoicedForReturnShipment(
                  QtyToBeInvoiced,QtyToBeInvoicedBase,
                  TrackingSpecificationExists,PurchLine,ReturnShptLine,TempTrackingSpecification);

                IF TrackingSpecificationExists THEN BEGIN
                  TempTrackingSpecification."Quantity actual Handled (Base)" := QtyToBeInvoicedBase;
                  TempTrackingSpecification.MODIFY;
                END;

                IF TrackingSpecificationExists THEN
                  ItemTrackingMgt.AdjustQuantityRounding(
                    RemQtyToBeInvoiced,QtyToBeInvoiced,
                    RemQtyToBeInvoicedBase,QtyToBeInvoicedBase);

                RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                ReturnShptLine."Quantity Invoiced" :=
                  ReturnShptLine."Quantity Invoiced" - QtyToBeInvoiced;
                ReturnShptLine."Qty. Invoiced (Base)" :=
                  ReturnShptLine."Qty. Invoiced (Base)" - QtyToBeInvoicedBase;
                ReturnShptLine."Return Qty. Shipped Not Invd." :=
                  ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced";
                ReturnShptLine.MODIFY;
                IF PurchLine.Type = PurchLine.Type::Item THEN
                  PostItemJnlLine(
                    PurchHeader,PurchLine,
                    0,0,
                    QtyToBeInvoiced,QtyToBeInvoicedBase,
                    ItemEntryRelation."Item Entry No.",'',TempTrackingSpecification);
                IF TrackingSpecificationExists THEN
                  EndLoop := (TempTrackingSpecification.NEXT = 0) OR (RemQtyToBeInvoiced = 0)
                ELSE
                  EndLoop :=
                    (ReturnShptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(PurchLine."Return Qty. to Ship"));
              UNTIL EndLoop;
            END ELSE
              ERROR(
                ReturnShipmentInvoicedErr,
                PurchLine."Return Shipment Line No.",PurchLine."Return Shipment No.");
          END;

          IF ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Return Qty. to Ship") THEN BEGIN
            IF "Document Type" = "Document Type"::"Credit Memo" THEN
              ERROR(InvoiceGreaterThanReturnShipmentErr,ReturnShptLine."Document No.");
            ERROR(ReturnShipmentLinesDeletedErr);
          END;
        END ELSE BEGIN
          IF (ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Qty. to Receive")) OR
             (ABS(RemQtyToBeInvoiced) >= ABS(QtyToInvoiceBaseInTrackingSpec)) AND (QtyToInvoiceBaseInTrackingSpec <> 0)
          THEN BEGIN
            PurchRcptLine.RESET;
            CASE "Document Type" OF
              "Document Type"::Order:
                BEGIN
                  PurchRcptLine.SETCURRENTKEY("Order No.","Order Line No.");
                  PurchRcptLine.SETRANGE("Order No.",PurchLine."Document No.");
                  PurchRcptLine.SETRANGE("Order Line No.",PurchLine."Line No.");
                END;
              "Document Type"::Invoice:
                BEGIN
                  PurchRcptLine.SETRANGE("Document No.",PurchLine."Receipt No.");
                  PurchRcptLine.SETRANGE("Line No.",PurchLine."Receipt Line No.");
                END;
            END;

            PurchRcptLine.SETFILTER("Qty. Rcd. Not Invoiced",'<>0');
            IF PurchRcptLine.FINDSET(TRUE,FALSE) THEN BEGIN
              ItemJnlRollRndg := TRUE;
              REPEAT
                IF TrackingSpecificationExists THEN BEGIN
                  ItemEntryRelation.GET(TempTrackingSpecification."Item Ledger Entry No.");
                  PurchRcptLine.GET(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
                END ELSE
                  ItemEntryRelation."Item Entry No." := PurchRcptLine."Item Rcpt. Entry No.";
                UpdateRemainingQtyToBeInvoiced(RemQtyToInvoiceCurrLine,RemQtyToInvoiceCurrLineBase,PurchRcptLine);
                PurchRcptLine.TESTFIELD("Buy-from Vendor No.",PurchLine."Buy-from Vendor No.");
                PurchRcptLine.TESTFIELD(Type,PurchLine.Type);
                PurchRcptLine.TESTFIELD("No.",PurchLine."No.");
                PurchRcptLine.TESTFIELD("Gen. Bus. Posting Group",PurchLine."Gen. Bus. Posting Group");
                PurchRcptLine.TESTFIELD("Gen. Prod. Posting Group",PurchLine."Gen. Prod. Posting Group");
                PurchRcptLine.TESTFIELD("Job No.",PurchLine."Job No.");
                PurchRcptLine.TESTFIELD("Unit of Measure Code",PurchLine."Unit of Measure Code");
                PurchRcptLine.TESTFIELD("Variant Code",PurchLine."Variant Code");
                PurchRcptLine.TESTFIELD("Prod. Order No.",PurchLine."Prod. Order No.");

                UpdateQtyToBeInvoicedForReceipt(
                  QtyToBeInvoiced,QtyToBeInvoicedBase,
                  TrackingSpecificationExists,PurchLine,PurchRcptLine,TempTrackingSpecification);

                IF TrackingSpecificationExists THEN BEGIN
                  TempTrackingSpecification."Quantity actual Handled (Base)" := QtyToBeInvoicedBase;
                  TempTrackingSpecification.MODIFY;
                END;

                IF TrackingSpecificationExists THEN
                  ItemTrackingMgt.AdjustQuantityRounding(
                    RemQtyToInvoiceCurrLine,QtyToBeInvoiced,
                    RemQtyToInvoiceCurrLineBase,QtyToBeInvoicedBase);

                RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                UpdateInvoicedQtyOnPurchRcptLine(PurchRcptLine,QtyToBeInvoiced,QtyToBeInvoicedBase);
                IF PurchLine.Type = PurchLine.Type::Item THEN
                  PostItemJnlLine(
                    PurchHeader,PurchLine,
                    0,0,
                    QtyToBeInvoiced,QtyToBeInvoicedBase,
                    ItemEntryRelation."Item Entry No.",'',TempTrackingSpecification);
                IF TrackingSpecificationExists THEN
                  EndLoop := (TempTrackingSpecification.NEXT = 0) OR (RemQtyToBeInvoiced = 0)
                ELSE
                  EndLoop :=
                    (PurchRcptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(PurchLine."Qty. to Receive"));
              UNTIL EndLoop;
            END ELSE
              ERROR(ReceiptInvoicedErr,PurchLine."Receipt Line No.",PurchLine."Receipt No.");
          END;

          IF ABS(RemQtyToBeInvoiced) > ABS(PurchLine."Qty. to Receive") THEN BEGIN
            IF "Document Type" = "Document Type"::Invoice THEN
              ERROR(QuantityToInvoiceGreaterErr,PurchRcptLine."Document No.");
            ERROR(ReceiptLinesDeletedErr);
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE PostUpdateOrderLine@142(PurchHeader@1001 : Record 38);
    VAR
      TempPurchLine@1000 : TEMPORARY Record 39;
    BEGIN
      ResetTempLines(TempPurchLine);
      WITH TempPurchLine DO BEGIN
        SETFILTER(Quantity,'<>0');
        IF FINDSET THEN
          REPEAT
            IF PurchHeader.Receive THEN BEGIN
              "Quantity Received" += "Qty. to Receive";
              "Qty. Received (Base)" += "Qty. to Receive (Base)";
            END;
            IF PurchHeader.Ship THEN BEGIN
              "Return Qty. Shipped" += "Return Qty. to Ship";
              "Return Qty. Shipped (Base)" += "Return Qty. to Ship (Base)";
            END;
            IF PurchHeader.Invoice THEN BEGIN
              IF "Document Type" = "Document Type"::Order THEN BEGIN
                IF ABS("Quantity Invoiced" + "Qty. to Invoice") > ABS("Quantity Received") THEN BEGIN
                  VALIDATE("Qty. to Invoice","Quantity Received" - "Quantity Invoiced");
                  "Qty. to Invoice (Base)" := "Qty. Received (Base)" - "Qty. Invoiced (Base)";
                END
              END ELSE
                IF ABS("Quantity Invoiced" + "Qty. to Invoice") > ABS("Return Qty. Shipped") THEN BEGIN
                  VALIDATE("Qty. to Invoice","Return Qty. Shipped" - "Quantity Invoiced");
                  "Qty. to Invoice (Base)" := "Return Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
                END;

              "Quantity Invoiced" := "Quantity Invoiced" + "Qty. to Invoice";
              "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" + "Qty. to Invoice (Base)";
              IF "Qty. to Invoice" <> 0 THEN BEGIN
                "Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
                "Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
                DecrementPrepmtAmtInvLCY(
                  TempPurchLine,"Prepmt. Amount Inv. (LCY)","Prepmt. VAT Amount Inv. (LCY)");
                "Prepmt Amt to Deduct" := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";
                "Prepmt VAT Diff. to Deduct" := 0;
              END;
            END;

            UpdateBlanketOrderLine(TempPurchLine,PurchHeader.Receive,PurchHeader.Ship,PurchHeader.Invoice);
            InitOutstanding;

            IF WhseHandlingRequired(TempPurchLine) OR
               (PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Blank)
            THEN BEGIN
              IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                "Return Qty. to Ship" := 0;
                "Return Qty. to Ship (Base)" := 0;
              END ELSE BEGIN
                "Qty. to Receive" := 0;
                "Qty. to Receive (Base)" := 0;
              END;
              InitQtyToInvoice;
            END ELSE BEGIN
              IF "Document Type" = "Document Type"::"Return Order" THEN
                InitQtyToShip
              ELSE
                InitQtyToReceive2;
            END;
            SetDefaultQuantity;
            ModifyTempLine(TempPurchLine);
            OnAfterPostUpdateOrderLine(TempPurchLine,WhseShip,WhseReceive);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE PostUpdateInvoiceLine@140();
    VAR
      PurchOrderLine@1001 : Record 39;
      PurchRcptLine@1002 : Record 121;
      SalesOrderLine@1003 : Record 37;
      TempPurchLine@1000 : TEMPORARY Record 39;
    BEGIN
      ResetTempLines(TempPurchLine);
      WITH TempPurchLine DO BEGIN
        SETFILTER("Receipt No.",'<>%1','');
        SETFILTER(Type,'<>%1',Type::" ");
        IF FINDSET THEN
          REPEAT
            PurchRcptLine.GET("Receipt No.","Receipt Line No.");
            PurchOrderLine.GET(
              PurchOrderLine."Document Type"::Order,
              PurchRcptLine."Order No.",PurchRcptLine."Order Line No.");
            IF Type = Type::"Charge (Item)" THEN
              UpdatePurchOrderChargeAssgnt(TempPurchLine,PurchOrderLine);
            PurchOrderLine."Quantity Invoiced" += "Qty. to Invoice";
            PurchOrderLine."Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
            IF ABS(PurchOrderLine."Quantity Invoiced") > ABS(PurchOrderLine."Quantity Received") THEN
              ERROR(InvoiceMoreThanReceivedErr,PurchOrderLine."Document No.");
            IF PurchOrderLine."Sales Order Line No." <> 0 THEN BEGIN // Drop Shipment
              SalesOrderLine.GET(
                SalesOrderLine."Document Type"::Order,
                PurchOrderLine."Sales Order No.",PurchOrderLine."Sales Order Line No.");
              IF ABS(PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced") <
                 ABS(SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced")
              THEN
                ERROR(CannotPostBeforeAssosSalesOrderErr,PurchOrderLine."Sales Order No.");
            END;
            PurchOrderLine.InitQtyToInvoice;
            IF PurchOrderLine."Prepayment %" <> 0 THEN BEGIN
              PurchOrderLine."Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
              PurchOrderLine."Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
              DecrementPrepmtAmtInvLCY(
                TempPurchLine,PurchOrderLine."Prepmt. Amount Inv. (LCY)",PurchOrderLine."Prepmt. VAT Amount Inv. (LCY)");
              PurchOrderLine."Prepmt Amt to Deduct" :=
                PurchOrderLine."Prepmt. Amt. Inv." - PurchOrderLine."Prepmt Amt Deducted";
              PurchOrderLine."Prepmt VAT Diff. to Deduct" := 0;
            END;
            PurchOrderLine.InitOutstanding;
            PurchOrderLine.MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE PostUpdateCreditMemoLine@108();
    VAR
      PurchOrderLine@1002 : Record 39;
      ReturnShptLine@1001 : Record 6651;
      TempPurchLine@1000 : TEMPORARY Record 39;
    BEGIN
      ResetTempLines(TempPurchLine);
      WITH TempPurchLine DO BEGIN
        SETFILTER("Return Shipment No.",'<>%1','');
        SETFILTER(Type,'<>%1',Type::" ");
        IF FINDSET THEN
          REPEAT
            ReturnShptLine.GET("Return Shipment No.","Return Shipment Line No.");
            PurchOrderLine.GET(
              PurchOrderLine."Document Type"::"Return Order",
              ReturnShptLine."Return Order No.",ReturnShptLine."Return Order Line No.");
            IF Type = Type::"Charge (Item)" THEN
              UpdatePurchOrderChargeAssgnt(TempPurchLine,PurchOrderLine);
            PurchOrderLine."Quantity Invoiced" :=
              PurchOrderLine."Quantity Invoiced" + "Qty. to Invoice";
            PurchOrderLine."Qty. Invoiced (Base)" :=
              PurchOrderLine."Qty. Invoiced (Base)" + "Qty. to Invoice (Base)";
            IF ABS(PurchOrderLine."Quantity Invoiced") > ABS(PurchOrderLine."Return Qty. Shipped") THEN
              ERROR(InvoiceMoreThanShippedErr,PurchOrderLine."Document No.");
            PurchOrderLine.InitQtyToInvoice;
            PurchOrderLine.InitOutstanding;
            PurchOrderLine.MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetPostingFlags@18(VAR PurchHeader@1000 : Record 38);
    BEGIN
      WITH PurchHeader DO BEGIN
        CASE "Document Type" OF
          "Document Type"::Order:
            Ship := FALSE;
          "Document Type"::Invoice:
            BEGIN
              Receive := TRUE;
              Invoice := TRUE;
              Ship := FALSE;
            END;
          "Document Type"::"Return Order":
            Receive := FALSE;
          "Document Type"::"Credit Memo":
            BEGIN
              Receive := FALSE;
              Invoice := TRUE;
              Ship := TRUE;
            END;
        END;
        IF NOT (Receive OR Invoice OR Ship) THEN
          ERROR(ReceiveInvoiceShipErr);
      END;
    END;

    LOCAL PROCEDURE SetCheckApplToItemEntry@164(PurchLine@1000 : Record 39) : Boolean;
    BEGIN
      WITH PurchLine DO
        EXIT(
          PurchSetup."Exact Cost Reversing Mandatory" AND (Type = Type::Item) AND
          (((Quantity < 0) AND ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice])) OR
           ((Quantity > 0) AND IsCreditDocType)) AND
          ("Job No." = ''));
    END;

    LOCAL PROCEDURE CreatePostedDeferralScheduleFromPurchDoc@169(PurchLine@1008 : Record 39;NewDocumentType@1007 : Integer;NewDocumentNo@1003 : Code[20];NewLineNo@1002 : Integer;PostingDate@1000 : Date);
    VAR
      PostedDeferralHeader@1006 : Record 1704;
      PostedDeferralLine@1005 : Record 1705;
      DeferralTemplate@1004 : Record 1700;
      DeferralAccount@1001 : Code[20];
    BEGIN
      IF PurchLine."Deferral Code" = '' THEN
        EXIT;

      IF DeferralTemplate.GET(PurchLine."Deferral Code") THEN
        DeferralAccount := DeferralTemplate."Deferral Account";

      IF TempDeferralHeader.GET(
           DeferralUtilities.GetPurchDeferralDocType,'','',PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.")
      THEN BEGIN
        PostedDeferralHeader.InitFromDeferralHeader(TempDeferralHeader,'','',NewDocumentType,
          NewDocumentNo,NewLineNo,DeferralAccount,PurchLine."Buy-from Vendor No.",PostingDate);
        WITH TempDeferralLine DO BEGIN
          SETRANGE("Deferral Doc. Type",DeferralUtilities.GetPurchDeferralDocType);
          SETRANGE("Gen. Jnl. Template Name",'');
          SETRANGE("Gen. Jnl. Batch Name",'');
          SETRANGE("Document Type",PurchLine."Document Type");
          SETRANGE("Document No.",PurchLine."Document No.");
          SETRANGE("Line No.",PurchLine."Line No.");
          IF FINDSET THEN BEGIN
            REPEAT
              PostedDeferralLine.InitFromDeferralLine(
                TempDeferralLine,'','',NewDocumentType,NewDocumentNo,NewLineNo,DeferralAccount);
            UNTIL NEXT = 0;
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE CalcDeferralAmounts@173(PurchHeader@1000 : Record 38;PurchLine@1003 : Record 39;OriginalDeferralAmount@1002 : Decimal);
    VAR
      DeferralHeader@1004 : Record 1701;
      DeferralLine@1005 : Record 1702;
      CurrExchRate@1006 : Record 330;
      TotalAmountLCY@1009 : Decimal;
      TotalAmount@1010 : Decimal;
      TotalDeferralCount@1007 : Integer;
      DeferralCount@1008 : Integer;
      UseDate@1001 : Date;
    BEGIN
      // Populate temp and calculate the LCY amounts for posting
      IF PurchHeader."Posting Date" = 0D THEN
        UseDate := WORKDATE
      ELSE
        UseDate := PurchHeader."Posting Date";

      IF DeferralHeader.GET(
           DeferralUtilities.GetPurchDeferralDocType,'','',PurchLine."Document Type",PurchLine."Document No.",PurchLine."Line No.")
      THEN BEGIN
        TempDeferralHeader := DeferralHeader;
        IF PurchLine.Quantity <> PurchLine."Qty. to Invoice" THEN
          TempDeferralHeader."Amount to Defer" :=
            ROUND(TempDeferralHeader."Amount to Defer" *
              PurchLine.GetDeferralAmount / OriginalDeferralAmount,Currency."Amount Rounding Precision");
        TempDeferralHeader."Amount to Defer (LCY)" :=
          ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              UseDate,PurchHeader."Currency Code",
              TempDeferralHeader."Amount to Defer",PurchHeader."Currency Factor"));
        TempDeferralHeader.INSERT;

        WITH DeferralLine DO BEGIN
          SETRANGE("Deferral Doc. Type",DeferralUtilities.GetPurchDeferralDocType);
          SETRANGE("Gen. Jnl. Template Name",'');
          SETRANGE("Gen. Jnl. Batch Name",'');
          SETRANGE("Document Type",PurchLine."Document Type");
          SETRANGE("Document No.",PurchLine."Document No.");
          SETRANGE("Line No.",PurchLine."Line No.");
          IF FINDSET THEN BEGIN
            TotalDeferralCount := COUNT;
            REPEAT
              TempDeferralLine.INIT;
              TempDeferralLine := DeferralLine;
              DeferralCount := DeferralCount + 1;

              IF DeferralCount = TotalDeferralCount THEN BEGIN
                TempDeferralLine.Amount := TempDeferralHeader."Amount to Defer" - TotalAmount;
                TempDeferralLine."Amount (LCY)" := TempDeferralHeader."Amount to Defer (LCY)" - TotalAmountLCY;
              END ELSE BEGIN
                IF PurchLine.Quantity <> PurchLine."Qty. to Invoice" THEN
                  TempDeferralLine.Amount :=
                    ROUND(TempDeferralLine.Amount *
                      PurchLine.GetDeferralAmount / OriginalDeferralAmount,Currency."Amount Rounding Precision");

                TempDeferralLine."Amount (LCY)" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate,PurchHeader."Currency Code",
                      TempDeferralLine.Amount,PurchHeader."Currency Factor"));
                TotalAmount := TotalAmount + TempDeferralLine.Amount;
                TotalAmountLCY := TotalAmountLCY + TempDeferralLine."Amount (LCY)";
              END;
              TempDeferralLine.INSERT;
            UNTIL NEXT = 0;
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE GetAmountRoundingPrecisionInLCY@122(DocType@1001 : Option;DocNo@1002 : Code[20];CurrencyCode@1000 : Code[10]) AmountRoundingPrecision : Decimal;
    VAR
      PurchHeader@1003 : Record 38;
    BEGIN
      IF CurrencyCode = '' THEN
        EXIT(GLSetup."Amount Rounding Precision");
      PurchHeader.GET(DocType,DocNo);
      AmountRoundingPrecision := Currency."Amount Rounding Precision" / PurchHeader."Currency Factor";
      IF AmountRoundingPrecision < GLSetup."Amount Rounding Precision" THEN
        EXIT(GLSetup."Amount Rounding Precision");
      EXIT(AmountRoundingPrecision);
    END;

    LOCAL PROCEDURE CollectPurchaseLineReservEntries@185(VAR JobReservEntry@1003 : Record 337;ItemJournalLine@1001 : Record 83);
    VAR
      ReservationEntry@1004 : Record 337;
      ItemJnlLineReserve@1000 : Codeunit 99000835;
    BEGIN
      IF ItemJournalLine."Job No." <> '' THEN BEGIN
        JobReservEntry.DELETEALL;
        ItemJnlLineReserve.FindReservEntry(ItemJournalLine,ReservationEntry);
        ReservationEntry.ClearTrackingFilter;
        IF ReservationEntry.FINDSET THEN
          REPEAT
            JobReservEntry := ReservationEntry;
            JobReservEntry.INSERT;
          UNTIL ReservationEntry.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE ArchiveSalesOrders@180(VAR TempDropShptPostBuffer@1000 : TEMPORARY Record 223);
    VAR
      SalesOrderHeader@1002 : Record 36;
      SalesOrderLine@1001 : Record 37;
    BEGIN
      IF TempDropShptPostBuffer.FINDSET THEN BEGIN
        REPEAT
          SalesOrderHeader.GET(
            SalesOrderHeader."Document Type"::Order,
            TempDropShptPostBuffer."Order No.");
          TempDropShptPostBuffer.SETRANGE("Order No.",TempDropShptPostBuffer."Order No.");
          REPEAT
            SalesOrderLine.GET(
              SalesOrderLine."Document Type"::Order,
              TempDropShptPostBuffer."Order No.",TempDropShptPostBuffer."Order Line No.");
            SalesOrderLine."Qty. to Ship" := TempDropShptPostBuffer.Quantity;
            SalesOrderLine."Qty. to Ship (Base)" := TempDropShptPostBuffer."Quantity (Base)";
            SalesOrderLine.MODIFY;
          UNTIL TempDropShptPostBuffer.NEXT = 0;
          SalesPost.ArchiveUnpostedOrder(SalesOrderHeader);
          TempDropShptPostBuffer.SETRANGE("Order No.");
        UNTIL TempDropShptPostBuffer.NEXT = 0;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCheckPurchDoc@1(PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    PROCEDURE OnAfterPostPurchaseDoc@116(VAR PurchaseHeader@1000 : Record 38;VAR GenJnlPostLine@1001 : Codeunit 12;PurchRcpHdrNo@1002 : Code[20];RetShptHdrNo@1003 : Code[20];PurchInvHdrNo@1004 : Code[20];PurchCrMemoHdrNo@1005 : Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdatePostingNos@178(VAR PurchaseHeader@1000 : Record 38;VAR NoSeriesMgt@1001 : Codeunit 396);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCheckMandatoryFields@195(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterFillInvoicePostBuffer@213(VAR InvoicePostBuffer@1000 : Record 49;PurchLine@1001 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterFinalizePosting@196(VAR PurchHeader@1000 : Record 38;VAR PurchRcptHeader@1001 : Record 120;VAR PurchInvHeader@1002 : Record 122;VAR PurchCrMemoHdr@1003 : Record 124;VAR ReturnShptHeader@1004 : Record 6650;VAR GenJnlPostLine@1005 : Codeunit 12);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostItemJnlLineCopyProdOrder@197(VAR ItemJnlLine@1000 : Record 83;PurchLine@1001 : Record 39;PurchRcptHeader@1002 : Record 120;QtyToBeReceived@1003 : Decimal);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPurchRcptHeaderInsert@200(VAR PurchRcptHeader@1001 : Record 120;VAR PurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPurchRcptLineInsert@211(PurchaseLine@1000 : Record 39;PurchRcptLine@1001 : Record 121;ItemLedgShptEntryNo@1002 : Integer;WhseShip@1003 : Boolean;WhseReceive@1004 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPurchInvHeaderInsert@203(VAR PurchInvHeader@1001 : Record 122;VAR PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPurchInvLineInsert@177(VAR PurchInvLine@1000 : Record 123;PurchInvHeader@1002 : Record 122;PurchLine@1001 : Record 39;ItemLedgShptEntryNo@1003 : Integer;WhseShip@1004 : Boolean;WhseReceive@1005 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPurchCrMemoHeaderInsert@204(VAR PurchCrMemoHdr@1001 : Record 124;VAR PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPurchCrMemoLineInsert@182(VAR PurchCrMemoLine@1000 : Record 125;VAR PurchCrMemoHdr@1002 : Record 124;VAR PurchLine@1001 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterReturnShptHeaderInsert@201(VAR ReturnShptHeader@1001 : Record 6650;VAR PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterReturnShptLineInsert@202(VAR ReturnShptLine@1001 : Record 6651;ReturnShptHeader@1002 : Record 6650;PurchLine@1000 : Record 39;ItemLedgShptEntryNo@1003 : Integer;WhseShip@1004 : Boolean;WhseReceive@1005 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostAccICLine@209(PurchaseLine@1000 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostItemLine@210(PurchaseLine@1000 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostVendorEntry@181(VAR GenJnlLine@1003 : Record 81;VAR PurchHeader@1000 : Record 38;VAR TotalPurchLine@1001 : Record 39;VAR TotalPurchLineLCY@1002 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostBalancingEntry@184(VAR GenJnlLine@1000 : Record 81;VAR PurchHeader@1003 : Record 38;VAR TotalPurchLine@1002 : Record 39;VAR TotalPurchLineLCY@1001 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostInvPostBuffer@206(VAR GenJnlLine@1002 : Record 81;VAR InvoicePostBuffer@1001 : Record 49;PurchHeader@1000 : Record 38;GLEntryNo@1003 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostWhseJnlLine@1012(VAR PurchaseLine@1000 : Record 39;ItemLedgEntryNo@1003 : Integer;WhseShip@1001 : Boolean;WhseReceive@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostUpdateOrderLine@1015(VAR PurchaseLine@1000 : Record 39;WhseShip@1001 : Boolean;WhseReceive@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdatePurchLineBeforePost@1014(VAR PurchaseLine@1000 : Record 39;WhseShip@1001 : Boolean;WhseReceive@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCheckExternalDocumentNumber@215(VendorLedgerEntry@1000 : Record 25;PurchaseHeader@1001 : Record 38;VAR Handled@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInvoiceRoundingAmount@208(PurchHeader@1000 : Record 38;TotalAmountIncludingVAT@1001 : Decimal;UseTempData@1002 : Boolean;VAR InvoiceRoundingAmount@1003 : Decimal);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostGLAndVendor@205(VAR PurchHeader@1000 : Record 38;VAR TempInvoicePostBuffer@1001 : TEMPORARY Record 49);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostPurchaseDoc@114(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostCommitPurchaseDoc@115(VAR PurchaseHeader@1000 : Record 38;VAR GenJnlPostLine@1001 : Codeunit 12;PreviewMode@1002 : Boolean;ModifyHeader@1003 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePurchRcptHeaderInsert@183(VAR PurchRcptHeader@1001 : Record 120;VAR PurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePurchRcptLineInsert@192(VAR PurchRcptLine@1001 : Record 121;VAR PurchRcptHeader@1002 : Record 120;VAR PurchLine@1000 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePurchInvHeaderInsert@176(VAR PurchInvHeader@1001 : Record 122;VAR PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePurchInvLineInsert@189(VAR PurchInvLine@1001 : Record 123;VAR PurchInvHeader@1000 : Record 122;VAR PurchaseLine@1002 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePurchCrMemoHeaderInsert@187(VAR PurchCrMemoHdr@1001 : Record 124;VAR PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePurchCrMemoLineInsert@190(VAR PurchCrMemoLine@1001 : Record 125;VAR PurchCrMemoHdr@1000 : Record 124;VAR PurchLine@1002 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeReturnShptHeaderInsert@186(VAR ReturnShptHeader@1001 : Record 6650;VAR PurchHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeReturnShptLineInsert@191(VAR ReturnShptLine@1001 : Record 6651;VAR ReturnShptHeader@1002 : Record 6650;VAR PurchLine@1000 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostVendorEntry@193(VAR GenJnlLine@1003 : Record 81;VAR PurchHeader@1000 : Record 38;VAR TotalPurchLine@1001 : Record 39;VAR TotalPurchLineLCY@1002 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostBalancingEntry@194(VAR GenJnlLine@1000 : Record 81;VAR PurchHeader@1003 : Record 38;VAR TotalPurchLine@1002 : Record 39;VAR TotalPurchLineLCY@1001 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostInvPostBuffer@6(VAR GenJnlLine@1000 : Record 81;VAR InvoicePostBuffer@1001 : Record 49;VAR PurchHeader@1003 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeUpdatePurchLineBeforePost@199(VAR PurchaseLine@1000 : Record 39;VAR PurchaseHeader@1001 : Record 38;WhseShip@1002 : Boolean;WhseReceive@1003 : Boolean);
    BEGIN
    END;

    [Integration(DEFAULT,TRUE)]
    LOCAL PROCEDURE OnBeforeTestPurchLine@1006(VAR PurchaseLine@1000 : Record 39;VAR PurchaseHeader@1001 : Record 38);
    BEGIN
    END;

    BEGIN
    END.
  }
}

