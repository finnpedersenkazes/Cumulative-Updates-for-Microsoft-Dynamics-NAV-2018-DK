OBJECT Codeunit 378 Transfer Extended Text
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Der er ikke plads til at inds�tte udvidet tekst.;ENU=There is not enough space to insert extended text lines.';
      GLAcc@1001 : Record 15;
      Item@1002 : Record 27;
      Res@1003 : Record 156;
      TmpExtTextLine@1004 : TEMPORARY Record 280;
      NextLineNo@1005 : Integer;
      LineSpacing@1006 : Integer;
      MakeUpdateRequired@1007 : Boolean;
      AutoText@1008 : Boolean;

    [External]
    PROCEDURE SalesCheckIfAnyExtText@1(VAR SalesLine@1000 : Record 37;Unconditionally@1001 : Boolean) : Boolean;
    VAR
      SalesHeader@1002 : Record 36;
      ExtTextHeader@1003 : Record 279;
    BEGIN
      MakeUpdateRequired := FALSE;
      IF IsDeleteAttachedLines(SalesLine."Line No.",SalesLine."No.",SalesLine."Attached to Line No.") THEN
        MakeUpdateRequired := DeleteSalesLines(SalesLine);

      AutoText := FALSE;

      IF Unconditionally THEN
        AutoText := TRUE
      ELSE
        CASE SalesLine.Type OF
          SalesLine.Type::" ":
            AutoText := TRUE;
          SalesLine.Type::"G/L Account":
            BEGIN
              IF GLAcc.GET(SalesLine."No.") THEN
                AutoText := GLAcc."Automatic Ext. Texts";
            END;
          SalesLine.Type::Item:
            BEGIN
              IF Item.GET(SalesLine."No.") THEN
                AutoText := Item."Automatic Ext. Texts";
            END;
          SalesLine.Type::Resource:
            BEGIN
              IF Res.GET(SalesLine."No.") THEN
                AutoText := Res."Automatic Ext. Texts";
            END;
        END;

      IF AutoText THEN BEGIN
        SalesLine.TESTFIELD("Document No.");
        SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.");
        ExtTextHeader.SETRANGE("Table Name",SalesLine.Type);
        ExtTextHeader.SETRANGE("No.",SalesLine."No.");
        CASE SalesLine."Document Type" OF
          SalesLine."Document Type"::Quote:
            ExtTextHeader.SETRANGE("Sales Quote",TRUE);
          SalesLine."Document Type"::"Blanket Order":
            ExtTextHeader.SETRANGE("Sales Blanket Order",TRUE);
          SalesLine."Document Type"::Order:
            ExtTextHeader.SETRANGE("Sales Order",TRUE);
          SalesLine."Document Type"::Invoice:
            ExtTextHeader.SETRANGE("Sales Invoice",TRUE);
          SalesLine."Document Type"::"Return Order":
            ExtTextHeader.SETRANGE("Sales Return Order",TRUE);
          SalesLine."Document Type"::"Credit Memo":
            ExtTextHeader.SETRANGE("Sales Credit Memo",TRUE);
        END;
        EXIT(ReadLines(ExtTextHeader,SalesHeader."Document Date",SalesHeader."Language Code"));
      END;
    END;

    [External]
    PROCEDURE ReminderCheckIfAnyExtText@14(VAR ReminderLine@1000 : Record 296;Unconditionally@1001 : Boolean) : Boolean;
    VAR
      ReminderHeader@1002 : Record 295;
      ExtTextHeader@1003 : Record 279;
    BEGIN
      MakeUpdateRequired := FALSE;
      IF IsDeleteAttachedLines(ReminderLine."Line No.",ReminderLine."No.",ReminderLine."Attached to Line No.") THEN
        MakeUpdateRequired := DeleteReminderLines(ReminderLine);

      IF Unconditionally THEN
        AutoText := TRUE
      ELSE
        CASE ReminderLine.Type OF
          ReminderLine.Type::" ":
            AutoText := TRUE;
          ReminderLine.Type::"G/L Account":
            IF GLAcc.GET(ReminderLine."No.") THEN
              AutoText := GLAcc."Automatic Ext. Texts";
        END;

      IF AutoText THEN BEGIN
        ReminderLine.TESTFIELD("Reminder No.");
        ReminderHeader.GET(ReminderLine."Reminder No.");
        ExtTextHeader.SETRANGE("Table Name",ReminderLine.Type);
        ExtTextHeader.SETRANGE("No.",ReminderLine."No.");
        ExtTextHeader.SETRANGE(Reminder,TRUE);
        EXIT(ReadLines(ExtTextHeader,ReminderHeader."Document Date",ReminderHeader."Language Code"));
      END;
    END;

    [External]
    PROCEDURE FinChrgMemoCheckIfAnyExtText@15(VAR FinChrgMemoLine@1000 : Record 303;Unconditionally@1001 : Boolean) : Boolean;
    VAR
      FinChrgMemoHeader@1002 : Record 302;
      ExtTextHeader@1003 : Record 279;
    BEGIN
      MakeUpdateRequired := FALSE;
      IF IsDeleteAttachedLines(FinChrgMemoLine."Line No.",FinChrgMemoLine."No.",FinChrgMemoLine."Attached to Line No.") THEN
        MakeUpdateRequired := DeleteFinChrgMemoLines(FinChrgMemoLine);

      IF Unconditionally THEN
        AutoText := TRUE
      ELSE
        CASE FinChrgMemoLine.Type OF
          FinChrgMemoLine.Type::" ":
            AutoText := TRUE;
          FinChrgMemoLine.Type::"G/L Account":
            IF GLAcc.GET(FinChrgMemoLine."No.") THEN
              AutoText := GLAcc."Automatic Ext. Texts";
        END;

      IF AutoText THEN BEGIN
        FinChrgMemoLine.TESTFIELD("Finance Charge Memo No.");
        FinChrgMemoHeader.GET(FinChrgMemoLine."Finance Charge Memo No.");
        ExtTextHeader.SETRANGE("Table Name",FinChrgMemoLine.Type);
        ExtTextHeader.SETRANGE("No.",FinChrgMemoLine."No.");
        ExtTextHeader.SETRANGE("Finance Charge Memo",TRUE);
        EXIT(ReadLines(ExtTextHeader,FinChrgMemoHeader."Document Date",FinChrgMemoHeader."Language Code"));
      END;
    END;

    [External]
    PROCEDURE PurchCheckIfAnyExtText@7(VAR PurchLine@1000 : Record 39;Unconditionally@1001 : Boolean) : Boolean;
    VAR
      PurchHeader@1002 : Record 38;
      ExtTextHeader@1003 : Record 279;
    BEGIN
      MakeUpdateRequired := FALSE;
      IF IsDeleteAttachedLines(PurchLine."Line No.",PurchLine."No.",PurchLine."Attached to Line No.") THEN
        MakeUpdateRequired := DeletePurchLines(PurchLine);

      AutoText := FALSE;

      IF Unconditionally THEN
        AutoText := TRUE
      ELSE
        CASE PurchLine.Type OF
          PurchLine.Type::" ":
            AutoText := TRUE;
          PurchLine.Type::"G/L Account":
            BEGIN
              IF GLAcc.GET(PurchLine."No.") THEN
                AutoText := GLAcc."Automatic Ext. Texts";
            END;
          PurchLine.Type::Item:
            BEGIN
              IF Item.GET(PurchLine."No.") THEN
                AutoText := Item."Automatic Ext. Texts";
            END;
        END;

      IF AutoText THEN BEGIN
        PurchLine.TESTFIELD("Document No.");
        PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.");
        ExtTextHeader.SETRANGE("Table Name",PurchLine.Type);
        ExtTextHeader.SETRANGE("No.",PurchLine."No.");
        CASE PurchLine."Document Type" OF
          PurchLine."Document Type"::Quote:
            ExtTextHeader.SETRANGE("Purchase Quote",TRUE);
          PurchLine."Document Type"::"Blanket Order":
            ExtTextHeader.SETRANGE("Purchase Blanket Order",TRUE);
          PurchLine."Document Type"::Order:
            ExtTextHeader.SETRANGE("Purchase Order",TRUE);
          PurchLine."Document Type"::Invoice:
            ExtTextHeader.SETRANGE("Purchase Invoice",TRUE);
          PurchLine."Document Type"::"Return Order":
            ExtTextHeader.SETRANGE("Purchase Return Order",TRUE);
          PurchLine."Document Type"::"Credit Memo":
            ExtTextHeader.SETRANGE("Purchase Credit Memo",TRUE);
        END;
        EXIT(ReadLines(ExtTextHeader,PurchHeader."Document Date",PurchHeader."Language Code"));
      END;
    END;

    [External]
    PROCEDURE PrepmtGetAnyExtText@8(GLAccNo@1001 : Code[20];TabNo@1000 : Integer;DocumentDate@1006 : Date;LanguageCode@1003 : Code[10];VAR ExtTextLine@1004 : TEMPORARY Record 280);
    VAR
      GLAcc@1002 : Record 15;
      ExtTextHeader@1005 : Record 279;
    BEGIN
      ExtTextLine.DELETEALL;

      GLAcc.GET(GLAccNo);
      IF NOT GLAcc."Automatic Ext. Texts" THEN
        EXIT;

      ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::"G/L Account");
      ExtTextHeader.SETRANGE("No.",GLAccNo);
      CASE TabNo OF
        DATABASE::"Sales Invoice Line":
          ExtTextHeader.SETRANGE("Prepmt. Sales Invoice",TRUE);
        DATABASE::"Sales Cr.Memo Line":
          ExtTextHeader.SETRANGE("Prepmt. Sales Credit Memo",TRUE);
        DATABASE::"Purch. Inv. Line":
          ExtTextHeader.SETRANGE("Prepmt. Purchase Invoice",TRUE);
        DATABASE::"Purch. Cr. Memo Line":
          ExtTextHeader.SETRANGE("Prepmt. Purchase Credit Memo",TRUE);
      END;
      IF ReadLines(ExtTextHeader,DocumentDate,LanguageCode) THEN BEGIN
        TmpExtTextLine.FIND('-');
        REPEAT
          ExtTextLine := TmpExtTextLine;
          ExtTextLine.INSERT;
        UNTIL TmpExtTextLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE InsertSalesExtText@2(VAR SalesLine@1000 : Record 37);
    VAR
      ToSalesLine@1001 : Record 37;
    BEGIN
      ToSalesLine.RESET;
      ToSalesLine.SETRANGE("Document Type",SalesLine."Document Type");
      ToSalesLine.SETRANGE("Document No.",SalesLine."Document No.");
      ToSalesLine := SalesLine;
      IF ToSalesLine.FIND('>') THEN BEGIN
        LineSpacing :=
          (ToSalesLine."Line No." - SalesLine."Line No.") DIV
          (1 + TmpExtTextLine.COUNT);
        IF LineSpacing = 0 THEN
          ERROR(Text000);
      END ELSE
        LineSpacing := 10000;

      NextLineNo := SalesLine."Line No." + LineSpacing;

      TmpExtTextLine.RESET;
      IF TmpExtTextLine.FIND('-') THEN BEGIN
        REPEAT
          ToSalesLine.INIT;
          ToSalesLine."Document Type" := SalesLine."Document Type";
          ToSalesLine."Document No." := SalesLine."Document No.";
          ToSalesLine."Line No." := NextLineNo;
          NextLineNo := NextLineNo + LineSpacing;
          ToSalesLine.Description := TmpExtTextLine.Text;
          ToSalesLine."Attached to Line No." := SalesLine."Line No.";
          ToSalesLine.INSERT;
        UNTIL TmpExtTextLine.NEXT = 0;
        MakeUpdateRequired := TRUE;
      END;
      TmpExtTextLine.DELETEALL;
    END;

    [External]
    PROCEDURE InsertReminderExtText@13(VAR ReminderLine@1000 : Record 296);
    VAR
      ToReminderLine@1001 : Record 296;
    BEGIN
      ToReminderLine.RESET;
      ToReminderLine.SETRANGE("Reminder No.",ReminderLine."Reminder No.");
      ToReminderLine := ReminderLine;
      IF ToReminderLine.FIND('>') THEN BEGIN
        LineSpacing :=
          (ToReminderLine."Line No." - ReminderLine."Line No.") DIV
          (1 + TmpExtTextLine.COUNT);
        IF LineSpacing = 0 THEN
          ERROR(Text000);
      END ELSE
        LineSpacing := 10000;

      NextLineNo := ReminderLine."Line No." + LineSpacing;

      TmpExtTextLine.RESET;
      IF TmpExtTextLine.FIND('-') THEN BEGIN
        REPEAT
          ToReminderLine.INIT;
          ToReminderLine."Reminder No." := ReminderLine."Reminder No.";
          ToReminderLine."Line No." := NextLineNo;
          NextLineNo := NextLineNo + LineSpacing;
          ToReminderLine.Description := TmpExtTextLine.Text;
          ToReminderLine."Attached to Line No." := ReminderLine."Line No.";
          ToReminderLine."Line Type" := ReminderLine."Line Type";
          ToReminderLine.INSERT;
        UNTIL TmpExtTextLine.NEXT = 0;
        MakeUpdateRequired := TRUE;
      END;
      TmpExtTextLine.DELETEALL;
    END;

    [External]
    PROCEDURE InsertFinChrgMemoExtText@16(VAR FinChrgMemoLine@1000 : Record 303);
    VAR
      ToFinChrgMemoLine@1001 : Record 303;
    BEGIN
      ToFinChrgMemoLine.RESET;
      ToFinChrgMemoLine.SETRANGE("Finance Charge Memo No.",FinChrgMemoLine."Finance Charge Memo No.");
      ToFinChrgMemoLine := FinChrgMemoLine;
      IF ToFinChrgMemoLine.FIND('>') THEN BEGIN
        LineSpacing :=
          (ToFinChrgMemoLine."Line No." - FinChrgMemoLine."Line No.") DIV
          (1 + TmpExtTextLine.COUNT);
        IF LineSpacing = 0 THEN
          ERROR(Text000);
      END ELSE
        LineSpacing := 10000;

      NextLineNo := FinChrgMemoLine."Line No." + LineSpacing;

      TmpExtTextLine.RESET;
      IF TmpExtTextLine.FIND('-') THEN BEGIN
        REPEAT
          ToFinChrgMemoLine.INIT;
          ToFinChrgMemoLine."Finance Charge Memo No." := FinChrgMemoLine."Finance Charge Memo No.";
          ToFinChrgMemoLine."Line No." := NextLineNo;
          NextLineNo := NextLineNo + LineSpacing;
          ToFinChrgMemoLine.Description := TmpExtTextLine.Text;
          ToFinChrgMemoLine."Attached to Line No." := FinChrgMemoLine."Line No.";
          ToFinChrgMemoLine.INSERT;
        UNTIL TmpExtTextLine.NEXT = 0;
        MakeUpdateRequired := TRUE;
      END;
      TmpExtTextLine.DELETEALL;
    END;

    [External]
    PROCEDURE InsertPurchExtText@3(VAR PurchLine@1000 : Record 39);
    VAR
      ToPurchLine@1001 : Record 39;
    BEGIN
      ToPurchLine.RESET;
      ToPurchLine.SETRANGE("Document Type",PurchLine."Document Type");
      ToPurchLine.SETRANGE("Document No.",PurchLine."Document No.");
      ToPurchLine := PurchLine;
      IF ToPurchLine.FIND('>') THEN BEGIN
        LineSpacing :=
          (ToPurchLine."Line No." - PurchLine."Line No.") DIV
          (1 + TmpExtTextLine.COUNT);
        IF LineSpacing = 0 THEN
          ERROR(Text000);
      END ELSE
        LineSpacing := 10000;

      NextLineNo := PurchLine."Line No." + LineSpacing;

      TmpExtTextLine.RESET;
      IF TmpExtTextLine.FIND('-') THEN BEGIN
        REPEAT
          ToPurchLine.INIT;
          ToPurchLine."Document Type" := PurchLine."Document Type";
          ToPurchLine."Document No." := PurchLine."Document No.";
          ToPurchLine."Line No." := NextLineNo;
          NextLineNo := NextLineNo + LineSpacing;
          ToPurchLine.Description := TmpExtTextLine.Text;
          ToPurchLine."Attached to Line No." := PurchLine."Line No.";
          ToPurchLine.INSERT;
        UNTIL TmpExtTextLine.NEXT = 0;
        MakeUpdateRequired := TRUE;
      END;
      TmpExtTextLine.DELETEALL;
    END;

    LOCAL PROCEDURE DeleteSalesLines@4(VAR SalesLine@1000 : Record 37) : Boolean;
    VAR
      SalesLine2@1001 : Record 37;
    BEGIN
      SalesLine2.SETRANGE("Document Type",SalesLine."Document Type");
      SalesLine2.SETRANGE("Document No.",SalesLine."Document No.");
      SalesLine2.SETRANGE("Attached to Line No.",SalesLine."Line No.");
      SalesLine2 := SalesLine;
      IF SalesLine2.FIND('>') THEN BEGIN
        REPEAT
          SalesLine2.DELETE(TRUE);
        UNTIL SalesLine2.NEXT = 0;
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE DeleteReminderLines@12(VAR ReminderLine@1000 : Record 296) : Boolean;
    VAR
      ReminderLine2@1001 : Record 296;
    BEGIN
      ReminderLine2.SETRANGE("Reminder No.",ReminderLine."Reminder No.");
      ReminderLine2.SETRANGE("Attached to Line No.",ReminderLine."Line No.");
      ReminderLine2 := ReminderLine;
      IF ReminderLine2.FIND('>') THEN BEGIN
        REPEAT
          ReminderLine2.DELETE;
        UNTIL ReminderLine2.NEXT = 0;
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE DeleteFinChrgMemoLines@17(VAR FinChrgMemoLine@1000 : Record 303) : Boolean;
    VAR
      FinChrgMemoLine2@1001 : Record 303;
    BEGIN
      FinChrgMemoLine2.SETRANGE("Finance Charge Memo No.",FinChrgMemoLine."Finance Charge Memo No.");
      FinChrgMemoLine2.SETRANGE("Attached to Line No.",FinChrgMemoLine."Line No.");
      FinChrgMemoLine2 := FinChrgMemoLine;
      IF FinChrgMemoLine2.FIND('>') THEN BEGIN
        REPEAT
          FinChrgMemoLine2.DELETE;
        UNTIL FinChrgMemoLine2.NEXT = 0;
        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE DeletePurchLines@5(VAR PurchLine@1000 : Record 39) : Boolean;
    VAR
      PurchLine2@1001 : Record 39;
    BEGIN
      PurchLine2.SETRANGE("Document Type",PurchLine."Document Type");
      PurchLine2.SETRANGE("Document No.",PurchLine."Document No.");
      PurchLine2.SETRANGE("Attached to Line No.",PurchLine."Line No.");
      PurchLine2 := PurchLine;
      IF PurchLine2.FIND('>') THEN BEGIN
        REPEAT
          PurchLine2.DELETE(TRUE);
        UNTIL PurchLine2.NEXT = 0;
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE MakeUpdate@6() : Boolean;
    BEGIN
      EXIT(MakeUpdateRequired);
    END;

    LOCAL PROCEDURE ReadLines@10(VAR ExtTextHeader@1000 : Record 279;DocDate@1001 : Date;LanguageCode@1002 : Code[10]) Result : Boolean;
    VAR
      ExtTextLine@1003 : Record 280;
    BEGIN
      ExtTextHeader.SETCURRENTKEY(
        "Table Name","No.","Language Code","All Language Codes","Starting Date","Ending Date");
      ExtTextHeader.SETRANGE("Starting Date",0D,DocDate);
      ExtTextHeader.SETFILTER("Ending Date",'%1..|%2',DocDate,0D);
      IF LanguageCode = '' THEN BEGIN
        ExtTextHeader.SETRANGE("Language Code",'');
        IF NOT ExtTextHeader.FINDSET THEN
          EXIT;
      END ELSE BEGIN
        ExtTextHeader.SETRANGE("Language Code",LanguageCode);
        IF NOT ExtTextHeader.FINDSET THEN BEGIN
          ExtTextHeader.SETRANGE("All Language Codes",TRUE);
          ExtTextHeader.SETRANGE("Language Code",'');
          IF NOT ExtTextHeader.FINDSET THEN
            EXIT;
        END;
      END;
      TmpExtTextLine.DELETEALL;
      REPEAT
        ExtTextLine.SETRANGE("Table Name",ExtTextHeader."Table Name");
        ExtTextLine.SETRANGE("No.",ExtTextHeader."No.");
        ExtTextLine.SETRANGE("Language Code",ExtTextHeader."Language Code");
        ExtTextLine.SETRANGE("Text No.",ExtTextHeader."Text No.");
        IF ExtTextLine.FINDSET THEN BEGIN
          REPEAT
            TmpExtTextLine := ExtTextLine;
            TmpExtTextLine.INSERT;
          UNTIL ExtTextLine.NEXT = 0;
          Result := TRUE;
        END;
      UNTIL ExtTextHeader.NEXT = 0;
    END;

    [External]
    PROCEDURE ServCheckIfAnyExtText@9(VAR ServiceLine@1000 : Record 5902;Unconditionally@1001 : Boolean) : Boolean;
    VAR
      ServHeader@1002 : Record 5900;
      ExtTextHeader@1003 : Record 279;
      ServCost@1004 : Record 5905;
    BEGIN
      MakeUpdateRequired := FALSE;
      IF IsDeleteAttachedLines(ServiceLine."Line No.",ServiceLine."No.",ServiceLine."Attached to Line No.") THEN
        MakeUpdateRequired := DeleteServiceLines(ServiceLine);

      AutoText := FALSE;
      IF Unconditionally THEN
        AutoText := TRUE
      ELSE
        CASE ServiceLine.Type OF
          ServiceLine.Type::" ":
            AutoText := TRUE;
          ServiceLine.Type::Cost:
            BEGIN
              IF ServCost.GET(ServiceLine."No.") THEN
                IF GLAcc.GET(ServCost."Account No.") THEN
                  AutoText := GLAcc."Automatic Ext. Texts";
            END;
          ServiceLine.Type::Item:
            BEGIN
              IF Item.GET(ServiceLine."No.") THEN
                AutoText := Item."Automatic Ext. Texts";
            END;
          ServiceLine.Type::Resource:
            BEGIN
              IF Res.GET(ServiceLine."No.") THEN
                AutoText := Res."Automatic Ext. Texts";
            END;
          ServiceLine.Type::"G/L Account":
            BEGIN
              IF GLAcc.GET(ServiceLine."No.") THEN
                AutoText := GLAcc."Automatic Ext. Texts";
            END;
        END;
      IF AutoText THEN BEGIN
        CASE ServiceLine.Type OF
          ServiceLine.Type::" ":
            BEGIN
              ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::"Standard Text");
              ExtTextHeader.SETRANGE("No.",ServiceLine."No.");
            END;
          ServiceLine.Type::Item:
            BEGIN
              ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::Item);
              ExtTextHeader.SETRANGE("No.",ServiceLine."No.");
            END;
          ServiceLine.Type::Resource:
            BEGIN
              ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::Resource);
              ExtTextHeader.SETRANGE("No.",ServiceLine."No.");
            END;
          ServiceLine.Type::Cost:
            BEGIN
              ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::"G/L Account");
              ServCost.GET(ServiceLine."No.");
              ExtTextHeader.SETRANGE("No.",ServCost."Account No.");
            END;
          ServiceLine.Type::"G/L Account":
            BEGIN
              ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::"G/L Account");
              ExtTextHeader.SETRANGE("No.",ServiceLine."No.");
            END;
        END;

        CASE ServiceLine."Document Type" OF
          ServiceLine."Document Type"::Quote:
            ExtTextHeader.SETRANGE("Service Quote",TRUE);
          ServiceLine."Document Type"::Order:
            ExtTextHeader.SETRANGE("Service Order",TRUE);
          ServiceLine."Document Type"::Invoice:
            ExtTextHeader.SETRANGE("Service Invoice",TRUE);
          ServiceLine."Document Type"::"Credit Memo":
            ExtTextHeader.SETRANGE("Service Credit Memo",TRUE);
        END;

        ServHeader.GET(ServiceLine."Document Type",ServiceLine."Document No.");
        EXIT(ReadLines(ExtTextHeader,ServHeader."Order Date",ServHeader."Language Code"));
      END;
    END;

    LOCAL PROCEDURE DeleteServiceLines@11(VAR ServiceLine@1000 : Record 5902) : Boolean;
    VAR
      ServiceLine2@1001 : Record 5902;
    BEGIN
      ServiceLine2.SETRANGE("Document Type",ServiceLine."Document Type");
      ServiceLine2.SETRANGE("Document No.",ServiceLine."Document No.");
      ServiceLine2.SETRANGE("Attached to Line No.",ServiceLine."Line No.");
      ServiceLine2 := ServiceLine;
      IF ServiceLine2.FIND('>') THEN BEGIN
        REPEAT
          ServiceLine2.DELETE;
        UNTIL ServiceLine2.NEXT = 0;
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE InsertServExtText@18(VAR ServiceLine@1000 : Record 5902);
    VAR
      ToServiceLine@1001 : Record 5902;
    BEGIN
      ToServiceLine.RESET;
      ToServiceLine.SETRANGE("Document Type",ServiceLine."Document Type");
      ToServiceLine.SETRANGE("Document No.",ServiceLine."Document No.");
      ToServiceLine := ServiceLine;
      IF ToServiceLine.FIND('>') THEN BEGIN
        LineSpacing :=
          (ToServiceLine."Line No." - ServiceLine."Line No.") DIV
          (1 + TmpExtTextLine.COUNT);
        IF LineSpacing = 0 THEN
          ERROR(Text000);
      END ELSE
        LineSpacing := 10000;

      NextLineNo := ServiceLine."Line No." + LineSpacing;

      TmpExtTextLine.RESET;
      IF TmpExtTextLine.FIND('-') THEN BEGIN
        REPEAT
          ToServiceLine.INIT;
          ToServiceLine."Document Type" := ServiceLine."Document Type";
          ToServiceLine."Document No." := ServiceLine."Document No.";
          ToServiceLine."Service Item Line No." := ServiceLine."Service Item Line No.";
          ToServiceLine."Line No." := NextLineNo;
          NextLineNo := NextLineNo + LineSpacing;
          ToServiceLine.Description := TmpExtTextLine.Text;
          ToServiceLine."Attached to Line No." := ServiceLine."Line No.";
          ToServiceLine."Service Item No." := ServiceLine."Service Item No.";
          ToServiceLine.INSERT(TRUE);
        UNTIL TmpExtTextLine.NEXT = 0;
        MakeUpdateRequired := TRUE;
      END;
      TmpExtTextLine.DELETEALL;
    END;

    LOCAL PROCEDURE IsDeleteAttachedLines@19(LineNo@1000 : Integer;No@1002 : Code[20];AttachedToLineNo@1001 : Integer) : Boolean;
    BEGIN
      EXIT((LineNo <> 0) AND (AttachedToLineNo = 0) AND (No <> ''));
    END;

    BEGIN
    END.
  }
}

