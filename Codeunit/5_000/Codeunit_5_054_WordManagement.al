OBJECT Codeunit 5054 WordManagement
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text003@1003 : TextConst 'DAN=Fletter Microsoft Word-dokumenter...\\;ENU=Merging Microsoft Word Documents...\\';
      Text004@1004 : TextConst 'DAN=Forbereder;ENU=Preparing';
      Text005@1005 : TextConst 'DAN=Programstatus;ENU=Program status';
      Text006@1006 : TextConst 'DAN=Forbereder fletning...;ENU=Preparing Merge...';
      Text007@1007 : TextConst 'DAN=Venter p� udskriftsjob...;ENU=Waiting for print job...';
      Text008@1008 : TextConst 'DAN=Overf�rer %1-data til Microsoft Word...;ENU=Transferring %1 data to Microsoft Word...';
      Text009@1049 : TextConst 'DAN=Sender individuelle mails...;ENU=Sending individual email messages...';
      Text010@1010 : TextConst '@@@=Attachment No. must have File Extension DOC or DOCX.;DAN=%1 %2 skal have %3 DOC eller DOCX.;ENU=%1 %2 must have %3 DOC or DOCX.';
      Text011@1011 : TextConst 'DAN=Fejl i vedh�ftet fil.;ENU=Attachment file error.';
      Text012@1012 : TextConst 'DAN=Opretter flettekilde...;ENU=Creating merge source...';
      Text013@1013 : TextConst 'DAN=Microsoft Word �bner flettekilde...;ENU=Microsoft Word is opening merge source...';
      Text014@1014 : TextConst 'DAN=Fletter %1 i Microsoft Word...;ENU=Merging %1 in Microsoft Word...';
      Text015@1015 : TextConst 'DAN=FaxMailTil;ENU=FaxMailTo';
      Text017@1017 : TextConst 'DAN=Flettekildefilen er l�st af en anden proces.\;ENU=The merge source file is locked by another process.\';
      Text018@1018 : TextConst 'DAN=Pr�v igen senere.;ENU=Please try again later.';
      Text019@1019 : TextConst 'DAN=" Mailadresse";ENU=" Mail Address"';
      Text020@1020 : TextConst 'DAN="Dokument ";ENU="Document "';
      Text021@1021 : TextConst 'DAN="Indl�s vedh�ftet fil ";ENU="Import attachment "';
      Text022@1022 : TextConst 'DAN=Skal %1 slettes?;ENU=Delete %1?';
      Text023@1023 : TextConst 'DAN=En anden bruger har �ndret recorden for %1,\efter at du hentede den fra databasen.\\Indtast �ndringerne igen i det opdaterede bilag.;ENU=Another user has modified the record for this %1\after you retrieved it from the database.\\Enter the changes again in the updated document.';
      FileMgt@1038 : Codeunit 419;
      AttachmentManagement@1035 : Codeunit 5052;
      WordHelper@1037 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Word.WordHelper" RUNONCLIENT;
      Window@1034 : Dialog;
      Text030@1001 : TextConst 'DAN=Formel starthilsen;ENU=Formal Salutation';
      Text031@1000 : TextConst 'DAN=Uformel starthilsen;ENU=Informal Salutation';
      MergeSourceBufferFile@1016 : File;
      MergeSourceBufferFileName@1002 : Text;
      Text032@1024 : TextConst 'DAN=*.htm|*.htm;ENU=*.htm|*.htm';
      ImportAttachmentQst@1009 : TextConst '@@@=%1: Text Caption;DAN=Vil du importere den vedh�ftede fil %1?;ENU=Do you want to import attachment %1?';

    [Internal]
    PROCEDURE CreateWordAttachment@13(WordCaption@1001 : Text[260];LanguageCode@1100 : Code[10]) NewAttachNo@1000 : Integer;
    VAR
      Attachment@1002 : Record 5062;
      WordApplication@1009 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.ApplicationClass" RUNONCLIENT;
      WordDocument@1008 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.Document" RUNONCLIENT;
      WordMergefile@1007 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Word.MergeHandler" RUNONCLIENT;
      FileName@1004 : Text;
      MergeFileName@1005 : Text;
      ParamInt@1006 : Integer;
    BEGIN
      WordMergefile := WordMergefile.MergeHandler;

      MergeFileName := FileMgt.ClientTempFileName('HTM');
      CreateHeader(WordMergefile,TRUE,MergeFileName,LanguageCode); // Header without data

      WordApplication := WordApplication.ApplicationClass;
      Attachment."File Extension" := GetWordDocumentExtension(WordApplication.Version);
      WordDocument := WordHelper.AddDocument(WordApplication);
      WordDocument.MailMerge.MainDocumentType := 0; // 0 = wdFormLetters
      ParamInt := 7; // 7 = HTML
      WordHelper.CallMailMergeOpenDataSource(WordDocument,MergeFileName,ParamInt);

      FileName := Attachment.ConstFilename;
      WordHelper.CallSaveAs(WordDocument,FileName);
      IF WordHandler(WordDocument,Attachment,WordCaption,FALSE,FileName,FALSE) THEN
        NewAttachNo := Attachment."No."
      ELSE
        NewAttachNo := 0;

      CLEAR(WordMergefile);
      CLEAR(WordDocument);
      WordHelper.CallQuit(WordApplication,FALSE);
      CLEAR(WordApplication);

      DeleteFile(MergeFileName);
    END;

    [Internal]
    PROCEDURE OpenWordAttachment@5(VAR Attachment@1000 : Record 5062;FileName@1001 : Text;Caption@1002 : Text[260];IsTemporary@1003 : Boolean;LanguageCode@1100 : Code[10]);
    VAR
      WordApplication@1009 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.ApplicationClass" RUNONCLIENT;
      WordDocument@1008 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.Document" RUNONCLIENT;
      WordMergefile@1007 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Word.MergeHandler" RUNONCLIENT;
      MergeFileName@1005 : Text;
      ParamInt@1006 : Integer;
    BEGIN
      WordMergefile := WordMergefile.MergeHandler;

      MergeFileName := FileMgt.ClientTempFileName('HTM');
      CreateHeader(WordMergefile,TRUE,MergeFileName,LanguageCode);

      WordApplication := WordApplication.ApplicationClass;

      WordDocument := WordHelper.CallOpen(WordApplication,FileName,FALSE,Attachment."Read Only");

      IF ISNULL(WordDocument.MailMerge.MainDocumentType) THEN BEGIN
        WordDocument.MailMerge.MainDocumentType := 0; // 0 = wdFormLetters
        WordHelper.CallMailMergeOpenDataSource(WordDocument,MergeFileName,ParamInt);
      END;

      IF WordDocument.MailMerge.Fields.Count > 0 THEN BEGIN
        ParamInt := 7; // 7 = HTML
        WordHelper.CallMailMergeOpenDataSource(WordDocument,MergeFileName,ParamInt);
      END;

      WordHandler(WordDocument,Attachment,Caption,IsTemporary,FileName,FALSE);

      CLEAR(WordMergefile);
      CLEAR(WordDocument);
      WordHelper.CallQuit(WordApplication,FALSE);
      CLEAR(WordApplication);

      DeleteFile(MergeFileName);
    END;

    [Internal]
    PROCEDURE Merge@1(VAR TempDeliverySorter@1000 : TEMPORARY Record 5074);
    VAR
      TempDeliverySorter2@1001 : TEMPORARY Record 5074;
      WordApplication@1012 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.ApplicationClass" RUNONCLIENT;
      LastAttachmentNo@1002 : Integer;
      LastCorrType@1003 : Integer;
      LastSubject@1004 : Text[50];
      LastSendWordDocsAsAttmt@1005 : Boolean;
      LineCount@1006 : Integer;
      NoOfRecords@1007 : Integer;
      WordHided@1008 : Boolean;
      Param@1009 : Boolean;
      FirstRecord@1010 : Boolean;
    BEGIN
      Window.OPEN(
        Text003 +
        '#1############ @2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
        '#3############ @4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\\' +
        '#5############ #6################################');

      Window.UPDATE(1,Text004);
      Window.UPDATE(5,Text005);

      Window.UPDATE(6,Text006);
      TempDeliverySorter.SETCURRENTKEY(
        "Attachment No.","Correspondence Type",Subject,"Send Word Docs. as Attmt.");
      TempDeliverySorter.SETFILTER("Correspondence Type",'<>0');
      NoOfRecords := TempDeliverySorter.COUNT;
      TempDeliverySorter.FIND('-');

      WordApplication := WordApplication.ApplicationClass;
      IF WordApplication.Documents.Count > 0 THEN BEGIN
        WordApplication.Visible := FALSE;
        WordHided := TRUE;
      END;

      FirstRecord := TRUE;
      REPEAT
        LineCount := LineCount + 1;
        Window.UPDATE(2,ROUND(LineCount / NoOfRecords * 10000,1));
        Window.UPDATE(3,STRSUBSTNO('%1',TempDeliverySorter."Correspondence Type"));

        IF NOT FirstRecord AND
           ((TempDeliverySorter."Attachment No." <> LastAttachmentNo) OR
            (TempDeliverySorter."Correspondence Type" <> LastCorrType) OR
            (TempDeliverySorter.Subject <> LastSubject) OR
            (TempDeliverySorter."Send Word Docs. as Attmt." <> LastSendWordDocsAsAttmt))
        THEN BEGIN
          ExecuteMerge(WordApplication,TempDeliverySorter2);
          TempDeliverySorter2.DELETEALL;
          IF TempDeliverySorter."Attachment No." <> LastAttachmentNo THEN
            ImportMergeSourceFile(LastAttachmentNo)
        END;

        TempDeliverySorter2 := TempDeliverySorter;
        TempDeliverySorter2.INSERT;
        LastAttachmentNo := TempDeliverySorter."Attachment No.";
        LastCorrType := TempDeliverySorter."Correspondence Type";
        LastSubject := TempDeliverySorter.Subject;
        LastSendWordDocsAsAttmt := TempDeliverySorter."Send Word Docs. as Attmt.";

        FirstRecord := FALSE;
      UNTIL TempDeliverySorter.NEXT = 0;

      IF TempDeliverySorter2.FIND('-') THEN BEGIN
        ExecuteMerge(WordApplication,TempDeliverySorter2);
        ImportMergeSourceFile(TempDeliverySorter2."Attachment No.")
      END;

      IF WordHided THEN
        WordApplication.Visible := TRUE
      ELSE BEGIN
        // Wait for print job to finish
        IF WordApplication.BackgroundPrintingStatus <> 0 THEN
          REPEAT
            Window.UPDATE(6,Text007);
            SLEEP(500);
          UNTIL WordApplication.BackgroundPrintingStatus = 0;

        Param := FALSE;
        WordHelper.CallQuit(WordApplication,Param);
      END;

      CLEAR(WordApplication);
      Window.CLOSE;
    END;

    LOCAL PROCEDURE ExecuteMerge@6(VAR WordApplication@1021 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.ApplicationClass" RUNONCLIENT;VAR TempDeliverySorter@1000 : TEMPORARY Record 5074);
    VAR
      Attachment@1001 : Record 5062;
      InteractLogEntry@1002 : Record 5065;
      TempSegLine@1010 : TEMPORARY Record 5077;
      WordDocument@1020 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.Document" RUNONCLIENT;
      WordInlineShape@1009 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.InlineShape" RUNONCLIENT;
      WordMergefile@1019 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Word.MergeHandler" RUNONCLIENT;
      WordOLEFormat@1027 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.OLEFormat" RUNONCLIENT;
      WordLinkFormat@1023 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.LinkFormat" RUNONCLIENT;
      WordShape@1003 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.Shape" RUNONCLIENT;
      MergeFile@1028 : File;
      MergeClientFileName@1025 : Text;
      MainFileName@1011 : Text;
      NoOfRecords@1012 : Integer;
      ParamBln@1013 : Boolean;
      ParamInt@1014 : Integer;
      Row@1018 : Integer;
      ShapesIndex@1024 : Integer;
      HeaderIsReady@1026 : Boolean;
      FaxMailToValue@1030 : Text;
    BEGIN
      Window.UPDATE(
        6,STRSUBSTNO(Text008,
          FORMAT(TempDeliverySorter."Correspondence Type")));

      IF TempDeliverySorter.FIND('-') THEN
        NoOfRecords := TempDeliverySorter.COUNT;

      Attachment.GET(TempDeliverySorter."Attachment No.");
      Attachment.CALCFIELDS("Attachment File");

      // Handle Word documents without mergefields
      IF NOT DocumentContainMergefields(Attachment) AND
         TempDeliverySorter."Send Word Docs. as Attmt."
      THEN BEGIN
        SendAttachmentWithoutMergeFields(WordApplication,TempDeliverySorter,Attachment);
        EXIT;
      END;

      WITH TempDeliverySorter DO BEGIN
        SETCURRENTKEY("Attachment No.","Correspondence Type",Subject);
        FIND('-');
      END;
      Row := 2;

      MainFileName := FileMgt.ClientTempFileName('DOC');
      TempDeliverySorter.FIND('-');
      Attachment.GET(TempDeliverySorter."Attachment No.");
      Attachment.CALCFIELDS("Attachment File");
      IF NOT IsWordDocumentExtension(Attachment."File Extension") THEN
        ERROR(STRSUBSTNO(Text010,Attachment.TABLECAPTION,Attachment."No.",Attachment.FIELDCAPTION("File Extension")));

      IF NOT Attachment.ExportAttachmentToClientFile(MainFileName) THEN
        ERROR(Text011);

      Window.UPDATE(6,Text012);
      Attachment.CALCFIELDS("Merge Source");
      IF Attachment."Merge Source".HASVALUE THEN BEGIN
        CreateMergeSource(MergeFile);
        REPEAT
          PopulateInterLogEntryToMergeSource(
            MergeFile,Attachment,TempDeliverySorter."No.",HeaderIsReady,TempDeliverySorter."Correspondence Type");
          Row := Row + 1;
          Window.UPDATE(4,ROUND(Row / NoOfRecords * 10000,1))
        UNTIL TempDeliverySorter.NEXT = 0;
        MergeClientFileName := CloseAndDownloadMergeSource(MergeFile);
      END ELSE BEGIN
        MergeClientFileName := FileMgt.ClientTempFileName('HTM');
        WordMergefile := WordMergefile.MergeHandler;
        CreateHeader(WordMergefile,FALSE,MergeClientFileName,TempDeliverySorter."Language Code");
        REPEAT
          InteractLogEntry.GET(TempDeliverySorter."No.");

          // This field must come last in the merge source file
          CASE TempDeliverySorter."Correspondence Type" OF
            TempDeliverySorter."Correspondence Type"::Fax:
              FaxMailToValue := AttachmentManagement.InteractionFax(InteractLogEntry);
            TempDeliverySorter."Correspondence Type"::Email:
              FaxMailToValue := AttachmentManagement.InteractionEMail(InteractLogEntry);
            ELSE
              FaxMailToValue := '';
          END;

          AddFieldsToMergeSource(WordMergefile,InteractLogEntry,TempSegLine,FaxMailToValue);
          Row := Row + 1;
          Window.UPDATE(4,ROUND(Row / NoOfRecords * 10000,1))
        UNTIL TempDeliverySorter.NEXT = 0;
        WordMergefile.CloseMergeFile;
      END;

      WordDocument := WordHelper.CallOpen(WordApplication,MainFileName,FALSE,FALSE);
      WordDocument.MailMerge.MainDocumentType := 0;

      Window.UPDATE(6,Text013);
      ParamInt := 7; // 7 = HTML
      WordHelper.CallMailMergeOpenDataSource(WordDocument,MergeClientFileName,ParamInt);
      Window.UPDATE(6,STRSUBSTNO(Text014,TempDeliverySorter."Correspondence Type"));

      FOR ShapesIndex := 1 TO WordDocument.InlineShapes.Count DO BEGIN
        WordInlineShape := WordHelper.GetInlineShapeItem(WordDocument,ShapesIndex);
        WordInlineShape.Select;
        IF NOT ISNULL(WordInlineShape) THEN BEGIN
          WordShape := WordInlineShape.ConvertToShape;
          WordLinkFormat := WordShape.LinkFormat;
          WordOLEFormat := WordShape.OLEFormat;
          IF NOT ISNULL(WordOLEFormat) THEN
            WordDocument.MailMerge.MailAsAttachment := WordDocument.MailMerge.MailAsAttachment OR WordOLEFormat.DisplayAsIcon;
          IF NOT ISNULL(WordLinkFormat) THEN BEGIN
            WordLinkFormat.SavePictureWithDocument := TRUE;
            WordLinkFormat.BreakLink;
            WordLinkFormat.Update;
          END;
          WordInlineShape := WordShape.ConvertToInlineShape;
        END;
      END;

      CASE TempDeliverySorter."Correspondence Type" OF
        TempDeliverySorter."Correspondence Type"::Fax:
          BEGIN
            WordDocument.MailMerge.Destination := 3;
            WordDocument.MailMerge.MailAddressFieldName := Text015;
            WordDocument.MailMerge.MailAsAttachment := TRUE;
            WordHelper.CallMailMergeExecute(WordDocument);
          END;
        TempDeliverySorter."Correspondence Type"::Email:
          BEGIN
            WordDocument.MailMerge.Destination := 2;
            WordDocument.MailMerge.MailAddressFieldName := Text015;
            WordDocument.MailMerge.MailSubject := TempDeliverySorter.Subject;
            WordDocument.MailMerge.MailAsAttachment :=
              WordDocument.MailMerge.MailAsAttachment OR TempDeliverySorter."Send Word Docs. as Attmt.";
            WordHelper.CallMailMergeExecute(WordDocument);
          END;
        TempDeliverySorter."Correspondence Type"::"Hard Copy":
          BEGIN
            WordDocument.MailMerge.Destination := 0; // 0 = wdSendToNewDocument
            WordHelper.CallMailMergeExecute(WordDocument);
            WordHelper.CallPrintOut(WordHelper.GetActiveDocument(WordApplication));
          END;
      END;

      // Update delivery status on Interaction Log Entry
      IF TempDeliverySorter.FIND('-') THEN BEGIN
        InteractLogEntry.LOCKTABLE;
        REPEAT
          WITH InteractLogEntry DO BEGIN
            GET(TempDeliverySorter."No.");
            "Delivery Status" := "Delivery Status"::" ";
            MODIFY;
          END;
        UNTIL TempDeliverySorter.NEXT = 0;
        COMMIT;
      END;

      ParamBln := FALSE;
      WordHelper.CallClose(WordDocument,ParamBln);
      IF NOT Attachment."Merge Source".HASVALUE THEN
        AppendToMergeSource(MergeClientFileName);
      DeleteFile(MainFileName);
      DeleteFile(MergeClientFileName);

      IF NOT ISNULL(WordLinkFormat) THEN
        CLEAR(WordLinkFormat);
      IF NOT ISNULL(WordOLEFormat) THEN
        CLEAR(WordOLEFormat);
      CLEAR(WordMergefile);
      CLEAR(WordDocument);
    END;

    [Internal]
    PROCEDURE ShowMergedDocument@11(VAR SegLine@1000 : Record 5077;VAR Attachment@1001 : Record 5062;WordCaption@1002 : Text[260];IsTemporary@1016 : Boolean);
    BEGIN
      RunMergedDocument(SegLine,Attachment,WordCaption,IsTemporary,TRUE,TRUE);
    END;

    [External]
    PROCEDURE CreateHeader@4(VAR WordMergefile@1011 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Word.MergeHandler" RUNONCLIENT;MergeFieldsOnly@1000 : Boolean;MergeFileName@1001 : Text;LanguageCode@1100 : Code[10]);
    VAR
      Salesperson@1002 : Record 13;
      Country@1003 : Record 9;
      Contact@1004 : Record 5050;
      SegLine@1005 : Record 5077;
      CompanyInfo@1006 : Record 79;
      RMSetup@1010 : Record 5079;
      InteractionLogEntry@1012 : Record 5065;
      Language@1013 : Record 8;
      I@1007 : Integer;
      MainLanguage@1009 : Integer;
    BEGIN
      IF NOT WordMergefile.CreateMergeFile(MergeFileName) THEN
        ERROR(Text017 + Text018);

      // Create HTML Header source
      WITH WordMergefile DO BEGIN
        MainLanguage := GLOBALLANGUAGE;

        IF LanguageCode = '' THEN BEGIN
          RMSetup.GET;
          IF RMSetup."Mergefield Language ID" <> 0 THEN
            GLOBALLANGUAGE := RMSetup."Mergefield Language ID";
        END ELSE
          GLOBALLANGUAGE := Language.GetLanguageID(LanguageCode);
        AddField(InteractionLogEntry.FIELDCAPTION("Entry No."));
        AddField(Contact.TABLECAPTION + Text019);
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("No."));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("Company Name"));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION(Name));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("Name 2"));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION(Address));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("Address 2"));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("Post Code"));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION(City));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION(County));
        AddField(Contact.TABLECAPTION + ' ' + Country.TABLECAPTION + ' ' + Country.FIELDCAPTION(Name));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("Job Title"));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("Phone No."));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("Fax No."));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("E-Mail"));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("Mobile Phone No."));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("VAT Registration No."));
        AddField(Contact.TABLECAPTION + ' ' + Contact.FIELDCAPTION("Home Page"));
        AddField(Text030);
        AddField(Text031);
        AddField(Salesperson.TABLECAPTION + ' ' + Salesperson.FIELDCAPTION(Code));
        AddField(Salesperson.TABLECAPTION + ' ' + Salesperson.FIELDCAPTION(Name));
        AddField(Salesperson.TABLECAPTION + ' ' + Salesperson.FIELDCAPTION("Job Title"));
        AddField(Salesperson.TABLECAPTION + ' ' + Salesperson.FIELDCAPTION("Phone No."));
        AddField(Salesperson.TABLECAPTION + ' ' + Salesperson.FIELDCAPTION("E-Mail"));
        AddField(Text020 + SegLine.FIELDCAPTION(Date));
        AddField(Text020 + SegLine.FIELDCAPTION("Campaign No."));
        AddField(Text020 + SegLine.FIELDCAPTION("Segment No."));
        AddField(Text020 + SegLine.FIELDCAPTION(Description));
        AddField(Text020 + SegLine.FIELDCAPTION(Subject));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION(Name));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION("Name 2"));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION(Address));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION("Address 2"));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION("Post Code"));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION(City));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION(County));
        AddField(CompanyInfo.TABLECAPTION + ' ' + Country.TABLECAPTION + ' ' + Country.FIELDCAPTION(Name));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION("VAT Registration No."));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION("Registration No."));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION("Phone No."));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION("Fax No."));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION("Bank Branch No."));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION("Bank Name"));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION("Bank Account No."));
        AddField(CompanyInfo.TABLECAPTION + ' ' + CompanyInfo.FIELDCAPTION("Giro No."));
        OnCreateHeaderAddFields(Salesperson,Country,Contact,CompanyInfo,SegLine,InteractionLogEntry);
        GLOBALLANGUAGE := MainLanguage;
        AddField(Text015);
        WriteLine;

        // Mergesource must be at least two lines
        IF MergeFieldsOnly THEN BEGIN
          FOR I := 1 TO 48 DO
            AddField('');
          WriteLine;
          CloseMergeFile;
        END;
      END;
    END;

    LOCAL PROCEDURE WordHandler@7(VAR WordDocument@1009 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.Document";VAR Attachment@1001 : Record 5062;Caption@1002 : Text[260];IsTemporary@1003 : Boolean;FileName@1004 : Text;IsInherited@1008 : Boolean) DocImported@1000 : Boolean;
    VAR
      Attachment2@1005 : Record 5062;
      WordHandler@1006 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Word.WordHandler" RUNONCLIENT;
      NewFileName@1007 : Text;
    BEGIN
      WordHandler := WordHandler.WordHandler;

      WordDocument.ActiveWindow.Caption := Caption;
      WordDocument.Application.Visible := TRUE; // Visible before WindowState KB176866 - http://support.microsoft.com/kb/176866
      WordDocument.ActiveWindow.WindowState := 1; // 1 = wdWindowStateMaximize
      WordDocument.Saved := TRUE;
      WordDocument.Application.Activate;

      NewFileName := WordHandler.WaitForDocument(WordDocument);

      IF NOT Attachment."Read Only" THEN
        IF WordHandler.IsDocumentClosed THEN
          IF WordHandler.HasDocumentChanged THEN BEGIN
            CLEAR(WordHandler);
            IF CONFIRM(ImportAttachmentQst,TRUE,Caption) THEN BEGIN
              IF (NOT IsTemporary) AND Attachment2.GET(Attachment."No.") THEN
                IF Attachment2."Last Time Modified" <> Attachment."Last Time Modified" THEN BEGIN
                  DeleteFile(FileName);
                  IF NewFileName <> FileName THEN
                    IF CONFIRM(STRSUBSTNO(Text022,NewFileName),FALSE) THEN
                      DeleteFile(NewFileName);
                  ERROR(STRSUBSTNO(Text023,Attachment.TABLECAPTION));
                END;
              Attachment.ImportAttachmentFromClientFile(NewFileName,IsTemporary,IsInherited);
              DeleteFile(NewFileName);
              DocImported := TRUE;
            END;
          END;

      CLEAR(WordHandler);
      DeleteFile(FileName);
    END;

    LOCAL PROCEDURE DeleteFile@8(FileName@1001 : Text) : Boolean;
    VAR
      I@1002 : Integer;
    BEGIN
      // Wait for Word to release the files
      IF FileName = '' THEN
        EXIT(FALSE);

      IF NOT FileMgt.ClientFileExists(FileName) THEN
        EXIT(TRUE);

      REPEAT
        SLEEP(250);
        I := I + 1;
      UNTIL FileMgt.DeleteClientFile(FileName) OR (I = 25);
      EXIT(NOT FileMgt.ClientFileExists(FileName));
    END;

    LOCAL PROCEDURE DocumentContainMergefields@2(VAR Attachment@1001 : Record 5062) MergeFields@1000 : Boolean;
    VAR
      WordApplication@1005 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.ApplicationClass" RUNONCLIENT;
      WordDocument@1004 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.Document" RUNONCLIENT;
      ParamBln@1002 : Boolean;
      FileName@1003 : Text;
    BEGIN
      WordApplication := WordApplication.ApplicationClass;
      IF (UPPERCASE(Attachment."File Extension") <> 'DOC') AND
         (UPPERCASE(Attachment."File Extension") <> 'DOCX')
      THEN
        EXIT(FALSE);
      FileName := Attachment.ConstFilename;
      Attachment.ExportAttachmentToClientFile(FileName);
      WordDocument := WordHelper.CallOpen(WordApplication,FileName,FALSE,FALSE);

      MergeFields := (WordDocument.MailMerge.Fields.Count > 0);
      ParamBln := FALSE;
      WordHelper.CallClose(WordDocument,ParamBln);
      DeleteFile(FileName);

      CLEAR(WordDocument);
      WordHelper.CallQuit(WordApplication,FALSE);
      CLEAR(WordApplication);
    END;

    LOCAL PROCEDURE CreateMergeSource@14(VAR MergeFile@1000 : File);
    VAR
      MergeServerFileName@1001 : Text;
    BEGIN
      MergeServerFileName := FileMgt.ServerTempFileName('HTM');
      MergeFile.WRITEMODE := TRUE;
      MergeFile.TEXTMODE := TRUE;
      MergeFile.CREATE(MergeServerFileName);
    END;

    LOCAL PROCEDURE CloseAndDownloadMergeSource@15(VAR MergeFile@1000 : File) MergeClientFileName : Text;
    VAR
      MergeServerFileName@1001 : Text;
    BEGIN
      MergeServerFileName := MergeFile.NAME;
      MergeFile.WRITE('</table>');
      MergeFile.WRITE('</body>');
      MergeFile.WRITE('</html>');
      MergeFile.CLOSE;

      MergeClientFileName := FileMgt.DownloadTempFile(MergeServerFileName);

      // We don't need the file any more on ServiceTier
      ERASE(MergeServerFileName);

      EXIT(MergeClientFileName);
    END;

    [Internal]
    PROCEDURE PopulateInterLogEntryToMergeSource@12(VAR MergeFile@1000 : File;VAR Attachment@1006 : Record 5062;EntryNo@1011 : Integer;VAR HeaderIsReady@1001 : Boolean;CorrespondenceType@1012 : ',Hard Copy,Email,Fax');
    VAR
      InteractLogEntry@1004 : Record 5065;
      InStreamBLOB@1005 : InStream;
      CurrentLine@1003 : Text[250];
      NewLine@1002 : Text[250];
      LineIsFound@1010 : Boolean;
    BEGIN
      Attachment.CALCFIELDS("Merge Source");
      Attachment."Merge Source".CREATEINSTREAM(InStreamBLOB);
      REPEAT
        InStreamBLOB.READTEXT(CurrentLine);
        IF (STRPOS(CurrentLine,'<tr>') > 0) AND HeaderIsReady THEN BEGIN
          InStreamBLOB.READTEXT(NewLine);
          IF STRPOS(NewLine,FORMAT(EntryNo)) > 0 THEN BEGIN
            MergeFile.WRITE(CurrentLine);
            MergeFile.WRITE(NewLine);
            LineIsFound := TRUE;
          END;
        END;

        IF NOT HeaderIsReady THEN BEGIN
          MergeFile.WRITE(CurrentLine);
          IF STRPOS(CurrentLine,'</tr>') > 0 THEN
            HeaderIsReady := TRUE
        END
      UNTIL LineIsFound OR InStreamBLOB.EOS;

      IF LineIsFound THEN BEGIN
        InStreamBLOB.READTEXT(NewLine);
        WHILE STRPOS(NewLine,'</tr>') = 0 DO BEGIN
          CurrentLine := NewLine;
          InStreamBLOB.READTEXT(NewLine);
          MergeFile.WRITE(CurrentLine);
        END;
        IF InteractLogEntry.GET(EntryNo) THEN BEGIN
          CASE CorrespondenceType OF
            CorrespondenceType::Fax:
              MergeFile.WRITE('<td>' + AttachmentManagement.InteractionFax(InteractLogEntry) + '</td>');
            CorrespondenceType::Email:
              MergeFile.WRITE('<td>' + AttachmentManagement.InteractionEMail(InteractLogEntry) + '</td>')
            ELSE
              MergeFile.WRITE('<td></td>')
          END
        END;
        MergeFile.WRITE(NewLine);
      END;
    END;

    [External]
    PROCEDURE AddFieldsToMergeSource@16(VAR WordMergefile@1012 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Word.MergeHandler" RUNONCLIENT;VAR InteractLogEntry@1000 : Record 5065;VAR SegLine@1007 : Record 5077;FaxMailToValue@1013 : Text);
    VAR
      Salesperson@1006 : Record 13;
      Country@1005 : Record 9;
      Country2@1004 : Record 9;
      Contact@1003 : Record 5050;
      CompanyInfo@1002 : Record 79;
      FormatAddr@1001 : Codeunit 365;
      ContAddr@1011 : ARRAY [8] OF Text[50];
      ContAddr2@1010 : ARRAY [8] OF Text[50];
      LineNo@1016 : Text;
      SalesPersonCode@1014 : Code[20];
      ContactNo@1015 : Code[20];
      ContactAltAddressCode@1017 : Code[10];
      LanguageCode@1019 : Code[10];
      Date@1018 : Date;
      ContactAddressDimension@1008 : Integer;
    BEGIN
      IF InteractLogEntry.ISEMPTY THEN BEGIN
        ContactNo := SegLine."Contact No.";
        SalesPersonCode := SegLine."Salesperson Code";
        LineNo := FORMAT(SegLine."Line No.");
        ContactAltAddressCode := SegLine."Contact Alt. Address Code";
        Date := SegLine.Date;
        LanguageCode := SegLine."Language Code";
      END ELSE BEGIN
        ContactNo := InteractLogEntry."Contact No.";
        SalesPersonCode := InteractLogEntry."Salesperson Code";
        LineNo := FORMAT(InteractLogEntry."Entry No.");
        ContactAltAddressCode := InteractLogEntry."Contact Alt. Address Code";
        Date := InteractLogEntry.Date;
        LanguageCode := InteractLogEntry."Interaction Language Code";
      END;

      Contact.GET(ContactNo);
      CompanyInfo.GET;
      IF NOT Country2.GET(CompanyInfo."Country/Region Code") THEN
        CLEAR(Country2);

      IF NOT Country.GET(Contact."Country/Region Code") THEN
        CLEAR(Country);

      IF NOT Salesperson.GET(SalesPersonCode) THEN
        CLEAR(Salesperson);

      // This field must come first in the merge source file
      WordMergefile.AddField(LineNo);

      // Add multiline fielddata
      ContactAddressDimension := 1;
      FormatAddr.ContactAddrAlt(ContAddr,Contact,ContactAltAddressCode,Date);

      WordMergefile.OpenNewMultipleValueField;
      COPYARRAY(ContAddr2,ContAddr,1);
      COMPRESSARRAY(ContAddr2);
      WHILE ContAddr2[1] <> '' DO BEGIN
        IF ContAddr[ContactAddressDimension] <> '' THEN BEGIN
          WordMergefile.AddDataToMultipleValueField(ContAddr[ContactAddressDimension]);
          ContAddr2[1] := '';
          COMPRESSARRAY(ContAddr2);
        END ELSE
          WordMergefile.AddDataToMultipleValueField('&nbsp;');
        ContactAddressDimension := ContactAddressDimension + 1;
      END;
      WordMergefile.CloseMultipleValueField;

      WITH WordMergefile DO BEGIN
        AddField(Contact."No.");
        AddField(Contact."Company Name");
        AddField(Contact.Name);
        AddField(Contact."Name 2");
        AddField(Contact.Address);
        AddField(Contact."Address 2");
        AddField(Contact."Post Code");
        AddField(Contact.City);
        AddField(Contact.County);
        AddField(Country.Name);
        AddField(Contact."Job Title");
        AddField(Contact."Phone No.");
        AddField(Contact."Fax No.");
        AddField(Contact."E-Mail");
        AddField(Contact."Mobile Phone No.");
        AddField(Contact."VAT Registration No.");
        AddField(Contact."Home Page");
        AddField(Contact.GetSalutation(0,LanguageCode));
        AddField(Contact.GetSalutation(1,LanguageCode));
        AddField(Salesperson.Code);
        AddField(Salesperson.Name);
        AddField(Salesperson."Job Title");
        AddField(Salesperson."Phone No.");
        AddField(Salesperson."E-Mail");

        IF InteractLogEntry.ISEMPTY THEN BEGIN
          AddField(FORMAT(SegLine.Date));
          AddField(SegLine."Campaign No.");
          AddField(SegLine."Segment No.");
          AddField(SegLine.Description);
          AddField(SegLine.Subject);
        END ELSE BEGIN
          AddField(FORMAT(InteractLogEntry.Date));
          AddField(InteractLogEntry."Campaign No.");
          AddField(InteractLogEntry."Segment No.");
          AddField(InteractLogEntry.Description);
          AddField(InteractLogEntry.Subject);
        END;

        AddField(CompanyInfo.Name);
        AddField(CompanyInfo."Name 2");
        AddField(CompanyInfo.Address);
        AddField(CompanyInfo."Address 2");
        AddField(CompanyInfo."Post Code");
        AddField(CompanyInfo.City);
        AddField(CompanyInfo.County);
        AddField(Country2.Name);
        AddField(CompanyInfo."VAT Registration No.");
        AddField(CompanyInfo."Registration No.");
        AddField(CompanyInfo."Phone No.");
        AddField(CompanyInfo."Fax No.");
        AddField(CompanyInfo."Bank Branch No.");
        AddField(CompanyInfo."Bank Name");
        AddField(CompanyInfo."Bank Account No.");
        AddField(CompanyInfo."Giro No.");
        AddField(FaxMailToValue);
        OnAddFieldsToMergeSource(Salesperson,Country,Contact,CompanyInfo,SegLine,InteractLogEntry);
        WriteLine;
      END;
    END;

    LOCAL PROCEDURE ImportMergeSourceFile@10(AttachmentNo@1000 : Integer);
    VAR
      Attachment@1001 : Record 5062;
    BEGIN
      Attachment.GET(AttachmentNo);
      Attachment.CALCFIELDS("Merge Source","Attachment File");
      IF NOT Attachment."Merge Source".HASVALUE THEN BEGIN
        IF NOT DocumentContainMergefields(Attachment) THEN
          EXIT;
        MergeSourceBufferFile.WRITE('</table>');
        MergeSourceBufferFile.WRITE('</body>');
        MergeSourceBufferFile.WRITE('</html>');
        MergeSourceBufferFile.CLOSE;
        Attachment."Merge Source".IMPORT(MergeSourceBufferFileName);
        Attachment.MODIFY;
        DeleteFile(MergeSourceBufferFileName);
        MergeSourceBufferFileName := ''
      END
    END;

    LOCAL PROCEDURE AppendToMergeSource@41(MergeFileName@1000 : Text);
    VAR
      SourceFile@1003 : File;
      CurrentLine@1004 : Text[250];
      SkipHeader@1005 : Boolean;
      MergeFileNameServer@1006 : Text;
    BEGIN
      IF MergeSourceBufferFileName = '' THEN BEGIN
        MergeSourceBufferFileName := FileMgt.ServerTempFileName('HTM');
        MergeSourceBufferFile.WRITEMODE := TRUE;
        MergeSourceBufferFile.TEXTMODE := TRUE;
        MergeSourceBufferFile.CREATE(MergeSourceBufferFileName);
      END ELSE
        SkipHeader := TRUE;
      SourceFile.TEXTMODE := TRUE;

      MergeFileNameServer := FileMgt.ServerTempFileName('HTM');
      UPLOAD(Text021,'',Text032,MergeFileName,MergeFileNameServer);

      SourceFile.OPEN(MergeFileNameServer);
      IF SkipHeader THEN
        REPEAT
          SourceFile.READ(CurrentLine)
        UNTIL (STRPOS(CurrentLine,'</tr>') <> 0);
      WHILE (STRPOS(CurrentLine,'</table>') = 0) AND (SourceFile.POS <> SourceFile.LEN) DO BEGIN
        SourceFile.READ(CurrentLine);
        IF STRPOS(CurrentLine,'</table>') = 0 THEN
          MergeSourceBufferFile.WRITE(CurrentLine);
      END;
      SourceFile.CLOSE;

      ERASE(MergeFileNameServer);
    END;

    [External]
    PROCEDURE GetWordDocumentExtension@17(VersionTxt@1001 : Text[30]) : Code[4];
    VAR
      Version@1200 : Decimal;
      SeparatorPos@1201 : Integer;
      CommaStr@1202 : Code[1];
      DefaultStr@1203 : Code[10];
      EvalOK@1204 : Boolean;
    BEGIN
      DefaultStr := 'DOC';
      SeparatorPos := STRPOS(VersionTxt,'.');
      IF SeparatorPos = 0 THEN
        SeparatorPos := STRPOS(VersionTxt,',');
      IF SeparatorPos = 0 THEN
        EvalOK := EVALUATE(Version,VersionTxt)
      ELSE BEGIN
        CommaStr := COPYSTR(FORMAT(11 / 10),2,1);
        EvalOK := EVALUATE(Version,COPYSTR(VersionTxt,1,SeparatorPos - 1) + CommaStr + COPYSTR(VersionTxt,SeparatorPos + 1));
      END;
      IF EvalOK AND (Version >= 12.0) THEN
        EXIT('DOCX');
      EXIT(DefaultStr);
    END;

    LOCAL PROCEDURE HandleWordDocumentWithoutMerge@18(VAR WordDocument@1021 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.Document";VAR DeliverySorter@1022 : Record 5074;MainFileName@1023 : Text);
    VAR
      InteractLogEntry@1001 : Record 5065;
      Contact@1002 : Record 5050;
      Mail@1003 : Codeunit 397;
    BEGIN
      WITH InteractLogEntry DO
        REPEAT
          LOCKTABLE;
          GET(DeliverySorter."No.");
          IF DeliverySorter."Correspondence Type" = DeliverySorter."Correspondence Type"::Email THEN BEGIN
            Contact.GET("Contact No.");
            Mail.NewMessage(
              AttachmentManagement.InteractionEMail(InteractLogEntry),'','',
              DeliverySorter.Subject,'',MainFileName,FALSE);
          END ELSE
            WordHelper.CallPrintOut(WordDocument);
          "Delivery Status" := "Delivery Status"::" ";
          MODIFY;
          COMMIT;
        UNTIL DeliverySorter.NEXT = 0;
    END;

    LOCAL PROCEDURE SendAttachmentWithoutMergeFields@3(VAR WordApplication@1002 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.ApplicationClass";VAR TempDeliverySorter@1001 : TEMPORARY Record 5074;VAR Attachment@1003 : Record 5062);
    VAR
      WordDocument@1004 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.Document" RUNONCLIENT;
      FileName@1000 : Text;
    BEGIN
      FileName := FileMgt.ClientTempFileName('DOC');
      Attachment.ExportAttachmentToClientFile(FileName);
      CASE TempDeliverySorter."Correspondence Type" OF
        TempDeliverySorter."Correspondence Type"::"Hard Copy":
          BEGIN
            WordDocument := WordHelper.CallOpen(WordApplication,FileName,FALSE,FALSE);
            HandleWordDocumentWithoutMerge(WordDocument,TempDeliverySorter,FileName);
            WordHelper.CallClose(WordDocument,FALSE);
          END;
        TempDeliverySorter."Correspondence Type"::Email:
          BEGIN
            // Send attachment to all contacts in buffer
            Window.UPDATE(6,Text009);
            Attachment.TESTFIELD("File Extension");
            HandleWordDocumentWithoutMerge(WordDocument,TempDeliverySorter,FileName);
            DeleteFile(FileName);
          END;
      END;
    END;

    [External]
    PROCEDURE IsWordDocumentExtension@19(FileExtension@1000 : Text) : Boolean;
    BEGIN
      IF (UPPERCASE(FileExtension) <> 'DOC') AND
         (UPPERCASE(FileExtension) <> 'DOCX') AND
         (UPPERCASE(FileExtension) <> '.DOC') AND
         (UPPERCASE(FileExtension) <> '.DOCX')
      THEN
        EXIT(FALSE);

      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE RunMergedDocument@20(VAR SegLine@1000 : Record 5077;VAR Attachment@1001 : Record 5062;WordCaption@1002 : Text[260];IsTemporary@1016 : Boolean;IsVisible@1003 : Boolean;Handler@1005 : Boolean);
    VAR
      TempInteractLogEntry@1026 : TEMPORARY Record 5065;
      WordMergefile@1006 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Word.MergeHandler" RUNONCLIENT;
      WordApplication@1019 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.ApplicationClass" RUNONCLIENT;
      WordDocument@1018 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.Document" RUNONCLIENT;
      MergeFile@1004 : File;
      MergeClientFileName@1009 : Text;
      MainFileName@1010 : Text;
      ParamInt@1011 : Integer;
      IsInherited@1021 : Boolean;
      HeaderIsReady@1023 : Boolean;
    BEGIN
      IF NOT IsWordDocumentExtension(Attachment."File Extension") THEN
        ERROR(STRSUBSTNO(Text010,Attachment.TABLECAPTION,Attachment."No.",
            Attachment.FIELDCAPTION("File Extension")));

      IF SegLine.AttachmentInherited THEN
        IsInherited := TRUE;

      MainFileName := FileMgt.ClientTempFileName('DOC');

      // Handle Word documents without mergefields
      IF NOT DocumentContainMergefields(Attachment) THEN BEGIN
        Attachment.ExportAttachmentToClientFile(MainFileName);
        WordApplication := WordApplication.ApplicationClass;
        WordDocument := WordHelper.CallOpen(WordApplication,MainFileName,FALSE,Attachment."Read Only");
      END ELSE BEGIN
        // Merge possible
        IF NOT Attachment.ExportAttachmentToClientFile(MainFileName) THEN
          ERROR(Text011);

        Attachment.CALCFIELDS("Merge Source");
        IF Attachment."Merge Source".HASVALUE THEN BEGIN
          CreateMergeSource(MergeFile);
          PopulateInterLogEntryToMergeSource(MergeFile,Attachment,SegLine."Line No.",HeaderIsReady,0);
          MergeClientFileName := CloseAndDownloadMergeSource(MergeFile);
        END ELSE BEGIN
          MergeClientFileName := FileMgt.ClientTempFileName('HTM');
          WordMergefile := WordMergefile.MergeHandler;
          CreateHeader(WordMergefile,FALSE,MergeClientFileName,SegLine."Language Code");

          AddFieldsToMergeSource(WordMergefile,TempInteractLogEntry,SegLine,'');
          WordMergefile.CloseMergeFile;
        END;

        WordApplication := WordApplication.ApplicationClass;
        WordDocument := WordHelper.CallOpen(WordApplication,MainFileName,FALSE,FALSE);
        WordDocument.MailMerge.MainDocumentType := 0;
        ParamInt := 7; // 7 = HTML
        WordHelper.CallMailMergeOpenDataSource(WordDocument,MergeClientFileName,ParamInt);
        ParamInt := 9999998; // 9999998 = wdToggle
        WordDocument.MailMerge.ViewMailMergeFieldCodes(ParamInt);
      END;

      IF Handler THEN
        WordHandler(WordDocument,Attachment,WordCaption,IsTemporary,MainFileName,IsInherited)
      ELSE
        WordMerge(WordDocument,Attachment,WordCaption,IsTemporary,MainFileName,IsInherited,IsVisible);

      CLEAR(WordMergefile);
      CLEAR(WordDocument);
      WordHelper.CallQuit(WordApplication,FALSE);
      CLEAR(WordApplication);

      DeleteFile(MergeClientFileName);
    END;

    LOCAL PROCEDURE WordMerge@9(VAR WordDocument@1009 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.Document";VAR Attachment@1001 : Record 5062;Caption@1002 : Text[260];IsTemporary@1003 : Boolean;FileName@1004 : Text;IsInherited@1008 : Boolean;IsVisible@1012 : Boolean) DocImported@1000 : Boolean;
    VAR
      FileManagement@1007 : Codeunit 419;
      WordHandler@1011 : DotNet "'Microsoft.Dynamics.Nav.Integration.Office, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Integration.Office.Word.WordHandler" RUNONCLIENT;
      TempFileName@1010 : Text;
      NewFileName@1005 : Text;
    BEGIN
      WordHandler := WordHandler.WordHandler;

      IF IsVisible THEN BEGIN
        WordDocument.ActiveWindow.Caption := Caption;
        WordDocument.Application.Visible := TRUE; // Visible before WindowState KB176866 - http://support.microsoft.com/kb/176866
        WordDocument.ActiveWindow.WindowState := 1; // 1 = wdWindowStateMaximize
        WordDocument.Application.Activate;
        NewFileName := WordHandler.WaitForDocument(WordDocument);
      END ELSE BEGIN
        WordHelper.CallClose(WordDocument,TRUE);
        NewFileName := FileName;
      END;

      IF IsTemporary THEN BEGIN
        TempFileName := FileManagement.ClientTempFileName(FileManagement.GetExtension(NewFileName));
        FileManagement.CopyClientFile(NewFileName,TempFileName,TRUE);
        Attachment.ImportAttachmentFromClientFile(TempFileName,IsTemporary,IsInherited);
        FileManagement.DeleteClientFile(TempFileName);
        DeleteFile(NewFileName);
        DocImported := TRUE;
      END;

      CLEAR(WordHandler);
      DeleteFile(FileName);
    END;

    PROCEDURE CanRunWordApp@21() CanRunWord : Boolean;
    VAR
      WordApplication@1000 : DotNet "'Microsoft.Office.Interop.Word, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c'.Microsoft.Office.Interop.Word.ApplicationClass" RUNONCLIENT;
      ErrorMessage@1002 : Text;
      CanRunWordModified@1003 : Boolean;
    BEGIN
      OnBeforeCheckCanRunWord(CanRunWord,CanRunWordModified);
      IF CanRunWordModified THEN
        EXIT(CanRunWord);

      WordApplication := WordHelper.GetApplication(ErrorMessage);
      EXIT(NOT ISNULL(WordApplication));
    END;

    [Integration]
    LOCAL PROCEDURE OnAddFieldsToMergeSource@25(Salesperson@1004 : Record 13;Country@1003 : Record 9;Contact@1001 : Record 5050;CompanyInfo@1000 : Record 79;SegmentLine@1002 : Record 5077;InteractionLogEntry@1005 : Record 5065);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnCreateHeaderAddFields@23(Salesperson@1007 : Record 13;Country@1006 : Record 9;Contact@1005 : Record 5050;CompanyInfo@1003 : Record 79;SegmentLine@1000 : Record 5077;InteractionLogEntry@1001 : Record 5065);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCheckCanRunWord@22(VAR CanRunWord@1000 : Boolean;VAR CanRunWordModified@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

