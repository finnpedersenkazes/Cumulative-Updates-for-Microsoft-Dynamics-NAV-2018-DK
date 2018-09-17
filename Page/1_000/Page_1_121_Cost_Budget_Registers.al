OBJECT Page 1121 Cost Budget Registers
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningsbudgetregistre;
               ENU=Cost Budget Registers];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table1111;
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
                      CaptionML=[DAN=&Omkostningsbudgetposter;
                                 ENU=&Cost Budget Entries];
                      ToolTipML=[DAN=Vis de relaterede omkostningsbudgetposter.;
                                 ENU=View the related cost budget entries.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=GLRegisters;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CostBudgetEntry@1000 : Record 1109;
                                 CostBudgetEntries@1002 : Page 1115;
                               BEGIN
                                 CostBudgetEntry.SETRANGE("Entry No.","From Cost Budget Entry No.","To Cost Budget Entry No.");
                                 CostBudgetEntries.SETTABLEVIEW(CostBudgetEntry);
                                 CostBudgetEntries.EDITABLE := FALSE;
                                 CostBudgetEntries.RUN;
                               END;
                                }
      { 4       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 6       ;2   ;Action    ;
                      CaptionML=[DAN=&Slet omkostningsbudgetposter;
                                 ENU=&Delete Cost Budget Entries];
                      ToolTipML=[DAN=Slet bogfõrte omkostningsbudgetposter, og annuller allokeringer, eksempelvis nÜr du simulerer budgetallokeringer ved hjëlp af forskellige allokeringskoder, nÜr du tilbagefõrer allokeringer i omkostningsbudgettet for at inkludere forsinkede poster i en samlet post som en del af samme bogfõringsproces, eller nÜr du annullerer en omkostningsbudgetpost i journalen.;
                                 ENU=Delete posted cost budget entries and reverses allocations, for example when you simulate budget allocations by using different allocation codes, when you reverse cost budget allocations to include late entries in a combined entry as part of the same posting process, or when you cancel a cost budget entry in the register.];
                      ApplicationArea=#CostAccounting;
                      RunObject=Report 1139;
                      RunPageOnRec=Yes;
                      Image=Delete }
    }
  }
  CONTROLS
  {
    { 7   ;0   ;Container ;
                ContainerType=ContentArea }

    { 8   ;1   ;Group     ;
                GroupType=Repeater }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#CostAccounting;
                SourceExpr="No.";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsbudgetregisterets kilde.;
                           ENU=Specifies the source for the cost budget register.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Source;
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket niveau bogfõring af omkostningsfordeling udfõres pÜ. Dette sikrer f.eks., at omkostninger fordeles pÜ niveau 1 fra omkostningsstedet ADM til omkostningsstederne WORKSHOP og PROD, fõr de tildeles pÜ niveau 2 fra omkostningsstedet PROD til omkostningsemnerne MùBLER, STOLE og MALING.;
                           ENU=Specifies by which level the cost allocation posting is done. For example, this makes sure that costs are allocated at level 1 from the ADM cost center to the WORKSHOP and PROD cost centers, before they are allocated at level 2 from the PROD cost center to the FURNITURE, CHAIRS, and PAINT cost objects.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Level }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens bogfõringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Posting Date" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det fõrste finanskontobudgetpostnummer i kladden, hvis omkostningsbudgetposten overfõres fra finanspostbudgettet.;
                           ENU=Specifies the first general ledger budget entry number in the register if the cost budget posting is transferred from the general ledger budget.];
                ApplicationArea=#CostAccounting;
                SourceExpr="From Cost Budget Entry No.";
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste omkostningsbudgetpostnummer, der skal bruges pÜ linjen.;
                           ENU=Specifies the last cost budget entry number to be used in the line.];
                ApplicationArea=#CostAccounting;
                SourceExpr="To Cost Budget Entry No.";
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af poster i omkostningsbudgetregistret.;
                           ENU=Specifies the number of entries in the cost budget register.];
                ApplicationArea=#CostAccounting;
                SourceExpr="No. of Entries";
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det fõrste finanskontobudgetpostnummer i kladden, hvis budgetbogfõringen overfõres fra finanspostbudgettet.;
                           ENU=Specifies the first general ledger budget entry number in the register if the budget posting is transferred from the general ledger budget.];
                ApplicationArea=#CostAccounting;
                SourceExpr="From Budget Entry No.";
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sidste budgetpostnummer, der skal bruges pÜ linjen.;
                           ENU=Specifies the last budget entry number to be used in the line.];
                ApplicationArea=#CostAccounting;
                SourceExpr="To Budget Entry No.";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver belõbet pÜ de overfõrte og fordelte omkostningsbudgetposter.;
                           ENU=Specifies the amount of the transferred and allocated cost budget entries.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Amount;
                Editable=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om omkostningen er blevet lukket.;
                           ENU=Specifies whether the cost has been closed.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Closed }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr omkostningsbudgetregistret sidst blev opdateret.;
                           ENU=Specifies when the cost budget register was last updated.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Processed Date" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogfõrt posten, der skal bruges, f.eks. i ëndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#CostAccounting;
                SourceExpr="User ID" }

    { 23  ;2   ;Field     ;
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

