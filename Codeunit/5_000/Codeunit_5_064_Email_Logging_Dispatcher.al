OBJECT Codeunit 5064 Email Logging Dispatcher
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    TableNo=472;
    OnRun=VAR
            MarketingSetup@1003 : Record 5079;
            StorageFolder@1001 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder";
            QueueFolder@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder";
            WebCredentials@1002 : DotNet "'Microsoft.Exchange.WebServices, Version=15.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Exchange.WebServices.Data.WebCredentials";
          BEGIN
            IF ISNULLGUID(ID) THEN
              EXIT;

            SetErrorContext(Text101);
            CheckSetup(MarketingSetup);

            SetErrorContext(Text102);
            IF MarketingSetup."Exchange Account User Name" <> '' THEN
              MarketingSetup.CreateExchangeAccountCredentials(WebCredentials);

            IF NOT ExchangeWebServicesServer.Initialize2010(MarketingSetup."Autodiscovery E-Mail Address",
                 MarketingSetup."Exchange Service URL",WebCredentials,FALSE)
            THEN
              ERROR(Text001);

            SetErrorContext(Text103);
            IF NOT ExchangeWebServicesServer.GetEmailFolder(MarketingSetup.GetQueueFolderUID,QueueFolder) THEN
              ERROR(Text002,MarketingSetup."Queue Folder Path");

            SetErrorContext(Text104);
            IF NOT ExchangeWebServicesServer.GetEmailFolder(MarketingSetup.GetStorageFolderUID,StorageFolder) THEN
              ERROR(Text002,MarketingSetup."Storage Folder Path");

            RunEMailBatch(MarketingSetup."Email Batch Size",QueueFolder,StorageFolder);
          END;

  }
  CODE
  {
    VAR
      ExchangeWebServicesServer@1012 : Codeunit 5321;
      Text001@1001 : TextConst 'DAN=Det lykkedes ikke at udf�re automatisk registrering af Exchange-tjenesten.;ENU=Autodiscovery of exchange service failed.';
      Text002@1000 : TextConst 'DAN=Mappen %1 findes ikke. Kontroller, at stien til mappen er korrekt i vinduet Marketingops�tning.;ENU=The %1 folder does not exist. Verify that the path to the folder is correct in the Marketing Setup window.';
      Text003@1003 : TextConst 'DAN=K�- eller lagermappen er ikke blevet initialiseret. Indtast mappestien i vinduet Marketingops�tning.;ENU=The queue or storage folder has not been initialized. Enter the folder path in the Marketing Setup window.';
      Text101@1004 : TextConst 'DAN=Validerer ops�tning;ENU=Validating setup';
      Text102@1005 : TextConst 'DAN=Initialisering og automatisk registrering af Exchange-webtjenesten er i gang;ENU=Initialization and autodiscovery of Exchange web service is in progress';
      Text103@1006 : TextConst 'DAN=�bner k�mappe;ENU=Opening queue folder';
      Text104@1007 : TextConst 'DAN=�bner lagringsmappe;ENU=Opening storage folder';
      Text105@1008 : TextConst 'DAN=L�ser mails;ENU=Reading email messages';
      Text106@1009 : TextConst 'DAN=Kontrollerer n�ste mail;ENU=Checking next email message';
      Text107@1010 : TextConst 'DAN=Logf�rer mails;ENU=Logging email messages';
      Text108@1011 : TextConst 'DAN=Sletter mail fra k�en;ENU=Deleting email message from queue';
      ErrorContext@1002 : Text;
      Text109@1014 : TextConst 'DAN=Interaktionsskabelonen til mails er ikke blevet angivet i vinduet Interaktionsskabelonops�tning.;ENU=The interaction template for email messages has not been specified in the Interaction Template Setup window.';
      Text110@1013 : TextConst 'DAN=Der er blevet angivet en skabelon til mails i vinduet Interaktionsskabelonops�tning, men skabelonen findes ikke.;ENU=An interaction template for email messages has been specified in the Interaction Template Setup window, but the template does not exist.';

    [Internal]
    PROCEDURE CheckSetup@18(VAR MarketingSetup@1001 : Record 5079);
    VAR
      ErrorMsg@1000 : Text;
    BEGIN
      IF NOT CheckInteractionTemplateSetup(ErrorMsg) THEN
        ERROR(ErrorMsg);

      MarketingSetup.GET;
      IF NOT (MarketingSetup."Queue Folder UID".HASVALUE AND MarketingSetup."Storage Folder UID".HASVALUE) THEN
        ERROR(Text003);

      MarketingSetup.TESTFIELD("Autodiscovery E-Mail Address");
    END;

    [Internal]
    PROCEDURE RunEMailBatch@2(BatchSize@1000 : Integer;VAR QueueFolder@1009 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder";VAR StorageFolder@1008 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder");
    VAR
      QueueFindResults@1004 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IFindEmailsResults";
      QueueEnumerator@1003 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
      QueueMessage@1002 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";
      EmailsLeftInBatch@1005 : Integer;
      PageSize@1001 : Integer;
    BEGIN
      EmailsLeftInBatch := BatchSize;
      REPEAT
        SetErrorContext(Text105);

        PageSize := 50;
        IF (BatchSize <> 0) AND (EmailsLeftInBatch < PageSize) THEN
          PageSize := EmailsLeftInBatch;

        // Keep using zero offset, since all processed messages are deleted from the queue folder
        QueueFindResults := QueueFolder.FindEmailMessages(PageSize,0);
        QueueEnumerator := QueueFindResults.GetEnumerator;
        WHILE QueueEnumerator.MoveNext DO BEGIN
          QueueMessage := QueueEnumerator.Current;
          ProcessMessage(QueueMessage,StorageFolder);
          SetErrorContext(Text108);
          QueueMessage.Delete;
        END;

        EmailsLeftInBatch := EmailsLeftInBatch - PageSize;
      UNTIL (NOT QueueFindResults.MoreAvailable) OR ((BatchSize <> 0) AND (EmailsLeftInBatch <= 0));
    END;

    [External]
    PROCEDURE GetErrorContext@1() : Text;
    BEGIN
      EXIT(ErrorContext);
    END;

    [External]
    PROCEDURE SetErrorContext@5(NewContext@1000 : Text);
    BEGIN
      ErrorContext := NewContext;
    END;

    [External]
    PROCEDURE ItemLinkedFromAttachment@10(MessageId@1002 : Text;VAR Attachment@1000 : Record 5062) : Boolean;
    BEGIN
      Attachment.SETRANGE("Email Message Checksum",Attachment.Checksum(MessageId));

      IF NOT Attachment.FINDSET THEN
        EXIT(FALSE);
      REPEAT
        IF Attachment.GetMessageID = MessageId THEN
          EXIT(TRUE);
      UNTIL (Attachment.NEXT = 0);
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE AttachmentRecordAlreadyExists@17(AttachmentNo@1002 : Text;VAR Attachment@1003 : Record 5062) : Boolean;
    VAR
      No@1001 : Integer;
    BEGIN
      IF EVALUATE(No,AttachmentNo) THEN
        EXIT(Attachment.GET(No));
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE SalespersonRecipients@12(Message@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";VAR SegLine@1001 : Record 5077) : Boolean;
    VAR
      RecepientEnumerator@1002 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
      Recepient@1004 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailAddress";
      RecepientAddress@1007 : Text;
    BEGIN
      RecepientEnumerator := Message.Recipients.GetEnumerator;
      WHILE RecepientEnumerator.MoveNext DO BEGIN
        Recepient := RecepientEnumerator.Current;
        RecepientAddress := Recepient.Address;
        IF IsSalesperson(RecepientAddress,SegLine."Salesperson Code") THEN BEGIN
          SegLine.INSERT;
          SegLine."Line No." := SegLine."Line No." + 1;
        END;
      END;
      EXIT(NOT SegLine.ISEMPTY);
    END;

    LOCAL PROCEDURE ContactRecipients@11(Message@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";VAR SegLine@1001 : Record 5077) : Boolean;
    VAR
      RecepientEnumerator@1004 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.IEnumerator";
      RecepientAddress@1007 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailAddress";
    BEGIN
      RecepientEnumerator := Message.Recipients.GetEnumerator;
      WHILE RecepientEnumerator.MoveNext DO BEGIN
        RecepientAddress := RecepientEnumerator.Current;
        IF IsContact(RecepientAddress.Address,SegLine) THEN BEGIN
          SegLine.INSERT;
          SegLine."Line No." := SegLine."Line No." + 1;
        END;
      END;
      EXIT(NOT SegLine.ISEMPTY);
    END;

    LOCAL PROCEDURE IsMessageToLog@3(QueueMessage@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";StorageFolder@1002 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder";VAR SegLine@1003 : Record 5077;VAR Attachment@1008 : Record 5062) : Boolean;
    VAR
      StorageMessage@1007 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";
      Sender@1004 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailAddress";
      SenderAddress@1001 : Text;
      MessageId@1006 : Text;
    BEGIN
      IF QueueMessage.IsSensitive THEN
        EXIT(FALSE);

      Sender := QueueMessage.SenderAddress;
      IF Sender.IsEmpty OR (QueueMessage.RecipientsCount = 0) THEN
        EXIT(FALSE);

      IF ExchangeWebServicesServer.IdenticalMailExists(QueueMessage,StorageFolder,StorageMessage) THEN BEGIN
        MessageId := StorageMessage.Id;
        StorageMessage.Delete;
        IF ItemLinkedFromAttachment(MessageId,Attachment) THEN
          EXIT(TRUE);
      END;

      IF AttachmentRecordAlreadyExists(QueueMessage.NavAttachmentNo,Attachment) THEN
        EXIT(TRUE);

      // Check if in- or out-bound and store sender and recipients in segment line(s)
      SenderAddress := Sender.Address;
      IF IsSalesperson(SenderAddress,SegLine."Salesperson Code") THEN BEGIN
        SegLine."Information Flow" := SegLine."Information Flow"::Outbound;
        IF NOT ContactRecipients(QueueMessage,SegLine) THEN
          EXIT(FALSE);
      END ELSE BEGIN
        IF IsContact(SenderAddress,SegLine) THEN BEGIN
          SegLine."Information Flow" := SegLine."Information Flow"::Inbound;
          IF NOT SalespersonRecipients(QueueMessage,SegLine) THEN
            EXIT(FALSE);
        END ELSE
          EXIT(FALSE);
      END;

      EXIT(NOT SegLine.ISEMPTY);
    END;

    [External]
    PROCEDURE UpdateSegLine@15(VAR SegLine@1000 : Record 5077;Emails@1001 : Code[10];Subject@1002 : Text;DateSent@1005 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";DateReceived@1006 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";AttachmentNo@1003 : Integer);
    VAR
      LineDate@1007 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTime";
      DateTimeKind@1008 : DotNet "'mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.DateTimeKind";
      InformationFlow@1004 : Integer;
    BEGIN
      InformationFlow := SegLine."Information Flow";
      SegLine.VALIDATE("Interaction Template Code",Emails);
      SegLine."Information Flow" := InformationFlow;
      SegLine."Correspondence Type" := SegLine."Correspondence Type"::Email;
      SegLine.Description := COPYSTR(Subject,1,MAXSTRLEN(SegLine.Description));

      IF SegLine."Information Flow" = SegLine."Information Flow"::Outbound THEN BEGIN
        LineDate := DateSent;
        SegLine."Initiated By" := SegLine."Initiated By"::Us;
      END ELSE BEGIN
        LineDate := DateReceived;
        SegLine."Initiated By" := SegLine."Initiated By"::Them;
      END;

      // The date received from Exchange is UTC and to record the UTC date and time
      // using the AL functions requires datetime to be of the local date time kind.
      LineDate := LineDate.DateTime(LineDate.Ticks,DateTimeKind.Local);
      SegLine.Date := DT2DATE(LineDate);
      SegLine."Time of Interaction" := DT2TIME(LineDate);

      SegLine.Subject := COPYSTR(Subject,1,MAXSTRLEN(SegLine.Subject));
      SegLine."Attachment No." := AttachmentNo;
      SegLine.MODIFY;
    END;

    LOCAL PROCEDURE LogMessageAsInteraction@4(QueueMessage@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";StorageFolder@1001 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder";VAR SegLine@1002 : Record 5077;VAR Attachment@1006 : Record 5062);
    VAR
      InteractLogEntry@1009 : Record 5065;
      InteractionTemplateSetup@1011 : Record 5122;
      StorageMessage@1012 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";
      OStream@1004 : OutStream;
      Subject@1003 : Text;
      EMailMessageUrl@1007 : Text;
      AttachmentNo@1005 : Integer;
      NextInteractLogEntryNo@1013 : Integer;
    BEGIN
      IF NOT SegLine.ISEMPTY THEN BEGIN
        Subject := QueueMessage.Subject;

        Attachment.RESET;
        Attachment.LOCKTABLE;
        IF Attachment.FINDLAST THEN
          AttachmentNo := Attachment."No." + 1
        ELSE
          AttachmentNo := 1;

        Attachment.INIT;
        Attachment."No." := AttachmentNo;
        Attachment.INSERT;

        InteractionTemplateSetup.GET;
        SegLine.RESET;
        SegLine.FINDSET(TRUE);
        REPEAT
          UpdateSegLine(
            SegLine,InteractionTemplateSetup."E-Mails",Subject,QueueMessage.DateTimeSent,QueueMessage.DateTimeReceived,
            Attachment."No.");
        UNTIL SegLine.NEXT = 0;

        InteractLogEntry.LOCKTABLE;
        IF InteractLogEntry.FINDLAST THEN
          NextInteractLogEntryNo := InteractLogEntry."Entry No.";
        IF SegLine.FINDSET THEN
          REPEAT
            NextInteractLogEntryNo := NextInteractLogEntryNo + 1;
            InsertInteractionLogEntry(SegLine,NextInteractLogEntryNo);
          UNTIL SegLine.NEXT = 0;
      END;

      IF Attachment."No." <> 0 THEN BEGIN
        StorageMessage := QueueMessage.CopyToFolder(StorageFolder);
        Attachment.LinkToMessage(StorageMessage.Id,StorageMessage.EntryId,TRUE);

        StorageMessage.NavAttachmentNo := FORMAT(Attachment."No.");
        StorageMessage.Update;

        Attachment."Email Message Url".CREATEOUTSTREAM(OStream);
        EMailMessageUrl := StorageMessage.LinkUrl;
        IF EMailMessageUrl <> '' THEN
          OStream.WRITE(EMailMessageUrl);
        Attachment.MODIFY;

        COMMIT;
      END;
    END;

    [External]
    PROCEDURE InsertInteractionLogEntry@7(SegLine@1000 : Record 5077;EntryNo@1001 : Integer);
    VAR
      InteractLogEntry@1002 : Record 5065;
    BEGIN
      InteractLogEntry.INIT;
      InteractLogEntry."Entry No." := EntryNo;
      InteractLogEntry."Correspondence Type" := InteractLogEntry."Correspondence Type"::Email;
      InteractLogEntry.CopyFromSegment(SegLine);
      InteractLogEntry."E-Mail Logged" := TRUE;
      InteractLogEntry.INSERT;
    END;

    [External]
    PROCEDURE IsSalesperson@16(Email@1000 : Text;VAR SalespersonCode@1001 : Code[20]) : Boolean;
    VAR
      Salesperson@1002 : Record 13;
    BEGIN
      IF Email = '' THEN
        EXIT(FALSE);

      IF STRLEN(Email) > MAXSTRLEN(Salesperson."Search E-Mail") THEN
        EXIT(FALSE);

      Salesperson.SETCURRENTKEY("Search E-Mail");
      Salesperson.SETRANGE("Search E-Mail",Email);
      IF Salesperson.FINDFIRST THEN BEGIN
        SalespersonCode := Salesperson.Code;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE IsContact@19(EMail@1002 : Text;VAR SegLine@1000 : Record 5077) : Boolean;
    VAR
      Cont@1003 : Record 5050;
      ContAltAddress@1004 : Record 5051;
    BEGIN
      IF EMail = '' THEN
        EXIT(FALSE);

      IF STRLEN(EMail) > MAXSTRLEN(Cont."Search E-Mail") THEN
        EXIT(FALSE);

      Cont.SETCURRENTKEY("Search E-Mail");
      Cont.SETRANGE("Search E-Mail",EMail);
      IF Cont.FINDFIRST THEN BEGIN
        SegLine."Contact No." := Cont."No.";
        SegLine."Contact Company No." := Cont."Company No.";
        SegLine."Contact Alt. Address Code" := '';
        EXIT(TRUE);
      END;

      IF STRLEN(EMail) > MAXSTRLEN(ContAltAddress."Search E-Mail") THEN
        EXIT(FALSE);

      ContAltAddress.SETCURRENTKEY("Search E-Mail");
      ContAltAddress.SETRANGE("Search E-Mail",EMail);
      IF ContAltAddress.FINDFIRST THEN BEGIN
        SegLine."Contact No." := ContAltAddress."Contact No.";
        Cont.GET(ContAltAddress."Contact No.");
        SegLine."Contact Company No." := Cont."Company No.";
        SegLine."Contact Alt. Address Code" := ContAltAddress.Code;
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ProcessMessage@20(QueueMessage@1000 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailMessage";StorageFolder@1002 : DotNet "'Microsoft.Dynamics.Nav.EwsWrapper, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Exchange.IEmailFolder");
    VAR
      TempSegLine@1001 : TEMPORARY Record 5077;
      Attachment@1003 : Record 5062;
    BEGIN
      TempSegLine.DELETEALL;
      TempSegLine.INIT;

      Attachment.INIT;
      Attachment.RESET;

      SetErrorContext(Text106);
      IF IsMessageToLog(QueueMessage,StorageFolder,TempSegLine,Attachment) THEN BEGIN
        SetErrorContext(Text107);
        LogMessageAsInteraction(QueueMessage,StorageFolder,TempSegLine,Attachment);
      END;
    END;

    [External]
    PROCEDURE CheckInteractionTemplateSetup@21(VAR ErrorMsg@1000 : Text) : Boolean;
    VAR
      InteractionTemplateSetup@1001 : Record 5122;
      InteractionTemplate@1002 : Record 5064;
    BEGIN
      // Emails cannot be automatically logged unless the field Emails on Interaction Template Setup is set.
      InteractionTemplateSetup.GET;
      IF InteractionTemplateSetup."E-Mails" = '' THEN BEGIN
        ErrorMsg := Text109;
        EXIT(FALSE);
      END;

      // Since we have no guarantees that the Interaction Template for Emails exists, we check for it here.
      InteractionTemplate.SETFILTER(Code,'=%1',InteractionTemplateSetup."E-Mails");
      IF NOT InteractionTemplate.FINDFIRST THEN BEGIN
        ErrorMsg := Text110;
        EXIT(FALSE);
      END;

      EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

