OBJECT Page 611 IC Outbox Transactions
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=IC-udbakketransaktioner;
               ENU=IC Outbox Transactions];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table414;
    PageType=Worksheet;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Funktioner,Udbakketransaktion;
                                ENU=New,Process,Report,Functions,Outbox Transaction];
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Udbakketransaktion;
                                 ENU=&Outbox Transaction];
                      Image=Export }
      { 34      ;2   ;Action    ;
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
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Bem‘rkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Intercompany;
                      RunObject=Page 620;
                      RunPageLink=Table Name=CONST(IC Outbox Transaction),
                                  Transaction No.=FIELD(Transaction No.),
                                  IC Partner Code=FIELD(IC Partner Code),
                                  Transaction Source=FIELD(Transaction Source);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 32      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 36      ;2   ;ActionGroup;
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
                                 CurrPage.SETSELECTIONFILTER(ICOutboxTransaction);
                                 IF ICOutboxTransaction.FIND('-') THEN
                                   REPEAT
                                     ICOutboxTransaction."Line Action" := ICOutboxTransaction."Line Action"::"No Action";
                                     ICOutboxTransaction.MODIFY;
                                   UNTIL ICOutboxTransaction.NEXT = 0;
                               END;
                                }
      { 37      ;3   ;Action    ;
                      Name=SendToICPartner;
                      CaptionML=[DAN=Send til IC-partner;
                                 ENU=Send to IC Partner];
                      ToolTipML=[DAN=Indstil feltet Linjehandling p† den valgte linje Send til IC-Partner for at angive, at transaktionen vil blive sendt til den koncerninterne partner.;
                                 ENU=Set the Line Action field on the selected line to Send to IC Partner, to indicate that the transaction will be sent to the IC partner.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=SendMail;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ICOutboxExport@1000 : Codeunit 431;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ICOutboxTransaction);
                                 IF ICOutboxTransaction.FIND('-') THEN
                                   REPEAT
                                     ICOutboxTransaction.VALIDATE("Line Action",ICOutboxTransaction."Line Action"::"Send to IC Partner");
                                     ICOutboxTransaction.MODIFY;
                                   UNTIL ICOutboxTransaction.NEXT = 0;
                                 ICOutboxExport.RunOutboxTransactions(ICOutboxTransaction);
                               END;
                                }
      { 38      ;3   ;Action    ;
                      CaptionML=[DAN=Returner til indbakke;
                                 ENU=Return to Inbox];
                      ToolTipML=[DAN=Indstil feltet Linjehandling p† den valgte linje Returner til indbakke for at angive, at transaktionen vil blive sendt tilbage til indbakken til revurdering.;
                                 ENU=Set the Line Action field on the selected line to Return to Inbox, to indicate that the transaction will be sent back to the inbox for reevaluation.];
                      ApplicationArea=#Intercompany;
                      Promoted=Yes;
                      Image=Return;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ICOutboxExport@1000 : Codeunit 431;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ICOutboxTransaction);
                                 IF ICOutboxTransaction.FIND('-') THEN
                                   REPEAT
                                     TESTFIELD("Transaction Source",ICOutboxTransaction."Transaction Source"::"Rejected by Current Company");
                                     ICOutboxTransaction."Line Action" := ICOutboxTransaction."Line Action"::"Return to Inbox";
                                     ICOutboxTransaction.MODIFY;
                                   UNTIL ICOutboxTransaction.NEXT = 0;
                                 ICOutboxExport.RunOutboxTransactions(ICOutboxTransaction);
                               END;
                                }
      { 39      ;3   ;Action    ;
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
                                 ICOutboxExport@1000 : Codeunit 431;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ICOutboxTransaction);
                                 IF ICOutboxTransaction.FIND('-') THEN
                                   REPEAT
                                     ICOutboxTransaction."Line Action" := ICOutboxTransaction."Line Action"::Cancel;
                                     ICOutboxTransaction.MODIFY;
                                   UNTIL ICOutboxTransaction.NEXT = 0;
                                 ICOutboxExport.RunOutboxTransactions(ICOutboxTransaction);
                               END;
                                }
      { 23      ;2   ;Separator  }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Fuldf›r linjehandlinger;
                                 ENU=Complete Line Actions];
                      ToolTipML=[DAN=Udfyld linjen med den angivne handling.;
                                 ENU=Complete the line with the action specified.];
                      ApplicationArea=#Advanced;
                      RunObject=Codeunit 431;
                      Promoted=Yes;
                      Image=CompleteLine;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 31  ;1   ;Group      }

    { 28  ;2   ;Field     ;
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

    { 29  ;2   ;Field     ;
                CaptionML=[DAN=Vis transaktionskilde;
                           ENU=Show Transaction Source];
                ToolTipML=[DAN=Angiver, hvordan du vil filtrere linjerne i vinduet. Du kan v‘lge kun at f† vist nye transaktioner oprettet af dine koncerninterne partnere, eller du kan f† vist de transaktioner, du eller dine koncerninterne partnere har oprettet eller f†et returneret, eller begge.;
                           ENU=Specifies how you want to filter the lines shown in the window. You can choose to see only new transactions that your intercompany partner(s) have created, only transactions that you created and your intercompany partner(s) returned to you, or both.];
                OptionCaptionML=[DAN=" ,Afvist af aktuelt regnskab,Oprettet af aktuelt regnskab";
                                 ENU=" ,Rejected by Current Company,Created by Current Company"];
                ApplicationArea=#Intercompany;
                SourceExpr=ShowLines;
                OnValidate=BEGIN
                             SETRANGE("Transaction Source");
                             CASE ShowLines OF
                               ShowLines::"Rejected by Current Company":
                                 SETRANGE("Transaction Source","Transaction Source"::"Rejected by Current Company");
                               ShowLines::"Created by Current Company":
                                 SETRANGE("Transaction Source","Transaction Source"::"Created by Current Company");
                             END;
                             ShowLinesOnAfterValidate;
                           END;
                            }

    { 30  ;2   ;Field     ;
                CaptionML=[DAN=Vis linjehandling;
                           ENU=Show Line Action];
                ToolTipML=[DAN=Angiver, hvordan du vil filtrere linjerne i vinduet. Du kan v‘lge at f† vist alle linjer eller kun linjer med en bestemt indstilling i feltet Linjehandling.;
                           ENU=Specifies how you want to filter the lines shown in the window. You can choose to see all lines, or only lines with a specific option in the Line Action field.];
                OptionCaptionML=[DAN=Alle,Ingen handling,Send til IC-partner,Returner til indbakke,Opret rettelseslinjer;
                                 ENU=All,No Action,Send to IC Partner,Return to Inbox,Create Correction Lines];
                ApplicationArea=#Intercompany;
                SourceExpr=ShowAction;
                OnValidate=BEGIN
                             SETRANGE("Line Action");
                             CASE ShowAction OF
                               ShowAction::"No Action":
                                 SETRANGE("Line Action","Line Action"::"No Action");
                               ShowAction::"Send to IC Partner":
                                 SETRANGE("Line Action","Line Action"::"Send to IC Partner");
                               ShowAction::"Return to Inbox":
                                 SETRANGE("Line Action","Line Action"::"Return to Inbox");
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
                           ENU=Specifies whether the transaction was created in a journal, a sales document or a purchase document.];
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
                ToolTipML=[DAN=Angiver, hvad der sker med transaktionen, n†r du fuldf›rer linjehandlingerne. Hvis feltet indeholder Ingen handling, forbliver linjen i Udbakke. Hvis feltet indeholder Send til IC-partner, sendes transaktionen til din koncerninterne partners indbakke.;
                           ENU=Specifies what happens to the transaction when you complete line actions. If the field contains No Action, the line will remain in the Outbox. If the field contains Send to IC Partner, the transaction will be sent to your intercompany partner's inbox.];
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
      ICOutboxTransaction@1003 : Record 414;
      PartnerFilter@1000 : Code[250];
      ShowLines@1001 : ' ,Rejected by Current Company,Created by Current Company';
      ShowAction@1002 : 'All,No Action,Send to IC Partner,Return to Inbox,Cancel';

    LOCAL PROCEDURE ShowLinesOnAfterValidate@19062975();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ShowActionOnAfterValidate@19051274();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE PartnerFilterOnAfterValidate@19027260();
    BEGIN
      SETFILTER("IC Partner Code",PartnerFilter);
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

