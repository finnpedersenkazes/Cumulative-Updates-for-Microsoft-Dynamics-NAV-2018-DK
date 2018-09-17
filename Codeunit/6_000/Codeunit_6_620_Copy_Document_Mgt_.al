OBJECT Codeunit 6620 Copy Document Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1034 : TextConst 'DAN=Indtast et bilagsnr.;ENU=Please enter a Document No.';
      Text001@1033 : TextConst 'DAN=%1 %2 kan ikke kopieres til sig selv.;ENU=%1 %2 cannot be copied onto itself.';
      DeleteLinesQst@1032 : TextConst '@@@="%1=Document type, e.g. Invoice. %2=Document No., e.g. 001";DAN=De eksisterende linjer for %1 %2 vil blive slettet.\\Vil du forts�tte?;ENU=The existing lines for %1 %2 will be deleted.\\Do you want to continue?';
      Text004@1030 : TextConst 'DAN=De linjer, som indeholder en finanskonto, hvorp� direkte bogf�ring ikke er tilladt, er ikke blevet kopieret til det nye dokument ved hj�lp af k�rslen Kopi�r dokument.;ENU=The document line(s) with a G/L account where direct posting is not allowed have not been copied to the new document by the Copy Document batch job.';
      Text006@1028 : TextConst 'DAN=BEM�RK! Der blev givet en kontantrabat af %1 %2.;ENU=NOTE: A Payment Discount was Granted by %1 %2.';
      Text007@1027 : TextConst 'DAN=Tilbud,Rammeordre,Ordre,Faktura,Kreditnota,Bogf. salgslev.,Bogf. faktura,Bogf. kreditnota,Bogf. returvaremodt.;ENU=Quote,Blanket Order,Order,Invoice,Credit Memo,Posted Shipment,Posted Invoice,Posted Credit Memo,Posted Return Receipt';
      Currency@1024 : Record 4;
      Item@1023 : Record 27;
      AsmHeader@1049 : Record 900;
      PostedAsmHeader@1051 : Record 910;
      TempAsmHeader@1052 : TEMPORARY Record 900;
      TempAsmLine@1053 : TEMPORARY Record 901;
      TempSalesInvLine@1056 : TEMPORARY Record 113;
      SalespersonPurchaser@1972 : Record 13;
      LanguageManagement@1031 : Codeunit 43;
      CustCheckCreditLimit@1006 : Codeunit 312;
      ItemCheckAvail@1005 : Codeunit 311;
      TransferExtendedText@1015 : Codeunit 378;
      TransferOldExtLines@1004 : Codeunit 379;
      ItemTrackingDocMgt@1060 : Codeunit 6503;
      DeferralUtilities@1063 : Codeunit 1720;
      Window@1043 : Dialog;
      WindowUpdateDateTime@1044 : DateTime;
      InsertCancellationLine@1066 : Boolean;
      SalesDocType@1002 : 'Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Shipment,Posted Invoice,Posted Return Receipt,Posted Credit Memo';
      PurchDocType@1003 : 'Quote,Blanket Order,Order,Invoice,Return Order,Credit Memo,Posted Receipt,Posted Invoice,Posted Return Shipment,Posted Credit Memo';
      ServDocType@1016 : 'Quote,Contract';
      QtyToAsmToOrder@1055 : Decimal;
      QtyToAsmToOrderBase@1057 : Decimal;
      IncludeHeader@1001 : Boolean;
      RecalculateLines@1000 : Boolean;
      MoveNegLines@1009 : Boolean;
      Text008@1010 : TextConst 'DAN=Der er ingen negative salgslinjer at flytte.;ENU=There are no negative sales lines to move.';
      Text009@1007 : TextConst 'DAN=BEM�RK!: Der blev modtaget en kontantrabat fra %1 %2.;ENU=NOTE: A Payment Discount was Received by %1 %2.';
      Text010@1008 : TextConst 'DAN=Der er ingen negative k�bslinjer at flytte.;ENU=There are no negative purchase lines to move.';
      CreateToHeader@1011 : Boolean;
      Text011@1012 : TextConst 'DAN=Angiv et kreditornr.;ENU=Please enter a Vendor No.';
      HideDialog@1013 : Boolean;
      Text012@1014 : TextConst 'DAN=Der er ingen salgslinjer at kopiere.;ENU=There are no sales lines to copy.';
      Text013@1018 : TextConst 'DAN=Leverancenr.,Fakturanr.,Returvarekvitteringsnr.,Kreditnotanr.;ENU=Shipment No.,Invoice No.,Return Receipt No.,Credit Memo No.';
      Text014@1022 : TextConst 'DAN=Kvitteringsnr.,Fakturanr.,Returvareleverancenr.,Kreditnotanr.;ENU=Receipt No.,Invoice No.,Return Shipment No.,Credit Memo No.';
      Text015@1019 : TextConst 'DAN=%1 %2:;ENU=%1 %2:';
      Text016@1026 : TextConst 'DAN="Fak.nr.,Lev.nr.,Kr.notanr.,Returv.kvit.nr. ";ENU="Inv. No. ,Shpt. No. ,Cr. Memo No. ,Rtrn. Rcpt. No. "';
      Text017@1035 : TextConst 'DAN="Fak.nr.,Kvit.nr.,Kr.notanr.,Returv.kvit.nr. ";ENU="Inv. No. ,Rcpt. No. ,Cr. Memo No. ,Rtrn. Shpt. No. "';
      Text018@1029 : TextConst 'DAN=%1 - %2:;ENU=%1 - %2:';
      Text019@1037 : TextConst 'DAN=Der er ikke oprettet en obligatorisk k�de til bel�bstilbagef�rsel for alle kopierede dokumentlinjer.;ENU=Exact Cost Reversing Link has not been created for all copied document lines.';
      Text020@1036 : TextConst 'DAN=\;ENU=\';
      Text022@1039 : TextConst 'DAN=Kopierer dokumentlinjer...\;ENU=Copying document lines...\';
      Text023@1041 : TextConst 'DAN=Behandler kildelinjer      #1######\;ENU=Processing source lines      #1######\';
      Text024@1040 : TextConst 'DAN=Opretter nye linjer        #2######;ENU=Creating new lines           #2######';
      ExactCostRevMandatory@1042 : Boolean;
      ApplyFully@1017 : Boolean;
      AskApply@1020 : Boolean;
      ReappDone@1021 : Boolean;
      Text025@1046 : TextConst 'DAN=Du har valgt at returnere den originale m�ngde, der allerede er udlignet for en eller flere returdokumentlinjer. N�r du bogf�rer returdokumentet, vil programmet derfor genudligne relevante poster. V�r opm�rksom p�, at dette kan �ndre prisen p� eksisterende poster. Hvis du vil undg� dette, skal du slette de p�g�ldende returdokumentlinjer, f�r bogf�ring udf�res.;ENU=For one or more return document lines, you chose to return the original quantity, which is already fully applied. Therefore, when you post the return document, the program will reapply relevant entries. Beware that this may change the cost of existing entries. To avoid this, you must delete the affected return document lines before posting.';
      SkippedLine@1047 : Boolean;
      Text029@1048 : TextConst 'DAN=En eller flere returdokumentlinjer blev ikke indsat, eller de indeholder kun restm�ngden fra den originale dokumentlinje. Dette sker, fordi m�ngder p� den bogf�rte dokumentlinje allerede er helt eller delvist udlignet. Hvis du vil omvende hele m�ngden, skal du v�lge Returner originale m�ngde, f�r de bogf�rte dokumentlinjer hentes.;ENU=One or more return document lines were not inserted or they contain only the remaining quantity of the original document line. This is because quantities on the posted document line are already fully or partially applied. If you want to reverse the full quantity, you must select Return Original Quantity before getting the posted document lines.';
      Text030@1025 : TextConst 'DAN=En eller flere returdokumentlinjer blev ikke kopieret. Det skyldes, at antallene i den bogf�rte bilagslinje allerede er anvendt helt eller delvist, s� linket Pr�cis kostprisudligning kan ikke oprettes.;ENU=One or more return document lines were not copied. This is because quantities on the posted document line are already fully or partially applied, so the Exact Cost Reversing link could not be created.';
      Text031@1038 : TextConst 'DAN=Returdokumentlinje indeholder kun den originale dokumentlinjem�ngde, der ikke allerede er udlignet manuelt.;ENU=Return document line contains only the original document line quantity, that is not already manually applied.';
      SomeAreFixed@1045 : Boolean;
      AsmHdrExistsForFromDocLine@1050 : Boolean;
      Text032@1054 : TextConst 'DAN=Den bogf�rte salgsfaktura %1 d�kker mere end en leverance af tilknyttede montageordrer, som kan have forskellige montagekomponenter. V�lg Bogf�rt leverance som dokumenttype, og v�lg derefter en specifik leverance af samlede varer.;ENU=The posted sales invoice %1 covers more than one shipment of linked assembly orders that potentially have different assembly components. Select Posted Shipment as document type, and then select a specific shipment of assembled items.';
      SkipCopyFromDescription@1058 : Boolean;
      SkipTestCreditLimit@1059 : Boolean;
      WarningDone@1061 : Boolean;
      LinesApplied@1062 : Boolean;
      DiffPostDateOrderQst@1065 : TextConst 'DAN=Bogf�ringsdatoen for det kopierede dokument er forskellig fra bogf�ringsdatoen for originaldokumentet. Originaldokumentet har allerede et bogf�ringsnr. baseret p� en nummerserie med dator�kkef�lge. N�r du bogf�rer det kopierede dokument, kan du f� den forkerte dator�kkef�lge i de bogf�rte dokumenter.\Vil du forts�tte?;ENU=The Posting Date of the copied document is different from the Posting Date of the original document. The original document already has a Posting No. based on a number series with date order. When you post the copied document, you may have the wrong date order in the posted documents.\Do you want to continue?';
      CopyPostedDeferral@1064 : Boolean;
      CrMemoCancellationMsg@1067 : TextConst '@@@="%1 = Document No.";DAN=Annullering af kreditnota %1.;ENU=Cancellation of credit memo %1.';
      CopyExtText@1068 : Boolean;
      CopyJobData@1069 : Boolean;

    [External]
    PROCEDURE SetProperties@2(NewIncludeHeader@1001 : Boolean;NewRecalculateLines@1000 : Boolean;NewMoveNegLines@1006 : Boolean;NewCreateToHeader@1002 : Boolean;NewHideDialog@1003 : Boolean;NewExactCostRevMandatory@1004 : Boolean;NewApplyFully@1005 : Boolean);
    BEGIN
      IncludeHeader := NewIncludeHeader;
      RecalculateLines := NewRecalculateLines;
      MoveNegLines := NewMoveNegLines;
      CreateToHeader := NewCreateToHeader;
      HideDialog := NewHideDialog;
      ExactCostRevMandatory := NewExactCostRevMandatory;
      ApplyFully := NewApplyFully;
      AskApply := FALSE;
      ReappDone := FALSE;
      SkippedLine := FALSE;
      SomeAreFixed := FALSE;
      SkipCopyFromDescription := FALSE;
      SkipTestCreditLimit := FALSE;
    END;

    [External]
    PROCEDURE SetPropertiesForCreditMemoCorrection@99();
    BEGIN
      SetProperties(TRUE,FALSE,FALSE,FALSE,TRUE,TRUE,FALSE);
    END;

    [External]
    PROCEDURE SetPropertiesForInvoiceCorrection@60(NewSkipCopyFromDescription@1000 : Boolean);
    BEGIN
      SetProperties(TRUE,FALSE,FALSE,FALSE,TRUE,FALSE,FALSE);
      SkipTestCreditLimit := TRUE;
      SkipCopyFromDescription := NewSkipCopyFromDescription;
    END;

    [External]
    PROCEDURE SalesHeaderDocType@1(DocType@1001 : Option) : Integer;
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      CASE DocType OF
        SalesDocType::Quote:
          EXIT(SalesHeader."Document Type"::Quote);
        SalesDocType::"Blanket Order":
          EXIT(SalesHeader."Document Type"::"Blanket Order");
        SalesDocType::Order:
          EXIT(SalesHeader."Document Type"::Order);
        SalesDocType::Invoice:
          EXIT(SalesHeader."Document Type"::Invoice);
        SalesDocType::"Return Order":
          EXIT(SalesHeader."Document Type"::"Return Order");
        SalesDocType::"Credit Memo":
          EXIT(SalesHeader."Document Type"::"Credit Memo");
      END;
    END;

    [External]
    PROCEDURE PurchHeaderDocType@19(DocType@1001 : Option) : Integer;
    VAR
      FromPurchHeader@1000 : Record 38;
    BEGIN
      CASE DocType OF
        PurchDocType::Quote:
          EXIT(FromPurchHeader."Document Type"::Quote);
        PurchDocType::"Blanket Order":
          EXIT(FromPurchHeader."Document Type"::"Blanket Order");
        PurchDocType::Order:
          EXIT(FromPurchHeader."Document Type"::Order);
        PurchDocType::Invoice:
          EXIT(FromPurchHeader."Document Type"::Invoice);
        PurchDocType::"Return Order":
          EXIT(FromPurchHeader."Document Type"::"Return Order");
        PurchDocType::"Credit Memo":
          EXIT(FromPurchHeader."Document Type"::"Credit Memo");
      END;
    END;

    [External]
    PROCEDURE CopySalesDocForInvoiceCancelling@98(FromDocNo@1000 : Code[20];VAR ToSalesHeader@1001 : Record 36);
    BEGIN
      CopyJobData := TRUE;
      CopySalesDoc(SalesDocType::"Posted Invoice",FromDocNo,ToSalesHeader);
    END;

    [External]
    PROCEDURE CopySalesDocForCrMemoCancelling@71(FromDocNo@1000 : Code[20];VAR ToSalesHeader@1001 : Record 36);
    BEGIN
      InsertCancellationLine := TRUE;
      CopySalesDoc(SalesDocType::"Posted Credit Memo",FromDocNo,ToSalesHeader);
      InsertCancellationLine := FALSE;
    END;

    [External]
    PROCEDURE CopySalesDoc@16(FromDocType@1007 : Option;FromDocNo@1006 : Code[20];VAR ToSalesHeader@1008 : Record 36);
    VAR
      PaymentTerms@1009 : Record 3;
      ToSalesLine@1025 : Record 37;
      OldSalesHeader@1024 : Record 36;
      FromSalesHeader@1023 : Record 36;
      FromSalesLine@1022 : Record 37;
      FromSalesShptHeader@1021 : Record 110;
      FromSalesShptLine@1020 : Record 111;
      FromSalesInvHeader@1019 : Record 112;
      FromSalesInvLine@1018 : Record 113;
      FromReturnRcptHeader@1017 : Record 6660;
      FromReturnRcptLine@1016 : Record 6661;
      FromSalesCrMemoHeader@1015 : Record 114;
      FromSalesCrMemoLine@1014 : Record 115;
      GLSetUp@1010 : Record 98;
      ReleaseSalesDocument@1001 : Codeunit 414;
      NextLineNo@1003 : Integer;
      ItemChargeAssgntNextLineNo@1002 : Integer;
      LinesNotCopied@1000 : Integer;
      MissingExCostRevLink@1012 : Boolean;
      ReleaseDocument@1005 : Boolean;
    BEGIN
      WITH ToSalesHeader DO BEGIN
        IF NOT CreateToHeader THEN BEGIN
          TESTFIELD(Status,Status::Open);
          IF FromDocNo = '' THEN
            ERROR(Text000);
          FIND;
        END;

        OnBeforeCopySalesDocument(FromDocType,FromDocNo,ToSalesHeader);

        TransferOldExtLines.ClearLineNumbers;

        IF NOT InitAndCheckSalesDocuments(
             FromDocType,FromDocNo,FromSalesHeader,ToSalesHeader,
             FromSalesShptHeader,FromSalesInvHeader,FromReturnRcptHeader,FromSalesCrMemoHeader)
        THEN
          EXIT;

        ToSalesLine.LOCKTABLE;

        ToSalesLine.SETRANGE("Document Type","Document Type");
        IF CreateToHeader THEN BEGIN
          INSERT(TRUE);
          ToSalesLine.SETRANGE("Document No.","No.");
        END ELSE BEGIN
          ToSalesLine.SETRANGE("Document No.","No.");
          IF IncludeHeader THEN
            IF NOT ToSalesLine.ISEMPTY THEN BEGIN
              COMMIT;
              IF NOT CONFIRM(DeleteLinesQst,TRUE,"Document Type","No.") THEN
                EXIT;
              ToSalesLine.DELETEALL(TRUE);
            END;
        END;

        IF ToSalesLine.FINDLAST THEN
          NextLineNo := ToSalesLine."Line No."
        ELSE
          NextLineNo := 0;

        IF IncludeHeader THEN BEGIN
          CheckCustomer(FromSalesHeader,ToSalesHeader);
          OldSalesHeader := ToSalesHeader;
          CASE FromDocType OF
            SalesDocType::Quote,
            SalesDocType::"Blanket Order",
            SalesDocType::Order,
            SalesDocType::Invoice,
            SalesDocType::"Return Order",
            SalesDocType::"Credit Memo":
              BEGIN
                FromSalesHeader.CALCFIELDS("Work Description");
                TRANSFERFIELDS(FromSalesHeader,FALSE);
                UpdateSalesHeaderWhenCopyFromSalesHeader(ToSalesHeader,OldSalesHeader,FromDocType);
              END;
            SalesDocType::"Posted Shipment":
              BEGIN
                VALIDATE("Sell-to Customer No.",FromSalesShptHeader."Sell-to Customer No.");
                TRANSFERFIELDS(FromSalesShptHeader,FALSE);
              END;
            SalesDocType::"Posted Invoice":
              BEGIN
                FromSalesInvHeader.CALCFIELDS("Work Description");
                VALIDATE("Sell-to Customer No.",FromSalesInvHeader."Sell-to Customer No.");
                TRANSFERFIELDS(FromSalesInvHeader,FALSE);
              END;
            SalesDocType::"Posted Return Receipt":
              BEGIN
                VALIDATE("Sell-to Customer No.",FromReturnRcptHeader."Sell-to Customer No.");
                TRANSFERFIELDS(FromReturnRcptHeader,FALSE);
              END;
            SalesDocType::"Posted Credit Memo":
              TransferFieldsFromCrMemoToInv(ToSalesHeader,FromSalesCrMemoHeader);
          END;
          Invoice := FALSE;
          Ship := FALSE;
          IF Status = Status::Released THEN BEGIN
            Status := Status::Open;
            ReleaseDocument := TRUE;
          END;
          IF MoveNegLines OR IncludeHeader THEN
            VALIDATE("Location Code");
          CopyShiptoCodeFromInvToCrMemo(ToSalesHeader,FromSalesInvHeader,FromDocType);

          CopyFieldsFromOldSalesHeader(ToSalesHeader,OldSalesHeader);
          IF RecalculateLines THEN
            CreateDim(
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::Customer,"Bill-to Customer No.",
              DATABASE::"Salesperson/Purchaser","Salesperson Code",
              DATABASE::Campaign,"Campaign No.",
              DATABASE::"Customer Template","Bill-to Customer Template Code");
          "No. Printed" := 0;
          "Applies-to Doc. Type" := "Applies-to Doc. Type"::" ";
          "Applies-to Doc. No." := '';
          "Applies-to ID" := '';
          "Opportunity No." := '';
          "Quote No." := '';
          IF ((FromDocType = SalesDocType::"Posted Invoice") AND
              ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"])) OR
             ((FromDocType = SalesDocType::"Posted Credit Memo") AND
              NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]))
          THEN
            UpdateCustLedgEntry(ToSalesHeader,FromDocType,FromDocNo);

          IF "Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote] THEN
            "Posting Date" := 0D;

          Correction := FALSE;
          IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
            "Shipment Date" := 0D;
            GLSetUp.GET;
            Correction := GLSetUp."Mark Cr. Memos as Corrections";
            IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN
              PaymentTerms.GET("Payment Terms Code")
            ELSE
              CLEAR(PaymentTerms);
            IF NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
              "Payment Terms Code" := '';
              "Payment Discount %" := 0;
              "Pmt. Discount Date" := 0D;
            END;
          END;

          OnBeforeModifySalesHeader(ToSalesHeader,FromDocType,FromDocNo,IncludeHeader);

          IF CreateToHeader THEN BEGIN
            VALIDATE("Payment Terms Code");
            MODIFY(TRUE);
          END ELSE
            MODIFY;
          OnCopySalesDocWithHeader(FromDocType,FromDocNo,ToSalesHeader);
        END;

        LinesNotCopied := 0;
        CASE FromDocType OF
          SalesDocType::Quote,
          SalesDocType::"Blanket Order",
          SalesDocType::Order,
          SalesDocType::Invoice,
          SalesDocType::"Return Order",
          SalesDocType::"Credit Memo":
            BEGIN
              ItemChargeAssgntNextLineNo := 0;
              FromSalesLine.RESET;
              FromSalesLine.SETRANGE("Document Type",FromSalesHeader."Document Type");
              FromSalesLine.SETRANGE("Document No.",FromSalesHeader."No.");
              IF MoveNegLines THEN
                FromSalesLine.SETFILTER(Quantity,'<=0');
              IF FromSalesLine.FIND('-') THEN
                REPEAT
                  IF NOT ExtTxtAttachedToPosSalesLine(FromSalesHeader,MoveNegLines,FromSalesLine."Attached to Line No.") THEN BEGIN
                    InitAsmCopyHandling(TRUE);
                    ToSalesLine."Document Type" := "Document Type";
                    AsmHdrExistsForFromDocLine := FromSalesLine.AsmToOrderExists(AsmHeader);
                    IF AsmHdrExistsForFromDocLine THEN BEGIN
                      CASE ToSalesLine."Document Type" OF
                        ToSalesLine."Document Type"::Order:
                          BEGIN
                            QtyToAsmToOrder := FromSalesLine."Qty. to Assemble to Order";
                            QtyToAsmToOrderBase := FromSalesLine."Qty. to Asm. to Order (Base)";
                          END;
                        ToSalesLine."Document Type"::Quote,
                        ToSalesLine."Document Type"::"Blanket Order":
                          BEGIN
                            QtyToAsmToOrder := FromSalesLine.Quantity;
                            QtyToAsmToOrderBase := FromSalesLine."Quantity (Base)";
                          END;
                      END;
                      GenerateAsmDataFromNonPosted(AsmHeader);
                    END;
                    IF CopySalesLine(ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLine,
                         NextLineNo,LinesNotCopied,FALSE,DeferralTypeForSalesDoc(FromDocType),CopyPostedDeferral,
                         FromSalesLine."Line No.")
                    THEN BEGIN
                      IF FromSalesLine.Type = FromSalesLine.Type::"Charge (Item)" THEN
                        CopyFromSalesDocAssgntToLine(ToSalesLine,FromSalesLine,ItemChargeAssgntNextLineNo);
                    END;
                  END;
                UNTIL FromSalesLine.NEXT = 0;
            END;
          SalesDocType::"Posted Shipment":
            BEGIN
              FromSalesHeader.TRANSFERFIELDS(FromSalesShptHeader);
              FromSalesShptLine.RESET;
              FromSalesShptLine.SETRANGE("Document No.",FromSalesShptHeader."No.");
              IF MoveNegLines THEN
                FromSalesShptLine.SETFILTER(Quantity,'<=0');
              CopySalesShptLinesToDoc(ToSalesHeader,FromSalesShptLine,LinesNotCopied,MissingExCostRevLink);
            END;
          SalesDocType::"Posted Invoice":
            BEGIN
              FromSalesHeader.TRANSFERFIELDS(FromSalesInvHeader);
              FromSalesInvLine.RESET;
              FromSalesInvLine.SETRANGE("Document No.",FromSalesInvHeader."No.");
              IF MoveNegLines THEN
                FromSalesInvLine.SETFILTER(Quantity,'<=0');
              CopySalesInvLinesToDoc(ToSalesHeader,FromSalesInvLine,LinesNotCopied,MissingExCostRevLink);
            END;
          SalesDocType::"Posted Return Receipt":
            BEGIN
              FromSalesHeader.TRANSFERFIELDS(FromReturnRcptHeader);
              FromReturnRcptLine.RESET;
              FromReturnRcptLine.SETRANGE("Document No.",FromReturnRcptHeader."No.");
              IF MoveNegLines THEN
                FromReturnRcptLine.SETFILTER(Quantity,'<=0');
              CopySalesReturnRcptLinesToDoc(ToSalesHeader,FromReturnRcptLine,LinesNotCopied,MissingExCostRevLink);
            END;
          SalesDocType::"Posted Credit Memo":
            BEGIN
              FromSalesHeader.TRANSFERFIELDS(FromSalesCrMemoHeader);
              FromSalesCrMemoLine.RESET;
              FromSalesCrMemoLine.SETRANGE("Document No.",FromSalesCrMemoHeader."No.");
              IF MoveNegLines THEN
                FromSalesCrMemoLine.SETFILTER(Quantity,'<=0');
              CopySalesCrMemoLinesToDoc(ToSalesHeader,FromSalesCrMemoLine,LinesNotCopied,MissingExCostRevLink);
            END;
        END;
      END;

      IF MoveNegLines THEN BEGIN
        DeleteSalesLinesWithNegQty(FromSalesHeader,FALSE);
        LinkJobPlanningLine(ToSalesHeader);
      END;

      IF ReleaseDocument THEN BEGIN
        ToSalesHeader.Status := ToSalesHeader.Status::Released;
        ReleaseSalesDocument.Reopen(ToSalesHeader);
      END ELSE
        IF (FromDocType IN
            [SalesDocType::Quote,
             SalesDocType::"Blanket Order",
             SalesDocType::Order,
             SalesDocType::Invoice,
             SalesDocType::"Return Order",
             SalesDocType::"Credit Memo"])
           AND NOT IncludeHeader AND NOT RecalculateLines
        THEN
          IF FromSalesHeader.Status = FromSalesHeader.Status::Released THEN BEGIN
            ReleaseSalesDocument.RUN(ToSalesHeader);
            ReleaseSalesDocument.Reopen(ToSalesHeader);
          END;
      CASE TRUE OF
        MissingExCostRevLink AND (LinesNotCopied <> 0):
          MESSAGE(Text019 + Text020 + Text004);
        MissingExCostRevLink:
          MESSAGE(Text019);
        LinesNotCopied <> 0:
          MESSAGE(Text004);
      END;

      OnAfterCopySalesDocument(FromDocType,FromDocNo,ToSalesHeader);
    END;

    LOCAL PROCEDURE CheckCustomer@146(VAR FromSalesHeader@1000 : Record 36;VAR ToSalesHeader@1002 : Record 36);
    VAR
      Cust@1001 : Record 18;
    BEGIN
      IF Cust.GET(FromSalesHeader."Sell-to Customer No.") THEN
        Cust.CheckBlockedCustOnDocs(Cust,ToSalesHeader."Document Type",FALSE,FALSE);
      IF Cust.GET(FromSalesHeader."Bill-to Customer No.") THEN
        Cust.CheckBlockedCustOnDocs(Cust,ToSalesHeader."Document Type",FALSE,FALSE);
    END;

    [External]
    PROCEDURE CopyPurchaseDocForInvoiceCancelling@104(FromDocNo@1000 : Code[20];VAR ToPurchaseHeader@1001 : Record 38);
    BEGIN
      CopyPurchDoc(PurchDocType::"Posted Invoice",FromDocNo,ToPurchaseHeader);
    END;

    [External]
    PROCEDURE CopyPurchDocForCrMemoCancelling@136(FromDocNo@1001 : Code[20];VAR ToPurchaseHeader@1000 : Record 38);
    BEGIN
      InsertCancellationLine := TRUE;
      CopyPurchDoc(SalesDocType::"Posted Credit Memo",FromDocNo,ToPurchaseHeader);
      InsertCancellationLine := FALSE;
    END;

    [External]
    PROCEDURE CopyPurchDoc@22(FromDocType@1005 : Option;FromDocNo@1004 : Code[20];VAR ToPurchHeader@1017 : Record 38);
    VAR
      PaymentTerms@1022 : Record 3;
      ToPurchLine@1015 : Record 39;
      OldPurchHeader@1014 : Record 38;
      FromPurchHeader@1013 : Record 38;
      FromPurchLine@1012 : Record 39;
      FromPurchRcptHeader@1011 : Record 120;
      FromPurchRcptLine@1010 : Record 121;
      FromPurchInvHeader@1009 : Record 122;
      FromPurchInvLine@1008 : Record 123;
      FromReturnShptHeader@1002 : Record 6650;
      FromReturnShptLine@1001 : Record 6651;
      FromPurchCrMemoHeader@1007 : Record 124;
      FromPurchCrMemoLine@1006 : Record 125;
      GLSetup@1023 : Record 98;
      Vend@1024 : Record 23;
      ReleasePurchaseDocument@1000 : Codeunit 415;
      NextLineNo@1020 : Integer;
      ItemChargeAssgntNextLineNo@1016 : Integer;
      LinesNotCopied@1018 : Integer;
      MissingExCostRevLink@1025 : Boolean;
      ReleaseDocument@1021 : Boolean;
    BEGIN
      WITH ToPurchHeader DO BEGIN
        IF NOT CreateToHeader THEN BEGIN
          TESTFIELD(Status,Status::Open);
          IF FromDocNo = '' THEN
            ERROR(Text000);
          FIND;
        END;

        OnBeforeCopyPurchaseDocument(FromDocType,FromDocNo,ToPurchHeader);

        TransferOldExtLines.ClearLineNumbers;

        IF NOT InitAndCheckPurchaseDocuments(
             FromDocType,FromDocNo,FromPurchHeader,ToPurchHeader,
             FromPurchRcptHeader,FromPurchInvHeader,FromReturnShptHeader,FromPurchCrMemoHeader)
        THEN
          EXIT;

        ToPurchLine.LOCKTABLE;

        IF CreateToHeader THEN BEGIN
          INSERT(TRUE);
          ToPurchLine.SETRANGE("Document Type","Document Type");
          ToPurchLine.SETRANGE("Document No.","No.");
        END ELSE BEGIN
          ToPurchLine.SETRANGE("Document Type","Document Type");
          ToPurchLine.SETRANGE("Document No.","No.");
          IF IncludeHeader THEN
            IF ToPurchLine.FINDFIRST THEN BEGIN
              COMMIT;
              IF NOT CONFIRM(DeleteLinesQst,TRUE,"Document Type","No.") THEN
                EXIT;
              ToPurchLine.DELETEALL(TRUE);
            END;
        END;

        IF ToPurchLine.FINDLAST THEN
          NextLineNo := ToPurchLine."Line No."
        ELSE
          NextLineNo := 0;

        IF IncludeHeader THEN BEGIN
          IF Vend.GET(FromPurchHeader."Buy-from Vendor No.") THEN
            Vend.CheckBlockedVendOnDocs(Vend,FALSE);
          IF Vend.GET(FromPurchHeader."Pay-to Vendor No.") THEN
            Vend.CheckBlockedVendOnDocs(Vend,FALSE);
          OldPurchHeader := ToPurchHeader;
          CASE FromDocType OF
            PurchDocType::Quote,
            PurchDocType::"Blanket Order",
            PurchDocType::Order,
            PurchDocType::Invoice,
            PurchDocType::"Return Order",
            PurchDocType::"Credit Memo":
              BEGIN
                TRANSFERFIELDS(FromPurchHeader,FALSE);
                UpdatePurchHeaderWhenCopyFromPurchHeader(ToPurchHeader,OldPurchHeader,FromDocType);
              END;
            PurchDocType::"Posted Receipt":
              BEGIN
                VALIDATE("Buy-from Vendor No.",FromPurchRcptHeader."Buy-from Vendor No.");
                TRANSFERFIELDS(FromPurchRcptHeader,FALSE);
              END;
            PurchDocType::"Posted Invoice":
              BEGIN
                VALIDATE("Buy-from Vendor No.",FromPurchInvHeader."Buy-from Vendor No.");
                TRANSFERFIELDS(FromPurchInvHeader,FALSE);
              END;
            PurchDocType::"Posted Return Shipment":
              BEGIN
                VALIDATE("Buy-from Vendor No.",FromReturnShptHeader."Buy-from Vendor No.");
                TRANSFERFIELDS(FromReturnShptHeader,FALSE);
              END;
            PurchDocType::"Posted Credit Memo":
              BEGIN
                VALIDATE("Buy-from Vendor No.",FromPurchCrMemoHeader."Buy-from Vendor No.");
                TRANSFERFIELDS(FromPurchCrMemoHeader,FALSE);
              END;
          END;
          Invoice := FALSE;
          Receive := FALSE;
          IF Status = Status::Released THEN BEGIN
            Status := Status::Open;
            ReleaseDocument := TRUE;
          END;
          IF MoveNegLines OR IncludeHeader THEN BEGIN
            VALIDATE("Location Code");
            CopyShippingInfoPurchOrder(ToPurchHeader,FromPurchHeader);
          END;
          IF MoveNegLines THEN
            VALIDATE("Order Address Code");

          CopyFieldsFromOldPurchHeader(ToPurchHeader,OldPurchHeader);
          IF RecalculateLines THEN
            CreateDim(
              DATABASE::Vendor,"Pay-to Vendor No.",
              DATABASE::"Salesperson/Purchaser","Purchaser Code",
              DATABASE::Campaign,"Campaign No.",
              DATABASE::"Responsibility Center","Responsibility Center");
          "No. Printed" := 0;
          "Applies-to Doc. Type" := "Applies-to Doc. Type"::" ";
          "Applies-to Doc. No." := '';
          "Applies-to ID" := '';
          "Quote No." := '';
          IF ((FromDocType = PurchDocType::"Posted Invoice") AND
              ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"])) OR
             ((FromDocType = PurchDocType::"Posted Credit Memo") AND
              NOT ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]))
          THEN
            UpdateVendLedgEntry(ToPurchHeader,FromDocType,FromDocNo);

          IF "Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote] THEN
            "Posting Date" := 0D;

          Correction := FALSE;
          IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
            "Expected Receipt Date" := 0D;
            GLSetup.GET;
            Correction := GLSetup."Mark Cr. Memos as Corrections";
            IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN
              PaymentTerms.GET("Payment Terms Code")
            ELSE
              CLEAR(PaymentTerms);
            IF NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
              "Payment Terms Code" := '';
              "Payment Discount %" := 0;
              "Pmt. Discount Date" := 0D;
            END;
          END;

          OnBeforeModifyPurchHeader(ToPurchHeader,FromDocType,FromDocNo,IncludeHeader);

          IF CreateToHeader THEN BEGIN
            VALIDATE("Payment Terms Code");
            MODIFY(TRUE);
          END ELSE
            MODIFY;
        END;

        LinesNotCopied := 0;
        CASE FromDocType OF
          PurchDocType::Quote,
          PurchDocType::"Blanket Order",
          PurchDocType::Order,
          PurchDocType::Invoice,
          PurchDocType::"Return Order",
          PurchDocType::"Credit Memo":
            BEGIN
              ItemChargeAssgntNextLineNo := 0;
              FromPurchLine.RESET;
              FromPurchLine.SETRANGE("Document Type",FromPurchHeader."Document Type");
              FromPurchLine.SETRANGE("Document No.",FromPurchHeader."No.");
              IF MoveNegLines THEN
                FromPurchLine.SETFILTER(Quantity,'<=0');
              IF FromPurchLine.FIND('-') THEN
                REPEAT
                  IF NOT ExtTxtAttachedToPosPurchLine(FromPurchHeader,MoveNegLines,FromPurchLine."Attached to Line No.") THEN
                    IF CopyPurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLine,
                         NextLineNo,LinesNotCopied,FALSE,DeferralTypeForPurchDoc(FromDocType),CopyPostedDeferral,
                         FromPurchLine."Line No.")
                    THEN BEGIN
                      IF FromPurchLine.Type = FromPurchLine.Type::"Charge (Item)" THEN
                        CopyFromPurchDocAssgntToLine(ToPurchLine,FromPurchLine,ItemChargeAssgntNextLineNo);
                    END;
                UNTIL FromPurchLine.NEXT = 0;
            END;
          PurchDocType::"Posted Receipt":
            BEGIN
              FromPurchHeader.TRANSFERFIELDS(FromPurchRcptHeader);
              FromPurchRcptLine.RESET;
              FromPurchRcptLine.SETRANGE("Document No.",FromPurchRcptHeader."No.");
              IF MoveNegLines THEN
                FromPurchRcptLine.SETFILTER(Quantity,'<=0');
              CopyPurchRcptLinesToDoc(ToPurchHeader,FromPurchRcptLine,LinesNotCopied,MissingExCostRevLink);
            END;
          PurchDocType::"Posted Invoice":
            BEGIN
              FromPurchHeader.TRANSFERFIELDS(FromPurchInvHeader);
              FromPurchInvLine.RESET;
              FromPurchInvLine.SETRANGE("Document No.",FromPurchInvHeader."No.");
              IF MoveNegLines THEN
                FromPurchInvLine.SETFILTER(Quantity,'<=0');
              CopyPurchInvLinesToDoc(ToPurchHeader,FromPurchInvLine,LinesNotCopied,MissingExCostRevLink);
            END;
          PurchDocType::"Posted Return Shipment":
            BEGIN
              FromPurchHeader.TRANSFERFIELDS(FromReturnShptHeader);
              FromReturnShptLine.RESET;
              FromReturnShptLine.SETRANGE("Document No.",FromReturnShptHeader."No.");
              IF MoveNegLines THEN
                FromReturnShptLine.SETFILTER(Quantity,'<=0');
              CopyPurchReturnShptLinesToDoc(ToPurchHeader,FromReturnShptLine,LinesNotCopied,MissingExCostRevLink);
            END;
          PurchDocType::"Posted Credit Memo":
            BEGIN
              FromPurchHeader.TRANSFERFIELDS(FromPurchCrMemoHeader);
              FromPurchCrMemoLine.RESET;
              FromPurchCrMemoLine.SETRANGE("Document No.",FromPurchCrMemoHeader."No.");
              IF MoveNegLines THEN
                FromPurchCrMemoLine.SETFILTER(Quantity,'<=0');
              CopyPurchCrMemoLinesToDoc(ToPurchHeader,FromPurchCrMemoLine,LinesNotCopied,MissingExCostRevLink);
            END;
        END;
      END;

      IF MoveNegLines THEN
        DeletePurchLinesWithNegQty(FromPurchHeader,FALSE);

      IF ReleaseDocument THEN BEGIN
        ToPurchHeader.Status := ToPurchHeader.Status::Released;
        ReleasePurchaseDocument.Reopen(ToPurchHeader);
      END ELSE
        IF (FromDocType IN
            [PurchDocType::Quote,
             PurchDocType::"Blanket Order",
             PurchDocType::Order,
             PurchDocType::Invoice,
             PurchDocType::"Return Order",
             PurchDocType::"Credit Memo"])
           AND NOT IncludeHeader AND NOT RecalculateLines
        THEN
          IF FromPurchHeader.Status = FromPurchHeader.Status::Released THEN BEGIN
            ReleasePurchaseDocument.RUN(ToPurchHeader);
            ReleasePurchaseDocument.Reopen(ToPurchHeader);
          END;

      CASE TRUE OF
        MissingExCostRevLink AND (LinesNotCopied <> 0):
          MESSAGE(Text019 + Text020 + Text004);
        MissingExCostRevLink:
          MESSAGE(Text019);
        LinesNotCopied <> 0:
          MESSAGE(Text004);
      END;

      OnAfterCopyPurchaseDocument(FromDocType,FromDocNo,ToPurchHeader);
    END;

    [External]
    PROCEDURE ShowSalesDoc@15(ToSalesHeader@1000 : Record 36);
    BEGIN
      WITH ToSalesHeader DO
        CASE "Document Type" OF
          "Document Type"::Order:
            PAGE.RUN(PAGE::"Sales Order",ToSalesHeader);
          "Document Type"::Invoice:
            PAGE.RUN(PAGE::"Sales Invoice",ToSalesHeader);
          "Document Type"::"Return Order":
            PAGE.RUN(PAGE::"Sales Return Order",ToSalesHeader);
          "Document Type"::"Credit Memo":
            PAGE.RUN(PAGE::"Sales Credit Memo",ToSalesHeader);
        END;
    END;

    [External]
    PROCEDURE ShowPurchDoc@24(ToPurchHeader@1000 : Record 38);
    BEGIN
      WITH ToPurchHeader DO
        CASE "Document Type" OF
          "Document Type"::Order:
            PAGE.RUN(PAGE::"Purchase Order",ToPurchHeader);
          "Document Type"::Invoice:
            PAGE.RUN(PAGE::"Purchase Invoice",ToPurchHeader);
          "Document Type"::"Return Order":
            PAGE.RUN(PAGE::"Purchase Return Order",ToPurchHeader);
          "Document Type"::"Credit Memo":
            PAGE.RUN(PAGE::"Purchase Credit Memo",ToPurchHeader);
        END;
    END;

    [External]
    PROCEDURE CopyFromSalesToPurchDoc@23(VendorNo@1004 : Code[20];FromSalesHeader@1000 : Record 36;VAR ToPurchHeader@1001 : Record 38);
    VAR
      FromSalesLine@1003 : Record 37;
      ToPurchLine@1002 : Record 39;
      NextLineNo@1005 : Integer;
    BEGIN
      IF VendorNo = '' THEN
        ERROR(Text011);

      WITH ToPurchLine DO BEGIN
        LOCKTABLE;
        ToPurchHeader.INSERT(TRUE);
        ToPurchHeader.VALIDATE("Buy-from Vendor No.",VendorNo);
        ToPurchHeader.MODIFY(TRUE);
        FromSalesLine.SETRANGE("Document Type",FromSalesHeader."Document Type");
        FromSalesLine.SETRANGE("Document No.",FromSalesHeader."No.");
        IF NOT FromSalesLine.FIND('-') THEN
          ERROR(Text012);
        REPEAT
          NextLineNo := NextLineNo + 10000;
          CLEAR(ToPurchLine);
          INIT;
          "Document Type" := ToPurchHeader."Document Type";
          "Document No." := ToPurchHeader."No.";
          "Line No." := NextLineNo;
          IF FromSalesLine.Type = FromSalesLine.Type::" " THEN
            Description := FromSalesLine.Description
          ELSE BEGIN
            TransfldsFromSalesToPurchLine(FromSalesLine,ToPurchLine);
            IF (Type = Type::Item) AND (Quantity <> 0) THEN
              CopyItemTrackingEntries(
                FromSalesLine,ToPurchLine,FromSalesHeader."Prices Including VAT",
                ToPurchHeader."Prices Including VAT");
          END;
          OnBeforeCopySalesToPurchDoc(ToPurchLine,FromSalesLine);
          INSERT(TRUE);
          OnAfterCopySalesToPurchDoc(ToPurchLine,FromSalesLine);
        UNTIL FromSalesLine.NEXT = 0;
      END;
    END;

    [Internal]
    PROCEDURE TransfldsFromSalesToPurchLine@3(VAR FromSalesLine@1000 : Record 37;VAR ToPurchLine@1001 : Record 39);
    BEGIN
      WITH ToPurchLine DO BEGIN
        VALIDATE(Type,FromSalesLine.Type);
        VALIDATE("No.",FromSalesLine."No.");
        VALIDATE("Variant Code",FromSalesLine."Variant Code");
        VALIDATE("Location Code",FromSalesLine."Location Code");
        VALIDATE("Unit of Measure Code",FromSalesLine."Unit of Measure Code");
        IF (Type = Type::Item) AND ("No." <> '') THEN
          UpdateUOMQtyPerStockQty;
        "Expected Receipt Date" := FromSalesLine."Shipment Date";
        "Bin Code" := FromSalesLine."Bin Code";
        IF (FromSalesLine."Document Type" = FromSalesLine."Document Type"::"Return Order") AND
           ("Document Type" = "Document Type"::"Return Order")
        THEN
          VALIDATE(Quantity,FromSalesLine.Quantity)
        ELSE
          VALIDATE(Quantity,FromSalesLine."Outstanding Quantity");
        VALIDATE("Return Reason Code",FromSalesLine."Return Reason Code");
        VALIDATE("Direct Unit Cost");
        Description := FromSalesLine.Description;
        "Description 2" := FromSalesLine."Description 2";
        OnAfterTransfldsFromSalesToPurchLine(FromSalesLine,ToPurchLine);
      END;
    END;

    LOCAL PROCEDURE DeleteSalesLinesWithNegQty@12(FromSalesHeader@1001 : Record 36;OnlyTest@1002 : Boolean);
    VAR
      FromSalesLine@1000 : Record 37;
    BEGIN
      WITH FromSalesLine DO BEGIN
        SETRANGE("Document Type",FromSalesHeader."Document Type");
        SETRANGE("Document No.",FromSalesHeader."No.");
        SETFILTER(Quantity,'<0');
        IF OnlyTest THEN BEGIN
          IF NOT FIND('-') THEN
            ERROR(Text008);
          REPEAT
            TESTFIELD("Shipment No.",'');
            TESTFIELD("Return Receipt No.",'');
            TESTFIELD("Quantity Shipped",0);
            TESTFIELD("Quantity Invoiced",0);
          UNTIL NEXT = 0;
        END ELSE
          DELETEALL(TRUE);
      END;
    END;

    LOCAL PROCEDURE DeletePurchLinesWithNegQty@30(FromPurchHeader@1001 : Record 38;OnlyTest@1002 : Boolean);
    VAR
      FromPurchLine@1000 : Record 39;
    BEGIN
      WITH FromPurchLine DO BEGIN
        SETRANGE("Document Type",FromPurchHeader."Document Type");
        SETRANGE("Document No.",FromPurchHeader."No.");
        SETFILTER(Quantity,'<0');
        IF OnlyTest THEN BEGIN
          IF NOT FIND('-') THEN
            ERROR(Text010);
          REPEAT
            TESTFIELD("Receipt No.",'');
            TESTFIELD("Return Shipment No.",'');
            TESTFIELD("Quantity Received",0);
            TESTFIELD("Quantity Invoiced",0);
          UNTIL NEXT = 0;
        END ELSE
          DELETEALL(TRUE);
      END;
    END;

    LOCAL PROCEDURE CopySalesLine@7(VAR ToSalesHeader@1004 : Record 36;VAR ToSalesLine@1001 : Record 37;VAR FromSalesHeader@1005 : Record 36;VAR FromSalesLine@1002 : Record 37;VAR NextLineNo@1003 : Integer;VAR LinesNotCopied@1006 : Integer;RecalculateAmount@1008 : Boolean;FromSalesDocType@1007 : Option;VAR CopyPostedDeferral@1014 : Boolean;DocLineNo@1011 : Integer) : Boolean;
    VAR
      ToSalesLine2@1009 : Record 37;
      RoundingLineInserted@1013 : Boolean;
      CopyThisLine@1000 : Boolean;
      InvDiscountAmount@1020 : Decimal;
    BEGIN
      CopyThisLine := TRUE;

      CheckSalesRounding(FromSalesLine,RoundingLineInserted);

      IF ((ToSalesHeader."Language Code" <> FromSalesHeader."Language Code") OR RecalculateLines) AND
         (FromSalesLine."Attached to Line No." <> 0) OR
         FromSalesLine."Prepayment Line" OR RoundingLineInserted
      THEN
        EXIT(FALSE);
      ToSalesLine.SetSalesHeader(ToSalesHeader);
      IF RecalculateLines AND NOT FromSalesLine."System-Created Entry" THEN BEGIN
        ToSalesLine.INIT;
        OnAfterInitToSalesLine(ToSalesLine);
      END ELSE BEGIN
        ToSalesLine := FromSalesLine;
        ToSalesLine."Returns Deferral Start Date" := 0D;
        IF ToSalesHeader."Document Type" IN [ToSalesHeader."Document Type"::Quote,ToSalesHeader."Document Type"::"Blanket Order"] THEN
          ToSalesLine."Deferral Code" := '';
        IF MoveNegLines AND (ToSalesLine.Type <> ToSalesLine.Type::" ") THEN BEGIN
          ToSalesLine.Amount := -ToSalesLine.Amount;
          ToSalesLine."Amount Including VAT" := -ToSalesLine."Amount Including VAT";
        END
      END;

      IF (NOT RecalculateLines) AND (ToSalesLine."No." <> '') THEN
        ToSalesLine.TESTFIELD("VAT Bus. Posting Group",ToSalesHeader."VAT Bus. Posting Group");

      NextLineNo := NextLineNo + 10000;
      ToSalesLine."Document Type" := ToSalesHeader."Document Type";
      ToSalesLine."Document No." := ToSalesHeader."No.";
      ToSalesLine."Line No." := NextLineNo;
      IF (ToSalesLine.Type <> ToSalesLine.Type::" ") AND
         (ToSalesLine."Document Type" IN [ToSalesLine."Document Type"::"Return Order",ToSalesLine."Document Type"::"Credit Memo"])
      THEN BEGIN
        ToSalesLine."Job Contract Entry No." := 0;
        IF (ToSalesLine.Amount = 0) OR
           (ToSalesHeader."Prices Including VAT" <> FromSalesHeader."Prices Including VAT") OR
           (ToSalesHeader."Currency Factor" <> FromSalesHeader."Currency Factor")
        THEN BEGIN
          InvDiscountAmount := ToSalesLine."Inv. Discount Amount";
          ToSalesLine.VALIDATE("Line Discount %");
          ToSalesLine.VALIDATE("Inv. Discount Amount",InvDiscountAmount);
        END;
      END;
      ToSalesLine.VALIDATE("Currency Code",FromSalesHeader."Currency Code");

      UpdateSalesLine(ToSalesHeader,ToSalesLine,FromSalesHeader,
        FromSalesLine,CopyThisLine,RecalculateAmount,FromSalesDocType,CopyPostedDeferral);
      ToSalesLine.CheckLocationOnWMS;

      IF ExactCostRevMandatory AND
         (FromSalesLine.Type = FromSalesLine.Type::Item) AND
         (FromSalesLine."Appl.-from Item Entry" <> 0) AND
         NOT MoveNegLines
      THEN BEGIN
        IF RecalculateAmount THEN BEGIN
          ToSalesLine.VALIDATE("Unit Price",FromSalesLine."Unit Price");
          ToSalesLine.VALIDATE("Line Discount %",FromSalesLine."Line Discount %");
          ToSalesLine.VALIDATE(
            "Line Discount Amount",
            ROUND(FromSalesLine."Line Discount Amount",Currency."Amount Rounding Precision"));
          ToSalesLine.VALIDATE(
            "Inv. Discount Amount",
            ROUND(FromSalesLine."Inv. Discount Amount",Currency."Amount Rounding Precision"));
        END;
        ToSalesLine.VALIDATE("Appl.-from Item Entry",FromSalesLine."Appl.-from Item Entry");
        IF NOT CreateToHeader THEN
          IF ToSalesLine."Shipment Date" = 0D THEN BEGIN
            IF ToSalesHeader."Shipment Date" <> 0D THEN
              ToSalesLine."Shipment Date" := ToSalesHeader."Shipment Date"
            ELSE
              ToSalesLine."Shipment Date" := WORKDATE;
          END;
      END;

      IF MoveNegLines AND (ToSalesLine.Type <> ToSalesLine.Type::" ") THEN BEGIN
        ToSalesLine.VALIDATE(Quantity,-FromSalesLine.Quantity);
        ToSalesLine.VALIDATE("Unit Price",FromSalesLine."Unit Price");
        ToSalesLine.VALIDATE("Line Discount %",FromSalesLine."Line Discount %");
        ToSalesLine."Appl.-to Item Entry" := FromSalesLine."Appl.-to Item Entry";
        ToSalesLine."Appl.-from Item Entry" := FromSalesLine."Appl.-from Item Entry";
        ToSalesLine."Job No." := FromSalesLine."Job No.";
        ToSalesLine."Job Task No." := FromSalesLine."Job Task No.";
        ToSalesLine."Job Contract Entry No." := FromSalesLine."Job Contract Entry No.";
      END;

      IF CopyJobData THEN BEGIN
        ToSalesLine."Job No." := FromSalesLine."Job No.";
        ToSalesLine."Job Task No." := FromSalesLine."Job Task No.";
        IF ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::Invoice THEN
          ToSalesLine."Job Contract Entry No." :=
            CreateJobPlanningLine(ToSalesHeader,ToSalesLine,FromSalesLine."Job Contract Entry No.")
        ELSE
          ToSalesLine."Job Contract Entry No." := FromSalesLine."Job Contract Entry No.";
      END;

      IF (ToSalesHeader."Language Code" <> FromSalesHeader."Language Code") OR RecalculateLines OR CopyExtText THEN BEGIN
        IF TransferExtendedText.SalesCheckIfAnyExtText(ToSalesLine,FALSE) THEN BEGIN
          TransferExtendedText.InsertSalesExtText(ToSalesLine);
          ToSalesLine2.SETRANGE("Document Type",ToSalesLine."Document Type");
          ToSalesLine2.SETRANGE("Document No.",ToSalesLine."Document No.");
          ToSalesLine2.FINDLAST;
          NextLineNo := ToSalesLine2."Line No.";
        END;
      END ELSE
        ToSalesLine."Attached to Line No." :=
          TransferOldExtLines.TransferExtendedText(DocLineNo,NextLineNo,FromSalesLine."Attached to Line No.");

      IF NOT RecalculateLines THEN BEGIN
        ToSalesLine."Dimension Set ID" := FromSalesLine."Dimension Set ID";
        ToSalesLine."Shortcut Dimension 1 Code" := FromSalesLine."Shortcut Dimension 1 Code";
        ToSalesLine."Shortcut Dimension 2 Code" := FromSalesLine."Shortcut Dimension 2 Code";
      END;

      IF CopyThisLine THEN BEGIN
        OnBeforeInsertToSalesLine(ToSalesLine,FromSalesLine,FromSalesDocType,RecalculateLines);
        ToSalesLine.INSERT;
        HandleAsmAttachedToSalesLine(ToSalesLine);
        IF ToSalesLine.Reserve = ToSalesLine.Reserve::Always THEN
          ToSalesLine.AutoReserve;
        OnAfterInsertToSalesLine(ToSalesLine,FromSalesLine);
      END ELSE
        LinesNotCopied := LinesNotCopied + 1;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE UpdateSalesHeaderWhenCopyFromSalesHeader@162(VAR SalesHeader@1000 : Record 36;OriginalSalesHeader@1001 : Record 36;FromDocType@1002 : Option);
    BEGIN
      ClearSalesLastNoSFields(SalesHeader);
      WITH SalesHeader DO BEGIN
        Status := Status::Open;
        IF "Document Type" <> "Document Type"::Order THEN
          "Prepayment %" := 0;
        IF FromDocType = SalesDocType::"Return Order" THEN BEGIN
          CopySellToAddressToShipToAddress;
          VALIDATE("Ship-to Code");
        END;
        IF FromDocType IN [SalesDocType::Quote,SalesDocType::"Blanket Order"] THEN
          IF OriginalSalesHeader."Posting Date" = 0D THEN
            "Posting Date" := WORKDATE
          ELSE
            "Posting Date" := OriginalSalesHeader."Posting Date";
      END;
    END;

    LOCAL PROCEDURE ClearSalesLastNoSFields@191(VAR SalesHeader@1000 : Record 36);
    BEGIN
      WITH SalesHeader DO BEGIN
        "Last Shipping No." := '';
        "Last Posting No." := '';
        "Last Prepayment No." := '';
        "Last Prepmt. Cr. Memo No." := '';
        "Last Return Receipt No." := '';
      END;
    END;

    LOCAL PROCEDURE UpdateSalesLine@132(VAR ToSalesHeader@1005 : Record 36;VAR ToSalesLine@1000 : Record 37;VAR FromSalesHeader@1001 : Record 36;VAR FromSalesLine@1002 : Record 37;VAR CopyThisLine@1004 : Boolean;RecalculateAmount@1006 : Boolean;FromSalesDocType@1008 : Option;VAR CopyPostedDeferral@1009 : Boolean);
    VAR
      GLAcc@1003 : Record 15;
      VATPostingSetup@1007 : Record 325;
      DeferralDocType@1010 : Integer;
    BEGIN
      OnBeforeUpdateSalesLine(
        ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLine,
        CopyThisLine,RecalculateAmount,FromSalesDocType,CopyPostedDeferral);

      CopyPostedDeferral := FALSE;
      DeferralDocType := DeferralUtilities.GetSalesDeferralDocType;
      IF RecalculateLines AND NOT FromSalesLine."System-Created Entry" THEN BEGIN
        ToSalesLine.VALIDATE(Type,FromSalesLine.Type);
        ToSalesLine.Description := FromSalesLine.Description;
        ToSalesLine.VALIDATE("Description 2",FromSalesLine."Description 2");
        OnUpdateSalesLine(ToSalesLine,FromSalesLine);

        IF (FromSalesLine.Type <> 0) AND (FromSalesLine."No." <> '') THEN BEGIN
          IF ToSalesLine.Type = ToSalesLine.Type::"G/L Account" THEN BEGIN
            ToSalesLine."No." := FromSalesLine."No.";
            IF GLAcc."No." <> FromSalesLine."No." THEN
              GLAcc.GET(FromSalesLine."No.");
            CopyThisLine := GLAcc."Direct Posting";
            IF CopyThisLine THEN
              ToSalesLine.VALIDATE("No.",FromSalesLine."No.");
          END ELSE
            ToSalesLine.VALIDATE("No.",FromSalesLine."No.");
          ToSalesLine.VALIDATE("Variant Code",FromSalesLine."Variant Code");
          ToSalesLine.VALIDATE("Location Code",FromSalesLine."Location Code");
          ToSalesLine.VALIDATE("Unit of Measure",FromSalesLine."Unit of Measure");
          ToSalesLine.VALIDATE("Unit of Measure Code",FromSalesLine."Unit of Measure Code");
          ToSalesLine.VALIDATE(Quantity,FromSalesLine.Quantity);

          IF NOT (FromSalesLine.Type IN [FromSalesLine.Type::Item,FromSalesLine.Type::Resource]) THEN BEGIN
            IF (FromSalesHeader."Currency Code" <> ToSalesHeader."Currency Code") OR
               (FromSalesHeader."Prices Including VAT" <> ToSalesHeader."Prices Including VAT")
            THEN BEGIN
              ToSalesLine."Unit Price" := 0;
              ToSalesLine."Line Discount %" := 0;
            END ELSE BEGIN
              ToSalesLine.VALIDATE("Unit Price",FromSalesLine."Unit Price");
              ToSalesLine.VALIDATE("Line Discount %",FromSalesLine."Line Discount %");
            END;
            IF ToSalesLine.Quantity <> 0 THEN
              ToSalesLine.VALIDATE("Line Discount Amount",FromSalesLine."Line Discount Amount");
          END;
          ToSalesLine.VALIDATE("Work Type Code",FromSalesLine."Work Type Code");
          IF (ToSalesLine."Document Type" = ToSalesLine."Document Type"::Order) AND
             (FromSalesLine."Purchasing Code" <> '')
          THEN
            ToSalesLine.VALIDATE("Purchasing Code",FromSalesLine."Purchasing Code");
        END;
        IF (FromSalesLine.Type = FromSalesLine.Type::" ") AND (FromSalesLine."No." <> '') THEN
          ToSalesLine.VALIDATE("No.",FromSalesLine."No.");
        IF IsDeferralToBeCopied(DeferralDocType,ToSalesLine."Document Type",FromSalesDocType) THEN
          ToSalesLine.VALIDATE("Deferral Code",FromSalesLine."Deferral Code");
      END ELSE BEGIN
        SetDefaultValuesToSalesLine(ToSalesLine,ToSalesHeader,FromSalesLine."VAT Difference");
        IF IsDeferralToBeCopied(DeferralDocType,ToSalesLine."Document Type",FromSalesDocType) THEN
          IF IsDeferralPosted(DeferralDocType,FromSalesDocType) THEN
            CopyPostedDeferral := TRUE
          ELSE
            ToSalesLine."Returns Deferral Start Date" :=
              CopyDeferrals(DeferralDocType,FromSalesLine."Document Type",FromSalesLine."Document No.",
                FromSalesLine."Line No.",ToSalesLine."Document Type",ToSalesLine."Document No.",ToSalesLine."Line No.")
        ELSE
          IF IsDeferralToBeDefaulted(DeferralDocType,ToSalesLine."Document Type",FromSalesDocType) THEN
            InitSalesDeferralCode(ToSalesLine);

        IF ToSalesLine."Document Type" <> ToSalesLine."Document Type"::Order THEN BEGIN
          ToSalesLine."Drop Shipment" := FALSE;
          ToSalesLine."Special Order" := FALSE;
        END;
        IF RecalculateAmount AND (FromSalesLine."Appl.-from Item Entry" = 0) THEN BEGIN
          IF (ToSalesLine.Type <> ToSalesLine.Type::" ") AND (ToSalesLine."No." <> '') THEN BEGIN
            ToSalesLine.VALIDATE("Line Discount %",FromSalesLine."Line Discount %");
            ToSalesLine.VALIDATE(
              "Inv. Discount Amount",ROUND(FromSalesLine."Inv. Discount Amount",Currency."Amount Rounding Precision"));
          END;
          ToSalesLine.VALIDATE("Unit Cost (LCY)",FromSalesLine."Unit Cost (LCY)");
        END;
        IF VATPostingSetup.GET(ToSalesLine."VAT Bus. Posting Group",ToSalesLine."VAT Prod. Posting Group") THEN
          ToSalesLine."VAT Identifier" := VATPostingSetup."VAT Identifier";

        ToSalesLine.UpdateWithWarehouseShip;
        IF (ToSalesLine.Type = ToSalesLine.Type::Item) AND (ToSalesLine."No." <> '') THEN BEGIN
          GetItem(ToSalesLine."No.");
          IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT ToSalesLine.IsShipment THEN
            ToSalesLine.GetUnitCost;

          IF Item.Reserve = Item.Reserve::Optional THEN
            ToSalesLine.Reserve := ToSalesHeader.Reserve
          ELSE
            ToSalesLine.Reserve := Item.Reserve;
          IF ToSalesLine.Reserve = ToSalesLine.Reserve::Always THEN
            IF ToSalesHeader."Shipment Date" <> 0D THEN
              ToSalesLine."Shipment Date" := ToSalesHeader."Shipment Date"
            ELSE
              ToSalesLine."Shipment Date" := WORKDATE;
        END;
      END;

      OnAfterUpdateSalesLine(
        ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLine,
        CopyThisLine,RecalculateAmount,FromSalesDocType,CopyPostedDeferral);
    END;

    LOCAL PROCEDURE HandleAsmAttachedToSalesLine@25(VAR ToSalesLine@1000 : Record 37);
    VAR
      Item@1001 : Record 27;
    BEGIN
      WITH ToSalesLine DO BEGIN
        IF Type <> Type::Item THEN
          EXIT;
        IF NOT ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order,"Document Type"::"Blanket Order"]) THEN
          EXIT;
      END;
      IF AsmHdrExistsForFromDocLine THEN BEGIN
        ToSalesLine."Qty. to Assemble to Order" := QtyToAsmToOrder;
        ToSalesLine."Qty. to Asm. to Order (Base)" := QtyToAsmToOrderBase;
        ToSalesLine.MODIFY;
        CopyAsmOrderToAsmOrder(TempAsmHeader,TempAsmLine,ToSalesLine,GetAsmOrderType(ToSalesLine."Document Type"),'',TRUE);
      END ELSE BEGIN
        Item.GET(ToSalesLine."No.");
        IF (Item."Assembly Policy" = Item."Assembly Policy"::"Assemble-to-Order") AND
           (Item."Replenishment System" = Item."Replenishment System"::Assembly)
        THEN BEGIN
          ToSalesLine.VALIDATE("Qty. to Assemble to Order",ToSalesLine.Quantity);
          ToSalesLine.MODIFY;
        END;
      END;
    END;

    LOCAL PROCEDURE CopyPurchLine@20(VAR ToPurchHeader@1011 : Record 38;VAR ToPurchLine@1001 : Record 39;VAR FromPurchHeader@1012 : Record 38;VAR FromPurchLine@1003 : Record 39;VAR NextLineNo@1006 : Integer;VAR LinesNotCopied@1005 : Integer;RecalculateAmount@1004 : Boolean;FromPurchDocType@1008 : Option;VAR CopyPostedDeferral@1002 : Boolean;DocLineNo@1009 : Integer) : Boolean;
    VAR
      ToPurchLine2@1007 : Record 39;
      RoundingLineInserted@1013 : Boolean;
      CopyThisLine@1000 : Boolean;
      InvDiscountAmount@1020 : Decimal;
    BEGIN
      CopyThisLine := TRUE;

      CheckPurchRounding(FromPurchLine,RoundingLineInserted);

      IF ((ToPurchHeader."Language Code" <> FromPurchHeader."Language Code") OR RecalculateLines) AND
         (FromPurchLine."Attached to Line No." <> 0) OR
         FromPurchLine."Prepayment Line" OR RoundingLineInserted
      THEN
        EXIT(FALSE);

      IF RecalculateLines AND NOT FromPurchLine."System-Created Entry" THEN BEGIN
        ToPurchLine.INIT;
        OnAfterInitToPurchLine(ToPurchLine);
      END ELSE BEGIN
        ToPurchLine := FromPurchLine;
        ToPurchLine."Returns Deferral Start Date" := 0D;
        IF ToPurchHeader."Document Type" IN [ToPurchHeader."Document Type"::Quote,ToPurchHeader."Document Type"::"Blanket Order"] THEN
          ToPurchLine."Deferral Code" := '';
        IF MoveNegLines AND (ToPurchLine.Type <> ToPurchLine.Type::" ") THEN BEGIN
          ToPurchLine.Amount := -ToPurchLine.Amount;
          ToPurchLine."Amount Including VAT" := -ToPurchLine."Amount Including VAT";
        END
      END;

      IF (NOT RecalculateLines) AND (ToPurchLine."No." <> '') THEN
        ToPurchLine.TESTFIELD("VAT Bus. Posting Group",ToPurchHeader."VAT Bus. Posting Group");

      NextLineNo := NextLineNo + 10000;
      ToPurchLine."Document Type" := ToPurchHeader."Document Type";
      ToPurchLine."Document No." := ToPurchHeader."No.";
      ToPurchLine."Line No." := NextLineNo;
      ToPurchLine.VALIDATE("Currency Code",FromPurchHeader."Currency Code");
      IF (ToPurchLine.Type <> ToPurchLine.Type::" ") AND
         ((ToPurchLine.Amount = 0) OR
          (ToPurchHeader."Prices Including VAT" <> FromPurchHeader."Prices Including VAT") OR
          (ToPurchHeader."Currency Factor" <> FromPurchHeader."Currency Factor"))
      THEN BEGIN
        InvDiscountAmount := ToPurchLine."Inv. Discount Amount";
        ToPurchLine.VALIDATE("Line Discount %");
        ToPurchLine.VALIDATE("Inv. Discount Amount",InvDiscountAmount);
      END;

      UpdatePurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLine,
        CopyThisLine,RecalculateAmount,FromPurchDocType,CopyPostedDeferral);
      ToPurchLine.CheckLocationOnWMS;

      IF ExactCostRevMandatory AND
         (FromPurchLine.Type = FromPurchLine.Type::Item) AND
         (FromPurchLine."Appl.-to Item Entry" <> 0) AND
         NOT MoveNegLines
      THEN BEGIN
        IF RecalculateAmount THEN BEGIN
          ToPurchLine.VALIDATE("Direct Unit Cost",FromPurchLine."Direct Unit Cost");
          ToPurchLine.VALIDATE("Line Discount %",FromPurchLine."Line Discount %");
          ToPurchLine.VALIDATE(
            "Line Discount Amount",
            ROUND(FromPurchLine."Line Discount Amount",Currency."Amount Rounding Precision"));
          ToPurchLine.VALIDATE(
            "Inv. Discount Amount",
            ROUND(FromPurchLine."Inv. Discount Amount",Currency."Amount Rounding Precision"));
        END;
        ToPurchLine.VALIDATE("Appl.-to Item Entry",FromPurchLine."Appl.-to Item Entry");
        IF NOT CreateToHeader THEN
          IF ToPurchLine."Expected Receipt Date" = 0D THEN BEGIN
            IF ToPurchHeader."Expected Receipt Date" <> 0D THEN
              ToPurchLine."Expected Receipt Date" := ToPurchHeader."Expected Receipt Date"
            ELSE
              ToPurchLine."Expected Receipt Date" := WORKDATE;
          END;
      END;

      IF MoveNegLines AND (ToPurchLine.Type <> ToPurchLine.Type::" ") THEN BEGIN
        ToPurchLine.VALIDATE(Quantity,-FromPurchLine.Quantity);
        ToPurchLine."Appl.-to Item Entry" := FromPurchLine."Appl.-to Item Entry"
      END;

      IF (ToPurchHeader."Language Code" <> FromPurchHeader."Language Code") OR RecalculateLines OR CopyExtText THEN BEGIN
        IF TransferExtendedText.PurchCheckIfAnyExtText(ToPurchLine,FALSE) THEN BEGIN
          TransferExtendedText.InsertPurchExtText(ToPurchLine);
          ToPurchLine2.SETRANGE("Document Type",ToPurchLine."Document Type");
          ToPurchLine2.SETRANGE("Document No.",ToPurchLine."Document No.");
          ToPurchLine2.FINDLAST;
          NextLineNo := ToPurchLine2."Line No.";
        END;
      END ELSE
        ToPurchLine."Attached to Line No." :=
          TransferOldExtLines.TransferExtendedText(DocLineNo,NextLineNo,FromPurchLine."Attached to Line No.");

      ToPurchLine.VALIDATE("Job No.",FromPurchLine."Job No.");
      ToPurchLine.VALIDATE("Job Task No.",FromPurchLine."Job Task No.");
      ToPurchLine.VALIDATE("Job Line Type",FromPurchLine."Job Line Type");

      IF NOT RecalculateLines THEN BEGIN
        ToPurchLine."Dimension Set ID" := FromPurchLine."Dimension Set ID";
        ToPurchLine."Shortcut Dimension 1 Code" := FromPurchLine."Shortcut Dimension 1 Code";
        ToPurchLine."Shortcut Dimension 2 Code" := FromPurchLine."Shortcut Dimension 2 Code";
      END;

      IF CopyThisLine THEN BEGIN
        OnBeforeInsertToPurchLine(ToPurchLine,FromPurchLine,FromPurchDocType,RecalculateLines);
        ToPurchLine.INSERT;
        OnAfterInsertToPurchLine(ToPurchLine,FromPurchLine);
      END ELSE
        LinesNotCopied := LinesNotCopied + 1;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE UpdatePurchHeaderWhenCopyFromPurchHeader@205(VAR PurchaseHeader@1000 : Record 38;OriginalPurchaseHeader@1001 : Record 38;FromDocType@1002 : Option);
    BEGIN
      ClearPurchLastNoSFields(PurchaseHeader);
      WITH PurchaseHeader DO BEGIN
        Status := Status::Open;
        "IC Status" := "IC Status"::New;
        IF "Document Type" <> "Document Type"::Order THEN
          "Prepayment %" := 0;
        IF FromDocType IN [PurchDocType::Quote,PurchDocType::"Blanket Order"] THEN
          IF OriginalPurchaseHeader."Posting Date" = 0D THEN
            "Posting Date" := WORKDATE
          ELSE
            "Posting Date" := OriginalPurchaseHeader."Posting Date";
      END;
    END;

    LOCAL PROCEDURE ClearPurchLastNoSFields@197(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
      WITH PurchaseHeader DO BEGIN
        "Last Receiving No." := '';
        "Last Posting No." := '';
        "Last Prepayment No." := '';
        "Last Prepmt. Cr. Memo No." := '';
        "Last Return Shipment No." := '';
      END;
    END;

    LOCAL PROCEDURE UpdatePurchLine@135(VAR ToPurchHeader@1000 : Record 38;VAR ToPurchLine@1001 : Record 39;VAR FromPurchHeader@1005 : Record 38;VAR FromPurchLine@1002 : Record 39;VAR CopyThisLine@1004 : Boolean;RecalculateAmount@1006 : Boolean;FromPurchDocType@1008 : Option;VAR CopyPostedDeferral@1009 : Boolean);
    VAR
      GLAcc@1003 : Record 15;
      VATPostingSetup@1007 : Record 325;
      DeferralDocType@1010 : Integer;
    BEGIN
      OnBeforeUpdatePurchLine(
        ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLine,
        CopyThisLine,RecalculateAmount,FromPurchDocType,CopyPostedDeferral);

      CopyPostedDeferral := FALSE;
      DeferralDocType := DeferralUtilities.GetPurchDeferralDocType;
      IF RecalculateLines AND NOT FromPurchLine."System-Created Entry" THEN BEGIN
        ToPurchLine.VALIDATE(Type,FromPurchLine.Type);
        ToPurchLine.Description := FromPurchLine.Description;
        ToPurchLine.VALIDATE("Description 2",FromPurchLine."Description 2");
        OnUpdatePurchLine(ToPurchLine,FromPurchLine);

        IF (FromPurchLine.Type <> 0) AND (FromPurchLine."No." <> '') THEN BEGIN
          IF ToPurchLine.Type = ToPurchLine.Type::"G/L Account" THEN BEGIN
            ToPurchLine."No." := FromPurchLine."No.";
            IF GLAcc."No." <> FromPurchLine."No." THEN
              GLAcc.GET(FromPurchLine."No.");
            CopyThisLine := GLAcc."Direct Posting";
            IF CopyThisLine THEN
              ToPurchLine.VALIDATE("No.",FromPurchLine."No.");
          END ELSE
            ToPurchLine.VALIDATE("No.",FromPurchLine."No.");
          ToPurchLine.VALIDATE("Variant Code",FromPurchLine."Variant Code");
          ToPurchLine.VALIDATE("Location Code",FromPurchLine."Location Code");
          ToPurchLine.VALIDATE("Unit of Measure",FromPurchLine."Unit of Measure");
          ToPurchLine.VALIDATE("Unit of Measure Code",FromPurchLine."Unit of Measure Code");
          ToPurchLine.VALIDATE(Quantity,FromPurchLine.Quantity);
          IF FromPurchLine.Type <> FromPurchLine.Type::Item THEN BEGIN
            ToPurchHeader.TESTFIELD("Currency Code",FromPurchHeader."Currency Code");
            ToPurchLine.VALIDATE("Direct Unit Cost",FromPurchLine."Direct Unit Cost");
            ToPurchLine.VALIDATE("Line Discount %",FromPurchLine."Line Discount %");
            IF ToPurchLine.Quantity <> 0 THEN
              ToPurchLine.VALIDATE("Line Discount Amount",FromPurchLine."Line Discount Amount");
          END;
          IF (ToPurchLine."Document Type" = ToPurchLine."Document Type"::Order) AND
             (FromPurchLine."Purchasing Code" <> '') AND NOT FromPurchLine."Drop Shipment" AND
             NOT FromPurchLine."Special Order"
          THEN
            ToPurchLine.VALIDATE("Purchasing Code",FromPurchLine."Purchasing Code");
        END;
        IF (FromPurchLine.Type = FromPurchLine.Type::" ") AND (FromPurchLine."No." <> '') THEN
          ToPurchLine.VALIDATE("No.",FromPurchLine."No.");
        IF IsDeferralToBeCopied(DeferralDocType,ToPurchLine."Document Type",FromPurchDocType) THEN
          ToPurchLine.VALIDATE("Deferral Code",FromPurchLine."Deferral Code");
      END ELSE BEGIN
        SetDefaultValuesToPurchLine(ToPurchLine,ToPurchHeader,FromPurchLine."VAT Difference");
        IF IsDeferralToBeCopied(DeferralDocType,ToPurchLine."Document Type",FromPurchDocType) THEN
          IF IsDeferralPosted(DeferralDocType,FromPurchDocType) THEN
            CopyPostedDeferral := TRUE
          ELSE
            ToPurchLine."Returns Deferral Start Date" :=
              CopyDeferrals(DeferralDocType,FromPurchLine."Document Type",FromPurchLine."Document No.",
                FromPurchLine."Line No.",ToPurchLine."Document Type",ToPurchLine."Document No.",ToPurchLine."Line No.")
        ELSE
          IF IsDeferralToBeDefaulted(DeferralDocType,ToPurchLine."Document Type",FromPurchDocType) THEN
            InitPurchDeferralCode(ToPurchLine);

        IF FromPurchLine."Drop Shipment" OR FromPurchLine."Special Order" THEN
          ToPurchLine."Purchasing Code" := '';
        ToPurchLine."Drop Shipment" := FALSE;
        ToPurchLine."Special Order" := FALSE;
        IF VATPostingSetup.GET(ToPurchLine."VAT Bus. Posting Group",ToPurchLine."VAT Prod. Posting Group") THEN
          ToPurchLine."VAT Identifier" := VATPostingSetup."VAT Identifier";

        OnBeforeCopyPurchLines(ToPurchLine);

        CopyDocLines(RecalculateAmount,ToPurchLine,FromPurchLine);

        ToPurchLine.UpdateWithWarehouseReceive;
        ToPurchLine."Pay-to Vendor No." := ToPurchHeader."Pay-to Vendor No.";
      END;

      OnAfterUpdatePurchLine(
        ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLine,
        CopyThisLine,RecalculateAmount,FromPurchDocType,CopyPostedDeferral);
    END;

    LOCAL PROCEDURE CheckPurchRounding@8(FromPurchLine@1000 : Record 39;VAR RoundingLineInserted@1002 : Boolean);
    VAR
      PurchSetup@1005 : Record 312;
      Vendor@1004 : Record 23;
      VendorPostingGroup@1003 : Record 93;
    BEGIN
      IF (FromPurchLine.Type <> FromPurchLine.Type::"G/L Account") OR (FromPurchLine."No." = '') THEN
        EXIT;
      IF NOT FromPurchLine."System-Created Entry" THEN
        EXIT;

      PurchSetup.GET;
      IF PurchSetup."Invoice Rounding" THEN BEGIN
        Vendor.GET(FromPurchLine."Pay-to Vendor No.");
        VendorPostingGroup.GET(Vendor."Vendor Posting Group");
        RoundingLineInserted := FromPurchLine."No." = VendorPostingGroup.GetInvRoundingAccount;
      END;
    END;

    LOCAL PROCEDURE CheckSalesRounding@133(FromSalesLine@1000 : Record 37;VAR RoundingLineInserted@1002 : Boolean);
    VAR
      SalesSetup@1005 : Record 311;
      Customer@1004 : Record 18;
      CustomerPostingGroup@1003 : Record 92;
    BEGIN
      IF (FromSalesLine.Type <> FromSalesLine.Type::"G/L Account") OR (FromSalesLine."No." = '') THEN
        EXIT;
      IF NOT FromSalesLine."System-Created Entry" THEN
        EXIT;

      SalesSetup.GET;
      IF SalesSetup."Invoice Rounding" THEN BEGIN
        Customer.GET(FromSalesLine."Bill-to Customer No.");
        CustomerPostingGroup.GET(Customer."Customer Posting Group");
        RoundingLineInserted := FromSalesLine."No." = CustomerPostingGroup.GetInvRoundingAccount;
      END;
    END;

    LOCAL PROCEDURE CopyFromSalesDocAssgntToLine@5800(VAR ToSalesLine@1005 : Record 37;FromSalesLine@1000 : Record 37;VAR ItemChargeAssgntNextLineNo@1001 : Integer);
    VAR
      FromItemChargeAssgntSales@1002 : Record 5809;
      ToItemChargeAssgntSales@1003 : Record 5809;
      AssignItemChargeSales@1004 : Codeunit 5807;
    BEGIN
      WITH FromSalesLine DO BEGIN
        FromItemChargeAssgntSales.RESET;
        FromItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
        FromItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
        FromItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
        FromItemChargeAssgntSales.SETFILTER(
          "Applies-to Doc. Type",'<>%1',"Document Type");
        IF FromItemChargeAssgntSales.FIND('-') THEN
          REPEAT
            ToItemChargeAssgntSales.COPY(FromItemChargeAssgntSales);
            ToItemChargeAssgntSales."Document Type" := ToSalesLine."Document Type";
            ToItemChargeAssgntSales."Document No." := ToSalesLine."Document No.";
            ToItemChargeAssgntSales."Document Line No." := ToSalesLine."Line No.";
            AssignItemChargeSales.InsertItemChargeAssgnt(
              ToItemChargeAssgntSales,ToItemChargeAssgntSales."Applies-to Doc. Type",
              ToItemChargeAssgntSales."Applies-to Doc. No.",ToItemChargeAssgntSales."Applies-to Doc. Line No.",
              ToItemChargeAssgntSales."Item No.",ToItemChargeAssgntSales.Description,ItemChargeAssgntNextLineNo);
          UNTIL FromItemChargeAssgntSales.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CopyFromPurchDocAssgntToLine@4(VAR ToPurchLine@1008 : Record 39;FromPurchLine@1000 : Record 39;VAR ItemChargeAssgntNextLineNo@1001 : Integer);
    VAR
      FromItemChargeAssgntPurch@1002 : Record 5805;
      ToItemChargeAssgntPurch@1003 : Record 5805;
      AssignItemChargePurch@1004 : Codeunit 5805;
    BEGIN
      WITH FromPurchLine DO BEGIN
        FromItemChargeAssgntPurch.RESET;
        FromItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
        FromItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
        FromItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
        FromItemChargeAssgntPurch.SETFILTER(
          "Applies-to Doc. Type",'<>%1',"Document Type");
        IF FromItemChargeAssgntPurch.FIND('-') THEN
          REPEAT
            ToItemChargeAssgntPurch.COPY(FromItemChargeAssgntPurch);
            ToItemChargeAssgntPurch."Document Type" := ToPurchLine."Document Type";
            ToItemChargeAssgntPurch."Document No." := ToPurchLine."Document No.";
            ToItemChargeAssgntPurch."Document Line No." := ToPurchLine."Line No.";
            AssignItemChargePurch.InsertItemChargeAssgnt(
              ToItemChargeAssgntPurch,ToItemChargeAssgntPurch."Applies-to Doc. Type",
              ToItemChargeAssgntPurch."Applies-to Doc. No.",ToItemChargeAssgntPurch."Applies-to Doc. Line No.",
              ToItemChargeAssgntPurch."Item No.",ToItemChargeAssgntPurch.Description,ItemChargeAssgntNextLineNo);
          UNTIL FromItemChargeAssgntPurch.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CopyFromPurchLineItemChargeAssign@159(FromPurchLine@1000 : Record 39;ToPurchLine@1001 : Record 39;FromPurchHeader@1014 : Record 38;VAR ItemChargeAssgntNextLineNo@1006 : Integer);
    VAR
      ToItemChargeAssignmentPurch@1002 : Record 5805;
      ValueEntry@1003 : Record 5802;
      ItemLedgerEntry@1004 : Record 32;
      Item@1007 : Record 27;
      Currency@1012 : Record 4;
      ItemChargeAssgntPurch@1005 : Codeunit 5805;
      CurrencyFactor@1009 : Decimal;
      QtyToAssign@1011 : Decimal;
      SumQtyToAssign@1010 : Decimal;
      RemainingQty@1008 : Decimal;
    BEGIN
      IF FromPurchLine."Document Type" = FromPurchLine."Document Type"::"Credit Memo" THEN
        ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Purchase Credit Memo")
      ELSE
        ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Purchase Invoice");

      ValueEntry.SETRANGE("Document No.",FromPurchLine."Document No.");
      ValueEntry.SETRANGE("Document Line No.",FromPurchLine."Line No.");
      ValueEntry.SETRANGE("Item Charge No.",FromPurchLine."No.");
      ToItemChargeAssignmentPurch."Document Type" := ToPurchLine."Document Type";
      ToItemChargeAssignmentPurch."Document No." := ToPurchLine."Document No.";
      ToItemChargeAssignmentPurch."Document Line No." := ToPurchLine."Line No.";
      ToItemChargeAssignmentPurch."Item Charge No." := FromPurchLine."No.";
      ToItemChargeAssignmentPurch."Unit Cost" := FromPurchLine."Unit Cost";

      IF ValueEntry.FINDSET THEN BEGIN
        REPEAT
          IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN
            IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Purchase Receipt" THEN BEGIN
              Item.GET(ItemLedgerEntry."Item No.");
              CurrencyFactor := FromPurchHeader."Currency Factor";

              IF NOT Currency.GET(FromPurchHeader."Currency Code") THEN BEGIN
                CurrencyFactor := 1;
                Currency.InitRoundingPrecision;
              END;

              QtyToAssign := ValueEntry."Cost Amount (Actual)" * CurrencyFactor / ToPurchLine."Unit Cost";
              SumQtyToAssign += QtyToAssign;

              ItemChargeAssgntPurch.InsertItemChargeAssgntWithAssignValues(
                ToItemChargeAssignmentPurch,ToItemChargeAssignmentPurch."Applies-to Doc. Type"::Receipt,
                ItemLedgerEntry."Document No.",ItemLedgerEntry."Document Line No.",ItemLedgerEntry."Item No.",Item.Description,
                QtyToAssign,0,ItemChargeAssgntNextLineNo);
            END;
        UNTIL ValueEntry.NEXT = 0;

        // Use 2 passes to correct rounding issues
        ToItemChargeAssignmentPurch.SETRANGE("Document Type",ToPurchLine."Document Type");
        ToItemChargeAssignmentPurch.SETRANGE("Document No.",ToPurchLine."Document No.");
        ToItemChargeAssignmentPurch.SETRANGE("Document Line No.",ToPurchLine."Line No.");
        IF ToItemChargeAssignmentPurch.FINDSET(TRUE) THEN BEGIN
          RemainingQty := (FromPurchLine.Quantity - SumQtyToAssign) / ValueEntry.COUNT;
          SumQtyToAssign := 0;
          REPEAT
            AddRemainingQtyToPurchItemCharge(ToItemChargeAssignmentPurch,RemainingQty);
            SumQtyToAssign += ToItemChargeAssignmentPurch."Qty. to Assign";
          UNTIL ToItemChargeAssignmentPurch.NEXT = 0;

          RemainingQty := FromPurchLine.Quantity - SumQtyToAssign;
          IF RemainingQty <> 0 THEN
            AddRemainingQtyToPurchItemCharge(ToItemChargeAssignmentPurch,RemainingQty);
        END;
      END;
    END;

    LOCAL PROCEDURE CopyFromSalesLineItemChargeAssign@160(FromSalesLine@1000 : Record 37;ToSalesLine@1001 : Record 37;FromSalesHeader@1002 : Record 36;VAR ItemChargeAssgntNextLineNo@1003 : Integer);
    VAR
      ValueEntry@1004 : Record 5802;
      Currency@1005 : Record 4;
      ToItemChargeAssignmentSales@1006 : Record 5809;
      ItemLedgerEntry@1012 : Record 32;
      Item@1011 : Record 27;
      ItemChargeAssgntSales@1013 : Codeunit 5807;
      CurrencyFactor@1010 : Decimal;
      QtyToAssign@1009 : Decimal;
      SumQtyToAssign@1008 : Decimal;
      RemainingQty@1007 : Decimal;
    BEGIN
      IF FromSalesLine."Document Type" = FromSalesLine."Document Type"::"Credit Memo" THEN
        ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Credit Memo")
      ELSE
        ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Invoice");

      ValueEntry.SETRANGE("Document No.",FromSalesLine."Document No.");
      ValueEntry.SETRANGE("Document Line No.",FromSalesLine."Line No.");
      ValueEntry.SETRANGE("Item Charge No.",FromSalesLine."No.");
      ToItemChargeAssignmentSales."Document Type" := ToSalesLine."Document Type";
      ToItemChargeAssignmentSales."Document No." := ToSalesLine."Document No.";
      ToItemChargeAssignmentSales."Document Line No." := ToSalesLine."Line No.";
      ToItemChargeAssignmentSales."Item Charge No." := FromSalesLine."No.";
      ToItemChargeAssignmentSales."Unit Cost" := FromSalesLine."Unit Price";

      IF ValueEntry.FINDSET THEN BEGIN
        REPEAT
          IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN
            IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" THEN BEGIN
              Item.GET(ItemLedgerEntry."Item No.");
              CurrencyFactor := FromSalesHeader."Currency Factor";

              IF NOT Currency.GET(FromSalesHeader."Currency Code") THEN BEGIN
                CurrencyFactor := 1;
                Currency.InitRoundingPrecision;
              END;

              QtyToAssign := ValueEntry."Cost Amount (Actual)" * CurrencyFactor / ToSalesLine."Unit Price";
              SumQtyToAssign += QtyToAssign;

              ItemChargeAssgntSales.InsertItemChargeAssgntWithAssignValues(
                ToItemChargeAssignmentSales,ToItemChargeAssignmentSales."Applies-to Doc. Type"::Shipment,
                ItemLedgerEntry."Document No.",ItemLedgerEntry."Document Line No.",ItemLedgerEntry."Item No.",Item.Description,
                QtyToAssign,0,ItemChargeAssgntNextLineNo);
            END;
        UNTIL ValueEntry.NEXT = 0;

        // Use 2 passes to correct rounding issues
        ToItemChargeAssignmentSales.SETRANGE("Document Type",ToSalesLine."Document Type");
        ToItemChargeAssignmentSales.SETRANGE("Document No.",ToSalesLine."Document No.");
        ToItemChargeAssignmentSales.SETRANGE("Document Line No.",ToSalesLine."Line No.");
        IF ToItemChargeAssignmentSales.FINDSET(TRUE) THEN BEGIN
          RemainingQty := (FromSalesLine.Quantity - SumQtyToAssign) / ValueEntry.COUNT;
          SumQtyToAssign := 0;
          REPEAT
            AddRemainingQtyToSalesItemCharge(ToItemChargeAssignmentSales,RemainingQty);
            SumQtyToAssign += ToItemChargeAssignmentSales."Qty. to Assign";
          UNTIL ToItemChargeAssignmentSales.NEXT = 0;

          RemainingQty := FromSalesLine.Quantity - SumQtyToAssign;
          IF RemainingQty <> 0 THEN
            AddRemainingQtyToSalesItemCharge(ToItemChargeAssignmentSales,RemainingQty);
        END;
      END;
    END;

    LOCAL PROCEDURE AddRemainingQtyToPurchItemCharge@188(VAR ItemChargeAssignmentPurch@1000 : Record 5805;RemainingQty@1001 : Decimal);
    BEGIN
      ItemChargeAssignmentPurch.VALIDATE("Qty. to Assign",ROUND(ItemChargeAssignmentPurch."Qty. to Assign" + RemainingQty,0.00001));
      ItemChargeAssignmentPurch.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE AddRemainingQtyToSalesItemCharge@164(VAR ItemChargeAssignmentSales@1000 : Record 5809;RemainingQty@1001 : Decimal);
    BEGIN
      ItemChargeAssignmentSales.VALIDATE("Qty. to Assign",ROUND(ItemChargeAssignmentSales."Qty. to Assign" + RemainingQty,0.00001));
      ItemChargeAssignmentSales.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE WarnSalesInvoicePmtDisc@11(VAR ToSalesHeader@1001 : Record 36;VAR FromSalesHeader@1002 : Record 36;FromDocType@1004 : Option;FromDocNo@1003 : Code[20]);
    VAR
      CustLedgEntry@1000 : Record 21;
    BEGIN
      IF HideDialog THEN
        EXIT;

      IF IncludeHeader AND
         (ToSalesHeader."Document Type" IN
          [ToSalesHeader."Document Type"::"Return Order",ToSalesHeader."Document Type"::"Credit Memo"])
      THEN BEGIN
        CustLedgEntry.SETCURRENTKEY("Document No.");
        CustLedgEntry.SETRANGE("Document Type",FromSalesHeader."Document Type"::Invoice);
        CustLedgEntry.SETRANGE("Document No.",FromDocNo);
        IF CustLedgEntry.FINDFIRST THEN BEGIN
          IF (CustLedgEntry."Pmt. Disc. Given (LCY)" <> 0) AND
             (CustLedgEntry."Journal Batch Name" = '')
          THEN
            MESSAGE(Text006,SELECTSTR(FromDocType,Text007),FromDocNo);
        END;
      END;

      IF IncludeHeader AND
         (ToSalesHeader."Document Type" IN
          [ToSalesHeader."Document Type"::Invoice,ToSalesHeader."Document Type"::Order,
           ToSalesHeader."Document Type"::Quote,ToSalesHeader."Document Type"::"Blanket Order"]) AND
         (FromDocType = 9)
      THEN BEGIN
        CustLedgEntry.SETCURRENTKEY("Document No.");
        CustLedgEntry.SETRANGE("Document Type",FromSalesHeader."Document Type"::"Credit Memo");
        CustLedgEntry.SETRANGE("Document No.",FromDocNo);
        IF CustLedgEntry.FINDFIRST THEN BEGIN
          IF (CustLedgEntry."Pmt. Disc. Given (LCY)" <> 0) AND
             (CustLedgEntry."Journal Batch Name" = '')
          THEN
            MESSAGE(Text006,SELECTSTR(FromDocType - 1,Text007),FromDocNo);
        END;
      END;
    END;

    LOCAL PROCEDURE WarnPurchInvoicePmtDisc@10(VAR ToPurchHeader@1001 : Record 38;VAR FromPurchHeader@1002 : Record 38;FromDocType@1004 : Option;FromDocNo@1003 : Code[20]);
    VAR
      VendLedgEntry@1000 : Record 25;
    BEGIN
      IF HideDialog THEN
        EXIT;

      IF IncludeHeader AND
         (ToPurchHeader."Document Type" IN
          [ToPurchHeader."Document Type"::"Return Order",ToPurchHeader."Document Type"::"Credit Memo"])
      THEN BEGIN
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document Type",FromPurchHeader."Document Type"::Invoice);
        VendLedgEntry.SETRANGE("Document No.",FromDocNo);
        IF VendLedgEntry.FINDFIRST THEN BEGIN
          IF (VendLedgEntry."Pmt. Disc. Rcd.(LCY)" <> 0) AND
             (VendLedgEntry."Journal Batch Name" = '')
          THEN
            MESSAGE(Text009,SELECTSTR(FromDocType,Text007),FromDocNo);
        END;
      END;

      IF IncludeHeader AND
         (ToPurchHeader."Document Type" IN
          [ToPurchHeader."Document Type"::Invoice,ToPurchHeader."Document Type"::Order,
           ToPurchHeader."Document Type"::Quote,ToPurchHeader."Document Type"::"Blanket Order"]) AND
         (FromDocType = 9)
      THEN BEGIN
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document Type",FromPurchHeader."Document Type"::"Credit Memo");
        VendLedgEntry.SETRANGE("Document No.",FromDocNo);
        IF VendLedgEntry.FINDFIRST THEN BEGIN
          IF (VendLedgEntry."Pmt. Disc. Rcd.(LCY)" <> 0) AND
             (VendLedgEntry."Journal Batch Name" = '')
          THEN
            MESSAGE(Text006,SELECTSTR(FromDocType - 1,Text007),FromDocNo);
        END;
      END;
    END;

    LOCAL PROCEDURE CheckCopyFromSalesHeaderAvail@89(FromSalesHeader@1000 : Record 36;ToSalesHeader@1001 : Record 36);
    VAR
      FromSalesLine@1002 : Record 37;
      ToSalesLine@1003 : Record 37;
    BEGIN
      WITH ToSalesHeader DO
        IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
          FromSalesLine.SETRANGE("Document Type",FromSalesHeader."Document Type");
          FromSalesLine.SETRANGE("Document No.",FromSalesHeader."No.");
          FromSalesLine.SETRANGE(Type,FromSalesLine.Type::Item);
          FromSalesLine.SETFILTER("No.",'<>%1','');
          IF FromSalesLine.FIND('-') THEN
            REPEAT
              IF FromSalesLine.Quantity > 0 THEN BEGIN
                ToSalesLine."No." := FromSalesLine."No.";
                ToSalesLine."Variant Code" := FromSalesLine."Variant Code";
                ToSalesLine."Location Code" := FromSalesLine."Location Code";
                ToSalesLine."Bin Code" := FromSalesLine."Bin Code";
                ToSalesLine."Unit of Measure Code" := FromSalesLine."Unit of Measure Code";
                ToSalesLine."Qty. per Unit of Measure" := FromSalesLine."Qty. per Unit of Measure";
                ToSalesLine."Outstanding Quantity" := FromSalesLine.Quantity;
                IF "Document Type" = "Document Type"::Order THEN
                  ToSalesLine."Outstanding Quantity" := FromSalesLine.Quantity - FromSalesLine."Qty. to Assemble to Order";
                ToSalesLine."Qty. to Assemble to Order" := 0;
                ToSalesLine."Drop Shipment" := FromSalesLine."Drop Shipment";
                CheckItemAvailability(ToSalesHeader,ToSalesLine);

                IF "Document Type" = "Document Type"::Order THEN BEGIN
                  ToSalesLine."Outstanding Quantity" := FromSalesLine.Quantity;
                  ToSalesLine."Qty. to Assemble to Order" := FromSalesLine."Qty. to Assemble to Order";
                  CheckATOItemAvailable(FromSalesLine,ToSalesLine);
                END;
              END;
            UNTIL FromSalesLine.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE CheckCopyFromSalesShptAvail@91(FromSalesShptHeader@1000 : Record 110;ToSalesHeader@1001 : Record 36);
    VAR
      FromSalesShptLine@1002 : Record 111;
      ToSalesLine@1003 : Record 37;
      FromPostedAsmHeader@1004 : Record 910;
    BEGIN
      IF NOT (ToSalesHeader."Document Type" IN [ToSalesHeader."Document Type"::Order,ToSalesHeader."Document Type"::Invoice]) THEN
        EXIT;

      WITH ToSalesLine DO BEGIN
        FromSalesShptLine.SETRANGE("Document No.",FromSalesShptHeader."No.");
        FromSalesShptLine.SETRANGE(Type,FromSalesShptLine.Type::Item);
        FromSalesShptLine.SETFILTER("No.",'<>%1','');
        IF FromSalesShptLine.FIND('-') THEN
          REPEAT
            IF FromSalesShptLine.Quantity > 0 THEN BEGIN
              "No." := FromSalesShptLine."No.";
              "Variant Code" := FromSalesShptLine."Variant Code";
              "Location Code" := FromSalesShptLine."Location Code";
              "Bin Code" := FromSalesShptLine."Bin Code";
              "Unit of Measure Code" := FromSalesShptLine."Unit of Measure Code";
              "Qty. per Unit of Measure" := FromSalesShptLine."Qty. per Unit of Measure";
              "Outstanding Quantity" := FromSalesShptLine.Quantity;

              IF "Document Type" = "Document Type"::Order THEN
                IF FromSalesShptLine.AsmToShipmentExists(FromPostedAsmHeader) THEN
                  "Outstanding Quantity" := FromSalesShptLine.Quantity - FromPostedAsmHeader.Quantity;
              "Qty. to Assemble to Order" := 0;
              "Drop Shipment" := FromSalesShptLine."Drop Shipment";
              CheckItemAvailability(ToSalesHeader,ToSalesLine);

              IF "Document Type" = "Document Type"::Order THEN
                IF FromSalesShptLine.AsmToShipmentExists(FromPostedAsmHeader) THEN BEGIN
                  "Qty. to Assemble to Order" := FromPostedAsmHeader.Quantity;
                  CheckPostedATOItemAvailable(FromSalesShptLine,ToSalesLine);
                END;
            END;
          UNTIL FromSalesShptLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckCopyFromSalesInvoiceAvail@96(FromSalesInvHeader@1001 : Record 112;ToSalesHeader@1000 : Record 36);
    VAR
      FromSalesInvLine@1002 : Record 113;
      ToSalesLine@1003 : Record 37;
    BEGIN
      IF NOT (ToSalesHeader."Document Type" IN [ToSalesHeader."Document Type"::Order,ToSalesHeader."Document Type"::Invoice]) THEN
        EXIT;

      WITH ToSalesLine DO BEGIN
        FromSalesInvLine.SETRANGE("Document No.",FromSalesInvHeader."No.");
        FromSalesInvLine.SETRANGE(Type,FromSalesInvLine.Type::Item);
        FromSalesInvLine.SETFILTER("No.",'<>%1','');
        FromSalesInvLine.SETRANGE("Prepayment Line",FALSE);
        IF FromSalesInvLine.FIND('-') THEN
          REPEAT
            IF FromSalesInvLine.Quantity > 0 THEN BEGIN
              "No." := FromSalesInvLine."No.";
              "Variant Code" := FromSalesInvLine."Variant Code";
              "Location Code" := FromSalesInvLine."Location Code";
              "Bin Code" := FromSalesInvLine."Bin Code";
              "Unit of Measure Code" := FromSalesInvLine."Unit of Measure Code";
              "Qty. per Unit of Measure" := FromSalesInvLine."Qty. per Unit of Measure";
              "Outstanding Quantity" := FromSalesInvLine.Quantity;
              "Drop Shipment" := FromSalesInvLine."Drop Shipment";
              CheckItemAvailability(ToSalesHeader,ToSalesLine);
            END;
          UNTIL FromSalesInvLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckCopyFromSalesRetRcptAvail@97(FromReturnRcptHeader@1001 : Record 6660;ToSalesHeader@1000 : Record 36);
    VAR
      FromReturnRcptLine@1002 : Record 6661;
      ToSalesLine@1003 : Record 37;
    BEGIN
      IF NOT (ToSalesHeader."Document Type" IN [ToSalesHeader."Document Type"::Order,ToSalesHeader."Document Type"::Invoice]) THEN
        EXIT;

      WITH ToSalesLine DO BEGIN
        FromReturnRcptLine.SETRANGE("Document No.",FromReturnRcptHeader."No.");
        FromReturnRcptLine.SETRANGE(Type,FromReturnRcptLine.Type::Item);
        FromReturnRcptLine.SETFILTER("No.",'<>%1','');
        IF FromReturnRcptLine.FIND('-') THEN
          REPEAT
            IF FromReturnRcptLine.Quantity > 0 THEN BEGIN
              "No." := FromReturnRcptLine."No.";
              "Variant Code" := FromReturnRcptLine."Variant Code";
              "Location Code" := FromReturnRcptLine."Location Code";
              "Bin Code" := FromReturnRcptLine."Bin Code";
              "Unit of Measure Code" := FromReturnRcptLine."Unit of Measure Code";
              "Qty. per Unit of Measure" := FromReturnRcptLine."Qty. per Unit of Measure";
              "Outstanding Quantity" := FromReturnRcptLine.Quantity;
              "Drop Shipment" := FALSE;
              CheckItemAvailability(ToSalesHeader,ToSalesLine);
            END;
          UNTIL FromReturnRcptLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckCopyFromSalesCrMemoAvail@100(FromSalesCrMemoHeader@1000 : Record 114;ToSalesHeader@1001 : Record 36);
    VAR
      FromSalesCrMemoLine@1003 : Record 115;
      ToSalesLine@1002 : Record 37;
    BEGIN
      IF NOT (ToSalesHeader."Document Type" IN [ToSalesHeader."Document Type"::Order,ToSalesHeader."Document Type"::Invoice]) THEN
        EXIT;

      WITH ToSalesLine DO BEGIN
        FromSalesCrMemoLine.SETRANGE("Document No.",FromSalesCrMemoHeader."No.");
        FromSalesCrMemoLine.SETRANGE(Type,FromSalesCrMemoLine.Type::Item);
        FromSalesCrMemoLine.SETFILTER("No.",'<>%1','');
        FromSalesCrMemoLine.SETRANGE("Prepayment Line",FALSE);
        IF FromSalesCrMemoLine.FIND('-') THEN
          REPEAT
            IF FromSalesCrMemoLine.Quantity > 0 THEN BEGIN
              "No." := FromSalesCrMemoLine."No.";
              "Variant Code" := FromSalesCrMemoLine."Variant Code";
              "Location Code" := FromSalesCrMemoLine."Location Code";
              "Bin Code" := FromSalesCrMemoLine."Bin Code";
              "Unit of Measure Code" := FromSalesCrMemoLine."Unit of Measure Code";
              "Qty. per Unit of Measure" := FromSalesCrMemoLine."Qty. per Unit of Measure";
              "Outstanding Quantity" := FromSalesCrMemoLine.Quantity;
              "Drop Shipment" := FALSE;
              CheckItemAvailability(ToSalesHeader,ToSalesLine);
            END;
          UNTIL FromSalesCrMemoLine.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckItemAvailability@5(VAR ToSalesHeader@1001 : Record 36;VAR ToSalesLine@1000 : Record 37);
    BEGIN
      IF HideDialog THEN
        EXIT;

      ToSalesLine."Document Type" := ToSalesHeader."Document Type";
      ToSalesLine."Document No." := ToSalesHeader."No.";
      ToSalesLine.Type := ToSalesLine.Type::Item;
      ToSalesLine."Purchase Order No." := '';
      ToSalesLine."Purch. Order Line No." := 0;
      ToSalesLine."Drop Shipment" :=
        NOT RecalculateLines AND ToSalesLine."Drop Shipment" AND
        (ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::Order);

      IF ToSalesLine."Shipment Date" = 0D THEN BEGIN
        IF ToSalesHeader."Shipment Date" <> 0D THEN
          ToSalesLine.VALIDATE("Shipment Date",ToSalesHeader."Shipment Date")
        ELSE
          ToSalesLine.VALIDATE("Shipment Date",WORKDATE);
      END;

      IF ItemCheckAvail.SalesLineCheck(ToSalesLine) THEN
        ItemCheckAvail.RaiseUpdateInterruptedError;
    END;

    LOCAL PROCEDURE CheckATOItemAvailable@26(VAR FromSalesLine@1001 : Record 37;ToSalesLine@1000 : Record 37);
    VAR
      ATOLink@1002 : Record 904;
      AsmHeader@1005 : Record 900;
      TempAsmHeader@1003 : TEMPORARY Record 900;
      TempAsmLine@1004 : TEMPORARY Record 901;
    BEGIN
      IF HideDialog THEN
        EXIT;

      IF ATOLink.ATOCopyCheckAvailShowWarning(
           AsmHeader,ToSalesLine,TempAsmHeader,TempAsmLine,
           NOT FromSalesLine.AsmToOrderExists(AsmHeader))
      THEN
        IF ItemCheckAvail.ShowAsmWarningYesNo(TempAsmHeader,TempAsmLine) THEN
          ItemCheckAvail.RaiseUpdateInterruptedError;
    END;

    LOCAL PROCEDURE CheckPostedATOItemAvailable@88(VAR FromSalesShptLine@1001 : Record 111;ToSalesLine@1000 : Record 37);
    VAR
      ATOLink@1002 : Record 904;
      PostedAsmHeader@1005 : Record 910;
      TempAsmHeader@1003 : TEMPORARY Record 900;
      TempAsmLine@1004 : TEMPORARY Record 901;
    BEGIN
      IF HideDialog THEN
        EXIT;

      IF ATOLink.PstdATOCopyCheckAvailShowWarn(
           PostedAsmHeader,ToSalesLine,TempAsmHeader,TempAsmLine,
           NOT FromSalesShptLine.AsmToShipmentExists(PostedAsmHeader))
      THEN
        IF ItemCheckAvail.ShowAsmWarningYesNo(TempAsmHeader,TempAsmLine) THEN
          ItemCheckAvail.RaiseUpdateInterruptedError;
    END;

    [External]
    PROCEDURE CopyServContractLines@27(ToServContractHeader@1002 : Record 5965;FromDocType@1000 : Option;FromDocNo@1003 : Code[20];VAR FromServContractLine@1005 : Record 5964) AllLinesCopied : Boolean;
    VAR
      ExistingServContractLine@1001 : Record 5964;
      LineNo@1004 : Integer;
    BEGIN
      IF FromDocNo = '' THEN
        ERROR(Text000);

      ExistingServContractLine.LOCKTABLE;
      ExistingServContractLine.RESET;
      ExistingServContractLine.SETRANGE("Contract Type",ToServContractHeader."Contract Type");
      ExistingServContractLine.SETRANGE("Contract No.",ToServContractHeader."Contract No.");
      IF ExistingServContractLine.FINDLAST THEN
        LineNo := ExistingServContractLine."Line No." + 10000
      ELSE
        LineNo := 10000;

      AllLinesCopied := TRUE;
      FromServContractLine.RESET;
      FromServContractLine.SETRANGE("Contract Type",FromDocType);
      FromServContractLine.SETRANGE("Contract No.",FromDocNo);
      IF FromServContractLine.FIND('-') THEN
        REPEAT
          IF NOT ProcessServContractLine(
               ToServContractHeader,
               FromServContractLine,
               LineNo)
          THEN BEGIN
            AllLinesCopied := FALSE;
            FromServContractLine.MARK(TRUE)
          END ELSE
            LineNo := LineNo + 10000
        UNTIL FromServContractLine.NEXT = 0;
    END;

    [External]
    PROCEDURE ServContractHeaderDocType@28(DocType@1001 : Option) : Integer;
    VAR
      ServContractHeader@1000 : Record 5965;
    BEGIN
      CASE DocType OF
        ServDocType::Quote:
          EXIT(ServContractHeader."Contract Type"::Quote);
        ServDocType::Contract:
          EXIT(ServContractHeader."Contract Type"::Contract);
      END;
    END;

    LOCAL PROCEDURE ProcessServContractLine@29(ToServContractHeader@1003 : Record 5965;VAR FromServContractLine@1000 : Record 5964;LineNo@1005 : Integer) : Boolean;
    VAR
      ToServContractLine@1007 : Record 5964;
      ExistingServContractLine@1006 : Record 5964;
      ServItem@1004 : Record 5940;
    BEGIN
      IF FromServContractLine."Service Item No." <> '' THEN BEGIN
        ServItem.GET(FromServContractLine."Service Item No.");
        IF ServItem."Customer No." <> ToServContractHeader."Customer No." THEN
          EXIT(FALSE);

        ExistingServContractLine.RESET;
        ExistingServContractLine.SETCURRENTKEY("Service Item No.","Contract Status");
        ExistingServContractLine.SETRANGE("Service Item No.",FromServContractLine."Service Item No.");
        ExistingServContractLine.SETRANGE("Contract Type",ToServContractHeader."Contract Type");
        ExistingServContractLine.SETRANGE("Contract No.",ToServContractHeader."Contract No.");
        IF NOT ExistingServContractLine.ISEMPTY THEN
          EXIT(FALSE);
      END;

      ToServContractLine := FromServContractLine;
      ToServContractLine."Last Planned Service Date" := 0D;
      ToServContractLine."Last Service Date" := 0D;
      ToServContractLine."Last Preventive Maint. Date" := 0D;
      ToServContractLine."Invoiced to Date" := 0D;
      ToServContractLine."Contract Type" := ToServContractHeader."Contract Type";
      ToServContractLine."Contract No." := ToServContractHeader."Contract No.";
      ToServContractLine."Line No." := LineNo;
      ToServContractLine."New Line" := TRUE;
      ToServContractLine.Credited := FALSE;
      ToServContractLine.SetupNewLine;
      ToServContractLine.INSERT(TRUE);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CopySalesShptLinesToDoc@39(ToSalesHeader@1002 : Record 36;VAR FromSalesShptLine@1001 : Record 111;VAR LinesNotCopied@1018 : Integer;VAR MissingExCostRevLink@1009 : Boolean);
    VAR
      ItemLedgEntry@1008 : Record 32;
      TempTrkgItemLedgEntry@1017 : TEMPORARY Record 32;
      FromSalesHeader@1006 : Record 36;
      FromSalesLine@1003 : Record 37;
      ToSalesLine@1010 : Record 37;
      FromSalesLineBuf@1007 : TEMPORARY Record 37;
      FromSalesShptHeader@1005 : Record 110;
      TempItemTrkgEntry@1021 : TEMPORARY Record 337;
      TempDocSalesLine@1012 : TEMPORARY Record 37;
      ItemTrackingMgt@1016 : Codeunit 6500;
      OldDocNo@1011 : Code[20];
      NextLineNo@1000 : Integer;
      NextItemTrkgEntryNo@1019 : Integer;
      FromLineCounter@1023 : Integer;
      ToLineCounter@1022 : Integer;
      CopyItemTrkg@1004 : Boolean;
      SplitLine@1020 : Boolean;
      FillExactCostRevLink@1015 : Boolean;
      CopyLine@1024 : Boolean;
      InsertDocNoLine@1025 : Boolean;
    BEGIN
      MissingExCostRevLink := FALSE;
      InitCurrency(ToSalesHeader."Currency Code");
      OpenWindow;

      WITH FromSalesShptLine DO
        IF FINDSET THEN
          REPEAT
            FromLineCounter := FromLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(1,FromLineCounter);
            IF FromSalesShptHeader."No." <> "Document No." THEN BEGIN
              FromSalesShptHeader.GET("Document No.");
              TransferOldExtLines.ClearLineNumbers;
            END;
            FromSalesShptHeader.TESTFIELD("Prices Including VAT",ToSalesHeader."Prices Including VAT");
            FromSalesHeader.TRANSFERFIELDS(FromSalesShptHeader);
            FillExactCostRevLink :=
              IsSalesFillExactCostRevLink(ToSalesHeader,0,FromSalesHeader."Currency Code");
            FromSalesLine.TRANSFERFIELDS(FromSalesShptLine);
            FromSalesLine."Appl.-from Item Entry" := 0;

            IF "Document No." <> OldDocNo THEN BEGIN
              OldDocNo := "Document No.";
              InsertDocNoLine := TRUE;
            END;

            SplitLine := TRUE;
            FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
            IF NOT SplitPstdSalesLinesPerILE(
                 ToSalesHeader,FromSalesHeader,ItemLedgEntry,FromSalesLineBuf,
                 FromSalesLine,TempDocSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,TRUE)
            THEN
              IF CopyItemTrkg THEN
                SplitLine :=
                  SplitSalesDocLinesPerItemTrkg(
                    ItemLedgEntry,TempItemTrkgEntry,FromSalesLineBuf,
                    FromSalesLine,TempDocSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,TRUE)
              ELSE
                SplitLine := FALSE;

            IF NOT SplitLine THEN BEGIN
              FromSalesLineBuf := FromSalesLine;
              CopyLine := TRUE;
            END ELSE
              CopyLine := FromSalesLineBuf.FINDSET AND FillExactCostRevLink;

            Window.UPDATE(1,FromLineCounter);
            IF CopyLine THEN BEGIN
              NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
              AsmHdrExistsForFromDocLine := AsmToShipmentExists(PostedAsmHeader);
              InitAsmCopyHandling(TRUE);
              IF AsmHdrExistsForFromDocLine THEN BEGIN
                QtyToAsmToOrder := Quantity;
                QtyToAsmToOrderBase := "Quantity (Base)";
                GenerateAsmDataFromPosted(PostedAsmHeader,ToSalesHeader."Document Type");
              END;
              IF InsertDocNoLine THEN BEGIN
                InsertOldSalesDocNoLine(ToSalesHeader,"Document No.",1,NextLineNo);
                InsertDocNoLine := FALSE;
              END;
              REPEAT
                ToLineCounter := ToLineCounter + 1;
                IF IsTimeForUpdate THEN
                  Window.UPDATE(2,ToLineCounter);
                IF CopySalesLine(
                     ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLineBuf,NextLineNo,LinesNotCopied,
                     FALSE,DeferralTypeForSalesDoc(SalesDocType::"Posted Shipment"),CopyPostedDeferral,
                     FromSalesLineBuf."Line No.")
                THEN
                  IF CopyItemTrkg THEN BEGIN
                    IF SplitLine THEN
                      ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                        TempItemTrkgEntry,TempTrkgItemLedgEntry,FALSE,FromSalesLineBuf."Document No.",FromSalesLineBuf."Line No.")
                    ELSE
                      ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntry);

                    ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(
                      TempTrkgItemLedgEntry,ToSalesLine,
                      FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                      FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT",TRUE);
                  END;
              UNTIL FromSalesLineBuf.NEXT = 0;
            END;
          UNTIL NEXT = 0;

      Window.CLOSE;
    END;

    [External]
    PROCEDURE CopySalesInvLinesToDoc@34(ToSalesHeader@1002 : Record 36;VAR FromSalesInvLine@1001 : Record 113;VAR LinesNotCopied@1020 : Integer;VAR MissingExCostRevLink@1019 : Boolean);
    VAR
      ItemLedgEntryBuf@1008 : TEMPORARY Record 32;
      FromSalesHeader@1006 : Record 36;
      FromSalesLine@1003 : Record 37;
      FromSalesLine2@1022 : Record 37;
      ToSalesLine@1010 : Record 37;
      FromSalesLineBuf@1007 : TEMPORARY Record 37;
      FromSalesInvHeader@1005 : Record 112;
      TempItemTrkgEntry@1009 : TEMPORARY Record 337;
      TempDocSalesLine@1026 : TEMPORARY Record 37;
      OldInvDocNo@1011 : Code[20];
      OldShptDocNo@1014 : Code[20];
      OldBufDocNo@1037 : Code[20];
      NextLineNo@1000 : Integer;
      SalesCombDocLineNo@1015 : Integer;
      NextItemTrkgEntryNo@1023 : Integer;
      FromLineCounter@1025 : Integer;
      ToLineCounter@1024 : Integer;
      CopyItemTrkg@1004 : Boolean;
      SplitLine@1021 : Boolean;
      FillExactCostRevLink@1013 : Boolean;
      SalesInvLineCount@1040 : Integer;
      SalesLineCount@1041 : Integer;
      BufferCount@1042 : Integer;
      FirstLineShipped@1016 : Boolean;
      FirstLineText@1017 : Boolean;
      ItemChargeAssgntNextLineNo@1027 : Integer;
    BEGIN
      MissingExCostRevLink := FALSE;
      InitCurrency(ToSalesHeader."Currency Code");
      FromSalesLineBuf.RESET;
      FromSalesLineBuf.DELETEALL;
      TempItemTrkgEntry.RESET;
      TempItemTrkgEntry.DELETEALL;
      OpenWindow;
      InitAsmCopyHandling(TRUE);
      TempSalesInvLine.DELETEALL;

      // Fill sales line buffer
      SalesInvLineCount := 0;
      FirstLineText := FALSE;
      WITH FromSalesInvLine DO
        IF FINDSET THEN
          REPEAT
            FromLineCounter := FromLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(1,FromLineCounter);
            SetTempSalesInvLine(FromSalesInvLine,TempSalesInvLine,SalesInvLineCount,NextLineNo,FirstLineText);
            IF FromSalesInvHeader."No." <> "Document No." THEN BEGIN
              FromSalesInvHeader.GET("Document No.");
              TransferOldExtLines.ClearLineNumbers;
            END;
            FromSalesInvHeader.TESTFIELD("Prices Including VAT",ToSalesHeader."Prices Including VAT");
            FromSalesHeader.TRANSFERFIELDS(FromSalesInvHeader);
            FillExactCostRevLink := IsSalesFillExactCostRevLink(ToSalesHeader,1,FromSalesHeader."Currency Code");
            FromSalesLine.TRANSFERFIELDS(FromSalesInvLine);
            FromSalesLine."Appl.-from Item Entry" := 0;
            // Reuse fields to buffer invoice line information
            FromSalesLine."Shipment No." := "Document No.";
            FromSalesLine."Shipment Line No." := 0;
            FromSalesLine."Return Receipt No." := '';
            FromSalesLine."Return Receipt Line No." := "Line No.";

            SplitLine := TRUE;
            GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
            IF NOT SplitPstdSalesLinesPerILE(
                 ToSalesHeader,FromSalesHeader,ItemLedgEntryBuf,FromSalesLineBuf,
                 FromSalesLine,TempDocSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,FALSE)
            THEN
              IF CopyItemTrkg THEN
                SplitLine := SplitSalesDocLinesPerItemTrkg(
                    ItemLedgEntryBuf,TempItemTrkgEntry,FromSalesLineBuf,
                    FromSalesLine,TempDocSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,FALSE)
              ELSE
                SplitLine := FALSE;

            IF NOT SplitLine THEN
              CopySalesLinesToBuffer(
                FromSalesHeader,FromSalesLine,FromSalesLine2,FromSalesLineBuf,
                ToSalesHeader,TempDocSalesLine,"Document No.",NextLineNo);
          UNTIL NEXT = 0;

      // Create sales line from buffer
      Window.UPDATE(1,FromLineCounter);
      BufferCount := 0;
      FirstLineShipped := TRUE;
      WITH FromSalesLineBuf DO BEGIN
        // Sorting according to Sales Line Document No.,Line No.
        SETCURRENTKEY("Document Type","Document No.","Line No.");
        SalesLineCount := 0;
        IF FINDSET THEN
          REPEAT
            IF Type = Type::Item THEN
              SalesLineCount += 1;
          UNTIL NEXT = 0;
        IF FINDSET THEN BEGIN
          NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
          REPEAT
            ToLineCounter := ToLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(2,ToLineCounter);
            IF "Shipment No." <> OldInvDocNo THEN BEGIN
              OldInvDocNo := "Shipment No.";
              OldShptDocNo := '';
              FirstLineShipped := TRUE;
              InsertOldSalesDocNoLine(ToSalesHeader,OldInvDocNo,2,NextLineNo);
            END;
            CheckFirstLineShipped("Document No.","Shipment Line No.",SalesCombDocLineNo,NextLineNo,FirstLineShipped);
            IF ("Document No." <> OldShptDocNo) AND ("Shipment Line No." > 0) THEN BEGIN
              IF FirstLineShipped THEN
                SalesCombDocLineNo := NextLineNo;
              OldShptDocNo := "Document No.";
              InsertOldSalesCombDocNoLine(ToSalesHeader,OldInvDocNo,OldShptDocNo,SalesCombDocLineNo,TRUE);
              NextLineNo := NextLineNo + 10000;
              FirstLineShipped := TRUE;
            END;

            InitFromSalesLine2(FromSalesLine2,FromSalesLineBuf);
            IF GetSalesDocNo(TempDocSalesLine,"Line No.") <> OldBufDocNo THEN BEGIN
              OldBufDocNo := GetSalesDocNo(TempDocSalesLine,"Line No.");
              TransferOldExtLines.ClearLineNumbers;
            END;
            AsmHdrExistsForFromDocLine := FALSE;
            IF Type = Type::Item THEN BEGIN
              BufferCount += 1;
              AsmHdrExistsForFromDocLine := RetrieveSalesInvLine(FromSalesLine2,BufferCount,SalesLineCount = SalesInvLineCount);
              InitAsmCopyHandling(TRUE);
              IF AsmHdrExistsForFromDocLine THEN BEGIN
                AsmHdrExistsForFromDocLine := GetAsmDataFromSalesInvLine(ToSalesHeader."Document Type");
                IF AsmHdrExistsForFromDocLine THEN BEGIN
                  QtyToAsmToOrder := TempSalesInvLine.Quantity;
                  QtyToAsmToOrderBase := TempSalesInvLine.Quantity * TempSalesInvLine."Qty. per Unit of Measure";
                END;
              END;
            END;
            IF CopySalesLine(ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLine2,NextLineNo,LinesNotCopied,
                 "Return Receipt No." = '',DeferralTypeForSalesDoc(SalesDocType::"Posted Invoice"),CopyPostedDeferral,
                 GetSalesLineNo(TempDocSalesLine,FromSalesLine2."Line No."))
            THEN BEGIN
              IF CopyPostedDeferral THEN
                CopySalesPostedDeferrals(ToSalesLine,DeferralUtilities.GetSalesDeferralDocType,
                  DeferralTypeForSalesDoc(SalesDocType::"Posted Invoice"),"Shipment No.","Return Receipt Line No.",
                  ToSalesLine."Document Type",ToSalesLine."Document No.",ToSalesLine."Line No.");
              FromSalesInvLine.GET("Shipment No.","Return Receipt Line No.");

              // copy item charges
              IF Type = Type::"Charge (Item)" THEN BEGIN
                FromSalesLine.TRANSFERFIELDS(FromSalesInvLine);
                FromSalesLine."Document Type" := FromSalesLine."Document Type"::Invoice;
                CopyFromSalesLineItemChargeAssign(FromSalesLine,ToSalesLine,FromSalesHeader,ItemChargeAssgntNextLineNo);
              END;

              // copy item tracking
              IF (Type = Type::Item) AND (Quantity <> 0) AND SalesDocCanReceiveTracking(ToSalesHeader) THEN BEGIN
                FromSalesInvLine."Document No." := OldInvDocNo;
                FromSalesInvLine."Line No." := "Return Receipt Line No.";
                FromSalesInvLine.GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
                IF IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) THEN
                  CopyItemLedgEntryTrackingToSalesLine(
                    ItemLedgEntryBuf,TempItemTrkgEntry,FromSalesLineBuf,ToSalesLine,ToSalesHeader."Prices Including VAT",
                    FromSalesHeader."Prices Including VAT",FillExactCostRevLink,MissingExCostRevLink);
              END;
            END;
          UNTIL NEXT = 0;
        END;
      END;
      Window.CLOSE;
    END;

    [External]
    PROCEDURE CopySalesCrMemoLinesToDoc@31(ToSalesHeader@1002 : Record 36;VAR FromSalesCrMemoLine@1001 : Record 115;VAR LinesNotCopied@1020 : Integer;VAR MissingExCostRevLink@1019 : Boolean);
    VAR
      ItemLedgEntryBuf@1008 : TEMPORARY Record 32;
      TempTrkgItemLedgEntry@1012 : TEMPORARY Record 32;
      FromSalesHeader@1006 : Record 36;
      FromSalesLine@1003 : Record 37;
      FromSalesLine2@1022 : Record 37;
      ToSalesLine@1010 : Record 37;
      FromSalesLineBuf@1007 : TEMPORARY Record 37;
      FromSalesCrMemoHeader@1005 : Record 114;
      TempItemTrkgEntry@1009 : TEMPORARY Record 337;
      TempDocSalesLine@1026 : TEMPORARY Record 37;
      ItemTrackingMgt@1018 : Codeunit 6500;
      OldCrMemoDocNo@1011 : Code[20];
      OldReturnRcptDocNo@1014 : Code[20];
      OldBufDocNo@1016 : Code[20];
      NextLineNo@1000 : Integer;
      NextItemTrkgEntryNo@1023 : Integer;
      FromLineCounter@1025 : Integer;
      ToLineCounter@1024 : Integer;
      ItemChargeAssgntNextLineNo@1015 : Integer;
      CopyItemTrkg@1004 : Boolean;
      SplitLine@1021 : Boolean;
      FillExactCostRevLink@1013 : Boolean;
    BEGIN
      MissingExCostRevLink := FALSE;
      InitCurrency(ToSalesHeader."Currency Code");
      FromSalesLineBuf.RESET;
      FromSalesLineBuf.DELETEALL;
      TempItemTrkgEntry.RESET;
      TempItemTrkgEntry.DELETEALL;
      OpenWindow;

      // Fill sales line buffer
      WITH FromSalesCrMemoLine DO
        IF FINDSET THEN
          REPEAT
            FromLineCounter := FromLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(1,FromLineCounter);
            IF FromSalesCrMemoHeader."No." <> "Document No." THEN BEGIN
              FromSalesCrMemoHeader.GET("Document No.");
              TransferOldExtLines.ClearLineNumbers;
            END;
            FromSalesHeader.TRANSFERFIELDS(FromSalesCrMemoHeader);
            FillExactCostRevLink :=
              IsSalesFillExactCostRevLink(ToSalesHeader,3,FromSalesHeader."Currency Code");
            FromSalesLine.TRANSFERFIELDS(FromSalesCrMemoLine);
            FromSalesLine."Appl.-from Item Entry" := 0;
            // Reuse fields to buffer credit memo line information
            FromSalesLine."Shipment No." := "Document No.";
            FromSalesLine."Shipment Line No." := 0;
            FromSalesLine."Return Receipt No." := '';
            FromSalesLine."Return Receipt Line No." := "Line No.";

            SplitLine := TRUE;
            GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
            IF NOT SplitPstdSalesLinesPerILE(
                 ToSalesHeader,FromSalesHeader,ItemLedgEntryBuf,FromSalesLineBuf,
                 FromSalesLine,TempDocSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,FALSE)
            THEN
              IF CopyItemTrkg THEN
                SplitLine :=
                  SplitSalesDocLinesPerItemTrkg(
                    ItemLedgEntryBuf,TempItemTrkgEntry,FromSalesLineBuf,
                    FromSalesLine,TempDocSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,FALSE)
              ELSE
                SplitLine := FALSE;

            IF NOT SplitLine THEN
              CopySalesLinesToBuffer(
                FromSalesHeader,FromSalesLine,FromSalesLine2,FromSalesLineBuf,
                ToSalesHeader,TempDocSalesLine,"Document No.",NextLineNo);
          UNTIL NEXT = 0;

      // Create sales line from buffer
      Window.UPDATE(1,FromLineCounter);
      WITH FromSalesLineBuf DO BEGIN
        // Sorting according to Sales Line Document No.,Line No.
        SETCURRENTKEY("Document Type","Document No.","Line No.");
        IF FINDSET THEN BEGIN
          NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
          REPEAT
            ToLineCounter := ToLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(2,ToLineCounter);
            IF "Shipment No." <> OldCrMemoDocNo THEN BEGIN
              OldCrMemoDocNo := "Shipment No.";
              OldReturnRcptDocNo := '';
              InsertOldSalesDocNoLine(ToSalesHeader,OldCrMemoDocNo,4,NextLineNo);
            END;
            IF ("Document No." <> OldReturnRcptDocNo) AND ("Shipment Line No." > 0) THEN BEGIN
              OldReturnRcptDocNo := "Document No.";
              InsertOldSalesCombDocNoLine(ToSalesHeader,OldCrMemoDocNo,OldReturnRcptDocNo,NextLineNo,FALSE);
            END;

            // Empty buffer fields
            FromSalesLine2 := FromSalesLineBuf;
            FromSalesLine2."Shipment No." := '';
            FromSalesLine2."Shipment Line No." := 0;
            FromSalesLine2."Return Receipt No." := '';
            FromSalesLine2."Return Receipt Line No." := 0;
            IF GetSalesDocNo(TempDocSalesLine,"Line No.") <> OldBufDocNo THEN BEGIN
              OldBufDocNo := GetSalesDocNo(TempDocSalesLine,"Line No.");
              TransferOldExtLines.ClearLineNumbers;
            END;
            IF CopySalesLine(
                 ToSalesHeader,ToSalesLine,FromSalesHeader,
                 FromSalesLine2,NextLineNo,LinesNotCopied,"Return Receipt No." = '',
                 DeferralTypeForSalesDoc(SalesDocType::"Posted Credit Memo"),CopyPostedDeferral,
                 GetSalesLineNo(TempDocSalesLine,FromSalesLine2."Line No."))
            THEN BEGIN
              IF CopyPostedDeferral THEN
                CopySalesPostedDeferrals(ToSalesLine,DeferralUtilities.GetSalesDeferralDocType,
                  DeferralTypeForSalesDoc(SalesDocType::"Posted Credit Memo"),"Shipment No." ,
                  "Return Receipt Line No.",ToSalesLine."Document Type",ToSalesLine."Document No.",ToSalesLine."Line No.");
              FromSalesCrMemoLine.GET("Shipment No.","Return Receipt Line No.");

              // copy item charges
              IF Type = Type::"Charge (Item)" THEN BEGIN
                FromSalesLine.TRANSFERFIELDS(FromSalesCrMemoLine);
                FromSalesLine."Document Type" := FromSalesLine."Document Type"::"Credit Memo";
                CopyFromSalesLineItemChargeAssign(FromSalesLine,ToSalesLine,FromSalesHeader,ItemChargeAssgntNextLineNo);
              END;
              // copy item tracking
              IF (Type = Type::Item) AND (Quantity <> 0) THEN BEGIN
                FromSalesCrMemoLine."Document No." := OldCrMemoDocNo;
                FromSalesCrMemoLine."Line No." := "Return Receipt Line No.";
                FromSalesCrMemoLine.GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
                IF IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) THEN BEGIN
                  IF MoveNegLines OR NOT ExactCostRevMandatory THEN
                    ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntryBuf)
                  ELSE
                    ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                      TempItemTrkgEntry,TempTrkgItemLedgEntry,FALSE,"Document No.","Line No.");

                  ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(
                    TempTrkgItemLedgEntry,ToSalesLine,
                    FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                    FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT",FALSE);
                END;
              END;
            END;
          UNTIL NEXT = 0;
        END;
      END;

      Window.CLOSE;
    END;

    [External]
    PROCEDURE CopySalesReturnRcptLinesToDoc@40(ToSalesHeader@1002 : Record 36;VAR FromReturnRcptLine@1001 : Record 6661;VAR LinesNotCopied@1018 : Integer;VAR MissingExCostRevLink@1009 : Boolean);
    VAR
      ItemLedgEntry@1008 : Record 32;
      TempTrkgItemLedgEntry@1019 : TEMPORARY Record 32;
      FromSalesHeader@1006 : Record 36;
      FromSalesLine@1003 : Record 37;
      ToSalesLine@1010 : Record 37;
      FromSalesLineBuf@1007 : TEMPORARY Record 37;
      FromReturnRcptHeader@1005 : Record 6660;
      TempItemTrkgEntry@1015 : TEMPORARY Record 337;
      TempDocSalesLine@1013 : TEMPORARY Record 37;
      ItemTrackingMgt@1020 : Codeunit 6500;
      OldDocNo@1011 : Code[20];
      NextLineNo@1000 : Integer;
      NextItemTrkgEntryNo@1021 : Integer;
      FromLineCounter@1023 : Integer;
      ToLineCounter@1022 : Integer;
      CopyItemTrkg@1004 : Boolean;
      SplitLine@1017 : Boolean;
      FillExactCostRevLink@1012 : Boolean;
      CopyLine@1024 : Boolean;
      InsertDocNoLine@1025 : Boolean;
    BEGIN
      MissingExCostRevLink := FALSE;
      InitCurrency(ToSalesHeader."Currency Code");
      OpenWindow;

      WITH FromReturnRcptLine DO
        IF FINDSET THEN
          REPEAT
            FromLineCounter := FromLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(1,FromLineCounter);
            IF FromReturnRcptHeader."No." <> "Document No." THEN BEGIN
              FromReturnRcptHeader.GET("Document No.");
              TransferOldExtLines.ClearLineNumbers;
            END;
            FromSalesHeader.TRANSFERFIELDS(FromReturnRcptHeader);
            FillExactCostRevLink :=
              IsSalesFillExactCostRevLink(ToSalesHeader,2,FromSalesHeader."Currency Code");
            FromSalesLine.TRANSFERFIELDS(FromReturnRcptLine);
            FromSalesLine."Appl.-from Item Entry" := 0;

            IF "Document No." <> OldDocNo THEN BEGIN
              OldDocNo := "Document No.";
              InsertDocNoLine := TRUE;
            END;

            SplitLine := TRUE;
            FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
            IF NOT SplitPstdSalesLinesPerILE(
                 ToSalesHeader,FromSalesHeader,ItemLedgEntry,FromSalesLineBuf,
                 FromSalesLine,TempDocSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,TRUE)
            THEN
              IF CopyItemTrkg THEN
                SplitLine :=
                  SplitSalesDocLinesPerItemTrkg(
                    ItemLedgEntry,TempItemTrkgEntry,FromSalesLineBuf,
                    FromSalesLine,TempDocSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,TRUE)
              ELSE
                SplitLine := FALSE;

            IF NOT SplitLine THEN BEGIN
              FromSalesLineBuf := FromSalesLine;
              CopyLine := TRUE;
            END ELSE
              CopyLine := FromSalesLineBuf.FINDSET AND FillExactCostRevLink;

            Window.UPDATE(1,FromLineCounter);
            IF CopyLine THEN BEGIN
              NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
              IF InsertDocNoLine THEN BEGIN
                InsertOldSalesDocNoLine(ToSalesHeader,"Document No.",3,NextLineNo);
                InsertDocNoLine := FALSE;
              END;
              REPEAT
                ToLineCounter := ToLineCounter + 1;
                IF IsTimeForUpdate THEN
                  Window.UPDATE(2,ToLineCounter);
                IF CopySalesLine(
                     ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLineBuf,NextLineNo,LinesNotCopied,
                     FALSE,DeferralTypeForSalesDoc(SalesDocType::"Posted Return Receipt"),CopyPostedDeferral,
                     FromSalesLineBuf."Line No.")
                THEN
                  IF CopyItemTrkg THEN BEGIN
                    IF SplitLine THEN
                      ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                        TempItemTrkgEntry,TempTrkgItemLedgEntry,FALSE,FromSalesLineBuf."Document No.",FromSalesLineBuf."Line No.")
                    ELSE
                      ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntry);

                    ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(
                      TempTrkgItemLedgEntry,ToSalesLine,
                      FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                      FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT",TRUE);
                  END;
              UNTIL FromSalesLineBuf.NEXT = 0
            END;
          UNTIL NEXT = 0;

      Window.CLOSE;
    END;

    LOCAL PROCEDURE CopySalesLinesToBuffer@144(FromSalesHeader@1003 : Record 36;FromSalesLine@1002 : Record 37;VAR FromSalesLine2@1000 : Record 37;VAR TempSalesLineBuf@1001 : TEMPORARY Record 37;ToSalesHeader@1005 : Record 36;VAR TempDocSalesLine@1007 : TEMPORARY Record 37;DocNo@1006 : Code[20];VAR NextLineNo@1004 : Integer);
    BEGIN
      FromSalesLine2 := TempSalesLineBuf;
      TempSalesLineBuf := FromSalesLine;
      TempSalesLineBuf."Document No." := FromSalesLine2."Document No.";
      TempSalesLineBuf."Shipment Line No." := FromSalesLine2."Shipment Line No.";
      TempSalesLineBuf."Line No." := NextLineNo;
      NextLineNo := NextLineNo + 10000;
      IF NOT IsRecalculateAmount(
           FromSalesHeader."Currency Code",ToSalesHeader."Currency Code",
           FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT")
      THEN
        TempSalesLineBuf."Return Receipt No." := DocNo;
      ReCalcSalesLine(FromSalesHeader,ToSalesHeader,TempSalesLineBuf);
      TempSalesLineBuf.INSERT;
      AddSalesDocLine(TempDocSalesLine,TempSalesLineBuf."Line No.",DocNo,FromSalesLine."Line No.");
    END;

    LOCAL PROCEDURE CopyItemLedgEntryTrackingToSalesLine@198(VAR TempItemLedgEntry@1002 : TEMPORARY Record 32;VAR TempReservationEntry@1011 : TEMPORARY Record 337;TempFromSalesLine@1007 : TEMPORARY Record 37;ToSalesLine@1000 : Record 37;ToSalesPricesInctVAT@1004 : Boolean;FromSalesPricesInctVAT@1005 : Boolean;FillExactCostRevLink@1006 : Boolean;VAR MissingExCostRevLink@1008 : Boolean);
    VAR
      TempTrkgItemLedgEntry@1010 : TEMPORARY Record 32;
      AssemblyHeader@1001 : Record 900;
      ItemTrackingMgt@1003 : Codeunit 6500;
    BEGIN
      IF MoveNegLines OR NOT ExactCostRevMandatory THEN
        ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,TempItemLedgEntry)
      ELSE
        ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
          TempReservationEntry,TempTrkgItemLedgEntry,FALSE,TempFromSalesLine."Document No.",TempFromSalesLine."Line No.");

      IF ToSalesLine.AsmToOrderExists(AssemblyHeader) THEN
        SetTrackingOnAssemblyReservation(AssemblyHeader,TempItemLedgEntry)
      ELSE
        ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(
          TempTrkgItemLedgEntry,ToSalesLine,FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
          FromSalesPricesInctVAT,ToSalesPricesInctVAT,FALSE);
    END;

    LOCAL PROCEDURE SplitPstdSalesLinesPerILE@35(ToSalesHeader@1011 : Record 36;FromSalesHeader@1017 : Record 36;VAR ItemLedgEntry@1003 : Record 32;VAR FromSalesLineBuf@1004 : Record 37;FromSalesLine@1001 : Record 37;VAR TempDocSalesLine@1008 : TEMPORARY Record 37;VAR NextLineNo@1006 : Integer;VAR CopyItemTrkg@1002 : Boolean;VAR MissingExCostRevLink@1005 : Boolean;FillExactCostRevLink@1000 : Boolean;FromShptOrRcpt@1016 : Boolean) : Boolean;
    VAR
      OrgQtyBase@1007 : Decimal;
    BEGIN
      IF FromShptOrRcpt THEN BEGIN
        FromSalesLineBuf.RESET;
        FromSalesLineBuf.DELETEALL;
      END ELSE
        FromSalesLineBuf.INIT;

      CopyItemTrkg := FALSE;

      IF (FromSalesLine.Type <> FromSalesLine.Type::Item) OR (FromSalesLine.Quantity = 0) THEN
        EXIT(FALSE);
      IF IsCopyItemTrkg(ItemLedgEntry,CopyItemTrkg,FillExactCostRevLink) OR
         NOT FillExactCostRevLink OR MoveNegLines OR
         NOT ExactCostRevMandatory
      THEN
        EXIT(FALSE);

      WITH ItemLedgEntry DO BEGIN
        FINDSET;
        IF Quantity >= 0 THEN BEGIN
          FromSalesLineBuf."Document No." := "Document No.";
          IF GetSalesDocType(ItemLedgEntry) IN
             [FromSalesLineBuf."Document Type"::Order,FromSalesLineBuf."Document Type"::"Return Order"]
          THEN
            FromSalesLineBuf."Shipment Line No." := 1;
          EXIT(FALSE);
        END;
        OrgQtyBase := FromSalesLine."Quantity (Base)";
        REPEAT
          IF "Shipped Qty. Not Returned" = 0 THEN
            LinesApplied := TRUE;

          IF "Shipped Qty. Not Returned" < 0 THEN BEGIN
            FromSalesLineBuf := FromSalesLine;

            IF -"Shipped Qty. Not Returned" < ABS(FromSalesLine."Quantity (Base)") THEN BEGIN
              IF FromSalesLine."Quantity (Base)" > 0 THEN
                FromSalesLineBuf."Quantity (Base)" := -"Shipped Qty. Not Returned"
              ELSE
                FromSalesLineBuf."Quantity (Base)" := "Shipped Qty. Not Returned";
              IF FromSalesLineBuf."Qty. per Unit of Measure" = 0 THEN
                FromSalesLineBuf.Quantity := FromSalesLineBuf."Quantity (Base)"
              ELSE
                FromSalesLineBuf.Quantity :=
                  ROUND(FromSalesLineBuf."Quantity (Base)" / FromSalesLineBuf."Qty. per Unit of Measure",0.00001);
            END;
            FromSalesLine."Quantity (Base)" := FromSalesLine."Quantity (Base)" - FromSalesLineBuf."Quantity (Base)";
            FromSalesLine.Quantity := FromSalesLine.Quantity - FromSalesLineBuf.Quantity;
            FromSalesLineBuf."Appl.-from Item Entry" := "Entry No.";
            NextLineNo := NextLineNo + 1;
            FromSalesLineBuf."Line No." := NextLineNo;
            NextLineNo := NextLineNo + 1;
            FromSalesLineBuf."Document No." := "Document No.";
            IF GetSalesDocType(ItemLedgEntry) IN
               [FromSalesLineBuf."Document Type"::Order,FromSalesLineBuf."Document Type"::"Return Order"]
            THEN
              FromSalesLineBuf."Shipment Line No." := 1;

            IF NOT FromShptOrRcpt THEN
              UpdateRevSalesLineAmount(
                FromSalesLineBuf,OrgQtyBase,
                FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT");

            FromSalesLineBuf.INSERT;
            AddSalesDocLine(TempDocSalesLine,FromSalesLineBuf."Line No.","Document No.",FromSalesLine."Line No.");
          END;
        UNTIL (NEXT = 0) OR (FromSalesLine."Quantity (Base)" = 0);

        IF (FromSalesLine."Quantity (Base)" <> 0) AND FillExactCostRevLink THEN
          MissingExCostRevLink := TRUE;
        CheckUnappliedLines(LinesApplied,MissingExCostRevLink);
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE SplitSalesDocLinesPerItemTrkg@57(VAR ItemLedgEntry@1003 : Record 32;VAR TempItemTrkgEntry@1002 : TEMPORARY Record 337;VAR FromSalesLineBuf@1004 : Record 37;FromSalesLine@1001 : Record 37;VAR TempDocSalesLine@1011 : TEMPORARY Record 37;VAR NextLineNo@1009 : Integer;VAR NextItemTrkgEntryNo@1007 : Integer;VAR MissingExCostRevLink@1005 : Boolean;FromShptOrRcpt@1010 : Boolean) : Boolean;
    VAR
      SalesLineBuf@1008 : ARRAY [2] OF TEMPORARY Record 37;
      Tracked@1013 : Boolean;
      ReversibleQtyBase@1000 : Decimal;
      SignFactor@1006 : Integer;
      i@1012 : Integer;
    BEGIN
      IF FromShptOrRcpt THEN BEGIN
        FromSalesLineBuf.RESET;
        FromSalesLineBuf.DELETEALL;
        TempItemTrkgEntry.RESET;
        TempItemTrkgEntry.DELETEALL;
      END ELSE
        FromSalesLineBuf.INIT;

      IF MoveNegLines OR NOT ExactCostRevMandatory THEN
        EXIT(FALSE);

      IF FromSalesLine."Quantity (Base)" < 0 THEN
        SignFactor := -1
      ELSE
        SignFactor := 1;

      WITH ItemLedgEntry DO BEGIN
        SETCURRENTKEY("Document No.","Document Type","Document Line No.");
        FINDSET;
        REPEAT
          SalesLineBuf[1] := FromSalesLine;
          SalesLineBuf[1]."Line No." := NextLineNo;
          SalesLineBuf[1]."Quantity (Base)" := 0;
          SalesLineBuf[1].Quantity := 0;
          SalesLineBuf[1]."Document No." := "Document No.";
          IF GetSalesDocType(ItemLedgEntry) IN
             [SalesLineBuf[1]."Document Type"::Order,SalesLineBuf[1]."Document Type"::"Return Order"]
          THEN
            SalesLineBuf[1]."Shipment Line No." := 1;
          SalesLineBuf[2] := SalesLineBuf[1];
          SalesLineBuf[2]."Line No." := SalesLineBuf[2]."Line No." + 1;

          IF NOT FromShptOrRcpt THEN BEGIN
            SETRANGE("Document No.","Document No.");
            SETRANGE("Document Type","Document Type");
            SETRANGE("Document Line No.","Document Line No.");
          END;
          REPEAT
            i := 1;
            IF NOT Positive THEN
              "Shipped Qty. Not Returned" :=
                "Shipped Qty. Not Returned" -
                CalcDistributedQty(TempItemTrkgEntry,ItemLedgEntry,SalesLineBuf[2]."Line No." + 1);

            IF "Document Type" IN ["Document Type"::"Sales Return Receipt","Document Type"::"Sales Credit Memo"] THEN
              IF "Remaining Quantity" < FromSalesLine."Quantity (Base)" * SignFactor THEN
                ReversibleQtyBase := "Remaining Quantity" * SignFactor
              ELSE
                ReversibleQtyBase := FromSalesLine."Quantity (Base)"
            ELSE
              IF Positive THEN BEGIN
                ReversibleQtyBase := "Remaining Quantity";
                IF ReversibleQtyBase < FromSalesLine."Quantity (Base)" * SignFactor THEN
                  ReversibleQtyBase := ReversibleQtyBase * SignFactor
                ELSE
                  ReversibleQtyBase := FromSalesLine."Quantity (Base)";
              END ELSE
                IF -"Shipped Qty. Not Returned" < FromSalesLine."Quantity (Base)" * SignFactor THEN
                  ReversibleQtyBase := -"Shipped Qty. Not Returned" * SignFactor
                ELSE
                  ReversibleQtyBase := FromSalesLine."Quantity (Base)";

            IF ReversibleQtyBase <> 0 THEN BEGIN
              IF NOT Positive THEN
                IF IsSplitItemLedgEntry(ItemLedgEntry) THEN
                  i := 2;

              SalesLineBuf[i]."Quantity (Base)" := SalesLineBuf[i]."Quantity (Base)" + ReversibleQtyBase;
              IF SalesLineBuf[i]."Qty. per Unit of Measure" = 0 THEN
                SalesLineBuf[i].Quantity := SalesLineBuf[i]."Quantity (Base)"
              ELSE
                SalesLineBuf[i].Quantity :=
                  ROUND(SalesLineBuf[i]."Quantity (Base)" / SalesLineBuf[i]."Qty. per Unit of Measure",0.00001);
              FromSalesLine."Quantity (Base)" := FromSalesLine."Quantity (Base)" - ReversibleQtyBase;
              // Fill buffer with exact cost reversing link
              InsertTempItemTrkgEntry(
                ItemLedgEntry,TempItemTrkgEntry,-ABS(ReversibleQtyBase),
                SalesLineBuf[i]."Line No.",NextItemTrkgEntryNo,TRUE);
              Tracked := TRUE;
            END;
          UNTIL (NEXT = 0) OR (FromSalesLine."Quantity (Base)" = 0);

          FOR i := 1 TO 2 DO
            IF SalesLineBuf[i]."Quantity (Base)" <> 0 THEN BEGIN
              FromSalesLineBuf := SalesLineBuf[i];
              FromSalesLineBuf.INSERT;
              AddSalesDocLine(TempDocSalesLine,FromSalesLineBuf."Line No.","Document No.",FromSalesLine."Line No.");
              NextLineNo := SalesLineBuf[i]."Line No." + 1;
            END;

          IF NOT FromShptOrRcpt THEN BEGIN
            SETRANGE("Document No.");
            SETRANGE("Document Type");
            SETRANGE("Document Line No.");
          END;
        UNTIL (NEXT = 0) OR FromShptOrRcpt;

        IF (FromSalesLine."Quantity (Base)" <> 0) AND NOT Tracked THEN
          MissingExCostRevLink := TRUE;
      END;

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CopyPurchRcptLinesToDoc@53(ToPurchHeader@1002 : Record 38;VAR FromPurchRcptLine@1001 : Record 121;VAR LinesNotCopied@1018 : Integer;VAR MissingExCostRevLink@1009 : Boolean);
    VAR
      ItemLedgEntry@1008 : Record 32;
      TempTrkgItemLedgEntry@1019 : TEMPORARY Record 32;
      FromPurchHeader@1006 : Record 38;
      FromPurchLine@1003 : Record 39;
      OriginalPurchHeader@1026 : Record 38;
      ToPurchLine@1010 : Record 39;
      FromPurchLineBuf@1007 : TEMPORARY Record 39;
      FromPurchRcptHeader@1005 : Record 120;
      TempItemTrkgEntry@1022 : TEMPORARY Record 337;
      TempDocPurchaseLine@1013 : TEMPORARY Record 39;
      ItemTrackingMgt@1020 : Codeunit 6500;
      OldDocNo@1011 : Code[20];
      NextLineNo@1000 : Integer;
      NextItemTrkgEntryNo@1021 : Integer;
      FromLineCounter@1023 : Integer;
      ToLineCounter@1012 : Integer;
      CopyItemTrkg@1004 : Boolean;
      FillExactCostRevLink@1015 : Boolean;
      SplitLine@1017 : Boolean;
      CopyLine@1024 : Boolean;
      InsertDocNoLine@1025 : Boolean;
    BEGIN
      MissingExCostRevLink := FALSE;
      InitCurrency(ToPurchHeader."Currency Code");
      OpenWindow;

      WITH FromPurchRcptLine DO
        IF FINDSET THEN
          REPEAT
            FromLineCounter := FromLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(1,FromLineCounter);
            IF FromPurchRcptHeader."No." <> "Document No." THEN BEGIN
              FromPurchRcptHeader.GET("Document No.");
              IF OriginalPurchHeader.GET(OriginalPurchHeader."Document Type"::Order,FromPurchRcptHeader."Order No.") THEN
                OriginalPurchHeader.TESTFIELD("Prices Including VAT",ToPurchHeader."Prices Including VAT");
              TransferOldExtLines.ClearLineNumbers;
            END;
            FromPurchHeader.TRANSFERFIELDS(FromPurchRcptHeader);
            FillExactCostRevLink :=
              IsPurchFillExactCostRevLink(ToPurchHeader,0,FromPurchHeader."Currency Code");
            FromPurchLine.TRANSFERFIELDS(FromPurchRcptLine);
            FromPurchLine."Appl.-to Item Entry" := 0;

            IF "Document No." <> OldDocNo THEN BEGIN
              OldDocNo := "Document No.";
              InsertDocNoLine := TRUE;
            END;

            SplitLine := TRUE;
            FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
            IF NOT SplitPstdPurchLinesPerILE(
                 ToPurchHeader,FromPurchHeader,ItemLedgEntry,FromPurchLineBuf,
                 FromPurchLine,TempDocPurchaseLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,TRUE)
            THEN
              IF CopyItemTrkg THEN
                SplitLine :=
                  SplitPurchDocLinesPerItemTrkg(
                    ItemLedgEntry,TempItemTrkgEntry,FromPurchLineBuf,
                    FromPurchLine,TempDocPurchaseLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,TRUE)
              ELSE
                SplitLine := FALSE;

            IF NOT SplitLine THEN BEGIN
              FromPurchLineBuf := FromPurchLine;
              CopyLine := TRUE;
            END ELSE
              CopyLine := FromPurchLineBuf.FINDSET AND FillExactCostRevLink;

            Window.UPDATE(1,FromLineCounter);
            IF CopyLine THEN BEGIN
              NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
              IF InsertDocNoLine THEN BEGIN
                InsertOldPurchDocNoLine(ToPurchHeader,"Document No.",1,NextLineNo);
                InsertDocNoLine := FALSE;
              END;
              REPEAT
                ToLineCounter := ToLineCounter + 1;
                IF IsTimeForUpdate THEN
                  Window.UPDATE(2,ToLineCounter);
                IF FromPurchLine."Prod. Order No." <> '' THEN
                  FromPurchLine."Quantity (Base)" := 0;
                IF CopyPurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLineBuf,NextLineNo,LinesNotCopied,
                     FALSE,DeferralTypeForPurchDoc(PurchDocType::"Posted Receipt"),CopyPostedDeferral,FromPurchLineBuf."Line No.")
                THEN
                  IF CopyItemTrkg THEN BEGIN
                    IF SplitLine THEN
                      ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                        TempItemTrkgEntry,TempTrkgItemLedgEntry,TRUE,FromPurchLineBuf."Document No.",FromPurchLineBuf."Line No.")
                    ELSE
                      ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntry);

                    ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
                      TempTrkgItemLedgEntry,ToPurchLine,
                      FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                      FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT",TRUE);
                  END;
              UNTIL FromPurchLineBuf.NEXT = 0
            END;
          UNTIL NEXT = 0;

      Window.CLOSE;
    END;

    [External]
    PROCEDURE CopyPurchInvLinesToDoc@52(ToPurchHeader@1002 : Record 38;VAR FromPurchInvLine@1001 : Record 123;VAR LinesNotCopied@1020 : Integer;VAR MissingExCostRevLink@1019 : Boolean);
    VAR
      ItemLedgEntryBuf@1018 : TEMPORARY Record 32;
      TempTrkgItemLedgEntry@1012 : TEMPORARY Record 32;
      FromPurchHeader@1006 : Record 38;
      FromPurchLine@1003 : Record 39;
      FromPurchLine2@1022 : Record 39;
      ToPurchLine@1010 : Record 39;
      FromPurchLineBuf@1007 : TEMPORARY Record 39;
      FromPurchInvHeader@1005 : Record 122;
      TempItemTrkgEntry@1009 : TEMPORARY Record 337;
      TempDocPurchaseLine@1015 : TEMPORARY Record 39;
      ItemTrackingMgt@1021 : Codeunit 6500;
      OldInvDocNo@1011 : Code[20];
      OldRcptDocNo@1023 : Code[20];
      OldBufDocNo@1016 : Code[20];
      NextLineNo@1000 : Integer;
      NextItemTrkgEntryNo@1024 : Integer;
      FromLineCounter@1025 : Integer;
      ToLineCounter@1013 : Integer;
      CopyItemTrkg@1004 : Boolean;
      SplitLine@1008 : Boolean;
      FillExactCostRevLink@1014 : Boolean;
      ItemChargeAssgntNextLineNo@1017 : Integer;
    BEGIN
      MissingExCostRevLink := FALSE;
      InitCurrency(ToPurchHeader."Currency Code");
      FromPurchLineBuf.RESET;
      FromPurchLineBuf.DELETEALL;
      TempItemTrkgEntry.RESET;
      TempItemTrkgEntry.DELETEALL;
      OpenWindow;
      // Fill purchase line buffer
      WITH FromPurchInvLine DO
        IF FINDSET THEN
          REPEAT
            FromLineCounter := FromLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(1,FromLineCounter);
            IF FromPurchInvHeader."No." <> "Document No." THEN BEGIN
              FromPurchInvHeader.GET("Document No.");
              FromPurchInvHeader.TESTFIELD("Prices Including VAT",ToPurchHeader."Prices Including VAT");
              TransferOldExtLines.ClearLineNumbers;
            END;
            FromPurchHeader.TRANSFERFIELDS(FromPurchInvHeader);
            FillExactCostRevLink := IsPurchFillExactCostRevLink(ToPurchHeader,1,FromPurchHeader."Currency Code");
            FromPurchLine.TRANSFERFIELDS(FromPurchInvLine);
            FromPurchLine."Appl.-to Item Entry" := 0;
            // Reuse fields to buffer invoice line information
            FromPurchLine."Receipt No." := "Document No.";
            FromPurchLine."Receipt Line No." := 0;
            FromPurchLine."Return Shipment No." := '';
            FromPurchLine."Return Shipment Line No." := "Line No.";

            SplitLine := TRUE;
            GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
            IF NOT SplitPstdPurchLinesPerILE(
                 ToPurchHeader,FromPurchHeader,ItemLedgEntryBuf,FromPurchLineBuf,
                 FromPurchLine,TempDocPurchaseLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,FALSE)
            THEN
              IF CopyItemTrkg THEN
                SplitLine := SplitPurchDocLinesPerItemTrkg(
                    ItemLedgEntryBuf,TempItemTrkgEntry,FromPurchLineBuf,
                    FromPurchLine,TempDocPurchaseLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,FALSE)
              ELSE
                SplitLine := FALSE;

            IF NOT SplitLine THEN
              CopyPurchLinesToBuffer(
                FromPurchHeader,FromPurchLine,FromPurchLine2,FromPurchLineBuf,ToPurchHeader,TempDocPurchaseLine,
                "Document No.",NextLineNo);
          UNTIL NEXT = 0;

      // Create purchase line from buffer
      Window.UPDATE(1,FromLineCounter);
      WITH FromPurchLineBuf DO BEGIN
        // Sorting according to Purchase Line Document No.,Line No.
        SETCURRENTKEY("Document Type","Document No.","Line No.");
        IF FINDSET THEN BEGIN
          NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
          REPEAT
            ToLineCounter := ToLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(2,ToLineCounter);
            IF "Receipt No." <> OldInvDocNo THEN BEGIN
              OldInvDocNo := "Receipt No.";
              OldRcptDocNo := '';
              InsertOldPurchDocNoLine(ToPurchHeader,OldInvDocNo,2,NextLineNo);
            END;
            IF ("Document No." <> OldRcptDocNo) AND ("Receipt Line No." > 0) THEN BEGIN
              OldRcptDocNo := "Document No.";
              InsertOldPurchCombDocNoLine(ToPurchHeader,OldInvDocNo,OldRcptDocNo,NextLineNo,TRUE);
            END;

            // Empty buffer fields
            FromPurchLine2 := FromPurchLineBuf;
            FromPurchLine2."Receipt No." := '';
            FromPurchLine2."Receipt Line No." := 0;
            FromPurchLine2."Return Shipment No." := '';
            FromPurchLine2."Return Shipment Line No." := 0;
            IF GetPurchDocNo(TempDocPurchaseLine,"Line No.") <> OldBufDocNo THEN BEGIN
              OldBufDocNo := GetPurchDocNo(TempDocPurchaseLine,"Line No.");
              TransferOldExtLines.ClearLineNumbers;
            END;
            IF CopyPurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLine2,NextLineNo,LinesNotCopied,
                 "Return Shipment No." = '',DeferralTypeForPurchDoc(PurchDocType::"Posted Invoice"),CopyPostedDeferral,
                 GetPurchLineNo(TempDocPurchaseLine,FromPurchLine2."Line No."))
            THEN BEGIN
              IF CopyPostedDeferral THEN
                CopyPurchPostedDeferrals(ToPurchLine,DeferralUtilities.GetPurchDeferralDocType,
                  DeferralTypeForPurchDoc(PurchDocType::"Posted Invoice"),"Receipt No.",
                  "Return Shipment Line No.",ToPurchLine."Document Type",ToPurchLine."Document No.",ToPurchLine."Line No.");
              FromPurchInvLine.GET("Receipt No.","Return Shipment Line No.");

              // copy item charges
              IF Type = Type::"Charge (Item)" THEN BEGIN
                FromPurchLine.TRANSFERFIELDS(FromPurchInvLine);
                FromPurchLine."Document Type" := FromPurchLine."Document Type"::Invoice;
                CopyFromPurchLineItemChargeAssign(FromPurchLine,ToPurchLine,FromPurchHeader,ItemChargeAssgntNextLineNo);
              END;
              // copy item tracking
              IF (Type = Type::Item) AND (Quantity <> 0) AND ("Prod. Order No." = '') AND
                 PurchaseDocCanReceiveTracking(ToPurchHeader)
              THEN BEGIN
                FromPurchInvLine."Document No." := OldInvDocNo;
                FromPurchInvLine."Line No." := "Return Shipment Line No.";
                FromPurchInvLine.GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
                IF IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) THEN BEGIN
                  IF "Job No." <> '' THEN
                    ItemLedgEntryBuf.SETFILTER("Entry Type",'<> %1',ItemLedgEntryBuf."Entry Type"::"Negative Adjmt.");
                  IF MoveNegLines OR NOT ExactCostRevMandatory THEN
                    ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntryBuf)
                  ELSE
                    ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                      TempItemTrkgEntry,TempTrkgItemLedgEntry,TRUE,"Document No.","Line No.");

                  ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(TempTrkgItemLedgEntry,ToPurchLine,
                    FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                    FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT",FALSE);
                END;
              END;
            END;
          UNTIL NEXT = 0;
        END;
      END;

      Window.CLOSE;
    END;

    [External]
    PROCEDURE CopyPurchCrMemoLinesToDoc@51(ToPurchHeader@1002 : Record 38;VAR FromPurchCrMemoLine@1001 : Record 125;VAR LinesNotCopied@1020 : Integer;VAR MissingExCostRevLink@1019 : Boolean);
    VAR
      ItemLedgEntryBuf@1008 : TEMPORARY Record 32;
      TempTrkgItemLedgEntry@1018 : TEMPORARY Record 32;
      FromPurchHeader@1006 : Record 38;
      FromPurchLine@1003 : Record 39;
      FromPurchLine2@1022 : Record 39;
      ToPurchLine@1010 : Record 39;
      FromPurchLineBuf@1007 : TEMPORARY Record 39;
      FromPurchCrMemoHeader@1005 : Record 124;
      TempItemTrkgEntry@1021 : TEMPORARY Record 337;
      TempDocPurchaseLine@1026 : TEMPORARY Record 39;
      ItemTrackingMgt@1009 : Codeunit 6500;
      OldCrMemoDocNo@1011 : Code[20];
      OldReturnShptDocNo@1023 : Code[20];
      OldBufDocNo@1016 : Code[20];
      NextLineNo@1000 : Integer;
      NextItemTrkgEntryNo@1024 : Integer;
      FromLineCounter@1025 : Integer;
      ToLineCounter@1013 : Integer;
      ItemChargeAssgntNextLineNo@1015 : Integer;
      CopyItemTrkg@1004 : Boolean;
      SplitLine@1012 : Boolean;
      FillExactCostRevLink@1014 : Boolean;
    BEGIN
      MissingExCostRevLink := FALSE;
      InitCurrency(ToPurchHeader."Currency Code");
      FromPurchLineBuf.RESET;
      FromPurchLineBuf.DELETEALL;
      TempItemTrkgEntry.RESET;
      TempItemTrkgEntry.DELETEALL;
      OpenWindow;

      // Fill purchase line buffer
      WITH FromPurchCrMemoLine DO
        IF FINDSET THEN
          REPEAT
            FromLineCounter := FromLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(1,FromLineCounter);
            IF FromPurchCrMemoHeader."No." <> "Document No." THEN BEGIN
              FromPurchCrMemoHeader.GET("Document No.");
              FromPurchCrMemoHeader.TESTFIELD("Prices Including VAT",ToPurchHeader."Prices Including VAT");
              TransferOldExtLines.ClearLineNumbers;
            END;
            FromPurchHeader.TRANSFERFIELDS(FromPurchCrMemoHeader);
            FillExactCostRevLink :=
              IsPurchFillExactCostRevLink(ToPurchHeader,3,FromPurchHeader."Currency Code");
            FromPurchLine.TRANSFERFIELDS(FromPurchCrMemoLine);
            FromPurchLine."Appl.-to Item Entry" := 0;
            // Reuse fields to buffer credit memo line information
            FromPurchLine."Receipt No." := "Document No.";
            FromPurchLine."Receipt Line No." := 0;
            FromPurchLine."Return Shipment No." := '';
            FromPurchLine."Return Shipment Line No." := "Line No.";

            SplitLine := TRUE;
            GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
            IF NOT SplitPstdPurchLinesPerILE(
                 ToPurchHeader,FromPurchHeader,ItemLedgEntryBuf,FromPurchLineBuf,
                 FromPurchLine,TempDocPurchaseLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,FALSE)
            THEN
              IF CopyItemTrkg THEN
                SplitLine :=
                  SplitPurchDocLinesPerItemTrkg(
                    ItemLedgEntryBuf,TempItemTrkgEntry,FromPurchLineBuf,
                    FromPurchLine,TempDocPurchaseLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,FALSE)
              ELSE
                SplitLine := FALSE;

            IF NOT SplitLine THEN
              CopyPurchLinesToBuffer(
                FromPurchHeader,FromPurchLine,FromPurchLine2,FromPurchLineBuf,ToPurchHeader,TempDocPurchaseLine,
                "Document No.",NextLineNo);
          UNTIL NEXT = 0;

      // Create purchase line from buffer
      Window.UPDATE(1,FromLineCounter);
      WITH FromPurchLineBuf DO BEGIN
        // Sorting according to Purchase Line Document No.,Line No.
        SETCURRENTKEY("Document Type","Document No.","Line No.");
        IF FINDSET THEN BEGIN
          NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
          REPEAT
            ToLineCounter := ToLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(2,ToLineCounter);
            IF "Receipt No." <> OldCrMemoDocNo THEN BEGIN
              OldCrMemoDocNo := "Receipt No.";
              OldReturnShptDocNo := '';
              InsertOldPurchDocNoLine(ToPurchHeader,OldCrMemoDocNo,4,NextLineNo);
            END;
            IF "Document No." <> OldReturnShptDocNo THEN BEGIN
              OldReturnShptDocNo := "Document No.";
              InsertOldPurchCombDocNoLine(ToPurchHeader,OldCrMemoDocNo,OldReturnShptDocNo,NextLineNo,FALSE);
            END;

            // Empty buffer fields
            FromPurchLine2 := FromPurchLineBuf;
            FromPurchLine2."Receipt No." := '';
            FromPurchLine2."Receipt Line No." := 0;
            FromPurchLine2."Return Shipment No." := '';
            FromPurchLine2."Return Shipment Line No." := 0;
            IF GetPurchDocNo(TempDocPurchaseLine,"Line No.") <> OldBufDocNo THEN BEGIN
              OldBufDocNo := GetPurchDocNo(TempDocPurchaseLine,"Line No.");
              TransferOldExtLines.ClearLineNumbers;
            END;
            IF CopyPurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLine2,NextLineNo,LinesNotCopied,
                 "Return Shipment No." = '',DeferralTypeForPurchDoc(PurchDocType::"Posted Credit Memo"),CopyPostedDeferral,
                 GetPurchLineNo(TempDocPurchaseLine,FromPurchLine2."Line No."))
            THEN BEGIN
              IF CopyPostedDeferral THEN
                CopyPurchPostedDeferrals(ToPurchLine,DeferralUtilities.GetPurchDeferralDocType,
                  DeferralTypeForPurchDoc(PurchDocType::"Posted Credit Memo"),"Receipt No.",
                  "Return Shipment Line No.",ToPurchLine."Document Type",ToPurchLine."Document No.",ToPurchLine."Line No.");
              FromPurchCrMemoLine.GET("Receipt No.","Return Shipment Line No.");

              // copy item charges
              IF Type = Type::"Charge (Item)" THEN BEGIN
                FromPurchLine.TRANSFERFIELDS(FromPurchCrMemoLine);
                FromPurchLine."Document Type" := FromPurchLine."Document Type"::"Credit Memo";
                CopyFromPurchLineItemChargeAssign(FromPurchLine,ToPurchLine,FromPurchHeader,ItemChargeAssgntNextLineNo);
              END;
              // copy item tracking
              IF (Type = Type::Item) AND (Quantity <> 0) AND ("Prod. Order No." = '') THEN BEGIN
                FromPurchCrMemoLine."Document No." := OldCrMemoDocNo;
                FromPurchCrMemoLine."Line No." := "Return Shipment Line No.";
                FromPurchCrMemoLine.GetItemLedgEntries(ItemLedgEntryBuf,TRUE);
                IF IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) THEN BEGIN
                  IF "Job No." <> '' THEN
                    ItemLedgEntryBuf.SETFILTER("Entry Type",'<> %1',ItemLedgEntryBuf."Entry Type"::"Negative Adjmt.");
                  IF MoveNegLines OR NOT ExactCostRevMandatory THEN
                    ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntryBuf)
                  ELSE
                    ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                      TempItemTrkgEntry,TempTrkgItemLedgEntry,TRUE,"Document No.","Line No.");

                  ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
                    TempTrkgItemLedgEntry,ToPurchLine,
                    FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                    FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT",FALSE);
                END;
              END;
            END;
          UNTIL NEXT = 0;
        END;
      END;

      Window.CLOSE;
    END;

    [External]
    PROCEDURE CopyPurchReturnShptLinesToDoc@50(ToPurchHeader@1002 : Record 38;VAR FromReturnShptLine@1001 : Record 6651;VAR LinesNotCopied@1018 : Integer;VAR MissingExCostRevLink@1009 : Boolean);
    VAR
      ItemLedgEntry@1008 : Record 32;
      TempTrkgItemLedgEntry@1020 : TEMPORARY Record 32;
      FromPurchHeader@1006 : Record 38;
      FromPurchLine@1003 : Record 39;
      OriginalPurchHeader@1026 : Record 38;
      ToPurchLine@1010 : Record 39;
      FromPurchLineBuf@1007 : TEMPORARY Record 39;
      FromReturnShptHeader@1005 : Record 6650;
      TempItemTrkgEntry@1022 : TEMPORARY Record 337;
      TempDocPurchaseLine@1013 : TEMPORARY Record 39;
      ItemTrackingMgt@1019 : Codeunit 6500;
      OldDocNo@1011 : Code[20];
      NextLineNo@1000 : Integer;
      NextItemTrkgEntryNo@1021 : Integer;
      FromLineCounter@1023 : Integer;
      ToLineCounter@1012 : Integer;
      CopyItemTrkg@1004 : Boolean;
      SplitLine@1017 : Boolean;
      FillExactCostRevLink@1015 : Boolean;
      CopyLine@1025 : Boolean;
      InsertDocNoLine@1024 : Boolean;
    BEGIN
      MissingExCostRevLink := FALSE;
      InitCurrency(ToPurchHeader."Currency Code");
      OpenWindow;

      WITH FromReturnShptLine DO
        IF FINDSET THEN
          REPEAT
            FromLineCounter := FromLineCounter + 1;
            IF IsTimeForUpdate THEN
              Window.UPDATE(1,FromLineCounter);
            IF FromReturnShptHeader."No." <> "Document No." THEN BEGIN
              FromReturnShptHeader.GET("Document No.");
              IF OriginalPurchHeader.GET(OriginalPurchHeader."Document Type"::"Return Order",FromReturnShptHeader."Return Order No.") THEN
                OriginalPurchHeader.TESTFIELD("Prices Including VAT",ToPurchHeader."Prices Including VAT");
              TransferOldExtLines.ClearLineNumbers;
            END;
            FromPurchHeader.TRANSFERFIELDS(FromReturnShptHeader);
            FillExactCostRevLink :=
              IsPurchFillExactCostRevLink(ToPurchHeader,2,FromPurchHeader."Currency Code");
            FromPurchLine.TRANSFERFIELDS(FromReturnShptLine);
            FromPurchLine."Appl.-to Item Entry" := 0;

            IF "Document No." <> OldDocNo THEN BEGIN
              OldDocNo := "Document No.";
              InsertDocNoLine := TRUE;
            END;

            SplitLine := TRUE;
            FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
            IF NOT SplitPstdPurchLinesPerILE(
                 ToPurchHeader,FromPurchHeader,ItemLedgEntry,FromPurchLineBuf,
                 FromPurchLine,TempDocPurchaseLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,TRUE)
            THEN
              IF CopyItemTrkg THEN
                SplitLine :=
                  SplitPurchDocLinesPerItemTrkg(
                    ItemLedgEntry,TempItemTrkgEntry,FromPurchLineBuf,
                    FromPurchLine,TempDocPurchaseLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,TRUE)
              ELSE
                SplitLine := FALSE;

            IF NOT SplitLine THEN BEGIN
              FromPurchLineBuf := FromPurchLine;
              CopyLine := TRUE;
            END ELSE
              CopyLine := FromPurchLineBuf.FINDSET AND FillExactCostRevLink;

            Window.UPDATE(1,FromLineCounter);
            IF CopyLine THEN BEGIN
              NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
              IF InsertDocNoLine THEN BEGIN
                InsertOldPurchDocNoLine(ToPurchHeader,"Document No.",3,NextLineNo);
                InsertDocNoLine := FALSE;
              END;
              REPEAT
                ToLineCounter := ToLineCounter + 1;
                IF IsTimeForUpdate THEN
                  Window.UPDATE(2,ToLineCounter);
                IF CopyPurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLineBuf,NextLineNo,LinesNotCopied,
                     FALSE,DeferralTypeForPurchDoc(PurchDocType::"Posted Return Shipment"),CopyPostedDeferral,
                     FromPurchLineBuf."Line No.")
                THEN
                  IF CopyItemTrkg THEN BEGIN
                    IF SplitLine THEN
                      ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                        TempItemTrkgEntry,TempTrkgItemLedgEntry,TRUE,FromPurchLineBuf."Document No.",FromPurchLineBuf."Line No.")
                    ELSE
                      ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntry);

                    ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
                      TempTrkgItemLedgEntry,ToPurchLine,
                      FillExactCostRevLink AND ExactCostRevMandatory,MissingExCostRevLink,
                      FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT",TRUE);
                  END;
              UNTIL FromPurchLineBuf.NEXT = 0
            END;
          UNTIL NEXT = 0;

      Window.CLOSE;
    END;

    LOCAL PROCEDURE CopyPurchLinesToBuffer@145(FromPurchHeader@1006 : Record 38;FromPurchLine@1005 : Record 39;VAR FromPurchLine2@1004 : Record 39;VAR TempPurchLineBuf@1003 : TEMPORARY Record 39;ToPurchHeader@1002 : Record 38;VAR TempDocPurchaseLine@1007 : TEMPORARY Record 39;DocNo@1001 : Code[20];VAR NextLineNo@1000 : Integer);
    BEGIN
      FromPurchLine2 := TempPurchLineBuf;
      TempPurchLineBuf := FromPurchLine;
      TempPurchLineBuf."Document No." := FromPurchLine2."Document No.";
      TempPurchLineBuf."Receipt Line No." := FromPurchLine2."Receipt Line No.";
      TempPurchLineBuf."Line No." := NextLineNo;
      NextLineNo := NextLineNo + 10000;
      IF NOT IsRecalculateAmount(
           FromPurchHeader."Currency Code",ToPurchHeader."Currency Code",
           FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT")
      THEN
        TempPurchLineBuf."Return Shipment No." := DocNo;
      ReCalcPurchLine(FromPurchHeader,ToPurchHeader,TempPurchLineBuf);
      TempPurchLineBuf.INSERT;
      AddPurchDocLine(TempDocPurchaseLine,TempPurchLineBuf."Line No.",DocNo,FromPurchLine."Line No.");
    END;

    LOCAL PROCEDURE CreateJobPlanningLine@155(SalesHeader@1004 : Record 36;SalesLine@1005 : Record 37;JobContractEntryNo@1000 : Integer) : Integer;
    VAR
      JobPlanningLine@1001 : Record 1003;
      NewJobPlanningLine@1002 : Record 1003;
      JobPlanningLineInvoice@1003 : Record 1022;
    BEGIN
      JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
      JobPlanningLine.SETRANGE("Job Contract Entry No.",JobContractEntryNo);
      IF JobPlanningLine.FINDFIRST THEN BEGIN
        NewJobPlanningLine.InitFromJobPlanningLine(JobPlanningLine,SalesLine.Quantity);

        JobPlanningLineInvoice.InitFromJobPlanningLine(NewJobPlanningLine);
        JobPlanningLineInvoice.InitFromSales(SalesHeader,SalesHeader."Posting Date",SalesLine."Line No.");
        JobPlanningLineInvoice.INSERT;

        NewJobPlanningLine.UpdateQtyToTransfer;
        NewJobPlanningLine.INSERT;
      END;

      EXIT(NewJobPlanningLine."Job Contract Entry No.");
    END;

    LOCAL PROCEDURE SplitPstdPurchLinesPerILE@55(ToPurchHeader@1008 : Record 38;FromPurchHeader@1009 : Record 38;VAR ItemLedgEntry@1003 : Record 32;VAR FromPurchLineBuf@1004 : Record 39;FromPurchLine@1001 : Record 39;VAR TempDocPurchaseLine@1011 : TEMPORARY Record 39;VAR NextLineNo@1006 : Integer;VAR CopyItemTrkg@1002 : Boolean;VAR MissingExCostRevLink@1005 : Boolean;FillExactCostRevLink@1000 : Boolean;FromShptOrRcpt@1010 : Boolean) : Boolean;
    VAR
      Item@1012 : Record 27;
      ApplyRec@1019 : Record 339;
      OrgQtyBase@1007 : Decimal;
    BEGIN
      IF FromShptOrRcpt THEN BEGIN
        FromPurchLineBuf.RESET;
        FromPurchLineBuf.DELETEALL;
      END ELSE
        FromPurchLineBuf.INIT;

      CopyItemTrkg := FALSE;

      IF (FromPurchLine.Type <> FromPurchLine.Type::Item) OR (FromPurchLine.Quantity = 0) OR (FromPurchLine."Prod. Order No." <> '')
      THEN
        EXIT(FALSE);

      Item.GET(FromPurchLine."No.");
      IF Item.Type = Item.Type::Service THEN
        EXIT(FALSE);

      IF IsCopyItemTrkg(ItemLedgEntry,CopyItemTrkg,FillExactCostRevLink) OR
         NOT FillExactCostRevLink OR MoveNegLines OR
         NOT ExactCostRevMandatory
      THEN
        EXIT(FALSE);

      IF FromPurchLine."Job No." <> '' THEN
        EXIT(FALSE);

      WITH ItemLedgEntry DO BEGIN
        FINDSET;
        IF Quantity <= 0 THEN BEGIN
          FromPurchLineBuf."Document No." := "Document No.";
          IF GetPurchDocType(ItemLedgEntry) IN
             [FromPurchLineBuf."Document Type"::Order,FromPurchLineBuf."Document Type"::"Return Order"]
          THEN
            FromPurchLineBuf."Receipt Line No." := 1;
          EXIT(FALSE);
        END;
        OrgQtyBase := FromPurchLine."Quantity (Base)";
        REPEAT
          IF NOT ApplyFully THEN BEGIN
            ApplyRec.AppliedOutbndEntryExists("Entry No.",FALSE,FALSE);
            IF ApplyRec.FIND('-') THEN
              SkippedLine := SkippedLine OR ApplyRec.FIND('-');
          END;
          IF ApplyFully THEN BEGIN
            ApplyRec.AppliedOutbndEntryExists("Entry No.",FALSE,FALSE);
            IF ApplyRec.FIND('-') THEN
              REPEAT
                SomeAreFixed := SomeAreFixed OR ApplyRec.Fixed;
              UNTIL ApplyRec.NEXT = 0;
          END;

          IF AskApply AND ("Item Tracking" = "Item Tracking"::None) THEN
            IF NOT ("Remaining Quantity" > 0) OR ("Item Tracking" <> "Item Tracking"::None) THEN
              ConfirmApply;
          IF AskApply THEN
            IF "Remaining Quantity" < ABS(FromPurchLine."Quantity (Base)") THEN
              ConfirmApply;
          IF ("Remaining Quantity" > 0) OR ApplyFully THEN BEGIN
            FromPurchLineBuf := FromPurchLine;
            IF "Remaining Quantity" < ABS(FromPurchLine."Quantity (Base)") THEN
              IF NOT ApplyFully THEN BEGIN
                IF FromPurchLine."Quantity (Base)" > 0 THEN
                  FromPurchLineBuf."Quantity (Base)" := "Remaining Quantity"
                ELSE
                  FromPurchLineBuf."Quantity (Base)" := -"Remaining Quantity";
                ConvertFromBase(
                  FromPurchLineBuf.Quantity,FromPurchLineBuf."Quantity (Base)",FromPurchLineBuf."Qty. per Unit of Measure");
              END ELSE BEGIN
                ReappDone := TRUE;
                FromPurchLineBuf."Quantity (Base)" := Sign(Quantity) * Quantity - ApplyRec.Returned("Entry No.");
                ConvertFromBase(
                  FromPurchLineBuf.Quantity,FromPurchLineBuf."Quantity (Base)",FromPurchLineBuf."Qty. per Unit of Measure");
              END;
            FromPurchLine."Quantity (Base)" := FromPurchLine."Quantity (Base)" - FromPurchLineBuf."Quantity (Base)";
            FromPurchLine.Quantity := FromPurchLine.Quantity - FromPurchLineBuf.Quantity;
            FromPurchLineBuf."Appl.-to Item Entry" := "Entry No.";
            FromPurchLineBuf."Line No." := NextLineNo;
            NextLineNo := NextLineNo + 1;
            FromPurchLineBuf."Document No." := "Document No.";
            IF GetPurchDocType(ItemLedgEntry) IN
               [FromPurchLineBuf."Document Type"::Order,FromPurchLineBuf."Document Type"::"Return Order"]
            THEN
              FromPurchLineBuf."Receipt Line No." := 1;

            IF NOT FromShptOrRcpt THEN
              UpdateRevPurchLineAmount(
                FromPurchLineBuf,OrgQtyBase,
                FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT");
            IF FromPurchLineBuf.Quantity <> 0 THEN BEGIN
              FromPurchLineBuf.INSERT;
              AddPurchDocLine(TempDocPurchaseLine,FromPurchLineBuf."Line No.","Document No.",FromPurchLine."Line No.");
            END ELSE
              SkippedLine := TRUE;
          END ELSE
            IF "Remaining Quantity" = 0 THEN
              SkippedLine := TRUE;
        UNTIL (NEXT = 0) OR (FromPurchLine."Quantity (Base)" = 0);

        IF (FromPurchLine."Quantity (Base)" <> 0) AND FillExactCostRevLink THEN
          MissingExCostRevLink := TRUE;
      END;
      CheckUnappliedLines(SkippedLine,MissingExCostRevLink);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE SplitPurchDocLinesPerItemTrkg@59(VAR ItemLedgEntry@1003 : Record 32;VAR TempItemTrkgEntry@1009 : TEMPORARY Record 337;VAR FromPurchLineBuf@1004 : Record 39;FromPurchLine@1001 : Record 39;VAR TempDocPurchaseLine@1010 : TEMPORARY Record 39;VAR NextLineNo@1008 : Integer;VAR NextItemTrkgEntryNo@1002 : Integer;VAR MissingExCostRevLink@1005 : Boolean;FromShptOrRcpt@1007 : Boolean) : Boolean;
    VAR
      PurchLineBuf@1012 : ARRAY [2] OF TEMPORARY Record 39;
      ApplyRec@1019 : Record 339;
      Tracked@1011 : Boolean;
      RemainingQtyBase@1000 : Decimal;
      SignFactor@1006 : Integer;
      i@1013 : Integer;
    BEGIN
      IF FromShptOrRcpt THEN BEGIN
        FromPurchLineBuf.RESET;
        FromPurchLineBuf.DELETEALL;
        TempItemTrkgEntry.RESET;
        TempItemTrkgEntry.DELETEALL;
      END ELSE
        FromPurchLineBuf.INIT;

      IF MoveNegLines OR NOT ExactCostRevMandatory THEN
        EXIT(FALSE);

      IF FromPurchLine."Quantity (Base)" < 0 THEN
        SignFactor := -1
      ELSE
        SignFactor := 1;

      WITH ItemLedgEntry DO BEGIN
        SETCURRENTKEY("Document No.","Document Type","Document Line No.");
        FINDSET;
        REPEAT
          PurchLineBuf[1] := FromPurchLine;
          PurchLineBuf[1]."Line No." := NextLineNo;
          PurchLineBuf[1]."Quantity (Base)" := 0;
          PurchLineBuf[1].Quantity := 0;
          PurchLineBuf[1]."Document No." := "Document No.";
          IF GetPurchDocType(ItemLedgEntry) IN
             [PurchLineBuf[1]."Document Type"::Order,PurchLineBuf[1]."Document Type"::"Return Order"]
          THEN
            PurchLineBuf[1]."Receipt Line No." := 1;
          PurchLineBuf[2] := PurchLineBuf[1];
          PurchLineBuf[2]."Line No." := PurchLineBuf[2]."Line No." + 1;

          IF NOT FromShptOrRcpt THEN BEGIN
            SETRANGE("Document No.","Document No.");
            SETRANGE("Document Type","Document Type");
            SETRANGE("Document Line No.","Document Line No.");
          END;
          REPEAT
            i := 1;
            IF Positive THEN
              "Remaining Quantity" :=
                "Remaining Quantity" -
                CalcDistributedQty(TempItemTrkgEntry,ItemLedgEntry,PurchLineBuf[2]."Line No." + 1);

            IF "Document Type" IN ["Document Type"::"Purchase Return Shipment","Document Type"::"Purchase Credit Memo"] THEN
              IF -"Shipped Qty. Not Returned" < FromPurchLine."Quantity (Base)" * SignFactor THEN
                RemainingQtyBase := -"Shipped Qty. Not Returned" * SignFactor
              ELSE
                RemainingQtyBase := FromPurchLine."Quantity (Base)"
            ELSE
              IF NOT Positive THEN BEGIN
                RemainingQtyBase := -"Shipped Qty. Not Returned";
                IF RemainingQtyBase < FromPurchLine."Quantity (Base)" * SignFactor THEN
                  RemainingQtyBase := RemainingQtyBase * SignFactor
                ELSE
                  RemainingQtyBase := FromPurchLine."Quantity (Base)";
              END ELSE
                IF "Remaining Quantity" < FromPurchLine."Quantity (Base)" * SignFactor THEN BEGIN
                  IF ("Item Tracking" = "Item Tracking"::None) AND AskApply THEN
                    ConfirmApply;
                  IF (NOT ApplyFully) OR ("Item Tracking" <> "Item Tracking"::None) THEN
                    RemainingQtyBase := GetQtyOfPurchILENotShipped("Entry No.") * SignFactor
                  ELSE
                    RemainingQtyBase := FromPurchLine."Quantity (Base)" - ApplyRec.Returned("Entry No.");
                END ELSE
                  RemainingQtyBase := FromPurchLine."Quantity (Base)";

            IF RemainingQtyBase <> 0 THEN BEGIN
              IF Positive THEN
                IF IsSplitItemLedgEntry(ItemLedgEntry) THEN
                  i := 2;

              PurchLineBuf[i]."Quantity (Base)" := PurchLineBuf[i]."Quantity (Base)" + RemainingQtyBase;
              IF PurchLineBuf[i]."Qty. per Unit of Measure" = 0 THEN
                PurchLineBuf[i].Quantity := PurchLineBuf[i]."Quantity (Base)"
              ELSE
                PurchLineBuf[i].Quantity :=
                  ROUND(PurchLineBuf[i]."Quantity (Base)" / PurchLineBuf[i]."Qty. per Unit of Measure",0.00001);
              FromPurchLine."Quantity (Base)" := FromPurchLine."Quantity (Base)" - RemainingQtyBase;
              // Fill buffer with exact cost reversing link for remaining quantity
              IF "Document Type" IN ["Document Type"::"Purchase Return Shipment","Document Type"::"Purchase Credit Memo"] THEN
                InsertTempItemTrkgEntry(
                  ItemLedgEntry,TempItemTrkgEntry,-ABS(RemainingQtyBase),
                  PurchLineBuf[i]."Line No.",NextItemTrkgEntryNo,TRUE)
              ELSE
                InsertTempItemTrkgEntry(
                  ItemLedgEntry,TempItemTrkgEntry,ABS(RemainingQtyBase),
                  PurchLineBuf[i]."Line No.",NextItemTrkgEntryNo,TRUE);
              Tracked := TRUE;
            END;
          UNTIL (NEXT = 0) OR (FromPurchLine."Quantity (Base)" = 0);

          FOR i := 1 TO 2 DO
            IF PurchLineBuf[i]."Quantity (Base)" <> 0 THEN BEGIN
              FromPurchLineBuf := PurchLineBuf[i];
              FromPurchLineBuf.INSERT;
              AddPurchDocLine(TempDocPurchaseLine,FromPurchLineBuf."Line No.","Document No.",FromPurchLine."Line No.");
              NextLineNo := PurchLineBuf[i]."Line No." + 1;
            END;

          IF NOT FromShptOrRcpt THEN BEGIN
            SETRANGE("Document No.");
            SETRANGE("Document Type");
            SETRANGE("Document Line No.");
          END;
        UNTIL (NEXT = 0) OR FromShptOrRcpt;
        IF (FromPurchLine."Quantity (Base)" <> 0) AND NOT Tracked THEN
          MissingExCostRevLink := TRUE;
      END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CalcDistributedQty@76(VAR TempItemTrkgEntry@1000 : TEMPORARY Record 337;ItemLedgEntry@1002 : Record 32;NextLineNo@1001 : Integer) : Decimal;
    BEGIN
      WITH ItemLedgEntry DO BEGIN
        TempItemTrkgEntry.RESET;
        TempItemTrkgEntry.SETCURRENTKEY("Source ID","Source Ref. No.");
        TempItemTrkgEntry.SETRANGE("Source ID","Document No.");
        TempItemTrkgEntry.SETFILTER("Source Ref. No.",'<%1',NextLineNo);
        TempItemTrkgEntry.SETRANGE("Item Ledger Entry No.","Entry No.");
        TempItemTrkgEntry.CALCSUMS("Quantity (Base)");
        TempItemTrkgEntry.RESET;
        EXIT(TempItemTrkgEntry."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE IsSplitItemLedgEntry@83(OrgItemLedgEntry@1000 : Record 32) : Boolean;
    VAR
      ItemLedgEntry@1001 : Record 32;
    BEGIN
      WITH OrgItemLedgEntry DO BEGIN
        ItemLedgEntry.SETCURRENTKEY("Document No.");
        ItemLedgEntry.SETRANGE("Document No.","Document No.");
        ItemLedgEntry.SETRANGE("Document Type","Document Type");
        ItemLedgEntry.SETRANGE("Document Line No.","Document Line No.");
        ItemLedgEntry.SETRANGE("Lot No.","Lot No.");
        ItemLedgEntry.SETRANGE("Serial No.","Serial No.");
        ItemLedgEntry.SETFILTER("Entry No.",'<%1',"Entry No.");
        EXIT(NOT ItemLedgEntry.ISEMPTY);
      END;
    END;

    LOCAL PROCEDURE IsCopyItemTrkg@33(VAR ItemLedgEntry@1000 : Record 32;VAR CopyItemTrkg@1001 : Boolean;FillExactCostRevLink@1002 : Boolean) : Boolean;
    BEGIN
      WITH ItemLedgEntry DO BEGIN
        IF ISEMPTY THEN
          EXIT(TRUE);
        SETFILTER("Lot No.",'<>''''');
        IF NOT ISEMPTY THEN BEGIN
          IF FillExactCostRevLink THEN
            CopyItemTrkg := TRUE;
          EXIT(TRUE);
        END;
        SETRANGE("Lot No.");
        SETFILTER("Serial No.",'<>''''');
        IF NOT ISEMPTY THEN BEGIN
          IF FillExactCostRevLink THEN
            CopyItemTrkg := TRUE;
          EXIT(TRUE);
        END;
        SETRANGE("Serial No.");
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE InsertTempItemTrkgEntry@70(ItemLedgEntry@1001 : Record 32;VAR TempItemTrkgEntry@1000 : Record 337;QtyBase@1002 : Decimal;DocLineNo@1004 : Integer;VAR NextEntryNo@1003 : Integer;FillExactCostRevLink@1005 : Boolean);
    BEGIN
      IF QtyBase = 0 THEN
        EXIT;

      WITH ItemLedgEntry DO BEGIN
        TempItemTrkgEntry.INIT;
        TempItemTrkgEntry."Entry No." := NextEntryNo;
        NextEntryNo := NextEntryNo + 1;
        IF NOT FillExactCostRevLink THEN
          TempItemTrkgEntry."Reservation Status" := TempItemTrkgEntry."Reservation Status"::Prospect;
        TempItemTrkgEntry."Source ID" := "Document No.";
        TempItemTrkgEntry."Source Ref. No." := DocLineNo;
        TempItemTrkgEntry."Item Ledger Entry No." := "Entry No.";
        TempItemTrkgEntry."Quantity (Base)" := QtyBase;
        TempItemTrkgEntry.INSERT;
      END;
    END;

    LOCAL PROCEDURE GetLastToSalesLineNo@36(ToSalesHeader@1000 : Record 36) : Decimal;
    VAR
      ToSalesLine@1001 : Record 37;
    BEGIN
      ToSalesLine.LOCKTABLE;
      ToSalesLine.SETRANGE("Document Type",ToSalesHeader."Document Type");
      ToSalesLine.SETRANGE("Document No.",ToSalesHeader."No.");
      IF ToSalesLine.FINDLAST THEN
        EXIT(ToSalesLine."Line No.");
      EXIT(0);
    END;

    LOCAL PROCEDURE GetLastToPurchLineNo@54(ToPurchHeader@1000 : Record 38) : Decimal;
    VAR
      ToPurchLine@1001 : Record 39;
    BEGIN
      ToPurchLine.LOCKTABLE;
      ToPurchLine.SETRANGE("Document Type",ToPurchHeader."Document Type");
      ToPurchLine.SETRANGE("Document No.",ToPurchHeader."No.");
      IF ToPurchLine.FINDLAST THEN
        EXIT(ToPurchLine."Line No.");
      EXIT(0);
    END;

    LOCAL PROCEDURE InsertOldSalesDocNoLine@41(ToSalesHeader@1001 : Record 36;OldDocNo@1000 : Code[20];OldDocType@1004 : Integer;VAR NextLineNo@1002 : Integer);
    VAR
      ToSalesLine2@1003 : Record 37;
    BEGIN
      IF SkipCopyFromDescription THEN
        EXIT;

      NextLineNo := NextLineNo + 10000;
      ToSalesLine2.INIT;
      ToSalesLine2."Line No." := NextLineNo;
      ToSalesLine2."Document Type" := ToSalesHeader."Document Type";
      ToSalesLine2."Document No." := ToSalesHeader."No.";

      LanguageManagement.SetGlobalLanguageByCode(ToSalesHeader."Language Code");
      IF InsertCancellationLine THEN
        ToSalesLine2.Description := STRSUBSTNO(CrMemoCancellationMsg,OldDocNo)
      ELSE
        ToSalesLine2.Description := STRSUBSTNO(Text015,SELECTSTR(OldDocType,Text013),OldDocNo);
      LanguageManagement.RestoreGlobalLanguage;

      OnBeforeInsertOldSalesDocNoLine(ToSalesHeader,ToSalesLine2,OldDocType,OldDocNo);
      ToSalesLine2.INSERT;
    END;

    LOCAL PROCEDURE InsertOldSalesCombDocNoLine@62(ToSalesHeader@1001 : Record 36;OldDocNo@1000 : Code[20];OldDocNo2@1005 : Code[20];VAR NextLineNo@1002 : Integer;CopyFromInvoice@1004 : Boolean);
    VAR
      ToSalesLine2@1003 : Record 37;
    BEGIN
      NextLineNo := NextLineNo + 10000;
      ToSalesLine2.INIT;
      ToSalesLine2."Line No." := NextLineNo;
      ToSalesLine2."Document Type" := ToSalesHeader."Document Type";
      ToSalesLine2."Document No." := ToSalesHeader."No.";

      LanguageManagement.SetGlobalLanguageByCode(ToSalesHeader."Language Code");
      IF CopyFromInvoice THEN
        ToSalesLine2.Description :=
          STRSUBSTNO(
            Text018,
            COPYSTR(SELECTSTR(1,Text016) + OldDocNo,1,23),
            COPYSTR(SELECTSTR(2,Text016) + OldDocNo2,1,23))
      ELSE
        ToSalesLine2.Description :=
          STRSUBSTNO(
            Text018,
            COPYSTR(SELECTSTR(3,Text016) + OldDocNo,1,23),
            COPYSTR(SELECTSTR(4,Text016) + OldDocNo2,1,23));
      LanguageManagement.RestoreGlobalLanguage;

      OnBeforeInsertOldSalesCombDocNoLine(ToSalesHeader,ToSalesLine2,CopyFromInvoice,OldDocNo,OldDocNo2);
      ToSalesLine2.INSERT;
    END;

    LOCAL PROCEDURE InsertOldPurchDocNoLine@56(ToPurchHeader@1001 : Record 38;OldDocNo@1000 : Code[20];OldDocType@1004 : Integer;VAR NextLineNo@1002 : Integer);
    VAR
      ToPurchLine2@1003 : Record 39;
    BEGIN
      IF SkipCopyFromDescription THEN
        EXIT;

      NextLineNo := NextLineNo + 10000;
      ToPurchLine2.INIT;
      ToPurchLine2."Line No." := NextLineNo;
      ToPurchLine2."Document Type" := ToPurchHeader."Document Type";
      ToPurchLine2."Document No." := ToPurchHeader."No.";

      LanguageManagement.SetGlobalLanguageByCode(ToPurchHeader."Language Code");
      IF InsertCancellationLine THEN
        ToPurchLine2.Description := STRSUBSTNO(CrMemoCancellationMsg,OldDocNo)
      ELSE
        ToPurchLine2.Description := STRSUBSTNO(Text015,SELECTSTR(OldDocType,Text014),OldDocNo);
      LanguageManagement.RestoreGlobalLanguage;

      OnBeforeInsertOldPurchDocNoLine(ToPurchHeader,ToPurchLine2,OldDocType,OldDocNo);
      ToPurchLine2.INSERT;
    END;

    LOCAL PROCEDURE InsertOldPurchCombDocNoLine@72(ToPurchHeader@1001 : Record 38;OldDocNo@1000 : Code[20];OldDocNo2@1005 : Code[20];VAR NextLineNo@1002 : Integer;CopyFromInvoice@1004 : Boolean);
    VAR
      ToPurchLine2@1003 : Record 39;
    BEGIN
      NextLineNo := NextLineNo + 10000;
      ToPurchLine2.INIT;
      ToPurchLine2."Line No." := NextLineNo;
      ToPurchLine2."Document Type" := ToPurchHeader."Document Type";
      ToPurchLine2."Document No." := ToPurchHeader."No.";

      LanguageManagement.SetGlobalLanguageByCode(ToPurchHeader."Language Code");
      IF CopyFromInvoice THEN
        ToPurchLine2.Description :=
          STRSUBSTNO(
            Text018,
            COPYSTR(SELECTSTR(1,Text017) + OldDocNo,1,23),
            COPYSTR(SELECTSTR(2,Text017) + OldDocNo2,1,23))
      ELSE
        ToPurchLine2.Description :=
          STRSUBSTNO(
            Text018,
            COPYSTR(SELECTSTR(3,Text017) + OldDocNo,1,23),
            COPYSTR(SELECTSTR(4,Text017) + OldDocNo2,1,23));
      LanguageManagement.RestoreGlobalLanguage;

      OnBeforeInsertOldPurchCombDocNoLine(ToPurchHeader,ToPurchLine2,CopyFromInvoice,OldDocNo,OldDocNo2);
      ToPurchLine2.INSERT;
    END;

    [External]
    PROCEDURE IsSalesFillExactCostRevLink@38(ToSalesHeader@1000 : Record 36;FromDocType@1001 : 'Sales Shipment,Sales Invoice,Sales Return Receipt,Sales Credit Memo';CurrencyCode@1002 : Code[10]) : Boolean;
    BEGIN
      WITH ToSalesHeader DO
        CASE FromDocType OF
          FromDocType::"Sales Shipment":
            EXIT("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]);
          FromDocType::"Sales Invoice":
            EXIT(
              ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
              ("Currency Code" = CurrencyCode));
          FromDocType::"Sales Return Receipt":
            EXIT("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]);
          FromDocType::"Sales Credit Memo":
            EXIT(
              ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
              ("Currency Code" = CurrencyCode));
        END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE IsPurchFillExactCostRevLink@44(ToPurchHeader@1000 : Record 38;FromDocType@1001 : 'Purchase Receipt,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo';CurrencyCode@1002 : Code[10]) : Boolean;
    BEGIN
      WITH ToPurchHeader DO
        CASE FromDocType OF
          FromDocType::"Purchase Receipt":
            EXIT("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]);
          FromDocType::"Purchase Invoice":
            EXIT(
              ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
              ("Currency Code" = CurrencyCode));
          FromDocType::"Purchase Return Shipment":
            EXIT("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]);
          FromDocType::"Purchase Credit Memo":
            EXIT(
              ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
              ("Currency Code" = CurrencyCode));
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE GetSalesDocType@68(ItemLedgEntry@1000 : Record 32) : Integer;
    VAR
      SalesLine@1001 : Record 37;
    BEGIN
      WITH ItemLedgEntry DO
        CASE "Document Type" OF
          "Document Type"::"Sales Shipment":
            EXIT(SalesLine."Document Type"::Order);
          "Document Type"::"Sales Invoice":
            EXIT(SalesLine."Document Type"::Invoice);
          "Document Type"::"Sales Credit Memo":
            EXIT(SalesLine."Document Type"::"Credit Memo");
          "Document Type"::"Sales Return Receipt":
            EXIT(SalesLine."Document Type"::"Return Order");
        END;
    END;

    LOCAL PROCEDURE GetPurchDocType@45(ItemLedgEntry@1000 : Record 32) : Integer;
    VAR
      PurchLine@1001 : Record 39;
    BEGIN
      WITH ItemLedgEntry DO
        CASE "Document Type" OF
          "Document Type"::"Purchase Receipt":
            EXIT(PurchLine."Document Type"::Order);
          "Document Type"::"Purchase Invoice":
            EXIT(PurchLine."Document Type"::Invoice);
          "Document Type"::"Purchase Credit Memo":
            EXIT(PurchLine."Document Type"::"Credit Memo");
          "Document Type"::"Purchase Return Shipment":
            EXIT(PurchLine."Document Type"::"Return Order");
        END;
    END;

    LOCAL PROCEDURE GetItem@42(ItemNo@1000 : Code[20]);
    BEGIN
      IF ItemNo <> Item."No." THEN
        IF NOT Item.GET(ItemNo) THEN
          Item.INIT;
    END;

    LOCAL PROCEDURE CalcVAT@48(VAR Value@1003 : Decimal;VATPercentage@1005 : Decimal;FromPricesInclVAT@1000 : Boolean;ToPricesInclVAT@1002 : Boolean;RndgPrecision@1001 : Decimal);
    BEGIN
      IF (ToPricesInclVAT = FromPricesInclVAT) OR (Value = 0) THEN
        EXIT;

      IF ToPricesInclVAT THEN
        Value := ROUND(Value * (100 + VATPercentage) / 100,RndgPrecision)
      ELSE
        Value := ROUND(Value * 100 / (100 + VATPercentage),RndgPrecision);
    END;

    LOCAL PROCEDURE ReCalcSalesLine@46(FromSalesHeader@1001 : Record 36;ToSalesHeader@1002 : Record 36;VAR SalesLine@1003 : Record 37);
    VAR
      CurrExchRate@1004 : Record 330;
      SalesLineAmount@1000 : Decimal;
    BEGIN
      WITH ToSalesHeader DO BEGIN
        IF NOT IsRecalculateAmount(
             FromSalesHeader."Currency Code","Currency Code",
             FromSalesHeader."Prices Including VAT","Prices Including VAT")
        THEN
          EXIT;

        IF FromSalesHeader."Currency Code" <> "Currency Code" THEN BEGIN
          IF SalesLine.Quantity <> 0 THEN
            SalesLineAmount := SalesLine."Unit Price" * SalesLine.Quantity
          ELSE
            SalesLineAmount := SalesLine."Unit Price";
          IF FromSalesHeader."Currency Code" <> '' THEN BEGIN
            SalesLineAmount :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                FromSalesHeader."Posting Date",FromSalesHeader."Currency Code",
                SalesLineAmount,FromSalesHeader."Currency Factor");
            SalesLine."Line Discount Amount" :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                FromSalesHeader."Posting Date",FromSalesHeader."Currency Code",
                SalesLine."Line Discount Amount",FromSalesHeader."Currency Factor");
            SalesLine."Inv. Discount Amount" :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                FromSalesHeader."Posting Date",FromSalesHeader."Currency Code",
                SalesLine."Inv. Discount Amount",FromSalesHeader."Currency Factor");
          END;

          IF "Currency Code" <> '' THEN BEGIN
            SalesLineAmount :=
              CurrExchRate.ExchangeAmtLCYToFCY(
                "Posting Date","Currency Code",SalesLineAmount,"Currency Factor");
            SalesLine."Line Discount Amount" :=
              CurrExchRate.ExchangeAmtLCYToFCY(
                "Posting Date","Currency Code",SalesLine."Line Discount Amount","Currency Factor");
            SalesLine."Inv. Discount Amount" :=
              CurrExchRate.ExchangeAmtLCYToFCY(
                "Posting Date","Currency Code",SalesLine."Inv. Discount Amount","Currency Factor");
          END;
        END;

        SalesLine."Currency Code" := "Currency Code";
        IF SalesLine.Quantity <> 0 THEN BEGIN
          SalesLineAmount := ROUND(SalesLineAmount,Currency."Amount Rounding Precision");
          SalesLine."Unit Price" := ROUND(SalesLineAmount / SalesLine.Quantity,Currency."Unit-Amount Rounding Precision");
        END ELSE
          SalesLine."Unit Price" := ROUND(SalesLineAmount,Currency."Unit-Amount Rounding Precision");
        SalesLine."Line Discount Amount" := ROUND(SalesLine."Line Discount Amount",Currency."Amount Rounding Precision");
        SalesLine."Inv. Discount Amount" := ROUND(SalesLine."Inv. Discount Amount",Currency."Amount Rounding Precision");

        CalcVAT(
          SalesLine."Unit Price",SalesLine."VAT %",FromSalesHeader."Prices Including VAT",
          "Prices Including VAT",Currency."Unit-Amount Rounding Precision");
        CalcVAT(
          SalesLine."Line Discount Amount",SalesLine."VAT %",FromSalesHeader."Prices Including VAT",
          "Prices Including VAT",Currency."Amount Rounding Precision");
        CalcVAT(
          SalesLine."Inv. Discount Amount",SalesLine."VAT %",FromSalesHeader."Prices Including VAT",
          "Prices Including VAT",Currency."Amount Rounding Precision");
      END;
    END;

    LOCAL PROCEDURE ReCalcPurchLine@61(FromPurchHeader@1001 : Record 38;ToPurchHeader@1002 : Record 38;VAR PurchLine@1003 : Record 39);
    VAR
      CurrExchRate@1004 : Record 330;
      PurchLineAmount@1000 : Decimal;
    BEGIN
      WITH ToPurchHeader DO BEGIN
        IF NOT IsRecalculateAmount(
             FromPurchHeader."Currency Code","Currency Code",
             FromPurchHeader."Prices Including VAT","Prices Including VAT")
        THEN
          EXIT;

        IF FromPurchHeader."Currency Code" <> "Currency Code" THEN BEGIN
          IF PurchLine.Quantity <> 0 THEN
            PurchLineAmount := PurchLine."Direct Unit Cost" * PurchLine.Quantity
          ELSE
            PurchLineAmount := PurchLine."Direct Unit Cost";
          IF FromPurchHeader."Currency Code" <> '' THEN BEGIN
            PurchLineAmount :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                FromPurchHeader."Posting Date",FromPurchHeader."Currency Code",
                PurchLineAmount,FromPurchHeader."Currency Factor");
            PurchLine."Line Discount Amount" :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                FromPurchHeader."Posting Date",FromPurchHeader."Currency Code",
                PurchLine."Line Discount Amount",FromPurchHeader."Currency Factor");
            PurchLine."Inv. Discount Amount" :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                FromPurchHeader."Posting Date",FromPurchHeader."Currency Code",
                PurchLine."Inv. Discount Amount",FromPurchHeader."Currency Factor");
          END;

          IF "Currency Code" <> '' THEN BEGIN
            PurchLineAmount :=
              CurrExchRate.ExchangeAmtLCYToFCY(
                "Posting Date","Currency Code",PurchLineAmount,"Currency Factor");
            PurchLine."Line Discount Amount" :=
              CurrExchRate.ExchangeAmtLCYToFCY(
                "Posting Date","Currency Code",PurchLine."Line Discount Amount","Currency Factor");
            PurchLine."Inv. Discount Amount" :=
              CurrExchRate.ExchangeAmtLCYToFCY(
                "Posting Date","Currency Code",PurchLine."Inv. Discount Amount","Currency Factor");
          END;
        END;

        PurchLine."Currency Code" := "Currency Code";
        IF PurchLine.Quantity <> 0 THEN BEGIN
          PurchLineAmount := ROUND(PurchLineAmount,Currency."Amount Rounding Precision");
          PurchLine."Direct Unit Cost" := ROUND(PurchLineAmount / PurchLine.Quantity,Currency."Unit-Amount Rounding Precision");
        END ELSE
          PurchLine."Direct Unit Cost" := ROUND(PurchLineAmount,Currency."Unit-Amount Rounding Precision");
        PurchLine."Line Discount Amount" := ROUND(PurchLine."Line Discount Amount",Currency."Amount Rounding Precision");
        PurchLine."Inv. Discount Amount" := ROUND(PurchLine."Inv. Discount Amount",Currency."Amount Rounding Precision");

        CalcVAT(
          PurchLine."Direct Unit Cost",PurchLine."VAT %",FromPurchHeader."Prices Including VAT",
          "Prices Including VAT",Currency."Unit-Amount Rounding Precision");
        CalcVAT(
          PurchLine."Line Discount Amount",PurchLine."VAT %",FromPurchHeader."Prices Including VAT",
          "Prices Including VAT",Currency."Amount Rounding Precision");
        CalcVAT(
          PurchLine."Inv. Discount Amount",PurchLine."VAT %",FromPurchHeader."Prices Including VAT",
          "Prices Including VAT",Currency."Amount Rounding Precision");
      END;
    END;

    LOCAL PROCEDURE IsRecalculateAmount@63(FromCurrencyCode@1000 : Code[10];ToCurrencyCode@1002 : Code[10];FromPricesInclVAT@1001 : Boolean;ToPricesInclVAT@1003 : Boolean) : Boolean;
    BEGIN
      EXIT(
        (FromCurrencyCode <> ToCurrencyCode) OR
        (FromPricesInclVAT <> ToPricesInclVAT));
    END;

    LOCAL PROCEDURE UpdateRevSalesLineAmount@67(VAR SalesLine@1000 : Record 37;OrgQtyBase@1009 : Decimal;FromPricesInclVAT@1005 : Boolean;ToPricesInclVAT@1006 : Boolean);
    VAR
      Amount@1007 : Decimal;
    BEGIN
      IF (OrgQtyBase = 0) OR (SalesLine.Quantity = 0) OR
         ((FromPricesInclVAT = ToPricesInclVAT) AND (OrgQtyBase = SalesLine."Quantity (Base)"))
      THEN
        EXIT;

      Amount := SalesLine.Quantity * SalesLine."Unit Price";
      CalcVAT(
        Amount,SalesLine."VAT %",FromPricesInclVAT,ToPricesInclVAT,Currency."Amount Rounding Precision");
      SalesLine."Unit Price" := Amount / SalesLine.Quantity;
      SalesLine."Line Discount Amount" :=
        ROUND(
          ROUND(SalesLine.Quantity * SalesLine."Unit Price",Currency."Amount Rounding Precision") *
          SalesLine."Line Discount %" / 100,
          Currency."Amount Rounding Precision");
      Amount :=
        ROUND(SalesLine."Inv. Discount Amount" / OrgQtyBase * SalesLine."Quantity (Base)",Currency."Amount Rounding Precision");
      CalcVAT(
        Amount,SalesLine."VAT %",FromPricesInclVAT,ToPricesInclVAT,Currency."Amount Rounding Precision");
      SalesLine."Inv. Discount Amount" := Amount;
    END;

    [External]
    PROCEDURE CalculateRevSalesLineAmount@84(VAR SalesLine@1000 : Record 37;OrgQtyBase@1009 : Decimal;FromPricesInclVAT@1005 : Boolean;ToPricesInclVAT@1006 : Boolean);
    VAR
      UnitPrice@1007 : Decimal;
      LineDiscAmt@1001 : Decimal;
      InvDiscAmt@1002 : Decimal;
    BEGIN
      UpdateRevSalesLineAmount(SalesLine,OrgQtyBase,FromPricesInclVAT,ToPricesInclVAT);

      UnitPrice := SalesLine."Unit Price";
      LineDiscAmt := SalesLine."Line Discount Amount";
      InvDiscAmt := SalesLine."Inv. Discount Amount";

      SalesLine.VALIDATE("Unit Price",UnitPrice);
      SalesLine.VALIDATE("Line Discount Amount",LineDiscAmt);
      SalesLine.VALIDATE("Inv. Discount Amount",InvDiscAmt);
    END;

    LOCAL PROCEDURE UpdateRevPurchLineAmount@65(VAR PurchLine@1000 : Record 39;OrgQtyBase@1009 : Decimal;FromPricesInclVAT@1005 : Boolean;ToPricesInclVAT@1006 : Boolean);
    VAR
      Amount@1007 : Decimal;
    BEGIN
      IF (OrgQtyBase = 0) OR (PurchLine.Quantity = 0) OR
         ((FromPricesInclVAT = ToPricesInclVAT) AND (OrgQtyBase = PurchLine."Quantity (Base)"))
      THEN
        EXIT;

      Amount := PurchLine.Quantity * PurchLine."Direct Unit Cost";
      CalcVAT(
        Amount,PurchLine."VAT %",FromPricesInclVAT,ToPricesInclVAT,Currency."Amount Rounding Precision");
      PurchLine."Direct Unit Cost" := Amount / PurchLine.Quantity;
      PurchLine."Line Discount Amount" :=
        ROUND(
          ROUND(PurchLine.Quantity * PurchLine."Direct Unit Cost",Currency."Amount Rounding Precision") *
          PurchLine."Line Discount %" / 100,
          Currency."Amount Rounding Precision");
      Amount :=
        ROUND(PurchLine."Inv. Discount Amount" / OrgQtyBase * PurchLine."Quantity (Base)",Currency."Amount Rounding Precision");
      CalcVAT(
        Amount,PurchLine."VAT %",FromPricesInclVAT,ToPricesInclVAT,Currency."Amount Rounding Precision");
      PurchLine."Inv. Discount Amount" := Amount;
    END;

    [External]
    PROCEDURE CalculateRevPurchLineAmount@82(VAR PurchLine@1000 : Record 39;OrgQtyBase@1009 : Decimal;FromPricesInclVAT@1005 : Boolean;ToPricesInclVAT@1006 : Boolean);
    VAR
      DirectUnitCost@1007 : Decimal;
      LineDiscAmt@1001 : Decimal;
      InvDiscAmt@1002 : Decimal;
    BEGIN
      UpdateRevPurchLineAmount(PurchLine,OrgQtyBase,FromPricesInclVAT,ToPricesInclVAT);

      DirectUnitCost := PurchLine."Direct Unit Cost";
      LineDiscAmt := PurchLine."Line Discount Amount";
      InvDiscAmt := PurchLine."Inv. Discount Amount";

      PurchLine.VALIDATE("Direct Unit Cost",DirectUnitCost);
      PurchLine.VALIDATE("Line Discount Amount",LineDiscAmt);
      PurchLine.VALIDATE("Inv. Discount Amount",InvDiscAmt);
    END;

    LOCAL PROCEDURE InitCurrency@81(CurrencyCode@1000 : Code[10]);
    BEGIN
      IF CurrencyCode <> '' THEN
        Currency.GET(CurrencyCode)
      ELSE
        Currency.InitRoundingPrecision;

      Currency.TESTFIELD("Unit-Amount Rounding Precision");
      Currency.TESTFIELD("Amount Rounding Precision");
    END;

    LOCAL PROCEDURE OpenWindow@79();
    BEGIN
      Window.OPEN(
        Text022 +
        Text023 +
        Text024);
      WindowUpdateDateTime := CURRENTDATETIME;
    END;

    LOCAL PROCEDURE IsTimeForUpdate@75() : Boolean;
    BEGIN
      IF CURRENTDATETIME - WindowUpdateDateTime >= 1000 THEN BEGIN
        WindowUpdateDateTime := CURRENTDATETIME;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ConfirmApply@32();
    BEGIN
      AskApply := FALSE;
      ApplyFully := FALSE;
    END;

    LOCAL PROCEDURE ConvertFromBase@47(VAR Quantity@1000 : Decimal;QuantityBase@1001 : Decimal;QtyPerUOM@1002 : Decimal);
    BEGIN
      IF QtyPerUOM = 0 THEN
        Quantity := QuantityBase
      ELSE
        Quantity :=
          ROUND(QuantityBase / QtyPerUOM,0.00001);
    END;

    LOCAL PROCEDURE Sign@77(Quantity@1000 : Decimal) : Decimal;
    BEGIN
      IF Quantity < 0 THEN
        EXIT(-1);
      EXIT(1);
    END;

    [External]
    PROCEDURE ShowMessageReapply@80(OriginalQuantity@1000 : Boolean);
    VAR
      Text@1001 : Text[1024];
    BEGIN
      Text := '';
      IF SkippedLine THEN
        Text := Text029;
      IF OriginalQuantity AND ReappDone THEN
        IF Text = '' THEN
          Text := Text025;
      IF SomeAreFixed THEN
        MESSAGE(Text031);
      IF Text <> '' THEN
        MESSAGE(Text);
    END;

    LOCAL PROCEDURE LinkJobPlanningLine@86(SalesHeader@1000 : Record 36);
    VAR
      SalesLine@1001 : Record 37;
      JobPlanningLine@1002 : Record 1003;
      JobPlanningLineInvoice@1003 : Record 1022;
    BEGIN
      JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      REPEAT
        JobPlanningLine.SETRANGE("Job Contract Entry No.",SalesLine."Job Contract Entry No.");
        IF JobPlanningLine.FINDFIRST THEN BEGIN
          JobPlanningLineInvoice."Job No." := JobPlanningLine."Job No.";
          JobPlanningLineInvoice."Job Task No." := JobPlanningLine."Job Task No.";
          JobPlanningLineInvoice."Job Planning Line No." := JobPlanningLine."Line No.";
          CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Invoice:
              BEGIN
                JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."Document Type"::Invoice;
                JobPlanningLineInvoice."Quantity Transferred" := SalesLine.Quantity;
              END;
            SalesHeader."Document Type"::"Credit Memo":
              BEGIN
                JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."Document Type"::"Credit Memo";
                JobPlanningLineInvoice."Quantity Transferred" := -SalesLine.Quantity;
              END;
            ELSE
              EXIT;
          END;
          JobPlanningLineInvoice."Document No." := SalesHeader."No.";
          JobPlanningLineInvoice."Line No." := SalesLine."Line No.";
          JobPlanningLineInvoice."Transferred Date" := SalesHeader."Posting Date";
          JobPlanningLineInvoice.INSERT;

          JobPlanningLine.UpdateQtyToTransfer;
          JobPlanningLine.MODIFY;
        END;
      UNTIL SalesLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetQtyOfPurchILENotShipped@6(ItemLedgerEntryNo@1000 : Integer) : Decimal;
    VAR
      ItemApplicationEntry@1003 : Record 339;
      ItemLedgerEntryLocal@1001 : Record 32;
      QtyNotShipped@1002 : Decimal;
    BEGIN
      QtyNotShipped := 0;
      WITH ItemApplicationEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Inbound Item Entry No.","Outbound Item Entry No.");
        SETRANGE("Inbound Item Entry No.",ItemLedgerEntryNo);
        SETRANGE("Outbound Item Entry No.",0);
        IF NOT FINDFIRST THEN
          EXIT(QtyNotShipped);
        QtyNotShipped := Quantity;
        SETFILTER("Outbound Item Entry No.",'<>0');
        IF NOT FINDSET(FALSE,FALSE) THEN
          EXIT(QtyNotShipped);
        REPEAT
          ItemLedgerEntryLocal.GET("Outbound Item Entry No.");
          IF (ItemLedgerEntryLocal."Entry Type" IN
              [ItemLedgerEntryLocal."Entry Type"::Sale,
               ItemLedgerEntryLocal."Entry Type"::Purchase]) OR
             ((ItemLedgerEntryLocal."Entry Type" IN
               [ItemLedgerEntryLocal."Entry Type"::"Positive Adjmt.",ItemLedgerEntryLocal."Entry Type"::"Negative Adjmt."]) AND
              (ItemLedgerEntryLocal."Job No." = ''))
          THEN
            QtyNotShipped += Quantity;
        UNTIL NEXT = 0;
      END;
      EXIT(QtyNotShipped);
    END;

    LOCAL PROCEDURE CopyAsmOrderToAsmOrder@13(VAR TempFromAsmHeader@1007 : TEMPORARY Record 900;VAR TempFromAsmLine@1008 : TEMPORARY Record 901;ToSalesLine@1000 : Record 37;ToAsmHeaderDocType@1002 : Integer;ToAsmHeaderDocNo@1009 : Code[20];InclAsmHeader@1012 : Boolean);
    VAR
      FromAsmHeader@1001 : Record 900;
      ToAsmHeader@1004 : Record 900;
      TempToAsmHeader@1100 : TEMPORARY Record 900;
      AssembleToOrderLink@1003 : Record 904;
      ToAsmLine@1006 : Record 901;
      BasicAsmOrderCopy@1010 : Boolean;
    BEGIN
      IF ToAsmHeaderDocType = -1 THEN
        EXIT;
      BasicAsmOrderCopy := ToAsmHeaderDocNo <> '';
      IF BasicAsmOrderCopy THEN
        ToAsmHeader.GET(ToAsmHeaderDocType,ToAsmHeaderDocNo)
      ELSE BEGIN
        IF ToSalesLine.AsmToOrderExists(FromAsmHeader) THEN
          EXIT;
        CLEAR(ToAsmHeader);
        AssembleToOrderLink.InsertAsmHeader(ToAsmHeader,ToAsmHeaderDocType,'');
        InclAsmHeader := TRUE;
      END;

      IF InclAsmHeader THEN BEGIN
        IF BasicAsmOrderCopy THEN BEGIN
          TempToAsmHeader := ToAsmHeader;
          TempToAsmHeader.INSERT;
          ProcessToAsmHeader(TempToAsmHeader,TempFromAsmHeader,ToSalesLine,TRUE,TRUE); // Basic, Availabilitycheck
          CheckAsmOrderAvailability(TempToAsmHeader,TempFromAsmLine,ToSalesLine);
        END;
        ProcessToAsmHeader(ToAsmHeader,TempFromAsmHeader,ToSalesLine,BasicAsmOrderCopy,FALSE);
      END ELSE
        IF BasicAsmOrderCopy THEN
          CheckAsmOrderAvailability(ToAsmHeader,TempFromAsmLine,ToSalesLine);
      CreateToAsmLines(ToAsmHeader,TempFromAsmLine,ToAsmLine,ToSalesLine,BasicAsmOrderCopy,FALSE);
      IF NOT BasicAsmOrderCopy THEN
        WITH AssembleToOrderLink DO BEGIN
          "Assembly Document Type" := ToAsmHeader."Document Type";
          "Assembly Document No." := ToAsmHeader."No.";
          Type := Type::Sale;
          "Document Type" := ToSalesLine."Document Type";
          "Document No." := ToSalesLine."Document No.";
          "Document Line No." := ToSalesLine."Line No.";
          INSERT;
          IF ToSalesLine."Document Type" = ToSalesLine."Document Type"::Order THEN BEGIN
            IF ToSalesLine."Shipment Date" = 0D THEN BEGIN
              ToSalesLine."Shipment Date" := ToAsmHeader."Due Date";
              ToSalesLine.MODIFY;
            END;
            ReserveAsmToSale(ToSalesLine,ToSalesLine.Quantity,ToSalesLine."Quantity (Base)");
          END;
        END;

      ToAsmHeader.ShowDueDateBeforeWorkDateMsg;
    END;

    [External]
    PROCEDURE CopyAsmHeaderToAsmHeader@90(FromAsmHeader@1000 : Record 900;ToAsmHeader@1001 : Record 900;IncludeHeader@1003 : Boolean);
    VAR
      EmptyToSalesLine@1002 : Record 37;
    BEGIN
      InitialToAsmHeaderCheck(ToAsmHeader,IncludeHeader);
      GenerateAsmDataFromNonPosted(FromAsmHeader);
      CLEAR(EmptyToSalesLine);
      EmptyToSalesLine.INIT;
      CopyAsmOrderToAsmOrder(TempAsmHeader,TempAsmLine,EmptyToSalesLine,ToAsmHeader."Document Type",ToAsmHeader."No.",IncludeHeader);
    END;

    [External]
    PROCEDURE CopyPostedAsmHeaderToAsmHeader@14(PostedAsmHeader@1000 : Record 910;ToAsmHeader@1001 : Record 900;IncludeHeader@1003 : Boolean);
    VAR
      EmptyToSalesLine@1002 : Record 37;
    BEGIN
      InitialToAsmHeaderCheck(ToAsmHeader,IncludeHeader);
      GenerateAsmDataFromPosted(PostedAsmHeader,0);
      CLEAR(EmptyToSalesLine);
      EmptyToSalesLine.INIT;
      CopyAsmOrderToAsmOrder(TempAsmHeader,TempAsmLine,EmptyToSalesLine,ToAsmHeader."Document Type",ToAsmHeader."No.",IncludeHeader);
    END;

    LOCAL PROCEDURE GenerateAsmDataFromNonPosted@18(AsmHeader@1000 : Record 900);
    VAR
      AsmLine@1001 : Record 901;
    BEGIN
      InitAsmCopyHandling(FALSE);
      TempAsmHeader := AsmHeader;
      TempAsmHeader.INSERT;
      AsmLine.SETRANGE("Document Type",AsmHeader."Document Type");
      AsmLine.SETRANGE("Document No.",AsmHeader."No.");
      IF AsmLine.FINDSET THEN
        REPEAT
          TempAsmLine := AsmLine;
          TempAsmLine.INSERT;
        UNTIL AsmLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GenerateAsmDataFromPosted@87(PostedAsmHeader@1000 : Record 910;DocType@1001 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order');
    VAR
      PostedAsmLine@1002 : Record 911;
    BEGIN
      InitAsmCopyHandling(FALSE);
      TempAsmHeader.TRANSFERFIELDS(PostedAsmHeader);
      CASE DocType OF
        DocType::Quote:
          TempAsmHeader."Document Type" := TempAsmHeader."Document Type"::Quote;
        DocType::Order:
          TempAsmHeader."Document Type" := TempAsmHeader."Document Type"::Order;
        DocType::"Blanket Order":
          TempAsmHeader."Document Type" := TempAsmHeader."Document Type"::"Blanket Order";
        ELSE
          EXIT;
      END;
      TempAsmHeader.INSERT;
      PostedAsmLine.SETRANGE("Document No.",PostedAsmHeader."No.");
      IF PostedAsmLine.FINDSET THEN
        REPEAT
          TempAsmLine.TRANSFERFIELDS(PostedAsmLine);
          TempAsmLine."Document No." := TempAsmHeader."No.";
          TempAsmLine."Cost Amount" := PostedAsmLine.Quantity * PostedAsmLine."Unit Cost";
          TempAsmLine.INSERT;
        UNTIL PostedAsmLine.NEXT = 0;
    END;

    LOCAL PROCEDURE GetAsmDataFromSalesInvLine@9(DocType@1001 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order') : Boolean;
    VAR
      ValueEntry@1002 : Record 5802;
      ValueEntry2@1000 : Record 5802;
      ItemLedgerEntry@1003 : Record 32;
      ItemLedgerEntry2@1005 : Record 32;
      SalesShipmentLine@1004 : Record 111;
    BEGIN
      CLEAR(PostedAsmHeader);
      IF TempSalesInvLine.Type <> TempSalesInvLine.Type::Item THEN
        EXIT(FALSE);
      ValueEntry.SETCURRENTKEY("Document No.");
      ValueEntry.SETRANGE("Document No.",TempSalesInvLine."Document No.");
      ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Invoice");
      ValueEntry.SETRANGE("Document Line No.",TempSalesInvLine."Line No.");
      IF NOT ValueEntry.FINDFIRST THEN
        EXIT(FALSE);
      IF NOT ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN
        EXIT(FALSE);
      IF ItemLedgerEntry."Document Type" <> ItemLedgerEntry."Document Type"::"Sales Shipment" THEN
        EXIT(FALSE);
      SalesShipmentLine.GET(ItemLedgerEntry."Document No.",ItemLedgerEntry."Document Line No.");
      IF NOT SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) THEN
        EXIT(FALSE);
      IF ValueEntry.COUNT > 1 THEN BEGIN
        ValueEntry2.COPY(ValueEntry);
        ValueEntry2.SETFILTER("Item Ledger Entry No.",'<>%1',ValueEntry."Item Ledger Entry No.");
        IF ValueEntry2.FINDSET THEN
          REPEAT
            ItemLedgerEntry2.GET(ValueEntry2."Item Ledger Entry No.");
            IF (ItemLedgerEntry2."Document Type" <> ItemLedgerEntry."Document Type") OR
               (ItemLedgerEntry2."Document No." <> ItemLedgerEntry."Document No.") OR
               (ItemLedgerEntry2."Document Line No." <> ItemLedgerEntry."Document Line No.")
            THEN
              ERROR(Text032,TempSalesInvLine."Document No.");
          UNTIL ValueEntry2.NEXT = 0;
      END;
      GenerateAsmDataFromPosted(PostedAsmHeader,DocType);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE InitAsmCopyHandling@17(ResetQuantities@1000 : Boolean);
    BEGIN
      IF ResetQuantities THEN BEGIN
        QtyToAsmToOrder := 0;
        QtyToAsmToOrderBase := 0;
      END;
      TempAsmHeader.DELETEALL;
      TempAsmLine.DELETEALL;
    END;

    LOCAL PROCEDURE RetrieveSalesInvLine@92(SalesLine@1000 : Record 37;PosNo@1001 : Integer;LineCountsEqual@1002 : Boolean) : Boolean;
    BEGIN
      IF NOT LineCountsEqual THEN
        EXIT(FALSE);
      TempSalesInvLine.FINDSET;
      IF PosNo > 1 THEN
        TempSalesInvLine.NEXT(PosNo - 1);
      EXIT((SalesLine.Type = TempSalesInvLine.Type) AND (SalesLine."No." = TempSalesInvLine."No."));
    END;

    [External]
    PROCEDURE InitialToAsmHeaderCheck@21(ToAsmHeader@1000 : Record 900;IncludeHeader@1001 : Boolean);
    BEGIN
      ToAsmHeader.TESTFIELD("No.");
      IF IncludeHeader THEN BEGIN
        ToAsmHeader.TESTFIELD("Item No.",'');
        ToAsmHeader.TESTFIELD(Quantity,0);
      END ELSE BEGIN
        ToAsmHeader.TESTFIELD("Item No.");
        ToAsmHeader.TESTFIELD(Quantity);
      END;
    END;

    LOCAL PROCEDURE GetAsmOrderType@85(SalesLineDocType@1000 : 'Quote,Order,,,Blanket Order') : Integer;
    BEGIN
      IF SalesLineDocType IN [SalesLineDocType::Quote,SalesLineDocType::Order,SalesLineDocType::"Blanket Order"] THEN
        EXIT(SalesLineDocType);
      EXIT(-1);
    END;

    LOCAL PROCEDURE ProcessToAsmHeader@1110(VAR ToAsmHeader@1101 : Record 900;TempFromAsmHeader@1102 : TEMPORARY Record 900;ToSalesLine@1104 : Record 37;BasicAsmOrderCopy@1105 : Boolean;AvailabilityCheck@1106 : Boolean);
    BEGIN
      WITH ToAsmHeader DO BEGIN
        IF AvailabilityCheck THEN BEGIN
          "Item No." := TempFromAsmHeader."Item No.";
          "Location Code" := TempFromAsmHeader."Location Code";
          "Variant Code" := TempFromAsmHeader."Variant Code";
          "Unit of Measure Code" := TempFromAsmHeader."Unit of Measure Code";
        END ELSE BEGIN
          VALIDATE("Item No.",TempFromAsmHeader."Item No.");
          VALIDATE("Location Code",TempFromAsmHeader."Location Code");
          VALIDATE("Variant Code",TempFromAsmHeader."Variant Code");
          VALIDATE("Unit of Measure Code",TempFromAsmHeader."Unit of Measure Code");
        END;
        IF BasicAsmOrderCopy THEN BEGIN
          VALIDATE("Due Date",TempFromAsmHeader."Due Date");
          Quantity := TempFromAsmHeader.Quantity;
          "Quantity (Base)" := TempFromAsmHeader."Quantity (Base)";
        END ELSE BEGIN
          IF ToSalesLine."Shipment Date" <> 0D THEN
            VALIDATE("Due Date",ToSalesLine."Shipment Date");
          Quantity := QtyToAsmToOrder;
          "Quantity (Base)" := QtyToAsmToOrderBase;
        END;
        "Bin Code" := TempFromAsmHeader."Bin Code";
        "Unit Cost" := TempFromAsmHeader."Unit Cost";
        RoundQty(Quantity);
        RoundQty("Quantity (Base)");
        "Cost Amount" := ROUND(Quantity * "Unit Cost");
        InitRemainingQty;
        InitQtyToAssemble;
        IF NOT AvailabilityCheck THEN BEGIN
          VALIDATE("Quantity to Assemble");
          VALIDATE("Planning Flexibility",TempFromAsmHeader."Planning Flexibility");
        END;
        MODIFY;
      END;
    END;

    LOCAL PROCEDURE CreateToAsmLines@94(ToAsmHeader@1001 : Record 900;VAR FromAsmLine@1000 : Record 901;VAR ToAssemblyLine@1002 : Record 901;ToSalesLine@1005 : Record 37;BasicAsmOrderCopy@1003 : Boolean;AvailabilityCheck@1011 : Boolean);
    VAR
      AssemblyLineMgt@1010 : Codeunit 905;
      UOMMgt@1004 : Codeunit 5402;
    BEGIN
      IF FromAsmLine.FINDSET THEN
        REPEAT
          ToAssemblyLine.INIT;
          ToAssemblyLine."Document Type" := ToAsmHeader."Document Type";
          ToAssemblyLine."Document No." := ToAsmHeader."No.";
          ToAssemblyLine."Line No." := AssemblyLineMgt.GetNextAsmLineNo(ToAssemblyLine,AvailabilityCheck);
          ToAssemblyLine.INSERT(NOT AvailabilityCheck);
          IF AvailabilityCheck THEN BEGIN
            ToAssemblyLine.Type := FromAsmLine.Type;
            ToAssemblyLine."No." := FromAsmLine."No.";
            ToAssemblyLine."Resource Usage Type" := FromAsmLine."Resource Usage Type";
            ToAssemblyLine."Unit of Measure Code" := FromAsmLine."Unit of Measure Code";
            ToAssemblyLine."Quantity per" := FromAsmLine."Quantity per";
            ToAssemblyLine.Quantity := GetAppliedQuantityForAsmLine(BasicAsmOrderCopy,ToAsmHeader,FromAsmLine,ToSalesLine);
          END ELSE BEGIN
            ToAssemblyLine.VALIDATE(Type,FromAsmLine.Type);
            ToAssemblyLine.VALIDATE("No.",FromAsmLine."No.");
            ToAssemblyLine.VALIDATE("Resource Usage Type",FromAsmLine."Resource Usage Type");
            ToAssemblyLine.VALIDATE("Unit of Measure Code",FromAsmLine."Unit of Measure Code");
            IF ToAssemblyLine.Type <> ToAssemblyLine.Type::" " THEN
              ToAssemblyLine.VALIDATE("Quantity per",FromAsmLine."Quantity per");
            ToAssemblyLine.VALIDATE(Quantity,GetAppliedQuantityForAsmLine(BasicAsmOrderCopy,ToAsmHeader,FromAsmLine,ToSalesLine));
          END;
          ToAssemblyLine.ValidateDueDate(ToAsmHeader,ToAsmHeader."Starting Date",FALSE);
          ToAssemblyLine.ValidateLeadTimeOffset(ToAsmHeader,FromAsmLine."Lead-Time Offset",FALSE);
          ToAssemblyLine.Description := FromAsmLine.Description;
          ToAssemblyLine."Description 2" := FromAsmLine."Description 2";
          ToAssemblyLine.Position := FromAsmLine.Position;
          ToAssemblyLine."Position 2" := FromAsmLine."Position 2";
          ToAssemblyLine."Position 3" := FromAsmLine."Position 3";
          IF ToAssemblyLine.Type <> ToAssemblyLine.Type::" " THEN BEGIN
            ToAssemblyLine.VALIDATE("Unit Cost",FromAsmLine."Unit Cost");
            IF AvailabilityCheck THEN BEGIN
              WITH ToAssemblyLine DO BEGIN
                "Quantity (Base)" := UOMMgt.CalcBaseQty(Quantity,"Qty. per Unit of Measure");
                "Remaining Quantity" := "Quantity (Base)";
                "Quantity to Consume" := ToAsmHeader."Quantity to Assemble" * FromAsmLine."Quantity per";
                "Quantity to Consume (Base)" := UOMMgt.CalcBaseQty("Quantity to Consume","Qty. per Unit of Measure");
              END;
            END ELSE
              ToAssemblyLine.VALIDATE("Quantity to Consume",ToAsmHeader."Quantity to Assemble" * FromAsmLine."Quantity per");
          END;
          IF ToAssemblyLine.Type = ToAssemblyLine.Type::Item THEN
            IF AvailabilityCheck THEN BEGIN
              ToAssemblyLine."Location Code" := FromAsmLine."Location Code";
              ToAssemblyLine."Variant Code" := FromAsmLine."Variant Code";
            END ELSE BEGIN
              ToAssemblyLine.VALIDATE("Location Code",FromAsmLine."Location Code");
              ToAssemblyLine.VALIDATE("Variant Code",FromAsmLine."Variant Code");
            END;
          ToAssemblyLine.MODIFY(NOT AvailabilityCheck);
        UNTIL FromAsmLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckAsmOrderAvailability@95(ToAsmHeader@1007 : Record 900;VAR FromAsmLine@1006 : Record 901;ToSalesLine@1004 : Record 37);
    VAR
      TempToAsmHeader@1002 : TEMPORARY Record 900;
      TempToAsmLine@1003 : TEMPORARY Record 901;
      AsmLineOnDestinationOrder@1010 : Record 901;
      AssemblyLineMgt@1008 : Codeunit 905;
      ItemCheckAvail@1009 : Codeunit 311;
      LineNo@1005 : Integer;
    BEGIN
      TempToAsmHeader := ToAsmHeader;
      TempToAsmHeader.INSERT;
      CreateToAsmLines(TempToAsmHeader,FromAsmLine,TempToAsmLine,ToSalesLine,TRUE,TRUE);
      IF TempToAsmLine.FINDLAST THEN
        LineNo := TempToAsmLine."Line No.";
      CLEAR(TempToAsmLine);
      WITH AsmLineOnDestinationOrder DO BEGIN
        SETRANGE("Document Type",ToAsmHeader."Document Type");
        SETRANGE("Document No.",ToAsmHeader."No.");
        SETRANGE(Type,Type::Item);
      END;
      IF AsmLineOnDestinationOrder.FINDSET THEN
        REPEAT
          TempToAsmLine := AsmLineOnDestinationOrder;
          LineNo += 10000;
          TempToAsmLine."Line No." := LineNo;
          TempToAsmLine.INSERT;
        UNTIL AsmLineOnDestinationOrder.NEXT = 0;
      IF AssemblyLineMgt.ShowAvailability(FALSE,TempToAsmHeader,TempToAsmLine) THEN
        ItemCheckAvail.RaiseUpdateInterruptedError;
      TempToAsmLine.DELETEALL;
    END;

    LOCAL PROCEDURE GetAppliedQuantityForAsmLine@101(BasicAsmOrderCopy@1000 : Boolean;ToAsmHeader@1001 : Record 900;TempFromAsmLine@1002 : TEMPORARY Record 901;ToSalesLine@1003 : Record 37) : Decimal;
    BEGIN
      IF BasicAsmOrderCopy THEN
        EXIT(ToAsmHeader.Quantity * TempFromAsmLine."Quantity per");
      CASE ToSalesLine."Document Type" OF
        ToSalesLine."Document Type"::Order:
          EXIT(ToSalesLine."Qty. to Assemble to Order" * TempFromAsmLine."Quantity per");
        ToSalesLine."Document Type"::Quote,
        ToSalesLine."Document Type"::"Blanket Order":
          EXIT(ToSalesLine.Quantity * TempFromAsmLine."Quantity per");
      END;
    END;

    LOCAL PROCEDURE CopyDocLines@93(RecalculateAmount@1002 : Boolean;ToPurchLine@1001 : Record 39;VAR FromPurchLine@1000 : Record 39);
    BEGIN
      IF NOT RecalculateAmount THEN
        EXIT;
      IF (ToPurchLine.Type <> ToPurchLine.Type::" ") AND (ToPurchLine."No." <> '') THEN BEGIN
        ToPurchLine.VALIDATE("Line Discount %",FromPurchLine."Line Discount %");
        ToPurchLine.VALIDATE(
          "Inv. Discount Amount",
          ROUND(FromPurchLine."Inv. Discount Amount",Currency."Amount Rounding Precision"));
      END;
    END;

    LOCAL PROCEDURE CheckCreditLimit@73(FromSalesHeader@1000 : Record 36;ToSalesHeader@1001 : Record 36);
    BEGIN
      IF SkipTestCreditLimit THEN
        EXIT;

      IF IncludeHeader THEN
        CustCheckCreditLimit.SalesHeaderCheck(FromSalesHeader)
      ELSE
        CustCheckCreditLimit.SalesHeaderCheck(ToSalesHeader);
    END;

    LOCAL PROCEDURE CheckUnappliedLines@102(SkippedLine@1000 : Boolean;VAR MissingExCostRevLink@1001 : Boolean);
    BEGIN
      IF SkippedLine AND MissingExCostRevLink THEN BEGIN
        IF NOT WarningDone THEN
          MESSAGE(Text030);
        MissingExCostRevLink := FALSE;
        WarningDone := TRUE;
      END;
    END;

    LOCAL PROCEDURE SetDefaultValuesToSalesLine@103(VAR ToSalesLine@1000 : Record 37;ToSalesHeader@1001 : Record 36;VATDifference@1002 : Decimal);
    BEGIN
      IF ToSalesLine."Document Type" <> ToSalesLine."Document Type"::Order THEN BEGIN
        ToSalesLine."Prepayment %" := 0;
        ToSalesLine."Prepayment VAT %" := 0;
        ToSalesLine."Prepmt. VAT Calc. Type" := 0;
        ToSalesLine."Prepayment VAT Identifier" := '';
        ToSalesLine."Prepayment VAT %" := 0;
        ToSalesLine."Prepayment Tax Group Code" := '';
        ToSalesLine."Prepmt. Line Amount" := 0;
        ToSalesLine."Prepmt. Amt. Incl. VAT" := 0;
      END;
      ToSalesLine."Prepmt. Amt. Inv." := 0;
      ToSalesLine."Prepmt. Amount Inv. (LCY)" := 0;
      ToSalesLine."Prepayment Amount" := 0;
      ToSalesLine."Prepmt. VAT Base Amt." := 0;
      ToSalesLine."Prepmt Amt to Deduct" := 0;
      ToSalesLine."Prepmt Amt Deducted" := 0;
      ToSalesLine."Prepmt. Amount Inv. Incl. VAT" := 0;
      ToSalesLine."Prepayment VAT Difference" := 0;
      ToSalesLine."Prepmt VAT Diff. to Deduct" := 0;
      ToSalesLine."Prepmt VAT Diff. Deducted" := 0;
      ToSalesLine."Prepmt. Amt. Incl. VAT" := 0;
      ToSalesLine."Prepmt. VAT Amount Inv. (LCY)" := 0;
      ToSalesLine."Quantity Shipped" := 0;
      ToSalesLine."Qty. Shipped (Base)" := 0;
      ToSalesLine."Return Qty. Received" := 0;
      ToSalesLine."Return Qty. Received (Base)" := 0;
      ToSalesLine."Quantity Invoiced" := 0;
      ToSalesLine."Qty. Invoiced (Base)" := 0;
      ToSalesLine."Reserved Quantity" := 0;
      ToSalesLine."Reserved Qty. (Base)" := 0;
      ToSalesLine."Qty. to Ship" := 0;
      ToSalesLine."Qty. to Ship (Base)" := 0;
      ToSalesLine."Return Qty. to Receive" := 0;
      ToSalesLine."Return Qty. to Receive (Base)" := 0;
      ToSalesLine."Qty. to Invoice" := 0;
      ToSalesLine."Qty. to Invoice (Base)" := 0;
      ToSalesLine."Qty. Shipped Not Invoiced" := 0;
      ToSalesLine."Return Qty. Rcd. Not Invd." := 0;
      ToSalesLine."Shipped Not Invoiced" := 0;
      ToSalesLine."Return Rcd. Not Invd." := 0;
      ToSalesLine."Qty. Shipped Not Invd. (Base)" := 0;
      ToSalesLine."Ret. Qty. Rcd. Not Invd.(Base)" := 0;
      ToSalesLine."Shipped Not Invoiced (LCY)" := 0;
      ToSalesLine."Return Rcd. Not Invd. (LCY)" := 0;
      ToSalesLine."Job No." := '';
      ToSalesLine."Job Task No." := '';
      ToSalesLine."Job Contract Entry No." := 0;
      IF ToSalesLine."Document Type" IN
         [ToSalesLine."Document Type"::"Blanket Order",
          ToSalesLine."Document Type"::"Credit Memo",
          ToSalesLine."Document Type"::"Return Order"]
      THEN BEGIN
        ToSalesLine."Blanket Order No." := '';
        ToSalesLine."Blanket Order Line No." := 0;
      END;
      ToSalesLine.InitOutstanding;
      IF ToSalesLine."Document Type" IN
         [ToSalesLine."Document Type"::"Return Order",ToSalesLine."Document Type"::"Credit Memo"]
      THEN
        ToSalesLine.InitQtyToReceive
      ELSE
        ToSalesLine.InitQtyToShip;
      ToSalesLine."VAT Difference" := VATDifference;
      ToSalesLine."Shipment No." := '';
      ToSalesLine."Shipment Line No." := 0;
      IF NOT CreateToHeader AND RecalculateLines THEN
        ToSalesLine."Shipment Date" := ToSalesHeader."Shipment Date";
      ToSalesLine."Appl.-from Item Entry" := 0;
      ToSalesLine."Appl.-to Item Entry" := 0;

      ToSalesLine."Purchase Order No." := '';
      ToSalesLine."Purch. Order Line No." := 0;
      ToSalesLine."Special Order Purchase No." := '';
      ToSalesLine."Special Order Purch. Line No." := 0;
    END;

    LOCAL PROCEDURE SetDefaultValuesToPurchLine@108(VAR ToPurchLine@1000 : Record 39;ToPurchHeader@1002 : Record 38;VATDifference@1001 : Decimal);
    BEGIN
      IF ToPurchLine."Document Type" <> ToPurchLine."Document Type"::Order THEN BEGIN
        ToPurchLine."Prepayment %" := 0;
        ToPurchLine."Prepayment VAT %" := 0;
        ToPurchLine."Prepmt. VAT Calc. Type" := 0;
        ToPurchLine."Prepayment VAT Identifier" := '';
        ToPurchLine."Prepayment VAT %" := 0;
        ToPurchLine."Prepayment Tax Group Code" := '';
        ToPurchLine."Prepmt. Line Amount" := 0;
        ToPurchLine."Prepmt. Amt. Incl. VAT" := 0;
      END;
      ToPurchLine."Prepmt. Amt. Inv." := 0;
      ToPurchLine."Prepmt. Amount Inv. (LCY)" := 0;
      ToPurchLine."Prepayment Amount" := 0;
      ToPurchLine."Prepmt. VAT Base Amt." := 0;
      ToPurchLine."Prepmt Amt to Deduct" := 0;
      ToPurchLine."Prepmt Amt Deducted" := 0;
      ToPurchLine."Prepmt. Amount Inv. Incl. VAT" := 0;
      ToPurchLine."Prepayment VAT Difference" := 0;
      ToPurchLine."Prepmt VAT Diff. to Deduct" := 0;
      ToPurchLine."Prepmt VAT Diff. Deducted" := 0;
      ToPurchLine."Prepmt. Amt. Incl. VAT" := 0;
      ToPurchLine."Prepmt. VAT Amount Inv. (LCY)" := 0;
      ToPurchLine."Quantity Received" := 0;
      ToPurchLine."Qty. Received (Base)" := 0;
      ToPurchLine."Return Qty. Shipped" := 0;
      ToPurchLine."Return Qty. Shipped (Base)" := 0;
      ToPurchLine."Quantity Invoiced" := 0;
      ToPurchLine."Qty. Invoiced (Base)" := 0;
      ToPurchLine."Reserved Quantity" := 0;
      ToPurchLine."Reserved Qty. (Base)" := 0;
      ToPurchLine."Qty. Rcd. Not Invoiced" := 0;
      ToPurchLine."Qty. Rcd. Not Invoiced (Base)" := 0;
      ToPurchLine."Return Qty. Shipped Not Invd." := 0;
      ToPurchLine."Ret. Qty. Shpd Not Invd.(Base)" := 0;
      ToPurchLine."Qty. to Receive" := 0;
      ToPurchLine."Qty. to Receive (Base)" := 0;
      ToPurchLine."Return Qty. to Ship" := 0;
      ToPurchLine."Return Qty. to Ship (Base)" := 0;
      ToPurchLine."Qty. to Invoice" := 0;
      ToPurchLine."Qty. to Invoice (Base)" := 0;
      ToPurchLine."Amt. Rcd. Not Invoiced" := 0;
      ToPurchLine."Amt. Rcd. Not Invoiced (LCY)" := 0;
      ToPurchLine."Return Shpd. Not Invd." := 0;
      ToPurchLine."Return Shpd. Not Invd. (LCY)" := 0;
      IF ToPurchLine."Document Type" IN
         [ToPurchLine."Document Type"::"Blanket Order",
          ToPurchLine."Document Type"::"Credit Memo",
          ToPurchLine."Document Type"::"Return Order"]
      THEN BEGIN
        ToPurchLine."Blanket Order No." := '';
        ToPurchLine."Blanket Order Line No." := 0;
      END;

      ToPurchLine.InitOutstanding;
      IF ToPurchLine."Document Type" IN
         [ToPurchLine."Document Type"::"Return Order",ToPurchLine."Document Type"::"Credit Memo"]
      THEN
        ToPurchLine.InitQtyToShip
      ELSE
        ToPurchLine.InitQtyToReceive;
      ToPurchLine."VAT Difference" := VATDifference;
      ToPurchLine."Receipt No." := '';
      ToPurchLine."Receipt Line No." := 0;
      IF NOT CreateToHeader THEN
        ToPurchLine."Expected Receipt Date" := ToPurchHeader."Expected Receipt Date";
      ToPurchLine."Appl.-to Item Entry" := 0;

      ToPurchLine."Sales Order No." := '';
      ToPurchLine."Sales Order Line No." := 0;
      ToPurchLine."Special Order Sales No." := '';
      ToPurchLine."Special Order Sales Line No." := 0;
    END;

    LOCAL PROCEDURE CopyItemTrackingEntries@126(SalesLine@1000 : Record 37;VAR PurchLine@1001 : Record 39;SalesPricesIncludingVAT@1006 : Boolean;PurchPricesIncludingVAT@1005 : Boolean);
    VAR
      TempItemLedgerEntry@1003 : TEMPORARY Record 32;
      TrackingSpecification@1008 : Record 336;
      ItemTrackingMgt@1002 : Codeunit 6500;
      MissingExCostRevLink@1004 : Boolean;
    BEGIN
      FindTrackingEntries(
        TempItemLedgerEntry,DATABASE::"Sales Line",TrackingSpecification."Source Subtype"::"5",
        SalesLine."Document No.",'',0,SalesLine."Line No.",SalesLine."No.");
      ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
        TempItemLedgerEntry,PurchLine,FALSE,MissingExCostRevLink,
        SalesPricesIncludingVAT,PurchPricesIncludingVAT,TRUE);
    END;

    LOCAL PROCEDURE FindTrackingEntries@125(VAR TempItemLedgerEntry@1007 : TEMPORARY Record 32;Type@1006 : Integer;Subtype@1005 : Integer;ID@1004 : Code[20];BatchName@1003 : Code[10];ProdOrderLine@1002 : Integer;RefNo@1001 : Integer;ItemNo@1000 : Code[20]);
    VAR
      TrackingSpecification@1008 : Record 336;
    BEGIN
      WITH TrackingSpecification DO BEGIN
        SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Batch Name",
          "Source Prod. Order Line","Source Ref. No.");
        SETRANGE("Source ID",ID);
        SETRANGE("Source Ref. No.",RefNo);
        SETRANGE("Source Type",Type);
        SETRANGE("Source Subtype",Subtype);
        SETRANGE("Source Batch Name",BatchName);
        SETRANGE("Source Prod. Order Line",ProdOrderLine);
        SETRANGE("Item No.",ItemNo);
        IF FINDSET THEN
          REPEAT
            AddItemLedgerEntry(TempItemLedgerEntry,"Lot No.","Serial No.","Entry No.");
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE AddItemLedgerEntry@127(VAR TempItemLedgerEntry@1000 : TEMPORARY Record 32;LotNo@1003 : Code[20];SerialNo@1004 : Code[20];EntryNo@1001 : Integer);
    VAR
      ItemLedgerEntry@1002 : Record 32;
    BEGIN
      IF (LotNo = '') AND (SerialNo = '') THEN
        EXIT;

      IF NOT ItemLedgerEntry.GET(EntryNo) THEN
        EXIT;

      TempItemLedgerEntry := ItemLedgerEntry;
      IF TempItemLedgerEntry.INSERT THEN;
    END;

    LOCAL PROCEDURE CopyFieldsFromOldSalesHeader@111(VAR ToSalesHeader@1000 : Record 36;OldSalesHeader@1001 : Record 36);
    BEGIN
      WITH ToSalesHeader DO BEGIN
        "No. Series" := OldSalesHeader."No. Series";
        "Posting Description" := OldSalesHeader."Posting Description";
        "Posting No." := OldSalesHeader."Posting No.";
        "Posting No. Series" := OldSalesHeader."Posting No. Series";
        "Shipping No." := OldSalesHeader."Shipping No.";
        "Shipping No. Series" := OldSalesHeader."Shipping No. Series";
        "Return Receipt No." := OldSalesHeader."Return Receipt No.";
        "Return Receipt No. Series" := OldSalesHeader."Return Receipt No. Series";
        "Prepayment No. Series" := OldSalesHeader."Prepayment No. Series";
        "Prepayment No." := OldSalesHeader."Prepayment No.";
        "Prepmt. Posting Description" := OldSalesHeader."Prepmt. Posting Description";
        "Prepmt. Cr. Memo No. Series" := OldSalesHeader."Prepmt. Cr. Memo No. Series";
        "Prepmt. Cr. Memo No." := OldSalesHeader."Prepmt. Cr. Memo No.";
        "Prepmt. Posting Description" := OldSalesHeader."Prepmt. Posting Description";
        SetSalespersonPurchaserCode("Salesperson Code");
      END
    END;

    LOCAL PROCEDURE CopyFieldsFromOldPurchHeader@119(VAR ToPurchHeader@1000 : Record 38;OldPurchHeader@1001 : Record 38);
    BEGIN
      WITH ToPurchHeader DO BEGIN
        "No. Series" := OldPurchHeader."No. Series";
        "Posting Description" := OldPurchHeader."Posting Description";
        "Posting No." := OldPurchHeader."Posting No.";
        "Posting No. Series" := OldPurchHeader."Posting No. Series";
        "Receiving No." := OldPurchHeader."Receiving No.";
        "Receiving No. Series" := OldPurchHeader."Receiving No. Series";
        "Return Shipment No." := OldPurchHeader."Return Shipment No.";
        "Return Shipment No. Series" := OldPurchHeader."Return Shipment No. Series";
        "Prepayment No. Series" := OldPurchHeader."Prepayment No. Series";
        "Prepayment No." := OldPurchHeader."Prepayment No.";
        "Prepmt. Posting Description" := OldPurchHeader."Prepmt. Posting Description";
        "Prepmt. Cr. Memo No. Series" := OldPurchHeader."Prepmt. Cr. Memo No. Series";
        "Prepmt. Cr. Memo No." := OldPurchHeader."Prepmt. Cr. Memo No.";
        "Prepmt. Posting Description" := OldPurchHeader."Prepmt. Posting Description";
        SetSalespersonPurchaserCode("Purchaser Code");
      END;
    END;

    LOCAL PROCEDURE CheckFromSalesHeader@105(SalesHeaderFrom@1000 : Record 36;SalesHeaderTo@1001 : Record 36);
    BEGIN
      WITH SalesHeaderTo DO BEGIN
        SalesHeaderFrom.TESTFIELD("Sell-to Customer No.","Sell-to Customer No.");
        SalesHeaderFrom.TESTFIELD("Bill-to Customer No.","Bill-to Customer No.");
        SalesHeaderFrom.TESTFIELD("Customer Posting Group","Customer Posting Group");
        SalesHeaderFrom.TESTFIELD("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
        SalesHeaderFrom.TESTFIELD("Currency Code","Currency Code");
        SalesHeaderFrom.TESTFIELD("Prices Including VAT","Prices Including VAT");
      END;
    END;

    LOCAL PROCEDURE CheckFromSalesShptHeader@106(SalesShipmentHeaderFrom@1000 : Record 110;SalesHeaderTo@1001 : Record 36);
    BEGIN
      WITH SalesHeaderTo DO BEGIN
        SalesShipmentHeaderFrom.TESTFIELD("Sell-to Customer No.","Sell-to Customer No.");
        SalesShipmentHeaderFrom.TESTFIELD("Bill-to Customer No.","Bill-to Customer No.");
        SalesShipmentHeaderFrom.TESTFIELD("Customer Posting Group","Customer Posting Group");
        SalesShipmentHeaderFrom.TESTFIELD("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
        SalesShipmentHeaderFrom.TESTFIELD("Currency Code","Currency Code");
        SalesShipmentHeaderFrom.TESTFIELD("Prices Including VAT","Prices Including VAT");
      END;
    END;

    LOCAL PROCEDURE CheckFromSalesInvHeader@109(SalesInvoiceHeaderFrom@1000 : Record 112;SalesHeaderTo@1001 : Record 36);
    BEGIN
      WITH SalesHeaderTo DO BEGIN
        SalesInvoiceHeaderFrom.TESTFIELD("Sell-to Customer No.","Sell-to Customer No.");
        SalesInvoiceHeaderFrom.TESTFIELD("Bill-to Customer No.","Bill-to Customer No.");
        SalesInvoiceHeaderFrom.TESTFIELD("Customer Posting Group","Customer Posting Group");
        SalesInvoiceHeaderFrom.TESTFIELD("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
        SalesInvoiceHeaderFrom.TESTFIELD("Currency Code","Currency Code");
        SalesInvoiceHeaderFrom.TESTFIELD("Prices Including VAT","Prices Including VAT");
      END;
    END;

    LOCAL PROCEDURE CheckFromSalesReturnRcptHeader@107(ReturnReceiptHeaderFrom@1000 : Record 6660;SalesHeaderTo@1001 : Record 36);
    BEGIN
      WITH SalesHeaderTo DO BEGIN
        ReturnReceiptHeaderFrom.TESTFIELD("Sell-to Customer No.","Sell-to Customer No.");
        ReturnReceiptHeaderFrom.TESTFIELD("Bill-to Customer No.","Bill-to Customer No.");
        ReturnReceiptHeaderFrom.TESTFIELD("Customer Posting Group","Customer Posting Group");
        ReturnReceiptHeaderFrom.TESTFIELD("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
        ReturnReceiptHeaderFrom.TESTFIELD("Currency Code","Currency Code");
        ReturnReceiptHeaderFrom.TESTFIELD("Prices Including VAT","Prices Including VAT");
      END;
    END;

    LOCAL PROCEDURE CheckFromSalesCrMemoHeader@110(SalesCrMemoHeaderFrom@1000 : Record 114;SalesHeaderTo@1001 : Record 36);
    BEGIN
      WITH SalesHeaderTo DO BEGIN
        SalesCrMemoHeaderFrom.TESTFIELD("Sell-to Customer No.","Sell-to Customer No.");
        SalesCrMemoHeaderFrom.TESTFIELD("Bill-to Customer No.","Bill-to Customer No.");
        SalesCrMemoHeaderFrom.TESTFIELD("Customer Posting Group","Customer Posting Group");
        SalesCrMemoHeaderFrom.TESTFIELD("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
        SalesCrMemoHeaderFrom.TESTFIELD("Currency Code","Currency Code");
        SalesCrMemoHeaderFrom.TESTFIELD("Prices Including VAT","Prices Including VAT");
      END;
    END;

    LOCAL PROCEDURE CheckFromPurchaseHeader@118(PurchaseHeaderFrom@1000 : Record 38;PurchaseHeaderTo@1001 : Record 38);
    BEGIN
      WITH PurchaseHeaderTo DO BEGIN
        PurchaseHeaderFrom.TESTFIELD("Buy-from Vendor No.","Buy-from Vendor No.");
        PurchaseHeaderFrom.TESTFIELD("Pay-to Vendor No.","Pay-to Vendor No.");
        PurchaseHeaderFrom.TESTFIELD("Vendor Posting Group","Vendor Posting Group");
        PurchaseHeaderFrom.TESTFIELD("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
        PurchaseHeaderFrom.TESTFIELD("Currency Code","Currency Code");
      END;
    END;

    LOCAL PROCEDURE CheckFromPurchaseRcptHeader@117(PurchRcptHeaderFrom@1000 : Record 120;PurchaseHeaderTo@1001 : Record 38);
    BEGIN
      WITH PurchaseHeaderTo DO BEGIN
        PurchRcptHeaderFrom.TESTFIELD("Buy-from Vendor No.","Buy-from Vendor No.");
        PurchRcptHeaderFrom.TESTFIELD("Pay-to Vendor No.","Pay-to Vendor No.");
        PurchRcptHeaderFrom.TESTFIELD("Vendor Posting Group","Vendor Posting Group");
        PurchRcptHeaderFrom.TESTFIELD("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
        PurchRcptHeaderFrom.TESTFIELD("Currency Code","Currency Code");
      END;
    END;

    LOCAL PROCEDURE CheckFromPurchaseInvHeader@116(PurchInvHeaderFrom@1000 : Record 122;PurchaseHeaderTo@1001 : Record 38);
    BEGIN
      WITH PurchaseHeaderTo DO BEGIN
        PurchInvHeaderFrom.TESTFIELD("Buy-from Vendor No.","Buy-from Vendor No.");
        PurchInvHeaderFrom.TESTFIELD("Pay-to Vendor No.","Pay-to Vendor No.");
        PurchInvHeaderFrom.TESTFIELD("Vendor Posting Group","Vendor Posting Group");
        PurchInvHeaderFrom.TESTFIELD("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
        PurchInvHeaderFrom.TESTFIELD("Currency Code","Currency Code");
      END;
    END;

    LOCAL PROCEDURE CheckFromPurchaseReturnShptHeader@114(ReturnShipmentHeaderFrom@1000 : Record 6650;PurchaseHeaderTo@1001 : Record 38);
    BEGIN
      WITH PurchaseHeaderTo DO BEGIN
        ReturnShipmentHeaderFrom.TESTFIELD("Buy-from Vendor No.","Buy-from Vendor No.");
        ReturnShipmentHeaderFrom.TESTFIELD("Pay-to Vendor No.","Pay-to Vendor No.");
        ReturnShipmentHeaderFrom.TESTFIELD("Vendor Posting Group","Vendor Posting Group");
        ReturnShipmentHeaderFrom.TESTFIELD("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
        ReturnShipmentHeaderFrom.TESTFIELD("Currency Code","Currency Code");
      END;
    END;

    LOCAL PROCEDURE CheckFromPurchaseCrMemoHeader@115(PurchCrMemoHdrFrom@1000 : Record 124;PurchaseHeaderTo@1001 : Record 38);
    BEGIN
      WITH PurchaseHeaderTo DO BEGIN
        PurchCrMemoHdrFrom.TESTFIELD("Buy-from Vendor No.","Buy-from Vendor No.");
        PurchCrMemoHdrFrom.TESTFIELD("Pay-to Vendor No.","Pay-to Vendor No.");
        PurchCrMemoHdrFrom.TESTFIELD("Vendor Posting Group","Vendor Posting Group");
        PurchCrMemoHdrFrom.TESTFIELD("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
        PurchCrMemoHdrFrom.TESTFIELD("Currency Code","Currency Code");
      END;
    END;

    LOCAL PROCEDURE CopyDeferrals@74(DeferralDocType@1010 : Integer;FromDocType@1001 : Integer;FromDocNo@1002 : Code[20];FromLineNo@1003 : Integer;ToDocType@1000 : Integer;ToDocNo@1008 : Code[20];ToLineNo@1009 : Integer) StartDate : Date;
    VAR
      FromDeferralHeader@1004 : Record 1701;
      FromDeferralLine@1005 : Record 1702;
      ToDeferralHeader@1006 : Record 1701;
      ToDeferralLine@1007 : Record 1702;
      SalesCommentLine@1011 : Record 44;
    BEGIN
      StartDate := 0D;
      IF FromDeferralHeader.GET(
           DeferralDocType,'','',
           FromDocType,FromDocNo,FromLineNo)
      THEN BEGIN
        RemoveDefaultDeferralCode(DeferralDocType,ToDocType,ToDocNo,ToLineNo);
        ToDeferralHeader.INIT;
        ToDeferralHeader.TRANSFERFIELDS(FromDeferralHeader);
        ToDeferralHeader."Document Type" := ToDocType;
        ToDeferralHeader."Document No." := ToDocNo;
        ToDeferralHeader."Line No." := ToLineNo;
        ToDeferralHeader.INSERT;
        FromDeferralLine.SETRANGE("Deferral Doc. Type",DeferralDocType);
        FromDeferralLine.SETRANGE("Gen. Jnl. Template Name",'');
        FromDeferralLine.SETRANGE("Gen. Jnl. Batch Name",'');
        FromDeferralLine.SETRANGE("Document Type",FromDocType);
        FromDeferralLine.SETRANGE("Document No.",FromDocNo);
        FromDeferralLine.SETRANGE("Line No.",FromLineNo);
        IF FromDeferralLine.FINDSET THEN
          WITH ToDeferralLine DO
            REPEAT
              INIT;
              TRANSFERFIELDS(FromDeferralLine);
              "Document Type" := ToDocType;
              "Document No." := ToDocNo;
              "Line No." := ToLineNo;
              INSERT;
            UNTIL FromDeferralLine.NEXT = 0;
        IF ToDocType = SalesCommentLine."Document Type"::"Return Order" THEN
          StartDate := FromDeferralHeader."Start Date"
      END;
    END;

    LOCAL PROCEDURE CopyPostedDeferrals@112(DeferralDocType@1010 : Integer;FromDocType@1000 : Integer;FromDocNo@1001 : Code[20];FromLineNo@1002 : Integer;ToDocType@1003 : Integer;ToDocNo@1004 : Code[20];ToLineNo@1005 : Integer) StartDate : Date;
    VAR
      PostedDeferralHeader@1006 : Record 1704;
      PostedDeferralLine@1007 : Record 1705;
      DeferralHeader@1008 : Record 1701;
      DeferralLine@1009 : Record 1702;
      SalesCommentLine@1011 : Record 44;
      InitialAmountToDefer@1012 : Decimal;
    BEGIN
      StartDate := 0D;
      IF PostedDeferralHeader.GET(DeferralDocType,'','',
           FromDocType,FromDocNo,FromLineNo)
      THEN BEGIN
        RemoveDefaultDeferralCode(DeferralDocType,ToDocType,ToDocNo,ToLineNo);
        InitialAmountToDefer := 0;
        DeferralHeader.INIT;
        DeferralHeader.TRANSFERFIELDS(PostedDeferralHeader);
        DeferralHeader."Document Type" := ToDocType;
        DeferralHeader."Document No." := ToDocNo;
        DeferralHeader."Line No." := ToLineNo;
        DeferralHeader.INSERT;
        PostedDeferralLine.SETRANGE("Deferral Doc. Type",DeferralDocType);
        PostedDeferralLine.SETRANGE("Gen. Jnl. Document No.",'');
        PostedDeferralLine.SETRANGE("Account No.",'');
        PostedDeferralLine.SETRANGE("Document Type",FromDocType);
        PostedDeferralLine.SETRANGE("Document No.",FromDocNo);
        PostedDeferralLine.SETRANGE("Line No.",FromLineNo);
        IF PostedDeferralLine.FINDSET THEN
          WITH DeferralLine DO
            REPEAT
              INIT;
              TRANSFERFIELDS(PostedDeferralLine);
              "Document Type" := ToDocType;
              "Document No." := ToDocNo;
              "Line No." := ToLineNo;
              IF PostedDeferralLine."Amount (LCY)" <> 0.0 THEN
                InitialAmountToDefer := InitialAmountToDefer + PostedDeferralLine."Amount (LCY)"
              ELSE
                InitialAmountToDefer := InitialAmountToDefer + PostedDeferralLine.Amount;
              INSERT;
            UNTIL PostedDeferralLine.NEXT = 0;
        IF ToDocType = SalesCommentLine."Document Type"::"Return Order" THEN
          StartDate := PostedDeferralHeader."Start Date";
        IF DeferralHeader.GET(DeferralDocType,'','',ToDocType,ToDocNo,ToLineNo) THEN BEGIN
          DeferralHeader."Initial Amount to Defer" := InitialAmountToDefer;
          DeferralHeader.MODIFY;
        END;
      END;
    END;

    LOCAL PROCEDURE IsDeferralToBeCopied@113(DeferralDocType@1004 : Integer;ToDocType@1000 : Option;FromDocType@1001 : Option) : Boolean;
    VAR
      SalesLine@1002 : Record 37;
      SalesCommentLine@1003 : Record 44;
      PurchLine@1006 : Record 39;
      PurchCommentLine@1005 : Record 43;
      DeferralHeader@1007 : Record 1701;
    BEGIN
      IF DeferralDocType = DeferralHeader."Deferral Doc. Type"::Sales THEN
        CASE ToDocType OF
          SalesLine."Document Type"::Order,
          SalesLine."Document Type"::Invoice,
          SalesLine."Document Type"::"Credit Memo",
          SalesLine."Document Type"::"Return Order":
            CASE FromDocType OF
              SalesCommentLine."Document Type"::Order,
              SalesCommentLine."Document Type"::Invoice,
              SalesCommentLine."Document Type"::"Credit Memo",
              SalesCommentLine."Document Type"::"Return Order",
              SalesCommentLine."Document Type"::"Posted Invoice",
              SalesCommentLine."Document Type"::"Posted Credit Memo":
                EXIT(TRUE)
            END;
        END
      ELSE
        IF DeferralDocType = DeferralHeader."Deferral Doc. Type"::Purchase THEN
          CASE ToDocType OF
            PurchLine."Document Type"::Order,
            PurchLine."Document Type"::Invoice,
            PurchLine."Document Type"::"Credit Memo",
            PurchLine."Document Type"::"Return Order":
              CASE FromDocType OF
                PurchCommentLine."Document Type"::Order,
                PurchCommentLine."Document Type"::Invoice,
                PurchCommentLine."Document Type"::"Credit Memo",
                PurchCommentLine."Document Type"::"Return Order",
                PurchCommentLine."Document Type"::"Posted Invoice",
                PurchCommentLine."Document Type"::"Posted Credit Memo":
                  EXIT(TRUE)
              END;
          END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsDeferralToBeDefaulted@120(DeferralDocType@1004 : Integer;ToDocType@1000 : Option;FromDocType@1001 : Option) : Boolean;
    VAR
      SalesLine@1002 : Record 37;
      SalesCommentLine@1003 : Record 44;
      PurchLine@1006 : Record 39;
      PurchCommentLine@1005 : Record 43;
      DeferralHeader@1007 : Record 1701;
    BEGIN
      IF DeferralDocType = DeferralHeader."Deferral Doc. Type"::Sales THEN
        CASE ToDocType OF
          SalesLine."Document Type"::Order,
          SalesLine."Document Type"::Invoice,
          SalesLine."Document Type"::"Credit Memo",
          SalesLine."Document Type"::"Return Order":
            CASE FromDocType OF
              SalesCommentLine."Document Type"::Quote,
              SalesCommentLine."Document Type"::"Blanket Order",
              SalesCommentLine."Document Type"::Shipment,
              SalesCommentLine."Document Type"::"Posted Return Receipt":
                EXIT(TRUE)
            END;
        END
      ELSE
        IF DeferralDocType = DeferralHeader."Deferral Doc. Type"::Purchase THEN
          CASE ToDocType OF
            PurchLine."Document Type"::Order,
            PurchLine."Document Type"::Invoice,
            PurchLine."Document Type"::"Credit Memo",
            PurchLine."Document Type"::"Return Order":
              CASE FromDocType OF
                PurchCommentLine."Document Type"::Quote,
                PurchCommentLine."Document Type"::"Blanket Order",
                PurchCommentLine."Document Type"::Receipt,
                PurchCommentLine."Document Type"::"Posted Return Shipment":
                  EXIT(TRUE)
              END;
          END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsDeferralPosted@121(DeferralDocType@1002 : Integer;FromDocType@1000 : Option) : Boolean;
    VAR
      SalesCommentLine@1001 : Record 44;
      PurchCommentLine@1003 : Record 43;
      DeferralHeader@1004 : Record 1701;
    BEGIN
      IF DeferralDocType = DeferralHeader."Deferral Doc. Type"::Sales THEN
        CASE FromDocType OF
          SalesCommentLine."Document Type"::Shipment,
          SalesCommentLine."Document Type"::"Posted Invoice",
          SalesCommentLine."Document Type"::"Posted Credit Memo",
          SalesCommentLine."Document Type"::"Posted Return Receipt":
            EXIT(TRUE);
        END
      ELSE
        IF DeferralDocType = DeferralHeader."Deferral Doc. Type"::Purchase THEN
          CASE FromDocType OF
            PurchCommentLine."Document Type"::Receipt,
            PurchCommentLine."Document Type"::"Posted Invoice",
            PurchCommentLine."Document Type"::"Posted Credit Memo",
            PurchCommentLine."Document Type"::"Posted Return Shipment":
              EXIT(TRUE);
          END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE InitSalesDeferralCode@122(VAR ToSalesLine@1000 : Record 37);
    VAR
      GLAccount@1001 : Record 15;
      Item@1002 : Record 27;
      Resource@1003 : Record 156;
    BEGIN
      CASE ToSalesLine."Document Type" OF
        ToSalesLine."Document Type"::Order,
        ToSalesLine."Document Type"::Invoice,
        ToSalesLine."Document Type"::"Credit Memo",
        ToSalesLine."Document Type"::"Return Order":
          CASE ToSalesLine.Type OF
            ToSalesLine.Type::"G/L Account":
              BEGIN
                GLAccount.GET(ToSalesLine."No.");
                ToSalesLine.VALIDATE("Deferral Code",GLAccount."Default Deferral Template Code");
              END;
            ToSalesLine.Type::Item:
              BEGIN
                Item.GET(ToSalesLine."No.");
                ToSalesLine.VALIDATE("Deferral Code",Item."Default Deferral Template Code");
              END;
            ToSalesLine.Type::Resource:
              BEGIN
                Resource.GET(ToSalesLine."No.");
                ToSalesLine.VALIDATE("Deferral Code",Resource."Default Deferral Template Code");
              END;
          END;
      END;
    END;

    LOCAL PROCEDURE InitFromSalesLine2@123(VAR FromSalesLine2@1000 : Record 37;VAR FromSalesLineBuf@1001 : Record 37);
    BEGIN
      // Empty buffer fields
      FromSalesLine2 := FromSalesLineBuf;
      FromSalesLine2."Shipment No." := '';
      FromSalesLine2."Shipment Line No." := 0;
      FromSalesLine2."Return Receipt No." := '';
      FromSalesLine2."Return Receipt Line No." := 0;
    END;

    LOCAL PROCEDURE RemoveDefaultDeferralCode@124(DeferralDocType@1005 : Integer;DocType@1002 : Integer;DocNo@1001 : Code[20];LineNo@1000 : Integer);
    VAR
      DeferralHeader@1003 : Record 1701;
      DeferralLine@1004 : Record 1702;
    BEGIN
      IF DeferralHeader.GET(DeferralDocType,'','',DocType,DocNo,LineNo) THEN
        DeferralHeader.DELETE;

      DeferralLine.SETRANGE("Deferral Doc. Type",DeferralDocType);
      DeferralLine.SETRANGE("Gen. Jnl. Template Name",'');
      DeferralLine.SETRANGE("Gen. Jnl. Batch Name",'');
      DeferralLine.SETRANGE("Document Type",DocType);
      DeferralLine.SETRANGE("Document No.",DocNo);
      DeferralLine.SETRANGE("Line No.",LineNo);
      DeferralLine.DELETEALL;
    END;

    [External]
    PROCEDURE DeferralTypeForSalesDoc@128(DocType@1001 : Option) : Integer;
    VAR
      SalesCommentLine@1000 : Record 44;
    BEGIN
      CASE DocType OF
        SalesDocType::Quote:
          EXIT(SalesCommentLine."Document Type"::Quote);
        SalesDocType::"Blanket Order":
          EXIT(SalesCommentLine."Document Type"::"Blanket Order");
        SalesDocType::Order:
          EXIT(SalesCommentLine."Document Type"::Order);
        SalesDocType::Invoice:
          EXIT(SalesCommentLine."Document Type"::Invoice);
        SalesDocType::"Return Order":
          EXIT(SalesCommentLine."Document Type"::"Return Order");
        SalesDocType::"Credit Memo":
          EXIT(SalesCommentLine."Document Type"::"Credit Memo");
        SalesDocType::"Posted Shipment":
          EXIT(SalesCommentLine."Document Type"::Shipment);
        SalesDocType::"Posted Invoice":
          EXIT(SalesCommentLine."Document Type"::"Posted Invoice");
        SalesDocType::"Posted Return Receipt":
          EXIT(SalesCommentLine."Document Type"::"Posted Return Receipt");
        SalesDocType::"Posted Credit Memo":
          EXIT(SalesCommentLine."Document Type"::"Posted Credit Memo");
      END;
    END;

    [External]
    PROCEDURE DeferralTypeForPurchDoc@129(DocType@1001 : Option) : Integer;
    VAR
      PurchCommentLine@1000 : Record 43;
    BEGIN
      CASE DocType OF
        PurchDocType::Quote:
          EXIT(PurchCommentLine."Document Type"::Quote);
        PurchDocType::"Blanket Order":
          EXIT(PurchCommentLine."Document Type"::"Blanket Order");
        PurchDocType::Order:
          EXIT(PurchCommentLine."Document Type"::Order);
        PurchDocType::Invoice:
          EXIT(PurchCommentLine."Document Type"::Invoice);
        PurchDocType::"Return Order":
          EXIT(PurchCommentLine."Document Type"::"Return Order");
        PurchDocType::"Credit Memo":
          EXIT(PurchCommentLine."Document Type"::"Credit Memo");
        PurchDocType::"Posted Receipt":
          EXIT(PurchCommentLine."Document Type"::Receipt);
        PurchDocType::"Posted Invoice":
          EXIT(PurchCommentLine."Document Type"::"Posted Invoice");
        PurchDocType::"Posted Return Shipment":
          EXIT(PurchCommentLine."Document Type"::"Posted Return Shipment");
        PurchDocType::"Posted Credit Memo":
          EXIT(PurchCommentLine."Document Type"::"Posted Credit Memo");
      END;
    END;

    LOCAL PROCEDURE InitPurchDeferralCode@131(VAR ToPurchLine@1000 : Record 39);
    VAR
      GLAccount@1001 : Record 15;
      Item@1002 : Record 27;
    BEGIN
      CASE ToPurchLine."Document Type" OF
        ToPurchLine."Document Type"::Order,
        ToPurchLine."Document Type"::Invoice,
        ToPurchLine."Document Type"::"Credit Memo",
        ToPurchLine."Document Type"::"Return Order":
          CASE ToPurchLine.Type OF
            ToPurchLine.Type::"G/L Account":
              BEGIN
                GLAccount.GET(ToPurchLine."No.");
                ToPurchLine.VALIDATE("Deferral Code",GLAccount."Default Deferral Template Code");
              END;
            ToPurchLine.Type::Item:
              BEGIN
                Item.GET(ToPurchLine."No.");
                ToPurchLine.VALIDATE("Deferral Code",Item."Default Deferral Template Code");
              END;
          END;
      END;
    END;

    LOCAL PROCEDURE CopySalesPostedDeferrals@138(ToSalesLine@1012 : Record 37;DeferralDocType@1010 : Integer;FromDocType@1000 : Integer;FromDocNo@1001 : Code[20];FromLineNo@1002 : Integer;ToDocType@1003 : Integer;ToDocNo@1004 : Code[20];ToLineNo@1005 : Integer);
    BEGIN
      ToSalesLine."Returns Deferral Start Date" :=
        CopyPostedDeferrals(DeferralDocType,
          FromDocType,FromDocNo,FromLineNo,
          ToDocType,ToDocNo,ToLineNo);
      ToSalesLine.MODIFY;
    END;

    LOCAL PROCEDURE CopyPurchPostedDeferrals@139(ToPurchaseLine@1012 : Record 39;DeferralDocType@1010 : Integer;FromDocType@1000 : Integer;FromDocNo@1001 : Code[20];FromLineNo@1002 : Integer;ToDocType@1003 : Integer;ToDocNo@1004 : Code[20];ToLineNo@1005 : Integer);
    BEGIN
      ToPurchaseLine."Returns Deferral Start Date" :=
        CopyPostedDeferrals(DeferralDocType,
          FromDocType,FromDocNo,FromLineNo,
          ToDocType,ToDocNo,ToLineNo);
      ToPurchaseLine.MODIFY;
    END;

    LOCAL PROCEDURE CheckDateOrder@37(PostingNo@1003 : Code[20];PostingNoSeries@1000 : Code[20];OldPostingDate@1004 : Date;NewPostingDate@1001 : Date) : Boolean;
    VAR
      NoSeries@1002 : Record 308;
    BEGIN
      IF IncludeHeader THEN
        IF (PostingNo <> '') AND (OldPostingDate <> NewPostingDate) THEN
          IF NoSeries.GET(PostingNoSeries) THEN
            IF NoSeries."Date Order" THEN
              EXIT(CONFIRM(DiffPostDateOrderQst));
      EXIT(TRUE)
    END;

    LOCAL PROCEDURE CheckSalesDocItselfCopy@49(FromSalesHeader@1000 : Record 36;ToSalesHeader@1001 : Record 36);
    BEGIN
      IF (FromSalesHeader."Document Type" = ToSalesHeader."Document Type") AND
         (FromSalesHeader."No." = ToSalesHeader."No.")
      THEN
        ERROR(Text001,ToSalesHeader."Document Type",ToSalesHeader."No.");
    END;

    LOCAL PROCEDURE CheckPurchDocItselfCopy@58(FromPurchHeader@1000 : Record 38;ToPurchHeader@1001 : Record 38);
    BEGIN
      IF (FromPurchHeader."Document Type" = ToPurchHeader."Document Type") AND
         (FromPurchHeader."No." = ToPurchHeader."No.")
      THEN
        ERROR(Text001,ToPurchHeader."Document Type",ToPurchHeader."No.");
    END;

    LOCAL PROCEDURE UpdateCustLedgEntry@43(VAR ToSalesHeader@1004 : Record 36;FromDocType@1000 : Option;FromDocNo@1002 : Code[20]);
    VAR
      CustLedgEntry@1001 : Record 21;
    BEGIN
      CustLedgEntry.SETCURRENTKEY("Document No.");
      IF FromDocType = SalesDocType::"Posted Invoice" THEN
        CustLedgEntry.SETRANGE("Document Type",CustLedgEntry."Document Type"::Invoice)
      ELSE
        CustLedgEntry.SETRANGE("Document Type",CustLedgEntry."Document Type"::"Credit Memo");
      CustLedgEntry.SETRANGE("Document No.",FromDocNo);
      CustLedgEntry.SETRANGE("Customer No.",ToSalesHeader."Bill-to Customer No.");
      CustLedgEntry.SETRANGE(Open,TRUE);
      IF CustLedgEntry.FINDFIRST THEN BEGIN
        ToSalesHeader."Bal. Account No." := '';
        IF FromDocType = SalesDocType::"Posted Invoice" THEN BEGIN
          ToSalesHeader."Applies-to Doc. Type" := ToSalesHeader."Applies-to Doc. Type"::Invoice;
          ToSalesHeader."Applies-to Doc. No." := FromDocNo;
        END ELSE BEGIN
          ToSalesHeader."Applies-to Doc. Type" := ToSalesHeader."Applies-to Doc. Type"::"Credit Memo";
          ToSalesHeader."Applies-to Doc. No." := FromDocNo;
        END;
        CustLedgEntry.CALCFIELDS("Remaining Amount");
        CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
        CustLedgEntry."Accepted Payment Tolerance" := 0;
        CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
      END;
    END;

    [External]
    PROCEDURE UpdateVendLedgEntry@66(VAR ToPurchHeader@1001 : Record 38;FromDocType@1002 : Option;FromDocNo@1003 : Code[20]);
    VAR
      VendLedgEntry@1000 : Record 25;
    BEGIN
      VendLedgEntry.SETCURRENTKEY("Document No.");
      IF FromDocType = PurchDocType::"Posted Invoice" THEN
        VendLedgEntry.SETRANGE("Document Type",VendLedgEntry."Document Type"::Invoice)
      ELSE
        VendLedgEntry.SETRANGE("Document Type",VendLedgEntry."Document Type"::"Credit Memo");
      VendLedgEntry.SETRANGE("Document No.",FromDocNo);
      VendLedgEntry.SETRANGE("Vendor No.",ToPurchHeader."Pay-to Vendor No.");
      VendLedgEntry.SETRANGE(Open,TRUE);
      IF VendLedgEntry.FINDFIRST THEN BEGIN
        IF FromDocType = PurchDocType::"Posted Invoice" THEN BEGIN
          ToPurchHeader."Applies-to Doc. Type" := ToPurchHeader."Applies-to Doc. Type"::Invoice;
          ToPurchHeader."Applies-to Doc. No." := FromDocNo;
        END ELSE BEGIN
          ToPurchHeader."Applies-to Doc. Type" := ToPurchHeader."Applies-to Doc. Type"::"Credit Memo";
          ToPurchHeader."Applies-to Doc. No." := FromDocNo;
        END;
        VendLedgEntry.CALCFIELDS("Remaining Amount");
        VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
        VendLedgEntry."Accepted Payment Tolerance" := 0;
        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
        CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
      END;
    END;

    LOCAL PROCEDURE ExtTxtAttachedToPosSalesLine@130(SalesHeader@1002 : Record 36;MoveNegLines@1003 : Boolean;AttachedToLineNo@1001 : Integer) : Boolean;
    VAR
      AttachedToSalesLine@1000 : Record 37;
    BEGIN
      IF MoveNegLines THEN
        IF AttachedToLineNo <> 0 THEN
          IF AttachedToSalesLine.GET(SalesHeader."Document Type",SalesHeader."No.",AttachedToLineNo) THEN
            IF AttachedToSalesLine.Quantity >= 0 THEN
              EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ExtTxtAttachedToPosPurchLine@134(PurchHeader@1002 : Record 38;MoveNegLines@1003 : Boolean;AttachedToLineNo@1001 : Integer) : Boolean;
    VAR
      AttachedToPurchLine@1000 : Record 39;
    BEGIN
      IF MoveNegLines THEN
        IF AttachedToLineNo <> 0 THEN
          IF AttachedToPurchLine.GET(PurchHeader."Document Type",PurchHeader."No.",AttachedToLineNo) THEN
            IF AttachedToPurchLine.Quantity >= 0 THEN
              EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE SalesDocCanReceiveTracking@64(SalesHeader@1000 : Record 36) : Boolean;
    BEGIN
      EXIT(
        (SalesHeader."Document Type" <> SalesHeader."Document Type"::Quote) AND
        (SalesHeader."Document Type" <> SalesHeader."Document Type"::"Blanket Order"));
    END;

    LOCAL PROCEDURE PurchaseDocCanReceiveTracking@69(PurchaseHeader@1000 : Record 38) : Boolean;
    BEGIN
      EXIT(
        (PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Quote) AND
        (PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::"Blanket Order"));
    END;

    LOCAL PROCEDURE CheckFirstLineShipped@177(DocNo@1000 : Code[20];ShipmentLineNo@1001 : Integer;VAR SalesCombDocLineNo@1003 : Integer;VAR NextLineNo@1004 : Integer;VAR FirstLineShipped@1002 : Boolean);
    BEGIN
      IF (DocNo = '') AND (ShipmentLineNo = 0) AND FirstLineShipped THEN BEGIN
        FirstLineShipped := FALSE;
        SalesCombDocLineNo := NextLineNo;
        NextLineNo := NextLineNo + 10000;
      END;
    END;

    LOCAL PROCEDURE SetTempSalesInvLine@78(FromSalesInvLine@1000 : Record 113;VAR TempSalesInvLine@1001 : TEMPORARY Record 113;VAR SalesInvLineCount@1003 : Integer;VAR NextLineNo@1004 : Integer;VAR FirstLineText@1002 : Boolean);
    BEGIN
      IF FromSalesInvLine.Type = FromSalesInvLine.Type::Item THEN BEGIN
        SalesInvLineCount += 1;
        TempSalesInvLine := FromSalesInvLine;
        TempSalesInvLine.INSERT;
        IF FirstLineText THEN BEGIN
          NextLineNo := NextLineNo + 10000;
          FirstLineText := FALSE;
        END;
      END ELSE
        IF FromSalesInvLine.Type = FromSalesInvLine.Type::" " THEN
          FirstLineText := TRUE;
    END;

    LOCAL PROCEDURE InitAndCheckSalesDocuments@143(FromDocType@1001 : Option;FromDocNo@1003 : Code[20];VAR FromSalesHeader@1002 : Record 36;VAR ToSalesHeader@1000 : Record 36;VAR FromSalesShipmentHeader@1004 : Record 110;VAR FromSalesInvoiceHeader@1005 : Record 112;VAR FromReturnReceiptHeader@1006 : Record 6660;VAR FromSalesCrMemoHeader@1007 : Record 114) : Boolean;
    BEGIN
      WITH ToSalesHeader DO
        CASE FromDocType OF
          SalesDocType::Quote,
          SalesDocType::"Blanket Order",
          SalesDocType::Order,
          SalesDocType::Invoice,
          SalesDocType::"Return Order",
          SalesDocType::"Credit Memo":
            BEGIN
              FromSalesHeader.GET(SalesHeaderDocType(FromDocType),FromDocNo);
              IF NOT CheckDateOrder(
                   "Posting No.","Posting No. Series",
                   "Posting Date",FromSalesHeader."Posting Date")
              THEN
                EXIT(FALSE);
              IF MoveNegLines THEN
                DeleteSalesLinesWithNegQty(FromSalesHeader,TRUE);
              CheckSalesDocItselfCopy(ToSalesHeader,FromSalesHeader);

              IF "Document Type" <= "Document Type"::Invoice THEN BEGIN
                FromSalesHeader.CALCFIELDS("Amount Including VAT");
                "Amount Including VAT" := FromSalesHeader."Amount Including VAT";
                CheckCreditLimit(FromSalesHeader,ToSalesHeader);
              END;
              CheckCopyFromSalesHeaderAvail(FromSalesHeader,ToSalesHeader);

              IF NOT IncludeHeader AND NOT RecalculateLines THEN
                CheckFromSalesHeader(FromSalesHeader,ToSalesHeader);
            END;
          SalesDocType::"Posted Shipment":
            BEGIN
              FromSalesShipmentHeader.GET(FromDocNo);
              IF NOT CheckDateOrder(
                   "Posting No.","Posting No. Series",
                   "Posting Date",FromSalesShipmentHeader."Posting Date")
              THEN
                EXIT(FALSE);
              CheckCopyFromSalesShptAvail(FromSalesShipmentHeader,ToSalesHeader);

              IF NOT IncludeHeader AND NOT RecalculateLines THEN
                CheckFromSalesShptHeader(FromSalesShipmentHeader,ToSalesHeader);
            END;
          SalesDocType::"Posted Invoice":
            BEGIN
              FromSalesInvoiceHeader.GET(FromDocNo);
              FromSalesInvoiceHeader.TESTFIELD("Prepayment Invoice",FALSE);
              WarnSalesInvoicePmtDisc(ToSalesHeader,FromSalesHeader,FromDocType,FromDocNo);
              IF NOT CheckDateOrder(
                   "Posting No.","Posting No. Series",
                   "Posting Date",FromSalesInvoiceHeader."Posting Date")
              THEN
                EXIT(FALSE);
              IF "Document Type" <= "Document Type"::Invoice THEN BEGIN
                FromSalesInvoiceHeader.CALCFIELDS("Amount Including VAT");
                "Amount Including VAT" := FromSalesInvoiceHeader."Amount Including VAT";
                IF IncludeHeader THEN
                  FromSalesHeader.TRANSFERFIELDS(FromSalesInvoiceHeader);
                CheckCreditLimit(FromSalesHeader,ToSalesHeader);
              END;
              CheckCopyFromSalesInvoiceAvail(FromSalesInvoiceHeader,ToSalesHeader);

              IF NOT IncludeHeader AND NOT RecalculateLines THEN
                CheckFromSalesInvHeader(FromSalesInvoiceHeader,ToSalesHeader);
            END;
          SalesDocType::"Posted Return Receipt":
            BEGIN
              FromReturnReceiptHeader.GET(FromDocNo);
              IF NOT CheckDateOrder(
                   "Posting No.","Posting No. Series",
                   "Posting Date",FromReturnReceiptHeader."Posting Date")
              THEN
                EXIT(FALSE);
              CheckCopyFromSalesRetRcptAvail(FromReturnReceiptHeader,ToSalesHeader);

              IF NOT IncludeHeader AND NOT RecalculateLines THEN
                CheckFromSalesReturnRcptHeader(FromReturnReceiptHeader,ToSalesHeader);
            END;
          SalesDocType::"Posted Credit Memo":
            BEGIN
              FromSalesCrMemoHeader.GET(FromDocNo);
              FromSalesCrMemoHeader.TESTFIELD("Prepayment Credit Memo",FALSE);
              WarnSalesInvoicePmtDisc(ToSalesHeader,FromSalesHeader,FromDocType,FromDocNo);
              IF NOT CheckDateOrder(
                   "Posting No.","Posting No. Series",
                   "Posting Date",FromSalesCrMemoHeader."Posting Date")
              THEN
                EXIT(FALSE);
              IF "Document Type" <= "Document Type"::Invoice THEN BEGIN
                FromSalesCrMemoHeader.CALCFIELDS("Amount Including VAT");
                "Amount Including VAT" := FromSalesCrMemoHeader."Amount Including VAT";
                IF IncludeHeader THEN
                  FromSalesHeader.TRANSFERFIELDS(FromSalesCrMemoHeader);
                CheckCreditLimit(FromSalesHeader,ToSalesHeader);
              END;
              CheckCopyFromSalesCrMemoAvail(FromSalesCrMemoHeader,ToSalesHeader);

              IF NOT IncludeHeader AND NOT RecalculateLines THEN
                CheckFromSalesCrMemoHeader(FromSalesCrMemoHeader,ToSalesHeader);
            END;
        END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE InitAndCheckPurchaseDocuments@147(FromDocType@1007 : Option;FromDocNo@1006 : Code[20];VAR FromPurchaseHeader@1005 : Record 38;VAR ToPurchaseHeader@1004 : Record 38;VAR FromPurchRcptHeader@1003 : Record 120;VAR FromPurchInvHeader@1002 : Record 122;VAR FromReturnShipmentHeader@1001 : Record 6650;VAR FromPurchCrMemoHdr@1000 : Record 124) : Boolean;
    BEGIN
      WITH ToPurchaseHeader DO
        CASE FromDocType OF
          PurchDocType::Quote,
          PurchDocType::"Blanket Order",
          PurchDocType::Order,
          PurchDocType::Invoice,
          PurchDocType::"Return Order",
          PurchDocType::"Credit Memo":
            BEGIN
              FromPurchaseHeader.GET(PurchHeaderDocType(FromDocType),FromDocNo);
              IF NOT CheckDateOrder(
                   "Posting No.","Posting No. Series",
                   "Posting Date",FromPurchaseHeader."Posting Date")
              THEN
                EXIT(FALSE);
              IF MoveNegLines THEN
                DeletePurchLinesWithNegQty(FromPurchaseHeader,TRUE);
              CheckPurchDocItselfCopy(ToPurchaseHeader,FromPurchaseHeader);
              IF NOT IncludeHeader AND NOT RecalculateLines THEN
                CheckFromPurchaseHeader(FromPurchaseHeader,ToPurchaseHeader);
            END;
          PurchDocType::"Posted Receipt":
            BEGIN
              FromPurchRcptHeader.GET(FromDocNo);
              IF NOT CheckDateOrder(
                   "Posting No.","Posting No. Series",
                   "Posting Date",FromPurchRcptHeader."Posting Date")
              THEN
                EXIT(FALSE);
              IF NOT IncludeHeader AND NOT RecalculateLines THEN
                CheckFromPurchaseRcptHeader(FromPurchRcptHeader,ToPurchaseHeader);
            END;
          PurchDocType::"Posted Invoice":
            BEGIN
              FromPurchInvHeader.GET(FromDocNo);
              IF NOT CheckDateOrder(
                   "Posting No.","Posting No. Series",
                   "Posting Date",FromPurchInvHeader."Posting Date")
              THEN
                EXIT(FALSE);
              FromPurchInvHeader.TESTFIELD("Prepayment Invoice",FALSE);
              WarnPurchInvoicePmtDisc(ToPurchaseHeader,FromPurchaseHeader,FromDocType,FromDocNo);
              IF NOT IncludeHeader AND NOT RecalculateLines THEN
                CheckFromPurchaseInvHeader(FromPurchInvHeader,ToPurchaseHeader);
            END;
          PurchDocType::"Posted Return Shipment":
            BEGIN
              FromReturnShipmentHeader.GET(FromDocNo);
              IF NOT CheckDateOrder(
                   "Posting No.","Posting No. Series",
                   "Posting Date",FromReturnShipmentHeader."Posting Date")
              THEN
                EXIT(FALSE);
              IF NOT IncludeHeader AND NOT RecalculateLines THEN
                CheckFromPurchaseReturnShptHeader(FromReturnShipmentHeader,ToPurchaseHeader);
            END;
          PurchDocType::"Posted Credit Memo":
            BEGIN
              FromPurchCrMemoHdr.GET(FromDocNo);
              IF NOT CheckDateOrder(
                   "Posting No.","Posting No. Series",
                   "Posting Date",FromPurchCrMemoHdr."Posting Date")
              THEN
                EXIT(FALSE);
              FromPurchCrMemoHdr.TESTFIELD("Prepayment Credit Memo",FALSE);
              WarnPurchInvoicePmtDisc(ToPurchaseHeader,FromPurchaseHeader,FromDocType,FromDocNo);
              IF NOT IncludeHeader AND NOT RecalculateLines THEN
                CheckFromPurchaseCrMemoHeader(FromPurchCrMemoHdr,ToPurchaseHeader);
            END;
        END;

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CopySalesLinesToDoc@149(FromDocType@1004 : Option;ToSalesHeader@1006 : Record 36;VAR FromSalesShipmentLine@1003 : Record 111;VAR FromSalesInvoiceLine@1002 : Record 113;VAR FromReturnReceiptLine@1001 : Record 6661;VAR FromSalesCrMemoLine@1000 : Record 115;VAR LinesNotCopied@1009 : Integer;VAR MissingExCostRevLink@1008 : Boolean);
    BEGIN
      CopyExtText := TRUE;
      CASE FromDocType OF
        SalesDocType::"Posted Shipment":
          CopySalesShptLinesToDoc(ToSalesHeader,FromSalesShipmentLine,LinesNotCopied,MissingExCostRevLink);
        SalesDocType::"Posted Invoice":
          CopySalesInvLinesToDoc(ToSalesHeader,FromSalesInvoiceLine,LinesNotCopied,MissingExCostRevLink);
        SalesDocType::"Posted Return Receipt":
          CopySalesReturnRcptLinesToDoc(ToSalesHeader,FromReturnReceiptLine,LinesNotCopied,MissingExCostRevLink);
        SalesDocType::"Posted Credit Memo":
          CopySalesCrMemoLinesToDoc(ToSalesHeader,FromSalesCrMemoLine,LinesNotCopied,MissingExCostRevLink);
      END;
      CopyExtText := FALSE;
    END;

    [External]
    PROCEDURE CopyPurchaseLinesToDoc@153(FromDocType@1004 : Option;ToPurchaseHeader@1006 : Record 38;VAR FromPurchRcptLine@1003 : Record 121;VAR FromPurchInvLine@1002 : Record 123;VAR FromReturnShipmentLine@1001 : Record 6651;VAR FromPurchCrMemoLine@1000 : Record 125;VAR LinesNotCopied@1009 : Integer;VAR MissingExCostRevLink@1008 : Boolean);
    BEGIN
      CopyExtText := TRUE;
      CASE FromDocType OF
        PurchDocType::"Posted Receipt":
          CopyPurchRcptLinesToDoc(ToPurchaseHeader,FromPurchRcptLine,LinesNotCopied,MissingExCostRevLink);
        PurchDocType::"Posted Invoice":
          CopyPurchInvLinesToDoc(ToPurchaseHeader,FromPurchInvLine,LinesNotCopied,MissingExCostRevLink);
        PurchDocType::"Posted Return Shipment":
          CopyPurchReturnShptLinesToDoc(ToPurchaseHeader,FromReturnShipmentLine,LinesNotCopied,MissingExCostRevLink);
        PurchDocType::"Posted Credit Memo":
          CopyPurchCrMemoLinesToDoc(ToPurchaseHeader,FromPurchCrMemoLine,LinesNotCopied,MissingExCostRevLink);
      END;
      CopyExtText := FALSE;
    END;

    LOCAL PROCEDURE CopyShiptoCodeFromInvToCrMemo@150(VAR ToSalesHeader@1000 : Record 36;FromSalesInvHeader@1001 : Record 112;FromDocType@1002 : Option);
    BEGIN
      IF (FromDocType = SalesDocType::"Posted Invoice") AND
         (FromSalesInvHeader."Ship-to Code" <> '') AND
         (ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::"Credit Memo")
      THEN
        ToSalesHeader."Ship-to Code" := FromSalesInvHeader."Ship-to Code";
    END;

    LOCAL PROCEDURE TransferFieldsFromCrMemoToInv@151(VAR ToSalesHeader@1000 : Record 36;FromSalesCrMemoHeader@1001 : Record 114);
    BEGIN
      ToSalesHeader.VALIDATE("Sell-to Customer No.",FromSalesCrMemoHeader."Sell-to Customer No.");
      ToSalesHeader.TRANSFERFIELDS(FromSalesCrMemoHeader,FALSE);
      IF (ToSalesHeader."Document Type" = ToSalesHeader."Document Type"::Invoice) AND IncludeHeader THEN BEGIN
        ToSalesHeader.CopySellToAddressToShipToAddress;
        ToSalesHeader.VALIDATE("Ship-to Code",FromSalesCrMemoHeader."Ship-to Code");
      END;
    END;

    LOCAL PROCEDURE CopyShippingInfoPurchOrder@161(VAR ToPurchaseHeader@1000 : Record 38;FromPurchaseHeader@1001 : Record 38);
    BEGIN
      IF (ToPurchaseHeader."Document Type" = ToPurchaseHeader."Document Type"::Order) AND
         (FromPurchaseHeader."Document Type" = FromPurchaseHeader."Document Type"::Order)
      THEN BEGIN
        ToPurchaseHeader."Ship-to Address" := FromPurchaseHeader."Ship-to Address";
        ToPurchaseHeader."Ship-to Address 2" := FromPurchaseHeader."Ship-to Address 2";
        ToPurchaseHeader."Ship-to City" := FromPurchaseHeader."Ship-to City";
        ToPurchaseHeader."Ship-to Country/Region Code" := FromPurchaseHeader."Ship-to Country/Region Code";
        ToPurchaseHeader."Ship-to County" := FromPurchaseHeader."Ship-to County";
        ToPurchaseHeader."Ship-to Name" := FromPurchaseHeader."Ship-to Name";
        ToPurchaseHeader."Ship-to Name 2" := FromPurchaseHeader."Ship-to Name 2";
        ToPurchaseHeader."Ship-to Post Code" := FromPurchaseHeader."Ship-to Post Code";
        ToPurchaseHeader."Ship-to Contact" := FromPurchaseHeader."Ship-to Contact";
        ToPurchaseHeader."Inbound Whse. Handling Time" := FromPurchaseHeader."Inbound Whse. Handling Time";
      END;
    END;

    LOCAL PROCEDURE SetSalespersonPurchaserCode@218(VAR SalespersonPurchaserCode@1000 : Code[20]);
    BEGIN
      IF SalespersonPurchaserCode <> '' THEN
        IF SalespersonPurchaser.GET(SalespersonPurchaserCode) THEN
          IF SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) THEN
            SalespersonPurchaserCode := ''
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCopySalesDocument@137(FromDocumentType@1000 : Option;FromDocumentNo@1001 : Code[20];VAR ToSalesHeader@1002 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCopyPurchaseDocument@140(FromDocumentType@1002 : Option;FromDocumentNo@1001 : Code[20];VAR ToPurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeModifySalesHeader@148(VAR ToSalesHeader@1000 : Record 36;FromDocType@1001 : Option;FromDocNo@1002 : Code[20];IncludeHeader@1003 : Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE AddSalesDocLine@246(VAR TempDocSalesLine@1002 : TEMPORARY Record 37;BufferLineNo@1000 : Integer;DocumentNo@1003 : Code[20];DocumentLineNo@1001 : Integer);
    BEGIN
      TempDocSalesLine."Document No." := DocumentNo;
      TempDocSalesLine."Line No." := DocumentLineNo;
      TempDocSalesLine."Shipment Line No." := BufferLineNo;
      TempDocSalesLine.INSERT;
    END;

    LOCAL PROCEDURE GetSalesLineNo@257(VAR TempDocSalesLine@1000 : TEMPORARY Record 37;BufferLineNo@1001 : Integer) : Integer;
    BEGIN
      TempDocSalesLine.SETRANGE("Shipment Line No.",BufferLineNo);
      IF NOT TempDocSalesLine.FINDFIRST THEN
        EXIT(0);
      EXIT(TempDocSalesLine."Line No.");
    END;

    LOCAL PROCEDURE GetSalesDocNo@256(VAR TempDocSalesLine@1000 : TEMPORARY Record 37;BufferLineNo@1001 : Integer) : Code[20];
    BEGIN
      TempDocSalesLine.SETRANGE("Shipment Line No.",BufferLineNo);
      IF NOT TempDocSalesLine.FINDFIRST THEN
        EXIT('');
      EXIT(TempDocSalesLine."Document No.");
    END;

    LOCAL PROCEDURE AddPurchDocLine@249(VAR TempDocPurchaseLine@1002 : TEMPORARY Record 39;BufferLineNo@1000 : Integer;DocumentNo@1003 : Code[20];DocumentLineNo@1001 : Integer);
    BEGIN
      TempDocPurchaseLine."Document No." := DocumentNo;
      TempDocPurchaseLine."Line No." := DocumentLineNo;
      TempDocPurchaseLine."Receipt Line No." := BufferLineNo;
      TempDocPurchaseLine.INSERT;
    END;

    LOCAL PROCEDURE GetPurchLineNo@248(VAR TempDocPurchaseLine@1000 : TEMPORARY Record 39;BufferLineNo@1001 : Integer) : Integer;
    BEGIN
      TempDocPurchaseLine.SETRANGE("Receipt Line No.",BufferLineNo);
      IF NOT TempDocPurchaseLine.FINDFIRST THEN
        EXIT(0);
      EXIT(TempDocPurchaseLine."Line No.");
    END;

    LOCAL PROCEDURE GetPurchDocNo@247(VAR TempDocPurchaseLine@1000 : TEMPORARY Record 39;BufferLineNo@1001 : Integer) : Code[20];
    BEGIN
      TempDocPurchaseLine.SETRANGE("Receipt Line No.",BufferLineNo);
      IF NOT TempDocPurchaseLine.FINDFIRST THEN
        EXIT('');
      EXIT(TempDocPurchaseLine."Document No.");
    END;

    LOCAL PROCEDURE SetTrackingOnAssemblyReservation@193(AssemblyHeader@1001 : Record 900;VAR TempItemLedgerEntry@1002 : TEMPORARY Record 32);
    VAR
      ReservationEntry@1000 : Record 337;
      TempReservationEntry@1003 : TEMPORARY Record 337;
      TempTrackingSpecification@1004 : TEMPORARY Record 336;
      ItemTrackingCode@1009 : Record 6502;
      ReservationEngineMgt@1007 : Codeunit 99000831;
      QtyToAddAsBlank@1008 : Decimal;
    BEGIN
      TempItemLedgerEntry.SETFILTER("Lot No.",'<>%1','');
      IF TempItemLedgerEntry.ISEMPTY THEN
        EXIT;

      ReservationEntry.SETRANGE("Source Type",DATABASE::"Assembly Header");
      ReservationEntry.SETRANGE("Source Subtype",AssemblyHeader."Document Type");
      ReservationEntry.SETRANGE("Source ID",AssemblyHeader."No.");
      ReservationEntry.SETRANGE("Source Ref. No.",0);
      ReservationEntry.SETRANGE("Reservation Status",ReservationEntry."Reservation Status"::Reservation);
      IF ReservationEntry.FINDSET THEN
        REPEAT
          TempReservationEntry := ReservationEntry;
          TempReservationEntry.INSERT;
        UNTIL ReservationEntry.NEXT = 0;

      IF TempItemLedgerEntry.FINDSET THEN
        REPEAT
          TempTrackingSpecification."Entry No." += 1;
          TempTrackingSpecification."Item No." := TempItemLedgerEntry."Item No.";
          TempTrackingSpecification."Location Code" := TempItemLedgerEntry."Location Code";
          TempTrackingSpecification."Quantity (Base)" := TempItemLedgerEntry.Quantity;
          TempTrackingSpecification."Serial No." := TempItemLedgerEntry."Serial No.";
          TempTrackingSpecification."Lot No." := TempItemLedgerEntry."Lot No.";
          TempTrackingSpecification."Warranty Date" := TempItemLedgerEntry."Warranty Date";
          TempTrackingSpecification."Expiration Date" := TempItemLedgerEntry."Expiration Date";
          TempTrackingSpecification.INSERT;
        UNTIL TempItemLedgerEntry.NEXT = 0;

      IF TempTrackingSpecification.FINDSET THEN
        REPEAT
          IF GetItemTrackingCode(ItemTrackingCode,TempTrackingSpecification."Item No.") THEN
            ReservationEngineMgt.AddItemTrackingToTempRecSet(
              TempReservationEntry,TempTrackingSpecification,TempTrackingSpecification."Quantity (Base)",QtyToAddAsBlank,
              ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
        UNTIL TempTrackingSpecification.NEXT = 0;
    END;

    LOCAL PROCEDURE GetItemTrackingCode@195(VAR ItemTrackingCode@1000 : Record 6502;ItemNo@1001 : Code[20]) : Boolean;
    BEGIN
      IF NOT Item.GET(ItemNo) THEN
        EXIT(FALSE);

      IF Item."Item Tracking Code" = '' THEN
        EXIT(FALSE);

      ItemTrackingCode.GET(Item."Item Tracking Code");
      EXIT(TRUE);
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCopyPurchLines@1051(VAR PurchaseLine@1000 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCopySalesToPurchDoc@1001(VAR ToPurchLine@1000 : Record 39;VAR FromSalesLine@1001 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeUpdateSalesLine@152(VAR ToSalesHeader@1007 : Record 36;VAR ToSalesLine@1006 : Record 37;VAR FromSalesHeader@1005 : Record 36;VAR FromSalesLine@1004 : Record 37;VAR CopyThisLine@1003 : Boolean;RecalculateAmount@1002 : Boolean;FromSalesDocType@1001 : Option;VAR CopyPostedDeferral@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeModifyPurchHeader@157(VAR ToPurchHeader@1000 : Record 38;FromDocType@1001 : Option;FromDocNo@1002 : Code[20];IncludeHeader@1003 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeUpdatePurchLine@156(VAR ToPurchHeader@1007 : Record 38;VAR ToPurchLine@1006 : Record 39;VAR FromPurchHeader@1005 : Record 38;VAR FromPurchLine@1004 : Record 39;VAR CopyThisLine@1003 : Boolean;RecalculateAmount@1002 : Boolean;FromPurchDocType@1001 : Option;VAR CopyPostedDeferral@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopySalesDocument@141(FromDocumentType@1002 : Option;FromDocumentNo@1001 : Code[20];VAR ToSalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyPurchaseDocument@142(FromDocumentType@1002 : Option;FromDocumentNo@1001 : Code[20];VAR ToPurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdateSalesLine@154(VAR ToSalesHeader@1007 : Record 36;VAR ToSalesLine@1006 : Record 37;VAR FromSalesHeader@1005 : Record 36;VAR FromSalesLine@1004 : Record 37;VAR CopyThisLine@1003 : Boolean;RecalculateAmount@1002 : Boolean;FromSalesDocType@1001 : Option;VAR CopyPostedDeferral@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterUpdatePurchLine@158(VAR ToPurchHeader@1007 : Record 38;VAR ToPurchLine@1006 : Record 39;VAR FromPurchHeader@1005 : Record 38;VAR FromPurchLine@1004 : Record 39;VAR CopyThisLine@1003 : Boolean;RecalculateAmount@1002 : Boolean;FromPurchDocType@1001 : Option;VAR CopyPostedDeferral@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnUpdateSalesLine@1002(VAR ToSalesLine@1000 : Record 37;VAR FromSalesLine@1001 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnUpdatePurchLine@1003(VAR ToPurchLine@1000 : Record 39;VAR FromPurchLine@1001 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnCopySalesDocWithHeader@1007(FromDocType@1001 : Option;FromDocNo@1002 : Code[20];VAR ToSalesHeader@1003 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransfldsFromSalesToPurchLine@1008(VAR FromSalesLine@1000 : Record 37;VAR ToPurchaseLine@1001 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitToSalesLine@1009(VAR ToSalesLine@1000 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertToSalesLine@1010(VAR ToSalesLine@1000 : Record 37;FromSalesLine@1001 : Record 37;FromDocType@1002 : Option;RecalcLines@1003 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertOldSalesDocNoLine@163(VAR ToSalesHeader@1000 : Record 36;VAR ToSalesLine@1001 : Record 37;OldDocType@1003 : Option;OldDocNo@1002 : Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertOldSalesCombDocNoLine@167(VAR ToSalesHeader@1003 : Record 36;VAR ToSalesLine@1002 : Record 37;CopyFromInvoice@1004 : Boolean;OldDocNo@1000 : Code[20];OldDocNo2@1001 : Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInitToPurchLine@1011(VAR ToPurchaseLine@1000 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertToPurchLine@1012(VAR ToPurchLine@1000 : Record 39;FromPurchLine@1001 : Record 39;FromDocType@1002 : Option;RecalcLines@1003 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertOldPurchDocNoLine@165(ToPurchHeader@1000 : Record 38;VAR ToPurchLine@1001 : Record 39;OldDocType@1003 : Option;OldDocNo@1002 : Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertOldPurchCombDocNoLine@168(VAR ToPurchHeader@1003 : Record 38;VAR ToPurchLine@1002 : Record 39;CopyFromInvoice@1004 : Boolean;OldDocNo@1000 : Code[20];OldDocNo2@1001 : Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertToSalesLine@1014(VAR ToSalesLine@1000 : Record 37;FromSalesLine@1001 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopySalesToPurchDoc@1017(VAR ToPurchLine@1000 : Record 39;VAR FromSalesLine@1001 : Record 37);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertToPurchLine@1016(VAR ToPurchLine@1000 : Record 39;VAR FromPurchLine@1001 : Record 39);
    BEGIN
    END;

    BEGIN
    END.
  }
}

