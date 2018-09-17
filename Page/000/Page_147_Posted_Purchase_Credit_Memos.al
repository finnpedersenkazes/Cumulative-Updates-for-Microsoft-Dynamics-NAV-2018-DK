OBJECT Page 147 Posted Purchase Credit Memos
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Bogfõrte kõbskreditnotaer;
               ENU=Posted Purchase Credit Memos];
    SourceTable=Table124;
    SourceTableView=SORTING(Posting Date)
                    ORDER(Descending);
    PageType=List;
    CardPageID=Posted Purchase Credit Memo;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Annuller;
                                ENU=New,Process,Report,Cancel];
    OnOpenPage=VAR
                 OfficeMgt@1000 : Codeunit 1630;
                 HasFilters@1001 : Boolean;
               BEGIN
                 HasFilters := GETFILTERS <> '';
                 SetSecurityFilterOnRespCenter;
                 IF HasFilters THEN
                   IF FINDFIRST THEN;
                 IsOfficeAddin := OfficeMgt.IsAvailable;
                 IsFoundationEnabled := ApplicationAreaSetup.IsFoundationEnabled;
               END;

    OnAfterGetCurrRecord=BEGIN
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kr&editnota;
                                 ENU=&Cr. Memo];
                      Image=CreditMemo }
      { 29      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 401;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 66;
                      RunPageLink=Document Type=CONST(Posted Credit Memo),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102601000;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kreditoren i kõbsdokumentet.;
                                 ENU=View or edit detailed information about the vendor on the purchase document.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 26;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Promoted=Yes;
                      Image=Vendor;
                      PromotedCategory=Process;
                      Scope=Repeater }
      { 21      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du fÜr vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PurchCrMemoHdr@1102 : Record 124;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(PurchCrMemoHdr);
                                 PurchCrMemoHdr.PrintRecords(TRUE);
                               END;
                                }
      { 22      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte dokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel] }
      { 14      ;2   ;Action    ;
                      Name=CancelCrMemo;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel];
                      ToolTipML=[DAN=Opret og bogfõr en kõbsfaktura, der tilbagefõrer denne bogfõrte kõbskreditnota. Denne bogfõrte kõbskreditnota bliver annulleret.;
                                 ENU=Create and post a purchase invoice that reverses this posted purchase credit memo. This posted purchase credit memo will be canceled.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Cancel PstdPurchCrM (Yes/No)",Rec);
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=ShowInvoice;
                      CaptionML=[DAN=Vis annulleret faktura/rettelsesfaktura;
                                 ENU=Show Canceled/Corrective Invoice];
                      ToolTipML=[DAN=èbn den bogfõrte salgsfaktura, som blev oprettet, da du annullerede den bogfõrte salgskreditnota. Hvis den bogfõrte salgskreditnota er resultatet af en annulleret salgsfaktura, Übnes den annullerede faktura.;
                                 ENU=Open the posted sales invoice that was created when you canceled the posted sales credit memo. If the posted sales credit memo is the result of a canceled sales invoice, then canceled invoice will open.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      Enabled=Cancelled OR Corrective;
                      PromotedIsBig=Yes;
                      Image=Invoice;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ShowCanceledOrCorrInvoice;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#All;
                SourceExpr="Buy-from Vendor No." }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Address Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who delivered the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Vendor Name" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt til at beregne belõbene pÜ kreditnotaen.;
                           ENU=Specifies the currency code used to calculate the amounts on the credit memo.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr kreditnotaen er forfalden til betaling. Feltet beregnes automatisk ud fra data i felterne Betalingsbeting.kode og Bogfõringsdato pÜ kõbshovedet.;
                           ENU=Specifies when the credit memo is due. The program calculates the date using the Payment Terms Code and Posting Date fields on the purchase header.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af belõbene, i kreditnotaens valuta, pÜ kreditnotalinjerne.;
                           ENU=Specifies the total, in the currency of the credit memo, of the amounts on all the credit memo lines.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                OnDrillDown=BEGIN
                              SETRANGE("No.");
                              PAGE.RUNMODAL(PAGE::"Posted Purchase Credit Memo",Rec)
                            END;
                             }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede sum af belõbene, herunder moms, pÜ alle dokumentets linjer.;
                           ENU=Specifies the total of the amounts, including VAT, on all the lines on the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Including VAT";
                OnDrillDown=BEGIN
                              SETRANGE("No.");
                              PAGE.RUNMODAL(PAGE::"Posted Purchase Credit Memo",Rec)
                            END;
                             }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der mangler at blive betalt for den bogfõrte kõbsfaktura, der vedrõrer denne kõbskreditnota.;
                           ENU=Specifies the amount that remains to be paid for the posted purchase invoice that relates to this purchase credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte kõbsfaktura, der er relateret til denne kõbskreditnota, er betalt. Afkrydsningsfeltet markeres ogsÜ, hvis der er oprettet en kreditnota for restbelõbet.;
                           ENU=Specifies if the posted purchase invoice that relates to this purchase credit memo is paid. The check box will also be selected if a credit memo for the remaining amount has been applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Paid }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte kõbsfaktura, der vedrõrer denne kõbskreditnota, er rettet eller annulleret.;
                           ENU=Specifies if the posted purchase invoice that relates to this purchase credit memo has been either corrected or canceled.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Cancelled;
                Editable=FALSE;
                LookupPageID=Posted Sales Invoices;
                DrillDownPageID=Posted Sales Invoices;
                HideValue=NOT Cancelled;
                Style=Unfavorable;
                StyleExpr=Cancelled;
                OnDrillDown=BEGIN
                              ShowCorrectiveInvoice;
                            END;
                             }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte kõbsfaktura er rettet eller annulleret af denne kõbskreditnota.;
                           ENU=Specifies if the posted purchase invoice has been either corrected or canceled by this purchase credit memo .];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Corrective;
                Editable=FALSE;
                LookupPageID=Posted Sales Invoices;
                DrillDownPageID=Posted Sales Invoices;
                HideValue=NOT Corrective;
                Style=Unfavorable;
                StyleExpr=Corrective;
                OnDrillDown=BEGIN
                              ShowCancelledInvoice;
                            END;
                             }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the post code of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Post Code";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen for den kreditor, der leverede varerne.;
                           ENU=Specifies the city of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Country/Region Code";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen hos den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the contact person at the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Contact";
                Visible=FALSE }

    { 127 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the number of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Vendor No.";
                Visible=FALSE }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the name of the vendor who you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Name";
                Visible=FALSE }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the post code of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Post Code";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens lande/omrÜdekode.;
                           ENU=Specifies the country/region code of the address.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Country/Region Code";
                Visible=FALSE }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den kontaktperson, du kan kontakte hos den kreditor, du har modtaget kreditnotaen fra.;
                           ENU=Specifies the name of the person you should contact at the vendor who you received the credit memo from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact";
                Visible=FALSE }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omrÜdekoden pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kreditnotaen blev bogfõrt.;
                           ENU=Specifies the date the credit memo was posted.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken indkõber der er tilknyttet kreditoren.;
                           ENU=Specifies which purchaser is assigned to the vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchaser Code";
                Visible=FALSE }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, der blev brugt ved bogfõring af kreditnotaen.;
                           ENU=Specifies the code for the location used when you posted the credit memo.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Advanced;
                SourceExpr="No. Printed" }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 1102601003;2;Field  ;
                ToolTipML=[DAN=Angiver den type bogfõrt bilag, som dette bilag eller denne kladdelinje udlignes med, nÜr du bogfõrer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-to Doc. Type";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 3   ;1   ;Part      ;
                Name=IncomingDocAttachFactBox;
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page193;
                Visible=NOT IsOfficeAddin;
                PartType=Page;
                ShowFilter=No }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ApplicationAreaSetup@1001 : Record 9178;
      IsOfficeAddin@1000 : Boolean;
      IsFoundationEnabled@1002 : Boolean;

    BEGIN
    END.
  }
}

