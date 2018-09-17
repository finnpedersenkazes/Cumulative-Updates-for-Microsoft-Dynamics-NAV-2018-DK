OBJECT Page 1115 Cost Budget Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Omkostningsbudgetposter;
               ENU=Cost Budget Entries];
    SourceTable=Table1109;
    DelayedInsert=Yes;
    DataCaptionFields=Cost Type No.,Budget Name;
    PageType=List;
    OnOpenPage=BEGIN
                 IF GETFILTER("Budget Name") = '' THEN
                   CostBudgetName.INIT
                 ELSE BEGIN
                   COPYFILTER("Budget Name",CostBudgetName.Name);
                   CostBudgetName.FINDFIRST;
                 END;
               END;

    OnNewRecord=BEGIN
                  "Budget Name" := CostBudgetName.Name;
                  IF CostBudgetName.Name <> "Budget Name" THEN
                    CostBudgetName.GET("Budget Name");
                  IF GETFILTER("Cost Type No.") <> '' THEN
                    "Cost Type No." := GetFirstCostType(GETFILTER("Cost Type No."));
                  IF GETFILTER("Cost Center Code") <> '' THEN
                    "Cost Center Code" := GetFirstCostCenter(GETFILTER("Cost Center Code"));
                  IF GETFILTER("Cost Object Code") <> '' THEN
                    "Cost Object Code" := GetFirstCostObject(GETFILTER("Cost Object Code"));
                  Date := GetFirstDate(GETFILTER(Date));
                  "Last Modified By User" := USERID;
                END;

    OnInsertRecord=BEGIN
                     SetCostBudgetRegNo(CurrRegNo);
                     INSERT(TRUE);
                     CurrRegNo := GetCostBudgetRegNo;
                     EXIT(FALSE);
                   END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† det omkostningsbudget, som posten er tilknyttet.;
                           ENU=Specifies the name of the cost budget that the entry belongs to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Budget Name";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for omkostningsbudgetposten.;
                           ENU=Specifies the date of the cost budget entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Date }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsstedets undertype. Dette er et oplysningsfelt og bruges ikke til nogen andre form†l. V‘lg feltet for at v‘lge omkostningsundertype.;
                           ENU=Specifies the subtype of the cost center. This is an information field and is not used for any other purposes. Choose the field to select the cost subtype.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Type No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsstedets kode. Koden fungerer som en standardv‘rdi for omkostningsbogf›ring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost center code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Center Code" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsemnets kode. Koden fungerer som en standardv‘rdi for omkostningsbogf›ring, der registreres senere i omkostningskladden.;
                           ENU=Specifies the cost object code. The code serves as a default value for cost posting that is captured later in the cost journal.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Cost Object Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningsbudgetposternes bel›b.;
                           ENU=Specifies the amount of the cost budget entries.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Amount }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af omkostningsbudgetposten.;
                           ENU=Specifies a description of the cost budget entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det relaterede bilag.;
                           ENU=Specifies the number of the related document.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Document No." }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den post, der er oprettet af systemet for omkostningsbudgetposten.;
                           ENU=Specifies the entry created by the system for the cost budget entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr="System-Created Entry" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Source Code" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den fordelingsn›gle, som omkostningsbudgetposten kommer fra.;
                           ENU=Specifies the ID of the allocation key that the cost budget entry comes from.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Allocation ID" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om omkostningsposten er blevet udlignet.;
                           ENU=Specifies whether the cost entry has been allocated.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Allocated }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken omkostningskladde der blev brugt til at allokere omkostningsbudgettet.;
                           ENU=Specifies which cost journal was used to allocate the cost budget.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Allocated with Journal No." }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen, der forklarer allokeringsniveauet og fordelinger.;
                           ENU=Specifies the description that explains the allocation level and shares.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Allocation Description" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bruger, der sidst har ‘ndret omkostningsbudgettet.;
                           ENU=Specifies the user who made the last change to the cost budget.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Last Modified By User" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Entry No." }

  }
  CODE
  {
    VAR
      CostBudgetName@1000 : Record 1110;
      CurrRegNo@1002 : Integer;

    [External]
    PROCEDURE SetCurrRegNo@7(RegNo@1000 : Integer);
    BEGIN
      CurrRegNo := RegNo;
    END;

    [External]
    PROCEDURE GetCurrRegNo@5() : Integer;
    BEGIN
      EXIT(CurrRegNo);
    END;

    BEGIN
    END.
  }
}

