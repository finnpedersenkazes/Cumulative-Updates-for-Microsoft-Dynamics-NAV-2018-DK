OBJECT Table 5077 Segment Line
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    OnDelete=VAR
               SegLine@1001 : Record 5077;
               SegmentCriteriaLine@1002 : Record 5097;
               SegmentHistory@1003 : Record 5078;
               SegInteractLanguage@1005 : Record 5104;
               Task@1000 : Record 5080;
             BEGIN
               CampaignTargetGrMgt.DeleteSegfromTargetGr(Rec);

               SegInteractLanguage.RESET;
               SegInteractLanguage.SETRANGE("Segment No.","Segment No.");
               SegInteractLanguage.SETRANGE("Segment Line No.","Line No.");
               SegInteractLanguage.DELETEALL(TRUE);
               GET("Segment No.","Line No.");

               SegLine.SETRANGE("Segment No.","Segment No.");
               SegLine.SETFILTER("Line No.",'<>%1',"Line No.");
               IF SegLine.ISEMPTY THEN BEGIN
                 IF SegHeader.GET("Segment No.") THEN
                   SegHeader.CALCFIELDS("No. of Criteria Actions");
                 IF SegHeader."No. of Criteria Actions" > 1 THEN
                   IF CONFIRM(Text006,TRUE) THEN BEGIN
                     SegmentCriteriaLine.SETRANGE("Segment No.","Segment No.");
                     SegmentCriteriaLine.DELETEALL;
                     SegmentHistory.SETRANGE("Segment No.","Segment No.");
                     SegmentHistory.DELETEALL;
                   END;
               END;
               IF "Contact No." <> '' THEN BEGIN
                 SegLine.SETRANGE("Contact No.","Contact No.");
                 IF SegLine.ISEMPTY THEN BEGIN
                   Task.SETRANGE("Segment No.","Segment No.");
                   Task.SETRANGE("Contact No.","Contact No.");
                   Task.MODIFYALL("Segment No.",'');
                 END;
               END;
             END;

    CaptionML=[DAN=M�lgruppelinje;
               ENU=Segment Line];
  }
  FIELDS
  {
    { 1   ;   ;Segment No.         ;Code20        ;TableRelation="Segment Header";
                                                   CaptionML=[DAN=M�lgruppenr.;
                                                              ENU=Segment No.] }
    { 2   ;   ;Line No.            ;Integer       ;CaptionML=[DAN=Linjenr.;
                                                              ENU=Line No.] }
    { 3   ;   ;Contact No.         ;Code20        ;TableRelation=Contact;
                                                   OnValidate=VAR
                                                                SegInteractLanguage@1000 : Record 5104;
                                                                Attachment@1001 : Record 5062;
                                                                InteractTmpl@1002 : Record 5064;
                                                              BEGIN
                                                                InitLine;

                                                                IF Cont.GET("Contact No.") THEN BEGIN
                                                                  "Language Code" := FindLanguage("Interaction Template Code",Cont."Language Code");
                                                                  "Contact Company No." := Cont."Company No.";
                                                                  "Contact Alt. Address Code" := Cont.ActiveAltAddress(Date);
                                                                  IF SegHeader.GET("Segment No.") THEN BEGIN
                                                                    IF SegHeader."Salesperson Code" = '' THEN
                                                                      "Salesperson Code" := Cont."Salesperson Code"
                                                                    ELSE
                                                                      "Salesperson Code" := SegHeader."Salesperson Code";
                                                                    IF SegHeader."Ignore Contact Corres. Type" AND
                                                                       (SegHeader."Correspondence Type (Default)" <> SegHeader."Correspondence Type (Default)"::" ")
                                                                    THEN
                                                                      "Correspondence Type" := SegHeader."Correspondence Type (Default)"
                                                                    ELSE
                                                                      IF InteractTmpl.GET(SegHeader."Interaction Template Code") AND
                                                                         (InteractTmpl."Ignore Contact Corres. Type" OR
                                                                          ((InteractTmpl."Ignore Contact Corres. Type" = FALSE) AND
                                                                           (Cont."Correspondence Type" = Cont."Correspondence Type"::" ")))
                                                                      THEN
                                                                        "Correspondence Type" := InteractTmpl."Correspondence Type (Default)"
                                                                      ELSE
                                                                        "Correspondence Type" := Cont."Correspondence Type";
                                                                  END ELSE
                                                                    IF NOT Salesperson.GET(GETFILTER("Salesperson Code")) THEN
                                                                      "Salesperson Code" := Cont."Salesperson Code";
                                                                END ELSE BEGIN
                                                                  "Contact Company No." := '';
                                                                  "Contact Alt. Address Code" := '';
                                                                  IF SegHeader.GET("Segment No.") THEN
                                                                    "Salesperson Code" := SegHeader."Salesperson Code"
                                                                  ELSE BEGIN
                                                                    "Salesperson Code" := '';
                                                                    "Language Code" := '';
                                                                  END;
                                                                END;
                                                                CALCFIELDS("Contact Name","Contact Company Name");

                                                                IF "Segment No." <> '' THEN BEGIN
                                                                  IF UniqueAttachmentExists THEN BEGIN
                                                                    MODIFY;
                                                                    SegInteractLanguage.RESET;
                                                                    SegInteractLanguage.SETRANGE("Segment No.","Segment No.");
                                                                    SegInteractLanguage.SETRANGE("Segment Line No.","Line No.");
                                                                    SegInteractLanguage.DELETEALL(TRUE);
                                                                    GET("Segment No.","Line No.");
                                                                  END;

                                                                  "Language Code" := FindLanguage("Interaction Template Code","Language Code");
                                                                  IF SegInteractLanguage.GET("Segment No.",0,"Language Code") THEN BEGIN
                                                                    IF Attachment.GET(SegInteractLanguage."Attachment No.") THEN
                                                                      "Attachment No." := SegInteractLanguage."Attachment No.";
                                                                    Subject := SegInteractLanguage.Subject;
                                                                  END;
                                                                END;

                                                                IF xRec."Contact No." <> "Contact No." THEN
                                                                  SetCampaignTargetGroup;
                                                              END;

                                                   CaptionML=[DAN=Kontaktnr.;
                                                              ENU=Contact No.] }
    { 4   ;   ;Campaign No.        ;Code20        ;TableRelation=Campaign;
                                                   OnValidate=BEGIN
                                                                IF xRec."Campaign No." <> "Campaign No." THEN
                                                                  SetCampaignTargetGroup;
                                                              END;

                                                   CaptionML=[DAN=Kampagnenr.;
                                                              ENU=Campaign No.] }
    { 5   ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=S�lgerkode;
                                                              ENU=Salesperson Code] }
    { 6   ;   ;Correspondence Type ;Option        ;OnValidate=VAR
                                                                Attachment@1000 : Record 5062;
                                                                ErrorText@1001 : Text[80];
                                                              BEGIN
                                                                IF NOT Attachment.GET("Attachment No.") THEN
                                                                  EXIT;

                                                                ErrorText := Attachment.CheckCorrespondenceType("Correspondence Type");
                                                                IF ErrorText <> '' THEN
                                                                  ERROR(
                                                                    STRSUBSTNO('%1%2',
                                                                      STRSUBSTNO(Text000,FIELDCAPTION("Correspondence Type"),"Correspondence Type",TABLECAPTION,"Line No."),
                                                                      ErrorText));
                                                              END;

                                                   CaptionML=[DAN=Korrespondancetype;
                                                              ENU=Correspondence Type];
                                                   OptionCaptionML=[DAN=" ,Papirformat,Mail,Telefax";
                                                                    ENU=" ,Hard Copy,Email,Fax"];
                                                   OptionString=[ ,Hard Copy,Email,Fax] }
    { 7   ;   ;Interaction Template Code;Code10   ;TableRelation="Interaction Template";
                                                   OnValidate=VAR
                                                                SegInteractLanguage@1001 : Record 5104;
                                                                InteractTemplLanguage@1002 : Record 5103;
                                                                InteractTmpl@1003 : Record 5064;
                                                              BEGIN
                                                                TESTFIELD("Contact No.");
                                                                Cont.GET("Contact No.");
                                                                "Attachment No." := 0;
                                                                "Language Code" := '';
                                                                Subject := '';
                                                                "Correspondence Type" := "Correspondence Type"::" ";
                                                                "Interaction Group Code" := '';
                                                                "Cost (LCY)" := 0;
                                                                "Duration (Min.)" := 0;
                                                                "Information Flow" := "Information Flow"::" ";
                                                                "Initiated By" := "Initiated By"::" ";
                                                                "Campaign Target" := FALSE;
                                                                "Campaign Response" := FALSE;
                                                                "Correspondence Type" := "Correspondence Type"::" ";
                                                                IF (GETFILTER("Campaign No.") = '') AND (InteractTmpl."Campaign No." <> '') THEN
                                                                  "Campaign No." := '';
                                                                MODIFY;

                                                                IF "Segment No." <> '' THEN BEGIN
                                                                  SegInteractLanguage.RESET;
                                                                  SegInteractLanguage.SETRANGE("Segment No.","Segment No.");
                                                                  SegInteractLanguage.SETRANGE("Segment Line No.","Line No.");
                                                                  SegInteractLanguage.DELETEALL(TRUE);
                                                                  GET("Segment No.","Line No.");
                                                                  IF "Interaction Template Code" <> '' THEN BEGIN
                                                                    SegHeader.GET("Segment No.");
                                                                    IF "Interaction Template Code" <> SegHeader."Interaction Template Code" THEN BEGIN
                                                                      SegHeader.CreateSegInteractions("Interaction Template Code","Segment No.","Line No.");
                                                                      "Language Code" := FindLanguage("Interaction Template Code",Cont."Language Code");
                                                                      IF SegInteractLanguage.GET("Segment No.","Line No.","Language Code") THEN
                                                                        "Attachment No." := SegInteractLanguage."Attachment No.";
                                                                    END ELSE BEGIN
                                                                      "Language Code" := FindLanguage("Interaction Template Code",Cont."Language Code");
                                                                      IF SegInteractLanguage.GET("Segment No.",0,"Language Code") THEN
                                                                        "Attachment No." := SegInteractLanguage."Attachment No.";
                                                                    END;
                                                                  END;
                                                                END ELSE BEGIN
                                                                  "Language Code" := FindLanguage("Interaction Template Code",Cont."Language Code");
                                                                  IF InteractTemplLanguage.GET("Interaction Template Code","Language Code") THEN
                                                                    "Attachment No." := InteractTemplLanguage."Attachment No.";
                                                                END;

                                                                IF InteractTmpl.GET("Interaction Template Code") THEN BEGIN
                                                                  "Interaction Group Code" := InteractTmpl."Interaction Group Code";
                                                                  IF Description = '' THEN
                                                                    Description := InteractTmpl.Description;
                                                                  IF EmailDraftLogging THEN BEGIN
                                                                    Subject := GetEmailDraftSubject;
                                                                    Description := EmailDraftTxt;
                                                                  END;
                                                                  "Cost (LCY)" := InteractTmpl."Unit Cost (LCY)";
                                                                  "Duration (Min.)" := InteractTmpl."Unit Duration (Min.)";
                                                                  "Information Flow" := InteractTmpl."Information Flow";
                                                                  "Initiated By" := InteractTmpl."Initiated By";
                                                                  "Campaign Target" := InteractTmpl."Campaign Target";
                                                                  "Campaign Response" := InteractTmpl."Campaign Response";

                                                                  CASE TRUE OF
                                                                    SegHeader."Ignore Contact Corres. Type" AND
                                                                    (SegHeader."Correspondence Type (Default)" <> SegHeader."Correspondence Type (Default)"::" "):
                                                                      "Correspondence Type" := SegHeader."Correspondence Type (Default)";
                                                                    InteractTmpl."Ignore Contact Corres. Type" OR
                                                                    ((InteractTmpl."Ignore Contact Corres. Type" = FALSE) AND
                                                                     (Cont."Correspondence Type" = Cont."Correspondence Type"::" ") AND
                                                                     (InteractTmpl."Correspondence Type (Default)" <> InteractTmpl."Correspondence Type (Default)"::" ")):
                                                                      "Correspondence Type" := InteractTmpl."Correspondence Type (Default)";
                                                                    ELSE
                                                                      IF Cont."Correspondence Type" <> Cont."Correspondence Type"::" " THEN
                                                                        "Correspondence Type" := Cont."Correspondence Type"
                                                                      ELSE
                                                                        "Correspondence Type" := xRec."Correspondence Type";
                                                                  END;
                                                                  IF SegHeader."Campaign No." <> '' THEN
                                                                    "Campaign No." := SegHeader."Campaign No."
                                                                  ELSE
                                                                    IF (GETFILTER("Campaign No.") = '') AND (InteractTmpl."Campaign No." <> '') THEN
                                                                      "Campaign No." := InteractTmpl."Campaign No.";
                                                                END;
                                                                IF Campaign.GET("Campaign No.") THEN
                                                                  "Campaign Description" := Campaign.Description;

                                                                MODIFY;
                                                              END;

                                                   CaptionML=[DAN=Interaktionsskabelonkode;
                                                              ENU=Interaction Template Code] }
    { 8   ;   ;Cost (LCY)          ;Decimal       ;CaptionML=[DAN=Kostbel�b (RV);
                                                              ENU=Cost (LCY)];
                                                   MinValue=0;
                                                   AutoFormatType=1 }
    { 9   ;   ;Duration (Min.)     ;Decimal       ;CaptionML=[DAN=Varighed (min.);
                                                              ENU=Duration (Min.)];
                                                   DecimalPlaces=0:0;
                                                   MinValue=0 }
    { 10  ;   ;Attachment No.      ;Integer       ;TableRelation=Attachment;
                                                   CaptionML=[DAN=Vedh�ftet fil nr.;
                                                              ENU=Attachment No.] }
    { 11  ;   ;Campaign Response   ;Boolean       ;CaptionML=[DAN=Kampagnereaktion;
                                                              ENU=Campaign Response] }
    { 12  ;   ;Contact Name        ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Contact.Name WHERE (No.=FIELD(Contact No.),
                                                                                          Type=CONST(Person)));
                                                   CaptionML=[DAN=Kontaktnavn;
                                                              ENU=Contact Name];
                                                   Editable=No }
    { 13  ;   ;Information Flow    ;Option        ;CaptionML=[DAN=Informationsstr�m;
                                                              ENU=Information Flow];
                                                   OptionCaptionML=[DAN=" ,Udg�ende,Indg�ende";
                                                                    ENU=" ,Outbound,Inbound"];
                                                   OptionString=[ ,Outbound,Inbound];
                                                   BlankZero=Yes }
    { 14  ;   ;Initiated By        ;Option        ;CaptionML=[DAN=Iv�rksat af;
                                                              ENU=Initiated By];
                                                   OptionCaptionML=[DAN=" ,Os,Dem";
                                                                    ENU=" ,Us,Them"];
                                                   OptionString=[ ,Us,Them];
                                                   BlankZero=Yes }
    { 15  ;   ;Contact Alt. Address Code;Code10   ;TableRelation="Contact Alt. Address".Code WHERE (Contact No.=FIELD(Contact No.));
                                                   CaptionML=[DAN=Kontaktens alt. adr.kode;
                                                              ENU=Contact Alt. Address Code] }
    { 16  ;   ;Evaluation          ;Option        ;CaptionML=[DAN=Vurdering;
                                                              ENU=Evaluation];
                                                   OptionCaptionML=[DAN=" ,Meget positiv,Positiv,Neutral,Negativ,Meget negativ";
                                                                    ENU=" ,Very Positive,Positive,Neutral,Negative,Very Negative"];
                                                   OptionString=[ ,Very Positive,Positive,Neutral,Negative,Very Negative] }
    { 17  ;   ;Campaign Target     ;Boolean       ;OnValidate=BEGIN
                                                                IF xRec."Campaign Target" <> "Campaign Target" THEN
                                                                  SetCampaignTargetGroup;
                                                              END;

                                                   CaptionML=[DAN=Kampagnem�lgruppe;
                                                              ENU=Campaign Target] }
    { 18  ;   ;Contact Company Name;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Contact.Name WHERE (No.=FIELD(Contact Company No.),
                                                                                          Type=CONST(Company)));
                                                   CaptionML=[DAN=Virksomhed;
                                                              ENU=Contact Company Name];
                                                   Editable=No }
    { 19  ;   ;Language Code       ;Code10        ;TableRelation=Language;
                                                   OnValidate=VAR
                                                                SegInteractLanguage@1002 : Record 5104;
                                                                InteractTemplLanguage@1001 : Record 5103;
                                                              BEGIN
                                                                TESTFIELD("Interaction Template Code");

                                                                IF "Language Code" = xRec."Language Code" THEN
                                                                  EXIT;

                                                                IF SegHeader.GET("Segment No.") THEN BEGIN
                                                                  IF NOT UniqueAttachmentExists THEN BEGIN
                                                                    IF SegInteractLanguage.GET("Segment No.",0,"Language Code") THEN BEGIN
                                                                      "Attachment No." := SegInteractLanguage."Attachment No.";
                                                                      Subject := SegInteractLanguage.Subject;
                                                                    END ELSE BEGIN
                                                                      "Attachment No." := 0;
                                                                      Subject := '';
                                                                    END;
                                                                  END ELSE
                                                                    IF SegInteractLanguage.GET("Segment No.","Line No.","Language Code") THEN BEGIN
                                                                      "Attachment No." := SegInteractLanguage."Attachment No.";
                                                                      Subject := SegInteractLanguage.Subject;
                                                                    END ELSE BEGIN
                                                                      "Attachment No." := 0;
                                                                      Subject := '';
                                                                    END;
                                                                  MODIFY;
                                                                END ELSE BEGIN
                                                                  InteractTemplLanguage.GET("Interaction Template Code","Language Code");
                                                                  SetInteractionAttachment;
                                                                END;
                                                              END;

                                                   OnLookup=BEGIN
                                                              LanguageCodeOnLookup;
                                                            END;

                                                   CaptionML=[DAN=Sprogkode;
                                                              ENU=Language Code] }
    { 22  ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 23  ;   ;Date                ;Date          ;OnValidate=BEGIN
                                                                IF Cont.GET("Contact No.") THEN
                                                                  IF "Contact Alt. Address Code" = Cont.ActiveAltAddress(xRec.Date) THEN
                                                                    "Contact Alt. Address Code" := Cont.ActiveAltAddress(Date);
                                                              END;

                                                   CaptionML=[DAN=Dato;
                                                              ENU=Date] }
    { 24  ;   ;Time of Interaction ;Time          ;CaptionML=[DAN=Interaktion oprettet;
                                                              ENU=Time of Interaction] }
    { 25  ;   ;Attempt Failed      ;Boolean       ;CaptionML=[DAN=Fors�g mislykket;
                                                              ENU=Attempt Failed] }
    { 26  ;   ;To-do No.           ;Code20        ;TableRelation=To-do;
                                                   CaptionML=[DAN=Opgavenr.;
                                                              ENU=Task No.] }
    { 27  ;   ;Contact Company No. ;Code20        ;TableRelation=Contact WHERE (Type=CONST(Company));
                                                   CaptionML=[DAN=Virksomhedsnummer;
                                                              ENU=Contact Company No.] }
    { 28  ;   ;Campaign Entry No.  ;Integer       ;TableRelation="Campaign Entry";
                                                   CaptionML=[DAN=Kampagnepostl�benr.;
                                                              ENU=Campaign Entry No.];
                                                   Editable=No }
    { 29  ;   ;Interaction Group Code;Code10      ;TableRelation="Interaction Group";
                                                   CaptionML=[DAN=Interaktionsgruppekode;
                                                              ENU=Interaction Group Code] }
    { 31  ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Salgstilbud,Rammesalgsordre,Salgsordrebekr�ft.,Salgsfakt.,Salgslev.nota,Salgskreditnota,Salgskontoudtog,Rykker (salg),Opret. serviceordre,Bogf. serviceordre,K�bsrekvisition,Rammek�bsordre,K�bsordre,K�bsfakt.,K�bsmodtag.,K�bskreditnota,F�lgebrev";
                                                                    ENU=" ,Sales Qte.,Sales Blnkt. Ord,Sales Ord. Cnfrmn.,Sales Inv.,Sales Shpt. Note,Sales Cr. Memo,Sales Stmnt.,Sales Rmdr.,Serv. Ord. Create,Serv. Ord. Post,Purch.Qte.,Purch. Blnkt. Ord.,Purch. Ord.,Purch. Inv.,Purch. Rcpt.,Purch. Cr. Memo,Cover Sheet"];
                                                   OptionString=[ ,Sales Qte.,Sales Blnkt. Ord,Sales Ord. Cnfrmn.,Sales Inv.,Sales Shpt. Note,Sales Cr. Memo,Sales Stmnt.,Sales Rmdr.,Serv. Ord. Create,Serv. Ord. Post,Purch.Qte.,Purch. Blnkt. Ord.,Purch. Ord.,Purch. Inv.,Purch. Rcpt.,Purch. Cr. Memo,Cover Sheet] }
    { 32  ;   ;Document No.        ;Code20        ;TestTableRelation=No;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 33  ;   ;Send Word Doc. As Attmt.;Boolean   ;CaptionML=[DAN=Send Word-dokument vedh�ftet;
                                                              ENU=Send Word Doc. As Attmt.] }
    { 34  ;   ;Contact Via         ;Text80        ;CaptionML=[DAN=Kontaktens tlf.nr.;
                                                              ENU=Contact Via] }
    { 35  ;   ;Version No.         ;Integer       ;CaptionML=[DAN=Versionsnr.;
                                                              ENU=Version No.] }
    { 36  ;   ;Doc. No. Occurrence ;Integer       ;CaptionML=[DAN=Forekomster af dok.nr.;
                                                              ENU=Doc. No. Occurrence] }
    { 37  ;   ;Subject             ;Text50        ;CaptionML=[DAN=Emne;
                                                              ENU=Subject] }
    { 44  ;   ;Opportunity No.     ;Code20        ;TableRelation=Opportunity;
                                                   CaptionML=[DAN=Salgsmulighednummer;
                                                              ENU=Opportunity No.] }
    { 9501;   ;Wizard Step         ;Option        ;CaptionML=[DAN=Trin i guide;
                                                              ENU=Wizard Step];
                                                   OptionCaptionML=[DAN=" ,1,2,3,4,5,6";
                                                                    ENU=" ,1,2,3,4,5,6"];
                                                   OptionString=[ ,1,2,3,4,5,6];
                                                   Editable=No }
    { 9502;   ;Wizard Contact Name ;Text50        ;CaptionML=[DAN=Kontaktnavn for guide;
                                                              ENU=Wizard Contact Name] }
    { 9503;   ;Opportunity Description;Text50     ;CaptionML=[DAN=Salgsmulighedbeskrivelse;
                                                              ENU=Opportunity Description] }
    { 9504;   ;Campaign Description;Text50        ;CaptionML=[DAN=Kampagnebeskrivelse;
                                                              ENU=Campaign Description] }
    { 9505;   ;Interaction Successful;Boolean     ;CaptionML=[DAN=Interaktionen er fuldf�rt;
                                                              ENU=Interaction Successful] }
    { 9506;   ;Dial Contact        ;Boolean       ;CaptionML=[DAN=Ring til kontakt;
                                                              ENU=Dial Contact] }
    { 9507;   ;Mail Contact        ;Boolean       ;CaptionML=[DAN=Send mail til kontakt;
                                                              ENU=Mail Contact] }
  }
  KEYS
  {
    {    ;Segment No.,Line No.                    ;SumIndexFields=Cost (LCY),Duration (Min.);
                                                   Clustered=Yes }
    {    ;Segment No.,Campaign No.,Date            }
    {    ;Contact No.,Segment No.                  }
    {    ;Campaign No.                             }
    {    ;Campaign No.,Contact Company No.,Campaign Target }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN="%1 = %2 kan ikke angives for %3 %4.\";ENU="%1 = %2 can not be specified for %3 %4.\"';
      Text001@1001 : TextConst 'DAN=Overf�rt;ENU=Inherited';
      Text002@1002 : TextConst 'DAN=Entydig;ENU=Unique';
      SegHeader@1006 : Record 5076;
      Cont@1007 : Record 5050;
      Salesperson@1008 : Record 13;
      Campaign@1013 : Record 5071;
      InteractTmpl@1003 : Record 5064;
      Attachment@1005 : Record 5062;
      TempAttachment@1004 : TEMPORARY Record 5062;
      InterLogEntryCommentLine@1017 : Record 5123;
      TempInterLogEntryCommentLine@1018 : TEMPORARY Record 5123;
      AttachmentManagement@1010 : Codeunit 5052;
      ClientTypeManagement@1077 : Codeunit 4;
      Text005@1023 : TextConst 'DAN=Feltet %1 skal udfyldes.;ENU=You must fill in the %1 field.';
      Text004@1012 : TextConst 'DAN=Indl�sningen af den vedh�ftede fil blev afbrudt efter din anmodning.;ENU=The program has stopped importing the attachment at your request.';
      Text006@1011 : TextConst 'DAN=M�lgruppen er tom.\Vil du nulstille antallet af kriteriehandlinger?;ENU=Your Segment is now empty.\Do you want to reset number of criteria actions?';
      CampaignTargetGrMgt@1014 : Codeunit 7030;
      Mail@1020 : Codeunit 397;
      ResumedAttachmentNo@1015 : Integer;
      Text007@1016 : TextConst 'DAN=Vil du afslutte denne interaktion p� et senere tidspunkt?;ENU=Do you want to finish this interaction later?';
      Text008@1022 : TextConst 'DAN=Du skal v�lge en interaktionsskabelon med en vedh�ftet fil.;ENU=You must select an interaction template with an attachment.';
      Text009@1025 : TextConst 'DAN=Du skal v�lge en kontakt, du vil henvende dig til.;ENU=You must select a contact to interact with.';
      Text013@1024 : TextConst 'DAN=Du skal angive telefonnummeret.;ENU=You must fill in the phone number.';
      Text024@1032 : TextConst '@@@="%1=Correspondence Type";DAN="%1 = %2 kan ikke angives.";ENU="%1 = %2 cannot be specified."';
      Text025@1033 : TextConst '@@@=%2 - product name;DAN=Mailen kunne ikke sendes pga. f�lgende fejl: %1.\Bem�rk: Hvis du k�rer %2 som administrator, skal du ogs� k�re Outlook som administrator.;ENU=The email could not be sent because of the following error: %1.\Note: if you run %2 as administrator, you must run Outlook as administrator as well.';
      EmailDraftTxt@1019 : TextConst 'DAN=Mailkladde;ENU=Email Draft';

    [External]
    PROCEDURE InitLine@1();
    BEGIN
      IF SegHeader.GET("Segment No.") THEN BEGIN
        Description := SegHeader.Description;
        "Campaign No." := SegHeader."Campaign No.";
        "Salesperson Code" := SegHeader."Salesperson Code";
        "Correspondence Type" := SegHeader."Correspondence Type (Default)";
        "Interaction Template Code" := SegHeader."Interaction Template Code";
        "Interaction Group Code" := SegHeader."Interaction Group Code";
        "Cost (LCY)" := SegHeader."Unit Cost (LCY)";
        "Duration (Min.)" := SegHeader."Unit Duration (Min.)";
        "Attachment No." := SegHeader."Attachment No.";
        Date := SegHeader.Date;
        "Campaign Target" := SegHeader."Campaign Target";
        "Information Flow" := SegHeader."Information Flow";
        "Initiated By" := SegHeader."Initiated By";
        "Campaign Response" := SegHeader."Campaign Response";
        "Send Word Doc. As Attmt." := SegHeader."Send Word Docs. as Attmt.";
        CLEAR(Evaluation);
      END;
    END;

    [External]
    PROCEDURE AttachmentText@5() : Text[30];
    BEGIN
      IF AttachmentInherited THEN
        EXIT(Text001);

      IF "Attachment No." <> 0 THEN
        EXIT(Text002);

      EXIT('');
    END;

    [Internal]
    PROCEDURE MaintainAttachment@9();
    VAR
      Cont@1000 : Record 5050;
      SalutationFormula@1001 : Record 5069;
    BEGIN
      TESTFIELD("Interaction Template Code");

      Cont.GET("Contact No.");
      IF SalutationFormula.GET(Cont."Salutation Code","Language Code",0) THEN;
      IF SalutationFormula.GET(Cont."Salutation Code","Language Code",1) THEN;

      IF "Attachment No." <> 0 THEN
        OpenAttachment
      ELSE
        CreateAttachment;
    END;

    [Internal]
    PROCEDURE CreateAttachment@8();
    VAR
      SegInteractLanguage@1003 : Record 5104;
    BEGIN
      IF NOT SegInteractLanguage.GET("Segment No.","Line No.","Language Code") THEN BEGIN
        SegInteractLanguage.INIT;
        SegInteractLanguage."Segment No." := "Segment No.";
        SegInteractLanguage."Segment Line No." := "Line No.";
        SegInteractLanguage."Language Code" := "Language Code";
        SegInteractLanguage.Description := Description;
        SegInteractLanguage.Subject := Subject;
      END;

      SegInteractLanguage.CreateAttachment;
    END;

    [Internal]
    PROCEDURE OpenAttachment@2();
    VAR
      Attachment@1004 : Record 5062;
      Attachment2@1003 : Record 5062;
      SegInteractLanguage@1002 : Record 5104;
      NewAttachmentNo@1000 : Integer;
    BEGIN
      IF "Attachment No." = 0 THEN
        EXIT;

      Attachment.GET("Attachment No.");
      Attachment2 := Attachment;

      Attachment2.ShowAttachment(Rec,"Segment No." + ' ' + Description,FALSE,TRUE);

      IF AttachmentInherited THEN BEGIN
        NewAttachmentNo := Attachment2."No.";
        IF (Attachment."Last Date Modified" <> Attachment2."Last Date Modified") OR
           (Attachment."Last Time Modified" <> Attachment2."Last Time Modified")
        THEN BEGIN
          SegInteractLanguage.INIT;
          SegInteractLanguage."Segment No." := "Segment No.";
          SegInteractLanguage."Segment Line No." := "Line No.";
          SegInteractLanguage."Language Code" := "Language Code";
          SegInteractLanguage.Description := Description;
          SegInteractLanguage.Subject := Subject;
          SegInteractLanguage."Attachment No." := NewAttachmentNo;
          SegInteractLanguage.INSERT(TRUE);
          GET("Segment No.","Line No.");
          "Attachment No." := NewAttachmentNo;
          MODIFY;
        END;
      END
    END;

    [Internal]
    PROCEDURE ImportAttachment@3();
    VAR
      SegInteractLanguage@1003 : Record 5104;
    BEGIN
      IF NOT SegInteractLanguage.GET("Segment No.","Line No.","Language Code") THEN BEGIN
        SegInteractLanguage.INIT;
        SegInteractLanguage."Segment No." := "Segment No.";
        SegInteractLanguage."Segment Line No." := "Line No.";
        SegInteractLanguage."Language Code" := "Language Code";
        SegInteractLanguage.Description := Description;
        SegInteractLanguage.INSERT(TRUE);
      END;
      SegInteractLanguage.ImportAttachment;
    END;

    [Internal]
    PROCEDURE ExportAttachment@4();
    VAR
      SegInteractLanguage@1000 : Record 5104;
    BEGIN
      IF UniqueAttachmentExists THEN BEGIN
        IF SegInteractLanguage.GET("Segment No.","Line No.","Language Code") THEN
          IF SegInteractLanguage."Attachment No." <> 0 THEN
            SegInteractLanguage.ExportAttachment;
      END ELSE
        IF SegInteractLanguage.GET("Segment No.",0,"Language Code") THEN
          IF SegInteractLanguage."Attachment No." <> 0 THEN
            SegInteractLanguage.ExportAttachment;
    END;

    [External]
    PROCEDURE RemoveAttachment@7();
    VAR
      SegInteractLanguage@1002 : Record 5104;
    BEGIN
      IF SegInteractLanguage.GET("Segment No.","Line No.","Language Code") THEN BEGIN
        SegInteractLanguage.DELETE(TRUE);
        GET("Segment No.","Line No.");
      END;
      "Attachment No." := 0;
    END;

    [External]
    PROCEDURE CreatePhoneCall@21();
    VAR
      TempSegmentLine@1000 : TEMPORARY Record 5077;
    BEGIN
      Cont.GET("Contact No.");
      TempSegmentLine."Contact No." := Cont."No.";
      TempSegmentLine."Contact Via" := Cont."Phone No.";
      TempSegmentLine."Contact Company No." := Cont."Company No.";
      TempSegmentLine."To-do No." := "To-do No.";
      TempSegmentLine."Salesperson Code" := "Salesperson Code";
      IF "Contact Alt. Address Code" <> '' THEN
        TempSegmentLine."Contact Alt. Address Code" := "Contact Alt. Address Code";
      IF "Campaign No." <> '' THEN
        TempSegmentLine."Campaign No." := "Campaign No.";

      TempSegmentLine."Campaign Target" := "Campaign Target";
      TempSegmentLine."Campaign Response" := "Campaign Response";
      TempSegmentLine.SETRANGE("Contact No.",TempSegmentLine."Contact No.");
      TempSegmentLine.SETRANGE("Campaign No.",TempSegmentLine."Campaign No.");

      TempSegmentLine.StartWizard2;
    END;

    LOCAL PROCEDURE FindLanguage@10(InteractTmplCode@1001 : Code[10];ContactLanguageCode@1000 : Code[10]) Language@1005 : Code[10];
    VAR
      SegInteractLanguage@1004 : Record 5104;
      InteractTemplLanguage@1003 : Record 5103;
      InteractTmpl@1002 : Record 5064;
    BEGIN
      IF SegHeader.GET("Segment No.") THEN BEGIN
        IF NOT UniqueAttachmentExists AND
           ("Interaction Template Code" = SegHeader."Interaction Template Code")
        THEN BEGIN
          IF SegInteractLanguage.GET("Segment No.",0,ContactLanguageCode) THEN
            Language := ContactLanguageCode
          ELSE
            Language := SegHeader."Language Code (Default)";
        END ELSE
          IF SegInteractLanguage.GET("Segment No.","Line No.",ContactLanguageCode) THEN
            Language := ContactLanguageCode
          ELSE BEGIN
            InteractTmpl.GET(InteractTmplCode);
            IF SegInteractLanguage.GET("Segment No.","Line No.",InteractTmpl."Language Code (Default)") THEN
              Language := InteractTmpl."Language Code (Default)"
            ELSE BEGIN
              SegInteractLanguage.SETRANGE("Segment No.","Segment No.");
              SegInteractLanguage.SETRANGE("Segment Line No.","Line No.");
              IF SegInteractLanguage.FINDFIRST THEN
                Language := SegInteractLanguage."Language Code";
            END;
          END;
      END ELSE BEGIN  // Create Interaction:
        IF InteractTemplLanguage.GET(InteractTmplCode,ContactLanguageCode) THEN
          Language := ContactLanguageCode
        ELSE
          IF InteractTmpl.GET(InteractTmplCode) THEN
            Language := InteractTmpl."Language Code (Default)";
      END;
    END;

    PROCEDURE AttachmentInherited@12() : Boolean;
    VAR
      SegInteractLanguage@1000 : Record 5104;
    BEGIN
      IF "Attachment No." = 0 THEN
        EXIT(FALSE);
      IF NOT SegHeader.GET("Segment No.") THEN
        EXIT(FALSE);
      IF "Interaction Template Code" = '' THEN
        EXIT(FALSE);

      SegInteractLanguage.SETRANGE("Segment No.","Segment No.");
      SegInteractLanguage.SETRANGE("Segment Line No.","Line No.");
      SegInteractLanguage.SETRANGE("Language Code","Language Code");
      SegInteractLanguage.SETRANGE("Attachment No.","Attachment No.");
      IF NOT SegInteractLanguage.ISEMPTY THEN
        EXIT(FALSE);

      SegInteractLanguage.SETRANGE("Segment Line No.",0);
      EXIT(NOT SegInteractLanguage.ISEMPTY);
    END;

    [External]
    PROCEDURE SetInteractionAttachment@13();
    VAR
      Attachment@1001 : Record 5062;
      InteractTemplLanguage@1000 : Record 5103;
    BEGIN
      IF InteractTemplLanguage.GET("Interaction Template Code","Language Code") THEN BEGIN
        IF Attachment.GET(InteractTemplLanguage."Attachment No.") THEN
          "Attachment No." := InteractTemplLanguage."Attachment No."
        ELSE
          "Attachment No." := 0;
      END;
      MODIFY;
    END;

    LOCAL PROCEDURE UniqueAttachmentExists@14() : Boolean;
    VAR
      SegInteractLanguage@1000 : Record 5104;
    BEGIN
      IF "Line No." <> 0 THEN BEGIN
        SegInteractLanguage.SETRANGE("Segment No.","Segment No.");
        SegInteractLanguage.SETRANGE("Segment Line No.","Line No.");
        EXIT(NOT SegInteractLanguage.ISEMPTY);
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE SetCampaignTargetGroup@15();
    BEGIN
      IF Campaign.GET(xRec."Campaign No.") THEN BEGIN
        Campaign.CALCFIELDS(Activated);
        IF Campaign.Activated THEN
          CampaignTargetGrMgt.DeleteSegfromTargetGr(xRec);
      END;

      IF Campaign.GET("Campaign No.") THEN BEGIN
        Campaign.CALCFIELDS(Activated);
        IF Campaign.Activated THEN
          CampaignTargetGrMgt.AddSegLinetoTargetGr(Rec);
      END;
    END;

    [External]
    PROCEDURE CopyFromInteractLogEntry@52(VAR InteractLogEntry@1001 : Record 5065);
    BEGIN
      "Line No." := InteractLogEntry."Entry No.";
      "Contact No." := InteractLogEntry."Contact No.";
      "Contact Company No." := InteractLogEntry."Contact Company No.";
      Date := InteractLogEntry.Date;
      Description := InteractLogEntry.Description;
      "Information Flow" := InteractLogEntry."Information Flow";
      "Initiated By" := InteractLogEntry."Initiated By";
      "Attachment No." := InteractLogEntry."Attachment No.";
      "Cost (LCY)" := InteractLogEntry."Cost (LCY)";
      "Duration (Min.)" := InteractLogEntry."Duration (Min.)";
      "Interaction Group Code" := InteractLogEntry."Interaction Group Code";
      "Interaction Template Code" := InteractLogEntry."Interaction Template Code";
      "Language Code" := InteractLogEntry."Interaction Language Code";
      Subject := InteractLogEntry.Subject;
      "Campaign No." := InteractLogEntry."Campaign No.";
      "Campaign Entry No." := InteractLogEntry."Campaign Entry No.";
      "Campaign Response" := InteractLogEntry."Campaign Response";
      "Campaign Target" := InteractLogEntry."Campaign Target";
      "Segment No." := InteractLogEntry."Segment No.";
      Evaluation := InteractLogEntry.Evaluation;
      "Time of Interaction" := InteractLogEntry."Time of Interaction";
      "Attempt Failed" := InteractLogEntry."Attempt Failed";
      "To-do No." := InteractLogEntry."To-do No.";
      "Salesperson Code" := InteractLogEntry."Salesperson Code";
      "Correspondence Type" := InteractLogEntry."Correspondence Type";
      "Contact Alt. Address Code" := InteractLogEntry."Contact Alt. Address Code";
      "Document Type" := InteractLogEntry."Document Type";
      "Document No." := InteractLogEntry."Document No.";
      "Doc. No. Occurrence" := InteractLogEntry."Doc. No. Occurrence";
      "Version No." := InteractLogEntry."Version No.";
      "Send Word Doc. As Attmt." := InteractLogEntry."Send Word Docs. as Attmt.";
      "Contact Via" := InteractLogEntry."Contact Via";
      "Opportunity No." := InteractLogEntry."Opportunity No.";

      OnAfterCopyFromInteractionLogEntry(Rec,InteractLogEntry);
    END;

    PROCEDURE CreateInteractionFromContact@38(VAR Contact@1000 : Record 5050);
    BEGIN
      DELETEALL;
      INIT;
      IF Contact.Type = Contact.Type::Person THEN
        SETRANGE("Contact Company No.",Contact."Company No.");
      SETRANGE("Contact No.",Contact."No.");
      VALIDATE("Contact No.",Contact."No.");

      "Salesperson Code" := FindSalespersonByUserEmail;
      IF "Salesperson Code" = '' THEN
        "Salesperson Code" := Contact."Salesperson Code";
      StartWizard;
    END;

    [External]
    PROCEDURE CreateInteractionFromSalesperson@39(VAR Salesperson@1000 : Record 13);
    BEGIN
      DELETEALL;
      INIT;
      VALIDATE("Salesperson Code",Salesperson.Code);
      SETRANGE("Salesperson Code",Salesperson.Code);
      StartWizard;
    END;

    [External]
    PROCEDURE CreateInteractionFromInteractLogEntry@42(VAR InteractionLogEntry@1000 : Record 5065);
    VAR
      Cont@1005 : Record 5050;
      Salesperson@1004 : Record 13;
      Campaign@1003 : Record 5071;
      Task@1002 : Record 5080;
      Opportunity@1001 : Record 5092;
    BEGIN
      IF Task.GET(InteractionLogEntry.GETFILTER("To-do No.")) THEN BEGIN
        CreateFromTask(Task);
        SETRANGE("To-do No.","To-do No.");
      END ELSE BEGIN
        IF Cont.GET(InteractionLogEntry.GETFILTER("Contact Company No.")) THEN BEGIN
          VALIDATE("Contact No.",Cont."Company No.");
          SETRANGE("Contact No.","Contact No.");
        END;
        IF Cont.GET(InteractionLogEntry.GETFILTER("Contact No.")) THEN BEGIN
          VALIDATE("Contact No.",Cont."No.");
          SETRANGE("Contact No.","Contact No.");
        END;
        IF Salesperson.GET(InteractionLogEntry.GETFILTER("Salesperson Code")) THEN BEGIN
          "Salesperson Code" := Salesperson.Code;
          SETRANGE("Salesperson Code","Salesperson Code");
        END;
        IF Campaign.GET(InteractionLogEntry.GETFILTER("Campaign No.")) THEN BEGIN
          "Campaign No." := Campaign."No.";
          SETRANGE("Campaign No.","Campaign No.");
        END;
        IF Opportunity.GET(InteractionLogEntry.GETFILTER("Opportunity No.")) THEN BEGIN
          "Opportunity No." := Opportunity."No.";
          SETRANGE("Opportunity No.","Opportunity No.");
        END;
      END;
      StartWizard;
    END;

    [External]
    PROCEDURE CreateInteractionFromTask@43(VAR Task@1000 : Record 5080);
    BEGIN
      INIT;
      CreateFromTask(Task);
      SETRANGE("To-do No.","To-do No.");
      StartWizard;
    END;

    [External]
    PROCEDURE CreateInteractionFromOpp@129(VAR Opportunity@1000 : Record 5092);
    VAR
      Contact@1001 : Record 5050;
      Salesperson@1002 : Record 13;
      Campaign@1003 : Record 5071;
    BEGIN
      INIT;
      IF Contact.GET(Opportunity."Contact Company No.") THEN BEGIN
        Contact.CheckIfPrivacyBlockedGeneric;
        VALIDATE("Contact No.",Contact."Company No.");
        SETRANGE("Contact No.","Contact No.");
      END;
      IF Contact.GET(Opportunity."Contact No.") THEN BEGIN
        Contact.CheckIfPrivacyBlockedGeneric;
        VALIDATE("Contact No.",Contact."No.");
        SETRANGE("Contact No.","Contact No.");
      END;
      IF Salesperson.GET(Opportunity."Salesperson Code") THEN BEGIN
        VALIDATE("Salesperson Code",Salesperson.Code);
        SETRANGE("Salesperson Code","Salesperson Code");
      END;
      IF Campaign.GET(Opportunity."Campaign No.") THEN BEGIN
        VALIDATE("Campaign No.",Campaign."No.");
        SETRANGE("Campaign No.","Campaign No.");
      END;
      VALIDATE("Opportunity No.",Opportunity."No.");
      SETRANGE("Opportunity No.","Opportunity No.");
      StartWizard;
    END;

    [External]
    PROCEDURE CreateOpportunity@32() : Code[20];
    VAR
      Opportunity@1000 : Record 5092;
    BEGIN
      Opportunity.CreateFromSegmentLine(Rec);
      EXIT(Opportunity."No.");
    END;

    LOCAL PROCEDURE CreateFromTask@37(Task@1000 : Record 5080);
    BEGIN
      "To-do No." := Task."No.";
      VALIDATE("Contact No.",Task."Contact No.");
      "Salesperson Code" := Task."Salesperson Code";
      "Campaign No." := Task."Campaign No.";
      "Opportunity No." := Task."Opportunity No.";
    END;

    LOCAL PROCEDURE GetContactName@41() : Text[50];
    VAR
      Cont@1000 : Record 5050;
    BEGIN
      IF Cont.GET("Contact No.") THEN
        EXIT(Cont.Name);
      IF Cont.GET("Contact Company No.") THEN
        EXIT(Cont.Name);
    END;

    [External]
    PROCEDURE StartWizard@33();
    VAR
      Opp@1000 : Record 5092;
      RelationshipPerformanceMgt@1001 : Codeunit 783;
    BEGIN
      IF Campaign.GET("Campaign No.") THEN
        "Campaign Description" := Campaign.Description;
      IF Opp.GET("Opportunity No.") THEN
        "Opportunity Description" := Opp.Description;
      "Wizard Contact Name" := GetContactName;
      "Wizard Step" := "Wizard Step"::"1";
      "Interaction Successful" := TRUE;
      VALIDATE(Date,WORKDATE);
      "Time of Interaction" := DT2TIME(ROUNDDATETIME(CURRENTDATETIME + 1000,60000,'>'));
      INSERT;

      IF PAGE.RUNMODAL(PAGE::"Create Interaction",Rec,"Interaction Template Code") = ACTION::OK THEN;
      IF "Wizard Step" = "Wizard Step"::"6" THEN
        RelationshipPerformanceMgt.SendCreateOpportunityNotification(Rec);
    END;

    [Internal]
    PROCEDURE CheckStatus@16();
    VAR
      InteractTmpl@1000 : Record 5064;
      Attachment@1001 : Record 5062;
      SalutationFormula@1002 : Record 5069;
    BEGIN
      IF "Contact No." = '' THEN
        ERROR(Text009);
      IF "Interaction Template Code" = '' THEN
        ErrorMessage(FIELDCAPTION("Interaction Template Code"));
      IF "Salesperson Code" = '' THEN
        ErrorMessage(FIELDCAPTION("Salesperson Code"));
      IF Date = 0D THEN
        ErrorMessage(FIELDCAPTION(Date));
      IF Description = '' THEN
        ErrorMessage(FIELDCAPTION(Description));

      InteractTmpl.GET("Interaction Template Code");
      IF InteractTmpl."Wizard Action" = InteractTmpl."Wizard Action"::Open THEN
        IF "Attachment No." = 0 THEN
          ErrorMessage(Attachment.TABLECAPTION);

      Cont.GET("Contact No.");
      IF SalutationFormula.GET(Cont."Salutation Code","Language Code",0) THEN;
      IF SalutationFormula.GET(Cont."Salutation Code","Language Code",1) THEN;

      IF TempAttachment.FINDFIRST THEN
        TempAttachment.CALCFIELDS("Attachment File");
      IF ("Correspondence Type" = "Correspondence Type"::Email) AND
         NOT TempAttachment."Attachment File".HASVALUE
      THEN
        ERROR(Text008);
    END;

    PROCEDURE FinishWizard@18(IsFinish@1000 : Boolean);
    VAR
      InteractionLogEntry@1003 : Record 5065;
      SegManagement@1002 : Codeunit 5051;
      send@1001 : Boolean;
      Flag@1102601000 : Boolean;
      HTMLAttachment@1006 : Boolean;
      HTMLContentBodyText@1004 : Text;
      CustomLayoutCode@1005 : Code[20];
    BEGIN
      HTMLAttachment := IsHTMLAttachment;
      Flag := FALSE;
      IF IsFinish THEN
        Flag := TRUE
      ELSE
        Flag := CONFIRM(Text007);

      IF Flag THEN BEGIN
        CheckStatus;

        IF "Opportunity No." = '' THEN
          "Wizard Step" := "Wizard Step"::"6";

        IF NOT HTMLAttachment THEN
          HandleTrigger;

        "Attempt Failed" := NOT "Interaction Successful";
        Subject := Description;
        IF NOT HTMLAttachment THEN
          ProcessPostponedAttachment;
        send := (IsFinish AND ("Correspondence Type" <> "Correspondence Type"::" "));
        IF send AND HTMLAttachment THEN BEGIN
          TempAttachment.ReadHTMLCustomLayoutAttachment(HTMLContentBodyText,CustomLayoutCode);
          AttachmentManagement.GenerateHTMLContent(TempAttachment,Rec);
        END;
        SegManagement.LogInteraction(Rec,TempAttachment,TempInterLogEntryCommentLine,send,NOT IsFinish);
        InteractionLogEntry.FINDLAST;
        IF send AND (InteractionLogEntry."Delivery Status" = InteractionLogEntry."Delivery Status"::Error) THEN BEGIN
          IF HTMLAttachment THEN BEGIN
            CLEAR(TempAttachment);
            LoadTempAttachment(FALSE);
            TempAttachment.WriteHTMLCustomLayoutAttachment(HTMLContentBodyText,CustomLayoutCode);
            COMMIT;
          END;
          IF NOT (ClientTypeManagement.GetCurrentClientType IN [CLIENTTYPE::Web,CLIENTTYPE::Tablet,CLIENTTYPE::Phone]) THEN
            IF Mail.GetErrorDesc <> '' THEN
              ERROR(Text025,Mail.GetErrorDesc,PRODUCTNAME.FULL);
        END;
      END
    END;

    LOCAL PROCEDURE ErrorMessage@17(FieldName@1000 : Text[1024]);
    BEGIN
      ERROR(Text005,FieldName);
    END;

    [External]
    PROCEDURE ValidateCorrespondenceType@47();
    VAR
      ErrorText@1000 : Text[80];
    BEGIN
      IF "Correspondence Type" <> "Correspondence Type"::" " THEN
        IF TempAttachment.FINDFIRST THEN BEGIN
          ErrorText := TempAttachment.CheckCorrespondenceType("Correspondence Type");
          IF ErrorText <> '' THEN
            ERROR(
              Text024 + ErrorText,
              FIELDCAPTION("Correspondence Type"),"Correspondence Type");
        END;
    END;

    LOCAL PROCEDURE HandleTrigger@20();
    VAR
      TempBlob@1005 : Record 99008535;
      FileMgt@1003 : Codeunit 419;
      ImportedFileName@1000 : Text;
    BEGIN
      InteractTmpl.GET("Interaction Template Code");

      CASE InteractTmpl."Wizard Action" OF
        InteractTmpl."Wizard Action"::" ":
          IF "Attachment No." <> 0 THEN BEGIN
            LoadTempAttachment(FALSE);
            Subject := Description;
            TempAttachment.RunAttachment(Rec,Description,TRUE,FALSE,FALSE);
          END;
        InteractTmpl."Wizard Action"::Open:
          BEGIN
            TESTFIELD("Attachment No.");
            LoadTempAttachment(FALSE);
            Subject := Description;
            TempAttachment.ShowAttachment(Rec,Description,TRUE,FALSE);
          END;
        InteractTmpl."Wizard Action"::Import:
          BEGIN
            ImportedFileName := FileMgt.BLOBImport(TempBlob,ImportedFileName);
            IF ImportedFileName = '' THEN
              MESSAGE(Text004)
            ELSE BEGIN
              TempAttachment.DELETEALL;
              TempAttachment."Attachment File" := TempBlob.Blob;
              TempAttachment."File Extension" := COPYSTR(FileMgt.GetExtension(ImportedFileName),1,250);
              TempAttachment.INSERT;
            END;
          END;
      END;
    END;

    LOCAL PROCEDURE LoadTempAttachment@22(ForceReload@1000 : Boolean);
    BEGIN
      IF NOT ForceReload AND TempAttachment."Attachment File".HASVALUE THEN
        EXIT;
      Attachment.GET("Attachment No.");
      Attachment.CALCFIELDS("Attachment File");
      TempAttachment.DELETEALL;
      TempAttachment.WizEmbeddAttachment(Attachment);
      TempAttachment."No." := 0;
      TempAttachment."Read Only" := FALSE;
      IF Attachment.IsHTML THEN
        TempAttachment."File Extension" := Attachment."File Extension";
      TempAttachment.INSERT;
    END;

    [External]
    PROCEDURE LoadContentBodyTextFromCustomLayoutAttachment@6() : Text;
    VAR
      ContentBodyText@1001 : Text;
      CustomLayoutCode@1000 : Code[20];
    BEGIN
      TempAttachment.ReadHTMLCustomLayoutAttachment(ContentBodyText,CustomLayoutCode);
      EXIT(ContentBodyText);
    END;

    [External]
    PROCEDURE UpdateContentBodyTextInCustomLayoutAttachment@28(NewContentBodyText@1007 : Text);
    VAR
      OldContentBodyText@1000 : Text;
      CustomLayoutCode@1001 : Code[20];
    BEGIN
      TempAttachment.FIND;
      TempAttachment.ReadHTMLCustomLayoutAttachment(OldContentBodyText,CustomLayoutCode);
      TempAttachment.WriteHTMLCustomLayoutAttachment(NewContentBodyText,CustomLayoutCode);
    END;

    LOCAL PROCEDURE ProcessPostponedAttachment@19();
    BEGIN
      IF "Attachment No." <> 0 THEN BEGIN
        LoadTempAttachment(FALSE);
        IF "Line No." <> 0 THEN
          "Attachment No." := ResumedAttachmentNo;
      END ELSE
        IF Attachment.GET(ResumedAttachmentNo) THEN
          Attachment.RemoveAttachment(FALSE);
    END;

    PROCEDURE LoadAttachment@24(ForceReload@1000 : Boolean);
    BEGIN
      IF "Line No." <> 0 THEN BEGIN
        InterLogEntryCommentLine.SETRANGE("Entry No.","Line No.");
        IF InterLogEntryCommentLine.FIND('-') THEN
          REPEAT
            TempInterLogEntryCommentLine.INIT;
            TempInterLogEntryCommentLine.TRANSFERFIELDS(InterLogEntryCommentLine,FALSE);
            TempInterLogEntryCommentLine."Line No." := InterLogEntryCommentLine."Line No.";
            TempInterLogEntryCommentLine.INSERT;
          UNTIL InterLogEntryCommentLine.NEXT = 0;
        ResumedAttachmentNo := "Attachment No.";
      END;
      IF "Attachment No." <> 0 THEN
        LoadTempAttachment(ForceReload)
      ELSE BEGIN
        TempAttachment.DELETEALL;
        CLEAR(TempAttachment);
      END;
    END;

    [External]
    PROCEDURE MakePhoneCallFromContact@45(VAR Cont@1000 : Record 5050;Task@1001 : Record 5080;TableNo@1005 : Integer;PhoneNo@1003 : Text[30];ContAltAddrCode@1002 : Code[10]);
    BEGIN
      INIT;
      IF Cont.Type = Cont.Type::Person THEN
        SETRANGE("Contact No.",Cont."No.")
      ELSE
        SETRANGE("Contact Company No.",Cont."Company No.");
      IF PhoneNo <> '' THEN
        "Contact Via" := PhoneNo
      ELSE
        "Contact Via" := Cont."Phone No.";
      VALIDATE("Contact No.",Cont."No.");
      "Contact Name" := Cont.Name;
      VALIDATE(Date,TODAY);
      IF ContAltAddrCode <> '' THEN
        "Contact Alt. Address Code" := ContAltAddrCode;
      IF TableNo = DATABASE::"To-do" THEN
        "To-do No." := Task."No.";
      StartWizard2;
    END;

    [External]
    PROCEDURE StartWizard2@34();
    VAR
      InteractionTmplSetup@1000 : Record 5122;
      Campaign@1001 : Record 5071;
    BEGIN
      InteractionTmplSetup.GET;
      InteractionTmplSetup.TESTFIELD("Outg. Calls");

      "Wizard Step" := "Wizard Step"::"1";
      IF Date = 0D THEN
        Date := TODAY;
      "Time of Interaction" := TIME;
      "Interaction Successful" := TRUE;
      "Dial Contact" := TRUE;

      IF Campaign.GET(GETFILTER("Campaign No.")) THEN
        "Campaign Description" := Campaign.Description;
      "Wizard Contact Name" := GetContactName;

      INSERT;
      VALIDATE("Interaction Template Code",InteractionTmplSetup."Outg. Calls");
      IF PAGE.RUNMODAL(PAGE::"Make Phone Call",Rec,"Contact Via") = ACTION::OK THEN;
    END;

    [External]
    PROCEDURE CheckPhoneCallStatus@25();
    BEGIN
      IF "Wizard Step" = "Wizard Step"::"1" THEN BEGIN
        IF "Dial Contact" AND ("Contact Via" = '') THEN
          ERROR(Text013);
        IF Date = 0D THEN
          ErrorMessage(FIELDCAPTION(Date));
        IF Description = '' THEN
          ErrorMessage(FIELDCAPTION(Description));
        IF "Salesperson Code" = '' THEN
          ErrorMessage(FIELDCAPTION("Salesperson Code"));
      END;
    END;

    [Internal]
    PROCEDURE LogPhoneCall@23();
    VAR
      TempAttachment@1000 : TEMPORARY Record 5062;
      SegLine@1001 : Record 5077;
      SegManagement@1002 : Codeunit 5051;
    BEGIN
      "Attempt Failed" := NOT "Interaction Successful";

      SegManagement.LogInteraction(Rec,TempAttachment,TempInterLogEntryCommentLine,FALSE,FALSE);

      IF SegLine.GET("Segment No.","Line No.") THEN BEGIN
        SegLine.LOCKTABLE;
        SegLine."Contact Via" := "Contact Via";
        SegLine."Wizard Step" := SegLine."Wizard Step"::" ";
        SegLine.MODIFY;
      END;
    END;

    [External]
    PROCEDURE ShowComment@27();
    BEGIN
      PAGE.RUNMODAL(PAGE::"Inter. Log Entry Comment Sheet",TempInterLogEntryCommentLine);
    END;

    [External]
    PROCEDURE SetComments@53(VAR InterLogEntryCommentLine@1001 : Record 5123);
    BEGIN
      TempInterLogEntryCommentLine.DELETEALL;

      IF InterLogEntryCommentLine.FINDSET THEN
        REPEAT
          TempInterLogEntryCommentLine := InterLogEntryCommentLine;
          TempInterLogEntryCommentLine.INSERT;
        UNTIL InterLogEntryCommentLine.NEXT = 0;
    END;

    [External]
    PROCEDURE IsHTMLAttachment@26() : Boolean;
    BEGIN
      IF NOT TempAttachment.FIND THEN
        EXIT(FALSE);
      EXIT(TempAttachment.IsHTML);
    END;

    [Internal]
    PROCEDURE PreviewHTMLContent@30();
    BEGIN
      TempAttachment.FIND;
      TempAttachment.ShowAttachment(Rec,'',TRUE,FALSE);
    END;

    [External]
    PROCEDURE LanguageCodeOnLookup@31();
    VAR
      SegInteractLanguage@1001 : Record 5104;
      InteractionTmplLanguage@1000 : Record 5103;
    BEGIN
      TESTFIELD("Interaction Template Code");

      IF SegHeader.GET("Segment No.") THEN BEGIN
        SegInteractLanguage.SETRANGE("Segment No.","Segment No.");
        IF UniqueAttachmentExists OR
           ("Interaction Template Code" <> SegHeader."Interaction Template Code")
        THEN
          SegInteractLanguage.SETRANGE("Segment Line No.","Line No.")
        ELSE
          SegInteractLanguage.SETRANGE("Segment Line No.",0);

        IF PAGE.RUNMODAL(0,SegInteractLanguage) = ACTION::LookupOK THEN BEGIN
          GET("Segment No.","Line No.");
          "Language Code" := SegInteractLanguage."Language Code";
          "Attachment No." := SegInteractLanguage."Attachment No.";
          Subject := SegInteractLanguage.Subject;
          MODIFY;
        END ELSE
          GET("Segment No.","Line No.");
      END ELSE BEGIN  // Create Interaction
        InteractionTmplLanguage.SETRANGE("Interaction Template Code","Interaction Template Code");
        IF PAGE.RUNMODAL(0,InteractionTmplLanguage) = ACTION::LookupOK THEN BEGIN
          "Language Code" := InteractionTmplLanguage."Language Code";
          MODIFY;
        END;
        SetInteractionAttachment;
      END;
    END;

    PROCEDURE FilterContactCompanyOpportunities@29(VAR Opportunity@1000 : Record 5092);
    BEGIN
      Opportunity.RESET;
      Opportunity.SETRANGE(Closed,FALSE);
      IF "Salesperson Code" <> '' THEN
        Opportunity.SETRANGE("Salesperson Code","Salesperson Code");
      Opportunity.SETFILTER("Contact Company No.","Contact Company No.");
      IF "Opportunity No." <> '' THEN BEGIN
        Opportunity.SETRANGE("No.","Opportunity No.");
        IF Opportunity.FINDFIRST THEN;
        Opportunity.SETRANGE("No.");
      END;
    END;

    LOCAL PROCEDURE FindSalespersonByUserEmail@35() : Code[10];
    VAR
      User@1002 : Record 2000000120;
      Salesperson@1003 : Record 13;
      Email@1001 : Text[250];
    BEGIN
      User.SETRANGE("User Name",USERID);
      IF User.FINDFIRST THEN
        Email := User."Authentication Email";

      IF Email <> '' THEN BEGIN
        Salesperson.SETRANGE("E-Mail",Email);
        IF Salesperson.COUNT = 1 THEN BEGIN
          Salesperson.FINDFIRST;
          "Salesperson Code" := Salesperson.Code;
        END;
      END;
      EXIT("Salesperson Code");
    END;

    PROCEDURE ExportODataFields@36();
    VAR
      TenantWebService@1001 : Record 2000000168;
      ODataFieldsExport@1002 : Page 6713;
      RecRef@1000 : RecordRef;
    BEGIN
      TenantWebService.SETRANGE("Object Type",TenantWebService."Object Type"::Query);
      TenantWebService.SETRANGE("Object ID",QUERY::"Segment Lines");
      TenantWebService.FINDFIRST;

      RecRef.OPEN(DATABASE::"Segment Line");
      RecRef.SETVIEW(GETVIEW);

      ODataFieldsExport.SetExportData(TenantWebService,RecRef);
      ODataFieldsExport.RUNMODAL;
    END;

    LOCAL PROCEDURE EmailDraftLogging@40() : Boolean;
    VAR
      InteractionMgt@1000 : Codeunit 5067;
    BEGIN
      EXIT(InteractionMgt.GetEmailDraftLogging);
    END;

    LOCAL PROCEDURE GetEmailDraftSubject@44() : Text[50];
    BEGIN
      EXIT(
        COPYSTR(
          STRSUBSTNO('%1 - %2',"Document Type","Document No."),
          1,
          MAXSTRLEN(Subject)));
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCopyFromInteractionLogEntry@11(VAR SegmentLine@1000 : Record 5077;InteractionLogEntry@1001 : Record 5065);
    BEGIN
    END;

    BEGIN
    END.
  }
}

