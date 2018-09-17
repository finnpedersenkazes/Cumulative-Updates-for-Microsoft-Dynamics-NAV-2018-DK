OBJECT Table 5815 Inventory Period Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogfõring af lagerbeholdningsperiode;
               ENU=Inventory Period Entry];
    DrillDownPageID=Page5829;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=Lõbenr.;
                                                              ENU=Entry No.];
                                                   NotBlank=Yes }
    { 2   ;   ;Ending Date         ;Date          ;TableRelation="Inventory Period";
                                                   CaptionML=[DAN=Slutdato;
                                                              ENU=Ending Date];
                                                   NotBlank=Yes }
    { 3   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
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
                                                              ENU=User ID] }
    { 4   ;   ;Creation Date       ;Date          ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date] }
    { 5   ;   ;Creation Time       ;Time          ;CaptionML=[DAN=Oprettelsestidspunkt;
                                                              ENU=Creation Time] }
    { 6   ;   ;Closing Item Register No.;Integer  ;TableRelation="Item Register";
                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Varejournalnr. - ultimo;
                                                              ENU=Closing Item Register No.] }
    { 7   ;   ;Entry Type          ;Option        ;CaptionML=[DAN=Posttype;
                                                              ENU=Entry Type];
                                                   OptionCaptionML=[DAN=Afslut,èbn igen;
                                                                    ENU=Close,Re-open];
                                                   OptionString=Close,Re-open;
                                                   Editable=No }
    { 8   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
  }
  KEYS
  {
    {    ;Ending Date,Entry No.                   ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {

    [External]
    PROCEDURE RemoveItemRegNo@4(EntryNo@1002 : Integer;PhysInventory@1003 : Boolean);
    VAR
      ItemReg@1000 : Record 46;
      InvtPeriodEntry@1001 : Record 5815;
    BEGIN
      IF PhysInventory THEN BEGIN
        ItemReg.SETFILTER("From Phys. Inventory Entry No.",'<=%1',EntryNo);
        ItemReg.SETFILTER("To Phys. Inventory Entry No.",'>=%1',EntryNo);
      END ELSE BEGIN
        ItemReg.SETFILTER("From Entry No.",'<=%1',"Entry No.");
        ItemReg.SETFILTER("To Entry No.",'>=%1',"Entry No.");
      END;
      IF ItemReg.FINDFIRST THEN BEGIN
        InvtPeriodEntry.SETFILTER("Closing Item Register No.",'>=%1',ItemReg."No.");
        InvtPeriodEntry.MODIFYALL("Closing Item Register No.",0);
      END;
    END;

    BEGIN
    END.
  }
}

