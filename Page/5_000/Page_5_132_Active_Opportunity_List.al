OBJECT Page 5132 Active Opportunity List
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
    CaptionML=[DAN=Oversigt over aktive salgsmuligheder;
               ENU=Active Opportunity List];
    SourceTable=Table5092;
    DataCaptionFields=Contact Company No.,Contact No.;
    PageType=List;
    OnAfterGetCurrRecord=BEGIN
                           CALCFIELDS("Contact Name","Contact Company Name");
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Salgsmuligheden;
                                 ENU=Oppo&rtunity];
                      Image=Opportunity }
      { 35      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Kort;
                                 ENU=Card];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om den aktive salgsmulighed.;
                                 ENU=View or change detailed information about the active opportunity.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5124;
                      RunPageLink=No.=FIELD(No.);
                      Image=EditLines }
      { 36      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger s†som v‘rdien for bogf›rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5127;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 45      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Interaktionslogposter;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=Vis en liste med de interaktioner, som du har gemt, f.eks. hvis du vil oprette en interaktion, udskrive en f›lgeseddel en salgsordre osv.;
                                 ENU=View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5076;
                      RunPageView=SORTING(Opportunity No.,Date);
                      RunPageLink=Opportunity No.=FIELD(No.);
                      Image=InteractionLog }
      { 48      ;2   ;Action    ;
                      CaptionML=[DAN=&Udsatte interaktioner;
                                 ENU=Postponed &Interactions];
                      ToolTipML=[DAN=Vis en liste med de interaktioner, som du har gemt, f.eks. hvis du vil oprette en interaktion, udskrive en f›lgeseddel en salgsordre osv.;
                                 ENU=View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5082;
                      RunPageView=SORTING(Opportunity No.,Date);
                      RunPageLink=Opportunity No.=FIELD(No.);
                      Image=PostponedInteractions }
      { 37      ;2   ;Action    ;
                      CaptionML=[DAN=Opg&aver;
                                 ENU=T&asks];
                      ToolTipML=[DAN=F† vist alle marketingopgaver, der vedr›rer salgsmuligheden.;
                                 ENU=View all marketing tasks that involve the opportunity.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5096;
                      RunPageView=SORTING(Opportunity No.);
                      RunPageLink=Opportunity No.=FIELD(No.),
                                  System To-do Type=FILTER(Organizer);
                      Image=TaskList }
      { 42      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5072;
                      RunPageLink=Table Name=CONST(Opportunity),
                                  No.=FIELD(No.);
                      Image=ViewComments }
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
                ApplicationArea=#All;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at salgsmuligheden er lukket.;
                           ENU=Specifies that the opportunity is closed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Closed }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor salgsmuligheden blev oprettet.;
                           ENU=Specifies the date that the opportunity was created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Creation Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den †bne salgsmulighed.;
                           ENU=Specifies the description of the opportunity.];
                ApplicationArea=#All;
                SourceExpr=Description }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontakt, som denne salgsmulighed er knyttet til.;
                           ENU=Specifies the number of the contact that this opportunity is linked to.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact No." }

    { 3   ;2   ;Field     ;
                DrillDown=No;
                CaptionML=[DAN=Kontaktnavn;
                           ENU=Contact Name];
                ToolTipML=[DAN=Angiver navnet p† den kontakt, som denne salgsmulighed er knyttet til. Feltet udfyldes automatisk, n†r du angiver et nummer i feltet Nummer.;
                           ENU=Specifies the name of the contact to which this opportunity is linked. The program automatically fills in this field when you have entered a number in the No. field.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Name" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den virksomhed, som er knyttet til denne salgsmulighed.;
                           ENU=Specifies the number of the company that is linked to this opportunity.];
                ApplicationArea=#Advanced;
                SourceExpr="Contact Company No.";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† virksomheden for den kontakt, som denne salgsmulighed er knyttet til. Feltet udfyldes automatisk, n†r du angiver et nummer i feltet Virksomhedsnummer.;
                           ENU=Specifies the name of the company of the contact person to which this opportunity is linked. The program automatically fills in this field when you have entered a number in the Contact Company No. field.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Company Name" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger, som er ansvarlig for salgsmuligheden.;
                           ENU=Specifies the code of the salesperson that is responsible for the opportunity.];
                ApplicationArea=#Advanced;
                SourceExpr="Salesperson Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for salgsmuligheden. Der er fire indstillinger:;
                           ENU=Specifies the status of the opportunity. There are four options:];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Status }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den salgsproces, som salgsmuligheden er knyttet til.;
                           ENU=Specifies the code of the sales cycle that the opportunity is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Cycle Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den aktuelle salgsprocesfase for salgsmuligheden.;
                           ENU=Specifies the current sales cycle stage of the opportunity.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Current Sales Cycle Stage" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, som denne salgsmulighed er knyttet til.;
                           ENU=Specifies the number of the campaign to which this opportunity is linked.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No." }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsdokumentets type (Tilbud, Ordre, Bogf›rt faktura). Kombinationen af Salgsdokumentsnr. og Salgsdokumenttype angiver, hvilket salgsdokument der er knyttet til salgsmuligheden.;
                           ENU=Specifies the type of the sales document (Quote, Order, Posted Invoice). The combination of Sales Document No. and Sales Document Type specifies which sales document is assigned to the opportunity.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Document Type" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det salgsdokument, der er blevet oprettet til denne salgsmulighed.;
                           ENU=Specifies the number of the sales document that has been created for this opportunity.];
                ApplicationArea=#Advanced;
                SourceExpr="Sales Document No.";
                LookupPageID=Sales Quote }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ansl†ede ultimodato for salgsmuligheden.;
                           ENU=Specifies the estimated closing date of the opportunity.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Estimated Closing Date" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ansl†ede v‘rdi af salgsmuligheden.;
                           ENU=Specifies the estimated value of the opportunity.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Estimated Value (LCY)" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den aktuelle beregnede v‘rdi af salgsmuligheden.;
                           ENU=Specifies the current calculated value of the opportunity.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Calcd. Current Value (LCY)" }

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

