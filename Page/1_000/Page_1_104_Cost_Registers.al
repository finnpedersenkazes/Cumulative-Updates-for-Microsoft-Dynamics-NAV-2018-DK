OBJECT Page 1104 Cost Registers
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningsjournaler;
               ENU=Cost Registers];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table1105;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=&Entry];
                      Image=Entry }
      { 3       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Omkostningsposter;
                                 ENU=&Cost Entries];
                      ToolTipML=[DAN=Vis omkostningsposter, som kan komme fra kilder sÜsom automatisk overfõrsel af finansposter til omkostningsposter, manuel bogfõring for rene omkostningsposter, interne afgifter og manuelle allokeringer samt automatisk tildeling af bogfõringer for faktiske omkostninger.;
                                 ENU=View cost entries, which can come from sources such as automatic transfer of general ledger entries to cost entries, manual posting for pure cost entries, internal charges, and manual allocations, and automatic allocation postings for actual costs.];
                      ApplicationArea=#CostAccounting;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CostEntries;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CostEntry@1000 : Record 1104;
                               BEGIN
                                 CostEntry.SETRANGE("Entry No.","From Cost Entry No.","To Cost Entry No.");
                                 PAGE.RUN(PAGE::"Cost Entries",CostEntry);
                               END;
                                }
      { 4       ;2   ;Action    ;
                      CaptionML=[DAN=&Fordelte omkostningsposter;
                                 ENU=&Allocated Cost Entries];
                      ToolTipML=[DAN=Angiver omkostningsfordelingens poster.;
                                 ENU=Specifies the cost allocation entries.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Page 1103;
                      RunPageView=SORTING(Allocated with Journal No.);
                      RunPageLink=Allocated with Journal No.=FIELD(No.);
                      Promoted=Yes;
                      Image=GLRegisters;
                      PromotedCategory=Process }
      { 5       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 6       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=&Slet omkostningsposter;
                                 ENU=&Delete Cost Entries];
                      ToolTipML=[DAN=Slet bogfõrte omkostningsposter, og annuller allokeringer, eksempelvis for at simulere allokeringer ved hjëlp af forskellige fordelingsforhold, for at tilbagefõre omkostningsfordelinger, for at inkludere forsinkede poster i en samlet post som en del af samme bogfõringsproces eller for at annullere omkostningsposter fra omkostningsregisteret.;
                                 ENU=Delete posted cost entries and reverses allocations, for example to simulate allocations by using different allocation ratios, to reverse cost allocations to include late entries in a combined entry as part of the same posting process, or to cancel cost entries from the cost register.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1130;
                      RunPageOnRec=Yes;
                      Image=Delete }
      { 25      ;2   ;Action    ;
                      CaptionML=[DAN=&Slet gamle omkostningsposter;
                                 ENU=&Delete Old Cost Entries];
                      ToolTipML=[DAN=Slet alle omkostningsposter til og med den dato, du angiver i rapporten.;
                                 ENU=Delete all cost entries up to and including the date that you enter in the report.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1141;
                      Image=Delete }
    }
  }
  CONTROLS
  {
    { 8   ;0   ;Container ;
                ContainerType=ContentArea }

    { 9   ;1   ;Group     ;
                GroupType=Repeater }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#CostAccounting;
                SourceExpr="No.";
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsregisterets kilde.;
                           ENU=Specifies the source for the cost register.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Source;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket niveau bogfõring af omkostningsfordeling udfõres pÜ. Dette sikrer f.eks., at omkostninger fordeles pÜ niveau 1 fra omkostningsstedet ADM til omkostningsstederne WORKSHOP og PROD, fõr de tildeles pÜ niveau 2 fra omkostningsstedet PROD til omkostningsemnerne MùBLER, STOLE og MALING.;
                           ENU=Specifies by which level the cost allocation posting is done. For example, this makes sure that costs are allocated at level 1 from the ADM cost center to the WORKSHOP and PROD cost centers, before they are allocated at level 2 from the PROD cost center to the FURNITURE, CHAIRS, and PAINT cost objects.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Level }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogfõringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Posting Date" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det fõrste omkostningsspostnummer i omkostningsjournalen.;
                           ENU=Specifies the first cost entry number in the cost register.];
                ApplicationArea=#CostAccounting;
                SourceExpr="From Cost Entry No.";
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ starten af det interval, der gëlder for den registrerede omkostning.;
                           ENU=Specifies the number of the start of the range that applies to the cost registered.];
                ApplicationArea=#CostAccounting;
                SourceExpr="To Cost Entry No.";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af poster i omkostningsregisteret.;
                           ENU=Specifies the number of entries in the cost register.];
                ApplicationArea=#CostAccounting;
                SourceExpr="No. of Entries";
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det fõrste finanskontopostnummer, hvor omkostningsposten overfõres fra finansposten.;
                           ENU=Specifies the first general ledger entry number when the cost posting is transferred from the general ledger.];
                ApplicationArea=#CostAccounting;
                SourceExpr="From G/L Entry No.";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ slutningen af det interval, der gëlder for den registrerede omkostning.;
                           ENU=Specifies the number of the end of the range that applies to the cost registered.];
                ApplicationArea=#CostAccounting;
                SourceExpr="To G/L Entry No.";
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der reprësenterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Debit Amount";
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der reprësenterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Credit Amount" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om omkostningsposten er blevet lukket.;
                           ENU=Specifies whether or not the cost has been closed.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Closed }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr omkostningsregisteret sidst blev opdateret.;
                           ENU=Specifies when the cost register was last updated.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Processed Date" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogfõrt posten, der skal bruges, f.eks. i ëndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#CostAccounting;
                SourceExpr="User ID" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den kladdekõrsel, et personligt kladdelayout, som posterne blev bogfõrt fra.;
                           ENU=Specifies the name of the journal batch, a personalized journal layout, that the entries were posted from.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Journal Batch Name" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

