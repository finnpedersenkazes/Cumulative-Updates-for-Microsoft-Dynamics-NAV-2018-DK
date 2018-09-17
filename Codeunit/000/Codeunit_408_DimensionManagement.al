OBJECT Codeunit 408 DimensionManagement
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 80=imd,
                TableData 232=imd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Dimensionerne %1 og %2 kan ikke bruges samtidig.;ENU=Dimensions %1 and %2 can''t be used concurrently.';
      Text001@1001 : TextConst 'DAN=Dimensionskombinationerne %1 - %2 og %3 - %4 kan ikke bruges samtidig.;ENU=Dimension combinations %1 - %2 and %3 - %4 can''t be used concurrently.';
      Text002@1002 : TextConst 'DAN=Denne genvejsdimension er ikke angivet i %1.;ENU=This Shortcut Dimension is not defined in the %1.';
      Text003@1003 : TextConst 'DAN=%1 er ikke en tilg�ngelig %2 for denne dimension.;ENU=%1 is not an available %2 for that dimension.';
      Text004@1004 : TextConst 'DAN=Angiv %1 for %2 %3.;ENU=Select a %1 for the %2 %3.';
      Text005@1005 : TextConst 'DAN=Angiv %1 til %2 %3 for %4 %5.;ENU=Select a %1 for the %2 %3 for %4 %5.';
      Text006@1006 : TextConst 'DAN=Angiv %1 %2 til %3 %4.;ENU=Select %1 %2 for the %3 %4.';
      Text007@1007 : TextConst 'DAN=Angiv %1 %2 til %3 %4 for %5 %6.;ENU=Select %1 %2 for the %3 %4 for %5 %6.';
      Text008@1008 : TextConst 'DAN=%1 %2 skal v�re tom.;ENU=%1 %2 must be blank.';
      Text009@1009 : TextConst 'DAN=%1 %2 skal v�re tom for %3 %4.;ENU=%1 %2 must be blank for %3 %4.';
      Text010@1010 : TextConst 'DAN=%1 %2 m� ikke angives.;ENU=%1 %2 must not be mentioned.';
      Text011@1011 : TextConst 'DAN=%1 %2 m� ikke angives for %3 %4.;ENU=%1 %2 must not be mentioned for %3 %4.';
      Text012@1012 : TextConst 'DAN=%1, der bliver brugt i %2 blev ikke brugt i %3.;ENU=A %1 used in %2 has not been used in %3.';
      Text013@1013 : TextConst 'DAN=%1 for %2 %3 er ikke identisk i %4 og %5.;ENU=%1 for %2 %3 is not the same in %4 and %5.';
      Text014@1014 : TextConst 'DAN=%1 %2 er sp�rret.;ENU=%1 %2 is blocked.';
      Text015@1015 : TextConst 'DAN=%1 %2 blev ikke fundet.;ENU=%1 %2 can''t be found.';
      Text016@1016 : TextConst 'DAN=%1 %2 - %3 er sp�rret.;ENU=%1 %2 - %3 is blocked.';
      Text017@1017 : TextConst 'DAN=%1 for %2 %3 - %4 m� ikke v�re %5.;ENU=%1 for %2 %3 - %4 must not be %5.';
      Text018@1018 : TextConst 'DAN=%1 for %2 mangler.;ENU=%1 for %2 is missing.';
      Text019@1028 : TextConst 'DAN=Du har �ndret en dimension.\\Vil du opdatere linjerne?;ENU=You have changed a dimension.\\Do you want to update the lines?';
      TempDimBuf1@1019 : TEMPORARY Record 360;
      TempDimBuf2@1020 : TEMPORARY Record 360;
      ObjTransl@1027 : Record 377;
      DimValComb@1032 : Record 351;
      JobTaskDimTemp@1033 : TEMPORARY Record 1002;
      DefaultDim@1035 : Record 352;
      DimSetEntry@1034 : Record 480;
      TempDimSetEntry2@1029 : TEMPORARY Record 480;
      TempDimCombInitialized@1031 : Boolean;
      TempDimCombEmpty@1030 : Boolean;
      DimCombErr@1021 : Text[250];
      DimValuePostingErr@1022 : Text[250];
      DimErr@1023 : Text[250];
      DocDimConsistencyErr@1024 : Text[250];
      HasGotGLSetup@1025 : Boolean;
      GLSetupShortcutDimCode@1026 : ARRAY [8] OF Code[20];
      DimSetFilterCtr@1036 : Integer;
      OverflowDimFilterErr@1037 : TextConst 'DAN=Konvertering af dimensionsfilter resulterer i et filter, der bliver for langt.;ENU=Conversion of dimension filter results in a filter that becomes too long.';

    [External]
    PROCEDURE GetDimensionSetID@123(VAR DimSetEntry2@1000 : Record 480) : Integer;
    BEGIN
      EXIT(DimSetEntry.GetDimensionSetID(DimSetEntry2));
    END;

    [External]
    PROCEDURE GetDimensionSet@124(VAR TempDimSetEntry@1000 : TEMPORARY Record 480;DimSetID@1001 : Integer);
    VAR
      DimSetEntry2@1002 : Record 480;
    BEGIN
      TempDimSetEntry.DELETEALL;
      WITH DimSetEntry2 DO BEGIN
        SETRANGE("Dimension Set ID",DimSetID);
        IF FINDSET THEN
          REPEAT
            TempDimSetEntry := DimSetEntry2;
            TempDimSetEntry.INSERT;
          UNTIL NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE ShowDimensionSet@125(DimSetID@1000 : Integer;NewCaption@1003 : Text[250]);
    VAR
      DimSetEntries@1002 : Page 479;
    BEGIN
      DimSetEntry.RESET;
      DimSetEntry.FILTERGROUP(2);
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
      DimSetEntry.FILTERGROUP(0);
      DimSetEntries.SETTABLEVIEW(DimSetEntry);
      DimSetEntries.SetFormCaption(NewCaption);
      DimSetEntry.RESET;
      DimSetEntries.RUNMODAL;
    END;

    [External]
    PROCEDURE EditDimensionSet@128(DimSetID@1000 : Integer;NewCaption@1003 : Text[250]) : Integer;
    VAR
      EditDimSetEntries@1002 : Page 480;
      NewDimSetID@1004 : Integer;
    BEGIN
      NewDimSetID := DimSetID;
      DimSetEntry.RESET;
      DimSetEntry.FILTERGROUP(2);
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
      DimSetEntry.FILTERGROUP(0);
      EditDimSetEntries.SETTABLEVIEW(DimSetEntry);
      EditDimSetEntries.SetFormCaption(NewCaption);
      EditDimSetEntries.RUNMODAL;
      NewDimSetID := EditDimSetEntries.GetDimensionID;
      DimSetEntry.RESET;
      EXIT(NewDimSetID);
    END;

    [External]
    PROCEDURE EditDimensionSet2@131(DimSetID@1000 : Integer;NewCaption@1003 : Text[250];VAR GlobalDimVal1@1006 : Code[20];VAR GlobalDimVal2@1005 : Code[20]) : Integer;
    VAR
      EditDimSetEntries@1002 : Page 480;
      NewDimSetID@1004 : Integer;
    BEGIN
      NewDimSetID := DimSetID;
      DimSetEntry.RESET;
      DimSetEntry.FILTERGROUP(2);
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
      DimSetEntry.FILTERGROUP(0);
      EditDimSetEntries.SETTABLEVIEW(DimSetEntry);
      EditDimSetEntries.SetFormCaption(NewCaption);
      EditDimSetEntries.RUNMODAL;
      NewDimSetID := EditDimSetEntries.GetDimensionID;
      UpdateGlobalDimFromDimSetID(NewDimSetID,GlobalDimVal1,GlobalDimVal2);
      DimSetEntry.RESET;
      EXIT(NewDimSetID);
    END;

    [External]
    PROCEDURE EditReclasDimensionSet2@133(VAR DimSetID@1001 : Integer;VAR NewDimSetID@1002 : Integer;NewCaption@1000 : Text[250];VAR GlobalDimVal1@1005 : Code[20];VAR GlobalDimVal2@1003 : Code[20];VAR NewGlobalDimVal1@1007 : Code[20];VAR NewGlobalDimVal2@1006 : Code[20]);
    VAR
      EditReclasDimensions@1004 : Page 484;
    BEGIN
      EditReclasDimensions.SetDimensionIDs(DimSetID,NewDimSetID);
      EditReclasDimensions.SetFormCaption(NewCaption);
      EditReclasDimensions.RUNMODAL;
      EditReclasDimensions.GetDimensionIDs(DimSetID,NewDimSetID);
      UpdateGlobalDimFromDimSetID(DimSetID,GlobalDimVal1,GlobalDimVal2);
      UpdateGlobalDimFromDimSetID(NewDimSetID,NewGlobalDimVal1,NewGlobalDimVal2);
    END;

    [External]
    PROCEDURE UpdateGlobalDimFromDimSetID@130(DimSetID@1000 : Integer;VAR GlobalDimVal1@1001 : Code[20];VAR GlobalDimVal2@1002 : Code[20]);
    BEGIN
      GetGLSetup;
      GlobalDimVal1 := '';
      GlobalDimVal2 := '';
      IF GLSetupShortcutDimCode[1] <> '' THEN
        IF DimSetEntry.GET(DimSetID,GLSetupShortcutDimCode[1]) THEN
          GlobalDimVal1 := DimSetEntry."Dimension Value Code";
      IF GLSetupShortcutDimCode[2] <> '' THEN
        IF DimSetEntry.GET(DimSetID,GLSetupShortcutDimCode[2]) THEN
          GlobalDimVal2 := DimSetEntry."Dimension Value Code";
    END;

    [External]
    PROCEDURE GetCombinedDimensionSetID@132(DimensionSetIDArr@1000 : ARRAY [10] OF Integer;VAR GlobalDimVal1@1004 : Code[20];VAR GlobalDimVal2@1005 : Code[20]) : Integer;
    VAR
      TempDimSetEntry@1003 : TEMPORARY Record 480;
      i@1001 : Integer;
    BEGIN
      GetGLSetup;
      GlobalDimVal1 := '';
      GlobalDimVal2 := '';
      DimSetEntry.RESET;
      FOR i := 1 TO 10 DO
        IF DimensionSetIDArr[i] <> 0 THEN BEGIN
          DimSetEntry.SETRANGE("Dimension Set ID",DimensionSetIDArr[i]);
          IF DimSetEntry.FINDSET THEN
            REPEAT
              IF TempDimSetEntry.GET(0,DimSetEntry."Dimension Code") THEN
                TempDimSetEntry.DELETE;
              TempDimSetEntry := DimSetEntry;
              TempDimSetEntry."Dimension Set ID" := 0;
              TempDimSetEntry.INSERT;
              IF GLSetupShortcutDimCode[1] = TempDimSetEntry."Dimension Code" THEN
                GlobalDimVal1 := TempDimSetEntry."Dimension Value Code";
              IF GLSetupShortcutDimCode[2] = TempDimSetEntry."Dimension Code" THEN
                GlobalDimVal2 := TempDimSetEntry."Dimension Value Code";
            UNTIL DimSetEntry.NEXT = 0;
        END;
      EXIT(GetDimensionSetID(TempDimSetEntry));
    END;

    [External]
    PROCEDURE GetDeltaDimSetID@137(DimSetID@1005 : Integer;NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 : Integer) : Integer;
    VAR
      TempDimSetEntry@1004 : TEMPORARY Record 480;
      TempDimSetEntryNew@1003 : TEMPORARY Record 480;
      TempDimSetEntryDeleted@1002 : TEMPORARY Record 480;
    BEGIN
      // Returns an updated DimSetID based on parent's old and new DimSetID
      IF NewParentDimSetID = OldParentDimSetID THEN
        EXIT(DimSetID);
      GetDimensionSet(TempDimSetEntry,DimSetID);
      GetDimensionSet(TempDimSetEntryNew,NewParentDimSetID);
      GetDimensionSet(TempDimSetEntryDeleted,OldParentDimSetID);
      IF TempDimSetEntryDeleted.FINDSET THEN
        REPEAT
          IF TempDimSetEntryNew.GET(NewParentDimSetID,TempDimSetEntryDeleted."Dimension Code") THEN BEGIN
            IF TempDimSetEntryNew."Dimension Value Code" = TempDimSetEntryDeleted."Dimension Value Code" THEN
              TempDimSetEntryNew.DELETE;
            TempDimSetEntryDeleted.DELETE;
          END;
        UNTIL TempDimSetEntryDeleted.NEXT = 0;

      IF TempDimSetEntryDeleted.FINDSET THEN
        REPEAT
          IF TempDimSetEntry.GET(DimSetID,TempDimSetEntryDeleted."Dimension Code") THEN
            TempDimSetEntry.DELETE;
        UNTIL TempDimSetEntryDeleted.NEXT = 0;

      IF TempDimSetEntryNew.FINDSET THEN
        REPEAT
          IF TempDimSetEntry.GET(DimSetID,TempDimSetEntryNew."Dimension Code") THEN BEGIN
            IF TempDimSetEntry."Dimension Value Code" <> TempDimSetEntryNew."Dimension Value Code" THEN BEGIN
              TempDimSetEntry."Dimension Value Code" := TempDimSetEntryNew."Dimension Value Code";
              TempDimSetEntry."Dimension Value ID" := TempDimSetEntryNew."Dimension Value ID";
              TempDimSetEntry.MODIFY;
            END;
          END ELSE BEGIN
            TempDimSetEntry := TempDimSetEntryNew;
            TempDimSetEntry."Dimension Set ID" := DimSetID;
            TempDimSetEntry.INSERT;
          END;
        UNTIL TempDimSetEntryNew.NEXT = 0;

      EXIT(GetDimensionSetID(TempDimSetEntry));
    END;

    LOCAL PROCEDURE GetGLSetup@52();
    VAR
      GLSetup@1000 : Record 98;
    BEGIN
      IF NOT HasGotGLSetup THEN BEGIN
        GLSetup.GET;
        GLSetupShortcutDimCode[1] := GLSetup."Shortcut Dimension 1 Code";
        GLSetupShortcutDimCode[2] := GLSetup."Shortcut Dimension 2 Code";
        GLSetupShortcutDimCode[3] := GLSetup."Shortcut Dimension 3 Code";
        GLSetupShortcutDimCode[4] := GLSetup."Shortcut Dimension 4 Code";
        GLSetupShortcutDimCode[5] := GLSetup."Shortcut Dimension 5 Code";
        GLSetupShortcutDimCode[6] := GLSetup."Shortcut Dimension 6 Code";
        GLSetupShortcutDimCode[7] := GLSetup."Shortcut Dimension 7 Code";
        GLSetupShortcutDimCode[8] := GLSetup."Shortcut Dimension 8 Code";
        HasGotGLSetup := TRUE;
      END;
    END;

    [External]
    PROCEDURE CheckDimIDComb@138(DimSetID@1002 : Integer) : Boolean;
    BEGIN
      TempDimBuf1.RESET;
      TempDimBuf1.DELETEALL;
      DimSetEntry.RESET;
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
      IF DimSetEntry.FINDSET THEN
        REPEAT
          TempDimBuf1.INIT;
          TempDimBuf1."Table ID" := DATABASE::"Dimension Buffer";
          TempDimBuf1."Entry No." := 0;
          TempDimBuf1."Dimension Code" := DimSetEntry."Dimension Code";
          TempDimBuf1."Dimension Value Code" := DimSetEntry."Dimension Value Code";
          TempDimBuf1.INSERT;
        UNTIL DimSetEntry.NEXT = 0;

      DimSetEntry.RESET;
      EXIT(CheckDimComb);
    END;

    [External]
    PROCEDURE CheckDimValuePosting@14(TableID@1000 : ARRAY [10] OF Integer;No@1001 : ARRAY [10] OF Code[20];DimSetID@1003 : Integer) : Boolean;
    VAR
      i@1004 : Integer;
      j@1005 : Integer;
      NoFilter@1006 : ARRAY [2] OF Text[250];
    BEGIN
      IF NOT CheckBlockedDimAndValues(DimSetID) THEN
        EXIT(FALSE);
      DefaultDim.SETFILTER("Value Posting",'<>%1',DefaultDim."Value Posting"::" ");
      DimSetEntry.RESET;
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
      NoFilter[2] := '';
      FOR i := 1 TO ARRAYLEN(TableID) DO BEGIN
        IF (TableID[i] <> 0) AND (No[i] <> '') THEN BEGIN
          DefaultDim.SETRANGE("Table ID",TableID[i]);
          NoFilter[1] := No[i];
          FOR j := 1 TO 2 DO BEGIN
            DefaultDim.SETRANGE("No.",NoFilter[j]);
            IF DefaultDim.FINDSET THEN
              REPEAT
                DimSetEntry.SETRANGE("Dimension Code",DefaultDim."Dimension Code");
                CASE DefaultDim."Value Posting" OF
                  DefaultDim."Value Posting"::"Code Mandatory":
                    BEGIN
                      IF NOT DimSetEntry.FINDFIRST OR (DimSetEntry."Dimension Value Code" = '') THEN BEGIN
                        IF DefaultDim."No." = '' THEN
                          DimValuePostingErr :=
                            STRSUBSTNO(
                              Text004,
                              DefaultDim.FIELDCAPTION("Dimension Value Code"),
                              DefaultDim.FIELDCAPTION("Dimension Code"),DefaultDim."Dimension Code")
                        ELSE
                          DimValuePostingErr :=
                            STRSUBSTNO(
                              Text005,
                              DefaultDim.FIELDCAPTION("Dimension Value Code"),
                              DefaultDim.FIELDCAPTION("Dimension Code"),
                              DefaultDim."Dimension Code",
                              ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DefaultDim."Table ID"),
                              DefaultDim."No.");
                        EXIT(FALSE);
                      END;
                    END;
                  DefaultDim."Value Posting"::"Same Code":
                    BEGIN
                      IF DefaultDim."Dimension Value Code" <> '' THEN BEGIN
                        IF NOT DimSetEntry.FINDFIRST OR
                           (DefaultDim."Dimension Value Code" <> DimSetEntry."Dimension Value Code")
                        THEN BEGIN
                          IF DefaultDim."No." = '' THEN
                            DimValuePostingErr :=
                              STRSUBSTNO(
                                Text006,
                                DefaultDim.FIELDCAPTION("Dimension Value Code"),DefaultDim."Dimension Value Code",
                                DefaultDim.FIELDCAPTION("Dimension Code"),DefaultDim."Dimension Code")
                          ELSE
                            DimValuePostingErr :=
                              STRSUBSTNO(
                                Text007,
                                DefaultDim.FIELDCAPTION("Dimension Value Code"),
                                DefaultDim."Dimension Value Code",
                                DefaultDim.FIELDCAPTION("Dimension Code"),
                                DefaultDim."Dimension Code",
                                ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DefaultDim."Table ID"),
                                DefaultDim."No.");
                          EXIT(FALSE);
                        END;
                      END ELSE BEGIN
                        IF DimSetEntry.FINDFIRST THEN BEGIN
                          IF DefaultDim."No." = '' THEN
                            DimValuePostingErr :=
                              STRSUBSTNO(
                                Text008,
                                DimSetEntry.FIELDCAPTION("Dimension Code"),DimSetEntry."Dimension Code")
                          ELSE
                            DimValuePostingErr :=
                              STRSUBSTNO(
                                Text009,
                                DimSetEntry.FIELDCAPTION("Dimension Code"),
                                DimSetEntry."Dimension Code",
                                ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DefaultDim."Table ID"),
                                DefaultDim."No.");
                          EXIT(FALSE);
                        END;
                      END;
                    END;
                  DefaultDim."Value Posting"::"No Code":
                    BEGIN
                      IF DimSetEntry.FINDFIRST THEN BEGIN
                        IF DefaultDim."No." = '' THEN
                          DimValuePostingErr :=
                            STRSUBSTNO(
                              Text010,
                              DimSetEntry.FIELDCAPTION("Dimension Code"),DimSetEntry."Dimension Code")
                        ELSE
                          DimValuePostingErr :=
                            STRSUBSTNO(
                              Text011,
                              DimSetEntry.FIELDCAPTION("Dimension Code"),
                              DimSetEntry."Dimension Code",
                              ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DefaultDim."Table ID"),
                              DefaultDim."No.");
                        EXIT(FALSE);
                      END;
                    END;
                END;
              UNTIL DefaultDim.NEXT = 0;
          END;
        END;
      END;
      DimSetEntry.RESET;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CheckDimBuffer@64(VAR DimBuffer@1000 : Record 360) : Boolean;
    VAR
      i@1001 : Integer;
    BEGIN
      TempDimBuf1.RESET;
      TempDimBuf1.DELETEALL;
      IF DimBuffer.FINDSET THEN BEGIN
        i := 1;
        REPEAT
          TempDimBuf1.INIT;
          TempDimBuf1."Table ID" := DATABASE::"Dimension Buffer";
          TempDimBuf1."Entry No." := i;
          TempDimBuf1."Dimension Code" := DimBuffer."Dimension Code";
          TempDimBuf1."Dimension Value Code" := DimBuffer."Dimension Value Code";
          TempDimBuf1.INSERT;
          i := i + 1;
        UNTIL DimBuffer.NEXT = 0;
      END;
      EXIT(CheckDimComb);
    END;

    LOCAL PROCEDURE CheckDimComb@3() : Boolean;
    VAR
      DimComb@1000 : Record 350;
      CurrentDimCode@1002 : Code[20];
      CurrentDimValCode@1003 : Code[20];
      DimFilter@1004 : Text[1024];
      FilterTooLong@1005 : Boolean;
    BEGIN
      IF NOT TempDimCombInitialized THEN BEGIN
        TempDimCombInitialized := TRUE;
        IF DimComb.ISEMPTY THEN
          TempDimCombEmpty := TRUE;
      END;

      IF TempDimCombEmpty THEN
        EXIT(TRUE);

      IF NOT TempDimBuf1.FINDSET THEN
        EXIT(TRUE);

      REPEAT
        IF STRLEN(DimFilter) + 1 + STRLEN(TempDimBuf1."Dimension Code") > MAXSTRLEN(DimFilter) THEN
          FilterTooLong := TRUE
        ELSE
          IF DimFilter = '' THEN
            DimFilter := TempDimBuf1."Dimension Code"
          ELSE
            DimFilter := DimFilter + '|' + TempDimBuf1."Dimension Code";
      UNTIL FilterTooLong OR (TempDimBuf1.NEXT = 0);

      IF NOT FilterTooLong THEN BEGIN
        DimComb.SETFILTER("Dimension 1 Code",DimFilter);
        DimComb.SETFILTER("Dimension 2 Code",DimFilter);
        IF DimComb.FINDSET THEN
          REPEAT
            IF DimComb."Combination Restriction" = DimComb."Combination Restriction"::Blocked THEN BEGIN
              DimCombErr := STRSUBSTNO(Text000,DimComb."Dimension 1 Code",DimComb."Dimension 2 Code");
              EXIT(FALSE);
            END ELSE BEGIN
              TempDimBuf1.SETRANGE("Dimension Code",DimComb."Dimension 1 Code");
              TempDimBuf1.FINDFIRST;
              CurrentDimCode := TempDimBuf1."Dimension Code";
              CurrentDimValCode := TempDimBuf1."Dimension Value Code";
              TempDimBuf1.SETRANGE("Dimension Code",DimComb."Dimension 2 Code");
              TempDimBuf1.FINDFIRST;
              IF NOT
                 CheckDimValueComb(
                   TempDimBuf1."Dimension Code",TempDimBuf1."Dimension Value Code",
                   CurrentDimCode,CurrentDimValCode)
              THEN
                EXIT(FALSE);
              IF NOT
                 CheckDimValueComb(
                   CurrentDimCode,CurrentDimValCode,
                   TempDimBuf1."Dimension Code",TempDimBuf1."Dimension Value Code")
              THEN
                EXIT(FALSE);
            END;
          UNTIL DimComb.NEXT = 0;
        EXIT(TRUE);
      END;

      WHILE TempDimBuf1.FINDFIRST DO BEGIN
        CurrentDimCode := TempDimBuf1."Dimension Code";
        CurrentDimValCode := TempDimBuf1."Dimension Value Code";
        TempDimBuf1.DELETE;
        IF TempDimBuf1.FINDSET THEN
          REPEAT
            IF CurrentDimCode > TempDimBuf1."Dimension Code" THEN BEGIN
              IF DimComb.GET(TempDimBuf1."Dimension Code",CurrentDimCode) THEN BEGIN
                IF DimComb."Combination Restriction" = DimComb."Combination Restriction"::Blocked THEN BEGIN
                  DimCombErr :=
                    STRSUBSTNO(
                      Text000,
                      TempDimBuf1."Dimension Code",CurrentDimCode);
                  EXIT(FALSE);
                END;
                IF NOT
                   CheckDimValueComb(
                     TempDimBuf1."Dimension Code",TempDimBuf1."Dimension Value Code",
                     CurrentDimCode,CurrentDimValCode)
                THEN
                  EXIT(FALSE);
              END;
            END ELSE BEGIN
              IF DimComb.GET(CurrentDimCode,TempDimBuf1."Dimension Code") THEN BEGIN
                IF DimComb."Combination Restriction" = DimComb."Combination Restriction"::Blocked THEN BEGIN
                  DimCombErr :=
                    STRSUBSTNO(
                      Text000,
                      CurrentDimCode,TempDimBuf1."Dimension Code");
                  EXIT(FALSE);
                END;
                IF NOT
                   CheckDimValueComb(
                     CurrentDimCode,CurrentDimValCode,TempDimBuf1."Dimension Code",
                     TempDimBuf1."Dimension Value Code")
                THEN
                  EXIT(FALSE);
              END;
            END;
          UNTIL TempDimBuf1.NEXT = 0;
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckDimValueComb@9(Dim1@1000 : Code[20];Dim1Value@1001 : Code[20];Dim2@1002 : Code[20];Dim2Value@1003 : Code[20]) : Boolean;
    BEGIN
      IF DimValComb.GET(Dim1,Dim1Value,Dim2,Dim2Value) THEN BEGIN
        DimCombErr :=
          STRSUBSTNO(Text001,
            Dim1,Dim1Value,Dim2,Dim2Value);
        EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE GetDimCombErr@41() : Text[250];
    BEGIN
      EXIT(DimCombErr);
    END;

    [External]
    PROCEDURE UpdateDefaultDim@59(TableID@1000 : Integer;No@1001 : Code[20];VAR GlobalDim1Code@1002 : Code[20];VAR GlobalDim2Code@1003 : Code[20]);
    VAR
      DefaultDim@1004 : Record 352;
    BEGIN
      GetGLSetup;
      IF DefaultDim.GET(TableID,No,GLSetupShortcutDimCode[1]) THEN
        GlobalDim1Code := DefaultDim."Dimension Value Code"
      ELSE
        GlobalDim1Code := '';
      IF DefaultDim.GET(TableID,No,GLSetupShortcutDimCode[2]) THEN
        GlobalDim2Code := DefaultDim."Dimension Value Code"
      ELSE
        GlobalDim2Code := '';
    END;

    [External]
    PROCEDURE GetDefaultDimID@8(TableID@1000 : ARRAY [10] OF Integer;No@1001 : ARRAY [10] OF Code[20];SourceCode@1002 : Code[20];VAR GlobalDim1Code@1003 : Code[20];VAR GlobalDim2Code@1004 : Code[20];InheritFromDimSetID@1014 : Integer;InheritFromTableNo@1015 : Integer) : Integer;
    VAR
      DimVal@1012 : Record 349;
      DefaultDimPriority1@1005 : Record 354;
      DefaultDimPriority2@1006 : Record 354;
      DefaultDim@1007 : Record 352;
      TempDimSetEntry@1011 : TEMPORARY Record 480;
      TempDimSetEntry0@1016 : TEMPORARY Record 480;
      i@1010 : Integer;
      j@1009 : Integer;
      NoFilter@1008 : ARRAY [2] OF Code[20];
      NewDimSetID@1013 : Integer;
    BEGIN
      OnBeforeGetDefaultDimID(TableID,No,SourceCode,GlobalDim1Code,GlobalDim2Code,InheritFromDimSetID,InheritFromTableNo);

      GetGLSetup;
      IF InheritFromDimSetID > 0 THEN
        GetDimensionSet(TempDimSetEntry0,InheritFromDimSetID);
      TempDimBuf2.RESET;
      TempDimBuf2.DELETEALL;
      IF TempDimSetEntry0.FINDSET THEN
        REPEAT
          TempDimBuf2.INIT;
          TempDimBuf2."Table ID" := InheritFromTableNo;
          TempDimBuf2."Entry No." := 0;
          TempDimBuf2."Dimension Code" := TempDimSetEntry0."Dimension Code";
          TempDimBuf2."Dimension Value Code" := TempDimSetEntry0."Dimension Value Code";
          TempDimBuf2.INSERT;
        UNTIL TempDimSetEntry0.NEXT = 0;

      NoFilter[2] := '';
      FOR i := 1 TO ARRAYLEN(TableID) DO BEGIN
        IF (TableID[i] <> 0) AND (No[i] <> '') THEN BEGIN
          DefaultDim.SETRANGE("Table ID",TableID[i]);
          NoFilter[1] := No[i];
          FOR j := 1 TO 2 DO BEGIN
            DefaultDim.SETRANGE("No.",NoFilter[j]);
            IF DefaultDim.FINDSET THEN
              REPEAT
                IF DefaultDim."Dimension Value Code" <> '' THEN BEGIN
                  TempDimBuf2.SETRANGE("Dimension Code",DefaultDim."Dimension Code");
                  IF NOT TempDimBuf2.FINDFIRST THEN BEGIN
                    TempDimBuf2.INIT;
                    TempDimBuf2."Table ID" := DefaultDim."Table ID";
                    TempDimBuf2."Entry No." := 0;
                    TempDimBuf2."Dimension Code" := DefaultDim."Dimension Code";
                    TempDimBuf2."Dimension Value Code" := DefaultDim."Dimension Value Code";
                    TempDimBuf2.INSERT;
                  END ELSE BEGIN
                    IF DefaultDimPriority1.GET(SourceCode,DefaultDim."Table ID") THEN BEGIN
                      IF DefaultDimPriority2.GET(SourceCode,TempDimBuf2."Table ID") THEN BEGIN
                        IF DefaultDimPriority1.Priority < DefaultDimPriority2.Priority THEN BEGIN
                          TempDimBuf2.DELETE;
                          TempDimBuf2."Table ID" := DefaultDim."Table ID";
                          TempDimBuf2."Entry No." := 0;
                          TempDimBuf2."Dimension Value Code" := DefaultDim."Dimension Value Code";
                          TempDimBuf2.INSERT;
                        END;
                      END ELSE BEGIN
                        TempDimBuf2.DELETE;
                        TempDimBuf2."Table ID" := DefaultDim."Table ID";
                        TempDimBuf2."Entry No." := 0;
                        TempDimBuf2."Dimension Value Code" := DefaultDim."Dimension Value Code";
                        TempDimBuf2.INSERT;
                      END;
                    END;
                  END;
                  IF GLSetupShortcutDimCode[1] = TempDimBuf2."Dimension Code" THEN
                    GlobalDim1Code := TempDimBuf2."Dimension Value Code";
                  IF GLSetupShortcutDimCode[2] = TempDimBuf2."Dimension Code" THEN
                    GlobalDim2Code := TempDimBuf2."Dimension Value Code";
                END;
              UNTIL DefaultDim.NEXT = 0;
          END;
        END;
      END;
      TempDimBuf2.RESET;
      IF TempDimBuf2.FINDSET THEN BEGIN
        REPEAT
          DimVal.GET(TempDimBuf2."Dimension Code",TempDimBuf2."Dimension Value Code");
          TempDimSetEntry."Dimension Code" := TempDimBuf2."Dimension Code";
          TempDimSetEntry."Dimension Value Code" := TempDimBuf2."Dimension Value Code";
          TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
          TempDimSetEntry.INSERT;
        UNTIL TempDimBuf2.NEXT = 0;
        NewDimSetID := GetDimensionSetID(TempDimSetEntry);
      END;
      EXIT(NewDimSetID);
    END;

    [External]
    PROCEDURE GetRecDefaultDimID@150(RecVariant@1011 : Variant;CurrFieldNo@1012 : Integer;TableID@1000 : ARRAY [10] OF Integer;No@1001 : ARRAY [10] OF Code[20];SourceCode@1002 : Code[20];VAR GlobalDim1Code@1003 : Code[20];VAR GlobalDim2Code@1004 : Code[20];InheritFromDimSetID@1014 : Integer;InheritFromTableNo@1015 : Integer) : Integer;
    BEGIN
      OnGetRecDefaultDimID(RecVariant,CurrFieldNo,TableID,No,SourceCode,InheritFromDimSetID,InheritFromTableNo);
      EXIT(GetDefaultDimID(TableID,No,SourceCode,GlobalDim1Code,GlobalDim2Code,InheritFromDimSetID,InheritFromTableNo));
    END;

    PROCEDURE AddFirstToTableIdArray@256(VAR TableID@1000 : ARRAY [10] OF Integer;VAR No@1001 : ARRAY [10] OF Code[20];NewTableId@1002 : Integer;NewNo@1003 : Code[20]);
    VAR
      Index@1004 : Integer;
    BEGIN
      IF NewNo = '' THEN
        EXIT;
      FOR Index := ARRAYLEN(TableID) DOWNTO 2 DO BEGIN
        TableID[Index] := TableID[Index - 1];
        No[Index] := No[Index - 1];
      END;
      TableID[1] := NewTableId;
      No[1] := NewNo;
    END;

    PROCEDURE AddLastToTableIdArray@257(VAR TableID@1000 : ARRAY [10] OF Integer;VAR No@1001 : ARRAY [10] OF Code[20];NewTableId@1002 : Integer;NewNo@1003 : Code[20]);
    VAR
      Index@1004 : Integer;
    BEGIN
      IF NewNo = '' THEN
        EXIT;
      FOR Index := 1 TO ARRAYLEN(TableID) DO
        IF (No[Index] = '') OR (Index = ARRAYLEN(TableID)) THEN BEGIN
          TableID[Index] := NewTableId;
          No[Index] := NewNo;
          EXIT;
        END;
    END;

    [External]
    PROCEDURE TypeToTableID1@11(Type@1000 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee') : Integer;
    BEGIN
      CASE Type OF
        Type::"G/L Account":
          EXIT(DATABASE::"G/L Account");
        Type::Customer:
          EXIT(DATABASE::Customer);
        Type::Vendor:
          EXIT(DATABASE::Vendor);
        Type::Employee:
          EXIT(DATABASE::Employee);
        Type::"Bank Account":
          EXIT(DATABASE::"Bank Account");
        Type::"Fixed Asset":
          EXIT(DATABASE::"Fixed Asset");
        Type::"IC Partner":
          EXIT(DATABASE::"IC Partner");
      END;
    END;

    [External]
    PROCEDURE TypeToTableID2@13(Type@1000 : 'Resource,Item,G/L Account') : Integer;
    VAR
      TableID@1001 : Integer;
    BEGIN
      CASE Type OF
        Type::Resource:
          EXIT(DATABASE::Resource);
        Type::Item:
          EXIT(DATABASE::Item);
        Type::"G/L Account":
          EXIT(DATABASE::"G/L Account");
        ELSE BEGIN
          OnTypeToTableID2(TableID,Type);
          EXIT(TableID);
        END;
      END;
    END;

    [External]
    PROCEDURE TypeToTableID3@16(Type@1000 : ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)') : Integer;
    BEGIN
      CASE Type OF
        Type::" ":
          EXIT(0);
        Type::"G/L Account":
          EXIT(DATABASE::"G/L Account");
        Type::Item:
          EXIT(DATABASE::Item);
        Type::Resource:
          EXIT(DATABASE::Resource);
        Type::"Fixed Asset":
          EXIT(DATABASE::"Fixed Asset");
        Type::"Charge (Item)":
          EXIT(DATABASE::"Item Charge");
      END;
    END;

    [External]
    PROCEDURE TypeToTableID4@1(Type@1000 : ' ,Item,Resource') : Integer;
    BEGIN
      CASE Type OF
        Type::" ":
          EXIT(0);
        Type::Item:
          EXIT(DATABASE::Item);
        Type::Resource:
          EXIT(DATABASE::Resource);
      END;
    END;

    [External]
    PROCEDURE TypeToTableID5@119(Type@1000 : ' ,Item,Resource,Cost,G/L Account') : Integer;
    BEGIN
      CASE Type OF
        Type::" ":
          EXIT(0);
        Type::Item:
          EXIT(DATABASE::Item);
        Type::Resource:
          EXIT(DATABASE::Resource);
        Type::Cost:
          EXIT(DATABASE::"Service Cost");
        Type::"G/L Account":
          EXIT(DATABASE::"G/L Account");
      END;
    END;

    [External]
    PROCEDURE DeleteDefaultDim@58(TableID@1000 : Integer;No@1001 : Code[20]);
    VAR
      DefaultDim@1002 : Record 352;
    BEGIN
      DefaultDim.SETRANGE("Table ID",TableID);
      DefaultDim.SETRANGE("No.",No);
      IF NOT DefaultDim.ISEMPTY THEN
        DefaultDim.DELETEALL;
    END;

    [External]
    PROCEDURE LookupDimValueCode@21(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    VAR
      DimVal@1002 : Record 349;
      GLSetup@1003 : Record 98;
    BEGIN
      GetGLSetup;
      IF GLSetupShortcutDimCode[FieldNumber] = '' THEN
        ERROR(Text002,GLSetup.TABLECAPTION);
      DimVal.SETRANGE("Dimension Code",GLSetupShortcutDimCode[FieldNumber]);
      DimVal."Dimension Code" := GLSetupShortcutDimCode[FieldNumber];
      DimVal.Code := ShortcutDimCode;
      IF PAGE.RUNMODAL(0,DimVal) = ACTION::LookupOK THEN BEGIN
        CheckDim(DimVal."Dimension Code");
        CheckDimValue(DimVal."Dimension Code",DimVal.Code);
        ShortcutDimCode := DimVal.Code;
      END;
    END;

    [External]
    PROCEDURE ValidateDimValueCode@22(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20]);
    VAR
      DimVal@1002 : Record 349;
      GLSetup@1003 : Record 98;
    BEGIN
      GetGLSetup;
      IF (GLSetupShortcutDimCode[FieldNumber] = '') AND (ShortcutDimCode <> '') THEN
        ERROR(Text002,GLSetup.TABLECAPTION);
      DimVal.SETRANGE("Dimension Code",GLSetupShortcutDimCode[FieldNumber]);
      IF ShortcutDimCode <> '' THEN BEGIN
        DimVal.SETRANGE(Code,ShortcutDimCode);
        IF NOT DimVal.FINDFIRST THEN BEGIN
          DimVal.SETFILTER(Code,STRSUBSTNO('%1*',ShortcutDimCode));
          IF DimVal.FINDFIRST THEN
            ShortcutDimCode := DimVal.Code
          ELSE
            ERROR(
              STRSUBSTNO(Text003,
                ShortcutDimCode,DimVal.FIELDCAPTION(Code)));
        END;
      END;
    END;

    [External]
    PROCEDURE ValidateShortcutDimValues@127(FieldNumber@1000 : Integer;VAR ShortcutDimCode@1001 : Code[20];VAR DimSetID@1004 : Integer);
    VAR
      DimVal@1002 : Record 349;
      TempDimSetEntry@1005 : TEMPORARY Record 480;
    BEGIN
      ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimVal."Dimension Code" := GLSetupShortcutDimCode[FieldNumber];
      IF ShortcutDimCode <> '' THEN BEGIN
        DimVal.GET(DimVal."Dimension Code",ShortcutDimCode);
        IF NOT CheckDim(DimVal."Dimension Code") THEN
          ERROR(GetDimErr);
        IF NOT CheckDimValue(DimVal."Dimension Code",ShortcutDimCode) THEN
          ERROR(GetDimErr);
      END;
      GetDimensionSet(TempDimSetEntry,DimSetID);
      IF TempDimSetEntry.GET(TempDimSetEntry."Dimension Set ID",DimVal."Dimension Code") THEN
        IF TempDimSetEntry."Dimension Value Code" <> ShortcutDimCode THEN
          TempDimSetEntry.DELETE;
      IF ShortcutDimCode <> '' THEN BEGIN
        TempDimSetEntry."Dimension Code" := DimVal."Dimension Code";
        TempDimSetEntry."Dimension Value Code" := DimVal.Code;
        TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
        IF TempDimSetEntry.INSERT THEN;
      END;
      DimSetID := GetDimensionSetID(TempDimSetEntry);
    END;

    [External]
    PROCEDURE SaveDefaultDim@53(TableID@1000 : Integer;No@1001 : Code[20];FieldNumber@1002 : Integer;ShortcutDimCode@1003 : Code[20]);
    VAR
      DefaultDim@1004 : Record 352;
    BEGIN
      GetGLSetup;
      IF ShortcutDimCode <> '' THEN BEGIN
        IF DefaultDim.GET(TableID,No,GLSetupShortcutDimCode[FieldNumber])
        THEN BEGIN
          DefaultDim.VALIDATE("Dimension Value Code",ShortcutDimCode);
          DefaultDim.MODIFY;
        END ELSE BEGIN
          DefaultDim.INIT;
          DefaultDim.VALIDATE("Table ID",TableID);
          DefaultDim.VALIDATE("No.",No);
          DefaultDim.VALIDATE("Dimension Code",GLSetupShortcutDimCode[FieldNumber]);
          DefaultDim.VALIDATE("Dimension Value Code",ShortcutDimCode);
          DefaultDim.INSERT;
        END;
      END ELSE
        IF DefaultDim.GET(TableID,No,GLSetupShortcutDimCode[FieldNumber]) THEN
          DefaultDim.DELETE;
    END;

    [External]
    PROCEDURE GetShortcutDimensions@129(DimSetID@1000 : Integer;VAR ShortcutDimCode@1004 : ARRAY [8] OF Code[20]);
    VAR
      i@1006 : Integer;
    BEGIN
      GetGLSetup;
      FOR i := 3 TO 8 DO BEGIN
        ShortcutDimCode[i] := '';
        IF GLSetupShortcutDimCode[i] <> '' THEN
          IF DimSetEntry.GET(DimSetID,GLSetupShortcutDimCode[i]) THEN
            ShortcutDimCode[i] := DimSetEntry."Dimension Value Code";
      END;
    END;

    [External]
    PROCEDURE CheckDimBufferValuePosting@68(VAR DimBuffer@1000 : Record 360;TableID@1001 : ARRAY [10] OF Integer;No@1002 : ARRAY [10] OF Code[20]) : Boolean;
    VAR
      i@1005 : Integer;
    BEGIN
      TempDimBuf2.RESET;
      TempDimBuf2.DELETEALL;
      IF DimBuffer.FINDSET THEN BEGIN
        i := 1;
        REPEAT
          IF (NOT CheckDimValue(
                DimBuffer."Dimension Code",DimBuffer."Dimension Value Code")) OR
             (NOT CheckDim(DimBuffer."Dimension Code"))
          THEN BEGIN
            DimValuePostingErr := DimErr;
            EXIT(FALSE);
          END;
          TempDimBuf2.INIT;
          TempDimBuf2."Entry No." := i;
          TempDimBuf2."Dimension Code" := DimBuffer."Dimension Code";
          TempDimBuf2."Dimension Value Code" := DimBuffer."Dimension Value Code";
          TempDimBuf2.INSERT;
          i := i + 1;
        UNTIL DimBuffer.NEXT = 0;
      END;
      EXIT(CheckValuePosting(TableID,No));
    END;

    LOCAL PROCEDURE CheckValuePosting@36(TableID@1000 : ARRAY [10] OF Integer;No@1001 : ARRAY [10] OF Code[20]) : Boolean;
    VAR
      DefaultDim@1002 : Record 352;
      i@1004 : Integer;
      j@1005 : Integer;
      NoFilter@1006 : ARRAY [2] OF Text[250];
    BEGIN
      DefaultDim.SETFILTER("Value Posting",'<>%1',DefaultDim."Value Posting"::" ");
      NoFilter[2] := '';
      FOR i := 1 TO ARRAYLEN(TableID) DO BEGIN
        IF (TableID[i] <> 0) AND (No[i] <> '') THEN BEGIN
          DefaultDim.SETRANGE("Table ID",TableID[i]);
          NoFilter[1] := No[i];
          FOR j := 1 TO 2 DO BEGIN
            DefaultDim.SETRANGE("No.",NoFilter[j]);
            IF DefaultDim.FINDSET THEN BEGIN
              REPEAT
                TempDimBuf2.SETRANGE("Dimension Code",DefaultDim."Dimension Code");
                CASE DefaultDim."Value Posting" OF
                  DefaultDim."Value Posting"::"Code Mandatory":
                    BEGIN
                      IF (NOT TempDimBuf2.FINDFIRST) OR
                         (TempDimBuf2."Dimension Value Code" = '')
                      THEN BEGIN
                        IF DefaultDim."No." = '' THEN
                          DimValuePostingErr :=
                            STRSUBSTNO(
                              Text004,
                              DefaultDim.FIELDCAPTION("Dimension Value Code"),
                              DefaultDim.FIELDCAPTION("Dimension Code"),DefaultDim."Dimension Code")
                        ELSE
                          DimValuePostingErr :=
                            STRSUBSTNO(
                              Text005,
                              DefaultDim.FIELDCAPTION("Dimension Value Code"),
                              DefaultDim.FIELDCAPTION("Dimension Code"),
                              DefaultDim."Dimension Code",
                              ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DefaultDim."Table ID"),
                              DefaultDim."No.");
                        EXIT(FALSE);
                      END;
                    END;
                  DefaultDim."Value Posting"::"Same Code":
                    BEGIN
                      IF DefaultDim."Dimension Value Code" <> '' THEN BEGIN
                        IF (NOT TempDimBuf2.FINDFIRST) OR
                           (DefaultDim."Dimension Value Code" <> TempDimBuf2."Dimension Value Code")
                        THEN BEGIN
                          IF DefaultDim."No." = '' THEN
                            DimValuePostingErr :=
                              STRSUBSTNO(
                                Text006,
                                DefaultDim.FIELDCAPTION("Dimension Value Code"),DefaultDim."Dimension Value Code",
                                DefaultDim.FIELDCAPTION("Dimension Code"),DefaultDim."Dimension Code")
                          ELSE
                            DimValuePostingErr :=
                              STRSUBSTNO(
                                Text007,
                                DefaultDim.FIELDCAPTION("Dimension Value Code"),
                                DefaultDim."Dimension Value Code",
                                DefaultDim.FIELDCAPTION("Dimension Code"),
                                DefaultDim."Dimension Code",
                                ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DefaultDim."Table ID"),
                                DefaultDim."No.");
                          EXIT(FALSE);
                        END;
                      END ELSE BEGIN
                        IF TempDimBuf2.FINDFIRST THEN BEGIN
                          IF DefaultDim."No." = '' THEN
                            DimValuePostingErr :=
                              STRSUBSTNO(
                                Text008,
                                TempDimBuf2.FIELDCAPTION("Dimension Code"),TempDimBuf2."Dimension Code")
                          ELSE
                            DimValuePostingErr :=
                              STRSUBSTNO(
                                Text009,
                                TempDimBuf2.FIELDCAPTION("Dimension Code"),
                                TempDimBuf2."Dimension Code",
                                ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DefaultDim."Table ID"),
                                DefaultDim."No.");
                          EXIT(FALSE);
                        END;
                      END;
                    END;
                  DefaultDim."Value Posting"::"No Code":
                    BEGIN
                      IF TempDimBuf2.FINDFIRST THEN BEGIN
                        IF DefaultDim."No." = '' THEN
                          DimValuePostingErr :=
                            STRSUBSTNO(
                              Text010,
                              TempDimBuf2.FIELDCAPTION("Dimension Code"),TempDimBuf2."Dimension Code")
                        ELSE
                          DimValuePostingErr :=
                            STRSUBSTNO(
                              Text011,
                              TempDimBuf2.FIELDCAPTION("Dimension Code"),
                              TempDimBuf2."Dimension Code",
                              ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DefaultDim."Table ID"),
                              DefaultDim."No.");
                        EXIT(FALSE);
                      END;
                    END;
                END;
              UNTIL DefaultDim.NEXT = 0;
              TempDimBuf2.RESET;
            END;
          END;
        END;
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE GetDimValuePostingErr@98() : Text[250];
    BEGIN
      EXIT(DimValuePostingErr);
    END;

    PROCEDURE DefaultDimObjectNoList@40(VAR TempAllObjWithCaption@1000 : TEMPORARY Record 2000000058);
    BEGIN
      DefaultDimObjectNoWithoutGlobalDimsList(TempAllObjWithCaption);
      DefaultDimObjectNoWithGlobalDimsList(TempAllObjWithCaption);
    END;

    PROCEDURE DefaultDimObjectNoWithGlobalDimsList@48(VAR TempAllObjWithCaption@1000 : TEMPORARY Record 2000000058);
    VAR
      TempDimField@1002 : TEMPORARY Record 2000000041;
      TempDimSetIDField@1001 : TEMPORARY Record 2000000041;
    BEGIN
      TempDimField.SETFILTER(
        TableNo,'<>%1&<>%2&<>%3',
        DATABASE::"General Ledger Setup",DATABASE::"Job Task",DATABASE::"Change Global Dim. Header");
      TempDimField.SETFILTER(ObsoleteState,'<>%1',TempDimField.ObsoleteState::Removed);
      TempDimField.SETFILTER(FieldName,'*Global Dimension*');
      TempDimField.SETRANGE(Type,TempDimField.Type::Code);
      TempDimField.SETRANGE(Len,20);
      FillNormalFieldBuffer(TempDimField);
      TempDimSetIDField.SETRANGE(RelationTableNo,DATABASE::"Dimension Set Entry");
      FillNormalFieldBuffer(TempDimSetIDField);
      IF TempDimField.FINDSET THEN
        REPEAT
          TempDimSetIDField.SETRANGE(TableNo,TempDimField.TableNo);
          IF TempDimSetIDField.ISEMPTY THEN
            InsertObject(TempAllObjWithCaption,TempDimField.TableNo);
        UNTIL TempDimField.NEXT = 0;
      OnAfterSetupObjectNoList(TempAllObjWithCaption);
    END;

    LOCAL PROCEDURE DefaultDimObjectNoWithoutGlobalDimsList@50(VAR TempAllObjWithCaption@1000 : TEMPORARY Record 2000000058);
    BEGIN
      DefaultDimInsertTempObject(TempAllObjWithCaption,DATABASE::"IC Partner");
      DefaultDimInsertTempObject(TempAllObjWithCaption,DATABASE::"Service Order Type");
      DefaultDimInsertTempObject(TempAllObjWithCaption,DATABASE::"Service Item Group");
      DefaultDimInsertTempObject(TempAllObjWithCaption,DATABASE::"Service Item");
      DefaultDimInsertTempObject(TempAllObjWithCaption,DATABASE::"Service Contract Template");
      DefaultDimInsertTempObject(TempAllObjWithCaption,DATABASE::"Service Contract Header");
    END;

    LOCAL PROCEDURE DefaultDimInsertTempObject@51(VAR TempAllObjWithCaption@1001 : TEMPORARY Record 2000000058;TableID@1000 : Integer);
    BEGIN
      TempAllObjWithCaption.INIT;
      TempAllObjWithCaption."Object Type" := TempAllObjWithCaption."Object Type"::Table;
      TempAllObjWithCaption."Object ID" := TableID;
      TempAllObjWithCaption.INSERT;
    END;

    PROCEDURE GlobalDimObjectNoList@49(VAR TempAllObjWithCaption@1000 : TEMPORARY Record 2000000058);
    VAR
      Field@1001 : Record 2000000041;
      TempDimField@1002 : TEMPORARY Record 2000000041;
      TempDimSetIDField@1003 : TEMPORARY Record 2000000041;
      LastTableNo@1004 : Integer;
    BEGIN
      TempDimSetIDField.SETRANGE(RelationTableNo,DATABASE::"Dimension Set Entry");
      FillNormalFieldBuffer(TempDimSetIDField);
      TempDimField.SETFILTER(FieldName,'*Global Dimension*|*Shortcut Dimension*|*Global Dim.*');
      TempDimField.SETFILTER(ObsoleteState,'<>%1',TempDimField.ObsoleteState::Removed);
      TempDimField.SETRANGE(Type,TempDimField.Type::Code);
      TempDimField.SETRANGE(Len,20);
      FillNormalFieldBuffer(TempDimField);
      TempDimField.RESET;
      IF TempDimSetIDField.FINDSET THEN
        REPEAT
          TempDimField.SETRANGE(TableNo,TempDimSetIDField.TableNo);
          IF NOT TempDimField.ISEMPTY THEN BEGIN
            InsertObject(TempAllObjWithCaption,TempDimSetIDField.TableNo);
            TempDimField.DELETEALL;
          END;
        UNTIL TempDimSetIDField.NEXT = 0;

      TempDimField.RESET;
      TempDimField.SETFILTER(ObsoleteState,'<>%1',TempDimField.ObsoleteState::Removed);
      TempDimField.SETFILTER(FieldName,'*Global Dim.*');
      IF TempDimField.FINDSET THEN
        REPEAT
          IF LastTableNo <> TempDimField.TableNo THEN BEGIN
            LastTableNo := TempDimField.TableNo;
            // Field No. 2 must relate to a table with Dim Set ID
            IF Field.GET(TempDimField.TableNo,2) THEN BEGIN
              TempDimSetIDField.SETRANGE(TableNo,Field.RelationTableNo);
              IF NOT TempDimSetIDField.ISEMPTY THEN
                InsertObject(TempAllObjWithCaption,TempDimField.TableNo);
            END;
          END;
        UNTIL TempDimField.NEXT = 0;
    END;

    PROCEDURE JobTaskDimObjectNoList@55(VAR TempAllObjWithCaption@1000 : TEMPORARY Record 2000000058);
    BEGIN
      // Table 1001 "Job Task" is an exception
      // it has Table 1002 "Job Task Dimension" that implements default dimension behavior
      InsertObject(TempAllObjWithCaption,DATABASE::"Job Task");
    END;

    PROCEDURE FindDimFieldInTable@57(TableNo@1000 : Integer;FieldNameFilter@1001 : Text;VAR Field@1002 : Record 2000000041) : Boolean;
    BEGIN
      Field.SETRANGE(TableNo,TableNo);
      Field.SETFILTER(FieldName,'*' + FieldNameFilter + '*');
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      Field.SETRANGE(Class,Field.Class::Normal);
      Field.SETRANGE(Type,Field.Type::Code);
      Field.SETRANGE(Len,20);
      IF Field.FINDFIRST THEN
        EXIT(TRUE);
    END;

    LOCAL PROCEDURE FillNormalFieldBuffer@62(VAR TempField@1000 : Record 2000000041);
    VAR
      Field@1001 : Record 2000000041;
    BEGIN
      Field.COPYFILTERS(TempField);
      Field.SETRANGE(Class,Field.Class::Normal);
      Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
      IF Field.FINDSET THEN
        REPEAT
          TempField := Field;
          TempField.INSERT;
        UNTIL Field.NEXT = 0;
    END;

    [External]
    PROCEDURE GetDocDimConsistencyErr@56() : Text[250];
    BEGIN
      EXIT(DocDimConsistencyErr);
    END;

    [External]
    PROCEDURE CheckDim@60(DimCode@1000 : Code[20]) : Boolean;
    VAR
      Dim@1001 : Record 348;
    BEGIN
      IF Dim.GET(DimCode) THEN BEGIN
        IF Dim.Blocked THEN BEGIN
          DimErr :=
            STRSUBSTNO(Text014,Dim.TABLECAPTION,DimCode);
          EXIT(FALSE);
        END;
      END ELSE BEGIN
        DimErr :=
          STRSUBSTNO(Text015,Dim.TABLECAPTION,DimCode);
        EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CheckDimValue@61(DimCode@1000 : Code[20];DimValCode@1001 : Code[20]) : Boolean;
    VAR
      DimVal@1002 : Record 349;
    BEGIN
      IF (DimCode <> '') AND (DimValCode <> '') THEN BEGIN
        IF DimVal.GET(DimCode,DimValCode) THEN BEGIN
          IF DimVal.Blocked THEN BEGIN
            DimErr :=
              STRSUBSTNO(
                Text016,DimVal.TABLECAPTION,DimCode,DimValCode);
            EXIT(FALSE);
          END;
          IF NOT (DimVal."Dimension Value Type" IN
                  [DimVal."Dimension Value Type"::Standard,
                   DimVal."Dimension Value Type"::"Begin-Total"])
          THEN BEGIN
            DimErr :=
              STRSUBSTNO(Text017,DimVal.FIELDCAPTION("Dimension Value Type"),
                DimVal.TABLECAPTION,DimCode,DimValCode,FORMAT(DimVal."Dimension Value Type"));
            EXIT(FALSE);
          END;
        END ELSE BEGIN
          DimErr :=
            STRSUBSTNO(
              Text018,DimVal.TABLECAPTION,DimCode);
          EXIT(FALSE);
        END;
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckBlockedDimAndValues@6(DimSetID@1000 : Integer) : Boolean;
    VAR
      DimSetEntry@1001 : Record 480;
    BEGIN
      IF DimSetID = 0 THEN
        EXIT(TRUE);
      DimSetEntry.RESET;
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
      IF DimSetEntry.FINDSET THEN
        REPEAT
          IF NOT CheckDim(DimSetEntry."Dimension Code") OR
             NOT CheckDimValue(DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code")
          THEN BEGIN
            DimValuePostingErr := DimErr;
            EXIT(FALSE);
          END;
        UNTIL DimSetEntry.NEXT = 0;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE GetDimErr@71() : Text[250];
    BEGIN
      EXIT(DimErr);
    END;

    [External]
    PROCEDURE LookupDimValueCodeNoUpdate@20(FieldNumber@1000 : Integer);
    VAR
      DimVal@1001 : Record 349;
      GLSetup@1002 : Record 98;
    BEGIN
      GetGLSetup;
      IF GLSetupShortcutDimCode[FieldNumber] = '' THEN
        ERROR(Text002,GLSetup.TABLECAPTION);
      DimVal.SETRANGE("Dimension Code",GLSetupShortcutDimCode[FieldNumber]);
      IF PAGE.RUNMODAL(0,DimVal) = ACTION::LookupOK THEN;
    END;

    [External]
    PROCEDURE CopyJnlLineDimToICJnlDim@93(TableID@1000 : Integer;TransactionNo@1001 : Integer;PartnerCode@1002 : Code[20];TransactionSource@1008 : Option;LineNo@1003 : Integer;DimSetID@1004 : Integer);
    VAR
      InOutBoxJnlLineDim@1005 : Record 423;
      DimSetEntry@1009 : Record 480;
      ICDim@1006 : Code[20];
      ICDimValue@1007 : Code[20];
    BEGIN
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
      IF DimSetEntry.FINDSET THEN
        REPEAT
          ICDim := ConvertDimtoICDim(DimSetEntry."Dimension Code");
          ICDimValue := ConvertDimValuetoICDimVal(DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
          IF (ICDim <> '') AND (ICDimValue <> '') THEN BEGIN
            InOutBoxJnlLineDim.INIT;
            InOutBoxJnlLineDim."Table ID" := TableID;
            InOutBoxJnlLineDim."IC Partner Code" := PartnerCode;
            InOutBoxJnlLineDim."Transaction No." := TransactionNo;
            InOutBoxJnlLineDim."Transaction Source" := TransactionSource;
            InOutBoxJnlLineDim."Line No." := LineNo;
            InOutBoxJnlLineDim."Dimension Code" := ICDim;
            InOutBoxJnlLineDim."Dimension Value Code" := ICDimValue;
            InOutBoxJnlLineDim.INSERT;
          END;
        UNTIL DimSetEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE DefaultDimOnInsert@17(DefaultDimension@1000 : Record 352);
    VAR
      CallingTrigger@1001 : 'OnInsert,OnModify,OnDelete';
    BEGIN
      IF DefaultDimension."Table ID" = DATABASE::Job THEN
        UpdateJobTaskDim(DefaultDimension,FALSE);

      UpdateCostType(DefaultDimension,CallingTrigger::OnInsert);
    END;

    [External]
    PROCEDURE DefaultDimOnModify@18(DefaultDimension@1000 : Record 352);
    VAR
      CallingTrigger@1001 : 'OnInsert,OnModify,OnDelete';
    BEGIN
      IF DefaultDimension."Table ID" = DATABASE::Job THEN
        UpdateJobTaskDim(DefaultDimension,FALSE);

      UpdateCostType(DefaultDimension,CallingTrigger::OnModify);
    END;

    [External]
    PROCEDURE DefaultDimOnDelete@19(DefaultDimension@1000 : Record 352);
    VAR
      CallingTrigger@1001 : 'OnInsert,OnModify,OnDelete';
    BEGIN
      IF DefaultDimension."Table ID" = DATABASE::Job THEN
        UpdateJobTaskDim(DefaultDimension,TRUE);

      UpdateCostType(DefaultDimension,CallingTrigger::OnDelete);
    END;

    [External]
    PROCEDURE CopyICJnlDimToICJnlDim@97(VAR FromInOutBoxLineDim@1001 : Record 423;VAR ToInOutBoxlineDim@1000 : Record 423);
    BEGIN
      IF FromInOutBoxLineDim.FINDSET THEN
        REPEAT
          ToInOutBoxlineDim := FromInOutBoxLineDim;
          ToInOutBoxlineDim.INSERT;
        UNTIL FromInOutBoxLineDim.NEXT = 0;
    END;

    [External]
    PROCEDURE CopyDocDimtoICDocDim@107(TableID@1005 : Integer;TransactionNo@1004 : Integer;PartnerCode@1003 : Code[20];TransactionSource@1002 : Option;LineNo@1001 : Integer;DimSetEntryID@1000 : Integer);
    VAR
      InOutBoxDocDim@1008 : Record 442;
      DimSetEntry@1009 : Record 480;
      ICDim@1007 : Code[20];
      ICDimValue@1006 : Code[20];
    BEGIN
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetEntryID);
      IF DimSetEntry.FINDSET THEN
        REPEAT
          ICDim := ConvertDimtoICDim(DimSetEntry."Dimension Code");
          ICDimValue := ConvertDimValuetoICDimVal(DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
          IF (ICDim <> '') AND (ICDimValue <> '') THEN BEGIN
            InOutBoxDocDim.INIT;
            InOutBoxDocDim."Table ID" := TableID;
            InOutBoxDocDim."IC Partner Code" := PartnerCode;
            InOutBoxDocDim."Transaction No." := TransactionNo;
            InOutBoxDocDim."Transaction Source" := TransactionSource;
            InOutBoxDocDim."Line No." := LineNo;
            InOutBoxDocDim."Dimension Code" := ICDim;
            InOutBoxDocDim."Dimension Value Code" := ICDimValue;
            InOutBoxDocDim.INSERT;
          END;
        UNTIL DimSetEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE CopyICDocDimtoICDocDim@108(FromSourceICDocDim@1003 : Record 442;VAR ToSourceICDocDim@1002 : Record 442;ToTableID@1001 : Integer;ToTransactionSource@1000 : Integer);
    BEGIN
      WITH FromSourceICDocDim DO BEGIN
        SetICDocDimFilters(FromSourceICDocDim,"Table ID","Transaction No.","IC Partner Code","Transaction Source","Line No.");
        IF FINDSET THEN
          REPEAT
            ToSourceICDocDim := FromSourceICDocDim;
            ToSourceICDocDim."Table ID" := ToTableID;
            ToSourceICDocDim."Transaction Source" := ToTransactionSource;
            ToSourceICDocDim.INSERT;
          UNTIL NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE MoveICDocDimtoICDocDim@112(FromSourceICDocDim@1003 : Record 442;VAR ToSourceICDocDim@1002 : Record 442;ToTableID@1001 : Integer;ToTransactionSource@1000 : Integer);
    BEGIN
      WITH FromSourceICDocDim DO BEGIN
        SetICDocDimFilters(FromSourceICDocDim,"Table ID","Transaction No.","IC Partner Code","Transaction Source","Line No.");
        IF FINDSET THEN
          REPEAT
            ToSourceICDocDim := FromSourceICDocDim;
            ToSourceICDocDim."Table ID" := ToTableID;
            ToSourceICDocDim."Transaction Source" := ToTransactionSource;
            ToSourceICDocDim.INSERT;
            DELETE;
          UNTIL NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE SetICDocDimFilters@110(VAR ICDocDim@1000 : Record 442;TableID@1001 : Integer;TransactionNo@1002 : Integer;PartnerCode@1003 : Code[20];TransactionSource@1004 : Integer;LineNo@1005 : Integer);
    BEGIN
      ICDocDim.RESET;
      ICDocDim.SETRANGE("Table ID",TableID);
      ICDocDim.SETRANGE("Transaction No.",TransactionNo);
      ICDocDim.SETRANGE("IC Partner Code",PartnerCode);
      ICDocDim.SETRANGE("Transaction Source",TransactionSource);
      ICDocDim.SETRANGE("Line No.",LineNo);
    END;

    [External]
    PROCEDURE DeleteICDocDim@109(TableID@1000 : Integer;ICTransactionNo@1001 : Integer;ICPartnerCode@1002 : Code[20];TransactionSource@1003 : Option;LineNo@1005 : Integer);
    VAR
      ICDocDim@1004 : Record 442;
    BEGIN
      SetICDocDimFilters(ICDocDim,TableID,ICTransactionNo,ICPartnerCode,TransactionSource,LineNo);
      IF NOT ICDocDim.ISEMPTY THEN
        ICDocDim.DELETEALL;
    END;

    [External]
    PROCEDURE DeleteICJnlDim@116(TableID@1000 : Integer;ICTransactionNo@1001 : Integer;ICPartnerCode@1002 : Code[20];TransactionSource@1003 : Option;LineNo@1005 : Integer);
    VAR
      ICJnlDim@1004 : Record 423;
    BEGIN
      ICJnlDim.SETRANGE("Table ID",TableID);
      ICJnlDim.SETRANGE("Transaction No.",ICTransactionNo);
      ICJnlDim.SETRANGE("IC Partner Code",ICPartnerCode);
      ICJnlDim.SETRANGE("Transaction Source",TransactionSource);
      ICJnlDim.SETRANGE("Line No.",LineNo);
      IF NOT ICJnlDim.ISEMPTY THEN
        ICJnlDim.DELETEALL;
    END;

    LOCAL PROCEDURE ConvertICDimtoDim@99(FromICDim@1000 : Code[20]) DimCode : Code[20];
    VAR
      ICDim@1002 : Record 411;
    BEGIN
      IF ICDim.GET(FromICDim) THEN
        DimCode := ICDim."Map-to Dimension Code";
    END;

    LOCAL PROCEDURE ConvertICDimValuetoDimValue@100(FromICDim@1000 : Code[20];FromICDimValue@1001 : Code[20]) DimValueCode : Code[20];
    VAR
      ICDimValue@1002 : Record 412;
    BEGIN
      IF ICDimValue.GET(FromICDim,FromICDimValue) THEN
        DimValueCode := ICDimValue."Map-to Dimension Value Code";
    END;

    [External]
    PROCEDURE ConvertDimtoICDim@102(FromDim@1001 : Code[20]) ICDimCode : Code[20];
    VAR
      Dim@1000 : Record 348;
    BEGIN
      IF Dim.GET(FromDim) THEN
        ICDimCode := Dim."Map-to IC Dimension Code";
    END;

    [External]
    PROCEDURE ConvertDimValuetoICDimVal@103(FromDim@1000 : Code[20];FromDimValue@1001 : Code[20]) ICDimValueCode : Code[20];
    VAR
      DimValue@1002 : Record 349;
    BEGIN
      IF DimValue.GET(FromDim,FromDimValue) THEN
        ICDimValueCode := DimValue."Map-to IC Dimension Value Code";
    END;

    [External]
    PROCEDURE CheckICDimValue@113(ICDimCode@1001 : Code[20];ICDimValCode@1000 : Code[20]) : Boolean;
    VAR
      ICDimVal@1002 : Record 412;
    BEGIN
      IF (ICDimCode <> '') AND (ICDimValCode <> '') THEN BEGIN
        IF ICDimVal.GET(ICDimCode,ICDimValCode) THEN BEGIN
          IF ICDimVal.Blocked THEN BEGIN
            DimErr :=
              STRSUBSTNO(
                Text016,ICDimVal.TABLECAPTION,ICDimCode,ICDimValCode);
            EXIT(FALSE);
          END;
          IF NOT (ICDimVal."Dimension Value Type" IN
                  [ICDimVal."Dimension Value Type"::Standard,
                   ICDimVal."Dimension Value Type"::"Begin-Total"])
          THEN BEGIN
            DimErr :=
              STRSUBSTNO(Text017,ICDimVal.FIELDCAPTION("Dimension Value Type"),
                ICDimVal.TABLECAPTION,ICDimCode,ICDimValCode,FORMAT(ICDimVal."Dimension Value Type"));
            EXIT(FALSE);
          END;
        END ELSE BEGIN
          DimErr :=
            STRSUBSTNO(
              Text018,ICDimVal.TABLECAPTION,ICDimCode);
          EXIT(FALSE);
        END;
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CheckICDim@114(ICDimCode@1000 : Code[20]) : Boolean;
    VAR
      ICDim@1001 : Record 411;
    BEGIN
      IF ICDim.GET(ICDimCode) THEN BEGIN
        IF ICDim.Blocked THEN BEGIN
          DimErr :=
            STRSUBSTNO(Text014,ICDim.TABLECAPTION,ICDimCode);
          EXIT(FALSE);
        END;
      END ELSE BEGIN
        DimErr :=
          STRSUBSTNO(Text015,ICDim.TABLECAPTION,ICDimCode);
        EXIT(FALSE);
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE SaveJobTaskDim@39(JobNo@1000 : Code[20];JobTaskNo@1001 : Code[20];FieldNumber@1003 : Integer;ShortcutDimCode@1002 : Code[20]);
    VAR
      JobTaskDim@1004 : Record 1002;
    BEGIN
      GetGLSetup;
      IF ShortcutDimCode <> '' THEN BEGIN
        IF JobTaskDim.GET(JobNo,JobTaskNo,GLSetupShortcutDimCode[FieldNumber])
        THEN BEGIN
          JobTaskDim.VALIDATE("Dimension Value Code",ShortcutDimCode);
          JobTaskDim.MODIFY;
        END ELSE BEGIN
          JobTaskDim.INIT;
          JobTaskDim.VALIDATE("Job No.",JobNo);
          JobTaskDim.VALIDATE("Job Task No.",JobTaskNo);
          JobTaskDim.VALIDATE("Dimension Code",GLSetupShortcutDimCode[FieldNumber]);
          JobTaskDim.VALIDATE("Dimension Value Code",ShortcutDimCode);
          JobTaskDim.INSERT;
        END;
      END ELSE
        IF JobTaskDim.GET(JobNo,JobTaskNo,GLSetupShortcutDimCode[FieldNumber]) THEN
          JobTaskDim.DELETE;
    END;

    [External]
    PROCEDURE SaveJobTaskTempDim@46(FieldNumber@1001 : Integer;ShortcutDimCode@1000 : Code[20]);
    BEGIN
      GetGLSetup;
      IF ShortcutDimCode <> '' THEN BEGIN
        IF JobTaskDimTemp.GET('','',GLSetupShortcutDimCode[FieldNumber])
        THEN BEGIN
          JobTaskDimTemp."Dimension Value Code" := ShortcutDimCode;
          JobTaskDimTemp.MODIFY;
        END ELSE BEGIN
          JobTaskDimTemp.INIT;
          JobTaskDimTemp."Dimension Code" := GLSetupShortcutDimCode[FieldNumber];
          JobTaskDimTemp."Dimension Value Code" := ShortcutDimCode;
          JobTaskDimTemp.INSERT;
        END;
      END ELSE
        IF JobTaskDimTemp.GET('','',GLSetupShortcutDimCode[FieldNumber]) THEN
          JobTaskDimTemp.DELETE;
    END;

    [External]
    PROCEDURE InsertJobTaskDim@54(JobNo@1000 : Code[20];JobTaskNo@1001 : Code[20];VAR GlobalDim1Code@1005 : Code[20];VAR GlobalDim2Code@1004 : Code[20]);
    VAR
      DefaultDim@1002 : Record 352;
      JobTaskDim@1003 : Record 1002;
    BEGIN
      GetGLSetup;
      DefaultDim.SETRANGE("Table ID",DATABASE::Job);
      DefaultDim.SETRANGE("No.",JobNo);
      IF DefaultDim.FINDSET(FALSE,FALSE) THEN
        REPEAT
          IF DefaultDim."Dimension Value Code" <> '' THEN BEGIN
            JobTaskDim.INIT;
            JobTaskDim."Job No." := JobNo;
            JobTaskDim."Job Task No." := JobTaskNo;
            JobTaskDim."Dimension Code" := DefaultDim."Dimension Code";
            JobTaskDim."Dimension Value Code" := DefaultDim."Dimension Value Code";
            JobTaskDim.INSERT;
            IF JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[1] THEN
              GlobalDim1Code := JobTaskDim."Dimension Value Code";
            IF JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[2] THEN
              GlobalDim2Code := JobTaskDim."Dimension Value Code";
          END;
        UNTIL DefaultDim.NEXT = 0;

      JobTaskDimTemp.RESET;
      IF JobTaskDimTemp.FINDSET THEN
        REPEAT
          IF NOT JobTaskDim.GET(JobNo,JobTaskNo,JobTaskDimTemp."Dimension Code") THEN BEGIN
            JobTaskDim.INIT;
            JobTaskDim."Job No." := JobNo;
            JobTaskDim."Job Task No." := JobTaskNo;
            JobTaskDim."Dimension Code" := JobTaskDimTemp."Dimension Code";
            JobTaskDim."Dimension Value Code" := JobTaskDimTemp."Dimension Value Code";
            JobTaskDim.INSERT;
            IF JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[1] THEN
              GlobalDim1Code := JobTaskDim."Dimension Value Code";
            IF JobTaskDim."Dimension Code" = GLSetupShortcutDimCode[2] THEN
              GlobalDim2Code := JobTaskDim."Dimension Value Code";
          END;
        UNTIL JobTaskDimTemp.NEXT = 0;
      JobTaskDimTemp.DELETEALL;
    END;

    LOCAL PROCEDURE UpdateJobTaskDim@15(DefaultDimension@1000 : Record 352;FromOnDelete@1003 : Boolean);
    VAR
      JobTaskDimension@1001 : Record 1002;
      JobTask@1002 : Record 1001;
    BEGIN
      IF DefaultDimension."Table ID" <> DATABASE::Job THEN
        EXIT;

      JobTask.SETRANGE("Job No.",DefaultDimension."No.");
      IF JobTask.ISEMPTY THEN
        EXIT;

      IF NOT CONFIRM(Text019,TRUE) THEN
        EXIT;

      JobTaskDimension.SETRANGE("Job No.",DefaultDimension."No.");
      JobTaskDimension.SETRANGE("Dimension Code",DefaultDimension."Dimension Code");
      JobTaskDimension.DELETEALL(TRUE);

      IF FromOnDelete OR
         (DefaultDimension."Value Posting" = DefaultDimension."Value Posting"::"No Code") OR
         (DefaultDimension."Dimension Value Code" = '')
      THEN
        EXIT;

      IF JobTask.FINDSET THEN
        REPEAT
          CLEAR(JobTaskDimension);
          JobTaskDimension."Job No." := JobTask."Job No.";
          JobTaskDimension."Job Task No." := JobTask."Job Task No.";
          JobTaskDimension."Dimension Code" := DefaultDimension."Dimension Code";
          JobTaskDimension."Dimension Value Code" := DefaultDimension."Dimension Value Code";
          JobTaskDimension.INSERT(TRUE);
        UNTIL JobTask.NEXT = 0;
    END;

    [External]
    PROCEDURE DeleteJobTaskTempDim@76();
    BEGIN
      JobTaskDimTemp.RESET;
      JobTaskDimTemp.DELETEALL;
    END;

    [External]
    PROCEDURE CopyJobTaskDimToJobTaskDim@77(JobNo@1000 : Code[20];JobTaskNo@1001 : Code[20];NewJobNo@1002 : Code[20];NewJobTaskNo@1003 : Code[20]);
    VAR
      JobTaskDimension@1004 : Record 1002;
      JobTaskDimension2@1005 : Record 1002;
    BEGIN
      JobTaskDimension.RESET;
      JobTaskDimension.SETRANGE("Job No.",JobNo);
      JobTaskDimension.SETRANGE("Job Task No.",JobTaskNo);
      IF JobTaskDimension.FINDSET THEN
        REPEAT
          IF NOT JobTaskDimension2.GET(NewJobNo,NewJobTaskNo,JobTaskDimension."Dimension Code") THEN BEGIN
            JobTaskDimension2.INIT;
            JobTaskDimension2."Job No." := NewJobNo;
            JobTaskDimension2."Job Task No." := NewJobTaskNo;
            JobTaskDimension2."Dimension Code" := JobTaskDimension."Dimension Code";
            JobTaskDimension2."Dimension Value Code" := JobTaskDimension."Dimension Value Code";
            JobTaskDimension2.INSERT(TRUE);
          END ELSE BEGIN
            JobTaskDimension2."Dimension Value Code" := JobTaskDimension."Dimension Value Code";
            JobTaskDimension2.MODIFY(TRUE);
          END;
        UNTIL JobTaskDimension.NEXT = 0;

      JobTaskDimension2.RESET;
      JobTaskDimension2.SETRANGE("Job No.",NewJobNo);
      JobTaskDimension2.SETRANGE("Job Task No.",NewJobTaskNo);
      IF JobTaskDimension2.FINDSET THEN
        REPEAT
          IF NOT JobTaskDimension.GET(JobNo,JobTaskNo,JobTaskDimension2."Dimension Code") THEN
            JobTaskDimension2.DELETE(TRUE);
        UNTIL JobTaskDimension2.NEXT = 0;
    END;

    [External]
    PROCEDURE CheckDimIDConsistency@10(VAR DimSetEntry@1000 : Record 480;VAR PostedDimSetEntry@1001 : Record 480;DocTableID@1002 : Integer;PostedDocTableID@1003 : Integer) : Boolean;
    BEGIN
      IF DimSetEntry.FINDSET THEN;
      IF PostedDimSetEntry.FINDSET THEN;
      REPEAT
        CASE TRUE OF
          DimSetEntry."Dimension Code" > PostedDimSetEntry."Dimension Code":
            BEGIN
              DocDimConsistencyErr :=
                STRSUBSTNO(
                  Text012,
                  DimSetEntry.FIELDCAPTION("Dimension Code"),
                  ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DocTableID),
                  ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,PostedDocTableID));
              EXIT(FALSE);
            END;
          DimSetEntry."Dimension Code" < PostedDimSetEntry."Dimension Code":
            BEGIN
              DocDimConsistencyErr :=
                STRSUBSTNO(
                  Text012,
                  PostedDimSetEntry.FIELDCAPTION("Dimension Code"),
                  ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,PostedDocTableID),
                  ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DocTableID));
              EXIT(FALSE);
            END;
          DimSetEntry."Dimension Code" = PostedDimSetEntry."Dimension Code":
            BEGIN
              IF DimSetEntry."Dimension Value Code" <> PostedDimSetEntry."Dimension Value Code" THEN BEGIN
                DocDimConsistencyErr :=
                  STRSUBSTNO(
                    Text013,
                    DimSetEntry.FIELDCAPTION("Dimension Value Code"),
                    DimSetEntry.FIELDCAPTION("Dimension Code"),
                    DimSetEntry."Dimension Code",
                    ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,DocTableID),
                    ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,PostedDocTableID));
                EXIT(FALSE);
              END;
            END;
        END;
      UNTIL (DimSetEntry.NEXT = 0) AND (PostedDimSetEntry.NEXT = 0);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CreateDimSetEntryFromDimValue@4(DimValue@1000 : Record 349;VAR TempDimSetEntry@1001 : TEMPORARY Record 480);
    BEGIN
      TempDimSetEntry."Dimension Code" := DimValue."Dimension Code";
      TempDimSetEntry."Dimension Value Code" := DimValue.Code;
      TempDimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
      TempDimSetEntry.INSERT;
    END;

    [External]
    PROCEDURE CreateDimSetIDFromICDocDim@5(VAR ICDocDim@1000 : Record 442) : Integer;
    VAR
      DimValue@1004 : Record 349;
      TempDimSetEntry@1003 : TEMPORARY Record 480;
    BEGIN
      IF ICDocDim.FIND('-') THEN
        REPEAT
          DimValue.GET(
            ConvertICDimtoDim(ICDocDim."Dimension Code"),
            ConvertICDimValuetoDimValue(ICDocDim."Dimension Code",ICDocDim."Dimension Value Code"));
          CreateDimSetEntryFromDimValue(DimValue,TempDimSetEntry);
        UNTIL ICDocDim.NEXT = 0;
      EXIT(GetDimensionSetID(TempDimSetEntry));
    END;

    [External]
    PROCEDURE CreateDimSetIDFromICJnlLineDim@7(VAR ICInboxOutboxJnlLineDim@1000 : Record 423) : Integer;
    VAR
      DimValue@1001 : Record 349;
      TempDimSetEntry@1002 : TEMPORARY Record 480;
    BEGIN
      IF ICInboxOutboxJnlLineDim.FIND('-') THEN
        REPEAT
          DimValue.GET(
            ConvertICDimtoDim(ICInboxOutboxJnlLineDim."Dimension Code"),
            ConvertICDimValuetoDimValue(
              ICInboxOutboxJnlLineDim."Dimension Code",ICInboxOutboxJnlLineDim."Dimension Value Code"));
          CreateDimSetEntryFromDimValue(DimValue,TempDimSetEntry);
        UNTIL ICInboxOutboxJnlLineDim.NEXT = 0;
      EXIT(GetDimensionSetID(TempDimSetEntry));
    END;

    [External]
    PROCEDURE CopyDimBufToDimSetEntry@65(VAR FromDimBuf@1000 : Record 360;VAR DimSetEntry@1001 : Record 480);
    VAR
      DimValue@1005 : Record 349;
    BEGIN
      WITH FromDimBuf DO
        IF FINDSET THEN
          REPEAT
            DimValue.GET("Dimension Code","Dimension Value Code");
            DimSetEntry."Dimension Code" := "Dimension Code";
            DimSetEntry."Dimension Value Code" := "Dimension Value Code";
            DimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
            DimSetEntry.INSERT;
          UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE CreateDimSetIDFromDimBuf@12(VAR DimBuf@1000 : Record 360) : Integer;
    VAR
      DimValue@1001 : Record 349;
      TempDimSetEntry@1002 : TEMPORARY Record 480;
    BEGIN
      IF DimBuf.FINDSET THEN
        REPEAT
          DimValue.GET(DimBuf."Dimension Code",DimBuf."Dimension Value Code");
          CreateDimSetEntryFromDimValue(DimValue,TempDimSetEntry);
        UNTIL DimBuf.NEXT = 0;
      EXIT(GetDimensionSetID(TempDimSetEntry));
    END;

    [External]
    PROCEDURE CreateDimForPurchLineWithHigherPriorities@79(PurchaseLine@1008 : Record 39;CurrFieldNo@1005 : Integer;VAR DimensionSetID@1001 : Integer;VAR DimValue1@1003 : Code[20];VAR DimValue2@1002 : Code[20];SourceCode@1004 : Code[10];PriorityTableID@1000 : Integer);
    VAR
      TableID@1006 : ARRAY [10] OF Integer;
      No@1007 : ARRAY [10] OF Code[20];
      HighPriorityTableID@1010 : ARRAY [10] OF Integer;
      HighPriorityNo@1009 : ARRAY [10] OF Code[20];
    BEGIN
      TableID[1] := DATABASE::Job;
      TableID[2] := TypeToTableID3(PurchaseLine.Type);
      No[1] := PurchaseLine."Job No.";
      No[2] := PurchaseLine."No.";

      IF GetTableIDsForHigherPriorities(
           TableID,No,HighPriorityTableID,HighPriorityNo,SourceCode,PriorityTableID)
      THEN
        DimensionSetID :=
          GetRecDefaultDimID(
            PurchaseLine,CurrFieldNo,HighPriorityTableID,HighPriorityNo,SourceCode,DimValue1,DimValue2,0,0);
    END;

    [External]
    PROCEDURE CreateDimForSalesLineWithHigherPriorities@80(SalesLine@1008 : Record 37;CurrFieldNo@1005 : Integer;VAR DimensionSetID@1001 : Integer;VAR DimValue1@1003 : Code[20];VAR DimValue2@1002 : Code[20];SourceCode@1004 : Code[10];PriorityTableID@1000 : Integer);
    VAR
      TableID@1006 : ARRAY [10] OF Integer;
      No@1007 : ARRAY [10] OF Code[20];
      HighPriorityTableID@1010 : ARRAY [10] OF Integer;
      HighPriorityNo@1009 : ARRAY [10] OF Code[20];
    BEGIN
      TableID[1] := DATABASE::Job;
      TableID[2] := TypeToTableID3(SalesLine.Type);
      No[1] := SalesLine."Job No.";
      No[2] := SalesLine."No.";

      IF GetTableIDsForHigherPriorities(
           TableID,No,HighPriorityTableID,HighPriorityNo,SourceCode,PriorityTableID)
      THEN
        DimensionSetID :=
          GetRecDefaultDimID(
            SalesLine,CurrFieldNo,HighPriorityTableID,HighPriorityNo,SourceCode,DimValue1,DimValue2,0,0);
    END;

    [External]
    PROCEDURE CreateDimForJobJournalLineWithHigherPriorities@73(JobJournalLine@1008 : Record 210;CurrFieldNo@1005 : Integer;VAR DimensionSetID@1001 : Integer;VAR DimValue1@1004 : Code[20];VAR DimValue2@1003 : Code[20];SourceCode@1002 : Code[10];PriorityTableID@1000 : Integer);
    VAR
      TableID@1010 : ARRAY [10] OF Integer;
      No@1009 : ARRAY [10] OF Code[20];
      HighPriorityTableID@1007 : ARRAY [10] OF Integer;
      HighPriorityNo@1006 : ARRAY [10] OF Code[20];
    BEGIN
      TableID[1] := DATABASE::Job;
      TableID[2] := TypeToTableID2(JobJournalLine.Type);
      TableID[3] := DATABASE::"Resource Group";
      No[1] := JobJournalLine."Job No.";
      No[2] := JobJournalLine."No.";
      No[3] := JobJournalLine."Resource Group No.";

      IF GetTableIDsForHigherPriorities(
           TableID,No,HighPriorityTableID,HighPriorityNo,SourceCode,PriorityTableID)
      THEN
        DimensionSetID :=
          GetRecDefaultDimID(
            JobJournalLine,CurrFieldNo,HighPriorityTableID,HighPriorityNo,SourceCode,DimValue1,DimValue2,0,0);
    END;

    LOCAL PROCEDURE GetTableIDsForHigherPriorities@78(TableID@1005 : ARRAY [10] OF Integer;No@1009 : ARRAY [10] OF Code[20];VAR HighPriorityTableID@1000 : ARRAY [10] OF Integer;VAR HighPriorityNo@1001 : ARRAY [10] OF Code[20];SourceCode@1003 : Code[10];PriorityTableID@1002 : Integer) Result : Boolean;
    VAR
      DefaultDimensionPriority@1008 : Record 354;
      InitialPriority@1007 : Integer;
      i@1004 : Integer;
      j@1006 : Integer;
    BEGIN
      CLEAR(HighPriorityTableID);
      CLEAR(HighPriorityNo);
      IF DefaultDimensionPriority.GET(SourceCode,PriorityTableID) THEN
        InitialPriority := DefaultDimensionPriority.Priority;
      DefaultDimensionPriority.SETRANGE("Source Code",SourceCode);
      DefaultDimensionPriority.SETFILTER(Priority,'<=%1',InitialPriority);
      i := 1;
      FOR j := 1 TO ARRAYLEN(TableID) DO BEGIN
        IF TableID[j] = 0 THEN
          BREAK;
        DefaultDimensionPriority.Priority := 0;
        DefaultDimensionPriority.SETRANGE("Table ID",TableID[j]);
        IF ((InitialPriority = 0) OR DefaultDimensionPriority.FINDFIRST) AND
           ((DefaultDimensionPriority.Priority < InitialPriority) OR
            ((DefaultDimensionPriority.Priority = InitialPriority) AND (TableID[j] < PriorityTableID)))
        THEN BEGIN
          Result := TRUE;
          HighPriorityTableID[i] := TableID[j];
          HighPriorityNo[i] := No[j];
          i += 1;
        END;
      END;
      EXIT(Result);
    END;

    [External]
    PROCEDURE GetDimSetIDsForFilter@23(DimCode@1000 : Code[20];DimValueFilter@1001 : Text);
    VAR
      DimSetEntry2@1002 : Record 480;
    BEGIN
      DimSetEntry2.SETFILTER("Dimension Code",'%1',DimCode);
      DimSetEntry2.SETFILTER("Dimension Value Code",DimValueFilter);
      IF DimSetEntry2.FINDSET THEN
        REPEAT
          AddDimSetIDtoTempEntry(TempDimSetEntry2,DimSetEntry2."Dimension Set ID");
        UNTIL DimSetEntry2.NEXT = 0;
      IF FilterIncludesBlank(DimCode,DimValueFilter) THEN
        GetDimSetIDsForBlank(DimCode);
      DimSetFilterCtr += 1;
    END;

    LOCAL PROCEDURE GetDimSetIDsForBlank@27(DimCode@1000 : Code[20]);
    VAR
      TempDimSetEntry@1001 : TEMPORARY Record 480;
      DimSetEntry2@1002 : Record 480;
      PrevDimSetID@1004 : Integer;
      i@1003 : Integer;
    BEGIN
      AddDimSetIDtoTempEntry(TempDimSetEntry,0);
      FOR i := 1 TO 2 DO BEGIN
        IF i = 2 THEN
          DimSetEntry2.SETFILTER("Dimension Code",'%1',DimCode);
        IF DimSetEntry2.FINDSET THEN BEGIN
          PrevDimSetID := 0;
          REPEAT
            IF DimSetEntry2."Dimension Set ID" <> PrevDimSetID THEN BEGIN
              AddDimSetIDtoTempEntry(TempDimSetEntry,DimSetEntry2."Dimension Set ID");
              PrevDimSetID := DimSetEntry2."Dimension Set ID";
            END;
          UNTIL DimSetEntry2.NEXT = 0;
        END;
      END;
      TempDimSetEntry.SETFILTER("Dimension Value ID",'%1',1);
      IF TempDimSetEntry.FINDSET THEN
        REPEAT
          AddDimSetIDtoTempEntry(TempDimSetEntry2,TempDimSetEntry."Dimension Set ID");
        UNTIL TempDimSetEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE GetDimSetFilter@43() DimSetFilter : Text;
    BEGIN
      TempDimSetEntry2.SETFILTER("Dimension Value ID",'%1',DimSetFilterCtr);
      IF TempDimSetEntry2.FINDSET THEN BEGIN
        DimSetFilter := FORMAT(TempDimSetEntry2."Dimension Set ID");
        IF TempDimSetEntry2.NEXT <> 0 THEN
          REPEAT
            DimSetFilter += '|' + FORMAT(TempDimSetEntry2."Dimension Set ID");
          UNTIL TempDimSetEntry2.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE FilterIncludesBlank@25(DimCode@1001 : Code[20];DimValueFilter@1000 : Text) : Boolean;
    VAR
      TempDimSetEntry@1002 : TEMPORARY Record 480;
    BEGIN
      TempDimSetEntry."Dimension Code" := DimCode;
      TempDimSetEntry.INSERT;
      TempDimSetEntry.SETFILTER("Dimension Value Code",DimValueFilter);
      EXIT(NOT TempDimSetEntry.ISEMPTY);
    END;

    LOCAL PROCEDURE AddDimSetIDtoTempEntry@30(VAR TempDimSetEntry@1001 : TEMPORARY Record 480;DimSetID@1000 : Integer);
    BEGIN
      IF TempDimSetEntry.GET(DimSetID,'') THEN BEGIN
        TempDimSetEntry."Dimension Value ID" += 1;
        TempDimSetEntry.MODIFY;
      END ELSE BEGIN
        TempDimSetEntry."Dimension Set ID" := DimSetID;
        TempDimSetEntry."Dimension Value ID" := 1;
        TempDimSetEntry.INSERT
      END;
    END;

    [External]
    PROCEDURE ClearDimSetFilter@26();
    BEGIN
      TempDimSetEntry2.RESET;
      TempDimSetEntry2.DELETEALL;
      DimSetFilterCtr := 0;
    END;

    [External]
    PROCEDURE GetTempDimSetEntry@31(VAR TempDimSetEntry@1000 : TEMPORARY Record 480);
    BEGIN
      TempDimSetEntry.COPY(TempDimSetEntry2,TRUE);
    END;

    LOCAL PROCEDURE UpdateCostType@28(DefaultDimension@1000 : Record 352;CallingTrigger@1004 : 'OnInsert,OnModify,OnDelete');
    VAR
      GLAcc@1003 : Record 15;
      CostAccSetup@1002 : Record 1108;
      CostAccMgt@1001 : Codeunit 1100;
    BEGIN
      IF CostAccSetup.GET AND (DefaultDimension."Table ID" = DATABASE::"G/L Account") THEN
        IF GLAcc.GET(DefaultDimension."No.") THEN
          CostAccMgt.UpdateCostTypeFromDefaultDimension(DefaultDimension,GLAcc,CallingTrigger);
    END;

    [External]
    PROCEDURE CreateDimSetFromJobTaskDim@32(JobNo@1006 : Code[20];JobTaskNo@1001 : Code[20];VAR GlobalDimVal1@1005 : Code[20];VAR GlobalDimVal2@1004 : Code[20]) NewDimSetID : Integer;
    VAR
      JobTaskDimension@1000 : Record 1002;
      DimValue@1002 : Record 349;
      TempDimSetEntry@1003 : TEMPORARY Record 480;
    BEGIN
      WITH JobTaskDimension DO BEGIN
        SETRANGE("Job No.",JobNo);
        SETRANGE("Job Task No.",JobTaskNo);
        IF FINDSET THEN BEGIN
          REPEAT
            DimValue.GET("Dimension Code","Dimension Value Code");
            TempDimSetEntry."Dimension Code" := "Dimension Code";
            TempDimSetEntry."Dimension Value Code" := "Dimension Value Code";
            TempDimSetEntry."Dimension Value ID" := DimValue."Dimension Value ID";
            TempDimSetEntry.INSERT(TRUE);
          UNTIL NEXT = 0;
          NewDimSetID := GetDimensionSetID(TempDimSetEntry);
          UpdateGlobalDimFromDimSetID(NewDimSetID,GlobalDimVal1,GlobalDimVal2);
        END;
      END;
    END;

    [External]
    PROCEDURE UpdateGenJnlLineDim@34(VAR GenJnlLine@1000 : Record 81;DimSetID@1001 : Integer);
    BEGIN
      GenJnlLine."Dimension Set ID" := DimSetID;
      UpdateGlobalDimFromDimSetID(
        GenJnlLine."Dimension Set ID",
        GenJnlLine."Shortcut Dimension 1 Code",GenJnlLine."Shortcut Dimension 2 Code");
    END;

    [External]
    PROCEDURE UpdateGenJnlLineDimFromCustLedgEntry@33(VAR GenJnlLine@1000 : Record 81;DtldCustLedgEntry@1001 : Record 379);
    VAR
      CustLedgEntry@1002 : Record 21;
    BEGIN
      IF DtldCustLedgEntry."Cust. Ledger Entry No." <> 0 THEN BEGIN
        CustLedgEntry.GET(DtldCustLedgEntry."Cust. Ledger Entry No.");
        UpdateGenJnlLineDim(GenJnlLine,CustLedgEntry."Dimension Set ID");
      END;
    END;

    [External]
    PROCEDURE UpdateGenJnlLineDimFromVendLedgEntry@29(VAR GenJnlLine@1001 : Record 81;DtldVendLedgEntry@1000 : Record 380);
    VAR
      VendLedgEntry@1002 : Record 25;
    BEGIN
      IF DtldVendLedgEntry."Vendor Ledger Entry No." <> 0 THEN BEGIN
        VendLedgEntry.GET(DtldVendLedgEntry."Vendor Ledger Entry No.");
        UpdateGenJnlLineDim(GenJnlLine,VendLedgEntry."Dimension Set ID");
      END;
    END;

    [External]
    PROCEDURE GetDimSetEntryDefaultDim@45(VAR DimSetEntry2@1001 : Record 480);
    VAR
      DimValue@1000 : Record 349;
    BEGIN
      IF NOT DimSetEntry2.ISEMPTY THEN
        DimSetEntry2.DELETEALL;
      IF TempDimBuf2.FINDSET THEN
        REPEAT
          DimValue.GET(TempDimBuf2."Dimension Code",TempDimBuf2."Dimension Value Code");
          DimSetEntry2."Dimension Code" := TempDimBuf2."Dimension Code";
          DimSetEntry2."Dimension Value Code" := TempDimBuf2."Dimension Value Code";
          DimSetEntry2."Dimension Value ID" := DimValue."Dimension Value ID";
          DimSetEntry2.INSERT;
        UNTIL TempDimBuf2.NEXT = 0;
      TempDimBuf2.RESET;
      TempDimBuf2.DELETEALL;
    END;

    [External]
    PROCEDURE InsertObject@35(VAR TempAllObjWithCaption@1000 : TEMPORARY Record 2000000058;TableID@1001 : Integer);
    VAR
      AllObjWithCaption@1002 : Record 2000000058;
    BEGIN
      IF AllObjWithCaption.GET(AllObjWithCaption."Object Type"::Table,TableID) THEN BEGIN
        TempAllObjWithCaption := AllObjWithCaption;
        IF TempAllObjWithCaption.INSERT THEN;
      END;
    END;

    [External]
    PROCEDURE GetConsolidatedDimFilterByDimFilter@37(VAR Dimension@1000 : Record 348;DimFilter@1001 : Text) ConsolidatedDimFilter : Text;
    BEGIN
      Dimension.SETFILTER("Consolidation Code",DimFilter);
      ConsolidatedDimFilter += DimFilter;
      IF Dimension.FINDSET THEN
        REPEAT
          ConsolidatedDimFilter += '|' + Dimension.Code;
        UNTIL Dimension.NEXT = 0;
    END;

    [External]
    PROCEDURE ResolveDimValueFilter@47(VAR DimValueFilter@1001 : Text;DimensionCode@1000 : Code[20]);
    VAR
      TempDimensionValue@1002 : TEMPORARY Record 349;
      TempDimensionValueBuffer@1003 : TEMPORARY Record 349;
    BEGIN
      GetDimValuesWithTotalings(TempDimensionValue,DimValueFilter,DimensionCode);
      FillTempDimensionValueBuffer(TempDimensionValue,TempDimensionValueBuffer,DimValueFilter,DimensionCode);
      GetFilterFromDimValuesTable(TempDimensionValue,TempDimensionValueBuffer,DimValueFilter);
    END;

    LOCAL PROCEDURE GetDimValuesWithTotalings@44(VAR TempDimensionValue@1004 : TEMPORARY Record 349;DimValueFilter@1002 : Text;DimensionCode@1000 : Code[20]);
    VAR
      DimensionValue@1001 : Record 349;
    BEGIN
      IF NOT TempDimensionValue.ISTEMPORARY OR (DimensionCode = '') THEN
        EXIT;
      DimensionValue.SETRANGE("Dimension Code",DimensionCode);
      DimensionValue.SETFILTER(Code,DimValueFilter);
      IF DimensionValue.FINDSET THEN
        REPEAT
          TempDimensionValue.INIT;
          TempDimensionValue := DimensionValue;
          IF TempDimensionValue.INSERT THEN
            IF DimensionValue.Totaling <> '' THEN
              GetDimValuesWithTotalings(TempDimensionValue,DimensionValue.Totaling,DimensionCode);
        UNTIL DimensionValue.NEXT = 0;
    END;

    LOCAL PROCEDURE FillTempDimensionValueBuffer@94(VAR TempDimensionValue@1004 : TEMPORARY Record 349;VAR TempDimensionValueBuffer@1000 : TEMPORARY Record 349;DimValueFilter@1003 : Text;DimensionCode@1002 : Code[20]);
    VAR
      DimensionValue@1001 : Record 349;
    BEGIN
      IF NOT TempDimensionValueBuffer.ISTEMPORARY OR (DimensionCode = '') THEN
        EXIT;

      DimensionValue.SETRANGE("Dimension Code",DimensionCode);
      IF DimensionValue.FINDSET THEN BEGIN
        REPEAT
          TempDimensionValueBuffer.INIT;
          TempDimensionValueBuffer := DimensionValue;
          TempDimensionValueBuffer.INSERT;
        UNTIL DimensionValue.NEXT = 0;

        TempDimensionValueBuffer.INIT;
        TempDimensionValueBuffer := DimensionValue;
        TempDimensionValueBuffer.Code := '''''';
        TempDimensionValueBuffer.INSERT;

        TempDimensionValueBuffer.SETFILTER(Code,DimValueFilter);
        TempDimensionValueBuffer.Code := '''''';
        IF TempDimensionValueBuffer.FIND THEN BEGIN
          TempDimensionValue.INIT;
          TempDimensionValue := TempDimensionValueBuffer;
          TempDimensionValue.INSERT;
        END;
      END;
    END;

    LOCAL PROCEDURE GetFilterFromDimValuesTable@42(VAR TempDimensionValue@1001 : TEMPORARY Record 349;VAR TempDimensionValueBuffer@1004 : TEMPORARY Record 349;VAR DimValueFilter@1000 : Text);
    VAR
      RangeStartCode@1006 : Code[20];
      PreviousCode@1002 : Code[20];
      RangeStarted@1003 : Boolean;
      Finished@1007 : Boolean;
    BEGIN
      WITH TempDimensionValue DO BEGIN
        IF NOT ISTEMPORARY THEN
          EXIT;
        SETFILTER("Dimension Value Type",'%1|%2',"Dimension Value Type"::Standard,"Dimension Value Type"::Heading);
        IF FINDSET THEN BEGIN
          Finished := FALSE;
          DimValueFilter := '';
          TempDimensionValueBuffer.RESET;
          TempDimensionValueBuffer.FINDFIRST;
          WHILE NOT Finished DO
            IF Code IN [TempDimensionValueBuffer.Code,''''''] THEN BEGIN
              IF NOT RangeStarted THEN BEGIN
                RangeStarted := TRUE;
                RangeStartCode := Code;
              END;
              PreviousCode := Code;
              IF Code <> '''''' THEN
                TempDimensionValueBuffer.NEXT;
              Finished := NEXT = 0;
            END ELSE BEGIN
              AddRangeToFilter(DimValueFilter,RangeStartCode,PreviousCode,RangeStarted);
              TempDimensionValueBuffer.GET("Dimension Code",Code);
            END;
          AddRangeToFilter(DimValueFilter,RangeStartCode,PreviousCode,RangeStarted);
        END;
      END;
    END;

    LOCAL PROCEDURE AddRangeToFilter@24(VAR DimValueFilter@1000 : Text;RangeStartCode@1002 : Code[20];RangeEndCode@1001 : Code[20];VAR RangeStarted@1003 : Boolean);
    BEGIN
      IF NOT RangeStarted THEN
        EXIT;
      RangeStarted := FALSE;

      IF DimValueFilter <> '' THEN BEGIN
        IF STRLEN(DimValueFilter) + 1 > MAXSTRLEN(DimValueFilter) THEN
          ERROR(OverflowDimFilterErr);
        DimValueFilter := DimValueFilter + '|';
      END;
      IF RangeStartCode = RangeEndCode THEN BEGIN
        IF STRLEN(DimValueFilter) + STRLEN(RangeStartCode) > MAXSTRLEN(DimValueFilter) THEN
          ERROR(OverflowDimFilterErr);
        DimValueFilter := DimValueFilter + RangeStartCode;
      END ELSE BEGIN
        IF STRLEN(DimValueFilter) + STRLEN(RangeStartCode) + 2 + STRLEN(RangeEndCode) > MAXSTRLEN(DimValueFilter) THEN
          ERROR(OverflowDimFilterErr);
        DimValueFilter := DimValueFilter + RangeStartCode + '..' + RangeEndCode;
      END;
    END;

    [Integration]
    PROCEDURE OnAfterSetupObjectNoList@2(VAR TempAllObjWithCaption@1000 : TEMPORARY Record 2000000058);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeGetDefaultDimID@63(VAR TableID@1006 : ARRAY [10] OF Integer;VAR No@1005 : ARRAY [10] OF Code[20];SourceCode@1004 : Code[20];VAR GlobalDim1Code@1003 : Code[20];VAR GlobalDim2Code@1002 : Code[20];InheritFromDimSetID@1001 : Integer;InheritFromTableNo@1000 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnGetRecDefaultDimID@155(RecVariant@1011 : Variant;CurrFieldNo@1012 : Integer;VAR TableID@1000 : ARRAY [10] OF Integer;VAR No@1001 : ARRAY [10] OF Code[20];VAR SourceCode@1002 : Code[20];VAR InheritFromDimSetID@1004 : Integer;VAR InheritFromTableNo@1003 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnTypeToTableID2@38(VAR TableID@1002 : Integer;Type@1000 : Integer);
    BEGIN
    END;

    BEGIN
    END.
  }
}

