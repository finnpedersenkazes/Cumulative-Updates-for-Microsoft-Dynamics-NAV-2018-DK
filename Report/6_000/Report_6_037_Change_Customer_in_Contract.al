OBJECT Report 6037 Change Customer in Contract
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Skift debitor i kontrakt;
               ENU=Change Customer in Contract];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  IF NewCustomerNo = '' THEN
                    ERROR(Text000);
                  Cust.GET(NewCustomerNo);
                  IF NewShiptoCode <> '' THEN
                    ShipToAddr.GET(NewCustomerNo,NewShiptoCode);
                  IF (NewShiptoCode = ServContract."Ship-to Code") AND
                     (NewCustomerNo = ServContract."Customer No.")
                  THEN
                    ERROR(Text011);

                  IF NOT CONFIRM(Text002,FALSE) THEN
                    CurrReport.QUIT;

                  IF TempServContract.COUNT > 1 THEN
                    IF NOT CONFIRM(
                         Text009,FALSE,
                         TempServContract.COUNT,
                         TempServItem.COUNT)
                    THEN
                      CurrReport.QUIT;
                END;

    OnPostReport=VAR
                   ServItem@1006 : Record 5940;
                   Window@1005 : Dialog;
                   CounterTotal@1003 : Integer;
                   Counter@1002 : Integer;
                   CounterBreak@1000 : Integer;
                   ItemCounter@1004 : Integer;
                 BEGIN
                   ServItem.LOCKTABLE;
                   ServContractLine.LOCKTABLE;
                   ServContract.LOCKTABLE;
                   CLEAR(TempServContract);
                   CLEAR(TempServItem);
                   ServContractMgt.GetAffectedItemsOnCustChange(
                     ContractNo,
                     TempServContract,
                     TempServItem,
                     FALSE,
                     ServContractLine."Contract Type"::Contract);

                   Window.OPEN(
                     Text005 +
                     Text006 +
                     '#1###' +
                     Text007 +
                     '#2###  @3@@@@@@@@@\\' +
                     Text008 +
                     '#4###' +
                     Text007 +
                     '#5###  @6@@@@@@@@@\\');
                   Window.UPDATE(2,TempServContract.COUNT);
                   Window.UPDATE(5,TempServItem.COUNT);

                   CounterTotal := TempServContract.COUNT;
                   Counter := 0;
                   ItemCounter := 0;
                   CounterBreak := ROUND(CounterTotal / 100,1,'>');
                   IF TempServContract.FIND('-') THEN
                     REPEAT
                       Counter := Counter + 1;
                       ItemCounter := ItemCounter + 1;
                       IF Counter >= CounterBreak THEN BEGIN
                         Counter := 0;
                         Window.UPDATE(3,ROUND(ItemCounter / CounterTotal * 10000,1));
                       END;
                       Window.UPDATE(1,ItemCounter);
                       ServContract.GET(TempServContract."Contract Type",TempServContract."Contract No.");
                       ServContractMgt.ChangeCustNoOnServContract(NewCustomerNo,NewShiptoCode,ServContract)
                     UNTIL TempServContract.NEXT = 0
                   ELSE
                     Window.UPDATE(3,10000);

                   CounterTotal := TempServItem.COUNT;
                   Counter := 0;
                   ItemCounter := 0;
                   CounterBreak := ROUND(CounterTotal / 100,1,'>');
                   IF TempServItem.FIND('-') THEN
                     REPEAT
                       Counter := Counter + 1;
                       ItemCounter := ItemCounter + 1;
                       IF Counter >= CounterBreak THEN BEGIN
                         Counter := 0;
                         Window.UPDATE(6,ROUND(ItemCounter / CounterTotal * 10000,1));
                       END;
                       Window.UPDATE(4,ItemCounter);
                       ServItem.GET(TempServItem."No.");
                       ServContractMgt.ChangeCustNoOnServItem(NewCustomerNo,NewShiptoCode,ServItem)
                     UNTIL TempServItem.NEXT = 0
                   ELSE
                     Window.UPDATE(6,10000);
                 END;

  }
  DATASET
  {
  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      OnOpenPage=BEGIN
                   ServContractMgt.GetAffectedItemsOnCustChange(
                     ContractNo,
                     TempServContract,
                     TempServItem,
                     FALSE,
                     ServContractLine."Contract Type"::Contract);

                   IF TempServContract.COUNT > 1 THEN
                     ContractNoText := Text004
                   ELSE
                     ContractNoText := TempServContract."Contract No.";

                   IF TempServItem.COUNT > 1 THEN
                     ServiceItemNoText := Text004
                   ELSE
                     ServiceItemNoText := TempServItem."No.";
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  DrillDown=Yes;
                  CaptionML=[DAN=Kontraktnr.;
                             ENU=Contract No.];
                  ToolTipML=[DAN=Angiver alle fakturerbare avancer for sagsopgaven, anf›rt i den lokale valuta.;
                             ENU=Specifies all billable profits for the job task, expressed in the local currency.];
                  ApplicationArea=#Service;
                  SourceExpr=ContractNoText;
                  Editable=FALSE;
                  OnDrillDown=BEGIN
                                PAGE.RUNMODAL(PAGE::"Service Contract List",TempServContract);
                              END;
                               }

      { 11  ;2   ;Field     ;
                  DrillDown=Yes;
                  CaptionML=[DAN=Serviceartikelnr.;
                             ENU=Service Item No.];
                  ToolTipML=[DAN=Angiver feltet for at se listen med relaterede serviceartikler, hvis der er mange forskellige serviceartikler.;
                             ENU=Specifies the field to see the list of related service items, if there are a number of service items.];
                  ApplicationArea=#Service;
                  SourceExpr=ServiceItemNoText;
                  Editable=FALSE;
                  OnDrillDown=BEGIN
                                PAGE.RUNMODAL(PAGE::"Service Item List",TempServItem);
                              END;
                               }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Eksisterende debitornr.;
                             ENU=Existing Customer No.];
                  ToolTipML=[DAN=Angiver feltet for at se debitornumrene i kontrakten.;
                             ENU=Specifies the field to see the existing customer number in the contract.];
                  ApplicationArea=#Service;
                  SourceExpr=ServContract."Customer No.";
                  Editable=FALSE }

      { 5   ;2   ;Field     ;
                  CaptionML=[DAN=Eksisterende lev.adr.kode;
                             ENU=Existing Ship-to Code];
                  ToolTipML=[DAN=Angiver feltet for at se leveringsadressekoden i kontrakten.;
                             ENU=Specifies the field to see the existing ship-to code in the contract.];
                  ApplicationArea=#Service;
                  SourceExpr=ServContract."Ship-to Code";
                  Editable=FALSE }

      { 7   ;2   ;Field     ;
                  CaptionML=[DAN=Nyt debitornr.;
                             ENU=New Customer No.];
                  ToolTipML=[DAN=Angiver nummeret p† den nye debitor, som du vil medtage i k›rslen. V‘lg feltet for at se de eksisterende debitornumre.;
                             ENU=Specifies the number of the new customer that you want to include in the batch job. Choose the field to see the existing customer numbers.];
                  ApplicationArea=#Service;
                  SourceExpr=NewCustomerNo;
                  OnValidate=BEGIN
                               IF NewCustomerNo <> '' THEN
                                 VerifyCustNo(NewCustomerNo,NewShiptoCode);
                             END;

                  OnLookup=BEGIN
                             CLEAR(Cust);
                             Cust."No." := NewCustomerNo;
                             Cust.SETFILTER(Blocked,'<>%1',Cust.Blocked::All);
                             IF PAGE.RUNMODAL(0,Cust) = ACTION::LookupOK THEN
                               IF Cust."No." <> '' THEN BEGIN
                                 VerifyCustNo(Cust."No.",NewShiptoCode);
                                 NewCustomerNo := Cust."No.";
                               END;
                           END;
                            }

      { 9   ;2   ;Field     ;
                  CaptionML=[DAN=Ny lev.adr.kode;
                             ENU=New Ship-to Code];
                  ToolTipML=[DAN=Angiver den nye leveringsadressekode, som du vil inkludere i k›rslen. V‘lg feltet for at se de eksisterende leveringskoder.;
                             ENU=Specifies the new ship-to code that you want to include in the batch job. Choose the field to see the existing ship-to codes.];
                  ApplicationArea=#Service;
                  SourceExpr=NewShiptoCode;
                  OnValidate=BEGIN
                               IF NewShiptoCode <> '' THEN
                                 ShipToAddr.GET(NewCustomerNo,NewShiptoCode);
                             END;

                  OnLookup=BEGIN
                             CLEAR(ShipToAddr);
                             ShipToAddr.SETRANGE("Customer No.",NewCustomerNo);
                             ShipToAddr.Code := NewShiptoCode;
                             IF PAGE.RUNMODAL(0,ShipToAddr) = ACTION::LookupOK THEN BEGIN
                               ShipToAddr.GET(ShipToAddr."Customer No.",ShipToAddr.Code);
                               NewShiptoCode := ShipToAddr.Code;
                             END;
                           END;
                            }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Feltet Nyt debitornr. skal udfyldes.;ENU=You must fill in the New Customer No. field.';
      ServContract@1002 : Record 5965;
      Cust@1005 : Record 18;
      ShipToAddr@1006 : Record 222;
      ServContractLine@1027 : Record 5964;
      TempServContract@1019 : TEMPORARY Record 5965;
      TempServItem@1018 : TEMPORARY Record 5940;
      ServContractMgt@1017 : Codeunit 5940;
      ContractNo@1009 : Code[20];
      NewCustomerNo@1011 : Code[20];
      NewShiptoCode@1012 : Code[10];
      Text002@1013 : TextConst 'DAN=Hvis du ‘ndrer debitornummeret eller leveringsadressekoden, bliver de tilknyttede serviceordrer og salgsfakturaer ikke opdateret.\\Vil du forts‘tte?;ENU=If you change the customer number or the ship-to code, the related service orders and sales invoices will not be updated.\\Do you want to continue?';
      Text004@1020 : TextConst 'DAN=(Flere);ENU=(Multiple)';
      ContractNoText@1021 : Text[20];
      ServiceItemNoText@1022 : Text[20];
      Text005@1023 : TextConst 'DAN=Opdatererrelaterede objekter...\\;ENU=Updating related objects...\\';
      Text006@1024 : TextConst 'DAN="Kontrakt     ";ENU="Contract     "';
      Text007@1025 : TextConst 'DAN=" fra ";ENU=" from "';
      Text008@1026 : TextConst 'DAN="Serviceartikel ";ENU="Service item "';
      Text009@1015 : TextConst 'DAN=Er du sikker p†, at du vil ‘ndre debitornummeret i %1 tilknyttede kontrakter/tilbud og %2 tilknyttede serviceartikler?;ENU=Are you sure that you want to change the customer number in %1 related contracts/quotes and %2 related service items?';
      Text010@1016 : TextConst 'DAN=Du kan ikke v‘lge en debitor, der er sp‘rret.;ENU=You cannot select a customer with the status Blocked.';
      Text011@1003 : TextConst 'DAN=Det debitornummer og den leveringsadressekode, som du har valgt, er de samme som i dette dokument.;ENU=The customer number and the ship-to code that you have selected are the same as the ones on this document.';

    PROCEDURE SetRecord@1(ContrNo@1000 : Code[20]);
    BEGIN
      ContractNo := ContrNo;
      ServContract.GET(ServContract."Contract Type"::Contract,ContractNo);
      ServContract.TESTFIELD("Change Status",ServContract."Change Status"::Open);
    END;

    LOCAL PROCEDURE VerifyCustNo@3(CustNo@1000 : Code[20];ShiptoCode@1001 : Code[20]);
    BEGIN
      IF CustNo <> '' THEN BEGIN
        Cust.GET(CustNo);
        IF Cust."Privacy Blocked" THEN
          ERROR(Cust.GetPrivacyBlockedGenericErrorText(Cust));
        IF Cust.Blocked = Cust.Blocked::All THEN
          ERROR(Text010);
        IF NOT ShipToAddr.GET(CustNo,ShiptoCode) THEN
          NewShiptoCode := '';
      END;
    END;

    PROCEDURE InitializeRequest@2(NewCustomerNoFrom@1000 : Code[20];NewShipToCodeFrom@1001 : Code[10]);
    BEGIN
      NewCustomerNo := NewCustomerNoFrom;
      NewShiptoCode := NewShipToCodeFrom;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

