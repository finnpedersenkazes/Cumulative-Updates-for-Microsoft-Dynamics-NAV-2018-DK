OBJECT Codeunit 80 Sales-Post
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572,NAVDK11.00.00.23572;
  }
  PROPERTIES
  {
    TableNo=36;
    Permissions=TableData 37=imd,
                TableData 38=m,
                TableData 39=m,
                TableData 49=imd,
                TableData 110=imd,
                TableData 111=imd,
                TableData 112=imd,
                TableData 113=imd,
                TableData 114=imd,
                TableData 115=imd,
                TableData 120=imd,
                TableData 121=imd,
                TableData 223=imd,
                TableData 252=imd,
                TableData 914=i,
                TableData 6507=ri,
                TableData 6508=rid,
                TableData 6660=imd,
                TableData 6661=imd;
    OnRun=VAR
            SalesHeader@1005 : Record 36;
            SalesLine@1001 : Record 37;
            TempInvoicePostBuffer@1000 : TEMPORARY Record 49;
            TempItemLedgEntryNotInvoiced@1006 : TEMPORARY Record 32;
            CustLedgEntry@1013 : Record 21;
            TempCombinedSalesLine@1022 : TEMPORARY Record 37;
            TempServiceItem2@1040 : TEMPORARY Record 5940;
            TempServiceItemComp2@1038 : TEMPORARY Record 5941;
            TempVATAmountLine@1043 : TEMPORARY Record 290;
            TempVATAmountLineRemainder@1042 : TEMPORARY Record 290;
            TempDropShptPostBuffer@1009 : TEMPORARY Record 223;
            UpdateAnalysisView@1002 : Codeunit 410;
            UpdateItemAnalysisView@1014 : Codeunit 7150;
            HasATOShippedNotInvoiced@1012 : Boolean;
            EverythingInvoiced@1034 : Boolean;
            BiggestLineNo@1020 : Integer;
            ICGenJnlLineNo@1032 : Integer;
            LineCount@1035 : Integer;
          BEGIN
            OnBeforePostSalesDoc(Rec);

            ValidatePostingAndDocumentDate(Rec);

            IF PreviewMode THEN BEGIN
              CLEARALL;
              PreviewMode := TRUE;
            END ELSE
              CLEARALL;

            GetGLSetup;
            GetCurrency("Currency Code");

            SalesSetup.GET;
            SalesHeader := Rec;
            FillTempLines(SalesHeader);
            TempServiceItem2.DELETEALL;
            TempServiceItemComp2.DELETEALL;

            // Header
            CheckAndUpdate(SalesHeader);

            TempDeferralHeader.DELETEALL;
            TempDeferralLine.DELETEALL;
            TempInvoicePostBuffer.DELETEALL;
            TempDropShptPostBuffer.DELETEALL;
            EverythingInvoiced := TRUE;

            // Lines
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.",SalesHeader."No.");
            LineCount := 0;
            RoundingLineInserted := FALSE;
            MergeSaleslines(SalesHeader,SalesLine,TempPrepaymentSalesLine,TempCombinedSalesLine);
            AdjustFinalInvWith100PctPrepmt(TempCombinedSalesLine);

            TempVATAmountLineRemainder.DELETEALL;
            SalesLine.CalcVATAmountLines(1,SalesHeader,TempCombinedSalesLine,TempVATAmountLine);

            SalesLinesProcessed := FALSE;
            IF SalesLine.FINDFIRST THEN
              REPEAT
                ItemJnlRollRndg := FALSE;
                LineCount := LineCount + 1;
                Window.UPDATE(2,LineCount);

                PostSalesLine(
                  SalesHeader,SalesLine,EverythingInvoiced,TempInvoicePostBuffer,TempVATAmountLine,TempVATAmountLineRemainder,
                  TempItemLedgEntryNotInvoiced,HasATOShippedNotInvoiced,TempDropShptPostBuffer,ICGenJnlLineNo,
                  TempServiceItem2,TempServiceItemComp2);

                IF RoundingLineInserted THEN
                  LastLineRetrieved := TRUE
                ELSE BEGIN
                  BiggestLineNo := MAX(BiggestLineNo,SalesLine."Line No.");
                  LastLineRetrieved := GetNextSalesline(SalesLine);
                  IF LastLineRetrieved AND SalesSetup."Invoice Rounding" THEN
                    InvoiceRounding(SalesHeader,SalesLine,FALSE,BiggestLineNo);
                END;
              UNTIL LastLineRetrieved;

            IF NOT SalesHeader.IsCreditDocType THEN BEGIN
              ReverseAmount(TotalSalesLine);
              ReverseAmount(TotalSalesLineLCY);
              TotalSalesLineLCY."Unit Cost (LCY)" := -TotalSalesLineLCY."Unit Cost (LCY)";
            END;

            PostDropOrderShipment(SalesHeader,TempDropShptPostBuffer);
            IF SalesHeader.Invoice THEN
              PostGLAndCustomer(SalesHeader,TempInvoicePostBuffer,CustLedgEntry);

            IF ICGenJnlLineNo > 0 THEN
              PostICGenJnl;

            MakeInventoryAdjustment;
            UpdateLastPostingNos(SalesHeader);

            FinalizePosting(SalesHeader,EverythingInvoiced,TempDropShptPostBuffer);

            Rec := SalesHeader;
            SynchBOMSerialNo(TempServiceItem2,TempServiceItemComp2);
            IF NOT InvtPickPutaway THEN BEGIN
              COMMIT;
              UpdateAnalysisView.UpdateAll(0,TRUE);
              UpdateItemAnalysisView.UpdateAll(0,TRUE);
            END;

            OnAfterPostSalesDoc(
              Rec,GenJnlPostLine,SalesShptHeader."No.",ReturnRcptHeader."No.",SalesInvHeader."No.",SalesCrMemoHeader."No.");
          END;

  }
  CODE
  {
    VAR
      NothingToPostErr@1000 : TextConst 'DAN=Der er intet at bogf�re.;ENU=There is nothing to post.';
      PostingLinesMsg@1001 : TextConst '@@@=Counter;DAN=Linjerne bogf�res          #2######\;ENU=Posting lines              #2######\';
      PostingSalesAndVATMsg@1002 : TextConst '@@@=Counter;DAN=Salg og moms bogf�res      #3######\;ENU=Posting sales and VAT      #3######\';
      PostingCustomersMsg@1003 : TextConst '@@@=Counter;DAN=Debitorerne bogf�res       #4######\;ENU=Posting to customers       #4######\';
      PostingBalAccountMsg@1004 : TextConst '@@@=Counter;DAN=Bogf�rer p� modkonto       #5######;ENU=Posting to bal. account    #5######';
      PostingLines2Msg@1005 : TextConst '@@@=Counter;DAN=Linjer bogf�res            #2######;ENU=Posting lines              #2######';
      InvoiceNoMsg@1006 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = Invoice No.";DAN=%1 %2 -> Faktura %3;ENU=%1 %2 -> Invoice %3';
      CreditMemoNoMsg@1007 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = Credit Memo No.";DAN=%1 %2 -> kreditnota %3;ENU=%1 %2 -> Credit Memo %3';
      DropShipmentErr@1008 : TextConst '@@@="%1 = Line No.";DAN=Du kan ikke levere salgsordrelinjen %1. Linjen er markeret som en direkte levering og kan endnu ikke knyttes til et k�b.;ENU=You cannot ship sales order line %1. The line is marked as a drop shipment and is not yet associated with a purchase order.';
      ShipmentSameSignErr@1010 : TextConst 'DAN=skal have samme fortegn som salgsleverancen;ENU=must have the same sign as the shipment';
      ShipmentLinesDeletedErr@1011 : TextConst 'DAN=Salgsleverancelinjerne er slettet.;ENU=The shipment lines have been deleted.';
      InvoiceMoreThanShippedErr@1012 : TextConst '@@@="%1 = Order No.";DAN=Du kan ikke fakturere ordre %1 for mere, end der er leveret.;ENU=You cannot invoice more than you have shipped for order %1.';
      VATAmountTxt@1013 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      VATRateTxt@1014 : TextConst '@@@="%1 = VAT Rate";DAN=%1% moms;ENU=%1% VAT';
      BlanketOrderQuantityGreaterThanErr@1015 : TextConst '@@@="%1 = Quantity";DAN=i den tilknyttede rammeordre m� ikke v�re st�rre end %1.;ENU=in the associated blanket order must not be greater than %1';
      BlanketOrderQuantityReducedErr@1016 : TextConst 'DAN=i den tilknyttede rammeordre m� ikke reduceres;ENU=in the associated blanket order must not be reduced';
      ShipInvoiceReceiveErr@1017 : TextConst 'DAN=Tast "Ja" i og/eller Lever og/eller Faktura og/eller Modtag.;ENU=Please enter "Yes" in Ship and/or Invoice and/or Receive.';
      WarehouseRequiredErr@1018 : TextConst '@@@="%1/%2 = Document Type, %3/%4 - Document No.,%5/%6 = Line No.";DAN="Der kr�ves lagerekspedition for %1 = %2, %3 = %4, %5 = %6.";ENU="Warehouse handling is required for %1 = %2, %3 = %4, %5 = %6."';
      ReturnReceiptSameSignErr@1021 : TextConst 'DAN=skal have samme fortegn som returvaremodtagelsen;ENU=must have the same sign as the return receipt';
      ReturnReceiptInvoicedErr@1022 : TextConst '@@@="%1 = Line No., %2 = Document No.";DAN=Linje %1 i returvarekvitteringen %2, som du fors�ger at fakturere, er allerede blevet faktureret.;ENU=Line %1 of the return receipt %2, which you are attempting to invoice, has already been invoiced.';
      ShipmentInvoiceErr@1023 : TextConst '@@@="%1 = Line No., %2 = Document No.";DAN=Linje %1 i leverancen %2, som du fors�ger at fakturere, er allerede blevet faktureret.;ENU=Line %1 of the shipment %2, which you are attempting to invoice, has already been invoiced.';
      QuantityToInvoiceGreaterErr@1024 : TextConst '@@@="%1 = Document No.";DAN=Det antal, som du fors�ger at fakturere, er st�rre end antallet i leverancen %1.;ENU=The quantity you are attempting to invoice is greater than the quantity in shipment %1.';
      DimensionIsBlockedErr@1025 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = Error text";DAN=Kombinationen af dimensioner, der bliver brugt i %1 %2, er sp�rret (Fejl: %3).;ENU=The combination of dimensions used in %1 %2 is blocked (Error: %3).';
      LineDimensionBlockedErr@1026 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = LineNo., %4 = Error text";DAN=Kombinationen af de dimensioner, der bliver brugt i %1 %2, linjenr. %3, er sp�rret (Fejl: %4).;ENU=The combination of dimensions used in %1 %2, line no. %3 is blocked (Error: %4).';
      InvalidDimensionsErr@1027 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = Error text";DAN=De dimensioner, der bliver brugt i %1 %2, er ugyldige (Fejl: %3).;ENU=The dimensions used in %1 %2 are invalid (Error: %3).';
      LineInvalidDimensionsErr@1028 : TextConst '@@@="%1 = Document Type, %2 = Document No, %3 = LineNo., %4 = Error text";DAN=De dimensioner, der bliver brugt i %1 %2 linjenr. %3, er ugyldige (Fejl: %4).;ENU=The dimensions used in %1 %2, line no. %3 are invalid (Error: %4).';
      CannotAssignMoreErr@1029 : TextConst '@@@="%1 = Quantity, %2/%3 = Document Type, %4/%5 - Document No.,%6/%7 = Line No.";DAN="Du kan ikke tildele mere end %1 enheder i %2 = %3, %4 = %5,%6 = %7.";ENU="You cannot assign more than %1 units in %2 = %3, %4 = %5,%6 = %7."';
      MustAssignErr@1030 : TextConst 'DAN=Du skal tildele alle varegebyrer, hvis du fakturerer alt.;ENU=You must assign all item charges, if you invoice everything.';
      Item@1164 : Record 27;
      SalesSetup@1032 : Record 311;
      GLSetup@1033 : Record 98;
      GLEntry@1034 : Record 17;
      TempSalesLineGlobal@1051 : TEMPORARY Record 37;
      xSalesLine@1038 : Record 37;
      SalesLineACY@1039 : Record 37;
      TotalSalesLine@1040 : Record 37;
      TotalSalesLineLCY@1041 : Record 37;
      TempPrepaymentSalesLine@1170 : TEMPORARY Record 37;
      SalesShptHeader@1043 : Record 110;
      SalesInvHeader@1045 : Record 112;
      SalesCrMemoHeader@1047 : Record 114;
      ReturnRcptHeader@1049 : Record 6660;
      PurchRcptHeader@1053 : Record 120;
      PurchRcptLine@1054 : Record 121;
      ItemChargeAssgntSales@1042 : Record 5809;
      TempItemChargeAssgntSales@1037 : TEMPORARY Record 5809;
      SourceCodeSetup@1061 : Record 242;
      Currency@1068 : Record 4;
      WhseRcptHeader@1019 : Record 7316;
      TempWhseRcptHeader@1145 : TEMPORARY Record 7316;
      WhseShptHeader@1148 : Record 7320;
      TempWhseShptHeader@1149 : TEMPORARY Record 7320;
      PostedWhseRcptHeader@1142 : Record 7318;
      PostedWhseRcptLine@1146 : Record 7319;
      PostedWhseShptHeader@1150 : Record 7322;
      PostedWhseShptLine@1151 : Record 7323;
      Location@1080 : Record 14;
      TempHandlingSpecification@1088 : TEMPORARY Record 336;
      TempATOTrackingSpecification@1063 : TEMPORARY Record 336;
      TempTrackingSpecification@1139 : TEMPORARY Record 336;
      TempTrackingSpecificationInv@1160 : TEMPORARY Record 336;
      TempWhseSplitSpecification@1190 : TEMPORARY Record 336;
      TempValueEntryRelation@1140 : TEMPORARY Record 6508;
      JobTaskSalesLine@1167 : Record 37;
      TempICGenJnlLine@2165 : TEMPORARY Record 81;
      TempPrepmtDeductLCYSalesLine@1134 : TEMPORARY Record 37;
      TempSKU@1175 : TEMPORARY Record 5700;
      DeferralPostBuffer@1046 : Record 1706;
      TempDeferralHeader@1009 : TEMPORARY Record 1701;
      TempDeferralLine@1035 : TEMPORARY Record 1702;
      GenJnlPostLine@1082 : Codeunit 12;
      ResJnlPostLine@1083 : Codeunit 212;
      ItemJnlPostLine@1085 : Codeunit 22;
      ReserveSalesLine@1086 : Codeunit 99000832;
      IdentityManagement@1044 : Codeunit 9801;
      ApprovalsMgmt@1165 : Codeunit 1535;
      ItemTrackingMgt@1196 : Codeunit 6500;
      WhseJnlPostLine@1141 : Codeunit 7301;
      WhsePostRcpt@1152 : Codeunit 5760;
      WhsePostShpt@1153 : Codeunit 5763;
      PurchPost@1159 : Codeunit 90;
      CostCalcMgt@1163 : Codeunit 5836;
      JobPostLine@1166 : Codeunit 1001;
      ServItemMgt@1055 : Codeunit 5920;
      AsmPost@1067 : Codeunit 900;
      DeferralUtilities@1048 : Codeunit 1720;
      OIOXMLCheckSalesHeader@1060000 : Codeunit 13602;
      Window@1097 : Dialog;
      UseDate@1099 : Date;
      GenJnlLineDocNo@1101 : Code[20];
      GenJnlLineExtDocNo@1102 : Code[35];
      SrcCode@1103 : Code[10];
      GenJnlLineDocType@1104 : Integer;
      ItemLedgShptEntryNo@1106 : Integer;
      FALineNo@1108 : Integer;
      RoundingLineNo@1109 : Integer;
      DeferralLineNo@1050 : Integer;
      InvDefLineNo@1058 : Integer;
      RemQtyToBeInvoiced@1111 : Decimal;
      RemQtyToBeInvoicedBase@1112 : Decimal;
      RemAmt@1136 : Decimal;
      RemDiscAmt@1137 : Decimal;
      TotalChargeAmt@1056 : Decimal;
      TotalChargeAmtLCY@1052 : Decimal;
      LastLineRetrieved@1116 : Boolean;
      RoundingLineInserted@1117 : Boolean;
      DropShipOrder@1119 : Boolean;
      CannotAssignInvoicedErr@1127 : TextConst '@@@="%1 = Sales Line, %2/%3 = Document Type, %4/%5 - Document No.,%6/%7 = Line No.";DAN="Du kan ikke tildele varegebyrer til %1 %2 = %3,%4 = %5, %6 = %7, fordi det er blevet faktureret.";ENU="You cannot assign item charges to the %1 %2 = %3,%4 = %5, %6 = %7, because it has been invoiced."';
      InvoiceMoreThanReceivedErr@1094 : TextConst '@@@="%1 = Order No.";DAN=Du kan ikke fakturere mere end du har modtaget for returvareordren %1.;ENU=You cannot invoice more than you have received for return order %1.';
      ReturnReceiptLinesDeletedErr@1095 : TextConst 'DAN=Returvaremodtagelseslinjerne er blevet slettet.;ENU=The return receipt lines have been deleted.';
      InvoiceGreaterThanReturnReceiptErr@1130 : TextConst '@@@="%1 = Receipt No.";DAN=Det antal, som du fors�ger at fakturere, er st�rre end antallet p� returvarekvitteringen %1.;ENU=The quantity you are attempting to invoice is greater than the quantity in return receipt %1.';
      ItemJnlRollRndg@1135 : Boolean;
      RelatedItemLedgEntriesNotFoundErr@1129 : TextConst 'DAN=Relaterede vareposter blev ikke fundet.;ENU=Related item ledger entries cannot be found.';
      ItemTrackingWrongSignErr@1147 : TextConst 'DAN=Signering af varesporing er ugyldig.;ENU=Item Tracking is signed wrongly.';
      ItemTrackingMismatchErr@1143 : TextConst 'DAN=Varesporing stemmer ikke overens.;ENU=Item Tracking does not match.';
      WhseShip@1110 : Boolean;
      WhseReceive@1154 : Boolean;
      InvtPickPutaway@1155 : Boolean;
      PostingDateNotAllowedErr@1157 : TextConst 'DAN=er ikke inden for den tilladte bogf�ringsperiode;ENU=is not within your range of allowed posting dates';
      ItemTrackQuantityMismatchErr@1066 : TextConst '@@@="%1 = Quantity";DAN=%1 stemmer ikke overens med det antal, der er angivet i varesporing.;ENU=The %1 does not match the quantity defined in item tracking.';
      CannotBeGreaterThanErr@1084 : TextConst '@@@="%1 = Amount";DAN=m� ikke v�re st�rre end %1.;ENU=cannot be more than %1.';
      CannotBeSmallerThanErr@1105 : TextConst '@@@="%1 = Amount";DAN=skal mindst v�re %1.;ENU=must be at least %1.';
      JobContractLine@1172 : Boolean;
      GLSetupRead@1133 : Boolean;
      ItemTrkgAlreadyOverruled@1059 : Boolean;
      PrepAmountToDeductToBigErr@1076 : TextConst '@@@="%1 = Prepmt Amt to Deduct, %2 = Max Amount";DAN=Den samlede %1 m� ikke v�re mere end %2.;ENU=The total %1 cannot be more than %2.';
      PrepAmountToDeductToSmallErr@1091 : TextConst '@@@="%1 = Prepmt Amt to Deduct, %2 = Max Amount";DAN=Den samlede %1 skal mindst v�re %2.;ENU=The total %1 must be at least %2.';
      MustAssignItemChargeErr@1102601000 : TextConst '@@@="%1 = Item Charge No.";DAN=Du skal angive varegebyr %1, hvis du vil fakturere det.;ENU=You must assign item charge %1 if you want to invoice it.';
      CannotInvoiceItemChargeErr@1102601001 : TextConst '@@@="%1 = Item Charge No.";DAN=Du kan ikke fakturere varegebyr %1, da der ikke findes en varepost, som det kan tilknyttes.;ENU=You can not invoice item charge %1 because there is no item ledger entry to assign it to.';
      SalesLinesProcessed@1072 : Boolean;
      AssemblyCheckProgressMsg@1073 : TextConst '@@@="%1 = Text, %2 = Progress bar";DAN=#1#################################\\Kontrollerer montage #2###########;ENU=#1#################################\\Checking Assembly #2###########';
      AssemblyPostProgressMsg@1090 : TextConst '@@@="%1 = Text, %2 = Progress bar";DAN=#1#################################\\Bogf�rer montage #2###########;ENU=#1#################################\\Posting Assembly #2###########';
      AssemblyFinalizeProgressMsg@1168 : TextConst '@@@="%1 = Text, %2 = Progress bar";DAN=#1#################################\\Fuldf�rer montage #2###########;ENU=#1#################################\\Finalizing Assembly #2###########';
      ReassignItemChargeErr@1171 : TextConst 'DAN=Ordrelinjen, som varegebyret oprindeligt blev knyttet til, er blevet fuldt bogf�rt. Du skal tilknytte varegebyret til den bogf�rte kvittering eller leverance igen.;ENU=The order line that the item charge was originally assigned to has been fully posted. You must reassign the item charge to the posted receipt or shipment.';
      ReservationDisruptedQst@1132 : TextConst '@@@="One or more reservation entries exist for the item with No. = 1000, Location Code = SILVER, Variant Code = NEW which may be disrupted if you post this negative adjustment. Do you want to continue?";DAN="Der findes en eller flere reservationsposter til varen %1 = %2, %3 = %4, %5 = %6, som kan blive afbrudt, hvis du bogf�rer denne nedregulering. Vil du forts�tte?";ENU="One or more reservation entries exist for the item with %1 = %2, %3 = %4, %5 = %6 which may be disrupted if you post this negative adjustment. Do you want to continue?"';
      NotSupportedDocumentTypeErr@1020 : TextConst '@@@="%1 = Document Type";DAN=Dokumenttypen %1 underst�ttes ikke.;ENU=Document type %1 is not supported.';
      PreviewMode@1031 : Boolean;
      NoDeferralScheduleErr@1064 : TextConst '@@@="%1=The item number of the sales transaction line, %2=The Deferral Template Code";DAN=Du skal oprette en periodiseringsplan, fordi du har angivet periodiseringskoden %2 i linje %1.;ENU=You must create a deferral schedule because you have specified the deferral code %2 in line %1.';
      ZeroDeferralAmtErr@1060 : TextConst '@@@="%1=The item number of the sales transaction line, %2=The Deferral Template Code";DAN=Periodiseringsbel�b m� ikke v�re 0. Linje: %1, periodiseringsskabelon: %2.;ENU=Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.';
      DownloadShipmentAlsoQst@1036 : TextConst 'DAN=Du kan downloade bilaget Salg - leverance nu. Du kan ogs� �bne det fra vinduet Bogf�rte salgsleverancer p� et senere tidspunkt.\\Vil du downloade bilaget Salg - leverance nu?;ENU=You can also download the Sales - Shipment document now. Alternatively, you can access it from the Posted Sales Shipments window later.\\Do you want to download the Sales - Shipment document now?';
      InvPickExistsErr@1062 : TextConst 'DAN=Et eller flere relaterede pluk (lager) skal registreres, f�r du kan bogf�re leverancen.;ENU=One or more related inventory picks must be registered before you can post the shipment.';
      InvPutAwayExistsErr@1057 : TextConst 'DAN=En eller flere l�g-p�-lager-aktiviteter skal registreres, f�r du kan bogf�re modtagelsen.;ENU=One or more related inventory put-aways must be registered before you can post the receipt.';
      PostingPreviewNoTok@1257 : TextConst '@@@={Locked};DAN=***;ENU=***';

    LOCAL PROCEDURE CopyToTempLines@180(SalesHeader@1000 : Record 36);
    VAR
      SalesLine@1001 : Record 37;
    BEGIN
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      IF SalesLine.FINDSET THEN
        REPEAT
          TempSalesLineGlobal := SalesLine;
          TempSalesLineGlobal.INSERT;
        UNTIL SalesLine.NEXT = 0;
    END;

    LOCAL PROCEDURE FillTempLines@36(SalesHeader@1000 : Record 36);
    BEGIN
      TempSalesLineGlobal.RESET;
      IF TempSalesLineGlobal.ISEMPTY THEN
        CopyToTempLines(SalesHeader);
    END;

    LOCAL PROCEDURE ModifyTempLine@184(VAR TempSalesLineLocal@1000 : TEMPORARY Record 37);
    VAR
      SalesLine@1001 : Record 37;
    BEGIN
      TempSalesLineLocal.MODIFY;
      SalesLine := TempSalesLineLocal;
      SalesLine.MODIFY;
    END;

    LOCAL PROCEDURE RefreshTempLines@28(SalesHeader@1000 : Record 36);
    BEGIN
      TempSalesLineGlobal.RESET;
      TempSalesLineGlobal.DELETEALL;
      CopyToTempLines(SalesHeader);
    END;

    LOCAL PROCEDURE ResetTempLines@131(VAR TempSalesLineLocal@1000 : TEMPORARY Record 37);
    BEGIN
      TempSalesLineLocal.RESET;
      TempSalesLineLocal.COPY(TempSalesLineGlobal,TRUE);
    END;

    LOCAL PROCEDURE CalcInvoice@145(SalesHeader@1000 : Record 36) NewInvoice : Boolean;
    VAR
      TempSalesLine@1001 : TEMPORARY Record 37;
    BEGIN
      WITH SalesHeader DO BEGIN
        ResetTempLines(TempSalesLine);
        TempSalesLine.SETFILTER(Quantity,'<>0');
        IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
          TempSalesLine.SETFILTER("Qty. to Invoice",'<>0');
        NewInvoice := NOT TempSalesLine.ISEMPTY;
        IF NewInvoice THEN
          CASE "Document Type" OF
            "Document Type"::Order:
              IF NOT Ship THEN BEGIN
                TempSalesLine.SETFILTER("Qty. Shipped Not Invoiced",'<>0');
                NewInvoice := NOT TempSalesLine.ISEMPTY;
              END;
            "Document Type"::"Return Order":
              IF NOT Receive THEN BEGIN
                TempSalesLine.SETFILTER("Return Qty. Rcd. Not Invd.",'<>0');
                NewInvoice := NOT TempSalesLine.ISEMPTY;
              END;
          END;
        EXIT(NewInvoice);
      END;
    END;

    LOCAL PROCEDURE CalcInvDiscount@18(VAR SalesHeader@1000 : Record 36);
    VAR
      SalesHeaderCopy@1005 : Record 36;
      SalesLine@1001 : Record 37;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF NOT (SalesSetup."Calc. Inv. Discount" AND (Status <> Status::Open)) THEN
          EXIT;

        SalesHeaderCopy := SalesHeader;
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        SalesLine.FINDFIRST;
        CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",SalesLine);
        RefreshTempLines(SalesHeader);
        GET("Document Type","No.");
        RestoreSalesHeader(SalesHeader,SalesHeaderCopy);
        IF NOT PreviewMode THEN
          COMMIT;
      END;
    END;

    LOCAL PROCEDURE RestoreSalesHeader@232(VAR SalesHeader@1000 : Record 36;SalesHeaderCopy@1002 : Record 36);
    BEGIN
      WITH SalesHeader DO BEGIN
        Invoice := SalesHeaderCopy.Invoice;
        Receive := SalesHeaderCopy.Receive;
        Ship := SalesHeaderCopy.Ship;
        "Posting No." := SalesHeaderCopy."Posting No.";
        "Shipping No." := SalesHeaderCopy."Shipping No.";
        "Return Receipt No." := SalesHeaderCopy."Return Receipt No.";
      END;
    END;

    LOCAL PROCEDURE CheckAndUpdate@153(VAR SalesHeader@1000 : Record 36);
    VAR
      GenJnlCheckLine@1001 : Codeunit 11;
      ModifyHeader@1003 : Boolean;
    BEGIN
      WITH SalesHeader DO BEGIN
        // Check
        CheckMandatoryHeaderFields(SalesHeader);
        OIOXMLCheckSalesHeader.RUN(SalesHeader);
        IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
          FIELDERROR("Posting Date",PostingDateNotAllowedErr);

        SetPostingFlags(SalesHeader);
        InitProgressWindow(SalesHeader);

        InvtPickPutaway := "Posting from Whse. Ref." <> 0;
        "Posting from Whse. Ref." := 0;

        CheckDim(SalesHeader);

        CheckPostRestrictions(SalesHeader);

        IF Invoice THEN
          Invoice := CalcInvoice(SalesHeader);

        IF Invoice THEN
          CopyAndCheckItemCharge(SalesHeader);

        IF Invoice AND NOT IsCreditDocType THEN
          TESTFIELD("Due Date");

        IF Ship THEN BEGIN
          InitPostATOs(SalesHeader);
          Ship := CheckTrackingAndWarehouseForShip(SalesHeader);
          IF NOT InvtPickPutaway THEN
            IF CheckIfInvPickExists(SalesHeader) THEN
              ERROR(InvPickExistsErr);
        END;

        IF Receive THEN BEGIN
          Receive := CheckTrackingAndWarehouseForReceive(SalesHeader);
          IF NOT InvtPickPutaway THEN
            IF CheckIfInvPutawayExists THEN
              ERROR(InvPutAwayExistsErr);
        END;

        IF NOT (Ship OR Invoice OR Receive) THEN
          ERROR(NothingToPostErr);

        IF ("Shipping Advice" = "Shipping Advice"::Complete) AND Ship THEN
          CheckShippingAdvice;

        OnAfterCheckSalesDoc(SalesHeader);

        // Update
        IF Invoice THEN
          CreatePrepaymentLines(SalesHeader,TempPrepaymentSalesLine,TRUE);

        ModifyHeader := UpdatePostingNos(SalesHeader);

        DropShipOrder := UpdateAssosOrderPostingNos(SalesHeader);

        OnBeforePostCommitSalesDoc(SalesHeader,GenJnlPostLine,PreviewMode,ModifyHeader);
        IF NOT PreviewMode AND ModifyHeader THEN BEGIN
          MODIFY;
          COMMIT;
        END;

        CalcInvDiscount(SalesHeader);
        ReleaseSalesDocument(SalesHeader);

        IF Ship OR Receive THEN
          ArchiveUnpostedOrder(SalesHeader);

        CheckICPartnerBlocked(SalesHeader);
        SendICDocument(SalesHeader,ModifyHeader);
        UpdateHandledICInboxTransaction(SalesHeader);

        LockTables;

        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup.Sales;

        InsertPostedHeaders(SalesHeader);

        UpdateIncomingDocument("Incoming Document Entry No.","Posting Date",GenJnlLineDocNo);
      END;
    END;

    LOCAL PROCEDURE PostSalesLine@161(SalesHeader@1000 : Record 36;VAR SalesLine@1001 : Record 37;VAR EverythingInvoiced@1004 : Boolean;VAR TempInvoicePostBuffer@1017 : TEMPORARY Record 49;VAR TempVATAmountLine@1005 : TEMPORARY Record 290;VAR TempVATAmountLineRemainder@1006 : TEMPORARY Record 290;VAR TempItemLedgEntryNotInvoiced@1007 : TEMPORARY Record 32;HasATOShippedNotInvoiced@1008 : Boolean;VAR TempDropShptPostBuffer@1009 : TEMPORARY Record 223;VAR ICGenJnlLineNo@1010 : Integer;VAR TempServiceItem2@1012 : TEMPORARY Record 5940;VAR TempServiceItemComp2@1013 : TEMPORARY Record 5941);
    VAR
      SalesInvLine@1014 : Record 113;
      SalesCrMemoLine@1015 : Record 115;
      TempPostedATOLink@1003 : TEMPORARY Record 914;
      InvoicePostBuffer@1016 : Record 49;
      CostBaseAmount@1002 : Decimal;
    BEGIN
      WITH SalesLine DO BEGIN
        IF Type = Type::Item THEN
          CostBaseAmount := "Line Amount";
        IF "Qty. per Unit of Measure" = 0 THEN
          "Qty. per Unit of Measure" := 1;

        TestSalesLine(SalesHeader,SalesLine);

        TempPostedATOLink.RESET;
        TempPostedATOLink.DELETEALL;
        IF SalesHeader.Ship THEN
          PostATO(SalesHeader,SalesLine,TempPostedATOLink);

        UpdateSalesLineBeforePost(SalesHeader,SalesLine);

        TestUpdatedSalesLine(SalesLine);

        IF "Qty. to Invoice" + "Quantity Invoiced" <> Quantity THEN
          EverythingInvoiced := FALSE;

        IF Quantity <> 0 THEN
          DivideAmount(SalesHeader,SalesLine,1,"Qty. to Invoice",TempVATAmountLine,TempVATAmountLineRemainder);

        CheckItemReservDisruption(SalesLine);
        RoundAmount(SalesHeader,SalesLine,"Qty. to Invoice");

        IF NOT IsCreditDocType THEN BEGIN
          ReverseAmount(SalesLine);
          ReverseAmount(SalesLineACY);
        END;

        RemQtyToBeInvoiced := "Qty. to Invoice";
        RemQtyToBeInvoicedBase := "Qty. to Invoice (Base)";

        PostItemTrackingLine(SalesHeader,SalesLine,TempItemLedgEntryNotInvoiced,HasATOShippedNotInvoiced);

        CASE Type OF
          Type::"G/L Account":
            PostGLAccICLine(SalesHeader,SalesLine,ICGenJnlLineNo);
          Type::Item:
            PostItemLine(SalesHeader,SalesLine,TempDropShptPostBuffer,TempPostedATOLink);
          Type::Resource:
            PostResJnlLine(SalesHeader,SalesLine,JobTaskSalesLine);
          Type::"Charge (Item)":
            PostItemChargeLine(SalesHeader,SalesLine);
        END;

        IF (Type >= Type::"G/L Account") AND ("Qty. to Invoice" <> 0) THEN BEGIN
          AdjustPrepmtAmountLCY(SalesHeader,SalesLine);
          FillInvoicePostingBuffer(SalesHeader,SalesLine,SalesLineACY,TempInvoicePostBuffer,InvoicePostBuffer);
          InsertPrepmtAdjInvPostingBuf(SalesHeader,SalesLine,TempInvoicePostBuffer,InvoicePostBuffer);
        END;

        IF NOT ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) THEN
          TESTFIELD("Job No.",'');

        IF (SalesShptHeader."No." <> '') AND ("Shipment No." = '') AND
           NOT RoundingLineInserted AND NOT "Prepayment Line"
        THEN
          InsertShipmentLine(SalesHeader,SalesShptHeader,SalesLine,CostBaseAmount,TempServiceItem2,TempServiceItemComp2);

        IF (ReturnRcptHeader."No." <> '') AND ("Return Receipt No." = '') AND
           NOT RoundingLineInserted
        THEN
          InsertReturnReceiptLine(ReturnRcptHeader,SalesLine,CostBaseAmount);

        IF SalesHeader.Invoice THEN
          IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order,SalesHeader."Document Type"::Invoice] THEN BEGIN
            SalesInvLine.InitFromSalesLine(SalesInvHeader,xSalesLine);
            ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,SalesInvLine.RowID1);
            OnBeforeSalesInvLineInsert(SalesInvLine,SalesInvHeader,xSalesLine);
            SalesInvLine.INSERT(TRUE);
            OnAfterSalesInvLineInsert(SalesInvLine,SalesInvHeader,xSalesLine,ItemLedgShptEntryNo,WhseShip,WhseReceive);
            CreatePostedDeferralScheduleFromSalesDoc(xSalesLine,SalesInvLine.GetDocumentType,
              SalesInvHeader."No.",SalesInvLine."Line No.",SalesInvHeader."Posting Date");
          END ELSE BEGIN
            SalesCrMemoLine.InitFromSalesLine(SalesCrMemoHeader,xSalesLine);
            ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,SalesCrMemoLine.RowID1);
            OnBeforeSalesCrMemoLineInsert(SalesCrMemoLine,SalesCrMemoHeader,xSalesLine);
            SalesCrMemoLine.INSERT(TRUE);
            OnAfterSalesCrMemoLineInsert(SalesCrMemoLine,SalesCrMemoHeader,SalesHeader,xSalesLine);
            CreatePostedDeferralScheduleFromSalesDoc(xSalesLine,SalesCrMemoLine.GetDocumentType,
              SalesCrMemoHeader."No.",SalesCrMemoLine."Line No.",SalesCrMemoHeader."Posting Date");
          END;
      END;
    END;

    LOCAL PROCEDURE PostGLAndCustomer@164(SalesHeader@1000 : Record 36;VAR TempInvoicePostBuffer@1001 : TEMPORARY Record 49;VAR CustLedgEntry@1002 : Record 21);
    BEGIN
      OnBeforePostGLAndCustomer(SalesHeader,TempInvoicePostBuffer,CustLedgEntry);

      WITH SalesHeader DO BEGIN
        // Post sales and VAT to G/L entries from posting buffer
        PostInvoicePostBuffer(SalesHeader,TempInvoicePostBuffer);

        // Post customer entry
        IF GUIALLOWED THEN
          Window.UPDATE(4,1);
        PostCustomerEntry(
          SalesHeader,TotalSalesLine,TotalSalesLineLCY,GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);

        UpdateSalesHeader(CustLedgEntry);

        // Balancing account
        IF "Bal. Account No." <> '' THEN BEGIN
          IF GUIALLOWED THEN
            Window.UPDATE(5,1);
          PostBalancingEntry(
            SalesHeader,TotalSalesLine,TotalSalesLineLCY,GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);
        END;
      END;

      OnAfterPostGLAndCustomer(SalesHeader,GenJnlPostLine,TotalSalesLine,TotalSalesLineLCY);
    END;

    LOCAL PROCEDURE PostGLAccICLine@160(SalesHeader@1000 : Record 36;SalesLine@1003 : Record 37;VAR ICGenJnlLineNo@1002 : Integer);
    VAR
      GLAcc@1001 : Record 15;
    BEGIN
      IF (SalesLine."No." <> '') AND NOT SalesLine."System-Created Entry" THEN BEGIN
        GLAcc.GET(SalesLine."No.");
        GLAcc.TESTFIELD("Direct Posting",TRUE);
        IF (SalesLine."IC Partner Code" <> '') AND SalesHeader.Invoice THEN
          InsertICGenJnlLine(SalesHeader,xSalesLine,ICGenJnlLineNo);
      END;
    END;

    LOCAL PROCEDURE PostItemLine@170(SalesHeader@1000 : Record 36;VAR SalesLine@1001 : Record 37;VAR TempDropShptPostBuffer@1002 : TEMPORARY Record 223;VAR TempPostedATOLink@1003 : TEMPORARY Record 914);
    VAR
      DummyTrackingSpecification@1004 : Record 336;
      SalesLineToShip@1007 : Record 37;
      QtyToInvoice@1005 : Decimal;
      QtyToInvoiceBase@1006 : Decimal;
    BEGIN
      ItemLedgShptEntryNo := 0;
      QtyToInvoice := RemQtyToBeInvoiced;
      QtyToInvoiceBase := RemQtyToBeInvoicedBase;

      WITH SalesHeader DO BEGIN
        IF (SalesLine."Qty. to Ship" <> 0) AND (SalesLine."Purch. Order Line No." <> 0) THEN BEGIN
          TempDropShptPostBuffer."Order No." := SalesLine."Purchase Order No.";
          TempDropShptPostBuffer."Order Line No." := SalesLine."Purch. Order Line No.";
          TempDropShptPostBuffer.Quantity := -SalesLine."Qty. to Ship";
          TempDropShptPostBuffer."Quantity (Base)" := -SalesLine."Qty. to Ship (Base)";
          TempDropShptPostBuffer."Item Shpt. Entry No." :=
            PostAssocItemJnlLine(SalesHeader,SalesLine,TempDropShptPostBuffer.Quantity,TempDropShptPostBuffer."Quantity (Base)");
          TempDropShptPostBuffer.INSERT;
          SalesLine."Appl.-to Item Entry" := TempDropShptPostBuffer."Item Shpt. Entry No.";
        END;

        CLEAR(TempPostedATOLink);
        TempPostedATOLink.SETRANGE("Order No.",SalesLine."Document No.");
        TempPostedATOLink.SETRANGE("Order Line No.",SalesLine."Line No.");
        IF TempPostedATOLink.FINDFIRST THEN
          PostATOAssocItemJnlLine(SalesHeader,SalesLine,TempPostedATOLink,QtyToInvoice,QtyToInvoiceBase);

        IF QtyToInvoice <> 0 THEN
          ItemLedgShptEntryNo :=
            PostItemJnlLine(
              SalesHeader,SalesLine,
              QtyToInvoice,QtyToInvoiceBase,
              QtyToInvoice,QtyToInvoiceBase,
              0,'',DummyTrackingSpecification,FALSE);

        SalesLineToShip := SalesLine;

        // Invoice discount amount is also included in expected sales amount posted for shipment or return receipt.
        IF QtyToInvoice <> 0 THEN
          SalesLineToShip."Inv. Discount Amount" :=
            ROUND(SalesLineToShip.Quantity * SalesLineToShip."Inv. Discount Amount" / QtyToInvoice,
              Currency."Amount Rounding Precision");

        IF SalesLineToShip.IsCreditDocType THEN BEGIN
          IF ABS(SalesLineToShip."Return Qty. to Receive") > ABS(QtyToInvoice) THEN
            ItemLedgShptEntryNo :=
              PostItemJnlLine(
                SalesHeader,SalesLineToShip,
                SalesLineToShip."Return Qty. to Receive" - QtyToInvoice,
                SalesLineToShip."Return Qty. to Receive (Base)" - QtyToInvoiceBase,
                0,0,0,'',DummyTrackingSpecification,FALSE);
        END ELSE BEGIN
          IF ABS(SalesLineToShip."Qty. to Ship") > ABS(QtyToInvoice) + ABS(TempPostedATOLink."Assembled Quantity") THEN
            ItemLedgShptEntryNo :=
              PostItemJnlLine(
                SalesHeader,SalesLineToShip,
                SalesLineToShip."Qty. to Ship" - TempPostedATOLink."Assembled Quantity" - QtyToInvoice,
                SalesLineToShip."Qty. to Ship (Base)" - TempPostedATOLink."Assembled Quantity (Base)" - QtyToInvoiceBase,
                0,0,0,'',DummyTrackingSpecification,FALSE);
        END;
      END;
    END;

    LOCAL PROCEDURE PostItemChargeLine@172(SalesHeader@1001 : Record 36;SalesLine@1002 : Record 37);
    VAR
      SalesLineBackup@1000 : Record 37;
    BEGIN
      IF NOT (SalesHeader.Invoice AND (SalesLine."Qty. to Invoice" <> 0)) THEN
        EXIT;

      ItemJnlRollRndg := TRUE;
      SalesLineBackup.COPY(SalesLine);
      IF FindTempItemChargeAssgntSales(SalesLineBackup."Line No.") THEN
        REPEAT
          CASE TempItemChargeAssgntSales."Applies-to Doc. Type" OF
            TempItemChargeAssgntSales."Applies-to Doc. Type"::Shipment:
              BEGIN
                PostItemChargePerShpt(SalesHeader,SalesLineBackup);
                TempItemChargeAssgntSales.MARK(TRUE);
              END;
            TempItemChargeAssgntSales."Applies-to Doc. Type"::"Return Receipt":
              BEGIN
                PostItemChargePerRetRcpt(SalesHeader,SalesLineBackup);
                TempItemChargeAssgntSales.MARK(TRUE);
              END;
            TempItemChargeAssgntSales."Applies-to Doc. Type"::Order,
            TempItemChargeAssgntSales."Applies-to Doc. Type"::Invoice,
            TempItemChargeAssgntSales."Applies-to Doc. Type"::"Return Order",
            TempItemChargeAssgntSales."Applies-to Doc. Type"::"Credit Memo":
              CheckItemCharge(TempItemChargeAssgntSales);
          END;
        UNTIL TempItemChargeAssgntSales.NEXT = 0;
    END;

    LOCAL PROCEDURE PostItemTrackingLine@162(SalesHeader@1000 : Record 36;SalesLine@1001 : Record 37;VAR TempItemLedgEntryNotInvoiced@1004 : TEMPORARY Record 32;HasATOShippedNotInvoiced@1005 : Boolean);
    VAR
      TempTrackingSpecification@1003 : TEMPORARY Record 336;
      TrackingSpecificationExists@1002 : Boolean;
    BEGIN
      IF SalesLine."Prepayment Line" THEN
        EXIT;

      IF SalesHeader.Invoice THEN
        IF SalesLine."Qty. to Invoice" = 0 THEN
          TrackingSpecificationExists := FALSE
        ELSE
          TrackingSpecificationExists :=
            ReserveSalesLine.RetrieveInvoiceSpecification(SalesLine,TempTrackingSpecification);

      PostItemTracking(
        SalesHeader,SalesLine,TrackingSpecificationExists,TempTrackingSpecification,
        TempItemLedgEntryNotInvoiced,HasATOShippedNotInvoiced);

      IF TrackingSpecificationExists THEN
        SaveInvoiceSpecification(TempTrackingSpecification);
    END;

    LOCAL PROCEDURE PostItemJnlLine@2(SalesHeader@1017 : Record 36;SalesLine@1000 : Record 37;QtyToBeShipped@1001 : Decimal;QtyToBeShippedBase@1002 : Decimal;QtyToBeInvoiced@1003 : Decimal;QtyToBeInvoicedBase@1004 : Decimal;ItemLedgShptEntryNo@1005 : Integer;ItemChargeNo@1006 : Code[20];TrackingSpecification@1009 : Record 336;IsATO@1007 : Boolean) : Integer;
    VAR
      ItemJnlLine@1010 : Record 83;
      TempWhseJnlLine@1012 : TEMPORARY Record 7311;
      TempWhseTrackingSpecification@1008 : TEMPORARY Record 336;
      OriginalItemJnlLine@1013 : Record 83;
      CurrExchRate@1015 : Record 330;
      PostWhseJnlLine@1011 : Boolean;
      CheckApplFromItemEntry@1014 : Boolean;
      InvDiscAmountPerShippedQty@1016 : Decimal;
    BEGIN
      IF NOT ItemJnlRollRndg THEN BEGIN
        RemAmt := 0;
        RemDiscAmt := 0;
      END;

      WITH ItemJnlLine DO BEGIN
        INIT;
        CopyFromSalesHeader(SalesHeader);
        CopyFromSalesLine(SalesLine);
        "Country/Region Code" := GetCountryCode(SalesLine,SalesHeader);

        CopyTrackingFromSpec(TrackingSpecification);
        "Item Shpt. Entry No." := ItemLedgShptEntryNo;

        Quantity := -QtyToBeShipped;
        "Quantity (Base)" := -QtyToBeShippedBase;
        "Invoiced Quantity" := -QtyToBeInvoiced;
        "Invoiced Qty. (Base)" := -QtyToBeInvoicedBase;

        IF QtyToBeShipped = 0 THEN
          IF SalesLine.IsCreditDocType THEN
            CopyDocumentFields(
              "Document Type"::"Sales Credit Memo",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,SalesHeader."Posting No. Series")
          ELSE
            CopyDocumentFields(
              "Document Type"::"Sales Invoice",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,SalesHeader."Posting No. Series")
        ELSE BEGIN
          IF SalesLine.IsCreditDocType THEN
            CopyDocumentFields(
              "Document Type"::"Sales Return Receipt",
              ReturnRcptHeader."No.",ReturnRcptHeader."External Document No.",SrcCode,ReturnRcptHeader."No. Series")
          ELSE
            CopyDocumentFields(
              "Document Type"::"Sales Shipment",SalesShptHeader."No.",SalesShptHeader."External Document No.",SrcCode,
              SalesShptHeader."No. Series");
          IF QtyToBeInvoiced <> 0 THEN BEGIN
            IF "Document No." = '' THEN
              IF SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo" THEN
                CopyDocumentFields(
                  "Document Type"::"Sales Credit Memo",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,SalesHeader."Posting No. Series")
              ELSE
                CopyDocumentFields(
                  "Document Type"::"Sales Invoice",GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,SalesHeader."Posting No. Series");
            "Posting No. Series" := SalesHeader."Posting No. Series";
          END;
        END;

        IF QtyToBeInvoiced <> 0 THEN
          "Invoice No." := GenJnlLineDocNo;

        "Assemble to Order" := IsATO;
        IF "Assemble to Order" THEN
          "Applies-to Entry" := SalesLine.FindOpenATOEntry('','')
        ELSE
          "Applies-to Entry" := SalesLine."Appl.-to Item Entry";

        IF ItemChargeNo <> '' THEN BEGIN
          "Item Charge No." := ItemChargeNo;
          SalesLine."Qty. to Invoice" := QtyToBeInvoiced;
        END ELSE
          "Applies-from Entry" := SalesLine."Appl.-from Item Entry";

        IF QtyToBeInvoiced <> 0 THEN BEGIN
          Amount := -(SalesLine.Amount * (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemAmt);
          IF SalesHeader."Prices Including VAT" THEN
            "Discount Amount" :=
              -((SalesLine."Line Discount Amount" + SalesLine."Inv. Discount Amount") /
                (1 + SalesLine."VAT %" / 100) * (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemDiscAmt)
          ELSE
            "Discount Amount" :=
              -((SalesLine."Line Discount Amount" + SalesLine."Inv. Discount Amount") *
                (QtyToBeInvoiced / SalesLine."Qty. to Invoice") - RemDiscAmt);
          RemAmt := Amount - ROUND(Amount);
          RemDiscAmt := "Discount Amount" - ROUND("Discount Amount");
          Amount := ROUND(Amount);
          "Discount Amount" := ROUND("Discount Amount");
        END ELSE BEGIN
          InvDiscAmountPerShippedQty := ABS(SalesLine."Inv. Discount Amount") * QtyToBeShipped / SalesLine.Quantity;
          Amount := QtyToBeShipped * SalesLine."Unit Price";
          IF SalesHeader."Prices Including VAT" THEN
            Amount :=
              -((Amount * (1 - SalesLine."Line Discount %" / 100) - InvDiscAmountPerShippedQty) /
                (1 + SalesLine."VAT %" / 100) - RemAmt)
          ELSE
            Amount :=
              -(Amount * (1 - SalesLine."Line Discount %" / 100) - InvDiscAmountPerShippedQty - RemAmt);
          RemAmt := Amount - ROUND(Amount);
          IF SalesHeader."Currency Code" <> '' THEN
            Amount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  SalesHeader."Posting Date",SalesHeader."Currency Code",
                  Amount,SalesHeader."Currency Factor"))
          ELSE
            Amount := ROUND(Amount);
        END;

        IF NOT JobContractLine THEN BEGIN
          IF SalesSetup."Exact Cost Reversing Mandatory" AND (SalesLine.Type = SalesLine.Type::Item) THEN
            IF SalesLine.IsCreditDocType THEN
              CheckApplFromItemEntry := SalesLine.Quantity > 0
            ELSE
              CheckApplFromItemEntry := SalesLine.Quantity < 0;

          IF (SalesLine."Location Code" <> '') AND (SalesLine.Type = SalesLine.Type::Item) AND (Quantity <> 0) THEN
            IF ShouldPostWhseJnlLine(SalesLine) THEN BEGIN
              CreateWhseJnlLine(ItemJnlLine,SalesLine,TempWhseJnlLine);
              PostWhseJnlLine := TRUE;
            END;

          IF QtyToBeShippedBase <> 0 THEN BEGIN
            IF SalesLine.IsCreditDocType THEN
              ReserveSalesLine.TransferSalesLineToItemJnlLine(SalesLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,FALSE)
            ELSE
              TransferReservToItemJnlLine(
                SalesLine,ItemJnlLine,-QtyToBeShippedBase,TempTrackingSpecification,CheckApplFromItemEntry);

            IF CheckApplFromItemEntry AND (NOT SalesLine.IsServiceItem) THEN
              SalesLine.TESTFIELD("Appl.-from Item Entry");
          END;

          OriginalItemJnlLine := ItemJnlLine;
          OnBeforeItemJnlPostLine(ItemJnlLine,SalesLine,SalesHeader);
          ItemJnlPostLine.RunWithCheck(ItemJnlLine);

          IF IsATO THEN
            PostItemJnlLineTracking(
              SalesLine,TempWhseTrackingSpecification,PostWhseJnlLine,QtyToBeInvoiced,TempATOTrackingSpecification)
          ELSE
            PostItemJnlLineTracking(SalesLine,TempWhseTrackingSpecification,PostWhseJnlLine,QtyToBeInvoiced,TempHandlingSpecification);
          PostItemJnlLineWhseLine(TempWhseJnlLine,TempWhseTrackingSpecification);

          OnAfterPostItemJnlLineWhseLine(SalesLine,ItemLedgShptEntryNo,WhseShip,WhseReceive);

          IF (SalesLine.Type = SalesLine.Type::Item) AND SalesHeader.Invoice THEN
            PostItemJnlLineItemCharges(SalesHeader,SalesLine,OriginalItemJnlLine,"Item Shpt. Entry No.");
        END;
        EXIT("Item Shpt. Entry No.");
      END;
    END;

    LOCAL PROCEDURE PostItemJnlLineItemCharges@165(SalesHeader@1000 : Record 36;SalesLine@1001 : Record 37;VAR OriginalItemJnlLine@1003 : Record 83;ItemShptEntryNo@1004 : Integer);
    VAR
      ItemChargeSalesLine@1002 : Record 37;
    BEGIN
      WITH SalesLine DO BEGIN
        ClearItemChargeAssgntFilter;
        TempItemChargeAssgntSales.SETCURRENTKEY(
          "Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
        TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type","Document Type");
        TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.","Document No.");
        TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.","Line No.");
        IF TempItemChargeAssgntSales.FINDSET THEN
          REPEAT
            TESTFIELD("Allow Item Charge Assignment");
            GetItemChargeLine(SalesHeader,ItemChargeSalesLine);
            ItemChargeSalesLine.CALCFIELDS("Qty. Assigned");
            IF (ItemChargeSalesLine."Qty. to Invoice" <> 0) OR
               (ABS(ItemChargeSalesLine."Qty. Assigned") < ABS(ItemChargeSalesLine."Quantity Invoiced"))
            THEN BEGIN
              OriginalItemJnlLine."Item Shpt. Entry No." := ItemShptEntryNo;
              PostItemChargePerOrder(SalesHeader,SalesLine,OriginalItemJnlLine,ItemChargeSalesLine);
              TempItemChargeAssgntSales.MARK(TRUE);
            END;
          UNTIL TempItemChargeAssgntSales.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE PostItemJnlLineTracking@166(SalesLine@1000 : Record 37;VAR TempWhseTrackingSpecification@1002 : TEMPORARY Record 336;PostWhseJnlLine@1001 : Boolean;QtyToBeInvoiced@1003 : Decimal;VAR TempTrackingSpec@1004 : TEMPORARY Record 336);
    BEGIN
      IF ItemJnlPostLine.CollectTrackingSpecification(TempTrackingSpec) THEN
        IF TempTrackingSpec.FINDSET THEN
          REPEAT
            TempTrackingSpecification := TempTrackingSpec;
            TempTrackingSpecification.SetSourceFromSalesLine(SalesLine);
            IF TempTrackingSpecification.INSERT THEN;
            IF QtyToBeInvoiced <> 0 THEN BEGIN
              TempTrackingSpecificationInv := TempTrackingSpecification;
              IF TempTrackingSpecificationInv.INSERT THEN;
            END;
            IF PostWhseJnlLine THEN BEGIN
              TempWhseTrackingSpecification := TempTrackingSpecification;
              IF TempWhseTrackingSpecification.INSERT THEN;
            END;
          UNTIL TempTrackingSpec.NEXT = 0;
    END;

    LOCAL PROCEDURE PostItemJnlLineWhseLine@173(VAR TempWhseJnlLine@1000 : TEMPORARY Record 7311;VAR TempWhseTrackingSpecification@1001 : TEMPORARY Record 336);
    VAR
      TempWhseJnlLine2@1002 : TEMPORARY Record 7311;
    BEGIN
      ItemTrackingMgt.SplitWhseJnlLine(TempWhseJnlLine,TempWhseJnlLine2,TempWhseTrackingSpecification,FALSE);
      IF TempWhseJnlLine2.FINDSET THEN
        REPEAT
          WhseJnlPostLine.RUN(TempWhseJnlLine2);
        UNTIL TempWhseJnlLine2.NEXT = 0;
      TempWhseTrackingSpecification.DELETEALL;
    END;

    LOCAL PROCEDURE ShouldPostWhseJnlLine@73(SalesLine@1000 : Record 37) : Boolean;
    BEGIN
      WITH SalesLine DO BEGIN
        GetLocation("Location Code");
        IF (("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) AND
            Location."Directed Put-away and Pick") OR
           (Location."Bin Mandatory" AND NOT (WhseShip OR WhseReceive OR InvtPickPutaway OR "Drop Shipment"))
        THEN
          EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE PostItemChargePerOrder@5801(SalesHeader@1012 : Record 36;SalesLine@1013 : Record 37;ItemJnlLine2@1001 : Record 83;ItemChargeSalesLine@1002 : Record 37);
    VAR
      NonDistrItemJnlLine@1000 : Record 83;
      CurrExchRate@1003 : Record 330;
      QtyToInvoice@1004 : Decimal;
      Factor@1005 : Decimal;
      OriginalAmt@1007 : Decimal;
      OriginalDiscountAmt@1009 : Decimal;
      OriginalQty@1010 : Decimal;
      SignFactor@1006 : Integer;
      TotalChargeAmt2@1008 : Decimal;
      TotalChargeAmtLCY2@1011 : Decimal;
    BEGIN
      WITH TempItemChargeAssgntSales DO BEGIN
        SalesLine.TESTFIELD("Job No.",'');
        SalesLine.TESTFIELD("Allow Item Charge Assignment",TRUE);
        ItemJnlLine2."Document No." := GenJnlLineDocNo;
        ItemJnlLine2."External Document No." := GenJnlLineExtDocNo;
        ItemJnlLine2."Item Charge No." := "Item Charge No.";
        ItemJnlLine2.Description := ItemChargeSalesLine.Description;
        ItemJnlLine2."Unit of Measure Code" := '';
        ItemJnlLine2."Qty. per Unit of Measure" := 1;
        ItemJnlLine2."Applies-from Entry" := 0;
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          QtyToInvoice :=
            CalcQtyToInvoice(SalesLine."Return Qty. to Receive (Base)",SalesLine."Qty. to Invoice (Base)")
        ELSE
          QtyToInvoice :=
            CalcQtyToInvoice(SalesLine."Qty. to Ship (Base)",SalesLine."Qty. to Invoice (Base)");
        IF ItemJnlLine2."Invoiced Quantity" = 0 THEN BEGIN
          ItemJnlLine2."Invoiced Quantity" := ItemJnlLine2.Quantity;
          ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
        END;
        ItemJnlLine2."Document Line No." := ItemChargeSalesLine."Line No.";

        ItemJnlLine2.Amount := "Amount to Assign" * ItemJnlLine2."Invoiced Qty. (Base)" / QtyToInvoice;
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          ItemJnlLine2.Amount := -ItemJnlLine2.Amount;
        ItemJnlLine2."Unit Cost (ACY)" :=
          ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
            Currency."Unit-Amount Rounding Precision");

        TotalChargeAmt2 := TotalChargeAmt2 + ItemJnlLine2.Amount;
        IF SalesHeader."Currency Code" <> '' THEN
          ItemJnlLine2.Amount :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              UseDate,SalesHeader."Currency Code",TotalChargeAmt2 + TotalSalesLine.Amount,SalesHeader."Currency Factor") -
            TotalChargeAmtLCY2 - TotalSalesLineLCY.Amount
        ELSE
          ItemJnlLine2.Amount := TotalChargeAmt2 - TotalChargeAmtLCY2;

        TotalChargeAmtLCY2 := TotalChargeAmtLCY2 + ItemJnlLine2.Amount;
        ItemJnlLine2."Unit Cost" := ROUND(
            ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",GLSetup."Unit-Amount Rounding Precision");
        ItemJnlLine2."Applies-to Entry" := ItemJnlLine2."Item Shpt. Entry No.";

        IF SalesHeader."Currency Code" <> '' THEN
          ItemJnlLine2."Discount Amount" := ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate,SalesHeader."Currency Code",
                ItemChargeSalesLine."Inv. Discount Amount" * ItemJnlLine2."Invoiced Qty. (Base)" /
                ItemChargeSalesLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
                SalesHeader."Currency Factor"),GLSetup."Amount Rounding Precision")
        ELSE
          ItemJnlLine2."Discount Amount" := ROUND(
              ItemChargeSalesLine."Inv. Discount Amount" * ItemJnlLine2."Invoiced Qty. (Base)" /
              ItemChargeSalesLine."Quantity (Base)" * "Qty. to Assign" / QtyToInvoice,
              GLSetup."Amount Rounding Precision");

        IF SalesLine.IsCreditDocType THEN
          ItemJnlLine2."Discount Amount" := -ItemJnlLine2."Discount Amount";
        ItemJnlLine2."Shortcut Dimension 1 Code" := ItemChargeSalesLine."Shortcut Dimension 1 Code";
        ItemJnlLine2."Shortcut Dimension 2 Code" := ItemChargeSalesLine."Shortcut Dimension 2 Code";
        ItemJnlLine2."Dimension Set ID" := ItemChargeSalesLine."Dimension Set ID";
        ItemJnlLine2."Gen. Prod. Posting Group" := ItemChargeSalesLine."Gen. Prod. Posting Group";
      END;

      WITH TempTrackingSpecificationInv DO BEGIN
        RESET;
        SETRANGE("Source Type",DATABASE::"Sales Line");
        SETRANGE("Source ID",TempItemChargeAssgntSales."Applies-to Doc. No.");
        SETRANGE("Source Ref. No.",TempItemChargeAssgntSales."Applies-to Doc. Line No.");
        IF ISEMPTY THEN
          ItemJnlPostLine.RunWithCheck(ItemJnlLine2)
        ELSE BEGIN
          FINDSET;
          NonDistrItemJnlLine := ItemJnlLine2;
          OriginalAmt := NonDistrItemJnlLine.Amount;
          OriginalDiscountAmt := NonDistrItemJnlLine."Discount Amount";
          OriginalQty := NonDistrItemJnlLine."Quantity (Base)";
          IF ("Quantity (Base)" / OriginalQty) > 0 THEN
            SignFactor := 1
          ELSE
            SignFactor := -1;
          REPEAT
            Factor := "Quantity (Base)" / OriginalQty * SignFactor;
            IF ABS("Quantity (Base)") < ABS(NonDistrItemJnlLine."Quantity (Base)") THEN BEGIN
              ItemJnlLine2."Quantity (Base)" := -"Quantity (Base)";
              ItemJnlLine2."Invoiced Qty. (Base)" := ItemJnlLine2."Quantity (Base)";
              ItemJnlLine2.Amount :=
                ROUND(OriginalAmt * Factor,GLSetup."Amount Rounding Precision");
              ItemJnlLine2."Discount Amount" :=
                ROUND(OriginalDiscountAmt * Factor,GLSetup."Amount Rounding Precision");
              ItemJnlLine2."Unit Cost" :=
                ROUND(ItemJnlLine2.Amount / ItemJnlLine2."Invoiced Qty. (Base)",
                  GLSetup."Unit-Amount Rounding Precision") * SignFactor;
              ItemJnlLine2."Item Shpt. Entry No." := "Item Ledger Entry No.";
              ItemJnlLine2."Applies-to Entry" := "Item Ledger Entry No.";
              ItemJnlLine2.CopyTrackingFromSpec(TempTrackingSpecificationInv);
              ItemJnlPostLine.RunWithCheck(ItemJnlLine2);
              ItemJnlLine2."Location Code" := NonDistrItemJnlLine."Location Code";
              NonDistrItemJnlLine."Quantity (Base)" -= ItemJnlLine2."Quantity (Base)";
              NonDistrItemJnlLine.Amount -= ItemJnlLine2.Amount;
              NonDistrItemJnlLine."Discount Amount" -= ItemJnlLine2."Discount Amount";
            END ELSE BEGIN // the last time
              NonDistrItemJnlLine."Quantity (Base)" := -"Quantity (Base)";
              NonDistrItemJnlLine."Invoiced Qty. (Base)" := -"Quantity (Base)";
              NonDistrItemJnlLine."Unit Cost" :=
                ROUND(NonDistrItemJnlLine.Amount / NonDistrItemJnlLine."Invoiced Qty. (Base)",
                  GLSetup."Unit-Amount Rounding Precision");
              NonDistrItemJnlLine."Item Shpt. Entry No." := "Item Ledger Entry No.";
              NonDistrItemJnlLine."Applies-to Entry" := "Item Ledger Entry No.";
              NonDistrItemJnlLine.CopyTrackingFromSpec(TempTrackingSpecificationInv);
              ItemJnlPostLine.RunWithCheck(NonDistrItemJnlLine);
              NonDistrItemJnlLine."Location Code" := ItemJnlLine2."Location Code";
            END;
          UNTIL NEXT = 0;
        END;
      END;
    END;

    LOCAL PROCEDURE PostItemChargePerShpt@5807(SalesHeader@1001 : Record 36;VAR SalesLine@1000 : Record 37);
    VAR
      SalesShptLine@1003 : Record 111;
      TempItemLedgEntry@1010 : TEMPORARY Record 32;
      ItemTrackingMgt@1009 : Codeunit 6500;
      DistributeCharge@1011 : Boolean;
    BEGIN
      IF NOT SalesShptLine.GET(
           TempItemChargeAssgntSales."Applies-to Doc. No.",TempItemChargeAssgntSales."Applies-to Doc. Line No.")
      THEN
        ERROR(ShipmentLinesDeletedErr);
      SalesShptLine.TESTFIELD("Job No.",'');

      IF SalesShptLine."Item Shpt. Entry No." <> 0 THEN
        DistributeCharge :=
          CostCalcMgt.SplitItemLedgerEntriesExist(
            TempItemLedgEntry,-SalesShptLine."Quantity (Base)",SalesShptLine."Item Shpt. Entry No.")
      ELSE BEGIN
        DistributeCharge := TRUE;
        IF NOT ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
             DATABASE::"Sales Shipment Line",0,SalesShptLine."Document No.",
             '',0,SalesShptLine."Line No.",-SalesShptLine."Quantity (Base)")
        THEN
          ERROR(RelatedItemLedgEntriesNotFoundErr);
      END;

      IF DistributeCharge THEN
        PostDistributeItemCharge(
          SalesHeader,SalesLine,TempItemLedgEntry,SalesShptLine."Quantity (Base)",
          TempItemChargeAssgntSales."Qty. to Assign",TempItemChargeAssgntSales."Amount to Assign")
      ELSE
        PostItemCharge(SalesHeader,SalesLine,
          SalesShptLine."Item Shpt. Entry No.",SalesShptLine."Quantity (Base)",
          TempItemChargeAssgntSales."Amount to Assign",
          TempItemChargeAssgntSales."Qty. to Assign");
    END;

    LOCAL PROCEDURE PostItemChargePerRetRcpt@5810(SalesHeader@1001 : Record 36;VAR SalesLine@1000 : Record 37);
    VAR
      ReturnRcptLine@1002 : Record 6661;
      TempItemLedgEntry@1010 : TEMPORARY Record 32;
      ItemTrackingMgt@1009 : Codeunit 6500;
      DistributeCharge@1011 : Boolean;
    BEGIN
      IF NOT ReturnRcptLine.GET(
           TempItemChargeAssgntSales."Applies-to Doc. No.",TempItemChargeAssgntSales."Applies-to Doc. Line No.")
      THEN
        ERROR(ShipmentLinesDeletedErr);
      ReturnRcptLine.TESTFIELD("Job No.",'');

      IF ReturnRcptLine."Item Rcpt. Entry No." <> 0 THEN
        DistributeCharge :=
          CostCalcMgt.SplitItemLedgerEntriesExist(
            TempItemLedgEntry,ReturnRcptLine."Quantity (Base)",ReturnRcptLine."Item Rcpt. Entry No.")
      ELSE BEGIN
        DistributeCharge := TRUE;
        IF NOT ItemTrackingMgt.CollectItemEntryRelation(TempItemLedgEntry,
             DATABASE::"Return Receipt Line",0,ReturnRcptLine."Document No.",
             '',0,ReturnRcptLine."Line No.",ReturnRcptLine."Quantity (Base)")
        THEN
          ERROR(RelatedItemLedgEntriesNotFoundErr);
      END;

      IF DistributeCharge THEN
        PostDistributeItemCharge(
          SalesHeader,SalesLine,TempItemLedgEntry,ReturnRcptLine."Quantity (Base)",
          TempItemChargeAssgntSales."Qty. to Assign",TempItemChargeAssgntSales."Amount to Assign")
      ELSE
        PostItemCharge(SalesHeader,SalesLine,
          ReturnRcptLine."Item Rcpt. Entry No.",ReturnRcptLine."Quantity (Base)",
          TempItemChargeAssgntSales."Amount to Assign",
          TempItemChargeAssgntSales."Qty. to Assign")
    END;

    LOCAL PROCEDURE PostDistributeItemCharge@181(SalesHeader@1000 : Record 36;SalesLine@1001 : Record 37;VAR TempItemLedgEntry@1002 : TEMPORARY Record 32;NonDistrQuantity@1003 : Decimal;NonDistrQtyToAssign@1004 : Decimal;NonDistrAmountToAssign@1005 : Decimal);
    VAR
      Factor@1006 : Decimal;
      QtyToAssign@1007 : Decimal;
      AmountToAssign@1008 : Decimal;
    BEGIN
      IF TempItemLedgEntry.FINDSET THEN
        REPEAT
          Factor := ABS(TempItemLedgEntry.Quantity) / NonDistrQuantity;
          QtyToAssign := NonDistrQtyToAssign * Factor;
          AmountToAssign := ROUND(NonDistrAmountToAssign * Factor,GLSetup."Amount Rounding Precision");
          IF Factor < 1 THEN BEGIN
            PostItemCharge(SalesHeader,SalesLine,
              TempItemLedgEntry."Entry No.",ABS(TempItemLedgEntry.Quantity),
              AmountToAssign,QtyToAssign);
            NonDistrQuantity := NonDistrQuantity - ABS(TempItemLedgEntry.Quantity);
            NonDistrQtyToAssign := NonDistrQtyToAssign - QtyToAssign;
            NonDistrAmountToAssign := NonDistrAmountToAssign - AmountToAssign;
          END ELSE // the last time
            PostItemCharge(SalesHeader,SalesLine,
              TempItemLedgEntry."Entry No.",ABS(TempItemLedgEntry.Quantity),
              NonDistrAmountToAssign,NonDistrQtyToAssign);
        UNTIL TempItemLedgEntry.NEXT = 0
      ELSE
        ERROR(RelatedItemLedgEntriesNotFoundErr);
    END;

    LOCAL PROCEDURE PostAssocItemJnlLine@3(SalesHeader@1002 : Record 36;SalesLine@1003 : Record 37;QtyToBeShipped@1000 : Decimal;QtyToBeShippedBase@1001 : Decimal) : Integer;
    VAR
      ItemJnlLine@1008 : Record 83;
      TempHandlingSpecification2@1005 : TEMPORARY Record 336;
      ItemEntryRelation@1004 : Record 6507;
      PurchOrderHeader@1007 : Record 38;
      PurchOrderLine@1006 : Record 39;
    BEGIN
      PurchOrderHeader.GET(
        PurchOrderHeader."Document Type"::Order,SalesLine."Purchase Order No.");
      PurchOrderLine.GET(
        PurchOrderLine."Document Type"::Order,SalesLine."Purchase Order No.",SalesLine."Purch. Order Line No.");

      WITH ItemJnlLine DO BEGIN
        INIT;
        "Entry Type" := "Entry Type"::Purchase;
        CopyDocumentFields(
          "Document Type"::"Purchase Receipt",PurchOrderHeader."Receiving No.",PurchOrderHeader."No.",SrcCode,
          PurchOrderHeader."Posting No. Series");

        CopyFromPurchHeader(PurchOrderHeader);
        "Posting Date" := SalesHeader."Posting Date";
        "Document Date" := SalesHeader."Document Date";
        CopyFromPurchLine(PurchOrderLine);

        Quantity := QtyToBeShipped;
        "Quantity (Base)" := QtyToBeShippedBase;
        "Invoiced Quantity" := 0;
        "Invoiced Qty. (Base)" := 0;
        "Source Currency Code" := SalesHeader."Currency Code";
        Amount := ROUND(PurchOrderLine.Amount * QtyToBeShipped / PurchOrderLine.Quantity);
        "Discount Amount" := PurchOrderLine."Line Discount Amount";

        "Applies-to Entry" := 0;
      END;

      IF PurchOrderLine."Job No." = '' THEN BEGIN
        TransferReservFromPurchLine(PurchOrderLine,ItemJnlLine,SalesLine,QtyToBeShippedBase);
        OnBeforePostAssocItemJnlLine(ItemJnlLine,PurchOrderLine);
        ItemJnlPostLine.RunWithCheck(ItemJnlLine);

        // Handle Item Tracking
        IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification2) THEN BEGIN
          IF TempHandlingSpecification2.FINDSET THEN
            REPEAT
              TempTrackingSpecification := TempHandlingSpecification2;
              TempTrackingSpecification.SetSourceFromPurchLine(PurchOrderLine);
              IF TempTrackingSpecification.INSERT THEN;
              ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification2);
              ItemEntryRelation.SetSource(DATABASE::"Purch. Rcpt. Line",0,PurchOrderHeader."Receiving No.",PurchOrderLine."Line No.");
              ItemEntryRelation.SetOrderInfo(PurchOrderLine."Document No.",PurchOrderLine."Line No.");
              ItemEntryRelation.INSERT;
            UNTIL TempHandlingSpecification2.NEXT = 0;
          EXIT(0);
        END;
      END;

      EXIT(ItemJnlLine."Item Shpt. Entry No.");
    END;

    LOCAL PROCEDURE ReleaseSalesDocument@19(VAR SalesHeader@1000 : Record 36);
    VAR
      SalesHeaderCopy@1001 : Record 36;
      TempAsmHeader@1005 : TEMPORARY Record 900;
      ReleaseSalesDocument@1006 : Codeunit 414;
      LinesWereModified@1007 : Boolean;
      SavedStatus@1004 : Option;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF NOT (Status = Status::Open) OR (Status = Status::"Pending Prepayment") THEN
          EXIT;

        SalesHeaderCopy := SalesHeader;
        SavedStatus := Status;
        GetOpenLinkedATOs(TempAsmHeader);
        LinesWereModified := ReleaseSalesDocument.ReleaseSalesHeader(SalesHeader,PreviewMode);
        IF LinesWereModified THEN
          RefreshTempLines(SalesHeader);
        TESTFIELD(Status,Status::Released);
        Status := SavedStatus;
        RestoreSalesHeader(SalesHeader,SalesHeaderCopy);
        ReopenAsmOrders(TempAsmHeader);
        IF PreviewMode AND ("Posting No." = '') THEN
          "Posting No." := '***';
        IF NOT PreviewMode THEN BEGIN
          MODIFY;
          COMMIT;
        END;
        Status := Status::Released;
      END;
    END;

    LOCAL PROCEDURE TestSalesLine@147(SalesHeader@1001 : Record 36;SalesLine@1000 : Record 37);
    VAR
      FA@1003 : Record 5600;
      DeprBook@1004 : Record 5611;
      DummyTrackingSpecification@1002 : Record 336;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF SalesLine.Type = SalesLine.Type::Item THEN
          DummyTrackingSpecification.CheckItemTrackingQuantity(
            DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.",
            SalesLine."Qty. to Ship (Base)",SalesLine."Qty. to Invoice (Base)",Ship,Invoice);

        CASE "Document Type" OF
          "Document Type"::Order:
            SalesLine.TESTFIELD("Return Qty. to Receive",0);
          "Document Type"::Invoice:
            BEGIN
              IF SalesLine."Shipment No." = '' THEN
                SalesLine.TESTFIELD("Qty. to Ship",SalesLine.Quantity);
              SalesLine.TESTFIELD("Return Qty. to Receive",0);
              SalesLine.TESTFIELD("Qty. to Invoice",SalesLine.Quantity);
            END;
          "Document Type"::"Return Order":
            SalesLine.TESTFIELD("Qty. to Ship",0);
          "Document Type"::"Credit Memo":
            BEGIN
              IF SalesLine."Return Receipt No." = '' THEN
                SalesLine.TESTFIELD("Return Qty. to Receive",SalesLine.Quantity);
              SalesLine.TESTFIELD("Qty. to Ship",0);
              SalesLine.TESTFIELD("Qty. to Invoice",SalesLine.Quantity);
            END;
        END;
        IF SalesLine.Type = SalesLine.Type::"Charge (Item)" THEN BEGIN
          SalesLine.TESTFIELD(Amount);
          SalesLine.TESTFIELD("Job No.",'');
          SalesLine.TESTFIELD("Job Contract Entry No.",0);
        END;
        IF SalesLine.Type = SalesLine.Type::"Fixed Asset" THEN BEGIN
          SalesLine.TESTFIELD("Job No.",'');
          SalesLine.TESTFIELD("Depreciation Book Code");
          DeprBook.GET(SalesLine."Depreciation Book Code");
          DeprBook.TESTFIELD("G/L Integration - Disposal",TRUE);
          FA.GET(SalesLine."No.");
          FA.TESTFIELD("Budgeted Asset",FALSE);
        END ELSE BEGIN
          SalesLine.TESTFIELD("Depreciation Book Code",'');
          SalesLine.TESTFIELD("Depr. until FA Posting Date",FALSE);
          SalesLine.TESTFIELD("FA Posting Date",0D);
          SalesLine.TESTFIELD("Duplicate in Depreciation Book",'');
          SalesLine.TESTFIELD("Use Duplication List",FALSE);
        END;
        IF NOT ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) THEN
          SalesLine.TESTFIELD("Job No.",'');

        OnAfterTestSalesLine(SalesLine,WhseShip,WhseReceive);
      END;
    END;

    LOCAL PROCEDURE TestUpdatedSalesLine@444(SalesLine@1000 : Record 37);
    BEGIN
      WITH SalesLine DO BEGIN
        IF "Drop Shipment" THEN BEGIN
          IF Type <> Type::Item THEN
            TESTFIELD("Drop Shipment",FALSE);
          IF ("Qty. to Ship" <> 0) AND ("Purch. Order Line No." = 0) THEN
            ERROR(DropShipmentErr,"Line No.");
        END;

        IF Quantity = 0 THEN
          TESTFIELD(Amount,0)
        ELSE BEGIN
          TESTFIELD("No.");
          TESTFIELD(Type);
          TESTFIELD("Gen. Bus. Posting Group");
          TESTFIELD("Gen. Prod. Posting Group");
        END;
      END;
    END;

    LOCAL PROCEDURE UpdatePostingNos@154(VAR SalesHeader@1000 : Record 36) ModifyHeader : Boolean;
    VAR
      NoSeriesMgt@1001 : Codeunit 396;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF Ship AND ("Shipping No." = '') THEN
          IF ("Document Type" = "Document Type"::Order) OR
             (("Document Type" = "Document Type"::Invoice) AND SalesSetup."Shipment on Invoice")
          THEN
            IF NOT PreviewMode THEN BEGIN
              TESTFIELD("Shipping No. Series");
              "Shipping No." := NoSeriesMgt.GetNextNo("Shipping No. Series","Posting Date",TRUE);
              ModifyHeader := TRUE;
            END ELSE
              "Shipping No." := PostingPreviewNoTok;

        IF Receive AND ("Return Receipt No." = '') THEN
          IF ("Document Type" = "Document Type"::"Return Order") OR
             (("Document Type" = "Document Type"::"Credit Memo") AND SalesSetup."Return Receipt on Credit Memo")
          THEN
            IF NOT PreviewMode THEN BEGIN
              TESTFIELD("Return Receipt No. Series");
              "Return Receipt No." := NoSeriesMgt.GetNextNo("Return Receipt No. Series","Posting Date",TRUE);
              ModifyHeader := TRUE;
            END ELSE
              "Return Receipt No." := PostingPreviewNoTok;

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
              "Posting No." := PostingPreviewNoTok;
          END;
        END;
      END;

      OnAfterUpdatePostingNos(SalesHeader,NoSeriesMgt);
    END;

    LOCAL PROCEDURE UpdateAssocOrder@4(VAR TempDropShptPostBuffer@1001 : TEMPORARY Record 223);
    VAR
      PurchOrderHeader@1003 : Record 38;
      PurchOrderLine@1002 : Record 39;
      ReservePurchLine@1000 : Codeunit 99000834;
    BEGIN
      TempDropShptPostBuffer.RESET;
      IF TempDropShptPostBuffer.ISEMPTY THEN
        EXIT;
      CLEAR(PurchOrderHeader);
      TempDropShptPostBuffer.FINDSET;
      REPEAT
        IF PurchOrderHeader."No." <> TempDropShptPostBuffer."Order No." THEN BEGIN
          PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order,TempDropShptPostBuffer."Order No.");
          PurchOrderHeader."Last Receiving No." := PurchOrderHeader."Receiving No.";
          PurchOrderHeader."Receiving No." := '';
          PurchOrderHeader.MODIFY;
          ReservePurchLine.UpdateItemTrackingAfterPosting(PurchOrderHeader);
        END;
        PurchOrderLine.GET(
          PurchOrderLine."Document Type"::Order,
          TempDropShptPostBuffer."Order No.",TempDropShptPostBuffer."Order Line No.");
        PurchOrderLine."Quantity Received" := PurchOrderLine."Quantity Received" + TempDropShptPostBuffer.Quantity;
        PurchOrderLine."Qty. Received (Base)" := PurchOrderLine."Qty. Received (Base)" + TempDropShptPostBuffer."Quantity (Base)";
        PurchOrderLine.InitOutstanding;
        PurchOrderLine.ClearQtyIfBlank;
        PurchOrderLine.InitQtyToReceive;
        PurchOrderLine.MODIFY;
      UNTIL TempDropShptPostBuffer.NEXT = 0;
      TempDropShptPostBuffer.DELETEALL;
    END;

    LOCAL PROCEDURE UpdateAssocLines@5(VAR SalesOrderLine@1000 : Record 37);
    VAR
      PurchOrderLine@1001 : Record 39;
    BEGIN
      PurchOrderLine.GET(
        PurchOrderLine."Document Type"::Order,
        SalesOrderLine."Purchase Order No.",SalesOrderLine."Purch. Order Line No.");
      PurchOrderLine."Sales Order No." := '';
      PurchOrderLine."Sales Order Line No." := 0;
      PurchOrderLine.MODIFY;
      SalesOrderLine."Purchase Order No." := '';
      SalesOrderLine."Purch. Order Line No." := 0;
    END;

    LOCAL PROCEDURE UpdateAssosOrderPostingNos@157(SalesHeader@1000 : Record 36) DropShipment : Boolean;
    VAR
      TempSalesLine@1001 : TEMPORARY Record 37;
      PurchOrderHeader@1005 : Record 38;
      NoSeriesMgt@1002 : Codeunit 396;
      ReleasePurchaseDocument@1003 : Codeunit 415;
    BEGIN
      WITH SalesHeader DO BEGIN
        ResetTempLines(TempSalesLine);
        TempSalesLine.SETFILTER("Purch. Order Line No.",'<>0');
        DropShipment := NOT TempSalesLine.ISEMPTY;

        TempSalesLine.SETFILTER("Qty. to Ship",'<>0');
        IF DropShipment AND Ship THEN
          IF TempSalesLine.FINDSET THEN
            REPEAT
              IF PurchOrderHeader."No." <> TempSalesLine."Purchase Order No." THEN BEGIN
                PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order,TempSalesLine."Purchase Order No.");
                PurchOrderHeader.TESTFIELD("Pay-to Vendor No.");
                PurchOrderHeader.Receive := TRUE;
                ReleasePurchaseDocument.ReleasePurchaseHeader(PurchOrderHeader,PreviewMode);
                IF PurchOrderHeader."Receiving No." = '' THEN BEGIN
                  PurchOrderHeader.TESTFIELD("Receiving No. Series");
                  PurchOrderHeader."Receiving No." :=
                    NoSeriesMgt.GetNextNo(PurchOrderHeader."Receiving No. Series","Posting Date",TRUE);
                  PurchOrderHeader.MODIFY;
                END;
              END;
            UNTIL TempSalesLine.NEXT = 0;

        EXIT(DropShipment);
      END;
    END;

    LOCAL PROCEDURE UpdateAfterPosting@155(SalesHeader@1001 : Record 36);
    VAR
      TempSalesLine@1000 : TEMPORARY Record 37;
    BEGIN
      WITH TempSalesLine DO BEGIN
        ResetTempLines(TempSalesLine);
        SETFILTER("Qty. to Assemble to Order",'<>0');
        IF FINDSET THEN
          REPEAT
            FinalizePostATO(TempSalesLine);
          UNTIL NEXT = 0;

        ResetTempLines(TempSalesLine);
        SETFILTER("Blanket Order Line No.",'<>0');
        IF FINDSET THEN
          REPEAT
            UpdateBlanketOrderLine(TempSalesLine,SalesHeader.Ship,SalesHeader.Receive,SalesHeader.Invoice);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UpdateLastPostingNos@167(VAR SalesHeader@1000 : Record 36);
    BEGIN
      WITH SalesHeader DO BEGIN
        IF Ship THEN BEGIN
          "Last Shipping No." := "Shipping No.";
          "Shipping No." := '';
        END;
        IF Invoice THEN BEGIN
          "Last Posting No." := "Posting No.";
          "Posting No." := '';
        END;
        IF Receive THEN BEGIN
          "Last Return Receipt No." := "Return Receipt No.";
          "Return Receipt No." := '';
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateSalesLineBeforePost@137(SalesHeader@1000 : Record 36;VAR SalesLine@1001 : Record 37);
    BEGIN
      WITH SalesLine DO BEGIN
        IF NOT (SalesHeader.Ship OR RoundingLineInserted) THEN BEGIN
          "Qty. to Ship" := 0;
          "Qty. to Ship (Base)" := 0;
        END;
        IF NOT (SalesHeader.Receive OR RoundingLineInserted) THEN BEGIN
          "Return Qty. to Receive" := 0;
          "Return Qty. to Receive (Base)" := 0;
        END;

        JobContractLine := FALSE;
        IF (Type = Type::Item) OR (Type = Type::"G/L Account") OR (Type = Type::" ") THEN
          IF "Job Contract Entry No." > 0 THEN
            PostJobContractLine(SalesHeader,SalesLine);
        IF Type = Type::Resource THEN
          JobTaskSalesLine := SalesLine;

        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) AND ("Shipment No." <> '') THEN BEGIN
          "Quantity Shipped" := Quantity;
          "Qty. Shipped (Base)" := "Quantity (Base)";
          "Qty. to Ship" := 0;
          "Qty. to Ship (Base)" := 0;
        END;

        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") AND ("Return Receipt No." <> '') THEN BEGIN
          "Return Qty. Received" := Quantity;
          "Return Qty. Received (Base)" := "Quantity (Base)";
          "Return Qty. to Receive" := 0;
          "Return Qty. to Receive (Base)" := 0;
        END;

        IF SalesHeader.Invoice THEN BEGIN
          IF ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice) THEN
            InitQtyToInvoice;
        END ELSE BEGIN
          "Qty. to Invoice" := 0;
          "Qty. to Invoice (Base)" := 0;
        END;

        IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
          GetItem(SalesLine);
          IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT IsShipment THEN
            GetUnitCost;
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateWhseDocuments@163();
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

    LOCAL PROCEDURE DeleteAfterPosting@159(VAR SalesHeader@1000 : Record 36);
    VAR
      SalesCommentLine@1001 : Record 44;
      SalesLine@1003 : Record 37;
      TempSalesLine@1004 : TEMPORARY Record 37;
      WarehouseRequest@1002 : Record 5765;
      CustInvoiceDisc@1005 : Record 19;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF HASLINKS THEN
          DELETELINKS;
        DELETE;
        ReserveSalesLine.DeleteInvoiceSpecFromHeader(SalesHeader);
        DeleteATOLinks(SalesHeader);
        ResetTempLines(TempSalesLine);
        IF TempSalesLine.FINDFIRST THEN
          REPEAT
            IF TempSalesLine."Deferral Code" <> '' THEN
              DeferralUtilities.RemoveOrSetDeferralSchedule(
                '',DeferralUtilities.GetSalesDeferralDocType,'','',TempSalesLine."Document Type",
                TempSalesLine."Document No.",TempSalesLine."Line No.",0,0D,TempSalesLine.Description,'',TRUE);
            IF TempSalesLine.HASLINKS THEN
              TempSalesLine.DELETELINKS;
          UNTIL TempSalesLine.NEXT = 0;

        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        SalesLine.DELETEALL;
        IF IdentityManagement.IsInvAppId AND CustInvoiceDisc.GET("Invoice Disc. Code") THEN
          CustInvoiceDisc.DELETE; // Cleanup of autogenerated cust. invoice discounts

        DeleteItemChargeAssgnt(SalesHeader);
        SalesCommentLine.DeleteComments("Document Type","No.");
        WarehouseRequest.DeleteRequest(DATABASE::"Sales Line","Document Type","No.");
      END;
    END;

    LOCAL PROCEDURE FinalizePosting@156(VAR SalesHeader@1000 : Record 36;EverythingInvoiced@1001 : Boolean;VAR TempDropShptPostBuffer@1002 : TEMPORARY Record 223);
    VAR
      O365CouponClaim@1008 : Record 2115;
      TempSalesLine@1005 : TEMPORARY Record 37;
      GenJnlPostPreview@1006 : Codeunit 19;
      ICInboxOutboxMgt@1003 : Codeunit 427;
      WhseSalesRelease@1004 : Codeunit 5771;
      ArchiveManagement@1007 : Codeunit 5063;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"]) AND
           (NOT EverythingInvoiced)
        THEN BEGIN
          MODIFY;
          InsertTrackingSpecification(SalesHeader);
          PostUpdateOrderLine(SalesHeader);
          UpdateAssocOrder(TempDropShptPostBuffer);
          UpdateWhseDocuments;
          WhseSalesRelease.Release(SalesHeader);
          UpdateItemChargeAssgnt;
        END ELSE BEGIN
          CASE "Document Type" OF
            "Document Type"::Invoice:
              BEGIN
                PostUpdateInvoiceLine;
                InsertTrackingSpecification(SalesHeader);
              END;
            "Document Type"::"Credit Memo":
              BEGIN
                PostUpdateReturnReceiptLine;
                InsertTrackingSpecification(SalesHeader);
              END;
            ELSE BEGIN
              UpdateAssocOrder(TempDropShptPostBuffer);
              IF DropShipOrder THEN
                InsertTrackingSpecification(SalesHeader);

              ResetTempLines(TempSalesLine);
              TempSalesLine.SETFILTER("Purch. Order Line No.",'<>0');
              IF TempSalesLine.FINDSET THEN
                REPEAT
                  UpdateAssocLines(TempSalesLine);
                  TempSalesLine.MODIFY;
                UNTIL TempSalesLine.NEXT = 0;

              ResetTempLines(TempSalesLine);
              TempSalesLine.SETFILTER("Prepayment %",'<>0');
              IF TempSalesLine.FINDSET THEN
                REPEAT
                  DecrementPrepmtAmtInvLCY(
                    TempSalesLine,TempSalesLine."Prepmt. Amount Inv. (LCY)",TempSalesLine."Prepmt. VAT Amount Inv. (LCY)");
                  TempSalesLine.MODIFY;
                UNTIL TempSalesLine.NEXT = 0;
            END;
          END;
          UpdateAfterPosting(SalesHeader);
          UpdateEmailParameters(SalesHeader);
          O365CouponClaim.RedeemCouponsForSalesDocument(SalesHeader);
          UpdateWhseDocuments;
          ArchiveManagement.AutoArchiveSalesDocument(SalesHeader);
          ApprovalsMgmt.DeleteApprovalEntries(RECORDID);
          IF NOT PreviewMode THEN
            DeleteAfterPosting(SalesHeader);
        END;

        InsertValueEntryRelation;
        IF PreviewMode THEN BEGIN
          Window.CLOSE;
          GenJnlPostPreview.ThrowError;
        END;
        IF NOT InvtPickPutaway THEN
          COMMIT;

        Window.CLOSE;
        IF Invoice AND ("Bill-to IC Partner Code" <> '') THEN
          IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN
            ICInboxOutboxMgt.CreateOutboxSalesInvTrans(SalesInvHeader)
          ELSE
            ICInboxOutboxMgt.CreateOutboxSalesCrMemoTrans(SalesCrMemoHeader);

        OnAfterFinalizePosting(SalesHeader,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,ReturnRcptHeader,GenJnlPostLine);

        ClearPostBuffers;
      END;
    END;

    LOCAL PROCEDURE FillInvoicePostingBuffer@5804(SalesHeader@1011 : Record 36;SalesLine@1000 : Record 37;SalesLineACY@1001 : Record 37;VAR TempInvoicePostBuffer@1013 : TEMPORARY Record 49;VAR InvoicePostBuffer@1012 : Record 49);
    VAR
      GenPostingSetup@1006 : Record 252;
      TotalVAT@1005 : Decimal;
      TotalVATACY@1004 : Decimal;
      TotalAmount@1003 : Decimal;
      TotalAmountACY@1002 : Decimal;
      AmtToDefer@1007 : Decimal;
      AmtToDeferACY@1008 : Decimal;
      TotalVATBase@1015 : Decimal;
      TotalVATBaseACY@1014 : Decimal;
      DeferralAccount@1009 : Code[20];
      SalesAccount@1010 : Code[20];
    BEGIN
      GenPostingSetup.GET(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group");

      InvoicePostBuffer.PrepareSales(SalesLine);

      TotalVAT := SalesLine."Amount Including VAT" - SalesLine.Amount;
      TotalVATACY := SalesLineACY."Amount Including VAT" - SalesLineACY.Amount;
      TotalAmount := SalesLine.Amount;
      TotalAmountACY := SalesLineACY.Amount;

      IF SalesLine."Deferral Code" <> '' THEN
        GetAmountsForDeferral(SalesLine,AmtToDefer,AmtToDeferACY,DeferralAccount)
      ELSE BEGIN
        AmtToDefer := 0;
        AmtToDeferACY := 0;
        DeferralAccount := '';
      END;

      IF SalesSetup."Discount Posting" IN
         [SalesSetup."Discount Posting"::"Invoice Discounts",SalesSetup."Discount Posting"::"All Discounts"]
      THEN BEGIN
        CalcInvoiceDiscountPosting(SalesHeader,SalesLine,SalesLineACY,InvoicePostBuffer);
        IF (InvoicePostBuffer.Amount <> 0) OR (InvoicePostBuffer."Amount (ACY)" <> 0) THEN BEGIN
          InvoicePostBuffer.SetAccount(
            GenPostingSetup.GetSalesInvDiscAccount,TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
          UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer,TRUE);
        END;
      END;

      IF SalesSetup."Discount Posting" IN
         [SalesSetup."Discount Posting"::"Line Discounts",SalesSetup."Discount Posting"::"All Discounts"]
      THEN BEGIN
        CalcLineDiscountPosting(SalesHeader,SalesLine,SalesLineACY,InvoicePostBuffer);
        IF (InvoicePostBuffer.Amount <> 0) OR (InvoicePostBuffer."Amount (ACY)" <> 0) THEN BEGIN
          InvoicePostBuffer.SetAccount(
            GenPostingSetup.GetSalesLineDiscAccount,TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
          UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer,TRUE);
        END;
      END;

      // Don't adjust VAT Base Amounts if deferrals are adjusting total amount
      DeferralUtilities.AdjustTotalAmountForDeferrals(SalesLine."Deferral Code",
        AmtToDefer,AmtToDeferACY,TotalAmount,TotalAmountACY,TotalVATBase,TotalVATBaseACY);

      InvoicePostBuffer.SetAmounts(
        TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY,SalesLine."VAT Difference",TotalVATBase,TotalVATBaseACY);

      IF (SalesLine.Type = SalesLine.Type::"G/L Account") OR (SalesLine.Type = SalesLine.Type::"Fixed Asset") THEN
        SalesAccount := SalesLine."No."
      ELSE
        IF SalesLine.IsCreditDocType THEN
          SalesAccount := GenPostingSetup.GetSalesCrMemoAccount
        ELSE
          SalesAccount := GenPostingSetup.GetSalesAccount;
      InvoicePostBuffer.SetAccount(SalesAccount,TotalVAT,TotalVATACY,TotalAmount,TotalAmountACY);
      InvoicePostBuffer."Deferral Code" := SalesLine."Deferral Code";
      OnAfterFillInvoicePostBuffer(InvoicePostBuffer,SalesLine);
      UpdateInvoicePostBuffer(TempInvoicePostBuffer,InvoicePostBuffer,FALSE);
      IF SalesLine."Deferral Code" <> '' THEN
        FillDeferralPostingBuffer(SalesHeader,SalesLine,InvoicePostBuffer,AmtToDefer,AmtToDeferACY,DeferralAccount,SalesAccount);
    END;

    LOCAL PROCEDURE UpdateInvoicePostBuffer@6(VAR TempInvoicePostBuffer@1004 : TEMPORARY Record 49;InvoicePostBuffer@1003 : Record 49;ForceGLAccountType@1000 : Boolean);
    VAR
      RestoreFAType@1002 : Boolean;
    BEGIN
      IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
        FALineNo := FALineNo + 1;
        InvoicePostBuffer."Fixed Asset Line No." := FALineNo;
        IF ForceGLAccountType THEN BEGIN
          RestoreFAType := TRUE;
          InvoicePostBuffer.Type := InvoicePostBuffer.Type::"G/L Account";
        END;
      END;

      TempInvoicePostBuffer.Update(InvoicePostBuffer,InvDefLineNo,DeferralLineNo);

      IF RestoreFAType THEN
        TempInvoicePostBuffer.Type := TempInvoicePostBuffer.Type::"Fixed Asset";
    END;

    LOCAL PROCEDURE InsertPrepmtAdjInvPostingBuf@80(SalesHeader@1003 : Record 36;PrepmtSalesLine@1000 : Record 37;VAR TempInvoicePostBuffer@1005 : TEMPORARY Record 49;InvoicePostBuffer@1004 : Record 49);
    VAR
      SalesPostPrepayments@1002 : Codeunit 442;
      AdjAmount@1001 : Decimal;
    BEGIN
      WITH PrepmtSalesLine DO
        IF "Prepayment Line" THEN
          IF "Prepmt. Amount Inv. (LCY)" <> 0 THEN BEGIN
            AdjAmount := -"Prepmt. Amount Inv. (LCY)";
            InvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
              "No.",AdjAmount,SalesHeader."Currency Code" = '');
            InvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
              SalesPostPrepayments.GetCorrBalAccNo(SalesHeader,AdjAmount > 0),
              -AdjAmount,SalesHeader."Currency Code" = '');
          END ELSE
            IF ("Prepayment %" = 100) AND ("Prepmt. VAT Amount Inv. (LCY)" <> 0) THEN
              InvoicePostBuffer.FillPrepmtAdjBuffer(TempInvoicePostBuffer,InvoicePostBuffer,
                SalesPostPrepayments.GetInvRoundingAccNo(SalesHeader."Customer Posting Group"),
                "Prepmt. VAT Amount Inv. (LCY)",SalesHeader."Currency Code" = '');
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

    LOCAL PROCEDURE DivideAmount@8(SalesHeader@1004 : Record 36;VAR SalesLine@1005 : Record 37;QtyType@1000 : 'General,Invoicing,Shipping';SalesLineQty@1001 : Decimal;VAR TempVATAmountLine@1002 : TEMPORARY Record 290;VAR TempVATAmountLineRemainder@1003 : TEMPORARY Record 290);
    VAR
      OriginalDeferralAmount@1006 : Decimal;
    BEGIN
      IF RoundingLineInserted AND (RoundingLineNo = SalesLine."Line No.") THEN
        EXIT;
      WITH SalesLine DO
        IF (SalesLineQty = 0) OR ("Unit Price" = 0) THEN BEGIN
          "Line Amount" := 0;
          "Line Discount Amount" := 0;
          "VAT Base Amount" := 0;
          Amount := 0;
          "Amount Including VAT" := 0;
        END ELSE BEGIN
          OriginalDeferralAmount := GetDeferralAmount;
          TempVATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0);
          IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
            "VAT %" := TempVATAmountLine."VAT %";
          TempVATAmountLineRemainder := TempVATAmountLine;
          IF NOT TempVATAmountLineRemainder.FIND THEN BEGIN
            TempVATAmountLineRemainder.INIT;
            TempVATAmountLineRemainder.INSERT;
          END;
          "Line Amount" := GetLineAmountToHandle(SalesLineQty) + GetPrepmtDiffToLineAmount(SalesLine);
          IF SalesLineQty <> Quantity THEN
            "Line Discount Amount" :=
              ROUND("Line Discount Amount" * SalesLineQty / Quantity,Currency."Amount Rounding Precision");

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

          IF SalesHeader."Prices Including VAT" THEN BEGIN
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
                Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
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
                  Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
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
            CalcDeferralAmounts(SalesHeader,SalesLine,OriginalDeferralAmount);
        END;
    END;

    LOCAL PROCEDURE RoundAmount@9(SalesHeader@1003 : Record 36;VAR SalesLine@1004 : Record 37;SalesLineQty@1000 : Decimal);
    VAR
      CurrExchRate@1002 : Record 330;
      NoVAT@1001 : Boolean;
    BEGIN
      WITH SalesLine DO BEGIN
        IncrAmount(SalesHeader,SalesLine,TotalSalesLine);
        Increment(TotalSalesLine."Net Weight",ROUND(SalesLineQty * "Net Weight",0.00001));
        Increment(TotalSalesLine."Gross Weight",ROUND(SalesLineQty * "Gross Weight",0.00001));
        Increment(TotalSalesLine."Unit Volume",ROUND(SalesLineQty * "Unit Volume",0.00001));
        Increment(TotalSalesLine.Quantity,SalesLineQty);
        IF "Units per Parcel" > 0 THEN
          Increment(
            TotalSalesLine."Units per Parcel",
            ROUND(SalesLineQty / "Units per Parcel",1,'>'));

        xSalesLine := SalesLine;
        SalesLineACY := SalesLine;

        IF SalesHeader."Currency Code" <> '' THEN BEGIN
          IF SalesHeader."Posting Date" = 0D THEN
            UseDate := WORKDATE
          ELSE
            UseDate := SalesHeader."Posting Date";

          NoVAT := Amount = "Amount Including VAT";
          "Amount Including VAT" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate,SalesHeader."Currency Code",
                TotalSalesLine."Amount Including VAT",SalesHeader."Currency Factor")) -
            TotalSalesLineLCY."Amount Including VAT";
          IF NoVAT THEN
            Amount := "Amount Including VAT"
          ELSE
            Amount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate,SalesHeader."Currency Code",
                  TotalSalesLine.Amount,SalesHeader."Currency Factor")) -
              TotalSalesLineLCY.Amount;
          "Line Amount" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate,SalesHeader."Currency Code",
                TotalSalesLine."Line Amount",SalesHeader."Currency Factor")) -
            TotalSalesLineLCY."Line Amount";
          "Line Discount Amount" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate,SalesHeader."Currency Code",
                TotalSalesLine."Line Discount Amount",SalesHeader."Currency Factor")) -
            TotalSalesLineLCY."Line Discount Amount";
          "Inv. Discount Amount" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate,SalesHeader."Currency Code",
                TotalSalesLine."Inv. Discount Amount",SalesHeader."Currency Factor")) -
            TotalSalesLineLCY."Inv. Discount Amount";
          "VAT Difference" :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                UseDate,SalesHeader."Currency Code",
                TotalSalesLine."VAT Difference",SalesHeader."Currency Factor")) -
            TotalSalesLineLCY."VAT Difference";
        END;
        IncrAmount(SalesHeader,SalesLine,TotalSalesLineLCY);
        Increment(TotalSalesLineLCY."Unit Cost (LCY)",ROUND(SalesLineQty * "Unit Cost (LCY)"));
      END;
    END;

    LOCAL PROCEDURE ReverseAmount@10(VAR SalesLine@1000 : Record 37);
    BEGIN
      WITH SalesLine DO BEGIN
        "Qty. to Ship" := -"Qty. to Ship";
        "Qty. to Ship (Base)" := -"Qty. to Ship (Base)";
        "Return Qty. to Receive" := -"Return Qty. to Receive";
        "Return Qty. to Receive (Base)" := -"Return Qty. to Receive (Base)";
        "Qty. to Invoice" := -"Qty. to Invoice";
        "Qty. to Invoice (Base)" := -"Qty. to Invoice (Base)";
        "Line Amount" := -"Line Amount";
        Amount := -Amount;
        "VAT Base Amount" := -"VAT Base Amount";
        "VAT Difference" := -"VAT Difference";
        "Amount Including VAT" := -"Amount Including VAT";
        "Line Discount Amount" := -"Line Discount Amount";
        "Inv. Discount Amount" := -"Inv. Discount Amount";
      END;
    END;

    LOCAL PROCEDURE InvoiceRounding@12(SalesHeader@1003 : Record 36;VAR SalesLine@1005 : Record 37;UseTempData@1000 : Boolean;BiggestLineNo@1004 : Integer);
    VAR
      CustPostingGr@1002 : Record 92;
      TempSalesLineForCalc@1006 : TEMPORARY Record 37;
      InvoiceRoundingAmount@1001 : Decimal;
    BEGIN
      Currency.TESTFIELD("Invoice Rounding Precision");
      InvoiceRoundingAmount :=
        -ROUND(
          TotalSalesLine."Amount Including VAT" -
          ROUND(
            TotalSalesLine."Amount Including VAT",Currency."Invoice Rounding Precision",Currency.InvoiceRoundingDirection),
          Currency."Amount Rounding Precision");

      OnBeforeInvoiceRoundingAmount(SalesHeader,TotalSalesLine."Amount Including VAT",UseTempData,InvoiceRoundingAmount);
      IF InvoiceRoundingAmount <> 0 THEN BEGIN
        CustPostingGr.GET(SalesHeader."Customer Posting Group");
        WITH SalesLine DO BEGIN
          INIT;
          BiggestLineNo := BiggestLineNo + 10000;
          "System-Created Entry" := TRUE;
          IF UseTempData THEN BEGIN
            "Line No." := 0;
            Type := Type::"G/L Account";
            CreateTempSalesLineForCalc(TempSalesLineForCalc,SalesLine,CustPostingGr.GetInvRoundingAccount);
            SalesLine := TempSalesLineForCalc;
          END ELSE BEGIN
            "Line No." := BiggestLineNo;
            VALIDATE(Type,Type::"G/L Account");
            VALIDATE("No.",CustPostingGr.GetInvRoundingAccount);
          END;
          VALIDATE(Quantity,1);
          IF IsCreditDocType THEN
            VALIDATE("Return Qty. to Receive",Quantity)
          ELSE
            VALIDATE("Qty. to Ship",Quantity);
          IF SalesHeader."Prices Including VAT" THEN
            VALIDATE("Unit Price",InvoiceRoundingAmount)
          ELSE
            VALIDATE(
              "Unit Price",
              ROUND(
                InvoiceRoundingAmount /
                (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                Currency."Amount Rounding Precision"));
          VALIDATE("Amount Including VAT",InvoiceRoundingAmount);
          "Line No." := BiggestLineNo;
          LastLineRetrieved := FALSE;
          RoundingLineInserted := TRUE;
          RoundingLineNo := "Line No.";
        END;
      END;
    END;

    LOCAL PROCEDURE IncrAmount@13(SalesHeader@1001 : Record 36;SalesLine@1002 : Record 37;VAR TotalSalesLine@1000 : Record 37);
    BEGIN
      WITH SalesLine DO BEGIN
        IF SalesHeader."Prices Including VAT" OR
           ("VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT")
        THEN
          Increment(TotalSalesLine."Line Amount","Line Amount");
        Increment(TotalSalesLine.Amount,Amount);
        Increment(TotalSalesLine."VAT Base Amount","VAT Base Amount");
        Increment(TotalSalesLine."VAT Difference","VAT Difference");
        Increment(TotalSalesLine."Amount Including VAT","Amount Including VAT");
        Increment(TotalSalesLine."Line Discount Amount","Line Discount Amount");
        Increment(TotalSalesLine."Inv. Discount Amount","Inv. Discount Amount");
        Increment(TotalSalesLine."Inv. Disc. Amount to Invoice","Inv. Disc. Amount to Invoice");
        Increment(TotalSalesLine."Prepmt. Line Amount","Prepmt. Line Amount");
        Increment(TotalSalesLine."Prepmt. Amt. Inv.","Prepmt. Amt. Inv.");
        Increment(TotalSalesLine."Prepmt Amt to Deduct","Prepmt Amt to Deduct");
        Increment(TotalSalesLine."Prepmt Amt Deducted","Prepmt Amt Deducted");
        Increment(TotalSalesLine."Prepayment VAT Difference","Prepayment VAT Difference");
        Increment(TotalSalesLine."Prepmt VAT Diff. to Deduct","Prepmt VAT Diff. to Deduct");
        Increment(TotalSalesLine."Prepmt VAT Diff. Deducted","Prepmt VAT Diff. Deducted");
      END;
    END;

    LOCAL PROCEDURE Increment@14(VAR Number@1000 : Decimal;Number2@1001 : Decimal);
    BEGIN
      Number := Number + Number2;
    END;

    [External]
    PROCEDURE GetSalesLines@16(VAR SalesHeader@1000 : Record 36;VAR NewSalesLine@1001 : Record 37;QtyType@1002 : 'General,Invoicing,Shipping');
    VAR
      OldSalesLine@1003 : Record 37;
      MergedSalesLines@1006 : TEMPORARY Record 37;
      TotalAdjCostLCY@1005 : Decimal;
    BEGIN
      IF QtyType = QtyType::Invoicing THEN BEGIN
        CreatePrepaymentLines(SalesHeader,TempPrepaymentSalesLine,FALSE);
        MergeSaleslines(SalesHeader,OldSalesLine,TempPrepaymentSalesLine,MergedSalesLines);
        SumSalesLines2(SalesHeader,NewSalesLine,MergedSalesLines,QtyType,TRUE,FALSE,TotalAdjCostLCY);
      END ELSE
        SumSalesLines2(SalesHeader,NewSalesLine,OldSalesLine,QtyType,TRUE,FALSE,TotalAdjCostLCY);
    END;

    [Internal]
    PROCEDURE GetSalesLinesTemp@33(VAR SalesHeader@1000 : Record 36;VAR NewSalesLine@1001 : Record 37;VAR OldSalesLine@1002 : Record 37;QtyType@1003 : 'General,Invoicing,Shipping');
    VAR
      TotalAdjCostLCY@1005 : Decimal;
    BEGIN
      OldSalesLine.SetSalesHeader(SalesHeader);
      SumSalesLines2(SalesHeader,NewSalesLine,OldSalesLine,QtyType,TRUE,FALSE,TotalAdjCostLCY);
    END;

    [External]
    PROCEDURE SumSalesLines@15(VAR NewSalesHeader@1000 : Record 36;QtyType@1001 : 'General,Invoicing,Shipping';VAR NewTotalSalesLine@1002 : Record 37;VAR NewTotalSalesLineLCY@1003 : Record 37;VAR VATAmount@1004 : Decimal;VAR VATAmountText@1005 : Text[30];VAR ProfitLCY@1006 : Decimal;VAR ProfitPct@1007 : Decimal;VAR TotalAdjCostLCY@1010 : Decimal);
    VAR
      OldSalesLine@1008 : Record 37;
    BEGIN
      SumSalesLinesTemp(
        NewSalesHeader,OldSalesLine,QtyType,NewTotalSalesLine,NewTotalSalesLineLCY,
        VATAmount,VATAmountText,ProfitLCY,ProfitPct,TotalAdjCostLCY);
    END;

    [External]
    PROCEDURE SumSalesLinesTemp@25(VAR SalesHeader@1000 : Record 36;VAR OldSalesLine@1001 : Record 37;QtyType@1002 : 'General,Invoicing,Shipping';VAR NewTotalSalesLine@1003 : Record 37;VAR NewTotalSalesLineLCY@1004 : Record 37;VAR VATAmount@1005 : Decimal;VAR VATAmountText@1006 : Text[30];VAR ProfitLCY@1007 : Decimal;VAR ProfitPct@1008 : Decimal;VAR TotalAdjCostLCY@1011 : Decimal);
    VAR
      SalesLine@1009 : Record 37;
    BEGIN
      WITH SalesHeader DO BEGIN
        SumSalesLines2(SalesHeader,SalesLine,OldSalesLine,QtyType,FALSE,TRUE,TotalAdjCostLCY);
        ProfitLCY := TotalSalesLineLCY.Amount - TotalSalesLineLCY."Unit Cost (LCY)";
        IF TotalSalesLineLCY.Amount = 0 THEN
          ProfitPct := 0
        ELSE
          ProfitPct := ROUND(ProfitLCY / TotalSalesLineLCY.Amount * 100,0.1);
        VATAmount := TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount;
        IF TotalSalesLine."VAT %" = 0 THEN
          VATAmountText := VATAmountTxt
        ELSE
          VATAmountText := STRSUBSTNO(VATRateTxt,TotalSalesLine."VAT %");
        NewTotalSalesLine := TotalSalesLine;
        NewTotalSalesLineLCY := TotalSalesLineLCY;
      END;
    END;

    LOCAL PROCEDURE SumSalesLines2@11(SalesHeader@1011 : Record 36;VAR NewSalesLine@1000 : Record 37;VAR OldSalesLine@1001 : Record 37;QtyType@1002 : 'General,Invoicing,Shipping';InsertSalesLine@1003 : Boolean;CalcAdCostLCY@1008 : Boolean;VAR TotalAdjCostLCY@1006 : Decimal);
    VAR
      SalesLine@1012 : Record 37;
      TempVATAmountLine@1010 : TEMPORARY Record 290;
      TempVATAmountLineRemainder@1009 : TEMPORARY Record 290;
      SalesLineQty@1004 : Decimal;
      AdjCostLCY@1007 : Decimal;
      BiggestLineNo@1005 : Integer;
    BEGIN
      TotalAdjCostLCY := 0;
      TempVATAmountLineRemainder.DELETEALL;
      OldSalesLine.CalcVATAmountLines(QtyType,SalesHeader,OldSalesLine,TempVATAmountLine);
      WITH SalesHeader DO BEGIN
        GetGLSetup;
        SalesSetup.GET;
        GetCurrency("Currency Code");
        OldSalesLine.SETRANGE("Document Type","Document Type");
        OldSalesLine.SETRANGE("Document No.","No.");
        RoundingLineInserted := FALSE;
        IF OldSalesLine.FINDSET THEN
          REPEAT
            IF NOT RoundingLineInserted THEN
              SalesLine := OldSalesLine;
            CASE QtyType OF
              QtyType::General:
                SalesLineQty := SalesLine.Quantity;
              QtyType::Invoicing:
                SalesLineQty := SalesLine."Qty. to Invoice";
              QtyType::Shipping:
                BEGIN
                  IF IsCreditDocType THEN
                    SalesLineQty := SalesLine."Return Qty. to Receive"
                  ELSE
                    SalesLineQty := SalesLine."Qty. to Ship";
                END;
            END;
            DivideAmount(SalesHeader,SalesLine,QtyType,SalesLineQty,TempVATAmountLine,TempVATAmountLineRemainder);
            SalesLine.Quantity := SalesLineQty;
            IF SalesLineQty <> 0 THEN BEGIN
              IF (SalesLine.Amount <> 0) AND NOT RoundingLineInserted THEN
                IF TotalSalesLine.Amount = 0 THEN
                  TotalSalesLine."VAT %" := SalesLine."VAT %"
                ELSE
                  IF TotalSalesLine."VAT %" <> SalesLine."VAT %" THEN
                    TotalSalesLine."VAT %" := 0;
              RoundAmount(SalesHeader,SalesLine,SalesLineQty);

              IF (QtyType IN [QtyType::General,QtyType::Invoicing]) AND
                 NOT InsertSalesLine AND CalcAdCostLCY
              THEN BEGIN
                AdjCostLCY := CostCalcMgt.CalcSalesLineCostLCY(SalesLine,QtyType);
                TotalAdjCostLCY := TotalAdjCostLCY + GetSalesLineAdjCostLCY(SalesLine,QtyType,AdjCostLCY);
              END;

              SalesLine := xSalesLine;
            END;
            IF InsertSalesLine THEN BEGIN
              NewSalesLine := SalesLine;
              NewSalesLine.INSERT;
            END;
            IF RoundingLineInserted THEN
              LastLineRetrieved := TRUE
            ELSE BEGIN
              BiggestLineNo := MAX(BiggestLineNo,OldSalesLine."Line No.");
              LastLineRetrieved := OldSalesLine.NEXT = 0;
              IF LastLineRetrieved AND SalesSetup."Invoice Rounding" THEN
                InvoiceRounding(SalesHeader,SalesLine,TRUE,BiggestLineNo);
            END;
          UNTIL LastLineRetrieved;
      END;
    END;

    LOCAL PROCEDURE GetSalesLineAdjCostLCY@48(SalesLine2@1000 : Record 37;QtyType@1002 : 'General,Invoicing,Shipping';AdjCostLCY@1001 : Decimal) : Decimal;
    BEGIN
      WITH SalesLine2 DO BEGIN
        IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN
          AdjCostLCY := -AdjCostLCY;

        CASE TRUE OF
          "Shipment No." <> '',"Return Receipt No." <> '':
            EXIT(AdjCostLCY);
          QtyType = QtyType::General:
            EXIT(ROUND("Outstanding Quantity" * "Unit Cost (LCY)") + AdjCostLCY);
          "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]:
            BEGIN
              IF "Qty. to Invoice" > "Qty. to Ship" THEN
                EXIT(ROUND("Qty. to Ship" * "Unit Cost (LCY)") + AdjCostLCY);
              EXIT(ROUND("Qty. to Invoice" * "Unit Cost (LCY)"));
            END;
          IsCreditDocType:
            BEGIN
              IF "Qty. to Invoice" > "Return Qty. to Receive" THEN
                EXIT(ROUND("Return Qty. to Receive" * "Unit Cost (LCY)") + AdjCostLCY);
              EXIT(ROUND("Qty. to Invoice" * "Unit Cost (LCY)"));
            END;
        END;
      END;
    END;

    [External]
    PROCEDURE UpdateBlanketOrderLine@21(SalesLine@1000 : Record 37;Ship@1001 : Boolean;Receive@1006 : Boolean;Invoice@1002 : Boolean);
    VAR
      BlanketOrderSalesLine@1003 : Record 37;
      xBlanketOrderSalesLine@1007 : Record 37;
      ModifyLine@1004 : Boolean;
      Sign@1005 : Decimal;
    BEGIN
      IF (SalesLine."Blanket Order No." <> '') AND (SalesLine."Blanket Order Line No." <> 0) AND
         ((Ship AND (SalesLine."Qty. to Ship" <> 0)) OR
          (Receive AND (SalesLine."Return Qty. to Receive" <> 0)) OR
          (Invoice AND (SalesLine."Qty. to Invoice" <> 0)))
      THEN
        IF BlanketOrderSalesLine.GET(
             BlanketOrderSalesLine."Document Type"::"Blanket Order",SalesLine."Blanket Order No.",
             SalesLine."Blanket Order Line No.")
        THEN BEGIN
          BlanketOrderSalesLine.TESTFIELD(Type,SalesLine.Type);
          BlanketOrderSalesLine.TESTFIELD("No.",SalesLine."No.");
          BlanketOrderSalesLine.TESTFIELD("Sell-to Customer No.",SalesLine."Sell-to Customer No.");

          ModifyLine := FALSE;
          CASE SalesLine."Document Type" OF
            SalesLine."Document Type"::Order,
            SalesLine."Document Type"::Invoice:
              Sign := 1;
            SalesLine."Document Type"::"Return Order",
            SalesLine."Document Type"::"Credit Memo":
              Sign := -1;
          END;
          IF Ship AND (SalesLine."Shipment No." = '') THEN BEGIN
            xBlanketOrderSalesLine := BlanketOrderSalesLine;

            IF BlanketOrderSalesLine."Qty. per Unit of Measure" =
               SalesLine."Qty. per Unit of Measure"
            THEN
              BlanketOrderSalesLine."Quantity Shipped" :=
                BlanketOrderSalesLine."Quantity Shipped" + Sign * SalesLine."Qty. to Ship"
            ELSE
              BlanketOrderSalesLine."Quantity Shipped" :=
                BlanketOrderSalesLine."Quantity Shipped" +
                Sign *
                ROUND(
                  (SalesLine."Qty. per Unit of Measure" /
                   BlanketOrderSalesLine."Qty. per Unit of Measure") *
                  SalesLine."Qty. to Ship",0.00001);
            BlanketOrderSalesLine."Qty. Shipped (Base)" :=
              BlanketOrderSalesLine."Qty. Shipped (Base)" + Sign * SalesLine."Qty. to Ship (Base)";
            ModifyLine := TRUE;

            AsmPost.UpdateBlanketATO(xBlanketOrderSalesLine,BlanketOrderSalesLine);
          END;
          IF Receive AND (SalesLine."Return Receipt No." = '') THEN BEGIN
            IF BlanketOrderSalesLine."Qty. per Unit of Measure" =
               SalesLine."Qty. per Unit of Measure"
            THEN
              BlanketOrderSalesLine."Quantity Shipped" :=
                BlanketOrderSalesLine."Quantity Shipped" + Sign * SalesLine."Return Qty. to Receive"
            ELSE
              BlanketOrderSalesLine."Quantity Shipped" :=
                BlanketOrderSalesLine."Quantity Shipped" +
                Sign *
                ROUND(
                  (SalesLine."Qty. per Unit of Measure" /
                   BlanketOrderSalesLine."Qty. per Unit of Measure") *
                  SalesLine."Return Qty. to Receive",0.00001);
            BlanketOrderSalesLine."Qty. Shipped (Base)" :=
              BlanketOrderSalesLine."Qty. Shipped (Base)" + Sign * SalesLine."Return Qty. to Receive (Base)";
            ModifyLine := TRUE;
          END;
          IF Invoice THEN BEGIN
            IF BlanketOrderSalesLine."Qty. per Unit of Measure" =
               SalesLine."Qty. per Unit of Measure"
            THEN
              BlanketOrderSalesLine."Quantity Invoiced" :=
                BlanketOrderSalesLine."Quantity Invoiced" + Sign * SalesLine."Qty. to Invoice"
            ELSE
              BlanketOrderSalesLine."Quantity Invoiced" :=
                BlanketOrderSalesLine."Quantity Invoiced" +
                Sign *
                ROUND(
                  (SalesLine."Qty. per Unit of Measure" /
                   BlanketOrderSalesLine."Qty. per Unit of Measure") *
                  SalesLine."Qty. to Invoice",0.00001);
            BlanketOrderSalesLine."Qty. Invoiced (Base)" :=
              BlanketOrderSalesLine."Qty. Invoiced (Base)" + Sign * SalesLine."Qty. to Invoice (Base)";
            ModifyLine := TRUE;
          END;

          IF ModifyLine THEN BEGIN
            BlanketOrderSalesLine.InitOutstanding;
            IF (BlanketOrderSalesLine.Quantity * BlanketOrderSalesLine."Quantity Shipped" < 0) OR
               (ABS(BlanketOrderSalesLine.Quantity) < ABS(BlanketOrderSalesLine."Quantity Shipped"))
            THEN
              BlanketOrderSalesLine.FIELDERROR(
                "Quantity Shipped",STRSUBSTNO(
                  BlanketOrderQuantityGreaterThanErr,
                  BlanketOrderSalesLine.FIELDCAPTION(Quantity)));

            IF (BlanketOrderSalesLine."Quantity (Base)" *
                BlanketOrderSalesLine."Qty. Shipped (Base)" < 0) OR
               (ABS(BlanketOrderSalesLine."Quantity (Base)") <
                ABS(BlanketOrderSalesLine."Qty. Shipped (Base)"))
            THEN
              BlanketOrderSalesLine.FIELDERROR(
                "Qty. Shipped (Base)",
                STRSUBSTNO(
                  BlanketOrderQuantityGreaterThanErr,
                  BlanketOrderSalesLine.FIELDCAPTION("Quantity (Base)")));

            BlanketOrderSalesLine.CALCFIELDS("Reserved Qty. (Base)");
            IF ABS(BlanketOrderSalesLine."Outstanding Qty. (Base)") <
               ABS(BlanketOrderSalesLine."Reserved Qty. (Base)")
            THEN
              BlanketOrderSalesLine.FIELDERROR(
                "Reserved Qty. (Base)",BlanketOrderQuantityReducedErr);

            BlanketOrderSalesLine."Qty. to Invoice" :=
              BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Invoiced";
            BlanketOrderSalesLine."Qty. to Ship" :=
              BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Quantity Shipped";
            BlanketOrderSalesLine."Qty. to Invoice (Base)" :=
              BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Invoiced (Base)";
            BlanketOrderSalesLine."Qty. to Ship (Base)" :=
              BlanketOrderSalesLine."Quantity (Base)" - BlanketOrderSalesLine."Qty. Shipped (Base)";

            BlanketOrderSalesLine.MODIFY;
          END;
        END;
    END;

    LOCAL PROCEDURE RunGenJnlPostLine@23(VAR GenJnlLine@1000 : Record 81) : Integer;
    BEGIN
      EXIT(GenJnlPostLine.RunWithCheck(GenJnlLine));
    END;

    LOCAL PROCEDURE CheckDim@34(SalesHeader@1000 : Record 36);
    BEGIN
      CheckDimCombHeader(SalesHeader);
      CheckDimValuePostingHeader(SalesHeader);
      CheckDimLines(SalesHeader);
    END;

    LOCAL PROCEDURE CheckDimCombHeader@178(SalesHeader@1000 : Record 36);
    VAR
      DimMgt@1001 : Codeunit 408;
    BEGIN
      WITH SalesHeader DO
        IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
          ERROR(DimensionIsBlockedErr,"Document Type","No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimCombLine@171(SalesLine@1000 : Record 37);
    VAR
      DimMgt@1001 : Codeunit 408;
    BEGIN
      WITH SalesLine DO
        IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
          ERROR(LineDimensionBlockedErr,"Document Type","Document No.","Line No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimLines@176(SalesHeader@1000 : Record 36);
    VAR
      TempSalesLine@1001 : TEMPORARY Record 37;
    BEGIN
      WITH TempSalesLine DO BEGIN
        ResetTempLines(TempSalesLine);
        SETFILTER(Type,'<>%1',Type::" ");
        IF FINDSET THEN
          REPEAT
            IF (SalesHeader.Invoice AND ("Qty. to Invoice" <> 0)) OR
               (SalesHeader.Ship AND ("Qty. to Ship" <> 0)) OR
               (SalesHeader.Receive AND ("Return Qty. to Receive" <> 0))
            THEN BEGIN
              CheckDimCombLine(TempSalesLine);
              CheckDimValuePostingLine(TempSalesLine);
            END
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckDimValuePostingHeader@177(SalesHeader@1000 : Record 36);
    VAR
      DimMgt@1001 : Codeunit 408;
      TableIDArr@1002 : ARRAY [10] OF Integer;
      NumberArr@1003 : ARRAY [10] OF Code[20];
    BEGIN
      WITH SalesHeader DO BEGIN
        TableIDArr[1] := DATABASE::Customer;
        NumberArr[1] := "Bill-to Customer No.";
        TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
        NumberArr[2] := "Salesperson Code";
        TableIDArr[3] := DATABASE::Campaign;
        NumberArr[3] := "Campaign No.";
        TableIDArr[4] := DATABASE::"Responsibility Center";
        NumberArr[4] := "Responsibility Center";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,"Dimension Set ID") THEN
          ERROR(InvalidDimensionsErr,"Document Type","No.",DimMgt.GetDimValuePostingErr);
      END;
    END;

    LOCAL PROCEDURE CreateTempSalesLineForCalc@267(VAR SalesLineForCalc@1000 : Record 37;SalesLine@1001 : Record 37;InvoiceRoundingAccount@1002 : Code[20]);
    BEGIN
      SalesLineForCalc := SalesLine;
      SalesLineForCalc.SetHideValidationDialog(TRUE);
      SalesLineForCalc.VALIDATE("No.",InvoiceRoundingAccount);
    END;

    LOCAL PROCEDURE CheckDimValuePostingLine@175(SalesLine@1000 : Record 37);
    VAR
      DimMgt@1001 : Codeunit 408;
      TableIDArr@1002 : ARRAY [10] OF Integer;
      NumberArr@1003 : ARRAY [10] OF Code[20];
    BEGIN
      WITH SalesLine DO BEGIN
        TableIDArr[1] := DimMgt.TypeToTableID3(Type);
        NumberArr[1] := "No.";
        TableIDArr[2] := DATABASE::Job;
        NumberArr[2] := "Job No.";
        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,"Dimension Set ID") THEN
          ERROR(LineInvalidDimensionsErr,"Document Type","Document No.","Line No.",DimMgt.GetDimValuePostingErr);
      END;
    END;

    LOCAL PROCEDURE DeleteItemChargeAssgnt@5803(SalesHeader@1001 : Record 36);
    VAR
      ItemChargeAssgntSales@1000 : Record 5809;
    BEGIN
      ItemChargeAssgntSales.SETRANGE("Document Type",SalesHeader."Document Type");
      ItemChargeAssgntSales.SETRANGE("Document No.",SalesHeader."No.");
      IF NOT ItemChargeAssgntSales.ISEMPTY THEN
        ItemChargeAssgntSales.DELETEALL;
    END;

    LOCAL PROCEDURE UpdateItemChargeAssgnt@5808();
    VAR
      ItemChargeAssgntSales@1000 : Record 5809;
    BEGIN
      WITH TempItemChargeAssgntSales DO BEGIN
        ClearItemChargeAssgntFilter;
        MARKEDONLY(TRUE);
        IF FINDSET THEN
          REPEAT
            ItemChargeAssgntSales.GET("Document Type","Document No.","Document Line No.","Line No.");
            ItemChargeAssgntSales."Qty. Assigned" :=
              ItemChargeAssgntSales."Qty. Assigned" + "Qty. to Assign";
            ItemChargeAssgntSales."Qty. to Assign" := 0;
            ItemChargeAssgntSales."Amount to Assign" := 0;
            ItemChargeAssgntSales.MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UpdateSalesOrderChargeAssgnt@5814(SalesOrderInvLine@1000 : Record 37;SalesOrderLine@1001 : Record 37);
    VAR
      SalesOrderLine2@1002 : Record 37;
      SalesOrderInvLine2@1003 : Record 37;
      SalesShptLine@1004 : Record 111;
      ReturnRcptLine@1005 : Record 6661;
    BEGIN
      WITH SalesOrderInvLine DO BEGIN
        ClearItemChargeAssgntFilter;
        TempItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
        TempItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
        TempItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
        TempItemChargeAssgntSales.MARKEDONLY(TRUE);
        IF TempItemChargeAssgntSales.FINDSET THEN
          REPEAT
            IF TempItemChargeAssgntSales."Applies-to Doc. Type" = "Document Type" THEN BEGIN
              SalesOrderInvLine2.GET(
                TempItemChargeAssgntSales."Applies-to Doc. Type",
                TempItemChargeAssgntSales."Applies-to Doc. No.",
                TempItemChargeAssgntSales."Applies-to Doc. Line No.");
              IF ((SalesOrderLine."Document Type" = SalesOrderLine."Document Type"::Order) AND
                  (SalesOrderInvLine2."Shipment No." = "Shipment No.")) OR
                 ((SalesOrderLine."Document Type" = SalesOrderLine."Document Type"::"Return Order") AND
                  (SalesOrderInvLine2."Return Receipt No." = "Return Receipt No."))
              THEN BEGIN
                IF SalesOrderLine."Document Type" = SalesOrderLine."Document Type"::Order THEN BEGIN
                  IF NOT
                     SalesShptLine.GET(SalesOrderInvLine2."Shipment No.",SalesOrderInvLine2."Shipment Line No.")
                  THEN
                    ERROR(ShipmentLinesDeletedErr);
                  SalesOrderLine2.GET(
                    SalesOrderLine2."Document Type"::Order,
                    SalesShptLine."Order No.",SalesShptLine."Order Line No.");
                END ELSE BEGIN
                  IF NOT
                     ReturnRcptLine.GET(SalesOrderInvLine2."Return Receipt No.",SalesOrderInvLine2."Return Receipt Line No.")
                  THEN
                    ERROR(ReturnReceiptLinesDeletedErr);
                  SalesOrderLine2.GET(
                    SalesOrderLine2."Document Type"::"Return Order",
                    ReturnRcptLine."Return Order No.",ReturnRcptLine."Return Order Line No.");
                END;
                UpdateSalesChargeAssgntLines(
                  SalesOrderLine,
                  SalesOrderLine2."Document Type",
                  SalesOrderLine2."Document No.",
                  SalesOrderLine2."Line No.",
                  TempItemChargeAssgntSales."Qty. to Assign");
              END;
            END ELSE
              UpdateSalesChargeAssgntLines(
                SalesOrderLine,
                TempItemChargeAssgntSales."Applies-to Doc. Type",
                TempItemChargeAssgntSales."Applies-to Doc. No.",
                TempItemChargeAssgntSales."Applies-to Doc. Line No.",
                TempItemChargeAssgntSales."Qty. to Assign");
          UNTIL TempItemChargeAssgntSales.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UpdateSalesChargeAssgntLines@5813(SalesOrderLine@1000 : Record 37;ApplToDocType@1001 : Option;ApplToDocNo@1002 : Code[20];ApplToDocLineNo@1003 : Integer;QtyToAssign@1004 : Decimal);
    VAR
      ItemChargeAssgntSales@1005 : Record 5809;
      TempItemChargeAssgntSales2@1007 : Record 5809;
      LastLineNo@1006 : Integer;
      TotalToAssign@1008 : Decimal;
    BEGIN
      ItemChargeAssgntSales.SETRANGE("Document Type",SalesOrderLine."Document Type");
      ItemChargeAssgntSales.SETRANGE("Document No.",SalesOrderLine."Document No.");
      ItemChargeAssgntSales.SETRANGE("Document Line No.",SalesOrderLine."Line No.");
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type",ApplToDocType);
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.",ApplToDocNo);
      ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.",ApplToDocLineNo);
      IF ItemChargeAssgntSales.FINDFIRST THEN BEGIN
        ItemChargeAssgntSales."Qty. Assigned" := ItemChargeAssgntSales."Qty. Assigned" + QtyToAssign;
        ItemChargeAssgntSales."Qty. to Assign" := 0;
        ItemChargeAssgntSales."Amount to Assign" := 0;
        ItemChargeAssgntSales.MODIFY;
      END ELSE BEGIN
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type");
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.");
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.");
        ItemChargeAssgntSales.CALCSUMS("Qty. to Assign");

        // calculate total qty. to assign of the invoice charge line
        TempItemChargeAssgntSales2.SETRANGE("Document Type",TempItemChargeAssgntSales."Document Type");
        TempItemChargeAssgntSales2.SETRANGE("Document No.",TempItemChargeAssgntSales."Document No.");
        TempItemChargeAssgntSales2.SETRANGE("Document Line No.",TempItemChargeAssgntSales."Document Line No.");
        TempItemChargeAssgntSales2.CALCSUMS("Qty. to Assign");

        TotalToAssign := ItemChargeAssgntSales."Qty. to Assign" +
          TempItemChargeAssgntSales2."Qty. to Assign";

        IF ItemChargeAssgntSales.FINDLAST THEN
          LastLineNo := ItemChargeAssgntSales."Line No.";

        IF SalesOrderLine.Quantity < TotalToAssign THEN
          REPEAT
            TotalToAssign := TotalToAssign - ItemChargeAssgntSales."Qty. to Assign";
            ItemChargeAssgntSales."Qty. to Assign" := 0;
            ItemChargeAssgntSales."Amount to Assign" := 0;
            ItemChargeAssgntSales.MODIFY;
          UNTIL (ItemChargeAssgntSales.NEXT(-1) = 0) OR
                (TotalToAssign = SalesOrderLine.Quantity);

        InsertAssocOrderCharge(
          SalesOrderLine,
          ApplToDocType,
          ApplToDocNo,
          ApplToDocLineNo,
          LastLineNo,
          TempItemChargeAssgntSales."Applies-to Doc. Line Amount");
      END;
    END;

    LOCAL PROCEDURE InsertAssocOrderCharge@45(SalesOrderLine@1000 : Record 37;ApplToDocType@1001 : Option;ApplToDocNo@1002 : Code[20];ApplToDocLineNo@1003 : Integer;LastLineNo@1004 : Integer;ApplToDocLineAmt@1005 : Decimal);
    VAR
      NewItemChargeAssgntSales@1006 : Record 5809;
    BEGIN
      WITH NewItemChargeAssgntSales DO BEGIN
        INIT;
        "Document Type" := SalesOrderLine."Document Type";
        "Document No." := SalesOrderLine."Document No.";
        "Document Line No." := SalesOrderLine."Line No.";
        "Line No." := LastLineNo + 10000;
        "Item Charge No." := TempItemChargeAssgntSales."Item Charge No.";
        "Item No." := TempItemChargeAssgntSales."Item No.";
        "Qty. Assigned" := TempItemChargeAssgntSales."Qty. to Assign";
        "Qty. to Assign" := 0;
        "Amount to Assign" := 0;
        Description := TempItemChargeAssgntSales.Description;
        "Unit Cost" := TempItemChargeAssgntSales."Unit Cost";
        "Applies-to Doc. Type" := ApplToDocType;
        "Applies-to Doc. No." := ApplToDocNo;
        "Applies-to Doc. Line No." := ApplToDocLineNo;
        "Applies-to Doc. Line Amount" := ApplToDocLineAmt;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE CopyAndCheckItemCharge@5806(SalesHeader@1000 : Record 36);
    VAR
      TempSalesLine@1001 : TEMPORARY Record 37;
      SalesLine@1002 : Record 37;
      InvoiceEverything@1004 : Boolean;
      AssignError@1005 : Boolean;
      QtyNeeded@1003 : Decimal;
    BEGIN
      TempItemChargeAssgntSales.RESET;
      TempItemChargeAssgntSales.DELETEALL;

      // Check for max qty posting
      WITH TempSalesLine DO BEGIN
        ResetTempLines(TempSalesLine);
        SETRANGE(Type,Type::"Charge (Item)");
        IF ISEMPTY THEN
          EXIT;

        ItemChargeAssgntSales.RESET;
        ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
        ItemChargeAssgntSales.SETFILTER("Qty. to Assign",'<>0');
        IF ItemChargeAssgntSales.FINDSET THEN
          REPEAT
            TempItemChargeAssgntSales.INIT;
            TempItemChargeAssgntSales := ItemChargeAssgntSales;
            TempItemChargeAssgntSales.INSERT;
          UNTIL ItemChargeAssgntSales.NEXT = 0;

        SETFILTER("Qty. to Invoice",'<>0');
        IF FINDSET THEN
          REPEAT
            TESTFIELD("Job No.",'');
            TESTFIELD("Job Contract Entry No.",0);
            IF ("Qty. to Ship" + "Return Qty. to Receive" <> 0) AND
               ((SalesHeader.Ship OR SalesHeader.Receive) OR
                (ABS("Qty. to Invoice") >
                 ABS("Qty. Shipped Not Invoiced" + "Qty. to Ship") +
                 ABS("Ret. Qty. Rcd. Not Invd.(Base)" + "Return Qty. to Receive")))
            THEN
              TESTFIELD("Line Amount");

            IF NOT SalesHeader.Ship THEN
              "Qty. to Ship" := 0;
            IF NOT SalesHeader.Receive THEN
              "Return Qty. to Receive" := 0;
            IF ABS("Qty. to Invoice") >
               ABS("Quantity Shipped" + "Qty. to Ship" + "Return Qty. Received" + "Return Qty. to Receive" - "Quantity Invoiced")
            THEN
              "Qty. to Invoice" :=
                "Quantity Shipped" + "Qty. to Ship" + "Return Qty. Received" + "Return Qty. to Receive" - "Quantity Invoiced";

            CALCFIELDS("Qty. to Assign","Qty. Assigned");
            IF ABS("Qty. to Assign" + "Qty. Assigned") > ABS("Qty. to Invoice" + "Quantity Invoiced") THEN
              ERROR(CannotAssignMoreErr,
                "Qty. to Invoice" + "Quantity Invoiced" - "Qty. Assigned",
                FIELDCAPTION("Document Type"),"Document Type",
                FIELDCAPTION("Document No."),"Document No.",
                FIELDCAPTION("Line No."),"Line No.");
            IF Quantity = "Qty. to Invoice" + "Quantity Invoiced" THEN BEGIN
              IF "Qty. to Assign" <> 0 THEN
                IF Quantity = "Quantity Invoiced" THEN BEGIN
                  TempItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
                  TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type","Document Type");
                  IF TempItemChargeAssgntSales.FINDSET THEN
                    REPEAT
                      SalesLine.GET(
                        TempItemChargeAssgntSales."Applies-to Doc. Type",
                        TempItemChargeAssgntSales."Applies-to Doc. No.",
                        TempItemChargeAssgntSales."Applies-to Doc. Line No.");
                      IF SalesLine.Quantity = SalesLine."Quantity Invoiced" THEN
                        ERROR(CannotAssignInvoicedErr,SalesLine.TABLECAPTION,
                          SalesLine.FIELDCAPTION("Document Type"),SalesLine."Document Type",
                          SalesLine.FIELDCAPTION("Document No."),SalesLine."Document No.",
                          SalesLine.FIELDCAPTION("Line No."),SalesLine."Line No.");
                    UNTIL TempItemChargeAssgntSales.NEXT = 0;
                END;
              IF Quantity <> "Qty. to Assign" + "Qty. Assigned" THEN
                AssignError := TRUE;
            END;

            IF ("Qty. to Assign" + "Qty. Assigned") < ("Qty. to Invoice" + "Quantity Invoiced") THEN
              ERROR(MustAssignItemChargeErr,"No.");

            // check if all ILEs exist
            QtyNeeded := "Qty. to Assign";
            TempItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
            IF TempItemChargeAssgntSales.FINDSET THEN
              REPEAT
                IF (TempItemChargeAssgntSales."Applies-to Doc. Type" <> "Document Type") OR
                   (TempItemChargeAssgntSales."Applies-to Doc. No." <> "Document No.")
                THEN
                  QtyNeeded := QtyNeeded - TempItemChargeAssgntSales."Qty. to Assign"
                ELSE BEGIN
                  SalesLine.GET(
                    TempItemChargeAssgntSales."Applies-to Doc. Type",
                    TempItemChargeAssgntSales."Applies-to Doc. No.",
                    TempItemChargeAssgntSales."Applies-to Doc. Line No.");
                  IF ItemLedgerEntryExist(SalesLine,SalesHeader.Ship OR SalesHeader.Receive) THEN
                    QtyNeeded := QtyNeeded - TempItemChargeAssgntSales."Qty. to Assign";
                END;
              UNTIL TempItemChargeAssgntSales.NEXT = 0;

            IF QtyNeeded > 0 THEN
              ERROR(CannotInvoiceItemChargeErr,"No.");
          UNTIL NEXT = 0;

        // Check saleslines
        IF AssignError THEN
          IF SalesHeader."Document Type" IN
             [SalesHeader."Document Type"::Invoice,SalesHeader."Document Type"::"Credit Memo"]
          THEN
            InvoiceEverything := TRUE
          ELSE BEGIN
            RESET;
            SETFILTER(Type,'%1|%2',Type::Item,Type::"Charge (Item)");
            IF FINDSET THEN
              REPEAT
                IF SalesHeader.Ship OR SalesHeader.Receive THEN
                  InvoiceEverything :=
                    Quantity = "Qty. to Invoice" + "Quantity Invoiced"
                ELSE
                  InvoiceEverything :=
                    (Quantity = "Qty. to Invoice" + "Quantity Invoiced") AND
                    ("Qty. to Invoice" =
                     "Qty. Shipped Not Invoiced" + "Ret. Qty. Rcd. Not Invd.(Base)");
              UNTIL (NEXT = 0) OR (NOT InvoiceEverything);
          END;

        IF InvoiceEverything AND AssignError THEN
          ERROR(MustAssignErr);
      END;
    END;

    LOCAL PROCEDURE ClearItemChargeAssgntFilter@27();
    BEGIN
      TempItemChargeAssgntSales.SETRANGE("Document Line No.");
      TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type");
      TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.");
      TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.");
      TempItemChargeAssgntSales.MARKEDONLY(FALSE);
    END;

    LOCAL PROCEDURE GetItemChargeLine@5809(SalesHeader@1005 : Record 36;VAR ItemChargeSalesLine@1000 : Record 37);
    VAR
      SalesShptLine@1001 : Record 111;
      ReturnReceiptLine@1003 : Record 6661;
      QtyShippedNotInvd@1002 : Decimal;
      QtyReceivedNotInvd@1004 : Decimal;
    BEGIN
      WITH TempItemChargeAssgntSales DO
        IF (ItemChargeSalesLine."Document Type" <> "Document Type") OR
           (ItemChargeSalesLine."Document No." <> "Document No.") OR
           (ItemChargeSalesLine."Line No." <> "Document Line No.")
        THEN BEGIN
          ItemChargeSalesLine.GET("Document Type","Document No.","Document Line No.");
          IF NOT SalesHeader.Ship THEN
            ItemChargeSalesLine."Qty. to Ship" := 0;
          IF NOT SalesHeader.Receive THEN
            ItemChargeSalesLine."Return Qty. to Receive" := 0;
          IF ItemChargeSalesLine."Shipment No." <> '' THEN BEGIN
            SalesShptLine.GET(ItemChargeSalesLine."Shipment No.",ItemChargeSalesLine."Shipment Line No.");
            QtyShippedNotInvd := "Qty. to Assign" - "Qty. Assigned";
          END ELSE
            QtyShippedNotInvd := ItemChargeSalesLine."Quantity Shipped";
          IF ItemChargeSalesLine."Return Receipt No." <> '' THEN BEGIN
            ReturnReceiptLine.GET(ItemChargeSalesLine."Return Receipt No.",ItemChargeSalesLine."Return Receipt Line No.");
            QtyReceivedNotInvd := "Qty. to Assign" - "Qty. Assigned";
          END ELSE
            QtyReceivedNotInvd := ItemChargeSalesLine."Return Qty. Received";
          IF ABS(ItemChargeSalesLine."Qty. to Invoice") >
             ABS(QtyShippedNotInvd + ItemChargeSalesLine."Qty. to Ship" +
               QtyReceivedNotInvd + ItemChargeSalesLine."Return Qty. to Receive" -
               ItemChargeSalesLine."Quantity Invoiced")
          THEN
            ItemChargeSalesLine."Qty. to Invoice" :=
              QtyShippedNotInvd + ItemChargeSalesLine."Qty. to Ship" +
              QtyReceivedNotInvd + ItemChargeSalesLine."Return Qty. to Receive" -
              ItemChargeSalesLine."Quantity Invoiced";
        END;
    END;

    LOCAL PROCEDURE CalcQtyToInvoice@24(QtyToHandle@1000 : Decimal;QtyToInvoice@1001 : Decimal) : Decimal;
    BEGIN
      IF ABS(QtyToHandle) > ABS(QtyToInvoice) THEN
        EXIT(-QtyToHandle);

      EXIT(-QtyToInvoice);
    END;

    LOCAL PROCEDURE CheckWarehouse@7301(VAR TempItemSalesLine@1000 : TEMPORARY Record 37);
    VAR
      WhseValidateSourceLine@1003 : Codeunit 5777;
      ShowError@1002 : Boolean;
    BEGIN
      WITH TempItemSalesLine DO BEGIN
        SETRANGE(Type,Type::Item);
        SETRANGE("Drop Shipment",FALSE);
        IF FINDSET THEN
          REPEAT
            GetLocation("Location Code");
            CASE "Document Type" OF
              "Document Type"::Order:
                IF ((Location."Require Receive" OR Location."Require Put-away") AND (Quantity < 0)) OR
                   ((Location."Require Shipment" OR Location."Require Pick") AND (Quantity >= 0))
                THEN BEGIN
                  IF Location."Directed Put-away and Pick" THEN
                    ShowError := TRUE
                  ELSE
                    IF WhseValidateSourceLine.WhseLinesExist(
                         DATABASE::"Sales Line","Document Type","Document No.","Line No.",0,Quantity)
                    THEN
                      ShowError := TRUE;
                END;
              "Document Type"::"Return Order":
                IF ((Location."Require Receive" OR Location."Require Put-away") AND (Quantity >= 0)) OR
                   ((Location."Require Shipment" OR Location."Require Pick") AND (Quantity < 0))
                THEN BEGIN
                  IF Location."Directed Put-away and Pick" THEN
                    ShowError := TRUE
                  ELSE
                    IF WhseValidateSourceLine.WhseLinesExist(
                         DATABASE::"Sales Line","Document Type","Document No.","Line No.",0,Quantity)
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

    LOCAL PROCEDURE CreateWhseJnlLine@7302(ItemJnlLine@1000 : Record 83;SalesLine@1001 : Record 37;VAR TempWhseJnlLine@1002 : TEMPORARY Record 7311);
    VAR
      WhseMgt@1003 : Codeunit 5775;
      WMSMgt@1004 : Codeunit 7302;
    BEGIN
      WITH SalesLine DO BEGIN
        WMSMgt.CheckAdjmtBin(Location,ItemJnlLine.Quantity,TRUE);
        WMSMgt.CreateWhseJnlLine(ItemJnlLine,0,TempWhseJnlLine,FALSE);
        TempWhseJnlLine."Source Type" := DATABASE::"Sales Line";
        TempWhseJnlLine."Source Subtype" := "Document Type";
        TempWhseJnlLine."Source Code" := SrcCode;
        TempWhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(TempWhseJnlLine."Source Type",TempWhseJnlLine."Source Subtype");
        TempWhseJnlLine."Source No." := "Document No.";
        TempWhseJnlLine."Source Line No." := "Line No.";
        CASE "Document Type" OF
          "Document Type"::Order:
            TempWhseJnlLine."Reference Document" :=
              TempWhseJnlLine."Reference Document"::"Posted Shipment";
          "Document Type"::Invoice:
            TempWhseJnlLine."Reference Document" :=
              TempWhseJnlLine."Reference Document"::"Posted S. Inv.";
          "Document Type"::"Credit Memo":
            TempWhseJnlLine."Reference Document" :=
              TempWhseJnlLine."Reference Document"::"Posted S. Cr. Memo";
          "Document Type"::"Return Order":
            TempWhseJnlLine."Reference Document" :=
              TempWhseJnlLine."Reference Document"::"Posted Rtrn. Shipment";
        END;
        TempWhseJnlLine."Reference No." := ItemJnlLine."Document No.";
      END;
    END;

    LOCAL PROCEDURE WhseHandlingRequired@7307(SalesLine@1001 : Record 37) : Boolean;
    VAR
      WhseSetup@1000 : Record 5769;
    BEGIN
      IF (SalesLine.Type = SalesLine.Type::Item) AND (NOT SalesLine."Drop Shipment") THEN BEGIN
        IF SalesLine."Location Code" = '' THEN BEGIN
          WhseSetup.GET;
          IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN
            EXIT(WhseSetup."Require Receive");

          EXIT(WhseSetup."Require Shipment");
        END;

        GetLocation(SalesLine."Location Code");
        IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN
          EXIT(Location."Require Receive");

        EXIT(Location."Require Shipment");
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

    LOCAL PROCEDURE InsertShptEntryRelation@38(VAR SalesShptLine@1002 : Record 111) : Integer;
    VAR
      ItemEntryRelation@1001 : Record 6507;
    BEGIN
      TempHandlingSpecification.CopySpecification(TempTrackingSpecificationInv);
      TempHandlingSpecification.CopySpecification(TempATOTrackingSpecification);
      TempHandlingSpecification.RESET;
      IF TempHandlingSpecification.FINDSET THEN BEGIN
        REPEAT
          ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification);
          ItemEntryRelation.TransferFieldsSalesShptLine(SalesShptLine);
          ItemEntryRelation.INSERT;
        UNTIL TempHandlingSpecification.NEXT = 0;
        TempHandlingSpecification.DELETEALL;
        EXIT(0);
      END;
      EXIT(ItemLedgShptEntryNo);
    END;

    LOCAL PROCEDURE InsertReturnEntryRelation@39(VAR ReturnRcptLine@1002 : Record 6661) : Integer;
    VAR
      ItemEntryRelation@1001 : Record 6507;
    BEGIN
      TempHandlingSpecification.CopySpecification(TempTrackingSpecificationInv);
      TempHandlingSpecification.CopySpecification(TempATOTrackingSpecification);
      TempHandlingSpecification.RESET;
      IF TempHandlingSpecification.FINDSET THEN BEGIN
        REPEAT
          ItemEntryRelation.InitFromTrackingSpec(TempHandlingSpecification);
          ItemEntryRelation.TransferFieldsReturnRcptLine(ReturnRcptLine);
          ItemEntryRelation.INSERT;
        UNTIL TempHandlingSpecification.NEXT = 0;
        TempHandlingSpecification.DELETEALL;
        EXIT(0);
      END;
      EXIT(ItemLedgShptEntryNo);
    END;

    LOCAL PROCEDURE CheckTrackingSpecification@46(SalesHeader@1002 : Record 36;VAR TempItemSalesLine@1019 : TEMPORARY Record 37);
    VAR
      ReservationEntry@1001 : Record 337;
      ItemTrackingCode@1009 : Record 6502;
      ItemJnlLine@1006 : Record 83;
      CreateReservEntry@1004 : Codeunit 99000830;
      ItemTrackingManagement@1015 : Codeunit 6500;
      ErrorFieldCaption@1018 : Text[250];
      SignFactor@1005 : Integer;
      SalesLineQtyToHandle@1023 : Decimal;
      TrackingQtyToHandle@1003 : Decimal;
      Inbound@1010 : Boolean;
      SNRequired@1011 : Boolean;
      LotRequired@1012 : Boolean;
      SNInfoRequired@1013 : Boolean;
      LotInfoRequired@1014 : Boolean;
      CheckSalesLine@1008 : Boolean;
    BEGIN
      // if a SalesLine is posted with ItemTracking then tracked quantity must be equal to posted quantity
      IF NOT (SalesHeader."Document Type" IN
              [SalesHeader."Document Type"::Order,SalesHeader."Document Type"::"Return Order"])
      THEN
        EXIT;

      TrackingQtyToHandle := 0;

      WITH TempItemSalesLine DO BEGIN
        SETRANGE(Type,Type::Item);
        IF SalesHeader.Ship THEN BEGIN
          SETFILTER("Quantity Shipped",'<>%1',0);
          ErrorFieldCaption := FIELDCAPTION("Qty. to Ship");
        END ELSE BEGIN
          SETFILTER("Return Qty. Received",'<>%1',0);
          ErrorFieldCaption := FIELDCAPTION("Return Qty. to Receive");
        END;

        IF FINDSET THEN BEGIN
          ReservationEntry."Source Type" := DATABASE::"Sales Line";
          ReservationEntry."Source Subtype" := SalesHeader."Document Type";
          SignFactor := CreateReservEntry.SignFactor(ReservationEntry);
          REPEAT
            // Only Item where no SerialNo or LotNo is required
            GetItem(TempItemSalesLine);
            IF Item."Item Tracking Code" <> '' THEN BEGIN
              Inbound := (Quantity * SignFactor) > 0;
              ItemTrackingCode.Code := Item."Item Tracking Code";
              ItemTrackingManagement.GetItemTrackingSettings(ItemTrackingCode,
                ItemJnlLine."Entry Type"::Sale,Inbound,
                SNRequired,LotRequired,SNInfoRequired,LotInfoRequired);
              CheckSalesLine := NOT SNRequired AND NOT LotRequired;
              IF CheckSalesLine THEN
                CheckSalesLine := CheckTrackingExists(TempItemSalesLine);
            END ELSE
              CheckSalesLine := FALSE;

            TrackingQtyToHandle := 0;

            IF CheckSalesLine THEN BEGIN
              GetTrackingQuantities(TempItemSalesLine,TrackingQtyToHandle);
              TrackingQtyToHandle := TrackingQtyToHandle * SignFactor;
              IF SalesHeader.Ship THEN
                SalesLineQtyToHandle := "Qty. to Ship (Base)"
              ELSE
                SalesLineQtyToHandle := "Return Qty. to Receive (Base)";
              IF TrackingQtyToHandle <> SalesLineQtyToHandle THEN
                ERROR(STRSUBSTNO(ItemTrackQuantityMismatchErr,ErrorFieldCaption));
            END;
          UNTIL NEXT = 0;
        END;
      END;
    END;

    LOCAL PROCEDURE CheckTrackingExists@168(SalesLine@1000 : Record 37) : Boolean;
    VAR
      TrackingSpecification@1004 : Record 336;
      ReservEntry@1001 : Record 337;
    BEGIN
      TrackingSpecification.SetSourceFilter(
        DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.",TRUE);
      TrackingSpecification.SetSourceFilter2('',0);
      ReservEntry.SetSourceFilter(
        DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.",TRUE);
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

    LOCAL PROCEDURE GetTrackingQuantities@47(SalesLine@1000 : Record 37;VAR TrackingQtyToHandle@1003 : Decimal);
    VAR
      ReservEntry@1001 : Record 337;
    BEGIN
      ReservEntry.SetSourceFilter(
        DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.",TRUE);
      ReservEntry.SetSourceFilter2('',0);
      IF ReservEntry.FINDSET THEN
        REPEAT
          IF ReservEntry.TrackingExists THEN
            TrackingQtyToHandle := TrackingQtyToHandle + ReservEntry."Qty. to Handle (Base)";
        UNTIL ReservEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE SaveInvoiceSpecification@37(VAR TempInvoicingSpecification@1000 : TEMPORARY Record 336);
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

    LOCAL PROCEDURE InsertTrackingSpecification@35(SalesHeader@1001 : Record 36);
    BEGIN
      IF NOT TempTrackingSpecification.ISEMPTY THEN BEGIN
        TempTrackingSpecification.InsertSpecification;
        ReserveSalesLine.UpdateItemTrackingAfterPosting(SalesHeader);
      END;
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

    LOCAL PROCEDURE PostItemCharge@42(SalesHeader@1010 : Record 36;VAR SalesLine@1005 : Record 37;ItemEntryNo@1004 : Integer;QuantityBase@1003 : Decimal;AmountToAssign@1002 : Decimal;QtyToAssign@1001 : Decimal);
    VAR
      DummyTrackingSpecification@1000 : Record 336;
      SalesLineToPost@1006 : Record 37;
      CurrExchRate@1007 : Record 330;
    BEGIN
      WITH TempItemChargeAssgntSales DO BEGIN
        SalesLineToPost := SalesLine;
        SalesLineToPost."No." := "Item No.";
        SalesLineToPost."Appl.-to Item Entry" := ItemEntryNo;
        IF NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) THEN
          SalesLineToPost.Amount := -AmountToAssign
        ELSE
          SalesLineToPost.Amount := AmountToAssign;

        IF SalesLineToPost."Currency Code" <> '' THEN
          SalesLineToPost."Unit Cost" := ROUND(
              -SalesLineToPost.Amount / QuantityBase,Currency."Unit-Amount Rounding Precision")
        ELSE
          SalesLineToPost."Unit Cost" := ROUND(
              -SalesLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");
        TotalChargeAmt := TotalChargeAmt + SalesLineToPost.Amount;

        IF SalesHeader."Currency Code" <> '' THEN
          SalesLineToPost.Amount :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              UseDate,SalesHeader."Currency Code",TotalChargeAmt,SalesHeader."Currency Factor");
        SalesLineToPost."Inv. Discount Amount" := ROUND(
            SalesLine."Inv. Discount Amount" / SalesLine.Quantity * QtyToAssign,
            GLSetup."Amount Rounding Precision");
        SalesLineToPost."Line Discount Amount" := ROUND(
            SalesLine."Line Discount Amount" / SalesLine.Quantity * QtyToAssign,
            GLSetup."Amount Rounding Precision");
        SalesLineToPost."Line Amount" := ROUND(
            SalesLine."Line Amount" / SalesLine.Quantity * QtyToAssign,
            GLSetup."Amount Rounding Precision");
        SalesLine."Inv. Discount Amount" := SalesLine."Inv. Discount Amount" - SalesLineToPost."Inv. Discount Amount";
        SalesLine."Line Discount Amount" := SalesLine."Line Discount Amount" - SalesLineToPost."Line Discount Amount";
        SalesLine."Line Amount" := SalesLine."Line Amount" - SalesLineToPost."Line Amount";
        SalesLine.Quantity := SalesLine.Quantity - QtyToAssign;
        SalesLineToPost.Amount := ROUND(SalesLineToPost.Amount,GLSetup."Amount Rounding Precision") - TotalChargeAmtLCY;
        IF SalesHeader."Currency Code" <> '' THEN
          TotalChargeAmtLCY := TotalChargeAmtLCY + SalesLineToPost.Amount;
        SalesLineToPost."Unit Cost (LCY)" := ROUND(
            SalesLineToPost.Amount / QuantityBase,GLSetup."Unit-Amount Rounding Precision");
        UpdateSalesLineDimSetIDFromAppliedEntry(SalesLineToPost,SalesLine);
        SalesLineToPost."Line No." := "Document Line No.";
        PostItemJnlLine(
          SalesHeader,SalesLineToPost,
          0,0,-QuantityBase,-QuantityBase,
          SalesLineToPost."Appl.-to Item Entry",
          "Item Charge No.",DummyTrackingSpecification,FALSE);
      END;
    END;

    LOCAL PROCEDURE SaveTempWhseSplitSpec@31(VAR SalesLine3@1000 : Record 37;VAR TempSrcTrackingSpec@1001 : TEMPORARY Record 336);
    BEGIN
      TempWhseSplitSpecification.RESET;
      TempWhseSplitSpecification.DELETEALL;
      IF TempSrcTrackingSpec.FINDSET THEN
        REPEAT
          TempWhseSplitSpecification := TempSrcTrackingSpec;
          TempWhseSplitSpecification.SetSource(
            DATABASE::"Sales Line",SalesLine3."Document Type",SalesLine3."Document No.",SalesLine3."Line No.",'',0);
          TempWhseSplitSpecification.INSERT;
        UNTIL TempSrcTrackingSpec.NEXT = 0;
    END;

    LOCAL PROCEDURE TransferReservToItemJnlLine@32(VAR SalesOrderLine@1000 : Record 37;VAR ItemJnlLine@1001 : Record 83;QtyToBeShippedBase@1002 : Decimal;VAR TempTrackingSpecification2@1003 : TEMPORARY Record 336;VAR CheckApplFromItemEntry@1004 : Boolean);
    VAR
      RemainingQuantity@1005 : Decimal;
    BEGIN
      // Handle Item Tracking and reservations, also on drop shipment
      IF QtyToBeShippedBase = 0 THEN
        EXIT;

      CLEAR(ReserveSalesLine);
      IF NOT SalesOrderLine."Drop Shipment" THEN
        IF NOT HasSpecificTracking(SalesOrderLine."No.") AND HasInvtPickLine(SalesOrderLine) THEN
          ReserveSalesLine.TransferSalesLineToItemJnlLine(
            SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,TRUE)
        ELSE
          ReserveSalesLine.TransferSalesLineToItemJnlLine(
            SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,FALSE)
      ELSE BEGIN
        ReserveSalesLine.SetApplySpecificItemTracking(TRUE);
        TempTrackingSpecification2.RESET;
        TempTrackingSpecification2.SetSourceFilter(
          DATABASE::"Purchase Line",1,SalesOrderLine."Purchase Order No.",SalesOrderLine."Purch. Order Line No.",FALSE);
        TempTrackingSpecification2.SetSourceFilter2('',0);
        IF TempTrackingSpecification2.ISEMPTY THEN
          ReserveSalesLine.TransferSalesLineToItemJnlLine(
            SalesOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry,FALSE)
        ELSE BEGIN
          ReserveSalesLine.SetOverruleItemTracking(TRUE);
          ReserveSalesLine.SetItemTrkgAlreadyOverruled(ItemTrkgAlreadyOverruled);
          TempTrackingSpecification2.FINDSET;
          IF TempTrackingSpecification2."Quantity (Base)" / QtyToBeShippedBase < 0 THEN
            ERROR(ItemTrackingWrongSignErr);
          REPEAT
            ItemJnlLine.CopyTrackingFromSpec(TempTrackingSpecification2);
            ItemJnlLine."Applies-to Entry" := TempTrackingSpecification2."Item Ledger Entry No.";
            RemainingQuantity :=
              ReserveSalesLine.TransferSalesLineToItemJnlLine(
                SalesOrderLine,ItemJnlLine,TempTrackingSpecification2."Quantity (Base)",CheckApplFromItemEntry,FALSE);
            IF RemainingQuantity <> 0 THEN
              ERROR(ItemTrackingMismatchErr);
          UNTIL TempTrackingSpecification2.NEXT = 0;
          ItemJnlLine.ClearTracking;
          ItemJnlLine."Applies-to Entry" := 0;
        END;
      END;
    END;

    LOCAL PROCEDURE TransferReservFromPurchLine@41(VAR PurchOrderLine@1000 : Record 39;VAR ItemJnlLine@1001 : Record 83;SalesLine@1008 : Record 37;QtyToBeShippedBase@1002 : Decimal);
    VAR
      ReservEntry@1004 : Record 337;
      TempTrackingSpecification2@1005 : TEMPORARY Record 336;
      ReservePurchLine@1003 : Codeunit 99000834;
      RemainingQuantity@1006 : Decimal;
      CheckApplToItemEntry@1007 : Boolean;
    BEGIN
      // Handle Item Tracking on Drop Shipment
      ItemTrkgAlreadyOverruled := FALSE;
      IF QtyToBeShippedBase = 0 THEN
        EXIT;

      ReservEntry.SetSourceFilter(
        DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.",TRUE);
      ReservEntry.SetSourceFilter2('',0);
      ReservEntry.SETFILTER("Qty. to Handle (Base)",'<>0');
      IF NOT ReservEntry.ISEMPTY THEN
        ItemTrackingMgt.SumUpItemTracking(ReservEntry,TempTrackingSpecification2,FALSE,TRUE);
      TempTrackingSpecification2.SETFILTER("Qty. to Handle (Base)",'<>0');
      IF TempTrackingSpecification2.ISEMPTY THEN BEGIN
        ReserveSalesLine.SetApplySpecificItemTracking(TRUE);
        ReservePurchLine.TransferPurchLineToItemJnlLine(
          PurchOrderLine,ItemJnlLine,QtyToBeShippedBase,CheckApplToItemEntry)
      END ELSE BEGIN
        ReservePurchLine.SetOverruleItemTracking(TRUE);
        ItemTrkgAlreadyOverruled := TRUE;
        TempTrackingSpecification2.FINDSET;
        IF -TempTrackingSpecification2."Quantity (Base)" / QtyToBeShippedBase < 0 THEN
          ERROR(ItemTrackingWrongSignErr);
        IF ReservePurchLine.ReservEntryExist(PurchOrderLine) THEN
          REPEAT
            ItemJnlLine.CopyTrackingFromSpec(TempTrackingSpecification2);
            RemainingQuantity :=
              ReservePurchLine.TransferPurchLineToItemJnlLine(
                PurchOrderLine,ItemJnlLine,
                -TempTrackingSpecification2."Qty. to Handle (Base)",CheckApplToItemEntry);
            IF RemainingQuantity <> 0 THEN
              ERROR(ItemTrackingMismatchErr);
          UNTIL TempTrackingSpecification2.NEXT = 0;
        ItemJnlLine.ClearTracking;
        ItemJnlLine."Applies-to Entry" := 0;
      END;
    END;

    [External]
    PROCEDURE SetWhseRcptHeader@43(VAR WhseRcptHeader2@1000 : Record 7316);
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

    LOCAL PROCEDURE GetItem@49(SalesLine@1000 : Record 37);
    BEGIN
      WITH SalesLine DO BEGIN
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        IF "No." <> Item."No." THEN
          Item.GET("No.");
      END;
    END;

    LOCAL PROCEDURE GetNextSalesline@50(VAR SalesLine@1000 : Record 37) : Boolean;
    BEGIN
      IF NOT SalesLinesProcessed THEN
        IF SalesLine.NEXT = 1 THEN
          EXIT(FALSE);
      SalesLinesProcessed := TRUE;
      IF TempPrepaymentSalesLine.FIND('-') THEN BEGIN
        SalesLine := TempPrepaymentSalesLine;
        TempPrepaymentSalesLine.DELETE;
        EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreatePrepaymentLines@51(SalesHeader@1003 : Record 36;VAR TempPrepmtSalesLine@1004 : Record 37;CompleteFunctionality@1009 : Boolean);
    VAR
      GLAcc@1002 : Record 15;
      TempSalesLine@1000 : TEMPORARY Record 37;
      TempExtTextLine@1012 : TEMPORARY Record 280;
      GenPostingSetup@1005 : Record 252;
      TransferExtText@1011 : Codeunit 378;
      NextLineNo@1001 : Integer;
      Fraction@1008 : Decimal;
      VATDifference@1015 : Decimal;
      TempLineFound@1010 : Boolean;
      PrepmtAmtToDeduct@1016 : Decimal;
    BEGIN
      GetGLSetup;
      WITH TempSalesLine DO BEGIN
        FillTempLines(SalesHeader);
        ResetTempLines(TempSalesLine);
        IF NOT FINDLAST THEN
          EXIT;
        NextLineNo := "Line No." + 10000;
        SETFILTER(Quantity,'>0');
        SETFILTER("Qty. to Invoice",'>0');
        TempPrepmtSalesLine.SetHasBeenShown;
        IF FINDSET THEN BEGIN
          IF CompleteFunctionality AND ("Document Type" = "Document Type"::Invoice) THEN
            TestGetShipmentPPmtAmtToDeduct;
          REPEAT
            IF CompleteFunctionality THEN
              IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice THEN BEGIN
                IF NOT SalesHeader.Ship AND ("Qty. to Invoice" = Quantity - "Quantity Invoiced") THEN
                  IF "Qty. Shipped Not Invoiced" < "Qty. to Invoice" THEN
                    VALIDATE("Qty. to Invoice","Qty. Shipped Not Invoiced");
                Fraction := ("Qty. to Invoice" + "Quantity Invoiced") / Quantity;

                IF "Prepayment %" <> 100 THEN
                  CASE TRUE OF
                    ("Prepmt Amt to Deduct" <> 0) AND
                    ("Prepmt Amt to Deduct" > ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision")):
                      FIELDERROR(
                        "Prepmt Amt to Deduct",
                        STRSUBSTNO(CannotBeGreaterThanErr,
                          ROUND(Fraction * "Line Amount",Currency."Amount Rounding Precision")));
                    ("Prepmt. Amt. Inv." <> 0) AND
                    (ROUND((1 - Fraction) * "Line Amount",Currency."Amount Rounding Precision") <
                     ROUND(
                       ROUND(
                         ROUND("Unit Price" * (Quantity - "Quantity Invoiced" - "Qty. to Invoice"),
                           Currency."Amount Rounding Precision") *
                         (1 - ("Line Discount %" / 100)),Currency."Amount Rounding Precision") *
                       "Prepayment %" / 100,Currency."Amount Rounding Precision")):
                      FIELDERROR(
                        "Prepmt Amt to Deduct",
                        STRSUBSTNO(CannotBeSmallerThanErr,
                          ROUND(
                            "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - (1 - Fraction) * "Line Amount",
                            Currency."Amount Rounding Precision")));
                  END;
              END;
            IF "Prepmt Amt to Deduct" <> 0 THEN BEGIN
              IF ("Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
                 ("Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
              THEN
                GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
              GLAcc.GET(GenPostingSetup.GetSalesPrepmtAccount);
              TempLineFound := FALSE;
              IF SalesHeader."Compress Prepayment" THEN BEGIN
                TempPrepmtSalesLine.SETRANGE("No.",GLAcc."No.");
                TempPrepmtSalesLine.SETRANGE("Dimension Set ID","Dimension Set ID");
                TempLineFound := TempPrepmtSalesLine.FINDFIRST;
              END;
              IF TempLineFound THEN BEGIN
                PrepmtAmtToDeduct :=
                  TempPrepmtSalesLine."Prepmt Amt to Deduct" +
                  InsertedPrepmtVATBaseToDeduct(
                    SalesHeader,TempSalesLine,TempPrepmtSalesLine."Line No.",TempPrepmtSalesLine."Unit Price");
                VATDifference := TempPrepmtSalesLine."VAT Difference";
                TempPrepmtSalesLine.VALIDATE(
                  "Unit Price",TempPrepmtSalesLine."Unit Price" + "Prepmt Amt to Deduct");
                TempPrepmtSalesLine.VALIDATE("VAT Difference",VATDifference - "Prepmt VAT Diff. to Deduct");
                TempPrepmtSalesLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                IF "Prepayment %" < TempPrepmtSalesLine."Prepayment %" THEN
                  TempPrepmtSalesLine."Prepayment %" := "Prepayment %";
                TempPrepmtSalesLine.MODIFY;
              END ELSE BEGIN
                TempPrepmtSalesLine.INIT;
                TempPrepmtSalesLine."Document Type" := SalesHeader."Document Type";
                TempPrepmtSalesLine."Document No." := SalesHeader."No.";
                TempPrepmtSalesLine."Line No." := 0;
                TempPrepmtSalesLine."System-Created Entry" := TRUE;
                IF CompleteFunctionality THEN
                  TempPrepmtSalesLine.VALIDATE(Type,TempPrepmtSalesLine.Type::"G/L Account")
                ELSE
                  TempPrepmtSalesLine.Type := TempPrepmtSalesLine.Type::"G/L Account";
                TempPrepmtSalesLine.VALIDATE("No.",GenPostingSetup."Sales Prepayments Account");
                TempPrepmtSalesLine.VALIDATE(Quantity,-1);
                TempPrepmtSalesLine."Qty. to Ship" := TempPrepmtSalesLine.Quantity;
                TempPrepmtSalesLine."Qty. to Invoice" := TempPrepmtSalesLine.Quantity;
                PrepmtAmtToDeduct := InsertedPrepmtVATBaseToDeduct(SalesHeader,TempSalesLine,NextLineNo,0);
                TempPrepmtSalesLine.VALIDATE("Unit Price","Prepmt Amt to Deduct");
                TempPrepmtSalesLine.VALIDATE("VAT Difference",-"Prepmt VAT Diff. to Deduct");
                TempPrepmtSalesLine."Prepmt Amt to Deduct" := PrepmtAmtToDeduct;
                TempPrepmtSalesLine."Prepayment %" := "Prepayment %";
                TempPrepmtSalesLine."Prepayment Line" := TRUE;
                TempPrepmtSalesLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                TempPrepmtSalesLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                TempPrepmtSalesLine."Dimension Set ID" := "Dimension Set ID";
                TempPrepmtSalesLine."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 10000;
                TempPrepmtSalesLine.INSERT;

                TransferExtText.PrepmtGetAnyExtText(
                  TempPrepmtSalesLine."No.",DATABASE::"Sales Invoice Line",
                  SalesHeader."Document Date",SalesHeader."Language Code",TempExtTextLine);
                IF TempExtTextLine.FIND('-') THEN
                  REPEAT
                    TempPrepmtSalesLine.INIT;
                    TempPrepmtSalesLine.Description := TempExtTextLine.Text;
                    TempPrepmtSalesLine."System-Created Entry" := TRUE;
                    TempPrepmtSalesLine."Prepayment Line" := TRUE;
                    TempPrepmtSalesLine."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 10000;
                    TempPrepmtSalesLine.INSERT;
                  UNTIL TempExtTextLine.NEXT = 0;
              END;
            END;
          UNTIL NEXT = 0
        END;
      END;
      DividePrepmtAmountLCY(TempPrepmtSalesLine,SalesHeader);
    END;

    LOCAL PROCEDURE InsertedPrepmtVATBaseToDeduct@82(SalesHeader@1004 : Record 36;SalesLine@1000 : Record 37;PrepmtLineNo@1001 : Integer;TotalPrepmtAmtToDeduct@1002 : Decimal) : Decimal;
    VAR
      PrepmtVATBaseToDeduct@1003 : Decimal;
    BEGIN
      WITH SalesLine DO BEGIN
        IF SalesHeader."Prices Including VAT" THEN
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
      WITH TempPrepmtDeductLCYSalesLine DO BEGIN
        TempPrepmtDeductLCYSalesLine := SalesLine;
        IF "Document Type" = "Document Type"::Order THEN
          "Qty. to Invoice" := GetQtyToInvoice(SalesLine,SalesHeader.Ship)
        ELSE
          GetLineDataFromOrder(TempPrepmtDeductLCYSalesLine);
        CalcPrepaymentToDeduct;
        "Line Amount" := GetLineAmountToHandle("Qty. to Invoice");
        "Attached to Line No." := PrepmtLineNo;
        "VAT Base Amount" := PrepmtVATBaseToDeduct;
        INSERT;
      END;
      EXIT(PrepmtVATBaseToDeduct);
    END;

    LOCAL PROCEDURE DividePrepmtAmountLCY@83(VAR PrepmtSalesLine@1000 : Record 37;SalesHeader@1006 : Record 36);
    VAR
      CurrExchRate@1001 : Record 330;
      ActualCurrencyFactor@1002 : Decimal;
    BEGIN
      WITH PrepmtSalesLine DO BEGIN
        RESET;
        SETFILTER(Type,'<>%1',Type::" ");
        IF FINDSET THEN
          REPEAT
            IF SalesHeader."Currency Code" <> '' THEN
              ActualCurrencyFactor :=
                ROUND(
                  CurrExchRate.ExchangeAmtFCYToLCY(
                    SalesHeader."Posting Date",
                    SalesHeader."Currency Code",
                    "Prepmt Amt to Deduct",
                    SalesHeader."Currency Factor")) /
                "Prepmt Amt to Deduct"
            ELSE
              ActualCurrencyFactor := 1;

            UpdatePrepmtAmountInvBuf("Line No.",ActualCurrencyFactor);
          UNTIL NEXT = 0;
        RESET;
      END;
    END;

    LOCAL PROCEDURE UpdatePrepmtAmountInvBuf@92(PrepmtSalesLineNo@1000 : Integer;CurrencyFactor@1004 : Decimal);
    VAR
      PrepmtAmtRemainder@1002 : Decimal;
    BEGIN
      WITH TempPrepmtDeductLCYSalesLine DO BEGIN
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

    LOCAL PROCEDURE AdjustPrepmtAmountLCY@84(SalesHeader@1006 : Record 36;VAR PrepmtSalesLine@1000 : Record 37);
    VAR
      SalesLine@1005 : Record 37;
      SalesInvoiceLine@1013 : Record 37;
      DeductionFactor@1001 : Decimal;
      PrepmtVATPart@1009 : Decimal;
      PrepmtVATAmtRemainder@1010 : Decimal;
      TotalRoundingAmount@1011 : ARRAY [2] OF Decimal;
      TotalPrepmtAmount@1002 : ARRAY [2] OF Decimal;
      FinalInvoice@1003 : Boolean;
      PricesInclVATRoundingAmount@1004 : ARRAY [2] OF Decimal;
    BEGIN
      IF PrepmtSalesLine."Prepayment Line" THEN BEGIN
        PrepmtVATPart :=
          (PrepmtSalesLine."Amount Including VAT" - PrepmtSalesLine.Amount) / PrepmtSalesLine."Unit Price";

        WITH TempPrepmtDeductLCYSalesLine DO BEGIN
          RESET;
          SETRANGE("Attached to Line No.",PrepmtSalesLine."Line No.");
          IF FINDSET(TRUE) THEN BEGIN
            FinalInvoice := IsFinalInvoice;
            REPEAT
              SalesLine := TempPrepmtDeductLCYSalesLine;
              SalesLine.FIND;
              IF "Document Type" = "Document Type"::Invoice THEN BEGIN
                SalesInvoiceLine := SalesLine;
                GetSalesOrderLine(SalesLine,SalesInvoiceLine);
                SalesLine."Qty. to Invoice" := SalesInvoiceLine."Qty. to Invoice";
              END;
              IF SalesLine."Qty. to Invoice" <> "Qty. to Invoice" THEN
                SalesLine."Prepmt Amt to Deduct" := CalcPrepmtAmtToDeduct(SalesLine,SalesHeader.Ship);
              DeductionFactor :=
                SalesLine."Prepmt Amt to Deduct" /
                (SalesLine."Prepmt. Amt. Inv." - SalesLine."Prepmt Amt Deducted");

              "Prepmt. VAT Amount Inv. (LCY)" :=
                CalcRoundedAmount(SalesLine."Prepmt Amt to Deduct" * PrepmtVATPart,PrepmtVATAmtRemainder);
              IF ("Prepayment %" <> 100) OR IsFinalInvoice OR ("Currency Code" <> '') THEN
                CalcPrepmtRoundingAmounts(TempPrepmtDeductLCYSalesLine,SalesLine,DeductionFactor,TotalRoundingAmount);
              MODIFY;

              IF SalesHeader."Prices Including VAT" THEN
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

        UpdatePrepmtSalesLineWithRounding(
          PrepmtSalesLine,TotalRoundingAmount,TotalPrepmtAmount,
          FinalInvoice,PricesInclVATRoundingAmount);
      END;
    END;

    LOCAL PROCEDURE CalcPrepmtAmtToDeduct@93(SalesLine@1000 : Record 37;Ship@1001 : Boolean) : Decimal;
    BEGIN
      WITH SalesLine DO BEGIN
        "Qty. to Invoice" := GetQtyToInvoice(SalesLine,Ship);
        CalcPrepaymentToDeduct;
        EXIT("Prepmt Amt to Deduct");
      END;
    END;

    LOCAL PROCEDURE GetQtyToInvoice@100(SalesLine@1000 : Record 37;Ship@1002 : Boolean) : Decimal;
    VAR
      AllowedQtyToInvoice@1001 : Decimal;
    BEGIN
      WITH SalesLine DO BEGIN
        AllowedQtyToInvoice := "Qty. Shipped Not Invoiced";
        IF Ship THEN
          AllowedQtyToInvoice := AllowedQtyToInvoice + "Qty. to Ship";
        IF "Qty. to Invoice" > AllowedQtyToInvoice THEN
          EXIT(AllowedQtyToInvoice);
        EXIT("Qty. to Invoice");
      END;
    END;

    LOCAL PROCEDURE GetLineDataFromOrder@94(VAR SalesLine@1000 : Record 37);
    VAR
      SalesShptLine@1001 : Record 111;
      SalesOrderLine@1002 : Record 37;
    BEGIN
      WITH SalesLine DO BEGIN
        SalesShptLine.GET("Shipment No.","Shipment Line No.");
        SalesOrderLine.GET("Document Type"::Order,SalesShptLine."Order No.",SalesShptLine."Order Line No.");

        Quantity := SalesOrderLine.Quantity;
        "Qty. Shipped Not Invoiced" := SalesOrderLine."Qty. Shipped Not Invoiced";
        "Quantity Invoiced" := SalesOrderLine."Quantity Invoiced";
        "Prepmt Amt Deducted" := SalesOrderLine."Prepmt Amt Deducted";
        "Prepmt. Amt. Inv." := SalesOrderLine."Prepmt. Amt. Inv.";
        "Line Discount Amount" := SalesOrderLine."Line Discount Amount";
      END;
    END;

    LOCAL PROCEDURE CalcPrepmtRoundingAmounts@79(VAR PrepmtSalesLineBuf@1000 : Record 37;SalesLine@1003 : Record 37;DeductionFactor@1001 : Decimal;VAR TotalRoundingAmount@1002 : ARRAY [2] OF Decimal);
    VAR
      RoundingAmount@1004 : ARRAY [2] OF Decimal;
    BEGIN
      WITH PrepmtSalesLineBuf DO BEGIN
        IF "VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT" THEN BEGIN
          RoundingAmount[1] :=
            "Prepmt. Amount Inv. (LCY)" - ROUND(DeductionFactor * SalesLine."Prepmt. Amount Inv. (LCY)");
          "Prepmt. Amount Inv. (LCY)" := "Prepmt. Amount Inv. (LCY)" - RoundingAmount[1];
          TotalRoundingAmount[1] += RoundingAmount[1];
        END;
        RoundingAmount[2] :=
          "Prepmt. VAT Amount Inv. (LCY)" - ROUND(DeductionFactor * SalesLine."Prepmt. VAT Amount Inv. (LCY)");
        "Prepmt. VAT Amount Inv. (LCY)" := "Prepmt. VAT Amount Inv. (LCY)" - RoundingAmount[2];
        TotalRoundingAmount[2] += RoundingAmount[2];
      END;
    END;

    LOCAL PROCEDURE UpdatePrepmtSalesLineWithRounding@89(VAR PrepmtSalesLine@1002 : Record 37;TotalRoundingAmount@1001 : ARRAY [2] OF Decimal;TotalPrepmtAmount@1000 : ARRAY [2] OF Decimal;FinalInvoice@1005 : Boolean;PricesInclVATRoundingAmount@1006 : ARRAY [2] OF Decimal);
    VAR
      AdjustAmount@1008 : Boolean;
      NewAmountIncludingVAT@1003 : Decimal;
      Prepmt100PctVATRoundingAmt@1004 : Decimal;
      AmountRoundingPrecision@1007 : Decimal;
    BEGIN
      WITH PrepmtSalesLine DO BEGIN
        NewAmountIncludingVAT := TotalPrepmtAmount[1] + TotalPrepmtAmount[2] + TotalRoundingAmount[1] + TotalRoundingAmount[2];
        IF "Prepayment %" = 100 THEN
          TotalRoundingAmount[1] += "Amount Including VAT" - NewAmountIncludingVAT;
        AmountRoundingPrecision :=
          GetAmountRoundingPrecisionInLCY("Document Type","Document No.","Currency Code");

        IF (ABS(TotalRoundingAmount[1]) <= AmountRoundingPrecision) AND
           (ABS(TotalRoundingAmount[2]) <= AmountRoundingPrecision)
        THEN BEGIN
          IF "Prepayment %" = 100 THEN
            Prepmt100PctVATRoundingAmt := TotalRoundingAmount[1];
          TotalRoundingAmount[1] := 0;
        END;
        "Prepmt. Amount Inv. (LCY)" := TotalRoundingAmount[1];
        Amount := TotalPrepmtAmount[1] + TotalRoundingAmount[1];

        IF (PricesInclVATRoundingAmount[1] <> 0) AND (TotalRoundingAmount[1] = 0) THEN BEGIN
          IF ("Prepayment %" = 100) AND FinalInvoice AND
             (Amount + TotalPrepmtAmount[2] = "Amount Including VAT")
          THEN
            Prepmt100PctVATRoundingAmt := 0;
          PricesInclVATRoundingAmount[1] := 0;
        END;

        IF ((TotalRoundingAmount[2] <> 0) OR FinalInvoice) AND (TotalRoundingAmount[1] = 0) THEN BEGIN
          IF ("Prepayment %" = 100) AND ("Prepmt. Amount Inv. (LCY)" = 0) THEN
            Prepmt100PctVATRoundingAmt += TotalRoundingAmount[2];
          IF ("Prepayment %" = 100) OR FinalInvoice THEN
            TotalRoundingAmount[2] := 0;
        END;

        IF (PricesInclVATRoundingAmount[2] <> 0) AND (TotalRoundingAmount[2] = 0) THEN BEGIN
          IF ABS(Prepmt100PctVATRoundingAmt) <= AmountRoundingPrecision THEN
            Prepmt100PctVATRoundingAmt := 0;
          PricesInclVATRoundingAmount[2] := 0;
        END;

        "Prepmt. VAT Amount Inv. (LCY)" := TotalRoundingAmount[2] + Prepmt100PctVATRoundingAmt;
        NewAmountIncludingVAT := Amount + TotalPrepmtAmount[2] + TotalRoundingAmount[2];
        IF (PricesInclVATRoundingAmount[1] = 0) AND (PricesInclVATRoundingAmount[2] = 0) OR
           ("Currency Code" <> '') AND FinalInvoice
        THEN
          Increment(
            TotalSalesLineLCY."Amount Including VAT",
            "Amount Including VAT" - NewAmountIncludingVAT - Prepmt100PctVATRoundingAmt);
        IF "Currency Code" = '' THEN
          TotalSalesLine."Amount Including VAT" := TotalSalesLineLCY."Amount Including VAT";
        "Amount Including VAT" := NewAmountIncludingVAT;

        IF FinalInvoice THEN
          AdjustAmount :=
            (TotalSalesLine.Amount = 0) AND (TotalSalesLine."Amount Including VAT" <> 0) AND
            (ABS(TotalSalesLine."Amount Including VAT") <= Currency."Amount Rounding Precision")
        ELSE
          AdjustAmount := (TotalSalesLine.Amount < 0) AND (TotalSalesLine."Amount Including VAT" < 0);
        IF AdjustAmount THEN BEGIN
          "Amount Including VAT" += TotalSalesLineLCY."Amount Including VAT";
          TotalSalesLine."Amount Including VAT" := 0;
          TotalSalesLineLCY."Amount Including VAT" := 0;
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

    LOCAL PROCEDURE GetSalesOrderLine@85(VAR SalesOrderLine@1000 : Record 37;SalesLine@1001 : Record 37);
    VAR
      SalesShptLine@1002 : Record 111;
    BEGIN
      SalesShptLine.GET(SalesLine."Shipment No.",SalesLine."Shipment Line No.");
      SalesOrderLine.GET(
        SalesOrderLine."Document Type"::Order,
        SalesShptLine."Order No.",SalesShptLine."Order Line No.");
      SalesOrderLine."Prepmt Amt to Deduct" := SalesLine."Prepmt Amt to Deduct";
    END;

    LOCAL PROCEDURE DecrementPrepmtAmtInvLCY@86(SalesLine@1000 : Record 37;VAR PrepmtAmountInvLCY@1001 : Decimal;VAR PrepmtVATAmountInvLCY@1002 : Decimal);
    BEGIN
      TempPrepmtDeductLCYSalesLine.RESET;
      TempPrepmtDeductLCYSalesLine := SalesLine;
      IF TempPrepmtDeductLCYSalesLine.FIND THEN BEGIN
        PrepmtAmountInvLCY := PrepmtAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt. Amount Inv. (LCY)";
        PrepmtVATAmountInvLCY := PrepmtVATAmountInvLCY - TempPrepmtDeductLCYSalesLine."Prepmt. VAT Amount Inv. (LCY)";
      END;
    END;

    LOCAL PROCEDURE AdjustFinalInvWith100PctPrepmt@97(VAR CombinedSalesLine@1000 : Record 37);
    VAR
      DiffToLineDiscAmt@1001 : Decimal;
    BEGIN
      WITH TempPrepmtDeductLCYSalesLine DO BEGIN
        RESET;
        SETRANGE("Prepayment %",100);
        IF FINDSET(TRUE) THEN
          REPEAT
            IF IsFinalInvoice THEN BEGIN
              DiffToLineDiscAmt := "Prepmt Amt to Deduct" - "Line Amount";
              IF "Document Type" = "Document Type"::Order THEN
                DiffToLineDiscAmt := DiffToLineDiscAmt * Quantity / "Qty. to Invoice";
              IF DiffToLineDiscAmt <> 0 THEN BEGIN
                CombinedSalesLine.GET("Document Type","Document No.","Line No.");
                CombinedSalesLine."Line Discount Amount" -= DiffToLineDiscAmt;
                CombinedSalesLine.MODIFY;

                "Line Discount Amount" := CombinedSalesLine."Line Discount Amount";
                MODIFY;
              END;
            END;
          UNTIL NEXT = 0;
        RESET;
      END;
    END;

    LOCAL PROCEDURE GetPrepmtDiffToLineAmount@98(SalesLine@1000 : Record 37) : Decimal;
    BEGIN
      WITH TempPrepmtDeductLCYSalesLine DO
        IF SalesLine."Prepayment %" = 100 THEN
          IF GET(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.") THEN
            EXIT("Prepmt Amt to Deduct" + "Inv. Discount Amount" - "Line Amount");
      EXIT(0);
    END;

    LOCAL PROCEDURE MergeSaleslines@52(SalesHeader@1000000004 : Record 36;VAR SalesLine@1000 : Record 37;VAR SalesLine2@1000000002 : Record 37;VAR MergedSalesLine@1000000003 : Record 37);
    BEGIN
      WITH SalesLine DO BEGIN
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        IF FIND('-') THEN
          REPEAT
            MergedSalesLine := SalesLine;
            MergedSalesLine.INSERT;
          UNTIL NEXT = 0;
      END;
      WITH SalesLine2 DO BEGIN
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        IF FIND('-') THEN
          REPEAT
            MergedSalesLine := SalesLine2;
            MergedSalesLine.INSERT;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE PostJobContractLine@54(SalesHeader@1001 : Record 36;SalesLine@1000 : Record 37);
    BEGIN
      IF SalesLine."Job Contract Entry No." = 0 THEN
        EXIT;
      IF (SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice) AND
         (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Credit Memo")
      THEN
        SalesLine.TESTFIELD("Job Contract Entry No.",0);

      SalesLine.TESTFIELD("Job No.");
      SalesLine.TESTFIELD("Job Task No.");

      IF SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice THEN
        SalesLine."Document No." := SalesInvHeader."No.";
      IF SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" THEN
        SalesLine."Document No." := SalesCrMemoHeader."No.";
      JobContractLine := TRUE;
      JobPostLine.PostInvoiceContractLine(SalesHeader,SalesLine);
    END;

    LOCAL PROCEDURE InsertICGenJnlLine@150(SalesHeader@1005 : Record 36;SalesLine@1000 : Record 37;VAR ICGenJnlLineNo@1006 : Integer);
    VAR
      ICGLAccount@1001 : Record 410;
      Vend@1002 : Record 23;
      ICPartner@1003 : Record 413;
      CurrExchRate@1004 : Record 330;
      GenJnlLine@1007 : Record 81;
    BEGIN
      SalesHeader.TESTFIELD("Sell-to IC Partner Code",'');
      SalesHeader.TESTFIELD("Bill-to IC Partner Code",'');
      SalesLine.TESTFIELD("IC Partner Ref. Type",SalesLine."IC Partner Ref. Type"::"G/L Account");
      ICGLAccount.GET(SalesLine."IC Partner Reference");
      ICGenJnlLineNo := ICGenJnlLineNo + 1;

      WITH TempICGenJnlLine DO BEGIN
        InitNewLine(
          SalesHeader."Posting Date",SalesHeader."Document Date",SalesHeader."Posting Description",
          SalesLine."Shortcut Dimension 1 Code",SalesLine."Shortcut Dimension 2 Code",SalesLine."Dimension Set ID",
          SalesHeader."Reason Code");
        "Line No." := ICGenJnlLineNo;

        CopyDocumentFields(GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,SalesHeader."Posting No. Series");

        VALIDATE("Account Type","Account Type"::"IC Partner");
        VALIDATE("Account No.",SalesLine."IC Partner Code");
        "Source Currency Code" := SalesHeader."Currency Code";
        "Source Currency Amount" := Amount;
        Correction := SalesHeader.Correction;
        "Country/Region Code" := SalesHeader."VAT Country/Region Code";
        "Source Type" := GenJnlLine."Source Type"::Customer;
        "Source No." := SalesHeader."Bill-to Customer No.";
        "Source Line No." := SalesLine."Line No.";
        VALIDATE("Bal. Account Type","Bal. Account Type"::"G/L Account");
        VALIDATE("Bal. Account No.",SalesLine."No.");

        Vend.SETRANGE("IC Partner Code",SalesLine."IC Partner Code");
        IF Vend.FINDFIRST THEN BEGIN
          VALIDATE("Bal. Gen. Bus. Posting Group",Vend."Gen. Bus. Posting Group");
          VALIDATE("Bal. VAT Bus. Posting Group",Vend."VAT Bus. Posting Group");
        END;
        VALIDATE("Bal. VAT Prod. Posting Group",SalesLine."VAT Prod. Posting Group");
        "IC Partner Code" := SalesLine."IC Partner Code";
        "IC Partner G/L Acc. No." := SalesLine."IC Partner Reference";
        "IC Direction" := "IC Direction"::Outgoing;
        ICPartner.GET(SalesLine."IC Partner Code");
        IF ICPartner."Cost Distribution in LCY" AND (SalesLine."Currency Code" <> '') THEN BEGIN
          "Currency Code" := '';
          "Currency Factor" := 0;
          Currency.GET(SalesLine."Currency Code");
          IF SalesHeader.IsCreditDocType THEN
            Amount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  SalesHeader."Posting Date",SalesLine."Currency Code",
                  SalesLine.Amount,SalesHeader."Currency Factor"))
          ELSE
            Amount :=
              -ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  SalesHeader."Posting Date",SalesLine."Currency Code",
                  SalesLine.Amount,SalesHeader."Currency Factor"));
        END ELSE BEGIN
          Currency.InitRoundingPrecision;
          "Currency Code" := SalesHeader."Currency Code";
          "Currency Factor" := SalesHeader."Currency Factor";
          IF SalesHeader.IsCreditDocType THEN
            Amount := SalesLine.Amount
          ELSE
            Amount := -SalesLine.Amount;
        END;
        IF "Bal. VAT %" <> 0 THEN
          Amount := ROUND(Amount * (1 + "Bal. VAT %" / 100),Currency."Amount Rounding Precision");
        VALIDATE(Amount);
        OnBeforeInsertICGenJnlLine(TempICGenJnlLine,SalesHeader,SalesLine);
        INSERT;
      END;
    END;

    LOCAL PROCEDURE PostICGenJnl@151();
    VAR
      ICInOutBoxMgt@1001 : Codeunit 427;
      ICTransactionNo@1000 : Integer;
    BEGIN
      TempICGenJnlLine.RESET;
      TempICGenJnlLine.SETFILTER(Amount,'<>%1',0);
      IF TempICGenJnlLine.FIND('-') THEN
        REPEAT
          ICTransactionNo := ICInOutBoxMgt.CreateOutboxJnlTransaction(TempICGenJnlLine,FALSE);
          ICInOutBoxMgt.CreateOutboxJnlLine(ICTransactionNo,1,TempICGenJnlLine);
          GenJnlPostLine.RunWithCheck(TempICGenJnlLine);
        UNTIL TempICGenJnlLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TestGetShipmentPPmtAmtToDeduct@29();
    VAR
      TempSalesLine@1004 : TEMPORARY Record 37;
      TempShippedSalesLine@1003 : TEMPORARY Record 37;
      TempTotalSalesLine@1007 : TEMPORARY Record 37;
      TempSalesShptLine@1009 : TEMPORARY Record 111;
      SalesShptLine@1002 : Record 111;
      MaxAmtToDeduct@1001 : Decimal;
    BEGIN
      WITH TempSalesLine DO BEGIN
        ResetTempLines(TempSalesLine);
        SETFILTER(Quantity,'>0');
        SETFILTER("Qty. to Invoice",'>0');
        SETFILTER("Shipment No.",'<>%1','');
        SETFILTER("Prepmt Amt to Deduct",'<>0');
        IF ISEMPTY THEN
          EXIT;

        SETRANGE("Prepmt Amt to Deduct");
        IF FINDSET THEN
          REPEAT
            IF SalesShptLine.GET("Shipment No.","Shipment Line No.") THEN BEGIN
              TempShippedSalesLine := TempSalesLine;
              TempShippedSalesLine.INSERT;
              TempSalesShptLine := SalesShptLine;
              IF TempSalesShptLine.INSERT THEN;

              IF NOT TempTotalSalesLine.GET("Document Type"::Order,SalesShptLine."Order No.",SalesShptLine."Order Line No.") THEN BEGIN
                TempTotalSalesLine.INIT;
                TempTotalSalesLine."Document Type" := "Document Type"::Order;
                TempTotalSalesLine."Document No." := SalesShptLine."Order No.";
                TempTotalSalesLine."Line No." := SalesShptLine."Order Line No.";
                TempTotalSalesLine.INSERT;
              END;
              TempTotalSalesLine."Qty. to Invoice" := TempTotalSalesLine."Qty. to Invoice" + "Qty. to Invoice";
              TempTotalSalesLine."Prepmt Amt to Deduct" := TempTotalSalesLine."Prepmt Amt to Deduct" + "Prepmt Amt to Deduct";
              AdjustInvLineWith100PctPrepmt(TempSalesLine,TempTotalSalesLine);
              TempTotalSalesLine.MODIFY;
            END;
          UNTIL NEXT = 0;

        IF TempShippedSalesLine.FINDSET THEN
          REPEAT
            IF TempSalesShptLine.GET(TempShippedSalesLine."Shipment No.",TempShippedSalesLine."Shipment Line No.") THEN
              IF GET(TempShippedSalesLine."Document Type"::Order,TempSalesShptLine."Order No.",TempSalesShptLine."Order Line No.") THEN
                IF TempTotalSalesLine.GET(
                     TempShippedSalesLine."Document Type"::Order,TempSalesShptLine."Order No.",TempSalesShptLine."Order Line No.")
                THEN BEGIN
                  MaxAmtToDeduct := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";

                  IF TempTotalSalesLine."Prepmt Amt to Deduct" > MaxAmtToDeduct THEN
                    ERROR(STRSUBSTNO(PrepAmountToDeductToBigErr,FIELDCAPTION("Prepmt Amt to Deduct"),MaxAmtToDeduct));

                  IF (TempTotalSalesLine."Qty. to Invoice" = Quantity - "Quantity Invoiced") AND
                     (TempTotalSalesLine."Prepmt Amt to Deduct" <> MaxAmtToDeduct)
                  THEN
                    ERROR(STRSUBSTNO(PrepAmountToDeductToSmallErr,FIELDCAPTION("Prepmt Amt to Deduct"),MaxAmtToDeduct));
                END;
          UNTIL TempShippedSalesLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE AdjustInvLineWith100PctPrepmt@99(VAR SalesInvoiceLine@1000 : Record 37;VAR TempTotalSalesLine@1001 : TEMPORARY Record 37);
    VAR
      SalesOrderLine@1003 : Record 37;
      DiffAmtToDeduct@1002 : Decimal;
    BEGIN
      IF SalesInvoiceLine."Prepayment %" = 100 THEN BEGIN
        SalesOrderLine := TempTotalSalesLine;
        SalesOrderLine.FIND;
        IF TempTotalSalesLine."Qty. to Invoice" = SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced" THEN BEGIN
          DiffAmtToDeduct :=
            SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted" - TempTotalSalesLine."Prepmt Amt to Deduct";
          IF DiffAmtToDeduct <> 0 THEN BEGIN
            SalesInvoiceLine."Prepmt Amt to Deduct" := SalesInvoiceLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
            SalesInvoiceLine."Line Amount" := SalesInvoiceLine."Prepmt Amt to Deduct";
            SalesInvoiceLine."Line Discount Amount" := SalesInvoiceLine."Line Discount Amount" - DiffAmtToDeduct;
            ModifyTempLine(SalesInvoiceLine);
            TempTotalSalesLine."Prepmt Amt to Deduct" := TempTotalSalesLine."Prepmt Amt to Deduct" + DiffAmtToDeduct;
          END;
        END;
      END;
    END;

    [External]
    PROCEDURE ArchiveUnpostedOrder@56(SalesHeader@1001 : Record 36);
    VAR
      SalesLine@1002 : Record 37;
      ArchiveManagement@1000 : Codeunit 5063;
    BEGIN
      SalesSetup.GET;
      IF NOT SalesSetup."Archive Quotes and Orders" THEN
        EXIT;
      IF NOT (SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order,SalesHeader."Document Type"::"Return Order"]) THEN
        EXIT;

      SalesLine.RESET;
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      SalesLine.SETFILTER(Quantity,'<>0');
      IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
        SalesLine.SETFILTER("Qty. to Ship",'<>0')
      ELSE
        SalesLine.SETFILTER("Return Qty. to Receive",'<>0');
      IF NOT SalesLine.ISEMPTY AND NOT PreviewMode THEN BEGIN
        RoundDeferralsForArchive(SalesHeader,SalesLine);
        ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
      END;
    END;

    LOCAL PROCEDURE SynchBOMSerialNo@1204(VAR ServItemTmp3@1200 : TEMPORARY Record 5940;VAR ServItemTmpCmp3@1201 : TEMPORARY Record 5941);
    VAR
      ItemLedgEntry@1000 : Record 32;
      ItemLedgEntry2@1001 : Record 32;
      TempSalesShipMntLine@1002 : TEMPORARY Record 111;
      ServItemTmpCmp4@1003 : TEMPORARY Record 5941;
      ServItemCompLocal@1004 : Record 5941;
      TempItemLedgEntry2@1008 : TEMPORARY Record 32;
      ChildCount@1005 : Integer;
      EndLoop@1006 : Boolean;
    BEGIN
      IF NOT ServItemTmpCmp3.FIND('-') THEN
        EXIT;

      IF NOT ServItemTmp3.FIND('-') THEN
        EXIT;

      TempSalesShipMntLine.DELETEALL;
      REPEAT
        CLEAR(TempSalesShipMntLine);
        TempSalesShipMntLine."Document No." := ServItemTmp3."Sales/Serv. Shpt. Document No.";
        TempSalesShipMntLine."Line No." := ServItemTmp3."Sales/Serv. Shpt. Line No.";
        IF TempSalesShipMntLine.INSERT THEN;
      UNTIL ServItemTmp3.NEXT = 0;

      IF NOT TempSalesShipMntLine.FIND('-') THEN
        EXIT;

      ServItemTmp3.SETCURRENTKEY("Sales/Serv. Shpt. Document No.","Sales/Serv. Shpt. Line No.");
      CLEAR(ItemLedgEntry);
      ItemLedgEntry.SETCURRENTKEY("Document No.","Document Type","Document Line No.");

      REPEAT
        ChildCount := 0;
        ServItemTmpCmp4.DELETEALL;
        ServItemTmp3.SETRANGE("Sales/Serv. Shpt. Document No.",TempSalesShipMntLine."Document No.");
        ServItemTmp3.SETRANGE("Sales/Serv. Shpt. Line No.",TempSalesShipMntLine."Line No.");
        IF ServItemTmp3.FIND('-') THEN
          REPEAT
            ServItemTmpCmp3.SETRANGE(Active,TRUE);
            ServItemTmpCmp3.SETRANGE("Parent Service Item No.",ServItemTmp3."No.");
            IF ServItemTmpCmp3.FIND('-') THEN
              REPEAT
                ChildCount += 1;
                ServItemTmpCmp4 := ServItemTmpCmp3;
                ServItemTmpCmp4.INSERT;
              UNTIL ServItemTmpCmp3.NEXT = 0;
          UNTIL ServItemTmp3.NEXT = 0;
        ItemLedgEntry.SETRANGE("Document No.",TempSalesShipMntLine."Document No.");
        ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Sales Shipment");
        ItemLedgEntry.SETRANGE("Document Line No.",TempSalesShipMntLine."Line No.");
        IF ItemLedgEntry.FINDFIRST AND ServItemTmpCmp4.FIND('-') THEN BEGIN
          CLEAR(ItemLedgEntry2);
          ItemLedgEntry2.GET(ItemLedgEntry."Entry No.");
          EndLoop := FALSE;
          REPEAT
            IF ItemLedgEntry2."Item No." = ServItemTmpCmp4."No." THEN
              EndLoop := TRUE
            ELSE
              IF ItemLedgEntry2.NEXT = 0 THEN
                EndLoop := TRUE;
          UNTIL EndLoop;
          ItemLedgEntry2.SETRANGE("Entry No.",ItemLedgEntry2."Entry No.",ItemLedgEntry2."Entry No." + ChildCount - 1);
          IF ItemLedgEntry2.FINDSET THEN
            REPEAT
              TempItemLedgEntry2 := ItemLedgEntry2;
              TempItemLedgEntry2.INSERT;
            UNTIL ItemLedgEntry2.NEXT = 0;
          REPEAT
            IF ServItemCompLocal.GET(
                 ServItemTmpCmp4.Active,
                 ServItemTmpCmp4."Parent Service Item No.",
                 ServItemTmpCmp4."Line No.")
            THEN BEGIN
              TempItemLedgEntry2.SETRANGE("Item No.",ServItemCompLocal."No.");
              IF TempItemLedgEntry2.FINDFIRST THEN BEGIN
                ServItemCompLocal."Serial No." := TempItemLedgEntry2."Serial No.";
                ServItemCompLocal.MODIFY;
                TempItemLedgEntry2.DELETE;
              END;
            END;
          UNTIL ServItemTmpCmp4.NEXT = 0;
        END;
      UNTIL TempSalesShipMntLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetGLSetup@60();
    BEGIN
      IF NOT GLSetupRead THEN
        GLSetup.GET;
      GLSetupRead := TRUE;
    END;

    LOCAL PROCEDURE LockTables@58();
    VAR
      SalesLine@1000 : Record 37;
      PurchOrderHeader@1002 : Record 38;
      PurchOrderLine@1001 : Record 39;
    BEGIN
      SalesLine.LOCKTABLE;
      ItemChargeAssgntSales.LOCKTABLE;
      PurchOrderLine.LOCKTABLE;
      PurchOrderHeader.LOCKTABLE;
      GetGLSetup;
      IF NOT GLSetup.OptimGLEntLockForMultiuserEnv THEN BEGIN
        GLEntry.LOCKTABLE;
        IF GLEntry.FINDLAST THEN;
      END;
    END;

    LOCAL PROCEDURE PostCustomerEntry@101(SalesHeader@1000 : Record 36;TotalSalesLine2@1005 : Record 37;TotalSalesLineLCY2@1006 : Record 37;DocType@1002 : Option;DocNo@1003 : Code[20];ExtDocNo@1004 : Code[35];SourceCode@1007 : Code[10]);
    VAR
      GenJnlLine@1001 : Record 81;
    BEGIN
      WITH GenJnlLine DO BEGIN
        InitNewLine(
          SalesHeader."Posting Date",SalesHeader."Document Date",SalesHeader."Posting Description",
          SalesHeader."Shortcut Dimension 1 Code",SalesHeader."Shortcut Dimension 2 Code",
          SalesHeader."Dimension Set ID",SalesHeader."Reason Code");

        CopyDocumentFields(DocType,DocNo,ExtDocNo,SourceCode,'');
        "Account Type" := "Account Type"::Customer;
        "Account No." := SalesHeader."Bill-to Customer No.";
        CopyFromSalesHeader(SalesHeader);
        SetCurrencyFactor(SalesHeader."Currency Code",SalesHeader."Currency Factor");

        "System-Created Entry" := TRUE;

        CopyFromSalesHeaderApplyTo(SalesHeader);
        CopyFromSalesHeaderPayment(SalesHeader);

        Amount := -TotalSalesLine2."Amount Including VAT";
        "Source Currency Amount" := -TotalSalesLine2."Amount Including VAT";
        "Amount (LCY)" := -TotalSalesLineLCY2."Amount Including VAT";
        "Sales/Purch. (LCY)" := -TotalSalesLineLCY2.Amount;
        "Profit (LCY)" := -(TotalSalesLineLCY2.Amount - TotalSalesLineLCY2."Unit Cost (LCY)");
        "Inv. Discount (LCY)" := -TotalSalesLineLCY2."Inv. Discount Amount";

        OnBeforePostCustomerEntry(GenJnlLine,SalesHeader,TotalSalesLine2,TotalSalesLineLCY2);
        GenJnlPostLine.RunWithCheck(GenJnlLine);
      END;
    END;

    LOCAL PROCEDURE UpdateSalesHeader@102(VAR CustLedgerEntry@1000 : Record 21);
    VAR
      GenJnlLine@1001 : Record 81;
    BEGIN
      CASE GenJnlLineDocType OF
        GenJnlLine."Document Type"::Invoice:
          BEGIN
            FindCustLedgEntry(GenJnlLineDocType,GenJnlLineDocNo,CustLedgerEntry);
            SalesInvHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
            SalesInvHeader.MODIFY;
          END;
        GenJnlLine."Document Type"::"Credit Memo":
          BEGIN
            FindCustLedgEntry(GenJnlLineDocType,GenJnlLineDocNo,CustLedgerEntry);
            SalesCrMemoHeader."Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
            SalesCrMemoHeader.MODIFY;
          END;
      END;
    END;

    LOCAL PROCEDURE MAX@55(number1@1000 : Integer;number2@1001 : Integer) : Integer;
    BEGIN
      IF number1 > number2 THEN
        EXIT(number1);
      EXIT(number2);
    END;

    LOCAL PROCEDURE PostBalancingEntry@63(SalesHeader@1014 : Record 36;TotalSalesLine2@1013 : Record 37;TotalSalesLineLCY2@1011 : Record 37;DocType@1009 : Option;DocNo@1008 : Code[20];ExtDocNo@1007 : Code[35];SourceCode@1006 : Code[10]);
    VAR
      CustLedgEntry@1002 : Record 21;
      GenJnlLine@1001 : Record 81;
    BEGIN
      FindCustLedgEntry(DocType,DocNo,CustLedgEntry);

      WITH GenJnlLine DO BEGIN
        InitNewLine(
          SalesHeader."Posting Date",SalesHeader."Document Date",SalesHeader."Posting Description",
          SalesHeader."Shortcut Dimension 1 Code",SalesHeader."Shortcut Dimension 2 Code",
          SalesHeader."Dimension Set ID",SalesHeader."Reason Code");

        CopyDocumentFields(0,DocNo,ExtDocNo,SourceCode,'');
        "Account Type" := "Account Type"::Customer;
        "Account No." := SalesHeader."Bill-to Customer No.";
        CopyFromSalesHeader(SalesHeader);
        SetCurrencyFactor(SalesHeader."Currency Code",SalesHeader."Currency Factor");

        IF SalesHeader.IsCreditDocType THEN
          "Document Type" := "Document Type"::Refund
        ELSE
          "Document Type" := "Document Type"::Payment;

        SetApplyToDocNo(SalesHeader,GenJnlLine,DocType,DocNo);

        Amount := TotalSalesLine2."Amount Including VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible";
        "Source Currency Amount" := Amount;
        CustLedgEntry.CALCFIELDS(Amount);
        IF CustLedgEntry.Amount = 0 THEN
          "Amount (LCY)" := TotalSalesLineLCY2."Amount Including VAT"
        ELSE
          "Amount (LCY)" :=
            TotalSalesLineLCY2."Amount Including VAT" +
            ROUND(CustLedgEntry."Remaining Pmt. Disc. Possible" / CustLedgEntry."Adjusted Currency Factor");
        "Allow Zero-Amount Posting" := TRUE;

        OnBeforePostBalancingEntry(GenJnlLine,SalesHeader,TotalSalesLine2,TotalSalesLineLCY2);
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        OnAfterPostBalancingEntry(GenJnlLine,SalesHeader,TotalSalesLine2,TotalSalesLineLCY2);
      END;
    END;

    LOCAL PROCEDURE SetApplyToDocNo@57(SalesHeader@1000 : Record 36;VAR GenJnlLine@1001 : Record 81;DocType@1002 : Option;DocNo@1003 : Code[20]);
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF SalesHeader."Bal. Account Type" = SalesHeader."Bal. Account Type"::"Bank Account" THEN
          "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
        "Bal. Account No." := SalesHeader."Bal. Account No.";
        "Applies-to Doc. Type" := DocType;
        "Applies-to Doc. No." := DocNo;
      END;
    END;

    LOCAL PROCEDURE FindCustLedgEntry@71(DocType@1003 : Option;DocNo@1002 : Code[20];VAR CustLedgEntry@1000 : Record 21);
    BEGIN
      CustLedgEntry.SETRANGE("Document Type",DocType);
      CustLedgEntry.SETRANGE("Document No.",DocNo);
      CustLedgEntry.FINDLAST;
    END;

    LOCAL PROCEDURE ItemLedgerEntryExist@7(SalesLine2@1000 : Record 37;ShipOrReceive@1002 : Boolean) : Boolean;
    VAR
      HasItemLedgerEntry@1001 : Boolean;
    BEGIN
      IF ShipOrReceive THEN
        // item ledger entry will be created during posting in this transaction
        HasItemLedgerEntry :=
          ((SalesLine2."Qty. to Ship" + SalesLine2."Quantity Shipped") <> 0) OR
          ((SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced") <> 0) OR
          ((SalesLine2."Return Qty. to Receive" + SalesLine2."Return Qty. Received") <> 0)
      ELSE
        // item ledger entry must already exist
        HasItemLedgerEntry :=
          (SalesLine2."Quantity Shipped" <> 0) OR
          (SalesLine2."Return Qty. Received" <> 0);

      EXIT(HasItemLedgerEntry);
    END;

    LOCAL PROCEDURE CheckPostRestrictions@115(SalesHeader@1000 : Record 36);
    VAR
      Contact@1001 : Record 5050;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF NOT PreviewMode THEN
          OnCheckSalesPostRestrictions;

        CheckCustBlockage(SalesHeader,"Sell-to Customer No.",TRUE);
        ValidateSalesPersonOnSalesHeader(SalesHeader,TRUE,TRUE);

        IF "Bill-to Customer No." <> "Sell-to Customer No." THEN
          CheckCustBlockage(SalesHeader,"Bill-to Customer No.",FALSE);

        IF "Sell-to Contact No." <> '' THEN
          IF Contact.GET("Sell-to Contact No.") THEN
            Contact.CheckIfPrivacyBlocked(TRUE);
        IF "Bill-to Contact No." <> '' THEN
          IF Contact.GET("Bill-to Contact No.") THEN
            Contact.CheckIfPrivacyBlocked(TRUE);
      END;
    END;

    LOCAL PROCEDURE CheckCustBlockage@1029(SalesHeader@1000 : Record 36;CustCode@1011 : Code[20];ExecuteDocCheck@1012 : Boolean);
    VAR
      Cust@1039 : Record 18;
      TempSalesLine@1001 : TEMPORARY Record 37;
    BEGIN
      WITH SalesHeader DO BEGIN
        Cust.GET(CustCode);
        IF Receive THEN
          Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,TRUE)
        ELSE BEGIN
          IF Ship AND CheckDocumentType(SalesHeader,ExecuteDocCheck) THEN BEGIN
            ResetTempLines(TempSalesLine);
            TempSalesLine.SETFILTER("Qty. to Ship",'<>0');
            TempSalesLine.SETRANGE("Shipment No.",'');
            IF NOT TempSalesLine.ISEMPTY THEN
              Cust.CheckBlockedCustOnDocs(Cust,"Document Type",TRUE,TRUE);
          END ELSE
            Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE CheckDocumentType@1030(SalesHeader@1000 : Record 36;ExecuteDocCheck@1031 : Boolean) : Boolean;
    BEGIN
      WITH SalesHeader DO
        IF ExecuteDocCheck THEN
          EXIT(
            ("Document Type" = "Document Type"::Order) OR
            (("Document Type" = "Document Type"::Invoice) AND SalesSetup."Shipment on Invoice"));
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE UpdateWonOpportunities@66(VAR SalesHeader@1000 : Record 36);
    VAR
      Opp@1001 : Record 5092;
      OpportunityEntry@1002 : Record 5093;
    BEGIN
      WITH SalesHeader DO
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          Opp.RESET;
          Opp.SETCURRENTKEY("Sales Document Type","Sales Document No.");
          Opp.SETRANGE("Sales Document Type",Opp."Sales Document Type"::Order);
          Opp.SETRANGE("Sales Document No.","No.");
          Opp.SETRANGE(Status,Opp.Status::Won);
          IF Opp.FINDFIRST THEN BEGIN
            Opp."Sales Document Type" := Opp."Sales Document Type"::"Posted Invoice";
            Opp."Sales Document No." := SalesInvHeader."No.";
            Opp.MODIFY;
            OpportunityEntry.RESET;
            OpportunityEntry.SETCURRENTKEY(Active,"Opportunity No.");
            OpportunityEntry.SETRANGE(Active,TRUE);
            OpportunityEntry.SETRANGE("Opportunity No.",Opp."No.");
            IF OpportunityEntry.FINDFIRST THEN BEGIN
              OpportunityEntry."Calcd. Current Value (LCY)" := OpportunityEntry.GetSalesDocValue(SalesHeader);
              OpportunityEntry.MODIFY;
            END;
          END;
        END;
    END;

    LOCAL PROCEDURE UpdateQtyToBeInvoicedForShipment@90(VAR QtyToBeInvoiced@1000 : Decimal;VAR QtyToBeInvoicedBase@1001 : Decimal;TrackingSpecificationExists@1002 : Boolean;HasATOShippedNotInvoiced@1003 : Boolean;SalesLine@1007 : Record 37;SalesShptLine@1006 : Record 111;InvoicingTrackingSpecification@1004 : Record 336;ItemLedgEntryNotInvoiced@1005 : Record 32);
    BEGIN
      IF TrackingSpecificationExists THEN BEGIN
        QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
        QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
      END ELSE
        IF HasATOShippedNotInvoiced THEN BEGIN
          QtyToBeInvoicedBase := ItemLedgEntryNotInvoiced.Quantity - ItemLedgEntryNotInvoiced."Invoiced Quantity";
          IF ABS(QtyToBeInvoicedBase) > ABS(RemQtyToBeInvoicedBase) THEN
            QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Qty. to Ship (Base)";
          QtyToBeInvoiced := ROUND(QtyToBeInvoicedBase / SalesShptLine."Qty. per Unit of Measure",0.00001);
        END ELSE BEGIN
          QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Qty. to Ship";
          QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Qty. to Ship (Base)";
        END;

      IF ABS(QtyToBeInvoiced) > ABS(SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced") THEN BEGIN
        QtyToBeInvoiced := -(SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced");
        QtyToBeInvoicedBase := -(SalesShptLine."Quantity (Base)" - SalesShptLine."Qty. Invoiced (Base)");
      END;
    END;

    LOCAL PROCEDURE UpdateQtyToBeInvoicedForReturnReceipt@201(VAR QtyToBeInvoiced@1002 : Decimal;VAR QtyToBeInvoicedBase@1001 : Decimal;TrackingSpecificationExists@1000 : Boolean;SalesLine@1004 : Record 37;ReturnReceiptLine@1003 : Record 6661;InvoicingTrackingSpecification@1005 : Record 336);
    BEGIN
      IF TrackingSpecificationExists THEN BEGIN
        QtyToBeInvoiced := InvoicingTrackingSpecification."Qty. to Invoice";
        QtyToBeInvoicedBase := InvoicingTrackingSpecification."Qty. to Invoice (Base)";
      END ELSE BEGIN
        QtyToBeInvoiced := RemQtyToBeInvoiced - SalesLine."Return Qty. to Receive";
        QtyToBeInvoicedBase := RemQtyToBeInvoicedBase - SalesLine."Return Qty. to Receive (Base)";
      END;
      IF ABS(QtyToBeInvoiced) >
         ABS(ReturnReceiptLine.Quantity - ReturnReceiptLine."Quantity Invoiced")
      THEN BEGIN
        QtyToBeInvoiced := ReturnReceiptLine.Quantity - ReturnReceiptLine."Quantity Invoiced";
        QtyToBeInvoicedBase := ReturnReceiptLine."Quantity (Base)" - ReturnReceiptLine."Qty. Invoiced (Base)";
      END;
    END;

    LOCAL PROCEDURE UpdateRemainingQtyToBeInvoiced@125(SalesShptLine@1000 : Record 111;VAR RemQtyToInvoiceCurrLine@1001 : Decimal;VAR RemQtyToInvoiceCurrLineBase@1002 : Decimal);
    BEGIN
      RemQtyToInvoiceCurrLine := -SalesShptLine.Quantity + SalesShptLine."Quantity Invoiced";
      RemQtyToInvoiceCurrLineBase := -SalesShptLine."Quantity (Base)" + SalesShptLine."Qty. Invoiced (Base)";
      IF RemQtyToInvoiceCurrLine < RemQtyToBeInvoiced THEN BEGIN
        RemQtyToInvoiceCurrLine := RemQtyToBeInvoiced;
        RemQtyToInvoiceCurrLineBase := RemQtyToBeInvoicedBase;
      END;
    END;

    LOCAL PROCEDURE IsEndLoopForShippedNotInvoiced@96(RemQtyToBeInvoiced@1004 : Decimal;TrackingSpecificationExists@1001 : Boolean;VAR HasATOShippedNotInvoiced@1000 : Boolean;VAR SalesShptLine@1006 : Record 111;VAR InvoicingTrackingSpecification@1002 : Record 336;VAR ItemLedgEntryNotInvoiced@1003 : Record 32;SalesLine@1005 : Record 37) : Boolean;
    BEGIN
      IF TrackingSpecificationExists THEN
        EXIT((InvoicingTrackingSpecification.NEXT = 0) OR (RemQtyToBeInvoiced = 0));

      IF HasATOShippedNotInvoiced THEN BEGIN
        HasATOShippedNotInvoiced := ItemLedgEntryNotInvoiced.NEXT <> 0;
        IF NOT HasATOShippedNotInvoiced THEN
          EXIT(NOT SalesShptLine.FINDSET OR (ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Qty. to Ship")));
        EXIT(ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Qty. to Ship"));
      END;

      EXIT((SalesShptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Qty. to Ship")));
    END;

    [External]
    PROCEDURE SetItemEntryRelation@87(VAR ItemEntryRelation@1000 : Record 6507;VAR SalesShptLine@1001 : Record 111;VAR InvoicingTrackingSpecification@1004 : Record 336;VAR ItemLedgEntryNotInvoiced@1005 : Record 32;TrackingSpecificationExists@1002 : Boolean;HasATOShippedNotInvoiced@1003 : Boolean);
    BEGIN
      IF TrackingSpecificationExists THEN BEGIN
        ItemEntryRelation.GET(InvoicingTrackingSpecification."Item Ledger Entry No.");
        SalesShptLine.GET(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
      END ELSE
        IF HasATOShippedNotInvoiced THEN BEGIN
          ItemEntryRelation."Item Entry No." := ItemLedgEntryNotInvoiced."Entry No.";
          SalesShptLine.GET(ItemLedgEntryNotInvoiced."Document No.",ItemLedgEntryNotInvoiced."Document Line No.");
        END ELSE
          ItemEntryRelation."Item Entry No." := SalesShptLine."Item Shpt. Entry No.";
    END;

    LOCAL PROCEDURE PostATOAssocItemJnlLine@76(SalesHeader@1004 : Record 36;SalesLine@1003 : Record 37;VAR PostedATOLink@1000 : Record 914;VAR RemQtyToBeInvoiced@1002 : Decimal;VAR RemQtyToBeInvoicedBase@1001 : Decimal);
    VAR
      DummyTrackingSpecification@1005 : Record 336;
    BEGIN
      WITH PostedATOLink DO BEGIN
        DummyTrackingSpecification.INIT;
        IF SalesLine."Document Type" = SalesLine."Document Type"::Order THEN BEGIN
          "Assembled Quantity" := -"Assembled Quantity";
          "Assembled Quantity (Base)" := -"Assembled Quantity (Base)";
          IF ABS(RemQtyToBeInvoiced) >= ABS("Assembled Quantity") THEN BEGIN
            ItemLedgShptEntryNo :=
              PostItemJnlLine(
                SalesHeader,SalesLine,
                "Assembled Quantity","Assembled Quantity (Base)",
                "Assembled Quantity","Assembled Quantity (Base)",
                0,'',DummyTrackingSpecification,TRUE);
            RemQtyToBeInvoiced -= "Assembled Quantity";
            RemQtyToBeInvoicedBase -= "Assembled Quantity (Base)";
          END ELSE BEGIN
            IF RemQtyToBeInvoiced <> 0 THEN
              ItemLedgShptEntryNo :=
                PostItemJnlLine(
                  SalesHeader,SalesLine,
                  RemQtyToBeInvoiced,
                  RemQtyToBeInvoicedBase,
                  RemQtyToBeInvoiced,
                  RemQtyToBeInvoicedBase,
                  0,'',DummyTrackingSpecification,TRUE);

            ItemLedgShptEntryNo :=
              PostItemJnlLine(
                SalesHeader,SalesLine,
                "Assembled Quantity" - RemQtyToBeInvoiced,
                "Assembled Quantity (Base)" - RemQtyToBeInvoicedBase,
                0,0,
                0,'',DummyTrackingSpecification,TRUE);

            RemQtyToBeInvoiced := 0;
            RemQtyToBeInvoicedBase := 0;
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE GetOpenLinkedATOs@72(VAR TempAsmHeader@1000 : TEMPORARY Record 900);
    VAR
      TempSalesLine@1002 : TEMPORARY Record 37;
      AsmHeader@1001 : Record 900;
    BEGIN
      WITH TempSalesLine DO BEGIN
        ResetTempLines(TempSalesLine);
        IF FINDSET THEN
          REPEAT
            IF AsmToOrderExists(AsmHeader) THEN
              IF AsmHeader.Status = AsmHeader.Status::Open THEN BEGIN
                TempAsmHeader.TRANSFERFIELDS(AsmHeader);
                TempAsmHeader.INSERT;
              END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE ReopenAsmOrders@69(VAR TempAsmHeader@1002 : TEMPORARY Record 900);
    VAR
      AsmHeader@1001 : Record 900;
    BEGIN
      IF TempAsmHeader.FIND('-') THEN
        REPEAT
          AsmHeader.GET(TempAsmHeader."Document Type",TempAsmHeader."No.");
          AsmHeader.Status := AsmHeader.Status::Open;
          AsmHeader.MODIFY;
        UNTIL TempAsmHeader.NEXT = 0;
    END;

    LOCAL PROCEDURE InitPostATO@53(SalesHeader@1002 : Record 36;VAR SalesLine@1000 : Record 37);
    VAR
      AsmHeader@1001 : Record 900;
      Window@1003 : Dialog;
    BEGIN
      IF SalesLine.AsmToOrderExists(AsmHeader) THEN BEGIN
        Window.OPEN(AssemblyCheckProgressMsg);
        Window.UPDATE(1,
          STRSUBSTNO('%1 %2 %3 %4',
            SalesLine."Document Type",SalesLine."Document No.",SalesLine.FIELDCAPTION("Line No."),SalesLine."Line No."));
        Window.UPDATE(2,STRSUBSTNO('%1 %2',AsmHeader."Document Type",AsmHeader."No."));

        SalesLine.CheckAsmToOrder(AsmHeader);
        IF NOT HasQtyToAsm(SalesLine,AsmHeader) THEN
          EXIT;

        AsmPost.SetPostingDate(TRUE,SalesHeader."Posting Date");
        AsmPost.InitPostATO(AsmHeader);

        Window.CLOSE;
      END;
    END;

    LOCAL PROCEDURE InitPostATOs@179(SalesHeader@1001 : Record 36);
    VAR
      TempSalesLine@1000 : TEMPORARY Record 37;
    BEGIN
      WITH TempSalesLine DO BEGIN
        FindNotShippedLines(SalesHeader,TempSalesLine);
        SETFILTER("Qty. to Assemble to Order",'<>0');
        IF FINDSET THEN
          REPEAT
            InitPostATO(SalesHeader,TempSalesLine);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE PostATO@59(SalesHeader@1005 : Record 36;VAR SalesLine@1000 : Record 37;VAR TempPostedATOLink@1004 : TEMPORARY Record 914);
    VAR
      AsmHeader@1001 : Record 900;
      PostedATOLink@1002 : Record 914;
      Window@1003 : Dialog;
    BEGIN
      IF SalesLine.AsmToOrderExists(AsmHeader) THEN BEGIN
        Window.OPEN(AssemblyPostProgressMsg);
        Window.UPDATE(1,
          STRSUBSTNO('%1 %2 %3 %4',
            SalesLine."Document Type",SalesLine."Document No.",SalesLine.FIELDCAPTION("Line No."),SalesLine."Line No."));
        Window.UPDATE(2,STRSUBSTNO('%1 %2',AsmHeader."Document Type",AsmHeader."No."));

        SalesLine.CheckAsmToOrder(AsmHeader);
        IF NOT HasQtyToAsm(SalesLine,AsmHeader) THEN
          EXIT;
        IF AsmHeader."Remaining Quantity (Base)" = 0 THEN
          EXIT;

        PostedATOLink.INIT;
        PostedATOLink."Assembly Document Type" := PostedATOLink."Assembly Document Type"::Assembly;
        PostedATOLink."Assembly Document No." := AsmHeader."Posting No.";
        PostedATOLink."Document Type" := PostedATOLink."Document Type"::"Sales Shipment";
        PostedATOLink."Document No." := SalesHeader."Shipping No.";
        PostedATOLink."Document Line No." := SalesLine."Line No.";

        PostedATOLink."Assembly Order No." := AsmHeader."No.";
        PostedATOLink."Order No." := SalesLine."Document No.";
        PostedATOLink."Order Line No." := SalesLine."Line No.";

        PostedATOLink."Assembled Quantity" := AsmHeader."Quantity to Assemble";
        PostedATOLink."Assembled Quantity (Base)" := AsmHeader."Quantity to Assemble (Base)";
        PostedATOLink.INSERT;

        TempPostedATOLink := PostedATOLink;
        TempPostedATOLink.INSERT;

        AsmPost.PostATO(AsmHeader,ItemJnlPostLine,ResJnlPostLine,WhseJnlPostLine);

        Window.CLOSE;
      END;
    END;

    LOCAL PROCEDURE FinalizePostATO@61(VAR SalesLine@1000 : Record 37);
    VAR
      ATOLink@1002 : Record 904;
      AsmHeader@1003 : Record 900;
      Window@1001 : Dialog;
    BEGIN
      IF SalesLine.AsmToOrderExists(AsmHeader) THEN BEGIN
        Window.OPEN(AssemblyFinalizeProgressMsg);
        Window.UPDATE(1,
          STRSUBSTNO('%1 %2 %3 %4',
            SalesLine."Document Type",SalesLine."Document No.",SalesLine.FIELDCAPTION("Line No."),SalesLine."Line No."));
        Window.UPDATE(2,STRSUBSTNO('%1 %2',AsmHeader."Document Type",AsmHeader."No."));

        SalesLine.CheckAsmToOrder(AsmHeader);
        AsmHeader.TESTFIELD("Remaining Quantity (Base)",0);
        AsmPost.FinalizePostATO(AsmHeader);
        ATOLink.GET(AsmHeader."Document Type",AsmHeader."No.");
        ATOLink.DELETE;

        Window.CLOSE;
      END;
    END;

    LOCAL PROCEDURE CheckATOLink@78(SalesLine@1000 : Record 37);
    VAR
      AsmHeader@1001 : Record 900;
    BEGIN
      IF SalesLine."Qty. to Asm. to Order (Base)" = 0 THEN
        EXIT;
      IF SalesLine.AsmToOrderExists(AsmHeader) THEN
        SalesLine.CheckAsmToOrder(AsmHeader);
    END;

    LOCAL PROCEDURE DeleteATOLinks@67(SalesHeader@1000 : Record 36);
    VAR
      ATOLink@1001 : Record 904;
    BEGIN
      WITH ATOLink DO BEGIN
        SETCURRENTKEY(Type,"Document Type","Document No.");
        SETRANGE(Type,Type::Sale);
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        IF NOT ISEMPTY THEN
          DELETEALL;
      END;
    END;

    LOCAL PROCEDURE HasQtyToAsm@68(SalesLine@1000 : Record 37;AsmHeader@1001 : Record 900) : Boolean;
    BEGIN
      IF SalesLine."Qty. to Asm. to Order (Base)" = 0 THEN
        EXIT(FALSE);
      IF SalesLine."Qty. to Ship (Base)" = 0 THEN
        EXIT(FALSE);
      IF AsmHeader."Quantity to Assemble (Base)" = 0 THEN
        EXIT(FALSE);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetATOItemLedgEntriesNotInvoiced@77(SalesLine@1000 : Record 37;VAR ItemLedgEntryNotInvoiced@1001 : Record 32) : Boolean;
    VAR
      PostedATOLink@1002 : Record 914;
      ItemLedgEntry@1003 : Record 32;
    BEGIN
      ItemLedgEntryNotInvoiced.RESET;
      ItemLedgEntryNotInvoiced.DELETEALL;
      IF PostedATOLink.FindLinksFromSalesLine(SalesLine) THEN
        REPEAT
          ItemLedgEntry.SETCURRENTKEY("Document No.","Document Type","Document Line No.");
          ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Sales Shipment");
          ItemLedgEntry.SETRANGE("Document No.",PostedATOLink."Document No.");
          ItemLedgEntry.SETRANGE("Document Line No.",PostedATOLink."Document Line No.");
          ItemLedgEntry.SETRANGE("Assemble to Order",TRUE);
          ItemLedgEntry.SETRANGE("Completely Invoiced",FALSE);
          IF ItemLedgEntry.FINDSET THEN
            REPEAT
              IF ItemLedgEntry.Quantity <> ItemLedgEntry."Invoiced Quantity" THEN BEGIN
                ItemLedgEntryNotInvoiced := ItemLedgEntry;
                ItemLedgEntryNotInvoiced.INSERT;
              END;
            UNTIL ItemLedgEntry.NEXT = 0;
        UNTIL PostedATOLink.NEXT = 0;

      EXIT(ItemLedgEntryNotInvoiced.FINDSET);
    END;

    [External]
    PROCEDURE SetWhseJnlRegisterCU@26(VAR WhseJnlRegisterLine@1000 : Codeunit 7301);
    BEGIN
      WhseJnlPostLine := WhseJnlRegisterLine;
    END;

    LOCAL PROCEDURE PostWhseShptLines@74(VAR WhseShptLine2@1000 : Record 7321;SalesShptLine2@1004 : Record 111;VAR SalesLine2@1007 : Record 37);
    VAR
      ATOWhseShptLine@1002 : Record 7321;
      NonATOWhseShptLine@1001 : Record 7321;
      ATOLineFound@1005 : Boolean;
      NonATOLineFound@1003 : Boolean;
      TotalSalesShptLineQty@1006 : Decimal;
    BEGIN
      WhseShptLine2.GetATOAndNonATOLines(ATOWhseShptLine,NonATOWhseShptLine,ATOLineFound,NonATOLineFound);
      IF ATOLineFound THEN
        TotalSalesShptLineQty += ATOWhseShptLine."Qty. to Ship";
      IF NonATOLineFound THEN
        TotalSalesShptLineQty += NonATOWhseShptLine."Qty. to Ship";
      SalesShptLine2.TESTFIELD(Quantity,TotalSalesShptLineQty);

      SaveTempWhseSplitSpec(SalesLine2,TempATOTrackingSpecification);
      WhsePostShpt.SetWhseJnlRegisterCU(WhseJnlPostLine);
      IF ATOLineFound AND (ATOWhseShptLine."Qty. to Ship (Base)" > 0) THEN
        WhsePostShpt.CreatePostedShptLine(
          ATOWhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);

      SaveTempWhseSplitSpec(SalesLine2,TempHandlingSpecification);
      IF NonATOLineFound AND (NonATOWhseShptLine."Qty. to Ship (Base)" > 0) THEN
        WhsePostShpt.CreatePostedShptLine(
          NonATOWhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
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

    LOCAL PROCEDURE UpdateIncomingDocument@95(IncomingDocNo@1000 : Integer;PostingDate@1002 : Date;GenJnlLineDocNo@1003 : Code[20]);
    VAR
      IncomingDocument@1001 : Record 130;
    BEGIN
      IncomingDocument.UpdateIncomingDocumentFromPosting(IncomingDocNo,PostingDate,GenJnlLineDocNo);
    END;

    LOCAL PROCEDURE CheckItemCharge@88(ItemChargeAssgntSales@1000 : Record 5809);
    VAR
      SalesLineForCharge@1001 : Record 37;
    BEGIN
      WITH ItemChargeAssgntSales DO
        CASE "Applies-to Doc. Type" OF
          "Applies-to Doc. Type"::Order,
          "Applies-to Doc. Type"::Invoice:
            IF SalesLineForCharge.GET(
                 "Applies-to Doc. Type",
                 "Applies-to Doc. No.",
                 "Applies-to Doc. Line No.")
            THEN
              IF (SalesLineForCharge."Quantity (Base)" = SalesLineForCharge."Qty. Shipped (Base)") AND
                 (SalesLineForCharge."Qty. Shipped Not Invd. (Base)" = 0)
              THEN
                ERROR(ReassignItemChargeErr);
          "Applies-to Doc. Type"::"Return Order",
          "Applies-to Doc. Type"::"Credit Memo":
            IF SalesLineForCharge.GET(
                 "Applies-to Doc. Type",
                 "Applies-to Doc. No.",
                 "Applies-to Doc. Line No.")
            THEN
              IF (SalesLineForCharge."Quantity (Base)" = SalesLineForCharge."Return Qty. Received (Base)") AND
                 (SalesLineForCharge."Ret. Qty. Rcd. Not Invd.(Base)" = 0)
              THEN
                ERROR(ReassignItemChargeErr);
        END;
    END;

    LOCAL PROCEDURE CheckItemReservDisruption@104(SalesLine@1001 : Record 37);
    VAR
      AvailableQty@1000 : Decimal;
    BEGIN
      WITH SalesLine DO BEGIN
        IF NOT ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) OR
           (Type <> Type::Item) OR NOT ("Qty. to Ship (Base)" > 0)
        THEN
          EXIT;
        IF ("Job Contract Entry No." <> 0) OR
           Nonstock OR "Special Order" OR "Drop Shipment" OR
           IsServiceItem OR FullQtyIsForAsmToOrder OR
           TempSKU.GET("Location Code","No.","Variant Code") // Warn against item
        THEN
          EXIT;

        Item.SETFILTER("Location Filter","Location Code");
        Item.SETFILTER("Variant Filter","Variant Code");
        Item.CALCFIELDS("Reserved Qty. on Inventory","Net Change");
        CALCFIELDS("Reserved Qty. (Base)");
        AvailableQty := Item."Net Change" - (Item."Reserved Qty. on Inventory" - "Reserved Qty. (Base)");

        IF (Item."Reserved Qty. on Inventory" > 0) AND
           (AvailableQty < "Qty. to Ship (Base)") AND
           (Item."Reserved Qty. on Inventory" > "Reserved Qty. (Base)")
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

    [External]
    PROCEDURE InitProgressWindow@105(SalesHeader@1000 : Record 36);
    BEGIN
      IF SalesHeader.Invoice THEN
        Window.OPEN(
          '#1#################################\\' +
          PostingLinesMsg +
          PostingSalesAndVATMsg +
          PostingCustomersMsg +
          PostingBalAccountMsg)
      ELSE
        Window.OPEN(
          '#1#################################\\' +
          PostingLines2Msg);

      Window.UPDATE(1,STRSUBSTNO('%1 %2',SalesHeader."Document Type",SalesHeader."No."));
    END;

    LOCAL PROCEDURE CheckCertificateOfSupplyStatus@188(SalesShptHeader@1001 : Record 110;SalesShptLine@1000 : Record 111);
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

    LOCAL PROCEDURE HasSpecificTracking@107(ItemNo@1000 : Code[20]) : Boolean;
    VAR
      Item@1001 : Record 27;
      ItemTrackingCode@1002 : Record 6502;
    BEGIN
      Item.GET(ItemNo);
      IF Item."Item Tracking Code" <> '' THEN BEGIN
        ItemTrackingCode.GET(Item."Item Tracking Code");
        EXIT(ItemTrackingCode."SN Specific Tracking" OR ItemTrackingCode."Lot Specific Tracking");
      END;
    END;

    LOCAL PROCEDURE HasInvtPickLine@108(SalesLine@1000 : Record 37) : Boolean;
    VAR
      WhseActivityLine@1001 : Record 5767;
    BEGIN
      WITH WhseActivityLine DO BEGIN
        SETRANGE("Activity Type","Activity Type"::"Invt. Pick");
        SETRANGE("Source Type",DATABASE::"Sales Line");
        SETRANGE("Source Subtype",SalesLine."Document Type");
        SETRANGE("Source No.",SalesLine."Document No.");
        SETRANGE("Source Line No.",SalesLine."Line No.");
        EXIT(NOT ISEMPTY);
      END;
    END;

    LOCAL PROCEDURE InsertPostedHeaders@139(SalesHeader@1000 : Record 36);
    VAR
      SalesShptLine@1001 : Record 111;
      GenJnlLine@1002 : Record 81;
    BEGIN
      WITH SalesHeader DO BEGIN
        // Insert shipment header
        IF Ship THEN BEGIN
          IF ("Document Type" = "Document Type"::Order) OR
             (("Document Type" = "Document Type"::Invoice) AND SalesSetup."Shipment on Invoice")
          THEN BEGIN
            IF DropShipOrder THEN BEGIN
              PurchRcptHeader.LOCKTABLE;
              PurchRcptLine.LOCKTABLE;
              SalesShptHeader.LOCKTABLE;
              SalesShptLine.LOCKTABLE;
            END;
            InsertShipmentHeader(SalesHeader,SalesShptHeader);
          END;

          ServItemMgt.CopyReservationEntry(SalesHeader);
          IF ("Document Type" = "Document Type"::Invoice) AND
             (NOT SalesSetup."Shipment on Invoice")
          THEN
            ServItemMgt.CreateServItemOnSalesInvoice(SalesHeader);
        END;

        ServItemMgt.DeleteServItemOnSaleCreditMemo(SalesHeader);

        // Insert return receipt header
        IF Receive THEN
          IF ("Document Type" = "Document Type"::"Return Order") OR
             (("Document Type" = "Document Type"::"Credit Memo") AND SalesSetup."Return Receipt on Credit Memo")
          THEN
            InsertReturnReceiptHeader(SalesHeader,ReturnRcptHeader);

        // Insert invoice header or credit memo header
        IF Invoice THEN
          IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
            InsertInvoiceHeader(SalesHeader,SalesInvHeader);
            GenJnlLineDocType := GenJnlLine."Document Type"::Invoice;
            GenJnlLineDocNo := SalesInvHeader."No.";
            GenJnlLineExtDocNo := SalesInvHeader."External Document No.";
          END ELSE BEGIN // Credit Memo
            InsertCrMemoHeader(SalesHeader,SalesCrMemoHeader);
            GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo";
            GenJnlLineDocNo := SalesCrMemoHeader."No.";
            GenJnlLineExtDocNo := SalesCrMemoHeader."External Document No.";
          END;
      END;
    END;

    LOCAL PROCEDURE InsertShipmentHeader@110(SalesHeader@1000 : Record 36;VAR SalesShptHeader@1001 : Record 110);
    VAR
      SalesCommentLine@1002 : Record 44;
      RecordLinkManagement@1003 : Codeunit 447;
    BEGIN
      WITH SalesHeader DO BEGIN
        SalesShptHeader.INIT;
        SalesShptHeader.TRANSFERFIELDS(SalesHeader);

        SalesShptHeader."No." := "Shipping No.";
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          SalesShptHeader."Order No. Series" := "No. Series";
          SalesShptHeader."Order No." := "No.";
          IF SalesSetup."Ext. Doc. No. Mandatory" THEN
            TESTFIELD("External Document No.");
        END;
        SalesShptHeader."Source Code" := SrcCode;
        SalesShptHeader."User ID" := USERID;
        SalesShptHeader."No. Printed" := 0;
        OnBeforeSalesShptHeaderInsert(SalesShptHeader,SalesHeader);
        SalesShptHeader.INSERT(TRUE);

        ApprovalsMgmt.PostApprovalEntries(RECORDID,SalesShptHeader.RECORDID,SalesShptHeader."No.");

        IF SalesSetup."Copy Comments Order to Shpt." THEN BEGIN
          SalesCommentLine.CopyComments(
            "Document Type",SalesCommentLine."Document Type"::Shipment,"No.",SalesShptHeader."No.");
          RecordLinkManagement.CopyLinks(SalesHeader,SalesShptHeader);
        END;
        IF WhseShip THEN BEGIN
          WhseShptHeader.GET(TempWhseShptHeader."No.");
          WhsePostShpt.CreatePostedShptHeader(
            PostedWhseShptHeader,WhseShptHeader,"Shipping No.","Posting Date");
        END;
        IF WhseReceive THEN BEGIN
          WhseRcptHeader.GET(TempWhseRcptHeader."No.");
          WhsePostRcpt.CreatePostedRcptHeader(
            PostedWhseRcptHeader,WhseRcptHeader,"Shipping No.","Posting Date");
        END;
      END;
    END;

    LOCAL PROCEDURE InsertReturnReceiptHeader@113(SalesHeader@1000 : Record 36;VAR ReturnRcptHeader@1001 : Record 6660);
    VAR
      SalesCommentLine@1002 : Record 44;
      RecordLinkManagement@1003 : Codeunit 447;
    BEGIN
      WITH SalesHeader DO BEGIN
        ReturnRcptHeader.INIT;
        ReturnRcptHeader.TRANSFERFIELDS(SalesHeader);
        ReturnRcptHeader."No." := "Return Receipt No.";
        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
          ReturnRcptHeader."Return Order No. Series" := "No. Series";
          ReturnRcptHeader."Return Order No." := "No.";
          IF SalesSetup."Ext. Doc. No. Mandatory" THEN
            TESTFIELD("External Document No.");
        END;
        ReturnRcptHeader."No. Series" := "Return Receipt No. Series";
        ReturnRcptHeader."Source Code" := SrcCode;
        ReturnRcptHeader."User ID" := USERID;
        ReturnRcptHeader."No. Printed" := 0;
        OnBeforeReturnRcptHeaderInsert(ReturnRcptHeader,SalesHeader);
        ReturnRcptHeader.INSERT(TRUE);

        ApprovalsMgmt.PostApprovalEntries(RECORDID,ReturnRcptHeader.RECORDID,ReturnRcptHeader."No.");

        IF SalesSetup."Copy Cmts Ret.Ord. to Ret.Rcpt" THEN BEGIN
          SalesCommentLine.CopyComments(
            "Document Type",SalesCommentLine."Document Type"::"Posted Return Receipt","No.",ReturnRcptHeader."No.");
          RecordLinkManagement.CopyLinks(SalesHeader,ReturnRcptHeader);
        END;
        IF WhseReceive THEN BEGIN
          WhseRcptHeader.GET(TempWhseRcptHeader."No.");
          WhsePostRcpt.CreatePostedRcptHeader(PostedWhseRcptHeader,WhseRcptHeader,"Return Receipt No.","Posting Date");
        END;
        IF WhseShip THEN BEGIN
          WhseShptHeader.GET(TempWhseShptHeader."No.");
          WhsePostShpt.CreatePostedShptHeader(PostedWhseShptHeader,WhseShptHeader,"Return Receipt No.","Posting Date");
        END;
      END;
    END;

    LOCAL PROCEDURE InsertInvoiceHeader@116(SalesHeader@1000 : Record 36;VAR SalesInvHeader@1001 : Record 112);
    VAR
      SalesCommentLine@1002 : Record 44;
      RecordLinkManagement@1003 : Codeunit 447;
      SegManagement@1004 : Codeunit 5051;
    BEGIN
      WITH SalesHeader DO BEGIN
        SalesInvHeader.INIT;
        CALCFIELDS("Work Description");
        SalesInvHeader.TRANSFERFIELDS(SalesHeader);

        SalesInvHeader."No." := "Posting No.";
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          IF SalesSetup."Ext. Doc. No. Mandatory" THEN
            TESTFIELD("External Document No.");
          SalesInvHeader."Pre-Assigned No. Series" := '';
          SalesInvHeader."Order No. Series" := "No. Series";
          SalesInvHeader."Order No." := "No.";
        END ELSE BEGIN
          IF "Posting No." = '' THEN
            SalesInvHeader."No." := "No.";
          SalesInvHeader."Pre-Assigned No. Series" := "No. Series";
          SalesInvHeader."Pre-Assigned No." := "No.";
        END;
        IF GUIALLOWED THEN
          Window.UPDATE(1,STRSUBSTNO(InvoiceNoMsg,"Document Type","No.",SalesInvHeader."No."));
        SalesInvHeader."Source Code" := SrcCode;
        SalesInvHeader."User ID" := USERID;
        SalesInvHeader."No. Printed" := 0;
        OnBeforeSalesInvHeaderInsert(SalesInvHeader,SalesHeader);
        SalesInvHeader.INSERT(TRUE);
        OnAfterSalesInvHeaderInsert(SalesInvHeader,SalesHeader);

        UpdateWonOpportunities(SalesHeader);
        SegManagement.CreateCampaignEntryOnSalesInvoicePosting(SalesInvHeader);

        ApprovalsMgmt.PostApprovalEntries(RECORDID,SalesInvHeader.RECORDID,SalesInvHeader."No.");

        IF SalesSetup."Copy Comments Order to Invoice" THEN BEGIN
          SalesCommentLine.CopyComments(
            "Document Type",SalesCommentLine."Document Type"::"Posted Invoice","No.",SalesInvHeader."No.");
          RecordLinkManagement.CopyLinks(SalesHeader,SalesInvHeader);
        END;
      END;
    END;

    LOCAL PROCEDURE InsertCrMemoHeader@118(SalesHeader@1000 : Record 36;VAR SalesCrMemoHeader@1001 : Record 114);
    VAR
      SalesCommentLine@1002 : Record 44;
      RecordLinkManagement@1003 : Codeunit 447;
    BEGIN
      WITH SalesHeader DO BEGIN
        SalesCrMemoHeader.INIT;
        SalesCrMemoHeader.TRANSFERFIELDS(SalesHeader);
        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
          SalesCrMemoHeader."No." := "Posting No.";
          IF SalesSetup."Ext. Doc. No. Mandatory" THEN
            TESTFIELD("External Document No.");
          SalesCrMemoHeader."Pre-Assigned No. Series" := '';
          SalesCrMemoHeader."Return Order No. Series" := "No. Series";
          SalesCrMemoHeader."Return Order No." := "No.";
          Window.UPDATE(1,STRSUBSTNO(CreditMemoNoMsg,"Document Type","No.",SalesCrMemoHeader."No."));
        END ELSE BEGIN
          SalesCrMemoHeader."Pre-Assigned No. Series" := "No. Series";
          SalesCrMemoHeader."Pre-Assigned No." := "No.";
          IF "Posting No." <> '' THEN BEGIN
            SalesCrMemoHeader."No." := "Posting No.";
            Window.UPDATE(1,STRSUBSTNO(CreditMemoNoMsg,"Document Type","No.",SalesCrMemoHeader."No."));
          END;
        END;
        SalesCrMemoHeader."Source Code" := SrcCode;
        SalesCrMemoHeader."User ID" := USERID;
        SalesCrMemoHeader."No. Printed" := 0;
        OnBeforeSalesCrMemoHeaderInsert(SalesCrMemoHeader,SalesHeader);
        SalesCrMemoHeader.INSERT(TRUE);
        OnAfterSalesCrMemoHeaderInsert(SalesCrMemoHeader,SalesHeader);

        ApprovalsMgmt.PostApprovalEntries(RECORDID,SalesCrMemoHeader.RECORDID,SalesCrMemoHeader."No.");

        IF SalesSetup."Copy Cmts Ret.Ord. to Cr. Memo" THEN BEGIN
          SalesCommentLine.CopyComments(
            "Document Type",SalesCommentLine."Document Type"::"Posted Credit Memo","No.",SalesCrMemoHeader."No.");
          RecordLinkManagement.CopyLinks(SalesHeader,SalesCrMemoHeader);
        END;
      END;
    END;

    LOCAL PROCEDURE InsertShipmentLine@143(SalesHeader@1008 : Record 36;SalesShptHeader@1000 : Record 110;SalesLine@1001 : Record 37;CostBaseAmount@1003 : Decimal;VAR TempServiceItem2@1013 : TEMPORARY Record 5940;VAR TempServiceItemComp2@1009 : TEMPORARY Record 5941);
    VAR
      SalesShptLine@1004 : Record 111;
      WhseShptLine@1005 : Record 7321;
      WhseRcptLine@1006 : Record 7317;
      TempServiceItem1@1012 : TEMPORARY Record 5940;
      TempServiceItemComp1@1010 : TEMPORARY Record 5941;
    BEGIN
      SalesShptLine.InitFromSalesLine(SalesShptHeader,xSalesLine);
      SalesShptLine."Quantity Invoiced" := -RemQtyToBeInvoiced;
      SalesShptLine."Qty. Invoiced (Base)" := -RemQtyToBeInvoicedBase;
      SalesShptLine."Qty. Shipped Not Invoiced" := SalesShptLine.Quantity - SalesShptLine."Quantity Invoiced";

      IF (SalesLine.Type = SalesLine.Type::Item) AND (SalesLine."Qty. to Ship" <> 0) THEN BEGIN
        IF WhseShip THEN BEGIN
          WhseShptLine.GetWhseShptLine(
            WhseShptHeader."No.",DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
          PostWhseShptLines(WhseShptLine,SalesShptLine,SalesLine);
        END;
        IF WhseReceive THEN BEGIN
          WhseRcptLine.GetWhseRcptLine(
            WhseRcptHeader."No.",DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
          WhseRcptLine.TESTFIELD("Qty. to Receive",-SalesShptLine.Quantity);
          SaveTempWhseSplitSpec(SalesLine,TempHandlingSpecification);
          WhsePostRcpt.CreatePostedRcptLine(
            WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
        END;

        SalesShptLine."Item Shpt. Entry No." :=
          InsertShptEntryRelation(SalesShptLine); // ItemLedgShptEntryNo
        SalesShptLine."Item Charge Base Amount" :=
          ROUND(CostBaseAmount / SalesLine.Quantity * SalesShptLine.Quantity);
      END;
      OnBeforeSalesShptLineInsert(SalesShptLine,SalesShptHeader,SalesLine);
      SalesShptLine.INSERT(TRUE);
      OnAfterSalesShptLineInsert(SalesShptLine,SalesLine);

      CheckCertificateOfSupplyStatus(SalesShptHeader,SalesShptLine);

      ServItemMgt.CreateServItemOnSalesLineShpt(SalesHeader,xSalesLine,SalesShptLine);
      IF SalesLine."BOM Item No." <> '' THEN BEGIN
        ServItemMgt.ReturnServItemComp(TempServiceItem1,TempServiceItemComp1);
        IF TempServiceItem1.FINDSET THEN
          REPEAT
            TempServiceItem2 := TempServiceItem1;
            IF TempServiceItem2.INSERT THEN;
          UNTIL TempServiceItem1.NEXT = 0;
        IF TempServiceItemComp1.FINDSET THEN
          REPEAT
            TempServiceItemComp2 := TempServiceItemComp1;
            IF TempServiceItemComp2.INSERT THEN;
          UNTIL TempServiceItemComp1.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE InsertReturnReceiptLine@146(ReturnRcptHeader@1000 : Record 6660;SalesLine@1001 : Record 37;CostBaseAmount@1003 : Decimal);
    VAR
      ReturnRcptLine@1004 : Record 6661;
      WhseShptLine@1006 : Record 7321;
      WhseRcptLine@1005 : Record 7317;
    BEGIN
      ReturnRcptLine.InitFromSalesLine(ReturnRcptHeader,xSalesLine);
      ReturnRcptLine."Quantity Invoiced" := RemQtyToBeInvoiced;
      ReturnRcptLine."Qty. Invoiced (Base)" := RemQtyToBeInvoicedBase;
      ReturnRcptLine."Return Qty. Rcd. Not Invd." := ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";

      IF (SalesLine.Type = SalesLine.Type::Item) AND (SalesLine."Return Qty. to Receive" <> 0) THEN BEGIN
        IF WhseReceive THEN BEGIN
          WhseRcptLine.GetWhseRcptLine(
            WhseRcptHeader."No.",DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
          WhseRcptLine.TESTFIELD("Qty. to Receive",ReturnRcptLine.Quantity);
          SaveTempWhseSplitSpec(SalesLine,TempHandlingSpecification);
          WhsePostRcpt.CreatePostedRcptLine(
            WhseRcptLine,PostedWhseRcptHeader,PostedWhseRcptLine,TempWhseSplitSpecification);
        END;
        IF WhseShip THEN BEGIN
          WhseShptLine.GetWhseShptLine(
            WhseShptHeader."No.",DATABASE::"Sales Line",SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
          WhseShptLine.TESTFIELD("Qty. to Ship",-ReturnRcptLine.Quantity);
          SaveTempWhseSplitSpec(SalesLine,TempHandlingSpecification);
          WhsePostShpt.SetWhseJnlRegisterCU(WhseJnlPostLine);
          WhsePostShpt.CreatePostedShptLine(
            WhseShptLine,PostedWhseShptHeader,PostedWhseShptLine,TempWhseSplitSpecification);
        END;

        ReturnRcptLine."Item Rcpt. Entry No." :=
          InsertReturnEntryRelation(ReturnRcptLine); // ItemLedgShptEntryNo;
        ReturnRcptLine."Item Charge Base Amount" :=
          ROUND(CostBaseAmount / SalesLine.Quantity * ReturnRcptLine.Quantity);
      END;
      OnBeforeReturnRcptLineInsert(ReturnRcptLine,ReturnRcptHeader,SalesLine);
      ReturnRcptLine.INSERT(TRUE);
      OnAfterReturnRcptLineInsert(ReturnRcptLine,ReturnRcptHeader,SalesLine,ItemLedgShptEntryNo,WhseShip,WhseReceive);
    END;

    LOCAL PROCEDURE CheckICPartnerBlocked@20(SalesHeader@1000 : Record 36);
    VAR
      ICPartner@1001 : Record 413;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF "Sell-to IC Partner Code" <> '' THEN
          IF ICPartner.GET("Sell-to IC Partner Code") THEN
            ICPartner.TESTFIELD(Blocked,FALSE);
        IF "Bill-to IC Partner Code" <> '' THEN
          IF ICPartner.GET("Bill-to IC Partner Code") THEN
            ICPartner.TESTFIELD(Blocked,FALSE);
      END;
    END;

    LOCAL PROCEDURE SendICDocument@109(VAR SalesHeader@1000 : Record 36;VAR ModifyHeader@1001 : Boolean);
    VAR
      ICInboxOutboxMgt@1002 : Codeunit 427;
    BEGIN
      WITH SalesHeader DO
        IF "Send IC Document" AND ("IC Status" = "IC Status"::New) AND ("IC Direction" = "IC Direction"::Outgoing) AND
           ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"])
        THEN BEGIN
          ICInboxOutboxMgt.SendSalesDoc(SalesHeader,TRUE);
          "IC Status" := "IC Status"::Pending;
          ModifyHeader := TRUE;
        END;
    END;

    LOCAL PROCEDURE UpdateHandledICInboxTransaction@111(SalesHeader@1000 : Record 36);
    VAR
      HandledICInboxTrans@1001 : Record 420;
      Customer@1002 : Record 18;
    BEGIN
      WITH SalesHeader DO
        IF "IC Direction" = "IC Direction"::Incoming THEN BEGIN
          HandledICInboxTrans.SETRANGE("Document No.","External Document No.");
          Customer.GET("Sell-to Customer No.");
          HandledICInboxTrans.SETRANGE("IC Partner Code",Customer."IC Partner Code");
          HandledICInboxTrans.LOCKTABLE;
          IF HandledICInboxTrans.FINDFIRST THEN BEGIN
            HandledICInboxTrans.Status := HandledICInboxTrans.Status::Posted;
            HandledICInboxTrans.MODIFY;
          END;
        END;
    END;

    [External]
    PROCEDURE GetPostedDocumentRecord@222(SalesHeader@1000 : Record 36;VAR PostedSalesDocumentVariant@1001 : Variant);
    VAR
      SalesInvHeader@1007 : Record 112;
      SalesCrMemoHeader@1006 : Record 114;
    BEGIN
      WITH SalesHeader DO
        CASE "Document Type" OF
          "Document Type"::Order:
            IF Invoice THEN BEGIN
              SalesInvHeader.GET("Last Posting No.");
              SalesInvHeader.SETRECFILTER;
              PostedSalesDocumentVariant := SalesInvHeader;
            END;
          "Document Type"::Invoice:
            BEGIN
              IF "Last Posting No." = '' THEN
                SalesInvHeader.GET("No.")
              ELSE
                SalesInvHeader.GET("Last Posting No.");

              SalesInvHeader.SETRECFILTER;
              PostedSalesDocumentVariant := SalesInvHeader;
            END;
          "Document Type"::"Credit Memo":
            BEGIN
              IF "Last Posting No." = '' THEN
                SalesCrMemoHeader.GET("No.")
              ELSE
                SalesCrMemoHeader.GET("Last Posting No.");
              SalesCrMemoHeader.SETRECFILTER;
              PostedSalesDocumentVariant := SalesCrMemoHeader;
            END;
          "Document Type"::"Return Order":
            IF Invoice THEN BEGIN
              IF "Last Posting No." = '' THEN
                SalesCrMemoHeader.GET("No.")
              ELSE
                SalesCrMemoHeader.GET("Last Posting No.");
              SalesCrMemoHeader.SETRECFILTER;
              PostedSalesDocumentVariant := SalesCrMemoHeader;
            END;
          ELSE
            ERROR(STRSUBSTNO(NotSupportedDocumentTypeErr,"Document Type"));
        END;
    END;

    PROCEDURE SendPostedDocumentRecord@223(SalesHeader@1000 : Record 36;VAR DocumentSendingProfile@1001 : Record 60);
    VAR
      SalesInvHeader@1007 : Record 112;
      SalesCrMemoHeader@1006 : Record 114;
      SalesShipmentHeader@1002 : Record 110;
      OfficeManagement@1003 : Codeunit 1630;
    BEGIN
      WITH SalesHeader DO
        CASE "Document Type" OF
          "Document Type"::Order:
            BEGIN
              OnSendSalesDocument(Invoice AND Ship);
              IF Invoice THEN BEGIN
                SalesInvHeader.GET("Last Posting No.");
                SalesInvHeader.SETRECFILTER;
                SalesInvHeader.SendProfile(DocumentSendingProfile);
              END;
              IF Ship AND Invoice AND NOT OfficeManagement.IsAvailable
              THEN
                IF NOT CONFIRM(DownloadShipmentAlsoQst,TRUE) THEN
                  EXIT;
              IF Ship THEN BEGIN
                SalesShipmentHeader.GET("Last Shipping No.");
                SalesShipmentHeader.SETRECFILTER;
                SalesShipmentHeader.SendProfile(DocumentSendingProfile);
              END;
            END;
          "Document Type"::Invoice:
            BEGIN
              IF "Last Posting No." = '' THEN
                SalesInvHeader.GET("No.")
              ELSE
                SalesInvHeader.GET("Last Posting No.");

              SalesInvHeader.SETRECFILTER;
              SalesInvHeader.SendProfile(DocumentSendingProfile);
            END;
          "Document Type"::"Credit Memo":
            BEGIN
              IF "Last Posting No." = '' THEN
                SalesCrMemoHeader.GET("No.")
              ELSE
                SalesCrMemoHeader.GET("Last Posting No.");
              SalesCrMemoHeader.SETRECFILTER;
              SalesCrMemoHeader.SendProfile(DocumentSendingProfile);
            END;
          "Document Type"::"Return Order":
            IF Invoice THEN BEGIN
              IF "Last Posting No." = '' THEN
                SalesCrMemoHeader.GET("No.")
              ELSE
                SalesCrMemoHeader.GET("Last Posting No.");
              SalesCrMemoHeader.SETRECFILTER;
              SalesCrMemoHeader.SendProfile(DocumentSendingProfile);
            END;
          ELSE
            ERROR(STRSUBSTNO(NotSupportedDocumentTypeErr,"Document Type"));
        END;
    END;

    LOCAL PROCEDURE MakeInventoryAdjustment@112();
    VAR
      InvtSetup@1000 : Record 313;
      InvtAdjmt@1001 : Codeunit 5895;
    BEGIN
      InvtSetup.GET;
      IF InvtSetup."Automatic Cost Adjustment" <>
         InvtSetup."Automatic Cost Adjustment"::Never
      THEN BEGIN
        InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
        InvtAdjmt.SetJobUpdateProperties(TRUE);
        InvtAdjmt.MakeMultiLevelAdjmt;
      END;
    END;

    LOCAL PROCEDURE FindNotShippedLines@30(SalesHeader@1000 : Record 36;VAR TempSalesLine@1001 : TEMPORARY Record 37);
    BEGIN
      WITH TempSalesLine DO BEGIN
        ResetTempLines(TempSalesLine);
        SETFILTER(Quantity,'<>0');
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
          SETFILTER("Qty. to Ship",'<>0');
        SETRANGE("Shipment No.",'');
      END;
    END;

    LOCAL PROCEDURE CheckTrackingAndWarehouseForShip@114(SalesHeader@1004 : Record 36) Ship : Boolean;
    VAR
      TempSalesLine@1000 : TEMPORARY Record 37;
    BEGIN
      WITH TempSalesLine DO BEGIN
        FindNotShippedLines(SalesHeader,TempSalesLine);
        Ship := FINDFIRST;
        WhseShip := TempWhseShptHeader.FINDFIRST;
        WhseReceive := TempWhseRcptHeader.FINDFIRST;
        IF Ship THEN BEGIN
          CheckTrackingSpecification(SalesHeader,TempSalesLine);
          IF NOT (WhseShip OR WhseReceive OR InvtPickPutaway) THEN
            CheckWarehouse(TempSalesLine);
        END;
        EXIT(Ship);
      END;
    END;

    LOCAL PROCEDURE CheckTrackingAndWarehouseForReceive@117(SalesHeader@1004 : Record 36) Receive : Boolean;
    VAR
      TempSalesLine@1000 : TEMPORARY Record 37;
    BEGIN
      WITH TempSalesLine DO BEGIN
        ResetTempLines(TempSalesLine);
        SETFILTER(Quantity,'<>0');
        SETFILTER("Return Qty. to Receive",'<>0');
        SETRANGE("Return Receipt No.",'');
        Receive := FINDFIRST;
        WhseShip := TempWhseShptHeader.FINDFIRST;
        WhseReceive := TempWhseRcptHeader.FINDFIRST;
        IF Receive THEN BEGIN
          CheckTrackingSpecification(SalesHeader,TempSalesLine);
          IF NOT (WhseReceive OR WhseShip OR InvtPickPutaway) THEN
            CheckWarehouse(TempSalesLine);
        END;
        EXIT(Receive);
      END;
    END;

    LOCAL PROCEDURE CheckIfInvPickExists@240(SalesHeader@1004 : Record 36) : Boolean;
    VAR
      TempSalesLine@1000 : TEMPORARY Record 37;
      WarehouseActivityLine@1001 : Record 5767;
    BEGIN
      WITH TempSalesLine DO BEGIN
        FindNotShippedLines(SalesHeader,TempSalesLine);
        IF ISEMPTY THEN
          EXIT(FALSE);
        FINDSET;
        REPEAT
          IF WarehouseActivityLine.ActivityExists(
               DATABASE::"Sales Line","Document Type","Document No.","Line No.",0,
               WarehouseActivityLine."Activity Type"::"Invt. Pick")
          THEN
            EXIT(TRUE);
        UNTIL NEXT = 0;
        EXIT(FALSE);
      END;
    END;

    LOCAL PROCEDURE CheckIfInvPutawayExists@239() : Boolean;
    VAR
      TempSalesLine@1000 : TEMPORARY Record 37;
      WarehouseActivityLine@1001 : Record 5767;
    BEGIN
      WITH TempSalesLine DO BEGIN
        ResetTempLines(TempSalesLine);
        SETFILTER(Quantity,'<>0');
        SETFILTER("Return Qty. to Receive",'<>0');
        SETRANGE("Return Receipt No.",'');
        IF ISEMPTY THEN
          EXIT(FALSE);
        FINDSET;
        REPEAT
          IF WarehouseActivityLine.ActivityExists(
               DATABASE::"Sales Line","Document Type","Document No.","Line No.",0,
               WarehouseActivityLine."Activity Type"::"Invt. Put-away")
          THEN
            EXIT(TRUE);
        UNTIL NEXT = 0;
        EXIT(FALSE);
      END;
    END;

    LOCAL PROCEDURE CalcInvoiceDiscountPosting@169(SalesHeader@1002 : Record 36;SalesLine@1001 : Record 37;SalesLineACY@1000 : Record 37;VAR InvoicePostBuffer@1003 : Record 49);
    BEGIN
      IF SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Reverse Charge VAT" THEN
        InvoicePostBuffer.CalcDiscountNoVAT(-SalesLine."Inv. Discount Amount",-SalesLineACY."Inv. Discount Amount")
      ELSE
        InvoicePostBuffer.CalcDiscount(
          SalesHeader."Prices Including VAT",-SalesLine."Inv. Discount Amount",-SalesLineACY."Inv. Discount Amount");
    END;

    LOCAL PROCEDURE CalcLineDiscountPosting@81(SalesHeader@1003 : Record 36;SalesLine@1002 : Record 37;SalesLineACY@1001 : Record 37;VAR InvoicePostBuffer@1000 : Record 49);
    BEGIN
      IF SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Reverse Charge VAT" THEN
        InvoicePostBuffer.CalcDiscountNoVAT(-SalesLine."Line Discount Amount",-SalesLineACY."Line Discount Amount")
      ELSE
        InvoicePostBuffer.CalcDiscount(
          SalesHeader."Prices Including VAT",-SalesLine."Line Discount Amount",-SalesLineACY."Line Discount Amount");
    END;

    LOCAL PROCEDURE FindTempItemChargeAssgntSales@119(SalesLineNo@1000 : Integer) : Boolean;
    BEGIN
      ClearItemChargeAssgntFilter;
      TempItemChargeAssgntSales.SETCURRENTKEY("Applies-to Doc. Type");
      TempItemChargeAssgntSales.SETRANGE("Document Line No.",SalesLineNo);
      EXIT(TempItemChargeAssgntSales.FINDSET);
    END;

    LOCAL PROCEDURE UpdateInvoicedQtyOnShipmentLine@120(VAR SalesShptLine@1000 : Record 111;QtyToBeInvoiced@1001 : Decimal;QtyToBeInvoicedBase@1002 : Decimal);
    BEGIN
      WITH SalesShptLine DO BEGIN
        "Quantity Invoiced" := "Quantity Invoiced" - QtyToBeInvoiced;
        "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" - QtyToBeInvoicedBase;
        "Qty. Shipped Not Invoiced" := Quantity - "Quantity Invoiced";
        MODIFY;
      END;
    END;

    [External]
    PROCEDURE SetPreviewMode@121(NewPreviewMode@1000 : Boolean);
    BEGIN
      PreviewMode := NewPreviewMode;
    END;

    LOCAL PROCEDURE PostDropOrderShipment@144(VAR SalesHeader@1001 : Record 36;VAR TempDropShptPostBuffer@1004 : TEMPORARY Record 223);
    VAR
      PurchSetup@1000 : Record 312;
      PurchCommentLine@1002 : Record 43;
      PurchOrderHeader@1006 : Record 38;
      PurchOrderLine@1005 : Record 39;
      RecordLinkManagement@1003 : Codeunit 447;
    BEGIN
      ArchivePurchaseOrders(TempDropShptPostBuffer);
      WITH SalesHeader DO
        IF TempDropShptPostBuffer.FINDSET THEN BEGIN
          PurchSetup.GET;
          REPEAT
            PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order,TempDropShptPostBuffer."Order No.");
            PurchRcptHeader.INIT;
            PurchRcptHeader.TRANSFERFIELDS(PurchOrderHeader);
            PurchRcptHeader."No." := PurchOrderHeader."Receiving No.";
            PurchRcptHeader."Order No." := PurchOrderHeader."No.";
            PurchRcptHeader."Posting Date" := "Posting Date";
            PurchRcptHeader."Document Date" := "Document Date";
            PurchRcptHeader."No. Printed" := 0;
            PurchRcptHeader.INSERT;

            ApprovalsMgmt.PostApprovalEntries(RECORDID,PurchRcptHeader.RECORDID,PurchRcptHeader."No.");

            IF PurchSetup."Copy Comments Order to Receipt" THEN BEGIN
              PurchCommentLine.CopyComments(
                PurchOrderHeader."Document Type",PurchCommentLine."Document Type"::Receipt,
                PurchOrderHeader."No.",PurchRcptHeader."No.");
              RecordLinkManagement.CopyLinks(PurchOrderHeader,PurchRcptHeader);
            END;
            TempDropShptPostBuffer.SETRANGE("Order No.",TempDropShptPostBuffer."Order No.");
            REPEAT
              PurchOrderLine.GET(
                PurchOrderLine."Document Type"::Order,
                TempDropShptPostBuffer."Order No.",TempDropShptPostBuffer."Order Line No.");
              PurchRcptLine.INIT;
              PurchRcptLine.TRANSFERFIELDS(PurchOrderLine);
              PurchRcptLine."Posting Date" := PurchRcptHeader."Posting Date";
              PurchRcptLine."Document No." := PurchRcptHeader."No.";
              PurchRcptLine.Quantity := TempDropShptPostBuffer.Quantity;
              PurchRcptLine."Quantity (Base)" := TempDropShptPostBuffer."Quantity (Base)";
              PurchRcptLine."Quantity Invoiced" := 0;
              PurchRcptLine."Qty. Invoiced (Base)" := 0;
              PurchRcptLine."Order No." := PurchOrderLine."Document No.";
              PurchRcptLine."Order Line No." := PurchOrderLine."Line No.";
              PurchRcptLine."Qty. Rcd. Not Invoiced" :=
                PurchRcptLine.Quantity - PurchRcptLine."Quantity Invoiced";

              IF PurchRcptLine.Quantity <> 0 THEN BEGIN
                PurchRcptLine."Item Rcpt. Entry No." := TempDropShptPostBuffer."Item Shpt. Entry No.";
                PurchRcptLine."Item Charge Base Amount" := PurchOrderLine."Line Amount"
              END;
              PurchRcptLine.INSERT;
              PurchPost.UpdateBlanketOrderLine(PurchOrderLine,TRUE,FALSE,FALSE);
            UNTIL TempDropShptPostBuffer.NEXT = 0;
            TempDropShptPostBuffer.SETRANGE("Order No.");
          UNTIL TempDropShptPostBuffer.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE PostInvoicePostBuffer@140(SalesHeader@1000 : Record 36;VAR TempInvoicePostBuffer@1004 : TEMPORARY Record 49);
    VAR
      LineCount@1002 : Integer;
      GLEntryNo@1001 : Integer;
    BEGIN
      LineCount := 0;
      IF TempInvoicePostBuffer.FIND('+') THEN
        REPEAT
          LineCount := LineCount + 1;
          IF GUIALLOWED THEN
            Window.UPDATE(3,LineCount);

          GLEntryNo := PostInvoicePostBufferLine(SalesHeader,TempInvoicePostBuffer);

          IF (TempInvoicePostBuffer."Job No." <> '') AND
             (TempInvoicePostBuffer.Type = TempInvoicePostBuffer.Type::"G/L Account")
          THEN
            JobPostLine.PostSalesGLAccounts(TempInvoicePostBuffer,GLEntryNo);

        UNTIL TempInvoicePostBuffer.NEXT(-1) = 0;

      TempInvoicePostBuffer.DELETEALL;
    END;

    LOCAL PROCEDURE PostInvoicePostBufferLine@158(SalesHeader@1000 : Record 36;InvoicePostBuffer@1001 : Record 49) GLEntryNo : Integer;
    VAR
      GenJnlLine@1002 : Record 81;
    BEGIN
      WITH GenJnlLine DO BEGIN
        InitNewLine(
          SalesHeader."Posting Date",SalesHeader."Document Date",SalesHeader."Posting Description",
          InvoicePostBuffer."Global Dimension 1 Code",InvoicePostBuffer."Global Dimension 2 Code",
          InvoicePostBuffer."Dimension Set ID",SalesHeader."Reason Code");

        CopyDocumentFields(GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,'');

        CopyFromSalesHeader(SalesHeader);

        CopyFromInvoicePostBuffer(InvoicePostBuffer);
        IF InvoicePostBuffer.Type <> InvoicePostBuffer.Type::"Prepmt. Exch. Rate Difference" THEN
          "Gen. Posting Type" := "Gen. Posting Type"::Sale;
        IF InvoicePostBuffer.Type = InvoicePostBuffer.Type::"Fixed Asset" THEN BEGIN
          "FA Posting Type" := "FA Posting Type"::Disposal;
          CopyFromInvoicePostBufferFA(InvoicePostBuffer);
        END;

        OnBeforePostInvPostBuffer(GenJnlLine,InvoicePostBuffer,SalesHeader);
        GLEntryNo := RunGenJnlPostLine(GenJnlLine);
        OnAfterPostInvPostBuffer(GenJnlLine,InvoicePostBuffer,SalesHeader,GLEntryNo);
      END;
    END;

    LOCAL PROCEDURE PostItemTracking@152(SalesHeader@1000 : Record 36;SalesLine@1002 : Record 37;TrackingSpecificationExists@1004 : Boolean;VAR TempTrackingSpecification@1005 : TEMPORARY Record 336;VAR TempItemLedgEntryNotInvoiced@1009 : TEMPORARY Record 32;HasATOShippedNotInvoiced@1012 : Boolean);
    VAR
      ItemEntryRelation@1006 : Record 6507;
      ReturnRcptLine@1003 : Record 6661;
      SalesShptLine@1007 : Record 111;
      EndLoop@1001 : Boolean;
      RemQtyToInvoiceCurrLine@1011 : Decimal;
      RemQtyToInvoiceCurrLineBase@1010 : Decimal;
      QtyToBeInvoiced@1013 : Decimal;
      QtyToBeInvoicedBase@1008 : Decimal;
      QtyToInvoiceBaseInTrackingSpec@1014 : Decimal;
    BEGIN
      WITH SalesHeader DO BEGIN
        EndLoop := FALSE;
        IF TrackingSpecificationExists THEN BEGIN
          TempTrackingSpecification.CALCSUMS("Qty. to Invoice (Base)");
          QtyToInvoiceBaseInTrackingSpec := TempTrackingSpecification."Qty. to Invoice (Base)";
          IF NOT TempTrackingSpecification.FINDFIRST THEN
            TempTrackingSpecification.INIT;
        END;

        IF SalesLine.IsCreditDocType THEN BEGIN
          IF (ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Return Qty. to Receive")) OR
             (ABS(RemQtyToBeInvoiced) >= ABS(QtyToInvoiceBaseInTrackingSpec)) AND (QtyToInvoiceBaseInTrackingSpec <> 0)
          THEN BEGIN
            ReturnRcptLine.RESET;
            CASE "Document Type" OF
              "Document Type"::"Return Order":
                BEGIN
                  ReturnRcptLine.SETCURRENTKEY("Return Order No.","Return Order Line No.");
                  ReturnRcptLine.SETRANGE("Return Order No.",SalesLine."Document No.");
                  ReturnRcptLine.SETRANGE("Return Order Line No.",SalesLine."Line No.");
                END;
              "Document Type"::"Credit Memo":
                BEGIN
                  ReturnRcptLine.SETRANGE("Document No.",SalesLine."Return Receipt No.");
                  ReturnRcptLine.SETRANGE("Line No.",SalesLine."Return Receipt Line No.");
                END;
            END;
            ReturnRcptLine.SETFILTER("Return Qty. Rcd. Not Invd.",'<>0');
            IF ReturnRcptLine.FIND('-') THEN BEGIN
              ItemJnlRollRndg := TRUE;
              REPEAT
                IF TrackingSpecificationExists THEN BEGIN  // Item Tracking
                  ItemEntryRelation.GET(TempTrackingSpecification."Item Ledger Entry No.");
                  ReturnRcptLine.GET(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
                END ELSE
                  ItemEntryRelation."Item Entry No." := ReturnRcptLine."Item Rcpt. Entry No.";
                ReturnRcptLine.TESTFIELD("Sell-to Customer No.",SalesLine."Sell-to Customer No.");
                ReturnRcptLine.TESTFIELD(Type,SalesLine.Type);
                ReturnRcptLine.TESTFIELD("No.",SalesLine."No.");
                ReturnRcptLine.TESTFIELD("Gen. Bus. Posting Group",SalesLine."Gen. Bus. Posting Group");
                ReturnRcptLine.TESTFIELD("Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group");
                ReturnRcptLine.TESTFIELD("Job No.",SalesLine."Job No.");
                ReturnRcptLine.TESTFIELD("Unit of Measure Code",SalesLine."Unit of Measure Code");
                ReturnRcptLine.TESTFIELD("Variant Code",SalesLine."Variant Code");
                IF SalesLine."Qty. to Invoice" * ReturnRcptLine.Quantity < 0 THEN
                  SalesLine.FIELDERROR("Qty. to Invoice",ReturnReceiptSameSignErr);
                UpdateQtyToBeInvoicedForReturnReceipt(
                  QtyToBeInvoiced,QtyToBeInvoicedBase,
                  TrackingSpecificationExists,SalesLine,ReturnRcptLine,TempTrackingSpecification);

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
                ReturnRcptLine."Quantity Invoiced" :=
                  ReturnRcptLine."Quantity Invoiced" + QtyToBeInvoiced;
                ReturnRcptLine."Qty. Invoiced (Base)" :=
                  ReturnRcptLine."Qty. Invoiced (Base)" + QtyToBeInvoicedBase;
                ReturnRcptLine."Return Qty. Rcd. Not Invd." :=
                  ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced";
                ReturnRcptLine.MODIFY;
                IF SalesLine.Type = SalesLine.Type::Item THEN
                  PostItemJnlLine(
                    SalesHeader,SalesLine,
                    0,0,
                    QtyToBeInvoiced,
                    QtyToBeInvoicedBase,
                    // ReturnRcptLine."Item Rcpt. Entry No."
                    ItemEntryRelation."Item Entry No.",'',TempTrackingSpecification,FALSE);
                IF TrackingSpecificationExists THEN
                  EndLoop := (TempTrackingSpecification.NEXT = 0) OR (RemQtyToBeInvoiced = 0)
                ELSE
                  EndLoop :=
                    (ReturnRcptLine.NEXT = 0) OR (ABS(RemQtyToBeInvoiced) <= ABS(SalesLine."Return Qty. to Receive"));
              UNTIL EndLoop;
            END ELSE
              ERROR(
                ReturnReceiptInvoicedErr,
                SalesLine."Return Receipt Line No.",SalesLine."Return Receipt No.");
          END;

          IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Return Qty. to Receive") THEN BEGIN
            IF "Document Type" = "Document Type"::"Credit Memo" THEN
              ERROR(
                InvoiceGreaterThanReturnReceiptErr,
                ReturnRcptLine."Document No.");
            ERROR(ReturnReceiptLinesDeletedErr);
          END;
        END ELSE BEGIN
          IF (ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Qty. to Ship")) OR
             (ABS(RemQtyToBeInvoiced) >= ABS(QtyToInvoiceBaseInTrackingSpec)) AND (QtyToInvoiceBaseInTrackingSpec <> 0)
          THEN BEGIN
            SalesShptLine.RESET;
            CASE "Document Type" OF
              "Document Type"::Order:
                BEGIN
                  SalesShptLine.SETCURRENTKEY("Order No.","Order Line No.");
                  SalesShptLine.SETRANGE("Order No.",SalesLine."Document No.");
                  SalesShptLine.SETRANGE("Order Line No.",SalesLine."Line No.");
                END;
              "Document Type"::Invoice:
                BEGIN
                  SalesShptLine.SETRANGE("Document No.",SalesLine."Shipment No.");
                  SalesShptLine.SETRANGE("Line No.",SalesLine."Shipment Line No.");
                END;
            END;

            IF NOT TrackingSpecificationExists THEN
              HasATOShippedNotInvoiced := GetATOItemLedgEntriesNotInvoiced(SalesLine,TempItemLedgEntryNotInvoiced);

            SalesShptLine.SETFILTER("Qty. Shipped Not Invoiced",'<>0');
            IF SalesShptLine.FINDFIRST THEN BEGIN
              ItemJnlRollRndg := TRUE;
              REPEAT
                SetItemEntryRelation(
                  ItemEntryRelation,SalesShptLine,
                  TempTrackingSpecification,TempItemLedgEntryNotInvoiced,
                  TrackingSpecificationExists,HasATOShippedNotInvoiced);

                UpdateRemainingQtyToBeInvoiced(SalesShptLine,RemQtyToInvoiceCurrLine,RemQtyToInvoiceCurrLineBase);

                SalesShptLine.TESTFIELD("Sell-to Customer No.",SalesLine."Sell-to Customer No.");
                SalesShptLine.TESTFIELD(Type,SalesLine.Type);
                SalesShptLine.TESTFIELD("No.",SalesLine."No.");
                SalesShptLine.TESTFIELD("Gen. Bus. Posting Group",SalesLine."Gen. Bus. Posting Group");
                SalesShptLine.TESTFIELD("Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group");
                SalesShptLine.TESTFIELD("Job No.",SalesLine."Job No.");
                SalesShptLine.TESTFIELD("Unit of Measure Code",SalesLine."Unit of Measure Code");
                SalesShptLine.TESTFIELD("Variant Code",SalesLine."Variant Code");
                IF -SalesLine."Qty. to Invoice" * SalesShptLine.Quantity < 0 THEN
                  SalesLine.FIELDERROR("Qty. to Invoice",ShipmentSameSignErr);

                UpdateQtyToBeInvoicedForShipment(
                  QtyToBeInvoiced,QtyToBeInvoicedBase,
                  TrackingSpecificationExists,HasATOShippedNotInvoiced,
                  SalesLine,SalesShptLine,
                  TempTrackingSpecification,TempItemLedgEntryNotInvoiced);

                IF TrackingSpecificationExists THEN BEGIN
                  TempTrackingSpecification."Quantity actual Handled (Base)" := QtyToBeInvoicedBase;
                  TempTrackingSpecification.MODIFY;
                END;

                IF TrackingSpecificationExists OR HasATOShippedNotInvoiced THEN
                  ItemTrackingMgt.AdjustQuantityRounding(
                    RemQtyToInvoiceCurrLine,QtyToBeInvoiced,
                    RemQtyToInvoiceCurrLineBase,QtyToBeInvoicedBase);

                RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
                RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;
                UpdateInvoicedQtyOnShipmentLine(SalesShptLine,QtyToBeInvoiced,QtyToBeInvoicedBase);
                IF SalesLine.Type = SalesLine.Type::Item THEN
                  PostItemJnlLine(
                    SalesHeader,SalesLine,
                    0,0,
                    QtyToBeInvoiced,
                    QtyToBeInvoicedBase,
                    // SalesShptLine."Item Shpt. Entry No."
                    ItemEntryRelation."Item Entry No.",'',TempTrackingSpecification,FALSE);
              UNTIL IsEndLoopForShippedNotInvoiced(
                      RemQtyToBeInvoiced,TrackingSpecificationExists,HasATOShippedNotInvoiced,
                      SalesShptLine,TempTrackingSpecification,TempItemLedgEntryNotInvoiced,SalesLine);
            END ELSE
              ERROR(
                ShipmentInvoiceErr,SalesLine."Shipment Line No.",SalesLine."Shipment No.");
          END;

          IF ABS(RemQtyToBeInvoiced) > ABS(SalesLine."Qty. to Ship") THEN BEGIN
            IF "Document Type" = "Document Type"::Invoice THEN
              ERROR(QuantityToInvoiceGreaterErr,SalesShptLine."Document No.");
            ERROR(ShipmentLinesDeletedErr);
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE PostUpdateOrderLine@149(SalesHeader@1000 : Record 36);
    VAR
      TempSalesLine@1001 : TEMPORARY Record 37;
    BEGIN
      ResetTempLines(TempSalesLine);
      WITH TempSalesLine DO BEGIN
        SETFILTER(Quantity,'<>0');
        IF FINDSET THEN
          REPEAT
            IF SalesHeader.Ship THEN BEGIN
              "Quantity Shipped" += "Qty. to Ship";
              "Qty. Shipped (Base)" += "Qty. to Ship (Base)";
            END;
            IF SalesHeader.Receive THEN BEGIN
              "Return Qty. Received" += "Return Qty. to Receive";
              "Return Qty. Received (Base)" += "Return Qty. to Receive (Base)";
            END;
            IF SalesHeader.Invoice THEN BEGIN
              IF "Document Type" = "Document Type"::Order THEN BEGIN
                IF ABS("Quantity Invoiced" + "Qty. to Invoice") > ABS("Quantity Shipped") THEN BEGIN
                  VALIDATE("Qty. to Invoice","Quantity Shipped" - "Quantity Invoiced");
                  "Qty. to Invoice (Base)" := "Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
                END
              END ELSE
                IF ABS("Quantity Invoiced" + "Qty. to Invoice") > ABS("Return Qty. Received") THEN BEGIN
                  VALIDATE("Qty. to Invoice","Return Qty. Received" - "Quantity Invoiced");
                  "Qty. to Invoice (Base)" := "Return Qty. Received (Base)" - "Qty. Invoiced (Base)";
                END;

              "Quantity Invoiced" += "Qty. to Invoice";
              "Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
              IF "Qty. to Invoice" <> 0 THEN BEGIN
                "Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
                "Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
                DecrementPrepmtAmtInvLCY(
                  TempSalesLine,"Prepmt. Amount Inv. (LCY)","Prepmt. VAT Amount Inv. (LCY)");
                "Prepmt Amt to Deduct" := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";
                "Prepmt VAT Diff. to Deduct" := 0;
              END;
            END;

            UpdateBlanketOrderLine(TempSalesLine,SalesHeader.Ship,SalesHeader.Receive,SalesHeader.Invoice);
            InitOutstanding;
            CheckATOLink(TempSalesLine);
            IF WhseHandlingRequired(TempSalesLine) OR
               (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Blank)
            THEN BEGIN
              IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
                "Return Qty. to Receive" := 0;
                "Return Qty. to Receive (Base)" := 0;
              END ELSE BEGIN
                "Qty. to Ship" := 0;
                "Qty. to Ship (Base)" := 0;
              END;
              InitQtyToInvoice;
            END ELSE BEGIN
              IF "Document Type" = "Document Type"::"Return Order" THEN
                InitQtyToReceive
              ELSE
                InitQtyToShip2;
            END;

            IF ("Purch. Order Line No." <> 0) AND (Quantity = "Quantity Invoiced") THEN
              UpdateAssocLines(TempSalesLine);
            SetDefaultQuantity;
            ModifyTempLine(TempSalesLine);

            OnAfterPostUpdateOrderLineModifyTempLine(TempSalesLine,WhseShip,WhseReceive);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE PostUpdateInvoiceLine@141();
    VAR
      SalesOrderLine@1001 : Record 37;
      SalesShptLine@1002 : Record 111;
      TempSalesLine@1000 : TEMPORARY Record 37;
      TempSalesOrderHeader@1003 : TEMPORARY Record 36;
      CRMSalesDocumentPostingMgt@1004 : Codeunit 5346;
    BEGIN
      ResetTempLines(TempSalesLine);
      WITH TempSalesLine DO BEGIN
        SETFILTER("Shipment No.",'<>%1','');
        SETFILTER(Type,'<>%1',Type::" ");
        IF FINDSET THEN
          REPEAT
            SalesShptLine.GET("Shipment No.","Shipment Line No.");
            SalesOrderLine.GET(
              SalesOrderLine."Document Type"::Order,
              SalesShptLine."Order No.",SalesShptLine."Order Line No.");
            IF Type = Type::"Charge (Item)" THEN
              UpdateSalesOrderChargeAssgnt(TempSalesLine,SalesOrderLine);
            SalesOrderLine."Quantity Invoiced" += "Qty. to Invoice";
            SalesOrderLine."Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
            IF ABS(SalesOrderLine."Quantity Invoiced") > ABS(SalesOrderLine."Quantity Shipped") THEN
              ERROR(InvoiceMoreThanShippedErr,SalesOrderLine."Document No.");
            SalesOrderLine.InitQtyToInvoice;
            IF SalesOrderLine."Prepayment %" <> 0 THEN BEGIN
              SalesOrderLine."Prepmt Amt Deducted" += "Prepmt Amt to Deduct";
              SalesOrderLine."Prepmt VAT Diff. Deducted" += "Prepmt VAT Diff. to Deduct";
              DecrementPrepmtAmtInvLCY(
                TempSalesLine,SalesOrderLine."Prepmt. Amount Inv. (LCY)",SalesOrderLine."Prepmt. VAT Amount Inv. (LCY)");
              SalesOrderLine."Prepmt Amt to Deduct" :=
                SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted";
              SalesOrderLine."Prepmt VAT Diff. to Deduct" := 0;
            END;
            SalesOrderLine.InitOutstanding;
            SalesOrderLine.MODIFY;
            IF NOT TempSalesOrderHeader.GET(SalesOrderLine."Document Type",SalesOrderLine."Document No.") THEN BEGIN
              TempSalesOrderHeader."Document Type" := SalesOrderLine."Document Type";
              TempSalesOrderHeader."No." := SalesOrderLine."Document No.";
              TempSalesOrderHeader.INSERT;
            END;
          UNTIL NEXT = 0;
        CRMSalesDocumentPostingMgt.CheckShippedOrders(TempSalesOrderHeader);
      END;
    END;

    LOCAL PROCEDURE PostUpdateReturnReceiptLine@142();
    VAR
      SalesOrderLine@1002 : Record 37;
      ReturnRcptLine@1000 : Record 6661;
      TempSalesLine@1001 : TEMPORARY Record 37;
    BEGIN
      ResetTempLines(TempSalesLine);
      WITH TempSalesLine DO BEGIN
        SETFILTER("Return Receipt No.",'<>%1','');
        SETFILTER(Type,'<>%1',Type::" ");
        IF FINDSET THEN
          REPEAT
            ReturnRcptLine.GET("Return Receipt No.","Return Receipt Line No.");
            SalesOrderLine.GET(
              SalesOrderLine."Document Type"::"Return Order",
              ReturnRcptLine."Return Order No.",ReturnRcptLine."Return Order Line No.");
            IF Type = Type::"Charge (Item)" THEN
              UpdateSalesOrderChargeAssgnt(TempSalesLine,SalesOrderLine);
            SalesOrderLine."Quantity Invoiced" += "Qty. to Invoice";
            SalesOrderLine."Qty. Invoiced (Base)" += "Qty. to Invoice (Base)";
            IF ABS(SalesOrderLine."Quantity Invoiced") > ABS(SalesOrderLine."Return Qty. Received") THEN
              ERROR(InvoiceMoreThanReceivedErr,SalesOrderLine."Document No.");
            SalesOrderLine.InitQtyToInvoice;
            SalesOrderLine.InitOutstanding;
            SalesOrderLine.MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE FillDeferralPostingBuffer@123(SalesHeader@1008 : Record 36;SalesLine@1000 : Record 37;InvoicePostBuffer@1009 : Record 49;RemainAmtToDefer@1001 : Decimal;RemainAmtToDeferACY@1002 : Decimal;DeferralAccount@1003 : Code[20];SalesAccount@1004 : Code[20]);
    VAR
      DeferralTemplate@1007 : Record 1700;
    BEGIN
      DeferralTemplate.GET(SalesLine."Deferral Code");

      IF TempDeferralHeader.GET(DeferralUtilities.GetSalesDeferralDocType,'','',
           SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.")
      THEN BEGIN
        IF TempDeferralHeader."Amount to Defer" <> 0 THEN BEGIN
          DeferralUtilities.FilterDeferralLines(
            TempDeferralLine,DeferralUtilities.GetSalesDeferralDocType,'','',
            SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");

          // Remainder\Initial deferral pair
          DeferralPostBuffer.PrepareSales(SalesLine,GenJnlLineDocNo);
          DeferralPostBuffer."Posting Date" := SalesHeader."Posting Date";
          DeferralPostBuffer.Description := SalesHeader."Posting Description";
          DeferralPostBuffer."Period Description" := DeferralTemplate."Period Description";
          DeferralPostBuffer."Deferral Line No." := InvDefLineNo;
          DeferralPostBuffer.PrepareInitialPair(
            InvoicePostBuffer,RemainAmtToDefer,RemainAmtToDeferACY,SalesAccount,DeferralAccount);
          DeferralPostBuffer.Update(DeferralPostBuffer,InvoicePostBuffer);
          IF (RemainAmtToDefer <> 0) OR (RemainAmtToDeferACY <> 0) THEN BEGIN
            DeferralPostBuffer.PrepareRemainderSales(
              SalesLine,RemainAmtToDefer,RemainAmtToDeferACY,SalesAccount,DeferralAccount,InvDefLineNo);
            DeferralPostBuffer.Update(DeferralPostBuffer,InvoicePostBuffer);
          END;

          // Add the deferral lines for each period to the deferral posting buffer merging when they are the same
          IF TempDeferralLine.FINDSET THEN
            REPEAT
              IF (TempDeferralLine."Amount (LCY)" <> 0) OR (TempDeferralLine.Amount <> 0) THEN BEGIN
                DeferralPostBuffer.PrepareSales(SalesLine,GenJnlLineDocNo);
                DeferralPostBuffer.InitFromDeferralLine(TempDeferralLine);
                IF NOT SalesLine.IsCreditDocType THEN
                  DeferralPostBuffer.ReverseAmounts;
                DeferralPostBuffer."G/L Account" := SalesAccount;
                DeferralPostBuffer."Deferral Account" := DeferralAccount;
                DeferralPostBuffer."Period Description" := DeferralTemplate."Period Description";
                DeferralPostBuffer."Deferral Line No." := InvDefLineNo;
                DeferralPostBuffer.Update(DeferralPostBuffer,InvoicePostBuffer);
              END ELSE
                ERROR(ZeroDeferralAmtErr,SalesLine."No.",SalesLine."Deferral Code");

            UNTIL TempDeferralLine.NEXT = 0

          ELSE
            ERROR(NoDeferralScheduleErr,SalesLine."No.",SalesLine."Deferral Code");
        END ELSE
          ERROR(NoDeferralScheduleErr,SalesLine."No.",SalesLine."Deferral Code")
      END ELSE
        ERROR(NoDeferralScheduleErr,SalesLine."No.",SalesLine."Deferral Code");
    END;

    LOCAL PROCEDURE RoundDeferralsForArchive@126(SalesHeader@1000 : Record 36;VAR SalesLine@1001 : Record 37);
    VAR
      ArchiveManagement@1005 : Codeunit 5063;
    BEGIN
      ArchiveManagement.RoundSalesDeferralsForArchive(SalesHeader,SalesLine);
    END;

    LOCAL PROCEDURE GetAmountsForDeferral@127(SalesLine@1001 : Record 37;VAR AmtToDefer@1002 : Decimal;VAR AmtToDeferACY@1003 : Decimal;VAR DeferralAccount@1004 : Code[20]);
    VAR
      DeferralTemplate@1005 : Record 1700;
    BEGIN
      DeferralTemplate.GET(SalesLine."Deferral Code");
      DeferralTemplate.TESTFIELD("Deferral Account");
      DeferralAccount := DeferralTemplate."Deferral Account";

      IF TempDeferralHeader.GET(DeferralUtilities.GetSalesDeferralDocType,'','',
           SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.")
      THEN BEGIN
        AmtToDeferACY := TempDeferralHeader."Amount to Defer";
        AmtToDefer := TempDeferralHeader."Amount to Defer (LCY)";
      END;

      IF NOT SalesLine.IsCreditDocType THEN BEGIN
        AmtToDefer := -AmtToDefer;
        AmtToDeferACY := -AmtToDeferACY;
      END;
    END;

    LOCAL PROCEDURE CheckMandatoryHeaderFields@128(SalesHeader@1000 : Record 36);
    BEGIN
      SalesHeader.TESTFIELD("Document Type");
      SalesHeader.TESTFIELD("Sell-to Customer No.");
      SalesHeader.TESTFIELD("Bill-to Customer No.");
      SalesHeader.TESTFIELD("Posting Date");
      SalesHeader.TESTFIELD("Document Date");

      OnAfterCheckMandatoryFields(SalesHeader);
    END;

    LOCAL PROCEDURE ClearPostBuffers@132();
    BEGIN
      CLEAR(WhsePostRcpt);
      CLEAR(WhsePostShpt);
      CLEAR(GenJnlPostLine);
      CLEAR(ResJnlPostLine);
      CLEAR(JobPostLine);
      CLEAR(ItemJnlPostLine);
      CLEAR(WhseJnlPostLine);
    END;

    LOCAL PROCEDURE SetPostingFlags@138(VAR SalesHeader@1000 : Record 36);
    BEGIN
      WITH SalesHeader DO BEGIN
        CASE "Document Type" OF
          "Document Type"::Order:
            Receive := FALSE;
          "Document Type"::Invoice:
            BEGIN
              Ship := TRUE;
              Invoice := TRUE;
              Receive := FALSE;
            END;
          "Document Type"::"Return Order":
            Ship := FALSE;
          "Document Type"::"Credit Memo":
            BEGIN
              Ship := FALSE;
              Invoice := TRUE;
              Receive := TRUE;
            END;
        END;
        IF NOT (Ship OR Invoice OR Receive) THEN
          ERROR(ShipInvoiceReceiveErr);
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostSalesDoc@133(VAR SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostCommitSalesDoc@134(VAR SalesHeader@1000 : Record 36;VAR GenJnlPostLine@1003 : Codeunit 12;PreviewMode@1001 : Boolean;ModifyHeader@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCheckSalesDoc@1(SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterFillInvoicePostBuffer@208(VAR InvoicePostBuffer@1000 : Record 49;SalesLine@1001 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostSalesDoc@135(VAR SalesHeader@1001 : Record 36;VAR GenJnlPostLine@1000 : Codeunit 12;SalesShptHdrNo@1002 : Code[20];RetRcpHdrNo@1003 : Code[20];SalesInvHdrNo@1004 : Code[20];SalesCrMemoHdrNo@1005 : Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostBalancingEntry@204(VAR GenJnlLine@1000 : Record 81;VAR SalesHeader@1003 : Record 36;VAR TotalSalesLine@1002 : Record 37;VAR TotalSalesLineLCY@1001 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostInvPostBuffer@205(VAR GenJnlLine@1000 : Record 81;VAR InvoicePostBuffer@1001 : Record 49;VAR SalesHeader@1003 : Record 36;GLEntryNo@1002 : Integer);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterUpdatePostingNos@22(VAR SalesHeader@1000 : Record 36;VAR NoSeriesMgt@1001 : Codeunit 396);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCheckMandatoryFields@195(VAR SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterSalesInvHeaderInsert@207(VAR SalesInvHeader@1000 : Record 112;SalesHeader@1001 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterSalesInvLineInsert@174(VAR SalesInvLine@1000 : Record 113;SalesInvHeader@1002 : Record 112;SalesLine@1001 : Record 37;ItemLedgShptEntryNo@1003 : Integer;WhseShip@1004 : Boolean;WhseReceive@1005 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterSalesCrMemoHeaderInsert@203(VAR SalesCrMemoHeader@1001 : Record 114;SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterSalesCrMemoLineInsert@182(VAR SalesCrMemoLine@1000 : Record 115;SalesCrMemoHeader@1002 : Record 114;SalesHeader@1003 : Record 36;SalesLine@1001 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterSalesShptLineInsert@209(VAR SalesShipmentLine@1000 : Record 111;SalesLine@1001 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterReturnRcptLineInsert@206(VAR ReturnRcptLine@1002 : Record 6661;ReturnRcptHeader@1001 : Record 6660;SalesLine@1000 : Record 37;ItemShptLedEntryNo@1003 : Integer;WhseShip@1004 : Boolean;WhseReceive@1005 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterFinalizePosting@196(VAR SalesHeader@1000 : Record 36;VAR SalesShipmentHeader@1001 : Record 110;VAR SalesInvoiceHeader@1002 : Record 112;VAR SalesCrMemoHeader@1003 : Record 114;VAR ReturnReceiptHeader@1004 : Record 6660;VAR GenJnlPostLine@1005 : Codeunit 12);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertICGenJnlLine@198(VAR ICGenJournalLine@1000 : Record 81;SalesHeader@1001 : Record 36;SalesLine@1002 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInvoiceRoundingAmount@211(SalesHeader@1000 : Record 36;TotalAmountIncludingVAT@1001 : Decimal;UseTempData@1002 : Boolean;VAR InvoiceRoundingAmount@1003 : Decimal);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeItemJnlPostLine@227(VAR ItemJournalLine@1000 : Record 83;SalesLine@1001 : Record 37;SalesHeader@1002 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeSalesShptHeaderInsert@183(VAR SalesShptHeader@1001 : Record 110;SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeSalesShptLineInsert@192(VAR SalesShptLine@1001 : Record 111;SalesShptHeader@1002 : Record 110;SalesLine@1000 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeSalesInvHeaderInsert@185(VAR SalesInvHeader@1001 : Record 112;SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeSalesInvLineInsert@189(VAR SalesInvLine@1001 : Record 113;SalesInvHeader@1000 : Record 112;SalesLine@1002 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeSalesCrMemoHeaderInsert@187(VAR SalesCrMemoHeader@1001 : Record 114;SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeSalesCrMemoLineInsert@190(VAR SalesCrMemoLine@1001 : Record 115;SalesCrMemoHeader@1000 : Record 114;SalesLine@1002 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeReturnRcptHeaderInsert@186(VAR ReturnRcptHeader@1001 : Record 6660;SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeReturnRcptLineInsert@191(VAR ReturnRcptLine@1001 : Record 6661;ReturnRcptHeader@1002 : Record 6660;SalesLine@1000 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostCustomerEntry@193(VAR GenJnlLine@1003 : Record 81;SalesHeader@1000 : Record 36;VAR TotalSalesLine@1001 : Record 37;VAR TotalSalesLineLCY@1002 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostBalancingEntry@194(VAR GenJnlLine@1000 : Record 81;SalesHeader@1003 : Record 36;VAR TotalSalesLine@1002 : Record 37;VAR TotalSalesLineLCY@1001 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostInvPostBuffer@148(VAR GenJnlLine@1000 : Record 81;VAR InvoicePostBuffer@1001 : Record 49;SalesHeader@1003 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostAssocItemJnlLine@238(VAR ItemJournalLine@1000 : Record 83;PurchaseLine@1001 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostItemJnlLineWhseLine@1006(SalesLine@1000 : Record 37;ItemLedgEntryNo@1001 : Integer;WhseShip@1002 : Boolean;WhseReceive@1003 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTestSalesLine@1009(SalesLine@1000 : Record 37;WhseShip@1001 : Boolean;WhseReceive@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostUpdateOrderLineModifyTempLine@1010(SalesLine@1000 : Record 37;WhseShip@1001 : Boolean;WhseReceive@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterPostGLAndCustomer@218(VAR SalesHeader@1000 : Record 36;VAR GenJnlPostLine@1001 : Codeunit 12;TotalSalesLine@1003 : Record 37;TotalSalesLineLCY@1004 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePostGLAndCustomer@202(SalesHeader@1000 : Record 36;VAR TempInvoicePostBuffer@1001 : TEMPORARY Record 49;VAR CustLedgerEntry@1002 : Record 21);
    BEGIN
    END;

    LOCAL PROCEDURE PostResJnlLine@136(VAR SalesHeader@1000 : Record 36;VAR SalesLine@1002 : Record 37;VAR JobTaskSalesLine@1003 : Record 37);
    VAR
      ResJnlLine@1001 : Record 207;
    BEGIN
      IF SalesLine."Qty. to Invoice" = 0 THEN
        EXIT;

      WITH ResJnlLine DO BEGIN
        INIT;
        "Posting Date" := SalesHeader."Posting Date";
        "Document Date" := SalesHeader."Document Date";
        "Reason Code" := SalesHeader."Reason Code";

        CopyDocumentFields(GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,SalesHeader."Posting No. Series");

        CopyFromSalesLine(SalesLine);

        ResJnlPostLine.RunWithCheck(ResJnlLine);
        IF JobTaskSalesLine."Job Contract Entry No." > 0 THEN
          PostJobContractLine(SalesHeader,JobTaskSalesLine);
      END;
    END;

    LOCAL PROCEDURE ValidatePostingAndDocumentDate@199(VAR SalesHeader@1000 : Record 36);
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
        BatchProcessingMgt.GetParameterBoolean(SalesHeader.RECORDID,BatchPostParameterTypes.ReplacePostingDate,ReplacePostingDate) AND
        BatchProcessingMgt.GetParameterBoolean(
          SalesHeader.RECORDID,BatchPostParameterTypes.ReplaceDocumentDate,ReplaceDocumentDate) AND
        BatchProcessingMgt.GetParameterDate(SalesHeader.RECORDID,BatchPostParameterTypes.PostingDate,PostingDate);

      IF PostingDateExists AND (ReplacePostingDate OR (SalesHeader."Posting Date" = 0D)) THEN BEGIN
        SalesHeader."Posting Date" := PostingDate;
        SalesHeader.SynchronizeAsmHeader;
        SalesHeader.VALIDATE("Currency Code");
        ModifyHeader := TRUE;
      END;

      IF PostingDateExists AND (ReplaceDocumentDate OR (SalesHeader."Document Date" = 0D)) THEN BEGIN
        SalesHeader.VALIDATE("Document Date",PostingDate);
        ModifyHeader := TRUE;
      END;

      IF ModifyHeader THEN
        SalesHeader.MODIFY;
    END;

    LOCAL PROCEDURE UpdateSalesLineDimSetIDFromAppliedEntry@62(VAR SalesLineToPost@1000 : Record 37;SalesLine@1001 : Record 37);
    VAR
      ItemLedgEntry@1002 : Record 32;
      DimensionMgt@1003 : Codeunit 408;
      DimSetID@1004 : ARRAY [10] OF Integer;
    BEGIN
      DimSetID[1] := SalesLine."Dimension Set ID";
      WITH SalesLineToPost DO BEGIN
        IF "Appl.-to Item Entry" <> 0 THEN BEGIN
          ItemLedgEntry.GET("Appl.-to Item Entry");
          DimSetID[2] := ItemLedgEntry."Dimension Set ID";
        END;
        "Dimension Set ID" :=
          DimensionMgt.GetCombinedDimensionSetID(DimSetID,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
      END;
    END;

    LOCAL PROCEDURE CalcDeferralAmounts@64(SalesHeader@1000 : Record 36;SalesLine@1003 : Record 37;OriginalDeferralAmount@1002 : Decimal);
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
      IF SalesHeader."Posting Date" = 0D THEN
        UseDate := WORKDATE
      ELSE
        UseDate := SalesHeader."Posting Date";

      IF DeferralHeader.GET(
           DeferralUtilities.GetSalesDeferralDocType,'','',SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.")
      THEN BEGIN
        TempDeferralHeader := DeferralHeader;
        IF SalesLine.Quantity <> SalesLine."Qty. to Invoice" THEN
          TempDeferralHeader."Amount to Defer" :=
            ROUND(TempDeferralHeader."Amount to Defer" *
              SalesLine.GetDeferralAmount / OriginalDeferralAmount,Currency."Amount Rounding Precision");
        TempDeferralHeader."Amount to Defer (LCY)" :=
          ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              UseDate,SalesHeader."Currency Code",
              TempDeferralHeader."Amount to Defer",SalesHeader."Currency Factor"));
        TempDeferralHeader.INSERT;

        WITH DeferralLine DO BEGIN
          DeferralUtilities.FilterDeferralLines(
            DeferralLine,DeferralHeader."Deferral Doc. Type",
            DeferralHeader."Gen. Jnl. Template Name",DeferralHeader."Gen. Jnl. Batch Name",
            DeferralHeader."Document Type",DeferralHeader."Document No.",DeferralHeader."Line No.");
          IF FINDSET THEN BEGIN
            TotalDeferralCount := COUNT;
            REPEAT
              DeferralCount := DeferralCount + 1;
              TempDeferralLine.INIT;
              TempDeferralLine := DeferralLine;

              IF DeferralCount = TotalDeferralCount THEN BEGIN
                TempDeferralLine.Amount := TempDeferralHeader."Amount to Defer" - TotalAmount;
                TempDeferralLine."Amount (LCY)" := TempDeferralHeader."Amount to Defer (LCY)" - TotalAmountLCY;
              END ELSE BEGIN
                IF SalesLine.Quantity <> SalesLine."Qty. to Invoice" THEN
                  TempDeferralLine.Amount :=
                    ROUND(TempDeferralLine.Amount *
                      SalesLine.GetDeferralAmount / OriginalDeferralAmount,Currency."Amount Rounding Precision");

                TempDeferralLine."Amount (LCY)" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate,SalesHeader."Currency Code",
                      TempDeferralLine.Amount,SalesHeader."Currency Factor"));
                TotalAmount := TotalAmount + TempDeferralLine.Amount;
                TotalAmountLCY := TotalAmountLCY + TempDeferralLine."Amount (LCY)";
              END;
              TempDeferralLine.INSERT;
            UNTIL NEXT = 0;
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE CreatePostedDeferralScheduleFromSalesDoc@65(SalesLine@1008 : Record 37;NewDocumentType@1007 : Integer;NewDocumentNo@1003 : Code[20];NewLineNo@1002 : Integer;PostingDate@1000 : Date);
    VAR
      PostedDeferralHeader@1006 : Record 1704;
      PostedDeferralLine@1005 : Record 1705;
      DeferralTemplate@1004 : Record 1700;
      DeferralAccount@1001 : Code[20];
    BEGIN
      IF SalesLine."Deferral Code" = '' THEN
        EXIT;

      IF DeferralTemplate.GET(SalesLine."Deferral Code") THEN
        DeferralAccount := DeferralTemplate."Deferral Account";

      IF TempDeferralHeader.GET(
           DeferralUtilities.GetSalesDeferralDocType,'','',SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.")
      THEN BEGIN
        PostedDeferralHeader.InitFromDeferralHeader(TempDeferralHeader,'','',
          NewDocumentType,NewDocumentNo,NewLineNo,DeferralAccount,SalesLine."Sell-to Customer No.",PostingDate);
        DeferralUtilities.FilterDeferralLines(
          TempDeferralLine,DeferralUtilities.GetSalesDeferralDocType,'','',
          SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
        IF TempDeferralLine.FINDSET THEN
          REPEAT
            PostedDeferralLine.InitFromDeferralLine(
              TempDeferralLine,'','',NewDocumentType,NewDocumentNo,NewLineNo,DeferralAccount);
          UNTIL TempDeferralLine.NEXT = 0;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnSendSalesDocument@70(ShipAndInvoice@1000 : Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE GetAmountRoundingPrecisionInLCY@122(DocType@1002 : Option;DocNo@1003 : Code[20];CurrencyCode@1000 : Code[10]) AmountRoundingPrecision : Decimal;
    VAR
      SalesHeader@1001 : Record 36;
    BEGIN
      IF CurrencyCode = '' THEN
        EXIT(GLSetup."Amount Rounding Precision");
      SalesHeader.GET(DocType,DocNo);
      AmountRoundingPrecision := Currency."Amount Rounding Precision" / SalesHeader."Currency Factor";
      IF AmountRoundingPrecision < GLSetup."Amount Rounding Precision" THEN
        EXIT(GLSetup."Amount Rounding Precision");
      EXIT(AmountRoundingPrecision);
    END;

    LOCAL PROCEDURE UpdateEmailParameters@197(SalesHeader@1000 : Record 36);
    VAR
      FindEmailParameter@1001 : Record 9510;
      RenameEmailParameter@1003 : Record 9510;
    BEGIN
      IF SalesHeader."Last Posting No." = '' THEN
        EXIT;
      FindEmailParameter.SETRANGE("Document No",SalesHeader."No.");
      FindEmailParameter.SETRANGE("Document Type",SalesHeader."Document Type");
      IF FindEmailParameter.FINDSET THEN
        REPEAT
          RenameEmailParameter.COPY(FindEmailParameter);
          RenameEmailParameter.RENAME(
            SalesHeader."Last Posting No.",FindEmailParameter."Document Type",FindEmailParameter."Parameter Type");
        UNTIL FindEmailParameter.NEXT = 0;
    END;

    LOCAL PROCEDURE ArchivePurchaseOrders@200(VAR TempDropShptPostBuffer@1000 : TEMPORARY Record 223);
    VAR
      PurchOrderHeader@1002 : Record 38;
      PurchOrderLine@1001 : Record 39;
    BEGIN
      IF TempDropShptPostBuffer.FINDSET THEN BEGIN
        REPEAT
          PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order,TempDropShptPostBuffer."Order No.");
          TempDropShptPostBuffer.SETRANGE("Order No.",TempDropShptPostBuffer."Order No.");
          REPEAT
            PurchOrderLine.GET(
              PurchOrderLine."Document Type"::Order,
              TempDropShptPostBuffer."Order No.",TempDropShptPostBuffer."Order Line No.");
            PurchOrderLine."Qty. to Receive" := TempDropShptPostBuffer.Quantity;
            PurchOrderLine."Qty. to Receive (Base)" := TempDropShptPostBuffer."Quantity (Base)";
            PurchOrderLine.MODIFY;
          UNTIL TempDropShptPostBuffer.NEXT = 0;
          PurchPost.ArchiveUnpostedOrder(PurchOrderHeader);
          TempDropShptPostBuffer.SETRANGE("Order No.");
        UNTIL TempDropShptPostBuffer.NEXT = 0;
      END;
    END;

    BEGIN
    END.
  }
}

