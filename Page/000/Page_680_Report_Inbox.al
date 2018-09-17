OBJECT Page 680 Report Inbox
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rapportindbakke;
               ENU=Report Inbox];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table477;
    SourceTableView=SORTING(User ID,Created Date-Time)
                    ORDER(Descending);
    PageType=List;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dato og tidspunkt, hvor den planlagte rapport blev behandlet i sagsk›en.;
                           ENU=Specifies the date and time that the scheduled report was processed from the job queue.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Created Date-Time" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens objekt-id.;
                           ENU=Specifies the object ID of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report ID" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† rapporten.;
                           ENU=Specifies the name of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report Name" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

