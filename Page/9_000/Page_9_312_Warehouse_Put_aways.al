OBJECT Page 9312 Warehouse Put-aways
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
    CaptionML=[DAN=L‘g-p†-lager (lager);
               ENU=Warehouse Put-aways];
    SourceTable=Table5766;
    SourceTableView=WHERE(Type=CONST(Put-away));
    PageType=List;
    CardPageID=Warehouse Put-away;
    OnOpenPage=BEGIN
                 ErrorIfUserIsNotWhseEmployee;
               END;

    OnFindRecord=BEGIN
                   EXIT(FindFirstAllowedRec(Which));
                 END;

    OnNextRecord=BEGIN
                   EXIT(FindNextAllowedRec(Steps));
                 END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601000;1 ;ActionGroup;
                      CaptionML=[DAN=L&‘g-p†-lager;
                                 ENU=Put-&away];
                      Image=CreatePutAway }
      { 1102601002;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5776;
                      RunPageLink=Table Name=CONST(Whse. Activity Header),
                                  Type=FIELD(Type),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 1102601003;2 ;Action    ;
                      CaptionML=[DAN=Registrerede l‘g-p†-lager-akt.;
                                 ENU=Registered Put-aways];
                      ToolTipML=[DAN=Vis det antal, der allerede er blevet lagt p† lager.;
                                 ENU=View the quantity that has already been put-away.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5797;
                      RunPageView=SORTING(Whse. Activity No.);
                      RunPageLink=Type=FIELD(Type),
                                  Whse. Activity No.=FIELD(No.);
                      Image=RegisteredDocs }
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
                ApplicationArea=#Warehouse;
                SourceExpr="No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bilagstype, som linjen vedr›rer.;
                           ENU=Specifies the type of document that the line relates to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Document" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source No." }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type aktivitet, eksempelvis l‘g-p†-lager, som lagerstedet udf›rer for de linjer, der er knyttet til hovedet.;
                           ENU=Specifies the type of activity, such as Put-away, that the warehouse performs on the lines that are attached to the header.];
                ApplicationArea=#Warehouse;
                SourceExpr=Type;
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor lageraktiviteten finder sted.;
                           ENU=Specifies the code for the location where the warehouse activity takes place.];
                ApplicationArea=#Warehouse;
                SourceExpr="Location Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om den destinationstype, f.eks. debitor eller kreditor, som er knyttet til lageraktiviteten.;
                           ENU=Specifies information about the type of destination, such as customer or vendor, associated with the warehouse activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination Type" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer eller den kode for debitoren eller kreditoren, som linjen er tilknyttet.;
                           ENU=Specifies the number or the code of the customer or vendor that the line is linked to.];
                ApplicationArea=#Warehouse;
                SourceExpr="Destination No." }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et bilagsnummer, som bliver brugt i debitors eller kreditors nummereringssystem.;
                           ENU=Specifies a document number that refers to the customer's or vendor's numbering system.];
                ApplicationArea=#Warehouse;
                SourceExpr="External Document No." }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assigned User ID";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af linjer i lageraktivitetsdokumentet.;
                           ENU=Specifies the number of lines in the warehouse activity document.];
                ApplicationArea=#Warehouse;
                SourceExpr="No. of Lines" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan linjerne sorteres i lagerhovedet, f.eks. efter Vare eller Bilag.;
                           ENU=Specifies the method by which the lines are sorted on the warehouse header, such as Item or Document.];
                ApplicationArea=#Warehouse;
                SourceExpr="Sorting Method";
                Visible=FALSE }

    { 1102601001;2;Field  ;
                ToolTipML=[DAN=Angiver den dato, hvor brugeren fik tildelt aktiviteten.;
                           ENU=Specifies the date when the user was assigned the activity.];
                ApplicationArea=#Warehouse;
                SourceExpr="Assignment Date";
                Visible=FALSE }

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

