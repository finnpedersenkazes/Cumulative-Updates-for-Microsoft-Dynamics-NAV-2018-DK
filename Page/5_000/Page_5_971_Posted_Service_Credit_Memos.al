OBJECT Page 5971 Posted Service Credit Memos
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
    CaptionML=[DAN=Bogf�rte servicekreditnotaer;
               ENU=Posted Service Credit Memos];
    SourceTable=Table5994;
    PageType=List;
    CardPageID=Posted Service Credit Memo;
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;
               END;

    OnAfterGetRecord=VAR
                       ServiceCrMemoHeader@1000 : Record 5994;
                     BEGIN
                       DocExchStatusStyle := GetDocExchStatusStyle;

                       ServiceCrMemoHeader.COPYFILTERS(Rec);
                       ServiceCrMemoHeader.SETFILTER("Document Exchange Status",'<>%1',"Document Exchange Status"::"Not Sent");
                       DocExchStatusVisible := NOT ServiceCrMemoHeader.ISEMPTY;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           DocExchStatusStyle := GetDocExchStatusStyle;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 19      ;1   ;ActionGroup;
                      CaptionML=[DAN=Kr&editnota;
                                 ENU=&Cr. Memo];
                      Image=CreditMemo }
      { 31      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om recorden, f.eks. v�rdien af bogf�rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 6034;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 32      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Type=CONST(General),
                                  Table Name=CONST(Service Cr.Memo Header),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 7       ;1   ;Action    ;
                      Name=SendCustom;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Send;
                                 ENU=Send];
                      ToolTipML=[DAN=Klarg�r bilaget til afsendelse i henhold til debitorens afsendelsesprofil, f.eks. vedh�ftet en mail. Vinduet Send dokument til vises, s� du kan bekr�fte eller v�lge en afsendelsesprofil.;
                                 ENU=Prepare to send the document according to the customer's sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=SendToMultiple;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ServCrMemoHeader := Rec;
                                 CurrPage.SETSELECTIONFILTER(ServCrMemoHeader);
                                 ServCrMemoHeader.SendRecords;
                               END;
                                }
      { 20      ;1   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Udskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=G�r dig klar til at udskrive bilaget. Der �bnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages p� udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.SETSELECTIONFILTER(ServCrMemoHeader);
                                 ServCrMemoHeader.PrintRecords(TRUE);
                               END;
                                }
      { 25      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf�ringsdatoen p� den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 5       ;1   ;Action    ;
                      Name=ActivityLog;
                      CaptionML=[DAN=Aktivitetslogfil;
                                 ENU=Activity Log];
                      ToolTipML=[DAN=Se status og eventuelle fejl, hvis dokumentet blev sendt som et elektronisk dokument eller OCR-fil via dokumentudvekslingstjenesten.;
                                 ENU=View the status and any errors if the document was sent as an electronic document or OCR file through the document exchange service.];
                      ApplicationArea=#Service;
                      Image=Log;
                      OnAction=VAR
                                 ActivityLog@1002 : Record 710;
                               BEGIN
                                 ActivityLog.ShowEntries(RECORDID);
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
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, der er tilknyttet kreditnotaen.;
                           ENU=Specifies the number of the customer associated with the credit memo.];
                ApplicationArea=#Service;
                SourceExpr="Customer No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den debitor, som servicen p� kreditnotaen er leveret til.;
                           ENU=Specifies the name of the customer to whom you shipped the service on the credit memo.];
                ApplicationArea=#Service;
                SourceExpr=Name }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for bel�bene p� kreditnotaen.;
                           ENU=Specifies the currency code for the amounts on the credit memo.];
                ApplicationArea=#Service;
                SourceExpr="Currency Code" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret.;
                           ENU=Specifies the postal code.];
                ApplicationArea=#Service;
                SourceExpr="Post Code";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr�de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Service;
                SourceExpr="Country/Region Code";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� kontaktpersonen i debitorens virksomhed.;
                           ENU=Specifies the name of the contact person at the customer company.];
                ApplicationArea=#Service;
                SourceExpr="Contact Name";
                Visible=FALSE }

    { 127 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 125 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Name";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Post Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande/omr�dekoden for debitorens faktureringsadresse.;
                           ENU=Specifies the country/region code of the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Country/Region Code";
                Visible=FALSE }

    { 115 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� kontaktpersonen p� debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Service;
                SourceExpr="Bill-to Contact";
                Visible=FALSE }

    { 111 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogs� i tilf�lde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 109 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� debitoren p� den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret p� den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omr�dekoden p� den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� kontaktpersonen p� den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Service;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 97  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kreditnotaen blev bogf�rt.;
                           ENU=Specifies the date when the credit memo was posted.];
                ApplicationArea=#Service;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s�lger, der er tilknyttet kreditnotaen.;
                           ENU=Specifies the code of the salesperson associated with the credit memo.];
                ApplicationArea=#Service;
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
                ToolTipML=[DAN=Angiver lokationen, eksempelvis lagerstedet eller distributionscenteret, hvor kreditnotaen blev registreret.;
                           ENU=Specifies the location, such as warehouse or distribution center, where the credit memo was registered.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for dokumentet, hvis du bruger en dokumentudvekslingstjeneste til at sende det som et elektronisk dokument. Statusv�rdierne rapporteres af dokumentudvekslingstjenesten.;
                           ENU=Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.];
                ApplicationArea=#Service;
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

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      ServCrMemoHeader@1000 : Record 5994;
      DocExchStatusStyle@1001 : Text;
      DocExchStatusVisible@1002 : Boolean;

    BEGIN
    END.
  }
}

