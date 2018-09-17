OBJECT Page 920 Posted Assembly Order
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=[DAN=Bogf›rt montageordre;
               ENU=Posted Assembly Order];
    InsertAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table910;
    PageType=Document;
    OnAfterGetRecord=BEGIN
                       UndoPostEnabledExpr := NOT Reversed AND NOT IsAsmToOrder;
                     END;

    ActionList=ACTIONS
    {
      { 23      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 26      ;1   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowStatistics;
                               END;
                                }
      { 24      ;1   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 4       ;1   ;Action    ;
                      Name=Item &Tracking Lines;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 ShowItemTrackingLines;
                               END;
                                }
      { 25      ;1   ;Action    ;
                      Name=Comments;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 907;
                      RunPageLink=Document Type=CONST(Posted Assembly),
                                  Document No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 27      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 28      ;1   ;Action    ;
                      Name=Print;
                      CaptionML=[DAN=Udskriv;
                                 ENU=Print];
                      ToolTipML=[DAN=Udskriv oplysningerne i vinduet. Du f†r vist et anmodningsvindue for udskrivningen, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Print the information in the window. A print request window opens where you can specify what to include on the print-out.];
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
      { 29      ;1   ;Action    ;
                      Name=Navigate;
                      CaptionML=[DAN=Naviger;
                                 ENU=Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate;
                               END;
                                }
      { 34      ;1   ;Action    ;
                      Name=Undo Post;
                      CaptionML=[DAN=Fortryd montage;
                                 ENU=Undo Assembly];
                      ToolTipML=[DAN=Annuller bogf›ringen af montageordren. Der oprettes et s‘t korrigerende vareposter for at tilbagef›re de oprindelige poster. Hver positive afgangspost for montageelementet tilbagef›res med en negativ afgangspost. Hver negativ forbrugspost for en montagekomponent tilbagef›res med en positiv forbrugspost. Faste kostprisudligninger oprettes automatisk mellem rettelsesposterne og de oprindelige poster for at sikre en pr‘cis kostprisudligning.;
                                 ENU=Cancel the posting of the assembly order. A set of corrective item ledger entries is created to reverse the original entries. Each positive output entry for the assembly item is reversed by a negative output entry. Each negative consumption entry for an assembly component is reversed by a positive consumption entry. Fixed cost application is automatically created between the corrective and original entries to ensure exact cost reversal.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Enabled=UndoPostEnabledExpr;
                      Image=Undo;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Pstd. Assembly - Undo (Yes/No)",Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=General;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den montageordre, som den bogf›rte montageordrelinje stammer fra.;
                           ENU=Specifies the number of the assembly order that the posted assembly order line originates from.];
                ApplicationArea=#Assembly;
                SourceExpr="Order No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bogf›rte montageelementet.;
                           ENU=Specifies the number of the posted assembly item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No." }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af det bogf›rte montageelement.;
                           ENU=Specifies the description of the posted assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr=Description }

    { 8   ;2   ;Group     ;
                GroupType=Group }

    { 9   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af det montageelement, der blev bogf›rt med montageordren.;
                           ENU=Specifies how many units of the assembly item were posted with this posted assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr=Quantity }

    { 10  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren blev bogf›rt.;
                           ENU=Specifies the date when the assembly order was posted.];
                ApplicationArea=#Assembly;
                SourceExpr="Posting Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageelementet skal v‘re tilg‘ngeligt.;
                           ENU=Specifies the date when the assembled item is due to be available for use.];
                ApplicationArea=#Assembly;
                SourceExpr="Due Date" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den bogf›rte montageordre blev p†begyndt.;
                           ENU=Specifies the date on which the posted assembly order started.];
                ApplicationArea=#Assembly;
                SourceExpr="Starting Date" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor den bogf›rte montageordre var f‘rdig, dvs. den dato, hvor alle montageelementer var afg†et.;
                           ENU=Specifies the date when the posted assembly order finished, which means the date on which all assembly items were output.];
                ApplicationArea=#Assembly;
                SourceExpr="Ending Date" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogf›rte montageordre blev knyttet til en salgsordre, som angiver, at elementet blev monteret under en ordre.;
                           ENU=Specifies if the posted assembly order was linked to a sales order, which indicates that the item was assembled to order.];
                ApplicationArea=#Assembly;
                SourceExpr="Assemble to Order";
                OnDrillDown=BEGIN
                              ShowAsmToOrder;
                            END;
                             }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogf›rte montageordre er annulleret.;
                           ENU=Specifies if the posted assembly order has been undone.];
                ApplicationArea=#Assembly;
                SourceExpr=Reversed }

    { 13  ;1   ;Part      ;
                Name=Lines;
                ApplicationArea=#Assembly;
                SubPageLink=Document No.=FIELD(No.);
                PagePartID=Page921;
                PartType=Page }

    { 14  ;1   ;Group     ;
                Name=Posting;
                CaptionML=[DAN=Bogf›ring;
                           ENU=Posting];
                GroupType=Group }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken lokation montageelementet afgik til fra dette bogf›rte montageordrehoved.;
                           ENU=Specifies to which location the assembly item was output from this posted assembly order header.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken placering montageelementet blev bogf›rt til som afgang for det bogf›rte montageordrehoved.;
                           ENU=Specifies to which bin the assembly item was posted as output on the posted assembly order header.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Cost" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede kostpris for den bogf›rte montageordre.;
                           ENU=Specifies the total unit cost of the posted assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr="Cost Amount" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Assembly;
                SourceExpr="User ID";
                Visible=FALSE }

    { 20  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 21  ;1   ;Part      ;
                PartType=System;
                SystemPartID=RecordLinks }

    { 22  ;1   ;Part      ;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      UndoPostEnabledExpr@1000 : Boolean INDATASET;

    BEGIN
    END.
  }
}

