OBJECT Table 5200 Employee
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    DataCaptionFields=No.,First Name,Middle Name,Last Name;
    OnInsert=BEGIN
               "Last Modified Date Time" := CURRENTDATETIME;
               IF "No." = '' THEN BEGIN
                 HumanResSetup.GET;
                 HumanResSetup.TESTFIELD("Employee Nos.");
                 NoSeriesMgt.InitSeries(HumanResSetup."Employee Nos.",xRec."No. Series",0D,"No.","No. Series");
               END;

               DimMgt.UpdateDefaultDim(
                 DATABASE::Employee,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");
               UpdateSearchName;
             END;

    OnModify=BEGIN
               "Last Modified Date Time" := CURRENTDATETIME;
               "Last Date Modified" := TODAY;
               IF Res.READPERMISSION THEN
                 EmployeeResUpdate.HumanResToRes(xRec,Rec);
               IF SalespersonPurchaser.READPERMISSION THEN
                 EmployeeSalespersonUpdate.HumanResToSalesPerson(xRec,Rec);
               UpdateSearchName;
             END;

    OnDelete=BEGIN
               AlternativeAddr.SETRANGE("Employee No.","No.");
               AlternativeAddr.DELETEALL;

               EmployeeQualification.SETRANGE("Employee No.","No.");
               EmployeeQualification.DELETEALL;

               Relative.SETRANGE("Employee No.","No.");
               Relative.DELETEALL;

               EmployeeAbsence.SETRANGE("Employee No.","No.");
               EmployeeAbsence.DELETEALL;

               MiscArticleInformation.SETRANGE("Employee No.","No.");
               MiscArticleInformation.DELETEALL;

               ConfidentialInformation.SETRANGE("Employee No.","No.");
               ConfidentialInformation.DELETEALL;

               HumanResComment.SETRANGE("No.","No.");
               HumanResComment.DELETEALL;

               DimMgt.DeleteDefaultDim(DATABASE::Employee,"No.");
             END;

    OnRename=BEGIN
               "Last Modified Date Time" := CURRENTDATETIME;
               "Last Date Modified" := TODAY;
               UpdateSearchName;
             END;

    CaptionML=[DAN=Medarbejder;
               ENU=Employee];
    LookupPageID=Page5201;
    DrillDownPageID=Page5201;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Code20        ;OnValidate=BEGIN
                                                                IF "No." <> xRec."No." THEN BEGIN
                                                                  HumanResSetup.GET;
                                                                  NoSeriesMgt.TestManual(HumanResSetup."Employee Nos.");
                                                                  "No. Series" := '';
                                                                END;
                                                              END;

                                                   AltSearchField=Search Name;
                                                   CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;First Name          ;Text30        ;CaptionML=[DAN=Fornavn;
                                                              ENU=First Name] }
    { 3   ;   ;Middle Name         ;Text30        ;CaptionML=[DAN=Mellemnavn;
                                                              ENU=Middle Name] }
    { 4   ;   ;Last Name           ;Text30        ;CaptionML=[DAN=Efternavn;
                                                              ENU=Last Name] }
    { 5   ;   ;Initials            ;Text30        ;OnValidate=BEGIN
                                                                IF ("Search Name" = UPPERCASE(xRec.Initials)) OR ("Search Name" = '') THEN
                                                                  "Search Name" := Initials;
                                                              END;

                                                   CaptionML=[DAN=Initialer;
                                                              ENU=Initials] }
    { 6   ;   ;Job Title           ;Text30        ;CaptionML=[DAN=Stilling;
                                                              ENU=Job Title] }
    { 7   ;   ;Search Name         ;Code250       ;OnValidate=BEGIN
                                                                IF "Search Name" = '' THEN
                                                                  "Search Name" := SetSearchNameToFullnameAndInitials;
                                                              END;

                                                   CaptionML=[DAN=S›genavn;
                                                              ENU=Search Name] }
    { 8   ;   ;Address             ;Text50        ;CaptionML=[DAN=Adresse;
                                                              ENU=Address] }
    { 9   ;   ;Address 2           ;Text50        ;CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2] }
    { 10  ;   ;City                ;Text30        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code".City
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidateCity(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=By;
                                                              ENU=City] }
    { 11  ;   ;Post Code           ;Code20        ;TableRelation=IF (Country/Region Code=CONST()) "Post Code"
                                                                 ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
                                                   OnValidate=BEGIN
                                                                PostCode.ValidatePostCode(City,"Post Code",County,"Country/Region Code",(CurrFieldNo <> 0) AND GUIALLOWED);
                                                              END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 12  ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 13  ;   ;Phone No.           ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.] }
    { 14  ;   ;Mobile Phone No.    ;Text30        ;ExtendedDatatype=Phone No.;
                                                   CaptionML=[DAN=Mobiltelefon;
                                                              ENU=Mobile Phone No.] }
    { 15  ;   ;E-Mail              ;Text80        ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                MailManagement.ValidateEmailAddressField("E-Mail");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Mail;
                                                              ENU=Email] }
    { 16  ;   ;Alt. Address Code   ;Code10        ;TableRelation="Alternative Address".Code WHERE (Employee No.=FIELD(No.));
                                                   CaptionML=[DAN=Alt. adresse - kode;
                                                              ENU=Alt. Address Code] }
    { 17  ;   ;Alt. Address Start Date;Date       ;CaptionML=[DAN=Alt. adresse - startdato;
                                                              ENU=Alt. Address Start Date] }
    { 18  ;   ;Alt. Address End Date;Date         ;CaptionML=[DAN=Alt. adresse - slutdato;
                                                              ENU=Alt. Address End Date] }
    { 19  ;   ;Picture             ;BLOB          ;CaptionML=[DAN=Billede;
                                                              ENU=Picture];
                                                   SubType=Bitmap }
    { 20  ;   ;Birth Date          ;Date          ;CaptionML=[DAN=F›dselsdato;
                                                              ENU=Birth Date] }
    { 21  ;   ;Social Security No. ;Text30        ;CaptionML=[DAN=CPR-nr.;
                                                              ENU=Social Security No.] }
    { 22  ;   ;Union Code          ;Code10        ;TableRelation=Union;
                                                   CaptionML=[DAN=Fagforeningskode;
                                                              ENU=Union Code] }
    { 23  ;   ;Union Membership No.;Text30        ;CaptionML=[DAN=Medlemsnr.;
                                                              ENU=Union Membership No.] }
    { 24  ;   ;Gender              ;Option        ;CaptionML=[DAN=K›n;
                                                              ENU=Gender];
                                                   OptionCaptionML=[DAN=" ,Kvinde,Mand";
                                                                    ENU=" ,Female,Male"];
                                                   OptionString=[ ,Female,Male] }
    { 25  ;   ;Country/Region Code ;Code10        ;TableRelation=Country/Region;
                                                   CaptionML=[DAN=Lande-/omr†dekode;
                                                              ENU=Country/Region Code] }
    { 26  ;   ;Manager No.         ;Code20        ;TableRelation=Employee;
                                                   CaptionML=[DAN=Ledernr.;
                                                              ENU=Manager No.] }
    { 27  ;   ;Emplymt. Contract Code;Code10      ;TableRelation="Employment Contract";
                                                   CaptionML=[DAN=Ans‘ttelseskontraktkode;
                                                              ENU=Emplymt. Contract Code] }
    { 28  ;   ;Statistics Group Code;Code10       ;TableRelation="Employee Statistics Group";
                                                   CaptionML=[DAN=Statistikgruppekode;
                                                              ENU=Statistics Group Code] }
    { 29  ;   ;Employment Date     ;Date          ;CaptionML=[DAN=Ans‘ttelsesdato;
                                                              ENU=Employment Date] }
    { 31  ;   ;Status              ;Option        ;OnValidate=BEGIN
                                                                EmployeeQualification.SETRANGE("Employee No.","No.");
                                                                EmployeeQualification.MODIFYALL("Employee Status",Status);
                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Status;
                                                              ENU=Status];
                                                   OptionCaptionML=[DAN=Aktiv,Inaktiv,Fratr†dt;
                                                                    ENU=Active,Inactive,Terminated];
                                                   OptionString=Active,Inactive,Terminated }
    { 32  ;   ;Inactive Date       ;Date          ;CaptionML=[DAN=Inaktiv den;
                                                              ENU=Inactive Date] }
    { 33  ;   ;Cause of Inactivity Code;Code10    ;TableRelation="Cause of Inactivity";
                                                   CaptionML=[DAN=Inaktivitets†rsagskode;
                                                              ENU=Cause of Inactivity Code] }
    { 34  ;   ;Termination Date    ;Date          ;CaptionML=[DAN=Fratr‘delsesdato;
                                                              ENU=Termination Date] }
    { 35  ;   ;Grounds for Term. Code;Code10      ;TableRelation="Grounds for Termination";
                                                   CaptionML=[DAN=Fratr‘delses†rsagskode;
                                                              ENU=Grounds for Term. Code] }
    { 36  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 37  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   OnValidate=BEGIN
                                                                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                                                              END;

                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 38  ;   ;Resource No.        ;Code20        ;TableRelation=Resource WHERE (Type=CONST(Person));
                                                   OnValidate=BEGIN
                                                                IF ("Resource No." <> '') AND Res.WRITEPERMISSION THEN
                                                                  EmployeeResUpdate.ResUpdate(Rec)
                                                              END;

                                                   CaptionML=[DAN=Ressourcenr.;
                                                              ENU=Resource No.] }
    { 39  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Human Resource Comment Line" WHERE (Table Name=CONST(Employee),
                                                                                                          No.=FIELD(No.)));
                                                   CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 40  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 41  ;   ;Date Filter         ;Date          ;FieldClass=FlowFilter;
                                                   CaptionML=[DAN=Datofilter;
                                                              ENU=Date Filter] }
    { 42  ;   ;Global Dimension 1 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-filter;
                                                              ENU=Global Dimension 1 Filter];
                                                   CaptionClass='1,3,1' }
    { 43  ;   ;Global Dimension 2 Filter;Code20   ;FieldClass=FlowFilter;
                                                   TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-filter;
                                                              ENU=Global Dimension 2 Filter];
                                                   CaptionClass='1,3,2' }
    { 44  ;   ;Cause of Absence Filter;Code10     ;FieldClass=FlowFilter;
                                                   TableRelation="Cause of Absence";
                                                   CaptionML=[DAN=Frav‘rs†rsagsfilter;
                                                              ENU=Cause of Absence Filter] }
    { 45  ;   ;Total Absence (Base);Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Employee Absence"."Quantity (Base)" WHERE (Employee No.=FIELD(No.),
                                                                                                               Cause of Absence Code=FIELD(Cause of Absence Filter),
                                                                                                               From Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Frav‘r i alt (basis);
                                                              ENU=Total Absence (Base)];
                                                   DecimalPlaces=0:5;
                                                   Editable=No }
    { 46  ;   ;Extension           ;Text30        ;CaptionML=[DAN=Lokalnr.;
                                                              ENU=Extension] }
    { 47  ;   ;Employee No. Filter ;Code20        ;FieldClass=FlowFilter;
                                                   TableRelation=Employee;
                                                   CaptionML=[DAN=Medarbejdernr.filter;
                                                              ENU=Employee No. Filter] }
    { 48  ;   ;Pager               ;Text30        ;CaptionML=[DAN=Persons›ger;
                                                              ENU=Pager] }
    { 49  ;   ;Fax No.             ;Text30        ;CaptionML=[DAN=Telefax;
                                                              ENU=Fax No.] }
    { 50  ;   ;Company E-Mail      ;Text80        ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                MailManagement.ValidateEmailAddressField("Company E-Mail");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Arbejdsmail;
                                                              ENU=Company Email] }
    { 51  ;   ;Title               ;Text30        ;CaptionML=[DAN=Titel;
                                                              ENU=Title] }
    { 52  ;   ;Salespers./Purch. Code;Code20      ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=S‘lger/indk›berkode;
                                                              ENU=Salespers./Purch. Code] }
    { 53  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series];
                                                   Editable=No }
    { 54  ;   ;Last Modified Date Time;DateTime   ;CaptionML=[DAN=Dato/klokkesl‘t for seneste ‘ndring;
                                                              ENU=Last Modified Date Time];
                                                   Editable=No }
    { 55  ;   ;Employee Posting Group;Code20      ;TableRelation="Employee Posting Group";
                                                   CaptionML=[DAN=Medarbejderbogf›ringsgruppe;
                                                              ENU=Employee Posting Group] }
    { 56  ;   ;Bank Branch No.     ;Text20        ;CaptionML=[DAN=Bankregistreringsnr.;
                                                              ENU=Bank Branch No.] }
    { 57  ;   ;Bank Account No.    ;Text30        ;CaptionML=[DAN=Bankkontonr.;
                                                              ENU=Bank Account No.] }
    { 58  ;   ;IBAN                ;Code50        ;OnValidate=VAR
                                                                CompanyInfo@1000 : Record 79;
                                                              BEGIN
                                                                CompanyInfo.CheckIBAN(IBAN);
                                                              END;

                                                   CaptionML=[DAN=IBAN;
                                                              ENU=IBAN] }
    { 59  ;   ;Balance             ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=-Sum("Detailed Employee Ledger Entry".Amount WHERE (Employee No.=FIELD(No.),
                                                                                                                   Initial Entry Global Dim. 1=FIELD(Global Dimension 1 Filter),
                                                                                                                   Initial Entry Global Dim. 2=FIELD(Global Dimension 2 Filter),
                                                                                                                   Posting Date=FIELD(Date Filter)));
                                                   CaptionML=[DAN=Saldo;
                                                              ENU=Balance];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 60  ;   ;SWIFT Code          ;Code20        ;CaptionML=[DAN=SWIFT-kode;
                                                              ENU=SWIFT Code] }
    { 80  ;   ;Application Method  ;Option        ;CaptionML=[DAN=Udligningsmetode;
                                                              ENU=Application Method];
                                                   OptionCaptionML=[DAN=Manuelt,Saldo;
                                                                    ENU=Manual,Apply to Oldest];
                                                   OptionString=Manual,Apply to Oldest }
    { 140 ;   ;Image               ;Media         ;ExtendedDatatype=Person;
                                                   CaptionML=[DAN=Grafik;
                                                              ENU=Image] }
    { 150 ;   ;Privacy Blocked     ;Boolean       ;CaptionML=[DAN=Beskyttelse af personlige oplysninger sp‘rret;
                                                              ENU=Privacy Blocked] }
    { 1100;   ;Cost Center Code    ;Code20        ;TableRelation="Cost Center";
                                                   CaptionML=[DAN=Omkostningsstedskode;
                                                              ENU=Cost Center Code] }
    { 1101;   ;Cost Object Code    ;Code20        ;TableRelation="Cost Object";
                                                   CaptionML=[DAN=Omkostningsemnekode;
                                                              ENU=Cost Object Code] }
    { 8000;   ;Id                  ;GUID          ;CaptionML=[DAN=Id;
                                                              ENU=Id] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Search Name                              }
    {    ;Status,Union Code                        }
    {    ;Status,Emplymt. Contract Code            }
    {    ;Last Name,First Name,Middle Name         }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,First Name,Last Name,Initials,Job Title }
    { 2   ;Brick               ;Last Name,First Name,Job Title,Image     }
  }
  CODE
  {
    VAR
      HumanResSetup@1000 : Record 5218;
      Res@1002 : Record 156;
      PostCode@1003 : Record 225;
      AlternativeAddr@1004 : Record 5201;
      EmployeeQualification@1005 : Record 5203;
      Relative@1006 : Record 5205;
      EmployeeAbsence@1007 : Record 5207;
      MiscArticleInformation@1008 : Record 5214;
      ConfidentialInformation@1009 : Record 5216;
      HumanResComment@1010 : Record 5208;
      SalespersonPurchaser@1011 : Record 13;
      NoSeriesMgt@1012 : Codeunit 396;
      EmployeeResUpdate@1013 : Codeunit 5200;
      EmployeeSalespersonUpdate@1014 : Codeunit 5201;
      DimMgt@1015 : Codeunit 408;
      Text000@1016 : TextConst 'DAN=Vinduet Ops‘tning af Online Map skal udfyldes, f›r du kan bruge Online Map.\Se Ops‘tning af Online Map i Hj‘lp.;ENU=Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
      BlockedEmplForJnrlErr@1001 : TextConst '@@@="%1 = employee no.";DAN=Du kan ikke oprette dette bilag, fordi medarbejderen %1 er blokeret p† grund af beskyttelse af personlige oplysninger.;ENU=You cannot create this document because employee %1 is blocked due to privacy.';
      BlockedEmplForJnrlPostingErr@1017 : TextConst '@@@="%1 = employee no.";DAN=Du kan ikke bogf›re dette bilag, fordi medarbejderen %1 er blokeret p† grund af beskyttelse af personlige oplysninger.;ENU=You cannot post this document because employee %1 is blocked due to privacy.';

    [External]
    PROCEDURE AssistEdit@2() : Boolean;
    BEGIN
      HumanResSetup.GET;
      HumanResSetup.TESTFIELD("Employee Nos.");
      IF NoSeriesMgt.SelectSeries(HumanResSetup."Employee Nos.",xRec."No. Series","No. Series") THEN BEGIN
        NoSeriesMgt.SetSeries("No.");
        EXIT(TRUE);
      END;
    END;

    [External]
    PROCEDURE FullName@1() : Text[100];
    BEGIN
      IF "Middle Name" = '' THEN
        EXIT("First Name" + ' ' + "Last Name");

      EXIT("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    END;

    LOCAL PROCEDURE ValidateShortcutDimCode@29(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    BEGIN
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Employee,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    END;

    [Internal]
    PROCEDURE DisplayMap@7();
    VAR
      MapPoint@1001 : Record 800;
      MapMgt@1000 : Codeunit 802;
    BEGIN
      IF MapPoint.FINDFIRST THEN
        MapMgt.MakeSelection(DATABASE::Employee,GETPOSITION)
      ELSE
        MESSAGE(Text000);
    END;

    LOCAL PROCEDURE UpdateSearchName@4();
    VAR
      PrevSearchName@1000 : Code[250];
    BEGIN
      PrevSearchName := xRec.FullName + ' ' + xRec.Initials;
      IF ((("First Name" <> xRec."First Name") OR ("Middle Name" <> xRec."Middle Name") OR ("Last Name" <> xRec."Last Name") OR
           (Initials <> xRec.Initials)) AND ("Search Name" = PrevSearchName))
      THEN
        "Search Name" := SetSearchNameToFullnameAndInitials;
    END;

    LOCAL PROCEDURE SetSearchNameToFullnameAndInitials@3() : Code[250];
    BEGIN
      EXIT(FullName + ' ' + Initials);
    END;

    [External]
    PROCEDURE GetBankAccountNo@5() : Text;
    BEGIN
      IF IBAN <> '' THEN
        EXIT(DELCHR(IBAN,'=<>'));

      IF "Bank Account No." <> '' THEN
        EXIT("Bank Account No.");
    END;

    [External]
    PROCEDURE CheckBlockedEmployeeOnJnls@8(IsPosting@1000 : Boolean);
    BEGIN
      IF "Privacy Blocked" THEN BEGIN
        IF IsPosting THEN
          ERROR(BlockedEmplForJnrlPostingErr,"No.");
        ERROR(BlockedEmplForJnrlErr,"No.")
      END;
    END;

    BEGIN
    END.
  }
}

