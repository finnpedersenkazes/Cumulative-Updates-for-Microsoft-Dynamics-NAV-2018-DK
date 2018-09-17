OBJECT Table 270 Bank Account
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783,NAVDK11.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 271=r;
    DataCaptionFields=No.,Name;
    OnInsert=BEGIN
               IF "No." = '' THEN BEGIN
                 GLSetup.GET;
                 GLSetup.TESTFIELD("Bank Account Nos.");
                 NoSeriesMgt.InitSeries(GLSetup."Bank Account Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;

               IF NOT InsertFromContact THEN
                 UpdateContFromBank.OnInsert(Rec);

               DimMgt.UpdateDefaultDim(
                 DATABASE::"Bank Account","No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");
             END;

    OnModify=BEGIN
               "Last Date Modified" := TODAY;

               IF (Name <> xRec.Name) OR
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
                  ("Our Contact Code" <> xRec."Our Contact Code") OR
                  ("Country/Region Code" <> xRec."Country/Region Code") OR
                  ("Fax No." <> xRec."Fax No.") OR
                  ("Telex Answer Back" <> xRec."Telex Answer Back") OR
                  ("Post Code" <> xRec."Post Code") OR
                  (County <> xRec.County) OR
                  ("E-Mail" <> xRec."E-Mail") OR
                  ("Home Page" <> xRec."Home Page")
               THEN BEGIN
                 MODIFY;
                 UpdateContFromBank.OnModify(Rec);
                 IF NOT FIND THEN BEGIN
                   RESET;
                   IF FIND THEN;
                 END;
               END;
             END;

    OnDelete=BEGIN
               MoveEntries.MoveBankAccEntries(Rec);

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::"Bank Account");
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               UpdateContFromBank.OnDelete(Rec);

               DimMgt.DeleteDefaultDim(DATABASE::"Bank Account","No.");
             END;

    OnRename=BEGIN
               "Last Date Modified" := TODAY;
             END;

    CaptionML=[DAN=Bankkonto;
               ENU=Bank Account];
    LookupPageID=Page371;
    DrillDownPageID=Page371;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  GLSetup.GET;
                                                                  NoSeriesMgt.TestManual(GLSetup."Bank Account Nos.");
                                                                  "No. Series" := '';
                                                                END;
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
    { 8   ;   ;Contact             ;Text50        ;CaptionML=[DAN=Kontakt;
                                                              ENU=Contact] }
    { 9   ;   ;Phone No.           ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.] }
    { 10  ;   ;Telex No.           ;Text20        ;CaptionML=[DAN=Telex;
                                                              ENU=Telex No.] }
    { 13  ;   ;Bank Account No.    ;Text30        ;OnValidate=BEGIN
                                                                IF ("Bank Account No." <> '') AND (STRLEN("Bank Account No.") < 10) THEN
                                                                  "Bank Account No." := PADSTR('',10 - STRLEN("Bank Account No."),'0') + "Bank Account No.";
                                                              END;

                                                   CaptionML=[DAN=Bankkontonr.;
                                                              ENU=Bank Account No.] }
    { 14  ;   ;Transit No.         ;Text20        ;CaptionML=[DAN=Transitnr.;
                                                              ENU=Transit No.] }
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
    { 20  ;   ;Min. Balance        ;Decimal       ;CaptionML=[DAN=Min. saldo;
                                                              ENU=Min. Balance];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 21  ;   ;Bank Acc. Posting Group;Code20     ;TableRelation="Bank Account Posting Group";
                                                   CaptionML=[DAN=Bankbogf›ringsgruppe;
                                                              ENU=Bank Acc. Posting Group] }
    { 22  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                IF "Currency Code" = xRec."Currency Code" THEN
                                                                  EXIT;

                                                                BankAcc.RESET;
                                                                BankAcc := Rec;
                                                                BankAcc.CALCFIELDS(Balance,"Balance (LCY)");
                                                                BankAcc.TESTFIELD(Balance,0);
                                                                BankAcc.TESTFIELD("Balance (LCY)",0);

                                                                IF NOT BankAccLedgEntry.SETCURRENTKEY("Bank Account No.",Open) THEN
                                                                  BankAccLedgEntry.SETCURRENTKEY("Bank Account No.");
                                                                BankAccLedgEntry.SETRANGE("Bank Account No.","No.");
                                                                BankAccLedgEntry.SETRANGE(Open,TRUE);
                                                                IF BankAccLedgEntry.FINDLAST THEN
                                                                  ERROR(
                                                                    Text000,
                                                                    FIELDCAPTION("Currency Code"));
                                                              END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 24  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 26  ;   ;Statistics Group    ;Integer       ;CaptionML=[DAN=Statistikgruppe;
                                                              ENU=Statistics Group] }
    { 29  ;   ;Our Contact Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Vores attentionkode;
                                                              ENU=Our Contact Code] }
    { 35  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr†dekode;
                                                              ENU=Country/Region Code] }
    { 37  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 38  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Comment Line" WHERE (Table Name=CONST(Bank Account),
                                                                                           No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 39  ;   ;Blocked             ;Boolean       ;CaptionML=[DAN=Sp‘rret;
                                                              ENU=Blocked] }
    { 41  ;   ;Last Statement No.  ;Code20        ;CaptionML=[DAN=Sidste kontoudtogsnr.;
                                                              ENU=Last Statement No.] }
    { 42  ;   ;Last Payment Statement No.;Code20  ;OnValidate=VAR
                                                                TextManagement@1000 : Codeunit 41;
                                                              BEGIN
                                                                TextManagement.EvaluateIncStr("Last Payment Statement No.",FIELDCAPTION("Last Payment Statement No."));
                                                              END;

                                                   CaptionML=[DAN=Kontoudtogsnr. p† sidste betaling;
                                                              ENU=Last Payment Statement No.] }
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
                                                   CalcFormula=Sum("Bank Account Ledger Entry".Amount WHERE (Bank Account No.=FIELD(No.),
                                                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
                                                   CaptionML=[DAN=Saldo;
                                                              ENU=Balance];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 59  ;   ;Balance (LCY)       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry"."Amount (LCY)" WHERE (Bank Account No.=FIELD(No.),
                                                                                                                     Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Global Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
                                                   CaptionML=[DAN=Saldo (RV);
                                                              ENU=Balance (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 60  ;   ;Net Change          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry".Amount WHERE (Bank Account No.=FIELD(No.),
                                                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                             Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Bev‘gelse;
                                                              ENU=Net Change];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 61  ;   ;Net Change (LCY)    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry"."Amount (LCY)" WHERE (Bank Account No.=FIELD(No.),
                                                                                                                     Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Bev‘gelse (RV);
                                                              ENU=Net Change (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 62  ;   ;Total on Checks     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Check Ledger Entry".Amount WHERE (Bank Account No.=FIELD(No.),
                                                                                                      Entry Status=FILTER(Posted),
                                                                                                      Statement Status=FILTER(<>Closed)));
                                                   CaptionML=[DAN=I alt i checks;
                                                              ENU=Total on Checks];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 84  ;   ;Fax No.             ;Text30        ;CaptionML=[DAN=Telefax;
                                                              ENU=Fax No.] }
    { 85  ;   ;Telex Answer Back   ;Text20        ;CaptionML=[DAN=Telex (tilbagesvar);
                                                              ENU=Telex Answer Back] }
    { 89  ;   ;Picture             ;BLOB          ;CaptionML=[DAN=Billede;
                                                              ENU=Picture];
                                                   SubType=Bitmap }
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
    { 93  ;   ;Last Check No.      ;Code20        ;AccessByPermission=TableData 272=R;
                                                   CaptionML=[DAN=Sidste checknr.;
                                                              ENU=Last Check No.] }
    { 94  ;   ;Balance Last Statement;Decimal     ;CaptionML=[DAN=Sidste kontoudtog - saldo;
                                                              ENU=Balance Last Statement];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 95  ;   ;Balance at Date     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry".Amount WHERE (Bank Account No.=FIELD(No.),
                                                                                                             Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                             Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                             Posting Date=FIELD(UPPERLIMIT(Date Filter))));
                                                   CaptionML=[DAN=Saldo til dato;
                                                              ENU=Balance at Date];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 96  ;   ;Balance at Date (LCY);Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry"."Amount (LCY)" WHERE (Bank Account No.=FIELD(No.),
                                                                                                                     Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Posting Date=FIELD(UPPERLIMIT(Date Filter))));
                                                   CaptionML=[DAN=Saldo til dato (RV);
                                                              ENU=Balance at Date (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 97  ;   ;Debit Amount        ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry"."Debit Amount" WHERE (Bank Account No.=FIELD(No.),
                                                                                                                     Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                     Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                     Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Debetbel›b;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 98  ;   ;Credit Amount       ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry"."Credit Amount" WHERE (Bank Account No.=FIELD(No.),
                                                                                                                      Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                      Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                      Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kreditbel›b;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 99  ;   ;Debit Amount (LCY)  ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry"."Debit Amount (LCY)" WHERE (Bank Account No.=FIELD(No.),
                                                                                                                           Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                           Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                           Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Debetbel›b (RV);
                                                              ENU=Debit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 100 ;   ;Credit Amount (LCY) ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Bank Account Ledger Entry"."Credit Amount (LCY)" WHERE (Bank Account No.=FIELD(No.),
                                                                                                                            Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                                                                            Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                                                                            Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Kreditbel›b (RV);
                                                              ENU=Credit Amount (LCY)];
                                                   BlankZero=Yes;
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 101 ;   ;Bank Branch No.     ;Text20        ;OnValidate=BEGIN
                                                                IF ("Bank Branch No." <> '') AND (STRLEN("Bank Branch No.") < 4) THEN
                                                                  "Bank Branch No." := PADSTR('',4 - STRLEN("Bank Branch No."),'0') + "Bank Branch No.";
                                                              END;

                                                   CaptionML=[DAN=Bankregistreringsnr.;
                                                              ENU=Bank Branch No.] }
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
    { 107 ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 108 ;   ;Check Report ID     ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Report));
                                                   CaptionML=[DAN=Tjek rapport-id;
                                                              ENU=Check Report ID] }
    { 109 ;   ;Check Report Name   ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Name" WHERE (Object Type=CONST(Report),
                                                                                                             Object ID=FIELD(Check Report ID)));
                                                   CaptionML=[DAN=Tjek rapportnavn;
                                                              ENU=Check Report Name];
                                                   Editable=No }
    { 110 ;   ;IBAN                ;Code50        ;OnValidate=VAR
                                                                CompanyInfo@1000 : Record 79;
                                                              BEGIN
                                                                CompanyInfo.CheckIBAN(IBAN);
                                                              END;

                                                   CaptionML=[DAN=IBAN;
                                                              ENU=IBAN] }
    { 111 ;   ;SWIFT Code          ;Code20        ;CaptionML=[DAN=SWIFT-kode;
                                                              ENU=SWIFT Code] }
    { 113 ;   ;Bank Statement Import Format;Code20;TableRelation="Bank Export/Import Setup".Code WHERE (Direction=CONST(Import));
                                                   CaptionML=[DAN=Format til import af bankkontoudtog;
                                                              ENU=Bank Statement Import Format] }
    { 115 ;   ;Credit Transfer Msg. Nos.;Code20   ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Kreditoverf›rselsmedd.numre;
                                                              ENU=Credit Transfer Msg. Nos.] }
    { 116 ;   ;Direct Debit Msg. Nos.;Code20      ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Direct Debit-medd.numre;
                                                              ENU=Direct Debit Msg. Nos.] }
    { 117 ;   ;SEPA Direct Debit Exp. Format;Code20;
                                                   TableRelation="Bank Export/Import Setup".Code WHERE (Direction=CONST(Export));
                                                   CaptionML=[DAN=Eksportformat for SEPA Direct Debit;
                                                              ENU=SEPA Direct Debit Exp. Format] }
    { 121 ;   ;Bank Stmt. Service Record ID;RecordID;
                                                   OnValidate=VAR
                                                                Handled@1000 : Boolean;
                                                              BEGIN
                                                                IF FORMAT("Bank Stmt. Service Record ID") = '' THEN
                                                                  OnUnlinkStatementProviderEvent(Rec,Handled);
                                                              END;

                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Id for record fra bankkontoudtogstjeneste;
                                                              ENU=Bank Stmt. Service Record ID] }
    { 123 ;   ;Transaction Import Timespan;Integer;CaptionML=[DAN=Tidsperiode for import af transaktion;
                                                              ENU=Transaction Import Timespan] }
    { 124 ;   ;Automatic Stmt. Import Enabled;Boolean;
                                                   OnValidate=BEGIN
                                                                IF "Automatic Stmt. Import Enabled" THEN BEGIN
                                                                  IF NOT IsAutoLogonPossible THEN
                                                                    ERROR(MFANotSupportedErr);

                                                                  IF NOT ("Transaction Import Timespan" IN [0..9999]) THEN
                                                                    ERROR(TransactionImportTimespanMustBePositiveErr);
                                                                  ScheduleBankStatementDownload
                                                                END ELSE
                                                                  UnscheduleBankStatementDownload;
                                                              END;

                                                   CaptionML=[DAN=Automatisk import af udtog aktiveret;
                                                              ENU=Automatic Stmt. Import Enabled] }
    { 140 ;   ;Image               ;Media         ;ExtendedDatatype=Person;
                                                   CaptionML=[DAN=Grafik;
                                                              ENU=Image] }
    { 170 ;   ;Creditor No.        ;Code35        ;CaptionML=[DAN=Kreditornummer;
                                                              ENU=Creditor No.] }
    { 1210;   ;Payment Export Format;Code20       ;TableRelation="Bank Export/Import Setup".Code WHERE (Direction=CONST(Export));
                                                   CaptionML=[DAN=Format til eksport af betaling;
                                                              ENU=Payment Export Format] }
    { 1211;   ;Bank Clearing Code  ;Text50        ;CaptionML=[DAN=Kode for bankclearing;
                                                              ENU=Bank Clearing Code] }
    { 1212;   ;Bank Clearing Standard;Text50      ;TableRelation="Bank Clearing Standard";
                                                   CaptionML=[DAN=Bankclearingsstandard;
                                                              ENU=Bank Clearing Standard] }
    { 1213;   ;Bank Name - Data Conversion;Text50 ;TableRelation="Bank Data Conv. Bank" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Banknavn - datakonvertering;
                                                              ENU=Bank Name - Data Conversion] }
    { 1250;   ;Match Tolerance Type;Option        ;OnValidate=BEGIN
                                                                IF "Match Tolerance Type" <> xRec."Match Tolerance Type" THEN
                                                                  "Match Tolerance Value" := 0;
                                                              END;

                                                   CaptionML=[DAN=Matchtolerancetype;
                                                              ENU=Match Tolerance Type];
                                                   OptionCaptionML=[DAN=Procent,Bel›b;
                                                                    ENU=Percentage,Amount];
                                                   OptionString=Percentage,Amount }
    { 1251;   ;Match Tolerance Value;Decimal      ;OnValidate=BEGIN
                                                                IF "Match Tolerance Value" < 0 THEN
                                                                  ERROR(InvalidValueErr);

                                                                IF "Match Tolerance Type" = "Match Tolerance Type"::Percentage THEN
                                                                  IF "Match Tolerance Value" > 99 THEN
                                                                    ERROR(InvalidPercentageValueErr,FIELDCAPTION("Match Tolerance Type"),
                                                                      FORMAT("Match Tolerance Type"::Percentage));
                                                              END;

                                                   CaptionML=[DAN=Matchtolerancev‘rdi;
                                                              ENU=Match Tolerance Value];
                                                   DecimalPlaces=0:5 }
    { 1260;   ;Positive Pay Export Code;Code20    ;TableRelation="Bank Export/Import Setup".Code WHERE (Direction=CONST(Export-Positive Pay));
                                                   CaptionML=[DAN=Eksportkode for Positive Pay;
                                                              ENU=Positive Pay Export Code] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Name                              }
    {    ;Bank Acc. Posting Group                  }
    {    ;Currency Code                            }
    {    ;Country/Region Code                      }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Name,Bank Account No.,Currency Code  }
    { 2   ;Brick               ;No.,Name,Bank Account No.,Currency Code,Image }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Du kan ikke ‘ndre %1, fordi der er en eller flere †bne poster p† denne bankkonto;ENU=You cannot change %1 because there are one or more open ledger entries for this bank account.';
      Text003@1003 : TextConst 'DAN=Vil du oprette en attentionpost for %1 %2?;ENU=Do you wish to create a contact for %1 %2?';
      GLSetup@1004 : Record 98;
      BankAcc@1005 : Record 270;
      BankAccLedgEntry@1006 : Record 271;
      CommentLine@1007 : Record 97;
      PostCode@1008 : Record 225;
      NoSeriesMgt@1009 : Codeunit 396;
      MoveEntries@1010 : Codeunit 361;
      UpdateContFromBank@1011 : Codeunit 5058;
      DimMgt@1012 : Codeunit 408;
      InsertFromContact@1013 : Boolean;
      Text004@1014 : TextConst 'DAN=Vinduet Ops‘tning af Online Map skal udfyldes, f›r du kan bruge Online Map.\Se Ops‘tning af Online Map i Hj‘lp.;ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
      BankAccIdentifierIsEmptyErr@1001 : TextConst 'DAN=Du skal angive et %1 eller et %2.;ENU=You must specify either a %1 or an %2.';
      InvalidPercentageValueErr@1002 : TextConst '@@@=%1 is "field caption and %2 is "Percentage";DAN=Hvis %1 er %2, skal v‘rdien v‘re mellem 0 og 99.;ENU=If %1 is %2, then the value must be between 0 and 99.';
      InvalidValueErr@1015 : TextConst 'DAN=V‘rdien skal v‘re positiv.;ENU=The value must be positive.';
      DataExchNotSetErr@1016 : TextConst 'DAN=Feltet Dataudvekslingskode skal udfyldes.;ENU=The Data Exchange Code field must be filled.';
      BankStmtScheduledDownloadDescTxt@1018 : TextConst '@@@=%1 - Bank Account name;DAN=%1 Import af bankkontoudtog;ENU=%1 Bank Statement Import';
      JobQEntriesCreatedQst@1019 : TextConst 'DAN=Der er oprettet en opgavek›post til import af bankkontoudtog.\\Vil du †bne vinduet Opgavek›post?;ENU=A job queue entry for import of bank statements has been created.\\Do you want to open the Job Queue Entry window?';
      TransactionImportTimespanMustBePositiveErr@1020 : TextConst 'DAN=V‘rdien i feltet Antal inkluderede dage skal v‘re et positivt tal p† h›jst 9999.;ENU=The value in the Number of Days Included field must be a positive number not greater than 9999.';
      MFANotSupportedErr@1021 : TextConst 'DAN=Den automatiske import af bankkontoudtog kan ikke konfigureres, da den valgte bank kr‘ver multifaktorgodkendelse.;ENU=Cannot setup automatic bank statement import because the selected bank requires multi-factor authentication.';
      BankAccNotLinkedErr@1023 : TextConst 'DAN=Denne bankkonto er ikke tilknyttet en online bankkonto.;ENU=This bank account is not linked to an online bank account.';
      AutoLogonNotPossibleErr@1024 : TextConst 'DAN=Automatisk logon er ikke mulig for denne bankkonto.;ENU=Automatic logon is not possible for this bank account.';
      CancelTxt@1017 : TextConst 'DAN=Annuller;ENU=Cancel';
      OnlineFeedStatementStatus@1022 : 'Not Linked,Linked,Linked and Auto. Bank Statement Enabled';

    [External]
    PROCEDURE AssistEdit@2(OldBankAcc@1000 : Record 270) : Boolean;
    BEGIN
      WITH BankAcc DO BEGIN
        BankAcc := Rec;
        GLSetup.GET;
        GLSetup.TESTFIELD("Bank Account Nos.");
        IF NoSeriesMgt.SelectSeries(GLSetup."Bank Account Nos.",OldBankAcc."No. Series","No. Series") THEN BEGIN
          GLSetup.GET;
          GLSetup.TESTFIELD("Bank Account Nos.");
          NoSeriesMgt.SetSeries("No.");
          Rec := BankAcc;
          EXIT(TRUE);
        END;
      END;
    END;

    [External]
    PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::"Bank Account","No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    END;

    [External]
    PROCEDURE ShowContact@1();
    VAR
      ContBusRel@1000 : Record 5054;
      Cont@1001 : Record 5050;
    BEGIN
      IF "No." = '' THEN
        EXIT;

      ContBusRel.SETCURRENTKEY("Link to Table","No.");
      ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::"Bank Account");
      ContBusRel.SETRANGE("No.","No.");
      IF NOT ContBusRel.FINDFIRST THEN BEGIN
        IF NOT CONFIRM(Text003,FALSE,TABLECAPTION,"No.") THEN
          EXIT;
        UpdateContFromBank.InsertNewContact(Rec,FALSE);
        ContBusRel.FINDFIRST;
      END;
      COMMIT;

      Cont.SETCURRENTKEY("Company Name","Company No.",Type,Name);
      Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
      PAGE.RUN(PAGE::"Contact List",Cont);
    END;

    [External]
    PROCEDURE SetInsertFromContact@3(FromContact@1000 : Boolean);
    BEGIN
      InsertFromContact := FromContact;
    END;

    [External]
    PROCEDURE GetPaymentExportCodeunitID@6() : Integer;
    VAR
      BankExportImportSetup@1000 : Record 1200;
    BEGIN
      GetBankExportImportSetup(BankExportImportSetup);
      EXIT(BankExportImportSetup."Processing Codeunit ID");
    END;

    [External]
    PROCEDURE GetPaymentExportXMLPortID@4() : Integer;
    VAR
      BankExportImportSetup@1000 : Record 1200;
    BEGIN
      GetBankExportImportSetup(BankExportImportSetup);
      BankExportImportSetup.TESTFIELD("Processing XMLport ID");
      EXIT(BankExportImportSetup."Processing XMLport ID");
    END;

    [External]
    PROCEDURE GetDDExportCodeunitID@11() : Integer;
    VAR
      BankExportImportSetup@1000 : Record 1200;
    BEGIN
      GetDDExportImportSetup(BankExportImportSetup);
      BankExportImportSetup.TESTFIELD("Processing Codeunit ID");
      EXIT(BankExportImportSetup."Processing Codeunit ID");
    END;

    [External]
    PROCEDURE GetDDExportXMLPortID@9() : Integer;
    VAR
      BankExportImportSetup@1000 : Record 1200;
    BEGIN
      GetDDExportImportSetup(BankExportImportSetup);
      BankExportImportSetup.TESTFIELD("Processing XMLport ID");
      EXIT(BankExportImportSetup."Processing XMLport ID");
    END;

    [External]
    PROCEDURE GetBankExportImportSetup@8(VAR BankExportImportSetup@1001 : Record 1200);
    BEGIN
      TESTFIELD("Payment Export Format");
      BankExportImportSetup.GET("Payment Export Format");
    END;

    [External]
    PROCEDURE GetDDExportImportSetup@12(VAR BankExportImportSetup@1001 : Record 1200);
    BEGIN
      TESTFIELD("SEPA Direct Debit Exp. Format");
      BankExportImportSetup.GET("SEPA Direct Debit Exp. Format");
    END;

    [External]
    PROCEDURE GetCreditTransferMessageNo@5() : Code[20];
    VAR
      NoSeriesManagement@1000 : Codeunit 396;
    BEGIN
      TESTFIELD("Credit Transfer Msg. Nos.");
      EXIT(NoSeriesManagement.GetNextNo("Credit Transfer Msg. Nos.",TODAY,TRUE));
    END;

    [External]
    PROCEDURE GetDirectDebitMessageNo@10() : Code[20];
    VAR
      NoSeriesManagement@1000 : Codeunit 396;
    BEGIN
      TESTFIELD("Direct Debit Msg. Nos.");
      EXIT(NoSeriesManagement.GetNextNo("Direct Debit Msg. Nos.",TODAY,TRUE));
    END;

    [Internal]
    PROCEDURE DisplayMap@7();
    VAR
      MapPoint@1001 : Record 800;
      MapMgt@1000 : Codeunit 802;
    BEGIN
      IF MapPoint.FINDFIRST THEN
        MapMgt.MakeSelection(DATABASE::"Bank Account",GETPOSITION)
      ELSE
        MESSAGE(Text004);
    END;

    [External]
    PROCEDURE GetDataExchDef@13(VAR DataExchDef@1000 : Record 1222);
    VAR
      BankExportImportSetup@1001 : Record 1200;
      DataExchDefCodeResponse@1002 : Code[20];
      Handled@1003 : Boolean;
    BEGIN
      OnGetDataExchangeDefinitionEvent(DataExchDefCodeResponse,Handled);
      IF NOT Handled THEN BEGIN
        TESTFIELD("Bank Statement Import Format");
        DataExchDefCodeResponse := "Bank Statement Import Format";
      END;

      IF DataExchDefCodeResponse = '' THEN
        ERROR(DataExchNotSetErr);

      BankExportImportSetup.GET(DataExchDefCodeResponse);
      BankExportImportSetup.TESTFIELD("Data Exch. Def. Code");

      DataExchDef.GET(BankExportImportSetup."Data Exch. Def. Code");
      DataExchDef.TESTFIELD(Type,DataExchDef.Type::"Bank Statement Import");
    END;

    [External]
    PROCEDURE GetBankAccountNoWithCheck@14() AccountNo : Text;
    BEGIN
      AccountNo := GetBankAccountNo;
      IF AccountNo = '' THEN
        ERROR(BankAccIdentifierIsEmptyErr,FIELDCAPTION("Bank Account No."),FIELDCAPTION(IBAN));
    END;

    [External]
    PROCEDURE GetBankAccountNo@15() : Text;
    BEGIN
      IF ("Bank Branch No." = '') OR ("Bank Account No." = '') THEN
        EXIT(DELCHR(IBAN,'=<>'));

      EXIT("Bank Branch No." + "Bank Account No.");
    END;

    [External]
    PROCEDURE IsInLocalCurrency@16() : Boolean;
    VAR
      GeneralLedgerSetup@1000 : Record 98;
    BEGIN
      IF "Currency Code" = '' THEN
        EXIT(TRUE);

      GeneralLedgerSetup.GET;
      EXIT("Currency Code" = GeneralLedgerSetup.GetCurrencyCode(''));
    END;

    [External]
    PROCEDURE GetPosPayExportCodeunitID@17() : Integer;
    VAR
      BankExportImportSetup@1000 : Record 1200;
    BEGIN
      TESTFIELD("Positive Pay Export Code");
      BankExportImportSetup.GET("Positive Pay Export Code");
      EXIT(BankExportImportSetup."Processing Codeunit ID");
    END;

    [External]
    PROCEDURE IsLinkedToBankStatementServiceProvider@27() : Boolean;
    VAR
      IsBankAccountLinked@1000 : Boolean;
    BEGIN
      OnCheckLinkedToStatementProviderEvent(Rec,IsBankAccountLinked);
      EXIT(IsBankAccountLinked);
    END;

    [External]
    PROCEDURE StatementProvidersExist@37() : Boolean;
    VAR
      TempNameValueBuffer@1000 : TEMPORARY Record 823;
    BEGIN
      OnGetStatementProvidersEvent(TempNameValueBuffer);
      EXIT(NOT TempNameValueBuffer.ISEMPTY);
    END;

    [External]
    PROCEDURE LinkStatementProvider@32(VAR BankAccount@1001 : Record 270);
    VAR
      StatementProvider@1000 : Text;
    BEGIN
      StatementProvider := SelectBankLinkingService;

      IF StatementProvider <> '' THEN
        OnLinkStatementProviderEvent(BankAccount,StatementProvider);
    END;

    [External]
    PROCEDURE SimpleLinkStatementProvider@39(VAR OnlineBankAccLink@1001 : Record 777);
    VAR
      StatementProvider@1000 : Text;
    BEGIN
      StatementProvider := SelectBankLinkingService;

      IF StatementProvider <> '' THEN
        OnSimpleLinkStatementProviderEvent(OnlineBankAccLink,StatementProvider);
    END;

    [External]
    PROCEDURE UnlinkStatementProvider@31();
    VAR
      Handled@1000 : Boolean;
    BEGIN
      OnUnlinkStatementProviderEvent(Rec,Handled);
    END;

    [External]
    PROCEDURE UpdateBankAccountLinking@35();
    VAR
      StatementProvider@1000 : Text;
    BEGIN
      StatementProvider := SelectBankLinkingService;

      IF StatementProvider <> '' THEN
        OnUpdateBankAccountLinkingEvent(Rec,StatementProvider);
    END;

    [External]
    PROCEDURE GetUnlinkedBankAccounts@30(VAR TempUnlinkedBankAccount@1000 : TEMPORARY Record 270);
    VAR
      BankAccount@1001 : Record 270;
    BEGIN
      IF BankAccount.FINDSET THEN
        REPEAT
          IF NOT BankAccount.IsLinkedToBankStatementServiceProvider THEN BEGIN
            TempUnlinkedBankAccount := BankAccount;
            TempUnlinkedBankAccount.INSERT;
          END;
        UNTIL BankAccount.NEXT = 0;
    END;

    [External]
    PROCEDURE GetLinkedBankAccounts@33(VAR TempUnlinkedBankAccount@1000 : TEMPORARY Record 270);
    VAR
      BankAccount@1001 : Record 270;
    BEGIN
      IF BankAccount.FINDSET THEN
        REPEAT
          IF BankAccount.IsLinkedToBankStatementServiceProvider THEN BEGIN
            TempUnlinkedBankAccount := BankAccount;
            TempUnlinkedBankAccount.INSERT;
          END;
        UNTIL BankAccount.NEXT = 0;
    END;

    LOCAL PROCEDURE SelectBankLinkingService@38() : Text;
    VAR
      TempNameValueBuffer@1002 : TEMPORARY Record 823;
      OptionStr@1001 : Text;
      OptionNo@1000 : Integer;
    BEGIN
      OnGetStatementProvidersEvent(TempNameValueBuffer);

      IF TempNameValueBuffer.ISEMPTY THEN
        EXIT(''); // Action should not be visible in this case so should not occur

      IF (TempNameValueBuffer.COUNT = 1) OR (NOT GUIALLOWED) THEN
        EXIT(TempNameValueBuffer.Name);

      TempNameValueBuffer.FINDSET;
      REPEAT
        OptionStr += STRSUBSTNO('%1,',TempNameValueBuffer.Value);
      UNTIL TempNameValueBuffer.NEXT = 0;
      OptionStr += CancelTxt;

      OptionNo := STRMENU(OptionStr);
      IF (OptionNo = 0) OR (OptionNo = TempNameValueBuffer.COUNT + 1) THEN
        EXIT;

      TempNameValueBuffer.SETRANGE(Value,SELECTSTR(OptionNo,OptionStr));
      TempNameValueBuffer.FINDFIRST;

      EXIT(TempNameValueBuffer.Name);
    END;

    [External]
    PROCEDURE IsAutoLogonPossible@28() : Boolean;
    VAR
      AutoLogonPossible@1000 : Boolean;
    BEGIN
      AutoLogonPossible := TRUE;
      OnCheckAutoLogonPossibleEvent(Rec,AutoLogonPossible);
      EXIT(AutoLogonPossible)
    END;

    LOCAL PROCEDURE ScheduleBankStatementDownload@18();
    VAR
      JobQueueEntry@1002 : Record 472;
    BEGIN
      IF NOT IsLinkedToBankStatementServiceProvider THEN
        ERROR(BankAccNotLinkedErr);
      IF NOT IsAutoLogonPossible THEN
        ERROR(AutoLogonNotPossibleErr);

      JobQueueEntry.ScheduleRecurrentJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
        CODEUNIT::"Automatic Import of Bank Stmt.",RECORDID);
      JobQueueEntry."Timeout (sec.)" := 1800;
      JobQueueEntry.Description :=
        COPYSTR(STRSUBSTNO(BankStmtScheduledDownloadDescTxt,Name),1,MAXSTRLEN(JobQueueEntry.Description));
      JobQueueEntry."Notify On Success" := FALSE;
      JobQueueEntry."No. of Minutes between Runs" := 121;
      JobQueueEntry.MODIFY;
      IF CONFIRM(JobQEntriesCreatedQst) THEN
        ShowBankStatementDownloadJobQueueEntry;
    END;

    LOCAL PROCEDURE UnscheduleBankStatementDownload@20();
    VAR
      JobQueueEntry@1002 : Record 472;
    BEGIN
      SetAutomaticImportJobQueueEntryFilters(JobQueueEntry);
      IF NOT JobQueueEntry.ISEMPTY THEN
        JobQueueEntry.DELETEALL;
    END;

    [External]
    PROCEDURE CreateNewAccount@42(OnlineBankAccLink@1000 : Record 777);
    BEGIN
      INIT;
      VALIDATE("Bank Account No.",OnlineBankAccLink."Bank Account No.");
      VALIDATE(Name,OnlineBankAccLink.Name);
      VALIDATE("Currency Code",OnlineBankAccLink."Currency Code");
      VALIDATE(Contact,OnlineBankAccLink.Contact);
    END;

    LOCAL PROCEDURE ShowBankStatementDownloadJobQueueEntry@19();
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      SetAutomaticImportJobQueueEntryFilters(JobQueueEntry);
      IF JobQueueEntry.FINDFIRST THEN
        PAGE.RUN(PAGE::"Job Queue Entry Card",JobQueueEntry);
    END;

    LOCAL PROCEDURE SetAutomaticImportJobQueueEntryFilters@21(VAR JobQueueEntry@1000 : Record 472);
    BEGIN
      JobQueueEntry.SETRANGE("Object Type to Run",JobQueueEntry."Object Type to Run"::Codeunit);
      JobQueueEntry.SETRANGE("Object ID to Run",CODEUNIT::"Automatic Import of Bank Stmt.");
      JobQueueEntry.SETRANGE("Record ID to Process",RECORDID);
    END;

    [External]
    PROCEDURE GetOnlineFeedStatementStatus@44(VAR OnlineFeedStatus@1000 : Option;VAR Linked@1001 : Boolean);
    BEGIN
      Linked := FALSE;
      OnlineFeedStatus := OnlineFeedStatementStatus::"Not Linked";
      IF IsLinkedToBankStatementServiceProvider THEN BEGIN
        Linked := TRUE;
        OnlineFeedStatus := OnlineFeedStatementStatus::Linked;
        IF IsScheduledBankStatement THEN
          OnlineFeedStatus := OnlineFeedStatementStatus::"Linked and Auto. Bank Statement Enabled";
      END;
    END;

    LOCAL PROCEDURE IsScheduledBankStatement@43() : Boolean;
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      JobQueueEntry.SETRANGE("Record ID to Process",RECORDID);
      EXIT(JobQueueEntry.FINDFIRST);
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnCheckLinkedToStatementProviderEvent@22(VAR BankAccount@1000 : Record 270;VAR IsLinked@1002 : Boolean);
    BEGIN
      // The subscriber of this event should answer whether the bank account is linked to a bank statement provider service
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnCheckAutoLogonPossibleEvent@23(VAR BankAccount@1000 : Record 270;VAR AutoLogonPossible@1001 : Boolean);
    BEGIN
      // The subscriber of this event should answer whether the bank account can be logged on to without multi-factor authentication
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnUnlinkStatementProviderEvent@24(VAR BankAccount@1000 : Record 270;VAR Handled@1002 : Boolean);
    BEGIN
      // The subscriber of this event should unlink the bank account from a bank statement provider service
    END;

    [Integration]
    [External]
    PROCEDURE OnMarkAccountLinkedEvent@41(VAR OnlineBankAccLink@1000 : Record 777;VAR BankAccount@1001 : Record 270);
    BEGIN
      // The subscriber of this event should Mark the account linked to a bank statement provider service
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnSimpleLinkStatementProviderEvent@40(VAR OnlineBankAccLink@1000 : Record 777;VAR StatementProvider@1002 : Text);
    BEGIN
      // The subscriber of this event should link the bank account to a bank statement provider service
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnLinkStatementProviderEvent@25(VAR BankAccount@1000 : Record 270;VAR StatementProvider@1002 : Text);
    BEGIN
      // The subscriber of this event should link the bank account to a bank statement provider service
    END;

    [Integration(TRUE)]
    [External]
    LOCAL PROCEDURE OnGetDataExchangeDefinitionEvent@26(VAR DataExchDefCodeResponse@1001 : Code[20];VAR Handled@1000 : Boolean);
    BEGIN
      // This event should retrieve the data exchange definition format for processing the online feeds
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnUpdateBankAccountLinkingEvent@34(VAR BankAccount@1000 : Record 270;VAR StatementProvider@1001 : Text);
    BEGIN
      // This event should handle updating of the single or multiple bank accounts
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnGetStatementProvidersEvent@36(VAR TempNameValueBuffer@1002 : TEMPORARY Record 823);
    BEGIN
      // The subscriber of this event should insert a unique identifier (Name) and friendly name of the provider (Value)
    END;

    BEGIN
    END.
  }
}

