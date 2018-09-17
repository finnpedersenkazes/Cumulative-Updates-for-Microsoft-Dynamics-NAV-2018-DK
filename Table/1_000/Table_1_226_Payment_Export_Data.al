OBJECT Table 1226 Payment Export Data
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF NOT PreserveNonLatinCharacters THEN
                 PaymentExportConvertToLatin;
             END;

    CaptionML=[DAN=Data til eksport af betaling;
               ENU=Payment Export Data];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Data Exch Entry No. ;Integer       ;TableRelation="Data Exch.";
                                                   CaptionML=[DAN=Dataudvekslingspostnr.;
                                                              ENU=Data Exch Entry No.] }
    { 3   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 4   ;   ;Data Exch. Line Def Code;Code20    ;CaptionML=[DAN=Definitionskode for dataudvekslingslinje;
                                                              ENU=Data Exch. Line Def Code] }
    { 5   ;   ;General Journal Template;Code10    ;TableRelation="Gen. Journal Template";
                                                   CaptionML=[DAN=Finanskladdetype;
                                                              ENU=General Journal Template] }
    { 6   ;   ;General Journal Batch Name;Code10  ;TableRelation="Gen. Journal Batch";
                                                   CaptionML=[DAN=Finanskladdenavn;
                                                              ENU=General Journal Batch Name] }
    { 7   ;   ;General Journal Line No.;Integer   ;CaptionML=[DAN=Finanskladdelinjenr.;
                                                              ENU=General Journal Line No.] }
    { 28  ;   ;Sender Bank Name - Data Conv.;Text50;
                                                   CaptionML=[DAN=Afsenderbanks navn - datakonvertering;
                                                              ENU=Sender Bank Name - Data Conv.] }
    { 29  ;   ;Sender Bank Name    ;Text50        ;CaptionML=[DAN=Afsenderbanks navn;
                                                              ENU=Sender Bank Name] }
    { 30  ;   ;Sender Bank Account Code;Code20    ;TableRelation="Bank Account";
                                                   CaptionML=[DAN=Afsenders bankkontokode;
                                                              ENU=Sender Bank Account Code] }
    { 31  ;   ;Sender Bank Account No.;Text50     ;CaptionML=[DAN=Afsenders bankkontonr.;
                                                              ENU=Sender Bank Account No.] }
    { 32  ;   ;Sender Bank Account Currency;Code10;TableRelation=Currency;
                                                   CaptionML=[DAN=Afsenderbanks kontovaluta;
                                                              ENU=Sender Bank Account Currency] }
    { 33  ;   ;Sender Bank Country/Region;Code10  ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Afsenderbanks land/omr†de;
                                                              ENU=Sender Bank Country/Region] }
    { 34  ;   ;Sender Bank BIC     ;Code35        ;CaptionML=[DAN=Afsenders bank-BIC;
                                                              ENU=Sender Bank BIC] }
    { 35  ;   ;Sender Bank Clearing Std.;Text50   ;TableRelation="Bank Clearing Standard";
                                                   CaptionML=[DAN=Afsenderbanks clearingstandard;
                                                              ENU=Sender Bank Clearing Std.] }
    { 36  ;   ;Sender Bank Clearing Code;Text50   ;CaptionML=[DAN=Afsenderbanks clearingkode;
                                                              ENU=Sender Bank Clearing Code] }
    { 37  ;   ;Sender Bank Address ;Text50        ;CaptionML=[DAN=Afsenderbanks adresse;
                                                              ENU=Sender Bank Address] }
    { 38  ;   ;Sender Bank City    ;Text50        ;CaptionML=[DAN=Afsenderbanks by;
                                                              ENU=Sender Bank City] }
    { 39  ;   ;Sender Bank Post Code;Code20       ;CaptionML=[DAN=Afsenderbanks postnummer;
                                                              ENU=Sender Bank Post Code] }
    { 40  ;   ;Recipient Name      ;Text50        ;CaptionML=[DAN=Modtagers navn;
                                                              ENU=Recipient Name] }
    { 41  ;   ;Recipient Address   ;Text50        ;CaptionML=[DAN=Modtagers adresse;
                                                              ENU=Recipient Address] }
    { 42  ;   ;Recipient City      ;Text50        ;CaptionML=[DAN=Modtagers by;
                                                              ENU=Recipient City] }
    { 43  ;   ;Recipient Post Code ;Code20        ;CaptionML=[DAN=Modtagers postnr.;
                                                              ENU=Recipient Post Code] }
    { 44  ;   ;Recipient Country/Region Code;Code10;
                                                   CaptionML=[DAN=Modtagers lande-/omr†dekode;
                                                              ENU=Recipient Country/Region Code] }
    { 45  ;   ;Recipient Email Address;Text80     ;CaptionML=[DAN=Modtagers mailadresse;
                                                              ENU=Recipient Email Address] }
    { 46  ;   ;Recipient ID        ;Code20        ;CaptionML=[DAN=Modtager-id;
                                                              ENU=Recipient ID] }
    { 48  ;   ;Recipient Bank Clearing Std.;Text50;TableRelation="Bank Clearing Standard";
                                                   CaptionML=[DAN=Modtagerbanks clearingstandard;
                                                              ENU=Recipient Bank Clearing Std.] }
    { 49  ;   ;Recipient Bank Clearing Code;Text50;CaptionML=[DAN=Modtagerbanks clearingkode;
                                                              ENU=Recipient Bank Clearing Code] }
    { 50  ;   ;Recipient Reg. No.  ;Code20        ;CaptionML=[DAN=Modtagers registreringsnr.;
                                                              ENU=Recipient Reg. No.] }
    { 51  ;   ;Recipient Acc. No.  ;Code30        ;CaptionML=[DAN=Modtagers kontonr.;
                                                              ENU=Recipient Acc. No.] }
    { 52  ;   ;Recipient Bank Acc. No.;Text50     ;CaptionML=[DAN=Modtagers bankkontonr.;
                                                              ENU=Recipient Bank Acc. No.] }
    { 53  ;   ;Recipient Bank BIC  ;Code35        ;CaptionML=[DAN=Modtagerbanks BIC;
                                                              ENU=Recipient Bank BIC] }
    { 54  ;   ;Recipient Bank Name ;Text50        ;CaptionML=[DAN=Modtagerbanks navn;
                                                              ENU=Recipient Bank Name] }
    { 55  ;   ;Recipient Bank Address;Text50      ;CaptionML=[DAN=Modtagerbanks adresse;
                                                              ENU=Recipient Bank Address] }
    { 56  ;   ;Recipient Bank City ;Text50        ;CaptionML=[DAN=Modtagerbanks by;
                                                              ENU=Recipient Bank City] }
    { 57  ;   ;Recipient Bank Country/Region;Code10;
                                                   TableRelation=Country/Region;
                                                   CaptionML=[DAN=Modtagerbanks land/omr†de;
                                                              ENU=Recipient Bank Country/Region] }
    { 58  ;   ;Recipient Creditor No.;Code20      ;CaptionML=[DAN=Modtagers kreditornr.;
                                                              ENU=Recipient Creditor No.] }
    { 59  ;   ;Recipient Bank Post Code;Code20    ;CaptionML=[DAN=Modtagerbanks postnr.;
                                                              ENU=Recipient Bank Post Code] }
    { 60  ;   ;Message Type        ;Code1         ;CaptionML=[DAN=Meddelelsestype;
                                                              ENU=Message Type] }
    { 61  ;   ;Letter to Sender    ;Code1         ;CaptionML=[DAN=Brev til afsender;
                                                              ENU=Letter to Sender] }
    { 63  ;   ;Recipient Acknowledgement;Code1    ;CaptionML=[DAN=Modtagers bekr‘ftelse;
                                                              ENU=Recipient Acknowledgement] }
    { 64  ;   ;Short Advice        ;Text35        ;CaptionML=[DAN=Kort advis;
                                                              ENU=Short Advice] }
    { 65  ;   ;Message to Recipient 1;Text140     ;CaptionML=[DAN=Meddelelse til modtager 1;
                                                              ENU=Message to Recipient 1] }
    { 66  ;   ;Message to Recipient 2;Text140     ;CaptionML=[DAN=Meddelelse til modtager 2;
                                                              ENU=Message to Recipient 2] }
    { 80  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   DecimalPlaces=2:2 }
    { 81  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 82  ;   ;Transfer Date       ;Date          ;CaptionML=[DAN=Overflytningsdato;
                                                              ENU=Transfer Date] }
    { 83  ;   ;Transfer Type       ;Code1         ;CaptionML=[DAN=Overflytningstype;
                                                              ENU=Transfer Type] }
    { 84  ;   ;Payment Type        ;Text50        ;CaptionML=[DAN=Betalingstype;
                                                              ENU=Payment Type] }
    { 85  ;   ;Document No.        ;Code20        ;CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 87  ;   ;Recipient Reference ;Code35        ;CaptionML=[DAN=Modtagers reference;
                                                              ENU=Recipient Reference] }
    { 88  ;   ;Payment Reference   ;Code50        ;CaptionML=[DAN=Betalingsreference;
                                                              ENU=Payment Reference] }
    { 89  ;   ;Invoice Amount      ;Decimal       ;CaptionML=[DAN=Fakturabel›b;
                                                              ENU=Invoice Amount] }
    { 90  ;   ;Invoice Date        ;Date          ;CaptionML=[DAN=Fakturadato;
                                                              ENU=Invoice Date] }
    { 91  ;   ;Recipient County    ;Text30        ;CaptionML=[DAN=Modtagers amt;
                                                              ENU=Recipient County] }
    { 92  ;   ;Recipient Bank County;Text30       ;CaptionML=[DAN=Modtagers banklandsdel;
                                                              ENU=Recipient Bank County] }
    { 93  ;   ;Sender Bank County  ;Text30        ;CaptionML=[DAN=Afsenders banklandsdel;
                                                              ENU=Sender Bank County] }
    { 100 ;   ;Payment Information ID;Text50      ;CaptionML=[DAN=Betalingsoplysnings-id;
                                                              ENU=Payment Information ID] }
    { 101 ;   ;End-to-End ID       ;Text50        ;CaptionML=[DAN=Slutpunkt-til-slutpunkt-id;
                                                              ENU=End-to-End ID] }
    { 102 ;   ;Message ID          ;Text35        ;CaptionML=[DAN=Meddelelses-id;
                                                              ENU=Message ID] }
    { 103 ;   ;SEPA Instruction Priority;Option   ;OnValidate=BEGIN
                                                                CASE "SEPA Instruction Priority" OF
                                                                  "SEPA Instruction Priority"::NORMAL:
                                                                    "SEPA Instruction Priority Text" := 'NORM';
                                                                  "SEPA Instruction Priority"::HIGH:
                                                                    "SEPA Instruction Priority Text" := 'HIGH';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=SEPA Instruktionsprioritet;
                                                              ENU=SEPA Instruction Priority];
                                                   OptionCaptionML=[DAN=NORMAL,HIGH;
                                                                    ENU=NORMAL,HIGH];
                                                   OptionString=NORMAL,HIGH }
    { 104 ;   ;SEPA Instruction Priority Text;Code4;
                                                   CaptionML=[DAN=SEPA Instruktionsprioritetstekst;
                                                              ENU=SEPA Instruction Priority Text];
                                                   Editable=No }
    { 105 ;   ;SEPA Payment Method ;Option        ;InitValue=TRF;
                                                   OnValidate=BEGIN
                                                                CASE "SEPA Payment Method" OF
                                                                  "SEPA Payment Method"::CHK:
                                                                    "SEPA Payment Method Text" := 'CHK';
                                                                  "SEPA Payment Method"::TRF:
                                                                    "SEPA Payment Method Text" := 'TRF';
                                                                  "SEPA Payment Method"::TRA:
                                                                    "SEPA Payment Method Text" := 'TRA';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=SEPA Betalingsform;
                                                              ENU=SEPA Payment Method];
                                                   OptionCaptionML=[DAN=CHK,TRF,TRA;
                                                                    ENU=CHK,TRF,TRA];
                                                   OptionString=CHK,TRF,TRA }
    { 106 ;   ;SEPA Payment Method Text;Code3     ;CaptionML=[DAN=SEPA Betalingsformstekst;
                                                              ENU=SEPA Payment Method Text] }
    { 107 ;   ;SEPA Batch Booking  ;Boolean       ;CaptionML=[DAN=SEPA Massebogf›ring;
                                                              ENU=SEPA Batch Booking] }
    { 108 ;   ;SEPA Charge Bearer  ;Option        ;InitValue=SLEV;
                                                   OnValidate=BEGIN
                                                                CASE "SEPA Charge Bearer" OF
                                                                  "SEPA Charge Bearer"::DEBT:
                                                                    "SEPA Charge Bearer Text" := 'DEBT';
                                                                  "SEPA Charge Bearer"::CRED:
                                                                    "SEPA Charge Bearer Text" := 'CRED';
                                                                  "SEPA Charge Bearer"::SHAR:
                                                                    "SEPA Charge Bearer Text" := 'SHAR';
                                                                  "SEPA Charge Bearer"::SLEV:
                                                                    "SEPA Charge Bearer Text" := 'SLEV';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=SEPA Debiter ih‘ndehaver;
                                                              ENU=SEPA Charge Bearer];
                                                   OptionCaptionML=[DAN=DEBT,CRED,SHAR,SLEV;
                                                                    ENU=DEBT,CRED,SHAR,SLEV];
                                                   OptionString=DEBT,CRED,SHAR,SLEV }
    { 109 ;   ;SEPA Charge Bearer Text;Code4      ;CaptionML=[DAN=SEPA Tekst til Debiter ih‘ndehaver;
                                                              ENU=SEPA Charge Bearer Text] }
    { 120 ;   ;SEPA Direct Debit Mandate ID;Code35;CaptionML=[DAN=Id for SEPA Direct Debit-betalingsaftale;
                                                              ENU=SEPA Direct Debit Mandate ID] }
    { 121 ;   ;SEPA Direct Debit Seq. Type;Option ;OnValidate=BEGIN
                                                                CASE "SEPA Direct Debit Seq. Type" OF
                                                                  "SEPA Direct Debit Seq. Type"::"One Off":
                                                                    "SEPA Direct Debit Seq. Text" := 'OOFF';
                                                                  "SEPA Direct Debit Seq. Type"::First:
                                                                    "SEPA Direct Debit Seq. Text" := 'FRST';
                                                                  "SEPA Direct Debit Seq. Type"::Recurring:
                                                                    "SEPA Direct Debit Seq. Text" := 'RCUR';
                                                                  "SEPA Direct Debit Seq. Type"::Last:
                                                                    "SEPA Direct Debit Seq. Text" := 'FNAL';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=SEPA Direct Debit-sekvenstype;
                                                              ENU=SEPA Direct Debit Seq. Type];
                                                   OptionCaptionML=[DAN=Engangsbetaling,F›rste,Tilbagevendende betaling,Sidste;
                                                                    ENU=One Off,First,Recurring,Last];
                                                   OptionString=One Off,First,Recurring,Last }
    { 122 ;   ;SEPA Direct Debit Seq. Text;Code4  ;CaptionML=[DAN=SEPA Direct Debit-sekvenstekst;
                                                              ENU=SEPA Direct Debit Seq. Text] }
    { 123 ;   ;SEPA DD Mandate Signed Date;Date   ;CaptionML=[DAN=Underskriftsdato for SEPA Direct Debit-betalingsaftale;
                                                              ENU=SEPA DD Mandate Signed Date] }
    { 124 ;   ;SEPA Partner Type   ;Option        ;OnValidate=BEGIN
                                                                CASE "SEPA Partner Type" OF
                                                                  "SEPA Partner Type"::" ":
                                                                    "SEPA Partner Type Text" := '';
                                                                  "SEPA Partner Type"::Company:
                                                                    "SEPA Partner Type Text" := 'B2B';
                                                                  "SEPA Partner Type"::Person:
                                                                    "SEPA Partner Type Text" := 'CORE';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=SEPA Partnertype;
                                                              ENU=SEPA Partner Type];
                                                   OptionCaptionML=[DAN=" ,Virksomhed,Person";
                                                                    ENU=" ,Company,Person"];
                                                   OptionString=[ ,Company,Person] }
    { 125 ;   ;SEPA Partner Type Text;Code4       ;CaptionML=[DAN=SEPA Tekst til partnertype;
                                                              ENU=SEPA Partner Type Text] }
    { 130 ;   ;Importing Code      ;Code10        ;CaptionML=[DAN=Indl‘ser kode;
                                                              ENU=Importing Code] }
    { 131 ;   ;Importing Date      ;Date          ;CaptionML=[DAN=Indl‘ser dato;
                                                              ENU=Importing Date] }
    { 132 ;   ;Importing Description;Text250      ;CaptionML=[DAN=Indl‘ser beskrivelse;
                                                              ENU=Importing Description] }
    { 133 ;   ;Costs Distribution  ;Text30        ;CaptionML=[DAN=Omkostningsfordeling;
                                                              ENU=Costs Distribution] }
    { 134 ;   ;Message Structure   ;Text30        ;CaptionML=[DAN=Meddelelsesstruktur;
                                                              ENU=Message Structure] }
    { 135 ;   ;Own Address Info.   ;Text30        ;CaptionML=[DAN=Oplysninger om egen adresse.;
                                                              ENU=Own Address Info.] }
    { 170 ;   ;Creditor No.        ;Code35        ;CaptionML=[DAN=Kreditornummer;
                                                              ENU=Creditor No.] }
    { 171 ;   ;Transit No.         ;Code35        ;CaptionML=[DAN=Transitnr.;
                                                              ENU=Transit No.] }
    { 173 ;   ;Applies-to Ext. Doc. No.;Code35    ;CaptionML=[DAN=Eksternt udlign.bilagsnr.;
                                                              ENU=Applies-to Ext. Doc. No.] }
    { 200 ;   ;Format Command      ;Code4         ;CaptionML=[DAN=Format‚r kommando;
                                                              ENU=Format Command] }
    { 201 ;   ;Format Remittance Info Type;Code1  ;CaptionML=[DAN=Format‚r type af indbetalingsoplysninger;
                                                              ENU=Format Remittance Info Type] }
    { 220 ;   ;Format Payment Type ;Code2         ;CaptionML=[DAN=Format‚r betalingstype;
                                                              ENU=Format Payment Type] }
    { 221 ;   ;Format Expense Code ;Code1         ;CaptionML=[DAN=Format‚r udgiftskode;
                                                              ENU=Format Expense Code] }
    { 222 ;   ;Format Text Code    ;Code3         ;CaptionML=[DAN=Format‚r tekstkode;
                                                              ENU=Format Text Code] }
    { 283 ;   ;Format Form Type    ;Code2         ;CaptionML=[DAN=Format‚r formulartype;
                                                              ENU=Format Form Type] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      TempPaymentExportRemittanceText@1001 : TEMPORARY Record 1229;
      PreserveNonLatinCharacters@1004 : Boolean;
      EmployeeMustHaveBankAccountNoErr@1000 : TextConst '@@@=Employee name;DAN=Du skal angive et bankkontonr. eller et IBAN for medarbejderen %1.;ENU=You must specify either Bank Account No. or IBAN for employee %1.';

    [External]
    PROCEDURE InitData@1(VAR GenJnlLine@1000 : Record 81);
    BEGIN
      RESET;
      CLEAR(TempPaymentExportRemittanceText);
      INIT;
      Amount := GenJnlLine.Amount;
      "Currency Code" := GenJnlLine."Currency Code";
    END;

    [External]
    PROCEDURE AddRemittanceText@3(NewText@1000 : Text[140]);
    BEGIN
      IF NewText = '' THEN
        EXIT;
      IF TempPaymentExportRemittanceText.FINDLAST THEN;
      TempPaymentExportRemittanceText."Pmt. Export Data Entry No." := "Entry No.";
      TempPaymentExportRemittanceText."Line No." += 1;
      IF PreserveNonLatinCharacters THEN
        TempPaymentExportRemittanceText.Text := NewText
      ELSE
        TempPaymentExportRemittanceText.Text := COPYSTR(ConvertToASCII(NewText),1,MAXSTRLEN(TempPaymentExportRemittanceText.Text));
      TempPaymentExportRemittanceText.INSERT;
    END;

    [External]
    PROCEDURE GetRemittanceTexts@5(VAR PaymentExportRemittanceText@1000 : Record 1229);
    BEGIN
      IF TempPaymentExportRemittanceText.FINDSET THEN
        REPEAT
          PaymentExportRemittanceText := TempPaymentExportRemittanceText;
          PaymentExportRemittanceText.INSERT;
        UNTIL TempPaymentExportRemittanceText.NEXT = 0;
    END;

    [External]
    PROCEDURE AddGenJnlLineErrorText@8(GenJnlLine@1001 : Record 81;NewText@1000 : Text);
    BEGIN
      GenJnlLine.InsertPaymentFileError(NewText);
    END;

    LOCAL PROCEDURE ConvertToASCII@9(Text@1000 : Text) : Text;
    VAR
      StringConversionManagement@1004 : Codeunit 47;
    BEGIN
      EXIT(StringConversionManagement.WindowsToASCII(Text));
    END;

    [External]
    PROCEDURE SetPreserveNonLatinCharacters@15(NewPreserveNonLatinCharacters@1000 : Boolean);
    BEGIN
      PreserveNonLatinCharacters := NewPreserveNonLatinCharacters;
    END;

    [External]
    PROCEDURE GetPreserveNonLatinCharacters@17() : Boolean;
    BEGIN
      EXIT(PreserveNonLatinCharacters);
    END;

    LOCAL PROCEDURE PaymentExportConvertToLatin@22();
    VAR
      RecRef@1001 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      ConvertFieldsToLatinCharacters(RecRef);
      RecRef.SETTABLE(Rec);
    END;

    [External]
    PROCEDURE CompanyInformationConvertToLatin@20(VAR CompanyInformation@1000 : Record 79);
    VAR
      RecRef@1001 : RecordRef;
    BEGIN
      RecRef.GETTABLE(CompanyInformation);
      ConvertFieldsToLatinCharacters(RecRef);
      RecRef.SETTABLE(CompanyInformation);
    END;

    LOCAL PROCEDURE ConvertFieldsToLatinCharacters@19(VAR RecRef@1001 : RecordRef);
    VAR
      Field@1000 : Record 2000000041;
      TypeHelper@1005 : Codeunit 10;
      StringConversionManagement@1004 : Codeunit 47;
      FieldRef@1002 : FieldRef;
    BEGIN
      PreserveNonLatinCharacters := FALSE;
      Field.SETRANGE(Class,Field.Class::Normal);
      Field.SETFILTER(Type,'%1|%2',Field.Type::Text,Field.Type::Code);
      IF TypeHelper.FindFields(RecRef.NUMBER,Field) THEN
        REPEAT
          FieldRef := RecRef.FIELD(Field."No.");
          FieldRef.VALUE := COPYSTR(StringConversionManagement.WindowsToASCII(FORMAT(FieldRef.VALUE)),1,FieldRef.LENGTH);
        UNTIL Field.NEXT = 0;
    END;

    [External]
    PROCEDURE SetCustomerAsRecipient@2(VAR Customer@1000 : Record 18;VAR CustomerBankAccount@1001 : Record 287);
    BEGIN
      "Recipient Name" := Customer.Name;
      "Recipient Address" := Customer.Address;
      "Recipient City" := COPYSTR(Customer.City,1,35);
      "Recipient County" := Customer.County;
      "Recipient Post Code" := Customer."Post Code";
      "Recipient Country/Region Code" := Customer."Country/Region Code";
      "Recipient Email Address" := Customer."E-Mail";
      "Recipient Bank Name" := CustomerBankAccount.Name;
      "Recipient Bank Address" := CustomerBankAccount.Address;
      "Recipient Bank City" := COPYSTR(CustomerBankAccount.City,1,35);
      "Recipient Bank County" := CustomerBankAccount.County;
      "Recipient Bank Post Code" := CustomerBankAccount."Post Code";
      "Recipient Bank Country/Region" := CustomerBankAccount."Country/Region Code";
      "Recipient Bank BIC" := CustomerBankAccount."SWIFT Code";
      "Recipient Bank Acc. No." := COPYSTR(CustomerBankAccount.GetBankAccountNo,1,MAXSTRLEN("Recipient Bank Acc. No."));
      "Recipient Bank Clearing Std." := CustomerBankAccount."Bank Clearing Standard";
      "Recipient Bank Clearing Code" := CustomerBankAccount."Bank Clearing Code";
    END;

    [External]
    PROCEDURE SetVendorAsRecipient@10(VAR Vendor@1000 : Record 23;VAR VendorBankAccount@1001 : Record 288);
    BEGIN
      "Recipient Name" := Vendor.Name;
      "Recipient Address" := Vendor.Address;
      "Recipient City" := COPYSTR(Vendor.City,1,35);
      "Recipient County" := Vendor.County;
      "Recipient Post Code" := Vendor."Post Code";
      "Recipient Country/Region Code" := Vendor."Country/Region Code";
      "Recipient Email Address" := Vendor."E-Mail";
      "Recipient Bank Name" := VendorBankAccount.Name;
      "Recipient Bank Address" := VendorBankAccount.Address;
      "Recipient Bank City" := COPYSTR(VendorBankAccount.City,1,35);
      "Recipient Bank County" := VendorBankAccount.County;
      "Recipient Bank Post Code" := VendorBankAccount."Post Code";
      "Recipient Bank Country/Region" := VendorBankAccount."Country/Region Code";
      "Recipient Bank BIC" := VendorBankAccount."SWIFT Code";
      "Recipient Bank Acc. No." := COPYSTR(VendorBankAccount.GetBankAccountNo,1,MAXSTRLEN("Recipient Bank Acc. No."));
      "Recipient Bank Clearing Std." := VendorBankAccount."Bank Clearing Standard";
      "Recipient Bank Clearing Code" := VendorBankAccount."Bank Clearing Code";
    END;

    [External]
    PROCEDURE SetEmployeeAsRecipient@12(VAR Employee@1000 : Record 5200);
    BEGIN
      "Recipient Name" := COPYSTR(Employee.FullName,1,MAXSTRLEN("Recipient Name"));
      "Recipient Address" := Employee.Address;
      "Recipient City" := COPYSTR(Employee.City,1,35);
      "Recipient County" := Employee.County;
      "Recipient Post Code" := Employee."Post Code";
      "Recipient Country/Region Code" := Employee."Country/Region Code";
      "Recipient Email Address" := Employee."E-Mail";
      IF Employee.GetBankAccountNo = '' THEN
        ERROR(EmployeeMustHaveBankAccountNoErr,Employee.FullName);
      "Recipient Bank Acc. No." := COPYSTR(Employee.GetBankAccountNo,1,MAXSTRLEN("Recipient Bank Acc. No."));
      "Recipient Bank BIC" := Employee."SWIFT Code";
    END;

    [External]
    PROCEDURE SetBankAsSenderBank@11(BankAccount@1000 : Record 270);
    BEGIN
      "Sender Bank Name - Data Conv." := BankAccount."Bank Name - Data Conversion";
      "Sender Bank Name" := BankAccount.Name;
      "Sender Bank Address" := BankAccount.Address;
      "Sender Bank City" := BankAccount.City;
      "Sender Bank County" := BankAccount.County;
      "Sender Bank Post Code" := BankAccount."Post Code";
      "Sender Bank Account Code" := BankAccount."No.";
      "Sender Bank Account No." := COPYSTR(BankAccount.GetBankAccountNo,1,MAXSTRLEN("Sender Bank Account No."));
      "Sender Bank BIC" := BankAccount."SWIFT Code";
      "Sender Bank Clearing Std." := BankAccount."Bank Clearing Standard";
      "Sender Bank Clearing Code" := BankAccount."Bank Clearing Code";
    END;

    [External]
    PROCEDURE SetCreditorIdentifier@6(BankAccount@1000 : Record 270);
    BEGIN
      BankAccount.TESTFIELD("Creditor No.");
      "Creditor No." := BankAccount."Creditor No.";
      "Transit No." := BankAccount."Transit No.";
    END;

    [External]
    PROCEDURE SetCreditTransferIDs@7(MessageID@1000 : Code[20]);
    BEGIN
      "Message ID" := MessageID;
      "Payment Information ID" := MessageID + '/' + FORMAT("Entry No.");
      "End-to-End ID" := "Payment Information ID";
    END;

    [External]
    PROCEDURE IsFieldBlank@4(FieldID@1003 : Integer) : Boolean;
    VAR
      RecRef@1005 : RecordRef;
      FieldRef@1002 : FieldRef;
      BlankValue@1000 : Text;
    BEGIN
      RecRef.GETTABLE(Rec);
      FieldRef := RecRef.FIELD(FieldID);
      CASE FORMAT(FieldRef.TYPE) OF
        'Text','Code','Date':
          BlankValue := '';
        'Decimal','Integer':
          BlankValue := '0';
      END;
      EXIT(FORMAT(FieldRef.VALUE) = BlankValue);
    END;

    BEGIN
    END.
  }
}

