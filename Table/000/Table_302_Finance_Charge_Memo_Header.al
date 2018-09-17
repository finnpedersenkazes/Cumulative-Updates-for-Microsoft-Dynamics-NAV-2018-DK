OBJECT Table 302 Finance Charge Memo Header
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
                 SalesSetup.TESTFIELD("Fin. Chrg. Memo Nos.");
                 SalesSetup.TESTFIELD("Issued Fin. Chrg. M. Nos.");
                 NoSeriesMgt.InitSeries(
                   SalesSetup."Fin. Chrg. Memo Nos.",xRec."No. Series","Posting Date",
                   "No.","No. Series");
               END;
               "Posting Description" := STRSUBSTNO(Text000,"No.");
               IF ("No. Series" <> '') AND
                  (SalesSetup."Fin. Chrg. Memo Nos." = SalesSetup."Issued Fin. Chrg. M. Nos.")
               THEN
                 "Issuing No. Series" := "No. Series"
               ELSE
                 NoSeriesMgt.SetDefaultSeries("Issuing No. Series",SalesSetup."Issued Fin. Chrg. M. Nos.");
               IF "Posting Date" = 0D THEN
                 "Posting Date" := WORKDATE;
               "Document Date" := WORKDATE;
               "Due Date" := WORKDATE;
               IF GETFILTER("Customer No.") <> '' THEN
                 IF GETRANGEMIN("Customer No.") = GETRANGEMAX("Customer No.") THEN
                   VALIDATE("Customer No.",GETRANGEMIN("Customer No."));
             END;

    OnDelete=BEGIN
               FinChrgMemoIssue.DeleteHeader(Rec,IssuedFinChrgMemoHdr);

               FinChrgMemoLine.SETRANGE("Finance Charge Memo No.","No.");
               FinChrgMemoLine.DELETEALL;

               FinChrgMemoCommentLine.SETRANGE(Type,FinChrgMemoCommentLine.Type::"Finance Charge Memo");
               FinChrgMemoCommentLine.SETRANGE("No.","No.");
               FinChrgMemoCommentLine.DELETEALL;

               IF IssuedFinChrgMemoHdr."No." <> '' THEN BEGIN
                 COMMIT;
                 IF CONFIRM(
                      Text001,TRUE,
                      IssuedFinChrgMemoHdr."No.")
                 THEN BEGIN
                   IssuedFinChrgMemoHdr.SETRECFILTER;
                   IssuedFinChrgMemoHdr.PrintRecords(TRUE,FALSE,FALSE)
                 END;
               END;
             END;

    CaptionML=[DAN=Rentenotahoved;
               ENU=Finance Charge Memo Header];
    LookupPageID=Page448;
    DrillDownPageID=Page448;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  SalesSetup.GET;
                                                                  NoSeriesMgt.TestManual(SalesSetup."Fin. Chrg. Memo Nos.");
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
                                                                    EXIT;
                                                                  END;
                                                                IF "Customer No." = '' THEN
                                                                  EXIT;
                                                                Cust.GET("Customer No.");
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
                                                                VALIDATE("Fin. Charge Terms Code",Cust."Fin. Charge Terms Code");
                                                                "Account Code" := Cust."Account Code";
                                                                "EAN No." := Cust.GLN;
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
    { 14  ;   ;Your Reference      ;Text35        ;CaptionML=[DAN=Reference;
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
                                                                VALIDATE("Fin. Charge Terms Code");
                                                              END;

                                                   CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 23  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 25  ;   ;Fin. Charge Terms Code;Code10      ;TableRelation="Finance Charge Terms";
                                                   OnValidate=BEGIN
                                                                IF CurrFieldNo = FIELDNO("Fin. Charge Terms Code") THEN
                                                                  IF Undo THEN BEGIN
                                                                    "Fin. Charge Terms Code" := xRec."Fin. Charge Terms Code";
                                                                    EXIT;
                                                                  END;
                                                                IF "Fin. Charge Terms Code" <> '' THEN BEGIN
                                                                  FinChrgTerms.GET("Fin. Charge Terms Code");
                                                                  "Post Interest" := FinChrgTerms."Post Interest";
                                                                  "Post Additional Fee" := FinChrgTerms."Post Additional Fee";
                                                                  IF "Document Date" <> 0D THEN
                                                                    "Due Date" := CALCDATE(FinChrgTerms."Due Date Calculation","Document Date");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Rentebetingelseskode;
                                                              ENU=Fin. Charge Terms Code] }
    { 26  ;   ;Post Interest       ;Boolean       ;CaptionML=[DAN=Bogf�r rente;
                                                              ENU=Post Interest] }
    { 27  ;   ;Post Additional Fee ;Boolean       ;CaptionML=[DAN=Bogf�r opkr�vningsgebyr;
                                                              ENU=Post Additional Fee] }
    { 29  ;   ;Posting Description ;Text50        ;CaptionML=[DAN=Bogf�ringsbeskrivelse;
                                                              ENU=Posting Description] }
    { 30  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Fin. Charge Comment Line" WHERE (Type=CONST(Finance Charge Memo),
                                                                                                       No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 31  ;   ;Remaining Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Finance Charge Memo Line"."Remaining Amount" WHERE (Finance Charge Memo No.=FIELD(No.)));
                                                   CaptionML=[DAN=Restbel�b;
                                                              ENU=Remaining Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 32  ;   ;Interest Amount     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Finance Charge Memo Line".Amount WHERE (Finance Charge Memo No.=FIELD(No.),
                                                                                                            Type=CONST(Customer Ledger Entry)));
                                                   CaptionML=[DAN=Rentebel�b;
                                                              ENU=Interest Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 33  ;   ;Additional Fee      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Finance Charge Memo Line".Amount WHERE (Finance Charge Memo No.=FIELD(No.),
                                                                                                            Type=CONST(G/L Account)));
                                                   CaptionML=[DAN=Opkr�vningsgebyr;
                                                              ENU=Additional Fee];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 34  ;   ;VAT Amount          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Finance Charge Memo Line"."VAT Amount" WHERE (Finance Charge Memo No.=FIELD(No.)));
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
                                                                  SalesSetup.TESTFIELD("Fin. Chrg. Memo Nos.");
                                                                  SalesSetup.TESTFIELD("Issued Fin. Chrg. M. Nos.");
                                                                  NoSeriesMgt.TestSeries(SalesSetup."Issued Fin. Chrg. M. Nos.","Issuing No. Series");
                                                                END;
                                                                TESTFIELD("Issuing No.",'');
                                                              END;

                                                   OnLookup=BEGIN
                                                              WITH FinChrgMemoHeader DO BEGIN
                                                                FinChrgMemoHeader := Rec;
                                                                SalesSetup.GET;
                                                                SalesSetup.TESTFIELD("Fin. Chrg. Memo Nos.");
                                                                SalesSetup.TESTFIELD("Issued Fin. Chrg. M. Nos.");
                                                                IF NoSeriesMgt.LookupSeries(SalesSetup."Issued Fin. Chrg. M. Nos.","Issuing No. Series") THEN
                                                                  VALIDATE("Issuing No. Series");
                                                                Rec := FinChrgMemoHeader;
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
                                                                FinChrgMemoLine.RESET;
                                                                FinChrgMemoLine.SETRANGE("Finance Charge Memo No.","No.");
                                                                FinChrgMemoLine.SETFILTER(Type, '>%1', FinChrgMemoLine.Type::" ");
                                                                FinChrgMemoLine.SETFILTER("Account Code", '%1|%2', xRec."Account Code", '');
                                                                FinChrgMemoLine.MODIFYALL("Account Code", "Account Code");
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
      Text000@1000 : TextConst 'DAN=Rentenota %1;ENU=Finance Charge Memo %1';
      Text001@1001 : TextConst 'DAN=�nsker du at udskrive rentenota %1?;ENU=Do you want to print finance charge memo %1?';
      Text002@1002 : TextConst 'DAN=�ndringen sletter linjerne i denne rentenota.\\;ENU=This change will cause the existing lines to be deleted for this finance charge memo.\\';
      Text003@1003 : TextConst 'DAN=Vil du forts�tte?;ENU=Do you want to continue?';
      Text004@1004 : TextConst 'DAN=Der er ikke plads til at inds�tte teksten.;ENU=There is not enough space to insert the text.';
      Text005@1005 : TextConst 'DAN=Hvis du sletter dette dokument, opst�r der et hul i nummerserien for rentenotaer.;ENU=Deleting this document will cause a gap in the number series for finance charge memos.';
      Text006@1006 : TextConst 'DAN=For at udfylde dette hul i nummerserien vil der blive dannet en blank rentenota %1.\\;ENU=An empty finance charge memo %1 will be created to fill this gap in the number series.\\';
      Text13606@1101100001 : TextConst 'DAN=indeholder ikke et gyldigt 13-cifret EAN-nr.;ENU=does not contain a valid, 13-digit EAN No.';
      Text13607@1101100002 : TextConst 'DAN=%1 %2 underst�ttes ikke i denne version af OIOUBL.;ENU=%1 %2 is not supported in this version of OIOUBL.';
      Currency@1029 : Record 4;
      SalesSetup@1007 : Record 311;
      CustPostingGr@1008 : Record 92;
      FinChrgTerms@1009 : Record 5;
      CurrForFinChrgTerms@1010 : Record 328;
      FinChrgText@1011 : Record 301;
      FinChrgMemoHeader@1012 : Record 302;
      FinChrgMemoLine@1013 : Record 303;
      FinChrgMemoCommentLine@1014 : Record 306;
      Cust@1015 : Record 18;
      PostCode@1016 : Record 225;
      IssuedFinChrgMemoHdr@1017 : Record 304;
      GenBusPostingGrp@1018 : Record 250;
      CurrExchRate@1019 : Record 330;
      OIOUBLDocumentEncode@1101100000 : Codeunit 13600;
      ApplicationManagement@1028 : Codeunit 1;
      NoSeriesMgt@1020 : Codeunit 396;
      TransferExtendedText@1021 : Codeunit 378;
      FinChrgMemoIssue@1022 : Codeunit 395;
      DimMgt@1023 : Codeunit 408;
      NextLineNo@1024 : Integer;
      LineSpacing@1025 : Integer;
      FinChrgMemoTotal@1026 : Decimal;
      OK@1027 : Boolean;

    [External]
    PROCEDURE AssistEdit@5(OldFinChrgMemoHeader@1000 : Record 302) : Boolean;
    BEGIN
      WITH FinChrgMemoHeader DO BEGIN
        FinChrgMemoHeader := Rec;
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Fin. Chrg. Memo Nos.");
        SalesSetup.TESTFIELD("Issued Fin. Chrg. M. Nos.");
        IF NoSeriesMgt.SelectSeries(SalesSetup."Fin. Chrg. Memo Nos.",OldFinChrgMemoHeader."No. Series","No. Series") THEN BEGIN
          SalesSetup.GET;
          SalesSetup.TESTFIELD("Fin. Chrg. Memo Nos.");
          SalesSetup.TESTFIELD("Issued Fin. Chrg. M. Nos.");
          NoSeriesMgt.SetSeries("No.");
          Rec := FinChrgMemoHeader;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE Undo@6() : Boolean;
    BEGIN
      FinChrgMemoLine.SETRANGE("Finance Charge Memo No.","No.");
      IF FinChrgMemoLine.FIND('-') THEN BEGIN
        COMMIT;
        IF NOT
           CONFIRM(
             Text002 +
             Text003,
             FALSE)
        THEN
          EXIT(TRUE);
        FinChrgMemoLine.DELETEALL;
        MODIFY;
      END;
    END;

    [Internal]
    PROCEDURE InsertLines@3();
    VAR
      CaptionManagement@1000 : Codeunit 42;
    BEGIN
      TESTFIELD("Fin. Charge Terms Code");
      FinChrgTerms.GET("Fin. Charge Terms Code");
      FinChrgMemoLine.RESET;
      FinChrgMemoLine.SETRANGE("Finance Charge Memo No.","No.");
      FinChrgMemoLine."Finance Charge Memo No." := "No.";
      IF FinChrgMemoLine.FIND('+') THEN
        NextLineNo := FinChrgMemoLine."Line No."
      ELSE
        NextLineNo := 0;
      IF (FinChrgMemoLine.Type <> FinChrgMemoLine.Type::" ") OR
         (FinChrgMemoLine.Description <> '')
      THEN BEGIN
        LineSpacing := 10000;
        InsertBlankLine(FinChrgMemoLine."Line Type"::"Finance Charge Memo Line");
      END;
      IF FinChrgTerms."Additional Fee (LCY)" <> 0 THEN BEGIN
        NextLineNo := NextLineNo + 10000;
        FinChrgMemoLine.INIT;
        FinChrgMemoLine."Account Code" := "Account Code";
        FinChrgMemoLine."Line No." := NextLineNo;
        FinChrgMemoLine.Type := FinChrgMemoLine.Type::"G/L Account";
        TESTFIELD("Customer Posting Group");
        CustPostingGr.GET("Customer Posting Group");
        FinChrgMemoLine.VALIDATE("No.",CustPostingGr.GetAdditionalFeeAccount);
        FinChrgMemoLine.Description :=
          COPYSTR(
            CaptionManagement.GetTranslatedFieldCaption(
              "Language Code",DATABASE::"Currency for Fin. Charge Terms",
              CurrForFinChrgTerms.FIELDNO("Additional Fee")),1,100);
        IF "Currency Code" = '' THEN
          FinChrgMemoLine.VALIDATE(Amount,FinChrgTerms."Additional Fee (LCY)")
        ELSE BEGIN
          IF NOT CurrForFinChrgTerms.GET("Fin. Charge Terms Code","Currency Code") THEN
            CurrForFinChrgTerms."Additional Fee" :=
              CurrExchRate.ExchangeAmtLCYToFCY(
                "Posting Date","Currency Code",
                FinChrgTerms."Additional Fee (LCY)",CurrExchRate.ExchangeRate(
                  "Posting Date","Currency Code"));
          FinChrgMemoLine.VALIDATE(Amount,CurrForFinChrgTerms."Additional Fee");
        END;
        OnBeforeInsertFinChrgMemoLine(FinChrgMemoLine);
        FinChrgMemoLine.INSERT;
        IF TransferExtendedText.FinChrgMemoCheckIfAnyExtText(FinChrgMemoLine,FALSE) THEN
          TransferExtendedText.InsertFinChrgMemoExtText(FinChrgMemoLine);
      END;
      FinChrgMemoLine."Line No." := FinChrgMemoLine."Line No." + 10000;
      FinanceChargeRounding(Rec);
      InsertBeginTexts(Rec);
      InsertEndTexts(Rec);
      MODIFY;
    END;

    [External]
    PROCEDURE UpdateLines@8(FinChrgMemoHeader2@1000 : Record 302);
    BEGIN
      FinChrgMemoLine.RESET;
      FinChrgMemoLine.SETRANGE("Finance Charge Memo No.",FinChrgMemoHeader2."No.");
      OK := FinChrgMemoLine.FIND('-');
      WHILE OK DO BEGIN
        OK :=
          (FinChrgMemoLine.Type = FinChrgMemoLine.Type::" ") AND
          (FinChrgMemoLine."Attached to Line No." = 0);
        IF OK THEN BEGIN
          FinChrgMemoLine.DELETE(TRUE);
          OK := FinChrgMemoLine.NEXT <> 0;
        END;
      END;
      OK := FinChrgMemoLine.FIND('+');
      WHILE OK DO BEGIN
        OK :=
          (FinChrgMemoLine.Type = FinChrgMemoLine.Type::" ") AND
          (FinChrgMemoLine."Attached to Line No." = 0);
        IF OK THEN BEGIN
          FinChrgMemoLine.DELETE(TRUE);
          OK := FinChrgMemoLine.NEXT(-1) <> 0;
        END;
      END;
      FinChrgMemoLine.SETRANGE("Line Type",FinChrgMemoLine."Line Type"::Rounding);
      IF FinChrgMemoLine.FINDFIRST THEN
        FinChrgMemoLine.DELETE(TRUE);

      FinChrgMemoLine.SETRANGE("Line Type");
      FinChrgMemoLine.FINDLAST;
      FinChrgMemoLine."Line No." := FinChrgMemoLine."Line No." + 10000;
      FinanceChargeRounding(FinChrgMemoHeader2);

      InsertBeginTexts(FinChrgMemoHeader2);
      InsertEndTexts(FinChrgMemoHeader2);
    END;

    LOCAL PROCEDURE InsertBeginTexts@11(FinChrgMemoHeader2@1000 : Record 302);
    BEGIN
      FinChrgText.RESET;
      FinChrgText.SETRANGE("Fin. Charge Terms Code",FinChrgMemoHeader2."Fin. Charge Terms Code");
      FinChrgText.SETRANGE(Position,FinChrgText.Position::Beginning);

      FinChrgMemoLine.RESET;
      FinChrgMemoLine.SETRANGE("Finance Charge Memo No.",FinChrgMemoHeader2."No.");
      FinChrgMemoLine."Finance Charge Memo No." := FinChrgMemoHeader2."No.";
      IF FinChrgMemoLine.FIND('-') THEN BEGIN
        LineSpacing := FinChrgMemoLine."Line No." DIV (FinChrgText.COUNT + 2);
        IF LineSpacing = 0 THEN
          ERROR(Text004);
      END ELSE
        LineSpacing := 10000;
      NextLineNo := 0;
      InsertTextLines(FinChrgMemoHeader2);
    END;

    LOCAL PROCEDURE InsertEndTexts@12(FinChrgMemoHeader2@1000 : Record 302);
    BEGIN
      FinChrgText.RESET;
      FinChrgText.SETRANGE("Fin. Charge Terms Code",FinChrgMemoHeader2."Fin. Charge Terms Code");
      FinChrgText.SETRANGE(Position,FinChrgText.Position::Ending);

      FinChrgMemoLine.RESET;
      FinChrgMemoLine.SETRANGE("Finance Charge Memo No.",FinChrgMemoHeader2."No.");
      FinChrgMemoLine."Finance Charge Memo No." := FinChrgMemoHeader2."No.";
      IF FinChrgMemoLine.FIND('+') THEN
        NextLineNo := FinChrgMemoLine."Line No."
      ELSE BEGIN
        FinChrgMemoLine.SETFILTER("Line Type",'%1|%2',
          FinChrgMemoLine."Line Type"::"Finance Charge Memo Line",
          FinChrgMemoLine."Line Type"::Rounding);
        IF FinChrgMemoLine.FIND('+') THEN
          NextLineNo := FinChrgMemoLine."Line No."
        ELSE
          NextLineNo := 0;
      END;
      FinChrgMemoLine.SETRANGE("Line Type");
      LineSpacing := 10000;
      InsertTextLines(FinChrgMemoHeader2);
    END;

    LOCAL PROCEDURE InsertTextLines@4(FinChrgMemoHeader2@1000 : Record 302);
    BEGIN
      IF FinChrgText.FIND('-') THEN BEGIN
        IF FinChrgText.Position = FinChrgText.Position::Ending THEN
          InsertBlankLine(FinChrgMemoLine."Line Type"::"Ending Text");
        IF NOT FinChrgTerms.GET(FinChrgMemoHeader2."Fin. Charge Terms Code") THEN
          FinChrgTerms.INIT;

        FinChrgMemoHeader2.CALCFIELDS(
          "Remaining Amount","Interest Amount","Additional Fee","VAT Amount");
        FinChrgMemoTotal :=
          FinChrgMemoHeader2."Remaining Amount" + FinChrgMemoHeader2."Interest Amount" +
          FinChrgMemoHeader2."Additional Fee" + FinChrgMemoHeader2."VAT Amount";

        REPEAT
          NextLineNo := NextLineNo + LineSpacing;
          FinChrgMemoLine.INIT;
          FinChrgMemoLine."Line No." := NextLineNo;
          FinChrgMemoLine.Description :=
            COPYSTR(
              STRSUBSTNO(
                FinChrgText.Text,
                FinChrgMemoHeader2."Document Date",
                FinChrgMemoHeader2."Due Date",
                FinChrgTerms."Interest Rate",
                FinChrgMemoHeader2."Remaining Amount",
                FinChrgMemoHeader2."Interest Amount",
                FinChrgMemoHeader2."Additional Fee",
                FORMAT(FinChrgMemoTotal,0,ApplicationManagement.AutoFormatTranslate(1,FinChrgMemoHeader."Currency Code")),
                FinChrgMemoHeader2."Currency Code",
                FinChrgMemoHeader2."Posting Date"),
              1,MAXSTRLEN(FinChrgMemoLine.Description));
          IF FinChrgText.Position = FinChrgText.Position::Beginning THEN
            FinChrgMemoLine."Line Type" := FinChrgMemoLine."Line Type"::"Beginning Text"
          ELSE
            FinChrgMemoLine."Line Type" := FinChrgMemoLine."Line Type"::"Ending Text";
          FinChrgMemoLine.INSERT;
        UNTIL FinChrgText.NEXT = 0;
        IF FinChrgText.Position = FinChrgText.Position::Beginning THEN
          InsertBlankLine(FinChrgMemoLine."Line Type"::"Beginning Text");
      END;
    END;

    LOCAL PROCEDURE InsertBlankLine@9(LineType@1000 : Integer);
    BEGIN
      NextLineNo := NextLineNo + LineSpacing;
      FinChrgMemoLine.INIT;
      FinChrgMemoLine."Line No." := NextLineNo;
      FinChrgMemoLine."Line Type" := LineType;
      FinChrgMemoLine.INSERT;
    END;

    [External]
    PROCEDURE PrintRecords@1();
    VAR
      FinChrgMemoHeader@1000 : Record 302;
      ReportSelection@1001 : Record 77;
    BEGIN
      WITH FinChrgMemoHeader DO BEGIN
        COPY(Rec);
        ReportSelection.Print(ReportSelection.Usage::"F.C.Test",FinChrgMemoHeader,FIELDNO("Customer No."));
      END;
    END;

    [External]
    PROCEDURE ConfirmDeletion@2() : Boolean;
    BEGIN
      FinChrgMemoIssue.TestDeleteHeader(Rec,IssuedFinChrgMemoHdr);
      IF IssuedFinChrgMemoHdr."No." <> '' THEN
        IF NOT CONFIRM(
             Text005 +
             Text006 +
             Text003,TRUE,
             IssuedFinChrgMemoHdr."No.")
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
          Rec,CurrFieldNo,TableID,No,SourceCodeSetup."Finance Charge Memo",
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);

      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@19(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    END;

    LOCAL PROCEDURE FinanceChargeRounding@10(FinanceChargeHeader@1001 : Record 302);
    VAR
      TotalAmountInclVAT@1004 : Decimal;
      FinanceChargeRoundingAmount@1000 : Decimal;
    BEGIN
      GetCurrency(FinanceChargeHeader);
      IF Currency."Invoice Rounding Precision" = 0 THEN
        EXIT;

      FinanceChargeHeader.CALCFIELDS(
        "Interest Amount","Additional Fee","VAT Amount");

      TotalAmountInclVAT := FinanceChargeHeader."Interest Amount" +
        FinanceChargeHeader."Additional Fee" +
        FinanceChargeHeader."VAT Amount";
      FinanceChargeRoundingAmount :=
        -ROUND(
          TotalAmountInclVAT -
          ROUND(
            TotalAmountInclVAT,
            Currency."Invoice Rounding Precision",
            Currency.InvoiceRoundingDirection),
          Currency."Amount Rounding Precision");
      IF FinanceChargeRoundingAmount <> 0 THEN BEGIN
        CustPostingGr.GET(FinanceChargeHeader."Customer Posting Group");
        WITH FinChrgMemoLine DO BEGIN
          INIT;
          VALIDATE(Type,Type::"G/L Account");
          "System-Created Entry" := TRUE;
          VALIDATE("No.",CustPostingGr.GetInvRoundingAccount);
          VALIDATE(
            Amount,
            ROUND(
              FinanceChargeRoundingAmount / (1 + ("VAT %" / 100)),
              Currency."Amount Rounding Precision"));
          "VAT Amount" := FinanceChargeRoundingAmount - Amount;
          "Line Type" := "Line Type"::Rounding;
          INSERT;
        END;
      END;
    END;

    LOCAL PROCEDURE GetCurrency@17(FinanceChargeHeader@1001 : Record 302);
    BEGIN
      WITH FinanceChargeHeader DO
        IF "Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          Currency.GET("Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
    END;

    [External]
    PROCEDURE UpdateFinanceChargeRounding@7(FinanceChargeHeader@1000 : Record 302);
    VAR
      OldLineNo@1001 : Integer;
    BEGIN
      FinChrgMemoLine.RESET;
      FinChrgMemoLine.SETRANGE("Finance Charge Memo No.",FinanceChargeHeader."No.");
      FinChrgMemoLine.SETRANGE("Line Type",FinChrgMemoLine."Line Type"::Rounding);
      IF FinChrgMemoLine.FINDFIRST THEN
        FinChrgMemoLine.DELETE(TRUE);

      FinChrgMemoLine.SETRANGE("Line Type");
      FinChrgMemoLine.SETFILTER(Type,'<>%1',FinChrgMemoLine.Type::" ");
      IF FinChrgMemoLine.FINDLAST THEN BEGIN
        OldLineNo := FinChrgMemoLine."Line No.";
        FinChrgMemoLine.SETRANGE(Type);
        IF FinChrgMemoLine.NEXT <> 0 THEN
          FinChrgMemoLine."Line No." := OldLineNo + ((FinChrgMemoLine."Line No." - OldLineNo) / 2)
        ELSE
          FinChrgMemoLine."Line No." := FinChrgMemoLine."Line No." + 10000;
      END ELSE
        FinChrgMemoLine."Line No." := 10000;

      FinanceChargeRounding(FinanceChargeHeader);
    END;

    [External]
    PROCEDURE ShowDocDim@13();
    BEGIN
      "Dimension Set ID" :=
        DimMgt.EditDimensionSet2(
          "Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."),
          "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");

      DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
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
    LOCAL PROCEDURE OnAfterCreateDimTableIDs@164(VAR FinanceChargeMemoHeader@1000 : Record 302;FieldNo@1001 : Integer;TableID@1003 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertFinChrgMemoLine@165(VAR FinChrgMemoLine@1000 : Record 303);
    BEGIN
    END;

    BEGIN
    END.
  }
}

