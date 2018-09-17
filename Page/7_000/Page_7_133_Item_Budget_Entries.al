OBJECT Page 7133 Item Budget Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varebudgetposter;
               ENU=Item Budget Entries];
    SourceTable=Table7134;
    DataCaptionExpr=GetCaption;
    DelayedInsert=Yes;
    PageType=List;
    OnInit=BEGIN
             BudgetDimension3CodeEnable := TRUE;
             BudgetDimension2CodeEnable := TRUE;
             BudgetDimension1CodeEnable := TRUE;
             GlobalDimension2CodeEnable := TRUE;
             GlobalDimension1CodeEnable := TRUE;
             BudgetDimension3CodeVisible := TRUE;
             BudgetDimension2CodeVisible := TRUE;
             BudgetDimension1CodeVisible := TRUE;
             GlobalDimension2CodeVisible := TRUE;
             GlobalDimension1CodeVisible := TRUE;
             LowestModifiedEntryNo := 2147483647;
           END;

    OnOpenPage=BEGIN
                 IF GETFILTER("Budget Name") = '' THEN
                   ItemBudgetName.INIT
                 ELSE BEGIN
                   COPYFILTER("Analysis Area",ItemBudgetName."Analysis Area");
                   COPYFILTER("Budget Name",ItemBudgetName.Name);
                   ItemBudgetName.FINDFIRST;
                 END;
                 CurrPage.EDITABLE := NOT ItemBudgetName.Blocked;
                 GLSetup.GET;
                 GlobalDimension1CodeEnable := GLSetup."Global Dimension 1 Code" <> '';
                 GlobalDimension2CodeEnable := GLSetup."Global Dimension 2 Code" <> '';
                 BudgetDimension1CodeEnable := ItemBudgetName."Budget Dimension 1 Code" <> '';
                 BudgetDimension2CodeEnable := ItemBudgetName."Budget Dimension 2 Code" <> '';
                 BudgetDimension3CodeEnable := ItemBudgetName."Budget Dimension 3 Code" <> '';
                 GlobalDimension1CodeVisible := GLSetup."Global Dimension 1 Code" <> '';
                 GlobalDimension2CodeVisible := GLSetup."Global Dimension 2 Code" <> '';
                 BudgetDimension1CodeVisible := ItemBudgetName."Budget Dimension 1 Code" <> '';
                 BudgetDimension2CodeVisible := ItemBudgetName."Budget Dimension 2 Code" <> '';
                 BudgetDimension3CodeVisible := ItemBudgetName."Budget Dimension 3 Code" <> '';
               END;

    OnClosePage=VAR
                  UpdateItemAnalysisView@1000 : Codeunit 7150;
                BEGIN
                  IF LowestModifiedEntryNo < 2147483647 THEN
                    UpdateItemAnalysisView.SetLastBudgetEntryNo(LowestModifiedEntryNo - 1);
                END;

    OnNewRecord=BEGIN
                  "Budget Name" := GETRANGEMIN("Budget Name");
                  "Analysis Area" := GETRANGEMIN("Analysis Area");
                  IF (ItemBudgetName.Name <> "Budget Name") OR (ItemBudgetName."Analysis Area" <> "Analysis Area") THEN
                    ItemBudgetName.GET("Analysis Area","Budget Name");
                  IF GETFILTER("Item No.") <> '' THEN
                    "Item No." := GetFirstItem(GETFILTER("Item No."));
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
                      GetFirstDimValue(ItemBudgetName."Budget Dimension 1 Code",GETFILTER("Budget Dimension 1 Code"));

                  IF GETFILTER("Budget Dimension 2 Code") <> '' THEN
                    "Budget Dimension 2 Code" :=
                      GetFirstDimValue(ItemBudgetName."Budget Dimension 2 Code",GETFILTER("Budget Dimension 2 Code"));

                  IF GETFILTER("Budget Dimension 3 Code") <> '' THEN
                    "Budget Dimension 3 Code" :=
                      GetFirstDimValue(ItemBudgetName."Budget Dimension 3 Code",GETFILTER("Budget Dimension 3 Code"));

                  IF GETFILTER("Location Code") <> '' THEN
                    "Location Code" := GetFirstLocationCode(GETFILTER("Location Code"));
                END;

    OnModifyRecord=BEGIN
                     IF "Entry No." < LowestModifiedEntryNo THEN
                       LowestModifiedEntryNo := "Entry No.";
                     EXIT(TRUE);
                   END;

    OnDeleteRecord=BEGIN
                     IF "Entry No." < LowestModifiedEntryNo THEN
                       LowestModifiedEntryNo := "Entry No.";
                     EXIT(TRUE);
                   END;

    OnAfterGetCurrRecord=BEGIN
                           IF "Entry No." <> 0 THEN
                             IF "Dimension Set ID" <> xRec."Dimension Set ID" THEN
                               LowestModifiedEntryNo := "Entry No.";
                         END;

    ActionList=ACTIONS
    {
      { 7       ;    ;ActionContainer;
                      Name=<Action1900000003>;
                      ActionContainerType=RelatedInformation }
      { 5       ;1   ;ActionGroup;
                      Name=<Action23>;
                      CaptionML=[DAN=&Post;
                                 ENU=Ent&ry];
                      Image=Entry }
      { 3       ;2   ;Action    ;
                      Name=<Action24>;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=SetDimensionFilter;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Angiv dimensionsfilter;
                                 ENU=Set Dimension Filter];
                      ToolTipML=[DAN=Begr�ns posterne i overensstemmelse med dimensionsfiltre, som du angiver.;
                                 ENU=Limit the entries according to dimension filters that you specify.];
                      ApplicationArea=#Dimensions;
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
                ToolTipML=[DAN=Angiver navnet p� det varebudget, som posten h�rer til.;
                           ENU=Specifies the name of the item budget that the entry belongs to.];
                ApplicationArea=#ItemBudget;
                SourceExpr="Budget Name";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for varebudgetposten.;
                           ENU=Specifies the date of this item budget entry.];
                ApplicationArea=#ItemBudget;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den vare, som budgetposten g�lder for.;
                           ENU=Specifies the number of the item that this budget entry applies to.];
                ApplicationArea=#ItemBudget;
                SourceExpr="Item No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af budgettallet.;
                           ENU=Specifies a description of the budget figure.];
                ApplicationArea=#ItemBudget;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kildetypen for budgetposten.;
                           ENU=Specifies the source type of this budget entry.];
                ApplicationArea=#ItemBudget;
                SourceExpr="Source Type" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#ItemBudget;
                SourceExpr="Source No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 1 Code";
                Visible=GlobalDimension1CodeVisible;
                Enabled=GlobalDimension1CodeEnable }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p� analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg�ngelige p� alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Dimensions;
                SourceExpr="Global Dimension 2 Code";
                Visible=GlobalDimension2CodeVisible;
                Enabled=GlobalDimension2CodeEnable }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dimensionsv�rdikoden for den Budgetdimension 1-kode, som varebudgetposten er tilknyttet.;
                           ENU=Specifies the dimension value code for the Budget Dimension 1 code that this item budget entry is linked to.];
                ApplicationArea=#Dimensions;
                SourceExpr="Budget Dimension 1 Code";
                Visible=BudgetDimension1CodeVisible;
                Enabled=BudgetDimension1CodeEnable }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dimensionsv�rdikoden for den Budgetdimension 2-kode, som varebudgetposten er tilknyttet.;
                           ENU=Specifies the dimension value code for the Budget Dimension 2 code that this item budget entry is linked to.];
                ApplicationArea=#Dimensions;
                SourceExpr="Budget Dimension 2 Code";
                Visible=BudgetDimension2CodeVisible;
                Enabled=BudgetDimension2CodeEnable }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dimensionsv�rdikoden for den Budgetdimension 3-kode, som varebudgetposten er tilknyttet.;
                           ENU=Specifies the dimension value code for the Budget Dimension 3 Code that this item budget entry is linked to.];
                ApplicationArea=#Dimensions;
                SourceExpr="Budget Dimension 3 Code";
                Visible=BudgetDimension3CodeVisible;
                Enabled=BudgetDimension3CodeEnable }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokationskode, som varebudgetposten er tilknyttet.;
                           ENU=Specifies the code for the location that this item budget entry is linked to.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet for varebudgetposten.;
                           ENU=Specifies the quantity of this item budget entry.];
                ApplicationArea=#ItemBudget;
                SourceExpr=Quantity }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbel�bet for varebudgetposten.;
                           ENU=Specifies the cost amount of this item budget entry.];
                ApplicationArea=#ItemBudget;
                SourceExpr="Cost Amount" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgsbel�bet for varebudgetlinjeposten.;
                           ENU=Specifies the sales amount of this item budget line entry.];
                ApplicationArea=#ItemBudget;
                SourceExpr="Sales Amount" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#ItemBudget;
                SourceExpr="Entry No.";
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver a reference til en kombination af dimensionsv�rdier. De faktiske v�rdier gemmes i tabellen Dimensionsgruppepost.;
                           ENU=Specifies a reference to a combination of dimension values. The actual values are stored in the Dimension Set Entry table.];
                ApplicationArea=#Dimensions;
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
      GLSetup@1004 : Record 98;
      ItemBudgetName@1003 : Record 7132;
      DimensionSetIDFilter@1001 : Page 481;
      LowestModifiedEntryNo@1000 : Integer;
      GlobalDimension1CodeVisible@19028123 : Boolean INDATASET;
      GlobalDimension2CodeVisible@19054752 : Boolean INDATASET;
      BudgetDimension1CodeVisible@19036733 : Boolean INDATASET;
      BudgetDimension2CodeVisible@19019212 : Boolean INDATASET;
      BudgetDimension3CodeVisible@19014779 : Boolean INDATASET;
      GlobalDimension1CodeEnable@19057401 : Boolean INDATASET;
      GlobalDimension2CodeEnable@19039220 : Boolean INDATASET;
      BudgetDimension1CodeEnable@19069571 : Boolean INDATASET;
      BudgetDimension2CodeEnable@19071456 : Boolean INDATASET;
      BudgetDimension3CodeEnable@19074873 : Boolean INDATASET;

    LOCAL PROCEDURE GetFirstItem@3(ItemFilter@1000 : Text[250]) : Code[20];
    VAR
      Item@1001 : Record 27;
    BEGIN
      WITH Item DO BEGIN
        SETFILTER("No.",ItemFilter);
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

    LOCAL PROCEDURE GetFirstLocationCode@5(LocationCodetFilter@1000 : Text[250]) : Code[10];
    VAR
      Location@1001 : Record 14;
    BEGIN
      WITH Location DO BEGIN
        SETFILTER(Code,LocationCodetFilter);
        IF FINDFIRST THEN
          EXIT(Code);

        EXIT('');
      END;
    END;

    BEGIN
    END.
  }
}

