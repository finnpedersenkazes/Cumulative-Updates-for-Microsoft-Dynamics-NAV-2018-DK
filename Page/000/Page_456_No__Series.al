OBJECT Page 456 No. Series
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Nummerserie;
               ENU=No. Series];
    SourceTable=Table308;
    PageType=List;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Naviger;
                                ENU=New,Process,Report,Navigate];
    OnAfterGetRecord=BEGIN
                       UpdateLineActionOnPage;
                     END;

    OnNewRecord=BEGIN
                  UpdateLineActionOnPage;
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Serie;
                                 ENU=&Series];
                      Image=SerialNo }
      { 5       ;2   ;Action    ;
                      CaptionML=[DAN=Linjer;
                                 ENU=Lines];
                      ToolTipML=[DAN=Se eller rediger detaljerede oplysninger om nummerserielinjerne.;
                                 ENU=View or edit additional information about the number series lines.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 457;
                      RunPageLink=Series Code=FIELD(Code);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AllLines;
                      PromotedCategory=Category4 }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Relationer;
                                 ENU=Relationships];
                      ToolTipML=[DAN=Se eller rediger relationerne mellem nummerserierne.;
                                 ENU=View or edit relationships between number series.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 458;
                      RunPageLink=Code=FIELD(Code);
                      Promoted=Yes;
                      Image=Relationship;
                      PromotedCategory=Category4 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for nummerserien.;
                           ENU=Specifies a number series code.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af nummerserien.;
                           ENU=Specifies a description of the number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 22  ;2   ;Field     ;
                CaptionML=[DAN=Startdato;
                           ENU=Starting Date];
                ToolTipML=[DAN=Angiver den dato, som linjen g‘lder fra.;
                           ENU=Specifies the date from which this line applies.];
                ApplicationArea=#Advanced;
                SourceExpr=StartDate;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrillDownActionOnPage;
                            END;
                             }

    { 20  ;2   ;Field     ;
                DrillDown=Yes;
                CaptionML=[DAN=Startnr.;
                           ENU=Starting No.];
                ToolTipML=[DAN=Angiver det f›rste nummer i serien.;
                           ENU=Specifies the first number in the series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=StartNo;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrillDownActionOnPage;
                            END;
                             }

    { 14  ;2   ;Field     ;
                DrillDown=Yes;
                CaptionML=[DAN=Slutnr.;
                           ENU=Ending No.];
                ToolTipML=[DAN=Angiver det sidste nummer i serien.;
                           ENU=Specifies the last number in the series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=EndNo;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrillDownActionOnPage;
                            END;
                             }

    { 28  ;2   ;Field     ;
                CaptionML=[DAN=Sidst anvendt dato;
                           ENU=Last Date Used];
                ToolTipML=[DAN=Angiver datoen, hvor der sidst blev tildelt et nummer fra nummerserien.;
                           ENU=Specifies the date when a number was most recently assigned from the number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=LastDateUsed;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrillDownActionOnPage;
                            END;
                             }

    { 9   ;2   ;Field     ;
                DrillDown=Yes;
                CaptionML=[DAN=Sidst anvendt nr.;
                           ENU=Last No. Used];
                ToolTipML=[DAN=Angiver det sidste nummer, der er benyttet, fra nummerserien.;
                           ENU=Specifies the last number that was used from the number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=LastNoUsed;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrillDownActionOnPage;
                            END;
                             }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Advarselsnr.;
                           ENU=Warning No.];
                ToolTipML=[DAN=Angiver navnet p† diagramnotaens sprog.;
                           ENU=Specifies the language name of the chart memo.];
                ApplicationArea=#Advanced;
                SourceExpr=WarningNo;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrillDownActionOnPage;
                            END;
                             }

    { 16  ;2   ;Field     ;
                CaptionML=[DAN=For›g med;
                           ENU=Increment-by No.];
                ToolTipML=[DAN=Angiver et nummer, der angiver st›rrelsen p† intervallet mellem numrene i nummerserien.;
                           ENU=Specifies a number that represents the size of the interval by which the numbers in the series are spaced.];
                ApplicationArea=#Advanced;
                SourceExpr=IncrementByNo;
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              DrillDownActionOnPage;
                            END;
                             }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om denne nummerserie skal bruges til automatisk tildeling af numre.;
                           ENU=Specifies whether this number series will be used to assign numbers automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Default Nos." }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du kan indtaste numre manuelt i stedet for at bruge nummerserien.;
                           ENU=Specifies that you can enter numbers manually instead of using this number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Manual Nos." }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du skal kontrollere, at numre tildeles kronologisk.;
                           ENU=Specifies to check that numbers are assigned chronologically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Date Order" }

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
      StartDate@1003 : Date;
      StartNo@1004 : Code[20];
      EndNo@1005 : Code[20];
      LastNoUsed@1006 : Code[20];
      WarningNo@1007 : Code[20];
      IncrementByNo@1008 : Integer;
      LastDateUsed@1009 : Date;

    LOCAL PROCEDURE DrillDownActionOnPage@4();
    BEGIN
      DrillDown;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE UpdateLineActionOnPage@1();
    BEGIN
      UpdateLine(StartDate,StartNo,EndNo,LastNoUsed,WarningNo,IncrementByNo,LastDateUsed);
    END;

    BEGIN
    END.
  }
}

