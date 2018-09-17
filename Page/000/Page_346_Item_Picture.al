OBJECT Page 346 Item Picture
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varebillede;
               ENU=Item Picture];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table27;
    PageType=CardPart;
    OnOpenPage=BEGIN
                 CameraAvailable := CameraProvider.IsAvailable;
                 IF CameraAvailable THEN
                   CameraProvider := CameraProvider.Create;
               END;

    OnAfterGetCurrRecord=BEGIN
                           SetEditableOnPictureActions;
                         END;

    ActionList=ACTIONS
    {
      { 2       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;Action    ;
                      Name=TakePicture;
                      CaptionML=[DAN=Tag;
                                 ENU=Take];
                      ToolTipML=[DAN=Aktiv‚r kameraet p† enheden.;
                                 ENU=Activate the camera on the device.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Visible=CameraAvailable AND (HideActions = FALSE);
                      PromotedIsBig=Yes;
                      Image=Camera;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 TakeNewPicture;
                               END;
                                }
      { 4       ;1   ;Action    ;
                      Name=ImportPicture;
                      CaptionML=[DAN=Indl‘s;
                                 ENU=Import];
                      ToolTipML=[DAN=Import‚r en billedfil.;
                                 ENU=Import a picture file.];
                      ApplicationArea=#All;
                      Visible=HideActions = FALSE;
                      Image=Import;
                      OnAction=BEGIN
                                 ImportFromDevice;
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Name=ExportFile;
                      CaptionML=[DAN=Udl‘s;
                                 ENU=Export];
                      ToolTipML=[DAN=Eksport‚r billedet til en fil.;
                                 ENU=Export the picture to a file.];
                      ApplicationArea=#All;
                      Visible=(CameraAvailable = FALSE) AND (HideActions = FALSE);
                      Enabled=DeleteExportEnabled;
                      Image=Export;
                      OnAction=VAR
                                 NameValueBuffer@1002 : Record 823;
                                 TempNameValueBuffer@1004 : TEMPORARY Record 823;
                                 FileManagement@1001 : Codeunit 419;
                                 ToFile@1003 : Text;
                                 ExportPath@1005 : Text;
                               BEGIN
                                 TESTFIELD("No.");
                                 TESTFIELD(Description);

                                 NameValueBuffer.DELETEALL;
                                 ExportPath := TEMPORARYPATH + "No." + FORMAT(Picture.MEDIAID);
                                 Picture.EXPORTFILE(ExportPath + '.jpg');
                                 FileManagement.GetServerDirectoryFilesList(TempNameValueBuffer,TEMPORARYPATH);
                                 TempNameValueBuffer.SETFILTER(Name,STRSUBSTNO('%1*',ExportPath));
                                 TempNameValueBuffer.FINDFIRST;
                                 ToFile := STRSUBSTNO('%1 %2.jpg',"No.",CONVERTSTR(Description,'"/\','___'));
                                 DOWNLOAD(TempNameValueBuffer.Name,DownloadImageTxt,'','',ToFile);
                                 IF FileManagement.DeleteServerFile(TempNameValueBuffer.Name) THEN;
                               END;
                                }
      { 7       ;1   ;Action    ;
                      Name=DeletePicture;
                      CaptionML=[DAN=Slet;
                                 ENU=Delete];
                      ToolTipML=[DAN=Slet recorden.;
                                 ENU=Delete the record.];
                      ApplicationArea=#All;
                      Visible=HideActions = FALSE;
                      Enabled=DeleteExportEnabled;
                      Image=Delete;
                      OnAction=BEGIN
                                 DeleteItemPicture;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver det billede, der er blevet indsat for varen.;
                           ENU=Specifies the picture that has been inserted for the item.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Picture;
                ShowCaption=No }

  }
  CODE
  {
    VAR
      CameraProvider@1000 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.CameraProvider" WITHEVENTS RUNONCLIENT;
      CameraAvailable@1002 : Boolean;
      OverrideImageQst@1007 : TextConst 'DAN=Det eksisterende billede erstattes. Vil du forts‘tte?;ENU=The existing picture will be replaced. Do you want to continue?';
      DeleteImageQst@1003 : TextConst 'DAN=Er du sikker p†, at billedet skal slettes?;ENU=Are you sure you want to delete the picture?';
      SelectPictureTxt@1001 : TextConst 'DAN=V‘lg et billede til overf›rsel;ENU=Select a picture to upload';
      DeleteExportEnabled@1005 : Boolean;
      DownloadImageTxt@1006 : TextConst 'DAN=Hent billede;ENU=Download image';
      HideActions@1008 : Boolean;

    [External]
    PROCEDURE TakeNewPicture@2();
    VAR
      CameraOptions@1000 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.CameraOptions";
    BEGIN
      FIND;
      TESTFIELD("No.");
      TESTFIELD(Description);

      IF NOT CameraAvailable THEN
        EXIT;

      CameraOptions := CameraOptions.CameraOptions;
      CameraOptions.Quality := 50;
      CameraProvider.RequestPictureAsync(CameraOptions);
    END;

    [External]
    PROCEDURE ImportFromDevice@4();
    VAR
      FileManagement@1002 : Codeunit 419;
      FileName@1001 : Text;
      ClientFileName@1000 : Text;
    BEGIN
      FIND;
      TESTFIELD("No.");
      TESTFIELD(Description);

      IF Picture.COUNT > 0 THEN
        IF NOT CONFIRM(OverrideImageQst) THEN
          ERROR('');

      ClientFileName := '';
      FileName := FileManagement.UploadFile(SelectPictureTxt,ClientFileName);
      IF FileName = '' THEN
        ERROR('');

      CLEAR(Picture);
      Picture.IMPORTFILE(FileName,ClientFileName);
      IF NOT INSERT(TRUE) THEN
        MODIFY(TRUE);

      IF FileManagement.DeleteServerFile(FileName) THEN;
    END;

    LOCAL PROCEDURE SetEditableOnPictureActions@1();
    BEGIN
      DeleteExportEnabled := Picture.COUNT <> 0;
    END;

    [External]
    PROCEDURE IsCameraAvailable@3() : Boolean;
    BEGIN
      EXIT(CameraProvider.IsAvailable);
    END;

    [External]
    PROCEDURE SetHideActions@1010();
    BEGIN
      HideActions := TRUE;
    END;

    PROCEDURE DeleteItemPicture@5();
    BEGIN
      TESTFIELD("No.");

      IF NOT CONFIRM(DeleteImageQst) THEN
        EXIT;

      CLEAR(Picture);
      MODIFY(TRUE);
    END;

    EVENT CameraProvider@1000::PictureAvailable@10(PictureName@1001 : Text;PictureFilePath@1000 : Text);
    VAR
      File@1003 : File;
      Instream@1004 : InStream;
    BEGIN
      IF (PictureName = '') OR (PictureFilePath = '') THEN
        EXIT;

      IF Picture.COUNT > 0 THEN
        IF NOT CONFIRM(OverrideImageQst) THEN BEGIN
          IF ERASE(PictureFilePath) THEN;
          EXIT;
        END;

      File.OPEN(PictureFilePath);
      File.CREATEINSTREAM(Instream);

      CLEAR(Picture);
      Picture.IMPORTSTREAM(Instream,PictureName);
      IF NOT MODIFY(TRUE) THEN
        INSERT(TRUE);

      File.CLOSE;
      IF ERASE(PictureFilePath) THEN;
    END;

    BEGIN
    END.
  }
}

