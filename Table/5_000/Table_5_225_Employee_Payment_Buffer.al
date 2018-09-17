OBJECT Table 5225 Employee Payment Buffer
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Medarbejderbetalingsbuffer;
               ENU=Employee Payment Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Employee No.        ;Code20        ;TableRelation=Employee;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Medarbejdernr.;
                                                              ENU=Employee No.] }
    { 2   ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 3   ;   ;Employee Ledg. Entry No.;Integer   ;TableRelation="Employee Ledger Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Medarbejderpostnr.;
                                                              ENU=Employee Ledg. Entry No.] }
    { 4   ;   ;Dimension Entry No. ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsl›benr.;
                                                              ENU=Dimension Entry No.] }
    { 5   ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 6   ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 7   ;   ;Document No.        ;Code20        ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 8   ;   ;Amount              ;Decimal       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Bel›b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 9   ;   ;Employee Ledg. Entry Doc. Type;Option;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Medarbejderpostbilagstype;
                                                              ENU=Employee Ledg. Entry Doc. Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 10  ;   ;Employee Ledg. Entry Doc. No.;Code20;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Medarbejderpostbilagsnr.;
                                                              ENU=Employee Ledg. Entry Doc. No.] }
    { 170 ;   ;Creditor No.        ;Code20        ;TableRelation="Employee Ledger Entry"."Creditor No." WHERE (Entry No.=FIELD(Employee Ledg. Entry No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditornummer;
                                                              ENU=Creditor No.];
                                                   Numeric=Yes }
    { 171 ;   ;Payment Reference   ;Code50        ;TableRelation="Employee Ledger Entry"."Payment Reference" WHERE (Entry No.=FIELD(Employee Ledg. Entry No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Betalingsreference;
                                                              ENU=Payment Reference];
                                                   Numeric=Yes }
    { 172 ;   ;Payment Method Code ;Code10        ;TableRelation="Employee Ledger Entry"."Payment Method Code" WHERE (Employee No.=FIELD(Employee No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Betalingsformkode;
                                                              ENU=Payment Method Code] }
    { 173 ;   ;Applies-to Ext. Doc. No.;Code35    ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Eksternt udlign.bilagsnr.;
                                                              ENU=Applies-to Ext. Doc. No.] }
    { 290 ;   ;Exported to Payment File;Boolean   ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Eksporteret til betalingsfil;
                                                              ENU=Exported to Payment File];
                                                   Editable=No }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Employee No.,Currency Code,Employee Ledg. Entry No.,Dimension Entry No.;
                                                   Clustered=Yes }
    {    ;Document No.                             }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    BEGIN
    END.
  }
}

