OBJECT Table 570 G/L Account Category
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    DataCaptionFields=Description;
    OnDelete=VAR
               GLAccount@1000 : Record 15;
             BEGIN
               IF "System Generated" THEN
                 ERROR(CannotDeleteSystemGeneratedErr,Description);
               GLAccount.SETRANGE("Account Subcategory Entry No.","Entry No.");
               IF GLAccount.FINDFIRST THEN
                 ERROR(CategoryUsedOnAccountErr,TABLECAPTION,Description,GLAccount.TABLECAPTION,GLAccount."No.");
               DeleteChildren("Entry No.");
             END;

    CaptionML=[DAN=Finanskontokategori;
               ENU=G/L Account Category];
  }
  FIELDS
  {
    { 1   ;   ;Entry No.           ;Integer       ;AutoIncrement=Yes;
                                                   CaptionML=[DAN=L�benummer;
                                                              ENU=Entry No.] }
    { 2   ;   ;Parent Entry No.    ;Integer       ;CaptionML=[DAN=Overordnet posteringsnr.;
                                                              ENU=Parent Entry No.] }
    { 3   ;   ;Sibling Sequence No.;Integer       ;CaptionML=[DAN=Sidestillet r�kkef�lgenr.;
                                                              ENU=Sibling Sequence No.] }
    { 4   ;   ;Presentation Order  ;Text100       ;CaptionML=[DAN=Pr�sentationsr�kkef�lge;
                                                              ENU=Presentation Order] }
    { 5   ;   ;Indentation         ;Integer       ;CaptionML=[DAN=Indrykning;
                                                              ENU=Indentation] }
    { 6   ;   ;Description         ;Text80        ;CaptionML=[DAN=Beskrivelse;
                                                              ENU=Description] }
    { 7   ;   ;Account Category    ;Option        ;OnValidate=BEGIN
                                                                IF "Account Category" IN ["Account Category"::Income,"Account Category"::"Cost of Goods Sold","Account Category"::Expense]
                                                                THEN BEGIN
                                                                  "Income/Balance" := "Income/Balance"::"Income Statement";
                                                                  "Additional Report Definition" := "Additional Report Definition"::" ";
                                                                END ELSE
                                                                  "Income/Balance" := "Income/Balance"::"Balance Sheet";
                                                                IF Description = '' THEN
                                                                  Description := FORMAT("Account Category");
                                                                UpdatePresentationOrder;
                                                              END;

                                                   CaptionML=[DAN=Kontokategori;
                                                              ENU=Account Category];
                                                   OptionCaptionML=[DAN=,Aktiver,G�ld,Egenkapital,Indt�gter,Kostpris,Udgifter;
                                                                    ENU=,Assets,Liabilities,Equity,Income,Cost of Goods Sold,Expense];
                                                   OptionString=,Assets,Liabilities,Equity,Income,Cost of Goods Sold,Expense;
                                                   BlankZero=Yes }
    { 8   ;   ;Income/Balance      ;Option        ;OnValidate=BEGIN
                                                                UpdatePresentationOrder;
                                                              END;

                                                   CaptionML=[DAN=Indt�gter/saldo;
                                                              ENU=Income/Balance];
                                                   OptionCaptionML=[DAN=Resultatopg�relse,Balance;
                                                                    ENU=Income Statement,Balance Sheet];
                                                   OptionString=Income Statement,Balance Sheet;
                                                   Editable=No }
    { 9   ;   ;Additional Report Definition;Option;OnValidate=BEGIN
                                                                IF "Additional Report Definition" <> "Additional Report Definition"::" " THEN
                                                                  TESTFIELD("Income/Balance","Income/Balance"::"Balance Sheet");
                                                              END;

                                                   CaptionML=[DAN=Ekstra rapportdefinition;
                                                              ENU=Additional Report Definition];
                                                   OptionCaptionML=[DAN=,Driftsaktiviteter,Investeringsaktiviteter,Finansieringsaktviteter,Kassekonti,Overf�rt resultat,Uddeling til aktion�rer;
                                                                    ENU=" ,Operating Activities,Investing Activities,Financing Activities,Cash Accounts,Retained Earnings,Distribution to Shareholders"];
                                                   OptionString=[ ,Operating Activities,Investing Activities,Financing Activities,Cash Accounts,Retained Earnings,Distribution to Shareholders] }
    { 11  ;   ;System Generated    ;Boolean       ;CaptionML=[DAN=Systemgenereret;
                                                              ENU=System Generated] }
    { 12  ;   ;Has Children        ;Boolean       ;FieldClass=FlowField;
                                                   CalcFormula=Exist("G/L Account Category" WHERE (Parent Entry No.=FIELD(Entry No.)));
                                                   CaptionML=[DAN=Har b�rn;
                                                              ENU=Has Children] }
  }
  KEYS
  {
    {    ;Entry No.                               ;Clustered=Yes }
    {    ;Presentation Order,Sibling Sequence No.  }
  }
  FIELDGROUPS
  {
  }
  CODE
  {
    VAR
      NewCategoryTxt@1001 : TextConst 'DAN=<Angiv et navn>;ENU=<Enter a Name>';
      CannotDeleteSystemGeneratedErr@1019 : TextConst '@@@="%1 = a category value, e.g. ""Assets""";DAN=%1 er en systemgenereret kategori og kan ikke slettes.;ENU=%1 is a system generated category and cannot be deleted.';
      NoAccountsInFilterErr@1002 : TextConst '@@@="%1 = either ''Balance Sheet'' or ''Income Statement''";DAN=Der er ingen finanskonti i filtertypen for %1.;ENU=There are no G/L Accounts in the filter of type %1.';
      CategoryUsedOnAccountErr@1003 : TextConst '@@@="%1=account category table name, %2=category description, %3=g/l account table name, %4=g/l account number.";DAN=Du kan ikke slette %1 %2, fordi den bruges i %3 %4 .;ENU=You cannot delete %1 %2 because it is used in %3 %4.';

    [External]
    PROCEDURE UpdatePresentationOrder@4();
    VAR
      GLAccountCategory@1000 : Record 570;
      PresentationOrder@1001 : Text;
    BEGIN
      IF "Entry No." = 0 THEN
        EXIT;
      GLAccountCategory := Rec;
      IF "Sibling Sequence No." = 0 THEN
        "Sibling Sequence No." := "Entry No." * 10000 MOD 2000000000;
      Indentation := 0;
      PresentationOrder := COPYSTR(FORMAT(1000000 + "Sibling Sequence No."),2);
      WHILE GLAccountCategory."Parent Entry No." <> 0 DO BEGIN
        Indentation += 1;
        GLAccountCategory.GET(GLAccountCategory."Parent Entry No.");
        PresentationOrder := COPYSTR(FORMAT(1000000 + GLAccountCategory."Sibling Sequence No."),2) + PresentationOrder;
      END;
      CASE "Account Category" OF
        "Account Category"::Assets:
          PresentationOrder := '0' + PresentationOrder;
        "Account Category"::Liabilities:
          PresentationOrder := '1' + PresentationOrder;
        "Account Category"::Equity:
          PresentationOrder := '2' + PresentationOrder;
        "Account Category"::Income:
          PresentationOrder := '3' + PresentationOrder;
        "Account Category"::"Cost of Goods Sold":
          PresentationOrder := '4' + PresentationOrder;
        "Account Category"::Expense:
          PresentationOrder := '5' + PresentationOrder;
      END;
      "Presentation Order" := COPYSTR(PresentationOrder,1,MAXSTRLEN("Presentation Order"));
      MODIFY;
    END;

    [External]
    PROCEDURE InitializeDataSet@1();
    BEGIN
      CODEUNIT.RUN(CODEUNIT::"G/L Account Category Mgt.");
    END;

    [External]
    PROCEDURE InsertRow@6() : Integer;
    VAR
      GLAccountCategoryMgt@1000 : Codeunit 570;
    BEGIN
      EXIT(GLAccountCategoryMgt.AddCategory("Entry No.","Parent Entry No.","Account Category",NewCategoryTxt,FALSE,0));
    END;

    LOCAL PROCEDURE Move@13(Steps@1002 : Integer);
    VAR
      GLAccountCategory@1000 : Record 570;
      SiblingOrder@1001 : Integer;
    BEGIN
      IF "Entry No." = 0 THEN
        EXIT;
      GLAccountCategory := Rec;
      GLAccountCategory.SETRANGE("Parent Entry No.","Parent Entry No.");
      GLAccountCategory.SETRANGE("Account Category","Account Category");
      GLAccountCategory.SETCURRENTKEY("Presentation Order","Sibling Sequence No.");
      IF GLAccountCategory.NEXT(Steps) = 0 THEN
        EXIT;
      SiblingOrder := "Sibling Sequence No.";
      "Sibling Sequence No." := GLAccountCategory."Sibling Sequence No.";
      GLAccountCategory."Sibling Sequence No." := SiblingOrder;
      GLAccountCategory.UpdatePresentationOrder;
      GLAccountCategory.MODIFY;
      UpdatePresentationOrder;
      MODIFY;
      UpdateDescendants(Rec);
      UpdateDescendants(GLAccountCategory);
    END;

    [External]
    PROCEDURE MoveUp@11();
    BEGIN
      Move(-1);
    END;

    [External]
    PROCEDURE MoveDown@14();
    BEGIN
      Move(1);
    END;

    LOCAL PROCEDURE ChangeAncestor@10(ChangeToChild@1002 : Boolean);
    VAR
      GLAccountCategory@1000 : Record 570;
    BEGIN
      IF "Entry No." = 0 THEN
        EXIT;
      GLAccountCategory := Rec;
      IF ChangeToChild THEN BEGIN
        GLAccountCategory.SETRANGE("Parent Entry No.","Parent Entry No.");
        GLAccountCategory.SETRANGE(Indentation,Indentation);
        GLAccountCategory.SETCURRENTKEY("Presentation Order","Sibling Sequence No.");
        IF GLAccountCategory.NEXT(-1) = 0 THEN
          EXIT;
        "Parent Entry No." := GLAccountCategory."Entry No."
      END ELSE
        IF GLAccountCategory.GET("Parent Entry No.") THEN
          "Parent Entry No." := GLAccountCategory."Parent Entry No."
        ELSE
          EXIT;
      UpdatePresentationOrder;
      MODIFY;
      UpdateDescendants(Rec);
    END;

    LOCAL PROCEDURE UpdateDescendants@12(ParentGLAccountCategory@1000 : Record 570);
    VAR
      GLAccountCategory@1001 : Record 570;
    BEGIN
      IF ParentGLAccountCategory."Entry No." = 0 THEN
        EXIT;
      GLAccountCategory.SETRANGE("Parent Entry No.",ParentGLAccountCategory."Entry No.");
      IF GLAccountCategory.FINDSET THEN
        REPEAT
          GLAccountCategory."Income/Balance" := ParentGLAccountCategory."Income/Balance";
          GLAccountCategory."Account Category" := ParentGLAccountCategory."Account Category";
          GLAccountCategory.UpdatePresentationOrder;
          UpdateDescendants(GLAccountCategory);
        UNTIL GLAccountCategory.NEXT = 0;
    END;

    [External]
    PROCEDURE MakeChildOfPreviousSibling@15();
    BEGIN
      ChangeAncestor(TRUE);
    END;

    [External]
    PROCEDURE MakeSiblingOfParent@16();
    BEGIN
      ChangeAncestor(FALSE);
    END;

    [External]
    PROCEDURE DeleteRow@9();
    BEGIN
      IF "Entry No." = 0 THEN
        EXIT;
      DeleteChildren("Entry No.");
      DELETE(TRUE);
    END;

    LOCAL PROCEDURE DeleteChildren@7(ParentEntryNo@1001 : Integer);
    VAR
      GLAccountCategory@1000 : Record 570;
    BEGIN
      GLAccountCategory.SETRANGE("Parent Entry No.",ParentEntryNo);
      IF GLAccountCategory.FINDSET THEN
        REPEAT
          GLAccountCategory.DeleteRow;
        UNTIL GLAccountCategory.NEXT = 0;
    END;

    [External]
    PROCEDURE MapAccounts@8();
    BEGIN
    END;

    [External]
    PROCEDURE ValidateTotaling@5(NewTotaling@1001 : Text);
    VAR
      GLAccount@1000 : Record 15;
      OldTotaling@1002 : Text;
    BEGIN
      OldTotaling := GetTotaling;
      IF NewTotaling = OldTotaling THEN
        EXIT;
      IF NewTotaling <> '' THEN BEGIN
        GLAccount.SETFILTER("No.",NewTotaling);
        GLAccount.SETRANGE("Income/Balance","Income/Balance");
        GLAccount.LOCKTABLE;
        IF NOT GLAccount.FINDSET THEN
          ERROR(NoAccountsInFilterErr,"Income/Balance");
        ClearGLAccountSubcategoryEntryNo(OldTotaling,"Income/Balance");
        REPEAT
          GLAccount.VALIDATE("Account Subcategory Entry No.","Entry No.");
          GLAccount.MODIFY(TRUE);
        UNTIL GLAccount.NEXT = 0;
      END ELSE
        ClearGLAccountSubcategoryEntryNo(OldTotaling,"Income/Balance");
    END;

    LOCAL PROCEDURE ClearGLAccountSubcategoryEntryNo@3(Filter@1000 : Text;IncomeBalance@1002 : Integer);
    VAR
      GLAccount@1001 : Record 15;
    BEGIN
      GLAccount.SETFILTER("No.",Filter);
      GLAccount.SETRANGE("Income/Balance",IncomeBalance);
      GLAccount.MODIFYALL("Account Subcategory Entry No.",0);
    END;

    [Internal]
    PROCEDURE LookupTotaling@22();
    VAR
      GLAccount@1001 : Record 15;
      GLAccList@1000 : Page 18;
      OldTotaling@1002 : Text;
    BEGIN
      GLAccount.SETRANGE("Income/Balance","Income/Balance");
      OldTotaling := GetTotaling;
      IF OldTotaling <> '' THEN BEGIN
        GLAccount.SETFILTER("No.",OldTotaling);
        IF GLAccount.FINDFIRST THEN
          GLAccList.SETRECORD(GLAccount);
        GLAccount.SETRANGE("No.");
      END;
      GLAccList.SETTABLEVIEW(GLAccount);
      GLAccList.LOOKUPMODE(TRUE);
      IF GLAccList.RUNMODAL = ACTION::LookupOK THEN
        ValidateTotaling(GLAccList.GetSelectionFilter);
    END;

    [External]
    PROCEDURE PositiveNormalBalance@19() : Boolean;
    BEGIN
      EXIT("Account Category" IN ["Account Category"::Expense,"Account Category"::Assets,"Account Category"::"Cost of Goods Sold"]);
    END;

    [External]
    PROCEDURE GetBalance@17() : Decimal;
    VAR
      GLEntry@1000 : Record 17;
      GLAccountCategory@1001 : Record 570;
      Balance@1002 : Decimal;
      TotalingStr@1004 : Text;
    BEGIN
      CALCFIELDS("Has Children");
      IF "Has Children" THEN BEGIN
        GLAccountCategory.SETRANGE("Parent Entry No.","Entry No.");
        IF GLAccountCategory.FINDSET THEN
          REPEAT
            Balance += GLAccountCategory.GetBalance;
          UNTIL GLAccountCategory.NEXT = 0;
      END;
      TotalingStr := GetTotaling;
      IF TotalingStr = '' THEN
        EXIT(Balance);
      GLEntry.SETFILTER("G/L Account No.",TotalingStr);
      GLEntry.CALCSUMS(Amount);
      EXIT(Balance + GLEntry.Amount);
    END;

    [Internal]
    PROCEDURE GetTotaling@2() : Text[250];
    VAR
      GLAccount@1000 : Record 15;
      SelectionFilterManagement@1001 : Codeunit 46;
    BEGIN
      GLAccount.SETRANGE("Account Subcategory Entry No.","Entry No.");
      EXIT(COPYSTR(SelectionFilterManagement.GetSelectionFilterForGLAccount(GLAccount),1,250));
    END;

    BEGIN
    END.
  }
}

