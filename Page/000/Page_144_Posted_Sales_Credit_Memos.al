OBJECT Page 144 Posted Sales Credit Memos
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846,NAVDK11.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Bogf. salgskr.notaer;
               ENU=Posted Sales Credit Memos];
    SourceTable=Table114;
    SourceTableView=SORTING(Posting Date)
                    ORDER(Descending);
    PageType=List;
    CardPageID=Posted Sales Credit Memo;
    PromotedActionCategoriesML=[DAN=Ny,Proces,Rapport,Kreditnota,Annuller;
                                ENU=New,Process,Report,Credit Memo,Cancel];
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

    OnAfterGetRecord=VAR
                       SalesCrMemoHeader@1000 : Record 114;
                     BEGIN
                       DocExchStatusStyle := GetDocExchStatusStyle;

                       SalesCrMemoHeader.COPYFILTERS(Rec);
                       SalesCrMemoHeader.SETFILTER("Document Exchange Status",'<>%1',"Document Exchange Status"::"Not Sent");
                       DocExchStatusVisible := NOT SalesCrMemoHeader.ISEMPTY;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           DocExchStatusStyle := GetDocExchStatusStyle;
                           CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Kreditnota;
                                 ENU=&Credit Memo];
                      Image=CreditMemo }
      { 26      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=�bn den bogf�rte salgskreditnota.;
                                 ENU=Open the posted sales credit memo.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=EditLines;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 PAGE.RUN(PAGE::"Posted Sales Credit Memo",Rec)
                               END;
                                }
      { 31      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om recorden, f.eks. v�rdien af bogf�rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 398;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Statistics;
                      PromotedCategory=Category4 }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=CONST(Posted Credit Memo),
                                  No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category4 }
      { 1102601000;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Dimensions;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1060000 ;2   ;Separator  }
      { 1060001 ;2   ;Action    ;
                      CaptionML=[DAN=Opret elektronisk kreditnota;
                                 ENU=Create Electronic Credit Memo];
                      ToolTipML=[DAN=Opret en elektronisk version af det aktuelle dokument.;
                                 ENU=Create an electronic version of the current document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ElectronicDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SalesCrMemoHeader@1060001 : Record 114;
                               BEGIN
                                 SalesCrMemoHeader := Rec;
                                 SalesCrMemoHeader.SETRECFILTER;

                                 REPORT.RUNMODAL(REPORT::"Create Electronic Credit Memos",TRUE,FALSE,SalesCrMemoHeader);
                               END;
                                }
      { 10      ;2   ;Action    ;
                      Name=IncomingDoc;
                      AccessByPermission=TableData 130=R;
                      CaptionML=[DAN=Indg�ende bilag;
                                 ENU=Incoming Document];
                      ToolTipML=[DAN=Se eller opret en indg�ende bilagsrecord, som er knyttet til posten eller bilaget.;
                                 ENU=View or create an incoming document record that is linked to the entry or document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Document;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 IncomingDocument@1000 : Record 130;
                               BEGIN
                                 IncomingDocument.ShowCard("No.","Posting Date");
                               END;
                                }
      { 12      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Debitor;
                                 ENU=Customer];
                      ToolTipML=[DAN=F� vist eller rediger detaljerede oplysninger om debitoren.;
                                 ENU=View or edit detailed information about the customer.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 21;
                      RunPageLink=No.=FIELD(Sell-to Customer No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Customer;
                      PromotedCategory=Category4;
                      Scope=Repeater }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf�ringsdatoen p� det valgte bogf�rte salgsdokument.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected posted sales document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=NOT IsOfficeAddin;
                      PromotedIsBig=Yes;
                      Image=Navigate;
                      PromotedCategory=Category4;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 36      ;1   ;ActionGroup;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel] }
      { 28      ;2   ;Action    ;
                      Name=CancelCrMemo;
                      CaptionML=[DAN=Annuller;
                                 ENU=Cancel];
                      ToolTipML=[DAN=Opret og bogf�r en faktura, der tilbagef�rer denne bogf�rte salgskreditnota. Denne bogf�rte salgskreditnota annulleres.;
                                 ENU=Create and post a sales invoice that reverses this posted sales credit memo. This posted sales credit memo will be canceled.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      PromotedIsBig=Yes;
                      Image=Cancel;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Cancel PstdSalesCrM (Yes/No)",Rec);
                               END;
                                }
      { 24      ;2   ;Action    ;
                      Name=ShowInvoice;
                      CaptionML=[DAN=Vis annulleret faktura/rettelsesfaktura;
                                 ENU=Show Canceled/Corrective Invoice];
                      ToolTipML=[DAN=�bn den bogf�rte salgsfaktura, som blev oprettet, da du annullerede den bogf�rte salgskreditnota. Hvis den bogf�rte salgskreditnota er resultatet af en annulleret salgsfaktura, �bnes den annullerede faktura.;
                                 ENU=Open the posted sales invoice that was created when you canceled the posted sales credit memo. If the posted sales credit memo is the result of a canceled sales invoice, then canceled invoice will open.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsFoundationEnabled;
                      Enabled=Cancelled OR Corrective;
                      PromotedIsBig=Yes;
                      Image=Invoice;
                      PromotedCategory=Category5;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ShowCanceledOrCorrInvoice;
                               END;
                                }
      { 98      ;1   ;ActionGroup;
                      CaptionML=[DAN=Send;
                                 ENU=Send] }
      { 5       ;2   ;Action    ;
                      Name=SendCustom;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Send;
                                 ENU=Send];
                      ToolTipML=[DAN=Klarg�r bilaget til afsendelse i henhold til debitorens afsendelsesprofil, f.eks. vedh�ftet en mail. Vinduet Send dokument til vises, s� du kan bekr�fte eller v�lge en afsendelsesprofil.;
                                 ENU=Prepare to send the document according to the customer's sending profile, such as attached to an email. The Send document to window opens where you can confirm or select a sending profile.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendToMultiple;
                      PromotedCategory=Process;
                      Scope=Repeater;
                      OnAction=VAR
                                 SalesCrMemoHeader@1000 : Record 114;
                               BEGIN
                                 SalesCrMemoHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
                                 SalesCrMemoHeader.SendRecords;
                               END;
                                }
      { 20      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du f�r vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsOfficeAddin;
                      Image=Print;
                      Scope=Repeater;
                      OnAction=VAR
                                 SalesCrMemoHeader@1102 : Record 114;
                               BEGIN
                                 SalesCrMemoHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
                                 SalesCrMemoHeader.PrintRecords(TRUE);
                               END;
                                }
      { 3       ;2   ;Action    ;
                      CaptionML=[DAN=Send via &mail;
                                 ENU=Send by &Email];
                      ToolTipML=[DAN=Forbered at afsende bilaget via mail. Vinduet Send mail �bnes med debitorens oplysninger, s� du kan tilf�je eller redigere oplysninger, f�r du sender mailen.;
                                 ENU=Prepare to send the document by email. The Send Email window opens prefilled for the customer where you can add or change information before you send the email.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Email;
                      Scope=Repeater;
                      OnAction=VAR
                                 SalesCrMemoHeader@1000 : Record 114;
                               BEGIN
                                 SalesCrMemoHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
                                 SalesCrMemoHeader.EmailRecords(TRUE);
                               END;
                                }
      { 9       ;1   ;Action    ;
                      Name=ActivityLog;
                      CaptionML=[DAN=Aktivitetslogfil;
                                 ENU=Activity Log];
                      ToolTipML=[DAN=Se status og eventuelle fejl, hvis dokumentet blev sendt som et elektronisk dokument eller OCR-fil via dokumentudvekslingstjenesten.;
                                 ENU=View the status and any errors if the document was sent as an electronic document or OCR file through the document exchange service.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Log;
                      OnAction=BEGIN
                                 ShowActivityLog;
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer No." }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Debitornavn;
                           ENU=Customer Name];
                ToolTipML=[DAN=Angiver navnet p� den debitor, som varerne i kreditnotaen er leveret til.;
                           ENU=Specifies the name of the customer that you shipped the items on the credit memo to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sell-to Customer Name" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for kreditnotaen.;
                           ENU=Specifies the currency code of the credit memo.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor leverancen forfalder til betaling.;
                           ENU=Specifies the date on which the shipment is due for payment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due Date" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede bel�b i alle kreditnotalinjerne. Bel�bet er angivet i kreditnotaens valuta. Bel�bet er uden moms.;
                           ENU=Specifies the total of the amounts on all the credit memo lines, in the currency of the credit memo. The amount does not include VAT.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount;
                OnDrillDown=BEGIN
                              SETRANGE("No.");
                              PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memo",Rec)
                            END;
                             }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede sum af bel�bene, herunder moms, p� alle dokumentets linjer.;
                           ENU=Specifies the total of the amounts, including VAT, on all the lines on the document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Amount Including VAT";
                OnDrillDown=BEGIN
                              SETRANGE("No.");
                              PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memo",Rec)
                            END;
                             }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel�b, der mangler at blive betalt for den bogf�rte salgsfaktura.;
                           ENU=Specifies the amount that remains to be paid for the posted sales invoice.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Remaining Amount" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogf�rte salgsfaktura, der vedr�rer denne salgskreditnota, er betalt.;
                           ENU=Specifies if the posted sales invoice that relates to this sales credit memo is paid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Paid }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogf�rte salgsfaktura, der vedr�rer denne salgskreditnota, er rettet eller annulleret.;
                           ENU=Specifies if the posted sales invoice that relates to this sales credit memo has been either corrected or canceled.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Cancelled;
                HideValue=NOT Cancelled;
                Style=Unfavorable;
                StyleExpr=Cancelled;
                OnDrillDown=BEGIN
                              ShowCorrectiveInvoice;
                            END;
                             }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogf�rte salgsfaktura er rettet eller annulleret af denne salgskreditnota.;
                           ENU=Specifies if the posted sales invoice has been either corrected or canceled by this sales credit memo.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Corrective;
                HideValue=NOT Corrective;
                Style=Unfavorable;
                StyleExpr=Corrective;
                OnDrillDown=BEGIN
                              ShowCancelledInvoice;
                            END;
                             }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens prim�re adresse.;
                           ENU=Specifies the postal code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Post Code";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omr�dekoden for debitorens prim�re adresse.;
                           ENU=Specifies the country/region code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Country/Region Code";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� kontaktpersonen p� debitorens prim�re adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact";
                Visible=FALSE }

    { 127 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Name";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Post Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omr�dekoden for debitorens faktureringsadresse.;
                           ENU=Specifies the country/region code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Country/Region Code";
                Visible=FALSE }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� kontaktpersonen p� debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact";
                Visible=FALSE }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs� i tilf�lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� debitoren p� den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p� den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omr�dekoden p� den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� kontaktpersonen p� den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kreditnotaen blev bogf�rt.;
                           ENU=Specifies the date when the credit memo was posted.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken s�lger der er tilknyttet kreditnotaen.;
                           ENU=Specifies which salesperson is associated with the credit memo.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code";
                Visible=FALSE }

    { 89  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 87  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 91  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken lokation kreditnotaen er registreret p�.;
                           ENU=Specifies the location where the credit memo was registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange bilaget er blevet udskrevet.;
                           ENU=Specifies how many times the document has been printed.];
                ApplicationArea=#Advanced;
                SourceExpr="No. Printed" }

    { 1102601003;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Date";
                Visible=FALSE }

    { 1102601005;2;Field  ;
                ToolTipML=[DAN=Angiver den type bogf�rt bilag, som dette bilag eller denne kladdelinje udlignes med, n�r du bogf�rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#Advanced;
                SourceExpr="Applies-to Doc. Type";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for dokumentet, hvis du bruger en dokumentudvekslingstjeneste til at sende det som et elektronisk dokument. Statusv�rdierne rapporteres af dokumentudvekslingstjenesten.;
                           ENU=Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Exchange Status";
                Visible=DocExchStatusVisible;
                StyleExpr=DocExchStatusStyle;
                OnDrillDown=VAR
                              DocExchServDocStatus@1000 : Codeunit 1420;
                            BEGIN
                              DocExchServDocStatus.DocExchStatusDrillDown(Rec);
                            END;
                             }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 7   ;1   ;Part      ;
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
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ApplicationAreaSetup@1002 : Record 9178;
      DocExchStatusStyle@1111 : Text;
      DocExchStatusVisible@1000 : Boolean;
      IsOfficeAddin@1001 : Boolean;
      IsFoundationEnabled@1003 : Boolean;

    BEGIN
    END.
  }
}

