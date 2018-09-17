OBJECT Page 595 Change Log Entries
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=’ndringslogposter;
               ENU=Change Log Entries];
    SourceTable=Table405;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 47      ;1   ;Action    ;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      ToolTipML=[DAN=Forbered udskrivning af bilaget. Du f†r vist et anmodningsvindue for bilaget, hvor du kan angive, hvad der skal udskrives.;
                                 ENU=Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Print;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUN(REPORT::"Change Log Entries",TRUE,FALSE,Rec);
                               END;
                                }
      { 6       ;1   ;Action    ;
                      Name=Setup;
                      CaptionML=[DAN=Ops‘tning;
                                 ENU=Setup];
                      ToolTipML=[DAN=Aktiv‚r, deaktiver eller konfigurer logf›ring af ‘ndringer.;
                                 ENU=Enable, disable or setup change logging.];
                      ApplicationArea=#All;
                      RunObject=Page 592;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Setup }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato og det klokkesl‘t, hvor ‘ndringslogposten blev oprettet.;
                           ENU=Specifies the date and time when this change log entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Date and Time" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID" }

    { 10  ;2   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver nummeret p† den tabel, der indeholder det ‘ndrede felt.;
                           ENU=Specifies the number of the table containing the changed field.];
                ApplicationArea=#Advanced;
                SourceExpr="Table No.";
                Visible=false }

    { 12  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den tabel, der indeholder det ‘ndrede felt.;
                           ENU=Specifies the name of the table containing the changed field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Table Caption" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prim‘rn›glen eller -n›glerne for det ‘ndrede felt.;
                           ENU=Specifies the primary key or keys of the changed field.];
                ApplicationArea=#Advanced;
                SourceExpr="Primary Key";
                Visible=false }

    { 26  ;2   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver feltnummeret for den f›rste prim‘rn›gle for det ‘ndrede felt.;
                           ENU=Specifies the field number of the first primary key for the changed field.];
                ApplicationArea=#Advanced;
                SourceExpr="Primary Key Field 1 No.";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver feltnavnet for den f›rste prim‘rn›gle for det ‘ndrede felt.;
                           ENU=Specifies the field name of the first primary key for the changed field.];
                ApplicationArea=#Advanced;
                SourceExpr="Primary Key Field 1 Caption";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘rdien for den f›rste prim‘rn›gle for det ‘ndrede felt.;
                           ENU=Specifies the value of the first primary key for the changed field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Primary Key Field 1 Value" }

    { 32  ;2   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver feltnummeret for den anden prim‘rn›gle for det ‘ndrede felt.;
                           ENU=Specifies the field number of the second primary key for the changed field.];
                ApplicationArea=#Advanced;
                SourceExpr="Primary Key Field 2 No.";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver feltnavnet for den anden prim‘rn›gle for det ‘ndrede felt.;
                           ENU=Specifies the field name of the second primary key for the changed field.];
                ApplicationArea=#Advanced;
                SourceExpr="Primary Key Field 2 Caption";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘rdien for den anden prim‘rn›gle for det ‘ndrede felt.;
                           ENU=Specifies the value of the second primary key for the changed field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Primary Key Field 2 Value" }

    { 38  ;2   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver feltnummeret for den tredje prim‘rn›gle for det ‘ndrede felt.;
                           ENU=Specifies the field number of the third primary key for the changed field.];
                ApplicationArea=#Advanced;
                SourceExpr="Primary Key Field 3 No.";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver feltnavnet for den tredje prim‘rn›gle for det ‘ndrede felt.;
                           ENU=Specifies the field name of the third primary key for the changed field.];
                ApplicationArea=#Advanced;
                SourceExpr="Primary Key Field 3 Caption";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘rdien for den tredje prim‘rn›gle for det ‘ndrede felt.;
                           ENU=Specifies the value of the third primary key for the changed field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Primary Key Field 3 Value" }

    { 14  ;2   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver feltnummeret for det ‘ndrede felt.;
                           ENU=Specifies the field number of the changed field.];
                ApplicationArea=#Advanced;
                SourceExpr="Field No.";
                Visible=false }

    { 16  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver felttitlen for det ‘ndrede felt.;
                           ENU=Specifies the field caption of the changed field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Field Caption" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type ‘ndring, der er foretaget i feltet.;
                           ENU=Specifies the type of change made to the field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Type of Change" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den v‘rdi, som feltet indeholdte, f›r en bruger ‘ndrede feltet.;
                           ENU=Specifies the value that the field had before a user made changes to the field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Old Value" }

    { 3   ;2   ;Field     ;
                Name=Old Value Local;
                CaptionML=[DAN=Gammel v‘rdi (lokal);
                           ENU=Old Value (Local)];
                ToolTipML=[DAN=Angiver den v‘rdi, som feltet indeholdte, f›r en bruger ‘ndrede feltet.;
                           ENU=Specifies the value that the field had before a user made changes to the field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetLocalOldValue }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den v‘rdi, feltet indeholdte, efter en bruger ‘ndrede feltet.;
                           ENU=Specifies the value that the field had after a user made changes to the field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="New Value" }

    { 5   ;2   ;Field     ;
                Name=New Value Local;
                CaptionML=[DAN=Ny v‘rdi (lokal);
                           ENU=New Value (Local)];
                ToolTipML=[DAN=Angiver den v‘rdi, feltet indeholdte, efter en bruger ‘ndrede feltet.;
                           ENU=Specifies the value that the field had after a user made changes to the field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetLocalNewValue }

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

