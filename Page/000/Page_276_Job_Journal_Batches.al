OBJECT Page 276 Job Journal Batches
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=[DAN=Sagskladdenavne;
               ENU=Job Journal Batches];
    SourceTable=Table237;
    DataCaptionExpr=DataCaption;
    PageType=List;
    RefreshOnActivate=Yes;
    OnInit=BEGIN
             SETRANGE("Journal Template Name");
           END;

    OnOpenPage=BEGIN
                 JobJnlMgt.OpenJnlBatch(Rec);
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
                      ToolTipML=[DAN=�bn en kladde baseret p� kladdenavnet.;
                                 ENU=Open a journal based on the journal batch.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=OpenJournal;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 JobJnlMgt.TemplateSelectionFromBatch(Rec);
                               END;
                                }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Bogf�ring;
                                 ENU=P&osting];
                      Image=Post }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Kontroller;
                                 ENU=Test Report];
                      ToolTipML=[DAN=F� vist en testrapport, s� du kan finde og rette eventuelle fejl, f�r du udf�rer den faktiske bogf�ring af kladden eller bilaget.;
                                 ENU=View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.];
                      ApplicationArea=#Jobs;
                      Image=TestReport;
                      OnAction=BEGIN
                                 ReportPrint.PrintJobJnlBatch(Rec);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      ShortCutKey=F9;
                      CaptionML=[DAN=&Bogf�r;
                                 ENU=P&ost];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden ved at bogf�re bel�b og antal p� de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Jobs;
                      RunObject=Codeunit 1023;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process }
      { 14      ;2   ;Action    ;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Bogf�r og &udskriv;
                                 ENU=Post and &Print];
                      ToolTipML=[DAN=F�rdigg�r bilaget eller kladden, og forbered udskrivning. V�rdierne og m�ngderne bogf�res p� de relevante konti. Du f�r vist et rapportanmodningsvindue, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.];
                      ApplicationArea=#Jobs;
                      RunObject=Codeunit 1024;
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
                ToolTipML=[DAN=Angiver navnet p� denne sagskladde. Du kan angive op til 10 tegn, b�de tal og bogstaver.;
                           ENU=Specifies the name of this job journal. You can enter a maximum of 10 characters, both numbers and letters.];
                ApplicationArea=#Jobs;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af denne kladde. Du kan bruge op til 50 tegn (b�de tal og bogstaver).;
                           ENU=Specifies a description of this journal. You can enter a maximum of 50 characters, both numbers and letters.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Jobs;
                SourceExpr="No. Series" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der bruges til at knytte bilagsnumre til finansposter, der bogf�res fra denne kladdek�rsel. Mark�r dette felt for at f� vist den nummerserie, der er oprettet i tabellen Nummerserie.;
                           ENU=Specifies the code for the number series that will be used to assign document numbers to ledger entries that are posted from this journal batch. To see the number series that have been set up in the No. Series table, choose the field.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting No. Series" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver �rsagskoden som et supplerende kildespor, der hj�lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Reason Code";
                Visible=TRUE }

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
      JobJnlMgt@1001 : Codeunit 1020;

    LOCAL PROCEDURE DataCaption@1() : Text[250];
    VAR
      JobJnlTemplate@1000 : Record 209;
    BEGIN
      IF NOT CurrPage.LOOKUPMODE THEN
        IF GETFILTER("Journal Template Name") <> '' THEN
          IF GETRANGEMIN("Journal Template Name") = GETRANGEMAX("Journal Template Name") THEN
            IF JobJnlTemplate.GET(GETRANGEMIN("Journal Template Name")) THEN
              EXIT(JobJnlTemplate.Name + ' ' + JobJnlTemplate.Description);
    END;

    BEGIN
    END.
  }
}

