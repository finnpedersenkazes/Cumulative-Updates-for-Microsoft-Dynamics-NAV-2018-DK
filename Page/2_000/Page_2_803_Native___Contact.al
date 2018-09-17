OBJECT Page 2803 Native - Contact
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Native - Contact;
               ENU=Native - Contact];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table5050;
    DelayedInsert=Yes;
    PageType=List;
    OnOpenPage=BEGIN
                 SetFilterForGETStatement;
               END;

    OnAfterGetRecord=BEGIN
                       ClearCalculatedFields;
                       SetXrmID;
                       SetCustomerID;
                     END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 8   ;2   ;Field     ;
                Name=number;
                CaptionML=[@@@={Locked};
                           DAN=number;
                           ENU=number];
                ApplicationArea=#All;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                Name=xrmId;
                CaptionML=[@@@={Locked};
                           DAN=xrmId;
                           ENU=xrmId];
                ApplicationArea=#All;
                SourceExpr="Xrm Id" }

    { 3   ;2   ;Field     ;
                Name=displayName;
                CaptionML=[@@@={Locked};
                           DAN=displayName;
                           ENU=displayName];
                ApplicationArea=#All;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                Name=phoneNumber;
                CaptionML=[@@@={Locked};
                           DAN=phoneNumber;
                           ENU=phoneNumber];
                ApplicationArea=#All;
                SourceExpr="Phone No." }

    { 5   ;2   ;Field     ;
                Name=email;
                CaptionML=[@@@={Locked};
                           DAN=email;
                           ENU=email];
                ApplicationArea=#All;
                SourceExpr="E-Mail" }

    { 7   ;2   ;Field     ;
                Name=customerId;
                CaptionML=[@@@={Locked};
                           DAN=customerId;
                           ENU=customerId];
                ToolTipML=[DAN=Angiver debitorens id.;
                           ENU=Specifies the Customer Id.];
                ApplicationArea=#All;
                SourceExpr=CustomerID }

  }
  CODE
  {
    VAR
      CustomerID@1000 : GUID;
      CannotCreateCustomerErr@1001 : TextConst 'DAN=Der kan ikke oprettes en debitor ud fra kontakten.;ENU=Cannot create a customer from the contact.';

    LOCAL PROCEDURE SetXrmID@4();
    VAR
      GraphIntegrationRecord@1002 : Record 5451;
      IntegrationRecord@1001 : Record 5151;
      GraphID@1000 : Text[250];
    BEGIN
      IF NOT GraphIntegrationRecord.FindIDFromRecordID(RECORDID,GraphID) THEN
        EXIT;

      IntegrationRecord.SETRANGE("Record ID",RECORDID);
      IF NOT IntegrationRecord.FINDFIRST THEN
        EXIT;

      IF NOT GraphIntegrationRecord.GET(GraphID,IntegrationRecord."Integration ID") THEN
        EXIT;

      "Xrm Id" := GraphIntegrationRecord.XRMId;
    END;

    LOCAL PROCEDURE SetCustomerID@8();
    VAR
      Customer@1001 : Record 18;
      GraphIntContact@1000 : Codeunit 5461;
    BEGIN
      IF NOT GraphIntContact.FindCustomerFromContact(Customer,Rec) THEN
        EXIT;

      CustomerID := Customer.Id;
    END;

    LOCAL PROCEDURE ClearCalculatedFields@3();
    BEGIN
      CLEAR(CustomerID);
      CLEAR("Xrm Id");
    END;

    LOCAL PROCEDURE SetFilterForGETStatement@6();
    VAR
      Contact@1002 : Record 5050;
      GraphIntContact@1001 : Codeunit 5461;
      xrmIDFilter@1000 : Text[250];
    BEGIN
      xrmIDFilter := COPYSTR(GETFILTER("Xrm Id"),1,MAXSTRLEN(xrmIDFilter));
      IF xrmIDFilter = '' THEN
        EXIT;

      IF NOT GraphIntContact.FindContactFromGraphId(xrmIDFilter,Contact) THEN
        SETFILTER("No.",'<>*')
      ELSE
        SETRANGE("No.",Contact."No.");

      SETRANGE("Xrm Id");
    END;

    [ServiceEnabled]
    [External]
    PROCEDURE MakeCustomer@15(VAR ActionContext@1000 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext");
    VAR
      Customer@1001 : Record 18;
      GraphIntContact@1002 : Codeunit 5461;
    BEGIN
      IF NOT ISNULLGUID(CustomerID) THEN BEGIN
        Customer.SETRANGE(Id,CustomerID);
        Customer.FINDFIRST;
      END ELSE
        IF NOT GraphIntContact.FindOrCreateCustomerFromGraphContactSafe("Xrm Id",Customer,Rec) THEN
          ERROR(CannotCreateCustomerErr);

      SetActionResponse(ActionContext,Customer);
    END;

    LOCAL PROCEDURE SetActionResponse@47(VAR ActionContext@1004 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.WebServiceActionContext";VAR Customer@1000 : Record 18);
    VAR
      ODataActionManagement@1003 : Codeunit 6711;
    BEGIN
      ODataActionManagement.AddKey(Customer.FIELDNO(Id),Customer.Id);
      ODataActionManagement.SetDeleteResponseLocation(ActionContext,PAGE::"Native - Customer Entity")
    END;

    BEGIN
    END.
  }
}

