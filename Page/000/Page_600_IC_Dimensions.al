OBJECT Page 600 IC Dimensions
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Koncerninterne dimensioner;
               ENU=Intercompany Dimensions];
    SourceTable=Table411;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Dimensioner,Import/eksport;
                                ENU=New,Process,Report,Dimensions,Import/Export];
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=IC-&dimension;
                                 ENU=IC &Dimension] }
      { 16      ;2   ;Action    ;
                      CaptionML=[DAN=IC-dimensions&v‘rdier;
                                 ENU=IC Dimension &Values];
                      ToolTipML=[DAN=Vis eller rediger, hvordan din virksomheds dimensionsv‘rdier svarer til dimensionsv‘rdierne for dine koncerninterne partnere.;
                                 ENU=View or edit how your company's dimension values correspond to the dimension values of your intercompany partners.];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 601;
                      RunPageLink=Dimension Code=FIELD(Code);
                      Promoted=Yes;
                      Image=ChangeDimensions;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=Kobl til dim. med samme kode;
                                 ENU=Map to Dim. with Same Code];
                      ToolTipML=[DAN=Knyt de valgte koncerninterne dimensioner til dimensioner med samme kode.;
                                 ENU=Map the selected intercompany dimensions to dimensions with the same code.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=MapDimensions;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ICDimension@1001 : Record 411;
                                 ICMapping@1000 : Codeunit 428;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ICDimension);
                                 IF ICDimension.FIND('-') AND CONFIRM(Text000) THEN
                                   REPEAT
                                     ICMapping.MapIncomingICDimensions(ICDimension);
                                   UNTIL ICDimension.NEXT = 0;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=CopyFromDimensions;
                      CaptionML=[DAN=Kopi‚r fra dimensioner;
                                 ENU=Copy from Dimensions];
                      ToolTipML=[DAN=Opretter koncerninterne dimensioner for eksisterende dimensioner.;
                                 ENU=Creates intercompany dimensions for existing dimensions.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=CopyDimensions;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CopyFromDimensions;
                               END;
                                }
      { 14      ;2   ;Separator  }
      { 18      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indl‘s;
                                 ENU=Import];
                      ToolTipML=[DAN=Import‚r koncerninterne dimensioner fra en fil.;
                                 ENU=Import intercompany dimensions from a file.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=Import;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ImportFromXML;
                               END;
                                }
      { 19      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Ud&l‘s;
                                 ENU=E&xport];
                      ToolTipML=[DAN=Eksport‚r koncerninterne dimensioner til en fil.;
                                 ENU=Export intercompany dimensions to a file.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=Export;
                      PromotedCategory=Category5;
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncerninterne dimension.;
                           ENU=Specifies the intercompany dimension code.];
                ApplicationArea=#Intercompany;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den koncerninterne dimension;
                           ENU=Specifies the intercompany dimension name];
                ApplicationArea=#Intercompany;
                SourceExpr=Name }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Intercompany;
                SourceExpr=Blocked }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den dimension i din virksomhed, som denne koncerninterne dimension svarer til.;
                           ENU=Specifies the code of the dimension in your company that this intercompany dimension corresponds to.];
                ApplicationArea=#Intercompany;
                SourceExpr="Map-to Dimension Code" }

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
      Text001@1004 : TextConst 'DAN=V‘lg fil, der skal indl‘ses i %1;ENU=Select file to import into %1';
      Text002@1003 : TextConst 'DAN=ICDim.xml;ENU=ICDim.xml';
      Text004@1001 : TextConst 'DAN=Er du sikker p†, at du vil kopiere fra Dimensioner?;ENU=Are you sure you want to copy from Dimensions?';
      Text005@1002 : TextConst 'DAN=Indtast filnavn.;ENU=Enter the file name.';
      Text006@1005 : TextConst 'DAN=XML-filer (*.xml)|*.xml|Alle filer (*.*)|*.*;ENU=XML Files (*.xml)|*.xml|All Files (*.*)|*.*';

    LOCAL PROCEDURE CopyFromDimensions@1();
    VAR
      Dim@1000 : Record 348;
      DimVal@1005 : Record 349;
      ICDim@1001 : Record 411;
      ICDimVal@1006 : Record 412;
      ICDimValEmpty@1002 : Boolean;
      ICDimValExists@1003 : Boolean;
      PrevIndentation@1004 : Integer;
    BEGIN
      IF NOT CONFIRM(Text004,FALSE) THEN
        EXIT;

      ICDimVal.LOCKTABLE;
      ICDim.LOCKTABLE;
      Dim.SETRANGE(Blocked,FALSE);
      IF Dim.FIND('-') THEN
        REPEAT
          IF NOT ICDim.GET(Dim.Code) THEN BEGIN
            ICDim.INIT;
            ICDim.Code := Dim.Code;
            ICDim.Name := Dim.Name;
            ICDim.INSERT;
          END;

          ICDimValExists := FALSE;
          DimVal.SETRANGE("Dimension Code",Dim.Code);
          ICDimVal.SETRANGE("Dimension Code",Dim.Code);
          ICDimValEmpty := NOT ICDimVal.FINDFIRST;
          IF DimVal.FIND('-') THEN
            REPEAT
              IF DimVal."Dimension Value Type" = DimVal."Dimension Value Type"::"End-Total" THEN
                PrevIndentation := PrevIndentation - 1;
              IF NOT ICDimValEmpty THEN
                ICDimValExists := ICDimVal.GET(DimVal."Dimension Code",DimVal.Code);
              IF NOT ICDimValExists AND NOT DimVal.Blocked THEN BEGIN
                ICDimVal.INIT;
                ICDimVal."Dimension Code" := DimVal."Dimension Code";
                ICDimVal.Code := DimVal.Code;
                ICDimVal.Name := DimVal.Name;
                ICDimVal."Dimension Value Type" := DimVal."Dimension Value Type";
                ICDimVal.Indentation := PrevIndentation;
                ICDimVal.INSERT;
              END;
              PrevIndentation := ICDimVal.Indentation;
              IF DimVal."Dimension Value Type" = DimVal."Dimension Value Type"::"Begin-Total" THEN
                PrevIndentation := PrevIndentation + 1;
            UNTIL DimVal.NEXT = 0;
        UNTIL Dim.NEXT = 0;
    END;

    LOCAL PROCEDURE ImportFromXML@2();
    VAR
      CompanyInfo@1006 : Record 79;
      ICDimIO@1002 : XMLport 11;
      IFile@1001 : File;
      IStr@1000 : InStream;
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
      ICDimIO.SETSOURCE(IStr);
      ICDimIO.IMPORT;
    END;

    LOCAL PROCEDURE ExportToXML@3();
    VAR
      CompanyInfo@1006 : Record 79;
      FileMgt@1000 : Codeunit 419;
      ICDimIO@1005 : XMLport 11;
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
      ICDimIO.SETDESTINATION(OStr);
      ICDimIO.EXPORT;
      OFile.CLOSE;
      CLEAR(OStr);

      DOWNLOAD(FileName,'Export',TEMPORARYPATH,'',DefaultFileName);
    END;

    BEGIN
    END.
  }
}

