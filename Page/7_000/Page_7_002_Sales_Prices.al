OBJECT Page 7002 Sales Prices
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salgspriser;
               ENU=Sales Prices];
    SaveValues=Yes;
    SourceTable=Table7002;
    DataCaptionExpr=GetCaption;
    DelayedInsert=Yes;
    PageType=List;
    ShowFilter=No;
    OnInit=BEGIN
             SalesCodeFilterCtrlEnable := TRUE;
             SalesCodeControlEditable := TRUE;
             IsLookupMode := CurrPage.LOOKUPMODE;
           END;

    OnOpenPage=BEGIN
                 IsOnMobile := ClientTypeManagement.GetCurrentClientType = CLIENTTYPE::Phone;
                 GetRecFilters;
                 SetRecFilters;
               END;

    OnAfterGetCurrRecord=BEGIN
                           SalesCodeControlEditable := SetSalesCodeEditable("Sales Type");
                         END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      Name=Filtering;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;Action    ;
                      Name=Filter;
                      CaptionML=[DAN=Filter;
                                 ENU=Filter];
                      ToolTipML=[DAN=Anvend filteret.;
                                 ENU=Apply the filter.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsOnMobile;
                      Image=Filter;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 FilterLines;
                               END;
                                }
      { 7       ;1   ;Action    ;
                      Name=ClearFilter;
                      CaptionML=[DAN=Ryd filter;
                                 ENU=Clear Filter];
                      ToolTipML=[DAN=Ryd filter.;
                                 ENU=Clear filter.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Visible=IsOnMobile;
                      Image=ClearFilter;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 RESET;
                                 UpdateBasicRecFilters;
                                 EVALUATE(StartingDateFilter,GETFILTER("Starting Date"));
                                 SetEditableFields;
                               END;
                                }
      { 48      ;1   ;Action    ;
                      Name=CopyPrices;
                      CaptionML=[DAN=Kopi�r priser;
                                 ENU=Copy Prices];
                      ToolTipML=[DAN=V�lg priser, og tryk p� OK for at kopiere dem til Debitornr.;
                                 ENU=Select prices and press OK to copy them to Customer No.];
                      ApplicationArea=#Basic,#Suite;
                      Visible=NOT IsLookupMode;
                      Image=Copy;
                      OnAction=BEGIN
                                 CopyPrices;
                                 CurrPage.UPDATE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 20  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                Visible=NOT IsOnMobile }

    { 28  ;2   ;Field     ;
                CaptionML=[DAN=Salgstypefilter;
                           ENU=Sales Type Filter];
                ToolTipML=[DAN=Angiver et filter for de salgspriser, der vises.;
                           ENU=Specifies a filter for which sales prices to display.];
                OptionCaptionML=[DAN=Debitor,Debitorprisgruppe,Alle debitorer,Kampagne,Ingen;
                                 ENU=Customer,Customer Price Group,All Customers,Campaign,None];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SalesTypeFilter;
                OnValidate=BEGIN
                             SalesTypeFilterOnAfterValidate;
                           END;
                            }

    { 26  ;2   ;Field     ;
                Name=SalesCodeFilterCtrl;
                CaptionML=[DAN=Salgskodefilter;
                           ENU=Sales Code Filter];
                ToolTipML=[DAN=Angiver et filter for de salgspriser, der vises.;
                           ENU=Specifies a filter for which sales prices to display.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SalesCodeFilter;
                Enabled=SalesCodeFilterCtrlEnable;
                OnValidate=BEGIN
                             SalesCodeFilterOnAfterValidate;
                           END;

                OnLookup=VAR
                           CustList@1005 : Page 22;
                           CustPriceGrList@1004 : Page 7;
                           CampaignList@1002 : Page 5087;
                         BEGIN
                           IF SalesTypeFilter = SalesTypeFilter::"All Customers" THEN
                             EXIT;

                           CASE SalesTypeFilter OF
                             SalesTypeFilter::Customer:
                               BEGIN
                                 CustList.LOOKUPMODE := TRUE;
                                 IF CustList.RUNMODAL = ACTION::LookupOK THEN
                                   Text := CustList.GetSelectionFilter
                                 ELSE
                                   EXIT(FALSE);
                               END;
                             SalesTypeFilter::"Customer Price Group":
                               BEGIN
                                 CustPriceGrList.LOOKUPMODE := TRUE;
                                 IF CustPriceGrList.RUNMODAL = ACTION::LookupOK THEN
                                   Text := CustPriceGrList.GetSelectionFilter
                                 ELSE
                                   EXIT(FALSE);
                               END;
                             SalesTypeFilter::Campaign:
                               BEGIN
                                 CampaignList.LOOKUPMODE := TRUE;
                                 IF CampaignList.RUNMODAL = ACTION::LookupOK THEN
                                   Text := CampaignList.GetSelectionFilter
                                 ELSE
                                   EXIT(FALSE);
                               END;
                           END;

                           EXIT(TRUE);
                         END;
                          }

    { 10  ;2   ;Field     ;
                Name=ItemNoFilterCtrl;
                CaptionML=[DAN=Varenummerfilter;
                           ENU=Item No. Filter];
                ToolTipML=[DAN=Angiver et filter for de salgspriser, der vises.;
                           ENU=Specifies a filter for which sales prices to display.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ItemNoFilter;
                OnValidate=BEGIN
                             ItemNoFilterOnAfterValidate;
                           END;

                OnLookup=VAR
                           ItemList@1002 : Page 31;
                         BEGIN
                           ItemList.LOOKUPMODE := TRUE;
                           IF ItemList.RUNMODAL = ACTION::LookupOK THEN
                             Text := ItemList.GetSelectionFilter
                           ELSE
                             EXIT(FALSE);

                           EXIT(TRUE);
                         END;
                          }

    { 34  ;2   ;Field     ;
                CaptionML=[DAN=Startdatofilter;
                           ENU=Starting Date Filter];
                ToolTipML=[DAN=Angiver et filter for de salgspriser, der vises.;
                           ENU=Specifies a filter for which sales prices to display.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=StartingDateFilter;
                OnValidate=VAR
                             ApplicationMgt@1030 : Codeunit 1;
                           BEGIN
                             IF ApplicationMgt.MakeDateFilter(StartingDateFilter) = 0 THEN;
                             StartingDateFilterOnAfterValid;
                           END;
                            }

    { 38  ;2   ;Field     ;
                Name=SalesCodeFilterCtrl2;
                CaptionML=[DAN=Valutakodefilter;
                           ENU=Currency Code Filter];
                ToolTipML=[DAN=Angiver et filter for de salgspriser, der vises.;
                           ENU=Specifies a filter for which sales prices to display.];
                ApplicationArea=#Suite;
                SourceExpr=CurrencyCodeFilter;
                OnValidate=BEGIN
                             CurrencyCodeFilterOnAfterValid;
                           END;

                OnLookup=VAR
                           CurrencyList@1000 : Page 5;
                         BEGIN
                           CurrencyList.LOOKUPMODE := TRUE;
                           IF CurrencyList.RUNMODAL = ACTION::LookupOK THEN
                             Text := CurrencyList.GetSelectionFilter
                           ELSE
                             EXIT(FALSE);

                           EXIT(TRUE);
                         END;
                          }

    { 9   ;1   ;Group     ;
                CaptionML=[DAN=Filtre;
                           ENU=Filters];
                Visible=IsOnMobile;
                GroupType=Group }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et filter for de salgspriser, der vises.;
                           ENU=Specifies a filter for which sales prices to display.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=GetFilterDescription;
                Editable=FALSE;
                OnAssistEdit=BEGIN
                               FilterLines;
                               CurrPage.UPDATE(FALSE);
                             END;
                              }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den salgspristype, som definerer, om prisen er for et individ, en gruppe, alle debitorer eller en kampagne.;
                           ENU=Specifies the sales price type, which defines whether the price is for an individual, group, all customers, or a campaign.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales Type";
                Editable=SalesTypeControlEditable;
                OnValidate=BEGIN
                             SalesCodeControlEditable := SetSalesCodeEditable("Sales Type");
                           END;
                            }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken kode der tilh�rer salgstypen.;
                           ENU=Specifies the code that belongs to the Sales Type.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales Code";
                Editable=SalesCodeControlEditable }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den vare, som salgsprisen g�lder for.;
                           ENU=Specifies the number of the item for which the sales price is valid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No.";
                Editable=ItemNoControlEditable }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p� linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for salgsprisens valuta.;
                           ENU=Specifies the code for the currency of the sales price.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code";
                Visible=FALSE;
                Editable=CurrencyCodeControlEditable }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det minimale salgsantal, der kr�ves for at garantere salgsprisen.;
                           ENU=Specifies the minimum sales quantity required to warrant the sales price.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Minimum Quantity" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for �n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f� den angivet i henhold til feltet Avancepct.beregning p� det dertilh�rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Price" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som salgsprisen er gyldig fra.;
                           ENU=Specifies the date from which the sales price is valid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Starting Date";
                Editable=StartingDateControlEditable }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kalenderdato, hvor salgsprisaftalen slutter.;
                           ENU=Specifies the calendar date when the sales price agreement ends.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ending Date" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om salgsprisen inkluderer moms.;
                           ENU=Specifies if the sales price includes VAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Price Includes VAT";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der beregnes linjerabat, n�r salgsprisen tilbydes.;
                           ENU=Specifies if a line discount will be calculated when the sales price is offered.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Line Disc.";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en fakturarabat beregnes, n�r salgsprisen tilbydes.;
                           ENU=Specifies if an invoice discount will be calculated when the sales price is offered.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsvirksomhedsbogf�ringsgruppen for debitorer, som salgsprisen skal anvendes p� (inklusive moms).;
                           ENU=Specifies the VAT business posting group for customers for whom you want the sales price (which includes VAT) to apply.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Gr. (Price)";
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
      Cust@1001 : Record 18;
      CustPriceGr@1005 : Record 6;
      Campaign@1008 : Record 5071;
      ClientTypeManagement@1077 : Codeunit 4;
      SalesTypeFilter@1000 : 'Customer,Customer Price Group,All Customers,Campaign,None';
      SalesCodeFilter@1003 : Text;
      ItemNoFilter@1011 : Text;
      StartingDateFilter@1006 : Text[30];
      CurrencyCodeFilter@1002 : Text;
      Text000@1007 : TextConst 'DAN=Alle debitorer;ENU=All Customers';
      Text001@1009 : TextConst 'DAN=Ingen %1 i filteret %2.;ENU=No %1 within the filter %2.';
      SalesCodeFilterCtrlEnable@19013164 : Boolean INDATASET;
      IsOnMobile@1004 : Boolean;
      IsLookupMode@1017 : Boolean;
      SalesTypeControlEditable@1012 : Boolean;
      SalesCodeControlEditable@1013 : Boolean;
      ItemNoControlEditable@1014 : Boolean;
      StartingDateControlEditable@1015 : Boolean;
      CurrencyCodeControlEditable@1016 : Boolean;
      MultipleCustomersSelectedErr@1018 : TextConst 'DAN=Mere end �n debitor bruger salgspriserne. Hvis du vil kopiere priser, m� feltet Salgskodefilter kun indeholde �n debitor.;ENU=More than one customer uses these sales prices. To copy prices, the Sales Code Filter field must contain one customer only.';
      IncorrectSalesTypeToCopyPricesErr@1010 : TextConst 'DAN=Hvis du vil kopiere salgspriser, skal feltet Salgstypefilter indeholde debitor.;ENU=To copy sales prices, The Sales Type Filter field must contain Customer.';

    LOCAL PROCEDURE GetRecFilters@2();
    BEGIN
      IF GETFILTERS <> '' THEN
        UpdateBasicRecFilters;

      EVALUATE(StartingDateFilter,GETFILTER("Starting Date"));
    END;

    LOCAL PROCEDURE UpdateBasicRecFilters@17();
    BEGIN
      IF GETFILTER("Sales Type") <> '' THEN
        SalesTypeFilter := GetSalesTypeFilter
      ELSE
        SalesTypeFilter := SalesTypeFilter::None;

      SalesCodeFilter := GETFILTER("Sales Code");
      ItemNoFilter := GETFILTER("Item No.");
      CurrencyCodeFilter := GETFILTER("Currency Code");
    END;

    [Internal]
    PROCEDURE SetRecFilters@1();
    BEGIN
      SalesCodeFilterCtrlEnable := TRUE;

      IF SalesTypeFilter <> SalesTypeFilter::None THEN
        SETRANGE("Sales Type",SalesTypeFilter)
      ELSE
        SETRANGE("Sales Type");

      IF SalesTypeFilter IN [SalesTypeFilter::"All Customers",SalesTypeFilter::None] THEN BEGIN
        SalesCodeFilterCtrlEnable := FALSE;
        SalesCodeFilter := '';
      END;

      IF SalesCodeFilter <> '' THEN
        SETFILTER("Sales Code",SalesCodeFilter)
      ELSE
        SETRANGE("Sales Code");

      IF StartingDateFilter <> '' THEN
        SETFILTER("Starting Date",StartingDateFilter)
      ELSE
        SETRANGE("Starting Date");

      IF ItemNoFilter <> '' THEN BEGIN
        SETFILTER("Item No.",ItemNoFilter);
      END ELSE
        SETRANGE("Item No.");

      IF CurrencyCodeFilter <> '' THEN BEGIN
        SETFILTER("Currency Code",CurrencyCodeFilter);
      END ELSE
        SETRANGE("Currency Code");

      CASE SalesTypeFilter OF
        SalesTypeFilter::Customer:
          CheckFilters(DATABASE::Customer,SalesCodeFilter);
        SalesTypeFilter::"Customer Price Group":
          CheckFilters(DATABASE::"Customer Price Group",SalesCodeFilter);
        SalesTypeFilter::Campaign:
          CheckFilters(DATABASE::Campaign,SalesCodeFilter);
      END;
      CheckFilters(DATABASE::Item,ItemNoFilter);
      CheckFilters(DATABASE::Currency,CurrencyCodeFilter);

      SetEditableFields;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE GetCaption@3() : Text;
    BEGIN
      IF IsOnMobile THEN
        EXIT('');

      EXIT(GetFilterDescription);
    END;

    LOCAL PROCEDURE GetFilterDescription@7() : Text;
    VAR
      ObjTranslation@1000 : Record 377;
      SourceTableName@1002 : Text;
      SalesSrcTableName@1003 : Text;
      Description@1001 : Text;
    BEGIN
      GetRecFilters;

      SourceTableName := '';
      IF ItemNoFilter <> '' THEN
        SourceTableName := ObjTranslation.TranslateObject(ObjTranslation."Object Type"::Table,27);

      SalesSrcTableName := '';
      CASE SalesTypeFilter OF
        SalesTypeFilter::Customer:
          BEGIN
            SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."Object Type"::Table,18);
            Cust."No." := COPYSTR(SalesCodeFilter,1,MAXSTRLEN(Cust."No."));
            IF Cust.FIND THEN
              Description := Cust.Name;
          END;
        SalesTypeFilter::"Customer Price Group":
          BEGIN
            SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."Object Type"::Table,6);
            CustPriceGr.Code := COPYSTR(SalesCodeFilter,1,MAXSTRLEN(CustPriceGr.Code));
            IF CustPriceGr.FIND THEN
              Description := CustPriceGr.Description;
          END;
        SalesTypeFilter::Campaign:
          BEGIN
            SalesSrcTableName := ObjTranslation.TranslateObject(ObjTranslation."Object Type"::Table,5071);
            Campaign."No." := COPYSTR(SalesCodeFilter,1,MAXSTRLEN(Campaign."No."));
            IF Campaign.FIND THEN
              Description := Campaign.Description;
          END;
        SalesTypeFilter::"All Customers":
          BEGIN
            SalesSrcTableName := Text000;
            Description := '';
          END;
      END;

      IF SalesSrcTableName = Text000 THEN
        EXIT(STRSUBSTNO('%1 %2 %3',SalesSrcTableName,SourceTableName,ItemNoFilter));
      EXIT(STRSUBSTNO('%1 %2 %3 %4 %5',SalesSrcTableName,SalesCodeFilter,Description,SourceTableName,ItemNoFilter));
    END;

    LOCAL PROCEDURE CheckFilters@4(TableNo@1000 : Integer;FilterTxt@1001 : Text);
    VAR
      FilterRecordRef@1002 : RecordRef;
      FilterFieldRef@1003 : FieldRef;
    BEGIN
      IF FilterTxt = '' THEN
        EXIT;
      CLEAR(FilterRecordRef);
      CLEAR(FilterFieldRef);
      FilterRecordRef.OPEN(TableNo);
      FilterFieldRef := FilterRecordRef.FIELD(1);
      FilterFieldRef.SETFILTER(FilterTxt);
      IF FilterRecordRef.ISEMPTY THEN
        ERROR(Text001,FilterRecordRef.CAPTION,FilterTxt);
    END;

    LOCAL PROCEDURE SalesCodeFilterOnAfterValidate@19067727();
    BEGIN
      CurrPage.SAVERECORD;
      SetRecFilters;
    END;

    LOCAL PROCEDURE SalesTypeFilterOnAfterValidate@19024044();
    BEGIN
      CurrPage.SAVERECORD;
      SalesCodeFilter := '';
      SetRecFilters;
    END;

    LOCAL PROCEDURE StartingDateFilterOnAfterValid@19055286();
    BEGIN
      CurrPage.SAVERECORD;
      SetRecFilters;
    END;

    LOCAL PROCEDURE ItemNoFilterOnAfterValidate@19009808();
    BEGIN
      CurrPage.SAVERECORD;
      SetRecFilters;
    END;

    LOCAL PROCEDURE CurrencyCodeFilterOnAfterValid@19015290();
    BEGIN
      CurrPage.SAVERECORD;
      SetRecFilters;
    END;

    LOCAL PROCEDURE GetSalesTypeFilter@1000() : Integer;
    BEGIN
      CASE GETFILTER("Sales Type") OF
        FORMAT("Sales Type"::Customer):
          EXIT(0);
        FORMAT("Sales Type"::"Customer Price Group"):
          EXIT(1);
        FORMAT("Sales Type"::"All Customers"):
          EXIT(2);
        FORMAT("Sales Type"::Campaign):
          EXIT(3);
      END;
    END;

    LOCAL PROCEDURE SetSalesCodeEditable@5(SalesType@1000 : Option) : Boolean;
    BEGIN
      EXIT(SalesType <> "Sales Type"::"All Customers");
    END;

    LOCAL PROCEDURE SetEditableFields@10();
    BEGIN
      SalesTypeControlEditable := GETFILTER("Sales Type") = '';
      SalesCodeControlEditable :=
        SalesCodeControlEditable AND (GETFILTER("Sales Code") = '');
      ItemNoControlEditable := GETFILTER("Item No.") = '';
      StartingDateControlEditable := GETFILTER("Starting Date") = '';
      CurrencyCodeControlEditable := GETFILTER("Currency Code") = '';
    END;

    LOCAL PROCEDURE FilterLines@6();
    VAR
      FilterPageBuilder@1000 : FilterPageBuilder;
    BEGIN
      FilterPageBuilder.ADDTABLE(TABLECAPTION,DATABASE::"Sales Price");

      FilterPageBuilder.SETVIEW(TABLECAPTION,GETVIEW);
      IF GETFILTER("Sales Type") = '' THEN
        FilterPageBuilder.ADDFIELDNO(TABLECAPTION,FIELDNO("Sales Type"));
      IF GETFILTER("Sales Code") = '' THEN
        FilterPageBuilder.ADDFIELDNO(TABLECAPTION,FIELDNO("Sales Code"));
      IF GETFILTER("Item No.") = '' THEN
        FilterPageBuilder.ADDFIELDNO(TABLECAPTION,FIELDNO("Item No."));
      IF GETFILTER("Starting Date") = '' THEN
        FilterPageBuilder.ADDFIELDNO(TABLECAPTION,FIELDNO("Starting Date"));
      IF GETFILTER("Currency Code") = '' THEN
        FilterPageBuilder.ADDFIELDNO(TABLECAPTION,FIELDNO("Currency Code"));

      IF FilterPageBuilder.RUNMODAL THEN
        SETVIEW(FilterPageBuilder.GETVIEW(TABLECAPTION));

      UpdateBasicRecFilters;
      EVALUATE(StartingDateFilter,GETFILTER("Starting Date"));
      SetEditableFields;
    END;

    LOCAL PROCEDURE CopyPrices@8();
    VAR
      Customer@1001 : Record 18;
      SalesPrice@1004 : Record 7002;
      SelectedSalesPrice@1005 : Record 7002;
      SalesPrices@1002 : Page 7002;
      CopyToCustomerNo@1003 : Code[20];
    BEGIN
      IF SalesTypeFilter <> SalesTypeFilter::Customer THEN
        ERROR(IncorrectSalesTypeToCopyPricesErr);
      Customer.SETFILTER("No.",SalesCodeFilter);
      IF Customer.COUNT <> 1 THEN
        ERROR(MultipleCustomersSelectedErr);
      CopyToCustomerNo := COPYSTR(SalesCodeFilter,1,MAXSTRLEN(CopyToCustomerNo));
      SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::Customer);
      SalesPrice.SETFILTER("Sales Code",'<>%1',SalesCodeFilter);
      SalesPrices.LOOKUPMODE(TRUE);
      SalesPrices.SETTABLEVIEW(SalesPrice);
      IF SalesPrices.RUNMODAL = ACTION::LookupOK THEN BEGIN
        SalesPrices.GetSelectionFilter(SelectedSalesPrice);
        CopySalesPriceToCustomersSalesPrice(SelectedSalesPrice,CopyToCustomerNo);
      END;
    END;

    PROCEDURE GetSelectionFilter@9(VAR SalesPrice@1000 : Record 7002);
    BEGIN
      CurrPage.SETSELECTIONFILTER(SalesPrice);
    END;

    BEGIN
    END.
  }
}

