OBJECT Table 46 Item Register
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varejournal;
               ENU=Item Register];
    LookupPageID=Page117;
  }
  FIELDS
  {
    { 1   ;   ;No.                 ;Integer       ;CaptionML=[DAN=Nummer;
                                                              ENU=No.] }
    { 2   ;   ;From Entry No.      ;Integer       ;TableRelation="Item Ledger Entry";
                                                   CaptionML=[DAN=Fra l�benr.;
                                                              ENU=From Entry No.] }
    { 3   ;   ;To Entry No.        ;Integer       ;TableRelation="Item Ledger Entry";
                                                   CaptionML=[DAN=Til l�benr.;
                                                              ENU=To Entry No.] }
    { 4   ;   ;Creation Date       ;Date          ;CaptionML=[DAN=Oprettelsesdato;
                                                              ENU=Creation Date] }
    { 5   ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 6   ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 7   ;   ;Journal Batch Name  ;Code10        ;TableRelation="Item Journal Batch".Name;
                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 10  ;   ;From Phys. Inventory Entry No.;Integer;
                                                   TableRelation="Phys. Inventory Ledger Entry";
                                                   CaptionML=[DAN=Fra l�benr. - lageropg�relse;
                                                              ENU=From Phys. Inventory Entry No.] }
    { 11  ;   ;To Phys. Inventory Entry No.;Integer;
                                                   TableRelation="Phys. Inventory Ledger Entry";
                                                   CaptionML=[DAN=Til l�benr. - lageropg�relse;
                                                              ENU=To Phys. Inventory Entry No.] }
    { 5800;   ;From Value Entry No.;Integer       ;TableRelation="Value Entry";
                                                   CaptionML=[DAN=Fra v�rdil�benr.;
                                                              ENU=From Value Entry No.] }
    { 5801;   ;To Value Entry No.  ;Integer       ;TableRelation="Value Entry";
                                                   CaptionML=[DAN=Til v�rdil�benr.;
                                                              ENU=To Value Entry No.] }
    { 5831;   ;From Capacity Entry No.;Integer    ;TableRelation="Capacity Ledger Entry";
                                                   CaptionML=[DAN=Fra kapacitetsl�benr.;
                                                              ENU=From Capacity Entry No.] }
    { 5832;   ;To Capacity Entry No.;Integer      ;TableRelation="Capacity Ledger Entry";
                                                   CaptionML=[DAN=Til kapacitetsl�benr.;
                                                              ENU=To Capacity Entry No.] }
  }
  KEYS
  {
    {    ;No.                                     ;Clustered=Yes }
    {    ;Creation Date                            }
    {    ;Source Code,Journal Batch Name,Creation Date }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;No.,From Entry No.,To Entry No.,Creation Date,Source Code }
  }
  CODE
  {

    BEGIN
    END.
  }
}

