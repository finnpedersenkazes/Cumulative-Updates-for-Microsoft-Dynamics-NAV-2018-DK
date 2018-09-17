OBJECT Report 96 Copy G/L Budget
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kopier finansbudget;
               ENU=Copy G/L Budget];
    ProcessingOnly=Yes;
    OnInitReport=BEGIN
                   IF AmountAdjustFactor = 0 THEN
                     AmountAdjustFactor := 1;

                   IF ToDateCompression = ToDateCompression::None THEN
                     ToDateCompression := ToDateCompression::Day;
                 END;

    OnPreReport=VAR
                  SelectedDim@1000 : Record 369;
                  GLSetup@1001 : Record 98;
                  GLBudgetName@1002 : Record 95;
                  Continue@1003 : Boolean;
                BEGIN
                  IF NOT NoMessage THEN
                    DimSelectionBuf.CompareDimText(3,REPORT::"Copy G/L Budget",'',ColumnDim,Text001);

                  IF (FromSource = FromSource::"G/L Budget Entry") AND (FromGLBudgetName = '') THEN
                    ERROR(STRSUBSTNO(Text002));

                  IF (FromSource = FromSource::"G/L Entry") AND (FromDate = '') THEN
                    ERROR(STRSUBSTNO(Text003));

                  IF ToGLBudgetName = '' THEN
                    ERROR(STRSUBSTNO(Text004));

                  Continue := TRUE;
                  GLBudgetName.SETRANGE(Name,ToGLBudgetName);
                  IF NOT GLBudgetName.FINDFIRST THEN BEGIN
                    IF NOT NoMessage THEN
                      IF NOT CONFIRM(
                           Text005,FALSE,ToGLBudgetName)
                      THEN
                        Continue := FALSE;
                    IF Continue THEN BEGIN
                      GLBudgetName.INIT;
                      GLBudgetName.Name := ToGLBudgetName;
                      GLBudgetName.INSERT;
                      COMMIT;
                    END;
                  END ELSE BEGIN
                    BudgetDim1Code := GLBudgetName."Budget Dimension 1 Code";
                    BudgetDim2Code := GLBudgetName."Budget Dimension 2 Code";
                    BudgetDim3Code := GLBudgetName."Budget Dimension 3 Code";
                    BudgetDim4Code := GLBudgetName."Budget Dimension 4 Code";
                  END;

                  IF (NOT NoMessage) AND Continue THEN
                    IF NOT CONFIRM(
                         Text006,FALSE)
                    THEN
                      Continue := FALSE;

                  IF Continue THEN BEGIN
                    SelectedDim.GetSelectedDim(USERID,3,REPORT::"Copy G/L Budget",'',TempSelectedDim);
                    IF TempSelectedDim.FIND('-') THEN
                      REPEAT
                        TempSelectedDim.Level := 0;
                        IF TempSelectedDim."Dimension Value Filter" <> '' THEN
                          IF FilterIncludesBlanks(TempSelectedDim."Dimension Value Filter") THEN
                            TempSelectedDim.Level := 1;
                        TempSelectedDim.MODIFY;
                      UNTIL TempSelectedDim.NEXT = 0;

                    ToGLBudgetEntry.LOCKTABLE;
                    IF ToGLBudgetEntry.FINDLAST THEN
                      GLBudgetEntryNo := ToGLBudgetEntry."Entry No." + 1
                    ELSE
                      GLBudgetEntryNo := 1;

                    GLSetup.GET;
                    GlobalDim1Code := GLSetup."Global Dimension 1 Code";
                    GlobalDim2Code := GLSetup."Global Dimension 2 Code";
                  END ELSE
                    CurrReport.QUIT;
                END;

    OnPostReport=VAR
                   FromGLBudgetEntry@1000 : Record 96;
                   FromGLEntry@1002 : Record 17;
                 BEGIN
                   WindowUpdateDateTime := CURRENTDATETIME;
                   Window.OPEN(Text007 + Text008 + Text009);

                   CASE FromSource OF
                     FromSource::"G/L Entry":
                       WITH FromGLEntry DO BEGIN
                         SETCURRENTKEY("G/L Account No.","Posting Date");
                         IF FromGLAccountNo <> '' THEN
                           SETFILTER("G/L Account No.",FromGLAccountNo);
                         SETFILTER("Posting Date",FromDate);
                         IF FIND('-') THEN BEGIN
                           REPEAT
                             ProcessRecord(
                               "G/L Account No.","Business Unit Code","Posting Date",Description,
                               "Dimension Set ID",Amount);
                           UNTIL NEXT = 0;
                         END;
                       END;
                     FromSource::"G/L Budget Entry":
                       WITH FromGLBudgetEntry DO BEGIN
                         SETRANGE("Budget Name",FromGLBudgetName);
                         IF FromGLAccountNo <> '' THEN
                           SETFILTER("G/L Account No.",FromGLAccountNo);
                         IF FromDate <> '' THEN
                           SETFILTER(Date,FromDate);
                         IF FINDLAST THEN
                           SETFILTER("Entry No.",'<=%1',"Entry No.");
                         SETCURRENTKEY("Budget Name","G/L Account No.",Description,Date);
                         IF FINDSET THEN
                           REPEAT
                             ProcessRecord(
                               "G/L Account No.","Business Unit Code",Date,Description,
                               "Dimension Set ID",Amount);
                           UNTIL NEXT = 0;
                       END;
                   END;
                   InsertGLBudgetEntry;
                   Window.CLOSE;

                   IF NOT NoMessage THEN
                     MESSAGE(Text010);
                 END;

  }
  DATASET
  {
  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 12  ;2   ;Group     ;
                  CaptionML=[DAN=Kopier fra;
                             ENU=Copy from] }

      { 15  ;3   ;Field     ;
                  Name=Source;
                  CaptionML=[DAN=Kilde;
                             ENU=Source];
                  ToolTipML=[DAN=Angiver, hvilke former for bel›b der skal kopieres til et nyt budget. Du kan v‘lge finansposter eller finansbudgetposter.;
                             ENU=Specifies which kind of amounts that you want to copy to a new budget. You can select either general ledger entries or general ledger budget entries.];
                  OptionCaptionML=[DAN=Finanspost,Finansbudgetpost;
                                   ENU=G/L Entry,G/L Budget Entry];
                  ApplicationArea=#Suite;
                  SourceExpr=FromSource;
                  OnValidate=BEGIN
                               IF FromSource = FromSource::"G/L Entry" THEN
                                 FromGLBudgetName := '';
                             END;
                              }

      { 24  ;3   ;Field     ;
                  CaptionML=[DAN=Budgetnavn;
                             ENU=Budget Name];
                  ToolTipML=[DAN=Angiver navnet p† budgettet.;
                             ENU=Specifies the name of the budget.];
                  ApplicationArea=#Suite;
                  SourceExpr=FromGLBudgetName;
                  TableRelation="G/L Budget Name";
                  OnValidate=BEGIN
                               IF (FromGLBudgetName <> '') AND (FromSource = FromSource::"G/L Entry") THEN
                                 FromSource := FromSource::"G/L Budget Entry";
                             END;
                              }

      { 22  ;3   ;Field     ;
                  Name=GLAccountNo;
                  CaptionML=[DAN=Finanskontonr.;
                             ENU=G/L Account No.];
                  ToolTipML=[DAN=Angiver den eller de finanskonti, som k›rslen vil behandle.;
                             ENU=Specifies the G/L account or accounts that the batch job will process.];
                  ApplicationArea=#Suite;
                  SourceExpr=FromGLAccountNo;
                  TableRelation="G/L Account" }

      { 9   ;3   ;Field     ;
                  Name=Date;
                  CaptionML=[DAN=Dato;
                             ENU=Date];
                  ToolTipML=[DAN=Angiver datoen.;
                             ENU=Specifies the date.];
                  ApplicationArea=#Suite;
                  SourceExpr=FromDate;
                  OnValidate=VAR
                               GLAcc@1001 : Record 15;
                               ApplicationManagement@1002 : Codeunit 1;
                             BEGIN
                               IF ApplicationManagement.MakeDateFilter(FromDate) = 0 THEN;
                               GLAcc.SETFILTER("Date Filter",FromDate);
                               FromDate := GLAcc.GETFILTER("Date Filter");
                             END;
                              }

      { 26  ;3   ;Field     ;
                  CaptionML=[DAN=Ultimoposter;
                             ENU=Closing Entries];
                  ToolTipML=[DAN=Angiver, om den viste saldo skal indeholde ultimoposter. Hvis du vil se bel›bene p† resultatopg›relseskontiene i afsluttede †r, skal du udelukke ultimoposter.;
                             ENU=Specifies whether the balance shown will include closing entries. If you want to see the amounts on income statement accounts in closed years, you must exclude closing entries.];
                  OptionCaptionML=[DAN=Medtag,Udelad;
                                   ENU=Include,Exclude];
                  ApplicationArea=#Suite;
                  SourceExpr=FromClosingEntryFilter }

      { 1   ;3   ;Field     ;
                  CaptionML=[DAN=Dimensioner;
                             ENU=Dimensions];
                  ToolTipML=[DAN=Angiver dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                             ENU=Specifies dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                  ApplicationArea=#Suite;
                  SourceExpr=ColumnDim;
                  Editable=FALSE;
                  OnAssistEdit=VAR
                                 DimSelectionBuf@1001 : Record 368;
                               BEGIN
                                 DimSelectionBuf.SetDimSelectionChange(3,REPORT::"Copy G/L Budget",ColumnDim);
                               END;
                                }

      { 11  ;2   ;Group     ;
                  CaptionML=[DAN=Kopier til;
                             ENU=Copy to] }

      { 7   ;3   ;Field     ;
                  Name=BudgetName;
                  CaptionML=[DAN=Budgetnavn;
                             ENU=Budget Name];
                  ToolTipML=[DAN=Angiver navnet p† budgettet.;
                             ENU=Specifies the name of the budget.];
                  ApplicationArea=#Suite;
                  SourceExpr=ToGLBudgetName;
                  TableRelation="G/L Budget Name" }

      { 5   ;3   ;Field     ;
                  CaptionML=[DAN=Finanskontonr.;
                             ENU=G/L Account No.];
                  ToolTipML=[DAN=Angiver den eller de finanskonti, som k›rslen vil behandle.;
                             ENU=Specifies the G/L account or accounts that the batch job will process.];
                  ApplicationArea=#Suite;
                  SourceExpr=ToGLAccountNo;
                  TableRelation="G/L Account";
                  OnValidate=BEGIN
                               ToGLAccountNoOnAfterValidate;
                             END;
                              }

      { 13  ;2   ;Group     ;
                  CaptionML=[DAN=Udlign;
                             ENU=Apply] }

      { 18  ;3   ;Field     ;
                  CaptionML=[DAN=Ganges med;
                             ENU=Adjustment Factor];
                  ToolTipML=[DAN=Angiver en reguleringsfaktor, som de bel›b, der skal kopieres, ganges med. Hvis du angiver en reguleringsfaktor, kan du for›ge eller mindske de bel›b, der kopieres til det nye budget.;
                             ENU=Specifies an adjustment factor to multiply the amounts that you want to copy. By entering an adjustment factor, you can increase or decrease the amounts that are copied to the new budget.];
                  ApplicationArea=#Suite;
                  DecimalPlaces=0:5;
                  NotBlank=Yes;
                  SourceExpr=AmountAdjustFactor;
                  MinValue=0 }

      { 14  ;3   ;Field     ;
                  CaptionML=[DAN=Afrundingsmetode;
                             ENU=Rounding Method];
                  ToolTipML=[DAN=Angiver en kode for den afrundingsmetode, som du vil knytte til de poster, du kopierer til et nyt budget.;
                             ENU=Specifies a code for the rounding method that you want to apply to entries when you copy them to a new budget.];
                  ApplicationArea=#Suite;
                  SourceExpr=RoundingMethod.Code;
                  TableRelation="Rounding Method" }

      { 20  ;3   ;Field     ;
                  CaptionML=[DAN=Flyt datoer med;
                             ENU=Date Change Formula];
                  ToolTipML=[DAN=Angiver, hvordan datoerne p† de poster, der kopieres, ‘ndres. Hvis du f.eks. vil kopiere budgettet fra sidste uge til denne uge, skal du bruge datoformlen 1U (‚n uge).;
                             ENU="Specifies how the dates on the entries that are copied will be changed. Use a date formula; for example, to copy last week's budget to this week, use the formula 1W (one week)."];
                  OptionCaptionML=[DAN=Ingen,Dag,Uge,M†ned,Kvartal,r,Regnskabsperiode;
                                   ENU=None,Day,Week,Month,Quarter,Year,Period];
                  ApplicationArea=#Suite;
                  SourceExpr=DateAdjustExpression }

      { 3   ;3   ;Field     ;
                  CaptionML=[DAN=Datokomprimering;
                             ENU=Date Compression];
                  ToolTipML=[DAN=Angiver l‘ngden p† den periode, hvori der kombineres poster. V‘lg feltet, hvis du vil se indstillingerne.;
                             ENU=Specifies the length of the period whose entries are combined. To see the options, choose the field.];
                  OptionCaptionML=[DAN=Ingen,Dag,Uge,M†ned,Kvartal,r,Regnskabsperiode;
                                   ENU=None,Day,Week,Month,Quarter,Year,Period];
                  ApplicationArea=#Suite;
                  SourceExpr=ToDateCompression }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text001@1000 : TextConst 'DAN=Dimensioner;ENU=Dimensions';
      Text002@1001 : TextConst 'DAN=Du skal angive et budgetnavn, der skal kopieres fra.;ENU=You must specify a budget name to copy from.';
      Text003@1002 : TextConst 'DAN=Du skal angive et tidsinterval, der skal kopieres fra.;ENU=You must specify a date interval to copy from.';
      Text004@1003 : TextConst 'DAN=Du skal angive et budgetnavn, der skal kopieres til.;ENU=You must specify a budget name to copy to.';
      Text005@1004 : TextConst 'DAN=Vil du oprette finansbudgetnavnet %1?;ENU=Do you want to create G/L Budget Name %1?';
      Text006@1005 : TextConst 'DAN=Vil du begynde at kopiere?;ENU=Do you want to start the copy?';
      Text007@1006 : TextConst 'DAN=Kopierer budget...\\;ENU=Copying budget...\\';
      Text008@1007 : TextConst 'DAN=Finanskontonr.  #1####################\;ENU=G/L Account No. #1####################\';
      Text009@1008 : TextConst 'DAN=Bogf›ringsdato  #2######;ENU=Posting Date    #2######';
      Text010@1009 : TextConst 'DAN=Budgettet blev kopieret.;ENU=Budget has been successfully copied.';
      Text011@1075 : TextConst 'DAN=Du kan kun definere en finanskonto.;ENU=You can define only one G/L Account.';
      ToGLBudgetEntry@1010 : Record 96;
      TempGLBudgetEntry@1012 : TEMPORARY Record 96;
      TempSelectedDim@1015 : TEMPORARY Record 369;
      TempDimEntryBuffer@1044 : TEMPORARY Record 373;
      DimSetEntry@1045 : Record 480;
      TempDimSetEntry@1051 : TEMPORARY Record 480;
      RoundingMethod@1018 : Record 42;
      DimSelectionBuf@1019 : Record 368;
      DimMgt@1020 : Codeunit 408;
      Window@1013 : Dialog;
      FromDate@1021 : Text;
      FromSource@1022 : 'G/L Entry,G/L Budget Entry';
      FromGLBudgetName@1023 : Code[10];
      FromGLAccountNo@1024 : Code[250];
      FromClosingEntryFilter@1025 : 'Include,Exclude';
      ToGLBudgetName@1026 : Code[10];
      ToGLAccountNo@1027 : Code[20];
      ToBUCode@1028 : Code[20];
      ToDateCompression@1029 : 'None,Day,Week,Month,Quarter,Year,Period';
      ColumnDim@1030 : Text[250];
      AmountAdjustFactor@1031 : Decimal;
      DateAdjustExpression@1032 : DateFormula;
      GLBudgetEntryNo@1033 : Integer;
      GlobalDim1Code@1034 : Code[20];
      GlobalDim2Code@1035 : Code[20];
      BudgetDim1Code@1036 : Code[20];
      BudgetDim2Code@1037 : Code[20];
      BudgetDim3Code@1038 : Code[20];
      BudgetDim4Code@1039 : Code[20];
      NoMessage@1040 : Boolean;
      PrevPostingDate@1041 : Date;
      PrevCalculatedPostingDate@1042 : Date;
      OldGLAccountNo@1053 : Code[20];
      OldPostingDate@1052 : Date;
      OldPostingDescription@1011 : Text[50];
      OldBUCode@1050 : Code[20];
      WindowUpdateDateTime@1048 : DateTime;

    LOCAL PROCEDURE ProcessRecord@3(GLAccNo@1000 : Code[20];BUCode@1001 : Code[20];PostingDate@1002 : Date;PostingDescription@1003 : Text[50];DimSetID@1004 : Integer;Amount@1007 : Decimal);
    VAR
      NewDate@1008 : Date;
      NewDimSetID@1006 : Integer;
    BEGIN
      IF CURRENTDATETIME - WindowUpdateDateTime >= 750 THEN BEGIN
        Window.UPDATE(1,GLAccNo);
        Window.UPDATE(2,PostingDate);
        WindowUpdateDateTime := CURRENTDATETIME;
      END;
      NewDate := CalculatePeriodStart(PostingDate);
      IF (FromClosingEntryFilter = FromClosingEntryFilter::Exclude) AND (NewDate = CLOSINGDATE(NewDate)) THEN
        EXIT;

      IF (FromSource = FromSource::"G/L Entry") AND
         (ToDateCompression <> ToDateCompression::None)
      THEN
        PostingDescription := '';

      IF OldGLAccountNo = '' THEN BEGIN
        OldGLAccountNo := GLAccNo;
        OldPostingDate := NewDate;
        OldBUCode := BUCode;
        OldPostingDescription := PostingDescription;
      END;

      IF (GLAccNo <> OldGLAccountNo) OR
         (NewDate <> OldPostingDate) OR
         (BUCode <> OldBUCode) OR
         (PostingDescription <> OldPostingDescription) OR
         (ToDateCompression = ToDateCompression::None)
      THEN BEGIN
        OldGLAccountNo := GLAccNo;
        OldPostingDate := NewDate;
        OldBUCode := BUCode;
        OldPostingDescription := PostingDescription;
        InsertGLBudgetEntry;
      END;

      NewDimSetID := DimSetID;
      IF NOT IncludeFromEntry(NewDimSetID) THEN
        EXIT;

      UpdateTempGLBudgetEntry(GLAccNo,NewDate,Amount,PostingDescription,BUCode,NewDimSetID);
    END;

    LOCAL PROCEDURE UpdateTempGLBudgetEntry@6(GLAccNo@1000 : Code[20];PostingDate@1001 : Date;Amount@1002 : Decimal;Description@1003 : Text[50];BUCode@1004 : Code[20];DimSetID@1007 : Integer);
    BEGIN
      TempGLBudgetEntry.SETRANGE("G/L Account No.",GLAccNo);
      TempGLBudgetEntry.SETRANGE(Date,PostingDate);
      TempGLBudgetEntry.SETRANGE(Description,Description);
      TempGLBudgetEntry.SETRANGE("Business Unit Code",BUCode);
      TempGLBudgetEntry.SETRANGE("Dimension Set ID",DimSetID);

      IF TempGLBudgetEntry.FINDFIRST THEN BEGIN
        TempGLBudgetEntry.Amount := TempGLBudgetEntry.Amount + Amount;
        TempGLBudgetEntry.MODIFY;
        TempGLBudgetEntry.RESET;
      END ELSE BEGIN
        TempGLBudgetEntry.RESET;
        IF TempGLBudgetEntry.FINDLAST THEN
          TempGLBudgetEntry."Entry No." := TempGLBudgetEntry."Entry No." + 1
        ELSE
          TempGLBudgetEntry."Entry No." := 1;
        TempGLBudgetEntry."Dimension Set ID" := DimSetID;
        TempGLBudgetEntry."G/L Account No." := GLAccNo;
        TempGLBudgetEntry.Date := PostingDate;
        TempGLBudgetEntry.Amount := Amount;
        TempGLBudgetEntry.Description := Description;
        TempGLBudgetEntry."Business Unit Code" := BUCode;
        TempGLBudgetEntry.INSERT;
      END;
    END;

    LOCAL PROCEDURE InsertGLBudgetEntry@2();
    VAR
      Sign@1000 : Decimal;
    BEGIN
      IF TempGLBudgetEntry.FIND('-') THEN BEGIN
        REPEAT
          IF TempGLBudgetEntry.Amount <> 0 THEN BEGIN
            ToGLBudgetEntry := TempGLBudgetEntry;
            ToGLBudgetEntry."Entry No." := GLBudgetEntryNo;
            GLBudgetEntryNo := GLBudgetEntryNo + 1;
            ToGLBudgetEntry."Budget Name" := ToGLBudgetName;
            IF ToGLAccountNo <> '' THEN
              ToGLBudgetEntry."G/L Account No." := ToGLAccountNo;
            IF ToBUCode <> '' THEN
              ToGLBudgetEntry."Business Unit Code" := ToBUCode;
            ToGLBudgetEntry."User ID" := USERID;
            ToGLBudgetEntry."Last Date Modified" := TODAY;
            ToGLBudgetEntry.Date := TempGLBudgetEntry.Date;
            ToGLBudgetEntry.Amount := ROUND(TempGLBudgetEntry.Amount * AmountAdjustFactor);
            IF RoundingMethod.Code <> '' THEN BEGIN
              IF ToGLBudgetEntry.Amount >= 0 THEN
                Sign := 1
              ELSE
                Sign := -1;
              RoundingMethod."Minimum Amount" := ABS(ToGLBudgetEntry.Amount);
              IF RoundingMethod.FIND('=<') THEN BEGIN
                ToGLBudgetEntry.Amount :=
                  ToGLBudgetEntry.Amount + Sign * RoundingMethod."Amount Added Before";
                IF RoundingMethod.Precision > 0 THEN
                  ToGLBudgetEntry.Amount :=
                    Sign *
                    ROUND(
                      ABS(
                        ToGLBudgetEntry.Amount),RoundingMethod.Precision,COPYSTR('=><',
                        RoundingMethod.Type + 1,1));
                ToGLBudgetEntry.Amount :=
                  ToGLBudgetEntry.Amount + Sign * RoundingMethod."Amount Added After";
              END;
            END;
            DimSetEntry.RESET;
            DimSetEntry.SETRANGE("Dimension Set ID",TempGLBudgetEntry."Dimension Set ID");
            IF DimSetEntry.FIND('-') THEN BEGIN
              REPEAT
                IF DimSetEntry."Dimension Code" = GlobalDim1Code THEN
                  ToGLBudgetEntry."Global Dimension 1 Code" := DimSetEntry."Dimension Value Code";
                IF DimSetEntry."Dimension Code" = GlobalDim2Code THEN
                  ToGLBudgetEntry."Global Dimension 2 Code" := DimSetEntry."Dimension Value Code";
                IF DimSetEntry."Dimension Code" = BudgetDim1Code THEN
                  ToGLBudgetEntry."Budget Dimension 1 Code" := DimSetEntry."Dimension Value Code";
                IF DimSetEntry."Dimension Code" = BudgetDim2Code THEN
                  ToGLBudgetEntry."Budget Dimension 2 Code" := DimSetEntry."Dimension Value Code";
                IF DimSetEntry."Dimension Code" = BudgetDim3Code THEN
                  ToGLBudgetEntry."Budget Dimension 3 Code" := DimSetEntry."Dimension Value Code";
                IF DimSetEntry."Dimension Code" = BudgetDim4Code THEN
                  ToGLBudgetEntry."Budget Dimension 4 Code" := DimSetEntry."Dimension Value Code";
              UNTIL DimSetEntry.NEXT = 0;
            END;
            ToGLBudgetEntry.INSERT;
          END;
        UNTIL TempGLBudgetEntry.NEXT = 0;
      END;
      TempGLBudgetEntry.RESET;
      TempGLBudgetEntry.DELETEALL;
    END;

    [External]
    PROCEDURE Initialize@1(FromSource2@1000 : Option;FromGLBudgetName2@1001 : Code[10];FromGLAccountNo2@1002 : Code[250];FromDate2@1003 : Text[30];ToGlBudgetName2@1004 : Code[10];ToGLAccountNo2@1005 : Code[20];ToBUCode2@1006 : Code[20];AmountAdjustFactor2@1007 : Decimal;RoundingMethod2@1008 : Code[10];DateAdjustExpression2@1009 : DateFormula;NoMessage2@1010 : Boolean);
    BEGIN
      FromSource := FromSource2;
      FromGLBudgetName := FromGLBudgetName2;
      FromGLAccountNo := FromGLAccountNo2;
      FromDate := FromDate2;
      ToGLBudgetName := ToGlBudgetName2;
      ToGLAccountNo := ToGLAccountNo2;
      ToBUCode := ToBUCode2;
      AmountAdjustFactor := AmountAdjustFactor2;
      RoundingMethod.Code := RoundingMethod2;
      DateAdjustExpression := DateAdjustExpression2;
      NoMessage := NoMessage2;
    END;

    LOCAL PROCEDURE CalculatePeriodStart@4(PostingDate@1000 : Date) : Date;
    VAR
      AccountingPeriod@1001 : Record 50;
    BEGIN
      IF FORMAT(DateAdjustExpression) <> '' THEN
        IF PostingDate = CLOSINGDATE(PostingDate) THEN
          PostingDate := CLOSINGDATE(CALCDATE(DateAdjustExpression,NORMALDATE(PostingDate)))
        ELSE
          PostingDate := CALCDATE(DateAdjustExpression,PostingDate);
      IF PostingDate = CLOSINGDATE(PostingDate) THEN
        EXIT(PostingDate);

      CASE ToDateCompression OF
        ToDateCompression::Week:
          PostingDate := CALCDATE('<CW+1D-1W>',PostingDate);
        ToDateCompression::Month:
          PostingDate := CALCDATE('<CM+1D-1M>',PostingDate);
        ToDateCompression::Quarter:
          PostingDate := CALCDATE('<CQ+1D-1Q>',PostingDate);
        ToDateCompression::Year:
          PostingDate := CALCDATE('<CY+1D-1Y>',PostingDate);
        ToDateCompression::Period:
          BEGIN
            IF PostingDate <> PrevPostingDate THEN BEGIN
              PrevPostingDate := PostingDate;
              AccountingPeriod.SETRANGE("Starting Date",0D,PostingDate);
              IF AccountingPeriod.FINDLAST THEN BEGIN
                PrevCalculatedPostingDate := AccountingPeriod."Starting Date"
              END ELSE
                PrevCalculatedPostingDate := PostingDate;
            END;
            PostingDate := PrevCalculatedPostingDate;
          END;
      END;
      EXIT(PostingDate);
    END;

    LOCAL PROCEDURE FilterIncludesBlanks@17(TheFilter@1000 : Code[250]) : Boolean;
    VAR
      TempDimBuf2@1001 : TEMPORARY Record 360;
    BEGIN
      WITH TempDimBuf2 DO BEGIN
        DELETEALL; // Necessary because of C/SIDE error
        INIT;
        INSERT;
        SETFILTER("Dimension Code",TheFilter);
        EXIT(FINDFIRST);
      END;
    END;

    LOCAL PROCEDURE IncludeFromEntry@5(VAR DimSetID@1000 : Integer) : Boolean;
    VAR
      IncludeEntry@1001 : Boolean;
    BEGIN
      IF TempDimEntryBuffer.GET(DimSetID) THEN BEGIN
        DimSetID := TempDimEntryBuffer."Dimension Entry No.";
        EXIT(TRUE);
      END;
      TempDimEntryBuffer."No." := DimSetID;

      IncludeEntry := TRUE;
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
      TempDimSetEntry.RESET;
      TempDimSetEntry.DELETEALL;
      IF TempSelectedDim.FIND('-') THEN
        REPEAT
          DimSetEntry.INIT;
          DimSetEntry.SETRANGE("Dimension Code",TempSelectedDim."Dimension Code");
          IF TempSelectedDim."Dimension Value Filter" <> '' THEN
            DimSetEntry.SETFILTER("Dimension Value Code",TempSelectedDim."Dimension Value Filter");
          IF DimSetEntry.FINDFIRST THEN BEGIN
            TempDimSetEntry := DimSetEntry;
            TempDimSetEntry."Dimension Set ID" := 0;
            IF TempSelectedDim."New Dimension Value Code" <> '' THEN
              TempDimSetEntry.VALIDATE("Dimension Value Code",TempSelectedDim."New Dimension Value Code");
            TempDimSetEntry.INSERT(TRUE);
          END ELSE BEGIN
            IF TempSelectedDim."Dimension Value Filter" <> '' THEN
              IF TempSelectedDim.Level = 1 THEN BEGIN
                DimSetEntry.SETRANGE("Dimension Value Code");
                IncludeEntry := NOT DimSetEntry.FINDFIRST;
              END ELSE
                IncludeEntry := FALSE;
            IF IncludeEntry AND (TempSelectedDim."New Dimension Value Code" <> '') THEN BEGIN
              TempDimSetEntry."Dimension Set ID" := 0;
              TempDimSetEntry."Dimension Code" := COPYSTR(TempSelectedDim."Dimension Code",1,20);
              TempDimSetEntry.VALIDATE("Dimension Value Code",TempSelectedDim."New Dimension Value Code");
              TempDimSetEntry.INSERT(TRUE);
            END;
          END;
          DimSetEntry.SETRANGE("Dimension Code");
          DimSetEntry.SETRANGE("Dimension Value Code");
        UNTIL (TempSelectedDim.NEXT = 0) OR NOT IncludeEntry;
      IF IncludeEntry THEN BEGIN
        DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);
        TempDimEntryBuffer."Dimension Entry No." := DimSetID;
        TempDimEntryBuffer.INSERT;
        EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    [External]
    PROCEDURE InitializeRequest@7(FromSource2@1000 : Option;FromGLBudgetName2@1001 : Code[10];FromGLAccountNo2@1002 : Code[250];FromDate2@1003 : Text[30];FromClosingEntryFilter2@1011 : Option;DimensionText@1006 : Text[250];ToGlBudgetName2@1004 : Code[10];ToGLAccountNo2@1005 : Code[20];AmountAdjustFactor2@1007 : Decimal;RoundingMethod2@1008 : Code[10];DateAdjustExpression2@1009 : DateFormula;ToDateCompression2@1010 : Option);
    BEGIN
      FromSource := FromSource2;
      FromGLBudgetName := FromGLBudgetName2;
      FromGLAccountNo := FromGLAccountNo2;
      FromDate := FromDate2;
      FromClosingEntryFilter := FromClosingEntryFilter2;
      ColumnDim := DimensionText;
      ToGLBudgetName := ToGlBudgetName2;
      ToGLAccountNo := ToGLAccountNo2;
      AmountAdjustFactor := AmountAdjustFactor2;
      RoundingMethod.Code := RoundingMethod2;
      DateAdjustExpression := DateAdjustExpression2;
      ToDateCompression := ToDateCompression2;
    END;

    LOCAL PROCEDURE ToGLAccountNoOnAfterValidate@1130();
    VAR
      GLAccount@1110 : Record 15;
    BEGIN
      IF ToGLAccountNo <> '' THEN BEGIN
        GLAccount.GET(ToGLAccountNo);
        MESSAGE(Text011)
      END;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

