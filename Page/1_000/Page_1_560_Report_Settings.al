OBJECT Page 1560 Report Settings
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rapportindstillinger;
               ENU=Report Settings];
    InsertAllowed=No;
    SourceTable=Table2000000196;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Administrer;
                                ENU=New,Process,Report,Manage];
    ShowFilter=No;
    OnAfterGetRecord=BEGIN
                       LookupObjectName("Object ID","Object Type");
                     END;

    OnAfterGetCurrRecord=BEGIN
                           LastUsed := "Parameter Name" = LastUsedTxt;
                         END;

    ActionList=ACTIONS
    {
      { 5       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 11      ;1   ;Action    ;
                      Name=NewSettings;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ToolTipML=[DAN="Opret nye rapportindstillinger, der angiver filtre og indstillinger for en specifik rapport. ";
                                 ENU="Create a new report settings entry that sets filters and options for a specific report. "];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=New;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ObjectOptions@1001 : Record 2000000196;
                                 PickReport@1000 : Page 1561;
                                 OptionDataTxt@1003 : Text;
                               BEGIN
                                 IF PickReport.RUNMODAL <> ACTION::OK THEN
                                   EXIT;

                                 PickReport.GetObjectOptions(ObjectOptions);
                                 OptionDataTxt := REPORT.RUNREQUESTPAGE(ObjectOptions."Object ID",OptionDataTxt);
                                 IF OptionDataTxt <> '' THEN BEGIN
                                   UpdateOptionData(ObjectOptions,OptionDataTxt);
                                   ObjectOptions.INSERT(TRUE);
                                   Rec := ObjectOptions;
                                 END;
                               END;
                                }
      { 14      ;1   ;Action    ;
                      Name=CopySettings;
                      CaptionML=[DAN=Kopier;
                                 ENU=Copy];
                      ToolTipML=[DAN=Tag en kopi af de valgte rapportindstillinger.;
                                 ENU=Make a copy the selected report settings.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Copy;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ObjectOptions@1000 : Record 2000000196;
                               BEGIN
                                 IF "Option Data".HASVALUE THEN
                                   CALCFIELDS("Option Data");

                                 ObjectOptions.TRANSFERFIELDS(Rec);
                                 ObjectOptions."Parameter Name" := STRSUBSTNO(CopyTxt,"Parameter Name");
                                 ObjectOptions.INSERT(TRUE);
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Name=EditSettings;
                      CaptionML=[DAN=Rediger;
                                 ENU=Edit];
                      ToolTipML=[DAN=Skift de indstillinger og filtre, der er defineret for de valgte rapportindstillinger.;
                                 ENU=Change the options and filters that are defined for the selected report settings.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled=NOT LastUsed;
                      Image=Edit;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 OptionDataTxt@1002 : Text;
                               BEGIN
                                 OptionDataTxt := REPORT.RUNREQUESTPAGE("Object ID",GetOptionData);
                                 IF OptionDataTxt <> '' THEN BEGIN
                                   UpdateOptionData(Rec,OptionDataTxt);
                                   MODIFY(TRUE);
                                 END;
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
                Name=Name;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† de angivne indstillinger.;
                           ENU=Specifies the name of the settings entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Parameter Name" }

    { 4   ;2   ;Field     ;
                Name=Report ID;
                CaptionML=[DAN=Rapport-id;
                           ENU=Report ID];
                ToolTipML=[DAN=Angiver id'et for den rapport, der bruger indstillingerne.;
                           ENU=Specifies the ID of the report that uses the settings.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Object ID";
                MinValue=1;
                TableRelation=IF (Object Type=CONST(Report)) "Report Metadata".ID;
                OnValidate=BEGIN
                             ValidateObjectID;
                             LookupObjectName("Object ID","Object Type");
                           END;
                            }

    { 8   ;2   ;Field     ;
                Name=Report Name;
                CaptionML=[DAN=Rapportnavn;
                           ENU=Report Name];
                ToolTipML=[DAN=Angiver navnet p† den rapport, der bruger indstillingerne.;
                           ENU=Specifies the name of the report that uses the settings.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ReportName;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Tildelt til;
                           ENU=Assigned to];
                ToolTipML=[DAN=Angiver, hvem der kan bruge rapportindstillingerne. Hvis feltet er tomt, er indstillingerne tilg‘ngelige for alle brugere.;
                           ENU=Specifies who can use the report settings. If the field is blank, the settings are available to all users.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User Name";
                TableRelation=User."User Name";
                Enabled=NOT LastUsed;
                OnValidate=BEGIN
                             IF "User Name" <> '' THEN
                               "Public Visible" := FALSE
                             ELSE
                               "Public Visible" := TRUE;
                           END;
                            }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Oprettet af;
                           ENU=Created by];
                ToolTipML=[DAN=Angiver navnet p† den bruger, der oprettede indstillingerne.;
                           ENU=Specifies the name of the user who created the settings.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Created By";
                TableRelation=User."User Name";
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Delt med alle brugere;
                           ENU=Shared with all users];
                ToolTipML=[DAN=Angiver, om rapportindstillingerne er tilg‘ngelige for alle brugere eller kun den bruger, som er tildelt indstillingerne.;
                           ENU=Specifies whether the report settings are available to all users or only the user assigned to the settings.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Public Visible";
                Enabled=NOT LastUsed;
                OnValidate=BEGIN
                             IF "User Name" = '' THEN
                               "User Name" := "Created By"
                             ELSE
                               "User Name" := '';
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den virksomhed, som indstillingerne tilh›rer.;
                           ENU=Specifies the company to which the settings belong.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Company Name" }

  }
  CODE
  {
    VAR
      CopyTxt@1002 : TextConst '@@@=%1 is the Parameter Name field from the Object Options record;DAN=Kopi af %1;ENU=Copy of %1';
      LastUsedTxt@1003 : TextConst '@@@=Translation must match RequestPageLatestSavedSettingsName from Lang.resx;DAN=Sidst anvendte indstillinger og filtre;ENU=Last used options and filters';
      LastUsed@1004 : Boolean;
      ObjectIdValidationErr@1006 : TextConst 'DAN=Det angivne objekt-id er ikke gyldigt. Objektet skal forekomme i programmet.;ENU="The specified object ID is not valid; the object must exist in the application."';
      ReportName@1000 : Text;
      EmptyOptionDataErr@1001 : TextConst 'DAN=Indstillingsdata er tom.;ENU=Option Data is empty.';

    LOCAL PROCEDURE ValidateObjectID@3();
    VAR
      ObjectMetadata@1000 : Record 2000000071;
    BEGIN
      IF NOT ObjectMetadata.GET("Object Type","Object ID") THEN
        ERROR(ObjectIdValidationErr);
    END;

    LOCAL PROCEDURE LookupObjectName@15(ObjectID@1000 : Integer;ObjectType@1002 : Option);
    VAR
      AllObjWithCaption@1001 : Record 2000000058;
    BEGIN
      IF AllObjWithCaption.GET(ObjectType,ObjectID) THEN
        ReportName := AllObjWithCaption."Object Caption"
      ELSE
        ReportName := '';
    END;

    LOCAL PROCEDURE UpdateOptionData@2(VAR ObjectOptions@1000 : Record 2000000196;OptionDataTxt@1002 : Text);
    VAR
      OutStream@1001 : OutStream;
    BEGIN
      IF OptionDataTxt = '' THEN
        ERROR(EmptyOptionDataErr);

      CLEAR(ObjectOptions."Option Data");
      ObjectOptions."Option Data".CREATEOUTSTREAM(OutStream,TEXTENCODING::UTF8);
      OutStream.WRITETEXT(OptionDataTxt);
    END;

    LOCAL PROCEDURE GetOptionData@24() Result : Text;
    VAR
      InStream@1000 : InStream;
    BEGIN
      IF "Option Data".HASVALUE THEN BEGIN
        CALCFIELDS("Option Data");
        "Option Data".CREATEINSTREAM(InStream,TEXTENCODING::UTF8);
        InStream.READTEXT(Result);
      END;
    END;

    BEGIN
    {
      RENAME does not work when primary key contains an option field, in this case "Object Type".
      Therefore DELETE / INSERT is needed as "User Name" is part of the primary key.
    }
    END.
  }
}

