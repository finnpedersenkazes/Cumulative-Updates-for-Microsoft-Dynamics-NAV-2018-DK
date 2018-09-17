OBJECT Table 325 VAT Posting Setup
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               IF "VAT %" = 0 THEN
                 "VAT %" := GetVATPtc;
             END;

    OnDelete=BEGIN
               CheckSetupUsage;
             END;

    CaptionML=[DAN=Ops�tning af momsbogf.;
               ENU=VAT Posting Setup];
    LookupPageID=Page472;
    DrillDownPageID=Page472;
  }
  FIELDS
  {
    { 1   ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 2   ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 3   ;   ;VAT Calculation Type;Option        ;CaptionML=[DAN=Momsberegningstype;
                                                              ENU=VAT Calculation Type];
                                                   OptionCaptionML=[DAN=Normal moms,Modtagermoms,Momskorrektion,Sales tax;
                                                                    ENU=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax];
                                                   OptionString=Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax }
    { 4   ;   ;VAT %               ;Decimal       ;OnValidate=BEGIN
                                                                TestNotSalesTax(FIELDCAPTION("VAT %"));
                                                                CheckVATIdentifier;
                                                              END;

                                                   CaptionML=[DAN=Momspct.;
                                                              ENU=VAT %];
                                                   DecimalPlaces=0:5;
                                                   MinValue=0;
                                                   MaxValue=100 }
    { 5   ;   ;Unrealized VAT Type ;Option        ;OnValidate=BEGIN
                                                                TestNotSalesTax(FIELDCAPTION("Unrealized VAT Type"));

                                                                IF "Unrealized VAT Type" > 0 THEN BEGIN
                                                                  GLSetup.GET;
                                                                  IF NOT GLSetup."Unrealized VAT" AND NOT GLSetup."Prepayment Unrealized VAT" THEN
                                                                    GLSetup.TESTFIELD("Unrealized VAT",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Urealiseret moms - type;
                                                              ENU=Unrealized VAT Type];
                                                   OptionCaptionML=[DAN=" ,Procent,F�rst,Sidst,F�rst (betalt),Sidst (betalt)";
                                                                    ENU=" ,Percentage,First,Last,First (Fully Paid),Last (Fully Paid)"];
                                                   OptionString=[ ,Percentage,First,Last,First (Fully Paid),Last (Fully Paid)] }
    { 6   ;   ;Adjust for Payment Discount;Boolean;OnValidate=BEGIN
                                                                TestNotSalesTax(FIELDCAPTION("Adjust for Payment Discount"));

                                                                IF "Adjust for Payment Discount" THEN BEGIN
                                                                  GLSetup.GET;
                                                                  GLSetup.TESTFIELD("Adjust for Payment Disc.",TRUE);
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Reguler moms ved kontantrabat;
                                                              ENU=Adjust for Payment Discount] }
    { 7   ;   ;Sales VAT Account   ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                TestNotSalesTax(FIELDCAPTION("Sales VAT Account"));

                                                                CheckGLAcc("Sales VAT Account");
                                                              END;

                                                   CaptionML=[DAN=Salgsmomskonto;
                                                              ENU=Sales VAT Account] }
    { 8   ;   ;Sales VAT Unreal. Account;Code20   ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                TestNotSalesTax(FIELDCAPTION("Sales VAT Unreal. Account"));

                                                                CheckGLAcc("Sales VAT Unreal. Account");
                                                              END;

                                                   CaptionML=[DAN=Urealiseret salgsmomskonto;
                                                              ENU=Sales VAT Unreal. Account] }
    { 9   ;   ;Purchase VAT Account;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                TestNotSalesTax(FIELDCAPTION("Purchase VAT Account"));

                                                                CheckGLAcc("Purchase VAT Account");
                                                              END;

                                                   CaptionML=[DAN=K�bsmomskonto;
                                                              ENU=Purchase VAT Account] }
    { 10  ;   ;Purch. VAT Unreal. Account;Code20  ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                TestNotSalesTax(FIELDCAPTION("Purch. VAT Unreal. Account"));

                                                                CheckGLAcc("Purch. VAT Unreal. Account");
                                                              END;

                                                   CaptionML=[DAN=Urealiseret k�bsmomskonto;
                                                              ENU=Purch. VAT Unreal. Account] }
    { 11  ;   ;Reverse Chrg. VAT Acc.;Code20      ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                TestNotSalesTax(FIELDCAPTION("Reverse Chrg. VAT Acc."));

                                                                CheckGLAcc("Reverse Chrg. VAT Acc.");
                                                              END;

                                                   CaptionML=[DAN=Modtagermomskonto;
                                                              ENU=Reverse Chrg. VAT Acc.] }
    { 12  ;   ;Reverse Chrg. VAT Unreal. Acc.;Code20;
                                                   TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                TestNotSalesTax(FIELDCAPTION("Reverse Chrg. VAT Unreal. Acc."));

                                                                CheckGLAcc("Reverse Chrg. VAT Unreal. Acc.");
                                                              END;

                                                   CaptionML=[DAN=Urealiseret modtagermomskonto;
                                                              ENU=Reverse Chrg. VAT Unreal. Acc.] }
    { 13  ;   ;VAT Identifier      ;Code20        ;OnValidate=BEGIN
                                                                "VAT %" := GetVATPtc;
                                                              END;

                                                   CaptionML=[DAN=Moms-id;
                                                              ENU=VAT Identifier] }
    { 14  ;   ;EU Service          ;Boolean       ;CaptionML=[DAN=EU-service;
                                                              ENU=EU Service] }
    { 15  ;   ;VAT Clause Code     ;Code20        ;TableRelation="VAT Clause";
                                                   OnValidate=BEGIN
                                                                CheckVATClauseCode;
                                                              END;

                                                   CaptionML=[DAN=Momsklausulkode;
                                                              ENU=VAT Clause Code] }
    { 16  ;   ;Certificate of Supply Required;Boolean;
                                                   CaptionML=[DAN=Leveringscertifikat p�kr�vet;
                                                              ENU=Certificate of Supply Required] }
    { 17  ;   ;Tax Category        ;Code10        ;CaptionML=[DAN=Momskategori;
                                                              ENU=Tax Category] }
    { 20  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 40  ;   ;Used in Ledger Entries;Integer     ;FieldClass=FlowField;
                                                   CalcFormula=Count("G/L Entry" WHERE (VAT Bus. Posting Group=FIELD(VAT Bus. Posting Group),
                                                                                        VAT Prod. Posting Group=FIELD(VAT Prod. Posting Group)));
                                                   CaptionML=[DAN=Bruges i Finansposter;
                                                              ENU=Used in Ledger Entries];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;VAT Bus. Posting Group,VAT Prod. Posting Group;
                                                   Clustered=Yes }
    {    ;VAT Prod. Posting Group,VAT Bus. Posting Group }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 skal indtastes p� skatteregionslinjen, n�r %2 er %3.;ENU=%1 must be entered on the tax jurisdiction line when %2 is %3.';
      Text001@1001 : TextConst 'DAN="%1 = %2 er allerede blevet brugt for %3 = %4 i %5 for %6 = %7 og %8 = %9.";ENU="%1 = %2 has already been used for %3 = %4 in %5 for %6 = %7 and %8 = %9."';
      GLSetup@1002 : Record 98;
      PostingSetupMgt@1005 : Codeunit 48;
      DuplicateEntryErr@1003 : TextConst 'DAN=En anden post med samme %1 i samme %2 har en anden %3 tilknyttet. Brug samme %3, eller fjern den.;ENU=Another entry with the same %1 in the same %2 has a different %3 assigned. Use the same %3 or remove it.';
      YouCannotDeleteErr@1004 : TextConst '@@@="%1 = Location Code; %2 = Posting Group";DAN=Du kan ikke slette %1 %2.;ENU=You cannot delete %1 %2.';

    LOCAL PROCEDURE CheckGLAcc@2(AccNo@1000 : Code[20]);
    VAR
      GLAcc@1001 : Record 15;
    BEGIN
      IF AccNo <> '' THEN BEGIN
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
      END;
    END;

    LOCAL PROCEDURE CheckSetupUsage@24();
    BEGIN
      CALCFIELDS("Used in Ledger Entries");
      IF "Used in Ledger Entries" > 0 THEN
        ERROR(YouCannotDeleteErr,"VAT Bus. Posting Group","VAT Prod. Posting Group");
    END;

    LOCAL PROCEDURE TestNotSalesTax@1(FromFieldName@1000 : Text[100]);
    BEGIN
      IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
        ERROR(
          Text000,
          FromFieldName,FIELDCAPTION("VAT Calculation Type"),
          "VAT Calculation Type");
    END;

    LOCAL PROCEDURE CheckVATIdentifier@14();
    VAR
      VATPostingSetup@1000 : Record 325;
    BEGIN
      VATPostingSetup.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
      VATPostingSetup.SETFILTER("VAT Prod. Posting Group",'<>%1',"VAT Prod. Posting Group");
      VATPostingSetup.SETFILTER("VAT %",'<>%1',"VAT %");
      VATPostingSetup.SETRANGE("VAT Identifier","VAT Identifier");
      IF VATPostingSetup.FINDFIRST THEN
        ERROR(
          Text001,
          FIELDCAPTION("VAT Identifier"),VATPostingSetup."VAT Identifier",
          FIELDCAPTION("VAT %"),VATPostingSetup."VAT %",TABLECAPTION,
          FIELDCAPTION("VAT Bus. Posting Group"),VATPostingSetup."VAT Bus. Posting Group",
          FIELDCAPTION("VAT Prod. Posting Group"),VATPostingSetup."VAT Prod. Posting Group");
    END;

    LOCAL PROCEDURE CheckVATClauseCode@11();
    VAR
      VATPostingSetup@1000 : Record 325;
    BEGIN
      IF "VAT Clause Code" = '' THEN
        EXIT;
      VATPostingSetup.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
      VATPostingSetup.SETFILTER("VAT Prod. Posting Group",'<>%1',"VAT Prod. Posting Group");
      VATPostingSetup.SETRANGE("VAT Identifier","VAT Identifier");
      VATPostingSetup.SETFILTER("VAT Clause Code",'<>%1',"VAT Clause Code");
      IF NOT VATPostingSetup.ISEMPTY THEN
        ERROR(
          DuplicateEntryErr,
          FIELDCAPTION("VAT Identifier"),
          FIELDCAPTION("VAT Bus. Posting Group"),
          FIELDCAPTION("VAT Clause Code"));
    END;

    LOCAL PROCEDURE GetVATPtc@3() : Decimal;
    VAR
      VATPostingSetup@1000 : Record 325;
    BEGIN
      VATPostingSetup.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
      VATPostingSetup.SETFILTER("VAT Prod. Posting Group",'<>%1',"VAT Prod. Posting Group");
      VATPostingSetup.SETRANGE("VAT Identifier","VAT Identifier");
      IF NOT VATPostingSetup.FINDFIRST THEN
        VATPostingSetup."VAT %" := "VAT %";
      EXIT(VATPostingSetup."VAT %");
    END;

    [External]
    PROCEDURE GetSalesAccount@4(Unrealized@1000 : Boolean) : Code[20];
    BEGIN
      IF Unrealized THEN BEGIN
        IF "Sales VAT Unreal. Account" = '' THEN
          PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Sales VAT Unreal. Account"));
        TESTFIELD("Sales VAT Unreal. Account");
        EXIT("Sales VAT Unreal. Account");
      END;
      IF "Sales VAT Account" = '' THEN
        PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Sales VAT Account"));
      TESTFIELD("Sales VAT Account");
      EXIT("Sales VAT Account");
    END;

    [External]
    PROCEDURE GetPurchAccount@5(Unrealized@1000 : Boolean) : Code[20];
    BEGIN
      IF Unrealized THEN BEGIN
        IF "Purch. VAT Unreal. Account" = '' THEN
          PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Purch. VAT Unreal. Account"));
        TESTFIELD("Purch. VAT Unreal. Account");
        EXIT("Purch. VAT Unreal. Account");
      END;
      IF "Purchase VAT Account" = '' THEN
        PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Purchase VAT Account"));
      TESTFIELD("Purchase VAT Account");
      EXIT("Purchase VAT Account");
    END;

    [External]
    PROCEDURE GetRevChargeAccount@6(Unrealized@1000 : Boolean) : Code[20];
    BEGIN
      IF Unrealized THEN BEGIN
        IF "Reverse Chrg. VAT Unreal. Acc." = '' THEN
          PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Reverse Chrg. VAT Unreal. Acc."));
        TESTFIELD("Reverse Chrg. VAT Unreal. Acc.");
        EXIT("Reverse Chrg. VAT Unreal. Acc.");
      END;
      IF "Reverse Chrg. VAT Acc." = '' THEN
        PostingSetupMgt.SendVATPostingSetupNotification(Rec,FIELDCAPTION("Reverse Chrg. VAT Acc."));
      TESTFIELD("Reverse Chrg. VAT Acc.");
      EXIT("Reverse Chrg. VAT Acc.");
    END;

    PROCEDURE SetAccountsVisibility@8(VAR UnrealizedVATVisible@1000 : Boolean;VAR AdjustForPmtDiscVisible@1001 : Boolean);
    BEGIN
      GLSetup.GET;
      UnrealizedVATVisible := GLSetup."Unrealized VAT" OR GLSetup."Prepayment Unrealized VAT";
      AdjustForPmtDiscVisible := GLSetup."Adjust for Payment Disc.";
    END;

    PROCEDURE SuggestSetupAccounts@26();
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Rec);
      SuggestVATAccounts(RecRef);
      RecRef.MODIFY;
    END;

    LOCAL PROCEDURE SuggestVATAccounts@30(VAR RecRef@1000 : RecordRef);
    BEGIN
      IF "Sales VAT Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Sales VAT Account"));
      IF "Purchase VAT Account" = '' THEN
        SuggestAccount(RecRef,FIELDNO("Purchase VAT Account"));

      IF "Unrealized VAT Type" > 0 THEN BEGIN
        IF "Sales VAT Unreal. Account" = '' THEN
          SuggestAccount(RecRef,FIELDNO("Sales VAT Unreal. Account"));
        IF "Purch. VAT Unreal. Account" = '' THEN
          SuggestAccount(RecRef,FIELDNO("Purch. VAT Unreal. Account"));
      END;

      IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
        IF "Reverse Chrg. VAT Acc." = '' THEN
          SuggestAccount(RecRef,FIELDNO("Reverse Chrg. VAT Acc."));
        IF ("Unrealized VAT Type" > 0) AND ("Reverse Chrg. VAT Unreal. Acc." = '') THEN
          SuggestAccount(RecRef,FIELDNO("Reverse Chrg. VAT Unreal. Acc."));
      END;
    END;

    LOCAL PROCEDURE SuggestAccount@34(VAR RecRef@1000 : RecordRef;AccountFieldNo@1001 : Integer);
    VAR
      TempAccountUseBuffer@1002 : TEMPORARY Record 63;
      RecFieldRef@1003 : FieldRef;
      VATPostingSetupRecRef@1005 : RecordRef;
      VATPostingSetupFieldRef@1006 : FieldRef;
    BEGIN
      VATPostingSetupRecRef.OPEN(DATABASE::"VAT Posting Setup");

      VATPostingSetupRecRef.RESET;
      VATPostingSetupFieldRef := VATPostingSetupRecRef.FIELD(FIELDNO("VAT Bus. Posting Group"));
      VATPostingSetupFieldRef.SETRANGE("VAT Bus. Posting Group");
      VATPostingSetupFieldRef := VATPostingSetupRecRef.FIELD(FIELDNO("VAT Prod. Posting Group"));
      VATPostingSetupFieldRef.SETFILTER('<>%1',"VAT Prod. Posting Group");
      TempAccountUseBuffer.UpdateBuffer(VATPostingSetupRecRef,AccountFieldNo);

      VATPostingSetupRecRef.RESET;
      VATPostingSetupFieldRef := VATPostingSetupRecRef.FIELD(FIELDNO("VAT Bus. Posting Group"));
      VATPostingSetupFieldRef.SETFILTER('<>%1',"VAT Bus. Posting Group");
      VATPostingSetupFieldRef := VATPostingSetupRecRef.FIELD(FIELDNO("VAT Prod. Posting Group"));
      VATPostingSetupFieldRef.SETRANGE("VAT Prod. Posting Group");
      TempAccountUseBuffer.UpdateBuffer(VATPostingSetupRecRef,AccountFieldNo);

      VATPostingSetupRecRef.CLOSE;

      TempAccountUseBuffer.RESET;
      TempAccountUseBuffer.SETCURRENTKEY("No. of Use");
      IF TempAccountUseBuffer.FINDLAST THEN BEGIN
        RecFieldRef := RecRef.FIELD(AccountFieldNo);
        RecFieldRef.VALUE(TempAccountUseBuffer."Account No.");
      END;
    END;

    BEGIN
    END.
  }
}

