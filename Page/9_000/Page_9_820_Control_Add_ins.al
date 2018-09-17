OBJECT Page 9820 Control Add-ins
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Tilf›jelseskontrolelementer;
               ENU=Control Add-ins];
    SourceTable=Table2000000069;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Ressource for tilf›jelseskontrolelement;
                                ENU=New,Process,Report,Control Add-in Resource];
    ActionList=ACTIONS
    {
      { 8       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ressource for tilf›jelseskontrolelement;
                                 ENU=Control Add-in Resource] }
      { 9       ;2   ;Action    ;
                      Name=Import;
                      CaptionML=[DAN=Indl‘s;
                                 ENU=Import];
                      ToolTipML=[DAN=Import‚r en definition af tilf›jelseskontrolelement fra en fil.;
                                 ENU=Import a control add-in definition from a file.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 TempBlob@1002 : Record 99008535;
                                 FileManagement@1000 : Codeunit 419;
                                 ResourceName@1001 : Text;
                               BEGIN
                                 IF Resource.HASVALUE THEN
                                   IF NOT CONFIRM(ImportQst) THEN
                                     EXIT;

                                 ResourceName := FileManagement.BLOBImportWithFilter(
                                     TempBlob,ImportTitleTxt,'',
                                     ImportFileTxt + ' (*.zip)|*.zip|' + AllFilesTxt + ' (*.*)|*.*','*.*');

                                 IF ResourceName <> '' THEN BEGIN
                                   Resource := TempBlob.Blob;
                                   CurrPage.SAVERECORD;

                                   MESSAGE(ImportDoneMsg);
                                 END;
                               END;
                                }
      { 10      ;2   ;Action    ;
                      Name=Export;
                      CaptionML=[DAN=Udl‘s;
                                 ENU=Export];
                      ToolTipML=[DAN=Eksport‚r en definition af tilf›jelseskontrolelement til en fil.;
                                 ENU=Export a control add-in definition to a file.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Export;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 TempBlob@1001 : Record 99008535;
                                 FileManagement@1000 : Codeunit 419;
                               BEGIN
                                 IF NOT Resource.HASVALUE THEN BEGIN
                                   MESSAGE(NoResourceMsg);
                                   EXIT;
                                 END;

                                 CALCFIELDS(Resource);
                                 TempBlob.Blob := Resource;
                                 FileManagement.BLOBExport(TempBlob,"Add-in Name" + '.zip',TRUE);
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=Clear;
                      CaptionML=[DAN=Ryd;
                                 ENU=Clear];
                      ToolTipML=[DAN=Ryd ressourcen fra det valgte tilf›jelseskontrolelement.;
                                 ENU=Clear the resource from the selected control add-in.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 IF NOT Resource.HASVALUE THEN
                                   EXIT;

                                 CLEAR(Resource);
                                 CurrPage.SAVERECORD;

                                 MESSAGE(RemoveDoneMsg);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† klientens tilf›jelseskontrolelement, som er registreret p† Dynamics NAV Server.;
                           ENU=Specifies the name of the Client Control Add-in that is registered on the Dynamics NAV Server.];
                ApplicationArea=#Advanced;
                SourceExpr="Add-in Name" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det offentlige n›gletoken, der er tilknyttet tilf›jelsesprogrammet.;
                           ENU=Specifies the public key token that is associated with the Add-in.];
                ApplicationArea=#Advanced;
                SourceExpr="Public Key Token";
                OnValidate=BEGIN
                             "Public Key Token" := DELCHR("Public Key Token",'<>',' ');
                           END;
                            }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver versionen p† klientens tilf›jelseskontrolelement, som er registreret p† en Dynamics NAV Server.;
                           ENU=Specifies the version of the Client Control Add-in that is registered on a Dynamics NAV Server.];
                ApplicationArea=#Advanced;
                SourceExpr=Version }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportlayoutets kategori. Den f›lgende tabel beskriver de typer, der er tilg‘ngelige:;
                           ENU=Specifies the category of the add-in. The following table describes the types that are available:];
                ApplicationArea=#Advanced;
                SourceExpr=Category }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af klientens tilf›jelseskontrolelement.;
                           ENU=Specifies the description of the Client Control Add-in.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 7   ;2   ;Field     ;
                CaptionML=[@@@={Locked};
                           DAN=Resource;
                           ENU=Resource];
                ToolTipML=[DAN=Angiver URL til zip-filen med ressourcer.;
                           ENU=Specifies the URL to the resource zip file.];
                ApplicationArea=#Advanced;
                SourceExpr=Resource.HASVALUE }

  }
  CODE
  {
    VAR
      AllFilesTxt@1001 : TextConst 'DAN=Alle filer;ENU=All Files';
      ImportFileTxt@1002 : TextConst 'DAN=Ressource for tilf›jelseskontrolelement;ENU=Control Add-in Resource';
      ImportDoneMsg@1003 : TextConst 'DAN=Ressourcen for tilf›jelseskontrolelementet er importeret.;ENU=The control add-in resource has been imported.';
      ImportQst@1004 : TextConst 'DAN=Ressourcen for tilf›jelseskontrolelementet er allerede angivet.\Vil du overskrive den?;ENU=The control add-in resource is already specified.\Do you want to overwrite it?';
      ImportTitleTxt@1005 : TextConst 'DAN=Import‚r ressource for tilf›jelseskontrolelement;ENU=Import Control Add-in Resource';
      NoResourceMsg@1006 : TextConst 'DAN=Der er ingen ressource for tilf›jelseskontrolelementet.;ENU=There is no resource for the control add-in.';
      RemoveDoneMsg@1007 : TextConst 'DAN=Ressourcen for tilf›jelseskontrolelementet er fjernet.;ENU=The control add-in resource has been removed.';

    BEGIN
    END.
  }
}

