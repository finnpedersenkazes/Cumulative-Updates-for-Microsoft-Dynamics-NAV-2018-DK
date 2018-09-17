OBJECT Page 104 Account Schedule
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontoskema;
               ENU=Account Schedule];
    MultipleNewLines=Yes;
    SourceTable=Table85;
    DataCaptionFields=Schedule Name;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=BEGIN
                 AccSchedManagement.OpenAndCheckSchedule(CurrentSchedName,Rec);
               END;

    OnAfterGetRecord=BEGIN
                       IF NOT DimCaptionsInitialized THEN
                         DimCaptionsInitialized := TRUE;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 29      ;1   ;Action    ;
                      Name=Overview;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Oversigt;
                                 ENU=Overview];
                      ToolTipML=[DAN=Se en oversigt over det aktuelle kontoskema.;
                                 ENU=View an overview of the current account schedule.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ViewDetails;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 AccSchedOverview@1001 : Page 490;
                               BEGIN
                                 AccSchedOverview.SetAccSchedName(CurrentSchedName);
                                 AccSchedOverview.RUN;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 11      ;1   ;Action    ;
                      Name=Indent;
                      CaptionML=[DAN=Indryk;
                                 ENU=Indent];
                      ToolTipML=[DAN=MarkÇr denne rëkke som vërende en del af en rëkkegruppe. Indryk f.eks. rëkker, der angiver en rëkke konti, f.eks. indtëgtstyper.;
                                 ENU=Make this row part of a group of rows. For example, indent rows that itemize a range of accounts, such as types of revenue.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Indent;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=VAR
                                 AccScheduleLine@1000 : Record 85;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(AccScheduleLine);
                                 IF AccScheduleLine.FINDSET THEN
                                   REPEAT
                                     AccScheduleLine.Indent;
                                     AccScheduleLine.MODIFY;
                                   UNTIL AccScheduleLine.NEXT = 0;
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=Outdent;
                      CaptionML=[DAN=Ryk ud;
                                 ENU=Outdent];
                      ToolTipML=[DAN=Ryk denne rëkke et niveau ud.;
                                 ENU=Move this row out one level.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=DecreaseIndent;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=VAR
                                 AccScheduleLine@1000 : Record 85;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(AccScheduleLine);
                                 IF AccScheduleLine.FINDSET THEN
                                   REPEAT
                                     AccScheduleLine.Outdent;
                                     AccScheduleLine.MODIFY;
                                   UNTIL AccScheduleLine.NEXT = 0;
                                 CurrPage.UPDATE(FALSE);
                               END;
                                }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 7       ;2   ;Action    ;
                      Name=InsertGLAccounts;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indsët finanskonti;
                                 ENU=Insert G/L Accounts];
                      ToolTipML=[DAN=èbn listen over finanskonti, sÜ du kan tilfõje konti i kontoskemaet.;
                                 ENU=Open the list of general ledger accounts so you can add accounts to the account schedule.];
                      ApplicationArea=#Basic,#Suite;
                      Image=InsertAccount;
                      OnAction=VAR
                                 AccSchedLine@1001 : Record 85;
                               BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 SetupAccSchedLine(AccSchedLine);
                                 AccSchedManagement.InsertGLAccounts(AccSchedLine);
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=InsertCFAccounts;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indsët CF-konti;
                                 ENU=Insert CF Accounts];
                      ToolTipML=[DAN=MarkÇr pengestrõmskonti fra diagrammet med pengestrõmskonti, og kopiÇr dem til linjer i kontoskemaet.;
                                 ENU=Mark the cash flow accounts from the chart of cash flow accounts and copy them to account schedule lines.];
                      ApplicationArea=#Advanced;
                      Image=InsertAccount;
                      OnAction=VAR
                                 AccSchedLine@1001 : Record 85;
                               BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 SetupAccSchedLine(AccSchedLine);
                                 AccSchedManagement.InsertCFAccounts(AccSchedLine);
                               END;
                                }
      { 3       ;2   ;Action    ;
                      Name=InsertCostTypes;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Indsët pristyper;
                                 ENU=Insert Cost Types];
                      ToolTipML=[DAN=Indsët omkostningstyperne for at analysere, hvad omkostningerne er, hvor omkostningerne kommer fra, og hvem der skal afholde omkostningerne.;
                                 ENU=Insert cost types to analyze what the costs are, where the costs come from, and who should bear the costs.];
                      ApplicationArea=#CostAccounting;
                      Image=InsertAccount;
                      OnAction=VAR
                                 AccSchedLine@1001 : Record 85;
                               BEGIN
                                 CurrPage.UPDATE(TRUE);
                                 SetupAccSchedLine(AccSchedLine);
                                 AccSchedManagement.InsertCostTypes(AccSchedLine);
                               END;
                                }
      { 24      ;2   ;Action    ;
                      Name=EditColumnLayoutSetup;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Rediger opsëtning af kolonneformat;
                                 ENU=Edit Column Layout Setup];
                      ToolTipML=[DAN=Opret eller rediger kolonnelayoutet for det aktuelle kontoskemanavn.;
                                 ENU=Create or change the column layout for the current account schedule name.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 489;
                      Image=SetupColumns }
      { 14      ;    ;ActionContainer;
                      CaptionML=[DAN=Rapporter;
                                 ENU=Reports];
                      ActionContainerType=Reports }
      { 22      ;1   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Print;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 AccScheduleName@1001 : Record 84;
                               BEGIN
                                 AccScheduleName.GET("Schedule Name");
                                 AccScheduleName.Print;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 18  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet pÜ kontoskemaet.;
                           ENU=Specifies the name of the account schedule.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CurrentSchedName;
                OnValidate=BEGIN
                             AccSchedManagement.CheckName(CurrentSchedName);
                             CurrentSchedNameOnAfterValidat;
                           END;

                OnLookup=BEGIN
                           EXIT(AccSchedManagement.LookupName(CurrentSchedName,Text));
                         END;
                          }

    { 1   ;1   ;Group     ;
                IndentationColumnName=Indentation;
                IndentationControls=Description;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nummer, som identificerer linjen.;
                           ENU=Specifies a number that identifies the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Row No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tekst, der vises pÜ kontoskemalinjen.;
                           ENU=Specifies text that will appear on the account schedule line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Style=Strong;
                StyleExpr=Bold }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver sammentëllingstypen for kontoskemalinjen. Typen er afgõrende for, hvilke konti inden for det valgte sammentëllingsinterval, du har angivet i feltet Sammentëlling, der bliver sammentalt. ";
                           ENU="Specifies the totaling type for the account schedule line. The type determines which accounts within the totaling interval you specify in the Totaling field will be totaled. "];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Totaling Type" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en oversigt over kontonumre. Posterne for kontoen sammentëlles for at give en balancesum. Hvordan poster sammentëlles afhënger af vërdien i feltet Kontotype.;
                           ENU=Specifies an account interval or a list of account numbers. The entries of the account will be totaled to give a total balance. How entries are totaled depends on the value in the Account Type field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Totaling }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rëkketypen for kontoskemarëkken. Typen er afgõrende for, hvordan belõbene i rëkken beregnes.;
                           ENU=Specifies the row type for the account schedule row. The type determines how the amounts in the row are calculated.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Row Type" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke posttyper der skal medtages i belõbene i kontoskemarëkken.;
                           ENU=Specifies the type of entries that will be included in the amounts in the account schedule row.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Type" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om debiteringer skal vises som negative belõb med et minustegn og krediteringer som positive belõb i rapporter.;
                           ENU=Specifies whether to show debits in reports as negative amounts with a minus sign and credits as positive amounts.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Show Opposite Sign" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke dimensionsvërdibelõb der vil blive sammentalt i linjen.;
                           ENU=Specifies which dimension value amounts will be totaled on this line.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 1 Totaling";
                Visible=FALSE;
                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(1,Text));
                         END;
                          }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke dimensionsvërdibelõb der vil blive sammentalt i linjen.;
                           ENU=Specifies which dimension value amounts will be totaled on this line.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 2 Totaling";
                Visible=FALSE;
                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(2,Text));
                         END;
                          }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke dimensionsvërdibelõb der vil blive sammentalt i linjen.;
                           ENU=Specifies which dimension value amounts will be totaled on this line.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 3 Totaling";
                Visible=FALSE;
                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(3,Text));
                         END;
                          }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilke dimensionsvërdibelõb der vil blive sammentalt i linjen.;
                           ENU=Specifies which dimension value amounts will be totaled on this line.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension 4 Totaling";
                Visible=FALSE;
                OnLookup=BEGIN
                           EXIT(LookUpDimFilter(4,Text));
                         END;
                          }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kontoskemalinjen skal udskrives pÜ rapporten.;
                           ENU=Specifies whether the account schedule line will be printed on the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Show }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om belõbene i denne rëkke skal udskrives med fed.;
                           ENU=Specifies whether to print the amounts in this row in bold.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Bold }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om belõbene i denne rëkke skal udskrives med kursiv.;
                           ENU=Specifies whether to print the amounts in this row in italics.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Italic }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om belõbene i denne rëkke skal udskrives med understregning.;
                           ENU=Specifies whether to underline the amounts in this row.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Underline }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om belõbene i denne rëkke skal udskrives med dobbelt understregning.;
                           ENU=Specifies whether to double underline the amounts in this row.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Double Underline";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der ved udskrivning af kontoskemaet skal laves et sideskift lige efter den aktuelle konto.;
                           ENU=Specifies whether there will be a page break after the current account when the account schedule is printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="New Page" }

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
      AccSchedManagement@1000 : Codeunit 8;
      CurrentSchedName@1001 : Code[10];
      DimCaptionsInitialized@1003 : Boolean;

    [External]
    PROCEDURE SetAccSchedName@1(NewAccSchedName@1000 : Code[10]);
    BEGIN
      CurrentSchedName := NewAccSchedName;
    END;

    LOCAL PROCEDURE CurrentSchedNameOnAfterValidat@19053875();
    BEGIN
      CurrPage.SAVERECORD;
      AccSchedManagement.SetName(CurrentSchedName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    [External]
    PROCEDURE SetupAccSchedLine@3(VAR AccSchedLine@1000 : Record 85);
    BEGIN
      AccSchedLine := Rec;
      IF "Line No." = 0 THEN BEGIN
        AccSchedLine := xRec;
        AccSchedLine.SETRANGE("Schedule Name",CurrentSchedName);
        IF AccSchedLine.NEXT = 0 THEN
          AccSchedLine."Line No." := xRec."Line No." + 10000
        ELSE BEGIN
          IF AccSchedLine.FINDLAST THEN
            AccSchedLine."Line No." += 10000;
          AccSchedLine.SETRANGE("Schedule Name");
        END;
      END;
    END;

    BEGIN
    END.
  }
}

