OBJECT Table 8627 Config. Setup
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Konfig.opsëtning;
               ENU=Config. Setup];
  }
  FIELDS
  {
    { 1   ;   ;Primary Key         ;Code10        ;CaptionML=[DAN=Primërnõgle;
                                                              ENU=Primary Key] }
    { 2   ;   ;Name                ;Text50        ;CaptionML=[DAN=Navn;
                                                              ENU=Name] }
    { 3   ;   ;Name 2              ;Text50        ;CaptionML=[DAN=Navn 2;
                                                              ENU=Name 2] }
    { 4   ;   ;Address             ;Text50        ;CaptionML=[DAN=Adresse;
                                                              ENU=Address] }
    { 5   ;   ;Address 2           ;Text50        ;CaptionML=[DAN=Adresse 2;
                                                              ENU=Address 2] }
    { 6   ;   ;City                ;Text30        ;CaptionML=[DAN=By;
                                                              ENU=City] }
    { 7   ;   ;Phone No.           ;Text30        ;CaptionML=[DAN=Telefon;
                                                              ENU=Phone No.] }
    { 8   ;   ;Phone No. 2         ;Text30        ;CaptionML=[DAN=Telefon 2;
                                                              ENU=Phone No. 2] }
    { 9   ;   ;Telex No.           ;Text30        ;CaptionML=[DAN=Telex;
                                                              ENU=Telex No.] }
    { 10  ;   ;Fax No.             ;Text30        ;CaptionML=[DAN=Telefax;
                                                              ENU=Fax No.] }
    { 11  ;   ;Giro No.            ;Text20        ;CaptionML=[DAN=Gironr.;
                                                              ENU=Giro No.] }
    { 12  ;   ;Bank Name           ;Text50        ;AccessByPermission=TableData 270=R;
                                                   CaptionML=[DAN=Banknavn;
                                                              ENU=Bank Name] }
    { 13  ;   ;Bank Branch No.     ;Text20        ;AccessByPermission=TableData 270=R;
                                                   CaptionML=[DAN=Bankregistreringsnr.;
                                                              ENU=Bank Branch No.] }
    { 14  ;   ;Bank Account No.    ;Text30        ;AccessByPermission=TableData 270=R;
                                                   CaptionML=[DAN=Bankkontonr.;
                                                              ENU=Bank Account No.] }
    { 15  ;   ;Payment Routing No. ;Text20        ;CaptionML=[DAN=PBS-nr.;
                                                              ENU=Payment Routing No.] }
    { 17  ;   ;Customs Permit No.  ;Text10        ;CaptionML=[DAN=Toldregistreringsnr.;
                                                              ENU=Customs Permit No.] }
    { 18  ;   ;Customs Permit Date ;Date          ;CaptionML=[DAN=Toldreg.dato;
                                                              ENU=Customs Permit Date] }
    { 19  ;   ;VAT Registration No.;Text20        ;CaptionML=[DAN=SE/CVR-nr.;
                                                              ENU=VAT Registration No.] }
    { 20  ;   ;Registration No.    ;Text20        ;CaptionML=[DAN=Registreringsnr.;
                                                              ENU=Registration No.] }
    { 21  ;   ;Telex Answer Back   ;Text20        ;CaptionML=[DAN=Telex (tilbagesvar);
                                                              ENU=Telex Answer Back] }
    { 22  ;   ;Ship-to Name        ;Text50        ;CaptionML=[DAN=Leveringsnavn;
                                                              ENU=Ship-to Name] }
    { 23  ;   ;Ship-to Name 2      ;Text50        ;CaptionML=[DAN=Leveringsnavn 2;
                                                              ENU=Ship-to Name 2] }
    { 24  ;   ;Ship-to Address     ;Text50        ;CaptionML=[DAN=Leveringsadresse;
                                                              ENU=Ship-to Address] }
    { 25  ;   ;Ship-to Address 2   ;Text50        ;CaptionML=[DAN=Leveringsadresse 2;
                                                              ENU=Ship-to Address 2] }
    { 26  ;   ;Ship-to City        ;Text30        ;CaptionML=[DAN=Leveringsby;
                                                              ENU=Ship-to City] }
    { 27  ;   ;Ship-to Contact     ;Text50        ;CaptionML=[DAN=Leveres attention;
                                                              ENU=Ship-to Contact] }
    { 28  ;   ;Location Code       ;Code10        ;CaptionML=[DAN=Lokationskode;
                                                              ENU=Location Code] }
    { 29  ;   ;Picture             ;BLOB          ;CaptionML=[DAN=Billede;
                                                              ENU=Picture];
                                                   SubType=Bitmap }
    { 30  ;   ;Post Code           ;Code20        ;CaptionML=[DAN=Postnr.;
                                                              ENU=Post Code] }
    { 31  ;   ;County              ;Text30        ;CaptionML=[DAN=Amt;
                                                              ENU=County] }
    { 32  ;   ;Ship-to Post Code   ;Code20        ;CaptionML=[DAN=Leveringspostnr.;
                                                              ENU=Ship-to Post Code] }
    { 33  ;   ;Ship-to County      ;Text30        ;CaptionML=[DAN=Leveringsamt;
                                                              ENU=Ship-to County] }
    { 34  ;   ;E-Mail              ;Text80        ;CaptionML=[DAN=Mail;
                                                              ENU=Email] }
    { 35  ;   ;Home Page           ;Text80        ;CaptionML=[DAN=Hjemmeside;
                                                              ENU=Home Page] }
    { 36  ;   ;Country/Region Code ;Code10        ;CaptionML=[DAN=Lande-/omrÜdekode;
                                                              ENU=Country/Region Code] }
    { 37  ;   ;Ship-to Country/Region Code;Code10 ;CaptionML=[DAN=Lande-/omrÜdekode for levering;
                                                              ENU=Ship-to Country/Region Code] }
    { 38  ;   ;IBAN                ;Code50        ;OnValidate=VAR
                                                                CompanyInfo@1000 : Record 79;
                                                              BEGIN
                                                                CompanyInfo.CheckIBAN(IBAN);
                                                              END;

                                                   CaptionML=[DAN=IBAN;
                                                              ENU=IBAN] }
    { 39  ;   ;SWIFT Code          ;Code20        ;CaptionML=[DAN=SWIFT-kode;
                                                              ENU=SWIFT Code] }
    { 40  ;   ;Industrial Classification;Text30   ;CaptionML=[DAN=Industriklassifikation;
                                                              ENU=Industrial Classification] }
    { 500 ;   ;Logo Position on Documents;Option  ;CaptionML=[DAN=Logoplacering pÜ dokumenter;
                                                              ENU=Logo Position on Documents];
                                                   OptionCaptionML=[DAN=Intet logo,Venstrestillet,Centreret,Hõjrestillet;
                                                                    ENU=No Logo,Left,Center,Right];
                                                   OptionString=No Logo,Left,Center,Right }
    { 5700;   ;Responsibility Center;Code10       ;CaptionML=[DAN=Ansvarscenter;
                                                              ENU=Responsibility Center] }
    { 5791;   ;Check-Avail. Period Calc.;DateFormula;
                                                   CaptionML=[DAN=Check beholdn. Periodeberegn.;
                                                              ENU=Check-Avail. Period Calc.] }
    { 5792;   ;Check-Avail. Time Bucket;Option    ;CaptionML=[DAN=Check beholdn. Interval;
                                                              ENU=Check-Avail. Time Bucket];
                                                   OptionCaptionML=[DAN=Dag,Uge,MÜned,Kvartal,èr;
                                                                    ENU=Day,Week,Month,Quarter,Year];
                                                   OptionString=Day,Week,Month,Quarter,Year }
    { 7600;   ;Base Calendar Code  ;Code10        ;CaptionML=[DAN=Basiskalenderkode;
                                                              ENU=Base Calendar Code] }
    { 7601;   ;Cal. Convergence Time Frame;DateFormula;
                                                   InitValue=1Y;
                                                   CaptionML=[DAN=Beregn konv. tidsrum;
                                                              ENU=Cal. Convergence Time Frame] }
    { 8600;   ;Package File Name   ;Text250       ;OnValidate=VAR
                                                                FileManagement@1000 : Codeunit 419;
                                                              BEGIN
                                                                ReadPackageHeader(DecompressPackage(FileManagement.CanRunDotNetOnClient));
                                                              END;

                                                   CaptionML=[DAN=Pakkefilnavn;
                                                              ENU=Package File Name] }
    { 8601;   ;Package Code        ;Code20        ;CaptionML=[DAN=Pakkekode;
                                                              ENU=Package Code];
                                                   Editable=No }
    { 8602;   ;Language ID         ;Integer       ;TableRelation="Windows Language";
                                                   CaptionML=[DAN=Sprog-id;
                                                              ENU=Language ID];
                                                   Editable=No }
    { 8603;   ;Product Version     ;Text80        ;CaptionML=[DAN=Produktversion;
                                                              ENU=Product Version];
                                                   Editable=No }
    { 8604;   ;Package Name        ;Text50        ;CaptionML=[DAN=Pakkenavn;
                                                              ENU=Package Name] }
    { 8605;   ;Your Profile Code   ;Code30        ;TableRelation="All Profile"."Profile ID";
                                                   CaptionML=[DAN=Din profilkode;
                                                              ENU=Your Profile Code] }
    { 8606;   ;Your Profile App ID ;GUID          ;CaptionML=[DAN=Din profils app-id;
                                                              ENU=Your Profile App ID] }
    { 8607;   ;Your Profile Scope  ;Option        ;CaptionML=[DAN=Din profils omrÜde;
                                                              ENU=Your Profile Scope];
                                                   OptionCaptionML=[DAN=System,Lejer;
                                                                    ENU=System,Tenant];
                                                   OptionString=System,Tenant }
  }
  KEYS
  {
    {    ;Primary Key                             ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      PackageAlreadyExistsQst@1003 : TextConst 'DAN=Den importerede pakke findes allerede. Vil du importere en anden pakke?;ENU=The imported package already exists. Do you want to import another package?';
      HideDialog@1000 : Boolean;
      PackageDataNotDefinedErr@1001 : TextConst '@@@="%1 = ""Package Code""";DAN=%1 skal defineres i den importerede pakke.;ENU=%1 should be defined in the imported package.';

    [Internal]
    PROCEDURE CompleteWizard@1() : Boolean;
    VAR
      Scope@1000 : 'System,Tenant';
      AppID@1001 : GUID;
    BEGIN
      TESTFIELD("Package File Name");
      TESTFIELD("Package Code");
      TESTFIELD("Package Name");

      ImportPackage(DecompressPackage(TRUE));
      ApplyPackages;
      ApplyAnswers;
      CopyCompInfo;
      SelectDefaultRoleCenter("Your Profile Code",AppID,Scope::System);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE SelectDefaultRoleCenter@8(ProfileID@1000 : Code[30];AppID@1003 : GUID;Scope@1004 : 'System,Tenant');
    VAR
      Profile@1001 : Record 2000000178;
      ConfPersonalizationMgt@1002 : Codeunit 9170;
    BEGIN
      IF Profile.GET(Scope,AppID,ProfileID) THEN BEGIN
        Profile.VALIDATE("Default Role Center",TRUE);
        Profile.MODIFY;
        ConfPersonalizationMgt.ChangeDefaultRoleCenter(Profile);
      END;
    END;

    [Internal]
    PROCEDURE ReadPackageHeader@7(DecompressedFileName@1005 : Text);
    VAR
      ConfigPackage@1003 : Record 8623;
      ConfigXMLExchange@1002 : Codeunit 8614;
      XMLDOMManagement@1004 : Codeunit 6224;
      PackageXML@1000 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlDocument";
      DocumentElement@1001 : DotNet "'System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Xml.XmlElement";
      LanguageID@1006 : Text;
    BEGIN
      IF "Package File Name" <> '' THEN BEGIN
        XMLDOMManagement.LoadXMLDocumentFromFile(DecompressedFileName,PackageXML);
        DocumentElement := PackageXML.DocumentElement;
        "Package Code" :=
          COPYSTR(
            ConfigXMLExchange.GetAttribute(
              ConfigXMLExchange.GetElementName(ConfigPackage.FIELDNAME(Code)),DocumentElement),
            1,MAXSTRLEN("Package Code"));
        IF "Package Code" = '' THEN
          ERROR(PackageDataNotDefinedErr,FIELDCAPTION("Package Code"));
        "Package Name" :=
          COPYSTR(
            ConfigXMLExchange.GetAttribute(
              ConfigXMLExchange.GetElementName(ConfigPackage.FIELDNAME("Package Name")),DocumentElement),
            1,MAXSTRLEN("Package Name"));
        IF "Package Name" = '' THEN
          ERROR(PackageDataNotDefinedErr,FIELDCAPTION("Package Name"));
        "Product Version" :=
          COPYSTR(
            ConfigXMLExchange.GetAttribute(
              ConfigXMLExchange.GetElementName(ConfigPackage.FIELDNAME("Product Version")),DocumentElement),
            1,MAXSTRLEN("Product Version"));
        LanguageID := ConfigXMLExchange.GetAttribute(
            ConfigXMLExchange.GetElementName(ConfigPackage.FIELDNAME("Language ID")),DocumentElement);
        IF LanguageID <> '' THEN
          EVALUATE("Language ID",LanguageID);
        MODIFY;
      END ELSE BEGIN
        "Package Code" := '';
        "Package Name" := '';
        "Product Version" := '';
        "Language ID" := 0;
      END;
    END;

    [Internal]
    PROCEDURE ImportPackage@4(DecompressedFileName@1005 : Text);
    VAR
      ConfigPackage@1000 : Record 8623;
      ConfigXMLExchange@1001 : Codeunit 8614;
    BEGIN
      IF ConfigPackage.GET("Package Code") THEN
        IF NOT HideDialog THEN
          IF CONFIRM(PackageAlreadyExistsQst,TRUE) THEN BEGIN
            ConfigPackage.DELETE(TRUE);
            COMMIT;
          END ELSE
            ERROR('');

      ConfigXMLExchange.SetHideDialog(HideDialog);
      ConfigXMLExchange.ImportPackageXML(DecompressedFileName);
      COMMIT;
    END;

    [External]
    PROCEDURE ApplyPackages@6() ErrorCount : Integer;
    VAR
      ConfigPackage@1003 : Record 8623;
      ConfigPackageTable@1002 : Record 8613;
      ConfigPackageMgt@1001 : Codeunit 8611;
    BEGIN
      ConfigPackage.GET("Package Code");
      ConfigPackageTable.SETRANGE("Package Code",ConfigPackage.Code);
      ConfigPackageMgt.SetHideDialog(HideDialog);
      ErrorCount := ConfigPackageMgt.ApplyPackage(ConfigPackage,ConfigPackageTable,TRUE);
    END;

    [Internal]
    PROCEDURE ApplyAnswers@9();
    VAR
      ConfigQuestionnaire@1000 : Record 8610;
      ConfigQuestionnaireMgt@1001 : Codeunit 8610;
    BEGIN
      IF ConfigQuestionnaire.FINDSET THEN
        REPEAT
          ConfigQuestionnaireMgt.ApplyAnswers(ConfigQuestionnaire);
        UNTIL ConfigQuestionnaire.NEXT = 0;
    END;

    [External]
    PROCEDURE CopyCompInfo@5();
    VAR
      CompanyInfo@1000 : Record 79;
      SalesReceivablesSetup@1001 : Record 311;
    BEGIN
      IF NOT CompanyInfo.GET THEN BEGIN
        CompanyInfo.INIT;
        CompanyInfo.INSERT;
      END;
      CompanyInfo.TRANSFERFIELDS(Rec);
      CompanyInfo.MODIFY;

      IF NOT SalesReceivablesSetup.GET THEN BEGIN
        SalesReceivablesSetup.INIT;
        SalesReceivablesSetup.INSERT;
      END;
      SalesReceivablesSetup."Logo Position on Documents" := "Logo Position on Documents";
      SalesReceivablesSetup.MODIFY;

      COMMIT;
    END;

    [External]
    PROCEDURE SetHideDialog@48(NewHideDialog@1000 : Boolean);
    BEGIN
      HideDialog := NewHideDialog;
    END;

    [Internal]
    PROCEDURE DecompressPackage@2(UploadToServer@1003 : Boolean) DecompressedFileName : Text;
    VAR
      ConfigXMLExchange@1002 : Codeunit 8614;
      FileMgt@1001 : Codeunit 419;
    BEGIN
      IF UploadToServer THEN
        DecompressedFileName := ConfigXMLExchange.DecompressPackage(FileMgt.UploadFileSilent("Package File Name"))
      ELSE
        DecompressedFileName := ConfigXMLExchange.DecompressPackage("Package File Name");
    END;

    BEGIN
    END.
  }
}

