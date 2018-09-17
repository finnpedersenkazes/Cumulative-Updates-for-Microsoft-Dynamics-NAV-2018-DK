OBJECT Table 18 Customer
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441,NAVDK11.00.00.21441;
  }
  PROPERTIES
  {
    Permissions=TableData 21=r,
                TableData 167=r,
                TableData 249=rd,
                TableData 5900=r,
                TableData 5940=rm,
                TableData 5965=rm,
                TableData 7002=rd,
                TableData 7004=rd;
    DataCaptionFields=No.,Name;
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 SalesSetup.GET;
                 SalesSetup.TESTFIELD("Customer Nos.");
                 NoSeriesMgt.InitSeries(SalesSetup."Customer Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;

               IF "Invoice Disc. Code" = '' THEN
                 "Invoice Disc. Code" := "No.";

               IF NOT (InsertFromContact OR (InsertFromTemplate AND (Contact <> '')) OR ISTEMPORARY) THEN
                 UpdateContFromCust.OnInsert(Rec);

               IF "Salesperson Code" = '' THEN
                 SetDefaultSalesperson;

               DimMgt.UpdateDefaultDim(
                 DATABASE::Customer,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");

               SetLastModifiedDateTime;
             END;

    OnModify=BEGIN
               SetLastModifiedDateTime;
               IF IsContactUpdateNeeded THEN BEGIN
                 MODIFY;
                 UpdateContFromCust.OnModify(Rec);
                 IF NOT FIND THEN BEGIN
                   RESET;
                   IF FIND THEN;
                 END;
               END;
             END;

    OnDelete=VAR
               CampaignTargetGr@1000 : Record 7030;
               ContactBusRel@1001 : Record 5054;
               Job@1004 : Record 167;
               SocialListeningSearchTopic@1007 : Record 871;
               StdCustSalesCode@1003 : Record 172;
               CustomReportSelection@1008 : Record 9657;
               MyCustomer@1005 : Record 9150;
               ServHeader@1009 : Record 5900;
               CampaignTargetGrMgmt@1002 : Codeunit 7030;
               VATRegistrationLogMgt@1006 : Codeunit 249;
             BEGIN
               ApprovalsMgmt.OnCancelCustomerApprovalRequest(Rec);

               ServiceItem.SETRANGE("Customer No.","No.");
               IF ServiceItem.FINDFIRST THEN
                 IF CONFIRM(
                      Text008,
                      FALSE,
                      TABLECAPTION,
                      "No.",
                      ServiceItem.FIELDCAPTION("Customer No."))
                 THEN
                   ServiceItem.MODIFYALL("Customer No.",'')
                 ELSE
                   ERROR(Text009);

               Job.SETRANGE("Bill-to Customer No.","No.");
               IF NOT Job.ISEMPTY THEN
                 ERROR(Text015,TABLECAPTION,"No.",Job.TABLECAPTION);

               MoveEntries.MoveCustEntries(Rec);

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Customer);
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               CustBankAcc.SETRANGE("Customer No.","No.");
               CustBankAcc.DELETEALL;

               ShipToAddr.SETRANGE("Customer No.","No.");
               ShipToAddr.DELETEALL;

               SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::Customer);
               SalesPrice.SETRANGE("Sales Code","No.");
               SalesPrice.DELETEALL;

               SalesLineDisc.SETRANGE("Sales Type",SalesLineDisc."Sales Type"::Customer);
               SalesLineDisc.SETRANGE("Sales Code","No.");
               SalesLineDisc.DELETEALL;

               SalesPrepmtPct.SETCURRENTKEY("Sales Type","Sales Code");
               SalesPrepmtPct.SETRANGE("Sales Type",SalesPrepmtPct."Sales Type"::Customer);
               SalesPrepmtPct.SETRANGE("Sales Code","No.");
               SalesPrepmtPct.DELETEALL;

               StdCustSalesCode.SETRANGE("Customer No.","No.");
               StdCustSalesCode.DELETEALL(TRUE);

               ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
               ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Customer);
               ItemCrossReference.SETRANGE("Cross-Reference Type No.","No.");
               ItemCrossReference.DELETEALL;

               IF NOT SocialListeningSearchTopic.ISEMPTY THEN BEGIN
                 SocialListeningSearchTopic.FindSearchTopic(SocialListeningSearchTopic."Source Type"::Customer,"No.");
                 SocialListeningSearchTopic.DELETEALL;
               END;

               SalesOrderLine.SETCURRENTKEY("Document Type","Bill-to Customer No.");
               SalesOrderLine.SETRANGE("Bill-to Customer No.","No.");
               IF SalesOrderLine.FINDFIRST THEN
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.",SalesOrderLine."Document Type");

               SalesOrderLine.SETRANGE("Bill-to Customer No.");
               SalesOrderLine.SETRANGE("Sell-to Customer No.","No.");
               IF SalesOrderLine.FINDFIRST THEN
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.",SalesOrderLine."Document Type");

               CampaignTargetGr.SETRANGE("No.","No.");
               CampaignTargetGr.SETRANGE(Type,CampaignTargetGr.Type::Customer);
               IF CampaignTargetGr.FIND('-') THEN BEGIN
                 ContactBusRel.SETRANGE("Link to Table",ContactBusRel."Link to Table"::Customer);
                 ContactBusRel.SETRANGE("No.","No.");
                 ContactBusRel.FINDFIRST;
                 REPEAT
                   CampaignTargetGrMgmt.ConverttoContact(Rec,ContactBusRel."Contact No.");
                 UNTIL CampaignTargetGr.NEXT = 0;
               END;

               ServContract.SETFILTER(Status,'<>%1',ServContract.Status::Canceled);
               ServContract.SETRANGE("Customer No.","No.");
               IF NOT ServContract.ISEMPTY THEN
                 ERROR(
                   Text007,
                   TABLECAPTION,"No.");

               ServContract.SETRANGE(Status);
               ServContract.MODIFYALL("Customer No.",'');

               ServContract.SETFILTER(Status,'<>%1',ServContract.Status::Canceled);
               ServContract.SETRANGE("Bill-to Customer No.","No.");
               IF NOT ServContract.ISEMPTY THEN
                 ERROR(
                   Text007,
                   TABLECAPTION,"No.");

               ServContract.SETRANGE(Status);
               ServContract.MODIFYALL("Bill-to Customer No.",'');

               ServHeader.SETCURRENTKEY("Customer No.","Order Date");
               ServHeader.SETRANGE("Customer No.","No.");
               IF ServHeader.FINDFIRST THEN
                 ERROR(
                   Text013,
                   TABLECAPTION,"No.",ServHeader."Document Type");

               ServHeader.SETRANGE("Bill-to Customer No.");
               IF ServHeader.FINDFIRST THEN
                 ERROR(
                   Text013,
                   TABLECAPTION,"No.",ServHeader."Document Type");

               UpdateContFromCust.OnDelete(Rec);

               CustomReportSelection.SETRANGE("Source Type",DATABASE::Customer);
               CustomReportSelection.SETRANGE("Source No.","No.");
               CustomReportSelection.DELETEALL;

               MyCustomer.SETRANGE("Customer No.","No.");
               MyCustomer.DELETEALL;
               VATRegistrationLogMgt.DeleteCustomerLog(Rec);

               DimMgt.DeleteDefaultDim(DATABASE::Customer,"No.");
             END;

    OnRename=VAR
               CustomerTemplate@1000 : Record 5105;
               SkipRename@1001 : Boolean;
             BEGIN
               // Give extensions option to opt out of rename logic.
               SkipRenamingLogic(SkipRename);
               IF SkipRename THEN
                 EXIT;

               ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);

               SetLastModifiedDateTime;
               IF xRec."Invoice Disc. Code" = xRec."No." THEN
                 "Invoice Disc. Code" := "No.";
               CustomerTemplate.SETRANGE("Invoice Disc. Code",xRec."No.");
               CustomerTemplate.MODIFYALL("Invoice Disc. Code","No.");
             END;

    CaptionML=[DAN=Debitor;
               ENU=Customer];
    LookupPageID=Page22;
    DrillDownPageID=Page22;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Customer Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                                IF "Invoice Disc. Code" = '' THEN
                                                                  "Invoice Disc. Code" := "No.";
                                                              END;

                                                   AltSearchField=Search Name;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Name                ;Text50        ;OnValidate=BEGIN
                                                                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                                                                  "Search Name" := Name;
                                                              END;

                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Search Name         ;Code50        ;CaptionML=[DAN=S›genavn;
                                                              ENU=Search Name] }
    { 4   ;   ;Name 2              ;Text50        ;CaptionML=[DAN=Navn 2;
                                                              ENU=Name 2] }
    { 5   ;   ;Address             ;Text50        ;CaptionML=[DAN=Adresse;
                                                              ENU=Address] }
    { 6   ;   ;Address 2           ;Text50        ;CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2] }
    { 7   ;   ;City                ;Text30        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City] }
    { 8   ;   ;Contact             ;Text50        ;OnValidate=BEGIN
                                                                IF RMSetup.GET THEN
                                                                  IF RMSetup."Bus. Rel. Code for Customers" <> '' THEN
                                                                    IF (xRec.Contact = '') AND (xRec."Primary Contact No." = '') AND (Contact <> '') THEN BEGIN
                                                                      MODIFY;
                                                                      UpdateContFromCust.OnModify(Rec);
                                                                      UpdateContFromCust.InsertNewContactPerson(Rec,FALSE);
                                                                      MODIFY(TRUE);
                                                                    END
                                                              END;

                                                   OnLookup=VAR
                                                              ContactBusinessRelation@1001 : Record 5054;
                                                              Cont@1000 : Record 5050;
                                                            BEGIN
                                                              IF ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer,"No.") THEN
                                                                Cont.SETRANGE("Company No.",ContactBusinessRelation."Contact No.")
                                                              ELSE
                                                                Cont.SETRANGE("Company No.",'');

                                                              IF "Primary Contact No." <> '' THEN
                                                                IF Cont.GET("Primary Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN
                                                                VALIDATE("Primary Contact No.",Cont."No.");
                                                            END;

                                                   CaptionML=[DAN=Kontakt;
                                                              ENU=Contact] }
    { 9   ;   ;Phone No.           ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.] }
    { 10  ;   ;Telex No.           ;Text20        ;CaptionML=[DAN=Telex;
                                                              ENU=Telex No.] }
    { 11  ;   ;Document Sending Profile;Code20    ;TableRelation="Document Sending Profile".Code;
                                                   CaptionML=[DAN=Dokumentafsendelsesprofil;
                                                              ENU=Document Sending Profile] }
    { 14  ;   ;Our Account No.     ;Text20        ;CaptionML=[DAN=Vores kontonr.;
                                                              ENU=Our Account No.] }
    { 15  ;   ;Territory Code      ;Code10        ;TableRelation=Territory;
                                                   CaptionML=[DAN=Distriktskode;
                                                              ENU=Territory Code] }
    { 16  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 17  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 18  ;   ;Chain Name          ;Code10        ;CaptionML=[DAN=K‘de;
                                                              ENU=Chain Name] }
    { 19  ;   ;Budgeted Amount     ;Decimal       ;CaptionML=[DAN=Budgetteret bel›b;
                                                              ENU=Budgeted Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 20  ;   ;Credit Limit (LCY)  ;Decimal       ;CaptionML=[DAN=Kreditmaksimum (RV);
                                                              ENU=Credit Limit (LCY)];
                                                   AutoFormatType=1 }
    { 21  ;   ;Customer Posting Group;Code20      ;TableRelation="Customer Posting Group";
                                                   CaptionML=[DAN=Debitorbogf›ringsgruppe;
                                                              ENU=Customer Posting Group] }
    { 22  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                UpdateCurrencyId;
                                                              END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 23  ;   ;Customer Price Group;Code10        ;TableRelation="Customer Price Group";
                                                   CaptionML=[DAN=Debitorprisgruppe;
                                                              ENU=Customer Price Group] }
    { 24  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 26  ;   ;Statistics Group    ;Integer       ;CaptionML=[DAN=Statistikgruppe;
                                                              ENU=Statistics Group] }
    { 27  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   OnValidate=BEGIN
                                                                UpdatePaymentTermsId;
                                                              END;

                                                   CaptionML=[DAN=Betalingsbeting.kode;
                                                              ENU=Payment Terms Code] }
    { 28  ;   ;Fin. Charge Terms Code;Code10      ;TableRelation="Finance Charge Terms";
                                                   CaptionML=[DAN=Rentebetingelseskode;
                                                              ENU=Fin. Charge Terms Code] }
    { 29  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   OnValidate=BEGIN
                                                                ValidateSalesPersonCode;
                                                              END;

                                                   CaptionML=[DAN=S‘lgerkode;
                                                              ENU=Salesperson Code] }
    { 30  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   OnValidate=BEGIN
                                                                UpdateShipmentMethodId;
                                                              END;

                                                   CaptionML=[DAN=Leveringskode;
                                                              ENU=Shipment Method Code] }
    { 31  ;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   OnValidate=BEGIN
                                                                IF "Shipping Agent Code" <> xRec."Shipping Agent Code" THEN
                                                                  VALIDATE("Shipping Agent Service Code",'');
                                                              END;

                                                   AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Spedit›rkode;
                                                              ENU=Shipping Agent Code] }
    { 32  ;   ;Place of Export     ;Code20        ;CaptionML=[DAN=Udpassagested;
                                                              ENU=Place of Export] }
    { 33  ;   ;Invoice Disc. Code  ;Code20        ;TableRelation=Customer;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Fakturarabatkode;
                                                              ENU=Invoice Disc. Code] }
    { 34  ;   ;Customer Disc. Group;Code20        ;TableRelation="Customer Discount Group";
                                                   CaptionML=[DAN=Debitorrabatgruppe;
                                                              ENU=Customer Disc. Group] }
    { 35  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCountryCode(City,"Post Code",County,"Country/Region Code");
                                                                IF "Country/Region Code" <> xRec."Country/Region Code" THEN
                                                                  VATRegistrationValidation;
                                                              END;

                                                   CaptionML=[DAN=Lande-/omr†dekode;
                                                              ENU=Country/Region Code] }
    { 36  ;   ;Collection Method   ;Code20        ;CaptionML=[DAN=Opkr‘vningskode;
                                                              ENU=Collection Method] }
    { 37  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 38  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Comment Line" WHERE (Table Name=CONST(Customer),
                                                                                           No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 39  ;   ;Blocked             ;Option        ;OnValidate=VAR
                                                                CustLedgerEntry@1001 : Record 21;
                                                                AccountingPeriod@1002 : Record 50;
                                                                IdentityManagement@1000 : Codeunit 9801;
                                                              BEGIN
                                                                IF (Blocked <> Blocked::All) AND "Privacy Blocked" THEN
                                                                  IF GUIALLOWED THEN
                                                                    IF CONFIRM(ConfirmBlockedPrivacyBlockedQst) THEN
                                                                      "Privacy Blocked" := FALSE
                                                                    ELSE
                                                                      ERROR('')
                                                                  ELSE
                                                                    ERROR(CanNotChangeBlockedDueToPrivacyBlockedErr);

                                                                IF NOT IdentityManagement.IsInvAppId THEN
                                                                  EXIT;

                                                                CustLedgerEntry.RESET;
                                                                CustLedgerEntry.SETCURRENTKEY("Customer No.","Posting Date");
                                                                CustLedgerEntry.SETRANGE("Customer No.","No.");
                                                                AccountingPeriod.SETRANGE(Closed,FALSE);
                                                                IF AccountingPeriod.FINDFIRST THEN
                                                                  CustLedgerEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
                                                                IF NOT CustLedgerEntry.ISEMPTY THEN
                                                                  ERROR(CannotDeleteBecauseInInvErr,TABLECAPTION);
                                                              END;

                                                   CaptionML=[DAN=Sp‘rret;
                                                              ENU=Blocked];
                                                   OptionCaptionML=[DAN=" ,Lever,Fakturer,Alle";
                                                                    ENU=" ,Ship,Invoice,All"];
                                                   OptionString=[ ,Ship,Invoice,All] }
    { 40  ;   ;Invoice Copies      ;Integer       ;CaptionML=[DAN=Antal fakturakopier;
                                                              ENU=Invoice Copies] }
    { 41  ;   ;Last Statement No.  ;Integer       ;CaptionML=[DAN=Sidste kontoudtogsnr.;
                                                              ENU=Last Statement No.] }
    { 42  ;   ;Print Statements    ;Boolean       ;CaptionML=[DAN=Udskriv kontoudtog;
                                                              ENU=Print Statements] }
    { 45  ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.] }
    { 46  ;   ;Priority            ;Integer       ;CaptionML=[DAN=Prioritet;
                                                              ENU=Priority] }
    { 47  ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   OnValidate=VAR
                                                                PaymentMethod@1000 : Record 289;
                                                              BEGIN
                                                                UpdatePaymentMethodId;

                                                                IF "Payment Method Code" = '' THEN
                                                                  EXIT;

                                                                PaymentMethod.GET("Payment Method Code");
                                                                IF PaymentMethod."Direct Debit" AND ("Payment Terms Code" = '') THEN
                                                                  VALIDATE("Payment Terms Code",PaymentMethod."Direct Debit Pmt. Terms Code");
                                                              END;

                                                   CaptionML=[DAN=Betalingsformskode;
                                                              ENU=Payment Method Code] }
    { 53  ;   ;Last Modified Date Time;DateTime   ;CaptionML=[DAN=Dato/klokkesl‘t for seneste ‘ndring;
                                                              ENU=Last Modified Date Time];
                                                   Editable=No }
    { 54  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 55  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 56  ;   ;Global Dimension 1 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-filter;
                                                              ENU=Global Dimension 1 Filter];
                                                   CaptionClass='1,3,1' }
    { 57  ;   ;Global Dimension 2 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-filter;
                                                              ENU=Global Dimension 2 Filter];
                                                   CaptionClass='1,3,2' }
    { 58  ;   ;Balance             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Saldo;
                                                              ENU=Balance];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Balance (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Saldo (RV);
                                                              ENU=Balance (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 60  ;   ;Net Change          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Bev‘gelse;
                                                              ENU=Net Change];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Net Change (LCY)    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Bev‘gelse (RV);
                                                              ENU=Net Change (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 62  ;   ;Sales (LCY)         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cust. Ledger Entry"."Sales (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                             Posting Date=FIELD(Date Filter),
                                                                                                             Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Salg (RV);
                                                              ENU=Sales (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 63  ;   ;Profit (LCY)        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cust. Ledger Entry"."Profit (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                              Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                              Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Avancebel›b (RV);
                                                              ENU=Profit (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 64  ;   ;Inv. Discounts (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cust. Ledger Entry"."Inv. Discount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                     Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Posting Date=FIELD(Date Filter),
                                                                                                                     Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Fakt.rabatbel›b (RV);
                                                              ENU=Inv. Discounts (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 65  ;   ;Pmt. Discounts (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(Payment Discount..'Payment Discount (VAT Adjustment)'),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Kontantrabat (RV);
                                                              ENU=Pmt. Discounts (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 66  ;   ;Balance Due         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                              Initial Entry Due Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Forf. bel›b;
                                                              ENU=Balance Due];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 67  ;   ;Balance Due (LCY)   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Due Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Forf. bel›b (RV);
                                                              ENU=Balance Due (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 69  ;   ;Payments            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Payment),
                                                                                                               Entry Type=CONST(Initial Entry),
                                                                                                               Customer No.=FIELD(No.),
                                                                                                               Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                               Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                               Posting Date=FIELD(Date Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Betalinger;
                                                              ENU=Payments];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 70  ;   ;Invoice Amounts     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Invoice),
                                                                                                              Entry Type=CONST(Initial Entry),
                                                                                                              Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Fakturabel›b;
                                                              ENU=Invoice Amounts];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 71  ;   ;Cr. Memo Amounts    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Credit Memo),
                                                                                                               Entry Type=CONST(Initial Entry),
                                                                                                               Customer No.=FIELD(No.),
                                                                                                               Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                               Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                               Posting Date=FIELD(Date Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Kreditnotabel›b;
                                                              ENU=Cr. Memo Amounts];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 72  ;   ;Finance Charge Memo Amounts;Decimal;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                                                              Entry Type=CONST(Initial Entry),
                                                                                                              Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Rentenotabel›b;
                                                              ENU=Finance Charge Memo Amounts];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 74  ;   ;Payments (LCY)      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Payment),
                                                                                                                       Entry Type=CONST(Initial Entry),
                                                                                                                       Customer No.=FIELD(No.),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Betalt (RV);
                                                              ENU=Payments (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 75  ;   ;Inv. Amounts (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Invoice),
                                                                                                                      Entry Type=CONST(Initial Entry),
                                                                                                                      Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Fakturabel›b (RV);
                                                              ENU=Inv. Amounts (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 76  ;   ;Cr. Memo Amounts (LCY);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Credit Memo),
                                                                                                                       Entry Type=CONST(Initial Entry),
                                                                                                                       Customer No.=FIELD(No.),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Kr.notabel›b (RV);
                                                              ENU=Cr. Memo Amounts (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 77  ;   ;Fin. Charge Memo Amounts (LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                                                                      Entry Type=CONST(Initial Entry),
                                                                                                                      Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Rentenotabel›b (RV);
                                                              ENU=Fin. Charge Memo Amounts (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 78  ;   ;Outstanding Orders  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Outstanding Amount" WHERE (Document Type=CONST(Order),
                                                                                                            Bill-to Customer No.=FIELD(No.),
                                                                                                            Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                            Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                            Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Udest†ende ordrer;
                                                              ENU=Outstanding Orders];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 79  ;   ;Shipped Not Invoiced;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Shipped Not Invoiced" WHERE (Document Type=CONST(Order),
                                                                                                              Bill-to Customer No.=FIELD(No.),
                                                                                                              Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                              Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Lev. bel›b (ufakt.);
                                                              ENU=Shipped Not Invoiced];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 80  ;   ;Application Method  ;Option        ;CaptionML=[DAN=Udligningsmetode;
                                                              ENU=Application Method];
                                                   OptionCaptionML=[DAN=Manuelt,Saldo;
                                                                    ENU=Manual,Apply to Oldest];
                                                   OptionString=Manual,Apply to Oldest }
    { 82  ;   ;Prices Including VAT;Boolean       ;CaptionML=[DAN=Priser inkl. moms;
                                                              ENU=Prices Including VAT] }
    { 83  ;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 84  ;   ;Fax No.             ;Text30        ;CaptionML=[DAN=Telefax;
                                                              ENU=Fax No.] }
    { 85  ;   ;Telex Answer Back   ;Text20        ;CaptionML=[DAN=Telex (tilbagesvar);
                                                              ENU=Telex Answer Back] }
    { 86  ;   ;VAT Registration No.;Text20        ;OnValidate=BEGIN
                                                                "VAT Registration No." := UPPERCASE("VAT Registration No.");
                                                                IF "VAT Registration No." <> xRec."VAT Registration No." THEN
                                                                  VATRegistrationValidation;
                                                              END;

                                                   CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
    { 87  ;   ;Combine Shipments   ;Boolean       ;AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Tillad samlefaktura;
                                                              ENU=Combine Shipments] }
    { 88  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Virksomhedsbogf›ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 89  ;   ;Picture             ;BLOB          ;CaptionML=[DAN=Billede;
                                                              ENU=Picture];
                                                   SubType=Bitmap }
    { 90  ;   ;GLN                 ;Code13        ;OnValidate=VAR
                                                                GLNCalculator@1000 : Codeunit 1607;
                                                              BEGIN
                                                                IF GLN <> '' THEN
                                                                  GLNCalculator.AssertValidCheckDigit13(GLN);

                                                                IF (GLN <> '') AND ("OIOUBL Profile Code" = '') THEN
                                                                  SetDefaultProfileCode;
                                                              END;

                                                   CaptionML=[DAN=GLN;
                                                              ENU=GLN];
                                                   Numeric=Yes }
    { 91  ;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 92  ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 97  ;   ;Debit Amount        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Debit Amount" WHERE (Customer No.=FIELD(No.),
                                                                                                                      Entry Type=FILTER(<>Application),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Debetbel›b;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 98  ;   ;Credit Amount       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Credit Amount" WHERE (Customer No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(<>Application),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Kreditbel›b;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 99  ;   ;Debit Amount (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Debit Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                            Entry Type=FILTER(<>Application),
                                                                                                                            Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                            Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                            Posting Date=FIELD(Date Filter),
                                                                                                                            Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Debetbel›b (RV);
                                                              ENU=Debit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 100 ;   ;Credit Amount (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                             Entry Type=FILTER(<>Application),
                                                                                                                             Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                             Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                             Posting Date=FIELD(Date Filter),
                                                                                                                             Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Kreditbel›b (RV);
                                                              ENU=Credit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 102 ;   ;E-Mail              ;Text80        ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                MailManagement.ValidateEmailAddressField("E-Mail");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Mail;
                                                              ENU=Email] }
    { 103 ;   ;Home Page           ;Text80        ;ExtendedDatatype=URL;
                                                   CaptionML=[DAN=Hjemmeside;
                                                              ENU=Home Page] }
    { 104 ;   ;Reminder Terms Code ;Code10        ;TableRelation="Reminder Terms";
                                                   CaptionML=[DAN=Rykkerbetingelseskode;
                                                              ENU=Reminder Terms Code] }
    { 105 ;   ;Reminder Amounts    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Reminder),
                                                                                                              Entry Type=CONST(Initial Entry),
                                                                                                              Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Rykkerbel›b;
                                                              ENU=Reminder Amounts];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 106 ;   ;Reminder Amounts (LCY);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Reminder),
                                                                                                                      Entry Type=CONST(Initial Entry),
                                                                                                                      Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Rykkerbel›b (RV);
                                                              ENU=Reminder Amounts (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 107 ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 108 ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   OnValidate=BEGIN
                                                                UpdateTaxAreaId;
                                                              END;

                                                   CaptionML=[DAN=Skatteomr†dekode;
                                                              ENU=Tax Area Code] }
    { 109 ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 110 ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   OnValidate=BEGIN
                                                                UpdateTaxAreaId;
                                                              END;

                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 111 ;   ;Currency Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Currency;
                                                   CaptionML=[DAN=Valutafilter;
                                                              ENU=Currency Filter] }
    { 113 ;   ;Outstanding Orders (LCY);Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                  Bill-to Customer No.=FIELD(No.),
                                                                                                                  Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Udest†ende ordrer (RV);
                                                              ENU=Outstanding Orders (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 114 ;   ;Shipped Not Invoiced (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Shipped Not Invoiced (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                    Bill-to Customer No.=FIELD(No.),
                                                                                                                    Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                    Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                    Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Lev. bel›b ufakt. (RV);
                                                              ENU=Shipped Not Invoiced (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 115 ;   ;Reserve             ;Option        ;InitValue=Optional;
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Reserver;
                                                              ENU=Reserve];
                                                   OptionCaptionML=[DAN=Aldrig,Eventuelt,Altid;
                                                                    ENU=Never,Optional,Always];
                                                   OptionString=Never,Optional,Always }
    { 116 ;   ;Block Payment Tolerance;Boolean    ;OnValidate=BEGIN
                                                                UpdatePaymentTolerance((CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   CaptionML=[DAN=Ingen betalingstolerance;
                                                              ENU=Block Payment Tolerance] }
    { 117 ;   ;Pmt. Disc. Tolerance (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(Payment Discount Tolerance|'Payment Discount Tolerance (VAT Adjustment)'|'Payment Discount Tolerance (VAT Excl.)'),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Kont.rabattolerance (RV);
                                                              ENU=Pmt. Disc. Tolerance (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 118 ;   ;Pmt. Tolerance (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Customer No.=FIELD(No.),
                                                                                                                       Entry Type=FILTER(Payment Tolerance|'Payment Tolerance (VAT Adjustment)'|'Payment Tolerance (VAT Excl.)'),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Betalingstolerance (RV);
                                                              ENU=Pmt. Tolerance (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 119 ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   OnValidate=VAR
                                                                CustLedgEntry@1001 : Record 21;
                                                                AccountingPeriod@1000 : Record 50;
                                                                ICPartner@1002 : Record 413;
                                                              BEGIN
                                                                IF xRec."IC Partner Code" <> "IC Partner Code" THEN BEGIN
                                                                  IF NOT CustLedgEntry.SETCURRENTKEY("Customer No.",Open) THEN
                                                                    CustLedgEntry.SETCURRENTKEY("Customer No.");
                                                                  CustLedgEntry.SETRANGE("Customer No.","No.");
                                                                  CustLedgEntry.SETRANGE(Open,TRUE);
                                                                  IF CustLedgEntry.FINDLAST THEN
                                                                    ERROR(Text012,FIELDCAPTION("IC Partner Code"),TABLECAPTION);

                                                                  CustLedgEntry.RESET;
                                                                  CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
                                                                  CustLedgEntry.SETRANGE("Customer No.","No.");
                                                                  AccountingPeriod.SETRANGE(Closed,FALSE);
                                                                  IF AccountingPeriod.FINDFIRST THEN BEGIN
                                                                    CustLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
                                                                    IF CustLedgEntry.FINDFIRST THEN
                                                                      IF NOT CONFIRM(Text011,FALSE,TABLECAPTION) THEN
                                                                        "IC Partner Code" := xRec."IC Partner Code";
                                                                  END;
                                                                END;

                                                                IF "IC Partner Code" <> '' THEN BEGIN
                                                                  ICPartner.GET("IC Partner Code");
                                                                  IF (ICPartner."Customer No." <> '') AND (ICPartner."Customer No." <> "No.") THEN
                                                                    ERROR(Text010,FIELDCAPTION("IC Partner Code"),"IC Partner Code",TABLECAPTION,ICPartner."Customer No.");
                                                                  ICPartner."Customer No." := "No.";
                                                                  ICPartner.MODIFY;
                                                                END;

                                                                IF (xRec."IC Partner Code" <> "IC Partner Code") AND ICPartner.GET(xRec."IC Partner Code") THEN BEGIN
                                                                  ICPartner."Customer No." := '';
                                                                  ICPartner.MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=IC-partner kode;
                                                              ENU=IC Partner Code] }
    { 120 ;   ;Refunds             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Refund),
                                                                                                              Entry Type=CONST(Initial Entry),
                                                                                                              Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Refusioner;
                                                              ENU=Refunds] }
    { 121 ;   ;Refunds (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Refund),
                                                                                                                      Entry Type=CONST(Initial Entry),
                                                                                                                      Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Refusioner (RV);
                                                              ENU=Refunds (LCY)] }
    { 122 ;   ;Other Amounts       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Initial Document Type=CONST(" "),
                                                                                                              Entry Type=CONST(Initial Entry),
                                                                                                              Customer No.=FIELD(No.),
                                                                                                              Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                              Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                              Posting Date=FIELD(Date Filter),
                                                                                                              Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Andre bel›b;
                                                              ENU=Other Amounts] }
    { 123 ;   ;Other Amounts (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(" "),
                                                                                                                      Entry Type=CONST(Initial Entry),
                                                                                                                      Customer No.=FIELD(No.),
                                                                                                                      Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                      Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Andre bel›b (RV);
                                                              ENU=Other Amounts (LCY)] }
    { 124 ;   ;Prepayment %        ;Decimal       ;CaptionML=[DAN=Forudbetaling i %;
                                                              ENU=Prepayment %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 125 ;   ;Outstanding Invoices (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Invoice),
                                                                                                                  Bill-to Customer No.=FIELD(No.),
                                                                                                                  Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Udest†ende fakturaer (RV);
                                                              ENU=Outstanding Invoices (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 126 ;   ;Outstanding Invoices;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Outstanding Amount" WHERE (Document Type=CONST(Invoice),
                                                                                                            Bill-to Customer No.=FIELD(No.),
                                                                                                            Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                            Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                            Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Udest†ende fakturaer;
                                                              ENU=Outstanding Invoices];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 130 ;   ;Bill-to No. Of Archived Doc.;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header Archive" WHERE (Document Type=CONST(Order),
                                                                                                   Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureres til kunde - antal arkiverede dok.;
                                                              ENU=Bill-to No. Of Archived Doc.] }
    { 131 ;   ;Sell-to No. Of Archived Doc.;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header Archive" WHERE (Document Type=CONST(Order),
                                                                                                   Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Kunde - antal arkiverede dok.;
                                                              ENU=Sell-to No. Of Archived Doc.] }
    { 132 ;   ;Partner Type        ;Option        ;CaptionML=[DAN=Partnertype;
                                                              ENU=Partner Type];
                                                   OptionCaptionML=[DAN=" ,Virksomhed,Person";
                                                                    ENU=" ,Company,Person"];
                                                   OptionString=[ ,Company,Person] }
    { 140 ;   ;Image               ;Media         ;ExtendedDatatype=Person;
                                                   CaptionML=[DAN=Grafik;
                                                              ENU=Image] }
    { 150 ;   ;Privacy Blocked     ;Boolean       ;OnValidate=BEGIN
                                                                IF "Privacy Blocked" THEN
                                                                  Blocked := Blocked::All
                                                                ELSE
                                                                  Blocked := Blocked::" ";
                                                              END;

                                                   CaptionML=[DAN=Beskyttelse af personlige oplysninger sp‘rret;
                                                              ENU=Privacy Blocked] }
    { 288 ;   ;Preferred Bank Account Code;Code20 ;TableRelation="Customer Bank Account".Code WHERE (Customer No.=FIELD(No.));
                                                   CaptionML=[DAN=Foretrukken bankkontokode;
                                                              ENU=Preferred Bank Account Code] }
    { 840 ;   ;Cash Flow Payment Terms Code;Code10;TableRelation="Payment Terms";
                                                   CaptionML=[DAN=Pengestr›msbetalingsbeting.kode;
                                                              ENU=Cash Flow Payment Terms Code] }
    { 5049;   ;Primary Contact No. ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                Cont@1000 : Record 5050;
                                                                ContBusRel@1001 : Record 5054;
                                                              BEGIN
                                                                Contact := '';
                                                                IF "Primary Contact No." <> '' THEN BEGIN
                                                                  Cont.GET("Primary Contact No.");

                                                                  ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                                  ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                                                                  ContBusRel.SETRANGE("No.","No.");
                                                                  ContBusRel.FINDFIRST;

                                                                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                                                                    ERROR(Text003,Cont."No.",Cont.Name,"No.",Name);

                                                                  IF Cont.Type = Cont.Type::Person THEN
                                                                    Contact := Cont.Name;

                                                                  IF Cont.Image.HASVALUE THEN
                                                                    CopyContactPicture(Cont);

                                                                  IF Cont."Phone No." <> '' THEN
                                                                    "Phone No." := Cont."Phone No.";
                                                                  IF Cont."E-Mail" <> '' THEN
                                                                    "E-Mail" := Cont."E-Mail";
                                                                END ELSE
                                                                  IF Image.HASVALUE THEN
                                                                    CLEAR(Image);
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1000 : Record 5050;
                                                              ContBusRel@1001 : Record 5054;
                                                              TempCust@1002 : TEMPORARY Record 18;
                                                            BEGIN
                                                              ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                                                              ContBusRel.SETRANGE("No.","No.");
                                                              IF ContBusRel.FINDFIRST THEN
                                                                Cont.SETRANGE("Company No.",ContBusRel."Contact No.")
                                                              ELSE
                                                                Cont.SETRANGE("No.",'');

                                                              IF "Primary Contact No." <> '' THEN
                                                                IF Cont.GET("Primary Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                                                                TempCust.COPY(Rec);
                                                                FIND;
                                                                TRANSFERFIELDS(TempCust,FALSE);
                                                                VALIDATE("Primary Contact No.",Cont."No.");
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Prim‘rkontaktnr.;
                                                              ENU=Primary Contact No.] }
    { 5050;   ;Contact Type        ;Option        ;CaptionML=[DAN=Kontakttype;
                                                              ENU=Contact Type];
                                                   OptionCaptionML=[DAN=Virksomhed,Person;
                                                                    ENU=Company,Person];
                                                   OptionString=Company,Person }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 5750;   ;Shipping Advice     ;Option        ;AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Afsendelsesadvis;
                                                              ENU=Shipping Advice];
                                                   OptionCaptionML=[DAN=Delvis,Komplet;
                                                                    ENU=Partial,Complete];
                                                   OptionString=Partial,Complete }
    { 5790;   ;Shipping Time       ;DateFormula   ;AccessByPermission=TableData 5790=R;
                                                   CaptionML=[DAN=Transporttid;
                                                              ENU=Shipping Time] }
    { 5792;   ;Shipping Agent Service Code;Code10 ;TableRelation="Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));
                                                   OnValidate=BEGIN
                                                                IF ("Shipping Agent Code" <> '') AND
                                                                   ("Shipping Agent Service Code" <> '')
                                                                THEN
                                                                  IF ShippingAgentService.GET("Shipping Agent Code","Shipping Agent Service Code") THEN
                                                                    "Shipping Time" := ShippingAgentService."Shipping Time"
                                                                  ELSE
                                                                    EVALUATE("Shipping Time",'<>');
                                                              END;

                                                   CaptionML=[DAN=Spedit›rservicekode;
                                                              ENU=Shipping Agent Service Code] }
    { 5900;   ;Service Zone Code   ;Code10        ;TableRelation="Service Zone";
                                                   CaptionML=[DAN=Servicezonekode;
                                                              ENU=Service Zone Code] }
    { 5902;   ;Contract Gain/Loss Amount;Decimal  ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Contract Gain/Loss Entry".Amount WHERE (Customer No.=FIELD(No.),
                                                                                                            Ship-to Code=FIELD(Ship-to Filter),
                                                                                                            Change Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kontraktgevinst/-tab (bel›b);
                                                              ENU=Contract Gain/Loss Amount];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5903;   ;Ship-to Filter      ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(No.));
                                                   CaptionML=[DAN=Leveringsfilter;
                                                              ENU=Ship-to Filter] }
    { 5910;   ;Outstanding Serv. Orders (LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                    Bill-to Customer No.=FIELD(No.),
                                                                                                                    Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                    Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                    Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Udest†ende serviceordrer (RV);
                                                              ENU=Outstanding Serv. Orders (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5911;   ;Serv Shipped Not Invoiced(LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Line"."Shipped Not Invoiced (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                      Bill-to Customer No.=FIELD(No.),
                                                                                                                      Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                      Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                      Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Service sendt, men ikke faktureret (RV);
                                                              ENU=Serv Shipped Not Invoiced(LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5912;   ;Outstanding Serv.Invoices(LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Service Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Invoice),
                                                                                                                    Bill-to Customer No.=FIELD(No.),
                                                                                                                    Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                    Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                    Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Udest†ende servicefakturaer (RV);
                                                              ENU=Outstanding Serv.Invoices(LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 7001;   ;Allow Line Disc.    ;Boolean       ;InitValue=Yes;
                                                   CaptionML=[DAN=Tillad linjerabat;
                                                              ENU=Allow Line Disc.] }
    { 7171;   ;No. of Quotes       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Quote),
                                                                                           Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal tilbud;
                                                              ENU=No. of Quotes];
                                                   Editable=No }
    { 7172;   ;No. of Blanket Orders;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Blanket Order),
                                                                                           Sell-to Customer No.=FIELD(No.)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Antal rammeordrer;
                                                              ENU=No. of Blanket Orders];
                                                   Editable=No }
    { 7173;   ;No. of Orders       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Order),
                                                                                           Sell-to Customer No.=FIELD(No.)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Antal ordrer;
                                                              ENU=No. of Orders];
                                                   Editable=No }
    { 7174;   ;No. of Invoices     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Invoice),
                                                                                           Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal fakturaer;
                                                              ENU=No. of Invoices];
                                                   Editable=No }
    { 7175;   ;No. of Return Orders;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Return Order),
                                                                                           Sell-to Customer No.=FIELD(No.)));
                                                   AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Antal returordrer;
                                                              ENU=No. of Return Orders];
                                                   Editable=No }
    { 7176;   ;No. of Credit Memos ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Credit Memo),
                                                                                           Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal kreditnotaer;
                                                              ENU=No. of Credit Memos];
                                                   Editable=No }
    { 7177;   ;No. of Pstd. Shipments;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Shipment Header" WHERE (Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal bogf›rte leveringer;
                                                              ENU=No. of Pstd. Shipments];
                                                   Editable=No }
    { 7178;   ;No. of Pstd. Invoices;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Invoice Header" WHERE (Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal bogf›rte fakturaer;
                                                              ENU=No. of Pstd. Invoices];
                                                   Editable=No }
    { 7179;   ;No. of Pstd. Return Receipts;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Return Receipt Header" WHERE (Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal bogf›rte returvaremodt.;
                                                              ENU=No. of Pstd. Return Receipts];
                                                   Editable=No }
    { 7180;   ;No. of Pstd. Credit Memos;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Cr.Memo Header" WHERE (Sell-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal bogf›rte kreditnotaer;
                                                              ENU=No. of Pstd. Credit Memos];
                                                   Editable=No }
    { 7181;   ;No. of Ship-to Addresses;Integer   ;FieldClass=FlowField;
                                                   CalcFormula=Count("Ship-to Address" WHERE (Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal leveringsadresser;
                                                              ENU=No. of Ship-to Addresses];
                                                   Editable=No }
    { 7182;   ;Bill-To No. of Quotes;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Quote),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureres - Antal tilbud;
                                                              ENU=Bill-To No. of Quotes];
                                                   Editable=No }
    { 7183;   ;Bill-To No. of Blanket Orders;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Blanket Order),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Faktureres - Antal rammeordrer;
                                                              ENU=Bill-To No. of Blanket Orders];
                                                   Editable=No }
    { 7184;   ;Bill-To No. of Orders;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Order),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   AccessByPermission=TableData 110=R;
                                                   CaptionML=[DAN=Faktureres - Antal ordrer;
                                                              ENU=Bill-To No. of Orders];
                                                   Editable=No }
    { 7185;   ;Bill-To No. of Invoices;Integer    ;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Invoice),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureres - Antal fakturaer;
                                                              ENU=Bill-To No. of Invoices];
                                                   Editable=No }
    { 7186;   ;Bill-To No. of Return Orders;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Return Order),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   AccessByPermission=TableData 6660=R;
                                                   CaptionML=[DAN=Faktureres - Antal returordrer;
                                                              ENU=Bill-To No. of Return Orders];
                                                   Editable=No }
    { 7187;   ;Bill-To No. of Credit Memos;Integer;FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Header" WHERE (Document Type=CONST(Credit Memo),
                                                                                           Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureres - Antal kreditnotaer;
                                                              ENU=Bill-To No. of Credit Memos];
                                                   Editable=No }
    { 7188;   ;Bill-To No. of Pstd. Shipments;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Shipment Header" WHERE (Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureres - Antal bogf›rte leveringer;
                                                              ENU=Bill-To No. of Pstd. Shipments];
                                                   Editable=No }
    { 7189;   ;Bill-To No. of Pstd. Invoices;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Invoice Header" WHERE (Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureres - Antal bogf›rte fakturaer;
                                                              ENU=Bill-To No. of Pstd. Invoices];
                                                   Editable=No }
    { 7190;   ;Bill-To No. of Pstd. Return R.;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Return Receipt Header" WHERE (Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureres - Antal bogf›rte returvaremodtagelser;
                                                              ENU=Bill-To No. of Pstd. Return R.];
                                                   Editable=No }
    { 7191;   ;Bill-To No. of Pstd. Cr. Memos;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Sales Cr.Memo Header" WHERE (Bill-to Customer No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureres - Antal bogf›rte kreditnotaer;
                                                              ENU=Bill-To No. of Pstd. Cr. Memos];
                                                   Editable=No }
    { 7600;   ;Base Calendar Code  ;Code10        ;TableRelation="Base Calendar";
                                                   CaptionML=[DAN=Basiskalenderkode;
                                                              ENU=Base Calendar Code] }
    { 7601;   ;Copy Sell-to Addr. to Qte From;Option;
                                                   AccessByPermission=TableData 5050=R;
                                                   CaptionML=[DAN=Kopi‚r kundeadr. til tilb. fra;
                                                              ENU=Copy Sell-to Addr. to Qte From];
                                                   OptionCaptionML=[DAN=Virksomhed,Person;
                                                                    ENU=Company,Person];
                                                   OptionString=Company,Person }
    { 7602;   ;Validate EU Vat Reg. No.;Boolean   ;CaptionML=[DAN=Kontroll‚r SE/CVR-nr. for EU;
                                                              ENU=Validate EU Vat Reg. No.] }
    { 8000;   ;Id                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=Id] }
    { 8001;   ;Currency Id         ;GUID          ;TableRelation=Currency.Id;
                                                   OnValidate=BEGIN
                                                                UpdateCurrencyCode;
                                                              END;

                                                   CaptionML=[DAN=Valuta-id;
                                                              ENU=Currency Id] }
    { 8002;   ;Payment Terms Id    ;GUID          ;TableRelation="Payment Terms".Id;
                                                   OnValidate=BEGIN
                                                                UpdatePaymentTermsCode;
                                                              END;

                                                   CaptionML=[DAN=Id for betalingsbetingelser;
                                                              ENU=Payment Terms Id] }
    { 8003;   ;Shipment Method Id  ;GUID          ;TableRelation="Shipment Method".Id;
                                                   OnValidate=BEGIN
                                                                UpdateShipmentMethodCode;
                                                              END;

                                                   CaptionML=[DAN=Id for leveringsform;
                                                              ENU=Shipment Method Id] }
    { 8004;   ;Payment Method Id   ;GUID          ;TableRelation="Payment Method".Id;
                                                   OnValidate=BEGIN
                                                                UpdatePaymentMethodCode;
                                                              END;

                                                   CaptionML=[DAN=Id for betalingsform;
                                                              ENU=Payment Method Id] }
    { 9003;   ;Tax Area ID         ;GUID          ;OnValidate=BEGIN
                                                                UpdateTaxAreaCode;
                                                              END;

                                                   CaptionML=[DAN=Skatteomr†de-id;
                                                              ENU=Tax Area ID] }
    { 9004;   ;Tax Area Display Name;Text50       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("Tax Area".Description WHERE (Code=FIELD(Tax Area Code)));
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=This field is not needed and it should not be used.;
                                                   CaptionML=[DAN=Visningsnavn for skatteomr†de;
                                                              ENU=Tax Area Display Name] }
    { 9005;   ;Contact ID          ;GUID          ;CaptionML=[DAN=Kontakt-id;
                                                              ENU=Contact ID] }
    { 9006;   ;Contact Graph Id    ;Text250       ;CaptionML=[DAN=Graph-id for kontakt;
                                                              ENU=Contact Graph Id] }
    { 13600;  ;EAN No.             ;Code13        ;OnValidate=BEGIN
                                                                IF "EAN No." = '' THEN
                                                                  EXIT;
                                                                IF NOT OIOXMLDocumentEncode.IsValidEANNo("EAN No.") THEN
                                                                  FIELDERROR("EAN No.",Text13606);
                                                                IF ("EAN No." <> '') AND ("OIOUBL Profile Code" = '') THEN
                                                                  SetDefaultProfileCode;
                                                              END;

                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=EAN-nr.;
                                                              ENU=EAN No.] }
    { 13601;  ;Account Code        ;Text30        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontokode;
                                                              ENU=Account Code] }
    { 13604;  ;OIOUBL Profile Code ;Code10        ;TableRelation="OIOUBL Profile";
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=OIOUBL-profilkode;
                                                              ENU=OIOUBL Profile Code] }
    { 13605;  ;OIOUBL Profile Code Required;Boolean;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=OIOUBL-profilkode kr‘ves;
                                                              ENU=OIOUBL Profile Code Required] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Name                              }
    {    ;Customer Posting Group                   }
    {    ;Currency Code                            }
    {    ;Country/Region Code                      }
    {    ;Gen. Bus. Posting Group                  }
    {    ;Name,Address,City                        }
    {    ;VAT Registration No.                     }
    {    ;Name                                     }
    {    ;City                                     }
    {    ;Post Code                                }
    {    ;Phone No.                                }
    {    ;Contact                                  }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Name,City,Post Code,Phone No.,Contact }
    { 2   ;Brick               ;No.,Name,Balance (LCY),Contact,Balance Due (LCY),Image }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der findes ‚n eller flere udest†ende forekomster af salgs%3 for denne debitor.;ENU=You cannot delete %1 %2 because there is at least one outstanding Sales %3 for this customer.';
      Text002@1001 : TextConst 'DAN=Vil du oprette en attentionpost for %1 %2?;ENU=Do you wish to create a contact for %1 %2?';
      SalesSetup@1002 : Record 311;
      CommentLine@1004 : Record 97;
      SalesOrderLine@1005 : Record 37;
      CustBankAcc@1006 : Record 287;
      ShipToAddr@1007 : Record 222;
      PostCode@1008 : Record 225;
      GenBusPostingGrp@1009 : Record 250;
      ShippingAgentService@1010 : Record 5790;
      ItemCrossReference@1016 : Record 5717;
      RMSetup@1018 : Record 5079;
      SalesPrice@1021 : Record 7002;
      SalesLineDisc@1022 : Record 7004;
      SalesPrepmtPct@1003 : Record 459;
      ServContract@1026 : Record 5965;
      ServiceItem@1027 : Record 5940;
      SalespersonPurchaser@1060 : Record 13;
      PaymentToleranceMgt@1038 : Codeunit 426;
      NoSeriesMgt@1011 : Codeunit 396;
      MoveEntries@1012 : Codeunit 361;
      UpdateContFromCust@1013 : Codeunit 5056;
      DimMgt@1014 : Codeunit 408;
      ApprovalsMgmt@1039 : Codeunit 1535;
      InsertFromContact@1015 : Boolean;
      Text003@1020 : TextConst 'DAN=Kontakten %1 %2 er ikke knyttet til debitoren %3 %4.;ENU=Contact %1 %2 is not related to customer %3 %4.';
      Text004@1023 : TextConst 'DAN=bogf›re;ENU=post';
      Text005@1024 : TextConst 'DAN=oprette;ENU=create';
      Text006@1025 : TextConst 'DAN=Du kan ikke %1 denne dokumenttype, n†r debitor %2 er sp‘rret med typen %3;ENU=You cannot %1 this type of document when Customer %2 is blocked with type %3';
      Text007@1028 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der findes mindst ‚n annulleret servicekontrakt til denne debitor.;ENU=You cannot delete %1 %2 because there is at least one not cancelled Service Contract for this customer.';
      Text008@1029 : TextConst 'DAN=Hvis du sletter %1 %2, vil %3 for de tilknyttede serviceartikler ogs† blive slettet. Vil du forts‘tte?;ENU=Deleting the %1 %2 will cause the %3 to be deleted for the associated Service Items. Do you want to continue?';
      Text009@1030 : TextConst 'DAN=Debitoren kan ikke slettes.;ENU=Cannot delete customer.';
      Text010@1031 : TextConst 'DAN=%1 %2 er tildelt til %3 %4.\Samme %1 kan ikke angives p† mere end ‚n/‚t %3. Angiv en anden kode.;ENU=The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3. Enter another code.';
      Text011@1033 : TextConst 'DAN=Afstemning af IC-transaktioner kan v‘re sv‘rt, hvis du ‘ndrer IC-partner kode, da denne %1 har poster i et regnskabs†r, der endnu ikke er blevet afsluttet.\Vil du stadig ‘ndre IC-partner kode?;ENU=Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
      Text012@1032 : TextConst 'DAN=Du kan ikke ‘ndre indholdet af feltet %1, fordi denne/dette %2 har en eller flere †bne poster.;ENU=You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
      Text013@1035 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der er mindst ‚n udest†ende service %3 for denne debitor.;ENU=You cannot delete %1 %2 because there is at least one outstanding Service %3 for this customer.';
      Text014@1017 : TextConst 'DAN=Vinduet Ops‘tning af Online Map skal udfyldes, f›r du kan bruge Online Map.\Se Ops‘tning af Online Map i Hj‘lp.;ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
      Text015@1036 : TextConst 'DAN=Du kan ikke slette %1 %2, da mindst ‚n %3 er knyttet til denne kunde.;ENU=You cannot delete %1 %2 because there is at least one %3 associated to this customer.';
      OIOXMLDocumentEncode@1101100000 : Codeunit 13600;
      Text13606@1101100001 : TextConst 'DAN=indeholder ikke et gyldigt 13-cifret EAN-nr.;ENU=does not contain a valid, 13-digit EAN No.';
      AllowPaymentToleranceQst@1037 : TextConst 'DAN=Vil du tillade betalingstolerance for poster, der aktuelt er †bne?;ENU=Do you want to allow payment tolerance for entries that are currently open?';
      RemovePaymentRoleranceQst@1019 : TextConst 'DAN=Vil du fjerne betalingstolerance fra poster, der aktuelt er †bne?;ENU=Do you want to remove payment tolerance from entries that are currently open?';
      CreateNewCustTxt@1041 : TextConst '@@@="%1 is the name to be used to create the customer. ";DAN=Opret et nyt debitorkort for %1;ENU=Create a new customer card for %1';
      SelectCustErr@1040 : TextConst 'DAN=Du skal v‘lge en eksisterende debitor.;ENU=You must select an existing customer.';
      CustNotRegisteredTxt@1042 : TextConst 'DAN=Denne debitor er ikke registreret. V‘lg en af f›lgende muligheder for at forts‘tte:;ENU=This customer is not registered. To continue, choose one of the following options:';
      SelectCustTxt@1043 : TextConst 'DAN=V‘lg en eksisterende debitor;ENU=Select an existing customer';
      InsertFromTemplate@1044 : Boolean;
      LookupRequested@1034 : Boolean;
      OverrideImageQst@1045 : TextConst 'DAN=Tilsides‘t grafik?;ENU=Override Image?';
      CannotDeleteBecauseInInvErr@1046 : TextConst '@@@="%1 = the object to be deleted (example: Item, Customer).";DAN=Du kan ikke slette %1, fordi den har †bne fakturaer.;ENU=You cannot delete %1 because it has open invoices.';
      PrivacyBlockedActionErr@1061 : TextConst '@@@="%1 = action (create or post), %2 = customer code.";DAN=Du kan ikke %1 denne bilagstype, n†r beskyttelse af personlige oplysninger sp‘rret for debitor %2.;ENU=You cannot %1 this type of document when Customer %2 is blocked for privacy.';
      PrivacyBlockedGenericTxt@1062 : TextConst '@@@="%1 = customer code";DAN=Beskyttelse af personlige oplysninger sp‘rret m† ikke v‘re g‘ldende for debitoren %1.;ENU=Privacy Blocked must not be true for customer %1.';
      ConfirmBlockedPrivacyBlockedQst@1071 : TextConst 'DAN=Hvis du ‘ndrer feltet Sp‘rret, ‘ndres feltet Beskyttelse af personlige oplysninger sp‘rret til Nej. Vil du forts‘tte?;ENU=If you change the Blocked field, the Privacy Blocked field is changed to No. Do you want to continue?';
      CanNotChangeBlockedDueToPrivacyBlockedErr@1072 : TextConst 'DAN=Feltet Sp‘rret kan ikke ‘ndres, fordi brugeren er blokeret af sikkerhedsm‘ssige †rsager.;ENU=The Blocked field cannot be changed because the user is blocked for privacy reasons.';

    [External]
    PROCEDURE AssistEdit@2(OldCust@1000 : Record 18) : Boolean;
    VAR
      Cust@1001 : Record 18;
    BEGIN
      WITH Cust DO BEGIN
        Cust := Rec;
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Customer Nos.");
        IF NoSeriesMgt.SelectSeries(SalesSetup."Customer Nos.",OldCust."No. Series","No. Series") THEN BEGIN
          NoSeriesMgt.SetSeries("No.");
          Rec := Cust;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Customer,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    END;

    [External]
    PROCEDURE ShowContact@1();
    VAR
      ContBusRel@1000 : Record 5054;
      Cont@1001 : Record 5050;
      OfficeContact@1002 : Record 5050;
      OfficeMgt@1003 : Codeunit 1630;
    BEGIN
      IF OfficeMgt.GetContact(OfficeContact,"No.") AND (OfficeContact.COUNT = 1) THEN
        PAGE.RUN(PAGE::"Contact Card",OfficeContact)
      ELSE BEGIN
        IF "No." = '' THEN
          EXIT;

        ContBusRel.SETCURRENTKEY("Link to Table","No.");
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
        ContBusRel.SETRANGE("No.","No.");
        IF NOT ContBusRel.FINDFIRST THEN BEGIN
          IF NOT CONFIRM(Text002,FALSE,TABLECAPTION,"No.") THEN
            EXIT;
          UpdateContFromCust.InsertNewContact(Rec,FALSE);
          ContBusRel.FINDFIRST;
        END;
        COMMIT;

        Cont.FILTERGROUP(2);
        Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
        IF Cont.ISEMPTY THEN BEGIN
          Cont.SETRANGE("Company No.");
          Cont.SETRANGE("No.",ContBusRel."Contact No.");
        END;
        PAGE.RUN(PAGE::"Contact List",Cont);
      END;
    END;

    [External]
    PROCEDURE SetInsertFromContact@3(FromContact@1000 : Boolean);
    BEGIN
      InsertFromContact := FromContact;
    END;

    [External]
    PROCEDURE CheckBlockedCustOnDocs@5(Cust2@1000 : Record 18;DocType@1001 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';Shipment@1005 : Boolean;Transaction@1003 : Boolean);
    BEGIN
      WITH Cust2 DO BEGIN
        IF "Privacy Blocked" THEN
          CustPrivacyBlockedErrorMessage(Cust2,Transaction);

        IF ((Blocked = Blocked::All) OR
            ((Blocked = Blocked::Invoice) AND
             (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"])) OR
            ((Blocked = Blocked::Ship) AND (DocType IN [DocType::Quote,DocType::Order,DocType::"Blanket Order"]) AND
             (NOT Transaction)) OR
            ((Blocked = Blocked::Ship) AND (DocType IN [DocType::Quote,DocType::Order,DocType::Invoice,DocType::"Blanket Order"]) AND
             Shipment AND Transaction))
        THEN
          CustBlockedErrorMessage(Cust2,Transaction);
      END;
    END;

    [External]
    PROCEDURE CheckBlockedCustOnJnls@7(Cust2@1003 : Record 18;DocType@1002 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';Transaction@1000 : Boolean);
    BEGIN
      WITH Cust2 DO BEGIN
        IF "Privacy Blocked" THEN
          CustPrivacyBlockedErrorMessage(Cust2,Transaction);

        IF (Blocked = Blocked::All) OR
           ((Blocked = Blocked::Invoice) AND (DocType IN [DocType::Invoice,DocType::" "]))
        THEN
          CustBlockedErrorMessage(Cust2,Transaction)
      END;
    END;

    [External]
    PROCEDURE CustBlockedErrorMessage@4(Cust2@1001 : Record 18;Transaction@1000 : Boolean);
    VAR
      Action@1002 : Text[30];
    BEGIN
      IF Transaction THEN
        Action := Text004
      ELSE
        Action := Text005;
      ERROR(Text006,Action,Cust2."No.",Cust2.Blocked);
    END;

    [External]
    PROCEDURE CustPrivacyBlockedErrorMessage@72(Cust2@1001 : Record 18;Transaction@1000 : Boolean);
    VAR
      Action@1002 : Text[30];
    BEGIN
      IF Transaction THEN
        Action := Text004
      ELSE
        Action := Text005;

      ERROR(PrivacyBlockedActionErr,Action,Cust2."No.");
    END;

    [Internal]
    PROCEDURE GetPrivacyBlockedGenericErrorText@73(Cust2@1001 : Record 18) : Text[250];
    BEGIN
      EXIT(STRSUBSTNO(PrivacyBlockedGenericTxt,Cust2."No."));
    END;

    [Internal]
    PROCEDURE DisplayMap@8();
    VAR
      MapPoint@1001 : Record 800;
      MapMgt@1000 : Codeunit 802;
    BEGIN
      IF MapPoint.FINDFIRST THEN
        MapMgt.MakeSelection(DATABASE::Customer,GETPOSITION)
      ELSE
        MESSAGE(Text014);
    END;

    [External]
    PROCEDURE GetTotalAmountLCY@10() : Decimal;
    BEGIN
      CALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)","Outstanding Invoices (LCY)",
        "Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");

      EXIT(GetTotalAmountLCYCommon);
    END;

    [External]
    PROCEDURE GetTotalAmountLCYUI@16() : Decimal;
    BEGIN
      SETAUTOCALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)","Outstanding Invoices (LCY)",
        "Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)","Outstanding Serv.Invoices(LCY)");

      EXIT(GetTotalAmountLCYCommon);
    END;

    LOCAL PROCEDURE GetTotalAmountLCYCommon@17() : Decimal;
    VAR
      SalesLine@1000 : Record 37;
      ServiceLine@1002 : Record 5902;
      SalesOutstandingAmountFromShipment@1001 : Decimal;
      ServOutstandingAmountFromShipment@1003 : Decimal;
      InvoicedPrepmtAmountLCY@1004 : Decimal;
    BEGIN
      SalesOutstandingAmountFromShipment := SalesLine.OutstandingInvoiceAmountFromShipment("No.");
      ServOutstandingAmountFromShipment := ServiceLine.OutstandingInvoiceAmountFromShipment("No.");
      InvoicedPrepmtAmountLCY := GetInvoicedPrepmtAmountLCY;

      EXIT("Balance (LCY)" + "Outstanding Orders (LCY)" + "Shipped Not Invoiced (LCY)" + "Outstanding Invoices (LCY)" +
        "Outstanding Serv. Orders (LCY)" + "Serv Shipped Not Invoiced(LCY)" + "Outstanding Serv.Invoices(LCY)" -
        SalesOutstandingAmountFromShipment - ServOutstandingAmountFromShipment - InvoicedPrepmtAmountLCY);
    END;

    [External]
    PROCEDURE GetSalesLCY@13() : Decimal;
    VAR
      CustomerSalesYTD@1005 : Record 18;
      AccountingPeriod@1004 : Record 50;
      StartDate@1001 : Date;
      EndDate@1000 : Date;
    BEGIN
      StartDate := AccountingPeriod.GetFiscalYearStartDate(WORKDATE);
      EndDate := AccountingPeriod.GetFiscalYearEndDate(WORKDATE);
      CustomerSalesYTD := Rec;
      CustomerSalesYTD."SECURITYFILTERING"("SECURITYFILTERING");
      CustomerSalesYTD.SETRANGE("Date Filter",StartDate,EndDate);
      CustomerSalesYTD.CALCFIELDS("Sales (LCY)");
      EXIT(CustomerSalesYTD."Sales (LCY)");
    END;

    [External]
    PROCEDURE CalcAvailableCredit@9() : Decimal;
    BEGIN
      EXIT(CalcAvailableCreditCommon(FALSE));
    END;

    [External]
    PROCEDURE CalcAvailableCreditUI@15() : Decimal;
    BEGIN
      EXIT(CalcAvailableCreditCommon(TRUE));
    END;

    LOCAL PROCEDURE CalcAvailableCreditCommon@14(CalledFromUI@1000 : Boolean) : Decimal;
    BEGIN
      IF "Credit Limit (LCY)" = 0 THEN
        EXIT(0);
      IF CalledFromUI THEN
        EXIT("Credit Limit (LCY)" - GetTotalAmountLCYUI);
      EXIT("Credit Limit (LCY)" - GetTotalAmountLCY);
    END;

    [External]
    PROCEDURE CalcOverdueBalance@11() OverDueBalance : Decimal;
    VAR
      CustLedgEntryRemainAmtQuery@1000 : Query 21 SECURITYFILTERING(Filtered);
    BEGIN
      CustLedgEntryRemainAmtQuery.SETRANGE(Customer_No,"No.");
      CustLedgEntryRemainAmtQuery.SETRANGE(IsOpen,TRUE);
      CustLedgEntryRemainAmtQuery.SETFILTER(Due_Date,'<%1',WORKDATE);
      CustLedgEntryRemainAmtQuery.OPEN;

      IF CustLedgEntryRemainAmtQuery.READ THEN
        OverDueBalance := CustLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    END;

    [External]
    PROCEDURE GetLegalEntityType@6() : Text;
    BEGIN
      EXIT(FORMAT("Partner Type"));
    END;

    [External]
    PROCEDURE GetLegalEntityTypeLbl@26() : Text;
    BEGIN
      EXIT(FIELDCAPTION("Partner Type"));
    END;

    [External]
    PROCEDURE SetStyle@12() : Text;
    BEGIN
      IF CalcAvailableCredit < 0 THEN
        EXIT('Unfavorable');
      EXIT('');
    END;

    PROCEDURE SetDefaultProfileCode@1060000();
    BEGIN
      SalesSetup.GET;
      "OIOUBL Profile Code" := SalesSetup."Default OIOUBL Profile Code";
    END;

    [External]
    PROCEDURE HasValidDDMandate@23(Date@1000 : Date) : Boolean;
    VAR
      SEPADirectDebitMandate@1001 : Record 1230;
    BEGIN
      EXIT(SEPADirectDebitMandate.GetDefaultMandate("No.",Date) <> '');
    END;

    [External]
    PROCEDURE GetInvoicedPrepmtAmountLCY@18() : Decimal;
    VAR
      SalesLine@1000 : Record 37;
    BEGIN
      SalesLine.SETCURRENTKEY("Document Type","Bill-to Customer No.");
      SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
      SalesLine.SETRANGE("Bill-to Customer No.","No.");
      SalesLine.CALCSUMS("Prepmt. Amount Inv. (LCY)","Prepmt. VAT Amount Inv. (LCY)");
      EXIT(SalesLine."Prepmt. Amount Inv. (LCY)" + SalesLine."Prepmt. VAT Amount Inv. (LCY)");
    END;

    [External]
    PROCEDURE CalcCreditLimitLCYExpendedPct@19() : Decimal;
    BEGIN
      IF "Credit Limit (LCY)" = 0 THEN
        EXIT(0);

      IF "Balance (LCY)" / "Credit Limit (LCY)" < 0 THEN
        EXIT(0);

      IF "Balance (LCY)" / "Credit Limit (LCY)" > 1 THEN
        EXIT(10000);

      EXIT(ROUND("Balance (LCY)" / "Credit Limit (LCY)" * 10000,1));
    END;

    [External]
    PROCEDURE CreateAndShowNewInvoice@21();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Sales Invoice",SalesHeader)
    END;

    [External]
    PROCEDURE CreateAndShowNewOrder@30();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Sales Order",SalesHeader)
    END;

    [External]
    PROCEDURE CreateAndShowNewCreditMemo@22();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Sales Credit Memo",SalesHeader)
    END;

    [External]
    PROCEDURE CreateAndShowNewQuote@24();
    VAR
      SalesHeader@1000 : Record 36;
    BEGIN
      SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
      SalesHeader.SETRANGE("Sell-to Customer No.","No.");
      SalesHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Sales Quote",SalesHeader)
    END;

    LOCAL PROCEDURE UpdatePaymentTolerance@20(UseDialog@1000 : Boolean);
    BEGIN
      IF "Block Payment Tolerance" THEN BEGIN
        IF UseDialog THEN
          IF NOT CONFIRM(RemovePaymentRoleranceQst,FALSE) THEN
            EXIT;
        PaymentToleranceMgt.DelTolCustLedgEntry(Rec);
      END ELSE BEGIN
        IF UseDialog THEN
          IF NOT CONFIRM(AllowPaymentToleranceQst,FALSE) THEN
            EXIT;
        PaymentToleranceMgt.CalcTolCustLedgEntry(Rec);
      END;
    END;

    [External]
    PROCEDURE GetBillToCustomerNo@27() : Code[20];
    BEGIN
      IF "Bill-to Customer No." <> '' THEN
        EXIT("Bill-to Customer No.");
      EXIT("No.");
    END;

    [External]
    PROCEDURE HasAddressIgnoreCountryCode@37() : Boolean;
    BEGIN
      CASE TRUE OF
        Address <> '':
          EXIT(TRUE);
        "Address 2" <> '':
          EXIT(TRUE);
        City <> '':
          EXIT(TRUE);
        County <> '':
          EXIT(TRUE);
        "Post Code" <> '':
          EXIT(TRUE);
        Contact <> '':
          EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE HasAddress@25() : Boolean;
    BEGIN
      EXIT(HasAddressIgnoreCountryCode OR ("Country/Region Code" <> ''));
    END;

    [External]
    PROCEDURE GetCustNo@44(CustomerText@1000 : Text) : Text;
    BEGIN
      EXIT(GetCustNoOpenCard(CustomerText,TRUE,TRUE));
    END;

    [External]
    PROCEDURE GetCustNoOpenCard@36(CustomerText@1000 : Text;ShowCustomerCard@1006 : Boolean;ShowCreateCustomerOption@1007 : Boolean) : Code[20];
    VAR
      Customer@1001 : Record 18;
      CustomerNo@1002 : Code[20];
      NoFiltersApplied@1008 : Boolean;
      CustomerWithoutQuote@1005 : Text;
      CustomerFilterFromStart@1004 : Text;
      CustomerFilterContains@1003 : Text;
    BEGIN
      IF CustomerText = '' THEN
        EXIT('');

      IF STRLEN(CustomerText) <= MAXSTRLEN(Customer."No.") THEN
        IF Customer.GET(COPYSTR(CustomerText,1,MAXSTRLEN(Customer."No."))) THEN
          EXIT(Customer."No.");

      Customer.SETRANGE(Blocked,Customer.Blocked::" ");
      Customer.SETRANGE(Name,CustomerText);
      IF Customer.FINDFIRST THEN
        EXIT(Customer."No.");

      CustomerWithoutQuote := CONVERTSTR(CustomerText,'''','?');
      Customer.SETFILTER(Name,'''@' + CustomerWithoutQuote + '''');
      IF Customer.FINDFIRST THEN
        EXIT(Customer."No.");
      Customer.SETRANGE(Name);

      CustomerFilterFromStart := '''@' + CustomerWithoutQuote + '*''';

      Customer.FILTERGROUP := -1;
      Customer.SETFILTER("No.",CustomerFilterFromStart);

      Customer.SETFILTER(Name,CustomerFilterFromStart);

      IF Customer.FINDFIRST THEN
        EXIT(Customer."No.");

      CustomerFilterContains := '''@*' + CustomerWithoutQuote + '*''';

      Customer.SETFILTER("No.",CustomerFilterContains);
      Customer.SETFILTER(Name,CustomerFilterContains);
      Customer.SETFILTER(City,CustomerFilterContains);
      Customer.SETFILTER(Contact,CustomerFilterContains);
      Customer.SETFILTER("Phone No.",CustomerFilterContains);
      Customer.SETFILTER("Post Code",CustomerFilterContains);

      IF Customer.COUNT = 0 THEN
        MarkCustomersWithSimilarName(Customer,CustomerText);

      IF Customer.COUNT = 1 THEN BEGIN
        Customer.FINDFIRST;
        EXIT(Customer."No.");
      END;

      IF NOT GUIALLOWED THEN
        ERROR(SelectCustErr);

      IF Customer.COUNT = 0 THEN BEGIN
        IF Customer.WRITEPERMISSION THEN
          IF ShowCreateCustomerOption THEN
            CASE STRMENU(
                   STRSUBSTNO(
                     '%1,%2',STRSUBSTNO(CreateNewCustTxt,CONVERTSTR(CustomerText,',','.')),SelectCustTxt),1,CustNotRegisteredTxt) OF
              0:
                ERROR(SelectCustErr);
              1:
                EXIT(CreateNewCustomer(COPYSTR(CustomerText,1,MAXSTRLEN(Customer.Name)),ShowCustomerCard));
            END
          ELSE
            EXIT('');
        Customer.RESET;
        NoFiltersApplied := TRUE;
      END;

      IF ShowCustomerCard THEN
        CustomerNo := PickCustomer(Customer,NoFiltersApplied)
      ELSE BEGIN
        LookupRequested := TRUE;
        EXIT('');
      END;

      IF CustomerNo <> '' THEN
        EXIT(CustomerNo);

      ERROR(SelectCustErr);
    END;

    LOCAL PROCEDURE MarkCustomersWithSimilarName@33(VAR Customer@1001 : Record 18;CustomerText@1000 : Text);
    VAR
      TypeHelper@1002 : Codeunit 10;
      CustomerCount@1003 : Integer;
      CustomerTextLength@1004 : Integer;
      Treshold@1005 : Integer;
    BEGIN
      IF CustomerText = '' THEN
        EXIT;
      IF STRLEN(CustomerText) > MAXSTRLEN(Customer.Name) THEN
        EXIT;
      CustomerTextLength := STRLEN(CustomerText);
      Treshold := CustomerTextLength DIV 5;
      IF Treshold = 0 THEN
        EXIT;

      Customer.RESET;
      Customer.ASCENDING(FALSE); // most likely to search for newest customers
      Customer.SETRANGE(Blocked,Customer.Blocked::" ");
      IF Customer.FINDSET THEN
        REPEAT
          CustomerCount += 1;
          IF ABS(CustomerTextLength - STRLEN(Customer.Name)) <= Treshold THEN
            IF TypeHelper.TextDistance(UPPERCASE(CustomerText),UPPERCASE(Customer.Name)) <= Treshold THEN
              Customer.MARK(TRUE);
        UNTIL Customer.MARK OR (Customer.NEXT = 0) OR (CustomerCount > 1000);
      Customer.MARKEDONLY(TRUE);
    END;

    [Internal]
    PROCEDURE CreateNewCustomer@28(CustomerName@1000 : Text[50];ShowCustomerCard@1001 : Boolean) : Code[20];
    VAR
      Customer@1005 : Record 18;
      MiniCustomerTemplate@1006 : Record 1300;
      CustomerCard@1002 : Page 21;
    BEGIN
      Customer.Name := CustomerName;
      IF NOT MiniCustomerTemplate.NewCustomerFromTemplate(Customer) THEN
        Customer.INSERT(TRUE)
      ELSE
        IF CustomerName <> Customer.Name THEN BEGIN
          Customer.Name := CustomerName;
          Customer.MODIFY(TRUE);
        END;

      COMMIT;
      IF NOT ShowCustomerCard THEN
        EXIT(Customer."No.");
      Customer.SETRANGE("No.",Customer."No.");
      CustomerCard.SETTABLEVIEW(Customer);
      IF NOT (CustomerCard.RUNMODAL = ACTION::OK) THEN
        ERROR(SelectCustErr);

      EXIT(Customer."No.");
    END;

    LOCAL PROCEDURE PickCustomer@51(VAR Customer@1000 : Record 18;NoFiltersApplied@1002 : Boolean) : Code[20];
    VAR
      CustomerList@1001 : Page 22;
    BEGIN
      IF NOT NoFiltersApplied THEN
        MarkCustomersByFilters(Customer);

      CustomerList.SETTABLEVIEW(Customer);
      CustomerList.SETRECORD(Customer);
      CustomerList.LOOKUPMODE := TRUE;
      IF CustomerList.RUNMODAL = ACTION::LookupOK THEN
        CustomerList.GETRECORD(Customer)
      ELSE
        CLEAR(Customer);

      EXIT(Customer."No.");
    END;

    LOCAL PROCEDURE MarkCustomersByFilters@42(VAR Customer@1000 : Record 18);
    BEGIN
      IF Customer.FINDSET THEN
        REPEAT
          Customer.MARK(TRUE);
        UNTIL Customer.NEXT = 0;
      IF Customer.FINDFIRST THEN;
      Customer.MARKEDONLY := TRUE;
    END;

    [External]
    PROCEDURE OpenCustomerLedgerEntries@31(FilterOnDueEntries@1002 : Boolean);
    VAR
      DetailedCustLedgEntry@1001 : Record 379;
      CustLedgerEntry@1000 : Record 21;
    BEGIN
      DetailedCustLedgEntry.SETRANGE("Customer No.","No.");
      COPYFILTER("Global Dimension 1 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 1");
      COPYFILTER("Global Dimension 2 Filter",DetailedCustLedgEntry."Initial Entry Global Dim. 2");
      IF FilterOnDueEntries AND (GETFILTER("Date Filter") <> '') THEN BEGIN
        COPYFILTER("Date Filter",DetailedCustLedgEntry."Initial Entry Due Date");
        DetailedCustLedgEntry.SETFILTER("Posting Date",'<=%1',GETRANGEMAX("Date Filter"));
      END;
      COPYFILTER("Currency Filter",DetailedCustLedgEntry."Currency Code");
      CustLedgerEntry.DrillDownOnEntries(DetailedCustLedgEntry);
    END;

    [External]
    PROCEDURE SetInsertFromTemplate@32(FromTemplate@1000 : Boolean);
    BEGIN
      InsertFromTemplate := FromTemplate;
    END;

    [External]
    PROCEDURE IsLookupRequested@34() Result : Boolean;
    BEGIN
      Result := LookupRequested;
      LookupRequested := FALSE;
    END;

    LOCAL PROCEDURE IsContactUpdateNeeded@48() : Boolean;
    VAR
      UpdateNeeded@1000 : Boolean;
    BEGIN
      UpdateNeeded :=
        (Name <> xRec.Name) OR
        ("Search Name" <> xRec."Search Name") OR
        ("Name 2" <> xRec."Name 2") OR
        (Address <> xRec.Address) OR
        ("Address 2" <> xRec."Address 2") OR
        (City <> xRec.City) OR
        ("Phone No." <> xRec."Phone No.") OR
        ("Telex No." <> xRec."Telex No.") OR
        ("Territory Code" <> xRec."Territory Code") OR
        ("Currency Code" <> xRec."Currency Code") OR
        ("Language Code" <> xRec."Language Code") OR
        ("Salesperson Code" <> xRec."Salesperson Code") OR
        ("Country/Region Code" <> xRec."Country/Region Code") OR
        ("Fax No." <> xRec."Fax No.") OR
        ("Telex Answer Back" <> xRec."Telex Answer Back") OR
        ("VAT Registration No." <> xRec."VAT Registration No.") OR
        ("Post Code" <> xRec."Post Code") OR
        (County <> xRec.County) OR
        ("E-Mail" <> xRec."E-Mail") OR
        ("Home Page" <> xRec."Home Page") OR
        (Contact <> xRec.Contact);

      OnBeforeIsContactUpdateNeeded(Rec,xRec,UpdateNeeded);
      EXIT(UpdateNeeded);
    END;

    LOCAL PROCEDURE CopyContactPicture@38(VAR Cont@1000 : Record 5050);
    VAR
      TempNameValueBuffer@1005 : TEMPORARY Record 823;
      FileManagement@1001 : Codeunit 419;
      ExportPath@1006 : Text;
    BEGIN
      IF Image.HASVALUE THEN
        IF NOT CONFIRM(OverrideImageQst) THEN
          EXIT;

      ExportPath := TEMPORARYPATH + Cont."No." + FORMAT(Cont.Image.MEDIAID);
      Cont.Image.EXPORTFILE(ExportPath);
      FileManagement.GetServerDirectoryFilesList(TempNameValueBuffer,TEMPORARYPATH);
      TempNameValueBuffer.SETFILTER(Name,STRSUBSTNO('%1*',ExportPath));
      TempNameValueBuffer.FINDFIRST;

      CLEAR(Image);
      Image.IMPORTFILE(TempNameValueBuffer.Name,'');
      MODIFY;
      IF FileManagement.DeleteServerFile(TempNameValueBuffer.Name) THEN;
    END;

    LOCAL PROCEDURE SetDefaultSalesperson@35();
    VAR
      UserSetup@1000 : Record 91;
    BEGIN
      IF NOT UserSetup.GET(USERID) THEN
        EXIT;

      IF UserSetup."Salespers./Purch. Code" <> '' THEN
        VALIDATE("Salesperson Code",UserSetup."Salespers./Purch. Code");
    END;

    LOCAL PROCEDURE SetLastModifiedDateTime@39();
    BEGIN
      "Last Modified Date Time" := CURRENTDATETIME;
      "Last Date Modified" := TODAY;
    END;

    LOCAL PROCEDURE VATRegistrationValidation@47();
    VAR
      VATRegistrationNoFormat@1005 : Record 381;
      VATRegistrationLog@1004 : Record 249;
      VATRegNoSrvConfig@1003 : Record 248;
      VATRegistrationLogMgt@1002 : Codeunit 249;
      ResultRecordRef@1001 : RecordRef;
      ApplicableCountryCode@1000 : Code[10];
    BEGIN
      IF NOT VATRegistrationNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Customer) THEN
        EXIT;
      VATRegistrationLogMgt.LogCustomer(Rec);
      IF ("Country/Region Code" = '') AND (VATRegistrationNoFormat."Country/Region Code" = '') THEN
        EXIT;
      ApplicableCountryCode := "Country/Region Code";
      IF ApplicableCountryCode = '' THEN
        ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
      IF VATRegNoSrvConfig.VATRegNoSrvIsEnabled THEN BEGIN
        VATRegistrationLogMgt.ValidateVATRegNoWithVIES(ResultRecordRef,Rec,"No.",
          VATRegistrationLog."Account Type"::Customer,ApplicableCountryCode);
        ResultRecordRef.SETTABLE(Rec);
      END;
    END;

    PROCEDURE SetAddress@40(CustomerAddress@1001 : Text[50];CustomerAddress2@1002 : Text[50];CustomerPostCode@1003 : Code[20];CustomerCity@1000 : Text[30];CustomerCounty@1004 : Text[30];CustomerCountryCode@1005 : Code[10];CustomerContact@1006 : Text[50]);
    BEGIN
      Address := CustomerAddress;
      "Address 2" := CustomerAddress2;
      "Post Code" := CustomerPostCode;
      City := CustomerCity;
      County := CustomerCounty;
      "Country/Region Code" := CustomerCountryCode;
      UpdateContFromCust.OnModify(Rec);
      Contact := CustomerContact;
    END;

    PROCEDURE FindByEmail@41(VAR Customer@1001 : Record 18;Email@1000 : Text) : Boolean;
    VAR
      LocalContact@1002 : Record 5050;
      ContactBusinessRelation@1003 : Record 5054;
      MarketingSetup@1004 : Record 5079;
    BEGIN
      Customer.SETRANGE("E-Mail",Email);
      IF Customer.FINDFIRST THEN
        EXIT(TRUE);

      Customer.SETRANGE("E-Mail");
      LocalContact.SETRANGE("E-Mail",Email);
      IF LocalContact.FINDSET THEN BEGIN
        MarketingSetup.GET;
        REPEAT
          IF ContactBusinessRelation.GET(LocalContact."No.",MarketingSetup."Bus. Rel. Code for Customers") THEN BEGIN
            Customer.GET(ContactBusinessRelation."No.");
            EXIT(TRUE);
          END;
        UNTIL LocalContact.NEXT = 0
      END;
    END;

    LOCAL PROCEDURE UpdateCurrencyCode@54();
    VAR
      Currency@1001 : Record 4;
    BEGIN
      IF NOT ISNULLGUID("Currency Id") THEN BEGIN
        Currency.SETRANGE(Id,"Currency Id");
        Currency.FINDFIRST;
      END;

      VALIDATE("Currency Code",Currency.Code);
    END;

    LOCAL PROCEDURE UpdatePaymentTermsCode@56();
    VAR
      PaymentTerms@1001 : Record 3;
    BEGIN
      IF NOT ISNULLGUID("Payment Terms Id") THEN BEGIN
        PaymentTerms.SETRANGE(Id,"Payment Terms Id");
        PaymentTerms.FINDFIRST;
      END;

      VALIDATE("Payment Terms Code",PaymentTerms.Code);
    END;

    LOCAL PROCEDURE UpdateShipmentMethodCode@58();
    VAR
      ShipmentMethod@1001 : Record 10;
    BEGIN
      IF NOT ISNULLGUID("Shipment Method Id") THEN BEGIN
        ShipmentMethod.SETRANGE(Id,"Shipment Method Id");
        ShipmentMethod.FINDFIRST;
      END;

      VALIDATE("Shipment Method Code",ShipmentMethod.Code);
    END;

    LOCAL PROCEDURE UpdatePaymentMethodCode@43();
    VAR
      PaymentMethod@1001 : Record 289;
    BEGIN
      IF NOT ISNULLGUID("Payment Method Id") THEN BEGIN
        PaymentMethod.SETRANGE(Id,"Payment Method Id");
        PaymentMethod.FINDFIRST;
      END;

      VALIDATE("Payment Method Code",PaymentMethod.Code);
    END;

    PROCEDURE UpdateCurrencyId@55();
    VAR
      Currency@1000 : Record 4;
    BEGIN
      IF "Currency Code" = '' THEN BEGIN
        CLEAR("Currency Id");
        EXIT;
      END;

      IF NOT Currency.GET("Currency Code") THEN
        EXIT;

      "Currency Id" := Currency.Id;
    END;

    PROCEDURE UpdatePaymentTermsId@57();
    VAR
      PaymentTerms@1000 : Record 3;
    BEGIN
      IF "Payment Terms Code" = '' THEN BEGIN
        CLEAR("Payment Terms Id");
        EXIT;
      END;

      IF NOT PaymentTerms.GET("Payment Terms Code") THEN
        EXIT;

      "Payment Terms Id" := PaymentTerms.Id;
    END;

    PROCEDURE UpdateShipmentMethodId@59();
    VAR
      ShipmentMethod@1000 : Record 10;
    BEGIN
      IF "Shipment Method Code" = '' THEN BEGIN
        CLEAR("Shipment Method Id");
        EXIT;
      END;

      IF NOT ShipmentMethod.GET("Shipment Method Code") THEN
        EXIT;

      "Shipment Method Id" := ShipmentMethod.Id;
    END;

    PROCEDURE UpdatePaymentMethodId@45();
    VAR
      PaymentMethod@1000 : Record 289;
    BEGIN
      IF "Payment Method Code" = '' THEN BEGIN
        CLEAR("Payment Method Id");
        EXIT;
      END;

      IF NOT PaymentMethod.GET("Payment Method Code") THEN
        EXIT;

      "Payment Method Id" := PaymentMethod.Id;
    END;

    PROCEDURE UpdateTaxAreaId@1166();
    VAR
      VATBusinessPostingGroup@1002 : Record 323;
      TaxArea@1000 : Record 318;
      GeneralLedgerSetup@1001 : Record 98;
    BEGIN
      IF GeneralLedgerSetup.UseVat THEN BEGIN
        IF "VAT Bus. Posting Group" = '' THEN BEGIN
          CLEAR("Tax Area ID");
          EXIT;
        END;

        IF NOT VATBusinessPostingGroup.GET("VAT Bus. Posting Group") THEN
          EXIT;

        "Tax Area ID" := VATBusinessPostingGroup.Id;
      END ELSE BEGIN
        IF "Tax Area Code" = '' THEN BEGIN
          CLEAR("Tax Area ID");
          EXIT;
        END;

        IF NOT TaxArea.GET("Tax Area Code") THEN
          EXIT;

        "Tax Area ID" := TaxArea.Id;
      END;
    END;

    LOCAL PROCEDURE UpdateTaxAreaCode@1164();
    VAR
      TaxArea@1001 : Record 318;
      VATBusinessPostingGroup@1000 : Record 323;
      GeneralLedgerSetup@1002 : Record 98;
    BEGIN
      IF ISNULLGUID("Tax Area ID") THEN
        EXIT;

      IF GeneralLedgerSetup.UseVat THEN BEGIN
        VATBusinessPostingGroup.SETRANGE(Id,"Tax Area ID");
        VATBusinessPostingGroup.FINDFIRST;
        "VAT Bus. Posting Group" := VATBusinessPostingGroup.Code;
      END ELSE BEGIN
        TaxArea.SETRANGE(Id,"Tax Area ID");
        TaxArea.FINDFIRST;
        "Tax Area Code" := TaxArea.Code;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE SkipRenamingLogic@46(VAR SkipRename@1000 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeIsContactUpdateNeeded@50(Customer@1000 : Record 18;xCustomer@1001 : Record 18;VAR UpdateNeeded@1002 : Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE ValidateSalesPersonCode@1900();
    BEGIN
      IF "Salesperson Code" <> '' THEN
        IF SalespersonPurchaser.GET("Salesperson Code") THEN
          IF SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) THEN
            ERROR(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser,TRUE))
    END;

    BEGIN
    END.
  }
}

