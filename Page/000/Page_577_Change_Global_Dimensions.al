OBJECT Page 577 Change Global Dimensions
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rediger globale dimensioner;
               ENU=Change Global Dimensions];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table484;
    PromotedActionCategoriesML=[DAN=Ny,Proces,Rapport,Fortl›bende,Parallel;
                                ENU=New,Process,Report,Sequential,Parallel];
    ShowFilter=No;
    OnOpenPage=BEGIN
                 ChangeGlobalDimensions.ResetIfAllCompleted;
               END;

    OnClosePage=BEGIN
                  ChangeGlobalDimensions.RemoveHeader;
                END;

    OnAfterGetCurrRecord=BEGIN
                           RefreshCurrentDimCodes;
                           ChangeGlobalDimensions.FillBuffer;
                           IsGlobalDimCodeEnabled := ChangeGlobalDimensions.IsDimCodeEnabled;
                           IsPrepareEnabledFlag := ChangeGlobalDimensions.IsPrepareEnabled(Rec);
                           IsStartEnabled := ChangeGlobalDimensions.IsStartEnabled;
                           SetStyle;
                         END;

    ActionList=ACTIONS
    {
      { 7       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 15      ;1   ;ActionGroup;
                      Name=Sequential;
                      CaptionML=[DAN=Fortl›bende;
                                 ENU=Sequential] }
      { 13      ;2   ;Action    ;
                      Name=StartSequential;
                      AccessByPermission=TableData 483=IMD;
                      CaptionML=[DAN=Start;
                                 ENU=Start];
                      ToolTipML=[DAN=Start processen, der implementerer de angivne dimensions‘ndringer i de ber›rte tabeller i den aktuelle session. Andre brugere kan ikke ‘ndre de ber›rte tabeller, mens processen k›rer.;
                                 ENU=Start the process that implements the specified dimension change(s) in the affected tables within the current session. Other users cannot change the affected tables while the process is running.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      Enabled=IsPrepareEnabledFlag AND NOT "Parallel Processing";
                      PromotedIsBig=Yes;
                      Image=Start;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ChangeGlobalDimensions.StartSequential;
                               END;
                                }
      { 14      ;1   ;ActionGroup;
                      Name=Parallel;
                      CaptionML=[DAN=Parallel;
                                 ENU=Parallel] }
      { 8       ;2   ;Action    ;
                      Name=Prepare;
                      AccessByPermission=TableData 483=IM;
                      CaptionML=[DAN=Forbered;
                                 ENU=Prepare];
                      ToolTipML=[DAN=Udfyld oversigtspanelet Log poster med listen over tabeller, der vil blive p†virket af den angivne dimensions‘ndring. Her kan du ogs† f›lge status for den baggrundssag, som udf›rer ‘ndringen. Bem‘rk: F›r du kan starte sagen, skal du logge ind og ud for at sikre, at den aktuelle bruger ikke kan ‘ndre de tabeller, der skal opdateres.;
                                 ENU=Fill the Log Entries FastTab with the list of tables that will be affected by the specified dimension change. Here you can also follow the progress of the background job that performs the change. Note: Before you can start the job, you must sign out and in to ensure that the current user cannot modify the tables that are being updated.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      Enabled=IsPrepareEnabledFlag AND "Parallel Processing";
                      PromotedIsBig=Yes;
                      Image=ChangeBatch;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ChangeGlobalDimensions.Prepare;
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=Reset;
                      AccessByPermission=TableData 483=D;
                      CaptionML=[DAN=Nulstil;
                                 ENU=Reset];
                      ToolTipML=[DAN=Annuller ‘ndringen.;
                                 ENU=Cancel the change.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      Enabled=IsStartEnabled AND "Parallel Processing";
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ChangeGlobalDimensions.ResetState;
                               END;
                                }
      { 10      ;2   ;Action    ;
                      Name=Start;
                      AccessByPermission=TableData 483=MD;
                      CaptionML=[DAN=Start;
                                 ENU=Start];
                      ToolTipML=[DAN=Start en baggrundsag, der implementerer de(n) angivne dimensions‘ndring(er) i de ber›rte tabeller. Andre brugere kan ikke ‘ndre de p†g‘ldende globale dimensioner, mens k›rslen er i gang. Bem‘rk: F›r du kan starte sagen, skal du v‘lge handlingen Forbered og derefter logge ud og ind.;
                                 ENU=Start a background job that implements the specified dimension change(s) in the affected tables. Other users cannot change the affected global dimensions while the job is running. Note: Before you can start the job, you must choose the Prepare action, and then sign out and in.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      Enabled=IsStartEnabled AND "Parallel Processing";
                      PromotedIsBig=Yes;
                      Image=Start;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ChangeGlobalDimensions.Start;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Indstillinger;
                           ENU=Options];
                GroupType=Group }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en anden global dimension, du vil bruge. Det andet felt i r‘kken viser den aktuelle globale dimension.;
                           ENU=Specifies another global dimension that you want to use. The second field on the row will show the current global dimension.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 1 Code";
                TableRelation=Dimension;
                Editable=IsGlobalDimCodeEnabled;
                StyleExpr=CurrGlobalDimCodeStyle1;
                OnValidate=BEGIN
                             IsPrepareEnabledFlag := ChangeGlobalDimensions.IsPrepareEnabled(Rec);
                             SetStyle;
                             CurrPage.UPDATE(TRUE);
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en anden global dimension, du vil bruge. Det andet felt i r‘kken viser den aktuelle globale dimension.;
                           ENU=Specifies another global dimension that you want to use. The second field on the row will show the current global dimension.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 2 Code";
                TableRelation=Dimension;
                Editable=IsGlobalDimCodeEnabled;
                StyleExpr=CurrGlobalDimCodeStyle2;
                OnValidate=BEGIN
                             IsPrepareEnabledFlag := ChangeGlobalDimensions.IsPrepareEnabled(Rec);
                             SetStyle;
                             CurrPage.UPDATE(TRUE);
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om ‘ndringen behandles af parallelle baggrundssager.;
                           ENU=Specifies if the change will be processed by parallel background jobs.];
                ApplicationArea=#Dimensions;
                SourceExpr="Parallel Processing";
                Enabled=IsGlobalDimCodeEnabled;
                OnValidate=BEGIN
                             CurrPage.UPDATE(TRUE);
                           END;
                            }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimension, der aktuelt er defineret som Global dimension 1.;
                           ENU=Specifies the dimension that is currently defined as Global Dimension 1.];
                ApplicationArea=#Dimensions;
                SourceExpr="Old Global Dimension 1 Code";
                Enabled=FALSE;
                StyleExpr=CurrGlobalDimCodeStyle1;
                ShowCaption=No }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dimension, der aktuelt er defineret som Global dimension 2.;
                           ENU=Specifies the dimension that is currently defined as Global Dimension 2.];
                ApplicationArea=#Dimensions;
                SourceExpr="Old Global Dimension 2 Code";
                Enabled=FALSE;
                StyleExpr=CurrGlobalDimCodeStyle2;
                ShowCaption=No }

    { 16  ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                Enabled=FALSE }

    { 9   ;1   ;Part      ;
                Name=LogLines;
                ApplicationArea=#Dimensions;
                PagePartID=Page578;
                PartType=Page }

  }
  CODE
  {
    VAR
      ChangeGlobalDimensions@1001 : Codeunit 483;
      CurrGlobalDimCodeStyle1@1006 : Text INDATASET;
      CurrGlobalDimCodeStyle2@1007 : Text INDATASET;
      IsGlobalDimCodeEnabled@1000 : Boolean;
      IsPrepareEnabledFlag@1002 : Boolean;
      IsStartEnabled@1003 : Boolean;

    LOCAL PROCEDURE SetStyle@1();
    BEGIN
      SetAmbiguousStyle(CurrGlobalDimCodeStyle1,"Old Global Dimension 1 Code" <> "Global Dimension 1 Code");
      SetAmbiguousStyle(CurrGlobalDimCodeStyle2,"Old Global Dimension 2 Code" <> "Global Dimension 2 Code");
    END;

    LOCAL PROCEDURE SetAmbiguousStyle@7(VAR Style@1000 : Text;Modified@1001 : Boolean);
    BEGIN
      IF Modified THEN
        Style := 'Ambiguous'
      ELSE
        Style := '';
    END;

    BEGIN
    END.
  }
}

