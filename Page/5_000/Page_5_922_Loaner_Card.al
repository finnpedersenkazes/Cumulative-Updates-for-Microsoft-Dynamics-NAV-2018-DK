OBJECT Page 5922 Loaner Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udl†nsvarekort;
               ENU=Loaner Card];
    SourceTable=Table5913;
    PageType=Card;
    RefreshOnActivate=Yes;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dl†nsvare;
                                 ENU=L&oaner];
                      Image=Loaners }
      { 22      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Service;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Loaner),
                                  Table Subtype=CONST(0),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 23      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Udl†nsvarepo&ster;
                                 ENU=Loaner E&ntries];
                      ToolTipML=[DAN=Vis udl†nsvarens historik.;
                                 ENU=View the history of the loaner.];
                      ApplicationArea=#Service;
                      RunObject=Page 5924;
                      RunPageView=SORTING(Loaner No.)
                                  ORDER(Ascending);
                      RunPageLink=Loaner No.=FIELD(No.);
                      Image=Entries }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 56      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=&Modtag;
                                 ENU=&Receive];
                      ToolTipML=[DAN=Registrer, at udl†nsvaren er modtaget p† din virksomhed.;
                                 ENU=Record that the loaner is received at your company.];
                      ApplicationArea=#Service;
                      Promoted=Yes;
                      Image=ReceiveLoaner;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ServLoanerMgt@1003 : Codeunit 5901;
                               BEGIN
                                 ServLoanerMgt.Receive(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No.";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af udl†nsvaren.;
                           ENU=Specifies a description of the loaner.];
                ApplicationArea=#Service;
                SourceExpr=Description;
                Importance=Promoted }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende beskrivelse af udl†nsvaren.;
                           ENU=Specifies an additional description of the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Description 2" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhedsprisen p† udl†nsvaren.;
                           ENU=Specifies the unit price of the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Item No." }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p† udl†nsvaren for serviceartiklen.;
                           ENU=Specifies the serial number for the loaner for the service item.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Service;
                SourceExpr="Unit of Measure Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at udl†nsvaren er l†nt ud til en debitor.;
                           ENU=Specifies that the loaner has been lent to a customer.];
                ApplicationArea=#Service;
                SourceExpr=Lent }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dokumenttypen for udl†nsvareposten.;
                           ENU=Specifies the document type of the loaner entry.];
                ApplicationArea=#Service;
                SourceExpr="Document Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det servicedokument, som udl†nsvaren blev l†nt ud for.;
                           ENU=Specifies the number of the service document for the service item that was lent.];
                ApplicationArea=#Service;
                SourceExpr="Document No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Service;
                SourceExpr=Blocked }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor udl†nsvarekortet sidst blev ‘ndret.;
                           ENU=Specifies the date when the loaner card was last modified.];
                ApplicationArea=#Service;
                SourceExpr="Last Date Modified" }

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

    BEGIN
    END.
  }
}

