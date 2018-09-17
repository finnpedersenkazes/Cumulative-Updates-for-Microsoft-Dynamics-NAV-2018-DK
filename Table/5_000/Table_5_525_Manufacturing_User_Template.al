OBJECT Table 5525 Manufacturing User Template
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Produktionsbrugerskabelon;
               ENU=Manufacturing User Template];
  }
  FIELDS
  {
    { 1   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnValidate=VAR
                                                                UserMgt@1000 : Codeunit 418;
                                                              BEGIN
                                                                UserMgt.ValidateUserID("User ID");
                                                              END;

                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 2   ;   ;Create Purchase Order;Option       ;AccessByPermission=TableData 120=R;
                                                   CaptionML=[DAN=Opret k�bsordre;
                                                              ENU=Create Purchase Order];
                                                   OptionCaptionML=[DAN=" ,Opret k�bsordrer,Opret k�bsordrer og udskriv,Kopi�r til indk.kld.";
                                                                    ENU=" ,Make Purch. Orders,Make Purch. Orders & Print,Copy to Req. Wksh"];
                                                   OptionString=[ ,Make Purch. Orders,Make Purch. Orders & Print,Copy to Req. Wksh] }
    { 3   ;   ;Create Production Order;Option     ;CaptionML=[DAN=Opret produktionsordre;
                                                              ENU=Create Production Order];
                                                   OptionCaptionML=[DAN=" ,Planlagt,Fastlagt,Fastlagt med udskrivning,Kopi�r til indk�bskladde";
                                                                    ENU=" ,Planned,Firm Planned,Firm Planned & Print,Copy to Req. Wksh"];
                                                   OptionString=[ ,Planned,Firm Planned,Firm Planned & Print,Copy to Req. Wksh] }
    { 4   ;   ;Create Transfer Order;Option       ;AccessByPermission=TableData 5740=R;
                                                   CaptionML=[DAN=Opret overflytningsordre;
                                                              ENU=Create Transfer Order];
                                                   OptionCaptionML=[DAN=" ,Opret overf�rselsordrer,Opret overf�rselsordre med udskrivning,Kopi�r til indk�bskladde";
                                                                    ENU=" ,Make Trans. Orders,Make Trans. Order & Print,Copy to Req. Wksh"];
                                                   OptionString=[ ,Make Trans. Orders,Make Trans. Order & Print,Copy to Req. Wksh] }
    { 5   ;   ;Create Assembly Order;Option       ;AccessByPermission=TableData 90=R;
                                                   CaptionML=[DAN=Opret montageordre;
                                                              ENU=Create Assembly Order];
                                                   OptionCaptionML=[DAN=" ,Opret montageordrer,Opret montageordrer & udskriv";
                                                                    ENU=" ,Make Assembly Orders,Make Assembly Orders & Print"];
                                                   OptionString=[ ,Make Assembly Orders,Make Assembly Orders & Print] }
    { 11  ;   ;Purchase Req. Wksh. Template;Code10;TableRelation="Req. Wksh. Template";
                                                   CaptionML=[DAN=Indk�bskladdeskabelon;
                                                              ENU=Purchase Req. Wksh. Template] }
    { 12  ;   ;Purchase Wksh. Name ;Code10        ;TableRelation="Requisition Wksh. Name".Name WHERE (Worksheet Template Name=FIELD(Purchase Req. Wksh. Template));
                                                   CaptionML=[DAN=Indk�bskladdenavn;
                                                              ENU=Purchase Wksh. Name] }
    { 15  ;   ;Prod. Req. Wksh. Template;Code10   ;TableRelation="Req. Wksh. Template";
                                                   CaptionML=[DAN=Produktionskladdeskabelon;
                                                              ENU=Prod. Req. Wksh. Template] }
    { 16  ;   ;Prod. Wksh. Name    ;Code10        ;TableRelation="Requisition Wksh. Name".Name WHERE (Worksheet Template Name=FIELD(Prod. Req. Wksh. Template));
                                                   CaptionML=[DAN=Produktionskladdenavn;
                                                              ENU=Prod. Wksh. Name] }
    { 19  ;   ;Transfer Req. Wksh. Template;Code10;TableRelation="Req. Wksh. Template";
                                                   CaptionML=[DAN=Overf�rselskladdeskabelon;
                                                              ENU=Transfer Req. Wksh. Template] }
    { 20  ;   ;Transfer Wksh. Name ;Code10        ;TableRelation="Requisition Wksh. Name".Name WHERE (Worksheet Template Name=FIELD(Transfer Req. Wksh. Template));
                                                   CaptionML=[DAN=Overf�rselskladdenavn;
                                                              ENU=Transfer Wksh. Name] }
    { 21  ;   ;Make Orders         ;Option        ;CaptionML=[DAN=Lav ordrer;
                                                              ENU=Make Orders];
                                                   OptionCaptionML=[DAN=Den aktive linje,Den aktive ordre,Alle linjer;
                                                                    ENU=The Active Line,The Active Order,All Lines];
                                                   OptionString=The Active Line,The Active Order,All Lines }
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

    BEGIN
    END.
  }
}

