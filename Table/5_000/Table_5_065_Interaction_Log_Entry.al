OBJECT Table 5065 Interaction Log Entry
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    OnDelete=VAR
               InteractionCommentLine@1000 : Record 5123;
               Attachment@1003 : Record 5062;
               CampaignMgt@1001 : Codeunit 7030;
             BEGIN
               InteractionCommentLine.SETRANGE("Entry No.","Entry No.");
               InteractionCommentLine.DELETEALL;

               CampaignMgt.DeleteContfromTargetGr(Rec);
               IF Attachment.GET("Attachment No.") THEN
                 Attachment.RemoveAttachment(FALSE);
             END;

    CaptionML=[DAN=Interaktionslogpost;
               ENU=Interaction Log Entry];
    LookupPageID=Page5076;
    DrillDownPageID=Page5076;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 2   ;   ;Contact No.         ;Code20        ;TableRelation=Contact;
                                                   CaptionML=[DAN=Kontaktnr.;
                                                              ENU=Contact No.] }
    { 3   ;   ;Contact Company No. ;Code20        ;TableRelation=Contact WHERE (Type=CONST(Company));
                                                   CaptionML=[DAN=Virksomhedsnummer;
                                                              ENU=Contact Company No.] }
    { 4   ;   ;Date                ;Date          ;CaptionML=[DAN=Dato;
                                                              ENU=Date] }
    { 5   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 6   ;   ;Information Flow    ;Option        ;CaptionML=[DAN=Informationsstr�m;
                                                              ENU=Information Flow];
                                                   OptionCaptionML=[DAN=" ,Udg�ende,Indg�ende";
                                                                    ENU=" ,Outbound,Inbound"];
                                                   OptionString=[ ,Outbound,Inbound] }
    { 7   ;   ;Initiated By        ;Option        ;CaptionML=[DAN=Iv�rksat af;
                                                              ENU=Initiated By];
                                                   OptionCaptionML=[DAN=" ,Os,Dem";
                                                                    ENU=" ,Us,Them"];
                                                   OptionString=[ ,Us,Them] }
    { 8   ;   ;Attachment No.      ;Integer       ;TableRelation=Attachment;
                                                   CaptionML=[DAN=Vedh�ftet fil nr.;
                                                              ENU=Attachment No.] }
    { 9   ;   ;Cost (LCY)          ;Decimal       ;CaptionML=[DAN=Kostbel�b (RV);
                                                              ENU=Cost (LCY)];
                                                   Editable=No;
                                                   AutoFormatType=1 }
    { 10  ;   ;Duration (Min.)     ;Decimal       ;CaptionML=[DAN=Varighed (min.);
                                                              ENU=Duration (Min.)];
                                                   DecimalPlaces=0:0;
                                                   Editable=No }
    { 11  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   TestTableRelation=No;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 12  ;   ;Interaction Group Code;Code10      ;TableRelation="Interaction Group";
                                                   CaptionML=[DAN=Interaktionsgruppekode;
                                                              ENU=Interaction Group Code] }
    { 13  ;   ;Interaction Template Code;Code10   ;TableRelation="Interaction Template";
                                                   CaptionML=[DAN=Interaktionsskabelonkode;
                                                              ENU=Interaction Template Code] }
    { 14  ;   ;Campaign No.        ;Code20        ;TableRelation=Campaign;
                                                   CaptionML=[DAN=Kampagnenr.;
                                                              ENU=Campaign No.] }
    { 15  ;   ;Campaign Entry No.  ;Integer       ;TableRelation="Campaign Entry" WHERE (Campaign No.=FIELD(Campaign No.));
                                                   CaptionML=[DAN=Kampagnepostl�benr.;
                                                              ENU=Campaign Entry No.] }
    { 16  ;   ;Campaign Response   ;Boolean       ;CaptionML=[DAN=Kampagnereaktion;
                                                              ENU=Campaign Response] }
    { 17  ;   ;Campaign Target     ;Boolean       ;CaptionML=[DAN=Kampagnem�lgruppe;
                                                              ENU=Campaign Target] }
    { 18  ;   ;Segment No.         ;Code20        ;CaptionML=[DAN=M�lgruppenr.;
                                                              ENU=Segment No.] }
    { 19  ;   ;Evaluation          ;Option        ;CaptionML=[DAN=Vurdering;
                                                              ENU=Evaluation];
                                                   OptionCaptionML=[DAN=" ,Meget positiv,Positiv,Neutral,Negativ,Meget negativ";
                                                                    ENU=" ,Very Positive,Positive,Neutral,Negative,Very Negative"];
                                                   OptionString=[ ,Very Positive,Positive,Neutral,Negative,Very Negative];
                                                   Editable=No }
    { 20  ;   ;Time of Interaction ;Time          ;CaptionML=[DAN=Interaktion oprettet;
                                                              ENU=Time of Interaction] }
    { 21  ;   ;Attempt Failed      ;Boolean       ;CaptionML=[DAN=Fors�g mislykket;
                                                              ENU=Attempt Failed] }
    { 23  ;   ;To-do No.           ;Code20        ;TableRelation=To-do;
                                                   CaptionML=[DAN=Opgavenr.;
                                                              ENU=Task No.] }
    { 24  ;   ;Salesperson Code    ;Code20        ;TableRelation=Salesperson/Purchaser;
                                                   CaptionML=[DAN=S�lgerkode;
                                                              ENU=Salesperson Code] }
    { 25  ;   ;Delivery Status     ;Option        ;CaptionML=[DAN=Afsendelsesstatus;
                                                              ENU=Delivery Status];
                                                   OptionCaptionML=[DAN=" ,I gang,Fejl";
                                                                    ENU=" ,In Progress,Error"];
                                                   OptionString=[ ,In Progress,Error] }
    { 26  ;   ;Canceled            ;Boolean       ;CaptionML=[DAN=Annulleret;
                                                              ENU=Canceled] }
    { 27  ;   ;Correspondence Type ;Option        ;CaptionML=[DAN=Korrespondancetype;
                                                              ENU=Correspondence Type];
                                                   OptionCaptionML=[DAN=" ,Papirformat,Mail,Telefax";
                                                                    ENU=" ,Hard Copy,Email,Fax"];
                                                   OptionString=[ ,Hard Copy,Email,Fax] }
    { 28  ;   ;Contact Alt. Address Code;Code10   ;TableRelation="Contact Alt. Address".Code WHERE (Contact No.=FIELD(Contact No.));
                                                   CaptionML=[DAN=Kontaktens alt. adr.kode;
                                                              ENU=Contact Alt. Address Code] }
    { 29  ;   ;Logged Segment Entry No.;Integer   ;TableRelation="Logged Segment";
                                                   CaptionML=[DAN=Gemt m�lgruppel�benr.;
                                                              ENU=Logged Segment Entry No.] }
    { 30  ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Salgstilbud,Rammesalgsordre,Salgsordrebekr�ft.,Salgsfaktura,Salgslev.nota,Salgskreditnota,Salgskontoudtog,Rykker (salg),Opret. serviceordre,Bogf. serviceordre,K�bsrekvisition,Rammek�bsordre,K�bsordre,K�bsfaktura,K�bsmodtag.,K�bskreditnota,F�lgebrev,Salgsreturv.ordre,Salgsrentenota,Salgsreturv.kvit.,K�bsreturv.kvit.,K�bsreturv.ordrebekr�ft.,Servicekontrakt,Servicekontrakttilbud,Servicetilbud";
                                                                    ENU=" ,Sales Qte.,Sales Blnkt. Ord,Sales Ord. Cnfrmn.,Sales Inv.,Sales Shpt. Note,Sales Cr. Memo,Sales Stmnt.,Sales Rmdr.,Serv. Ord. Create,Serv. Ord. Post,Purch.Qte.,Purch. Blnkt. Ord.,Purch. Ord.,Purch. Inv.,Purch. Rcpt.,Purch. Cr. Memo,Cover Sheet,Sales Return Order,Sales Finance Charge Memo,Sales Return Receipt,Purch. Return Shipment,Purch. Return Ord. Cnfrmn.,Service Contract,Service Contract Quote,Service Quote"];
                                                   OptionString=[ ,Sales Qte.,Sales Blnkt. Ord,Sales Ord. Cnfrmn.,Sales Inv.,Sales Shpt. Note,Sales Cr. Memo,Sales Stmnt.,Sales Rmdr.,Serv. Ord. Create,Serv. Ord. Post,Purch.Qte.,Purch. Blnkt. Ord.,Purch. Ord.,Purch. Inv.,Purch. Rcpt.,Purch. Cr. Memo,Cover Sheet,Sales Return Order,Sales Finance Charge Memo,Sales Return Receipt,Purch. Return Shipment,Purch. Return Ord. Cnfrmn.,Service Contract,Service Contract Quote,Service Quote] }
    { 31  ;   ;Document No.        ;Code20        ;TestTableRelation=No;
                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 32  ;   ;Version No.         ;Integer       ;CaptionML=[DAN=Versionsnr.;
                                                              ENU=Version No.] }
    { 33  ;   ;Doc. No. Occurrence ;Integer       ;CaptionML=[DAN=Forekomster af dok.nr.;
                                                              ENU=Doc. No. Occurrence] }
    { 34  ;   ;Contact Via         ;Text80        ;CaptionML=[DAN=Kontaktens tlf.nr.;
                                                              ENU=Contact Via] }
    { 35  ;   ;Send Word Docs. as Attmt.;Boolean  ;CaptionML=[DAN=Send Word-dok. som vedh. filer;
                                                              ENU=Send Word Docs. as Attmt.] }
    { 36  ;   ;Interaction Language Code;Code10   ;TableRelation=Language;
                                                   CaptionML=[DAN=Interaktionssprogkode;
                                                              ENU=Interaction Language Code] }
    { 37  ;   ;E-Mail Logged       ;Boolean       ;CaptionML=[DAN=Mail logf�rt;
                                                              ENU=Email Logged] }
    { 38  ;   ;Subject             ;Text50        ;CaptionML=[DAN=Emne;
                                                              ENU=Subject] }
    { 39  ;   ;Contact Name        ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Contact.Name WHERE (No.=FIELD(Contact No.)));
                                                   CaptionML=[DAN=Kontaktnavn;
                                                              ENU=Contact Name];
                                                   Editable=No }
    { 40  ;   ;Contact Company Name;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(Contact.Name WHERE (No.=FIELD(Contact Company No.),
                                                                                          Type=CONST(Company)));
                                                   CaptionML=[DAN=Virksomhed;
                                                              ENU=Contact Company Name];
                                                   Editable=No }
    { 43  ;   ;Comment             ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("Inter. Log Entry Comment Line" WHERE (Entry No.=FIELD(Entry No.)));
                                                   CaptionML=[DAN=Bem�rkning;
                                                              ENU=Comment];
                                                   Editable=No }
    { 44  ;   ;Opportunity No.     ;Code20        ;TableRelation=Opportunity;
                                                   CaptionML=[DAN=Salgsmulighednummer;
                                                              ENU=Opportunity No.] }
    { 45  ;   ;Postponed           ;Boolean       ;CaptionML=[DAN=Udsat;
                                                              ENU=Postponed] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Contact Company No.,Contact No.,Date,Postponed;
                                                   SumIndexFields=Cost (LCY),Duration (Min.) }
    {    ;Contact Company No.,Date,Contact No.,Canceled,Initiated By,Attempt Failed,Postponed;
                                                   SumIndexFields=Cost (LCY),Duration (Min.);
                                                   MaintainSIFTIndex=No }
    {    ;Interaction Group Code,Date              }
    {    ;Interaction Group Code,Canceled,Date,Postponed;
                                                   SumIndexFields=Cost (LCY),Duration (Min.) }
    {    ;Interaction Template Code,Date           }
    {    ;Interaction Template Code,Canceled,Date,Postponed;
                                                   SumIndexFields=Cost (LCY),Duration (Min.) }
    {    ;Canceled,Campaign No.,Campaign Entry No.,Date,Postponed;
                                                   SumIndexFields=Cost (LCY),Duration (Min.) }
    {    ;Campaign No.,Campaign Entry No.,Date,Postponed;
                                                   SumIndexFields=Cost (LCY),Duration (Min.) }
    {    ;Salesperson Code,Date,Postponed         ;SumIndexFields=Cost (LCY),Duration (Min.) }
    {    ;Canceled,Salesperson Code,Date,Postponed;SumIndexFields=Cost (LCY),Duration (Min.) }
    {    ;Logged Segment Entry No.,Postponed       }
    {    ;Attachment No.                           }
    {    ;To-do No.,Date                           }
    {    ;Contact No.,Correspondence Type,E-Mail Logged,Subject,Postponed }
    {    ;Campaign No.,Campaign Target             }
    {    ;Campaign No.,Contact Company No.,Campaign Target,Postponed }
    {    ;Opportunity No.,Date                     }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Description,Contact No.,Date   }
    { 2   ;Brick               ;Salesperson Code,Description,Date,Contact Name,Contact Company Name }
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 %2 er markeret som %3.\;ENU=%1 %2 is marked %3.\';
      Text001@1001 : TextConst 'DAN=Vil du fjerne markeringen?;ENU=Do you wish to remove the checkmark?';
      Text002@1002 : TextConst 'DAN=Vil du markere %1 %2 som %3?;ENU=Do you wish to mark %1 %2 as %3?';
      Text003@1003 : TextConst 'DAN=Du kan ikke f� vist salgskontoudtog, efter at de er blevet udskrevet.;ENU=It is not possible to view sales statements after they have been printed.';
      Text004@1004 : TextConst 'DAN=Du kan ikke f� vist f�lgebreve, efter at de er blevet udskrevet.;ENU=It is not possible to show cover sheets after they have been printed.';
      Text005@1005 : TextConst 'DAN=Vil du fjerne markeringen af de markerede %1-linjer?;ENU=Do you wish to remove the checkmark from the selected %1 lines?';
      Text006@1006 : TextConst 'DAN=Vil du markere de valgte %1-linjer som %2?;ENU=Do you wish to mark the selected %1 lines as %2?';
      Text009@1007 : TextConst 'DAN=Vil du fjerne den vedh�ftede fil?;ENU=Do you want to remove Attachment?';
      Text010@1008 : TextConst 'DAN=Vil du fjerne specifikke vedh�ftede filer for de valgte linjer?;ENU=Do you want to remove unique Attachments for the selected lines?';
      Text011@1009 : TextConst 'DAN=Meget positiv,Positiv,Neutral,Negativ,Meget negativ;ENU=Very Positive,Positive,Neutral,Negative,Very Negative';

    [External]
    PROCEDURE AssignNewOpportunity@15();
    VAR
      Opportunity@1000 : Record 5092;
    BEGIN
      TESTFIELD(Canceled,FALSE);
      TESTFIELD("Opportunity No.",'');
      Opportunity.CreateFromInteractionLogEntry(Rec);
      "Opportunity No." := Opportunity."No.";
      MODIFY;
    END;

    [External]
    PROCEDURE CanCreateOpportunity@13() : Boolean;
    BEGIN
      EXIT(NOT Canceled AND ("Opportunity No." = ''));
    END;

    PROCEDURE CopyFromSegment@14(SegLine@1001 : Record 5077);
    BEGIN
      "Contact No." := SegLine."Contact No.";
      "Contact Company No." := SegLine."Contact Company No.";
      Date := SegLine.Date;
      Description := SegLine.Description;
      "Information Flow" := SegLine."Information Flow";
      "Initiated By" := SegLine."Initiated By";
      "Attachment No." := SegLine."Attachment No.";
      "Cost (LCY)" := SegLine."Cost (LCY)";
      "Duration (Min.)" := SegLine."Duration (Min.)";
      "User ID" := USERID;
      "Interaction Group Code" := SegLine."Interaction Group Code";
      "Interaction Template Code" := SegLine."Interaction Template Code";
      "Interaction Language Code" := SegLine."Language Code";
      Subject := SegLine.Subject;
      "Campaign No." := SegLine."Campaign No.";
      "Campaign Entry No." := SegLine."Campaign Entry No.";
      "Campaign Response" := SegLine."Campaign Response";
      "Campaign Target" := SegLine."Campaign Target";
      "Segment No." := SegLine."Segment No.";
      Evaluation := SegLine.Evaluation;
      "Time of Interaction" := SegLine."Time of Interaction";
      "Attempt Failed" := SegLine."Attempt Failed";
      "To-do No." := SegLine."To-do No.";
      "Salesperson Code" := SegLine."Salesperson Code";
      "Correspondence Type" := SegLine."Correspondence Type";
      "Contact Alt. Address Code" := SegLine."Contact Alt. Address Code";
      "Document Type" := SegLine."Document Type";
      "Document No." := SegLine."Document No.";
      "Doc. No. Occurrence" := SegLine."Doc. No. Occurrence";
      "Version No." := SegLine."Version No.";
      "Send Word Docs. as Attmt." := SegLine."Send Word Doc. As Attmt.";
      "Contact Via" := SegLine."Contact Via";
      "Opportunity No." := SegLine."Opportunity No.";
    END;

    [External]
    PROCEDURE CreateInteraction@10();
    VAR
      TempSegLine@1000 : TEMPORARY Record 5077;
    BEGIN
      TempSegLine.CreateInteractionFromInteractLogEntry(Rec);
    END;

    [External]
    PROCEDURE CreateTask@8();
    VAR
      TempTask@1000 : TEMPORARY Record 5080;
    BEGIN
      TempTask.CreateTaskFromInteractLogEntry(Rec)
    END;

    [Internal]
    PROCEDURE OpenAttachment@5();
    VAR
      Attachment@1000 : Record 5062;
      SegLine@1001 : Record 5077;
      IStream@1003 : InStream;
      EmailMessageUrl@1002 : Text;
    BEGIN
      IF "Attachment No." = 0 THEN
        EXIT;
      Attachment.GET("Attachment No.");

      IF Attachment."Storage Type" <> Attachment."Storage Type"::"Exchange Storage" THEN BEGIN
        SegLine."Contact No." := "Contact No.";
        SegLine."Salesperson Code" := "Salesperson Code";
        SegLine."Contact Alt. Address Code" := "Contact Alt. Address Code";
        SegLine.Date := Date;
        SegLine."Campaign No." := "Campaign No.";
        SegLine."Segment No." := "Segment No.";
        SegLine."Line No." := "Entry No.";
        SegLine.Description := Description;
        SegLine.Subject := Subject;
        SegLine."Language Code" := "Interaction Language Code";
        Attachment.ShowAttachment(SegLine,FORMAT("Entry No.") + ' ' + Description,FALSE,FALSE);
      END ELSE BEGIN
        Attachment.CALCFIELDS("Email Message Url");
        IF Attachment."Email Message Url".HASVALUE THEN BEGIN
          Attachment."Email Message Url".CREATEINSTREAM(IStream);
          IStream.READ(EmailMessageUrl);
          HYPERLINK(EmailMessageUrl);
        END ELSE
          Attachment.DisplayInOutlook;
      END;
    END;

    [Internal]
    PROCEDURE ToggleCanceledCheckmark@7();
    VAR
      ErrorTxt@1004 : Text[80];
      MasterCanceledCheckmark@1001 : Boolean;
      RemoveUniqueAttachment@1000 : Boolean;
    BEGIN
      IF FIND('-') THEN BEGIN
        IF ConfirmToggleCanceledCheckmark(COUNT,ErrorTxt) THEN BEGIN
          MasterCanceledCheckmark := NOT Canceled;
          IF FindUniqueAttachment AND MasterCanceledCheckmark THEN
            RemoveUniqueAttachment := CONFIRM(ErrorTxt,FALSE);
          SETCURRENTKEY("Entry No.");
          IF FIND('-') THEN
            REPEAT
              SetCanceledCheckmark(MasterCanceledCheckmark,RemoveUniqueAttachment);
            UNTIL NEXT = 0
        END;
      END
    END;

    [Internal]
    PROCEDURE SetCanceledCheckmark@2(CanceledCheckmark@1003 : Boolean;RemoveUniqueAttachment@1004 : Boolean);
    VAR
      CampaignEntry@1000 : Record 5072;
      LoggedSeg@1001 : Record 5075;
      Attachment@1002 : Record 5062;
    BEGIN
      IF Canceled AND NOT CanceledCheckmark THEN BEGIN
        IF "Logged Segment Entry No." <> 0 THEN BEGIN
          LoggedSeg.GET("Logged Segment Entry No.");
          LoggedSeg.TESTFIELD(Canceled,FALSE);
        END;
        IF "Campaign Entry No." <> 0 THEN BEGIN
          CampaignEntry.GET("Campaign Entry No.");
          CampaignEntry.TESTFIELD(Canceled,FALSE);
        END;
      END;

      IF NOT Canceled AND CanceledCheckmark THEN
        IF UniqueAttachment AND RemoveUniqueAttachment THEN BEGIN
          IF Attachment.GET("Attachment No.") THEN
            Attachment.RemoveAttachment(FALSE);
          "Attachment No." := 0;
        END;

      Canceled := CanceledCheckmark;
      MODIFY;
    END;

    LOCAL PROCEDURE ConfirmToggleCanceledCheckmark@3(NumberOfSelectedLines@1000 : Integer;VAR ErrorTxt@1001 : Text[80]) : Boolean;
    BEGIN
      IF NumberOfSelectedLines = 1 THEN BEGIN
        ErrorTxt := Text009;
        IF Canceled THEN
          EXIT(CONFIRM(
              Text000 +
              Text001,TRUE,TABLECAPTION,"Entry No.",FIELDCAPTION(Canceled)));

        EXIT(CONFIRM(
            Text002,TRUE,TABLECAPTION,"Entry No.",FIELDCAPTION(Canceled)));
      END;
      ErrorTxt := Text010;
      IF Canceled THEN
        EXIT(CONFIRM(
            Text005,TRUE,TABLECAPTION));

      EXIT(CONFIRM(
          Text006,TRUE,TABLECAPTION,FIELDCAPTION(Canceled)));
    END;

    [External]
    PROCEDURE UniqueAttachment@4() IsUnique@1000 : Boolean;
    VAR
      InteractLogEntry@1001 : Record 5065;
    BEGIN
      IF "Attachment No." <> 0 THEN BEGIN
        InteractLogEntry.SETCURRENTKEY("Attachment No.");
        InteractLogEntry.SETRANGE("Attachment No.","Attachment No.");
        InteractLogEntry.SETFILTER("Entry No.",'<>%1',"Entry No.");
        IsUnique := NOT InteractLogEntry.FINDFIRST;
      END;
    END;

    LOCAL PROCEDURE FindUniqueAttachment@6() IsUnique@1000 : Boolean;
    BEGIN
      IF FIND('-') THEN
        REPEAT
          IsUnique := UniqueAttachment;
        UNTIL (NEXT = 0) OR IsUnique
    END;

    [External]
    PROCEDURE ShowDocument@1();
    VAR
      SalesHeader@1000 : Record 36;
      SalesHeaderArchive@1011 : Record 5107;
      SalesInvHeader@1001 : Record 112;
      SalesShptHeader@1002 : Record 110;
      SalesCrMemoHeader@1003 : Record 114;
      IssuedReminderHeader@1004 : Record 297;
      PurchHeader@1005 : Record 38;
      PurchHeaderArchive@1012 : Record 5109;
      PurchInvHeader@1006 : Record 122;
      PurchRcptHeader@1007 : Record 120;
      PurchCrMemoHeader@1008 : Record 124;
      ServHeader@1009 : Record 5900;
      ReturnRcptHeader@1013 : Record 6660;
      IssuedFinChargeMemoHeader@1015 : Record 304;
      ReturnReceiptHeader@1014 : Record 6660;
      ReturnShipmentHeader@1016 : Record 6650;
      ServiceContractHeader@1017 : Record 5965;
    BEGIN
      CASE "Document Type" OF
        "Document Type"::"Sales Qte.":
          IF "Version No." <> 0 THEN BEGIN
            SalesHeaderArchive.GET(
              SalesHeaderArchive."Document Type"::Quote,"Document No.",
              "Doc. No. Occurrence","Version No.");
            SalesHeaderArchive.SETRANGE("Document Type",SalesHeaderArchive."Document Type"::Quote);
            SalesHeaderArchive.SETRANGE("No.","Document No.");
            SalesHeaderArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
            PAGE.RUN(PAGE::"Sales Quote Archive",SalesHeaderArchive);
          END ELSE BEGIN
            SalesHeader.GET(SalesHeader."Document Type"::Quote,"Document No.");
            PAGE.RUN(PAGE::"Sales Quote",SalesHeader);
          END;
        "Document Type"::"Sales Blnkt. Ord":
          BEGIN
            SalesHeader.GET(SalesHeader."Document Type"::"Blanket Order","Document No.");
            PAGE.RUN(PAGE::"Blanket Sales Order",SalesHeader);
          END;
        "Document Type"::"Sales Ord. Cnfrmn.":
          IF "Version No." <> 0 THEN BEGIN
            SalesHeaderArchive.GET(
              SalesHeaderArchive."Document Type"::Order,"Document No.",
              "Doc. No. Occurrence","Version No.");
            SalesHeaderArchive.SETRANGE("Document Type",SalesHeaderArchive."Document Type"::Order);
            SalesHeaderArchive.SETRANGE("No.","Document No.");
            SalesHeaderArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
            PAGE.RUN(PAGE::"Sales Order Archive",SalesHeaderArchive);
          END ELSE BEGIN
            SalesHeader.GET(SalesHeader."Document Type"::Order,"Document No.");
            PAGE.RUN(PAGE::"Sales Order",SalesHeader);
          END;
        "Document Type"::"Sales Inv.":
          BEGIN
            SalesInvHeader.GET("Document No.");
            PAGE.RUN(PAGE::"Posted Sales Invoice",SalesInvHeader);
          END;
        "Document Type"::"Sales Shpt. Note":
          BEGIN
            SalesShptHeader.GET("Document No.");
            PAGE.RUN(PAGE::"Posted Sales Shipment",SalesShptHeader);
          END;
        "Document Type"::"Sales Cr. Memo":
          BEGIN
            SalesCrMemoHeader.GET("Document No.");
            PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
          END;
        "Document Type"::"Sales Stmnt.":
          ERROR(Text003);
        "Document Type"::"Sales Rmdr.":
          BEGIN
            IssuedReminderHeader.GET("Document No.");
            PAGE.RUN(PAGE::"Issued Reminder",IssuedReminderHeader);
          END;
        "Document Type"::"Serv. Ord. Create":
          BEGIN
            ServHeader.GET(ServHeader."Document Type"::Order,"Document No.");
            PAGE.RUN(PAGE::"Service Order",ServHeader)
          END;
        "Document Type"::"Purch.Qte.":
          IF "Version No." <> 0 THEN BEGIN
            PurchHeaderArchive.GET(
              PurchHeaderArchive."Document Type"::Quote,"Document No.",
              "Doc. No. Occurrence","Version No.");
            PurchHeaderArchive.SETRANGE("Document Type",PurchHeaderArchive."Document Type"::Quote);
            PurchHeaderArchive.SETRANGE("No.","Document No.");
            PurchHeaderArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
            PAGE.RUN(PAGE::"Purchase Quote Archive",PurchHeaderArchive);
          END ELSE BEGIN
            PurchHeader.GET(PurchHeader."Document Type"::Quote,"Document No.");
            PAGE.RUN(PAGE::"Purchase Quote",PurchHeader);
          END;
        "Document Type"::"Purch. Blnkt. Ord.":
          BEGIN
            PurchHeader.GET(PurchHeader."Document Type"::"Blanket Order","Document No.");
            PAGE.RUN(PAGE::"Blanket Purchase Order",PurchHeader);
          END;
        "Document Type"::"Purch. Ord.":
          IF "Version No." <> 0 THEN BEGIN
            PurchHeaderArchive.GET(
              PurchHeaderArchive."Document Type"::Order,"Document No.",
              "Doc. No. Occurrence","Version No.");
            PurchHeaderArchive.SETRANGE("Document Type",PurchHeaderArchive."Document Type"::Order);
            PurchHeaderArchive.SETRANGE("No.","Document No.");
            PurchHeaderArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
            PAGE.RUN(PAGE::"Purchase Order Archive",PurchHeaderArchive);
          END ELSE BEGIN
            PurchHeader.GET(PurchHeader."Document Type"::Order,"Document No.");
            PAGE.RUN(PAGE::"Purchase Order",PurchHeader);
          END;
        "Document Type"::"Purch. Inv.":
          BEGIN
            PurchInvHeader.GET("Document No.");
            PAGE.RUN(PAGE::"Posted Purchase Invoice",PurchInvHeader);
          END;
        "Document Type"::"Purch. Rcpt.":
          BEGIN
            PurchRcptHeader.GET("Document No.");
            PAGE.RUN(PAGE::"Posted Purchase Receipt",PurchRcptHeader);
          END;
        "Document Type"::"Purch. Cr. Memo":
          BEGIN
            PurchCrMemoHeader.GET("Document No.");
            PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHeader);
          END;
        "Document Type"::"Cover Sheet":
          ERROR(Text004);
        "Document Type"::"Sales Return Order":
          IF SalesHeader.GET(SalesHeader."Document Type"::"Return Order","Document No.") THEN
            PAGE.RUN(PAGE::"Sales Return Order",SalesHeader)
          ELSE BEGIN
            ReturnRcptHeader.SETRANGE("Return Order No.","Document No.");
            PAGE.RUN(PAGE::"Posted Return Receipt",ReturnRcptHeader);
          END;
        "Document Type"::"Sales Finance Charge Memo":
          BEGIN
            IssuedFinChargeMemoHeader.GET("Document No.");
            PAGE.RUN(PAGE::"Issued Finance Charge Memo",IssuedFinChargeMemoHeader);
          END;
        "Document Type"::"Sales Return Receipt":
          BEGIN
            ReturnReceiptHeader.GET("Document No.");
            PAGE.RUN(PAGE::"Posted Return Receipt",ReturnReceiptHeader);
          END;
        "Document Type"::"Purch. Return Shipment":
          BEGIN
            ReturnShipmentHeader.GET("Document No.");
            PAGE.RUN(PAGE::"Posted Return Shipment",ReturnShipmentHeader);
          END;
        "Document Type"::"Purch. Return Ord. Cnfrmn.":
          IF PurchHeader.GET(PurchHeader."Document Type"::"Return Order","Document No.") THEN
            PAGE.RUN(PAGE::"Purchase Return Order",PurchHeader)
          ELSE BEGIN
            ReturnShipmentHeader.SETRANGE("Return Order No.","Document No.");
            PAGE.RUN(PAGE::"Posted Return Shipment",ReturnShipmentHeader);
          END;
        "Document Type"::"Service Contract":
          BEGIN
            ServiceContractHeader.GET(ServiceContractHeader."Contract Type"::Contract,"Document No.");
            PAGE.RUN(PAGE::"Service Contract",ServiceContractHeader);
          END;
        "Document Type"::"Service Contract Quote":
          BEGIN
            ServiceContractHeader.GET(ServiceContractHeader."Contract Type"::Quote,"Document No.");
            PAGE.RUN(PAGE::"Service Contract Quote",ServiceContractHeader);
          END;
        "Document Type"::"Service Quote":
          BEGIN
            ServHeader.GET(ServHeader."Document Type"::Quote,"Document No.");
            PAGE.RUN(PAGE::"Service Quote",ServHeader);
          END;
      END;
    END;

    [External]
    PROCEDURE EvaluateInteraction@9();
    VAR
      Selected@1000 : Integer;
    BEGIN
      IF FIND('-') THEN BEGIN
        Selected := DIALOG.STRMENU(Text011);
        IF Selected <> 0 THEN
          REPEAT
            Evaluation := Selected;
            MODIFY;
          UNTIL NEXT = 0
      END;
    END;

    [External]
    PROCEDURE ResumeInteraction@11();
    VAR
      TempSegLine@1000 : TEMPORARY Record 5077;
    BEGIN
      TempSegLine.CopyFromInteractLogEntry(Rec);
      TempSegLine.VALIDATE(Date,WORKDATE);

      IF TempSegLine."To-do No." <> '' THEN
        TempSegLine.SETRANGE("To-do No.",TempSegLine."To-do No.");

      IF TempSegLine."Contact Company No." <> '' THEN
        TempSegLine.SETRANGE("Contact Company No.",TempSegLine."Contact Company No.");

      IF TempSegLine."Contact No." <> '' THEN
        TempSegLine.SETRANGE("Contact No.",TempSegLine."Contact No.");

      IF TempSegLine."Salesperson Code" <> '' THEN
        TempSegLine.SETRANGE("Salesperson Code",TempSegLine."Salesperson Code");

      IF TempSegLine."Campaign No." <> '' THEN
        TempSegLine.SETRANGE("Campaign No.",TempSegLine."Campaign No.");

      IF TempSegLine."Opportunity No." <> '' THEN
        TempSegLine.SETRANGE("Opportunity No.",TempSegLine."Opportunity No.");

      TempSegLine.StartWizard;
    END;

    BEGIN
    END.
  }
}

