OBJECT Table 17 G/L Entry
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    OnInsert=BEGIN
               "Last Modified DateTime" := CURRENTDATETIME;
             END;

    OnModify=BEGIN
               "Last Modified DateTime" := CURRENTDATETIME;
             END;

    OnRename=BEGIN
               "Last Modified DateTime" := CURRENTDATETIME;
             END;

    CaptionML=[DAN=Finanspost;
               ENU=G/L Entry];
    LookupPageID=Page20;
    DrillDownPageID=Page20;
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;CaptionML=[DAN=L�benr.;
                                                              ENU=Entry No.] }
    { 3   ;   ;G/L Account No.     ;Code20        ;TableRelation="G/L Account";
                                                   OnValidate=BEGIN
                                                                UpdateAccountID;
                                                              END;

                                                   CaptionML=[DAN=Finanskontonr.;
                                                              ENU=G/L Account No.] }
    { 4   ;   ;Posting Date        ;Date          ;CaptionML=[DAN=Bogf�ringsdato;
                                                              ENU=Posting Date];
                                                   ClosingDates=Yes }
    { 5   ;   ;Document Type       ;Option        ;CaptionML=[DAN=Bilagstype;
                                                              ENU=Document Type];
                                                   OptionCaptionML=[DAN=" ,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion";
                                                                    ENU=" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"];
                                                   OptionString=[ ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund] }
    { 6   ;   ;Document No.        ;Code20        ;OnLookup=VAR
                                                              IncomingDocument@1000 : Record 130;
                                                            BEGIN
                                                              IncomingDocument.HyperlinkToDocument("Document No.","Posting Date");
                                                            END;

                                                   CaptionML=[DAN=Bilagsnr.;
                                                              ENU=Document No.] }
    { 7   ;   ;Description         ;Text50        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 10  ;   ;Bal. Account No.    ;Code20        ;TableRelation=IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                 ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Bal. Account Type=CONST(IC Partner)) "IC Partner"
                                                                 ELSE IF (Bal. Account Type=CONST(Employee)) Employee;
                                                   CaptionML=[DAN=Modkonto;
                                                              ENU=Bal. Account No.] }
    { 17  ;   ;Amount              ;Decimal       ;CaptionML=[DAN=Bel�b;
                                                              ENU=Amount];
                                                   AutoFormatType=1 }
    { 23  ;   ;Global Dimension 1 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
                                                   CaptionML=[DAN=Global dimension 1-kode;
                                                              ENU=Global Dimension 1 Code];
                                                   CaptionClass='1,1,1' }
    { 24  ;   ;Global Dimension 2 Code;Code20     ;TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
                                                   CaptionML=[DAN=Global dimension 2-kode;
                                                              ENU=Global Dimension 2 Code];
                                                   CaptionClass='1,1,2' }
    { 27  ;   ;User ID             ;Code50        ;TableRelation=User."User Name";
                                                   OnLookup=VAR
                                                              UserMgt@1000 : Codeunit 418;
                                                            BEGIN
                                                              UserMgt.LookupUserID("User ID");
                                                            END;

                                                   ValidateTableRelation=No;
                                                   TestTableRelation=No;
                                                   DataClassification=EndUserIdentifiableInformation;
                                                   CaptionML=[DAN=Bruger-id;
                                                              ENU=User ID] }
    { 28  ;   ;Source Code         ;Code10        ;TableRelation="Source Code";
                                                   CaptionML=[DAN=Kildespor;
                                                              ENU=Source Code] }
    { 29  ;   ;System-Created Entry;Boolean       ;CaptionML=[DAN=Automatisk oprettet;
                                                              ENU=System-Created Entry] }
    { 30  ;   ;Prior-Year Entry    ;Boolean       ;CaptionML=[DAN=Efterpost;
                                                              ENU=Prior-Year Entry] }
    { 41  ;   ;Job No.             ;Code20        ;TableRelation=Job;
                                                   CaptionML=[DAN=Sagsnr.;
                                                              ENU=Job No.] }
    { 42  ;   ;Quantity            ;Decimal       ;CaptionML=[DAN=Antal;
                                                              ENU=Quantity];
                                                   DecimalPlaces=0:5 }
    { 43  ;   ;VAT Amount          ;Decimal       ;CaptionML=[DAN=Momsbel�b;
                                                              ENU=VAT Amount];
                                                   AutoFormatType=1 }
    { 45  ;   ;Business Unit Code  ;Code20        ;TableRelation="Business Unit";
                                                   CaptionML=[DAN=Konc.virksomhedskode;
                                                              ENU=Business Unit Code] }
    { 46  ;   ;Journal Batch Name  ;Code10        ;CaptionML=[DAN=Kladdenavn;
                                                              ENU=Journal Batch Name] }
    { 47  ;   ;Reason Code         ;Code10        ;TableRelation="Reason Code";
                                                   CaptionML=[DAN=�rsagskode;
                                                              ENU=Reason Code] }
    { 48  ;   ;Gen. Posting Type   ;Option        ;CaptionML=[DAN=Bogf�ringstype;
                                                              ENU=Gen. Posting Type];
                                                   OptionCaptionML=[DAN=" ,K�b,Salg,Afregning";
                                                                    ENU=" ,Purchase,Sale,Settlement"];
                                                   OptionString=[ ,Purchase,Sale,Settlement] }
    { 49  ;   ;Gen. Bus. Posting Group;Code20     ;TableRelation="Gen. Business Posting Group";
                                                   CaptionML=[DAN=Virksomhedsbogf�ringsgruppe;
                                                              ENU=Gen. Bus. Posting Group] }
    { 50  ;   ;Gen. Prod. Posting Group;Code20    ;TableRelation="Gen. Product Posting Group";
                                                   CaptionML=[DAN=Produktbogf�ringsgruppe;
                                                              ENU=Gen. Prod. Posting Group] }
    { 51  ;   ;Bal. Account Type   ;Option        ;CaptionML=[DAN=Modkontotype;
                                                              ENU=Bal. Account Type];
                                                   OptionCaptionML=[DAN=Finanskonto,Debitor,Kreditor,Bankkonto,Anl�g,IC-partner,Medarbejder;
                                                                    ENU=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee];
                                                   OptionString=G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee }
    { 52  ;   ;Transaction No.     ;Integer       ;CaptionML=[DAN=Transaktionsnr.;
                                                              ENU=Transaction No.] }
    { 53  ;   ;Debit Amount        ;Decimal       ;CaptionML=[DAN=Debetbel�b;
                                                              ENU=Debit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 54  ;   ;Credit Amount       ;Decimal       ;CaptionML=[DAN=Kreditbel�b;
                                                              ENU=Credit Amount];
                                                   BlankZero=Yes;
                                                   AutoFormatType=1 }
    { 55  ;   ;Document Date       ;Date          ;CaptionML=[DAN=Bilagsdato;
                                                              ENU=Document Date];
                                                   ClosingDates=Yes }
    { 56  ;   ;External Document No.;Code35       ;CaptionML=[DAN=Eksternt bilagsnr.;
                                                              ENU=External Document No.] }
    { 57  ;   ;Source Type         ;Option        ;CaptionML=[DAN=Kildetype;
                                                              ENU=Source Type];
                                                   OptionCaptionML=[DAN=" ,Debitor,Kreditor,Bankkonto,Anl�g,Medarbejder";
                                                                    ENU=" ,Customer,Vendor,Bank Account,Fixed Asset,Employee"];
                                                   OptionString=[ ,Customer,Vendor,Bank Account,Fixed Asset,Employee] }
    { 58  ;   ;Source No.          ;Code20        ;TableRelation=IF (Source Type=CONST(Customer)) Customer
                                                                 ELSE IF (Source Type=CONST(Vendor)) Vendor
                                                                 ELSE IF (Source Type=CONST(Bank Account)) "Bank Account"
                                                                 ELSE IF (Source Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                 ELSE IF (Source Type=CONST(Employee)) Employee;
                                                   CaptionML=[DAN=Kildenr.;
                                                              ENU=Source No.] }
    { 59  ;   ;No. Series          ;Code20        ;TableRelation="No. Series";
                                                   CaptionML=[DAN=Nummerserie;
                                                              ENU=No. Series] }
    { 60  ;   ;Tax Area Code       ;Code20        ;TableRelation="Tax Area";
                                                   CaptionML=[DAN=Skatteomr�dekode;
                                                              ENU=Tax Area Code] }
    { 61  ;   ;Tax Liable          ;Boolean       ;CaptionML=[DAN=Skattepligtig;
                                                              ENU=Tax Liable] }
    { 62  ;   ;Tax Group Code      ;Code20        ;TableRelation="Tax Group";
                                                   CaptionML=[DAN=Skattegruppekode;
                                                              ENU=Tax Group Code] }
    { 63  ;   ;Use Tax             ;Boolean       ;CaptionML=[DAN=Use Tax;
                                                              ENU=Use Tax] }
    { 64  ;   ;VAT Bus. Posting Group;Code20      ;TableRelation="VAT Business Posting Group";
                                                   CaptionML=[DAN=Momsvirksomhedsbogf.gruppe;
                                                              ENU=VAT Bus. Posting Group] }
    { 65  ;   ;VAT Prod. Posting Group;Code20     ;TableRelation="VAT Product Posting Group";
                                                   CaptionML=[DAN=Momsproduktbogf.gruppe;
                                                              ENU=VAT Prod. Posting Group] }
    { 68  ;   ;Additional-Currency Amount;Decimal ;AccessByPermission=TableData 4=R;
                                                   CaptionML=[DAN=Ekstra valuta (bel�b);
                                                              ENU=Additional-Currency Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 69  ;   ;Add.-Currency Debit Amount;Decimal ;CaptionML=[DAN=Debetbel�b i ekstra valuta;
                                                              ENU=Add.-Currency Debit Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 70  ;   ;Add.-Currency Credit Amount;Decimal;CaptionML=[DAN=Kreditbel�b i ekstra valuta;
                                                              ENU=Add.-Currency Credit Amount];
                                                   AutoFormatType=1;
                                                   AutoFormatExpr=GetCurrencyCode }
    { 71  ;   ;Close Income Statement Dim. ID;Integer;
                                                   CaptionML=[DAN=Dim.-id for nulstil res.opg�relse;
                                                              ENU=Close Income Statement Dim. ID] }
    { 72  ;   ;IC Partner Code     ;Code20        ;TableRelation="IC Partner";
                                                   CaptionML=[DAN=IC-partner kode;
                                                              ENU=IC Partner Code] }
    { 73  ;   ;Reversed            ;Boolean       ;CaptionML=[DAN=Tilbagef�rt;
                                                              ENU=Reversed] }
    { 74  ;   ;Reversed by Entry No.;Integer      ;TableRelation="G/L Entry";
                                                   CaptionML=[DAN=Tilbagef�rt af l�benr.;
                                                              ENU=Reversed by Entry No.];
                                                   BlankZero=Yes }
    { 75  ;   ;Reversed Entry No.  ;Integer       ;TableRelation="G/L Entry";
                                                   CaptionML=[DAN=Tilbagef�rt l�benr.;
                                                              ENU=Reversed Entry No.];
                                                   BlankZero=Yes }
    { 76  ;   ;G/L Account Name    ;Text50        ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("G/L Account".Name WHERE (No.=FIELD(G/L Account No.)));
                                                   CaptionML=[DAN=Finanskontonavn;
                                                              ENU=G/L Account Name];
                                                   Editable=No }
    { 480 ;   ;Dimension Set ID    ;Integer       ;TableRelation="Dimension Set Entry";
                                                   OnLookup=BEGIN
                                                              ShowDimensions;
                                                            END;

                                                   CaptionML=[DAN=Dimensionsgruppe-id;
                                                              ENU=Dimension Set ID];
                                                   Editable=No }
    { 5400;   ;Prod. Order No.     ;Code20        ;CaptionML=[DAN=Prod.ordrenr.;
                                                              ENU=Prod. Order No.] }
    { 5600;   ;FA Entry Type       ;Option        ;AccessByPermission=TableData 5600=R;
                                                   CaptionML=[DAN=Anl�gstype;
                                                              ENU=FA Entry Type];
                                                   OptionCaptionML=[DAN=" ,Anl�g,Reparation";
                                                                    ENU=" ,Fixed Asset,Maintenance"];
                                                   OptionString=[ ,Fixed Asset,Maintenance] }
    { 5601;   ;FA Entry No.        ;Integer       ;TableRelation=IF (FA Entry Type=CONST(Fixed Asset)) "FA Ledger Entry"
                                                                 ELSE IF (FA Entry Type=CONST(Maintenance)) "Maintenance Ledger Entry";
                                                   CaptionML=[DAN=Anl�gsl�benr.;
                                                              ENU=FA Entry No.];
                                                   BlankZero=Yes }
    { 8001;   ;Account Id          ;GUID          ;FieldClass=FlowField;
                                                   CalcFormula=Lookup("G/L Account".Id WHERE (No.=FIELD(G/L Account No.)));
                                                   TableRelation="G/L Account".Id;
                                                   OnValidate=BEGIN
                                                                UpdateAccountNo;
                                                              END;

                                                   CaptionML=[DAN=Konto-id;
                                                              ENU=Account Id] }
    { 8005;   ;Last Modified DateTime;DateTime    ;CaptionML=[DAN=Senest �ndrede DateTime;
                                                              ENU=Last Modified DateTime];
                                                   Editable=No }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;G/L Account No.,Posting Date            ;SumIndexFields=Amount,Debit Amount,Credit Amount,Additional-Currency Amount,Add.-Currency Debit Amount,Add.-Currency Credit Amount }
    {    ;G/L Account No.,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date;
                                                   SumIndexFields=Amount,Debit Amount,Credit Amount,Additional-Currency Amount,Add.-Currency Debit Amount,Add.-Currency Credit Amount }
    { No ;G/L Account No.,Business Unit Code,Posting Date;
                                                   SumIndexFields=Amount,Debit Amount,Credit Amount,Additional-Currency Amount,Add.-Currency Debit Amount,Add.-Currency Credit Amount }
    { No ;G/L Account No.,Business Unit Code,Global Dimension 1 Code,Global Dimension 2 Code,Posting Date;
                                                   SumIndexFields=Amount,Debit Amount,Credit Amount,Additional-Currency Amount,Add.-Currency Debit Amount,Add.-Currency Credit Amount }
    {    ;Document No.,Posting Date                }
    {    ;Transaction No.                          }
    {    ;IC Partner Code                          }
    {    ;G/L Account No.,Job No.,Posting Date    ;SumIndexFields=Amount }
    {    ;Posting Date,G/L Account No.,Dimension Set ID;
                                                   SumIndexFields=Amount }
  }
  FIELDGROUPS
  {
    { 1   ;DropDown            ;Entry No.,Description,G/L Account No.,Posting Date,Document Type,Document No. }
  }
  CODE
  {
    VAR
      GLSetup@1000 : Record 98;
      GLSetupRead@1002 : Boolean;

    [External]
    PROCEDURE GetCurrencyCode@1() : Code[10];
    BEGIN
      IF NOT GLSetupRead THEN BEGIN
        GLSetup.GET;
        GLSetupRead := TRUE;
      END;
      EXIT(GLSetup."Additional Reporting Currency");
    END;

    [External]
    PROCEDURE ShowValueEntries@8();
    VAR
      GLItemLedgRelation@1000 : Record 5823;
      ValueEntry@1002 : Record 5802;
      TempValueEntry@1001 : TEMPORARY Record 5802;
    BEGIN
      GLItemLedgRelation.SETRANGE("G/L Entry No.","Entry No.");
      IF GLItemLedgRelation.FINDSET THEN
        REPEAT
          ValueEntry.GET(GLItemLedgRelation."Value Entry No.");
          TempValueEntry.INIT;
          TempValueEntry := ValueEntry;
          TempValueEntry.INSERT;
        UNTIL GLItemLedgRelation.NEXT = 0;

      PAGE.RUNMODAL(0,TempValueEntry);
    END;

    [External]
    PROCEDURE ShowDimensions@2();
    VAR
      DimMgt@1000 : Codeunit 408;
    BEGIN
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    END;

    [External]
    PROCEDURE UpdateDebitCredit@3(Correction@1000 : Boolean);
    BEGIN
      IF ((Amount > 0) AND (NOT Correction)) OR
         ((Amount < 0) AND Correction)
      THEN BEGIN
        "Debit Amount" := Amount;
        "Credit Amount" := 0
      END ELSE BEGIN
        "Debit Amount" := 0;
        "Credit Amount" := -Amount;
      END;

      IF (("Additional-Currency Amount" > 0) AND (NOT Correction)) OR
         (("Additional-Currency Amount" < 0) AND Correction)
      THEN BEGIN
        "Add.-Currency Debit Amount" := "Additional-Currency Amount";
        "Add.-Currency Credit Amount" := 0
      END ELSE BEGIN
        "Add.-Currency Debit Amount" := 0;
        "Add.-Currency Credit Amount" := -"Additional-Currency Amount";
      END;
    END;

    [External]
    PROCEDURE CopyFromGenJnlLine@4(GenJnlLine@1000 : Record 81);
    BEGIN
      "Posting Date" := GenJnlLine."Posting Date";
      "Document Date" := GenJnlLine."Document Date";
      "Document Type" := GenJnlLine."Document Type";
      "Document No." := GenJnlLine."Document No.";
      "External Document No." := GenJnlLine."External Document No.";
      Description := GenJnlLine.Description;
      "Business Unit Code" := GenJnlLine."Business Unit Code";
      "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
      "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
      "Dimension Set ID" := GenJnlLine."Dimension Set ID";
      "Source Code" := GenJnlLine."Source Code";
      IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" THEN BEGIN
        IF GenJnlLine."Source Type" = GenJnlLine."Source Type"::Employee THEN
          "Source Type" := "Source Type"::Employee
        ELSE
          "Source Type" := GenJnlLine."Source Type";
        "Source No." := GenJnlLine."Source No.";
      END ELSE BEGIN
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Employee THEN
          "Source Type" := "Source Type"::Employee
        ELSE
          "Source Type" := GenJnlLine."Account Type";
        "Source No." := GenJnlLine."Account No.";
      END;
      IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"IC Partner") OR
         (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"IC Partner")
      THEN
        "Source Type" := "Source Type"::" ";
      "Job No." := GenJnlLine."Job No.";
      Quantity := GenJnlLine.Quantity;
      "Journal Batch Name" := GenJnlLine."Journal Batch Name";
      "Reason Code" := GenJnlLine."Reason Code";
      "User ID" := USERID;
      "No. Series" := GenJnlLine."Posting No. Series";
      "IC Partner Code" := GenJnlLine."IC Partner Code";

      OnAfterCopyGLEntryFromGenJnlLine(Rec,GenJnlLine);
    END;

    [External]
    PROCEDURE CopyPostingGroupsFromGLEntry@5(GLEntry@1000 : Record 17);
    BEGIN
      "Gen. Posting Type" := GLEntry."Gen. Posting Type";
      "Gen. Bus. Posting Group" := GLEntry."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := GLEntry."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := GLEntry."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := GLEntry."VAT Prod. Posting Group";
      "Tax Area Code" := GLEntry."Tax Area Code";
      "Tax Liable" := GLEntry."Tax Liable";
      "Tax Group Code" := GLEntry."Tax Group Code";
      "Use Tax" := GLEntry."Use Tax";
    END;

    [External]
    PROCEDURE CopyPostingGroupsFromVATEntry@96(VATEntry@1001 : Record 254);
    BEGIN
      "Gen. Posting Type" := VATEntry.Type;
      "Gen. Bus. Posting Group" := VATEntry."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := VATEntry."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := VATEntry."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := VATEntry."VAT Prod. Posting Group";
      "Tax Area Code" := VATEntry."Tax Area Code";
      "Tax Liable" := VATEntry."Tax Liable";
      "Tax Group Code" := VATEntry."Tax Group Code";
      "Use Tax" := VATEntry."Use Tax";
    END;

    [External]
    PROCEDURE CopyPostingGroupsFromGenJnlLine@19(GenJnlLine@1000 : Record 81);
    BEGIN
      "Gen. Posting Type" := GenJnlLine."Gen. Posting Type";
      "Gen. Bus. Posting Group" := GenJnlLine."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := GenJnlLine."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := GenJnlLine."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := GenJnlLine."VAT Prod. Posting Group";
      "Tax Area Code" := GenJnlLine."Tax Area Code";
      "Tax Liable" := GenJnlLine."Tax Liable";
      "Tax Group Code" := GenJnlLine."Tax Group Code";
      "Use Tax" := GenJnlLine."Use Tax";
    END;

    [External]
    PROCEDURE CopyPostingGroupsFromDtldCVBuf@94(DtldCVLedgEntryBuf@1001 : Record 383;GenPostingType@1002 : ' ,Purchase,Sale,Settlement');
    BEGIN
      "Gen. Posting Type" := GenPostingType;
      "Gen. Bus. Posting Group" := DtldCVLedgEntryBuf."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := DtldCVLedgEntryBuf."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := DtldCVLedgEntryBuf."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := DtldCVLedgEntryBuf."VAT Prod. Posting Group";
      "Tax Area Code" := DtldCVLedgEntryBuf."Tax Area Code";
      "Tax Liable" := DtldCVLedgEntryBuf."Tax Liable";
      "Tax Group Code" := DtldCVLedgEntryBuf."Tax Group Code";
      "Use Tax" := DtldCVLedgEntryBuf."Use Tax";
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterCopyGLEntryFromGenJnlLine@6(VAR GLEntry@1000 : Record 17;VAR GenJournalLine@1001 : Record 81);
    BEGIN
    END;

    [External]
    PROCEDURE CopyFromDeferralPostBuffer@46(DeferralPostBuffer@1001 : Record 1703);
    BEGIN
      "System-Created Entry" := DeferralPostBuffer."System-Created Entry";
      "Gen. Posting Type" := DeferralPostBuffer."Gen. Posting Type";
      "Gen. Bus. Posting Group" := DeferralPostBuffer."Gen. Bus. Posting Group";
      "Gen. Prod. Posting Group" := DeferralPostBuffer."Gen. Prod. Posting Group";
      "VAT Bus. Posting Group" := DeferralPostBuffer."VAT Bus. Posting Group";
      "VAT Prod. Posting Group" := DeferralPostBuffer."VAT Prod. Posting Group";
      "Tax Area Code" := DeferralPostBuffer."Tax Area Code";
      "Tax Liable" := DeferralPostBuffer."Tax Liable";
      "Tax Group Code" := DeferralPostBuffer."Tax Group Code";
      "Use Tax" := DeferralPostBuffer."Use Tax";
    END;

    PROCEDURE UpdateAccountID@1166();
    VAR
      GLAccount@1000 : Record 15;
    BEGIN
      IF "G/L Account No." = '' THEN BEGIN
        CLEAR("Account Id");
        EXIT;
      END;

      IF NOT GLAccount.GET("G/L Account No.") THEN
        EXIT;

      "Account Id" := GLAccount.Id;
    END;

    LOCAL PROCEDURE UpdateAccountNo@1164();
    VAR
      GLAccount@1001 : Record 15;
    BEGIN
      IF ISNULLGUID("Account Id") THEN
        EXIT;

      GLAccount.SETRANGE(Id,"Account Id");
      IF NOT GLAccount.FINDFIRST THEN
        EXIT;

      "G/L Account No." := GLAccount."No.";
    END;

    BEGIN
    END.
  }
}
