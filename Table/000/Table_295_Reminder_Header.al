OBJECT Table 295 Reminder Header
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783,NAVDK11.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,Name;
    OnInsert=BEGIN
               SalesSetup.GET;
               IF "No." = '' THEN BEGIN
                 SalesSetup.TESTFIELD("Reminder Nos.");
                 SalesSetup.TESTFIELD("Issued Reminder Nos.");
                 NoSeriesMgt.InitSeries(
                   SalesSetup."Reminder Nos.",xRec."No. Series","Posting Date",
                   "No.","No. Series");
               END;
               "Posting Description" := STRSUBSTNO(Text000,"No.");
               IF ("No. Series" <> '') AND
                  (SalesSetup."Reminder Nos." = SalesSetup."Issued Reminder Nos.")
               THEN
                 "Issuing No. Series" := "No. Series"
               ELSE
                 NoSeriesMgt.SetDefaultSeries("Issuing No. Series",SalesSetup."Issued Reminder Nos.");
               IF "Posting Date" = 0D THEN
                 "Posting Date" := WORKDATE;
               "Document Date" := WORKDATE;
               "Due Date" := WORKDATE;
               IF GETFILTER("Customer No.") <> '' THEN
                 IF GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") THEN
                   VALIDATE("Customer No.",GETRANGEMIN("Customer No."));
             END;

    OnDelete=BEGIN
               ReminderIssue.DeleteHeader(Rec,IssuedReminderHeader);

               ReminderLine.SETRANGE("Reminder No.","No.");
               ReminderLine.DELETEALL;

               ReminderCommentLine.SETRANGE(Type,ReminderCommentLine.Type::Reminder);
               ReminderCommentLine.SETRANGE("No.","No.");
               ReminderCommentLine.DELETEALL;

               IF IssuedReminderHeader."No." <> '' THEN BEGIN
                 COMMIT;
                 IF CONFIRM(
                      Text001,TRUE,
                      IssuedReminderHeader."No.")
                 THEN BEGIN
                   IssuedReminderHeader.SETRECFILTER;
                   IssuedReminderHeader.PrintRecords(TRUE,FALSE,FALSE)
                 END;
               END;
             END;

    CaptionML=[DAN=Rykkerhoved;
               ENU=Reminder Header];
    LookupPageID=Page436;
    DrillDownPageID=Page436;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Reminder Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                                "Posting Description" := STRSUBSTNO(Text000,"No.");
                                                              END;

                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
                                                   OnValidate=BEGIN
                                                                IF CurrFieldNo = FIELDNO("Customer No.") THEN
                                                                  IF Undo THEN BEGIN
                                                                    "Customer No." := xRec."Customer No.";
                                                                    CreateDim(DATABASE::Customer,"Customer No.");
                                                                    EXIT;
                                                                  END;
                                                                IF "Customer No." = '' THEN BEGIN
                                                                  CreateDim(DATABASE::Customer,"Customer No.");
                                                                  EXIT;
                                                                END;
                                                                Cust.GET("Customer No.");
                                                                IF Cust.Blocked = Cust.Blocked::All THEN
                                                                  Cust.CustBlockedErrorMessage(Cust,FALSE);
                                                                Name := Cust.Name;
                                                                "Name 2" := Cust."Name 2";
                                                                Address := Cust.Address;
                                                                "Address 2" := Cust."Address 2";
                                                                "Post Code" := Cust."Post Code";
                                                                City := Cust.City;
                                                                County := Cust.County;
                                                                Contact := Cust.Contact;
                                                                "Contact Phone No." := Cust."Phone No.";
                                                                "Contact Fax No." := Cust."Fax No.";
                                                                "Contact E-Mail" := Cust."E-Mail";
                                                                "Contact Role" := "Contact Role"::" ";
                                                                "Country/Region Code" := Cust."Country/Region Code";
                                                                "Language Code" := Cust."Language Code";
                                                                "Currency Code" := Cust."Currency Code";
                                                                "Shortcut Dimension 1 Code" := Cust."Global Dimension 1 Code";
                                                                "Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";
                                                                "VAT Registration No." := Cust."VAT Registration No.";
                                                                Cust.TESTFIELD("Customer Posting Group");
                                                                "Customer Posting Group" := Cust."Customer Posting Group";
                                                                "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                                                                "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                                                                "Tax Area Code" := Cust."Tax Area Code";
                                                                "Tax Liable" := Cust."Tax Liable";
                                                                "Reminder Terms Code" := Cust."Reminder Terms Code";
                                                                "Fin. Charge Terms Code" := Cust."Fin. Charge Terms Code";
                                                                "Account Code" := Cust."Account Code";
                                                                "EAN No." := Cust.GLN;
                                                                VALIDATE("Reminder Terms Code");

                                                                CreateDim(DATABASE::Customer,"Customer No.");
                                                              END;

                                                   CaptionML=[DAN=Debitornr.;
                                                              ENU=Customer No.] }
    { 3   ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 4   ;   ;Name 2              ;Text50        ;CaptionML=[DAN=Navn 2;
                                                              ENU=Name 2] }
    { 5   ;   ;Address             ;Text50        ;CaptionML=[DAN=Adresse;
                                                              ENU=Address] }
    { 6   ;   ;Address 2           ;Text50        ;CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2] }
    { 7   ;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 8   ;   ;City                ;Text30        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City] }
    { 9   ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 10  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr�dekode;
                                                              ENU=Country/Region Code] }
    { 11  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 12  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   OnValidate=BEGIN
                                                                IF CurrFieldNo = FIELDNO("Currency Code") THEN
                                                                  IF Undo THEN BEGIN
                                                                    "Currency Code" := xRec."Currency Code";
                                                                    EXIT;
                                                                  END;
                                                              END;

                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 13  ;   ;Contact             ;Text50        ;CaptionML=[DAN=Kontakt;
                                                              ENU=Contact] }
    { 14  ;   ;Your Reference      ;Text30        ;CaptionML=[DAN=Reference;
                                                              ENU=Your Reference] }
    { 15  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 16  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 17  ;   ;Customer Posting Group;Code20      ;TableRelation="Customer Posting Group";
                                                   CaptionML=[DAN=Debitorbogf�ringsgruppe;
                                                              ENU=Customer Posting Group];
                                                   Editable=No }
    { 18  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   OnValidate=BEGIN
                                                                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                                                                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                                                                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                                                              END;

                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group];
                                                   Editable=No }
    { 19  ;   ;VAT Registration No.;Text20        ;CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
    { 20  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 21  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date] }
    { 22  ;   ;Document Date       ;Date          ;OnValidate=BEGIN
                                                                IF CurrFieldNo = FIELDNO("Document Date") THEN
                                                                  IF Undo THEN BEGIN
                                                                    "Document Date" := xRec."Document Date";
                                                                    EXIT;
                                                                  END;
                                                                VALIDATE("Reminder Level");
                                                              END;

                                                   CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 23  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 24  ;   ;Reminder Terms Code ;Code10        ;TableRelation="Reminder Terms";
                                                   OnValidate=BEGIN
                                                                IF CurrFieldNo = FIELDNO("Reminder Terms Code") THEN
                                                                  IF Undo THEN BEGIN
                                                                    "Reminder Terms Code" := xRec."Reminder Terms Code";
                                                                    EXIT;
                                                                  END;
                                                                IF "Reminder Terms Code" <> '' THEN BEGIN
                                                                  ReminderTerms.GET("Reminder Terms Code");
                                                                  "Post Interest" := ReminderTerms."Post Interest";
                                                                  "Post Additional Fee" := ReminderTerms."Post Additional Fee";
                                                                  "Post Add. Fee per Line" := ReminderTerms."Post Add. Fee per Line";
                                                                  VALIDATE("Reminder Level");
                                                                  VALIDATE("Post Interest");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Rykkerbetingelseskode;
                                                              ENU=Reminder Terms Code] }
    { 25  ;   ;Fin. Charge Terms Code;Code10      ;TableRelation="Finance Charge Terms";
                                                   OnValidate=BEGIN
                                                                IF CurrFieldNo = FIELDNO("Fin. Charge Terms Code") THEN
                                                                  IF Undo THEN BEGIN
                                                                    "Fin. Charge Terms Code" := xRec."Fin. Charge Terms Code";
                                                                    EXIT;
                                                                  END;
                                                              END;

                                                   CaptionML=[DAN=Rentebetingelseskode;
                                                              ENU=Fin. Charge Terms Code] }
    { 26  ;   ;Post Interest       ;Boolean       ;CaptionML=[DAN=Bogf�r rente;
                                                              ENU=Post Interest] }
    { 27  ;   ;Post Additional Fee ;Boolean       ;CaptionML=[DAN=Bogf�r opkr�vningsgebyr;
                                                              ENU=Post Additional Fee] }
    { 28  ;   ;Reminder Level      ;Integer       ;TableRelation="Reminder Level".No. WHERE (Reminder Terms Code=FIELD(Reminder Terms Code));
                                                   OnValidate=BEGIN
                                                                IF ("Reminder Level" <> 0) AND ("Reminder Terms Code" <> '') THEN BEGIN
                                                                  ReminderTerms.GET("Reminder Terms Code");
                                                                  ReminderLevel.SETRANGE("Reminder Terms Code","Reminder Terms Code");
                                                                  ReminderLevel.SETRANGE("No.",1,"Reminder Level");
                                                                  IF ReminderLevel.FINDLAST AND ("Document Date" <> 0D) THEN
                                                                    "Due Date" := CALCDATE(ReminderLevel."Due Date Calculation","Document Date");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Rykkerniveau;
                                                              ENU=Reminder Level] }
    { 29  ;   ;Posting Description ;Text50        ;CaptionML=[DAN=Bogf�ringsbeskrivelse;
                                                              ENU=Posting Description] }
    { 30  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Reminder Comment Line" WHERE (Type=CONST(Reminder),
                                                                                                    No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 31  ;   ;Remaining Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reminder Line"."Remaining Amount" WHERE (Reminder No.=FIELD(No.),
                                                                                                             Line Type=FILTER(<>Not Due)));
                                                   CaptionML=[DAN=Restbel�b;
                                                              ENU=Remaining Amount];
                                                   DecimalPlaces=2:2;
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 32  ;   ;Interest Amount     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reminder Line".Amount WHERE (Reminder No.=FIELD(No.),
                                                                                                 Type=CONST(Customer Ledger Entry),
                                                                                                 Line Type=FILTER(<>Not Due)));
                                                   CaptionML=[DAN=Rentebel�b;
                                                              ENU=Interest Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 33  ;   ;Additional Fee      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reminder Line".Amount WHERE (Reminder No.=FIELD(No.),
                                                                                                 Type=CONST(G/L Account),
                                                                                                 Line Type=FILTER(<>Not Due)));
                                                   CaptionML=[DAN=Opkr�vningsgebyr;
                                                              ENU=Additional Fee];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 34  ;   ;VAT Amount          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reminder Line"."VAT Amount" WHERE (Reminder No.=FIELD(No.),
                                                                                                       Line Type=FILTER(<>Not Due)));
                                                   CaptionML=[DAN=Momsbel�b;
                                                              ENU=VAT Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 37  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 38  ;   ;Issuing No. Series  ;Code20        ;TableRelation="No. Series";
                                                   OnValidate=BEGIN
                                                                IF "Issuing No. Series" <> '' THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  SalesSetup.TESTFIELD("Reminder Nos.");
                                                                  SalesSetup.TESTFIELD("Issued Reminder Nos.");
                                                                  NoSeriesMgt.TestSeries(SalesSetup."Issued Reminder Nos.","Issuing No. Series");
                                                                END;
                                                                TESTFIELD("Issuing No.",'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              WITH ReminderHeader DO BEGIN
                                                                ReminderHeader := Rec;
                                                                SalesSetup.GET;
                                                                SalesSetup.TESTFIELD("Reminder Nos.");
                                                                SalesSetup.TESTFIELD("Issued Reminder Nos.");
                                                                IF NoSeriesMgt.LookupSeries(SalesSetup."Issued Reminder Nos.","Issuing No. Series") THEN
                                                                  VALIDATE("Issuing No. Series");
                                                                Rec := ReminderHeader;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Udstedelsesnummerserie;
                                                              ENU=Issuing No. Series] }
    { 39  ;   ;Issuing No.         ;Code20        ;CaptionML=[DAN=Udstedelsesnr.;
                                                              ENU=Issuing No.] }
    { 41  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=Skatteomr�dekode;
                                                              ENU=Tax Area Code] }
    { 42  ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 43  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 44  ;   ;Use Header Level    ;Boolean       ;CaptionML=[DAN=Brug hovedniveau;
                                                              ENU=Use Header Level] }
    { 45  ;   ;Add. Fee per Line   ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Reminder Line".Amount WHERE (Reminder No.=FIELD(No.),
                                                                                                 Type=CONST(Line Fee),
                                                                                                 Line Type=FILTER(<>Not Due)));
                                                   CaptionML=[DAN=Opkr�vningsgebyr pr. linje;
                                                              ENU=Add. Fee per Line];
                                                   AutoFormatExpr="Currency Code" }
    { 46  ;   ;Post Add. Fee per Line;Boolean     ;CaptionML=[DAN=Bogf�r opkr�vningsgebyr pr. linje;
                                                              ENU=Post Add. Fee per Line] }
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
    { 9000;   ;Assigned User ID    ;Code50        ;TableRelation="User Setup";
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Tildelt bruger-id;
                                                              ENU=Assigned User ID] }
    { 13600;  ;EAN No.             ;Code13        ;OnValidate=BEGIN
                                                                IF "EAN No." = '' THEN
                                                                  EXIT;

                                                                IF NOT OIOUBLDocumentEncode.IsValidEANNo("EAN No.") THEN
                                                                  FIELDERROR("EAN No.", Text13606);
                                                              END;

                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=EAN-nr.;
                                                              ENU=EAN No.] }
    { 13602;  ;Account Code        ;Text30        ;OnValidate=BEGIN
                                                                ReminderLine.RESET;
                                                                ReminderLine.SETRANGE("Reminder No.","No.");
                                                                ReminderLine.SETFILTER(Type, '>%1', ReminderLine.Type::" ");
                                                                ReminderLine.SETFILTER("Account Code", '%1|%2', xRec."Account Code", '');
                                                                ReminderLine.MODIFYALL("Account Code", "Account Code");
                                                              END;

                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontokode;
                                                              ENU=Account Code] }
    { 13605;  ;Contact Phone No.   ;Text30        ;ExtendedDatatype=Phone No.;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontaktens telefonnummer;
                                                              ENU=Contact Phone No.] }
    { 13606;  ;Contact Fax No.     ;Text30        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontaktens faxnummer;
                                                              ENU=Contact Fax No.] }
    { 13607;  ;Contact E-Mail      ;Text80        ;ExtendedDatatype=E-Mail;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontaktens mailadresse;
                                                              ENU=Contact E-Mail] }
    { 13608;  ;Contact Role        ;Option        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Kontaktens rolle;
                                                              ENU=Contact Role];
                                                   OptionCaptionML=[DAN=" ,,,Indk�bsansvarlig,,,Bogholder,,,Budgetansvarlig,,,Indk�ber";
                                                                    ENU=" ,,,Purchase Responsible,,,Accountant,,,Budget Responsible,,,Requisitioner"];
                                                   OptionString=[ ,,,Purchase Responsible,,,Accountant,,,Budget Responsible,,,Requisitioner] }
    { 13620;  ;Payment Channel     ;Option        ;OnValidate=BEGIN
                                                                IF "Payment Channel" = "Payment Channel"::"Payment Slip" THEN
                                                                  ERROR(Text13607, FIELDCAPTION("Payment Channel"),"Payment Channel");
                                                              END;

                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Betalingskanal;
                                                              ENU=Payment Channel];
                                                   OptionCaptionML=[DAN=" ,Betalingsbon,Kontooverf�rsel,National transaktion,Direct Debit";
                                                                    ENU=" ,Payment Slip,Account Transfer,National Clearing,Direct Debit"];
                                                   OptionString=[ ,Payment Slip,Account Transfer,National Clearing,Direct Debit] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Customer No.,Currency Code               }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Customer No.,Name,Due Date           }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Rykker %1;ENU=Reminder %1';
      Text001@1001 : TextConst 'DAN=�nsker du at udskrive rykker %1?;ENU=Do you want to print reminder %1?';
      Text002@1002 : TextConst 'DAN=�ndringen sletter linjerne i denne rykker.\\;ENU=This change will cause the existing lines to be deleted for this reminder.\\';
      Text003@1003 : TextConst 'DAN=Vil du forts�tte?;ENU=Do you want to continue?';
      Text004@1004 : TextConst 'DAN=Der er ikke plads til at inds�tte teksten.;ENU=There is not enough space to insert the text.';
      Text005@1005 : TextConst 'DAN="Hvis du sletter dette dokument, opst�r der et hul i nummerserien for rykkere. ";ENU="Deleting this document will cause a gap in the number series for reminders. "';
      Text006@1006 : TextConst 'DAN=For at udfylde dette hul i nummerserien vil der bliver dannet en blank rykker %1.\\;ENU=An empty reminder %1 will be created to fill this gap in the number series.\\';
      Currency@1011 : Record 4;
      SalesSetup@1007 : Record 311;
      CustPostingGr@1008 : Record 92;
      ReminderTerms@1009 : Record 292;
      ReminderLevel@1010 : Record 293;
      ReminderText@1012 : Record 294;
      FinChrgTerms@1013 : Record 5;
      ReminderHeader@1014 : Record 295;
      ReminderLine@1015 : Record 296;
      ReminderCommentLine@1016 : Record 299;
      Cust@1017 : Record 18;
      PostCode@1018 : Record 225;
      IssuedReminderHeader@1019 : Record 297;
      GenBusPostingGrp@1020 : Record 250;
      OIOUBLDocumentEncode@1101100000 : Codeunit 13600;
      ApplicationManagement@1031 : Codeunit 1;
      NoSeriesMgt@1022 : Codeunit 396;
      TransferExtendedText@1023 : Codeunit 378;
      ReminderIssue@1024 : Codeunit 393;
      DimMgt@1025 : Codeunit 408;
      NextLineNo@1026 : Integer;
      LineSpacing@1027 : Integer;
      ReminderTotal@1028 : Decimal;
      Text13606@1101100001 : TextConst 'DAN=indeholder ikke et gyldigt 13-cifret EAN-nr.;ENU=does not contain a valid, 13-digit EAN No.';
      Text13607@1101100002 : TextConst 'DAN=%1 %2 underst�ttes ikke i denne version af OIOUBL.;ENU=%1 %2 is not supported in this version of OIOUBL.';

    [External]
    PROCEDURE AssistEdit@9(OldReminderHeader@1000 : Record 295) : Boolean;
    BEGIN
      WITH ReminderHeader DO BEGIN
        ReminderHeader := Rec;
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Reminder Nos.");
        SalesSetup.TESTFIELD("Issued Reminder Nos.");
        IF NoSeriesMgt.SelectSeries(SalesSetup."Reminder Nos.",OldReminderHeader."No. Series","No. Series") THEN BEGIN
          SalesSetup.GET;
          SalesSetup.TESTFIELD("Reminder Nos.");
          SalesSetup.TESTFIELD("Issued Reminder Nos.");
          NoSeriesMgt.SetSeries("No.");
          Rec := ReminderHeader;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE Undo@6() : Boolean;
    BEGIN
      ReminderLine.SETRANGE("Reminder No.","No.");
      IF ReminderLine.FIND('-') THEN BEGIN
        COMMIT;
        IF NOT
           CONFIRM(
             Text002 +
             Text003,
             FALSE)
        THEN
          EXIT(TRUE);
        ReminderLine.DELETEALL;
        MODIFY
      END;
    END;

    PROCEDURE InsertLines@3();
    VAR
      ReminderLine2@1000 : Record 296;
      CurrencyForReminderLevel@1002 : Record 329;
      CaptionManagement@1003 : Codeunit 42;
      AdditionalFee@1001 : Decimal;
    BEGIN
      CurrencyForReminderLevel.INIT;
      ReminderLevel.SETRANGE("Reminder Terms Code","Reminder Terms Code");
      ReminderLevel.SETRANGE("No.",1,"Reminder Level");
      IF ReminderLevel.FINDLAST THEN BEGIN
        CALCFIELDS("Remaining Amount");
        AdditionalFee := ReminderLevel.GetAdditionalFee("Remaining Amount","Currency Code",FALSE,"Posting Date");

        IF AdditionalFee > 0 THEN BEGIN
          ReminderLine.RESET;
          ReminderLine.SETRANGE("Reminder No.","No.");
          ReminderLine.SETRANGE("Line Type",ReminderLine."Line Type"::"Reminder Line");
          ReminderLine."Reminder No." := "No.";
          IF ReminderLine.FIND('+') THEN
            NextLineNo := ReminderLine."Line No."
          ELSE
            NextLineNo := 0;
          ReminderLine.SETRANGE("Line Type");
          ReminderLine2 := ReminderLine;
          ReminderLine2.COPYFILTERS(ReminderLine);
          ReminderLine2.SETFILTER("Line Type",'<>%1',ReminderLine2."Line Type"::"Line Fee");
          IF ReminderLine2.NEXT <> 0 THEN BEGIN
            LineSpacing := (ReminderLine2."Line No." - ReminderLine."Line No.") DIV 3;
          END ELSE
            LineSpacing := 10000;
          InsertBlankLine(ReminderLine."Line Type"::"Additional Fee");

          NextLineNo := NextLineNo + LineSpacing;
          ReminderLine.INIT;
          ReminderLine."Account Code" := "Account Code";
          ReminderLine."Line No." := NextLineNo;
          ReminderLine.Type := ReminderLine.Type::"G/L Account";
          TESTFIELD("Customer Posting Group");
          CustPostingGr.GET("Customer Posting Group");
          ReminderLine.VALIDATE("No.",CustPostingGr.GetAdditionalFeeAccount);
          ReminderLine.Description :=
            COPYSTR(
              CaptionManagement.GetTranslatedFieldCaption(
                "Language Code",DATABASE::"Currency for Reminder Level",
                CurrencyForReminderLevel.FIELDNO("Additional Fee")),1,100);
          ReminderLine.VALIDATE(Amount,AdditionalFee);
          ReminderLine."Line Type" := ReminderLine."Line Type"::"Additional Fee";
          OnBeforeInsertReminderLine(ReminderLine);
          ReminderLine.INSERT;
          IF TransferExtendedText.ReminderCheckIfAnyExtText(ReminderLine,FALSE) THEN
            TransferExtendedText.InsertReminderExtText(ReminderLine);
        END;
      END;
      ReminderLine."Line No." := ReminderLine."Line No." + 10000;
      ReminderRounding(Rec);
      InsertBeginTexts(Rec);
      InsertEndTexts(Rec);
      MODIFY;
    END;

    PROCEDURE UpdateLines@13(ReminderHeader@1000 : Record 295;UpdateAdditionalFee@1001 : Boolean);
    BEGIN
      ReminderLine.RESET;
      ReminderLine.SETRANGE("Reminder No.",ReminderHeader."No.");
      ReminderLine.SETRANGE(
        "Line Type",
        ReminderLine."Line Type"::"Beginning Text",
        ReminderLine."Line Type"::"Ending Text");
      ReminderLine.SETRANGE(Type,ReminderLine.Type::" ");
      ReminderLine.SETRANGE("Attached to Line No.",0);
      ReminderLine.DELETEALL(TRUE);

      IF UpdateAdditionalFee THEN BEGIN
        ReminderLine.RESET;
        ReminderLine.SETRANGE("Reminder No.",ReminderHeader."No.");
        ReminderLine.SETRANGE("Line Type",ReminderLine."Line Type"::"Additional Fee");
        ReminderLine.DELETEALL;
        InsertLines;
      END ELSE BEGIN
        InsertBeginTexts(ReminderHeader);
        InsertEndTexts(ReminderHeader);
      END;
    END;

    LOCAL PROCEDURE InsertBeginTexts@11(ReminderHeader@1000 : Record 295);
    BEGIN
      ReminderLevel.SETRANGE("Reminder Terms Code",ReminderHeader."Reminder Terms Code");
      ReminderLevel.SETRANGE("No.",1,ReminderHeader."Reminder Level");
      IF ReminderLevel.FINDLAST THEN BEGIN
        ReminderText.RESET;
        ReminderText.SETRANGE("Reminder Terms Code",ReminderHeader."Reminder Terms Code");
        ReminderText.SETRANGE("Reminder Level",ReminderLevel."No.");
        ReminderText.SETRANGE(Position,ReminderText.Position::Beginning);

        ReminderLine.RESET;
        ReminderLine.SETRANGE("Reminder No.",ReminderHeader."No.");
        ReminderLine."Reminder No." := ReminderHeader."No.";
        IF ReminderLine.FIND('-') THEN BEGIN
          LineSpacing := ReminderLine."Line No." DIV (ReminderText.COUNT + 2);
          IF LineSpacing = 0 THEN
            ERROR(Text004);
        END ELSE
          LineSpacing := 10000;
        NextLineNo := 0;
        InsertTextLines(ReminderHeader);
      END;
    END;

    LOCAL PROCEDURE InsertEndTexts@12(ReminderHeader@1000 : Record 295);
    VAR
      ReminderLine2@1001 : Record 296;
    BEGIN
      ReminderLevel.SETRANGE("Reminder Terms Code",ReminderHeader."Reminder Terms Code");
      ReminderLevel.SETRANGE("No.",1,ReminderHeader."Reminder Level");
      IF ReminderLevel.FINDLAST THEN BEGIN
        ReminderText.SETRANGE(
          "Reminder Terms Code",ReminderHeader."Reminder Terms Code");
        ReminderText.SETRANGE("Reminder Level",ReminderLevel."No.");
        ReminderText.SETRANGE(Position,ReminderText.Position::Ending);
        ReminderLine.RESET;
        ReminderLine.SETRANGE("Reminder No.",ReminderHeader."No.");
        ReminderLine.SETFILTER(
          "Line Type",'%1|%2|%3',
          ReminderLine."Line Type"::"Reminder Line",
          ReminderLine."Line Type"::"Additional Fee",
          ReminderLine."Line Type"::Rounding);
        IF ReminderLine.FINDLAST THEN
          NextLineNo := ReminderLine."Line No."
        ELSE
          NextLineNo := 0;
        ReminderLine.SETRANGE("Line Type");
        ReminderLine2 := ReminderLine;
        ReminderLine2.COPYFILTERS(ReminderLine);
        ReminderLine2.SETFILTER("Line Type",'<>%1',ReminderLine2."Line Type"::"Line Fee");
        IF ReminderLine2.NEXT <> 0 THEN BEGIN
          LineSpacing :=
            (ReminderLine2."Line No." - ReminderLine."Line No.") DIV
            (ReminderText.COUNT + 2);
          IF LineSpacing = 0 THEN
            ERROR(Text004);
        END ELSE
          LineSpacing := 10000;
        InsertTextLines(ReminderHeader);
      END;
    END;

    LOCAL PROCEDURE InsertTextLines@4(ReminderHeader@1000 : Record 295);
    VAR
      CompanyInfo@1001 : Record 79;
    BEGIN
      IF ReminderText.FIND('-') THEN BEGIN
        IF ReminderText.Position = ReminderText.Position::Ending THEN
          InsertBlankLine(ReminderLine."Line Type"::"Ending Text");
        IF ReminderHeader."Fin. Charge Terms Code" <> '' THEN
          FinChrgTerms.GET(ReminderHeader."Fin. Charge Terms Code");
        IF NOT ReminderLevel."Calculate Interest" THEN
          FinChrgTerms."Interest Rate" := 0;
        ReminderHeader.CALCFIELDS(
          "Remaining Amount","Interest Amount","Additional Fee","VAT Amount","Add. Fee per Line");
        ReminderTotal :=
          ReminderHeader."Remaining Amount" + ReminderHeader."Interest Amount" +
          ReminderHeader."Additional Fee" + ReminderHeader."VAT Amount" +
          ReminderHeader."Add. Fee per Line";
        CompanyInfo.GET;

        REPEAT
          NextLineNo := NextLineNo + LineSpacing;
          ReminderLine.INIT;
          ReminderLine."Line No." := NextLineNo;
          ReminderLine.Type := ReminderLine.Type::" ";
          ReminderLine.Description :=
            COPYSTR(
              STRSUBSTNO(
                ReminderText.Text,
                ReminderHeader."Document Date",
                ReminderHeader."Due Date",
                FinChrgTerms."Interest Rate",
                FORMAT(ReminderHeader."Remaining Amount",0,
                  ApplicationManagement.AutoFormatTranslate(1,ReminderHeader."Currency Code")),
                ReminderHeader."Interest Amount",
                ReminderHeader."Additional Fee",
                FORMAT(ReminderTotal,0,ApplicationManagement.AutoFormatTranslate(1,ReminderHeader."Currency Code")),
                ReminderHeader."Reminder Level",
                ReminderHeader."Currency Code",
                ReminderHeader."Posting Date",
                CompanyInfo.Name,
                ReminderHeader."Add. Fee per Line"),
              1,
              MAXSTRLEN(ReminderLine.Description));
          IF ReminderText.Position = ReminderText.Position::Beginning THEN
            ReminderLine."Line Type" := ReminderLine."Line Type"::"Beginning Text"
          ELSE
            ReminderLine."Line Type" := ReminderLine."Line Type"::"Ending Text";
          ReminderLine.INSERT;
        UNTIL ReminderText.NEXT = 0;
        IF ReminderText.Position = ReminderText.Position::Beginning THEN
          InsertBlankLine(ReminderLine."Line Type"::"Beginning Text");
      END;
    END;

    LOCAL PROCEDURE InsertBlankLine@5(LineType@1000 : Integer);
    BEGIN
      NextLineNo := NextLineNo + LineSpacing;
      ReminderLine.INIT;
      ReminderLine."Line No." := NextLineNo;
      ReminderLine."Line Type" := LineType;
      ReminderLine.INSERT;
    END;

    [External]
    PROCEDURE PrintRecords@1();
    VAR
      ReminderHeader@1000 : Record 295;
      ReportSelection@1001 : Record 77;
    BEGIN
      WITH ReminderHeader DO BEGIN
        COPY(Rec);
        FINDFIRST;
        SETRECFILTER;
        ReportSelection.Print(ReportSelection.Usage::"Rem.Test",ReminderHeader,FIELDNO("Customer No."));
      END;
    END;

    [External]
    PROCEDURE ConfirmDeletion@2() : Boolean;
    BEGIN
      ReminderIssue.TestDeleteHeader(Rec,IssuedReminderHeader);
      IF IssuedReminderHeader."No." <> '' THEN
        IF NOT CONFIRM(
             Text005 +
             Text006 +
             Text003,TRUE,
             IssuedReminderHeader."No.")
        THEN
          EXIT;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateDim@16(Type1@1000 : Integer;No1@1001 : Code[20]);
    VAR
      SourceCodeSetup@1003 : Record 242;
      TableID@1004 : ARRAY [10] OF Integer;
      No@1005 : ARRAY [10] OF Code[20];
    BEGIN
      SourceCodeSetup.GET;
      TableID[1] := Type1;
      No[1] := No1;
      OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

      "Shortcut Dimension 1 Code" := '';
      "Shortcut Dimension 2 Code" := '';
      "Dimension Set ID" :=
        DimMgt.GetRecDefaultDimID(
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Reminder,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@19(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    LOCAL PROCEDURE ReminderRounding@7(ReminderHeader@1001 : Record 295);
    VAR
      TotalAmountInclVAT@1004 : Decimal;
      ReminderRoundingAmount@1000 : Decimal;
      Handled@1002 : Boolean;
    BEGIN
      OnBeforeReminderRounding(ReminderHeader,Handled);
      IF Handled THEN
        EXIT;

      GetCurrency(ReminderHeader);
      IF Currency."Invoice Rounding Precision" = 0 THEN
        EXIT;

      ReminderHeader.CALCFIELDS(
        "Remaining Amount","Interest Amount","Additional Fee","VAT Amount","Add. Fee per Line");

      TotalAmountInclVAT := ReminderHeader."Remaining Amount" +
        ReminderHeader."Interest Amount" +
        ReminderHeader."Additional Fee" +
        ReminderHeader."Add. Fee per Line" +
        ReminderHeader."VAT Amount";
      ReminderRoundingAmount :=
        -ROUND(
          TotalAmountInclVAT -
          ROUND(
            TotalAmountInclVAT,
            Currency."Invoice Rounding Precision",
            Currency.InvoiceRoundingDirection),
          Currency."Amount Rounding Precision");
      IF ReminderRoundingAmount <> 0 THEN BEGIN
        CustPostingGr.GET(ReminderHeader."Customer Posting Group");
        WITH ReminderLine DO BEGIN
          INIT;
          VALIDATE("Line No.",GetNextLineNo(ReminderHeader."No."));
          VALIDATE("Reminder No.",ReminderHeader."No.");
          VALIDATE(Type,Type::"G/L Account");
          "System-Created Entry" := TRUE;
          VALIDATE("No.",CustPostingGr.GetInvRoundingAccount);
          VALIDATE(
            Amount,
            ROUND(
              ReminderRoundingAmount / (1 + ("VAT %" / 100)),
              Currency."Amount Rounding Precision"));
          "VAT Amount" := ReminderRoundingAmount - Amount;
          "Line Type" := "Line Type"::Rounding;
          INSERT;
        END;
      END;
    END;

    LOCAL PROCEDURE GetCurrency@17(ReminderHeader@1000 : Record 295);
    BEGIN
      WITH ReminderHeader DO
        IF "Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          Currency.GET("Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
    END;

    [External]
    PROCEDURE UpdateReminderRounding@8(ReminderHeader@1000 : Record 295);
    VAR
      OldLineNo@1001 : Integer;
    BEGIN
      ReminderLine.RESET;
      ReminderLine.SETRANGE("Reminder No.",ReminderHeader."No.");
      ReminderLine.SETRANGE("Line Type",ReminderLine."Line Type"::Rounding);
      IF ReminderLine.FINDFIRST THEN
        ReminderLine.DELETE(TRUE);

      ReminderLine.SETRANGE("Line Type");
      ReminderLine.SETFILTER(Type,'<>%1',ReminderLine.Type::" ");
      IF ReminderLine.FINDLAST THEN BEGIN
        OldLineNo := ReminderLine."Line No.";
        ReminderLine.SETRANGE(Type);
        IF ReminderLine.NEXT <> 0 THEN
          ReminderLine."Line No." := OldLineNo + ((ReminderLine."Line No." - OldLineNo) DIV 2)
        ELSE
          ReminderLine."Line No." := OldLineNo + 10000;
      END ELSE
        ReminderLine."Line No." := 10000;

      ReminderRounding(ReminderHeader);
    END;

    [External]
    PROCEDURE ShowDocDim@10();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE CalculateLineFeeVATAmount@1000() : Decimal;
    VAR
      ReminderLine@1000 : Record 296;
    BEGIN
      ReminderLine.SETCURRENTKEY("Reminder No.",Type,"Line Type");
      ReminderLine.SETRANGE("Reminder No.","No.");
      ReminderLine.SETRANGE(Type,ReminderLine.Type::"Line Fee");
      ReminderLine.CALCSUMS("VAT Amount");
      EXIT(ReminderLine."VAT Amount");
    END;

    LOCAL PROCEDURE GetNextLineNo@1010(ReminderNo@1000 : Code[20]) : Integer;
    VAR
      ReminderLine@1001 : Record 296;
    BEGIN
      ReminderLine.SETRANGE("Reminder No.",ReminderNo);
      IF ReminderLine.FINDLAST THEN
        EXIT(ReminderLine."Line No." + 10000);
      EXIT(10000);
    END;

    LOCAL PROCEDURE GetFilterCustNo@64() : Code[20];
    BEGIN
      IF GETFILTER("Customer No.") <> '' THEN
        IF GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") THEN
          EXIT(GETRANGEMAX("Customer No."));
    END;

    [External]
    PROCEDURE SetCustomerFromFilter@186();
    BEGIN
      IF GetFilterCustNo <> '' THEN
        VALIDATE("Customer No.",GetFilterCustNo);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@164(VAR ReminderHeader@1000 : Record 295;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertReminderLine@165(VAR ReminderLine@1000 : Record 296);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeReminderRounding@14(VAR ReminderHeader@1000 : Record 295;VAR Handled@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

