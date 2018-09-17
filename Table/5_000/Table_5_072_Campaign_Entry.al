OBJECT Table 5072 Campaign Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    DataCaptionFields=Campaign No.;
    OnDelete=VAR
               InteractLogEntry@1000 : Record 5065;
             BEGIN
               InteractLogEntry.SETCURRENTKEY("Campaign No.","Campaign Entry No.");
               InteractLogEntry.SETRANGE("Campaign No.","Campaign No.");
               InteractLogEntry.SETRANGE("Campaign Entry No.","Entry No.");
               InteractLogEntry.DELETEALL;
             END;

    CaptionML=[DAN=Kampagnepost;
               ENU=Campaign Entry];
    LookupPageID=Page5089;
    DrillDownPageID=Page5089;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L›benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Campaign No.        ;Code20        ;TableRelation=Campaign;
                                                   CaptionML=[DAN=Kampagnenr.;
                                                              ENU=Campaign No.] }
    { 3   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 4   ;   ;Date                ;Date          ;CaptionML=[DAN=Dato;
                                                              ENU=Date] }
    { 5   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
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
    { 6   ;   ;Segment No.         ;Code20        ;TableRelation="Segment Header";
                                                   CaptionML=[DAN=M†lgruppenr.;
                                                              ENU=Segment No.] }
    { 7   ;   ;Canceled            ;Boolean       ;CaptionML=[DAN=Annulleret;
                                                              ENU=Canceled];
                                                   BlankZero=Yes }
    { 8   ;   ;No. of Interactions ;Integer       ;FieldClass=FlowField;
                                                   CalcFormula=Count("Interaction Log Entry" WHERE (Campaign No.=FIELD(Campaign No.),
                                                                                                    Campaign Entry No.=FIELD(Entry No.),
                                                                                                    Canceled=FIELD(Canceled)));
                                                   CaptionML=[DAN=Antal interaktioner;
                                                              ENU=No. of Interactions];
                                                   Editable=No }
    { 10  ;   ;Cost (LCY)          ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Interaction Log Entry"."Cost (LCY)" WHERE (Campaign No.=FIELD(Campaign No.),
                                                                                                               Campaign Entry No.=FIELD(Entry No.),
                                                                                                               Canceled=FIELD(Canceled)));
                                                   CaptionML=[DAN=Kostbel›b (RV);
                                                              ENU=Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 11  ;   ;Duration (Min.)     ;Decimal       ;FieldClass=FlowField;
                                                   CalcFormula=Sum("Interaction Log Entry"."Duration (Min.)" WHERE (Campaign No.=FIELD(Campaign No.),
                                                                                                                    Campaign Entry No.=FIELD(Entry No.),
                                                                                                                    Canceled=FIELD(Canceled)));
                                                   CaptionML=[DAN=Varighed (min.);
                                                              ENU=Duration (Min.)];
                                                   DecimalPlaces=0:0;
                                                   Editable=No }
    { 12  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=S‘lgerkode;
                                                              ENU=Salesperson Code] }
    { 13  ;   ;Register No.        ;Integer       ;TableRelation="Logged Segment";
                                                   CaptionML=[DAN=Journalnr.;
                                                              ENU=Register No.] }
    { 14  ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Salgstilbud,Rammesalgsordre,Salgsordrebekr‘ft.,Salgsfakt.,Salgslev.nota,Salgskreditnota,Salgskontoudtog,Rykker (salg),Opret. serviceordre,Bogf. serviceordre,K›bsrekvisition,Rammek›bsordre,K›bsordre,K›bsfakt.,K›bsmodtag.,K›bskreditnota,F›lgebrev";
                                                                    ENU=" ,Sales Qte.,Sales Blnkt. Ord,Sales Ord. Cnfrmn.,Sales Inv.,Sales Shpt. Note,Sales Cr. Memo,Sales Stmnt.,Sales Rmdr.,Serv. Ord. Create,Serv. Ord. Post,Purch.Qte.,Purch. Blnkt. Ord.,Purch. Ord.,Purch. Inv.,Purch. Rcpt.,Purch. Cr. Memo,Cover Sheet"];
                                                   OptionString=[ ,Sales Qte.,Sales Blnkt. Ord,Sales Ord. Cnfrmn.,Sales Inv.,Sales Shpt. Note,Sales Cr. Memo,Sales Stmnt.,Sales Rmdr.,Serv. Ord. Create,Serv. Ord. Post,Purch.Qte.,Purch. Blnkt. Ord.,Purch. Ord.,Purch. Inv.,Purch. Rcpt.,Purch. Cr. Memo,Cover Sheet] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Campaign No.,Date,Document Type          }
    {    ;Register No.                             }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Campaign No.,Description,Date,Document Type }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 %2 er markeret som %3.\Vil du fjerne markeringen?;ENU=%1 %2 is marked %3.\Do you wish to remove the checkmark?';
      Text002@1002 : TextConst 'DAN=Vil du markere %1 %2 som %3?;ENU=Do you wish to mark %1 %2 as %3?';

    [External]
    PROCEDURE CopyFromSegment@11(SegLine@1001 : Record 5077);
    BEGIN
      "Campaign No." := SegLine."Campaign No.";
      Date := SegLine.Date;
      "Segment No." := SegLine."Segment No.";
      "Salesperson Code" := SegLine."Salesperson Code";
      "User ID" := USERID;
      "Document Type" := SegLine."Document Type";
    END;

    [External]
    PROCEDURE ToggleCanceledCheckmark@2();
    VAR
      MasterCanceledCheckmark@1000 : Boolean;
    BEGIN
      IF ConfirmToggleCanceledCheckmark THEN BEGIN
        MasterCanceledCheckmark := NOT Canceled;
        SetCanceledCheckmark(MasterCanceledCheckmark);
      END;
    END;

    [External]
    PROCEDURE SetCanceledCheckmark@1(CanceledCheckmark@1001 : Boolean);
    VAR
      InteractLogEntry@1000 : Record 5065;
    BEGIN
      Canceled := CanceledCheckmark;
      MODIFY;

      InteractLogEntry.SETCURRENTKEY("Campaign No.","Campaign Entry No.");
      InteractLogEntry.SETRANGE("Campaign No.","Campaign No.");
      InteractLogEntry.SETRANGE("Campaign Entry No.","Entry No.");
      InteractLogEntry.MODIFYALL(Canceled,Canceled);
    END;

    LOCAL PROCEDURE ConfirmToggleCanceledCheckmark@3() : Boolean;
    BEGIN
      IF Canceled THEN
        EXIT(CONFIRM(Text000,TRUE,TABLECAPTION,"Entry No.",FIELDCAPTION(Canceled)));

      EXIT(CONFIRM(Text002,TRUE,TABLECAPTION,"Entry No.",FIELDCAPTION(Canceled)));
    END;

    BEGIN
    END.
  }
}

