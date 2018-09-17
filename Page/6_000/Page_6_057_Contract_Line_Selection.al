OBJECT Page 6057 Contract Line Selection
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontraktlinjevalg;
               ENU=Contract Line Selection];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table5940;
    DataCaptionFields=Customer No.;
    PageType=Worksheet;
    OnInit=BEGIN
             CurrPage.LOOKUPMODE := TRUE;
           END;

    OnOpenPage=BEGIN
                 OKButton := FALSE;
                 SETCURRENTKEY("Customer No.","Ship-to Code");
                 FILTERGROUP(2);
                 SETRANGE("Customer No.",CustomerNo);
                 SETFILTER(Status,'<>%1',Status::Defective);
                 FILTERGROUP(0);
                 SETRANGE("Ship-to Code",ShipToCode);
                 SetSelectionFilter;
               END;

    OnQueryClosePage=BEGIN
                       IF CloseAction = ACTION::LookupOK THEN
                         LookupOKOnPush;
                       IF OKButton THEN BEGIN
                         ServContract.GET(ContractType,ContractNo);
                         CurrPage.SETSELECTIONFILTER(Rec);
                         ServContractLine.HideDialogBox(TRUE);
                         IF FIND('-') THEN
                           REPEAT
                             CheckServContractLine;
                           UNTIL NEXT = 0;
                         CreateServContractLines;
                         COMMIT;
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 32      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Serviceart.;
                                 ENU=&Serv. Item];
                      Image=ServiceItem }
      { 33      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=&Kort;
                                 ENU=&Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om servicekontrakten.;
                                 ENU=View or edit detailed information for the service contract.];
                      ApplicationArea=#Service;
                      RunObject=Page 5980;
                      RunPageOnRec=Yes;
                      RunPageLink=No.=FIELD(No.);
                      Image=EditLines }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 2   ;1   ;Field     ;
                CaptionML=[DAN=Valgfilter;
                           ENU=Selection Filter];
                ToolTipML=[DAN=Angiver et valgfilter.;
                           ENU=Specifies a selection filter.];
                OptionCaptionML=[DAN=Alle serviceartikler,Serviceartikler uden kontrakt;
                                 ENU=All Service Items,Service Items without Contract];
                ApplicationArea=#Service;
                SourceExpr=SelectionFilter;
                OnValidate=BEGIN
                             SelectionFilterOnAfterValidate;
                           END;
                            }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Varenr.;
                           ENU=Item No.];
                ToolTipML=[DAN=Angiver det varenummer, som er knyttet til serviceartiklen.;
                           ENU=Specifies the item number linked to the service item.];
                ApplicationArea=#Service;
                SourceExpr="Item No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p� varen.;
                           ENU=Specifies the serial number of this item.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No." }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen.;
                           ENU=Specifies a description of this item.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som ejer varen.;
                           ENU=Specifies the number of the customer who owns this item.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs� i tilf�lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� kreditoren for varen.;
                           ENU=Specifies the number of the vendor for this item.];
                ApplicationArea=#Service;
                SourceExpr="Vendor No.";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Service;
                SourceExpr="Vendor Item No.";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ServContract@1000 : Record 5965;
      ServContractLine@1008 : Record 5964;
      TempServItem@1001 : TEMPORARY Record 5940;
      OKButton@1002 : Boolean;
      CustomerNo@1004 : Code[20];
      ShipToCode@1005 : Code[10];
      ContractNo@1006 : Code[20];
      ContractType@1007 : Integer;
      LineNo@1009 : Integer;
      Text000@1010 : TextConst '@@@=Service Item 1 already exists in this service contract.;DAN=%1 %2 findes allerede i denne servicekontrakt.;ENU=%1 %2 already exists in this service contract.';
      Text001@1012 : TextConst '@@@=Service Item 1 already belongs to one or more service contracts/quotes.\\Do you want to include this service item into the document?;DAN=%1 %2 er allerede knyttet til en eller flere servicekontrakter/tilbud.\\Skal denne serviceartikel medtages i dokumentet?;ENU=%1 %2 already belongs to one or more service contracts/quotes.\\Do you want to include this service item into the document?';
      Text002@1011 : TextConst '@@@=Service Item 1 has a different ship-to code for this customer.\\Do you want to include this service item into the document?;DAN=%1 %2 har en anden leveringsadressekode for denne debitor.\\Skal denne serviceartikel medtages i dokumentet?;ENU=%1 %2 has a different ship-to code for this customer.\\Do you want to include this service item into the document?';
      SelectionFilter@1013 : 'All Service Items,Service Items without Contract';

    [External]
    PROCEDURE SetSelection@1(CustNo@1000 : Code[20];ShipNo@1001 : Code[10];CtrType@1004 : Integer;CtrNo@1002 : Code[20]);
    BEGIN
      CustomerNo := CustNo;
      ShipToCode := ShipNo;
      ContractType := CtrType;
      ContractNo := CtrNo;
    END;

    LOCAL PROCEDURE FindlineNo@2() : Integer;
    BEGIN
      ServContractLine.RESET;
      ServContractLine.SETRANGE("Contract Type",ContractType);
      ServContractLine.SETRANGE("Contract No.",ContractNo);
      IF ServContractLine.FINDLAST THEN
        EXIT(ServContractLine."Line No.");

      EXIT(0);
    END;

    LOCAL PROCEDURE CheckServContractLine@3();
    BEGIN
      TempServItem := Rec;

      ServContractLine.RESET;
      ServContractLine.SETCURRENTKEY("Service Item No.");
      ServContractLine.SETRANGE("Contract No.",ServContract."Contract No.");
      ServContractLine.SETRANGE("Contract Type",ServContract."Contract Type");
      ServContractLine.SETRANGE("Service Item No.",TempServItem."No.");
      IF ServContractLine.FINDFIRST THEN BEGIN
        MESSAGE(Text000,TempServItem.TABLECAPTION,TempServItem."No.");
        EXIT;
      END;

      ServContractLine.RESET;
      ServContractLine.SETCURRENTKEY("Service Item No.","Contract Status");
      ServContractLine.SETRANGE("Service Item No.",TempServItem."No.");
      ServContractLine.SETFILTER("Contract Status",'<>%1',ServContractLine."Contract Status"::Cancelled);
      ServContractLine.SETRANGE("Contract Type",ServContractLine."Contract Type"::Contract);
      ServContractLine.SETFILTER("Contract No.",'<>%1',ServContract."Contract No.");
      IF ServContractLine.FINDFIRST THEN BEGIN
        IF NOT CONFIRM(Text001,TRUE,TempServItem.TABLECAPTION,TempServItem."No.") THEN
          EXIT;
      END ELSE BEGIN
        ServContractLine.RESET;
        ServContractLine.SETCURRENTKEY("Service Item No.");
        ServContractLine.SETRANGE("Service Item No.",TempServItem."No.");
        ServContractLine.SETRANGE("Contract Type",ServContractLine."Contract Type"::Quote);
        ServContractLine.SETFILTER("Contract No.",'<>%1',ServContract."Contract No.");
        IF ServContractLine.FINDFIRST THEN
          IF NOT CONFIRM(Text001,TRUE,TempServItem.TABLECAPTION,TempServItem."No.") THEN
            EXIT;
      END;

      IF TempServItem."Ship-to Code" <> ServContract."Ship-to Code" THEN
        IF NOT CONFIRM(Text002,FALSE,TempServItem.TABLECAPTION,TempServItem."No.") THEN
          EXIT;

      TempServItem.INSERT;
    END;

    LOCAL PROCEDURE CreateServContractLines@4();
    BEGIN
      ServContractLine.LOCKTABLE;
      LineNo := FindlineNo + 10000;
      IF TempServItem.FIND('-') THEN
        REPEAT
          ServContractLine.INIT;
          ServContractLine.HideDialogBox(TRUE);
          ServContractLine."Contract Type" := ServContract."Contract Type";
          ServContractLine."Contract No." := ServContract."Contract No.";
          ServContractLine."Line No." := LineNo;
          ServContractLine.SetupNewLine;
          ServContractLine.VALIDATE("Service Item No.",TempServItem."No.");
          ServContractLine.VALIDATE("Line Value",TempServItem."Default Contract Value");
          ServContractLine.VALIDATE("Line Discount %",TempServItem."Default Contract Discount %");
          ServContractLine.INSERT(TRUE);
          LineNo := LineNo + 10000;
        UNTIL TempServItem.NEXT = 0
    END;

    [External]
    PROCEDURE SetSelectionFilter@5();
    BEGIN
      CASE SelectionFilter OF
        SelectionFilter::"All Service Items":
          SETRANGE("No. of Active Contracts");
        SelectionFilter::"Service Items without Contract":
          SETRANGE("No. of Active Contracts",0);
      END;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE SelectionFilterOnAfterValidate@19033692();
    BEGIN
      CurrPage.UPDATE;
      SetSelectionFilter;
    END;

    LOCAL PROCEDURE LookupOKOnPush@19031339();
    BEGIN
      OKButton := "No." <> '';
    END;

    BEGIN
    END.
  }
}

