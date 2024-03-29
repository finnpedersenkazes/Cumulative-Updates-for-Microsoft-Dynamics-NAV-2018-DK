OBJECT Table 372 Payment Buffer
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Betalingsbuffer;
               ENU=Payment Buffer];
  }
  FIELDS
  {
    { 1   ;   ;Vendor No.          ;Code20        ;TableRelation=Vendor;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kred.nummer;
                                                              ENU=Vendor No.] }
    { 2   ;   ;Currency Code       ;Code10        ;TableRelation=Currency;
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Valutakode;
                                                              ENU=Currency Code] }
    { 3   ;   ;Vendor Ledg. Entry No.;Integer     ;TableRelation="Vendor Ledger Entry";
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditorpostl�benr.;
                                                              ENU=Vendor Ledg. Entry No.] }
    { 4   ;   ;Dimension Entry No. ;Integer       ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Dimensionsl�benr.;
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
                                                   CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 9   ;   ;Vendor Ledg. Entry Doc. Type;Option;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditorpostbilagstype;
                                                              ENU=Vendor Ledg. Entry Doc. Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 10  ;   ;Vendor Ledg. Entry Doc. No.;Code20 ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditorpostbilagsnr.;
                                                              ENU=Vendor Ledg. Entry Doc. No.] }
    { 170 ;   ;Creditor No.        ;Code20        ;TableRelation="Vendor Ledger Entry"."Creditor No." WHERE (Entry No.=FIELD(Vendor Ledg. Entry No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Kreditornummer;
                                                              ENU=Creditor No.] }
    { 171 ;   ;Payment Reference   ;Code50        ;TableRelation="Vendor Ledger Entry"."Payment Reference" WHERE (Entry No.=FIELD(Vendor Ledg. Entry No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Betalingsreference;
                                                              ENU=Payment Reference];
                                                   Numeric=Yes }
    { 172 ;   ;Payment Method Code ;Code10        ;TableRelation="Vendor Ledger Entry"."Payment Method Code" WHERE (Vendor No.=FIELD(Vendor No.));
                                                   DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Betalingsformskode;
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
    {    ;Vendor No.,Currency Code,Vendor Ledg. Entry No.,Dimension Entry No.;
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

