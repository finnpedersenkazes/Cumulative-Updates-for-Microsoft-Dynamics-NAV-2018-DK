OBJECT Page 2103 O365 Sales Document List
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
    CaptionML=[DAN=Fakturaliste;
               ENU=Invoice List];
    DeleteAllowed=No;
    SourceTable=Table2103;
    SourceTableView=SORTING(Sell-to Customer Name);
    PageType=ListPart;
    SourceTableTemporary=Yes;
    RefreshOnActivate=Yes;
    OnInit=BEGIN
             SetSortByDocDate;
           END;

    OnFindRecord=BEGIN
                   EXIT(OnFind(Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(OnNext(Steps));
                 END;

    OnAfterGetRecord=VAR
                       O365SalesManagement@1000 : Codeunit 2107;
                     BEGIN
                       OutStandingStatusStyle := '';
                       TotalInvoicedStyle := '';

                       O365SalesManagement.GetO365DocumentBrickStyle(Rec,OutStandingStatusStyle,TotalInvoicedStyle);
                     END;

    ActionList=ACTIONS
    {
      { 16      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 17      ;1   ;Action    ;
                      Name=ShowLatest;
                      CaptionML=[DAN=Vis alle fakturaer;
                                 ENU=Show all invoices];
                      ToolTipML=[DAN=Viser alle fakturaer, sorteret efter deres fakturadato.;
                                 ENU=Show all invoices, sorted by their invoice date.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=NOT HideActions;
                      OnAction=BEGIN
                                 SETRANGE(Posted);
                                 SETRANGE("Outstanding Amount");

                                 SetSortByDocDate;
                               END;
                                }
      { 18      ;1   ;Action    ;
                      Name=ShowUnpaid;
                      CaptionML=[DAN=Vis kun ubetalte fakturaer;
                                 ENU=Show only unpaid invoices];
                      ToolTipML=[DAN=Viser fakturaer, der endnu ikke er blevet betalt fuldt ud, sorteret efter forfaldsdatoen.;
                                 ENU=Displays invoices that have not yet been paid in full, sorted by the due date.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=NOT HideActions;
                      Image=Invoicing-Mail;
                      OnAction=BEGIN
                                 SETRANGE(Posted,TRUE);
                                 SETFILTER("Outstanding Amount",'>0');

                                 SetSortByDueDate;

                                 // go to "most late" document
                                 FindPostedDocument('-');
                                 CurrPage.UPDATE;
                               END;
                                }
      { 19      ;1   ;Action    ;
                      Name=ShowDraft;
                      CaptionML=[DAN=Vis kun kladdefakturaer;
                                 ENU=Show only draft invoices];
                      ToolTipML=[DAN=Viser kladdefakturaer og estimater;
                                 ENU=Displays draft invoices and estimates];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=NOT HideActions;
                      Image=Invoicing-Document;
                      OnAction=BEGIN
                                 SETRANGE(Posted,FALSE);
                                 SETRANGE("Outstanding Amount");

                                 SetSortByDocDate;
                               END;
                                }
      { 24      ;1   ;Action    ;
                      Name=ShowSent;
                      CaptionML=[DAN=Vis kun sendte fakturaer;
                                 ENU=Show only sent invoices];
                      ToolTipML=[DAN=Viser sendte fakturaer, sorteret efter fakturadatoen.;
                                 ENU=Displays invoices that are sent, sorted by the invoice date.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=NOT HideActions;
                      Image=Invoicing-Send;
                      OnAction=BEGIN
                                 SETRANGE(Posted,TRUE);
                                 SETRANGE("Outstanding Amount");

                                 SetSortByDocDate;
                               END;
                                }
      { 20      ;1   ;Action    ;
                      Name=Open;
                      ShortCutKey=Return;
                      CaptionML=[DAN=èbn;
                                 ENU=Open];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=FALSE;
                      Image=DocumentEdit;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 OpenInvoice;
                               END;
                                }
      { 28      ;1   ;Action    ;
                      Name=Post;
                      CaptionML=[DAN=Send;
                                 ENU=Send];
                      ToolTipML=;
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      Visible=NOT HideActions;
                      PromotedIsBig=Yes;
                      Image=PostSendTo;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=VAR
                                 O365SendResendInvoice@1003 : Codeunit 2104;
                               BEGIN
                                 O365SendResendInvoice.SendOrResendSalesDocument(Rec);
                               END;

                      Gesture=LeftSwipe }
      { 30      ;1   ;Action    ;
                      Name=_NEW_TEMP_;
                      CaptionML=[DAN=Nyt;
                                 ENU=New];
                      ToolTipML=[DAN=Opret en ny faktura.;
                                 ENU=Create a new Invoice.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Visible=NOT HideActions;
                      Image=New;
                      OnAction=VAR
                                 O365SalesDocument@1000 : Record 2103;
                               BEGIN
                                 O365SalesDocument.CreateDocument(PAGE::"O365 Sales Invoice",O365SalesDocument."Document Type"::Invoice);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagets type.;
                           ENU=Specifies the type of the document.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Document Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Sell-to Customer No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Sell-to Customer Name" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ debitorens primëre adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Sell-to Contact" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Document Date" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutaen for belõbene i salgsdokumentet.;
                           ENU=Specifies the currency of amounts on the sales document.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Currency Code" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver valutaen med dens symbol, f.eks. ? for Euro. ";
                           ENU="Specifies the currency with its symbol, such as $ for Dollar. "];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Currency Symbol" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om dokumentet er bogfõrt.;
                           ENU=Specifies if the document is posted.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Posted }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for dokumentet, f.eks. Frigivet eller èben.;
                           ENU=Specifies the status of the document, such as Released or Open.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Document Status" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede fakturerede belõb.;
                           ENU=Specifies the total invoiced amount.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Total Invoiced Amount";
                StyleExpr=TotalInvoicedStyle }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udestÜende belõb, dvs. det belõb, der ikke er betalt.;
                           ENU=Specifies the outstanding amount, meaning the amount not paid.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Outstanding Status";
                StyleExpr=OutStandingStatusStyle }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det visuelle id for bilagsformatet.;
                           ENU=Specifies the visual identifier of the document format.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Document Icon" }

    { 21  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Display No." }

  }
  CODE
  {
    VAR
      OutStandingStatusStyle@1005 : Text[30];
      TotalInvoicedStyle@1000 : Text;
      HideActions@1001 : Boolean;

    PROCEDURE SetHideActions@1(NewHideActions@1000 : Boolean);
    BEGIN
      HideActions := NewHideActions;
    END;

    BEGIN
    {
      NB! The name of the 'New' action has to be "_NEW_TEMP_" in order for the phone client to show the '+' sign in the list.
    }
    END.
  }
}

