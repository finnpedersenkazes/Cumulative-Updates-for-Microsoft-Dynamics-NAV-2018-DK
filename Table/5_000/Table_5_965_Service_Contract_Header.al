OBJECT Table 5965 Service Contract Header
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    DataCaptionFields=Contract No.,Description;
    OnInsert=BEGIN
               ServMgtSetup.GET;
               IF "Contract No." = '' THEN BEGIN
                 ServMgtSetup.TESTFIELD("Service Contract Nos.");
                 NoSeriesMgt.InitSeries(ServMgtSetup."Service Contract Nos.",xRec."No. Series",0D,
                   "Contract No.","No. Series");
               END;
               "Starting Date" := WORKDATE;
               "First Service Date" := WORKDATE;
               ServContractTmplt.RESET;
               IF ServContractTmplt.FINDFIRST THEN
                 IF CONFIRM(Text000,TRUE) THEN BEGIN
                   COMMIT;
                   CLEAR(ServContrQuoteTmplUpd);
                   ServContrQuoteTmplUpd.RUN(Rec);
                 END;
               VALIDATE("Starting Date");
             END;

    OnModify=BEGIN
               CheckChangeStatus;
               IF ("Contract Type" = "Contract Type"::Contract) AND ("Contract No." <> '') THEN BEGIN
                 ServMgtSetup.GET;
                 IF ServMgtSetup."Register Contract Changes" THEN
                   UpdContractChangeLog(xRec);

                 IF (Status <> xRec.Status) AND
                    (Status = Status::Canceled)
                 THEN
                   ContractGainLossEntry.AddEntry(3,"Contract Type","Contract No.",-"Annual Amount","Cancel Reason Code");
               END;

               IF (Status = Status::Signed) AND
                  ("Annual Amount" <> xRec."Annual Amount")
               THEN
                 ContractGainLossEntry.AddEntry(4,"Contract Type",
                   "Contract No.","Annual Amount" - xRec."Annual Amount",'');
             END;

    OnDelete=VAR
               ServLedgEntry@1000 : Record 5907;
             BEGIN
               IF NOT UserMgt.CheckRespCenter(2,"Responsibility Center") THEN
                 ERROR(
                   Text002,
                   RespCenter.TABLECAPTION,UserMgt.GetSalesFilter);

               IF "Contract Type" = "Contract Type"::Contract THEN BEGIN
                 MoveEntries.MoveServContractLedgerEntries(Rec);

                 IF Status = Status::Signed THEN
                   ERROR(Text003,FORMAT(Status),TABLECAPTION);

                 ServLedgEntry.SETRANGE(Type,ServLedgEntry.Type::"Service Contract");
                 ServLedgEntry.SETRANGE("No.","Contract No.");
                 ServLedgEntry.SETRANGE(Prepaid,FALSE);
                 ServLedgEntry.SETRANGE(Open,TRUE);
                 IF NOT ServLedgEntry.ISEMPTY THEN
                   IF NOT CONFIRM(
                        Text052,
                        FALSE,
                        ServLedgEntry.FIELDCAPTION(Open))
                   THEN
                     ERROR(Text053);
               END;
               ServContractLine.RESET;
               ServContractLine.SETRANGE("Contract Type","Contract Type");
               ServContractLine.SETRANGE("Contract No.","Contract No.");
               ServContractLine.DELETEALL;

               ServCommentLine.SETRANGE("Table Name",ServCommentLine."Table Name"::"Service Contract");
               ServCommentLine.SETRANGE("Table Subtype","Contract Type");
               ServCommentLine.SETRANGE("No.","Contract No.");
               ServCommentLine.DELETEALL;

               ServHour.RESET;
               CASE "Contract Type" OF
                 "Contract Type"::Quote:
                   ServHour.SETRANGE("Service Contract Type",ServHour."Service Contract Type"::Quote);
                 "Contract Type"::Contract:
                   ServHour.SETRANGE("Service Contract Type",ServHour."Service Contract Type"::Contract);
               END;
               ServHour.SETRANGE("Service Contract No.","Contract No.");
               ServHour.DELETEALL;

               FiledServContract.RESET;
               FiledServContract.SETCURRENTKEY("Contract Type Relation","Contract No. Relation");
               FiledServContract.SETRANGE("Contract Type Relation","Contract Type");
               FiledServContract.SETRANGE("Contract No. Relation","Contract No.");
               FiledServContract.DELETEALL(TRUE);
             END;

    OnRename=BEGIN
               ERROR(Text063,TABLECAPTION);
             END;

    CaptionML=[DAN=Servicekontrakthoved;
               ENU=Service Contract Header];
    LookupPageID=Page6051;
    DrillDownPageID=Page6051;
  }
  FIELDS
  {
    { 1   ;   ;Contract No.        ;Code20        ;OnValidate=BEGIN
                                                                IF "Contract No." <> xRec."Contract No." THEN BEGIN
                                                                  ServMgtSetup.GET;
                                                                  NoSeriesMgt.TestManual(ServMgtSetup."Service Contract Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Kontraktnr.;
                                                              ENU=Contract No.] }
    { 2   ;   ;Contract Type       ;Option        ;CaptionML=[DAN=Kontrakttype;
                                                              ENU=Contract Type];
                                                   OptionCaptionML=[DAN=Tilbud,Kontrakt;
                                                                    ENU=Quote,Contract];
                                                   OptionString=Quote,Contract }
    { 3   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Description 2       ;Text50        ;CaptionML=[DAN=Beskrivelse 2;
                                                              ENU=Description 2] }
    { 5   ;   ;Status              ;Option        ;OnValidate=VAR
                                                                ServLedgEntry@1001 : Record 5907;
                                                                AnyServItemInOtherContract@1000 : Boolean;
                                                              BEGIN
                                                                IF Status <> xRec.Status THEN BEGIN
                                                                  IF NOT SuspendChangeStatus THEN
                                                                    TESTFIELD("Change Status","Change Status"::Open);
                                                                  CASE "Contract Type" OF
                                                                    "Contract Type"::Contract:
                                                                      BEGIN
                                                                        IF Status <> Status::Canceled THEN
                                                                          ERROR(Text006,FIELDCAPTION(Status));

                                                                        CALCFIELDS("No. of Unposted Invoices","No. of Unposted Credit Memos");
                                                                        CASE TRUE OF
                                                                          ("No. of Unposted Invoices" <> 0) AND ("No. of Unposted Credit Memos" = 0):
                                                                            IF NOT CONFIRM(Text048) THEN BEGIN
                                                                              Status := xRec.Status;
                                                                              EXIT;
                                                                            END;
                                                                          ("No. of Unposted Invoices" = 0) AND ("No. of Unposted Credit Memos" <> 0):
                                                                            IF NOT CONFIRM(Text049) THEN BEGIN
                                                                              Status := xRec.Status;
                                                                              EXIT;
                                                                            END;
                                                                          ("No. of Unposted Invoices" <> 0) AND ("No. of Unposted Credit Memos" <> 0):
                                                                            IF NOT CONFIRM(Text055) THEN BEGIN
                                                                              Status := xRec.Status;
                                                                              EXIT;
                                                                            END;
                                                                        END;

                                                                        ServMgtSetup.GET;
                                                                        IF ServMgtSetup."Use Contract Cancel Reason" THEN
                                                                          TESTFIELD("Cancel Reason Code");

                                                                        ServLedgEntry.SETRANGE(Type,ServLedgEntry.Type::"Service Contract");
                                                                        ServLedgEntry.SETRANGE("No.","Contract No.");
                                                                        ServLedgEntry.SETRANGE("Moved from Prepaid Acc.",FALSE);
                                                                        ServLedgEntry.SETRANGE(Open,FALSE);
                                                                        ServLedgEntry.CALCSUMS("Amount (LCY)");
                                                                        IF ServLedgEntry."Amount (LCY)" <> 0 THEN
                                                                          StrToInsert := OpenPrepaymentEntriesExistTxt;
                                                                        IF NOT CONFIRM(CancelTheContractQst,FALSE,StrToInsert) THEN BEGIN
                                                                          Status := xRec.Status;
                                                                          EXIT;
                                                                        END;
                                                                        FiledServContract.FileContractBeforeCancellation(xRec);
                                                                      END;
                                                                    "Contract Type"::Quote:
                                                                      CASE Status OF
                                                                        Status::" ":
                                                                          IF xRec.Status = xRec.Status::Canceled THEN BEGIN
                                                                            ServContractLine.RESET;
                                                                            ServContractLine.SETRANGE("Contract Type","Contract Type");
                                                                            ServContractLine.SETRANGE("Contract No.","Contract No.");
                                                                            IF ServContractLine.FIND('-') THEN
                                                                              REPEAT
                                                                                ServContractLine2.RESET;
                                                                                ServContractLine2.SETCURRENTKEY("Service Item No.");
                                                                                ServContractLine2.SETRANGE("Service Item No.",ServContractLine."Service Item No.");
                                                                                ServContractLine2.SETRANGE("Contract Type","Contract Type"::Contract);
                                                                                IF ServContractLine2.FINDFIRST THEN BEGIN
                                                                                  AnyServItemInOtherContract := TRUE;
                                                                                  ServContractLine.MARK(TRUE);
                                                                                END;
                                                                              UNTIL ServContractLine.NEXT = 0;

                                                                            "Change Status" := "Change Status"::Open;

                                                                            IF AnyServItemInOtherContract THEN
                                                                              IF CONFIRM(Text062,TRUE,FORMAT(xRec.Status),FIELDCAPTION(Status)) THEN BEGIN
                                                                                ServContractLine.MARKEDONLY(TRUE);
                                                                                PAGE.RUNMODAL(PAGE::"Service Contract Line List",ServContractLine);
                                                                              END;
                                                                          END;
                                                                        Status::Signed:
                                                                          ERROR(
                                                                            Text009,
                                                                            FIELDCAPTION(Status),Status,FIELDCAPTION("Contract Type"),"Contract Type");
                                                                        Status::Canceled:
                                                                          IF NOT CONFIRM(STRSUBSTNO(
                                                                                 Text010,"Contract No."),FALSE)
                                                                          THEN BEGIN
                                                                            Status := xRec.Status;
                                                                            EXIT;
                                                                          END;
                                                                      END;
                                                                  END;
                                                                  IF Status = Status::Canceled THEN
                                                                    "Change Status" := "Change Status"::Locked;
                                                                  ServContractLine.RESET;
                                                                  ServContractLine.SETRANGE("Contract Type","Contract Type");
                                                                  ServContractLine.SETRANGE("Contract No.","Contract No.");
                                                                  ServContractLine.MODIFYALL("Contract Status",Status);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=" ,Underskrevet,Annulleret";
                                                                    ENU=" ,Signed,Canceled"];
                                                   OptionString=[ ,Signed,Canceled];
                                                   Editable=Yes }
    { 6   ;   ;Change Status       ;Option        ;CaptionML=[DAN=�ndringsstatus;
                                                              ENU=Change Status];
                                                   OptionCaptionML=[DAN=�ben,L�st;
                                                                    ENU=Open,Locked];
                                                   OptionString=Open,Locked;
                                                   Editable=No }
    { 7   ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   OnValidate=BEGIN
                                                                Cust.GET("Customer No.");
                                                                IF "Customer No." <> xRec."Customer No." THEN BEGIN
                                                                  IF ContractLinesExist THEN
                                                                    CASE "Contract Type" OF
                                                                      "Contract Type"::Contract:
                                                                        ERROR(Text011 + Text012,FIELDCAPTION("Customer No."));
                                                                      "Contract Type"::Quote:
                                                                        ERROR(Text011,FIELDCAPTION("Customer No."));
                                                                    END;
                                                                  VALIDATE("Ship-to Code",'');
                                                                END;

                                                                "Responsibility Center" := UserMgt.GetRespCenter(2,Cust."Responsibility Center");

                                                                IF "Customer No." <> '' THEN BEGIN
                                                                  IF Cust."Bill-to Customer No." = '' THEN BEGIN
                                                                    IF "Bill-to Customer No." = "Customer No." THEN
                                                                      SkipBillToContact := TRUE;
                                                                    VALIDATE("Bill-to Customer No.","Customer No.");
                                                                    SkipBillToContact := FALSE;
                                                                  END ELSE
                                                                    VALIDATE("Bill-to Customer No.",Cust."Bill-to Customer No.");
                                                                  IF NOT SkipContact THEN BEGIN
                                                                    "Contact Name" := Cust.Contact;
                                                                    "Phone No." := Cust."Phone No.";
                                                                    "E-Mail" := Cust."E-Mail";
                                                                  END;
                                                                  "Fax No." := Cust."Fax No.";
                                                                END ELSE BEGIN
                                                                  "Contact Name" := '';
                                                                  "Phone No." := '';
                                                                  "Fax No." := '';
                                                                  "E-Mail" := '';
                                                                  "Service Zone Code" := '';
                                                                END;

                                                                IF "Customer No." <> xRec."Customer No." THEN BEGIN
                                                                  CALCFIELDS(
                                                                    Name,"Name 2",Address,"Address 2",
                                                                    "Post Code",City,County,"Country/Region Code");
                                                                  CALCFIELDS(
                                                                    "Bill-to Name","Bill-to Name 2","Bill-to Address","Bill-to Address 2",
                                                                    "Bill-to Post Code","Bill-to City","Bill-to County","Bill-to Country/Region Code");
                                                                  UpdateShiptoCode;
                                                                END;

                                                                IF NOT SkipContact THEN
                                                                  UpdateCont("Customer No.");
                                                              END;

                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.];
                                                   NotBlank=Yes }
    { 8   ;   ;Name                ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.Name WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   Editable=No }
    { 9   ;   ;Address             ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.Address WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Adresse;
                                                              ENU=Address];
                                                   Editable=No }
    { 10  ;   ;Address 2           ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Address 2" WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2];
                                                   Editable=No }
    { 11  ;   ;Post Code           ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Post Code" WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code];
                                                   Editable=No }
    { 12  ;   ;City                ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.City WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=By;
                                                              ENU=City];
                                                   Editable=No }
    { 13  ;   ;Contact Name        ;Text50        ;CaptionML=[DAN=Kontaktnavn;
                                                              ENU=Contact Name] }
    { 14  ;   ;Your Reference      ;Text35        ;CaptionML=[DAN=Reference;
                                                              ENU=Your Reference] }
    { 15  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   OnValidate=BEGIN
                                                                ValidateSalesPersonOnServiceContractHeader(Rec,FALSE,FALSE);

                                                                CheckChangeStatus;
                                                                MODIFY;

                                                                CreateDim(
                                                                  DATABASE::"Salesperson/Purchaser","Salesperson Code",
                                                                  DATABASE::Customer,"Bill-to Customer No.",
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::"Service Contract Template","Template No.",
                                                                  DATABASE::"Service Order Type","Service Order Type");
                                                              END;

                                                   CaptionML=[DAN=S�lgerkode;
                                                              ENU=Salesperson Code] }
    { 16  ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   OnValidate=VAR
                                                                CustCheckCrLimit@1000 : Codeunit 312;
                                                              BEGIN
                                                                CheckChangeStatus;
                                                                IF xRec."Bill-to Customer No." <> "Bill-to Customer No." THEN
                                                                  IF xRec."Bill-to Customer No." <> '' THEN BEGIN
                                                                    IF HideValidationDialog THEN
                                                                      Confirmed := TRUE
                                                                    ELSE
                                                                      Confirmed := CONFIRM(Text014,FALSE,FIELDCAPTION("Bill-to Customer No."));
                                                                  END ELSE
                                                                    Confirmed := TRUE;

                                                                IF Confirmed THEN BEGIN
                                                                  IF "Bill-to Customer No." <> xRec."Bill-to Customer No." THEN
                                                                    IF "Bill-to Customer No." <> '' THEN BEGIN
                                                                      Cust.GET("Bill-to Customer No.");
                                                                      IF Cust."Privacy Blocked" THEN
                                                                        Cust.CustPrivacyBlockedErrorMessage(Cust,FALSE);
                                                                      IF Cust.Blocked = Cust.Blocked::All THEN
                                                                        Cust.CustBlockedErrorMessage(Cust,FALSE);
                                                                    END;

                                                                  IF "Customer No." <> '' THEN BEGIN
                                                                    Cust.GET("Customer No.");
                                                                    IF Cust."Bill-to Customer No." <> '' THEN
                                                                      IF "Bill-to Customer No." = '' THEN
                                                                        "Bill-to Customer No." := Cust."Bill-to Customer No.";
                                                                  END;
                                                                  IF "Bill-to Customer No." = '' THEN
                                                                    "Bill-to Customer No." := "Customer No.";
                                                                  IF Cust.GET("Bill-to Customer No.") THEN BEGIN
                                                                    "Currency Code" := Cust."Currency Code";
                                                                    "Payment Terms Code" := Cust."Payment Terms Code";
                                                                    "Language Code" := Cust."Language Code";
                                                                    SetSalespersonCode(Cust."Salesperson Code","Salesperson Code");
                                                                    IF NOT SkipBillToContact THEN
                                                                      "Bill-to Contact" := Cust.Contact;
                                                                  END;

                                                                  IF NOT HideValidationDialog THEN
                                                                    CustCheckCrLimit.ServiceContractHeaderCheck(Rec);

                                                                  CALCFIELDS(
                                                                    "Bill-to Name","Bill-to Name 2","Bill-to Address","Bill-to Address 2",
                                                                    "Bill-to Post Code","Bill-to City","Bill-to County","Bill-to Country/Region Code");

                                                                  IF NOT SkipBillToContact THEN
                                                                    UpdateBillToCont("Bill-to Customer No.");
                                                                END ELSE
                                                                  "Bill-to Customer No." := xRec."Bill-to Customer No.";

                                                                CreateDim(
                                                                  DATABASE::Customer,"Bill-to Customer No.",
                                                                  DATABASE::"Salesperson/Purchaser","Salesperson Code",
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::"Service Contract Template","Template No.",
                                                                  DATABASE::"Service Order Type","Service Order Type");
                                                              END;

                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.] }
    { 17  ;   ;Bill-to Name        ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.Name WHERE (No.=FIELD(Bill-to Customer No.)));
                                                   CaptionML=[DAN=Faktureringsnavn;
                                                              ENU=Bill-to Name];
                                                   Editable=No }
    { 18  ;   ;Bill-to Address     ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.Address WHERE (No.=FIELD(Bill-to Customer No.)));
                                                   CaptionML=[DAN=Faktureringsadresse;
                                                              ENU=Bill-to Address];
                                                   Editable=No }
    { 19  ;   ;Bill-to Address 2   ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Address 2" WHERE (No.=FIELD(Bill-to Customer No.)));
                                                   CaptionML=[DAN=Faktureringsadresse 2;
                                                              ENU=Bill-to Address 2];
                                                   Editable=No }
    { 20  ;   ;Bill-to Post Code   ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Post Code" WHERE (No.=FIELD(Bill-to Customer No.)));
                                                   CaptionML=[DAN=Faktureringspostnr.;
                                                              ENU=Bill-to Post Code];
                                                   Editable=No }
    { 21  ;   ;Bill-to City        ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.City WHERE (No.=FIELD(Bill-to Customer No.)));
                                                   CaptionML=[DAN=Faktureringsby;
                                                              ENU=Bill-to City];
                                                   Editable=No }
    { 22  ;   ;Ship-to Code        ;Code10        ;TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(Customer No.));
                                                   OnValidate=BEGIN
                                                                IF ("Customer No." <> xRec."Customer No.") OR
                                                                   ("Ship-to Code" <> xRec."Ship-to Code")
                                                                THEN BEGIN
                                                                  IF ContractLinesExist THEN
                                                                    ERROR(Text011,FIELDCAPTION("Ship-to Code"));
                                                                  UpdateServZone;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Leveringsadressekode;
                                                              ENU=Ship-to Code] }
    { 23  ;   ;Ship-to Name        ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address".Name WHERE (Customer No.=FIELD(Customer No.),
                                                                                                    Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringsnavn;
                                                              ENU=Ship-to Name];
                                                   Editable=No }
    { 24  ;   ;Ship-to Address     ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address".Address WHERE (Customer No.=FIELD(Customer No.),
                                                                                                       Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringsadresse;
                                                              ENU=Ship-to Address];
                                                   Editable=No }
    { 25  ;   ;Ship-to Address 2   ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address"."Address 2" WHERE (Customer No.=FIELD(Customer No.),
                                                                                                           Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringsadresse 2;
                                                              ENU=Ship-to Address 2];
                                                   Editable=No }
    { 26  ;   ;Ship-to Post Code   ;Code20        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address"."Post Code" WHERE (Customer No.=FIELD(Customer No.),
                                                                                                           Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringspostnr.;
                                                              ENU=Ship-to Post Code];
                                                   Editable=No }
    { 27  ;   ;Ship-to City        ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address".City WHERE (Customer No.=FIELD(Customer No.),
                                                                                                    Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringsby;
                                                              ENU=Ship-to City];
                                                   Editable=No }
    { 28  ;   ;Serv. Contract Acc. Gr. Code;Code10;TableRelation="Service Contract Account Group";
                                                   CaptionML=[DAN=Servicekontraktkto.grp.kode;
                                                              ENU=Serv. Contract Acc. Gr. Code] }
    { 32  ;   ;Invoice Period      ;Option        ;OnValidate=BEGIN
                                                                CalcInvPeriodDuration;
                                                                IF (FORMAT("Price Update Period") <> '') AND
                                                                   (CALCDATE("Price Update Period","Starting Date") < CALCDATE(InvPeriodDuration,"Starting Date"))
                                                                THEN
                                                                  ERROR(Text065,FIELDCAPTION("Invoice Period"),FIELDCAPTION("Price Update Period"));

                                                                TESTFIELD("Change Status","Change Status"::Open);
                                                                IF ("Invoice Period" = "Invoice Period"::None) AND
                                                                   ("Last Invoice Date" <> 0D)
                                                                THEN
                                                                  ERROR(Text041,
                                                                    FIELDCAPTION("Invoice Period"),
                                                                    FORMAT("Invoice Period"),
                                                                    TABLECAPTION);

                                                                IF "Invoice Period" = "Invoice Period"::None THEN BEGIN
                                                                  "Amount per Period" := 0;
                                                                  "Next Invoice Date" := 0D;
                                                                  "Next Invoice Period Start" := 0D;
                                                                  "Next Invoice Period End" := 0D;
                                                                END ELSE
                                                                  IF Prepaid THEN BEGIN
                                                                    IF "Next Invoice Date" = 0D THEN BEGIN
                                                                      IF "Last Invoice Date" = 0D THEN BEGIN
                                                                        TESTFIELD("Starting Date");
                                                                        IF "Starting Date" = CALCDATE('<-CM>',"Starting Date") THEN
                                                                          VALIDATE("Next Invoice Date","Starting Date")
                                                                        ELSE
                                                                          VALIDATE("Next Invoice Date",CALCDATE('<-CM+1M>',"Starting Date"));
                                                                      END ELSE
                                                                        IF "Last Invoice Date" = CALCDATE('<-CM>',"Last Invoice Date") THEN
                                                                          VALIDATE("Next Invoice Date",CALCDATE('<CM+1D>',"Last Invoice Period End"))
                                                                        ELSE
                                                                          VALIDATE("Next Invoice Date",CALCDATE('<-CM+1M>',"Last Invoice Date"));
                                                                    END ELSE
                                                                      VALIDATE("Next Invoice Date");
                                                                  END ELSE
                                                                    VALIDATE("Last Invoice Date");
                                                              END;

                                                   CaptionML=[DAN=Faktureringsperiode;
                                                              ENU=Invoice Period];
                                                   OptionCaptionML=[DAN=M�ned,To m�neder,Kvartal,Halv�r,�r,Ingen;
                                                                    ENU=Month,Two Months,Quarter,Half Year,Year,None];
                                                   OptionString=Month,Two Months,Quarter,Half Year,Year,None }
    { 33  ;   ;Last Invoice Date   ;Date          ;OnValidate=BEGIN
                                                                TESTFIELD("Starting Date");
                                                                IF "Last Invoice Date" = 0D THEN
                                                                  IF Prepaid THEN
                                                                    TempDate := CALCDATE('<-1D-CM>',"Starting Date")
                                                                  ELSE
                                                                    TempDate := CALCDATE('<-1D+CM>',"Starting Date")
                                                                ELSE
                                                                  TempDate := "Last Invoice Date";
                                                                CASE "Invoice Period" OF
                                                                  "Invoice Period"::Month:
                                                                    "Next Invoice Date" := CALCDATE('<1M>',TempDate);
                                                                  "Invoice Period"::"Two Months":
                                                                    "Next Invoice Date" := CALCDATE('<2M>',TempDate);
                                                                  "Invoice Period"::Quarter:
                                                                    "Next Invoice Date" := CALCDATE('<3M>',TempDate);
                                                                  "Invoice Period"::"Half Year":
                                                                    "Next Invoice Date" := CALCDATE('<6M>',TempDate);
                                                                  "Invoice Period"::Year:
                                                                    "Next Invoice Date" := CALCDATE('<12M>',TempDate);
                                                                  "Invoice Period"::None:
                                                                    IF Prepaid THEN
                                                                      "Next Invoice Date" := 0D;
                                                                END;
                                                                IF NOT Prepaid AND ("Next Invoice Date" <> 0D) THEN
                                                                  "Next Invoice Date" := CALCDATE('<CM>',"Next Invoice Date");

                                                                IF ("Last Invoice Date" <> 0D) AND ("Last Invoice Date" <> xRec."Last Invoice Date") THEN
                                                                  IF Prepaid THEN
                                                                    VALIDATE("Last Invoice Period End","Next Invoice Period End")
                                                                  ELSE
                                                                    VALIDATE("Last Invoice Period End","Last Invoice Date");

                                                                VALIDATE("Next Invoice Date");
                                                              END;

                                                   CaptionML=[DAN=Sidste faktureringsdato;
                                                              ENU=Last Invoice Date];
                                                   Editable=No }
    { 34  ;   ;Next Invoice Date   ;Date          ;OnValidate=VAR
                                                                ServLedgEntry@1000 : Record 5907;
                                                              BEGIN
                                                                IF "Next Invoice Date" = 0D THEN BEGIN
                                                                  "Next Invoice Period Start" := 0D;
                                                                  "Next Invoice Period End" := 0D;
                                                                  EXIT;
                                                                END;
                                                                IF "Last Invoice Date" <> 0D THEN
                                                                  IF "Last Invoice Date" > "Next Invoice Date" THEN BEGIN
                                                                    ServLedgEntry.SETRANGE(Type,ServLedgEntry.Type::"Service Contract");
                                                                    ServLedgEntry.SETRANGE("No.","Contract No.");
                                                                    IF NOT ServLedgEntry.ISEMPTY THEN
                                                                      ERROR(Text023,FIELDCAPTION("Next Invoice Date"),FIELDCAPTION("Last Invoice Date"));
                                                                    "Last Invoice Date" := 0D;
                                                                  END;

                                                                IF "Next Invoice Date" < "Starting Date" THEN
                                                                  ERROR(Text024,FIELDCAPTION("Next Invoice Date"),FIELDCAPTION("Starting Date"));

                                                                IF Prepaid THEN BEGIN
                                                                  IF "Next Invoice Date" <> CALCDATE('<-CM>',"Next Invoice Date") THEN
                                                                    ERROR(Text026,FIELDCAPTION("Next Invoice Date"));
                                                                  TempDate := CalculateEndPeriodDate(TRUE,"Next Invoice Date");
                                                                  IF "Expiration Date" <> 0D THEN
                                                                    IF "Next Invoice Date" > "Expiration Date" THEN
                                                                      "Next Invoice Date" := 0D
                                                                    ELSE
                                                                      IF TempDate > "Expiration Date" THEN
                                                                        TempDate := "Expiration Date";
                                                                  IF ("Next Invoice Date" <> 0D) AND (TempDate <> 0D) THEN BEGIN
                                                                    "Next Invoice Period Start" := "Next Invoice Date";
                                                                    "Next Invoice Period End" := TempDate;
                                                                  END ELSE BEGIN
                                                                    "Next Invoice Period Start" := 0D;
                                                                    "Next Invoice Period End" := 0D;
                                                                  END;
                                                                END ELSE BEGIN
                                                                  IF "Next Invoice Date" <> CALCDATE('<CM>',"Next Invoice Date") THEN
                                                                    ERROR(Text028,FIELDCAPTION("Next Invoice Date"));
                                                                  TempDate := CalculateEndPeriodDate(FALSE,"Next Invoice Date");
                                                                  IF TempDate < "Starting Date" THEN
                                                                    TempDate := "Starting Date";

                                                                  IF "Expiration Date" <> 0D THEN
                                                                    IF "Expiration Date" < TempDate THEN
                                                                      "Next Invoice Date" := 0D
                                                                    ELSE
                                                                      IF "Expiration Date" < "Next Invoice Date" THEN
                                                                        "Next Invoice Date" := "Expiration Date";

                                                                  IF ("Next Invoice Date" <> 0D) AND (TempDate <> 0D) THEN BEGIN
                                                                    "Next Invoice Period Start" := TempDate;
                                                                    "Next Invoice Period End" := "Next Invoice Date";
                                                                  END ELSE BEGIN
                                                                    "Next Invoice Period Start" := 0D;
                                                                    "Next Invoice Period End" := 0D;
                                                                  END;
                                                                END;

                                                                ValidateNextInvoicePeriod;
                                                              END;

                                                   CaptionML=[DAN=N�ste faktureringsdato;
                                                              ENU=Next Invoice Date];
                                                   Editable=No }
    { 35  ;   ;Starting Date       ;Date          ;OnValidate=BEGIN
                                                                CheckChangeStatus;

                                                                IF "Last Invoice Date" <> 0D THEN
                                                                  ERROR(
                                                                    Text029,
                                                                    FIELDCAPTION("Starting Date"),FORMAT("Contract Type"));
                                                                IF "Starting Date" = 0D THEN BEGIN
                                                                  VALIDATE("Next Invoice Date",0D);
                                                                  "First Service Date" := 0D;
                                                                  ServContractLine.RESET;
                                                                  ServContractLine.SETRANGE("Contract Type","Contract Type");
                                                                  ServContractLine.SETRANGE("Contract No.","Contract No.");
                                                                  ServContractLine.SETRANGE("New Line",TRUE);
                                                                  IF ServContractLine.FIND('-') THEN BEGIN
                                                                    REPEAT
                                                                      ServContractLine."Starting Date" := 0D;
                                                                      ServContractLine."Next Planned Service Date" := 0D;
                                                                      ServContractLine.MODIFY;
                                                                    UNTIL ServContractLine.NEXT = 0;
                                                                    MODIFY(TRUE);
                                                                  END;
                                                                END ELSE BEGIN
                                                                  IF "Starting Date" > "First Service Date" THEN
                                                                    "First Service Date" := "Starting Date";
                                                                  ServContractLine.RESET;
                                                                  ServContractLine.SETRANGE("Contract Type","Contract Type");
                                                                  ServContractLine.SETRANGE("Contract No.","Contract No.");
                                                                  ServContractLine.SETRANGE("New Line",TRUE);
                                                                  IF ServContractLine.FIND('-') THEN BEGIN
                                                                    REPEAT
                                                                      ServContractLine.SuspendStatusCheck(TRUE);
                                                                      ServContractLine."Starting Date" := "Starting Date";
                                                                      ServContractLine."Next Planned Service Date" := "First Service Date";
                                                                      ServContractLine.MODIFY;
                                                                    UNTIL ServContractLine.NEXT = 0;
                                                                    MODIFY(TRUE);
                                                                  END;
                                                                  IF "Next Price Update Date" = 0D THEN
                                                                    "Next Price Update Date" := CALCDATE("Price Update Period","Starting Date");
                                                                  IF "Invoice Period" <> "Invoice Period"::None THEN
                                                                    IF Prepaid THEN BEGIN
                                                                      IF "Starting Date" = CALCDATE('<-CM>',"Starting Date") THEN
                                                                        VALIDATE("Next Invoice Date","Starting Date")
                                                                      ELSE
                                                                        VALIDATE("Next Invoice Date",CALCDATE('<-CM+1M>',"Starting Date"))
                                                                    END ELSE
                                                                      VALIDATE("Last Invoice Date");
                                                                  VALIDATE("Service Period");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 36  ;   ;Expiration Date     ;Date          ;OnValidate=BEGIN
                                                                CheckChangeStatus;

                                                                IF "Expiration Date" <> xRec."Expiration Date" THEN BEGIN
                                                                  IF "Expiration Date" <> 0D THEN BEGIN
                                                                    IF "Expiration Date" < "Starting Date" THEN
                                                                      ERROR(Text023,FIELDCAPTION("Expiration Date"),FIELDCAPTION("Starting Date"));
                                                                    IF "Last Invoice Date" <> 0D THEN
                                                                      IF "Expiration Date" < "Last Invoice Date" THEN
                                                                        ERROR(
                                                                          Text023,FIELDCAPTION("Expiration Date"),FIELDCAPTION("Last Invoice Date"));
                                                                  END;

                                                                  ServContractLine.RESET;
                                                                  ServContractLine.SETRANGE("Contract Type","Contract Type");
                                                                  ServContractLine.SETRANGE("Contract No.","Contract No.");
                                                                  ServContractLine.SETRANGE(Credited,FALSE);

                                                                  IF ("Expiration Date" <> 0D) OR
                                                                     ("Contract Type" = "Contract Type"::Quote)
                                                                  THEN BEGIN
                                                                    IF "Contract Type" = "Contract Type"::Contract THEN BEGIN
                                                                      ServContractLine.SETFILTER("Contract Expiration Date",'>%1',"Expiration Date");
                                                                      IF ServContractLine.FIND('-') THEN
                                                                        IF NOT CONFIRM(
                                                                             Text056,
                                                                             TRUE,
                                                                             FIELDCAPTION("Expiration Date"),
                                                                             TABLECAPTION,
                                                                             "Expiration Date")
                                                                        THEN
                                                                          ERROR('');
                                                                      ServContractLine.SETFILTER("Contract Expiration Date",'>%1 | %2',"Expiration Date",0D);
                                                                    END;

                                                                    IF ServContractLine.FIND('-') THEN BEGIN
                                                                      REPEAT
                                                                        ServContractLine."Contract Expiration Date" := "Expiration Date";
                                                                        ServContractLine."Credit Memo Date" := "Expiration Date";
                                                                        ServContractLine.MODIFY;
                                                                      UNTIL ServContractLine.NEXT = 0;
                                                                      MODIFY(TRUE);
                                                                    END;
                                                                  END;
                                                                  VALIDATE("Invoice Period");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Udl�bsdato;
                                                              ENU=Expiration Date] }
    { 38  ;   ;First Service Date  ;Date          ;OnValidate=BEGIN
                                                                IF "First Service Date" <> xRec."First Service Date" THEN BEGIN
                                                                  IF ("Contract Type" = "Contract Type"::Contract) AND
                                                                     (Status = Status::Signed)
                                                                  THEN
                                                                    ERROR(
                                                                      Text030,
                                                                      FIELDCAPTION("First Service Date"));

                                                                  IF "First Service Date" < "Starting Date" THEN
                                                                    ERROR(
                                                                      Text023,
                                                                      FIELDCAPTION("First Service Date"),
                                                                      FIELDCAPTION("Starting Date"));

                                                                  IF "Contract Type" = "Contract Type"::Quote THEN BEGIN
                                                                    IF ContractLinesExist THEN
                                                                      MESSAGE(
                                                                        Text031,FIELDCAPTION("First Service Date"));
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=F�rste servicedato;
                                                              ENU=First Service Date] }
    { 39  ;   ;Max. Labor Unit Price;Decimal      ;CaptionML=[DAN=Maks. arbejdsenhedspris;
                                                              ENU=Max. Labor Unit Price];
                                                   BlankZero=Yes;
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 40  ;   ;Calcd. Annual Amount;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Contract Line"."Line Amount" WHERE (Contract Type=FIELD(Contract Type),
                                                                                                                Contract No.=FIELD(Contract No.)));
                                                   CaptionML=[DAN=Beregnet �rligt bel�b;
                                                              ENU=Calcd. Annual Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 42  ;   ;Annual Amount       ;Decimal       ;OnValidate=BEGIN
                                                                TESTFIELD("Change Status","Change Status"::Open);
                                                                ServMgtSetup.GET;
                                                                DistributeAmounts;
                                                                VALIDATE("Invoice Period");
                                                              END;

                                                   CaptionML=[DAN=�rligt bel�b;
                                                              ENU=Annual Amount];
                                                   MinValue=0;
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 43  ;   ;Amount per Period   ;Decimal       ;CaptionML=[DAN=Periodebel�b;
                                                              ENU=Amount per Period];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 44  ;   ;Combine Invoices    ;Boolean       ;CaptionML=[DAN=Kombiner fakturaer;
                                                              ENU=Combine Invoices] }
    { 45  ;   ;Prepaid             ;Boolean       ;OnValidate=VAR
                                                                ServLedgEntry@1000 : Record 5907;
                                                              BEGIN
                                                                IF Prepaid <> xRec.Prepaid THEN BEGIN
                                                                  IF "Contract Type" = "Contract Type"::Contract THEN BEGIN
                                                                    ServLedgEntry.SETCURRENTKEY("Service Contract No.");
                                                                    ServLedgEntry.SETRANGE("Service Contract No.","Contract No.");
                                                                    IF NOT ServLedgEntry.ISEMPTY THEN
                                                                      ERROR(
                                                                        Text032,
                                                                        FIELDCAPTION(Prepaid),TABLECAPTION,"Contract No.");
                                                                  END;
                                                                  TESTFIELD("Starting Date");
                                                                  IF Prepaid THEN BEGIN
                                                                    IF "Invoice after Service" THEN
                                                                      ERROR(
                                                                        Text057,
                                                                        FIELDCAPTION("Invoice after Service"),
                                                                        FIELDCAPTION(Prepaid));
                                                                    IF "Invoice Period" = "Invoice Period"::None THEN
                                                                      VALIDATE("Next Invoice Date",0D)
                                                                    ELSE
                                                                      IF "Starting Date" = CALCDATE('<-CM>',"Starting Date") THEN
                                                                        VALIDATE("Next Invoice Date","Starting Date")
                                                                      ELSE
                                                                        VALIDATE("Next Invoice Date",CALCDATE('<-CM+1M>',"Starting Date"));
                                                                  END ELSE
                                                                    VALIDATE("Last Invoice Date");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Forudbetalt;
                                                              ENU=Prepaid] }
    { 46  ;   ;Next Invoice Period ;Text30        ;CaptionML=[DAN=N�ste faktureringsperiode;
                                                              ENU=Next Invoice Period];
                                                   Editable=No }
    { 47  ;   ;Service Zone Code   ;Code10        ;TableRelation="Service Zone";
                                                   CaptionML=[DAN=Servicezonekode;
                                                              ENU=Service Zone Code] }
    { 48  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 50  ;   ;Cancel Reason Code  ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=Annullerings�rsagskode;
                                                              ENU=Cancel Reason Code] }
    { 51  ;   ;Last Price Update Date;Date        ;CaptionML=[DAN=Dato for sidste prisregulering;
                                                              ENU=Last Price Update Date];
                                                   Editable=No }
    { 52  ;   ;Next Price Update Date;Date        ;OnValidate=BEGIN
                                                                IF "Next Price Update Date" < "Next Invoice Date" THEN
                                                                  ERROR(Text064,FIELDCAPTION("Next Price Update Date"),FIELDCAPTION("Next Invoice Date"));
                                                              END;

                                                   CaptionML=[DAN=Dato for n�ste prisregulering;
                                                              ENU=Next Price Update Date] }
    { 53  ;   ;Last Price Update % ;Decimal       ;CaptionML=[DAN=N�ste prisreguleringspct.;
                                                              ENU=Last Price Update %];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 55  ;   ;Response Time (Hours);Decimal      ;OnValidate=BEGIN
                                                                CheckChangeStatus;

                                                                IF "Response Time (Hours)" <> xRec."Response Time (Hours)" THEN BEGIN
                                                                  ServContractLine.RESET;
                                                                  ServContractLine.SETRANGE("Contract Type","Contract Type");
                                                                  ServContractLine.SETRANGE("Contract No.","Contract No.");
                                                                  ServContractLine.SETFILTER("Response Time (Hours)",'>%1',"Response Time (Hours)");
                                                                  IF ServContractLine.FIND('-') THEN
                                                                    IF CONFIRM(
                                                                         Text034,
                                                                         TRUE,
                                                                         FIELDCAPTION("Response Time (Hours)"))
                                                                    THEN
                                                                      ServContractLine.MODIFYALL("Response Time (Hours)","Response Time (Hours)",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Svartid (timer);
                                                              ENU=Response Time (Hours)];
                                                   DecimalPlaces=0:5;
                                                   BlankZero=Yes }
    { 56  ;   ;Contract Lines on Invoice;Boolean  ;CaptionML=[DAN=Kontraktlinjer p� faktura;
                                                              ENU=Contract Lines on Invoice] }
    { 57  ;   ;No. of Posted Invoices;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Service Document Register" WHERE (Source Document Type=CONST(Contract),
                                                                                                        Source Document No.=FIELD(Contract No.),
                                                                                                        Destination Document Type=CONST(Posted Invoice)));
                                                   CaptionML=[DAN=Antal bogf�rte fakturaer;
                                                              ENU=No. of Posted Invoices];
                                                   Editable=No }
    { 58  ;   ;No. of Unposted Invoices;Integer   ;FieldClass=FlowField;
                                                   CalcFormula=Count("Service Document Register" WHERE (Source Document Type=CONST(Contract),
                                                                                                        Source Document No.=FIELD(Contract No.),
                                                                                                        Destination Document Type=CONST(Invoice)));
                                                   CaptionML=[DAN=Antal ikkebogf�rte fakturaer;
                                                              ENU=No. of Unposted Invoices];
                                                   Editable=No }
    { 59  ;   ;Service Period      ;DateFormula   ;OnValidate=BEGIN
                                                                IF "Service Period" <> xRec."Service Period" THEN BEGIN
                                                                  IF ("Contract Type" = "Contract Type"::Contract) AND
                                                                     (Status = Status::Signed)
                                                                  THEN
                                                                    ERROR(
                                                                      Text030,
                                                                      FIELDCAPTION("Service Period"));
                                                                  IF "Contract Type" = "Contract Type"::Quote THEN BEGIN
                                                                    IF ContractLinesExist THEN
                                                                      MESSAGE(
                                                                        Text031,
                                                                        FIELDCAPTION("Service Period"));
                                                                  END;
                                                                  IF ContractLinesExist AND (FORMAT("Service Period") <> '') THEN BEGIN
                                                                    ServContractLine.RESET;
                                                                    ServContractLine.SETRANGE("Contract Type","Contract Type");
                                                                    ServContractLine.SETRANGE("Contract No.","Contract No.");
                                                                    IF ServContractLine.FIND('-') THEN
                                                                      REPEAT
                                                                        IF (FORMAT(ServContractLine."Service Period") = '') OR
                                                                           (ServContractLine."Service Period" = xRec."Service Period")
                                                                        THEN BEGIN
                                                                          ServContractLine."Service Period" := "Service Period";
                                                                          ServContractLine.MODIFY;
                                                                        END;
                                                                      UNTIL ServContractLine.NEXT = 0;
                                                                  END;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Serviceperiode;
                                                              ENU=Service Period] }
    { 60  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   CaptionML=[DAN=Betalingsbeting.kode;
                                                              ENU=Payment Terms Code] }
    { 62  ;   ;Invoice after Service;Boolean      ;OnValidate=BEGIN
                                                                IF NOT ServHeader.READPERMISSION AND
                                                                   "Invoice after Service" = TRUE
                                                                THEN
                                                                  ERROR(Text054);
                                                                IF "Invoice after Service" AND
                                                                   Prepaid
                                                                THEN
                                                                  ERROR(
                                                                    Text057,
                                                                    FIELDCAPTION("Invoice after Service"),
                                                                    FIELDCAPTION(Prepaid));
                                                              END;

                                                   CaptionML=[DAN=Faktura efter endt service;
                                                              ENU=Invoice after Service] }
    { 63  ;   ;Quote Type          ;Option        ;CaptionML=[DAN=Tilbudstype;
                                                              ENU=Quote Type];
                                                   OptionCaptionML=[DAN=Tilbud 1,Tilbud 2,Tilbud 3,Tilbud 4,Tilbud 5,Tilbud 6,Tilbud 7,Tilbud 8;
                                                                    ENU=Quote 1,Quote 2,Quote 3,Quote 4,Quote 5,Quote 6,Quote 7,Quote 8];
                                                   OptionString=Quote 1,Quote 2,Quote 3,Quote 4,Quote 5,Quote 6,Quote 7,Quote 8 }
    { 64  ;   ;Allow Unbalanced Amounts;Boolean   ;OnValidate=BEGIN
                                                                TESTFIELD("Change Status","Change Status"::Open);
                                                                ServMgtSetup.GET;
                                                                IF "Allow Unbalanced Amounts" <> xRec."Allow Unbalanced Amounts" THEN
                                                                  DistributeAmounts;
                                                              END;

                                                   CaptionML=[DAN=Tillad bel�b, der ikke stemmer;
                                                              ENU=Allow Unbalanced Amounts] }
    { 65  ;   ;Contract Group Code ;Code10        ;TableRelation="Contract Group";
                                                   CaptionML=[DAN=Kontraktgruppekode;
                                                              ENU=Contract Group Code] }
    { 66  ;   ;Service Order Type  ;Code10        ;TableRelation="Service Order Type";
                                                   OnValidate=BEGIN
                                                                CreateDim(
                                                                  DATABASE::"Service Order Type","Service Order Type",
                                                                  DATABASE::Customer,"Bill-to Customer No.",
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::"Service Contract Template","Template No.",
                                                                  DATABASE::"Salesperson/Purchaser","Salesperson Code");
                                                              END;

                                                   CaptionML=[DAN=Serviceordretype;
                                                              ENU=Service Order Type] }
    { 67  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                CheckChangeStatus;
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 68  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                CheckChangeStatus;
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 69  ;   ;Accept Before       ;Date          ;CaptionML=[DAN=Accept f�r;
                                                              ENU=Accept Before] }
    { 71  ;   ;Automatic Credit Memos;Boolean     ;CaptionML=[DAN=Kreditnotaer automatisk;
                                                              ENU=Automatic Credit Memos] }
    { 74  ;   ;Template No.        ;Code20        ;OnValidate=BEGIN
                                                                CreateDim(
                                                                  DATABASE::Customer,"Bill-to Customer No.",
                                                                  DATABASE::"Salesperson/Purchaser","Salesperson Code",
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::"Service Contract Template","Template No.",
                                                                  DATABASE::"Service Order Type","Service Order Type");
                                                              END;

                                                   CaptionML=[DAN=Skabelonnr.;
                                                              ENU=Template No.] }
    { 75  ;   ;Price Update Period ;DateFormula   ;InitValue=1Y;
                                                   OnValidate=BEGIN
                                                                CalcInvPeriodDuration;
                                                                IF (FORMAT("Price Update Period") <> '') AND
                                                                   (CALCDATE("Price Update Period","Starting Date") < CALCDATE(InvPeriodDuration,"Starting Date"))
                                                                THEN
                                                                  ERROR(Text064,FIELDCAPTION("Price Update Period"),FIELDCAPTION("Invoice Period"));

                                                                IF FORMAT("Price Update Period") <> '' THEN
                                                                  IF "Last Price Update Date" <> 0D THEN
                                                                    "Next Price Update Date" := CALCDATE("Price Update Period","Last Price Update Date")
                                                                  ELSE
                                                                    "Next Price Update Date" := CALCDATE("Price Update Period","Starting Date")
                                                                ELSE
                                                                  "Next Price Update Date" := 0D;
                                                              END;

                                                   CaptionML=[DAN=Prisreguleringsperiode;
                                                              ENU=Price Update Period] }
    { 79  ;   ;Price Inv. Increase Code;Code20    ;TableRelation="Standard Text";
                                                   CaptionML=[DAN=Prisforh�jelseskode;
                                                              ENU=Price Inv. Increase Code] }
    { 80  ;   ;Print Increase Text ;Boolean       ;CaptionML=[DAN=Udskriv prisforh�jelsestekst;
                                                              ENU=Print Increase Text] }
    { 81  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                MESSAGE(Text042,FIELDCAPTION("Currency Code"));
                                                              END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 82  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 83  ;   ;Probability         ;Decimal       ;InitValue=100;
                                                   CaptionML=[DAN=Sandsynlighed;
                                                              ENU=Probability];
                                                   DecimalPlaces=0:5 }
    { 84  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Service Comment Line" WHERE (Table Name=CONST(Service Contract),
                                                                                                   Table Subtype=FIELD(Contract Type),
                                                                                                   No.=FIELD(Contract No.),
                                                                                                   Table Line No.=FILTER(0)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 85  ;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   OnValidate=BEGIN
                                                                IF NOT UserMgt.CheckRespCenter(2,"Responsibility Center") THEN
                                                                  ERROR(
                                                                    Text040,
                                                                    RespCenter.TABLECAPTION,UserMgt.GetSalesFilter);

                                                                CreateDim(
                                                                  DATABASE::"Salesperson/Purchaser","Salesperson Code",
                                                                  DATABASE::Customer,"Bill-to Customer No.",
                                                                  DATABASE::"Responsibility Center","Responsibility Center",
                                                                  DATABASE::"Service Contract Template","Template No.",
                                                                  DATABASE::"Service Order Type","Service Order Type");
                                                              END;

                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 86  ;   ;Phone No.           ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.] }
    { 87  ;   ;Fax No.             ;Text30        ;CaptionML=[DAN=Telefax;
                                                              ENU=Fax No.] }
    { 88  ;   ;E-Mail              ;Text80        ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                MailManagement.ValidateEmailAddressField("E-Mail");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Mail;
                                                              ENU=Email] }
    { 89  ;   ;Bill-to County      ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.County WHERE (No.=FIELD(Bill-to Customer No.)));
                                                   CaptionML=[DAN=Faktureringsamt;
                                                              ENU=Bill-to County];
                                                   Editable=No }
    { 90  ;   ;County              ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer.County WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Amt;
                                                              ENU=County];
                                                   Editable=No }
    { 91  ;   ;Ship-to County      ;Text30        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address".County WHERE (Customer No.=FIELD(Customer No.),
                                                                                                      Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringsamt;
                                                              ENU=Ship-to County];
                                                   Editable=No }
    { 92  ;   ;Country/Region Code ;Code10        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Country/Region Code" WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code];
                                                   Editable=No }
    { 93  ;   ;Bill-to Country/Region Code;Code10 ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Country/Region Code" WHERE (No.=FIELD(Bill-to Customer No.)));
                                                   CaptionML=[DAN=Lande-/omr�dekode til fakturering;
                                                              ENU=Bill-to Country/Region Code];
                                                   Editable=No }
    { 94  ;   ;Ship-to Country/Region Code;Code10 ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address"."Country/Region Code" WHERE (Customer No.=FIELD(Customer No.),
                                                                                                                     Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Lande-/omr�dekode for levering;
                                                              ENU=Ship-to Country/Region Code];
                                                   Editable=No }
    { 95  ;   ;Name 2              ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Name 2" WHERE (No.=FIELD(Customer No.)));
                                                   CaptionML=[DAN=Navn 2;
                                                              ENU=Name 2];
                                                   Editable=No }
    { 96  ;   ;Bill-to Name 2      ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Customer."Name 2" WHERE (No.=FIELD(Bill-to Customer No.)));
                                                   CaptionML=[DAN=Faktureringsnavn 2;
                                                              ENU=Bill-to Name 2];
                                                   Editable=No }
    { 97  ;   ;Ship-to Name 2      ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Ship-to Address"."Name 2" WHERE (Customer No.=FIELD(Customer No.),
                                                                                                        Code=FIELD(Ship-to Code)));
                                                   CaptionML=[DAN=Leveringsnavn 2;
                                                              ENU=Ship-to Name 2];
                                                   Editable=No }
    { 98  ;   ;Next Invoice Period Start;Date     ;CaptionML=[DAN=N�ste fakturaperiodestart;
                                                              ENU=Next Invoice Period Start];
                                                   Editable=No }
    { 99  ;   ;Next Invoice Period End;Date       ;CaptionML=[DAN=N�ste fakt.periodeafslut.;
                                                              ENU=Next Invoice Period End];
                                                   Editable=No }
    { 100 ;   ;Contract Invoice Amount;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Service Ledger Entry"."Amount (LCY)" WHERE (Service Contract No.=FIELD(Contract No.),
                                                                                                                 Entry Type=CONST(Sale),
                                                                                                                 Moved from Prepaid Acc.=CONST(Yes),
                                                                                                                 Type=FIELD(Type Filter),
                                                                                                                 Posting Date=FIELD(Date Filter),
                                                                                                                 Open=CONST(No)));
                                                   CaptionML=[DAN=Kontraktsfakturabel�b;
                                                              ENU=Contract Invoice Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 101 ;   ;Contract Prepaid Amount;Decimal    ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Service Ledger Entry"."Amount (LCY)" WHERE (Service Contract No.=FIELD(Contract No.),
                                                                                                                 Entry Type=CONST(Sale),
                                                                                                                 Moved from Prepaid Acc.=CONST(No),
                                                                                                                 Type=CONST(Service Contract),
                                                                                                                 Posting Date=FIELD(Date Filter),
                                                                                                                 Open=CONST(No),
                                                                                                                 Prepaid=CONST(Yes)));
                                                   CaptionML=[DAN=Forudbetalt kontraktbel�b;
                                                              ENU=Contract Prepaid Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 102 ;   ;Contract Discount Amount;Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Ledger Entry"."Contract Disc. Amount" WHERE (Service Contract No.=FIELD(Contract No.),
                                                                                                                         Entry Type=CONST(Sale),
                                                                                                                         Moved from Prepaid Acc.=CONST(Yes),
                                                                                                                         Type=FIELD(Type Filter),
                                                                                                                         Posting Date=FIELD(Date Filter),
                                                                                                                         Open=CONST(No)));
                                                   CaptionML=[DAN=Kontraktrabatbel�b;
                                                              ENU=Contract Discount Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 103 ;   ;Contract Cost Amount;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Ledger Entry"."Cost Amount" WHERE (Service Contract No.=FIELD(Contract No.),
                                                                                                               Entry Type=CONST(Usage),
                                                                                                               Moved from Prepaid Acc.=CONST(Yes),
                                                                                                               Type=FIELD(Type Filter),
                                                                                                               Posting Date=FIELD(Date Filter),
                                                                                                               Open=CONST(No)));
                                                   CaptionML=[DAN=Kontraktkostbel�b;
                                                              ENU=Contract Cost Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 104 ;   ;Contract Gain/Loss Amount;Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Contract Gain/Loss Entry".Amount WHERE (Contract No.=FIELD(Contract No.),
                                                                                                            Reason Code=FIELD(Reason Code Filter),
                                                                                                            Change Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kontraktgevinst/-tab (bel�b);
                                                              ENU=Contract Gain/Loss Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 106 ;   ;No. of Posted Credit Memos;Integer ;FieldClass=FlowField;
                                                   CalcFormula=Count("Service Document Register" WHERE (Source Document Type=CONST(Contract),
                                                                                                        Source Document No.=FIELD(Contract No.),
                                                                                                        Destination Document Type=CONST(Posted Credit Memo)));
                                                   CaptionML=[DAN=Antal bogf�rte kreditnotaer;
                                                              ENU=No. of Posted Credit Memos];
                                                   Editable=No }
    { 107 ;   ;No. of Unposted Credit Memos;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Service Document Register" WHERE (Source Document Type=CONST(Contract),
                                                                                                        Source Document No.=FIELD(Contract No.),
                                                                                                        Destination Document Type=CONST(Credit Memo)));
                                                   CaptionML=[DAN=Antal ikkebogf. kreditnotaer;
                                                              ENU=No. of Unposted Credit Memos];
                                                   Editable=No }
    { 140 ;   ;Type Filter         ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Typefilter;
                                                              ENU=Type Filter];
                                                   OptionCaptionML=[DAN=" ,Ressource,Vare,Serviceomkostning,Servicekontrakt,Finanskonto";
                                                                    ENU=" ,Resource,Item,Service Cost,Service Contract,G/L Account"];
                                                   OptionString=[ ,Resource,Item,Service Cost,Service Contract,G/L Account] }
    { 141 ;   ;Reason Code Filter  ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="Reason Code";
                                                   CaptionML=[DAN=�rsagskodefilter;
                                                              ENU=Reason Code Filter] }
    { 142 ;   ;Posted Service Order Filter;Code20 ;FieldClass=FlowFilter;
                                                   TableRelation="Service Shipment Header";
                                                   CaptionML=[DAN=Bogf�rt serviceordrefilter;
                                                              ENU=Posted Service Order Filter] }
    { 143 ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 144 ;   ;Item Filter         ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Item;
                                                   CaptionML=[DAN=Varefilter;
                                                              ENU=Item Filter] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnValidate=BEGIN
                                                                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
                                                              END;

                                                   OnLookup=BEGIN
                                                              ShowDocDim;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 5050;   ;Contact No.         ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                Cont@1001 : Record 5050;
                                                                ContBusinessRelation@1000 : Record 5054;
                                                              BEGIN
                                                                IF ("Contact No." <> xRec."Contact No.") AND (xRec."Contact No." <> '') THEN
                                                                  IF NOT CONFIRM(Text014,FALSE,FIELDCAPTION("Contact No.")) THEN BEGIN
                                                                    "Contact No." := xRec."Contact No.";
                                                                    EXIT;
                                                                  END;

                                                                IF ("Customer No." <> '') AND ("Contact No." <> '') THEN BEGIN
                                                                  Cont.GET("Contact No.");
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Customer No.") THEN
                                                                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                                                                      ERROR(Text045,Cont."No.",Cont.Name,"Customer No.");
                                                                END;

                                                                UpdateCust("Contact No.");
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1001 : Record 5050;
                                                              ContBusinessRelation@1000 : Record 5054;
                                                            BEGIN
                                                              IF ("Customer No." <> '') AND Cont.GET("Contact No.") THEN
                                                                Cont.SETRANGE("Company No.",Cont."Company No.")
                                                              ELSE
                                                                IF "Customer No." <> '' THEN BEGIN
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Customer No.") THEN
                                                                    Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.");
                                                                END ELSE
                                                                  Cont.SETFILTER("Company No.",'<>%1','''');

                                                              IF "Contact No." <> '' THEN
                                                                IF Cont.GET("Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                                                                xRec := Rec;
                                                                VALIDATE("Contact No.",Cont."No.");
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Kontaktnr.;
                                                              ENU=Contact No.] }
    { 5051;   ;Bill-to Contact No. ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                Cont@1001 : Record 5050;
                                                                ContBusinessRelation@1000 : Record 5054;
                                                              BEGIN
                                                                IF ("Bill-to Contact No." <> xRec."Bill-to Contact No.") AND
                                                                   (xRec."Bill-to Contact No." <> '')
                                                                THEN
                                                                  IF NOT CONFIRM(Text014,FALSE,FIELDCAPTION("Bill-to Contact No.")) THEN BEGIN
                                                                    "Bill-to Contact No." := xRec."Bill-to Contact No.";
                                                                    EXIT;
                                                                  END;

                                                                IF ("Bill-to Customer No." <> '') AND ("Bill-to Contact No." <> '') THEN BEGIN
                                                                  Cont.GET("Bill-to Contact No.");
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Bill-to Customer No.") THEN
                                                                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                                                                      ERROR(Text045,Cont."No.",Cont.Name,"Bill-to Customer No.");
                                                                END;

                                                                UpdateBillToCust("Bill-to Contact No.");
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1001 : Record 5050;
                                                              ContBusinessRelation@1000 : Record 5054;
                                                            BEGIN
                                                              IF ("Bill-to Customer No." <> '') AND Cont.GET("Bill-to Contact No.") THEN
                                                                Cont.SETRANGE("Company No.",Cont."Company No.")
                                                              ELSE
                                                                IF Cust.GET("Bill-to Customer No.") THEN BEGIN
                                                                  IF ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer,"Bill-to Customer No.") THEN
                                                                    Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.");
                                                                END ELSE
                                                                  Cont.SETFILTER("Company No.",'<>%1','''');

                                                              IF "Bill-to Contact No." <> '' THEN
                                                                IF Cont.GET("Bill-to Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                                                                xRec := Rec;
                                                                VALIDATE("Bill-to Contact No.",Cont."No.");
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Faktureres attentionnr.;
                                                              ENU=Bill-to Contact No.] }
    { 5052;   ;Bill-to Contact     ;Text50        ;CaptionML=[DAN=Faktureres attention;
                                                              ENU=Bill-to Contact] }
    { 5053;   ;Last Invoice Period End;Date       ;CaptionML=[DAN=Sidste fakt.periodeafslut.;
                                                              ENU=Last Invoice Period End] }
  }
  KEYS
  {
    {    ;Contract Type,Contract No.              ;Clustered=Yes }
    {    ;Contract No.,Contract Type               }
    {    ;Customer No.,Ship-to Code                }
    {    ;Bill-to Customer No.,Contract Type,Combine Invoices,Next Invoice Date }
    {    ;Next Price Update Date                   }
    {    ;Responsibility Center,Service Zone Code,Status,Contract Group Code }
    {    ;Salesperson Code,Status                  }
    {    ;Template No.                             }
    {    ;Customer No.,Bill-to Customer No.       ;MaintainSQLIndex=No }
    {    ;Customer No.,Currency Code,Ship-to Code ;MaintainSQLIndex=No }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Contract No.,Description,Customer No.,Status,Change Status,Starting Date }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Vil du oprette kontrakten ved hj�lp af en kontraktskabelon?;ENU=Do you want to create the contract using a contract template?';
      Text002@1002 : TextConst 'DAN=Du kan ikke slette dette bilag. Dit id tillader kun behandling fra %1 %2.;ENU=You cannot delete this document. Your identification is set up to process from %1 %2 only.';
      Text003@1003 : TextConst 'DAN=Du kan ikke slette %1 %2.;ENU=You cannot delete %1 %2.';
      Text006@1006 : TextConst 'DAN=Feltet %1 kan kun �ndres til Annulleret.;ENU=The %1 field can only be changed to Canceled.';
      CancelTheContractQst@1007 : TextConst '@@@=%1: Text008;DAN=%1 Det ikke er muligt at �ndre en servicekontrakt til en tidligere status.\\Vil du annullere kontrakten?;ENU=%1 It is not possible to change a service contract to its previous status.\\Do you want to cancel the contract?';
      OpenPrepaymentEntriesExistTxt@1008 : TextConst 'DAN=�bn de forudbetalingsposter, der findes for kontrakten.;ENU=Open prepayment entries exist for the contract.';
      Text009@1009 : TextConst 'DAN=Du kan ikke �ndre feltet %1 til %2, n�r feltet %3 er %4.;ENU=You cannot change the %1 field to %2 when the %3 field is %4.';
      Text010@1010 : TextConst 'DAN=Vil du annullere %1?;ENU=Do you want to cancel %1?';
      Text011@1011 : TextConst 'DAN=Du kan ikke �ndre feltet %1 manuelt, fordi der er kontraktlinjer til denne debitor.\\;ENU=You cannot change the %1 field manually because there are contract lines for this customer.\\';
      Text012@1012 : TextConst 'DAN=Brug funktionen Skift debitor til at skifte debitor.;ENU=To change the customer, use the Change Customer function.';
      Text014@1014 : TextConst 'DAN=Skal %1 �ndres?;ENU=Do you want to change %1?';
      Text023@1015 : TextConst 'DAN=%1 kan ikke v�re mindre end %2.;ENU=%1 cannot be less than %2.';
      Text024@1016 : TextConst 'DAN=%1 kan ikke ligge f�r %2.;ENU=The %1 cannot be before the %2.';
      Text026@1017 : TextConst 'DAN=%1 skal v�re den f�rste dag i m�neden.;ENU=%1 must be the first day in the month.';
      Text027@1018 : TextConst 'DAN=%1 til %2;ENU=%1 to %2';
      Text028@1019 : TextConst 'DAN=%1 skal v�re den sidste dag i m�neden.;ENU=%1 must be the last day in the month.';
      Text029@1020 : TextConst 'DAN=Du kan ikke �ndre %1, fordi %2 er blevet faktureret.;ENU=You are not allowed to change %1 because the %2 has been invoiced.';
      Text030@1021 : TextConst 'DAN=Du kan ikke �ndre feltet %1 p� underskrevne servicekontrakter.;ENU=You cannot change the %1 field on signed service contracts.';
      Text031@1022 : TextConst 'DAN=Du har �ndret feltet %1.\\Kontraktlinjerne bliver ikke opdateret.;ENU=You have changed the %1 field.\\The contract lines will not be updated.';
      Text032@1023 : TextConst 'DAN=Du kan ikke �ndre %1, fordi %2 %3 er blevet faktureret.;ENU=You cannot change %1 because %2 %3 has been invoiced.';
      Text034@1024 : TextConst 'DAN=Nogle kontraktlinjer har en l�ngere svartid end feltet %1 p� servicekontrakthovedet. Vil du opdatere dem?;ENU=Some of the contract lines have a longer response time than the %1 field on the service contract header. Do you want to update them?';
      Text040@1030 : TextConst 'DAN=Dit id tillader kun behandling fra %1 %2.;ENU=Your identification is set up to process from %1 %2 only.';
      ServHeader@1075 : Record 5900;
      ServContractTmplt@1049 : Record 5968;
      ServContractHeader@1032 : Record 5965;
      ServContractLine@1059 : Record 5964;
      ServMgtSetup@1034 : Record 5911;
      ServCommentLine@1035 : Record 5906;
      Cust@1036 : Record 18;
      ShipToAddr@1037 : Record 222;
      ContractChangeLog@1038 : Record 5967;
      FiledServContract@1039 : Record 5970;
      ContractGainLossEntry@1042 : Record 5969;
      RespCenter@1044 : Record 5714;
      ServHour@1069 : Record 5910;
      ServContractLine2@1031 : Record 5964;
      Currency@1061 : Record 4;
      Salesperson@1913 : Record 13;
      NoSeriesMgt@1045 : Codeunit 396;
      UserMgt@1046 : Codeunit 5700;
      ServContractMgt@1047 : Codeunit 5940;
      ServOrderMgt@1048 : Codeunit 5900;
      ServContrQuoteTmplUpd@1050 : Codeunit 5942;
      DimMgt@1040 : Codeunit 408;
      MoveEntries@1077 : Codeunit 361;
      DaysInThisInvPeriod@1051 : Integer;
      DaysInFullInvPeriod@1052 : Integer;
      TempDate@1055 : Date;
      Text041@1056 : TextConst 'DAN=%1 kan ikke �ndres til %2, fordi denne %3 er blevet faktureret.;ENU=%1 cannot be changed to %2 because this %3 has been invoiced';
      Text042@1057 : TextConst 'DAN=Bel�bene p� servicekontrakthovedet og servicekontraktlinjerne er ikke blevet opdateret. V�rdien i feltet %1 angiver den valuta, der anvendes til at beregne bel�bene i de salgsdokumenter, der tilh�rer denne kontrakt. Bel�bene i servicekontrakten vises kun i RV.;ENU=The amounts on the service contract header and service contract lines have not been updated. The value of the %1 field indicates the currency in which the amounts in the sales documents belonging to this contract are calculated. The amounts on the service contract are presented in LCY only.';
      Text044@1067 : TextConst 'DAN=Kontakten %1 %2 er ikke knyttet til debitoren %3.;ENU=Contact %1 %2 is not related to customer %3.';
      Text045@1033 : TextConst 'DAN=Kontakten %1 %2 er knyttet til en anden virksomhed end debitoren %3.;ENU=Contact %1 %2 is related to a different company than customer %3.';
      Text048@1065 : TextConst 'DAN=Der er knyttet ikkebogf�rte fakturaer til denne kontrakt.\\Vil du annullere kontrakten?;ENU=There are unposted invoices linked to this contract.\\Do you want to cancel the contract?';
      Text049@1066 : TextConst 'DAN=Der er knyttet ikkebogf�rte kreditnotaer til denne kontrakt.\\Vil du annullere kontrakten?;ENU=There are unposted credit memos linked to this contract.\\Do you want to cancel the contract?';
      Text051@1001 : TextConst 'DAN=Kontakten %1 %2 er ikke knyttet til en debitor.;ENU=Contact %1 %2 is not related to a customer.';
      ContactNo@1068 : Code[20];
      Text052@1070 : TextConst 'DAN=Der findes %1 serviceposter til denne servicekontrakt\Vil du forts�tte?;ENU=%1 service ledger entries exist for this service contract\Would you like to continue?';
      Text053@1071 : TextConst 'DAN=Sletteprocessen blev afbrudt.;ENU=The deletion process has been interrupted.';
      SuspendChangeStatus@1072 : Boolean;
      SkipContact@1074 : Boolean;
      SkipBillToContact@1073 : Boolean;
      Text054@1076 : TextConst 'DAN=Du kan ikke markere dette felt, fordi du ikke har adgang til serviceordrestyring.;ENU=You cannot checkmark this field because you do not have permissions for the Service Order Management Area.';
      Text055@1079 : TextConst 'DAN=Der er knyttet ikkebogf�rte fakturaer og kreditnotaer til denne kontrakt.\\Vil du annullere kontrakten?;ENU=There are unposted invoices and credit memos linked to this contract.\\Do you want to cancel the contract?';
      StrToInsert@1078 : Text[250];
      Text056@1080 : TextConst 'DAN=Kontraktudl�bsdatoerne i servicekontraktlinjerne, som ligger senere end %1 p� %2, vil blive erstattet med %3.\Vil du forts�tte?;ENU=The contract expiration dates on the service contract lines that are later than %1 on the %2 will be replaced with %3.\Do you want to continue?';
      Text057@1081 : TextConst 'DAN=Du kan ikke b�de markere felterne %1 og %2.;ENU=You cannot select both the %1 and the %2 check boxes.';
      Text058@1026 : TextConst 'DAN=Du kan ikke bruge fordelingsfunktionaliteten, hvis der ikke findes kontraktlinjer i servicekontrakten.;ENU=You cannot use the Distribution functionality if there are no contract lines in the service contract.';
      Text059@1082 : TextConst 'DAN=Du kan ikke bruge indstillingen Fordeling baseret p� avance, hvis summen af v�rdier i feltet Avance i kontraktlinjerne er lig med nul.;ENU=You cannot use the Distribution Based on Profit option if the sum of values in the Profit field on the contract lines equals to zero.';
      Text060@1083 : TextConst 'DAN=Du kan ikke bruge indstillingen Fordeling baseret p� linjebel�b, hvis summen af v�rdier i feltet Linjebel�b er lig med nul.;ENU=You cannot use the Distribution Based on Line Amount option if the sum of values in the Line Amount field on the contract lines equals to zero.';
      Text061@1084 : TextConst 'DAN=Differencen i det �rlige bel�b er blevet fordelt, og en eller flere kontraktlinjer indeholder v�rdien nul eller mindre i felterne %1.\Du kan angive et bel�b i feltet %1.;ENU=The annual amount difference has been distributed and one or more contract lines have zero or less in the %1 fields.\You can enter an amount in the %1 field.';
      Text062@1085 : TextConst 'DAN=Der er f�jet linjer med serviceartikler til en eller flere kontrakter,\mens tilbuddet havde %1 %2.\Vil du have vist disse linjer?;ENU=Some lines containing service items have been added to one or more contracts\while the quote had the %1 %2.\Do you want to see these lines?';
      HideValidationDialog@1004 : Boolean;
      Confirmed@1005 : Boolean;
      Text063@1025 : TextConst 'DAN=%1 kan ikke omd�bes.;ENU=You cannot rename a %1.';
      InvPeriodDuration@1100 : DateFormula;
      Text064@1103 : TextConst 'DAN=%1 kan ikke v�re mindre end %2.;ENU=%1 cannot be less than %2.';
      Text065@1104 : TextConst 'DAN=%1 kan ikke v�re st�rre end %2.;ENU=%1 cannot be more than %2.';

    [External]
    PROCEDURE UpdContractChangeLog@5(OldServContractHeader@1000 : Record 5965);
    BEGIN
      IF "Contract Type" <> OldServContractHeader."Contract Type" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Contract Type"),0,
          FORMAT(OldServContractHeader."Contract Type"),FORMAT("Contract Type"),
          '',0);
      IF "Contract No." <> OldServContractHeader."Contract No." THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Contract No."),0,
          FORMAT(OldServContractHeader."Contract No."),FORMAT("Contract No."),
          '',0);
      IF Description <> OldServContractHeader.Description THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION(Description),0,
          OldServContractHeader.Description,Description,
          '',0);
      IF "Description 2" <> OldServContractHeader."Description 2" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Description 2"),0,
          OldServContractHeader."Description 2","Description 2",
          '',0);
      IF Status <> OldServContractHeader.Status THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION(Status),0,
          FORMAT(OldServContractHeader.Status),FORMAT(Status),
          '',0);
      IF "Customer No." <> OldServContractHeader."Customer No." THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Customer No."),0,
          OldServContractHeader."Customer No.","Customer No.",
          '',0);
      IF "Contact Name" <> OldServContractHeader."Contact Name" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Contact Name"),0,
          OldServContractHeader."Contact Name","Contact Name",
          '',0);
      IF "Your Reference" <> OldServContractHeader."Your Reference" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Your Reference"),0,
          OldServContractHeader."Your Reference","Your Reference",
          '',0);
      IF "Salesperson Code" <> OldServContractHeader."Salesperson Code" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Salesperson Code"),0,
          OldServContractHeader."Salesperson Code","Salesperson Code",
          '',0);
      IF "Bill-to Customer No." <> OldServContractHeader."Bill-to Customer No." THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Bill-to Customer No."),0,
          OldServContractHeader."Bill-to Customer No.","Bill-to Customer No.",
          '',0);
      IF "Ship-to Code" <> OldServContractHeader."Ship-to Code" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Ship-to Code"),0,
          OldServContractHeader."Ship-to Code","Ship-to Code",
          '',0);
      IF Prepaid <> OldServContractHeader.Prepaid THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION(Prepaid),0,
          FORMAT(OldServContractHeader.Prepaid),FORMAT(Prepaid),
          '',0);
      IF "Invoice Period" <> OldServContractHeader."Invoice Period" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Invoice Period"),0,
          FORMAT(OldServContractHeader."Invoice Period"),FORMAT("Invoice Period"),
          '',0);
      IF "Next Invoice Date" <> OldServContractHeader."Next Invoice Date" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Next Invoice Date"),0,
          FORMAT(OldServContractHeader."Next Invoice Date"),FORMAT("Next Invoice Date"),
          '',0);
      IF "Starting Date" <> OldServContractHeader."Starting Date" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Starting Date"),0,
          FORMAT(OldServContractHeader."Starting Date"),FORMAT("Starting Date"),
          '',0);
      IF "Expiration Date" <> OldServContractHeader."Expiration Date" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Expiration Date"),0,
          FORMAT(OldServContractHeader."Expiration Date"),FORMAT("Expiration Date"),
          '',0);
      IF "First Service Date" <> OldServContractHeader."First Service Date" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("First Service Date"),0,
          FORMAT(OldServContractHeader."First Service Date"),FORMAT("First Service Date"),
          '',0);
      IF "Max. Labor Unit Price" <> OldServContractHeader."Max. Labor Unit Price" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Max. Labor Unit Price"),0,
          FORMAT(OldServContractHeader."Max. Labor Unit Price"),FORMAT("Max. Labor Unit Price"),
          '',0);
      IF "Annual Amount" <> OldServContractHeader."Annual Amount" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Annual Amount"),0,
          FORMAT(OldServContractHeader."Annual Amount"),FORMAT("Annual Amount"),
          '',0);
      IF "Amount per Period" <> OldServContractHeader."Amount per Period" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Amount per Period"),0,
          FORMAT(OldServContractHeader."Amount per Period"),FORMAT("Amount per Period"),
          '',0);
      IF "Combine Invoices" <> OldServContractHeader."Combine Invoices" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Combine Invoices"),0,
          FORMAT(OldServContractHeader."Combine Invoices"),FORMAT("Combine Invoices"),
          '',0);
      IF "Next Invoice Period Start" <> OldServContractHeader."Next Invoice Period Start" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Next Invoice Period Start"),0,
          FORMAT(OldServContractHeader."Next Invoice Period Start"),FORMAT("Next Invoice Period Start"),
          '',0);
      IF "Next Invoice Period End" <> OldServContractHeader."Next Invoice Period End" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Next Invoice Period End"),0,
          FORMAT(OldServContractHeader."Next Invoice Period End"),FORMAT("Next Invoice Period End"),
          '',0);
      IF "Service Zone Code" <> OldServContractHeader."Service Zone Code" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Service Zone Code"),0,
          FORMAT(OldServContractHeader."Service Zone Code"),FORMAT("Service Zone Code"),
          '',0);
      IF "Cancel Reason Code" <> OldServContractHeader."Cancel Reason Code" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Cancel Reason Code"),0,
          FORMAT(OldServContractHeader."Cancel Reason Code"),FORMAT("Cancel Reason Code"),
          '',0);
      IF "Next Price Update Date" <> OldServContractHeader."Next Price Update Date" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Next Price Update Date"),0,
          FORMAT(OldServContractHeader."Next Price Update Date"),FORMAT("Next Price Update Date"),
          '',0);
      IF "Response Time (Hours)" <> OldServContractHeader."Response Time (Hours)" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Response Time (Hours)"),0,
          FORMAT(OldServContractHeader."Response Time (Hours)"),FORMAT("Response Time (Hours)"),
          '',0);
      IF "Contract Lines on Invoice" <> OldServContractHeader."Contract Lines on Invoice" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Contract Lines on Invoice"),0,
          FORMAT(OldServContractHeader."Contract Lines on Invoice"),FORMAT("Contract Lines on Invoice"),
          '',0);
      IF "Service Period" <> OldServContractHeader."Service Period" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Service Period"),0,
          FORMAT(OldServContractHeader."Service Period"),FORMAT("Service Period"),
          '',0);
      IF "Payment Terms Code" <> OldServContractHeader."Payment Terms Code" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Payment Terms Code"),0,
          FORMAT(OldServContractHeader."Payment Terms Code"),FORMAT("Payment Terms Code"),
          '',0);
      IF "Contract Group Code" <> OldServContractHeader."Contract Group Code" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Contract Group Code"),0,
          OldServContractHeader."Contract Group Code","Contract Group Code",
          '',0);
      IF "Service Order Type" <> OldServContractHeader."Service Order Type" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Service Order Type"),0,
          FORMAT(OldServContractHeader."Service Order Type"),FORMAT("Service Order Type"),
          '',0);
      IF "Accept Before" <> OldServContractHeader."Accept Before" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Accept Before"),0,
          FORMAT(OldServContractHeader."Accept Before"),FORMAT("Accept Before"),
          '',0);
      IF "Automatic Credit Memos" <> OldServContractHeader."Automatic Credit Memos" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Automatic Credit Memos"),0,
          FORMAT(OldServContractHeader."Automatic Credit Memos"),FORMAT("Automatic Credit Memos"),
          '',0);
      IF "Price Update Period" <> OldServContractHeader."Price Update Period" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Price Update Period"),0,
          FORMAT(OldServContractHeader."Price Update Period"),FORMAT("Price Update Period"),
          '',0);
      IF "Price Inv. Increase Code" <> OldServContractHeader."Price Inv. Increase Code" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Price Inv. Increase Code"),0,
          FORMAT(OldServContractHeader."Price Inv. Increase Code"),FORMAT("Price Inv. Increase Code"),
          '',0);
      IF "Currency Code" <> OldServContractHeader."Currency Code" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Currency Code"),0,
          FORMAT(OldServContractHeader."Currency Code"),FORMAT("Currency Code"),
          '',0);
      IF "Responsibility Center" <> OldServContractHeader."Responsibility Center" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Responsibility Center"),0,
          FORMAT(OldServContractHeader."Responsibility Center"),FORMAT("Responsibility Center"),
          '',0);
      IF "Phone No." <> OldServContractHeader."Phone No." THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Phone No."),0,
          FORMAT(OldServContractHeader."Phone No."),FORMAT("Phone No."),
          '',0);
      IF "Fax No." <> OldServContractHeader."Fax No." THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Fax No."),0,
          FORMAT(OldServContractHeader."Fax No."),FORMAT("Fax No."),
          '',0);
      IF "E-Mail" <> OldServContractHeader."E-Mail" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("E-Mail"),0,
          FORMAT(OldServContractHeader."E-Mail"),FORMAT("E-Mail"),
          '',0);
      IF "Allow Unbalanced Amounts" <> OldServContractHeader."Allow Unbalanced Amounts" THEN
        ContractChangeLog.LogContractChange(
          "Contract No.",0,FIELDCAPTION("Allow Unbalanced Amounts"),0,
          FORMAT(OldServContractHeader."Allow Unbalanced Amounts"),FORMAT("Allow Unbalanced Amounts"),
          '',0);
    END;

    [External]
    PROCEDURE AssistEdit@1(OldServContract@1000 : Record 5965) : Boolean;
    BEGIN
      WITH ServContractHeader DO BEGIN
        ServContractHeader := Rec;
        ServMgtSetup.GET;
        ServMgtSetup.TESTFIELD("Service Contract Nos.");
        IF NoSeriesMgt.SelectSeries(ServMgtSetup."Service Contract Nos.",OldServContract."No. Series","No. Series") THEN BEGIN
          NoSeriesMgt.SetSeries("Contract No.");
          Rec := ServContractHeader;
          EXIT(TRUE);
        END;
      END;
    END;

    [External]
    PROCEDURE ReturnNoOfPer@2(InvoicePeriod@1001 : 'Month,Two Months,Quarter,Half Year,Year') RetPer@1000 : Integer;
    BEGIN
      CASE InvoicePeriod OF
        InvoicePeriod::Month:
          RetPer := 12;
        InvoicePeriod::"Two Months":
          RetPer := 6;
        InvoicePeriod::Quarter:
          RetPer := 4;
        InvoicePeriod::"Half Year":
          RetPer := 2;
        InvoicePeriod::Year:
          RetPer := 1;
        ELSE
          RetPer := 0;
      END;
    END;

    LOCAL PROCEDURE CalculateEndPeriodDate@3(Prepaid@1000 : Boolean;NextInvDate@1001 : Date) : Date;
    VAR
      TempDate2@1002 : Date;
    BEGIN
      IF NextInvDate = 0D THEN
        EXIT(0D);
      IF Prepaid THEN BEGIN
        CASE "Invoice Period" OF
          "Invoice Period"::Month:
            TempDate2 := CALCDATE('<1M-1D>',NextInvDate);
          "Invoice Period"::"Two Months":
            TempDate2 := CALCDATE('<2M-1D>',NextInvDate);
          "Invoice Period"::Quarter:
            TempDate2 := CALCDATE('<3M-1D>',NextInvDate);
          "Invoice Period"::"Half Year":
            TempDate2 := CALCDATE('<6M-1D>',NextInvDate);
          "Invoice Period"::Year:
            TempDate2 := CALCDATE('<12M-1D>',NextInvDate);
          "Invoice Period"::None:
            TempDate2 := 0D;
        END;
        EXIT(TempDate2);
      END;
      CASE "Invoice Period" OF
        "Invoice Period"::Month:
          TempDate2 := CALCDATE('<-CM>',NextInvDate);
        "Invoice Period"::"Two Months":
          TempDate2 := CALCDATE('<-CM-1M>',NextInvDate);
        "Invoice Period"::Quarter:
          TempDate2 := CALCDATE('<-CM-2M>',NextInvDate);
        "Invoice Period"::"Half Year":
          TempDate2 := CALCDATE('<-CM-5M>',NextInvDate);
        "Invoice Period"::Year:
          TempDate2 := CALCDATE('<-CM-11M>',NextInvDate);
        "Invoice Period"::None:
          TempDate2 := 0D;
      END;
      EXIT(TempDate2);
    END;

    [External]
    PROCEDURE UpdateServZone@4();
    BEGIN
      IF "Ship-to Code" <> '' THEN BEGIN
        ShipToAddr.GET("Customer No.","Ship-to Code");
        "Service Zone Code" := ShipToAddr."Service Zone Code";
      END ELSE
        IF "Customer No." <> '' THEN BEGIN
          Cust.GET("Customer No.");
          "Service Zone Code" := Cust."Service Zone Code";
        END ELSE
          "Service Zone Code" := '';
    END;

    LOCAL PROCEDURE ContractLinesExist@7() : Boolean;
    BEGIN
      ServContractLine.RESET;
      ServContractLine.SETRANGE("Contract Type","Contract Type");
      ServContractLine.SETRANGE("Contract No.","Contract No.");
      EXIT(ServContractLine.FIND('-'));
    END;

    [External]
    PROCEDURE UpdateShiptoCode@6();
    BEGIN
      IF "Ship-to Code" = '' THEN BEGIN
        "Ship-to Name" := Name;
        "Ship-to Name 2" := "Name 2";
        "Ship-to Address" := Address;
        "Ship-to Address 2" := "Address 2";
        "Ship-to Post Code" := "Post Code";
        "Ship-to City" := City;
        "Ship-to County" := County;
        "Ship-to Country/Region Code" := "Country/Region Code";
      END;
    END;

    [External]
    PROCEDURE NextInvoicePeriod@8() : Text[250];
    BEGIN
      IF ("Next Invoice Period Start" <> 0D) AND ("Next Invoice Period End" <> 0D) THEN
        EXIT(STRSUBSTNO(Text027,"Next Invoice Period Start","Next Invoice Period End"));
    END;

    [External]
    PROCEDURE ValidateNextInvoicePeriod@9();
    VAR
      InvFrom@1001 : Date;
      InvTo@1000 : Date;
    BEGIN
      IF NextInvoicePeriod = '' THEN BEGIN
        "Amount per Period" := 0;
        EXIT;
      END;
      Currency.InitRoundingPrecision;
      InvFrom := "Next Invoice Period Start";
      InvTo := "Next Invoice Period End";

      DaysInThisInvPeriod := InvTo - InvFrom + 1;

      IF Prepaid THEN BEGIN
        TempDate := CalculateEndPeriodDate(TRUE,"Next Invoice Date");
        DaysInFullInvPeriod := TempDate - "Next Invoice Date" + 1;
      END ELSE BEGIN
        TempDate := CalculateEndPeriodDate(FALSE,"Next Invoice Date");
        DaysInFullInvPeriod := "Next Invoice Date" - TempDate + 1;
        IF (DaysInFullInvPeriod = DaysInThisInvPeriod) AND ("Next Invoice Date" = "Expiration Date") THEN
          DaysInFullInvPeriod := CalculateEndPeriodDate(TRUE,TempDate) - TempDate + 1;
      END;

      IF DaysInFullInvPeriod = DaysInThisInvPeriod THEN
        "Amount per Period" :=
          ROUND("Annual Amount" / ReturnNoOfPer("Invoice Period"),Currency."Amount Rounding Precision")
      ELSE
        "Amount per Period" := ROUND(
            ServContractMgt.CalcContractAmount(Rec,InvFrom,InvTo),Currency."Amount Rounding Precision");
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@19(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    [External]
    PROCEDURE CreateDim@16(Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20];Type4@1007 : Integer;No4@1006 : Code[20];Type5@1009 : Integer;No5@1008 : Code[20]);
    VAR
      SourceCodeSetup@1010 : Record 242;
      TableID@1011 : ARRAY [10] OF Integer;
      No@1012 : ARRAY [10] OF Code[20];
    BEGIN
      IF "Change Status" <> "Change Status"::Open THEN
        EXIT;

      SourceCodeSetup.GET;
      TableID[1] := Type1;
      No[1] := No1;
      TableID[2] := Type2;
      No[2] := No2;
      TableID[3] := Type3;
      No[3] := No3;
      TableID[4] := Type4;
      No[4] := No4;
      TableID[5] := Type5;
      No[5] := No5;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup."Service Management",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    END;

    [External]
    PROCEDURE SuspendStatusCheck@11(StatCheckParameter@1000 : Boolean);
    BEGIN
      SuspendChangeStatus := StatCheckParameter;
    END;

    [External]
    PROCEDURE UpdateCont@24(CustomerNo@1000 : Code[20]);
    VAR
      ContBusRel@1003 : Record 5054;
      Cont@1002 : Record 5050;
      Cust@1004 : Record 18;
    BEGIN
      IF Cust.GET(CustomerNo) THEN BEGIN
        CLEAR(ServOrderMgt);
        ContactNo := ServOrderMgt.FindContactInformation(Cust."No.");
        IF Cont.GET(ContactNo) THEN BEGIN
          "Contact No." := Cont."No.";
          "Contact Name" := Cont.Name;
          "Phone No." := Cont."Phone No.";
          "E-Mail" := Cont."E-Mail";
        END ELSE BEGIN
          IF Cust."Primary Contact No." <> '' THEN
            "Contact No." := Cust."Primary Contact No."
          ELSE
            IF ContBusRel.FindByRelation(ContBusRel."Link to Table"::Customer,"Customer No.") THEN
              "Contact No." := ContBusRel."Contact No.";
          "Contact Name" := Cust.Contact;
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateBillToCont@27(CustomerNo@1000 : Code[20]);
    VAR
      ContBusRel@1003 : Record 5054;
      Cont@1002 : Record 5050;
      Cust@1001 : Record 18;
    BEGIN
      IF Cust.GET(CustomerNo) THEN BEGIN
        CLEAR(ServOrderMgt);
        ContactNo := ServOrderMgt.FindContactInformation("Bill-to Customer No.");
        IF Cont.GET(ContactNo) THEN BEGIN
          "Bill-to Contact No." := Cont."No.";
          "Bill-to Contact" := Cont.Name;
        END ELSE BEGIN
          IF Cust."Primary Contact No." <> '' THEN
            "Bill-to Contact No." := Cust."Primary Contact No."
          ELSE
            IF ContBusRel.FindByRelation(ContBusRel."Link to Table"::Customer,"Bill-to Customer No.") THEN
              "Bill-to Contact No." := ContBusRel."Contact No.";
          "Bill-to Contact" := Cust.Contact;
        END;
      END;
    END;

    [External]
    PROCEDURE UpdateCust@25(ContactNo@1002 : Code[20]);
    VAR
      ContBusinessRelation@1007 : Record 5054;
      Cust@1006 : Record 18;
      Cont@1005 : Record 5050;
    BEGIN
      IF Cont.GET(ContactNo) THEN BEGIN
        "Contact No." := Cont."No.";
        "Phone No." := Cont."Phone No.";
        "E-Mail" := Cont."E-Mail";
        IF Cont.Type = Cont.Type::Person THEN
          "Contact Name" := Cont.Name
        ELSE
          IF Cust.GET("Customer No.") THEN
            "Contact Name" := Cust.Contact
          ELSE
            "Contact Name" := ''
      END ELSE BEGIN
        "Contact Name" := '';
        "Phone No." := '';
        "E-Mail" := '';
        EXIT;
      END;

      IF ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") THEN BEGIN
        IF ("Customer No." <> '') AND
           ("Customer No." <> ContBusinessRelation."No.")
        THEN
          ERROR(Text044,Cont."No.",Cont.Name,"Customer No.");
        IF "Customer No." = '' THEN BEGIN
          SkipContact := TRUE;
          VALIDATE("Customer No.",ContBusinessRelation."No.");
          SkipContact := FALSE;
        END;
      END ELSE
        ERROR(Text051,Cont."No.",Cont.Name);

      IF ("Customer No." = "Bill-to Customer No.") OR
         ("Bill-to Customer No." = '')
      THEN
        VALIDATE("Bill-to Contact No.","Contact No.");
    END;

    LOCAL PROCEDURE UpdateBillToCust@26(ContactNo@1000 : Code[20]);
    VAR
      ContBusinessRelation@1005 : Record 5054;
      Cust@1004 : Record 18;
      Cont@1003 : Record 5050;
    BEGIN
      IF Cont.GET(ContactNo) THEN BEGIN
        "Bill-to Contact No." := Cont."No.";
        IF Cont.Type = Cont.Type::Person THEN
          "Bill-to Contact" := Cont.Name
        ELSE
          IF Cust.GET("Bill-to Customer No.") THEN
            "Bill-to Contact" := Cust.Contact
          ELSE
            "Bill-to Contact" := '';
      END ELSE BEGIN
        "Bill-to Contact" := '';
        EXIT;
      END;

      IF ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") THEN BEGIN
        IF "Bill-to Customer No." = '' THEN BEGIN
          SkipBillToContact := TRUE;
          VALIDATE("Bill-to Customer No.",ContBusinessRelation."No.");
          SkipBillToContact := FALSE;
        END ELSE
          IF "Bill-to Customer No." <> ContBusinessRelation."No." THEN
            ERROR(Text044,Cont."No.",Cont.Name,"Bill-to Customer No.");
      END ELSE
        ERROR(Text051,Cont."No.",Cont.Name);
    END;

    LOCAL PROCEDURE EvenDistribution@12(VAR ServContractLine2@1001 : Record 5964);
    VAR
      OldServContractLine@1002 : Record 5964;
      AmountToAdjust@1000 : Decimal;
    BEGIN
      ServContractLine2.LOCKTABLE;
      CALCFIELDS("Calcd. Annual Amount");
      AmountToAdjust := ("Annual Amount" - "Calcd. Annual Amount") / ServContractLine2.COUNT;
      IF ServContractLine2.FIND('-') THEN
        REPEAT
          OldServContractLine := ServContractLine2;
          ServContractLine2.VALIDATE(
            "Line Amount",
            ROUND(ServContractLine2."Line Amount" + AmountToAdjust,Currency."Amount Rounding Precision"));
          ServContractLine2.MODIFY;
          IF ServMgtSetup."Register Contract Changes" THEN
            ServContractLine2.LogContractLineChanges(OldServContractLine);
        UNTIL ServContractLine2.NEXT = 0;
    END;

    LOCAL PROCEDURE ProfitBasedDistribution@13(VAR ServContractLine2@1001 : Record 5964);
    VAR
      OldServContractLine@1002 : Record 5964;
      TotalProfit@1000 : Decimal;
    BEGIN
      ServContractLine2.LOCKTABLE;
      ServContractLine2.CALCSUMS(Profit);
      TotalProfit := ServContractLine2.Profit;
      IF TotalProfit = 0 THEN
        ERROR(Text059);
      CALCFIELDS("Calcd. Annual Amount");
      IF ServContractLine2.FIND('-') THEN
        REPEAT
          OldServContractLine := ServContractLine2;
          ServContractLine2.VALIDATE(
            "Line Amount",
            ROUND(
              ServContractLine."Line Amount" +
              ("Annual Amount" - "Calcd. Annual Amount") *
              (ServContractLine2.Profit / TotalProfit),Currency."Amount Rounding Precision"));
          ServContractLine2.MODIFY;
          IF ServMgtSetup."Register Contract Changes" THEN
            ServContractLine2.LogContractLineChanges(OldServContractLine);
        UNTIL ServContractLine2.NEXT = 0;
    END;

    LOCAL PROCEDURE AmountBasedDistribution@14(VAR ServContractLine2@1000 : Record 5964);
    VAR
      OldServContractLine@1001 : Record 5964;
    BEGIN
      ServContractLine2.LOCKTABLE;
      CALCFIELDS("Calcd. Annual Amount");
      IF "Calcd. Annual Amount" = 0 THEN
        ERROR(Text060);
      IF ServContractLine2.FIND('-') THEN
        REPEAT
          OldServContractLine := ServContractLine2;
          ServContractLine2.VALIDATE(
            "Line Amount",
            ROUND(
              ServContractLine2."Line Amount" +
              ("Annual Amount" - "Calcd. Annual Amount") *
              (ServContractLine2."Line Amount" / "Calcd. Annual Amount"),
              Currency."Amount Rounding Precision"));
          ServContractLine2.MODIFY;
          IF ServMgtSetup."Register Contract Changes" THEN
            ServContractLine2.LogContractLineChanges(OldServContractLine);
        UNTIL ServContractLine2.NEXT = 0;
    END;

    LOCAL PROCEDURE DistributeAmounts@17();
    VAR
      OldServContractLine@1002 : Record 5964;
      ContractAmountDistribution@1000 : Page 6079;
      Result@1001 : Integer;
    BEGIN
      IF NOT "Allow Unbalanced Amounts" THEN BEGIN
        ServContractLine.RESET;
        ServContractLine.SETRANGE("Contract Type","Contract Type");
        ServContractLine.SETRANGE("Contract No.","Contract No.");
        IF NOT ServContractLine.FIND('-') AND ("Annual Amount" <> 0) THEN
          ERROR(Text058);
        CALCFIELDS("Calcd. Annual Amount");
        IF "Annual Amount" <> "Calcd. Annual Amount" THEN BEGIN
          ServContractLine.SETRANGE("Line Value",0);
          IF ServContractLine.FIND('-') THEN
            ServContractLine.TESTFIELD("Line Value");
          ServContractLine.SETRANGE("Line Value");
          IF ServContractLine.NEXT <> 0 THEN BEGIN
            CLEAR(ContractAmountDistribution);
            ContractAmountDistribution.SetValues("Annual Amount","Calcd. Annual Amount");
            IF ContractAmountDistribution.RUNMODAL = ACTION::Yes THEN BEGIN
              Result := ContractAmountDistribution.GetResult;
              Currency.InitRoundingPrecision;
              CASE Result OF
                0:
                  EvenDistribution(ServContractLine);
                1:
                  ProfitBasedDistribution(ServContractLine);
                2:
                  AmountBasedDistribution(ServContractLine);
              END;
              CALCFIELDS("Calcd. Annual Amount");
              IF "Annual Amount" <> "Calcd. Annual Amount" THEN BEGIN
                ServContractLine.VALIDATE(
                  "Line Amount",
                  ServContractLine."Line Amount" + "Annual Amount" - "Calcd. Annual Amount");
                ServContractLine.MODIFY;
              END;
              ServContractLine.SETFILTER("Line Amount",'<=0');
              IF ServContractLine.FIND('-') THEN
                MESSAGE(Text061,ServContractLine.FIELDCAPTION("Line Amount"));
            END ELSE
              ERROR('');
          END ELSE BEGIN
            OldServContractLine := ServContractLine;
            ServContractLine.VALIDATE("Line Amount","Annual Amount");
            ServContractLine.MODIFY;
            IF ServMgtSetup."Register Contract Changes" THEN
              ServContractLine.LogContractLineChanges(OldServContractLine);
          END;
        END;
      END;
    END;

    [External]
    PROCEDURE SetHideValidationDialog@15(Hide@1000 : Boolean);
    BEGIN
      HideValidationDialog := Hide;
    END;

    [External]
    PROCEDURE SetSecurityFilterOnRespCenter@42();
    BEGIN
      IF UserMgt.GetServiceFilter <> '' THEN BEGIN
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserMgt.GetServiceFilter);
        FILTERGROUP(0);
      END;

      SETRANGE("Date Filter",0D,WORKDATE - 1);
    END;

    [External]
    PROCEDURE ShowDocDim@18();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2',"Contract Type","Contract No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    LOCAL PROCEDURE CalcInvPeriodDuration@1102();
    BEGIN
      IF "Invoice Period" <> "Invoice Period"::None THEN
        CASE "Invoice Period" OF
          "Invoice Period"::Month:
            EVALUATE(InvPeriodDuration,'<1M>');
          "Invoice Period"::"Two Months":
            EVALUATE(InvPeriodDuration,'<2M>');
          "Invoice Period"::Quarter:
            EVALUATE(InvPeriodDuration,'<3M>');
          "Invoice Period"::"Half Year":
            EVALUATE(InvPeriodDuration,'<6M>');
          "Invoice Period"::Year:
            EVALUATE(InvPeriodDuration,'<1Y>');
        END;
    END;

    LOCAL PROCEDURE CheckChangeStatus@20();
    BEGIN
      IF (Status <> Status::Canceled) AND
         NOT SuspendChangeStatus
      THEN
        TESTFIELD("Change Status","Change Status"::Open);
    END;

    LOCAL PROCEDURE SetSalespersonCode@433(SalesPersonCodeToCheck@1000 : Code[20];VAR SalesPersonCodeToAssign@1001 : Code[20]);
    BEGIN
      IF SalesPersonCodeToCheck <> '' THEN
        IF Salesperson.GET(SalesPersonCodeToCheck) THEN
          IF Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) THEN
            SalesPersonCodeToAssign := ''
          ELSE
            SalesPersonCodeToAssign := SalesPersonCodeToCheck;
    END;

    PROCEDURE ValidateSalesPersonOnServiceContractHeader@218(ServiceContractHeader2@1000 : Record 5965;IsTransaction@1001 : Boolean;IsPostAction@1002 : Boolean);
    BEGIN
      IF ServiceContractHeader2."Salesperson Code" <> '' THEN
        IF Salesperson.GET(ServiceContractHeader2."Salesperson Code") THEN
          IF Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) THEN BEGIN
            IF IsTransaction THEN
              ERROR(Salesperson.GetPrivacyBlockedTransactionText(Salesperson,IsPostAction,TRUE));
            IF NOT IsTransaction THEN
              ERROR(Salesperson.GetPrivacyBlockedGenericText(Salesperson,TRUE));
          END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@138(VAR ServiceContractHeader@1000 : Record 5965;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    BEGIN
    END.
  }
}

