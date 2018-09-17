OBJECT Codeunit 361 MoveEntries
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 17=rm,
                TableData 21=rm,
                TableData 25=rm,
                TableData 32=rm,
                TableData 169=rm,
                TableData 203=rm,
                TableData 271=rm,
                TableData 272=rm,
                TableData 300=rm,
                TableData 5802=rm,
                TableData 5804=rd,
                TableData 5896=rm,
                TableData 5907=rm,
                TableData 5908=rm;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi den har poster i et regnskabs�r, der endnu ikke er afsluttet.;ENU=You cannot delete %1 %2 because it has ledger entries in a fiscal year that has not been closed yet.';
      Text001@1001 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der er en eller flere �bne poster.;ENU=You cannot delete %1 %2 because there are one or more open ledger entries.';
      Text002@1002 : TextConst 'DAN="Der er vareposter, der ikke er regulerede for vare %1. ";ENU="There are item entries that have not been adjusted for item %1. "';
      Text003@1003 : TextConst 'DAN="Hvis varen slettes, ville det betyde, at lagerv�rdien bliver ukorrekt. ";ENU="If you delete this item the inventory valuation will be incorrect. "';
      Text004@1004 : TextConst 'DAN=Brug k�rslen %2, f�r du kan slette varen.;ENU=Use the %2 batch job before deleting the item.';
      Text005@1005 : TextConst 'DAN=Juster kostpris - vareposter;ENU=Adjust Cost - Item Entries';
      Text006@1006 : TextConst 'DAN=%1 %2 kan ikke slettes, da den indeholder finansposter.;ENU=You cannot delete %1 %2 because it has ledger entries.';
      Text007@1007 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der findes udest�ende k�bsordrelinjer.;ENU=You cannot delete %1 %2 because there are outstanding purchase order lines.';
      Text008@1008 : TextConst 'DAN="Der findes vareposter, som ikke er blevet faktureret for varen %1. ";ENU="There are item entries that have not been completely invoiced for item %1. "';
      Text009@1009 : TextConst 'DAN=Fakturer alle vareposter, f�r varen slettes.;ENU=Invoice all item entries before deleting the item.';
      AccountingPeriod@1010 : Record 50;
      GLEntry@1011 : Record 17;
      CustLedgEntry@1012 : Record 21;
      VendLedgEntry@1013 : Record 25;
      BankAccLedgEntry@1014 : Record 271;
      CheckLedgEntry@1015 : Record 272;
      ItemLedgEntry@1016 : Record 32;
      ResLedgEntry@1017 : Record 203;
      JobLedgEntry@1018 : Record 169;
      PurchOrderLine@1019 : Record 39;
      ReminderEntry@1020 : Record 300;
      ValueEntry@1021 : Record 5802;
      AvgCostAdjmt@1022 : Record 5804;
      InvtAdjmtEntryOrder@1031 : Record 5896;
      ServLedgEntry@1023 : Record 5907;
      WarrantyLedgEntry@1024 : Record 5908;
      CannotDeleteGLBugetEntriesErr@1026 : TextConst '@@@="%1 - G/L Account No., %2 - Date, %3 - G/L Budget Name. You cannot delete G/L Account 1000 because it has budget ledger entries\ after 25/01/2018 in G/L Budget Name = Budget_2018.";DAN=You cannot delete G/L account %1 because it contains budget ledger entries after %2 for G/L budget name %3.;ENU=You cannot delete G/L account %1 because it contains budget ledger entries after %2 for G/L budget name %3.';
      Text013@1028 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der findes forudbetalte kontraktposter i %3.;ENU=You cannot delete %1 %2 because prepaid contract entries exist in %3.';
      Text014@1029 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der er �bne, forudbetalte kontraktposter i %3.;ENU=You cannot delete %1 %2, because open prepaid contract entries exist in %3.';
      Text015@1030 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der findes udest�ende k�bsreturvareordrelinjer.;ENU=You cannot delete %1 %2 because there are outstanding purchase return order lines.';
      TimeSheetLinesErr@1033 : TextConst '@@@=You cannot delete job JOB001 because it has open or submitted time sheet lines.;DAN=Du kan ikke slette sag %1, fordi den har �bne eller sendte timeseddellinjer.;ENU=You cannot delete job %1 because it has open or submitted time sheet lines.';
      CannotDeleteBecauseInInvErr@1032 : TextConst '@@@="%1 = the object to be deleted (example: Item, Customer).";DAN=Du kan ikke slette %1, fordi den bruges i nogle fakturaer.;ENU=You cannot delete %1 because it is used in some invoices.';
      GLAccDeleteClosedPeriodsQst@1034 : TextConst 'DAN=Bem�rk, at regnskabslovgivningen kan muligvis kr�ver, at regnskabsdata gemmes i et bestemt antal �r. Er du sikker p�, at du vil slette finanskontoen?;ENU=Note that accounting regulations may require that you save accounting data for a certain number of years. Are you sure you want to delete the G/L account?';
      CannotDeleteGLAccountWithEntriesInOpenFiscalYearErr@1035 : TextConst '@@@=%1 - G/L Account No. You cannot delete G/L Account 1000 because it has ledger entries in a fiscal year that has not been closed yet.;DAN=Du kan ikke slette finanskontoen %1, fordi den har poster i et regnskabs�r, der endnu ikke er afsluttet.;ENU=You cannot delete G/L account %1 because it has ledger entries in a fiscal year that has not been closed yet.';
      CannotDeleteGLAccountWithEntriesAfterDateErr@1036 : TextConst '@@@=%1 - G/L Account No., %2 - Date. You cannot delete G/L Account 1000 because it has ledger entries posted after 01-01-2010.;DAN=Du kan ikke slette finanskontoen %1, da den indeholder poster, der er bogf�rt efter %2.;ENU=You cannot delete G/L account %1 because it has ledger entries posted after %2.';

    [External]
    PROCEDURE MoveGLEntries@1(GLAcc@1000 : Record 15);
    VAR
      GLSetup@1004 : Record 98;
      CalcGLAccWhereUsed@1001 : Codeunit 100;
    BEGIN
      GLSetup.GET;

      CheckGLAccountEntries(GLAcc,GLSetup);

      IF GLSetup."Check G/L Account Usage" THEN
        CalcGLAccWhereUsed.DeleteGLNo(GLAcc."No.");

      GLEntry.RESET;
      GLEntry.SETCURRENTKEY("G/L Account No.");
      GLEntry.SETRANGE("G/L Account No.",GLAcc."No.");
      GLEntry.MODIFYALL("G/L Account No.",'');
    END;

    [External]
    PROCEDURE MoveCustEntries@2(Cust@1000 : Record 18);
    VAR
      IdentityManagement@1001 : Codeunit 9801;
    BEGIN
      CustLedgEntry.RESET;
      CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
      CustLedgEntry.SETRANGE("Customer No.",Cust."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        CustLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT CustLedgEntry.ISEMPTY THEN BEGIN
        IF IdentityManagement.IsInvAppId THEN
          ERROR(
            CannotDeleteBecauseInInvErr,
            Cust.TABLECAPTION);

        ERROR(
          Text000,
          Cust.TABLECAPTION,Cust."No.");
      END;

      CustLedgEntry.RESET;
      IF NOT CustLedgEntry.SETCURRENTKEY("Customer No.",Open) THEN
        CustLedgEntry.SETCURRENTKEY("Customer No.");
      CustLedgEntry.SETRANGE("Customer No.",Cust."No.");
      CustLedgEntry.SETRANGE(Open,TRUE);
      IF NOT CustLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          Cust.TABLECAPTION,Cust."No.");

      ReminderEntry.RESET;
      ReminderEntry.SETCURRENTKEY("Customer No.");
      ReminderEntry.SETRANGE("Customer No.",Cust."No.");
      ReminderEntry.MODIFYALL("Customer No.",'');

      CustLedgEntry.SETRANGE(Open);
      CustLedgEntry.MODIFYALL("Customer No.",'');

      ServLedgEntry.RESET;
      ServLedgEntry.SETRANGE("Customer No.",Cust."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ServLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          Cust.TABLECAPTION,Cust."No.");

      ServLedgEntry.SETRANGE("Posting Date");
      ServLedgEntry.SETRANGE(Open,TRUE);
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          Cust.TABLECAPTION,Cust."No.");

      ServLedgEntry.SETRANGE(Open);
      ServLedgEntry.MODIFYALL("Customer No.",'');

      ServLedgEntry.RESET;
      ServLedgEntry.SETRANGE("Bill-to Customer No.",Cust."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ServLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          Cust.TABLECAPTION,Cust."No.");

      ServLedgEntry.SETRANGE("Posting Date");
      ServLedgEntry.SETRANGE(Open,TRUE);
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          Cust.TABLECAPTION,Cust."No.");

      ServLedgEntry.SETRANGE(Open);
      ServLedgEntry.MODIFYALL("Bill-to Customer No.",'');

      WarrantyLedgEntry.LOCKTABLE;
      WarrantyLedgEntry.SETRANGE("Customer No.",Cust."No.");
      WarrantyLedgEntry.MODIFYALL("Customer No.",'');

      WarrantyLedgEntry.SETRANGE("Customer No.");
      WarrantyLedgEntry.SETRANGE("Bill-to Customer No.",Cust."No.");
      WarrantyLedgEntry.MODIFYALL("Bill-to Customer No.",'');
    END;

    [External]
    PROCEDURE MoveVendorEntries@3(Vend@1000 : Record 23);
    BEGIN
      VendLedgEntry.RESET;
      VendLedgEntry.SETCURRENTKEY("Vendor No.","Posting Date");
      VendLedgEntry.SETRANGE("Vendor No.",Vend."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        VendLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT VendLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          Vend.TABLECAPTION,Vend."No.");

      VendLedgEntry.RESET;
      IF NOT VendLedgEntry.SETCURRENTKEY("Vendor No.",Open) THEN
        VendLedgEntry.SETCURRENTKEY("Vendor No.");
      VendLedgEntry.SETRANGE("Vendor No.",Vend."No.");
      VendLedgEntry.SETRANGE(Open,TRUE);
      IF NOT VendLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          Vend.TABLECAPTION,Vend."No.");

      VendLedgEntry.SETRANGE(Open);
      VendLedgEntry.MODIFYALL("Vendor No.",'');

      WarrantyLedgEntry.LOCKTABLE;
      WarrantyLedgEntry.SETRANGE("Vendor No.",Vend."No.");
      WarrantyLedgEntry.MODIFYALL("Vendor No.",'');
    END;

    [External]
    PROCEDURE MoveBankAccEntries@5(BankAcc@1000 : Record 270);
    BEGIN
      BankAccLedgEntry.RESET;
      BankAccLedgEntry.SETCURRENTKEY("Bank Account No.","Posting Date");
      BankAccLedgEntry.SETRANGE("Bank Account No.",BankAcc."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        BankAccLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT BankAccLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          BankAcc.TABLECAPTION,BankAcc."No.");

      BankAccLedgEntry.RESET;
      IF NOT BankAccLedgEntry.SETCURRENTKEY("Bank Account No.",Open) THEN
        BankAccLedgEntry.SETCURRENTKEY("Bank Account No.");
      BankAccLedgEntry.SETRANGE("Bank Account No.",BankAcc."No.");
      BankAccLedgEntry.SETRANGE(Open,TRUE);
      IF NOT BankAccLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          BankAcc.TABLECAPTION,BankAcc."No.");

      BankAccLedgEntry.SETRANGE(Open);
      BankAccLedgEntry.MODIFYALL("Bank Account No.",'');
      CheckLedgEntry.SETCURRENTKEY("Bank Account No.");
      CheckLedgEntry.SETRANGE("Bank Account No.",BankAcc."No.");
      CheckLedgEntry.MODIFYALL("Bank Account No.",'');
    END;

    [External]
    PROCEDURE MoveItemEntries@4(Item@1000 : Record 27);
    VAR
      IdentityManagement@1001 : Codeunit 9801;
    BEGIN
      ItemLedgEntry.RESET;
      ItemLedgEntry.SETCURRENTKEY("Item No.");
      ItemLedgEntry.SETRANGE("Item No.",Item."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ItemLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ItemLedgEntry.ISEMPTY THEN BEGIN
        IF IdentityManagement.IsInvAppId THEN
          ERROR(
            CannotDeleteBecauseInInvErr,
            Item.TABLECAPTION);

        ERROR(
          Text000,
          Item.TABLECAPTION,Item."No.");
      END;

      ItemLedgEntry.RESET;
      ItemLedgEntry.SETCURRENTKEY("Item No.");
      ItemLedgEntry.SETRANGE("Item No.",Item."No.");
      ItemLedgEntry.SETRANGE("Completely Invoiced",FALSE);
      IF NOT ItemLedgEntry.ISEMPTY THEN
        ERROR(
          Text008 +
          Text003 +
          Text009,Item."No.");
      ItemLedgEntry.SETRANGE("Completely Invoiced");

      ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
      ItemLedgEntry.SETRANGE(Open,TRUE);
      IF NOT ItemLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          Item.TABLECAPTION,Item."No.");

      ItemLedgEntry.SETCURRENTKEY("Item No.","Applied Entry to Adjust");
      ItemLedgEntry.SETRANGE(Open,FALSE);
      ItemLedgEntry.SETRANGE("Applied Entry to Adjust",TRUE);
      IF NOT ItemLedgEntry.ISEMPTY THEN
        ERROR(
          Text002 +
          Text003 +
          Text004,
          Item."No.",Text005);
      ItemLedgEntry.SETRANGE("Applied Entry to Adjust");

      IF Item."Costing Method" = Item."Costing Method"::Average THEN BEGIN
        AvgCostAdjmt.RESET;
        AvgCostAdjmt.SETRANGE("Item No.",Item."No.");
        AvgCostAdjmt.SETRANGE("Cost Is Adjusted",FALSE);
        IF NOT AvgCostAdjmt.ISEMPTY THEN
          ERROR(
            Text002 +
            Text003 +
            Text004,
            Item."No.",Text005);
      END;

      ItemLedgEntry.SETRANGE(Open);
      ItemLedgEntry.MODIFYALL("Item No.",'');

      ValueEntry.RESET;
      ValueEntry.SETCURRENTKEY("Item No.");
      ValueEntry.SETRANGE("Item No.",Item."No.");
      ValueEntry.MODIFYALL("Item No.",'');

      AvgCostAdjmt.RESET;
      AvgCostAdjmt.SETRANGE("Item No.",Item."No.");
      AvgCostAdjmt.DELETEALL;

      InvtAdjmtEntryOrder.RESET;
      InvtAdjmtEntryOrder.SETRANGE("Item No.",Item."No.");
      InvtAdjmtEntryOrder.SETRANGE("Order Type",InvtAdjmtEntryOrder."Order Type"::Production);
      InvtAdjmtEntryOrder.MODIFYALL("Cost is Adjusted",TRUE);
      InvtAdjmtEntryOrder.SETRANGE("Order Type");
      InvtAdjmtEntryOrder.MODIFYALL("Item No.",'');

      ServLedgEntry.RESET;
      ServLedgEntry.SETRANGE("Item No. (Serviced)",Item."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ServLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          Item.TABLECAPTION,Item."No.");

      ServLedgEntry.SETRANGE("Posting Date");
      ServLedgEntry.SETRANGE(Open,TRUE);
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          Item.TABLECAPTION,Item."No.");

      ServLedgEntry.SETRANGE(Open);
      ServLedgEntry.MODIFYALL("Item No. (Serviced)",'');

      ServLedgEntry.SETRANGE("Item No. (Serviced)");
      ServLedgEntry.SETRANGE(Type,ServLedgEntry.Type::Item);
      ServLedgEntry.SETRANGE("No.",Item."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ServLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          Item.TABLECAPTION,Item."No.");

      ServLedgEntry.SETRANGE("Posting Date");
      ServLedgEntry.SETRANGE(Open,TRUE);
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          Item.TABLECAPTION,Item."No.");

      ServLedgEntry.SETRANGE(Open);
      ServLedgEntry.MODIFYALL("No.",'');

      WarrantyLedgEntry.LOCKTABLE;
      WarrantyLedgEntry.SETRANGE("Item No. (Serviced)",Item."No.");
      WarrantyLedgEntry.MODIFYALL("Item No. (Serviced)",'');

      WarrantyLedgEntry.SETRANGE("Item No. (Serviced)");
      WarrantyLedgEntry.SETRANGE(Type,WarrantyLedgEntry.Type::Item);
      WarrantyLedgEntry.SETRANGE("No.",Item."No.");
      WarrantyLedgEntry.MODIFYALL("No.",'');
    END;

    [External]
    PROCEDURE MoveResEntries@6(Res@1000 : Record 156);
    BEGIN
      ResLedgEntry.RESET;
      ResLedgEntry.SETCURRENTKEY("Resource No.","Posting Date");
      ResLedgEntry.SETRANGE("Resource No.",Res."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ResLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ResLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          Res.TABLECAPTION,Res."No.");

      ResLedgEntry.RESET;
      ResLedgEntry.SETCURRENTKEY("Resource No.");
      ResLedgEntry.SETRANGE("Resource No.",Res."No.");
      ResLedgEntry.MODIFYALL("Resource No.",'');

      ServLedgEntry.RESET;
      ServLedgEntry.SETRANGE(Type,ServLedgEntry.Type::Resource);
      ServLedgEntry.SETRANGE("No.",Res."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ServLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          Res.TABLECAPTION,Res."No.");

      ServLedgEntry.SETRANGE("Posting Date");
      ServLedgEntry.SETRANGE(Open,TRUE);
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          Res.TABLECAPTION,Res."No.");

      ServLedgEntry.SETRANGE(Open);
      ServLedgEntry.MODIFYALL("No.",'');

      WarrantyLedgEntry.LOCKTABLE;
      WarrantyLedgEntry.SETRANGE(Type,WarrantyLedgEntry.Type::Resource);
      WarrantyLedgEntry.SETRANGE("No.",Res."No.");
      WarrantyLedgEntry.MODIFYALL("No.",'');
    END;

    [External]
    PROCEDURE MoveJobEntries@7(Job@1000 : Record 167);
    VAR
      TimeSheetLine@1001 : Record 951;
    BEGIN
      JobLedgEntry.SETCURRENTKEY("Job No.");
      JobLedgEntry.SETRANGE("Job No.",Job."No.");

      IF NOT JobLedgEntry.ISEMPTY THEN
        ERROR(
          Text006,
          Job.TABLECAPTION,Job."No.");

      TimeSheetLine.SETRANGE(Type,TimeSheetLine.Type::Job);
      TimeSheetLine.SETRANGE("Job No.",Job."No.");
      TimeSheetLine.SETFILTER(Status,'%1|%2',TimeSheetLine.Status::Open,TimeSheetLine.Status::Submitted);
      IF NOT TimeSheetLine.ISEMPTY THEN
        ERROR(TimeSheetLinesErr,Job."No.");

      PurchOrderLine.SETCURRENTKEY("Document Type");
      PurchOrderLine.SETFILTER(
        "Document Type",'%1|%2',
        PurchOrderLine."Document Type"::Order,
        PurchOrderLine."Document Type"::"Return Order");
      PurchOrderLine.SETRANGE("Job No.",Job."No.");
      IF PurchOrderLine.FINDFIRST THEN BEGIN
        IF PurchOrderLine."Document Type" = PurchOrderLine."Document Type"::Order THEN
          ERROR(Text007,Job.TABLECAPTION,Job."No.");
        IF PurchOrderLine."Document Type" = PurchOrderLine."Document Type"::"Return Order" THEN
          ERROR(Text015,Job.TABLECAPTION,Job."No.");
      END;

      ServLedgEntry.RESET;
      ServLedgEntry.SETRANGE("Job No.",Job."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ServLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          Job.TABLECAPTION,Job."No.");

      ServLedgEntry.SETRANGE("Posting Date");
      ServLedgEntry.SETRANGE(Open,TRUE);
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          Job.TABLECAPTION,Job."No.");

      ServLedgEntry.SETRANGE(Open);
      ServLedgEntry.MODIFYALL("Job No.",'');
    END;

    [External]
    PROCEDURE MoveServiceItemLedgerEntries@8(ServiceItem@1000 : Record 5940);
    VAR
      ResultDescription@1001 : Text;
    BEGIN
      ServLedgEntry.LOCKTABLE;

      ResultDescription := CheckIfServiceItemCanBeDeleted(ServLedgEntry,ServiceItem."No.");
      IF ResultDescription <> '' THEN
        ERROR(ResultDescription);

      ServLedgEntry.MODIFYALL("Service Item No. (Serviced)",'');

      WarrantyLedgEntry.LOCKTABLE;
      WarrantyLedgEntry.SETRANGE("Service Item No. (Serviced)",ServiceItem."No.");
      WarrantyLedgEntry.MODIFYALL("Service Item No. (Serviced)",'');
    END;

    [External]
    PROCEDURE MoveServContractLedgerEntries@9(ServiceContractHeader@1000 : Record 5965);
    BEGIN
      IF ServiceContractHeader.Prepaid THEN BEGIN
        ServLedgEntry.RESET;
        ServLedgEntry.SETCURRENTKEY(Type,"No.");
        ServLedgEntry.SETRANGE(Type,ServLedgEntry.Type::"Service Contract");
        ServLedgEntry.SETRANGE("No.",ServiceContractHeader."Contract No.");
        ServLedgEntry.SETRANGE(Prepaid,TRUE);
        ServLedgEntry.SETRANGE("Moved from Prepaid Acc.",FALSE);
        ServLedgEntry.SETRANGE(Open,FALSE);
        IF NOT ServLedgEntry.ISEMPTY THEN
          ERROR(
            Text013,
            ServiceContractHeader.TABLECAPTION,ServiceContractHeader."Contract No.",ServLedgEntry.TABLECAPTION);
        ServLedgEntry.SETRANGE(Open,TRUE);
        IF NOT ServLedgEntry.ISEMPTY THEN
          ERROR(
            Text014,
            ServiceContractHeader.TABLECAPTION,ServiceContractHeader."Contract No.",ServLedgEntry.TABLECAPTION);
      END;

      ServLedgEntry.RESET;
      ServLedgEntry.SETRANGE("Service Contract No.",ServiceContractHeader."Contract No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ServLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          ServiceContractHeader.TABLECAPTION,ServiceContractHeader."Contract No.");

      ServLedgEntry.SETRANGE("Posting Date");
      ServLedgEntry.SETRANGE(Open,TRUE);
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          ServiceContractHeader.TABLECAPTION,ServiceContractHeader."Contract No.");

      ServLedgEntry.SETRANGE(Open);
      ServLedgEntry.MODIFYALL("Service Contract No.",'');

      ServLedgEntry.SETRANGE("Service Contract No.");
      ServLedgEntry.SETRANGE(Type,ServLedgEntry.Type::"Service Contract");
      ServLedgEntry.SETRANGE("No.",ServiceContractHeader."Contract No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ServLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          ServiceContractHeader.TABLECAPTION,ServiceContractHeader."Contract No.");

      ServLedgEntry.SETRANGE("Posting Date");
      ServLedgEntry.SETRANGE(Open,TRUE);
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          ServiceContractHeader.TABLECAPTION,ServiceContractHeader."Contract No.");

      ServLedgEntry.SETRANGE(Open);
      ServLedgEntry.MODIFYALL("No.",'');

      WarrantyLedgEntry.LOCKTABLE;
      WarrantyLedgEntry.SETRANGE("Service Contract No.",ServiceContractHeader."Contract No.");
      WarrantyLedgEntry.MODIFYALL("Service Contract No.",'');
    END;

    [External]
    PROCEDURE MoveServiceCostLedgerEntries@13(ServiceCost@1000 : Record 5905);
    BEGIN
      ServLedgEntry.RESET;
      ServLedgEntry.SETRANGE(Type,ServLedgEntry.Type::"Service Cost");
      ServLedgEntry.SETRANGE("No.",ServiceCost.Code);
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ServLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text000,
          ServiceCost.TABLECAPTION,ServiceCost.Code);

      ServLedgEntry.SETRANGE("Posting Date");
      ServLedgEntry.SETRANGE(Open,TRUE);
      IF NOT ServLedgEntry.ISEMPTY THEN
        ERROR(
          Text001,
          ServiceCost.TABLECAPTION,ServiceCost.Code);

      ServLedgEntry.SETRANGE(Open);
      ServLedgEntry.MODIFYALL("No.",'');

      WarrantyLedgEntry.LOCKTABLE;
      WarrantyLedgEntry.SETRANGE(Type,WarrantyLedgEntry.Type::"Service Cost");
      WarrantyLedgEntry.SETRANGE("No.",ServiceCost.Code);
      WarrantyLedgEntry.MODIFYALL("No.",'');
    END;

    [External]
    PROCEDURE MoveCashFlowEntries@10(CashFlowAccount@1004 : Record 841);
    VAR
      CFForecastEntry@1003 : Record 847;
      CFSetup@1002 : Record 843;
      CFWorksheetLine@1000 : Record 846;
    BEGIN
      CashFlowAccount.LOCKTABLE;

      IF CashFlowAccount."Account Type" = CashFlowAccount."Account Type"::Entry THEN BEGIN
        CashFlowAccount.CALCFIELDS(Amount);
        CashFlowAccount.TESTFIELD(Amount,0);
      END;

      CFForecastEntry.RESET;
      CFForecastEntry.SETCURRENTKEY("Cash Flow Account No.");
      CFForecastEntry.SETRANGE("Cash Flow Account No.",CashFlowAccount."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        CFForecastEntry.SETFILTER("Cash Flow Date",'>%1',AccountingPeriod."Starting Date");
      IF NOT CFForecastEntry.ISEMPTY THEN
        ERROR(
          Text000,
          CashFlowAccount.TABLECAPTION,CashFlowAccount."No.");

      CFSetup.GET;
      IF CFSetup."Receivables CF Account No." = CashFlowAccount."No." THEN
        CFSetup.MODIFYALL("Receivables CF Account No.",'');

      IF CFSetup."Payables CF Account No." = CashFlowAccount."No." THEN
        CFSetup.MODIFYALL("Payables CF Account No.",'');

      IF CFSetup."Sales Order CF Account No." = CashFlowAccount."No." THEN
        CFSetup.MODIFYALL("Sales Order CF Account No.",'');

      IF CFSetup."Purch. Order CF Account No." = CashFlowAccount."No." THEN
        CFSetup.MODIFYALL("Purch. Order CF Account No.",'');

      IF CFSetup."FA Budget CF Account No." = CashFlowAccount."No." THEN
        CFSetup.MODIFYALL("FA Budget CF Account No.",'');

      IF CFSetup."FA Disposal CF Account No." = CashFlowAccount."No." THEN
        CFSetup.MODIFYALL("FA Disposal CF Account No.",'');

      IF CFSetup."Service CF Account No." = CashFlowAccount."No." THEN
        CFSetup.MODIFYALL("Service CF Account No.",'');

      CFWorksheetLine.RESET;
      CFWorksheetLine.SETRANGE("Cash Flow Account No.",CashFlowAccount."No.");
      CFWorksheetLine.MODIFYALL("Cash Flow Account No.",'');

      CFForecastEntry.RESET;
      CFForecastEntry.SETCURRENTKEY("Cash Flow Forecast No.");
      CFForecastEntry.SETRANGE("Cash Flow Account No.",CashFlowAccount."No.");
      CFForecastEntry.MODIFYALL("Cash Flow Account No.",'');
    END;

    [External]
    PROCEDURE MoveDocRelatedEntries@67(TableNo@1003 : Integer;DocNo@1001 : Code[20]);
    VAR
      ItemLedgEntry2@1002 : Record 32;
      ValueEntry2@1004 : Record 5802;
      CostCalcMgt@1000 : Codeunit 5836;
    BEGIN
      ItemLedgEntry2.LOCKTABLE;
      ItemLedgEntry2.SETCURRENTKEY("Document No.");
      ItemLedgEntry2.SETRANGE("Document No.",DocNo);
      ItemLedgEntry2.SETRANGE("Document Type",CostCalcMgt.GetDocType(TableNo));
      ItemLedgEntry2.SETFILTER("Document Line No.",'<>0');
      ItemLedgEntry2.MODIFYALL("Document Line No.",0);

      ValueEntry2.LOCKTABLE;
      ValueEntry2.SETCURRENTKEY("Document No.");
      ValueEntry2.SETRANGE("Document No.",DocNo);
      ValueEntry2.SETRANGE("Document Type",CostCalcMgt.GetDocType(TableNo));
      ValueEntry2.SETFILTER("Document Line No.",'<>0');
      ValueEntry2.MODIFYALL("Document Line No.",0);
    END;

    [External]
    PROCEDURE CheckIfServiceItemCanBeDeleted@11(VAR ServiceLedgerEntry@1000 : Record 5907;ServiceItemNo@1001 : Code[20]) : Text;
    VAR
      ServiceItem@1003 : Record 5940;
    BEGIN
      ServiceLedgerEntry.RESET;
      ServiceLedgerEntry.SETCURRENTKEY("Service Item No. (Serviced)");
      ServiceLedgerEntry.SETRANGE("Service Item No. (Serviced)",ServiceItemNo);
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        ServiceLedgerEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT ServiceLedgerEntry.ISEMPTY THEN
        EXIT(STRSUBSTNO(Text000,ServiceItem.TABLECAPTION,ServiceItemNo));

      ServiceLedgerEntry.SETRANGE("Posting Date");
      ServiceLedgerEntry.SETRANGE(Open,TRUE);
      IF NOT ServiceLedgerEntry.ISEMPTY THEN
        EXIT(STRSUBSTNO(Text001,ServiceItem.TABLECAPTION,ServiceItemNo));

      ServiceLedgerEntry.SETRANGE(Open);
      EXIT('');
    END;

    LOCAL PROCEDURE CheckGLAccountEntries@12(GLAccount@1000 : Record 15;GeneralLedgerSetup@1002 : Record 98);
    VAR
      GLBudgetEntry@1003 : Record 96;
      HasGLEntries@1004 : Boolean;
      HasGLBudgetEntries@1005 : Boolean;
    BEGIN
      IF GLAccount."Account Type" = GLAccount."Account Type"::Posting THEN BEGIN
        GLAccount.CALCFIELDS(Balance);
        GLAccount.TESTFIELD(Balance,0);
      END;

      GLEntry.SETRANGE("G/L Account No.",GLAccount."No.");
      AccountingPeriod.SETRANGE(Closed,FALSE);
      IF AccountingPeriod.FINDFIRST THEN
        GLEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
      IF NOT GLEntry.ISEMPTY THEN
        ERROR(CannotDeleteGLAccountWithEntriesInOpenFiscalYearErr,GLAccount."No.");

      AccountingPeriod.SETRANGE(Closed,TRUE);
      IF AccountingPeriod.ISEMPTY THEN
        EXIT;

      GeneralLedgerSetup.TESTFIELD("Allow G/L Acc. Deletion Before");

      GLEntry.SETFILTER("Posting Date",'>=%1',GeneralLedgerSetup."Allow G/L Acc. Deletion Before");

      GLBudgetEntry.LOCKTABLE;
      GLBudgetEntry.SETCURRENTKEY("Budget Name","G/L Account No.",Date);
      GLBudgetEntry.SETRANGE("G/L Account No.",GLAccount."No.");
      GLBudgetEntry.SETFILTER(Date,'>=%1',GeneralLedgerSetup."Allow G/L Acc. Deletion Before");

      HasGLEntries := NOT GLEntry.ISEMPTY;
      HasGLBudgetEntries := GLBudgetEntry.FINDFIRST;

      IF HasGLEntries OR HasGLBudgetEntries THEN BEGIN
        IF CONFIRM(GLAccDeleteClosedPeriodsQst) THEN
          EXIT;

        IF HasGLEntries THEN
          ERROR(
            CannotDeleteGLAccountWithEntriesAfterDateErr,
            GLAccount."No.",GeneralLedgerSetup."Allow G/L Acc. Deletion Before");
        IF HasGLBudgetEntries THEN
          ERROR(
            CannotDeleteGLBugetEntriesErr,
            GLAccount."No.",GeneralLedgerSetup."Allow G/L Acc. Deletion Before",GLBudgetEntry."Budget Name");
      END;
    END;

    BEGIN
    END.
  }
}

