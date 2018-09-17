OBJECT Table 7701 Miniform Line
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Miniformularlinje;
               ENU=Miniform Line];
  }
  FIELDS
  {
    { 1   ;   ;Miniform Code       ;Code20        ;TableRelation="Miniform Header".Code;
                                                   CaptionML=[DAN=Miniformularkode;
                                                              ENU=Miniform Code];
                                                   NotBlank=Yes }
    { 3   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 11  ;   ;Area                ;Option        ;CaptionML=[DAN=Area;
                                                              ENU=Area];
                                                   OptionCaptionML=[@@@={Locked};
                                                                    DAN=Header,Body,Footer;
                                                                    ENU=Header,Body,Footer];
                                                   OptionString=Header,Body,Footer }
    { 12  ;   ;Field Type          ;Option        ;OnValidate=BEGIN
                                                                IF "Field Type" = "Field Type"::Input THEN BEGIN
                                                                  GetMiniFormHeader;
                                                                  IF ((MiniFormHeader."Form Type" = MiniFormHeader."Form Type"::"Selection List") OR
                                                                      (MiniFormHeader."Form Type" = MiniFormHeader."Form Type"::"Data List"))
                                                                  THEN
                                                                    ERROR(
                                                                      STRSUBSTNO(Text000,
                                                                        "Field Type",MiniFormHeader.FIELDCAPTION("Form Type"),MiniFormHeader."Form Type"));
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=Field Type;
                                                              ENU=Field Type];
                                                   OptionCaptionML=[@@@={Locked};
                                                                    DAN=Text,Input,Output,Asterisk;
                                                                    ENU=Text,Input,Output,Asterisk];
                                                   OptionString=Text,Input,Output,Asterisk }
    { 13  ;   ;Table No.           ;Integer       ;OnValidate=BEGIN
                                                                IF "Table No." <> 0 THEN BEGIN
                                                                  Field.RESET;
                                                                  Field.SETRANGE(TableNo,"Table No.");
                                                                  Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
                                                                  Field.FINDFIRST;
                                                                END ELSE
                                                                  VALIDATE("Field No.",0);
                                                              END;

                                                   OnLookup=BEGIN
                                                              IF "Field Type" IN ["Field Type"::Input,"Field Type"::Output] THEN BEGIN
                                                                Field.RESET;
                                                                Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
                                                                IF PAGE.RUNMODAL(PAGE::Fields,Field) = ACTION::LookupOK THEN BEGIN
                                                                  "Table No." := Field.TableNo;
                                                                  VALIDATE("Field No.",Field."No.");
                                                                END;
                                                              END;
                                                            END;

                                                   CaptionML=[DAN=Tabelnr.;
                                                              ENU=Table No.] }
    { 14  ;   ;Field No.           ;Integer       ;OnValidate=VAR
                                                                TypeHelper@1000 : Codeunit 10;
                                                              BEGIN
                                                                IF "Field No." <> 0 THEN BEGIN
                                                                  Field.GET("Table No.","Field No.");
                                                                  TypeHelper.TestFieldIsNotObsolete(Field);
                                                                  VALIDATE(Text,Field."Field Caption");
                                                                  VALIDATE("Field Length",Field.Len);
                                                                END ELSE BEGIN
                                                                  VALIDATE(Text,'');
                                                                  VALIDATE("Field Length",0);
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              Field.RESET;
                                                              Field.SETRANGE(TableNo,"Table No.");
                                                              Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
                                                              Field.TableNo := "Table No.";
                                                              Field."No." := "Field No.";
                                                              IF PAGE.RUNMODAL(PAGE::Fields,Field) = ACTION::LookupOK THEN
                                                                VALIDATE("Field No.",Field."No.");
                                                            END;

                                                   CaptionML=[DAN=Feltnr.;
                                                              ENU=Field No.] }
    { 15  ;   ;Text                ;Text30        ;CaptionML=[DAN=Tekst;
                                                              ENU=Text] }
    { 16  ;   ;Field Length        ;Integer       ;CaptionML=[DAN=Feltl‘ngde;
                                                              ENU=Field Length] }
    { 21  ;   ;Call Miniform       ;Code20        ;TableRelation="Miniform Header";
                                                   OnValidate=BEGIN
                                                                GetMiniFormHeader;
                                                              END;

                                                   CaptionML=[DAN=Miniformular til opkald;
                                                              ENU=Call Miniform] }
  }
  KEYS
  {
    {    ;Miniform Code,Line No.                  ;Clustered=Yes }
    {    ;Area                                     }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      MiniFormHeader@1002 : Record 7700;
      Field@1003 : Record 2000000041;
      Text000@1004 : TextConst 'DAN="%1 er ikke tilladt for %2 %3 ";ENU="%1 not allowed for %2 %3 "';

    LOCAL PROCEDURE GetMiniFormHeader@3();
    BEGIN
      IF MiniFormHeader.Code <> "Miniform Code" THEN
        MiniFormHeader.GET("Miniform Code");
    END;

    BEGIN
    END.
  }
}

