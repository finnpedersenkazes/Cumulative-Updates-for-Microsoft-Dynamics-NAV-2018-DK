OBJECT Page 958 Time Sheet Posting Entries
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
    CaptionML=[DAN=Bogf›ringsposter for timesedler;
               ENU=Time Sheet Posting Entries];
    SourceTable=Table958;
    DataCaptionFields=Time Sheet No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 10      ;    ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 11      ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes til bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
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
                ToolTipML=[DAN=Angiver nummeret p† en timeseddel.;
                           ENU=Specifies the number of a time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Time Sheet No." }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for en timeseddellinje.;
                           ENU=Specifies the number of a time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr="Time Sheet Line No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, for hvilken forbrugsoplysningerne er angivet i en timeseddel.;
                           ENU=Specifies the date for which time usage information was entered in a time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Time Sheet Date" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den beskrivelse, der er indeholdt i detaljerne om timeseddellinjen.;
                           ENU=Specifies the description that is contained in the details about the time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet timer, der er bogf›rt for den p†g‘ldende dato p† timesedlen.;
                           ENU=Specifies the number of hours that have been posted for that date in the time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr=Quantity }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bilagsnummer, der blev genereret eller oprettet til timesedlen under bogf›ringen.;
                           ENU=Specifies the document number that was generated or created for the time sheet during posting.];
                ApplicationArea=#Jobs;
                SourceExpr="Document No." }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bogf›ringsdatoen for det bogf›rte bilag.;
                           ENU=Specifies the posting date of the posted document.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Date" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Entry No." }

  }
  CODE
  {
    VAR
      Navigate@1000 : Page 344;

    BEGIN
    END.
  }
}

