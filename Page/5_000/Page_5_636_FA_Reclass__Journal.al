OBJECT Page 5636 FA Reclass. Journal
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anl‘gsompost.kladde;
               ENU=FA Reclass. Journal];
    SaveValues=Yes;
    SourceTable=Table5624;
    DelayedInsert=Yes;
    DataCaptionFields=Journal Batch Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 JnlSelected@1000 : Boolean;
               BEGIN
                 IF IsOpenedFromBatch THEN BEGIN
                   CurrentJnlBatchName := "Journal Batch Name";
                   FAReclassJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
                   EXIT;
                 END;
                 FAReclassJnlManagement.TemplateSelection(PAGE::"FA Reclass. Journal",Rec,JnlSelected);
                 IF NOT JnlSelected THEN
                   ERROR('');

                 FAReclassJnlManagement.OpenJournal(CurrentJnlBatchName,Rec);
               END;

    OnNewRecord=BEGIN
                  SetUpNewLine(xRec);
                END;

    OnAfterGetCurrRecord=BEGIN
                           FAReclassJnlManagement.GetFAS(Rec,FADescription,NewFADescription);
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 30      ;1   ;Action    ;
                      Name=Reclassify;
                      CaptionML=[DAN=&Omposter;
                                 ENU=Recl&assify];
                      ToolTipML=[DAN=Omposter oplysningerne om anl‘gget p† kladdelinjerne.;
                                 ENU=Reclassify the fixed asset information on the journal lines.];
                      ApplicationArea=#FixedAssets;
                      Promoted=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"FA Reclass. Jnl.-Transfer",Rec);
                                 CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 10  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Kladdenavn;
                           ENU=Batch Name];
                ToolTipML=[DAN=Angiver navnet p† den kladdek›rsel, et personligt kladdelayout, som kladden er baseret p†.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the journal is based on.];
                ApplicationArea=#FixedAssets;
                SourceExpr=CurrentJnlBatchName;
                OnValidate=BEGIN
                             FAReclassJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                             CurrentJnlBatchNameOnAfterVali;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           FAReclassJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samme dato som i feltet Bogf›ringsdato for anl‘g, n†r linjen bogf›res.;
                           ENU=Specifies the same date as the FA Posting Date field when the line is posted.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for den relaterede anl‘gstransaktion, f.eks. en afskrivning.;
                           ENU=Specifies the posting date of the related fixed asset transaction, such as a depreciation.];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA Posting Date" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v‘rdi afh‘ngigt af, hvordan du har konfigureret den nummerserie, der er tildelt den aktuelle kladdek›rsel.;
                           ENU=Specifies a value depending on how you have set up the number series that is assigned to the current journal batch.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Document No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver nummeret for det relaterede anl‘g. ";
                           ENU="Specifies the number of the related fixed asset. "];
                ApplicationArea=#FixedAssets;
                SourceExpr="FA No.";
                OnValidate=BEGIN
                             FAReclassJnlManagement.GetFAS(Rec,FADescription,NewFADescription);
                           END;
                            }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det anl‘g, som du vil ompostere til.;
                           ENU=Specifies the number of the fixed asset you want to reclassify to.];
                ApplicationArea=#FixedAssets;
                SourceExpr="New FA No.";
                OnValidate=BEGIN
                             FAReclassJnlManagement.GetFAS(Rec,FADescription,NewFADescription);
                           END;
                            }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den afskrivningsprofil, linjen skal bogf›res til, hvis du har valgt Anl‘gsaktiv i feltet Type for denne linje.;
                           ENU=Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Depreciation Book Code" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Viser den beskrivelse af aktivet, du har angivet i feltet Anl‘gsnr.;
                           ENU=Specifies the description of the asset entered in the FA No field. field.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det anskaffelsesbel›b, som du vil ompostere.;
                           ENU=Specifies the acquisition amount you want to reclassify.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reclassify Acq. Cost Amount";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af anskaffelsesprisen, som du vil ompostere.;
                           ENU=Specifies the percentage of the acquisition cost you want to reclassify.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reclassify Acq. Cost %" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Viser omposteringen af anskaffelsesprisen for det anl‘g, som du har angivet i feltet Anl‘gsnr., til det anl‘g, du har angivet i feltet Nyt anl‘gsnr.;
                           ENU=Specifies the reclassification of the acquisition cost for the fixed asset entered in the FA No. field, to the fixed asset entered in the New FA No. field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reclassify Acquisition Cost" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Viser omposteringen af den akkumulerede afskrivning for det anl‘g, som du har angivet i feltet Anl‘gsnr., til det anl‘g, du har angivet i feltet Nyt anl‘gsnr.;
                           ENU=Specifies the reclassification of the accumulated depreciation for the fixed asset entered in the FA No. field, to the fixed asset entered in the New FA No. field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reclassify Depreciation" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Viser omposteringen af alle nedskrivningsposter for det anl‘g, som du har angivet i feltet Anl‘gsnr., til det anl‘g, du har angivet i feltet Nyt anl‘gsnr.;
                           ENU=Specifies the reclassification of all write-down entries for the fixed asset entered in the FA No. field to the fixed asset you have entered in the New FA No. field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reclassify Write-Down";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Vis omposteringen af alle opskrivningsposter for det anl‘g, som du har angivet i feltet Anl‘gsnr., til det anl‘g, du har angivet i feltet Nyt anl‘gsnr.;
                           ENU=Specifies the reclassification of all appreciation entries for the fixed asset entered in the FA No. field to the fixed asset entered in the New FA No. field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reclassify Appreciation";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Viser omposteringen af alle Bruger 1-poster for det anl‘g, som du har angivet i feltet Anl‘gsnr., til det anl‘g, du har angivet i feltet Nyt anl‘gsnr.;
                           ENU=Specifies the reclassification of all custom 1 entries for the fixed asset entered in the FA No. field to the fixed asset entered in the New FA No. field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reclassify Custom 1";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Viser omposteringen af alle Bruger 2-poster for det anl‘g, som du har angivet i feltet Anl‘gsnr., til det anl‘g, du har angivet i feltet Nyt anl‘gsnr.;
                           ENU=Specifies the reclassification of all custom 2 entries for the fixed asset entered in the FA No. field to the fixed asset entered in the New FA No. field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reclassify Custom 2";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver skrapv‘rdien for det anl‘g, der skal omposteres, til det anl‘g, du har angivet i feltet Nyt anl‘gsnr.;
                           ENU=Specifies the salvage value for the fixed asset to be reclassified to the fixed asset entered in the New FA No. field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reclassify Salvage Value";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om du vil oprette en eller flere udlignende postlinjer i anl‘gsfinanskladden eller anl‘gskladden.;
                           ENU=Specifies whether to create one or more balancing entry lines in the FA general ledger journal or FA Journal.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Insert Bal. Account" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at funktionen Omposter udfylder felterne Midlertidig slutdato og Midlertidigt fast afskr.bel›b p† anl‘gsafskrivningsprofilen.;
                           ENU=Specifies that the Reclassify function fills in the Temp. Ending Date and Temp. Fixed Depr. Amount fields on the FA depreciation book.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Calc. DB1 Depr. Amount";
                Visible=FALSE }

    { 33  ;1   ;Group      }

    { 1902115301;2;Group  ;
                GroupType=FixedLayout }

    { 1901652501;3;Group  ;
                CaptionML=[DAN=Anl‘gsbeskrivelse;
                           ENU=FA Description] }

    { 35  ;4   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af anl‘gget.;
                           ENU=Specifies a description of the fixed asset.];
                ApplicationArea=#FixedAssets;
                SourceExpr=FADescription;
                Editable=FALSE;
                ShowCaption=No }

    { 1901991701;3;Group  ;
                CaptionML=[DAN=Ny anl‘gsbeskrivelse;
                           ENU=New FA Description] }

    { 36  ;4   ;Field     ;
                CaptionML=[DAN=Ny anl‘gsbeskrivelse;
                           ENU=New FA Description];
                ToolTipML=[DAN=Angiver en beskrivelse af det anl‘g, der er indtastet i feltet Nyt anl‘gsnr. p† linjen.;
                           ENU=Specifies a description of the fixed asset that is entered in the New FA No. field on the line.];
                ApplicationArea=#FixedAssets;
                SourceExpr=NewFADescription;
                Editable=FALSE }

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
      FAReclassJnlManagement@1000 : Codeunit 5646;
      CurrentJnlBatchName@1001 : Code[10];
      FADescription@1002 : Text[30];
      NewFADescription@1003 : Text[30];

    LOCAL PROCEDURE CurrentJnlBatchNameOnAfterVali@19002411();
    BEGIN
      CurrPage.SAVERECORD;
      FAReclassJnlManagement.SetName(CurrentJnlBatchName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

