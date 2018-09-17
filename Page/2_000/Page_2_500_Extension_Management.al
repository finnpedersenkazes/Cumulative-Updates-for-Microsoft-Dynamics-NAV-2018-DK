OBJECT Page 2500 Extension Management
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Udvidelsesstyring;
               ENU=Extension Management];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table2000000160;
    SourceTableView=SORTING(Name)
                    ORDER(Ascending)
                    WHERE(Name=FILTER(<>_Exclude_*),
                          Package Type=FILTER(=0|2));
    PageType=List;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Proces,Rapport,Detaljer,Administrer;
                                ENU=New,Process,Report,Details,Manage];
    OnInit=VAR
             PermissionManager@1000 : Codeunit 9002;
           BEGIN
             IsSaaS := PermissionManager.SoftwareAsAService;
             IsSaaSInstallAllowed := PermissionManager.IsSandboxConfiguration OR GetSaaSInstallSetting;
           END;

    OnOpenPage=BEGIN
                 ActionsEnabled := FALSE;
                 SETFILTER("Tenant ID",'%1|%2',TENANTID,'');
                 IF IsSaaS AND (NOT IsSaaSInstallAllowed) THEN BEGIN
                   CurrPage.CAPTION(SaaSCaptionTxt);
                   SETFILTER(Installed,'%1',TRUE);
                 END
               END;

    OnAfterGetRecord=BEGIN
                       ActionsEnabled := TRUE;
                       VersionDisplay :=
                         STRSUBSTNO(
                           VersionFormatTxt,
                           NavExtensionInstallationMgmt.GetVersionDisplayString("Version Major","Version Minor","Version Build","Version Revision"));
                       // Currently using the "Tenant ID" field to identify development extensions
                       IsTenantExtension := STRLEN("Tenant ID") > 0;

                       Style := FALSE;
                       PublisherOrStatus := Publisher;
                       IF (NOT IsSaaS) OR IsSaaSInstallAllowed THEN BEGIN
                         PublisherOrStatus := NavExtensionInstallationMgmt.GetExtensionInstalledDisplayString("Package ID");
                         Style := NavExtensionInstallationMgmt.IsInstalled("Package ID");
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 11      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 13      ;1   ;ActionGroup;
                      Visible=False;
                      Enabled=False }
      { 9       ;2   ;Action    ;
                      Name=Install;
                      CaptionML=[DAN=Installer;
                                 ENU=Install];
                      ToolTipML=[DAN=Installer udvidelsen for den aktuelle lejer.;
                                 ENU=Install the extension for the current tenant.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=(NOT IsSaaS) OR IsSaaSInstallAllowed;
                      Enabled=ActionsEnabled AND NOT IsSaaS;
                      Image=NewRow;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IF NavExtensionInstallationMgmt.IsInstalled("Package ID") THEN BEGIN
                                   MESSAGE(AlreadyInstalledMsg,Name);
                                   EXIT;
                                 END;

                                 RunOldExtensionInstallation;
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Name=Uninstall;
                      CaptionML=[DAN=Fjern;
                                 ENU=Uninstall];
                      ToolTipML=[DAN=Fjern udvidelsen fra den aktuelle lejer.;
                                 ENU=Remove the extension from the current tenant.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=ActionsEnabled;
                      Image=RemoveLine;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IF NOT NavExtensionInstallationMgmt.IsInstalled("Package ID") THEN BEGIN
                                   MESSAGE(AlreadyUninstalledMsg,Name);
                                   EXIT;
                                 END;

                                 RunOldExtensionInstallation;
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Name=Unpublish;
                      CaptionML=[DAN=Annuller udgivelse;
                                 ENU=Unpublish];
                      ToolTipML=[DAN=Annuller udgivelsen af udvidelsen fra lejeren.;
                                 ENU=Unpublish the extension from the tenant.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsTenantExtension;
                      Enabled=ActionsEnabled;
                      Image=RemoveLine;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 IF NavExtensionInstallationMgmt.IsInstalled("Package ID") THEN BEGIN
                                   MESSAGE(CannotUnpublishIfInstalledMsg,Name);
                                   EXIT;
                                 END;

                                 NavExtensionInstallationMgmt.UnpublishNavTenantExtension("Package ID");
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=Download Source;
                      CaptionML=[DAN=Download kilde;
                                 ENU=Download Source];
                      ToolTipML=[DAN=Download udvidelsens kildekode.;
                                 ENU=Download the source code for the extension.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=IsTenantExtension AND "Show My Code";
                      Image=ExportFile;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=VAR
                                 TempBlob@1000 : Record 99008535;
                                 FileManagement@1001 : Codeunit 419;
                                 NvOutStream@1002 : OutStream;
                                 Designer@1003 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.Designer.NavDesignerALFunctions";
                                 FileName@1004 : Text;
                                 VersionString@1005 : Text;
                                 CleanFileName@1006 : Text;
                               BEGIN
                                 TempBlob.Blob.CREATEOUTSTREAM(NvOutStream);
                                 Designer.GenerateDesignerPackageZipStream(NvOutStream,ID);
                                 VersionString :=
                                   NavExtensionInstallationMgmt.GetVersionDisplayString("Version Major","Version Minor","Version Build","Version Revision");
                                 FileName := STRSUBSTNO(ExtensionFileNameTxt,Name,Publisher,VersionString);
                                 CleanFileName := Designer.SanitizeDesignerFileName(FileName,'_');
                                 FileManagement.BLOBExport(TempBlob,CleanFileName,TRUE);
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=LearnMore;
                      CaptionML=[DAN=L‘r mere;
                                 ENU=Learn More];
                      ToolTipML=[DAN=Vis oplysninger fra udbyderen af udvidelsen.;
                                 ENU=View information from the extension provider.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=ActionsEnabled;
                      Image=Info;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 HYPERLINK(Help);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=Refresh;
                      CaptionML=[DAN=Opdater;
                                 ENU=Refresh];
                      ToolTipML=[DAN=Opdater listen med udvidelser.;
                                 ENU=Refresh the list of extensions.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=RefreshLines;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 ActionsEnabled := FALSE;
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=Extension Marketplace;
                      CaptionML=[DAN=Markedsplads for udvidelser;
                                 ENU=Extension Marketplace];
                      ToolTipML=[DAN=S›g efter udvidelser p† markedspladsen, hvis du vil installere nye udvidelser.;
                                 ENU=Browse the extension marketplace for new extensions to install.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsSaaS;
                      Enabled=IsSaaS;
                      PromotedIsBig=Yes;
                      Image=NewItem;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 IF AppSource.IsAvailable THEN BEGIN
                                   AppSource := AppSource.Create();
                                   AppSource.ShowAppSource();
                                 END;
                               END;
                                }
      { 15      ;1   ;ActionGroup;
                      Name=Manage;
                      CaptionML=[DAN=Administrer;
                                 ENU=Manage] }
      { 10      ;2   ;Action    ;
                      Name=View;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=Vis udvidelsesdetaljer.;
                                 ENU=View extension details.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsSaaS;
                      Enabled=ActionsEnabled;
                      Image=View;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 RunOldExtensionInstallation;
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
                Editable=FALSE;
                GroupType=Repeater }

    { 6   ;2   ;Field     ;
                Name=Logo;
                CaptionML=[DAN=Logo;
                           ENU=Logo];
                ToolTipML=[DAN=Angiver logoet fra udvidelsen, eksempelvis tjenesteudbyderens logo.;
                           ENU=Specifies the logo of the extension, such as the logo of the service provider.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Logo }

    { 4   ;2   ;Field     ;
                Name=AdditionalInfo;
                CaptionML=[DAN=AdditionalInfo;
                           ENU=AdditionalInfo];
                ToolTipML=[DAN=Angiver den person eller den virksomhed, der oprettede udvidelsen.;
                           ENU=Specifies the person or company that created the extension.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=PublisherOrStatus;
                Style=Favorable;
                StyleExpr=Style }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† udvidelsen.;
                           ENU=Specifies the name of the extension.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et afstandsstykke for visningstilstanden "Mursten".;
                           ENU=Specifies a spacer for 'Brick' view mode.];
                ApplicationArea=#Basic,#Suite;
                Visible=IsSaaS;
                Enabled=IsSaaS;
                HideValue=TRUE;
                Style=Favorable;
                StyleExpr=TRUE }

    { 8   ;2   ;Field     ;
                Name=Version;
                CaptionML=[DAN=Version;
                           ENU=Version];
                ToolTipML=[DAN=Angiver udvidelsens version.;
                           ENU=Specifies the version of the extension.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=VersionDisplay }

  }
  CODE
  {
    VAR
      VersionFormatTxt@1000 : TextConst '@@@="v=version abbr, %1=Version string";DAN=v. %1;ENU=v. %1';
      NavExtensionInstallationMgmt@1002 : Codeunit 2500;
      AppSource@1011 : DotNet "'Microsoft.Dynamics.Nav.ClientExtensions, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.Capabilities.AppSource" RUNONCLIENT;
      PublisherOrStatus@1004 : Text;
      VersionDisplay@1009 : Text;
      ActionsEnabled@1006 : Boolean;
      IsSaaS@1001 : Boolean;
      SaaSCaptionTxt@1003 : TextConst '@@@=The caption to display when on SaaS;DAN=Installerede udvidelser;ENU=Installed Extensions';
      Style@1005 : Boolean;
      ExtensionFileNameTxt@1013 : TextConst '@@@="{Locked};%1=Name, %2=Publisher, %3=Version";DAN=%1_%2_%3.zip;ENU=%1_%2_%3.zip';
      AlreadyInstalledMsg@1007 : TextConst '@@@="%1 = name of extension";DAN=Udvidelsen %1 er allerede installeret.;ENU=The extension %1 is already installed.';
      AlreadyUninstalledMsg@1008 : TextConst '@@@="%1 = name of extension.";DAN=Udvidelsen %1 er ikke installeret.;ENU=The extension %1 is not installed.';
      IsSaaSInstallAllowed@1010 : Boolean;
      IsTenantExtension@1012 : Boolean;
      CannotUnpublishIfInstalledMsg@1014 : TextConst '@@@="%1 = name of extension";DAN=Udgivelsen af udvidelsen %1 kan ikke annulleres, da den er installeret.;ENU=The extension %1 cannot be unpublished because it is installed.';

    LOCAL PROCEDURE RunOldExtensionInstallation@16();
    VAR
      ExtensionDetails@1000 : Page 2501;
    BEGIN
      ExtensionDetails.SETRECORD(Rec);
      ExtensionDetails.RUN;
      IF ExtensionDetails.EDITABLE = FALSE THEN
        CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE GetSaaSInstallSetting@1() : Boolean;
    VAR
      ServerConfigSettingHandler@1000 : Codeunit 6723;
      InstallAllowed@1001 : Boolean;
    BEGIN
      InstallAllowed := ServerConfigSettingHandler.GetEnableSaaSExtensionInstallSetting;
      EXIT(InstallAllowed);
    END;

    BEGIN
    END.
  }
}

