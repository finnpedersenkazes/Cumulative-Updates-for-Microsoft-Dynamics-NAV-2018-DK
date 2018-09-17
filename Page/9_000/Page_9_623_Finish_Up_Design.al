OBJECT Page 9623 Finish Up Design
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=F‘rdigg›r design;
               ENU=Finish Up Design];
    PageType=NavigatePage;
    RefreshOnActivate=Yes;
    OnInit=VAR
             Designer@1000 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.Designer.NavDesignerALFunctions";
           BEGIN
             SaveVisible := TRUE;
             DownloadCode := FALSE;
             AppName := Designer.GetDesignerExtensionName();
             Publisher := Designer.GetDesignerExtensionPublisher();
             IF AppName = '' THEN
               NameAndPublisherEnabled := TRUE
             ELSE
               NameAndPublisherEnabled := FALSE;
           END;

    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      Name=Save;
                      CaptionML=[DAN=Gem;
                                 ENU=Save];
                      ApplicationArea=#Basic,#Suite;
                      Visible=SaveVisible;
                      InFooterBar=Yes;
                      Image=Approve;
                      OnAction=VAR
                                 TempBlob@1004 : TEMPORARY Record 99008535;
                                 FileManagement@1003 : Codeunit 419;
                                 NvOutStream@1002 : OutStream;
                                 Designer@1001 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.Designer.NavDesignerALFunctions";
                                 FileName@1000 : Text;
                                 CleanFileName@1005 : Text;
                               BEGIN
                                 IF STRLEN(AppName) = 0 THEN
                                   ERROR(BlankNameErr);

                                 IF STRLEN(Publisher) = 0 THEN
                                   ERROR(BlankPublisherErr);

                                 IF NOT Designer.ExtensionNameAndPublisherIsValid(AppName,Publisher) THEN
                                   ERROR(DuplicateNameAndPublisherErr);

                                 SaveVisible := FALSE;

                                 Designer.SaveDesignerExtension(AppName,Publisher);

                                 IF DownloadCode THEN BEGIN
                                   TempBlob.Blob.CREATEOUTSTREAM(NvOutStream);
                                   Designer.GenerateDesignerPackageZipStream(NvOutStream,Publisher,AppName);
                                   FileName := STRSUBSTNO(ExtensionFileNameTxt,AppName,Publisher);
                                   CleanFileName := Designer.SanitizeDesignerFileName(FileName,'_');
                                   FileManagement.BLOBExport(TempBlob,CleanFileName,TRUE);
                                 END;

                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Visible=SaveVisible;
                GroupType=Group }

    { 4   ;2   ;Field     ;
                Name=AppName;
                CaptionML=[DAN=Udvidelsesnavn;
                           ENU=Extension Name];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr=AppName;
                Enabled=NameAndPublisherEnabled;
                Editable=NameAndPublisherEnabled }

    { 5   ;2   ;Field     ;
                Name=Publisher;
                CaptionML=[DAN=Udgiver;
                           ENU=Publisher];
                ApplicationArea=#Basic,#Suite;
                NotBlank=Yes;
                SourceExpr=Publisher;
                Enabled=NameAndPublisherEnabled;
                Editable=NameAndPublisherEnabled }

    { 8   ;2   ;Field     ;
                Name=DownloadCode;
                CaptionML=[DAN=Download kode;
                           ENU=Download Code];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=DownloadCode }

  }
  CODE
  {
    VAR
      SaveVisible@1000 : Boolean;
      ExtensionFileNameTxt@1005 : TextConst '@@@="{Locked}; %1=Name, %2=Publisher";DAN=%1_%2_1.0.0.0.zip;ENU=%1_%2_1.0.0.0.zip';
      AppName@1002 : Text[250];
      Publisher@1003 : Text[250];
      DownloadCode@1004 : Boolean;
      BlankNameErr@1006 : TextConst '@@@=Specifies that field cannot be blank.;DAN=Navnet m† ikke v‘re tomt.;ENU=Name cannot be blank.';
      BlankPublisherErr@1007 : TextConst '@@@=Specifies that field cannot be blank.;DAN=Udgiveren skal angives.;ENU=Publisher cannot be blank.';
      NameAndPublisherEnabled@1001 : Boolean;
      DuplicateNameAndPublisherErr@1009 : TextConst '@@@=An extension with the same name and publisher already exists.;DAN=Det angivne navn og udgiver bruges allerede i en anden udvidelse. Angiv et andet navn og udgiver.;ENU=The specified name and publisher are already used in another extension. Please specify another name or publisher.';

    BEGIN
    END.
  }
}

