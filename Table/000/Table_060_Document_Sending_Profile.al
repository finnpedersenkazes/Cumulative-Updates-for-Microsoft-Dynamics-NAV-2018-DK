OBJECT Table 60 Document Sending Profile
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=VAR
               DocumentSendingProfile@1000 : Record 60;
             BEGIN
               DocumentSendingProfile.SETRANGE(Default,TRUE);
               IF NOT DocumentSendingProfile.FINDFIRST THEN
                 Default := TRUE;
             END;

    OnDelete=VAR
               Customer@1000 : Record 18;
             BEGIN
               IF Default THEN
                 ERROR(CannotDeleteDefaultRuleErr);

               Customer.SETRANGE("Document Sending Profile",Code);
               IF Customer.FINDFIRST THEN BEGIN
                 IF CONFIRM(UpdateAssCustomerQst,FALSE,Code) THEN
                   Customer.MODIFYALL("Document Sending Profile",'')
                 ELSE
                   ERROR(CannotDeleteErr);
               END;
             END;

    CaptionML=[DAN=Dokumentafsendelsesprofil;
               ENU=Document Sending Profile];
    LookupPageID=Page359;
  }
  FIELDS
  {
    { 1   ;   ;Code                ;Code20        ;CaptionML=[DAN=Kode;
                                                              ENU=Code];
                                                   NotBlank=Yes }
    { 2   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 10  ;   ;Printer             ;Option        ;CaptionML=[DAN=Printer;
                                                              ENU=Printer];
                                                   OptionCaptionML=[DAN=Nej,Ja (Bed om indstillinger),Ja (Brug standardindstillinger);
                                                                    ENU=No,Yes (Prompt for Settings),Yes (Use Default Settings)];
                                                   OptionString=No,Yes (Prompt for Settings),Yes (Use Default Settings) }
    { 11  ;   ;E-Mail              ;Option        ;CaptionML=[DAN=Mail;
                                                              ENU=Email];
                                                   OptionCaptionML=[DAN=Nej,Ja (Bed om indstillinger),Ja (Brug standardindstillinger);
                                                                    ENU=No,Yes (Prompt for Settings),Yes (Use Default Settings)];
                                                   OptionString=No,Yes (Prompt for Settings),Yes (Use Default Settings) }
    { 12  ;   ;E-Mail Attachment   ;Option        ;CaptionML=[DAN=Mail som vedh�ftet fil;
                                                              ENU=Email Attachment];
                                                   OptionCaptionML=[DAN=PDF,Elektronisk dokument,PDF og elektronisk dokument;
                                                                    ENU=PDF,Electronic Document,PDF & Electronic Document];
                                                   OptionString=PDF,Electronic Document,PDF & Electronic Document }
    { 13  ;   ;E-Mail Format       ;Code20        ;TableRelation="Electronic Document Format".Code;
                                                   CaptionML=[DAN=Mailformat;
                                                              ENU=Email Format] }
    { 15  ;   ;Disk                ;Option        ;CaptionML=[DAN=Disk;
                                                              ENU=Disk];
                                                   OptionCaptionML=[DAN=Nej,PDF,Elektronisk dokument,PDF og elektronisk dokument;
                                                                    ENU=No,PDF,Electronic Document,PDF & Electronic Document];
                                                   OptionString=No,PDF,Electronic Document,PDF & Electronic Document }
    { 16  ;   ;Disk Format         ;Code20        ;TableRelation="Electronic Document Format".Code;
                                                   CaptionML=[DAN=Diskformat;
                                                              ENU=Disk Format] }
    { 20  ;   ;Electronic Document ;Option        ;CaptionML=[DAN=Elektronisk dokument;
                                                              ENU=Electronic Document];
                                                   OptionCaptionML=[DAN=Nej,Via dokumentudvekslingstjeneste;
                                                                    ENU=No,Through Document Exchange Service];
                                                   OptionString=No,Through Document Exchange Service }
    { 21  ;   ;Electronic Format   ;Code20        ;TableRelation="Electronic Document Format".Code;
                                                   CaptionML=[DAN=Elektronisk format;
                                                              ENU=Electronic Format] }
    { 30  ;   ;Default             ;Boolean       ;OnValidate=VAR
                                                                DocumentSendingProfile@1001 : Record 60;
                                                              BEGIN
                                                                IF (xRec.Default = TRUE) AND (Default = FALSE) THEN
                                                                  ERROR(CannotRemoveDefaultRuleErr);

                                                                DocumentSendingProfile.SETRANGE(Default,TRUE);
                                                                DocumentSendingProfile.MODIFYALL(Default,FALSE,FALSE);
                                                              END;

                                                   CaptionML=[DAN=Standard;
                                                              ENU=Default] }
    { 50  ;   ;Send To             ;Option        ;CaptionML=[DAN=Send til;
                                                              ENU=Send To];
                                                   OptionCaptionML=[DAN=Disk,Mail,Udskrift,Elektronisk dokument;
                                                                    ENU=Disk,Email,Print,Electronic Document];
                                                   OptionString=Disk,Email,Print,Electronic Document }
    { 51  ;   ;Usage               ;Option        ;CaptionML=[DAN=Forbrug;
                                                              ENU=Usage];
                                                   OptionCaptionML=[DAN=Salgsfaktura,Salgskreditnota,,Servicefaktura,Servicekreditnota,Antal i tilbud;
                                                                    ENU=Sales Invoice,Sales Credit Memo,,Service Invoice,Service Credit Memo,Job Quote];
                                                   OptionString=Sales Invoice,Sales Credit Memo,,Service Invoice,Service Credit Memo,Job Quote }
    { 52  ;   ;One Related Party Selected;Boolean ;InitValue=Yes;
                                                   OnValidate=BEGIN
                                                                IF NOT "One Related Party Selected" THEN BEGIN
                                                                  "Electronic Document" := "Electronic Document"::No;
                                                                  "Electronic Format" := '';
                                                                END;
                                                              END;

                                                   CaptionML=[DAN=En relateret part er valgt;
                                                              ENU=One Related Party Selected] }
  }
  KEYS
  {
    {    ;Code                                    ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      DefaultCodeTxt@1000 : TextConst '@@@=Translate as we translate default term in local languages;DAN=STANDARD;ENU=DEFAULT';
      DefaultDescriptionTxt@1001 : TextConst 'DAN=Standardreglen bruges i mangel af anden regel;ENU=Default rule used if no other provided';
      RecordAsTextFormatterTxt@1002 : TextConst 'DAN="%1 ; %2";ENU="%1 ; %2"';
      FieldCaptionContentFormatterTxt@1007 : TextConst '@@@="%1=Field Caption (e.g. Email), %2=Field Content (e.g. PDF) so for example ''Email (PDF)''";DAN=%1 (%2);ENU=%1 (%2)';
      CannotDeleteDefaultRuleErr@1003 : TextConst 'DAN=Du kan ikke slette standardreglen. Tildel f�rst en anden regel, der skal v�re standardreglen.;ENU=You cannot delete the default rule. Assign other rule to be default first.';
      CannotRemoveDefaultRuleErr@1004 : TextConst 'DAN=Der skal v�re en standardregel i systemet. Du kan fjerne standardegenskaben fra denne regel ved at tildele standarden til en anden regel.;ENU=There must be one default rule in the system. To remove the default property from this rule, assign default to another rule.';
      UpdateAssCustomerQst@1005 : TextConst 'DAN=Hvis du sletter dokumentafsendelsesprofilen %1, slettes den ogs� p� de debitorkort, der bruger profilen.\\Vil du forts�tte?;ENU=If you delete document sending profile %1, it will also be deleted on customer cards that use the profile.\\Do you want to continue?';
      CannotDeleteErr@1006 : TextConst 'DAN=Dokumentafsendelsesprofilen kan ikke slettes.;ENU=Cannot delete the document sending profile.';
      CannotSendMultipleSalesDocsErr@1008 : TextConst 'DAN=Du kan kun send �t elektronisk salgsdokument ad gangen.;ENU=You can only send one electronic sales document at a time.';
      InvoicesTxt@1009 : TextConst 'DAN=Fakturaer;ENU=Invoices';
      ShipmentsTxt@1010 : TextConst 'DAN=Leverancer;ENU=Shipments';
      CreditMemosTxt@1011 : TextConst 'DAN=Kreditnotaer;ENU=Credit Memos';
      ReceiptsTxt@1012 : TextConst 'DAN=Modtagelser;ENU=Receipts';
      JobQuotesTxt@1013 : TextConst 'DAN=Antal i tilbud;ENU=Job Quotes';
      PurchaseOrdersTxt@1014 : TextConst 'DAN=K�bsordrer;ENU=Purchase Orders';
      ProfileSelectionQst@1018 : TextConst '@@@=Translation should contain comma separators between variants as ENU value does. No other commas should be there.;DAN=Bekr�ft den f�rste profil - og brug den til alle valgte bilag.,Bekr�ft profilen for hvert enkelt bilag.,Brug standardprofilen til alle valgte bilag uden bekr�ftelse.;ENU=Confirm the first profile and use it for all selected documents.,Confirm the profile for each document.,Use the default profile for all selected documents without confimation.';
      CustomerProfileSelectionInstrTxt@1016 : TextConst 'DAN="Debitorerne p� de valgte dokumenter anvender forskellige dokumentafsendelsesprofiler. V�lg �n af f�lgende indstillinger: ";ENU="Customers on the selected documents use different document sending profiles. Choose one of the following options: "';
      VendorProfileSelectionInstrTxt@1017 : TextConst 'DAN="Kreditorerne p� de valgte dokumenter anvender forskellige dokumentafsendelsesprofiler. V�lg �n af f�lgende indstillinger: ";ENU="Vendors on the selected documents use different document sending profiles. Choose one of the following options: "';

    [External]
    PROCEDURE GetDefaultForCustomer@4(CustomerNo@1000 : Code[20];VAR DocumentSendingProfile@1002 : Record 60);
    VAR
      Customer@1001 : Record 18;
    BEGIN
      IF Customer.GET(CustomerNo) THEN
        IF DocumentSendingProfile.GET(Customer."Document Sending Profile") THEN
          EXIT;

      GetDefault(DocumentSendingProfile);
    END;

    [External]
    PROCEDURE GetDefaultForVendor@27(VendorNo@1001 : Code[20];VAR DocumentSendingProfile@1000 : Record 60);
    VAR
      Vendor@1002 : Record 23;
    BEGIN
      IF Vendor.GET(VendorNo) THEN
        IF DocumentSendingProfile.GET(Vendor."Document Sending Profile") THEN
          EXIT;

      GetDefault(DocumentSendingProfile);
    END;

    [External]
    PROCEDURE GetDefault@1(VAR DefaultDocumentSendingProfile@1000 : Record 60);
    VAR
      DocumentSendingProfile@1001 : Record 60;
    BEGIN
      DocumentSendingProfile.SETRANGE(Default,TRUE);
      IF NOT DocumentSendingProfile.FINDFIRST THEN BEGIN
        DocumentSendingProfile.INIT;
        DocumentSendingProfile.VALIDATE(Code,DefaultCodeTxt);
        DocumentSendingProfile.VALIDATE(Description,DefaultDescriptionTxt);
        DocumentSendingProfile.VALIDATE("E-Mail","E-Mail"::"Yes (Prompt for Settings)");
        DocumentSendingProfile.VALIDATE("E-Mail Attachment","E-Mail Attachment"::PDF);
        DocumentSendingProfile.VALIDATE(Default,TRUE);
        DocumentSendingProfile.INSERT(TRUE);
      END;

      DefaultDocumentSendingProfile := DocumentSendingProfile;
    END;

    [External]
    PROCEDURE GetRecordAsText@2() : Text;
    VAR
      RecordAsText@1000 : Text;
    BEGIN
      RecordAsText := '';

      IF ("Electronic Document" <> "Electronic Document"::No) AND ("Electronic Format" <> '') THEN
        RecordAsText := STRSUBSTNO(
            RecordAsTextFormatterTxt,
            STRSUBSTNO(FieldCaptionContentFormatterTxt,FIELDCAPTION("Electronic Document"),"Electronic Document"),RecordAsText);

      IF "E-Mail" <> "E-Mail"::No THEN
        RecordAsText := STRSUBSTNO(
            RecordAsTextFormatterTxt,
            STRSUBSTNO(FieldCaptionContentFormatterTxt,FIELDCAPTION("E-Mail"),"E-Mail Attachment"),RecordAsText);
      IF Printer <> Printer::No THEN
        RecordAsText := STRSUBSTNO(RecordAsTextFormatterTxt,FIELDCAPTION(Printer),RecordAsText);

      IF Disk <> Disk::No THEN
        RecordAsText := STRSUBSTNO(
            RecordAsTextFormatterTxt,STRSUBSTNO(FieldCaptionContentFormatterTxt,FIELDCAPTION(Disk),Disk),RecordAsText);

      EXIT(RecordAsText);
    END;

    [External]
    PROCEDURE WillUserBePrompted@5() : Boolean;
    BEGIN
      EXIT(
        (Printer = Printer::"Yes (Prompt for Settings)") OR
        ("E-Mail" = "E-Mail"::"Yes (Prompt for Settings)"));
    END;

    [External]
    PROCEDURE SetDocumentUsage@3(DocumentVariant@1000 : Variant);
    VAR
      ElectronicDocumentFormat@1001 : Record 61;
      DocumentUsage@1002 : Option;
    BEGIN
      ElectronicDocumentFormat.GetDocumentUsage(DocumentUsage,DocumentVariant);
      VALIDATE(Usage,DocumentUsage);
    END;

    [External]
    PROCEDURE VerifySelectedOptionsValid@6();
    BEGIN
      IF "One Related Party Selected" THEN
        EXIT;

      IF "E-Mail Attachment" > "E-Mail Attachment"::PDF THEN
        ERROR(CannotSendMultipleSalesDocsErr);

      IF "Electronic Document" > "Electronic Document"::No THEN
        ERROR(CannotSendMultipleSalesDocsErr);
    END;

    [External]
    PROCEDURE LookupProfile@7(CustNo@1000 : Code[20];Multiselection@1002 : Boolean;ShowDialog@1005 : Boolean) : Boolean;
    VAR
      DocumentSendingProfile@1001 : Record 60;
      OfficeMgt@1004 : Codeunit 1630;
    BEGIN
      IF OfficeMgt.IsAvailable THEN BEGIN
        GetOfficeAddinDefault(Rec,OfficeMgt.AttachAvailable);
        EXIT(TRUE);
      END;

      GetDefaultForCustomer(CustNo,DocumentSendingProfile);
      IF ShowDialog THEN
        EXIT(RunSelectSendingOptionsPage(DocumentSendingProfile.Code,Multiselection));

      Rec := DocumentSendingProfile;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE LookUpProfileVendor@18(VendorNo@1001 : Code[20];Multiselection@1000 : Boolean;ShowDialog@1005 : Boolean) : Boolean;
    VAR
      DocumentSendingProfile@1004 : Record 60;
      OfficeMgt@1002 : Codeunit 1630;
    BEGIN
      IF OfficeMgt.IsAvailable THEN BEGIN
        GetOfficeAddinDefault(Rec,OfficeMgt.AttachAvailable);
        EXIT(TRUE);
      END;

      DocumentSendingProfile.GetDefaultForVendor(VendorNo,DocumentSendingProfile);
      IF ShowDialog THEN
        EXIT(RunSelectSendingOptionsPage(DocumentSendingProfile.Code,Multiselection));

      Rec := DocumentSendingProfile;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE RunSelectSendingOptionsPage@32(DocumentSendingProfileCode@1002 : Code[20];OneRelatedPartySelected@1001 : Boolean) : Boolean;
    VAR
      TempDocumentSendingProfile@1000 : TEMPORARY Record 60;
    BEGIN
      TempDocumentSendingProfile.INIT;
      TempDocumentSendingProfile.Code := DocumentSendingProfileCode;
      TempDocumentSendingProfile.VALIDATE("One Related Party Selected",OneRelatedPartySelected);
      TempDocumentSendingProfile.INSERT;

      COMMIT;
      IF PAGE.RUNMODAL(PAGE::"Select Sending Options",TempDocumentSendingProfile) = ACTION::LookupOK THEN BEGIN
        Rec := TempDocumentSendingProfile;
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE SendCustomerRecords@33(ReportUsage@1012 : Integer;RecordVariant@1011 : Variant;DocName@1008 : Text[150];CustomerNo@1013 : Code[20];DocumentNo@1014 : Code[20];CustomerFieldNo@1007 : Integer;DocumentFieldNo@1006 : Integer);
    VAR
      DocumentSendingProfile@1001 : Record 60;
      RecRefSource@1000 : RecordRef;
      RecRefToSend@1009 : RecordRef;
      ProfileSelectionMethod@1002 : 'ConfirmDefault,ConfirmPerEach,UseDefault';
      SingleCustomerSelected@1005 : Boolean;
      ShowDialog@1010 : Boolean;
    BEGIN
      SingleCustomerSelected := IsSingleRecordSelected(RecordVariant,CustomerNo,CustomerFieldNo);

      IF NOT SingleCustomerSelected THEN
        IF NOT DocumentSendingProfile.ProfileSelectionMethodDialog(ProfileSelectionMethod,TRUE) THEN
          EXIT;

      IF SingleCustomerSelected OR (ProfileSelectionMethod = ProfileSelectionMethod::ConfirmDefault) THEN BEGIN
        IF DocumentSendingProfile.LookupProfile(CustomerNo,TRUE,TRUE) THEN
          DocumentSendingProfile.Send(ReportUsage,RecordVariant,DocumentNo,CustomerNo,DocName,CustomerFieldNo,DocumentFieldNo);
      END ELSE BEGIN
        ShowDialog := ProfileSelectionMethod = ProfileSelectionMethod::ConfirmPerEach;
        RecRefSource.GETTABLE(RecordVariant);
        IF RecRefSource.FINDSET THEN
          REPEAT
            RecRefToSend := RecRefSource.DUPLICATE;
            RecRefToSend.SETRECFILTER;
            CustomerNo := RecRefToSend.FIELD(CustomerFieldNo).VALUE;
            DocumentNo := RecRefToSend.FIELD(DocumentFieldNo).VALUE;
            IF DocumentSendingProfile.LookupProfile(CustomerNo,TRUE,ShowDialog) THEN
              DocumentSendingProfile.Send(ReportUsage,RecRefToSend,DocumentNo,CustomerNo,DocName,CustomerFieldNo,DocumentFieldNo);
          UNTIL RecRefSource.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE SendVendorRecords@35(ReportUsage@1012 : Integer;RecordVariant@1011 : Variant;DocName@1008 : Text[150];VendorNo@1013 : Code[20];DocumentNo@1014 : Code[20];VendorFieldNo@1007 : Integer;DocumentFieldNo@1006 : Integer);
    VAR
      DocumentSendingProfile@1001 : Record 60;
      RecRef@1000 : RecordRef;
      RecRef2@1009 : RecordRef;
      ProfileSelectionMethod@1002 : 'ConfirmDefault,ConfirmPerEach,UseDefault';
      SingleVendorSelected@1005 : Boolean;
      ShowDialog@1010 : Boolean;
    BEGIN
      SingleVendorSelected := IsSingleRecordSelected(RecordVariant,VendorNo,VendorFieldNo);

      IF NOT SingleVendorSelected THEN
        IF NOT DocumentSendingProfile.ProfileSelectionMethodDialog(ProfileSelectionMethod,FALSE) THEN
          EXIT;

      IF SingleVendorSelected OR (ProfileSelectionMethod = ProfileSelectionMethod::ConfirmDefault) THEN BEGIN
        IF DocumentSendingProfile.LookUpProfileVendor(VendorNo,TRUE,TRUE) THEN
          DocumentSendingProfile.SendVendor(ReportUsage,RecordVariant,DocumentNo,VendorNo,DocName,VendorFieldNo,DocumentFieldNo);
      END ELSE BEGIN
        ShowDialog := ProfileSelectionMethod = ProfileSelectionMethod::ConfirmPerEach;
        RecRef.GETTABLE(RecordVariant);
        IF RecRef.FINDSET THEN
          REPEAT
            RecRef2 := RecRef.DUPLICATE;
            RecRef2.SETRECFILTER;
            VendorNo := RecRef2.FIELD(VendorFieldNo).VALUE;
            DocumentNo := RecRef2.FIELD(DocumentFieldNo).VALUE;
            IF DocumentSendingProfile.LookUpProfileVendor(VendorNo,TRUE,ShowDialog) THEN
              DocumentSendingProfile.SendVendor(ReportUsage,RecRef2,DocumentNo,VendorNo,DocName,VendorFieldNo,DocumentFieldNo);
          UNTIL RecRef.NEXT = 0;
      END;
    END;

    [Internal]
    PROCEDURE Send@11(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;DocNo@1003 : Code[20];ToCust@1002 : Code[20];DocName@1001 : Text[150];CustomerFieldNo@1000 : Integer;DocumentNoFieldNo@1006 : Integer);
    BEGIN
      SendToVAN(RecordVariant);
      SendToPrinter(ReportUsage,RecordVariant,CustomerFieldNo);
      TrySendToEMailGroupedMultipleSelection(ReportUsage,RecordVariant,DocumentNoFieldNo,DocName,CustomerFieldNo);
      SendToDisk(ReportUsage,RecordVariant,DocNo,DocName,ToCust);
    END;

    [Internal]
    PROCEDURE SendVendor@20(ReportUsage@1006 : Integer;RecordVariant@1005 : Variant;DocNo@1004 : Code[20];ToVendor@1003 : Code[20];DocName@1002 : Text[150];VendorNoFieldNo@1001 : Integer;DocumentNoFieldNo@1000 : Integer);
    BEGIN
      SendToVAN(RecordVariant);
      SendToPrinterVendor(ReportUsage,RecordVariant,VendorNoFieldNo);
      TrySendToEMailGroupedMultipleSelectionVendor(ReportUsage,RecordVariant,DocumentNoFieldNo,DocName,VendorNoFieldNo);
      SendToDiskVendor(ReportUsage,RecordVariant,DocNo,DocName,ToVendor);
    END;

    [Internal]
    PROCEDURE TrySendToVAN@13(RecordVariant@1004 : Variant);
    BEGIN
      "Electronic Document" := "Electronic Document"::"Through Document Exchange Service";
      SendToVAN(RecordVariant);
    END;

    [External]
    PROCEDURE TrySendToPrinter@14(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;CustomerFieldNo@1001 : Integer;ShowDialog@1000 : Boolean);
    BEGIN
      IF ShowDialog THEN
        Printer := Printer::"Yes (Prompt for Settings)"
      ELSE
        Printer := Printer::"Yes (Use Default Settings)";

      SendToPrinter(ReportUsage,RecordVariant,CustomerFieldNo);
    END;

    [External]
    PROCEDURE TrySendToPrinterVendor@28(ReportUsage@1003 : Integer;RecordVariant@1002 : Variant;VendorNoFieldNo@1004 : Integer;ShowDialog@1000 : Boolean);
    BEGIN
      IF ShowDialog THEN
        Printer := Printer::"Yes (Prompt for Settings)"
      ELSE
        Printer := Printer::"Yes (Use Default Settings)";

      SendToPrinterVendor(ReportUsage,RecordVariant,VendorNoFieldNo);
    END;

    [Internal]
    PROCEDURE TrySendToEMail@15(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;DocumentNoFieldNo@1003 : Integer;DocName@1001 : Text[150];CustomerFieldNo@1002 : Integer;ShowDialog@1000 : Boolean);
    BEGIN
      IF ShowDialog THEN
        "E-Mail" := "E-Mail"::"Yes (Prompt for Settings)"
      ELSE
        "E-Mail" := "E-Mail"::"Yes (Use Default Settings)";

      "E-Mail Attachment" := "E-Mail Attachment"::PDF;

      TrySendToEMailGroupedMultipleSelection(ReportUsage,RecordVariant,DocumentNoFieldNo,DocName,CustomerFieldNo);
    END;

    LOCAL PROCEDURE TrySendToEMailGroupedMultipleSelection@19(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;DocumentNoFieldNo@1003 : Integer;DocName@1001 : Text[150];CustomerFieldNo@1006 : Integer);
    VAR
      TempCustomer@1009 : TEMPORARY Record 18;
      RecRef@1007 : RecordRef;
      CustomerNoFieldRef@1000 : FieldRef;
      RecToSend@1011 : Variant;
    BEGIN
      RecToSend := RecordVariant;
      RecRef.GETTABLE(RecordVariant);
      CustomerNoFieldRef := RecRef.FIELD(CustomerFieldNo);
      GetDisctinctCustomers(RecRef,CustomerFieldNo,TempCustomer);

      IF TempCustomer.FINDSET THEN
        REPEAT
          CustomerNoFieldRef.SETFILTER(TempCustomer."No.");
          RecRef.FINDFIRST;
          RecRef.SETTABLE(RecToSend);
          SendToEMail(
            ReportUsage,RecToSend,GetMultipleDocumentsTo(RecRef,DocumentNoFieldNo),
            GetMultipleDocumentsName(DocName,ReportUsage,RecRef),TempCustomer."No.");
        UNTIL TempCustomer.NEXT = 0;
    END;

    LOCAL PROCEDURE TrySendToEMailGroupedMultipleSelectionVendor@23(ReportUsage@1004 : Integer;RecordVariant@1003 : Variant;DocumentNoFieldNo@1002 : Integer;DocName@1001 : Text[150];VendorFieldNo@1000 : Integer);
    VAR
      TempVendor@1008 : TEMPORARY Record 23;
      RecRef@1007 : RecordRef;
      VendorNoFieldRef@1006 : FieldRef;
      RecToSend@1005 : Variant;
    BEGIN
      RecToSend := RecordVariant;
      RecRef.GETTABLE(RecordVariant);
      VendorNoFieldRef := RecRef.FIELD(VendorFieldNo);
      GetDistinctVendors(RecRef,VendorFieldNo,TempVendor);

      IF TempVendor.FINDSET THEN
        REPEAT
          VendorNoFieldRef.SETFILTER(TempVendor."No.");
          RecRef.FINDFIRST;
          RecRef.SETTABLE(RecToSend);
          SendToEmailVendor(
            ReportUsage,RecToSend,GetMultipleDocumentsTo(RecRef,DocumentNoFieldNo),
            GetMultipleDocumentsName(DocName,ReportUsage,RecRef),TempVendor."No.");
        UNTIL TempVendor.NEXT = 0;
    END;

    [Internal]
    PROCEDURE TrySendToDisk@16(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;DocNo@1003 : Code[20];DocName@1001 : Text[150];ToCust@1000 : Code[20]);
    BEGIN
      Disk := Disk::PDF;
      SendToDisk(ReportUsage,RecordVariant,DocNo,DocName,ToCust);
    END;

    LOCAL PROCEDURE SendToVAN@8(RecordVariant@1004 : Variant);
    VAR
      ReportDistributionManagement@1006 : Codeunit 452;
    BEGIN
      IF "Electronic Document" = "Electronic Document"::No THEN
        EXIT;

      ReportDistributionManagement.VANDocumentReport(RecordVariant,Rec);
    END;

    LOCAL PROCEDURE SendToPrinter@9(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;CustomerNoFieldNo@1002 : Integer);
    VAR
      ReportSelections@1006 : Record 77;
      ShowRequestForm@1000 : Boolean;
    BEGIN
      IF Printer = Printer::No THEN
        EXIT;

      ShowRequestForm := Printer = Printer::"Yes (Prompt for Settings)";
      ReportSelections.PrintWithGUIYesNo(ReportUsage,RecordVariant,ShowRequestForm,CustomerNoFieldNo);
    END;

    LOCAL PROCEDURE SendToPrinterVendor@22(ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;VendorNoFieldNo@1005 : Integer);
    VAR
      ReportSelections@1004 : Record 77;
      ShowRequestForm@1003 : Boolean;
    BEGIN
      IF Printer = Printer::No THEN
        EXIT;

      ShowRequestForm := Printer = Printer::"Yes (Prompt for Settings)";
      ReportSelections.PrintWithGUIYesNoVendor(ReportUsage,RecordVariant,ShowRequestForm,VendorNoFieldNo);
    END;

    LOCAL PROCEDURE SendToEMail@10(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;DocNo@1003 : Code[20];DocName@1016 : Text[150];ToCust@1002 : Code[20]);
    VAR
      ReportSelections@1000 : Record 77;
      ElectronicDocumentFormat@1006 : Record 61;
      ReportDistributionManagement@1012 : Codeunit 452;
      DocumentMailing@1007 : Codeunit 260;
      FileManagement@1011 : Codeunit 419;
      ShowDialog@1001 : Boolean;
      ClientFilePath@1013 : Text[250];
      ServerFilePath@1009 : Text[250];
      ZipPath@1015 : Text[250];
      ClientZipFileName@1014 : Text[250];
      ServerEmailBodyFilePath@1008 : Text[250];
      SendToEmailAddress@1010 : Text[250];
    BEGIN
      IF "E-Mail" = "E-Mail"::No THEN
        EXIT;

      ShowDialog := "E-Mail" = "E-Mail"::"Yes (Prompt for Settings)";

      CASE "E-Mail Attachment" OF
        "E-Mail Attachment"::PDF:
          ReportSelections.SendEmailToCust(ReportUsage,RecordVariant,DocNo,DocName,ShowDialog,ToCust);
        "E-Mail Attachment"::"Electronic Document":
          BEGIN
            ReportSelections.GetEmailBody(ServerEmailBodyFilePath,ReportUsage,RecordVariant,ToCust,SendToEmailAddress);
            ReportDistributionManagement.SendXmlEmailAttachment(
              RecordVariant,"E-Mail Format",ServerEmailBodyFilePath,SendToEmailAddress);
          END;
        "E-Mail Attachment"::"PDF & Electronic Document":
          BEGIN
            ElectronicDocumentFormat.SendElectronically(ServerFilePath,ClientFilePath,RecordVariant,"E-Mail Format");
            ReportDistributionManagement.CreateOrAppendZipFile(FileManagement,ServerFilePath,ClientFilePath,ZipPath,ClientZipFileName);
            ReportSelections.SendToZip(ReportUsage,RecordVariant,DocNo,ToCust,FileManagement);
            FileManagement.CloseZipArchive;

            ReportSelections.GetEmailBody(ServerEmailBodyFilePath,ReportUsage,RecordVariant,ToCust,SendToEmailAddress);
            DocumentMailing.EmailFile(
              ZipPath,ClientZipFileName,ServerEmailBodyFilePath,DocNo,SendToEmailAddress,DocName,
              NOT ShowDialog,ReportUsage);
          END;
      END;
    END;

    LOCAL PROCEDURE SendToEmailVendor@30(ReportUsage@1004 : Integer;RecordVariant@1003 : Variant;DocNo@1002 : Code[20];DocName@1001 : Text[150];ToVendor@1000 : Code[20]);
    VAR
      ReportSelections@1016 : Record 77;
      ElectronicDocumentFormat@1015 : Record 61;
      ReportDistributionManagement@1014 : Codeunit 452;
      DocumentMailing@1013 : Codeunit 260;
      FileManagement@1012 : Codeunit 419;
      ShowDialog@1011 : Boolean;
      ClientFilePath@1010 : Text[250];
      ServerFilePath@1009 : Text[250];
      ZipPath@1008 : Text[250];
      ClientZipFileName@1007 : Text[250];
      ServerEmailBodyFilePath@1006 : Text[250];
      SendToEmailAddress@1005 : Text[250];
    BEGIN
      IF "E-Mail" = "E-Mail"::No THEN
        EXIT;

      ShowDialog := "E-Mail" = "E-Mail"::"Yes (Prompt for Settings)";

      CASE "E-Mail Attachment" OF
        "E-Mail Attachment"::PDF:
          ReportSelections.SendEmailToVendor(ReportUsage,RecordVariant,DocNo,DocName,ShowDialog,ToVendor);
        "E-Mail Attachment"::"Electronic Document":
          BEGIN
            ReportSelections.GetEmailBodyVendor(ServerEmailBodyFilePath,ReportUsage,RecordVariant,ToVendor,SendToEmailAddress);
            ReportDistributionManagement.SendXmlEmailAttachmentVendor(
              RecordVariant,"E-Mail Format",ServerEmailBodyFilePath,SendToEmailAddress);
          END;
        "E-Mail Attachment"::"PDF & Electronic Document":
          BEGIN
            ElectronicDocumentFormat.SendElectronically(ServerFilePath,ClientFilePath,RecordVariant,"E-Mail Format");
            ReportDistributionManagement.CreateOrAppendZipFile(FileManagement,ServerFilePath,ClientFilePath,ZipPath,ClientZipFileName);
            ReportSelections.SendToZipVendor(ReportUsage,RecordVariant,DocNo,ToVendor,FileManagement);
            FileManagement.CloseZipArchive;

            ReportSelections.GetEmailBodyVendor(ServerEmailBodyFilePath,ReportUsage,RecordVariant,ToVendor,SendToEmailAddress);
            DocumentMailing.EmailFile(
              ZipPath,ClientZipFileName,ServerEmailBodyFilePath,DocNo,SendToEmailAddress,DocName,
              NOT ShowDialog,ReportUsage);
          END;
      END;
    END;

    LOCAL PROCEDURE SendToDisk@12(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;DocNo@1002 : Code[20];DocName@1013 : Text;ToCust@1009 : Code[20]);
    VAR
      ReportSelections@1001 : Record 77;
      ElectronicDocumentFormat@1003 : Record 61;
      ReportDistributionManagement@1000 : Codeunit 452;
      FileManagement@1010 : Codeunit 419;
      ServerFilePath@1006 : Text[250];
      ClientFilePath@1007 : Text[250];
      ZipPath@1011 : Text[250];
      ClientZipFileName@1012 : Text[250];
    BEGIN
      IF Disk = Disk::No THEN
        EXIT;

      CASE Disk OF
        Disk::PDF:
          ReportSelections.SendToDisk(ReportUsage,RecordVariant,DocNo,DocName,ToCust);
        Disk::"Electronic Document":
          BEGIN
            ElectronicDocumentFormat.SendElectronically(ServerFilePath,ClientFilePath,RecordVariant,"Disk Format");
            ReportDistributionManagement.SaveFileOnClient(ServerFilePath,ClientFilePath);
          END;
        Disk::"PDF & Electronic Document":
          BEGIN
            ElectronicDocumentFormat.SendElectronically(ServerFilePath,ClientFilePath,RecordVariant,"Disk Format");
            ReportDistributionManagement.CreateOrAppendZipFile(FileManagement,ServerFilePath,ClientFilePath,ZipPath,ClientZipFileName);
            ReportSelections.SendToZip(ReportUsage,RecordVariant,DocNo,ToCust,FileManagement);
            FileManagement.CloseZipArchive;

            ReportDistributionManagement.SaveFileOnClient(ZipPath,ClientZipFileName);
          END;
      END;
    END;

    LOCAL PROCEDURE SendToDiskVendor@29(ReportUsage@1004 : Integer;RecordVariant@1003 : Variant;DocNo@1002 : Code[20];DocName@1001 : Text;ToVendor@1000 : Code[20]);
    VAR
      ReportSelections@1012 : Record 77;
      ElectronicDocumentFormat@1011 : Record 61;
      ReportDistributionManagement@1010 : Codeunit 452;
      FileManagement@1009 : Codeunit 419;
      ServerFilePath@1008 : Text[250];
      ClientFilePath@1007 : Text[250];
      ZipPath@1006 : Text[250];
      ClientZipFileName@1005 : Text[250];
    BEGIN
      IF Disk = Disk::No THEN
        EXIT;

      CASE Disk OF
        Disk::PDF:
          ReportSelections.SendToDiskVendor(ReportUsage,RecordVariant,DocNo,DocName,ToVendor);
        Disk::"Electronic Document":
          BEGIN
            ElectronicDocumentFormat.SendElectronically(ServerFilePath,ClientFilePath,RecordVariant,"Disk Format");
            ReportDistributionManagement.SaveFileOnClient(ServerFilePath,ClientFilePath);
          END;
        Disk::"PDF & Electronic Document":
          BEGIN
            ElectronicDocumentFormat.SendElectronically(ServerFilePath,ClientFilePath,RecordVariant,"Disk Format");
            ReportDistributionManagement.CreateOrAppendZipFile(FileManagement,ServerFilePath,ClientFilePath,ZipPath,ClientZipFileName);
            ReportSelections.SendToZipVendor(ReportUsage,RecordVariant,DocNo,ToVendor,FileManagement);
            FileManagement.CloseZipArchive;

            ReportDistributionManagement.SaveFileOnClient(ZipPath,ClientZipFileName);
          END;
      END;
    END;

    [External]
    PROCEDURE GetOfficeAddinDefault@17(VAR TempDocumentSendingProfile@1000 : TEMPORARY Record 60;CanAttach@1001 : Boolean);
    BEGIN
      WITH TempDocumentSendingProfile DO BEGIN
        INIT;
        Code := DefaultCodeTxt;
        Description := DefaultDescriptionTxt;
        IF CanAttach THEN
          "E-Mail" := "E-Mail"::"Yes (Use Default Settings)"
        ELSE
          "E-Mail" := "E-Mail"::"Yes (Prompt for Settings)";
        "E-Mail Attachment" := "E-Mail Attachment"::PDF;
        Default := FALSE;
      END;
    END;

    LOCAL PROCEDURE GetMultipleDocumentsName@21(DocName@1002 : Text[150];ReportUsage@1000 : Integer;RecRef@1001 : RecordRef) : Text[150];
    VAR
      ReportSelections@1011 : Record 77;
    BEGIN
      IF RecRef.COUNT > 1 THEN
        CASE ReportUsage OF
          ReportSelections.Usage::"S.Invoice":
            EXIT(InvoicesTxt);
          ReportSelections.Usage::"S.Shipment":
            EXIT(ShipmentsTxt);
          ReportSelections.Usage::"S.Cr.Memo":
            EXIT(CreditMemosTxt);
          ReportSelections.Usage::"S.Ret.Rcpt.":
            EXIT(ReceiptsTxt);
          ReportSelections.Usage::JQ:
            EXIT(JobQuotesTxt);
          ReportSelections.Usage::"P.Order":
            EXIT(PurchaseOrdersTxt);
        END;

      EXIT(DocName);
    END;

    LOCAL PROCEDURE GetMultipleDocumentsTo@25(RecRef@1001 : RecordRef;DocumentNoFieldNo@1000 : Integer) : Code[20];
    VAR
      DocumentNoFieldRef@1002 : FieldRef;
    BEGIN
      IF RecRef.COUNT > 1 THEN
        EXIT('');

      DocumentNoFieldRef := RecRef.FIELD(DocumentNoFieldNo);
      EXIT(DocumentNoFieldRef.VALUE);
    END;

    LOCAL PROCEDURE GetDisctinctCustomers@24(RecRef@1002 : RecordRef;CustomerFieldNo@1000 : Integer;VAR TempCustomer@1001 : TEMPORARY Record 18);
    VAR
      FieldRef@1003 : FieldRef;
      CustomerNo@1004 : Code[20];
    BEGIN
      IF RecRef.FINDSET THEN
        REPEAT
          FieldRef := RecRef.FIELD(CustomerFieldNo);
          CustomerNo := FieldRef.VALUE;
          IF NOT TempCustomer.GET(CustomerNo) THEN BEGIN
            TempCustomer."No." := CustomerNo;
            TempCustomer.INSERT;
          END;
        UNTIL RecRef.NEXT = 0;
    END;

    LOCAL PROCEDURE GetDistinctVendors@26(RecRef@1002 : RecordRef;VendorFieldNo@1001 : Integer;VAR TempVendor@1000 : TEMPORARY Record 23);
    VAR
      FieldRef@1004 : FieldRef;
      VendorNo@1003 : Code[20];
    BEGIN
      IF RecRef.FINDSET THEN
        REPEAT
          FieldRef := RecRef.FIELD(VendorFieldNo);
          VendorNo := FieldRef.VALUE;
          IF NOT TempVendor.GET(VendorNo) THEN BEGIN
            TempVendor."No." := VendorNo;
            TempVendor.INSERT;
          END;
        UNTIL RecRef.NEXT = 0;
    END;

    [External]
    PROCEDURE ProfileSelectionMethodDialog@31(VAR ProfileSelectionMethod@1000 : 'ConfirmDefault,ConfirmPerEach,UseDefault';IsCustomer@1002 : Boolean) : Boolean;
    VAR
      ProfileSelectionInstruction@1001 : Text;
    BEGIN
      IF IsCustomer THEN
        ProfileSelectionInstruction := CustomerProfileSelectionInstrTxt
      ELSE
        ProfileSelectionInstruction := VendorProfileSelectionInstrTxt;

      CASE STRMENU(ProfileSelectionQst,3,ProfileSelectionInstruction) OF
        0:
          EXIT(FALSE);
        1:
          ProfileSelectionMethod := ProfileSelectionMethod::ConfirmDefault;
        2:
          ProfileSelectionMethod := ProfileSelectionMethod::ConfirmPerEach;
        3:
          ProfileSelectionMethod := ProfileSelectionMethod::UseDefault;
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE IsSingleRecordSelected@91(RecordVariant@1003 : Variant;CVNo@1007 : Code[20];CVFieldNo@1005 : Integer) : Boolean;
    VAR
      RecRef@1004 : RecordRef;
      FieldRef@1006 : FieldRef;
    BEGIN
      RecRef.GETTABLE(RecordVariant);
      IF NOT RecRef.FINDSET THEN
        EXIT(FALSE);

      IF RecRef.NEXT = 0 THEN
        EXIT(TRUE);

      FieldRef := RecRef.FIELD(CVFieldNo);
      FieldRef.SETFILTER('<>%1',CVNo);
      EXIT(RecRef.ISEMPTY);
    END;

    [External]
    PROCEDURE CheckElectronicSendingEnabled@34();
    VAR
      DocExchServiceMgt@1002 : Codeunit 1410;
    BEGIN
      IF "Electronic Document" <> "Electronic Document"::No THEN
        DocExchServiceMgt.CheckServiceEnabled;
    END;

    BEGIN
    END.
  }
}

