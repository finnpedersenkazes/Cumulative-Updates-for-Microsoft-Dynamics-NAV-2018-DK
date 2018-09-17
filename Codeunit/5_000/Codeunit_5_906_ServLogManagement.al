OBJECT Codeunit 5906 ServLogManagement
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Ordren blev oprettet;ENU=Order created';
      Text001@1001 : TextConst 'DAN=Status blev �ndret;ENU=Status changed';
      Text002@1002 : TextConst 'DAN=Debitor blev �ndret;ENU=Customer changed';
      Text003@1003 : TextConst 'DAN=Ressourcen blev allokeret;ENU=Resource allocated';
      Text004@1004 : TextConst 'DAN=Allokeringen blev annulleret;ENU=Allocation canceled';
      Text005@1005 : TextConst 'DAN=Leverancen blev oprettet;ENU=Shipment created';
      Text006@1006 : TextConst 'DAN=Udl�nt udl�nsvare;ENU=Loaner lent';
      Text007@1007 : TextConst 'DAN=Udl�nsvare modtaget;ENU=Loaner received';
      Text008@1008 : TextConst 'DAN=Ordren blev faktureret;ENU=Order invoiced';
      Text009@1009 : TextConst 'DAN=Ordren blev slettet;ENU=Order deleted';
      Text010@1010 : TextConst 'DAN=Kontraktnr. blev �ndret;ENU=Contract no. changed';
      Text011@1011 : TextConst 'DAN=Tilbuddet blev accepteret;ENU=Quote accepted';
      Text012@1012 : TextConst 'DAN=Tilbuddet blev oprettet;ENU=Quote created';
      Text013@1013 : TextConst 'DAN=Reparationsstatus blev �ndret;ENU=Repair status changed';
      UnknownEventTxt@1014 : TextConst 'DAN=Ukendt h�ndelse;ENU=Unknown event';
      Text015@1015 : TextConst 'DAN=Oprettet;ENU=Created';
      Text016@1016 : TextConst 'DAN=Automatisk oprettet;ENU=Automatically created';
      Text017@1017 : TextConst 'DAN=Tilf�jet til kontrakt;ENU=Added to contract';
      Text018@1018 : TextConst 'DAN=Fjernet fra kontrakt;ENU=Removed from contract';
      Text019@1019 : TextConst 'DAN=Tilf�jet til serviceordre;ENU=Added to service order';
      Text020@1020 : TextConst 'DAN=Ordrestatus blev �ndret;ENU=Order status changed';
      Text021@1021 : TextConst 'DAN=Fjernet fra serviceordre;ENU=Removed from service order';
      Text022@1022 : TextConst 'DAN=Serviceart.komp. blev fjernet;ENU=Service item component removed';
      Text023@1023 : TextConst 'DAN=Serviceartiklen blev fjernet;ENU=Service item replaced';
      Text024@1024 : TextConst 'DAN=Leveringsadressen blev �ndret;ENU=Ship-to address changed';
      Text025@1025 : TextConst 'DAN=Varenummeret blev �ndret;ENU=Item no. changed';
      Text026@1026 : TextConst 'DAN=Serienummeret blev �ndret;ENU=Serial no. changed';
      Text027@1027 : TextConst 'DAN=Tilf�jet til servicetilbuddet;ENU=Added to service quote';
      Text028@1028 : TextConst 'DAN=Serviceartikelkomp. erstattet;ENU=Service item comp. replaced';
      Text029@1029 : TextConst 'DAN=Leveringsadr.kode er �ndret;ENU=Ship-to Code changed';
      Text030@1030 : TextConst 'DAN=Genallokering n�dvendig;ENU=Reallocation needed';
      Text031@1031 : TextConst 'DAN=Fjernet fra servicetilbud;ENU=Removed from service quote';
      Text032@1032 : TextConst 'DAN=�ndret nummer;ENU=No. changed';
      Text033@1033 : TextConst 'DAN=�ndret svardato;ENU=Response Date changed';
      Text034@1034 : TextConst 'DAN=�ndret svartid;ENU=Response Time changed';
      Text035@1036 : TextConst 'DAN=Fakturaen blev oprettet;ENU=Invoice created';
      Text036@1037 : TextConst 'DAN=Kreditnotaen blev oprettet;ENU=Credit memo created';
      Text037@1035 : TextConst 'DAN=Kreditnotaen blev bogf�rt;ENU=Credit memo posted';
      Text038@1038 : TextConst 'DAN=Fakturaen blev bogf�rt;ENU=Invoice posted';
      Text039@1039 : TextConst 'DAN=Fakturaen blev slettet;ENU=Invoice deleted';
      Text040@1040 : TextConst 'DAN=Kreditnotaen blev slettet;ENU=Credit memo deleted';

    [External]
    PROCEDURE ServOrderEventDescription@19(EventNo@1000 : Integer) : Text[50];
    VAR
      Description@1002 : Text[50];
      Handled@1001 : Boolean;
    BEGIN
      CASE EventNo OF
        1:
          EXIT(Text000);
        2:
          EXIT(Text001);
        3:
          EXIT(Text002);
        4:
          EXIT(Text003);
        5:
          EXIT(Text004);
        6:
          EXIT(Text005);
        7:
          EXIT(Text006);
        8:
          EXIT(Text007);
        9:
          EXIT(Text008);
        10:
          EXIT(Text009);
        11:
          EXIT(Text010);
        12:
          EXIT(Text011);
        13:
          EXIT(Text012);
        14:
          EXIT(Text013);
        15:
          EXIT(Text029);
        16:
          EXIT(Text037);
        17:
          EXIT(Text030);
        18:
          EXIT(Text033);
        19:
          EXIT(Text034);
        20:
          EXIT(Text035);
        21:
          EXIT(Text036);
        22:
          EXIT(Text038);
        23:
          EXIT(Text039);
        24:
          EXIT(Text040);
        ELSE BEGIN
          OnServOrderEventDescription(EventNo,Description,Handled);
          IF Handled THEN
            EXIT(Description);
          EXIT(UnknownEventTxt);
        END;
      END;
    END;

    [External]
    PROCEDURE ServItemEventDescription@25(EventNo@1000 : Integer) : Text[50];
    VAR
      Description@1001 : Text[50];
      Handled@1002 : Boolean;
    BEGIN
      OnBeforeServItemEventDescription(EventNo);

      CASE EventNo OF
        1:
          EXIT(Text015);
        2:
          EXIT(Text016);
        3:
          EXIT(Text017);
        4:
          EXIT(Text018);
        5:
          EXIT(Text019);
        6:
          EXIT(Text020);
        7:
          EXIT(Text021);
        8:
          EXIT(Text001);
        9:
          EXIT(Text022);
        10:
          EXIT(Text023);
        11:
          EXIT(Text002);
        12:
          EXIT(Text024);
        13:
          EXIT(Text025);
        14:
          EXIT(Text026);
        15:
          EXIT(Text027);
        16:
          EXIT(Text028);
        17:
          EXIT(Text031);
        18:
          EXIT(Text032);
        ELSE BEGIN
          OnServItemEventDescription(EventNo,Description,Handled);
          IF Handled THEN
            EXIT(Description);
          EXIT(UnknownEventTxt);
        END;
      END;
    END;

    [External]
    PROCEDURE ServItemCreated@2(ServItem@1000 : Record 5940);
    VAR
      ServItemLog@1001 : Record 5942;
    BEGIN
      IF ServItem."No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServItem."No.";
      ServItemLog."Event No." := 1;
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemAutoCreated@7(ServItem@1000 : Record 5940);
    VAR
      ServItemLog@1001 : Record 5942;
    BEGIN
      IF ServItem."No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServItem."No.";
      ServItemLog.After := ServItem."Description 2";
      ServItemLog."Event No." := 2;
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemAddToContract@1(ServContrLine@1000 : Record 5964);
    VAR
      ServItemLog@1001 : Record 5942;
    BEGIN
      IF ServContrLine."Service Item No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServContrLine."Service Item No.";
      ServItemLog."Event No." := 3;
      ServItemLog."Document Type" := ServItemLog."Document Type"::Contract;
      ServItemLog."Document No." := ServContrLine."Contract No.";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemRemovedFromContract@3(ServContrLine@1000 : Record 5964);
    VAR
      ServItemLog@1001 : Record 5942;
    BEGIN
      IF ServContrLine."Service Item No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServContrLine."Service Item No.";
      ServItemLog."Event No." := 4;
      ServItemLog."Document Type" := ServItemLog."Document Type"::Contract;
      ServItemLog."Document No." := ServContrLine."Contract No.";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemToServOrder@4(ServItemLine@1000 : Record 5901);
    VAR
      ServItemLog@1001 : Record 5942;
    BEGIN
      IF ServItemLine."Service Item No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServItemLine."Service Item No.";
      IF ServItemLine."Document Type" = ServItemLine."Document Type"::Order THEN
        ServItemLog."Event No." := 5
      ELSE
        ServItemLog."Event No." := 15;
      ServItemLog."Document Type" := ServItemLine."Document Type" + 1;
      ServItemLog."Document No." := ServItemLine."Document No.";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemOffServOrder@5(ServItemLine@1000 : Record 5901);
    VAR
      ServItemLog@1001 : Record 5942;
    BEGIN
      IF ServItemLine."Service Item No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServItemLine."Service Item No.";
      IF ServItemLine."Document Type" = ServItemLine."Document Type"::Order THEN
        ServItemLog."Event No." := 7
      ELSE
        ServItemLog."Event No." := 17;
      ServItemLog."Document Type" := ServItemLine."Document Type" + 1;
      ServItemLog."Document No." := ServItemLine."Document No.";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemComponentAdded@8(Component@1000 : Record 5941);
    VAR
      ServItemLog@1001 : Record 5942;
    BEGIN
      IF Component."Parent Service Item No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := Component."Parent Service Item No.";
      ServItemLog.After := FORMAT(Component.Type) + ' ' + Component."No.";
      ServItemLog."Event No." := 16;
      ServItemLog."Document Type" := ServItemLog."Document Type"::Order;
      ServItemLog."Document No." := Component."Service Order No.";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemComponentRemoved@6(Component@1000 : Record 5941);
    VAR
      ServItemLog@1001 : Record 5942;
    BEGIN
      IF Component."Parent Service Item No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := Component."Parent Service Item No.";
      ServItemLog.Before := FORMAT(Component.Type) + ' ' + Component."No.";
      ServItemLog."Event No." := 9;
      ServItemLog."Document Type" := ServItemLog."Document Type"::Order;
      ServItemLog."Document No." := Component."Service Order No.";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemCustChange@9(ServItem@1000 : Record 5940;OldServItem@1001 : Record 5940);
    VAR
      ServItemLog@1002 : Record 5942;
    BEGIN
      IF ServItem."No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServItem."No.";
      ServItemLog."Event No." := 11;
      ServItemLog.Before := OldServItem."Customer No.";
      ServItemLog.After := ServItem."Customer No.";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemShipToCodeChange@16(ServItem@1000 : Record 5940;OldServItem@1001 : Record 5940);
    VAR
      ServItemLog@1002 : Record 5942;
    BEGIN
      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServItem."No.";
      ServItemLog."Event No." := 12;
      ServItemLog.Before := OldServItem."Ship-to Code";
      ServItemLog.After := ServItem."Ship-to Code";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemStatusChange@24(ServItem@1000 : Record 5940;OldServItem@1001 : Record 5940);
    VAR
      ServItemLog@1002 : Record 5942;
    BEGIN
      IF ServItem."No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServItem."No.";
      ServItemLog."Event No." := 8;
      ServItemLog.Before := FORMAT(OldServItem.Status);
      ServItemLog.After := FORMAT(ServItem.Status);
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemSerialNoChange@13(ServItem@1000 : Record 5940;OldServItem@1001 : Record 5940);
    VAR
      ServItemLog@1002 : Record 5942;
    BEGIN
      IF ServItem."No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServItem."No.";
      ServItemLog."Event No." := 14;
      ServItemLog.After := ServItem."Serial No.";
      ServItemLog.Before := OldServItem."Serial No.";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemNoChange@32(ServItem@1000 : Record 5940;OldServItem@1001 : Record 5940);
    VAR
      ServItemLog@1002 : Record 5942;
    BEGIN
      IF (ServItem."No." = '') OR (OldServItem."No." = '') THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := OldServItem."No.";
      ServItemLog."Event No." := 18;
      ServItemLog.After := ServItem."No.";
      ServItemLog.Before := OldServItem."No.";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemItemNoChange@18(ServItem@1000 : Record 5940;OldServItem@1001 : Record 5940);
    VAR
      ServItemLog@1002 : Record 5942;
    BEGIN
      IF (ServItem."Item No." = '') AND (OldServItem."Item No." = '') THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServItem."No.";
      ServItemLog."Event No." := 13;
      ServItemLog.After := ServItem."Item No.";
      ServItemLog.Before := OldServItem."Item No.";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemReplaced@30(ServItem@1000 : Record 5940;NewServItem@1001 : Record 5940);
    VAR
      ServItemLog@1002 : Record 5942;
    BEGIN
      IF ServItem."No." = '' THEN
        EXIT;

      ServItemLog.INIT;
      ServItemLog."Service Item No." := ServItem."No.";
      ServItemLog."Event No." := 10;
      ServItemLog.After := NewServItem."No.";
      ServItemLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemDeleted@33(ServItemNo@1000 : Code[20]);
    VAR
      ServItemLog@1001 : Record 5942;
    BEGIN
      ServItemLog.SETRANGE("Service Item No.",ServItemNo);
      ServItemLog.DELETEALL;
    END;

    [External]
    PROCEDURE ServHeaderStatusChange@10(ServHeader@1000 : Record 5900;OldServHeader@1001 : Record 5900);
    VAR
      ServOrderLog@1002 : Record 5912;
    BEGIN
      IF (ServHeader."No." = '') OR (OldServHeader."No." = '') THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServHeader."Document Type";
      ServOrderLog."Document No." := ServHeader."No.";
      ServOrderLog."Event No." := 2;
      ServOrderLog.After := FORMAT(ServHeader.Status);
      ServOrderLog.Before := FORMAT(OldServHeader.Status);
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServHeaderCustomerChange@11(ServHeader@1000 : Record 5900;OldServHeader@1001 : Record 5900);
    VAR
      ServOrderLog@1002 : Record 5912;
    BEGIN
      IF (ServHeader."No." = '') OR (OldServHeader."Customer No." = '') OR
         (ServHeader."Customer No." = OldServHeader."Customer No.")
      THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServHeader."Document Type";
      ServOrderLog."Document No." := ServHeader."No.";
      ServOrderLog."Event No." := 3;
      ServOrderLog.After := ServHeader."Customer No.";
      ServOrderLog.Before := OldServHeader."Customer No.";
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServHeaderShiptoChange@22(ServHeader@1000 : Record 5900;OldServHeader@1001 : Record 5900);
    VAR
      ServOrderLog@1002 : Record 5912;
    BEGIN
      IF (ServHeader."No." = '') OR (OldServHeader."Customer No." = '') OR
         (ServHeader."Ship-to Code" = OldServHeader."Ship-to Code")
      THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServHeader."Document Type";
      ServOrderLog."Document No." := ServHeader."No.";
      ServOrderLog."Event No." := 15;
      ServOrderLog.After := ServHeader."Ship-to Code";
      ServOrderLog.Before := OldServHeader."Ship-to Code";
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServHeaderAllocation@12(ResourceNo@1000 : Code[20];DocumentType@1001 : Integer;DocumentNo@1004 : Code[20];ServItemLineNo@1002 : Integer);
    VAR
      ServOrderLog@1003 : Record 5912;
    BEGIN
      IF (DocumentNo = '') OR (ResourceNo = '') THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := DocumentType;
      ServOrderLog."Document No." := DocumentNo;
      ServOrderLog."Service Item Line No." := ServItemLineNo;
      ServOrderLog."Event No." := 4;
      ServOrderLog.After := ResourceNo;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServHeaderCancelAllocation@28(ResourceNo@1000 : Code[20];DocumentType@1004 : Integer;DocumentNo@1001 : Code[20];ServItemLineNo@1002 : Integer);
    VAR
      ServOrderLog@1003 : Record 5912;
    BEGIN
      IF (DocumentNo = '') OR (ResourceNo = '') THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := DocumentType;
      ServOrderLog."Document No." := DocumentNo;
      ServOrderLog."Service Item Line No." := ServItemLineNo;
      ServOrderLog."Event No." := 5;
      ServOrderLog.After := ResourceNo;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServHeaderReallocationNeeded@31(ResourceNo@1003 : Code[20];DocumentType@1002 : Integer;DocumentNo@1001 : Code[20];ServItemLineNo@1000 : Integer);
    VAR
      ServOrderLog@1004 : Record 5912;
    BEGIN
      IF (DocumentNo = '') OR (ResourceNo = '') THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := DocumentType;
      ServOrderLog."Document No." := DocumentNo;
      ServOrderLog."Service Item Line No." := ServItemLineNo;
      ServOrderLog."Event No." := 17;
      ServOrderLog.After := ResourceNo;
      ServOrderLog.Before := ResourceNo;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServHeaderCreate@17(ServHeader@1000 : Record 5900);
    VAR
      ServOrderLog@1001 : Record 5912;
    BEGIN
      IF ServHeader."No." = '' THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServHeader."Document Type";
      ServOrderLog."Document No." := ServHeader."No.";
      CASE ServOrderLog."Document Type" OF
        ServOrderLog."Document Type"::Quote:
          ServOrderLog."Event No." := 13;
        ServOrderLog."Document Type"::Invoice:
          ServOrderLog."Event No." := 20;
        ServOrderLog."Document Type"::"Credit Memo":
          ServOrderLog."Event No." := 21;
        ELSE
          ServOrderLog."Event No." := 1
      END;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServOrderShipmentPost@21(ServOrderNo@1002 : Code[20];ShptNo@1000 : Code[20]);
    VAR
      ServOrderLog@1001 : Record 5912;
    BEGIN
      IF (ServOrderNo = '') OR (ShptNo = '') THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServOrderLog."Document Type"::Shipment;
      ServOrderLog."Document No." := ShptNo;
      ServOrderLog.Before := ServOrderNo;
      ServOrderLog."Event No." := 6;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServOrderInvoicePost@23(ServOrderNo@1000 : Code[20];InvoiceNo@1001 : Code[20]);
    VAR
      ServOrderLog@1002 : Record 5912;
    BEGIN
      IF (ServOrderNo = '') OR (InvoiceNo = '') THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServOrderLog."Document Type"::"Posted Invoice";
      ServOrderLog."Document No." := InvoiceNo;
      ServOrderLog.Before := ServOrderNo;
      ServOrderLog."Event No." := 9;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServInvoicePost@45(ServOrderNo@1000 : Code[20];InvoiceNo@1001 : Code[20]);
    VAR
      ServOrderLog@1002 : Record 5912;
    BEGIN
      IF (ServOrderNo = '') OR (InvoiceNo = '') THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServOrderLog."Document Type"::"Posted Invoice";
      ServOrderLog."Document No." := InvoiceNo;
      ServOrderLog.Before := ServOrderNo;
      ServOrderLog."Event No." := 22;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServCrMemoPost@37(ServOrderNo@1000 : Code[20];CrMemoNo@1001 : Code[20]);
    VAR
      ServOrderLog@1002 : Record 5912;
    BEGIN
      IF (ServOrderNo = '') OR (CrMemoNo = '') THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServOrderLog."Document Type"::"Posted Credit Memo";
      ServOrderLog."Document No." := CrMemoNo;
      ServOrderLog."Event No." := 16;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServHeaderManualDelete@27(ServHeader@1000 : Record 5900);
    VAR
      ServOrderLog@1001 : Record 5912;
    BEGIN
      IF ServHeader."No." = '' THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServHeader."Document Type";
      ServOrderLog."Document No." := ServHeader."No.";
      CASE ServOrderLog."Document Type" OF
        ServOrderLog."Document Type"::Invoice:
          ServOrderLog."Event No." := 23;
        ServOrderLog."Document Type"::"Credit Memo":
          ServOrderLog."Event No." := 24;
        ELSE
          ServOrderLog."Event No." := 10
      END;
      ServOrderLog.After := '';

      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServHeaderContractNoChanged@14(ServHeader@1000 : Record 5900;OldServHeader@1001 : Record 5900);
    VAR
      ServOrderLog@1002 : Record 5912;
    BEGIN
      IF (ServHeader."No." = '') OR (ServHeader."Contract No." = OldServHeader."Contract No.") THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServHeader."Document Type";
      ServOrderLog."Document No." := ServHeader."No.";
      ServOrderLog.After := ServHeader."Contract No.";
      ServOrderLog.Before := OldServHeader."Contract No.";
      ServOrderLog."Event No." := 11;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServOrderQuoteChanged@15(ServHeader@1000 : Record 5900;OldServHeader@1001 : Record 5900);
    VAR
      ServOrderLog@1002 : Record 5912;
    BEGIN
      IF ServHeader."No." = '' THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := OldServHeader."Document Type";
      ServOrderLog."Document No." := OldServHeader."No.";
      ServOrderLog.After :=
        COPYSTR(
          FORMAT(ServHeader."Document Type") + ' ' + ServHeader."No.",
          1,MAXSTRLEN(ServOrderLog.After));
      ServOrderLog.Before :=
        COPYSTR(
          FORMAT(OldServHeader."Document Type") + ' ' + OldServHeader."No.",
          1,MAXSTRLEN(ServOrderLog.Before));
      ServOrderLog."Event No." := 12;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServHeaderRepairStatusChange@29(ServItemLine@1000 : Record 5901;OldServItemLine@1001 : Record 5901);
    VAR
      ServOrderLog@1002 : Record 5912;
    BEGIN
      IF (ServItemLine."Document No." = '') OR (ServItemLine."Line No." = 0) THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServItemLine."Document Type";
      ServOrderLog."Document No." := ServItemLine."Document No.";
      ServOrderLog."Service Item Line No." := ServItemLine."Line No.";
      ServOrderLog.After := ServItemLine."Repair Status Code";
      ServOrderLog.Before := OldServItemLine."Repair Status Code";
      ServOrderLog."Event No." := 14;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE LoanerLent@20(LoanerEntry@1000 : Record 5914);
    VAR
      ServOrderLog@1001 : Record 5912;
    BEGIN
      IF LoanerEntry."Loaner No." = '' THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := LoanerEntry."Document Type" - 1;
      ServOrderLog."Document No." := LoanerEntry."Document No.";
      ServOrderLog."Event No." := 7;
      ServOrderLog.After := LoanerEntry."Loaner No.";
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE LoanerReceived@26(LoanerEntry@1000 : Record 5914);
    VAR
      ServOrderLog@1001 : Record 5912;
    BEGIN
      IF LoanerEntry."Loaner No." = '' THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := LoanerEntry."Document Type" - 1;
      ServOrderLog."Document No." := LoanerEntry."Document No.";
      ServOrderLog."Event No." := 8;
      ServOrderLog.After := LoanerEntry."Loaner No.";
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemLineResponseDateChange@35(VAR ServItemLine@1000 : Record 5901;VAR OldServItemLine@1001 : Record 5901);
    VAR
      ServOrderLog@1002 : Record 5912;
    BEGIN
      IF (ServItemLine."Document No." = '') OR (ServItemLine."Line No." = 0) THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServItemLine."Document Type";
      ServOrderLog."Document No." := ServItemLine."Document No.";
      ServOrderLog."Service Item Line No." := ServItemLine."Line No.";
      ServOrderLog.After := FORMAT(ServItemLine."Response Date");
      ServOrderLog.Before := FORMAT(OldServItemLine."Response Date");
      ServOrderLog."Event No." := 18;
      ServOrderLog.INSERT(TRUE);
    END;

    [External]
    PROCEDURE ServItemLineResponseTimeChange@36(VAR ServItemLine@1001 : Record 5901;VAR OldServItemLine@1000 : Record 5901);
    VAR
      ServOrderLog@1002 : Record 5912;
    BEGIN
      IF (ServItemLine."Document No." = '') OR (ServItemLine."Line No." = 0) THEN
        EXIT;

      ServOrderLog.INIT;
      ServOrderLog."Document Type" := ServItemLine."Document Type";
      ServOrderLog."Document No." := ServItemLine."Document No.";
      ServOrderLog."Service Item Line No." := ServItemLine."Line No.";
      ServOrderLog.After := FORMAT(ServItemLine."Response Time");
      ServOrderLog.Before := FORMAT(OldServItemLine."Response Time");
      ServOrderLog."Event No." := 19;
      ServOrderLog.INSERT(TRUE);
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeServItemEventDescription@38(VAR EventNo@1000 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnServItemEventDescription@34(EventNo@1000 : Integer;VAR Description@1001 : Text[50];VAR Handled@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnServOrderEventDescription@41(EventNo@1000 : Integer;VAR Description@1001 : Text[50];VAR Handled@1002 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

