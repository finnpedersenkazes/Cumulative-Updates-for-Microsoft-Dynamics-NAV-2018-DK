OBJECT Page 9600 XML Schemas
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=XML-skemaer;
               ENU=XML Schemas];
    SourceTable=Table9600;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Vis;
                                ENU=New,Process,Report,Show];
    OnOpenPage=BEGIN
                 SETRANGE(Indentation,0);
               END;

    ActionList=ACTIONS
    {
      { 10      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=Indlës skema;
                                 ENU=Load Schema];
                      ToolTipML=[DAN=Indlës et XML-skema til databasen.;
                                 ENU=Load an XML schema into the database.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Import;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 LoadSchema;
                               END;
                                }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=EksportÇr skema;
                                 ENU=Export Schema];
                      ToolTipML=[DAN=EksportÇr et XML-skema til en fil.;
                                 ENU=Export an XML schema to a file.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Export;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ExportSchema(TRUE);
                               END;
                                }
      { 13      ;1   ;Action    ;
                      CaptionML=[DAN=èbn skemafremviser;
                                 ENU=Open Schema Viewer];
                      ToolTipML=[DAN=Vis XML-skemaet for en fil, som du vil oprette en XMLport eller en dataudvekslingsdefinition for, sÜ brugerne kan importere/eksportere data til eller fra den pÜgëldende fil.;
                                 ENU=View the XML schema of a file for which you want to create an XMLport or a data exchange definition so that users can import/export data to or from the file in question.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ViewWorksheet;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 XMLSchemaViewer@1000 : Page 9610;
                               BEGIN
                                 XMLSchemaViewer.SetXMLSchemaCode(Code);
                                 XMLSchemaViewer.RUN;
                               END;
                                }
      { 14      ;1   ;Action    ;
                      CaptionML=[DAN=Udvid alle;
                                 ENU=Expand All];
                      ToolTipML=[DAN=Udvid alle elementer.;
                                 ENU=Expand all elements.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ExpandAll;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 SETRANGE(Indentation);
                               END;
                                }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Skjul alle;
                                 ENU=Collapse All];
                      ToolTipML=[DAN=Skjul alle elementer.;
                                 ENU=Collapse all elements.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CollapseAll;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 SETRANGE(Indentation,0);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                IndentationColumnName=Indentation;
                IndentationControls=Code;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for XML-skemaet.;
                           ENU=Specifies a code for the XML schema.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den XML-skemafil, der er indlëst for linjen.;
                           ENU=Specifies the description of the XML schema file that has been loaded for the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navneomrÜdet for den XML-skemafil, der er indlëst for linjen.;
                           ENU=Specifies the namespace of the XML schema file that has been loaded for the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Target Namespace" }

    { 9   ;2   ;Field     ;
                CaptionML=[DAN=Skema er indlëst;
                           ENU=Schema is Loaded];
                ToolTipML=[DAN=Angiver, at en XML-skemafil er indlëst for linjen.;
                           ENU=Specifies that an XML schema file has been loaded for the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=XSD.HASVALUE }

    { 6   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 7   ;1   ;Part      ;
                PartType=System;
                SystemPartID=Notes }

    { 8   ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

  }
  CODE
  {

    BEGIN
    END.
  }
}

