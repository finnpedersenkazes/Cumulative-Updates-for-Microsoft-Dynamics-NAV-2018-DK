OBJECT Page 120 G/L Budget Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Finansbudgetposter;
               ENU=G/L Budget Entries];
    SourceTable=Table96;
    DelayedInsert=Yes;
    DataCaptionFields=G/L Account No.,Budget Name;
    PageType=List;
    OnInit=BEGIN
             BudgetDimension4CodeEnable := TRUE;
             BudgetDimension3CodeEnable := TRUE;
             BudgetDimension2CodeEnable := TRUE;
             BudgetDimension1CodeEnable := TRUE;
             GlobalDimension2CodeEnable := TRUE;
             GlobalDimension1CodeEnable := TRUE;
             BudgetDimension4CodeVisible := TRUE;
             BudgetDimension3CodeVisible := TRUE;
             BudgetDimension2CodeVisible := TRUE;
             BudgetDimension1CodeVisible := TRUE;
             GlobalDimension2CodeVisible := TRUE;
             GlobalDimension1CodeVisible := TRUE;
             LowestModifiedEntryNo := 2147483647;
           END;

    OnOpenPage=VAR
                 GLBudgetName@1000 : Record 95;
               BEGIN
                 IF GETFILTER("Budget Name") = '' THEN
                   GLBudgetName.INIT
                 ELSE BEGIN
                   COPYFILTER("Budget Name",GLBudgetName.Name);
                   GLBudgetName.FINDFIRST;
                 END;
                 CurrPage.EDITABLE := NOT GLBudgetName.Blocked AND IsEditable;
                 GLSetup.GET;
                 GlobalDimension1CodeEnable := GLSetup."Global Dimension 1 Code" <> '';
                 GlobalDimension2CodeEnable := GLSetup."Global Dimension 2 Code" <> '';
                 BudgetDimension1CodeEnable := GLBudgetName."Budget Dimension 1 Code" <> '';
                 BudgetDimension2CodeEnable := GLBudgetName."Budget Dimension 2 Code" <> '';
                 BudgetDimension3CodeEnable := GLBudgetName."Budget Dimension 3 Code" <> '';
                 BudgetDimension4CodeEnable := GLBudgetName."Budget Dimension 4 Code" <> '';
                 GlobalDimension1CodeVisible := GLSetup."Global Dimension 1 Code" <> '';
                 GlobalDimension2CodeVisible := GLSetup."Global Dimension 2 Code" <> '';
                 BudgetDimension1CodeVisible := GLBudgetName."Budget Dimension 1 Code" <> '';
                 BudgetDimension2CodeVisible := GLBudgetName."Budget Dimension 2 Code" <> '';
                 BudgetDimension3CodeVisible := GLBudgetName."Budget Dimension 3 Code" <> '';
                 BudgetDimension4CodeVisible := GLBudgetName."Budget Dimension 4 Code" <> '';
               END;

    OnClosePage=VAR
                  UpdateAnalysisView@1000 : Codeunit 410;
                BEGIN
                  IF LowestModifiedEntryNo < 2147483647 THEN
                    UpdateAnalysisView.SetLastBudgetEntryNo(LowestModifiedEntryNo - 1);
                END;

    OnNewRecord=BEGIN
                  IF GETFILTER("Budget Name") <> '' THEN
                    "Budget Name" := GETRANGEMIN("Budget Name");
                  IF GLBudgetName.Name <> "Budget Name" THEN
                    GLBudgetName.GET("Budget Name");
                  IF GETFILTER("G/L Account No.") <> '' THEN
                    "G/L Account No." := GetFirstGLAcc(GETFILTER("G/L Account No."));
                  Date := GetFirstDate(GETFILTER(Date));
                  "User ID" := USERID;

                  IF GETFILTER("Global Dimension 1 Code") <> '' THEN
                    "Global Dimension 1 Code" :=
                      GetFirstDimValue(GLSetup."Global Dimension 1 Code",GETFILTER("Global Dimension 1 Code"));

                  IF GETFILTER("Global Dimension 2 Code") <> '' THEN
                    "Global Dimension 2 Code" :=
                      GetFirstDimValue(GLSetup."Global Dimension 2 Code",GETFILTER("Global Dimension 2 Code"));

                  IF GETFILTER("Budget Dimension 1 Code") <> '' THEN
                    "Budget Dimension 1 Code" :=
                      GetFirstDimValue(GLBudgetName."Budget Dimension 1 Code",GETFILTER("Budget Dimension 1 Code"));

                  IF GETFILTER("Budget Dimension 2 Code") <> '' THEN
                    "Budget Dimension 2 Code" :=
                      GetFirstDimValue(GLBudgetName."Budget Dimension 2 Code",GETFILTER("Budget Dimension 2 Code"));

                  IF GETFILTER("Budget Dimension 3 Code") <> '' THEN
                    "Budget Dimension 3 Code" :=
                      GetFirstDimValue(GLBudgetName."Budget Dimension 3 Code",GETFILTER("Budget Dimension 3 Code"));

                  IF GETFILTER("Budget Dimension 4 Code") <> '' THEN
                    "Budget Dimension 4 Code" :=
                      GetFirstDimValue(GLBudgetName."Budget Dimension 4 Code",GETFILTER("Budget Dimension 4 Code"));

                  IF GETFILTER("Business Unit Code") <> '' THEN
                    "Business Unit Code" := GetFirstBusUnit(GETFILTER("Business Unit Code"));
                END;

    OnModifyRecord=BEGIN
                     IF "Entry No." < LowestModifiedEntryNo THEN
                       LowestModifiedEntryNo := "Entry No.";
                     EXIT(TRUE);
                   END;

    OnDeleteRecord=BEGIN
                     IF "Entry No." < LowestModifiedEntryNo THEN
                       LowestModifiedEntryNo := "Entry No.";
                     EXIT(IsEditable);
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 24      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsbilag for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr�ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Suite;
                      Image=Filter;
                      OnAction=BEGIN
                                 SETFILTER("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� det finansbudget, som posten er tilknyttet.;
                           ENU=Specifies the name of the G/L budget that the entry belongs to.];
                ApplicationArea=#Suite;
                SourceExpr="Budget Name";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for budgetposten.;
                           ENU=Specifies the date of the budget entry.];
                ApplicationArea=#Suite;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den finanskonto, som budgetposten vedr�rer, eller den konto p� linjen, hvor budgettallet er indtastet.;
                           ENU=Specifies the number of the G/L account that the budget entry applies to, or, the account on the line where the budget figure has been entered.];
                ApplicationArea=#Suite;
                SourceExpr="G/L Account No." }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af budgettallet.;
                           ENU=Specifies a description of the budget figure.];
                ApplicationArea=#Suite;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code";
                Visible=GlobalDimension1CodeVisible;
                Enabled=GlobalDimension1CodeEnable }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=GlobalDimension2CodeVisible;
                Enabled=GlobalDimension2CodeEnable }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dimensionsv�rdikoden for koden Budgetdimension 1, som budgetposten er tilknyttet.;
                           ENU=Specifies the dimension value code for the Budget Dimension 1 Code the budget entry is linked to.];
                ApplicationArea=#Suite;
                SourceExpr="Budget Dimension 1 Code";
                Visible=BudgetDimension1CodeVisible;
                Enabled=BudgetDimension1CodeEnable }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dimensionsv�rdikoden for koden Budgetdimension 2, som budgetposten er tilknyttet.;
                           ENU=Specifies the dimension value code for the Budget Dimension 2 Code the budget entry is linked to.];
                ApplicationArea=#Suite;
                SourceExpr="Budget Dimension 2 Code";
                Visible=BudgetDimension2CodeVisible;
                Enabled=BudgetDimension2CodeEnable }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dimensionsv�rdikoden for koden Budgetdimension 3, som budgetposten er tilknyttet.;
                           ENU=Specifies the dimension value code for the Budget Dimension 3 Code the budget entry is linked to.];
                ApplicationArea=#Suite;
                SourceExpr="Budget Dimension 3 Code";
                Visible=BudgetDimension3CodeVisible;
                Enabled=BudgetDimension3CodeEnable }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dimensionsv�rdikoden for koden Budgetdimension 4, som budgetposten er tilknyttet.;
                           ENU=Specifies the dimension value code for the Budget Dimension 4 Code the budget entry is linked to.];
                ApplicationArea=#Suite;
                SourceExpr="Budget Dimension 4 Code";
                Visible=BudgetDimension4CodeVisible;
                Enabled=BudgetDimension4CodeEnable }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den koncernvirksomhedskode, som budgetposten er tilknyttet.;
                           ENU=Specifies the code for the business unit that the budget entry is linked to.];
                ApplicationArea=#Advanced;
                SourceExpr="Business Unit Code";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel�bet for budgetposten.;
                           ENU=Specifies the amount of the budget entry.];
                ApplicationArea=#Suite;
                SourceExpr=Amount }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Suite;
                SourceExpr="Entry No.";
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv�rdier. De faktiske v�rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Suite;
                SourceExpr="Dimension Set ID";
                Visible=FALSE }

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
    VAR
      GLSetup@1000 : Record 98;
      GLBudgetName@1001 : Record 95;
      DimensionSetIDFilter@1002 : Page 481;
      LowestModifiedEntryNo@1004 : Integer;
      GlobalDimension1CodeVisible@19028123 : Boolean INDATASET;
      GlobalDimension2CodeVisible@19054752 : Boolean INDATASET;
      BudgetDimension1CodeVisible@19036733 : Boolean INDATASET;
      BudgetDimension2CodeVisible@19019212 : Boolean INDATASET;
      BudgetDimension3CodeVisible@19014779 : Boolean INDATASET;
      BudgetDimension4CodeVisible@19001818 : Boolean INDATASET;
      GlobalDimension1CodeEnable@19057401 : Boolean INDATASET;
      GlobalDimension2CodeEnable@19039220 : Boolean INDATASET;
      BudgetDimension1CodeEnable@19069571 : Boolean INDATASET;
      BudgetDimension2CodeEnable@19071456 : Boolean INDATASET;
      BudgetDimension3CodeEnable@19074873 : Boolean INDATASET;
      BudgetDimension4CodeEnable@19060014 : Boolean INDATASET;
      IsEditable@1003 : Boolean;

    LOCAL PROCEDURE GetFirstGLAcc@3(GLAccFilter@1000 : Text[250]) : Code[20];
    VAR
      GLAcc@1001 : Record 15;
    BEGIN
      WITH GLAcc DO BEGIN
        SETFILTER("No.",GLAccFilter);
        IF FINDFIRST THEN
          EXIT("No.");

        EXIT('');
      END;
    END;

    LOCAL PROCEDURE GetFirstDate@1(DateFilter@1001 : Text[250]) : Date;
    VAR
      Period@1002 : Record 2000000007;
    BEGIN
      IF DateFilter = '' THEN
        EXIT(0D);
      WITH Period DO BEGIN
        SETRANGE("Period Type","Period Type"::Date);
        SETFILTER("Period Start",DateFilter);
        IF FINDFIRST THEN
          EXIT("Period Start");

        EXIT(0D);
      END;
    END;

    LOCAL PROCEDURE GetFirstDimValue@2(DimCode@1000 : Code[20];DimValFilter@1001 : Text[250]) : Code[20];
    VAR
      DimVal@1002 : Record 349;
    BEGIN
      IF (DimCode = '') OR (DimValFilter = '') THEN
        EXIT('');
      WITH DimVal DO BEGIN
        SETRANGE("Dimension Code",DimCode);
        SETFILTER(Code,DimValFilter);
        IF FINDFIRST THEN
          EXIT(Code);

        EXIT('');
      END;
    END;

    LOCAL PROCEDURE GetFirstBusUnit@5(BusUnitFilter@1000 : Text[250]) : Code[20];
    VAR
      BusUnit@1001 : Record 220;
    BEGIN
      WITH BusUnit DO BEGIN
        SETFILTER(Code,BusUnitFilter);
        IF FINDFIRST THEN
          EXIT(Code);

        EXIT('');
      END;
    END;

    PROCEDURE SetEditable@6(NewIsEditable@1000 : Boolean);
    BEGIN
      IsEditable := NewIsEditable;
    END;

    BEGIN
    END.
  }
}

