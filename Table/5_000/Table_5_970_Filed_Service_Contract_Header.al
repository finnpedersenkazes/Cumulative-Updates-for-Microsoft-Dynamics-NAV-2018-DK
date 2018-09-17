OBJECT Table 5970 Filed Service Contract Header
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 5970=rimd,
                TableData 5971=rimd;
    OnDelete=BEGIN
               FiledContractLine.RESET;
               FiledContractLine.SETRANGE("Entry No.","Entry No.");
               FiledContractLine.DELETEALL;
             END;

    CaptionML=[DAN=Arkiveret servicekontrakthoved;
               ENU=Filed Service Contract Header];
    LookupPageID=Page6073;
    DrillDownPageID=Page6073;
  }
  FIELDS
  {
    { 1   ;   ;Contract No.        ;Code20        ;CaptionML=[DAN=Kontraktnr.;
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
    { 5   ;   ;Status              ;Option        ;CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=" ,Underskrevet,Annulleret";
                                                                    ENU=" ,Signed,Canceled"];
                                                   OptionString=[ ,Signed,Canceled];
                                                   Editable=Yes }
    { 6   ;   ;Change Status       ;Option        ;CaptionML=[DAN=Skift status;
                                                              ENU=Change Status];
                                                   OptionCaptionML=[DAN=èben,LÜst;
                                                                    ENU=Open,Locked];
                                                   OptionString=Open,Locked }
    { 7   ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.];
                                                   NotBlank=Yes }
    { 8   ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name];
                                                   Editable=No }
    { 9   ;   ;Address             ;Text50        ;CaptionML=[DAN=Adresse;
                                                              ENU=Address];
                                                   Editable=No }
    { 10  ;   ;Address 2           ;Text50        ;CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2];
                                                   Editable=No }
    { 11  ;   ;Post Code           ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code];
                                                   Editable=No }
    { 12  ;   ;City                ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City];
                                                   Editable=No }
    { 13  ;   ;Contact Name        ;Text50        ;CaptionML=[DAN=Kontaktnavn;
                                                              ENU=Contact Name] }
    { 14  ;   ;Your Reference      ;Text35        ;CaptionML=[DAN=Reference;
                                                              ENU=Your Reference] }
    { 15  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=Sëlgerkode;
                                                              ENU=Salesperson Code] }
    { 16  ;   ;Bill-to Customer No.;Code20        ;TableRelation=Customer;
                                                   CaptionML=[DAN=Faktureres til kundenr.;
                                                              ENU=Bill-to Customer No.] }
    { 17  ;   ;Bill-to Name        ;Text50        ;CaptionML=[DAN=Faktureringsnavn;
                                                              ENU=Bill-to Name];
                                                   Editable=No }
    { 18  ;   ;Bill-to Address     ;Text50        ;CaptionML=[DAN=Faktureringsadresse;
                                                              ENU=Bill-to Address];
                                                   Editable=No }
    { 19  ;   ;Bill-to Address 2   ;Text50        ;CaptionML=[DAN=Faktureringsadresse 2;
                                                              ENU=Bill-to Address 2];
                                                   Editable=No }
    { 20  ;   ;Bill-to Post Code   ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Faktureringspostnr.;
                                                              ENU=Bill-to Post Code];
                                                   Editable=No }
    { 21  ;   ;Bill-to City        ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Faktureringsby;
                                                              ENU=Bill-to City];
                                                   Editable=No }
    { 22  ;   ;Ship-to Code        ;Code10        ;TableRelation="Ship-to Address".Code WHERE (Customer No.=FIELD(Customer No.));
                                                   CaptionML=[DAN=Leveringsadressekode;
                                                              ENU=Ship-to Code] }
    { 23  ;   ;Ship-to Name        ;Text50        ;CaptionML=[DAN=Leveringsnavn;
                                                              ENU=Ship-to Name];
                                                   Editable=No }
    { 24  ;   ;Ship-to Address     ;Text50        ;CaptionML=[DAN=Leveringsadresse;
                                                              ENU=Ship-to Address];
                                                   Editable=No }
    { 25  ;   ;Ship-to Address 2   ;Text50        ;CaptionML=[DAN=Leveringsadresse 2;
                                                              ENU=Ship-to Address 2];
                                                   Editable=No }
    { 26  ;   ;Ship-to Post Code   ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Leveringspostnr.;
                                                              ENU=Ship-to Post Code];
                                                   Editable=No }
    { 27  ;   ;Ship-to City        ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Leveringsby;
                                                              ENU=Ship-to City];
                                                   Editable=No }
    { 28  ;   ;Serv. Contract Acc. Gr. Code;Code10;TableRelation="Service Contract Account Group".Code;
                                                   CaptionML=[DAN=Servicekontraktkto.grp.kode;
                                                              ENU=Serv. Contract Acc. Gr. Code] }
    { 32  ;   ;Invoice Period      ;Option        ;CaptionML=[DAN=Faktureringsperiode;
                                                              ENU=Invoice Period];
                                                   OptionCaptionML=[DAN=MÜned,To mÜneder,Kvartal,HalvÜr,èr,Ingen;
                                                                    ENU=Month,Two Months,Quarter,Half Year,Year,None];
                                                   OptionString=Month,Two Months,Quarter,Half Year,Year,None }
    { 33  ;   ;Last Invoice Date   ;Date          ;CaptionML=[DAN=Sidste faktureringsdato;
                                                              ENU=Last Invoice Date];
                                                   Editable=No }
    { 34  ;   ;Next Invoice Date   ;Date          ;CaptionML=[DAN=Nëste faktureringsdato;
                                                              ENU=Next Invoice Date] }
    { 35  ;   ;Starting Date       ;Date          ;CaptionML=[DAN=Startdato;
                                                              ENU=Starting Date] }
    { 36  ;   ;Expiration Date     ;Date          ;CaptionML=[DAN=Udlõbsdato;
                                                              ENU=Expiration Date] }
    { 38  ;   ;First Service Date  ;Date          ;CaptionML=[DAN=Fõrste servicedato;
                                                              ENU=First Service Date] }
    { 39  ;   ;Max. Labor Unit Price;Decimal      ;CaptionML=[DAN=Maks. arbejdsenhedspris;
                                                              ENU=Max. Labor Unit Price];
                                                   AutoFormatType=2;
                                                   AutoFormatExpr="Currency Code" }
    { 40  ;   ;Calcd. Annual Amount;Decimal       ;CaptionML=[DAN=Beregnet Ürligt belõb;
                                                              ENU=Calcd. Annual Amount] }
    { 42  ;   ;Annual Amount       ;Decimal       ;CaptionML=[DAN=èrligt belõb;
                                                              ENU=Annual Amount];
                                                   AutoFormatType=1 }
    { 43  ;   ;Amount per Period   ;Decimal       ;CaptionML=[DAN=Periodebelõb;
                                                              ENU=Amount per Period];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 44  ;   ;Combine Invoices    ;Boolean       ;CaptionML=[DAN=Kombiner fakturaer;
                                                              ENU=Combine Invoices] }
    { 45  ;   ;Prepaid             ;Boolean       ;CaptionML=[DAN=Forudbetalt;
                                                              ENU=Prepaid] }
    { 46  ;   ;Next Invoice Period ;Text30        ;CaptionML=[DAN=Nëste faktureringsperiode;
                                                              ENU=Next Invoice Period];
                                                   Editable=No }
    { 47  ;   ;Service Zone Code   ;Code10        ;TableRelation="Service Zone";
                                                   CaptionML=[DAN=Servicezonekode;
                                                              ENU=Service Zone Code] }
    { 48  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 50  ;   ;Cancel Reason Code  ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=AnnulleringsÜrsagskode;
                                                              ENU=Cancel Reason Code] }
    { 51  ;   ;Last Price Update Date;Date        ;CaptionML=[DAN=Dato for sidste prisregulering;
                                                              ENU=Last Price Update Date];
                                                   Editable=No }
    { 52  ;   ;Next Price Update Date;Date        ;CaptionML=[DAN=Dato for nëste prisregulering;
                                                              ENU=Next Price Update Date] }
    { 53  ;   ;Last Price Update % ;Decimal       ;CaptionML=[DAN=Nëste prisreguleringspct.;
                                                              ENU=Last Price Update %];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 55  ;   ;Response Time (Hours);Decimal      ;CaptionML=[DAN=Svartid (timer);
                                                              ENU=Response Time (Hours)];
                                                   DecimalPlaces=0:5 }
    { 56  ;   ;Contract Lines on Invoice;Boolean  ;CaptionML=[DAN=Kontraktlinjer pÜ faktura;
                                                              ENU=Contract Lines on Invoice] }
    { 59  ;   ;Service Period      ;DateFormula   ;CaptionML=[DAN=Serviceperiode;
                                                              ENU=Service Period] }
    { 60  ;   ;Payment Terms Code  ;Code10        ;TableRelation="Payment Terms";
                                                   CaptionML=[DAN=Betalingsbeting.kode;
                                                              ENU=Payment Terms Code] }
    { 62  ;   ;Invoice after Service;Boolean      ;CaptionML=[DAN=Faktura efter endt service;
                                                              ENU=Invoice after Service] }
    { 63  ;   ;Quote Type          ;Option        ;CaptionML=[DAN=Tilbudstype;
                                                              ENU=Quote Type];
                                                   OptionCaptionML=[DAN=Tilbud 1.,Tilbud 2.,Tilbud 3.,Tilbud 4.,Tilbud 5.,Tilbud 6.,Tilbud 7.,Tilbud 8.;
                                                                    ENU=Quote 1.,Quote 2.,Quote 3.,Quote 4.,Quote 5.,Quote 6.,Quote 7.,Quote 8.];
                                                   OptionString=Quote 1.,Quote 2.,Quote 3.,Quote 4.,Quote 5.,Quote 6.,Quote 7.,Quote 8. }
    { 64  ;   ;Allow Unbalanced Amounts;Boolean   ;CaptionML=[DAN=Tillad belõb, der ikke stemmer;
                                                              ENU=Allow Unbalanced Amounts] }
    { 65  ;   ;Contract Group Code ;Code10        ;TableRelation="Contract Group";
                                                   CaptionML=[DAN=Kontraktgruppekode;
                                                              ENU=Contract Group Code] }
    { 66  ;   ;Service Order Type  ;Code10        ;TableRelation="Service Order Type";
                                                   CaptionML=[DAN=Serviceordretype;
                                                              ENU=Service Order Type] }
    { 67  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 68  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 69  ;   ;Accept Before       ;Date          ;CaptionML=[DAN=Accept fõr;
                                                              ENU=Accept Before] }
    { 71  ;   ;Automatic Credit Memos;Boolean     ;CaptionML=[DAN=Kreditnotaer automatisk;
                                                              ENU=Automatic Credit Memos] }
    { 74  ;   ;Template No.        ;Code20        ;CaptionML=[DAN=Skabelonnr.;
                                                              ENU=Template No.] }
    { 75  ;   ;Price Update Period ;DateFormula   ;InitValue=1Y;
                                                   CaptionML=[DAN=Prisreguleringsperiode;
                                                              ENU=Price Update Period] }
    { 79  ;   ;Price Inv. Increase Code;Code20    ;TableRelation="Standard Text";
                                                   CaptionML=[DAN=Prisforhõjelseskode;
                                                              ENU=Price Inv. Increase Code] }
    { 80  ;   ;Print Increase Text ;Boolean       ;CaptionML=[DAN=Udskriv prisforhõjelsestekst;
                                                              ENU=Print Increase Text] }
    { 81  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 82  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 83  ;   ;Probability         ;Decimal       ;InitValue=100;
                                                   CaptionML=[DAN=Sandsynlighed;
                                                              ENU=Probability];
                                                   DecimalPlaces=0:5 }
    { 85  ;   ;Responsibility Center;Code10       ;TableRelation="Responsibility Center";
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
    { 89  ;   ;Bill-to County      ;Text30        ;CaptionML=[DAN=Faktureringsamt;
                                                              ENU=Bill-to County] }
    { 90  ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 91  ;   ;Ship-to County      ;Text30        ;CaptionML=[DAN=Leveringsamt;
                                                              ENU=Ship-to County] }
    { 92  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode;
                                                              ENU=Country/Region Code] }
    { 93  ;   ;Bill-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode til fakturering;
                                                              ENU=Bill-to Country/Region Code] }
    { 94  ;   ;Ship-to Country/Region Code;Code10 ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omrÜdekode for levering;
                                                              ENU=Ship-to Country/Region Code] }
    { 95  ;   ;Name 2              ;Text50        ;CaptionML=[DAN=Navn 2;
                                                              ENU=Name 2];
                                                   Editable=No }
    { 96  ;   ;Bill-to Name 2      ;Text50        ;CaptionML=[DAN=Faktureringsnavn 2;
                                                              ENU=Bill-to Name 2];
                                                   Editable=No }
    { 97  ;   ;Ship-to Name 2      ;Text50        ;CaptionML=[DAN=Leveringsnavn 2;
                                                              ENU=Ship-to Name 2];
                                                   Editable=No }
    { 98  ;   ;Next Invoice Period Start;Date     ;CaptionML=[DAN=Nëste fakturaperiodestart;
                                                              ENU=Next Invoice Period Start];
                                                   Editable=No }
    { 99  ;   ;Next Invoice Period End;Date       ;CaptionML=[DAN=Nëste fakt.periodeafslut.;
                                                              ENU=Next Invoice Period End];
                                                   Editable=No }
    { 100 ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenr.;
                                                              ENU=Entry No.] }
    { 101 ;   ;File Date           ;Date          ;CaptionML=[DAN=Arkiveret den;
                                                              ENU=File Date] }
    { 102 ;   ;File Time           ;Time          ;CaptionML=[DAN=Arkiveret kl.;
                                                              ENU=File Time] }
    { 103 ;   ;Filed By            ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("Filed By");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Arkiveret af;
                                                              ENU=Filed By] }
    { 104 ;   ;Reason for Filing   ;Option        ;CaptionML=[DAN=ArkiveringsÜrsag;
                                                              ENU=Reason for Filing];
                                                   OptionCaptionML=[DAN=" ,Kontrakt underskrevet,Kontrakt annulleret";
                                                                    ENU=" ,Contract Signed,Contract Canceled"];
                                                   OptionString=[ ,Contract Signed,Contract Canceled] }
    { 105 ;   ;Contract Type Relation;Option      ;CaptionML=[DAN=Kontrakttyperelation;
                                                              ENU=Contract Type Relation];
                                                   OptionCaptionML=[DAN=Tilbud,Kontrakt;
                                                                    ENU=Quote,Contract];
                                                   OptionString=Quote,Contract }
    { 106 ;   ;Contract No. Relation;Code20       ;TableRelation="Service Contract Header"."Contract No." WHERE (Contract Type=FIELD(Contract Type Relation));
                                                   CaptionML=[DAN=Kontraktnr.relation;
                                                              ENU=Contract No. Relation] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 5050;   ;Contact No.         ;Code20        ;CaptionML=[DAN=Kontaktnr.;
                                                              ENU=Contact No.] }
    { 5051;   ;Bill-to Contact No. ;Code20        ;AccessByPermission=TableData 5771=R;
                                                   CaptionML=[DAN=Faktureres attentionnr.;
                                                              ENU=Bill-to Contact No.] }
    { 5052;   ;Bill-to Contact     ;Text50        ;CaptionML=[DAN=Faktureres attention;
                                                              ENU=Bill-to Contact] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Contract Type Relation,Contract No. Relation,File Date,File Time }
    {    ;Contract Type,Contract No.               }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      FiledServContractHeader@1000 : Record 5970;
      FiledContractLine@1001 : Record 5971;
      DimMgt@1006 : Codeunit 408;
      SigningQuotation@1003 : Boolean;
      CancelContract@1004 : Boolean;
      Text027@1005 : TextConst 'DAN=%1 til %2;ENU=%1 to %2';

    [External]
    PROCEDURE FileContract@1(ServContractHeader@1000 : Record 5965);
    VAR
      ServContractLine@1002 : Record 5964;
      NextEntryNo@1001 : Integer;
    BEGIN
      WITH ServContractHeader DO BEGIN
        TESTFIELD("Contract No.");

        FiledContractLine.LOCKTABLE;
        FiledServContractHeader.LOCKTABLE;

        FiledServContractHeader.RESET;
        IF FiledServContractHeader.FINDLAST THEN
          NextEntryNo := FiledServContractHeader."Entry No." + 1
        ELSE
          NextEntryNo := 1;

        FiledServContractHeader.INIT;
        CALCFIELDS(
          Name,Address,"Address 2","Post Code",City,County,"Country/Region Code","Name 2",
          "Bill-to Name","Bill-to Address","Bill-to Address 2","Bill-to Post Code",
          "Bill-to City","Bill-to County","Bill-to Country/Region Code","Bill-to Name 2",
          "Calcd. Annual Amount");
        IF "Ship-to Code" = '' THEN BEGIN
          "Ship-to Name" := Name;
          "Ship-to Address" := Address;
          "Ship-to Address 2" := "Address 2";
          "Ship-to Post Code" := "Post Code";
          "Ship-to City" := City;
          "Ship-to County" := County;
          "Ship-to Country/Region Code" := "Country/Region Code";
          "Ship-to Name 2" := "Name 2";
        END ELSE
          CALCFIELDS(
            "Ship-to Name","Ship-to Address","Ship-to Address 2","Ship-to Post Code","Ship-to City",
            "Ship-to County","Ship-to Country/Region Code","Ship-to Name 2");

        FiledServContractHeader.TRANSFERFIELDS(ServContractHeader);

        IF SigningQuotation THEN
          FiledServContractHeader."Reason for Filing" :=
            FiledServContractHeader."Reason for Filing"::"Contract Signed";

        IF CancelContract THEN
          FiledServContractHeader."Reason for Filing" :=
            FiledServContractHeader."Reason for Filing"::"Contract Canceled";

        FiledServContractHeader."Contract Type Relation" := "Contract Type";
        FiledServContractHeader."Contract No. Relation" := "Contract No.";
        FiledServContractHeader."Entry No." := NextEntryNo;
        FiledServContractHeader."File Date" := TODAY;
        FiledServContractHeader."File Time" := TIME;
        FiledServContractHeader."Filed By" := USERID;
        FiledServContractHeader.Name := Name;
        FiledServContractHeader.Address := Address;
        FiledServContractHeader."Address 2" := "Address 2";
        FiledServContractHeader."Post Code" := "Post Code";
        FiledServContractHeader.City := City;
        FiledServContractHeader."Bill-to Name" := "Bill-to Name";
        FiledServContractHeader."Bill-to Address" := "Bill-to Address";
        FiledServContractHeader."Bill-to Address 2" := "Bill-to Address 2";
        FiledServContractHeader."Bill-to Post Code" := "Bill-to Post Code";
        FiledServContractHeader."Bill-to City" := "Bill-to City";
        FiledServContractHeader."Ship-to Name" := "Ship-to Name";
        FiledServContractHeader."Ship-to Address" := "Ship-to Address";
        FiledServContractHeader."Ship-to Address 2" := "Ship-to Address 2";
        FiledServContractHeader."Ship-to Post Code" := "Ship-to Post Code";
        FiledServContractHeader."Ship-to City" := "Ship-to City";
        FiledServContractHeader."Calcd. Annual Amount" := "Calcd. Annual Amount";
        FiledServContractHeader."Bill-to County" := "Bill-to County";
        FiledServContractHeader.County := County;
        FiledServContractHeader."Ship-to County" := "Ship-to County";
        FiledServContractHeader."Country/Region Code" := "Country/Region Code";
        FiledServContractHeader."Bill-to Country/Region Code" := "Bill-to Country/Region Code";
        FiledServContractHeader."Ship-to Country/Region Code" := "Ship-to Country/Region Code";
        FiledServContractHeader."Name 2" := "Name 2";
        FiledServContractHeader."Bill-to Name 2" := "Bill-to Name 2";
        FiledServContractHeader."Ship-to Name 2" := "Ship-to Name 2";
        FiledServContractHeader.INSERT;

        ServContractLine.RESET;
        ServContractLine.SETRANGE("Contract Type","Contract Type");
        ServContractLine.SETRANGE("Contract No.","Contract No.");
        IF ServContractLine.FIND('-') THEN
          REPEAT
            FiledContractLine.INIT;
            FiledContractLine."Entry No." := FiledServContractHeader."Entry No.";
            FiledContractLine.TRANSFERFIELDS(ServContractLine);
            FiledContractLine.INSERT;
          UNTIL ServContractLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE FileQuotationBeforeSigning@4(ServContract@1000 : Record 5965);
    BEGIN
      SigningQuotation := TRUE;
      FileContract(ServContract);
      SigningQuotation := FALSE;
    END;

    [External]
    PROCEDURE FileContractBeforeCancellation@7(ServContract@1000 : Record 5965);
    BEGIN
      CancelContract := TRUE;
      FileContract(ServContract);
      CancelContract := FALSE;
    END;

    [External]
    PROCEDURE NextInvoicePeriod@8() : Text[250];
    BEGIN
      IF ("Next Invoice Period Start" <> 0D) AND ("Next Invoice Period End" <> 0D) THEN
        EXIT(STRSUBSTNO(Text027,"Next Invoice Period Start","Next Invoice Period End"));
    END;

    LOCAL PROCEDURE ShowDimensions@2();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Contract No."));
    END;

    BEGIN
    END.
  }
}

