OBJECT Page 5923 Loaner List
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
    CaptionML=[DAN=Udl†nsvareoversigt;
               ENU=Loaner List];
    SourceTable=Table5913;
    PageType=List;
    CardPageID=Loaner Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dl†nsvare;
                                 ENU=L&oaner];
                      Image=Loaners }
      { 23      ;2   ;Action    ;
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
      { 24      ;2   ;Action    ;
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
      { 1900000005;0 ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1906302005;1 ;Action    ;
                      CaptionML=[DAN=Ny serviceordre;
                                 ENU=New Service Order];
                      ToolTipML=[DAN="Opret en ordre for bestemt servicearbejde, der skal udf›res p† en kundes vare. ";
                                 ENU="Create an order for specific service work to be performed on a customer's item. "];
                      ApplicationArea=#Service;
                      RunObject=Page 5900;
                      Promoted=Yes;
                      Image=Document;
                      PromotedCategory=New;
                      RunPageMode=Create }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=Modtag;
                                 ENU=Receive];
                      ToolTipML=[DAN=Registrer, at en udl†nsvare er modtaget fra servicedebitoren.;
                                 ENU=Register that a loaner has been received back from the service customer.];
                      ApplicationArea=#Service;
                      Image=ReceiveLoaner;
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af udl†nsvaren.;
                           ENU=Specifies a description of the loaner.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende beskrivelse af udl†nsvaren.;
                           ENU=Specifies an additional description of the loaner.];
                ApplicationArea=#Service;
                SourceExpr="Description 2" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at udl†nsvaren er l†nt ud til en debitor.;
                           ENU=Specifies that the loaner has been lent to a customer.];
                ApplicationArea=#Service;
                SourceExpr=Lent }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dokumenttypen for udl†nsvareposten.;
                           ENU=Specifies the document type of the loaner entry.];
                ApplicationArea=#Service;
                SourceExpr="Document Type" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det servicedokument, som udl†nsvaren blev l†nt ud for.;
                           ENU=Specifies the number of the service document for the service item that was lent.];
                ApplicationArea=#Service;
                SourceExpr="Document No." }

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

