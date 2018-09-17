OBJECT Table 132 Incoming Document Approver
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Godkender af indg†ende bilag;
               ENU=Incoming Document Approver];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;GUID          ;DataClassification=EndUserPseudonymousIdentifiers;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
  }
  KEYS
  {
    {    ;User ID                                 ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [Internal]
    PROCEDURE SetIsApprover@1(VAR User@1003 : Record 2000000120;IsApprover@1000 : Boolean);
    VAR
      IncomingDocumentApprover@1001 : Record 132;
      WasApprover@1002 : Boolean;
    BEGIN
      IncomingDocumentApprover.LOCKTABLE;
      WasApprover := IncomingDocumentApprover.GET(User."User Security ID");
      IF WasApprover AND NOT IsApprover THEN
        IncomingDocumentApprover.DELETE;
      IF NOT WasApprover AND IsApprover THEN BEGIN
        IncomingDocumentApprover."User ID" := User."User Security ID";
        IncomingDocumentApprover.INSERT;
      END;
    END;

    BEGIN
    END.
  }
}

