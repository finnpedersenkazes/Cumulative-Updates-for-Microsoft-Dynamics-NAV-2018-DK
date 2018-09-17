OBJECT Page 99000920 Registered Absences
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Reg. frav‘r;
               ENU=Registered Absences];
    SourceTable=Table99000848;
    DelayedInsert=Yes;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1900173204;1 ;Action    ;
                      CaptionML=[DAN=Opdater registreret frav‘r;
                                 ENU=Implement Registered Absence];
                      ToolTipML=[DAN=Implementer de frav‘rsposter, du har oprettet i vinduerne Reg. frav‘r (fra prod.ress.), Reg. frav‘r (fra arb.center), og Kapacitetsfrav‘r.;
                                 ENU=Implement the absence entries that you have made in the Reg. Abs. (from Machine Ctr.), Reg. Abs. (from Work Center), and Capacity Absence windows.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99003801;
                      Promoted=Yes;
                      Image=ImplementRegAbsence;
                      PromotedCategory=Process }
      { 1904735304;1 ;Action    ;
                      CaptionML=[DAN=Reg. frav‘r (fra prod.ress.);
                                 ENU=Reg. Abs. (from Machine Ctr.)];
                      ToolTipML=[DAN=Registr‚r planlagt frav‘r i en produktionsressource. Det planlagte frav‘r kan registreres for b†de personale og maskiner. Du kan registrere ‘ndringer i tilg‘ngelige ressourcer i tabellen Registreret frav‘r. N†r k›rslen er afsluttet, kan du se resultatet i vinduet Reg. frav‘r.;
                                 ENU=Register planned absences at a machine center. The planned absence can be registered for both human and machine resources. You can register changes in the available resources in the Registered Absence table. When the batch job has been completed, you can see the result in the Registered Absences window.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99003800;
                      Promoted=Yes;
                      Image=CalendarMachine;
                      PromotedCategory=Process }
      { 1901636904;1 ;Action    ;
                      CaptionML=[DAN=Reg. frav‘r (fra arb.center);
                                 ENU=Reg. Abs. (from Work Ctr.)];
                      ToolTipML=[DAN=Registr‚r planlagt frav‘r i en produktionsressource. Det planlagte frav‘r kan registreres for b†de personale og maskiner. Du kan registrere ‘ndringer i tilg‘ngelige ressourcer i tabellen Registreret frav‘r. N†r k›rslen er afsluttet, kan du se resultatet i vinduet Reg. frav‘r.;
                                 ENU=Register planned absences at a machine center. The planned absence can be registered for both human and machine resources. You can register changes in the available resources in the Registered Absence table. When the batch job has been completed, you can see the result in the Registered Absences window.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99003805;
                      Promoted=Yes;
                      Image=CalendarWorkcenter;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om frav‘rsposten er knyttet til en produktionsressource eller et maskincenter.;
                           ENU=Specifies if the absence entry is related to a machine center or a work center.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Capacity Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for frav‘ret. Hvis frav‘ret omfatter flere dage, findes der en postlinje for hver dag.;
                           ENU=Specifies the date of the absence. If the absence covers several days, there will be an entry line for each day.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Date }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af †rsagen til frav‘ret.;
                           ENU=Specifies a short description of the reason for the absence.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Startdato/tidspunkt.;
                           ENU=Specifies the date and the starting time, which are combined in a format called "starting date-time".];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date-Time" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl‘ttet for frav‘ret, f.eks. det klokkesl‘t, hvor medarbejderen normalt begynder p† arbejde eller maskinen begynder at k›re.;
                           ENU=Specifies the starting time of the absence, such as the time the employee normally starts to work or the time the machine starts to operate.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Slutdato/tidspunkt.;
                           ENU=Specifies the date and the ending time, which are combined in a format called "ending date-time".];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date-Time";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl‘ttet for frav‘rsdagen, f.eks. det klokkesl‘t, hvor medarbejderen normalt g†r hjem eller maskinen standser.;
                           ENU=Specifies the ending time of day of the absence, such as the time the employee normally leaves, or the time the machine stops operating.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omfanget af den kapacitet, som ikke kan anvendes i frav‘rsperioden.;
                           ENU=Specifies the amount of capacity, which cannot be used during the absence period.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Capacity }

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

    BEGIN
    END.
  }
}

