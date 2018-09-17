OBJECT Page 571 No. Series List
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Nummerserieoversigt;
               ENU=No. Series List];
    SourceTable=Table308;
    PageType=List;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Naviger;
                                ENU=New,Process,Report,Navigate];
    OnAfterGetRecord=BEGIN
                       UpdateLine(StartDate,StartNo,EndNo,LastNoUsed,WarningNo,IncrementByNo,LastDateUsed);
                     END;

    OnNewRecord=BEGIN
                  StartDate := 0D;
                  StartNo := '';
                  EndNo := '';
                  LastNoUsed := '';
                  WarningNo := '';
                  IncrementByNo := 0;
                  LastDateUsed := 0D;
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Serie;
                                 ENU=&Series];
                      Image=SerialNo }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Linjer;
                                 ENU=Lines];
                      ToolTipML=[DAN=Definer detaljerede oplysninger om nummerserierne.;
                                 ENU=Define additional information about the number series.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 457;
                      RunPageLink=Series Code=FIELD(Code);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AllLines;
                      PromotedCategory=Category4 }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Relationer;
                                 ENU=Relationships];
                      ToolTipML=[DAN=Definer relationerne mellem nummerserier.;
                                 ENU=Define the relationship between number series.];
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
                ToolTipML=[DAN=Angiver den dato, hvorfra du ›nsker at anvende denne nummerserie. Du kan bruge dette felt, hvis du vil starte en ny serie fra begyndelsen af en ny periode. Du kan oprette en nummerserielinje for hver periode. P† startdatoen skiftes der automatisk til den nye serie.;
                           ENU=Specifies the date from which you want this number series to apply. You use this field if you want to start a new series at the beginning of a new period. You set up a number series line for each period. The program will automatically switch to the new series on the starting date.];
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
                ToolTipML=[DAN=Angiver, hvorn†r du vil have en advarsel om, at nummerserien er ved at udl›be. Skriv et nummer fra serien. Der bliver vist en advarsel, n†r programmet n†r til dette nummer. Du kan bruge op til 20 tegn (b†de tal og bogstaver).;
                           ENU=Specifies when you want to receive a warning that the number series is running out. You enter a number from the series. The program will provide a warning when this number is reached. You can enter a maximum of 20 characters, both numbers and letters.];
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
                ToolTipML=[DAN=Angiver v‘rdien til for›gelse af den numeriske del af serien.;
                           ENU=Specifies the value for incrementing the numeric part of the series.];
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
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

