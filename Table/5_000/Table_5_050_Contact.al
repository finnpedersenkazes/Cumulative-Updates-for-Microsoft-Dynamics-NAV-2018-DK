OBJECT Table 5050 Contact
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    Permissions=TableData 36=rm,
                TableData 5051=rd,
                TableData 5052=rd,
                TableData 5054=rd,
                TableData 5056=rd,
                TableData 5058=rd,
                TableData 5060=rd,
                TableData 5061=rd,
                TableData 5065=rm,
                TableData 5067=rd,
                TableData 5080=rm,
                TableData 5089=rd,
                TableData 5092=rm,
                TableData 5093=rm;
    DataCaptionFields=No.,Name;
    OnInsert=BEGIN
               RMSetup.GET;

               IF "No." = '' THEN BEGIN
                 RMSetup.TESTFIELD("Contact Nos.");
                 NoSeriesMgt.InitSeries(RMSetup."Contact Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;

               IF NOT SkipDefaults THEN BEGIN
                 IF "Salesperson Code" = '' THEN BEGIN
                   "Salesperson Code" := RMSetup."Default Salesperson Code";
                   SetDefaultSalesperson;
                 END;
                 IF "Territory Code" = '' THEN
                   "Territory Code" := RMSetup."Default Territory Code";
                 IF "Country/Region Code" = '' THEN
                   "Country/Region Code" := RMSetup."Default Country/Region Code";
                 IF "Language Code" = '' THEN
                   "Language Code" := RMSetup."Default Language Code";
                 IF "Correspondence Type" = "Correspondence Type"::" " THEN
                   "Correspondence Type" := RMSetup."Default Correspondence Type";
                 IF "Salutation Code" = '' THEN
                   IF Type = Type::Company THEN
                     "Salutation Code" := RMSetup."Def. Company Salutation Code"
                   ELSE
                     "Salutation Code" := RMSetup."Default Person Salutation Code";
               END;

               TypeChange;
               SetLastDateTimeModified;
             END;

    OnModify=BEGIN
               // If the modify is called from code, Rec and xRec are the same,
               // so find the xRec
               IF FORMAT(xRec) = FORMAT(Rec) THEN
                 xRec.FIND;
               OnModify(xRec);
             END;

    OnDelete=VAR
               Task@1000 : Record 5080;
               SegLine@1001 : Record 5077;
               ContIndustGrp@1002 : Record 5058;
               ContactWebSource@1003 : Record 5060;
               ContJobResp@1004 : Record 5067;
               ContMailingGrp@1005 : Record 5056;
               ContProfileAnswer@1006 : Record 5089;
               RMCommentLine@1007 : Record 5061;
               ContAltAddr@1008 : Record 5051;
               ContAltAddrDateRange@1009 : Record 5052;
               InteractLogEntry@1010 : Record 5065;
               Opp@1011 : Record 5092;
               Cont@1015 : Record 5050;
               ContBusRel@1014 : Record 5054;
               IntrastatSetup@1013 : Record 247;
               CampaignTargetGrMgt@1016 : Codeunit 7030;
               VATRegistrationLogMgt@1012 : Codeunit 249;
             BEGIN
               Task.SETCURRENTKEY("Contact Company No.","Contact No.",Closed,Date);
               Task.SETRANGE("Contact Company No.","Company No.");
               Task.SETRANGE("Contact No.","No.");
               Task.SETRANGE(Closed,FALSE);
               IF Task.FIND('-') THEN
                 ERROR(CannotDeleteWithOpenTasksErr,"No.");

               SegLine.SETRANGE("Contact No.","No.");
               IF NOT SegLine.ISEMPTY THEN
                 ERROR(Text001,TABLECAPTION,"No.");

               Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
               Opp.SETRANGE("Contact Company No.","Company No.");
               Opp.SETRANGE("Contact No.","No.");
               Opp.SETRANGE(Status,Opp.Status::"Not Started",Opp.Status::"In Progress");
               IF Opp.FIND('-') THEN
                 ERROR(Text002,TABLECAPTION,"No.");

               ContBusRel.SETRANGE("Contact No.","No.");
               ContBusRel.DELETEALL;
               CASE Type OF
                 Type::Company:
                   BEGIN
                     ContIndustGrp.SETRANGE("Contact No.","No.");
                     ContIndustGrp.DELETEALL;
                     ContactWebSource.SETRANGE("Contact No.","No.");
                     ContactWebSource.DELETEALL;
                     DuplMgt.RemoveContIndex(Rec,FALSE);
                     InteractLogEntry.SETCURRENTKEY("Contact Company No.");
                     InteractLogEntry.SETRANGE("Contact Company No.","No.");
                     IF InteractLogEntry.FIND('-') THEN
                       REPEAT
                         CampaignTargetGrMgt.DeleteContfromTargetGr(InteractLogEntry);
                         CLEAR(InteractLogEntry."Contact Company No.");
                         CLEAR(InteractLogEntry."Contact No.");
                         InteractLogEntry.MODIFY;
                       UNTIL InteractLogEntry.NEXT = 0;

                     Cont.RESET;
                     Cont.SETCURRENTKEY("Company No.");
                     Cont.SETRANGE("Company No.","No.");
                     Cont.SETRANGE(Type,Type::Person);
                     IF Cont.FIND('-') THEN
                       REPEAT
                         Cont.DELETE(TRUE);
                       UNTIL Cont.NEXT = 0;

                     Opp.RESET;
                     Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
                     Opp.SETRANGE("Contact Company No.","Company No.");
                     Opp.SETRANGE("Contact No.","No.");
                     IF Opp.FIND('-') THEN
                       REPEAT
                         CLEAR(Opp."Contact No.");
                         CLEAR(Opp."Contact Company No.");
                         Opp.MODIFY;
                       UNTIL Opp.NEXT = 0;

                     Task.RESET;
                     Task.SETCURRENTKEY("Contact Company No.");
                     Task.SETRANGE("Contact Company No.","Company No.");
                     IF Task.FIND('-') THEN
                       REPEAT
                         CLEAR(Task."Contact No.");
                         CLEAR(Task."Contact Company No.");
                         Task.MODIFY;
                       UNTIL Task.NEXT = 0;
                   END;
                 Type::Person:
                   BEGIN
                     ContJobResp.SETRANGE("Contact No.","No.");
                     ContJobResp.DELETEALL;

                     InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                     InteractLogEntry.SETRANGE("Contact Company No.","Company No.");
                     InteractLogEntry.SETRANGE("Contact No.","No.");
                     InteractLogEntry.MODIFYALL("Contact No.","Company No.");

                     Opp.RESET;
                     Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
                     Opp.SETRANGE("Contact Company No.","Company No.");
                     Opp.SETRANGE("Contact No.","No.");
                     Opp.MODIFYALL("Contact No.","Company No.");

                     Task.RESET;
                     Task.SETCURRENTKEY("Contact Company No.","Contact No.");
                     Task.SETRANGE("Contact Company No.","Company No.");
                     Task.SETRANGE("Contact No.","No.");
                     Task.MODIFYALL("Contact No.","Company No.");
                   END;
               END;

               ContMailingGrp.SETRANGE("Contact No.","No.");
               ContMailingGrp.DELETEALL;

               ContProfileAnswer.SETRANGE("Contact No.","No.");
               ContProfileAnswer.DELETEALL;

               RMCommentLine.SETRANGE("Table Name",RMCommentLine."Table Name"::Contact);
               RMCommentLine.SETRANGE("No.","No.");
               RMCommentLine.SETRANGE("Sub No.",0);
               RMCommentLine.DELETEALL;

               ContAltAddr.SETRANGE("Contact No.","No.");
               ContAltAddr.DELETEALL;

               ContAltAddrDateRange.SETRANGE("Contact No.","No.");
               ContAltAddrDateRange.DELETEALL;

               VATRegistrationLogMgt.DeleteContactLog(Rec);

               IntrastatSetup.CheckDeleteIntrastatContact(IntrastatSetup."Intrastat Contact Type"::Contact,"No.");
             END;

    OnRename=BEGIN
               VALIDATE("Lookup Contact No.");
             END;

    CaptionML=[DAN=Kontakt;
               ENU=Contact];
    LookupPageID=Page5052;
    DrillDownPageID=Page5052;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  RMSetup.GET;
                                                                  NoSeriesMgt.TestManual(RMSetup."Contact Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   AltSearchField=Search Name;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Name                ;Text50        ;OnValidate=BEGIN
                                                                NameBreakdown;
                                                                ProcessNameChange;
                                                              END;

                                                   CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Search Name         ;Code50        ;CaptionML=[DAN=S�genavn;
                                                              ENU=Search Name] }
    { 4   ;   ;Name 2              ;Text50        ;CaptionML=[DAN=Navn 2;
                                                              ENU=Name 2] }
    { 5   ;   ;Address             ;Text50        ;CaptionML=[DAN=Adresse;
                                                              ENU=Address] }
    { 6   ;   ;Address 2           ;Text50        ;CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2] }
    { 7   ;   ;City                ;Text30        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=VAR
                                                                PostCode@1000 : Record 225;
                                                              BEGIN
                                                                PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City] }
    { 9   ;   ;Phone No.           ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.] }
    { 10  ;   ;Telex No.           ;Text20        ;CaptionML=[DAN=Telex;
                                                              ENU=Telex No.] }
    { 15  ;   ;Territory Code      ;Code10        ;TableRelation=Territory;
                                                   CaptionML=[DAN=Distriktskode;
                                                              ENU=Territory Code] }
    { 22  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 24  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 29  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   OnValidate=BEGIN
                                                                ValidateSalesPerson;
                                                              END;

                                                   CaptionML=[DAN=S�lgerkode;
                                                              ENU=Salesperson Code] }
    { 35  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   OnValidate=VAR
                                                                PostCode@1000 : Record 225;
                                                              BEGIN
                                                                PostCode.ValidateCountryCode(City,"Post Code",County,"Country/Region Code");
                                                                IF "Country/Region Code" <> xRec."Country/Region Code" THEN
                                                                  VATRegistrationValidation;
                                                              END;

                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code] }
    { 38  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Rlshp. Mgt. Comment Line" WHERE (Table Name=CONST(Contact),
                                                                                                       No.=FIELD(No.),
                                                                                                       Sub No.=CONST(0)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 54  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
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
    { 89  ;   ;Picture             ;BLOB          ;CaptionML=[DAN=Billede;
                                                              ENU=Picture];
                                                   SubType=Bitmap }
    { 91  ;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=VAR
                                                                PostCode@1000 : Record 225;
                                                              BEGIN
                                                                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 92  ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 102 ;   ;E-Mail              ;Text80        ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                IF ("Search E-Mail" = UPPERCASE(xRec."E-Mail")) OR ("Search E-Mail" = '') THEN
                                                                  "Search E-Mail" := "E-Mail";
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
                                                              ENU=No. Series] }
    { 140 ;   ;Image               ;Media         ;ExtendedDatatype=Person;
                                                   CaptionML=[DAN=Grafik;
                                                              ENU=Image] }
    { 150 ;   ;Privacy Blocked     ;Boolean       ;OnValidate=BEGIN
                                                                IF NOT "Privacy Blocked" THEN
                                                                  IF Minor THEN
                                                                    IF NOT "Parental Consent Received" THEN
                                                                      ERROR(ParentalConsentReceivedErr,"No.");
                                                              END;

                                                   CaptionML=[DAN=Beskyttelse af personlige oplysninger sp�rret;
                                                              ENU=Privacy Blocked] }
    { 151 ;   ;Minor               ;Boolean       ;OnValidate=BEGIN
                                                                IF Minor THEN
                                                                  VALIDATE("Privacy Blocked",TRUE);
                                                              END;

                                                   CaptionML=[DAN=Mindre�rig;
                                                              ENU=Minor] }
    { 152 ;   ;Parental Consent Received;Boolean  ;OnValidate=BEGIN
                                                                VALIDATE("Privacy Blocked",TRUE);
                                                              END;

                                                   CaptionML=[DAN=For�ldresamtykke modtaget;
                                                              ENU=Parental Consent Received] }
    { 5050;   ;Type                ;Option        ;OnValidate=BEGIN
                                                                IF (CurrFieldNo <> 0) AND ("No." <> '') THEN BEGIN
                                                                  TypeChange;
                                                                  MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Type;
                                                              ENU=Type];
                                                   OptionCaptionML=[DAN=Virksomhed,Person;
                                                                    ENU=Company,Person];
                                                   OptionString=Company,Person }
    { 5051;   ;Company No.         ;Code20        ;TableRelation=Contact WHERE (Type=CONST(Company));
                                                   OnValidate=VAR
                                                                Opp@1000 : Record 5092;
                                                                OppEntry@1001 : Record 5093;
                                                                Task@1002 : Record 5080;
                                                                InteractLogEntry@1003 : Record 5065;
                                                                SegLine@1005 : Record 5077;
                                                                SalesHeader@1004 : Record 36;
                                                                Cont@1008 : Record 5050;
                                                                ContBusRel@1007 : Record 5054;
                                                              BEGIN
                                                                IF Cont.GET("Company No.") THEN
                                                                  InheritCompanyToPersonData(Cont)
                                                                ELSE
                                                                  CLEAR("Company Name");

                                                                IF "Company No." = xRec."Company No." THEN
                                                                  EXIT;

                                                                TESTFIELD(Type,Type::Person);

                                                                SegLine.SETRANGE("Contact No.","No.");
                                                                IF NOT SegLine.ISEMPTY THEN
                                                                  ERROR(Text012,FIELDCAPTION("Company No."));

                                                                IF Cont.GET("No.") THEN BEGIN
                                                                  IF xRec."Company No." <> '' THEN BEGIN
                                                                    Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
                                                                    Opp.SETRANGE("Contact Company No.",xRec."Company No.");
                                                                    Opp.SETRANGE("Contact No.","No.");
                                                                    IF NOT Opp.ISEMPTY THEN
                                                                      Opp.MODIFYALL("Contact No.",xRec."Company No.");
                                                                    OppEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                                                                    OppEntry.SETRANGE("Contact Company No.",xRec."Company No.");
                                                                    OppEntry.SETRANGE("Contact No.","No.");
                                                                    IF NOT OppEntry.ISEMPTY THEN
                                                                      OppEntry.MODIFYALL("Contact No.",xRec."Company No.");
                                                                    Task.SETCURRENTKEY("Contact Company No.","Contact No.");
                                                                    Task.SETRANGE("Contact Company No.",xRec."Company No.");
                                                                    Task.SETRANGE("Contact No.","No.");
                                                                    IF NOT Task.ISEMPTY THEN
                                                                      Task.MODIFYALL("Contact No.",xRec."Company No.");
                                                                    InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                                                                    InteractLogEntry.SETRANGE("Contact Company No.",xRec."Company No.");
                                                                    InteractLogEntry.SETRANGE("Contact No.","No.");
                                                                    IF NOT InteractLogEntry.ISEMPTY THEN
                                                                      InteractLogEntry.MODIFYALL("Contact No.",xRec."Company No.");
                                                                    ContBusRel.RESET;
                                                                    ContBusRel.SETCURRENTKEY("Link to Table","No.");
                                                                    ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                                                                    ContBusRel.SETRANGE("Contact No.",xRec."Company No.");
                                                                    SalesHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
                                                                    SalesHeader.SETRANGE("Sell-to Contact No.","No.");
                                                                    IF ContBusRel.FINDFIRST THEN
                                                                      SalesHeader.SETRANGE("Sell-to Customer No.",ContBusRel."No.")
                                                                    ELSE
                                                                      SalesHeader.SETRANGE("Sell-to Customer No.",'');
                                                                    IF SalesHeader.FIND('-') THEN
                                                                      REPEAT
                                                                        SalesHeader."Sell-to Contact No." := xRec."Company No.";
                                                                        IF SalesHeader."Sell-to Contact No." = SalesHeader."Bill-to Contact No." THEN
                                                                          SalesHeader."Bill-to Contact No." := xRec."Company No.";
                                                                        SalesHeader.MODIFY;
                                                                      UNTIL SalesHeader.NEXT = 0;
                                                                    SalesHeader.RESET;
                                                                    SalesHeader.SETCURRENTKEY("Bill-to Contact No.");
                                                                    SalesHeader.SETRANGE("Bill-to Contact No.","No.");
                                                                    IF NOT SalesHeader.ISEMPTY THEN
                                                                      SalesHeader.MODIFYALL("Bill-to Contact No.",xRec."Company No.");
                                                                  END ELSE BEGIN
                                                                    Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
                                                                    Opp.SETRANGE("Contact Company No.",'');
                                                                    Opp.SETRANGE("Contact No.","No.");
                                                                    IF NOT Opp.ISEMPTY THEN
                                                                      Opp.MODIFYALL("Contact Company No.","Company No.");
                                                                    OppEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                                                                    OppEntry.SETRANGE("Contact Company No.",'');
                                                                    OppEntry.SETRANGE("Contact No.","No.");
                                                                    IF NOT OppEntry.ISEMPTY THEN
                                                                      OppEntry.MODIFYALL("Contact Company No.","Company No.");
                                                                    Task.SETCURRENTKEY("Contact Company No.","Contact No.");
                                                                    Task.SETRANGE("Contact Company No.",'');
                                                                    Task.SETRANGE("Contact No.","No.");
                                                                    IF NOT Task.ISEMPTY THEN
                                                                      Task.MODIFYALL("Contact Company No.","Company No.");
                                                                    InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                                                                    InteractLogEntry.SETRANGE("Contact Company No.",'');
                                                                    InteractLogEntry.SETRANGE("Contact No.","No.");
                                                                    IF NOT InteractLogEntry.ISEMPTY THEN
                                                                      InteractLogEntry.MODIFYALL("Contact Company No.","Company No.");
                                                                  END;

                                                                  IF CurrFieldNo <> 0 THEN
                                                                    MODIFY;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Virksomhedsnr.;
                                                              ENU=Company No.] }
    { 5052;   ;Company Name        ;Text50        ;TableRelation=Contact WHERE (Type=CONST(Company));
                                                   OnValidate=BEGIN
                                                                VALIDATE("Company No.",GetCompNo("Company Name"));
                                                              END;

                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Virksomhedsnavn;
                                                              ENU=Company Name] }
    { 5053;   ;Lookup Contact No.  ;Code20        ;TableRelation=Contact;
                                                   OnValidate=BEGIN
                                                                IF Type = Type::Company THEN
                                                                  "Lookup Contact No." := ''
                                                                ELSE
                                                                  "Lookup Contact No." := "No.";
                                                              END;

                                                   CaptionML=[DAN=Kontroller kontaktnr.;
                                                              ENU=Lookup Contact No.];
                                                   Editable=No }
    { 5054;   ;First Name          ;Text30        ;OnValidate=BEGIN
                                                                Name := CalculatedName;
                                                                ProcessNameChange;
                                                              END;

                                                   CaptionML=[DAN=Fornavn;
                                                              ENU=First Name] }
    { 5055;   ;Middle Name         ;Text30        ;OnValidate=BEGIN
                                                                Name := CalculatedName;
                                                                ProcessNameChange;
                                                              END;

                                                   CaptionML=[DAN=Mellemnavn;
                                                              ENU=Middle Name] }
    { 5056;   ;Surname             ;Text30        ;OnValidate=BEGIN
                                                                Name := CalculatedName;
                                                                ProcessNameChange;
                                                              END;

                                                   CaptionML=[DAN=Efternavn;
                                                              ENU=Surname] }
    { 5058;   ;Job Title           ;Text30        ;CaptionML=[DAN=Stilling;
                                                              ENU=Job Title] }
    { 5059;   ;Initials            ;Text30        ;CaptionML=[DAN=Initialer;
                                                              ENU=Initials] }
    { 5060;   ;Extension No.       ;Text30        ;CaptionML=[DAN=Lokalnr.;
                                                              ENU=Extension No.] }
    { 5061;   ;Mobile Phone No.    ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Mobiltelefon;
                                                              ENU=Mobile Phone No.] }
    { 5062;   ;Pager               ;Text30        ;CaptionML=[DAN=Persons�ger;
                                                              ENU=Pager] }
    { 5063;   ;Organizational Level Code;Code10   ;TableRelation="Organizational Level";
                                                   CaptionML=[DAN=Kompetanceniveau;
                                                              ENU=Organizational Level Code] }
    { 5064;   ;Exclude from Segment;Boolean       ;CaptionML=[DAN=Udeluk fra m�lgruppe;
                                                              ENU=Exclude from Segment] }
    { 5065;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 5066;   ;Next Task Date      ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Min(To-do.Date WHERE (Contact Company No.=FIELD(Company No.),
                                                                                     Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                                                                     Closed=CONST(No),
                                                                                     System To-do Type=CONST(Contact Attendee)));
                                                   CaptionML=[DAN=N�ste opgavedato;
                                                              ENU=Next Task Date];
                                                   Editable=No }
    { 5067;   ;Last Date Attempted ;Date          ;FieldClass=FlowField;
                                                   CalcFormula=Max("Interaction Log Entry".Date WHERE (Contact Company No.=FIELD(Company No.),
                                                                                                       Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                                                                                       Initiated By=CONST(Us),
                                                                                                       Postponed=CONST(No)));
                                                   CaptionML=[DAN=Sidst fors�gt den;
                                                              ENU=Last Date Attempted];
                                                   Editable=No }
    { 5068;   ;Date of Last Interaction;Date      ;FieldClass=FlowField;
                                                   CalcFormula=Max("Interaction Log Entry".Date WHERE (Contact Company No.=FIELD(Company No.),
                                                                                                       Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                                                                                       Attempt Failed=CONST(No),
                                                                                                       Postponed=CONST(No)));
                                                   CaptionML=[DAN=Dato for seneste interaktion;
                                                              ENU=Date of Last Interaction];
                                                   Editable=No }
    { 5069;   ;No. of Job Responsibilities;Integer;FieldClass=FlowField;
                                                   CalcFormula=Count("Contact Job Responsibility" WHERE (Contact No.=FIELD(No.)));
                                                   CaptionML=[DAN=Ansvarsomr�der;
                                                              ENU=No. of Job Responsibilities];
                                                   Editable=No }
    { 5070;   ;No. of Industry Groups;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("Contact Industry Group" WHERE (Contact No.=FIELD(Company No.)));
                                                   CaptionML=[DAN=Antal brancher;
                                                              ENU=No. of Industry Groups];
                                                   Editable=No }
    { 5071;   ;No. of Business Relations;Integer  ;FieldClass=FlowField;
                                                   CalcFormula=Count("Contact Business Relation" WHERE (Contact No.=FIELD(Company No.)));
                                                   CaptionML=[DAN=Antal forretningsrelationer;
                                                              ENU=No. of Business Relations];
                                                   Editable=No }
    { 5072;   ;No. of Mailing Groups;Integer      ;FieldClass=FlowField;
                                                   CalcFormula=Count("Contact Mailing Group" WHERE (Contact No.=FIELD(No.)));
                                                   CaptionML=[DAN=Antal mailgrupper;
                                                              ENU=No. of Mailing Groups];
                                                   Editable=No }
    { 5073;   ;External ID         ;Code20        ;CaptionML=[DAN=Eksternt id;
                                                              ENU=External ID] }
    { 5074;   ;No. of Interactions ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Interaction Log Entry" WHERE (Contact Company No.=FIELD(FILTER(Company No.)),
                                                                                                    Canceled=CONST(No),
                                                                                                    Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                                                                                    Date=FIELD(Date Filter),
                                                                                                    Postponed=CONST(No)));
                                                   CaptionML=[DAN=Antal interaktioner;
                                                              ENU=No. of Interactions];
                                                   Editable=No }
    { 5076;   ;Cost (LCY)          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Interaction Log Entry"."Cost (LCY)" WHERE (Contact Company No.=FIELD(Company No.),
                                                                                                               Canceled=CONST(No),
                                                                                                               Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                                                                                               Date=FIELD(Date Filter),
                                                                                                               Postponed=CONST(No)));
                                                   CaptionML=[DAN=Kostbel�b (RV);
                                                              ENU=Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5077;   ;Duration (Min.)     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Interaction Log Entry"."Duration (Min.)" WHERE (Contact Company No.=FIELD(Company No.),
                                                                                                                    Canceled=CONST(No),
                                                                                                                    Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                                                                                                    Date=FIELD(Date Filter),
                                                                                                                    Postponed=CONST(No)));
                                                   CaptionML=[DAN=Varighed (min.);
                                                              ENU=Duration (Min.)];
                                                   DecimalPlaces=0:0;
                                                   Editable=No }
    { 5078;   ;No. of Opportunities;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Opportunity Entry" WHERE (Active=CONST(Yes),
                                                                                                Contact Company No.=FIELD(Company No.),
                                                                                                Estimated Close Date=FIELD(Date Filter),
                                                                                                Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                                                                                Action Taken=FIELD(Action Taken Filter)));
                                                   CaptionML=[DAN=Antal salgsmuligheder;
                                                              ENU=No. of Opportunities];
                                                   Editable=No }
    { 5079;   ;Estimated Value (LCY);Decimal      ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Opportunity Entry"."Estimated Value (LCY)" WHERE (Active=CONST(Yes),
                                                                                                                      Contact Company No.=FIELD(Company No.),
                                                                                                                      Estimated Close Date=FIELD(Date Filter),
                                                                                                                      Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                                                                                                      Action Taken=FIELD(Action Taken Filter)));
                                                   CaptionML=[DAN=Ansl�et v�rdi (RV);
                                                              ENU=Estimated Value (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5080;   ;Calcd. Current Value (LCY);Decimal ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Opportunity Entry"."Calcd. Current Value (LCY)" WHERE (Active=CONST(Yes),
                                                                                                                           Contact Company No.=FIELD(Company No.),
                                                                                                                           Estimated Close Date=FIELD(Date Filter),
                                                                                                                           Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                                                                                                           Action Taken=FIELD(Action Taken Filter)));
                                                   CaptionML=[DAN=Beregnet aktuel v�rdi (RV);
                                                              ENU=Calcd. Current Value (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 5082;   ;Opportunity Entry Exists;Boolean   ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Opportunity Entry" WHERE (Active=CONST(Yes),
                                                                                                Contact Company No.=FIELD(Company No.),
                                                                                                Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                                                                                Sales Cycle Code=FIELD(Sales Cycle Filter),
                                                                                                Sales Cycle Stage=FIELD(Sales Cycle Stage Filter),
                                                                                                Salesperson Code=FIELD(Salesperson Filter),
                                                                                                Campaign No.=FIELD(Campaign Filter),
                                                                                                Action Taken=FIELD(Action Taken Filter),
                                                                                                Estimated Value (LCY)=FIELD(Estimated Value Filter),
                                                                                                Calcd. Current Value (LCY)=FIELD(Calcd. Current Value Filter),
                                                                                                Completed %=FIELD(Completed % Filter),
                                                                                                Chances of Success %=FIELD(Chances of Success % Filter),
                                                                                                Probability %=FIELD(Probability % Filter),
                                                                                                Estimated Close Date=FIELD(Date Filter),
                                                                                                Close Opportunity Code=FIELD(Close Opportunity Filter)));
                                                   CaptionML=[DAN=Salgsmulighedpost findes;
                                                              ENU=Opportunity Entry Exists];
                                                   Editable=No }
    { 5083;   ;Task Entry Exists   ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist(To-do WHERE (Contact Company No.=FIELD(Company No.),
                                                                                  Contact No.=FIELD(FILTER(Lookup Contact No.)),
                                                                                  Team Code=FIELD(Team Filter),
                                                                                  Salesperson Code=FIELD(Salesperson Filter),
                                                                                  Campaign No.=FIELD(Campaign Filter),
                                                                                  Date=FIELD(Date Filter),
                                                                                  Status=FIELD(Task Status Filter),
                                                                                  Priority=FIELD(Priority Filter),
                                                                                  Closed=FIELD(Task Closed Filter)));
                                                   CaptionML=[DAN=Opgavepost findes;
                                                              ENU=Task Entry Exists];
                                                   Editable=No }
    { 5084;   ;Salesperson Filter  ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=S�lgerfilter;
                                                              ENU=Salesperson Filter] }
    { 5085;   ;Campaign Filter     ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Campaign;
                                                   CaptionML=[DAN=Kampagnefilter;
                                                              ENU=Campaign Filter] }
    { 5087;   ;Action Taken Filter ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Handling foretaget-filter;
                                                              ENU=Action Taken Filter];
                                                   OptionCaptionML=[DAN=" ,N�ste,Forrige,Opdateret,Sprunget fra,Vundet,Tabt";
                                                                    ENU=" ,Next,Previous,Updated,Jumped,Won,Lost"];
                                                   OptionString=[ ,Next,Previous,Updated,Jumped,Won,Lost] }
    { 5088;   ;Sales Cycle Filter  ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation="Sales Cycle";
                                                   CaptionML=[DAN=Salgsprocesfilter;
                                                              ENU=Sales Cycle Filter] }
    { 5089;   ;Sales Cycle Stage Filter;Integer   ;FieldClass=FlowFilter;
                                                   TableRelation="Sales Cycle Stage".Stage WHERE (Sales Cycle Code=FIELD(Sales Cycle Filter));
                                                   CaptionML=[DAN=Salgsprocesfasefilter;
                                                              ENU=Sales Cycle Stage Filter] }
    { 5090;   ;Probability % Filter;Decimal       ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Sandsynlighed %-filter;
                                                              ENU=Probability % Filter];
                                                   DecimalPlaces=1:1;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 5091;   ;Completed % Filter  ;Decimal       ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Afsluttet %-filter;
                                                              ENU=Completed % Filter];
                                                   DecimalPlaces=1:1;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 5092;   ;Estimated Value Filter;Decimal     ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Filter for ansl�et v�rdi;
                                                              ENU=Estimated Value Filter];
                                                   AutoFormatType=1 }
    { 5093;   ;Calcd. Current Value Filter;Decimal;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Filter for bergn. aktuel v�rdi;
                                                              ENU=Calcd. Current Value Filter];
                                                   AutoFormatType=1 }
    { 5094;   ;Chances of Success % Filter;Decimal;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Succespotentiale %-filter;
                                                              ENU=Chances of Success % Filter];
                                                   DecimalPlaces=0:0;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 5095;   ;Task Status Filter  ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Filter for opgavestatus;
                                                              ENU=Task Status Filter];
                                                   OptionCaptionML=[DAN=Ikke startet,Igangsat,Afsluttet,Venter,Udsat;
                                                                    ENU=Not Started,In Progress,Completed,Waiting,Postponed];
                                                   OptionString=Not Started,In Progress,Completed,Waiting,Postponed }
    { 5096;   ;Task Closed Filter  ;Boolean       ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Filter for lukket opgave;
                                                              ENU=Task Closed Filter] }
    { 5097;   ;Priority Filter     ;Option        ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Prioritetsfilter;
                                                              ENU=Priority Filter];
                                                   OptionCaptionML=[DAN=Lav,Normal,H�j;
                                                                    ENU=Low,Normal,High];
                                                   OptionString=Low,Normal,High }
    { 5098;   ;Team Filter         ;Code10        ;FieldClass=FlowFilter;
                                                   TableRelation=Team;
                                                   CaptionML=[DAN=Teamfilter;
                                                              ENU=Team Filter] }
    { 5099;   ;Close Opportunity Filter;Code10    ;FieldClass=FlowFilter;
                                                   TableRelation="Close Opportunity Code";
                                                   CaptionML=[DAN=Luk salgsmulighedfilter;
                                                              ENU=Close Opportunity Filter] }
    { 5100;   ;Correspondence Type ;Option        ;CaptionML=[DAN=Korrespondancetype;
                                                              ENU=Correspondence Type];
                                                   OptionCaptionML=[DAN=" ,Papirformat,Mail,Telefax";
                                                                    ENU=" ,Hard Copy,Email,Fax"];
                                                   OptionString=[ ,Hard Copy,Email,Fax] }
    { 5101;   ;Salutation Code     ;Code10        ;TableRelation=Salutation;
                                                   CaptionML=[DAN=Starthilsenkode;
                                                              ENU=Salutation Code] }
    { 5102;   ;Search E-Mail       ;Code80        ;CaptionML=[DAN=S�g efter mail;
                                                              ENU=Search Email] }
    { 5104;   ;Last Time Modified  ;Time          ;CaptionML=[DAN=Rettet kl.;
                                                              ENU=Last Time Modified] }
    { 5105;   ;E-Mail 2            ;Text80        ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                MailManagement.ValidateEmailAddressField("E-Mail 2");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Mail 2;
                                                              ENU=Email 2] }
    { 8050;   ;Xrm Id              ;GUID          ;CaptionML=[DAN=Xrm-id;
                                                              ENU=Xrm Id];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Name                              }
    {    ;Company Name,Company No.,Type,Name       }
    {    ;Company No.                              }
    {    ;Territory Code                           }
    {    ;Salesperson Code                         }
    {    ;VAT Registration No.                     }
    {    ;Search E-Mail                            }
    {    ;Name                                     }
    {    ;City                                     }
    {    ;Post Code                                }
    {    ;Phone No.                                }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Name,Type,City,Post Code,Phone No.   }
    { 2   ;Brick               ;No.,Name,Type,City,Phone No.,Image       }
  }
  CODE
  {
    VAR
      CannotDeleteWithOpenTasksErr@1000 : TextConst '@@@="%1 = Contact No.";DAN=Du kan ikke slette kontakten %1, fordi der er en eller flere �bne opgaver.;ENU=You cannot delete contact %1 because there are one or more tasks open.';
      Text001@1001 : TextConst 'DAN=Du kan ikke slette recorden %2 i %1, fordi der er tildelt en eller flere ikke-registrerede m�lgrupper til kontakten.;ENU=You cannot delete the %2 record of the %1 because the contact is assigned one or more unlogged segments.';
      Text002@1002 : TextConst 'DAN=Du kan ikke slette recorden %2 i %1, fordi et eller flere salgsmuligheder ikke er p�begyndt eller er i gang.;ENU=You cannot delete the %2 record of the %1 because one or more opportunities are in not started or progress.';
      Text003@1003 : TextConst 'DAN=%1 kan ikke �ndres, fordi der er knyttet �n eller flere interaktionslogposter til kontakten.;ENU=%1 cannot be changed because one or more interaction log entries are linked to the contact.';
      CannotChangeWithOpenTasksErr@1005 : TextConst '@@@="%1 = Contact No.";DAN=%1 kan ikke �ndres, fordi der er knyttet �n eller flere opgaver til kontakten.;ENU=%1 cannot be changed because one or more tasks are linked to the contact.';
      Text006@1006 : TextConst 'DAN=%1 kan ikke �ndres, fordi der er knyttet �t eller flere salgsmuligheder til kontakten.;ENU=%1 cannot be changed because one or more opportunities are linked to the contact.';
      Text007@1007 : TextConst 'DAN=%1 kan ikke �ndres, fordi �n eller flere personer er knyttet til kontakten.;ENU=%1 cannot be changed because there are one or more related people linked to the contact.';
      RelatedRecordIsCreatedMsg@1009 : TextConst '@@@=The Customer record has been created.;DAN=Recorden %1 er blevet oprettet.;ENU=The %1 record has been created.';
      Text010@1010 : TextConst 'DAN=Recorden %2 i %1 er ikke knyttet til andre tabeller.;ENU=The %2 record of the %1 is not linked with any other table.';
      RMSetup@1012 : Record 5079;
      Salesperson@1927 : Record 13;
      DuplMgt@1015 : Codeunit 5060;
      NoSeriesMgt@1016 : Codeunit 396;
      UpdateCustVendBank@1017 : Codeunit 5055;
      CampaignMgt@1050 : Codeunit 7030;
      ContChanged@1018 : Boolean;
      SkipDefaults@1019 : Boolean;
      Text012@1020 : TextConst 'DAN=%1 kan ikke �ndres, fordi der er tildelt �n eller flere ikke-registrerede m�lgrupper til kontakten.;ENU=You cannot change %1 because one or more unlogged segments are assigned to the contact.';
      Text019@1022 : TextConst 'DAN=Recorden %2 i %1 har allerede %3 til %4 %5.;ENU=The %2 record of the %1 already has the %3 with %4 %5.';
      CreateCustomerFromContactQst@1021 : TextConst 'DAN=Vil du oprette kontakten som debitor ved hj�lp af en debitorskabelon?;ENU=Do you want to create a contact as a customer using a customer template?';
      Text021@1023 : TextConst 'DAN=Du skal oprette formelle og uformelle starthilsenformularer p� sproget %1 for kontakten %2.;ENU=You have to set up formal and informal salutation formulas in %1  language for the %2 contact.';
      Text022@1034 : TextConst 'DAN=Oprettelsen af debitoren blev afbrudt.;ENU=The creation of the customer has been aborted.';
      Text033@1008 : TextConst 'DAN=Vinduet Ops�tning af Online Map skal udfyldes, f�r du kan bruge Online Map.\Se Ops�tning af Online Map i Hj�lp.;ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
      SelectContactErr@1004 : TextConst 'DAN=Du skal v�lge en eksisterende kontakt.;ENU=You must select an existing contact.';
      AlreadyExistErr@1024 : TextConst '@@@="%1=Contact table caption;%2=Contact number;%3=Contact Business Relation table caption;%4=Contact Business Relation Link to Table value;%5=Contact Business Relation number";DAN=%1 %2 har allerede en %3 til %4 %5.;ENU=%1 %2 already has a %3 with %4 %5.';
      HideValidationDialog@1025 : Boolean;
      PrivacyBlockedPostErr@1013 : TextConst '@@@="%1=contact no.";DAN=Du kan ikke bogf�re denne bilagstype, fordi kontakten %1 er blokeret p� grund af beskyttelse af personlige oplysninger.;ENU=You cannot post this type of document because contact %1 is blocked due to privacy.';
      PrivacyBlockedCreateErr@1011 : TextConst '@@@="%1=contact no.";DAN=Du kan ikke oprette denne bilagstype, fordi kontakten %1 er blokeret p� grund af beskyttelse af personlige oplysninger.;ENU=You cannot create this type of document because contact %1 is blocked due to privacy.';
      PrivacyBlockedGenericErr@1014 : TextConst '@@@="%1=contact no.";DAN=Du kan ikke anvende kontakten %1, fordi de er markeret som blokeret pga. beskyttelse af personlige oplysninger.;ENU=You cannot use contact %1 because they are marked as blocked due to privacy.';
      ParentalConsentReceivedErr@1026 : TextConst '@@@="%1=contact no.";DAN=Beskyttelse af personlige oplysninger sp�rret kan ikke slettes, f�r For�ldresamtykke modtaget indstilles til Sand for mindre�rig kontakt %1.;ENU=Privacy Blocked cannot be cleared until Parental Consent Received is set to true for minor contact %1.';
      ProfileForMinorErr@1027 : TextConst 'DAN=Du kan ikke bruge profiler for kontakter, der er markeret som Mindre�rig.;ENU=You cannot use profiles for contacts marked as Minor.';

    [External]
    PROCEDURE OnModify@4(xRec@1005 : Record 5050);
    VAR
      OldCont@1001 : Record 5050;
      Cont@1003 : Record 5050;
    BEGIN
      SetLastDateTimeModified;

      IF "No." <> '' THEN
        IF IsUpdateNeeded THEN
          UpdateCustVendBank.RUN(Rec);

      IF Type = Type::Company THEN BEGIN
        RMSetup.GET;
        Cont.RESET;
        Cont.SETCURRENTKEY("Company No.");
        Cont.SETRANGE("Company No.","No.");
        Cont.SETRANGE(Type,Type::Person);
        Cont.SETFILTER("No.",'<>%1',"No.");
        IF Cont.FIND('-') THEN
          REPEAT
            ContChanged := FALSE;
            OldCont := Cont;
            IF Name <> xRec.Name THEN BEGIN
              Cont."Company Name" := Name;
              ContChanged := TRUE;
            END;
            IF RMSetup."Inherit Salesperson Code" AND
               (xRec."Salesperson Code" <> "Salesperson Code") AND
               (xRec."Salesperson Code" = Cont."Salesperson Code")
            THEN BEGIN
              Cont."Salesperson Code" := "Salesperson Code";
              ContChanged := TRUE;
            END;
            IF RMSetup."Inherit Territory Code" AND
               (xRec."Territory Code" <> "Territory Code") AND
               (xRec."Territory Code" = Cont."Territory Code")
            THEN BEGIN
              Cont."Territory Code" := "Territory Code";
              ContChanged := TRUE;
            END;
            IF RMSetup."Inherit Country/Region Code" AND
               (xRec."Country/Region Code" <> "Country/Region Code") AND
               (xRec."Country/Region Code" = Cont."Country/Region Code")
            THEN BEGIN
              Cont."Country/Region Code" := "Country/Region Code";
              ContChanged := TRUE;
            END;
            IF RMSetup."Inherit Language Code" AND
               (xRec."Language Code" <> "Language Code") AND
               (xRec."Language Code" = Cont."Language Code")
            THEN BEGIN
              Cont."Language Code" := "Language Code";
              ContChanged := TRUE;
            END;
            IF RMSetup."Inherit Address Details" THEN
              IF xRec.IdenticalAddress(Cont) THEN BEGIN
                IF xRec.Address <> Address THEN BEGIN
                  Cont.Address := Address;
                  ContChanged := TRUE;
                END;
                IF xRec."Address 2" <> "Address 2" THEN BEGIN
                  Cont."Address 2" := "Address 2";
                  ContChanged := TRUE;
                END;
                IF xRec."Post Code" <> "Post Code" THEN BEGIN
                  Cont."Post Code" := "Post Code";
                  ContChanged := TRUE;
                END;
                IF xRec.City <> City THEN BEGIN
                  Cont.City := City;
                  ContChanged := TRUE;
                END;
                IF xRec.County <> County THEN BEGIN
                  Cont.County := County;
                  ContChanged := TRUE;
                END;
              END;
            IF RMSetup."Inherit Communication Details" THEN BEGIN
              IF (xRec."Phone No." <> "Phone No.") AND (xRec."Phone No." = Cont."Phone No.") THEN BEGIN
                Cont."Phone No." := "Phone No.";
                ContChanged := TRUE;
              END;
              IF (xRec."Telex No." <> "Telex No.") AND (xRec."Telex No." = Cont."Telex No.") THEN BEGIN
                Cont."Telex No." := "Telex No.";
                ContChanged := TRUE;
              END;
              IF (xRec."Fax No." <> "Fax No.") AND (xRec."Fax No." = Cont."Fax No.") THEN BEGIN
                Cont."Fax No." := "Fax No.";
                ContChanged := TRUE;
              END;
              IF (xRec."Telex Answer Back" <> "Telex Answer Back") AND (xRec."Telex Answer Back" = Cont."Telex Answer Back") THEN BEGIN
                Cont."Telex Answer Back" := "Telex Answer Back";
                ContChanged := TRUE;
              END;
              IF (xRec."E-Mail" <> "E-Mail") AND (xRec."E-Mail" = Cont."E-Mail") THEN BEGIN
                Cont.VALIDATE("E-Mail","E-Mail");
                ContChanged := TRUE;
              END;
              IF (xRec."Home Page" <> "Home Page") AND (xRec."Home Page" = Cont."Home Page") THEN BEGIN
                Cont."Home Page" := "Home Page";
                ContChanged := TRUE;
              END;
              IF (xRec."Extension No." <> "Extension No.") AND (xRec."Extension No." = Cont."Extension No.") THEN BEGIN
                Cont."Extension No." := "Extension No.";
                ContChanged := TRUE;
              END;
              IF (xRec."Mobile Phone No." <> "Mobile Phone No.") AND (xRec."Mobile Phone No." = Cont."Mobile Phone No.") THEN BEGIN
                Cont."Mobile Phone No." := "Mobile Phone No.";
                ContChanged := TRUE;
              END;
              IF (xRec.Pager <> Pager) AND (xRec.Pager = Cont.Pager) THEN BEGIN
                Cont.Pager := Pager;
                ContChanged := TRUE;
              END;
            END;
            IF ContChanged THEN BEGIN
              Cont.OnModify(OldCont);
              Cont.MODIFY;
            END;
          UNTIL Cont.NEXT = 0;

        IF (Name <> xRec.Name) OR
           ("Name 2" <> xRec."Name 2") OR
           (Address <> xRec.Address) OR
           ("Address 2" <> xRec."Address 2") OR
           (City <> xRec.City) OR
           ("Post Code" <> xRec."Post Code") OR
           ("VAT Registration No." <> xRec."VAT Registration No.") OR
           ("Phone No." <> xRec."Phone No.")
        THEN
          CheckDupl;
      END;
    END;

    [External]
    PROCEDURE TypeChange@1();
    VAR
      InteractLogEntry@1000 : Record 5065;
      Opp@1001 : Record 5092;
      Task@1002 : Record 5080;
      Cont@1006 : Record 5050;
      CampaignTargetGrMgt@1003 : Codeunit 7030;
    BEGIN
      RMSetup.GET;

      IF Type <> xRec.Type THEN BEGIN
        InteractLogEntry.LOCKTABLE;
        Cont.LOCKTABLE;
        InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
        InteractLogEntry.SETRANGE("Contact Company No.","Company No.");
        InteractLogEntry.SETRANGE("Contact No.","No.");
        IF InteractLogEntry.FINDFIRST THEN
          ERROR(Text003,FIELDCAPTION(Type));
        Task.SETRANGE("Contact Company No.","Company No.");
        Task.SETRANGE("Contact No.","No.");
        IF NOT Task.ISEMPTY THEN
          ERROR(CannotChangeWithOpenTasksErr,FIELDCAPTION(Type));
        Opp.SETRANGE("Contact Company No.","Company No.");
        Opp.SETRANGE("Contact No.","No.");
        IF NOT Opp.ISEMPTY THEN
          ERROR(Text006,FIELDCAPTION(Type));
      END;

      CASE Type OF
        Type::Company:
          BEGIN
            IF Type <> xRec.Type THEN BEGIN
              TESTFIELD("Organizational Level Code",'');
              TESTFIELD("No. of Job Responsibilities",0);
            END;
            "First Name" := '';
            "Middle Name" := '';
            Surname := '';
            "Job Title" := '';
            "Company No." := "No.";
            "Company Name" := Name;
            "Salutation Code" := RMSetup."Def. Company Salutation Code";
          END;
        Type::Person:
          BEGIN
            CampaignTargetGrMgt.DeleteContfromTargetGr(InteractLogEntry);
            Cont.RESET;
            Cont.SETCURRENTKEY("Company No.");
            Cont.SETRANGE("Company No.","No.");
            Cont.SETRANGE(Type,Type::Person);
            IF Cont.FINDFIRST THEN
              ERROR(Text007,FIELDCAPTION(Type));
            IF Type <> xRec.Type THEN BEGIN
              TESTFIELD("No. of Business Relations",0);
              TESTFIELD("No. of Industry Groups",0);
              TESTFIELD("Currency Code",'');
              TESTFIELD("VAT Registration No.",'');
            END;
            IF "Company No." = "No." THEN BEGIN
              "Company No." := '';
              "Company Name" := '';
              "Salutation Code" := RMSetup."Default Person Salutation Code";
              NameBreakdown;
            END;
          END;
      END;
      VALIDATE("Lookup Contact No.");

      IF Cont.GET("No.") THEN BEGIN
        IF Type = Type::Company THEN
          CheckDupl
        ELSE
          DuplMgt.RemoveContIndex(Rec,FALSE);
      END;
    END;

    [External]
    PROCEDURE AssistEdit@2(OldCont@1000 : Record 5050) : Boolean;
    VAR
      Cont@1003 : Record 5050;
    BEGIN
      WITH Cont DO BEGIN
        Cont := Rec;
        RMSetup.GET;
        RMSetup.TESTFIELD("Contact Nos.");
        IF NoSeriesMgt.SelectSeries(RMSetup."Contact Nos.",OldCont."No. Series","No. Series") THEN BEGIN
          RMSetup.GET;
          RMSetup.TESTFIELD("Contact Nos.");
          NoSeriesMgt.SetSeries("No.");
          Rec := Cont;
          EXIT(TRUE);
        END;
      END;
    END;

    [External]
    PROCEDURE CreateCustomer@3(CustomerTemplate@1006 : Code[10]);
    VAR
      Cust@1000 : Record 18;
      CustTemplate@1003 : Record 5105;
      DefaultDim@1005 : Record 352;
      DefaultDim2@1004 : Record 352;
      ContBusRel@1008 : Record 5054;
      OfficeMgt@1002 : Codeunit 1630;
    BEGIN
      CheckForExistingRelationships(ContBusRel."Link to Table"::Customer);
      CheckIfPrivacyBlockedGeneric;
      RMSetup.GET;
      RMSetup.TESTFIELD("Bus. Rel. Code for Customers");

      IF CustomerTemplate <> '' THEN
        IF CustTemplate.GET(CustomerTemplate) THEN;

      CLEAR(Cust);
      Cust.SetInsertFromContact(TRUE);
      Cust."Contact Type" := Type;
      OnBeforeCustomerInsert(Cust,CustomerTemplate);
      Cust.INSERT(TRUE);
      Cust.SetInsertFromContact(FALSE);

      ContBusRel."Contact No." := "No.";
      ContBusRel."Business Relation Code" := RMSetup."Bus. Rel. Code for Customers";
      ContBusRel."Link to Table" := ContBusRel."Link to Table"::Customer;
      ContBusRel."No." := Cust."No.";
      ContBusRel.INSERT(TRUE);

      UpdateCustVendBank.UpdateCustomer(Rec,ContBusRel);

      Cust.GET(ContBusRel."No.");
      IF Type = Type::Company THEN BEGIN
        Cust.VALIDATE(Name,"Company Name");
        Cust.VALIDATE("Country/Region Code","Country/Region Code");
      END;
      Cust.MODIFY;

      IF CustTemplate.Code <> '' THEN BEGIN
        IF "Territory Code" = '' THEN
          Cust."Territory Code" := CustTemplate."Territory Code"
        ELSE
          Cust."Territory Code" := "Territory Code";
        IF "Currency Code" = '' THEN
          Cust."Currency Code" := CustTemplate."Currency Code"
        ELSE
          Cust."Currency Code" := "Currency Code";
        IF "Country/Region Code" = '' THEN
          Cust."Country/Region Code" := CustTemplate."Country/Region Code"
        ELSE
          Cust."Country/Region Code" := "Country/Region Code";
        Cust."Customer Posting Group" := CustTemplate."Customer Posting Group";
        Cust."Customer Price Group" := CustTemplate."Customer Price Group";
        IF CustTemplate."Invoice Disc. Code" <> '' THEN
          Cust."Invoice Disc. Code" := CustTemplate."Invoice Disc. Code";
        Cust."Customer Disc. Group" := CustTemplate."Customer Disc. Group";
        Cust."Allow Line Disc." := CustTemplate."Allow Line Disc.";
        Cust."Gen. Bus. Posting Group" := CustTemplate."Gen. Bus. Posting Group";
        Cust."VAT Bus. Posting Group" := CustTemplate."VAT Bus. Posting Group";
        Cust."Payment Terms Code" := CustTemplate."Payment Terms Code";
        Cust."Payment Method Code" := CustTemplate."Payment Method Code";
        Cust."Prices Including VAT" := CustTemplate."Prices Including VAT";
        Cust."Shipment Method Code" := CustTemplate."Shipment Method Code";
        Cust.MODIFY;

        DefaultDim.SETRANGE("Table ID",DATABASE::"Customer Template");
        DefaultDim.SETRANGE("No.",CustTemplate.Code);
        IF DefaultDim.FIND('-') THEN
          REPEAT
            CLEAR(DefaultDim2);
            DefaultDim2.INIT;
            DefaultDim2.VALIDATE("Table ID",DATABASE::Customer);
            DefaultDim2."No." := Cust."No.";
            DefaultDim2.VALIDATE("Dimension Code",DefaultDim."Dimension Code");
            DefaultDim2.VALIDATE("Dimension Value Code",DefaultDim."Dimension Value Code");
            DefaultDim2."Value Posting" := DefaultDim."Value Posting";
            DefaultDim2.INSERT(TRUE);
          UNTIL DefaultDim.NEXT = 0;
      END;

      UpdateQuotes(Cust);
      CampaignMgt.ConverttoCustomer(Rec,Cust);
      IF OfficeMgt.IsAvailable THEN
        PAGE.RUN(PAGE::"Customer Card",Cust)
      ELSE
        IF NOT HideValidationDialog THEN
          MESSAGE(RelatedRecordIsCreatedMsg,Cust.TABLECAPTION);
    END;

    [External]
    PROCEDURE CreateVendor@7();
    VAR
      ContBusRel@1004 : Record 5054;
      Vend@1000 : Record 23;
      ContComp@1001 : Record 5050;
      OfficeMgt@1002 : Codeunit 1630;
    BEGIN
      CheckForExistingRelationships(ContBusRel."Link to Table"::Vendor);
      CheckIfPrivacyBlockedGeneric;
      TESTFIELD("Company No.");
      RMSetup.GET;
      RMSetup.TESTFIELD("Bus. Rel. Code for Vendors");

      CLEAR(Vend);
      Vend.SetInsertFromContact(TRUE);
      OnBeforeVendorInsert(Vend);
      Vend.INSERT(TRUE);
      Vend.SetInsertFromContact(FALSE);

      IF Type = Type::Company THEN
        ContComp := Rec
      ELSE
        ContComp.GET("Company No.");

      ContBusRel."Contact No." := ContComp."No.";
      ContBusRel."Business Relation Code" := RMSetup."Bus. Rel. Code for Vendors";
      ContBusRel."Link to Table" := ContBusRel."Link to Table"::Vendor;
      ContBusRel."No." := Vend."No.";
      ContBusRel.INSERT(TRUE);

      UpdateCustVendBank.UpdateVendor(ContComp,ContBusRel);

      IF OfficeMgt.IsAvailable THEN
        PAGE.RUN(PAGE::"Vendor Card",Vend)
      ELSE
        IF NOT HideValidationDialog THEN
          MESSAGE(RelatedRecordIsCreatedMsg,Vend.TABLECAPTION);
    END;

    PROCEDURE CreateVendor2@40();
    BEGIN
      CreateVendor;
    END;

    [External]
    PROCEDURE CreateBankAccount@8();
    VAR
      BankAcc@1000 : Record 270;
      ContComp@1001 : Record 5050;
      ContBusRel@1003 : Record 5054;
    BEGIN
      TESTFIELD("Company No.");
      RMSetup.GET;
      RMSetup.TESTFIELD("Bus. Rel. Code for Bank Accs.");

      CLEAR(BankAcc);
      BankAcc.SetInsertFromContact(TRUE);
      BankAcc.INSERT(TRUE);
      BankAcc.SetInsertFromContact(FALSE);

      IF Type = Type::Company THEN
        ContComp := Rec
      ELSE
        ContComp.GET("Company No.");

      ContBusRel."Contact No." := ContComp."No.";
      ContBusRel."Business Relation Code" := RMSetup."Bus. Rel. Code for Bank Accs.";
      ContBusRel."Link to Table" := ContBusRel."Link to Table"::"Bank Account";
      ContBusRel."No." := BankAcc."No.";
      ContBusRel.INSERT(TRUE);

      CheckIfPrivacyBlockedGeneric;

      UpdateCustVendBank.UpdateBankAccount(ContComp,ContBusRel);

      IF NOT HideValidationDialog THEN
        MESSAGE(RelatedRecordIsCreatedMsg,BankAcc.TABLECAPTION);
    END;

    [External]
    PROCEDURE CreateCustomerLink@5();
    VAR
      Cust@1001 : Record 18;
      ContBusRel@1000 : Record 5054;
    BEGIN
      CheckForExistingRelationships(ContBusRel."Link to Table"::Customer);
      CheckIfPrivacyBlockedGeneric;
      RMSetup.GET;
      RMSetup.TESTFIELD("Bus. Rel. Code for Customers");
      CreateLink(
        PAGE::"Customer Link",
        RMSetup."Bus. Rel. Code for Customers",
        ContBusRel."Link to Table"::Customer);

      ContBusRel.SETCURRENTKEY("Link to Table","No.");
      ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
      ContBusRel.SETRANGE("Contact No.","Company No.");
      IF ContBusRel.FINDFIRST THEN
        IF Cust.GET(ContBusRel."No.") THEN
          UpdateQuotes(Cust);
    END;

    [External]
    PROCEDURE CreateVendorLink@6();
    VAR
      ContBusRel@1001 : Record 5054;
    BEGIN
      CheckForExistingRelationships(ContBusRel."Link to Table"::Vendor);
      CheckIfPrivacyBlockedGeneric;
      TESTFIELD("Company No.");
      RMSetup.GET;
      RMSetup.TESTFIELD("Bus. Rel. Code for Vendors");
      CreateLink(
        PAGE::"Vendor Link",
        RMSetup."Bus. Rel. Code for Vendors",
        ContBusRel."Link to Table"::Vendor);
    END;

    [External]
    PROCEDURE CreateBankAccountLink@9();
    VAR
      ContBusRel@1001 : Record 5054;
    BEGIN
      CheckIfPrivacyBlockedGeneric;
      TESTFIELD("Company No.");
      RMSetup.GET;
      RMSetup.TESTFIELD("Bus. Rel. Code for Bank Accs.");
      CreateLink(
        PAGE::"Bank Account Link",
        RMSetup."Bus. Rel. Code for Bank Accs.",
        ContBusRel."Link to Table"::"Bank Account");
    END;

    LOCAL PROCEDURE CreateLink@11(CreateForm@1000 : Integer;BusRelCode@1001 : Code[10];Table@1002 : ' ,Customer,Vendor,Bank Account');
    VAR
      TempContBusRel@1003 : TEMPORARY Record 5054;
    BEGIN
      TempContBusRel."Contact No." := "No.";
      TempContBusRel."Business Relation Code" := BusRelCode;
      TempContBusRel."Link to Table" := Table;
      TempContBusRel.INSERT;
      IF PAGE.RUNMODAL(CreateForm,TempContBusRel) = ACTION::LookupOK THEN; // enforce look up mode dialog
      TempContBusRel.DELETEALL;
    END;

    [External]
    PROCEDURE CreateInteraction@10();
    VAR
      TempSegmentLine@1000 : TEMPORARY Record 5077;
    BEGIN
      CheckIfPrivacyBlockedGeneric;
      TempSegmentLine.CreateInteractionFromContact(Rec);
    END;

    [External]
    PROCEDURE GetDefaultPhoneNo@31() : Text[30];
    VAR
      ClientTypeManagement@1000 : Codeunit 4;
    BEGIN
      IF ClientTypeManagement.IsClientType(CLIENTTYPE::Phone) THEN BEGIN
        IF "Mobile Phone No." = '' THEN
          EXIT("Phone No.");
        EXIT("Mobile Phone No.");
      END;
      IF "Phone No." = '' THEN
        EXIT("Mobile Phone No.");
      EXIT("Phone No.");
    END;

    PROCEDURE ShowCustVendBank@12();
    VAR
      ContBusRel@1000 : Record 5054;
      Cust@1002 : Record 18;
      Vend@1003 : Record 23;
      BankAcc@1004 : Record 270;
      FormSelected@1001 : Boolean;
    BEGIN
      FormSelected := TRUE;

      ContBusRel.RESET;

      IF "Company No." <> '' THEN
        ContBusRel.SETFILTER("Contact No.",'%1|%2',"No.","Company No.")
      ELSE
        ContBusRel.SETRANGE("Contact No.","No.");
      ContBusRel.SETFILTER("No.",'<>''''');

      CASE ContBusRel.COUNT OF
        0:
          ERROR(Text010,TABLECAPTION,"No.");
        1:
          ContBusRel.FINDFIRST;
        ELSE
          FormSelected := PAGE.RUNMODAL(PAGE::"Contact Business Relations",ContBusRel) = ACTION::LookupOK;
      END;

      IF FormSelected THEN
        CASE ContBusRel."Link to Table" OF
          ContBusRel."Link to Table"::Customer:
            BEGIN
              Cust.GET(ContBusRel."No.");
              PAGE.RUN(PAGE::"Customer Card",Cust);
            END;
          ContBusRel."Link to Table"::Vendor:
            BEGIN
              Vend.GET(ContBusRel."No.");
              PAGE.RUN(PAGE::"Vendor Card",Vend);
            END;
          ContBusRel."Link to Table"::"Bank Account":
            BEGIN
              BankAcc.GET(ContBusRel."No.");
              PAGE.RUN(PAGE::"Bank Account Card",BankAcc);
            END;
        END;
    END;

    LOCAL PROCEDURE NameBreakdown@13();
    VAR
      NamePart@1000 : ARRAY [30] OF Text[250];
      TempName@1001 : Text[250];
      FirstName250@1004 : Text[250];
      i@1002 : Integer;
      NoOfParts@1003 : Integer;
    BEGIN
      IF Type = Type::Company THEN
        EXIT;

      TempName := Name;
      WHILE STRPOS(TempName,' ') > 0 DO BEGIN
        IF STRPOS(TempName,' ') > 1 THEN BEGIN
          i := i + 1;
          NamePart[i] := COPYSTR(TempName,1,STRPOS(TempName,' ') - 1);
        END;
        TempName := COPYSTR(TempName,STRPOS(TempName,' ') + 1);
      END;
      i := i + 1;
      NamePart[i] := TempName;
      NoOfParts := i;

      "First Name" := '';
      "Middle Name" := '';
      Surname := '';
      FOR i := 1 TO NoOfParts DO
        IF (i = NoOfParts) AND (NoOfParts > 1) THEN
          Surname := COPYSTR(NamePart[i],1,MAXSTRLEN(Surname))
        ELSE
          IF (i = NoOfParts - 1) AND (NoOfParts > 2) THEN
            "Middle Name" := COPYSTR(NamePart[i],1,MAXSTRLEN("Middle Name"))
          ELSE BEGIN
            FirstName250 := DELCHR("First Name" + ' ' + NamePart[i],'<',' ');
            "First Name" := COPYSTR(FirstName250,1,MAXSTRLEN("First Name"));
          END;
    END;

    [External]
    PROCEDURE SetSkipDefault@15();
    BEGIN
      SkipDefaults := TRUE;
    END;

    [External]
    PROCEDURE IdenticalAddress@16(VAR Cont@1000 : Record 5050) : Boolean;
    BEGIN
      EXIT(
        (Address = Cont.Address) AND
        ("Address 2" = Cont."Address 2") AND
        ("Post Code" = Cont."Post Code") AND
        (City = Cont.City))
    END;

    [External]
    PROCEDURE ActiveAltAddress@17(ActiveDate@1000 : Date) : Code[10];
    VAR
      ContAltAddrDateRange@1001 : Record 5052;
    BEGIN
      ContAltAddrDateRange.SETCURRENTKEY("Contact No.","Starting Date");
      ContAltAddrDateRange.SETRANGE("Contact No.","No.");
      ContAltAddrDateRange.SETRANGE("Starting Date",0D,ActiveDate);
      ContAltAddrDateRange.SETFILTER("Ending Date",'>=%1|%2',ActiveDate,0D);
      IF ContAltAddrDateRange.FINDLAST THEN
        EXIT(ContAltAddrDateRange."Contact Alt. Address Code");

      EXIT('');
    END;

    LOCAL PROCEDURE CalculatedName@14() NewName@1000 : Text[50];
    VAR
      NewName92@1001 : Text[92];
    BEGIN
      IF "First Name" <> '' THEN
        NewName92 := "First Name";
      IF "Middle Name" <> '' THEN
        NewName92 := NewName92 + ' ' + "Middle Name";
      IF Surname <> '' THEN
        NewName92 := NewName92 + ' ' + Surname;

      NewName92 := DELCHR(NewName92,'<',' ');
      NewName := COPYSTR(NewName92,1,MAXSTRLEN(NewName));
    END;

    LOCAL PROCEDURE UpdateSearchName@22();
    BEGIN
      IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
        "Search Name" := Name;
    END;

    LOCAL PROCEDURE CheckDupl@21();
    BEGIN
      IF RMSetup."Maintain Dupl. Search Strings" THEN
        DuplMgt.MakeContIndex(Rec);
      IF GUIALLOWED THEN
        IF DuplMgt.DuplicateExist(Rec) THEN BEGIN
          MODIFY;
          COMMIT;
          DuplMgt.LaunchDuplicateForm(Rec);
        END;
    END;

    [External]
    PROCEDURE FindCustomerTemplate@23() : Code[10];
    VAR
      CustTemplate@1003 : Record 5105;
      ContCompany@1002 : Record 5050;
    BEGIN
      CustTemplate.RESET;
      CustTemplate.SETRANGE("Territory Code","Territory Code");
      CustTemplate.SETRANGE("Country/Region Code","Country/Region Code");
      CustTemplate.SETRANGE("Contact Type",Type);
      IF ContCompany.GET("Company No.") THEN
        CustTemplate.SETRANGE("Currency Code",ContCompany."Currency Code");

      IF CustTemplate.COUNT = 1 THEN BEGIN
        CustTemplate.FINDFIRST;
        EXIT(CustTemplate.Code);
      END;
    END;

    [External]
    PROCEDURE ChooseCustomerTemplate@27() : Code[10];
    VAR
      CustTemplate@1000 : Record 5105;
      ContBusRel@1002 : Record 5054;
    BEGIN
      CheckForExistingRelationships(ContBusRel."Link to Table"::Customer);
      ContBusRel.RESET;
      ContBusRel.SETRANGE("Contact No.","No.");
      ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
      IF ContBusRel.FINDFIRST THEN
        ERROR(
          Text019,
          TABLECAPTION,"No.",ContBusRel.TABLECAPTION,ContBusRel."Link to Table",ContBusRel."No.");

      IF CONFIRM(CreateCustomerFromContactQst,TRUE) THEN BEGIN
        CustTemplate.SETRANGE("Contact Type",Type);
        IF PAGE.RUNMODAL(0,CustTemplate) = ACTION::LookupOK THEN
          EXIT(CustTemplate.Code);

        ERROR(Text022);
      END;
    END;

    LOCAL PROCEDURE UpdateQuotes@29(Customer@1000 : Record 18);
    VAR
      SalesHeader@1003 : Record 36;
      SalesHeader2@1005 : Record 36;
      Cont@1004 : Record 5050;
      SalesLine@1001 : Record 37;
    BEGIN
      IF "Company No." <> '' THEN
        Cont.SETRANGE("Company No.","Company No.")
      ELSE
        Cont.SETRANGE("No.","No.");

      IF Cont.FINDSET THEN
        REPEAT
          SalesHeader.RESET;
          SalesHeader.SETRANGE("Sell-to Customer No.",'');
          SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Quote);
          SalesHeader.SETRANGE("Sell-to Contact No.",Cont."No.");
          IF SalesHeader.FINDSET THEN
            REPEAT
              SalesHeader2.GET(SalesHeader."Document Type",SalesHeader."No.");
              SalesHeader2."Sell-to Customer No." := Customer."No.";
              SalesHeader2."Sell-to Customer Name" := Customer.Name;
              SalesHeader2."Sell-to Customer Template Code" := '';
              IF SalesHeader2."Sell-to Contact No." = SalesHeader2."Bill-to Contact No." THEN BEGIN
                SalesHeader2."Bill-to Customer No." := Customer."No.";
                SalesHeader2."Bill-to Name" := Customer.Name;
                SalesHeader2."Bill-to Customer Template Code" := '';
                SalesHeader2."Salesperson Code" := Customer."Salesperson Code";
              END;
              SalesHeader2.MODIFY;
              SalesLine.SETRANGE("Document Type",SalesHeader2."Document Type");
              SalesLine.SETRANGE("Document No.",SalesHeader2."No.");
              SalesLine.MODIFYALL("Sell-to Customer No.",SalesHeader2."Sell-to Customer No.");
              IF SalesHeader2."Sell-to Contact No." = SalesHeader2."Bill-to Contact No." THEN
                SalesLine.MODIFYALL("Bill-to Customer No.",SalesHeader2."Bill-to Customer No.");
            UNTIL SalesHeader.NEXT = 0;

          SalesHeader.RESET;
          SalesHeader.SETRANGE("Bill-to Customer No.",'');
          SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Quote);
          SalesHeader.SETRANGE("Bill-to Contact No.",Cont."No.");
          IF SalesHeader.FINDSET THEN
            REPEAT
              SalesHeader2.GET(SalesHeader."Document Type",SalesHeader."No.");
              SalesHeader2."Bill-to Customer No." := Customer."No.";
              SalesHeader2."Bill-to Customer Template Code" := '';
              SalesHeader2."Salesperson Code" := Customer."Salesperson Code";
              SalesHeader2.MODIFY;
              SalesLine.SETRANGE("Document Type",SalesHeader2."Document Type");
              SalesLine.SETRANGE("Document No.",SalesHeader2."No.");
              SalesLine.MODIFYALL("Bill-to Customer No.",SalesHeader2."Bill-to Customer No.");
            UNTIL SalesHeader.NEXT = 0;
        UNTIL Cont.NEXT = 0;
    END;

    [External]
    PROCEDURE GetSalutation@18(SalutationType@1001 : 'Formal,Informal';LanguageCode@1000 : Code[10]) : Text[260];
    VAR
      SalutationFormula@1005 : Record 5069;
      NamePart@1004 : ARRAY [5] OF Text[50];
      SubStr@1003 : Text[30];
      i@1002 : Integer;
    BEGIN
      IF NOT SalutationFormula.GET("Salutation Code",LanguageCode,SalutationType) THEN
        ERROR(Text021,LanguageCode,"No.");
      SalutationFormula.TESTFIELD(Salutation);

      CASE SalutationFormula."Name 1" OF
        SalutationFormula."Name 1"::"Job Title":
          NamePart[1] := "Job Title";
        SalutationFormula."Name 1"::"First Name":
          NamePart[1] := "First Name";
        SalutationFormula."Name 1"::"Middle Name":
          NamePart[1] := "Middle Name";
        SalutationFormula."Name 1"::Surname:
          NamePart[1] := Surname;
        SalutationFormula."Name 1"::Initials:
          NamePart[1] := Initials;
        SalutationFormula."Name 1"::"Company Name":
          NamePart[1] := "Company Name";
      END;

      CASE SalutationFormula."Name 2" OF
        SalutationFormula."Name 2"::"Job Title":
          NamePart[2] := "Job Title";
        SalutationFormula."Name 2"::"First Name":
          NamePart[2] := "First Name";
        SalutationFormula."Name 2"::"Middle Name":
          NamePart[2] := "Middle Name";
        SalutationFormula."Name 2"::Surname:
          NamePart[2] := Surname;
        SalutationFormula."Name 2"::Initials:
          NamePart[2] := Initials;
        SalutationFormula."Name 2"::"Company Name":
          NamePart[2] := "Company Name";
      END;

      CASE SalutationFormula."Name 3" OF
        SalutationFormula."Name 3"::"Job Title":
          NamePart[3] := "Job Title";
        SalutationFormula."Name 3"::"First Name":
          NamePart[3] := "First Name";
        SalutationFormula."Name 3"::"Middle Name":
          NamePart[3] := "Middle Name";
        SalutationFormula."Name 3"::Surname:
          NamePart[3] := Surname;
        SalutationFormula."Name 3"::Initials:
          NamePart[3] := Initials;
        SalutationFormula."Name 3"::"Company Name":
          NamePart[3] := "Company Name";
      END;

      CASE SalutationFormula."Name 4" OF
        SalutationFormula."Name 4"::"Job Title":
          NamePart[4] := "Job Title";
        SalutationFormula."Name 4"::"First Name":
          NamePart[4] := "First Name";
        SalutationFormula."Name 4"::"Middle Name":
          NamePart[4] := "Middle Name";
        SalutationFormula."Name 4"::Surname:
          NamePart[4] := Surname;
        SalutationFormula."Name 4"::Initials:
          NamePart[4] := Initials;
        SalutationFormula."Name 4"::"Company Name":
          NamePart[4] := "Company Name";
      END;

      CASE SalutationFormula."Name 5" OF
        SalutationFormula."Name 5"::"Job Title":
          NamePart[5] := "Job Title";
        SalutationFormula."Name 5"::"First Name":
          NamePart[5] := "First Name";
        SalutationFormula."Name 5"::"Middle Name":
          NamePart[5] := "Middle Name";
        SalutationFormula."Name 5"::Surname:
          NamePart[5] := Surname;
        SalutationFormula."Name 5"::Initials:
          NamePart[5] := Initials;
        SalutationFormula."Name 5"::"Company Name":
          NamePart[5] := "Company Name";
      END;

      FOR i := 1 TO 5 DO
        IF NamePart[i] = '' THEN BEGIN
          SubStr := '%' + FORMAT(i) + ' ';
          IF STRPOS(SalutationFormula.Salutation,SubStr) > 0 THEN
            SalutationFormula.Salutation :=
              DELSTR(SalutationFormula.Salutation,STRPOS(SalutationFormula.Salutation,SubStr),3);
        END;

      EXIT(STRSUBSTNO(SalutationFormula.Salutation,NamePart[1],NamePart[2],NamePart[3],NamePart[4],NamePart[5]))
    END;

    [Internal]
    PROCEDURE InheritCompanyToPersonData@24(NewCompanyContact@1000 : Record 5050);
    BEGIN
      "Company Name" := NewCompanyContact.Name;

      RMSetup.GET;
      IF RMSetup."Inherit Salesperson Code" THEN
        "Salesperson Code" := NewCompanyContact."Salesperson Code";
      IF RMSetup."Inherit Territory Code" THEN
        "Territory Code" := NewCompanyContact."Territory Code";
      IF RMSetup."Inherit Country/Region Code" THEN
        "Country/Region Code" := NewCompanyContact."Country/Region Code";
      IF RMSetup."Inherit Language Code" THEN
        "Language Code" := NewCompanyContact."Language Code";
      IF RMSetup."Inherit Address Details" AND StaleAddress THEN BEGIN
        Address := NewCompanyContact.Address;
        "Address 2" := NewCompanyContact."Address 2";
        "Post Code" := NewCompanyContact."Post Code";
        City := NewCompanyContact.City;
        County := NewCompanyContact.County;
      END;
      IF RMSetup."Inherit Communication Details" THEN BEGIN
        UpdateFieldForNewCompany(FIELDNO("Phone No."));
        UpdateFieldForNewCompany(FIELDNO("Telex No."));
        UpdateFieldForNewCompany(FIELDNO("Fax No."));
        UpdateFieldForNewCompany(FIELDNO("Telex Answer Back"));
        UpdateFieldForNewCompany(FIELDNO("E-Mail"));
        UpdateFieldForNewCompany(FIELDNO("Home Page"));
        UpdateFieldForNewCompany(FIELDNO("Extension No."));
        UpdateFieldForNewCompany(FIELDNO("Mobile Phone No."));
        UpdateFieldForNewCompany(FIELDNO(Pager));
        UpdateFieldForNewCompany(FIELDNO("Correspondence Type"));
      END;
      CALCFIELDS("No. of Industry Groups","No. of Business Relations");
    END;

    LOCAL PROCEDURE StaleAddress@33() Stale : Boolean;
    VAR
      OldCompanyContact@1000 : Record 5050;
      DummyContact@1001 : Record 5050;
    BEGIN
      IF OldCompanyContact.GET(xRec."Company No.") THEN
        Stale := IdenticalAddress(OldCompanyContact);
      Stale := Stale OR IdenticalAddress(DummyContact);
    END;

    LOCAL PROCEDURE UpdateFieldForNewCompany@34(FieldNo@1001 : Integer);
    VAR
      OldCompanyContact@1000 : Record 5050;
      NewCompanyContact@1005 : Record 5050;
      OldCompanyRecRef@1002 : RecordRef;
      NewCompanyRecRef@1007 : RecordRef;
      ContactRecRef@1003 : RecordRef;
      ContactFieldRef@1008 : FieldRef;
      OldCompanyFieldValue@1004 : Text;
      ContactFieldValue@1006 : Text;
      Stale@1009 : Boolean;
    BEGIN
      ContactRecRef.GETTABLE(Rec);
      ContactFieldRef := ContactRecRef.FIELD(FieldNo);
      ContactFieldValue := FORMAT(ContactFieldRef.VALUE);

      IF NewCompanyContact.GET("Company No.") THEN BEGIN
        NewCompanyRecRef.GETTABLE(NewCompanyContact);
        IF OldCompanyContact.GET(xRec."Company No.") THEN BEGIN
          OldCompanyRecRef.GETTABLE(OldCompanyContact);
          OldCompanyFieldValue := FORMAT(OldCompanyRecRef.FIELD(FieldNo).VALUE);
          Stale := ContactFieldValue = OldCompanyFieldValue;
        END;
        IF Stale OR (ContactFieldValue = '') THEN BEGIN
          ContactFieldRef.VALIDATE(NewCompanyRecRef.FIELD(FieldNo).VALUE);
          ContactRecRef.SETTABLE(Rec);
        END;
      END;
    END;

    [External]
    PROCEDURE SetHideValidationDialog@26(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      HideValidationDialog := NewHideValidationDialog;
    END;

    [Internal]
    PROCEDURE DisplayMap@36();
    VAR
      MapPoint@1001 : Record 800;
      MapMgt@1000 : Codeunit 802;
    BEGIN
      IF MapPoint.FINDFIRST THEN
        MapMgt.MakeSelection(DATABASE::Contact,GETPOSITION)
      ELSE
        MESSAGE(Text033);
    END;

    LOCAL PROCEDURE ProcessNameChange@37();
    VAR
      ContBusRel@1000 : Record 5054;
      Cust@1001 : Record 18;
      Vend@1002 : Record 23;
    BEGIN
      UpdateSearchName;

      IF Type = Type::Company THEN
        "Company Name" := Name;

      IF Type = Type::Person THEN BEGIN
        ContBusRel.RESET;
        ContBusRel.SETCURRENTKEY("Link to Table","Contact No.");
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
        ContBusRel.SETRANGE("Contact No.","Company No.");
        IF ContBusRel.FINDFIRST THEN
          IF Cust.GET(ContBusRel."No.") THEN
            IF Cust."Primary Contact No." = "No." THEN BEGIN
              Cust.Contact := Name;
              Cust.MODIFY;
            END;

        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
        IF ContBusRel.FINDFIRST THEN
          IF Vend.GET(ContBusRel."No.") THEN
            IF Vend."Primary Contact No." = "No." THEN BEGIN
              Vend.Contact := Name;
              Vend.MODIFY;
            END;
      END;
    END;

    LOCAL PROCEDURE GetCompNo@19(ContactText@1000 : Text) : Text;
    VAR
      Contact@1001 : Record 5050;
      ContactWithoutQuote@1002 : Text;
      ContactFilterFromStart@1003 : Text;
      ContactFilterContains@1004 : Text;
      ContactNo@1005 : Code[20];
    BEGIN
      IF ContactText = '' THEN
        EXIT('');

      IF STRLEN(ContactText) <= MAXSTRLEN(Contact."Company No.") THEN
        IF Contact.GET(COPYSTR(ContactText,1,MAXSTRLEN(Contact."Company No."))) THEN
          EXIT(Contact."No.");

      ContactWithoutQuote := CONVERTSTR(ContactText,'''','?');

      Contact.SETRANGE(Type,Contact.Type::Company);

      Contact.SETFILTER(Name,'''@' + ContactWithoutQuote + '''');
      IF Contact.FINDFIRST THEN
        EXIT(Contact."No.");
      Contact.SETRANGE(Name);
      ContactFilterFromStart := '''@' + ContactWithoutQuote + '*''';
      Contact.FILTERGROUP := -1;
      Contact.SETFILTER("No.",ContactFilterFromStart);
      Contact.SETFILTER(Name,ContactFilterFromStart);
      IF Contact.FINDFIRST THEN
        EXIT(Contact."No.");
      ContactFilterContains := '''@*' + ContactWithoutQuote + '*''';
      Contact.SETFILTER("No.",ContactFilterContains);
      Contact.SETFILTER(Name,ContactFilterContains);
      Contact.SETFILTER(City,ContactFilterContains);
      Contact.SETFILTER("Phone No.",ContactFilterContains);
      Contact.SETFILTER("Post Code",ContactFilterContains);
      CASE Contact.COUNT OF
        1:
          BEGIN
            Contact.FINDFIRST;
            EXIT(Contact."No.");
          END;
        ELSE BEGIN
          IF NOT GUIALLOWED THEN
            ERROR(SelectContactErr);
          ContactNo := SelectContact(Contact);
          IF ContactNo <> '' THEN
            EXIT(ContactNo);
        END;
      END;
      ERROR(SelectContactErr);
    END;

    LOCAL PROCEDURE SelectContact@51(VAR Contact@1000 : Record 5050) : Code[20];
    VAR
      ContactList@1001 : Page 5052;
    BEGIN
      IF Contact.FINDSET THEN
        REPEAT
          Contact.MARK(TRUE);
        UNTIL Contact.NEXT = 0;
      IF Contact.FINDFIRST THEN;
      Contact.MARKEDONLY := TRUE;

      ContactList.SETTABLEVIEW(Contact);
      ContactList.SETRECORD(Contact);
      ContactList.LOOKUPMODE := TRUE;
      IF ContactList.RUNMODAL = ACTION::LookupOK THEN
        ContactList.GETRECORD(Contact)
      ELSE
        CLEAR(Contact);

      EXIT(Contact."No.");
    END;

    [External]
    PROCEDURE LookupCompany@25();
    VAR
      Contact@1001 : Record 5050;
      CompanyDetails@1000 : Page 5054;
    BEGIN
      Contact.SETRANGE("No.","Company No.");
      CompanyDetails.SETTABLEVIEW(Contact);
      CompanyDetails.SETRECORD(Contact);
      IF Type = Type::Person THEN
        CompanyDetails.EDITABLE := FALSE;
      CompanyDetails.RUNMODAL;
    END;

    PROCEDURE LookupCustomerTemplate@53() : Code[20];
    VAR
      CustomerTemplate@1001 : Record 5105;
      CustomerTemplateList@1000 : Page 5156;
    BEGIN
      CustomerTemplate.FILTERGROUP(2);
      CustomerTemplate.SETRANGE("Contact Type",Type);
      CustomerTemplate.FILTERGROUP(0);
      CustomerTemplateList.LOOKUPMODE := TRUE;
      CustomerTemplateList.SETTABLEVIEW(CustomerTemplate);
      IF CustomerTemplateList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        CustomerTemplateList.GETRECORD(CustomerTemplate);
        EXIT(CustomerTemplate.Code);
      END;
    END;

    LOCAL PROCEDURE CheckForExistingRelationships@20(LinkToTable@1000 : ' ,Customer,Vendor,Bank Account');
    VAR
      Contact@1001 : Record 5050;
      ContBusRel@1003 : Record 5054;
    BEGIN
      Contact := Rec;

      IF "No." <> '' THEN BEGIN
        IF ContBusRel.FindByContact(LinkToTable,Contact."No.") THEN
          ERROR(
            AlreadyExistErr,
            Contact.TABLECAPTION,"No.",ContBusRel.TABLECAPTION,LinkToTable,ContBusRel."No.");

        IF ContBusRel.FindByRelation(LinkToTable,"No.") THEN
          ERROR(
            AlreadyExistErr,
            LinkToTable,"No.",ContBusRel.TABLECAPTION,Contact.TABLECAPTION,ContBusRel."Contact No.");
      END;
    END;

    [External]
    PROCEDURE SetLastDateTimeModified@28();
    VAR
      DateFilterCalc@1000 : Codeunit 358;
      UtcNow@1001 : DateTime;
    BEGIN
      UtcNow := DateFilterCalc.ConvertToUtcDateTime(CURRENTDATETIME);
      "Last Date Modified" := DT2DATE(UtcNow);
      "Last Time Modified" := DT2TIME(UtcNow);
    END;

    [External]
    PROCEDURE SetLastDateTimeFilter@30(DateFilter@1001 : DateTime);
    VAR
      DateFilterCalc@1004 : Codeunit 358;
      SyncDateTimeUtc@1002 : DateTime;
      CurrentFilterGroup@1003 : Integer;
    BEGIN
      SyncDateTimeUtc := DateFilterCalc.ConvertToUtcDateTime(DateFilter);
      CurrentFilterGroup := FILTERGROUP;
      SETFILTER("Last Date Modified",'>=%1',DT2DATE(SyncDateTimeUtc));
      FILTERGROUP(-1);
      SETFILTER("Last Date Modified",'>%1',DT2DATE(SyncDateTimeUtc));
      SETFILTER("Last Time Modified",'>%1',DT2TIME(SyncDateTimeUtc));
      FILTERGROUP(CurrentFilterGroup);
    END;

    PROCEDURE TouchContact@32(ContactNo@1000 : Code[20]);
    VAR
      Cont@1001 : Record 5050;
    BEGIN
      Cont.LOCKTABLE;
      IF Cont.GET(ContactNo) THEN BEGIN
        Cont.SetLastDateTimeModified;
        Cont.MODIFY;
      END;
    END;

    PROCEDURE CountNoOfBusinessRelations@35() : Integer;
    VAR
      ContactBusinessRelation@1000 : Record 5054;
    BEGIN
      IF "Company No." <> '' THEN
        ContactBusinessRelation.SETFILTER("Contact No.",'%1|%2',"No.","Company No.")
      ELSE
        ContactBusinessRelation.SETRANGE("Contact No.","No.");
      EXIT(ContactBusinessRelation.COUNT);
    END;

    PROCEDURE CreateSalesQuoteFromContact@38();
    VAR
      SalesHeader@1001 : Record 36;
    BEGIN
      CheckIfPrivacyBlockedGeneric;
      SalesHeader.INIT;
      SalesHeader.VALIDATE("Document Type",SalesHeader."Document Type"::Quote);
      SalesHeader.INSERT(TRUE);
      SalesHeader.VALIDATE("Document Date",WORKDATE);
      SalesHeader.VALIDATE("Sell-to Contact No.","No.");
      SalesHeader.MODIFY;
      PAGE.RUN(PAGE::"Sales Quote",SalesHeader);
    END;

    PROCEDURE ContactToCustBusinessRelationExist@44() : Boolean;
    VAR
      ContBusRel@1000 : Record 5054;
    BEGIN
      ContBusRel.RESET;
      ContBusRel.SETRANGE("Contact No.","No.");
      ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
      EXIT(ContBusRel.FINDFIRST);
    END;

    PROCEDURE CheckIfMinorForProfiles@52();
    BEGIN
      IF Minor THEN
        ERROR(ProfileForMinorErr);
    END;

    PROCEDURE CheckIfPrivacyBlocked@48(IsPosting@1000 : Boolean);
    BEGIN
      IF "Privacy Blocked" THEN BEGIN
        IF IsPosting THEN
          ERROR(PrivacyBlockedPostErr,"No.");
        ERROR(PrivacyBlockedCreateErr,"No.");
      END;
    END;

    PROCEDURE CheckIfPrivacyBlockedGeneric@50();
    BEGIN
      IF "Privacy Blocked" THEN
        ERROR(PrivacyBlockedGenericErr,"No.");
    END;

    LOCAL PROCEDURE ValidateSalesPerson@433();
    BEGIN
      IF "Salesperson Code" <> '' THEN
        IF Salesperson.GET("Salesperson Code") THEN
          IF Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) THEN
            ERROR(Salesperson.GetPrivacyBlockedGenericText(Salesperson,TRUE))
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnBeforeVendorInsert@43(VAR Vend@1000 : Record 23);
    BEGIN
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE OnBeforeCustomerInsert@42(VAR Cust@1000 : Record 18;CustomerTemplate@1001 : Code[10]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeIsUpdateNeeded@49(Contact@1000 : Record 5050;xContact@1001 : Record 5050;VAR UpdateNeeded@1002 : Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE SetDefaultSalesperson@39();
    VAR
      UserSetup@1000 : Record 91;
    BEGIN
      IF UserSetup.GET(USERID) AND (UserSetup."Salespers./Purch. Code" <> '') THEN
        "Salesperson Code" := UserSetup."Salespers./Purch. Code";
    END;

    LOCAL PROCEDURE VATRegistrationValidation@41();
    VAR
      VATRegistrationNoFormat@1005 : Record 381;
      VATRegistrationLog@1004 : Record 249;
      VATRegNoSrvConfig@1003 : Record 248;
      VATRegistrationLogMgt@1002 : Codeunit 249;
      ResultRecordRef@1001 : RecordRef;
      ApplicableCountryCode@1000 : Code[10];
    BEGIN
      IF NOT VATRegistrationNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Contact) THEN
        EXIT;

      VATRegistrationLogMgt.LogContact(Rec);

      IF ("Country/Region Code" = '') AND (VATRegistrationNoFormat."Country/Region Code" = '') THEN
        EXIT;
      ApplicableCountryCode := "Country/Region Code";
      IF ApplicableCountryCode = '' THEN
        ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";

      IF VATRegNoSrvConfig.VATRegNoSrvIsEnabled THEN BEGIN
        VATRegistrationLogMgt.ValidateVATRegNoWithVIES(ResultRecordRef,Rec,"No.",
          VATRegistrationLog."Account Type"::Contact,ApplicableCountryCode);
        ResultRecordRef.SETTABLE(Rec);
      END;
    END;

    [External]
    PROCEDURE GetContNo@45(ContactText@1000 : Text) : Code[20];
    VAR
      Contact@1001 : Record 5050;
      ContactWithoutQuote@1005 : Text;
      ContactFilterFromStart@1004 : Text;
      ContactFilterContains@1003 : Text;
    BEGIN
      IF ContactText = '' THEN
        EXIT('');

      IF STRLEN(ContactText) <= MAXSTRLEN(Contact."No.") THEN
        IF Contact.GET(COPYSTR(ContactText,1,MAXSTRLEN(Contact."No."))) THEN
          EXIT(Contact."No.");

      Contact.SETRANGE(Name,ContactText);
      IF Contact.FINDFIRST THEN
        EXIT(Contact."No.");

      ContactWithoutQuote := CONVERTSTR(ContactText,'''','?');

      Contact.SETFILTER(Name,'''@' + ContactWithoutQuote + '''');
      IF Contact.FINDFIRST THEN
        EXIT(Contact."No.");

      Contact.SETRANGE(Name);

      ContactFilterFromStart := '''@' + ContactWithoutQuote + '*''';
      Contact.FILTERGROUP := -1;
      Contact.SETFILTER("No.",ContactFilterFromStart);
      Contact.SETFILTER(Name,ContactFilterFromStart);
      IF Contact.FINDFIRST THEN
        EXIT(Contact."No.");

      ContactFilterContains := '''@*' + ContactWithoutQuote + '*''';
      Contact.SETFILTER("No.",ContactFilterContains);
      Contact.SETFILTER(Name,ContactFilterContains);
      Contact.SETFILTER(City,ContactFilterContains);
      Contact.SETFILTER("Phone No.",ContactFilterContains);
      Contact.SETFILTER("Post Code",ContactFilterContains);
      IF Contact.COUNT = 0 THEN
        MarkContactsWithSimilarName(Contact,ContactText);

      IF Contact.COUNT = 1 THEN BEGIN
        Contact.FINDFIRST;
        EXIT(Contact."No.");
      END;

      EXIT('');
    END;

    LOCAL PROCEDURE MarkContactsWithSimilarName@46(VAR Contact@1001 : Record 5050;ContactText@1000 : Text);
    VAR
      TypeHelper@1002 : Codeunit 10;
      ContactCount@1003 : Integer;
      ContactTextLength@1004 : Integer;
      Treshold@1005 : Integer;
    BEGIN
      IF ContactText = '' THEN
        EXIT;
      IF STRLEN(ContactText) > MAXSTRLEN(Contact.Name) THEN
        EXIT;

      ContactTextLength := STRLEN(ContactText);
      Treshold := ContactTextLength DIV 5;
      IF Treshold = 0 THEN
        EXIT;

      Contact.RESET;
      Contact.ASCENDING(FALSE); // most likely to search for newest contacts
      IF Contact.FINDSET THEN
        REPEAT
          ContactCount += 1;
          IF ABS(ContactTextLength - STRLEN(Contact.Name)) <= Treshold THEN
            IF TypeHelper.TextDistance(UPPERCASE(ContactText),UPPERCASE(Contact.Name)) <= Treshold THEN
              Contact.MARK(TRUE);
        UNTIL Contact.MARK OR (Contact.NEXT = 0) OR (ContactCount > 1000);
      Contact.MARKEDONLY(TRUE);
    END;

    LOCAL PROCEDURE IsUpdateNeeded@47() : Boolean;
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
        (Type <> xRec.Type);

      OnBeforeIsUpdateNeeded(Rec,xRec,UpdateNeeded);
      EXIT(UpdateNeeded);
    END;

    BEGIN
    END.
  }
}

