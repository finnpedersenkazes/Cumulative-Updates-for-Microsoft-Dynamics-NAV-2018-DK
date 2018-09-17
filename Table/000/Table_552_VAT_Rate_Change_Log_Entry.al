OBJECT Table 552 VAT Rate Change Log Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Momssats‘ndringslogpost;
               ENU=VAT Rate Change Log Entry];
  }
  FIELDS
  {
    { 1   ;   ;Converted Date      ;Date          ;CaptionML=[DAN=Konverteringsdato;
                                                              ENU=Converted Date] }
    { 2   ;   ;Entry No.           ;BigInteger    ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 10  ;   ;Table ID            ;Integer       ;CaptionML=[DAN=Tabel-id;
                                                              ENU=Table ID] }
    { 11  ;   ;Table Caption       ;Text80        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObj."Object Name" WHERE (Object Type=CONST(Table),
                                                                                                  Object ID=FIELD(Table ID)));
                                                   CaptionML=[DAN=Tabeltitel;
                                                              ENU=Table Caption];
                                                   Editable=No }
    { 20  ;   ;Record ID           ;RecordID      ;DataClassification=SystemMetadata;
                                                   CaptionML=[DAN=Record-id;
                                                              ENU=Record ID] }
    { 30  ;   ;Old Gen. Prod. Posting Group;Code20;CaptionML=[DAN=Gl. gen. prod.bogf.gruppe;
                                                              ENU=Old Gen. Prod. Posting Group] }
    { 31  ;   ;New Gen. Prod. Posting Group;Code20;CaptionML=[DAN=Ny gen. prod.bogf.gruppe;
                                                              ENU=New Gen. Prod. Posting Group] }
    { 32  ;   ;Old VAT Prod. Posting Group;Code20 ;CaptionML=[DAN=Gl. momsprod.bogf.gruppe;
                                                              ENU=Old VAT Prod. Posting Group] }
    { 33  ;   ;New VAT Prod. Posting Group;Code20 ;CaptionML=[DAN=Ny momsprod.bogf.gruppe;
                                                              ENU=New VAT Prod. Posting Group] }
    { 40  ;   ;Converted           ;Boolean       ;CaptionML=[DAN=Konverteret;
                                                              ENU=Converted] }
    { 50  ;   ;Description         ;Text250       ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
  }
  KEYS
  {
    {    ;Converted Date,Entry No.                ;Clustered=Yes }
    {    ;Entry No.                               ;MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
    {    ;Table ID                                ;MaintainSQLIndex=No;
                                                   MaintainSIFTIndex=No }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE UpdateGroups@1(OldGenProdPostingGroup@1000 : Code[20];NewGenProdPostingGroup@1001 : Code[20];OldVATProdPostingGroup@1003 : Code[20];NewVATProdPostingGroup@1002 : Code[20]);
    BEGIN
      "Old Gen. Prod. Posting Group" := OldGenProdPostingGroup;
      "New Gen. Prod. Posting Group" := NewGenProdPostingGroup;
      "Old VAT Prod. Posting Group" := OldVATProdPostingGroup;
      "New VAT Prod. Posting Group" := NewVATProdPostingGroup;
    END;

    BEGIN
    END.
  }
}

