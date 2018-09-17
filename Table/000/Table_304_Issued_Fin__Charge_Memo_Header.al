OBJECT Table 304 Issued Fin. Charge Memo Header
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
    OnDelete=BEGIN
               TESTFIELD("No. Printed");
               LOCKTABLE;
               FinChrgMemoIssue.DeleteIssuedFinChrgLines(Rec);

               FinChrgCommentLine.SETRANGE(Type,FinChrgCommentLine.Type::"Issued Finance Charge Memo");
               FinChrgCommentLine.SETRANGE("No.","No.");
               FinChrgCommentLine.DELETEALL;
             END;

    CaptionML=[DAN=Udstedt rentenotahoved;
               ENU=Issued Fin. Charge Memo Header];
    LookupPageID=Page452;
    DrillDownPageID=Page452;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   NotBlank=Yes }
    { 2   ;   ;Customer No.        ;Code20        ;TableRelation=Customer;
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
    { 7   ;   ;Post Code           ;Code20        ;TableRelation="Post Code";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 8   ;   ;City                ;Text30        ;TableRelation="Post Code".City;
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City] }
    { 9   ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 10  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr†dekode;
                                                              ENU=Country/Region Code] }
    { 11  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 12  ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 13  ;   ;Contact             ;Text50        ;CaptionML=[DAN=Kontakt;
                                                              ENU=Contact] }
    { 14  ;   ;Your Reference      ;Text35        ;CaptionML=[DAN=Reference;
                                                              ENU=Your Reference] }
    { 15  ;   ;Shortcut Dimension 1 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Genvejsdimension 1-kode;
                                                              ENU=Shortcut Dimension 1 Code];
                                                   CaptionClass='1,2,1' }
    { 16  ;   ;Shortcut Dimension 2 Code;Code20   ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Genvejsdimension 2-kode;
                                                              ENU=Shortcut Dimension 2 Code];
                                                   CaptionClass='1,2,2' }
    { 17  ;   ;Customer Posting Group;Code20      ;TableRelation="Customer Posting Group";
                                                   CaptionML=[DAN=Debitorbogf›ringsgruppe;
                                                              ENU=Customer Posting Group] }
    { 18  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf›ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 19  ;   ;VAT Registration No.;Text20        ;CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
    { 20  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=rsagskode;
                                                              ENU=Reason Code] }
    { 21  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date] }
    { 22  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date] }
    { 23  ;   ;Due Date            ;Date          ;CaptionML=[DAN=Forfaldsdato;
                                                              ENU=Due Date] }
    { 25  ;   ;Fin. Charge Terms Code;Code10      ;TableRelation="Finance Charge Terms";
                                                   CaptionML=[DAN=Rentebetingelseskode;
                                                              ENU=Fin. Charge Terms Code] }
    { 26  ;   ;Interest Posted     ;Boolean       ;CaptionML=[DAN=Rente bogf›rt;
                                                              ENU=Interest Posted] }
    { 27  ;   ;Additional Fee Posted;Boolean      ;CaptionML=[DAN=Opkr‘vningsgebyr bogf›rt;
                                                              ENU=Additional Fee Posted] }
    { 29  ;   ;Posting Description ;Text50        ;CaptionML=[DAN=Bogf›ringsbeskrivelse;
                                                              ENU=Posting Description] }
    { 30  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Fin. Charge Comment Line" WHERE (Type=CONST(Issued Finance Charge Memo),
                                                                                                       No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 31  ;   ;Remaining Amount    ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Issued Fin. Charge Memo Line"."Remaining Amount" WHERE (Finance Charge Memo No.=FIELD(No.)));
                                                   CaptionML=[DAN=Restbel›b;
                                                              ENU=Remaining Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 32  ;   ;Interest Amount     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Issued Fin. Charge Memo Line".Amount WHERE (Finance Charge Memo No.=FIELD(No.),
                                                                                                                Type=CONST(Customer Ledger Entry)));
                                                   CaptionML=[DAN=Rentebel›b;
                                                              ENU=Interest Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 33  ;   ;Additional Fee      ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Issued Fin. Charge Memo Line".Amount WHERE (Finance Charge Memo No.=FIELD(No.),
                                                                                                                Type=CONST(G/L Account)));
                                                   CaptionML=[DAN=Opkr‘vningsgebyr;
                                                              ENU=Additional Fee];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 34  ;   ;VAT Amount          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Issued Fin. Charge Memo Line"."VAT Amount" WHERE (Finance Charge Memo No.=FIELD(No.)));
                                                   CaptionML=[DAN=Momsbel›b;
                                                              ENU=VAT Amount];
                                                   Editable=No;
                                                   AutoFormatType=1;
                                                   AutoFormatExpr="Currency Code" }
    { 35  ;   ;No. Printed         ;Integer       ;CaptionML=[DAN=Udskrevet;
                                                              ENU=No. Printed] }
    { 36  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 37  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 38  ;   ;Pre-Assigned No. Series;Code20     ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Forh†ndstildelt nr.serie;
                                                              ENU=Pre-Assigned No. Series] }
    { 39  ;   ;Pre-Assigned No.    ;Code20        ;CaptionML=[DAN=Forh†ndstildelt nr.;
                                                              ENU=Pre-Assigned No.] }
    { 40  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 41  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=Skatteomr†dekode;
                                                              ENU=Tax Area Code] }
    { 42  ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 43  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 13600;  ;EAN No.             ;Code13        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=EAN-nr.;
                                                              ENU=EAN No.] }
    { 13601;  ;Elec. Fin. Charge Memo Created;Boolean;
                                                   ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Elektronisk rentenota er oprettet;
                                                              ENU=Elec. Fin. Charge Memo Created];
                                                   Editable=No }
    { 13602;  ;Account Code        ;Text30        ;ObsoleteState=Pending;
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
                                                   OptionCaptionML=[DAN=" ,,,Indk›bsansvarlig,,,Bogholder,,,Budgetansvarlig,,,Indk›ber";
                                                                    ENU=" ,,,Purchase Responsible,,,Accountant,,,Budget Responsible,,,Requisitioner"];
                                                   OptionString=[ ,,,Purchase Responsible,,,Accountant,,,Budget Responsible,,,Requisitioner] }
    { 13620;  ;Payment Channel     ;Option        ;ObsoleteState=Pending;
                                                   ObsoleteReason=Moved to extension.;
                                                   CaptionML=[DAN=Betalingskanal;
                                                              ENU=Payment Channel];
                                                   OptionCaptionML=[DAN=" ,Betalingsbon,Kontooverf›rsel,National transaktion,Direct Debit";
                                                                    ENU=" ,Payment Slip,Account Transfer,National Clearing,Direct Debit"];
                                                   OptionString=[ ,Payment Slip,Account Transfer,National Clearing,Direct Debit] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Customer No.,Posting Date                }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,Customer No.,Name,Posting Date       }
  }
  CODE
  {
    VAR
      FinChrgCommentLine@1001 : Record 306;
      FinChrgMemoIssue@1002 : Codeunit 395;
      DimMgt@1003 : Codeunit 408;
      FinanceChargeTxt@1004 : TextConst 'DAN=Udstedt rentenota;ENU=Issued Finance Charge Memo';

    [Internal]
    PROCEDURE PrintRecords@1(ShowRequestForm@1000 : Boolean;SendAsEmail@1002 : Boolean;HideDialog@1003 : Boolean);
    VAR
      DummyReportSelections@1001 : Record 77;
      DocumentSendingProfile@1004 : Record 60;
    BEGIN
      IF SendAsEmail THEN
        DocumentSendingProfile.TrySendToEMail(
          DummyReportSelections.Usage::"Fin.Charge",Rec,FIELDNO("No."),FinanceChargeTxt,FIELDNO("Customer No."),NOT HideDialog)
      ELSE
        DocumentSendingProfile.TrySendToPrinter(
          DummyReportSelections.Usage::"Fin.Charge",Rec,FIELDNO("Customer No."),ShowRequestForm)
    END;

    [External]
    PROCEDURE Navigate@2();
    VAR
      NavigateForm@1000 : Page 344;
    BEGIN
      NavigateForm.SetDoc("Posting Date","No.");
      NavigateForm.RUN;
    END;

    [External]
    PROCEDURE IncrNoPrinted@3();
    BEGIN
      FinChrgMemoIssue.IncrNoPrinted(Rec);
    END;

    [External]
    PROCEDURE ShowDimensions@4();
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"No."));
    END;

    PROCEDURE AccountCodeLineSpecified@1101100007() : Boolean;
    VAR
      IssuedFinChargeMemoLine@1101100000 : Record 305;
    BEGIN
      IssuedFinChargeMemoLine.RESET;
      IssuedFinChargeMemoLine.SETRANGE("Finance Charge Memo No.", "No.");
      IssuedFinChargeMemoLine.SETFILTER(Type, '>%1', IssuedFinChargeMemoLine.Type::" ");
      IssuedFinChargeMemoLine.SETFILTER("Account Code", '<>%1&<>%2', '', "Account Code");
      EXIT(NOT IssuedFinChargeMemoLine.ISEMPTY);
    END;

    PROCEDURE TaxLineSpecified@1101100001() : Boolean;
    VAR
      IssuedFinChargeMemoLine@1101100000 : Record 305;
    BEGIN
      IssuedFinChargeMemoLine.RESET;
      IssuedFinChargeMemoLine.SETRANGE("Finance Charge Memo No.", "No.");
      IssuedFinChargeMemoLine.SETFILTER(Type, '>%1', IssuedFinChargeMemoLine.Type::" ");
      IssuedFinChargeMemoLine.FIND('-');
      IssuedFinChargeMemoLine.SETFILTER("VAT %", '<>%1', IssuedFinChargeMemoLine."VAT %");
      EXIT(NOT IssuedFinChargeMemoLine.ISEMPTY);
    END;

    PROCEDURE GetDescription@1101100005() : Text[1024];
    VAR
      AppMgt@1101100001 : Codeunit 1;
    BEGIN
      EXIT(STRSUBSTNO('%1 %2 %3%4', TABLECAPTION,FIELDCAPTION("No."), "No.", CrLf));
    END;

    LOCAL PROCEDURE CrLf@1101100009() CrLf : Text[2];
    BEGIN
      CrLf[1] := 13;
      CrLf[2] := 10;
    END;

    BEGIN
    END.
  }
}

