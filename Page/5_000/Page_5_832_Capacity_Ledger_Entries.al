OBJECT Page 5832 Capacity Ledger Entries
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
    CaptionML=[DAN=Kapacitetsposter;
               ENU=Capacity Ledger Entries];
    SourceTable=Table5832;
    DataCaptionExpr=GetCaption;
    SourceTableView=SORTING(Entry No.)
                    ORDER(Descending);
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 41      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 42      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr‘ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Dimensions;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
                               END;
                                }
      { 55      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&V‘rdiposter;
                                 ENU=&Value Entries];
                      ToolTipML=[DAN=F† vist historikken over bogf›rte bel›b, der p†virker v‘rdien af varen. V‘rdiposter oprettes for hver transaktion med varen.;
                                 ENU=View the history of posted amounts that affect the value of the item. Value entries are created for every transaction with the item.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Capacity Ledger Entry No.,Entry Type);
                      RunPageLink=Capacity Ledger Entry No.=FIELD(Entry No.);
                      Image=ValueLedger }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 8       ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Navigate@1001 : Page 344;
                               BEGIN
                                 IF "Order Type" = "Order Type"::Production THEN
                                   Navigate.SetDoc("Posting Date","Order No.")
                                 ELSE
                                   Navigate.SetDoc("Posting Date",'');
                                 Navigate.RUN;
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

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for posten.;
                           ENU=Specifies the posting date of the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Date" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type ordre posten blev oprettet i.;
                           ENU=Specifies which type of order the entry was created in.];
                ApplicationArea=#Advanced;
                SourceExpr="Order Type" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den ordre, hvor posten blev oprettet.;
                           ENU=Specifies the number of the order that created the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Order No." }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rutenummer, der tilh›rer posten.;
                           ENU=Specifies the routing number belonging to the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing No.";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rutereferencenummer, der svarer til rutereferencenummeret p† linjen.;
                           ENU=Specifies that the routing reference number corresponding to the routing reference number of the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing Reference No.";
                Visible=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver arbejdscenternummeret p† kladdelinjen.;
                           ENU=Specifies the work center number of the journal line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Center No.";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kapacitetspostens type.;
                           ENU=Specifies the type of capacity entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Type }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret for posten.;
                           ENU=Specifies the document number of the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den operation, som er knyttet til posten.;
                           ENU=Specifies the number of the operation associated with the entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Operation No." }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varenummeret.;
                           ENU=Specifies the item number.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No." }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of the entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det arbejdsskift, hvor produktionsressourcen blev planlagt, eller den relaterede produktionsoperation foregik.;
                           ENU=Specifies the work shift that this machine center was planned at, or in which work shift the related production operation took place.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Work Shift Code";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver starttidspunktet for den kapacitet, der er bogf›rt med denne post.;
                           ENU=Specifies the starting time of the capacity posted with this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sluttidspunktet for den kapacitet, der er bogf›rt med denne post.;
                           ENU=Specifies the ending time of the capacity posted with this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Ending Time";
                Visible=FALSE }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange personer der har arbejdet samtidigt p† denne post.;
                           ENU=Specifies how many people have worked concurrently on this entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Concurrent Capacity";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid det tager at konfigurere maskinerne for posten.;
                           ENU=Specifies how long it takes to set up the machines for this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Setup Time";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver operationstiden for posten.;
                           ENU=Specifies the run time of this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Run Time";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver stoptidspunktet for posten.;
                           ENU=Specifies the stop time of this entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Stop Time";
                Visible=FALSE }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i basisenheder for denne post.;
                           ENU=Specifies the quantity of this entry, in base units of measure.];
                ApplicationArea=#Advanced;
                SourceExpr=Quantity }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udg†ende antal i basisenheder.;
                           ENU=Specifies the output quantity, in base units of measure.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Output Quantity" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver spildantallet i basisenheder.;
                           ENU=Specifies the scrap quantity, in base units of measure.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Quantity" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den direkte omkostning i RV for antalsbogf›ringen.;
                           ENU=Specifies the direct cost in LCY of the quantity posting.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Cost" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de faste omkostninger i RV for antalsbogf›ringen.;
                           ENU=Specifies the overhead cost in LCY of the quantity posting.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Overhead Cost" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den direkte omkostning i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the direct cost in the additional reporting currency.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Cost (ACY)";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de faste omkostninger i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the overhead cost in the additional reporting currency.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Overhead Cost (ACY)";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver stopkoden.;
                           ENU=Specifies the stop code.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Stop Code";
                Visible=FALSE }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorfor en vare er blevet kasseret.;
                           ENU=Specifies why an item has been scrapped.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Code";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om posten er fuldt faktureret, eller om der forventes flere bogf›rte fakturaer.;
                           ENU=Specifies if the entry has been fully invoiced or if more posted invoices are expected.];
                ApplicationArea=#Advanced;
                SourceExpr="Completely Invoiced";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv‘rdier. De faktiske v‘rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Dimensions;
                SourceExpr="Dimension Set ID";
                Visible=FALSE }

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
      Text000@1000 : TextConst 'DAN=Prod.ress.;ENU=Machine Center';
      DimensionSetIDFilter@1001 : Page 481;

    LOCAL PROCEDURE GetCaption@3() : Text[250];
    VAR
      ObjTransl@1000 : Record 377;
      WorkCenter@1006 : Record 99000754;
      MachineCenter@1005 : Record 99000758;
      ProdOrder@1004 : Record 5405;
      SourceTableName@1002 : Text[100];
      SourceFilter@1001 : Text;
      Description@1003 : Text[100];
    BEGIN
      Description := '';

      CASE TRUE OF
        GETFILTER("Work Center No.") <> '':
          BEGIN
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,99000754);
            SourceFilter := GETFILTER("Work Center No.");
            IF MAXSTRLEN(WorkCenter."No.") >= STRLEN(SourceFilter) THEN
              IF WorkCenter.GET(SourceFilter) THEN
                Description := WorkCenter.Name;
          END;
        (GETFILTER("No.") <> '') AND (GETFILTER(Type) = Text000):
          BEGIN
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,99000758);
            SourceFilter := GETFILTER("No.");
            IF MAXSTRLEN(MachineCenter."No.") >= STRLEN(SourceFilter) THEN
              IF MachineCenter.GET(SourceFilter) THEN
                Description := MachineCenter.Name;
          END;
        (GETFILTER("Order No.") <> '') AND ("Order Type" = "Order Type"::Production):
          BEGIN
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5405);
            SourceFilter := GETFILTER("Order No.");
            IF MAXSTRLEN(ProdOrder."No.") >= STRLEN(SourceFilter) THEN
              IF ProdOrder.GET(ProdOrder.Status::Released,SourceFilter) OR
                 ProdOrder.GET(ProdOrder.Status::Finished,SourceFilter)
              THEN BEGIN
                SourceTableName := STRSUBSTNO('%1 %2',ProdOrder.Status,SourceTableName);
                Description := ProdOrder.Description;
              END;
          END;
      END;
      EXIT(STRSUBSTNO('%1 %2 %3',SourceTableName,SourceFilter,Description));
    END;

    BEGIN
    END.
  }
}

