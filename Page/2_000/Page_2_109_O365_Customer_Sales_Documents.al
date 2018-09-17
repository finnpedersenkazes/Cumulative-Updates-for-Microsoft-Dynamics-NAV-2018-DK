OBJECT Page 2109 O365 Customer Sales Documents
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
    CaptionML=[DAN=Fakturaer til debitor;
               ENU=Invoices for Customer];
    SourceTable=Table2103;
    SourceTableView=SORTING(Sell-to Customer Name);
    PageType=List;
    SourceTableTemporary=Yes;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 // Check if document type is filtered to quotes - used for visibility of the New action
                 QuotesOnly := STRPOS(GETFILTER("Document Type"),FORMAT("Document Type"::Quote)) > 0;
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
                       O365SalesManagement.GetO365DocumentBrickStyle(Rec,OutStandingStatusStyle,TotalInvoicedStyle);
                     END;

    ActionList=ACTIONS
    {
      { 16      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 17      ;1   ;Action    ;
                      Name=View;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=èbn kortet for den valgte record.;
                                 ENU=Open the card for the selected record.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Image=DocumentEdit;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 OpenInvoice;
                               END;
                                }
      { 19      ;1   ;Action    ;
                      Name=Post;
                      CaptionML=[DAN=Send;
                                 ENU=Send];
                      ToolTipML=;
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
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
      { 18      ;1   ;Action    ;
                      Name=_NEW_TEMP_ESTIMATE;
                      CaptionML=[DAN=Nyt;
                                 ENU=New];
                      ToolTipML=[DAN=Opret et nyt estimat.;
                                 ENU=Create a new estimate.];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      Visible=QuotesOnly AND NOT DisplayFailedMode;
                      Image=New;
                      OnAction=VAR
                                 O365SalesDocument@1000 : Record 2103;
                               BEGIN
                                 O365SalesDocument.CreateDocument(PAGE::"O365 Sales Quote",O365SalesDocument."Document Type"::Quote);
                               END;
                                }
      { 21      ;1   ;Action    ;
                      Name=_NEW_TEMP_DRAFT;
                      CaptionML=[DAN=Ny;
                                 ENU=New];
                      ToolTipML=[DAN=Opret en ny faktura;
                                 ENU=Create a new Invoice];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      Visible=NOT DisplayFailedMode AND NOT QuotesOnly;
                      Image=New;
                      OnAction=VAR
                                 O365SalesDocument@1000 : Record 2103;
                               BEGIN
                                 O365SalesDocument.CreateDocument(PAGE::"O365 Sales Invoice",O365SalesDocument."Document Type"::Invoice);
                               END;
                                }
      { 22      ;1   ;Action    ;
                      Name=Clear;
                      CaptionML=[DAN=Ryd;
                                 ENU=Clear];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      Visible=DisplayFailedMode;
                      PromotedIsBig=Yes;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=VAR
                                 O365DocumentSendMgt@1000 : Codeunit 2158;
                               BEGIN
                                 O365DocumentSendMgt.SetDocumentNotificationToCleared("No.",Posted,"Document Type");
                                 CurrPage.UPDATE(TRUE);
                               END;

                      Gesture=RightSwipe }
      { 23      ;1   ;Action    ;
                      Name=ClearAll;
                      CaptionML=[DAN=Ryd alle;
                                 ENU=Clear all];
                      ApplicationArea=#Basic,#Suite,#Invoicing;
                      Promoted=Yes;
                      Visible=DisplayFailedMode;
                      PromotedIsBig=Yes;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      Scope=Page;
                      OnAction=VAR
                                 O365DocumentSendMgt@1000 : Codeunit 2158;
                               BEGIN
                                 O365DocumentSendMgt.SetAllDocumentsNotificationsToCleared;
                                 CurrPage.UPDATE(TRUE);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 15  ;1   ;Group     ;
                GroupType=Repeater }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagstypen.;
                           ENU=Specifies the type of the document.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Document Type" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="No." }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ debitoren.;
                           ENU=Specifies the number of the customer.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Sell-to Customer No." }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ debitoren.;
                           ENU=Specifies the name of the customer.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Sell-to Customer Name" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen pÜ debitorens primëre adresse.;
                           ENU=Specifies the name of the contact person at the customer's main address.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Sell-to Contact" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Document Date" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutaen for belõbene i salgsbilaget.;
                           ENU=Specifies the currency of amounts on the sales document.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Currency Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver valutaen med dens symbol, f.eks. ? for Euro. ";
                           ENU="Specifies the currency with its symbol, such as $ for Dollar. "];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Currency Symbol" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om dokumentet er bogfõrt.;
                           ENU=Specifies if the document is posted.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr=Posted }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for dokumentet, f.eks. Frigivet eller èben.;
                           ENU=Specifies the status of the document, such as Released or Open.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Document Status" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede fakturerede belõb, vist i tilstanden "Mursten".;
                           ENU=Specifies the total invoices amount, displayed in Brick view.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Total Invoiced Amount";
                StyleExpr=TotalInvoicedStyle }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udestÜende belõb (altsÜ det belõb, der ikke er betalt), vist i tilstanden "Mursten".;
                           ENU=Specifies the outstanding amount, meaning the amount not paid, displayed in Brick view.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Outstanding Status";
                StyleExpr=OutStandingStatusStyle }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det visuelle id for bilagsformatet.;
                           ENU=Specifies the visual identifier of the document format.];
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Document Icon" }

    { 20  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite,#Invoicing;
                SourceExpr="Display No." }

  }
  CODE
  {
    VAR
      OutStandingStatusStyle@1001 : Text[30];
      TotalInvoicedStyle@1000 : Text;
      QuotesOnly@1002 : Boolean;
      DisplayFailedMode@1003 : Boolean;

    PROCEDURE SetDisplayFailedMode@2(NewDisplayFailedMode@1000 : Boolean);
    BEGIN
      DisplayFailedMode := NewDisplayFailedMode;
    END;

    BEGIN
    END.
  }
}

