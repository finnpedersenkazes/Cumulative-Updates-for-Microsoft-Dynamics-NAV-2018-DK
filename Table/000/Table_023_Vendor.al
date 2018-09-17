OBJECT Table 23 Vendor
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 25=r;
    DataCaptionFields=No.,Name;
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 PurchSetup.GET;
                 PurchSetup.TESTFIELD("Vendor Nos.");
                 NoSeriesMgt.InitSeries(PurchSetup."Vendor Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;

               IF "Invoice Disc. Code" = '' THEN
                 "Invoice Disc. Code" := "No.";

               IF NOT (InsertFromContact OR (InsertFromTemplate AND (Contact <> ''))) THEN
                 UpdateContFromVend.OnInsert(Rec);

               IF "Purchaser Code" = '' THEN
                 SetDefaultPurchaser;

               DimMgt.UpdateDefaultDim(
                 DATABASE::Vendor,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");

               SetLastModifiedDateTime;
             END;

    OnModify=BEGIN
               SetLastModifiedDateTime;
               IF IsContactUpdateNeeded THEN BEGIN
                 MODIFY;
                 UpdateContFromVend.OnModify(Rec);
                 IF NOT FIND THEN BEGIN
                   RESET;
                   IF FIND THEN;
                 END;
               END;
             END;

    OnDelete=VAR
               ItemVendor@1000 : Record 99;
               PurchPrice@1001 : Record 7012;
               PurchLineDiscount@1002 : Record 7014;
               PurchPrepmtPct@1003 : Record 460;
               SocialListeningSearchTopic@1005 : Record 871;
               CustomReportSelection@1006 : Record 9657;
               PurchOrderLine@1007 : Record 39;
               IntrastatSetup@1008 : Record 247;
               VATRegistrationLogMgt@1004 : Codeunit 249;
             BEGIN
               ApprovalsMgmt.OnCancelVendorApprovalRequest(Rec);

               MoveEntries.MoveVendorEntries(Rec);

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Vendor);
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               VendBankAcc.SETRANGE("Vendor No.","No.");
               VendBankAcc.DELETEALL;

               OrderAddr.SETRANGE("Vendor No.","No.");
               OrderAddr.DELETEALL;

               ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
               ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Vendor);
               ItemCrossReference.SETRANGE("Cross-Reference Type No.","No.");
               ItemCrossReference.DELETEALL;

               PurchOrderLine.SETCURRENTKEY("Document Type","Pay-to Vendor No.");
               PurchOrderLine.SETRANGE("Pay-to Vendor No.","No.");
               IF PurchOrderLine.FINDFIRST THEN
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.",
                   PurchOrderLine."Document Type");

               PurchOrderLine.SETRANGE("Pay-to Vendor No.");
               PurchOrderLine.SETRANGE("Buy-from Vendor No.","No.");
               IF NOT PurchOrderLine.ISEMPTY THEN
                 ERROR(
                   Text000,
                   TABLECAPTION,"No.");

               UpdateContFromVend.OnDelete(Rec);

               DimMgt.DeleteDefaultDim(DATABASE::Vendor,"No.");

               ServiceItem.SETRANGE("Vendor No.","No.");
               ServiceItem.MODIFYALL("Vendor No.",'');

               ItemVendor.SETRANGE("Vendor No.","No.");
               ItemVendor.DELETEALL(TRUE);

               IF NOT SocialListeningSearchTopic.ISEMPTY THEN BEGIN
                 SocialListeningSearchTopic.FindSearchTopic(SocialListeningSearchTopic."Source Type"::Vendor,"No.");
                 SocialListeningSearchTopic.DELETEALL;
               END;

               PurchPrice.SETCURRENTKEY("Vendor No.");
               PurchPrice.SETRANGE("Vendor No.","No.");
               PurchPrice.DELETEALL(TRUE);

               PurchLineDiscount.SETCURRENTKEY("Vendor No.");
               PurchLineDiscount.SETRANGE("Vendor No.","No.");
               PurchLineDiscount.DELETEALL(TRUE);

               CustomReportSelection.SETRANGE("Source Type",DATABASE::Vendor);
               CustomReportSelection.SETRANGE("Source No.","No.");
               CustomReportSelection.DELETEALL;

               PurchPrepmtPct.SETCURRENTKEY("Vendor No.");
               PurchPrepmtPct.SETRANGE("Vendor No.","No.");
               PurchPrepmtPct.DELETEALL(TRUE);

               VATRegistrationLogMgt.DeleteVendorLog(Rec);

               IntrastatSetup.CheckDeleteIntrastatContact(IntrastatSetup."Intrastat Contact Type"::Vendor,"No.");
             END;

    OnRename=BEGIN
               ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);
               SetLastModifiedDateTime;
               IF xRec."Invoice Disc. Code" = xRec."No." THEN
                 "Invoice Disc. Code" := "No.";
             END;

    CaptionML=[DAN=Kreditor;
               ENU=Vendor];
    LookupPageID=Page27;
    DrillDownPageID=Page27;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  PurchSetup.GET;
                                                                  NoSeriesMgt.TestManual(PurchSetup."Vendor Nos.");
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
                                                                  IF RMSetup."Bus. Rel. Code for Vendors" <> '' THEN BEGIN
                                                                    IF (xRec.Contact = '') AND (xRec."Primary Contact No." = '') AND (Contact <> '') THEN BEGIN
                                                                      MODIFY;
                                                                      UpdateContFromVend.OnModify(Rec);
                                                                      UpdateContFromVend.InsertNewContactPerson(Rec,FALSE);
                                                                      MODIFY(TRUE);
                                                                    END;
                                                                    EXIT;
                                                                  END;
                                                              END;

                                                   OnLookup=VAR
                                                              ContactBusinessRelation@1001 : Record 5054;
                                                              Cont@1000 : Record 5050;
                                                            BEGIN
                                                              IF ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Vendor,"No.") THEN
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
    { 19  ;   ;Budgeted Amount     ;Decimal       ;CaptionML=[DAN=Budgetteret bel›b;
                                                              ENU=Budgeted Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 21  ;   ;Vendor Posting Group;Code20        ;TableRelation="Vendor Posting Group";
                                                   CaptionML=[DAN=Kreditorbogf›ringsgruppe;
                                                              ENU=Vendor Posting Group] }
    { 22  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                UpdateCurrencyId;
                                                              END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
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
    { 29  ;   ;Purchaser Code      ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Indk›berkode;
                                                              ENU=Purchaser Code] }
    { 30  ;   ;Shipment Method Code;Code10        ;TableRelation="Shipment Method";
                                                   CaptionML=[DAN=Leveringskode;
                                                              ENU=Shipment Method Code] }
    { 31  ;   ;Shipping Agent Code ;Code10        ;TableRelation="Shipping Agent";
                                                   CaptionML=[DAN=Spedit›rkode;
                                                              ENU=Shipping Agent Code] }
    { 33  ;   ;Invoice Disc. Code  ;Code20        ;TableRelation=Vendor;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Fakturarabatkode;
                                                              ENU=Invoice Disc. Code] }
    { 35  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCountryCode(City,"Post Code",County,"Country/Region Code");
                                                                IF "Country/Region Code" <> xRec."Country/Region Code" THEN
                                                                  VATRegistrationValidation;
                                                              END;

                                                   CaptionML=[DAN=Lande-/omr†dekode;
                                                              ENU=Country/Region Code] }
    { 38  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Comment Line" WHERE (Table Name=CONST(Vendor),
                                                                                           No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 39  ;   ;Blocked             ;Option        ;CaptionML=[DAN=Sp‘rret;
                                                              ENU=Blocked];
                                                   OptionCaptionML=[DAN=" ,Betaling,Alle";
                                                                    ENU=" ,Payment,All"];
                                                   OptionString=[ ,Payment,All] }
    { 45  ;   ;Pay-to Vendor No.   ;Code20        ;TableRelation=Vendor;
                                                   CaptionML=[DAN=Faktureringsleverand›rnr.;
                                                              ENU=Pay-to Vendor No.] }
    { 46  ;   ;Priority            ;Integer       ;CaptionML=[DAN=Prioritet;
                                                              ENU=Priority] }
    { 47  ;   ;Payment Method Code ;Code10        ;TableRelation="Payment Method";
                                                   OnValidate=BEGIN
                                                                UpdatePaymentMethodId;
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
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Saldo;
                                                              ENU=Balance];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Balance (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Saldo (RV);
                                                              ENU=Balance (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 60  ;   ;Net Change          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(No.),
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
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Bev‘gelse (RV);
                                                              ENU=Net Change (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 62  ;   ;Purchases (LCY)     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Vendor Ledger Entry"."Purchase (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                  Posting Date=FIELD(Date Filter),
                                                                                                                  Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=K›b (RV);
                                                              ENU=Purchases (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 64  ;   ;Inv. Discounts (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Vendor Ledger Entry"."Inv. Discount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                       Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                       Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Fakt.rabatbel›b (RV);
                                                              ENU=Inv. Discounts (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 65  ;   ;Pmt. Discounts (LCY);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
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
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Vendor No.=FIELD(No.),
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
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Due Date=FIELD(UPPERLIMIT(Date Filter)),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Forf. bel›b (RV);
                                                              ENU=Balance Due (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 69  ;   ;Payments            ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Payment),
                                                                                                               Entry Type=CONST(Initial Entry),
                                                                                                               Vendor No.=FIELD(No.),
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
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Invoice),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
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
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Credit Memo),
                                                                                                               Entry Type=CONST(Initial Entry),
                                                                                                               Vendor No.=FIELD(No.),
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
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
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
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Payment),
                                                                                                                       Entry Type=CONST(Initial Entry),
                                                                                                                       Vendor No.=FIELD(No.),
                                                                                                                       Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                       Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                       Posting Date=FIELD(Date Filter),
                                                                                                                       Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Betalt (RV);
                                                              ENU=Payments (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 75  ;   ;Inv. Amounts (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Invoice),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Fakturabel›b (RV);
                                                              ENU=Inv. Amounts (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 76  ;   ;Cr. Memo Amounts (LCY);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Credit Memo),
                                                                                                                       Entry Type=CONST(Initial Entry),
                                                                                                                       Vendor No.=FIELD(No.),
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
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Finance Charge Memo),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Rentenotabel›b (RV);
                                                              ENU=Fin. Charge Memo Amounts (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 78  ;   ;Outstanding Orders  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount" WHERE (Document Type=CONST(Order),
                                                                                                               Pay-to Vendor No.=FIELD(No.),
                                                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Udest†ende ordrer;
                                                              ENU=Outstanding Orders];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 79  ;   ;Amt. Rcd. Not Invoiced;Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Amt. Rcd. Not Invoiced" WHERE (Document Type=CONST(Order),
                                                                                                                   Pay-to Vendor No.=FIELD(No.),
                                                                                                                   Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                   Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                   Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Modt. bel›b (ufakt.);
                                                              ENU=Amt. Rcd. Not Invoiced];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 80  ;   ;Application Method  ;Option        ;CaptionML=[DAN=Udligningsmetode;
                                                              ENU=Application Method];
                                                   OptionCaptionML=[DAN=Manuelt,Saldo;
                                                                    ENU=Manual,Apply to Oldest];
                                                   OptionString=Manual,Apply to Oldest }
    { 82  ;   ;Prices Including VAT;Boolean       ;OnValidate=VAR
                                                                PurchPrice@1000 : Record 7012;
                                                                Item@1001 : Record 27;
                                                                VATPostingSetup@1002 : Record 325;
                                                                Currency@1003 : Record 4;
                                                              BEGIN
                                                                PurchPrice.SETCURRENTKEY("Vendor No.");
                                                                PurchPrice.SETRANGE("Vendor No.","No.");
                                                                IF PurchPrice.FIND('-') THEN BEGIN
                                                                  IF VATPostingSetup.GET('','') THEN;
                                                                  IF CONFIRM(
                                                                       STRSUBSTNO(
                                                                         Text002,
                                                                         FIELDCAPTION("Prices Including VAT"),"Prices Including VAT",PurchPrice.TABLECAPTION),TRUE)
                                                                  THEN
                                                                    REPEAT
                                                                      IF PurchPrice."Item No." <> Item."No." THEN
                                                                        Item.GET(PurchPrice."Item No.");
                                                                      IF ("VAT Bus. Posting Group" <> VATPostingSetup."VAT Bus. Posting Group") OR
                                                                         (Item."VAT Prod. Posting Group" <> VATPostingSetup."VAT Prod. Posting Group")
                                                                      THEN
                                                                        VATPostingSetup.GET("VAT Bus. Posting Group",Item."VAT Prod. Posting Group");
                                                                      IF PurchPrice."Currency Code" = '' THEN
                                                                        Currency.InitRoundingPrecision
                                                                      ELSE
                                                                        IF PurchPrice."Currency Code" <> Currency.Code THEN
                                                                          Currency.GET(PurchPrice."Currency Code");
                                                                      IF VATPostingSetup."VAT %" <> 0 THEN BEGIN
                                                                        IF "Prices Including VAT" THEN
                                                                          PurchPrice."Direct Unit Cost" :=
                                                                            ROUND(
                                                                              PurchPrice."Direct Unit Cost" * (1 + VATPostingSetup."VAT %" / 100),
                                                                              Currency."Unit-Amount Rounding Precision")
                                                                        ELSE
                                                                          PurchPrice."Direct Unit Cost" :=
                                                                            ROUND(
                                                                              PurchPrice."Direct Unit Cost" / (1 + VATPostingSetup."VAT %" / 100),
                                                                              Currency."Unit-Amount Rounding Precision");
                                                                        PurchPrice.MODIFY;
                                                                      END;
                                                                    UNTIL PurchPrice.NEXT = 0;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Priser inkl. moms;
                                                              ENU=Prices Including VAT] }
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
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Debit Amount" WHERE (Vendor No.=FIELD(No.),
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
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Credit Amount" WHERE (Vendor No.=FIELD(No.),
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
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
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
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
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
    { 104 ;   ;Reminder Amounts    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Reminder),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Rykkerbel›b;
                                                              ENU=Reminder Amounts];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 105 ;   ;Reminder Amounts (LCY);Decimal     ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Reminder),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
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
                                                   CaptionML=[DAN=Skatteomr†dekode;
                                                              ENU=Tax Area Code] }
    { 109 ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 110 ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 111 ;   ;Currency Filter     ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Currency;
                                                   CaptionML=[DAN=Valutafilter;
                                                              ENU=Currency Filter] }
    { 113 ;   ;Outstanding Orders (LCY);Decimal   ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                     Pay-to Vendor No.=FIELD(No.),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Udest†ende ordrer (RV);
                                                              ENU=Outstanding Orders (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 114 ;   ;Amt. Rcd. Not Invoiced (LCY);Decimal;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Amt. Rcd. Not Invoiced (LCY)" WHERE (Document Type=CONST(Order),
                                                                                                                         Pay-to Vendor No.=FIELD(No.),
                                                                                                                         Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                         Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                         Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Bel›b modt. ufaktureret (RV);
                                                              ENU=Amt. Rcd. Not Invoiced (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 116 ;   ;Block Payment Tolerance;Boolean    ;CaptionML=[DAN=Ingen betalingstolerance;
                                                              ENU=Block Payment Tolerance] }
    { 117 ;   ;Pmt. Disc. Tolerance (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
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
                                                   CalcFormula=Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Vendor No.=FIELD(No.),
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
                                                                VendLedgEntry@1001 : Record 25;
                                                                AccountingPeriod@1000 : Record 50;
                                                                ICPartner@1002 : Record 413;
                                                              BEGIN
                                                                IF xRec."IC Partner Code" <> "IC Partner Code" THEN BEGIN
                                                                  IF NOT VendLedgEntry.SETCURRENTKEY("Vendor No.",Open) THEN
                                                                    VendLedgEntry.SETCURRENTKEY("Vendor No.");
                                                                  VendLedgEntry.SETRANGE("Vendor No.","No.");
                                                                  VendLedgEntry.SETRANGE(Open,TRUE);
                                                                  IF VendLedgEntry.FINDLAST THEN
                                                                    ERROR(Text010,FIELDCAPTION("IC Partner Code"),TABLECAPTION);

                                                                  VendLedgEntry.RESET;
                                                                  VendLedgEntry.SETCURRENTKEY("Vendor No.","Posting Date");
                                                                  VendLedgEntry.SETRANGE("Vendor No.","No.");
                                                                  AccountingPeriod.SETRANGE(Closed,FALSE);
                                                                  IF AccountingPeriod.FINDFIRST THEN BEGIN
                                                                    VendLedgEntry.SETFILTER("Posting Date",'>=%1',AccountingPeriod."Starting Date");
                                                                    IF VendLedgEntry.FINDFIRST THEN
                                                                      IF NOT CONFIRM(Text009,FALSE,TABLECAPTION) THEN
                                                                        "IC Partner Code" := xRec."IC Partner Code";
                                                                  END;
                                                                END;

                                                                IF "IC Partner Code" <> '' THEN BEGIN
                                                                  ICPartner.GET("IC Partner Code");
                                                                  IF (ICPartner."Vendor No." <> '') AND (ICPartner."Vendor No." <> "No.") THEN
                                                                    ERROR(Text008,FIELDCAPTION("IC Partner Code"),"IC Partner Code",TABLECAPTION,ICPartner."Vendor No.");
                                                                  ICPartner."Vendor No." := "No.";
                                                                  ICPartner.MODIFY;
                                                                END;

                                                                IF (xRec."IC Partner Code" <> "IC Partner Code") AND ICPartner.GET(xRec."IC Partner Code") THEN BEGIN
                                                                  ICPartner."Vendor No." := '';
                                                                  ICPartner.MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=IC-partner kode;
                                                              ENU=IC Partner Code] }
    { 120 ;   ;Refunds             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(Refund),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Refusioner;
                                                              ENU=Refunds] }
    { 121 ;   ;Refunds (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(Refund),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
                                                                                                                        Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                        Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                        Posting Date=FIELD(Date Filter),
                                                                                                                        Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Refusioner (RV);
                                                              ENU=Refunds (LCY)] }
    { 122 ;   ;Other Amounts       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry".Amount WHERE (Initial Document Type=CONST(" "),
                                                                                                                Entry Type=CONST(Initial Entry),
                                                                                                                Vendor No.=FIELD(No.),
                                                                                                                Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                Posting Date=FIELD(Date Filter),
                                                                                                                Currency Code=FIELD(Currency Filter)));
                                                   CaptionML=[DAN=Andre bel›b;
                                                              ENU=Other Amounts] }
    { 123 ;   ;Other Amounts (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE (Initial Document Type=CONST(" "),
                                                                                                                        Entry Type=CONST(Initial Entry),
                                                                                                                        Vendor No.=FIELD(No.),
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
    { 125 ;   ;Outstanding Invoices;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount" WHERE (Document Type=CONST(Invoice),
                                                                                                               Pay-to Vendor No.=FIELD(No.),
                                                                                                               Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                               Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                               Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Udest†ende fakturaer;
                                                              ENU=Outstanding Invoices];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 126 ;   ;Outstanding Invoices (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE (Document Type=CONST(Invoice),
                                                                                                                     Pay-to Vendor No.=FIELD(No.),
                                                                                                                     Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Currency Code=FIELD(Currency Filter)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Udest†ende fakturaer (RV);
                                                              ENU=Outstanding Invoices (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 130 ;   ;Pay-to No. Of Archived Doc.;Integer;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header Archive" WHERE (Document Type=CONST(Order),
                                                                                                      Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureringsleverand›r - antal arkiverede dok.;
                                                              ENU=Pay-to No. Of Archived Doc.] }
    { 131 ;   ;Buy-from No. Of Archived Doc.;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header Archive" WHERE (Document Type=CONST(Order),
                                                                                                      Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Leverand›r - antal arkiverede dok.;
                                                              ENU=Buy-from No. Of Archived Doc.] }
    { 132 ;   ;Partner Type        ;Option        ;CaptionML=[DAN=Partnertype;
                                                              ENU=Partner Type];
                                                   OptionCaptionML=[DAN=" ,Virksomhed,Person";
                                                                    ENU=" ,Company,Person"];
                                                   OptionString=[ ,Company,Person] }
    { 140 ;   ;Image               ;Media         ;ExtendedDatatype=Person;
                                                   CaptionML=[DAN=Grafik;
                                                              ENU=Image] }
    { 170 ;   ;Creditor No.        ;Code20        ;CaptionML=[DAN=Kreditornr.;
                                                              ENU=Creditor No.];
                                                   Numeric=Yes }
    { 288 ;   ;Preferred Bank Account Code;Code20 ;TableRelation="Vendor Bank Account".Code WHERE (Vendor No.=FIELD(No.));
                                                   CaptionML=[DAN=Foretrukken bankkontokode;
                                                              ENU=Preferred Bank Account Code] }
    { 840 ;   ;Cash Flow Payment Terms Code;Code10;TableRelation="Payment Terms";
                                                   CaptionML=[DAN=Pengestr›msbetalingsbeting.kode;
                                                              ENU=Cash Flow Payment Terms Code] }
    { 5049;   ;Primary Contact No. ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                Cont@1001 : Record 5050;
                                                                ContBusRel@1000 : Record 5054;
                                                              BEGIN
                                                                Contact := '';
                                                                IF "Primary Contact No." <> '' THEN BEGIN
                                                                  Cont.GET("Primary Contact No.");

                                                                  ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                                  ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
                                                                  ContBusRel.SETRANGE("No.","No.");
                                                                  ContBusRel.FINDFIRST;

                                                                  IF Cont."Company No." <> ContBusRel."Contact No." THEN
                                                                    ERROR(Text004,Cont."No.",Cont.Name,"No.",Name);

                                                                  IF Cont.Type = Cont.Type::Person THEN
                                                                    Contact := Cont.Name;

                                                                  IF Cont."Phone No." <> '' THEN
                                                                    "Phone No." := Cont."Phone No.";
                                                                  IF Cont."E-Mail" <> '' THEN
                                                                    "E-Mail" := Cont."E-Mail";
                                                                END;
                                                              END;

                                                   OnLookup=VAR
                                                              Cont@1001 : Record 5050;
                                                              ContBusRel@1000 : Record 5054;
                                                              TempVend@1002 : TEMPORARY Record 23;
                                                            BEGIN
                                                              ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
                                                              ContBusRel.SETRANGE("No.","No.");
                                                              IF ContBusRel.FINDFIRST THEN
                                                                Cont.SETRANGE("Company No.",ContBusRel."Contact No.")
                                                              ELSE
                                                                Cont.SETRANGE("No.",'');

                                                              IF "Primary Contact No." <> '' THEN
                                                                IF Cont.GET("Primary Contact No.") THEN ;
                                                              IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                                                                TempVend.COPY(Rec);
                                                                FIND;
                                                                TRANSFERFIELDS(TempVend,FALSE);
                                                                VALIDATE("Primary Contact No.",Cont."No.");
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Prim‘rkontaktnr.;
                                                              ENU=Primary Contact No.] }
    { 5700;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 5701;   ;Location Code       ;Code10        ;TableRelation=Location WHERE (Use As In-Transit=CONST(No));
                                                   CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 5790;   ;Lead Time Calculation;DateFormula  ;OnValidate=BEGIN
                                                                LeadTimeMgt.CheckLeadTimeIsNotNegative("Lead Time Calculation");
                                                              END;

                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Leveringstid;
                                                              ENU=Lead Time Calculation] }
    { 7177;   ;No. of Pstd. Receipts;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Rcpt. Header" WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal bogf›rte modtagelser;
                                                              ENU=No. of Pstd. Receipts];
                                                   Editable=No }
    { 7178;   ;No. of Pstd. Invoices;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Inv. Header" WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal bogf›rte fakturaer;
                                                              ENU=No. of Pstd. Invoices];
                                                   Editable=No }
    { 7179;   ;No. of Pstd. Return Shipments;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Return Shipment Header" WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal returvareleverancer;
                                                              ENU=No. of Pstd. Return Shipments];
                                                   Editable=No }
    { 7180;   ;No. of Pstd. Credit Memos;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Cr. Memo Hdr." WHERE (Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal bogf›rte kreditnotaer;
                                                              ENU=No. of Pstd. Credit Memos];
                                                   Editable=No }
    { 7181;   ;Pay-to No. of Orders;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Order),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Faktureringsleverand›r - antal ordrer;
                                                              ENU=Pay-to No. of Orders];
                                                   Editable=No }
    { 7182;   ;Pay-to No. of Invoices;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Invoice),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureringsleverand›r - antal fakturaer;
                                                              ENU=Pay-to No. of Invoices];
                                                   Editable=No }
    { 7183;   ;Pay-to No. of Return Orders;Integer;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Return Order),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Faktureringsleverand›r - antal returordrer;
                                                              ENU=Pay-to No. of Return Orders];
                                                   Editable=No }
    { 7184;   ;Pay-to No. of Credit Memos;Integer ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Credit Memo),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureringsleverand›r - antal kreditnotaer;
                                                              ENU=Pay-to No. of Credit Memos];
                                                   Editable=No }
    { 7185;   ;Pay-to No. of Pstd. Receipts;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Rcpt. Header" WHERE (Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureringsleverand›r - antal bogf›rte modtagelser;
                                                              ENU=Pay-to No. of Pstd. Receipts];
                                                   Editable=No }
    { 7186;   ;Pay-to No. of Pstd. Invoices;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Inv. Header" WHERE (Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureringsleverand›r - antal bogf›rte fakturaer;
                                                              ENU=Pay-to No. of Pstd. Invoices];
                                                   Editable=No }
    { 7187;   ;Pay-to No. of Pstd. Return S.;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Return Shipment Header" WHERE (Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureringsleverand›r - antal bogf. returvl.;
                                                              ENU=Pay-to No. of Pstd. Return S.];
                                                   Editable=No }
    { 7188;   ;Pay-to No. of Pstd. Cr. Memos;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Purch. Cr. Memo Hdr." WHERE (Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Leverand›rnr. -bogf›rte kreditnotaer;
                                                              ENU=Pay-to No. of Pstd. Cr. Memos];
                                                   Editable=No }
    { 7189;   ;No. of Quotes       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Quote),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal tilbud;
                                                              ENU=No. of Quotes];
                                                   Editable=No }
    { 7190;   ;No. of Blanket Orders;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Blanket Order),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Antal rammeordrer;
                                                              ENU=No. of Blanket Orders];
                                                   Editable=No }
    { 7191;   ;No. of Orders       ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Order),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Antal ordrer;
                                                              ENU=No. of Orders] }
    { 7192;   ;No. of Invoices     ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Invoice),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal fakturaer;
                                                              ENU=No. of Invoices];
                                                   Editable=No }
    { 7193;   ;No. of Return Orders;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Return Order),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 6650=R;
                                                   CaptionML=[DAN=Antal returordrer;
                                                              ENU=No. of Return Orders];
                                                   Editable=No }
    { 7194;   ;No. of Credit Memos ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Credit Memo),
                                                                                              Buy-from Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal kreditnotaer;
                                                              ENU=No. of Credit Memos];
                                                   Editable=No }
    { 7195;   ;No. of Order Addresses;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Order Address" WHERE (Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal bestillingsadresser;
                                                              ENU=No. of Order Addresses];
                                                   Editable=No }
    { 7196;   ;Pay-to No. of Quotes;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Quote),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Faktureringsleverand›r - antal tilbud;
                                                              ENU=Pay-to No. of Quotes];
                                                   Editable=No }
    { 7197;   ;Pay-to No. of Blanket Orders;Integer;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Count("Purchase Header" WHERE (Document Type=CONST(Blanket Order),
                                                                                              Pay-to Vendor No.=FIELD(No.)));
                                                   AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Faktureringsleverand›r - antal rammeordrer;
                                                              ENU=Pay-to No. of Blanket Orders] }
    { 7198;   ;No. of Incoming Documents;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=Count("Incoming Document" WHERE (Vendor No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal indg†ende bilag;
                                                              ENU=No. of Incoming Documents];
                                                   Editable=No }
    { 7600;   ;Base Calendar Code  ;Code10        ;TableRelation="Base Calendar";
                                                   CaptionML=[DAN=Basiskalenderkode;
                                                              ENU=Base Calendar Code] }
    { 7601;   ;Document Sending Profile;Code20    ;TableRelation="Document Sending Profile".Code;
                                                   CaptionML=[DAN=Dokumentafsendelsesprofil;
                                                              ENU=Document Sending Profile] }
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
    { 8003;   ;Payment Method Id   ;GUID          ;TableRelation="Payment Method".Id;
                                                   OnValidate=BEGIN
                                                                UpdatePaymentMethodCode;
                                                              END;

                                                   CaptionML=[DAN=Id for betalingsform;
                                                              ENU=Payment Method Id] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Name                              }
    {    ;Vendor Posting Group                     }
    {    ;Currency Code                            }
    {    ;Priority                                 }
    {    ;Country/Region Code                      }
    {    ;Gen. Bus. Posting Group                  }
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
      Text000@1000 : TextConst 'DAN=Du kan ikke slette %1 %2, fordi der findes ‚n eller flere udest†ende forekomster af k›bs%3 for denne kreditor.;ENU=You cannot delete %1 %2 because there is at least one outstanding Purchase %3 for this vendor.';
      Text002@1001 : TextConst 'DAN=Du har sat %1 til %2. Vil du opdatere prislisten %3 i overensstemmelse hermed?;ENU=You have set %1 to %2. Do you want to update the %3 price list accordingly?';
      Text003@1002 : TextConst 'DAN=Vil du oprette en attentionpost for %1 %2?;ENU=Do you wish to create a contact for %1 %2?';
      PurchSetup@1003 : Record 312;
      CommentLine@1005 : Record 97;
      PostCode@1007 : Record 225;
      VendBankAcc@1008 : Record 288;
      OrderAddr@1009 : Record 224;
      GenBusPostingGrp@1010 : Record 250;
      ItemCrossReference@1016 : Record 5717;
      RMSetup@1020 : Record 5079;
      ServiceItem@1024 : Record 5940;
      NoSeriesMgt@1011 : Codeunit 396;
      MoveEntries@1012 : Codeunit 361;
      UpdateContFromVend@1013 : Codeunit 5057;
      DimMgt@1014 : Codeunit 408;
      LeadTimeMgt@1006 : Codeunit 5404;
      ApprovalsMgmt@1028 : Codeunit 1535;
      InsertFromContact@1015 : Boolean;
      Text004@1019 : TextConst 'DAN=Kontakt %1 %2 er ikke knyttet til kreditor %3 %4.;ENU=Contact %1 %2 is not related to vendor %3 %4.';
      Text005@1021 : TextConst 'DAN=bogf›re;ENU=post';
      Text006@1022 : TextConst 'DAN=oprette;ENU=create';
      Text007@1023 : TextConst 'DAN=Du kan ikke %1 denne dokumenttype, n†r kreditor %2 er sp‘rret med typen %3;ENU=You cannot %1 this type of document when Vendor %2 is blocked with type %3';
      Text008@1025 : TextConst 'DAN=%1 %2 er blevet tildelt til %3 %4.\Samme %1 kan ikke angives p† mere end ‚n/‚t %3.;ENU=The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3.';
      Text009@1027 : TextConst 'DAN=Afstemning af IC-transaktioner kan v‘re sv‘rt, hvis du ‘ndrer IC-partner kode, da denne %1 har poster i et regnskabs†r, der endnu ikke er blevet afsluttet.\Vil du stadig ‘ndre IC-partner kode.;ENU=Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
      Text010@1026 : TextConst 'DAN=Du kan ikke ‘ndre indholdet af feltet %1, fordi denne/dette %2 har en eller flere †bne poster.;ENU=You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
      Text011@1004 : TextConst 'DAN=Vinduet Ops‘tning af Online Map skal udfyldes, f›r du kan bruge Online Map.\Se Ops‘tning af Online Map i Hj‘lp.;ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
      SelectVendorErr@1017 : TextConst 'DAN=Du skal v‘lge en eksisterende kreditor.;ENU=You must select an existing vendor.';
      CreateNewVendTxt@1129 : TextConst '@@@="%1 is the name to be used to create the customer. ";DAN=Opret et nyt kreditorkort for %1.;ENU=Create a new vendor card for %1.';
      VendNotRegisteredTxt@1128 : TextConst 'DAN=Denne kreditor er ikke registreret. V‘lg en af f›lgende muligheder for at forts‘tte:;ENU=This vendor is not registered. To continue, choose one of the following options:';
      SelectVendTxt@1118 : TextConst 'DAN=V‘lg en eksisterende kreditor.;ENU=Select an existing vendor.';
      InsertFromTemplate@1018 : Boolean;

    [External]
    PROCEDURE AssistEdit@2(OldVend@1000 : Record 23) : Boolean;
    VAR
      Vend@1001 : Record 23;
    BEGIN
      WITH Vend DO BEGIN
        Vend := Rec;
        PurchSetup.GET;
        PurchSetup.TESTFIELD("Vendor Nos.");
        IF NoSeriesMgt.SelectSeries(PurchSetup."Vendor Nos.",OldVend."No. Series","No. Series") THEN BEGIN
          PurchSetup.GET;
          PurchSetup.TESTFIELD("Vendor Nos.");
          NoSeriesMgt.SetSeries("No.");
          Rec := Vend;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Vendor,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    END;

    [External]
    PROCEDURE ShowContact@1();
    VAR
      ContBusRel@1000 : Record 5054;
      Cont@1001 : Record 5050;
      OfficeContact@1003 : Record 5050;
      OfficeMgt@1002 : Codeunit 1630;
    BEGIN
      IF OfficeMgt.GetContact(OfficeContact,"No.") AND (OfficeContact.COUNT = 1) THEN
        PAGE.RUN(PAGE::"Contact Card",OfficeContact)
      ELSE BEGIN
        IF "No." = '' THEN
          EXIT;

        ContBusRel.SETCURRENTKEY("Link to Table","No.");
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
        ContBusRel.SETRANGE("No.","No.");
        IF NOT ContBusRel.FINDFIRST THEN BEGIN
          IF NOT CONFIRM(Text003,FALSE,TABLECAPTION,"No.") THEN
            EXIT;
          UpdateContFromVend.InsertNewContact(Rec,FALSE);
          ContBusRel.FINDFIRST;
        END;
        COMMIT;

        Cont.FILTERGROUP(2);
        Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
        PAGE.RUN(PAGE::"Contact List",Cont);
      END;
    END;

    [External]
    PROCEDURE SetInsertFromContact@3(FromContact@1000 : Boolean);
    BEGIN
      InsertFromContact := FromContact;
    END;

    [External]
    PROCEDURE CheckBlockedVendOnDocs@4(Vend2@1003 : Record 23;Transaction@1000 : Boolean);
    BEGIN
      IF Vend2.Blocked = Vend2.Blocked::All THEN
        VendBlockedErrorMessage(Vend2,Transaction);
    END;

    [External]
    PROCEDURE CheckBlockedVendOnJnls@5(Vend2@1005 : Record 23;DocType@1004 : ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';Transaction@1003 : Boolean);
    BEGIN
      WITH Vend2 DO BEGIN
        IF (Blocked = Blocked::All) OR
           (Blocked = Blocked::Payment) AND (DocType = DocType::Payment)
        THEN
          VendBlockedErrorMessage(Vend2,Transaction);
      END;
    END;

    [External]
    PROCEDURE CreateAndShowNewInvoice@21();
    VAR
      PurchaseHeader@1000 : Record 38;
    BEGIN
      PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
      PurchaseHeader.SETRANGE("Buy-from Vendor No.","No.");
      PurchaseHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Purchase Invoice",PurchaseHeader)
    END;

    [External]
    PROCEDURE CreateAndShowNewCreditMemo@22();
    VAR
      PurchaseHeader@1000 : Record 38;
    BEGIN
      PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
      PurchaseHeader.SETRANGE("Buy-from Vendor No.","No.");
      PurchaseHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Purchase Credit Memo",PurchaseHeader)
    END;

    [External]
    PROCEDURE CreateAndShowNewPurchaseOrder@12();
    VAR
      PurchaseHeader@1000 : Record 38;
    BEGIN
      PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
      PurchaseHeader.SETRANGE("Buy-from Vendor No.","No.");
      PurchaseHeader.INSERT(TRUE);
      COMMIT;
      PAGE.RUN(PAGE::"Purchase Order",PurchaseHeader);
    END;

    [External]
    PROCEDURE VendBlockedErrorMessage@6(Vend2@1001 : Record 23;Transaction@1002 : Boolean);
    VAR
      Action@1000 : Text[30];
    BEGIN
      IF Transaction THEN
        Action := Text005
      ELSE
        Action := Text006;
      ERROR(Text007,Action,Vend2."No.",Vend2.Blocked);
    END;

    [Internal]
    PROCEDURE DisplayMap@7();
    VAR
      MapPoint@1001 : Record 800;
      MapMgt@1000 : Codeunit 802;
    BEGIN
      IF MapPoint.FINDFIRST THEN
        MapMgt.MakeSelection(DATABASE::Vendor,GETPOSITION)
      ELSE
        MESSAGE(Text011);
    END;

    [External]
    PROCEDURE CalcOverDueBalance@8() OverDueBalance : Decimal;
    VAR
      VendLedgEntryRemainAmtQuery@1001 : Query 25 SECURITYFILTERING(Filtered);
    BEGIN
      VendLedgEntryRemainAmtQuery.SETRANGE(Vendor_No,"No.");
      VendLedgEntryRemainAmtQuery.SETRANGE(IsOpen,TRUE);
      VendLedgEntryRemainAmtQuery.SETFILTER(Due_Date,'<%1',WORKDATE);
      VendLedgEntryRemainAmtQuery.OPEN;

      IF VendLedgEntryRemainAmtQuery.READ THEN
        OverDueBalance := -VendLedgEntryRemainAmtQuery.Sum_Remaining_Amt_LCY;
    END;

    [External]
    PROCEDURE GetInvoicedPrepmtAmountLCY@18() : Decimal;
    VAR
      PurchLine@1000 : Record 39;
    BEGIN
      PurchLine.SETCURRENTKEY("Document Type","Pay-to Vendor No.");
      PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
      PurchLine.SETRANGE("Pay-to Vendor No.","No.");
      PurchLine.CALCSUMS("Prepmt. Amount Inv. (LCY)","Prepmt. VAT Amount Inv. (LCY)");
      EXIT(PurchLine."Prepmt. Amount Inv. (LCY)" + PurchLine."Prepmt. VAT Amount Inv. (LCY)");
    END;

    [External]
    PROCEDURE GetTotalAmountLCY@10() : Decimal;
    BEGIN
      CALCFIELDS(
        "Balance (LCY)","Outstanding Orders (LCY)","Amt. Rcd. Not Invoiced (LCY)","Outstanding Invoices (LCY)");

      EXIT(
        "Balance (LCY)" + "Outstanding Orders (LCY)" +
        "Amt. Rcd. Not Invoiced (LCY)" + "Outstanding Invoices (LCY)" - GetInvoicedPrepmtAmountLCY);
    END;

    [External]
    PROCEDURE HasAddress@25() : Boolean;
    BEGIN
      CASE TRUE OF
        Address <> '':
          EXIT(TRUE);
        "Address 2" <> '':
          EXIT(TRUE);
        City <> '':
          EXIT(TRUE);
        "Country/Region Code" <> '':
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
    PROCEDURE GetVendorNo@19(VendorText@1000 : Text[50]) : Code[20];
    BEGIN
      EXIT(GetVendorNoOpenCard(VendorText,TRUE));
    END;

    [External]
    PROCEDURE GetVendorNoOpenCard@56(VendorText@1000 : Text[50];ShowVendorCard@1006 : Boolean) : Code[20];
    VAR
      Vendor@1001 : Record 23;
      VendorNo@1002 : Code[20];
      NoFiltersApplied@1007 : Boolean;
      VendorWithoutQuote@1003 : Text;
      VendorFilterFromStart@1004 : Text;
      VendorFilterContains@1005 : Text;
    BEGIN
      IF VendorText = '' THEN
        EXIT('');

      IF STRLEN(VendorText) <= MAXSTRLEN(Vendor."No.") THEN
        IF Vendor.GET(VendorText) THEN
          EXIT(Vendor."No.");

      VendorWithoutQuote := CONVERTSTR(VendorText,'''','?');

      Vendor.SETFILTER(Name,'''@' + VendorWithoutQuote + '''');
      IF Vendor.FINDFIRST THEN
        EXIT(Vendor."No.");
      Vendor.SETRANGE(Name);

      VendorFilterFromStart := '''@' + VendorWithoutQuote + '*''';

      Vendor.FILTERGROUP := -1;
      Vendor.SETFILTER("No.",VendorFilterFromStart);
      Vendor.SETFILTER(Name,VendorFilterFromStart);
      IF Vendor.FINDFIRST THEN
        EXIT(Vendor."No.");

      VendorFilterContains := '''@*' + VendorWithoutQuote + '*''';

      Vendor.SETFILTER("No.",VendorFilterContains);
      Vendor.SETFILTER(Name,VendorFilterContains);
      Vendor.SETFILTER(City,VendorFilterContains);
      Vendor.SETFILTER(Contact,VendorFilterContains);
      Vendor.SETFILTER("Phone No.",VendorFilterContains);
      Vendor.SETFILTER("Post Code",VendorFilterContains);

      IF Vendor.COUNT = 0 THEN
        MarkVendorsWithSimilarName(Vendor,VendorText);

      IF Vendor.COUNT = 1 THEN BEGIN
        Vendor.FINDFIRST;
        EXIT(Vendor."No.");
      END;

      IF NOT GUIALLOWED THEN
        ERROR(SelectVendorErr);

      IF Vendor.COUNT = 0 THEN BEGIN
        IF Vendor.WRITEPERMISSION THEN
          CASE STRMENU(STRSUBSTNO('%1,%2',STRSUBSTNO(CreateNewVendTxt,VendorText),SelectVendTxt),1,VendNotRegisteredTxt) OF
            0:
              ERROR(SelectVendorErr);
            1:
              EXIT(CreateNewVendor(COPYSTR(VendorText,1,MAXSTRLEN(Vendor.Name)),ShowVendorCard));
          END;
        Vendor.RESET;
        NoFiltersApplied := TRUE;
      END;

      IF ShowVendorCard THEN
        VendorNo := PickVendor(Vendor,NoFiltersApplied)
      ELSE
        EXIT('');

      IF VendorNo <> '' THEN
        EXIT(VendorNo);

      ERROR(SelectVendorErr);
    END;

    LOCAL PROCEDURE MarkVendorsWithSimilarName@33(VAR Vendor@1001 : Record 23;VendorText@1000 : Text);
    VAR
      TypeHelper@1002 : Codeunit 10;
      VendorCount@1003 : Integer;
      VendorTextLenght@1004 : Integer;
      Treshold@1005 : Integer;
    BEGIN
      IF VendorText = '' THEN
        EXIT;
      IF STRLEN(VendorText) > MAXSTRLEN(Vendor.Name) THEN
        EXIT;
      VendorTextLenght := STRLEN(VendorText);
      Treshold := VendorTextLenght DIV 5;
      IF Treshold = 0 THEN
        EXIT;
      Vendor.RESET;
      Vendor.ASCENDING(FALSE); // most likely to search for newest Vendors
      IF Vendor.FINDSET THEN
        REPEAT
          VendorCount += 1;
          IF ABS(VendorTextLenght - STRLEN(Vendor.Name)) <= Treshold THEN
            IF TypeHelper.TextDistance(UPPERCASE(VendorText),UPPERCASE(Vendor.Name)) <= Treshold THEN
              Vendor.MARK(TRUE);
        UNTIL Vendor.MARK OR (Vendor.NEXT = 0) OR (VendorCount > 1000);
      Vendor.MARKEDONLY(TRUE);
    END;

    LOCAL PROCEDURE CreateNewVendor@59(VendorName@1000 : Text[50];ShowVendorCard@1001 : Boolean) : Code[20];
    VAR
      Vendor@1005 : Record 23;
      MiniVendorTemplate@1006 : Record 1303;
      VendorCard@1002 : Page 26;
    BEGIN
      IF NOT MiniVendorTemplate.NewVendorFromTemplate(Vendor) THEN
        ERROR(SelectVendorErr);

      Vendor.Name := VendorName;
      Vendor.MODIFY(TRUE);
      COMMIT;
      IF NOT ShowVendorCard THEN
        EXIT(Vendor."No.");
      Vendor.SETRANGE("No.",Vendor."No.");
      VendorCard.SETTABLEVIEW(Vendor);
      IF NOT (VendorCard.RUNMODAL = ACTION::OK) THEN
        ERROR(SelectVendorErr);

      EXIT(Vendor."No.");
    END;

    LOCAL PROCEDURE PickVendor@58(VAR Vendor@1000 : Record 23;NoFiltersApplied@1002 : Boolean) : Code[20];
    VAR
      VendorList@1001 : Page 27;
    BEGIN
      IF NOT NoFiltersApplied THEN
        MarkVendorsByFilters(Vendor);

      VendorList.SETTABLEVIEW(Vendor);
      VendorList.SETRECORD(Vendor);
      VendorList.LOOKUPMODE := TRUE;
      IF VendorList.RUNMODAL = ACTION::LookupOK THEN
        VendorList.GETRECORD(Vendor)
      ELSE
        CLEAR(Vendor);

      EXIT(Vendor."No.");
    END;

    LOCAL PROCEDURE MarkVendorsByFilters@20(VAR Vendor@1000 : Record 23);
    BEGIN
      IF Vendor.FINDSET THEN
        REPEAT
          Vendor.MARK(TRUE);
        UNTIL Vendor.NEXT = 0;
      IF Vendor.FINDFIRST THEN;
      Vendor.MARKEDONLY := TRUE;
    END;

    [External]
    PROCEDURE OpenVendorLedgerEntries@9(FilterOnDueEntries@1002 : Boolean);
    VAR
      DetailedVendorLedgEntry@1001 : Record 380;
      VendorLedgerEntry@1000 : Record 25;
    BEGIN
      DetailedVendorLedgEntry.SETRANGE("Vendor No.","No.");
      COPYFILTER("Global Dimension 1 Filter",DetailedVendorLedgEntry."Initial Entry Global Dim. 1");
      COPYFILTER("Global Dimension 2 Filter",DetailedVendorLedgEntry."Initial Entry Global Dim. 2");
      IF FilterOnDueEntries AND (GETFILTER("Date Filter") <> '') THEN BEGIN
        COPYFILTER("Date Filter",DetailedVendorLedgEntry."Initial Entry Due Date");
        DetailedVendorLedgEntry.SETFILTER("Posting Date",'<=%1',GETRANGEMAX("Date Filter"));
      END;
      COPYFILTER("Currency Filter",DetailedVendorLedgEntry."Currency Code");
      VendorLedgerEntry.DrillDownOnEntries(DetailedVendorLedgEntry);
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
        ("Purchaser Code" <> xRec."Purchaser Code") OR
        ("Country/Region Code" <> xRec."Country/Region Code") OR
        ("Fax No." <> xRec."Fax No.") OR
        ("Telex Answer Back" <> xRec."Telex Answer Back") OR
        ("VAT Registration No." <> xRec."VAT Registration No.") OR
        ("Post Code" <> xRec."Post Code") OR
        (County <> xRec.County) OR
        ("E-Mail" <> xRec."E-Mail") OR
        ("Home Page" <> xRec."Home Page");

      OnBeforeIsContactUpdateNeeded(Rec,xRec,UpdateNeeded);
      EXIT(UpdateNeeded);
    END;

    [External]
    PROCEDURE SetInsertFromTemplate@11(FromTemplate@1000 : Boolean);
    BEGIN
      InsertFromTemplate := FromTemplate;
    END;

    PROCEDURE SetAddress@40(VendorAddress@1001 : Text[50];VendorAddress2@1002 : Text[50];VendorPostCode@1003 : Code[20];VendorCity@1000 : Text[30];VendorCounty@1004 : Text[30];VendorCountryCode@1005 : Code[10];VendorContact@1006 : Text[50]);
    BEGIN
      Address := VendorAddress;
      "Address 2" := VendorAddress2;
      "Post Code" := VendorPostCode;
      City := VendorCity;
      County := VendorCounty;
      "Country/Region Code" := VendorCountryCode;
      UpdateContFromVend.OnModify(Rec);
      Contact := VendorContact;
    END;

    LOCAL PROCEDURE SetDefaultPurchaser@13();
    VAR
      UserSetup@1000 : Record 91;
    BEGIN
      IF NOT UserSetup.GET(USERID) THEN
        EXIT;

      IF UserSetup."Salespers./Purch. Code" <> '' THEN
        VALIDATE("Purchaser Code",UserSetup."Salespers./Purch. Code");
    END;

    LOCAL PROCEDURE SetLastModifiedDateTime@47();
    BEGIN
      "Last Modified Date Time" := CURRENTDATETIME;
      "Last Date Modified" := TODAY;
    END;

    LOCAL PROCEDURE VATRegistrationValidation@14();
    VAR
      VATRegistrationLog@1005 : Record 249;
      VATRegistrationNoFormat@1004 : Record 381;
      VATRegNoSrvConfig@1003 : Record 248;
      VATRegistrationLogMgt@1002 : Codeunit 249;
      ResultRecordRef@1001 : RecordRef;
      ApplicableCountryCode@1000 : Code[10];
    BEGIN
      IF NOT VATRegistrationNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Vendor) THEN
        EXIT;
      VATRegistrationLogMgt.LogVendor(Rec);

      IF ("Country/Region Code" = '') AND (VATRegistrationNoFormat."Country/Region Code" = '') THEN
        EXIT;
      ApplicableCountryCode := "Country/Region Code";
      IF ApplicableCountryCode = '' THEN
        ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
      IF VATRegNoSrvConfig.VATRegNoSrvIsEnabled THEN BEGIN
        VATRegistrationLogMgt.ValidateVATRegNoWithVIES(ResultRecordRef,Rec,"No.",
          VATRegistrationLog."Account Type"::Vendor,ApplicableCountryCode);
        ResultRecordRef.SETTABLE(Rec);
      END;
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

    PROCEDURE UpdatePaymentMethodId@17();
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

    LOCAL PROCEDURE UpdatePaymentTermsCode@15();
    VAR
      PaymentTerms@1001 : Record 3;
    BEGIN
      IF NOT ISNULLGUID("Payment Terms Id") THEN BEGIN
        PaymentTerms.SETRANGE(Id,"Payment Terms Id");
        PaymentTerms.FINDFIRST;
      END;

      VALIDATE("Payment Terms Code",PaymentTerms.Code);
    END;

    LOCAL PROCEDURE UpdatePaymentMethodCode@16();
    VAR
      PaymentMethod@1001 : Record 289;
    BEGIN
      IF NOT ISNULLGUID("Payment Method Id") THEN BEGIN
        PaymentMethod.SETRANGE(Id,"Payment Method Id");
        PaymentMethod.FINDFIRST;
      END;

      VALIDATE("Payment Method Code",PaymentMethod.Code);
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeIsContactUpdateNeeded@50(Vendor@1000 : Record 23;xVendor@1001 : Record 23;VAR UpdateNeeded@1002 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

