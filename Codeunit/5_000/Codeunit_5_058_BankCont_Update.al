OBJECT Codeunit 5058 BankCont-Update
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      RMSetup@1000 : Record 5079;

    [External]
    PROCEDURE OnInsert@3(VAR BankAcc@1000 : Record 270);
    BEGIN
      RMSetup.GET;
      IF RMSetup."Bus. Rel. Code for Bank Accs." = '' THEN
        EXIT;

      InsertNewContact(BankAcc,TRUE);
    END;

    [External]
    PROCEDURE OnModify@1(VAR BankAcc@1000 : Record 270);
    VAR
      Cont@1005 : Record 5050;
      OldCont@1004 : Record 5050;
      ContBusRel@1006 : Record 5054;
      ContNo@1003 : Code[20];
      NoSeries@1002 : Code[20];
      SalespersonCode@1001 : Code[20];
    BEGIN
      WITH ContBusRel DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::"Bank Account");
        SETRANGE("No.",BankAcc."No.");
        IF NOT FINDFIRST THEN
          EXIT;
        Cont.GET("Contact No.");
        OldCont := Cont;
      END;

      ContNo := Cont."No.";
      NoSeries := Cont."No. Series";
      SalespersonCode := Cont."Salesperson Code";
      Cont.VALIDATE("E-Mail",BankAcc."E-Mail");
      Cont.TRANSFERFIELDS(BankAcc);
      Cont."No." := ContNo ;
      Cont."No. Series" := NoSeries;
      Cont."Salesperson Code" := SalespersonCode;
      Cont.VALIDATE(Name);
      Cont.OnModify(OldCont);
      Cont.MODIFY(TRUE);

      BankAcc.GET(BankAcc."No.");
    END;

    [External]
    PROCEDURE OnDelete@2(VAR BankAcc@1000 : Record 270);
    VAR
      ContBusRel@1001 : Record 5054;
    BEGIN
      WITH ContBusRel DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::"Bank Account");
        SETRANGE("No.",BankAcc."No.");
        DELETEALL(TRUE);
      END;
    END;

    [External]
    PROCEDURE InsertNewContact@4(VAR BankAcc@1000 : Record 270;LocalCall@1001 : Boolean);
    VAR
      Cont@1003 : Record 5050;
      ContBusRel@1004 : Record 5054;
      NoSeriesMgt@1002 : Codeunit 396;
    BEGIN
      IF NOT LocalCall THEN BEGIN
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Bank Accs.");
      END;

      WITH Cont DO BEGIN
        INIT;
        TRANSFERFIELDS(BankAcc);
        VALIDATE(Name);
        VALIDATE("E-Mail");
        "No." := '';
        "No. Series" := '';
        RMSetup.TESTFIELD("Contact Nos.");
        NoSeriesMgt.InitSeries(RMSetup."Contact Nos.",'',0D,"No.","No. Series");
        Type := Type::Company;
        TypeChange;
        SetSkipDefault;
        INSERT(TRUE);
      END;

      WITH ContBusRel DO BEGIN
        INIT;
        "Contact No." := Cont."No.";
        "Business Relation Code" := RMSetup."Bus. Rel. Code for Bank Accs.";
        "Link to Table" := "Link to Table"::"Bank Account";
        "No." := BankAcc."No.";
        INSERT(TRUE);
      END;
    END;

    PROCEDURE ContactNameIsBlank@7(BankAccountNo@1000 : Code[20]) : Boolean;
    VAR
      Contact@1001 : Record 5050;
      ContactBusinessRelation@1002 : Record 5054;
    BEGIN
      WITH ContactBusinessRelation DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::"Bank Account");
        SETRANGE("No.",BankAccountNo);
        IF NOT FINDFIRST THEN
          EXIT(FALSE);
        Contact.GET("Contact No.");
        EXIT(Contact.Name = '');
      END;
    END;

    BEGIN
    END.
  }
}

