OBJECT Page 577 Change Global Dimensions
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rediger globale dimensioner;
               ENU=Change Global Dimensions];
    LinksAllowed=No;
    ShowFilter=No;
    OnOpenPage=BEGIN
                 ChangeGlobalDimensions.Initialize;
                 ChangeGlobalDimensions.GetCurrentGlobalDimCodes(CurrentGlobalDimCode);
               END;

    OnAfterGetCurrRecord=BEGIN
                           IsGlobalDimCodeEnabled := ChangeGlobalDimensions.IsDimCodeEnabled;
                           ChangeGlobalDimensions.GetNewGlobalDimCodes(NewGlobalDimCode);
                           IsPrepareEnabled := ChangeGlobalDimensions.IsPrepareEnabled;
                           IsStartEnabled := ChangeGlobalDimensions.IsStartEnabled;
                           SetStyle;
                         END;

    ActionList=ACTIONS
    {
      { 7       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 8       ;1   ;Action    ;
                      Name=Prepare;
                      AccessByPermission=TableData 483=IM;
                      CaptionML=[DAN=Forbered;
                                 ENU=Prepare];
                      ToolTipML=[DAN=Forbered tabeller, der indeholder en reference til globale dimensioner.;
                                 ENU=Prepare tables that contains references to global dimensions.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=IsPrepareEnabled;
                      PromotedIsBig=Yes;
                      Image=ChangeBatch;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ChangeGlobalDimensions.Prepare;
                               END;
                                }
      { 11      ;1   ;Action    ;
                      Name=Reset;
                      AccessByPermission=TableData 483=D;
                      CaptionML=[DAN=Nulstil;
                                 ENU=Reset];
                      ToolTipML=[DAN=Annuller ‘ndringen.;
                                 ENU=Cancel the change.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Visible=IsStartEnabled;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ChangeGlobalDimensions.Reset;
                               END;
                                }
      { 10      ;1   ;Action    ;
                      Name=Start;
                      AccessByPermission=TableData 483=MD;
                      CaptionML=[DAN=Start;
                                 ENU=Start];
                      ToolTipML=[DAN=Start planl‘gning af baggrundssager pr. tabel.;
                                 ENU=Start scheduling background jobs per table.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=IsStartEnabled;
                      PromotedIsBig=Yes;
                      Image=Start;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ChangeGlobalDimensions.Start;
                                 ChangeGlobalDimensions.GetCurrentGlobalDimCodes(CurrentGlobalDimCode);
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
                Name=GlobalDimension1Code;
                CaptionML=[DAN=Global dimension 1-kode;
                           ENU=Global Dimension 1 Code];
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr=NewGlobalDimCode[1];
                TableRelation=Dimension;
                Editable=IsGlobalDimCodeEnabled;
                StyleExpr=CurrGlobalDimCodeStyle1;
                OnValidate=BEGIN
                             ChangeGlobalDimensions.SetNewGlobalDim1Code(NewGlobalDimCode[1]);
                             ChangeGlobalDimensions.GetNewGlobalDimCodes(NewGlobalDimCode);
                             IsPrepareEnabled := ChangeGlobalDimensions.IsPrepareEnabled;
                             SetStyle;
                           END;
                            }

    { 4   ;2   ;Field     ;
                Name=GlobalDimension2Code;
                CaptionML=[DAN=Global dimension 2-kode;
                           ENU=Global Dimension 2 Code];
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr=NewGlobalDimCode[2];
                TableRelation=Dimension;
                Editable=IsGlobalDimCodeEnabled;
                StyleExpr=CurrGlobalDimCodeStyle2;
                OnValidate=BEGIN
                             ChangeGlobalDimensions.SetNewGlobalDim2Code(NewGlobalDimCode[2]);
                             ChangeGlobalDimensions.GetNewGlobalDimCodes(NewGlobalDimCode);
                             IsPrepareEnabled := ChangeGlobalDimensions.IsPrepareEnabled;
                             SetStyle;
                           END;
                            }

    { 5   ;2   ;Field     ;
                Name=CurrGlobalDimension1Code;
                ToolTipML=[DAN=Angiver den dimension, der aktuelt er defineret som Global dimension 1.;
                           ENU=Specifies the dimension that is currently defined as Global Dimension 1.];
                ApplicationArea=#Suite;
                SourceExpr=CurrentGlobalDimCode[1];
                Enabled=FALSE;
                StyleExpr=CurrGlobalDimCodeStyle1;
                ShowCaption=No }

    { 6   ;2   ;Field     ;
                Name=CurrGlobalDimension2Code;
                ToolTipML=[DAN=Angiver den dimension, der aktuelt er defineret som Global dimension 2.;
                           ENU=Specifies the dimension that is currently defined as Global Dimension 2.];
                ApplicationArea=#Suite;
                SourceExpr=CurrentGlobalDimCode[2];
                Enabled=FALSE;
                StyleExpr=CurrGlobalDimCodeStyle2;
                ShowCaption=No }

    { 9   ;1   ;Part      ;
                Name=LogLines;
                ApplicationArea=#Suite;
                PagePartID=Page578;
                PartType=Page }

  }
  CODE
  {
    VAR
      ChangeGlobalDimensions@1001 : Codeunit 483;
      CurrentGlobalDimCode@1005 : ARRAY [2] OF Code[20];
      NewGlobalDimCode@1000 : ARRAY [2] OF Code[20];
      CurrGlobalDimCodeStyle1@1006 : Text INDATASET;
      CurrGlobalDimCodeStyle2@1007 : Text INDATASET;
      IsPrepareEnabled@1002 : Boolean;
      IsStartEnabled@1004 : Boolean;
      IsGlobalDimCodeEnabled@1003 : Boolean;

    LOCAL PROCEDURE SetStyle@1();
    BEGIN
      SetAmbiguousStyle(CurrGlobalDimCodeStyle1,CurrentGlobalDimCode[1] <> NewGlobalDimCode[1]);
      SetAmbiguousStyle(CurrGlobalDimCodeStyle2,CurrentGlobalDimCode[2] <> NewGlobalDimCode[2]);
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

