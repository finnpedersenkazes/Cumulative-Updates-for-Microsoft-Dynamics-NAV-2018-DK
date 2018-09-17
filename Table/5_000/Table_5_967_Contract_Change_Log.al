OBJECT Table 5967 Contract Change Log
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    Permissions=TableData 5967=rimd;
    DataCaptionFields=Contract No.;
    CaptionML=[DAN=Kontrakt�ndringslog;
               ENU=Contract Change Log];
  }
  FIELDS
  {
    { 1   ;   ;Contract Type       ;Option        ;CaptionML=[DAN=Kontrakttype;
                                                              ENU=Contract Type];
                                                   OptionCaptionML=[DAN=Tilbud,Kontrakt;
                                                                    ENU=Quote,Contract];
                                                   OptionString=Quote,Contract }
    { 2   ;   ;Contract No.        ;Code20        ;TableRelation=IF (Contract Type=CONST(Contract)) "Service Contract Header"."Contract No." WHERE (Contract Type=FIELD(Contract Type));
                                                   CaptionML=[DAN=Kontraktnr.;
                                                              ENU=Contract No.] }
    { 3   ;   ;Change No.          ;Integer       ;CaptionML=[DAN=�ndingsnr.;
                                                              ENU=Change No.] }
    { 4   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 5   ;   ;Date of Change      ;Date          ;CaptionML=[DAN=�ndret den;
                                                              ENU=Date of Change] }
    { 6   ;   ;Time of Change      ;Time          ;CaptionML=[DAN=�ndringstidspunkt;
                                                              ENU=Time of Change] }
    { 7   ;   ;Contract Part       ;Option        ;CaptionML=[DAN=Kontraktdel;
                                                              ENU=Contract Part];
                                                   OptionCaptionML=[DAN=Hoved,Linje,Rabat;
                                                                    ENU=Header,Line,Discount];
                                                   OptionString=Header,Line,Discount }
    { 8   ;   ;Field Description   ;Text80        ;CaptionML=[DAN=Feltbeskrivelse;
                                                              ENU=Field Description] }
    { 9   ;   ;Old Value           ;Text80        ;CaptionML=[DAN=Gammel v�rdi;
                                                              ENU=Old Value] }
    { 10  ;   ;New Value           ;Text80        ;CaptionML=[DAN=Ny v�rdi;
                                                              ENU=New Value] }
    { 12  ;   ;Type of Change      ;Option        ;CaptionML=[DAN=�ndringstype;
                                                              ENU=Type of Change];
                                                   OptionCaptionML=[DAN=Rettelse,Inds�ttelse,Sletning,Omd�bning;
                                                                    ENU=Modify,Insert,Delete,Rename];
                                                   OptionString=Modify,Insert,Delete,Rename }
    { 13  ;   ;Service Item No.    ;Code20        ;CaptionML=[DAN=Serviceartikelnr.;
                                                              ENU=Service Item No.] }
    { 14  ;   ;Serv. Contract Line No.;Integer    ;CaptionML=[DAN=Servicekontraktlinjenr.;
                                                              ENU=Serv. Contract Line No.] }
  }
  KEYS
  {
    {    ;Contract No.,Change No.                 ;Clustered=Yes }
    {    ;Contract Type                            }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ContractChangeLog@1000 : Record 5967;
      NextChangeNo@1001 : Integer;

    [External]
    PROCEDURE LogContractChange@1(ContractNo@1000 : Code[20];ContractPart@1001 : 'Header,Line,Discount';FieldName@1002 : Text[80];ChangeType@1003 : Integer;OldValue@1004 : Text[80];NewValue@1005 : Text[80];ServItemNo@1006 : Code[20];ServContractLineNo@1007 : Integer);
    BEGIN
      ContractChangeLog.RESET;
      ContractChangeLog.LOCKTABLE;
      ContractChangeLog.SETRANGE("Contract No.",ContractNo);
      IF ContractChangeLog.FINDLAST THEN
        NextChangeNo := ContractChangeLog."Change No." + 1
      ELSE
        NextChangeNo := 1;

      ContractChangeLog.INIT;
      ContractChangeLog."Contract Type" := ContractChangeLog."Contract Type"::Contract;
      ContractChangeLog."Contract No." := ContractNo;
      ContractChangeLog."User ID" := USERID;
      ContractChangeLog."Date of Change" := TODAY;
      ContractChangeLog."Time of Change" := TIME;
      ContractChangeLog."Change No." := NextChangeNo;
      ContractChangeLog."Contract Part" := ContractPart;
      ContractChangeLog."Service Item No." := ServItemNo;
      ContractChangeLog."Serv. Contract Line No." := ServContractLineNo;

      CASE ChangeType OF
        0:
          ContractChangeLog."Type of Change" := ContractChangeLog."Type of Change"::Modify;
        1:
          ContractChangeLog."Type of Change" := ContractChangeLog."Type of Change"::Insert;
        2:
          ContractChangeLog."Type of Change" := ContractChangeLog."Type of Change"::Delete;
        3:
          ContractChangeLog."Type of Change" := ContractChangeLog."Type of Change"::Rename;
      END;
      ContractChangeLog."Field Description" := FieldName;
      ContractChangeLog."Old Value" := OldValue;
      ContractChangeLog."New Value" := NewValue;
      ContractChangeLog.INSERT;
    END;

    BEGIN
    END.
  }
}

