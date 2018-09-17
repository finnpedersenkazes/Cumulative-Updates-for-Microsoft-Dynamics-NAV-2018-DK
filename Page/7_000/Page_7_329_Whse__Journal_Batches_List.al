OBJECT Page 7329 Whse. Journal Batches List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Lagerkladdenavneoversigt;
               ENU=Whse. Journal Batches List];
    SourceTable=Table7310;
    DataCaptionExpr=DataCaption;
    DelayedInsert=Yes;
    PageType=List;
    OnFindRecord=BEGIN
                   IF FIND(Which) THEN BEGIN
                     WhseJnlBatch := Rec;
                     WHILE TRUE DO BEGIN
                       IF WMSManagement.LocationIsAllowed("Location Code") THEN
                         EXIT(TRUE);
                       IF NEXT(1) = 0 THEN BEGIN
                         Rec := WhseJnlBatch;
                         IF FIND(Which) THEN
                           WHILE TRUE DO BEGIN
                             IF WMSManagement.LocationIsAllowed("Location Code") THEN
                               EXIT(TRUE);
                             IF NEXT(-1) = 0 THEN
                               EXIT(FALSE);
                           END;
                       END;
                     END;
                   END;
                   EXIT(FALSE);
                 END;

    OnNextRecord=VAR
                   RealSteps@1001 : Integer;
                   NextSteps@1002 : Integer;
                 BEGIN
                   IF Steps = 0 THEN
                     EXIT;

                   WhseJnlBatch := Rec;
                   REPEAT
                     NextSteps := NEXT(Steps / ABS(Steps));
                     IF WMSManagement.LocationIsAllowed("Location Code") THEN BEGIN
                       RealSteps := RealSteps + NextSteps;
                       WhseJnlBatch := Rec;
                     END;
                   UNTIL (NextSteps = 0) OR (RealSteps = Steps);
                   Rec := WhseJnlBatch;
                   FIND;
                   EXIT(RealSteps);
                 END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 12      ;1   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Rediger kladde;
                                 ENU=Edit Journal];
                      ToolTipML=[DAN=èbn en kladde baseret pÜ kladdenavnet.;
                                 ENU=Open a journal based on the journal batch.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=OpenJournal;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 WhseJnlLine.TemplateSelectionFromBatch(Rec);
                               END;
                                }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=R&egistrering;
                                 ENU=&Registering];
                      Image=PostOrder }
      { 13      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=Vis en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Advanced;
                      Image=TestReport;
                      OnAction=VAR
                                 ReportPrint@1000 : Codeunit 228;
                               BEGIN
                                 ReportPrint.PrintWhseJnlBatch(Rec);
                               END;
                                }
      { 14      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Journal;
                                 ENU=&Register];
                      ToolTipML=[DAN="Registrer den pÜgëldende lagerpost, f.eks. en opregulering. ";
                                 ENU="Register the warehouse entry in question, such as a positive adjustment. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Codeunit 7305;
                      Promoted=Yes;
                      Image=Confirm;
                      PromotedCategory=Process }
      { 21      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Registrer og &udskriv;
                                 ENU=Register and &Print];
                      ToolTipML=[DAN="Registrer lagerreguleringsposterne, og udskriv en oversigt over ëndringerne. ";
                                 ENU="Register the warehouse entry adjustments and print an overview of the changes. "];
                      ApplicationArea=#Advanced;
                      RunObject=Codeunit 7300;
                      Promoted=Yes;
                      Image=ConfirmAndPrint;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ lagerkladdekõrslen.;
                           ENU=Specifies the name of the warehouse journal batch.];
                ApplicationArea=#Warehouse;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af lagerkladdekõrslen.;
                           ENU=Specifies a description of the warehouse journal batch.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor kladdekõrslen gëlder.;
                           ENU=Specifies the code of the location where the journal batch applies.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Ürsagskoden som et supplerende kildespor, der hjëlper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Warehouse;
                SourceExpr="Reason Code" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Warehouse;
                SourceExpr="No. Series" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele bilagsnumre til de lagerposter, der er registreret fra kladdekõrslen.;
                           ENU=Specifies the number series code used to assign document numbers to the warehouse entries that are registered from this journal batch.];
                ApplicationArea=#Warehouse;
                SourceExpr="Registering No. Series" }

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
      WhseJnlLine@1002 : Record 7311;
      WhseJnlBatch@1000 : Record 7310;
      WMSManagement@1001 : Codeunit 7302;

    LOCAL PROCEDURE DataCaption@1() : Text[250];
    VAR
      WhseJnlTemplate@1000 : Record 7309;
    BEGIN
      IF NOT CurrPage.LOOKUPMODE THEN
        IF GETFILTER("Journal Template Name") <> '' THEN
          IF GETRANGEMIN("Journal Template Name") = GETRANGEMAX("Journal Template Name") THEN
            IF WhseJnlTemplate.GET(GETRANGEMIN("Journal Template Name")) THEN
              EXIT(WhseJnlTemplate.Name + ' ' + WhseJnlTemplate.Description);
    END;

    BEGIN
    END.
  }
}

