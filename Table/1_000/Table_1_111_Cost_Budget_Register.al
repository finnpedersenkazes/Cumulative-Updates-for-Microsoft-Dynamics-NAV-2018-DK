OBJECT Table 1111 Cost Budget Register
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningsbudgetregister;
               ENU=Cost Budget Register];
    LookupPageID=Page1121;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   Editable=No }
    { 2   ;   ;Source              ;Option        ;CaptionML=[DAN=Kilde;
                                                              ENU=Source];
                                                   OptionCaptionML=[DAN=Overf›r fra finansbudget,Omkostningskladde,Fordeling,Manuelt;
                                                                    ENU=Transfer from G/L Budget,Cost Journal,Allocation,Manual];
                                                   OptionString=Transfer from G/L Budget,Cost Journal,Allocation,Manual;
                                                   Editable=No }
    { 3   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description];
                                                   Editable=No }
    { 4   ;   ;From Budget Entry No.;Integer      ;TableRelation="G/L Budget Entry";
                                                   CaptionML=[DAN=Fra budgetpostnr.;
                                                              ENU=From Budget Entry No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 5   ;   ;To Budget Entry No. ;Integer       ;TableRelation="G/L Budget Entry";
                                                   CaptionML=[DAN=Til budgetpostnr.;
                                                              ENU=To Budget Entry No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 6   ;   ;From Cost Budget Entry No.;Integer ;TableRelation="Cost Budget Entry";
                                                   CaptionML=[DAN=Fra omkostningsbudgetpostnr.;
                                                              ENU=From Cost Budget Entry No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 7   ;   ;To Cost Budget Entry No.;Integer   ;TableRelation="Cost Budget Entry";
                                                   CaptionML=[DAN=Til omkostningsbudgetpostnr.;
                                                              ENU=To Cost Budget Entry No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 8   ;   ;No. of Entries      ;Integer       ;CaptionML=[DAN=Antal poster;
                                                              ENU=No. of Entries];
                                                   Editable=No }
    { 15  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 20  ;   ;Processed Date      ;Date          ;CaptionML=[DAN=Behandlingsdato;
                                                              ENU=Processed Date];
                                                   Editable=No }
    { 21  ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf›ringsdato;
                                                              ENU=Posting Date];
                                                   Editable=No }
    { 23  ;   ;Closed              ;Boolean       ;OnValidate=BEGIN
                                                                IF xRec.Closed AND NOT Closed THEN
                                                                  ERROR(Text000);

                                                                IF Closed AND NOT xRec.Closed THEN BEGIN
                                                                  IF NOT CONFIRM(Text001,FALSE,"No.") THEN
                                                                    ERROR('');

                                                                  CostBudgetRegister2.SETRANGE("No.",1,"No.");
                                                                  CostBudgetRegister2 := Rec;
                                                                  CostBudgetRegister2.SETRANGE(Closed,FALSE);
                                                                  CostBudgetRegister2.MODIFYALL(Closed,TRUE);
                                                                  GET("No.");
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Lukket;
                                                              ENU=Closed] }
    { 25  ;   ;Level               ;Integer       ;CaptionML=[DAN=Niveau;
                                                              ENU=Level];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 31  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID];
                                                   Editable=No }
    { 32  ;   ;Journal Batch Name  ;Code10        ;TableRelation="Cost Journal Template";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name];
                                                   Editable=No }
    { 33  ;   ;Cost Budget Name    ;Code10        ;TableRelation="Cost Budget Name";
                                                   CaptionML=[DAN=Omkostningsbudgetnavn;
                                                              ENU=Cost Budget Name];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Source                                   }
    {    ;Cost Budget Name                         }
    {    ;From Cost Budget Entry No.,To Cost Budget Entry No. }
    {    ;Closed                                   }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CostBudgetRegister2@1000 : Record 1111;
      Text000@1001 : TextConst 'DAN=En lukket journal kan ikke genaktiveres.;ENU=A closed register cannot be reactivated.';
      Text001@1002 : TextConst 'DAN=Alle journaler op til den aktuelle journal %1 bliver lukket og kan ikke l‘ngere slettes.\\Vil du lukke journalerne?;ENU=All registers up to the current register %1 will be closed and can no longer be deleted.\\Do you want to close the registers?';

    BEGIN
    END.
  }
}

