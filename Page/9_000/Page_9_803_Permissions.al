OBJECT Page 9803 Permissions
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rettigheder;
               ENU=Permissions];
    SourceTable=Table2000000005;
    DelayedInsert=Yes;
    PopulateAllFields=Yes;
    DataCaptionFields=Object Type,Object Name;
    PageType=Worksheet;
    SourceTableTemporary=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚r,L‘s,Inds‘t,Ret,Slet,Udf›r;
                                ENU=New,Process,Report,Read,Insert,Modify,Delete,Execute];
    ShowFilter=No;
    OnOpenPage=VAR
                 PermissionSet@1000 : Record 2000000004;
               BEGIN
                 IF CurrentRoleID = '' THEN
                   IF GETFILTER("Role ID") <> '' THEN
                     CurrentRoleID := GETRANGEMIN("Role ID")
                   ELSE
                     IF PermissionSet.FINDFIRST THEN
                       CurrentRoleID := PermissionSet."Role ID";
                 RESET;
                 FillTempPermissions;
               END;

    OnAfterGetRecord=BEGIN
                       SetObjectZeroName(Rec);
                       ZeroObjStyleExpr := "Object ID" = 0;
                       IsValidatedObjectID := FALSE;
                       IsNewRecord := FALSE;
                     END;

    OnNewRecord=BEGIN
                  ActivateControls;
                  PermissionRecExists := FALSE;
                  IsNewRecord := TRUE;
                  IsValidatedObjectID := FALSE;
                END;

    OnInsertRecord=VAR
                     Permission@1000 : Record 2000000005;
                   BEGIN
                     IF ("Object ID" = 0) AND ((Show = Show::All) OR IsValidatedObjectID) THEN
                       EXIT(FALSE);
                     IF ("Execute Permission" = "Execute Permission"::" ") AND
                        ("Read Permission" = "Read Permission"::" ") AND
                        ("Insert Permission" = "Insert Permission"::" ") AND
                        ("Modify Permission" = "Modify Permission"::" ") AND
                        ("Delete Permission" = "Delete Permission"::" ")
                     THEN
                       EXIT(FALSE);

                     IF "Object Type" = "Object Type"::"Table Data" THEN
                       "Execute Permission" := "Execute Permission"::" "
                     ELSE BEGIN
                       "Read Permission" := "Read Permission"::" ";
                       "Insert Permission" := "Insert Permission"::" ";
                       "Modify Permission" := "Modify Permission"::" ";
                       "Delete Permission" := "Delete Permission"::" ";
                     END;
                     Permission := Rec;
                     Permission.INSERT;
                     IF AddRelatedTables THEN
                       DoAddRelatedTables(Rec);
                     Rec := Permission;
                     SetObjectZeroName(Rec);
                     PermissionRecExists := TRUE;
                     IsNewRecord := FALSE;
                     ZeroObjStyleExpr := "Object ID" = 0;
                     EXIT(TRUE);
                   END;

    OnModifyRecord=BEGIN
                     ModifyRecord(Rec);
                     PermissionRecExists := TRUE;
                     IsNewRecord := FALSE;
                     EXIT(MODIFY);
                   END;

    OnDeleteRecord=VAR
                     Permission@1000 : Record 2000000005;
                   BEGIN
                     IF (Show = Show::All) AND ("Object ID" <> 0) THEN
                       EXIT(FALSE);
                     Permission := Rec;
                     Permission.FIND;
                     EXIT(Permission.DELETE);
                   END;

    OnAfterGetCurrRecord=VAR
                           Permission@1000 : Record 2000000005;
                         BEGIN
                           ActivateControls;
                           SetObjectZeroName(Rec);
                           IF NOT IsNewRecord THEN BEGIN
                             Permission := Rec;
                             PermissionRecExists := Permission.FIND;
                           END ELSE
                             PermissionRecExists := FALSE;
                           AllowChangePrimaryKey := NOT PermissionRecExists AND (Show = Show::"Only In Permission Set");
                           ZeroObjStyleExpr := PermissionRecExists AND ("Object ID" = 0);
                         END;

    ActionList=ACTIONS
    {
      { 12      ;    ;ActionContainer;
                      CaptionML=[DAN=Angiv rettighed;
                                 ENU=Set Permission];
                      ActionContainerType=ActionItems }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=L‘serettighed;
                                 ENU=Read Permission];
                      ActionContainerType=NewDocumentItems;
                      Image=Ledger }
      { 41      ;2   ;ActionGroup;
                      CaptionML=[DAN=Tillad l‘sning;
                                 ENU=Allow Read];
                      Image=Confirm }
      { 16      ;3   ;Action    ;
                      Name=AllowReadYes;
                      CaptionML=[DAN=Ja;
                                 ENU=Yes];
                      ToolTipML=[DAN=Tillad l‘seadgang.;
                                 ENU=Allow read access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Approve;
                      OnAction=BEGIN
                                 UpdateSelected('R',"Read Permission"::Yes);
                               END;
                                }
      { 15      ;3   ;Action    ;
                      Name=AllowReadNo;
                      CaptionML=[DAN=Nej;
                                 ENU=No];
                      ToolTipML=[DAN=Afvis;
                                 ENU=Disallow];
                      ApplicationArea=#Basic,#Suite;
                      Image=Reject;
                      OnAction=BEGIN
                                 UpdateSelected('R',"Read Permission"::" ");
                               END;
                                }
      { 17      ;3   ;Action    ;
                      Name=AllowReadIndirect;
                      CaptionML=[DAN=Indirekte;
                                 ENU=Indirect];
                      ToolTipML=[DAN=Tillad indirekte l‘seadgang.;
                                 ENU=Allow indirect read access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Indent;
                      OnAction=BEGIN
                                 UpdateSelected('R',"Read Permission"::Indirect);
                               END;
                                }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=Inds‘tterettighed;
                                 ENU=Insert Permission];
                      ActionContainerType=NewDocumentItems;
                      Image=FiledPosted }
      { 43      ;2   ;ActionGroup;
                      CaptionML=[DAN=Tillad inds‘ttelse;
                                 ENU=Allow Insertion];
                      Image=Confirm }
      { 20      ;3   ;Action    ;
                      Name=AllowInsertYes;
                      CaptionML=[DAN=Ja;
                                 ENU=Yes];
                      ToolTipML=[DAN=Tillad inds‘ttelsesadgang.;
                                 ENU=Allow insertion access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Approve;
                      OnAction=BEGIN
                                 UpdateSelected('I',"Insert Permission"::Yes);
                               END;
                                }
      { 21      ;3   ;Action    ;
                      Name=AllowInsertNo;
                      CaptionML=[DAN=Nej;
                                 ENU=No];
                      ToolTipML=[DAN=Afvis;
                                 ENU=Disallow];
                      ApplicationArea=#Basic,#Suite;
                      Image=Reject;
                      OnAction=BEGIN
                                 UpdateSelected('I',"Insert Permission"::" ");
                               END;
                                }
      { 19      ;3   ;Action    ;
                      Name=AllowInsertIndirect;
                      CaptionML=[DAN=Indirekte;
                                 ENU=Indirect];
                      ToolTipML=[DAN=Tillad indirekte inds‘ttelsesadgang.;
                                 ENU=Allow indirect insertion access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Indent;
                      OnAction=BEGIN
                                 UpdateSelected('I',"Insert Permission"::Indirect);
                               END;
                                }
      { 26      ;1   ;ActionGroup;
                      CaptionML=[DAN=Redigeringsrettighed;
                                 ENU=Modify Permission];
                      ActionContainerType=NewDocumentItems;
                      Image=Statistics }
      { 44      ;2   ;ActionGroup;
                      CaptionML=[DAN=Tillad ‘ndring;
                                 ENU=Allow Modification];
                      Image=Confirm }
      { 24      ;3   ;Action    ;
                      Name=AllowModifyYes;
                      CaptionML=[DAN=Ja;
                                 ENU=Yes];
                      ToolTipML=[DAN=Tillad redigeringsadgang.;
                                 ENU=Allow modification access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Approve;
                      OnAction=BEGIN
                                 UpdateSelected('M',"Modify Permission"::Yes);
                               END;
                                }
      { 25      ;3   ;Action    ;
                      Name=AllowModifyNo;
                      CaptionML=[DAN=Nej;
                                 ENU=No];
                      ToolTipML=[DAN=Afvis;
                                 ENU=Disallow];
                      ApplicationArea=#Basic,#Suite;
                      Image=Reject;
                      OnAction=BEGIN
                                 UpdateSelected('M',"Modify Permission"::" ");
                               END;
                                }
      { 23      ;3   ;Action    ;
                      Name=AllowModifyIndirect;
                      CaptionML=[DAN=Indirekte;
                                 ENU=Indirect];
                      ToolTipML=[DAN=Tillad indirekte redigeringsadgang.;
                                 ENU=Allow indirect modification access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Indent;
                      OnAction=BEGIN
                                 UpdateSelected('M',"Modify Permission"::Indirect);
                               END;
                                }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=Sletterettighed;
                                 ENU=Delete Permission];
                      ActionContainerType=NewDocumentItems;
                      Image=Transactions }
      { 45      ;2   ;ActionGroup;
                      CaptionML=[DAN=Tillad sletning;
                                 ENU=Allow Deletion];
                      Image=Confirm }
      { 28      ;3   ;Action    ;
                      Name=AllowDeleteYes;
                      CaptionML=[DAN=Ja;
                                 ENU=Yes];
                      ToolTipML=[DAN=Tillad sletteadgang.;
                                 ENU=Allow delete access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Approve;
                      OnAction=BEGIN
                                 UpdateSelected('D',"Delete Permission"::Yes);
                               END;
                                }
      { 29      ;3   ;Action    ;
                      Name=AllowDeleteNo;
                      CaptionML=[DAN=Nej;
                                 ENU=No];
                      ToolTipML=[DAN=Afvis;
                                 ENU=Disallow];
                      ApplicationArea=#Basic,#Suite;
                      Image=Reject;
                      OnAction=BEGIN
                                 UpdateSelected('D',"Delete Permission"::" ");
                               END;
                                }
      { 27      ;3   ;Action    ;
                      Name=AllowDeleteIndirect;
                      CaptionML=[DAN=Indirekte;
                                 ENU=Indirect];
                      ToolTipML=[DAN=Tillad indirekte sletteadgang.;
                                 ENU=Allow indirect delete access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Indent;
                      OnAction=BEGIN
                                 UpdateSelected('D',"Delete Permission"::Indirect);
                               END;
                                }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=Udf›relsesrettighed;
                                 ENU=Execute Permission];
                      ActionContainerType=NewDocumentItems;
                      Image=Transactions }
      { 46      ;2   ;ActionGroup;
                      CaptionML=[DAN=Tillad udf›relse;
                                 ENU=Allow Execution];
                      Image=Confirm }
      { 31      ;3   ;Action    ;
                      Name=AllowExecuteYes;
                      CaptionML=[DAN=Ja;
                                 ENU=Yes];
                      ToolTipML=[DAN=Tillad udf›relsesadgang.;
                                 ENU=Allow execution access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Approve;
                      OnAction=BEGIN
                                 UpdateSelected('X',"Execute Permission"::Yes);
                               END;
                                }
      { 32      ;3   ;Action    ;
                      Name=AllowExecuteNo;
                      CaptionML=[DAN=Nej;
                                 ENU=No];
                      ToolTipML=[DAN=Afvis;
                                 ENU=Disallow];
                      ApplicationArea=#Basic,#Suite;
                      Image=Reject;
                      OnAction=BEGIN
                                 UpdateSelected('X',"Execute Permission"::" ");
                               END;
                                }
      { 14      ;3   ;Action    ;
                      Name=AllowExecuteIndirect;
                      CaptionML=[DAN=Indirekte;
                                 ENU=Indirect];
                      ToolTipML=[DAN=Tillad indirekte udf›relsesadgang.;
                                 ENU=Allow indirect execution access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Indent;
                      OnAction=BEGIN
                                 UpdateSelected('X',"Execute Permission"::Indirect);
                               END;
                                }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=Alle rettigheder;
                                 ENU=All Permissions];
                      ActionContainerType=NewDocumentItems;
                      Image=Transactions }
      { 47      ;2   ;ActionGroup;
                      CaptionML=[DAN=Tillad alle;
                                 ENU=Allow All];
                      Image=Confirm }
      { 35      ;3   ;Action    ;
                      Name=AllowAllYes;
                      CaptionML=[DAN=Ja;
                                 ENU=Yes];
                      ToolTipML=[DAN=Tillad fuld adgang.;
                                 ENU=Allow full access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Approve;
                      OnAction=BEGIN
                                 UpdateSelected('*',"Read Permission"::Yes);
                               END;
                                }
      { 36      ;3   ;Action    ;
                      Name=AllowAllNo;
                      CaptionML=[DAN=Nej;
                                 ENU=No];
                      ToolTipML=[DAN=Afvis;
                                 ENU=Disallow];
                      ApplicationArea=#Basic,#Suite;
                      Image=Reject;
                      OnAction=BEGIN
                                 UpdateSelected('*',"Read Permission"::" ");
                               END;
                                }
      { 34      ;3   ;Action    ;
                      Name=AllowAllIndirect;
                      CaptionML=[DAN=Indirekte;
                                 ENU=Indirect];
                      ToolTipML=[DAN=Tillad indirekte fuld adgang.;
                                 ENU=Allow indirect full access.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Indent;
                      OnAction=BEGIN
                                 UpdateSelected('*',"Read Permission"::Indirect);
                               END;
                                }
      { 52      ;1   ;ActionGroup;
                      CaptionML=[DAN=Administrer rettighedss‘t;
                                 ENU=Manage Permission Sets] }
      { 54      ;2   ;Action    ;
                      Name=AddRelatedTablesAction;
                      CaptionML=[DAN=Tilf›j l‘serettighed til relaterede tabeller;
                                 ENU=Add Read Permission to Related Tables];
                      ToolTipML=[DAN=Definer l‘seadgang til relaterede tabeller.;
                                 ENU=Define read access to related tables.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Relationship;
                      OnAction=BEGIN
                                 AddRelatedTablesToSelected;
                               END;
                                }
      { 53      ;2   ;Action    ;
                      Name=IncludeExclude;
                      CaptionML=[DAN=Medtag/udelad rettighedss‘t;
                                 ENU=Include/Exclude Permission Set];
                      ToolTipML=[DAN=Tilf›j eller ekskluder et specifikt rettighedss‘t.;
                                 ENU=Add or exclude a specific permission set.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Edit;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 AddSubtractPermissionSet@1000 : Report 9000;
                               BEGIN
                                 AddSubtractPermissionSet.SetDestination(CurrentRoleID);
                                 AddSubtractPermissionSet.RUNMODAL;
                                 FillTempPermissions;
                               END;
                                }
      { 55      ;2   ;Action    ;
                      Name=ImportPermissions;
                      CaptionML=[DAN=Indl‘sningsrettigheder;
                                 ENU=Import Permissions];
                      ToolTipML=[DAN=Import‚r en fil med rettigheder.;
                                 ENU=Import a file with permissions.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Import;
                      OnAction=BEGIN
                                 SETRANGE("Role ID","Role ID");
                                 XMLPORT.RUN(XMLPORT::"Import/Export Permissions",FALSE,TRUE,Rec);
                                 RESET;
                                 FillTempPermissions;
                               END;
                                }
      { 51      ;1   ;ActionGroup;
                      Name=Code Coverage Actions;
                      CaptionML=[DAN=Registrer rettigheder;
                                 ENU=Record Permissions];
                      ActionContainerType=ActionItems }
      { 50      ;2   ;Action    ;
                      Name=Start;
                      CaptionML=[DAN=Start;
                                 ENU=Start];
                      ToolTipML=[DAN=Begynd at optage brugergr‘nsefladeaktiviteter for at generere det n›dvendige rettighedss‘t.;
                                 ENU=Start recording UI activities to generate the required permission set.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NOT PermissionLoggingRunning;
                      Image=Start;
                      OnAction=BEGIN
                                 IF NOT CONFIRM(StartRecordingQst) THEN
                                   EXIT;
                                 LogTablePermissions.Start;
                                 PermissionLoggingRunning := TRUE;
                               END;
                                }
      { 48      ;2   ;Action    ;
                      Name=Stop;
                      CaptionML=[DAN=Stop;
                                 ENU=Stop];
                      ToolTipML=[DAN=Stop registrering.;
                                 ENU=Stop recording.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=PermissionLoggingRunning;
                      Image=Stop;
                      OnAction=VAR
                                 TempTablePermissionBuffer@1000 : TEMPORARY Record 9800;
                               BEGIN
                                 LogTablePermissions.Stop(TempTablePermissionBuffer);
                                 PermissionLoggingRunning := FALSE;
                                 IF NOT CONFIRM(AddPermissionsQst) THEN
                                   EXIT;
                                 AddLoggedPermissions(TempTablePermissionBuffer);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 38  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 42  ;2   ;Group     ;
                GroupType=Group }

    { 39  ;3   ;Field     ;
                Name=CurrentRoleID;
                CaptionML=[DAN=Rolle-id;
                           ENU=Role ID];
                ToolTipML=[DAN=Angiver id'et for den rolle, som tilladelserne g‘lder for.;
                           ENU=Specifies the ID of the role that the permissions apply to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CurrentRoleID;
                TableRelation="Permission Set"."Role ID";
                Importance=Promoted;
                OnValidate=BEGIN
                             FillTempPermissions;
                           END;
                            }

    { 40  ;3   ;Field     ;
                Name=Show;
                CaptionML=[DAN=Vis;
                           ENU=Show];
                ToolTipML=[DAN=Angiver, om den valgte v‘rdi vises i vinduet.;
                           ENU=Specifies if the selected value is shown in the window.];
                OptionCaptionML=[DAN=Kun i rettighedss‘t,Alle;
                                 ENU=Only In Permission Set,All];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Show;
                OnValidate=BEGIN
                             FillTempPermissions;
                           END;
                            }

    { 49  ;2   ;Field     ;
                Name=AddRelatedTables;
                CaptionML=[DAN=Tilf›j l‘serettighed til relaterede tabeller;
                           ENU=Add Read Permission to Related Tables];
                ToolTipML=[DAN=Angiver, at alle tabeller, der vedr›rer den valgte tabel, bliver f›jet til vinduet med l‘serettighed.;
                           ENU=Specifies that all tables that are related to the selected table will be added to the window with Read permission.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=AddRelatedTables }

    { 2   ;1   ;Group     ;
                Name=Group;
                CaptionML=[DAN=Alle rettigheder;
                           ENU=AllPermission];
                GroupType=Repeater }

    { 13  ;2   ;Field     ;
                Name=PermissionSet;
                CaptionML=[DAN=Rettighedss‘t;
                           ENU=Permission Set];
                ToolTipML=[DAN=Angiver id'et p† de rettighedss‘t, der findes i den aktuelle database. Feltet bruges internt.;
                           ENU=Specifies the ID of the permission sets that exist in the current database. This field is used internally.];
                ApplicationArea=#Advanced;
                SourceExpr="Role ID";
                Visible=FALSE;
                Enabled=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type objekt, rettighederne anvendes p† i den aktuelle database.;
                           ENU=Specifies the type of object that the permissions apply to in the current database.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Object Type";
                Enabled=AllowChangePrimaryKey;
                Style=Strong;
                StyleExpr=ZeroObjStyleExpr;
                OnValidate=BEGIN
                             ActivateControls;
                             SetObjectZeroName(Rec);
                           END;
                            }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for det objekt, som rettighederne g‘lder for.;
                           ENU=Specifies the ID of the object to which the permissions apply.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Object ID";
                Enabled=AllowChangePrimaryKey;
                LookupPageID=All Objects with Caption;
                Style=Strong;
                StyleExpr=ZeroObjStyleExpr;
                OnValidate=BEGIN
                             IsValidatedObjectID := FALSE;
                             ActivateControls;
                             SetObjectZeroName(Rec);
                           END;
                            }

    { 9   ;2   ;Field     ;
                Name=ObjectName;
                CaptionML=[DAN=Objektnavn;
                           ENU=Object Name];
                ToolTipML=[DAN=Angiver navnet p† det objekt, som rettighederne g‘lder for.;
                           ENU=Specifies the name of the object to which the permissions apply.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ObjectName;
                Editable=FALSE;
                Style=Strong;
                StyleExpr=ZeroObjStyleExpr }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om, hvorvidt rettighedss‘ttet har l‘setilladelse til dette objekt. V‘rdierne for dette felt er tom, Ja og Indirekte. Indirekte betyder tilladelse kun via et andet objekt. Hvis feltet er tomt, har rettighedss‘ttet ikke l‘setilladelse.;
                           ENU=Specifies information about whether the permission set has read permission to this object. The values for the field are blank, Yes, and Indirect. Indirect means permission only through another object. If the field is empty, the permission set does not have read permission.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Read Permission";
                Enabled=IsTableData;
                Style=Strong;
                StyleExpr=ZeroObjStyleExpr }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om, hvorvidt rettighedss‘ttet har inds‘ttelsestilladelse til dette objekt. V‘rdierne for dette felt er tom, Ja og Indirekte. Indirekte betyder tilladelse kun via et andet objekt. Hvis feltet er tomt, har rettighedss‘ttet ikke inds‘ttelsestilladelse.;
                           ENU=Specifies information about whether the permission set has insert permission to this object. The values for the field are blank, Yes, and Indirect. Indirect means permission only through another object. If the field is empty, the permission set does not have insert permission.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Insert Permission";
                Enabled=IsTableData;
                Style=Strong;
                StyleExpr=ZeroObjStyleExpr }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om, hvorvidt rettighedss‘ttet har redigeringstilladelse til dette objekt. V‘rdierne for dette felt er tom, Ja og Indirekte. Indirekte betyder tilladelse kun via et andet objekt. Hvis feltet er tomt, har rettighedss‘ttet ikke redigeringstilladelse.;
                           ENU=Specifies information about whether the permission set has modify permission to this object. The values for the field are blank, Yes, and Indirect. Indirect means permission only through another object. If the field is empty, the permission set does not have modify permission.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Modify Permission";
                Enabled=IsTableData;
                Style=Strong;
                StyleExpr=ZeroObjStyleExpr }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om, hvorvidt rettighedss‘ttet har slettetilladelse til dette objekt. V‘rdierne for dette felt er tom, Ja og Indirekte. Indirekte betyder tilladelse kun via et andet objekt. Hvis feltet er tomt, har rettighedss‘ttet ikke slettetilladelse.;
                           ENU=Specifies information about whether the permission set has delete permission to this object. The values for the field are blank, Yes, and Indirect. Indirect means permission only through another object. If the field is empty, the permission set does not have delete permission.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Delete Permission";
                Enabled=IsTableData;
                Style=Strong;
                StyleExpr=ZeroObjStyleExpr }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om, hvorvidt rettighedss‘ttet har udf›relsestilladelse til dette objekt. V‘rdierne for dette felt er tom, Ja og Indirekte. Indirekte betyder tilladelse kun via et andet objekt. Hvis feltet er tomt, har rettighedss‘ttet ikke udf›relsestilladelse.;
                           ENU=Specifies information about whether the permission set has execute permission to this object. The values for the field are blank, Yes, and Indirect. Indirect means permission only through another object. If the field is empty, the permission set does not have execute permission.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Execute Permission";
                Enabled=NOT IsTableData;
                Style=Strong;
                StyleExpr=ZeroObjStyleExpr }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sikkerhedsfilter, der anvendes til dette rettighedss‘t for at begr‘nse den adgang, som dette rettighedss‘t har til oplysningerne i denne tabel.;
                           ENU=Specifies the security filter that is being applied to this permission set to limit the access that this permission set has to the data contained in this table.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Security Filter";
                Enabled=IsTableData;
                Style=Strong;
                StyleExpr=ZeroObjStyleExpr;
                OnAssistEdit=VAR
                               TableFilter@1000 : Record 9805;
                               TableFilterPage@1001 : Page 9805;
                             BEGIN
                               TableFilter.FILTERGROUP(2);
                               TableFilter.SETRANGE("Table Number","Object ID");
                               TableFilter.FILTERGROUP(0);
                               TableFilterPage.SETTABLEVIEW(TableFilter);
                               TableFilterPage.SetSourceTable(FORMAT("Security Filter"),"Object ID","Object Name");
                               IF ACTION::OK = TableFilterPage.RUNMODAL THEN
                                 EVALUATE("Security Filter",TableFilterPage.CreateTextTableFilter(FALSE));
                             END;
                              }

  }
  CODE
  {
    VAR
      LogTablePermissions@1013 : Codeunit 9800;
      CurrentRoleID@1000 : Code[20];
      Show@1002 : 'Only In Permission Set,All';
      AddRelatedTables@1006 : Boolean;
      IsTableData@1001 : Boolean INDATASET;
      IsNewRecord@1010 : Boolean;
      IsValidatedObjectID@1012 : Boolean;
      PermissionRecExists@1008 : Boolean;
      AllowChangePrimaryKey@1004 : Boolean;
      AddPermissionsQst@1007 : TextConst 'DAN=Vil du tilf›je de registrerede rettigheder?;ENU=Do you want to add the recorded permissions?';
      StartRecordingQst@1014 : TextConst 'DAN=Vil du starte optagelsen nu?;ENU=Do you want to start the recording now?';
      AllObjTxt@1009 : TextConst '@@@="%1= type name, e.g. Table Data or Report or Page";DAN=Alle objekter af typen %1;ENU=All objects of type %1';
      ZeroObjStyleExpr@1011 : Boolean;
      PermissionLoggingRunning@1003 : Boolean;
      ObjectName@1005 : Text;

    LOCAL PROCEDURE FillTempPermissions@1003();
    VAR
      TempPermission@1000 : TEMPORARY Record 2000000005;
      Permission@1002 : Record 2000000005;
    BEGIN
      TempPermission.COPY(Rec,TRUE);
      TempPermission.RESET;
      TempPermission.DELETEALL;
      FILTERGROUP(2);
      SETRANGE("Role ID",CurrentRoleID);
      Permission.SETRANGE("Role ID",CurrentRoleID);
      FILTERGROUP(0);

      IF Permission.FIND('-') THEN
        REPEAT
          TempPermission := Permission;
          TempPermission.INSERT;
        UNTIL Permission.NEXT = 0;

      IF Show = Show::All THEN
        FillTempPermissionsForAllObjects(TempPermission);
      IsNewRecord := FALSE;
      IF FIND('=<>') THEN;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE FillTempPermissionsForAllObjects@5(VAR Permission@1005 : Record 2000000005);
    VAR
      TempPermission@1007 : TEMPORARY Record 2000000005;
      AllObj@1006 : Record 2000000038;
    BEGIN
      AllObj.SETRANGE("Object Type");
      TempPermission.COPY(Permission,TRUE);
      TempPermission.INIT;
      IF AllObj.FINDSET THEN
        REPEAT
          TempPermission."Object Type" := AllObj."Object Type";
          TempPermission."Object ID" := AllObj."Object ID";
          TempPermission."Read Permission" := "Read Permission"::" ";
          TempPermission."Insert Permission" := "Insert Permission"::" ";
          TempPermission."Modify Permission" := "Modify Permission"::" ";
          TempPermission."Delete Permission" := "Delete Permission"::" ";
          TempPermission."Execute Permission" := "Execute Permission"::" ";
          SetObjectZeroName(TempPermission);
          IF TempPermission.INSERT THEN;
        UNTIL AllObj.NEXT = 0;
    END;

    LOCAL PROCEDURE ActivateControls@1();
    BEGIN
      IsTableData := "Object Type" = "Object Type"::"Table Data"
    END;

    LOCAL PROCEDURE ModifyRecord@59(VAR ModifiedPermission@1000 : Record 2000000005);
    VAR
      Permission@1001 : Record 2000000005;
      IsNewPermission@1003 : Boolean;
    BEGIN
      Permission.LOCKTABLE;
      IsNewPermission :=
        NOT Permission.GET(ModifiedPermission."Role ID",ModifiedPermission."Object Type",ModifiedPermission."Object ID");
      IF IsNewPermission THEN BEGIN
        Permission.TRANSFERFIELDS(ModifiedPermission,TRUE);
        Permission.INSERT;
      END ELSE BEGIN
        Permission.TRANSFERFIELDS(ModifiedPermission,FALSE);
        Permission.MODIFY;
      END;

      IF (Permission."Read Permission" = 0) AND
         (Permission."Insert Permission" = 0) AND
         (Permission."Modify Permission" = 0) AND
         (Permission."Delete Permission" = 0) AND
         (Permission."Execute Permission" = 0)
      THEN BEGIN
        Permission.DELETE;
        IF Show = Show::"Only In Permission Set" THEN
          ModifiedPermission.DELETE;
        IsNewPermission := FALSE;
      END;
      IF IsNewPermission AND AddRelatedTables THEN
        DoAddRelatedTables(ModifiedPermission);
    END;

    LOCAL PROCEDURE UpdateSelected@55(RIMDX@1000 : Text[1];PermissionOption@1001 : Option);
    VAR
      TempPermission@1003 : TEMPORARY Record 2000000005;
      OrgPermission@1002 : Record 2000000005;
    BEGIN
      OrgPermission := Rec;
      TempPermission.COPY(Rec,TRUE);
      CurrPage.SETSELECTIONFILTER(TempPermission);

      IF TempPermission.FINDSET THEN
        REPEAT
          CASE RIMDX OF
            'R':
              IF TempPermission."Object Type" = "Object Type"::"Table Data" THEN
                TempPermission."Read Permission" := PermissionOption;
            'I':
              IF TempPermission."Object Type" = "Object Type"::"Table Data" THEN
                TempPermission."Insert Permission" := PermissionOption;
            'M':
              IF TempPermission."Object Type" = "Object Type"::"Table Data" THEN
                TempPermission."Modify Permission" := PermissionOption;
            'D':
              IF TempPermission."Object Type" = "Object Type"::"Table Data" THEN
                TempPermission."Delete Permission" := PermissionOption;
            'X':
              IF TempPermission."Object Type" <> "Object Type"::"Table Data" THEN
                TempPermission."Execute Permission" := PermissionOption;
            '*':
              BEGIN
                IF TempPermission."Object Type" = "Object Type"::"Table Data" THEN BEGIN
                  TempPermission."Read Permission" := PermissionOption;
                  TempPermission."Insert Permission" := PermissionOption;
                  TempPermission."Modify Permission" := PermissionOption;
                  TempPermission."Delete Permission" := PermissionOption;
                END ELSE
                  TempPermission."Execute Permission" := PermissionOption;
              END;
          END;
          ModifyRecord(TempPermission);
          IF GET(TempPermission."Role ID",TempPermission."Object Type",TempPermission."Object ID") THEN BEGIN
            Rec := TempPermission;
            MODIFY;
          END;
        UNTIL TempPermission.NEXT = 0;

      Rec := OrgPermission;
      IF FIND THEN;
    END;

    LOCAL PROCEDURE AddRelatedTablesToSelected@8();
    VAR
      TempPermission@1003 : TEMPORARY Record 2000000005;
    BEGIN
      TempPermission.COPY(Rec,TRUE);
      CurrPage.SETSELECTIONFILTER(TempPermission);
      IF TempPermission.FINDSET THEN
        REPEAT
          DoAddRelatedTables(TempPermission);
        UNTIL TempPermission.NEXT = 0;
      IF FIND THEN;
    END;

    LOCAL PROCEDURE AddLoggedPermissions@11(VAR TablePermissionBuffer@1001 : Record 9800);
    BEGIN
      TablePermissionBuffer.SETRANGE("Session ID",SESSIONID);
      IF TablePermissionBuffer.FINDSET THEN
        REPEAT
          AddPermission(CurrentRoleID,
            TablePermissionBuffer."Object Type",
            TablePermissionBuffer."Object ID",
            TablePermissionBuffer."Read Permission",
            TablePermissionBuffer."Insert Permission",
            TablePermissionBuffer."Modify Permission",
            TablePermissionBuffer."Delete Permission",
            TablePermissionBuffer."Execute Permission");
        UNTIL TablePermissionBuffer.NEXT = 0;
      TablePermissionBuffer.DELETEALL;
    END;

    LOCAL PROCEDURE DoAddRelatedTables@7(VAR Permission@1000 : Record 2000000005);
    VAR
      TableRelationsMetadata@1002 : Record 2000000141;
    BEGIN
      IF Permission."Object Type" <> Permission."Object Type"::"Table Data" THEN
        EXIT;
      IF Permission."Object ID" = 0 THEN
        EXIT;

      TableRelationsMetadata.SETRANGE("Table ID",Permission."Object ID");
      TableRelationsMetadata.SETFILTER("Related Table ID",'>0&<>%1',Permission."Object ID");
      IF TableRelationsMetadata.FINDSET THEN
        REPEAT
          AddPermission(
            CurrentRoleID,"Object Type"::"Table Data",TableRelationsMetadata."Related Table ID","Read Permission"::Yes,
            "Insert Permission"::" ","Modify Permission"::" ","Delete Permission"::" ","Execute Permission"::" ");
        UNTIL TableRelationsMetadata.NEXT = 0;
    END;

    LOCAL PROCEDURE AddPermission@12(RoleID@1000 : Code[20];ObjectType@1001 : Option;ObjectID@1002 : Integer;AddRead@1007 : Option;AddInsert@1004 : Option;AddModify@1005 : Option;AddDelete@1006 : Option;AddExecute@1008 : Option) : Boolean;
    VAR
      Permission@1003 : Record 2000000005;
      LogTablePermissions@1009 : Codeunit 9800;
    BEGIN
      IF NOT GET(RoleID,ObjectType,ObjectID) THEN BEGIN
        INIT;
        "Role ID" := RoleID;
        "Object Type" := ObjectType;
        "Object ID" := ObjectID;
        "Read Permission" := "Read Permission"::" ";
        "Insert Permission" := "Insert Permission"::" ";
        "Modify Permission" := "Modify Permission"::" ";
        "Delete Permission" := "Delete Permission"::" ";
        "Execute Permission" := "Execute Permission"::" ";
        INSERT;
        Permission.TRANSFERFIELDS(Rec,TRUE);
        Permission.INSERT;
      END;

      "Read Permission" := LogTablePermissions.GetMaxPermission("Read Permission",AddRead);
      "Insert Permission" := LogTablePermissions.GetMaxPermission("Insert Permission",AddInsert);
      "Modify Permission" := LogTablePermissions.GetMaxPermission("Modify Permission",AddModify);
      "Delete Permission" := LogTablePermissions.GetMaxPermission("Delete Permission",AddDelete);
      "Execute Permission" := LogTablePermissions.GetMaxPermission("Execute Permission",AddExecute);

      SetObjectZeroName(Rec);
      MODIFY;
      Permission.LOCKTABLE;
      IF NOT Permission.GET(RoleID,ObjectType,ObjectID) THEN BEGIN
        Permission.TRANSFERFIELDS(Rec,TRUE);
        Permission.INSERT;
      END ELSE BEGIN
        Permission.TRANSFERFIELDS(Rec,FALSE);
        Permission.MODIFY;
      END;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE SetObjectZeroName@9(VAR Permission@1000 : Record 2000000005);
    BEGIN
      IF Permission."Object ID" <> 0 THEN BEGIN
        Permission.CALCFIELDS("Object Name");
        ObjectName := Permission."Object Name";
      END ELSE
        ObjectName := COPYSTR(STRSUBSTNO(AllObjTxt,Permission."Object Type"),1,MAXSTRLEN(Permission."Object Name"));
    END;

    BEGIN
    END.
  }
}

