OBJECT Page 1103 Cost Entries
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
    CaptionML=[DAN=Omkostningsposter;
               ENU=Cost Entries];
    SourceTable=Table1104;
    DataCaptionFields=Cost Type No.;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;Action    ;
                      CaptionML=[DAN=&Naviger;
                                 ENU=&Navigate];
                      ToolTipML=[DAN=Find alle de poster og bilag, der findes for bilagsnummeret og bogf›ringsdatoen p† den valgte post eller det valgte bilag.;
                                 ENU=Find all entries and documents that exist for the document number and posting date on the selected entry or document.];
                      ApplicationArea=#CostAccounting;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Navigate@1000 : Page 344;
                               BEGIN
                                 Navigate.SetDoc("Posting Date","Document No.");
                                 Navigate.RUN;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 3   ;0   ;Container ;
                ContainerType=ContentArea }

    { 4   ;1   ;Group     ;
                GroupType=Repeater }

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
                ToolTipML=[DAN=Angiver postens bogf›ringsdato.;
                           ENU=Specifies the entry's posting date.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Posting Date" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det relaterede bilag.;
                           ENU=Specifies the number of the related document.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Document No." }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af omkostningsposten.;
                           ENU=Specifies the description of the cost entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Description }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for omkostningsposten.;
                           ENU=Specifies the amount of the cost entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Amount }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den finanspost, som omkostningsposten g‘lder for.;
                           ENU=Specifies the G/L account that the cost entry applies to.];
                ApplicationArea=#CostAccounting;
                SourceExpr="G/L Account" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angivet postnummeret for den tilh›rende finanskontopost, der er knyttet til denne omkostningspost. For kombinerede poster g‘lder det, at postnummeret for den seneste finanskontopost gemmes i feltet. Dette er den post, der har det h›jeste postnummer.;
                           ENU=Specifies the entry number of the corresponding general ledger entry that is associated with this cost entry. For combined entries, the entry number of the last general ledger entry is saved in the field. This is the entry with the highest entry number.];
                ApplicationArea=#CostAccounting;
                SourceExpr="G/L Entry No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den fordelingsn›gle, som omkostningsbudgetposten kommer fra.;
                           ENU=Specifies the ID of the allocation key that the cost budget entry comes from.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Allocation ID" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen, der forklarer allokeringsniveauet og fordelinger.;
                           ENU=Specifies the description that explains the allocation level and shares.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Allocation Description" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Entry No." }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om omkostningsposten er blevet udlignet.;
                           ENU=Specifies whether the cost entry has been allocated.];
                ApplicationArea=#CostAccounting;
                SourceExpr=Allocated }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for denne post i den ekstra rapporteringsvaluta.;
                           ENU=Specifies the amount of this entry, in the additional reporting currency.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Additional-Currency Amount";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken omkostningskladde der blev brugt til at allokere omkostningen.;
                           ENU=Specifies which cost journal was used to allocate the cost.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Allocated with Journal No." }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den post, der er oprettet af systemet for omkostningsposten.;
                           ENU=Specifies the entry created by the system for the cost entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr="System-Created Entry" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Source Code" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Reason Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kladdebatchnavn, der bliver brugt til bogf›ringen. Navnet kopieres fra feltet Kladdetypenavn p† omkostningskladdelinjen.;
                           ENU=Specifies the journal batch name used in the posting. The name is copied from the Journal Template Name field on the cost journal line.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Batch Name" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#CostAccounting;
                SourceExpr="User ID" }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer debiteringer.;
                           ENU=Specifies the total of the ledger entries that represent debits.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Debit Amount";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal poster, der repr‘senterer krediteringer.;
                           ENU=Specifies the total of the ledger entries that represent credits.];
                ApplicationArea=#CostAccounting;
                SourceExpr="Credit Amount";
                Visible=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

