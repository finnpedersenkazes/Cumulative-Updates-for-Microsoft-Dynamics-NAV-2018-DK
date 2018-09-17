OBJECT Page 1751 Data Classification Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Regneark til projektklassificering;
               ENU=Data Classification Worksheet];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table2000000159;
    SourceTableView=WHERE(Field Caption=FILTER(<>''));
    PageType=List;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Administrer,Vis;
                                ENU=New,Process,Report,Manage,View];
    OnOpenPage=VAR
                 CompanyInformation@1002 : Record 79;
                 DataClassificationMgt@1000 : Codeunit 1750;
                 Notification@1001 : Notification;
               BEGIN
                 Notification.MESSAGE := DataClassificationMgt.GetLegalDisclaimerTxt;
                 Notification.SEND;
                 SETRANGE("Company Name",COMPANYNAME);
                 CompanyInformation.GET;
                 IF ISEMPTY AND CompanyInformation."Demo Company" THEN
                   DataClassificationMgt.CreateDemoData;
                 DataClassificationMgt.ShowSyncFieldsNotification;
               END;

    OnAfterGetRecord=BEGIN
                       SetLastMidifiedBy;
                     END;

    OnAfterGetCurrRecord=VAR
                           DataSensitivity@1000 : Record 2000000159;
                         BEGIN
                           CurrPage.SETSELECTIONFILTER(DataSensitivity);
                           FieldContentEnabled :=
                             (("Field Type" = "Field Type"::Code) OR
                              ("Field Type" = "Field Type"::Text)) AND
                             (DataSensitivity.COUNT = 1);
                         END;

    ActionList=ACTIONS
    {
      { 10      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;ActionGroup;
                      Name=Edit;
                      CaptionML=[DAN=Rediger;
                                 ENU=Edit] }
      { 19      ;2   ;Action    ;
                      Name=Set Up Data Classifications;
                      CaptionML=[DAN=Konfigurer dataklassificeringer;
                                 ENU=Set Up Data Classifications];
                      ToolTipML=[DAN=èbn den assisterende opsëtningsvejledning til dataklassificering;
                                 ENU=Open the Data Classification Assisted Setup Guide];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Setup;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"Data Classification Wizard");
                               END;
                                }
      { 18      ;2   ;Action    ;
                      Name=Set as Sensitive;
                      CaptionML=[DAN=Angiv som Fõlsomme;
                                 ENU=Set as Sensitive];
                      ToolTipML=[DAN=Angiv de valgte felters datafõlsomhed som Fõlsomme;
                                 ENU=Set the Data Sensitivity of the selected fields to Sensitive];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ApplyEntries;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SetSensitivityToSelection("Data Sensitivity"::Sensitive);
                               END;
                                }
      { 12      ;2   ;Action    ;
                      Name=Set as Personal;
                      CaptionML=[DAN=Indstil som Personlige;
                                 ENU=Set as Personal];
                      ToolTipML=[DAN=Angiv de valgte felters datafõlsomhed som Personlige;
                                 ENU=Set the Data Sensitivity of the selected fields to Personal];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ApplyEntries;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SetSensitivityToSelection("Data Sensitivity"::Personal);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=Set as Normal;
                      CaptionML=[DAN=Angiv som Normal;
                                 ENU=Set as Normal];
                      ToolTipML=[DAN=Angiv de valgte felters datafõlsomhed som Normal;
                                 ENU=Set the Data Sensitivity of the selected fields to Normal];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ApplyEntries;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SetSensitivityToSelection("Data Sensitivity"::Normal);
                               END;
                                }
      { 27      ;2   ;Action    ;
                      Name=Set as Company Confidential;
                      CaptionML=[DAN=Angiv som Virksomhedens fortrolige;
                                 ENU=Set as Company Confidential];
                      ToolTipML=[DAN=Angiv de valgte felters datafõlsomhed som Virksomhedens fortrolige;
                                 ENU=Set the Data Sensitivity of the selected fields to Company Confidential];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ApplyEntries;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SetSensitivityToSelection("Data Sensitivity"::"Company Confidential");
                               END;
                                }
      { 21      ;1   ;ActionGroup;
                      Name=View;
                      CaptionML=[DAN=Vis;
                                 ENU=View] }
      { 28      ;2   ;Action    ;
                      Name=View Similar Fields;
                      CaptionML=[DAN=Vis lignende felter;
                                 ENU=View Similar Fields];
                      ToolTipML=[DAN=FÜ vist felterne for relaterede records med et lignende navn, hvor et af felterne er valgt.;
                                 ENU=View the fields of the related records that have similar name with one of the fields selected.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=FilterLines;
                      PromotedCategory=Category5;
                      OnAction=VAR
                                 DataClassificationMgt@1000 : Codeunit 1750;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Rec);
                                 IF NOT FINDSET THEN
                                   ERROR(NoRecordsErr);
                                 DataClassificationMgt.FindSimilarFields(Rec);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 15      ;2   ;Action    ;
                      Name=View Unclassified;
                      CaptionML=[DAN=Vis ikke-klassificerede;
                                 ENU=View Unclassified];
                      ToolTipML=[DAN=Vis kun ikke-klassificerede felter;
                                 ENU=View only unclassified fields];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=FilterLines;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 SETRANGE("Data Sensitivity","Data Sensitivity"::Unclassified);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 22      ;2   ;Action    ;
                      Name=View Sensitive;
                      CaptionML=[DAN=Vis fõlsomme;
                                 ENU=View Sensitive];
                      ToolTipML=[DAN=Vis kun de felter, der er klassificeret som Fõlsomme;
                                 ENU=View only fields classified as Sensitive];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=FilterLines;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 SETRANGE("Data Sensitivity","Data Sensitivity"::Sensitive);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=View Personal;
                      CaptionML=[DAN=Vis personlige;
                                 ENU=View Personal];
                      ToolTipML=[DAN=Vis kun de felter, der er klassificeret som personlige;
                                 ENU=View only fields classified as Personal];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=FilterLines;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 SETRANGE("Data Sensitivity","Data Sensitivity"::Personal);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Name=View Normal;
                      CaptionML=[DAN=Vis Normal;
                                 ENU=View Normal];
                      ToolTipML=[DAN=Vis kun de felter, der er klassificeret som Normal;
                                 ENU=View only fields classified as Normal];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=FilterLines;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 SETRANGE("Data Sensitivity","Data Sensitivity"::Normal);
                                 CurrPage.UPDATE;
                               END;
                                }
      { 26      ;2   ;Action    ;
                      Name=View Company Confidential;
                      CaptionML=[DAN=Vis Virksomhedens fortrolige;
                                 ENU=View Company Confidential];
                      ToolTipML=[DAN=Vis kun de felter, der er klassificeret som Virksomhedens fortrolige;
                                 ENU=View only fields classified as Company Confidential];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=FilterLines;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 SETRANGE("Data Sensitivity","Data Sensitivity"::"Company Confidential");
                                 CurrPage.UPDATE;
                               END;
                                }
      { 23      ;2   ;Action    ;
                      Name=View All;
                      CaptionML=[DAN=Vis alle;
                                 ENU=View All];
                      ToolTipML=[DAN=Vis alle felter;
                                 ENU=View all fields];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=ClearFilter;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 RESET;
                                 SETRANGE("Company Name",COMPANYNAME);
                                 SETFILTER("Field Caption",'<>%1','');
                               END;
                                }
      { 30      ;2   ;Action    ;
                      Name=Show Field Content;
                      CaptionML=[DAN=Vis feltindhold;
                                 ENU=Show Field Content];
                      ToolTipML=[DAN=Vis alle de entydige vërdier i det valgte felt;
                                 ENU=Show all the unique values of the selected field];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=FieldContentEnabled;
                      PromotedIsBig=Yes;
                      Image=Table;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 TempFieldContentBuffer@1000 : TEMPORARY Record 1754;
                                 DataClassificationMgt@1003 : Codeunit 1750;
                                 RecordRef@1001 : RecordRef;
                                 FieldRef@1002 : FieldRef;
                               BEGIN
                                 RecordRef.OPEN("Table No");
                                 IF RecordRef.FINDSET THEN
                                   REPEAT
                                     FieldRef := RecordRef.FIELD("Field No");
                                     DataClassificationMgt.PopulateFieldValue(FieldRef,TempFieldContentBuffer);
                                   UNTIL RecordRef.NEXT = 0;
                                 PAGE.RUNMODAL(PAGE::"Field Content Buffer",TempFieldContentBuffer);
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
                ApplicationArea=#All;
                SourceExpr="Table No";
                Enabled=FALSE;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="Field No";
                Enabled=FALSE;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                DrillDown=No;
                ApplicationArea=#All;
                SourceExpr="Table Caption";
                Enabled=FALSE;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                DrillDown=No;
                ApplicationArea=#All;
                SourceExpr="Field Caption";
                Enabled=FALSE;
                Editable=FALSE;
                Style=Standard;
                StyleExpr=TRUE }

    { 7   ;2   ;Field     ;
                DrillDown=No;
                ApplicationArea=#All;
                SourceExpr="Field Type";
                Enabled=FALSE;
                Editable=FALSE;
                Style=Standard;
                StyleExpr=TRUE }

    { 9   ;2   ;Field     ;
                OptionCaptionML=[DAN=Ikke klassificerede,Fõlsomme,Personlige,Virksomhedens fortrolige,Normal;
                                 ENU=Unclassified,Sensitive,Personal,Company Confidential,Normal];
                ApplicationArea=#All;
                SourceExpr="Data Sensitivity";
                OnValidate=BEGIN
                             VALIDATE("Last Modified By",USERSECURITYID);
                             VALIDATE("Last Modified",CURRENTDATETIME);
                             SetLastMidifiedBy;
                           END;
                            }

    { 8   ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="Data Classification";
                Visible=FALSE;
                Enabled=FALSE;
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                CaptionML=[DAN=Sidst ëndret af;
                           ENU=Last Modified By];
                ApplicationArea=#All;
                SourceExpr=LastModifiedBy;
                Enabled=FALSE;
                Editable=FALSE }

    { 25  ;2   ;Field     ;
                ApplicationArea=#All;
                SourceExpr="Last Modified";
                Enabled=FALSE;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      NoRecordsErr@1000 : TextConst 'DAN=Der er ikke valgt en record.;ENU=No record has been selected.';
      FieldContentEnabled@1002 : Boolean;
      LastModifiedBy@1003 : Text;
      DeletedUserTok@1004 : TextConst 'DAN=Slettet bruger;ENU=Deleted User';
      ClassifyAllfieldsQst@1005 : TextConst '@@@="%1=Choosen sensitivity %2=total number of fields";DAN=Vil du indstille datafõlsomheden til %1 i %2-felter?;ENU=Do you want to set data sensitivity to %1 on %2 fields?';

    LOCAL PROCEDURE SetSensitivityToSelection@4(Sensitivity@1000 : Option);
    VAR
      DataSensitivity@1001 : Record 2000000159;
      DataClassificationMgt@1003 : Codeunit 1750;
    BEGIN
      CurrPage.SETSELECTIONFILTER(DataSensitivity);
      IF DataSensitivity.COUNT > 20 THEN
        IF NOT CONFIRM(STRSUBSTNO(
               ClassifyAllfieldsQst,
               SELECTSTR(Sensitivity + 1,DataClassificationMgt.GetDataSensitivityOptionString),
               DataSensitivity.COUNT))
        THEN
          EXIT;

      DataClassificationMgt.SetSensitivities(DataSensitivity,Sensitivity);
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE SetLastMidifiedBy@2();
    VAR
      User@1000 : Record 2000000120;
    BEGIN
      LastModifiedBy := '';
      IF User.GET("Last Modified By") THEN
        LastModifiedBy := User."User Name"
      ELSE
        IF NOT ISNULLGUID("Last Modified By") THEN
          LastModifiedBy := DeletedUserTok;
    END;

    BEGIN
    END.
  }
}

