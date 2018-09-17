OBJECT Page 146 Posted Purchase Invoices
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
    CaptionML=[DAN=Bogf. kõbsfakturaer;
               ENU=Posted Purchase Invoices];
    SourceTable=Table122;
    SourceTableView=SORTING(Posting Date)
                    ORDER(Descending);
    PageType=List;
    CardPageID=Posted Purchase Invoice;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Ret,Faktura;
                                ENU=New,Process,Report,Correct,Invoice];
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
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=F&aktura;
                                 ENU=&Invoice];
                      Image=Invoice }
      { 29      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 400;
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
                      RunPageLink=Document Type=CONST(Posted Invoice),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102601000;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=IncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=IndgÜende bilag;
                                 ENU=Incoming Document];
                      ToolTipML=[DAN=Vis eller opret en indgÜende bilagsrecord, som er knyttet til posten eller bilaget.;
                                 ENU=View or create an incoming document record that is linked to the entry or document.];
                      ApplicationArea=#Advanced;
                      Image=Document;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCard("No.","Posting Date");
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 22      ;1   ;Action    ;
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
                                 PurchInvHeader@1102 : Record 122;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(PurchInvHeader);
                                 PurchInvHeader.PrintRecords(TRUE);
                               END;
                                }
      { 18      ;1   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=N&aviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogfõringsdatoen pÜ det valgte bogfõrte kõbsdokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected posted purchase document.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsOfficeAddin;
                      Image=Navigate;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 26      ;1   ;ActionGroup;
                      Name=RelatedInformationNavigation;
                      CaptionML=[DAN=Navigation;
                                 ENU=Navigation];
                      Image=Invoice }
      { 24      ;2   ;Action    ;
                      Name=Vendor;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kreditor;
                                 ENU=Vendor];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om kreditoren i kõbsdokumentet.;
                                 ENU=View or edit detailed information about the vendor on the purchase document.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 26;
                      RunPageLink=No.=FIELD(Buy-from Vendor No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Vendor;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      Scope=Repeater }
      { 16      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ret;
                                 ENU=Correct] }
      { 12      ;2   ;Action    ;
                      Name=CorrectInvoice;
                      CaptionML=[DAN=Ret;
                                 ENU=Correct];
                      ToolTipML=[DAN=Tilbagefõr denne bogfõrte faktura, og opret automatisk en ny faktura med de samme oplysninger, som du kan rette, fõr du bogfõrer. Denne bogfõrte faktura bliver annulleret automatisk.;
                                 ENU=Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      PromotedIsBig=Yes;
                      Image=Undo;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Correct PstdPurchInv (Yes/No)",Rec);
                               END;
                                }
      { 14      ;2   ;Action    ;
                      Name=CancelInvoice;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel];
                      ToolTipML=[DAN=Opret og bogfõr en kõbskreditnota, der tilbagefõrer denne bogfõrte kõbsfaktura. Denne bogfõrte kõbsfaktura bliver annulleret.;
                                 ENU=Create and post a purchase credit memo that reverses this posted purchase invoice. This posted purchase invoice will be canceled.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Cancel PstdPurchInv (Yes/No)",Rec);
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=CreateCreditMemo;
                      CaptionML=[DAN=Opret rettelseskreditnota;
                                 ENU=Create Corrective Credit Memo];
                      ToolTipML=[DAN=Opret en kreditnota til denne bogfõrte faktura, som du udfylder og bogfõrer manuelt for at tilbagefõre den bogfõrte faktura.;
                                 ENU=Create a credit memo for this posted invoice that you complete and post manually to reverse the posted invoice.];
                      ApplicationArea=#Basic,#Suite;
                      Image=CreateCreditMemo;
                      Scope=Repeater;
                      OnAction=VAR
                                 PurchaseHeader@1001 : Record 38;
                                 CorrectPostedPurchInvoice@1000 : Codeunit 1313;
                               BEGIN
                                 CorrectPostedPurchInvoice.CreateCreditMemoCopyDocument(Rec,PurchaseHeader);
                                 PAGE.RUN(PAGE::"Purchase Credit Memo",PurchaseHeader);
                               END;
                                }
      { 20      ;2   ;Action    ;
                      Name=ShowCreditMemo;
                      CaptionML=[DAN=Vis annulleret kreditnota/rettelseskreditnota;
                                 ENU=Show Canceled/Corrective Credit Memo];
                      ToolTipML=[DAN=èbn den bogfõrte kõbskreditnota, som blev oprettet, da du annullerede den bogfõrte kõbsfaktura. Hvis den bogfõrte kõbsfaktura er resultatet af en annulleret kõbskreditnota, Übnes den annullerede kõbskreditnota.;
                                 ENU=Open the posted purchase credit memo that was created when you canceled the posted purchase invoice. If the posted purchase invoice is the result of a canceled purchase credit memo, then canceled purchase credit memo will open.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=Cancelled OR Corrective;
                      Image=CreditMemo;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ShowCanceledOrCorrCrMemo;
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

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for det oprindelige bilag, du modtog fra kreditoren. Du kan krëve bilagsnummeret til bogfõring, eller du kan lade det vëre valgfrit. Det er pÜkrëvet som standard, sÜ dette bilag refererer til originalen. Det fjerner et trin fra bogfõringsprocessen at gõre bilagsnumre valgfri. Hvis du f.eks. vedhëfter den oprindelige faktura som en PDF-fil, behõver du mÜske ikke at angive bilagsnummeret. I vinduet Kõbsopsëtning kan du vëlge, om bilagsnumre er pÜkrëvet ved at vëlge eller rydde markeringen i afkrydsningsfeltet Eksternt bilagsnr. obl.;
                           ENU=Specifies the document number of the original document you received from the vendor. You can require the document number for posting, or let it be optional. By default, it's required, so that this document references the original. Making document numbers optional removes a step from the posting process. For example, if you attach the original invoice as a PDF, you might not need to enter the document number. To specify whether document numbers are required, in the Purchases & Payables Setup window, select or clear the Ext. Doc. No. Mandatory field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Vendor Invoice No." }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Kreditornr.;
                           ENU=Vendor No.];
                ToolTipML=[DAN=Angiver id'et pÜ den kreditor, som du har kõbt varerne af.;
                           ENU=Specifies the identifier of the vendor that you bought the items from.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Vendor No." }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bestillingsadressen for den relaterede kreditor.;
                           ENU=Specifies the order address of the related vendor.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Address Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Kreditor;
                           ENU=Vendor];
                ToolTipML=[DAN=Angiver navnet pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the name of the vendor who shipped the items.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Buy-from Vendor Name" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, der er brugt til at beregne belõbene pÜ fakturaen.;
                           ENU=Specifies the currency code used to calculate the amounts on the invoice.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede sum af belõbene pÜ alle fakturaens linjer, angivet i fakturavalutaen.;
                           ENU=Specifies the total, in the currency of the invoice, of the amounts on all the invoice lines.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                OnDrillDown=BEGIN
                              SETRANGE("No.");
                              PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice",Rec)
                            END;
                             }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede sum af belõbene, herunder moms, pÜ alle dokumentets linjer.;
                           ENU=Specifies the total of the amounts, including VAT, on all the lines on the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Including VAT";
                OnDrillDown=BEGIN
                              SETRANGE("No.");
                              PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice",Rec)
                            END;
                             }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret pÜ den kreditor, der leverede varerne.;
                           ENU=Specifies the post code of the vendor who delivered the items.];
                ApplicationArea=#Advanced;
                SourceExpr="Buy-from Post Code";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
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

    { 137 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the number of the vendor that you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Vendor No.";
                Visible=FALSE }

    { 135 ;2   ;Field     ;
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

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den kontaktperson, du kan kontakte hos den kreditor, du har modtaget fakturaen fra.;
                           ENU=Specifies the name of the person you should contact at the vendor who you received the invoice from.];
                ApplicationArea=#Advanced;
                SourceExpr="Pay-to Contact";
                Visible=FALSE }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
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

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 105 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for bogfõring af kõbshovedet.;
                           ENU=Specifies the date the purchase header was posted.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 73  ;2   ;Field     ;
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
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne er registreret.;
                           ENU=Specifies the code for the location where the items are registered.];
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
                ToolTipML=[DAN=Angiver en formel, der beregner betalingens forfaldsdato, kontantrabatdato og kontantrabatbelõb.;
                           ENU=Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Terms Code";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver, hvornÜr fakturaen er forfalden til betaling. Feltet beregnes automatisk ud fra data i felterne Betalingsbeting.kode og Bilagsdato pÜ kõbshovedet.;
                           ENU=Specifies when the invoice is due. The program calculates the date using the Payment Terms Code and Document Date fields on the purchase header.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date" }

    { 1102601007;2;Field  ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles, hvis betaling gennemfõres fõr eller pÜ den dato, der er angivet i feltet Kont.rabatdato.;
                           ENU=Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Discount %";
                Visible=FALSE }

    { 1102601009;2;Field  ;
                ToolTipML=[DAN=Angiver, hvordan betalingen skal foretages, f.eks. via bankoverfõrsel, kontant eller med check.;
                           ENU=Specifies how to make payment, such as with bank transfer, cash,  or check.];
                ApplicationArea=#Advanced;
                SourceExpr="Payment Method Code";
                Visible=FALSE }

    { 1102601011;2;Field  ;
                ToolTipML=[DAN=Angiver betingelserne for levering af den relaterede leverance, som f.eks. frit ombord (FOB).;
                           ENU=Specifies the delivery conditions of the related shipment, such as free on board (FOB).];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Method Code";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det belõb, der mangler at blive betalt for den bogfõrte kõbsfaktura.;
                           ENU=Specifies the amount that remains to be paid for the posted purchase invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte kõbsfaktura er betalt. Afkrydsningsfeltet markeres ogsÜ, hvis der er oprettet en kreditnota for restbelõbet.;
                           ENU=Specifies if the posted purchase invoice is paid. The check box will also be selected if a credit memo for the remaining amount has been applied.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Closed }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte kõbsfaktura er blevet rettet eller annulleret.;
                           ENU=Specifies if the posted purchase invoice has been either corrected or canceled.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Cancelled;
                Importance=Additional;
                Visible=IsFoundationEnabled;
                HideValue=NOT Cancelled;
                Style=Unfavorable;
                StyleExpr=Cancelled;
                OnDrillDown=BEGIN
                              ShowCorrectiveCreditMemo;
                            END;
                             }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogfõrte kõbsfaktura er et rettelsesbilag.;
                           ENU=Specifies if the posted purchase invoice is a corrective document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Corrective;
                Importance=Additional;
                HideValue=NOT Corrective;
                Style=Unfavorable;
                StyleExpr=Corrective;
                OnDrillDown=BEGIN
                              ShowCancelledCreditMemo;
                            END;
                             }

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

