OBJECT Codeunit 5051 SegManagement
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 5065=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 til m�lgruppe nr. %2 findes allerede.;ENU=%1 for Segment No. %2 already exists.';
      Text001@1001 : TextConst 'DAN=M�lgruppen %1 er tom.;ENU=Segment %1 is empty.';
      Text002@1002 : TextConst 'DAN=Opf�lgning p� m�lgruppen %1;ENU=Follow-up on segment %1';
      InteractionTmplSetup@1003 : Record 5122;
      Text003@1004 : TextConst 'DAN=Interaktionsskabelonsproget %2 er tilknyttet interaktionsskabelonen %1.\Det er ikke tilladt at have sprog knyttet til skabeloner, der bruges til logf�ring af systemdokumenter.;ENU=Interaction Template %1 has assigned Interaction Template Language %2.\It is not allowed to have languages assigned to templates used for system document logging.';
      Text004@1006 : TextConst 'DAN=Interaktioner;ENU=Interactions';
      InterTemplateSalesInvoicesNotSpecifiedErr@1007 : TextConst 'DAN=Feltet Fakturaer i oversigtspanelet Salg i vinduet Ops�tning af interaktionsskabelon skal udfyldes.;ENU=The Invoices field on the Sales FastTab in the Interaction Template Setup window must be filled in.';
      InteractionMgt@1005 : Codeunit 5067;

    [Internal]
    PROCEDURE LogSegment@3(SegHeader@1000 : Record 5076;Deliver@1001 : Boolean;Followup@1002 : Boolean);
    VAR
      SegLine@1003 : Record 5077;
      LoggedSeg@1006 : Record 5075;
      InteractLogEntry@1007 : Record 5065;
      Attachment@1009 : Record 5062;
      InteractTemplate@1017 : Record 5064;
      DeliverySorterTemp@1010 : TEMPORARY Record 5074;
      AttachmentManagement@1011 : Codeunit 5052;
      SegmentNo@1012 : Code[20];
      CampaignNo@1016 : Code[20];
      NextInteractLogEntryNo@1015 : Integer;
    BEGIN
      LoggedSeg.LOCKTABLE;
      LoggedSeg.SETCURRENTKEY("Segment No.");
      LoggedSeg.SETRANGE("Segment No.",SegHeader."No.");
      IF NOT LoggedSeg.ISEMPTY THEN
        ERROR(Text000,LoggedSeg.TABLECAPTION,SegHeader."No.");

      SegHeader.TESTFIELD(Description);

      LoggedSeg.RESET;
      LoggedSeg.INIT;
      LoggedSeg."Entry No." := GetNextLoggedSegmentEntryNo;
      LoggedSeg."Segment No." := SegHeader."No.";
      LoggedSeg.Description := SegHeader.Description;
      LoggedSeg."Creation Date" := TODAY;
      LoggedSeg."User ID" := USERID;
      LoggedSeg.INSERT;

      SegLine.LOCKTABLE;
      SegLine.SETCURRENTKEY("Segment No.","Campaign No.",Date);
      SegLine.SETRANGE("Segment No.",SegHeader."No.");
      SegLine.SETFILTER("Campaign No.",'<>%1','');
      SegLine.SETFILTER("Contact No.",'<>%1','');
      IF SegLine.FINDSET THEN
        REPEAT
          SegLine."Campaign Entry No." := GetCampaignEntryNo(SegLine,LoggedSeg."Entry No.");
          SegLine.MODIFY;
        UNTIL SegLine.NEXT = 0;

      SegLine.RESET;
      SegLine.SETRANGE("Segment No.",SegHeader."No.");
      SegLine.SETFILTER("Contact No.",'<>%1','');

      IF SegLine.FINDSET THEN BEGIN
        IF InteractTemplate.GET(SegHeader."Interaction Template Code") THEN;
        NextInteractLogEntryNo := GetNextInteractionLogEntryNo;
        REPEAT
          TestFields(SegLine);
          InteractLogEntry.INIT;
          InteractLogEntry."Entry No." := NextInteractLogEntryNo;
          InteractLogEntry."Logged Segment Entry No." := LoggedSeg."Entry No.";
          InteractLogEntry.CopyFromSegment(SegLine);
          IF Deliver AND ((SegLine."Correspondence Type" <> 0) OR (InteractTemplate."Correspondence Type (Default)" <> 0)) THEN BEGIN
            InteractLogEntry."Delivery Status" := InteractLogEntry."Delivery Status"::"In Progress";
            SegLine.TESTFIELD("Attachment No.");
            DeliverySorterTemp."No." := InteractLogEntry."Entry No.";
            DeliverySorterTemp."Attachment No." := InteractLogEntry."Attachment No.";
            DeliverySorterTemp."Correspondence Type" := InteractLogEntry."Correspondence Type";
            DeliverySorterTemp.Subject := InteractLogEntry.Subject;
            DeliverySorterTemp."Send Word Docs. as Attmt." := InteractLogEntry."Send Word Docs. as Attmt.";
            DeliverySorterTemp."Language Code" := SegLine."Language Code";
            DeliverySorterTemp.INSERT;
          END;
          InteractLogEntry.INSERT;
          Attachment.LOCKTABLE;
          IF Attachment.GET(SegLine."Attachment No.") AND (NOT Attachment."Read Only") THEN BEGIN
            Attachment."Read Only" := TRUE;
            Attachment.MODIFY(TRUE);
          END;
          NextInteractLogEntryNo += 1;
        UNTIL SegLine.NEXT = 0;
      END ELSE
        ERROR(Text001,SegHeader."No.");

      SegmentNo := SegHeader."No.";
      CampaignNo := SegHeader."Campaign No.";
      SegHeader.DELETE(TRUE);

      IF Followup THEN BEGIN
        CLEAR(SegHeader);
        SegHeader."Campaign No." := CampaignNo;
        SegHeader.Description := COPYSTR(STRSUBSTNO(Text002,SegmentNo),1,50);
        SegHeader.INSERT(TRUE);
        SegHeader.ReuseLogged(LoggedSeg."Entry No.");
      END;

      IF Deliver THEN
        AttachmentManagement.Send(DeliverySorterTemp);
    END;

    [Internal]
    PROCEDURE LogInteraction@4(SegLine@1000 : Record 5077;VAR AttachmentTemp@1001 : Record 5062;VAR InterLogEntryCommentLineTmp@1010 : Record 5123;Deliver@1002 : Boolean;Postponed@1012 : Boolean) NextInteractLogEntryNo : Integer;
    VAR
      InteractLogEntry@1004 : Record 5065;
      Attachment@1005 : Record 5062;
      MarketingSetup@1014 : Record 5079;
      DeliverySorterTemp@1006 : TEMPORARY Record 5074;
      InterLogEntryCommentLine@1011 : Record 5123;
      AttachmentManagement@1007 : Codeunit 5052;
      FileMgt@1009 : Codeunit 419;
      FileName@1015 : Text;
    BEGIN
      IF NOT Postponed THEN
        TestFields(SegLine);
      IF (SegLine."Campaign No." <> '') AND (NOT Postponed) THEN
        SegLine."Campaign Entry No." := GetCampaignEntryNo(SegLine,0);

      IF AttachmentTemp."Attachment File".HASVALUE THEN BEGIN
        WITH Attachment DO BEGIN
          LOCKTABLE;
          IF (SegLine."Line No." <> 0) AND GET(SegLine."Attachment No.") THEN BEGIN
            RemoveAttachment(FALSE);
            AttachmentTemp."No." := SegLine."Attachment No.";
          END;

          COPY(AttachmentTemp);
          "Read Only" := TRUE;
          WizSaveAttachment;
          INSERT(TRUE);
        END;

        MarketingSetup.GET;
        IF MarketingSetup."Attachment Storage Type" = MarketingSetup."Attachment Storage Type"::"Disk File" THEN
          IF Attachment."No." <> 0 THEN BEGIN
            FileName := Attachment.ConstDiskFileName;
            IF FileName <> '' THEN BEGIN
              FileMgt.DeleteServerFile(FileName);
              AttachmentTemp.ExportAttachmentToServerFile(FileName);
            END;
          END;
        SegLine."Attachment No." := Attachment."No.";
      END;

      IF SegLine."Line No." = 0 THEN BEGIN
        NextInteractLogEntryNo := GetNextInteractionLogEntryNo;

        InteractLogEntry.INIT;
        InteractLogEntry."Entry No." := NextInteractLogEntryNo;
        InteractLogEntry.CopyFromSegment(SegLine);
        InteractLogEntry.Postponed := Postponed;
        InteractLogEntry.INSERT
      END ELSE BEGIN
        InteractLogEntry.GET(SegLine."Line No.");
        InteractLogEntry.CopyFromSegment(SegLine);
        InteractLogEntry.Postponed := Postponed;
        InteractLogEntry.MODIFY;
        InterLogEntryCommentLine.SETRANGE("Entry No.",InteractLogEntry."Entry No.");
        InterLogEntryCommentLine.DELETEALL;
      END;

      IF InterLogEntryCommentLineTmp.FINDSET THEN
        REPEAT
          InterLogEntryCommentLine.INIT;
          InterLogEntryCommentLine := InterLogEntryCommentLineTmp;
          InterLogEntryCommentLine."Entry No." := InteractLogEntry."Entry No.";
          InterLogEntryCommentLine.INSERT;
        UNTIL InterLogEntryCommentLineTmp.NEXT = 0;

      IF Deliver AND (SegLine."Correspondence Type" <> 0) AND (NOT Postponed) THEN BEGIN
        InteractLogEntry."Delivery Status" := InteractLogEntry."Delivery Status"::"In Progress";
        DeliverySorterTemp."No." := InteractLogEntry."Entry No.";
        DeliverySorterTemp."Attachment No." := Attachment."No.";
        DeliverySorterTemp."Correspondence Type" := InteractLogEntry."Correspondence Type";
        DeliverySorterTemp.Subject := InteractLogEntry.Subject;
        DeliverySorterTemp."Send Word Docs. as Attmt." := FALSE;
        DeliverySorterTemp."Language Code" := SegLine."Language Code";
        DeliverySorterTemp.INSERT;
        AttachmentManagement.Send(DeliverySorterTemp);
      END;
    END;

    [External]
    PROCEDURE LogDocument@2(DocumentType@1000 : Integer;DocumentNo@1001 : Code[20];DocNoOccurrence@1015 : Integer;VersionNo@1016 : Integer;AccountTableNo@1002 : Integer;AccountNo@1003 : Code[20];SalespersonCode@1004 : Code[20];CampaignNo@1018 : Code[20];Description@1005 : Text[50];OpportunityNo@1019 : Code[20]);
    VAR
      InteractTmpl@1006 : Record 5064;
      SegLine@1007 : TEMPORARY Record 5077;
      ContBusRel@1008 : Record 5054;
      Attachment@1009 : Record 5062;
      Cont@1010 : Record 5050;
      InteractTmplLanguage@1014 : Record 5103;
      InterLogEntryCommentLine@1017 : TEMPORARY Record 5123;
      InteractTmplCode@1012 : Code[10];
      ContNo@1013 : Code[20];
    BEGIN
      InteractTmplCode := FindInteractTmplCode(DocumentType);
      IF InteractTmplCode = '' THEN
        EXIT;

      InteractTmpl.GET(InteractTmplCode);

      InteractTmplLanguage.SETRANGE("Interaction Template Code",InteractTmplCode);
      IF InteractTmplLanguage.FINDFIRST THEN
        ERROR(Text003,InteractTmplCode,InteractTmplLanguage."Language Code");

      IF Description = '' THEN
        Description := InteractTmpl.Description;

      CASE AccountTableNo OF
        DATABASE::Customer:
          BEGIN
            ContNo := FindContactFromContBusRelation(ContBusRel."Link to Table"::Customer,AccountNo);
            IF ContNo = '' THEN
              EXIT;
          END;
        DATABASE::Vendor:
          BEGIN
            ContNo := FindContactFromContBusRelation(ContBusRel."Link to Table"::Vendor,AccountNo);
            IF ContNo = '' THEN
              EXIT;
          END;
        DATABASE::Contact:
          BEGIN
            IF NOT Cont.GET(AccountNo) THEN
              EXIT;
            IF SalespersonCode = '' THEN
              SalespersonCode := Cont."Salesperson Code";
            ContNo := AccountNo;
          END;
      END;

      SegLine.INIT;
      SegLine."Document Type" := DocumentType;
      SegLine."Document No." := DocumentNo;
      SegLine."Doc. No. Occurrence" := DocNoOccurrence;
      SegLine."Version No." := VersionNo;
      SegLine.VALIDATE("Contact No.",ContNo);
      SegLine.Date := TODAY;
      SegLine."Time of Interaction" := TIME;
      SegLine.Description := Description;
      SegLine."Salesperson Code" := SalespersonCode;
      SegLine."Opportunity No." := OpportunityNo;
      SegLine.INSERT;
      SegLine.VALIDATE("Interaction Template Code",InteractTmplCode);
      IF CampaignNo <> '' THEN
        SegLine."Campaign No." := CampaignNo;
      SegLine.MODIFY;

      LogInteraction(SegLine,Attachment,InterLogEntryCommentLine,FALSE,FALSE);
    END;

    [External]
    PROCEDURE FindInteractTmplCode@7(DocumentType@1000 : Integer) InteractTmplCode@1001 : Code[10];
    BEGIN
      IF InteractionTmplSetup.GET THEN
        CASE DocumentType OF
          1:
            InteractTmplCode := InteractionTmplSetup."Sales Quotes";
          2:
            InteractTmplCode := InteractionTmplSetup."Sales Blnkt. Ord";
          3:
            InteractTmplCode := InteractionTmplSetup."Sales Ord. Cnfrmn.";
          4:
            InteractTmplCode := InteractionTmplSetup."Sales Invoices";
          5:
            InteractTmplCode := InteractionTmplSetup."Sales Shpt. Note";
          6:
            InteractTmplCode := InteractionTmplSetup."Sales Cr. Memo";
          7:
            InteractTmplCode := InteractionTmplSetup."Sales Statement";
          8:
            InteractTmplCode := InteractionTmplSetup."Sales Rmdr.";
          9:
            InteractTmplCode := InteractionTmplSetup."Serv Ord Create";
          10:
            InteractTmplCode := InteractionTmplSetup."Serv Ord Post";
          11:
            InteractTmplCode := InteractionTmplSetup."Purch. Quotes";
          12:
            InteractTmplCode := InteractionTmplSetup."Purch Blnkt Ord";
          13:
            InteractTmplCode := InteractionTmplSetup."Purch. Orders";
          14:
            InteractTmplCode := InteractionTmplSetup."Purch Invoices";
          15:
            InteractTmplCode := InteractionTmplSetup."Purch. Rcpt.";
          16:
            InteractTmplCode := InteractionTmplSetup."Purch Cr Memos";
          17:
            InteractTmplCode := InteractionTmplSetup."Cover Sheets";
          18:
            InteractTmplCode := InteractionTmplSetup."Sales Return Order";
          19:
            InteractTmplCode := InteractionTmplSetup."Sales Finance Charge Memo";
          20:
            InteractTmplCode := InteractionTmplSetup."Sales Return Receipt";
          21:
            InteractTmplCode := InteractionTmplSetup."Purch. Return Shipment";
          22:
            InteractTmplCode := InteractionTmplSetup."Purch. Return Ord. Cnfrmn.";
          23:
            InteractTmplCode := InteractionTmplSetup."Service Contract";
          24:
            InteractTmplCode := InteractionTmplSetup."Service Contract Quote";
          25:
            InteractTmplCode := InteractionTmplSetup."Service Quote";
        END;
      IF EmailDraftLogging THEN
        InteractTmplCode := FindEmailDraftInteractTmplCode;
      EXIT(InteractTmplCode);
    END;

    LOCAL PROCEDURE FindEmailDraftInteractTmplCode@14() : Code[10];
    BEGIN
      InteractionTmplSetup.GET;
      EXIT(InteractionTmplSetup."E-Mail Draft");
    END;

    LOCAL PROCEDURE TestFields@5(VAR SegLine@1000 : Record 5077);
    VAR
      Cont@1001 : Record 5050;
      Salesperson@1002 : Record 13;
      Campaign@1003 : Record 5071;
      InteractTmpl@1004 : Record 5064;
      ContAltAddr@1005 : Record 5051;
    BEGIN
      WITH SegLine DO BEGIN
        TESTFIELD(Date);
        TESTFIELD("Contact No.");
        Cont.GET("Contact No.");
        IF "Document Type" = "Document Type"::" " THEN BEGIN
          TESTFIELD("Salesperson Code");
          Salesperson.GET("Salesperson Code");
        END;
        TESTFIELD("Interaction Template Code");
        InteractTmpl.GET("Interaction Template Code");
        IF "Campaign No." <> '' THEN
          Campaign.GET("Campaign No.");
        CASE "Correspondence Type" OF
          "Correspondence Type"::Email:
            BEGIN
              IF Cont."E-Mail" = '' THEN
                "Correspondence Type" := "Correspondence Type"::" ";

              IF ContAltAddr.GET("Contact No.","Contact Alt. Address Code") THEN
                IF ContAltAddr."E-Mail" <> '' THEN
                  "Correspondence Type" := "Correspondence Type"::Email;
            END;
          "Correspondence Type"::Fax:
            BEGIN
              IF Cont."Fax No." = '' THEN
                "Correspondence Type" := "Correspondence Type"::" ";

              IF ContAltAddr.GET("Contact No.","Contact Alt. Address Code") THEN
                IF ContAltAddr."Fax No." <> '' THEN
                  "Correspondence Type" := "Correspondence Type"::Fax;
            END;
        END;
      END;
    END;

    LOCAL PROCEDURE CopyFieldsToCampaignEntry@11(VAR CampaignEntry@1000 : Record 5072;VAR SegLine@1001 : Record 5077);
    VAR
      SegHeader@1002 : Record 5076;
    BEGIN
      CampaignEntry.CopyFromSegment(SegLine);
      IF SegLine."Segment No." <> '' THEN BEGIN
        SegHeader.GET(SegLine."Segment No.");
        CampaignEntry.Description := SegHeader.Description;
      END ELSE BEGIN
        CampaignEntry.Description :=
          COPYSTR(FindInteractTmplSetupCaption(SegLine."Document Type"),1,MAXSTRLEN(CampaignEntry.Description));
        IF CampaignEntry.Description = '' THEN
          CampaignEntry.Description := Text004;
      END;
    END;

    LOCAL PROCEDURE FindInteractTmplSetupCaption@6(DocumentType@1000 : Integer) InteractTmplSetupCaption@1001 : Text[80];
    BEGIN
      InteractionTmplSetup.GET;
      CASE DocumentType OF
        1:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Sales Quotes");
        2:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Sales Blnkt. Ord");
        3:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Sales Ord. Cnfrmn.");
        4:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Sales Invoices");
        5:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Sales Shpt. Note");
        6:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Sales Cr. Memo");
        7:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Sales Statement");
        8:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Sales Rmdr.");
        9:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Serv Ord Create");
        10:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Serv Ord Post");
        11:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Purch. Quotes");
        12:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Purch Blnkt Ord");
        13:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Purch. Orders");
        14:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Purch Invoices");
        15:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Purch. Rcpt.");
        16:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Purch Cr Memos");
        17:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Cover Sheets");
        18:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Sales Return Order");
        19:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Sales Finance Charge Memo");
        20:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Sales Return Receipt");
        21:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Purch. Return Shipment");
        22:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Purch. Return Ord. Cnfrmn.");
        23:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Service Contract");
        24:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Service Contract Quote");
        25:
          InteractTmplSetupCaption := InteractionTmplSetup.FIELDCAPTION("Service Quote");
      END;
      EXIT(InteractTmplSetupCaption);
    END;

    LOCAL PROCEDURE FindContactFromContBusRelation@13(LinkToTable@1000 : Option;AccountNo@1001 : Code[20]) : Code[20];
    VAR
      ContBusRel@1002 : Record 5054;
    BEGIN
      WITH ContBusRel DO BEGIN
        SETRANGE("Link to Table",LinkToTable);
        SETRANGE("No.",AccountNo);
        IF FINDFIRST THEN
          EXIT("Contact No.");
      END;
    END;

    PROCEDURE CreateCampaignEntryOnSalesInvoicePosting@9(SalesInvHeader@1000 : Record 112);
    VAR
      Campaign@1004 : Record 5071;
      CampaignTargetGr@1001 : Record 7030;
      ContBusRel@1006 : Record 5054;
      InteractionLogEntry@1008 : Record 5065;
      InteractTemplate@1010 : Record 5064;
      InteractionTemplateCode@1002 : Code[10];
      ContNo@1003 : Code[20];
    BEGIN
      WITH SalesInvHeader DO BEGIN
        CampaignTargetGr.SETRANGE(Type,CampaignTargetGr.Type::Customer);
        CampaignTargetGr.SETRANGE("No.","Bill-to Customer No.");
        IF NOT CampaignTargetGr.FINDFIRST THEN
          EXIT;

        Campaign.GET(CampaignTargetGr."Campaign No.");
        IF ("Posting Date" < Campaign."Starting Date") OR ("Posting Date" > Campaign."Ending Date") THEN
          EXIT;

        ContNo := FindContactFromContBusRelation(ContBusRel."Link to Table"::Customer,"Bill-to Customer No.");

        // Check if Interaction Log Entry already exist for initial Sales Order
        InteractionTemplateCode := FindInteractTmplCode(SalesInvoiceInterDocType);
        IF InteractionTemplateCode = '' THEN
          ERROR(InterTemplateSalesInvoicesNotSpecifiedErr);
        InteractTemplate.GET(InteractionTemplateCode);
        InteractionLogEntry.SETRANGE("Contact No.",ContNo);
        InteractionLogEntry.SETRANGE("Document Type",SalesInvoiceInterDocType);
        InteractionLogEntry.SETRANGE("Document No.","Order No.");
        InteractionLogEntry.SETRANGE("Interaction Group Code",InteractTemplate."Interaction Group Code");
        IF NOT InteractionLogEntry.ISEMPTY THEN
          EXIT;

        LogDocument(
          SalesInvoiceInterDocType,"No.",0,0,DATABASE::Contact,"Bill-to Contact No.","Salesperson Code",
          CampaignTargetGr."Campaign No.","Posting Description",'');
      END;
    END;

    [External]
    PROCEDURE SalesOrderConfirmInterDocType@10() : Integer;
    BEGIN
      EXIT(3);
    END;

    [External]
    PROCEDURE SalesInvoiceInterDocType@15() : Integer;
    BEGIN
      EXIT(4);
    END;

    LOCAL PROCEDURE EmailDraftLogging@12() : Boolean;
    BEGIN
      EXIT(InteractionMgt.GetEmailDraftLogging);
    END;

    LOCAL PROCEDURE GetNextInteractionLogEntryNo@22() : Integer;
    VAR
      InteractionLogEntry@1000 : Record 5065 SECURITYFILTERING(Ignored);
    BEGIN
      WITH InteractionLogEntry DO BEGIN
        LOCKTABLE;
        IF FINDLAST THEN;
        EXIT("Entry No." + 1);
      END;
    END;

    LOCAL PROCEDURE GetNextLoggedSegmentEntryNo@20() : Integer;
    VAR
      LoggedSegment@1000 : Record 5075 SECURITYFILTERING(Ignored);
    BEGIN
      WITH LoggedSegment DO BEGIN
        LOCKTABLE;
        IF FINDLAST THEN;
        EXIT("Entry No." + 1);
      END;
    END;

    LOCAL PROCEDURE GetNextCampaignEntryNo@21() : Integer;
    VAR
      CampaignEntry@1000 : Record 5072 SECURITYFILTERING(Ignored);
    BEGIN
      WITH CampaignEntry DO BEGIN
        LOCKTABLE;
        IF FINDLAST THEN;
        EXIT("Entry No." + 1);
      END;
    END;

    LOCAL PROCEDURE GetCampaignEntryNo@18(SegmentLine@1002 : Record 5077;LoggedSegmentEntryNo@1001 : Integer) : Integer;
    VAR
      CampaignEntry@1000 : Record 5072;
    BEGIN
      CampaignEntry.SETCURRENTKEY("Campaign No.",Date,"Document Type");
      CampaignEntry.SETRANGE("Document Type",SegmentLine."Document Type");
      CampaignEntry.SETRANGE("Campaign No.",SegmentLine."Campaign No.");
      CampaignEntry.SETRANGE("Segment No.",SegmentLine."Segment No.");
      IF CampaignEntry.FINDFIRST THEN
        EXIT(CampaignEntry."Entry No.");

      CampaignEntry.RESET;
      CampaignEntry.INIT;
      CampaignEntry."Entry No." := GetNextCampaignEntryNo;
      IF LoggedSegmentEntryNo <> 0 THEN
        CampaignEntry."Register No." := LoggedSegmentEntryNo;
      CopyFieldsToCampaignEntry(CampaignEntry,SegmentLine);
      CampaignEntry.INSERT;
      EXIT(CampaignEntry."Entry No.");
    END;

    BEGIN
    END.
  }
}

