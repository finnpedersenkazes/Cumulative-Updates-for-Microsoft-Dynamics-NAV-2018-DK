OBJECT Page 1259 Bank Name - Data Conv. List
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
    CaptionML=[DAN=Banknavn - datakonverteringsoversigt;
               ENU=Bank Name - Data Conv. List];
    SourceTable=Table1259;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Side,Ops�tning;
                                ENU=New,Process,Page,Setup];
    OnInit=BEGIN
             ShortTimeout := 5000;
             LongTimeout := 30000;
           END;

    OnOpenPage=VAR
                 ImpBankListExtDataHndl@1000 : Codeunit 1289;
                 CountryRegionCode@1004 : Text;
                 HideErrors@1003 : Boolean;
               BEGIN
                 CountryRegionCode := IdentifyCountryRegionCode(Rec,GETFILTER("Country/Region Code"));

                 IF ISEMPTY THEN BEGIN
                   ImpBankListExtDataHndl.GetBankListFromConversionService(HideErrors,CountryRegionCode,ShortTimeout);
                   EXIT;
                 END;

                 RefreshBankNamesOlderThanToday(CountryRegionCode,HideErrors,ShortTimeout);
               END;

    ActionList=ACTIONS
    {
      { 7       ;    ;ActionContainer;
                      Name=Action;
                      CaptionML=[DAN=Installation;
                                 ENU=Setup];
                      ActionContainerType=ActionItems }
      { 6       ;1   ;Action    ;
                      Name=UpdateBankList;
                      ShortCutKey=Ctrl+F5;
                      CaptionML=[DAN=Opdater liste over banknavne;
                                 ENU=Update Bank Name List];
                      ToolTipML=[DAN=Opdater banklisten med alle nye banker i dit land/omr�de.;
                                 ENU=Update the bank list with any new banks in your country/region.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Restore;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 ImpBankListExtDataHndl@1000 : Codeunit 1289;
                                 FilterNotUsed@1001 : Text;
                                 ShowErrors@1003 : Boolean;
                               BEGIN
                                 ShowErrors := TRUE;
                                 ImpBankListExtDataHndl.GetBankListFromConversionService(ShowErrors,FilterNotUsed,LongTimeout);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den bank og eventuelt dets lande/omr�dekode, som underst�tter ops�tningen for import eller eksport af bankdata ved hj�lp af tjenesten til konvertering af bankdata.;
                           ENU=Specifies the name of the bank, and potentially its country/region code, that supports your setup for import/export of bank data using the Bank Data Conversion Service feature.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Bank }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den bank, der underst�tter ops�tningen for import eller eksport af bankdata ved hj�lp af tjenesten til konvertering af bankdata.;
                           ENU=Specifies the name of the bank that supports your setup for import/export of bank data using the Bank Data Conversion Service feature.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Bank Name" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressens land/omr�de.;
                           ENU=Specifies the country/region of the address.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Country/Region Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det seneste tidspunkt, hvor listen over underst�ttede banker blev opdateret.;
                           ENU=Specifies the last time the list of supported banks was updated.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Update Date" }

  }
  CODE
  {
    VAR
      LongTimeout@1003 : Integer;
      ShortTimeout@1001 : Integer;

    LOCAL PROCEDURE IdentifyCountryRegionCode@1(VAR BankDataConvBank@1002 : Record 1259;Filter@1000 : Text) : Text;
    VAR
      CompanyInformation@1001 : Record 79;
      BlankFilter@1003 : Text;
    BEGIN
      BlankFilter := '''''';

      IF Filter = BlankFilter THEN BEGIN
        CompanyInformation.GET;
        BankDataConvBank.SETFILTER("Country/Region Code",CompanyInformation."Country/Region Code");
        EXIT(BankDataConvBank.GETFILTER("Country/Region Code"));
      END;

      EXIT(Filter);
    END;

    LOCAL PROCEDURE RefreshBankNamesOlderThanToday@5(CountryRegionCode@1000 : Text;ShowErrors@1002 : Boolean;Timeout@1004 : Integer);
    VAR
      BankDataConvBank@1001 : Record 1259;
      ImpBankListExtDataHndl@1003 : Codeunit 1289;
    BEGIN
      IF CountryRegionCode <> '' THEN
        BankDataConvBank.SETFILTER("Country/Region Code",CountryRegionCode);
      BankDataConvBank.SETFILTER("Last Update Date",'<%1',TODAY);
      IF BankDataConvBank.FINDFIRST THEN
        ImpBankListExtDataHndl.GetBankListFromConversionService(ShowErrors,CountryRegionCode,Timeout);
    END;

    BEGIN
    END.
  }
}

