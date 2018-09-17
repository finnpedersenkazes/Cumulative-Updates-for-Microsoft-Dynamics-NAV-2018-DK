OBJECT Page 262 Item Journal Batches
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varekladdenavne;
               ENU=Item Journal Batches];
    SourceTable=Table233;
    DataCaptionExpr=DataCaption;
    PageType=List;
    OnInit=BEGIN
             SETRANGE("Journal Template Name");
           END;

    OnOpenPage=BEGIN
                 ItemJnlMgt.OpenJnlBatch(Rec);
               END;

    OnNewRecord=BEGIN
                  SetupNewBatch;
                END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 19      ;1   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Rediger kladde;
                                 ENU=Edit Journal];
                      ToolTipML=[DAN=èbn en kladde baseret pÜ kladdenavnet.;
                                 ENU=Open a journal based on the journal batch.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=OpenJournal;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ItemJnlMgt.TemplateSelectionFromBatch(Rec);
                               END;
                                }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      Image=Post }
      { 12      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=FÜ vist en testrapport, sÜ du kan finde og rette eventuelle fejl, fõr du udfõrer den faktiske bogfõring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Basic,#Suite;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintItemJnlBatch(Rec);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogfõr;
                                 ENU=P&ost];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden ved at bogfõre belõb og antal pÜ de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 243;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process }
      { 14      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogfõr og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden, og forbered udskrivning. Vërdierne og mëngderne bogfõres pÜ de relevante konti. Du fÜr vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Codeunit 244;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostPrint;
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
                ToolTipML=[DAN=Angiver navnet pÜ den varekladde, du er ved at oprette.;
                           ENU=Specifies the name of the item journal you are creating.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af det varekladdenavn, du er ved at oprette.;
                           ENU=Specifies a brief description of the item journal batch you are creating.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Series" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele bilagsnumre til finansposter, der er bogfõrt fra denne kladdekõrsel.;
                           ENU=Specifies the number series code used to assign document numbers to ledger entries that are posted from this journal batch.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting No. Series" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver Ürsagskoden som et supplerende kildespor, der hjëlper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reason Code" }

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
      ItemJnlMgt@1001 : Codeunit 240;

    LOCAL PROCEDURE DataCaption@1() : Text[250];
    VAR
      ItemJnlTemplate@1000 : Record 82;
    BEGIN
      IF NOT CurrPage.LOOKUPMODE THEN
        IF GETFILTER("Journal Template Name") <> '' THEN
          IF GETRANGEMIN("Journal Template Name") = GETRANGEMAX("Journal Template Name") THEN
            IF ItemJnlTemplate.GET(GETRANGEMIN("Journal Template Name")) THEN
              EXIT(ItemJnlTemplate.Name + ' ' + ItemJnlTemplate.Description);
    END;

    BEGIN
    END.
  }
}

