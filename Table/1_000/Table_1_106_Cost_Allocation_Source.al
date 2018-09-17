OBJECT Table 1106 Cost Allocation Source
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               // Get ID if empty.
               IF ID = '' THEN BEGIN
                 CostAccSetup.LOCKTABLE;
                 CostAccSetup.GET;
                 IF CostAccSetup."Last Allocation ID" = '' THEN
                   ERROR(Text000);
                 CostAccSetup."Last Allocation ID" := INCSTR(CostAccSetup."Last Allocation ID");
                 CostAccSetup.MODIFY;
                 ID := CostAccSetup."Last Allocation ID";
               END;

               Modified;
             END;

    OnModify=BEGIN
               Modified;
             END;

    OnDelete=BEGIN
               CostAllocationTarget.SETRANGE(ID,ID);
               CostAllocationTarget.DELETEALL;
             END;

    CaptionML=[DAN=Omkostningsfordelingskilde;
               ENU=Cost Allocation Source];
    LookupPageID=Page1102;
  }
  FIELDS
  {
    { 1   ;   ;ID                  ;Code10        ;CaptionML=[DAN=Id;
                                                              ENU=ID] }
    { 2   ;   ;Level               ;Integer       ;InitValue=1;
                                                   CaptionML=[DAN=Niveau;
                                                              ENU=Level];
                                                   MinValue=1;
                                                   MaxValue=99 }
    { 3   ;   ;Valid From          ;Date          ;CaptionML=[DAN=Gyldig fra;
                                                              ENU=Valid From] }
    { 4   ;   ;Valid To            ;Date          ;CaptionML=[DAN=Gyldig til;
                                                              ENU=Valid To] }
    { 5   ;   ;Cost Type Range     ;Code30        ;TableRelation="Cost Type";
                                                   ValidateTableRelation=No;
                                                   CaptionML=[DAN=Omkostningstypeinterval;
                                                              ENU=Cost Type Range] }
    { 6   ;   ;Cost Center Code    ;Code20        ;TableRelation="Cost Center";
                                                   OnValidate=BEGIN
                                                                IF ("Cost Center Code" <> '') AND ("Cost Object Code" <> '') THEN
                                                                  ERROR(Text003);
                                                              END;

                                                   CaptionML=[DAN=Omkostningsstedskode;
                                                              ENU=Cost Center Code] }
    { 7   ;   ;Cost Object Code    ;Code20        ;TableRelation="Cost Object";
                                                   OnValidate=BEGIN
                                                                IF ("Cost Center Code" <> '') AND ("Cost Object Code" <> '') THEN
                                                                  ERROR(Text003);
                                                              END;

                                                   CaptionML=[DAN=Omkostningsemnekode;
                                                              ENU=Cost Object Code] }
    { 8   ;   ;Variant             ;Code10        ;CaptionML=[DAN=Variant;
                                                              ENU=Variant] }
    { 10  ;   ;Credit to Cost Type ;Code20        ;TableRelation="Cost Type";
                                                   CaptionML=[DAN=Kredit til omkostningstype;
                                                              ENU=Credit to Cost Type] }
    { 20  ;   ;Comment             ;Text50        ;CaptionML=[DAN=Bem‘rkning;
                                                              ENU=Comment] }
    { 22  ;   ;Total Share         ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Cost Allocation Target".Share WHERE (ID=FIELD(ID)));
                                                   CaptionML=[DAN=Samlet fordeling;
                                                              ENU=Total Share];
                                                   Editable=No }
    { 30  ;   ;Blocked             ;Boolean       ;CaptionML=[DAN=Sp‘rret;
                                                              ENU=Blocked] }
    { 60  ;   ;Last Date Modified  ;Date          ;CaptionML=[DAN=Rettet den;
                                                              ENU=Last Date Modified];
                                                   Editable=No }
    { 61  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                              TempUserID@1001 : Code[50];
                                                            BEGIN
                                                              TempUserID := "User ID";
                                                              UserMgt.LookupUserID(TempUserID);
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 100 ;   ;Allocation Source Type;Option      ;CaptionML=[DAN=Fordelingskildetype;
                                                              ENU=Allocation Source Type];
                                                   OptionCaptionML=[DAN=Begge,Faktisk,Budget;
                                                                    ENU=Both,Actual,Budget];
                                                   OptionString=Both,Actual,Budget }
  }
  KEYS
  {
    {    ;ID                                      ;Clustered=Yes }
    {    ;Level,Valid From,Valid To,Cost Type Range }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;ID,Level,Variant                         }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Hvis du vil tildele allokerings-id''et, skal feltet Sidste allokerings-id defineres under konfiguration af omkostningsregnskabet.;ENU=To assign the allocation ID, the Last Allocation ID field must be defined in the Cost Accounting setup.';
      Text003@1003 : TextConst 'DAN=Du kan ikke b†de definere et omkostningssted og et omkostningsemne.;ENU=You cannot define both cost center and cost object.';
      CostAccSetup@1004 : Record 1108;
      CostAllocationTarget@1005 : Record 1107;

    LOCAL PROCEDURE Modified@1();
    BEGIN
      "Last Date Modified" := TODAY;
      "User ID" := USERID;
    END;

    BEGIN
    END.
  }
}

