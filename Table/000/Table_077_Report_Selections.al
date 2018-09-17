OBJECT Table 77 Report Selections
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               CheckEmailBodyUsage;
             END;

    OnModify=BEGIN
               TESTFIELD("Report ID");
               CheckEmailBodyUsage;
             END;

    CaptionML=[DAN=Rapportvalg;
               ENU=Report Selections];
  }
  FIELDS
  {
    { 1   ;   ;Usage               ;Option        ;CaptionML=[DAN=Rapporttype;
                                                              ENU=Usage];
                                                   OptionCaptionML=[DAN=S.Quote,S.Order,S.Invoice,S.Cr.Memo,S.Test,P.Quote,P.Order,P.Invoice,P.Cr.Memo,P.Receipt,P.Ret.Shpt.,P.Test,B.Stmt,B.Recon.Test,B.Check,Reminder,Fin.Charge,Rem.Test,F.C.Test,Prod. Order,S.Blanket,P.Blanket,M1,M2,M3,M4,Inv1,Inv2,Inv3,SM.Quote,SM.Order,SM.Invoice,SM.Credit Memo,SM.Contract Quote,SM.Contract,SM.Test,S.Return,P.Return,S.Shipment,S.Ret.Rcpt.,S.Work Order,Invt. Period Test,SM.Shipment,S.Test Prepmt.,P.Test Prepmt.,S.Arch. Quote,S.Arch. Order,P.Arch. Quote,P.Arch. Order,S. Arch. Return Order,P. Arch. Return Order,Asm. Order,P.Assembly Order,S.Order Pick Instruction,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,C.Statement,V.Remittance,JQ,S.Invoice Draft,Pro Forma S. Invoice;
                                                                    ENU=S.Quote,S.Order,S.Invoice,S.Cr.Memo,S.Test,P.Quote,P.Order,P.Invoice,P.Cr.Memo,P.Receipt,P.Ret.Shpt.,P.Test,B.Stmt,B.Recon.Test,B.Check,Reminder,Fin.Charge,Rem.Test,F.C.Test,Prod. Order,S.Blanket,P.Blanket,M1,M2,M3,M4,Inv1,Inv2,Inv3,SM.Quote,SM.Order,SM.Invoice,SM.Credit Memo,SM.Contract Quote,SM.Contract,SM.Test,S.Return,P.Return,S.Shipment,S.Ret.Rcpt.,S.Work Order,Invt. Period Test,SM.Shipment,S.Test Prepmt.,P.Test Prepmt.,S.Arch. Quote,S.Arch. Order,P.Arch. Quote,P.Arch. Order,S. Arch. Return Order,P. Arch. Return Order,Asm. Order,P.Assembly Order,S.Order Pick Instruction,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,C.Statement,V.Remittance,JQ,S.Invoice Draft,Pro Forma S. Invoice];
                                                   OptionString=S.Quote,S.Order,S.Invoice,S.Cr.Memo,S.Test,P.Quote,P.Order,P.Invoice,P.Cr.Memo,P.Receipt,P.Ret.Shpt.,P.Test,B.Stmt,B.Recon.Test,B.Check,Reminder,Fin.Charge,Rem.Test,F.C.Test,Prod. Order,S.Blanket,P.Blanket,M1,M2,M3,M4,Inv1,Inv2,Inv3,SM.Quote,SM.Order,SM.Invoice,SM.Credit Memo,SM.Contract Quote,SM.Contract,SM.Test,S.Return,P.Return,S.Shipment,S.Ret.Rcpt.,S.Work Order,Invt. Period Test,SM.Shipment,S.Test Prepmt.,P.Test Prepmt.,S.Arch. Quote,S.Arch. Order,P.Arch. Quote,P.Arch. Order,S. Arch. Return Order,P. Arch. Return Order,Asm. Order,P.Assembly Order,S.Order Pick Instruction,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,C.Statement,V.Remittance,JQ,S.Invoice Draft,Pro Forma S. Invoice }
    { 2   ;   ;Sequence            ;Code10        ;CaptionML=[DAN=R�kkef�lge;
                                                              ENU=Sequence];
                                                   Numeric=Yes }
    { 3   ;   ;Report ID           ;Integer       ;TableRelation=AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Report));
                                                   OnValidate=BEGIN
                                                                CALCFIELDS("Report Caption");
                                                                VALIDATE("Use for Email Body",FALSE);
                                                              END;

                                                   CaptionML=[DAN=Rapport-id;
                                                              ENU=Report ID] }
    { 4   ;   ;Report Caption      ;Text250       ;FieldClass=FlowField;
                                                   CalcFormula=Lookup(AllObjWithCaption."Object Caption" WHERE (Object Type=CONST(Report),
                                                                                                                Object ID=FIELD(Report ID)));
                                                   CaptionML=[DAN=Rapportoverskrift;
                                                              ENU=Report Caption];
                                                   Editable=No }
    { 7   ;   ;Custom Report Layout Code;Code20   ;TableRelation="Custom Report Layout".Code WHERE (Code=FIELD(Custom Report Layout Code));
                                                   CaptionML=[DAN=Layoutkode for brugerdefineret rapport;
                                                              ENU=Custom Report Layout Code];
                                                   Editable=No }
    { 19  ;   ;Use for Email Attachment;Boolean   ;InitValue=Yes;
                                                   OnValidate=BEGIN
                                                                IF NOT "Use for Email Body" THEN
                                                                  VALIDATE("Email Body Layout Code",'');
                                                              END;

                                                   CaptionML=[DAN=Brug til vedh�ftet fil i mail;
                                                              ENU=Use for Email Attachment] }
    { 20  ;   ;Use for Email Body  ;Boolean       ;OnValidate=BEGIN
                                                                IF NOT "Use for Email Body" THEN
                                                                  VALIDATE("Email Body Layout Code",'');
                                                              END;

                                                   CaptionML=[DAN=Brug til br�dtekst i mail;
                                                              ENU=Use for Email Body] }
    { 21  ;   ;Email Body Layout Code;Code20      ;TableRelation=IF (Email Body Layout Type=CONST(Custom Report Layout)) "Custom Report Layout".Code WHERE (Code=FIELD(Email Body Layout Code),
                                                                                                                                                            Report ID=FIELD(Report ID))
                                                                                                                                                            ELSE IF (Email Body Layout Type=CONST(HTML Layout)) "O365 HTML Template".Code;
                                                   OnValidate=BEGIN
                                                                IF "Email Body Layout Code" <> '' THEN
                                                                  TESTFIELD("Use for Email Body",TRUE);
                                                                CALCFIELDS("Email Body Layout Description");
                                                              END;

                                                   CaptionML=[DAN=Layoutkode for br�dtekst i mail;
                                                              ENU=Email Body Layout Code] }
    { 22  ;   ;Email Body Layout Description;Text250;
                                                   FieldClass=FlowField;
                                                   CalcFormula=Lookup("Custom Report Layout".Description WHERE (Code=FIELD(Email Body Layout Code)));
                                                   OnLookup=VAR
                                                              CustomReportLayout@1001 : Record 9650;
                                                            BEGIN
                                                              IF "Email Body Layout Type" = "Email Body Layout Type"::"Custom Report Layout" THEN
                                                                IF CustomReportLayout.LookupLayoutOK("Report ID") THEN
                                                                  VALIDATE("Email Body Layout Code",CustomReportLayout.Code);
                                                            END;

                                                   CaptionML=[DAN=Layoutbeskrivelse for br�dtekst i mail;
                                                              ENU=Email Body Layout Description];
                                                   Editable=No }
    { 25  ;   ;Email Body Layout Type;Option      ;CaptionML=[DAN=Layouttype for br�dtekst i mail;
                                                              ENU=Email Body Layout Type];
                                                   OptionCaptionML=[DAN=Brugerdefineret rapportlayout,HTML-layout;
                                                                    ENU=Custom Report Layout,HTML Layout];
                                                   OptionString=Custom Report Layout,HTML Layout }
  }
  KEYS
  {
    {    ;Usage,Sequence                          ;Clustered=Yes }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      ReportSelection2@1000 : Record 77;
      MustSelectAndEmailBodyOrAttahmentErr@1001 : TextConst '@@@="%1 = Usage, for example Sales Invoice";DAN=Du skal v�lge en br�dtekst i mail eller vedh�ftet fil til mail i rapportvalget for %1.;ENU=You must select an email body or attachment in report selection for %1.';
      EmailBodyIsAlreadyDefinedErr@1002 : TextConst '@@@="%1 = Usage, for example Sales Invoice";DAN=En br�dtekst i mail er allerede defineret for %1.;ENU=An email body is already defined for %1.';
      CannotBeUsedAsAnEmailBodyErr@1003 : TextConst '@@@="%1 = Report ID,%2 = Type";DAN=Rapporten %1 bruger %2, som ikke kan bruges som br�dtekst i mail.;ENU=Report %1 uses the %2 which cannot be used as an email body.';
      ReportLayoutSelection@1004 : Record 9651;
      OneRecordWillBeSentQst@1005 : TextConst 'DAN=Kun det f�rste af de valgte dokumenter kan l�gges i opgavek�en.\\Vil du forts�tte?;ENU=Only the first of the selected documents can be scheduled in the job queue.\\Do you want to continue?';
      InteractionMgt@1006 : Codeunit 5067;

    [External]
    PROCEDURE NewRecord@1();
    BEGIN
      ReportSelection2.SETRANGE(Usage,Usage);
      IF ReportSelection2.FINDLAST AND (ReportSelection2.Sequence <> '') THEN
        Sequence := INCSTR(ReportSelection2.Sequence)
      ELSE
        Sequence := '1';
    END;

    LOCAL PROCEDURE CheckEmailBodyUsage@19();
    VAR
      ReportSelections@1001 : Record 77;
      ReportLayoutSelection@1000 : Record 9651;
    BEGIN
      IF "Use for Email Body" THEN BEGIN
        ReportSelections.FilterEmailBodyUsage(Usage);
        ReportSelections.SETFILTER(Sequence,'<>%1',Sequence);
        IF NOT ReportSelections.ISEMPTY THEN
          ERROR(EmailBodyIsAlreadyDefinedErr,Usage);

        IF "Email Body Layout Code" = '' THEN
          IF ReportLayoutSelection.GetDefaultType("Report ID") =
             ReportLayoutSelection.Type::"RDLC (built-in)"
          THEN
            ERROR(CannotBeUsedAsAnEmailBodyErr,"Report ID",ReportLayoutSelection.Type);
      END;
    END;

    [External]
    PROCEDURE FilterPrintUsage@2(ReportUsage@1000 : Integer);
    BEGIN
      RESET;
      SETRANGE(Usage,ReportUsage);
    END;

    [External]
    PROCEDURE FilterEmailUsage@3(ReportUsage@1000 : Integer);
    BEGIN
      RESET;
      SETRANGE(Usage,ReportUsage);
      SETRANGE("Use for Email Body",TRUE);
    END;

    [External]
    PROCEDURE FilterEmailBodyUsage@13(ReportUsage@1000 : Integer);
    BEGIN
      RESET;
      SETRANGE(Usage,ReportUsage);
      SETRANGE("Use for Email Body",TRUE);
    END;

    [External]
    PROCEDURE FilterEmailAttachmentUsage@11(ReportUsage@1000 : Integer);
    BEGIN
      RESET;
      SETRANGE(Usage,ReportUsage);
      SETRANGE("Use for Email Attachment",TRUE);
    END;

    [External]
    PROCEDURE FindPrintUsage@4(ReportUsage@1000 : Integer;CustNo@1002 : Code[20];VAR ReportSelections@1001 : Record 77);
    BEGIN
      FindPrintUsageInternal(ReportUsage,CustNo,ReportSelections,DATABASE::Customer);
    END;

    [External]
    PROCEDURE FindPrintUsageVendor@33(ReportUsage@1002 : Integer;VendorNo@1001 : Code[20];VAR ReportSelections@1000 : Record 77);
    BEGIN
      FindPrintUsageInternal(ReportUsage,VendorNo,ReportSelections,DATABASE::Vendor);
    END;

    LOCAL PROCEDURE FindPrintUsageInternal@44(ReportUsage@1000 : Integer;AccountNo@1002 : Code[20];VAR ReportSelections@1001 : Record 77;TableNo@1003 : Integer);
    BEGIN
      FilterPrintUsage(ReportUsage);
      SETFILTER("Report ID",'<>0');

      FindReportSelections(ReportSelections,AccountNo,TableNo);
      ReportSelections.FINDSET;
    END;

    [External]
    PROCEDURE FindEmailAttachmentUsage@10(ReportUsage@1000 : Integer;CustNo@1002 : Code[20];VAR ReportSelections@1001 : Record 77) : Boolean;
    BEGIN
      FilterEmailAttachmentUsage(ReportUsage);
      SETFILTER("Report ID",'<>0');
      SETRANGE("Use for Email Attachment",TRUE);

      FindReportSelections(ReportSelections,CustNo,DATABASE::Customer);
      EXIT(ReportSelections.FINDSET);
    END;

    [External]
    PROCEDURE FindEmailAttachmentUsageVendor@45(ReportUsage@1002 : Integer;VendorNo@1001 : Code[20];VAR ReportSelections@1000 : Record 77) : Boolean;
    BEGIN
      FilterEmailAttachmentUsage(ReportUsage);
      SETFILTER("Report ID",'<>0');
      SETRANGE("Use for Email Attachment",TRUE);

      FindReportSelections(ReportSelections,VendorNo,DATABASE::Vendor);
      EXIT(ReportSelections.FINDSET);
    END;

    [External]
    PROCEDURE FindEmailBodyUsage@5(ReportUsage@1000 : Integer;CustNo@1002 : Code[20];VAR ReportSelections@1001 : Record 77) : Boolean;
    BEGIN
      FilterEmailBodyUsage(ReportUsage);
      SETFILTER("Report ID",'<>0');

      FindReportSelections(ReportSelections,CustNo,DATABASE::Customer);
      EXIT(ReportSelections.FINDSET);
    END;

    [External]
    PROCEDURE FindEmailBodyUsageVendor@42(ReportUsage@1002 : Integer;VendorNo@1001 : Code[20];VAR ReportSelections@1000 : Record 77) : Boolean;
    BEGIN
      FilterEmailBodyUsage(ReportUsage);
      SETFILTER("Report ID",'<>0');

      FindReportSelections(ReportSelections,VendorNo,DATABASE::Vendor);
      EXIT(ReportSelections.FINDSET);
    END;

    [External]
    PROCEDURE PrintWithCheck@6(ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;CustomerNoFieldNo@1003 : Integer);
    VAR
      Handled@1002 : Boolean;
    BEGIN
      OnBeforePrintWithCheck(ReportUsage,RecordVariant,CustomerNoFieldNo,Handled);
      IF Handled THEN
        EXIT;

      PrintWithGUIYesNoWithCheck(ReportUsage,RecordVariant,TRUE,CustomerNoFieldNo);
    END;

    [External]
    PROCEDURE PrintWithGUIYesNoWithCheck@12(ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;IsGUI@1002 : Boolean;CustomerNoFieldNo@1005 : Integer);
    VAR
      Handled@1003 : Boolean;
    BEGIN
      OnBeforePrintWithGUIYesNoWithCheck(ReportUsage,RecordVariant,IsGUI,CustomerNoFieldNo,Handled);
      IF Handled THEN
        EXIT;

      PrintDocumentsWithCheckGUIYesNoCommon(ReportUsage,RecordVariant,IsGUI,CustomerNoFieldNo,TRUE,DATABASE::Customer);
    END;

    [External]
    PROCEDURE PrintWithGUIYesNoWithCheckVendor@66(ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;IsGUI@1002 : Boolean;VendorNoFieldNo@1005 : Integer);
    VAR
      Handled@1003 : Boolean;
    BEGIN
      OnBeforePrintWithGUIYesNoWithCheckVendor(ReportUsage,RecordVariant,IsGUI,VendorNoFieldNo,Handled);
      IF Handled THEN
        EXIT;

      PrintDocumentsWithCheckGUIYesNoCommon(ReportUsage,RecordVariant,IsGUI,VendorNoFieldNo,TRUE,DATABASE::Vendor);
    END;

    [External]
    PROCEDURE Print@7(ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;CustomerNoFieldNo@1003 : Integer);
    VAR
      Handled@1002 : Boolean;
    BEGIN
      OnBeforePrint(ReportUsage,RecordVariant,CustomerNoFieldNo,Handled);
      IF Handled THEN
        EXIT;

      PrintWithGUIYesNo(ReportUsage,RecordVariant,TRUE,CustomerNoFieldNo);
    END;

    [External]
    PROCEDURE PrintWithGUIYesNo@8(ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;IsGUI@1002 : Boolean;CustomerNoFieldNo@1005 : Integer);
    VAR
      Handled@1003 : Boolean;
    BEGIN
      OnBeforePrintWithGUIYesNo(ReportUsage,RecordVariant,IsGUI,CustomerNoFieldNo,Handled);
      IF Handled THEN
        EXIT;

      PrintDocumentsWithCheckGUIYesNoCommon(ReportUsage,RecordVariant,IsGUI,CustomerNoFieldNo,FALSE,DATABASE::Customer);
    END;

    [External]
    PROCEDURE PrintWithGUIYesNoVendor@32(ReportUsage@1003 : Integer;RecordVariant@1002 : Variant;IsGUI@1001 : Boolean;VendorNoFieldNo@1005 : Integer);
    VAR
      Handled@1000 : Boolean;
    BEGIN
      OnBeforePrintWithGUIYesNoVendor(ReportUsage,RecordVariant,IsGUI,VendorNoFieldNo,Handled);
      IF Handled THEN
        EXIT;

      PrintDocumentsWithCheckGUIYesNoCommon(ReportUsage,RecordVariant,IsGUI,VendorNoFieldNo,FALSE,DATABASE::Vendor);
    END;

    LOCAL PROCEDURE PrintDocumentsWithCheckGUIYesNoCommon@65(ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;IsGUI@1002 : Boolean;AccountNoFieldNo@1005 : Integer;WithCheck@1009 : Boolean;TableNo@1008 : Integer);
    VAR
      TempReportSelections@1004 : TEMPORARY Record 77;
      TempNameValueBuffer@1006 : TEMPORARY Record 823;
      RecRef@1007 : RecordRef;
      RecRefToPrint@1003 : RecordRef;
      RecVarToPrint@1011 : Variant;
      AccountNoFilter@1013 : Text;
    BEGIN
      OnBeforeSetReportLayout(RecordVariant);

      RecRef.GETTABLE(RecordVariant);
      GetUniqueAccountNos(TempNameValueBuffer,RecRef,AccountNoFieldNo);

      SelectTempReportSelectionsToPrint(TempReportSelections,TempNameValueBuffer,WithCheck,ReportUsage,TableNo);

      IF TempReportSelections.FINDSET THEN
        REPEAT
          IF TempReportSelections."Custom Report Layout Code" <> '' THEN
            ReportLayoutSelection.SetTempLayoutSelected(TempReportSelections."Custom Report Layout Code")
          ELSE
            ReportLayoutSelection.SetTempLayoutSelected('');

          TempNameValueBuffer.FINDSET;
          AccountNoFilter := GetAccountNoFilterForCustomReportLayout(TempReportSelections,TempNameValueBuffer,TableNo);
          GetFilteredRecordRef(RecRefToPrint,RecRef,AccountNoFieldNo,AccountNoFilter);
          RecVarToPrint := RecRefToPrint;

          REPORT.RUNMODAL(TempReportSelections."Report ID",IsGUI,FALSE,RecVarToPrint);

          ReportLayoutSelection.SetTempLayoutSelected('');
        UNTIL TempReportSelections.NEXT = 0;
    END;

    LOCAL PROCEDURE GetFilteredRecordRef@88(VAR RecRefToPrint@1000 : RecordRef;RecRefSource@1001 : RecordRef;AccountNoFieldNo@1002 : Integer;AccountNoFilter@1003 : Text);
    VAR
      AccountNoFieldRef@1004 : FieldRef;
      CurrentFilterGroup@1005 : Integer;
    BEGIN
      RecRefToPrint := RecRefSource.DUPLICATE;

      IF (AccountNoFieldNo <> 0) AND (AccountNoFilter <> '') THEN BEGIN
        CurrentFilterGroup := RecRefToPrint.FILTERGROUP;
        RecRefToPrint.FILTERGROUP(10);
        AccountNoFieldRef := RecRefToPrint.FIELD(AccountNoFieldNo);
        AccountNoFieldRef.SETFILTER(AccountNoFilter);
        RecRefToPrint.FILTERGROUP(CurrentFilterGroup);
      END;

      IF RecRefToPrint.FINDSET THEN;
    END;

    LOCAL PROCEDURE GetAccountNoFilterForCustomReportLayout@72(VAR TempReportSelections@1000 : TEMPORARY Record 77;VAR TempNameValueBuffer@1001 : TEMPORARY Record 823;TableNo@1002 : Integer) : Text;
    VAR
      CustomReportSelection@1005 : Record 9657;
      AccountNo@1003 : Code[20];
      AccountNoFilter@1004 : Text;
      AccountHasCustomSelection@1006 : Boolean;
      ReportInvolvedInCustomSelection@1007 : Boolean;
    BEGIN
      CustomReportSelection.SETRANGE("Source Type",TableNo);
      CustomReportSelection.SETRANGE(Usage,TempReportSelections.Usage);
      CustomReportSelection.SETRANGE("Report ID",TempReportSelections."Report ID");

      ReportInvolvedInCustomSelection := NOT CustomReportSelection.ISEMPTY;

      AccountNoFilter := '';

      TempNameValueBuffer.FINDSET;
      REPEAT
        AccountNo := COPYSTR(TempNameValueBuffer.Name,1,MAXSTRLEN(AccountNo));
        CustomReportSelection.SETRANGE("Source No.",AccountNo);

        IF ReportInvolvedInCustomSelection THEN BEGIN
          CustomReportSelection.SETRANGE("Custom Report Layout Code",TempReportSelections."Custom Report Layout Code");

          AccountHasCustomSelection := NOT CustomReportSelection.ISEMPTY;
          IF AccountHasCustomSelection THEN
            AccountNoFilter += AccountNo + '|';

          CustomReportSelection.SETRANGE("Custom Report Layout Code");
        END ELSE BEGIN
          CustomReportSelection.SETRANGE("Report ID");

          AccountHasCustomSelection := NOT CustomReportSelection.ISEMPTY;
          IF NOT AccountHasCustomSelection THEN
            AccountNoFilter += AccountNo + '|';

          CustomReportSelection.SETRANGE("Report ID",TempReportSelections."Report ID");
        END;

      UNTIL TempNameValueBuffer.NEXT = 0;

      AccountNoFilter := DELCHR(AccountNoFilter,'>','|');
      EXIT(AccountNoFilter);
    END;

    LOCAL PROCEDURE SelectTempReportSelections@73(VAR TempReportSelections@1003 : TEMPORARY Record 77;AccountNo@1000 : Code[20];WithCheck@1001 : Boolean;ReportUsage@1002 : Option;TableNo@1004 : Integer);
    BEGIN
      IF WithCheck THEN BEGIN
        FilterPrintUsage(ReportUsage);
        FindReportSelections(TempReportSelections,AccountNo,TableNo);
        IF NOT TempReportSelections.FINDSET THEN
          FINDSET;
      END ELSE
        FindPrintUsageInternal(ReportUsage,AccountNo,TempReportSelections,TableNo);
    END;

    LOCAL PROCEDURE SelectTempReportSelectionsToPrint@76(VAR TempReportSelections@1007 : TEMPORARY Record 77;VAR TempNameValueBuffer@1000 : TEMPORARY Record 823;WithCheck@1003 : Boolean;ReportUsage@1004 : Option;TableNo@1005 : Integer);
    VAR
      TempReportSelectionsAccount@1002 : TEMPORARY Record 77;
      AccountNo@1001 : Code[20];
      LastSequence@1006 : Code[10];
    BEGIN
      IF TempNameValueBuffer.FINDSET THEN
        REPEAT
          AccountNo := COPYSTR(TempNameValueBuffer.Name,1,MAXSTRLEN(AccountNo));
          TempReportSelectionsAccount.RESET;
          TempReportSelectionsAccount.DELETEALL;
          SelectTempReportSelections(TempReportSelectionsAccount,AccountNo,WithCheck,ReportUsage,TableNo);
          IF TempReportSelectionsAccount.FINDSET THEN
            REPEAT
              LastSequence := GetLastSequenceNo(TempReportSelections,ReportUsage);
              IF NOT HasReportWithUsage(TempReportSelections,ReportUsage,TempReportSelectionsAccount."Report ID") THEN BEGIN
                TempReportSelections := TempReportSelectionsAccount;
                IF LastSequence = '' THEN
                  TempReportSelections.Sequence := '1'
                ELSE
                  TempReportSelections.Sequence := INCSTR(LastSequence);
                TempReportSelections.INSERT;
              END;
            UNTIL TempReportSelectionsAccount.NEXT = 0;
        UNTIL TempNameValueBuffer.NEXT = 0;
    END;

    [Internal]
    PROCEDURE GetHtmlReport@29(VAR ServerEmailBodyFilePath@1001 : Text[250];ReportUsage@1002 : Integer;RecordVariant@1004 : Variant;CustNo@1003 : Code[20]);
    VAR
      TempBodyReportSelections@1000 : TEMPORARY Record 77;
    BEGIN
      ServerEmailBodyFilePath := '';

      FindPrintUsage(ReportUsage,CustNo,TempBodyReportSelections);

      ServerEmailBodyFilePath :=
        SaveReportAsHTML(TempBodyReportSelections."Report ID",RecordVariant,TempBodyReportSelections."Custom Report Layout Code");
    END;

    [Internal]
    PROCEDURE GetPdfReport@52(VAR ServerEmailBodyFilePath@1001 : Text[250];ReportUsage@1002 : Integer;RecordVariant@1004 : Variant;CustNo@1003 : Code[20]);
    VAR
      TempBodyReportSelections@1000 : TEMPORARY Record 77;
    BEGIN
      ServerEmailBodyFilePath := '';

      FindPrintUsage(ReportUsage,CustNo,TempBodyReportSelections);

      ServerEmailBodyFilePath :=
        SaveReportAsPDF(TempBodyReportSelections."Report ID",RecordVariant,TempBodyReportSelections."Custom Report Layout Code");
    END;

    [Internal]
    PROCEDURE GetEmailBodyInPdf@85(VAR ServerEmailBodyFilePath@1001 : Text[250];ReportUsage@1002 : Integer;RecordVariant@1004 : Variant;CustNo@1003 : Code[20];VAR CustEmailAddress@1005 : Text[250]) : Boolean;
    VAR
      TempBodyReportSelections@1000 : TEMPORARY Record 77;
    BEGIN
      ServerEmailBodyFilePath := '';

      CustEmailAddress := GetEmailAddressIgnoringLayout(ReportUsage,RecordVariant,CustNo);

      IF NOT FindEmailBodyUsage(ReportUsage,CustNo,TempBodyReportSelections) THEN
        EXIT(FALSE);

      ServerEmailBodyFilePath :=
        SaveReportAsPDF(TempBodyReportSelections."Report ID",RecordVariant,TempBodyReportSelections."Email Body Layout Code");

      CustEmailAddress := GetEmailAddress(ReportUsage,RecordVariant,CustNo,TempBodyReportSelections);

      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE GetEmailBody@20(VAR ServerEmailBodyFilePath@1001 : Text[250];ReportUsage@1002 : Integer;RecordVariant@1004 : Variant;CustNo@1003 : Code[20];VAR CustEmailAddress@1005 : Text[250]) : Boolean;
    VAR
      TempBodyReportSelections@1000 : TEMPORARY Record 77;
      O365HTMLTemplMgt@1006 : Codeunit 2114;
    BEGIN
      ServerEmailBodyFilePath := '';

      OnBeforeGetEmailBodyCustomer;

      IF CustEmailAddress = '' THEN
        CustEmailAddress := GetEmailAddressIgnoringLayout(ReportUsage,RecordVariant,CustNo);

      IF NOT FindEmailBodyUsage(ReportUsage,CustNo,TempBodyReportSelections) THEN
        EXIT(FALSE);

      CASE "Email Body Layout Type" OF
        "Email Body Layout Type"::"Custom Report Layout":
          ServerEmailBodyFilePath :=
            SaveReportAsHTML(TempBodyReportSelections."Report ID",RecordVariant,TempBodyReportSelections."Email Body Layout Code");
        "Email Body Layout Type"::"HTML Layout":
          ServerEmailBodyFilePath :=
            O365HTMLTemplMgt.CreateEmailBodyFromReportSelections(Rec,RecordVariant,CustEmailAddress);
      END;

      CustEmailAddress := GetEmailAddress(ReportUsage,RecordVariant,CustNo,TempBodyReportSelections);

      OnAfterGetEmailBodyCustomer(CustEmailAddress,ServerEmailBodyFilePath);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetEmailAddressIgnoringLayout@70(ReportUsage@1002 : Integer;RecordVariant@1004 : Variant;CustNo@1003 : Code[20]) : Text[250];
    VAR
      TempBodyReportSelections@1000 : TEMPORARY Record 77;
      EmailAddress@1001 : Text[250];
    BEGIN
      EmailAddress := GetEmailAddress(ReportUsage,RecordVariant,CustNo,TempBodyReportSelections);
      EXIT(EmailAddress);
    END;

    LOCAL PROCEDURE GetEmailAddress@60(ReportUsage@1002 : Integer;RecordVariant@1004 : Variant;CustNo@1003 : Code[20];VAR TempBodyReportSelections@1000 : TEMPORARY Record 77) : Text[250];
    VAR
      DataTypeManagement@1008 : Codeunit 701;
      RecordRef@1007 : RecordRef;
      FieldRef@1009 : FieldRef;
      DocumentNo@1011 : Code[20];
      EmailAddress@1001 : Text[250];
    BEGIN
      RecordRef.GETTABLE(RecordVariant);
      IF NOT RecordRef.ISEMPTY THEN
        IF DataTypeManagement.FindFieldByName(RecordRef,FieldRef,'No.') THEN BEGIN
          DocumentNo := FieldRef.VALUE;
          EmailAddress := GetDocumentEmailAddress(DocumentNo,ReportUsage);
          IF EmailAddress <> '' THEN
            EXIT(EmailAddress);
        END;

      IF NOT TempBodyReportSelections.ISEMPTY THEN BEGIN
        EmailAddress :=
          FindEmailAddressForEmailLayout(TempBodyReportSelections."Email Body Layout Code",CustNo,ReportUsage,DATABASE::Customer);
        IF EmailAddress <> '' THEN
          EXIT(EmailAddress);
      END;

      EmailAddress := GetCustEmailAddress(CustNo);
      EXIT(EmailAddress);
    END;

    [Internal]
    PROCEDURE GetEmailBodyVendor@40(VAR ServerEmailBodyFilePath@1004 : Text[250];ReportUsage@1003 : Integer;RecordVariant@1002 : Variant;VendorNo@1001 : Code[20];VAR VendorEmailAddress@1000 : Text[250]) : Boolean;
    VAR
      TempBodyReportSelections@1005 : TEMPORARY Record 77;
      FoundVendorEmailAddress@1007 : Text[250];
    BEGIN
      ServerEmailBodyFilePath := '';

      OnBeforeGetEmailBodyVendor;

      VendorEmailAddress := GetVendorEmailAddress(VendorNo,RecordVariant,ReportUsage);

      IF NOT FindEmailBodyUsageVendor(ReportUsage,VendorNo,TempBodyReportSelections) THEN
        EXIT(FALSE);

      ServerEmailBodyFilePath :=
        SaveReportAsHTML(TempBodyReportSelections."Report ID",RecordVariant,TempBodyReportSelections."Email Body Layout Code");

      FoundVendorEmailAddress :=
        FindEmailAddressForEmailLayout(TempBodyReportSelections."Email Body Layout Code",VendorNo,ReportUsage,DATABASE::Vendor);
      IF FoundVendorEmailAddress <> '' THEN
        VendorEmailAddress := FoundVendorEmailAddress;

      OnAfterGetEmailBodyVendor(VendorEmailAddress,ServerEmailBodyFilePath);

      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE SendEmailInBackground@30(JobQueueEntry@1000 : Record 472);
    VAR
      RecRef@1005 : RecordRef;
      ReportUsage@1004 : Integer;
      DocNo@1003 : Code[20];
      DocName@1002 : Text[150];
      No@1001 : Code[20];
      ParamString@1006 : Text;
    BEGIN
      // Called from codeunit 260 OnRun trigger - in a background process.
      RecRef.GET(JobQueueEntry."Record ID to Process");
      RecRef.LOCKTABLE;
      RecRef.FIND;
      RecRef.SETRECFILTER;
      ParamString := JobQueueEntry."Parameter String";  // Are set in function SendEmailToCust
      GetJobQueueParameters(ParamString,ReportUsage,DocNo,DocName,No);

      IF ParamString = 'Vendor' THEN
        SendEmailToVendorDirectly(ReportUsage,RecRef,DocNo,DocName,FALSE,No)
      ELSE
        SendEmailToCustDirectly(ReportUsage,RecRef,DocNo,DocName,FALSE,No);
    END;

    PROCEDURE GetJobQueueParameters@56(VAR ParameterString@1000 : Text;VAR ReportUsage@1001 : Integer;VAR DocNo@1002 : Code[20];VAR DocName@1003 : Text[150];VAR CustNo@1004 : Code[20]) WasSuccessful : Boolean;
    BEGIN
      WasSuccessful := EVALUATE(ReportUsage,GetNextJobQueueParam(ParameterString));
      WasSuccessful := WasSuccessful AND EVALUATE(DocNo,GetNextJobQueueParam(ParameterString));
      WasSuccessful := WasSuccessful AND EVALUATE(DocName,GetNextJobQueueParam(ParameterString));
      WasSuccessful := WasSuccessful AND EVALUATE(CustNo,GetNextJobQueueParam(ParameterString));
    END;

    LOCAL PROCEDURE GetNextJobQueueParam@31(VAR Parameter@1000 : Text) : Text;
    VAR
      i@1001 : Integer;
      Result@1002 : Text;
    BEGIN
      i := STRPOS(Parameter,'|');
      IF i > 0 THEN
        Result := COPYSTR(Parameter,1,i - 1);
      IF (i + 1) < STRLEN(Parameter) THEN
        Parameter := COPYSTR(Parameter,i + 1);
      EXIT(Result);
    END;

    [Internal]
    PROCEDURE SendEmailToCust@9(ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;DocNo@1006 : Code[20];DocName@1004 : Text[150];ShowDialog@1007 : Boolean;CustNo@1010 : Code[20]);
    VAR
      JobQueueEntry@1003 : Record 472;
      SMTPMail@1002 : Codeunit 400;
      OfficeMgt@1008 : Codeunit 1630;
      RecRef@1005 : RecordRef;
      Handled@1012 : Boolean;
    BEGIN
      OnBeforeSendEmailToCust(ReportUsage,RecordVariant,DocNo,DocName,ShowDialog,CustNo,Handled);
      IF Handled THEN
        EXIT;

      IF ShowDialog OR
         (NOT SMTPMail.IsEnabled) OR
         (GetEmailAddressIgnoringLayout(ReportUsage,RecordVariant,CustNo) = '') OR
         OfficeMgt.IsAvailable
      THEN BEGIN
        SendEmailToCustDirectly(ReportUsage,RecordVariant,DocNo,DocName,TRUE,CustNo);
        EXIT;
      END;

      RecRef.GETTABLE(RecordVariant);
      IF RecordsCanBeSent(RecRef) THEN BEGIN
        JobQueueEntry.INIT;
        JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
        JobQueueEntry."Object ID to Run" := CODEUNIT::"Document-Mailing";
        JobQueueEntry."Maximum No. of Attempts to Run" := 3;
        JobQueueEntry."Record ID to Process" := RecRef.RECORDID;
        JobQueueEntry."Parameter String" := STRSUBSTNO('%1|%2|%3|%4|',ReportUsage,DocNo,DocName,CustNo);
        JobQueueEntry.Description := COPYSTR(DocName,1,MAXSTRLEN(JobQueueEntry.Description));
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry);
      END;
    END;

    [Internal]
    PROCEDURE SendEmailToVendor@34(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;DocNo@1003 : Code[20];DocName@1002 : Text[150];ShowDialog@1001 : Boolean;VendorNo@1000 : Code[20]);
    VAR
      JobQueueEntry@1008 : Record 472;
      SMTPMail@1007 : Codeunit 400;
      OfficeMgt@1009 : Codeunit 1630;
      RecRef@1006 : RecordRef;
      VendorEmail@1011 : Text[250];
      Handled@1012 : Boolean;
    BEGIN
      OnBeforeSendEmailToVendor(ReportUsage,RecordVariant,DocNo,DocName,ShowDialog,VendorNo,Handled);
      IF Handled THEN
        EXIT;

      VendorEmail := GetVendorEmailAddress(VendorNo,RecordVariant,ReportUsage);
      IF ShowDialog OR NOT SMTPMail.IsEnabled OR (VendorEmail = '') OR OfficeMgt.IsAvailable THEN BEGIN
        SendEmailToVendorDirectly(ReportUsage,RecordVariant,DocNo,DocName,TRUE,VendorNo);
        EXIT;
      END;

      RecRef.GETTABLE(RecordVariant);
      JobQueueEntry.INIT;
      JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
      JobQueueEntry."Object ID to Run" := CODEUNIT::"Document-Mailing";
      JobQueueEntry."Maximum No. of Attempts to Run" := 3;
      JobQueueEntry."Record ID to Process" := RecRef.RECORDID;
      JobQueueEntry."Parameter String" := STRSUBSTNO('%1|%2|%3|%4|%5',ReportUsage,DocNo,DocName,VendorNo,'Vendor');
      JobQueueEntry.Description := COPYSTR(DocName,1,MAXSTRLEN(JobQueueEntry.Description));
      CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry);
    END;

    LOCAL PROCEDURE SendEmailToCustDirectly@28(ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;DocNo@1006 : Code[20];DocName@1004 : Text[150];ShowDialog@1007 : Boolean;CustNo@1010 : Code[20]) : Boolean;
    VAR
      TempAttachReportSelections@1008 : TEMPORARY Record 77;
      CustomReportSelection@1014 : Record 9657;
      MailManagement@1003 : Codeunit 9520;
      FoundBody@1005 : Boolean;
      FoundAttachment@1011 : Boolean;
      ServerEmailBodyFilePath@1009 : Text[250];
      EmailAddress@1012 : Text[250];
    BEGIN
      OnBeforeSetReportLayout(RecordVariant);
      BINDSUBSCRIPTION(MailManagement);
      FoundBody := GetEmailBody(ServerEmailBodyFilePath,ReportUsage,RecordVariant,CustNo,EmailAddress);
      UNBINDSUBSCRIPTION(MailManagement);
      FoundAttachment := FindEmailAttachmentUsage(ReportUsage,CustNo,TempAttachReportSelections);

      CustomReportSelection.SETRANGE("Source Type",DATABASE::Customer);
      CustomReportSelection.SETFILTER("Source No.",CustNo);
      EXIT(SendEmailDirectly(
          ReportUsage,RecordVariant,DocNo,DocName,FoundBody,FoundAttachment,ServerEmailBodyFilePath,EmailAddress,ShowDialog,
          TempAttachReportSelections,CustomReportSelection));
    END;

    LOCAL PROCEDURE SendEmailToVendorDirectly@37(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;DocNo@1003 : Code[20];DocName@1002 : Text[150];ShowDialog@1001 : Boolean;VendorNo@1000 : Code[20]) : Boolean;
    VAR
      TempAttachReportSelections@1014 : TEMPORARY Record 77;
      CustomReportSelection@1013 : Record 9657;
      MailManagement@1008 : Codeunit 9520;
      FoundBody@1010 : Boolean;
      FoundAttachment@1009 : Boolean;
      ServerEmailBodyFilePath@1007 : Text[250];
      EmailAddress@1006 : Text[250];
    BEGIN
      OnBeforeSetReportLayout(RecordVariant);
      BINDSUBSCRIPTION(MailManagement);
      FoundBody := GetEmailBodyVendor(ServerEmailBodyFilePath,ReportUsage,RecordVariant,VendorNo,EmailAddress);
      UNBINDSUBSCRIPTION(MailManagement);
      FoundAttachment := FindEmailAttachmentUsageVendor(ReportUsage,VendorNo,TempAttachReportSelections);

      CustomReportSelection.SETRANGE("Source Type",DATABASE::Vendor);
      CustomReportSelection.SETFILTER("Source No.",VendorNo);
      EXIT(SendEmailDirectly(
          ReportUsage,RecordVariant,DocNo,DocName,FoundBody,FoundAttachment,ServerEmailBodyFilePath,EmailAddress,ShowDialog,
          TempAttachReportSelections,CustomReportSelection));
    END;

    LOCAL PROCEDURE SendEmailDirectly@50(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;DocNo@1003 : Code[20];DocName@1002 : Text[150];FoundBody@1006 : Boolean;FoundAttachment@1007 : Boolean;ServerEmailBodyFilePath@1008 : Text[250];VAR DefaultEmailAddress@1010 : Text[250];ShowDialog@1009 : Boolean;VAR TempAttachReportSelections@1020 : TEMPORARY Record 77;VAR CustomReportSelection@1000 : Record 9657) AllEmailsWereSuccessful : Boolean;
    VAR
      DocumentMailing@1017 : Codeunit 260;
      OfficeAttachmentManager@1016 : Codeunit 1629;
      ServerAttachmentFilePath@1013 : Text[250];
      EmailAddress@1001 : Text[250];
    BEGIN
      AllEmailsWereSuccessful := TRUE;

      ShowNoBodyNoAttachmentError(ReportUsage,FoundBody,FoundAttachment);

      IF FoundBody AND NOT FoundAttachment THEN
        AllEmailsWereSuccessful :=
          DocumentMailing.EmailFile('','',ServerEmailBodyFilePath,DocNo,EmailAddress,DocName,NOT ShowDialog,ReportUsage);

      IF NOT FoundBody THEN
        InteractionMgt.SetEmailDraftLogging(TRUE);
      IF FoundAttachment THEN BEGIN
        IF ReportUsage = Usage::JQ THEN BEGIN
          Usage := ReportUsage;
          CustomReportSelection.SETFILTER(Usage,GETFILTER(Usage));
          IF CustomReportSelection.FINDFIRST THEN
            IF CustomReportSelection."Send To Email" <> '' THEN
              DefaultEmailAddress := CustomReportSelection."Send To Email";
        END;

        WITH TempAttachReportSelections DO BEGIN
          OfficeAttachmentManager.IncrementCount(COUNT - 1);
          REPEAT
            EmailAddress := COPYSTR(
                GetNextEmailAddressFromCustomReportSelection(CustomReportSelection,DefaultEmailAddress,Usage,Sequence),
                1,MAXSTRLEN(EmailAddress));
            ServerAttachmentFilePath := SaveReportAsPDF("Report ID",RecordVariant,"Custom Report Layout Code");
            AllEmailsWereSuccessful := AllEmailsWereSuccessful AND DocumentMailing.EmailFile(
                ServerAttachmentFilePath,
                '',
                ServerEmailBodyFilePath,
                DocNo,
                EmailAddress,
                DocName,
                NOT ShowDialog,
                ReportUsage);
          UNTIL NEXT = 0;
        END;
      END;
      InteractionMgt.SetEmailDraftLogging(FALSE);

      EXIT(AllEmailsWereSuccessful);
    END;

    [Internal]
    PROCEDURE SendToDisk@17(ReportUsage@1000 : Integer;RecordVariant@1001 : Variant;DocNo@1006 : Code[20];DocName@1007 : Text;CustNo@1004 : Code[20]);
    VAR
      TempReportSelections@1005 : TEMPORARY Record 77;
      ElectronicDocumentFormat@1008 : Record 61;
      FileManagement@1010 : Codeunit 419;
      ServerAttachmentFilePath@1002 : Text[250];
      ClientAttachmentFileName@1009 : Text;
    BEGIN
      OnBeforeSetReportLayout(RecordVariant);
      FindPrintUsage(ReportUsage,CustNo,TempReportSelections);
      WITH TempReportSelections DO
        REPEAT
          ServerAttachmentFilePath := SaveReportAsPDF("Report ID",RecordVariant,"Custom Report Layout Code");
          ClientAttachmentFileName := ElectronicDocumentFormat.GetAttachmentFileName(DocNo,DocName,'pdf');

          FileManagement.DownloadHandler(
            ServerAttachmentFilePath,
            '',
            '',
            FileManagement.GetToFilterText('',ClientAttachmentFileName),
            ClientAttachmentFileName);
        UNTIL NEXT = 0;
    END;

    [Internal]
    PROCEDURE SendToDiskVendor@48(ReportUsage@1004 : Integer;RecordVariant@1003 : Variant;DocNo@1002 : Code[20];DocName@1001 : Text;VendorNo@1000 : Code[20]);
    VAR
      TempReportSelections@1009 : TEMPORARY Record 77;
      ElectronicDocumentFormat@1008 : Record 61;
      FileManagement@1007 : Codeunit 419;
      ServerAttachmentFilePath@1006 : Text[250];
      ClientAttachmentFileName@1005 : Text;
    BEGIN
      OnBeforeSetReportLayout(RecordVariant);
      FindPrintUsageVendor(ReportUsage,VendorNo,TempReportSelections);
      WITH TempReportSelections DO
        REPEAT
          ServerAttachmentFilePath := SaveReportAsPDF("Report ID",RecordVariant,"Custom Report Layout Code");
          ClientAttachmentFileName := ElectronicDocumentFormat.GetAttachmentFileName(DocNo,DocName,'pdf');

          FileManagement.DownloadHandler(
            ServerAttachmentFilePath,
            '',
            '',
            FileManagement.GetToFilterText('',ClientAttachmentFileName),
            ClientAttachmentFileName);
        UNTIL NEXT = 0;
    END;

    [Internal]
    PROCEDURE SendToZip@18(ReportUsage@1003 : Integer;RecordVariant@1002 : Variant;DocNo@1001 : Code[20];CustNo@1007 : Code[20];VAR FileManagement@1000 : Codeunit 419);
    VAR
      TempReportSelections@1006 : TEMPORARY Record 77;
      ElectronicDocumentFormat@1005 : Record 61;
      ServerAttachmentFilePath@1004 : Text;
    BEGIN
      OnBeforeSetReportLayout(RecordVariant);
      FindPrintUsage(ReportUsage,CustNo,TempReportSelections);
      WITH TempReportSelections DO
        REPEAT
          ServerAttachmentFilePath := SaveReportAsPDF("Report ID",RecordVariant,"Custom Report Layout Code");
          FileManagement.AddFileToZipArchive(
            ServerAttachmentFilePath,
            ElectronicDocumentFormat.GetAttachmentFileName(DocNo,'Invoice','pdf'));
        UNTIL NEXT = 0;
    END;

    [Internal]
    PROCEDURE SendToZipVendor@47(ReportUsage@1004 : Integer;RecordVariant@1003 : Variant;DocNo@1002 : Code[20];VendorNo@1001 : Code[20];VAR FileManagement@1000 : Codeunit 419);
    VAR
      TempReportSelections@1007 : TEMPORARY Record 77;
      ElectronicDocumentFormat@1006 : Record 61;
      ServerAttachmentFilePath@1005 : Text;
    BEGIN
      OnBeforeSetReportLayout(RecordVariant);
      FindPrintUsageVendor(ReportUsage,VendorNo,TempReportSelections);
      WITH TempReportSelections DO
        REPEAT
          ServerAttachmentFilePath := SaveReportAsPDF("Report ID",RecordVariant,"Custom Report Layout Code");
          FileManagement.AddFileToZipArchive(
            ServerAttachmentFilePath,
            ElectronicDocumentFormat.GetAttachmentFileName(DocNo,'Purchase Order','pdf'));
        UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE GetDocumentEmailAddress@58(DocumentNo@1000 : Code[20];ReportUsage@1004 : Integer) : Text[250];
    VAR
      EmailParameter@1002 : Record 9510;
      ToAddress@1001 : Text;
    BEGIN
      IF EmailParameter.GetEntryWithReportUsage(DocumentNo,ReportUsage,EmailParameter."Parameter Type"::Address) THEN
        ToAddress := EmailParameter.GetParameterValue;
      EXIT(ToAddress);
    END;

    [External]
    PROCEDURE GetCustEmailAddress@16(BillToCustomerNo@1000 : Code[20]) : Text[250];
    VAR
      Customer@1002 : Record 18;
      Contact@1003 : Record 5050;
      ToAddress@1001 : Text;
      IsHandled@1004 : Boolean;
    BEGIN
      OnBeforeGetCustEmailAddress(BillToCustomerNo,ToAddress,IsHandled);
      IF IsHandled THEN
        EXIT(ToAddress);

      IF Customer.GET(BillToCustomerNo) THEN
        ToAddress := Customer."E-Mail"
      ELSE
        IF Contact.GET(BillToCustomerNo) THEN
          ToAddress := Contact."E-Mail";
      EXIT(ToAddress);
    END;

    [External]
    PROCEDURE GetVendorEmailAddress@35(BuyFromVendorNo@1000 : Code[20];RecVar@1004 : Variant;ReportUsage@1005 : Option) : Text[250];
    VAR
      Vendor@1002 : Record 23;
      ToAddress@1001 : Text[250];
      IsHandled@1003 : Boolean;
    BEGIN
      OnBeforeGetVendorEmailAddress(BuyFromVendorNo,ToAddress,IsHandled);
      IF IsHandled THEN
        EXIT(ToAddress);

      ToAddress := GetPurchaseOrderEmailAddress(BuyFromVendorNo,RecVar,ReportUsage);

      IF ToAddress = '' THEN
        IF Vendor.GET(BuyFromVendorNo) THEN
          ToAddress := Vendor."E-Mail";

      EXIT(ToAddress);
    END;

    LOCAL PROCEDURE GetPurchaseOrderEmailAddress@71(BuyFromVendorNo@1002 : Code[20];RecVar@1001 : Variant;ReportUsage@1000 : Option) : Text[250];
    VAR
      PurchaseHeader@1005 : Record 38;
      OrderAddress@1004 : Record 224;
      RecRef@1003 : RecordRef;
    BEGIN
      IF BuyFromVendorNo = '' THEN
        EXIT('');

      IF ReportUsage <> Usage::"P.Order" THEN
        EXIT('');

      RecRef.GETTABLE(RecVar);
      IF RecRef.NUMBER <> DATABASE::"Purchase Header" THEN
        EXIT('');

      PurchaseHeader := RecVar;
      IF PurchaseHeader."Order Address Code" = '' THEN
        EXIT('');

      IF NOT OrderAddress.GET(BuyFromVendorNo,PurchaseHeader."Order Address Code") THEN
        EXIT('');

      EXIT(OrderAddress."E-Mail");
    END;

    LOCAL PROCEDURE SaveReportAsPDF@14(ReportID@1000 : Integer;RecordVariant@1002 : Variant;LayoutCode@1003 : Code[20]) FilePath : Text[250];
    VAR
      ReportLayoutSelection@1004 : Record 9651;
      FileMgt@1001 : Codeunit 419;
    BEGIN
      OnBeforeSetReportLayout(RecordVariant);
      FilePath := COPYSTR(FileMgt.ServerTempFileName('pdf'),1,250);

      ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
      REPORT.SAVEASPDF(ReportID,FilePath,RecordVariant);
      ReportLayoutSelection.SetTempLayoutSelected('');

      COMMIT;
    END;

    LOCAL PROCEDURE SaveReportAsHTML@15(ReportID@1003 : Integer;RecordVariant@1002 : Variant;LayoutCode@1004 : Code[20]) FilePath : Text[250];
    VAR
      ReportLayoutSelection@1000 : Record 9651;
      FileMgt@1001 : Codeunit 419;
    BEGIN
      OnBeforeSetReportLayout(RecordVariant);
      FilePath := COPYSTR(FileMgt.ServerTempFileName('html'),1,250);

      ReportLayoutSelection.SetTempLayoutSelected(LayoutCode);
      REPORT.SAVEASHTML(ReportID,FilePath,RecordVariant);
      ReportLayoutSelection.SetTempLayoutSelected('');

      COMMIT;
    END;

    LOCAL PROCEDURE FindReportSelections@38(VAR ReportSelections@1000 : Record 77;AccountNo@1001 : Code[20];TableNo@1003 : Integer) : Boolean;
    VAR
      Handled@1002 : Boolean;
    BEGIN
      IF CopyCustomReportSectionToReportSelection(AccountNo,ReportSelections,TableNo) THEN
        EXIT(TRUE);

      OnFindReportSelections(ReportSelections,Handled,Rec);
      IF Handled THEN
        EXIT(TRUE);

      EXIT(CopyReportSelectionToReportSelection(ReportSelections));
    END;

    LOCAL PROCEDURE CopyCustomReportSectionToReportSelection@21(AccountNo@1002 : Code[20];VAR ToReportSelections@1001 : Record 77;TableNo@1003 : Integer) : Boolean;
    VAR
      CustomReportSelection@1000 : Record 9657;
    BEGIN
      GetCustomReportSelectionByUsageFilter(CustomReportSelection,AccountNo,GETFILTER(Usage),TableNo);
      CopyToReportSelection(ToReportSelections,CustomReportSelection);

      IF NOT ToReportSelections.FINDSET THEN
        EXIT(FALSE);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CopyToReportSelection@49(VAR ToReportSelections@1000 : Record 77;VAR CustomReportSelection@1002 : Record 9657);
    BEGIN
      ToReportSelections.RESET;
      ToReportSelections.DELETEALL;
      IF CustomReportSelection.FINDSET THEN
        REPEAT
          ToReportSelections.Usage := CustomReportSelection.Usage;
          ToReportSelections.Sequence := FORMAT(CustomReportSelection.Sequence);
          ToReportSelections."Report ID" := CustomReportSelection."Report ID";
          ToReportSelections."Custom Report Layout Code" := CustomReportSelection."Custom Report Layout Code";
          ToReportSelections."Email Body Layout Code" := CustomReportSelection."Email Body Layout Code";
          ToReportSelections."Use for Email Attachment" := CustomReportSelection."Use for Email Attachment";
          ToReportSelections."Use for Email Body" := CustomReportSelection."Use for Email Body";
          ToReportSelections.INSERT;
        UNTIL CustomReportSelection.NEXT = 0;
    END;

    LOCAL PROCEDURE CopyReportSelectionToReportSelection@22(VAR ToReportSelections@1000 : Record 77) : Boolean;
    BEGIN
      ToReportSelections.RESET;
      ToReportSelections.DELETEALL;
      IF FINDSET THEN
        REPEAT
          ToReportSelections := Rec;
          IF ToReportSelections.INSERT THEN;
        UNTIL NEXT = 0;

      EXIT(ToReportSelections.FINDSET);
    END;

    LOCAL PROCEDURE GetCustomReportSelection@23(VAR CustomReportSelection@1000 : Record 9657;AccountNo@1001 : Code[20];TableNo@1002 : Integer) : Boolean;
    BEGIN
      CustomReportSelection.SETRANGE("Source Type",TableNo);
      CustomReportSelection.SETFILTER("Source No.",AccountNo);
      IF CustomReportSelection.ISEMPTY THEN
        EXIT(FALSE);

      CustomReportSelection.SETFILTER("Use for Email Attachment",GETFILTER("Use for Email Attachment"));
      CustomReportSelection.SETFILTER("Use for Email Body",GETFILTER("Use for Email Body"));
    END;

    LOCAL PROCEDURE GetCustomReportSelectionByUsageFilter@24(VAR CustomReportSelection@1002 : Record 9657;AccountNo@1001 : Code[20];ReportUsageFilter@1000 : Text;TableNo@1003 : Integer) : Boolean;
    BEGIN
      CustomReportSelection.SETFILTER(Usage,ReportUsageFilter);
      EXIT(GetCustomReportSelection(CustomReportSelection,AccountNo,TableNo));
    END;

    LOCAL PROCEDURE GetCustomReportSelectionByUsageOption@25(VAR CustomReportSelection@1002 : Record 9657;AccountNo@1001 : Code[20];ReportUsage@1000 : Integer;TableNo@1003 : Integer) : Boolean;
    BEGIN
      CustomReportSelection.SETRANGE(Usage,ReportUsage);
      EXIT(GetCustomReportSelection(CustomReportSelection,AccountNo,TableNo));
    END;

    LOCAL PROCEDURE GetNextEmailAddressFromCustomReportSelection@54(VAR CustomReportSelection@1001 : Record 9657;DefaultEmailAddress@1000 : Text;UsageValue@1002 : Option;SequenceText@1003 : Text) : Text;
    VAR
      SequenceInteger@1004 : Integer;
    BEGIN
      IF EVALUATE(SequenceInteger,SequenceText) THEN BEGIN
        CustomReportSelection.SETRANGE(Usage,UsageValue);
        CustomReportSelection.SETRANGE(Sequence,SequenceInteger);
        IF CustomReportSelection.FINDFIRST THEN
          IF CustomReportSelection."Send To Email" <> '' THEN
            EXIT(CustomReportSelection."Send To Email");
      END;
      EXIT(DefaultEmailAddress);
    END;

    LOCAL PROCEDURE GetUniqueAccountNos@62(VAR TempNameValueBuffer@1001 : TEMPORARY Record 823;RecRef@1002 : RecordRef;AccountNoFieldNo@1004 : Integer);
    VAR
      TempCustomer@1003 : TEMPORARY Record 18;
      AccountNoFieldRef@1005 : FieldRef;
    BEGIN
      IF AccountNoFieldNo <> 0 THEN BEGIN
        AccountNoFieldRef := RecRef.FIELD(AccountNoFieldNo);
        IF RecRef.FINDSET THEN
          REPEAT
            TempNameValueBuffer.ID += 1;
            TempNameValueBuffer.Name := AccountNoFieldRef.VALUE;
            TempCustomer."No." := AccountNoFieldRef.VALUE; // to avoid duplicate No. insertion into Name/Value buffer
            IF TempCustomer.INSERT THEN
              TempNameValueBuffer.INSERT;
          UNTIL RecRef.NEXT = 0;
      END ELSE BEGIN
        TempNameValueBuffer.INIT;
        TempNameValueBuffer.INSERT;
      END;
    END;

    [External]
    PROCEDURE PrintForUsage@26(ReportUsage@1000 : Integer);
    VAR
      Handled@1001 : Boolean;
    BEGIN
      OnBeforePrintForUsage(ReportUsage,Handled);
      IF Handled THEN
        EXIT;

      FilterPrintUsage(ReportUsage);
      IF FINDSET THEN
        REPEAT
          REPORT.RUNMODAL("Report ID",TRUE);
        UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE FindEmailAddressForEmailLayout@27(LayoutCode@1002 : Code[20];AccountNo@1001 : Code[20];ReportUsage@1000 : Integer;TableNo@1004 : Integer) : Text[200];
    VAR
      CustomReportSelection@1003 : Record 9657;
    BEGIN
      // Search for a potential email address from Custom Report Selections
      GetCustomReportSelectionByUsageOption(CustomReportSelection,AccountNo,ReportUsage,TableNo);
      CustomReportSelection.SETFILTER("Send To Email",'<>%1','');
      CustomReportSelection.SETRANGE("Email Body Layout Code",LayoutCode);
      IF CustomReportSelection.FINDFIRST THEN
        EXIT(CustomReportSelection."Send To Email");

      // Relax the filter and search for an email address
      CustomReportSelection.SETFILTER("Use for Email Body",'');
      CustomReportSelection.SETRANGE("Email Body Layout Code",'');
      IF CustomReportSelection.FINDFIRST THEN
        EXIT(CustomReportSelection."Send To Email");
      EXIT('');
    END;

    LOCAL PROCEDURE ShowNoBodyNoAttachmentError@51(ReportUsage@1000 : Integer;FoundBody@1001 : Boolean;FoundAttachment@1002 : Boolean);
    BEGIN
      IF NOT (FoundBody OR FoundAttachment) THEN BEGIN
        Usage := ReportUsage;
        ERROR(MustSelectAndEmailBodyOrAttahmentErr,Usage);
      END;
    END;

    PROCEDURE ReportUsageToDocumentType@53(VAR DocumentType@1001 : Option;ReportUsage@1000 : Integer) : Boolean;
    VAR
      SalesHeader@1002 : Record 36;
    BEGIN
      CASE ReportUsage OF
        Usage::"S.Invoice",Usage::"S.Invoice Draft",Usage::"P.Invoice":
          DocumentType := SalesHeader."Document Type"::Invoice;
        Usage::"S.Quote",Usage::"P.Quote":
          DocumentType := SalesHeader."Document Type"::Quote;
        Usage::"S.Cr.Memo",Usage::"P.Cr.Memo":
          DocumentType := SalesHeader."Document Type"::"Credit Memo";
        Usage::"S.Order",Usage::"P.Order":
          DocumentType := SalesHeader."Document Type"::Order;
        ELSE
          EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE SendEmailInForeground@55(DocRecordID@1007 : RecordID;DocNo@1008 : Code[20];DocName@1009 : Text[150];ReportUsage@1010 : Integer;SourceIsCustomer@1011 : Boolean;SourceNo@1001 : Code[20]) : Boolean;
    VAR
      RecRef@1000 : RecordRef;
    BEGIN
      // Blocks the user until the email is sent; use SendEmailInBackground for normal purposes.

      IF NOT RecRef.GET(DocRecordID) THEN
        EXIT(FALSE);

      RecRef.LOCKTABLE;
      RecRef.FIND;
      RecRef.SETRECFILTER;

      IF SourceIsCustomer THEN
        EXIT(SendEmailToCustDirectly(ReportUsage,RecRef,DocNo,DocName,FALSE,SourceNo));

      EXIT(SendEmailToVendorDirectly(ReportUsage,RecRef,DocNo,DocName,FALSE,SourceNo));
    END;

    LOCAL PROCEDURE RecordsCanBeSent@41(RecRef@1000 : RecordRef) : Boolean;
    BEGIN
      IF RecRef.COUNT > 1 THEN
        EXIT(CONFIRM(OneRecordWillBeSentQst));

      EXIT(TRUE);
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeGetCustEmailAddress@57(BillToCustomerNo@1000 : Code[20];VAR ToAddress@1001 : Text;VAR IsHandled@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeGetVendorEmailAddress@59(BuyFromVendorNo@1000 : Code[20];VAR ToAddress@1001 : Text;VAR IsHandled@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePrint@77(ReportUsage@1002 : Integer;RecordVariant@1001 : Variant;CustomerNoFieldNo@1000 : Integer;VAR Handled@1003 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePrintForUsage@69(VAR ReportUsage@1000 : Integer;VAR IsHandled@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePrintWithCheck@43(ReportUsage@1002 : Integer;RecordVariant@1001 : Variant;CustomerNoFieldNo@1000 : Integer;VAR Handled@1003 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePrintWithGUIYesNoWithCheck@64(ReportUsage@1003 : Integer;RecordVariant@1002 : Variant;IsGUI@1001 : Boolean;CustomerNoFieldNo@1000 : Integer;VAR Handled@1004 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePrintWithGUIYesNoWithCheckVendor@74(ReportUsage@1003 : Integer;RecordVariant@1002 : Variant;IsGUI@1001 : Boolean;VendorNoFieldNo@1000 : Integer;VAR Handled@1004 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePrintWithGUIYesNo@79(ReportUsage@1003 : Integer;RecordVariant@1002 : Variant;IsGUI@1001 : Boolean;CustomerNoFieldNo@1000 : Integer;VAR Handled@1004 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforePrintWithGUIYesNoVendor@83(ReportUsage@1003 : Integer;RecordVariant@1002 : Variant;IsGUI@1001 : Boolean;VendorNoFieldNo@1000 : Integer;VAR Handled@1004 : Boolean);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnBeforeSetReportLayout@61(RecordVariant@1000 : Variant);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeSendEmailToCust@89(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;DocNo@1003 : Code[20];DocName@1002 : Text[150];ShowDialog@1001 : Boolean;CustNo@1000 : Code[20];VAR Handled@1006 : Boolean);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeSendEmailToVendor@92(ReportUsage@1005 : Integer;RecordVariant@1004 : Variant;DocNo@1003 : Code[20];DocName@1002 : Text[150];ShowDialog@1001 : Boolean;VendorNo@1000 : Code[20];VAR Handled@1006 : Boolean);
    BEGIN
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnFindReportSelections@63(VAR FilterReportSelections@1001 : Record 77;VAR IsHandled@1002 : Boolean;VAR ReturnReportSelections@1000 : Record 77);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeGetEmailBodyCustomer@36();
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterGetEmailBodyCustomer@39(CustomerEmailAddress@1000 : Text[250];ServerEmailBodyFilePath@1001 : Text[250]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeGetEmailBodyVendor@68();
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterGetEmailBodyVendor@67(VendorEmailAddress@1001 : Text[250];ServerEmailBodyFilePath@1000 : Text[250]);
    BEGIN
    END;

    LOCAL PROCEDURE GetLastSequenceNo@82(VAR TempReportSelectionsSource@1000 : TEMPORARY Record 77;ReportUsage@1002 : Option) : Code[10];
    VAR
      TempReportSelections@1001 : TEMPORARY Record 77;
    BEGIN
      TempReportSelections.COPY(TempReportSelectionsSource,TRUE);
      TempReportSelections.SETRANGE(Usage,ReportUsage);
      IF TempReportSelections.FINDLAST THEN;
      IF TempReportSelections.Sequence = '' THEN
        TempReportSelections.Sequence := '1';
      EXIT(TempReportSelections.Sequence);
    END;

    LOCAL PROCEDURE HasReportWithUsage@84(VAR TempReportSelectionsSource@1000 : TEMPORARY Record 77;ReportUsage@1002 : Option;ReportID@1003 : Integer) : Boolean;
    VAR
      TempReportSelections@1001 : TEMPORARY Record 77;
    BEGIN
      TempReportSelections.COPY(TempReportSelectionsSource,TRUE);
      TempReportSelections.SETRANGE(Usage,ReportUsage);
      TempReportSelections.SETRANGE("Report ID",ReportID);
      EXIT(TempReportSelections.FINDFIRST);
    END;

    BEGIN
    END.
  }
}

