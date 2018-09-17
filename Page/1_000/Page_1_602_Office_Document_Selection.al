OBJECT Page 1602 Office Document Selection
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
    CaptionML=[DAN=Valg af bilag;
               ENU=Document Selection];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table1620;
    PageType=List;
    SourceTableTemporary=Yes;
    ActionList=ACTIONS
    {
      { 8       ;    ;ActionContainer;
                      Name=ViewAction;
                      ActionContainerType=RelatedInformation }
      { 9       ;1   ;Action    ;
                      Name=View Document;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Vis bilag;
                                 ENU=View Document];
                      ToolTipML=[DAN=Se det valgte bilag.;
                                 ENU=View the selected document.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ViewOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 TempOfficeAddinContext@1002 : TEMPORARY Record 1600;
                                 OfficeMgt@1000 : Codeunit 1630;
                                 OfficeDocumentHandler@1001 : Codeunit 1637;
                               BEGIN
                                 OfficeMgt.GetContext(TempOfficeAddinContext);
                                 OfficeDocumentHandler.OpenIndividualDocument(TempOfficeAddinContext,Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken bilagstype posten tilh›rer.;
                           ENU=Specifies the document type that the entry belongs to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Type" }

    { 3   ;2   ;Field     ;
                Lookup=Yes;
                ToolTipML=[DAN=Angiver nummeret p† det relevante bilag.;
                           ENU=Specifies the number of the involved document.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serien for det relevante bilag, f.eks. K›b eller Salg.;
                           ENU=Specifies the series of the involved document, such as Purchasing or Sales.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Series }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om det relevante bilag er blevet bogf›rt.;
                           ENU=Specifies whether the involved document has been posted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Posted }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor det relaterede bilag blev oprettet.;
                           ENU=Specifies the date when the related document was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Document Date" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

