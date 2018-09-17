OBJECT Codeunit 5057 VendCont-Update
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
    PROCEDURE OnInsert@3(VAR Vend@1000 : Record 23);
    BEGIN
      RMSetup.GET;
      IF RMSetup."Bus. Rel. Code for Vendors" = '' THEN
        EXIT;

      InsertNewContact(Vend,TRUE);
    END;

    [External]
    PROCEDURE OnModify@1(VAR Vend@1000 : Record 23);
    VAR
      Cont@1002 : Record 5050;
      OldCont@1001 : Record 5050;
      ContBusRel@1006 : Record 5054;
      ContNo@1004 : Code[20];
      NoSeries@1003 : Code[20];
      SalespersonCode@1005 : Code[20];
    BEGIN
      WITH ContBusRel DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::Vendor);
        SETRANGE("No.",Vend."No.");
        IF NOT FINDFIRST THEN
          EXIT;
        Cont.GET("Contact No.");
        OldCont := Cont;
      END;

      ContNo := Cont."No.";
      NoSeries := Cont."No. Series";
      SalespersonCode := Cont."Salesperson Code";
      Cont.VALIDATE("E-Mail",Vend."E-Mail");
      Cont.TRANSFERFIELDS(Vend);
      Cont."No." := ContNo ;
      Cont."No. Series" := NoSeries;
      Cont."Salesperson Code" := SalespersonCode;
      Cont.VALIDATE(Name);
      Cont.OnModify(OldCont);
      Cont.MODIFY(TRUE);

      Vend.GET(Vend."No.");
    END;

    [External]
    PROCEDURE OnDelete@2(VAR Vend@1000 : Record 23);
    VAR
      ContBusRel@1001 : Record 5054;
    BEGIN
      WITH ContBusRel DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::Vendor);
        SETRANGE("No.",Vend."No.");
        DELETEALL(TRUE);
      END;
    END;

    [External]
    PROCEDURE InsertNewContact@4(VAR Vend@1000 : Record 23;LocalCall@1001 : Boolean);
    VAR
      Cont@1002 : Record 5050;
      ContBusRel@1004 : Record 5054;
      NoSeriesMgt@1003 : Codeunit 396;
    BEGIN
      IF NOT LocalCall THEN BEGIN
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Vendors");
      END;

      WITH Cont DO BEGIN
        INIT;
        TRANSFERFIELDS(Vend);
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
        "Business Relation Code" := RMSetup."Bus. Rel. Code for Vendors";
        "Link to Table" := "Link to Table"::Vendor;
        "No." := Vend."No.";
        INSERT(TRUE);
      END;
    END;

    [Internal]
    PROCEDURE InsertNewContactPerson@5(VAR Vend@1001 : Record 23;LocalCall@1003 : Boolean);
    VAR
      Cont@1004 : Record 5050;
      ContComp@1000 : Record 5050;
      ContBusRel@1002 : Record 5054;
    BEGIN
      IF NOT LocalCall THEN BEGIN
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Vendors");
      END;

      ContBusRel.SETCURRENTKEY("Link to Table","No.");
      ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
      ContBusRel.SETRANGE("No.",Vend."No.");
      IF ContBusRel.FINDFIRST THEN
        IF ContComp.GET(ContBusRel."Contact No.") THEN
          WITH Cont DO BEGIN
            INIT;
            "No." := '';
            INSERT(TRUE);
            "Company No." := ContComp."No.";
            Type := Type::Person;
            VALIDATE(Name,Vend.Contact);
            InheritCompanyToPersonData(ContComp);
            MODIFY(TRUE);
            Vend."Primary Contact No." := "No.";
          END
    END;

    PROCEDURE ContactNameIsBlank@6(VendorNo@1000 : Code[20]) : Boolean;
    VAR
      Contact@1001 : Record 5050;
      ContactBusinessRelation@1002 : Record 5054;
    BEGIN
      WITH ContactBusinessRelation DO BEGIN
        SETCURRENTKEY("Link to Table","No.");
        SETRANGE("Link to Table","Link to Table"::Vendor);
        SETRANGE("No.",VendorNo);
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

