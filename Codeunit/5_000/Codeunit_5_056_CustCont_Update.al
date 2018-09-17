OBJECT Codeunit 5056 CustCont-Update
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
    PROCEDURE OnInsert@3(VAR Cust@1000 : Record 18);
    BEGIN
      RMSetup.GET;
      IF RMSetup."Bus. Rel. Code for Customers" = '' THEN
        EXIT;

      InsertNewContact(Cust,TRUE);
    END;

    [External]
    PROCEDURE OnModify@1(VAR Cust@1000 : Record 18);
    VAR
      ContBusRel@1005 : Record 5054;
      Cont@1001 : Record 5050;
      OldCont@1002 : Record 5050;
      ContNo@1003 : Code[20];
      NoSeries@1004 : Code[20];
    BEGIN
      WITH ContBusRel DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::Customer);
        SETRANGE("No.",Cust."No.");
        IF NOT FINDFIRST THEN
          EXIT;
        Cont.GET("Contact No.");
        OldCont := Cont;
      END;

      ContNo := Cont."No.";
      NoSeries := Cont."No. Series";
      Cont.VALIDATE("E-Mail",Cust."E-Mail");
      Cont.TRANSFERFIELDS(Cust);
      Cont."No." := ContNo ;
      Cont."No. Series" := NoSeries;
      Cont.VALIDATE(Name);
      Cont.OnModify(OldCont);
      Cont.MODIFY(TRUE);

      Cust.GET(Cust."No.");
    END;

    [External]
    PROCEDURE OnDelete@2(VAR Cust@1000 : Record 18);
    VAR
      ContBusRel@1001 : Record 5054;
    BEGIN
      WITH ContBusRel DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::Customer);
        SETRANGE("No.",Cust."No.");
        DELETEALL(TRUE);
      END;
    END;

    [External]
    PROCEDURE InsertNewContact@5(VAR Cust@1000 : Record 18;LocalCall@1001 : Boolean);
    VAR
      ContBusRel@1004 : Record 5054;
      Cont@1002 : Record 5050;
      NoSeriesMgt@1003 : Codeunit 396;
    BEGIN
      IF NOT LocalCall THEN BEGIN
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Customers");
      END;

      WITH Cont DO BEGIN
        INIT;
        TRANSFERFIELDS(Cust);
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
        "Business Relation Code" := RMSetup."Bus. Rel. Code for Customers";
        "Link to Table" := "Link to Table"::Customer;
        "No." := Cust."No.";
        INSERT(TRUE);
      END;
    END;

    [Internal]
    PROCEDURE InsertNewContactPerson@4(VAR Cust@1001 : Record 18;LocalCall@1003 : Boolean);
    VAR
      ContComp@1000 : Record 5050;
      ContBusRel@1002 : Record 5054;
      Cont@1004 : Record 5050;
    BEGIN
      IF NOT LocalCall THEN BEGIN
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Customers");
      END;

      ContBusRel.SETCURRENTKEY("Link to Table","No.");
      ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
      ContBusRel.SETRANGE("No.",Cust."No.");
      IF ContBusRel.FINDFIRST THEN
        IF ContComp.GET(ContBusRel."Contact No.") THEN
          WITH Cont DO BEGIN
            INIT;
            "No." := '';
            VALIDATE(Type,Type::Person);
            INSERT(TRUE);
            "Company No." := ContComp."No.";
            VALIDATE(Name,Cust.Contact);
            InheritCompanyToPersonData(ContComp);
            MODIFY(TRUE);
            Cust."Primary Contact No." := "No.";
          END
    END;

    [External]
    PROCEDURE DeleteCustomerContacts@6(VAR Customer@1000 : Record 18);
    VAR
      Contact@1002 : Record 5050;
      ContactBusinessRelation@1001 : Record 5054;
    BEGIN
      WITH ContactBusinessRelation DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::Customer);
        SETRANGE("No.",Customer."No.");
        IF FINDSET THEN
          REPEAT
            IF Contact.GET("Contact No.") THEN
              Contact.DELETE(TRUE);
          UNTIL NEXT = 0;
      END;
    END;

    PROCEDURE ContactNameIsBlank@7(CustomerNo@1000 : Code[20]) : Boolean;
    VAR
      Contact@1001 : Record 5050;
      ContactBusinessRelation@1002 : Record 5054;
    BEGIN
      WITH ContactBusinessRelation DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::Customer);
        SETRANGE("No.",CustomerNo);
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

