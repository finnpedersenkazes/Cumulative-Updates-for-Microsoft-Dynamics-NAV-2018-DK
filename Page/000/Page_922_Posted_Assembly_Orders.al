OBJECT Page 922 Posted Assembly Orders
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
    CaptionML=[DAN=Bogfõrte montageordrer;
               ENU=Posted Assembly Orders];
    SourceTable=Table910;
    DataCaptionFields=No.;
    PageType=List;
    CardPageID=Posted Assembly Order;
    ActionList=ACTIONS
    {
      { 13      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 14      ;1   ;ActionGroup;
                      Name=Line;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      ActionContainerType=NewDocumentItems;
                      Image=Line }
      { 15      ;2   ;Action    ;
                      Name=Show Document;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vi&s bilag;
                                 ENU=&Show Document];
                      ToolTipML=[DAN=èbn det bilag, som oplysningerne pÜ linjen stammer fra.;
                                 ENU=Open the document that the information on the line comes from.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 920;
                      RunPageLink=No.=FIELD(No.);
                      Image=View }
      { 18      ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowStatistics;
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 17      ;2   ;Action    ;
                      Name=Comments;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 907;
                      RunPageLink=Document Type=CONST(Posted Assembly),
                                  Document No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 19      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;Action    ;
                      Name=Print;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Gõr dig klar til at udskrive bilaget. Der Übnes et rapportanmodningsvindue for bilaget, hvor du kan angive, hvad der skal medtages pÜ udskriften.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 PostedAssemblyHeader@1001 : Record 910;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(PostedAssemblyHeader);
                                 PostedAssemblyHeader.PrintRecords(TRUE);
                               END;
                                }
      { 21      ;1   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogfõringsdatoen pÜ den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
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
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den montageordre, som den bogfõrte montageordrelinje stammer fra.;
                           ENU=Specifies the number of the assembly order that the posted assembly order line originates from.];
                ApplicationArea=#Assembly;
                SourceExpr="Order No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af det bogfõrte montageelement.;
                           ENU=Specifies the description of the posted assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren blev bogfõrt.;
                           ENU=Specifies the date when the assembly order was posted.];
                ApplicationArea=#Assembly;
                SourceExpr="Posting Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageelementet skal vëre tilgëngeligt.;
                           ENU=Specifies the date when the assembled item is due to be available for use.];
                ApplicationArea=#Assembly;
                SourceExpr="Due Date" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den bogfõrte montageordre blev pÜbegyndt.;
                           ENU=Specifies the date on which the posted assembly order started.];
                ApplicationArea=#Assembly;
                SourceExpr="Starting Date" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den bogfõrte montageordre var fërdig, dvs. den dato, hvor alle montageelementer var afgÜet.;
                           ENU=Specifies the date when the posted assembly order finished, which means the date on which all assembly items were output.];
                ApplicationArea=#Assembly;
                SourceExpr="Ending Date" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ det bogfõrte montageelementet.;
                           ENU=Specifies the number of the posted assembly item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af det montageelement, der blev bogfõrt med montageordren.;
                           ENU=Specifies how many units of the assembly item were posted with this posted assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr=Quantity }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Cost" }

    { 10  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 11  ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

    { 12  ;1   ;Part      ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

