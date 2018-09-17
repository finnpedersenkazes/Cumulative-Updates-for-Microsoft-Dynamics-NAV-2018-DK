OBJECT Table 1105 Cost Register
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningsregister;
               ENU=Cost Register];
    LookupPageID=Page1104;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;CaptionML=[DAN=Nummer;
                                                              ENU=No.];
                                                   Editable=No }
    { 2   ;   ;Source              ;Option        ;CaptionML=[DAN=Kilde;
                                                              ENU=Source];
                                                   OptionCaptionML=[DAN=Overf›r fra finanskonto,Omkostningskladde,Fordeling,Overf›r fra budget;
                                                                    ENU=Transfer from G/L,Cost Journal,Allocation,Transfer from Budget];
                                                   OptionString=Transfer from G/L,Cost Journal,Allocation,Transfer from Budget;
                                                   Editable=No }
    { 3   ;   ;Text                ;Text30        ;CaptionML=[DAN=Tekst;
                                                              ENU=Text];
                                                   Editable=No }
    { 4   ;   ;From G/L Entry No.  ;Integer       ;TableRelation="G/L Entry";
                                                   CaptionML=[DAN=Fra finanspostnr.;
                                                              ENU=From G/L Entry No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 5   ;   ;To G/L Entry No.    ;Integer       ;TableRelation="G/L Entry";
                                                   CaptionML=[DAN=Til finanspostnr.;
                                                              ENU=To G/L Entry No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 6   ;   ;From Cost Entry No. ;Integer       ;TableRelation="Cost Entry";
                                                   CaptionML=[DAN=Fra omkostningspostnr.;
                                                              ENU=From Cost Entry No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 7   ;   ;To Cost Entry No.   ;Integer       ;TableRelation="Cost Entry";
                                                   CaptionML=[DAN=Til omkostningspostnr.;
                                                              ENU=To Cost Entry No.];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 8   ;   ;No. of Entries      ;Integer       ;CaptionML=[DAN=Antal poster;
                                                              ENU=No. of Entries];
                                                   Editable=No }
    { 15  ;   ;Debit Amount        ;Decimal       ;CaptionML=[DAN=Debetbel›b;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   Editable=No }
    { 16  ;   ;Credit Amount       ;Decimal       ;CaptionML=[DAN=Kreditbel›b;
                                                              ENU=Credit Amount];
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
                                                                  IF NOT CONFIRM(Text001,FALSE,"No.") THEN BEGIN
                                                                    Closed := NOT Closed;
                                                                    EXIT;
                                                                  END;

                                                                  CostRegister.SETRANGE("No.",1,"No.");
                                                                  CostRegister := Rec;
                                                                  CostRegister.SETRANGE(Closed,FALSE);
                                                                  CostRegister.MODIFYALL(Closed,TRUE);
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
    { 32  ;   ;Journal Batch Name  ;Code10        ;TableRelation="Cost Journal Template";
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Source                                   }
    {    ;Closed                                   }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      CostRegister@1000 : Record 1105;
      Text000@1001 : TextConst 'DAN=En lukket journal kan ikke genaktiveres.;ENU=A closed register cannot be reactivated.';
      Text001@1002 : TextConst 'DAN=Alle journaler op til den aktuelle journal %1 bliver lukket og kan ikke l‘ngere slettes.\\Vil du lukke journalerne?;ENU=All registers up to the current register %1 will be closed and can no longer be deleted.\\Do you want to close the registers?';

    BEGIN
    END.
  }
}

