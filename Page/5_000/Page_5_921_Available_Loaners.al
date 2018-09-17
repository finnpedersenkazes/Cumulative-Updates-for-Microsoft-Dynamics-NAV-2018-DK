OBJECT Page 5921 Available Loaners
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Tilg‘ngelige udl†nsvarer;
               ENU=Available Loaners];
    SourceTable=Table5913;
    PageType=List;
    OnOpenPage=BEGIN
                 SETRANGE(Blocked,FALSE);
                 SETRANGE(Lent,FALSE);
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dl†nsvare;
                                 ENU=L&oaner];
                      Image=Loaners }
      { 22      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den p†g‘ldende record p† bilaget eller kladdelinjen.;
                                 ENU=View or change detailed information about the record on the document or journal line.];
                      ApplicationArea=#Service;
                      RunObject=Page 5922;
                      RunPageLink=No.=FIELD(No.);
                      Image=EditLines }
      { 23      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Dimensions;
                      RunObject=Page 5911;
                      RunPageLink=Table Name=CONST(Loaner),
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
                                 LoanerEntry@1001 : Record 5914;
                                 ServItemLine@1002 : Record 5901;
                                 ServLoanerMgt@1003 : Codeunit 5901;
                               BEGIN
                                 IF Lent THEN  BEGIN
                                   CLEAR(LoanerEntry);
                                   LoanerEntry.SETCURRENTKEY("Document Type","Document No.","Loaner No.",Lent);
                                   LoanerEntry.SETRANGE("Document Type","Document Type");
                                   LoanerEntry.SETRANGE("Document No.","Document No.");
                                   LoanerEntry.SETRANGE("Loaner No.","No.");
                                   LoanerEntry.SETRANGE(Lent,TRUE);
                                   IF LoanerEntry.FINDFIRST THEN BEGIN
                                     ServItemLine.GET(LoanerEntry."Document Type" - 1,LoanerEntry."Document No.",LoanerEntry."Service Item Line No.");
                                     ServLoanerMgt.ReceiveLoaner(ServItemLine);
                                   END;
                                 END ELSE
                                   ERROR(Text000,TABLECAPTION,"No.");
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
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Service;
                SourceExpr="No." }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret p† udl†nsvaren for serviceartiklen.;
                           ENU=Specifies the serial number for the loaner for the service item.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af udl†nsvaren.;
                           ENU=Specifies a description of the loaner.];
                ApplicationArea=#Service;
                SourceExpr=Description }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der er en bem‘rkning for denne udl†nsvare.;
                           ENU=Specifies that there is a comment for this loaner.];
                ApplicationArea=#Service;
                SourceExpr=Comment }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf›res under transaktioner - eksempelvis en debitor, som er erkl‘ret insolvent, eller en vare, som er sat i karant‘ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Service;
                SourceExpr=Blocked }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at udl†nsvaren er l†nt ud til en debitor.;
                           ENU=Specifies that the loaner has been lent to a customer.];
                ApplicationArea=#Service;
                SourceExpr=Lent }

    { 27  ;2   ;Field     ;
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
    VAR
      Text000@1000 : TextConst '@@@=You cannot receive Loaner L00001 because it has not been lent.;DAN=Du kan ikke modtage %1 %2, fordi det ikke har v‘ret udl†nt.;ENU=You cannot receive %1 %2 because it has not been lent.';

    BEGIN
    END.
  }
}

