OBJECT Page 9303 Blanket Sales Orders
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
    CaptionML=[DAN=Rammesalgsordrer;
               ENU=Blanket Sales Orders];
    SourceTable=Table36;
    SourceTableView=WHERE(Document Type=CONST(Blanket Order));
    DataCaptionFields=Sell-to Customer No.;
    PageType=List;
    CardPageID=Blanket Sales Order;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Anmod om godkendelse;
                                ENU=New,Process,Report,Request Approval];
    OnOpenPage=BEGIN
                 SetSecurityFilterOnRespCenter;

                 CopySellToCustomerFilter;
               END;

    OnAfterGetCurrRecord=BEGIN
                           SetControlAppearance;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601015;1 ;ActionGroup;
                      CaptionML=[DAN=&Ordre;
                                 ENU=O&rder];
                      Image=Order }
      { 1102601017;2 ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger som f.eks. vërdien for bogfõrte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 OpenSalesOrderStatistics;
                               END;
                                }
      { 1102601019;2 ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 67;
                      RunPageLink=Document Type=CONST(Blanket Order),
                                  No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 1102601020;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 1102601021;2 ;Action    ;
                      Name=Approvals;
                      AccessByPermission=TableData 454=R;
                      CaptionML=[DAN=Godkendelser;
                                 ENU=Approvals];
                      ToolTipML=[DAN=FÜ vist en liste over records, der afventer godkendelse. Du kan f.eks. se, hvem der har anmodet om godkendelse af recorden, hvornÜr den blev sendt og hvornÜr den skal godkendes.;
                                 ENU=View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.];
                      ApplicationArea=#Advanced;
                      Image=Approvals;
                      OnAction=VAR
                                 WorkflowsEntriesBuffer@1000 : Record 832;
                               BEGIN
                                 WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RECORDID,DATABASE::"Sales Header","Document Type","No.");
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 1102601013;2 ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=&Frigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Advanced;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 ReleaseSalesDoc@1000 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualRelease(Rec);
                               END;
                                }
      { 1102601014;2 ;Action    ;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn dokumentet igen for at ëndre det, efter at det er blevet godkendt. Godkendte dokumenter har status Frigivet og skal Übnes, fõr de kan ëndres;
                                 ENU=Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed];
                      ApplicationArea=#Advanced;
                      Image=ReOpen;
                      OnAction=VAR
                                 ReleaseSalesDoc@1001 : Codeunit 414;
                               BEGIN
                                 ReleaseSalesDoc.PerformManualReopen(Rec);
                               END;
                                }
      { 73      ;1   ;Action    ;
                      CaptionML=[DAN=Lav &ordre;
                                 ENU=Make &Order];
                      ToolTipML=[DAN=Konverter rammesalgsordren til en salgsordre.;
                                 ENU=Convert the blanket sales order to a sales order.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=MakeOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ApprovalsMgmt@1001 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.PrePostApprovalCheckSales(Rec) THEN
                                   CODEUNIT.RUN(CODEUNIT::"Blnkt Sales Ord. to Ord. (Y/N)",Rec);
                               END;
                                }
      { 78      ;1   ;Action    ;
                      Name=Print;
                      Ellipsis=Yes;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Gõr dig klar til at udskrive bilaget. Der Übnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages pÜ udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 DocPrint.PrintSalesHeader(Rec);
                               END;
                                }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Anmod om godkendelse;
                                 ENU=Request Approval] }
      { 1102601010;2 ;Action    ;
                      Name=SendApprovalRequest;
                      CaptionML=[DAN=Send go&dkendelsesanmodning;
                                 ENU=Send A&pproval Request];
                      ToolTipML=[DAN=Anmod om godkendelse af bilaget.;
                                 ENU=Request approval of the document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=NOT OpenApprovalEntriesExist;
                      PromotedIsBig=Yes;
                      Image=SendApprovalRequest;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 IF ApprovalsMgmt.CheckSalesApprovalPossible(Rec) THEN
                                   ApprovalsMgmt.OnSendSalesDocForApproval(Rec);
                               END;
                                }
      { 1102601011;2 ;Action    ;
                      Name=CancelApprovalRequest;
                      CaptionML=[DAN=Annuller godkendelsesan&modning;
                                 ENU=Cancel Approval Re&quest];
                      ToolTipML=[DAN=Annuller godkendelsesanmodningen.;
                                 ENU=Cancel the approval request.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Enabled=CanCancelApprovalForRecord;
                      PromotedIsBig=Yes;
                      Image=CancelApprovalRequest;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ApprovalsMgmt@1000 : Codeunit 1535;
                               BEGIN
                                 ApprovalsMgmt.OnCancelSalesApprovalRequest(Rec);
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
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Customer Name" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Advanced;
                SourceExpr="External Document No." }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens primëre adresse.;
                           ENU=Specifies the postal code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Post Code";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omrÜdekoden for debitorens primëre adresse.;
                           ENU=Specifies the country/region code of the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Country/Region Code";
                Visible=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ debitorens primëre adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#Advanced;
                SourceExpr="Sell-to Contact";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the number of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Customer No.";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som du sender eller har sendt fakturaen eller kreditnotaen til.;
                           ENU=Specifies the name of the customer that you send or sent the invoice or credit memo to.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Name";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret i debitorens faktureringsadresse.;
                           ENU=Specifies the postal code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Post Code";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omrÜdekoden for debitorens faktureringsadresse.;
                           ENU=Specifies the country/region code of the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Country/Region Code";
                Visible=FALSE }

    { 159 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ debitorens faktureringsadresse.;
                           ENU=Specifies the name of the contact person at the customer's billing address.];
                ApplicationArea=#Advanced;
                SourceExpr="Bill-to Contact";
                Visible=FALSE }

    { 155 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for en alternativ leveringsadresse, hvis du vil sende til en anden adresse end den, der er indsat automatisk. Dette felt bruges ogsÜ i tilfëlde af direkte levering.;
                           ENU=Specifies a code for an alternate shipment address if you want to ship to another address than the one that has been entered automatically. This field is also used in case of drop shipment.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Code";
                Visible=FALSE }

    { 153 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the customer at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Name";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the postal code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Post Code";
                Visible=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lande-/omrÜdekoden pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the country/region code of the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Country/Region Code";
                Visible=FALSE }

    { 143 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ den adresse, som varerne leveres til.;
                           ENU=Specifies the name of the contact person at the address that the items are shipped to.];
                ApplicationArea=#Advanced;
                SourceExpr="Ship-to Contact";
                Visible=FALSE }

    { 139 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor bogfõringen af salgsdokumentet skal registreres.;
                           ENU=Specifies the date when the posting of the sales document will be recorded.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date";
                Visible=FALSE }

    { 121 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 119 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Opsëtning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 123 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver placeringen, hvor lagervarer til debitoren pÜ salgsbilaget skal sendes som standard.;
                           ENU=Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 99  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den sëlger, der er tildelt til debitoren.;
                           ENU=Specifies the name of the sales person who is assigned to the customer.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Advanced;
                SourceExpr="Assigned User ID" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutaen for belõbene i salgsdokumentet.;
                           ENU=Specifies the currency of amounts on the sales document.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1902018507;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Bill-to Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9082;
                PartType=Page }

    { 1900316107;1;Part   ;
                ApplicationArea=#Advanced;
                SubPageLink=No.=FIELD(Bill-to Customer No.),
                            Date Filter=FIELD(Date Filter);
                PagePartID=Page9084;
                PartType=Page }

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
      DocPrint@1102601000 : Codeunit 229;
      OpenApprovalEntriesExist@1002 : Boolean;
      CanCancelApprovalForRecord@1000 : Boolean;

    LOCAL PROCEDURE SetControlAppearance@5();
    VAR
      ApprovalsMgmt@1000 : Codeunit 1535;
    BEGIN
      OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);

      CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
    END;

    BEGIN
    END.
  }
}

