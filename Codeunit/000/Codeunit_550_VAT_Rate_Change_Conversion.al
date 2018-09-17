OBJECT Codeunit 550 VAT Rate Change Conversion
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 552=i;
    OnRun=BEGIN
            IF NOT VATRateChangeSetup.GET THEN BEGIN
              VATRateChangeSetup.INIT;
              VATRateChangeSetup.INSERT;
            END;

            Convert;
          END;

  }
  CODE
  {
    VAR
      VATRateChangeSetup@1001 : Record 550;
      VATRateChangeConversion@1000 : Record 551;
      ProgressWindow@1002 : Dialog;
      Text0001@1003 : TextConst 'DAN="Behandler tabel  #1#####################################  ";ENU="Progressing Table #1#####################################  "';
      Text0002@1004 : TextConst 'DAN="Behandler record #2############ af #3####################  ";ENU="Progressing Record #2############ of #3####################  "';
      Text0004@1005 : TextConst 'DAN=Ordrelinje %1 har en indk�bskode for direkte levering. Opdater ordren manuelt.;ENU=Order line %1 has a drop shipment purchasing code. Update the order manually.';
      Text0005@1006 : TextConst 'DAN=Ordrelinje %1 har en indk�bskode for specialordrer. Opdater ordren manuelt.;ENU=Order line %1 has a special order purchasing code. Update the order manually.';
      Text0006@1007 : TextConst 'DAN=Ordren har en delvist leveret linje med et link til et lagerdokument. Du skal opdatere ordren manuelt.;ENU=The order has a partially shipped line with link to a WHSE document. Update the order manually.';
      Text0007@1008 : TextConst 'DAN=Der er intet at konvertere. Det udest�ende antal er nul.;ENU=There is nothing to convert. The outstanding quantity is zero.';
      Text0008@1009 : TextConst 'DAN=Der skal v�re en post i tabellen %1 for kombinationen af momsvirksomhedsbogf�ringsgruppe %2 og momsproduktbogf�ringsgruppe %3.;ENU=There must be an entry in the %1 table for the combination of VAT business posting group %2 and VAT product posting group %3.';
      Text0009@1010 : TextConst 'DAN=Der kan ikke udf�res konvertering, f�r %1 er angivet til sand.;ENU=Conversion cannot be performed before %1 is set to true.';
      Text0010@1011 : TextConst 'DAN=Linjen er blevet leveret.;ENU=The line has been shipped.';
      Text0011@1012 : TextConst 'DAN=Dokumenter, der har bogf�rt forudbetaling, skal konverteres manuelt.;ENU=Documents that have posted prepayment must be converted manually.';
      Text0012@1013 : TextConst 'DAN=Denne linje %1 er opdelt i to linjer. Det udest�ende antal vises p� den nye linje.;ENU=This line %1 has been split into two lines. The outstanding quantity will be on the new line.';
      Text0013@1014 : TextConst 'DAN=Denne linje %1 er tilf�jet. Den indeholder det udest�ende antal fra linje %2.;ENU=This line %1 has been added. It contains the outstanding quantity from line %2.';
      Text0014@1015 : TextConst 'DAN=Ordrelinjen %1 af typen %2 er delvist leveret/faktureret. Opdater ordren manuelt.;ENU=The order line %1 of type %2 have been partial Shipped/Invoiced . Update the order manually.';
      Text0015@1016 : TextConst 'DAN=Der findes ikke en defineret konvertering. Definer konverteringen.;ENU=A defined conversion does not exist. Define the conversion.';
      Text0016@1017 : TextConst 'DAN=Der findes ikke definerede tabeller for konverteringen.;ENU=Defined tables for conversion do not exist.';
      Text0017@1018 : TextConst 'DAN=Denne linje %1 opdeles i to linjer. Det udest�ende antal vises p� den nye linje.;ENU=This line %1 will be split into two lines. The outstanding quantity will be on the new line.';
      Text0018@1019 : TextConst 'DAN=Dette bilag er knyttet til en montageordre. Du skal konvertere bilaget manuelt.;ENU=This document is linked to an assembly order. You must convert the document manually.';

    LOCAL PROCEDURE Convert@2();
    VAR
      GenProductPostingGroup@1001 : Record 251;
      TempGenProductPostingGroup@1000 : TEMPORARY Record 251;
    BEGIN
      VATRateChangeSetup.TESTFIELD("VAT Rate Change Tool Completed",FALSE);
      IF VATRateChangeConversion.ISEMPTY THEN
        ERROR(Text0015);
      IF NOT AreTablesSelected THEN
        ERROR(Text0016);
      TestVATPostingSetup;
      ProgressWindow.OPEN(Text0001 + Text0002);
      WITH VATRateChangeSetup DO BEGIN
        ProgressWindow.UPDATE;
        UpdateTable(
          DATABASE::"Gen. Product Posting Group",
          ConvertVATProdPostGrp("Update Gen. Prod. Post. Groups"),ConvertGenProdPostGrp("Update Gen. Prod. Post. Groups"));
        TempGenProductPostingGroup.DELETEALL;
        IF GenProductPostingGroup.FIND('-') THEN
          REPEAT
            TempGenProductPostingGroup := GenProductPostingGroup;
            TempGenProductPostingGroup.INSERT;
            GenProductPostingGroup."Auto Insert Default" := FALSE;
            GenProductPostingGroup.MODIFY;
          UNTIL GenProductPostingGroup.NEXT = 0;
        UpdateItem;
        UpdateRessouce;
        UpdateGLAccount;
        UpdateServPriceAdjDetail;
        UpdatePurchase;
        UpdateSales;
        UpdateService;
        UpdateTable(
          DATABASE::"Item Template",
          ConvertVATProdPostGrp("Update Item Templates"),ConvertGenProdPostGrp("Update Item Templates"));
        UpdateTable(
          DATABASE::"Item Charge",
          ConvertVATProdPostGrp("Update Item Charges"),ConvertGenProdPostGrp("Update Item Charges"));
        UpdateTable(
          DATABASE::"Gen. Journal Line",
          ConvertVATProdPostGrp("Update Gen. Journal Lines"),ConvertGenProdPostGrp("Update Gen. Journal Lines"));
        UpdateTable(
          DATABASE::"Gen. Jnl. Allocation",
          ConvertVATProdPostGrp("Update Gen. Journal Allocation"),ConvertGenProdPostGrp("Update Gen. Journal Allocation"));
        UpdateTable(
          DATABASE::"Standard General Journal Line",
          ConvertVATProdPostGrp("Update Std. Gen. Jnl. Lines"),ConvertGenProdPostGrp("Update Std. Gen. Jnl. Lines"));
        UpdateTable(
          DATABASE::"Res. Journal Line",
          ConvertVATProdPostGrp("Update Res. Journal Lines"),ConvertGenProdPostGrp("Update Res. Journal Lines"));
        UpdateTable(
          DATABASE::"Job Journal Line",
          ConvertVATProdPostGrp("Update Job Journal Lines"),ConvertGenProdPostGrp("Update Job Journal Lines"));
        UpdateTable(
          DATABASE::"Requisition Line",
          ConvertVATProdPostGrp("Update Requisition Lines"),ConvertGenProdPostGrp("Update Requisition Lines"));
        UpdateTable(
          DATABASE::"Standard Item Journal Line",
          ConvertVATProdPostGrp("Update Std. Item Jnl. Lines"),ConvertGenProdPostGrp("Update Std. Item Jnl. Lines"));
        UpdateTable(
          DATABASE::"Production Order",
          ConvertVATProdPostGrp("Update Production Orders"),ConvertGenProdPostGrp("Update Production Orders"));
        UpdateTable(
          DATABASE::"Work Center",
          ConvertVATProdPostGrp("Update Work Centers"),ConvertGenProdPostGrp("Update Work Centers"));
        UpdateTable(
          DATABASE::"Machine Center",
          ConvertVATProdPostGrp("Update Machine Centers"),ConvertGenProdPostGrp("Update Machine Centers"));
        UpdateTable(
          DATABASE::"Reminder Line",
          ConvertVATProdPostGrp("Update Reminders"),ConvertGenProdPostGrp("Update Reminders"));
        UpdateTable(
          DATABASE::"Finance Charge Memo Line",
          ConvertVATProdPostGrp("Update Finance Charge Memos"),ConvertGenProdPostGrp("Update Finance Charge Memos"));
        GenProductPostingGroup.DELETEALL;
        IF TempGenProductPostingGroup.FIND('-') THEN
          REPEAT
            GenProductPostingGroup := TempGenProductPostingGroup;
            GenProductPostingGroup.INSERT;
            TempGenProductPostingGroup.DELETE;
          UNTIL TempGenProductPostingGroup.NEXT = 0;
      END;
      ProgressWindow.CLOSE;
      IF VATRateChangeSetup."Perform Conversion" THEN BEGIN
        VATRateChangeSetup."VAT Rate Change Tool Completed" := TRUE;
        VATRateChangeSetup.MODIFY;
        VATRateChangeConversion.RESET;
        IF VATRateChangeConversion.FINDSET(TRUE) THEN
          REPEAT
            VATRateChangeConversion."Converted Date" := WORKDATE;
            VATRateChangeConversion.MODIFY;
          UNTIL VATRateChangeConversion.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE TestVATPostingSetup@24();
    VAR
      VATPostingSetupOld@1000 : Record 325;
      VATPostingSetupNew@1001 : Record 325;
      VATRateChangeConversion@1002 : Record 551;
    BEGIN
      VATRateChangeConversion.SETRANGE(Type,VATRateChangeConversion.Type::"VAT Prod. Posting Group");
      IF VATRateChangeConversion.FINDSET THEN
        REPEAT
          VATPostingSetupOld.SETRANGE("VAT Prod. Posting Group",VATRateChangeConversion."From Code");
          IF VATPostingSetupOld.FINDSET THEN
            REPEAT
              IF NOT VATPostingSetupNew.GET(VATPostingSetupOld."VAT Bus. Posting Group",VATRateChangeConversion."To Code") THEN
                ERROR(
                  Text0008,
                  VATPostingSetupNew.TABLECAPTION,
                  VATPostingSetupOld."VAT Bus. Posting Group",
                  VATRateChangeConversion."To Code");
              IF VATPostingSetupOld."VAT Identifier" <> '' THEN
                VATPostingSetupNew.TESTFIELD("VAT Identifier")
            UNTIL VATPostingSetupOld.NEXT = 0;
        UNTIL VATRateChangeConversion.NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateItem@5();
    VAR
      Item@1000 : Record 27;
      RecRef@1001 : RecordRef;
    BEGIN
      ProgressWindow.UPDATE(1,Item.TABLECAPTION);
      WITH VATRateChangeSetup DO
        IF "Item Filter" = '' THEN
          UpdateTable(DATABASE::Item,ConvertVATProdPostGrp("Update Items"),ConvertGenProdPostGrp("Update Items"))
        ELSE BEGIN
          Item.SETFILTER("No.","Item Filter");
          IF Item.FIND('-') THEN
            REPEAT
              RecRef.GETTABLE(Item);
              UpdateRec(RecRef,ConvertVATProdPostGrp("Update Items"),ConvertGenProdPostGrp("Update Items"));
            UNTIL Item.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdateGLAccount@8();
    VAR
      GLAccount@1000 : Record 15;
      RecRef@1001 : RecordRef;
    BEGIN
      ProgressWindow.UPDATE(1,GLAccount.TABLECAPTION);
      WITH VATRateChangeSetup DO
        IF "Account Filter" = '' THEN
          UpdateTable(DATABASE::"G/L Account",ConvertVATProdPostGrp("Update G/L Accounts"),ConvertGenProdPostGrp("Update G/L Accounts"))
        ELSE BEGIN
          GLAccount.SETFILTER("No.","Account Filter");
          IF GLAccount.FIND('-') THEN
            REPEAT
              RecRef.GETTABLE(GLAccount);
              UpdateRec(RecRef,ConvertVATProdPostGrp("Update G/L Accounts"),ConvertGenProdPostGrp("Update G/L Accounts"));
            UNTIL GLAccount.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE UpdateRessouce@7();
    VAR
      Resource@1000 : Record 156;
      RecRef@1001 : RecordRef;
    BEGIN
      WITH VATRateChangeSetup DO
        IF "Resource Filter" = '' THEN
          UpdateTable(DATABASE::Resource,ConvertVATProdPostGrp("Update Resources"),ConvertGenProdPostGrp("Update Resources"))
        ELSE BEGIN
          Resource.SETFILTER("No.","Resource Filter");
          IF Resource.FIND('-') THEN
            REPEAT
              RecRef.GETTABLE(Resource);
              UpdateRec(RecRef,ConvertVATProdPostGrp("Update Resources"),ConvertGenProdPostGrp("Update Resources"));
            UNTIL Resource.NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE ConvertVATProdPostGrp@3(UpdateOption@1000 : Option) : Boolean;
    VAR
      DummyVATRateChangeSetup@1001 : Record 550;
    BEGIN
      IF UpdateOption IN [DummyVATRateChangeSetup."Update Items"::"VAT Prod. Posting Group",
                          DummyVATRateChangeSetup."Update Items"::Both]
      THEN
        EXIT(TRUE);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ConvertGenProdPostGrp@6(UpdateOption@1000 : Option) : Boolean;
    VAR
      DummyVATRateChangeSetup@1001 : Record 550;
    BEGIN
      IF UpdateOption IN [DummyVATRateChangeSetup."Update Items"::"Gen. Prod. Posting Group",
                          DummyVATRateChangeSetup."Update Items"::Both]
      THEN
        EXIT(TRUE);
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE UpdateTable@4(TableID@1005 : Integer;ConvertVATProdPostingGroup@1000 : Boolean;ConvertGenProdPostingGroup@1001 : Boolean);
    VAR
      RecRef@1004 : RecordRef;
      I@1003 : Integer;
    BEGIN
      IF NOT ConvertVATProdPostingGroup AND NOT ConvertGenProdPostingGroup THEN
        EXIT;
      RecRef.OPEN(TableID);
      ProgressWindow.UPDATE(1,FORMAT(RecRef.CAPTION));
      I := 0;
      ProgressWindow.UPDATE(3,RecRef.COUNT);
      IF RecRef.FIND('-') THEN
        REPEAT
          I := I + 1;
          ProgressWindow.UPDATE(2,I);
          UpdateRec(RecRef,ConvertVATProdPostingGroup,ConvertGenProdPostingGroup);
        UNTIL RecRef.NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateRec@1(VAR RecRef@1005 : RecordRef;ConvertVATProdPostingGroup@1000 : Boolean;ConvertGenProdPostingGroup@1001 : Boolean);
    VAR
      Field@1008 : Record 2000000041;
      VATRateChangeLogEntry@1002 : Record 552;
      FieldRef@1003 : FieldRef;
      GenProdPostingGroupConverted@1004 : Boolean;
      VATProdPostingGroupConverted@1006 : Boolean;
    BEGIN
      VATRateChangeLogEntry.INIT;
      VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
      VATRateChangeLogEntry."Table ID" := RecRef.NUMBER;
      Field.SETRANGE(TableNo,RecRef.NUMBER);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      Field.SETRANGE(RelationTableNo,DATABASE::"Gen. Product Posting Group");
      IF Field.FIND('+') THEN
        REPEAT
          FieldRef := RecRef.FIELD(Field."No.");
          GenProdPostingGroupConverted := FALSE;
          IF ConvertGenProdPostingGroup THEN
            IF VATRateChangeConversion.GET(VATRateChangeConversion.Type::"Gen. Prod. Posting Group",FieldRef.VALUE) THEN BEGIN
              VATRateChangeLogEntry."Old Gen. Prod. Posting Group" := FieldRef.VALUE;
              FieldRef.VALIDATE(VATRateChangeConversion."To Code");
              VATRateChangeLogEntry."New Gen. Prod. Posting Group" := FieldRef.VALUE;
              GenProdPostingGroupConverted := TRUE;
            END;
          IF NOT GenProdPostingGroupConverted THEN BEGIN
            VATRateChangeLogEntry."Old Gen. Prod. Posting Group" := FieldRef.VALUE;
            VATRateChangeLogEntry."New Gen. Prod. Posting Group" := FieldRef.VALUE;
          END;
        UNTIL Field.NEXT(-1) = 0;

      Field.SETRANGE(RelationTableNo,DATABASE::"VAT Product Posting Group");
      IF Field.FIND('+') THEN
        REPEAT
          FieldRef := RecRef.FIELD(Field."No.");
          VATProdPostingGroupConverted := FALSE;
          IF ConvertVATProdPostingGroup THEN
            IF VATRateChangeConversion.GET(VATRateChangeConversion.Type::"VAT Prod. Posting Group",FieldRef.VALUE) THEN BEGIN
              VATRateChangeLogEntry."Old VAT Prod. Posting Group" := FieldRef.VALUE;
              FieldRef.VALIDATE(VATRateChangeConversion."To Code");
              VATRateChangeLogEntry."New VAT Prod. Posting Group" := FieldRef.VALUE;
              VATProdPostingGroupConverted := TRUE;
            END;
          IF NOT VATProdPostingGroupConverted THEN BEGIN
            VATRateChangeLogEntry."Old VAT Prod. Posting Group" := FieldRef.VALUE;
            VATRateChangeLogEntry."New VAT Prod. Posting Group" := FieldRef.VALUE;
          END;
        UNTIL Field.NEXT(-1) = 0;

      IF VATRateChangeSetup."Perform Conversion" THEN BEGIN
        RecRef.MODIFY;
        VATRateChangeLogEntry.Converted := TRUE;
      END;
      IF (VATRateChangeLogEntry."New Gen. Prod. Posting Group" <> VATRateChangeLogEntry."Old Gen. Prod. Posting Group") OR
         (VATRateChangeLogEntry."New VAT Prod. Posting Group" <> VATRateChangeLogEntry."Old VAT Prod. Posting Group")
      THEN
        WriteLogEntry(VATRateChangeLogEntry);
    END;

    LOCAL PROCEDURE WriteLogEntry@10(VATRateChangeLogEntry@1000 : Record 552);
    BEGIN
      WITH VATRateChangeLogEntry DO BEGIN
        IF Converted THEN
          "Converted Date" := WORKDATE
        ELSE
          IF Description = '' THEN
            Description := STRSUBSTNO(Text0009,VATRateChangeSetup.FIELDCAPTION("Perform Conversion"));
        INSERT;
      END;
    END;

    LOCAL PROCEDURE UpdateSales@12();
    VAR
      SalesHeader@1000 : Record 36;
      SalesHeader2@1004 : Record 36;
      SalesLine@1003 : Record 37;
      SalesLineOld@1011 : Record 37;
      VATRateChangeLogEntry@1002 : Record 552;
      RecRef@1001 : RecordRef;
      SalesHeaderStatusChanged@1005 : Boolean;
      NewVATProdPotingGroup@1007 : Code[20];
      NewGenProdPostingGroup@1008 : Code[20];
      ConvertVATProdPostingGroup@1009 : Boolean;
      ConvertGenProdPostingGroup@1006 : Boolean;
      RoundingPrecision@1010 : Decimal;
    BEGIN
      ProgressWindow.UPDATE(1,SalesHeader.TABLECAPTION);
      ConvertVATProdPostingGroup := ConvertVATProdPostGrp(VATRateChangeSetup."Update Sales Documents");
      ConvertGenProdPostingGroup := ConvertGenProdPostGrp(VATRateChangeSetup."Update Sales Documents");
      IF NOT ConvertVATProdPostingGroup AND NOT ConvertGenProdPostingGroup THEN
        EXIT;

      SalesHeader.SETFILTER(
        "Document Type",'%1..%2|%3',SalesHeader."Document Type"::Quote,SalesHeader."Document Type"::Invoice,
        SalesHeader."Document Type"::"Blanket Order");
      IF SalesHeader.FIND('-') THEN
        REPEAT
          SalesHeaderStatusChanged := FALSE;
          IF CanUpdateSales(SalesHeader,ConvertVATProdPostingGroup,ConvertGenProdPostingGroup) THEN BEGIN
            IF VATRateChangeSetup."Ignore Status on Sales Docs." THEN
              IF SalesHeader.Status <> SalesHeader.Status::Open THEN BEGIN
                SalesHeader2 := SalesHeader;
                SalesHeader.Status := SalesHeader.Status::Open;
                SalesHeader.MODIFY;
                SalesHeaderStatusChanged := TRUE;
              END;
            IF SalesHeader.Status = SalesHeader.Status::Open THEN BEGIN
              SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
              SalesLine.SETRANGE("Document No.",SalesHeader."No.");
              IF SalesLine.FINDSET THEN
                REPEAT
                  IF LineInScope(
                       SalesLine."Gen. Prod. Posting Group",SalesLine."VAT Prod. Posting Group",ConvertGenProdPostingGroup,
                       ConvertVATProdPostingGroup)
                  THEN
                    IF (SalesLine."Shipment No." = '') AND (SalesLine."Return Receipt No." = '') AND
                       IncludeLine(SalesLine.Type,SalesLine."No.")
                    THEN
                      IF SalesLine.Quantity = SalesLine."Outstanding Quantity" THEN BEGIN
                        RecRef.GETTABLE(SalesLine);

                        IF SalesHeader."Prices Including VAT" THEN
                          SalesLineOld := SalesLine;

                        UpdateRec(
                          RecRef,ConvertVATProdPostGrp(VATRateChangeSetup."Update Sales Documents"),
                          ConvertGenProdPostGrp(VATRateChangeSetup."Update Sales Documents"));

                        IF SalesHeader."Prices Including VAT" AND VATRateChangeSetup."Perform Conversion" THEN BEGIN
                          RecRef.SETTABLE(SalesLine);
                          RoundingPrecision := GetRoundingPrecision(SalesHeader."Currency Code");
                          SalesLine.VALIDATE(
                            "Unit Price",
                            ROUND(
                              SalesLineOld."Unit Price" * (100 + SalesLine."VAT %") / (100 + SalesLineOld."VAT %"),RoundingPrecision))
                        END;
                      END ELSE
                        IF VATRateChangeSetup."Perform Conversion" AND (SalesLine."Outstanding Quantity" <> 0) THEN BEGIN
                          NewVATProdPotingGroup := SalesLine."VAT Prod. Posting Group";
                          NewGenProdPostingGroup := SalesLine."Gen. Prod. Posting Group";
                          IF VATRateChangeConversion.GET(
                               VATRateChangeConversion.Type::"VAT Prod. Posting Group",SalesLine."VAT Prod. Posting Group")
                          THEN
                            NewVATProdPotingGroup := VATRateChangeConversion."To Code";
                          IF VATRateChangeConversion.GET(
                               VATRateChangeConversion.Type::"Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group")
                          THEN
                            NewGenProdPostingGroup := VATRateChangeConversion."To Code";
                          AddNewSalesLine(SalesLine,NewVATProdPotingGroup,NewGenProdPostingGroup);
                        END ELSE BEGIN
                          RecRef.GETTABLE(SalesLine);
                          InitVATRateChangeLogEntry(
                            VATRateChangeLogEntry,RecRef,SalesLine."Outstanding Quantity",SalesLine."Line No.");
                          VATRateChangeLogEntry.UpdateGroups(
                            SalesLine."Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group",
                            SalesLine."VAT Prod. Posting Group",SalesLine."VAT Prod. Posting Group");
                          WriteLogEntry(VATRateChangeLogEntry);
                        END;
                UNTIL SalesLine.NEXT = 0;
            END;
            IF SalesHeaderStatusChanged THEN BEGIN
              SalesHeader.Status := SalesHeader2.Status;
              SalesHeader.MODIFY;
            END;
          END;
        UNTIL SalesHeader.NEXT = 0;
    END;

    LOCAL PROCEDURE CanUpdateSales@11(SalesHeader@1007 : Record 36;ConvertVATProdPostingGroup@1005 : Boolean;ConvertGenProdPostingGroup@1004 : Boolean) : Boolean;
    VAR
      SalesLine@1003 : Record 37;
      VATRateChangeLogEntry@1002 : Record 552;
      WhseValidateSourceLine@1000 : Codeunit 5777;
      RecRef@1001 : RecordRef;
      DescriptionTxt@1006 : Text[250];
    BEGIN
      WITH SalesLine DO BEGIN
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        IF FINDSET THEN
          REPEAT
            DescriptionTxt := '';
            IF LineInScope("Gen. Prod. Posting Group","VAT Prod. Posting Group",ConvertGenProdPostingGroup,ConvertVATProdPostingGroup) THEN BEGIN
              IF "Drop Shipment" AND ("Purchase Order No." <> '') THEN
                DescriptionTxt := STRSUBSTNO(Text0004,"Line No.");
              IF "Special Order" AND ("Special Order Purchase No." <> '') THEN
                DescriptionTxt := STRSUBSTNO(Text0005,"Line No.");
              IF ("Outstanding Quantity" <> Quantity) AND
                 WhseValidateSourceLine.WhseLinesExist(DATABASE::"Sales Line","Document Type","Document No.","Line No.",0,Quantity)
              THEN
                DescriptionTxt := Text0006;
              IF ("Outstanding Quantity" <> Quantity) AND (Type = Type::"Charge (Item)") THEN
                DescriptionTxt := STRSUBSTNO(Text0014,"Line No.",Type::"Charge (Item)");
              IF  "Prepmt. Amount Inv. Incl. VAT" <> 0 THEN
                DescriptionTxt := Text0011;
              IF "Qty. to Assemble to Order" <> 0 THEN
                DescriptionTxt := Text0018;
            END;
          UNTIL (NEXT = 0) OR (DescriptionTxt <> '');
      END;
      IF DescriptionTxt = '' THEN
        EXIT(TRUE);

      RecRef.GETTABLE(SalesHeader);
      VATRateChangeLogEntry.INIT;
      VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
      VATRateChangeLogEntry."Table ID" := RecRef.NUMBER;
      VATRateChangeLogEntry.Description := DescriptionTxt;
      WriteLogEntry(VATRateChangeLogEntry);
    END;

    LOCAL PROCEDURE AddNewSalesLine@1000(SalesLine@1022 : Record 37;VATProdPostingGroup@1001 : Code[20];GenProdPostingGroup@1002 : Code[20]);
    VAR
      NewSalesLine@1004 : Record 37;
      OldSalesLine@1005 : Record 37;
      SalesHeader@1006 : Record 36;
      OldReservationEntry@1009 : Record 337;
      NewReservationEntry@1010 : Record 337;
      OldItemChargeAssignmentSales@1011 : Record 5809;
      NewItemChargeAssignmentSales@1012 : Record 5809;
      VATRateChangeLogEntry@1003 : Record 552;
      RecRef@1000 : RecordRef;
      NewLineNo@1015 : Integer;
      QtyRemainder@1016 : Decimal;
      AmountRemainder@1017 : Decimal;
      RoundingPrecision@1018 : Decimal;
    BEGIN
      IF NOT GetNextSalesLineNo(SalesLine,NewLineNo) THEN
        EXIT;
      WITH NewSalesLine DO BEGIN
        INIT;
        NewSalesLine := SalesLine;
        "Line No." := NewLineNo;
        "Quantity Shipped" := 0;
        "Qty. Shipped (Base)" := 0;
        "Return Qty. Received" := 0;
        "Return Qty. Received (Base)" := 0;
        "Quantity Invoiced" := 0;
        "Qty. Invoiced (Base)" := 0;
        "Reserved Quantity" := 0;
        "Reserved Qty. (Base)" := 0;
        "Qty. to Ship" := 0;
        "Qty. to Ship (Base)" := 0;
        "Return Qty. to Receive" := 0;
        "Return Qty. to Receive (Base)" := 0;
        "Qty. to Invoice" := 0;
        "Qty. to Invoice (Base)" := 0;
        "Qty. Shipped Not Invoiced" := 0;
        "Return Qty. Rcd. Not Invd." := 0;
        "Shipped Not Invoiced" := 0;
        "Return Rcd. Not Invd." := 0;
        "Qty. Shipped Not Invd. (Base)" := 0;
        "Ret. Qty. Rcd. Not Invd.(Base)" := 0;
        "Shipped Not Invoiced (LCY)" := 0;
        "Return Rcd. Not Invd. (LCY)" := 0;
        IF (GenProdPostingGroup <> '') AND ConvertGenProdPostGrp(VATRateChangeSetup."Update Sales Documents") THEN
          VALIDATE("Gen. Prod. Posting Group",GenProdPostingGroup);
        IF (VATProdPostingGroup <> '') AND ConvertVATProdPostGrp(VATRateChangeSetup."Update Sales Documents") THEN
          VALIDATE("VAT Prod. Posting Group",VATProdPostingGroup);
        VALIDATE(Quantity,SalesLine."Outstanding Quantity");
        VALIDATE("Qty. to Ship",SalesLine."Qty. to Ship");
        VALIDATE("Return Qty. to Receive",SalesLine."Return Qty. to Receive");
        IF ABS(SalesLine."Qty. to Invoice") > (ABS(SalesLine."Quantity Shipped") - ABS(SalesLine."Quantity Invoiced")) THEN
          VALIDATE(
            "Qty. to Invoice",SalesLine."Qty. to Invoice" - (SalesLine."Quantity Shipped" - SalesLine."Quantity Invoiced"))
        ELSE
          VALIDATE("Qty. to Invoice",0);
        SalesHeader.GET("Document Type","Document No.");
        RoundingPrecision := GetRoundingPrecision(SalesHeader."Currency Code");
        IF SalesHeader."Prices Including VAT" THEN
          VALIDATE("Unit Price",ROUND(SalesLine."Unit Price" * (100 + "VAT %") / (100 + SalesLine."VAT %"),RoundingPrecision))
        ELSE
          VALIDATE("Unit Price",SalesLine."Unit Price");
        VALIDATE("Line Discount %",SalesLine."Line Discount %");
        INSERT;
        RecRef.GETTABLE(SalesLine);
        VATRateChangeLogEntry.INIT;
        VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
        VATRateChangeLogEntry."Table ID" := RecRef.NUMBER;
        VATRateChangeLogEntry.UpdateGroups(
          SalesLine."Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group",
          SalesLine."VAT Prod. Posting Group",SalesLine."VAT Prod. Posting Group");
        VATRateChangeLogEntry.Description := STRSUBSTNO(Text0012,FORMAT(SalesLine."Line No."));
        VATRateChangeLogEntry.Converted := TRUE;
        WriteLogEntry(VATRateChangeLogEntry);

        RecRef.GETTABLE(NewSalesLine);
        VATRateChangeLogEntry.INIT;
        VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
        VATRateChangeLogEntry."Table ID" := RecRef.NUMBER;
        VATRateChangeLogEntry.UpdateGroups(
          SalesLine."Gen. Prod. Posting Group","Gen. Prod. Posting Group",
          SalesLine."VAT Prod. Posting Group","VAT Prod. Posting Group");
        VATRateChangeLogEntry.Description := STRSUBSTNO(Text0013,FORMAT("Line No."),FORMAT(SalesLine."Line No."));
        VATRateChangeLogEntry.Converted := TRUE;
        WriteLogEntry(VATRateChangeLogEntry);
      END;

      UpdateSalesBlanketOrder(NewSalesLine,SalesLine."Line No.");

      OldReservationEntry.RESET;
      OldReservationEntry.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
      OldReservationEntry.SETRANGE("Source ID",SalesLine."Document No.");
      OldReservationEntry.SETRANGE("Source Ref. No.",SalesLine."Line No.");
      OldReservationEntry.SETRANGE("Source Type",DATABASE::"Sales Line");
      OldReservationEntry.SETRANGE("Source Subtype",SalesLine."Document Type");
      OldReservationEntry.SETFILTER(
        "Reservation Status",'%1|%2',OldReservationEntry."Reservation Status"::Reservation,
        OldReservationEntry."Reservation Status"::Surplus);
      IF OldReservationEntry.FINDSET THEN
        REPEAT
          NewReservationEntry := OldReservationEntry;
          NewReservationEntry."Source Ref. No." := NewLineNo;
          NewReservationEntry.MODIFY;
        UNTIL OldReservationEntry.NEXT = 0;

      CASE SalesLine.Type OF
        SalesLine.Type::Item:
          BEGIN
            OldItemChargeAssignmentSales.RESET;
            OldItemChargeAssignmentSales.SETCURRENTKEY("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
            OldItemChargeAssignmentSales.SETRANGE("Applies-to Doc. Type",SalesLine."Document Type");
            OldItemChargeAssignmentSales.SETRANGE("Applies-to Doc. No.",SalesLine."Document No.");
            OldItemChargeAssignmentSales.SETRANGE("Applies-to Doc. Line No.",SalesLine."Line No.");
            IF OldItemChargeAssignmentSales.FIND('-') THEN
              REPEAT
                QtyRemainder := OldItemChargeAssignmentSales."Qty. to Assign";
                AmountRemainder := OldItemChargeAssignmentSales."Amount to Assign";
                NewItemChargeAssignmentSales := OldItemChargeAssignmentSales;
                NewItemChargeAssignmentSales."Line No." := GetNextItemChrgAssSaleLineNo(OldItemChargeAssignmentSales);
                NewItemChargeAssignmentSales."Applies-to Doc. Line No." := NewLineNo;
                NewItemChargeAssignmentSales."Qty. to Assign" :=
                  ROUND(QtyRemainder / SalesLine.Quantity * SalesLine."Outstanding Quantity",0.00001);
                IF SalesLine."Quantity Shipped" - SalesLine."Quantity Invoiced" = 0 THEN
                  NewItemChargeAssignmentSales."Qty. to Assign" := QtyRemainder;
                NewItemChargeAssignmentSales."Amount to Assign" :=
                  ROUND(NewItemChargeAssignmentSales."Qty. to Assign" * NewItemChargeAssignmentSales."Unit Cost",RoundingPrecision);
                NewItemChargeAssignmentSales.INSERT;
                QtyRemainder := QtyRemainder - NewItemChargeAssignmentSales."Qty. to Assign";
                AmountRemainder := AmountRemainder - NewItemChargeAssignmentSales."Amount to Assign";
                OldItemChargeAssignmentSales."Qty. to Assign" := QtyRemainder;
                OldItemChargeAssignmentSales."Amount to Assign" := AmountRemainder;
                OldItemChargeAssignmentSales.MODIFY;
              UNTIL OldItemChargeAssignmentSales.NEXT = 0;
          END;
      END;

      OldSalesLine.GET(SalesLine."Document Type",SalesLine."Document No.",SalesLine."Line No.");
      OldSalesLine.VALIDATE(Quantity,SalesLine."Quantity Shipped");

      OldSalesLine.VALIDATE("Unit Price",SalesLine."Unit Price");
      OldSalesLine.VALIDATE("Line Discount %",SalesLine."Line Discount %");
      OldSalesLine.VALIDATE("Qty. to Ship",0);
      OldSalesLine.VALIDATE("Return Qty. to Receive",0);
      IF ABS(SalesLine."Qty. to Invoice") > (ABS(SalesLine."Quantity Shipped") - ABS(SalesLine."Quantity Invoiced")) THEN
        OldSalesLine.VALIDATE("Qty. to Invoice",SalesLine."Quantity Shipped" - SalesLine."Quantity Invoiced")
      ELSE
        OldSalesLine.VALIDATE("Qty. to Invoice",SalesLine."Qty. to Invoice");

      OldSalesLine.MODIFY;
    END;

    LOCAL PROCEDURE UpdateSalesBlanketOrder@20(SalesLine@1000 : Record 37;OriginalLineNo@1004 : Integer);
    VAR
      SalesHeader@1003 : Record 36;
      SalesLine2@1002 : Record 37;
      SalesLine3@1001 : Record 37;
    BEGIN
      IF SalesLine."Document Type" = SalesLine."Document Type"::"Blanket Order" THEN BEGIN
        SalesLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
        SalesLine2.SETRANGE("Blanket Order No.",SalesLine."Document No.");
        SalesLine2.SETFILTER("Blanket Order Line No.",'=%1',OriginalLineNo);
        SalesLine2.SETRANGE(Type,SalesLine.Type);
        SalesLine2.SETRANGE("No.",SalesLine."No.");
        CLEAR(SalesHeader);
        IF SalesLine2.FINDSET THEN
          REPEAT
            IF (SalesHeader."Document Type" <> SalesLine2."Document Type") OR
               (SalesHeader."No." <> SalesLine2."Document No.")
            THEN BEGIN
              SalesHeader.GET(SalesLine2."Document Type",SalesLine2."Document No.");
              SalesLine3.RESET;
              SalesLine3.SETRANGE("Document Type",SalesHeader."Document Type");
              SalesLine3.SETRANGE("Document No.",SalesHeader."No.");
              SalesLine3.SETRANGE("Blanket Order No.",SalesLine2."Blanket Order No.");
              SalesLine3.SETRANGE("Blanket Order Line No.",SalesLine2."Blanket Order Line No.");
              IF SalesLine3.FINDLAST THEN BEGIN
                SalesLine3."Blanket Order Line No." := SalesLine."Line No.";
                SalesLine3.MODIFY;
              END;
            END;
          UNTIL SalesLine2.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE UpdatePurchase@9();
    VAR
      PurchaseHeader@1000 : Record 38;
      PurchaseHeader2@1004 : Record 38;
      PurchaseLine@1003 : Record 39;
      PurchaseLineOld@1010 : Record 39;
      VATRateChangeLogEntry@1002 : Record 552;
      RecRef@1001 : RecordRef;
      NewVATProdPotingGroup@1007 : Code[20];
      NewGenProdPostingGroup@1008 : Code[20];
      StatusChanged@1005 : Boolean;
      ConvertVATProdPostingGroup@1009 : Boolean;
      ConvertGenProdPostingGroup@1006 : Boolean;
      RoundingPrecision@1011 : Decimal;
    BEGIN
      ProgressWindow.UPDATE(1,PurchaseHeader.TABLECAPTION);
      ConvertVATProdPostingGroup := ConvertVATProdPostGrp(VATRateChangeSetup."Update Purchase Documents");
      ConvertGenProdPostingGroup := ConvertGenProdPostGrp(VATRateChangeSetup."Update Purchase Documents");
      IF NOT ConvertVATProdPostingGroup AND NOT ConvertGenProdPostingGroup THEN
        EXIT;

      PurchaseHeader.SETFILTER(
        "Document Type",'%1..%2|%3',PurchaseHeader."Document Type"::Quote,PurchaseHeader."Document Type"::Invoice,
        PurchaseHeader."Document Type"::"Blanket Order");

      IF PurchaseHeader.FIND('-') THEN
        REPEAT
          StatusChanged := FALSE;
          IF CanUpdatePurchase(PurchaseHeader,ConvertGenProdPostingGroup,ConvertVATProdPostingGroup) THEN BEGIN
            IF VATRateChangeSetup."Ignore Status on Purch. Docs." THEN
              IF PurchaseHeader.Status <> PurchaseHeader.Status::Open THEN BEGIN
                PurchaseHeader2 := PurchaseHeader;
                PurchaseHeader.Status := PurchaseHeader.Status::Open;
                PurchaseHeader.MODIFY;
                StatusChanged := TRUE;
              END;
            IF PurchaseHeader.Status = PurchaseHeader.Status::Open THEN BEGIN
              PurchaseLine.SETRANGE("Document Type",PurchaseHeader."Document Type");
              PurchaseLine.SETRANGE("Document No.",PurchaseHeader."No.");
              IF PurchaseLine.FINDSET THEN
                REPEAT
                  IF LineInScope(
                       PurchaseLine."Gen. Prod. Posting Group",PurchaseLine."VAT Prod. Posting Group",ConvertGenProdPostingGroup,
                       ConvertVATProdPostingGroup)
                  THEN
                    IF (PurchaseLine."Receipt No." = '') AND
                       (PurchaseLine."Return Shipment No." = '') AND IncludeLine(PurchaseLine.Type,PurchaseLine."No.")
                    THEN
                      IF PurchaseLine.Quantity = PurchaseLine."Outstanding Quantity" THEN BEGIN
                        IF PurchaseHeader."Prices Including VAT" THEN
                          PurchaseLineOld := PurchaseLine;

                        RecRef.GETTABLE(PurchaseLine);
                        UpdateRec(
                          RecRef,ConvertVATProdPostGrp(VATRateChangeSetup."Update Purchase Documents"),
                          ConvertGenProdPostGrp(VATRateChangeSetup."Update Purchase Documents"));

                        IF PurchaseHeader."Prices Including VAT" AND VATRateChangeSetup."Perform Conversion" THEN BEGIN
                          RecRef.SETTABLE(PurchaseLine);
                          RoundingPrecision := GetRoundingPrecision(PurchaseHeader."Currency Code");
                          PurchaseLine.VALIDATE(
                            "Direct Unit Cost",
                            ROUND(
                              PurchaseLineOld."Direct Unit Cost" * (100 + PurchaseLine."VAT %") / (100 + PurchaseLineOld."VAT %"),
                              RoundingPrecision));
                        END;
                      END ELSE
                        IF VATRateChangeSetup."Perform Conversion" AND (PurchaseLine."Outstanding Quantity" <> 0) THEN BEGIN
                          NewVATProdPotingGroup := PurchaseLine."VAT Prod. Posting Group";
                          NewGenProdPostingGroup := PurchaseLine."Gen. Prod. Posting Group";
                          IF ConvertVATProdPostingGroup THEN
                            IF VATRateChangeConversion.GET(
                                 VATRateChangeConversion.Type::"VAT Prod. Posting Group",PurchaseLine."VAT Prod. Posting Group")
                            THEN
                              NewVATProdPotingGroup := VATRateChangeConversion."To Code";
                          IF ConvertGenProdPostingGroup THEN
                            IF VATRateChangeConversion.GET(
                                 VATRateChangeConversion.Type::"Gen. Prod. Posting Group",PurchaseLine."Gen. Prod. Posting Group")
                            THEN
                              NewGenProdPostingGroup := VATRateChangeConversion."To Code";
                          AddNewPurchaseLine(PurchaseLine,NewVATProdPotingGroup,NewGenProdPostingGroup);
                        END ELSE BEGIN
                          RecRef.GETTABLE(PurchaseLine);
                          InitVATRateChangeLogEntry(
                            VATRateChangeLogEntry,RecRef,PurchaseLine."Outstanding Quantity",PurchaseLine."Line No.");
                          VATRateChangeLogEntry.UpdateGroups(
                            PurchaseLine."Gen. Prod. Posting Group",PurchaseLine."Gen. Prod. Posting Group",
                            PurchaseLine."VAT Prod. Posting Group",PurchaseLine."VAT Prod. Posting Group");
                          WriteLogEntry(VATRateChangeLogEntry);
                        END;
                UNTIL PurchaseLine.NEXT = 0;
            END;
            IF StatusChanged THEN BEGIN
              PurchaseHeader.Status := PurchaseHeader2.Status;
              PurchaseHeader.MODIFY;
            END;
          END;
        UNTIL PurchaseHeader.NEXT = 0;
    END;

    LOCAL PROCEDURE CanUpdatePurchase@16(PurchaseHeader@1007 : Record 38;ConvertGenProdPostingGroup@1004 : Boolean;ConvertVATProdPostingGroup@1005 : Boolean) : Boolean;
    VAR
      PurchaseLine@1003 : Record 39;
      VATRateChangeLogEntry@1002 : Record 552;
      WhseValidateSourceLine@1000 : Codeunit 5777;
      RecRef@1001 : RecordRef;
      DescriptionTxt@1006 : Text[250];
    BEGIN
      WITH PurchaseLine DO BEGIN
        SETRANGE("Document Type",PurchaseHeader."Document Type");
        SETRANGE("Document No.",PurchaseHeader."No.");
        IF FINDSET THEN
          REPEAT
            DescriptionTxt := '';
            IF LineInScope("Gen. Prod. Posting Group","VAT Prod. Posting Group",ConvertGenProdPostingGroup,ConvertVATProdPostingGroup) THEN BEGIN
              IF "Drop Shipment" AND ("Sales Order No." <> '') THEN
                DescriptionTxt := STRSUBSTNO(Text0004,"Line No.");
              IF "Special Order" AND ("Special Order Sales No." <> '') THEN
                DescriptionTxt := STRSUBSTNO(Text0005,"Line No.");
              IF ("Outstanding Quantity" <> Quantity) AND
                 WhseValidateSourceLine.WhseLinesExist(
                   DATABASE::"Purchase Line","Document Type","Document No.","Line No.",0,Quantity)
              THEN
                DescriptionTxt := Text0006;
              IF ("Outstanding Quantity" <> Quantity) AND (Type = Type::"Charge (Item)") THEN
                DescriptionTxt := STRSUBSTNO(Text0014,"Line No.",Type::"Charge (Item)");
              IF  "Prepmt. Amount Inv. (LCY)" <> 0 THEN
                DescriptionTxt := Text0011;
            END;
          UNTIL (NEXT = 0) OR (DescriptionTxt <> '');
      END;
      IF DescriptionTxt = '' THEN
        EXIT(TRUE);

      VATRateChangeLogEntry.INIT;
      RecRef.GETTABLE(PurchaseHeader);
      VATRateChangeLogEntry.INIT;
      VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
      VATRateChangeLogEntry."Table ID" := RecRef.NUMBER;
      VATRateChangeLogEntry.Description := DescriptionTxt;
      WriteLogEntry(VATRateChangeLogEntry);
    END;

    LOCAL PROCEDURE AddNewPurchaseLine@17(PurchaseLine@1001 : Record 39;VATProdPostingGroup@1000 : Code[20];GenProdPostingGroup@1002 : Code[20]);
    VAR
      NewPurchaseLine@1004 : Record 39;
      OldPurchaseLine@1005 : Record 39;
      PurchaseHeader@1006 : Record 38;
      OldReservationEntry@1009 : Record 337;
      NewReservationEntry@1010 : Record 337;
      OldItemChargeAssignmentPurch@1011 : Record 5805;
      NewItemChargeAssignmentPurch@1012 : Record 5805;
      VATRateChangeLogEntry@1007 : Record 552;
      RecRef@1003 : RecordRef;
      NewLineNo@1015 : Integer;
      QtyRemainder@1016 : Decimal;
      AmountRemainder@1017 : Decimal;
      RoundingPrecision@1018 : Decimal;
    BEGIN
      IF NOT GetNextPurchaseLineNo(PurchaseLine,NewLineNo) THEN
        EXIT;

      WITH NewPurchaseLine DO BEGIN
        INIT;
        NewPurchaseLine := PurchaseLine;
        "Line No." := NewLineNo;
        "Quantity Received" := 0;
        "Qty. Received (Base)" := 0;
        "Return Qty. Shipped" := 0;
        "Return Qty. Shipped (Base)" := 0;
        "Quantity Invoiced" := 0;
        "Qty. Invoiced (Base)" := 0;
        "Reserved Quantity" := 0;
        "Reserved Qty. (Base)" := 0;
        "Qty. Rcd. Not Invoiced" := 0;
        "Qty. Rcd. Not Invoiced (Base)" := 0;
        "Return Qty. Shipped Not Invd." := 0;
        "Ret. Qty. Shpd Not Invd.(Base)" := 0;
        "Qty. to Receive" := 0;
        "Qty. to Receive (Base)" := 0;
        "Return Qty. to Ship" := 0;
        "Return Qty. to Ship (Base)" := 0;
        "Qty. to Invoice" := 0;
        "Qty. to Invoice (Base)" := 0;
        "Amt. Rcd. Not Invoiced" := 0;
        "Amt. Rcd. Not Invoiced (LCY)" := 0;
        "Return Shpd. Not Invd." := 0;
        "Return Shpd. Not Invd. (LCY)" := 0;
        IF (GenProdPostingGroup <> '') AND ConvertGenProdPostGrp(VATRateChangeSetup."Update Purchase Documents") THEN
          VALIDATE("Gen. Prod. Posting Group",GenProdPostingGroup);
        IF (VATProdPostingGroup <> '') AND ConvertVATProdPostGrp(VATRateChangeSetup."Update Purchase Documents") THEN
          VALIDATE("VAT Prod. Posting Group",VATProdPostingGroup);
        VALIDATE(Quantity,PurchaseLine."Outstanding Quantity");
        VALIDATE("Qty. to Receive",PurchaseLine."Qty. to Receive");
        VALIDATE("Return Qty. to Ship",PurchaseLine."Return Qty. to Ship");
        IF ABS(PurchaseLine."Qty. to Invoice") > (ABS(PurchaseLine."Quantity Received") - ABS(PurchaseLine."Quantity Invoiced")) THEN
          VALIDATE(
            "Qty. to Invoice",PurchaseLine."Qty. to Invoice" - (PurchaseLine."Quantity Received" - PurchaseLine."Quantity Invoiced"))
        ELSE
          VALIDATE("Qty. to Invoice",0);

        PurchaseHeader.GET("Document Type","Document No.");
        RoundingPrecision := GetRoundingPrecision(PurchaseHeader."Currency Code");

        IF PurchaseHeader."Prices Including VAT" THEN
          VALIDATE(
            "Direct Unit Cost",
            ROUND(PurchaseLine."Direct Unit Cost" * (100 + "VAT %") / (100 + PurchaseLine."VAT %"),RoundingPrecision))
        ELSE
          VALIDATE("Direct Unit Cost",PurchaseLine."Direct Unit Cost");

        VALIDATE("Line Discount %",PurchaseLine."Line Discount %");
        INSERT;
        RecRef.GETTABLE(PurchaseLine);
        VATRateChangeLogEntry.INIT;
        VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
        VATRateChangeLogEntry."Table ID" := RecRef.NUMBER;
        VATRateChangeLogEntry.Description := STRSUBSTNO(Text0012,FORMAT(PurchaseLine."Line No."));
        VATRateChangeLogEntry.UpdateGroups(
          PurchaseLine."Gen. Prod. Posting Group",PurchaseLine."Gen. Prod. Posting Group",
          PurchaseLine."VAT Prod. Posting Group",PurchaseLine."VAT Prod. Posting Group");
        VATRateChangeLogEntry.Converted := TRUE;
        WriteLogEntry(VATRateChangeLogEntry);

        RecRef.GETTABLE(NewPurchaseLine);
        VATRateChangeLogEntry.INIT;
        VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
        VATRateChangeLogEntry."Table ID" := RecRef.NUMBER;
        VATRateChangeLogEntry.UpdateGroups(
          PurchaseLine."Gen. Prod. Posting Group","Gen. Prod. Posting Group",
          PurchaseLine."VAT Prod. Posting Group","VAT Prod. Posting Group");
        VATRateChangeLogEntry.Description := STRSUBSTNO(Text0013,FORMAT("Line No."),FORMAT(PurchaseLine."Line No."));
        VATRateChangeLogEntry.Converted := TRUE;
        WriteLogEntry(VATRateChangeLogEntry);
      END;

      UpdatePurchaseBlanketOrder(NewPurchaseLine,PurchaseLine."Line No.");

      OldReservationEntry.RESET;
      OldReservationEntry.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
      OldReservationEntry.SETRANGE("Source ID",PurchaseLine."Document No.");
      OldReservationEntry.SETRANGE("Source Ref. No.",PurchaseLine."Line No.");
      OldReservationEntry.SETRANGE("Source Type",DATABASE::"Purchase Line");
      OldReservationEntry.SETRANGE("Source Subtype",PurchaseLine."Document Type");
      OldReservationEntry.SETFILTER(
        "Reservation Status",'%1|%2',
        OldReservationEntry."Reservation Status"::Reservation,
        OldReservationEntry."Reservation Status"::Surplus);
      IF OldReservationEntry.FIND('-') THEN
        REPEAT
          NewReservationEntry := OldReservationEntry;
          NewReservationEntry."Source Ref. No." := NewLineNo;
          NewReservationEntry.MODIFY;
        UNTIL OldReservationEntry.NEXT = 0;

      CASE PurchaseLine.Type OF
        PurchaseLine.Type::Item:
          BEGIN
            OldItemChargeAssignmentPurch.RESET;
            OldItemChargeAssignmentPurch.SETCURRENTKEY("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
            OldItemChargeAssignmentPurch.SETRANGE("Applies-to Doc. Type",PurchaseLine."Document Type");
            OldItemChargeAssignmentPurch.SETRANGE("Applies-to Doc. No.",PurchaseLine."Document No.");
            OldItemChargeAssignmentPurch.SETRANGE("Applies-to Doc. Line No.",PurchaseLine."Line No.");
            IF OldItemChargeAssignmentPurch.FINDSET THEN
              REPEAT
                QtyRemainder := OldItemChargeAssignmentPurch."Qty. to Assign";
                AmountRemainder := OldItemChargeAssignmentPurch."Amount to Assign";
                NewItemChargeAssignmentPurch := OldItemChargeAssignmentPurch;
                NewItemChargeAssignmentPurch."Line No." := GetNextItemChrgAssPurchLineNo(OldItemChargeAssignmentPurch);
                NewItemChargeAssignmentPurch."Applies-to Doc. Line No." := NewLineNo;
                NewItemChargeAssignmentPurch."Qty. to Assign" :=
                  ROUND(QtyRemainder / PurchaseLine.Quantity * PurchaseLine."Outstanding Quantity",0.00001);
                IF PurchaseLine."Quantity Received" - PurchaseLine."Quantity Invoiced" = 0 THEN
                  NewItemChargeAssignmentPurch."Qty. to Assign" := QtyRemainder;
                NewItemChargeAssignmentPurch."Amount to Assign" :=
                  ROUND(NewItemChargeAssignmentPurch."Qty. to Assign" * NewItemChargeAssignmentPurch."Unit Cost",RoundingPrecision);
                NewItemChargeAssignmentPurch.INSERT;
                QtyRemainder := QtyRemainder - NewItemChargeAssignmentPurch."Qty. to Assign";
                AmountRemainder := AmountRemainder - NewItemChargeAssignmentPurch."Amount to Assign";
                OldItemChargeAssignmentPurch."Qty. to Assign" := QtyRemainder;
                OldItemChargeAssignmentPurch."Amount to Assign" := AmountRemainder;
                OldItemChargeAssignmentPurch.MODIFY;
              UNTIL OldItemChargeAssignmentPurch.NEXT = 0;
          END;
      END;

      OldPurchaseLine.GET(PurchaseLine."Document Type",PurchaseLine."Document No.",PurchaseLine."Line No.");
      OldPurchaseLine.VALIDATE(Quantity,PurchaseLine."Quantity Received");

      OldPurchaseLine.VALIDATE("Direct Unit Cost",PurchaseLine."Direct Unit Cost");

      OldPurchaseLine.VALIDATE("Line Discount %",PurchaseLine."Line Discount %");
      OldPurchaseLine.VALIDATE("Qty. to Receive",0);
      OldPurchaseLine.VALIDATE("Return Qty. to Ship",0);
      IF ABS(PurchaseLine."Qty. to Invoice") > (ABS(PurchaseLine."Quantity Received") - ABS(PurchaseLine."Quantity Invoiced")) THEN
        OldPurchaseLine.VALIDATE("Qty. to Invoice",PurchaseLine."Quantity Received" - PurchaseLine."Quantity Invoiced")
      ELSE
        OldPurchaseLine.VALIDATE("Qty. to Invoice",PurchaseLine."Qty. to Invoice");

      OldPurchaseLine.MODIFY;
    END;

    [External]
    PROCEDURE GetNextPurchaseLineNo@18(PurchaseLine@1001 : Record 39;VAR NextLineNo@1002 : Integer) : Boolean;
    VAR
      PurchaseLine2@1000 : Record 39;
    BEGIN
      PurchaseLine2.RESET;
      PurchaseLine2.SETRANGE("Document Type",PurchaseLine."Document Type");
      PurchaseLine2.SETRANGE("Document No.",PurchaseLine."Document No.");
      PurchaseLine2 := PurchaseLine;
      IF PurchaseLine2.FIND('>') THEN
        NextLineNo := PurchaseLine."Line No." + (PurchaseLine2."Line No." - PurchaseLine."Line No.") DIV 2;
      IF (NextLineNo = PurchaseLine."Line No.") OR (NextLineNo = 0) THEN BEGIN
        PurchaseLine2.FINDLAST;
        NextLineNo := PurchaseLine2."Line No." + 10000;
      END;
      EXIT(NextLineNo <> PurchaseLine."Line No.");
    END;

    LOCAL PROCEDURE UpdatePurchaseBlanketOrder@22(PurchaseLine@1000 : Record 39;OriginalLineNo@1004 : Integer);
    VAR
      PurchaseHeader@1003 : Record 38;
      PurchaseLine2@1002 : Record 39;
      PurchaseLine3@1001 : Record 39;
    BEGIN
      IF PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Blanket Order" THEN BEGIN
        PurchaseLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
        PurchaseLine2.SETRANGE("Blanket Order No.",PurchaseLine."Document No.");
        PurchaseLine2.SETFILTER("Blanket Order Line No.",'=%1',OriginalLineNo);
        PurchaseLine2.SETRANGE(Type,PurchaseLine.Type);
        PurchaseLine2.SETRANGE("No.",PurchaseLine."No.");
        CLEAR(PurchaseHeader);
        IF PurchaseLine2.FIND('-') THEN
          REPEAT
            IF (PurchaseHeader."Document Type" <> PurchaseLine2."Document Type") OR
               (PurchaseHeader."No." <> PurchaseLine2."Document No.")
            THEN BEGIN
              PurchaseHeader.GET(PurchaseLine2."Document Type",PurchaseLine2."Document No.");
              PurchaseLine3.RESET;
              PurchaseLine3.SETRANGE("Document Type",PurchaseHeader."Document Type");
              PurchaseLine3.SETRANGE("Document No.",PurchaseHeader."No.");
              PurchaseLine3.SETRANGE("Blanket Order No.",PurchaseLine2."Blanket Order No.");
              PurchaseLine3.SETRANGE("Blanket Order Line No.",PurchaseLine2."Blanket Order Line No.");
              IF PurchaseLine3.FINDLAST THEN BEGIN
                PurchaseLine3."Blanket Order Line No." := PurchaseLine."Line No.";
                PurchaseLine3.MODIFY;
              END;
            END;
          UNTIL PurchaseLine2.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE LineInScope@13(GenProdPostingGroup@1000 : Code[20];VATProdPostingGroup@1001 : Code[20];ConvertGenProdPostingGroup@1002 : Boolean;ConvertVATProdPostingGroup@1003 : Boolean) : Boolean;
    BEGIN
      IF ConvertGenProdPostingGroup THEN
        IF VATRateChangeConversion.GET(VATRateChangeConversion.Type::"Gen. Prod. Posting Group",GenProdPostingGroup) THEN
          EXIT(TRUE);
      IF ConvertVATProdPostingGroup THEN
        IF VATRateChangeConversion.GET(VATRateChangeConversion.Type::"VAT Prod. Posting Group",VATProdPostingGroup) THEN
          EXIT(TRUE);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE GetNextSalesLineNo@1050(SalesLine@1000 : Record 37;VAR NextLineNo@1001 : Integer) : Boolean;
    VAR
      SalesLine2@1002 : Record 37;
    BEGIN
      SalesLine2.RESET;
      SalesLine2.SETRANGE("Document Type",SalesLine."Document Type");
      SalesLine2.SETRANGE("Document No.",SalesLine."Document No.");
      SalesLine2 := SalesLine;
      IF SalesLine2.FIND('>') THEN
        NextLineNo := SalesLine."Line No." + (SalesLine2."Line No." - SalesLine."Line No.") DIV 2;
      IF (NextLineNo = SalesLine."Line No.") OR (NextLineNo = 0) THEN BEGIN
        SalesLine2.FINDLAST;
        NextLineNo := SalesLine2."Line No." + 10000;
      END;
      EXIT(NextLineNo <> SalesLine."Line No.");
    END;

    LOCAL PROCEDURE UpdateServPriceAdjDetail@14();
    VAR
      VatRateChangeConversion@1001 : Record 551;
      ServPriceAdjustmentDetail@1000 : Record 6083;
      ServPriceAdjustmentDetailNew@1002 : Record 6083;
      VATRateChangeLogEntry@1003 : Record 552;
      RecRef@1004 : RecordRef;
    BEGIN
      IF VATRateChangeSetup."Update Serv. Price Adj. Detail" <>
         VATRateChangeSetup."Update Serv. Price Adj. Detail"::"Gen. Prod. Posting Group"
      THEN
        EXIT;
      VatRateChangeConversion.SETRANGE(Type,VatRateChangeConversion.Type::"Gen. Prod. Posting Group");
      IF VatRateChangeConversion.FINDSET THEN
        REPEAT
          WITH ServPriceAdjustmentDetail DO BEGIN
            SETRANGE("Gen. Prod. Posting Group",VatRateChangeConversion."From Code");
            IF FINDSET THEN
              REPEAT
                VATRateChangeLogEntry.INIT;
                RecRef.GETTABLE(ServPriceAdjustmentDetailNew);
                VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
                VATRateChangeLogEntry."Table ID" := DATABASE::"Serv. Price Adjustment Detail";
                VATRateChangeLogEntry."Old Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                VATRateChangeLogEntry."New Gen. Prod. Posting Group" := VatRateChangeConversion."To Code";
                ServPriceAdjustmentDetailNew := ServPriceAdjustmentDetail;
                IF VATRateChangeSetup."Perform Conversion" THEN BEGIN
                  ServPriceAdjustmentDetailNew.RENAME(
                    "Serv. Price Adjmt. Gr. Code",Type,"No.","Work Type",VatRateChangeConversion."To Code");
                  VATRateChangeLogEntry.Converted := TRUE
                END ELSE
                  VATRateChangeLogEntry.Description := STRSUBSTNO(Text0009,VATRateChangeSetup.FIELDCAPTION("Perform Conversion"));
                WriteLogEntry(VATRateChangeLogEntry);
              UNTIL NEXT = 0;
          END;
        UNTIL VatRateChangeConversion.NEXT = 0;
    END;

    LOCAL PROCEDURE GetRoundingPrecision@19(CurrencyCode@1000 : Code[10]) : Decimal;
    VAR
      Currency@1001 : Record 4;
    BEGIN
      IF CurrencyCode = '' THEN
        Currency.InitRoundingPrecision
      ELSE
        Currency.GET(CurrencyCode);
      EXIT(Currency."Unit-Amount Rounding Precision");
    END;

    LOCAL PROCEDURE CanUpdateService@21(ServiceLine@1007 : Record 5902) : Boolean;
    VAR
      ServiceHeader@1002 : Record 5900;
      VATRateChangeLogEntry@1000 : Record 552;
      RecRef@1001 : RecordRef;
      DescriptionTxt@1006 : Text[250];
    BEGIN
      DescriptionTxt := '';
      WITH ServiceLine DO BEGIN
        IF "Shipment No." <> '' THEN
          DescriptionTxt := Text0010;
      END;
      IF DescriptionTxt = '' THEN
        EXIT(TRUE);

      VATRateChangeLogEntry.INIT;
      ServiceHeader.GET(ServiceLine."Document Type",ServiceLine."Document No.");
      RecRef.GETTABLE(ServiceHeader);
      VATRateChangeLogEntry.INIT;
      VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
      VATRateChangeLogEntry."Table ID" := RecRef.NUMBER;
      VATRateChangeLogEntry.Description := DescriptionTxt;
      WriteLogEntry(VATRateChangeLogEntry);
    END;

    LOCAL PROCEDURE UpdateService@23();
    VAR
      ServiceHeader@1008 : Record 5900;
      ServiceHeader2@1011 : Record 5900;
      ServiceLine@1000 : Record 5902;
      ServiceLineOld@1007 : Record 5902;
      VATRateChangeLogEntry@1004 : Record 552;
      RecRef@1001 : RecordRef;
      NewVATProdPotingGroup@1003 : Code[20];
      NewGenProdPostingGroup@1002 : Code[20];
      ConvertVATProdPostingGroup@1006 : Boolean;
      ConvertGenProdPostingGroup@1005 : Boolean;
      ServiceHeaderStatusChanged@1012 : Boolean;
      RoundingPrecision@1009 : Decimal;
      LastDocNo@1010 : Code[20];
    BEGIN
      ProgressWindow.UPDATE(1,ServiceLine.TABLECAPTION);
      ConvertVATProdPostingGroup := ConvertVATProdPostGrp(VATRateChangeSetup."Update Service Docs.");
      ConvertGenProdPostingGroup := ConvertGenProdPostGrp(VATRateChangeSetup."Update Service Docs.");
      IF NOT ConvertVATProdPostingGroup AND NOT ConvertGenProdPostingGroup THEN
        EXIT;

      WITH ServiceLine DO BEGIN
        SETFILTER("Document Type",'%1|%2|%3',"Document Type"::Quote,"Document Type"::Order,"Document Type"::Invoice);
        SETRANGE("Shipment No.",'');
        LastDocNo := '';
        IF FIND('-') THEN
          REPEAT
            IF LineInScope("Gen. Prod. Posting Group","VAT Prod. Posting Group",ConvertGenProdPostingGroup,ConvertVATProdPostingGroup) THEN
              IF CanUpdateService(ServiceLine) AND IncludeServiceLine(Type,"No.") THEN BEGIN
                IF LastDocNo <> "Document No." THEN BEGIN
                  ServiceHeader.GET("Document Type","Document No.");
                  LastDocNo := ServiceHeader."No.";
                END;

                IF VATRateChangeSetup."Ignore Status on Service Docs." THEN
                  IF ServiceHeader."Release Status" <> ServiceHeader."Release Status"::Open THEN BEGIN
                    ServiceHeader2 := ServiceHeader;
                    ServiceHeader."Release Status" := ServiceHeader."Release Status"::Open;
                    ServiceHeader.MODIFY;
                    ServiceHeaderStatusChanged := TRUE;
                  END;

                IF Quantity = "Outstanding Quantity" THEN BEGIN
                  IF ServiceHeader."Prices Including VAT" THEN
                    ServiceLineOld := ServiceLine;

                  RecRef.GETTABLE(ServiceLine);
                  UpdateRec(
                    RecRef,ConvertVATProdPostGrp(VATRateChangeSetup."Update Service Docs."),
                    ConvertGenProdPostGrp(VATRateChangeSetup."Update Service Docs."));

                  IF ServiceHeader."Prices Including VAT" AND VATRateChangeSetup."Perform Conversion" THEN BEGIN
                    RecRef.SETTABLE(ServiceLine);
                    RoundingPrecision := GetRoundingPrecision(ServiceHeader."Currency Code");
                    VALIDATE("Unit Price",ROUND("Unit Price" * (100 + "VAT %") / (100 + ServiceLineOld."VAT %"),RoundingPrecision))
                  END;
                END ELSE
                  IF VATRateChangeSetup."Perform Conversion" AND ("Outstanding Quantity" <> 0) THEN BEGIN
                    NewVATProdPotingGroup := "VAT Prod. Posting Group";
                    NewGenProdPostingGroup := "Gen. Prod. Posting Group";
                    IF ConvertVATProdPostingGroup THEN
                      IF VATRateChangeConversion.GET(
                           VATRateChangeConversion.Type::"VAT Prod. Posting Group","VAT Prod. Posting Group")
                      THEN
                        NewVATProdPotingGroup := VATRateChangeConversion."To Code";
                    IF ConvertGenProdPostingGroup THEN
                      IF VATRateChangeConversion.GET(
                           VATRateChangeConversion.Type::"Gen. Prod. Posting Group","Gen. Prod. Posting Group")
                      THEN
                        NewGenProdPostingGroup := VATRateChangeConversion."To Code";
                    AddNewServiceLine(ServiceLine,NewVATProdPotingGroup,NewGenProdPostingGroup);
                  END ELSE BEGIN
                    RecRef.GETTABLE(ServiceLine);
                    InitVATRateChangeLogEntry(VATRateChangeLogEntry,RecRef,"Outstanding Quantity","Line No.");
                    VATRateChangeLogEntry.UpdateGroups(
                      "Gen. Prod. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","VAT Prod. Posting Group");
                    WriteLogEntry(VATRateChangeLogEntry);
                  END;

                IF ServiceHeaderStatusChanged THEN BEGIN
                  ServiceHeader."Release Status" := ServiceHeader2."Release Status";
                  ServiceHeader.MODIFY;
                  ServiceHeaderStatusChanged := FALSE;
                END;
              END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE AddNewServiceLine@27(ServiceLine@1022 : Record 5902;VATProdPostingGroup@1001 : Code[20];GenProdPostingGroup@1002 : Code[20]);
    VAR
      NewServiceLine@1003 : Record 5902;
      OldServiceLine@1005 : Record 5902;
      ServiceHeader@1006 : Record 5900;
      OldReservationEntry@1009 : Record 337;
      NewReservationEntry@1010 : Record 337;
      VATRateChangeLogEntry@1004 : Record 552;
      RecRef@1000 : RecordRef;
      NewLineNo@1015 : Integer;
      RoundingPrecision@1007 : Decimal;
    BEGIN
      IF NOT GetNextServiceLineNo(ServiceLine,NewLineNo) THEN
        EXIT;

      WITH NewServiceLine DO BEGIN
        INIT;
        NewServiceLine := ServiceLine;
        "Line No." := NewLineNo;
        "Qty. to Invoice" := 0;
        "Qty. to Ship" := 0;
        "Qty. Shipped Not Invoiced" := 0;
        "Quantity Shipped" := 0;
        "Quantity Invoiced" := 0;
        "Qty. to Invoice (Base)" := 0;
        "Qty. to Ship (Base)" := 0;
        "Qty. Shipped Not Invd. (Base)" := 0;
        "Qty. Shipped (Base)" := 0;
        "Qty. Invoiced (Base)" := 0;
        "Qty. to Consume" := 0;
        "Quantity Consumed" := 0;
        "Qty. to Consume (Base)" := 0;
        "Qty. Consumed (Base)" := 0;
        IF (GenProdPostingGroup <> '') AND ConvertGenProdPostGrp(VATRateChangeSetup."Update Service Docs.") THEN
          VALIDATE("Gen. Prod. Posting Group",GenProdPostingGroup);
        IF (VATProdPostingGroup <> '') AND ConvertVATProdPostGrp(VATRateChangeSetup."Update Service Docs.") THEN
          VALIDATE("VAT Prod. Posting Group",VATProdPostingGroup);

        VALIDATE(Quantity,ServiceLine."Outstanding Quantity");
        VALIDATE("Qty. to Ship",ServiceLine."Qty. to Ship");
        VALIDATE("Qty. to Consume",ServiceLine."Qty. to Consume");
        IF ABS(ServiceLine."Qty. to Invoice") >
           (ABS(ServiceLine."Quantity Shipped") - ABS(ServiceLine."Quantity Invoiced"))
        THEN
          VALIDATE(
            "Qty. to Invoice",
            ServiceLine."Qty. to Invoice" - (ServiceLine."Quantity Shipped" - ServiceLine."Quantity Invoiced"))
        ELSE
          VALIDATE("Qty. to Invoice",0);
        ServiceHeader.GET("Document Type","Document No.");
        RoundingPrecision := GetRoundingPrecision(ServiceHeader."Currency Code");
        IF ServiceHeader."Prices Including VAT" THEN
          VALIDATE("Unit Price",ROUND(ServiceLine."Unit Price" * (100 + "VAT %") / (100 + ServiceLine."VAT %"),RoundingPrecision))
        ELSE
          VALIDATE("Unit Price",ServiceLine."Unit Price");
        VALIDATE("Line Discount %",ServiceLine."Line Discount %");
        INSERT;
        RecRef.GETTABLE(ServiceLine);
        VATRateChangeLogEntry.INIT;
        VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
        VATRateChangeLogEntry."Table ID" := RecRef.NUMBER;
        VATRateChangeLogEntry.Description := STRSUBSTNO(Text0012,FORMAT(ServiceLine."Line No."));
        VATRateChangeLogEntry.UpdateGroups(
          ServiceLine."Gen. Prod. Posting Group",ServiceLine."Gen. Prod. Posting Group",
          ServiceLine."VAT Prod. Posting Group",ServiceLine."VAT Prod. Posting Group");
        VATRateChangeLogEntry.Converted := TRUE;
        WriteLogEntry(VATRateChangeLogEntry);

        RecRef.GETTABLE(NewServiceLine);
        VATRateChangeLogEntry.INIT;
        VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
        VATRateChangeLogEntry."Table ID" := RecRef.NUMBER;
        VATRateChangeLogEntry.UpdateGroups(
          ServiceLine."Gen. Prod. Posting Group","Gen. Prod. Posting Group",
          ServiceLine."VAT Prod. Posting Group","VAT Prod. Posting Group");
        VATRateChangeLogEntry.Description := STRSUBSTNO(Text0013,FORMAT("Line No."),FORMAT(ServiceLine."Line No."));
        VATRateChangeLogEntry.Converted := TRUE;
        WriteLogEntry(VATRateChangeLogEntry);
      END;

      ServiceLine.CALCFIELDS("Reserved Quantity");
      IF ServiceLine."Reserved Quantity" <> 0 THEN BEGIN
        OldReservationEntry.RESET;
        OldReservationEntry.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
        OldReservationEntry.SETRANGE("Source ID",ServiceLine."Document No.");
        OldReservationEntry.SETRANGE("Source Ref. No.",ServiceLine."Line No.");
        OldReservationEntry.SETRANGE("Source Type",DATABASE::"Service Line");
        OldReservationEntry.SETRANGE("Source Subtype",ServiceLine."Document Type");
        OldReservationEntry.SETRANGE("Reservation Status",OldReservationEntry."Reservation Status"::Reservation);
        IF OldReservationEntry.FINDSET THEN
          REPEAT
            NewReservationEntry := OldReservationEntry;
            NewReservationEntry."Source Ref. No." := NewLineNo;
            NewReservationEntry.MODIFY;
          UNTIL OldReservationEntry.NEXT = 0;
      END;

      OldReservationEntry.RESET;
      OldReservationEntry.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
      OldReservationEntry.SETRANGE("Source ID",ServiceLine."Document No.");
      OldReservationEntry.SETRANGE("Source Ref. No.",ServiceLine."Line No.");
      OldReservationEntry.SETRANGE("Source Type",DATABASE::"Service Line");
      OldReservationEntry.SETRANGE("Source Subtype",ServiceLine."Document Type");
      OldReservationEntry.SETRANGE("Reservation Status",OldReservationEntry."Reservation Status"::Surplus);
      IF OldReservationEntry.FIND('-') THEN
        REPEAT
          NewReservationEntry := OldReservationEntry;
          NewReservationEntry."Source Ref. No." := NewLineNo;
          NewReservationEntry.MODIFY;
        UNTIL OldReservationEntry.NEXT = 0;

      OldServiceLine.GET(ServiceLine."Document Type",ServiceLine."Document No.",ServiceLine."Line No.");
      OldServiceLine.VALIDATE(Quantity,ServiceLine."Quantity Shipped");
      OldServiceLine.VALIDATE("Unit Price",ServiceLine."Unit Price");
      OldServiceLine.VALIDATE("Line Discount %",ServiceLine."Line Discount %");
      OldServiceLine.VALIDATE("Qty. to Ship",0);
      OldServiceLine.VALIDATE("Qty. to Consume",0);
      IF ABS(OldServiceLine."Qty. to Invoice") >
         (ABS(OldServiceLine."Quantity Shipped") - ABS(OldServiceLine."Quantity Consumed") - ABS(ServiceLine."Quantity Invoiced"))
      THEN
        OldServiceLine.VALIDATE(
          "Qty. to Invoice",OldServiceLine."Qty. to Invoice" - ServiceLine."Quantity Shipped" - OldServiceLine."Quantity Consumed")
      ELSE
        OldServiceLine.VALIDATE("Qty. to Invoice",OldServiceLine."Qty. to Invoice");
      OldServiceLine.MODIFY;
    END;

    [External]
    PROCEDURE GetNextServiceLineNo@31(ServiceLine@1000 : Record 5902;VAR NextLineNo@1001 : Integer) : Boolean;
    VAR
      ServiceLine2@1002 : Record 5902;
    BEGIN
      ServiceLine2.RESET;
      ServiceLine2.SETRANGE("Document Type",ServiceLine."Document Type");
      ServiceLine2.SETRANGE("Document No.",ServiceLine."Document No.");
      ServiceLine2 := ServiceLine;
      IF ServiceLine2.FIND('>') THEN
        NextLineNo := ServiceLine."Line No." + (ServiceLine2."Line No." - ServiceLine."Line No.") DIV 2;
      IF (NextLineNo = ServiceLine."Line No.") OR (NextLineNo = 0)THEN BEGIN
        ServiceLine2.FINDLAST;
        NextLineNo := ServiceLine2."Line No." + 10000;
      END;
      EXIT(NextLineNo <> ServiceLine."Line No.");
    END;

    LOCAL PROCEDURE GetNextItemChrgAssSaleLineNo@51(ItemChargeAssignmentSales@1002 : Record 5809) : Integer;
    VAR
      ItemChargeAssignmentSales2@1000 : Record 5809;
      ExitValue@1001 : Integer;
    BEGIN
      ExitValue := 10000;
      ItemChargeAssignmentSales2.RESET;
      ItemChargeAssignmentSales2.SETCURRENTKEY("Document Type","Document No.","Document Line No.");
      ItemChargeAssignmentSales2.SETRANGE("Document Type",ItemChargeAssignmentSales."Document Type");
      ItemChargeAssignmentSales2.SETRANGE("Document No.",ItemChargeAssignmentSales."Document No.");
      ItemChargeAssignmentSales2.SETRANGE("Document Line No.",ItemChargeAssignmentSales."Document Line No.");
      IF ItemChargeAssignmentSales2.FINDLAST THEN
        ExitValue := ItemChargeAssignmentSales2."Line No." + 10000;
      EXIT(ExitValue);
    END;

    LOCAL PROCEDURE GetNextItemChrgAssPurchLineNo@50(ItemChargeAssignmentPurch@1002 : Record 5805) : Integer;
    VAR
      ItemChargeAssignmentPurch2@1000 : Record 5805;
      ExitValue@1001 : Integer;
    BEGIN
      ExitValue := 10000;
      ItemChargeAssignmentPurch2.RESET;
      ItemChargeAssignmentPurch2.SETCURRENTKEY("Document Type","Document No.","Document Line No.");
      ItemChargeAssignmentPurch2.SETRANGE("Document Type",ItemChargeAssignmentPurch."Document Type");
      ItemChargeAssignmentPurch2.SETRANGE("Document No.",ItemChargeAssignmentPurch."Document No.");
      ItemChargeAssignmentPurch2.SETRANGE("Document Line No.",ItemChargeAssignmentPurch."Document Line No.");
      IF ItemChargeAssignmentPurch2.FINDLAST THEN
        ExitValue := ItemChargeAssignmentPurch2."Line No." + 10000;
      EXIT(ExitValue);
    END;

    LOCAL PROCEDURE AreTablesSelected@15() : Boolean;
    BEGIN
      WITH VATRateChangeSetup DO BEGIN
        IF "Update Gen. Prod. Post. Groups" <> "Update Gen. Prod. Post. Groups"::No THEN
          EXIT(TRUE);
        IF "Update G/L Accounts" <> "Update G/L Accounts"::No THEN
          EXIT(TRUE);
        IF "Update Items" <> "Update Items"::No THEN
          EXIT(TRUE);
        IF "Update Item Templates" <> "Update Item Templates"::No THEN
          EXIT(TRUE);
        IF "Update Item Charges" <> "Update Item Charges"::No THEN
          EXIT(TRUE);
        IF "Update Resources" <> "Update Resources"::No THEN
          EXIT(TRUE);
        IF "Update Gen. Journal Lines" <> "Update Gen. Journal Lines"::No THEN
          EXIT(TRUE);
        IF "Update Gen. Journal Allocation" <> "Update Gen. Journal Allocation"::No THEN
          EXIT(TRUE);
        IF "Update Std. Gen. Jnl. Lines" <> "Update Std. Gen. Jnl. Lines"::No THEN
          EXIT(TRUE);
        IF "Update Res. Journal Lines" <> "Update Res. Journal Lines"::No THEN
          EXIT(TRUE);
        IF "Update Job Journal Lines" <> "Update Job Journal Lines"::No THEN
          EXIT(TRUE);
        IF "Update Requisition Lines" <> "Update Requisition Lines"::No THEN
          EXIT(TRUE);
        IF "Update Std. Item Jnl. Lines" <> "Update Std. Item Jnl. Lines"::No THEN
          EXIT(TRUE);
        IF "Update Service Docs." <> "Update Service Docs."::No THEN
          EXIT(TRUE);
        IF "Update Serv. Price Adj. Detail" <> "Update Serv. Price Adj. Detail"::No THEN
          EXIT(TRUE);
        IF "Update Sales Documents" <> "Update Sales Documents"::No THEN
          EXIT(TRUE);
        IF "Update Purchase Documents" <> "Update Purchase Documents"::No THEN
          EXIT(TRUE);
        IF "Update Production Orders" <> "Update Production Orders"::No THEN
          EXIT(TRUE);
        IF "Update Work Centers" <> "Update Work Centers"::No THEN
          EXIT(TRUE);
        IF "Update Machine Centers" <> "Update Machine Centers"::No THEN
          EXIT(TRUE);
        IF "Update Reminders" <> "Update Reminders"::No THEN
          EXIT(TRUE);
        IF "Update Finance Charge Memos" <> "Update Finance Charge Memos"::No THEN
          EXIT(TRUE);
      END;
      EXIT(FALSE)
    END;

    LOCAL PROCEDURE IncludeLine@25(Type@1000 : ' ,G/L Account,Item,Resource';No@1001 : Code[20]) : Boolean;
    BEGIN
      CASE Type OF
        Type::"G/L Account":
          EXIT(IncludeGLAccount(No));
        Type::Item:
          EXIT(IncludeItem(No));
        Type::Resource:
          EXIT(IncludeRes(No));
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE IncludeGLAccount@26(No@1000 : Code[20]) : Boolean;
    VAR
      GLAccount@1001 : Record 15;
    BEGIN
      IF VATRateChangeSetup."Account Filter" = '' THEN
        EXIT(TRUE);
      GLAccount."No." := No;
      GLAccount.SETFILTER("No.",VATRateChangeSetup."Account Filter");
      EXIT(GLAccount.FIND);
    END;

    LOCAL PROCEDURE IncludeItem@28(No@1000 : Code[20]) : Boolean;
    VAR
      Item@1001 : Record 27;
    BEGIN
      IF VATRateChangeSetup."Item Filter" = '' THEN
        EXIT(TRUE);
      Item."No." := No;
      Item.SETFILTER("No.",VATRateChangeSetup."Item Filter");
      EXIT(Item.FIND);
    END;

    LOCAL PROCEDURE IncludeRes@29(No@1000 : Code[20]) : Boolean;
    VAR
      Res@1001 : Record 156;
    BEGIN
      IF VATRateChangeSetup."Resource Filter" = '' THEN
        EXIT(TRUE);
      Res."No." := No;
      Res.SETFILTER("No.",VATRateChangeSetup."Resource Filter");
      EXIT(Res.FIND);
    END;

    LOCAL PROCEDURE IncludeServiceLine@30(Type@1000 : ' ,Item,Resource,Cost,G/L Account';No@1001 : Code[20]) : Boolean;
    BEGIN
      CASE Type OF
        Type::"G/L Account":
          EXIT(IncludeGLAccount(No));
        Type::Item:
          EXIT(IncludeItem(No));
        Type::Resource:
          EXIT(IncludeRes(No));
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE InitVATRateChangeLogEntry@34(VAR VATRateChangeLogEntry@1001 : Record 552;RecRef@1002 : RecordRef;OutstandingQuantity@1003 : Decimal;LineNo@1004 : Integer);
    BEGIN
      VATRateChangeLogEntry.INIT;
      VATRateChangeLogEntry."Record ID" := RecRef.RECORDID;
      VATRateChangeLogEntry."Table ID" := RecRef.NUMBER;
      IF (OutstandingQuantity = 0) AND VATRateChangeSetup."Perform Conversion" THEN
        VATRateChangeLogEntry.Description := Text0007
      ELSE BEGIN
        VATRateChangeLogEntry.Description :=
          STRSUBSTNO(Text0009,VATRateChangeSetup.FIELDCAPTION("Perform Conversion"));
        IF OutstandingQuantity <> 0 THEN
          VATRateChangeLogEntry.Description := STRSUBSTNO(Text0017,LineNo)
      END;
    END;

    BEGIN
    END.
  }
}

