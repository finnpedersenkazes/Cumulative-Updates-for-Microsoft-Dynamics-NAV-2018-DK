OBJECT Table 91 User Setup
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnInsert=VAR
               User@1000 : Record 2000000120;
             BEGIN
               IF "E-Mail" <> '' THEN
                 EXIT;
               IF "User ID" <> '' THEN
                 EXIT;
               User.SETRANGE("User Name","User ID");
               IF User.FINDFIRST THEN
                 "E-Mail" := COPYSTR(User."Contact Email",1,MAXSTRLEN("E-Mail"));
             END;

    OnDelete=VAR
               NotificationSetup@1000 : Record 1512;
             BEGIN
               NotificationSetup.SETRANGE("User ID","User ID");
               NotificationSetup.DELETEALL(TRUE);
             END;

    CaptionML=[DAN=Brugerops�tning;
               ENU=User Setup];
    LookupPageID=Page119;
    DrillDownPageID=Page119;
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnValidate=VAR
                                                                UserMgt@1000 : Codeunit 418;
                                                              BEGIN
                                                                UserMgt.ValidateUserID("User ID");
                                                              END;

                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   NotBlank=Yes }
    { 2   ;   ;Allow Posting From  ;Date          ;CaptionML=[DAN=Bogf. tilladt fra;
                                                              ENU=Allow Posting From] }
    { 3   ;   ;Allow Posting To    ;Date          ;CaptionML=[DAN=Bogf. tilladt til;
                                                              ENU=Allow Posting To] }
    { 4   ;   ;Register Time       ;Boolean       ;CaptionML=[DAN=Registrer tid;
                                                              ENU=Register Time] }
    { 10  ;   ;Salespers./Purch. Code;Code20      ;TableRelation=Salesperson/Purchaser;
                                                   OnValidate=VAR
                                                                UserSetup@1000 : Record 91;
                                                              BEGIN
                                                                IF "Salespers./Purch. Code" <> '' THEN BEGIN
                                                                  ValidateSalesPersonPurchOnUserSetup(Rec);
                                                                  UserSetup.SETCURRENTKEY("Salespers./Purch. Code");
                                                                  UserSetup.SETRANGE("Salespers./Purch. Code","Salespers./Purch. Code");
                                                                  IF UserSetup.FINDFIRST THEN
                                                                    ERROR(Text001,"Salespers./Purch. Code",UserSetup."User ID");
                                                                  UpdateSalesPerson;
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=S�lger/indk�berkode;
                                                              ENU=Salespers./Purch. Code] }
    { 11  ;   ;Approver ID         ;Code50        ;TableRelation="User Setup"."User ID";
                                                   OnValidate=BEGIN
                                                                IF "Approver ID" = "User ID" THEN
                                                                  FIELDERROR("Approver ID");
                                                              END;

                                                   OnLookup=VAR
                                                              UserSetup@1000 : Record 91;
                                                            BEGIN
                                                              UserSetup.SETFILTER("User ID",'<>%1',"User ID");
                                                              IF PAGE.RUNMODAL(PAGE::"Approval User Setup",UserSetup) = ACTION::LookupOK THEN
                                                                VALIDATE("Approver ID",UserSetup."User ID");
                                                            END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Godkender-id;
                                                              ENU=Approver ID] }
    { 12  ;   ;Sales Amount Approval Limit;Integer;OnValidate=BEGIN
                                                                IF "Unlimited Sales Approval" AND ("Sales Amount Approval Limit" <> 0) THEN
                                                                  ERROR(Text003,FIELDCAPTION("Sales Amount Approval Limit"),FIELDCAPTION("Unlimited Sales Approval"));
                                                                IF "Sales Amount Approval Limit" < 0 THEN
                                                                  ERROR(Text005);
                                                              END;

                                                   CaptionML=[DAN=Bel�bsgr�nse for godkendelse af salg;
                                                              ENU=Sales Amount Approval Limit];
                                                   BlankZero=Yes }
    { 13  ;   ;Purchase Amount Approval Limit;Integer;
                                                   OnValidate=BEGIN
                                                                IF "Unlimited Purchase Approval" AND ("Purchase Amount Approval Limit" <> 0) THEN
                                                                  ERROR(Text003,FIELDCAPTION("Purchase Amount Approval Limit"),FIELDCAPTION("Unlimited Purchase Approval"));
                                                                IF "Purchase Amount Approval Limit" < 0 THEN
                                                                  ERROR(Text005);
                                                              END;

                                                   CaptionML=[DAN=Bel�bsgr�nse for godkendelse af k�b;
                                                              ENU=Purchase Amount Approval Limit];
                                                   BlankZero=Yes }
    { 14  ;   ;Unlimited Sales Approval;Boolean   ;OnValidate=BEGIN
                                                                IF "Unlimited Sales Approval" THEN
                                                                  "Sales Amount Approval Limit" := 0;
                                                              END;

                                                   CaptionML=[DAN=Ubegr�nset godkendelse af salg;
                                                              ENU=Unlimited Sales Approval] }
    { 15  ;   ;Unlimited Purchase Approval;Boolean;OnValidate=BEGIN
                                                                IF "Unlimited Purchase Approval" THEN
                                                                  "Purchase Amount Approval Limit" := 0;
                                                              END;

                                                   CaptionML=[DAN=Ubegr�nset godkendelse af k�b;
                                                              ENU=Unlimited Purchase Approval] }
    { 16  ;   ;Substitute          ;Code50        ;TableRelation="User Setup"."User ID";
                                                   OnValidate=BEGIN
                                                                IF Substitute = "User ID" THEN
                                                                  FIELDERROR(Substitute);
                                                              END;

                                                   OnLookup=VAR
                                                              UserSetup@1000 : Record 91;
                                                            BEGIN
                                                              UserSetup.SETFILTER("User ID",'<>%1',"User ID");
                                                              IF PAGE.RUNMODAL(PAGE::"Approval User Setup",UserSetup) = ACTION::LookupOK THEN
                                                                VALIDATE(Substitute,UserSetup."User ID");
                                                            END;

                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Erstatning;
                                                              ENU=Substitute] }
    { 17  ;   ;E-Mail              ;Text100       ;OnValidate=VAR
                                                                MailManagement@1000 : Codeunit 9520;
                                                              BEGIN
                                                                UpdateSalesPerson;
                                                                MailManagement.ValidateEmailAddressField("E-Mail");
                                                              END;

                                                   ExtendedDatatype=E-Mail;
                                                   CaptionML=[DAN=Mailadresse;
                                                              ENU=E-Mail] }
    { 19  ;   ;Request Amount Approval Limit;Integer;
                                                   OnValidate=BEGIN
                                                                IF "Unlimited Request Approval" AND ("Request Amount Approval Limit" <> 0) THEN
                                                                  ERROR(Text003,FIELDCAPTION("Request Amount Approval Limit"),FIELDCAPTION("Unlimited Request Approval"));
                                                                IF "Request Amount Approval Limit" < 0 THEN
                                                                  ERROR(Text005);
                                                              END;

                                                   CaptionML=[DAN=Anmod om bel�bsgr�nse for godkendelse;
                                                              ENU=Request Amount Approval Limit];
                                                   BlankZero=Yes }
    { 20  ;   ;Unlimited Request Approval;Boolean ;OnValidate=BEGIN
                                                                IF "Unlimited Request Approval" THEN
                                                                  "Request Amount Approval Limit" := 0;
                                                              END;

                                                   CaptionML=[DAN=Ubegr�nset anmodningsgodkendelsee;
                                                              ENU=Unlimited Request Approval] }
    { 21  ;   ;Approval Administrator;Boolean     ;OnValidate=VAR
                                                                UserSetup@1000 : Record 91;
                                                              BEGIN
                                                                IF "Approval Administrator" THEN BEGIN
                                                                  UserSetup.SETRANGE("Approval Administrator",TRUE);
                                                                  IF NOT UserSetup.ISEMPTY THEN
                                                                    FIELDERROR("Approval Administrator");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Godkendelsesadministrator;
                                                              ENU=Approval Administrator] }
    { 31  ;   ;License Type        ;Option        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(User."License Type" WHERE (User Name=FIELD(User ID)));
                                                   CaptionML=[DAN=Licenstype;
                                                              ENU=License Type];
                                                   OptionCaptionML=[DAN=Fuld bruger,Begr�nset bruger,Enhedsbruger,Windows-gruppe,Ekstern bruger;
                                                                    ENU=Full User,Limited User,Device Only User,Windows Group,External User];
                                                   OptionString=Full User,Limited User,Device Only User,Windows Group,External User }
    { 950 ;   ;Time Sheet Admin.   ;Boolean       ;CaptionML=[DAN=Timeseddeladm.;
                                                              ENU=Time Sheet Admin.] }
    { 5600;   ;Allow FA Posting From;Date         ;CaptionML=[DAN=Anl�gsbogf. tilladt fra;
                                                              ENU=Allow FA Posting From] }
    { 5601;   ;Allow FA Posting To ;Date          ;CaptionML=[DAN=Anl�gsbogf. tilladt til;
                                                              ENU=Allow FA Posting To] }
    { 5700;   ;Sales Resp. Ctr. Filter;Code10     ;TableRelation="Responsibility Center".Code;
                                                   CaptionML=[DAN=Filter til salgsansvarscenter;
                                                              ENU=Sales Resp. Ctr. Filter] }
    { 5701;   ;Purchase Resp. Ctr. Filter;Code10  ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Filter til k�bsansvarscenter;
                                                              ENU=Purchase Resp. Ctr. Filter] }
    { 5900;   ;Service Resp. Ctr. Filter;Code10   ;TableRelation="Responsibility Center";
                                                   CaptionML=[DAN=Filter til serviceansvarscenter;
                                                              ENU=Service Resp. Ctr. Filter] }
  }
  KEYS
  {
    {    ;User ID                                 ;Clustered=Yes }
    {    ;Salespers./Purch. Code                   }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text001@1000 : TextConst 'DAN=S�lger-/indk�berkoden %1 er allerede tildelt til bruger-id''et %2.;ENU=The %1 Salesperson/Purchaser code is already assigned to another User ID %2.';
      Text003@1002 : TextConst 'DAN="Du kan ikke have b�de %1 og %2. ";ENU="You cannot have both a %1 and %2. "';
      Text005@1004 : TextConst 'DAN=Du kan ikke have godkendelsesgr�nser, der er mindre end nul.;ENU=You cannot have approval limits less than zero.';
      SalesPersonPurchaser@1011 : Record 13;
      PrivacyBlockedGenericErr@1013 : TextConst '@@@="%1 = salesperson / purchaser code.";DAN=Privacy Blocked must not be true for Salesperson / Purchaser %1.;ENU=Privacy Blocked must not be true for Salesperson / Purchaser %1.';

    [External]
    PROCEDURE CreateApprovalUserSetup@3(User@1000 : Record 2000000120);
    VAR
      UserSetup@1001 : Record 91;
      ApprovalUserSetup@1002 : Record 91;
    BEGIN
      ApprovalUserSetup.INIT;
      ApprovalUserSetup.VALIDATE("User ID",User."User Name");
      ApprovalUserSetup.VALIDATE("Sales Amount Approval Limit",GetDefaultSalesAmountApprovalLimit);
      ApprovalUserSetup.VALIDATE("Purchase Amount Approval Limit",GetDefaultPurchaseAmountApprovalLimit);
      ApprovalUserSetup.VALIDATE("E-Mail",User."Contact Email");
      UserSetup.SETRANGE("Sales Amount Approval Limit",UserSetup.GetDefaultSalesAmountApprovalLimit);
      IF UserSetup.FINDFIRST THEN
        ApprovalUserSetup.VALIDATE("Approver ID",UserSetup."Approver ID");
      IF ApprovalUserSetup.INSERT THEN;
    END;

    [External]
    PROCEDURE GetDefaultSalesAmountApprovalLimit@1() : Integer;
    VAR
      UserSetup@1001 : Record 91;
      DefaultApprovalLimit@1000 : Integer;
      LimitedApprovers@1002 : Integer;
    BEGIN
      UserSetup.SETRANGE("Unlimited Sales Approval",FALSE);

      IF UserSetup.FINDFIRST THEN BEGIN
        DefaultApprovalLimit := UserSetup."Sales Amount Approval Limit";
        LimitedApprovers := UserSetup.COUNT;
        UserSetup.SETRANGE("Sales Amount Approval Limit",DefaultApprovalLimit);
        IF LimitedApprovers = UserSetup.COUNT THEN
          EXIT(DefaultApprovalLimit);
      END;

      // Return 0 if no user setup exists or no default value is found
      EXIT(0);
    END;

    [External]
    PROCEDURE GetDefaultPurchaseAmountApprovalLimit@2() : Integer;
    VAR
      UserSetup@1002 : Record 91;
      DefaultApprovalLimit@1001 : Integer;
      LimitedApprovers@1000 : Integer;
    BEGIN
      UserSetup.SETRANGE("Unlimited Purchase Approval",FALSE);

      IF UserSetup.FINDFIRST THEN BEGIN
        DefaultApprovalLimit := UserSetup."Purchase Amount Approval Limit";
        LimitedApprovers := UserSetup.COUNT;
        UserSetup.SETRANGE("Purchase Amount Approval Limit",DefaultApprovalLimit);
        IF LimitedApprovers = UserSetup.COUNT THEN
          EXIT(DefaultApprovalLimit);
      END;

      // Return 0 if no user setup exists or no default value is found
      EXIT(0);
    END;

    [External]
    PROCEDURE HideExternalUsers@5();
    VAR
      PermissionManager@1001 : Codeunit 9002;
      OriginalFilterGroup@1000 : Integer;
    BEGIN
      IF NOT PermissionManager.SoftwareAsAService THEN
        EXIT;

      OriginalFilterGroup := FILTERGROUP;
      FILTERGROUP := 2;
      CALCFIELDS("License Type");
      SETFILTER("License Type",'<>%1',"License Type"::"External User");
      FILTERGROUP := OriginalFilterGroup;
    END;

    LOCAL PROCEDURE UpdateSalesPerson@4();
    VAR
      SalespersonPurchaser@1000 : Record 13;
    BEGIN
      IF ("E-Mail" <> '') AND SalespersonPurchaser.GET("Salespers./Purch. Code") THEN BEGIN
        SalespersonPurchaser."E-Mail" := COPYSTR("E-Mail",1,MAXSTRLEN(SalespersonPurchaser."E-Mail"));
        SalespersonPurchaser.MODIFY;
      END;
    END;

    LOCAL PROCEDURE ValidateSalesPersonPurchOnUserSetup@298(UserSetup2@1000 : Record 91);
    BEGIN
      IF UserSetup2."Salespers./Purch. Code" <> '' THEN
        IF SalesPersonPurchaser.GET(UserSetup2."Salespers./Purch. Code") THEN
          IF SalesPersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalesPersonPurchaser) THEN
            ERROR(PrivacyBlockedGenericErr,UserSetup2."Salespers./Purch. Code")
    END;

    BEGIN
    END.
  }
}

