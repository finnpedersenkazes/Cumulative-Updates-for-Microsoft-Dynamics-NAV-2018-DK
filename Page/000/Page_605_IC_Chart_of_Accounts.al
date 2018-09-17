OBJECT Page 605 IC Chart of Accounts
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Koncernintern kontoplan;
               ENU=Intercompany Chart of Accounts];
    SourceTable=Table410;
    PageType=List;
    CardPageID=IC G/L Account Card;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Import/eksport;
                                ENU=New,Process,Report,Import/Export];
    OnAfterGetRecord=BEGIN
                       NameIndent := 0;
                       FormatLine;
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Kobl til konto med samme nr.;
                                 ENU=Map to Acc. with Same No.];
                      ToolTipML=[DAN=Knyt de valgte koncerninterne finanskonti til finanskonti med samme nummer.;
                                 ENU=Map the selected intercompany G/L accounts to G/L accounts with the same number.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=MapAccounts;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ICGLAcc@1001 : Record 410;
                                 ICMapping@1000 : Codeunit 428;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ICGLAcc);
                                 IF ICGLAcc.FIND('-') AND CONFIRM(Text000) THEN
                                   REPEAT
                                     ICMapping.MapAccounts(ICGLAcc);
                                   UNTIL ICGLAcc.NEXT = 0;
                               END;
                                }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Kopi‚r fra kontoplan;
                                 ENU=Copy from Chart of Accounts];
                      ToolTipML=[DAN=Opret koncerninterne finanskonti fra finanskonti.;
                                 ENU=Create intercompany G/L accounts from G/L accounts.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=CopyFromChartOfAccounts;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CopyFromChartOfAccounts;
                               END;
                                }
      { 20      ;2   ;Action    ;
                      CaptionML=[DAN=In&dryk IC-kontoplan;
                                 ENU=In&dent IC Chart of Accounts];
                      ToolTipML=[DAN=Indryk konti mellem en Fra-sum og den tilh›rende Til-sum ‚t niveau for at g›re kontoplanen mere overskuelig.;
                                 ENU=Indent accounts between a Begin-Total and the matching End-Total one level to make the chart of accounts easier to read.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=Indent;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 IndentCOA@1000 : Codeunit 3;
                               BEGIN
                                 IndentCOA.RunICAccountIndent;
                               END;
                                }
      { 21      ;2   ;Separator  }
      { 17      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indl‘s;
                                 ENU=Import];
                      ToolTipML=[DAN=Import‚r en koncernintern kontoplan fra en fil.;
                                 ENU=Import an intercompany chart of accounts from a file.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=Import;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ImportFromXML;
                               END;
                                }
      { 22      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Ud&l‘s;
                                 ENU=E&xport];
                      ToolTipML=[DAN=Eksport‚r den koncerninterne kontoplan til en fil.;
                                 ENU=Export the intercompany chart of accounts to a file.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=Export;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ExportToXML;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=NameIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Intercompany;
                SourceExpr="No.";
                Style=Strong;
                StyleExpr=Emphasize }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den koncerninterne finanskonto.;
                           ENU=Specifies the name of the IC general ledger account.];
                ApplicationArea=#Intercompany;
                SourceExpr=Name;
                Style=Strong;
                StyleExpr=Emphasize }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en finanskonto er en resultatopg›relseskonto eller en balancekonto.;
                           ENU=Specifies whether a general ledger account is an income statement account or a balance sheet account.];
                ApplicationArea=#Intercompany;
                SourceExpr="Income/Balance" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver form†let med kontoen. I alt: Bruges til at samment‘lle en r‘kke saldi p† konti fra mange forskellige grupper. Lad feltet st† tomt, hvis du vil bruge I alt. Fra-Sum: En markering af begyndelsen af en r‘kke konti, der skal samment‘lles og slutter med en Til-sum-konto. Til-sum: Det samlede antal konti, der starter med den foreg†ende Fra-sum-konto. Det samlede antal er defineret i feltet Samment‘lling.;
                           ENU=Specifies the purpose of the account. Total: Used to total a series of balances on accounts from many different account groupings. To use Total, leave this field blank. Begin-Total: A marker for the beginning of a series of accounts to be totaled that ends with an End-Total account. End-Total: A total of a series of accounts that starts with the preceding Begin-Total account. The total is defined in the Totaling field.];
                ApplicationArea=#Intercompany;
                SourceExpr="Account Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Intercompany;
                SourceExpr=Blocked }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiverÿnummeret p† den finanskonto i din kontoplan, som svarer til den koncerninterne finanskonto.;
                           ENU=Specifies the number of the G/L account in your chart of accounts that corresponds to this intercompany G/L account.];
                ApplicationArea=#Intercompany;
                SourceExpr="Map-to G/L Acc. No." }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Er du sikker p†, at du vil koble de valgte linjer?;ENU=Are you sure you want to map the selected lines?';
      Text001@1002 : TextConst 'DAN=V‘lg fil, der skal indl‘ses i %1;ENU=Select file to import into %1';
      Text002@1001 : TextConst 'DAN=ICGLAcc.xml;ENU=ICGLAcc.xml';
      Text004@1004 : TextConst 'DAN=Er du sikker p†, at du vil kopiere fra %1?;ENU=Are you sure you want to copy from %1?';
      Emphasize@19018670 : Boolean INDATASET;
      NameIndent@19079073 : Integer INDATASET;
      Text005@1005 : TextConst 'DAN=Indtast filnavn.;ENU=Enter the file name.';
      Text006@1006 : TextConst 'DAN=XML-filer (*.xml)|*.xml|Alle filer (*.*)|*.*;ENU=XML Files (*.xml)|*.xml|All Files (*.*)|*.*';

    LOCAL PROCEDURE CopyFromChartOfAccounts@1();
    VAR
      GLAcc@1000 : Record 15;
      ICGLAcc@1001 : Record 410;
      ChartofAcc@1005 : Page 16;
      ICGLAccEmpty@1002 : Boolean;
      ICGLAccExists@1003 : Boolean;
      PrevIndentation@1004 : Integer;
    BEGIN
      IF NOT CONFIRM(Text004,FALSE,ChartofAcc.CAPTION) THEN
        EXIT;

      ICGLAccEmpty := NOT ICGLAcc.FINDFIRST;
      ICGLAcc.LOCKTABLE;
      IF GLAcc.FIND('-') THEN
        REPEAT
          IF GLAcc."Account Type" = GLAcc."Account Type"::"End-Total" THEN
            PrevIndentation := PrevIndentation - 1;
          IF NOT ICGLAccEmpty THEN
            ICGLAccExists := ICGLAcc.GET(GLAcc."No.");
          IF NOT ICGLAccExists AND NOT GLAcc.Blocked THEN BEGIN
            ICGLAcc.INIT;
            ICGLAcc."No." := GLAcc."No.";
            ICGLAcc.Name := GLAcc.Name;
            ICGLAcc."Account Type" := GLAcc."Account Type";
            ICGLAcc."Income/Balance" := GLAcc."Income/Balance";
            ICGLAcc.Indentation := PrevIndentation;
            ICGLAcc.INSERT;
          END;
          PrevIndentation := GLAcc.Indentation;
          IF GLAcc."Account Type" = GLAcc."Account Type"::"Begin-Total" THEN
            PrevIndentation := PrevIndentation + 1;
        UNTIL GLAcc.NEXT = 0;
    END;

    LOCAL PROCEDURE ImportFromXML@2();
    VAR
      CompanyInfo@1006 : Record 79;
      ICGLAccIO@1002 : XMLport 10;
      IFile@1000 : File;
      IStr@1001 : InStream;
      FileName@1004 : Text[1024];
      StartFileName@1003 : Text[1024];
    BEGIN
      CompanyInfo.GET;

      StartFileName := CompanyInfo."IC Inbox Details";
      IF StartFileName <> '' THEN BEGIN
        IF StartFileName[STRLEN(StartFileName)] <> '\' THEN
          StartFileName := StartFileName + '\';
        StartFileName := StartFileName + '*.xml';
      END;

      IF NOT UPLOAD(STRSUBSTNO(Text001,TABLECAPTION),'',Text006,StartFileName,FileName) THEN
        ERROR(Text005);

      IFile.OPEN(FileName);
      IFile.CREATEINSTREAM(IStr);
      ICGLAccIO.SETSOURCE(IStr);
      ICGLAccIO.IMPORT;
    END;

    LOCAL PROCEDURE ExportToXML@3();
    VAR
      CompanyInfo@1006 : Record 79;
      FileMgt@1000 : Codeunit 419;
      ICGLAccIO@1005 : XMLport 10;
      OFile@1002 : File;
      OStr@1001 : OutStream;
      FileName@1004 : Text;
      DefaultFileName@1003 : Text;
    BEGIN
      CompanyInfo.GET;

      DefaultFileName := CompanyInfo."IC Inbox Details";
      IF DefaultFileName <> '' THEN
        IF DefaultFileName[STRLEN(DefaultFileName)] <> '\' THEN
          DefaultFileName := DefaultFileName + '\';
      DefaultFileName := DefaultFileName + Text002;

      FileName := FileMgt.ServerTempFileName('xml');
      IF FileName = '' THEN
        EXIT;

      OFile.CREATE(FileName);
      OFile.CREATEOUTSTREAM(OStr);
      ICGLAccIO.SETDESTINATION(OStr);
      ICGLAccIO.EXPORT;
      OFile.CLOSE;
      CLEAR(OStr);

      DOWNLOAD(FileName,'Export',TEMPORARYPATH,'',DefaultFileName);
    END;

    LOCAL PROCEDURE FormatLine@19039177();
    BEGIN
      NameIndent := Indentation;
      Emphasize := "Account Type" <> "Account Type"::Posting;
    END;

    BEGIN
    END.
  }
}

