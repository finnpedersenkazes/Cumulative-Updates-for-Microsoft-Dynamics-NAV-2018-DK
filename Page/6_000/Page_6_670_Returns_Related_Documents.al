OBJECT Page 6670 Returns-Related Documents
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Returrelaterede dokumenter;
               ENU=Returns-Related Documents];
    SourceTable=Table6670;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 10      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#SalesReturnOrder;
                      Image=EditLines;
                      OnAction=VAR
                                 SalesHeader@1001 : Record 36;
                                 PurchHeader@1000 : Record 38;
                               BEGIN
                                 CLEAR(CopyDocMgt);
                                 CASE "Document Type" OF
                                   "Document Type"::"Sales Order":
                                     SalesHeader.GET(SalesHeader."Document Type"::Order,"No.");
                                   "Document Type"::"Sales Invoice":
                                     SalesHeader.GET(SalesHeader."Document Type"::Invoice,"No.");
                                   "Document Type"::"Sales Return Order":
                                     SalesHeader.GET(SalesHeader."Document Type"::"Return Order","No.");
                                   "Document Type"::"Sales Credit Memo":
                                     SalesHeader.GET(SalesHeader."Document Type"::"Credit Memo","No.");
                                   "Document Type"::"Purchase Order":
                                     PurchHeader.GET(PurchHeader."Document Type"::Order,"No.");
                                   "Document Type"::"Purchase Invoice":
                                     PurchHeader.GET(PurchHeader."Document Type"::Invoice,"No.");
                                   "Document Type"::"Purchase Return Order":
                                     PurchHeader.GET(PurchHeader."Document Type"::"Return Order","No.");
                                   "Document Type"::"Purchase Credit Memo":
                                     PurchHeader.GET(PurchHeader."Document Type"::"Credit Memo","No.");
                                 END;

                                 IF "Document Type" IN ["Document Type"::"Sales Order".."Document Type"::"Sales Credit Memo"] THEN
                                   CopyDocMgt.ShowSalesDoc(SalesHeader)
                                 ELSE
                                   CopyDocMgt.ShowPurchDoc(PurchHeader);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver type af det relaterede bilag.;
                           ENU=Specifies the type of the related document.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="Document Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#SalesReturnOrder;
                SourceExpr="No." }

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
      CopyDocMgt@1000 : Codeunit 6620;

    BEGIN
    END.
  }
}

