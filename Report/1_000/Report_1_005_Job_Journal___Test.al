OBJECT Report 1005 Job Journal - Test
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sagskladde - kontrol;
               ENU=Job Journal - Test];
    OnPreReport=BEGIN
                  JobJnlLineFilter := "Job Journal Line".GETFILTERS;
                END;

  }
  DATASET
  {
    { 3783;    ;DataItem;                    ;
               DataItemTable=Table237;
               DataItemTableView=SORTING(Journal Template Name,Name);
               PrintOnlyIfDetail=Yes;
               OnAfterGetRecord=BEGIN
                                  CurrReport.PAGENO := 1;
                                END;

               ReqFilterFields=Journal Template Name,Name }

    { 47  ;1   ;Column  ;Job_Journal_Batch_Name;
               SourceExpr=Name }

    { 5444;1   ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               PrintOnlyIfDetail=Yes }

    { 13  ;2   ;Column  ;COMPANYNAME         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 31  ;2   ;Column  ;Job_Journal_Batch___Journal_Template_Name_;
               SourceExpr="Job Journal Batch"."Journal Template Name" }

    { 32  ;2   ;Column  ;Job_Journal_Batch__Name;
               SourceExpr="Job Journal Batch".Name }

    { 33  ;2   ;Column  ;FORMAT_TODAY_0_4_   ;
               SourceExpr=FORMAT(TODAY,0,4) }

    { 36  ;2   ;Column  ;CurrReport_PAGENO   ;
               SourceExpr=CurrReport.PAGENO }

    { 37  ;2   ;Column  ;Job_Journal_Line__TABLECAPTION__________JobJnlLineFilter;
               SourceExpr="Job Journal Line".TABLECAPTION + ': ' + JobJnlLineFilter }

    { 1000000000;2;Column;JobJnlLineFilter   ;
               SourceExpr=JobJnlLineFilter }

    { 14  ;2   ;Column  ;Job_Journal_Batch___Journal_Template_Name_Caption;
               SourceExpr=Job_Journal_Batch___Journal_Template_Name_CaptionLbl }

    { 17  ;2   ;Column  ;Job_Journal_Batch__NameCaption;
               SourceExpr=Job_Journal_Batch__NameCaptionLbl }

    { 18  ;2   ;Column  ;Job_Journal___TestCaption;
               SourceExpr=Job_Journal___TestCaptionLbl }

    { 35  ;2   ;Column  ;CurrReport_PAGENOCaption;
               SourceExpr=CurrReport_PAGENOCaptionLbl }

    { 20  ;2   ;Column  ;Job_Journal_Line__Line_Amount_Caption;
               SourceExpr="Job Journal Line".FIELDCAPTION("Line Amount") }

    { 28  ;2   ;Column  ;Job_Journal_Line__Unit_Price_Caption;
               SourceExpr="Job Journal Line".FIELDCAPTION("Unit Price") }

    { 16  ;2   ;Column  ;Job_Journal_Line__Total_Cost__LCY__Caption;
               SourceExpr="Job Journal Line".FIELDCAPTION("Total Cost (LCY)") }

    { 26  ;2   ;Column  ;Job_Journal_Line__Unit_Cost__LCY__Caption;
               SourceExpr="Job Journal Line".FIELDCAPTION("Unit Cost (LCY)") }

    { 24  ;2   ;Column  ;Job_Journal_Line__Work_Type_Code_Caption;
               SourceExpr="Job Journal Line".FIELDCAPTION("Work Type Code") }

    { 22  ;2   ;Column  ;Job_Journal_Line__Unit_of_Measure_Code_Caption;
               SourceExpr="Job Journal Line".FIELDCAPTION("Unit of Measure Code") }

    { 12  ;2   ;Column  ;Job_Journal_Line_QuantityCaption;
               SourceExpr="Job Journal Line".FIELDCAPTION(Quantity) }

    { 10  ;2   ;Column  ;Job_Journal_Line__No__Caption;
               SourceExpr="Job Journal Line".FIELDCAPTION("No.") }

    { 6   ;2   ;Column  ;Job_Journal_Line__Document_No__Caption;
               SourceExpr="Job Journal Line".FIELDCAPTION("Document No.") }

    { 8   ;2   ;Column  ;Job_Journal_Line_TypeCaption;
               SourceExpr="Job Journal Line".FIELDCAPTION(Type) }

    { 2   ;2   ;Column  ;Job_Journal_Line__Job_No__Caption;
               SourceExpr="Job Journal Line".FIELDCAPTION("Job No.") }

    { 4   ;2   ;Column  ;Job_Journal_Line__Posting_Date_Caption;
               SourceExpr=Job_Journal_Line__Posting_Date_CaptionLbl }

    { 7831;2   ;DataItem;                    ;
               DataItemTable=Table210;
               DataItemTableView=SORTING(Journal Template Name,Journal Batch Name,Line No.);
               OnPreDataItem=BEGIN
                               JobJnlTemplate.GET("Job Journal Batch"."Journal Template Name");
                               IF JobJnlTemplate.Recurring THEN BEGIN
                                 IF GETFILTER("Posting Date") <> '' THEN
                                   AddError(
                                     STRSUBSTNO(
                                       Text000,FIELDCAPTION("Posting Date")));
                                 SETRANGE("Posting Date",0D,WORKDATE);
                                 IF GETFILTER("Expiration Date") <> '' THEN
                                   AddError(
                                     STRSUBSTNO(
                                       Text000,FIELDCAPTION("Expiration Date")));
                                 SETFILTER("Expiration Date",'%1 | %2..',0D,WORKDATE);
                               END;

                               CurrReport.CREATETOTALS("Total Cost","Total Price");

                               IF "Job Journal Batch"."No. Series" <> '' THEN
                                 NoSeries.GET("Job Journal Batch"."No. Series");
                               LastPostingDate := 0D;
                               LastDocNo := '';
                             END;

               OnAfterGetRecord=VAR
                                  InvtPeriodEndDate@1000 : Date;
                                BEGIN
                                  IF EmptyLine THEN
                                    EXIT;

                                  MakeRecurringTexts("Job Journal Line");

                                  IF "Job No." = '' THEN
                                    AddError(STRSUBSTNO(Text001,FIELDCAPTION("Job No.")))
                                  ELSE
                                    IF NOT Job.GET("Job No.") THEN
                                      AddError(STRSUBSTNO(Text002,"Job No."))
                                    ELSE BEGIN
                                      IF Job.Blocked > Job.Blocked::" " THEN
                                        AddError(STRSUBSTNO(Text003,Job.FIELDCAPTION(Blocked),Job.Blocked,"Job No."));
                                    END;
                                  IF "Job No." <> '' THEN
                                    IF "Job Task No." = '' THEN
                                      AddError(STRSUBSTNO(Text001,FIELDCAPTION("Job Task No.")))
                                    ELSE BEGIN
                                      IF NOT JT.GET("Job No.","Job Task No.") THEN
                                        AddError(STRSUBSTNO(Text015,JT.TABLECAPTION,"Job Task No."))
                                    END;

                                  IF Type <> Type::"G/L Account" THEN
                                    IF "Gen. Prod. Posting Group" = '' THEN
                                      AddError(STRSUBSTNO(Text001,FIELDCAPTION("Gen. Prod. Posting Group")))
                                    ELSE
                                      IF NOT GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group") THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text004,GenPostingSetup.TABLECAPTION,
                                            "Gen. Bus. Posting Group","Gen. Prod. Posting Group"));

                                  IF "Document No." = '' THEN
                                    AddError(STRSUBSTNO(Text001,FIELDCAPTION("Document No.")));

                                  IF "No." = '' THEN
                                    AddError(STRSUBSTNO(Text001,FIELDCAPTION("No.")))
                                  ELSE
                                    CASE Type OF
                                      Type::Resource:
                                        IF NOT Res.GET("No.") THEN
                                          AddError(STRSUBSTNO(Text005,"No."))
                                        ELSE BEGIN
                                          IF Res."Privacy Blocked" THEN
                                            AddError(STRSUBSTNO(Text006,Res.FIELDCAPTION("Privacy Blocked"),FALSE,"No."));
                                          IF Res.Blocked THEN
                                            AddError(STRSUBSTNO(Text006,Res.FIELDCAPTION(Blocked),FALSE,"No."));
                                        END;
                                      Type::Item:
                                        IF NOT Item.GET("No.") THEN
                                          AddError(STRSUBSTNO(Text007,"No."))
                                        ELSE
                                          IF Item.Blocked THEN
                                            AddError(STRSUBSTNO(Text008,Item.FIELDCAPTION(Blocked),FALSE,"No."));
                                      Type::"G/L Account":
                                        ;
                                    END;

                                  CheckRecurringLine("Job Journal Line");

                                  IF "Posting Date" = 0D THEN
                                    AddError(STRSUBSTNO(Text001,FIELDCAPTION("Posting Date")))
                                  ELSE BEGIN
                                    IF "Posting Date" <> NORMALDATE("Posting Date") THEN
                                      AddError(STRSUBSTNO(Text009,FIELDCAPTION("Posting Date")));

                                    IF "Job Journal Batch"."No. Series" <> '' THEN
                                      IF NoSeries."Date Order" AND ("Posting Date" < LastPostingDate) THEN
                                        AddError(Text010);
                                    LastPostingDate := "Posting Date";

                                    IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                                      IF USERID <> '' THEN
                                        IF UserSetup.GET(USERID) THEN BEGIN
                                          AllowPostingFrom := UserSetup."Allow Posting From";
                                          AllowPostingTo := UserSetup."Allow Posting To";
                                        END;
                                      IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
                                        GLSetup.GET;
                                        AllowPostingFrom := GLSetup."Allow Posting From";
                                        AllowPostingTo := GLSetup."Allow Posting To";
                                      END;
                                      IF AllowPostingTo = 0D THEN
                                        AllowPostingTo := DMY2DATE(31,12,9999);
                                    END;
                                    IF ("Posting Date" < AllowPostingFrom) OR ("Posting Date" > AllowPostingTo) THEN
                                      AddError(STRSUBSTNO(Text011,FORMAT("Posting Date")))
                                    ELSE
                                      IF Type = Type::Item THEN BEGIN
                                        InvtPeriodEndDate := "Posting Date";
                                        IF NOT InvtPeriod.IsValidDate(InvtPeriodEndDate) THEN
                                          AddError(STRSUBSTNO(Text011,FORMAT("Posting Date")))
                                      END;
                                  END;

                                  IF "Document Date" <> 0D THEN
                                    IF "Document Date" <> NORMALDATE("Document Date") THEN
                                      AddError(STRSUBSTNO(Text009,FIELDCAPTION("Document Date")));

                                  IF "Job Journal Batch"."No. Series" <> '' THEN BEGIN
                                    IF LastDocNo <> '' THEN
                                      IF ("Document No." <> LastDocNo) AND ("Document No." <> INCSTR(LastDocNo)) THEN
                                        AddError(Text012);
                                    LastDocNo := "Document No.";
                                  END;

                                  IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                                    AddError(DimMgt.GetDimCombErr);

                                  TableID[1] := DATABASE::Job;
                                  No[1] := "Job No.";
                                  TableID[2] := DimMgt.TypeToTableID2(Type);
                                  No[2] := "No.";
                                  TableID[3] := DATABASE::"Resource Group";
                                  No[3] := "Resource Group No.";
                                  IF NOT DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") THEN
                                    AddError(DimMgt.GetDimValuePostingErr);
                                END;

               ReqFilterFields=Posting Date;
               DataItemLinkReference=Job Journal Batch;
               DataItemLink=Journal Template Name=FIELD(Journal Template Name),
                            Journal Batch Name=FIELD(Name) }

    { 1   ;3   ;Column  ;Job_Journal_Line__Line_Amount_;
               SourceExpr="Line Amount" }

    { 3   ;3   ;Column  ;Job_Journal_Line__Unit_Price_;
               SourceExpr="Unit Price" }

    { 5   ;3   ;Column  ;Job_Journal_Line__Total_Cost__LCY__;
               SourceExpr="Total Cost (LCY)" }

    { 7   ;3   ;Column  ;Job_Journal_Line__Unit_Cost__LCY__;
               SourceExpr="Unit Cost (LCY)" }

    { 9   ;3   ;Column  ;Job_Journal_Line__Work_Type_Code_;
               SourceExpr="Work Type Code" }

    { 11  ;3   ;Column  ;Job_Journal_Line__Unit_of_Measure_Code_;
               SourceExpr="Unit of Measure Code" }

    { 15  ;3   ;Column  ;Job_Journal_Line_Quantity;
               SourceExpr=Quantity }

    { 19  ;3   ;Column  ;Job_Journal_Line__No__;
               SourceExpr="No." }

    { 21  ;3   ;Column  ;Job_Journal_Line_Type;
               SourceExpr=Type }

    { 23  ;3   ;Column  ;Job_Journal_Line__Document_No__;
               SourceExpr="Document No." }

    { 25  ;3   ;Column  ;Job_Journal_Line__Job_No__;
               SourceExpr="Job No." }

    { 27  ;3   ;Column  ;Job_Journal_Line__Posting_Date_;
               SourceExpr=FORMAT("Posting Date") }

    { 49  ;3   ;Column  ;Job_Journal_Line_Journal_Template_Name;
               SourceExpr="Journal Template Name" }

    { 51  ;3   ;Column  ;Job_Journal_Line_Line_No_;
               SourceExpr="Line No." }

    { 9775;3   ;DataItem;DimensionLoop       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowDim THEN
                                 CurrReport.BREAK;
                               DimSetEntry.SETRANGE("Dimension Set ID","Job Journal Line"."Dimension Set ID");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry.FINDSET THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF NOT Continue THEN
                                      CurrReport.BREAK;

                                  CLEAR(DimText);
                                  Continue := FALSE;
                                  REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                      DimText := STRSUBSTNO('%1 - %2',DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code")
                                    ELSE
                                      DimText :=
                                        STRSUBSTNO(
                                          '%1; %2 - %3',DimText,DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                      DimText := OldDimText;
                                      Continue := TRUE;
                                      EXIT;
                                    END;
                                  UNTIL DimSetEntry.NEXT = 0;
                                END;
                                 }

    { 40  ;4   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 1000000001;4;Column;ShowDimensionLoop1 ;
               SourceExpr=Number = 1 }

    { 1000000002;4;Column;ShowDimensionLoop2 ;
               SourceExpr=Number > 1 }

    { 41  ;4   ;Column  ;DimensionsCaption   ;
               SourceExpr=DimensionsCaptionLbl }

    { 1162;3   ;DataItem;ErrorLoop           ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,ErrorCounter);
                             END;

               OnPostDataItem=BEGIN
                                ErrorCounter := 0;
                              END;
                               }

    { 38  ;4   ;Column  ;ErrorText_Number_   ;
               SourceExpr=ErrorText[Number] }

    { 39  ;4   ;Column  ;ErrorText_Number_Caption;
               SourceExpr=ErrorText_Number_CaptionLbl }

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

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Vis dimensioner;
                             ENU=Show Dimensions];
                  ToolTipML=[DAN=Angiver, at dimensionerne for hver post eller bogf�ringsgruppe h�rer med.;
                             ENU=Specifies that the dimensions for each entry or posting group are included.];
                  ApplicationArea=#Jobs;
                  SourceExpr=ShowDim }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Der kan ikke s�ttes filter p� %1, n�r du bogf�rer gentagelseskladder.;ENU=%1 cannot be filtered when you post recurring journals.';
      Text001@1001 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be specified.';
      Text002@1002 : TextConst 'DAN=Sag %1 findes ikke.;ENU=Job %1 does not exist.';
      Text003@1003 : TextConst 'DAN=%1 m� ikke v�re %2 for sagen %3.;ENU=%1 must not be %2 for job %3.';
      Text004@1004 : TextConst 'DAN=%1 %2 %3 findes ikke.;ENU=%1 %2 %3 does not exist.';
      Text005@1005 : TextConst 'DAN=Ressource %1 findes ikke.;ENU=Resource %1 does not exist.';
      Text006@1006 : TextConst 'DAN=%1 skal v�re %2 for ressource %3.;ENU=%1 must be %2 for resource %3.';
      Text007@1007 : TextConst 'DAN=Vare %1 findes ikke.;ENU=Item %1 does not exist.';
      Text008@1008 : TextConst 'DAN=%1 skal v�re %2 for vare %3.;ENU=%1 must be %2 for item %3.';
      Text009@1009 : TextConst 'DAN=%1 m� ikke v�re en ultimodato.;ENU=%1 must not be a closing date.';
      Text010@1010 : TextConst 'DAN=Linjerne er ikke sorteret efter bogf�ringsdato, fordi de ikke blev indtastet i den r�kkef�lge.;ENU=The lines are not listed according to posting date because they were not entered in that order.';
      Text011@1011 : TextConst 'DAN=%1 er ikke inden for den tilladte bogf�ringsperiode.;ENU=%1 is not within your allowed range of posting dates.';
      Text012@1012 : TextConst 'DAN=Der er et hul i nummerserien.;ENU=There is a gap in the number series.';
      Text013@1013 : TextConst 'DAN=%1 kan ikke indtastes.;ENU=%1 cannot be specified.';
      Text014@1014 : TextConst 'DAN=<Month Text>;ENU=<Month Text>';
      UserSetup@1015 : Record 91;
      GLSetup@1016 : Record 98;
      AccountingPeriod@1017 : Record 50;
      Job@1018 : Record 167;
      JT@1043 : Record 1001;
      Res@1019 : Record 156;
      Item@1020 : Record 27;
      JobJnlTemplate@1021 : Record 209;
      GenPostingSetup@1022 : Record 252;
      NoSeries@1023 : Record 308;
      DimSetEntry@1024 : Record 480;
      InvtPeriod@1045 : Record 5814;
      DimMgt@1025 : Codeunit 408;
      AllowPostingFrom@1026 : Date;
      AllowPostingTo@1027 : Date;
      Day@1028 : Integer;
      Week@1029 : Integer;
      Month@1030 : Integer;
      MonthText@1031 : Text[30];
      ErrorCounter@1032 : Integer;
      ErrorText@1033 : ARRAY [50] OF Text[250];
      JobJnlLineFilter@1034 : Text;
      LastPostingDate@1035 : Date;
      LastDocNo@1036 : Code[20];
      TableID@1037 : ARRAY [10] OF Integer;
      No@1038 : ARRAY [10] OF Code[20];
      DimText@1039 : Text[120];
      OldDimText@1040 : Text[120];
      ShowDim@1041 : Boolean;
      Continue@1042 : Boolean;
      Text015@1044 : TextConst 'DAN=%1 %2 findes ikke.;ENU=%1 %2 does not exist.';
      Job_Journal_Batch___Journal_Template_Name_CaptionLbl@6865 : TextConst 'DAN=Kladdetype;ENU=Journal Template';
      Job_Journal_Batch__NameCaptionLbl@8527 : TextConst 'DAN=Kladdenavn;ENU=Journal Batch';
      Job_Journal___TestCaptionLbl@3990 : TextConst 'DAN=Sagskladde - kontrol;ENU=Job Journal - Test';
      CurrReport_PAGENOCaptionLbl@8565 : TextConst 'DAN=Side;ENU=Page';
      Job_Journal_Line__Posting_Date_CaptionLbl@1674 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      DimensionsCaptionLbl@2995 : TextConst 'DAN=Dimensioner;ENU=Dimensions';
      ErrorText_Number_CaptionLbl@5070 : TextConst 'DAN=Advarsel!;ENU=Warning!';

    LOCAL PROCEDURE CheckRecurringLine@2(JobJnlLine2@1000 : Record 210);
    BEGIN
      WITH JobJnlLine2 DO
        IF JobJnlTemplate.Recurring THEN BEGIN
          IF "Recurring Method" = 0 THEN
            AddError(STRSUBSTNO(Text001,FIELDCAPTION("Recurring Method")));
          IF FORMAT("Recurring Frequency") = '' THEN
            AddError(STRSUBSTNO(Text001,FIELDCAPTION("Recurring Frequency")));
          IF "Recurring Method" = "Recurring Method"::Variable THEN
            IF Quantity = 0 THEN
              AddError(STRSUBSTNO(Text001,FIELDCAPTION(Quantity)));
        END ELSE BEGIN
          IF "Recurring Method" <> 0 THEN
            AddError(STRSUBSTNO(Text013,FIELDCAPTION("Recurring Method")));
          IF FORMAT("Recurring Frequency") <> '' THEN
            AddError(STRSUBSTNO(Text013,FIELDCAPTION("Recurring Frequency")));
        END;
    END;

    LOCAL PROCEDURE MakeRecurringTexts@3(VAR JobJnlLine2@1000 : Record 210);
    BEGIN
      WITH JobJnlLine2 DO
        IF ("Posting Date" <> 0D) AND ("No." <> '') AND ("Recurring Method" <> 0) THEN BEGIN
          Day := DATE2DMY("Posting Date",1);
          Week := DATE2DWY("Posting Date",2);
          Month := DATE2DMY("Posting Date",2);
          MonthText := FORMAT("Posting Date",0,Text014);
          AccountingPeriod.SETRANGE("Starting Date",0D,"Posting Date");
          IF NOT AccountingPeriod.FINDLAST THEN
            AccountingPeriod.Name := '';
          "Document No." :=
            DELCHR(PADSTR(STRSUBSTNO("Document No.",Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN("Document No.")),'>');
          Description :=
            DELCHR(PADSTR(STRSUBSTNO(Description,Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN(Description)),'>');
        END;
    END;

    LOCAL PROCEDURE AddError@1(Text@1000 : Text[250]);
    BEGIN
      ErrorCounter := ErrorCounter + 1;
      ErrorText[ErrorCounter] := Text;
    END;

    PROCEDURE InitializeRequest@4(NewShowDim@1001 : Boolean);
    BEGIN
      ShowDim := NewShowDim;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
    <?xml version="1.0" encoding="utf-8"?>
<Report xmlns="http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner">
  <AutoRefresh>0</AutoRefresh>
  <DataSources>
    <DataSource Name="DataSource">
      <ConnectionProperties>
        <DataProvider>SQL</DataProvider>
        <ConnectString />
      </ConnectionProperties>
      <rd:SecurityType>None</rd:SecurityType>
      <rd:DataSourceID>99331e9d-29f5-42bf-9560-1195c7942230</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="Job_Journal_Batch_Name">
          <DataField>Job_Journal_Batch_Name</DataField>
        </Field>
        <Field Name="COMPANYNAME">
          <DataField>COMPANYNAME</DataField>
        </Field>
        <Field Name="Job_Journal_Batch___Journal_Template_Name_">
          <DataField>Job_Journal_Batch___Journal_Template_Name_</DataField>
        </Field>
        <Field Name="Job_Journal_Batch__Name">
          <DataField>Job_Journal_Batch__Name</DataField>
        </Field>
        <Field Name="FORMAT_TODAY_0_4_">
          <DataField>FORMAT_TODAY_0_4_</DataField>
        </Field>
        <Field Name="CurrReport_PAGENO">
          <DataField>CurrReport_PAGENO</DataField>
        </Field>
        <Field Name="Job_Journal_Line__TABLECAPTION__________JobJnlLineFilter">
          <DataField>Job_Journal_Line__TABLECAPTION__________JobJnlLineFilter</DataField>
        </Field>
        <Field Name="JobJnlLineFilter">
          <DataField>JobJnlLineFilter</DataField>
        </Field>
        <Field Name="Job_Journal_Batch___Journal_Template_Name_Caption">
          <DataField>Job_Journal_Batch___Journal_Template_Name_Caption</DataField>
        </Field>
        <Field Name="Job_Journal_Batch__NameCaption">
          <DataField>Job_Journal_Batch__NameCaption</DataField>
        </Field>
        <Field Name="Job_Journal___TestCaption">
          <DataField>Job_Journal___TestCaption</DataField>
        </Field>
        <Field Name="CurrReport_PAGENOCaption">
          <DataField>CurrReport_PAGENOCaption</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Line_Amount_Caption">
          <DataField>Job_Journal_Line__Line_Amount_Caption</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Unit_Price_Caption">
          <DataField>Job_Journal_Line__Unit_Price_Caption</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Total_Cost__LCY__Caption">
          <DataField>Job_Journal_Line__Total_Cost__LCY__Caption</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Unit_Cost__LCY__Caption">
          <DataField>Job_Journal_Line__Unit_Cost__LCY__Caption</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Work_Type_Code_Caption">
          <DataField>Job_Journal_Line__Work_Type_Code_Caption</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Unit_of_Measure_Code_Caption">
          <DataField>Job_Journal_Line__Unit_of_Measure_Code_Caption</DataField>
        </Field>
        <Field Name="Job_Journal_Line_QuantityCaption">
          <DataField>Job_Journal_Line_QuantityCaption</DataField>
        </Field>
        <Field Name="Job_Journal_Line__No__Caption">
          <DataField>Job_Journal_Line__No__Caption</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Document_No__Caption">
          <DataField>Job_Journal_Line__Document_No__Caption</DataField>
        </Field>
        <Field Name="Job_Journal_Line_TypeCaption">
          <DataField>Job_Journal_Line_TypeCaption</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Job_No__Caption">
          <DataField>Job_Journal_Line__Job_No__Caption</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Posting_Date_Caption">
          <DataField>Job_Journal_Line__Posting_Date_Caption</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Line_Amount_">
          <DataField>Job_Journal_Line__Line_Amount_</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Line_Amount_Format">
          <DataField>Job_Journal_Line__Line_Amount_Format</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Unit_Price_">
          <DataField>Job_Journal_Line__Unit_Price_</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Unit_Price_Format">
          <DataField>Job_Journal_Line__Unit_Price_Format</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Total_Cost__LCY__">
          <DataField>Job_Journal_Line__Total_Cost__LCY__</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Total_Cost__LCY__Format">
          <DataField>Job_Journal_Line__Total_Cost__LCY__Format</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Unit_Cost__LCY__">
          <DataField>Job_Journal_Line__Unit_Cost__LCY__</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Unit_Cost__LCY__Format">
          <DataField>Job_Journal_Line__Unit_Cost__LCY__Format</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Work_Type_Code_">
          <DataField>Job_Journal_Line__Work_Type_Code_</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Unit_of_Measure_Code_">
          <DataField>Job_Journal_Line__Unit_of_Measure_Code_</DataField>
        </Field>
        <Field Name="Job_Journal_Line_Quantity">
          <DataField>Job_Journal_Line_Quantity</DataField>
        </Field>
        <Field Name="Job_Journal_Line_QuantityFormat">
          <DataField>Job_Journal_Line_QuantityFormat</DataField>
        </Field>
        <Field Name="Job_Journal_Line__No__">
          <DataField>Job_Journal_Line__No__</DataField>
        </Field>
        <Field Name="Job_Journal_Line_Type">
          <DataField>Job_Journal_Line_Type</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Document_No__">
          <DataField>Job_Journal_Line__Document_No__</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Job_No__">
          <DataField>Job_Journal_Line__Job_No__</DataField>
        </Field>
        <Field Name="Job_Journal_Line__Posting_Date_">
          <DataField>Job_Journal_Line__Posting_Date_</DataField>
        </Field>
        <Field Name="Job_Journal_Line_Journal_Template_Name">
          <DataField>Job_Journal_Line_Journal_Template_Name</DataField>
        </Field>
        <Field Name="Job_Journal_Line_Line_No_">
          <DataField>Job_Journal_Line_Line_No_</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="ShowDimensionLoop1">
          <DataField>ShowDimensionLoop1</DataField>
        </Field>
        <Field Name="ShowDimensionLoop2">
          <DataField>ShowDimensionLoop2</DataField>
        </Field>
        <Field Name="DimensionsCaption">
          <DataField>DimensionsCaption</DataField>
        </Field>
        <Field Name="ErrorText_Number_">
          <DataField>ErrorText_Number_</DataField>
        </Field>
        <Field Name="ErrorText_Number_Caption">
          <DataField>ErrorText_Number_Caption</DataField>
        </Field>
      </Fields>
      <rd:DataSetInfo>
        <rd:DataSetName>DataSet</rd:DataSetName>
        <rd:SchemaPath>Report.xsd</rd:SchemaPath>
        <rd:TableName>Result</rd:TableName>
      </rd:DataSetInfo>
    </DataSet>
  </DataSets>
  <ReportSections>
    <ReportSection>
      <Body>
        <ReportItems>
          <Textbox Name="textbox1">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Fields!Job_Journal_Line__TABLECAPTION__________JobJnlLineFilter.Value</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
              </Paragraph>
            </Paragraphs>
            <rd:DefaultName>textbox1</rd:DefaultName>
            <Height>0.423cm</Height>
            <Width>18.15cm</Width>
            <ZIndex>1</ZIndex>
            <Visibility>
              <Hidden>= IIF(Fields!JobJnlLineFilter.Value = "", TRUE, FALSE)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <PaddingRight>2pt</PaddingRight>
              <PaddingTop>2pt</PaddingTop>
              <PaddingBottom>2pt</PaddingBottom>
            </Style>
          </Textbox>
          <Tablix Name="Table1">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>1.3cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.2cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.5cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.65cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.8cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.6cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.3cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.2cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.6cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.6cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.9cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.6cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.9cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.1cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="COMPANYNAME">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!COMPANYNAME.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>44</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal___TestCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal___TestCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>43</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CurrReport_PAGENOCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrReport_PAGENOCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>42</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="FORMAT_TODAY_0_4_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!FORMAT_TODAY_0_4_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>41</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Batch___Journal_Template_Name_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Batch___Journal_Template_Name_Caption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>40</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Batch___Journal_Template_Name_">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Batch___Journal_Template_Name_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>39</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Batch__NameCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Batch__NameCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>38</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Batch_Name">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Batch_Name.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>37</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox14">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox14</rd:DefaultName>
                          <ZIndex>36</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox17">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox17</rd:DefaultName>
                          <ZIndex>35</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox18">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox18</rd:DefaultName>
                          <ZIndex>34</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox19">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox19</rd:DefaultName>
                          <ZIndex>33</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox20">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox20</rd:DefaultName>
                          <ZIndex>32</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>1.269cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line__Posting_Date_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line__Posting_Date_Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>31</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0cm</PaddingLeft>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line__Job_No__Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line__Job_No__Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>30</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.1cm</PaddingLeft>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line__Document_No__Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line__Document_No__Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>29</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.05cm</PaddingLeft>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line_TypeCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line_TypeCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>28</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line__No__Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line__No__Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>27</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.1cm</PaddingLeft>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line_QuantityCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line_QuantityCaption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>26</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line__Unit_of_Measure_Code_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line__Unit_of_Measure_Code_Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>25</ZIndex>
                          <Style>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>0.29cm</PaddingTop>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line__Work_Type_Code_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line__Work_Type_Code_Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>24</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line__Unit_Cost__LCY__Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line__Unit_Cost__LCY__Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>23</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line__Total_Cost__LCY__Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line__Total_Cost__LCY__Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>22</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line__Unit_Price_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line__Unit_Price_Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>21</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Job_Journal_Line__Line_Amount_Caption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Job_Journal_Line__Line_Amount_Caption.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>20</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingBottom>0.423cm</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox130">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line__Posting_Date_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>19</ZIndex>
                          <Style>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox131">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line__Job_No__.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>18</ZIndex>
                          <Style>
                            <PaddingLeft>0.1cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox132">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line__Document_No__.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>=iif(IsNumeric(Fields!Job_Journal_Line__Document_No__.Value),"Right","Left")</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>17</ZIndex>
                          <Style>
                            <PaddingLeft>0.05cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox133">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line_Type.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>16</ZIndex>
                          <Style>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox134">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line__No__.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>15</ZIndex>
                          <Style>
                            <PaddingLeft>0.1cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox135">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line_Quantity.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!Job_Journal_Line_QuantityFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>14</ZIndex>
                          <Style>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox136">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line__Unit_of_Measure_Code_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>13</ZIndex>
                          <Style>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox137">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line__Work_Type_Code_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>12</ZIndex>
                          <Style>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox138">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line__Unit_Cost__LCY__.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>#,##0.00###</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>11</ZIndex>
                          <Style>
                            <PaddingLeft>0cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox139">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line__Total_Cost__LCY__.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>N</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>10</ZIndex>
                          <Style>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox140">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line__Unit_Price_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>N</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>9</ZIndex>
                          <Style>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox141">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Job_Journal_Line__Line_Amount_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>N</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>8</ZIndex>
                          <Style>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox7">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DimensionsCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox7</rd:DefaultName>
                          <ZIndex>7</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox11">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DimText.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox11</rd:DefaultName>
                          <ZIndex>6</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.3cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>10</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox28">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox28</rd:DefaultName>
                          <ZIndex>5</ZIndex>
                          <Style>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox4">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox4</rd:DefaultName>
                          <ZIndex>4</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox2</rd:DefaultName>
                          <ZIndex>3</ZIndex>
                          <Style>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox120">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DimText.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>2</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.3cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>10</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox15">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!ErrorText_Number_Caption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox15</rd:DefaultName>
                          <ZIndex>1</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox16">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!ErrorText_Number_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox16</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.15cm</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>11</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
              </TablixRows>
            </TablixBody>
            <TablixColumnHierarchy>
              <TablixMembers>
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
                <TablixMember />
              </TablixMembers>
            </TablixColumnHierarchy>
            <TablixRowHierarchy>
              <TablixMembers>
                <TablixMember>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Group Name="Table1_Group1">
                    <GroupExpressions>
                      <GroupExpression>=Fields!Job_Journal_Line_Journal_Template_Name.Value</GroupExpression>
                      <GroupExpression>=Fields!Job_Journal_Batch_Name.Value</GroupExpression>
                      <GroupExpression>=Fields!Job_Journal_Line_Line_No_.Value</GroupExpression>
                    </GroupExpressions>
                  </Group>
                  <TablixMembers>
                    <TablixMember>
                      <Group Name="Table1_Group2">
                        <GroupExpressions>
                          <GroupExpression>=Fields!Job_Journal_Line__Job_No__.Value</GroupExpression>
                        </GroupExpressions>
                      </Group>
                      <TablixMembers>
                        <TablixMember>
                          <KeepWithGroup>After</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Group Name="Table1_Details_Group">
                            <DataElementName>Detail</DataElementName>
                          </Group>
                          <TablixMembers>
                            <TablixMember>
                              <Visibility>
                                <Hidden>= IIF(Fields!ShowDimensionLoop1.Value = TRUE, FALSE,TRUE)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>= IIF(Fields!ShowDimensionLoop2.Value = TRUE, FALSE,TRUE)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>= IIF(Fields!ErrorText_Number_Caption.Value = "" AND
      Fields!ErrorText_Number_.Value = "", TRUE, FALSE)</Hidden>
                              </Visibility>
                            </TablixMember>
                          </TablixMembers>
                          <DataElementName>Detail_Collection</DataElementName>
                          <DataElementOutput>Output</DataElementOutput>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                      </TablixMembers>
                    </TablixMember>
                  </TablixMembers>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>0.423cm</Top>
            <Width>18.15cm</Width>
          </Tablix>
        </ReportItems>
        <Height>3.484cm</Height>
      </Body>
      <Width>18.5cm</Width>
      <Page>
        <PageHeader>
          <Height>2.115cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="Job_Journal_Batch_Name1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>= ReportItems!Job_Journal_Batch_Name.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>1.692cm</Top>
              <Left>3.15cm</Left>
              <Width>1.5cm</Width>
              <ZIndex>9</ZIndex>
              <Visibility>
                <Hidden>=IIF(ReportItems!CurrReport_PAGENOCaption.Value = "",TRUE,FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="Job_Journal_Batch__NameCaption1">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>= ReportItems!Job_Journal_Batch__NameCaption.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>1.692cm</Top>
              <Width>3cm</Width>
              <ZIndex>8</ZIndex>
              <Visibility>
                <Hidden>=IIF(ReportItems!CurrReport_PAGENOCaption.Value = "",TRUE,FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="Job_Journal_Batch___Journal_Template_Name_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>= ReportItems!Job_Journal_Batch___Journal_Template_Name_.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>1.269cm</Top>
              <Left>3.15cm</Left>
              <Height>0.423cm</Height>
              <Width>1.5cm</Width>
              <ZIndex>7</ZIndex>
              <Visibility>
                <Hidden>=IIF(ReportItems!CurrReport_PAGENOCaption.Value = "",TRUE,FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="Job_Journal_Batch___Journal_Template_Name_Caption1">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>= ReportItems!Job_Journal_Batch___Journal_Template_Name_Caption.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>1.269cm</Top>
              <Height>0.423cm</Height>
              <Width>3cm</Width>
              <ZIndex>6</ZIndex>
              <Visibility>
                <Hidden>=IIF(ReportItems!CurrReport_PAGENOCaption.Value = "",TRUE,FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="PageNumberTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Globals!PageNumber</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Left>17.7cm</Left>
              <Height>0.423cm</Height>
              <Width>0.45cm</Width>
              <ZIndex>5</ZIndex>
              <Visibility>
                <Hidden>=IIF(ReportItems!CurrReport_PAGENOCaption.Value = "",TRUE,FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="UserIdTextBox">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=User!UserID</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.846cm</Top>
              <Left>14.9cm</Left>
              <Height>0.423cm</Height>
              <Width>3.25cm</Width>
              <ZIndex>4</ZIndex>
              <Visibility>
                <Hidden>=IIF(ReportItems!CurrReport_PAGENOCaption.Value = "",TRUE,FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ExecutionTimeTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>= ReportItems!FORMAT_TODAY_0_4_.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Format>g</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>15cm</Left>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CurrReport_PAGENOCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=ReportItems!CurrReport_PAGENOCaption.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Left>16.95cm</Left>
              <Height>0.423cm</Height>
              <Width>0.75cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="COMPANYNAME1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=ReportItems!COMPANYNAME.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Job_Journal___TestCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=ReportItems!Job_Journal___TestCaption.Value</Value>
                      <Style>
                        <FontSize>8pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
          </ReportItems>
        </PageHeader>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.5cm</LeftMargin>
        <TopMargin>2cm</TopMargin>
        <BottomMargin>2cm</BottomMargin>
      </Page>
    </ReportSection>
  </ReportSections>
  <Code>Public Function BlankZero(ByVal Value As Decimal)
    if Value = 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankPos(ByVal Value As Decimal)
    if Value &gt; 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankZeroAndPos(ByVal Value As Decimal)
    if Value &gt;= 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankNeg(ByVal Value As Decimal)
    if Value &lt; 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankNegAndZero(ByVal Value As Decimal)
    if Value &lt;= 0 then
        Return ""
    end if
    Return Value
End Function
</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Invalid</rd:ReportUnitType>
  <rd:ReportID>76bb14b4-b26d-4acb-9e2e-b43e2670f085</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

