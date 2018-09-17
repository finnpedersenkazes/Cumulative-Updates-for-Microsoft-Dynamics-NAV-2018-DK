OBJECT Page 615 IC Inbox Transactions
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=IC-indbakketransak.;
               ENU=IC Inbox Transactions];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table418;
    PageType=Worksheet;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Funktioner,Udbakketransaktion;
                                ENU=New,Process,Report,Functions,Outbox Transaction];
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Indbakketransaktion;
                                 ENU=&Inbox Transaction];
                      Image=Import }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Detaljer;
                                 ENU=Details];
                      ToolTipML=[DAN=F† vist transaktionsdetaljer.;
                                 ENU=View transaction details.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 ShowDetails;
                               END;
                                }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Bem‘rkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 620;
                      RunPageLink=Table Name=CONST(IC Inbox Transaction),
                                  Transaction No.=FIELD(Transaction No.),
                                  IC Partner Code=FIELD(IC Partner Code),
                                  Transaction Source=FIELD(Transaction Source);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 34      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 35      ;2   ;ActionGroup;
                      CaptionML=[DAN=Angiv linjehandling;
                                 ENU=Set Line Action];
                      Image=SelectLineToApply }
      { 8       ;3   ;Action    ;
                      CaptionML=[DAN=Ingen handling;
                                 ENU=No Action];
                      ToolTipML=[DAN=Indstil feltet Linjehandling p† den valgte linje til Ingen handling for at angive, at transaktionen forbliver i udbakken.;
                                 ENU=Set the Line Action field on the selected line to No Action, to indicate that the transaction will remain in the outbox.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ICInboxTransaction);
                                 IF ICInboxTransaction.FIND('-') THEN
                                   REPEAT
                                     ICInboxTransaction."Line Action" := ICInboxTransaction."Line Action"::"No Action";
                                     ICInboxTransaction.MODIFY;
                                   UNTIL ICInboxTransaction.NEXT = 0;
                               END;
                                }
      { 36      ;3   ;Action    ;
                      CaptionML=[DAN=Accepter;
                                 ENU=Accept];
                      ToolTipML=[DAN=Angiv linjehandling til Accept‚r. Hvis der st†r Accept‚r i feltet, overf›res transaktionen til et dokument eller en kladde (du bliver bedt om at angive kladdenavn og -type).;
                                 ENU=Set line action to Accept. If the field contains Accept, the transaction will be transferred to a document or journal (the program will ask you to specify the journal batch and template).];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=Approve;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApplicationAreaSetup@1000 : Record 9178;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ICInboxTransaction);
                                 IF ICInboxTransaction.FIND('-') THEN
                                   REPEAT
                                     TESTFIELD("Transaction Source",ICInboxTransaction."Transaction Source"::"Created by Partner");
                                     ICInboxTransaction.VALIDATE("Line Action",ICInboxTransaction."Line Action"::Accept);
                                     ICInboxTransaction.MODIFY;
                                   UNTIL ICInboxTransaction.NEXT = 0;

                                 IF ApplicationAreaSetup.IsFoundationEnabled THEN
                                   RunInboxTransactions(ICInboxTransaction);
                               END;
                                }
      { 37      ;3   ;Action    ;
                      CaptionML=[DAN=Returner til IC-partner;
                                 ENU=Return to IC Partner];
                      ToolTipML=[DAN=Indstil linjehandlingen til Returner til IC-partner. Hvis feltet indeholder Returner til IC-partner, flyttes transaktionen til udbakken.;
                                 ENU=Set line action to Return to IC Partner. If the field contains Return to IC Partner, the transaction will be moved to the outbox.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=Return;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApplicationAreaSetup@1000 : Record 9178;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ICInboxTransaction);
                                 IF ICInboxTransaction.FIND('-') THEN
                                   REPEAT
                                     TESTFIELD("Transaction Source",ICInboxTransaction."Transaction Source"::"Created by Partner");
                                     ICInboxTransaction."Line Action" := ICInboxTransaction."Line Action"::"Return to IC Partner";
                                     ICInboxTransaction.MODIFY;
                                   UNTIL ICInboxTransaction.NEXT = 0;

                                 IF ApplicationAreaSetup.IsFoundationEnabled THEN
                                   RunInboxTransactions(ICInboxTransaction);
                               END;
                                }
      { 40      ;3   ;Action    ;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel];
                      ToolTipML=[DAN=Indstil feltet Linjehandling p† den valgte linje til Annuller for at angive, at transaktionen vil blive slettet i udbakken.;
                                 ENU=Set the Line Action field on the selected line to Cancel, to indicate that the transaction will deleted from the outbox.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApplicationAreaSetup@1000 : Record 9178;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ICInboxTransaction);
                                 IF ICInboxTransaction.FIND('-') THEN
                                   REPEAT
                                     ICInboxTransaction."Line Action" := ICInboxTransaction."Line Action"::Cancel;
                                     ICInboxTransaction.MODIFY;
                                   UNTIL ICInboxTransaction.NEXT = 0;

                                 IF ApplicationAreaSetup.IsFoundationEnabled THEN
                                   RunInboxTransactions(ICInboxTransaction);
                               END;
                                }
      { 38      ;2   ;Separator  }
      { 39      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Fuldf›r linjehandlinger;
                                 ENU=Complete Line Actions];
                      ToolTipML=[DAN=Udf›r de handlinger, der er angivet p† linjerne.;
                                 ENU=Carry out the actions that are specified on the lines.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=CompleteLine;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 RunInboxTransactions(Rec);
                               END;
                                }
      { 9       ;2   ;Separator  }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Indl‘s transaktionsfil;
                                 ENU=Import Transaction File];
                      ToolTipML=[DAN=Import‚r den fil, transaktionen skal oprettes med.;
                                 ENU=Import a file to create the transaction with.];
                      ApplicationArea=#Intercompany;
                      RunObject=Codeunit 435;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      Image=Import;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 25  ;1   ;Group      }

    { 29  ;2   ;Field     ;
                CaptionML=[DAN=Partnerfilter;
                           ENU=Partner Filter];
                ToolTipML=[DAN=Angiver, hvordan du vil filtrere linjerne i vinduet. Hvis du lader feltet st† tomt, f†r du vist samtlige transaktioner for alle koncerninterne partnere. Du kan angive et filter, s† der kun vises transaktioner for bestemte partnere i vinduet.;
                           ENU=Specifies how you want to filter the lines shown in the window. If the field is blank, the window will show the transactions for all of your intercompany partners. You can set a filter to determine the partner or partners whose transactions will be shown in the window.];
                ApplicationArea=#Intercompany;
                SourceExpr=PartnerFilter;
                OnValidate=BEGIN
                             PartnerFilterOnAfterValidate;
                           END;

                OnLookup=VAR
                           PartnerList@1000 : Page 608;
                         BEGIN
                           PartnerList.LOOKUPMODE(TRUE);
                           IF NOT (PartnerList.RUNMODAL = ACTION::LookupOK) THEN
                             EXIT(FALSE);
                           Text := PartnerList.GetSelectionFilter;
                           EXIT(TRUE);
                         END;
                          }

    { 30  ;2   ;Field     ;
                CaptionML=[DAN=Vis transaktionskilde;
                           ENU=Show Transaction Source];
                ToolTipML=[DAN=Angiver, hvordan du vil filtrere linjerne i vinduet. Du kan v‘lge kun at f† vist nye transaktioner oprettet af dine koncerninterne partnere, eller du kan f† vist de transaktioner, du eller dine koncerninterne partnere har oprettet eller f†et returneret, eller begge.;
                           ENU=Specifies how you want to filter the lines shown in the window. You can choose to see only new transactions that your intercompany partner(s) have created, only transactions that you created and your intercompany partner(s) returned to you, or both.];
                OptionCaptionML=[DAN=" ,Returneret af partner,Oprettet af partner";
                                 ENU=" ,Returned by Partner,Created by Partner"];
                ApplicationArea=#Intercompany;
                SourceExpr=ShowLines;
                OnValidate=BEGIN
                             SETRANGE("Transaction Source");
                             CASE ShowLines OF
                               ShowLines::"Returned by Partner":
                                 SETRANGE("Transaction Source","Transaction Source"::"Returned by Partner");
                               ShowLines::"Created by Partner":
                                 SETRANGE("Transaction Source","Transaction Source"::"Created by Partner");
                             END;
                             ShowLinesOnAfterValidate;
                           END;
                            }

    { 31  ;2   ;Field     ;
                CaptionML=[DAN=Vis linjehandling;
                           ENU=Show Line Action];
                ToolTipML=[DAN=Angiver, hvordan du vil filtrere linjerne i vinduet. Du kan v‘lge at f† vist alle linjer eller kun linjer med en bestemt indstilling i feltet Linjehandling.;
                           ENU=Specifies how you want to filter the lines shown in the window. You can choose to see all lines, or only lines with a specific option in the Line Action field.];
                OptionCaptionML=[DAN=Alle,Ingen handling,Accept,Returner til IC-partner;
                                 ENU=All,No Action,Accept,Return to IC Partner];
                ApplicationArea=#Intercompany;
                SourceExpr=ShowAction;
                OnValidate=BEGIN
                             SETRANGE("Line Action");
                             CASE ShowAction OF
                               ShowAction::"No Action":
                                 SETRANGE("Line Action","Line Action"::"No Action");
                               ShowAction::Accept:
                                 SETRANGE("Line Action","Line Action"::Accept);
                               ShowAction::"Return to IC Partner":
                                 SETRANGE("Line Action","Line Action"::"Return to IC Partner");
                               ShowAction::Cancel:
                                 SETRANGE("Line Action","Line Action"::Cancel);
                             END;
                             ShowActionOnAfterValidate;
                           END;
                            }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver transaktionens l›benummer.;
                           ENU=Specifies the transaction's entry number.];
                ApplicationArea=#Intercompany;
                SourceExpr="Transaction No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den koncerninterne partner, som transaktionen er relateret til, hvis posten blev oprettet fra en koncernintern transaktion.;
                           ENU=Specifies the code of the intercompany partner that the transaction is related to if the entry was created from an intercompany transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="IC Partner Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktionen blev oprettet i en kladde, et salgsdokument eller et k›bsdokument.;
                           ENU=Specifies whether the transaction was created in a journal, a sales document, or a purchase document.];
                ApplicationArea=#Intercompany;
                SourceExpr="Source Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver type af det relaterede bilag.;
                           ENU=Specifies the type of the related document.];
                ApplicationArea=#Intercompany;
                SourceExpr="Document Type" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det relaterede bilag.;
                           ENU=Specifies the number of the related document.];
                ApplicationArea=#Intercompany;
                SourceExpr="Document No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#Intercompany;
                SourceExpr="Posting Date" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken virksomhed der har oprettet transaktionen.;
                           ENU=Specifies which company created the transaction.];
                ApplicationArea=#Intercompany;
                SourceExpr="Transaction Source" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Intercompany;
                SourceExpr="Document Date" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken handling der foretages for linjen, n†r du v‘lger handlingen Fuldf›r linjehandlinger.;
                           ENU=Specifies what action is taken for the line when you choose the Complete Line Actions action.];
                ApplicationArea=#Advanced;
                SourceExpr="Line Action" }

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
      ICInboxTransaction@1003 : Record 418;
      PartnerFilter@1000 : Code[250];
      ShowLines@1001 : ' ,Returned by Partner,Created by Partner';
      ShowAction@1002 : 'All,No Action,Accept,Return to IC Partner,Cancel';

    LOCAL PROCEDURE PartnerFilterOnAfterValidate@19027260();
    BEGIN
      SETFILTER("IC Partner Code",PartnerFilter);
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ShowLinesOnAfterValidate@19062975();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ShowActionOnAfterValidate@19051274();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    PROCEDURE RunInboxTransactions@6(VAR ICInboxTransaction@1000 : Record 418);
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
      ICInboxTransactionCopy@1003 : Record 418;
      RunReport@1002 : Boolean;
    BEGIN
      IF ApplicationAreaSetup.IsFoundationEnabled THEN
        RunReport := FALSE
      ELSE
        RunReport := TRUE;

      ICInboxTransactionCopy.COPY(ICInboxTransaction);
      ICInboxTransactionCopy.SETRANGE("Source Type",ICInboxTransactionCopy."Source Type"::Journal);

      IF NOT ICInboxTransactionCopy.ISEMPTY THEN
        RunReport := TRUE;

      COMMIT;
      REPORT.RUNMODAL(REPORT::"Complete IC Inbox Action",RunReport,FALSE,ICInboxTransaction);
      CurrPage.UPDATE(TRUE);
    END;

    BEGIN
    END.
  }
}

