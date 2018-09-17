OBJECT Page 317 VAT Statement
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Momsangivelse;
               ENU=VAT Statement];
    SaveValues=Yes;
    MultipleNewLines=Yes;
    SourceTable=Table256;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    OnOpenPage=VAR
                 StmtSelected@1000 : Boolean;
               BEGIN
                 OpenedFromBatch := ("Statement Name" <> '') AND ("Statement Template Name" = '');
                 IF OpenedFromBatch THEN BEGIN
                   CurrentStmtName := "Statement Name";
                   VATStmtManagement.OpenStmt(CurrentStmtName,Rec);
                   EXIT;
                 END;
                 VATStmtManagement.TemplateSelection(PAGE::"VAT Statement",Rec,StmtSelected);
                 IF NOT StmtSelected THEN
                   ERROR('');
                 VATStmtManagement.OpenStmt(CurrentStmtName,Rec);
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 28      ;1   ;ActionGroup;
                      CaptionML=[DAN=Moms&angivelse;
                                 ENU=VAT &Statement];
                      Image=Suggest }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=&Vis;
                                 ENU=P&review];
                      ToolTipML=[DAN=Vis momsangivelsesrapporten.;
                                 ENU=Preview the VAT statement report.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 474;
                      RunPageLink=Statement Template Name=FIELD(Statement Template Name),
                                  Name=FIELD(Statement Name);
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Process }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1902106506;1 ;Action    ;
                      CaptionML=[DAN=Momsangivelse;
                                 ENU=VAT Statement];
                      ToolTipML=[DAN=Vis en opg›relse over bogf›rt moms, og beregn de skyldige afgifter for den valgte periode til toldv‘senet.;
                                 ENU=View a statement of posted VAT and calculate the duty liable to the customs authorities for the selected period.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 ReportPrint.PrintVATStmtLine(Rec);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 32      ;2   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Udskriv;
                                 ENU=Print];
                      ToolTipML=[DAN=Udskriv oplysningerne i vinduet. Du f†r vist et anmodningsvindue for udskrivningen, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Print the information in the window. A print request window opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ReportPrint.PrintVATStmtLine(Rec);
                               END;
                                }
      { 33      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Afregn moms;
                                 ENU=Calc. and Post VAT Settlement];
                      ToolTipML=[DAN=Luk †bne skatteposter, og overf›r k›bs- og salgsskattebel›b til skatteafregningskontoen.;
                                 ENU=Close open Tax entries and transfers purchase and sales Tax amounts to the Tax settlement account.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 20;
                      Promoted=Yes;
                      Image=SettleOpenTransactions;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 35  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† momsangivelsen.;
                           ENU=Specifies the name of the VAT statement.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CurrentStmtName;
                OnValidate=BEGIN
                             VATStmtManagement.CheckName(CurrentStmtName,Rec);
                             CurrentStmtNameOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           EXIT(VATStmtManagement.LookupName(GETRANGEMAX("Statement Template Name"),CurrentStmtName,Text));
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nummer, som identificerer linjen.;
                           ENU=Specifies a number that identifies the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Row No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af momsangivelsen.;
                           ENU=Specifies a description of the VAT statement line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kasse, som momsangivelsen g‘lder for.;
                           ENU=Specifies the number on the packaging box that the VAT statement applies to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Box No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvad momsangivelseslinjen skal indeholde.;
                           ENU=Specifies what the VAT statement line will include.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et kontointerval eller en kontonummerserie.;
                           ENU=Specifies an account interval or a series of account numbers.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Account Totaling";
                OnLookup=VAR
                           GLAccountList@1000 : Page 18;
                         BEGIN
                           GLAccountList.LOOKUPMODE(TRUE);
                           IF NOT (GLAccountList.RUNMODAL = ACTION::LookupOK) THEN
                             EXIT(FALSE);
                           Text := GLAccountList.GetSelectionFilter;
                           EXIT(TRUE);
                         END;
                          }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transaktionstypen.;
                           ENU=Specifies the type of transaction.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Gen. Posting Type" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede debitors eller kreditors momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Bus. Posting Group" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den involverede vares eller ressources momsspecifikation for at knytte transaktioner, der er foretaget for denne record, til den relevante finanskonto i overensstemmelse med den generelle momsbogf›ringsops‘tning.;
                           ENU=Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="VAT Prod. Posting Group" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om momsangivelseslinjen viser momsbel›bene eller de basisbel›b, hvorfra momsen beregnes.;
                           ENU=Specifies if the VAT statement line shows the VAT amounts, or the base amounts on which the VAT is calculated.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Type" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et rubriknummerinterval eller en r‘kke rubriknumre.;
                           ENU=Specifies a row-number interval or a series of row numbers.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Row Totaling" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om programmet i sine interne beregninger skal kunne vende fortegnet ved momsposter.;
                           ENU=Specifies whether to reverse the sign of VAT entries when it performs calculations.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Calculate with" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den aktuelle momsangivelseslinje skal udskrives p† den rapport, der indeholder den f‘rdige momsangivelse. Hvis afkrydsningsfeltet er markeret, betyder det, at linjen udskrives.;
                           ENU=Specifies whether the VAT statement line will be printed on the report that contains the finished VAT statement. A check mark in the field means that the line will be printed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Print }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bel›bene p† momsangivelsen skal udskrives med deres oprindelige fortegn eller med vendt fortegn.;
                           ENU=Specifies whether amounts on the VAT statement will be printed with their original sign or with the sign reversed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Print with" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der ved udskrivning af momsangivelsen skal v‘re et sideskift umiddelbart efter denne momsangivelseslinje. Mark‚r afkrydsningsfeltet, hvis der skal v‘re sideskift efter denne linje.;
                           ENU=Specifies whether a new page should begin immediately after this line when the VAT statement is printed. To start a new page after this line, place a check mark in the field.];
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
      ReportPrint@1000 : Codeunit 228;
      VATStmtManagement@1001 : Codeunit 340;
      CurrentStmtName@1002 : Code[10];
      OpenedFromBatch@1003 : Boolean;

    LOCAL PROCEDURE CurrentStmtNameOnAfterValidate@19076269();
    BEGIN
      CurrPage.SAVERECORD;
      VATStmtManagement.SetName(CurrentStmtName,Rec);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

